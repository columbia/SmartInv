1 pragma solidity ^0.5.2;
2 
3 contract szfcMerkleRoot {
4 
5     uint64 oneHour= 3600000;
6 
7     address owner;
8 
9     mapping(bytes32 => uint64) hash2timestamp;
10 
11     mapping(uint64=> bytes32[]) public timestamp2hashes;  //date -> merkle root hash
12 
13     constructor() public {
14 
15         owner = msg.sender;
16 
17     }
18 
19     function push(uint64 _timestamp, bytes32 _root) external{
20 
21         require(msg.sender == owner);
22 
23         require(checkTime(_timestamp));
24         require(hash2timestamp[_root] == 0);
25 
26         //归结
27         uint64 hour_point = _timestamp - _timestamp % oneHour;
28 
29         hash2timestamp[_root] = _timestamp;
30 
31         bytes32[] storage hashes = timestamp2hashes[hour_point];
32 
33         hashes.push(_root);
34 
35 
36     }
37 
38 
39 
40 
41     function getAllHashes(uint64 _timestamp) external view returns(bytes32[] memory){
42 
43         uint64 hour_point = _timestamp - _timestamp % oneHour;
44 
45         bytes32[] storage hashes = timestamp2hashes[hour_point];
46 
47         return hashes;
48 
49     }
50 
51 
52     function getLastHash(uint64 _timestamp) public view returns(bytes32){
53 
54         uint64 hour_point = _timestamp - _timestamp % oneHour;
55 
56         bytes32[] storage hashes = timestamp2hashes[hour_point];
57 
58         if( hashes.length > 0 ) {
59             return hashes[hashes.length-1];
60         }
61 
62         return 0x00;
63 
64     }
65 
66 
67     function getTimestamp(bytes32 _root) external view returns(uint64){
68 
69         return hash2timestamp[_root];
70 
71     }
72 
73 
74     function getOwner() external view returns(address){
75 
76         return owner;
77 
78     }
79 
80 
81     function checkTime(uint64 _timestamp) private view returns (bool) {
82 
83         return ( _timestamp < now * 1000 );
84     }
85 
86 
87 
88 }