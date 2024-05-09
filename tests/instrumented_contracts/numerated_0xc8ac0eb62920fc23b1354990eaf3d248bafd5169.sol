1 pragma solidity 0.4.11;
2 
3 /**
4  * Copyright 2017 NB
5  *
6  * Licensed under the Apache License, Version 2.0 (the "License");
7  * you may not use this file except in compliance with the License.
8  * You may obtain a copy of the License at
9  *
10  *     http://www.apache.org/licenses/LICENSE-2.0
11  *
12  * Unless required by applicable law or agreed to in writing, software
13  * distributed under the License is distributed on an "AS IS" BASIS,
14  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15  * See the License for the specific language governing permissions and
16  * limitations under the License.
17  */
18 
19 
20 contract owned {
21     address public owner;
22 
23     function owned() {
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner {
28         if (msg.sender != owner) throw;
29         _;
30     }
31 
32     function transferOwnership(address newOwner) onlyOwner {
33         owner = newOwner;
34     }
35 }
36 
37 contract NB is owned {
38 
39 
40     // Configuration
41     mapping(string => string) private nodalblockConfig;
42 
43     // Service accounts
44     mapping (address => bool) private srvAccount;
45 
46     struct data {
47         string json;
48     }
49     mapping (string => data) private nodalblock;
50 
51     // Constructor
52     function Nodalblock(){
53         setConfig("code", "none");
54     }
55 
56     function releaseFunds() onlyOwner {
57         if(!owner.send(this.balance)) throw;
58     }
59 
60     function addNodalblockData(string json) {
61 
62         setConfig("code", json);
63     }
64 
65     function setConfig(string _key, string _value) onlyOwner {
66         nodalblockConfig[_key] = _value;
67     }
68 
69     function getConfig(string _key) constant returns (string _value) {
70             return nodalblockConfig[_key];
71         }
72 
73 }