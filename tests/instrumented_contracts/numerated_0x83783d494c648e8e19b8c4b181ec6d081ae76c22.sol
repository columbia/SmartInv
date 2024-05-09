1 pragma solidity ^0.4.21;
2 
3 contract Storage {
4     address owner; // This address has permission to upload data
5     
6     bytes32[] public data; // Storage container in pieces of 32 byte
7     uint remainder; // Where the previous uploadData() left off
8     
9     bool readOnly; // Set the contract to read only once upload is finished
10 
11     constructor() {
12         owner = msg.sender;
13     }
14     
15     // Data is uploaded over many transactions, until the whole file is stored in the contract
16     function uploadData(bytes _data) public {
17         require(msg.sender == owner);
18         require(readOnly != true);
19         uint startPoint;
20 
21         if(remainder != 0) {
22 
23             startPoint = 32 - remainder;
24             bytes memory rest = new bytes(32);
25             for(uint i = 0; i < remainder; i++) {
26                 rest[i] = data[data.length - 1][i];
27             }
28             for(i = 0; i < startPoint; i++) {
29                 rest[remainder + i] = _data[i];
30             }
31             bytes32 p;
32             assembly {
33                 p := mload(add(rest, 32))
34             }
35             data[data.length - 1] = p;
36         }
37         for(i = 0; i < (uint(_data.length - startPoint) / 32); i++) {
38             bytes32 word;
39             assembly {
40                 word:= mload(add(_data, add(add(32, startPoint), mul(i, 32))))
41             }
42             data.push(word);
43         }
44         uint loose = (_data.length - startPoint) % 32;
45         if(loose != 0) {
46             uint position = _data.length - loose;
47             bytes32 leftover;
48             assembly {
49                 leftover := mload(add(_data, add(32, position)))
50             }
51             data.push(leftover);
52         }
53         remainder = loose;
54     }
55     // If a mistake is done during upload, reverse using erase()
56     function erase(uint _entriesToDelete) public {
57         require(msg.sender == owner);
58         require(readOnly != true);
59         if(data.length < _entriesToDelete) { 
60             delete data;
61         }
62         else data.length -= _entriesToDelete;
63         remainder = 0;
64     }
65     function uploadFinish() public {
66         require(msg.sender == owner);
67         readOnly = true;
68     }
69 
70     // This loads the entire file as a single byte array. Since it does not
71     // affect the contract state, there are no gas costs
72     function getData() public view returns (bytes){
73         bytes memory result = new bytes(data.length*0x20);
74         for(uint i = 0; i < data.length; i++) {
75             bytes32 word = data[i];
76             assembly {
77                 mstore(add(result, add(0x20, mul(i, 32))), word)
78             }
79         }
80         return result;
81     }
82 }