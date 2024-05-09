1 pragma solidity ^0.5.0;
2 
3 
4 contract SafeCreativeAudit {
5 
6     address public owner;
7 
8     struct Record {
9         uint mineTime;
10         uint blockNumber;
11     }
12     
13     mapping (bytes32 => Record) private docHashes;
14     
15     modifier ownerOnly {
16         require(owner == msg.sender, "Unauthorized: only owner");
17         _;   // <--- note the '_', which represents the modified function's body
18     }
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     function addDocHash(bytes32 hash) public ownerOnly {
25         Record memory newRecord = Record(block.timestamp, block.number);
26         docHashes[hash] = newRecord;
27     }
28 
29     function findDocHash(bytes32 hash) public view returns(uint, uint) {
30         return (docHashes[hash].mineTime, docHashes[hash].blockNumber);
31     }
32 
33     function changeOwner(address newOwner) public ownerOnly{
34         owner = newOwner;
35     }
36 
37 
38 }