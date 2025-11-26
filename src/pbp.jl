module pbp

using DataFrames

include("helpers.jl")
using .helpers

include("getdata.jl")
using .getdata

include("gameinfo.jl")
using .gameinfo

export load_pbp, load_ftn_charting, load_participation

"""
    load_pbp(seasons = most_recent_season())

Load NFLFastR PBP data for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_pbp.html).
"""
function load_pbp(seasons = most_recent_season())
    seasons = check_years(seasons, 1999, "NFL PBP data")
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/pbp/play_by_play_",seasons))
    return df
end

"""
    load_ftn_charting(seasons = most_recent_season())

Load FTN charting data for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_ftn_charting.html).
"""
function load_ftn_charting(seasons = most_recent_season())
    seasons = check_years(seasons, 2022, "FTN charting data")
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/ftn_charting/ftn_charting_",seasons))
    return df
end

"""
    load_participation(seasons = 2023, include_pbp::Bool = false)

**NOTICE:** The NFL limited the amount of participation data available publicly for the 2023 season, and ceased providing any data for the 2024 season. The 2023 season lacks complete coverage, and the 2024 season and future seasons are unlikely to ever be updated with data.

Load NGS participation data for a given season. Defaults to the 2023 season. Pass in `seasons = true` for all available seasons. To join this participation data to PBP data (as provided by `load_pbp()`), pass `include_pbp=true` into this function.
    
For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_participation.html).
"""
function load_participation(seasons = 2023, include_pbp::Bool = false)
    seasons = check_years(seasons, 2016, "NFL participation data")
    if maximum(seasons) > 2023
        throw(DomainError(maximum(seasons),"The NFL has ceased to provide participation data for any games following the 2023 season."))
    end
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/pbp_participation/pbp_participation_",seasons), cols = :union)
    if include_pbp
        pbp = reduce(vcat, load_pbp.(seasons))
        df = select(df, Not([:old_game_id]))
        df = innerjoin(df, pbp, on = [:nflverse_game_id => :game_id, :play_id => :play_id])
    end
    return df
end

end