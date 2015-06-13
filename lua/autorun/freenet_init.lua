--[[--------------------------------------------------------------------------
	FreeNet developer addon
	
	File name:
		freenet_init.lua
		
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

local hook = hook
local include = include
local AddCSLuaFile = AddCSLuaFile

--[[--------------------------------------------------------------------------
-- Namespace Functions
--------------------------------------------------------------------------]]--

function fnet.Initialize()

	if ( SERVER ) then
	
		include( "freenet/sh_freenet_cvars.lua" )
		include( "freenet/sv_freenet.lua" )
		include( "freenet/sh_freenet.lua" )
		
		AddCSLuaFile( "freenet/sh_freenet_cvars.lua" )
		AddCSLuaFile( "freenet/sh_freenet.lua" )
		AddCSLuaFile( "freenet/cl_freenet.lua" )
		
	else
		
		include( "freenet/sh_freenet_cvars.lua" )
		include( "freenet/sh_freenet.lua" )
		include( "freenet/cl_freenet.lua" )
		
	end
	
	MsgC( Color(0,255,0), "[FreeNet] ", Color(255,255,255), "Addon loaded successfully\n" )
end
hook.Add( "Initialize", "FreeNet", fnet.Initialize )
