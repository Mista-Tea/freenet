--[[--------------------------------------------------------------------------
	FreeNet developer addon
	
	File name:
		freenet.lua
		
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
local error             = error
local unpack            = unpack
local Format            = Format
local player            = player
local IsValid           = IsValid
local IsColor           = IsColor
local tonumber          = tonumber
local CreateConVar      = CreateConVar
local RunConsoleCommand = RunConsoleCommand

--[[--------------------------------------------------------------------------
-- Namespace Functions
--------------------------------------------------------------------------]]--

fnet.Errors = CreateConVar( "freenet_errors", "1", bit.bor( FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Sets whether description (1) or default (0) error messages are printed to console" )
fnet.Debug  = CreateConVar( "freenet_debug",  "0", bit.bor( FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Sets whether developer messages should be printed to console (1) or not (0)" )

if ( SERVER ) then
	
	local debug = "[FreeNet] %s( Str=%s, To=<%s>, Val=<%s> )"
	
	function fnet.Broadcast( nwstr, ... )
		if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.Broadcast", nwstr or "nil", "", unpack( {...} ) or "nil" ) ) end
	
		fnet.Write( nwstr, {...} )
		net.Broadcast()
	end
	
	function fnet.Send( nwstr, plys, ... )
		if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.Sent", nwstr or "nil", plys or "nil", unpack( {...} ) or "nil" ) ) end
	
		fnet.Write( nwstr, {...} )
		net.Send( plys )
	end
	
	function fnet.SendOmit( nwstr, ply, ... )
		if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendOmit", nwstr or "nil", ply or "nil", unpack( {...} ) or "nil" ) ) end
		if ( not ply and fnet.Errors:GetBool() ) then error( "Tried to send net message without an omitted player (parameter #2 [player/table])" ) end
		
		fnet.Write( nwstr, {...} )
		net.SendOmit( ply )
	end
	
	function fnet.SendPVS( nwstr, vec, ... )
		if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendPVS", nwstr or "nil", vec or "nil", unpack( {...} ) or "nil" ) ) end
		if ( not (vec and isvector( vec )) and fnet.Errors:GetBool() ) then error( "Tried to send net message without PVS position (parameter #2 [vector])" ) end 
		
		fnet.Write( nwstr, {...} )
		net.SendPVS( vec )
	end

	function fnet.SendPAS( nwstr, vec, ... )
		if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendPAS", nwstr or "nil", vec or "nil", unpack( {...} ) or "nil" ) ) end
		if ( not (vec and isvector( vec )) and fnet.Errors:GetBool() ) then error( "Tried to send net message without PAS position (parameter #2 [vector])" ) end
		
		fnet.Write( nwstr, {...} )
		net.SendPAS( vec )
	end
	
	local function validateArg( ply, arg )
		if ( not ply:IsAdmin() ) then return false end
		
		local num = tonumber( arg )
		if ( not num ) then return false end
		
		return num >= 1 and "1" or "0"
	end
	
	concommand.Add( "freenet_enable_errors", function( ply, cmd, args )
		local override = hook.Run( "FreeNetErrors", ply )
		
		if ( override == false ) then return end
		local arg = validateArg( ply, args[1] )
		if ( not arg ) then return end
		
		RunConsoleCommand( "freenet_errors", arg )
	end, "Sets whether description (1) or default (0) error messages are printed to console", 0 )

	concommand.Add( "freenet_enable_debug", function( ply, cmd, args )
		local override = hook.Run( "FreeNetDebug", ply )
		
		if ( override == false ) then return end
		local arg = validateArg( ply, args[1] )
		if ( not arg ) then return end
		
		RunConsoleCommand( "freenet_debug", arg )
	end, "Sets whether developer messages should be printed to console (1) or not (0)", 0 )
	
elseif ( CLIENT ) then
	
	function fnet.SendToServer( nwstr, ... )
		fnet.Write( nwstr, { ... } )
		net.SendToServer()
	end
	
end

local MISSING_NAME = "Tried to start net message without providing a name (parameter #1 [string])"
local UNCHECKED_TYPE = "Tried to send net message with unchecked type (message: \"%s\" | type: %s)"

local types = {
	string  = net.WriteString,
	Entity  = net.WriteEntity,
	Player  = net.WriteEntity,
	NPC     = net.WriteEntity,
	Vehicle = net.WriteEntity,
	Weapon  = net.WriteEntity,
	Vector  = net.WriteVector,
	boolean = net.WriteBool,
	number  = net.WriteFloat,
	table   = function( v ) 
				if ( IsColor( v ) ) then net.WriteColor( v ) 
				else                     net.WriteTable( v ) end 
			end,
}

function fnet.Write( nwstr, values )
	if ( not nwstr and fnet.Errors:GetBool() ) then error( MISSING_NAME ) end

	net.Start( nwstr )
	
	local TYPE
	local value
	
	for i = 1, #values do
		value = values[i]
		TYPE = type( value )

		if ( not types[ TYPE ] ) then 
			error( UNCHECKED_TYPE:format( nwstr, TYPE ) )
		end
		
		types[ TYPE ]( value )
	end
end

MsgC( Color(0,255,0), "[FreeNet] ", Color(255,255,255), "Addon loaded successfully\n" )
