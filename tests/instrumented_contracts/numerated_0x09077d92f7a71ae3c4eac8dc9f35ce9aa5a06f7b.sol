1 pragma solidity ^0.4.8;
2 
3 contract SmartpoolVersion {
4     address    public poolContract;
5     bytes32    public clientVersion;
6     
7     mapping (address=>bool) owners;
8     
9     function SmartpoolVersion( address[3] _owners ) {
10         owners[_owners[0]] = true;
11         owners[_owners[1]] = true;
12         owners[_owners[2]] = true;        
13     }
14     
15     function updatePoolContract( address newAddress ) {
16         if( ! owners[msg.sender] ) throw;
17         
18         poolContract = newAddress;
19     }
20     
21     function updateClientVersion( bytes32 version ) {
22         if( ! owners[msg.sender] ) throw;
23         
24         clientVersion = version;
25     }
26 }