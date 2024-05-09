1 pragma solidity ^0.4.13;
2  
3 contract s_Form003 {
4     
5     mapping (bytes32 => string) data;
6     
7     address owner;
8     
9     function s_Form003() {
10         owner = msg.sender;
11 
12     }
13     
14     function setDataColla_001_001(string key, string value) {
15         require(msg.sender == owner);
16         data[sha3(key)] = value;
17     }
18     
19     function getDataColla_001_001(string key) constant returns(string) {
20         return data[sha3(key)];
21     }
22 
23 
24 
25     function setDataColla_001_002(string key, string value) {
26         require(msg.sender == owner);
27         data[sha3(key)] = value;
28     }
29     
30     function getDataColla_001_002(string key) constant returns(string) {
31         return data[sha3(key)];
32     }
33 
34 
35 /*
36 0x1FeCdc11d045Cfe5a564610C23120EBE35852Cb3
37 */
38 }