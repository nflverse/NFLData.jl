module helpers
using Dates

export check_years
export compute_labor_day

"Internal functon, test if a data is available for a given year."
function check_years(years_to_check, start_year, release, roster = false)
    most_rec_sea = 2024
    if years_to_check == true
        years_to_check = start_year:most_rec_sea
    end
    if minimum(years_to_check) < start_year
        throw(DomainError(minimum(years_to_check),"No $release available prior to $start_year\\!"))
    elseif minimum(years_to_check) > most_rec_sea
        throw(DomainError(minimum(years_to_check),"No $release available after $most_rec_sea!"))
    end
    if length(years_to_check) == 1
        years_to_check = [years_to_check]
    end
    return years_to_check
end

"Determine labor day of a given year, for use in determining the start of the NFL season."
function compute_labor_day(season::Int)
    earliest = Dates.firstdayofweek(Date(season,9,1))
    latest = Dates.firstdayofweek(Date(season,9,8))
    if(month(earliest) == 8)
        labor_day = latest
    else
        labor_day = earliest
    end
    return labor_day
end

"""
    nflverse_game_id(season::Number,week::Number,away::String,home::String)

Check and calculate an nflverse game ID.

# Examples
```julia-repl
julia> nflverse_game_id(2022, 2, "LAC", "KC")

    """
function nflverse_game_id(season::Number,week::Number,away::String,home::String)
    check_years(season, 1999, "NFLverse game ID")
    if (week > 22) | (week < 0)
        throw(DomainError(week,"`week` must be between 1 and 22!"))
    end

    #TODO valid_names <- names(nflreadr::team_abbr_mapping_norelocate)
end
end
