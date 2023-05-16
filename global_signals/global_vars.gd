extends Node

var the_player

var the_drone

var current_player

var current_sentence:=""

var object_used_up:= false

var using_preposition := true

var last_added := ""

var tree_timers := []

var temp_inventory = []

var temp_drone_inventory = []

var temp_shelves = []

var temp_player_pos: Vector2
var temp_drone_pos: Vector2

var carried_inventory = []

var drone_carried_inventory = []

var shelf_placed_items := []

var no_click := false

var last_clicked: String = ""

var last_clicked_object

var just_got_rope := false

var active_map: String = ""

var player_pos: Vector2

var wearing_skates := false

var wearing_gloves := false

var wearing_mask := false

var wearing_coat := false

var using_drone := false

var text_typing := false

var tutorial_active := false

var boy_waiting := false
var girl_waiting := false

var tut_count := 0

var play_music := true

var can_exit := true

var new_panels := []

var pick_up := 400.00

var inventory_items = {
	"watch": {
		"image":"res://assets/New1920/Clock Zoomed.png",
		"text":"This is a silver watch. It looks very old."
	},
	"gold_plate": {
		"image":"res://assets/New1920/Gold Plate Zoomed.png",
		"text":"This is a golden plate. It looks expensive."
	},
	"silver_plate": {
		"image":"res://assets/New1920/Silver Plate Zoomed.png",
		"text":"A large, round plate made of silver."
	},
	"the gold cup": {
		"scene":"res://scenes/Cup.tscn",
		"image":"res://assets/platformer/Gold Cup.png",
		"text":"A golden cup. It looks old and expensive.",
		"label": "cup"
	},

	"the ladder": {
		"scene": "res://scenes_two/Ladder.tscn",
		"image":"res://assets/medieval/Objects/ladder.png",
		"text":"A long ladder.",
		"label":"ladder"
	},	
	"the glass of water": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the glass": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the hidden glass": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the first glass": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the second glass": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the third glass": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the first glass of water": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the second glass of water": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the third glass of water": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the fourth glass of water": {
		"scene": "res://scenes_two/Glass.tscn",
		"image":"res://assets/platformer/glass_water.png",
		"text":"A glass of water",
		"label": "glass"
	},
	"the green crystal": {
		"scene":"res://scenes_two/GreenCystal.tscn" ,
		"image":"res://assets/platformer/Green Crystal.png",
		"text":"A green crystal",
		"label": "green_crystal"
	},
	"the red crystal": {
		"scene":"res://scenes_two/PinkCrystal.tscn",
		"image":"res://assets/platformer/Red Crystal.png",
		"text":"A red crystal",
		"label": "red_crystal"
	},
	"the blue crystal": {
		"scene":"res://scenes_two/BlueCrystal.tscn",
		"image":"res://assets/platformer/Blue Crystal.png",
		"text":"A blue crystal",
		"label": "blue_crystal"
	},
	"the yellow crystal": {
		"scene":"res://scenes_two/YellowCrystal.tscn",
		"image":"res://assets/platformer/Yellow Crystal.png",
		"text":"A yellow crystal",
		"label": "yellow_crystal"
	},	
	"the hammer": {
		"scene":"res://scenes_two/Hammer.tscn",
		"image":"res://assets/platformer/Hammer.png",
		"text":"The strong hammer",
		"label": "hammer"
	},
	"the roller skates": {
		"scene":"res://scenes_two/Skate.tscn",
		"image":"res://assets/platformer/skate.png",
		"text":"The roller skates",
		"label": "skates"
	},
	"the climbing gloves": {
		"scene":"res://scenes_two/Gloves.tscn",
		"image":"res://assets/platformer/gloves.png",
		"text":"The climbing gloves",
		"label": "gloves"
	},
	"the rope": {
		"scene":"res://scenes_two/Rope.tscn",
		"image":"res://assets/platformer/rope_piece_short.png",
		"text":"The rope",
		"label": "rope"
	},
	"the diving mask": {
		"scene":"res://scenes_two/ScubaMask.tscn",
		"image":"res://assets/platformer/scuba_mask.png",
		"text":"The rope",
		"label": "rope"
	},
	"the fireproof coat": {
		"scene":"res://scenes_two/FireCoat.tscn",
		"image":"res://assets/platformer/fire_coat.png",
		"text":"The fireproof coat",
		"label": "coat"
	},								
	"the weak wall": {
		"scene":"res://scenes_two/BreakableWall1.tscn",
		"image":"res://assets/platformer/breakbale wall.jpeg",
		"text":"The fireproof coat",
		"label": "coat"
	},
	"the drone": {
		"scene":"res://scenes_two/TheDrone.tscn",
		"image":"res://assets/platformer/drone.png",
		"text":"The drone",
		"label": "drone"
	},	
	"the fuse box": {
		"scene":"res://scenes_two/FuseBox.tscn",
		"image":"res://assets/platformer/fuse_box_off.png",
		"text":"The fuse box",
		"label": "fuse box"
	},	
	"the fuse": {
		"scene":"res://scenes_two/TheFuse.tscn",
		"image":"res://assets/platformer/fuse.png",
		"text":"The fuse",
		"label": "fuse"
	},
	"the glasses": {
		"scene":"res://puzzle_object_scenes/Glasses.tscn",
		"image":"res://assets/game_objects/puzzle_objects/glasses.png",
		"text":"The glasses",
		"label": "glasses"
	},	
	"the alpha key": {
		"scene":"res://scenes_two/DoorKey.tscn",
		"image":"res://assets/platformer/alpha_key.png",
		"text":"The fuse",
		"label": "fuse"
	},
	"the beta key": {
		"scene":"res://scenes_two/DoorKey.tscn",
		"image":"res://assets/game_objects/bravo_key.png",
		"text":"The beta key",
		"label": "beta key"
	},
	"the delta key": {
		"scene":"res://scenes_two/DoorKey.tscn",
		"image":"res://assets/game_objects/delta_key.png",
		"text":"The delta key",
		"label": "delta key"
	},
	"the old key": {
		"scene":"res://scenes_two/DoorKey.tscn",
		"image":"res://assets/platformer/alpha_key.png",
		"text":"The key",
		"label": "key"
	},
	"the apple": {
		"scene":"res://scenes_two/Apple.tscn",
		"image":"res://assets/platformer/apple.png",
		"text":"The apple",
		"label": "apple"
	},
	"the medicine": {
		"scene":"res://scenes_two/FirstAid.tscn",   
		"image":"res://assets/platformer/first_aid.png",
		"text":"The first aid kit",
		"label": "first aid"
	},
	"the clock": {
		"scene":"res://puzzle_object_scenes/RiddleItem.tscn",  
		"image":"res://assets/game_objects/puzzle_objects/Clock.png",
		"text":"the clock",
		"label": "clock"
	},
	"the mirror": {
		"scene": "res://puzzle_object_scenes/TheMirror.tscn",
		"image":"res://assets/game_objects/puzzle_objects/MIrror.png",
		"text":"the mirror",
		"label": "mirror"
	},
	"the bell": {
		"scene": "res://scenes_two/Bell.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Bell.png",
		"text":"the mirror",
		"label": "mirror"
	},
	"the pen": {
		"scene":"res://puzzle_object_scenes/Pen.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Pen.png",
		"text":"the pen",
		"label": "pen"
	},
	"the telescope": {
		"scene":"res://puzzle_object_scenes/Telescope.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Telescope.png",
		"text":"the telescope",
		"label": "telescope"
	},
	"the umbrella": {
		"scene":"res://puzzle_object_scenes/Umbrella.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Umbrella.png",
		"text":"the umbrella",
		"label": "umbrella"
	},	
	"the boomerang": {
		"scene":"res://puzzle_object_scenes/Boomerang.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Boomerang.png",
		"text":"the boomerang",
		"label": "boomerang"
	},
	"the compass": {
		"scene":"res://puzzle_object_scenes/Compass.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Compass.png",
		"text":"the compass",
		"label": "compass"
	},
	"the ring": {
		"scene":"res://puzzle_object_scenes/Ring.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Ring.png",
		"text":"the ring",
		"label": "ring"
	},
	"the padlock": {
		"scene":"res://puzzle_object_scenes/Padlock.tscn",
		"image":"res://assets/game_objects/puzzle_objects/Padlock.png",
		"text":"the ring",
		"label": "ring"
	},
	"the lamp": {
		"scene":"res://puzzle_object_scenes/Lamp.tscn",
		"image":"res://assets/game_objects/puzzle_objects/lamp.png",
		"text":"the lamp",
		"label": "lamp"
	},
	"the cooking pot": {
		"scene":"res://puzzle_object_scenes/CookingPot.tscn",
		"image":"res://assets/game_objects/puzzle_objects/CookingPot.png",
		"text":"the cooking pot",
		"label": "cooking pot"
	},					

}

var level_menu_data = {
	"TheJourney":{
		"image":"res://assets/level_panels/forest_level_panel.png",
		"label":"The Journey",
		"scene":"res://Intro/ForestIntro.tscn"
	},
	"TheVillage":{
		"image":"res://assets/level_panels/village_level_panel.png",
		"label":"The Village",
		"scene":"res://Intro/VillageIntro.tscn"
	},
	"Rock1":{
		"image":"res://assets/level_panels/lower1_level_panel.png",
		"label":"Rock Cave 1",
		"scene": "res://cave_scenes/Lower1a.tscn"
		},
	"Rock2":{
		"image":"res://assets/comic/lower2/lever_log.png",
		"label":"Rock Cave 2",
		"scene": "res://cave_scenes/Lower2a.tscn"
		},
	"Rock3":{
		"image":"res://assets/level_panels/lower3_level_panel.png",
		"label":"Rock Cave 3",
		"scene": "res://cave_scenes/Lower2.tscn"
		},
	"Rock4":{
		"image":"res://assets/level_panels/lower_4_level_panel.png",
		"label":"Rock Cave 4",
		"scene": "res://cave_scenes/Lower3a.tscn"
		},
	"Lava5":{
		"image":"res://assets/level_panels/lower5_level_panel.png",
		"label":"Lava Cave 5",
		"scene": "res://cave_scenes/Lower3.tscn"
		},
	"Lava6":{
		"image":"res://assets/level_panels/lava6_level_panel.png",
		"label":"Lava Cave 6",
		"scene": "res://cave_scenes/Mid5.tscn"
		},
	"Lava7":{
		"image":"res://assets/level_panels/lava7_level_panel.png",
		"label":"Lava Cave 7",
		"scene": "res://cave_scenes/Lava7.tscn"
		},
	"Lava8":{
		"image":"res://assets/level_panels/lava8_level_panel.png",
		"label":"Lava Cave 8",
		"scene": "res://cave_scenes/Lava8.tscn"
		},
	"Water9":{
		"image":"res://assets/level_panels/water9_level_panel.png",
		"label":"Water Cave 9",
		"scene": "res://cave_scenes/Water9.tscn"
		},
	"Water10":{
		"image":"res://assets/level_panels/water10_level_panel.png",
		"label":"Water Cave 10",
		"scene": "res://cave_scenes/Water10.tscn"
		},
	"Water11":{
		"image":"res://assets/level_panels/water10_level_panel.png",
		"label":"Water Cave 11",
		"scene": "res://cave_scenes/Water11.tscn"
		},
#	"Demo1":{
#		"image":"res://assets/comic/village_intro/arrive_village.png",
#		"label":"Demo 1",
#		"scene": "res://DemoLevels/Demo1.tscn"
#		},
#	"Demo2":{
#		"image":"res://assets/comic/village_intro/arrive_village.png",
#		"label":"Demo 2",
#		"scene": "res://DemoLevels/Demo2.tscn"
#		},
#	"Demo3":{
#		"image":"res://assets/comic/village_intro/arrive_village.png",
#		"label":"Demo 3",
#		"scene": "res://DemoLevels/Demo3.tscn"
#		},
#	"Demo4":{
#		"image":"res://assets/comic/village_intro/arrive_village.png",
#		"label":"Demo 4",
#		"scene": "res://DemoLevels/Demo4.tscn"
#		},
#	"VillageEnd":{
#		"image":"res://assets/comic/village_intro/loud_noise.png",
#		"label":"The Finale",
#		"scene": "res://End/VillageEnd.tscn"
#		}		

}

var village_sentences = [
	"arrived at village",
	"run and jump",
	"give medicine",
	"loud noise",
	"hide cave",
	"pull lever"
]

var comic_events = {
	"TheVillage":{
		"arrived at village":{
			"image":"res://assets/comic/village_intro/arrive_village.png",
			"label":"After a long journey, I arrived at the village.",
			"voice":"res://assets/audio/story_narration/village_intro/arrived_village.mp3",
			},
		"run and jump":{
			"image":"res://assets/comic/village_intro/climb_rope.png",
			"label": "I ran, jumped and climbed a rope before finding a woman and her children.",
			"voice":"res://assets/audio/story_narration/village_intro/ran_jumped.mp3"
			},			
		"give medicine": {
			"image":"res://assets/comic/village_intro/give_medicine.png",
			"label":"After speaking to the woman, I gave the children some medicine to help them.",
			"voice":"res://assets/audio/story_narration/village_intro/speak_woman.mp3"
			},
		"loud noise": {
			"image":"res://assets/comic/village_intro/loud_noise.png",
			"label":"Suddenly there was a loud noise. The woman seemed very worried.",
			"voice":"res://assets/audio/story_narration/village_intro/sudden_noise.mp3"
			},
		"hide cave": {
			"image":"res://assets/comic/village_intro/hide_cave.png",
			"label":"She told me to hide inside a cave.",
			"voice":"res://assets/audio/story_narration/village_intro/hide_cave.mp3"
			},
		"pull lever": {
			"image":"res://assets/comic/village_intro/pull_lever.png",
			"label":"It was very dark. I pulled a lever and found myself going deeper into the cave.",
			"voice":"res://assets/audio/story_narration/village_intro/very_dark.mp3"
			}
	},
	"Rock1":{
		"arrive in level":{
			"image":"res://assets/comic/lower1/arrive_level.png",
			"label":"I found myself in a dark cave. I had to get out and back to the village.",
			"voice":"res://assets/audio/story_narration/lower1/found_dark_cave.mp3",
			
			},
		"get the blue crystal":{
			"image":"res://assets/comic/lower1/blue_crystal.png",
			"label":"I found a beautiful, blue crystal. It took it so I could give it to someone in the village.",
			"voice":"res://assets/audio/story_narration/lower1/found_blue.mp3"
			},
		"look at the sign":{
			"image":"res://assets/comic/lower1/read_sign.png",
			"label": "The sign said 'My hands will help you stay organised' It seemed to be a riddle.",
			"voice": "res://assets/audio/story_narration/lower1/sign_said.mp3"
			},
		"get the mirror":{
			"image":"res://assets/comic/lower1/read_sign.png",
			"label": "I was surprised to find a mirror in the cave. I picked it up.",
			"voice": "res://assets/audio/story_narration/lower1/found_mirror.mp3"
			},	
		"get the clock":{
			"image":"res://assets/comic/lower1/get_clock.png",
			"label": "I found a clock hidden in one corner of the cave. I had a feeling it might be useful.",
			"voice": "res://assets/audio/story_narration/lower1/found_clock.mp3"
			},	
		"use the mirror in the hole":{
			"image":"res://assets/comic/lower1/mirror_hole.png",
			"label": "I tried putting the mirror in the hole but nothing happened. I needed something different.",
			"voice": "res://assets/audio/story_narration/lower1/mirror_in_hole.mp3"
			},	
		"use the clock in the hole":{
			"image":"res://assets/comic/lower1/clock_in_hole.png",
			"label": "I put the clock in the hole and was amazed by what happened next.",
			"voice": "res://assets/audio/story_narration/lower1/clock_in_hole.mp3"
			},		
		"the door opened": {
			"image":"res://assets/comic/lower1/door_open.png",
			"label":"The door opened. I hoped it would take me back to the village.",
			"voice":"res://assets/audio/story_narration/lower1/door_opened.mp3"
			}
	},
	"Rock2":{
		"lever moved on":{
			"image":"res://assets/comic/lower2/lever_log.png",
			"label":"I pushed a lever and a large log lowered, making a bridge for me to cross.",
			"voice":"res://assets/audio/story_narration/lower2/push_lever_log.mp3"
			
			},
		"lever moved off":{
			"image":"res://assets/comic/lower2/pull_lever.png",
			"label":"When I pulled the lever, the log rose up again.",
			"voice":"res://assets/audio/story_narration/lower2/pull_lever_log.mp3"
			},
		"look at the sign":{
			"image":"res://assets/comic/lower2/read_sign.png",
			"label": "The sign told me I needed an object whose voice could be a warning.",
			"voice": "res://assets/audio/story_narration/lower2/sign_voice_warning.mp3"
			},
		"get the yellow crystal":{
			"image":"res://assets/comic/lower2/found_yellow_c.png",
			"label": "I found an incredible yellow crystal. I picked it up.",
			"voice": "res://assets/audio/story_narration/lower2/found_yello_crystal.mp3"
			},	
		"get the pen":{
			"image":"res://assets/comic/lower2/found_pen.png",
			"label": "I found a pen. I wasn’t sure what I could do with that down in the cave.",
			"voice": "res://assets/audio/story_narration/lower2/found_a_pen_l2.mp3"
			},	
		"get the bell":{
			"image":"res://assets/comic/lower2/found_bell.png",
			"label": "I found a bell. It was odd, but could have been useful.",
			"voice": "res://assets/audio/story_narration/lower2/found_bell_useful.mp3"
			},	
		"get the green crystal":{
			"image":"res://assets/comic/lower2/found_green_c.png",
			"label": "I found an amazing green crystal. I took it with me.",
			"voice": "res://assets/audio/story_narration/lower2/found_green_crystal.mp3"
			},
		"use the pen in the hole":{
			"image":"res://assets/comic/lower2/try_pen.png",
			"label": "When I put the pen in the hole, nothing happened. It must have been the wrong item.",
			"voice": "res://assets/audio/story_narration/lower2/pen_hole_nothing.mp3"
			},	
		"use the bell in the hole":{
			"image":"res://assets/comic/lower2/bell_hole.png",
			"label": "I put the bell in the hole; I thought it might solve the riddle because the sound of a bell could be a warning.",
			"voice": "res://assets/audio/story_narration/lower2/bell_hole_solve.mp3"
			},					
		"the door opened": {
			"image":"res://assets/comic/lower2/door_opened.png",
			"label":"It worked and the door opened.",
			"voice":"res://assets/audio/story_narration/lower2/l3_door_opened.mp3"
			}
	},
	"Rock3":{
		"must keep going":{
			"image":"res://assets/comic/lower3/arrive_lower2.png",
			"label":"I found myself in another cave. I had no choice but to keep going.",
			"voice":"res://assets/audio/story_narration/lower3/start_another_cave.mp3"			
			},
		"found a ladder":{
			"image":"res://assets/comic/lower3/found_ladder.png",
			"label":"I found a ladder. I decided to keep it with me to help me escape the cave.",
			"voice":"res://assets/audio/story_narration/lower3/found_ladder.mp3"		
			},
		"get the bell":{
			"image":"res://assets/comic/lower3/found_bell.png",
			"label":"I found a bell, which seemed odd. There was something strange about it.",
			"voice":"res://assets/audio/story_narration/lower3/found_bell.mp3"		
			},
		"push button on":{
			"image":"res://assets/comic/lower3/push_btn_log.png",
			"label":"I found some buttons that moved these large logs up and down; this helped me to get around.",
			"voice":"res://assets/audio/story_narration/lower3/pushed_buttons.mp3"		
			},
		"look at the sign":{
			"image":"res://assets/comic/lower3/read_sign.png",
			"label":"I found another clue on a sign. It talked about my 'twin' which I didn't understand at first.",
			"voice":"res://assets/audio/story_narration/lower3/found_clue_sign.mp3"			
			},
		"had a fall":{
			"image":"res://assets/comic/lower3/fall_accident.png",
			"label":"I did have a bit of a fall, but luckily I was ok. I think there is something magic about this cave.",
			"voice":"res://assets/audio/story_narration/lower3/had_fall.mp3"			
			},
		"get the mirror":{
			"image":"res://assets/comic/lower3/found_mirror.png",
			"label":"I found a mirror. When I looked in it, my reflection seemed different somehow.",
			"voice":"res://assets/audio/story_narration/lower3/found_mirror.mp3"			
			},
		"get the blue crystal":{
			"image":"res://assets/comic/lower3/fall_accident.png",
			"label":"I found a blue crystal. It was in a very hard to reach place.",
			"voice":"res://assets/audio/story_narration/lower3/found_blue_crystal.mp3"			
			},
		"get the green crystal":{
			"image":"res://assets/comic/lower3/found_green_c.png",
			"label":"I found a green crystal. Pushing all those buttons was very tiring!",
			"voice":"res://assets/audio/story_narration/lower3/found_green_crystal.mp3"			
			},
		"use the mirror in the hole":{
			"image":"res://assets/comic/lower3/mirror_in_hole.png",
			"label":"I thought the mirror might be the solution to the riddle so I put it in the hole.",
			"voice":"res://assets/audio/story_narration/lower3/mirror_in_hole.mp3"			
			},
		"use the bell in the hole":{
			"image":"res://assets/comic/lower3/bell_in_hole.png",
			"label":"I put the bell in the hole but nothing happened. I had to try something else.",
			"voice":"res://assets/audio/story_narration/lower3/bell_in_hole.mp3"		
			},
		"the door opened":{
			"image":"res://assets/comic/lower3/door_open.png",
			"label":"That seemed to work and the door opened.",
			"voice":"res://assets/audio/story_narration/lower3/worked_door_open.mp3"		
			},
	},
	"Rock4":{
		"the first lever moved on":{
			"image":"res://assets/comic/lower4/start_hidden_lever.png",
			"label":"At first it looked like there was nowhere to go but then I saw a hidden lever that lowered a log.",
			"voice":	"res://assets/audio/story_narration/lower4/at_first_lever.mp3"		
			},
		"push button on":{
			"image":"res://assets/comic/lower4/push_button_jump.png",
			"label":"There was another one of those push buttons. I quickly jumped on to the log.",
			"voice":	"res://assets/audio/story_narration/lower4/button_quick_jump.mp3"
			},
		"get the compass":{
			"image":"res://assets/comic/lower4/found_compass.png",
			"label":"I found a compass but it didn't seem to be working.",
			"voice":	"res://assets/audio/story_narration/lower4/found_compass.mp3"	
			},
		"the second lever moved on":{
			"image":"res://assets/comic/lower4/hard_find_lever.png",
			"label":"It was hard to get to this lever; I pulled it and it lowered another log bridge.",
			"voice":	"res://assets/audio/story_narration/lower4/hard_lever_log_bridge.mp3"	
			},
		"get the red crystal":{
			"image":"res://assets/comic/lower4/found_red_crystal.png",
			"label":"I'm glad I came back to get this hidden red crystal.",
			"voice":	"res://assets/audio/story_narration/lower4/red_crystal_hidden.mp3"	
			},
		"the third lever moved on":{
			"image":"res://assets/comic/lower4/another_hard_find_lever.png",
			"label":"This lever was also really hard to find but I had to pull it to get across another log.",
			"voice":	"res://assets/audio/story_narration/lower4/lever_hard_find_pull.mp3"	
			},
		"get the boomerang":{
			"image":"res://assets/comic/lower4/found_boomerang.png",
			"label":"The boomerang was well hidden but I managed to get it.",
			"voice":	"res://assets/audio/story_narration/lower4/boomerang_hidden.mp3"
			},
		"look at the sign":{
			"image":"res://assets/comic/lower4/read_sign.png",
			"label":"The sign told me I needed something that would always come back to me.",
			"voice":	"res://assets/audio/story_narration/lower4/sign_come_back.mp3"	
			},
		"use the compass in the hole":{
			"image":"res://assets/comic/lower4/compass_in_hole.png",
			"label":"I tried the compass in the hole but it didn’t work.",
			"voice":	"res://assets/audio/story_narration/lower4/compass_didnt_work.mp3"	
			},
		"the door opened":{
			"image":"res://assets/comic/lower4/door_platform.png",
			"label":"The door was hidden but I found it by using a sideways moving platform.",
			"voice":"res://assets/audio/story_narration/lower4/found_ddor_sideways.mp3"
			},
		"use the boomerang in the hole":{
			"image":"res://assets/comic/lower4/boomerang_in_hole.png",
			"label":"Yes! A boomerang comes back to you when you throw it. That was the answer to the riddle.",
			"voice":	"res://assets/audio/story_narration/lower4/yes_boomerang_ansewer.mp3"
			},
			},
	"Lava5":{
		"get the hammer":{
			"image":"res://assets/comic/lower5/get_the_hammer.png",
			"label":"I found a hammer, I had a feeling it was going to help me.",
			"voice":"res://assets/audio/story_narration/lower5/found_hammer.mp3"			
			},
		"wall broken a weak wall":{
			"image":"res://assets/comic/lower5/wall_broken_weak.png",
			"label":"I was able to break a weak looking wall with the hammer.",
			"voice":"res://assets/audio/story_narration/lower5/weak_wall_break.mp3"		
			},
		"wall broken a breakable wall":{
			"image":"res://assets/comic/lower5/wall_broken_breakable.png",
			"label":"I was able to break a wall and found a green crystal behind it.",
			"voice":"res://assets/audio/story_narration/lower5/break_wall_found_green.mp3"		
			},
		"push button on":{
			"image":"res://assets/comic/lower5/push_button_on.png",
			"label":"I found more of these buttons that moved the logs; but I had to move quickly.",
			"voice":"res://assets/audio/story_narration/lower5/button_logs.mp3"	
			},
		"get the green crystal":{
			"image":"res://assets/comic/lower5/green_crystal.png",
			"label":"After breaking the wall, I picked up the green crystal.",
			"voice":"res://assets/audio/story_narration/lower5/got_green_crystal.mp3"		
			},
		"get the pen":{
			"image":"res://assets/comic/lower5/get_pen.png",
			"label":"I found a pen. I thought I should probably take it as it could be helpful.",
			"voice":"res://assets/audio/story_narration/lower5/found_pen.mp3"		
			},
		"floor broken the weak floor":{
			"image":"res://assets/comic/lower5/floor broken.png",
			"label":"I noticed the ceiling looked weak. By standing on the ladder, I was able to break through.",
			"voice":"res://assets/audio/story_narration/lower5/ceiling_weak.mp3"		
			},
		"look at the sign":{
			"image":"res://assets/comic/lower5/look_sign.png",
			"label":"There was another sign. I told me to find something that could create worlds.",
			"voice":"res://assets/audio/story_narration/lower5/look_sign_pen.mp3"		
			},
		"get the yellow crystal":{
			"image":"res://assets/comic/lower5/yellow_crystal.png",
			"label":"I spotted a yellow crystal. It was difficult to get to it but I managed at last and picked it up.",
			"voice":"res://assets/audio/story_narration/lower5/yellow_crystal_get.mp3"	
			},
		"use the yellow crystal in the hole":{
			"image":"res://assets/comic/lower5/yellow_crystal_hole.png",
			"label":"I tried putting the yellow crystal in the hole but it didn't do anything.",
			"voice":"res://assets/audio/story_narration/lower5/yellow_in_hole.mp3"		
			},
		"use the pen in the hole":{
			"image":"res://assets/comic/lower5/pen_hole.png",
			"label":"I had an idea. You can use a pen to write stories and create worlds. It worked!",
			"voice":"res://assets/audio/story_narration/lower5/pen_create_worlds.mp3"		
			},
		"the door opened":{
			"image":"res://assets/comic/lower5/door_open.png",
			"label":"After putting the pen in the hole, the door opened!",
			"voice":"res://assets/audio/story_narration/lower5/door_opened_pen_hole.mp3"		
			},
		},
	"Lava6":{
		"get the first glass of water":{
			"image":"res://assets/comic/lava6/fire_block.png",
			"label":"My path was blocked by a fire; luckily I found a glass of water which I poured on the fire and put it out.",
			"voice":"res://assets/audio/story_narration/lava6/path_block_fire.mp3"			
			},
		"get the second glass of water":{
			"image":"res://assets/comic/lava6/second_water.png",
			"label":"I used a moving log to reach a second glass of water. I thought I could use this if I came across more fire.",
			"voice":"res://assets/audio/story_narration/lava6/second_glass_log.mp3"		
			},
		"use the second glass of water on the second fire":{
			"image":"res://assets/comic/lava6/second_water.png",
			"label":"I was right. There was more fire. Luckily, I had that glass of water and I was able to get past.",
			"voice":"res://assets/audio/story_narration/lava6/second_glass_log.mp3"			
			},
		"wall broken the weak wall":{
			"image":"res://assets/comic/lava6/wall_broken.png",
			"label":"I used my hammer to knock down a wall. I thought there could be something useful behind it.",
			"voice":"res://assets/audio/story_narration/lava6/break_wall.mp3"			
			},
		"get the third glass of water":{
			"image":"res://assets/comic/lava6/get_third_water.png",
			"label":"I found another glass of water. It was strange to see these all over the place.",
			"voice":"res://assets/audio/story_narration/lava6/second_glass_log.mp3"			
			},
		"get the umbrella":{
			"image":"res://assets/comic/lava6/get_umbrella.png",
			"label":"I picked up an umbrella. I guessed it might come in handy.",
			"voice":"res://assets/audio/story_narration/lava6/get_umbrella.mp3"			
			},
		"look at the sign":{
			"image":"res://assets/comic/lava6/look_sign.png",
			"label":"When I read the sign, it told me to look for something that could show me the moon.",
			"voice":"res://assets/audio/story_narration/lava6/look_sign_moon.mp3"			
			},
		"use the third glass of water on the third fire":{
			"image":"res://assets/comic/lava6/third_fire.png",
			"label":"There was another fire. I used the water I found behind the wall to extinguish it.",
			"voice":"res://assets/audio/story_narration/lava6/third_fire.mp3"			
			},
		"use the umbrella in the hole":{
			"image":"res://assets/comic/lava6/umbrella_in_hole.png",
			"label":"When I tried putting the umbrella in the hole, nothing happened. It must have been the wrong item.",
			"voice":"res://assets/audio/story_narration/lava6/umbrealla_hole.mp3"			
			},
		"get the telescope":{
			"image":"res://assets/comic/lava6/get_telescope.png",
			"label":"I found a telescope but It was too dark to see anything through it.",
			"voice":"res://assets/audio/story_narration/lava6/get_telescope.mp3"			
			},
		"get the red crystal":{
			"image":"res://assets/comic/lava6/red_crystal.png",
			"label":"There was a red crystal on the ground. I decided I should pick it up.",
			"voice":"res://assets/audio/story_narration/lava6/red_crystal.mp3"			
			},
		"use the telescope in the hole":{
			"image":"res://assets/comic/lava6/telescope_in_hole.png",
			"label":"The clue said something about showing me the moon. I thought a telescope could do that.",
			"voice":"res://assets/audio/story_narration/lava6/telescope_hole.mp3"			
			},
			},
	"Lava7":{
		"get the ring":{
			"image":"res://assets/comic/lava7/get_ring.png",
			"label":"I took the ring that I found but I wasn’t sure if it was real or magic.",
			"voice":"res://assets/audio/story_narration/lava7/took_ring.mp3"			
			},
		"use the ring in the hole":{
			"image":"res://assets/comic/lava7/ring_in_hole.png",
			"label":"I put the ring in the hole but nothing happened. I needed to try something else.",
			"voice":"res://assets/audio/story_narration/lava7/ring_in_hole.mp3"			
			},
		"look at the sign":{
			"image":"res://assets/comic/lava7/look_sign.png",
			"label":"The clue said, “I keep your most precious things safe.”",
			"voice":"res://assets/audio/story_narration/lava7/look_sign.mp3"			
			},
		"use the padlock in the hole":{
			"image":"res://assets/comic/lava7/padlock_hole.png",
			"label":"I thought the padlock was the answer to the riddle. It worked! The door opened.",
			"voice":"res://assets/audio/story_narration/lava7/door_opened.mp3"			
			},
		"get the yellow crystal":{
			"image":"res://assets/comic/lava7/break_wall_yellow_crystal.png",
			"label":"I managed to break a wall and found a yellow crystal on a ledge. I picked up the crystal.",
			"voice":"res://assets/audio/story_narration/lava7/yellow_crystal.mp3"			
			},
		"get the green crystal":{
			"image":"res://assets/comic/lava7/green_crystal.png",
			"label":"I found a green crystal. It was quite well hidden.",
			"voice":"res://assets/audio/story_narration/lava7/green_crystal.mp3"			
			},
		"use the glass on the fire":{
			"image":"res://assets/comic/lava7/fire_lever.png",
			"label":"I put out the fire so that I could get to the lever.",
			"voice":"res://assets/audio/story_narration/lava7/fire_lever.mp3"		
			},
		"get the padlock":{
			"image":"res://assets/comic/lava7/get_padlock.png",
			"label":"After pulling the lever, I crossed over the log and picked up a padlock.",
			"voice":"res://assets/audio/story_narration/lava7/get_padlock.mp3"			
			},
		"use the second glass on the top fire":{
			"image":"res://assets/comic/lava7/glass_on_fire.png",
			"label":"I put out the fire with one of the glasses of water I found.",
			"voice":"res://assets/audio/story_narration/lava7/put_out_fire.mp3"			
			},
		"get the glass":{
			"image":"res://assets/comic/lava7/get_glass_easy.png",
			"label":"I found a glass of water. I thought it might help me put out one of the fires.",
			"voice":"res://assets/audio/story_narration/lava7/found_water_easy.mp3"			
			},
		"get the second glass":{
			"image":"res://assets/comic/lava7/glass_hard_get.png",
			"label":"This glass was very hard to get to but I knew that I needed it.",
			"voice":"res://assets/audio/story_narration/lava7/found_glass_hard.mp3"			
			},
		"wall broken the weak floor":{
			"image":"res://assets/comic/lava7/break_floor.png",
			"label":"I managed to break through a ceiling, I was getting good at this by now.",
			"voice":"res://assets/audio/story_narration/lava7/break_ceiling.mp3"			
			},
			},
	"Lava8":{
		"get the second glass":{
			"image":"res://assets/comic/lava8/second_glass.png",
			"label":"I pushed a button and caught a ride on a log to get to this glass of water.",
			"voice":"res://assets/audio/story_narration/lava8/ride_log_water.mp3"		
			},
		"the second lever moved on":{
			"image":"res://assets/comic/lava8/second_lever.png",
			"label":"I found a lever in the roof. It lowered a log bridge that I needed to cross.",
			"voice":"res://assets/audio/story_narration/lava8/lever_roof.mp3"			
			},
		"the first lever moved on":{
			"image":"res://assets/comic/lava8/first_lever.png",
			"label":"This lever moved a log that would help me get to the exit door.",
			"voice":"res://assets/audio/story_narration/lava8/lever_log_exit.mp3"			
			},
		"get the first glass":{
			"image":"res://assets/comic/lava8/first_glass.png",
			"label":"I found a glass of water. This was going to help me get past those fires.",
			"voice":"res://assets/audio/story_narration/lava8/first_glass_found.mp3"			
			},
		"use the first glass on the small fire":{
			"image":"res://assets/comic/lava8/fire_near_lever.png",
			"label":"I put out the fire so I could get to the lever.",
			"voice":"res://assets/audio/story_narration/lava8/fire_out_lever.mp3"			
			},
		"use the second glass on the small fire":{
			"image":"res://assets/comic/lava8/fire_near_lever.png",
			"label":"I put out the fire so I could get to the lever.",
			"voice":"res://assets/audio/story_narration/lava8/fire_out_lever.mp3"			
			},			
		"use the second glass on the top fire":{
			"image":"res://assets/comic/lava8/fire_near_bridge.png",
			"label":"I used the glass of water to put out this fire. I needed to get across the log bridge now.",
			"voice":"res://assets/audio/story_narration/lava8/water_fire_out_bridge.mp3"			
			},
		"use the first glass on the top fire":{
			"image":"res://assets/comic/lava8/fire_near_bridge.png",
			"label":"I used the glass of water to put out this fire. I needed to get across the log bridge now.",
			"voice":"res://assets/audio/story_narration/lava8/water_fire_out_bridge.mp3"			
			},
		"get the lamp":{
			"image":"res://assets/comic/lava8/get_lamp.png",
			"label":"I found a lamp. It wasn’t very bright but I thought it might help me later.",
			"voice":"res://assets/audio/story_narration/lava8/found_lamp.mp3"			
			},
		"get the cooking pot":{
			"image":"res://assets/comic/lava8/get_pot.png",
			"label":"I found a cooking pot. I took it with me. I wondered if it might help me get out of this cave.",
			"voice":"res://assets/audio/story_narration/lava8/found_cooking_pot.mp3"			
			},
		"get the red crystal":{
			"image":"res://assets/comic/lava8/red_crystal.png",
			"label":"I found a red crystal. I picked it up and added it to the other crystals I had already found.",
			"voice":"res://assets/audio/story_narration/lava8/red_crystal.mp3"			
			},
		"look at the sign":{
			"image":"res://assets/comic/lava8/look_sign.png",
			"label":"The clue talked about taking away my hunger.",
			"voice":"res://assets/audio/story_narration/lava8/look_sign.mp3"			
			},
		"use the lamp in the hole":{
			"image":"res://assets/comic/lava8/lamp_hole.png",
			"label":"I tried the lamp in the hole but nothing happened.",
			"voice":"res://assets/audio/story_narration/lava8/lamp_in_hole.mp3"			
			},
		"use the cooking pot in the hole":{
			"image":"res://assets/comic/lava8/pot_in_hole.png",
			"label":"Yes! The cooking pot can take away my hunger. The door opened!",
			"voice":"res://assets/audio/story_narration/lava8/cooking_pot_hole.mp3"			
			},
		"get the yellow crystal":{
			"image":"res://assets/comic/lava8/yellow_crystal.png",
			"label":"This yellow crystal was very well hidden.",
			"voice":"res://assets/audio/story_narration/lava8/yellow_crystal.mp3"			
			},
			},
	"Water9":{
		"the lever moved on":{
			"image":"res://assets/comic/water9/lever_moved.png",
			"label":"I pulled this lever and heard a log moving into place.",
			"voice":"res://assets/audio/story_narration/water9/pulled_lever.mp3"		
			},
		"push button on":{
			"image":"res://assets/comic/water9/push_button.png",
			"label":"After swimming through some cold water, I pushed this button and a log rose up.",
			"voice":"res://assets/audio/story_narration/water9/swim_push_btn.mp3"		
			},
		"wall broken the weak wall":{
			"image":"res://assets/comic/water9/break_wall.png",
			"label":"I used the hammer to get through this wall. Maybe something important was behind it.",
			"voice":"res://assets/audio/story_narration/water9/break_wall.mp3"		
			},
		"get the diving mask":{
			"image":"res://assets/comic/water9/get_mask.png",
			"label":"I found a diving mask. I could use this to dive underwater.",
			"voice":"res://assets/audio/story_narration/water9/found_diving_mask.mp3"		
			},
		"get the blue crystal":{
			"image":"res://assets/comic/water9/blue_crystal.png",
			"label":"I found a blue crystal under the water.",
			"voice":"res://assets/audio/story_narration/water9/blue_crystal.mp3"		
			},
		"get the glasses":{
			"image":"res://assets/comic/water9/get_glasses.png",
			"label":"There was a pair of glasses at the bottom of this water. I picked them up.",
			"voice":"res://assets/audio/story_narration/water9/get_glasses.mp3"		
			},
		"get the telescope":{
			"image":"res://assets/comic/water9/get_telescope.png",
			"label":"I found a telescope underwater. I took it. Maybe it could be useful again.",
			"voice":"res://assets/audio/story_narration/water9/get_telescope.mp3"		
			},
		"look at the sign":{
			"image":"res://assets/comic/water9/look_sign.png",
			"label":"This clue said I needed something that could help me see clearly.",
			"voice":"res://assets/audio/story_narration/water9/look_sign.mp3"		
			},
		"use the telescope in the hole":{
			"image":"res://assets/comic/water9/telescope_hole.png",
			"label":"I tried the telescope in the hole but it wasn’t the answer to the riddle.",
			"voice":"res://assets/audio/story_narration/water9/telescope_hole.mp3"		
			},
		"use the glasses in the hole":{
			"image":"res://assets/comic/water9/glasses_hole.png",
			"label":"I put the glasses in the hole and the door opened. Yes, glasses can help you see clearly.",
			"voice":"res://assets/audio/story_narration/water9/glasses_hole.mp3"		
			},
			},
	"Water10":{
		"first used rope":{
			"image":"res://assets/comic/water10/found_rope.png",
			"label":"I found a rope that I used to climb up to higher levels.",
			"voice":"res://assets/audio/story_narration/water10/found_a_rope.mp3"		
			},
		"get the blue crystal":{
			"image":"res://assets/comic/water10/blue_crystal.png",
			"label":"I found another blue crystal and picked it up.",
			"voice":"res://assets/audio/story_narration/water10/blue_crystal.mp3"		
			},
		"push button on":{
			"image":"res://assets/comic/water10/push_btn_platform.png",
			"label":"This button helped me ride this platform.",
			"voice":"res://assets/audio/story_narration/water10/button_ride_platform.mp3"		
			},
		"the lever moved on":{
			"image":"res://assets/comic/water10/lever.png",
			"label":"This lever lowered a log so I could get across to the door.",
			"voice":"res://assets/audio/story_narration/water10/lever_log.mp3"		
			},
		"get the green crystal":{
			"image":"res://assets/comic/water10/green_crystal.png",
			"label":"I found another green crystal. It was beautiful.",
			"voice":"res://assets/audio/story_narration/water10/green_crystal.mp3"		
			},
		"look at the sign":{
			"image":"res://assets/comic/water10/look_sign.png",
			"label":"The sign told me I needed something that chases away the darkness.",
			"voice":"res://assets/audio/story_narration/water10/look_sign.mp3"		
			},
		"get the yellow crystal":{
			"image":"res://assets/comic/water10/yellow_crystal.png",
			"label":"I picked up another yellow crystal. I was sure someone would need this.",
			"voice":"res://assets/audio/story_narration/water10/yellow_crystal.mp3"		
			},
		"get the lamp":{
			"image":"res://assets/comic/water10/get_lamp.png",
			"label":"I found a lamp. I thought it might help solve the riddle.",
			"voice":"res://assets/audio/story_narration/water10/found_lamp.mp3"		
			},
		"get the umbrella":{
			"image":"res://assets/comic/water10/get_umbrella.png",
			"label":"I found an umbrella. I wasn’t sure if I needed it but I took it anyway.",
			"voice":"res://assets/audio/story_narration/water10/found_umbrella.mp3"		
			},
		"get the red crystal":{
			"image":"res://assets/comic/water10/red_crystal.png",
			"label":"I found a fantastic, glowing red crystal.",
			"voice":"res://assets/audio/story_narration/water10/red_crystal.mp3"		
			},
		"use the umbrella in the hole":{
			"image":"res://assets/comic/water10/umbrella_hole.png",
			"label":"I put the umbrella in the hole. The door didn’t open. It must have been the wrong item.",
			"voice":"res://assets/audio/story_narration/water10/umbrella_hole.mp3"		
			},
		"use the lamp in the hole":{
			"image":"res://assets/comic/water10/lamp_hole.png",
			"label":"I put the lamp in the hole and the door opened. The lamp was the answer to the riddle.",
			"voice":"res://assets/audio/story_narration/water10/lamp_hole.mp3"		
			},
			},
	"Water11":{
		"get the alpha key":{
			"image":"res://assets/comic/water11/get_alpha_key.png",
			"label":"I found a key. I guessed it might help me open a door somewhere.",
			"voice":"res://assets/audio/story_narration/water11/found_key_one.mp3"	
			},
		"the alpha door opened":{
			"image":"res://assets/comic/water11/alpha_door_open.png",
			"label":"I was right about that key. It opened this door.",
			"voice":"res://assets/audio/story_narration/water11/right_about_key.mp3"
			},
		"get the cooking pot":{
			"image":"res://assets/comic/water11/get_pot.png",
			"label":"I found a cooking pot. It was heavy but I took it because it could have been useful.",
			"voice":"res://assets/audio/story_narration/water11/found_pot.mp3"	
			},
		"get the beta key":{
			"image":"res://assets/comic/water11/get_beta_key.png",
			"label":"I found another key. It was labelled, “The Beta Key”.",
			"voice":"res://assets/audio/story_narration/water11/found_beta_key.mp3"	
			},
		"the beta door opened":{
			"image":"res://assets/comic/water11/use_beta_key.png",
			"label":"I noticed the shape of the key matched the shape on the door.",
			"voice":"res://assets/audio/story_narration/water11/key_shape_match.mp3"	
			},
		"push button on":{
			"image":"res://assets/comic/water11/push_btn_log.png",
			"label":"I pushed this button so I could ride down with the log.",
			"voice":"res://assets/audio/story_narration/water11/push_btn_ride_log.mp3"	
			},
		"get the delta key":{
			"image":"res://assets/comic/water11/get_delta_key.png",
			"label":"I found another key underwater.",
			"voice":"res://assets/audio/story_narration/water11/key_underwater.mp3"	
			},
		"look at the sign":{
			"image":"res://assets/comic/water11/look_sign.png",
			"label":"The sign told me I was looking for something to keep me dry.",
			"voice":"res://assets/audio/story_narration/water11/look_sign.mp3"	
			},
		"get the umbrella":{
			"image":"res://assets/comic/water11/get_umbrella.png",
			"label":"I found an umbrella. It seemed like it would be useful.",
			"voice":"res://assets/audio/story_narration/water11/found_umbrella.mp3"	
			},
		"the delta door opened":{
			"image":"res://assets/comic/water11/use_delta_key.png",
			"label":"I used the key to get through the delta door.",
			"voice":"res://assets/audio/story_narration/water11/used_key_delta.mp3"	
			},
		"the lever moved on":{
			"image":"res://assets/comic/water11/use_lever_log.png",
			"label":"This lever lowered the log so I could get across.",
			"voice":"res://assets/audio/story_narration/water11/lever_lower_log.mp3"	
			},
		"get the green crystal":{
			"image":"res://assets/comic/water11/get_green_crystal.png",
			"label":"I found a green crystal hidden beneath the log.",
			"voice":"res://assets/audio/story_narration/water11/green_crystal.mp3"	
			},
		"the second lever moved on":{
			"image":"res://assets/comic/water11/lever_raise_log.png",
			"label":"I pulled this lever and it raised the log.",
			"voice":"res://assets/audio/story_narration/water11/lever_raise_log.mp3"	
			},
		"get the red crystal":{
			"image":"res://assets/comic/water11/get_red_crystal.png",
			"label":"I found a red crystal. It was very well hidden.",
			"voice":"res://assets/audio/story_narration/water11/red_crystal.mp3"	
			},
		"use the cooking pot in the hole":{
			"image":"res://assets/comic/water11/pot_in_hole.png",
			"label":"I put the cooking pot in the hole but nothing happened.",
			"voice":"res://assets/audio/story_narration/water11/pot_hole.mp3"	
			},
		"use the umbrella in the hole":{
			"image":"res://assets/comic/water11/umbrella_hole.png",
			"label":"The umbrella was the answer to the riddle. It sacrifices itself so I can stay dry.",
			"voice":"res://assets/audio/story_narration/water11/umbrella_hole.mp3"	
			},
			}

}

var temp_sentences=[]

var unlocked_levels = [
	"TheJourney",
	"TheVillage",
	"Rock1",
	"Rock2",
	"Rock3",
	"Rock4",
	"Lava5",
	"Lava6",
	"Lava7",
	"Lava8",
	"Water9",
	"Water10",
	"Water11"
]
#	"TheVillage",
#	"Lower1",
#	"VillageEnd"

var all_puzzle_items = [
	"the clock",
	"the mirror",
	"the boomerang",
	"the pen",
	"the telescope",
	"the bell",
	"the compass",
	"the umbrella",
	"the ring",
	"the padlock",
	"the glasses",
	"the cooking pot"
]

var single_inventory_items = [
	"the ladder",
	"the rope",
	"the roller skates",
	"the diving mask",
	"the climbing gloves",
	"the drone"
]

var use_touch_controls = false

var current_level := "Level1"
var save_level :=""

var 	load_from_door := false
var load_from_entry := false

var ladder_never_got := true

var button_never_pushed := true

var clicked_fire: TextureButton

func remove_worn_items() -> bool:
	if wearing_mask:
		if the_player.swimming:
			GlobalSignals.emit_signal("speak", "I can't take off the mask while swimming")
			return false
	wearing_mask = false
	wearing_coat = false
	wearing_gloves = false
	wearing_mask = false
	wearing_skates = false
	GlobalSignals.emit_signal("wear_skates", false)
	GlobalSignals.emit_signal("wear_gloves", false)
	GlobalSignals.emit_signal("wear_mask", false)
	GlobalSignals.emit_signal("wear_coat", false)
	return true

func worn_items_after_load():
	GlobalSignals.emit_signal("wear_skates", false)
	GlobalSignals.emit_signal("wear_gloves", false)
	GlobalSignals.emit_signal("wear_mask", false)
	GlobalSignals.emit_signal("wear_coat", false)
	if wearing_mask:
		GlobalSignals.emit_signal("wear_mask", true)
	elif wearing_skates:
		GlobalSignals.emit_signal("wear_skates", true)
	elif wearing_gloves:
		GlobalSignals.emit_signal("wear_gloves", true)
	elif wearing_coat:
		GlobalSignals.emit_signal("wear_coat", true)
	
func check_drone_inventory()->bool:
	if !using_drone:
		return true
	if GlobalVars.drone_carried_inventory.size() > 0:
		GlobalSignals.emit_signal("speak", "The drone can only carry one item at a time.")
		return false
	else:
		return true



#yield(get_tree().create_timer(1.8), "timeout")	
