extends Node

var grassLeft = 0
var grassCut = 0
var levelTimeElapsed = 0
var level = "Level1"
var playerIsDead = false
var campaignMode = false

var leaderboardSaveFile = File.new()
var leaderboardSavePath = "user://Leaderboard.json"
var leaderboard = {'1':[], '2':[], '3':[]}

# Here's the fields on the campaignPlayer once loaded:
# 'name': $NewCampaignMenu/NameEntry.text,
#'experience': 0,
#'money': 0,
#'maxMowerHealth': 5,
#'currentMowerHealth': 5
var campaignPlayer = {}



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


func savePlayer():
	if campaignPlayer.has('name'):
		var playerSaveFile = File.new()
		var playerSavePath = "user://savedGames/"+campaignPlayer['name']+".json"
		playerSaveFile.open(playerSavePath,playerSaveFile.WRITE)
		playerSaveFile.store_line(to_json(campaignPlayer))
		playerSaveFile.close()
	else:
		print("No player name found!  That is a problem!")
