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
22 // File: contracts/utility/interfaces/IWhitelist.sol
23 
24 /*
25     Whitelist interface
26 */
27 contract IWhitelist {
28     function isWhitelisted(address _address) public view returns (bool);
29 }
30 
31 // File: contracts/converter/interfaces/IBancorConverter.sol
32 
33 /*
34     Bancor Converter interface
35 */
36 contract IBancorConverter {
37     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
38     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
39     function conversionWhitelist() public view returns (IWhitelist) {}
40     function conversionFee() public view returns (uint32) {}
41     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
42     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
43     function claimTokens(address _from, uint256 _amount) public;
44     // deprecated, backward compatibility
45     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
46 }
47 
48 // File: contracts/converter/interfaces/IBancorConverterUpgrader.sol
49 
50 /*
51     Bancor Converter Upgrader interface
52 */
53 contract IBancorConverterUpgrader {
54     function upgrade(bytes32 _version) public;
55     function upgrade(uint16 _version) public;
56 }
57 
58 // File: contracts/converter/interfaces/IBancorFormula.sol
59 
60 /*
61     Bancor Formula interface
62 */
63 contract IBancorFormula {
64     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
65     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
66     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
67 }
68 
69 // File: contracts/IBancorNetwork.sol
70 
71 /*
72     Bancor Network interface
73 */
74 contract IBancorNetwork {
75     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
76     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
77     
78     function convertForPrioritized3(
79         IERC20Token[] _path,
80         uint256 _amount,
81         uint256 _minReturn,
82         address _for,
83         uint256 _customVal,
84         uint256 _block,
85         uint8 _v,
86         bytes32 _r,
87         bytes32 _s
88     ) public payable returns (uint256);
89     
90     // deprecated, backward compatibility
91     function convertForPrioritized2(
92         IERC20Token[] _path,
93         uint256 _amount,
94         uint256 _minReturn,
95         address _for,
96         uint256 _block,
97         uint8 _v,
98         bytes32 _r,
99         bytes32 _s
100     ) public payable returns (uint256);
101 
102     // deprecated, backward compatibility
103     function convertForPrioritized(
104         IERC20Token[] _path,
105         uint256 _amount,
106         uint256 _minReturn,
107         address _for,
108         uint256 _block,
109         uint256 _nonce,
110         uint8 _v,
111         bytes32 _r,
112         bytes32 _s
113     ) public payable returns (uint256);
114 }
115 
116 // File: contracts/ContractIds.sol
117 
118 /**
119     Id definitions for bancor contracts
120 
121     Can be used in conjunction with the contract registry to get contract addresses
122 */
123 contract ContractIds {
124     // generic
125     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
126     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
127 
128     // bancor logic
129     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
130     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
131     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
132     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
133     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
134 
135     // BNT core
136     bytes32 public constant BNT_TOKEN = "BNTToken";
137     bytes32 public constant BNT_CONVERTER = "BNTConverter";
138 
139     // BancorX
140     bytes32 public constant BANCOR_X = "BancorX";
141     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
142 }
143 
144 // File: contracts/FeatureIds.sol
145 
146 /**
147     Id definitions for bancor contract features
148 
149     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
150 */
151 contract FeatureIds {
152     // converter features
153     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
154 }
155 
156 // File: contracts/utility/interfaces/IOwned.sol
157 
158 /*
159     Owned contract interface
160 */
161 contract IOwned {
162     // this function isn't abstract since the compiler emits automatically generated getter functions as external
163     function owner() public view returns (address) {}
164 
165     function transferOwnership(address _newOwner) public;
166     function acceptOwnership() public;
167 }
168 
169 // File: contracts/utility/Owned.sol
170 
171 /*
172     Provides support and utilities for contract ownership
173 */
174 contract Owned is IOwned {
175     address public owner;
176     address public newOwner;
177 
178     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
179 
180     /**
181         @dev constructor
182     */
183     constructor() public {
184         owner = msg.sender;
185     }
186 
187     // allows execution by the owner only
188     modifier ownerOnly {
189         require(msg.sender == owner);
190         _;
191     }
192 
193     /**
194         @dev allows transferring the contract ownership
195         the new owner still needs to accept the transfer
196         can only be called by the contract owner
197 
198         @param _newOwner    new contract owner
199     */
200     function transferOwnership(address _newOwner) public ownerOnly {
201         require(_newOwner != owner);
202         newOwner = _newOwner;
203     }
204 
205     /**
206         @dev used by a new owner to accept an ownership transfer
207     */
208     function acceptOwnership() public {
209         require(msg.sender == newOwner);
210         emit OwnerUpdate(owner, newOwner);
211         owner = newOwner;
212         newOwner = address(0);
213     }
214 }
215 
216 // File: contracts/utility/Managed.sol
217 
218 /*
219     Provides support and utilities for contract management
220     Note that a managed contract must also have an owner
221 */
222 contract Managed is Owned {
223     address public manager;
224     address public newManager;
225 
226     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
227 
228     /**
229         @dev constructor
230     */
231     constructor() public {
232         manager = msg.sender;
233     }
234 
235     // allows execution by the manager only
236     modifier managerOnly {
237         assert(msg.sender == manager);
238         _;
239     }
240 
241     // allows execution by either the owner or the manager only
242     modifier ownerOrManagerOnly {
243         require(msg.sender == owner || msg.sender == manager);
244         _;
245     }
246 
247     /**
248         @dev allows transferring the contract management
249         the new manager still needs to accept the transfer
250         can only be called by the contract manager
251 
252         @param _newManager    new contract manager
253     */
254     function transferManagement(address _newManager) public ownerOrManagerOnly {
255         require(_newManager != manager);
256         newManager = _newManager;
257     }
258 
259     /**
260         @dev used by a new manager to accept a management transfer
261     */
262     function acceptManagement() public {
263         require(msg.sender == newManager);
264         emit ManagerUpdate(manager, newManager);
265         manager = newManager;
266         newManager = address(0);
267     }
268 }
269 
270 // File: contracts/utility/Utils.sol
271 
272 /*
273     Utilities & Common Modifiers
274 */
275 contract Utils {
276     /**
277         constructor
278     */
279     constructor() public {
280     }
281 
282     // verifies that an amount is greater than zero
283     modifier greaterThanZero(uint256 _amount) {
284         require(_amount > 0);
285         _;
286     }
287 
288     // validates an address - currently only checks that it isn't null
289     modifier validAddress(address _address) {
290         require(_address != address(0));
291         _;
292     }
293 
294     // verifies that the address is different than this contract address
295     modifier notThis(address _address) {
296         require(_address != address(this));
297         _;
298     }
299 
300 }
301 
302 // File: contracts/utility/SafeMath.sol
303 
304 /*
305     Library for basic math operations with overflow/underflow protection
306 */
307 library SafeMath {
308     /**
309         @dev returns the sum of _x and _y, reverts if the calculation overflows
310 
311         @param _x   value 1
312         @param _y   value 2
313 
314         @return sum
315     */
316     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
317         uint256 z = _x + _y;
318         require(z >= _x);
319         return z;
320     }
321 
322     /**
323         @dev returns the difference of _x minus _y, reverts if the calculation underflows
324 
325         @param _x   minuend
326         @param _y   subtrahend
327 
328         @return difference
329     */
330     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
331         require(_x >= _y);
332         return _x - _y;
333     }
334 
335     /**
336         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
337 
338         @param _x   factor 1
339         @param _y   factor 2
340 
341         @return product
342     */
343     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
344         // gas optimization
345         if (_x == 0)
346             return 0;
347 
348         uint256 z = _x * _y;
349         require(z / _x == _y);
350         return z;
351     }
352 
353       /**
354         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
355 
356         @param _x   dividend
357         @param _y   divisor
358 
359         @return quotient
360     */
361     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
362         require(_y > 0);
363         uint256 c = _x / _y;
364 
365         return c;
366     }
367 }
368 
369 // File: contracts/utility/interfaces/IContractRegistry.sol
370 
371 /*
372     Contract Registry interface
373 */
374 contract IContractRegistry {
375     function addressOf(bytes32 _contractName) public view returns (address);
376 
377     // deprecated, backward compatibility
378     function getAddress(bytes32 _contractName) public view returns (address);
379 }
380 
381 // File: contracts/utility/interfaces/IContractFeatures.sol
382 
383 /*
384     Contract Features interface
385 */
386 contract IContractFeatures {
387     function isSupported(address _contract, uint256 _features) public view returns (bool);
388     function enableFeatures(uint256 _features, bool _enable) public;
389 }
390 
391 // File: contracts/token/interfaces/ISmartToken.sol
392 
393 /*
394     Smart Token interface
395 */
396 contract ISmartToken is IOwned, IERC20Token {
397     function disableTransfers(bool _disable) public;
398     function issue(address _to, uint256 _amount) public;
399     function destroy(address _from, uint256 _amount) public;
400 }
401 
402 // File: contracts/utility/interfaces/ITokenHolder.sol
403 
404 /*
405     Token Holder interface
406 */
407 contract ITokenHolder is IOwned {
408     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
409 }
410 
411 // File: contracts/utility/TokenHolder.sol
412 
413 /*
414     We consider every contract to be a 'token holder' since it's currently not possible
415     for a contract to deny receiving tokens.
416 
417     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
418     the owner to send tokens that were sent to the contract by mistake back to their sender.
419 */
420 contract TokenHolder is ITokenHolder, Owned, Utils {
421     /**
422         @dev constructor
423     */
424     constructor() public {
425     }
426 
427     /**
428         @dev withdraws tokens held by the contract and sends them to an account
429         can only be called by the owner
430 
431         @param _token   ERC20 token contract address
432         @param _to      account to receive the new amount
433         @param _amount  amount to withdraw
434     */
435     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
436         public
437         ownerOnly
438         validAddress(_token)
439         validAddress(_to)
440         notThis(_to)
441     {
442         assert(_token.transfer(_to, _amount));
443     }
444 }
445 
446 // File: contracts/token/SmartTokenController.sol
447 
448 /*
449     The smart token controller is an upgradable part of the smart token that allows
450     more functionality as well as fixes for bugs/exploits.
451     Once it accepts ownership of the token, it becomes the token's sole controller
452     that can execute any of its functions.
453 
454     To upgrade the controller, ownership must be transferred to a new controller, along with
455     any relevant data.
456 
457     The smart token must be set on construction and cannot be changed afterwards.
458     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
459 
460     Note that the controller can transfer token ownership to a new controller that
461     doesn't allow executing any function on the token, for a trustless solution.
462     Doing that will also remove the owner's ability to upgrade the controller.
463 */
464 contract SmartTokenController is TokenHolder {
465     ISmartToken public token;   // smart token
466 
467     /**
468         @dev constructor
469     */
470     constructor(ISmartToken _token)
471         public
472         validAddress(_token)
473     {
474         token = _token;
475     }
476 
477     // ensures that the controller is the token's owner
478     modifier active() {
479         require(token.owner() == address(this));
480         _;
481     }
482 
483     // ensures that the controller is not the token's owner
484     modifier inactive() {
485         require(token.owner() != address(this));
486         _;
487     }
488 
489     /**
490         @dev allows transferring the token ownership
491         the new owner needs to accept the transfer
492         can only be called by the contract owner
493 
494         @param _newOwner    new token owner
495     */
496     function transferTokenOwnership(address _newOwner) public ownerOnly {
497         token.transferOwnership(_newOwner);
498     }
499 
500     /**
501         @dev used by a new owner to accept a token ownership transfer
502         can only be called by the contract owner
503     */
504     function acceptTokenOwnership() public ownerOnly {
505         token.acceptOwnership();
506     }
507 
508     /**
509         @dev disables/enables token transfers
510         can only be called by the contract owner
511 
512         @param _disable    true to disable transfers, false to enable them
513     */
514     function disableTokenTransfers(bool _disable) public ownerOnly {
515         token.disableTransfers(_disable);
516     }
517 
518     /**
519         @dev withdraws tokens held by the controller and sends them to an account
520         can only be called by the owner
521 
522         @param _token   ERC20 token contract address
523         @param _to      account to receive the new amount
524         @param _amount  amount to withdraw
525     */
526     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
527         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
528     }
529 }
530 
531 // File: contracts/token/interfaces/IEtherToken.sol
532 
533 /*
534     Ether Token interface
535 */
536 contract IEtherToken is ITokenHolder, IERC20Token {
537     function deposit() public payable;
538     function withdraw(uint256 _amount) public;
539     function withdrawTo(address _to, uint256 _amount) public;
540 }
541 
542 // File: contracts/bancorx/interfaces/IBancorX.sol
543 
544 contract IBancorX {
545     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
546     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
547 }
548 
549 // File: contracts/converter/BancorConverter.sol
550 
551 /*
552     Bancor Converter v12
553 
554     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
555 
556     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
557     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
558 
559     The converter is upgradable (just like any SmartTokenController).
560 
561     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
562              or with very small numbers because of precision loss
563 
564     Open issues:
565     - Front-running attacks are currently mitigated by the following mechanisms:
566         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
567         - gas price limit prevents users from having control over the order of execution
568         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
569       Other potential solutions might include a commit/reveal based schemes
570     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
571 */
572 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
573     using SafeMath for uint256;
574 
575     
576     uint32 private constant MAX_WEIGHT = 1000000;
577     uint64 private constant MAX_CONVERSION_FEE = 1000000;
578 
579     struct Connector {
580         uint256 virtualBalance;         // connector virtual balance
581         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
582         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
583         bool isSaleEnabled;             // is sale of the connector token enabled, can be set by the owner
584         bool isSet;                     // used to tell if the mapping element is defined
585     }
586 
587     uint16 public version = 12;
588     string public converterType = 'bancor';
589 
590     bool public allowRegistryUpdate = true;             // allows the owner to prevent/allow the registry to be updated
591     bool public claimTokensEnabled = false;             // allows BancorX contract to claim tokens without allowance (one transaction instread of two)
592     IContractRegistry public prevRegistry;              // address of previous registry as security mechanism
593     IContractRegistry public registry;                  // contract registry contract
594     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
595     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
596     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
597     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
598     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
599                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
600     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
601     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
602     IERC20Token[] private convertPath;
603 
604     // triggered when a conversion between two tokens occurs
605     event Conversion(
606         address indexed _fromToken,
607         address indexed _toToken,
608         address indexed _trader,
609         uint256 _amount,
610         uint256 _return,
611         int256 _conversionFee
612     );
613     // triggered after a conversion with new price data
614     event PriceDataUpdate(
615         address indexed _connectorToken,
616         uint256 _tokenSupply,
617         uint256 _connectorBalance,
618         uint32 _connectorWeight
619     );
620     // triggered when the conversion fee is updated
621     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
622 
623     // triggered when conversions are enabled/disabled
624     event ConversionsEnable(bool _conversionsEnabled);
625 
626     /**
627         @dev constructor
628 
629         @param  _token              smart token governed by the converter
630         @param  _registry           address of a contract registry contract
631         @param  _maxConversionFee   maximum conversion fee, represented in ppm
632         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
633         @param  _connectorWeight    optional, weight for the initial connector
634     */
635     constructor(
636         ISmartToken _token,
637         IContractRegistry _registry,
638         uint32 _maxConversionFee,
639         IERC20Token _connectorToken,
640         uint32 _connectorWeight
641     )
642         public
643         SmartTokenController(_token)
644         validAddress(_registry)
645         validMaxConversionFee(_maxConversionFee)
646     {
647         registry = _registry;
648         prevRegistry = _registry;
649         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
650 
651         // initialize supported features
652         if (features != address(0))
653             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
654 
655         maxConversionFee = _maxConversionFee;
656 
657         if (_connectorToken != address(0))
658             addConnector(_connectorToken, _connectorWeight, false);
659     }
660 
661     // validates a connector token address - verifies that the address belongs to one of the connector tokens
662     modifier validConnector(IERC20Token _address) {
663         require(connectors[_address].isSet);
664         _;
665     }
666 
667     // validates a token address - verifies that the address belongs to one of the convertible tokens
668     modifier validToken(IERC20Token _address) {
669         require(_address == token || connectors[_address].isSet);
670         _;
671     }
672 
673     // validates maximum conversion fee
674     modifier validMaxConversionFee(uint32 _conversionFee) {
675         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
676         _;
677     }
678 
679     // validates conversion fee
680     modifier validConversionFee(uint32 _conversionFee) {
681         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
682         _;
683     }
684 
685     // validates connector weight range
686     modifier validConnectorWeight(uint32 _weight) {
687         require(_weight > 0 && _weight <= MAX_WEIGHT);
688         _;
689     }
690 
691     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
692     modifier validConversionPath(IERC20Token[] _path) {
693         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
694         _;
695     }
696 
697     // allows execution only when the total weight is 100%
698     modifier maxTotalWeightOnly() {
699         require(totalConnectorWeight == MAX_WEIGHT);
700         _;
701     }
702 
703     // allows execution only when conversions aren't disabled
704     modifier conversionsAllowed {
705         assert(conversionsEnabled);
706         _;
707     }
708 
709     // allows execution by the BancorNetwork contract only
710     modifier bancorNetworkOnly {
711         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
712         require(msg.sender == address(bancorNetwork));
713         _;
714     }
715 
716     // allows execution by the converter upgrader contract only
717     modifier converterUpgraderOnly {
718         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
719         require(owner == converterUpgrader);
720         _;
721     }
722 
723     // allows execution only when claim tokens is enabled
724     modifier whenClaimTokensEnabled {
725         require(claimTokensEnabled);
726         _;
727     }
728 
729     /**
730         @dev sets the contract registry to whichever address the current registry is pointing to
731      */
732     function updateRegistry() public {
733         // require that upgrading is allowed or that the caller is the owner
734         require(allowRegistryUpdate || msg.sender == owner);
735 
736         // get the address of whichever registry the current registry is pointing to
737         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
738 
739         // if the new registry hasn't changed or is the zero address, revert
740         require(newRegistry != address(registry) && newRegistry != address(0));
741 
742         // set the previous registry as current registry and current registry as newRegistry
743         prevRegistry = registry;
744         registry = IContractRegistry(newRegistry);
745     }
746 
747     /**
748         @dev security mechanism allowing the converter owner to revert to the previous registry,
749         to be used in emergency scenario
750     */
751     function restoreRegistry() public ownerOrManagerOnly {
752         // set the registry as previous registry
753         registry = prevRegistry;
754 
755         // after a previous registry is restored, only the owner can allow future updates
756         allowRegistryUpdate = false;
757     }
758 
759     /**
760         @dev disables the registry update functionality
761         this is a safety mechanism in case of a emergency
762         can only be called by the manager or owner
763 
764         @param _disable    true to disable registry updates, false to re-enable them
765     */
766     function disableRegistryUpdate(bool _disable) public ownerOrManagerOnly {
767         allowRegistryUpdate = !_disable;
768     }
769 
770     /**
771         @dev disables/enables the claim tokens functionality
772 
773         @param _enable    true to enable claiming of tokens, false to disable
774      */
775     function enableClaimTokens(bool _enable) public ownerOnly {
776         claimTokensEnabled = _enable;
777     }
778 
779     /**
780         @dev returns the number of connector tokens defined
781 
782         @return number of connector tokens
783     */
784     function connectorTokenCount() public view returns (uint16) {
785         return uint16(connectorTokens.length);
786     }
787 
788     /**
789         @dev allows the owner to update & enable the conversion whitelist contract address
790         when set, only addresses that are whitelisted are actually allowed to use the converter
791         note that the whitelist check is actually done by the BancorNetwork contract
792 
793         @param _whitelist    address of a whitelist contract
794     */
795     function setConversionWhitelist(IWhitelist _whitelist)
796         public
797         ownerOnly
798         notThis(_whitelist)
799     {
800         conversionWhitelist = _whitelist;
801     }
802 
803     /**
804         @dev disables the entire conversion functionality
805         this is a safety mechanism in case of a emergency
806         can only be called by the manager
807 
808         @param _disable true to disable conversions, false to re-enable them
809     */
810     function disableConversions(bool _disable) public ownerOrManagerOnly {
811         if (conversionsEnabled == _disable) {
812             conversionsEnabled = !_disable;
813             emit ConversionsEnable(conversionsEnabled);
814         }
815     }
816 
817     /**
818         @dev allows transferring the token ownership
819         the new owner needs to accept the transfer
820         can only be called by the contract owner
821         note that token ownership can only be transferred while the owner is the converter upgrader contract
822 
823         @param _newOwner    new token owner
824     */
825     function transferTokenOwnership(address _newOwner)
826         public
827         ownerOnly
828         converterUpgraderOnly
829     {
830         super.transferTokenOwnership(_newOwner);
831     }
832 
833     /**
834         @dev updates the current conversion fee
835         can only be called by the manager
836 
837         @param _conversionFee new conversion fee, represented in ppm
838     */
839     function setConversionFee(uint32 _conversionFee)
840         public
841         ownerOrManagerOnly
842         validConversionFee(_conversionFee)
843     {
844         emit ConversionFeeUpdate(conversionFee, _conversionFee);
845         conversionFee = _conversionFee;
846     }
847 
848     /**
849         @dev given a return amount, returns the amount minus the conversion fee
850 
851         @param _amount      return amount
852         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
853 
854         @return return amount minus conversion fee
855     */
856     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
857         return _amount.mul((MAX_CONVERSION_FEE - conversionFee) ** _magnitude).div(MAX_CONVERSION_FEE ** _magnitude);
858     }
859 
860     /**
861         @dev withdraws tokens held by the converter and sends them to an account
862         can only be called by the owner
863         note that connector tokens can only be withdrawn by the owner while the converter is inactive
864         unless the owner is the converter upgrader contract
865 
866         @param _token   ERC20 token contract address
867         @param _to      account to receive the new amount
868         @param _amount  amount to withdraw
869     */
870     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
871         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
872 
873         // if the token is not a connector token, allow withdrawal
874         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
875         require(!connectors[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
876         super.withdrawTokens(_token, _to, _amount);
877     }
878 
879     /**
880         @dev allows the BancorX contract to claim BNT from any address (so that users
881         dont have to first give allowance when calling BancorX)
882 
883         @param _from      address to claim the BNT from
884         @param _amount    the amount to claim
885      */
886     function claimTokens(address _from, uint256 _amount) public whenClaimTokensEnabled {
887         address bancorX = registry.addressOf(ContractIds.BANCOR_X);
888 
889         // only the bancorX contract may call this method
890         require(msg.sender == bancorX);
891 
892         // destroy the tokens belonging to _from, and issue the same amount to bancorX contract
893         token.destroy(_from, _amount);
894         token.issue(msg.sender, _amount);
895     }
896 
897     /**
898         @dev upgrades the converter to the latest version
899         can only be called by the owner
900         note that the owner needs to call acceptOwnership/acceptManagement on the new converter after the upgrade
901     */
902     function upgrade() public ownerOnly {
903         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER));
904 
905         transferOwnership(converterUpgrader);
906         converterUpgrader.upgrade(version);
907         acceptOwnership();
908     }
909 
910     /**
911         @dev defines a new connector for the token
912         can only be called by the owner while the converter is inactive
913 
914         @param _token                  address of the connector token
915         @param _weight                 constant connector weight, represented in ppm, 1-1000000
916         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
917     */
918     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
919         public
920         ownerOnly
921         inactive
922         validAddress(_token)
923         notThis(_token)
924         validConnectorWeight(_weight)
925     {
926         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
927 
928         connectors[_token].virtualBalance = 0;
929         connectors[_token].weight = _weight;
930         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
931         connectors[_token].isSaleEnabled = true;
932         connectors[_token].isSet = true;
933         connectorTokens.push(_token);
934         totalConnectorWeight += _weight;
935     }
936 
937     /**
938         @dev updates one of the token connectors
939         can only be called by the owner
940 
941         @param _connectorToken         address of the connector token
942         @param _weight                 constant connector weight, represented in ppm, 1-1000000
943         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
944         @param _virtualBalance         new connector's virtual balance
945     */
946     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
947         public
948         ownerOnly
949         validConnector(_connectorToken)
950         validConnectorWeight(_weight)
951     {
952         Connector storage connector = connectors[_connectorToken];
953         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
954 
955         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
956         connector.weight = _weight;
957         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
958         connector.virtualBalance = _virtualBalance;
959     }
960 
961     /**
962         @dev disables converting from the given connector token in case the connector token got compromised
963         can only be called by the owner
964         note that converting to the token is still enabled regardless of this flag and it cannot be disabled by the owner
965 
966         @param _connectorToken  connector token contract address
967         @param _disable         true to disable the token, false to re-enable it
968     */
969     function disableConnectorSale(IERC20Token _connectorToken, bool _disable)
970         public
971         ownerOnly
972         validConnector(_connectorToken)
973     {
974         connectors[_connectorToken].isSaleEnabled = !_disable;
975     }
976 
977     /**
978         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
979 
980         @param _connectorToken  connector token contract address
981 
982         @return connector balance
983     */
984     function getConnectorBalance(IERC20Token _connectorToken)
985         public
986         view
987         validConnector(_connectorToken)
988         returns (uint256)
989     {
990         Connector storage connector = connectors[_connectorToken];
991         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
992     }
993 
994     /**
995         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
996 
997         @param _fromToken  ERC20 token to convert from
998         @param _toToken    ERC20 token to convert to
999         @param _amount     amount to convert, in fromToken
1000 
1001         @return expected conversion return amount and conversion fee
1002     */
1003     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
1004         require(_fromToken != _toToken); // validate input
1005 
1006         // conversion between the token and one of its connectors
1007         if (_toToken == token)
1008             return getPurchaseReturn(_fromToken, _amount);
1009         else if (_fromToken == token)
1010             return getSaleReturn(_toToken, _amount);
1011 
1012         // conversion between 2 connectors
1013         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
1014     }
1015 
1016     /**
1017         @dev returns the expected return for buying the token for a connector token
1018 
1019         @param _connectorToken  connector token contract address
1020         @param _depositAmount   amount to deposit (in the connector token)
1021 
1022         @return expected purchase return amount and conversion fee
1023     */
1024     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
1025         public
1026         view
1027         active
1028         validConnector(_connectorToken)
1029         returns (uint256, uint256)
1030     {
1031         Connector storage connector = connectors[_connectorToken];
1032         require(connector.isSaleEnabled); // validate input
1033 
1034         uint256 tokenSupply = token.totalSupply();
1035         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1036         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1037         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
1038         uint256 finalAmount = getFinalAmount(amount, 1);
1039 
1040         // return the amount minus the conversion fee and the conversion fee
1041         return (finalAmount, amount - finalAmount);
1042     }
1043 
1044     /**
1045         @dev returns the expected return for selling the token for one of its connector tokens
1046 
1047         @param _connectorToken  connector token contract address
1048         @param _sellAmount      amount to sell (in the smart token)
1049 
1050         @return expected sale return amount and conversion fee
1051     */
1052     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
1053         public
1054         view
1055         active
1056         validConnector(_connectorToken)
1057         returns (uint256, uint256)
1058     {
1059         Connector storage connector = connectors[_connectorToken];
1060         uint256 tokenSupply = token.totalSupply();
1061         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1062         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1063         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
1064         uint256 finalAmount = getFinalAmount(amount, 1);
1065 
1066         // return the amount minus the conversion fee and the conversion fee
1067         return (finalAmount, amount - finalAmount);
1068     }
1069 
1070     /**
1071         @dev returns the expected return for selling one of the connector tokens for another connector token
1072 
1073         @param _fromConnectorToken  contract address of the connector token to convert from
1074         @param _toConnectorToken    contract address of the connector token to convert to
1075         @param _sellAmount          amount to sell (in the from connector token)
1076 
1077         @return expected sale return amount and conversion fee (in the to connector token)
1078     */
1079     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
1080         public
1081         view
1082         active
1083         validConnector(_fromConnectorToken)
1084         validConnector(_toConnectorToken)
1085         returns (uint256, uint256)
1086     {
1087         Connector storage fromConnector = connectors[_fromConnectorToken];
1088         Connector storage toConnector = connectors[_toConnectorToken];
1089         require(fromConnector.isSaleEnabled); // validate input
1090 
1091         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1092         uint256 amount = formula.calculateCrossConnectorReturn(
1093             getConnectorBalance(_fromConnectorToken), 
1094             fromConnector.weight, 
1095             getConnectorBalance(_toConnectorToken), 
1096             toConnector.weight, 
1097             _sellAmount);
1098         uint256 finalAmount = getFinalAmount(amount, 2);
1099 
1100         // return the amount minus the conversion fee and the conversion fee
1101         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1102         return (finalAmount, amount - finalAmount);
1103     }
1104 
1105     /**
1106         @dev converts a specific amount of _fromToken to _toToken
1107 
1108         @param _fromToken  ERC20 token to convert from
1109         @param _toToken    ERC20 token to convert to
1110         @param _amount     amount to convert, in fromToken
1111         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1112 
1113         @return conversion return amount
1114     */
1115     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1116         public
1117         bancorNetworkOnly
1118         conversionsAllowed
1119         greaterThanZero(_minReturn)
1120         returns (uint256)
1121     {
1122         require(_fromToken != _toToken); // validate input
1123 
1124         // conversion between the token and one of its connectors
1125         if (_toToken == token)
1126             return buy(_fromToken, _amount, _minReturn);
1127         else if (_fromToken == token)
1128             return sell(_toToken, _amount, _minReturn);
1129 
1130         uint256 amount;
1131         uint256 feeAmount;
1132 
1133         // conversion between 2 connectors
1134         (amount, feeAmount) = getCrossConnectorReturn(_fromToken, _toToken, _amount);
1135         // ensure the trade gives something in return and meets the minimum requested amount
1136         require(amount != 0 && amount >= _minReturn);
1137 
1138         // update the source token virtual balance if relevant
1139         Connector storage fromConnector = connectors[_fromToken];
1140         if (fromConnector.isVirtualBalanceEnabled)
1141             fromConnector.virtualBalance = fromConnector.virtualBalance.add(_amount);
1142 
1143         // update the target token virtual balance if relevant
1144         Connector storage toConnector = connectors[_toToken];
1145         if (toConnector.isVirtualBalanceEnabled)
1146             toConnector.virtualBalance = toConnector.virtualBalance.sub(amount);
1147 
1148         // ensure that the trade won't deplete the connector balance
1149         uint256 toConnectorBalance = getConnectorBalance(_toToken);
1150         assert(amount < toConnectorBalance);
1151 
1152         // transfer funds from the caller in the from connector token
1153         assert(_fromToken.transferFrom(msg.sender, this, _amount));
1154         // transfer funds to the caller in the to connector token
1155         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1156         assert(_toToken.transfer(msg.sender, amount));
1157 
1158         // dispatch the conversion event
1159         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1160         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1161 
1162         // dispatch price data updates for the smart token / both connectors
1163         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
1164         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
1165         return amount;
1166     }
1167 
1168     /**
1169         @dev converts a specific amount of _fromToken to _toToken
1170 
1171         @param _fromToken  ERC20 token to convert from
1172         @param _toToken    ERC20 token to convert to
1173         @param _amount     amount to convert, in fromToken
1174         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1175 
1176         @return conversion return amount
1177     */
1178     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1179         convertPath = [_fromToken, token, _toToken];
1180         return quickConvert(convertPath, _amount, _minReturn);
1181     }
1182 
1183     /**
1184         @dev buys the token by depositing one of its connector tokens
1185 
1186         @param _connectorToken  connector token contract address
1187         @param _depositAmount   amount to deposit (in the connector token)
1188         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1189 
1190         @return buy return amount
1191     */
1192     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1193         uint256 amount;
1194         uint256 feeAmount;
1195         (amount, feeAmount) = getPurchaseReturn(_connectorToken, _depositAmount);
1196         // ensure the trade gives something in return and meets the minimum requested amount
1197         require(amount != 0 && amount >= _minReturn);
1198 
1199         // update virtual balance if relevant
1200         Connector storage connector = connectors[_connectorToken];
1201         if (connector.isVirtualBalanceEnabled)
1202             connector.virtualBalance = connector.virtualBalance.add(_depositAmount);
1203 
1204         // transfer funds from the caller in the connector token
1205         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
1206         // issue new funds to the caller in the smart token
1207         token.issue(msg.sender, amount);
1208 
1209         // dispatch the conversion event
1210         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
1211 
1212         // dispatch price data update for the smart token/connector
1213         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1214         return amount;
1215     }
1216 
1217     /**
1218         @dev sells the token by withdrawing from one of its connector tokens
1219 
1220         @param _connectorToken  connector token contract address
1221         @param _sellAmount      amount to sell (in the smart token)
1222         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1223 
1224         @return sell return amount
1225     */
1226     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1227         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1228         uint256 amount;
1229         uint256 feeAmount;
1230         (amount, feeAmount) = getSaleReturn(_connectorToken, _sellAmount);
1231         // ensure the trade gives something in return and meets the minimum requested amount
1232         require(amount != 0 && amount >= _minReturn);
1233 
1234         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1235         uint256 tokenSupply = token.totalSupply();
1236         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1237         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1238 
1239         // update virtual balance if relevant
1240         Connector storage connector = connectors[_connectorToken];
1241         if (connector.isVirtualBalanceEnabled)
1242             connector.virtualBalance = connector.virtualBalance.sub(amount);
1243 
1244         // destroy _sellAmount from the caller's balance in the smart token
1245         token.destroy(msg.sender, _sellAmount);
1246         // transfer funds to the caller in the connector token
1247         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1248         assert(_connectorToken.transfer(msg.sender, amount));
1249 
1250         // dispatch the conversion event
1251         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1252 
1253         // dispatch price data update for the smart token/connector
1254         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1255         return amount;
1256     }
1257 
1258     /**
1259         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1260         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1261 
1262         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1263         @param _amount      amount to convert from (in the initial source token)
1264         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1265 
1266         @return tokens issued in return
1267     */
1268     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1269         public
1270         payable
1271         returns (uint256)
1272     {
1273         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1274     }
1275 
1276     /**
1277         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1278         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1279 
1280         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1281         @param _amount      amount to convert from (in the initial source token)
1282         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1283         @param _block       if the current block exceeded the given parameter - it is cancelled
1284         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1285         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1286         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1287 
1288         @return tokens issued in return
1289     */
1290     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1291         public
1292         payable
1293         returns (uint256)
1294     {
1295         IERC20Token fromToken = _path[0];
1296         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1297 
1298         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1299         // so it can execute the conversion on behalf of the caller
1300         if (msg.value == 0) {
1301             // not ETH, send the source tokens to the BancorNetwork contract
1302             // if the token is the smart token, no allowance is required - destroy the tokens
1303             // from the caller and issue them to the BancorNetwork contract
1304             if (fromToken == token) {
1305                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1306                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1307             } else {
1308                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1309                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1310             }
1311         }
1312 
1313         // execute the conversion and pass on the ETH with the call
1314         return bancorNetwork.convertForPrioritized3.value(msg.value)(_path, _amount, _minReturn, msg.sender, _amount, _block, _v, _r, _s);
1315     }
1316 
1317     /**
1318         @dev allows a user to convert BNT that was sent from another blockchain into any other
1319         token on the BancorNetwork without specifying the amount of BNT to be converted, but
1320         rather by providing the xTransferId which allows us to get the amount from BancorX.
1321 
1322         @param _path             conversion path, see conversion path format in the BancorNetwork contract
1323         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1324         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
1325         @param _block            if the current block exceeded the given parameter - it is cancelled
1326         @param _v                (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1327         @param _r                (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1328         @param _s                (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1329 
1330         @return tokens issued in return
1331     */
1332     function completeXConversion(
1333         IERC20Token[] _path,
1334         uint256 _minReturn,
1335         uint256 _conversionId,
1336         uint256 _block,
1337         uint8 _v,
1338         bytes32 _r,
1339         bytes32 _s
1340     )
1341         public
1342         returns (uint256)
1343     {
1344         IBancorX bancorX = IBancorX(registry.addressOf(ContractIds.BANCOR_X));
1345         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1346 
1347         // verify that the first token in the path is BNT
1348         require(_path[0] == registry.addressOf(ContractIds.BNT_TOKEN));
1349 
1350         // get conversion amount from BancorX contract
1351         uint256 amount = bancorX.getXTransferAmount(_conversionId, msg.sender);
1352 
1353         // send BNT from msg.sender to the BancorNetwork contract
1354         token.destroy(msg.sender, amount);
1355         token.issue(bancorNetwork, amount);
1356 
1357         return bancorNetwork.convertForPrioritized3(_path, amount, _minReturn, msg.sender, _conversionId, _block, _v, _r, _s);
1358     }
1359 
1360     /**
1361         @dev buys the token with all connector tokens using the same percentage
1362         i.e. if the caller increases the supply by 10%, it will cost an amount equal to
1363         10% of each connector token balance
1364         can only be called if the max total weight is exactly 100% and while conversions are enabled
1365 
1366         @param _amount  amount to increase the supply by (in the smart token)
1367     */
1368     function fund(uint256 _amount)
1369         public
1370         maxTotalWeightOnly
1371         conversionsAllowed
1372     {
1373         uint256 supply = token.totalSupply();
1374 
1375         // iterate through the connector tokens and transfer a percentage equal to the ratio between _amount
1376         // and the total supply in each connector from the caller to the converter
1377         IERC20Token connectorToken;
1378         uint256 connectorBalance;
1379         uint256 connectorAmount;
1380         for (uint16 i = 0; i < connectorTokens.length; i++) {
1381             connectorToken = connectorTokens[i];
1382             connectorBalance = getConnectorBalance(connectorToken);
1383             connectorAmount = _amount.mul(connectorBalance).div(supply);
1384 
1385             // update virtual balance if relevant
1386             Connector storage connector = connectors[connectorToken];
1387             if (connector.isVirtualBalanceEnabled)
1388                 connector.virtualBalance = connector.virtualBalance.add(connectorAmount);
1389 
1390             // transfer funds from the caller in the connector token
1391             assert(connectorToken.transferFrom(msg.sender, this, connectorAmount));
1392 
1393             // dispatch price data update for the smart token/connector
1394             emit PriceDataUpdate(connectorToken, supply + _amount, connectorBalance + connectorAmount, connector.weight);
1395         }
1396 
1397         // issue new funds to the caller in the smart token
1398         token.issue(msg.sender, _amount);
1399     }
1400 
1401     /**
1402         @dev sells the token for all connector tokens using the same percentage
1403         i.e. if the holder sells 10% of the supply, they will receive 10% of each
1404         connector token balance in return
1405         can only be called if the max total weight is exactly 100%
1406         note that the function can also be called if conversions are disabled
1407 
1408         @param _amount  amount to liquidate (in the smart token)
1409     */
1410     function liquidate(uint256 _amount) public maxTotalWeightOnly {
1411         uint256 supply = token.totalSupply();
1412 
1413         // destroy _amount from the caller's balance in the smart token
1414         token.destroy(msg.sender, _amount);
1415 
1416         // iterate through the connector tokens and send a percentage equal to the ratio between _amount
1417         // and the total supply from each connector balance to the caller
1418         IERC20Token connectorToken;
1419         uint256 connectorBalance;
1420         uint256 connectorAmount;
1421         for (uint16 i = 0; i < connectorTokens.length; i++) {
1422             connectorToken = connectorTokens[i];
1423             connectorBalance = getConnectorBalance(connectorToken);
1424             connectorAmount = _amount.mul(connectorBalance).div(supply);
1425 
1426             // update virtual balance if relevant
1427             Connector storage connector = connectors[connectorToken];
1428             if (connector.isVirtualBalanceEnabled)
1429                 connector.virtualBalance = connector.virtualBalance.sub(connectorAmount);
1430 
1431             // transfer funds to the caller in the connector token
1432             // the transfer might fail if the actual connector balance is smaller than the virtual balance
1433             assert(connectorToken.transfer(msg.sender, connectorAmount));
1434 
1435             // dispatch price data update for the smart token/connector
1436             emit PriceDataUpdate(connectorToken, supply - _amount, connectorBalance - connectorAmount, connector.weight);
1437         }
1438     }
1439 
1440     // deprecated, backward compatibility
1441     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1442         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1443     }
1444 
1445     /**
1446         @dev helper, dispatches the Conversion event
1447 
1448         @param _fromToken       ERC20 token to convert from
1449         @param _toToken         ERC20 token to convert to
1450         @param _amount          amount purchased/sold (in the source token)
1451         @param _returnAmount    amount returned (in the target token)
1452     */
1453     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1454         // fee amount is converted to 255 bits -
1455         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1456         // currently the fee is always taken from the target token
1457         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1458         assert(_feeAmount <= 2 ** 255);
1459         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1460     }
1461 }