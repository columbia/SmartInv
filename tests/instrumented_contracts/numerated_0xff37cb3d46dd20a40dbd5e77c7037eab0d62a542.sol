1 pragma solidity 0.4.23;
2 
3 // File: mixbytes-solidity/contracts/security/ArgumentsChecker.sol
4 
5 // Copyright (C) 2017  MixBytes, LLC
6 
7 // Licensed under the Apache License, Version 2.0 (the "License").
8 // You may not use this file except in compliance with the License.
9 
10 // Unless required by applicable law or agreed to in writing, software
11 // distributed under the License is distributed on an "AS IS" BASIS,
12 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
13 
14 pragma solidity ^0.4.15;
15 
16 
17 /// @title utility methods and modifiers of arguments validation
18 contract ArgumentsChecker {
19 
20     /// @dev check which prevents short address attack
21     modifier payloadSizeIs(uint size) {
22        require(msg.data.length == size + 4 /* function selector */);
23        _;
24     }
25 
26     /// @dev check that address is valid
27     modifier validAddress(address addr) {
28         require(addr != address(0));
29         _;
30     }
31 }
32 
33 // File: mixbytes-solidity/contracts/crowdsale/FixedTimeBonuses.sol
34 
35 // Copyright (C) 2017  MixBytes, LLC
36 
37 // Licensed under the Apache License, Version 2.0 (the "License").
38 // You may not use this file except in compliance with the License.
39 
40 // Unless required by applicable law or agreed to in writing, software
41 // distributed under the License is distributed on an "AS IS" BASIS,
42 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
43 
44 pragma solidity ^0.4.15;
45 
46 
47 library FixedTimeBonuses {
48 
49     struct Bonus {
50         uint endTime;
51         uint bonus;
52     }
53 
54     struct Data {
55         Bonus[] bonuses;
56     }
57 
58     /// @dev validates consistency of data structure
59     /// @param self data structure
60     /// @param shouldDecrease additionally check if bonuses are decreasing over time
61     function validate(Data storage self, bool shouldDecrease) internal constant {
62         uint length = self.bonuses.length;
63         require(length > 0);
64 
65         Bonus storage last = self.bonuses[0];
66         for (uint i = 1; i < length; i++) {
67             Bonus storage current = self.bonuses[i];
68             require(current.endTime > last.endTime);
69             if (shouldDecrease)
70                 require(current.bonus < last.bonus);
71             last = current;
72         }
73     }
74 
75     /// @dev get ending time of the last bonus
76     /// @param self data structure
77     function getLastTime(Data storage self) internal constant returns (uint) {
78         return self.bonuses[self.bonuses.length - 1].endTime;
79     }
80 
81     /// @dev validates consistency of data structure
82     /// @param self data structure
83     /// @param time time for which bonus must be computed (assuming time <= getLastTime())
84     function getBonus(Data storage self, uint time) internal constant returns (uint) {
85         // TODO binary search?
86         uint length = self.bonuses.length;
87         for (uint i = 0; i < length; i++) {
88             if (self.bonuses[i].endTime >= time)
89                 return self.bonuses[i].bonus;
90         }
91         assert(false);  // must be unreachable
92     }
93 }
94 
95 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
96 
97 /**
98  * @title Helps contracts guard agains rentrancy attacks.
99  * @author Remco Bloemen <remco@2π.com>
100  * @notice If you mark a function `nonReentrant`, you should also
101  * mark it `external`.
102  */
103 contract ReentrancyGuard {
104 
105   /**
106    * @dev We use a single lock for the whole contract.
107    */
108   bool private rentrancy_lock = false;
109 
110   /**
111    * @dev Prevents a contract from calling itself, directly or indirectly.
112    * @notice If you mark a function `nonReentrant`, you should also
113    * mark it `external`. Calling one nonReentrant function from
114    * another is not supported. Instead, you can implement a
115    * `private` function doing the actual work, and a `external`
116    * wrapper marked as `nonReentrant`.
117    */
118   modifier nonReentrant() {
119     require(!rentrancy_lock);
120     rentrancy_lock = true;
121     _;
122     rentrancy_lock = false;
123   }
124 
125 }
126 
127 // File: contracts/oraclize/usingOraclize.sol
128 
129 // <ORACLIZE_API>
130 /*
131 Copyright (c) 2015-2016 Oraclize SRL
132 Copyright (c) 2016 Oraclize LTD
133 
134 
135 
136 Permission is hereby granted, free of charge, to any person obtaining a copy
137 of this software and associated documentation files (the "Software"), to deal
138 in the Software without restriction, including without limitation the rights
139 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
140 copies of the Software, and to permit persons to whom the Software is
141 furnished to do so, subject to the following conditions:
142 
143 
144 
145 The above copyright notice and this permission notice shall be included in
146 all copies or substantial portions of the Software.
147 
148 
149 
150 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
151 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
152 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
153 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
154 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
155 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
156 THE SOFTWARE.
157 */
158 
159 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
160 pragma solidity ^0.4.18;
161 
162 contract OraclizeI {
163     address public cbAddress;
164     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
165     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
166     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
167     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
168     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
169     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
170     function getPrice(string _datasource) public returns (uint _dsprice);
171     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
172     function setProofType(byte _proofType) external;
173     function setCustomGasPrice(uint _gasPrice) external;
174     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
175 }
176 contract OraclizeAddrResolverI {
177     function getAddress() public returns (address _addr);
178 }
179 contract usingOraclize {
180     uint constant day = 60*60*24;
181     uint constant week = 60*60*24*7;
182     uint constant month = 60*60*24*30;
183     byte constant proofType_NONE = 0x00;
184     byte constant proofType_TLSNotary = 0x10;
185     byte constant proofType_Android = 0x20;
186     byte constant proofType_Ledger = 0x30;
187     byte constant proofType_Native = 0xF0;
188     byte constant proofStorage_IPFS = 0x01;
189     uint8 constant networkID_auto = 0;
190     uint8 constant networkID_mainnet = 1;
191     uint8 constant networkID_testnet = 2;
192     uint8 constant networkID_morden = 2;
193     uint8 constant networkID_consensys = 161;
194 
195     OraclizeAddrResolverI OAR;
196 
197     OraclizeI oraclize;
198     modifier oraclizeAPI {
199         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
200             oraclize_setNetwork(networkID_auto);
201 
202         if(address(oraclize) != OAR.getAddress())
203             oraclize = OraclizeI(OAR.getAddress());
204 
205         _;
206     }
207     modifier coupon(string code){
208         oraclize = OraclizeI(OAR.getAddress());
209         _;
210     }
211 
212     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
213       return oraclize_setNetwork();
214       networkID; // silence the warning and remain backwards compatible
215     }
216     function oraclize_setNetwork() internal returns(bool){
217         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
218             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
219             oraclize_setNetworkName("eth_mainnet");
220             return true;
221         }
222         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
223             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
224             oraclize_setNetworkName("eth_ropsten3");
225             return true;
226         }
227         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
228             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
229             oraclize_setNetworkName("eth_kovan");
230             return true;
231         }
232         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
233             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
234             oraclize_setNetworkName("eth_rinkeby");
235             return true;
236         }
237         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
238             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
239             return true;
240         }
241         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
242             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
243             return true;
244         }
245         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
246             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
247             return true;
248         }
249         return false;
250     }
251 
252     function __callback(bytes32 myid, string result) public {
253         __callback(myid, result, new bytes(0));
254     }
255     function __callback(bytes32 myid, string result, bytes proof) public {
256       return;
257       myid; result; proof; // Silence compiler warnings
258     }
259 
260     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
261         return oraclize.getPrice(datasource);
262     }
263 
264     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
265         return oraclize.getPrice(datasource, gaslimit);
266     }
267 
268     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
269         uint price = oraclize.getPrice(datasource);
270         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
271         return oraclize.query.value(price)(0, datasource, arg);
272     }
273     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
274         uint price = oraclize.getPrice(datasource);
275         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
276         return oraclize.query.value(price)(timestamp, datasource, arg);
277     }
278     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
279         uint price = oraclize.getPrice(datasource, gaslimit);
280         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
281         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
282     }
283     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
284         uint price = oraclize.getPrice(datasource, gaslimit);
285         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
286         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
287     }
288     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
289         uint price = oraclize.getPrice(datasource);
290         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
291         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
292     }
293     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
294         uint price = oraclize.getPrice(datasource);
295         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
296         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
297     }
298     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
299         uint price = oraclize.getPrice(datasource, gaslimit);
300         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
301         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
302     }
303     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
304         uint price = oraclize.getPrice(datasource, gaslimit);
305         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
306         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
307     }
308     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
309         uint price = oraclize.getPrice(datasource);
310         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
311         bytes memory args = stra2cbor(argN);
312         return oraclize.queryN.value(price)(0, datasource, args);
313     }
314     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
315         uint price = oraclize.getPrice(datasource);
316         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
317         bytes memory args = stra2cbor(argN);
318         return oraclize.queryN.value(price)(timestamp, datasource, args);
319     }
320     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
321         uint price = oraclize.getPrice(datasource, gaslimit);
322         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
323         bytes memory args = stra2cbor(argN);
324         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
325     }
326     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
327         uint price = oraclize.getPrice(datasource, gaslimit);
328         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
329         bytes memory args = stra2cbor(argN);
330         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
331     }
332     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
333         string[] memory dynargs = new string[](1);
334         dynargs[0] = args[0];
335         return oraclize_query(datasource, dynargs);
336     }
337     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
338         string[] memory dynargs = new string[](1);
339         dynargs[0] = args[0];
340         return oraclize_query(timestamp, datasource, dynargs);
341     }
342     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
343         string[] memory dynargs = new string[](1);
344         dynargs[0] = args[0];
345         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
346     }
347     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
348         string[] memory dynargs = new string[](1);
349         dynargs[0] = args[0];
350         return oraclize_query(datasource, dynargs, gaslimit);
351     }
352 
353     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
354         string[] memory dynargs = new string[](2);
355         dynargs[0] = args[0];
356         dynargs[1] = args[1];
357         return oraclize_query(datasource, dynargs);
358     }
359     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
360         string[] memory dynargs = new string[](2);
361         dynargs[0] = args[0];
362         dynargs[1] = args[1];
363         return oraclize_query(timestamp, datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](2);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
370     }
371     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
372         string[] memory dynargs = new string[](2);
373         dynargs[0] = args[0];
374         dynargs[1] = args[1];
375         return oraclize_query(datasource, dynargs, gaslimit);
376     }
377     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
378         string[] memory dynargs = new string[](3);
379         dynargs[0] = args[0];
380         dynargs[1] = args[1];
381         dynargs[2] = args[2];
382         return oraclize_query(datasource, dynargs);
383     }
384     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
385         string[] memory dynargs = new string[](3);
386         dynargs[0] = args[0];
387         dynargs[1] = args[1];
388         dynargs[2] = args[2];
389         return oraclize_query(timestamp, datasource, dynargs);
390     }
391     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
392         string[] memory dynargs = new string[](3);
393         dynargs[0] = args[0];
394         dynargs[1] = args[1];
395         dynargs[2] = args[2];
396         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
397     }
398     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](3);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         dynargs[2] = args[2];
403         return oraclize_query(datasource, dynargs, gaslimit);
404     }
405 
406     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
407         string[] memory dynargs = new string[](4);
408         dynargs[0] = args[0];
409         dynargs[1] = args[1];
410         dynargs[2] = args[2];
411         dynargs[3] = args[3];
412         return oraclize_query(datasource, dynargs);
413     }
414     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
415         string[] memory dynargs = new string[](4);
416         dynargs[0] = args[0];
417         dynargs[1] = args[1];
418         dynargs[2] = args[2];
419         dynargs[3] = args[3];
420         return oraclize_query(timestamp, datasource, dynargs);
421     }
422     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         string[] memory dynargs = new string[](4);
424         dynargs[0] = args[0];
425         dynargs[1] = args[1];
426         dynargs[2] = args[2];
427         dynargs[3] = args[3];
428         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
429     }
430     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
431         string[] memory dynargs = new string[](4);
432         dynargs[0] = args[0];
433         dynargs[1] = args[1];
434         dynargs[2] = args[2];
435         dynargs[3] = args[3];
436         return oraclize_query(datasource, dynargs, gaslimit);
437     }
438     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](5);
440         dynargs[0] = args[0];
441         dynargs[1] = args[1];
442         dynargs[2] = args[2];
443         dynargs[3] = args[3];
444         dynargs[4] = args[4];
445         return oraclize_query(datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](5);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         dynargs[4] = args[4];
454         return oraclize_query(timestamp, datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457         string[] memory dynargs = new string[](5);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         dynargs[4] = args[4];
463         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
464     }
465     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](5);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         dynargs[4] = args[4];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
475         uint price = oraclize.getPrice(datasource);
476         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
477         bytes memory args = ba2cbor(argN);
478         return oraclize.queryN.value(price)(0, datasource, args);
479     }
480     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
481         uint price = oraclize.getPrice(datasource);
482         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
483         bytes memory args = ba2cbor(argN);
484         return oraclize.queryN.value(price)(timestamp, datasource, args);
485     }
486     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
487         uint price = oraclize.getPrice(datasource, gaslimit);
488         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
489         bytes memory args = ba2cbor(argN);
490         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
491     }
492     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
493         uint price = oraclize.getPrice(datasource, gaslimit);
494         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
495         bytes memory args = ba2cbor(argN);
496         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
497     }
498     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
499         bytes[] memory dynargs = new bytes[](1);
500         dynargs[0] = args[0];
501         return oraclize_query(datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
504         bytes[] memory dynargs = new bytes[](1);
505         dynargs[0] = args[0];
506         return oraclize_query(timestamp, datasource, dynargs);
507     }
508     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         bytes[] memory dynargs = new bytes[](1);
510         dynargs[0] = args[0];
511         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
514         bytes[] memory dynargs = new bytes[](1);
515         dynargs[0] = args[0];
516         return oraclize_query(datasource, dynargs, gaslimit);
517     }
518 
519     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
520         bytes[] memory dynargs = new bytes[](2);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         return oraclize_query(datasource, dynargs);
524     }
525     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
526         bytes[] memory dynargs = new bytes[](2);
527         dynargs[0] = args[0];
528         dynargs[1] = args[1];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](2);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
536     }
537     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
538         bytes[] memory dynargs = new bytes[](2);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         return oraclize_query(datasource, dynargs, gaslimit);
542     }
543     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
544         bytes[] memory dynargs = new bytes[](3);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         return oraclize_query(datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
551         bytes[] memory dynargs = new bytes[](3);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         return oraclize_query(timestamp, datasource, dynargs);
556     }
557     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
558         bytes[] memory dynargs = new bytes[](3);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
563     }
564     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](3);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         return oraclize_query(datasource, dynargs, gaslimit);
570     }
571 
572     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
573         bytes[] memory dynargs = new bytes[](4);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         dynargs[2] = args[2];
577         dynargs[3] = args[3];
578         return oraclize_query(datasource, dynargs);
579     }
580     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
581         bytes[] memory dynargs = new bytes[](4);
582         dynargs[0] = args[0];
583         dynargs[1] = args[1];
584         dynargs[2] = args[2];
585         dynargs[3] = args[3];
586         return oraclize_query(timestamp, datasource, dynargs);
587     }
588     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
589         bytes[] memory dynargs = new bytes[](4);
590         dynargs[0] = args[0];
591         dynargs[1] = args[1];
592         dynargs[2] = args[2];
593         dynargs[3] = args[3];
594         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
595     }
596     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
597         bytes[] memory dynargs = new bytes[](4);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         dynargs[2] = args[2];
601         dynargs[3] = args[3];
602         return oraclize_query(datasource, dynargs, gaslimit);
603     }
604     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](5);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         dynargs[2] = args[2];
609         dynargs[3] = args[3];
610         dynargs[4] = args[4];
611         return oraclize_query(datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](5);
615         dynargs[0] = args[0];
616         dynargs[1] = args[1];
617         dynargs[2] = args[2];
618         dynargs[3] = args[3];
619         dynargs[4] = args[4];
620         return oraclize_query(timestamp, datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623         bytes[] memory dynargs = new bytes[](5);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         dynargs[3] = args[3];
628         dynargs[4] = args[4];
629         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
630     }
631     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](5);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         dynargs[2] = args[2];
636         dynargs[3] = args[3];
637         dynargs[4] = args[4];
638         return oraclize_query(datasource, dynargs, gaslimit);
639     }
640 
641     function oraclize_cbAddress() oraclizeAPI internal returns (address){
642         return oraclize.cbAddress();
643     }
644     function oraclize_setProof(byte proofP) oraclizeAPI internal {
645         return oraclize.setProofType(proofP);
646     }
647     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
648         return oraclize.setCustomGasPrice(gasPrice);
649     }
650 
651     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
652         return oraclize.randomDS_getSessionPubKeyHash();
653     }
654 
655     function getCodeSize(address _addr) constant internal returns(uint _size) {
656         assembly {
657             _size := extcodesize(_addr)
658         }
659     }
660 
661     function parseAddr(string _a) internal pure returns (address){
662         bytes memory tmp = bytes(_a);
663         uint160 iaddr = 0;
664         uint160 b1;
665         uint160 b2;
666         for (uint i=2; i<2+2*20; i+=2){
667             iaddr *= 256;
668             b1 = uint160(tmp[i]);
669             b2 = uint160(tmp[i+1]);
670             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
671             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
672             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
673             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
674             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
675             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
676             iaddr += (b1*16+b2);
677         }
678         return address(iaddr);
679     }
680 
681     function strCompare(string _a, string _b) internal pure returns (int) {
682         bytes memory a = bytes(_a);
683         bytes memory b = bytes(_b);
684         uint minLength = a.length;
685         if (b.length < minLength) minLength = b.length;
686         for (uint i = 0; i < minLength; i ++)
687             if (a[i] < b[i])
688                 return -1;
689             else if (a[i] > b[i])
690                 return 1;
691         if (a.length < b.length)
692             return -1;
693         else if (a.length > b.length)
694             return 1;
695         else
696             return 0;
697     }
698 
699     function indexOf(string _haystack, string _needle) internal pure returns (int) {
700         bytes memory h = bytes(_haystack);
701         bytes memory n = bytes(_needle);
702         if(h.length < 1 || n.length < 1 || (n.length > h.length))
703             return -1;
704         else if(h.length > (2**128 -1))
705             return -1;
706         else
707         {
708             uint subindex = 0;
709             for (uint i = 0; i < h.length; i ++)
710             {
711                 if (h[i] == n[0])
712                 {
713                     subindex = 1;
714                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
715                     {
716                         subindex++;
717                     }
718                     if(subindex == n.length)
719                         return int(i);
720                 }
721             }
722             return -1;
723         }
724     }
725 
726     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
727         bytes memory _ba = bytes(_a);
728         bytes memory _bb = bytes(_b);
729         bytes memory _bc = bytes(_c);
730         bytes memory _bd = bytes(_d);
731         bytes memory _be = bytes(_e);
732         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
733         bytes memory babcde = bytes(abcde);
734         uint k = 0;
735         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
736         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
737         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
738         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
739         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
740         return string(babcde);
741     }
742 
743     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
744         return strConcat(_a, _b, _c, _d, "");
745     }
746 
747     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
748         return strConcat(_a, _b, _c, "", "");
749     }
750 
751     function strConcat(string _a, string _b) internal pure returns (string) {
752         return strConcat(_a, _b, "", "", "");
753     }
754 
755     // parseInt
756     function parseInt(string _a) internal pure returns (uint) {
757         return parseInt(_a, 0);
758     }
759 
760     // parseInt(parseFloat*10^_b)
761     function parseInt(string _a, uint _b) internal pure returns (uint) {
762         bytes memory bresult = bytes(_a);
763         uint mint = 0;
764         bool decimals = false;
765         for (uint i=0; i<bresult.length; i++){
766             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
767                 if (decimals){
768                    if (_b == 0) break;
769                     else _b--;
770                 }
771                 mint *= 10;
772                 mint += uint(bresult[i]) - 48;
773             } else if (bresult[i] == 46) decimals = true;
774         }
775         if (_b > 0) mint *= 10**_b;
776         return mint;
777     }
778 
779     function uint2str(uint i) internal pure returns (string){
780         if (i == 0) return "0";
781         uint j = i;
782         uint len;
783         while (j != 0){
784             len++;
785             j /= 10;
786         }
787         bytes memory bstr = new bytes(len);
788         uint k = len - 1;
789         while (i != 0){
790             bstr[k--] = byte(48 + i % 10);
791             i /= 10;
792         }
793         return string(bstr);
794     }
795 
796     function stra2cbor(string[] arr) internal pure returns (bytes) {
797             uint arrlen = arr.length;
798 
799             // get correct cbor output length
800             uint outputlen = 0;
801             bytes[] memory elemArray = new bytes[](arrlen);
802             for (uint i = 0; i < arrlen; i++) {
803                 elemArray[i] = (bytes(arr[i]));
804                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
805             }
806             uint ctr = 0;
807             uint cborlen = arrlen + 0x80;
808             outputlen += byte(cborlen).length;
809             bytes memory res = new bytes(outputlen);
810 
811             while (byte(cborlen).length > ctr) {
812                 res[ctr] = byte(cborlen)[ctr];
813                 ctr++;
814             }
815             for (i = 0; i < arrlen; i++) {
816                 res[ctr] = 0x5F;
817                 ctr++;
818                 for (uint x = 0; x < elemArray[i].length; x++) {
819                     // if there's a bug with larger strings, this may be the culprit
820                     if (x % 23 == 0) {
821                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
822                         elemcborlen += 0x40;
823                         uint lctr = ctr;
824                         while (byte(elemcborlen).length > ctr - lctr) {
825                             res[ctr] = byte(elemcborlen)[ctr - lctr];
826                             ctr++;
827                         }
828                     }
829                     res[ctr] = elemArray[i][x];
830                     ctr++;
831                 }
832                 res[ctr] = 0xFF;
833                 ctr++;
834             }
835             return res;
836         }
837 
838     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
839             uint arrlen = arr.length;
840 
841             // get correct cbor output length
842             uint outputlen = 0;
843             bytes[] memory elemArray = new bytes[](arrlen);
844             for (uint i = 0; i < arrlen; i++) {
845                 elemArray[i] = (bytes(arr[i]));
846                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
847             }
848             uint ctr = 0;
849             uint cborlen = arrlen + 0x80;
850             outputlen += byte(cborlen).length;
851             bytes memory res = new bytes(outputlen);
852 
853             while (byte(cborlen).length > ctr) {
854                 res[ctr] = byte(cborlen)[ctr];
855                 ctr++;
856             }
857             for (i = 0; i < arrlen; i++) {
858                 res[ctr] = 0x5F;
859                 ctr++;
860                 for (uint x = 0; x < elemArray[i].length; x++) {
861                     // if there's a bug with larger strings, this may be the culprit
862                     if (x % 23 == 0) {
863                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
864                         elemcborlen += 0x40;
865                         uint lctr = ctr;
866                         while (byte(elemcborlen).length > ctr - lctr) {
867                             res[ctr] = byte(elemcborlen)[ctr - lctr];
868                             ctr++;
869                         }
870                     }
871                     res[ctr] = elemArray[i][x];
872                     ctr++;
873                 }
874                 res[ctr] = 0xFF;
875                 ctr++;
876             }
877             return res;
878         }
879 
880 
881     string oraclize_network_name;
882     function oraclize_setNetworkName(string _network_name) internal {
883         oraclize_network_name = _network_name;
884     }
885 
886     function oraclize_getNetworkName() internal view returns (string) {
887         return oraclize_network_name;
888     }
889 
890     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
891         require((_nbytes > 0) && (_nbytes <= 32));
892         // Convert from seconds to ledger timer ticks
893         _delay *= 10; 
894         bytes memory nbytes = new bytes(1);
895         nbytes[0] = byte(_nbytes);
896         bytes memory unonce = new bytes(32);
897         bytes memory sessionKeyHash = new bytes(32);
898         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
899         assembly {
900             mstore(unonce, 0x20)
901             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
902             mstore(sessionKeyHash, 0x20)
903             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
904         }
905         bytes memory delay = new bytes(32);
906         assembly { 
907             mstore(add(delay, 0x20), _delay) 
908         }
909         
910         bytes memory delay_bytes8 = new bytes(8);
911         copyBytes(delay, 24, 8, delay_bytes8, 0);
912 
913         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
914         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
915         
916         bytes memory delay_bytes8_left = new bytes(8);
917         
918         assembly {
919             let x := mload(add(delay_bytes8, 0x20))
920             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
921             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
922             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
923             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
924             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
925             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
926             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
927             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
928 
929         }
930         
931         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
932         return queryId;
933     }
934     
935     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
936         oraclize_randomDS_args[queryId] = commitment;
937     }
938 
939     mapping(bytes32=>bytes32) oraclize_randomDS_args;
940     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
941 
942     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
943         bool sigok;
944         address signer;
945 
946         bytes32 sigr;
947         bytes32 sigs;
948 
949         bytes memory sigr_ = new bytes(32);
950         uint offset = 4+(uint(dersig[3]) - 0x20);
951         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
952         bytes memory sigs_ = new bytes(32);
953         offset += 32 + 2;
954         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
955 
956         assembly {
957             sigr := mload(add(sigr_, 32))
958             sigs := mload(add(sigs_, 32))
959         }
960 
961 
962         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
963         if (address(keccak256(pubkey)) == signer) return true;
964         else {
965             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
966             return (address(keccak256(pubkey)) == signer);
967         }
968     }
969 
970     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
971         bool sigok;
972 
973         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
974         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
975         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
976 
977         bytes memory appkey1_pubkey = new bytes(64);
978         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
979 
980         bytes memory tosign2 = new bytes(1+65+32);
981         tosign2[0] = byte(1); //role
982         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
983         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
984         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
985         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
986 
987         if (sigok == false) return false;
988 
989 
990         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
991         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
992 
993         bytes memory tosign3 = new bytes(1+65);
994         tosign3[0] = 0xFE;
995         copyBytes(proof, 3, 65, tosign3, 1);
996 
997         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
998         copyBytes(proof, 3+65, sig3.length, sig3, 0);
999 
1000         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1001 
1002         return sigok;
1003     }
1004 
1005     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1006         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1007         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1008 
1009         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1010         require(proofVerified);
1011 
1012         _;
1013     }
1014 
1015     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1016         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1017         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1018 
1019         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1020         if (proofVerified == false) return 2;
1021 
1022         return 0;
1023     }
1024 
1025     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1026         bool match_ = true;
1027         
1028         require(prefix.length == n_random_bytes);
1029 
1030         for (uint256 i=0; i< n_random_bytes; i++) {
1031             if (content[i] != prefix[i]) match_ = false;
1032         }
1033 
1034         return match_;
1035     }
1036 
1037     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1038 
1039         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1040         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1041         bytes memory keyhash = new bytes(32);
1042         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1043         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1044 
1045         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1046         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1047 
1048         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1049         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1050 
1051         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1052         // This is to verify that the computed args match with the ones specified in the query.
1053         bytes memory commitmentSlice1 = new bytes(8+1+32);
1054         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1055 
1056         bytes memory sessionPubkey = new bytes(64);
1057         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1058         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1059 
1060         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1061         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1062             delete oraclize_randomDS_args[queryId];
1063         } else return false;
1064 
1065 
1066         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1067         bytes memory tosign1 = new bytes(32+8+1+32);
1068         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1069         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1070 
1071         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1072         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1073             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1074         }
1075 
1076         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1077     }
1078 
1079     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1080     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1081         uint minLength = length + toOffset;
1082 
1083         // Buffer too small
1084         require(to.length >= minLength); // Should be a better way?
1085 
1086         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1087         uint i = 32 + fromOffset;
1088         uint j = 32 + toOffset;
1089 
1090         while (i < (32 + fromOffset + length)) {
1091             assembly {
1092                 let tmp := mload(add(from, i))
1093                 mstore(add(to, j), tmp)
1094             }
1095             i += 32;
1096             j += 32;
1097         }
1098 
1099         return to;
1100     }
1101 
1102     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1103     // Duplicate Solidity's ecrecover, but catching the CALL return value
1104     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1105         // We do our own memory management here. Solidity uses memory offset
1106         // 0x40 to store the current end of memory. We write past it (as
1107         // writes are memory extensions), but don't update the offset so
1108         // Solidity will reuse it. The memory used here is only needed for
1109         // this context.
1110 
1111         // FIXME: inline assembly can't access return values
1112         bool ret;
1113         address addr;
1114 
1115         assembly {
1116             let size := mload(0x40)
1117             mstore(size, hash)
1118             mstore(add(size, 32), v)
1119             mstore(add(size, 64), r)
1120             mstore(add(size, 96), s)
1121 
1122             // NOTE: we can reuse the request memory because we deal with
1123             //       the return code
1124             ret := call(3000, 1, 0, size, 128, size, 32)
1125             addr := mload(size)
1126         }
1127 
1128         return (ret, addr);
1129     }
1130 
1131     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1132     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1133         bytes32 r;
1134         bytes32 s;
1135         uint8 v;
1136 
1137         if (sig.length != 65)
1138           return (false, 0);
1139 
1140         // The signature format is a compact form of:
1141         //   {bytes32 r}{bytes32 s}{uint8 v}
1142         // Compact means, uint8 is not padded to 32 bytes.
1143         assembly {
1144             r := mload(add(sig, 32))
1145             s := mload(add(sig, 64))
1146 
1147             // Here we are loading the last 32 bytes. We exploit the fact that
1148             // 'mload' will pad with zeroes if we overread.
1149             // There is no 'mload8' to do this, but that would be nicer.
1150             v := byte(0, mload(add(sig, 96)))
1151 
1152             // Alternative solution:
1153             // 'byte' is not working due to the Solidity parser, so lets
1154             // use the second best option, 'and'
1155             // v := and(mload(add(sig, 65)), 255)
1156         }
1157 
1158         // albeit non-transactional signatures are not specified by the YP, one would expect it
1159         // to match the YP range of [27, 28]
1160         //
1161         // geth uses [0, 1] and some clients have followed. This might change, see:
1162         //  https://github.com/ethereum/go-ethereum/issues/2053
1163         if (v < 27)
1164           v += 27;
1165 
1166         if (v != 27 && v != 28)
1167             return (false, 0);
1168 
1169         return safer_ecrecover(hash, v, r, s);
1170     }
1171 
1172 }
1173 // </ORACLIZE_API>
1174 
1175 // File: zeppelin-solidity/contracts/math/SafeMath.sol
1176 
1177 /**
1178  * @title SafeMath
1179  * @dev Math operations with safety checks that throw on error
1180  */
1181 library SafeMath {
1182   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1183     uint256 c = a * b;
1184     assert(a == 0 || c / a == b);
1185     return c;
1186   }
1187 
1188   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1189     // assert(b > 0); // Solidity automatically throws when dividing by 0
1190     uint256 c = a / b;
1191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1192     return c;
1193   }
1194 
1195   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1196     assert(b <= a);
1197     return a - b;
1198   }
1199 
1200   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1201     uint256 c = a + b;
1202     assert(c >= a);
1203     return c;
1204   }
1205 }
1206 
1207 // File: mixbytes-solidity/contracts/ownership/multiowned.sol
1208 
1209 // Copyright (C) 2017  MixBytes, LLC
1210 
1211 // Licensed under the Apache License, Version 2.0 (the "License").
1212 // You may not use this file except in compliance with the License.
1213 
1214 // Unless required by applicable law or agreed to in writing, software
1215 // distributed under the License is distributed on an "AS IS" BASIS,
1216 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1217 
1218 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
1219 // Audit, refactoring and improvements by github.com/Eenae
1220 
1221 // @authors:
1222 // Gav Wood <g@ethdev.com>
1223 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
1224 // single, or, crucially, each of a number of, designated owners.
1225 // usage:
1226 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
1227 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
1228 // interior is executed.
1229 
1230 pragma solidity ^0.4.15;
1231 
1232 
1233 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
1234 // TODO acceptOwnership
1235 contract multiowned {
1236 
1237 	// TYPES
1238 
1239     // struct for the status of a pending operation.
1240     struct MultiOwnedOperationPendingState {
1241         // count of confirmations needed
1242         uint yetNeeded;
1243 
1244         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
1245         uint ownersDone;
1246 
1247         // position of this operation key in m_multiOwnedPendingIndex
1248         uint index;
1249     }
1250 
1251 	// EVENTS
1252 
1253     event Confirmation(address owner, bytes32 operation);
1254     event Revoke(address owner, bytes32 operation);
1255     event FinalConfirmation(address owner, bytes32 operation);
1256 
1257     // some others are in the case of an owner changing.
1258     event OwnerChanged(address oldOwner, address newOwner);
1259     event OwnerAdded(address newOwner);
1260     event OwnerRemoved(address oldOwner);
1261 
1262     // the last one is emitted if the required signatures change
1263     event RequirementChanged(uint newRequirement);
1264 
1265 	// MODIFIERS
1266 
1267     // simple single-sig function modifier.
1268     modifier onlyowner {
1269         require(isOwner(msg.sender));
1270         _;
1271     }
1272     // multi-sig function modifier: the operation must have an intrinsic hash in order
1273     // that later attempts can be realised as the same underlying operation and
1274     // thus count as confirmations.
1275     modifier onlymanyowners(bytes32 _operation) {
1276         if (confirmAndCheck(_operation)) {
1277             _;
1278         }
1279         // Even if required number of confirmations has't been collected yet,
1280         // we can't throw here - because changes to the state have to be preserved.
1281         // But, confirmAndCheck itself will throw in case sender is not an owner.
1282     }
1283 
1284     modifier validNumOwners(uint _numOwners) {
1285         require(_numOwners > 0 && _numOwners <= c_maxOwners);
1286         _;
1287     }
1288 
1289     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
1290         require(_required > 0 && _required <= _numOwners);
1291         _;
1292     }
1293 
1294     modifier ownerExists(address _address) {
1295         require(isOwner(_address));
1296         _;
1297     }
1298 
1299     modifier ownerDoesNotExist(address _address) {
1300         require(!isOwner(_address));
1301         _;
1302     }
1303 
1304     modifier multiOwnedOperationIsActive(bytes32 _operation) {
1305         require(isOperationActive(_operation));
1306         _;
1307     }
1308 
1309 	// METHODS
1310 
1311     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
1312     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
1313     function multiowned(address[] _owners, uint _required)
1314         public
1315         validNumOwners(_owners.length)
1316         multiOwnedValidRequirement(_required, _owners.length)
1317     {
1318         assert(c_maxOwners <= 255);
1319 
1320         m_numOwners = _owners.length;
1321         m_multiOwnedRequired = _required;
1322 
1323         for (uint i = 0; i < _owners.length; ++i)
1324         {
1325             address owner = _owners[i];
1326             // invalid and duplicate addresses are not allowed
1327             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
1328 
1329             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
1330             m_owners[currentOwnerIndex] = owner;
1331             m_ownerIndex[owner] = currentOwnerIndex;
1332         }
1333 
1334         assertOwnersAreConsistent();
1335     }
1336 
1337     /// @notice replaces an owner `_from` with another `_to`.
1338     /// @param _from address of owner to replace
1339     /// @param _to address of new owner
1340     // All pending operations will be canceled!
1341     function changeOwner(address _from, address _to)
1342         external
1343         ownerExists(_from)
1344         ownerDoesNotExist(_to)
1345         onlymanyowners(keccak256(msg.data))
1346     {
1347         assertOwnersAreConsistent();
1348 
1349         clearPending();
1350         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
1351         m_owners[ownerIndex] = _to;
1352         m_ownerIndex[_from] = 0;
1353         m_ownerIndex[_to] = ownerIndex;
1354 
1355         assertOwnersAreConsistent();
1356         OwnerChanged(_from, _to);
1357     }
1358 
1359     /// @notice adds an owner
1360     /// @param _owner address of new owner
1361     // All pending operations will be canceled!
1362     function addOwner(address _owner)
1363         external
1364         ownerDoesNotExist(_owner)
1365         validNumOwners(m_numOwners + 1)
1366         onlymanyowners(keccak256(msg.data))
1367     {
1368         assertOwnersAreConsistent();
1369 
1370         clearPending();
1371         m_numOwners++;
1372         m_owners[m_numOwners] = _owner;
1373         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
1374 
1375         assertOwnersAreConsistent();
1376         OwnerAdded(_owner);
1377     }
1378 
1379     /// @notice removes an owner
1380     /// @param _owner address of owner to remove
1381     // All pending operations will be canceled!
1382     function removeOwner(address _owner)
1383         external
1384         ownerExists(_owner)
1385         validNumOwners(m_numOwners - 1)
1386         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
1387         onlymanyowners(keccak256(msg.data))
1388     {
1389         assertOwnersAreConsistent();
1390 
1391         clearPending();
1392         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
1393         m_owners[ownerIndex] = 0;
1394         m_ownerIndex[_owner] = 0;
1395         //make sure m_numOwners is equal to the number of owners and always points to the last owner
1396         reorganizeOwners();
1397 
1398         assertOwnersAreConsistent();
1399         OwnerRemoved(_owner);
1400     }
1401 
1402     /// @notice changes the required number of owner signatures
1403     /// @param _newRequired new number of signatures required
1404     // All pending operations will be canceled!
1405     function changeRequirement(uint _newRequired)
1406         external
1407         multiOwnedValidRequirement(_newRequired, m_numOwners)
1408         onlymanyowners(keccak256(msg.data))
1409     {
1410         m_multiOwnedRequired = _newRequired;
1411         clearPending();
1412         RequirementChanged(_newRequired);
1413     }
1414 
1415     /// @notice Gets an owner by 0-indexed position
1416     /// @param ownerIndex 0-indexed owner position
1417     function getOwner(uint ownerIndex) public constant returns (address) {
1418         return m_owners[ownerIndex + 1];
1419     }
1420 
1421     /// @notice Gets owners
1422     /// @return memory array of owners
1423     function getOwners() public constant returns (address[]) {
1424         address[] memory result = new address[](m_numOwners);
1425         for (uint i = 0; i < m_numOwners; i++)
1426             result[i] = getOwner(i);
1427 
1428         return result;
1429     }
1430 
1431     /// @notice checks if provided address is an owner address
1432     /// @param _addr address to check
1433     /// @return true if it's an owner
1434     function isOwner(address _addr) public constant returns (bool) {
1435         return m_ownerIndex[_addr] > 0;
1436     }
1437 
1438     /// @notice Tests ownership of the current caller.
1439     /// @return true if it's an owner
1440     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
1441     // addOwner/changeOwner and to isOwner.
1442     function amIOwner() external constant onlyowner returns (bool) {
1443         return true;
1444     }
1445 
1446     /// @notice Revokes a prior confirmation of the given operation
1447     /// @param _operation operation value, typically keccak256(msg.data)
1448     function revoke(bytes32 _operation)
1449         external
1450         multiOwnedOperationIsActive(_operation)
1451         onlyowner
1452     {
1453         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1454         var pending = m_multiOwnedPending[_operation];
1455         require(pending.ownersDone & ownerIndexBit > 0);
1456 
1457         assertOperationIsConsistent(_operation);
1458 
1459         pending.yetNeeded++;
1460         pending.ownersDone -= ownerIndexBit;
1461 
1462         assertOperationIsConsistent(_operation);
1463         Revoke(msg.sender, _operation);
1464     }
1465 
1466     /// @notice Checks if owner confirmed given operation
1467     /// @param _operation operation value, typically keccak256(msg.data)
1468     /// @param _owner an owner address
1469     function hasConfirmed(bytes32 _operation, address _owner)
1470         external
1471         constant
1472         multiOwnedOperationIsActive(_operation)
1473         ownerExists(_owner)
1474         returns (bool)
1475     {
1476         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
1477     }
1478 
1479     // INTERNAL METHODS
1480 
1481     function confirmAndCheck(bytes32 _operation)
1482         private
1483         onlyowner
1484         returns (bool)
1485     {
1486         if (512 == m_multiOwnedPendingIndex.length)
1487             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
1488             // we won't be able to do it because of block gas limit.
1489             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
1490             // TODO use more graceful approach like compact or removal of clearPending completely
1491             clearPending();
1492 
1493         var pending = m_multiOwnedPending[_operation];
1494 
1495         // if we're not yet working on this operation, switch over and reset the confirmation status.
1496         if (! isOperationActive(_operation)) {
1497             // reset count of confirmations needed.
1498             pending.yetNeeded = m_multiOwnedRequired;
1499             // reset which owners have confirmed (none) - set our bitmap to 0.
1500             pending.ownersDone = 0;
1501             pending.index = m_multiOwnedPendingIndex.length++;
1502             m_multiOwnedPendingIndex[pending.index] = _operation;
1503             assertOperationIsConsistent(_operation);
1504         }
1505 
1506         // determine the bit to set for this owner.
1507         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
1508         // make sure we (the message sender) haven't confirmed this operation previously.
1509         if (pending.ownersDone & ownerIndexBit == 0) {
1510             // ok - check if count is enough to go ahead.
1511             assert(pending.yetNeeded > 0);
1512             if (pending.yetNeeded == 1) {
1513                 // enough confirmations: reset and run interior.
1514                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
1515                 delete m_multiOwnedPending[_operation];
1516                 FinalConfirmation(msg.sender, _operation);
1517                 return true;
1518             }
1519             else
1520             {
1521                 // not enough: record that this owner in particular confirmed.
1522                 pending.yetNeeded--;
1523                 pending.ownersDone |= ownerIndexBit;
1524                 assertOperationIsConsistent(_operation);
1525                 Confirmation(msg.sender, _operation);
1526             }
1527         }
1528     }
1529 
1530     // Reclaims free slots between valid owners in m_owners.
1531     // TODO given that its called after each removal, it could be simplified.
1532     function reorganizeOwners() private {
1533         uint free = 1;
1534         while (free < m_numOwners)
1535         {
1536             // iterating to the first free slot from the beginning
1537             while (free < m_numOwners && m_owners[free] != 0) free++;
1538 
1539             // iterating to the first occupied slot from the end
1540             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
1541 
1542             // swap, if possible, so free slot is located at the end after the swap
1543             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
1544             {
1545                 // owners between swapped slots should't be renumbered - that saves a lot of gas
1546                 m_owners[free] = m_owners[m_numOwners];
1547                 m_ownerIndex[m_owners[free]] = free;
1548                 m_owners[m_numOwners] = 0;
1549             }
1550         }
1551     }
1552 
1553     function clearPending() private onlyowner {
1554         uint length = m_multiOwnedPendingIndex.length;
1555         // TODO block gas limit
1556         for (uint i = 0; i < length; ++i) {
1557             if (m_multiOwnedPendingIndex[i] != 0)
1558                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
1559         }
1560         delete m_multiOwnedPendingIndex;
1561     }
1562 
1563     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
1564         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
1565         return ownerIndex;
1566     }
1567 
1568     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
1569         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
1570         return 2 ** ownerIndex;
1571     }
1572 
1573     function isOperationActive(bytes32 _operation) private constant returns (bool) {
1574         return 0 != m_multiOwnedPending[_operation].yetNeeded;
1575     }
1576 
1577 
1578     function assertOwnersAreConsistent() private constant {
1579         assert(m_numOwners > 0);
1580         assert(m_numOwners <= c_maxOwners);
1581         assert(m_owners[0] == 0);
1582         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
1583     }
1584 
1585     function assertOperationIsConsistent(bytes32 _operation) private constant {
1586         var pending = m_multiOwnedPending[_operation];
1587         assert(0 != pending.yetNeeded);
1588         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
1589         assert(pending.yetNeeded <= m_multiOwnedRequired);
1590     }
1591 
1592 
1593    	// FIELDS
1594 
1595     uint constant c_maxOwners = 250;
1596 
1597     // the number of owners that must confirm the same operation before it is run.
1598     uint public m_multiOwnedRequired;
1599 
1600 
1601     // pointer used to find a free slot in m_owners
1602     uint public m_numOwners;
1603 
1604     // list of owners (addresses),
1605     // slot 0 is unused so there are no owner which index is 0.
1606     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
1607     address[256] internal m_owners;
1608 
1609     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
1610     mapping(address => uint) internal m_ownerIndex;
1611 
1612 
1613     // the ongoing operations.
1614     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
1615     bytes32[] internal m_multiOwnedPendingIndex;
1616 }
1617 
1618 // File: contracts/EthPriceDependent.sol
1619 
1620 contract EthPriceDependent is usingOraclize, multiowned {
1621 
1622     using SafeMath for uint256;
1623 
1624     event NewOraclizeQuery(string description);
1625     event NewETHPrice(uint price);
1626     event ETHPriceOutOfBounds(uint price);
1627 
1628     /// @notice Constructor
1629     /// @param _initialOwners set owners, which can control bounds and things
1630     ///        described in the actual sale contract, inherited from this one
1631     /// @param _consensus Number of votes enough to make a decision
1632     /// @param _production True if on mainnet and testnet
1633     function EthPriceDependent(address[] _initialOwners,  uint _consensus, bool _production)
1634         public
1635         multiowned(_initialOwners, _consensus)
1636     {
1637         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1638         if (!_production) {
1639             // Use it when testing with testrpc and etherium bridge. Don't forget to change address
1640             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1641         } else {
1642             // Don't call this while testing as it's too long and gets in the way
1643             updateETHPriceInCents();
1644         }
1645     }
1646 
1647     /// @notice Send oraclize query.
1648     /// if price is received successfully - update scheduled automatically,
1649     /// if at any point the contract runs out of ether - updating stops and further
1650     /// updating will require running this function again.
1651     /// if price is out of bounds - updating attempts continue
1652     function updateETHPriceInCents() public payable {
1653         // prohibit running multiple instances of update
1654         // however don't throw any error, because it's called from __callback as well
1655         // and we need to let it update the price anyway, otherwise there is an attack possibility
1656         if ( !updateRequestExpired() ) {
1657             NewOraclizeQuery("Oraclize request fail. Previous one still pending");
1658         } else if (oraclize_getPrice("URL") > this.balance) {
1659             NewOraclizeQuery("Oraclize request fail. Not enough ether");
1660         } else {
1661             oraclize_query(
1662                 m_ETHPriceUpdateInterval,
1663                 "URL",
1664                 "json(https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=USD).0.price_usd",
1665                 m_callbackGas
1666             );
1667             m_ETHPriceLastUpdateRequest = getTime();
1668             NewOraclizeQuery("Oraclize query was sent");
1669         }
1670     }
1671 
1672     /// @notice Called on ETH price update by Oraclize
1673     function __callback(bytes32 myid, string result, bytes proof) public {
1674         require(msg.sender == oraclize_cbAddress());
1675 
1676         uint newPrice = parseInt(result).mul(100);
1677 
1678         if (newPrice >= m_ETHPriceLowerBound && newPrice <= m_ETHPriceUpperBound) {
1679             m_ETHPriceInCents = newPrice;
1680             m_ETHPriceLastUpdate = getTime();
1681             NewETHPrice(m_ETHPriceInCents);
1682         } else {
1683             ETHPriceOutOfBounds(newPrice);
1684         }
1685         // continue updating anyway (if current price was out of bounds, the price might recover in the next cycle)
1686         updateETHPriceInCents();
1687     }
1688 
1689     /// @notice set the limit of ETH in cents, oraclize data greater than this is not accepted
1690     /// @param _price Price in US cents
1691     function setETHPriceUpperBound(uint _price)
1692         external
1693         onlymanyowners(keccak256(msg.data))
1694     {
1695         m_ETHPriceUpperBound = _price;
1696     }
1697 
1698     /// @notice set the limit of ETH in cents, oraclize data smaller than this is not accepted
1699     /// @param _price Price in US cents
1700     function setETHPriceLowerBound(uint _price)
1701         external
1702         onlymanyowners(keccak256(msg.data))
1703     {
1704         m_ETHPriceLowerBound = _price;
1705     }
1706 
1707     /// @notice set the price of ETH in cents, called in case we don't get oraclize data
1708     ///         for more than double the update interval
1709     /// @param _price Price in US cents
1710     function setETHPriceManually(uint _price)
1711         external
1712         onlymanyowners(keccak256(msg.data))
1713     {
1714         // allow for owners to change the price anytime if update is not running
1715         // but if it is, then only in case the price has expired
1716         require( priceExpired() || updateRequestExpired() );
1717         m_ETHPriceInCents = _price;
1718         m_ETHPriceLastUpdate = getTime();
1719         NewETHPrice(m_ETHPriceInCents);
1720     }
1721 
1722     /// @notice add more ether to use in oraclize queries
1723     function topUp() external payable {
1724     }
1725 
1726     /// @dev change gas price for oraclize calls,
1727     ///      should be a compromise between speed and price according to market
1728     /// @param _gasPrice gas price in wei
1729     function setOraclizeGasPrice(uint _gasPrice)
1730         external
1731         onlymanyowners(keccak256(msg.data))
1732     {
1733         oraclize_setCustomGasPrice(_gasPrice);
1734     }
1735 
1736     /// @dev change gas limit for oraclize callback
1737     ///      note: should be changed only in case of emergency
1738     /// @param _callbackGas amount of gas
1739     function setOraclizeGasLimit(uint _callbackGas)
1740         external
1741         onlymanyowners(keccak256(msg.data))
1742     {
1743         m_callbackGas = _callbackGas;
1744     }
1745 
1746     /// @dev Check that double the update interval has passed
1747     ///      since last successful price update
1748     function priceExpired() public view returns (bool) {
1749         return (getTime() > m_ETHPriceLastUpdate + 2 * m_ETHPriceUpdateInterval);
1750     }
1751 
1752     /// @dev Check that price update was requested
1753     ///      more than 1 update interval ago
1754     ///      NOTE: m_leeway seconds added to offset possible timestamp inaccuracy
1755     function updateRequestExpired() public view returns (bool) {
1756         return ( (getTime() + m_leeway) >= (m_ETHPriceLastUpdateRequest + m_ETHPriceUpdateInterval) );
1757     }
1758 
1759     /// @dev to be overridden in tests
1760     function getTime() internal view returns (uint) {
1761         return now;
1762     }
1763 
1764     // FIELDS
1765 
1766     /// @notice usd price of ETH in cents, retrieved using oraclize
1767     uint public m_ETHPriceInCents = 0;
1768     /// @notice unix timestamp of last update
1769     uint public m_ETHPriceLastUpdate;
1770     /// @notice unix timestamp of last update request,
1771     ///         don't allow requesting more than once per update interval
1772     uint public m_ETHPriceLastUpdateRequest;
1773 
1774     /// @notice lower bound of the ETH price in cents
1775     uint public m_ETHPriceLowerBound = 100;
1776     /// @notice upper bound of the ETH price in cents
1777     uint public m_ETHPriceUpperBound = 100000000;
1778 
1779     /// @dev Update ETH price in cents every 12 hours
1780     uint public m_ETHPriceUpdateInterval = 60*60*1;
1781 
1782     /// @dev offset time inaccuracy when checking update expiration date
1783     uint public m_leeway = 900; // 15 minutes is the limit for miners
1784 
1785     /// @dev set just enough gas because the rest is not refunded
1786     uint public m_callbackGas = 200000;
1787 }
1788 
1789 // File: contracts/EthPriceDependentForICO.sol
1790 
1791 contract EthPriceDependentForICO is EthPriceDependent {
1792 
1793     /// @dev overridden price lifetime logic
1794     function priceExpired() public view returns (bool) {
1795         return 0 == m_ETHPriceInCents;
1796     }
1797 }
1798 
1799 // File: mixbytes-solidity/contracts/ownership/MultiownedControlled.sol
1800 
1801 // Copyright (C) 2017  MixBytes, LLC
1802 
1803 // Licensed under the Apache License, Version 2.0 (the "License").
1804 // You may not use this file except in compliance with the License.
1805 
1806 // Unless required by applicable law or agreed to in writing, software
1807 // distributed under the License is distributed on an "AS IS" BASIS,
1808 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1809 
1810 pragma solidity ^0.4.15;
1811 
1812 
1813 
1814 /**
1815  * @title Contract which is owned by owners and operated by controller.
1816  *
1817  * @notice Provides a way to set up an entity (typically other contract) entitled to control actions of this contract.
1818  * Controller is set up by owners or during construction.
1819  *
1820  * @dev controller check is performed by onlyController modifier.
1821  */
1822 contract MultiownedControlled is multiowned {
1823 
1824     event ControllerSet(address controller);
1825     event ControllerRetired(address was);
1826     event ControllerRetiredForever(address was);
1827 
1828 
1829     modifier onlyController {
1830         require(msg.sender == m_controller);
1831         _;
1832     }
1833 
1834 
1835     // PUBLIC interface
1836 
1837     function MultiownedControlled(address[] _owners, uint _signaturesRequired, address _controller)
1838         public
1839         multiowned(_owners, _signaturesRequired)
1840     {
1841         m_controller = _controller;
1842         ControllerSet(m_controller);
1843     }
1844 
1845     /// @dev sets the controller
1846     function setController(address _controller) external onlymanyowners(keccak256(msg.data)) {
1847         require(m_attaching_enabled);
1848         m_controller = _controller;
1849         ControllerSet(m_controller);
1850     }
1851 
1852     /// @dev ability for controller to step down
1853     function detachController() external onlyController {
1854         address was = m_controller;
1855         m_controller = address(0);
1856         ControllerRetired(was);
1857     }
1858 
1859     /// @dev ability for controller to step down and make this contract completely automatic (without third-party control)
1860     function detachControllerForever() external onlyController {
1861         assert(m_attaching_enabled);
1862         address was = m_controller;
1863         m_controller = address(0);
1864         m_attaching_enabled = false;
1865         ControllerRetiredForever(was);
1866     }
1867 
1868 
1869     // FIELDS
1870 
1871     /// @notice address of entity entitled to mint new tokens
1872     address public m_controller;
1873 
1874     bool public m_attaching_enabled = true;
1875 }
1876 
1877 // File: contracts/IBoomstarterToken.sol
1878 
1879 /// @title Interface of the BoomstarterToken.
1880 interface IBoomstarterToken {
1881     // multiowned
1882     function changeOwner(address _from, address _to) external;
1883     function addOwner(address _owner) external;
1884     function removeOwner(address _owner) external;
1885     function changeRequirement(uint _newRequired) external;
1886     function getOwner(uint ownerIndex) public view returns (address);
1887     function getOwners() public view returns (address[]);
1888     function isOwner(address _addr) public view returns (bool);
1889     function amIOwner() external view returns (bool);
1890     function revoke(bytes32 _operation) external;
1891     function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);
1892 
1893     // ERC20Basic
1894     function totalSupply() public view returns (uint256);
1895     function balanceOf(address who) public view returns (uint256);
1896     function transfer(address to, uint256 value) public returns (bool);
1897 
1898     // ERC20
1899     function allowance(address owner, address spender) public view returns (uint256);
1900     function transferFrom(address from, address to, uint256 value) public returns (bool);
1901     function approve(address spender, uint256 value) public returns (bool);
1902 
1903     function name() public view returns (string);
1904     function symbol() public view returns (string);
1905     function decimals() public view returns (uint8);
1906 
1907     // BurnableToken
1908     function burn(uint256 _amount) public returns (bool);
1909 
1910     // TokenWithApproveAndCallMethod
1911     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public;
1912 
1913     // BoomstarterToken
1914     function setSale(address account, bool isSale) external;
1915     function switchToNextSale(address _newSale) external;
1916     function thaw() external;
1917     function disablePrivileged() external;
1918 
1919 }
1920 
1921 // File: contracts/crowdsale/FundsRegistry.sol
1922 
1923 /// @title registry of funds sent by investors
1924 contract FundsRegistry is ArgumentsChecker, MultiownedControlled, ReentrancyGuard {
1925     using SafeMath for uint256;
1926 
1927     enum State {
1928         // gathering funds
1929         GATHERING,
1930         // returning funds to investors
1931         REFUNDING,
1932         // funds can be pulled by owners
1933         SUCCEEDED
1934     }
1935 
1936     event StateChanged(State _state);
1937     event Invested(address indexed investor, uint etherInvested, uint tokensReceived);
1938     event EtherSent(address indexed to, uint value);
1939     event RefundSent(address indexed to, uint value);
1940 
1941 
1942     modifier requiresState(State _state) {
1943         require(m_state == _state);
1944         _;
1945     }
1946 
1947 
1948     // PUBLIC interface
1949 
1950     function FundsRegistry(
1951         address[] _owners,
1952         uint _signaturesRequired,
1953         address _controller,
1954         address _token
1955     )
1956         MultiownedControlled(_owners, _signaturesRequired, _controller)
1957     {
1958         m_token = IBoomstarterToken(_token);
1959     }
1960 
1961     /// @dev performs only allowed state transitions
1962     function changeState(State _newState)
1963         external
1964         onlyController
1965     {
1966         assert(m_state != _newState);
1967 
1968         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
1969         else assert(false);
1970 
1971         m_state = _newState;
1972         StateChanged(m_state);
1973     }
1974 
1975     /// @dev records an investment
1976     /// @param _investor who invested
1977     /// @param _tokenAmount the amount of token bought, calculation is handled by ICO
1978     function invested(address _investor, uint _tokenAmount)
1979         external
1980         payable
1981         onlyController
1982         requiresState(State.GATHERING)
1983     {
1984         uint256 amount = msg.value;
1985         require(0 != amount);
1986         assert(_investor != m_controller);
1987 
1988         // register investor
1989         if (0 == m_weiBalances[_investor])
1990             m_investors.push(_investor);
1991 
1992         // register payment
1993         totalInvested = totalInvested.add(amount);
1994         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
1995         m_tokenBalances[_investor] = m_tokenBalances[_investor].add(_tokenAmount);
1996 
1997         Invested(_investor, amount, _tokenAmount);
1998     }
1999 
2000     /// @notice owners: send `value` of ether to address `to`, can be called if crowdsale succeeded
2001     /// @param to where to send ether
2002     /// @param value amount of wei to send
2003     function sendEther(address to, uint value)
2004         external
2005         validAddress(to)
2006         onlymanyowners(keccak256(msg.data))
2007         requiresState(State.SUCCEEDED)
2008     {
2009         require(value > 0 && this.balance >= value);
2010         to.transfer(value);
2011         EtherSent(to, value);
2012     }
2013 
2014     /// @notice owners: send `value` of tokens to address `to`, can be called if
2015     ///         crowdsale failed and some of the investors refunded the ether
2016     /// @param to where to send tokens
2017     /// @param value amount of token-wei to send
2018     function sendTokens(address to, uint value)
2019         external
2020         validAddress(to)
2021         onlymanyowners(keccak256(msg.data))
2022         requiresState(State.REFUNDING)
2023     {
2024         require(value > 0 && m_token.balanceOf(this) >= value);
2025         m_token.transfer(to, value);
2026     }
2027 
2028     /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
2029     /// @dev caller should approve tokens bought during ICO to this contract
2030     function withdrawPayments()
2031         external
2032         nonReentrant
2033         requiresState(State.REFUNDING)
2034     {
2035         address payee = msg.sender;
2036         uint payment = m_weiBalances[payee];
2037         uint tokens = m_tokenBalances[payee];
2038 
2039         // check that there is some ether to withdraw
2040         require(payment != 0);
2041         // check that the contract holds enough ether
2042         require(this.balance >= payment);
2043         // check that the investor (payee) gives back all tokens bought during ICO
2044         require(m_token.allowance(payee, this) >= m_tokenBalances[payee]);
2045 
2046         totalInvested = totalInvested.sub(payment);
2047         m_weiBalances[payee] = 0;
2048         m_tokenBalances[payee] = 0;
2049 
2050         m_token.transferFrom(payee, this, tokens);
2051 
2052         payee.transfer(payment);
2053         RefundSent(payee, payment);
2054     }
2055 
2056     function getInvestorsCount() external constant returns (uint) { return m_investors.length; }
2057 
2058     // FIELDS
2059 
2060     /// @notice total amount of investments in wei
2061     uint256 public totalInvested;
2062 
2063     /// @notice state of the registry
2064     State public m_state = State.GATHERING;
2065 
2066     /// @dev balances of investors in wei
2067     mapping(address => uint256) public m_weiBalances;
2068 
2069     /// @dev balances of tokens sold to investors
2070     mapping(address => uint256) public m_tokenBalances;
2071 
2072     /// @dev list of unique investors
2073     address[] public m_investors;
2074 
2075     /// @dev token accepted for refunds
2076     IBoomstarterToken public m_token;
2077 }
2078 
2079 // File: minter-service/contracts/IICOInfo.sol
2080 
2081 contract IICOInfo {
2082   function estimate(uint256 _wei) public constant returns (uint tokens);
2083   function purchasedTokenBalanceOf(address addr) public constant returns (uint256 tokens);
2084   function isSaleActive() public constant returns (bool active);
2085 }
2086 
2087 // File: minter-service/contracts/IMintableToken.sol
2088 
2089 contract IMintableToken {
2090     function mint(address _to, uint256 _amount);
2091 }
2092 
2093 // File: contracts/BoomstarterSale.sol
2094 
2095 contract BoomstarterSale is ArgumentsChecker, ReentrancyGuard, EthPriceDependentForICO, IICOInfo, IMintableToken {
2096     using FixedTimeBonuses for FixedTimeBonuses.Data;
2097 
2098     enum IcoState { INIT, ACTIVE, PAUSED, FAILED, SUCCEEDED }
2099 
2100     event StateChanged(IcoState _state);
2101     event FundTransfer(address backer, uint amount, bool isContribution);
2102 
2103 
2104     modifier requiresState(IcoState _state) {
2105         require(m_state == _state);
2106         _;
2107     }
2108 
2109     /// @dev triggers some state changes based on current time
2110     /// @param client optional refund parameter
2111     /// @param payment optional refund parameter
2112     /// @param refundable - if false, payment is made off-chain and shouldn't be refunded
2113     /// note: function body could be skipped!
2114     modifier timedStateChange(address client, uint payment, bool refundable) {
2115         if (IcoState.INIT == m_state && getTime() >= getStartTime())
2116             changeState(IcoState.ACTIVE);
2117 
2118         if (IcoState.ACTIVE == m_state && getTime() >= getFinishTime()) {
2119             finishICOInternal();
2120 
2121             if (refundable && payment > 0)
2122                 client.transfer(payment);
2123             // note that execution of further (but not preceding!) modifiers and functions ends here
2124         } else {
2125             _;
2126         }
2127     }
2128 
2129     /// @dev automatic check for unaccounted withdrawals
2130     /// @param client optional refund parameter
2131     /// @param payment optional refund parameter
2132     /// @param refundable - if false, payment is made off-chain and shouldn't be refunded
2133     modifier fundsChecker(address client, uint payment, bool refundable) {
2134         uint atTheBeginning = m_funds.balance;
2135         if (atTheBeginning < m_lastFundsAmount) {
2136             changeState(IcoState.PAUSED);
2137             if (refundable && payment > 0)
2138                 client.transfer(payment);     // we cant throw (have to save state), so refunding this way
2139             // note that execution of further (but not preceding!) modifiers and functions ends here
2140         } else {
2141             _;
2142 
2143             if (m_funds.balance < atTheBeginning) {
2144                 changeState(IcoState.PAUSED);
2145             } else {
2146                 m_lastFundsAmount = m_funds.balance;
2147             }
2148         }
2149     }
2150 
2151     function estimate(uint256 _wei) public view returns (uint tokens) {
2152         uint amount;
2153         (amount, ) = estimateTokensWithActualPayment(_wei);
2154         return amount;
2155     }
2156 
2157     function isSaleActive() public view returns (bool active) {
2158         return m_state == IcoState.ACTIVE && !priceExpired();
2159     }
2160 
2161     function purchasedTokenBalanceOf(address addr) public view returns (uint256 tokens) {
2162         return m_token.balanceOf(addr);
2163     }
2164 
2165     function getTokenBonus() public view returns (uint percent) {
2166         if (getTime() < 1538341200)     // OCT 1
2167             return 0;
2168         if (getTime() >= getFinishTime())
2169             return 0;
2170 
2171         return m_tokenBonuses.getBonus(getTime());
2172     }
2173 
2174     function ether2tokens(uint ether_) public view returns (uint) {
2175         return ether_.mul(m_ETHPriceInCents).div(c_tokenPriceInCents).mul(getTokenBonus().add(100)).div(100);
2176     }
2177 
2178     function tokens2ether(uint tokens) public view returns (uint) {
2179         return tokens.mul(100).div(getTokenBonus().add(100)).mul(c_tokenPriceInCents).div(m_ETHPriceInCents);
2180     }
2181 
2182     function estimateTokensWithActualPayment(uint256 _payment) public view returns (uint amount, uint actualPayment) {
2183         // amount of bought tokens
2184         uint tokens = ether2tokens(_payment);
2185 
2186         if (tokens.add(m_currentTokensSold) > c_maximumTokensSold) {
2187             tokens = c_maximumTokensSold.sub( m_currentTokensSold );
2188             _payment = tokens2ether(tokens);
2189         }
2190 
2191         return (tokens, _payment);
2192     }
2193 
2194 
2195     // PUBLIC interface
2196 
2197     /**
2198      * @dev constructor
2199      * @param _owners addresses to do administrative actions
2200      * @param _token address of token being sold
2201      * @param _updateInterval time between oraclize price updates in seconds
2202      * @param _production false if using testrpc/ganache, true otherwise
2203      */
2204     constructor(
2205         address[] _owners,
2206         address _token,
2207         uint _updateInterval,
2208         bool _production
2209     )
2210         public
2211         payable
2212         EthPriceDependent(_owners, 2, _production)
2213         validAddress(_token)
2214     {
2215         require(3 == _owners.length);
2216 
2217         m_token = IBoomstarterToken(_token);
2218         m_ETHPriceUpdateInterval = _updateInterval;
2219         m_startTime = getTime();
2220         oraclize_setCustomGasPrice(40*1000*1000*1000);
2221 
2222         m_tokenBonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1538946000 - 1, bonus: 25}));   // up to OCT 8
2223         m_tokenBonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1539550800 - 1, bonus: 15}));   // up to OCT 15
2224         m_tokenBonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1540155600 - 1, bonus: 10}));   // up to OCT 22
2225         m_tokenBonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1541019600 - 1, bonus: 5}));    // up to NOV 1
2226         m_tokenBonuses.bonuses.push(FixedTimeBonuses.Bonus({endTime: 1853960400 - 1, bonus: 0}));    // up to 2028 OCT 1
2227         m_tokenBonuses.validate(true);
2228     }
2229 
2230     /// @dev set addresses for ether and token storage
2231     ///      performed once by deployer
2232     /// @param _funds FundsRegistry address
2233     /// @param _tokenDistributor address to send remaining tokens to after ICO
2234     function init(address _funds, address _tokenDistributor)
2235         external
2236         validAddress(_funds)
2237         validAddress(_tokenDistributor)
2238         onlymanyowners(keccak256(msg.data))
2239     {
2240         require(m_token.balanceOf(this) > 0);   // tokens must be transferred beforehand
2241 
2242         // can be set only once
2243         require(m_funds == address(0));
2244         m_funds = FundsRegistry(_funds);
2245 
2246         // calculate remaining tokens and leave 25% for manual allocation
2247         c_maximumTokensSold = m_token.balanceOf(this).sub( m_token.totalSupply().div(4) );
2248 
2249         // set account that allocates the rest of tokens after ico succeeds
2250         m_tokenDistributor = _tokenDistributor;
2251     }
2252 
2253 
2254     // PUBLIC interface: payments
2255 
2256     // fallback function as a shortcut
2257     function() payable {
2258         require(0 == msg.data.length);
2259         buy();  // only internal call here!
2260     }
2261 
2262     /// @notice ICO participation
2263     function buy() public payable {     // dont mark as external!
2264         internalBuy(msg.sender, msg.value, true);
2265     }
2266 
2267     function mint(address client, uint256 ethers) public {
2268         nonEtherBuy(client, ethers);
2269     }
2270 
2271 
2272     /// @notice register investments coming in different currencies
2273     /// @dev can only be called by a special controller account
2274     /// @param client Account to send tokens to
2275     /// @param etherEquivalentAmount Amount of ether to use to calculate token amount
2276     function nonEtherBuy(address client, uint etherEquivalentAmount)
2277         public
2278     {
2279         require(msg.sender == m_nonEtherController);
2280         // just to check for input errors
2281         require(etherEquivalentAmount <= 70000 ether);
2282         internalBuy(client, etherEquivalentAmount, false);
2283     }
2284 
2285     /// @dev common buy for ether and non-ether
2286     /// @param client who invests
2287     /// @param payment how much ether
2288     /// @param refundable true if invested in ether - using buy()
2289     function internalBuy(address client, uint payment, bool refundable)
2290         internal
2291         nonReentrant
2292         timedStateChange(client, payment, refundable)
2293         fundsChecker(client, payment, refundable)
2294     {
2295         // don't allow to buy anything if price change was too long ago
2296         // effectively enforcing a sale pause
2297         require( !priceExpired() );
2298         require(m_state == IcoState.ACTIVE || m_state == IcoState.INIT && isOwner(client) /* for final test */);
2299 
2300         require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents);
2301 
2302 
2303         uint actualPayment = payment;
2304         uint tokens;
2305 
2306         (tokens, actualPayment) = estimateTokensWithActualPayment(payment);
2307 
2308 
2309         // change ICO investment stats
2310         m_currentTokensSold = m_currentTokensSold.add(tokens);
2311 
2312         // send bought tokens to the client
2313         m_token.transfer(client, tokens);
2314 
2315         assert(m_currentTokensSold <= c_maximumTokensSold);
2316 
2317         if (refundable) {
2318             // record payment if paid in ether
2319             m_funds.invested.value(actualPayment)(client, tokens);
2320             emit FundTransfer(client, actualPayment, true);
2321         }
2322 
2323         // check if ICO must be closed early
2324         if (payment.sub(actualPayment) > 0) {
2325             assert(c_maximumTokensSold == m_currentTokensSold);
2326             finishICOInternal();
2327 
2328             // send change
2329             client.transfer(payment.sub(actualPayment));
2330         } else if (c_maximumTokensSold == m_currentTokensSold) {
2331             finishICOInternal();
2332         }
2333     }
2334 
2335 
2336     // PUBLIC interface: misc getters
2337 
2338     /// @notice start time of the ICO
2339     function getStartTime() public view returns (uint) {
2340         return m_startTime;
2341     }
2342 
2343     /// @notice finish time of the ICO
2344     function getFinishTime() public view returns (uint) {
2345         return m_tokenBonuses.getLastTime();
2346     }
2347 
2348 
2349     // PUBLIC interface: owners: maintenance
2350 
2351     /// @notice pauses ICO
2352     function pause()
2353         external
2354         timedStateChange(address(0), 0, true)
2355         requiresState(IcoState.ACTIVE)
2356         onlyowner
2357     {
2358         changeState(IcoState.PAUSED);
2359     }
2360 
2361     /// @notice resume paused ICO
2362     function unpause()
2363         external
2364         timedStateChange(address(0), 0, true)
2365         requiresState(IcoState.PAUSED)
2366         onlymanyowners(keccak256(msg.data))
2367     {
2368         changeState(IcoState.ACTIVE);
2369         checkTime();
2370     }
2371 
2372     /// @notice withdraw tokens if ico failed
2373     /// @param _to address to send tokens to
2374     /// @param _amount amount of tokens in token-wei
2375     function withdrawTokens(address _to, uint _amount)
2376         external
2377         validAddress(_to)
2378         requiresState(IcoState.FAILED)
2379         onlymanyowners(keccak256(msg.data))
2380     {
2381         require((_amount > 0) && (m_token.balanceOf(this) >= _amount));
2382         m_token.transfer(_to, _amount);
2383     }
2384 
2385     /// @notice In case we need to attach to existent funds
2386     function setFundsRegistry(address _funds)
2387         external
2388         validAddress(_funds)
2389         timedStateChange(address(0), 0, true)
2390         requiresState(IcoState.PAUSED)
2391         onlymanyowners(keccak256(msg.data))
2392     {
2393         m_funds = FundsRegistry(_funds);
2394     }
2395 
2396     /// @notice set non ether investment controller
2397     function setNonEtherController(address _controller)
2398         external
2399         validAddress(_controller)
2400         timedStateChange(address(0), 0, true)
2401         onlymanyowners(keccak256(msg.data))
2402     {
2403         m_nonEtherController = _controller;
2404     }
2405 
2406     function getNonEtherController()
2407         public
2408         view
2409         returns (address)
2410     {
2411         return m_nonEtherController;
2412     }
2413 
2414     /// @notice explicit trigger for timed state changes
2415     function checkTime()
2416         public
2417         timedStateChange(address(0), 0, true)
2418         onlyowner
2419     {
2420     }
2421 
2422     /// @notice send everything to the new (fixed) ico smart contract
2423     /// @param newICO address of the new smart contract
2424     function applyHotFix(address newICO)
2425         public
2426         validAddress(newICO)
2427         requiresState(IcoState.PAUSED)
2428         onlymanyowners(keccak256(msg.data))
2429     {
2430         EthPriceDependent next = EthPriceDependent(newICO);
2431         next.topUp.value(address(this).balance)();
2432         m_token.transfer(newICO, m_token.balanceOf(this));
2433         m_token.switchToNextSale(newICO);
2434     }
2435 
2436     /// @notice withdraw all ether for oraclize payments
2437     /// @param to Address to send ether to
2438     function withdrawEther(address to)
2439         public
2440         validAddress(to)
2441         onlymanyowners(keccak256(msg.data))
2442     {
2443         to.transfer(address(this).balance);
2444     }
2445 
2446     /// @notice finishes ICO
2447     function finishICO()
2448         public
2449         timedStateChange(address(0), 0, true)
2450         requiresState(IcoState.ACTIVE)
2451         onlymanyowners(keccak256(msg.data))
2452     {
2453         finishICOInternal();
2454     }
2455 
2456 
2457     // INTERNAL functions
2458 
2459     function finishICOInternal() private {
2460         changeState(IcoState.SUCCEEDED);
2461     }
2462 
2463     /// @dev performs only allowed state transitions
2464     function changeState(IcoState _newState) private {
2465         assert(m_state != _newState);
2466 
2467         if (IcoState.INIT == m_state) {
2468             assert(IcoState.ACTIVE == _newState);
2469         } else if (IcoState.ACTIVE == m_state) {
2470             assert(
2471                 IcoState.PAUSED == _newState ||
2472                 IcoState.FAILED == _newState ||
2473                 IcoState.SUCCEEDED == _newState
2474             );
2475         } else if (IcoState.PAUSED == m_state) {
2476             assert(IcoState.ACTIVE == _newState || IcoState.FAILED == _newState);
2477         } else {
2478             assert(false);
2479         }
2480 
2481         m_state = _newState;
2482         emit StateChanged(m_state);
2483 
2484         // this should be tightly linked
2485         if (IcoState.SUCCEEDED == m_state) {
2486             onSuccess();
2487         } else if (IcoState.FAILED == m_state) {
2488             onFailure();
2489         }
2490     }
2491 
2492     function onSuccess() private {
2493         // allow owners to withdraw collected ether
2494         m_funds.changeState(FundsRegistry.State.SUCCEEDED);
2495         m_funds.detachController();
2496 
2497         // send all remaining tokens to the address responsible for dividing them into pools
2498         m_token.transfer(m_tokenDistributor, m_token.balanceOf(this));
2499     }
2500 
2501     function onFailure() private {
2502         // allow clients to get their ether back
2503         m_funds.changeState(FundsRegistry.State.REFUNDING);
2504         m_funds.detachController();
2505     }
2506 
2507 
2508     // FIELDS
2509 
2510     /// @notice token bonuses
2511     FixedTimeBonuses.Data m_tokenBonuses;
2512 
2513     /// @notice start time of the sale
2514     uint public m_startTime;
2515 
2516     /// @dev state of the ICO
2517     IcoState public m_state = IcoState.INIT;
2518 
2519     /// @dev contract responsible for token accounting
2520     IBoomstarterToken public m_token;
2521 
2522     /// @dev address responsile for allocation of the tokens left if ICO succeeds
2523     address public m_tokenDistributor;
2524 
2525     /// @dev contract responsible for investments accounting
2526     FundsRegistry public m_funds;
2527 
2528     /// @dev account handling investments in different currencies
2529     address public m_nonEtherController;
2530 
2531     /// @dev last recorded funds
2532     uint public m_lastFundsAmount;
2533 
2534     /// @notice minimum investment in cents
2535     uint public constant c_MinInvestmentInCents = 500; // $5
2536 
2537     /// @notice token price in cents
2538     uint public constant c_tokenPriceInCents = 200; // $2
2539 
2540     /// @notice current amount of tokens sold
2541     uint public m_currentTokensSold;
2542 
2543     /// @dev limit of tokens to be sold during ICO, need to leave 25% for the team
2544     ///      calculated from the current balance and the total supply
2545     uint public c_maximumTokensSold;
2546 }