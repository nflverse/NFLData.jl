module statsdata
include("helpers.jl")
using .helpers

include("getdata.jl")
using .getdata

include("gameinfo.jl")
using .gameinfo

export load_espn_qbr
export load_nextgen_stats
export load_pfr_advstats
export load_player_stats
export load_snap_counts 

"""
    load_espn_qbr(summary_type::AbstractString = "season")

Load ESPN QBR data. Defaults to loading data by `"season"`, pass in `"week"` to `summary_type` to get weekly QBR data. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_espn_qbr.html).
"""
function load_espn_qbr(summary_type::AbstractString = "season")
    if !(summary_type in ["season","week"])
        throw(DomainError(summary_type,"Please pass in one of \"season\" or \"week\" for the argument `summary_type`!"))
    end 
    df = from_url("https://github.com/nflverse/nflverse-data/releases/download/espn_data/qbr_$summary_type" * "_level")
    return df
end

"""
    load_nextgen_stats(stat_type::AbstractString = "passing")

Load NGS data by week. Specify the types of stats returned by passing in one of the following to `stat_type`: `"passing"`, `"receiving"`,`"rushing"`. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_nextgen_stats.html).
"""
function load_nextgen_stats(stat_type::AbstractString = "passing")
    if !(stat_type in ["passing", "receiving", "rushing"])
        throw(DomainError(stat_type,"Please pass in one of \"passing\",\"receiving\",\"rushing\" for the argument `stat_type`!"))
    end
    df = from_url("https://github.com/nflverse/nflverse-data/releases/download/nextgen_stats/ngs_$stat_type")
    return df
end

"""
    load_pfr_advstats(seasons = most_recent_season(), stat_type::String = "pass", summary_level::String = "week")

Load advanced stats from [Pro-Football-Reference.com](https://www.pro-football-reference.com/) for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons.

Specify the types of stats returned by passing one of `"pass"`,`"rush"`,`"rec"`, or `"def"` to `stat_type`.

Specify the summary level of stats returned by passing one of `"week"` or `"season"` to `summary_level`.

For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_pfr_passing.html).
"""
function load_pfr_advstats(seasons = most_recent_season(), stat_type::AbstractString = "pass", summary_level::AbstractString = "week")
    seasons = check_years(seasons, 2018, "PFR advanced stats")
    if !(stat_type in ["pass","rush","rec","def"])
        throw(DomainError(stat_type,"Please pass in one of \"pass\",\"rush\",\"rec\", or \"def\" for the argument `stat_type`!"))
    end
    if !(summary_level in ["week","season"])
        throw(DomainError(stat_type,"Please pass in one of \"week\" or \"season"\" for the argument `summary_level`!"))
    end
    if summary_level == "season"
        df = from_url("https://github.com/nflverse/nflverse-data/releases/download/pfr_advstats/advstats_season_$stat_type")
        df = df[in.(df.season, seasons),:]
        return df
    elseif summary_level == "week"
        df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/pfr_advstats/advstats_week_" * stat_type * "_", seasons))
    end
    return df
end

"""
    load_player_stats(stat_type::AbstractString = "offense")

Load stats for individual players as calculated from NFLFastR PBP data. Specify the type of stats returned by passing one of `"offense"`, `"defense"`, or `"kicking"` to `stat_type`.

For information about this resource, see the offensive stats data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_player_stats.html), and the defensive stats data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_player_stats_def.html).
"""
function load_player_stats(stat_type::AbstractString = "offense")
    if stat_type == "offense"
        file_ext = "player_stats"
    elseif stat_type == "defense"
        file_ext = "player_stats_def"
    elseif stat_type == "kicking"
        file_ext = "player_stats_kicking"
    else
        throw(DomainError(stat_type,"Please pass in one of \"offense\", \"defense\", or \"kicking\" for the argument `stat_type`!"))
    end
    df = from_url("https://github.com/nflverse/nflverse-data/releases/download/player_stats/$file_ext")
    return df
end

"""
    load_snap_counts(seasons = most_recent_season())

Load game-by-game snap count data for a given season. Defaults to the most recent season. Pass in `seasons = true` for all available seasons. For information about this resource, see its data dictionary [here](https://nflreadr.nflverse.com/articles/dictionary_snap_counts.html).
"""
function load_snap_counts(seasons = most_recent_season())
    seasons = check_years(seasons, 2012, "NFL snap counts")
    df = reduce(vcat, from_url.("https://github.com/nflverse/nflverse-data/releases/download/snap_counts/snap_counts_", seasons))
    return df
end

end