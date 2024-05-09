1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Uint256HashTable {
4     mapping(uint256 => uint256) public hashTableValues;
5 
6     constructor() public {
7 
8     }
9 
10     function set(uint256 key, uint256 value) public  {
11         hashTableValues[key] = value;
12     }
13 
14     function get(uint256 key) public view returns (uint256 retVal) {
15         return hashTableValues[key];
16     }
17 }