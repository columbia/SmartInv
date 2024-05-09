1 pragma solidity ^0.4.24;
2 
3 // File: contracts/bancorx/interfaces/IBancorXUpgrader.sol
4 
5 /*
6     Bancor X Upgrader interface
7 */
8 contract IBancorXUpgrader {
9     function upgrade(uint16 _version, address[] _reporters) public;
10 }
11 
12 // File: contracts/ContractIds.sol
13 
14 /**
15     Id definitions for bancor contracts
16 
17     Can be used in conjunction with the contract registry to get contract addresses
18 */
19 contract ContractIds {
20     // generic
21     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
22     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
23 
24     // bancor logic
25     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
26     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
27     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
28     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
29     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
30 
31     // BNT core
32     bytes32 public constant BNT_TOKEN = "BNTToken";
33     bytes32 public constant BNT_CONVERTER = "BNTConverter";
34 
35     // BancorX
36     bytes32 public constant BANCOR_X = "BancorX";
37     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
38 }
39 
40 // File: contracts/token/interfaces/IERC20Token.sol
41 
42 /*
43     ERC20 Standard Token interface
44 */
45 contract IERC20Token {
46     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
47     function name() public view returns (string) {}
48     function symbol() public view returns (string) {}
49     function decimals() public view returns (uint8) {}
50     function totalSupply() public view returns (uint256) {}
51     function balanceOf(address _owner) public view returns (uint256) { _owner; }
52     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
53 
54     function transfer(address _to, uint256 _value) public returns (bool success);
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
56     function approve(address _spender, uint256 _value) public returns (bool success);
57 }
58 
59 // File: contracts/utility/interfaces/IWhitelist.sol
60 
61 /*
62     Whitelist interface
63 */
64 contract IWhitelist {
65     function isWhitelisted(address _address) public view returns (bool);
66 }
67 
68 // File: contracts/converter/interfaces/IBancorConverter.sol
69 
70 /*
71     Bancor Converter interface
72 */
73 contract IBancorConverter {
74     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
75     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
76     function conversionWhitelist() public view returns (IWhitelist) {}
77     function conversionFee() public view returns (uint32) {}
78     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
79     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
80     function claimTokens(address _from, uint256 _amount) public;
81     // deprecated, backward compatibility
82     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
83 }
84 
85 // File: contracts/utility/interfaces/IContractRegistry.sol
86 
87 /*
88     Contract Registry interface
89 */
90 contract IContractRegistry {
91     function addressOf(bytes32 _contractName) public view returns (address);
92 
93     // deprecated, backward compatibility
94     function getAddress(bytes32 _contractName) public view returns (address);
95 }
96 
97 // File: contracts/utility/interfaces/IOwned.sol
98 
99 /*
100     Owned contract interface
101 */
102 contract IOwned {
103     // this function isn't abstract since the compiler emits automatically generated getter functions as external
104     function owner() public view returns (address) {}
105 
106     function transferOwnership(address _newOwner) public;
107     function acceptOwnership() public;
108 }
109 
110 // File: contracts/utility/Owned.sol
111 
112 /*
113     Provides support and utilities for contract ownership
114 */
115 contract Owned is IOwned {
116     address public owner;
117     address public newOwner;
118 
119     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
120 
121     /**
122         @dev constructor
123     */
124     constructor() public {
125         owner = msg.sender;
126     }
127 
128     // allows execution by the owner only
129     modifier ownerOnly {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     /**
135         @dev allows transferring the contract ownership
136         the new owner still needs to accept the transfer
137         can only be called by the contract owner
138 
139         @param _newOwner    new contract owner
140     */
141     function transferOwnership(address _newOwner) public ownerOnly {
142         require(_newOwner != owner);
143         newOwner = _newOwner;
144     }
145 
146     /**
147         @dev used by a new owner to accept an ownership transfer
148     */
149     function acceptOwnership() public {
150         require(msg.sender == newOwner);
151         emit OwnerUpdate(owner, newOwner);
152         owner = newOwner;
153         newOwner = address(0);
154     }
155 }
156 
157 // File: contracts/utility/SafeMath.sol
158 
159 /*
160     Library for basic math operations with overflow/underflow protection
161 */
162 library SafeMath {
163     /**
164         @dev returns the sum of _x and _y, asserts if the calculation overflows
165 
166         @param _x   value 1
167         @param _y   value 2
168 
169         @return sum
170     */
171     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
172         uint256 z = _x + _y;
173         assert(z >= _x);
174         return z;
175     }
176 
177     /**
178         @dev returns the difference of _x minus _y, asserts if the calculation underflows
179 
180         @param _x   minuend
181         @param _y   subtrahend
182 
183         @return difference
184     */
185     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
186         assert(_x >= _y);
187         return _x - _y;
188     }
189 
190     /**
191         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
192 
193         @param _x   factor 1
194         @param _y   factor 2
195 
196         @return product
197     */
198     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
199         // gas optimization
200         if (_x == 0)
201             return 0;
202 
203         uint256 z = _x * _y;
204         assert(z / _x == _y);
205         return z;
206     }
207 }
208 
209 // File: contracts/utility/Utils.sol
210 
211 /*
212     Utilities & Common Modifiers
213 */
214 contract Utils {
215     /**
216         constructor
217     */
218     constructor() public {
219     }
220 
221     // verifies that an amount is greater than zero
222     modifier greaterThanZero(uint256 _amount) {
223         require(_amount > 0);
224         _;
225     }
226 
227     // validates an address - currently only checks that it isn't null
228     modifier validAddress(address _address) {
229         require(_address != address(0));
230         _;
231     }
232 
233     // verifies that the address is different than this contract address
234     modifier notThis(address _address) {
235         require(_address != address(this));
236         _;
237     }
238 
239     // Overflow protected math functions
240 
241     /**
242         @dev returns the sum of _x and _y, asserts if the calculation overflows
243 
244         @param _x   value 1
245         @param _y   value 2
246 
247         @return sum
248     */
249     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
250         uint256 z = _x + _y;
251         assert(z >= _x);
252         return z;
253     }
254 
255     /**
256         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
257 
258         @param _x   minuend
259         @param _y   subtrahend
260 
261         @return difference
262     */
263     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
264         assert(_x >= _y);
265         return _x - _y;
266     }
267 
268     /**
269         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
270 
271         @param _x   factor 1
272         @param _y   factor 2
273 
274         @return product
275     */
276     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
277         uint256 z = _x * _y;
278         assert(_x == 0 || z / _x == _y);
279         return z;
280     }
281 }
282 
283 // File: contracts/utility/interfaces/ITokenHolder.sol
284 
285 /*
286     Token Holder interface
287 */
288 contract ITokenHolder is IOwned {
289     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
290 }
291 
292 // File: contracts/utility/TokenHolder.sol
293 
294 /*
295     We consider every contract to be a 'token holder' since it's currently not possible
296     for a contract to deny receiving tokens.
297 
298     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
299     the owner to send tokens that were sent to the contract by mistake back to their sender.
300 */
301 contract TokenHolder is ITokenHolder, Owned, Utils {
302     /**
303         @dev constructor
304     */
305     constructor() public {
306     }
307 
308     /**
309         @dev withdraws tokens held by the contract and sends them to an account
310         can only be called by the owner
311 
312         @param _token   ERC20 token contract address
313         @param _to      account to receive the new amount
314         @param _amount  amount to withdraw
315     */
316     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
317         public
318         ownerOnly
319         validAddress(_token)
320         validAddress(_to)
321         notThis(_to)
322     {
323         assert(_token.transfer(_to, _amount));
324     }
325 }
326 
327 // File: contracts/token/interfaces/ISmartToken.sol
328 
329 /*
330     Smart Token interface
331 */
332 contract ISmartToken is IOwned, IERC20Token {
333     function disableTransfers(bool _disable) public;
334     function issue(address _to, uint256 _amount) public;
335     function destroy(address _from, uint256 _amount) public;
336 }
337 
338 // File: contracts/bancorx/BancorX.sol
339 
340 /*
341     The BancorX contract allows cross chain token transfers.
342 
343     There are two processes that take place in the contract -
344     - Initiate a cross chain transfer to a target blockchain (locks tokens from the caller account on Ethereum)
345     - Report a cross chain transfer initiated on a source blockchain (releases tokens to an account on Ethereum)
346 
347     Reporting cross chain transfers works similar to standard multisig contracts, meaning that multiple
348     callers are required to report a transfer before tokens are released to the target account.
349 */
350 contract BancorX is Owned, TokenHolder, ContractIds {
351     using SafeMath for uint256;
352 
353     // represents a transaction on another blockchain where BNT was destroyed/locked
354     struct Transaction {
355         uint256 amount;
356         bytes32 fromBlockchain;
357         address to;
358         uint8 numOfReports;
359         bool completed;
360     }
361 
362     uint16 public version = 1;
363 
364     uint256 public maxLockLimit;            // the maximum amount of BNT that can be locked in one transaction
365     uint256 public maxReleaseLimit;         // the maximum amount of BNT that can be released in one transaction
366     uint256 public minLimit;                // the minimum amount of BNT that can be transferred in one transaction
367     uint256 public prevLockLimit;           // the lock limit *after* the last transaction
368     uint256 public prevReleaseLimit;        // the release limit *after* the last transaction
369     uint256 public limitIncPerBlock;        // how much the limit increases per block
370     uint256 public prevLockBlockNumber;     // the block number of the last lock transaction
371     uint256 public prevReleaseBlockNumber;  // the block number of the last release transaction
372     uint256 public minRequiredReports;      // minimum number of required reports to release tokens
373     
374     IContractRegistry public registry;      // contract registry
375     IContractRegistry public prevRegistry;  // address of previous registry as security mechanism
376     IBancorConverter public bntConverter;   // BNT converter
377     ISmartToken public bntToken;            // BNT token
378 
379     bool public xTransfersEnabled = true;   // true if x transfers are enabled, false if not
380     bool public reportingEnabled = true;    // true if reporting is enabled, false if not
381     bool public allowRegistryUpdate = true; // allows the owner to prevent/allow the registry to be updated
382 
383     // txId -> Transaction
384     mapping (uint256 => Transaction) public transactions;
385 
386     // txId -> reporter -> true if reporter already reported txId
387     mapping (uint256 => mapping (address => bool)) public reportedTxs;
388 
389     // address -> true if address is reporter
390     mapping (address => bool) public reporters;
391 
392     // triggered when BNT is locked in smart contract
393     event TokensLock(
394         address indexed _from,
395         uint256 _amount
396     );
397 
398     // triggered when BNT is released by the smart contract
399     event TokensRelease(
400         address indexed _to,
401         uint256 _amount
402     );
403 
404     // triggered when xTransfer is successfully called
405     event XTransfer(
406         address indexed _from,
407         bytes32 _toBlockchain,
408         bytes32 indexed _to,
409         uint256 _amount
410     );
411 
412     // triggered when report is successfully submitted
413     event TxReport(
414         address indexed _reporter,
415         bytes32 _fromBlockchain,
416         uint256 _txId,
417         address _to,
418         uint256 _amount
419     );
420 
421     /**
422         @dev constructor
423 
424         @param _maxLockLimit          maximum amount of BNT that can be locked in one transaction
425         @param _maxReleaseLimit       maximum amount of BNT that can be released in one transaction
426         @param _minLimit              minimum amount of BNT that can be transferred in one transaction
427         @param _limitIncPerBlock      how much the limit increases per block
428         @param _minRequiredReports    minimum number of reporters to report transaction before tokens can be released
429         @param _registry              address of contract registry
430      */
431     constructor(
432         uint256 _maxLockLimit,
433         uint256 _maxReleaseLimit,
434         uint256 _minLimit,
435         uint256 _limitIncPerBlock,
436         uint256 _minRequiredReports,
437         address _registry
438     )
439         public
440     {
441         // the maximum limits, minimum limit, and limit increase per block
442         maxLockLimit = _maxLockLimit;
443         maxReleaseLimit = _maxReleaseLimit;
444         minLimit = _minLimit;
445         limitIncPerBlock = _limitIncPerBlock;
446         minRequiredReports = _minRequiredReports;
447 
448         // previous limit is _maxLimit, and previous block number is current block number
449         prevLockLimit = _maxLockLimit;
450         prevReleaseLimit = _maxReleaseLimit;
451         prevLockBlockNumber = block.number;
452         prevReleaseBlockNumber = block.number;
453 
454         registry = IContractRegistry(_registry);
455         prevRegistry = IContractRegistry(_registry);
456         bntToken = ISmartToken(registry.addressOf(ContractIds.BNT_TOKEN));
457         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
458     }
459 
460     // validates that the caller is a reporter
461     modifier isReporter {
462         require(reporters[msg.sender]);
463         _;
464     }
465 
466     // allows execution only when x transfers are enabled
467     modifier whenXTransfersEnabled {
468         require(xTransfersEnabled);
469         _;
470     }
471 
472     // allows execution only when reporting is enabled
473     modifier whenReportingEnabled {
474         require(reportingEnabled);
475         _;
476     }
477 
478     /**
479         @dev setter
480 
481         @param _maxLockLimit    new maxLockLimit
482      */
483     function setMaxLockLimit(uint256 _maxLockLimit) public ownerOnly {
484         maxLockLimit = _maxLockLimit;
485     }
486     
487     /**
488         @dev setter
489 
490         @param _maxReleaseLimit    new maxReleaseLimit
491      */
492     function setMaxReleaseLimit(uint256 _maxReleaseLimit) public ownerOnly {
493         maxReleaseLimit = _maxReleaseLimit;
494     }
495     
496     /**
497         @dev setter
498 
499         @param _minLimit    new minLimit
500      */
501     function setMinLimit(uint256 _minLimit) public ownerOnly {
502         minLimit = _minLimit;
503     }
504 
505     /**
506         @dev setter
507 
508         @param _limitIncPerBlock    new limitIncPerBlock
509      */
510     function setLimitIncPerBlock(uint256 _limitIncPerBlock) public ownerOnly {
511         limitIncPerBlock = _limitIncPerBlock;
512     }
513 
514     /**
515         @dev setter
516 
517         @param _minRequiredReports    new minRequiredReports
518      */
519     function setMinRequiredReports(uint256 _minRequiredReports) public ownerOnly {
520         minRequiredReports = _minRequiredReports;
521     }
522 
523     /**
524         @dev allows the owner to set/remove reporters
525 
526         @param _reporter    reporter whos status is to be set
527         @param _active      true if the reporter is approved, false otherwise
528      */
529     function setReporter(address _reporter, bool _active) public ownerOnly {
530         reporters[_reporter] = _active;
531     }
532 
533     /**
534         @dev allows the owner enable/disable the xTransfer method
535 
536         @param _enable     true to enable, false to disable
537      */
538     function enableXTransfers(bool _enable) public ownerOnly {
539         xTransfersEnabled = _enable;
540     }
541 
542     /**
543         @dev allows the owner enable/disable the reportTransaction method
544 
545         @param _enable     true to enable, false to disable
546      */
547     function enableReporting(bool _enable) public ownerOnly {
548         reportingEnabled = _enable;
549     }
550 
551     /**
552         @dev disables the registry update functionality
553         this is a safety mechanism in case of a emergency
554         can only be called by the manager or owner
555 
556         @param _disable    true to disable registry updates, false to re-enable them
557     */
558     function disableRegistryUpdate(bool _disable) public ownerOnly {
559         allowRegistryUpdate = !_disable;
560     }
561 
562     /**
563         @dev allows the owner to set the BNT converters address to wherever the
564         contract registry currently points to
565      */
566     function setBNTConverterAddress() public ownerOnly {
567         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
568     }
569 
570     /**
571         @dev sets the contract registry to whichever address the current registry is pointing to
572      */
573     function updateRegistry() public {
574         // require that upgrading is allowed or that the caller is the owner
575         require(allowRegistryUpdate || msg.sender == owner);
576 
577         // get the address of whichever registry the current registry is pointing to
578         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
579 
580         // if the new registry hasn't changed or is the zero address, revert
581         require(newRegistry != address(registry) && newRegistry != address(0));
582 
583         // set the previous registry as current registry and current registry as newRegistry
584         prevRegistry = registry;
585         registry = IContractRegistry(newRegistry);
586     }
587 
588     /**
589         @dev security mechanism allowing the converter owner to revert to the previous registry,
590         to be used in emergency scenario
591     */
592     function restoreRegistry() public ownerOnly {
593         // set the registry as previous registry
594         registry = prevRegistry;
595 
596         // after a previous registry is restored, only the owner can allow future updates
597         allowRegistryUpdate = false;
598     }
599 
600     /**
601         @dev upgrades the contract to the latest version
602         can only be called by the owner
603         note that the owner needs to call acceptOwnership on the new contract after the upgrade
604 
605         @param _reporters    new list of reporters
606     */
607     function upgrade(address[] _reporters) public ownerOnly {
608         IBancorXUpgrader bancorXUpgrader = IBancorXUpgrader(registry.addressOf(ContractIds.BANCOR_X_UPGRADER));
609 
610         transferOwnership(bancorXUpgrader);
611         bancorXUpgrader.upgrade(version, _reporters);
612         acceptOwnership();
613     }
614 
615     /**
616         @dev claims BNT from msg.sender to be converted to BNT on another blockchain
617 
618         @param _toBlockchain    blockchain BNT will be issued on
619         @param _to              address to send the BNT to
620         @param _amount          the amount to transfer
621      */
622     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount) public whenXTransfersEnabled {
623         // get the current lock limit
624         uint256 currentLockLimit = getCurrentLockLimit();
625 
626         // require that; minLimit <= _amount <= currentLockLimit
627         require(_amount >= minLimit && _amount <= currentLockLimit);
628         
629         lockTokens(_amount);
630 
631         // set the previous lock limit and block number
632         prevLockLimit = currentLockLimit.sub(_amount);
633         prevLockBlockNumber = block.number;
634 
635         emit XTransfer(msg.sender, _toBlockchain, _to, _amount);
636     }
637 
638     /**
639         @dev allows reporter to report transaction which occured on another blockchain
640 
641         @param _fromBlockchain  blockchain BNT was destroyed in
642         @param _txId            transactionId of transaction thats being reported
643         @param _to              address to receive BNT
644         @param _amount          amount of BNT destroyed on another blockchain
645      */
646     function reportTx(
647         bytes32 _fromBlockchain,
648         uint256 _txId,
649         address _to,
650         uint256 _amount    
651     )
652         public
653         isReporter
654         whenReportingEnabled
655     {
656         // require that the transaction has not been reported yet by the reporter
657         require(!reportedTxs[_txId][msg.sender]);
658 
659         // set reported as true
660         reportedTxs[_txId][msg.sender] = true;
661 
662         Transaction storage txn = transactions[_txId];
663 
664         // If the caller is the first reporter, set the transaction details
665         if (txn.numOfReports == 0) {
666             txn.to = _to;
667             txn.amount = _amount;
668             txn.fromBlockchain = _fromBlockchain;
669         } else {
670             // otherwise, verify transaction details
671             require(txn.to == _to && txn.amount == _amount && txn.fromBlockchain == _fromBlockchain);
672         }
673         
674         // increment the number of reports
675         txn.numOfReports++;
676 
677         emit TxReport(msg.sender, _fromBlockchain, _txId, _to, _amount);
678 
679         // if theres enough reports, try to release tokens
680         if (txn.numOfReports >= minRequiredReports) {
681             require(!transactions[_txId].completed);
682 
683             // set the transaction as completed
684             transactions[_txId].completed = true;
685 
686             releaseTokens(_to, _amount);
687         }
688     }
689 
690     /**
691         @dev method for calculating current lock limit
692 
693         @return the current maximum limit of BNT that can be locked
694      */
695     function getCurrentLockLimit() public view returns (uint256) {
696         // prevLockLimit + ((currBlockNumber - prevLockBlockNumber) * limitIncPerBlock)
697         uint256 currentLockLimit = prevLockLimit.add(((block.number).sub(prevLockBlockNumber)).mul(limitIncPerBlock));
698         if (currentLockLimit > maxLockLimit)
699             return maxLockLimit;
700         return currentLockLimit;
701     }
702  
703     /**
704         @dev method for calculating current release limit
705 
706         @return the current maximum limit of BNT that can be released
707      */
708     function getCurrentReleaseLimit() public view returns (uint256) {
709         // prevReleaseLimit + ((currBlockNumber - prevReleaseBlockNumber) * limitIncPerBlock)
710         uint256 currentReleaseLimit = prevReleaseLimit.add(((block.number).sub(prevReleaseBlockNumber)).mul(limitIncPerBlock));
711         if (currentReleaseLimit > maxReleaseLimit)
712             return maxReleaseLimit;
713         return currentReleaseLimit;
714     }
715 
716     /**
717         @dev claims and locks BNT from msg.sender to be converted to BNT on another blockchain
718 
719         @param _amount  the amount to lock
720      */
721     function lockTokens(uint256 _amount) private {
722         // lock the BNT from msg.sender in this contract
723         bntConverter.claimTokens(msg.sender, _amount);
724 
725         emit TokensLock(msg.sender, _amount);
726     }
727 
728     /**
729         @dev private method to release BNT the contract holds
730 
731         @param _to      the address to release BNT to
732         @param _amount  the amount to release
733      */
734     function releaseTokens(address _to, uint256 _amount) private {
735         // get the current release limit
736         uint256 currentReleaseLimit = getCurrentReleaseLimit();
737 
738         require(_amount >= minLimit && _amount <= currentReleaseLimit);
739         
740         // update the previous release limit and block number
741         prevReleaseLimit = currentReleaseLimit.sub(_amount);
742         prevReleaseBlockNumber = block.number;
743 
744         // no need to require, reverts on failure
745         bntToken.transfer(_to, _amount);
746 
747         emit TokensRelease(_to, _amount);
748     }
749 }