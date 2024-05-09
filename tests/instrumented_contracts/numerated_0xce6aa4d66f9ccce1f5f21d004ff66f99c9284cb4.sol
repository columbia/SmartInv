1 pragma solidity ^0.4.13;
2  
3 contract s_Form004 {
4     
5     mapping (bytes32 => string) data;
6     
7     address owner;
8     
9     function s_Form004() {
10         owner = msg.sender;
11     }
12     
13     function setDataColla_AA_01(string key, string value) {
14         require(msg.sender == owner);
15         data[sha3(key)] = value;
16     }
17     
18     function getDataColla_AA_01(string key) constant returns(string) {
19         return data[sha3(key)];
20     }
21 
22     function setDataColla_AA_02(string key, string value) {
23         require(msg.sender == owner);
24         data[sha3(key)] = value;
25     }
26     
27     function getDataColla_AA_02(string key) constant returns(string) {
28         return data[sha3(key)];
29     }
30     
31     function setDataColla_AB_01(string key, string value) {
32         require(msg.sender == owner);
33         data[sha3(key)] = value;
34     }
35     
36     function getDataColla_AB_01(string key) constant returns(string) {
37         return data[sha3(key)];
38     }    
39 
40     function setDataColla_AB_02(string key, string value) {
41         require(msg.sender == owner);
42         data[sha3(key)] = value;
43     }
44     
45     function getDataColla_AB_02(string key) constant returns(string) {
46         return data[sha3(key)];
47     } 
48 
49 /*
50 0xCe6Aa4d66f9CCCE1f5F21D004Ff66F99c9284Cb4
51 Liechtensteinischer Sozialversicherung -Rentenversicherung AAD (association autonome et décentralisée/distribuée)
52 */
53 }