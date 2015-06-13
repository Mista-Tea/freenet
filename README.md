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

``` fnet.Send( "Example2", "GitHub <3", Color( 255, 0, 0 ), 100, { "John Doe", "Dohn Joe" } ) ```

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
