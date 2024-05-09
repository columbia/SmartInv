1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 contract DocumentRegistry {
7 
8 
9 
10 
11 	mapping(string => uint256) registry;
12 
13 
14 
15 
16 	function register(string hash) public {
17 		
18 		//REQUIRE THAT THE HASH HAS NOT BEEN REGISTERED BEFORE
19 		require(registry[hash] == 0);
20 		
21 		//REGISTER NEW HASH WITH CURRENT BLOCK'S TIMESTAMP
22 		registry[hash] = block.timestamp;
23 	}
24 
25 
26 
27 
28 	function check(string hash) public constant returns (uint256) {
29 		return registry[hash];
30 	}
31 }