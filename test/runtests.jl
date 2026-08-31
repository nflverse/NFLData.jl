using NFLData
using Test
import Base: UUID
import Scratch: scratch_dir

PKG_UUID = UUID("38e18452-fdda-4cae-b91e-088906595f57")

@testset "NFLData.jl" begin
    @testset "from_url" begin
        @test size(from_url("https://github.com/nflverse/nflverse-data/releases/download/players/players",file_type=".parquet"))[1] > 0
        @test size(from_url("https://github.com/nflverse/nflverse-data/releases/download/players/players",file_type=".csv"))[1] > 0
        @test size(from_url("https://github.com/nflverse/nflverse-data/releases/download/players/players",file_type=".csv.gz"))[1] > 0
    end
    @testset "current_week" begin
        @test get_current_week() > 0
        @test get_current_week() <= 22
        @test get_current_week(true) > 0
        @test get_current_week(true) <= 22
    end
    @testset "most_recent_season" begin
        @test most_recent_season() > 2023
    end
    @testset "load_players" begin
        @test size(load_players())[1] > 0
    end
    @testset "load_pbp" begin
        @test size(load_pbp(2023))[1] > 0
        @test size(load_pbp())[1] > 0
        @test size(load_pbp(2022:2023))[1] > 0
    end
    @testset "load_contracts" begin
        @test size(load_contracts())[1] > 0
    end
    @testset "load_draft_picks" begin
        @test size(load_draft_picks())[1] > 0
    end
    @testset "load_combine" begin
        @test size(load_combine())[1] > 0
        @test size(load_combine(2023))[1] > 0
        @test size(load_combine(2022:2023))[1] > 0
        @test all(load_combine(2023).season .== 2023)
    end
    @testset "load_espn_qbr" begin
        @test size(load_espn_qbr("week"))[1] > 0
        @test size(load_espn_qbr("season"))[1] > 0
    end
    @testset "load_ff_playerids" begin
        @test size(load_ff_playerids())[1] > 0
    end
    @testset "load_ff_rankings" begin
        @test size(load_ff_rankings("draft"))[1] > 0
        @test size(load_ff_rankings("week"))[1] > 0
        @test size(load_ff_rankings("all"))[1] > 0
    end
    @testset "load_ff_opportunity" begin
        @test size(load_ff_opportunity(2023))[1] > 0
        @test size(load_ff_opportunity())[1] > 0
        @test size(load_ff_opportunity(2022:2023))[1] > 0
        @test size(load_ff_opportunity(2023, "pbp_pass"))[1] > 0
        @test size(load_ff_opportunity(2023, "pbp_rush"))[1] > 0
        @test size(load_ff_opportunity(2023, "weekly", "v1.0.0"))[1] > 0
    end
    @testset "load_ftn_charting" begin
        @test size(load_ftn_charting(2023))[1] > 0
        @test size(load_ftn_charting())[1] > 0
        @test size(load_ftn_charting(2022:2023))[1] > 0
    end
    @testset "load_injuries" begin
        @test size(load_injuries(2023))[1] > 0
        @test size(load_injuries())[1] > 0
        @test size(load_injuries(2022:2023))[1] > 0
    end
    @testset "load_nextgen_stats" begin
        @test size(load_nextgen_stats())[1] > 0
        @test size(load_nextgen_stats("receiving"))[1] > 0
        @test size(load_nextgen_stats("rushing"))[1] > 0
    end
    @testset "load_officials" begin
        @test size(load_officials())[1] > 0
    end
    @testset "load_participation" begin
        @test size(load_participation(2023))[1] > 0
        @test size(load_participation(2023, true))[1] > 0
        @test size(load_participation(2022:2023, true))[1] > 0
    end
    @testset "load_pfr_advstats" begin
        @test size(load_pfr_advstats(2023))[1] > 0
        @test size(load_pfr_advstats(2022:2023))[1] > 0
        @test size(load_pfr_advstats(2023,"rush"))[1] > 0
        @test size(load_pfr_advstats(2023,"rec"))[1] > 0
        @test size(load_pfr_advstats(2023,"def"))[1] > 0
        @test size(load_pfr_advstats(2023,"pass","season"))[1] > 0
    end
    @testset "load_player_stats" begin
        @test size(load_player_stats())[1] > 0
        @test size(load_player_stats("defense"))[1] > 0
        @test size(load_player_stats("kicking"))[1] > 0
    end
    @testset "load_rosters" begin
        @test size(load_rosters(2023))[1] > 0
        @test size(load_rosters())[1] > 0
        @test size(load_rosters(1920))[1] > 0
        @test size(load_rosters(2022:2023))[1] > 0
    end
    @testset "load_rosters_weekly" begin
        @test size(load_rosters_weekly(2023))[1] > 0
        @test size(load_rosters_weekly())[1] > 0
        @test size(load_rosters_weekly(2022:2023))[1] > 0
    end
    @testset "load_schedules" begin
        @test size(load_schedules())[1] > 0
    end
    @testset "load_snap_counts" begin
        @test size(load_snap_counts(2023))[1] > 0
        @test size(load_snap_counts())[1] > 0
        @test size(load_snap_counts(2022:2023))[1] > 0
    end
    @testset "load_teams" begin
        @test size(load_teams())[1] > 0
    end
    @testset "load_trades" begin
        @test size(load_trades())[1] > 0
    end
    @testset "nflverse_game_id" begin
        @test nflverse_game_id(2022, 2, "LAC", "KC") == "2022_02_LAC_KC"
        @test length(nflverse_game_id.(2022, 1:14, "KC", "NE")) == 14
    end
    @testset "clean_team_abbrs" begin
        @test clean_team_abbrs("SEA") == "SEA"
        @test clean_team_abbrs("FOO") == "FOO"
        @test clean_team_abbrs("SD") == "LAC"
        @test clean_team_abbrs("SD", current_location = false) == "SD"
        @test clean_team_abbrs.(["SD","SEA"]) == ["LAC","SEA"]
        @test ismissing(clean_team_abbrs("FOO", keep_non_matches = false))
    end
    @testset "clean_player_names" begin
        @test clean_player_names("Tom Brady") == "Tom Brady"
        @test clean_player_names.(["Tom Brady","Melvin Gordon Jr."]) == ["Tom Brady","Melvin Gordon"]
        @test clean_player_names("Melvin Gordon Jr.") == "Melvin Gordon"
        @test clean_player_names("Melvin Gordon Jr.",lowercase = true) == "melvin gordon"
        @test clean_player_names("Alexander Armah") == "Alex Armah"
        @test clean_player_names("Moritz Böhringer") == "Moritz Bohringer"
        @test clean_player_names("Gordon Jr., Melvin", convert_lastfirst = true) == "Melvin Gordon"
    end
    @testset "clear_cache" begin
        load_players();
        path = scratch_dir(string(PKG_UUID), "NFLData_cache/")
        @test length(readdir(path)) > 0
        clear_cache();
        @test length(readdir(path)) == 0
    end
end
