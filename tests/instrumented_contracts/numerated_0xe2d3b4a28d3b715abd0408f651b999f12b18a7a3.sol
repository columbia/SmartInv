1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/utility/interfaces/IOwned.sol
23 
24 /*
25     Owned contract interface
26 */
27 contract IOwned {
28     // this function isn't abstract since the compiler emits automatically generated getter functions as external
29     function owner() public view returns (address) {}
30 
31     function transferOwnership(address _newOwner) public;
32     function acceptOwnership() public;
33 }
34 
35 // File: contracts/token/interfaces/ISmartToken.sol
36 
37 /*
38     Smart Token interface
39 */
40 contract ISmartToken is IOwned, IERC20Token {
41     function disableTransfers(bool _disable) public;
42     function issue(address _to, uint256 _amount) public;
43     function destroy(address _from, uint256 _amount) public;
44 }
45 
46 // File: contracts/utility/interfaces/IWhitelist.sol
47 
48 /*
49     Whitelist interface
50 */
51 contract IWhitelist {
52     function isWhitelisted(address _address) public view returns (bool);
53 }
54 
55 // File: contracts/converter/interfaces/IBancorConverter.sol
56 
57 /*
58     Bancor Converter interface
59 */
60 contract IBancorConverter {
61     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
62     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
63     function conversionWhitelist() public view returns (IWhitelist) {}
64     function conversionFee() public view returns (uint32) {}
65     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
66     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
67     function claimTokens(address _from, uint256 _amount) public;
68     // deprecated, backward compatibility
69     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
70 }
71 
72 // File: contracts/ContractIds.sol
73 
74 /**
75     Id definitions for bancor contracts
76 
77     Can be used in conjunction with the contract registry to get contract addresses
78 */
79 contract ContractIds {
80     // generic
81     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
82     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
83 
84     // bancor logic
85     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
86     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
87     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
88     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
89     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
90 
91     // Ids of BNT converter and BNT token
92     bytes32 public constant BNT_TOKEN = "BNTToken";
93     bytes32 public constant BNT_CONVERTER = "BNTConverter";
94 
95     // Id of BancorX contract
96     bytes32 public constant BANCOR_X = "BancorX";
97 }
98 
99 // File: contracts/utility/interfaces/IContractRegistry.sol
100 
101 /*
102     Contract Registry interface
103 */
104 contract IContractRegistry {
105     function addressOf(bytes32 _contractName) public view returns (address);
106 
107     // deprecated, backward compatibility
108     function getAddress(bytes32 _contractName) public view returns (address);
109 }
110 
111 // File: contracts/utility/Owned.sol
112 
113 /*
114     Provides support and utilities for contract ownership
115 */
116 contract Owned is IOwned {
117     address public owner;
118     address public newOwner;
119 
120     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
121 
122     /**
123         @dev constructor
124     */
125     constructor() public {
126         owner = msg.sender;
127     }
128 
129     // allows execution by the owner only
130     modifier ownerOnly {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     /**
136         @dev allows transferring the contract ownership
137         the new owner still needs to accept the transfer
138         can only be called by the contract owner
139 
140         @param _newOwner    new contract owner
141     */
142     function transferOwnership(address _newOwner) public ownerOnly {
143         require(_newOwner != owner);
144         newOwner = _newOwner;
145     }
146 
147     /**
148         @dev used by a new owner to accept an ownership transfer
149     */
150     function acceptOwnership() public {
151         require(msg.sender == newOwner);
152         emit OwnerUpdate(owner, newOwner);
153         owner = newOwner;
154         newOwner = address(0);
155     }
156 }
157 
158 // File: contracts/utility/Utils.sol
159 
160 /*
161     Utilities & Common Modifiers
162 */
163 contract Utils {
164     /**
165         constructor
166     */
167     constructor() public {
168     }
169 
170     // verifies that an amount is greater than zero
171     modifier greaterThanZero(uint256 _amount) {
172         require(_amount > 0);
173         _;
174     }
175 
176     // validates an address - currently only checks that it isn't null
177     modifier validAddress(address _address) {
178         require(_address != address(0));
179         _;
180     }
181 
182     // verifies that the address is different than this contract address
183     modifier notThis(address _address) {
184         require(_address != address(this));
185         _;
186     }
187 
188     // Overflow protected math functions
189 
190     /**
191         @dev returns the sum of _x and _y, asserts if the calculation overflows
192 
193         @param _x   value 1
194         @param _y   value 2
195 
196         @return sum
197     */
198     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
199         uint256 z = _x + _y;
200         assert(z >= _x);
201         return z;
202     }
203 
204     /**
205         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
206 
207         @param _x   minuend
208         @param _y   subtrahend
209 
210         @return difference
211     */
212     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
213         assert(_x >= _y);
214         return _x - _y;
215     }
216 
217     /**
218         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
219 
220         @param _x   factor 1
221         @param _y   factor 2
222 
223         @return product
224     */
225     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
226         uint256 z = _x * _y;
227         assert(_x == 0 || z / _x == _y);
228         return z;
229     }
230 }
231 
232 // File: contracts/utility/interfaces/ITokenHolder.sol
233 
234 /*
235     Token Holder interface
236 */
237 contract ITokenHolder is IOwned {
238     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
239 }
240 
241 // File: contracts/utility/TokenHolder.sol
242 
243 /*
244     We consider every contract to be a 'token holder' since it's currently not possible
245     for a contract to deny receiving tokens.
246 
247     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
248     the owner to send tokens that were sent to the contract by mistake back to their sender.
249 */
250 contract TokenHolder is ITokenHolder, Owned, Utils {
251     /**
252         @dev constructor
253     */
254     constructor() public {
255     }
256 
257     /**
258         @dev withdraws tokens held by the contract and sends them to an account
259         can only be called by the owner
260 
261         @param _token   ERC20 token contract address
262         @param _to      account to receive the new amount
263         @param _amount  amount to withdraw
264     */
265     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
266         public
267         ownerOnly
268         validAddress(_token)
269         validAddress(_to)
270         notThis(_to)
271     {
272         assert(_token.transfer(_to, _amount));
273     }
274 }
275 
276 // File: contracts/utility/SafeMath.sol
277 
278 /**
279  * @title SafeMath
280  * @dev Math operations with safety checks that revert on error
281  */
282 library SafeMath {
283 
284   /**
285   * @dev Multiplies two numbers, reverts on overflow.
286   */
287   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
289     // benefit is lost if 'b' is also tested.
290     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
291     if (a == 0) {
292       return 0;
293     }
294 
295     uint256 c = a * b;
296     require(c / a == b);
297 
298     return c;
299   }
300 
301   /**
302   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
303   */
304   function div(uint256 a, uint256 b) internal pure returns (uint256) {
305     require(b > 0); // Solidity only automatically asserts when dividing by 0
306     uint256 c = a / b;
307     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308 
309     return c;
310   }
311 
312   /**
313   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
314   */
315   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
316     require(b <= a);
317     uint256 c = a - b;
318 
319     return c;
320   }
321 
322   /**
323   * @dev Adds two numbers, reverts on overflow.
324   */
325   function add(uint256 a, uint256 b) internal pure returns (uint256) {
326     uint256 c = a + b;
327     require(c >= a);
328 
329     return c;
330   }
331 
332   /**
333   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
334   * reverts when dividing by zero.
335   */
336   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337     require(b != 0);
338     return a % b;
339   }
340 }
341 
342 // File: contracts/BancorX.sol
343 
344 contract BancorX is Owned, TokenHolder, ContractIds {
345     using SafeMath for uint256;
346 
347     // represents a transaction on another blockchain where BNT was destroyed/locked
348     struct Transaction {
349         uint256 amount;
350         bytes32 fromBlockchain;
351         address to;
352         uint8 numOfReports;
353         bool completed;
354     }
355 
356     uint256 public maxLockLimit;                   // the maximum amount of BNT that can be locked in one transaction
357     uint256 public maxReleaseLimit;                // the maximum amount of BNT that can be released in one transaction
358     uint256 public minLimit;                       // the minimum amount of BNT that can be transferred in one transaction
359     uint256 public prevLockLimit;                  // the lock limit *after* the last transaction
360     uint256 public prevReleaseLimit;               // the release limit *after* the last transaction
361     uint256 public limitIncPerBlock;               // how much the limit increases per block
362     uint256 public prevLockBlockNumber;            // the block number of the last lock transaction
363     uint256 public prevReleaseBlockNumber;         // the block number of the last release transaction
364     uint256 public minRequiredReports;             // minimum number of required reports to release tokens
365     
366     IContractRegistry public registry;             // contract registry
367     IContractRegistry public prevRegistry;         // address of previous registry as security mechanism
368     IBancorConverter public bntConverter;          // BNT converter
369     ISmartToken public bntToken;                   // BNT token
370 
371     bool public xTransfersEnabled = true;          // true if x transfers are enabled, false if not
372     bool public reportingEnabled = true;           // true if reporting is enabled, false if not
373     bool public allowRegistryUpdate = true;        // allows the owner to prevent/allow the registry to be updated
374 
375     // txId -> Transaction
376     mapping (uint256 => Transaction) public transactions;
377 
378     // txId -> reporter -> true if reporter already reported txId
379     mapping (uint256 => mapping (address => bool)) public reportedTxs;
380 
381     // address -> true if address is reporter
382     mapping (address => bool) public reporters;
383 
384     // triggered when BNT is locked in smart contract
385     event TokensLock(
386         address indexed _from,
387         uint256 _amount
388     );
389 
390     // triggered when BNT is released by the smart contract
391     event TokensRelease(
392         address indexed _to,
393         uint256 _amount
394     );
395 
396     // triggered when xTransfer is successfully called
397     event XTransfer(
398         address indexed _from,
399         bytes32 _toBlockchain,
400         bytes32 indexed _to,
401         uint256 _amount
402     );
403 
404     // triggered when report is successfully submitted
405     event TxReport(
406         address indexed _reporter,
407         bytes32 _fromBlockchain,
408         uint256 _txId,
409         address _to,
410         uint256 _amount
411     );
412 
413     /**
414         @dev constructor
415 
416         @param _maxLockLimit          maximum amount of BNT that can be locked in one transaction
417         @param _maxReleaseLimit       maximum amount of BNT that can be released in one transaction
418         @param _minLimit              minimum amount of BNT that can be transferred in one transaction
419         @param _limitIncPerBlock      how much the limit increases per block
420         @param _minRequiredReports    minimum number of reporters to report transaction before tokens can be released
421         @param _registry              address of contract registry
422      */
423     constructor(
424         uint256 _maxLockLimit,
425         uint256 _maxReleaseLimit,
426         uint256 _minLimit,
427         uint256 _limitIncPerBlock,
428         uint256 _minRequiredReports,
429         address _registry
430     )
431         public
432     {
433         // the maximum limits, minimum limit, and limit increase per block
434         maxLockLimit = _maxLockLimit;
435         maxReleaseLimit = _maxReleaseLimit;
436         minLimit = _minLimit;
437         limitIncPerBlock = _limitIncPerBlock;
438         minRequiredReports = _minRequiredReports;
439 
440         // previous limit is _maxLimit, and previous block number is current block number
441         prevLockLimit = _maxLockLimit;
442         prevReleaseLimit = _maxReleaseLimit;
443         prevLockBlockNumber = block.number;
444         prevReleaseBlockNumber = block.number;
445 
446         registry = IContractRegistry(_registry);
447         prevRegistry = IContractRegistry(_registry);
448         bntToken = ISmartToken(registry.addressOf(ContractIds.BNT_TOKEN));
449         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
450     }
451 
452     // validates that the caller is a reporter
453     modifier isReporter {
454         require(reporters[msg.sender]);
455         _;
456     }
457 
458     // allows execution only when x transfers are enabled
459     modifier whenXTransfersEnabled {
460         require(xTransfersEnabled);
461         _;
462     }
463 
464     // allows execution only when reporting is enabled
465     modifier whenReportingEnabled {
466         require(reportingEnabled);
467         _;
468     }
469 
470     /**
471         @dev setter
472 
473         @param _maxLockLimit    new maxLockLimit
474      */
475     function setMaxLockLimit(uint256 _maxLockLimit) public ownerOnly {
476         maxLockLimit = _maxLockLimit;
477     }
478     
479     /**
480         @dev setter
481 
482         @param _maxReleaseLimit    new maxReleaseLimit
483      */
484     function setMaxReleaseLimit(uint256 _maxReleaseLimit) public ownerOnly {
485         maxReleaseLimit = _maxReleaseLimit;
486     }
487     
488     /**
489         @dev setter
490 
491         @param _minLimit    new minLimit
492      */
493     function setMinLimit(uint256 _minLimit) public ownerOnly {
494         minLimit = _minLimit;
495     }
496 
497     /**
498         @dev setter
499 
500         @param _limitIncPerBlock    new limitIncPerBlock
501      */
502     function setLimitIncPerBlock(uint256 _limitIncPerBlock) public ownerOnly {
503         limitIncPerBlock = _limitIncPerBlock;
504     }
505 
506     /**
507         @dev setter
508 
509         @param _minRequiredReports    new minRequiredReports
510      */
511     function setMinRequiredReports(uint256 _minRequiredReports) public ownerOnly {
512         minRequiredReports = _minRequiredReports;
513     }
514 
515     /**
516         @dev allows the owner to set/remove reporters
517 
518         @param _reporter    reporter whos status is to be set
519         @param _active      true if the reporter is approved, false otherwise
520      */
521     function setReporter(address _reporter, bool _active) public ownerOnly {
522         reporters[_reporter] = _active;
523     }
524 
525     /**
526         @dev allows the owner enable/disable the xTransfer method
527 
528         @param _enable     true to enable, false to disable
529      */
530     function enableXTransfers(bool _enable) public ownerOnly {
531         xTransfersEnabled = _enable;
532     }
533 
534     /**
535         @dev allows the owner enable/disable the reportTransaction method
536 
537         @param _enable     true to enable, false to disable
538      */
539     function enableReporting(bool _enable) public ownerOnly {
540         reportingEnabled = _enable;
541     }
542 
543     /**
544         @dev disables the registry update functionality
545         this is a safety mechanism in case of a emergency
546         can only be called by the manager or owner
547 
548         @param _disable    true to disable registry updates, false to re-enable them
549     */
550     function disableRegistryUpdate(bool _disable) public ownerOnly {
551         allowRegistryUpdate = !_disable;
552     }
553 
554     /**
555         @dev allows the owner to set the BNT converters address to wherever the
556         contract registry currently points to
557      */
558     function setBNTConverterAddress() public ownerOnly {
559         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
560     }
561 
562     /**
563         @dev sets the contract registry to whichever address the current registry is pointing to
564      */
565     function updateRegistry() public {
566         // require that upgrading is allowed or that the caller is the owner
567         require(allowRegistryUpdate || msg.sender == owner);
568 
569         // get the address of whichever registry the current registry is pointing to
570         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
571 
572         // if the new registry hasn't changed or is the zero address, revert
573         require(newRegistry != address(registry) && newRegistry != address(0));
574 
575         // set the previous registry as current registry and current registry as newRegistry
576         prevRegistry = registry;
577         registry = IContractRegistry(newRegistry);
578     }
579 
580     /**
581         @dev security mechanism allowing the converter owner to revert to the previous registry,
582         to be used in emergency scenario
583     */
584     function restoreRegistry() public ownerOnly {
585         // set the registry as previous registry
586         registry = prevRegistry;
587 
588         // after a previous registry is restored, only the owner can allow future updates
589         allowRegistryUpdate = false;
590     }
591 
592 
593     /**
594         @dev claims BNT from msg.sender to be converted to BNT on another blockchain
595 
596         @param _toBlockchain    blockchain BNT will be issued on
597         @param _to              address to send the BNT to
598         @param _amount          the amount to transfer
599      */
600     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount) public whenXTransfersEnabled {
601         // get the current lock limit
602         uint256 currentLockLimit = getCurrentLockLimit();
603 
604         // require that; minLimit <= _amount <= currentLockLimit
605         require(_amount >= minLimit && _amount <= currentLockLimit);
606         
607         lockTokens(_amount);
608 
609         // set the previous lock limit and block number
610         prevLockLimit = currentLockLimit.sub(_amount);
611         prevLockBlockNumber = block.number;
612 
613         emit XTransfer(msg.sender, _toBlockchain, _to, _amount);
614     }
615 
616     /**
617         @dev allows reporter to report transaction which occured on another blockchain
618 
619         @param _fromBlockchain  blockchain BNT was destroyed in
620         @param _txId            transactionId of transaction thats being reported
621         @param _to              address to receive BNT
622         @param _amount          amount of BNT destroyed on another blockchain
623      */
624     function reportTx(
625         bytes32 _fromBlockchain,
626         uint256 _txId,
627         address _to,
628         uint256 _amount    
629     )
630         public
631         isReporter
632         whenReportingEnabled
633     {
634         // require that the transaction has not been reported yet by the reporter
635         require(!reportedTxs[_txId][msg.sender]);
636 
637         // set reported as true
638         reportedTxs[_txId][msg.sender] = true;
639 
640         Transaction storage txn = transactions[_txId];
641 
642         // If the caller is the first reporter, set the transaction details
643         if (txn.numOfReports == 0) {
644             txn.to = _to;
645             txn.amount = _amount;
646             txn.fromBlockchain = _fromBlockchain;
647         } else {
648             // otherwise, verify transaction details
649             require(txn.to == _to && txn.amount == _amount && txn.fromBlockchain == _fromBlockchain);
650         }
651         
652         // increment the number of reports
653         txn.numOfReports++;
654 
655         emit TxReport(msg.sender, _fromBlockchain, _txId, _to, _amount);
656 
657         // if theres enough reports, try to release tokens
658         if (txn.numOfReports >= minRequiredReports) {
659             require(!transactions[_txId].completed);
660 
661             // set the transaction as completed
662             transactions[_txId].completed = true;
663 
664             releaseTokens(_to, _amount);
665         }
666     }
667 
668     /**
669         @dev method for calculating current lock limit
670 
671         @return the current maximum limit of BNT that can be locked
672      */
673     function getCurrentLockLimit() public view returns (uint256) {
674         // prevLockLimit + ((currBlockNumber - prevLockBlockNumber) * limitIncPerBlock)
675         uint256 currentLockLimit = prevLockLimit.add(((block.number).sub(prevLockBlockNumber)).mul(limitIncPerBlock));
676         if (currentLockLimit > maxLockLimit)
677             return maxLockLimit;
678         return currentLockLimit;
679     }
680  
681     /**
682         @dev method for calculating current release limit
683 
684         @return the current maximum limit of BNT that can be released
685      */
686     function getCurrentReleaseLimit() public view returns (uint256) {
687         // prevReleaseLimit + ((currBlockNumber - prevReleaseBlockNumber) * limitIncPerBlock)
688         uint256 currentReleaseLimit = prevReleaseLimit.add(((block.number).sub(prevReleaseBlockNumber)).mul(limitIncPerBlock));
689         if (currentReleaseLimit > maxReleaseLimit)
690             return maxReleaseLimit;
691         return currentReleaseLimit;
692     }
693 
694     /**
695         @dev claims and locks BNT from msg.sender to be converted to BNT on another blockchain
696 
697         @param _amount  the amount to lock
698      */
699     function lockTokens(uint256 _amount) private {
700         // lock the BNT from msg.sender in this contract
701         bntConverter.claimTokens(msg.sender, _amount);
702 
703         emit TokensLock(msg.sender, _amount);
704     }
705 
706     /**
707         @dev private method to release BNT the contract holds
708 
709         @param _to      the address to release BNT to
710         @param _amount  the amount to release
711      */
712     function releaseTokens(address _to, uint256 _amount) private {
713         // get the current release limit
714         uint256 currentReleaseLimit = getCurrentReleaseLimit();
715 
716         require(_amount >= minLimit && _amount <= currentReleaseLimit);
717         
718         // update the previous release limit and block number
719         prevReleaseLimit = currentReleaseLimit.sub(_amount);
720         prevReleaseBlockNumber = block.number;
721 
722         // no need to require, reverts on failure
723         bntToken.transfer(_to, _amount);
724 
725         emit TokensRelease(_to, _amount);
726     }
727 }