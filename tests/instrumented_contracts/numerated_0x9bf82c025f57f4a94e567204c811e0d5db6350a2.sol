1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
32 pragma solidity ^0.4.18;
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
40     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
41     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
42     function getPrice(string _datasource) public returns (uint _dsprice);
43     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
44     function setProofType(byte _proofType) external;
45     function setCustomGasPrice(uint _gasPrice) external;
46     function randomDS_getSessionPubKeyHash() external constant returns (bytes32);
47 }
48 
49 contract OraclizeAddrResolverI {
50     function getAddress() public returns (address _addr);
51 }
52 
53 contract usingOraclize {
54     uint constant day = 60 * 60 * 24;
55     uint constant week = 60 * 60 * 24 * 7;
56     uint constant month = 60 * 60 * 24 * 30;
57     byte constant proofType_NONE = 0x00;
58     byte constant proofType_TLSNotary = 0x10;
59     byte constant proofType_Android = 0x20;
60     byte constant proofType_Ledger = 0x30;
61     byte constant proofType_Native = 0xF0;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_auto = 0;
64     uint8 constant networkID_mainnet = 1;
65     uint8 constant networkID_testnet = 2;
66     uint8 constant networkID_morden = 2;
67     uint8 constant networkID_consensys = 161;
68 
69     OraclizeAddrResolverI OAR;
70 
71     OraclizeI oraclize;
72     modifier oraclizeAPI {
73         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
74             oraclize_setNetwork(networkID_auto);
75 
76         if (address(oraclize) != OAR.getAddress())
77             oraclize = OraclizeI(OAR.getAddress());
78 
79         _;
80     }
81     modifier coupon(string code){
82         oraclize = OraclizeI(OAR.getAddress());
83         _;
84     }
85 
86     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
87         return oraclize_setNetwork();
88         networkID;
89         // silence the warning and remain backwards compatible
90     }
91 
92     function oraclize_setNetwork() internal returns (bool){
93         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
94             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
95             oraclize_setNetworkName("eth_mainnet");
96             return true;
97         }
98         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
99             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
100             oraclize_setNetworkName("eth_ropsten3");
101             return true;
102         }
103         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
104             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
105             oraclize_setNetworkName("eth_kovan");
106             return true;
107         }
108         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
109             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
110             oraclize_setNetworkName("eth_rinkeby");
111             return true;
112         }
113         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
114             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
115             return true;
116         }
117         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
118             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
119             return true;
120         }
121         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
122             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
123             return true;
124         }
125         return false;
126     }
127 
128     function __callback(bytes32 myid, string result) public {
129         __callback(myid, result, new bytes(0));
130     }
131 
132     function __callback(bytes32 myid, string result, bytes proof) public {
133         return;
134         myid;
135         result;
136         proof;
137         // Silence compiler warnings
138     }
139 
140     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
141         return oraclize.getPrice(datasource);
142     }
143 
144     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
145         return oraclize.getPrice(datasource, gaslimit);
146     }
147 
148     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource);
150         if (price > 1 ether + tx.gasprice * 200000) return 0;
151         // unexpectedly high price
152         return oraclize.query.value(price)(0, datasource, arg);
153     }
154 
155     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource);
157         if (price > 1 ether + tx.gasprice * 200000) return 0;
158         // unexpectedly high price
159         return oraclize.query.value(price)(timestamp, datasource, arg);
160     }
161 
162     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
163         uint price = oraclize.getPrice(datasource, gaslimit);
164         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
165         // unexpectedly high price
166         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
167     }
168 
169     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource, gaslimit);
171         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
172         // unexpectedly high price
173         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
174     }
175 
176     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
177         uint price = oraclize.getPrice(datasource);
178         if (price > 1 ether + tx.gasprice * 200000) return 0;
179         // unexpectedly high price
180         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
181     }
182 
183     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
184         uint price = oraclize.getPrice(datasource);
185         if (price > 1 ether + tx.gasprice * 200000) return 0;
186         // unexpectedly high price
187         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
188     }
189 
190     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
191         uint price = oraclize.getPrice(datasource, gaslimit);
192         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
193         // unexpectedly high price
194         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
195     }
196 
197     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
198         uint price = oraclize.getPrice(datasource, gaslimit);
199         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
200         // unexpectedly high price
201         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
202     }
203 
204     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
205         uint price = oraclize.getPrice(datasource);
206         if (price > 1 ether + tx.gasprice * 200000) return 0;
207         // unexpectedly high price
208         bytes memory args = stra2cbor(argN);
209         return oraclize.queryN.value(price)(0, datasource, args);
210     }
211 
212     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
213         uint price = oraclize.getPrice(datasource);
214         if (price > 1 ether + tx.gasprice * 200000) return 0;
215         // unexpectedly high price
216         bytes memory args = stra2cbor(argN);
217         return oraclize.queryN.value(price)(timestamp, datasource, args);
218     }
219 
220     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
221         uint price = oraclize.getPrice(datasource, gaslimit);
222         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
223         // unexpectedly high price
224         bytes memory args = stra2cbor(argN);
225         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
226     }
227 
228     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
229         uint price = oraclize.getPrice(datasource, gaslimit);
230         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
231         // unexpectedly high price
232         bytes memory args = stra2cbor(argN);
233         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
234     }
235 
236     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
237         string[] memory dynargs = new string[](1);
238         dynargs[0] = args[0];
239         return oraclize_query(datasource, dynargs);
240     }
241 
242     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
243         string[] memory dynargs = new string[](1);
244         dynargs[0] = args[0];
245         return oraclize_query(timestamp, datasource, dynargs);
246     }
247 
248     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
249         string[] memory dynargs = new string[](1);
250         dynargs[0] = args[0];
251         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
252     }
253 
254     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](1);
256         dynargs[0] = args[0];
257         return oraclize_query(datasource, dynargs, gaslimit);
258     }
259 
260     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
261         string[] memory dynargs = new string[](2);
262         dynargs[0] = args[0];
263         dynargs[1] = args[1];
264         return oraclize_query(datasource, dynargs);
265     }
266 
267     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](2);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         return oraclize_query(timestamp, datasource, dynargs);
272     }
273 
274     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
275         string[] memory dynargs = new string[](2);
276         dynargs[0] = args[0];
277         dynargs[1] = args[1];
278         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
279     }
280 
281     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](2);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         return oraclize_query(datasource, dynargs, gaslimit);
286     }
287 
288     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
289         string[] memory dynargs = new string[](3);
290         dynargs[0] = args[0];
291         dynargs[1] = args[1];
292         dynargs[2] = args[2];
293         return oraclize_query(datasource, dynargs);
294     }
295 
296     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](3);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         return oraclize_query(timestamp, datasource, dynargs);
302     }
303 
304     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](3);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
310     }
311 
312     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
313         string[] memory dynargs = new string[](3);
314         dynargs[0] = args[0];
315         dynargs[1] = args[1];
316         dynargs[2] = args[2];
317         return oraclize_query(datasource, dynargs, gaslimit);
318     }
319 
320     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
321         string[] memory dynargs = new string[](4);
322         dynargs[0] = args[0];
323         dynargs[1] = args[1];
324         dynargs[2] = args[2];
325         dynargs[3] = args[3];
326         return oraclize_query(datasource, dynargs);
327     }
328 
329     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
330         string[] memory dynargs = new string[](4);
331         dynargs[0] = args[0];
332         dynargs[1] = args[1];
333         dynargs[2] = args[2];
334         dynargs[3] = args[3];
335         return oraclize_query(timestamp, datasource, dynargs);
336     }
337 
338     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
339         string[] memory dynargs = new string[](4);
340         dynargs[0] = args[0];
341         dynargs[1] = args[1];
342         dynargs[2] = args[2];
343         dynargs[3] = args[3];
344         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
345     }
346 
347     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](4);
349         dynargs[0] = args[0];
350         dynargs[1] = args[1];
351         dynargs[2] = args[2];
352         dynargs[3] = args[3];
353         return oraclize_query(datasource, dynargs, gaslimit);
354     }
355 
356     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
357         string[] memory dynargs = new string[](5);
358         dynargs[0] = args[0];
359         dynargs[1] = args[1];
360         dynargs[2] = args[2];
361         dynargs[3] = args[3];
362         dynargs[4] = args[4];
363         return oraclize_query(datasource, dynargs);
364     }
365 
366     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
367         string[] memory dynargs = new string[](5);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         dynargs[2] = args[2];
371         dynargs[3] = args[3];
372         dynargs[4] = args[4];
373         return oraclize_query(timestamp, datasource, dynargs);
374     }
375 
376     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
377         string[] memory dynargs = new string[](5);
378         dynargs[0] = args[0];
379         dynargs[1] = args[1];
380         dynargs[2] = args[2];
381         dynargs[3] = args[3];
382         dynargs[4] = args[4];
383         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
384     }
385 
386     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
387         string[] memory dynargs = new string[](5);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         dynargs[2] = args[2];
391         dynargs[3] = args[3];
392         dynargs[4] = args[4];
393         return oraclize_query(datasource, dynargs, gaslimit);
394     }
395 
396     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource);
398         if (price > 1 ether + tx.gasprice * 200000) return 0;
399         // unexpectedly high price
400         bytes memory args = ba2cbor(argN);
401         return oraclize.queryN.value(price)(0, datasource, args);
402     }
403 
404     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource);
406         if (price > 1 ether + tx.gasprice * 200000) return 0;
407         // unexpectedly high price
408         bytes memory args = ba2cbor(argN);
409         return oraclize.queryN.value(price)(timestamp, datasource, args);
410     }
411 
412     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource, gaslimit);
414         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
415         // unexpectedly high price
416         bytes memory args = ba2cbor(argN);
417         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
418     }
419 
420     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource, gaslimit);
422         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
423         // unexpectedly high price
424         bytes memory args = ba2cbor(argN);
425         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
426     }
427 
428     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](1);
430         dynargs[0] = args[0];
431         return oraclize_query(datasource, dynargs);
432     }
433 
434     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](1);
436         dynargs[0] = args[0];
437         return oraclize_query(timestamp, datasource, dynargs);
438     }
439 
440     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         bytes[] memory dynargs = new bytes[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
444     }
445 
446     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         bytes[] memory dynargs = new bytes[](1);
448         dynargs[0] = args[0];
449         return oraclize_query(datasource, dynargs, gaslimit);
450     }
451 
452     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](2);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         return oraclize_query(datasource, dynargs);
457     }
458 
459     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
460         bytes[] memory dynargs = new bytes[](2);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         return oraclize_query(timestamp, datasource, dynargs);
464     }
465 
466     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](2);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
471     }
472 
473     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         bytes[] memory dynargs = new bytes[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(datasource, dynargs, gaslimit);
478     }
479 
480     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
481         bytes[] memory dynargs = new bytes[](3);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         dynargs[2] = args[2];
485         return oraclize_query(datasource, dynargs);
486     }
487 
488     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
489         bytes[] memory dynargs = new bytes[](3);
490         dynargs[0] = args[0];
491         dynargs[1] = args[1];
492         dynargs[2] = args[2];
493         return oraclize_query(timestamp, datasource, dynargs);
494     }
495 
496     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         bytes[] memory dynargs = new bytes[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503 
504     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         bytes[] memory dynargs = new bytes[](3);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511 
512     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](4);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         return oraclize_query(datasource, dynargs);
519     }
520 
521     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
522         bytes[] memory dynargs = new bytes[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(timestamp, datasource, dynargs);
528     }
529 
530     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
531         bytes[] memory dynargs = new bytes[](4);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538 
539     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         bytes[] memory dynargs = new bytes[](4);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         dynargs[3] = args[3];
545         return oraclize_query(datasource, dynargs, gaslimit);
546     }
547 
548     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
549         bytes[] memory dynargs = new bytes[](5);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         dynargs[4] = args[4];
555         return oraclize_query(datasource, dynargs);
556     }
557 
558     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
559         bytes[] memory dynargs = new bytes[](5);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         dynargs[4] = args[4];
565         return oraclize_query(timestamp, datasource, dynargs);
566     }
567 
568     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         bytes[] memory dynargs = new bytes[](5);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         dynargs[4] = args[4];
575         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576     }
577 
578     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](5);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         dynargs[4] = args[4];
585         return oraclize_query(datasource, dynargs, gaslimit);
586     }
587 
588     function oraclize_cbAddress() oraclizeAPI internal returns (address){
589         return oraclize.cbAddress();
590     }
591 
592     function oraclize_setProof(byte proofP) oraclizeAPI internal {
593         return oraclize.setProofType(proofP);
594     }
595 
596     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
597         return oraclize.setCustomGasPrice(gasPrice);
598     }
599 
600     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
601         return oraclize.randomDS_getSessionPubKeyHash();
602     }
603 
604     function getCodeSize(address _addr) constant internal returns (uint _size) {
605         assembly {
606             _size := extcodesize(_addr)
607         }
608     }
609 
610     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
611         bytes memory _ba = bytes(_a);
612         bytes memory _bb = bytes(_b);
613         bytes memory _bc = bytes(_c);
614         bytes memory _bd = bytes(_d);
615         bytes memory _be = bytes(_e);
616         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
617         bytes memory babcde = bytes(abcde);
618         uint k = 0;
619         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
620         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
621         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
622         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
623         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
624         return string(babcde);
625     }
626 
627     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
628         return strConcat(_a, _b, _c, _d, "");
629     }
630 
631     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
632         return strConcat(_a, _b, _c, "", "");
633     }
634 
635     function strConcat(string _a, string _b) internal pure returns (string) {
636         return strConcat(_a, _b, "", "", "");
637     }
638 
639     // parseInt
640     function parseInt(string _a) internal pure returns (uint) {
641         return parseInt(_a, 0);
642     }
643 
644     // parseInt(parseFloat*10^_b)
645     function parseInt(string _a, uint _b) internal pure returns (uint) {
646         bytes memory bresult = bytes(_a);
647         uint mint = 0;
648         bool decimals = false;
649         for (uint i = 0; i < bresult.length; i++) {
650             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
651                 if (decimals) {
652                     if (_b == 0) break;
653                     else _b--;
654                 }
655                 mint *= 10;
656                 mint += uint(bresult[i]) - 48;
657             } else if (bresult[i] == 46) decimals = true;
658         }
659         if (_b > 0) mint *= 10 ** _b;
660         return mint;
661     }
662 
663     function stra2cbor(string[] arr) internal pure returns (bytes) {
664         uint arrlen = arr.length;
665 
666         // get correct cbor output length
667         uint outputlen = 0;
668         bytes[] memory elemArray = new bytes[](arrlen);
669         for (uint i = 0; i < arrlen; i++) {
670             elemArray[i] = (bytes(arr[i]));
671             outputlen += elemArray[i].length + (elemArray[i].length - 1) / 23 + 3;
672             //+3 accounts for paired identifier types
673         }
674         uint ctr = 0;
675         uint cborlen = arrlen + 0x80;
676         outputlen += byte(cborlen).length;
677         bytes memory res = new bytes(outputlen);
678 
679         while (byte(cborlen).length > ctr) {
680             res[ctr] = byte(cborlen)[ctr];
681             ctr++;
682         }
683         for (i = 0; i < arrlen; i++) {
684             res[ctr] = 0x5F;
685             ctr++;
686             for (uint x = 0; x < elemArray[i].length; x++) {
687                 // if there's a bug with larger strings, this may be the culprit
688                 if (x % 23 == 0) {
689                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
690                     elemcborlen += 0x40;
691                     uint lctr = ctr;
692                     while (byte(elemcborlen).length > ctr - lctr) {
693                         res[ctr] = byte(elemcborlen)[ctr - lctr];
694                         ctr++;
695                     }
696                 }
697                 res[ctr] = elemArray[i][x];
698                 ctr++;
699             }
700             res[ctr] = 0xFF;
701             ctr++;
702         }
703         return res;
704     }
705 
706     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
707         uint arrlen = arr.length;
708 
709         // get correct cbor output length
710         uint outputlen = 0;
711         bytes[] memory elemArray = new bytes[](arrlen);
712         for (uint i = 0; i < arrlen; i++) {
713             elemArray[i] = (bytes(arr[i]));
714             outputlen += elemArray[i].length + (elemArray[i].length - 1) / 23 + 3;
715             //+3 accounts for paired identifier types
716         }
717         uint ctr = 0;
718         uint cborlen = arrlen + 0x80;
719         outputlen += byte(cborlen).length;
720         bytes memory res = new bytes(outputlen);
721 
722         while (byte(cborlen).length > ctr) {
723             res[ctr] = byte(cborlen)[ctr];
724             ctr++;
725         }
726         for (i = 0; i < arrlen; i++) {
727             res[ctr] = 0x5F;
728             ctr++;
729             for (uint x = 0; x < elemArray[i].length; x++) {
730                 // if there's a bug with larger strings, this may be the culprit
731                 if (x % 23 == 0) {
732                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
733                     elemcborlen += 0x40;
734                     uint lctr = ctr;
735                     while (byte(elemcborlen).length > ctr - lctr) {
736                         res[ctr] = byte(elemcborlen)[ctr - lctr];
737                         ctr++;
738                     }
739                 }
740                 res[ctr] = elemArray[i][x];
741                 ctr++;
742             }
743             res[ctr] = 0xFF;
744             ctr++;
745         }
746         return res;
747     }
748 
749 
750     string oraclize_network_name;
751 
752     function oraclize_setNetworkName(string _network_name) internal {
753         oraclize_network_name = _network_name;
754     }
755 
756     function oraclize_getNetworkName() internal view returns (string) {
757         return oraclize_network_name;
758     }
759 
760     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
761         require((_nbytes > 0) && (_nbytes <= 32));
762         bytes memory nbytes = new bytes(1);
763         nbytes[0] = byte(_nbytes);
764         bytes memory unonce = new bytes(32);
765         bytes memory sessionKeyHash = new bytes(32);
766         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
767         assembly {
768             mstore(unonce, 0x20)
769             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
770             mstore(sessionKeyHash, 0x20)
771             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
772         }
773         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
774         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
775         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
776         return queryId;
777     }
778 
779     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
780         oraclize_randomDS_args[queryId] = commitment;
781     }
782 
783     mapping(bytes32 => bytes32) oraclize_randomDS_args;
784     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
785 
786     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
787         bool sigok;
788         address signer;
789 
790         bytes32 sigr;
791         bytes32 sigs;
792 
793         bytes memory sigr_ = new bytes(32);
794         uint offset = 4 + (uint(dersig[3]) - 0x20);
795         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
796         bytes memory sigs_ = new bytes(32);
797         offset += 32 + 2;
798         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
799 
800         assembly {
801             sigr := mload(add(sigr_, 32))
802             sigs := mload(add(sigs_, 32))
803         }
804 
805 
806         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
807         if (address(keccak256(pubkey)) == signer) return true;
808         else {
809             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
810             return (address(keccak256(pubkey)) == signer);
811         }
812     }
813 
814     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
815         bool sigok;
816 
817         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
818         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
819         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
820 
821         bytes memory appkey1_pubkey = new bytes(64);
822         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
823 
824         bytes memory tosign2 = new bytes(1 + 65 + 32);
825         tosign2[0] = byte(1);
826         //role
827         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
828         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
829         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
830         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
831 
832         if (sigok == false) return false;
833 
834 
835         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
836         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
837 
838         bytes memory tosign3 = new bytes(1 + 65);
839         tosign3[0] = 0xFE;
840         copyBytes(proof, 3, 65, tosign3, 1);
841 
842         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
843         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
844 
845         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
846 
847         return sigok;
848     }
849 
850     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
851         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
852         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
853 
854         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
855         require(proofVerified);
856 
857         _;
858     }
859 
860     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
861         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
862         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) return 1;
863 
864         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
865         if (proofVerified == false) return 2;
866 
867         return 0;
868     }
869 
870     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool){
871         bool match_ = true;
872 
873         for (uint256 i = 0; i < prefix.length; i++) {
874             if (content[i] != prefix[i]) match_ = false;
875         }
876 
877         return match_;
878     }
879 
880     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
881         bool checkok;
882 
883 
884         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
885         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
886         bytes memory keyhash = new bytes(32);
887         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
888         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
889         if (checkok == false) return false;
890 
891         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
892         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
893 
894 
895         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
896         checkok = matchBytes32Prefix(sha256(sig1), result);
897         if (checkok == false) return false;
898 
899 
900         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
901         // This is to verify that the computed args match with the ones specified in the query.
902         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
903         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
904 
905         bytes memory sessionPubkey = new bytes(64);
906         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
907         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
908 
909         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
910         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
911             delete oraclize_randomDS_args[queryId];
912         } else return false;
913 
914 
915         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
916         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
917         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
918         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
919         if (checkok == false) return false;
920 
921         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
922         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
923             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
924         }
925 
926         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
927     }
928 
929 
930     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
931     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
932         uint minLength = length + toOffset;
933 
934         // Buffer too small
935         require(to.length >= minLength);
936         // Should be a better way?
937 
938         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
939         uint i = 32 + fromOffset;
940         uint j = 32 + toOffset;
941 
942         while (i < (32 + fromOffset + length)) {
943             assembly {
944                 let tmp := mload(add(from, i))
945                 mstore(add(to, j), tmp)
946             }
947             i += 32;
948             j += 32;
949         }
950 
951         return to;
952     }
953 
954     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
955     // Duplicate Solidity's ecrecover, but catching the CALL return value
956     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
957         bool ret;
958         address addr;
959 
960         assembly {
961             let size := mload(0x40)
962             mstore(size, hash)
963             mstore(add(size, 32), v)
964             mstore(add(size, 64), r)
965             mstore(add(size, 96), s)
966 
967         // NOTE: we can reuse the request memory because we deal with
968         //       the return code
969             ret := call(3000, 1, 0, size, 128, size, 32)
970             addr := mload(size)
971         }
972 
973         return (ret, addr);
974     }
975 
976     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
977     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
978         bytes32 r;
979         bytes32 s;
980         uint8 v;
981 
982         if (sig.length != 65)
983             return (false, 0);
984 
985         // The signature format is a compact form of:
986         //   {bytes32 r}{bytes32 s}{uint8 v}
987         // Compact means, uint8 is not padded to 32 bytes.
988         assembly {
989             r := mload(add(sig, 32))
990             s := mload(add(sig, 64))
991 
992         // Here we are loading the last 32 bytes. We exploit the fact that
993         // 'mload' will pad with zeroes if we overread.
994         // There is no 'mload8' to do this, but that would be nicer.
995             v := byte(0, mload(add(sig, 96)))
996 
997         // Alternative solution:
998         // 'byte' is not working due to the Solidity parser, so lets
999         // use the second best option, 'and'
1000         // v := and(mload(add(sig, 65)), 255)
1001         }
1002 
1003         // albeit non-transactional signatures are not specified by the YP, one would expect it
1004         // to match the YP range of [27, 28]
1005         //
1006         // geth uses [0, 1] and some clients have followed. This might change, see:
1007         //  https://github.com/ethereum/go-ethereum/issues/2053
1008         if (v < 27)
1009             v += 27;
1010 
1011         if (v != 27 && v != 28)
1012             return (false, 0);
1013 
1014         return safer_ecrecover(hash, v, r, s);
1015     }
1016 
1017 }
1018 // </ORACLIZE_API>
1019 
1020 
1021 /*
1022  * @title String & slice utility library for Solidity contracts.
1023  * @author Nick Johnson <arachnid@notdot.net>
1024  */
1025 
1026 pragma solidity ^0.4.14;
1027 
1028 library strings {
1029     struct slice {
1030         uint _len;
1031         uint _ptr;
1032     }
1033 
1034     function memcpy(uint dest, uint src, uint len) private {
1035         // Copy word-length chunks while possible
1036         for (; len >= 32; len -= 32) {
1037             assembly {
1038                 mstore(dest, mload(src))
1039             }
1040             dest += 32;
1041             src += 32;
1042         }
1043 
1044         // Copy remaining bytes
1045         uint mask = 256 ** (32 - len) - 1;
1046         assembly {
1047             let srcpart := and(mload(src), not(mask))
1048             let destpart := and(mload(dest), mask)
1049             mstore(dest, or(destpart, srcpart))
1050         }
1051     }
1052 
1053     function toSlice(string self) internal returns (slice) {
1054         uint ptr;
1055         assembly {
1056             ptr := add(self, 0x20)
1057         }
1058         return slice(bytes(self).length, ptr);
1059     }
1060     
1061     function copy(slice self) internal returns (slice) {
1062         return slice(self._len, self._ptr);
1063     }
1064 
1065     function toString(slice self) internal returns (string) {
1066         var ret = new string(self._len);
1067         uint retptr;
1068         assembly {retptr := add(ret, 32)}
1069 
1070         memcpy(retptr, self._ptr, self._len);
1071         return ret;
1072     }
1073     
1074     function beyond(slice self, slice needle) internal returns (slice) {
1075         if (self._len < needle._len) {
1076             return self;
1077         }
1078 
1079         bool equal = true;
1080         if (self._ptr != needle._ptr) {
1081             assembly {
1082                 let length := mload(needle)
1083                 let selfptr := mload(add(self, 0x20))
1084                 let needleptr := mload(add(needle, 0x20))
1085                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1086             }
1087         }
1088 
1089         if (equal) {
1090             self._len -= needle._len;
1091             self._ptr += needle._len;
1092         }
1093 
1094         return self;
1095     }
1096 
1097     function until(slice self, slice needle) internal returns (slice) {
1098         if (self._len < needle._len) {
1099             return self;
1100         }
1101 
1102         var selfptr = self._ptr + self._len - needle._len;
1103         bool equal = true;
1104         if (selfptr != needle._ptr) {
1105             assembly {
1106                 let length := mload(needle)
1107                 let needleptr := mload(add(needle, 0x20))
1108                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1109             }
1110         }
1111 
1112         if (equal) {
1113             self._len -= needle._len;
1114         }
1115 
1116         return self;
1117     }
1118 
1119     // Returns the memory address of the first byte of the first occurrence of
1120     // `needle` in `self`, or the first byte after `self` if not found.
1121     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1122         uint ptr;
1123         uint idx;
1124 
1125         if (needlelen <= selflen) {
1126             if (needlelen <= 32) {
1127                 // Optimized assembly for 68 gas per byte on short strings
1128                 assembly {
1129                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1130                     let needledata := and(mload(needleptr), mask)
1131                     let end := add(selfptr, sub(selflen, needlelen))
1132                     ptr := selfptr
1133                     loop :
1134                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1135                     ptr := add(ptr, 1)
1136                     jumpi(loop, lt(sub(ptr, 1), end))
1137                     ptr := add(selfptr, selflen)
1138                     exit :
1139                 }
1140                 return ptr;
1141             } else {
1142                 // For long needles, use hashing
1143                 bytes32 hash;
1144                 assembly {hash := sha3(needleptr, needlelen)}
1145                 ptr = selfptr;
1146                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1147                     bytes32 testHash;
1148                     assembly {testHash := sha3(ptr, needlelen)}
1149                     if (hash == testHash)
1150                         return ptr;
1151                     ptr += 1;
1152                 }
1153             }
1154         }
1155         return selfptr + selflen;
1156     }
1157 
1158     function split(slice self, slice needle, slice token) internal returns (slice) {
1159         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1160         token._ptr = self._ptr;
1161         token._len = ptr - self._ptr;
1162         if (ptr == self._ptr + self._len) {
1163             // Not found
1164             self._len = 0;
1165         } else {
1166             self._len -= token._len + needle._len;
1167             self._ptr = ptr + needle._len;
1168         }
1169         return token;
1170     }
1171     
1172     function split(slice self, slice needle) internal returns (slice token) {
1173         split(self, needle, token);
1174     }
1175 }
1176 
1177 contract CryptoLotto is usingOraclize {
1178     using strings for *;
1179 
1180     address Owner;
1181 
1182     uint public constant lottoPrice = 10 finney;
1183     uint public constant duration = 1 days;
1184 
1185     uint8 public constant lottoLength = 6;
1186     uint8 public constant lottoLowestNumber = 1;
1187     uint8 public constant lottoHighestNumber = 15;
1188 
1189     uint8 public constant sixMatchPayoutInPercent = 77;
1190     uint8 public constant bonusMatchPayoutInPercent = 11;
1191     uint8 public constant fiveMatchPayoutInPercent = 11;
1192     uint8 public constant ownerShareInPercent = 1;
1193     uint8 public constant numTurnsToRevolve = 10;
1194 
1195     string constant oraclizedQuery = "Sort[randomsample [range [1, 15], 7]], randomsample [range [0, 6], 1]";
1196     string constant oraclizedQuerySource = "WolframAlpha";
1197 
1198     bool public isLottoStarted = false;
1199     uint32 public turn = 0;
1200     uint32 public gasForOraclizedQuery = 600000;
1201     uint256 public raisedAmount = 0;
1202 
1203     uint8[] lottoNumbers = new uint8[](lottoLength);
1204     uint8 bonusNumber;
1205     enum lottoRank {NONCE, FIVE_MATCH, BONUS_MATCH, SIX_MATCH, DEFAULT}
1206     uint256 public finishWhen;
1207     uint256[] bettings;
1208     uint256[] accNumBettings;
1209     mapping(address => mapping(uint32 => uint64[])) tickets;
1210 
1211     uint256[] public raisedAmounts;
1212     uint256[] public untakenPrizeAmounts;
1213     uint32[] encodedLottoResults;
1214     uint32[] numFiveMatchWinners;
1215     uint32[] numBonusMatchWinners;
1216     uint32[] numSixMatchWinners;
1217     uint32[] nonces;
1218 
1219     uint64[] public timestamps;
1220 
1221     bytes32 oracleCallbackId;
1222 
1223     event LottoStart(uint32 turn);
1224     event FundRaised(address buyer, uint256 value, uint256 raisedAmount);
1225     event LottoNumbersAnnounced(uint8[] lottoNumbers, uint8 bonusNumber, uint256 raisedAmount, uint32 numFiveMatchWinners, uint32 numBonusMatchWinners, uint32 numSixMatchWinners);
1226     event SixMatchPrizeTaken(address winner, uint256 prizeAmount);
1227     event BonusMatchPrizeTaken(address winner, uint256 prizeAmount);
1228     event FiveMatchPrizeTaken(address winner, uint256 prizeAmount);
1229 
1230     modifier onlyOwner {
1231         require(msg.sender == Owner);
1232         _;
1233     }
1234 
1235     modifier onlyOracle {
1236         require(msg.sender == oraclize_cbAddress());
1237         _;
1238     }
1239 
1240     modifier onlyWhenLottoNotStarted {
1241         require(isLottoStarted == false);
1242         _;
1243     }
1244 
1245     modifier onlyWhenLottoStarted {
1246         require(isLottoStarted == true);
1247         _;
1248     }
1249 
1250     function CryptoLotto() {
1251         Owner = msg.sender;
1252     }
1253 
1254     function launchLotto() onlyOwner {
1255         oracleCallbackId = oraclize_query(oraclizedQuerySource, oraclizedQuery, gasForOraclizedQuery);
1256     }
1257 
1258     // Emergency function to call only when the turn missed oraclized_query becaused of gas management failure and no chance to resume by itself.
1259     function resumeLotto() onlyOwner {
1260         require(finishWhen < now);
1261         oracleCallbackId = oraclize_query(oraclizedQuerySource, oraclizedQuery, gasForOraclizedQuery);
1262     }
1263 
1264     function setGasForOraclizedQuery(uint32 _gasLimit) onlyOwner {
1265         gasForOraclizedQuery = _gasLimit;
1266     }
1267 
1268     function __callback(bytes32 myid, string result) onlyOracle {
1269         require(myid == oracleCallbackId);
1270         
1271         if (turn > 0)
1272             _finishLotto();
1273         _setLottoNumbers(result);
1274         _startLotto();
1275     }
1276 
1277     function _startLotto() onlyWhenLottoNotStarted internal {
1278         turn++;
1279         finishWhen = now + duration;
1280         oracleCallbackId = oraclize_query(duration, oraclizedQuerySource, oraclizedQuery, gasForOraclizedQuery);
1281         isLottoStarted = true;
1282         numFiveMatchWinners.push(0);
1283         numBonusMatchWinners.push(0);
1284         numSixMatchWinners.push(0);
1285         nonces.push(0);
1286         LottoStart(turn);
1287     }
1288 
1289     function _finishLotto() onlyWhenLottoStarted internal {
1290         isLottoStarted = false;
1291         _saveLottoResult();
1292         LottoNumbersAnnounced(lottoNumbers, bonusNumber, raisedAmounts[turn - 1], numFiveMatchWinners[turn - 1], numBonusMatchWinners[turn - 1], numSixMatchWinners[turn - 1]);
1293     }
1294 
1295     function _setLottoNumbers(string _strData) onlyWhenLottoNotStarted internal {
1296         uint8[] memory _lottoNumbers = new uint8[](lottoLength);
1297         uint8 _bonusNumber;
1298         var slicedString = _strData.toSlice();
1299         slicedString.beyond("{{".toSlice()).until("}".toSlice());
1300         var _strLottoNumbers = slicedString.split('}, {'.toSlice());
1301 
1302         var _bonusNumberIndex = uint8(parseInt(slicedString.toString()));
1303         uint8 _lottoLowestNumber = lottoLowestNumber;
1304         uint8 _lottoHighestNumber = lottoHighestNumber;
1305         uint8 _nonce = 0;
1306 
1307         for (uint8 _index = 0; _index < lottoLength + 1; _index++) {
1308             var splited = _strLottoNumbers.split(', '.toSlice());
1309             if (_index == _bonusNumberIndex) {
1310                 bonusNumber = uint8(parseInt(splited.toString()));
1311                 _nonce = 1;
1312                 continue;
1313             }
1314             _lottoNumbers[_index - _nonce] = uint8(parseInt(splited.toString()));
1315             require(_lottoNumbers[_index - _nonce] >= _lottoLowestNumber && _lottoNumbers[_index - _nonce] <= _lottoHighestNumber);
1316             if (_index - _nonce > 0)
1317                 require(_lottoNumbers[_index - _nonce - 1] < _lottoNumbers[_index - _nonce]);
1318             lottoNumbers[_index - _nonce] = _lottoNumbers[_index - _nonce];
1319         }
1320     }
1321 
1322     function _saveLottoResult() onlyWhenLottoNotStarted internal {
1323         uint32 _encodedLottoResult = 0;
1324         var _raisedAmount = raisedAmount;
1325 
1326         // lottoNumbers[6]          24 bits  [0..23]
1327         for (uint8 _index = 0; _index < lottoNumbers.length; _index++) {
1328             _encodedLottoResult |= uint32(lottoNumbers[_index]) << (_index * 4);
1329         }
1330 
1331         // bonusNumber               4 bits  [24..27]
1332         _encodedLottoResult |= uint32(bonusNumber) << (24);
1333 
1334         uint256 _totalPrizeAmount = 0;
1335 
1336         if (numFiveMatchWinners[turn - 1] > 0)
1337             _totalPrizeAmount += _raisedAmount * fiveMatchPayoutInPercent / 100;
1338 
1339         if (numBonusMatchWinners[turn - 1] > 0)
1340             _totalPrizeAmount += _raisedAmount * bonusMatchPayoutInPercent / 100;
1341 
1342         if (numSixMatchWinners[turn - 1] > 0)
1343             _totalPrizeAmount += _raisedAmount * sixMatchPayoutInPercent / 100;
1344 
1345         raisedAmounts.push(_raisedAmount);
1346         untakenPrizeAmounts.push(_totalPrizeAmount);
1347         encodedLottoResults.push(_encodedLottoResult);
1348         accNumBettings.push(bettings.length);
1349         timestamps.push(uint64(now));
1350 
1351         var _ownerShare = _raisedAmount * ownerShareInPercent / 100;
1352         Owner.transfer(_ownerShare);
1353 
1354         uint32 _numTurnsToRevolve = uint32(numTurnsToRevolve);
1355         uint256 _amountToCarryOver = 0;
1356         if (turn > _numTurnsToRevolve)
1357             _amountToCarryOver = untakenPrizeAmounts[turn - _numTurnsToRevolve - 1];
1358         raisedAmount = _raisedAmount - _totalPrizeAmount - _ownerShare + _amountToCarryOver;
1359     }
1360 
1361     function getLottoResult(uint256 _turn) constant returns (uint256, uint256, uint32, uint32, uint32) {
1362         require(_turn < turn && _turn > 0);
1363         return (raisedAmounts[_turn - 1], untakenPrizeAmounts[_turn - 1], numFiveMatchWinners[_turn - 1], numBonusMatchWinners[_turn - 1], numSixMatchWinners[_turn - 1]);
1364     }
1365 
1366     function getLottoNumbers(uint256 _turn) constant returns (uint8[], uint8) {
1367         require(_turn < turn && _turn > 0);
1368         var _encodedLottoResult = encodedLottoResults[_turn - 1];
1369         uint8[] memory _lottoNumbers = new uint8[](lottoLength);
1370         uint8 _bonusNumber;
1371 
1372         for (uint8 _index = 0; _index < _lottoNumbers.length; _index++) {
1373             _lottoNumbers[_index] = uint8((_encodedLottoResult >> (_index * 4)) & (2 ** 4 - 1));
1374         }
1375         _bonusNumber = uint8((_encodedLottoResult >> 24) & (2 ** 4 - 1));
1376         return (_lottoNumbers, _bonusNumber);
1377     }
1378 
1379     function buyTickets(uint _numTickets, uint8[] _betNumbersList, bool _isAutoGenerated) payable onlyWhenLottoStarted {
1380         require(finishWhen > now);
1381         var _lottoLength = lottoLength;
1382         require(_betNumbersList.length == _numTickets * _lottoLength);
1383         uint _totalPrice = _numTickets * lottoPrice;
1384         require(msg.value >= _totalPrice);
1385 
1386         for (uint j = 0; j < _numTickets; j++) {
1387             require(_betNumbersList[j * _lottoLength] >= lottoLowestNumber && _betNumbersList[(j + 1) * _lottoLength - 1] <= lottoHighestNumber);
1388             for (uint _index = 0; _index < _lottoLength - 1; _index++) {
1389                 require(_betNumbersList[_index + j * _lottoLength] < _betNumbersList[_index + 1 + j * _lottoLength]);
1390             }
1391         }
1392 
1393         uint8[] memory _betNumbers = new uint8[](lottoLength);
1394         for (j = 0; j < _numTickets; j++) {
1395             for (_index = 0; _index < _lottoLength - 1; _index++) {
1396                 _betNumbers[_index] = _betNumbersList[_index + j * _lottoLength];
1397             }
1398             _betNumbers[_index] = _betNumbersList[_index + j * _lottoLength];
1399             _saveBettingAndTicket(_betNumbers, _isAutoGenerated);
1400         }
1401 
1402         raisedAmount += _totalPrice;
1403         Owner.transfer(msg.value - _totalPrice);
1404         FundRaised(msg.sender, msg.value, raisedAmount);
1405     }
1406 
1407     function _getLottoRank(uint8[] _betNumbers) internal constant returns (lottoRank) {
1408         uint8 _lottoLength = lottoLength;
1409         uint8[] memory _lottoNumbers = new uint8[](_lottoLength);
1410         uint8 _indexLotto = 0;
1411         uint8 _indexBet = 0;
1412         uint8 _numMatch = 0;
1413 
1414         for (uint8 i = 0; i < _lottoLength; i++) {
1415             _lottoNumbers[i] = lottoNumbers[i];
1416         }
1417 
1418         while (_indexLotto < _lottoLength && _indexBet < _lottoLength) {
1419             if (_betNumbers[_indexBet] == _lottoNumbers[_indexLotto]) {
1420                 _numMatch++;
1421                 _indexBet++;
1422                 _indexLotto++;
1423                 if (_numMatch > 4)
1424                     for (uint8 _burner = 0; _burner < 6; _burner++) {}
1425                 continue;
1426             }
1427             else if (_betNumbers[_indexBet] < _lottoNumbers[_indexLotto]) {
1428                 _indexBet++;
1429                 continue;
1430             }
1431 
1432             else {
1433                 _indexLotto++;
1434                 continue;
1435             }
1436         }
1437 
1438         if (_numMatch == _lottoLength - 1) {
1439             uint8 _bonusNumber = bonusNumber;
1440             for (uint8 _index = 0; _index < lottoLength; _index++) {
1441                 if (_betNumbers[_index] == _bonusNumber) {
1442                     for (_burner = 0; _burner < 6; _burner++) {}
1443                     return lottoRank.BONUS_MATCH;
1444                 }
1445             }
1446             return lottoRank.FIVE_MATCH;
1447         }
1448         else if (_numMatch == _lottoLength) {
1449             for (_burner = 0; _burner < 12; _burner++) {}
1450             return lottoRank.SIX_MATCH;
1451         }
1452 
1453         return lottoRank.DEFAULT;
1454     }
1455 
1456     function _saveBettingAndTicket(uint8[] _betNumbers, bool _isAutoGenerated) internal onlyWhenLottoStarted {
1457         require(_betNumbers.length == 6 && lottoHighestNumber <= 16);
1458         uint256 _encodedBetting = 0;
1459         uint64 _encodedTicket = 0;
1460         uint256 _nonce256 = 0;
1461         uint64 _nonce64 = 0;
1462 
1463         // isTaken                   1 bit      betting[0]                  ticket[0]
1464         // isAutoGenerated           1 bit      betting[1]                  ticket[1]
1465         // betNumbers[6]            24 bits     betting[2..25]              ticket[2..25]
1466         // lottoRank.FIVE_MATCH      1 bit      betting[26]                 ticket[26]
1467         // lottoRank.BONUS_MATCH     1 bit      betting[27]                 ticket[27]
1468         // lottoRank.SIX_MATCH       1 bit      betting[28]                 ticket[28]
1469         // sender address          160 bits     betting[29..188]
1470         // timestamp                36 bits     betting[189..224]           ticket[29..64]
1471 
1472         // isAutoGenerated
1473         if (_isAutoGenerated) {
1474             _encodedBetting |= uint256(1) << 1;
1475             _encodedTicket |= uint64(1) << 1;
1476         }
1477 
1478         // betNumbers[6]
1479         for (uint8 _index = 0; _index < _betNumbers.length; _index++) {
1480             uint256 _betNumber = uint256(_betNumbers[_index]) << (_index * 4 + 2);
1481             _encodedBetting |= _betNumber;
1482             _encodedTicket |= uint64(_betNumber);
1483         }
1484 
1485         // lottoRank.FIVE_MATCH, lottoRank.BONUS_MATCH, lottoRank.SIX_MATCH
1486         lottoRank _lottoRank = _getLottoRank(_betNumbers);
1487         if (_lottoRank == lottoRank.FIVE_MATCH) {
1488             numFiveMatchWinners[turn - 1]++;
1489             _encodedBetting |= uint256(1) << 26;
1490             _encodedTicket |= uint64(1) << 26;
1491         }
1492         else if (_lottoRank == lottoRank.BONUS_MATCH) {
1493             numBonusMatchWinners[turn - 1]++;
1494             _encodedBetting |= uint256(1) << 27;
1495             _encodedTicket |= uint64(1) << 27;
1496         }
1497         else if (_lottoRank == lottoRank.SIX_MATCH) {
1498             numSixMatchWinners[turn - 1]++;
1499             _encodedBetting |= uint256(1) << 28;
1500             _encodedTicket |= uint64(1) << 28;
1501         } else {
1502             nonces[turn - 1]++;
1503             _nonce256 |= uint256(1) << 29;
1504             _nonce64 |= uint64(1) << 29;
1505         }
1506 
1507         // sender address
1508         _encodedBetting |= uint256(msg.sender) << 29;
1509 
1510         // timestamp
1511         _encodedBetting |= now << 189;
1512         _encodedTicket |= uint64(now) << 29;
1513 
1514         // push ticket
1515         tickets[msg.sender][turn].push(_encodedTicket);
1516         // push betting
1517         bettings.push(_encodedBetting);
1518     }
1519 
1520     function getNumBettings() constant returns (uint256) {
1521         return bettings.length;
1522     }
1523 
1524     function getTurn(uint256 _bettingId) constant returns (uint32) {
1525         uint32 _turn = turn;
1526         require(_turn > 0);
1527         require(_bettingId < bettings.length);
1528 
1529         if (_turn == 1 || _bettingId < accNumBettings[0])
1530             return 1;
1531         if (_bettingId >= accNumBettings[_turn - 2])
1532             return _turn;
1533 
1534         uint32 i = 0;
1535         uint32 j = _turn - 1;
1536         uint32 mid = 0;
1537 
1538         while (i < j) {
1539             mid = (i + j) / 2;
1540 
1541             if (accNumBettings[mid] == _bettingId)
1542                 return mid + 2;
1543 
1544             if (_bettingId < accNumBettings[mid]) {
1545                 if (mid > 0 && _bettingId > accNumBettings[mid - 1])
1546                     return mid + 1;
1547                 j = mid;
1548             }
1549             else {
1550                 if (mid < _turn - 2 && _bettingId < accNumBettings[mid + 1])
1551                     return mid + 2;
1552                 i = mid + 1;
1553             }
1554         }
1555         return mid + 2;
1556     }
1557 
1558     function getBetting(uint256 i) constant returns (bool, bool, uint8[], lottoRank, uint32){
1559         require(i < bettings.length);
1560         uint256 _betting = bettings[i];
1561 
1562         // isTaken                      1 bit      [0]
1563         bool _isTaken;
1564         if (_betting & 1 == 1)
1565             _isTaken = true;
1566         else
1567             _isAutoGenerated = false;
1568 
1569         // _isAutoGenerated             1 bit      [1]
1570         bool _isAutoGenerated;
1571         if ((_betting >> 1) & 1 == 1)
1572             _isAutoGenerated = true;
1573         else
1574             _isAutoGenerated = false;
1575 
1576         // 6 betNumbers                24 bits     [2..25]
1577         uint8[] memory _betNumbers = new uint8[](lottoLength);
1578         for (uint8 _index = 0; _index < lottoLength; _index++) {
1579             _betNumbers[_index] = uint8((_betting >> (_index * 4 + 2)) & (2 ** 4 - 1));
1580         }
1581 
1582         //  _timestamp                   bits     [189..255]
1583         uint128 _timestamp;
1584         _timestamp = uint128((_betting >> 189) & (2 ** 67 - 1));
1585 
1586         uint32 _turn = getTurn(i);
1587         if (_turn == turn && isLottoStarted)
1588             return (_isTaken, _isAutoGenerated, _betNumbers, lottoRank.NONCE, _turn);
1589 
1590         // return lottoRank only when the turn is finished
1591         // lottoRank                    3 bits     [26..28]
1592         lottoRank _lottoRank = lottoRank.DEFAULT;
1593         if ((_betting >> 26) & 1 == 1)
1594             _lottoRank = lottoRank.FIVE_MATCH;
1595         if ((_betting >> 27) & 1 == 1)
1596             _lottoRank = lottoRank.BONUS_MATCH;
1597         if ((_betting >> 28) & 1 == 1)
1598             _lottoRank = lottoRank.SIX_MATCH;
1599 
1600         return (_isTaken, _isAutoGenerated, _betNumbers, _lottoRank, _turn);
1601     }
1602 
1603     function getBettingExtra(uint256 i) constant returns (address, uint128){
1604         require(i < bettings.length);
1605         uint256 _betting = bettings[i];
1606         uint128 _timestamp = uint128((_betting >> 189) & (2 ** 67 - 1));
1607         address _beneficiary = address((_betting >> 29) & (2 ** 160 - 1));
1608         return (_beneficiary, _timestamp);
1609     }
1610 
1611     function getMyResult(uint32 _turn) constant returns (uint256, uint32, uint32, uint32, uint256) {
1612         require(_turn > 0);
1613         if (_turn == turn)
1614             require(!isLottoStarted);
1615         else
1616             require(_turn < turn);
1617 
1618         uint256 _numMyTickets = tickets[msg.sender][_turn].length;
1619         uint256 _totalPrizeAmount = 0;
1620         uint64 _ticket;
1621         uint32 _numSixMatchPrizes = 0;
1622         uint32 _numBonusMatchPrizes = 0;
1623         uint32 _numFiveMatchPrizes = 0;
1624 
1625         if (_numMyTickets == 0) {
1626             return (0, 0, 0, 0, 0);
1627         }
1628 
1629         for (uint256 _index = 0; _index < _numMyTickets; _index++) {
1630             _ticket = tickets[msg.sender][_turn][_index];
1631             if ((_ticket >> 26) & 1 == 1) {
1632                 _numFiveMatchPrizes++;
1633                 _totalPrizeAmount += _getFiveMatchPrizeAmount(_turn);
1634             }
1635             else if ((_ticket >> 27) & 1 == 1) {
1636                 _numBonusMatchPrizes++;
1637                 _totalPrizeAmount += _getBonusMatchPrizeAmount(_turn);
1638             }
1639             else if ((_ticket >> 28) & 1 == 1) {
1640                 _numSixMatchPrizes++;
1641                 _totalPrizeAmount += _getSixMatchPrizeAmount(_turn);
1642             }
1643         }
1644         return (_numMyTickets, _numSixMatchPrizes, _numBonusMatchPrizes, _numFiveMatchPrizes, _totalPrizeAmount);
1645     }
1646 
1647     function getNumMyTickets(uint32 _turn) constant returns (uint256) {
1648         require(_turn > 0 && _turn <= turn);
1649         return tickets[msg.sender][_turn].length;
1650     }
1651 
1652     function getMyTicket(uint32 _turn, uint256 i) constant returns (bool, bool, uint8[], lottoRank, uint64){
1653         require(_turn <= turn);
1654         require(i < tickets[msg.sender][_turn].length);
1655         uint64 _ticket = tickets[msg.sender][_turn][i];
1656 
1657         // isTaken                   1 bit      ticket[0]
1658         bool _isTaken = false;
1659         if ((_ticket & 1) == 1)
1660             _isTaken = true;
1661 
1662         // isAutoGenerated           1 bit      ticket[1]
1663         bool _isAutoGenerated = false;
1664         if ((_ticket >> 1) & 1 == 1)
1665             _isAutoGenerated = true;
1666 
1667         // betNumbers[6]            24 bits     ticket[2..25]
1668         uint8[] memory _betNumbers = new uint8[](lottoLength);
1669         for (uint8 _index = 0; _index < lottoLength; _index++) {
1670             _betNumbers[_index] = uint8((_ticket >> (_index * 4 + 2)) & (2 ** 4 - 1));
1671         }
1672 
1673         // timestamp                36 bits     ticket[29..64]
1674         uint64 _timestamp = uint64((_ticket >> 29) & (2 ** 36 - 1));
1675 
1676         if (_turn == turn)
1677             return (_isTaken, _isAutoGenerated, _betNumbers, lottoRank.NONCE, _timestamp);
1678 
1679         // return lottoRank only when the turn is finished
1680 
1681         // lottoRank.FIVE_MATCH      1 bit      ticket[26]
1682         // lottoRank.BONUS_MATCH     1 bit      ticket[27]
1683         // lottoRank.SIX_MATCH       1 bit      ticket[28]
1684         lottoRank _lottoRank = lottoRank.DEFAULT;
1685         if ((_ticket >> 26) & 1 == 1)
1686             _lottoRank = lottoRank.FIVE_MATCH;
1687         if ((_ticket >> 27) & 1 == 1)
1688             _lottoRank = lottoRank.BONUS_MATCH;
1689         if ((_ticket >> 28) & 1 == 1)
1690             _lottoRank = lottoRank.SIX_MATCH;
1691 
1692         return (_isTaken, _isAutoGenerated, _betNumbers, _lottoRank, _timestamp);
1693     }
1694 
1695     function getMyUntakenPrizes(uint32 _turn) constant returns (uint32[]) {
1696         require(_turn > 0 && _turn < turn);
1697         uint256 _numMyTickets = tickets[msg.sender][_turn].length;
1698 
1699         uint32[] memory _prizes = new uint32[](50);
1700         uint256 _indexPrizes = 0;
1701 
1702         for (uint16 _index; _index < _numMyTickets; _index++) {
1703             uint64 _ticket = tickets[msg.sender][_turn][_index];
1704             if (((_ticket >> 26) & 1 == 1) && (_ticket & 1 == 0))
1705                 _prizes[_indexPrizes++] = _index;
1706             else if (((_ticket >> 27) & 1 == 1) && (_ticket & 1 == 0))
1707                 _prizes[_indexPrizes++] = _index;
1708             else if (((_ticket >> 28) & 1 == 1) && (_ticket & 1 == 0))
1709                 _prizes[_indexPrizes++] = _index;
1710             if (_indexPrizes >= 50) {
1711                 break;
1712             }
1713         }
1714         uint32[] memory _retPrizes = new uint32[](_indexPrizes);
1715 
1716         for (_index = 0; _index < _indexPrizes; _index++) {
1717             _retPrizes[_index] = _prizes[_index];
1718         }
1719         return (_retPrizes);
1720     }
1721 
1722     function takePrize(uint32 _turn, uint256 i) {
1723         require(_turn > 0 && _turn < turn);
1724         if (turn > numTurnsToRevolve)
1725             require(_turn >= turn - numTurnsToRevolve);
1726 
1727         require(i < tickets[msg.sender][_turn].length);
1728         var _ticket = tickets[msg.sender][_turn][i];
1729 
1730         // isTaken must be false
1731         require((_ticket & 1) == 0);
1732 
1733         // lottoRank.FIVE_MATCH      1 bit   [26]
1734         // lottoRank.BONUS_MATCH     1 bit   [27]
1735         // lottoRank.SIX_MATCH       1 bit   [28]
1736         if ((_ticket >> 26) & 1 == 1) {
1737             uint256 _prizeAmount = _getFiveMatchPrizeAmount(_turn);
1738             require(_prizeAmount > 0);
1739             msg.sender.transfer(_prizeAmount);
1740             FiveMatchPrizeTaken(msg.sender, _prizeAmount);
1741             tickets[msg.sender][_turn][i] |= 1;
1742             untakenPrizeAmounts[_turn - 1] -= _prizeAmount;
1743         } else if ((_ticket >> 27) & 1 == 1) {
1744             _prizeAmount = _getBonusMatchPrizeAmount(_turn);
1745             require(_prizeAmount > 0);
1746             msg.sender.transfer(_prizeAmount);
1747             BonusMatchPrizeTaken(msg.sender, _prizeAmount);
1748             tickets[msg.sender][_turn][i] |= 1;
1749             untakenPrizeAmounts[_turn - 1] -= _prizeAmount;
1750         } else if ((_ticket >> 28) & 1 == 1) {
1751             _prizeAmount = _getSixMatchPrizeAmount(_turn);
1752             require(_prizeAmount > 0);
1753             msg.sender.transfer(_prizeAmount);
1754             SixMatchPrizeTaken(msg.sender, _prizeAmount);
1755             tickets[msg.sender][_turn][i] |= 1;
1756             untakenPrizeAmounts[_turn - 1] -= _prizeAmount;
1757         }
1758     }
1759 
1760     function _getFiveMatchPrizeAmount(uint256 _turn) internal constant returns (uint256) {
1761         require(_turn > 0 && _turn < turn);
1762         uint256 _numFiveMatchWinners = uint256(numFiveMatchWinners[_turn - 1]);
1763         if (_numFiveMatchWinners == 0)
1764             return 0;
1765         return raisedAmounts[_turn - 1] * fiveMatchPayoutInPercent / 100 / _numFiveMatchWinners;
1766     }
1767 
1768     function _getBonusMatchPrizeAmount(uint256 _turn) internal constant returns (uint256) {
1769         require(_turn > 0 && _turn < turn);
1770         uint256 _numBonusMatchWinners = uint256(numBonusMatchWinners[_turn - 1]);
1771         if (_numBonusMatchWinners == 0)
1772             return 0;
1773         return raisedAmounts[_turn - 1] * bonusMatchPayoutInPercent / 100 / _numBonusMatchWinners;
1774     }
1775 
1776     function _getSixMatchPrizeAmount(uint256 _turn) internal constant returns (uint256) {
1777         require(_turn > 0 && _turn < turn);
1778         uint256 _numSixMatchWinners = uint256(numSixMatchWinners[_turn - 1]);
1779         if (_numSixMatchWinners == 0)
1780             return 0;
1781         return raisedAmounts[_turn - 1] * sixMatchPayoutInPercent / 100 / _numSixMatchWinners;
1782     }
1783 
1784     function() payable {
1785     }
1786 }