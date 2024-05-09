1 // File: contracts/bancorx/interfaces/IBancorXUpgrader.sol
2 
3 pragma solidity 0.4.26;
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
14 pragma solidity 0.4.26;
15 
16 contract IBancorX {
17     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
18     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
19 }
20 
21 // File: contracts/token/interfaces/IERC20Token.sol
22 
23 pragma solidity 0.4.26;
24 
25 /*
26     ERC20 Standard Token interface
27 */
28 contract IERC20Token {
29     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
30     function name() public view returns (string) {this;}
31     function symbol() public view returns (string) {this;}
32     function decimals() public view returns (uint8) {this;}
33     function totalSupply() public view returns (uint256) {this;}
34     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
35     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
36 
37     function transfer(address _to, uint256 _value) public returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 }
41 
42 // File: contracts/utility/interfaces/IOwned.sol
43 
44 pragma solidity 0.4.26;
45 
46 /*
47     Owned contract interface
48 */
49 contract IOwned {
50     // this function isn't abstract since the compiler emits automatically generated getter functions as external
51     function owner() public view returns (address) {this;}
52 
53     function transferOwnership(address _newOwner) public;
54     function acceptOwnership() public;
55 }
56 
57 // File: contracts/token/interfaces/ISmartToken.sol
58 
59 pragma solidity 0.4.26;
60 
61 
62 
63 /*
64     Smart Token interface
65 */
66 contract ISmartToken is IOwned, IERC20Token {
67     function disableTransfers(bool _disable) public;
68     function issue(address _to, uint256 _amount) public;
69     function destroy(address _from, uint256 _amount) public;
70 }
71 
72 // File: contracts/token/interfaces/ISmartTokenController.sol
73 
74 pragma solidity 0.4.26;
75 
76 
77 /*
78     Smart Token Controller interface
79 */
80 contract ISmartTokenController {
81     function claimTokens(address _from, uint256 _amount) public;
82     function token() public view returns (ISmartToken) {this;}
83 }
84 
85 // File: contracts/utility/Owned.sol
86 
87 pragma solidity 0.4.26;
88 
89 
90 /**
91   * @dev Provides support and utilities for contract ownership
92 */
93 contract Owned is IOwned {
94     address public owner;
95     address public newOwner;
96 
97     /**
98       * @dev triggered when the owner is updated
99       * 
100       * @param _prevOwner previous owner
101       * @param _newOwner  new owner
102     */
103     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
104 
105     /**
106       * @dev initializes a new Owned instance
107     */
108     constructor() public {
109         owner = msg.sender;
110     }
111 
112     // allows execution by the owner only
113     modifier ownerOnly {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     /**
119       * @dev allows transferring the contract ownership
120       * the new owner still needs to accept the transfer
121       * can only be called by the contract owner
122       * 
123       * @param _newOwner    new contract owner
124     */
125     function transferOwnership(address _newOwner) public ownerOnly {
126         require(_newOwner != owner);
127         newOwner = _newOwner;
128     }
129 
130     /**
131       * @dev used by a new owner to accept an ownership transfer
132     */
133     function acceptOwnership() public {
134         require(msg.sender == newOwner);
135         emit OwnerUpdate(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 // File: contracts/utility/Utils.sol
142 
143 pragma solidity 0.4.26;
144 
145 /**
146   * @dev Utilities & Common Modifiers
147 */
148 contract Utils {
149     /**
150       * constructor
151     */
152     constructor() public {
153     }
154 
155     // verifies that an amount is greater than zero
156     modifier greaterThanZero(uint256 _amount) {
157         require(_amount > 0);
158         _;
159     }
160 
161     // validates an address - currently only checks that it isn't null
162     modifier validAddress(address _address) {
163         require(_address != address(0));
164         _;
165     }
166 
167     // verifies that the address is different than this contract address
168     modifier notThis(address _address) {
169         require(_address != address(this));
170         _;
171     }
172 
173 }
174 
175 // File: contracts/utility/interfaces/IContractRegistry.sol
176 
177 pragma solidity 0.4.26;
178 
179 /*
180     Contract Registry interface
181 */
182 contract IContractRegistry {
183     function addressOf(bytes32 _contractName) public view returns (address);
184 
185     // deprecated, backward compatibility
186     function getAddress(bytes32 _contractName) public view returns (address);
187 }
188 
189 // File: contracts/utility/ContractRegistryClient.sol
190 
191 pragma solidity 0.4.26;
192 
193 
194 
195 
196 /**
197   * @dev Base contract for ContractRegistry clients
198 */
199 contract ContractRegistryClient is Owned, Utils {
200     bytes32 internal constant CONTRACT_FEATURES = "ContractFeatures";
201     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
202     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
203     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
204     bytes32 internal constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
205     bytes32 internal constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
206     bytes32 internal constant BANCOR_CONVERTER_REGISTRY = "BancorConverterRegistry";
207     bytes32 internal constant BANCOR_CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
208     bytes32 internal constant BNT_TOKEN = "BNTToken";
209     bytes32 internal constant BANCOR_X = "BancorX";
210     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
211 
212     IContractRegistry public registry;      // address of the current contract-registry
213     IContractRegistry public prevRegistry;  // address of the previous contract-registry
214     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
215 
216     /**
217       * @dev verifies that the caller is mapped to the given contract name
218       * 
219       * @param _contractName    contract name
220     */
221     modifier only(bytes32 _contractName) {
222         require(msg.sender == addressOf(_contractName));
223         _;
224     }
225 
226     /**
227       * @dev initializes a new ContractRegistryClient instance
228       * 
229       * @param  _registry   address of a contract-registry contract
230     */
231     constructor(IContractRegistry _registry) internal validAddress(_registry) {
232         registry = IContractRegistry(_registry);
233         prevRegistry = IContractRegistry(_registry);
234     }
235 
236     /**
237       * @dev updates to the new contract-registry
238      */
239     function updateRegistry() public {
240         // verify that this function is permitted
241         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry);
242 
243         // get the new contract-registry
244         address newRegistry = addressOf(CONTRACT_REGISTRY);
245 
246         // verify that the new contract-registry is different and not zero
247         require(newRegistry != address(registry) && newRegistry != address(0));
248 
249         // verify that the new contract-registry is pointing to a non-zero contract-registry
250         require(IContractRegistry(newRegistry).addressOf(CONTRACT_REGISTRY) != address(0));
251 
252         // save a backup of the current contract-registry before replacing it
253         prevRegistry = registry;
254 
255         // replace the current contract-registry with the new contract-registry
256         registry = IContractRegistry(newRegistry);
257     }
258 
259     /**
260       * @dev restores the previous contract-registry
261     */
262     function restoreRegistry() public ownerOnly {
263         // restore the previous contract-registry
264         registry = prevRegistry;
265     }
266 
267     /**
268       * @dev restricts the permission to update the contract-registry
269       * 
270       * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
271     */
272     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) ownerOnly public {
273         // change the permission to update the contract-registry
274         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
275     }
276 
277     /**
278       * @dev returns the address associated with the given contract name
279       * 
280       * @param _contractName    contract name
281       * 
282       * @return contract address
283     */
284     function addressOf(bytes32 _contractName) internal view returns (address) {
285         return registry.addressOf(_contractName);
286     }
287 }
288 
289 // File: contracts/utility/SafeMath.sol
290 
291 pragma solidity 0.4.26;
292 
293 /**
294   * @dev Library for basic math operations with overflow/underflow protection
295 */
296 library SafeMath {
297     /**
298       * @dev returns the sum of _x and _y, reverts if the calculation overflows
299       * 
300       * @param _x   value 1
301       * @param _y   value 2
302       * 
303       * @return sum
304     */
305     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
306         uint256 z = _x + _y;
307         require(z >= _x);
308         return z;
309     }
310 
311     /**
312       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
313       * 
314       * @param _x   minuend
315       * @param _y   subtrahend
316       * 
317       * @return difference
318     */
319     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
320         require(_x >= _y);
321         return _x - _y;
322     }
323 
324     /**
325       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
326       * 
327       * @param _x   factor 1
328       * @param _y   factor 2
329       * 
330       * @return product
331     */
332     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
333         // gas optimization
334         if (_x == 0)
335             return 0;
336 
337         uint256 z = _x * _y;
338         require(z / _x == _y);
339         return z;
340     }
341 
342       /**
343         * ev Integer division of two numbers truncating the quotient, reverts on division by zero.
344         * 
345         * aram _x   dividend
346         * aram _y   divisor
347         * 
348         * eturn quotient
349     */
350     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
351         require(_y > 0);
352         uint256 c = _x / _y;
353 
354         return c;
355     }
356 }
357 
358 // File: contracts/utility/interfaces/ITokenHolder.sol
359 
360 pragma solidity 0.4.26;
361 
362 
363 
364 /*
365     Token Holder interface
366 */
367 contract ITokenHolder is IOwned {
368     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
369 }
370 
371 // File: contracts/token/interfaces/INonStandardERC20.sol
372 
373 pragma solidity 0.4.26;
374 
375 /*
376     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
377 */
378 contract INonStandardERC20 {
379     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
380     function name() public view returns (string) {this;}
381     function symbol() public view returns (string) {this;}
382     function decimals() public view returns (uint8) {this;}
383     function totalSupply() public view returns (uint256) {this;}
384     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
385     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
386 
387     function transfer(address _to, uint256 _value) public;
388     function transferFrom(address _from, address _to, uint256 _value) public;
389     function approve(address _spender, uint256 _value) public;
390 }
391 
392 // File: contracts/utility/TokenHolder.sol
393 
394 pragma solidity 0.4.26;
395 
396 
397 
398 
399 
400 
401 /**
402   * @dev We consider every contract to be a 'token holder' since it's currently not possible
403   * for a contract to deny receiving tokens.
404   * 
405   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
406   * the owner to send tokens that were sent to the contract by mistake back to their sender.
407   * 
408   * Note that we use the non standard ERC-20 interface which has no return value for transfer
409   * in order to support both non standard as well as standard token contracts.
410   * see https://github.com/ethereum/solidity/issues/4116
411 */
412 contract TokenHolder is ITokenHolder, Owned, Utils {
413     /**
414       * @dev initializes a new TokenHolder instance
415     */
416     constructor() public {
417     }
418 
419     /**
420       * @dev withdraws tokens held by the contract and sends them to an account
421       * can only be called by the owner
422       * 
423       * @param _token   ERC20 token contract address
424       * @param _to      account to receive the new amount
425       * @param _amount  amount to withdraw
426     */
427     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
428         public
429         ownerOnly
430         validAddress(_token)
431         validAddress(_to)
432         notThis(_to)
433     {
434         INonStandardERC20(_token).transfer(_to, _amount);
435     }
436 }
437 
438 // File: contracts/bancorx/BancorX.sol
439 
440 pragma solidity 0.4.26;
441 
442 
443 
444 
445 
446 
447 
448 
449 /**
450   * @dev The BancorX contract allows cross chain token transfers.
451   * 
452   * There are two processes that take place in the contract -
453   * - Initiate a cross chain transfer to a target blockchain (locks tokens from the caller account on Ethereum)
454   * - Report a cross chain transfer initiated on a source blockchain (releases tokens to an account on Ethereum)
455   * 
456   * Reporting cross chain transfers works similar to standard multisig contracts, meaning that multiple
457   * callers are required to report a transfer before tokens are released to the target account.
458 */
459 contract BancorX is IBancorX, TokenHolder, ContractRegistryClient {
460     using SafeMath for uint256;
461 
462     // represents a transaction on another blockchain where tokens were destroyed/locked
463     struct Transaction {
464         uint256 amount;
465         bytes32 fromBlockchain;
466         address to;
467         uint8 numOfReports;
468         bool completed;
469     }
470 
471     uint16 public version = 3;
472 
473     uint256 public maxLockLimit;            // the maximum amount of tokens that can be locked in one transaction
474     uint256 public maxReleaseLimit;         // the maximum amount of tokens that can be released in one transaction
475     uint256 public minLimit;                // the minimum amount of tokens that can be transferred in one transaction
476     uint256 public prevLockLimit;           // the lock limit *after* the last transaction
477     uint256 public prevReleaseLimit;        // the release limit *after* the last transaction
478     uint256 public limitIncPerBlock;        // how much the limit increases per block
479     uint256 public prevLockBlockNumber;     // the block number of the last lock transaction
480     uint256 public prevReleaseBlockNumber;  // the block number of the last release transaction
481     uint256 public minRequiredReports;      // minimum number of required reports to release tokens
482     
483     IERC20Token public token;               // erc20 token or smart token
484     bool public isSmartToken;               // false - erc20 token; true - smart token
485 
486     bool public xTransfersEnabled = true;   // true if x transfers are enabled, false if not
487     bool public reportingEnabled = true;    // true if reporting is enabled, false if not
488 
489     // txId -> Transaction
490     mapping (uint256 => Transaction) public transactions;
491 
492     // xTransferId -> txId
493     mapping (uint256 => uint256) public transactionIds;
494 
495     // txId -> reporter -> true if reporter already reported txId
496     mapping (uint256 => mapping (address => bool)) public reportedTxs;
497 
498     // address -> true if address is reporter
499     mapping (address => bool) public reporters;
500 
501     /**
502       * @dev triggered when tokens are locked in smart contract
503       * 
504       * @param _from    wallet address that the tokens are locked from
505       * @param _amount  amount locked
506     */
507     event TokensLock(
508         address indexed _from,
509         uint256 _amount
510     );
511 
512     /**
513       * @dev triggered when tokens are released by the smart contract
514       * 
515       * @param _to      wallet address that the tokens are released to
516       * @param _amount  amount released
517     */
518     event TokensRelease(
519         address indexed _to,
520         uint256 _amount
521     );
522 
523     /**
524       * @dev triggered when xTransfer is successfully called
525       * 
526       * @param _from            wallet address that initiated the xtransfer
527       * @param _toBlockchain    target blockchain
528       * @param _to              target wallet
529       * @param _amount          transfer amount
530       * @param _id              xtransfer id
531     */
532     event XTransfer(
533         address indexed _from,
534         bytes32 _toBlockchain,
535         bytes32 indexed _to,
536         uint256 _amount,
537         uint256 _id
538     );
539 
540     /**
541       * @dev triggered when report is successfully submitted
542       * 
543       * @param _reporter        reporter wallet
544       * @param _fromBlockchain  source blockchain
545       * @param _txId            tx id on the source blockchain
546       * @param _to              target wallet
547       * @param _amount          transfer amount
548       * @param _xTransferId     xtransfer id
549     */
550     event TxReport(
551         address indexed _reporter,
552         bytes32 _fromBlockchain,
553         uint256 _txId,
554         address _to,
555         uint256 _amount,
556         uint256 _xTransferId
557     );
558 
559     /**
560       * @dev triggered when final report is successfully submitted
561       * 
562       * @param _to  target wallet
563       * @param _id  xtransfer id
564     */
565     event XTransferComplete(
566         address _to,
567         uint256 _id
568     );
569 
570     /**
571       * @dev initializes a new BancorX instance
572       * 
573       * @param _maxLockLimit          maximum amount of tokens that can be locked in one transaction
574       * @param _maxReleaseLimit       maximum amount of tokens that can be released in one transaction
575       * @param _minLimit              minimum amount of tokens that can be transferred in one transaction
576       * @param _limitIncPerBlock      how much the limit increases per block
577       * @param _minRequiredReports    minimum number of reporters to report transaction before tokens can be released
578       * @param _registry              address of contract registry
579       * @param _token                 erc20 token or smart token
580       * @param _isSmartToken          false - erc20 token; true - smart token
581      */
582     constructor(
583         uint256 _maxLockLimit,
584         uint256 _maxReleaseLimit,
585         uint256 _minLimit,
586         uint256 _limitIncPerBlock,
587         uint256 _minRequiredReports,
588         IContractRegistry _registry,
589         IERC20Token _token,
590         bool _isSmartToken
591     )   ContractRegistryClient(_registry)
592         public
593     {
594         // the maximum limits, minimum limit, and limit increase per block
595         maxLockLimit = _maxLockLimit;
596         maxReleaseLimit = _maxReleaseLimit;
597         minLimit = _minLimit;
598         limitIncPerBlock = _limitIncPerBlock;
599         minRequiredReports = _minRequiredReports;
600 
601         // previous limit is _maxLimit, and previous block number is current block number
602         prevLockLimit = _maxLockLimit;
603         prevReleaseLimit = _maxReleaseLimit;
604         prevLockBlockNumber = block.number;
605         prevReleaseBlockNumber = block.number;
606 
607         token = _token;
608         isSmartToken = _isSmartToken;
609     }
610 
611     // validates that the caller is a reporter
612     modifier isReporter {
613         require(reporters[msg.sender]);
614         _;
615     }
616 
617     // allows execution only when x transfers are enabled
618     modifier whenXTransfersEnabled {
619         require(xTransfersEnabled);
620         _;
621     }
622 
623     // allows execution only when reporting is enabled
624     modifier whenReportingEnabled {
625         require(reportingEnabled);
626         _;
627     }
628 
629     /**
630       * @dev setter
631       * 
632       * @param _maxLockLimit    new maxLockLimit
633      */
634     function setMaxLockLimit(uint256 _maxLockLimit) public ownerOnly {
635         maxLockLimit = _maxLockLimit;
636     }
637     
638     /**
639       * @dev setter
640       * 
641       * @param _maxReleaseLimit    new maxReleaseLimit
642      */
643     function setMaxReleaseLimit(uint256 _maxReleaseLimit) public ownerOnly {
644         maxReleaseLimit = _maxReleaseLimit;
645     }
646     
647     /**
648       * @dev setter
649       * 
650       * @param _minLimit    new minLimit
651      */
652     function setMinLimit(uint256 _minLimit) public ownerOnly {
653         minLimit = _minLimit;
654     }
655 
656     /**
657       * @dev setter
658       * 
659       * @param _limitIncPerBlock    new limitIncPerBlock
660      */
661     function setLimitIncPerBlock(uint256 _limitIncPerBlock) public ownerOnly {
662         limitIncPerBlock = _limitIncPerBlock;
663     }
664 
665     /**
666       * @dev setter
667       * 
668       * @param _minRequiredReports    new minRequiredReports
669      */
670     function setMinRequiredReports(uint256 _minRequiredReports) public ownerOnly {
671         minRequiredReports = _minRequiredReports;
672     }
673 
674     /**
675       * @dev allows the owner to set/remove reporters
676       * 
677       * @param _reporter    reporter whos status is to be set
678       * @param _active      true if the reporter is approved, false otherwise
679      */
680     function setReporter(address _reporter, bool _active) public ownerOnly {
681         reporters[_reporter] = _active;
682     }
683 
684     /**
685       * @dev allows the owner enable/disable the xTransfer method
686       * 
687       * @param _enable     true to enable, false to disable
688      */
689     function enableXTransfers(bool _enable) public ownerOnly {
690         xTransfersEnabled = _enable;
691     }
692 
693     /**
694       * @dev allows the owner enable/disable the reportTransaction method
695       * 
696       * @param _enable     true to enable, false to disable
697      */
698     function enableReporting(bool _enable) public ownerOnly {
699         reportingEnabled = _enable;
700     }
701 
702     /**
703       * @dev upgrades the contract to the latest version
704       * can only be called by the owner
705       * note that the owner needs to call acceptOwnership on the new contract after the upgrade
706       * 
707       * @param _reporters    new list of reporters
708     */
709     function upgrade(address[] _reporters) public ownerOnly {
710         IBancorXUpgrader bancorXUpgrader = IBancorXUpgrader(addressOf(BANCOR_X_UPGRADER));
711 
712         transferOwnership(bancorXUpgrader);
713         bancorXUpgrader.upgrade(version, _reporters);
714         acceptOwnership();
715     }
716 
717     /**
718       * @dev claims tokens from msg.sender to be converted to tokens on another blockchain
719       * 
720       * @param _toBlockchain    blockchain on which tokens will be issued
721       * @param _to              address to send the tokens to
722       * @param _amount          the amount of tokens to transfer
723      */
724     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount) public whenXTransfersEnabled {
725         // get the current lock limit
726         uint256 currentLockLimit = getCurrentLockLimit();
727 
728         // require that; minLimit <= _amount <= currentLockLimit
729         require(_amount >= minLimit && _amount <= currentLockLimit);
730         
731         lockTokens(_amount);
732 
733         // set the previous lock limit and block number
734         prevLockLimit = currentLockLimit.sub(_amount);
735         prevLockBlockNumber = block.number;
736 
737         // emit XTransfer event with id of 0
738         emit XTransfer(msg.sender, _toBlockchain, _to, _amount, 0);
739     }
740 
741     /**
742       * @dev claims tokens from msg.sender to be converted to tokens on another blockchain
743       * 
744       * @param _toBlockchain    blockchain on which tokens will be issued
745       * @param _to              address to send the tokens to
746       * @param _amount          the amount of tokens to transfer
747       * @param _id              pre-determined unique (if non zero) id which refers to this transaction 
748      */
749     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public whenXTransfersEnabled {
750         // get the current lock limit
751         uint256 currentLockLimit = getCurrentLockLimit();
752 
753         // require that; minLimit <= _amount <= currentLockLimit
754         require(_amount >= minLimit && _amount <= currentLockLimit);
755         
756         lockTokens(_amount);
757 
758         // set the previous lock limit and block number
759         prevLockLimit = currentLockLimit.sub(_amount);
760         prevLockBlockNumber = block.number;
761 
762         // emit XTransfer event
763         emit XTransfer(msg.sender, _toBlockchain, _to, _amount, _id);
764     }
765 
766     /**
767       * @dev allows reporter to report transaction which occured on another blockchain
768       * 
769       * @param _fromBlockchain  blockchain in which tokens were destroyed
770       * @param _txId            transactionId of transaction thats being reported
771       * @param _to              address to receive tokens
772       * @param _amount          amount of tokens destroyed on another blockchain
773       * @param _xTransferId     unique (if non zero) pre-determined id (unlike _txId which is determined after the transactions been mined)
774      */
775     function reportTx(
776         bytes32 _fromBlockchain,
777         uint256 _txId,
778         address _to,
779         uint256 _amount,
780         uint256 _xTransferId 
781     )
782         public
783         isReporter
784         whenReportingEnabled
785     {
786         // require that the transaction has not been reported yet by the reporter
787         require(!reportedTxs[_txId][msg.sender]);
788 
789         // set reported as true
790         reportedTxs[_txId][msg.sender] = true;
791 
792         Transaction storage txn = transactions[_txId];
793 
794         // If the caller is the first reporter, set the transaction details
795         if (txn.numOfReports == 0) {
796             txn.to = _to;
797             txn.amount = _amount;
798             txn.fromBlockchain = _fromBlockchain;
799 
800             if (_xTransferId != 0) {
801                 // verify uniqueness of xTransfer id to prevent overwriting
802                 require(transactionIds[_xTransferId] == 0);
803                 transactionIds[_xTransferId] = _txId;
804             }
805         } else {
806             // otherwise, verify transaction details
807             require(txn.to == _to && txn.amount == _amount && txn.fromBlockchain == _fromBlockchain);
808             
809             if (_xTransferId != 0) {
810                 require(transactionIds[_xTransferId] == _txId);
811             }
812         }
813         
814         // increment the number of reports
815         txn.numOfReports++;
816 
817         emit TxReport(msg.sender, _fromBlockchain, _txId, _to, _amount, _xTransferId);
818 
819         // if theres enough reports, try to release tokens
820         if (txn.numOfReports >= minRequiredReports) {
821             require(!transactions[_txId].completed);
822 
823             // set the transaction as completed
824             transactions[_txId].completed = true;
825 
826             emit XTransferComplete(_to, _xTransferId);
827 
828             releaseTokens(_to, _amount);
829         }
830     }
831 
832     /**
833       * @dev gets x transfer amount by xTransferId (not txId)
834       * 
835       * @param _xTransferId    unique (if non zero) pre-determined id (unlike _txId which is determined after the transactions been broadcasted)
836       * @param _for            address corresponding to xTransferId
837       * 
838       * @return amount that was sent in xTransfer corresponding to _xTransferId
839     */
840     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256) {
841         // xTransferId -> txId -> Transaction
842         Transaction storage transaction = transactions[transactionIds[_xTransferId]];
843 
844         // verify that the xTransferId is for _for
845         require(transaction.to == _for);
846 
847         return transaction.amount;
848     }
849 
850     /**
851       * @dev method for calculating current lock limit
852       * 
853       * @return the current maximum limit of tokens that can be locked
854      */
855     function getCurrentLockLimit() public view returns (uint256) {
856         // prevLockLimit + ((currBlockNumber - prevLockBlockNumber) * limitIncPerBlock)
857         uint256 currentLockLimit = prevLockLimit.add(((block.number).sub(prevLockBlockNumber)).mul(limitIncPerBlock));
858         if (currentLockLimit > maxLockLimit)
859             return maxLockLimit;
860         return currentLockLimit;
861     }
862  
863     /**
864       * @dev method for calculating current release limit
865       * 
866       * @return the current maximum limit of tokens that can be released
867      */
868     function getCurrentReleaseLimit() public view returns (uint256) {
869         // prevReleaseLimit + ((currBlockNumber - prevReleaseBlockNumber) * limitIncPerBlock)
870         uint256 currentReleaseLimit = prevReleaseLimit.add(((block.number).sub(prevReleaseBlockNumber)).mul(limitIncPerBlock));
871         if (currentReleaseLimit > maxReleaseLimit)
872             return maxReleaseLimit;
873         return currentReleaseLimit;
874     }
875 
876     /**
877       * @dev claims and locks tokens from msg.sender to be converted to tokens on another blockchain
878       * 
879       * @param _amount  the amount of tokens to lock
880      */
881     function lockTokens(uint256 _amount) private {
882         if (isSmartToken)
883             ISmartTokenController(ISmartToken(token).owner()).claimTokens(msg.sender, _amount);
884         else
885             token.transferFrom(msg.sender, address(this), _amount);
886         emit TokensLock(msg.sender, _amount);
887     }
888 
889     /**
890       * @dev private method to release tokens held by the contract
891       * 
892       * @param _to      the address to release tokens to
893       * @param _amount  the amount of tokens to release
894      */
895     function releaseTokens(address _to, uint256 _amount) private {
896         // get the current release limit
897         uint256 currentReleaseLimit = getCurrentReleaseLimit();
898 
899         require(_amount >= minLimit && _amount <= currentReleaseLimit);
900         
901         // update the previous release limit and block number
902         prevReleaseLimit = currentReleaseLimit.sub(_amount);
903         prevReleaseBlockNumber = block.number;
904 
905         // no need to require, reverts on failure
906         token.transfer(_to, _amount);
907 
908         emit TokensRelease(_to, _amount);
909     }
910 }