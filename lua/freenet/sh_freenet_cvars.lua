--[[--------------------------------------------------------------------------
	FreeNet developer addon
	
	File name:
		sh_freenet_cvars.lua
		
	Author:
		Mista-Tea ([IJWTB] Thomas)
		
	License:
		The MIT License (MIT)
		Copyright (c) 2014 Mista-Tea
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
		
	Changelog:
		- Created June 11th, 2015
----------------------------------------------------------------------------]]

--[[--------------------------------------------------------------------------
-- Namespace Tables
--------------------------------------------------------------------------]]--

fnet = fnet or {}

--[[--------------------------------------------------------------------------
-- Localized Functions & Variables
--------------------------------------------------------------------------]]--

local bit               = bit
local net               = net
local util              = util
local math              = math
local type              = type
local chat              = chat
local hook              = hook
local unpack            = unpack
local Format            = Format
local player            = player
local IsValid           = IsValid
local tonumber          = tonumber
local CreateConVar      = CreateConVar
local RunConsoleCommand = RunConsoleCommand

--[[--------------------------------------------------------------------------
-- Namespace Functions
--------------------------------------------------------------------------]]--

-- This cvar is used to print more descriptive error messages than the default errors
-- For example, forgetting to supply a net message name and then calling net.Start()
fnet.Errors = CreateConVar( "freenet_errors", "1", bit.bor( FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Sets whether description (1) or default (0) error messages are printed to console" )

-- This cvar controls outputting developer info to console (disabled by default)
fnet.Debug = CreateConVar( "freenet_debug",   "0", bit.bor( FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Sets whether developer messages should be printed to console (1) or not (0)" )

if ( SERVER ) then

	--[[--------------------------------------------------------------------------
	--
	-- 	validateArg( player, * )
	--
	--	Convenience function for ensuring a player has the right to change a CVar
	--	and has supplied a valid argument.
	--
	--	NOTE: Players MUST be an Admin according to their usergroup (ply:GetUserGroup()).
	--	
	--]]--
	local function validateArg( ply, arg )
		if ( not ply:IsAdmin() ) then return false end
		
		local num = tonumber( arg )
		if ( not num ) then return false end
		
		return num >= 1 and "1" or "0"
	end


	--[[--------------------------------------------------------------------------
	--
	-- 	CCMD :: freenet_enable_errors (1/0)
	--
	--	Wrapper ccmd around the freenet_errors CVar. Allows server admins to change
	--	the CVar from their client console without needing to access the server
	--	console directly.
	--]]--
	concommand.Add( "freenet_enable_errors", function( ply, cmd, args )
		local override = hook.Run( "FreeNetErrors", ply )
		
		if ( override == false ) then return end
		local arg = validateArg( ply, args[1] )
		if ( not arg ) then return end
		
		RunConsoleCommand( "freenet_errors", arg )
	end, "Sets whether description (1) or default (0) error messages are printed to console", 0 )

	--[[--------------------------------------------------------------------------
	--
	-- 	CCMD :: freenet_enable_debug (1/0)
	--
	--	Wrapper ccmd around the freenet_debug CVar. Allows server admins to change
	--	the CVar from their client console without needing to access the server
	--	console directly.
	--]]--
	concommand.Add( "freenet_enable_debug", function( ply, cmd, args )
		local override = hook.Run( "FreeNetDebug", ply )
		
		if ( override == false ) then return end
		local arg = validateArg( ply, args[1] )
		if ( not arg ) then return end
		
		RunConsoleCommand( "freenet_debug", arg )
	end, "Sets whether developer messages should be printed to console (1) or not (0)", 0 )
	
end
