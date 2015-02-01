scriptId = 'hu.jeremy.myo.plexcontroller'
scriptTitle = "Plex Connector"
scriptDetailsUrl = ""

rollReference=0
enabled=false

-- Functions for each pose

-- Fist enters a menu, or play-pause
function playPause()
	myo.debug( "Enter" )
	myo.keyboard( "return","press" )

	-- Notify Myo (vibrate)
	myo.vibrate( "short" )
end

-- FingersSpread escapes, gets out
function getOut()
	myo.debug( "Escape" )
	myo.keyboard( "escape", "press" )
end

-- Waving out should be hitting the right arrow
function goingRight()
	myo.debug( "Next" )
	myo.keyboard( "right_arrow", "press" )
end

-- Waving in hits the left arrow
function goingLeft()
	myo.debug( "Previous" )
	myo.keyboard( "left_arrow","press" )
end

-- Waving out when arm is rotated hits the up arrow
function goingUp()
	myo.debug( "Up" )
	myo.keyboard( "up_arrow", "press" )
end

-- Waving in when arm is rotated hits the down arrow
function goingDown()
	myo.debug( "Down" )
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

-- Get roll value in degrees
function getMyoRollDegrees()
	local rollValue = math.deg( myo.getRoll() )
	return rollValue
end

-- Handle rotations that go over 180 degrees
function degreeDiff(value, base)
	local diff = value - base

	if diff > 180 then
		diff = diff - 360
	elseif diff < -180 then
		diff = diff + 360
	end

	return diff
end

-- Regular check to see arm orientation (roll)
function onPeriodic()
	if ( myo.isUnlocked() ) then
		relativeRoll = degreeDiff( getMyoRollDegrees(), rollReference )
	end
end

-- Detect Myo poses, and assign functions to each one of them
function onPoseEdge(pose, edge)
	-- Let's start
	if ( edge == "on" ) then
		enabled=true
		rollReference = getMyoRollDegrees()

		if ( pose == "fist" ) then
			playPause()
		elseif ( pose == "fingersSpread" ) then
			getOut()
		elseif ( relativeRoll<-45 ) then
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
	end

end
