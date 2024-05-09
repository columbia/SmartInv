1 pragma solidity ^0.4.24;
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
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier readWrite () {
21         require(readOnly != true);
22         _;
23     }
24 
25     // Data is uploaded over many transactions, until the whole file is stored in the contract
26     function uploadData(bytes _data) onlyOwner readWrite public {
27 
28         uint startPoint;
29 
30         if(remainder != 0) {
31 
32             startPoint = 32 - remainder;
33             bytes memory rest = new bytes(32);
34             for(uint i = 0; i < remainder; i++) {
35                 rest[i] = data[data.length - 1][i];
36             }
37             for(i = 0; i < startPoint; i++) {
38                 rest[remainder + i] = _data[i];
39             }
40             bytes32 p;
41             assembly {
42                 p := mload(add(rest, 32))
43             }
44             data[data.length - 1] = p;
45         }
46         for(i = 0; i < (uint(_data.length - startPoint) / 32); i++) {
47             bytes32 word;
48             assembly {
49                 word:= mload(add(_data, add(add(32, startPoint), mul(i, 32))))
50             }
51             data.push(word);
52         }
53         uint loose = (_data.length - startPoint) % 32;
54         if(loose != 0) {
55             uint position = _data.length - loose;
56             bytes32 leftover;
57             assembly {
58                 leftover := mload(add(_data, add(32, position)))
59             }
60             data.push(leftover);
61         }
62         remainder = loose;
63     }
64     // If a mistake is done during upload, reverse using erase()
65     function erase(uint _entriesToDelete) onlyOwner readWrite public {
66         require(_entriesToDelete != 0);
67         if(data.length < _entriesToDelete) { 
68             delete data;
69         }
70         else data.length -= _entriesToDelete;
71         remainder = 0;
72     }
73     function uploadFinish() onlyOwner public {
74         readOnly = true;
75     }
76 
77     // This loads the entire file as a single byte array. Since it does not
78     // affect the contract state, there are no gas costs
79 
80     function getData() public view returns (bytes){
81         bytes memory result = new bytes(data.length*0x20);
82         for(uint i = 0; i < data.length; i++) {
83             bytes32 word = data[i];
84             assembly {
85                 mstore(add(result, add(0x20, mul(i, 32))), word)
86             }
87         }
88         return result;
89     }
90 }