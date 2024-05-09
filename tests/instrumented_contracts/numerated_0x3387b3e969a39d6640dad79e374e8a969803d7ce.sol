1 pragma solidity >= 0.4.24;
2 
3 contract against_NS_for_IPFS {
4     mapping(bytes32 => string) public nsname;
5 	
6     string public name = "AGAINST NS";
7     string public symbol = "AGAINST";
8     string public comment = "AGAINST NS for IPFS";
9     address internal owner;
10 	
11 	constructor() public {
12        owner = address(msg.sender); 
13     }
14 	
15 	function setNS(bytes32 _nsname,string _hash) public {
16 	   if (msg.sender == owner) {
17 	     nsname[_nsname] = _hash;
18 	   }
19 	}
20 }