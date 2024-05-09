1 /**
2  * Copyright 2016 Everex https://everex.io
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License");
5  * you may not use this file except in compliance with the License.
6  * You may obtain a copy of the License at
7  *
8  *     http://www.apache.org/licenses/LICENSE-2.0
9  *
10  * Unless required by applicable law or agreed to in writing, software
11  * distributed under the License is distributed on an "AS IS" BASIS,
12  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13  * See the License for the specific language governing permissions and
14  * limitations under the License.
15  */
16 
17 
18 /* String utility library */
19 library strUtils {
20     string constant CHAINY_JSON_ID = '"id":"CHAINY"';
21     uint8 constant CHAINY_JSON_MIN_LEN = 32;
22 
23     /* Converts given number to base58, limited by _maxLength symbols */
24     function toBase58(uint256 _value, uint8 _maxLength) internal returns (string) {
25         string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
26         bytes memory alphabet = bytes(letters);
27         uint8 base = 58;
28         uint8 len = 0;
29         uint256 remainder = 0;
30         bytes memory bytesReversed = bytes(new string(_maxLength));
31 
32         for (uint8 i = 0; i < _maxLength; i++) {
33             remainder = _value % base;
34             _value = uint256(_value / base);
35             bytesReversed[i] = alphabet[remainder];
36             len++;
37             if(_value < base){
38                 break;
39             }
40         }
41 
42         // Reverse
43         bytes memory result = bytes(new string(len));
44         for (i = 0; i < len; i++) {
45             result[i] = bytesReversed[len - i - 1];
46         }
47         return string(result);
48     }
49 
50     /* Concatenates two strings */
51     function concat(string _s1, string _s2) internal returns (string) {
52         bytes memory bs1 = bytes(_s1);
53         bytes memory bs2 = bytes(_s2);
54         string memory s3 = new string(bs1.length + bs2.length);
55         bytes memory bs3 = bytes(s3);
56 
57         uint256 j = 0;
58         for (uint256 i = 0; i < bs1.length; i++) {
59             bs3[j++] = bs1[i];
60         }
61         for (i = 0; i < bs2.length; i++) {
62             bs3[j++] = bs2[i];
63         }
64 
65         return string(bs3);
66     }
67 
68     /* Checks if provided JSON string has valid Chainy format */
69     function isValidChainyJson(string _json) internal returns (bool) {
70         bytes memory json = bytes(_json);
71         bytes memory id = bytes(CHAINY_JSON_ID);
72 
73         if (json.length < CHAINY_JSON_MIN_LEN) {
74             return false;
75         } else {
76             uint len = 0;
77             if (json[1] == id[0]) {
78                 len = 1;
79                 while (len < id.length && (1 + len) < json.length && json[1 + len] == id[len]) {
80                     len++;
81                 }
82                 if (len == id.length) {
83                     return true;
84                 }
85             }
86         }
87 
88         return false;
89     }
90 }
91 
92 
93 // Ownership
94 contract owned {
95     address public owner;
96 
97     function owned() {
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner {
102         if (msg.sender != owner) throw;
103         _
104     }
105 
106     function transferOwnership(address newOwner) onlyOwner {
107         owner = newOwner;
108     }
109 }
110 
111 
112 // Mortality
113 contract mortal is owned {
114     function kill() onlyOwner {
115         if (this.balance > 0) {
116             if (!msg.sender.send(this.balance)) throw;
117         }
118         suicide(msg.sender);
119     }
120 }
121 
122 
123 contract Chainy is owned, mortal {
124     string constant CHAINY_URL = "https://txn.me/";
125 
126     // Configuration
127     mapping(string => uint256) private chainyConfig;
128 
129     // Service accounts
130     mapping (address => bool) private srvAccount;
131 
132     // Fee receiver
133     address private receiverAddress;
134 
135     struct data {uint256 timestamp; string json; address sender;}
136     mapping (string => data) private chainy;
137 
138     event chainyShortLink(uint256 timestamp, string code);
139 
140     // Constructor
141     function Chainy(){
142         setConfig("fee", 0);
143         setConfig("blockoffset", 1000000);
144     }
145 
146     // Sets configuration option
147     function setConfig(string _key, uint256 _value) onlyOwner {
148         chainyConfig[_key] = _value;
149     }
150 
151     // Returns configuration option
152     function getConfig(string _key) constant returns (uint256 _value) {
153         return chainyConfig[_key];
154     }
155 
156     // Add/Remove service account
157     function setServiceAccount(address _address, bool _value) onlyOwner {
158         srvAccount[_address] = _value;
159     }
160 
161     // Set receiver address
162     function setReceiverAddress(address _address) onlyOwner {
163         receiverAddress = _address;
164     }
165 
166     // Add record
167     function addChainyData(string json) {
168         checkFormat(json);
169 
170         var code = generateShortLink();
171         // Checks if the record exist
172         if (getChainyTimestamp(code) > 0) throw;
173 
174         processFee();
175         chainy[code] = data({
176             timestamp: block.timestamp,
177             json: json,
178             sender: tx.origin
179         });
180 
181         // Fire event
182         var link = strUtils.concat(CHAINY_URL, code);
183         chainyShortLink(block.timestamp, link);
184     }
185 
186     // Get record timestamp
187     function getChainyTimestamp(string code) constant returns (uint256) {
188         return chainy[code].timestamp;
189     }
190 
191     // Get record JSON
192     function getChainyData(string code) constant returns (string) {
193         return chainy[code].json;
194     }
195 
196     // Get record sender
197     function getChainySender(string code) constant returns (address) {
198         return chainy[code].sender;
199     }
200 
201     // Checks if enough fee provided
202     function processFee() internal {
203         var fee = getConfig("fee");
204         if (srvAccount[msg.sender] || (fee == 0)) return;
205 
206         if (msg.value < fee)
207             throw;
208         else
209             if (!receiverAddress.send(fee)) throw;
210     }
211 
212     // Checks if provided string has valid format
213     function checkFormat(string json) internal {
214         if (!strUtils.isValidChainyJson(json)) throw;
215     }
216 
217     function generateShortLink() internal returns (string) {
218         var s1 = strUtils.toBase58(block.number - getConfig("blockoffset"), 10);
219         var s2 = strUtils.toBase58(uint256(tx.origin), 2);
220 
221         var s = strUtils.concat(s1, s2);
222         return s;
223     }
224 
225 }