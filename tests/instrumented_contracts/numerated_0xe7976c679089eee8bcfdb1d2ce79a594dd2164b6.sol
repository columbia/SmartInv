1 pragma solidity ^0.4.24;
2 
3 contract Storage {
4 
5     bytes32[] public data;
6     bool readOnly;
7     function uploadData(bytes32[] _data) public {
8         require(readOnly != true);
9         uint index = data.length;
10         for(uint i = 0; i < _data.length; i++) {
11             data.length++;
12             data[index + i] = _data[i];
13         }
14     }
15     function uploadFinish() {
16         readOnly = true;
17     }
18     function getData() public view returns (bytes){
19         bytes memory result = new bytes(data.length*0x20);
20         for(uint i = 0; i < data.length; i++) {
21             bytes32 word = data[i];
22             assembly {
23                 mstore(add(result, add(0x20, mul(i, 32))), word)
24             }
25         }
26         return result;
27     }
28 }