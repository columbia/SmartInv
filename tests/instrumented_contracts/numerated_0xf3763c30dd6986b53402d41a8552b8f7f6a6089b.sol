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
30         bool needBreak = false;
31         bytes memory bytesReversed = bytes(new string(_maxLength));
32 
33         for (uint8 i = 0; i < _maxLength; i++) {
34             if(_value < base){
35                 needBreak = true;
36             }
37             remainder = _value % base;
38             _value = uint256(_value / base);
39             bytesReversed[i] = alphabet[remainder];
40             len++;
41             if(needBreak){
42                 break;
43             }
44         }
45 
46         // Reverse
47         bytes memory result = bytes(new string(len));
48         for (i = 0; i < len; i++) {
49             result[i] = bytesReversed[len - i - 1];
50         }
51         return string(result);
52     }
53 
54     /* Concatenates two strings */
55     function concat(string _s1, string _s2) internal returns (string) {
56         bytes memory bs1 = bytes(_s1);
57         bytes memory bs2 = bytes(_s2);
58         string memory s3 = new string(bs1.length + bs2.length);
59         bytes memory bs3 = bytes(s3);
60 
61         uint256 j = 0;
62         for (uint256 i = 0; i < bs1.length; i++) {
63             bs3[j++] = bs1[i];
64         }
65         for (i = 0; i < bs2.length; i++) {
66             bs3[j++] = bs2[i];
67         }
68 
69         return string(bs3);
70     }
71 
72     /* Checks if provided JSON string has valid Chainy format */
73     function isValidChainyJson(string _json) internal returns (bool) {
74         bytes memory json = bytes(_json);
75         bytes memory id = bytes(CHAINY_JSON_ID);
76 
77         if (json.length < CHAINY_JSON_MIN_LEN) {
78             return false;
79         } else {
80             uint len = 0;
81             if (json[1] == id[0]) {
82                 len = 1;
83                 while (len < id.length && (1 + len) < json.length && json[1 + len] == id[len]) {
84                     len++;
85                 }
86                 if (len == id.length) {
87                     return true;
88                 }
89             }
90         }
91 
92         return false;
93     }
94 }
95 
96 
97 // Ownership
98 contract owned {
99     address public owner;
100 
101     function owned() {
102         owner = msg.sender;
103     }
104 
105     modifier onlyOwner {
106         if (msg.sender != owner) throw;
107         _
108     }
109 
110     function transferOwnership(address newOwner) onlyOwner {
111         owner = newOwner;
112     }
113 }
114 
115 contract Chainy is owned {
116     // Chainy viewer url
117     string CHAINY_URL;
118 
119     // Configuration
120     mapping(string => uint256) private chainyConfig;
121 
122     // Service accounts
123     mapping (address => bool) private srvAccount;
124 
125     // Fee receiver
126     address private receiverAddress;
127 
128     struct data {uint256 timestamp; string json; address sender;}
129     mapping (string => data) private chainy;
130 
131     event chainyShortLink(uint256 timestamp, string code);
132 
133     // Constructor
134     function Chainy(){
135         setConfig("fee", 0);
136         // change the block offset to 1000000 to use contract in testnet
137         setConfig("blockoffset", 2000000);
138         setChainyURL("https://txn.me/");
139     }
140 
141     // Sets new Chainy viewer URL
142     function setChainyURL(string _url) onlyOwner {
143         CHAINY_URL = _url;
144     }
145 
146     // Returns current Chainy viewer URL
147     function getChainyURL() constant returns(string){
148         return CHAINY_URL;
149     }
150 
151     // Sets configuration option
152     function setConfig(string _key, uint256 _value) onlyOwner {
153         chainyConfig[_key] = _value;
154     }
155 
156     // Returns configuration option
157     function getConfig(string _key) constant returns (uint256 _value) {
158         return chainyConfig[_key];
159     }
160 
161     // Add/Remove service account
162     function setServiceAccount(address _address, bool _value) onlyOwner {
163         srvAccount[_address] = _value;
164     }
165 
166     // Set receiver address
167     function setReceiverAddress(address _address) onlyOwner {
168         receiverAddress = _address;
169     }
170 
171     // Send all ether back to owner
172     function releaseFunds() onlyOwner {
173         if(!owner.send(this.balance)) throw;
174     }
175 
176     // Add record
177     function addChainyData(string json) {
178         checkFormat(json);
179 
180         var code = generateShortLink();
181         // Checks if the record exist
182         if (getChainyTimestamp(code) > 0) throw;
183 
184         processFee();
185         chainy[code] = data({
186             timestamp: block.timestamp,
187             json: json,
188             sender: tx.origin
189         });
190 
191         // Fire event
192         var link = strUtils.concat(CHAINY_URL, code);
193         chainyShortLink(block.timestamp, link);
194     }
195 
196     // Get record timestamp
197     function getChainyTimestamp(string code) constant returns (uint256) {
198         return chainy[code].timestamp;
199     }
200 
201     // Get record JSON
202     function getChainyData(string code) constant returns (string) {
203         return chainy[code].json;
204     }
205 
206     // Get record sender
207     function getChainySender(string code) constant returns (address) {
208         return chainy[code].sender;
209     }
210 
211     // Checks if enough fee provided
212     function processFee() internal {
213         var fee = getConfig("fee");
214         if (srvAccount[msg.sender] || (fee == 0)) return;
215 
216         if (msg.value < fee)
217             throw;
218         else
219             if (!receiverAddress.send(fee)) throw;
220     }
221 
222     // Checks if provided string has valid format
223     function checkFormat(string json) internal {
224         if (!strUtils.isValidChainyJson(json)) throw;
225     }
226 
227     // Generates a shortlink code for this transaction
228     function generateShortLink() internal returns (string) {
229         var s1 = strUtils.toBase58(block.number - getConfig("blockoffset"), 11);
230         var s2 = strUtils.toBase58(uint256(tx.origin), 2);
231 
232         var s = strUtils.concat(s1, s2);
233         return s;
234     }
235 
236 }