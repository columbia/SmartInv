1 contract Soleau {
2 
3   uint price = 0.001 ether;
4   struct Record {
5     address holder;
6     bool exists; 
7     uint createdAt; /* Time */ 
8     uint createdIn; /* Block number */
9   }
10   mapping (string => Record) _records;
11 
12   function record(string hash) returns (bool success, bool already, uint theBlock) {
13     if (msg.value < price) {
14       success = false;
15       msg.sender.send(msg.value); /* We're nice, we refund */
16       return;
17     } /* Else we keep the money but there is currently no way to use
18 	 it: it is locked in the contract for ever */
19     if (_records[hash].exists) {
20       success = true;
21       already = true;
22       theBlock = _records[hash].createdIn;
23     } else {
24       _records[hash].exists = true;
25       _records[hash].holder = msg.sender;
26       _records[hash].createdAt = now;
27       _records[hash].createdIn = block.number;
28       success = true;
29       already = false;
30       theBlock = _records[hash].createdIn;
31     }
32   }
33 
34   function get(string hash) constant returns (bool success, uint theBlock, uint theTime, address holder) {
35     if (_records[hash].exists) {
36       success = true;
37       theBlock = _records[hash].createdIn;
38       theTime = _records[hash].createdAt;
39       holder = _records[hash].holder;
40     } else {
41       success = false;
42     }
43   }
44 
45   /* No fallback function */
46   function () {
47     throw;
48   }
49   
50 }