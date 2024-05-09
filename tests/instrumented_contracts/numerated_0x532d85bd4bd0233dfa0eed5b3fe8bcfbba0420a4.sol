1 pragma solidity ^0.5.1;
2 
3 // Author: SilentCicero @IAmNickDodson
4 contract MerklIO {
5     address public owner = msg.sender;
6     mapping(bytes32 => uint256) public hashToTimestamp; // hash => block timestamp
7     mapping(bytes32 => uint256) public hashToNumber; // hash => block number
8     
9     event Hashed(bytes32 indexed hash);
10     
11     function store(bytes32 hash) external {
12          // owner is merklio
13         assert(msg.sender == owner);
14         
15         // hash has not been set
16         assert(hashToTimestamp[hash] <= 0);
17     
18         // set hash to timestamp and blocknumber
19         hashToTimestamp[hash] = block.timestamp;
20         hashToNumber[hash] = block.number;
21         
22         // emit log for tracking
23         emit Hashed(hash);
24     }
25     
26     function changeOwner(address ownerNew) external {
27         // sender is owner
28         assert(msg.sender == owner);
29         
30         // set new owner
31         owner = ownerNew;
32     }
33 }