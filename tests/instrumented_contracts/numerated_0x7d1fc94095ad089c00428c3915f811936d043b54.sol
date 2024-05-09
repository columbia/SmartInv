1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 
47 
48 /**
49  * @title Destructible
50  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
51  */
52 contract Destructible is Ownable {
53 
54   function Destructible() public payable { }
55 
56   /**
57    * @dev Transfers the current balance to the owner and terminates the contract.
58    */
59   function destroy() onlyOwner public {
60     selfdestruct(owner);
61   }
62 
63   function destroyAndSend(address _recipient) onlyOwner public {
64     selfdestruct(_recipient);
65   }
66 }
67 
68 
69 
70 
71 
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() onlyOwner whenNotPaused public {
105     paused = true;
106     Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused public {
113     paused = false;
114     Unpause();
115   }
116 }
117 
118 // <ORACLIZE_API>
119 /*
120 Copyright (c) 2015-2016 Oraclize SRL
121 Copyright (c) 2016 Oraclize LTD
122 
123 
124 
125 Permission is hereby granted, free of charge, to any person obtaining a copy
126 of this software and associated documentation files (the "Software"), to deal
127 in the Software without restriction, including without limitation the rights
128 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
129 copies of the Software, and to permit persons to whom the Software is
130 furnished to do so, subject to the following conditions:
131 
132 
133 
134 The above copyright notice and this permission notice shall be included in
135 all copies or substantial portions of the Software.
136 
137 
138 
139 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
140 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
141 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
142 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
143 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
144 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
145 THE SOFTWARE.
146 */
147 
148 //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
149 
150 contract OraclizeI {
151     address public cbAddress;
152     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
153     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
154     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
155     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
156     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
157     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
158     function getPrice(string _datasource) returns (uint _dsprice);
159     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
160     function useCoupon(string _coupon);
161     function setProofType(byte _proofType);
162     function setConfig(bytes32 _config);
163     function setCustomGasPrice(uint _gasPrice);
164     function randomDS_getSessionPubKeyHash() returns(bytes32);
165 }
166 contract OraclizeAddrResolverI {
167     function getAddress() returns (address _addr);
168 }
169 contract usingOraclize {
170     uint constant day = 60*60*24;
171     uint constant week = 60*60*24*7;
172     uint constant month = 60*60*24*30;
173     byte constant proofType_NONE = 0x00;
174     byte constant proofType_TLSNotary = 0x10;
175     byte constant proofType_Android = 0x20;
176     byte constant proofType_Ledger = 0x30;
177     byte constant proofType_Native = 0xF0;
178     byte constant proofStorage_IPFS = 0x01;
179     uint8 constant networkID_auto = 0;
180     uint8 constant networkID_mainnet = 1;
181     uint8 constant networkID_testnet = 2;
182     uint8 constant networkID_morden = 2;
183     uint8 constant networkID_consensys = 161;
184 
185     OraclizeAddrResolverI OAR;
186 
187     OraclizeI oraclize;
188     modifier oraclizeAPI {
189         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
190             oraclize_setNetwork(networkID_auto);
191 
192         if(address(oraclize) != OAR.getAddress())
193             oraclize = OraclizeI(OAR.getAddress());
194 
195         _;
196     }
197     modifier coupon(string code){
198         oraclize = OraclizeI(OAR.getAddress());
199         oraclize.useCoupon(code);
200         _;
201     }
202 
203     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
204         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
205             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
206             oraclize_setNetworkName("eth_mainnet");
207             return true;
208         }
209         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
210             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
211             oraclize_setNetworkName("eth_ropsten3");
212             return true;
213         }
214         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
215             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
216             oraclize_setNetworkName("eth_kovan");
217             return true;
218         }
219         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
220             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
221             oraclize_setNetworkName("eth_rinkeby");
222             return true;
223         }
224         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
225             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
226             return true;
227         }
228         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
229             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
230             return true;
231         }
232         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
233             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
234             return true;
235         }
236         return false;
237     }
238 
239     function __callback(bytes32 myid, string result) {
240         __callback(myid, result, new bytes(0));
241     }
242     function __callback(bytes32 myid, string result, bytes proof) {
243     }
244 
245     function oraclize_useCoupon(string code) oraclizeAPI internal {
246         oraclize.useCoupon(code);
247     }
248 
249     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
250         return oraclize.getPrice(datasource);
251     }
252 
253     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
254         return oraclize.getPrice(datasource, gaslimit);
255     }
256 
257     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
258         uint price = oraclize.getPrice(datasource);
259         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
260         return oraclize.query.value(price)(0, datasource, arg);
261     }
262     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
263         uint price = oraclize.getPrice(datasource);
264         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
265         return oraclize.query.value(price)(timestamp, datasource, arg);
266     }
267     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
268         uint price = oraclize.getPrice(datasource, gaslimit);
269         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
270         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
271     }
272     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
273         uint price = oraclize.getPrice(datasource, gaslimit);
274         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
275         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
276     }
277     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
278         uint price = oraclize.getPrice(datasource);
279         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
280         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
281     }
282     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
283         uint price = oraclize.getPrice(datasource);
284         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
285         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
286     }
287     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
288         uint price = oraclize.getPrice(datasource, gaslimit);
289         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
290         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
291     }
292     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
293         uint price = oraclize.getPrice(datasource, gaslimit);
294         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
295         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
296     }
297     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
298         uint price = oraclize.getPrice(datasource);
299         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
300         bytes memory args = stra2cbor(argN);
301         return oraclize.queryN.value(price)(0, datasource, args);
302     }
303     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
304         uint price = oraclize.getPrice(datasource);
305         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
306         bytes memory args = stra2cbor(argN);
307         return oraclize.queryN.value(price)(timestamp, datasource, args);
308     }
309     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
310         uint price = oraclize.getPrice(datasource, gaslimit);
311         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
312         bytes memory args = stra2cbor(argN);
313         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
314     }
315     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
316         uint price = oraclize.getPrice(datasource, gaslimit);
317         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
318         bytes memory args = stra2cbor(argN);
319         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
320     }
321     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
322         string[] memory dynargs = new string[](1);
323         dynargs[0] = args[0];
324         return oraclize_query(datasource, dynargs);
325     }
326     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](1);
328         dynargs[0] = args[0];
329         return oraclize_query(timestamp, datasource, dynargs);
330     }
331     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
332         string[] memory dynargs = new string[](1);
333         dynargs[0] = args[0];
334         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
335     }
336     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
337         string[] memory dynargs = new string[](1);
338         dynargs[0] = args[0];
339         return oraclize_query(datasource, dynargs, gaslimit);
340     }
341 
342     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
343         string[] memory dynargs = new string[](2);
344         dynargs[0] = args[0];
345         dynargs[1] = args[1];
346         return oraclize_query(datasource, dynargs);
347     }
348     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
349         string[] memory dynargs = new string[](2);
350         dynargs[0] = args[0];
351         dynargs[1] = args[1];
352         return oraclize_query(timestamp, datasource, dynargs);
353     }
354     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
355         string[] memory dynargs = new string[](2);
356         dynargs[0] = args[0];
357         dynargs[1] = args[1];
358         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
359     }
360     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
361         string[] memory dynargs = new string[](2);
362         dynargs[0] = args[0];
363         dynargs[1] = args[1];
364         return oraclize_query(datasource, dynargs, gaslimit);
365     }
366     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
367         string[] memory dynargs = new string[](3);
368         dynargs[0] = args[0];
369         dynargs[1] = args[1];
370         dynargs[2] = args[2];
371         return oraclize_query(datasource, dynargs);
372     }
373     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
374         string[] memory dynargs = new string[](3);
375         dynargs[0] = args[0];
376         dynargs[1] = args[1];
377         dynargs[2] = args[2];
378         return oraclize_query(timestamp, datasource, dynargs);
379     }
380     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
381         string[] memory dynargs = new string[](3);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         dynargs[2] = args[2];
385         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
386     }
387     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
388         string[] memory dynargs = new string[](3);
389         dynargs[0] = args[0];
390         dynargs[1] = args[1];
391         dynargs[2] = args[2];
392         return oraclize_query(datasource, dynargs, gaslimit);
393     }
394 
395     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](4);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         dynargs[3] = args[3];
401         return oraclize_query(datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
404         string[] memory dynargs = new string[](4);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         dynargs[2] = args[2];
408         dynargs[3] = args[3];
409         return oraclize_query(timestamp, datasource, dynargs);
410     }
411     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         string[] memory dynargs = new string[](4);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         dynargs[3] = args[3];
417         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
418     }
419     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
420         string[] memory dynargs = new string[](4);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         dynargs[3] = args[3];
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
428         string[] memory dynargs = new string[](5);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         dynargs[3] = args[3];
433         dynargs[4] = args[4];
434         return oraclize_query(datasource, dynargs);
435     }
436     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
437         string[] memory dynargs = new string[](5);
438         dynargs[0] = args[0];
439         dynargs[1] = args[1];
440         dynargs[2] = args[2];
441         dynargs[3] = args[3];
442         dynargs[4] = args[4];
443         return oraclize_query(timestamp, datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](5);
447         dynargs[0] = args[0];
448         dynargs[1] = args[1];
449         dynargs[2] = args[2];
450         dynargs[3] = args[3];
451         dynargs[4] = args[4];
452         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
453     }
454     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](5);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         dynargs[3] = args[3];
460         dynargs[4] = args[4];
461         return oraclize_query(datasource, dynargs, gaslimit);
462     }
463     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
464         uint price = oraclize.getPrice(datasource);
465         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
466         bytes memory args = ba2cbor(argN);
467         return oraclize.queryN.value(price)(0, datasource, args);
468     }
469     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
470         uint price = oraclize.getPrice(datasource);
471         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
472         bytes memory args = ba2cbor(argN);
473         return oraclize.queryN.value(price)(timestamp, datasource, args);
474     }
475     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
476         uint price = oraclize.getPrice(datasource, gaslimit);
477         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
478         bytes memory args = ba2cbor(argN);
479         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
480     }
481     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
482         uint price = oraclize.getPrice(datasource, gaslimit);
483         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
484         bytes memory args = ba2cbor(argN);
485         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
486     }
487     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
488         bytes[] memory dynargs = new bytes[](1);
489         dynargs[0] = args[0];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](1);
494         dynargs[0] = args[0];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         bytes[] memory dynargs = new bytes[](1);
499         dynargs[0] = args[0];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         bytes[] memory dynargs = new bytes[](1);
504         dynargs[0] = args[0];
505         return oraclize_query(datasource, dynargs, gaslimit);
506     }
507 
508     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
509         bytes[] memory dynargs = new bytes[](2);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         return oraclize_query(datasource, dynargs);
513     }
514     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
515         bytes[] memory dynargs = new bytes[](2);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         return oraclize_query(timestamp, datasource, dynargs);
519     }
520     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
521         bytes[] memory dynargs = new bytes[](2);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
525     }
526     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         bytes[] memory dynargs = new bytes[](2);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         return oraclize_query(datasource, dynargs, gaslimit);
531     }
532     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
533         bytes[] memory dynargs = new bytes[](3);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         return oraclize_query(datasource, dynargs);
538     }
539     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
540         bytes[] memory dynargs = new bytes[](3);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         return oraclize_query(timestamp, datasource, dynargs);
545     }
546     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
547         bytes[] memory dynargs = new bytes[](3);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
552     }
553     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         bytes[] memory dynargs = new bytes[](3);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         return oraclize_query(datasource, dynargs, gaslimit);
559     }
560 
561     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](4);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         return oraclize_query(datasource, dynargs);
568     }
569     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
570         bytes[] memory dynargs = new bytes[](4);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         return oraclize_query(timestamp, datasource, dynargs);
576     }
577     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         bytes[] memory dynargs = new bytes[](4);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         dynargs[3] = args[3];
583         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
584     }
585     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
586         bytes[] memory dynargs = new bytes[](4);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         dynargs[3] = args[3];
591         return oraclize_query(datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](5);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         dynargs[3] = args[3];
599         dynargs[4] = args[4];
600         return oraclize_query(datasource, dynargs);
601     }
602     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
603         bytes[] memory dynargs = new bytes[](5);
604         dynargs[0] = args[0];
605         dynargs[1] = args[1];
606         dynargs[2] = args[2];
607         dynargs[3] = args[3];
608         dynargs[4] = args[4];
609         return oraclize_query(timestamp, datasource, dynargs);
610     }
611     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](5);
613         dynargs[0] = args[0];
614         dynargs[1] = args[1];
615         dynargs[2] = args[2];
616         dynargs[3] = args[3];
617         dynargs[4] = args[4];
618         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
619     }
620     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](5);
622         dynargs[0] = args[0];
623         dynargs[1] = args[1];
624         dynargs[2] = args[2];
625         dynargs[3] = args[3];
626         dynargs[4] = args[4];
627         return oraclize_query(datasource, dynargs, gaslimit);
628     }
629 
630     function oraclize_cbAddress() oraclizeAPI internal returns (address){
631         return oraclize.cbAddress();
632     }
633     function oraclize_setProof(byte proofP) oraclizeAPI internal {
634         return oraclize.setProofType(proofP);
635     }
636     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
637         return oraclize.setCustomGasPrice(gasPrice);
638     }
639     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
640         return oraclize.setConfig(config);
641     }
642 
643     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
644         return oraclize.randomDS_getSessionPubKeyHash();
645     }
646 
647     function getCodeSize(address _addr) constant internal returns(uint _size) {
648         assembly {
649             _size := extcodesize(_addr)
650         }
651     }
652 
653     function parseAddr(string _a) internal returns (address){
654         bytes memory tmp = bytes(_a);
655         uint160 iaddr = 0;
656         uint160 b1;
657         uint160 b2;
658         for (uint i=2; i<2+2*20; i+=2){
659             iaddr *= 256;
660             b1 = uint160(tmp[i]);
661             b2 = uint160(tmp[i+1]);
662             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
663             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
664             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
665             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
666             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
667             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
668             iaddr += (b1*16+b2);
669         }
670         return address(iaddr);
671     }
672 
673     function strCompare(string _a, string _b) internal returns (int) {
674         bytes memory a = bytes(_a);
675         bytes memory b = bytes(_b);
676         uint minLength = a.length;
677         if (b.length < minLength) minLength = b.length;
678         for (uint i = 0; i < minLength; i ++)
679             if (a[i] < b[i])
680                 return -1;
681             else if (a[i] > b[i])
682                 return 1;
683         if (a.length < b.length)
684             return -1;
685         else if (a.length > b.length)
686             return 1;
687         else
688             return 0;
689     }
690 
691     function indexOf(string _haystack, string _needle) internal returns (int) {
692         bytes memory h = bytes(_haystack);
693         bytes memory n = bytes(_needle);
694         if(h.length < 1 || n.length < 1 || (n.length > h.length))
695             return -1;
696         else if(h.length > (2**128 -1))
697             return -1;
698         else
699         {
700             uint subindex = 0;
701             for (uint i = 0; i < h.length; i ++)
702             {
703                 if (h[i] == n[0])
704                 {
705                     subindex = 1;
706                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
707                     {
708                         subindex++;
709                     }
710                     if(subindex == n.length)
711                         return int(i);
712                 }
713             }
714             return -1;
715         }
716     }
717 
718     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
719         bytes memory _ba = bytes(_a);
720         bytes memory _bb = bytes(_b);
721         bytes memory _bc = bytes(_c);
722         bytes memory _bd = bytes(_d);
723         bytes memory _be = bytes(_e);
724         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
725         bytes memory babcde = bytes(abcde);
726         uint k = 0;
727         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
728         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
729         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
730         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
731         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
732         return string(babcde);
733     }
734 
735     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
736         return strConcat(_a, _b, _c, _d, "");
737     }
738 
739     function strConcat(string _a, string _b, string _c) internal returns (string) {
740         return strConcat(_a, _b, _c, "", "");
741     }
742 
743     function strConcat(string _a, string _b) internal returns (string) {
744         return strConcat(_a, _b, "", "", "");
745     }
746 
747     // parseInt
748     function parseInt(string _a) internal returns (uint) {
749         return parseInt(_a, 0);
750     }
751 
752     // parseInt(parseFloat*10^_b)
753     function parseInt(string _a, uint _b) internal returns (uint) {
754         bytes memory bresult = bytes(_a);
755         uint mint = 0;
756         bool decimals = false;
757         for (uint i=0; i<bresult.length; i++){
758             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
759                 if (decimals){
760                    if (_b == 0) break;
761                     else _b--;
762                 }
763                 mint *= 10;
764                 mint += uint(bresult[i]) - 48;
765             } else if (bresult[i] == 46) decimals = true;
766         }
767         if (_b > 0) mint *= 10**_b;
768         return mint;
769     }
770 
771     function uint2str(uint i) internal returns (string){
772         if (i == 0) return "0";
773         uint j = i;
774         uint len;
775         while (j != 0){
776             len++;
777             j /= 10;
778         }
779         bytes memory bstr = new bytes(len);
780         uint k = len - 1;
781         while (i != 0){
782             bstr[k--] = byte(48 + i % 10);
783             i /= 10;
784         }
785         return string(bstr);
786     }
787 
788     function stra2cbor(string[] arr) internal returns (bytes) {
789             uint arrlen = arr.length;
790 
791             // get correct cbor output length
792             uint outputlen = 0;
793             bytes[] memory elemArray = new bytes[](arrlen);
794             for (uint i = 0; i < arrlen; i++) {
795                 elemArray[i] = (bytes(arr[i]));
796                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
797             }
798             uint ctr = 0;
799             uint cborlen = arrlen + 0x80;
800             outputlen += byte(cborlen).length;
801             bytes memory res = new bytes(outputlen);
802 
803             while (byte(cborlen).length > ctr) {
804                 res[ctr] = byte(cborlen)[ctr];
805                 ctr++;
806             }
807             for (i = 0; i < arrlen; i++) {
808                 res[ctr] = 0x5F;
809                 ctr++;
810                 for (uint x = 0; x < elemArray[i].length; x++) {
811                     // if there's a bug with larger strings, this may be the culprit
812                     if (x % 23 == 0) {
813                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
814                         elemcborlen += 0x40;
815                         uint lctr = ctr;
816                         while (byte(elemcborlen).length > ctr - lctr) {
817                             res[ctr] = byte(elemcborlen)[ctr - lctr];
818                             ctr++;
819                         }
820                     }
821                     res[ctr] = elemArray[i][x];
822                     ctr++;
823                 }
824                 res[ctr] = 0xFF;
825                 ctr++;
826             }
827             return res;
828         }
829 
830     function ba2cbor(bytes[] arr) internal returns (bytes) {
831             uint arrlen = arr.length;
832 
833             // get correct cbor output length
834             uint outputlen = 0;
835             bytes[] memory elemArray = new bytes[](arrlen);
836             for (uint i = 0; i < arrlen; i++) {
837                 elemArray[i] = (bytes(arr[i]));
838                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
839             }
840             uint ctr = 0;
841             uint cborlen = arrlen + 0x80;
842             outputlen += byte(cborlen).length;
843             bytes memory res = new bytes(outputlen);
844 
845             while (byte(cborlen).length > ctr) {
846                 res[ctr] = byte(cborlen)[ctr];
847                 ctr++;
848             }
849             for (i = 0; i < arrlen; i++) {
850                 res[ctr] = 0x5F;
851                 ctr++;
852                 for (uint x = 0; x < elemArray[i].length; x++) {
853                     // if there's a bug with larger strings, this may be the culprit
854                     if (x % 23 == 0) {
855                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
856                         elemcborlen += 0x40;
857                         uint lctr = ctr;
858                         while (byte(elemcborlen).length > ctr - lctr) {
859                             res[ctr] = byte(elemcborlen)[ctr - lctr];
860                             ctr++;
861                         }
862                     }
863                     res[ctr] = elemArray[i][x];
864                     ctr++;
865                 }
866                 res[ctr] = 0xFF;
867                 ctr++;
868             }
869             return res;
870         }
871 
872 
873     string oraclize_network_name;
874     function oraclize_setNetworkName(string _network_name) internal {
875         oraclize_network_name = _network_name;
876     }
877 
878     function oraclize_getNetworkName() internal returns (string) {
879         return oraclize_network_name;
880     }
881 
882     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
883         if ((_nbytes == 0)||(_nbytes > 32)) throw;
884 	// Convert from seconds to ledger timer ticks
885         _delay *= 10;
886         bytes memory nbytes = new bytes(1);
887         nbytes[0] = byte(_nbytes);
888         bytes memory unonce = new bytes(32);
889         bytes memory sessionKeyHash = new bytes(32);
890         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
891         assembly {
892             mstore(unonce, 0x20)
893             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
894             mstore(sessionKeyHash, 0x20)
895             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
896         }
897         bytes memory delay = new bytes(32);
898         assembly {
899             mstore(add(delay, 0x20), _delay)
900         }
901 
902         bytes memory delay_bytes8 = new bytes(8);
903         copyBytes(delay, 24, 8, delay_bytes8, 0);
904 
905         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
906         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
907 
908         bytes memory delay_bytes8_left = new bytes(8);
909 
910         assembly {
911             let x := mload(add(delay_bytes8, 0x20))
912             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
913             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
914             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
915             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
916             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
917             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
918             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
919             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
920 
921         }
922 
923         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
924         return queryId;
925     }
926 
927     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
928         oraclize_randomDS_args[queryId] = commitment;
929     }
930 
931     mapping(bytes32=>bytes32) oraclize_randomDS_args;
932     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
933 
934     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
935         bool sigok;
936         address signer;
937 
938         bytes32 sigr;
939         bytes32 sigs;
940 
941         bytes memory sigr_ = new bytes(32);
942         uint offset = 4+(uint(dersig[3]) - 0x20);
943         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
944         bytes memory sigs_ = new bytes(32);
945         offset += 32 + 2;
946         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
947 
948         assembly {
949             sigr := mload(add(sigr_, 32))
950             sigs := mload(add(sigs_, 32))
951         }
952 
953 
954         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
955         if (address(sha3(pubkey)) == signer) return true;
956         else {
957             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
958             return (address(sha3(pubkey)) == signer);
959         }
960     }
961 
962     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
963         bool sigok;
964 
965         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
966         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
967         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
968 
969         bytes memory appkey1_pubkey = new bytes(64);
970         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
971 
972         bytes memory tosign2 = new bytes(1+65+32);
973         tosign2[0] = 1; //role
974         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
975         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
976         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
977         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
978 
979         if (sigok == false) return false;
980 
981 
982         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
983         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
984 
985         bytes memory tosign3 = new bytes(1+65);
986         tosign3[0] = 0xFE;
987         copyBytes(proof, 3, 65, tosign3, 1);
988 
989         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
990         copyBytes(proof, 3+65, sig3.length, sig3, 0);
991 
992         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
993 
994         return sigok;
995     }
996 
997     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
998         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
999         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1000 
1001         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1002         if (proofVerified == false) throw;
1003 
1004         _;
1005     }
1006 
1007     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1008         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1009         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1010 
1011         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1012         if (proofVerified == false) return 2;
1013 
1014         return 0;
1015     }
1016 
1017     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1018         bool match_ = true;
1019 
1020 	if (prefix.length != n_random_bytes) throw;
1021 
1022         for (uint256 i=0; i< n_random_bytes; i++) {
1023             if (content[i] != prefix[i]) match_ = false;
1024         }
1025 
1026         return match_;
1027     }
1028 
1029     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1030 
1031         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1032         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1033         bytes memory keyhash = new bytes(32);
1034         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1035         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1036 
1037         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1038         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1039 
1040         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1041         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1042 
1043         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1044         // This is to verify that the computed args match with the ones specified in the query.
1045         bytes memory commitmentSlice1 = new bytes(8+1+32);
1046         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1047 
1048         bytes memory sessionPubkey = new bytes(64);
1049         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1050         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1051 
1052         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1053         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1054             delete oraclize_randomDS_args[queryId];
1055         } else return false;
1056 
1057 
1058         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1059         bytes memory tosign1 = new bytes(32+8+1+32);
1060         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1061         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1062 
1063         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1064         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1065             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1066         }
1067 
1068         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1069     }
1070 
1071 
1072     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1073     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1074         uint minLength = length + toOffset;
1075 
1076         if (to.length < minLength) {
1077             // Buffer too small
1078             throw; // Should be a better way?
1079         }
1080 
1081         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1082         uint i = 32 + fromOffset;
1083         uint j = 32 + toOffset;
1084 
1085         while (i < (32 + fromOffset + length)) {
1086             assembly {
1087                 let tmp := mload(add(from, i))
1088                 mstore(add(to, j), tmp)
1089             }
1090             i += 32;
1091             j += 32;
1092         }
1093 
1094         return to;
1095     }
1096 
1097     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1098     // Duplicate Solidity's ecrecover, but catching the CALL return value
1099     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1100         // We do our own memory management here. Solidity uses memory offset
1101         // 0x40 to store the current end of memory. We write past it (as
1102         // writes are memory extensions), but don't update the offset so
1103         // Solidity will reuse it. The memory used here is only needed for
1104         // this context.
1105 
1106         // FIXME: inline assembly can't access return values
1107         bool ret;
1108         address addr;
1109 
1110         assembly {
1111             let size := mload(0x40)
1112             mstore(size, hash)
1113             mstore(add(size, 32), v)
1114             mstore(add(size, 64), r)
1115             mstore(add(size, 96), s)
1116 
1117             // NOTE: we can reuse the request memory because we deal with
1118             //       the return code
1119             ret := call(3000, 1, 0, size, 128, size, 32)
1120             addr := mload(size)
1121         }
1122 
1123         return (ret, addr);
1124     }
1125 
1126     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1127     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1128         bytes32 r;
1129         bytes32 s;
1130         uint8 v;
1131 
1132         if (sig.length != 65)
1133           return (false, 0);
1134 
1135         // The signature format is a compact form of:
1136         //   {bytes32 r}{bytes32 s}{uint8 v}
1137         // Compact means, uint8 is not padded to 32 bytes.
1138         assembly {
1139             r := mload(add(sig, 32))
1140             s := mload(add(sig, 64))
1141 
1142             // Here we are loading the last 32 bytes. We exploit the fact that
1143             // 'mload' will pad with zeroes if we overread.
1144             // There is no 'mload8' to do this, but that would be nicer.
1145             v := byte(0, mload(add(sig, 96)))
1146 
1147             // Alternative solution:
1148             // 'byte' is not working due to the Solidity parser, so lets
1149             // use the second best option, 'and'
1150             // v := and(mload(add(sig, 65)), 255)
1151         }
1152 
1153         // albeit non-transactional signatures are not specified by the YP, one would expect it
1154         // to match the YP range of [27, 28]
1155         //
1156         // geth uses [0, 1] and some clients have followed. This might change, see:
1157         //  https://github.com/ethereum/go-ethereum/issues/2053
1158         if (v < 27)
1159           v += 27;
1160 
1161         if (v != 27 && v != 28)
1162             return (false, 0);
1163 
1164         return safer_ecrecover(hash, v, r, s);
1165     }
1166 
1167 }
1168 // </ORACLIZE_API>
1169 
1170 contract CryptoTreasure is Pausable, Destructible, usingOraclize {
1171 
1172 	uint currentGame = 1;
1173 	uint playPrice = 0.05 ether;
1174 	uint numberOfSpots = 107;
1175 	uint public currentTreasure;
1176 	uint initialTreasure = 2.5 ether;
1177 	uint totalPaidOut;
1178 	uint totalPlayers;
1179 	uint totalGamesEnded;
1180 	uint totalGamesWon;
1181 	uint totalGamesLost;
1182 	uint totalWagered;
1183 	uint totalPendingWithdrawals;
1184 	uint gasForOraclize = 200000;
1185 	uint restakePercent = 1027;
1186 
1187 	struct Player {
1188 		uint lastGamePlayed;
1189 		uint gamesPlayed;
1190 		uint gamesWon;
1191 		uint gamesLost;
1192 		uint amountWon;
1193 		uint pendingWithdrawals;
1194 		uint lastGameStatus;
1195 	}
1196 
1197 	struct Game {
1198 		uint Id;
1199 		uint Date;
1200 		uint Spot;
1201 		bool Ended;
1202 		bool Won;
1203 		address Player;
1204 	}
1205 
1206 	mapping (uint => Game) games;
1207 	mapping (address => Player) players;
1208 	mapping (bytes32 => uint) oraclizeQueries;
1209 
1210 	event GameWon(uint indexed game, address indexed player, uint amount, uint date);
1211 	event GameEnded(uint indexed game, address indexed player, uint date, uint8 number);
1212 
1213 	function CryptoTreasure() public {
1214 		oraclize_setNetwork(networkID_consensys);
1215 	}
1216 
1217 	function getVariables() public view returns(uint[11]) {
1218 		uint[11] memory array;
1219 		array[0] = (paused == true ? 1 : 0);
1220 		array[1] = playPrice;
1221 		array[2] = currentTreasure;
1222 		array[3] = players[msg.sender].lastGamePlayed;
1223 		array[4] = players[msg.sender].gamesPlayed;
1224 		array[5] = players[msg.sender].gamesWon;
1225 		array[6] = players[msg.sender].gamesLost;
1226 		array[7] = players[msg.sender].amountWon;
1227 		array[8] = players[msg.sender].pendingWithdrawals;
1228 		array[9] = players[msg.sender].lastGameStatus;
1229 		array[10] = totalPaidOut;
1230 		return array;
1231 	}
1232 
1233 	function initializeTreasure(uint _amount) internal {
1234 		if (_amount > 0) {
1235 			if (this.balance > _amount + totalPendingWithdrawals)
1236 				currentTreasure = _amount;
1237 			else
1238 				paused = true;
1239 		}
1240 	}
1241 
1242 	function participate(uint8 _spot) public payable whenNotPaused {
1243     require(_spot >= 1 && _spot <= numberOfSpots);
1244     require(msg.value == playPrice);
1245 
1246 		uint _restake = msg.value / 100 / 100 * restakePercent;
1247     currentTreasure += _restake;
1248     totalWagered += msg.value;
1249 
1250 		if (players[msg.sender].gamesPlayed == 0)
1251 			totalPlayers++;
1252 		players[msg.sender].gamesPlayed++;
1253 
1254 	  games[currentGame].Id = currentGame;
1255 		games[currentGame].Date = now;
1256 		games[currentGame].Spot = _spot;
1257 		games[currentGame].Player = msg.sender;
1258 
1259 	  finishGame(currentGame);
1260 		currentGame++;
1261 	}
1262 
1263   function __callback(bytes32 queryId, string result) public {
1264   	assert(msg.sender == oraclize_cbAddress());
1265 		uint gameId = oraclizeQueries[queryId];
1266 		uint8 winningNumber = uint8(parseInt(result));
1267 		distributeGame(winningNumber, gameId);
1268   }
1269 
1270   function distributeGame(uint8 winningNumber, uint gameId) internal {
1271   	require(games[gameId].Ended == false);
1272   	require(games[gameId].Player != 0x0);
1273 		games[gameId].Ended = true;
1274 		address _address = games[gameId].Player;
1275 
1276 		if (games[gameId].Spot == winningNumber) {
1277 
1278 			uint winningAmount = currentTreasure;
1279 			currentTreasure = 0;
1280 			games[gameId].Won = true;
1281 			players[_address].gamesWon++;
1282 			players[_address].amountWon += winningAmount;
1283 			players[_address].lastGameStatus = 1;
1284 			GameWon(gameId, _address, winningAmount, now);
1285 			if (!_address.send(winningAmount)) {
1286 				players[_address].pendingWithdrawals += winningAmount;
1287 				totalPendingWithdrawals += winningAmount;
1288 			}
1289 			totalPaidOut += winningAmount;
1290 			totalGamesWon++;
1291 			initializeTreasure(initialTreasure);
1292 
1293 		} else {
1294 			games[gameId].Won = false;
1295 			players[_address].gamesLost++;
1296 			players[_address].lastGameStatus = 2;
1297 			totalGamesLost++;
1298 		}
1299 
1300 		players[_address].lastGamePlayed = gameId;
1301 		GameEnded(gameId, _address, now, winningNumber);
1302 		totalGamesEnded++;
1303   }
1304 
1305 	function finishGame(uint gameId) internal {
1306 		require(games[gameId].Ended == false);
1307 		bytes32 queryId = oraclize_query("nested", "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateIntegers\",\"params\":{\"apiKey\":\"${[decrypt] BFa/zWup+t1GegCMaZO/Tx433Go5RruGsY5Kikog/3HpGfQRkxEaIzcLlY28YgCiNsR/FdeHyQFqAKiPrRvLSGqL4tPFla1p71fEwxFYqhiu2Yrxqlk8vz//fA87oJ6eu+aL6ze3HihJpi3LQ+7j4k5EnoEq}\",\"n\":1,\"min\":1,\"max\":107,\"replacement\":true${[identity] \"}\"},\"id\":1${[identity] \"}\"}']");
1308 		oraclizeQueries[queryId] = gameId;
1309 	}
1310 
1311 	function withdraw() public whenNotPaused returns (bool) {
1312 		uint withdrawAmount = players[msg.sender].pendingWithdrawals;
1313 		if (withdrawAmount > 0) {
1314 			players[msg.sender].pendingWithdrawals = 0;
1315 			totalPendingWithdrawals -= withdrawAmount;
1316 			if (msg.sender.send(withdrawAmount)) {
1317 				return true;
1318 			} else {
1319 				players[msg.sender].pendingWithdrawals = withdrawAmount;
1320 				totalPendingWithdrawals += withdrawAmount;
1321 				return false;
1322 			}
1323 		}
1324 	}
1325 
1326 	/* Admin functions below */
1327 
1328 	function withdraw(uint _amount) public onlyOwner {
1329 		require(_amount <= this.balance - currentTreasure - totalPendingWithdrawals);
1330     owner.transfer(_amount);
1331 	}
1332 
1333 	function deposit() public payable onlyOwner {
1334 	}
1335 
1336 	function getAdminVariables() public view onlyOwner returns(uint[14]) {
1337 		uint[14] memory array;
1338 		array[0] = this.balance;
1339 		array[1] = playPrice;
1340 		array[2] = initialTreasure;
1341 		array[3] = currentGame;
1342 		array[4] = totalPaidOut;
1343 		array[5] = totalPlayers;
1344 		array[6] = currentTreasure;
1345 		array[7] = totalGamesEnded;
1346 		array[8] = totalGamesWon;
1347 		array[9] = totalGamesLost;
1348 		array[10] = totalWagered;
1349 		array[11] = totalPendingWithdrawals;
1350 		array[12] = gasForOraclize;
1351 		array[13] = restakePercent;
1352 		return array;
1353 	}
1354 
1355 	function setAdminVariables(uint _playPrice,
1356 														 uint _initialTreasure,
1357 														 uint _restakePercent,
1358 														 uint _gasForOraclize) public onlyOwner {
1359 		if (_playPrice > 0) playPrice = _playPrice;
1360 		if (_initialTreasure > 0) initialTreasure = _initialTreasure;
1361 		if (_restakePercent > 0) restakePercent = _restakePercent;
1362 		if (_gasForOraclize > 0) gasForOraclize = _gasForOraclize;
1363 	}
1364 
1365 	function getUnfinishedGames() public view onlyOwner returns (uint[], uint[], uint[], bool[], bool[], address[]) {
1366 		uint totalUnfinished = 0;
1367 		uint i = 0;
1368 		for (i = 0; i < currentGame; i++) {
1369 			if (games[i].Ended == false && games[i].Id > 0)
1370 				totalUnfinished++;
1371 		}
1372 		uint[] memory arrId = new uint[](totalUnfinished);
1373 		uint[] memory arrDate = new uint[](totalUnfinished);
1374 		uint[] memory arrSpot = new uint[](totalUnfinished);
1375 		bool[] memory arrEnded = new bool[](totalUnfinished);
1376 		bool[] memory arrWon = new bool[](totalUnfinished);
1377 		address[] memory arrPlayer = new address[](totalUnfinished);
1378 		uint g = 0;
1379 		for (i = 0; i < currentGame; i++) {
1380 			if (games[i].Ended == false && games[i].Id > 0) {
1381 				arrId[g] = games[i].Id;
1382 				arrDate[g] = games[i].Date;
1383 				arrSpot[g] = games[i].Spot;
1384 				arrEnded[g] = games[i].Ended;
1385 				arrWon[g] = games[i].Won;
1386 				arrPlayer[g] = games[i].Player;
1387 				g++;
1388 			}
1389 		}
1390 		return (arrId, arrDate, arrSpot, arrEnded, arrWon, arrPlayer);
1391 	}
1392 
1393 	function manualFinishGame(uint gameId) public onlyOwner {
1394 		finishGame(gameId);
1395 	}
1396 
1397 	function manualInitializeTreasure(uint _amount) public onlyOwner {
1398 		require(this.balance > _amount + totalPendingWithdrawals);
1399 		initializeTreasure(_amount);
1400 	}
1401 
1402 }