1 pragma solidity ^0.4.13;
2  
3 contract s_Form001 {
4     
5     mapping (bytes32 => string) data;
6     
7     address owner;
8     
9     function s_Form001() {
10         owner = msg.sender;
11 
12     }
13     
14     function setData(string key, string value) {
15         require(msg.sender == owner);
16         data[sha3(key)] = value;
17     }
18     
19     function getData(string key) constant returns(string) {
20         return data[sha3(key)];
21     }
22 
23 /*
24 0x1aB8991D086831556b5846760F527B0b0b4F4aF5
25 */
26 }