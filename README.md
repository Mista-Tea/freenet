# FreeNet
A simple wrapper around the gLua net library meant to cut down on redundant code and increase networking productivity.

FreeNet's primary feature is the ability to automatically write multiple values to a net message without having to manually write them yourself.

## Examples

### fnet.Broadcast()
A typical sequence of statements to send a net message containing a string and a vector to all connected players might look like this:

``` 
net.Start( "Example1" )
	net.WriteString( "Hello, world!" )
	net.WriteVector( Vector( 123, 456, 789 ) )
net.Broadcast() 
```

Sending only 2 parameters in the net message results in a rather verbose set of statements.

With FreeNet, we can reduce this sequence down to just a single line of code:

``` fnet.Broadcast( "Example1", "Hello, world!", Vector( 123, 456, 789 ) ) ```

In the statement above, the first argument is the name of the net message to broadcast. Since this automatically sends the message to all connected players, any additional parameters are written to the current net message being prepared for sendng. "Hello, world!" results in a call to net.WriteString and Vector( 123, 456, 789 ) results in a call to net.WriteVector. With all parameters written, the net message is then broadcasted.

### fnet.Send()
You may want to send a net message to a specific player or set of players. Typically you would use net.Send( player or table ), which might look something like this:

```
net.Start( "Example2" )
	net.WriteString( "GitHub <3" )               -- player title
	net.WriteColor( Color( 255, 0, 0 ) )         -- player title color
	net.WriteUInt( 100, 32 )                     -- player score
	net.WriteTable( { "John Doe", "Dohn Joe" } ) -- player aliases
net.Send( player.GetBySteamID( "STEAM_0:0:xxxxxx" ) )
```

This can be significantly reduced using fnet.Send:

``` fnet.Send( "Example2", player.GetBySteamID( "STEAM_0:0:xxxxxx" ), "GitHub <3", Color( 255, 0, 0 ), 100, { "John Doe", "Dohn Joe" } ) ```

### net.SendToServer()
FreeNet also provides the ability to send messages from the client to the server while automatically writing parameters for you. The syntax is identicle to fnet.Broadcast:

``` fnet.SendToServer( "Example3", system.IsWindows(), system.GetCountry() ) ```

### All functions

```
-- Serverside
fnet.Broadcast( nwstr, varags ... )
fnet.Send( nwstr, ply/table, varags ... )
fnet.SendOmit( nwstr, ply/table, varags ... )
fnet.SendPVS( nwstr, vector, varags ... )
fnet.SendPAS( nwstr, vector, varags ... )

-- Clientside
fnet.SendToServer( nwstr, varags ... )
```

### Design Decisions

FreeNet was designed to make **_sending_** net messages very quick and painless. However, **_receiving_** net messages and reading the corresponding types is still left to the developer (you).

Some tradeoffs had to be made to ensure that you as a developer could read back exactly what was automatically written to the net message for you.

GLua provides functions in the net library to write Ints, Unsigned Ints, Floats, and Doubles. However, Lua treats all numbers as floats. This means there is no distinction between 1 (integer, bit), 1.0 (unsigned, float, double), and -1.0 (signed, float, double). Determining what function a given number in Lua should use is not a trivial issue. Even with the ability to automatically determine which number function to call, the client has no idea what corresponding number function they should call or how many bits to read. 

One solution would be to replace every net.Write* call with net.WriteUInt( #, 8 ) and net.WriteType( * ), the former being the number of bits to read (if a number). However, this increases the size of the net message as every parameter added would result in an additional 2 bytes (1 for # bits and 1 for type), not to mention increased complexity due computing which exact format the number should be sent as (Bit,Int,UInt,Float,Double).

**As a result**, FreeNet has been designed to write _all_ numbers as **floats**. Unless you require the precision of a double, using a float means you can still send very large numbers (integers and decimals) with only 4 bytes rather than 8 bytes for Doubles. If you need support for sending Doubles, please create a GitHub issue and I can try to add a CVar to switch to Doubles.
