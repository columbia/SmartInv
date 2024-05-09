1 pragma solidity ^0.4.23;
2 
3 contract TokenReclaim{
4     mapping (address=>string) internal _ethToSphtx;
5     mapping (string =>string) internal _accountToPubKey;
6     event AccountRegister (address ethAccount, string sphtxAccount, string pubKey);
7 
8     function register(string name, string pubKey) public{
9         require(bytes(name).length >= 3 && bytes(name).length <= 16);
10         bytes memory b = bytes(name);
11         require( (b[0] >='a' && b[0] <='z') || (b[0] >='0' && b[0] <= '9'));
12         for(uint i=1;i< bytes(name).length; i++){
13             require( (b[i] >='a' && b[i] <='z') || (b[i] >='0' && b[i] <= '9') || b[i] == '-' || b[i] =='.'  );
14         }
15         require(bytes(pubKey).length <= 64 && bytes(pubKey).length >= 50 );
16 
17         require(bytes(_ethToSphtx[msg.sender]).length == 0 || keccak256(bytes((_ethToSphtx[msg.sender]))) ==  keccak256(bytes(name)));//check that the address is not yet registered;
18 
19         require(bytes(_accountToPubKey[name]).length == 0 || keccak256(bytes((_ethToSphtx[msg.sender]))) ==  keccak256(bytes(name))); //check that the name is not yet used
20         _accountToPubKey[name] = pubKey;
21         _ethToSphtx[msg.sender] = name;
22         emit AccountRegister(msg.sender, name, pubKey);
23     }
24 
25     function account(address addr) constant public returns (string){
26         return _ethToSphtx[addr];
27     }
28 
29     function keys(address addr) constant public returns (string){
30         return _accountToPubKey[_ethToSphtx[addr]];
31     }
32 
33     function nameAvailable(string name) constant public returns (bool){
34         if( bytes(_accountToPubKey[name]).length != 0 )
35            return false;
36         if(bytes(name).length < 3 && bytes(name).length > 16)
37            return false;
38         bytes memory b = bytes(name);
39         if( (b[0] < 'a' || b[0] > 'z') && ( b[0] < '0' || b[0] > '9' ) )
40            return false;
41         for(uint i=1;i< bytes(name).length; i++)
42            if( (b[0] < 'a' || b[0] > 'z') && ( b[0] < '0' || b[0] > '9' ) && b[i] != '-' && b[i] != '.' )
43               return false;
44         return true;
45     }
46 
47 
48 }