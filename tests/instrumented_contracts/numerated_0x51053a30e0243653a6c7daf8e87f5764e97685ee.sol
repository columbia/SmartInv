1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
4 
5 
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 
15 
16 The above copyright notice and this permission notice shall be included in
17 all copies or substantial portions of the Software.
18 
19 
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 */
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
36     function getPrice(string _datasource) returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
38     function useCoupon(string _coupon);
39     function setProofType(byte _proofType);
40 }
41 contract OraclizeAddrResolverI {
42     function getAddress() returns (address _addr);
43 }
44 contract usingOraclize {
45     uint constant day = 60*60*24;
46     uint constant week = 60*60*24*7;
47     uint constant month = 60*60*24*30;
48     byte constant proofType_NONE = 0x00;
49     byte constant proofType_TLSNotary = 0x10;
50     byte constant proofStorage_IPFS = 0x01;
51     uint8 constant networkID_auto = 0;
52     uint8 constant networkID_mainnet = 1;
53     uint8 constant networkID_testnet = 2;
54     uint8 constant networkID_morden = 2;
55     uint8 constant networkID_consensys = 161;
56 
57     OraclizeAddrResolverI OAR;
58     
59     OraclizeI oraclize;
60     modifier oraclizeAPI {
61         address oraclizeAddr = OAR.getAddress();
62         if (oraclizeAddr == 0){
63             oraclize_setNetwork(networkID_auto);
64             oraclizeAddr = OAR.getAddress();
65         }
66         oraclize = OraclizeI(oraclizeAddr);
67         _
68     }
69     modifier coupon(string code){
70         oraclize = OraclizeI(OAR.getAddress());
71         oraclize.useCoupon(code);
72         _
73     }
74 
75     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
76         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
77             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
78             return true;
79         }
80         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
81             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
82             return true;
83         }
84         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
85             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
86             return true;
87         }
88         return false;
89     }
90     
91     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource);
93         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
94         return oraclize.query.value(price)(0, datasource, arg);
95     }
96     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query.value(price)(timestamp, datasource, arg);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource, gaslimit);
103         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
104         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
105     }
106     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
110     }
111     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
130     }
131     function oraclize_cbAddress() oraclizeAPI internal returns (address){
132         return oraclize.cbAddress();
133     }
134     function oraclize_setProof(byte proofP) oraclizeAPI internal {
135         return oraclize.setProofType(proofP);
136     }
137 
138     function getCodeSize(address _addr) constant internal returns(uint _size) {
139         assembly {
140             _size := extcodesize(_addr)
141         }
142     }
143 
144 
145     function parseAddr(string _a) internal returns (address){
146         bytes memory tmp = bytes(_a);
147         uint160 iaddr = 0;
148         uint160 b1;
149         uint160 b2;
150         for (uint i=2; i<2+2*20; i+=2){
151             iaddr *= 256;
152             b1 = uint160(tmp[i]);
153             b2 = uint160(tmp[i+1]);
154             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
155             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
156             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
157             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
158             iaddr += (b1*16+b2);
159         }
160         return address(iaddr);
161     }
162 
163 
164     function strCompare(string _a, string _b) internal returns (int) {
165         bytes memory a = bytes(_a);
166         bytes memory b = bytes(_b);
167         uint minLength = a.length;
168         if (b.length < minLength) minLength = b.length;
169         for (uint i = 0; i < minLength; i ++)
170             if (a[i] < b[i])
171                 return -1;
172             else if (a[i] > b[i])
173                 return 1;
174         if (a.length < b.length)
175             return -1;
176         else if (a.length > b.length)
177             return 1;
178         else
179             return 0;
180    } 
181 
182     function indexOf(string _haystack, string _needle) internal returns (int)
183     {
184         bytes memory h = bytes(_haystack);
185         bytes memory n = bytes(_needle);
186         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
187             return -1;
188         else if(h.length > (2**128 -1))
189             return -1;                                  
190         else
191         {
192             uint subindex = 0;
193             for (uint i = 0; i < h.length; i ++)
194             {
195                 if (h[i] == n[0])
196                 {
197                     subindex = 1;
198                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
199                     {
200                         subindex++;
201                     }   
202                     if(subindex == n.length)
203                         return int(i);
204                 }
205             }
206             return -1;
207         }   
208     }
209 
210     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
211         bytes memory _ba = bytes(_a);
212         bytes memory _bb = bytes(_b);
213         bytes memory _bc = bytes(_c);
214         bytes memory _bd = bytes(_d);
215         bytes memory _be = bytes(_e);
216         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
217         bytes memory babcde = bytes(abcde);
218         uint k = 0;
219         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
220         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
221         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
222         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
223         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
224         return string(babcde);
225     }
226     
227     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
228         return strConcat(_a, _b, _c, _d, "");
229     }
230 
231     function strConcat(string _a, string _b, string _c) internal returns (string) {
232         return strConcat(_a, _b, _c, "", "");
233     }
234 
235     function strConcat(string _a, string _b) internal returns (string) {
236         return strConcat(_a, _b, "", "", "");
237     }
238 
239     // parseInt
240     function parseInt(string _a) internal returns (uint) {
241         return parseInt(_a, 0);
242     }
243 
244     // parseInt(parseFloat*10^_b)
245     function parseInt(string _a, uint _b) internal returns (uint) {
246         bytes memory bresult = bytes(_a);
247         uint mint = 0;
248         bool decimals = false;
249         for (uint i=0; i<bresult.length; i++){
250             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
251                 if (decimals){
252                    if (_b == 0) break;
253                     else _b--;
254                 }
255                 mint *= 10;
256                 mint += uint(bresult[i]) - 48;
257             } else if (bresult[i] == 46) decimals = true;
258         }
259         return mint;
260     }
261     
262 
263 }
264 // </ORACLIZE_API>
265 
266 contract BitcoinBridge is usingOraclize {
267     string constant SHAPESHIFT_ENDPOINT =
268         "json(https://shapeshift.io/shift).deposit";
269 
270     struct Task {
271         bytes32 oraclizeId;
272         bytes bitcoinAddress;
273         uint value;
274         uint timestamp;
275     }
276 
277     mapping (uint => Task) public tasks;
278     mapping (bytes32 => uint) public oraclizeRequests;
279 
280     uint public nextId = 1;
281 
282     function queuePayment(bytes bitcoinAddress) oraclizeAPI
283                                                 returns (bool successful) {
284         uint oraclizePrice = oraclize.getPrice("URL");
285         if (msg.value <= oraclizePrice) throw;
286 
287         uint value = msg.value - oraclizePrice;
288 
289         uint id = nextId++;
290         string memory json = strConcat(
291             '{"pair": "eth_btc", "withdrawal": "',
292             string(bitcoinAddress),
293             '"}'
294         );
295         bytes32 oraclizeId = oraclize.query2.value(oraclizePrice)(
296             0,
297             "URL",
298             SHAPESHIFT_ENDPOINT,
299             json
300         );
301         tasks[id].oraclizeId = oraclizeId;
302         tasks[id].bitcoinAddress = bitcoinAddress;
303         tasks[id].value = value;
304         tasks[id].timestamp = now;
305         oraclizeRequests[oraclizeId] = id;
306 
307         return true;
308     }
309 
310     function __callback(bytes32 oraclizeId, string result) {
311         if (msg.sender != oraclize_cbAddress()) throw;
312 
313         uint id = oraclizeRequests[oraclizeId];
314         if (id == 0) return;
315 
316         address addr = parseAddr(result);
317         addr.send(tasks[id].value);
318 
319         delete oraclizeRequests[oraclizeId];
320         delete tasks[id];
321     }
322 
323     function retryOraclizeRequest(uint id) oraclizeAPI {
324         if (tasks[id].oraclizeId == 0) throw;
325 
326         uint timePassed = now - tasks[id].timestamp;
327         if (timePassed < 60 minutes) throw;
328 
329         uint oraclizePrice = oraclize.getPrice("URL");
330         if (msg.value < oraclizePrice) throw;
331 
332         string memory json = strConcat(
333             '{"pair": "eth_btc", "withdrawal": "',
334             string(tasks[id].bitcoinAddress),
335             '"}'
336         );
337         bytes32 newOraclizeId = oraclize.query2.value(oraclizePrice)(
338             0,
339             "URL",
340             SHAPESHIFT_ENDPOINT,
341             json
342         );
343 
344         delete oraclizeRequests[tasks[id].oraclizeId];
345         tasks[id].oraclizeId = newOraclizeId;
346         tasks[id].timestamp = now;
347         oraclizeRequests[newOraclizeId] = id;
348 
349         if (msg.value > oraclizePrice) {
350             msg.sender.send(msg.value - oraclizePrice);
351         }
352     }
353 }