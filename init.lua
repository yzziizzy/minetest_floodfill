




minetest.register_craftitem("floodfill:bucket", {
	description = "Floodfill Magic Bucket",
	inventory_image = "bucket.png^[colorize:gold:80",
	stack_max = 1,
	liquids_pointable = true,
	on_use = function(itemstack, player, pointed_thing)
		
		if pointed_thing.type ~= "node" then
			return
		end

		local opos = pointed_thing.under
		local node = minetest.get_node(opos)
		if node.name ~= "default:water_source"  and node.name ~= "default:water_flowing" then
			return
		end
		
		local radius = 10
		local visited = {}
		local stack = { opos }
		
		while #stack > 0 do
			-- pop this node
			local cpos = table.remove(stack)
			local chash = minetest.hash_node_position(cpos)
			if visited[chash] == nil then
				visited[chash] = 1
				
				local cnode = minetest.get_node(cpos)
				local def = node and minetest.registered_nodes[cnode.name]
				if node.name == "air" or def.buildable_to then
					minetest.add_node(cpos, {name = "default:water_source"})
				
					
					if math.abs(opos.x - cpos.x) < radius and math.abs(opos.z - cpos.z) < radius then
						table.insert(stack, {x=cpos.x + 1, y=cpos.y, z=cpos.z})
						table.insert(stack, {x=cpos.x - 1, y=cpos.y, z=cpos.z})
						table.insert(stack, {x=cpos.x, y=cpos.y, z=cpos.z + 1})
						table.insert(stack, {x=cpos.x, y=cpos.y, z=cpos.z - 1})
					end
				end
			end
		end
		
	end,
})




minetest.register_craft({
	output = 'floodfill:bucket',
	type = "shapeless",
	recipe = {'default:bucket_empty', 'default:gold_ingot'},
})

