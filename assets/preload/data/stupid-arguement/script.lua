-- Script by Shadow Mario
-- Customized for Simplicity by Kevin Kuntz
function onCreate()
	makeAnimationList();
	makeOffsets();
	
	-- boxing guy
	makeAnimatedLuaSprite('dog', 'characters/Cerberus', defaultOpponentX + 300, defaultOpponentY + 200);
	addAnimationByPrefix('dog', 'idle', 'Cerberus idle dance', 24, false);
	addAnimationByPrefix('dog', 'singLEFT', 'Cerberus Sing Note LEFT', 24, false);
	addAnimationByPrefix('dog', 'singDOWN', 'Cerberus Sing Note DOWN', 24, false);
	addAnimationByPrefix('dog', 'singUP', 'Cerberus Sing Note UP', 24, false);
	addAnimationByPrefix('dog', 'singRIGHT', 'Cerberus Sing Note RIGHT', 24, false);
	
	addLuaSprite('dog', true);

	playAnimation('dog', 0, true);
end

animationsList = {}
holdTimers = {dog = -1.0};
noteDatas = {dog = 0};
function makeAnimationList()
	animationsList[0] = 'idle';
	animationsList[1] = 'singLEFT';
	animationsList[2] = 'singDOWN';
	animationsList[3] = 'singUP';
	animationsList[4] = 'singRIGHT';
end

offsetsdog = {};
function makeOffsets()
	offsetsdog[0] = {x = 0, y = 0}; --idle
	offsetsdog[1] = {x = -84, y = 8}; --left
	offsetsdog[2] = {x = -44, y = 3}; --down
	offsetsdog[3] = {x = -90, y = 30}; --up
	offsetsdog[4] = {x = -83, y = 10}; --right
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'BARK' then
		if not isSustainNote then
			noteDatas.dog = direction;
		end	
	characterToPlay = 'dog'
	animToPlay = noteDatas.dog;
	holdTimers.dog = 0;
			
	playAnimation(characterToPlay, animToPlay, true);
	end
end

function onUpdate(elapsed)
	holdCap = stepCrochet * 0.004;
	if holdTimers.dog >= 0 then
		holdTimers.dog = holdTimers.dog + elapsed;
		if holdTimers.dog >= holdCap then
			playAnimation('dog', 0, false);
			holdTimers.dog = -1;
		end
	end
end

function onCountdownTick(counter)
	beatHitDance(counter);
end

function onBeatHit()
	beatHitDance(curBeat);
end

function beatHitDance(counter)
	if counter % 2 == 0 then
		if holdTimers.dog < 0 then
			playAnimation('dog', 0, false);
		end
	end
end

function playAnimation(character, animId, forced)
	-- 0 = idle
	-- 1 = singLEFT
	-- 2 = singDOWN
	-- 3 = singUP
	-- 4 = singRIGHT
	animName = animationsList[animId];
	--debugPrint(animName);
	if character == 'dog' then
		objectPlayAnimation('dog', animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
		setProperty('dog.offset.x', offsetsdog[animId].x);
		setProperty('dog.offset.y', offsetsdog[animId].y);
	end
end