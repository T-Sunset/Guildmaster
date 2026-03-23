# daily_login_track.gd
extends PanelContainer
class_name DailyLoginTrack

# Parameters
var has_setup : bool = false

# Functions
func open_popup():
	setup()
	self.visible = true
func close_popup():
	self.visible = false
func setup():
	# Display
	$MarginContainer/Content/DailyStreakLabel.text = "STREAK: " + str(GameManager.login_streak)
	
	$MarginContainer/Content/HBoxContainer/ClaimButton.visible = not GameManager.seen_streak_reward
	
	# GOLD?
	if GameManager.daily_login_reward.reward_type == LoginReward.RewardType.GOLD:
		$MarginContainer/Content/GoldInfluence.visible = true
		$MarginContainer/Content/Hero.visible = false
		$MarginContainer/Content/GoldInfluence/GoldInfluenceLabel.text = "You have been offered " + \
		str(GameManager.daily_login_reward.get_reward(GameManager.login_streak)) + "g!"
	elif GameManager.daily_login_reward.reward_type == LoginReward.RewardType.INFLUENCE:
		$MarginContainer/Content/GoldInfluence.visible = true
		$MarginContainer/Content/Hero.visible = false
		$MarginContainer/Content/GoldInfluence/GoldInfluenceLabel.text = "You have been offered " + \
		str(GameManager.daily_login_reward.get_reward(GameManager.login_streak)) + " influence!"
	else:
		$MarginContainer/Content/GoldInfluence.visible = false
		$MarginContainer/Content/Hero.visible = true
		$MarginContainer/Content/GoldInfluence/GoldInfluenceLabel.text = "You have been offered a hero!"
		if GameManager.seen_streak_reward == false:
			for child in $MarginContainer/Content/Hero/HeroList.get_children():
				child.queue_free()
			# Display hero
			var row = preload("res://src/scenes/prefabs/ui/HeroDisplay.tscn").instantiate()
			row.can_fire = false
			row.can_select = false
			row.setup(GameManager.daily_login_reward.get_reward(GameManager.login_streak))
			row.hire_this_hero.connect(hire_hero)
			$MarginContainer/Content/Hero/HeroList.add_child(row)

# When Hire button pressed
func hire_hero(hero:HeroData) -> void:
	# Have we room for another hero?
	if HeroManager.has_room_in_roster():
		# Can we afford this hero?
		if HeroManager.add_hero(hero):
			GameManager.seen_streak_reward = true
			close_popup()
			SaveManager.save_game()
			return
	if len(HeroManager.roster) == 0:
		if HeroManager.has_room_in_roster():
			if HeroManager.add_hero(hero):
				GameManager.seen_streak_reward = true
				close_popup()
				SaveManager.save_game()
				return

func _on_claim_button_pressed() -> void:
	close_popup()
	GameManager.seen_streak_reward = true
	if GameManager.daily_login_reward.reward_type == LoginReward.RewardType.GOLD:
		GameManager.add_gold(GameManager.daily_login_reward.get_reward(GameManager.login_streak))
	else:
		GameManager.add_influence(GameManager.daily_login_reward.get_reward(GameManager.login_streak))

func _on_close_button_pressed() -> void:
	close_popup()
