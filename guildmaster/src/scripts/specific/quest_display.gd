# quest_display.gd
extends VBoxContainer
class_name QuestDisplay

# Signals 
signal embark_clicked(quest:QuestData)
signal close_clicked(quest:QuestData)

# Parameters 
var quest : QuestData
var can_embark : bool = true
var show_slots : bool = false

# Display
func setup(q:QuestData):
	# Set Quest
	quest = q
	
	# Apply & Display
	# Name & Info
	$RowA/QuestNameLabel.text = q.quest_name
	$RowA/QuestDifficultyLabel.text = "Difficulty: " + str(q.quest_difficulty)
	$RowA/QuestDurationLabel.text = GameManager.convert_seconds_to_time_string(q.get_quest_duration())
	
	# Stat Scaling
	if q.quest_action.action_stats.has(Defs.Stats.STRENGTH):
		$RowB/StrengthLabel.text = "STR: " + Defs.SCALING_STRINGS[q.quest_action.action_stats[Defs.Stats.STRENGTH]]
	else:
		$RowB/StrengthLabel.text = "STR: --"
	if q.quest_action.action_stats.has(Defs.Stats.INTELLIGENCE):
		$RowB/IntelligenceLabel.text = "INT: " + Defs.SCALING_STRINGS[q.quest_action.action_stats[Defs.Stats.INTELLIGENCE]]
	else:
		$RowB/IntelligenceLabel.text = "INT: --"
	if q.quest_action.action_stats.has(Defs.Stats.DEXTERITY):
		$RowB/DexterityLabel.text = "DEX: " + Defs.SCALING_STRINGS[q.quest_action.action_stats[Defs.Stats.DEXTERITY]]
	else:
		$RowB/DexterityLabel.text = "DEX: --"
	
	# Display party / party slots
	if (!show_slots):
		$RowC.visible = false
	else:
		$RowC.visible = true
	for i in range(Defs.QUEST_MAX_PARTY_SIZE):
		if len(q.quest_party) > i:
			# ========= DO PORTRAITS HERE =========
			$RowC.get_child(i).get_child(1).text = q.quest_party[i].hero_name
		else:
			# EMPTY PORTRAIT HERE
			$RowC.get_child(i).get_child(1).text = "Empty Slot"
	
	# Rarity 
	$RowD/RarityLabel.text = str(q.quest_gold_reward) + "g Reward ("+q.quest_rarity.rarity_name+")"
	
	# Is this quest active? If not, check can_embark to see if we display embark button.
	if q in QuestManager.active_quests:
		if not q.quest_ended:
			$RowD/Active.visible = true
			$RowD/Finished.visible = false
			var elapsed = GameManager.now - q.quest_start_time
			var duration = q.quest_end_time - q.quest_start_time
			var progress = clamp(elapsed / duration, 0.0, 1.0)
			progress = int(progress * 100)
			$RowD/Active/QuestTimerBar.value = progress
			$RowD/Active/QuestTimerBar.max_value = 100
		else:
			$RowD/Active.visible = false
			$RowD/Finished.visible = true
			var finished_text = quest.quest_result_string
			$RowD/Finished/FinishButton.text = finished_text
		$RowD/Available.visible = false
	elif can_embark:
		$RowD/Finished.visible = false
		$RowD/Active.visible = false
		$RowD/Available.visible = true
	else:
		$RowD/Finished.visible = false
		$RowD/Active.visible = false
		$RowD/Available.visible = false

# Tick
func tick():
	# Is this quest active? If not, check can_embark to see if we display embark button.
	if quest in QuestManager.active_quests:
		if not quest.quest_ended:
			$RowD/Active.visible = true
			$RowD/Finished.visible = false
			var elapsed = GameManager.now - quest.quest_start_time
			var duration = quest.quest_end_time - quest.quest_start_time
			var progress = clamp(elapsed / duration, 0.0, 1.0)
			progress = int(progress * 100)
			$RowD/Active/QuestTimerBar.value = progress
			$RowD/Active/QuestTimerBar.max_value = 100
		else:
			$RowD/Active.visible = false
			$RowD/Finished.visible = true
			var finished_text = quest.quest_result_string
			$RowD/Finished/FinishButton.text = finished_text
		$RowD/Available.visible = false

func _on_embark_button_pressed() -> void:
	embark_clicked.emit(quest)

func _on_finish_button_pressed() -> void:
	close_clicked.emit(quest)
