1 pragma solidity 0.4.24;
2 
3 contract Storage {
4     address owner; // This address has permission to upload data
5     
6     bytes32[] public data; // Storage container in pieces of 32 byte
7     uint remainder; // Where the previous uploadData() left off
8     
9     bool readOnly; // Set the contract to read only once upload is finished
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14     
15     // Data is uploaded over many transactions, until the whole file is stored in the contract
16     function uploadData(bytes _data) public {
17         require(msg.sender == owner);
18         require(readOnly != true);
19         uint startPoint = 32 - remainder;
20 
21         if(remainder != 0) {
22 
23             bytes memory rest = new bytes(32);
24             for(uint i = 0; i < remainder; i++) {
25                 rest[i] = data[data.length - 1][i];
26             }
27             for(i = 0; i < startPoint; i++) {
28                 rest[remainder + i] = _data[i];
29             }
30             bytes32 p;
31             assembly {
32                 p := mload(add(rest, 32))
33             }
34             data[data.length - 1] = p;
35         }
36         for(i = 0; i < (uint(_data.length - startPoint) / 32); i++) {
37             bytes32 word;
38             assembly {
39                 word:= mload(add(_data, add(add(32, startPoint), mul(i, 32))))
40             }
41             data.push(word);
42         }
43         uint loose = (_data.length - startPoint) % 32;
44         if(loose != 0) {
45             uint position = _data.length - loose;
46             bytes32 leftover;
47             assembly {
48                 leftover := mload(add(_data, add(32, position)))
49             }
50             data.push(leftover);
51         }
52         remainder = loose;
53     }
54     // If a mistake is done during upload, reverse using erase()
55     function erase(uint _entriesToDelete) public {
56         require(msg.sender == owner);
57         require(readOnly != true);
58         data.length = data.length - _entriesToDelete;
59     }
60     function uploadFinish() public {
61         require(msg.sender == owner);
62         readOnly = true;
63     }
64 
65     // This loads the entire file as a single byte array. Since it does not
66     // affect the contract state, there are no gas costs
67     function getData() public view returns (bytes){
68         bytes memory result = new bytes(data.length*0x20);
69         for(uint i = 0; i < data.length; i++) {
70             bytes32 word = data[i];
71             assembly {
72                 mstore(add(result, add(0x20, mul(i, 32))), word)
73             }
74         }
75         return result;
76     }
77 }