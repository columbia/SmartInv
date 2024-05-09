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
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   function transferOwnership(address _newOwner) public onlyOwner {
52     require(_newOwner != address(0));
53     newOwner = _newOwner;
54   }
55 
56   function acceptOwnership() public {
57     if (msg.sender == newOwner) {
58       owner = newOwner;
59     }
60   }
61 }
62 
63 
64 
65 // <ORACLIZE_API>
66 /*
67 Copyright (c) 2015-2016 Oraclize SRL
68 Copyright (c) 2016 Oraclize LTD
69 
70 
71 
72 Permission is hereby granted, free of charge, to any person obtaining a copy
73 of this software and associated documentation files (the "Software"), to deal
74 in the Software without restriction, including without limitation the rights
75 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
76 copies of the Software, and to permit persons to whom the Software is
77 furnished to do so, subject to the following conditions:
78 
79 
80 
81 The above copyright notice and this permission notice shall be included in
82 all copies or substantial portions of the Software.
83 
84 
85 
86 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
87 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
88 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
89 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
90 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
91 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
92 THE SOFTWARE.
93 */
94 
95 contract OraclizeI {
96     address public cbAddress;
97     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
98     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
99     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
100     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
101     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
102     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
103     function getPrice(string _datasource) returns (uint _dsprice);
104     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
105     function useCoupon(string _coupon);
106     function setProofType(byte _proofType);
107     function setConfig(bytes32 _config);
108     function setCustomGasPrice(uint _gasPrice);
109     function randomDS_getSessionPubKeyHash() returns(bytes32);
110 }
111 contract OraclizeAddrResolverI {
112     function getAddress() returns (address _addr);
113 }
114 contract usingOraclize {
115     uint constant day = 60*60*24;
116     uint constant week = 60*60*24*7;
117     uint constant month = 60*60*24*30;
118     byte constant proofType_NONE = 0x00;
119     byte constant proofType_TLSNotary = 0x10;
120     byte constant proofType_Android = 0x20;
121     byte constant proofType_Ledger = 0x30;
122     byte constant proofType_Native = 0xF0;
123     byte constant proofStorage_IPFS = 0x01;
124     uint8 constant networkID_auto = 0;
125     uint8 constant networkID_mainnet = 1;
126     uint8 constant networkID_testnet = 2;
127     uint8 constant networkID_morden = 2;
128     uint8 constant networkID_consensys = 161;
129 
130     OraclizeAddrResolverI OAR;
131 
132     OraclizeI oraclize;
133     modifier oraclizeAPI {
134         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
135         oraclize = OraclizeI(OAR.getAddress());
136         _;
137     }
138     modifier coupon(string code){
139         oraclize = OraclizeI(OAR.getAddress());
140         oraclize.useCoupon(code);
141         _;
142     }
143 
144     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
145         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
146             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
147             oraclize_setNetworkName("eth_mainnet");
148             return true;
149         }
150         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
151             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
152             oraclize_setNetworkName("eth_ropsten3");
153             return true;
154         }
155         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
156             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
157             oraclize_setNetworkName("eth_kovan");
158             return true;
159         }
160         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
161             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
162             oraclize_setNetworkName("eth_rinkeby");
163             return true;
164         }
165         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
166             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
167             return true;
168         }
169         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
170             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
171             return true;
172         }
173         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
174             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
175             return true;
176         }
177         return false;
178     }
179 
180     function __callback(bytes32 myid, string result) {
181         __callback(myid, result, new bytes(0));
182     }
183     function __callback(bytes32 myid, string result, bytes proof) {
184     }
185     
186     function oraclize_useCoupon(string code) oraclizeAPI internal {
187         oraclize.useCoupon(code);
188     }
189 
190     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
191         return oraclize.getPrice(datasource);
192     }
193 
194     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
195         return oraclize.getPrice(datasource, gaslimit);
196     }
197     
198     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
199         uint price = oraclize.getPrice(datasource);
200         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
201         return oraclize.query.value(price)(0, datasource, arg);
202     }
203     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
204         uint price = oraclize.getPrice(datasource);
205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
206         return oraclize.query.value(price)(timestamp, datasource, arg);
207     }
208     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource, gaslimit);
210         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
211         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
212     }
213     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
214         uint price = oraclize.getPrice(datasource, gaslimit);
215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
216         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
217     }
218     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
219         uint price = oraclize.getPrice(datasource);
220         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
221         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
222     }
223     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
224         uint price = oraclize.getPrice(datasource);
225         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
226         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
227     }
228     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
229         uint price = oraclize.getPrice(datasource, gaslimit);
230         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
231         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
232     }
233     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
234         uint price = oraclize.getPrice(datasource, gaslimit);
235         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
236         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
237     }
238     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
239         uint price = oraclize.getPrice(datasource);
240         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
241         bytes memory args = stra2cbor(argN);
242         return oraclize.queryN.value(price)(0, datasource, args);
243     }
244     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
245         uint price = oraclize.getPrice(datasource);
246         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
247         bytes memory args = stra2cbor(argN);
248         return oraclize.queryN.value(price)(timestamp, datasource, args);
249     }
250     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
251         uint price = oraclize.getPrice(datasource, gaslimit);
252         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
253         bytes memory args = stra2cbor(argN);
254         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
255     }
256     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
257         uint price = oraclize.getPrice(datasource, gaslimit);
258         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
259         bytes memory args = stra2cbor(argN);
260         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
261     }
262     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](1);
264         dynargs[0] = args[0];
265         return oraclize_query(datasource, dynargs);
266     }
267     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](1);
269         dynargs[0] = args[0];
270         return oraclize_query(timestamp, datasource, dynargs);
271     }
272     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
273         string[] memory dynargs = new string[](1);
274         dynargs[0] = args[0];
275         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
276     }
277     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](1);
279         dynargs[0] = args[0];       
280         return oraclize_query(datasource, dynargs, gaslimit);
281     }
282     
283     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](2);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         return oraclize_query(datasource, dynargs);
288     }
289     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
290         string[] memory dynargs = new string[](2);
291         dynargs[0] = args[0];
292         dynargs[1] = args[1];
293         return oraclize_query(timestamp, datasource, dynargs);
294     }
295     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](2);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
300     }
301     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
302         string[] memory dynargs = new string[](2);
303         dynargs[0] = args[0];
304         dynargs[1] = args[1];
305         return oraclize_query(datasource, dynargs, gaslimit);
306     }
307     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
308         string[] memory dynargs = new string[](3);
309         dynargs[0] = args[0];
310         dynargs[1] = args[1];
311         dynargs[2] = args[2];
312         return oraclize_query(datasource, dynargs);
313     }
314     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
315         string[] memory dynargs = new string[](3);
316         dynargs[0] = args[0];
317         dynargs[1] = args[1];
318         dynargs[2] = args[2];
319         return oraclize_query(timestamp, datasource, dynargs);
320     }
321     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](3);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
327     }
328     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
329         string[] memory dynargs = new string[](3);
330         dynargs[0] = args[0];
331         dynargs[1] = args[1];
332         dynargs[2] = args[2];
333         return oraclize_query(datasource, dynargs, gaslimit);
334     }
335     
336     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
337         string[] memory dynargs = new string[](4);
338         dynargs[0] = args[0];
339         dynargs[1] = args[1];
340         dynargs[2] = args[2];
341         dynargs[3] = args[3];
342         return oraclize_query(datasource, dynargs);
343     }
344     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
345         string[] memory dynargs = new string[](4);
346         dynargs[0] = args[0];
347         dynargs[1] = args[1];
348         dynargs[2] = args[2];
349         dynargs[3] = args[3];
350         return oraclize_query(timestamp, datasource, dynargs);
351     }
352     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
353         string[] memory dynargs = new string[](4);
354         dynargs[0] = args[0];
355         dynargs[1] = args[1];
356         dynargs[2] = args[2];
357         dynargs[3] = args[3];
358         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
359     }
360     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
361         string[] memory dynargs = new string[](4);
362         dynargs[0] = args[0];
363         dynargs[1] = args[1];
364         dynargs[2] = args[2];
365         dynargs[3] = args[3];
366         return oraclize_query(datasource, dynargs, gaslimit);
367     }
368     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
369         string[] memory dynargs = new string[](5);
370         dynargs[0] = args[0];
371         dynargs[1] = args[1];
372         dynargs[2] = args[2];
373         dynargs[3] = args[3];
374         dynargs[4] = args[4];
375         return oraclize_query(datasource, dynargs);
376     }
377     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
378         string[] memory dynargs = new string[](5);
379         dynargs[0] = args[0];
380         dynargs[1] = args[1];
381         dynargs[2] = args[2];
382         dynargs[3] = args[3];
383         dynargs[4] = args[4];
384         return oraclize_query(timestamp, datasource, dynargs);
385     }
386     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         string[] memory dynargs = new string[](5);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         dynargs[2] = args[2];
391         dynargs[3] = args[3];
392         dynargs[4] = args[4];
393         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
394     }
395     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](5);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         dynargs[3] = args[3];
401         dynargs[4] = args[4];
402         return oraclize_query(datasource, dynargs, gaslimit);
403     }
404     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource);
406         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
407         bytes memory args = ba2cbor(argN);
408         return oraclize.queryN.value(price)(0, datasource, args);
409     }
410     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource);
412         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
413         bytes memory args = ba2cbor(argN);
414         return oraclize.queryN.value(price)(timestamp, datasource, args);
415     }
416     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource, gaslimit);
418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
419         bytes memory args = ba2cbor(argN);
420         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
421     }
422     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource, gaslimit);
424         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
425         bytes memory args = ba2cbor(argN);
426         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
427     }
428     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](1);
430         dynargs[0] = args[0];
431         return oraclize_query(datasource, dynargs);
432     }
433     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](1);
435         dynargs[0] = args[0];
436         return oraclize_query(timestamp, datasource, dynargs);
437     }
438     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
439         bytes[] memory dynargs = new bytes[](1);
440         dynargs[0] = args[0];
441         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
442     }
443     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](1);
445         dynargs[0] = args[0];       
446         return oraclize_query(datasource, dynargs, gaslimit);
447     }
448     
449     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](2);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
456         bytes[] memory dynargs = new bytes[](2);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
466     }
467     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         bytes[] memory dynargs = new bytes[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](3);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         return oraclize_query(timestamp, datasource, dynargs);
486     }
487     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](3);
489         dynargs[0] = args[0];
490         dynargs[1] = args[1];
491         dynargs[2] = args[2];
492         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         bytes[] memory dynargs = new bytes[](3);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         return oraclize_query(datasource, dynargs, gaslimit);
500     }
501     
502     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
503         bytes[] memory dynargs = new bytes[](4);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         dynargs[3] = args[3];
508         return oraclize_query(datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
511         bytes[] memory dynargs = new bytes[](4);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         dynargs[3] = args[3];
516         return oraclize_query(timestamp, datasource, dynargs);
517     }
518     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
519         bytes[] memory dynargs = new bytes[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
525     }
526     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         bytes[] memory dynargs = new bytes[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
535         bytes[] memory dynargs = new bytes[](5);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         dynargs[4] = args[4];
541         return oraclize_query(datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
544         bytes[] memory dynargs = new bytes[](5);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         dynargs[4] = args[4];
550         return oraclize_query(timestamp, datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
553         bytes[] memory dynargs = new bytes[](5);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         dynargs[4] = args[4];
559         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
560     }
561     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](5);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         dynargs[4] = args[4];
568         return oraclize_query(datasource, dynargs, gaslimit);
569     }
570 
571     function oraclize_cbAddress() oraclizeAPI internal returns (address){
572         return oraclize.cbAddress();
573     }
574     function oraclize_setProof(byte proofP) oraclizeAPI internal {
575         return oraclize.setProofType(proofP);
576     }
577     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
578         return oraclize.setCustomGasPrice(gasPrice);
579     }
580     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
581         return oraclize.setConfig(config);
582     }
583     
584     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
585         return oraclize.randomDS_getSessionPubKeyHash();
586     }
587 
588     function getCodeSize(address _addr) constant internal returns(uint _size) {
589         assembly {
590             _size := extcodesize(_addr)
591         }
592     }
593 
594     function parseAddr(string _a) internal returns (address){
595         bytes memory tmp = bytes(_a);
596         uint160 iaddr = 0;
597         uint160 b1;
598         uint160 b2;
599         for (uint i=2; i<2+2*20; i+=2){
600             iaddr *= 256;
601             b1 = uint160(tmp[i]);
602             b2 = uint160(tmp[i+1]);
603             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
604             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
605             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
606             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
607             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
608             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
609             iaddr += (b1*16+b2);
610         }
611         return address(iaddr);
612     }
613 
614     function strCompare(string _a, string _b) internal returns (int) {
615         bytes memory a = bytes(_a);
616         bytes memory b = bytes(_b);
617         uint minLength = a.length;
618         if (b.length < minLength) minLength = b.length;
619         for (uint i = 0; i < minLength; i ++)
620             if (a[i] < b[i])
621                 return -1;
622             else if (a[i] > b[i])
623                 return 1;
624         if (a.length < b.length)
625             return -1;
626         else if (a.length > b.length)
627             return 1;
628         else
629             return 0;
630     }
631 
632     function indexOf(string _haystack, string _needle) internal returns (int) {
633         bytes memory h = bytes(_haystack);
634         bytes memory n = bytes(_needle);
635         if(h.length < 1 || n.length < 1 || (n.length > h.length))
636             return -1;
637         else if(h.length > (2**128 -1))
638             return -1;
639         else
640         {
641             uint subindex = 0;
642             for (uint i = 0; i < h.length; i ++)
643             {
644                 if (h[i] == n[0])
645                 {
646                     subindex = 1;
647                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
648                     {
649                         subindex++;
650                     }
651                     if(subindex == n.length)
652                         return int(i);
653                 }
654             }
655             return -1;
656         }
657     }
658 
659     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
660         bytes memory _ba = bytes(_a);
661         bytes memory _bb = bytes(_b);
662         bytes memory _bc = bytes(_c);
663         bytes memory _bd = bytes(_d);
664         bytes memory _be = bytes(_e);
665         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
666         bytes memory babcde = bytes(abcde);
667         uint k = 0;
668         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
669         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
670         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
671         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
672         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
673         return string(babcde);
674     }
675 
676     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
677         return strConcat(_a, _b, _c, _d, "");
678     }
679 
680     function strConcat(string _a, string _b, string _c) internal returns (string) {
681         return strConcat(_a, _b, _c, "", "");
682     }
683 
684     function strConcat(string _a, string _b) internal returns (string) {
685         return strConcat(_a, _b, "", "", "");
686     }
687 
688     // parseInt
689     function parseInt(string _a) internal returns (uint) {
690         return parseInt(_a, 0);
691     }
692 
693     // parseInt(parseFloat*10^_b)
694     function parseInt(string _a, uint _b) internal returns (uint) {
695         bytes memory bresult = bytes(_a);
696         uint mint = 0;
697         bool decimals = false;
698         for (uint i=0; i<bresult.length; i++){
699             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
700                 if (decimals){
701                    if (_b == 0) break;
702                     else _b--;
703                 }
704                 mint *= 10;
705                 mint += uint(bresult[i]) - 48;
706             } else if (bresult[i] == 46) decimals = true;
707         }
708         if (_b > 0) mint *= 10**_b;
709         return mint;
710     }
711 
712     function uint2str(uint i) internal returns (string){
713         if (i == 0) return "0";
714         uint j = i;
715         uint len;
716         while (j != 0){
717             len++;
718             j /= 10;
719         }
720         bytes memory bstr = new bytes(len);
721         uint k = len - 1;
722         while (i != 0){
723             bstr[k--] = byte(48 + i % 10);
724             i /= 10;
725         }
726         return string(bstr);
727     }
728     
729     function stra2cbor(string[] arr) internal returns (bytes) {
730             uint arrlen = arr.length;
731 
732             // get correct cbor output length
733             uint outputlen = 0;
734             bytes[] memory elemArray = new bytes[](arrlen);
735             for (uint i = 0; i < arrlen; i++) {
736                 elemArray[i] = (bytes(arr[i]));
737                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
738             }
739             uint ctr = 0;
740             uint cborlen = arrlen + 0x80;
741             outputlen += byte(cborlen).length;
742             bytes memory res = new bytes(outputlen);
743 
744             while (byte(cborlen).length > ctr) {
745                 res[ctr] = byte(cborlen)[ctr];
746                 ctr++;
747             }
748             for (i = 0; i < arrlen; i++) {
749                 res[ctr] = 0x5F;
750                 ctr++;
751                 for (uint x = 0; x < elemArray[i].length; x++) {
752                     // if there's a bug with larger strings, this may be the culprit
753                     if (x % 23 == 0) {
754                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
755                         elemcborlen += 0x40;
756                         uint lctr = ctr;
757                         while (byte(elemcborlen).length > ctr - lctr) {
758                             res[ctr] = byte(elemcborlen)[ctr - lctr];
759                             ctr++;
760                         }
761                     }
762                     res[ctr] = elemArray[i][x];
763                     ctr++;
764                 }
765                 res[ctr] = 0xFF;
766                 ctr++;
767             }
768             return res;
769         }
770 
771     function ba2cbor(bytes[] arr) internal returns (bytes) {
772             uint arrlen = arr.length;
773 
774             // get correct cbor output length
775             uint outputlen = 0;
776             bytes[] memory elemArray = new bytes[](arrlen);
777             for (uint i = 0; i < arrlen; i++) {
778                 elemArray[i] = (bytes(arr[i]));
779                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
780             }
781             uint ctr = 0;
782             uint cborlen = arrlen + 0x80;
783             outputlen += byte(cborlen).length;
784             bytes memory res = new bytes(outputlen);
785 
786             while (byte(cborlen).length > ctr) {
787                 res[ctr] = byte(cborlen)[ctr];
788                 ctr++;
789             }
790             for (i = 0; i < arrlen; i++) {
791                 res[ctr] = 0x5F;
792                 ctr++;
793                 for (uint x = 0; x < elemArray[i].length; x++) {
794                     // if there's a bug with larger strings, this may be the culprit
795                     if (x % 23 == 0) {
796                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
797                         elemcborlen += 0x40;
798                         uint lctr = ctr;
799                         while (byte(elemcborlen).length > ctr - lctr) {
800                             res[ctr] = byte(elemcborlen)[ctr - lctr];
801                             ctr++;
802                         }
803                     }
804                     res[ctr] = elemArray[i][x];
805                     ctr++;
806                 }
807                 res[ctr] = 0xFF;
808                 ctr++;
809             }
810             return res;
811         }
812         
813         
814     string oraclize_network_name;
815     function oraclize_setNetworkName(string _network_name) internal {
816         oraclize_network_name = _network_name;
817     }
818     
819     function oraclize_getNetworkName() internal returns (string) {
820         return oraclize_network_name;
821     }
822     
823     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
824         if ((_nbytes == 0)||(_nbytes > 32)) throw;
825         bytes memory nbytes = new bytes(1);
826         nbytes[0] = byte(_nbytes);
827         bytes memory unonce = new bytes(32);
828         bytes memory sessionKeyHash = new bytes(32);
829         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
830         assembly {
831             mstore(unonce, 0x20)
832             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
833             mstore(sessionKeyHash, 0x20)
834             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
835         }
836         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
837         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
838         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
839         return queryId;
840     }
841     
842     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
843         oraclize_randomDS_args[queryId] = commitment;
844     }
845     
846     mapping(bytes32=>bytes32) oraclize_randomDS_args;
847     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
848 
849     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
850         bool sigok;
851         address signer;
852         
853         bytes32 sigr;
854         bytes32 sigs;
855         
856         bytes memory sigr_ = new bytes(32);
857         uint offset = 4+(uint(dersig[3]) - 0x20);
858         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
859         bytes memory sigs_ = new bytes(32);
860         offset += 32 + 2;
861         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
862 
863         assembly {
864             sigr := mload(add(sigr_, 32))
865             sigs := mload(add(sigs_, 32))
866         }
867         
868         
869         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
870         if (address(sha3(pubkey)) == signer) return true;
871         else {
872             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
873             return (address(sha3(pubkey)) == signer);
874         }
875     }
876 
877     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
878         bool sigok;
879         
880         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
881         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
882         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
883         
884         bytes memory appkey1_pubkey = new bytes(64);
885         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
886         
887         bytes memory tosign2 = new bytes(1+65+32);
888         tosign2[0] = 1; //role
889         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
890         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
891         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
892         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
893         
894         if (sigok == false) return false;
895         
896         
897         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
898         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
899         
900         bytes memory tosign3 = new bytes(1+65);
901         tosign3[0] = 0xFE;
902         copyBytes(proof, 3, 65, tosign3, 1);
903         
904         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
905         copyBytes(proof, 3+65, sig3.length, sig3, 0);
906         
907         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
908         
909         return sigok;
910     }
911     
912     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
913         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
914         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
915         
916         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
917         if (proofVerified == false) throw;
918         
919         _;
920     }
921     
922     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
923         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
924         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
925         
926         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
927         if (proofVerified == false) return 2;
928         
929         return 0;
930     }
931     
932     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
933         bool match_ = true;
934         
935         for (var i=0; i<prefix.length; i++){
936             if (content[i] != prefix[i]) match_ = false;
937         }
938         
939         return match_;
940     }
941 
942     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
943         bool checkok;
944         
945         
946         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
947         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
948         bytes memory keyhash = new bytes(32);
949         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
950         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
951         if (checkok == false) return false;
952         
953         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
954         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
955         
956         
957         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
958         checkok = matchBytes32Prefix(sha256(sig1), result);
959         if (checkok == false) return false;
960         
961         
962         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
963         // This is to verify that the computed args match with the ones specified in the query.
964         bytes memory commitmentSlice1 = new bytes(8+1+32);
965         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
966         
967         bytes memory sessionPubkey = new bytes(64);
968         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
969         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
970         
971         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
972         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
973             delete oraclize_randomDS_args[queryId];
974         } else return false;
975         
976         
977         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
978         bytes memory tosign1 = new bytes(32+8+1+32);
979         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
980         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
981         if (checkok == false) return false;
982         
983         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
984         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
985             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
986         }
987         
988         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
989     }
990 
991     
992     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
993     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
994         uint minLength = length + toOffset;
995 
996         if (to.length < minLength) {
997             // Buffer too small
998             throw; // Should be a better way?
999         }
1000 
1001         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1002         uint i = 32 + fromOffset;
1003         uint j = 32 + toOffset;
1004 
1005         while (i < (32 + fromOffset + length)) {
1006             assembly {
1007                 let tmp := mload(add(from, i))
1008                 mstore(add(to, j), tmp)
1009             }
1010             i += 32;
1011             j += 32;
1012         }
1013 
1014         return to;
1015     }
1016     
1017     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1018     // Duplicate Solidity's ecrecover, but catching the CALL return value
1019     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1020         // We do our own memory management here. Solidity uses memory offset
1021         // 0x40 to store the current end of memory. We write past it (as
1022         // writes are memory extensions), but don't update the offset so
1023         // Solidity will reuse it. The memory used here is only needed for
1024         // this context.
1025 
1026         // FIXME: inline assembly can't access return values
1027         bool ret;
1028         address addr;
1029 
1030         assembly {
1031             let size := mload(0x40)
1032             mstore(size, hash)
1033             mstore(add(size, 32), v)
1034             mstore(add(size, 64), r)
1035             mstore(add(size, 96), s)
1036 
1037             // NOTE: we can reuse the request memory because we deal with
1038             //       the return code
1039             ret := call(3000, 1, 0, size, 128, size, 32)
1040             addr := mload(size)
1041         }
1042   
1043         return (ret, addr);
1044     }
1045 
1046     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1047     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1048         bytes32 r;
1049         bytes32 s;
1050         uint8 v;
1051 
1052         if (sig.length != 65)
1053           return (false, 0);
1054 
1055         // The signature format is a compact form of:
1056         //   {bytes32 r}{bytes32 s}{uint8 v}
1057         // Compact means, uint8 is not padded to 32 bytes.
1058         assembly {
1059             r := mload(add(sig, 32))
1060             s := mload(add(sig, 64))
1061 
1062             // Here we are loading the last 32 bytes. We exploit the fact that
1063             // 'mload' will pad with zeroes if we overread.
1064             // There is no 'mload8' to do this, but that would be nicer.
1065             v := byte(0, mload(add(sig, 96)))
1066 
1067             // Alternative solution:
1068             // 'byte' is not working due to the Solidity parser, so lets
1069             // use the second best option, 'and'
1070             // v := and(mload(add(sig, 65)), 255)
1071         }
1072 
1073         // albeit non-transactional signatures are not specified by the YP, one would expect it
1074         // to match the YP range of [27, 28]
1075         //
1076         // geth uses [0, 1] and some clients have followed. This might change, see:
1077         //  https://github.com/ethereum/go-ethereum/issues/2053
1078         if (v < 27)
1079           v += 27;
1080 
1081         if (v != 27 && v != 28)
1082             return (false, 0);
1083 
1084         return safer_ecrecover(hash, v, r, s);
1085     }
1086         
1087 }
1088 // </ORACLIZE_API>
1089 
1090 /*
1091 oraclize update at 10 am
1092 
1093 Phase 1 PreICO  1 token = $ 0.11 (pre-ICO price: has to be updated)
1094 Phase 2 PreICO  1 token = $ 0.16 (pre-ICO price: has to be updated)
1095 ICO 1 token = $ 0.21 (ICO price: has to be updated)
1096 
1097 */
1098 
1099 //Abstract Token contract
1100 contract TokenContract{
1101   function transfer(address,uint256) public;
1102   function balanceOf(address) public returns(uint);    
1103 }
1104 
1105 //Crowdsale contract
1106 contract BitChordCrowdsale is Ownable, usingOraclize{
1107 
1108   using SafeMath for uint;
1109 
1110   uint decimals = 18;
1111 
1112   // Token contract address
1113   TokenContract public token;
1114 
1115   address public distributionAddress;
1116   uint public startingExchangePrice = 1902877214779731;
1117 
1118   // Constructor
1119   function BitChordCrowdsale(address _tokenAddress) public payable {
1120     token = TokenContract(_tokenAddress);
1121     owner = 0xAA38F23430DFAE7243af13d73C9DdC9C92B46Ec6;
1122 
1123     distributionAddress = 0x6978E2EA6021704Ac814E9EA97FB207BC6237C59;
1124 
1125     oraclize_setNetwork(networkID_auto);
1126     oraclize = OraclizeI(OAR.getAddress());
1127 
1128     oraclizeBalance = msg.value;
1129 
1130     stage_1_price = startingExchangePrice*11/100;
1131     stage_2_price = startingExchangePrice*16/100;
1132     stage_3_price = startingExchangePrice*21/100;
1133 
1134     uint tenAM = 1521799200; // Put the erliest 10AM timestamp
1135     
1136     updateFlag = true;
1137     oraclize_query((findTenAmUtc(tenAM)),"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1138   }
1139 
1140   uint public constant STAGE_1_START = 1523404860; //1523404860 
1141   uint public constant STAGE_1_FINISH = 1525132740;
1142 
1143   uint public stage_1_price;
1144   uint public constant STAGE_1_MAXCAP = 3100000 ether; 
1145 
1146   uint public constant STAGE_2_START = 1525132860; 
1147   uint public constant STAGE_2_FINISH = 1526687940; 
1148 
1149   uint public stage_2_price;
1150   uint public stage_2_maxcap = 9000000 ether;
1151 
1152 
1153   uint public constant STAGE_3_START = 1526688060; 
1154   uint public constant STAGE_3_FINISH = 1535414340;
1155 
1156   uint public stage_3_price;
1157   uint public constant STAGE_3_MAXCAP = 67100000 ether;
1158 
1159 
1160   uint public constant MIN_IVESTMENT = 0.1 ether;
1161 
1162   uint public ethCollected = 0;
1163   uint public stage_1_TokensSold = 0;
1164   uint public stage_2_TokensSold = 0;
1165   uint public stage_3_TokensSold = 0;
1166 
1167   function getPhase(uint _time) public view returns(uint8) {
1168     if(_time == 0){
1169       _time = now;
1170     }
1171     if (STAGE_1_START <= _time && _time < STAGE_1_FINISH){
1172       return 1;
1173     }
1174     if (STAGE_2_START <= _time && _time < STAGE_2_FINISH){
1175       return 2;
1176     }
1177     if (STAGE_3_START <= _time && _time < STAGE_3_FINISH){
1178       return 3;
1179     }
1180     return 0;
1181   }
1182 
1183   function getTimeBasedBonus (uint _time) public view returns(uint) {
1184     if (_time == 0){
1185       _time = now;
1186     }
1187     if (getPhase(_time) != 3){
1188       return 0;
1189     }
1190     if (STAGE_3_START + 20 days >= _time){
1191       return 10;
1192     }
1193     if (STAGE_3_START + 38 days >= _time){
1194       return 5;
1195     }
1196     return 0;
1197   }
1198 
1199   function () public payable {
1200     require (buy(msg.sender, msg.value, now));
1201     require (msg.value >= MIN_IVESTMENT);
1202   }
1203 
1204   bool phase2Flag = false;
1205 
1206   function buy (address _address, uint _value, uint _time) internal returns(bool)  {
1207     uint8 currentPhase = getPhase(_time);
1208 
1209 
1210     if (currentPhase == 1){
1211       uint tokensToSend = _value.mul((uint)(10).pow(decimals))/(stage_1_price);
1212       if(stage_1_TokensSold.add(tokensToSend) <= STAGE_1_MAXCAP){
1213         ethCollected = ethCollected.add(_value);
1214         token.transfer(_address,tokensToSend);
1215         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1216 
1217         stage_1_TokensSold = stage_1_TokensSold.add(tokensToSend);
1218 
1219         return true;
1220       }else{
1221         if(stage_1_TokensSold == STAGE_1_MAXCAP){
1222           return false;
1223         }
1224 
1225         uint availableTokens = STAGE_1_MAXCAP.sub(stage_1_TokensSold);
1226         uint ethRequire = availableTokens.mul(stage_1_price)/(uint(10).pow(decimals));
1227         token.transfer(_address,availableTokens);
1228         msg.sender.transfer(_value.sub(ethRequire));
1229         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1230 
1231         ethCollected = ethCollected.add(ethRequire);
1232         stage_1_TokensSold = STAGE_1_MAXCAP;
1233 
1234         return true;
1235       }
1236     }
1237 
1238     if(currentPhase == 2){
1239       if(!phase2Flag){
1240         stage_2_maxcap = stage_2_maxcap.add(STAGE_1_MAXCAP.sub(stage_1_TokensSold));
1241         phase2Flag = true;    
1242       }
1243 
1244       tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_2_price;
1245       if(stage_2_TokensSold.add(tokensToSend) <= stage_2_maxcap){
1246         ethCollected = ethCollected.add(_value);
1247         token.transfer(_address,tokensToSend);
1248         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1249 
1250         stage_2_TokensSold = stage_2_TokensSold.add(tokensToSend);
1251 
1252         return true;
1253       }else{
1254         if(stage_2_TokensSold == stage_2_maxcap){
1255           return false;
1256         }
1257         availableTokens = stage_2_maxcap.sub(stage_2_TokensSold);
1258         ethRequire = availableTokens.mul(stage_2_price)/(uint(10).pow(decimals));
1259         token.transfer(_address,availableTokens);
1260         msg.sender.transfer(_value.sub(ethRequire));
1261         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1262 
1263         ethCollected = ethCollected.add(ethRequire);
1264         stage_2_TokensSold = stage_2_maxcap;
1265 
1266         return true;
1267       }
1268     }
1269     if(currentPhase == 3){
1270       tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_3_price;
1271       uint bonusPercent = getTimeBasedBonus(_time);
1272       tokensToSend = tokensToSend.add(tokensToSend.mul(bonusPercent)/100);
1273 
1274       if(stage_3_TokensSold.add(tokensToSend) <= STAGE_3_MAXCAP){
1275         ethCollected = ethCollected.add(_value);
1276         token.transfer(_address,tokensToSend);
1277         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1278 
1279         stage_3_TokensSold = stage_3_TokensSold.add(tokensToSend);
1280 
1281         return true;
1282       }else{
1283         if(stage_3_TokensSold == STAGE_3_MAXCAP){
1284           return false;
1285         }
1286 
1287         availableTokens = STAGE_3_MAXCAP.sub(stage_3_TokensSold);
1288         ethRequire = availableTokens.mul(stage_3_price)/(uint(10).pow(decimals));
1289         token.transfer(_address,availableTokens);
1290         msg.sender.transfer(_value.sub(ethRequire));
1291         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1292 
1293         ethCollected = ethCollected.add(ethRequire);
1294         stage_3_TokensSold = STAGE_3_MAXCAP;
1295 
1296         return true;
1297       }
1298     }    
1299 
1300     return false;
1301   }
1302 
1303   function tokenCalculate (uint _value, uint _time) public view returns(uint)  {
1304     uint bonusPercent;
1305     uint8 currentPhase = getPhase(_time);
1306 
1307     if (currentPhase == 1){
1308       return _value.mul((uint)(10).pow(decimals))/stage_1_price;
1309     }
1310     if(currentPhase == 2){
1311       return _value.mul((uint)(10).pow(decimals))/stage_2_price;
1312     }
1313     if(currentPhase == 3){
1314       uint tokensToSend = _value.mul((uint)(10).pow(decimals))/stage_3_price;
1315       bonusPercent = getTimeBasedBonus(_time);
1316       return tokensToSend.add(tokensToSend.mul(bonusPercent)/100);
1317     }
1318     return 0;
1319   }
1320 
1321   function requestRemainingTokens () public onlyOwner {
1322     require (now > STAGE_3_FINISH);
1323     token.transfer(owner,token.balanceOf(address(this)));
1324   }
1325 
1326   // ORACLIZE functions
1327 
1328   uint public oraclizeBalance = 0;
1329   bool public updateFlag = false;
1330   uint public priceUpdateAt;
1331 
1332   function findTenAmUtc (uint ten) public view returns (uint) {
1333     for (uint i = 0; i < 300; i++){
1334       if(ten > now){
1335         return ten.sub(now);
1336       }
1337       ten = ten + 1 days;
1338     }
1339     return 0;
1340   }
1341 
1342   function update() internal {
1343     oraclize_query(86400,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1344     //86400 - 1 day
1345   
1346     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL")); //request to oraclize
1347   }
1348 
1349   function startOraclize (uint _time) public onlyOwner {
1350     require (_time != 0);
1351     require (!updateFlag);
1352 
1353     updateFlag = true;
1354     oraclize_query(_time,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1355     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL"));
1356   }
1357 
1358   function addEtherForOraclize () public payable {
1359     oraclizeBalance = oraclizeBalance.add(msg.value);
1360   }
1361 
1362   function requestOraclizeBalance () public onlyOwner {
1363     updateFlag = false;
1364     if (address(this).balance >= oraclizeBalance){
1365       owner.transfer(oraclizeBalance);
1366     }else{
1367       owner.transfer(address(this).balance);
1368     }
1369     oraclizeBalance = 0;
1370   }
1371 
1372   function stopOraclize () public onlyOwner {
1373     updateFlag = false;
1374   }
1375 
1376   function __callback(bytes32, string result, bytes) public {
1377     require(msg.sender == oraclize_cbAddress());
1378 
1379     uint256 price = 10 ** 23 / parseInt(result, 5);
1380 
1381     require(price > 0);
1382     // currentExchangePrice = price;
1383     stage_1_price = price*11/100;
1384     stage_2_price = price*16/100;
1385     stage_3_price = price*21/100;
1386 
1387     priceUpdateAt = block.timestamp;
1388 
1389     if(updateFlag){
1390       update();
1391     }
1392   }
1393 
1394   //end ORACLIZE functions
1395 }