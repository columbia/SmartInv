1 pragma solidity ^0.4.22;
2 
3 // File: contracts/libraries/SafeMath.sol
4 
5 /**
6  * @dev SafeMath by openzepplin
7  */ 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); 
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 // File: contracts/libraries/usingOraclize.sol
38 
39 // <ORACLIZE_API>
40 /*
41 Copyright (c) 2015-2016 Oraclize SRL
42 Copyright (c) 2016 Oraclize LTD
43 
44 
45 
46 Permission is hereby granted, free of charge, to any person obtaining a copy
47 of this software and associated documentation files (the "Software"), to deal
48 in the Software without restriction, including without limitation the rights
49 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
50 copies of the Software, and to permit persons to whom the Software is
51 furnished to do so, subject to the following conditions:
52 
53 
54 
55 The above copyright notice and this permission notice shall be included in
56 all copies or substantial portions of the Software.
57 
58 
59 
60 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
61 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
62 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
63 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
64 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
65 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
66 THE SOFTWARE.
67 */
68 
69 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
70 pragma solidity ^0.4.18;
71 
72 contract OraclizeI {
73     address public cbAddress;
74     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
75     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
76     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
77     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
78     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
79     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
80     function getPrice(string _datasource) public returns (uint _dsprice);
81     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
82     function setProofType(byte _proofType) external;
83     function setCustomGasPrice(uint _gasPrice) external;
84     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
85 }
86 contract OraclizeAddrResolverI {
87     function getAddress() public returns (address _addr);
88 }
89 contract usingOraclize {
90     uint constant day = 60*60*24;
91     uint constant week = 60*60*24*7;
92     uint constant month = 60*60*24*30;
93     byte constant proofType_NONE = 0x00;
94     byte constant proofType_TLSNotary = 0x10;
95     byte constant proofType_Android = 0x20;
96     byte constant proofType_Ledger = 0x30;
97     byte constant proofType_Native = 0xF0;
98     byte constant proofStorage_IPFS = 0x01;
99     uint8 constant networkID_auto = 0;
100     uint8 constant networkID_mainnet = 1;
101     uint8 constant networkID_testnet = 2;
102     uint8 constant networkID_morden = 2;
103     uint8 constant networkID_consensys = 161;
104 
105     OraclizeAddrResolverI OAR;
106 
107     OraclizeI oraclize;
108     modifier oraclizeAPI {
109         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
110             oraclize_setNetwork(networkID_auto);
111 
112         if(address(oraclize) != OAR.getAddress())
113             oraclize = OraclizeI(OAR.getAddress());
114 
115         _;
116     }
117     modifier coupon(string code){
118         oraclize = OraclizeI(OAR.getAddress());
119         _;
120     }
121 
122     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
123       return oraclize_setNetwork();
124       networkID; // silence the warning and remain backwards compatible
125     }
126     function oraclize_setNetwork() internal returns(bool){
127         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
128             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
129             oraclize_setNetworkName("eth_mainnet");
130             return true;
131         }
132         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
133             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
134             oraclize_setNetworkName("eth_ropsten3");
135             return true;
136         }
137         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
138             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
139             oraclize_setNetworkName("eth_kovan");
140             return true;
141         }
142         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
143             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
144             oraclize_setNetworkName("eth_rinkeby");
145             return true;
146         }
147         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
148             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
149             return true;
150         }
151         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
152             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
153             return true;
154         }
155         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
156             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
157             return true;
158         }
159         return false;
160     }
161 
162     function __callback(bytes32 myid, string result) public {
163         __callback(myid, result, new bytes(0));
164     }
165     function __callback(bytes32 myid, string result, bytes proof) public {
166       return;
167       myid; result; proof; // Silence compiler warnings
168     }
169 
170     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
171         return oraclize.getPrice(datasource);
172     }
173 
174     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
175         return oraclize.getPrice(datasource, gaslimit);
176     }
177 
178     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource);
180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
181         return oraclize.query.value(price)(0, datasource, arg);
182     }
183     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
186         return oraclize.query.value(price)(timestamp, datasource, arg);
187     }
188     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
189         uint price = oraclize.getPrice(datasource, gaslimit);
190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
191         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
192     }
193     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
194         uint price = oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
196         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
197     }
198     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource);
200         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
201         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
202     }
203     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource);
205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
206         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
207     }
208     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource, gaslimit);
210         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
211         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
212     }
213     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
214         uint price = oraclize.getPrice(datasource, gaslimit);
215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
216         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
217     }
218     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
219         uint price = oraclize.getPrice(datasource);
220         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
221         bytes memory args = stra2cbor(argN);
222         return oraclize.queryN.value(price)(0, datasource, args);
223     }
224     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
225         uint price = oraclize.getPrice(datasource);
226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
227         bytes memory args = stra2cbor(argN);
228         return oraclize.queryN.value(price)(timestamp, datasource, args);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource, gaslimit);
232         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
233         bytes memory args = stra2cbor(argN);
234         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
235     }
236     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
237         uint price = oraclize.getPrice(datasource, gaslimit);
238         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
239         bytes memory args = stra2cbor(argN);
240         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
241     }
242     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](1);
244         dynargs[0] = args[0];
245         return oraclize_query(datasource, dynargs);
246     }
247     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](1);
249         dynargs[0] = args[0];
250         return oraclize_query(timestamp, datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](1);
254         dynargs[0] = args[0];
255         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
256     }
257     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](1);
259         dynargs[0] = args[0];
260         return oraclize_query(datasource, dynargs, gaslimit);
261     }
262 
263     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
264         string[] memory dynargs = new string[](2);
265         dynargs[0] = args[0];
266         dynargs[1] = args[1];
267         return oraclize_query(datasource, dynargs);
268     }
269     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](2);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         return oraclize_query(timestamp, datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](2);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
280     }
281     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](2);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         return oraclize_query(datasource, dynargs, gaslimit);
286     }
287     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](3);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         return oraclize_query(datasource, dynargs);
293     }
294     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
295         string[] memory dynargs = new string[](3);
296         dynargs[0] = args[0];
297         dynargs[1] = args[1];
298         dynargs[2] = args[2];
299         return oraclize_query(timestamp, datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](3);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         dynargs[2] = args[2];
306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](3);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         return oraclize_query(datasource, dynargs, gaslimit);
314     }
315 
316     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
317         string[] memory dynargs = new string[](4);
318         dynargs[0] = args[0];
319         dynargs[1] = args[1];
320         dynargs[2] = args[2];
321         dynargs[3] = args[3];
322         return oraclize_query(datasource, dynargs);
323     }
324     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
325         string[] memory dynargs = new string[](4);
326         dynargs[0] = args[0];
327         dynargs[1] = args[1];
328         dynargs[2] = args[2];
329         dynargs[3] = args[3];
330         return oraclize_query(timestamp, datasource, dynargs);
331     }
332     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](4);
334         dynargs[0] = args[0];
335         dynargs[1] = args[1];
336         dynargs[2] = args[2];
337         dynargs[3] = args[3];
338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
339     }
340     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](4);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         dynargs[3] = args[3];
346         return oraclize_query(datasource, dynargs, gaslimit);
347     }
348     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](5);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         dynargs[2] = args[2];
353         dynargs[3] = args[3];
354         dynargs[4] = args[4];
355         return oraclize_query(datasource, dynargs);
356     }
357     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
358         string[] memory dynargs = new string[](5);
359         dynargs[0] = args[0];
360         dynargs[1] = args[1];
361         dynargs[2] = args[2];
362         dynargs[3] = args[3];
363         dynargs[4] = args[4];
364         return oraclize_query(timestamp, datasource, dynargs);
365     }
366     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
367         string[] memory dynargs = new string[](5);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         dynargs[2] = args[2];
371         dynargs[3] = args[3];
372         dynargs[4] = args[4];
373         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
374     }
375     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
376         string[] memory dynargs = new string[](5);
377         dynargs[0] = args[0];
378         dynargs[1] = args[1];
379         dynargs[2] = args[2];
380         dynargs[3] = args[3];
381         dynargs[4] = args[4];
382         return oraclize_query(datasource, dynargs, gaslimit);
383     }
384     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
387         bytes memory args = ba2cbor(argN);
388         return oraclize.queryN.value(price)(0, datasource, args);
389     }
390     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         bytes memory args = ba2cbor(argN);
394         return oraclize.queryN.value(price)(timestamp, datasource, args);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         bytes memory args = ba2cbor(argN);
400         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
401     }
402     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
403         uint price = oraclize.getPrice(datasource, gaslimit);
404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
405         bytes memory args = ba2cbor(argN);
406         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
407     }
408     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
409         bytes[] memory dynargs = new bytes[](1);
410         dynargs[0] = args[0];
411         return oraclize_query(datasource, dynargs);
412     }
413     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](1);
415         dynargs[0] = args[0];
416         return oraclize_query(timestamp, datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](1);
420         dynargs[0] = args[0];
421         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
422     }
423     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](1);
425         dynargs[0] = args[0];
426         return oraclize_query(datasource, dynargs, gaslimit);
427     }
428 
429     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
430         bytes[] memory dynargs = new bytes[](2);
431         dynargs[0] = args[0];
432         dynargs[1] = args[1];
433         return oraclize_query(datasource, dynargs);
434     }
435     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](2);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         return oraclize_query(timestamp, datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](2);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
446     }
447     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](2);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         return oraclize_query(datasource, dynargs, gaslimit);
452     }
453     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](3);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         return oraclize_query(datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
461         bytes[] memory dynargs = new bytes[](3);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         dynargs[2] = args[2];
465         return oraclize_query(timestamp, datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](3);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         dynargs[2] = args[2];
472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](3);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         return oraclize_query(datasource, dynargs, gaslimit);
480     }
481 
482     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
483         bytes[] memory dynargs = new bytes[](4);
484         dynargs[0] = args[0];
485         dynargs[1] = args[1];
486         dynargs[2] = args[2];
487         dynargs[3] = args[3];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
491         bytes[] memory dynargs = new bytes[](4);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         dynargs[3] = args[3];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](4);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         dynargs[3] = args[3];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](4);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         dynargs[3] = args[3];
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](5);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         dynargs[4] = args[4];
521         return oraclize_query(datasource, dynargs);
522     }
523     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
524         bytes[] memory dynargs = new bytes[](5);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         dynargs[2] = args[2];
528         dynargs[3] = args[3];
529         dynargs[4] = args[4];
530         return oraclize_query(timestamp, datasource, dynargs);
531     }
532     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
533         bytes[] memory dynargs = new bytes[](5);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         dynargs[4] = args[4];
539         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
540     }
541     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
542         bytes[] memory dynargs = new bytes[](5);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         dynargs[3] = args[3];
547         dynargs[4] = args[4];
548         return oraclize_query(datasource, dynargs, gaslimit);
549     }
550 
551     function oraclize_cbAddress() oraclizeAPI internal returns (address){
552         return oraclize.cbAddress();
553     }
554     function oraclize_setProof(byte proofP) oraclizeAPI internal {
555         return oraclize.setProofType(proofP);
556     }
557     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
558         return oraclize.setCustomGasPrice(gasPrice);
559     }
560 
561     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
562         return oraclize.randomDS_getSessionPubKeyHash();
563     }
564 
565     function getCodeSize(address _addr) constant internal returns(uint _size) {
566         assembly {
567             _size := extcodesize(_addr)
568         }
569     }
570 
571     function parseAddr(string _a) internal pure returns (address){
572         bytes memory tmp = bytes(_a);
573         uint160 iaddr = 0;
574         uint160 b1;
575         uint160 b2;
576         for (uint i=2; i<2+2*20; i+=2){
577             iaddr *= 256;
578             b1 = uint160(tmp[i]);
579             b2 = uint160(tmp[i+1]);
580             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
581             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
582             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
583             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
584             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
585             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
586             iaddr += (b1*16+b2);
587         }
588         return address(iaddr);
589     }
590 
591     function strCompare(string _a, string _b) internal pure returns (int) {
592         bytes memory a = bytes(_a);
593         bytes memory b = bytes(_b);
594         uint minLength = a.length;
595         if (b.length < minLength) minLength = b.length;
596         for (uint i = 0; i < minLength; i ++)
597             if (a[i] < b[i])
598                 return -1;
599             else if (a[i] > b[i])
600                 return 1;
601         if (a.length < b.length)
602             return -1;
603         else if (a.length > b.length)
604             return 1;
605         else
606             return 0;
607     }
608 
609     function indexOf(string _haystack, string _needle) internal pure returns (int) {
610         bytes memory h = bytes(_haystack);
611         bytes memory n = bytes(_needle);
612         if(h.length < 1 || n.length < 1 || (n.length > h.length))
613             return -1;
614         else if(h.length > (2**128 -1))
615             return -1;
616         else
617         {
618             uint subindex = 0;
619             for (uint i = 0; i < h.length; i ++)
620             {
621                 if (h[i] == n[0])
622                 {
623                     subindex = 1;
624                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
625                     {
626                         subindex++;
627                     }
628                     if(subindex == n.length)
629                         return int(i);
630                 }
631             }
632             return -1;
633         }
634     }
635 
636     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
637         bytes memory _ba = bytes(_a);
638         bytes memory _bb = bytes(_b);
639         bytes memory _bc = bytes(_c);
640         bytes memory _bd = bytes(_d);
641         bytes memory _be = bytes(_e);
642         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
643         bytes memory babcde = bytes(abcde);
644         uint k = 0;
645         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
646         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
647         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
648         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
649         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
650         return string(babcde);
651     }
652 
653     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
654         return strConcat(_a, _b, _c, _d, "");
655     }
656 
657     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
658         return strConcat(_a, _b, _c, "", "");
659     }
660 
661     function strConcat(string _a, string _b) internal pure returns (string) {
662         return strConcat(_a, _b, "", "", "");
663     }
664 
665     // parseInt
666     function parseInt(string _a) internal pure returns (uint) {
667         return parseInt(_a, 0);
668     }
669 
670     // parseInt(parseFloat*10^_b)
671     function parseInt(string _a, uint _b) internal pure returns (uint) {
672         bytes memory bresult = bytes(_a);
673         uint mint = 0;
674         bool decimals = false;
675         for (uint i=0; i<bresult.length; i++){
676             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
677                 if (decimals){
678                    if (_b == 0) break;
679                     else _b--;
680                 }
681                 mint *= 10;
682                 mint += uint(bresult[i]) - 48;
683             } else if (bresult[i] == 46) decimals = true;
684         }
685         if (_b > 0) mint *= 10**_b;
686         return mint;
687     }
688 
689     function uint2str(uint i) internal pure returns (string){
690         if (i == 0) return "0";
691         uint j = i;
692         uint len;
693         while (j != 0){
694             len++;
695             j /= 10;
696         }
697         bytes memory bstr = new bytes(len);
698         uint k = len - 1;
699         while (i != 0){
700             bstr[k--] = byte(48 + i % 10);
701             i /= 10;
702         }
703         return string(bstr);
704     }
705 
706     function stra2cbor(string[] arr) internal pure returns (bytes) {
707             uint arrlen = arr.length;
708 
709             // get correct cbor output length
710             uint outputlen = 0;
711             bytes[] memory elemArray = new bytes[](arrlen);
712             for (uint i = 0; i < arrlen; i++) {
713                 elemArray[i] = (bytes(arr[i]));
714                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
715             }
716             uint ctr = 0;
717             uint cborlen = arrlen + 0x80;
718             outputlen += byte(cborlen).length;
719             bytes memory res = new bytes(outputlen);
720 
721             while (byte(cborlen).length > ctr) {
722                 res[ctr] = byte(cborlen)[ctr];
723                 ctr++;
724             }
725             for (i = 0; i < arrlen; i++) {
726                 res[ctr] = 0x5F;
727                 ctr++;
728                 for (uint x = 0; x < elemArray[i].length; x++) {
729                     // if there's a bug with larger strings, this may be the culprit
730                     if (x % 23 == 0) {
731                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
732                         elemcborlen += 0x40;
733                         uint lctr = ctr;
734                         while (byte(elemcborlen).length > ctr - lctr) {
735                             res[ctr] = byte(elemcborlen)[ctr - lctr];
736                             ctr++;
737                         }
738                     }
739                     res[ctr] = elemArray[i][x];
740                     ctr++;
741                 }
742                 res[ctr] = 0xFF;
743                 ctr++;
744             }
745             return res;
746         }
747 
748     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
749             uint arrlen = arr.length;
750 
751             // get correct cbor output length
752             uint outputlen = 0;
753             bytes[] memory elemArray = new bytes[](arrlen);
754             for (uint i = 0; i < arrlen; i++) {
755                 elemArray[i] = (bytes(arr[i]));
756                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
757             }
758             uint ctr = 0;
759             uint cborlen = arrlen + 0x80;
760             outputlen += byte(cborlen).length;
761             bytes memory res = new bytes(outputlen);
762 
763             while (byte(cborlen).length > ctr) {
764                 res[ctr] = byte(cborlen)[ctr];
765                 ctr++;
766             }
767             for (i = 0; i < arrlen; i++) {
768                 res[ctr] = 0x5F;
769                 ctr++;
770                 for (uint x = 0; x < elemArray[i].length; x++) {
771                     // if there's a bug with larger strings, this may be the culprit
772                     if (x % 23 == 0) {
773                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
774                         elemcborlen += 0x40;
775                         uint lctr = ctr;
776                         while (byte(elemcborlen).length > ctr - lctr) {
777                             res[ctr] = byte(elemcborlen)[ctr - lctr];
778                             ctr++;
779                         }
780                     }
781                     res[ctr] = elemArray[i][x];
782                     ctr++;
783                 }
784                 res[ctr] = 0xFF;
785                 ctr++;
786             }
787             return res;
788         }
789 
790 
791     string oraclize_network_name;
792     function oraclize_setNetworkName(string _network_name) internal {
793         oraclize_network_name = _network_name;
794     }
795 
796     function oraclize_getNetworkName() internal view returns (string) {
797         return oraclize_network_name;
798     }
799 
800     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
801         require((_nbytes > 0) && (_nbytes <= 32));
802         // Convert from seconds to ledger timer ticks
803         _delay *= 10; 
804         bytes memory nbytes = new bytes(1);
805         nbytes[0] = byte(_nbytes);
806         bytes memory unonce = new bytes(32);
807         bytes memory sessionKeyHash = new bytes(32);
808         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
809         assembly {
810             mstore(unonce, 0x20)
811             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
812             mstore(sessionKeyHash, 0x20)
813             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
814         }
815         bytes memory delay = new bytes(32);
816         assembly { 
817             mstore(add(delay, 0x20), _delay) 
818         }
819         
820         bytes memory delay_bytes8 = new bytes(8);
821         copyBytes(delay, 24, 8, delay_bytes8, 0);
822 
823         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
824         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
825         
826         bytes memory delay_bytes8_left = new bytes(8);
827         
828         assembly {
829             let x := mload(add(delay_bytes8, 0x20))
830             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
831             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
832             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
833             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
834             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
835             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
836             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
837             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
838 
839         }
840         
841         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
842         return queryId;
843     }
844     
845     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
846         oraclize_randomDS_args[queryId] = commitment;
847     }
848 
849     mapping(bytes32=>bytes32) oraclize_randomDS_args;
850     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
851 
852     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
853         bool sigok;
854         address signer;
855 
856         bytes32 sigr;
857         bytes32 sigs;
858 
859         bytes memory sigr_ = new bytes(32);
860         uint offset = 4+(uint(dersig[3]) - 0x20);
861         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
862         bytes memory sigs_ = new bytes(32);
863         offset += 32 + 2;
864         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
865 
866         assembly {
867             sigr := mload(add(sigr_, 32))
868             sigs := mload(add(sigs_, 32))
869         }
870 
871 
872         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
873         if (address(keccak256(pubkey)) == signer) return true;
874         else {
875             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
876             return (address(keccak256(pubkey)) == signer);
877         }
878     }
879 
880     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
881         bool sigok;
882 
883         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
884         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
885         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
886 
887         bytes memory appkey1_pubkey = new bytes(64);
888         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
889 
890         bytes memory tosign2 = new bytes(1+65+32);
891         tosign2[0] = byte(1); //role
892         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
893         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
894         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
895         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
896 
897         if (sigok == false) return false;
898 
899 
900         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
901         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
902 
903         bytes memory tosign3 = new bytes(1+65);
904         tosign3[0] = 0xFE;
905         copyBytes(proof, 3, 65, tosign3, 1);
906 
907         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
908         copyBytes(proof, 3+65, sig3.length, sig3, 0);
909 
910         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
911 
912         return sigok;
913     }
914 
915     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
916         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
917         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
918 
919         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
920         require(proofVerified);
921 
922         _;
923     }
924 
925     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
926         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
927         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
928 
929         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
930         if (proofVerified == false) return 2;
931 
932         return 0;
933     }
934 
935     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
936         bool match_ = true;
937         
938         require(prefix.length == n_random_bytes);
939 
940         for (uint256 i=0; i< n_random_bytes; i++) {
941             if (content[i] != prefix[i]) match_ = false;
942         }
943 
944         return match_;
945     }
946 
947     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
948 
949         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
950         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
951         bytes memory keyhash = new bytes(32);
952         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
953         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
954 
955         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
956         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
957 
958         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
959         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
960 
961         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
962         // This is to verify that the computed args match with the ones specified in the query.
963         bytes memory commitmentSlice1 = new bytes(8+1+32);
964         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
965 
966         bytes memory sessionPubkey = new bytes(64);
967         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
968         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
969 
970         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
971         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
972             delete oraclize_randomDS_args[queryId];
973         } else return false;
974 
975 
976         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
977         bytes memory tosign1 = new bytes(32+8+1+32);
978         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
979         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
980 
981         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
982         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
983             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
984         }
985 
986         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
987     }
988 
989     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
990     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
991         uint minLength = length + toOffset;
992 
993         // Buffer too small
994         require(to.length >= minLength); // Should be a better way?
995 
996         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
997         uint i = 32 + fromOffset;
998         uint j = 32 + toOffset;
999 
1000         while (i < (32 + fromOffset + length)) {
1001             assembly {
1002                 let tmp := mload(add(from, i))
1003                 mstore(add(to, j), tmp)
1004             }
1005             i += 32;
1006             j += 32;
1007         }
1008 
1009         return to;
1010     }
1011 
1012     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1013     // Duplicate Solidity's ecrecover, but catching the CALL return value
1014     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1015         // We do our own memory management here. Solidity uses memory offset
1016         // 0x40 to store the current end of memory. We write past it (as
1017         // writes are memory extensions), but don't update the offset so
1018         // Solidity will reuse it. The memory used here is only needed for
1019         // this context.
1020 
1021         // FIXME: inline assembly can't access return values
1022         bool ret;
1023         address addr;
1024 
1025         assembly {
1026             let size := mload(0x40)
1027             mstore(size, hash)
1028             mstore(add(size, 32), v)
1029             mstore(add(size, 64), r)
1030             mstore(add(size, 96), s)
1031 
1032             // NOTE: we can reuse the request memory because we deal with
1033             //       the return code
1034             ret := call(3000, 1, 0, size, 128, size, 32)
1035             addr := mload(size)
1036         }
1037 
1038         return (ret, addr);
1039     }
1040 
1041     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1042     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1043         bytes32 r;
1044         bytes32 s;
1045         uint8 v;
1046 
1047         if (sig.length != 65)
1048           return (false, 0);
1049 
1050         // The signature format is a compact form of:
1051         //   {bytes32 r}{bytes32 s}{uint8 v}
1052         // Compact means, uint8 is not padded to 32 bytes.
1053         assembly {
1054             r := mload(add(sig, 32))
1055             s := mload(add(sig, 64))
1056 
1057             // Here we are loading the last 32 bytes. We exploit the fact that
1058             // 'mload' will pad with zeroes if we overread.
1059             // There is no 'mload8' to do this, but that would be nicer.
1060             v := byte(0, mload(add(sig, 96)))
1061 
1062             // Alternative solution:
1063             // 'byte' is not working due to the Solidity parser, so lets
1064             // use the second best option, 'and'
1065             // v := and(mload(add(sig, 65)), 255)
1066         }
1067 
1068         // albeit non-transactional signatures are not specified by the YP, one would expect it
1069         // to match the YP range of [27, 28]
1070         //
1071         // geth uses [0, 1] and some clients have followed. This might change, see:
1072         //  https://github.com/ethereum/go-ethereum/issues/2053
1073         if (v < 27)
1074           v += 27;
1075 
1076         if (v != 27 && v != 28)
1077             return (false, 0);
1078 
1079         return safer_ecrecover(hash, v, r, s);
1080     }
1081 
1082 }
1083 // </ORACLIZE_API>
1084 
1085 // File: contracts/VitalikLotto.sol
1086 
1087 contract VitalikLotto is usingOraclize {
1088 
1089     using SafeMath for uint256;
1090 
1091     // events 
1092     event DividendsWithdrawn(address beneficiary, uint256 ethValue);
1093     event DividendsReinvested(address beneficiary, uint256 dividends, uint256 tokenAmount);
1094     event LotteryCreated(uint256 identifier);
1095     event LotteryWinnerDetermined(address winner, uint256 winnerReward, address triggerer, uint256 triggererReward, uint256 random);
1096     event RandomRequested(uint256 identifier);
1097     event TokensPurchased(address beneficiary, uint256 tokenAmount, uint256 ethValue, address referrer);
1098     event TokensSold(address beneficiary, uint256 tokenAmount, uint256 ethValue);
1099 
1100     struct Lottery {
1101         bool instantiated;
1102         uint256 identifier;
1103         address[] ticketHolders;
1104         bool completed;
1105         uint256 reward;
1106     }
1107 
1108     // administration state variables
1109     uint256 constant internal ambassadorQuota = 4.8 ether;
1110     bool public pausedToPublic = true;
1111     bool public ambassadorMode = true;
1112     bool public pendingOraclize = false;
1113 
1114     // token state variables
1115     string constant public name = "Vitalik Lotto Token";
1116     string constant public symbol = "VLK";
1117     uint8 constant public decimals = 18;
1118     
1119     // game state variables
1120     uint constant minPurchaseAmount = 1 szabo; //0.000001 ether
1121     uint constant maxPurchaseAmount = 1000000 ether;
1122     uint256 constant internal initialTokenPrice = 0.0000001 ether;
1123     uint256 constant internal tokenIncrement = 0.00000001 ether;
1124     uint256 constant internal scaleFactor = 2**64;
1125     uint constant dividendFee = 5; // (1/5) = 20%
1126     uint constant referralFee = 3; // (1/3) = ~ 30%
1127     uint256 earningsPerToken;
1128     uint256 public tokenSupply;
1129     uint256 public contractBalance;
1130 
1131     // lotto state variables
1132     uint256 constant requiredLottoParticipants = 19;
1133     uint256 constant lottoFee = 10; // (1/10) = 10%
1134     uint256 constant lottoMin = .5 ether; 
1135     uint256 public lottoBalance;
1136     uint256 public lottoIdentifier;
1137     uint256 public lottoQueue;
1138 
1139     // administration mappings
1140     mapping (address => bool) public administrators;
1141     mapping (address => bool) public ambassadors;
1142 
1143     // game mappings
1144     mapping (address => int256) public payouts;
1145     mapping (address => uint256) internal referralBalance;
1146     mapping (address => uint256) public tokenBalance;
1147     mapping (address => address) public referrer; // safer alternative to cookie based referrals
1148 
1149     // lottery mappings
1150     mapping (uint256 => Lottery) lotteries;
1151     mapping (bytes32 => bool) lotteryRandomed;
1152     
1153     // contract constructor
1154     constructor() public {
1155         // grant the contract creator adminstration privileges
1156         administrators[msg.sender] = true;
1157         // create the first lottery
1158         _createLottery();
1159     }
1160 
1161     function activate() public {
1162         require(administrators[msg.sender] == true);
1163         require(pausedToPublic);
1164         pausedToPublic = false;
1165     }
1166 
1167     // returns the number of tokens for an user
1168     function balanceOf(address _user) public view returns(uint256) {
1169         return tokenBalance[_user];
1170     }
1171 
1172     function buyPrice() public view returns(uint256) {
1173         if(tokenSupply == 0) {
1174             return initialTokenPrice + tokenIncrement;
1175         } else {
1176             uint256 ethereum = _tokensToEthereum(1e18);
1177             uint256 dividends = SafeMath.div(ethereum, dividendFee);
1178             uint256 taxedEther = SafeMath.add(ethereum, dividends);
1179             return taxedEther;
1180         }
1181     }
1182 
1183     // an administrator can repeal the ambassador mode in case of an 
1184     // emergency / lack of funding
1185     function disableAmbassadorMode() public {
1186         require(administrators[msg.sender] == true);
1187         require(ambassadorMode);
1188         ambassadorMode = false;
1189     }
1190 
1191     // primary purchasing function which allows for a masternode referral
1192     function fund(address _referrer) public payable {
1193         require(getCodeSize(msg.sender) == 0);
1194         require(msg.value > minPurchaseAmount && msg.value < maxPurchaseAmount);
1195         contractBalance = SafeMath.add(contractBalance, msg.value);
1196         purchaseTokens(msg.value, _referrer);
1197     }
1198 
1199     // frontend function to get the referral balance of a user
1200     function getReferralBalance(address _user) public view returns (uint256) {
1201         return referralBalance[_user];
1202     }
1203 
1204     // returns the user's accumulated dividends, including the referral earnings
1205     function getUserDividends(address _user) public view returns (uint256) {
1206         return ((uint256) ((int256)(earningsPerToken * tokenBalance[_user]) - payouts[_user]) / scaleFactor) + (referralBalance[_user]);
1207     }
1208     
1209     // public function that allows a token holder to manually trigger the latest lottery
1210     // this saves on gas and potential failures during the purchase of tokens
1211     function invokeLottery() public {
1212         require(tokenBalance[msg.sender] > 0);
1213         Lottery storage lotto = lotteries[lottoQueue];
1214         require(lotto.instantiated);
1215         require(!lotto.completed);
1216         require(lotto.ticketHolders.length == requiredLottoParticipants);
1217         require(!pendingOraclize);
1218         pendingOraclize = true;
1219         emit RandomRequested(lotto.identifier);
1220         // generate an oraclize query by calling wolfram alpha
1221         // both the min and the max are inclusive
1222         oraclize_query("WolframAlpha", "random number between 0 and 18");
1223     }
1224 
1225     function purchaseTokens(uint256 _ethValue, address _referrer) contributionPhase() internal returns(uint256) {
1226         uint256 lottoFunds = SafeMath.div(_ethValue, lottoFee);
1227         uint256 undividedDividends = SafeMath.div(SafeMath.sub(_ethValue, lottoFunds), dividendFee);
1228         uint256 referralFunds = SafeMath.div(undividedDividends, referralFee);
1229         uint256 dividends = SafeMath.sub(undividedDividends, referralFunds);
1230         uint256 taxedEther = SafeMath.sub(_ethValue, dividends);
1231         uint256 tokenAmount = _ethereumToTokens(taxedEther);
1232         uint256 fee = dividends * scaleFactor;
1233 
1234         // if no referrer has been passed to the contract, check to see
1235         // if the user has already been referred by someone, previously.
1236         // this will also override a new referral attempt and use the initial referrer
1237         if(referrer[msg.sender] != 0x0000000000000000000000000000000000000000){
1238             _referrer = referrer[msg.sender];
1239         }
1240         // ensure the referrer has at least 100 tokens; otherwise set the
1241         // referrer to nilll
1242         if(tokenBalance[_referrer] < 100e18){
1243             _referrer = 0x0000000000000000000000000000000000000000;
1244         }
1245         // masternode referral check
1246         if(_referrer != 0x0000000000000000000000000000000000000000 && _referrer != msg.sender && 
1247             tokenBalance[_referrer] >= 100e18){ // 100 token masternode requirement
1248             // referrer receives their bonus
1249             referralBalance[_referrer] = SafeMath.add(referralBalance[_referrer], referralFunds);
1250             // store the referral for life
1251             referrer[msg.sender] = _referrer;
1252         } else {
1253             // there was no referrer, or the referrer does not have enough tokens
1254             dividends = SafeMath.add(dividends, referralFunds);
1255             // recalculate fee 
1256             fee = dividends * scaleFactor;
1257         }
1258         if(tokenSupply > 0){
1259             tokenSupply = SafeMath.add(tokenSupply, tokenAmount);
1260             earningsPerToken += (dividends * scaleFactor / (tokenSupply));
1261             fee = fee - (fee-(tokenAmount * (dividends * scaleFactor / (tokenSupply))));
1262         } else {
1263             tokenSupply = tokenAmount;
1264         }
1265         // add the lotto funds to the lotto balance
1266         lottoBalance = SafeMath.add(lottoBalance, lottoFunds);
1267         tokenBalance[msg.sender] = SafeMath.add(tokenBalance[msg.sender], tokenAmount);
1268         int256 purchasePayout = (int256)((earningsPerToken * tokenAmount) - fee);
1269         payouts[msg.sender] += purchasePayout;
1270         // if the msg.sender contributes .5 ether or more, they are eligible for the lottery
1271         if(_ethValue >= lottoMin) {
1272             Lottery storage lotto = lotteries[lottoIdentifier];
1273             lotto.ticketHolders.push(msg.sender);
1274             // every 19th lottery entry should trigger the drawing
1275             if(lotto.ticketHolders.length == requiredLottoParticipants){
1276                 uint256 lottoReward = lottoBalance;
1277                 lottoBalance = 0;
1278                 // set lottery reward
1279                 lotto.reward = lottoReward;
1280                 // increment lottery identifier and create a fresh, empty one
1281                 lottoIdentifier++;
1282                 _createLottery();
1283             }
1284         }  
1285         emit TokensPurchased(msg.sender, tokenAmount, _ethValue, _referrer);
1286         return tokenAmount;
1287     }
1288 
1289     function reinvest() public {
1290         address user = msg.sender;
1291         uint256 dividends = SafeMath.sub(getUserDividends(user), referralBalance[user]);
1292         require(dividends > 0);
1293         payouts[user] += (int256)(dividends * scaleFactor);
1294         dividends += referralBalance[user];
1295         referralBalance[user] = 0;
1296         uint256 tokenAmount = purchaseTokens(dividends, address(0x0));
1297         emit DividendsReinvested(user, dividends, tokenAmount);
1298     }
1299 
1300     function sell(uint256 _tokenAmount) public {
1301         address user = msg.sender;
1302         require(tokenBalance[user] > 0);
1303         require(_tokenAmount <= tokenBalance[user]);
1304         uint256 ethValue = _tokensToEthereum(_tokenAmount);
1305         uint256 lottoFunds = SafeMath.div(ethValue, lottoFee);
1306         // add the lotto funds to the lotto balance
1307         lottoBalance = SafeMath.add(lottoBalance, lottoFunds);
1308         uint256 dividends = SafeMath.div(SafeMath.sub(ethValue, lottoFunds), dividendFee);
1309         uint256 taxedEther = SafeMath.sub(ethValue, dividends);
1310         tokenSupply = SafeMath.sub(tokenSupply, _tokenAmount);
1311         tokenBalance[user] = SafeMath.sub(tokenBalance[user], _tokenAmount);
1312         int256 payout = (int256) (earningsPerToken * _tokenAmount + (taxedEther * scaleFactor));
1313         payouts[user] -= payout;      
1314         if (tokenSupply > 0) {
1315             earningsPerToken = SafeMath.add(earningsPerToken, (dividends * scaleFactor) / tokenSupply);
1316         }
1317         emit TokensSold(user, _tokenAmount, taxedEther);
1318     }
1319 
1320     function sellPrice() public view returns(uint256) {
1321         if(tokenSupply == 0){
1322             return initialTokenPrice - tokenIncrement;
1323         } else {
1324             uint256 ethereum = _tokensToEthereum(1e18);
1325             uint256 dividends = SafeMath.div(ethereum, dividendFee);
1326             uint256 taxedEther = SafeMath.sub(ethereum, dividends);
1327             return taxedEther;
1328         }
1329     }
1330 
1331     // administrator can whitelist an administrator
1332     function setAdministrator(address _user) public {
1333         require(administrators[msg.sender] == true);
1334         administrators[_user] = true;
1335     }
1336 
1337     // administrator can whitelist an ambassador
1338     function setAmbassador(address _user) public {
1339         require(administrators[msg.sender] == true);
1340         ambassadors[_user] = true;
1341     }
1342 
1343     function totalSupply() public view returns(uint256) {
1344         return tokenSupply;
1345     }
1346 
1347     function withdraw() public {
1348         address user = msg.sender;
1349         uint256 dividends = SafeMath.sub(getUserDividends(user), referralBalance[user]);
1350         require(dividends > 0);
1351         payouts[user] += (int256) (dividends * scaleFactor);
1352         // reset accumulated referral earnings
1353         referralBalance[user] = 0;
1354         dividends += referralBalance[user];
1355         // update the contract balance
1356         contractBalance = SafeMath.sub(contractBalance, dividends);
1357         user.transfer(dividends);
1358         emit DividendsWithdrawn(user, dividends);
1359     }
1360 
1361     // purchase tokens by sending funds directly to the contract
1362     function () payable public {
1363         require(getCodeSize(msg.sender) == 0);
1364         // call funding function with a blank referrer
1365         fund(address(0x0000000000000000000000000000000000000000));
1366     }
1367 
1368     /*
1369         MODIFIERS
1370     */
1371 
1372     // modifier function that checks if only ambassadors can currently contribute
1373     modifier contributionPhase(){
1374         if(ambassadorMode) {
1375             if((contractBalance < ambassadorQuota)) {
1376                 require(ambassadors[msg.sender]);
1377                 _;
1378             } else {
1379                 ambassadorMode = false;
1380                 _;
1381             }
1382         } else {
1383             require(!pausedToPublic);
1384             _;
1385         }
1386     }
1387 
1388     /*
1389         INTERNAL FUNCTIONS
1390     */
1391 
1392     function __callback(bytes32 _queryId, string _result) public {
1393         require(msg.sender == oraclize_cbAddress());
1394         require(lotteryRandomed[_queryId] == false);
1395         Lottery storage lotto = lotteries[lottoQueue];
1396         require(!lotto.completed);
1397         uint256 triggererReward;
1398         uint256 winnerReward;
1399         address winner;
1400         address triggerer;
1401         // parseInt function is available in usingOraclize contract
1402         uint256 random = uint256(parseInt(_result));
1403         (winnerReward, triggererReward, winner, triggerer) = _rewardLotteryWinners(lottoQueue, random);
1404         lottoQueue++;
1405         lotteryRandomed[_queryId] = true;
1406         pendingOraclize = false;
1407         emit LotteryWinnerDetermined(winner, winnerReward, triggerer, triggererReward, random);
1408     }
1409 
1410     function _createLottery() internal {
1411         Lottery memory newLotto = Lottery(true, lottoIdentifier, new address[](0), false, 0);
1412         lotteries[lottoIdentifier] = newLotto;
1413         emit LotteryCreated(lottoIdentifier);
1414     }
1415 
1416     function _ethereumToTokens(uint256 _ethereum) internal view returns(uint256) {
1417         uint256 _tokenPriceInitial = initialTokenPrice * 1e18;
1418         uint256 tokenAmount = 
1419          (
1420             (
1421                 SafeMath.sub(
1422                     (_sqrt
1423                         (
1424                             (_tokenPriceInitial**2)
1425                             +
1426                             (2*(tokenIncrement * 1e18)*(_ethereum * 1e18))
1427                             +
1428                             (((tokenIncrement)**2)*(tokenSupply**2))
1429                             +
1430                             (2*(tokenIncrement)*_tokenPriceInitial*tokenSupply)
1431                         )
1432                     ), _tokenPriceInitial
1433                 )
1434             )/(tokenIncrement)
1435         )-(tokenSupply)
1436         ;
1437         return tokenAmount;
1438     }
1439 
1440     function _rewardLotteryWinners(uint256 _identifier, uint256 _result) internal returns (uint256, uint256, address, address) {
1441         Lottery storage lotto = lotteries[_identifier];
1442         // reward for being the 19th participant
1443         uint256 triggererFunds = SafeMath.div(lotto.reward, 5);
1444         // reward for the lucky ticket holder
1445         uint256 luckyFunds = SafeMath.sub(lotto.reward, triggererFunds);
1446         // the triggerer is the last index of the array
1447         address triggerer = lotto.ticketHolders[requiredLottoParticipants - 1];
1448         address winner = lotto.ticketHolders[_result];
1449         winner.transfer(luckyFunds);
1450         triggerer.transfer(triggererFunds);
1451         contractBalance = SafeMath.sub(contractBalance, lotto.reward);
1452         lotto.completed = true;
1453         return (luckyFunds, triggererFunds, winner, triggerer);
1454     }
1455 
1456     function _sqrt(uint x) internal pure returns (uint y) {
1457         uint z = (x + 1) / 2;
1458         y = x;
1459         while (z < y) {
1460             y = z;
1461             z = (x / z + z) / 2;
1462         }
1463     }
1464 
1465     function _tokensToEthereum(uint256 _tokens) public view returns(uint256) {
1466         uint256 tokens = (_tokens + 1e18);
1467         uint256 supply = (tokenSupply + 1e18);
1468         uint256 ethValue =
1469         (
1470             SafeMath.sub(
1471                 (
1472                     (
1473                         (
1474                             initialTokenPrice +(tokenIncrement * (supply/1e18))
1475                         )-tokenIncrement
1476                     )*(tokens - 1e18)
1477                 ),(tokenIncrement*((tokens**2-tokens)/1e18))/2
1478             )
1479         /1e18);
1480         return ethValue;
1481     }
1482 }