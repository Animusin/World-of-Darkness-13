/mob/living/carbon/human/npc/proc/Aggro(var/mob/M, var/attacked = FALSE)
	if(attacked && danger_source != M)
		walk(src,0)
	if(M == src)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.vampire_faction == vampire_faction && !H.client)
			return
	if((stat != DEAD) && !HAS_TRAIT(M, TRAIT_DEATHCOMA))
		danger_source = M
		if(attacked)
			last_attacker = M
			if(health != last_health)
				last_health = health
				last_damager = M
	if(CheckMove())
		return
	if((last_danger_meet + 5 SECONDS) < world.time)
		last_danger_meet = world.time
		if(prob(50))
			if(!my_weapon)
				if(prob(50))
					emote("scream")
				else
					RealisticSay(pick(socialrole.help_phrases))
					Mugged(M)
			else
				RealisticSay(pick(socialrole.help_phrases))

/mob/living/carbon/human/npc/proc/Mugged(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/mypower = get_total_mentality()
		var/theirpower = H.get_total_social()
		if(mypower <= theirpower && prob(50))
			var/obj/item/stack/dollar/D = locate(/obj/item/stack/dollar) in contents
			if(D)
				var/turf/T = get_turf(src)
				D.forceMove(T)
				if(prob(50))
					var/witness_count = 0
					for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, src))
						if(NEPIC && NEPIC.stat != DEAD)
							witness_count++
					if(witness_count > 1)
						for(var/obj/item/police_radio/P in GLOB.police_radios)
							P.announce_crime("mugging", get_turf(src))
						for(var/obj/item/p25radio/police/P in GLOB.p25_radios)
							if(P.linked_network == "police")
								P.announce_crime("mugging", get_turf(src))
