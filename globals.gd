extends Node

var grassLeft = 0
var grassCut = 0
var levelTimeElapsed = 0
var level = 0
var playerIsDead = 0

var leaderboardSaveFile = File.new()
var leaderboardSavePath = "user://Leaderboard.json"
var leaderboard = {'1':[], '2':[], '3':[]}

#Save & Load
func saveLeaderboard():
	leaderboardSaveFile.open(leaderboardSavePath,leaderboardSaveFile.WRITE)
	leaderboardSaveFile.store_line(to_json(leaderboard))
	leaderboardSaveFile.close()


func loadLeaderboard():
	if leaderboardSaveFile.file_exists(leaderboardSavePath):
		leaderboardSaveFile.open(leaderboardSavePath,leaderboardSaveFile.READ)
		var tmp_data = leaderboardSaveFile.get_as_text()
		leaderboardSaveFile.close()
		
		var dict = {}
		leaderboard = parse_json(tmp_data)

func sortLeaderboard():
	for level in leaderboard:
		leaderboard[level].sort_custom(LeaderboardSorter, "grassCut_then_time")

class LeaderboardSorter:
	static func grassCut_then_time(a, b):
		if a["grassCut"] > b["grassCut"]:
			return true
		elif a["grassCut"] == b["grassCut"]:
			if a["time"] < b["time"]:
				return true
		return false
