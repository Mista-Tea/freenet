--[[--------------------------------------------------------------------------
	FreeNet developer addon
	
	File name:
		sh_freenet.lua
		
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

local net     = net
local type    = type
local error   = error
local IsColor = IsColor

local MISSING_NAME = "Tried to start net message without providing a name (parameter #1 [string])"
local UNCHECKED_TYPE = "Tried to send net message with unchecked type (message: \"%s\" | type: %s)"

--[[--------------------------------------------------------------------------
-- Namespace Functions
--------------------------------------------------------------------------]]--

--[[--------------------------------------------------------------------------]]--
--
--	Below is a lookup table between value type <-> net.Write*() function.
--	It is used to ensure the most appropriate net function is called when writing
--	the value to the net message.
--
--	Unfortunately, since all numbers in Lua simply return "number" for their type,
--	differentiating between an int/uint/float/double/bit is not trivial. A slight
--	performance tradeoff has been made to simplify this problem: all numbers are
--	written as floats and read as floats. When sending any form of number via
--	FreeNet, be sure to read it back with net.ReadFloat().
--]]--
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

--[[--------------------------------------------------------------------------
--
-- 	fnet.Write( string, table )
--
--	Convenience function that will detect the type of (most) values and 
--	automatically write them to the current net message. 
--
--	NOTE: An exception will be raised when you try to send a net message
--	without a network string (net message name).
--
--	NOTE: An exception will be raised when an unchecked (unsupported) type 
--	is given. Should this happen, please report the type and value to the 
--	FreeNet Github page!
--
--	@param nwstr  - the name of the net message being written
--	@param values - the table of values to write to the current net message
--]]--
function fnet.Write( nwstr, values )
	if ( !nwstr and fnet.Errors:GetBool() ) then error( MISSING_NAME ) end

	net.Start( nwstr )
	
	local TYPE
	local value
	
	for i = 1, #values do
		value = values[i]
		TYPE = type( value )

		if ( !types[ TYPE ] ) then 
			error( UNCHECKED_TYPE:format( nwstr, TYPE ) )
		end
		
		types[ TYPE ]( value )
	end
end
