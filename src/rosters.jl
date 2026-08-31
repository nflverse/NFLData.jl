module rosters
include("helpers.jl")
using .helpers

include("getdata.jl")
using .getdata

include("gameinfo.jl")
using .gameinfo

export load_players
export load_depth_charts
export load_injuries
export load_rosters
export load_rosters_weekly
export load_contracts
export load_draft_picks
export load_combine
export load_teams
export load_trades

"""
    load_players()

Load a somewhat complete record of NFL players, past and present, and their associated internal NFL IDs. 
"""
function load_players()
    return from_url("https://github.com/nflverse/nflverse-data/releases/download/players/players")
end

"""
    load_depth_charts(seasons = most_recent_season())

Load weekly NFL depth charts for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_depth_charts.html).
"""
function load_depth_charts(seasons = most_recent_season())
    seasons = check_years(seasons, 2001, "NFL depth charts", true)
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/depth_charts/depth_charts_",seasons))
    return df
end

"""
    load_injuries(seasons = 2024)

Load weekly NFL injury reports for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_injuries.html).
"""
function load_injuries(seasons = 2024)
    if any(seasons .>= 2025)
        throw(DomainError(minimum(years_to_check),"No NFL injury data available after 2024!"))
    end
    seasons = check_years(seasons, 2009, "NFL injury data", true)
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/injuries/injuries_",seasons))
    return df
end

"""
    load_rosters(seasons = most_recent_season(true))

Load NFL rosters for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_rosters.html).
"""
function load_rosters(seasons = most_recent_season(true))
    seasons = check_years(seasons, 1920, "NFL rosters", true)
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/rosters/roster_", seasons))
    return df
end

"""
    load_rosters_weekly(seasons = most_recent_season(true))

Load NFL rosters by week for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_rosters.html).
"""
function load_rosters_weekly(seasons = most_recent_season(true))
    seasons = check_years(seasons, 2002, "NFL weekly rosters", true)
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/weekly_rosters/roster_weekly_", seasons))
    return df
end

"""
    load_contracts()

Load NFL contract data. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_contracts.html).
"""
function load_contracts()
    return from_url("https://github.com/nflverse/nflverse-data/releases/download/contracts/historical_contracts",file_type=".csv.gz")
end

"""
    load_draft_picks()

Load NFL draft picks. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_draft_picks.html).
"""
function load_draft_picks()
    return from_url("https://github.com/nflverse/nflverse-data/releases/download/draft_picks/draft_picks")
end

"""
    load_combine(seasons = true)

Load NFL Scouting Combine data, sourced from [Pro-Football-Reference.com](https://www.pro-football-reference.com/). Defaults to all available seasons (2000 to present). Pass in a single year or a range of years to query specific seasons, or `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_combine.html).
"""
function load_combine(seasons = true)
    seasons = check_years(seasons, 2000, "NFL combine data")
    df = from_url("https://github.com/nflverse/nflverse-data/releases/download/combine/combine")
    df = df[in.(df.season, [seasons]), :]
    return df
end

"""
    load_teams(current::Bool = true)

Load NFL teams. Argument `current` is not implemented yet, when implemented will default to current NFL teams, for now pulls in all NFL teams past and present.
"""
function load_teams(current::Bool = true)
    df = from_url("https://github.com/nflverse/nflverse-pbp/raw/master/teams_colors_logos",file_type = ".csv")
    if current
# TODO out <- out[out$team_abbr %in% nflreadr::team_abbr_mapping,]
    end
    return df
end

"""
    load_trades()

Load historical NFL trades.
"""
function load_trades()
    df = from_url("https://github.com/nflverse/nfldata/raw/master/data/trades",file_type = ".csv")
    return df
end

end