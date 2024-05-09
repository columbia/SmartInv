1 pragma solidity ^0.4.24;
2 
3 contract Storage {
4 
5     bytes32[] public data;
6     bool readOnly;
7     function uploadData(bytes _data) public {
8         require(readOnly != true);
9         uint index = data.length;
10         for(uint i = 0; i < _data.length / 32; i++) {
11             bytes32 word;
12             assembly {
13                 word:= mload(add(_data, add(32, mul(i, 32))))
14             }
15             data.length++;
16             data[index + i] = word;
17         }
18     }
19     function uploadFinish() public {
20         readOnly = true;
21     }
22     function getData() public view returns (bytes){
23         bytes memory result = new bytes(data.length*0x20);
24         for(uint i = 0; i < data.length; i++) {
25             bytes32 word = data[i];
26             assembly {
27                 mstore(add(result, add(0x20, mul(i, 32))), word)
28             }
29         }
30         return result;
31     }
32 }