minetest.register_node('conway_game_of_life:live_cell', {
	description = 'live_cell',
	tiles = {'live_cell.png'},
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	drop = 'conway_game_of_life:live_cell',
	light_source = 3,
	on_timer = function(pos)
		minetest.set_node(pos, {name = 'conway_game_of_life:dead_cell'})
	end
})
minetest.register_node('conway_game_of_life:dead_cell', {
	description = 'dead_cell',
	tiles = {'dead_cell.png'},
	is_ground_content = true,
	groups = {cracky=3, stone=1},
	drop = 'conway_game_of_life:dead_cell',
	on_timer = function(pos)
		minetest.set_node(pos, {name = 'conway_game_of_life:live_cell'})
	end
})

local lifegame = true

minetest.register_abm{
	label = 'life',
	nodenames = {'conway_game_of_life:dead_cell', 'conway_game_of_life:live_cell'},
	neighbors = 'air',
	interval = 1,
	chance = 1,
	action = function(pos)
		if lifegame then return end
		
		local _, nodes_count = minetest.find_nodes_in_area(
			vector.add(pos, -1), vector.add(pos, 1),
			{
				'conway_game_of_life:live_cell'
			}
		)
		local count = nodes_count['conway_game_of_life:live_cell']

		local node = minetest.get_node(pos).name
		local timer = minetest.get_node_timer(pos)

		if count == 3 and node == 'conway_game_of_life:dead_cell' then
			timer:set(0.5, 0)
		elseif (count < 3 or count > 4) and node == 'conway_game_of_life:live_cell' then
			timer:set(0.5, 0)
		end
	end
}

minetest.register_chatcommand("lifegame", {
	params = "[true|false]",
	description = "Run game of life",
	func = function(name, param)
		if param == 'true' then
			lifegame = false
		elseif param == 'false' then
			lifegame = true
		else
			minetest.chat_send_player(name, 'please use true or false')
		end
	end,
})
