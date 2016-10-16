--[[--------------------------------------------------------------------------
	FreeNet developer addon
	
	File name:
		sv_freenet.lua
		
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

local net    = net
local print  = print
local unpack = unpack

local debug = "[FreeNet] %s( Str=%s, To=<%s>, Val=<%s> )"

--[[--------------------------------------------------------------------------
-- Namespace Functions
--------------------------------------------------------------------------]]--

--[[--------------------------------------------------------------------------
--
-- 	fnet.Broadcast( string, varags )
--
--	Wrapper function for net.Broadcast. Sends a net message to all connected 
--	players currently on the server.
--
--	http://wiki.garrysmod.com/page/net/Broadcast
--
--	@param nwstr - the name of the net message
--	@param ...   - varags (comma separated list of values)
--]]--
function fnet.Broadcast( nwstr, ... )
	if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.Broadcast", nwstr or "nil", "", unpack( {...} ) or "nil" ) ) end

	fnet.Write( nwstr, {...} )
	net.Broadcast()
end

--[[--------------------------------------------------------------------------
--
-- 	fnet.Send( string, player or table, varags )
--
--	Wrapper function for net.Send. Sends a net message to the specified player
--	or table of players.
--
--	http://wiki.garrysmod.com/page/net/Send
--
--	@param nwstr - the name of the net message
--	@param plys  - the player(s) to send the net message to
--	@param ...   - varags (comma separated list of values)
--]]--
function fnet.Send( nwstr, plys, ... )
	if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.Sent", nwstr or "nil", plys or "nil", unpack( {...} ) or "nil" ) ) end

	fnet.Write( nwstr, {...} )
	net.Send( plys )
end

--[[--------------------------------------------------------------------------
--
-- 	fnet.SendOmit( string, player or table, varags )
--
--	Wrapper function for net.SendOmit. Sends a net message to all connected
--	players, EXCLUDING the given player.
--
--	http://wiki.garrysmod.com/page/net/SendOmit
--
--	@param nwstr - the name of the net message
--	@param ply   - the player entity to omit (ignore) from the message
--	@param ...   - varags (comma separated list of values)
--]]--
function fnet.SendOmit( nwstr, ply, ... )
	if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendOmit", nwstr or "nil", ply or "nil", unpack( {...} ) or "nil" ) ) end
	if ( not ply and fnet.Errors:GetBool() ) then error( "Tried to send net message without an omitted player (parameter #2 [player/table])" ) end
	
	fnet.Write( nwstr, {...} )
	net.SendOmit( ply )
end

--[[--------------------------------------------------------------------------
--
-- 	fnet.SendPVS( string, vector, varags )
--
--	Wrapper function for net.SendPVS. Sends a net message to any players that
--	are within the given vector's PVS (potentially visible set).
--	I.e., to players that potentially see the given vector position.
--
--	http://wiki.garrysmod.com/page/net/SendPVS
--
--	@param nwstr - the name of the net message
--	@param vec   - the vector position
--	@param ...   - varags (comma separated list of values)
--]]--
function fnet.SendPVS( nwstr, vec, ... )
	if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendPVS", nwstr or "nil", vec or "nil", unpack( {...} ) or "nil" ) ) end
	if ( not (vec and isvector( vec )) and fnet.Errors:GetBool() ) then error( "Tried to send net message without PVS position (parameter #2 [vector])" ) end 
	
	fnet.Write( nwstr, {...} )
	net.SendPVS( vec )
end

--[[--------------------------------------------------------------------------
--
-- 	fnet.SendPAS( string, vector, varags )
--
--	Wrapper function for net.SendPAS. Sends a net message to any players that
--	are within the given vector's PAS (potentially audible set).
--	I.e., to players that potentially hear sound at the given vector position.
--
--	http://wiki.garrysmod.com/page/net/SendPAS
--
--	@param nwstr - the name of the net message
--	@param vec   - the vector position
--	@param ...   - varags (comma separated list of values)
--]]--
function fnet.SendPAS( nwstr, vec, ... )
	if ( fnet.Debug:GetBool() ) then print( debug:format( "fnet.SendPAS", nwstr or "nil", vec or "nil", unpack( {...} ) or "nil" ) ) end
	if ( not (vec and isvector( vec )) and fnet.Errors:GetBool() ) then error( "Tried to send net message without PAS position (parameter #2 [vector])" ) end
	
	fnet.Write( nwstr, {...} )
	net.SendPAS( vec )
end
