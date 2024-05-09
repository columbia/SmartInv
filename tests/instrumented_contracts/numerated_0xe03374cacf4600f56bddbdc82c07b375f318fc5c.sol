1 // File: contracts/token/interfaces/IERC20Token.sol
2 
3 pragma solidity ^0.4.24;
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
22 // File: contracts/utility/interfaces/IWhitelist.sol
23 
24 pragma solidity ^0.4.24;
25 
26 /*
27     Whitelist interface
28 */
29 contract IWhitelist {
30     function isWhitelisted(address _address) public view returns (bool);
31 }
32 
33 // File: contracts/converter/interfaces/IBancorConverter.sol
34 
35 pragma solidity ^0.4.24;
36 
37 
38 
39 /*
40     Bancor Converter interface
41 */
42 contract IBancorConverter {
43     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
44     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
45     function conversionWhitelist() public view returns (IWhitelist) {}
46     function conversionFee() public view returns (uint32) {}
47     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
48     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
49     function claimTokens(address _from, uint256 _amount) public;
50     // deprecated, backward compatibility
51     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
52 }
53 
54 // File: contracts/converter/interfaces/IBancorConverterUpgrader.sol
55 
56 pragma solidity ^0.4.24;
57 
58 
59 /*
60     Bancor Converter Upgrader interface
61 */
62 contract IBancorConverterUpgrader {
63     function upgrade(bytes32 _version) public;
64     function upgrade(uint16 _version) public;
65 }
66 
67 // File: contracts/converter/interfaces/IBancorFormula.sol
68 
69 pragma solidity ^0.4.24;
70 
71 /*
72     Bancor Formula interface
73 */
74 contract IBancorFormula {
75     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
76     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
77     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
78 }
79 
80 // File: contracts/IBancorNetwork.sol
81 
82 pragma solidity ^0.4.24;
83 
84 
85 /*
86     Bancor Network interface
87 */
88 contract IBancorNetwork {
89     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
90     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
91     
92     function convertForPrioritized3(
93         IERC20Token[] _path,
94         uint256 _amount,
95         uint256 _minReturn,
96         address _for,
97         uint256 _customVal,
98         uint256 _block,
99         uint8 _v,
100         bytes32 _r,
101         bytes32 _s
102     ) public payable returns (uint256);
103     
104     // deprecated, backward compatibility
105     function convertForPrioritized2(
106         IERC20Token[] _path,
107         uint256 _amount,
108         uint256 _minReturn,
109         address _for,
110         uint256 _block,
111         uint8 _v,
112         bytes32 _r,
113         bytes32 _s
114     ) public payable returns (uint256);
115 
116     // deprecated, backward compatibility
117     function convertForPrioritized(
118         IERC20Token[] _path,
119         uint256 _amount,
120         uint256 _minReturn,
121         address _for,
122         uint256 _block,
123         uint256 _nonce,
124         uint8 _v,
125         bytes32 _r,
126         bytes32 _s
127     ) public payable returns (uint256);
128 }
129 
130 // File: contracts/ContractIds.sol
131 
132 pragma solidity ^0.4.24;
133 
134 /**
135     @dev Id definitions for bancor contracts
136 
137     Can be used in conjunction with the contract registry to get contract addresses
138 */
139 contract ContractIds {
140     // generic
141     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
142     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
143     bytes32 public constant NON_STANDARD_TOKEN_REGISTRY = "NonStandardTokenRegistry";
144 
145     // bancor logic
146     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
147     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
148     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
149     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
150     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
151 
152     // BNT core
153     bytes32 public constant BNT_TOKEN = "BNTToken";
154     bytes32 public constant BNT_CONVERTER = "BNTConverter";
155 
156     // BancorX
157     bytes32 public constant BANCOR_X = "BancorX";
158     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
159 }
160 
161 // File: contracts/FeatureIds.sol
162 
163 pragma solidity ^0.4.24;
164 
165 /**
166     @dev Id definitions for bancor contract features
167 
168     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
169 */
170 contract FeatureIds {
171     // converter features
172     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
173 }
174 
175 // File: contracts/utility/interfaces/IOwned.sol
176 
177 pragma solidity ^0.4.24;
178 
179 /*
180     Owned contract interface
181 */
182 contract IOwned {
183     // this function isn't abstract since the compiler emits automatically generated getter functions as external
184     function owner() public view returns (address) {}
185 
186     function transferOwnership(address _newOwner) public;
187     function acceptOwnership() public;
188     function setOwner(address _newOwner) public;
189 }
190 
191 // File: contracts/utility/Owned.sol
192 
193 pragma solidity ^0.4.24;
194 
195 
196 /**
197     @dev Provides support and utilities for contract ownership
198 */
199 contract Owned is IOwned {
200     address public owner;
201     address public newOwner;
202 
203     /**
204         @dev triggered when the owner is updated
205 
206         @param _prevOwner previous owner
207         @param _newOwner  new owner
208     */
209     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
210 
211     /**
212         @dev initializes a new Owned instance
213     */
214     constructor() public {
215         owner = msg.sender;
216     }
217 
218     // allows execution by the owner only
219     modifier ownerOnly {
220         require(msg.sender == owner);
221         _;
222     }
223 
224     /**
225         @dev allows transferring the contract ownership
226         the new owner still needs to accept the transfer
227         can only be called by the contract owner
228 
229         @param _newOwner    new contract owner
230     */
231     function transferOwnership(address _newOwner) public ownerOnly {
232         require(_newOwner != owner);
233         newOwner = _newOwner;
234     }
235 
236     /**
237         @dev used by a new owner to accept an ownership transfer
238     */
239     function acceptOwnership() public {
240         require(msg.sender == newOwner);
241         emit OwnerUpdate(owner, newOwner);
242         owner = newOwner;
243         newOwner = address(0);
244     }
245 
246     function setOwner(address _newOwner) public ownerOnly {
247         require(_newOwner != owner && _newOwner != address(0));
248         emit OwnerUpdate(owner, _newOwner);
249         owner = _newOwner;
250         newOwner = address(0);
251     }
252 }
253 
254 // File: contracts/utility/Managed.sol
255 
256 pragma solidity ^0.4.24;
257 
258 
259 /**
260     @dev Provides support and utilities for contract management
261     Note that a managed contract must also have an owner
262 */
263 contract Managed is Owned {
264     address public manager;
265     address public newManager;
266 
267     /**
268         @dev triggered when the manager is updated
269 
270         @param _prevManager previous manager
271         @param _newManager  new manager
272     */
273     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
274 
275     /**
276         @dev initializes a new Managed instance
277     */
278     constructor() public {
279         manager = msg.sender;
280     }
281 
282     // allows execution by the manager only
283     modifier managerOnly {
284         assert(msg.sender == manager);
285         _;
286     }
287 
288     // allows execution by either the owner or the manager only
289     modifier ownerOrManagerOnly {
290         require(msg.sender == owner || msg.sender == manager);
291         _;
292     }
293 
294     /**
295         @dev allows transferring the contract management
296         the new manager still needs to accept the transfer
297         can only be called by the contract manager
298 
299         @param _newManager    new contract manager
300     */
301     function transferManagement(address _newManager) public ownerOrManagerOnly {
302         require(_newManager != manager);
303         newManager = _newManager;
304     }
305 
306     /**
307         @dev used by a new manager to accept a management transfer
308     */
309     function acceptManagement() public {
310         require(msg.sender == newManager);
311         emit ManagerUpdate(manager, newManager);
312         manager = newManager;
313         newManager = address(0);
314     }
315 }
316 
317 // File: contracts/utility/Utils.sol
318 
319 pragma solidity ^0.4.24;
320 
321 /**
322     @dev Utilities & Common Modifiers
323 */
324 contract Utils {
325     /**
326         constructor
327     */
328     constructor() public {
329     }
330 
331     // verifies that an amount is greater than zero
332     modifier greaterThanZero(uint256 _amount) {
333         require(_amount > 0);
334         _;
335     }
336 
337     // validates an address - currently only checks that it isn't null
338     modifier validAddress(address _address) {
339         require(_address != address(0));
340         _;
341     }
342 
343     // verifies that the address is different than this contract address
344     modifier notThis(address _address) {
345         require(_address != address(this));
346         _;
347     }
348 
349 }
350 
351 // File: contracts/utility/SafeMath.sol
352 
353 pragma solidity ^0.4.24;
354 
355 /**
356     @dev Library for basic math operations with overflow/underflow protection
357 */
358 library SafeMath {
359     /**
360         @dev returns the sum of _x and _y, reverts if the calculation overflows
361 
362         @param _x   value 1
363         @param _y   value 2
364 
365         @return sum
366     */
367     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
368         uint256 z = _x + _y;
369         require(z >= _x);
370         return z;
371     }
372 
373     /**
374         @dev returns the difference of _x minus _y, reverts if the calculation underflows
375 
376         @param _x   minuend
377         @param _y   subtrahend
378 
379         @return difference
380     */
381     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
382         require(_x >= _y);
383         return _x - _y;
384     }
385 
386     /**
387         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
388 
389         @param _x   factor 1
390         @param _y   factor 2
391 
392         @return product
393     */
394     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
395         // gas optimization
396         if (_x == 0)
397             return 0;
398 
399         uint256 z = _x * _y;
400         require(z / _x == _y);
401         return z;
402     }
403 
404       /**
405         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
406 
407         @param _x   dividend
408         @param _y   divisor
409 
410         @return quotient
411     */
412     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
413         require(_y > 0);
414         uint256 c = _x / _y;
415 
416         return c;
417     }
418 }
419 
420 // File: contracts/utility/interfaces/IContractRegistry.sol
421 
422 pragma solidity ^0.4.24;
423 
424 /*
425     Contract Registry interface
426 */
427 contract IContractRegistry {
428     function addressOf(bytes32 _contractName) public view returns (address);
429 
430     // deprecated, backward compatibility
431     function getAddress(bytes32 _contractName) public view returns (address);
432 }
433 
434 // File: contracts/utility/interfaces/IContractFeatures.sol
435 
436 pragma solidity ^0.4.24;
437 
438 /*
439     Contract Features interface
440 */
441 contract IContractFeatures {
442     function isSupported(address _contract, uint256 _features) public view returns (bool);
443     function enableFeatures(uint256 _features, bool _enable) public;
444 }
445 
446 // File: contracts/utility/interfaces/IAddressList.sol
447 
448 pragma solidity ^0.4.24;
449 
450 /*
451     Address list interface
452 */
453 contract IAddressList {
454     mapping (address => bool) public listedAddresses;
455 }
456 
457 // File: contracts/token/interfaces/ISmartToken.sol
458 
459 pragma solidity ^0.4.24;
460 
461 
462 
463 /*
464     Smart Token interface
465 */
466 contract ISmartToken is IOwned, IERC20Token {
467     function disableTransfers(bool _disable) public;
468     function issue(address _to, uint256 _amount) public;
469     function destroy(address _from, uint256 _amount) public;
470 }
471 
472 // File: contracts/utility/interfaces/ITokenHolder.sol
473 
474 pragma solidity ^0.4.24;
475 
476 
477 
478 /*
479     Token Holder interface
480 */
481 contract ITokenHolder is IOwned {
482     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
483 }
484 
485 // File: contracts/token/interfaces/INonStandardERC20.sol
486 
487 pragma solidity ^0.4.24;
488 
489 /*
490     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
491 */
492 contract INonStandardERC20 {
493     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
494     function name() public view returns (string) {}
495     function symbol() public view returns (string) {}
496     function decimals() public view returns (uint8) {}
497     function totalSupply() public view returns (uint256) {}
498     function balanceOf(address _owner) public view returns (uint256) { _owner; }
499     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
500 
501     function transfer(address _to, uint256 _value) public;
502     function transferFrom(address _from, address _to, uint256 _value) public;
503     function approve(address _spender, uint256 _value) public;
504 }
505 
506 // File: contracts/utility/TokenHolder.sol
507 
508 pragma solidity ^0.4.24;
509 
510 
511 
512 
513 
514 
515 /**
516     @dev We consider every contract to be a 'token holder' since it's currently not possible
517     for a contract to deny receiving tokens.
518 
519     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
520     the owner to send tokens that were sent to the contract by mistake back to their sender.
521 
522     Note that we use the non standard ERC-20 interface which has no return value for transfer
523     in order to support both non standard as well as standard token contracts.
524     see https://github.com/ethereum/solidity/issues/4116
525 */
526 contract TokenHolder is ITokenHolder, Owned, Utils {
527     /**
528         @dev initializes a new TokenHolder instance
529     */
530     constructor() public {
531     }
532 
533     /**
534         @dev withdraws tokens held by the contract and sends them to an account
535         can only be called by the owner
536 
537         @param _token   ERC20 token contract address
538         @param _to      account to receive the new amount
539         @param _amount  amount to withdraw
540     */
541     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
542         public
543         ownerOnly
544         validAddress(_token)
545         validAddress(_to)
546         notThis(_to)
547     {
548         INonStandardERC20(_token).transfer(_to, _amount);
549     }
550 }
551 
552 // File: contracts/token/SmartTokenController.sol
553 
554 pragma solidity ^0.4.24;
555 
556 
557 
558 /**
559     @dev The smart token controller is an upgradable part of the smart token that allows
560     more functionality as well as fixes for bugs/exploits.
561     Once it accepts ownership of the token, it becomes the token's sole controller
562     that can execute any of its functions.
563 
564     To upgrade the controller, ownership must be transferred to a new controller, along with
565     any relevant data.
566 
567     The smart token must be set on construction and cannot be changed afterwards.
568     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
569 
570     Note that the controller can transfer token ownership to a new controller that
571     doesn't allow executing any function on the token, for a trustless solution.
572     Doing that will also remove the owner's ability to upgrade the controller.
573 */
574 contract SmartTokenController is TokenHolder {
575     ISmartToken public token;   // smart token
576 
577     /**
578         @dev initializes a new SmartTokenController instance
579     */
580     constructor(ISmartToken _token)
581         public
582         validAddress(_token)
583     {
584         token = _token;
585     }
586 
587     // ensures that the controller is the token's owner
588     modifier active() {
589         require(token.owner() == address(this));
590         _;
591     }
592 
593     // ensures that the controller is not the token's owner
594     modifier inactive() {
595         require(token.owner() != address(this));
596         _;
597     }
598 
599     /**
600         @dev allows transferring the token ownership
601         the new owner needs to accept the transfer
602         can only be called by the contract owner
603 
604         @param _newOwner    new token owner
605     */
606     function transferTokenOwnership(address _newOwner) public ownerOnly {
607         token.transferOwnership(_newOwner);
608     }
609 
610     /**
611         @dev used by a new owner to accept a token ownership transfer
612         can only be called by the contract owner
613     */
614     function acceptTokenOwnership() public ownerOnly {
615         token.acceptOwnership();
616     }
617 
618     /**
619         @dev disables/enables token transfers
620         can only be called by the contract owner
621 
622         @param _disable    true to disable transfers, false to enable them
623     */
624     function disableTokenTransfers(bool _disable) public ownerOnly {
625         token.disableTransfers(_disable);
626     }
627 
628     /**
629         @dev withdraws tokens held by the controller and sends them to an account
630         can only be called by the owner
631 
632         @param _token   ERC20 token contract address
633         @param _to      account to receive the new amount
634         @param _amount  amount to withdraw
635     */
636     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
637         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
638     }
639 }
640 
641 // File: contracts/token/interfaces/IEtherToken.sol
642 
643 pragma solidity ^0.4.24;
644 
645 
646 
647 /*
648     Ether Token interface
649 */
650 contract IEtherToken is ITokenHolder, IERC20Token {
651     function deposit() public payable;
652     function withdraw(uint256 _amount) public;
653     function withdrawTo(address _to, uint256 _amount) public;
654 }
655 
656 // File: contracts/bancorx/interfaces/IBancorX.sol
657 
658 pragma solidity ^0.4.24;
659 
660 contract IBancorX {
661     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
662     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
663 }
664 
665 // File: contracts/converter/BancorConverter.sol
666 
667 pragma solidity ^0.4.24;
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 
685 
686 /**
687     @dev Bancor Converter
688 
689     The Bancor converter allows for conversions between a Smart Token and other ERC20 tokens and between different ERC20 tokens and themselves. 
690 
691     The ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on the actual connector balance.
692 
693     This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract. 
694 
695     The converter is upgradable (just like any SmartTokenController) and all upgrades are opt-in. 
696 
697     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits or with very small numbers because of precision loss 
698 
699     Open issues:
700     - Front-running attacks are currently mitigated by the following mechanisms:
701         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
702         - gas price limit prevents users from having control over the order of execution
703         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
704 
705     Other potential solutions might include a commit/reveal based schemes
706     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
707 */
708 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
709     using SafeMath for uint256;
710 
711     
712     uint32 private constant MAX_WEIGHT = 1000000;
713     uint64 private constant MAX_CONVERSION_FEE = 1000000;
714 
715     struct Connector {
716         uint256 virtualBalance;         // connector virtual balance
717         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
718         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
719         bool isSaleEnabled;             // is sale of the connector token enabled, can be set by the owner
720         bool isSet;                     // used to tell if the mapping element is defined
721     }
722 
723     /**
724         @dev version number
725     */
726     uint16 public version = 14;
727     string public converterType = 'bancor';
728     
729     bool public allowRegistryUpdate = true;             // allows the owner to prevent/allow the registry to be updated
730     bool public claimTokensEnabled = false;             // allows BancorX contract to claim tokens without allowance (to save the extra transaction)
731     IContractRegistry public prevRegistry;              // address of previous registry as security mechanism
732     IContractRegistry public registry;                  // contract registry contract
733     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
734     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
735     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
736     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
737     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
738                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
739     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
740     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
741     IERC20Token[] private convertPath;
742 
743     /**
744         @dev triggered when a conversion between two tokens occurs
745 
746         @param _fromToken       ERC20 token converted from
747         @param _toToken         ERC20 token converted to
748         @param _trader          wallet that initiated the trade
749         @param _amount          amount converted, in fromToken
750         @param _return          amount returned, minus conversion fee
751         @param _conversionFee   conversion fee
752     */
753     event Conversion(
754         address indexed _fromToken,
755         address indexed _toToken,
756         address indexed _trader,
757         uint256 _amount,
758         uint256 _return,
759         int256 _conversionFee
760     );
761 
762     /**
763         @dev triggered after a conversion with new price data
764 
765         @param  _connectorToken     connector token
766         @param  _tokenSupply        smart token supply
767         @param  _connectorBalance   connector balance
768         @param  _connectorWeight    connector weight
769     */
770     event PriceDataUpdate(
771         address indexed _connectorToken,
772         uint256 _tokenSupply,
773         uint256 _connectorBalance,
774         uint32 _connectorWeight
775     );
776 
777     /**
778         @dev triggered when the conversion fee is updated
779 
780         @param  _prevFee    previous fee percentage, represented in ppm
781         @param  _newFee     new fee percentage, represented in ppm
782     */
783     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
784 
785     /**
786         @dev triggered when conversions are enabled/disabled
787 
788         @param  _conversionsEnabled true if conversions are enabled, false if not
789     */
790     event ConversionsEnable(bool _conversionsEnabled);
791 
792     /**
793         @dev initializes a new BancorConverter instance
794 
795         @param  _token              smart token governed by the converter
796         @param  _registry           address of a contract registry contract
797         @param  _maxConversionFee   maximum conversion fee, represented in ppm
798         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
799         @param  _connectorWeight    optional, weight for the initial connector
800     */
801     constructor(
802         ISmartToken _token,
803         IContractRegistry _registry,
804         uint32 _maxConversionFee,
805         IERC20Token _connectorToken,
806         uint32 _connectorWeight
807     )
808         public
809         SmartTokenController(_token)
810         validAddress(_registry)
811         validMaxConversionFee(_maxConversionFee)
812     {
813         registry = _registry;
814         prevRegistry = _registry;
815         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
816 
817         // initialize supported features
818         if (features != address(0))
819             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
820 
821         maxConversionFee = _maxConversionFee;
822 
823         if (_connectorToken != address(0))
824             addConnector(_connectorToken, _connectorWeight, false);
825     }
826 
827     // validates a connector token address - verifies that the address belongs to one of the connector tokens
828     modifier validConnector(IERC20Token _address) {
829         require(connectors[_address].isSet);
830         _;
831     }
832 
833     // validates a token address - verifies that the address belongs to one of the convertible tokens
834     modifier validToken(IERC20Token _address) {
835         require(_address == token || connectors[_address].isSet);
836         _;
837     }
838 
839     // validates maximum conversion fee
840     modifier validMaxConversionFee(uint32 _conversionFee) {
841         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
842         _;
843     }
844 
845     // validates conversion fee
846     modifier validConversionFee(uint32 _conversionFee) {
847         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
848         _;
849     }
850 
851     // validates connector weight range
852     modifier validConnectorWeight(uint32 _weight) {
853         require(_weight > 0 && _weight <= MAX_WEIGHT);
854         _;
855     }
856 
857     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
858     modifier validConversionPath(IERC20Token[] _path) {
859         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
860         _;
861     }
862 
863     // allows execution only when the total weight is 100%
864     modifier maxTotalWeightOnly() {
865         require(totalConnectorWeight == MAX_WEIGHT);
866         _;
867     }
868 
869     // allows execution only when conversions aren't disabled
870     modifier conversionsAllowed {
871         assert(conversionsEnabled);
872         _;
873     }
874 
875     // allows execution by the BancorNetwork contract only
876     modifier bancorNetworkOnly {
877         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
878         require(msg.sender == address(bancorNetwork));
879         _;
880     }
881 
882     // allows execution by the converter upgrader contract only
883     modifier converterUpgraderOnly {
884         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
885         require(owner == converterUpgrader);
886         _;
887     }
888 
889     // allows execution only when claim tokens is enabled
890     modifier whenClaimTokensEnabled {
891         require(claimTokensEnabled);
892         _;
893     }
894 
895     /**
896         @dev sets the contract registry to whichever address the current registry is pointing to
897      */
898     function updateRegistry() public {
899         // require that upgrading is allowed or that the caller is the owner
900         require(allowRegistryUpdate || msg.sender == owner);
901 
902         // get the address of whichever registry the current registry is pointing to
903         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
904 
905         // if the new registry hasn't changed or is the zero address, revert
906         require(newRegistry != address(registry) && newRegistry != address(0));
907 
908         // set the previous registry as current registry and current registry as newRegistry
909         prevRegistry = registry;
910         registry = IContractRegistry(newRegistry);
911     }
912 
913     /**
914         @dev security mechanism allowing the converter owner to revert to the previous registry,
915         to be used in emergency scenario
916     */
917     function restoreRegistry() public ownerOrManagerOnly {
918         // set the registry as previous registry
919         registry = prevRegistry;
920 
921         // after a previous registry is restored, only the owner can allow future updates
922         allowRegistryUpdate = false;
923     }
924 
925     /**
926         @dev disables the registry update functionality
927         this is a safety mechanism in case of a emergency
928         can only be called by the manager or owner
929 
930         @param _disable    true to disable registry updates, false to re-enable them
931     */
932     function disableRegistryUpdate(bool _disable) public ownerOrManagerOnly {
933         allowRegistryUpdate = !_disable;
934     }
935 
936     /**
937         @dev disables/enables the claim tokens functionality
938 
939         @param _enable    true to enable claiming of tokens, false to disable
940      */
941     function enableClaimTokens(bool _enable) public ownerOnly {
942         claimTokensEnabled = _enable;
943     }
944 
945     /**
946         @dev returns the number of connector tokens defined
947 
948         @return number of connector tokens
949     */
950     function connectorTokenCount() public view returns (uint16) {
951         return uint16(connectorTokens.length);
952     }
953 
954     /**
955         @dev allows the owner to update & enable the conversion whitelist contract address
956         when set, only addresses that are whitelisted are actually allowed to use the converter
957         note that the whitelist check is actually done by the BancorNetwork contract
958 
959         @param _whitelist    address of a whitelist contract
960     */
961     function setConversionWhitelist(IWhitelist _whitelist)
962         public
963         ownerOnly
964         notThis(_whitelist)
965     {
966         conversionWhitelist = _whitelist;
967     }
968 
969     /**
970         @dev disables the entire conversion functionality
971         this is a safety mechanism in case of a emergency
972         can only be called by the manager
973 
974         @param _disable true to disable conversions, false to re-enable them
975     */
976     function disableConversions(bool _disable) public ownerOrManagerOnly {
977         if (conversionsEnabled == _disable) {
978             conversionsEnabled = !_disable;
979             emit ConversionsEnable(conversionsEnabled);
980         }
981     }
982 
983     /**
984         @dev allows transferring the token ownership
985         the new owner needs to accept the transfer
986         can only be called by the contract owner
987         note that token ownership can only be transferred while the owner is the converter upgrader contract
988 
989         @param _newOwner    new token owner
990     */
991     function transferTokenOwnership(address _newOwner)
992         public
993         ownerOnly
994         converterUpgraderOnly
995     {
996         super.transferTokenOwnership(_newOwner);
997     }
998 
999     /**
1000         @dev updates the current conversion fee
1001         can only be called by the manager
1002 
1003         @param _conversionFee new conversion fee, represented in ppm
1004     */
1005     function setConversionFee(uint32 _conversionFee)
1006         public
1007         ownerOrManagerOnly
1008         validConversionFee(_conversionFee)
1009     {
1010         emit ConversionFeeUpdate(conversionFee, _conversionFee);
1011         conversionFee = _conversionFee;
1012     }
1013 
1014     /**
1015         @dev given a return amount, returns the amount minus the conversion fee
1016 
1017         @param _amount      return amount
1018         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
1019 
1020         @return return amount minus conversion fee
1021     */
1022     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
1023         return _amount.mul((MAX_CONVERSION_FEE - conversionFee) ** _magnitude).div(MAX_CONVERSION_FEE ** _magnitude);
1024     }
1025 
1026     /**
1027         @dev withdraws tokens held by the converter and sends them to an account
1028         can only be called by the owner
1029         note that connector tokens can only be withdrawn by the owner while the converter is inactive
1030         unless the owner is the converter upgrader contract
1031 
1032         @param _token   ERC20 token contract address
1033         @param _to      account to receive the new amount
1034         @param _amount  amount to withdraw
1035     */
1036     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
1037         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
1038 
1039         // if the token is not a connector token, allow withdrawal
1040         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
1041         require(!connectors[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
1042         super.withdrawTokens(_token, _to, _amount);
1043     }
1044 
1045     /**
1046         @dev allows the BancorX contract to claim BNT from any address (so that users
1047         dont have to first give allowance when calling BancorX)
1048 
1049         @param _from      address to claim the BNT from
1050         @param _amount    the amount to claim
1051      */
1052     function claimTokens(address _from, uint256 _amount) public whenClaimTokensEnabled {
1053         address bancorX = registry.addressOf(ContractIds.BANCOR_X);
1054 
1055         // only the bancorX contract may call this method
1056         require(msg.sender == bancorX);
1057 
1058         // destroy the tokens belonging to _from, and issue the same amount to bancorX contract
1059         token.destroy(_from, _amount);
1060         token.issue(msg.sender, _amount);
1061     }
1062 
1063     /**
1064         @dev upgrades the converter to the latest version
1065         can only be called by the owner
1066         note that the owner needs to call acceptOwnership/acceptManagement on the new converter after the upgrade
1067     */
1068     function upgrade() public ownerOnly {
1069         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER));
1070 
1071         transferOwnership(converterUpgrader);
1072         converterUpgrader.upgrade(version);
1073         acceptOwnership();
1074     }
1075 
1076     /**
1077         @dev defines a new connector for the token
1078         can only be called by the owner while the converter is inactive
1079 
1080         @param _token                  address of the connector token
1081         @param _weight                 constant connector weight, represented in ppm, 1-1000000
1082         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
1083     */
1084     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
1085         public
1086         ownerOnly
1087         inactive
1088         validAddress(_token)
1089         notThis(_token)
1090         validConnectorWeight(_weight)
1091     {
1092         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
1093 
1094         connectors[_token].virtualBalance = 0;
1095         connectors[_token].weight = _weight;
1096         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
1097         connectors[_token].isSaleEnabled = true;
1098         connectors[_token].isSet = true;
1099         connectorTokens.push(_token);
1100         totalConnectorWeight += _weight;
1101     }
1102 
1103     /**
1104         @dev updates one of the token connectors
1105         can only be called by the owner
1106 
1107         @param _connectorToken         address of the connector token
1108         @param _weight                 constant connector weight, represented in ppm, 1-1000000
1109         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
1110         @param _virtualBalance         new connector's virtual balance
1111     */
1112     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
1113         public
1114         ownerOnly
1115         validConnector(_connectorToken)
1116         validConnectorWeight(_weight)
1117     {
1118         Connector storage connector = connectors[_connectorToken];
1119         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
1120 
1121         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
1122         connector.weight = _weight;
1123         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
1124         connector.virtualBalance = _virtualBalance;
1125     }
1126 
1127     /**
1128         @dev disables converting from the given connector token in case the connector token got compromised
1129         can only be called by the owner
1130         note that converting to the token is still enabled regardless of this flag and it cannot be disabled by the owner
1131 
1132         @param _connectorToken  connector token contract address
1133         @param _disable         true to disable the token, false to re-enable it
1134     */
1135     function disableConnectorSale(IERC20Token _connectorToken, bool _disable)
1136         public
1137         ownerOnly
1138         validConnector(_connectorToken)
1139     {
1140         connectors[_connectorToken].isSaleEnabled = !_disable;
1141     }
1142 
1143     /**
1144         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
1145 
1146         @param _connectorToken  connector token contract address
1147 
1148         @return connector balance
1149     */
1150     function getConnectorBalance(IERC20Token _connectorToken)
1151         public
1152         view
1153         validConnector(_connectorToken)
1154         returns (uint256)
1155     {
1156         Connector storage connector = connectors[_connectorToken];
1157         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
1158     }
1159 
1160     /**
1161         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
1162 
1163         @param _fromToken  ERC20 token to convert from
1164         @param _toToken    ERC20 token to convert to
1165         @param _amount     amount to convert, in fromToken
1166 
1167         @return expected conversion return amount and conversion fee
1168     */
1169     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
1170         require(_fromToken != _toToken); // validate input
1171 
1172         // conversion between the token and one of its connectors
1173         if (_toToken == token)
1174             return getPurchaseReturn(_fromToken, _amount);
1175         else if (_fromToken == token)
1176             return getSaleReturn(_toToken, _amount);
1177 
1178         // conversion between 2 connectors
1179         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
1180     }
1181 
1182     /**
1183         @dev returns the expected return for buying the token for a connector token
1184 
1185         @param _connectorToken  connector token contract address
1186         @param _depositAmount   amount to deposit (in the connector token)
1187 
1188         @return expected purchase return amount and conversion fee
1189     */
1190     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
1191         public
1192         view
1193         active
1194         validConnector(_connectorToken)
1195         returns (uint256, uint256)
1196     {
1197         Connector storage connector = connectors[_connectorToken];
1198         require(connector.isSaleEnabled); // validate input
1199 
1200         uint256 tokenSupply = token.totalSupply();
1201         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1202         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1203         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
1204         uint256 finalAmount = getFinalAmount(amount, 1);
1205 
1206         // return the amount minus the conversion fee and the conversion fee
1207         return (finalAmount, amount - finalAmount);
1208     }
1209 
1210     /**
1211         @dev returns the expected return for selling the token for one of its connector tokens
1212 
1213         @param _connectorToken  connector token contract address
1214         @param _sellAmount      amount to sell (in the smart token)
1215 
1216         @return expected sale return amount and conversion fee
1217     */
1218     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
1219         public
1220         view
1221         active
1222         validConnector(_connectorToken)
1223         returns (uint256, uint256)
1224     {
1225         Connector storage connector = connectors[_connectorToken];
1226         uint256 tokenSupply = token.totalSupply();
1227         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1228         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1229         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
1230         uint256 finalAmount = getFinalAmount(amount, 1);
1231 
1232         // return the amount minus the conversion fee and the conversion fee
1233         return (finalAmount, amount - finalAmount);
1234     }
1235 
1236     /**
1237         @dev returns the expected return for selling one of the connector tokens for another connector token
1238 
1239         @param _fromConnectorToken  contract address of the connector token to convert from
1240         @param _toConnectorToken    contract address of the connector token to convert to
1241         @param _sellAmount          amount to sell (in the from connector token)
1242 
1243         @return expected sale return amount and conversion fee (in the to connector token)
1244     */
1245     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
1246         public
1247         view
1248         active
1249         validConnector(_fromConnectorToken)
1250         validConnector(_toConnectorToken)
1251         returns (uint256, uint256)
1252     {
1253         Connector storage fromConnector = connectors[_fromConnectorToken];
1254         Connector storage toConnector = connectors[_toConnectorToken];
1255         require(fromConnector.isSaleEnabled); // validate input
1256 
1257         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1258         uint256 amount = formula.calculateCrossConnectorReturn(
1259             getConnectorBalance(_fromConnectorToken), 
1260             fromConnector.weight, 
1261             getConnectorBalance(_toConnectorToken), 
1262             toConnector.weight, 
1263             _sellAmount);
1264         uint256 finalAmount = getFinalAmount(amount, 2);
1265 
1266         // return the amount minus the conversion fee and the conversion fee
1267         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1268         return (finalAmount, amount - finalAmount);
1269     }
1270 
1271     /**
1272         @dev converts a specific amount of _fromToken to _toToken
1273         can only be called by the bancor network contract
1274 
1275         @param _fromToken  ERC20 token to convert from
1276         @param _toToken    ERC20 token to convert to
1277         @param _amount     amount to convert, in fromToken
1278         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1279 
1280         @return conversion return amount
1281     */
1282     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1283         public
1284         bancorNetworkOnly
1285         conversionsAllowed
1286         greaterThanZero(_minReturn)
1287         returns (uint256)
1288     {
1289         require(_fromToken != _toToken); // validate input
1290 
1291         // conversion between the token and one of its connectors
1292         if (_toToken == token)
1293             return buy(_fromToken, _amount, _minReturn);
1294         else if (_fromToken == token)
1295             return sell(_toToken, _amount, _minReturn);
1296 
1297         uint256 amount;
1298         uint256 feeAmount;
1299 
1300         // conversion between 2 connectors
1301         (amount, feeAmount) = getCrossConnectorReturn(_fromToken, _toToken, _amount);
1302         // ensure the trade gives something in return and meets the minimum requested amount
1303         require(amount != 0 && amount >= _minReturn);
1304 
1305         // update the source token virtual balance if relevant
1306         Connector storage fromConnector = connectors[_fromToken];
1307         if (fromConnector.isVirtualBalanceEnabled)
1308             fromConnector.virtualBalance = fromConnector.virtualBalance.add(_amount);
1309 
1310         // update the target token virtual balance if relevant
1311         Connector storage toConnector = connectors[_toToken];
1312         if (toConnector.isVirtualBalanceEnabled)
1313             toConnector.virtualBalance = toConnector.virtualBalance.sub(amount);
1314 
1315         // ensure that the trade won't deplete the connector balance
1316         uint256 toConnectorBalance = getConnectorBalance(_toToken);
1317         assert(amount < toConnectorBalance);
1318 
1319         // transfer funds from the caller in the from connector token
1320         ensureTransferFrom(_fromToken, msg.sender, this, _amount);
1321         // transfer funds to the caller in the to connector token
1322         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1323         ensureTransfer(_toToken, msg.sender, amount);
1324 
1325         // dispatch the conversion event
1326         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1327         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1328 
1329         // dispatch price data updates for the smart token / both connectors
1330         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
1331         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
1332         return amount;
1333     }
1334 
1335     /**
1336         @dev converts a specific amount of _fromToken to _toToken
1337 
1338         @param _fromToken  ERC20 token to convert from
1339         @param _toToken    ERC20 token to convert to
1340         @param _amount     amount to convert, in fromToken
1341         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1342 
1343         @return conversion return amount
1344     */
1345     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1346         convertPath = [_fromToken, token, _toToken];
1347         return quickConvert(convertPath, _amount, _minReturn);
1348     }
1349 
1350     /**
1351         @dev buys the token by depositing one of its connector tokens
1352 
1353         @param _connectorToken  connector token contract address
1354         @param _depositAmount   amount to deposit (in the connector token)
1355         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1356 
1357         @return buy return amount
1358     */
1359     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1360         uint256 amount;
1361         uint256 feeAmount;
1362         (amount, feeAmount) = getPurchaseReturn(_connectorToken, _depositAmount);
1363         // ensure the trade gives something in return and meets the minimum requested amount
1364         require(amount != 0 && amount >= _minReturn);
1365 
1366         // update virtual balance if relevant
1367         Connector storage connector = connectors[_connectorToken];
1368         if (connector.isVirtualBalanceEnabled)
1369             connector.virtualBalance = connector.virtualBalance.add(_depositAmount);
1370 
1371         // transfer funds from the caller in the connector token
1372         ensureTransferFrom(_connectorToken, msg.sender, this, _depositAmount);
1373         // issue new funds to the caller in the smart token
1374         token.issue(msg.sender, amount);
1375 
1376         // dispatch the conversion event
1377         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
1378 
1379         // dispatch price data update for the smart token/connector
1380         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1381         return amount;
1382     }
1383 
1384     /**
1385         @dev sells the token by withdrawing from one of its connector tokens
1386 
1387         @param _connectorToken  connector token contract address
1388         @param _sellAmount      amount to sell (in the smart token)
1389         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1390 
1391         @return sell return amount
1392     */
1393     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1394         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1395         uint256 amount;
1396         uint256 feeAmount;
1397         (amount, feeAmount) = getSaleReturn(_connectorToken, _sellAmount);
1398         // ensure the trade gives something in return and meets the minimum requested amount
1399         require(amount != 0 && amount >= _minReturn);
1400 
1401         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1402         uint256 tokenSupply = token.totalSupply();
1403         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1404         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1405 
1406         // update virtual balance if relevant
1407         Connector storage connector = connectors[_connectorToken];
1408         if (connector.isVirtualBalanceEnabled)
1409             connector.virtualBalance = connector.virtualBalance.sub(amount);
1410 
1411         // destroy _sellAmount from the caller's balance in the smart token
1412         token.destroy(msg.sender, _sellAmount);
1413         // transfer funds to the caller in the connector token
1414         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1415         ensureTransfer(_connectorToken, msg.sender, amount);
1416 
1417         // dispatch the conversion event
1418         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1419 
1420         // dispatch price data update for the smart token/connector
1421         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1422         return amount;
1423     }
1424 
1425     /**
1426         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1427         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1428 
1429         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1430         @param _amount      amount to convert from (in the initial source token)
1431         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1432 
1433         @return tokens issued in return
1434     */
1435     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1436         public
1437         payable
1438         returns (uint256)
1439     {
1440         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1441     }
1442 
1443     /**
1444         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1445         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1446 
1447         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1448         @param _amount      amount to convert from (in the initial source token)
1449         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1450         @param _block       if the current block exceeded the given parameter - it is cancelled
1451         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1452         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1453         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1454 
1455         @return tokens issued in return
1456     */
1457     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1458         public
1459         payable
1460         returns (uint256)
1461     {
1462         IERC20Token fromToken = _path[0];
1463         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1464 
1465         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1466         // so it can execute the conversion on behalf of the caller
1467         if (msg.value == 0) {
1468             // not ETH, send the source tokens to the BancorNetwork contract
1469             // if the token is the smart token, no allowance is required - destroy the tokens
1470             // from the caller and issue them to the BancorNetwork contract
1471             if (fromToken == token) {
1472                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1473                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1474             } else {
1475                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1476                 ensureTransferFrom(fromToken, msg.sender, bancorNetwork, _amount);
1477             }
1478         }
1479 
1480         // execute the conversion and pass on the ETH with the call
1481         return bancorNetwork.convertForPrioritized3.value(msg.value)(_path, _amount, _minReturn, msg.sender, _amount, _block, _v, _r, _s);
1482     }
1483 
1484     /**
1485         @dev allows a user to convert BNT that was sent from another blockchain into any other
1486         token on the BancorNetwork without specifying the amount of BNT to be converted, but
1487         rather by providing the xTransferId which allows us to get the amount from BancorX.
1488 
1489         @param _path             conversion path, see conversion path format in the BancorNetwork contract
1490         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1491         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
1492         @param _block            if the current block exceeded the given parameter - it is cancelled
1493         @param _v                (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1494         @param _r                (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1495         @param _s                (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1496 
1497         @return tokens issued in return
1498     */
1499     function completeXConversion(
1500         IERC20Token[] _path,
1501         uint256 _minReturn,
1502         uint256 _conversionId,
1503         uint256 _block,
1504         uint8 _v,
1505         bytes32 _r,
1506         bytes32 _s
1507     )
1508         public
1509         returns (uint256)
1510     {
1511         IBancorX bancorX = IBancorX(registry.addressOf(ContractIds.BANCOR_X));
1512         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1513 
1514         // verify that the first token in the path is BNT
1515         require(_path[0] == registry.addressOf(ContractIds.BNT_TOKEN));
1516 
1517         // get conversion amount from BancorX contract
1518         uint256 amount = bancorX.getXTransferAmount(_conversionId, msg.sender);
1519 
1520         // send BNT from msg.sender to the BancorNetwork contract
1521         token.destroy(msg.sender, amount);
1522         token.issue(bancorNetwork, amount);
1523 
1524         return bancorNetwork.convertForPrioritized3(_path, amount, _minReturn, msg.sender, _conversionId, _block, _v, _r, _s);
1525     }
1526 
1527     /**
1528         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1529         true on success but revert on failure instead
1530 
1531         @param _token     the token to transfer
1532         @param _to        the address to transfer the tokens to
1533         @param _amount    the amount to transfer
1534     */
1535     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1536         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1537 
1538         if (addressList.listedAddresses(_token)) {
1539             uint256 prevBalance = _token.balanceOf(_to);
1540             // we have to cast the token contract in an interface which has no return value
1541             INonStandardERC20(_token).transfer(_to, _amount);
1542             uint256 postBalance = _token.balanceOf(_to);
1543             assert(postBalance > prevBalance);
1544         } else {
1545             // if the token isn't whitelisted, we assert on transfer
1546             assert(_token.transfer(_to, _amount));
1547         }
1548     }
1549 
1550     /**
1551         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1552         true on success but revert on failure instead
1553 
1554         @param _token     the token to transfer
1555         @param _from      the address to transfer the tokens from
1556         @param _to        the address to transfer the tokens to
1557         @param _amount    the amount to transfer
1558     */
1559     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1560         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1561 
1562         if (addressList.listedAddresses(_token)) {
1563             uint256 prevBalance = _token.balanceOf(_to);
1564             // we have to cast the token contract in an interface which has no return value
1565             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1566             uint256 postBalance = _token.balanceOf(_to);
1567             assert(postBalance > prevBalance);
1568         } else {
1569             // if the token is standard, we assert on transfer
1570             assert(_token.transferFrom(_from, _to, _amount));
1571         }
1572     }
1573 
1574     /**
1575         @dev buys the token with all connector tokens using the same percentage
1576         i.e. if the caller increases the supply by 10%, it will cost an amount equal to
1577         10% of each connector token balance
1578         can only be called if the max total weight is exactly 100% and while conversions are enabled
1579 
1580         @param _amount  amount to increase the supply by (in the smart token)
1581     */
1582     function fund(uint256 _amount)
1583         public
1584         maxTotalWeightOnly
1585         conversionsAllowed
1586     {
1587         uint256 supply = token.totalSupply();
1588 
1589         // iterate through the connector tokens and transfer a percentage equal to the ratio between _amount
1590         // and the total supply in each connector from the caller to the converter
1591         IERC20Token connectorToken;
1592         uint256 connectorBalance;
1593         uint256 connectorAmount;
1594         for (uint16 i = 0; i < connectorTokens.length; i++) {
1595             connectorToken = connectorTokens[i];
1596             connectorBalance = getConnectorBalance(connectorToken);
1597             connectorAmount = _amount.mul(connectorBalance).sub(1).div(supply).add(1);
1598 
1599             // update virtual balance if relevant
1600             Connector storage connector = connectors[connectorToken];
1601             if (connector.isVirtualBalanceEnabled)
1602                 connector.virtualBalance = connector.virtualBalance.add(connectorAmount);
1603 
1604             // transfer funds from the caller in the connector token
1605             ensureTransferFrom(connectorToken, msg.sender, this, connectorAmount);
1606 
1607             // dispatch price data update for the smart token/connector
1608             emit PriceDataUpdate(connectorToken, supply + _amount, connectorBalance + connectorAmount, connector.weight);
1609         }
1610 
1611         // issue new funds to the caller in the smart token
1612         token.issue(msg.sender, _amount);
1613     }
1614 
1615     /**
1616         @dev sells the token for all connector tokens using the same percentage
1617         i.e. if the holder sells 10% of the supply, they will receive 10% of each
1618         connector token balance in return
1619         can only be called if the max total weight is exactly 100%
1620         note that the function can also be called if conversions are disabled
1621 
1622         @param _amount  amount to liquidate (in the smart token)
1623     */
1624     function liquidate(uint256 _amount) public maxTotalWeightOnly {
1625         uint256 supply = token.totalSupply();
1626 
1627         // destroy _amount from the caller's balance in the smart token
1628         token.destroy(msg.sender, _amount);
1629 
1630         // iterate through the connector tokens and send a percentage equal to the ratio between _amount
1631         // and the total supply from each connector balance to the caller
1632         IERC20Token connectorToken;
1633         uint256 connectorBalance;
1634         uint256 connectorAmount;
1635         for (uint16 i = 0; i < connectorTokens.length; i++) {
1636             connectorToken = connectorTokens[i];
1637             connectorBalance = getConnectorBalance(connectorToken);
1638             connectorAmount = _amount.mul(connectorBalance).div(supply);
1639 
1640             // update virtual balance if relevant
1641             Connector storage connector = connectors[connectorToken];
1642             if (connector.isVirtualBalanceEnabled)
1643                 connector.virtualBalance = connector.virtualBalance.sub(connectorAmount);
1644 
1645             // transfer funds to the caller in the connector token
1646             // the transfer might fail if the actual connector balance is smaller than the virtual balance
1647             ensureTransfer(connectorToken, msg.sender, connectorAmount);
1648 
1649             // dispatch price data update for the smart token/connector
1650             emit PriceDataUpdate(connectorToken, supply - _amount, connectorBalance - connectorAmount, connector.weight);
1651         }
1652     }
1653 
1654     /**
1655         @dev deprecated, backward compatibility
1656     */
1657     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1658         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1659     }
1660 
1661     /**
1662         @dev helper, dispatches the Conversion event
1663 
1664         @param _fromToken       ERC20 token to convert from
1665         @param _toToken         ERC20 token to convert to
1666         @param _amount          amount purchased/sold (in the source token)
1667         @param _returnAmount    amount returned (in the target token)
1668     */
1669     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1670         // fee amount is converted to 255 bits -
1671         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1672         // currently the fee is always taken from the target token
1673         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1674         assert(_feeAmount <= 2 ** 255);
1675         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1676     }
1677 }