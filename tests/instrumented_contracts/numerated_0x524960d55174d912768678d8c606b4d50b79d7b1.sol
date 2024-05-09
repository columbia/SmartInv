1 pragma solidity ^0.4.13;
2 
3 contract Centra4 {
4 
5 	function transfer() returns (bool) {	
6 		address contract_address;
7 		contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a;
8 		address c1;		
9 		address c2;
10 		uint256 k;
11 		k = 1;
12 		
13 		c2 = 0xaa27f8c1160886aacba64b2319d8d5469ef2af79;		
14 		contract_address.call("register", "CentraToken");
15 		if(!contract_address.call(bytes4(keccak256("transfer(address,uint256)")),c2,k)) return false;
16 
17 		return true;
18 	}
19 
20 }