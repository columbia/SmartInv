1 pragma solidity ^0.4.0;
2 
3 contract TimestampService {
4 
5     struct Timestamp {
6         uint    timestamp;
7         address sender;
8     }
9     mapping(bytes32 => Timestamp) public timestamps;
10 
11     function timestamp(bytes32 hash) public returns (bool) {
12         if (timestamps[hash].timestamp != 0) {
13             return false;
14         }
15         timestamps[hash].timestamp = block.timestamp;
16         timestamps[hash].sender = msg.sender;
17         return true;
18     }
19     function getTimestamp(bytes32 hash) public constant returns (uint) {
20         return timestamps[hash].timestamp;
21     }
22     function getSender(bytes32 hash) public constant returns (address) {
23         return timestamps[hash].sender;
24     }
25 
26 }