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
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 
90 /**
91  * @title Destructible
92  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
93  */
94 contract Destructible is Ownable {
95 
96   function Destructible() public payable { }
97 
98   /**
99    * @dev Transfers the current balance to the owner and terminates the contract.
100    */
101   function destroy() onlyOwner public {
102     selfdestruct(owner);
103   }
104 
105   function destroyAndSend(address _recipient) onlyOwner public {
106     selfdestruct(_recipient);
107   }
108 }
109 
110 // <ORACLIZE_API>
111 /*
112 Copyright (c) 2015-2016 Oraclize SRL
113 Copyright (c) 2016 Oraclize LTD
114 
115 
116 
117 Permission is hereby granted, free of charge, to any person obtaining a copy
118 of this software and associated documentation files (the "Software"), to deal
119 in the Software without restriction, including without limitation the rights
120 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
121 copies of the Software, and to permit persons to whom the Software is
122 furnished to do so, subject to the following conditions:
123 
124 
125 
126 The above copyright notice and this permission notice shall be included in
127 all copies or substantial portions of the Software.
128 
129 
130 
131 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
132 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
133 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
134 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
135 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
136 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
137 THE SOFTWARE.
138 */
139 
140 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
141 pragma solidity ^0.4.18;
142 
143 contract OraclizeI {
144     address public cbAddress;
145     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
146     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
147     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
148     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
149     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
150     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
151     function getPrice(string _datasource) public returns (uint _dsprice);
152     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
153     function setProofType(byte _proofType) external;
154     function setCustomGasPrice(uint _gasPrice) external;
155     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
156 }
157 contract OraclizeAddrResolverI {
158     function getAddress() public returns (address _addr);
159 }
160 contract usingOraclize {
161     uint constant day = 60*60*24;
162     uint constant week = 60*60*24*7;
163     uint constant month = 60*60*24*30;
164     byte constant proofType_NONE = 0x00;
165     byte constant proofType_TLSNotary = 0x10;
166     byte constant proofType_Android = 0x20;
167     byte constant proofType_Ledger = 0x30;
168     byte constant proofType_Native = 0xF0;
169     byte constant proofStorage_IPFS = 0x01;
170     uint8 constant networkID_auto = 0;
171     uint8 constant networkID_mainnet = 1;
172     uint8 constant networkID_testnet = 2;
173     uint8 constant networkID_morden = 2;
174     uint8 constant networkID_consensys = 161;
175 
176     OraclizeAddrResolverI OAR;
177 
178     OraclizeI oraclize;
179     modifier oraclizeAPI {
180         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
181             oraclize_setNetwork(networkID_auto);
182 
183         if(address(oraclize) != OAR.getAddress())
184             oraclize = OraclizeI(OAR.getAddress());
185 
186         _;
187     }
188     modifier coupon(string code){
189         oraclize = OraclizeI(OAR.getAddress());
190         _;
191     }
192 
193     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
194       return oraclize_setNetwork();
195       networkID; // silence the warning and remain backwards compatible
196     }
197     function oraclize_setNetwork() internal returns(bool){
198         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
199             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
200             oraclize_setNetworkName("eth_mainnet");
201             return true;
202         }
203         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
204             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
205             oraclize_setNetworkName("eth_ropsten3");
206             return true;
207         }
208         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
209             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
210             oraclize_setNetworkName("eth_kovan");
211             return true;
212         }
213         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
214             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
215             oraclize_setNetworkName("eth_rinkeby");
216             return true;
217         }
218         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
219             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
220             return true;
221         }
222         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
223             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
224             return true;
225         }
226         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
227             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
228             return true;
229         }
230         return false;
231     }
232 
233     function __callback(bytes32 myid, string result) public {
234         __callback(myid, result, new bytes(0));
235     }
236     function __callback(bytes32 myid, string result, bytes proof) public {
237       return;
238       myid; result; proof; // Silence compiler warnings
239     }
240 
241     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
242         return oraclize.getPrice(datasource);
243     }
244 
245     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
246         return oraclize.getPrice(datasource, gaslimit);
247     }
248 
249     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
250         uint price = oraclize.getPrice(datasource);
251         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
252         return oraclize.query.value(price)(0, datasource, arg);
253     }
254     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
255         uint price = oraclize.getPrice(datasource);
256         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
257         return oraclize.query.value(price)(timestamp, datasource, arg);
258     }
259     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
260         uint price = oraclize.getPrice(datasource, gaslimit);
261         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
262         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
263     }
264     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
265         uint price = oraclize.getPrice(datasource, gaslimit);
266         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
267         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
268     }
269     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
270         uint price = oraclize.getPrice(datasource);
271         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
272         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
273     }
274     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
275         uint price = oraclize.getPrice(datasource);
276         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
277         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
278     }
279     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
280         uint price = oraclize.getPrice(datasource, gaslimit);
281         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
282         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
283     }
284     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
285         uint price = oraclize.getPrice(datasource, gaslimit);
286         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
287         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
288     }
289     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
290         uint price = oraclize.getPrice(datasource);
291         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
292         bytes memory args = stra2cbor(argN);
293         return oraclize.queryN.value(price)(0, datasource, args);
294     }
295     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
296         uint price = oraclize.getPrice(datasource);
297         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
298         bytes memory args = stra2cbor(argN);
299         return oraclize.queryN.value(price)(timestamp, datasource, args);
300     }
301     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
302         uint price = oraclize.getPrice(datasource, gaslimit);
303         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
304         bytes memory args = stra2cbor(argN);
305         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
306     }
307     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
308         uint price = oraclize.getPrice(datasource, gaslimit);
309         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
310         bytes memory args = stra2cbor(argN);
311         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
312     }
313     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
314         string[] memory dynargs = new string[](1);
315         dynargs[0] = args[0];
316         return oraclize_query(datasource, dynargs);
317     }
318     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
319         string[] memory dynargs = new string[](1);
320         dynargs[0] = args[0];
321         return oraclize_query(timestamp, datasource, dynargs);
322     }
323     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
324         string[] memory dynargs = new string[](1);
325         dynargs[0] = args[0];
326         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
327     }
328     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
329         string[] memory dynargs = new string[](1);
330         dynargs[0] = args[0];
331         return oraclize_query(datasource, dynargs, gaslimit);
332     }
333 
334     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
335         string[] memory dynargs = new string[](2);
336         dynargs[0] = args[0];
337         dynargs[1] = args[1];
338         return oraclize_query(datasource, dynargs);
339     }
340     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
341         string[] memory dynargs = new string[](2);
342         dynargs[0] = args[0];
343         dynargs[1] = args[1];
344         return oraclize_query(timestamp, datasource, dynargs);
345     }
346     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
347         string[] memory dynargs = new string[](2);
348         dynargs[0] = args[0];
349         dynargs[1] = args[1];
350         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
351     }
352     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
353         string[] memory dynargs = new string[](2);
354         dynargs[0] = args[0];
355         dynargs[1] = args[1];
356         return oraclize_query(datasource, dynargs, gaslimit);
357     }
358     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
359         string[] memory dynargs = new string[](3);
360         dynargs[0] = args[0];
361         dynargs[1] = args[1];
362         dynargs[2] = args[2];
363         return oraclize_query(datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
366         string[] memory dynargs = new string[](3);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         dynargs[2] = args[2];
370         return oraclize_query(timestamp, datasource, dynargs);
371     }
372     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
373         string[] memory dynargs = new string[](3);
374         dynargs[0] = args[0];
375         dynargs[1] = args[1];
376         dynargs[2] = args[2];
377         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
378     }
379     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
380         string[] memory dynargs = new string[](3);
381         dynargs[0] = args[0];
382         dynargs[1] = args[1];
383         dynargs[2] = args[2];
384         return oraclize_query(datasource, dynargs, gaslimit);
385     }
386 
387     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
388         string[] memory dynargs = new string[](4);
389         dynargs[0] = args[0];
390         dynargs[1] = args[1];
391         dynargs[2] = args[2];
392         dynargs[3] = args[3];
393         return oraclize_query(datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
396         string[] memory dynargs = new string[](4);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         dynargs[2] = args[2];
400         dynargs[3] = args[3];
401         return oraclize_query(timestamp, datasource, dynargs);
402     }
403     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
404         string[] memory dynargs = new string[](4);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         dynargs[2] = args[2];
408         dynargs[3] = args[3];
409         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
410     }
411     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
412         string[] memory dynargs = new string[](4);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         dynargs[3] = args[3];
417         return oraclize_query(datasource, dynargs, gaslimit);
418     }
419     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
420         string[] memory dynargs = new string[](5);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         dynargs[3] = args[3];
425         dynargs[4] = args[4];
426         return oraclize_query(datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](5);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         dynargs[2] = args[2];
433         dynargs[3] = args[3];
434         dynargs[4] = args[4];
435         return oraclize_query(timestamp, datasource, dynargs);
436     }
437     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
438         string[] memory dynargs = new string[](5);
439         dynargs[0] = args[0];
440         dynargs[1] = args[1];
441         dynargs[2] = args[2];
442         dynargs[3] = args[3];
443         dynargs[4] = args[4];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](5);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         dynargs[2] = args[2];
451         dynargs[3] = args[3];
452         dynargs[4] = args[4];
453         return oraclize_query(datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
456         uint price = oraclize.getPrice(datasource);
457         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
458         bytes memory args = ba2cbor(argN);
459         return oraclize.queryN.value(price)(0, datasource, args);
460     }
461     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
462         uint price = oraclize.getPrice(datasource);
463         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
464         bytes memory args = ba2cbor(argN);
465         return oraclize.queryN.value(price)(timestamp, datasource, args);
466     }
467     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
468         uint price = oraclize.getPrice(datasource, gaslimit);
469         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
470         bytes memory args = ba2cbor(argN);
471         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
472     }
473     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
474         uint price = oraclize.getPrice(datasource, gaslimit);
475         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
476         bytes memory args = ba2cbor(argN);
477         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
478     }
479     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
480         bytes[] memory dynargs = new bytes[](1);
481         dynargs[0] = args[0];
482         return oraclize_query(datasource, dynargs);
483     }
484     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
485         bytes[] memory dynargs = new bytes[](1);
486         dynargs[0] = args[0];
487         return oraclize_query(timestamp, datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
490         bytes[] memory dynargs = new bytes[](1);
491         dynargs[0] = args[0];
492         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         bytes[] memory dynargs = new bytes[](1);
496         dynargs[0] = args[0];
497         return oraclize_query(datasource, dynargs, gaslimit);
498     }
499 
500     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
501         bytes[] memory dynargs = new bytes[](2);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         return oraclize_query(datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
507         bytes[] memory dynargs = new bytes[](2);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         return oraclize_query(timestamp, datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         bytes[] memory dynargs = new bytes[](2);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
517     }
518     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
519         bytes[] memory dynargs = new bytes[](2);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         return oraclize_query(datasource, dynargs, gaslimit);
523     }
524     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
525         bytes[] memory dynargs = new bytes[](3);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         return oraclize_query(datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
532         bytes[] memory dynargs = new bytes[](3);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         return oraclize_query(timestamp, datasource, dynargs);
537     }
538     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         bytes[] memory dynargs = new bytes[](3);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
544     }
545     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
546         bytes[] memory dynargs = new bytes[](3);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         return oraclize_query(datasource, dynargs, gaslimit);
551     }
552 
553     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
554         bytes[] memory dynargs = new bytes[](4);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         return oraclize_query(datasource, dynargs);
560     }
561     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
562         bytes[] memory dynargs = new bytes[](4);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         return oraclize_query(timestamp, datasource, dynargs);
568     }
569     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         bytes[] memory dynargs = new bytes[](4);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576     }
577     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         bytes[] memory dynargs = new bytes[](4);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         dynargs[3] = args[3];
583         return oraclize_query(datasource, dynargs, gaslimit);
584     }
585     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
586         bytes[] memory dynargs = new bytes[](5);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         dynargs[3] = args[3];
591         dynargs[4] = args[4];
592         return oraclize_query(datasource, dynargs);
593     }
594     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](5);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         dynargs[2] = args[2];
599         dynargs[3] = args[3];
600         dynargs[4] = args[4];
601         return oraclize_query(timestamp, datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
604         bytes[] memory dynargs = new bytes[](5);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         dynargs[4] = args[4];
610         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](5);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         dynargs[4] = args[4];
619         return oraclize_query(datasource, dynargs, gaslimit);
620     }
621 
622     function oraclize_cbAddress() oraclizeAPI internal returns (address){
623         return oraclize.cbAddress();
624     }
625     function oraclize_setProof(byte proofP) oraclizeAPI internal {
626         return oraclize.setProofType(proofP);
627     }
628     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
629         return oraclize.setCustomGasPrice(gasPrice);
630     }
631 
632     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
633         return oraclize.randomDS_getSessionPubKeyHash();
634     }
635 
636     function getCodeSize(address _addr) constant internal returns(uint _size) {
637         assembly {
638             _size := extcodesize(_addr)
639         }
640     }
641 
642     function parseAddr(string _a) internal pure returns (address){
643         bytes memory tmp = bytes(_a);
644         uint160 iaddr = 0;
645         uint160 b1;
646         uint160 b2;
647         for (uint i=2; i<2+2*20; i+=2){
648             iaddr *= 256;
649             b1 = uint160(tmp[i]);
650             b2 = uint160(tmp[i+1]);
651             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
652             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
653             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
654             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
655             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
656             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
657             iaddr += (b1*16+b2);
658         }
659         return address(iaddr);
660     }
661 
662     function strCompare(string _a, string _b) internal pure returns (int) {
663         bytes memory a = bytes(_a);
664         bytes memory b = bytes(_b);
665         uint minLength = a.length;
666         if (b.length < minLength) minLength = b.length;
667         for (uint i = 0; i < minLength; i ++)
668             if (a[i] < b[i])
669                 return -1;
670             else if (a[i] > b[i])
671                 return 1;
672         if (a.length < b.length)
673             return -1;
674         else if (a.length > b.length)
675             return 1;
676         else
677             return 0;
678     }
679 
680     function indexOf(string _haystack, string _needle) internal pure returns (int) {
681         bytes memory h = bytes(_haystack);
682         bytes memory n = bytes(_needle);
683         if(h.length < 1 || n.length < 1 || (n.length > h.length))
684             return -1;
685         else if(h.length > (2**128 -1))
686             return -1;
687         else
688         {
689             uint subindex = 0;
690             for (uint i = 0; i < h.length; i ++)
691             {
692                 if (h[i] == n[0])
693                 {
694                     subindex = 1;
695                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
696                     {
697                         subindex++;
698                     }
699                     if(subindex == n.length)
700                         return int(i);
701                 }
702             }
703             return -1;
704         }
705     }
706 
707     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
708         bytes memory _ba = bytes(_a);
709         bytes memory _bb = bytes(_b);
710         bytes memory _bc = bytes(_c);
711         bytes memory _bd = bytes(_d);
712         bytes memory _be = bytes(_e);
713         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
714         bytes memory babcde = bytes(abcde);
715         uint k = 0;
716         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
717         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
718         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
719         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
720         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
721         return string(babcde);
722     }
723 
724     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
725         return strConcat(_a, _b, _c, _d, "");
726     }
727 
728     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
729         return strConcat(_a, _b, _c, "", "");
730     }
731 
732     function strConcat(string _a, string _b) internal pure returns (string) {
733         return strConcat(_a, _b, "", "", "");
734     }
735 
736     // parseInt
737     function parseInt(string _a) internal pure returns (uint) {
738         return parseInt(_a, 0);
739     }
740 
741     // parseInt(parseFloat*10^_b)
742     function parseInt(string _a, uint _b) internal pure returns (uint) {
743         bytes memory bresult = bytes(_a);
744         uint mint = 0;
745         bool decimals = false;
746         for (uint i=0; i<bresult.length; i++){
747             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
748                 if (decimals){
749                    if (_b == 0) break;
750                     else _b--;
751                 }
752                 mint *= 10;
753                 mint += uint(bresult[i]) - 48;
754             } else if (bresult[i] == 46) decimals = true;
755         }
756         if (_b > 0) mint *= 10**_b;
757         return mint;
758     }
759 
760     function uint2str(uint i) internal pure returns (string){
761         if (i == 0) return "0";
762         uint j = i;
763         uint len;
764         while (j != 0){
765             len++;
766             j /= 10;
767         }
768         bytes memory bstr = new bytes(len);
769         uint k = len - 1;
770         while (i != 0){
771             bstr[k--] = byte(48 + i % 10);
772             i /= 10;
773         }
774         return string(bstr);
775     }
776 
777     function stra2cbor(string[] arr) internal pure returns (bytes) {
778             uint arrlen = arr.length;
779 
780             // get correct cbor output length
781             uint outputlen = 0;
782             bytes[] memory elemArray = new bytes[](arrlen);
783             for (uint i = 0; i < arrlen; i++) {
784                 elemArray[i] = (bytes(arr[i]));
785                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
786             }
787             uint ctr = 0;
788             uint cborlen = arrlen + 0x80;
789             outputlen += byte(cborlen).length;
790             bytes memory res = new bytes(outputlen);
791 
792             while (byte(cborlen).length > ctr) {
793                 res[ctr] = byte(cborlen)[ctr];
794                 ctr++;
795             }
796             for (i = 0; i < arrlen; i++) {
797                 res[ctr] = 0x5F;
798                 ctr++;
799                 for (uint x = 0; x < elemArray[i].length; x++) {
800                     // if there's a bug with larger strings, this may be the culprit
801                     if (x % 23 == 0) {
802                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
803                         elemcborlen += 0x40;
804                         uint lctr = ctr;
805                         while (byte(elemcborlen).length > ctr - lctr) {
806                             res[ctr] = byte(elemcborlen)[ctr - lctr];
807                             ctr++;
808                         }
809                     }
810                     res[ctr] = elemArray[i][x];
811                     ctr++;
812                 }
813                 res[ctr] = 0xFF;
814                 ctr++;
815             }
816             return res;
817         }
818 
819     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
820             uint arrlen = arr.length;
821 
822             // get correct cbor output length
823             uint outputlen = 0;
824             bytes[] memory elemArray = new bytes[](arrlen);
825             for (uint i = 0; i < arrlen; i++) {
826                 elemArray[i] = (bytes(arr[i]));
827                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
828             }
829             uint ctr = 0;
830             uint cborlen = arrlen + 0x80;
831             outputlen += byte(cborlen).length;
832             bytes memory res = new bytes(outputlen);
833 
834             while (byte(cborlen).length > ctr) {
835                 res[ctr] = byte(cborlen)[ctr];
836                 ctr++;
837             }
838             for (i = 0; i < arrlen; i++) {
839                 res[ctr] = 0x5F;
840                 ctr++;
841                 for (uint x = 0; x < elemArray[i].length; x++) {
842                     // if there's a bug with larger strings, this may be the culprit
843                     if (x % 23 == 0) {
844                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
845                         elemcborlen += 0x40;
846                         uint lctr = ctr;
847                         while (byte(elemcborlen).length > ctr - lctr) {
848                             res[ctr] = byte(elemcborlen)[ctr - lctr];
849                             ctr++;
850                         }
851                     }
852                     res[ctr] = elemArray[i][x];
853                     ctr++;
854                 }
855                 res[ctr] = 0xFF;
856                 ctr++;
857             }
858             return res;
859         }
860 
861 
862     string oraclize_network_name;
863     function oraclize_setNetworkName(string _network_name) internal {
864         oraclize_network_name = _network_name;
865     }
866 
867     function oraclize_getNetworkName() internal view returns (string) {
868         return oraclize_network_name;
869     }
870 
871     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
872         require((_nbytes > 0) && (_nbytes <= 32));
873         // Convert from seconds to ledger timer ticks
874         _delay *= 10; 
875         bytes memory nbytes = new bytes(1);
876         nbytes[0] = byte(_nbytes);
877         bytes memory unonce = new bytes(32);
878         bytes memory sessionKeyHash = new bytes(32);
879         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
880         assembly {
881             mstore(unonce, 0x20)
882             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
883             mstore(sessionKeyHash, 0x20)
884             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
885         }
886         bytes memory delay = new bytes(32);
887         assembly { 
888             mstore(add(delay, 0x20), _delay) 
889         }
890         
891         bytes memory delay_bytes8 = new bytes(8);
892         copyBytes(delay, 24, 8, delay_bytes8, 0);
893 
894         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
895         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
896         
897         bytes memory delay_bytes8_left = new bytes(8);
898         
899         assembly {
900             let x := mload(add(delay_bytes8, 0x20))
901             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
902             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
903             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
904             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
905             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
906             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
907             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
908             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
909 
910         }
911         
912         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
913         return queryId;
914     }
915     
916     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
917         oraclize_randomDS_args[queryId] = commitment;
918     }
919 
920     mapping(bytes32=>bytes32) oraclize_randomDS_args;
921     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
922 
923     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
924         bool sigok;
925         address signer;
926 
927         bytes32 sigr;
928         bytes32 sigs;
929 
930         bytes memory sigr_ = new bytes(32);
931         uint offset = 4+(uint(dersig[3]) - 0x20);
932         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
933         bytes memory sigs_ = new bytes(32);
934         offset += 32 + 2;
935         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
936 
937         assembly {
938             sigr := mload(add(sigr_, 32))
939             sigs := mload(add(sigs_, 32))
940         }
941 
942 
943         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
944         if (address(keccak256(pubkey)) == signer) return true;
945         else {
946             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
947             return (address(keccak256(pubkey)) == signer);
948         }
949     }
950 
951     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
952         bool sigok;
953 
954         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
955         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
956         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
957 
958         bytes memory appkey1_pubkey = new bytes(64);
959         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
960 
961         bytes memory tosign2 = new bytes(1+65+32);
962         tosign2[0] = byte(1); //role
963         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
964         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
965         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
966         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
967 
968         if (sigok == false) return false;
969 
970 
971         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
972         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
973 
974         bytes memory tosign3 = new bytes(1+65);
975         tosign3[0] = 0xFE;
976         copyBytes(proof, 3, 65, tosign3, 1);
977 
978         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
979         copyBytes(proof, 3+65, sig3.length, sig3, 0);
980 
981         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
982 
983         return sigok;
984     }
985 
986     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
987         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
988         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
989 
990         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
991         require(proofVerified);
992 
993         _;
994     }
995 
996     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
997         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
998         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
999 
1000         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1001         if (proofVerified == false) return 2;
1002 
1003         return 0;
1004     }
1005 
1006     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1007         bool match_ = true;
1008         
1009         require(prefix.length == n_random_bytes);
1010 
1011         for (uint256 i=0; i< n_random_bytes; i++) {
1012             if (content[i] != prefix[i]) match_ = false;
1013         }
1014 
1015         return match_;
1016     }
1017 
1018     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1019 
1020         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1021         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1022         bytes memory keyhash = new bytes(32);
1023         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1024         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1025 
1026         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1027         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1028 
1029         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1030         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1031 
1032         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1033         // This is to verify that the computed args match with the ones specified in the query.
1034         bytes memory commitmentSlice1 = new bytes(8+1+32);
1035         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1036 
1037         bytes memory sessionPubkey = new bytes(64);
1038         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1039         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1040 
1041         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1042         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1043             delete oraclize_randomDS_args[queryId];
1044         } else return false;
1045 
1046 
1047         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1048         bytes memory tosign1 = new bytes(32+8+1+32);
1049         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1050         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1051 
1052         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1053         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1054             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1055         }
1056 
1057         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1058     }
1059 
1060     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1061     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1062         uint minLength = length + toOffset;
1063 
1064         // Buffer too small
1065         require(to.length >= minLength); // Should be a better way?
1066 
1067         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1068         uint i = 32 + fromOffset;
1069         uint j = 32 + toOffset;
1070 
1071         while (i < (32 + fromOffset + length)) {
1072             assembly {
1073                 let tmp := mload(add(from, i))
1074                 mstore(add(to, j), tmp)
1075             }
1076             i += 32;
1077             j += 32;
1078         }
1079 
1080         return to;
1081     }
1082 
1083     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1084     // Duplicate Solidity's ecrecover, but catching the CALL return value
1085     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1086         // We do our own memory management here. Solidity uses memory offset
1087         // 0x40 to store the current end of memory. We write past it (as
1088         // writes are memory extensions), but don't update the offset so
1089         // Solidity will reuse it. The memory used here is only needed for
1090         // this context.
1091 
1092         // FIXME: inline assembly can't access return values
1093         bool ret;
1094         address addr;
1095 
1096         assembly {
1097             let size := mload(0x40)
1098             mstore(size, hash)
1099             mstore(add(size, 32), v)
1100             mstore(add(size, 64), r)
1101             mstore(add(size, 96), s)
1102 
1103             // NOTE: we can reuse the request memory because we deal with
1104             //       the return code
1105             ret := call(3000, 1, 0, size, 128, size, 32)
1106             addr := mload(size)
1107         }
1108 
1109         return (ret, addr);
1110     }
1111 
1112     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1113     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1114         bytes32 r;
1115         bytes32 s;
1116         uint8 v;
1117 
1118         if (sig.length != 65)
1119           return (false, 0);
1120 
1121         // The signature format is a compact form of:
1122         //   {bytes32 r}{bytes32 s}{uint8 v}
1123         // Compact means, uint8 is not padded to 32 bytes.
1124         assembly {
1125             r := mload(add(sig, 32))
1126             s := mload(add(sig, 64))
1127 
1128             // Here we are loading the last 32 bytes. We exploit the fact that
1129             // 'mload' will pad with zeroes if we overread.
1130             // There is no 'mload8' to do this, but that would be nicer.
1131             v := byte(0, mload(add(sig, 96)))
1132 
1133             // Alternative solution:
1134             // 'byte' is not working due to the Solidity parser, so lets
1135             // use the second best option, 'and'
1136             // v := and(mload(add(sig, 65)), 255)
1137         }
1138 
1139         // albeit non-transactional signatures are not specified by the YP, one would expect it
1140         // to match the YP range of [27, 28]
1141         //
1142         // geth uses [0, 1] and some clients have followed. This might change, see:
1143         //  https://github.com/ethereum/go-ethereum/issues/2053
1144         if (v < 27)
1145           v += 27;
1146 
1147         if (v != 27 && v != 28)
1148             return (false, 0);
1149 
1150         return safer_ecrecover(hash, v, r, s);
1151     }
1152 
1153 }
1154 // </ORACLIZE_API>
1155 
1156 
1157 contract CryptoTreasure is Ownable, Pausable, usingOraclize {
1158 
1159 	uint defaultPrice;
1160 	uint defaultMaxPlayers;
1161 	uint numberOfSpots;
1162 	uint commissionFeePercent;
1163 	uint public current;
1164 	uint commissionEarned;
1165 	uint bonusPool;
1166 	uint bonusPoolPercent;
1167 	uint totalPaidOut;
1168 	uint totalPlayers;
1169 	uint totalGamesEnded;
1170 	uint totalWonGames;
1171 	uint totalRevenue;
1172 	uint totalWithdrawn;
1173 	uint totalPendingWithdrawals;
1174 	uint minimumBalance = 0.001 ether;
1175 	uint gasForOraclize;
1176 	address lastGameEndedBy;
1177 
1178 	struct Game {
1179 		bool Active;
1180 		uint dateStarted;
1181 		uint dateEnded;
1182 		uint dateDistributed;
1183 		uint Balance;
1184 		uint bonusAdded;
1185 		uint maxPlayers;
1186 		uint numberOfPlayers;
1187 		uint Price;
1188 		bool Completed;
1189 		mapping (address => uint) playerToSpot;
1190 		mapping (uint8 => address[]) spotToPlayers;
1191 	}
1192 
1193 	mapping (uint => Game) games;
1194 
1195 	struct Player {
1196 		uint lastGamePlayed;
1197 		uint gamesPlayed;
1198 		uint gamesWon;
1199 		uint amountWon;
1200 		uint pendingWithdrawals;
1201 	}
1202 
1203 	mapping (address => Player) players;
1204 	mapping (bytes32 => uint) oraclizeQueries;
1205 
1206 	event GameStarted(uint indexed game, uint date);
1207 	event GameEnded(uint indexed game, uint date);
1208 	event GameWon(uint indexed game, address indexed player, uint amount, uint date);
1209 	event GameDistributed(uint indexed game, uint8 indexed spot, uint date);
1210 
1211 	function CryptoTreasure() public {
1212 		defaultPrice = 0.05 ether;
1213 		numberOfSpots = 107;
1214 		defaultMaxPlayers = 25;
1215 		commissionFeePercent = 15;
1216 		bonusPoolPercent = 20;
1217 		gasForOraclize = 400000;
1218 		newGame();
1219 	}
1220 
1221 	function newGame() internal {
1222 		current += 1;
1223 		games[current].dateStarted = now;
1224 		games[current].Active = true;
1225 		uint _bonusAmount = getBonusAmount();
1226 		games[current].Balance = _bonusAmount;
1227 		games[current].bonusAdded = _bonusAmount;
1228 		games[current].maxPlayers = defaultMaxPlayers;
1229 		games[current].Price = defaultPrice;
1230 		GameStarted(current, now);
1231 	}
1232 
1233 	function getVariables() public view returns(uint[13]) {
1234 		uint[13] memory array;
1235 		array[0] = current;
1236 		array[1] = (paused == true ? 1 : 0);
1237 		array[2] = games[current].Price;
1238 		array[3] = games[current].maxPlayers;
1239 		array[4] = games[current].numberOfPlayers;
1240 		array[5] = games[current].bonusAdded;
1241 		array[6] = calculateTotalGamePrize();
1242 		array[7] = players[msg.sender].lastGamePlayed;
1243 		array[8] = players[msg.sender].gamesPlayed;
1244 		array[9] = players[msg.sender].gamesWon;
1245 		array[10] = players[msg.sender].amountWon;
1246 		array[11] = players[msg.sender].pendingWithdrawals;
1247 		array[12] = commissionFeePercent;
1248 		return array;
1249 	}
1250 
1251 	function getBonusAmount() internal returns(uint) {
1252 		if (bonusPoolPercent > 0 && bonusPool > 0) {
1253 			uint _amount = (bonusPool / 100) * bonusPoolPercent;
1254 			bonusPool -= _amount;
1255 			return _amount;
1256 		}
1257 	}
1258 
1259 	function hasAlreadyPlayed(address player) public view returns(bool) {
1260 		return (games[current].playerToSpot[player] > 0);
1261 	}
1262 
1263 	function participate(uint8 _spot) public payable whenNotPaused {
1264 
1265 		// Check that current game is active
1266 		require(isGameActive());
1267 
1268 		// Check that the max number of players hasn't been met yet
1269 		require(games[current].numberOfPlayers < games[current].maxPlayers);
1270 
1271 		// Check that the player doesn't exists
1272 		require(hasAlreadyPlayed(msg.sender) == false);
1273 
1274 		// Check that the spot is valid
1275     require(_spot >= 1 && _spot <= numberOfSpots);
1276 
1277 		// Check that the amount paid is equal to the dig price
1278     require(msg.value == games[current].Price);
1279 
1280     games[current].playerToSpot[msg.sender] = _spot;
1281 		games[current].spotToPlayers[_spot].push(msg.sender);
1282     games[current].numberOfPlayers++;
1283 
1284 		uint commission = (msg.value / 100) * commissionFeePercent;
1285     uint balanceAmount = msg.value - commission;
1286     commissionEarned += commission;
1287     totalRevenue+= msg.value;
1288     games[current].Balance += balanceAmount;
1289 
1290 		if (players[msg.sender].gamesPlayed == 0)
1291 			totalPlayers++;
1292 
1293 		players[msg.sender].gamesPlayed++;
1294 		players[msg.sender].lastGamePlayed = current;
1295 
1296 		if (games[current].numberOfPlayers >= games[current].maxPlayers)
1297 			respawnGame();
1298 
1299 	}
1300 
1301 	function __callback(bytes32 queryId, string result) public {
1302   	if (msg.sender != oraclize_cbAddress()) throw;
1303 	  uint8 winningNumber = uint8(parseInt(result));
1304 	  if (games[oraclizeQueries[queryId]].Completed == false) {
1305 	  	games[oraclizeQueries[queryId]].Completed = true;
1306 			distributePrizes(oraclizeQueries[queryId], winningNumber);
1307 			GameDistributed(oraclizeQueries[queryId], winningNumber, now);
1308 	  }
1309   }
1310 
1311 	function generateNumberWinnerQuery() internal {
1312 		bytes32 queryId = oraclize_query("WolframAlpha", "random number between 1 and 107", gasForOraclize);
1313 		oraclizeQueries[queryId] = current;
1314 	}
1315 
1316 	function respawnGame() internal {
1317 		lastGameEndedBy = msg.sender;
1318 		games[current].Active = false;
1319 		games[current].dateEnded = now;
1320 		generateNumberWinnerQuery();
1321 		GameEnded(current, now);
1322 		totalGamesEnded++;
1323 		newGame();
1324 	}
1325 
1326 	function distributePrizes(uint _game, uint8 winnerSpot) internal {
1327 	 	uint totalWinners = games[_game].spotToPlayers[winnerSpot].length;
1328 	 	if (totalWinners > 0) {
1329 	 		totalWonGames++;
1330 			uint winnerAmount = games[_game].Balance / totalWinners;
1331 			for(uint8 i = 0; i < totalWinners; i++) {
1332 				address _address = games[_game].spotToPlayers[winnerSpot][i];
1333 				GameWon(_game, _address, winnerAmount, now);
1334 				players[_address].gamesWon++;
1335 				players[_address].amountWon += winnerAmount;
1336 				if (!_address.send(winnerAmount)) {
1337 					players[_address].pendingWithdrawals += winnerAmount;
1338 					totalPendingWithdrawals += winnerAmount;
1339 				}
1340 				totalPaidOut += winnerAmount;
1341 			}
1342 		} else {
1343 			bonusPool += games[_game].Balance;
1344 		}
1345 		games[_game].dateDistributed = now;
1346 	}
1347 
1348 	function withdraw() public whenNotPaused returns (bool) {
1349 		uint withdrawAmount = players[msg.sender].pendingWithdrawals;
1350 		if (withdrawAmount > 0) {
1351 			players[msg.sender].pendingWithdrawals = 0;
1352 			totalPendingWithdrawals -= withdrawAmount;
1353 			if (msg.sender.send(withdrawAmount)) {
1354 				return true;
1355 			} else {
1356 				players[msg.sender].pendingWithdrawals = withdrawAmount;
1357 				totalPendingWithdrawals += withdrawAmount;
1358 				return false;
1359 			}
1360 		}
1361 	}
1362 
1363 	function getGameBalance() public view returns(uint) {
1364 		return games[current].Balance;
1365 	}
1366 
1367 	function getGameBonusAdded() public view returns(uint) {
1368 		return games[current].bonusAdded;
1369 	}
1370 
1371 	function calculateTotalGamePrize() public view returns(uint) {
1372 		uint total = games[current].maxPlayers * games[current].Price;
1373 		uint commission = (total / 100) * commissionFeePercent;
1374 		return total - commission + games[current].bonusAdded;
1375 	}
1376 
1377 	function getNumberOfPlayersInCurrentGame() public view returns(uint) {
1378 		return games[current].numberOfPlayers;
1379 	}
1380 
1381 	function getPrice() public view returns(uint) {
1382 		return games[current].Price;
1383 	}
1384 
1385 	function getBalance() public view onlyOwner returns(uint) {
1386 		return this.balance;
1387 	}
1388 
1389 	function isGameActive() public view returns(bool) {
1390 		return games[current].Active;
1391 	}
1392 
1393 	function getPlayerInfo() public view returns(uint, uint, uint, uint) {
1394 		return (players[msg.sender].lastGamePlayed, players[msg.sender].gamesPlayed, players[msg.sender].gamesWon, players[msg.sender].amountWon);
1395 	}
1396 
1397 	/* Admin functions below */
1398 
1399 	function endCurrentGame() public onlyOwner {
1400 		respawnGame();
1401 	}
1402 
1403 	function withdrawCommission() public onlyOwner {
1404     require(commissionEarned > minimumBalance);
1405     uint _amount = commissionEarned - minimumBalance;
1406     commissionEarned -= _amount;
1407     totalWithdrawn += _amount;
1408     owner.transfer(_amount);
1409 	}
1410 
1411 	function withdrawBonus(uint _percent) public onlyOwner {
1412     require(bonusPool > 0);
1413     require(_percent > 0 && _percent <= 100);
1414     uint _amount = bonusPool / 100 * _percent;
1415     bonusPool -= _amount;
1416     commissionEarned += _amount;
1417 	}
1418 
1419 	function depositBonus() public payable onlyOwner {
1420     bonusPool += msg.value;
1421 	}
1422 
1423   function withdrawBalanceAmount (uint _amount) public onlyOwner {
1424     owner.transfer(_amount);
1425   }
1426 
1427 	function withdrawAll() public onlyOwner {
1428     owner.transfer(this.balance);
1429 	}
1430 
1431 	function getAdminVariables() public view onlyOwner returns(uint[21]) {
1432 		uint[21] memory array;
1433 		array[0] = this.balance;
1434 		array[1] = defaultPrice;
1435 		array[2] = defaultMaxPlayers;
1436 		array[3] = numberOfSpots;
1437 		array[4] = commissionFeePercent;
1438 		array[5] = current;
1439 		array[6] = commissionEarned;
1440 		array[7] = bonusPool;
1441 		array[8] = bonusPoolPercent;
1442 		array[9] = totalPaidOut;
1443 		array[10] = totalPlayers;
1444 		array[11] = getGameBalance();
1445 		array[12] = getGameBonusAdded();
1446 		array[13] = getNumberOfPlayersInCurrentGame();
1447 		array[14] = totalWonGames;
1448 		array[15] = totalGamesEnded;
1449 		array[16] = totalRevenue;
1450 		array[17] = totalWithdrawn;
1451 		array[18] = totalPendingWithdrawals;
1452 		array[19] = gasForOraclize;
1453 		array[20] = games[current].maxPlayers;
1454 		return array;
1455 	}
1456 
1457 	function setAdminVariables(uint _defaultPrice,
1458 														 uint _defaultMaxPlayers,
1459 														 uint _commissionFeePercent,
1460 														 uint _bonusPoolPercent,
1461 														 uint _gasForOraclize) public onlyOwner {
1462 		if (_defaultPrice > 0) defaultPrice = _defaultPrice;
1463 		if (_defaultMaxPlayers > 0) defaultMaxPlayers = _defaultMaxPlayers;
1464 		if (_commissionFeePercent >= 0 && _commissionFeePercent <= 100) commissionFeePercent = _commissionFeePercent;
1465 		if (_bonusPoolPercent >= 0 && _bonusPoolPercent <= 100) bonusPoolPercent = _bonusPoolPercent;
1466 		if (_gasForOraclize > 0) gasForOraclize = _gasForOraclize;
1467 	}
1468 
1469 	/* Admin function */
1470 	function kill() public onlyOwner() {
1471 		selfdestruct(owner);
1472 	}
1473 
1474 }