1 pragma solidity ^0.4.2;
2 
3 
4 // <ORACLIZE_API>
5 /*
6 Copyright (c) 2015-2016 Oraclize SRL
7 Copyright (c) 2016 Oraclize LTD
8 
9 
10 
11 Permission is hereby granted, free of charge, to any person obtaining a copy
12 of this software and associated documentation files (the "Software"), to deal
13 in the Software without restriction, including without limitation the rights
14 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
15 copies of the Software, and to permit persons to whom the Software is
16 furnished to do so, subject to the following conditions:
17 
18 
19 
20 The above copyright notice and this permission notice shall be included in
21 all copies or substantial portions of the Software.
22 
23 
24 
25 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
28 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
31 THE SOFTWARE.
32 */
33 
34 pragma solidity ^0.4.0;
35 
36 
37 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
38 
39 contract OraclizeI {
40     address public cbAddress;
41 
42     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
43 
44     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
45 
46     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
47 
48     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
49 
50     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
51 
52     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
53 
54     function getPrice(string _datasource) returns (uint _dsprice);
55 
56     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
57 
58     function useCoupon(string _coupon);
59 
60     function setProofType(byte _proofType);
61 
62     function setConfig(bytes32 _config);
63 
64     function setCustomGasPrice(uint _gasPrice);
65 
66     function randomDS_getSessionPubKeyHash() returns (bytes32);
67 }
68 
69 
70 contract OraclizeAddrResolverI {
71     function getAddress() returns (address _addr);
72 }
73 
74 
75 contract usingOraclize {
76     uint constant day = 60 * 60 * 24;
77 
78     uint constant week = 60 * 60 * 24 * 7;
79 
80     uint constant month = 60 * 60 * 24 * 30;
81 
82     byte constant proofType_NONE = 0x00;
83 
84     byte constant proofType_TLSNotary = 0x10;
85 
86     byte constant proofType_Android = 0x20;
87 
88     byte constant proofType_Ledger = 0x30;
89 
90     byte constant proofType_Native = 0xF0;
91 
92     byte constant proofStorage_IPFS = 0x01;
93 
94     uint8 constant networkID_auto = 0;
95 
96     uint8 constant networkID_mainnet = 1;
97 
98     uint8 constant networkID_testnet = 2;
99 
100     uint8 constant networkID_morden = 2;
101 
102     uint8 constant networkID_consensys = 161;
103 
104     OraclizeAddrResolverI OAR;
105 
106     OraclizeI oraclize;
107     modifier oraclizeAPI {
108         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0)) oraclize_setNetwork(networkID_auto);
109         oraclize = OraclizeI(OAR.getAddress());
110         _;
111     }
112     modifier coupon(string code){
113         oraclize = OraclizeI(OAR.getAddress());
114         oraclize.useCoupon(code);
115         _;
116     }
117 
118     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
119         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
120             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
121             oraclize_setNetworkName("eth_mainnet");
122             return true;
123         }
124         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
125             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
126             oraclize_setNetworkName("eth_ropsten3");
127             return true;
128         }
129         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
130             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
131             oraclize_setNetworkName("eth_kovan");
132             return true;
133         }
134         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
135             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
136             oraclize_setNetworkName("eth_rinkeby");
137             return true;
138         }
139         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
140             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
141             return true;
142         }
143         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
144             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
145             return true;
146         }
147         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
148             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
149             return true;
150         }
151         return false;
152     }
153 
154     function __callback(bytes32 myid, string result) {
155         __callback(myid, result, new bytes(0));
156     }
157 
158     function __callback(bytes32 myid, string result, bytes proof) {
159     }
160 
161     function oraclize_useCoupon(string code) oraclizeAPI internal {
162         oraclize.useCoupon(code);
163     }
164 
165     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
166         return oraclize.getPrice(datasource);
167     }
168 
169     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
170         return oraclize.getPrice(datasource, gaslimit);
171     }
172 
173     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource);
175         if (price > 1 ether + tx.gasprice * 200000) return 0;
176         // unexpectedly high price
177         return oraclize.query.value(price)(0, datasource, arg);
178     }
179 
180     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
181         uint price = oraclize.getPrice(datasource);
182         if (price > 1 ether + tx.gasprice * 200000) return 0;
183         // unexpectedly high price
184         return oraclize.query.value(price)(timestamp, datasource, arg);
185     }
186 
187     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource, gaslimit);
189         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
190         // unexpectedly high price
191         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
192     }
193 
194     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
195         uint price = oraclize.getPrice(datasource, gaslimit);
196         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
197         // unexpectedly high price
198         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
199     }
200 
201     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
202         uint price = oraclize.getPrice(datasource);
203         if (price > 1 ether + tx.gasprice * 200000) return 0;
204         // unexpectedly high price
205         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
206     }
207 
208     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
209         uint price = oraclize.getPrice(datasource);
210         if (price > 1 ether + tx.gasprice * 200000) return 0;
211         // unexpectedly high price
212         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
213     }
214 
215     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
216         uint price = oraclize.getPrice(datasource, gaslimit);
217         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
218         // unexpectedly high price
219         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
220     }
221 
222     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
223         uint price = oraclize.getPrice(datasource, gaslimit);
224         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
225         // unexpectedly high price
226         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
227     }
228 
229     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
230         uint price = oraclize.getPrice(datasource);
231         if (price > 1 ether + tx.gasprice * 200000) return 0;
232         // unexpectedly high price
233         bytes memory args = stra2cbor(argN);
234         return oraclize.queryN.value(price)(0, datasource, args);
235     }
236 
237     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
238         uint price = oraclize.getPrice(datasource);
239         if (price > 1 ether + tx.gasprice * 200000) return 0;
240         // unexpectedly high price
241         bytes memory args = stra2cbor(argN);
242         return oraclize.queryN.value(price)(timestamp, datasource, args);
243     }
244 
245     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
246         uint price = oraclize.getPrice(datasource, gaslimit);
247         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
248         // unexpectedly high price
249         bytes memory args = stra2cbor(argN);
250         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
251     }
252 
253     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
254         uint price = oraclize.getPrice(datasource, gaslimit);
255         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
256         // unexpectedly high price
257         bytes memory args = stra2cbor(argN);
258         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
259     }
260 
261     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](1);
263         dynargs[0] = args[0];
264         return oraclize_query(datasource, dynargs);
265     }
266 
267     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](1);
269         dynargs[0] = args[0];
270         return oraclize_query(timestamp, datasource, dynargs);
271     }
272 
273     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](1);
275         dynargs[0] = args[0];
276         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
277     }
278 
279     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
280         string[] memory dynargs = new string[](1);
281         dynargs[0] = args[0];
282         return oraclize_query(datasource, dynargs, gaslimit);
283     }
284 
285     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
286         string[] memory dynargs = new string[](2);
287         dynargs[0] = args[0];
288         dynargs[1] = args[1];
289         return oraclize_query(datasource, dynargs);
290     }
291 
292     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](2);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         return oraclize_query(timestamp, datasource, dynargs);
297     }
298 
299     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](2);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
304     }
305 
306     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
307         string[] memory dynargs = new string[](2);
308         dynargs[0] = args[0];
309         dynargs[1] = args[1];
310         return oraclize_query(datasource, dynargs, gaslimit);
311     }
312 
313     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](3);
315         dynargs[0] = args[0];
316         dynargs[1] = args[1];
317         dynargs[2] = args[2];
318         return oraclize_query(datasource, dynargs);
319     }
320 
321     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](3);
323         dynargs[0] = args[0];
324         dynargs[1] = args[1];
325         dynargs[2] = args[2];
326         return oraclize_query(timestamp, datasource, dynargs);
327     }
328 
329     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](3);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
335     }
336 
337     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](3);
339         dynargs[0] = args[0];
340         dynargs[1] = args[1];
341         dynargs[2] = args[2];
342         return oraclize_query(datasource, dynargs, gaslimit);
343     }
344 
345     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
346         string[] memory dynargs = new string[](4);
347         dynargs[0] = args[0];
348         dynargs[1] = args[1];
349         dynargs[2] = args[2];
350         dynargs[3] = args[3];
351         return oraclize_query(datasource, dynargs);
352     }
353 
354     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
355         string[] memory dynargs = new string[](4);
356         dynargs[0] = args[0];
357         dynargs[1] = args[1];
358         dynargs[2] = args[2];
359         dynargs[3] = args[3];
360         return oraclize_query(timestamp, datasource, dynargs);
361     }
362 
363     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
364         string[] memory dynargs = new string[](4);
365         dynargs[0] = args[0];
366         dynargs[1] = args[1];
367         dynargs[2] = args[2];
368         dynargs[3] = args[3];
369         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
370     }
371 
372     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         string[] memory dynargs = new string[](4);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         dynargs[2] = args[2];
377         dynargs[3] = args[3];
378         return oraclize_query(datasource, dynargs, gaslimit);
379     }
380 
381     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
382         string[] memory dynargs = new string[](5);
383         dynargs[0] = args[0];
384         dynargs[1] = args[1];
385         dynargs[2] = args[2];
386         dynargs[3] = args[3];
387         dynargs[4] = args[4];
388         return oraclize_query(datasource, dynargs);
389     }
390 
391     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
392         string[] memory dynargs = new string[](5);
393         dynargs[0] = args[0];
394         dynargs[1] = args[1];
395         dynargs[2] = args[2];
396         dynargs[3] = args[3];
397         dynargs[4] = args[4];
398         return oraclize_query(timestamp, datasource, dynargs);
399     }
400 
401     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
402         string[] memory dynargs = new string[](5);
403         dynargs[0] = args[0];
404         dynargs[1] = args[1];
405         dynargs[2] = args[2];
406         dynargs[3] = args[3];
407         dynargs[4] = args[4];
408         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
409     }
410 
411     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         string[] memory dynargs = new string[](5);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         dynargs[3] = args[3];
417         dynargs[4] = args[4];
418         return oraclize_query(datasource, dynargs, gaslimit);
419     }
420 
421     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource);
423         if (price > 1 ether + tx.gasprice * 200000) return 0;
424         // unexpectedly high price
425         bytes memory args = ba2cbor(argN);
426         return oraclize.queryN.value(price)(0, datasource, args);
427     }
428 
429     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource);
431         if (price > 1 ether + tx.gasprice * 200000) return 0;
432         // unexpectedly high price
433         bytes memory args = ba2cbor(argN);
434         return oraclize.queryN.value(price)(timestamp, datasource, args);
435     }
436 
437     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
438         uint price = oraclize.getPrice(datasource, gaslimit);
439         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
440         // unexpectedly high price
441         bytes memory args = ba2cbor(argN);
442         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
443     }
444 
445     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource, gaslimit);
447         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
448         // unexpectedly high price
449         bytes memory args = ba2cbor(argN);
450         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
451     }
452 
453     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](1);
455         dynargs[0] = args[0];
456         return oraclize_query(datasource, dynargs);
457     }
458 
459     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](1);
461         dynargs[0] = args[0];
462         return oraclize_query(timestamp, datasource, dynargs);
463     }
464 
465     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](1);
467         dynargs[0] = args[0];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470 
471     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         bytes[] memory dynargs = new bytes[](1);
473         dynargs[0] = args[0];
474         return oraclize_query(datasource, dynargs, gaslimit);
475     }
476 
477     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
478         bytes[] memory dynargs = new bytes[](2);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         return oraclize_query(datasource, dynargs);
482     }
483 
484     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](2);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         return oraclize_query(timestamp, datasource, dynargs);
489     }
490 
491     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
492         bytes[] memory dynargs = new bytes[](2);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
496     }
497 
498     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](2);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504 
505     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
506         bytes[] memory dynargs = new bytes[](3);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         return oraclize_query(datasource, dynargs);
511     }
512 
513     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](3);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         return oraclize_query(timestamp, datasource, dynargs);
519     }
520 
521     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         bytes[] memory dynargs = new bytes[](3);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
527     }
528 
529     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         bytes[] memory dynargs = new bytes[](3);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         return oraclize_query(datasource, dynargs, gaslimit);
535     }
536 
537     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
538         bytes[] memory dynargs = new bytes[](4);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         return oraclize_query(datasource, dynargs);
544     }
545 
546     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](4);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         return oraclize_query(timestamp, datasource, dynargs);
553     }
554 
555     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         bytes[] memory dynargs = new bytes[](4);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
562     }
563 
564     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](4);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         return oraclize_query(datasource, dynargs, gaslimit);
571     }
572 
573     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(datasource, dynargs);
581     }
582 
583     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
584         bytes[] memory dynargs = new bytes[](5);
585         dynargs[0] = args[0];
586         dynargs[1] = args[1];
587         dynargs[2] = args[2];
588         dynargs[3] = args[3];
589         dynargs[4] = args[4];
590         return oraclize_query(timestamp, datasource, dynargs);
591     }
592 
593     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](5);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         dynargs[3] = args[3];
599         dynargs[4] = args[4];
600         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
601     }
602 
603     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](5);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         dynargs[4] = args[4];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612 
613     function oraclize_cbAddress() oraclizeAPI internal returns (address){
614         return oraclize.cbAddress();
615     }
616 
617     function oraclize_setProof(byte proofP) oraclizeAPI internal {
618         return oraclize.setProofType(proofP);
619     }
620 
621     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
622         return oraclize.setCustomGasPrice(gasPrice);
623     }
624 
625     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
626         return oraclize.setConfig(config);
627     }
628 
629     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
630         return oraclize.randomDS_getSessionPubKeyHash();
631     }
632 
633     function getCodeSize(address _addr) constant internal returns (uint _size) {
634         assembly {
635         _size := extcodesize(_addr)
636         }
637     }
638 
639     function parseAddr(string _a) internal returns (address){
640         bytes memory tmp = bytes(_a);
641         uint160 iaddr = 0;
642         uint160 b1;
643         uint160 b2;
644         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
645             iaddr *= 256;
646             b1 = uint160(tmp[i]);
647             b2 = uint160(tmp[i + 1]);
648             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
649             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
650             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
651             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
652             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
653             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
654             iaddr += (b1 * 16 + b2);
655         }
656         return address(iaddr);
657     }
658 
659     function strCompare(string _a, string _b) internal returns (int) {
660         bytes memory a = bytes(_a);
661         bytes memory b = bytes(_b);
662         uint minLength = a.length;
663         if (b.length < minLength) minLength = b.length;
664         for (uint i = 0; i < minLength; i ++)
665         if (a[i] < b[i])
666         return - 1;
667         else if (a[i] > b[i])
668         return 1;
669         if (a.length < b.length)
670         return - 1;
671         else if (a.length > b.length)
672         return 1;
673         else
674         return 0;
675     }
676 
677     function indexOf(string _haystack, string _needle) internal returns (int) {
678         bytes memory h = bytes(_haystack);
679         bytes memory n = bytes(_needle);
680         if (h.length < 1 || n.length < 1 || (n.length > h.length))
681         return - 1;
682         else if (h.length > (2 ** 128 - 1))
683         return - 1;
684         else
685         {
686             uint subindex = 0;
687             for (uint i = 0; i < h.length; i ++)
688             {
689                 if (h[i] == n[0])
690                 {
691                     subindex = 1;
692                     while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
693                     {
694                         subindex++;
695                     }
696                     if (subindex == n.length)
697                     return int(i);
698                 }
699             }
700             return - 1;
701         }
702     }
703 
704     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
705         bytes memory _ba = bytes(_a);
706         bytes memory _bb = bytes(_b);
707         bytes memory _bc = bytes(_c);
708         bytes memory _bd = bytes(_d);
709         bytes memory _be = bytes(_e);
710         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
711         bytes memory babcde = bytes(abcde);
712         uint k = 0;
713         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
714         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
715         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
716         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
717         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
718         return string(babcde);
719     }
720 
721     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
722         return strConcat(_a, _b, _c, _d, "");
723     }
724 
725     function strConcat(string _a, string _b, string _c) internal returns (string) {
726         return strConcat(_a, _b, _c, "", "");
727     }
728 
729     function strConcat(string _a, string _b) internal returns (string) {
730         return strConcat(_a, _b, "", "", "");
731     }
732 
733     // parseInt
734     function parseInt(string _a) internal returns (uint) {
735         return parseInt(_a, 0);
736     }
737 
738     // parseInt(parseFloat*10^_b)
739     function parseInt(string _a, uint _b) internal returns (uint) {
740         bytes memory bresult = bytes(_a);
741         uint mint = 0;
742         bool decimals = false;
743         for (uint i = 0; i < bresult.length; i++) {
744             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
745                 if (decimals) {
746                     if (_b == 0) break;
747                     else _b--;
748                 }
749                 mint *= 10;
750                 mint += uint(bresult[i]) - 48;
751             }
752             else if (bresult[i] == 46) decimals = true;
753         }
754         if (_b > 0) mint *= 10 ** _b;
755         return mint;
756     }
757 
758     function uint2str(uint i) internal returns (string){
759         if (i == 0) return "0";
760         uint j = i;
761         uint len;
762         while (j != 0) {
763             len++;
764             j /= 10;
765         }
766         bytes memory bstr = new bytes(len);
767         uint k = len - 1;
768         while (i != 0) {
769             bstr[k--] = byte(48 + i % 10);
770             i /= 10;
771         }
772         return string(bstr);
773     }
774 
775     function stra2cbor(string[] arr) internal returns (bytes) {
776         uint arrlen = arr.length;
777 
778         // get correct cbor output length
779         uint outputlen = 0;
780         bytes[] memory elemArray = new bytes[](arrlen);
781         for (uint i = 0; i < arrlen; i++) {
782             elemArray[i] = (bytes(arr[i]));
783             outputlen += elemArray[i].length + (elemArray[i].length - 1) / 23 + 3;
784             //+3 accounts for paired identifier types
785         }
786         uint ctr = 0;
787         uint cborlen = arrlen + 0x80;
788         outputlen += byte(cborlen).length;
789         bytes memory res = new bytes(outputlen);
790 
791         while (byte(cborlen).length > ctr) {
792             res[ctr] = byte(cborlen)[ctr];
793             ctr++;
794         }
795         for (i = 0; i < arrlen; i++) {
796             res[ctr] = 0x5F;
797             ctr++;
798             for (uint x = 0; x < elemArray[i].length; x++) {
799                 // if there's a bug with larger strings, this may be the culprit
800                 if (x % 23 == 0) {
801                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
802                     elemcborlen += 0x40;
803                     uint lctr = ctr;
804                     while (byte(elemcborlen).length > ctr - lctr) {
805                         res[ctr] = byte(elemcborlen)[ctr - lctr];
806                         ctr++;
807                     }
808                 }
809                 res[ctr] = elemArray[i][x];
810                 ctr++;
811             }
812             res[ctr] = 0xFF;
813             ctr++;
814         }
815         return res;
816     }
817 
818     function ba2cbor(bytes[] arr) internal returns (bytes) {
819         uint arrlen = arr.length;
820 
821         // get correct cbor output length
822         uint outputlen = 0;
823         bytes[] memory elemArray = new bytes[](arrlen);
824         for (uint i = 0; i < arrlen; i++) {
825             elemArray[i] = (bytes(arr[i]));
826             outputlen += elemArray[i].length + (elemArray[i].length - 1) / 23 + 3;
827             //+3 accounts for paired identifier types
828         }
829         uint ctr = 0;
830         uint cborlen = arrlen + 0x80;
831         outputlen += byte(cborlen).length;
832         bytes memory res = new bytes(outputlen);
833 
834         while (byte(cborlen).length > ctr) {
835             res[ctr] = byte(cborlen)[ctr];
836             ctr++;
837         }
838         for (i = 0; i < arrlen; i++) {
839             res[ctr] = 0x5F;
840             ctr++;
841             for (uint x = 0; x < elemArray[i].length; x++) {
842                 // if there's a bug with larger strings, this may be the culprit
843                 if (x % 23 == 0) {
844                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
845                     elemcborlen += 0x40;
846                     uint lctr = ctr;
847                     while (byte(elemcborlen).length > ctr - lctr) {
848                         res[ctr] = byte(elemcborlen)[ctr - lctr];
849                         ctr++;
850                     }
851                 }
852                 res[ctr] = elemArray[i][x];
853                 ctr++;
854             }
855             res[ctr] = 0xFF;
856             ctr++;
857         }
858         return res;
859     }
860 
861 
862     string oraclize_network_name;
863 
864     function oraclize_setNetworkName(string _network_name) internal {
865         oraclize_network_name = _network_name;
866     }
867 
868     function oraclize_getNetworkName() internal returns (string) {
869         return oraclize_network_name;
870     }
871 
872     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
873         if ((_nbytes == 0) || (_nbytes > 32)) throw;
874         bytes memory nbytes = new bytes(1);
875         nbytes[0] = byte(_nbytes);
876         bytes memory unonce = new bytes(32);
877         bytes memory sessionKeyHash = new bytes(32);
878         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
879         assembly {
880         mstore(unonce, 0x20)
881         mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
882         mstore(sessionKeyHash, 0x20)
883         mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
884         }
885         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
886         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
887         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
888         return queryId;
889     }
890 
891     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
892         oraclize_randomDS_args[queryId] = commitment;
893     }
894 
895     mapping (bytes32 => bytes32) oraclize_randomDS_args;
896 
897     mapping (bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
898 
899     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
900         bool sigok;
901         address signer;
902 
903         bytes32 sigr;
904         bytes32 sigs;
905 
906         bytes memory sigr_ = new bytes(32);
907         uint offset = 4 + (uint(dersig[3]) - 0x20);
908         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
909         bytes memory sigs_ = new bytes(32);
910         offset += 32 + 2;
911         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
912 
913         assembly {
914         sigr := mload(add(sigr_, 32))
915         sigs := mload(add(sigs_, 32))
916         }
917 
918 
919         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
920         if (address(sha3(pubkey)) == signer) return true;
921         else {
922             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
923             return (address(sha3(pubkey)) == signer);
924         }
925     }
926 
927     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
928         bool sigok;
929 
930         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
931         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
932         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
933 
934         bytes memory appkey1_pubkey = new bytes(64);
935         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
936 
937         bytes memory tosign2 = new bytes(1 + 65 + 32);
938         tosign2[0] = 1;
939         //role
940         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
941         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
942         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
943         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
944 
945         if (sigok == false) return false;
946 
947 
948         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
949         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
950 
951         bytes memory tosign3 = new bytes(1 + 65);
952         tosign3[0] = 0xFE;
953         copyBytes(proof, 3, 65, tosign3, 1);
954 
955         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
956         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
957 
958         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
959 
960         return sigok;
961     }
962 
963     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
964         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
965         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) throw;
966 
967         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
968         if (proofVerified == false) throw;
969 
970         _;
971     }
972 
973     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
974         bool match_ = true;
975 
976         for (var i = 0; i < prefix.length; i++) {
977             if (content[i] != prefix[i]) match_ = false;
978         }
979 
980         return match_;
981     }
982 
983     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
984         bool checkok;
985 
986 
987         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
988         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
989         bytes memory keyhash = new bytes(32);
990         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
991         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
992         if (checkok == false) return false;
993 
994         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
995         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
996 
997 
998         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
999         checkok = matchBytes32Prefix(sha256(sig1), result);
1000         if (checkok == false) return false;
1001 
1002 
1003         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1004         // This is to verify that the computed args match with the ones specified in the query.
1005         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1006         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1007 
1008         bytes memory sessionPubkey = new bytes(64);
1009         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1010         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
1011 
1012         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1013         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
1014             delete oraclize_randomDS_args[queryId];
1015         }
1016         else return false;
1017 
1018 
1019         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1020         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1021         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1022         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1023         if (checkok == false) return false;
1024 
1025         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1026         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1027             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1028         }
1029 
1030         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1031     }
1032 
1033 
1034     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1035     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1036         uint minLength = length + toOffset;
1037 
1038         if (to.length < minLength) {
1039             // Buffer too small
1040             throw;
1041             // Should be a better way?
1042         }
1043 
1044         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1045         uint i = 32 + fromOffset;
1046         uint j = 32 + toOffset;
1047 
1048         while (i < (32 + fromOffset + length)) {
1049             assembly {
1050             let tmp := mload(add(from, i))
1051             mstore(add(to, j), tmp)
1052             }
1053             i += 32;
1054             j += 32;
1055         }
1056 
1057         return to;
1058     }
1059 
1060     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1061     // Duplicate Solidity's ecrecover, but catching the CALL return value
1062     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1063         // We do our own memory management here. Solidity uses memory offset
1064         // 0x40 to store the current end of memory. We write past it (as
1065         // writes are memory extensions), but don't update the offset so
1066         // Solidity will reuse it. The memory used here is only needed for
1067         // this context.
1068 
1069         // FIXME: inline assembly can't access return values
1070         bool ret;
1071         address addr;
1072 
1073         assembly {
1074         let size := mload(0x40)
1075         mstore(size, hash)
1076         mstore(add(size, 32), v)
1077         mstore(add(size, 64), r)
1078         mstore(add(size, 96), s)
1079 
1080         // NOTE: we can reuse the request memory because we deal with
1081         //       the return code
1082         ret := call(3000, 1, 0, size, 128, size, 32)
1083         addr := mload(size)
1084         }
1085 
1086         return (ret, addr);
1087     }
1088 
1089     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1090     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1091         bytes32 r;
1092         bytes32 s;
1093         uint8 v;
1094 
1095         if (sig.length != 65)
1096         return (false, 0);
1097 
1098         // The signature format is a compact form of:
1099         //   {bytes32 r}{bytes32 s}{uint8 v}
1100         // Compact means, uint8 is not padded to 32 bytes.
1101         assembly {
1102         r := mload(add(sig, 32))
1103         s := mload(add(sig, 64))
1104 
1105         // Here we are loading the last 32 bytes. We exploit the fact that
1106         // 'mload' will pad with zeroes if we overread.
1107         // There is no 'mload8' to do this, but that would be nicer.
1108         v
1109         := byte(0, mload(add(sig, 96)))
1110 
1111         // Alternative solution:
1112         // 'byte' is not working due to the Solidity parser, so lets
1113         // use the second best option, 'and'
1114         // v := and(mload(add(sig, 65)), 255)
1115     }
1116 
1117 
1118 // albeit non-transactional signatures are not specified by the YP, one would expect it
1119 // to match the YP range of [27, 28]
1120 //
1121 // geth uses [0, 1] and some clients have followed. This might change, see:
1122 //  https://github.com/ethereum/go-ethereum/issues/2053
1123 if (v < 27)
1124 v += 27;
1125 
1126 if (v != 27 && v != 28)
1127 return (false, 0);
1128 
1129 return safer_ecrecover(hash, v, r, s);
1130 }
1131 
1132 }
1133 // </ORACLIZE_API>
1134 
1135 /*
1136  * @title String & slice utility library for Solidity contracts.
1137  * @author Nick Johnson <arachnid@notdot.net>
1138  *
1139  * @dev Functionality in this library is largely implemented using an
1140  *      abstraction called a 'slice'. A slice represents a part of a string -
1141  *      anything from the entire string to a single character, or even no
1142  *      characters at all (a 0-length slice). Since a slice only has to specify
1143  *      an offset and a length, copying and manipulating slices is a lot less
1144  *      expensive than copying and manipulating the strings they reference.
1145  *
1146  *      To further reduce gas costs, most functions on slice that need to return
1147  *      a slice modify the original one instead of allocating a new one; for
1148  *      instance, `s.split(".")` will return the text up to the first '.',
1149  *      modifying s to only contain the remainder of the string after the '.'.
1150  *      In situations where you do not want to modify the original slice, you
1151  *      can make a copy first with `.copy()`, for example:
1152  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1153  *      Solidity has no memory management, it will result in allocating many
1154  *      short-lived slices that are later discarded.
1155  *
1156  *      Functions that return two slices come in two versions: a non-allocating
1157  *      version that takes the second slice as an argument, modifying it in
1158  *      place, and an allocating version that allocates and returns the second
1159  *      slice; see `nextRune` for example.
1160  *
1161  *      Functions that have to copy string data will return strings rather than
1162  *      slices; these can be cast back to slices for further processing if
1163  *      required.
1164  *
1165  *      For convenience, some functions are provided with non-modifying
1166  *      variants that create a new slice and return both; for instance,
1167  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1168  *      corresponding to the left and right parts of the string.
1169  */
1170 library strings {
1171 struct slice {
1172 uint _len;
1173 uint _ptr;
1174 }
1175 
1176 function memcpy(uint dest, uint src, uint len) private {
1177 // Copy word-length chunks while possible
1178 for (; len >= 32; len -= 32) {
1179 assembly {
1180 mstore(dest, mload(src))
1181 }
1182 dest += 32;
1183 src += 32;
1184 }
1185 
1186 // Copy remaining bytes
1187 uint mask = 256 ** (32 - len) - 1;
1188 assembly {
1189 let srcpart := and(mload(src), not(mask))
1190 let destpart := and(mload(dest), mask)
1191 mstore(dest, or(destpart, srcpart))
1192 }
1193 }
1194 
1195 /*
1196  * @dev Returns a slice containing the entire string.
1197  * @param self The string to make a slice from.
1198  * @return A newly allocated slice containing the entire string.
1199  */
1200 function toSlice(string self) internal returns (slice) {
1201 uint ptr;
1202 assembly {
1203 ptr := add(self, 0x20)
1204 }
1205 return slice(bytes(self).length, ptr);
1206 }
1207 
1208 /*
1209  * @dev Returns the length of a null-terminated bytes32 string.
1210  * @param self The value to find the length of.
1211  * @return The length of the string, from 0 to 32.
1212  */
1213 function len(bytes32 self) internal returns (uint) {
1214 uint ret;
1215 if (self == 0)
1216 return 0;
1217 if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1218 ret += 16;
1219 self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1220 }
1221 if (self & 0xffffffffffffffff == 0) {
1222 ret += 8;
1223 self = bytes32(uint(self) / 0x10000000000000000);
1224 }
1225 if (self & 0xffffffff == 0) {
1226 ret += 4;
1227 self = bytes32(uint(self) / 0x100000000);
1228 }
1229 if (self & 0xffff == 0) {
1230 ret += 2;
1231 self = bytes32(uint(self) / 0x10000);
1232 }
1233 if (self & 0xff == 0) {
1234 ret += 1;
1235 }
1236 return 32 - ret;
1237 }
1238 
1239 /*
1240  * @dev Returns a slice containing the entire bytes32, interpreted as a
1241  *      null-termintaed utf-8 string.
1242  * @param self The bytes32 value to convert to a slice.
1243  * @return A new slice containing the value of the input argument up to the
1244  *         first null.
1245  */
1246 function toSliceB32(bytes32 self) internal returns (slice ret) {
1247 // Allocate space for `self` in memory, copy it there, and point ret at it
1248 assembly {
1249 let ptr := mload(0x40)
1250 mstore(0x40, add(ptr, 0x20))
1251 mstore(ptr, self)
1252 mstore(add(ret, 0x20), ptr)
1253 }
1254 ret._len = len(self);
1255 }
1256 
1257 /*
1258  * @dev Returns a new slice containing the same data as the current slice.
1259  * @param self The slice to copy.
1260  * @return A new slice containing the same data as `self`.
1261  */
1262 function copy(slice self) internal returns (slice) {
1263 return slice(self._len, self._ptr);
1264 }
1265 
1266 /*
1267  * @dev Copies a slice to a new string.
1268  * @param self The slice to copy.
1269  * @return A newly allocated string containing the slice's text.
1270  */
1271 function toString(slice self) internal returns (string) {
1272 var ret = new string(self._len);
1273 uint retptr;
1274 assembly {retptr := add(ret, 32)}
1275 
1276 memcpy(retptr, self._ptr, self._len);
1277 return ret;
1278 }
1279 
1280 /*
1281  * @dev Returns the length in runes of the slice. Note that this operation
1282  *      takes time proportional to the length of the slice; avoid using it
1283  *      in loops, and call `slice.empty()` if you only need to know whether
1284  *      the slice is empty or not.
1285  * @param self The slice to operate on.
1286  * @return The length of the slice in runes.
1287  */
1288 function len(slice self) internal returns (uint) {
1289 // Starting at ptr-31 means the LSB will be the byte we care about
1290 var ptr = self._ptr - 31;
1291 var end = ptr + self._len;
1292 for (uint len = 0; ptr < end; len++) {
1293 uint8 b;
1294 assembly {b := and(mload(ptr), 0xFF)}
1295 if (b < 0x80) {
1296 ptr += 1;
1297 } else if (b < 0xE0) {
1298 ptr += 2;
1299 } else if (b < 0xF0) {
1300 ptr += 3;
1301 } else if (b < 0xF8) {
1302 ptr += 4;
1303 } else if (b < 0xFC) {
1304 ptr += 5;
1305 } else {
1306 ptr += 6;
1307 }
1308 }
1309 return len;
1310 }
1311 
1312 /*
1313  * @dev Returns true if the slice is empty (has a length of 0).
1314  * @param self The slice to operate on.
1315  * @return True if the slice is empty, False otherwise.
1316  */
1317 function empty(slice self) internal returns (bool) {
1318 return self._len == 0;
1319 }
1320 
1321 /*
1322  * @dev Returns a positive number if `other` comes lexicographically after
1323  *      `self`, a negative number if it comes before, or zero if the
1324  *      contents of the two slices are equal. Comparison is done per-rune,
1325  *      on unicode codepoints.
1326  * @param self The first slice to compare.
1327  * @param other The second slice to compare.
1328  * @return The result of the comparison.
1329  */
1330 function compare(slice self, slice other) internal returns (int) {
1331 uint shortest = self._len;
1332 if (other._len < self._len)
1333 shortest = other._len;
1334 
1335 var selfptr = self._ptr;
1336 var otherptr = other._ptr;
1337 for (uint idx = 0; idx < shortest; idx += 32) {
1338 uint a;
1339 uint b;
1340 assembly {
1341 a := mload(selfptr)
1342 b := mload(otherptr)
1343 }
1344 if (a != b) {
1345 // Mask out irrelevant bytes and check again
1346 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1347 var diff = (a & mask) - (b & mask);
1348 if (diff != 0)
1349 return int(diff);
1350 }
1351 selfptr += 32;
1352 otherptr += 32;
1353 }
1354 return int(self._len) - int(other._len);
1355 }
1356 
1357 /*
1358  * @dev Returns true if the two slices contain the same text.
1359  * @param self The first slice to compare.
1360  * @param self The second slice to compare.
1361  * @return True if the slices are equal, false otherwise.
1362  */
1363 function equals(slice self, slice other) internal returns (bool) {
1364 return compare(self, other) == 0;
1365 }
1366 
1367 /*
1368  * @dev Extracts the first rune in the slice into `rune`, advancing the
1369  *      slice to point to the next rune and returning `self`.
1370  * @param self The slice to operate on.
1371  * @param rune The slice that will contain the first rune.
1372  * @return `rune`.
1373  */
1374 function nextRune(slice self, slice rune) internal returns (slice) {
1375 rune._ptr = self._ptr;
1376 
1377 if (self._len == 0) {
1378 rune._len = 0;
1379 return rune;
1380 }
1381 
1382 uint len;
1383 uint b;
1384 // Load the first byte of the rune into the LSBs of b
1385 assembly {b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF)}
1386 if (b < 0x80) {
1387 len = 1;
1388 } else if (b < 0xE0) {
1389 len = 2;
1390 } else if (b < 0xF0) {
1391 len = 3;
1392 } else {
1393 len = 4;
1394 }
1395 
1396 // Check for truncated codepoints
1397 if (len > self._len) {
1398 rune._len = self._len;
1399 self._ptr += self._len;
1400 self._len = 0;
1401 return rune;
1402 }
1403 
1404 self._ptr += len;
1405 self._len -= len;
1406 rune._len = len;
1407 return rune;
1408 }
1409 
1410 /*
1411  * @dev Returns the first rune in the slice, advancing the slice to point
1412  *      to the next rune.
1413  * @param self The slice to operate on.
1414  * @return A slice containing only the first rune from `self`.
1415  */
1416 function nextRune(slice self) internal returns (slice ret) {
1417 nextRune(self, ret);
1418 }
1419 
1420 /*
1421  * @dev Returns the number of the first codepoint in the slice.
1422  * @param self The slice to operate on.
1423  * @return The number of the first codepoint in the slice.
1424  */
1425 function ord(slice self) internal returns (uint ret) {
1426 if (self._len == 0) {
1427 return 0;
1428 }
1429 
1430 uint word;
1431 uint len;
1432 uint divisor = 2 ** 248;
1433 
1434 // Load the rune into the MSBs of b
1435 assembly {word := mload(mload(add(self, 32)))}
1436 var b = word / divisor;
1437 if (b < 0x80) {
1438 ret = b;
1439 len = 1;
1440 } else if (b < 0xE0) {
1441 ret = b & 0x1F;
1442 len = 2;
1443 } else if (b < 0xF0) {
1444 ret = b & 0x0F;
1445 len = 3;
1446 } else {
1447 ret = b & 0x07;
1448 len = 4;
1449 }
1450 
1451 // Check for truncated codepoints
1452 if (len > self._len) {
1453 return 0;
1454 }
1455 
1456 for (uint i = 1; i < len; i++) {
1457 divisor = divisor / 256;
1458 b = (word / divisor) & 0xFF;
1459 if (b & 0xC0 != 0x80) {
1460 // Invalid UTF-8 sequence
1461 return 0;
1462 }
1463 ret = (ret * 64) | (b & 0x3F);
1464 }
1465 
1466 return ret;
1467 }
1468 
1469 /*
1470  * @dev Returns the keccak-256 hash of the slice.
1471  * @param self The slice to hash.
1472  * @return The hash of the slice.
1473  */
1474 function keccak(slice self) internal returns (bytes32 ret) {
1475 assembly {
1476 ret := sha3(mload(add(self, 32)), mload(self))
1477 }
1478 }
1479 
1480 /*
1481  * @dev Returns true if `self` starts with `needle`.
1482  * @param self The slice to operate on.
1483  * @param needle The slice to search for.
1484  * @return True if the slice starts with the provided text, false otherwise.
1485  */
1486 function startsWith(slice self, slice needle) internal returns (bool) {
1487 if (self._len < needle._len) {
1488 return false;
1489 }
1490 
1491 if (self._ptr == needle._ptr) {
1492 return true;
1493 }
1494 
1495 bool equal;
1496 assembly {
1497 let len := mload(needle)
1498 let selfptr := mload(add(self, 0x20))
1499 let needleptr := mload(add(needle, 0x20))
1500 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1501 }
1502 return equal;
1503 }
1504 
1505 /*
1506  * @dev If `self` starts with `needle`, `needle` is removed from the
1507  *      beginning of `self`. Otherwise, `self` is unmodified.
1508  * @param self The slice to operate on.
1509  * @param needle The slice to search for.
1510  * @return `self`
1511  */
1512 function beyond(slice self, slice needle) internal returns (slice) {
1513 if (self._len < needle._len) {
1514 return self;
1515 }
1516 
1517 bool equal = true;
1518 if (self._ptr != needle._ptr) {
1519 assembly {
1520 let len := mload(needle)
1521 let selfptr := mload(add(self, 0x20))
1522 let needleptr := mload(add(needle, 0x20))
1523 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1524 }
1525 }
1526 
1527 if (equal) {
1528 self._len -= needle._len;
1529 self._ptr += needle._len;
1530 }
1531 
1532 return self;
1533 }
1534 
1535 /*
1536  * @dev Returns true if the slice ends with `needle`.
1537  * @param self The slice to operate on.
1538  * @param needle The slice to search for.
1539  * @return True if the slice starts with the provided text, false otherwise.
1540  */
1541 function endsWith(slice self, slice needle) internal returns (bool) {
1542 if (self._len < needle._len) {
1543 return false;
1544 }
1545 
1546 var selfptr = self._ptr + self._len - needle._len;
1547 
1548 if (selfptr == needle._ptr) {
1549 return true;
1550 }
1551 
1552 bool equal;
1553 assembly {
1554 let len := mload(needle)
1555 let needleptr := mload(add(needle, 0x20))
1556 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1557 }
1558 
1559 return equal;
1560 }
1561 
1562 /*
1563  * @dev If `self` ends with `needle`, `needle` is removed from the
1564  *      end of `self`. Otherwise, `self` is unmodified.
1565  * @param self The slice to operate on.
1566  * @param needle The slice to search for.
1567  * @return `self`
1568  */
1569 function until(slice self, slice needle) internal returns (slice) {
1570 if (self._len < needle._len) {
1571 return self;
1572 }
1573 
1574 var selfptr = self._ptr + self._len - needle._len;
1575 bool equal = true;
1576 if (selfptr != needle._ptr) {
1577 assembly {
1578 let len := mload(needle)
1579 let needleptr := mload(add(needle, 0x20))
1580 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1581 }
1582 }
1583 
1584 if (equal) {
1585 self._len -= needle._len;
1586 }
1587 
1588 return self;
1589 }
1590 
1591 // Returns the memory address of the first byte of the first occurrence of
1592 // `needle` in `self`, or the first byte after `self` if not found.
1593 function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1594 uint ptr;
1595 uint idx;
1596 
1597 if (needlelen <= selflen) {
1598 if (needlelen <= 32) {
1599 // Optimized assembly for 68 gas per byte on short strings
1600 assembly {
1601 let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1602 let needledata := and(mload(needleptr), mask)
1603 let end := add(selfptr, sub(selflen, needlelen))
1604 ptr := selfptr
1605 loop :
1606 jumpi(exit, eq(and(mload(ptr), mask), needledata))
1607 ptr := add(ptr, 1)
1608 jumpi(loop, lt(sub(ptr, 1), end))
1609 ptr := add(selfptr, selflen)
1610 exit:
1611 }
1612 return ptr;
1613 } else {
1614 // For long needles, use hashing
1615 bytes32 hash;
1616 assembly {hash := sha3(needleptr, needlelen)}
1617 ptr = selfptr;
1618 for (idx = 0; idx <= selflen - needlelen; idx++) {
1619 bytes32 testHash;
1620 assembly {testHash := sha3(ptr, needlelen)}
1621 if (hash == testHash)
1622 return ptr;
1623 ptr += 1;
1624 }
1625 }
1626 }
1627 return selfptr + selflen;
1628 }
1629 
1630 // Returns the memory address of the first byte after the last occurrence of
1631 // `needle` in `self`, or the address of `self` if not found.
1632 function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1633 uint ptr;
1634 
1635 if (needlelen <= selflen) {
1636 if (needlelen <= 32) {
1637 // Optimized assembly for 69 gas per byte on short strings
1638 assembly {
1639 let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1640 let needledata := and(mload(needleptr), mask)
1641 ptr := add(selfptr, sub(selflen, needlelen))
1642 loop :
1643 jumpi(ret, eq(and(mload(ptr), mask), needledata))
1644 ptr := sub(ptr, 1)
1645 jumpi(loop, gt(add(ptr, 1), selfptr))
1646 ptr := selfptr
1647 jump(exit)
1648 ret :
1649 ptr := add(ptr, needlelen)
1650 exit :
1651 }
1652 return ptr;
1653 } else {
1654 // For long needles, use hashing
1655 bytes32 hash;
1656 assembly {hash := sha3(needleptr, needlelen)}
1657 ptr = selfptr + (selflen - needlelen);
1658 while (ptr >= selfptr) {
1659 bytes32 testHash;
1660 assembly {testHash := sha3(ptr, needlelen)}
1661 if (hash == testHash)
1662 return ptr + needlelen;
1663 ptr -= 1;
1664 }
1665 }
1666 }
1667 return selfptr;
1668 }
1669 
1670 /*
1671  * @dev Modifies `self` to contain everything from the first occurrence of
1672  *      `needle` to the end of the slice. `self` is set to the empty slice
1673  *      if `needle` is not found.
1674  * @param self The slice to search and modify.
1675  * @param needle The text to search for.
1676  * @return `self`.
1677  */
1678 function find(slice self, slice needle) internal returns (slice) {
1679 uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1680 self._len -= ptr - self._ptr;
1681 self._ptr = ptr;
1682 return self;
1683 }
1684 
1685 /*
1686  * @dev Modifies `self` to contain the part of the string from the start of
1687  *      `self` to the end of the first occurrence of `needle`. If `needle`
1688  *      is not found, `self` is set to the empty slice.
1689  * @param self The slice to search and modify.
1690  * @param needle The text to search for.
1691  * @return `self`.
1692  */
1693 function rfind(slice self, slice needle) internal returns (slice) {
1694 uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1695 self._len = ptr - self._ptr;
1696 return self;
1697 }
1698 
1699 /*
1700  * @dev Splits the slice, setting `self` to everything after the first
1701  *      occurrence of `needle`, and `token` to everything before it. If
1702  *      `needle` does not occur in `self`, `self` is set to the empty slice,
1703  *      and `token` is set to the entirety of `self`.
1704  * @param self The slice to split.
1705  * @param needle The text to search for in `self`.
1706  * @param token An output parameter to which the first token is written.
1707  * @return `token`.
1708  */
1709 function split(slice self, slice needle, slice token) internal returns (slice) {
1710 uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1711 token._ptr = self._ptr;
1712 token._len = ptr - self._ptr;
1713 if (ptr == self._ptr + self._len) {
1714 // Not found
1715 self._len = 0;
1716 } else {
1717 self._len -= token._len + needle._len;
1718 self._ptr = ptr + needle._len;
1719 }
1720 return token;
1721 }
1722 
1723 /*
1724  * @dev Splits the slice, setting `self` to everything after the first
1725  *      occurrence of `needle`, and returning everything before it. If
1726  *      `needle` does not occur in `self`, `self` is set to the empty slice,
1727  *      and the entirety of `self` is returned.
1728  * @param self The slice to split.
1729  * @param needle The text to search for in `self`.
1730  * @return The part of `self` up to the first occurrence of `delim`.
1731  */
1732 function split(slice self, slice needle) internal returns (slice token) {
1733 split(self, needle, token);
1734 }
1735 
1736 /*
1737  * @dev Splits the slice, setting `self` to everything before the last
1738  *      occurrence of `needle`, and `token` to everything after it. If
1739  *      `needle` does not occur in `self`, `self` is set to the empty slice,
1740  *      and `token` is set to the entirety of `self`.
1741  * @param self The slice to split.
1742  * @param needle The text to search for in `self`.
1743  * @param token An output parameter to which the first token is written.
1744  * @return `token`.
1745  */
1746 function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1747 uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1748 token._ptr = ptr;
1749 token._len = self._len - (ptr - self._ptr);
1750 if (ptr == self._ptr) {
1751 // Not found
1752 self._len = 0;
1753 } else {
1754 self._len -= token._len + needle._len;
1755 }
1756 return token;
1757 }
1758 
1759 /*
1760  * @dev Splits the slice, setting `self` to everything before the last
1761  *      occurrence of `needle`, and returning everything after it. If
1762  *      `needle` does not occur in `self`, `self` is set to the empty slice,
1763  *      and the entirety of `self` is returned.
1764  * @param self The slice to split.
1765  * @param needle The text to search for in `self`.
1766  * @return The part of `self` after the last occurrence of `delim`.
1767  */
1768 function rsplit(slice self, slice needle) internal returns (slice token) {
1769 rsplit(self, needle, token);
1770 }
1771 
1772 /*
1773  * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1774  * @param self The slice to search.
1775  * @param needle The text to search for in `self`.
1776  * @return The number of occurrences of `needle` found in `self`.
1777  */
1778 function count(slice self, slice needle) internal returns (uint count) {
1779 uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1780 while (ptr <= self._ptr + self._len) {
1781 count++;
1782 ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1783 }
1784 }
1785 
1786 /*
1787  * @dev Returns True if `self` contains `needle`.
1788  * @param self The slice to search.
1789  * @param needle The text to search for in `self`.
1790  * @return True if `needle` is found in `self`, false otherwise.
1791  */
1792 function contains(slice self, slice needle) internal returns (bool) {
1793 return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1794 }
1795 
1796 /*
1797  * @dev Returns a newly allocated string containing the concatenation of
1798  *      `self` and `other`.
1799  * @param self The first slice to concatenate.
1800  * @param other The second slice to concatenate.
1801  * @return The concatenation of the two strings.
1802  */
1803 function concat(slice self, slice other) internal returns (string) {
1804 var ret = new string(self._len + other._len);
1805 uint retptr;
1806 assembly {retptr := add(ret, 32)}
1807 memcpy(retptr, self._ptr, self._len);
1808 memcpy(retptr + self._len, other._ptr, other._len);
1809 return ret;
1810 }
1811 
1812 /*
1813  * @dev Joins an array of slices, using `self` as a delimiter, returning a
1814  *      newly allocated string.
1815  * @param self The delimiter to use.
1816  * @param parts A list of slices to join.
1817  * @return A newly allocated string containing all the slices in `parts`,
1818  *         joined with `self`.
1819  */
1820 function join(slice self, slice[] parts) internal returns (string) {
1821 if (parts.length == 0)
1822 return "";
1823 
1824 uint len = self._len * (parts.length - 1);
1825 for (uint i = 0; i < parts.length; i++)
1826 len += parts[i]._len;
1827 
1828 var ret = new string(len);
1829 uint retptr;
1830 assembly {retptr := add(ret, 32)}
1831 
1832 for (i = 0; i < parts.length; i++) {
1833 memcpy(retptr, parts[i]._ptr, parts[i]._len);
1834 retptr += parts[i]._len;
1835 if (i < parts.length - 1) {
1836 memcpy(retptr, self._ptr, self._len);
1837 retptr += self._len;
1838 }
1839 }
1840 
1841 return ret;
1842 }
1843 }
1844 
1845 
1846 contract DSSafeAddSub {
1847 function safeAdd(uint a, uint b) internal returns (uint) {
1848 require(a + b >= a);
1849 return a + b;
1850 }
1851 
1852 function safeSub(uint a, uint b) internal returns (uint) {
1853 require(b <= a);
1854 return a - b;
1855 }
1856 }
1857 
1858 
1859 
1860 contract Swanroll is usingOraclize, DSSafeAddSub {
1861 
1862 using strings for *;
1863 
1864 /*
1865  * checks player profit, bet size and player number is within range
1866 */
1867 modifier betIsValid(uint _betSize, uint _playerNumber) {
1868 if (((((_betSize * (100- (safeSub(_playerNumber, 1)))) / (safeSub(_playerNumber, 1))+ _betSize)) * houseEdge / houseEdgeDivisor) -_betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber) require(false);
1869 _;
1870 }
1871 
1872 /*
1873  * checks game is currently active
1874 */
1875 modifier gameIsActive {
1876 require(gamePaused != true);
1877 _;
1878 }
1879 
1880 /*
1881  * checks payouts are currently active
1882 */
1883 modifier payoutsAreActive {
1884 require(payoutsPaused != true);
1885 _;
1886 }
1887 
1888 /*
1889  * checks only Oraclize address is calling
1890 */
1891 modifier onlyOraclize {
1892 require(msg.sender == oraclize_cbAddress());
1893 _;
1894 }
1895 
1896 /*
1897  * checks only owner address is calling
1898 */
1899 modifier onlyOwner {
1900 require(msg.sender == owner);
1901 _;
1902 }
1903 
1904 /*
1905  * checks only treasury address is calling
1906 */
1907 modifier onlyTreasury {
1908 require(msg.sender == treasury);
1909 _;
1910 }
1911 
1912 /*
1913  * game vars
1914 */
1915 uint constant public maxProfitDivisor = 1000000;
1916 uint constant public houseEdgeDivisor = 1000;
1917 uint constant public maxNumber = 99;
1918 uint constant public minNumber = 2;
1919 bool public gamePaused;
1920 uint32 public gasForOraclize;
1921 address public owner;
1922 bool public payoutsPaused;
1923 address public treasury;
1924 uint public contractBalance;
1925 uint public houseEdge;
1926 uint public maxProfit;
1927 uint public maxProfitAsPercentOfHouse;
1928 uint public minBet;
1929 //init dicontinued contract data
1930 int public totalBets = 0;
1931 uint public maxPendingPayouts;
1932 //init dicontinued contract data
1933 uint public totalWeiWon = 0;
1934 //init dicontinued contract data
1935 uint public totalWeiWagered = 0;
1936 
1937 /*
1938  * player vars
1939 */
1940 mapping (bytes32 => address) playerAddress;
1941 mapping (bytes32 => address) playerTempAddress;
1942 mapping (bytes32 => bytes32) playerBetId;
1943 mapping (bytes32 => uint) playerBetValue;
1944 mapping (bytes32 => uint) playerTempBetValue;
1945 mapping (bytes32 => uint) playerDieResult;
1946 mapping (bytes32 => uint) playerNumber;
1947 mapping (address => uint) playerPendingWithdrawals;
1948 mapping (bytes32 => uint) playerProfit;
1949 mapping (bytes32 => uint) playerTempReward;
1950 
1951 /*
1952  * events
1953 */
1954 /* log bets + output to web3 for precise 'payout on win' field in UI */
1955 event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint PlayerNumber);
1956 /* output to web3 UI on bet result*/
1957 /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
1958 event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint Value, int Status, bytes Proof);
1959 /* log manual refunds */
1960 event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
1961 /* log owner transfers */
1962 event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
1963 
1964 
1965 /*
1966  * init
1967 */
1968 function Swanroll() {
1969 
1970 owner = msg.sender;
1971 treasury = msg.sender;
1972 
1973 oraclize_setNetwork(networkID_auto);
1974 /* use TLSNotary for oraclize call */
1975 oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1976 /* init 990 = 99% (1% houseEdge)*/
1977 ownerSetHouseEdge(990);
1978 /* init 10,000 = 1%  */
1979 ownerSetMaxProfitAsPercentOfHouse(100000);
1980 /* init min bet (0.1 ether) */
1981 ownerSetMinBet(100000000000000000);
1982 /* init gas for oraclize */
1983 gasForOraclize = 250000;
1984 
1985 }
1986 
1987 /*
1988  * public function
1989  * player submit bet
1990  * only if game is active & bet is valid can query oraclize and set player vars
1991 */
1992 function playerRollDice(uint rollUnder) public
1993 payable
1994 gameIsActive
1995 betIsValid(msg.value, rollUnder)
1996 {
1997 
1998 
1999 /* safely update contract balance to account for cost to call oraclize*/
2000 contractBalance = safeSub(contractBalance, oraclize_getPrice("URL", gasForOraclize));
2001 
2002 /* total number of bets */
2003 totalBets += 1;
2004 
2005 /* total wagered */
2006 totalWeiWagered += msg.value;
2007 
2008 /*
2009 * assign partially encrypted query to oraclize
2010 * only the apiKey is encrypted
2011 * integer query is in plain text
2012 */
2013 bytes32 rngId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\",\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BGrEyTBBbqynciODlOSfcvhQtq+ps4kHXcjyYYgGafvG1nhI3pUBdNoJpGhgK6o5+NLthVFfYADo2UySRWMxgBQmcxTC0wxQXqJloPCPnOqZxClVn7DDrRu3BZBAD9MB5UFeGG7y5i2cOKle851A5WX3T0+q},\"n\":1,\"min\":1,\"max\":100,\"replacement\":true,\"base\":10${[identity] \"}\"},\"id\":1${[identity] \"}\"}']", gasForOraclize);
2014 
2015 /* map bet id to this oraclize query */
2016 playerBetId[rngId] = rngId;
2017 /* map player lucky number to this oraclize query */
2018 playerNumber[rngId] = rollUnder;
2019 /* map value of wager to this oraclize query */
2020 playerBetValue[rngId] = msg.value;
2021 /* map player address to this oraclize query */
2022 playerAddress[rngId] = msg.sender;
2023 /* safely map player profit to this oraclize query */
2024 playerProfit[rngId] = ((((msg.value * (100 - (safeSub(rollUnder, 1)))) / (safeSub(rollUnder,1)) + msg.value)) *houseEdge / houseEdgeDivisor) - msg.value;
2025 /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
2026 maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
2027 /* check contract can payout on win */
2028 require(maxPendingPayouts < contractBalance);
2029 /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
2030 LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2031 
2032 }
2033 
2034 
2035 /*
2036 * semi-public function - only oraclize can call
2037 */
2038 /*TLSNotary for oraclize call */
2039 function __callback(bytes32 myid, string result, bytes proof) public
2040 onlyOraclize
2041 payoutsAreActive
2042 {
2043 
2044 /* player address mapped to query id does not exist */
2045 require(playerAddress[myid] != 0x0);
2046 
2047 /* keep oraclize honest by retrieving the serialNumber from random.org result */
2048 var sl_result = result.toSlice();
2049 sl_result.beyond("[".toSlice()).until("]".toSlice());
2050 uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());
2051 
2052 /* map result to player */
2053 playerDieResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());
2054 
2055 /* get the playerAddress for this query id */
2056 playerTempAddress[myid] = playerAddress[myid];
2057 /* delete playerAddress for this query id */
2058 delete playerAddress[myid];
2059 
2060 /* map the playerProfit for this query id */
2061 playerTempReward[myid] = playerProfit[myid];
2062 /* set  playerProfit for this query id to 0 */
2063 playerProfit[myid] = 0;
2064 
2065 /* safely reduce maxPendingPayouts liability */
2066 maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);
2067 
2068 /* map the playerBetValue for this query id */
2069 playerTempBetValue[myid] = playerBetValue[myid];
2070 /* set  playerBetValue for this query id to 0 */
2071 playerBetValue[myid] = 0;
2072 
2073 /*
2074 * refund
2075 * if result is 0 result is empty or no proof refund original bet value
2076 * if refund fails save refund value to playerPendingWithdrawals
2077 */
2078 if (playerDieResult[myid]== 0 || bytes(result).length == 0 || bytes(proof).length == 0){
2079 
2080 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);
2081 
2082 /*
2083 * send refund - external call to an untrusted contract
2084 * if send fails map refund value to playerPendingWithdrawals[address]
2085 * for withdrawal later via playerWithdrawPendingTransactions
2086 */
2087 if (!playerTempAddress[myid].send(playerTempBetValue[myid])){
2088 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);
2089 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2090 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);
2091 }
2092 
2093 return;
2094 }
2095 
2096 /*
2097 * pay winner
2098 * update contract balance to calculate new max bet
2099 * send reward
2100 * if send of reward fails save value to playerPendingWithdrawals
2101 */
2102 if (playerDieResult[myid] < playerNumber[myid]){
2103 
2104 /* safely reduce contract balance by player profit */
2105 contractBalance = safeSub(contractBalance, playerTempReward[myid]);
2106 
2107 /* update total wei won */
2108 totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);
2109 
2110 /* safely calculate payout via profit plus original wager */
2111 playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]);
2112 
2113 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);
2114 
2115 /* update maximum profit */
2116 setMaxProfit();
2117 
2118 /*
2119 * send win - external call to an untrusted contract
2120 * if send fails map reward value to playerPendingWithdrawals[address]
2121 * for withdrawal later via playerWithdrawPendingTransactions
2122 */
2123 if (!playerTempAddress[myid].send(playerTempReward[myid])){
2124 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);
2125 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2126 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);
2127 }
2128 
2129 return;
2130 
2131 }
2132 
2133 /*
2134 * no win
2135 * send 1 wei to a losing bet
2136 * update contract balance to calculate new max bet
2137 */
2138 if (playerDieResult[myid] >= playerNumber[myid]){
2139 
2140 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumber[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);
2141 
2142 /*
2143 *  safe adjust contractBalance
2144 *  setMaxProfit
2145 *  send 1 wei to losing bet
2146 */
2147 contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid] - 1));
2148 
2149 /* update maximum profit */
2150 setMaxProfit();
2151 
2152 /*
2153 * send 1 wei - external call to an untrusted contract
2154 */
2155 if (!playerTempAddress[myid].send(1)){
2156 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2157 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);
2158 }
2159 
2160 return;
2161 
2162 }
2163 
2164 }
2165 
2166 /*
2167 * public function
2168 * in case of a failed refund or win send
2169 */
2170 function playerWithdrawPendingTransactions() public
2171 payoutsAreActive
2172 returns (bool)
2173 {
2174 uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2175 playerPendingWithdrawals[msg.sender] = 0;
2176 /* external call to untrusted contract */
2177 if (msg.sender.call.value(withdrawAmount)()) {
2178 return true;
2179 } else {
2180 /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2181 /* player can try to withdraw again later */
2182 playerPendingWithdrawals[msg.sender] = withdrawAmount;
2183 return false;
2184 }
2185 }
2186 
2187 /* check for pending withdrawals  */
2188 function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2189 return playerPendingWithdrawals[addressToCheck];
2190 }
2191 
2192 /*
2193 * internal function
2194 * sets max profit
2195 */
2196 function setMaxProfit() internal {
2197 maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
2198 }
2199 
2200 /*
2201 * owner/treasury address only functions
2202 */
2203 function ()
2204 payable
2205 onlyTreasury
2206 {
2207 /* safely update contract balance */
2208 contractBalance = safeAdd(contractBalance, msg.value);
2209 /* update the maximum profit */
2210 setMaxProfit();
2211 }
2212 
2213 /* set gas for oraclize query */
2214 function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public
2215 onlyOwner
2216 {
2217 gasForOraclize = newSafeGasToOraclize;
2218 }
2219 
2220 /* only owner adjust contract balance variable (only used for max profit calc) */
2221 function ownerUpdateContractBalance(uint newContractBalanceInWei) public
2222 onlyOwner
2223 {
2224 contractBalance = newContractBalanceInWei;
2225 }
2226 
2227 /* only owner address can set houseEdge */
2228 function ownerSetHouseEdge(uint newHouseEdge) public
2229 onlyOwner
2230 {
2231 houseEdge = newHouseEdge;
2232 }
2233 
2234 /* only owner address can set maxProfitAsPercentOfHouse */
2235 function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
2236 onlyOwner
2237 {
2238 /* restrict each bet to a maximum profit of 10% contractBalance */
2239 require(newMaxProfitAsPercent <= 100000);
2240 maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
2241 setMaxProfit();
2242 }
2243 
2244 /* only owner address can set minBet */
2245 function ownerSetMinBet(uint newMinimumBet) public
2246 onlyOwner
2247 {
2248 minBet = newMinimumBet;
2249 }
2250 
2251 /* only owner address can transfer ether */
2252 function ownerTransferEther(address sendTo, uint amount) public
2253 onlyOwner
2254 {
2255 /* safely update contract balance when sending out funds*/
2256 contractBalance = safeSub(contractBalance, amount);
2257 /* update max profit */
2258 setMaxProfit();
2259 require(sendTo.send(amount));
2260 LogOwnerTransfer(sendTo, amount);
2261 }
2262 
2263 /* only owner address can do manual refund
2264 * used only if bet placed + oraclize failed to __callback
2265 * filter LogBet by address and/or playerBetId:
2266 * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2267 * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2268 * LogResult or LogRefund
2269 * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions
2270 */
2271 function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public
2272 onlyOwner
2273 {
2274 /* safely reduce pendingPayouts by playerProfit[rngId] */
2275 maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
2276 /* send refund */
2277 require(sendTo.send(originalPlayerBetValue));
2278 /* log refunds */
2279 LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);
2280 }
2281 
2282 /* only owner address can set emergency pause #1 */
2283 function ownerPauseGame(bool newStatus) public
2284 onlyOwner
2285 {
2286 gamePaused = newStatus;
2287 }
2288 
2289 /* only owner address can set emergency pause #2 */
2290 function ownerPausePayouts(bool newPayoutStatus) public
2291 onlyOwner
2292 {
2293 payoutsPaused = newPayoutStatus;
2294 }
2295 
2296 /* only owner address can set treasury address */
2297 function ownerSetTreasury(address newTreasury) public
2298 onlyOwner
2299 {
2300 treasury = newTreasury;
2301 }
2302 
2303 /* only owner address can set owner address */
2304 function ownerChangeOwner(address newOwner) public
2305 onlyOwner
2306 {
2307 owner = newOwner;
2308 }
2309 
2310 /* only owner address can suicide - emergency */
2311 function ownerkill() public
2312 onlyOwner
2313 {
2314 suicide(owner);
2315 }
2316 
2317 
2318 }