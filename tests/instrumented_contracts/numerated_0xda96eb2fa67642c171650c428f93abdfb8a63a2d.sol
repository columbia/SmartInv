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
12 // File: contracts/bancorx/interfaces/IBancorX.sol
13 
14 contract IBancorX {
15     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
16     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
17 }
18 
19 // File: contracts/ContractIds.sol
20 
21 /**
22     Id definitions for bancor contracts
23 
24     Can be used in conjunction with the contract registry to get contract addresses
25 */
26 contract ContractIds {
27     // generic
28     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
29     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
30 
31     // bancor logic
32     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
33     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
34     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
35     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
36     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
37 
38     // BNT core
39     bytes32 public constant BNT_TOKEN = "BNTToken";
40     bytes32 public constant BNT_CONVERTER = "BNTConverter";
41 
42     // BancorX
43     bytes32 public constant BANCOR_X = "BancorX";
44     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
45 }
46 
47 // File: contracts/token/interfaces/IERC20Token.sol
48 
49 /*
50     ERC20 Standard Token interface
51 */
52 contract IERC20Token {
53     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
54     function name() public view returns (string) {}
55     function symbol() public view returns (string) {}
56     function decimals() public view returns (uint8) {}
57     function totalSupply() public view returns (uint256) {}
58     function balanceOf(address _owner) public view returns (uint256) { _owner; }
59     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
60 
61     function transfer(address _to, uint256 _value) public returns (bool success);
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 }
65 
66 // File: contracts/utility/interfaces/IWhitelist.sol
67 
68 /*
69     Whitelist interface
70 */
71 contract IWhitelist {
72     function isWhitelisted(address _address) public view returns (bool);
73 }
74 
75 // File: contracts/converter/interfaces/IBancorConverter.sol
76 
77 /*
78     Bancor Converter interface
79 */
80 contract IBancorConverter {
81     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
82     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
83     function conversionWhitelist() public view returns (IWhitelist) {}
84     function conversionFee() public view returns (uint32) {}
85     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
86     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
87     function claimTokens(address _from, uint256 _amount) public;
88     // deprecated, backward compatibility
89     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
90 }
91 
92 // File: contracts/utility/interfaces/IContractRegistry.sol
93 
94 /*
95     Contract Registry interface
96 */
97 contract IContractRegistry {
98     function addressOf(bytes32 _contractName) public view returns (address);
99 
100     // deprecated, backward compatibility
101     function getAddress(bytes32 _contractName) public view returns (address);
102 }
103 
104 // File: contracts/utility/interfaces/IOwned.sol
105 
106 /*
107     Owned contract interface
108 */
109 contract IOwned {
110     // this function isn't abstract since the compiler emits automatically generated getter functions as external
111     function owner() public view returns (address) {}
112 
113     function transferOwnership(address _newOwner) public;
114     function acceptOwnership() public;
115 }
116 
117 // File: contracts/utility/Owned.sol
118 
119 /*
120     Provides support and utilities for contract ownership
121 */
122 contract Owned is IOwned {
123     address public owner;
124     address public newOwner;
125 
126     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
127 
128     /**
129         @dev constructor
130     */
131     constructor() public {
132         owner = msg.sender;
133     }
134 
135     // allows execution by the owner only
136     modifier ownerOnly {
137         require(msg.sender == owner);
138         _;
139     }
140 
141     /**
142         @dev allows transferring the contract ownership
143         the new owner still needs to accept the transfer
144         can only be called by the contract owner
145 
146         @param _newOwner    new contract owner
147     */
148     function transferOwnership(address _newOwner) public ownerOnly {
149         require(_newOwner != owner);
150         newOwner = _newOwner;
151     }
152 
153     /**
154         @dev used by a new owner to accept an ownership transfer
155     */
156     function acceptOwnership() public {
157         require(msg.sender == newOwner);
158         emit OwnerUpdate(owner, newOwner);
159         owner = newOwner;
160         newOwner = address(0);
161     }
162 }
163 
164 // File: contracts/utility/SafeMath.sol
165 
166 /*
167     Library for basic math operations with overflow/underflow protection
168 */
169 library SafeMath {
170     /**
171         @dev returns the sum of _x and _y, reverts if the calculation overflows
172 
173         @param _x   value 1
174         @param _y   value 2
175 
176         @return sum
177     */
178     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
179         uint256 z = _x + _y;
180         require(z >= _x);
181         return z;
182     }
183 
184     /**
185         @dev returns the difference of _x minus _y, reverts if the calculation underflows
186 
187         @param _x   minuend
188         @param _y   subtrahend
189 
190         @return difference
191     */
192     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
193         require(_x >= _y);
194         return _x - _y;
195     }
196 
197     /**
198         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
199 
200         @param _x   factor 1
201         @param _y   factor 2
202 
203         @return product
204     */
205     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
206         // gas optimization
207         if (_x == 0)
208             return 0;
209 
210         uint256 z = _x * _y;
211         require(z / _x == _y);
212         return z;
213     }
214 
215       /**
216         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
217 
218         @param _x   dividend
219         @param _y   divisor
220 
221         @return quotient
222     */
223     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
224         require(_y > 0);
225         uint256 c = _x / _y;
226 
227         return c;
228     }
229 }
230 
231 // File: contracts/utility/Utils.sol
232 
233 /*
234     Utilities & Common Modifiers
235 */
236 contract Utils {
237     /**
238         constructor
239     */
240     constructor() public {
241     }
242 
243     // verifies that an amount is greater than zero
244     modifier greaterThanZero(uint256 _amount) {
245         require(_amount > 0);
246         _;
247     }
248 
249     // validates an address - currently only checks that it isn't null
250     modifier validAddress(address _address) {
251         require(_address != address(0));
252         _;
253     }
254 
255     // verifies that the address is different than this contract address
256     modifier notThis(address _address) {
257         require(_address != address(this));
258         _;
259     }
260 
261 }
262 
263 // File: contracts/utility/interfaces/ITokenHolder.sol
264 
265 /*
266     Token Holder interface
267 */
268 contract ITokenHolder is IOwned {
269     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
270 }
271 
272 // File: contracts/utility/TokenHolder.sol
273 
274 /*
275     We consider every contract to be a 'token holder' since it's currently not possible
276     for a contract to deny receiving tokens.
277 
278     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
279     the owner to send tokens that were sent to the contract by mistake back to their sender.
280 */
281 contract TokenHolder is ITokenHolder, Owned, Utils {
282     /**
283         @dev constructor
284     */
285     constructor() public {
286     }
287 
288     /**
289         @dev withdraws tokens held by the contract and sends them to an account
290         can only be called by the owner
291 
292         @param _token   ERC20 token contract address
293         @param _to      account to receive the new amount
294         @param _amount  amount to withdraw
295     */
296     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
297         public
298         ownerOnly
299         validAddress(_token)
300         validAddress(_to)
301         notThis(_to)
302     {
303         assert(_token.transfer(_to, _amount));
304     }
305 }
306 
307 // File: contracts/token/interfaces/ISmartToken.sol
308 
309 /*
310     Smart Token interface
311 */
312 contract ISmartToken is IOwned, IERC20Token {
313     function disableTransfers(bool _disable) public;
314     function issue(address _to, uint256 _amount) public;
315     function destroy(address _from, uint256 _amount) public;
316 }
317 
318 // File: contracts/bancorx/BancorX.sol
319 
320 /*
321     The BancorX contract allows cross chain token transfers.
322 
323     There are two processes that take place in the contract -
324     - Initiate a cross chain transfer to a target blockchain (locks tokens from the caller account on Ethereum)
325     - Report a cross chain transfer initiated on a source blockchain (releases tokens to an account on Ethereum)
326 
327     Reporting cross chain transfers works similar to standard multisig contracts, meaning that multiple
328     callers are required to report a transfer before tokens are released to the target account.
329 */
330 contract BancorX is IBancorX, Owned, TokenHolder, ContractIds {
331     using SafeMath for uint256;
332 
333     // represents a transaction on another blockchain where BNT was destroyed/locked
334     struct Transaction {
335         uint256 amount;
336         bytes32 fromBlockchain;
337         address to;
338         uint8 numOfReports;
339         bool completed;
340     }
341 
342     uint16 public version = 2;
343 
344     uint256 public maxLockLimit;            // the maximum amount of BNT that can be locked in one transaction
345     uint256 public maxReleaseLimit;         // the maximum amount of BNT that can be released in one transaction
346     uint256 public minLimit;                // the minimum amount of BNT that can be transferred in one transaction
347     uint256 public prevLockLimit;           // the lock limit *after* the last transaction
348     uint256 public prevReleaseLimit;        // the release limit *after* the last transaction
349     uint256 public limitIncPerBlock;        // how much the limit increases per block
350     uint256 public prevLockBlockNumber;     // the block number of the last lock transaction
351     uint256 public prevReleaseBlockNumber;  // the block number of the last release transaction
352     uint256 public minRequiredReports;      // minimum number of required reports to release tokens
353     
354     IContractRegistry public registry;      // contract registry
355     IContractRegistry public prevRegistry;  // address of previous registry as security mechanism
356     IBancorConverter public bntConverter;   // BNT converter
357     ISmartToken public bntToken;            // BNT token
358 
359     bool public xTransfersEnabled = true;   // true if x transfers are enabled, false if not
360     bool public reportingEnabled = true;    // true if reporting is enabled, false if not
361     bool public allowRegistryUpdate = true; // allows the owner to prevent/allow the registry to be updated
362 
363     // txId -> Transaction
364     mapping (uint256 => Transaction) public transactions;
365 
366     // xTransferId -> txId
367     mapping (uint256 => uint256) public transactionIds;
368 
369     // txId -> reporter -> true if reporter already reported txId
370     mapping (uint256 => mapping (address => bool)) public reportedTxs;
371 
372     // address -> true if address is reporter
373     mapping (address => bool) public reporters;
374 
375     // triggered when BNT is locked in smart contract
376     event TokensLock(
377         address indexed _from,
378         uint256 _amount
379     );
380 
381     // triggered when BNT is released by the smart contract
382     event TokensRelease(
383         address indexed _to,
384         uint256 _amount
385     );
386 
387     // triggered when xTransfer is successfully called
388     event XTransfer(
389         address indexed _from,
390         bytes32 _toBlockchain,
391         bytes32 indexed _to,
392         uint256 _amount,
393         uint256 _id
394     );
395 
396     // triggered when report is successfully submitted
397     event TxReport(
398         address indexed _reporter,
399         bytes32 _fromBlockchain,
400         uint256 _txId,
401         address _to,
402         uint256 _amount,
403         uint256 _xTransferId
404     );
405 
406     // triggered when final report is successfully submitted
407     event XTransferComplete(
408         address _to,
409         uint256 _id
410     );
411 
412     /**
413         @dev constructor
414 
415         @param _maxLockLimit          maximum amount of BNT that can be locked in one transaction
416         @param _maxReleaseLimit       maximum amount of BNT that can be released in one transaction
417         @param _minLimit              minimum amount of BNT that can be transferred in one transaction
418         @param _limitIncPerBlock      how much the limit increases per block
419         @param _minRequiredReports    minimum number of reporters to report transaction before tokens can be released
420         @param _registry              address of contract registry
421      */
422     constructor(
423         uint256 _maxLockLimit,
424         uint256 _maxReleaseLimit,
425         uint256 _minLimit,
426         uint256 _limitIncPerBlock,
427         uint256 _minRequiredReports,
428         address _registry
429     )
430         public
431     {
432         // the maximum limits, minimum limit, and limit increase per block
433         maxLockLimit = _maxLockLimit;
434         maxReleaseLimit = _maxReleaseLimit;
435         minLimit = _minLimit;
436         limitIncPerBlock = _limitIncPerBlock;
437         minRequiredReports = _minRequiredReports;
438 
439         // previous limit is _maxLimit, and previous block number is current block number
440         prevLockLimit = _maxLockLimit;
441         prevReleaseLimit = _maxReleaseLimit;
442         prevLockBlockNumber = block.number;
443         prevReleaseBlockNumber = block.number;
444 
445         registry = IContractRegistry(_registry);
446         prevRegistry = IContractRegistry(_registry);
447         bntToken = ISmartToken(registry.addressOf(ContractIds.BNT_TOKEN));
448         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
449     }
450 
451     // validates that the caller is a reporter
452     modifier isReporter {
453         require(reporters[msg.sender]);
454         _;
455     }
456 
457     // allows execution only when x transfers are enabled
458     modifier whenXTransfersEnabled {
459         require(xTransfersEnabled);
460         _;
461     }
462 
463     // allows execution only when reporting is enabled
464     modifier whenReportingEnabled {
465         require(reportingEnabled);
466         _;
467     }
468 
469     /**
470         @dev setter
471 
472         @param _maxLockLimit    new maxLockLimit
473      */
474     function setMaxLockLimit(uint256 _maxLockLimit) public ownerOnly {
475         maxLockLimit = _maxLockLimit;
476     }
477     
478     /**
479         @dev setter
480 
481         @param _maxReleaseLimit    new maxReleaseLimit
482      */
483     function setMaxReleaseLimit(uint256 _maxReleaseLimit) public ownerOnly {
484         maxReleaseLimit = _maxReleaseLimit;
485     }
486     
487     /**
488         @dev setter
489 
490         @param _minLimit    new minLimit
491      */
492     function setMinLimit(uint256 _minLimit) public ownerOnly {
493         minLimit = _minLimit;
494     }
495 
496     /**
497         @dev setter
498 
499         @param _limitIncPerBlock    new limitIncPerBlock
500      */
501     function setLimitIncPerBlock(uint256 _limitIncPerBlock) public ownerOnly {
502         limitIncPerBlock = _limitIncPerBlock;
503     }
504 
505     /**
506         @dev setter
507 
508         @param _minRequiredReports    new minRequiredReports
509      */
510     function setMinRequiredReports(uint256 _minRequiredReports) public ownerOnly {
511         minRequiredReports = _minRequiredReports;
512     }
513 
514     /**
515         @dev allows the owner to set/remove reporters
516 
517         @param _reporter    reporter whos status is to be set
518         @param _active      true if the reporter is approved, false otherwise
519      */
520     function setReporter(address _reporter, bool _active) public ownerOnly {
521         reporters[_reporter] = _active;
522     }
523 
524     /**
525         @dev allows the owner enable/disable the xTransfer method
526 
527         @param _enable     true to enable, false to disable
528      */
529     function enableXTransfers(bool _enable) public ownerOnly {
530         xTransfersEnabled = _enable;
531     }
532 
533     /**
534         @dev allows the owner enable/disable the reportTransaction method
535 
536         @param _enable     true to enable, false to disable
537      */
538     function enableReporting(bool _enable) public ownerOnly {
539         reportingEnabled = _enable;
540     }
541 
542     /**
543         @dev disables the registry update functionality
544         this is a safety mechanism in case of a emergency
545         can only be called by the manager or owner
546 
547         @param _disable    true to disable registry updates, false to re-enable them
548     */
549     function disableRegistryUpdate(bool _disable) public ownerOnly {
550         allowRegistryUpdate = !_disable;
551     }
552 
553     /**
554         @dev allows the owner to set the BNT converters address to wherever the
555         contract registry currently points to
556      */
557     function setBNTConverterAddress() public ownerOnly {
558         bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));
559     }
560 
561     /**
562         @dev sets the contract registry to whichever address the current registry is pointing to
563      */
564     function updateRegistry() public {
565         // require that upgrading is allowed or that the caller is the owner
566         require(allowRegistryUpdate || msg.sender == owner);
567 
568         // get the address of whichever registry the current registry is pointing to
569         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
570 
571         // if the new registry hasn't changed or is the zero address, revert
572         require(newRegistry != address(registry) && newRegistry != address(0));
573 
574         // set the previous registry as current registry and current registry as newRegistry
575         prevRegistry = registry;
576         registry = IContractRegistry(newRegistry);
577     }
578 
579     /**
580         @dev security mechanism allowing the converter owner to revert to the previous registry,
581         to be used in emergency scenario
582     */
583     function restoreRegistry() public ownerOnly {
584         // set the registry as previous registry
585         registry = prevRegistry;
586 
587         // after a previous registry is restored, only the owner can allow future updates
588         allowRegistryUpdate = false;
589     }
590 
591     /**
592         @dev upgrades the contract to the latest version
593         can only be called by the owner
594         note that the owner needs to call acceptOwnership on the new contract after the upgrade
595 
596         @param _reporters    new list of reporters
597     */
598     function upgrade(address[] _reporters) public ownerOnly {
599         IBancorXUpgrader bancorXUpgrader = IBancorXUpgrader(registry.addressOf(ContractIds.BANCOR_X_UPGRADER));
600 
601         transferOwnership(bancorXUpgrader);
602         bancorXUpgrader.upgrade(version, _reporters);
603         acceptOwnership();
604     }
605 
606     /**
607         @dev claims BNT from msg.sender to be converted to BNT on another blockchain
608 
609         @param _toBlockchain    blockchain BNT will be issued on
610         @param _to              address to send the BNT to
611         @param _amount          the amount to transfer
612      */
613     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount) public whenXTransfersEnabled {
614         // get the current lock limit
615         uint256 currentLockLimit = getCurrentLockLimit();
616 
617         // require that; minLimit <= _amount <= currentLockLimit
618         require(_amount >= minLimit && _amount <= currentLockLimit);
619         
620         lockTokens(_amount);
621 
622         // set the previous lock limit and block number
623         prevLockLimit = currentLockLimit.sub(_amount);
624         prevLockBlockNumber = block.number;
625 
626         // emit XTransfer event with id of 0
627         emit XTransfer(msg.sender, _toBlockchain, _to, _amount, 0);
628     }
629 
630     /**
631         @dev claims BNT from msg.sender to be converted to BNT on another blockchain
632 
633         @param _toBlockchain    blockchain BNT will be issued on
634         @param _to              address to send the BNT to
635         @param _amount          the amount to transfer
636         @param _id              pre-determined unique (if non zero) id which refers to this transaction 
637      */
638     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public whenXTransfersEnabled {
639         // get the current lock limit
640         uint256 currentLockLimit = getCurrentLockLimit();
641 
642         // require that; minLimit <= _amount <= currentLockLimit
643         require(_amount >= minLimit && _amount <= currentLockLimit);
644         
645         lockTokens(_amount);
646 
647         // set the previous lock limit and block number
648         prevLockLimit = currentLockLimit.sub(_amount);
649         prevLockBlockNumber = block.number;
650 
651         // emit XTransfer event
652         emit XTransfer(msg.sender, _toBlockchain, _to, _amount, _id);
653     }
654 
655     /**
656         @dev allows reporter to report transaction which occured on another blockchain
657 
658         @param _fromBlockchain  blockchain BNT was destroyed in
659         @param _txId            transactionId of transaction thats being reported
660         @param _to              address to receive BNT
661         @param _amount          amount of BNT destroyed on another blockchain
662         @param _xTransferId     unique (if non zero) pre-determined id (unlike _txId which is determined after the transactions been mined)
663      */
664     function reportTx(
665         bytes32 _fromBlockchain,
666         uint256 _txId,
667         address _to,
668         uint256 _amount,
669         uint256 _xTransferId 
670     )
671         public
672         isReporter
673         whenReportingEnabled
674     {
675         // require that the transaction has not been reported yet by the reporter
676         require(!reportedTxs[_txId][msg.sender]);
677 
678         // set reported as true
679         reportedTxs[_txId][msg.sender] = true;
680 
681         Transaction storage txn = transactions[_txId];
682 
683         // If the caller is the first reporter, set the transaction details
684         if (txn.numOfReports == 0) {
685             txn.to = _to;
686             txn.amount = _amount;
687             txn.fromBlockchain = _fromBlockchain;
688 
689             if (_xTransferId != 0) {
690                 // verify uniqueness of xTransfer id to prevent overwriting
691                 require(transactionIds[_xTransferId] == 0);
692                 transactionIds[_xTransferId] = _txId;
693             }
694         } else {
695             // otherwise, verify transaction details
696             require(txn.to == _to && txn.amount == _amount && txn.fromBlockchain == _fromBlockchain);
697             
698             if (_xTransferId != 0) {
699                 require(transactionIds[_xTransferId] == _txId);
700             }
701         }
702         
703         // increment the number of reports
704         txn.numOfReports++;
705 
706         emit TxReport(msg.sender, _fromBlockchain, _txId, _to, _amount, _xTransferId);
707 
708         // if theres enough reports, try to release tokens
709         if (txn.numOfReports >= minRequiredReports) {
710             require(!transactions[_txId].completed);
711 
712             // set the transaction as completed
713             transactions[_txId].completed = true;
714 
715             emit XTransferComplete(_to, _xTransferId);
716 
717             releaseTokens(_to, _amount);
718         }
719     }
720 
721     /**
722         @dev gets x transfer amount by xTransferId (not txId)
723 
724         @param _xTransferId    unique (if non zero) pre-determined id (unlike _txId which is determined after the transactions been broadcasted)
725         @param _for            address corresponding to xTransferId
726 
727         @return amount that was sent in xTransfer corresponding to _xTransferId
728     */
729     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256) {
730         // xTransferId -> txId -> Transaction
731         Transaction storage transaction = transactions[transactionIds[_xTransferId]];
732 
733         // verify that the xTransferId is for _for
734         require(transaction.to == _for);
735 
736         return transaction.amount;
737     }
738 
739     /**
740         @dev method for calculating current lock limit
741 
742         @return the current maximum limit of BNT that can be locked
743      */
744     function getCurrentLockLimit() public view returns (uint256) {
745         // prevLockLimit + ((currBlockNumber - prevLockBlockNumber) * limitIncPerBlock)
746         uint256 currentLockLimit = prevLockLimit.add(((block.number).sub(prevLockBlockNumber)).mul(limitIncPerBlock));
747         if (currentLockLimit > maxLockLimit)
748             return maxLockLimit;
749         return currentLockLimit;
750     }
751  
752     /**
753         @dev method for calculating current release limit
754 
755         @return the current maximum limit of BNT that can be released
756      */
757     function getCurrentReleaseLimit() public view returns (uint256) {
758         // prevReleaseLimit + ((currBlockNumber - prevReleaseBlockNumber) * limitIncPerBlock)
759         uint256 currentReleaseLimit = prevReleaseLimit.add(((block.number).sub(prevReleaseBlockNumber)).mul(limitIncPerBlock));
760         if (currentReleaseLimit > maxReleaseLimit)
761             return maxReleaseLimit;
762         return currentReleaseLimit;
763     }
764 
765     /**
766         @dev claims and locks BNT from msg.sender to be converted to BNT on another blockchain
767 
768         @param _amount  the amount to lock
769      */
770     function lockTokens(uint256 _amount) private {
771         // lock the BNT from msg.sender in this contract
772         bntConverter.claimTokens(msg.sender, _amount);
773 
774         emit TokensLock(msg.sender, _amount);
775     }
776 
777     /**
778         @dev private method to release BNT the contract holds
779 
780         @param _to      the address to release BNT to
781         @param _amount  the amount to release
782      */
783     function releaseTokens(address _to, uint256 _amount) private {
784         // get the current release limit
785         uint256 currentReleaseLimit = getCurrentReleaseLimit();
786 
787         require(_amount >= minLimit && _amount <= currentReleaseLimit);
788         
789         // update the previous release limit and block number
790         prevReleaseLimit = currentReleaseLimit.sub(_amount);
791         prevReleaseBlockNumber = block.number;
792 
793         // no need to require, reverts on failure
794         bntToken.transfer(_to, _amount);
795 
796         emit TokensRelease(_to, _amount);
797     }
798 }