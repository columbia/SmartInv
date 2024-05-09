1 pragma solidity ^0.4.23;
2 
3 
4 contract RamanDataBlock {
5   mapping (uint => string) dataMap;
6   address owner;
7   
8   constructor() {
9   	owner = msg.sender;
10   }
11    function insertContent(uint fileId, string fileContent) public {
12 		require (msg.sender == owner);
13 		require(bytes(dataMap[fileId]).length == 0);
14 		dataMap[fileId] = fileContent;
15 	}
16 
17 	function getFileContent(uint fileId) public view returns(string) {
18 		return dataMap[fileId];
19 	}
20 }