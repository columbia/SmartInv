1 pragma solidity ^0.5.2;
2 
3 contract DataNode {
4   constructor() public {}
5 
6   uint private index = 1;
7 
8   event DataAdded(
9     string metaData,
10     uint dataByteLength,
11     uint usedIndex,
12     uint indexed index,
13     address indexed from
14   );
15 
16   function postDataTransaction(bytes calldata data, string calldata metaData) external payable {
17     emit DataAdded(metaData, data.length, index, index, msg.sender);
18     index++;
19   }
20 
21   function getNextIndex() public view returns (uint){
22     return index;
23   }
24 
25 }