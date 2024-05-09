1 pragma solidity 0.4.11;
2 
3 /**
4  * Copyright 2017 Nodalblock http://nodalblock.com
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
37 library strUtils {
38     string constant NODALBLOCK_JSON_ID = '"id":"NODALBLOCK"';
39     uint8 constant NODALBLOCK_JSON_MIN_LEN = 32;
40 
41     function toBase58(uint256 _value, uint8 _maxLength) internal returns (string) {
42         string memory letters = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
43         bytes memory alphabet = bytes(letters);
44         uint8 base = 58;
45         uint8 len = 0;
46         uint256 remainder = 0;
47         bool needBreak = false;
48         bytes memory bytesReversed = bytes(new string(_maxLength));
49 
50         for (uint8 i = 0; i < _maxLength; i++) {
51             if(_value < base){
52                 needBreak = true;
53             }
54             remainder = _value % base;
55             _value = uint256(_value / base);
56             bytesReversed[i] = alphabet[remainder];
57             len++;
58             if(needBreak){
59                 break;
60             }
61         }
62 
63         // Reverse
64         bytes memory result = bytes(new string(len));
65         for (i = 0; i < len; i++) {
66             result[i] = bytesReversed[len - i - 1];
67         }
68         return string(result);
69     }
70 
71     function concat(string _s1, string _s2) internal returns (string) {
72         bytes memory bs1 = bytes(_s1);
73         bytes memory bs2 = bytes(_s2);
74         string memory s3 = new string(bs1.length + bs2.length);
75         bytes memory bs3 = bytes(s3);
76 
77         uint256 j = 0;
78         for (uint256 i = 0; i < bs1.length; i++) {
79             bs3[j++] = bs1[i];
80         }
81         for (i = 0; i < bs2.length; i++) {
82             bs3[j++] = bs2[i];
83         }
84 
85         return string(bs3);
86     }
87 
88 
89     function isValidNodalblockJson(string _json) internal returns (bool) {
90         bytes memory json = bytes(_json);
91         bytes memory id = bytes(NODALBLOCK_JSON_ID);
92 
93         if (json.length < NODALBLOCK_JSON_MIN_LEN) {
94             return false;
95         } else {
96             uint len = 0;
97             if (json[1] == id[0]) {
98                 len = 1;
99                 while (len < id.length && (1 + len) < json.length && json[1 + len] == id[len]) {
100                     len++;
101                 }
102                 if (len == id.length) {
103                     return true;
104                 }
105             }
106         }
107 
108         return false;
109     }
110 }
111 
112 contract Nodalblock is owned {
113 
114     string  NODALBLOCK_URL;
115 
116     // Configuration
117     mapping(string => uint256) private nodalblockConfig;
118 
119     // Service accounts
120     mapping (address => bool) private srvAccount;
121 
122     // Fee receiver
123     address private receiverAddress;
124 
125     struct data {uint256 timestamp; string json; address sender;}
126     mapping (string => data) private nodalblock;
127 
128     event nodalblockShortLink(uint256 timestamp, string code);
129 
130     // Constructor
131     function Nodalblock(){
132         setConfig("fee", 0);
133         setConfig("blockoffset", 2000000);
134         setNodalblockURL("http://nodalblock.com/");
135     }
136 
137     function setNodalblockURL(string _url) onlyOwner {
138         NODALBLOCK_URL = _url;
139     }
140 
141     function getNodalblockURL() constant returns(string){
142         return NODALBLOCK_URL;
143     }
144 
145     function setConfig(string _key, uint256 _value) onlyOwner {
146         nodalblockConfig[_key] = _value;
147     }
148 
149     function getConfig(string _key) constant returns (uint256 _value) {
150         return nodalblockConfig[_key];
151     }
152 
153     function setServiceAccount(address _address, bool _value) onlyOwner {
154         srvAccount[_address] = _value;
155     }
156     function setReceiverAddress(address _address) onlyOwner {
157         receiverAddress = _address;
158     }
159 
160     function releaseFunds() onlyOwner {
161         if(!owner.send(this.balance)) throw;
162     }
163 
164     function addNodalblockData(string json) {
165         checkFormat(json);
166 
167         var code = generateShortLink();
168         // Checks if the record exist
169         if (getNodalblockTimestamp(code) > 0) throw;
170 
171         processFee();
172         nodalblock[code] = data({
173             timestamp: block.timestamp,
174             json: json,
175             sender: tx.origin
176         });
177 
178         // Fire event
179         var link = strUtils.concat(NODALBLOCK_URL, code);
180         nodalblockShortLink(block.timestamp, link);
181     }
182 
183     function getNodalblockTimestamp(string code) constant returns (uint256) {
184         return nodalblock[code].timestamp;
185     }
186 
187     function getNodalblockData(string code) constant returns (string) {
188         return nodalblock[code].json;
189     }
190 
191     function getNodalblockSender(string code) constant returns (address) {
192         return nodalblock[code].sender;
193     }
194 
195     function processFee() internal {
196         var fee = getConfig("fee");
197         if (srvAccount[msg.sender] || (fee == 0)) return;
198 
199         if (msg.value < fee)
200             throw;
201         else
202             if (!receiverAddress.send(fee)) throw;
203     }
204     function checkFormat(string json) internal {
205         if (!strUtils.isValidNodalblockJson(json)) throw;
206     }
207 
208     function generateShortLink() internal returns (string) {
209         var s1 = strUtils.toBase58(block.number - getConfig("blockoffset"), 11);
210         var s2 = strUtils.toBase58(uint256(tx.origin), 2);
211 
212         var s = strUtils.concat(s1, s2);
213         return s;
214     }
215 
216 }