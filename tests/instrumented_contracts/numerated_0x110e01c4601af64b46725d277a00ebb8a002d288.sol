1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         assert(c >= a);
10         return c;
11     }
12 }
13 
14 contract LoveBlocks {
15     using SafeMath for uint256;
16 
17     event NewLoveBlock(string message, bool encrypted, uint timestamp);
18 
19     struct LoveBlock {
20         string message;
21         bool encrypted;
22         uint timestamp;
23     }
24 
25     LoveBlock[] public locks;
26 
27     mapping (uint => address) private lockToOwner;
28     mapping (address => uint) private ownerToNumber;
29 
30     function myLoveBlockCount() external view returns(uint) {
31         return ownerToNumber[msg.sender];
32     }
33 
34     function totalLoveBlocks() external view returns(uint) {
35         return locks.length;
36     }
37 
38     function createLoveBlock(string _message, bool _encrypted) external {
39         uint id = locks.push(LoveBlock(_message, _encrypted, now)) - 1;
40         lockToOwner[id] = msg.sender;
41         ownerToNumber[msg.sender] = ownerToNumber[msg.sender].add(1);
42         emit NewLoveBlock(_message, _encrypted, now);
43     }
44 
45     function myLoveBlocks() external view returns(uint[]) {
46         uint[] memory result = new uint[](ownerToNumber[msg.sender]);
47 
48         uint counter = 0;
49         for (uint i = 0; i < locks.length; i++) {
50             if (msg.sender == lockToOwner[i]) {
51                 result[counter] = i;
52                 counter = counter.add(1);
53             }
54         }
55         return result;
56     }
57 }