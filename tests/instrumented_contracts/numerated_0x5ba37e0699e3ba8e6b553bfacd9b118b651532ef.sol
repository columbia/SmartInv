1 pragma solidity ^0.4.19;
2 
3 // File: contracts/libraries/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     // emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts/libraries/Claimable.sol
44 
45 /**
46  * @title Claimable
47  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
48  * This allows the new owner to accept the transfer.
49  */
50 contract Claimable is Ownable {
51   address public pendingOwner;
52 
53   /**
54    * @dev Modifier throws if called by any account other than the pendingOwner.
55    */
56   modifier onlyPendingOwner() {
57     require(msg.sender == pendingOwner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to set the pendingOwner address.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     pendingOwner = newOwner;
67   }
68 
69   /**
70    * @dev Allows the pendingOwner address to finalize the transfer.
71    */
72   function claimOwnership() onlyPendingOwner public {
73     // emit OwnershipTransferred(owner, pendingOwner);
74     owner = pendingOwner;
75     pendingOwner = address(0);
76   }
77 }
78 
79 // File: contracts/libraries/Pausable.sol
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 // File: contracts/libraries/SafeMath.sol
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that throw on error
130  */
131 library SafeMath {
132 
133   /**
134   * @dev Multiplies two numbers, throws on overflow.
135   */
136   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137     if (a == 0) {
138       return 0;
139     }
140     uint256 c = a * b;
141     assert(c / a == b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155   /**
156   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 a, uint256 b) internal pure returns (uint256) {
167     uint256 c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 // File: contracts/EthsqrGate.sol
174 
175 contract EthsqrGate is Claimable, Pausable {
176   address public cfoAddress;
177   
178   function EthsqrGate() public {
179     cfoAddress = msg.sender;
180   }
181 
182   modifier onlyCFO() {
183     require(msg.sender == cfoAddress);
184     _;
185   }
186 
187   function setCFO(address _newCFO) external onlyOwner {
188     require(_newCFO != address(0));
189     cfoAddress = _newCFO;
190   }
191 }
192 
193 // File: contracts/EthsqrPayments.sol
194 
195 contract EthsqrPayments {
196 
197   using SafeMath for uint256;
198   
199   mapping(address => uint256) public heldPayments;
200   uint256 public totalPaymentsHeld;
201   
202   event Price(uint256 indexed identifier, uint256 price, uint256 nextPrice, uint256 round, uint256 timestamp);
203   event Buy(address indexed oldOwner, address indexed newOwner, uint256 indexed identifier, uint256 price, uint256 winnings, uint256 round, uint256 timestamp);
204   event EarningsHeld(address payee, uint256 amount, uint256 timestamp);
205   event EarningsPaid(address payee, uint256 amount, uint256 timestamp);
206 
207   function nextPrice(uint256 _currentPrice) public pure returns(uint256) {
208     if (_currentPrice < 1 ether) {
209       return _currentPrice.mul(175).div(100);
210     } else if (_currentPrice < 10 ether) {
211       return _currentPrice.mul(150).div(100);
212     } else {
213       return _currentPrice.mul(125).div(100);
214     }
215   }
216 
217   function withdrawFunds() public {
218     address payee = msg.sender;
219     uint256 amount = heldPayments[payee];
220     require(amount > 0);
221     heldPayments[payee] = 0;
222     totalPaymentsHeld = totalPaymentsHeld.sub(amount);
223     payee.transfer(amount);
224     EarningsPaid(payee, amount, block.timestamp);
225   }
226 
227   function asyncSend(address payee, uint256 amount) internal {
228     heldPayments[payee] = heldPayments[payee].add(amount);
229     totalPaymentsHeld = totalPaymentsHeld.add(amount);
230     EarningsHeld(payee, amount, block.timestamp);
231   }
232 
233   function getPaymentsHeld(address payee) external view returns(uint256) {
234     return heldPayments[payee];
235   } 
236 }
237 
238 // File: contracts/libraries/Random.sol
239 
240 // axiom-zen eth-random contract
241 
242 // understand this is not truly random. just need some pnrg for mixing stuff up
243 // miners should have no interest in gaming this
244 
245 contract Random {
246   uint256 _seed;
247 
248   function maxRandom() public returns (uint256 randomNumber) {
249     _seed = uint256(keccak256(
250         _seed,
251         block.blockhash(block.number - 1),
252         block.coinbase,
253         block.difficulty
254     ));
255     return _seed;
256   }
257 
258   // return a pseudo random number between lower and upper bounds
259   // given the number of previous blocks it should hash.
260   function random(uint256 upper) public returns (uint256 randomNumber) {
261     return maxRandom() % upper;
262   }
263 }
264 
265 // File: contracts/libraries/usingOraclize.sol
266 
267 // <ORACLIZE_API>
268 /*
269 Copyright (c) 2015-2016 Oraclize SRL
270 Copyright (c) 2016 Oraclize LTD
271 
272 
273 
274 Permission is hereby granted, free of charge, to any person obtaining a copy
275 of this software and associated documentation files (the "Software"), to deal
276 in the Software without restriction, including without limitation the rights
277 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
278 copies of the Software, and to permit persons to whom the Software is
279 furnished to do so, subject to the following conditions:
280 
281 
282 
283 The above copyright notice and this permission notice shall be included in
284 all copies or substantial portions of the Software.
285 
286 
287 
288 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
289 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
290 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
291 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
292 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
293 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
294 THE SOFTWARE.
295 */
296 
297 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
298 pragma solidity ^0.4.18;
299 
300 contract OraclizeI {
301     address public cbAddress;
302     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
303     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
304     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
305     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
306     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
307     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
308     function getPrice(string _datasource) public returns (uint _dsprice);
309     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
310     function setProofType(byte _proofType) external;
311     function setCustomGasPrice(uint _gasPrice) external;
312     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
313 }
314 contract OraclizeAddrResolverI {
315     function getAddress() public returns (address _addr);
316 }
317 contract usingOraclize {
318     uint constant day = 60*60*24;
319     uint constant week = 60*60*24*7;
320     uint constant month = 60*60*24*30;
321     byte constant proofType_NONE = 0x00;
322     byte constant proofType_TLSNotary = 0x10;
323     byte constant proofType_Android = 0x20;
324     byte constant proofType_Ledger = 0x30;
325     byte constant proofType_Native = 0xF0;
326     byte constant proofStorage_IPFS = 0x01;
327     uint8 constant networkID_auto = 0;
328     uint8 constant networkID_mainnet = 1;
329     uint8 constant networkID_testnet = 2;
330     uint8 constant networkID_morden = 2;
331     uint8 constant networkID_consensys = 161;
332 
333     OraclizeAddrResolverI OAR;
334 
335     OraclizeI oraclize;
336     modifier oraclizeAPI {
337         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
338             oraclize_setNetwork(networkID_auto);
339 
340         if(address(oraclize) != OAR.getAddress())
341             oraclize = OraclizeI(OAR.getAddress());
342 
343         _;
344     }
345     modifier coupon(string code){
346         oraclize = OraclizeI(OAR.getAddress());
347         _;
348     }
349 
350     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
351       return oraclize_setNetwork();
352       networkID; // silence the warning and remain backwards compatible
353     }
354     function oraclize_setNetwork() internal returns(bool){
355         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
356             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
357             oraclize_setNetworkName("eth_mainnet");
358             return true;
359         }
360         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
361             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
362             oraclize_setNetworkName("eth_ropsten3");
363             return true;
364         }
365         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
366             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
367             oraclize_setNetworkName("eth_kovan");
368             return true;
369         }
370         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
371             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
372             oraclize_setNetworkName("eth_rinkeby");
373             return true;
374         }
375         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
376             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
377             return true;
378         }
379         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
380             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
381             return true;
382         }
383         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
384             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
385             return true;
386         }
387         return false;
388     }
389 
390     function __callback(bytes32 myid, string result) public {
391         __callback(myid, result, new bytes(0));
392     }
393     function __callback(bytes32 myid, string result, bytes proof) public {
394       return;
395       myid; result; proof; // Silence compiler warnings
396     }
397 
398     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
399         return oraclize.getPrice(datasource);
400     }
401 
402     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
403         return oraclize.getPrice(datasource, gaslimit);
404     }
405 
406     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource);
408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
409         return oraclize.query.value(price)(0, datasource, arg);
410     }
411     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource);
413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
414         return oraclize.query.value(price)(timestamp, datasource, arg);
415     }
416     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource, gaslimit);
418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
419         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
420     }
421     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource, gaslimit);
423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
424         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
425     }
426     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource);
428         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
429         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
430     }
431     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource);
433         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
434         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
435     }
436     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource, gaslimit);
438         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
439         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
440     }
441     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource, gaslimit);
443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
444         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
445     }
446     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource);
448         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
449         bytes memory args = stra2cbor(argN);
450         return oraclize.queryN.value(price)(0, datasource, args);
451     }
452     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource);
454         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
455         bytes memory args = stra2cbor(argN);
456         return oraclize.queryN.value(price)(timestamp, datasource, args);
457     }
458     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
459         uint price = oraclize.getPrice(datasource, gaslimit);
460         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
461         bytes memory args = stra2cbor(argN);
462         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
463     }
464     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
465         uint price = oraclize.getPrice(datasource, gaslimit);
466         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
467         bytes memory args = stra2cbor(argN);
468         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
469     }
470     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](1);
472         dynargs[0] = args[0];
473         return oraclize_query(datasource, dynargs);
474     }
475     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](1);
477         dynargs[0] = args[0];
478         return oraclize_query(timestamp, datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](1);
482         dynargs[0] = args[0];
483         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](1);
487         dynargs[0] = args[0];
488         return oraclize_query(datasource, dynargs, gaslimit);
489     }
490 
491     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](2);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         return oraclize_query(datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](2);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         return oraclize_query(timestamp, datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](2);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](2);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](3);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](3);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         return oraclize_query(timestamp, datasource, dynargs);
528     }
529     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
535     }
536     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](3);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         return oraclize_query(datasource, dynargs, gaslimit);
542     }
543 
544     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](4);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         return oraclize_query(datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](4);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         dynargs[3] = args[3];
558         return oraclize_query(timestamp, datasource, dynargs);
559     }
560     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](4);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         dynargs[3] = args[3];
566         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
567     }
568     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](4);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         return oraclize_query(datasource, dynargs, gaslimit);
575     }
576     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
577         string[] memory dynargs = new string[](5);
578         dynargs[0] = args[0];
579         dynargs[1] = args[1];
580         dynargs[2] = args[2];
581         dynargs[3] = args[3];
582         dynargs[4] = args[4];
583         return oraclize_query(datasource, dynargs);
584     }
585     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
586         string[] memory dynargs = new string[](5);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         dynargs[3] = args[3];
591         dynargs[4] = args[4];
592         return oraclize_query(timestamp, datasource, dynargs);
593     }
594     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
595         string[] memory dynargs = new string[](5);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         dynargs[2] = args[2];
599         dynargs[3] = args[3];
600         dynargs[4] = args[4];
601         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
602     }
603     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](5);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         dynargs[4] = args[4];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
613         uint price = oraclize.getPrice(datasource);
614         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
615         bytes memory args = ba2cbor(argN);
616         return oraclize.queryN.value(price)(0, datasource, args);
617     }
618     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
619         uint price = oraclize.getPrice(datasource);
620         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
621         bytes memory args = ba2cbor(argN);
622         return oraclize.queryN.value(price)(timestamp, datasource, args);
623     }
624     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
625         uint price = oraclize.getPrice(datasource, gaslimit);
626         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
627         bytes memory args = ba2cbor(argN);
628         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
629     }
630     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
631         uint price = oraclize.getPrice(datasource, gaslimit);
632         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
633         bytes memory args = ba2cbor(argN);
634         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
635     }
636     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](1);
638         dynargs[0] = args[0];
639         return oraclize_query(datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](1);
643         dynargs[0] = args[0];
644         return oraclize_query(timestamp, datasource, dynargs);
645     }
646     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](1);
648         dynargs[0] = args[0];
649         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
650     }
651     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](1);
653         dynargs[0] = args[0];
654         return oraclize_query(datasource, dynargs, gaslimit);
655     }
656 
657     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](2);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         return oraclize_query(datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](2);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         return oraclize_query(timestamp, datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](2);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
674     }
675     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](2);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         return oraclize_query(datasource, dynargs, gaslimit);
680     }
681     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](3);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](3);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         return oraclize_query(timestamp, datasource, dynargs);
694     }
695     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](3);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
701     }
702     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](3);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         return oraclize_query(datasource, dynargs, gaslimit);
708     }
709 
710     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](4);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         return oraclize_query(datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](4);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         dynargs[3] = args[3];
724         return oraclize_query(timestamp, datasource, dynargs);
725     }
726     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](4);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
733     }
734     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](4);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         return oraclize_query(datasource, dynargs, gaslimit);
741     }
742     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
743         bytes[] memory dynargs = new bytes[](5);
744         dynargs[0] = args[0];
745         dynargs[1] = args[1];
746         dynargs[2] = args[2];
747         dynargs[3] = args[3];
748         dynargs[4] = args[4];
749         return oraclize_query(datasource, dynargs);
750     }
751     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
752         bytes[] memory dynargs = new bytes[](5);
753         dynargs[0] = args[0];
754         dynargs[1] = args[1];
755         dynargs[2] = args[2];
756         dynargs[3] = args[3];
757         dynargs[4] = args[4];
758         return oraclize_query(timestamp, datasource, dynargs);
759     }
760     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
761         bytes[] memory dynargs = new bytes[](5);
762         dynargs[0] = args[0];
763         dynargs[1] = args[1];
764         dynargs[2] = args[2];
765         dynargs[3] = args[3];
766         dynargs[4] = args[4];
767         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
768     }
769     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](5);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         dynargs[2] = args[2];
774         dynargs[3] = args[3];
775         dynargs[4] = args[4];
776         return oraclize_query(datasource, dynargs, gaslimit);
777     }
778 
779     function oraclize_cbAddress() oraclizeAPI internal returns (address){
780         return oraclize.cbAddress();
781     }
782     function oraclize_setProof(byte proofP) oraclizeAPI internal {
783         return oraclize.setProofType(proofP);
784     }
785     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
786         return oraclize.setCustomGasPrice(gasPrice);
787     }
788 
789     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
790         return oraclize.randomDS_getSessionPubKeyHash();
791     }
792 
793     function getCodeSize(address _addr) constant internal returns(uint _size) {
794         assembly {
795             _size := extcodesize(_addr)
796         }
797     }
798 
799     function parseAddr(string _a) internal pure returns (address){
800         bytes memory tmp = bytes(_a);
801         uint160 iaddr = 0;
802         uint160 b1;
803         uint160 b2;
804         for (uint i=2; i<2+2*20; i+=2){
805             iaddr *= 256;
806             b1 = uint160(tmp[i]);
807             b2 = uint160(tmp[i+1]);
808             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
809             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
810             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
811             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
812             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
813             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
814             iaddr += (b1*16+b2);
815         }
816         return address(iaddr);
817     }
818 
819     function strCompare(string _a, string _b) internal pure returns (int) {
820         bytes memory a = bytes(_a);
821         bytes memory b = bytes(_b);
822         uint minLength = a.length;
823         if (b.length < minLength) minLength = b.length;
824         for (uint i = 0; i < minLength; i ++)
825             if (a[i] < b[i])
826                 return -1;
827             else if (a[i] > b[i])
828                 return 1;
829         if (a.length < b.length)
830             return -1;
831         else if (a.length > b.length)
832             return 1;
833         else
834             return 0;
835     }
836 
837     function indexOf(string _haystack, string _needle) internal pure returns (int) {
838         bytes memory h = bytes(_haystack);
839         bytes memory n = bytes(_needle);
840         if(h.length < 1 || n.length < 1 || (n.length > h.length))
841             return -1;
842         else if(h.length > (2**128 -1))
843             return -1;
844         else
845         {
846             uint subindex = 0;
847             for (uint i = 0; i < h.length; i ++)
848             {
849                 if (h[i] == n[0])
850                 {
851                     subindex = 1;
852                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
853                     {
854                         subindex++;
855                     }
856                     if(subindex == n.length)
857                         return int(i);
858                 }
859             }
860             return -1;
861         }
862     }
863 
864     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
865         bytes memory _ba = bytes(_a);
866         bytes memory _bb = bytes(_b);
867         bytes memory _bc = bytes(_c);
868         bytes memory _bd = bytes(_d);
869         bytes memory _be = bytes(_e);
870         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
871         bytes memory babcde = bytes(abcde);
872         uint k = 0;
873         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
874         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
875         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
876         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
877         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
878         return string(babcde);
879     }
880 
881     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
882         return strConcat(_a, _b, _c, _d, "");
883     }
884 
885     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
886         return strConcat(_a, _b, _c, "", "");
887     }
888 
889     function strConcat(string _a, string _b) internal pure returns (string) {
890         return strConcat(_a, _b, "", "", "");
891     }
892 
893     // parseInt
894     function parseInt(string _a) internal pure returns (uint) {
895         return parseInt(_a, 0);
896     }
897 
898     // parseInt(parseFloat*10^_b)
899     function parseInt(string _a, uint _b) internal pure returns (uint) {
900         bytes memory bresult = bytes(_a);
901         uint mint = 0;
902         bool decimals = false;
903         for (uint i=0; i<bresult.length; i++){
904             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
905                 if (decimals){
906                    if (_b == 0) break;
907                     else _b--;
908                 }
909                 mint *= 10;
910                 mint += uint(bresult[i]) - 48;
911             } else if (bresult[i] == 46) decimals = true;
912         }
913         if (_b > 0) mint *= 10**_b;
914         return mint;
915     }
916 
917     function uint2str(uint i) internal pure returns (string){
918         if (i == 0) return "0";
919         uint j = i;
920         uint len;
921         while (j != 0){
922             len++;
923             j /= 10;
924         }
925         bytes memory bstr = new bytes(len);
926         uint k = len - 1;
927         while (i != 0){
928             bstr[k--] = byte(48 + i % 10);
929             i /= 10;
930         }
931         return string(bstr);
932     }
933 
934     function stra2cbor(string[] arr) internal pure returns (bytes) {
935             uint arrlen = arr.length;
936 
937             // get correct cbor output length
938             uint outputlen = 0;
939             bytes[] memory elemArray = new bytes[](arrlen);
940             for (uint i = 0; i < arrlen; i++) {
941                 elemArray[i] = (bytes(arr[i]));
942                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
943             }
944             uint ctr = 0;
945             uint cborlen = arrlen + 0x80;
946             outputlen += byte(cborlen).length;
947             bytes memory res = new bytes(outputlen);
948 
949             while (byte(cborlen).length > ctr) {
950                 res[ctr] = byte(cborlen)[ctr];
951                 ctr++;
952             }
953             for (i = 0; i < arrlen; i++) {
954                 res[ctr] = 0x5F;
955                 ctr++;
956                 for (uint x = 0; x < elemArray[i].length; x++) {
957                     // if there's a bug with larger strings, this may be the culprit
958                     if (x % 23 == 0) {
959                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
960                         elemcborlen += 0x40;
961                         uint lctr = ctr;
962                         while (byte(elemcborlen).length > ctr - lctr) {
963                             res[ctr] = byte(elemcborlen)[ctr - lctr];
964                             ctr++;
965                         }
966                     }
967                     res[ctr] = elemArray[i][x];
968                     ctr++;
969                 }
970                 res[ctr] = 0xFF;
971                 ctr++;
972             }
973             return res;
974         }
975 
976     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
977             uint arrlen = arr.length;
978 
979             // get correct cbor output length
980             uint outputlen = 0;
981             bytes[] memory elemArray = new bytes[](arrlen);
982             for (uint i = 0; i < arrlen; i++) {
983                 elemArray[i] = (bytes(arr[i]));
984                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
985             }
986             uint ctr = 0;
987             uint cborlen = arrlen + 0x80;
988             outputlen += byte(cborlen).length;
989             bytes memory res = new bytes(outputlen);
990 
991             while (byte(cborlen).length > ctr) {
992                 res[ctr] = byte(cborlen)[ctr];
993                 ctr++;
994             }
995             for (i = 0; i < arrlen; i++) {
996                 res[ctr] = 0x5F;
997                 ctr++;
998                 for (uint x = 0; x < elemArray[i].length; x++) {
999                     // if there's a bug with larger strings, this may be the culprit
1000                     if (x % 23 == 0) {
1001                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1002                         elemcborlen += 0x40;
1003                         uint lctr = ctr;
1004                         while (byte(elemcborlen).length > ctr - lctr) {
1005                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1006                             ctr++;
1007                         }
1008                     }
1009                     res[ctr] = elemArray[i][x];
1010                     ctr++;
1011                 }
1012                 res[ctr] = 0xFF;
1013                 ctr++;
1014             }
1015             return res;
1016         }
1017 
1018 
1019     string oraclize_network_name;
1020     function oraclize_setNetworkName(string _network_name) internal {
1021         oraclize_network_name = _network_name;
1022     }
1023 
1024     function oraclize_getNetworkName() internal view returns (string) {
1025         return oraclize_network_name;
1026     }
1027 
1028     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1029         require((_nbytes > 0) && (_nbytes <= 32));
1030         // Convert from seconds to ledger timer ticks
1031         _delay *= 10; 
1032         bytes memory nbytes = new bytes(1);
1033         nbytes[0] = byte(_nbytes);
1034         bytes memory unonce = new bytes(32);
1035         bytes memory sessionKeyHash = new bytes(32);
1036         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1037         assembly {
1038             mstore(unonce, 0x20)
1039             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1040             mstore(sessionKeyHash, 0x20)
1041             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1042         }
1043         bytes memory delay = new bytes(32);
1044         assembly { 
1045             mstore(add(delay, 0x20), _delay) 
1046         }
1047         
1048         bytes memory delay_bytes8 = new bytes(8);
1049         copyBytes(delay, 24, 8, delay_bytes8, 0);
1050 
1051         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1052         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1053         
1054         bytes memory delay_bytes8_left = new bytes(8);
1055         
1056         assembly {
1057             let x := mload(add(delay_bytes8, 0x20))
1058             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1059             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1060             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1061             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1062             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1063             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1064             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1065             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1066 
1067         }
1068         
1069         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1070         return queryId;
1071     }
1072     
1073     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1074         oraclize_randomDS_args[queryId] = commitment;
1075     }
1076 
1077     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1078     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1079 
1080     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1081         bool sigok;
1082         address signer;
1083 
1084         bytes32 sigr;
1085         bytes32 sigs;
1086 
1087         bytes memory sigr_ = new bytes(32);
1088         uint offset = 4+(uint(dersig[3]) - 0x20);
1089         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1090         bytes memory sigs_ = new bytes(32);
1091         offset += 32 + 2;
1092         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1093 
1094         assembly {
1095             sigr := mload(add(sigr_, 32))
1096             sigs := mload(add(sigs_, 32))
1097         }
1098 
1099 
1100         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1101         if (address(keccak256(pubkey)) == signer) return true;
1102         else {
1103             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1104             return (address(keccak256(pubkey)) == signer);
1105         }
1106     }
1107 
1108     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1109         bool sigok;
1110 
1111         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1112         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1113         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1114 
1115         bytes memory appkey1_pubkey = new bytes(64);
1116         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1117 
1118         bytes memory tosign2 = new bytes(1+65+32);
1119         tosign2[0] = byte(1); //role
1120         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1121         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1122         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1123         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1124 
1125         if (sigok == false) return false;
1126 
1127 
1128         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1129         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1130 
1131         bytes memory tosign3 = new bytes(1+65);
1132         tosign3[0] = 0xFE;
1133         copyBytes(proof, 3, 65, tosign3, 1);
1134 
1135         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1136         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1137 
1138         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1139 
1140         return sigok;
1141     }
1142 
1143     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1144         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1145         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1146 
1147         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1148         require(proofVerified);
1149 
1150         _;
1151     }
1152 
1153     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1154         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1155         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1156 
1157         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1158         if (proofVerified == false) return 2;
1159 
1160         return 0;
1161     }
1162 
1163     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1164         bool match_ = true;
1165         
1166         require(prefix.length == n_random_bytes);
1167 
1168         for (uint256 i=0; i< n_random_bytes; i++) {
1169             if (content[i] != prefix[i]) match_ = false;
1170         }
1171 
1172         return match_;
1173     }
1174 
1175     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1176 
1177         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1178         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1179         bytes memory keyhash = new bytes(32);
1180         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1181         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1182 
1183         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1184         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1185 
1186         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1187         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1188 
1189         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1190         // This is to verify that the computed args match with the ones specified in the query.
1191         bytes memory commitmentSlice1 = new bytes(8+1+32);
1192         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1193 
1194         bytes memory sessionPubkey = new bytes(64);
1195         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1196         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1197 
1198         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1199         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1200             delete oraclize_randomDS_args[queryId];
1201         } else return false;
1202 
1203 
1204         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1205         bytes memory tosign1 = new bytes(32+8+1+32);
1206         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1207         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1208 
1209         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1210         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1211             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1212         }
1213 
1214         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1215     }
1216 
1217     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1218     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1219         uint minLength = length + toOffset;
1220 
1221         // Buffer too small
1222         require(to.length >= minLength); // Should be a better way?
1223 
1224         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1225         uint i = 32 + fromOffset;
1226         uint j = 32 + toOffset;
1227 
1228         while (i < (32 + fromOffset + length)) {
1229             assembly {
1230                 let tmp := mload(add(from, i))
1231                 mstore(add(to, j), tmp)
1232             }
1233             i += 32;
1234             j += 32;
1235         }
1236 
1237         return to;
1238     }
1239 
1240     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1241     // Duplicate Solidity's ecrecover, but catching the CALL return value
1242     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1243         // We do our own memory management here. Solidity uses memory offset
1244         // 0x40 to store the current end of memory. We write past it (as
1245         // writes are memory extensions), but don't update the offset so
1246         // Solidity will reuse it. The memory used here is only needed for
1247         // this context.
1248 
1249         // FIXME: inline assembly can't access return values
1250         bool ret;
1251         address addr;
1252 
1253         assembly {
1254             let size := mload(0x40)
1255             mstore(size, hash)
1256             mstore(add(size, 32), v)
1257             mstore(add(size, 64), r)
1258             mstore(add(size, 96), s)
1259 
1260             // NOTE: we can reuse the request memory because we deal with
1261             //       the return code
1262             ret := call(3000, 1, 0, size, 128, size, 32)
1263             addr := mload(size)
1264         }
1265 
1266         return (ret, addr);
1267     }
1268 
1269     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1270     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1271         bytes32 r;
1272         bytes32 s;
1273         uint8 v;
1274 
1275         if (sig.length != 65)
1276           return (false, 0);
1277 
1278         // The signature format is a compact form of:
1279         //   {bytes32 r}{bytes32 s}{uint8 v}
1280         // Compact means, uint8 is not padded to 32 bytes.
1281         assembly {
1282             r := mload(add(sig, 32))
1283             s := mload(add(sig, 64))
1284 
1285             // Here we are loading the last 32 bytes. We exploit the fact that
1286             // 'mload' will pad with zeroes if we overread.
1287             // There is no 'mload8' to do this, but that would be nicer.
1288             v := byte(0, mload(add(sig, 96)))
1289 
1290             // Alternative solution:
1291             // 'byte' is not working due to the Solidity parser, so lets
1292             // use the second best option, 'and'
1293             // v := and(mload(add(sig, 65)), 255)
1294         }
1295 
1296         // albeit non-transactional signatures are not specified by the YP, one would expect it
1297         // to match the YP range of [27, 28]
1298         //
1299         // geth uses [0, 1] and some clients have followed. This might change, see:
1300         //  https://github.com/ethereum/go-ethereum/issues/2053
1301         if (v < 27)
1302           v += 27;
1303 
1304         if (v != 27 && v != 28)
1305             return (false, 0);
1306 
1307         return safer_ecrecover(hash, v, r, s);
1308     }
1309 
1310 }
1311 // </ORACLIZE_API>
1312 
1313 // File: contracts/EthsqrCore.sol
1314 
1315 contract EthsqrCore is EthsqrGate, EthsqrPayments, Random, usingOraclize {
1316   using SafeMath for uint256;
1317 
1318   event Birth(uint256 identifier, uint256 timestamp);
1319   event DeterminingWinner(uint256 round, uint256 timestamp);
1320   event EarningsCleared(uint256 amount, address participant, uint256 timestamp);
1321   event Join(uint256 identifier, address participant, uint256 round, uint256 timestamp);
1322   event OraclizeCallbackReceived(uint256 round, uint256 random, uint256 timestamp);
1323   event OraclizeQuerySent(uint256 round, uint256 timestamp);
1324   event RoundEnded(uint256 round, address participant, uint256 timestamp);
1325   event RoundStarted(uint256 round, address participant, uint256 roundStart, uint256 roundEnd, uint256 timestamp);
1326   event TimeChanged(uint256 roundEnd, address player, uint256 timestamp);
1327   event UsernameUpdated(address player, string username);
1328   event WinnerDetermined(uint256 winner, uint256 round, uint256 amount, uint256 timestamp);
1329   event WinningEntry(address player, uint256 amount);
1330 
1331   struct Entry {
1332     address participant;
1333   }
1334 
1335   struct Ethsqr {
1336     uint256 identifier;
1337     uint256 parentIdentifier;
1338     address owner;
1339     uint256 price;
1340     uint256 trait;
1341   }
1342 
1343   struct Round {
1344     uint256 start;
1345     address starter;
1346     address ender;
1347     address[] winners;
1348     bool ended;
1349     uint256 entryPrice;
1350     uint256 entryCount;
1351     mapping(uint256 => Entry[]) sqrEntries;
1352     mapping(address => bool) clearedForEarnings;
1353     mapping(address => uint256) prizeForParticipant;
1354   }
1355 
1356   mapping(uint256 => Round) rounds;
1357   mapping(uint256 => Ethsqr) squares;
1358   mapping(uint256 => uint256) oracleResult;
1359   mapping(address => string) usernames;
1360   
1361   uint256 private entryPrice;
1362   uint256 private startPrice;
1363   uint256 private initialDuration;
1364   uint256 private oraclizeAllowance;
1365   uint256 private oraclizeCallbackGas;
1366   uint256 public roundStart;
1367   uint256 public roundEnd;
1368   uint256 public currentRoundNumber;
1369   bool public pendingOraclize;
1370   bool public pendingNewRound;
1371   bool public determiningWinner;
1372 
1373   function EthsqrCore() public {
1374     paused = true;
1375     entryPrice = .01 ether;
1376     startPrice = .005 ether;
1377     oraclizeAllowance = .012 ether;
1378     oraclizeCallbackGas = 1500000;
1379     currentRoundNumber = 0;
1380     determiningWinner = false;
1381     pendingNewRound = true;
1382     pendingOraclize = false;
1383     initialDuration = 10 minutes;
1384   }
1385 
1386   /**************************
1387     public funcs
1388   ***************************/
1389 
1390   function buySqr(uint256 _identifier) external payable whenNotPaused {
1391     require(!_isContract(msg.sender));
1392     Ethsqr storage sqr = squares[_identifier];
1393     address oldOwner = sqr.owner;
1394     address newOwner = msg.sender;
1395     uint256 price = sqr.price;
1396     uint256 newPrice = nextPrice(price);
1397     require(oldOwner != newOwner);
1398     require(msg.value >= price);
1399     uint256 twoPercent = uint256(SafeMath.div(SafeMath.mul(price, 2), 100));
1400     uint256 threePercent = uint256(SafeMath.div(SafeMath.mul(price, 3), 100));
1401     // 2% of transaction goes to dev 
1402     asyncSend(owner, twoPercent);
1403     // 3% of transaction goes to mastersqr owner
1404     asyncSend(squares[0].owner, threePercent);
1405     uint256 winnings = price.sub(threePercent + twoPercent);
1406     // send the winnings to the old owner, if the owner is not the contract, otherwise, add to contract balance
1407     if (oldOwner != address(this)) {
1408       asyncSend(oldOwner, winnings);
1409     }
1410     // calculate and refund any excess wei
1411     uint256 excess = msg.value - price;
1412     if (excess > 0) {
1413       asyncSend(newOwner, excess);
1414     }
1415     // update sqr attributes
1416     sqr.price = newPrice;
1417     sqr.owner = newOwner;
1418     // emit buyout events
1419     Buy(oldOwner, newOwner, _identifier, price, winnings, currentRoundNumber, block.timestamp);
1420     Price(_identifier, newPrice, nextPrice(newPrice), currentRoundNumber, block.timestamp);
1421   }
1422 
1423   function createSqr(uint256 _identifier, address _owner, uint256 _parentIdentifier, 
1424     uint256 _price) external onlyOwner {
1425     _mintSqr(_identifier, _owner, _parentIdentifier, _price);
1426   }
1427 
1428   function getRoundDividendShare() public view returns(uint256 share) {
1429     if(this.balance >= oraclizeAllowance){
1430       uint256 totalPossible = this.balance.sub(oraclizeAllowance).sub(totalPaymentsHeld);
1431       return uint256(SafeMath.div(SafeMath.mul(totalPossible, 10), 100));
1432     }
1433     return 0;
1434   }
1435 
1436   function getRoundPrizeShare() public view returns(uint256 share) {
1437     if(this.balance > oraclizeAllowance){
1438       uint256 totalPossible = this.balance.sub(oraclizeAllowance).sub(totalPaymentsHeld);
1439       return uint256(SafeMath.div(SafeMath.mul(totalPossible, 90), 100));
1440     }
1441     return 0;
1442   }
1443 
1444   function getRound(uint256 _identifier) external view returns(
1445     uint256 start, bool ended, address roundStarter, address roundEnder, 
1446     uint256 entryCount, uint256 joinPrice) {
1447     Round storage round = rounds[_identifier];
1448     ended = round.ended;
1449     start = round.start;
1450     roundStarter = round.starter;
1451     roundEnder = round.ender;
1452     entryCount = round.entryCount;
1453     joinPrice = round.entryPrice;
1454   }
1455 
1456   function getSqr(uint256 _identifier) external view returns(
1457     uint256 id, address owner, uint256 buyPrice, uint256 nextBuyPrice, 
1458     uint256 trait) {
1459     Ethsqr storage sqr = squares[_identifier];
1460     id = _identifier;
1461     owner = sqr.owner;
1462     buyPrice = sqr.price;
1463     nextBuyPrice = nextPrice(buyPrice);
1464     trait = sqr.trait;
1465   }
1466 
1467   function getUsername(address _player) external view returns(string) {
1468     return usernames[_player];
1469   }
1470 
1471   function joinSqr(uint256 _identifier) external payable whenNotPaused {
1472     // players can not join the mastersqr
1473     require(_identifier > 0);
1474     // ensure a contract isn't calling this function
1475     require(!_isContract(msg.sender));
1476     require(!pendingNewRound);
1477     require(!pendingOraclize);
1478     if (block.timestamp < roundEnd) {
1479       Round storage currentRound = rounds[currentRoundNumber];
1480       require(msg.value == currentRound.entryPrice);
1481       require(!determiningWinner);
1482       address participant = msg.sender;
1483       uint256 threePercent = uint256(SafeMath.div(SafeMath.mul(entryPrice, 3), 100));
1484       Ethsqr storage sqr = squares[_identifier];
1485       uint256 trait = sqr.trait;
1486       // send 3% dividend to mastersqr owner
1487       if(squares[0].owner != address(this)){
1488         asyncSend(squares[0].owner, threePercent);
1489       }
1490       // send 3% dividend to sqr owner
1491       if(squares[_identifier].owner != address(this)){
1492         asyncSend(squares[_identifier].owner, threePercent);
1493       }
1494       // create new entry and add it to the user entries
1495       currentRound.sqrEntries[_identifier].push(Entry({ participant: participant }));
1496       currentRound.entryCount = currentRound.entryCount.add(1);
1497       Join(_identifier, participant, currentRoundNumber, block.timestamp);
1498       // increase time trait || runs only if time left is less than 1 minute less than the initial duration
1499       if (trait == 1 && _timeRemaining() < (initialDuration - 1 minutes)) {
1500         roundEnd = roundEnd.add(1 minutes);
1501         TimeChanged(roundEnd, participant, block.timestamp);
1502       }
1503       // decrease time trait || runs only if there is more than one minute left
1504       if (trait == 2 && _timeRemaining() > 1 minutes) {
1505         roundEnd = roundEnd.sub(1 minutes);
1506         TimeChanged(roundEnd, participant, block.timestamp);
1507       }
1508     } else {
1509       // ensure we aren't currently waiting for a result from Oracle and there is no result yet
1510       require(!pendingOraclize);
1511       // ensure there is no result for this round yet
1512       require(oracleResult[currentRoundNumber] == 0);
1513       // set the player as the round ender
1514       currentRound.ender = participant;
1515       // ensure we can have enough to pay everyone after contacting oraclize
1516       if(getRoundPrizeShare() > 0){
1517         // make the call to Oraclize to get the random winner
1518         _useOraclize();
1519       } else {
1520         currentRound.ended = true;
1521         determiningWinner = false;
1522         pendingNewRound = true;
1523         RoundEnded(currentRoundNumber, participant, block.timestamp);
1524         WinnerDetermined(0, currentRoundNumber, 0, block.timestamp);
1525       }
1526       // send the round user half of the join price, back
1527       asyncSend(participant, entryPrice.div(2));
1528     }
1529   }
1530 
1531   modifier roundFinished() {
1532     require(block.timestamp > roundEnd);
1533     _;
1534   }
1535 
1536   function seedGame() external onlyOwner {
1537     for (uint256 i = 0; i < 26; i++) {
1538       _mintSqr(i, address(this), 0, 0.01 ether);
1539     }
1540     oraclize_setCustomGasPrice(10000000000); // set oraclize gas price to 10 gwei
1541   }
1542 
1543   function setEntryPrice(uint256 _price) external onlyOwner {
1544     // cfo can only decrease the join price, never increase it
1545     require(_price < entryPrice);
1546     entryPrice = _price;
1547   }
1548 
1549   function setInitialDuration(uint256 _seconds) external onlyOwner {
1550     initialDuration = _seconds;
1551   }
1552 
1553   function setOraclizeAllowance(uint256 _allowance) external onlyOwner {
1554     oraclizeAllowance = _allowance;
1555   }
1556 
1557   function setOraclizeCallbackGas(uint256 _gas) external onlyOwner {
1558     oraclizeCallbackGas = _gas;
1559   }
1560 
1561   function setOraclizeGasPrice(uint256 _gas) external onlyOwner {
1562     oraclize_setCustomGasPrice(_gas);
1563   }
1564 
1565   function setStartPrice(uint256 _price) external onlyOwner {
1566     startPrice = _price;
1567   }
1568 
1569   function setUsername(address _player, string _username) public {
1570     require(_player == msg.sender);
1571     usernames[_player] = _username;
1572     UsernameUpdated(_player, _username);
1573   }
1574 
1575   function startRound() external payable roundFinished whenNotPaused {
1576     require(pendingNewRound);
1577     require(msg.value >= startPrice);
1578     uint256 newRoundNumber = currentRoundNumber.add(1);
1579     address starter = address(msg.sender);
1580     // reset all traits every round
1581     if(newRoundNumber > 1) {
1582       for (uint256 i = 1; i < 26; i++) {
1583         Ethsqr storage sqr = squares[i];
1584         sqr.trait = random(3);
1585       }
1586     }
1587     roundStart = block.timestamp;
1588     roundEnd = block.timestamp.add(initialDuration);
1589     pendingNewRound = false;
1590     Round memory newRound = Round({
1591       start: block.timestamp,
1592       ender: address(0x0),
1593       ended: false,
1594       starter: starter,
1595       winners: new address[](0),
1596       entryCount: 0,
1597       entryPrice: entryPrice
1598     });
1599     rounds[newRoundNumber] = newRound;
1600     currentRoundNumber = newRoundNumber;
1601     RoundStarted(newRoundNumber, starter, roundStart, roundEnd, block.timestamp);
1602   }
1603 
1604   function ownerOf(uint256 _identifier) external view returns (address owner) {
1605     Ethsqr storage sqr = squares[_identifier];
1606     owner = sqr.owner;
1607   }
1608 
1609   /**************************
1610     internal funcs
1611   ***************************/
1612 
1613   function __callback(bytes32 myid, string result) public {
1614     require(msg.sender == oraclize_cbAddress());
1615     uint256 winner = uint256(parseInt(result));
1616     oracleResult[currentRoundNumber] = winner;
1617     pendingOraclize = false;
1618     OraclizeCallbackReceived(currentRoundNumber, winner, block.timestamp);
1619     _rewardWinners();
1620   }
1621 
1622   function _isContract(address _addr) internal view returns (bool) {
1623     uint size;
1624     assembly { size := extcodesize(_addr) }
1625     return size > 0;
1626   }
1627 
1628   function _mintSqr(uint256 _identifier, address _owner, uint256 _parentIdentifier, uint256 _price) internal {
1629     require(_identifier >= 0);
1630     require(squares[_identifier].price == 0);
1631     address initialOwner = _owner;
1632     if (_owner == 0x0) {
1633       initialOwner = address(this);
1634     }
1635     Ethsqr memory sqr = Ethsqr({
1636       owner: initialOwner,
1637       identifier: _identifier,
1638       parentIdentifier: _parentIdentifier,
1639       price: _price,
1640       trait: _identifier == 0 ? 0 : random(3)
1641     });
1642     squares[_identifier] = sqr;
1643     Birth(_identifier, block.timestamp);
1644     Price(_identifier, _price, nextPrice(_price), currentRoundNumber, block.timestamp);
1645   }
1646 
1647   function _rewardWinners() internal roundFinished {
1648     require(determiningWinner);
1649     require(oracleResult[currentRoundNumber] != 0);
1650     Round storage curRound = rounds[currentRoundNumber];
1651     Entry[] storage winningEntries = curRound.sqrEntries[oracleResult[currentRoundNumber]];
1652     // 90% of the prize goes to the random square participants
1653     uint256 prizeShare = getRoundPrizeShare(); 
1654     // 10% of the prize goes to the round dividend earners
1655     uint256 divShare = getRoundDividendShare();
1656     // if there was at least one winner, send funds to everyone!
1657     if ((winningEntries.length > 0) && (prizeShare > 0) && (divShare > 0)) {
1658       // final payout per winning entry
1659       uint256 winningEntryShare = uint256(SafeMath.div(prizeShare, winningEntries.length));
1660       // iterate over the winning entries to determine which addresses should get a payout for the random square
1661       for (uint256 i = 0; i < winningEntries.length; i++) {
1662         address curParticipant = winningEntries[0].participant;
1663         curRound.prizeForParticipant[curParticipant] = curRound.prizeForParticipant[curParticipant].add(winningEntryShare);
1664         if (curRound.clearedForEarnings[curParticipant] == false) {
1665           curRound.winners.push(curParticipant);
1666           curRound.clearedForEarnings[curParticipant] = true;
1667           WinningEntry(curParticipant, curRound.entryPrice);
1668         }
1669       }
1670       // iterate over the winners to update their funds 
1671       for (uint j = 0; j < curRound.winners.length; j++) {
1672         uint256 amount = curRound.prizeForParticipant[curRound.winners[j]];
1673         EarningsCleared(amount, curRound.winners[j], block.timestamp);
1674         asyncSend(curRound.winners[j], amount);
1675       }
1676       // send funds to the dividend earners
1677       uint256 tenPercent = uint256(SafeMath.div(SafeMath.mul(divShare, 10), 100));
1678       uint256 twentyPercent = uint256(SafeMath.div(SafeMath.mul(divShare, 20), 100));
1679       uint256 thirtyPercent = uint256(SafeMath.div(SafeMath.mul(divShare, 30), 100));
1680       // 30% of the div share goes to the owner of the mastersqr
1681       asyncSend(squares[0].owner, thirtyPercent);
1682       // 30% of the div share goes to the owner of the random sqr
1683       asyncSend(squares[oracleResult[currentRoundNumber]].owner, thirtyPercent);
1684       // 20% of the div share goes to the developer of the contract
1685       asyncSend(squares[0].owner, twentyPercent);
1686       // 10% of the div share goes to the round starter
1687       asyncSend(curRound.starter, tenPercent);
1688       // 10% of the div share goes to the round ender
1689       asyncSend(curRound.ender, tenPercent);
1690     }
1691     // reset state variables
1692     curRound.ended = true;
1693     determiningWinner = false;
1694     pendingNewRound = true;
1695     RoundEnded(currentRoundNumber, curRound.ender, block.timestamp);
1696     WinnerDetermined(oracleResult[currentRoundNumber], currentRoundNumber, prizeShare, block.timestamp);
1697   }
1698 
1699   function _timeRemaining() internal view returns(uint256 remainder) {
1700     return roundEnd > block.timestamp ? roundEnd - block.timestamp : 0;
1701   }
1702 
1703   function _useOraclize() internal {
1704     require(!pendingOraclize);
1705     pendingOraclize = true;    
1706     determiningWinner = true;
1707     DeterminingWinner(currentRoundNumber, block.timestamp);
1708     oraclize_query("WolframAlpha", "random number between 1 and 25", oraclizeCallbackGas);
1709     OraclizeQuerySent(currentRoundNumber, block.timestamp);
1710   }
1711 }