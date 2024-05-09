1 /*
2 
3    TEXTMESSAGE.ETH
4    
5    A Ethereum contract to send SMS message through the blockchain.
6    This contract does require of msg.value of $0.08-$0.15 USD to cover
7    the price of sending a text message to the real world.
8    
9    Documentation: https://hunterlong.github.io/textmessage.eth
10    Author: Hunter Long
11    
12 */
13 
14 pragma solidity ^0.4.11;
15 
16 contract OraclizeI {
17     address public cbAddress;
18     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
19     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
20     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
21     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
22     function getPrice(string _datasource) returns (uint _dsprice);
23     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
24     function useCoupon(string _coupon);
25     function setProofType(byte _proofType);
26     function setCustomGasPrice(uint _gasPrice);
27 }
28 contract OraclizeAddrResolverI {
29     function getAddress() returns (address _addr);
30 }
31 contract usingOraclize {
32     uint constant day = 60*60*24;
33     uint constant week = 60*60*24*7;
34     uint constant month = 60*60*24*30;
35     byte constant proofType_NONE = 0x00;
36     byte constant proofType_TLSNotary = 0x10;
37     byte constant proofStorage_IPFS = 0x01;
38     uint8 constant networkID_auto = 0;
39     uint8 constant networkID_mainnet = 1;
40     uint8 constant networkID_testnet = 2;
41     uint8 constant networkID_morden = 2;
42     uint8 constant networkID_consensys = 161;
43  
44     OraclizeAddrResolverI OAR;
45     
46     OraclizeI oraclize;
47     modifier oraclizeAPI {
48         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
49         oraclize = OraclizeI(OAR.getAddress());
50         _;
51     }
52     modifier coupon(string code){
53         oraclize = OraclizeI(OAR.getAddress());
54         oraclize.useCoupon(code);
55         _;
56     }
57  
58     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
59         networkID=networkID;
60         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){
61             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
62             return true;
63         }
64         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){
65             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
66             return true;
67         }
68         return false;
69     }
70     
71     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
72         uint price = oraclize.getPrice(datasource);
73         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
74         return oraclize.query.value(price)(0, datasource, arg);
75     }
76     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
77         uint price = oraclize.getPrice(datasource);
78         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
79         return oraclize.query.value(price)(timestamp, datasource, arg);
80     }
81     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
82         uint price = oraclize.getPrice(datasource, gaslimit);
83         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
84         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
85     }
86     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
87         uint price = oraclize.getPrice(datasource, gaslimit);
88         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
89         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
90     }
91     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource);
93         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
94         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
95     }
96     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource, gaslimit);
103         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
104         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
105     }
106     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
110     }
111     function oraclize_cbAddress() oraclizeAPI internal returns (address){
112         return oraclize.cbAddress();
113     }
114     function oraclize_setProof(byte proofP) oraclizeAPI internal {
115         return oraclize.setProofType(proofP);
116     }
117     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
118         return oraclize.setCustomGasPrice(gasPrice);
119     }    
120  
121     function getCodeSize(address _addr) constant internal returns(uint _size) {
122         _addr=_addr;
123         _size=_size;
124         assembly {
125             _size := extcodesize(_addr)
126         }
127     }
128  
129  
130     function parseAddr(string _a) internal returns (address){
131         bytes memory tmp = bytes(_a);
132         uint160 iaddr = 0;
133         uint160 b1;
134         uint160 b2;
135         for (uint i=2; i<2+2*20; i+=2){ iaddr *= 256; b1 = uint160(tmp[i]); b2 = uint160(tmp[i+1]); if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87; else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48; if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87; else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
136             iaddr += (b1*16+b2);
137         }
138         return address(iaddr);
139     }
140  
141  
142     function strCompare(string _a, string _b) internal returns (int) {
143         bytes memory a = bytes(_a);
144         bytes memory b = bytes(_b);
145         uint minLength = a.length;
146         if (b.length < minLength) minLength = b.length;
147         for (uint i = 0; i < minLength; i ++)
148             if (a[i] < b[i]) return -1; else if (a[i] > b[i])
149                 return 1;
150         if (a.length < b.length) return -1; else if (a.length > b.length)
151             return 1;
152         else
153             return 0;
154    } 
155  
156     function indexOf(string _haystack, string _needle) internal returns (int)
157     {
158         bytes memory h = bytes(_haystack);
159         bytes memory n = bytes(_needle);
160         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
161             return -1;
162         else if(h.length > (2**128 -1))
163             return -1;                                  
164         else
165         {
166             uint subindex = 0;
167             for (uint i = 0; i < h.length; i ++)
168             {
169                 if (h[i] == n[0])
170                 {
171                     subindex = 1;
172                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
173                     {
174                         subindex++;
175                     }   
176                     if(subindex == n.length)
177                         return int(i);
178                 }
179             }
180             return -1;
181         }   
182     }
183  
184     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
185         bytes memory _ba = bytes(_a);
186         bytes memory _bb = bytes(_b);
187         bytes memory _bc = bytes(_c);
188         bytes memory _bd = bytes(_d);
189         bytes memory _be = bytes(_e);
190         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
191         bytes memory babcde = bytes(abcde);
192         uint k = 0;
193         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
194         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
195         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
196         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
197         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
198         return string(babcde);
199     }
200     
201     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
202         return strConcat(_a, _b, _c, _d, "");
203     }
204  
205     function strConcat(string _a, string _b, string _c) internal returns (string) {
206         return strConcat(_a, _b, _c, "", "");
207     }
208  
209     function strConcat(string _a, string _b) internal returns (string) {
210         return strConcat(_a, _b, "", "", "");
211     }
212  
213     // parseInt
214     function parseInt(string _a) internal returns (uint) {
215         return parseInt(_a, 0);
216     }
217  
218     // parseInt(parseFloat*10^_b)
219     function parseInt(string _a, uint _b) internal returns (uint) {
220         bytes memory bresult = bytes(_a);
221         uint mint = 0;
222         bool decimals = false;
223         for (uint i=0; i<bresult.length; i++){ if ((bresult[i] >= 48)&&(bresult[i] <= 57)){ if (decimals){ if (_b == 0) break; else _b--; } mint *= 10; mint += uint(bresult[i]) - 48; } else if (bresult[i] == 46) decimals = true; } if (_b > 0) mint *= 10**_b;
224         return mint;
225     }
226     
227  
228 }
229 // 
230 
231 
232 contract owned {
233     address public owner;
234 
235     function owned() {
236         owner = msg.sender;
237     }
238 
239     modifier onlyOwner {
240         if (msg.sender != owner) throw;
241         _;
242     }
243 
244     function transferOwnership(address newOwner) onlyOwner {
245         owner = newOwner;
246     }
247 }
248 
249 
250 contract TextMessage is usingOraclize, owned {
251     
252     uint cost;
253     bool public enabled;
254     string apiURL;
255     string submitData;
256     string orcData;
257     string jsonData;
258     
259     event updateCost(uint newCost);
260     event updateEnabled(string newStatus);
261 
262     function TextMessage() {
263         oraclize_setProof(proofType_NONE);
264         cost = 450000000000000;
265         enabled = true;
266     }
267     
268     function changeCost(uint price) onlyOwner {
269         cost = price;
270         updateCost(cost);
271     }
272     
273     function pauseContract() onlyOwner {
274         enabled = false;
275         updateEnabled("Texting has been disabled");
276     }
277     
278     function enableContract() onlyOwner {
279         enabled = true;
280         updateEnabled("Texting has been enabled");
281     }
282     
283     function changeApiUrl(string newUrl) onlyOwner {
284         apiURL = newUrl;
285     }
286     
287     function withdraw() onlyOwner {
288         owner.transfer(this.balance - cost);
289     }
290     
291     function costWei() constant returns (uint) {
292       return cost;
293     }
294     
295     function sendText(string phoneNumber, string textBody) public payable {
296         if(!enabled) throw;
297         if(msg.value < cost) throw;
298         if (oraclize.getPrice("URL") > this.balance) throw;
299         sendMsg(phoneNumber, textBody);
300     }
301     
302     function sendMsg(string num, string body) internal {
303         submitData = strConcat('{"to":"', num, '","msg":"', body, '"}');
304         oraclize_query("URL", apiURL, submitData);
305     }
306     
307 }