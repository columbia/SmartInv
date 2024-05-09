1 pragma solidity ^0.5.1;
2 
3 /**
4  * Followine - Coil. More info www.followine.io
5 **/
6 
7 contract CoilChecker {
8 
9 	mapping (uint256 => bool) coils;
10 	address owner;
11 
12 	constructor() public {
13         owner = msg.sender;
14     }
15 
16 	modifier onlyOwner() {
17 		require(msg.sender == owner);
18 		_;
19 	}
20 
21     function addCoil(uint256 _id) public onlyOwner {
22         coils[_id] = true;
23     }
24 
25 	function changeOwner(address _newOwner) public onlyOwner {
26         owner = _newOwner;
27     }
28 
29 	function removeCoil(uint256 _id) public onlyOwner {
30         coils[_id] = false;
31     }
32 
33 	function getCoil(uint256 _id) public view returns (bool coilStatus) {
34         return coils[_id];
35     }
36 
37 }