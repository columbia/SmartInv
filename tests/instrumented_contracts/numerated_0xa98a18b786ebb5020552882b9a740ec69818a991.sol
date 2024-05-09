1 pragma solidity ^0.4.24;
2 
3 contract Storage {
4     address owner;
5     bytes[6] public data;
6     uint counter;
7     constructor() public {
8         owner = msg.sender;
9     }
10     function uploadData(bytes _data) public returns (uint){
11         require(msg.sender == owner);
12         data[counter] = _data;
13         counter++;
14     }
15     function getData() public view returns (bytes){
16         uint length;
17         for(uint i = 0; i<6; i++) {
18             length += data[i].length;
19         }
20         uint index;
21         bytes memory result = new bytes(length);
22         for(i = 0; i<6; i++) {
23             for(uint k = 0; k < data[i].length; k++) {
24                 result[index + k] = data[i][k];
25             }
26             index += data[i].length;
27         }
28         return result;
29     }
30 }