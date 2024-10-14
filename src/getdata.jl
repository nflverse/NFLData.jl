module getdata
using Scratch
using Preferences
using DataFrames
using Parquet2
using HTTP
using Downloads
using CSV
using Dates
import Base: UUID

export cache_data_pref, clear_cache, from_url

PKG_UUID = UUID("38e18452-fdda-4cae-b91e-088906595f57")

"""
    cache_data_pref(pref::Bool)

Set user preference to use data caching with NFLData.jl.
"""
function cache_data_pref(pref::Bool)
    @set_preferences!("cache" => pref)
end

"""
    clear_cache()

Clear the NFLData.jl scratch space.
"""
function clear_cache()
    path = scratch_dir(string(PKG_UUID), "NFLData_cache/")
    rm(path; force=true, recursive=true)
    mkpath(path)
    global download_cache = path;
end

const cache_data = @load_preference("cache", true)

download_cache = ""

"Initialize NFLData.jl with startup messages and caching."
function __init__()
#=     printstyled("By default, NFLData.jl caches data for up to 24 hours.\n", color = :blue)
    printstyled("To disable this caching, run `cache_data_pref(false)` and restart Julia.\n", color = :blue)
    printstyled("To clear the cache, run `clear_cache()`.\n", color = :blue) =#
    # initialize cache
    path = scratch_dir(string(PKG_UUID), "NFLData_cache/");
    mkpath(path)
    # check for what files are in the cache and how old the oldest one is
    if length(readdir(path)) > 0
        oldest_file = unix2datetime(minimum([mtime(joinpath(path, file)) for file in readdir(path)]))
        # check how old the oldest file in the cache is
        time_since_last_cache = round(now() - oldest_file, Hour(1))
        # if it's been more than 24 hours, clear the cache
        if time_since_last_cache >= Hour(24)
            rm(path; force=true, recursive=true)
        end
    end
    global download_cache = path;
end

"Helper function for reading a .parquet file to a DataFrame (while ensuring the connection closes after the file is read)."
function parquet2df(file::AbstractString)
    open(file) do io
        ds = Parquet2.Dataset(io)
        df = DataFrame(ds)
        close(ds)
        return df
    end
end

"""
    from_url(url::AbstractString; file_type::AbstractString = ".parquet")

Reads a file from a URL and caches it. `file_type` can be one of `".parquet"`, `".csv"`, or `".csv.gz"`.
"""
function from_url(url::AbstractString; file_type::AbstractString = ".parquet")
    if !(file_type in [".parquet",".csv",".csv.gz"])
        throw(DomainError(file_type,"`file_type` must be one of either \".parquet\", \".csv\", or \".csv.gz\"."))
    end
    if cache_data
        fname = joinpath(download_cache, basename(url) * file_type)
        if !isfile(fname)
            Downloads.download(url * file_type, fname)
        end
        if file_type == ".parquet"
            df = parquet2df(fname)
        elseif file_type in [".csv",".csv.gz"]
            df = DataFrame(CSV.File(fname, stringtype = String))
        end
    else
        if file_type == ".parquet"
            res = HTTP.get(url * file_type)
            ds = Parquet2.Dataset(res.body)
            df = DataFrame(ds)
        elseif file_type in [".csv",".csv.gz"]
            df = DataFrame(CSV.File(fname, stringtype = String))
        end
    end 
    return df
end

"..."
function from_url(url::AbstractString, seasons::Int; file_type::AbstractString = ".parquet")
    if !(file_type in [".parquet",".csv",".csv.gz"])
        throw(DomainError(file_type,"`file_type` must be one of either \".parquet\", \".csv\", or \".csv.gz\"."))
    end
    if cache_data
        fname = joinpath(download_cache, basename(url) * string(seasons) * file_type)
        if !isfile(fname)
            Downloads.download(url * string(seasons) * file_type, fname)
        end
        if file_type == ".parquet"
            df = parquet2df(fname)
        elseif file_type in [".csv",".csv.gz"]
            df = DataFrame(CSV.File(fname, stringtype = String))
        end
    else
        if file_type == ".parquet"
            res = HTTP.get(url * string(seasons) *  ".parquet")
            ds = Parquet2.Dataset(res.body)
            df = DataFrame(ds)
        elseif file_type in [".csv",".csv.gz"]
            df = DataFrame(CSV.File(fname, stringtype = String))
        end
    end 
    return df
end

end