extends Node

signal vocab_button_pressed(word)
signal object_button_pressed()
signal add_with_preposition(prep)

signal sentence_checker(sentence)
signal sentence_clear()

signal sentence_bar_update()

signal remove_object()

signal deselect_clues()

signal update_on_hover(word)

signal remove_game_object_rope()

signal medicine_given()

signal tut_to_give()
signal tut_to_medicine()
signal tut_to_boy()
signal tut_to_girl()
signal medicine_pressed()
signal tut_done()
signal hide_pointer()
signal can_give_box()

signal boy_clicks()
signal girl_clicks()
signal lever_clicks()

signal tut_to_push()

signal hand_over_box()

signal convo_barriers(state)

signal button_pressed(btn)

signal refresh_inventory()

signal reset_vote_buttons(source_btn)

signal speak(message)

signal remove_speak_panel()

signal online_status(status)

signal reload_level()

signal table_pushed()

signal update_player_position(player_pos)

signal update_drone_position(drone_pos)

signal add_to_inventory_bar_from_drone(item)

signal add_to_inventory_bar(item)

signal add_to_inventory_bar_load(item)

signal add_to_inventory_list(label)

signal drone_items_to_player()

signal add_to_inventory_list_from_drone(label)

signal add_to_inventory_bar_drone(item)

signal add_to_inventory_list_drone(label)

signal close_hole()


signal remove_from_inventory_list(label)

signal remove_all_inventory()

signal remove_all_inventory_drone()

signal can_climb(climb_state)

signal release_drone(state)

signal shutdown_drone()

signal drop_ladder()

signal summon_ladder()

signal drop_rope()

signal place_ladder(position)

signal place_rope(position)

signal wear_skates(state)

signal wear_gloves(state)

signal place_on_shelf(sentence, shelf)

signal remove_from_shelf(item)

signal open_door(can_save)

signal close_door()

signal touching_door(state, level, entry_door)

signal item_placed_on_shelf(the_item)

signal glass_box_broken()

signal update_room_save()

signal remove_from_game_objects(item)

signal water_entered()

signal water_exited()

signal wear_mask(state)

signal wear_coat(state)

signal save_game()

signal load_game(entry)

signal changing_level()

signal menu_start_level(level)

signal fade_in()

signal fade_out(back_in)

signal save_sentence(sentence)

signal pause_player_movement(state)

signal dance()

signal xyzzy()

signal Timeup()

signal start_countdown(time)

signal crate_box_broken()

signal bad_guy_speak(text)

signal lever_broken(broken)

signal padlock_opened()

signal remove_forcefield()

signal bad_guy_fire()

signal conversation_time(full_convo, object)

signal elder_conversation_advance()

signal remove_sign_reminder()

signal treasure_received()

signal vanish_an_item(item)

signal door_opened_now_save()

signal check_shelves(can_save)

signal read_comic_panel(to_read)

signal show_saving_status(staus)

signal show_object_labels(state)

signal use_move_vector(vec)
signal touch_jump()

signal clicker()
signal collector()

signal i_can_fly()

signal speedster()

signal gravity_change(dir)

signal saw_the_sign()

signal pogo()


signal to_click_mode()
signal to_text_mode()
