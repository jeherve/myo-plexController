scriptId = 'hu.jeremy.myo.plexcontroller'
scriptTitle = "Plex Connector"
scriptDetailsUrl = ""

centreRoll = 0

deltaRoll = 0

ROLL_DEADZONE = 1

PI = 3.1416
TWOPI = PI * 2

-- Functions for each pose

-- Fist enters a menu, or play-pause
function playPause()
	--myo.debug( "Enter" )
	myo.keyboard( "return","press" )

	-- Notify Myo (vibrate)
	myo.vibrate( "short" )
end

-- FingersSpread escapes, gets out
function getOut()
	--myo.debug( "Escape" )
	myo.keyboard( "escape", "press" )
end

-- Waving out should be hitting the right arrow
function goingRight()
	--myo.debug( "Next" )
	myo.keyboard( "right_arrow", "press" )
end

-- Waving in hits the left arrow
function goingLeft()
	--myo.debug( "Previous" )
	myo.keyboard( "left_arrow","press" )
end

-- Waving out when arm is rotated hits the up arrow
function goingUp()
	--myo.debug( "Up" )
	myo.keyboard( "up_arrow", "press" )
end

-- Waving in when arm is rotated hits the down arrow
function goingDown()
	--myo.debug( "Down" )
	myo.keyboard( "down_arrow", "press" )
end

-- App detection
-- Check that we're in the Plex Home Theater app
function onForegroundWindowChange(app, title)
	-- return platform == "MacOS" and app == "com.plexapp.plexhometheater" or
	--	platform == "Windows" and app == "PlexHomeTheater.exe"
	return true
end

-- Helpers

-- Zero the roll on unlock
function onUnlock()
	currentRoll = 0
	deltaRoll = 0
end

-- Regular check to see arm orientation (roll)
function onPeriodic()
	local currentRoll = myo.getRoll()
	deltaRoll = calculateDeltaRadians(currentRoll, centreRoll);
end

function calculateDeltaRadians(currentRoll, centreRoll)
	local deltaRoll = currentRoll - centreRoll

	if (deltaRoll > PI) then
		deltaRoll = deltaRoll - TWOPI
	elseif(deltaRoll < -PI) then
		deltaRoll = deltaRoll + TWOPI
	end

	return deltaRoll
end

-- Detect Myo poses, and assign functions to each one of them
function onPoseEdge(pose, edge)
	-- Let's start
	if ( edge == "on" ) then
		if ( pose == "fist" ) then
			playPause()
		elseif ( pose == "fingersSpread" ) then
			getOut()
		elseif ( math.abs(deltaRoll) < ROLL_DEADZONE ) then
			if ( pose == "waveOut" ) then
				goingUp()
			elseif ( pose == "waveIn") then
				goingDown()
			end
		elseif ( pose == "waveIn" ) then
			goingLeft()
		elseif ( pose == "waveOut" ) then
			goingRight()
		end

	-- Extend unlock and notify user
	myo.unlock("timed")

	end
end
