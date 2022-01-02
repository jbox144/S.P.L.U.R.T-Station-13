/mob/living/simple_animal/hostile/deathclaw/funclaw
	name = "Funclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match. This one seems to have a strange look in its eyes.."
	var/change_target_hole_cooldown = 0
	var/chosen_hole
	var/voremode = FALSE // Fixes runtime when grabbing victim
	gold_core_spawnable = NO_SPAWN // Admin only
	deathclaw_mode = "rape"

/mob/living/simple_animal/hostile/deathclaw/funclaw/gentle
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match. This one has the bedroom eyes.."
	deathclaw_mode = "gentle"

/mob/living/simple_animal/hostile/deathclaw/funclaw/abomination
	name = "Exiled Deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match. This one has a strange smell for some reason.."
	deathclaw_mode = "abomination"

/mob/living/simple_animal/hostile/deathclaw/funclaw/AttackingTarget()
	var/mob/living/M = target

	var/onLewdCooldown = FALSE
	var/wantsNoncon = FALSE

	if(get_refraction_dif() > 0)
		onLewdCooldown = TRUE

	if(M.client && M.client.prefs.nonconpref == "Yes")
		wantsNoncon = TRUE

	switch(deathclaw_mode)
		if("gentle")
			if(onLewdCooldown || !wantsNoncon)
				return // Do nothing
		if("abomination")
			if(onLewdCooldown || !wantsNoncon)
				return // Do nothing
		if("rape")
			if(onLewdCooldown || !wantsNoncon || M.health > 60)
				..() // Attack target
				return

	if(!M.pulledby)
		if(!M.buckled && !M.density)
			M.forceMove(src.loc)

		start_pulling(M, supress_message = TRUE)
		log_combat(src, M, "grabbed")
		M.visible_message("<span class='warning'>[src] violently grabs [M]!</span>", \
			"<span class='userdanger'>[src] violently grabs you!</span>")
		setGrabState(GRAB_NECK) //Instant neck grab

		return

	if(get_refraction_dif() > 0)
		..()
		return

	if(change_target_hole_cooldown < world.time)
		chosen_hole = null
		while (chosen_hole == null)
			pickNewHole(M)
		change_target_hole_cooldown = world.time + 100


	do_lewd_action(M)
	addtimer(CALLBACK(src, .proc/do_lewd_action, M), rand(8, 12))

	// Regular sex has an extra action per tick to seem less slow and robotic
	if(deathclaw_mode != "abomination" || M.client.prefs.unholypref != "Yes")
		addtimer(CALLBACK(src, .proc/do_lewd_action, M), rand(12, 16))


/mob/living/simple_animal/hostile/deathclaw/funclaw/proc/pickNewHole(mob/living/M)
	switch(rand(2))
		if(0)
			chosen_hole = CUM_TARGET_ANUS
		if(1)
			if(M.has_vagina())
				chosen_hole = CUM_TARGET_VAGINA
			else
				chosen_hole = CUM_TARGET_ANUS
		if(2)
			chosen_hole = CUM_TARGET_THROAT

/mob/living/simple_animal/hostile/deathclaw/funclaw/proc/do_lewd_action(mob/living/M)
	if(get_refraction_dif() > 0)
		return

	if(rand(1,7) == 7)
		playsound(loc, "modular_splurt/sound/lewd/deathclaw_grunt[rand(1, 5)].ogg", 70, 1, -1)

	switch(chosen_hole)
		if(CUM_TARGET_ANUS)
			if(tearSlot(M, SLOT_WEAR_SUIT))
				return
			if(tearSlot(M, SLOT_W_UNIFORM))
				return

			// Abomination deathclaws do other stuff instead
			if(deathclaw_mode == "abomination" && M.client.prefs.unholypref == "Yes")
				if(prob(1))
					do_grindmouth(M)
				else
					do_grindface(M)
				handle_post_sex(25, null, M)
			else
				do_anal(M)

		if(CUM_TARGET_VAGINA)
			if(tearSlot(M, SLOT_WEAR_SUIT))
				return
			if(tearSlot(M, SLOT_W_UNIFORM))
				return

			// Abomination deathclaws do other stuff instead
			if(deathclaw_mode == "abomination" && M.client.prefs.unholypref == "Yes")
				do_footjob_v(M)
				handle_post_sex(10, null, M)
			else
				do_vaginal(M)

		if(CUM_TARGET_THROAT)
			if(tearSlot(M, SLOT_HEAD))
				return
			if(tearSlot(M, SLOT_WEAR_MASK))
				return

			// Abomination deathclaws do other stuff instead
			if(deathclaw_mode == "abomination" && M.client.prefs.unholypref == "Yes")
				if(prob(1))
					do_faceshit(M)
				else
					do_facefart(M)
				handle_post_sex(25, null, M)
				shake_camera(M, 6, 1)
			else
				do_throatfuck(M)

/mob/living/simple_animal/hostile/deathclaw/funclaw/cum(mob/living/M)

	if(get_refraction_dif() > 0)
		return

	var/message

	if(!istype(M))
		chosen_hole = null

	switch(chosen_hole)
		if(CUM_TARGET_THROAT)
			if(M.has_mouth() && M.mouth_is_free())
				message = "shoves their fat reptillian cock deep down \the [M]'s throat and cums."
			else
				message = "cums on \the [M]'s face."
		if(CUM_TARGET_VAGINA)
			if(M.is_bottomless() && M.has_vagina())
				message = "rams its meaty cock into \the [M]'s pussy and fills it with sperm."
			else
				message = "cums on \the [M]'s belly."
		if(CUM_TARGET_ANUS)
			if(M.is_bottomless() && M.has_anus())
				message = "hilts its knot into \the [M]'s ass and floods it with Deathclaw jizz."
			else
				message = "cums on \the [M]'s backside."
		else
			message = "cums on the floor!"

	if(deathclaw_mode == "abomination" && M.client.prefs.unholypref == "Yes")
		message = "cums all over [M]'s body"

	M.reagents.add_reagent(/datum/reagent/consumable/semen, 30)
	new /obj/effect/decal/cleanable/semen(loc)
	playsound(loc, "modular_splurt/sound/lewd/deathclaw[rand(1, 2)].ogg", 70, 1, -1)
	visible_message("<font color=purple><b>\The [src]</b> [message]</font>")
	shake_camera(M, 6, 1)
	set_is_fucking(null ,null)

	refractory_period = world.time + rand(100, 150) // Sex cooldown
	set_lust(0) // Nuts at 400

	addtimer(CALLBACK(src, .proc/slap, M), 15)


/mob/living/simple_animal/hostile/deathclaw/funclaw/proc/slap(mob/living/M)
	playsound(loc, "modular_sand/sound/interactions/slap.ogg", 70, 1, -1)
	visible_message("<span class='danger'>\The [src]</b> slaps \the [M] right on the ass!</span>", \
			"<span class='userdanger'>\The [src]</b> slaps \the [M] right on the ass!</span>", null, COMBAT_MESSAGE_RANGE)

/mob/living/simple_animal/hostile/deathclaw/funclaw/proc/tearSlot(mob/living/M, slot)
	var/obj/item/W = M.get_item_by_slot(slot)
	if(W)
		M.dropItemToGround(W)
		playsound(loc, "sound/items/poster_ripped.ogg", 70, 1, -1)
		visible_message("<span class='danger'>\The [src]</b> tears off \the [M]'s clothes!</span>", \
				"<span class='userdanger'>\The [src]</b> tears off \the [M]'s clothes!</span>", null, COMBAT_MESSAGE_RANGE)
		return TRUE
	return FALSE
