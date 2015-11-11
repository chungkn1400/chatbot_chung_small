''
'' simple http-post example for Windows 
''
#Ifdef __FB_WIN32__
#include once "win/winsock2.bi"
/'#else
#include once "crt/netdb.bi"
#include once "crt/sys/socket.bi"
#include once "crt/netinet/in.bi"
#include once "crt/arpa/inet.bi"
#include once "crt/unistd.bi"
'/
#endif

const RECVBUFFLEN = 8192
const NEWLINE = !"\r\n"
Const DEFAULT_HOST = "www.freebasic.net"

declare sub doInit( )
declare sub doShutdown( )
declare sub getHostAndPath _
	( _
		byref src as string, _
		byref hostname as string, _
		byref path as string _
	)
declare function resolveHost( byref hostname as string ) as integer
declare sub reportError( byref msg as string )

/'dim Shared hostname as string
dim Shared path as string

Dim As Single lat=48.0,lon=2.0
Dim As String weatherurl="http://api.openweathermap.org/data/2.5/weather?lat="+Str(lat)+"&lon="+Str(lon)
hostname="http://www.freebasic.net"'api.openweathermap.org/data/2.5/"'weather?lat="+Str(lat)+"&lon="+Str(lon)

hostname="http://api.hostip.info/get_json.php?position=true"
path=""'weatherurl


hostname="http://overpass-api.de/api/interpreter?data=[out:json];%28node%28371597318%29;node%28371597317%29%29%3Bout%20skel%209%3B"
path=""

hostname="overpass-api.de"
path="/api/interpreter?data=[out:json];%28node%28371597318%29;node%28371597317%29%29%3Bout%20skel%209%3B"

hostname="api.openweathermap.org"
path="/data/2.5/weather?lat="+Str(lat)+"&lon="+Str(lon)


hostname="en.wikipedia.org"
'path="/w/api.php?action=opensearch&search="+wikikeysearch+"&limit=5&namespace=0&format=json&redirects=resolve&callback=mywikicallback";
path="/w/api.php?action=opensearch&search="+"lennon"+"&limit=5&namespace=0&format=json&redirects=resolve"
'/

Function httppost(ByRef hostname As string,ByRef path As string)As String 
	doInit( )

	'' check command-line
	'getHostAndPath( command( ), hostname, path )
	if( len( hostname ) = 0 ) then
		hostname = DEFAULT_HOST
	end if

	'' resolve name
	dim ip as integer
	dim s as SOCKET

	ip = resolveHost( hostname )
	if( ip = 0 ) then
		print "resolveHost(): invalid address"
		Sleep:end 1
	end if

	'' open socket
	s = opensocket( AF_INET, SOCK_STREAM, IPPROTO_TCP )
	if( s = 0 ) then
		reportError( "socket()" )
		Sleep:end 1
	end if

	'' connect to host
	dim sa as sockaddr_in
	sa.sin_port        = htons( 80 )
	sa.sin_family      = AF_INET
	sa.sin_addr.S_addr = ip

	if( connect( s, cast( PSOCKADDR, @sa ), sizeof( sa ) ) = SOCKET_ERROR ) then
		reportError( "connect()" )
		closesocket( s )
		Sleep:end 1
	end if

	'' send HTTP request
	dim sendbuffer as string
	sendBuffer = "GET /" + path + " HTTP/1.0" + NEWLINE + _
	             "Host: " + hostname + NEWLINE + _
	             "Connection: close" + NEWLINE + _
	             "User-Agent: GetHTTP 0.0" + NEWLINE + _
	             NEWLINE
	sendBuffer = "POST /" + path + " HTTP/1.0" + NEWLINE + _
	             "Host: " + hostname + NEWLINE + _
	             "Connection: close" + NEWLINE + _
	             "User-Agent: GetHTTP 0.0" + NEWLINE + _
	             NEWLINE

	if( send( s, sendBuffer, len( sendBuffer ), 0 ) = SOCKET_ERROR ) then
		reportError( "send()" )
		closesocket( s )
		Sleep:end 1
	end if

	'' receive until connection is closed
	dim recvbuffer as zstring * RECVBUFFLEN+1
	dim bytes as Integer
	Dim As String recvtext

	do 
		bytes = recv( s, recvBuffer, RECVBUFFLEN, 0 )
		if( bytes <= 0 ) then
			exit do
		end if

		'' add the null-terminator
		recvbuffer[bytes] = 0

		'' print buffer as a string
		'Print recvbuffer
		recvtext+=recvbuffer
	loop

	Print
	'Sleep
	'Print "recvbuffer="+recvbuffer
	

	'' close socket
	shutdown( s, 2 )
	closesocket( s )

	doShutdown( )
	
	Return recvtext
End Function 


sub getHostAndPath _
	( _
		byref src as string, _
		byref hostname as string, _
		byref path as string _
	)

	dim p as integer = instr( src, " " )
	if( p = 0 or p = len( src ) ) then
		hostname = trim( src )
		path = ""
	else
		hostname = trim( left( src, p-1 ) )
		path = trim( mid( src, p+1 ) )
	end if

end sub

function resolveHost( byref hostname as string ) as integer

	dim ia as in_addr
	dim hostentry as hostent ptr

	'' check if it's an ip address
	ia.S_addr = inet_addr( hostname )
	if ( ia.S_addr = INADDR_NONE ) then
		
		'' if not, assume it's a name, resolve it
		hostentry = gethostbyname( hostname )
		if ( hostentry = 0 ) then
			exit function
		end if
		
		function = *cast( integer ptr, *hostentry->h_addr_list )
	else
		'' just return the address
		function = ia.S_addr
	end if

end function

sub reportError( byref msg as string )
#ifdef __FB_WIN32__
	print msg; ": error #" & WSAGetLastError( )
#else
	perror( msg )
#endif
end sub

sub doInit( )
#ifdef __FB_WIN32__
	'' init winsock
	dim wsaData as WSAData
	if( WSAStartup( MAKEWORD( 1, 1 ), @wsaData ) <> 0 ) then
		print "Error: WSAStartup failed"
		end 1
	end if
#endif
end sub

sub doShutdown( )
#ifdef __FB_WIN32__
	'' quit winsock
	WSACleanup( )
#endif
end sub
