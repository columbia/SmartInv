1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/Math.sol
4 
5 /**
6  * @title Math
7  * @dev Assorted math operations
8  */
9 library Math {
10   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
11     return a >= b ? a : b;
12   }
13 
14   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
15     return a < b ? a : b;
16   }
17 
18   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a >= b ? a : b;
20   }
21 
22   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
23     return a < b ? a : b;
24   }
25 }
26 
27 // File: zeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     if (a == 0) {
40       return 0;
41     }
42     uint256 c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   /**
58   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 // File: contracts/BonusProgram.sol
76 
77 contract BonusProgram {
78   using SafeMath for uint256;
79 
80   // Amount of decimals specified for the ERC20 token
81   uint constant DECIMALS = 18;
82 
83   // Initial amount of bonus program tokens
84   uint256 public initialBonuslistTokens;
85   // Tokens that have been bought in bonus program
86   uint256 public tokensBoughtInBonusProgram = 0;
87 
88   constructor(uint256 _initialBonuslistTokens) public {
89     initialBonuslistTokens = _initialBonuslistTokens;
90   }
91 
92   /**
93    * @dev Calculates the amount of bonus tokens a buyer gets, based on how much the buyer bought and in which bonus threshold the purchase falls.
94    *      Note that this function does not modify any variables besides the _totalTokensSold, the responsibility for that lies with the caller.
95    * @param _tokensBought Number of tokens a buyer bought
96    * @param _totalTokensSold Number of tokens sold prior to the buyer buying their tokens
97    * @return The amount of tokens the buyer should receive as bonus
98    */
99   function _calculateBonus(uint256 _tokensBought, uint256 _totalTokensSold) internal pure returns (uint) {
100     uint _bonusTokens = 0;
101     // This checks if the bonus cap has been reached.
102     if (_totalTokensSold > 150 * 10**5 * 10**DECIMALS) {
103       return _bonusTokens;
104     }
105     // Bonus tranches: [ 15%, 10%, 5%, 2.5% ]
106     uint8[4] memory _bonusPattern = [ 150, 100, 50, 25 ];
107     // Bonus tranche thresholds in millions
108     uint256[5] memory _thresholds = [ 0, 25 * 10**5 * 10**DECIMALS, 50 * 10**5 * 10**DECIMALS, 100 * 10**5 * 10**DECIMALS, 150 * 10**5 * 10**DECIMALS ];
109 
110     for(uint8 i = 0; _tokensBought > 0 && i < _bonusPattern.length; ++i) {
111       uint _min = _thresholds[i];
112       uint _max = _thresholds[i+1];
113 
114       if(_totalTokensSold >= _min && _totalTokensSold < _max) {
115         uint _bonusedPart = Math.min256(_tokensBought, _max - _totalTokensSold);
116         _bonusTokens = _bonusTokens.add(_bonusedPart * _bonusPattern[i] / 1000);
117         _tokensBought = _tokensBought.sub(_bonusedPart);
118         _totalTokensSold  = _totalTokensSold.add(_bonusedPart);
119       }
120     }
121     return _bonusTokens;
122   }
123 }
124 
125 // File: contracts/interfaces/ContractManagerInterface.sol
126 
127 /**
128  * @title Contract Manager Interface
129  * @author Bram Hoven
130  * @notice Interface for communicating with the contract manager
131  */
132 interface ContractManagerInterface {
133   /**
134    * @notice Triggered when contract is added
135    * @param _address Address of the new contract
136    * @param _contractName Name of the new contract
137    */
138   event ContractAdded(address indexed _address, string _contractName);
139 
140   /**
141    * @notice Triggered when contract is removed
142    * @param _contractName Name of the contract that is removed
143    */
144   event ContractRemoved(string _contractName);
145 
146   /**
147    * @notice Triggered when contract is updated
148    * @param _oldAddress Address where the contract used to be
149    * @param _newAddress Address where the new contract is deployed
150    * @param _contractName Name of the contract that has been updated
151    */
152   event ContractUpdated(address indexed _oldAddress, address indexed _newAddress, string _contractName);
153 
154   /**
155    * @notice Triggered when authorization status changed
156    * @param _address Address who will gain or lose authorization to _contractName
157    * @param _authorized Boolean whether or not the address is authorized
158    * @param _contractName Name of the contract
159    */
160   event AuthorizationChanged(address indexed _address, bool _authorized, string _contractName);
161 
162   /**
163    * @notice Check whether the accessor is authorized to access that contract
164    * @param _contractName Name of the contract that is being accessed
165    * @param _accessor Address who wants to access that contract
166    */
167   function authorize(string _contractName, address _accessor) external view returns (bool);
168 
169   /**
170    * @notice Add a new contract to the manager
171    * @param _contractName Name of the new contract
172    * @param _address Address of the new contract
173    */
174   function addContract(string _contractName, address _address) external;
175 
176   /**
177    * @notice Get a contract by its name
178    * @param _contractName Name of the contract
179    */
180   function getContract(string _contractName) external view returns (address _contractAddress);
181 
182   /**
183    * @notice Remove an existing contract
184    * @param _contractName Name of the contract that will be removed
185    */
186   function removeContract(string _contractName) external;
187 
188   /**
189    * @notice Update an existing contract (changing the address)
190    * @param _contractName Name of the existing contract
191    * @param _newAddress Address where the new contract is deployed
192    */
193   function updateContract(string _contractName, address _newAddress) external;
194 
195   /**
196    * @notice Change whether an address is authorized to use a specific contract or not
197    * @param _contractName Name of the contract to which the accessor will gain authorization or not
198    * @param _authorizedAddress Address which will have its authorisation status changed
199    * @param _authorized Boolean whether the address will have access or not
200    */
201   function setAuthorizedContract(string _contractName, address _authorizedAddress, bool _authorized) external;
202 }
203 
204 // File: contracts/interfaces/MintableTokenInterface.sol
205 
206 /**
207  * @title Mintable Token Interface
208  * @author Bram Hoven
209  * @notice Interface for communicating with the mintable token
210  */
211 interface MintableTokenInterface {
212   /**
213    * @notice Triggered when tokens are minted
214    * @param _from Address which triggered the minting
215    * @param _to Address on which the tokens are deposited
216    * @param _tokens Amount of tokens minted
217    */
218   event TokensMinted(address indexed _from, address indexed _to, uint256 _tokens);
219 
220   /**
221    * @notice Triggered when the deposit address changes
222    * @param _old Old deposit address
223    * @param _new New deposit address
224    */
225   event DepositAddressChanged(address indexed _old, address indexed _new);
226 
227   /**
228    * @notice Called when new tokens are needed in circulation
229    * @param _tokens Amount of tokens to be created
230    */
231   function mintTokens(uint256 _tokens) external;
232 
233   /**
234    * @notice Called when tokens are bought in token sale
235    * @param _beneficiary Address on which tokens are deposited
236    * @param _tokens Amount of tokens to be created
237    */
238   function sendBoughtTokens(address _beneficiary, uint256 _tokens) external;
239 
240   /**
241    * @notice Called when deposit address needs to change
242    * @param _depositAddress Address on which minted tokens are deposited
243    */
244   function changeDepositAddress(address _depositAddress) external;
245 }
246 
247 // File: contracts/BountyProgram.sol
248 
249 contract BountyProgram {
250   using SafeMath for uint256;
251 
252   // Wownity bounty address
253   address public bountyAddress;
254 
255   // Amount of total tokens that were available
256   uint256 TOKENS_IN_BOUNTY = 25 * 10**4 * 10**18;
257   // Amount of tokens that are still available
258   uint256 tokenAvailable = 25 * 10**4 * 10**18;
259 
260   // Name of this contract
261   string private contractName;  
262   // Contract Manager
263   ContractManagerInterface private contractManager;
264   // The fida mintable token
265   MintableTokenInterface private mintableFida;
266 
267   /**
268    * @notice Triggered when bounty wallet address is changed
269    * @param _oldAddress Address where the bounty wallet used to be
270    * @param _newAddress Address where the new bounty wallet is
271    */
272   event BountyWalletAddressChanged(address indexed _oldAddress, address indexed _newAddress);
273 
274   /**
275    * @notice Triggered when a bounty is send
276    * @param _bountyReceiver Address where the bounty is send to
277    * @param _bountyTokens Amount of tokens that have been send
278    */
279   event BountySend(address indexed _bountyReceiver, uint256 _bountyTokens);
280 
281   /**
282    * @notice Contructor for creating the fida bounty program
283    * @param _contractName Name of this contract in the contract manager
284    * @param _bountyAddress Address of where bounty tokens will be send from
285    * @param _tokenAddress Address where ERC20 token is located
286    * @param _contractManager Address where the contract manager is deployed
287    */
288   constructor(string _contractName, address _bountyAddress, address _tokenAddress, address _contractManager) public {
289     contractName = _contractName;
290     bountyAddress = _bountyAddress;
291     mintableFida = MintableTokenInterface(_tokenAddress);
292     contractManager = ContractManagerInterface(_contractManager);
293   }
294 
295   /**
296    * @notice Change the address to where the bounty will be send when sale starts
297    * @param _walletAddress Address of the wallet
298    */
299   function setBountyWalletAddress(address _walletAddress) external {
300     require(contractManager.authorize(contractName, msg.sender));
301     require(_walletAddress != address(0));
302     require(_walletAddress != bountyAddress);
303 
304     address oldAddress = bountyAddress;
305     bountyAddress = _walletAddress;
306 
307     emit BountyWalletAddressChanged(oldAddress, _walletAddress);
308   }
309 
310   /**
311    * @notice Give out a bounty
312    * @param _tokens Amount of tokens to be given out
313    * @param _address Address whom will receive the bounty
314    */
315   function giveBounty(uint256 _tokens, address _address) external {
316     require(msg.sender == bountyAddress);
317 
318     tokenAvailable = tokenAvailable.sub(_tokens);
319 
320     mintableFida.sendBoughtTokens(_address, _tokens);
321   }
322 }
323 
324 // File: contracts/oraclizeAPI_0.5.sol
325 
326 // <ORACLIZE_API>
327 /*
328 Copyright (c) 2015-2016 Oraclize SRL
329 Copyright (c) 2016 Oraclize LTD
330 
331 
332 
333 Permission is hereby granted, free of charge, to any person obtaining a copy
334 of this software and associated documentation files (the "Software"), to deal
335 in the Software without restriction, including without limitation the rights
336 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
337 copies of the Software, and to permit persons to whom the Software is
338 furnished to do so, subject to the following conditions:
339 
340 
341 
342 The above copyright notice and this permission notice shall be included in
343 all copies or substantial portions of the Software.
344 
345 
346 
347 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
348 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
349 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
350 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
351 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
352 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
353 THE SOFTWARE.
354 */
355 
356 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
357 pragma solidity ^0.4.23;
358 
359 contract OraclizeI {
360     address public cbAddress;
361     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
362     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
363     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
364     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
365     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
366     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
367     function getPrice(string _datasource) public returns (uint _dsprice);
368     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
369     function setProofType(byte _proofType) external;
370     function setCustomGasPrice(uint _gasPrice) external;
371     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
372 }
373 contract OraclizeAddrResolverI {
374     function getAddress() public returns (address _addr);
375 }
376 contract usingOraclize {
377     uint constant day = 60*60*24;
378     uint constant week = 60*60*24*7;
379     uint constant month = 60*60*24*30;
380     byte constant proofType_NONE = 0x00;
381     byte constant proofType_TLSNotary = 0x10;
382     byte constant proofType_Android = 0x20;
383     byte constant proofType_Ledger = 0x30;
384     byte constant proofType_Native = 0xF0;
385     byte constant proofStorage_IPFS = 0x01;
386     uint8 constant networkID_auto = 0;
387     uint8 constant networkID_mainnet = 1;
388     uint8 constant networkID_testnet = 2;
389     uint8 constant networkID_morden = 2;
390     uint8 constant networkID_consensys = 161;
391 
392     OraclizeAddrResolverI OAR;
393 
394     OraclizeI oraclize;
395     modifier oraclizeAPI {
396         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
397             oraclize_setNetwork(networkID_auto);
398 
399         if(address(oraclize) != OAR.getAddress())
400             oraclize = OraclizeI(OAR.getAddress());
401 
402         _;
403     }
404     modifier coupon(string code){
405         oraclize = OraclizeI(OAR.getAddress());
406         _;
407     }
408 
409     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
410       return oraclize_setNetwork();
411       networkID; // silence the warning and remain backwards compatible
412     }
413     function oraclize_setNetwork() internal returns(bool){
414         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
415             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
416             oraclize_setNetworkName("eth_mainnet");
417             return true;
418         }
419         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
420             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
421             oraclize_setNetworkName("eth_ropsten3");
422             return true;
423         }
424         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
425             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
426             oraclize_setNetworkName("eth_kovan");
427             return true;
428         }
429         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
430             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
431             oraclize_setNetworkName("eth_rinkeby");
432             return true;
433         }
434         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
435             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
436             return true;
437         }
438         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
439             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
440             return true;
441         }
442         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
443             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
444             return true;
445         }
446         return false;
447     }
448 
449     function __callback(bytes32 myid, string result) public {
450         __callback(myid, result, new bytes(0));
451     }
452     function __callback(bytes32 myid, string result, bytes proof) public {
453       return;
454       myid; result; proof; // Silence compiler warnings
455     }
456 
457     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
458         return oraclize.getPrice(datasource);
459     }
460 
461     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
462         return oraclize.getPrice(datasource, gaslimit);
463     }
464 
465     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
466         uint price = oraclize.getPrice(datasource);
467         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
468         return oraclize.query.value(price)(0, datasource, arg);
469     }
470     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
471         uint price = oraclize.getPrice(datasource);
472         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
473         return oraclize.query.value(price)(timestamp, datasource, arg);
474     }
475     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
476         uint price = oraclize.getPrice(datasource, gaslimit);
477         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
478         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
479     }
480     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
481         uint price = oraclize.getPrice(datasource, gaslimit);
482         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
483         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
484     }
485     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
486         uint price = oraclize.getPrice(datasource);
487         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
488         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
489     }
490     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
491         uint price = oraclize.getPrice(datasource);
492         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
493         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
494     }
495     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
496         uint price = oraclize.getPrice(datasource, gaslimit);
497         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
498         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
499     }
500     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
501         uint price = oraclize.getPrice(datasource, gaslimit);
502         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
503         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
504     }
505     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
506         uint price = oraclize.getPrice(datasource);
507         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
508         bytes memory args = stra2cbor(argN);
509         return oraclize.queryN.value(price)(0, datasource, args);
510     }
511     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
512         uint price = oraclize.getPrice(datasource);
513         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
514         bytes memory args = stra2cbor(argN);
515         return oraclize.queryN.value(price)(timestamp, datasource, args);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
518         uint price = oraclize.getPrice(datasource, gaslimit);
519         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
520         bytes memory args = stra2cbor(argN);
521         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
522     }
523     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
524         uint price = oraclize.getPrice(datasource, gaslimit);
525         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
526         bytes memory args = stra2cbor(argN);
527         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
528     }
529     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](1);
531         dynargs[0] = args[0];
532         return oraclize_query(datasource, dynargs);
533     }
534     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](1);
536         dynargs[0] = args[0];
537         return oraclize_query(timestamp, datasource, dynargs);
538     }
539     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](1);
541         dynargs[0] = args[0];
542         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](1);
546         dynargs[0] = args[0];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549 
550     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](2);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         return oraclize_query(datasource, dynargs);
555     }
556     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](2);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         return oraclize_query(timestamp, datasource, dynargs);
561     }
562     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](2);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
567     }
568     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](2);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         return oraclize_query(datasource, dynargs, gaslimit);
573     }
574     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](3);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         return oraclize_query(datasource, dynargs);
580     }
581     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
582         string[] memory dynargs = new string[](3);
583         dynargs[0] = args[0];
584         dynargs[1] = args[1];
585         dynargs[2] = args[2];
586         return oraclize_query(timestamp, datasource, dynargs);
587     }
588     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
589         string[] memory dynargs = new string[](3);
590         dynargs[0] = args[0];
591         dynargs[1] = args[1];
592         dynargs[2] = args[2];
593         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
594     }
595     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
596         string[] memory dynargs = new string[](3);
597         dynargs[0] = args[0];
598         dynargs[1] = args[1];
599         dynargs[2] = args[2];
600         return oraclize_query(datasource, dynargs, gaslimit);
601     }
602 
603     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](4);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         return oraclize_query(datasource, dynargs);
610     }
611     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
612         string[] memory dynargs = new string[](4);
613         dynargs[0] = args[0];
614         dynargs[1] = args[1];
615         dynargs[2] = args[2];
616         dynargs[3] = args[3];
617         return oraclize_query(timestamp, datasource, dynargs);
618     }
619     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         string[] memory dynargs = new string[](4);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         dynargs[2] = args[2];
624         dynargs[3] = args[3];
625         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
626     }
627     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628         string[] memory dynargs = new string[](4);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         dynargs[2] = args[2];
632         dynargs[3] = args[3];
633         return oraclize_query(datasource, dynargs, gaslimit);
634     }
635     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
636         string[] memory dynargs = new string[](5);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         dynargs[2] = args[2];
640         dynargs[3] = args[3];
641         dynargs[4] = args[4];
642         return oraclize_query(datasource, dynargs);
643     }
644     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
645         string[] memory dynargs = new string[](5);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         dynargs[2] = args[2];
649         dynargs[3] = args[3];
650         dynargs[4] = args[4];
651         return oraclize_query(timestamp, datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
654         string[] memory dynargs = new string[](5);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         dynargs[3] = args[3];
659         dynargs[4] = args[4];
660         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
661     }
662     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         string[] memory dynargs = new string[](5);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         dynargs[3] = args[3];
668         dynargs[4] = args[4];
669         return oraclize_query(datasource, dynargs, gaslimit);
670     }
671     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
672         uint price = oraclize.getPrice(datasource);
673         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
674         bytes memory args = ba2cbor(argN);
675         return oraclize.queryN.value(price)(0, datasource, args);
676     }
677     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
678         uint price = oraclize.getPrice(datasource);
679         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
680         bytes memory args = ba2cbor(argN);
681         return oraclize.queryN.value(price)(timestamp, datasource, args);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
684         uint price = oraclize.getPrice(datasource, gaslimit);
685         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
686         bytes memory args = ba2cbor(argN);
687         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
688     }
689     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
690         uint price = oraclize.getPrice(datasource, gaslimit);
691         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
692         bytes memory args = ba2cbor(argN);
693         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](1);
697         dynargs[0] = args[0];
698         return oraclize_query(datasource, dynargs);
699     }
700     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](1);
702         dynargs[0] = args[0];
703         return oraclize_query(timestamp, datasource, dynargs);
704     }
705     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](1);
707         dynargs[0] = args[0];
708         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
709     }
710     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](1);
712         dynargs[0] = args[0];
713         return oraclize_query(datasource, dynargs, gaslimit);
714     }
715 
716     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](2);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         return oraclize_query(datasource, dynargs);
721     }
722     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](2);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         return oraclize_query(timestamp, datasource, dynargs);
727     }
728     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](2);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
733     }
734     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](2);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         return oraclize_query(datasource, dynargs, gaslimit);
739     }
740     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](3);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         return oraclize_query(datasource, dynargs);
746     }
747     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
748         bytes[] memory dynargs = new bytes[](3);
749         dynargs[0] = args[0];
750         dynargs[1] = args[1];
751         dynargs[2] = args[2];
752         return oraclize_query(timestamp, datasource, dynargs);
753     }
754     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
755         bytes[] memory dynargs = new bytes[](3);
756         dynargs[0] = args[0];
757         dynargs[1] = args[1];
758         dynargs[2] = args[2];
759         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
760     }
761     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
762         bytes[] memory dynargs = new bytes[](3);
763         dynargs[0] = args[0];
764         dynargs[1] = args[1];
765         dynargs[2] = args[2];
766         return oraclize_query(datasource, dynargs, gaslimit);
767     }
768 
769     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](4);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         dynargs[2] = args[2];
774         dynargs[3] = args[3];
775         return oraclize_query(datasource, dynargs);
776     }
777     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
778         bytes[] memory dynargs = new bytes[](4);
779         dynargs[0] = args[0];
780         dynargs[1] = args[1];
781         dynargs[2] = args[2];
782         dynargs[3] = args[3];
783         return oraclize_query(timestamp, datasource, dynargs);
784     }
785     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
786         bytes[] memory dynargs = new bytes[](4);
787         dynargs[0] = args[0];
788         dynargs[1] = args[1];
789         dynargs[2] = args[2];
790         dynargs[3] = args[3];
791         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
792     }
793     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
794         bytes[] memory dynargs = new bytes[](4);
795         dynargs[0] = args[0];
796         dynargs[1] = args[1];
797         dynargs[2] = args[2];
798         dynargs[3] = args[3];
799         return oraclize_query(datasource, dynargs, gaslimit);
800     }
801     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
802         bytes[] memory dynargs = new bytes[](5);
803         dynargs[0] = args[0];
804         dynargs[1] = args[1];
805         dynargs[2] = args[2];
806         dynargs[3] = args[3];
807         dynargs[4] = args[4];
808         return oraclize_query(datasource, dynargs);
809     }
810     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
811         bytes[] memory dynargs = new bytes[](5);
812         dynargs[0] = args[0];
813         dynargs[1] = args[1];
814         dynargs[2] = args[2];
815         dynargs[3] = args[3];
816         dynargs[4] = args[4];
817         return oraclize_query(timestamp, datasource, dynargs);
818     }
819     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
820         bytes[] memory dynargs = new bytes[](5);
821         dynargs[0] = args[0];
822         dynargs[1] = args[1];
823         dynargs[2] = args[2];
824         dynargs[3] = args[3];
825         dynargs[4] = args[4];
826         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
827     }
828     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
829         bytes[] memory dynargs = new bytes[](5);
830         dynargs[0] = args[0];
831         dynargs[1] = args[1];
832         dynargs[2] = args[2];
833         dynargs[3] = args[3];
834         dynargs[4] = args[4];
835         return oraclize_query(datasource, dynargs, gaslimit);
836     }
837 
838     function oraclize_cbAddress() oraclizeAPI internal returns (address){
839         return oraclize.cbAddress();
840     }
841     function oraclize_setProof(byte proofP) oraclizeAPI internal {
842         return oraclize.setProofType(proofP);
843     }
844     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
845         return oraclize.setCustomGasPrice(gasPrice);
846     }
847 
848     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
849         return oraclize.randomDS_getSessionPubKeyHash();
850     }
851 
852     function getCodeSize(address _addr) constant internal returns(uint _size) {
853         assembly {
854             _size := extcodesize(_addr)
855         }
856     }
857 
858     function parseAddr(string _a) internal pure returns (address){
859         bytes memory tmp = bytes(_a);
860         uint160 iaddr = 0;
861         uint160 b1;
862         uint160 b2;
863         for (uint i=2; i<2+2*20; i+=2){
864             iaddr *= 256;
865             b1 = uint160(tmp[i]);
866             b2 = uint160(tmp[i+1]);
867             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
868             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
869             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
870             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
871             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
872             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
873             iaddr += (b1*16+b2);
874         }
875         return address(iaddr);
876     }
877 
878     function strCompare(string _a, string _b) internal pure returns (int) {
879         bytes memory a = bytes(_a);
880         bytes memory b = bytes(_b);
881         uint minLength = a.length;
882         if (b.length < minLength) minLength = b.length;
883         for (uint i = 0; i < minLength; i ++)
884             if (a[i] < b[i])
885                 return -1;
886             else if (a[i] > b[i])
887                 return 1;
888         if (a.length < b.length)
889             return -1;
890         else if (a.length > b.length)
891             return 1;
892         else
893             return 0;
894     }
895 
896     function indexOf(string _haystack, string _needle) internal pure returns (int) {
897         bytes memory h = bytes(_haystack);
898         bytes memory n = bytes(_needle);
899         if(h.length < 1 || n.length < 1 || (n.length > h.length))
900             return -1;
901         else if(h.length > (2**128 -1))
902             return -1;
903         else
904         {
905             uint subindex = 0;
906             for (uint i = 0; i < h.length; i ++)
907             {
908                 if (h[i] == n[0])
909                 {
910                     subindex = 1;
911                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
912                     {
913                         subindex++;
914                     }
915                     if(subindex == n.length)
916                         return int(i);
917                 }
918             }
919             return -1;
920         }
921     }
922 
923     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
924         bytes memory _ba = bytes(_a);
925         bytes memory _bb = bytes(_b);
926         bytes memory _bc = bytes(_c);
927         bytes memory _bd = bytes(_d);
928         bytes memory _be = bytes(_e);
929         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
930         bytes memory babcde = bytes(abcde);
931         uint k = 0;
932         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
933         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
934         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
935         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
936         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
937         return string(babcde);
938     }
939 
940     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
941         return strConcat(_a, _b, _c, _d, "");
942     }
943 
944     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
945         return strConcat(_a, _b, _c, "", "");
946     }
947 
948     function strConcat(string _a, string _b) internal pure returns (string) {
949         return strConcat(_a, _b, "", "", "");
950     }
951 
952     // parseInt
953     function parseInt(string _a) internal pure returns (uint) {
954         return parseInt(_a, 0);
955     }
956 
957     // parseInt(parseFloat*10^_b)
958     function parseInt(string _a, uint _b) internal pure returns (uint) {
959         bytes memory bresult = bytes(_a);
960         uint mint = 0;
961         bool decimals = false;
962         for (uint i=0; i<bresult.length; i++){
963             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
964                 if (decimals){
965                    if (_b == 0) break;
966                     else _b--;
967                 }
968                 mint *= 10;
969                 mint += uint(bresult[i]) - 48;
970             } else if (bresult[i] == 46) decimals = true;
971         }
972         if (_b > 0) mint *= 10**_b;
973         return mint;
974     }
975 
976     function uint2str(uint i) internal pure returns (string){
977         if (i == 0) return "0";
978         uint j = i;
979         uint len;
980         while (j != 0){
981             len++;
982             j /= 10;
983         }
984         bytes memory bstr = new bytes(len);
985         uint k = len - 1;
986         while (i != 0){
987             bstr[k--] = byte(48 + i % 10);
988             i /= 10;
989         }
990         return string(bstr);
991     }
992 
993     function stra2cbor(string[] arr) internal pure returns (bytes) {
994             uint arrlen = arr.length;
995 
996             // get correct cbor output length
997             uint outputlen = 0;
998             bytes[] memory elemArray = new bytes[](arrlen);
999             for (uint i = 0; i < arrlen; i++) {
1000                 elemArray[i] = (bytes(arr[i]));
1001                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1002             }
1003             uint ctr = 0;
1004             uint cborlen = arrlen + 0x80;
1005             outputlen += byte(cborlen).length;
1006             bytes memory res = new bytes(outputlen);
1007 
1008             while (byte(cborlen).length > ctr) {
1009                 res[ctr] = byte(cborlen)[ctr];
1010                 ctr++;
1011             }
1012             for (i = 0; i < arrlen; i++) {
1013                 res[ctr] = 0x5F;
1014                 ctr++;
1015                 for (uint x = 0; x < elemArray[i].length; x++) {
1016                     // if there's a bug with larger strings, this may be the culprit
1017                     if (x % 23 == 0) {
1018                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1019                         elemcborlen += 0x40;
1020                         uint lctr = ctr;
1021                         while (byte(elemcborlen).length > ctr - lctr) {
1022                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1023                             ctr++;
1024                         }
1025                     }
1026                     res[ctr] = elemArray[i][x];
1027                     ctr++;
1028                 }
1029                 res[ctr] = 0xFF;
1030                 ctr++;
1031             }
1032             return res;
1033         }
1034 
1035     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1036             uint arrlen = arr.length;
1037 
1038             // get correct cbor output length
1039             uint outputlen = 0;
1040             bytes[] memory elemArray = new bytes[](arrlen);
1041             for (uint i = 0; i < arrlen; i++) {
1042                 elemArray[i] = (bytes(arr[i]));
1043                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1044             }
1045             uint ctr = 0;
1046             uint cborlen = arrlen + 0x80;
1047             outputlen += byte(cborlen).length;
1048             bytes memory res = new bytes(outputlen);
1049 
1050             while (byte(cborlen).length > ctr) {
1051                 res[ctr] = byte(cborlen)[ctr];
1052                 ctr++;
1053             }
1054             for (i = 0; i < arrlen; i++) {
1055                 res[ctr] = 0x5F;
1056                 ctr++;
1057                 for (uint x = 0; x < elemArray[i].length; x++) {
1058                     // if there's a bug with larger strings, this may be the culprit
1059                     if (x % 23 == 0) {
1060                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1061                         elemcborlen += 0x40;
1062                         uint lctr = ctr;
1063                         while (byte(elemcborlen).length > ctr - lctr) {
1064                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1065                             ctr++;
1066                         }
1067                     }
1068                     res[ctr] = elemArray[i][x];
1069                     ctr++;
1070                 }
1071                 res[ctr] = 0xFF;
1072                 ctr++;
1073             }
1074             return res;
1075         }
1076 
1077 
1078     string oraclize_network_name;
1079     function oraclize_setNetworkName(string _network_name) internal {
1080         oraclize_network_name = _network_name;
1081     }
1082 
1083     function oraclize_getNetworkName() internal view returns (string) {
1084         return oraclize_network_name;
1085     }
1086 
1087     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1088         require((_nbytes > 0) && (_nbytes <= 32));
1089         // Convert from seconds to ledger timer ticks
1090         _delay *= 10; 
1091         bytes memory nbytes = new bytes(1);
1092         nbytes[0] = byte(_nbytes);
1093         bytes memory unonce = new bytes(32);
1094         bytes memory sessionKeyHash = new bytes(32);
1095         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1096         assembly {
1097             mstore(unonce, 0x20)
1098             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1099             mstore(sessionKeyHash, 0x20)
1100             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1101         }
1102         bytes memory delay = new bytes(32);
1103         assembly { 
1104             mstore(add(delay, 0x20), _delay) 
1105         }
1106         
1107         bytes memory delay_bytes8 = new bytes(8);
1108         copyBytes(delay, 24, 8, delay_bytes8, 0);
1109 
1110         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1111         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1112         
1113         bytes memory delay_bytes8_left = new bytes(8);
1114         
1115         assembly {
1116             let x := mload(add(delay_bytes8, 0x20))
1117             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1119             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1124             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1125 
1126         }
1127         
1128         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1129         return queryId;
1130     }
1131     
1132     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1133         oraclize_randomDS_args[queryId] = commitment;
1134     }
1135 
1136     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1137     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1138 
1139     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1140         bool sigok;
1141         address signer;
1142 
1143         bytes32 sigr;
1144         bytes32 sigs;
1145 
1146         bytes memory sigr_ = new bytes(32);
1147         uint offset = 4+(uint(dersig[3]) - 0x20);
1148         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1149         bytes memory sigs_ = new bytes(32);
1150         offset += 32 + 2;
1151         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1152 
1153         assembly {
1154             sigr := mload(add(sigr_, 32))
1155             sigs := mload(add(sigs_, 32))
1156         }
1157 
1158 
1159         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1160         if (address(keccak256(pubkey)) == signer) return true;
1161         else {
1162             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1163             return (address(keccak256(pubkey)) == signer);
1164         }
1165     }
1166 
1167     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1168         bool sigok;
1169 
1170         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1171         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1172         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1173 
1174         bytes memory appkey1_pubkey = new bytes(64);
1175         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1176 
1177         bytes memory tosign2 = new bytes(1+65+32);
1178         tosign2[0] = byte(1); //role
1179         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1180         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1181         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1182         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1183 
1184         if (sigok == false) return false;
1185 
1186 
1187         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1188         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1189 
1190         bytes memory tosign3 = new bytes(1+65);
1191         tosign3[0] = 0xFE;
1192         copyBytes(proof, 3, 65, tosign3, 1);
1193 
1194         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1195         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1196 
1197         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1198 
1199         return sigok;
1200     }
1201 
1202     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1203         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1204         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1205 
1206         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1207         require(proofVerified);
1208 
1209         _;
1210     }
1211 
1212     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1213         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1214         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1215 
1216         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1217         if (proofVerified == false) return 2;
1218 
1219         return 0;
1220     }
1221 
1222     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1223         bool match_ = true;
1224         
1225         require(prefix.length == n_random_bytes);
1226 
1227         for (uint256 i=0; i< n_random_bytes; i++) {
1228             if (content[i] != prefix[i]) match_ = false;
1229         }
1230 
1231         return match_;
1232     }
1233 
1234     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1235 
1236         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1237         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1238         bytes memory keyhash = new bytes(32);
1239         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1240         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1241 
1242         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1243         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1244 
1245         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1246         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1247 
1248         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1249         // This is to verify that the computed args match with the ones specified in the query.
1250         bytes memory commitmentSlice1 = new bytes(8+1+32);
1251         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1252 
1253         bytes memory sessionPubkey = new bytes(64);
1254         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1255         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1256 
1257         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1258         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1259             delete oraclize_randomDS_args[queryId];
1260         } else return false;
1261 
1262 
1263         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1264         bytes memory tosign1 = new bytes(32+8+1+32);
1265         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1266         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1267 
1268         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1269         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1270             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1271         }
1272 
1273         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1274     }
1275 
1276     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1277     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1278         uint minLength = length + toOffset;
1279 
1280         // Buffer too small
1281         require(to.length >= minLength); // Should be a better way?
1282 
1283         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1284         uint i = 32 + fromOffset;
1285         uint j = 32 + toOffset;
1286 
1287         while (i < (32 + fromOffset + length)) {
1288             assembly {
1289                 let tmp := mload(add(from, i))
1290                 mstore(add(to, j), tmp)
1291             }
1292             i += 32;
1293             j += 32;
1294         }
1295 
1296         return to;
1297     }
1298 
1299     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1300     // Duplicate Solidity's ecrecover, but catching the CALL return value
1301     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1302         // We do our own memory management here. Solidity uses memory offset
1303         // 0x40 to store the current end of memory. We write past it (as
1304         // writes are memory extensions), but don't update the offset so
1305         // Solidity will reuse it. The memory used here is only needed for
1306         // this context.
1307 
1308         // FIXME: inline assembly can't access return values
1309         bool ret;
1310         address addr;
1311 
1312         assembly {
1313             let size := mload(0x40)
1314             mstore(size, hash)
1315             mstore(add(size, 32), v)
1316             mstore(add(size, 64), r)
1317             mstore(add(size, 96), s)
1318 
1319             // NOTE: we can reuse the request memory because we deal with
1320             //       the return code
1321             ret := call(3000, 1, 0, size, 128, size, 32)
1322             addr := mload(size)
1323         }
1324 
1325         return (ret, addr);
1326     }
1327 
1328     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1329     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1330         bytes32 r;
1331         bytes32 s;
1332         uint8 v;
1333 
1334         if (sig.length != 65)
1335           return (false, 0);
1336 
1337         // The signature format is a compact form of:
1338         //   {bytes32 r}{bytes32 s}{uint8 v}
1339         // Compact means, uint8 is not padded to 32 bytes.
1340         assembly {
1341             r := mload(add(sig, 32))
1342             s := mload(add(sig, 64))
1343 
1344             // Here we are loading the last 32 bytes. We exploit the fact that
1345             // 'mload' will pad with zeroes if we overread.
1346             // There is no 'mload8' to do this, but that would be nicer.
1347             v := byte(0, mload(add(sig, 96)))
1348 
1349             // Alternative solution:
1350             // 'byte' is not working due to the Solidity parser, so lets
1351             // use the second best option, 'and'
1352             // v := and(mload(add(sig, 65)), 255)
1353         }
1354 
1355         // albeit non-transactional signatures are not specified by the YP, one would expect it
1356         // to match the YP range of [27, 28]
1357         //
1358         // geth uses [0, 1] and some clients have followed. This might change, see:
1359         //  https://github.com/ethereum/go-ethereum/issues/2053
1360         if (v < 27)
1361           v += 27;
1362 
1363         if (v != 27 && v != 28)
1364             return (false, 0);
1365 
1366         return safer_ecrecover(hash, v, r, s);
1367     }
1368 
1369 }
1370 // </ORACLIZE_API>
1371 
1372 // File: contracts/PriceChecker.sol
1373 
1374 /**
1375  * @title Price Checker
1376  * @author Bram Hoven
1377  * @notice Retrieves the current Ether price in euros and converts it to the amount of fida per ether
1378  */
1379 contract PriceChecker is usingOraclize {
1380 
1381   // The address that is allowed to call the `updatePrice()` function
1382   address priceCheckerAddress;
1383   // Current price of ethereum in euros
1384   string public ETHEUR = "571.85000";
1385   // Amount of fida per ether
1386   uint256 public fidaPerEther = 57185000;
1387   // Latest callback id
1388   mapping(bytes32 => bool) public ids;
1389   // Gaslimit to be used by oraclize
1390   uint256 gasLimit = 58598;
1391 
1392   /**
1393    * @notice Triggered when price is updated
1394    * @param _id Oraclize query id
1395    * @param _price Price of 1 ether in euro's
1396    */
1397   event PriceUpdated(bytes32 _id, string _price);
1398   /**
1399    * @notice Triggered when updatePrice() is called
1400    * @param _id Oraclize query id
1401    * @param _fees The price of the oraclize call in ether
1402    */
1403   event NewOraclizeQuery(bytes32 _id, uint256 _fees);
1404 
1405   /**
1406    * @notice Triggered when fee is lower than this.balance
1407    * @param _description String with message
1408    * @param _fees The amount of wei it cost to perform this query
1409    */
1410   event OraclizeQueryNotSend(string _description, uint256 _fees);
1411 
1412   /**
1413    * @notice Contructor for initializing the pricechecker
1414    * @param _priceCheckerAddress Address which is allow to call `updatePrice()`
1415    */
1416   constructor(address _priceCheckerAddress) public payable {
1417     priceCheckerAddress = _priceCheckerAddress;
1418 
1419     _updatePrice();
1420   }
1421 
1422   /**
1423    * @notice Function for updating the price stored in this contract
1424    */
1425   function updatePrice() public payable {
1426     require(msg.sender == priceCheckerAddress);
1427 
1428     _updatePrice();
1429   }
1430 
1431   function _updatePrice() private {
1432     if (oraclize_getPrice("URL", gasLimit) > address(this).balance) {
1433       emit OraclizeQueryNotSend("Oraclize query was NOT sent, please add some ETH to cover for the query fee", oraclize_getPrice("URL"));
1434     } else {
1435       bytes32 id = oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.a[0]", gasLimit);
1436       ids[id] = true;
1437       emit NewOraclizeQuery(id, oraclize_getPrice("URL"));
1438     }
1439   }
1440 
1441   /**
1442    * @notice Oraclize callback function
1443    * @param _id The id of the query
1444    * @param _result Result of the query
1445    */
1446   function __callback(bytes32 _id, string _result) public {
1447     require(msg.sender == oraclize_cbAddress());
1448     require(ids[_id] == true);
1449 
1450     ETHEUR = _result;
1451     // Save price of ether as an uint without the 5 decimals (350.00000 * 10**5 = 35000000)
1452     fidaPerEther = parseInt(_result, 5);
1453 
1454     emit PriceUpdated(_id, _result);
1455   }
1456 
1457   /**
1458    * @notice Change gasLimit
1459    */
1460   function changeGasLimit(uint256 _gasLimit) public {
1461     require(msg.sender == priceCheckerAddress);
1462 
1463     gasLimit = _gasLimit;
1464   }
1465 }
1466 
1467 // File: contracts/interfaces/MemberManagerInterface.sol
1468 
1469 /**
1470  * @title Member Manager Interface
1471  * @author Bram Hoven
1472  */
1473 interface MemberManagerInterface {
1474   /**
1475    * @notice Triggered when member is added
1476    * @param member Address of newly added member
1477    */
1478   event MemberAdded(address indexed member);
1479 
1480   /**
1481    * @notice Triggered when member is removed
1482    * @param member Address of removed member
1483    */
1484   event MemberRemoved(address indexed member);
1485 
1486   /**
1487    * @notice Triggered when member has bought tokens
1488    * @param member Address of member
1489    * @param tokensBought Amount of tokens bought
1490    * @param tokens Amount of total tokens bought by member
1491    */
1492   event TokensBought(address indexed member, uint256 tokensBought, uint256 tokens);
1493 
1494   /**
1495    * @notice Remove a member from this contract
1496    * @param _member Address of member that will be removed
1497    */
1498   function removeMember(address _member) external;
1499 
1500   /**
1501    * @notice Add to the amount this member has bought
1502    * @param _member Address of the corresponding member
1503    * @param _amountBought Amount of tokens this member has bought
1504    */
1505   function addAmountBoughtAsMember(address _member, uint256 _amountBought) external;
1506 }
1507 
1508 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
1509 
1510 /**
1511  * @title ERC20Basic
1512  * @dev Simpler version of ERC20 interface
1513  * @dev see https://github.com/ethereum/EIPs/issues/179
1514  */
1515 contract ERC20Basic {
1516   function totalSupply() public view returns (uint256);
1517   function balanceOf(address who) public view returns (uint256);
1518   function transfer(address to, uint256 value) public returns (bool);
1519   event Transfer(address indexed from, address indexed to, uint256 value);
1520 }
1521 
1522 // File: contracts/FidaSale.sol
1523 
1524 /**
1525  * @title Fida Sale
1526  * @author Bram Hoven
1527  * @notice Contract which will run the fida sale
1528  */
1529 contract FidaSale is BonusProgram, BountyProgram, PriceChecker {
1530   using SafeMath for uint256;
1531 
1532   // Wownity wallet
1533   address public wallet;
1534 
1535   // Address which can buy tokens that have been bought with btc
1536   address public btcTokenBoughtAddress;
1537   // Address which can add addresses to the whitelist
1538   address public whitelistingAddress;
1539 
1540   // Contract Manager
1541   ContractManagerInterface private contractManager;
1542   // Name of this contract
1543   string private contractName;
1544 
1545   // The fida ERC20 token
1546   ERC20Basic private fidaToken;
1547   // The fida mintable token
1548   MintableTokenInterface private mintableFida;
1549   // Address on which the fida ERC20 contract is deployed
1550   address public fidaTokenAddress;
1551   // Amount of decimals specified for the ERC20 token
1552   uint256 public DECIMALS = 18;
1553 
1554   // Contract for earlybird check
1555   MemberManagerInterface public earlybird;
1556 
1557   // Total amount of investors
1558   uint256 public investorCount;
1559 
1560   // Investor whitelist
1561   mapping(address => bool) public whitelist;
1562   // Mapping of all our investors and amount they invested
1563   mapping(address => uint256) public investors;
1564 
1565   // Initial amount of bonus program tokens
1566   uint256 public INITIAL_BONUSLIST_TOKENS = 150 * 10**5 * 10**DECIMALS; // 15,000,000 fida
1567   // Initial amount of earlybird program tokens
1568   uint256 public INITIAL_EARLYBIRD_TOKENS = 50 * 10**5 * 10**DECIMALS; // 5,000,000 fida
1569   // Tokens that have been bought in early bird program
1570   uint256 public tokensBoughtInEarlybird = 0;
1571 
1572   // Shows the state of the bonus program
1573   bool public bonusProgramEnded = false;
1574   // Shows the state of the earlybird progran
1575   bool public earlybirdEnded = false;
1576 
1577   // Shows whether the fida sale has started
1578   bool public started = false;
1579   // Shows the state of the fida sale
1580   bool public finished = false;
1581 
1582   /**
1583    * @notice Triggered when token address is changed
1584    * @param _oldAddress Address where the ERC20 contract used to be
1585    * @param _newAddress Address where the new ERC20 contract is now deployed
1586    */
1587   event TokenAddressChanged(address indexed _oldAddress, address indexed _newAddress);
1588 
1589   /**
1590    * @notice Triggered when wallet address is changed
1591    * @param _oldAddress Address where the wallet used to be
1592    * @param _newAddress Address where the new wallet is
1593    */
1594   event WalletAddressChanged(address indexed _oldAddress, address indexed _newAddress);
1595 
1596   /**
1597    * @notice Triggered when btc token bought address is changed
1598    * @param _oldAddress Address what the authorized address used to be
1599    * @param _newAddress Address what the authorized address 
1600    */
1601   event BtcTokenBoughtAddressChanged(address indexed _oldAddress, address indexed _newAddress);
1602 
1603   /**
1604    * @notice Triggered when the whitelisting address is changed
1605    * @param _oldAddress Address what the authorized address used to be
1606    * @param _newAddress Address what the authorized address 
1607    */
1608   event WhitelistingAddressChanged(address indexed _oldAddress, address indexed _newAddress);
1609 
1610   /**
1611    * @notice Triggered when the whitelisting has changed for an address
1612    * @param _address Address which whitelisting status has changed
1613    * @param _whitelisted Status of his whitelisting (true = whitelisted)
1614    */
1615   event WhitelistChanged(address indexed _address, bool _whitelisted);
1616 
1617   /**
1618    * @notice Triggered when sale has started
1619    */
1620   event StartedSale();
1621 
1622   /**
1623    * @notice Triggered when sale has ended
1624    */
1625   event FinishedSale();
1626 
1627   /**
1628    * @notice Triggered when a early bird purchase has been made
1629    * @param _buyer Address who bought the tokens
1630    * @param _tokens Amount of tokens that have been bought
1631    */
1632   event BoughtEarlyBird(address indexed _buyer, uint256 _tokens);
1633 
1634   /**
1635    * @notice Triggered when a bonus program purchase has been made
1636    * @param _buyer Address who bought the tokens
1637    * @param _tokens Amount of tokens bought excl. bonus tokens
1638    * @param _bonusTokens Amount of bonus tokens received
1639    */
1640   event BoughtBonusProgram(address indexed _buyer, uint256 _tokens, uint256 _bonusTokens);
1641 
1642   /**
1643    * @notice Contructor for creating the fida sale
1644    * @param _contractName Name of this contract in the contract manager
1645    * @param _wallet Address of wallet where funds will be send
1646    * @param _bountyAddress Address of wallet where bounty tokens will be send to
1647    * @param _btcTokenBoughtAddress Address which is authorized to send tokens bought with btc
1648    * @param _whitelistingAddress Address which is authorized to add address to the whitelist
1649    * @param _priceCheckerAddress Address which is allow to call `updatePrice()`
1650    * @param _contractManager Address where the contract manager is deployed
1651    * @param _tokenContractName Name of the token contract in the contract manager
1652    * @param _memberContractName Name of the member manager contract in the contract manager
1653    */
1654   constructor(string _contractName, address _wallet, address _bountyAddress, address _btcTokenBoughtAddress, address _whitelistingAddress, address _priceCheckerAddress, address _contractManager, string _tokenContractName, string _memberContractName) public payable 
1655     BonusProgram(INITIAL_BONUSLIST_TOKENS) 
1656     BountyProgram(_contractName, _bountyAddress, _bountyAddress, _contractManager) 
1657     PriceChecker(_priceCheckerAddress) {
1658 
1659     contractName = _contractName;
1660     wallet = _wallet;
1661     btcTokenBoughtAddress = _btcTokenBoughtAddress;
1662     whitelistingAddress = _whitelistingAddress;
1663     contractManager = ContractManagerInterface(_contractManager);
1664 
1665     _changeTokenAddress(contractManager.getContract(_tokenContractName));
1666     earlybird = MemberManagerInterface(contractManager.getContract(_memberContractName));
1667   }
1668 
1669   /**
1670    * @notice Internal function for changing the token address
1671    * @param _tokenAddress Address where the new ERC20 contract is deployed
1672    */
1673   function _changeTokenAddress(address _tokenAddress) internal {
1674     require(_tokenAddress != address(0));
1675 
1676     address oldAddress = fidaTokenAddress;
1677     fidaTokenAddress = _tokenAddress;
1678     fidaToken = ERC20Basic(_tokenAddress);
1679     mintableFida = MintableTokenInterface(_tokenAddress);
1680 
1681     emit TokenAddressChanged(oldAddress, _tokenAddress);
1682   }
1683 
1684   /**
1685    * @notice Change the wallet where ether will be sent to when tokens are bought
1686    * @param _walletAddress Address of the wallet
1687    */
1688   function setWalletAddress(address _walletAddress) external {
1689     require(contractManager.authorize(contractName, msg.sender));
1690     require(_walletAddress != address(0));
1691     require(_walletAddress != wallet);
1692 
1693     address oldAddress = wallet;
1694     wallet = _walletAddress;
1695 
1696     emit WalletAddressChanged(oldAddress, _walletAddress);
1697   }
1698   
1699   /**
1700    * @notice Change the address which is authorized to send bought tokens with BTC
1701    * @param _address Address of the authorized btc tokens bought client
1702    */
1703   function setBtcTokenBoughtAddress(address _address) external {
1704     require(contractManager.authorize(contractName, msg.sender));
1705     require(_address != address(0));
1706     require(_address != btcTokenBoughtAddress);
1707 
1708     address oldAddress = btcTokenBoughtAddress;
1709     btcTokenBoughtAddress = _address;
1710 
1711     emit BtcTokenBoughtAddressChanged(oldAddress, _address);
1712   }
1713 
1714   /**
1715    * @notice Change the address that is authorized to change whitelist
1716    * @param _address The authorized address
1717    */
1718   function setWhitelistingAddress(address _address) external {
1719     require(contractManager.authorize(contractName, msg.sender));
1720     require(_address != address(0));
1721     require(_address != whitelistingAddress);
1722 
1723     address oldAddress = whitelistingAddress;
1724     whitelistingAddress = _address;
1725 
1726     emit WhitelistingAddressChanged(oldAddress, _address);
1727   }
1728 
1729   /**
1730    * @notice Set the whitelist status for an address
1731    * @param _address Address which will have his status changed
1732    * @param _whitelisted True or False whether whitelisted or not
1733    */
1734   function setWhitelistStatus(address _address, bool _whitelisted) external {
1735     require(msg.sender == whitelistingAddress);
1736     require(whitelist[_address] != _whitelisted);
1737 
1738     whitelist[_address] = _whitelisted;
1739 
1740     emit WhitelistChanged(_address, _whitelisted);
1741   }
1742 
1743   /**
1744    * @notice Get the whitelist status for an address
1745    * @param _address Address which is or isn't whitelisted
1746    */
1747   function getWhitelistStatus(address _address) external view returns (bool _whitelisted) {
1748     require(msg.sender == whitelistingAddress);
1749 
1750     return whitelist[_address];
1751   }
1752 
1753   /**
1754    * @notice Amount of fida you would get for any amount in wei
1755    * @param _weiAmount Amount of wei you want to know the amount of fida for
1756    */
1757   function getAmountFida(uint256 _weiAmount) public view returns (uint256 _fidaAmount) {
1758     require(_weiAmount != 0);
1759 
1760     // fidaPerEther has been mutliplied by 10**5 because of decimals
1761     // so we have to divide by 100000
1762     _fidaAmount = _weiAmount.mul(fidaPerEther).div(100000);
1763 
1764     return _fidaAmount;
1765   }
1766 
1767   /**
1768    * @notice Internal function for investing as a earlybird member
1769    * @param _beneficiary Address on which tokens will be deposited
1770    * @param _amountTokens Amount of tokens that will be bought
1771    */
1772   function _investAsEarlybird(address _beneficiary, uint256 _amountTokens) internal {
1773     tokensBoughtInEarlybird = tokensBoughtInEarlybird.add(_amountTokens);
1774 
1775     earlybird.addAmountBoughtAsMember(_beneficiary, _amountTokens);
1776     _depositTokens(_beneficiary, _amountTokens);
1777 
1778     emit BoughtEarlyBird(_beneficiary, _amountTokens);
1779 
1780     if (tokensBoughtInEarlybird >= INITIAL_EARLYBIRD_TOKENS) {
1781       earlybirdEnded = true;
1782     }
1783   }
1784 
1785   /**
1786    * @notice Internal function for invest as a bonusprogram member
1787    * @param _beneficiary Address on which tokens will be deposited
1788    * @param _amountTokens Amount of tokens that will be bought
1789    */
1790   function _investAsBonusProgram(address _beneficiary, uint256 _amountTokens) internal {
1791     uint256 bonusTokens = _calculateBonus(_amountTokens, tokensBoughtInBonusProgram);
1792     uint256 amountTokensWithBonus = _amountTokens.add(bonusTokens);
1793 
1794     tokensBoughtInBonusProgram = tokensBoughtInBonusProgram.add(_amountTokens);
1795 
1796     _depositTokens(_beneficiary, amountTokensWithBonus);
1797 
1798     emit BoughtBonusProgram(_beneficiary, _amountTokens, bonusTokens);
1799 
1800     if (tokensBoughtInBonusProgram >= INITIAL_BONUSLIST_TOKENS) {
1801       bonusProgramEnded = true;
1802     }
1803   }
1804 
1805   /**
1806    * @notice Internal function for depositing tokens after they had been bought
1807    * @param _beneficiary Address on which the tokens will be deposited
1808    * @param _amountTokens Amount of tokens that have been bought
1809    */
1810   function _depositTokens(address _beneficiary, uint256 _amountTokens) internal {
1811     require(_amountTokens != 0);
1812 
1813     if (investors[_beneficiary] == 0) {
1814       investorCount++;
1815     }
1816 
1817     investors[_beneficiary] = investors[_beneficiary].add(_amountTokens);
1818 
1819     mintableFida.sendBoughtTokens(_beneficiary, _amountTokens);
1820   }
1821 
1822   /**
1823    * @notice Public payable function to buy tokens during sale or emission
1824    * @param _beneficiary Address to which tokens will be deposited
1825    */
1826   function buyTokens(address _beneficiary) public payable {
1827     require(started);
1828     require(!finished);
1829     require(_beneficiary != address(0));
1830     require(msg.value != 0);
1831     require(whitelist[msg.sender] && whitelist[_beneficiary]);
1832     require(fidaToken.totalSupply() < 24750 * 10**3 * 10**DECIMALS);
1833 
1834     uint256 amountTokens = getAmountFida(msg.value);
1835     require(amountTokens >= 50 * 10**DECIMALS);
1836 
1837     if (!earlybirdEnded) {
1838       _investAsEarlybird(_beneficiary, amountTokens);
1839     } else {
1840       _investAsBonusProgram(_beneficiary, amountTokens);
1841     }
1842 
1843     wallet.transfer(msg.value);
1844   }
1845 
1846   /**
1847    * @notice Public payable function to buy tokens during sale or emission
1848    * @param _beneficiary Address to which tokens will be deposited
1849    * @param _tokens Amount of tokens that will be bought
1850    */
1851   function tokensBoughtWithBTC(address _beneficiary, uint256 _tokens) public payable {
1852     require(msg.sender == btcTokenBoughtAddress);
1853     require(started);
1854     require(!finished);
1855     require(_beneficiary != address(0));
1856     require(whitelist[_beneficiary]);
1857     require(fidaToken.totalSupply() < 24750 * 10**3 * 10**DECIMALS);
1858     require(_tokens >= 50 * 10**DECIMALS);
1859 
1860     if (!earlybirdEnded) {
1861       _investAsEarlybird(_beneficiary, _tokens);
1862     } else {
1863       _investAsBonusProgram(_beneficiary, _tokens);
1864     }
1865   }
1866 
1867   /**
1868    * @notice Anonymous payable function, this makes it easier for people to buy their tokens
1869    */
1870   function () public payable {
1871     buyTokens(msg.sender);
1872   }
1873 
1874   /**
1875    * @notice Function to start this sale
1876    */
1877   function startSale() public {
1878     require(contractManager.authorize(contractName, msg.sender));
1879     require(!started);
1880     require(!finished);
1881 
1882     started = true;
1883 
1884     emit StartedSale();
1885   }
1886 
1887   /**
1888    * @notice Function to finish this sale
1889    */
1890   function finishedSale() public {
1891     require(contractManager.authorize(contractName, msg.sender));
1892     require(started);
1893     require(!finished);
1894 
1895     finished = true;
1896 
1897     emit FinishedSale();
1898   }
1899 }