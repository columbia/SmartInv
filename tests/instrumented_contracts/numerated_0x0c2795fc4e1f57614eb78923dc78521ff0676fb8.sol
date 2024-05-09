1 pragma solidity ^0.4.20;
2 
3 //standart library for uint
4 library SafeMath { 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 
25   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
26     if (b == 0){
27       return 1;
28     }
29     uint256 c = a**b;
30     assert (c >= a);
31     return c;
32   }
33 }
34 
35 //standart contract to identify owner
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   address public techSupport;
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   modifier onlyTechSupport() {
50     require(msg.sender == techSupport);
51     _;
52   }
53 
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   function transferOwnership(address _newOwner) public onlyOwner {
59     require(_newOwner != address(0));
60     newOwner = _newOwner;
61   }
62 
63   function acceptOwnership() public {
64     if (msg.sender == newOwner) {
65       owner = newOwner;
66     }
67   }
68 
69   function transferTechSupport (address _address) public onlyOwner {
70     require (_address != address(0));
71     techSupport = _address;
72   }
73 }
74 
75 
76 
77 // <ORACLIZE_API>
78 /*
79 Copyright (c) 2015-2016 Oraclize SRL
80 Copyright (c) 2016 Oraclize LTD
81 
82 
83 
84 Permission is hereby granted, free of charge, to any person obtaining a copy
85 of this software and associated documentation files (the "Software"), to deal
86 in the Software without restriction, including without limitation the rights
87 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
88 copies of the Software, and to permit persons to whom the Software is
89 furnished to do so, subject to the following conditions:
90 
91 
92 
93 The above copyright notice and this permission notice shall be included in
94 all copies or substantial portions of the Software.
95 
96 
97 
98 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
99 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
100 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
101 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
102 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
103 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
104 THE SOFTWARE.
105 */
106 
107 contract OraclizeI {
108     address public cbAddress;
109     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
110     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
111     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
112     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
113     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
114     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
115     function getPrice(string _datasource) returns (uint _dsprice);
116     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
117     function useCoupon(string _coupon);
118     function setProofType(byte _proofType);
119     function setConfig(bytes32 _config);
120     function setCustomGasPrice(uint _gasPrice);
121     function randomDS_getSessionPubKeyHash() returns(bytes32);
122 }
123 contract OraclizeAddrResolverI {
124     function getAddress() returns (address _addr);
125 }
126 contract usingOraclize {
127     uint constant day = 60*60*24;
128     uint constant week = 60*60*24*7;
129     uint constant month = 60*60*24*30;
130     byte constant proofType_NONE = 0x00;
131     byte constant proofType_TLSNotary = 0x10;
132     byte constant proofType_Android = 0x20;
133     byte constant proofType_Ledger = 0x30;
134     byte constant proofType_Native = 0xF0;
135     byte constant proofStorage_IPFS = 0x01;
136     uint8 constant networkID_auto = 0;
137     uint8 constant networkID_mainnet = 1;
138     uint8 constant networkID_testnet = 2;
139     uint8 constant networkID_morden = 2;
140     uint8 constant networkID_consensys = 161;
141 
142     OraclizeAddrResolverI OAR;
143 
144     OraclizeI oraclize;
145     modifier oraclizeAPI {
146         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
147         oraclize = OraclizeI(OAR.getAddress());
148         _;
149     }
150     modifier coupon(string code){
151         oraclize = OraclizeI(OAR.getAddress());
152         oraclize.useCoupon(code);
153         _;
154     }
155 
156     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
157         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
158             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
159             oraclize_setNetworkName("eth_mainnet");
160             return true;
161         }
162         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
163             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
164             oraclize_setNetworkName("eth_ropsten3");
165             return true;
166         }
167         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
168             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
169             oraclize_setNetworkName("eth_kovan");
170             return true;
171         }
172         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
173             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
174             oraclize_setNetworkName("eth_rinkeby");
175             return true;
176         }
177         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
178             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
179             return true;
180         }
181         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
182             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
183             return true;
184         }
185         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
186             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
187             return true;
188         }
189         return false;
190     }
191 
192     function __callback(bytes32 myid, string result) {
193         __callback(myid, result, new bytes(0));
194     }
195     function __callback(bytes32 myid, string result, bytes proof) {
196     }
197     
198     function oraclize_useCoupon(string code) oraclizeAPI internal {
199         oraclize.useCoupon(code);
200     }
201 
202     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
203         return oraclize.getPrice(datasource);
204     }
205 
206     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
207         return oraclize.getPrice(datasource, gaslimit);
208     }
209     
210     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
211         uint price = oraclize.getPrice(datasource);
212         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
213         return oraclize.query.value(price)(0, datasource, arg);
214     }
215     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
216         uint price = oraclize.getPrice(datasource);
217         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
218         return oraclize.query.value(price)(timestamp, datasource, arg);
219     }
220     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
221         uint price = oraclize.getPrice(datasource, gaslimit);
222         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
223         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
224     }
225     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
226         uint price = oraclize.getPrice(datasource, gaslimit);
227         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
228         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
229     }
230     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
231         uint price = oraclize.getPrice(datasource);
232         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
233         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
234     }
235     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
236         uint price = oraclize.getPrice(datasource);
237         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
238         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
239     }
240     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
241         uint price = oraclize.getPrice(datasource, gaslimit);
242         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
243         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
244     }
245     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
246         uint price = oraclize.getPrice(datasource, gaslimit);
247         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
248         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
249     }
250     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
251         uint price = oraclize.getPrice(datasource);
252         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
253         bytes memory args = stra2cbor(argN);
254         return oraclize.queryN.value(price)(0, datasource, args);
255     }
256     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
257         uint price = oraclize.getPrice(datasource);
258         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
259         bytes memory args = stra2cbor(argN);
260         return oraclize.queryN.value(price)(timestamp, datasource, args);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
263         uint price = oraclize.getPrice(datasource, gaslimit);
264         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
265         bytes memory args = stra2cbor(argN);
266         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
267     }
268     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
269         uint price = oraclize.getPrice(datasource, gaslimit);
270         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
271         bytes memory args = stra2cbor(argN);
272         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
273     }
274     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](1);
276         dynargs[0] = args[0];
277         return oraclize_query(datasource, dynargs);
278     }
279     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](1);
281         dynargs[0] = args[0];
282         return oraclize_query(timestamp, datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](1);
286         dynargs[0] = args[0];
287         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
288     }
289     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](1);
291         dynargs[0] = args[0];       
292         return oraclize_query(datasource, dynargs, gaslimit);
293     }
294     
295     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](2);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         return oraclize_query(datasource, dynargs);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](2);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         return oraclize_query(timestamp, datasource, dynargs);
306     }
307     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](2);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
312     }
313     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](2);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         return oraclize_query(datasource, dynargs, gaslimit);
318     }
319     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
320         string[] memory dynargs = new string[](3);
321         dynargs[0] = args[0];
322         dynargs[1] = args[1];
323         dynargs[2] = args[2];
324         return oraclize_query(datasource, dynargs);
325     }
326     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](3);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         return oraclize_query(timestamp, datasource, dynargs);
332     }
333     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
334         string[] memory dynargs = new string[](3);
335         dynargs[0] = args[0];
336         dynargs[1] = args[1];
337         dynargs[2] = args[2];
338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
339     }
340     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](3);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         dynargs[2] = args[2];
345         return oraclize_query(datasource, dynargs, gaslimit);
346     }
347     
348     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](4);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         dynargs[2] = args[2];
353         dynargs[3] = args[3];
354         return oraclize_query(datasource, dynargs);
355     }
356     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](4);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         return oraclize_query(timestamp, datasource, dynargs);
363     }
364     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
365         string[] memory dynargs = new string[](4);
366         dynargs[0] = args[0];
367         dynargs[1] = args[1];
368         dynargs[2] = args[2];
369         dynargs[3] = args[3];
370         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
371     }
372     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         string[] memory dynargs = new string[](4);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         dynargs[2] = args[2];
377         dynargs[3] = args[3];
378         return oraclize_query(datasource, dynargs, gaslimit);
379     }
380     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
381         string[] memory dynargs = new string[](5);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         dynargs[2] = args[2];
385         dynargs[3] = args[3];
386         dynargs[4] = args[4];
387         return oraclize_query(datasource, dynargs);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
390         string[] memory dynargs = new string[](5);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         dynargs[2] = args[2];
394         dynargs[3] = args[3];
395         dynargs[4] = args[4];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](5);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         dynargs[3] = args[3];
404         dynargs[4] = args[4];
405         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](5);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         dynargs[2] = args[2];
412         dynargs[3] = args[3];
413         dynargs[4] = args[4];
414         return oraclize_query(datasource, dynargs, gaslimit);
415     }
416     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         bytes memory args = ba2cbor(argN);
420         return oraclize.queryN.value(price)(0, datasource, args);
421     }
422     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource);
424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425         bytes memory args = ba2cbor(argN);
426         return oraclize.queryN.value(price)(timestamp, datasource, args);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource, gaslimit);
430         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
431         bytes memory args = ba2cbor(argN);
432         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         bytes memory args = ba2cbor(argN);
438         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
439     }
440     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
446         bytes[] memory dynargs = new bytes[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(timestamp, datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](1);
457         dynargs[0] = args[0];       
458         return oraclize_query(datasource, dynargs, gaslimit);
459     }
460     
461     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
486         bytes[] memory dynargs = new bytes[](3);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(timestamp, datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         bytes[] memory dynargs = new bytes[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513     
514     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
523         bytes[] memory dynargs = new bytes[](4);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         return oraclize_query(timestamp, datasource, dynargs);
529     }
530     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
531         bytes[] memory dynargs = new bytes[](4);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         bytes[] memory dynargs = new bytes[](4);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         return oraclize_query(datasource, dynargs, gaslimit);
545     }
546     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
556         bytes[] memory dynargs = new bytes[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(datasource, dynargs, gaslimit);
581     }
582 
583     function oraclize_cbAddress() oraclizeAPI internal returns (address){
584         return oraclize.cbAddress();
585     }
586     function oraclize_setProof(byte proofP) oraclizeAPI internal {
587         return oraclize.setProofType(proofP);
588     }
589     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
590         return oraclize.setCustomGasPrice(gasPrice);
591     }
592     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
593         return oraclize.setConfig(config);
594     }
595     
596     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
597         return oraclize.randomDS_getSessionPubKeyHash();
598     }
599 
600     function getCodeSize(address _addr) constant internal returns(uint _size) {
601         assembly {
602             _size := extcodesize(_addr)
603         }
604     }
605 
606     function parseAddr(string _a) internal returns (address){
607         bytes memory tmp = bytes(_a);
608         uint160 iaddr = 0;
609         uint160 b1;
610         uint160 b2;
611         for (uint i=2; i<2+2*20; i+=2){
612             iaddr *= 256;
613             b1 = uint160(tmp[i]);
614             b2 = uint160(tmp[i+1]);
615             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
616             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
617             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
618             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
619             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
620             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
621             iaddr += (b1*16+b2);
622         }
623         return address(iaddr);
624     }
625 
626     function strCompare(string _a, string _b) internal returns (int) {
627         bytes memory a = bytes(_a);
628         bytes memory b = bytes(_b);
629         uint minLength = a.length;
630         if (b.length < minLength) minLength = b.length;
631         for (uint i = 0; i < minLength; i ++)
632             if (a[i] < b[i])
633                 return -1;
634             else if (a[i] > b[i])
635                 return 1;
636         if (a.length < b.length)
637             return -1;
638         else if (a.length > b.length)
639             return 1;
640         else
641             return 0;
642     }
643 
644     function indexOf(string _haystack, string _needle) internal returns (int) {
645         bytes memory h = bytes(_haystack);
646         bytes memory n = bytes(_needle);
647         if(h.length < 1 || n.length < 1 || (n.length > h.length))
648             return -1;
649         else if(h.length > (2**128 -1))
650             return -1;
651         else
652         {
653             uint subindex = 0;
654             for (uint i = 0; i < h.length; i ++)
655             {
656                 if (h[i] == n[0])
657                 {
658                     subindex = 1;
659                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
660                     {
661                         subindex++;
662                     }
663                     if(subindex == n.length)
664                         return int(i);
665                 }
666             }
667             return -1;
668         }
669     }
670 
671     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
672         bytes memory _ba = bytes(_a);
673         bytes memory _bb = bytes(_b);
674         bytes memory _bc = bytes(_c);
675         bytes memory _bd = bytes(_d);
676         bytes memory _be = bytes(_e);
677         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
678         bytes memory babcde = bytes(abcde);
679         uint k = 0;
680         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
681         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
682         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
683         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
684         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
685         return string(babcde);
686     }
687 
688     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
689         return strConcat(_a, _b, _c, _d, "");
690     }
691 
692     function strConcat(string _a, string _b, string _c) internal returns (string) {
693         return strConcat(_a, _b, _c, "", "");
694     }
695 
696     function strConcat(string _a, string _b) internal returns (string) {
697         return strConcat(_a, _b, "", "", "");
698     }
699 
700     // parseInt
701     function parseInt(string _a) internal returns (uint) {
702         return parseInt(_a, 0);
703     }
704 
705     // parseInt(parseFloat*10^_b)
706     function parseInt(string _a, uint _b) internal returns (uint) {
707         bytes memory bresult = bytes(_a);
708         uint mint = 0;
709         bool decimals = false;
710         for (uint i=0; i<bresult.length; i++){
711             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
712                 if (decimals){
713                    if (_b == 0) break;
714                     else _b--;
715                 }
716                 mint *= 10;
717                 mint += uint(bresult[i]) - 48;
718             } else if (bresult[i] == 46) decimals = true;
719         }
720         if (_b > 0) mint *= 10**_b;
721         return mint;
722     }
723 
724     function uint2str(uint i) internal returns (string){
725         if (i == 0) return "0";
726         uint j = i;
727         uint len;
728         while (j != 0){
729             len++;
730             j /= 10;
731         }
732         bytes memory bstr = new bytes(len);
733         uint k = len - 1;
734         while (i != 0){
735             bstr[k--] = byte(48 + i % 10);
736             i /= 10;
737         }
738         return string(bstr);
739     }
740     
741     function stra2cbor(string[] arr) internal returns (bytes) {
742             uint arrlen = arr.length;
743 
744             // get correct cbor output length
745             uint outputlen = 0;
746             bytes[] memory elemArray = new bytes[](arrlen);
747             for (uint i = 0; i < arrlen; i++) {
748                 elemArray[i] = (bytes(arr[i]));
749                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
750             }
751             uint ctr = 0;
752             uint cborlen = arrlen + 0x80;
753             outputlen += byte(cborlen).length;
754             bytes memory res = new bytes(outputlen);
755 
756             while (byte(cborlen).length > ctr) {
757                 res[ctr] = byte(cborlen)[ctr];
758                 ctr++;
759             }
760             for (i = 0; i < arrlen; i++) {
761                 res[ctr] = 0x5F;
762                 ctr++;
763                 for (uint x = 0; x < elemArray[i].length; x++) {
764                     // if there's a bug with larger strings, this may be the culprit
765                     if (x % 23 == 0) {
766                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
767                         elemcborlen += 0x40;
768                         uint lctr = ctr;
769                         while (byte(elemcborlen).length > ctr - lctr) {
770                             res[ctr] = byte(elemcborlen)[ctr - lctr];
771                             ctr++;
772                         }
773                     }
774                     res[ctr] = elemArray[i][x];
775                     ctr++;
776                 }
777                 res[ctr] = 0xFF;
778                 ctr++;
779             }
780             return res;
781         }
782 
783     function ba2cbor(bytes[] arr) internal returns (bytes) {
784             uint arrlen = arr.length;
785 
786             // get correct cbor output length
787             uint outputlen = 0;
788             bytes[] memory elemArray = new bytes[](arrlen);
789             for (uint i = 0; i < arrlen; i++) {
790                 elemArray[i] = (bytes(arr[i]));
791                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
792             }
793             uint ctr = 0;
794             uint cborlen = arrlen + 0x80;
795             outputlen += byte(cborlen).length;
796             bytes memory res = new bytes(outputlen);
797 
798             while (byte(cborlen).length > ctr) {
799                 res[ctr] = byte(cborlen)[ctr];
800                 ctr++;
801             }
802             for (i = 0; i < arrlen; i++) {
803                 res[ctr] = 0x5F;
804                 ctr++;
805                 for (uint x = 0; x < elemArray[i].length; x++) {
806                     // if there's a bug with larger strings, this may be the culprit
807                     if (x % 23 == 0) {
808                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
809                         elemcborlen += 0x40;
810                         uint lctr = ctr;
811                         while (byte(elemcborlen).length > ctr - lctr) {
812                             res[ctr] = byte(elemcborlen)[ctr - lctr];
813                             ctr++;
814                         }
815                     }
816                     res[ctr] = elemArray[i][x];
817                     ctr++;
818                 }
819                 res[ctr] = 0xFF;
820                 ctr++;
821             }
822             return res;
823         }
824         
825         
826     string oraclize_network_name;
827     function oraclize_setNetworkName(string _network_name) internal {
828         oraclize_network_name = _network_name;
829     }
830     
831     function oraclize_getNetworkName() internal returns (string) {
832         return oraclize_network_name;
833     }
834     
835     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
836         if ((_nbytes == 0)||(_nbytes > 32)) throw;
837         bytes memory nbytes = new bytes(1);
838         nbytes[0] = byte(_nbytes);
839         bytes memory unonce = new bytes(32);
840         bytes memory sessionKeyHash = new bytes(32);
841         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
842         assembly {
843             mstore(unonce, 0x20)
844             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
845             mstore(sessionKeyHash, 0x20)
846             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
847         }
848         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
849         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
850         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
851         return queryId;
852     }
853     
854     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
855         oraclize_randomDS_args[queryId] = commitment;
856     }
857     
858     mapping(bytes32=>bytes32) oraclize_randomDS_args;
859     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
860 
861     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
862         bool sigok;
863         address signer;
864         
865         bytes32 sigr;
866         bytes32 sigs;
867         
868         bytes memory sigr_ = new bytes(32);
869         uint offset = 4+(uint(dersig[3]) - 0x20);
870         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
871         bytes memory sigs_ = new bytes(32);
872         offset += 32 + 2;
873         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
874 
875         assembly {
876             sigr := mload(add(sigr_, 32))
877             sigs := mload(add(sigs_, 32))
878         }
879         
880         
881         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
882         if (address(sha3(pubkey)) == signer) return true;
883         else {
884             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
885             return (address(sha3(pubkey)) == signer);
886         }
887     }
888 
889     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
890         bool sigok;
891         
892         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
893         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
894         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
895         
896         bytes memory appkey1_pubkey = new bytes(64);
897         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
898         
899         bytes memory tosign2 = new bytes(1+65+32);
900         tosign2[0] = 1; //role
901         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
902         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
903         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
904         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
905         
906         if (sigok == false) return false;
907         
908         
909         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
910         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
911         
912         bytes memory tosign3 = new bytes(1+65);
913         tosign3[0] = 0xFE;
914         copyBytes(proof, 3, 65, tosign3, 1);
915         
916         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
917         copyBytes(proof, 3+65, sig3.length, sig3, 0);
918         
919         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
920         
921         return sigok;
922     }
923     
924     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
925         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
926         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
927         
928         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
929         if (proofVerified == false) throw;
930         
931         _;
932     }
933     
934     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
935         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
936         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
937         
938         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
939         if (proofVerified == false) return 2;
940         
941         return 0;
942     }
943     
944     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
945         bool match_ = true;
946         
947         for (var i=0; i<prefix.length; i++){
948             if (content[i] != prefix[i]) match_ = false;
949         }
950         
951         return match_;
952     }
953 
954     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
955         bool checkok;
956         
957         
958         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
959         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
960         bytes memory keyhash = new bytes(32);
961         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
962         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
963         if (checkok == false) return false;
964         
965         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
966         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
967         
968         
969         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
970         checkok = matchBytes32Prefix(sha256(sig1), result);
971         if (checkok == false) return false;
972         
973         
974         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
975         // This is to verify that the computed args match with the ones specified in the query.
976         bytes memory commitmentSlice1 = new bytes(8+1+32);
977         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
978         
979         bytes memory sessionPubkey = new bytes(64);
980         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
981         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
982         
983         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
984         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
985             delete oraclize_randomDS_args[queryId];
986         } else return false;
987         
988         
989         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
990         bytes memory tosign1 = new bytes(32+8+1+32);
991         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
992         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
993         if (checkok == false) return false;
994         
995         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
996         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
997             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
998         }
999         
1000         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1001     }
1002 
1003     
1004     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1005     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1006         uint minLength = length + toOffset;
1007 
1008         if (to.length < minLength) {
1009             // Buffer too small
1010             throw; // Should be a better way?
1011         }
1012 
1013         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1014         uint i = 32 + fromOffset;
1015         uint j = 32 + toOffset;
1016 
1017         while (i < (32 + fromOffset + length)) {
1018             assembly {
1019                 let tmp := mload(add(from, i))
1020                 mstore(add(to, j), tmp)
1021             }
1022             i += 32;
1023             j += 32;
1024         }
1025 
1026         return to;
1027     }
1028     
1029     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1030     // Duplicate Solidity's ecrecover, but catching the CALL return value
1031     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1032         // We do our own memory management here. Solidity uses memory offset
1033         // 0x40 to store the current end of memory. We write past it (as
1034         // writes are memory extensions), but don't update the offset so
1035         // Solidity will reuse it. The memory used here is only needed for
1036         // this context.
1037 
1038         // FIXME: inline assembly can't access return values
1039         bool ret;
1040         address addr;
1041 
1042         assembly {
1043             let size := mload(0x40)
1044             mstore(size, hash)
1045             mstore(add(size, 32), v)
1046             mstore(add(size, 64), r)
1047             mstore(add(size, 96), s)
1048 
1049             // NOTE: we can reuse the request memory because we deal with
1050             //       the return code
1051             ret := call(3000, 1, 0, size, 128, size, 32)
1052             addr := mload(size)
1053         }
1054   
1055         return (ret, addr);
1056     }
1057 
1058     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1059     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1060         bytes32 r;
1061         bytes32 s;
1062         uint8 v;
1063 
1064         if (sig.length != 65)
1065           return (false, 0);
1066 
1067         // The signature format is a compact form of:
1068         //   {bytes32 r}{bytes32 s}{uint8 v}
1069         // Compact means, uint8 is not padded to 32 bytes.
1070         assembly {
1071             r := mload(add(sig, 32))
1072             s := mload(add(sig, 64))
1073 
1074             // Here we are loading the last 32 bytes. We exploit the fact that
1075             // 'mload' will pad with zeroes if we overread.
1076             // There is no 'mload8' to do this, but that would be nicer.
1077             v := byte(0, mload(add(sig, 96)))
1078 
1079             // Alternative solution:
1080             // 'byte' is not working due to the Solidity parser, so lets
1081             // use the second best option, 'and'
1082             // v := and(mload(add(sig, 65)), 255)
1083         }
1084 
1085         // albeit non-transactional signatures are not specified by the YP, one would expect it
1086         // to match the YP range of [27, 28]
1087         //
1088         // geth uses [0, 1] and some clients have followed. This might change, see:
1089         //  https://github.com/ethereum/go-ethereum/issues/2053
1090         if (v < 27)
1091           v += 27;
1092 
1093         if (v != 27 && v != 28)
1094             return (false, 0);
1095 
1096         return safer_ecrecover(hash, v, r, s);
1097     }
1098         
1099 }
1100 // </ORACLIZE_API>
1101 
1102 /*
1103 oraclize update at 10 am
1104 
1105 Phase 1 PreICO  1 token = $ 0.11 (pre-ICO price: has to be updated)
1106 Phase 2 PreICO  1 token = $ 0.16 (pre-ICO price: has to be updated)
1107 ICO 1 token = $ 0.21 (ICO price: has to be updated)
1108 
1109 */
1110 
1111 //Abstract Token contract
1112 contract TokenContract{
1113   function transfer(address,uint256) public;
1114   function balanceOf(address) public returns(uint);
1115   function setCrowdsaleContract(address _address) public;
1116 }
1117 
1118 //Crowdsale contract
1119 contract BitChordCrowdsale is Ownable, usingOraclize{
1120 
1121   using SafeMath for uint;
1122 
1123   uint decimals = 18;
1124 
1125   // Token contract address
1126   TokenContract public token;
1127 
1128   address public distributionAddress;
1129   uint public startingExchangePrice = 1902877214779731;
1130 
1131   // Constructor
1132   function BitChordCrowdsale(address _tokenAddress, address _distribution) public payable {
1133     require (msg.value > 0);
1134     
1135     token = TokenContract(_tokenAddress);
1136     owner = msg.sender;
1137 
1138     distributionAddress = _distribution;
1139 
1140     oraclize_setNetwork(networkID_auto);
1141     oraclize = OraclizeI(OAR.getAddress());
1142 
1143     oraclizeBalance = msg.value;
1144 
1145     stage_1_price = startingExchangePrice*11/100;
1146     stage_2_price = startingExchangePrice*16/100;
1147     stage_3_price = startingExchangePrice*21/100;
1148 
1149     uint tenAM = 1521799200; // Put the erliest 10AM timestamp
1150 
1151     token.setCrowdsaleContract(address(this));
1152 
1153     
1154     updateFlag = true;
1155     oraclize_query((findTenAmUtc(tenAM)),"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1156   }
1157 
1158   uint public constant STAGE_1_START = 1523404860; //1523404860 
1159   uint public constant STAGE_1_FINISH = 1525132740;//1525132740;
1160 
1161   uint public stage_1_price;
1162   uint public constant STAGE_1_MAXCAP = 3100000 ether; 
1163 
1164   uint public constant STAGE_2_START = 1525132860;//1525132860; 
1165   uint public constant STAGE_2_FINISH = 1526687940;//1526687940; 
1166 
1167   uint public stage_2_price;
1168   uint public stage_2_maxcap = 9000000 ether;
1169 
1170 
1171   uint public constant STAGE_3_START = 1526688060; //1526688060; 
1172   uint public constant STAGE_3_FINISH = 1535414340;
1173 
1174   uint public stage_3_price;
1175   uint public constant STAGE_3_MAXCAP = 67100000 ether;
1176 
1177 
1178   uint public constant MIN_IVESTMENT = 0.1 ether;
1179 
1180   uint public ethCollected = 0;
1181   uint public stage_1_TokensSold = 0;
1182   uint public stage_2_TokensSold = 0;
1183   uint public stage_3_TokensSold = 0;
1184 
1185   function getPhase(uint _time) public view returns(uint8) {
1186     if(_time == 0){
1187       _time = now;
1188     }
1189     if (STAGE_1_START <= _time && _time < STAGE_1_FINISH){
1190       return 1;
1191     }
1192     if (STAGE_2_START <= _time && _time < STAGE_2_FINISH){
1193       return 2;
1194     }
1195     if (STAGE_3_START <= _time && _time < STAGE_3_FINISH){
1196       return 3;
1197     }
1198     return 0;
1199   }
1200 
1201   function () public payable {
1202     require (buy(msg.sender, msg.value, now));
1203     require (msg.value >= MIN_IVESTMENT);
1204   }
1205 
1206   bool phase2Flag = false;
1207 
1208   event OnSuccessfullyBought(address indexed to, uint indexed ethValue, bool indexed manual, uint tokens);
1209 
1210   function buy (address _address, uint _value, uint _time) internal returns(bool)  {
1211     uint8 currentPhase = getPhase(_time);
1212 
1213 
1214     if (currentPhase == 1){
1215       uint tokensToSend = _value.mul((uint)(10).pow(decimals))/(stage_1_price);
1216       if(stage_1_TokensSold.add(tokensToSend) <= STAGE_1_MAXCAP){
1217         ethCollected = ethCollected.add(_value);
1218         token.transfer(_address,tokensToSend);
1219         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1220 
1221         emit OnSuccessfullyBought(_address,_value,false,tokensToSend);
1222 
1223         stage_1_TokensSold = stage_1_TokensSold.add(tokensToSend);
1224 
1225         return true;
1226       }else{
1227         if(stage_1_TokensSold == STAGE_1_MAXCAP){
1228           return false;
1229         }
1230 
1231         uint availableTokens = STAGE_1_MAXCAP.sub(stage_1_TokensSold);
1232         uint ethRequire = availableTokens.mul(stage_1_price)/(uint(10).pow(decimals));
1233         token.transfer(_address,availableTokens);
1234         msg.sender.transfer(_value.sub(ethRequire));
1235         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1236 
1237         emit OnSuccessfullyBought(_address,ethRequire,false,availableTokens);
1238 
1239         ethCollected = ethCollected.add(ethRequire);
1240         stage_1_TokensSold = STAGE_1_MAXCAP;
1241 
1242         return true;
1243       }
1244     }
1245 
1246     if(currentPhase == 2){
1247       if(!phase2Flag){
1248         stage_2_maxcap = stage_2_maxcap.add(STAGE_1_MAXCAP.sub(stage_1_TokensSold));
1249         phase2Flag = true;
1250       }
1251 
1252       tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_2_price;
1253       if(stage_2_TokensSold.add(tokensToSend) <= stage_2_maxcap){
1254         ethCollected = ethCollected.add(_value);
1255         token.transfer(_address,tokensToSend);
1256         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1257 
1258         emit OnSuccessfullyBought(_address,_value,false,tokensToSend);
1259 
1260         stage_2_TokensSold = stage_2_TokensSold.add(tokensToSend);
1261 
1262         return true;
1263       }else{
1264         if(stage_2_TokensSold == stage_2_maxcap){
1265           return false;
1266         }
1267         availableTokens = stage_2_maxcap.sub(stage_2_TokensSold);
1268         ethRequire = availableTokens.mul(stage_2_price)/(uint(10).pow(decimals));
1269         token.transfer(_address,availableTokens);
1270         msg.sender.transfer(_value.sub(ethRequire));
1271         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1272 
1273         emit OnSuccessfullyBought(_address,ethRequire,false,availableTokens);
1274 
1275         ethCollected = ethCollected.add(ethRequire);
1276         stage_2_TokensSold = stage_2_maxcap;
1277 
1278         return true;
1279       }
1280     }
1281     if(currentPhase == 3){
1282       tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_3_price;
1283 
1284       if(stage_3_TokensSold.add(tokensToSend) <= STAGE_3_MAXCAP){
1285         ethCollected = ethCollected.add(_value);
1286         token.transfer(_address,tokensToSend);
1287         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1288 
1289         emit OnSuccessfullyBought(_address,_value,false,availableTokens);
1290 
1291         stage_3_TokensSold = stage_3_TokensSold.add(tokensToSend);
1292 
1293         return true;
1294       }else{
1295         if(stage_3_TokensSold == STAGE_3_MAXCAP){
1296           return false;
1297         }
1298 
1299         availableTokens = STAGE_3_MAXCAP.sub(stage_3_TokensSold);
1300         ethRequire = availableTokens.mul(stage_3_price)/(uint(10).pow(decimals));
1301         token.transfer(_address,availableTokens);
1302         msg.sender.transfer(_value.sub(ethRequire));
1303         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1304 
1305         emit OnSuccessfullyBought(_address,ethRequire,false,availableTokens);
1306 
1307         ethCollected = ethCollected.add(ethRequire);
1308         stage_3_TokensSold = STAGE_3_MAXCAP;
1309 
1310         return true;
1311       }
1312     }
1313 
1314     return false;
1315   }
1316 
1317   function tokenCalculate (uint _value, uint _time) public view returns(uint)  {
1318     // uint bonusPercent;
1319     uint8 currentPhase = getPhase(_time);
1320 
1321     if (currentPhase == 1){
1322       return _value.mul((uint)(10).pow(decimals))/stage_1_price;
1323     }
1324     if(currentPhase == 2){
1325       return _value.mul((uint)(10).pow(decimals))/stage_2_price;
1326     }
1327     if(currentPhase == 3){
1328       uint tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_3_price;
1329       return tokensToSend;
1330     }
1331     return 0;
1332   }
1333 
1334   function sendTokensManually (address _address, uint _value) public{
1335     require (msg.sender == owner || msg.sender == techSupport);
1336 
1337     uint8 currentPhase = getPhase(0);
1338 
1339     if(currentPhase == 1){
1340         require(stage_1_TokensSold.add(_value) <= STAGE_1_MAXCAP);
1341         stage_1_TokensSold += _value;
1342     }
1343     if(currentPhase == 2){
1344         require(stage_2_TokensSold.add(_value) <= stage_2_maxcap);
1345         stage_2_TokensSold += _value;
1346     }
1347     if(currentPhase == 3){
1348         require(stage_3_TokensSold.add(_value) <= STAGE_3_MAXCAP);
1349         stage_3_TokensSold += _value;
1350     }
1351 
1352     token.transfer(_address, _value);
1353     emit OnSuccessfullyBought(_address,0,true,_value);
1354   }
1355 
1356   function requestRemainingTokens () public onlyOwner {
1357     // require (now > STAGE_3_FINISH);
1358     token.transfer(owner,token.balanceOf(address(this)));
1359   }
1360 
1361   // ORACLIZE functions
1362 
1363   uint public oraclizeBalance = 0;
1364   bool public updateFlag = false;
1365   uint public priceUpdateAt;
1366 
1367   function findTenAmUtc (uint ten) public view returns (uint) {
1368     for (uint i = 0; i < 300; i++){
1369       if(ten > now){
1370         return ten.sub(now);
1371       }
1372       ten = ten + 1 days;
1373     }
1374     return 0;
1375   }
1376 
1377   function update() internal {
1378     oraclize_query(86400,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1379     //86400 - 1 day
1380   
1381     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL")); //request to oraclize
1382   }
1383 
1384   function startOraclize (uint _time) public onlyOwner {
1385     require (_time != 0);
1386     require (!updateFlag);
1387     
1388     updateFlag = true;
1389     oraclize_query(_time,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1390     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL"));
1391   }
1392 
1393   function addEtherForOraclize () public payable {
1394     oraclizeBalance = oraclizeBalance.add(msg.value);
1395   }
1396 
1397   function requestOraclizeBalance () public onlyOwner {
1398     updateFlag = false;
1399     if (address(this).balance >= oraclizeBalance){
1400       owner.transfer(oraclizeBalance);
1401     }else{
1402       owner.transfer(address(this).balance);
1403     }
1404     oraclizeBalance = 0;
1405   }
1406   
1407   function stopOraclize () public onlyOwner {
1408     updateFlag = false;
1409   }
1410     
1411   function __callback(bytes32, string result, bytes) public {
1412     require(msg.sender == oraclize_cbAddress());
1413 
1414     uint256 price = 10 ** 23 / parseInt(result, 5);
1415 
1416     require(price > 0);
1417     // currentExchangePrice = price;
1418     stage_1_price = price*11/100;
1419     stage_2_price = price*16/100;
1420     stage_3_price = price*21/100;
1421 
1422     priceUpdateAt = block.timestamp;
1423 
1424     if(updateFlag){
1425       update();
1426     }
1427   }
1428   
1429   //end ORACLIZE functions
1430 }