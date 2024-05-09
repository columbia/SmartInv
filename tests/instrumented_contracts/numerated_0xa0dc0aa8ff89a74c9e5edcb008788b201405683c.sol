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
55 }
56 
57 // File: contracts/converter/interfaces/IBancorFormula.sol
58 
59 /*
60     Bancor Formula interface
61 */
62 contract IBancorFormula {
63     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
64     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
65     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
66 }
67 
68 // File: contracts/IBancorNetwork.sol
69 
70 /*
71     Bancor Network interface
72 */
73 contract IBancorNetwork {
74     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
75     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
76     function convertForPrioritized2(
77         IERC20Token[] _path,
78         uint256 _amount,
79         uint256 _minReturn,
80         address _for,
81         uint256 _block,
82         uint8 _v,
83         bytes32 _r,
84         bytes32 _s)
85         public payable returns (uint256);
86 
87     // deprecated, backward compatibility
88     function convertForPrioritized(
89         IERC20Token[] _path,
90         uint256 _amount,
91         uint256 _minReturn,
92         address _for,
93         uint256 _block,
94         uint256 _nonce,
95         uint8 _v,
96         bytes32 _r,
97         bytes32 _s)
98         public payable returns (uint256);
99 }
100 
101 // File: contracts/ContractIds.sol
102 
103 /**
104     Id definitions for bancor contracts
105 
106     Can be used in conjunction with the contract registry to get contract addresses
107 */
108 contract ContractIds {
109     // generic
110     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
111     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
112 
113     // bancor logic
114     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
115     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
116     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
117     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
118     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
119 
120     // Ids of BNT converter and BNT token
121     bytes32 public constant BNT_TOKEN = "BNTToken";
122     bytes32 public constant BNT_CONVERTER = "BNTConverter";
123 
124     // Id of BancorX contract
125     bytes32 public constant BANCOR_X = "BancorX";
126 }
127 
128 // File: contracts/FeatureIds.sol
129 
130 /**
131     Id definitions for bancor contract features
132 
133     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
134 */
135 contract FeatureIds {
136     // converter features
137     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
138 }
139 
140 // File: contracts/utility/interfaces/IOwned.sol
141 
142 /*
143     Owned contract interface
144 */
145 contract IOwned {
146     // this function isn't abstract since the compiler emits automatically generated getter functions as external
147     function owner() public view returns (address) {}
148 
149     function transferOwnership(address _newOwner) public;
150     function acceptOwnership() public;
151 }
152 
153 // File: contracts/utility/Owned.sol
154 
155 /*
156     Provides support and utilities for contract ownership
157 */
158 contract Owned is IOwned {
159     address public owner;
160     address public newOwner;
161 
162     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
163 
164     /**
165         @dev constructor
166     */
167     constructor() public {
168         owner = msg.sender;
169     }
170 
171     // allows execution by the owner only
172     modifier ownerOnly {
173         require(msg.sender == owner);
174         _;
175     }
176 
177     /**
178         @dev allows transferring the contract ownership
179         the new owner still needs to accept the transfer
180         can only be called by the contract owner
181 
182         @param _newOwner    new contract owner
183     */
184     function transferOwnership(address _newOwner) public ownerOnly {
185         require(_newOwner != owner);
186         newOwner = _newOwner;
187     }
188 
189     /**
190         @dev used by a new owner to accept an ownership transfer
191     */
192     function acceptOwnership() public {
193         require(msg.sender == newOwner);
194         emit OwnerUpdate(owner, newOwner);
195         owner = newOwner;
196         newOwner = address(0);
197     }
198 }
199 
200 // File: contracts/utility/Managed.sol
201 
202 /*
203     Provides support and utilities for contract management
204     Note that a managed contract must also have an owner
205 */
206 contract Managed is Owned {
207     address public manager;
208     address public newManager;
209 
210     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
211 
212     /**
213         @dev constructor
214     */
215     constructor() public {
216         manager = msg.sender;
217     }
218 
219     // allows execution by the manager only
220     modifier managerOnly {
221         assert(msg.sender == manager);
222         _;
223     }
224 
225     // allows execution by either the owner or the manager only
226     modifier ownerOrManagerOnly {
227         require(msg.sender == owner || msg.sender == manager);
228         _;
229     }
230 
231     /**
232         @dev allows transferring the contract management
233         the new manager still needs to accept the transfer
234         can only be called by the contract manager
235 
236         @param _newManager    new contract manager
237     */
238     function transferManagement(address _newManager) public ownerOrManagerOnly {
239         require(_newManager != manager);
240         newManager = _newManager;
241     }
242 
243     /**
244         @dev used by a new manager to accept a management transfer
245     */
246     function acceptManagement() public {
247         require(msg.sender == newManager);
248         emit ManagerUpdate(manager, newManager);
249         manager = newManager;
250         newManager = address(0);
251     }
252 }
253 
254 // File: contracts/utility/Utils.sol
255 
256 /*
257     Utilities & Common Modifiers
258 */
259 contract Utils {
260     /**
261         constructor
262     */
263     constructor() public {
264     }
265 
266     // verifies that an amount is greater than zero
267     modifier greaterThanZero(uint256 _amount) {
268         require(_amount > 0);
269         _;
270     }
271 
272     // validates an address - currently only checks that it isn't null
273     modifier validAddress(address _address) {
274         require(_address != address(0));
275         _;
276     }
277 
278     // verifies that the address is different than this contract address
279     modifier notThis(address _address) {
280         require(_address != address(this));
281         _;
282     }
283 
284     // Overflow protected math functions
285 
286     /**
287         @dev returns the sum of _x and _y, asserts if the calculation overflows
288 
289         @param _x   value 1
290         @param _y   value 2
291 
292         @return sum
293     */
294     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
295         uint256 z = _x + _y;
296         assert(z >= _x);
297         return z;
298     }
299 
300     /**
301         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
302 
303         @param _x   minuend
304         @param _y   subtrahend
305 
306         @return difference
307     */
308     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
309         assert(_x >= _y);
310         return _x - _y;
311     }
312 
313     /**
314         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
315 
316         @param _x   factor 1
317         @param _y   factor 2
318 
319         @return product
320     */
321     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
322         uint256 z = _x * _y;
323         assert(_x == 0 || z / _x == _y);
324         return z;
325     }
326 }
327 
328 // File: contracts/utility/interfaces/IContractRegistry.sol
329 
330 /*
331     Contract Registry interface
332 */
333 contract IContractRegistry {
334     function addressOf(bytes32 _contractName) public view returns (address);
335 
336     // deprecated, backward compatibility
337     function getAddress(bytes32 _contractName) public view returns (address);
338 }
339 
340 // File: contracts/utility/interfaces/IContractFeatures.sol
341 
342 /*
343     Contract Features interface
344 */
345 contract IContractFeatures {
346     function isSupported(address _contract, uint256 _features) public view returns (bool);
347     function enableFeatures(uint256 _features, bool _enable) public;
348 }
349 
350 // File: contracts/token/interfaces/ISmartToken.sol
351 
352 /*
353     Smart Token interface
354 */
355 contract ISmartToken is IOwned, IERC20Token {
356     function disableTransfers(bool _disable) public;
357     function issue(address _to, uint256 _amount) public;
358     function destroy(address _from, uint256 _amount) public;
359 }
360 
361 // File: contracts/utility/interfaces/ITokenHolder.sol
362 
363 /*
364     Token Holder interface
365 */
366 contract ITokenHolder is IOwned {
367     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
368 }
369 
370 // File: contracts/utility/TokenHolder.sol
371 
372 /*
373     We consider every contract to be a 'token holder' since it's currently not possible
374     for a contract to deny receiving tokens.
375 
376     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
377     the owner to send tokens that were sent to the contract by mistake back to their sender.
378 */
379 contract TokenHolder is ITokenHolder, Owned, Utils {
380     /**
381         @dev constructor
382     */
383     constructor() public {
384     }
385 
386     /**
387         @dev withdraws tokens held by the contract and sends them to an account
388         can only be called by the owner
389 
390         @param _token   ERC20 token contract address
391         @param _to      account to receive the new amount
392         @param _amount  amount to withdraw
393     */
394     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
395         public
396         ownerOnly
397         validAddress(_token)
398         validAddress(_to)
399         notThis(_to)
400     {
401         assert(_token.transfer(_to, _amount));
402     }
403 }
404 
405 // File: contracts/token/SmartTokenController.sol
406 
407 /*
408     The smart token controller is an upgradable part of the smart token that allows
409     more functionality as well as fixes for bugs/exploits.
410     Once it accepts ownership of the token, it becomes the token's sole controller
411     that can execute any of its functions.
412 
413     To upgrade the controller, ownership must be transferred to a new controller, along with
414     any relevant data.
415 
416     The smart token must be set on construction and cannot be changed afterwards.
417     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
418 
419     Note that the controller can transfer token ownership to a new controller that
420     doesn't allow executing any function on the token, for a trustless solution.
421     Doing that will also remove the owner's ability to upgrade the controller.
422 */
423 contract SmartTokenController is TokenHolder {
424     ISmartToken public token;   // smart token
425 
426     /**
427         @dev constructor
428     */
429     constructor(ISmartToken _token)
430         public
431         validAddress(_token)
432     {
433         token = _token;
434     }
435 
436     // ensures that the controller is the token's owner
437     modifier active() {
438         require(token.owner() == address(this));
439         _;
440     }
441 
442     // ensures that the controller is not the token's owner
443     modifier inactive() {
444         require(token.owner() != address(this));
445         _;
446     }
447 
448     /**
449         @dev allows transferring the token ownership
450         the new owner needs to accept the transfer
451         can only be called by the contract owner
452 
453         @param _newOwner    new token owner
454     */
455     function transferTokenOwnership(address _newOwner) public ownerOnly {
456         token.transferOwnership(_newOwner);
457     }
458 
459     /**
460         @dev used by a new owner to accept a token ownership transfer
461         can only be called by the contract owner
462     */
463     function acceptTokenOwnership() public ownerOnly {
464         token.acceptOwnership();
465     }
466 
467     /**
468         @dev disables/enables token transfers
469         can only be called by the contract owner
470 
471         @param _disable    true to disable transfers, false to enable them
472     */
473     function disableTokenTransfers(bool _disable) public ownerOnly {
474         token.disableTransfers(_disable);
475     }
476 
477     /**
478         @dev withdraws tokens held by the controller and sends them to an account
479         can only be called by the owner
480 
481         @param _token   ERC20 token contract address
482         @param _to      account to receive the new amount
483         @param _amount  amount to withdraw
484     */
485     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
486         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
487     }
488 }
489 
490 // File: contracts/token/interfaces/IEtherToken.sol
491 
492 /*
493     Ether Token interface
494 */
495 contract IEtherToken is ITokenHolder, IERC20Token {
496     function deposit() public payable;
497     function withdraw(uint256 _amount) public;
498     function withdrawTo(address _to, uint256 _amount) public;
499 }
500 
501 // File: contracts/converter/BancorConverter.sol
502 
503 /*
504     Bancor Converter v0.11
505 
506     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
507 
508     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
509     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
510 
511     The converter is upgradable (just like any SmartTokenController).
512 
513     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
514              or with very small numbers because of precision loss
515 
516     Open issues:
517     - Front-running attacks are currently mitigated by the following mechanisms:
518         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
519         - gas price limit prevents users from having control over the order of execution
520         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
521       Other potential solutions might include a commit/reveal based schemes
522     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
523 */
524 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
525     uint32 private constant MAX_WEIGHT = 1000000;
526     uint64 private constant MAX_CONVERSION_FEE = 1000000;
527 
528     struct Connector {
529         uint256 virtualBalance;         // connector virtual balance
530         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
531         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
532         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
533         bool isSet;                     // used to tell if the mapping element is defined
534     }
535 
536     bytes32 public version = '0.11';
537     string public converterType = 'bancor';
538 
539     bool public allowRegistryUpdate = true;             // allows the owner to prevent/allow the registry to be updated
540     bool public claimTokensEnabled = false;             // allows BancorX contract to claim tokens without allowance (one transaction instread of two)
541     IContractRegistry public prevRegistry;              // address of previous registry as security mechanism
542     IContractRegistry public registry;                  // contract registry contract
543     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
544     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
545     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
546     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
547     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
548                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
549     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
550     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
551     IERC20Token[] private convertPath;
552 
553     // triggered when a conversion between two tokens occurs
554     event Conversion(
555         address indexed _fromToken,
556         address indexed _toToken,
557         address indexed _trader,
558         uint256 _amount,
559         uint256 _return,
560         int256 _conversionFee
561     );
562     // triggered after a conversion with new price data
563     event PriceDataUpdate(
564         address indexed _connectorToken,
565         uint256 _tokenSupply,
566         uint256 _connectorBalance,
567         uint32 _connectorWeight
568     );
569     // triggered when the conversion fee is updated
570     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
571 
572     // triggered when conversions are enabled/disabled
573     event ConversionsEnable(bool _conversionsEnabled);
574 
575     /**
576         @dev constructor
577 
578         @param  _token              smart token governed by the converter
579         @param  _registry           address of a contract registry contract
580         @param  _maxConversionFee   maximum conversion fee, represented in ppm
581         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
582         @param  _connectorWeight    optional, weight for the initial connector
583     */
584     constructor(
585         ISmartToken _token,
586         IContractRegistry _registry,
587         uint32 _maxConversionFee,
588         IERC20Token _connectorToken,
589         uint32 _connectorWeight
590     )
591         public
592         SmartTokenController(_token)
593         validAddress(_registry)
594         validMaxConversionFee(_maxConversionFee)
595     {
596         registry = _registry;
597         prevRegistry = _registry;
598         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
599 
600         // initialize supported features
601         if (features != address(0))
602             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
603 
604         maxConversionFee = _maxConversionFee;
605 
606         if (_connectorToken != address(0))
607             addConnector(_connectorToken, _connectorWeight, false);
608     }
609 
610     // validates a connector token address - verifies that the address belongs to one of the connector tokens
611     modifier validConnector(IERC20Token _address) {
612         require(connectors[_address].isSet);
613         _;
614     }
615 
616     // validates a token address - verifies that the address belongs to one of the convertible tokens
617     modifier validToken(IERC20Token _address) {
618         require(_address == token || connectors[_address].isSet);
619         _;
620     }
621 
622     // validates maximum conversion fee
623     modifier validMaxConversionFee(uint32 _conversionFee) {
624         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
625         _;
626     }
627 
628     // validates conversion fee
629     modifier validConversionFee(uint32 _conversionFee) {
630         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
631         _;
632     }
633 
634     // validates connector weight range
635     modifier validConnectorWeight(uint32 _weight) {
636         require(_weight > 0 && _weight <= MAX_WEIGHT);
637         _;
638     }
639 
640     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
641     modifier validConversionPath(IERC20Token[] _path) {
642         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
643         _;
644     }
645 
646     // allows execution only when the total weight is 100%
647     modifier maxTotalWeightOnly() {
648         require(totalConnectorWeight == MAX_WEIGHT);
649         _;
650     }
651 
652     // allows execution only when conversions aren't disabled
653     modifier conversionsAllowed {
654         assert(conversionsEnabled);
655         _;
656     }
657 
658     // allows execution by the BancorNetwork contract only
659     modifier bancorNetworkOnly {
660         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
661         require(msg.sender == address(bancorNetwork));
662         _;
663     }
664 
665     // allows execution by the converter upgrader contract only
666     modifier converterUpgraderOnly {
667         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
668         require(owner == converterUpgrader);
669         _;
670     }
671 
672     // allows execution only when claim tokens is enabled
673     modifier whenClaimTokensEnabled {
674         require(claimTokensEnabled);
675         _;
676     }
677 
678     /**
679         @dev sets the contract registry to whichever address the current registry is pointing to
680      */
681     function updateRegistry() public {
682         // require that upgrading is allowed or that the caller is the owner
683         require(allowRegistryUpdate || msg.sender == owner);
684 
685         // get the address of whichever registry the current registry is pointing to
686         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
687 
688         // if the new registry hasn't changed or is the zero address, revert
689         require(newRegistry != address(registry) && newRegistry != address(0));
690 
691         // set the previous registry as current registry and current registry as newRegistry
692         prevRegistry = registry;
693         registry = IContractRegistry(newRegistry);
694     }
695 
696     /**
697         @dev security mechanism allowing the converter owner to revert to the previous registry,
698         to be used in emergency scenario
699     */
700     function restoreRegistry() public ownerOrManagerOnly {
701         // set the registry as previous registry
702         registry = prevRegistry;
703 
704         // after a previous registry is restored, only the owner can allow future updates
705         allowRegistryUpdate = false;
706     }
707 
708     /**
709         @dev disables the registry update functionality
710         this is a safety mechanism in case of a emergency
711         can only be called by the manager or owner
712 
713         @param _disable    true to disable registry updates, false to re-enable them
714     */
715     function disableRegistryUpdate(bool _disable) public ownerOrManagerOnly {
716         allowRegistryUpdate = !_disable;
717     }
718 
719     /**
720         @dev disables/enables the claim tokens functionality
721 
722         @param _enable    true to enable claiming of tokens, false to disable
723      */
724     function enableClaimTokens(bool _enable) public ownerOnly {
725         claimTokensEnabled = _enable;
726     }
727 
728     /**
729         @dev returns the number of connector tokens defined
730 
731         @return number of connector tokens
732     */
733     function connectorTokenCount() public view returns (uint16) {
734         return uint16(connectorTokens.length);
735     }
736 
737     /**
738         @dev allows the owner to update & enable the conversion whitelist contract address
739         when set, only addresses that are whitelisted are actually allowed to use the converter
740         note that the whitelist check is actually done by the BancorNetwork contract
741 
742         @param _whitelist    address of a whitelist contract
743     */
744     function setConversionWhitelist(IWhitelist _whitelist)
745         public
746         ownerOnly
747         notThis(_whitelist)
748     {
749         conversionWhitelist = _whitelist;
750     }
751 
752     /**
753         @dev disables the entire conversion functionality
754         this is a safety mechanism in case of a emergency
755         can only be called by the manager
756 
757         @param _disable true to disable conversions, false to re-enable them
758     */
759     function disableConversions(bool _disable) public ownerOrManagerOnly {
760         if (conversionsEnabled == _disable) {
761             conversionsEnabled = !_disable;
762             emit ConversionsEnable(conversionsEnabled);
763         }
764     }
765 
766     /**
767         @dev allows transferring the token ownership
768         the new owner needs to accept the transfer
769         can only be called by the contract owner
770         note that token ownership can only be transferred while the owner is the converter upgrader contract
771 
772         @param _newOwner    new token owner
773     */
774     function transferTokenOwnership(address _newOwner)
775         public
776         ownerOnly
777         converterUpgraderOnly
778     {
779         super.transferTokenOwnership(_newOwner);
780     }
781 
782     /**
783         @dev updates the current conversion fee
784         can only be called by the manager
785 
786         @param _conversionFee new conversion fee, represented in ppm
787     */
788     function setConversionFee(uint32 _conversionFee)
789         public
790         ownerOrManagerOnly
791         validConversionFee(_conversionFee)
792     {
793         emit ConversionFeeUpdate(conversionFee, _conversionFee);
794         conversionFee = _conversionFee;
795     }
796 
797     /**
798         @dev given a return amount, returns the amount minus the conversion fee
799 
800         @param _amount      return amount
801         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
802 
803         @return return amount minus conversion fee
804     */
805     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
806         return safeMul(_amount, (MAX_CONVERSION_FEE - conversionFee) ** _magnitude) / MAX_CONVERSION_FEE ** _magnitude;
807     }
808 
809     /**
810         @dev withdraws tokens held by the converter and sends them to an account
811         can only be called by the owner
812         note that connector tokens can only be withdrawn by the owner while the converter is inactive
813         unless the owner is the converter upgrader contract
814 
815         @param _token   ERC20 token contract address
816         @param _to      account to receive the new amount
817         @param _amount  amount to withdraw
818     */
819     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
820         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
821 
822         // if the token is not a connector token, allow withdrawal
823         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
824         require(!connectors[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
825         super.withdrawTokens(_token, _to, _amount);
826     }
827 
828     /**
829         @dev allows the BancorX contract to claim BNT from any address (so that users
830         dont have to first give allowance when calling BancorX)
831 
832         @param _from      address to claim the BNT from
833         @param _amount    the amount to claim
834      */
835     function claimTokens(address _from, uint256 _amount) public whenClaimTokensEnabled {
836         address bancorX = registry.addressOf(ContractIds.BANCOR_X);
837 
838         // only the bancorX contract may call this method
839         require(msg.sender == bancorX);
840 
841         // destroy the tokens belonging to _from, and issue the same amount to bancorX contract
842         token.destroy(_from, _amount);
843         token.issue(bancorX, _amount);
844     }
845 
846     /**
847         @dev upgrades the converter to the latest version
848         can only be called by the owner
849         note that the owner needs to call acceptOwnership on the new converter after the upgrade
850     */
851     function upgrade() public ownerOnly {
852         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER));
853 
854         transferOwnership(converterUpgrader);
855         converterUpgrader.upgrade(version);
856         acceptOwnership();
857     }
858 
859     /**
860         @dev defines a new connector for the token
861         can only be called by the owner while the converter is inactive
862 
863         @param _token                  address of the connector token
864         @param _weight                 constant connector weight, represented in ppm, 1-1000000
865         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
866     */
867     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
868         public
869         ownerOnly
870         inactive
871         validAddress(_token)
872         notThis(_token)
873         validConnectorWeight(_weight)
874     {
875         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
876 
877         connectors[_token].virtualBalance = 0;
878         connectors[_token].weight = _weight;
879         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
880         connectors[_token].isPurchaseEnabled = true;
881         connectors[_token].isSet = true;
882         connectorTokens.push(_token);
883         totalConnectorWeight += _weight;
884     }
885 
886     /**
887         @dev updates one of the token connectors
888         can only be called by the owner
889 
890         @param _connectorToken         address of the connector token
891         @param _weight                 constant connector weight, represented in ppm, 1-1000000
892         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
893         @param _virtualBalance         new connector's virtual balance
894     */
895     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
896         public
897         ownerOnly
898         validConnector(_connectorToken)
899         validConnectorWeight(_weight)
900     {
901         Connector storage connector = connectors[_connectorToken];
902         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
903 
904         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
905         connector.weight = _weight;
906         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
907         connector.virtualBalance = _virtualBalance;
908     }
909 
910     /**
911         @dev disables purchasing with the given connector token in case the connector token got compromised
912         can only be called by the owner
913         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
914 
915         @param _connectorToken  connector token contract address
916         @param _disable         true to disable the token, false to re-enable it
917     */
918     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
919         public
920         ownerOnly
921         validConnector(_connectorToken)
922     {
923         connectors[_connectorToken].isPurchaseEnabled = !_disable;
924     }
925 
926     /**
927         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
928 
929         @param _connectorToken  connector token contract address
930 
931         @return connector balance
932     */
933     function getConnectorBalance(IERC20Token _connectorToken)
934         public
935         view
936         validConnector(_connectorToken)
937         returns (uint256)
938     {
939         Connector storage connector = connectors[_connectorToken];
940         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
941     }
942 
943     /**
944         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
945 
946         @param _fromToken  ERC20 token to convert from
947         @param _toToken    ERC20 token to convert to
948         @param _amount     amount to convert, in fromToken
949 
950         @return expected conversion return amount and conversion fee
951     */
952     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
953         require(_fromToken != _toToken); // validate input
954 
955         // conversion between the token and one of its connectors
956         if (_toToken == token)
957             return getPurchaseReturn(_fromToken, _amount);
958         else if (_fromToken == token)
959             return getSaleReturn(_toToken, _amount);
960 
961         // conversion between 2 connectors
962         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
963     }
964 
965     /**
966         @dev returns the expected return for buying the token for a connector token
967 
968         @param _connectorToken  connector token contract address
969         @param _depositAmount   amount to deposit (in the connector token)
970 
971         @return expected purchase return amount and conversion fee
972     */
973     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
974         public
975         view
976         active
977         validConnector(_connectorToken)
978         returns (uint256, uint256)
979     {
980         Connector storage connector = connectors[_connectorToken];
981         require(connector.isPurchaseEnabled); // validate input
982 
983         uint256 tokenSupply = token.totalSupply();
984         uint256 connectorBalance = getConnectorBalance(_connectorToken);
985         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
986         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
987         uint256 finalAmount = getFinalAmount(amount, 1);
988 
989         // return the amount minus the conversion fee and the conversion fee
990         return (finalAmount, amount - finalAmount);
991     }
992 
993     /**
994         @dev returns the expected return for selling the token for one of its connector tokens
995 
996         @param _connectorToken  connector token contract address
997         @param _sellAmount      amount to sell (in the smart token)
998 
999         @return expected sale return amount and conversion fee
1000     */
1001     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
1002         public
1003         view
1004         active
1005         validConnector(_connectorToken)
1006         returns (uint256, uint256)
1007     {
1008         Connector storage connector = connectors[_connectorToken];
1009         uint256 tokenSupply = token.totalSupply();
1010         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1011         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1012         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
1013         uint256 finalAmount = getFinalAmount(amount, 1);
1014 
1015         // return the amount minus the conversion fee and the conversion fee
1016         return (finalAmount, amount - finalAmount);
1017     }
1018 
1019     /**
1020         @dev returns the expected return for selling one of the connector tokens for another connector token
1021 
1022         @param _fromConnectorToken  contract address of the connector token to convert from
1023         @param _toConnectorToken    contract address of the connector token to convert to
1024         @param _sellAmount          amount to sell (in the from connector token)
1025 
1026         @return expected sale return amount and conversion fee (in the to connector token)
1027     */
1028     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
1029         public
1030         view
1031         active
1032         validConnector(_fromConnectorToken)
1033         validConnector(_toConnectorToken)
1034         returns (uint256, uint256)
1035     {
1036         Connector storage fromConnector = connectors[_fromConnectorToken];
1037         Connector storage toConnector = connectors[_toConnectorToken];
1038         require(toConnector.isPurchaseEnabled); // validate input
1039 
1040         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1041         uint256 amount = formula.calculateCrossConnectorReturn(
1042             getConnectorBalance(_fromConnectorToken), 
1043             fromConnector.weight, 
1044             getConnectorBalance(_toConnectorToken), 
1045             toConnector.weight, 
1046             _sellAmount);
1047         uint256 finalAmount = getFinalAmount(amount, 2);
1048 
1049         // return the amount minus the conversion fee and the conversion fee
1050         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1051         return (finalAmount, amount - finalAmount);
1052     }
1053 
1054     /**
1055         @dev converts a specific amount of _fromToken to _toToken
1056 
1057         @param _fromToken  ERC20 token to convert from
1058         @param _toToken    ERC20 token to convert to
1059         @param _amount     amount to convert, in fromToken
1060         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1061 
1062         @return conversion return amount
1063     */
1064     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1065         public
1066         bancorNetworkOnly
1067         conversionsAllowed
1068         greaterThanZero(_minReturn)
1069         returns (uint256)
1070     {
1071         require(_fromToken != _toToken); // validate input
1072 
1073         // conversion between the token and one of its connectors
1074         if (_toToken == token)
1075             return buy(_fromToken, _amount, _minReturn);
1076         else if (_fromToken == token)
1077             return sell(_toToken, _amount, _minReturn);
1078 
1079         uint256 amount;
1080         uint256 feeAmount;
1081 
1082         // conversion between 2 connectors
1083         (amount, feeAmount) = getCrossConnectorReturn(_fromToken, _toToken, _amount);
1084         // ensure the trade gives something in return and meets the minimum requested amount
1085         require(amount != 0 && amount >= _minReturn);
1086 
1087         // update the source token virtual balance if relevant
1088         Connector storage fromConnector = connectors[_fromToken];
1089         if (fromConnector.isVirtualBalanceEnabled)
1090             fromConnector.virtualBalance = safeAdd(fromConnector.virtualBalance, _amount);
1091 
1092         // update the target token virtual balance if relevant
1093         Connector storage toConnector = connectors[_toToken];
1094         if (toConnector.isVirtualBalanceEnabled)
1095             toConnector.virtualBalance = safeSub(toConnector.virtualBalance, amount);
1096 
1097         // ensure that the trade won't deplete the connector balance
1098         uint256 toConnectorBalance = getConnectorBalance(_toToken);
1099         assert(amount < toConnectorBalance);
1100 
1101         // transfer funds from the caller in the from connector token
1102         assert(_fromToken.transferFrom(msg.sender, this, _amount));
1103         // transfer funds to the caller in the to connector token
1104         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1105         assert(_toToken.transfer(msg.sender, amount));
1106 
1107         // dispatch the conversion event
1108         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1109         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1110 
1111         // dispatch price data updates for the smart token / both connectors
1112         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
1113         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
1114         return amount;
1115     }
1116 
1117     /**
1118         @dev converts a specific amount of _fromToken to _toToken
1119 
1120         @param _fromToken  ERC20 token to convert from
1121         @param _toToken    ERC20 token to convert to
1122         @param _amount     amount to convert, in fromToken
1123         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1124 
1125         @return conversion return amount
1126     */
1127     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1128         convertPath = [_fromToken, token, _toToken];
1129         return quickConvert(convertPath, _amount, _minReturn);
1130     }
1131 
1132     /**
1133         @dev buys the token by depositing one of its connector tokens
1134 
1135         @param _connectorToken  connector token contract address
1136         @param _depositAmount   amount to deposit (in the connector token)
1137         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1138 
1139         @return buy return amount
1140     */
1141     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1142         uint256 amount;
1143         uint256 feeAmount;
1144         (amount, feeAmount) = getPurchaseReturn(_connectorToken, _depositAmount);
1145         // ensure the trade gives something in return and meets the minimum requested amount
1146         require(amount != 0 && amount >= _minReturn);
1147 
1148         // update virtual balance if relevant
1149         Connector storage connector = connectors[_connectorToken];
1150         if (connector.isVirtualBalanceEnabled)
1151             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
1152 
1153         // transfer funds from the caller in the connector token
1154         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
1155         // issue new funds to the caller in the smart token
1156         token.issue(msg.sender, amount);
1157 
1158         // dispatch the conversion event
1159         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
1160 
1161         // dispatch price data update for the smart token/connector
1162         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1163         return amount;
1164     }
1165 
1166     /**
1167         @dev sells the token by withdrawing from one of its connector tokens
1168 
1169         @param _connectorToken  connector token contract address
1170         @param _sellAmount      amount to sell (in the smart token)
1171         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1172 
1173         @return sell return amount
1174     */
1175     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1176         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1177         uint256 amount;
1178         uint256 feeAmount;
1179         (amount, feeAmount) = getSaleReturn(_connectorToken, _sellAmount);
1180         // ensure the trade gives something in return and meets the minimum requested amount
1181         require(amount != 0 && amount >= _minReturn);
1182 
1183         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1184         uint256 tokenSupply = token.totalSupply();
1185         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1186         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1187 
1188         // update virtual balance if relevant
1189         Connector storage connector = connectors[_connectorToken];
1190         if (connector.isVirtualBalanceEnabled)
1191             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1192 
1193         // destroy _sellAmount from the caller's balance in the smart token
1194         token.destroy(msg.sender, _sellAmount);
1195         // transfer funds to the caller in the connector token
1196         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1197         assert(_connectorToken.transfer(msg.sender, amount));
1198 
1199         // dispatch the conversion event
1200         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1201 
1202         // dispatch price data update for the smart token/connector
1203         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1204         return amount;
1205     }
1206 
1207     /**
1208         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1209         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1210 
1211         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1212         @param _amount      amount to convert from (in the initial source token)
1213         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1214 
1215         @return tokens issued in return
1216     */
1217     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1218         public
1219         payable
1220         validConversionPath(_path)
1221         returns (uint256)
1222     {
1223         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1224     }
1225 
1226     /**
1227         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1228         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1229 
1230         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1231         @param _amount      amount to convert from (in the initial source token)
1232         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1233         @param _block       if the current block exceeded the given parameter - it is cancelled
1234         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1235         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1236         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1237 
1238         @return tokens issued in return
1239     */
1240     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1241         public
1242         payable
1243         validConversionPath(_path)
1244         returns (uint256)
1245     {
1246         IERC20Token fromToken = _path[0];
1247         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1248 
1249         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1250         // so it can execute the conversion on behalf of the caller
1251         if (msg.value == 0) {
1252             // not ETH, send the source tokens to the BancorNetwork contract
1253             // if the token is the smart token, no allowance is required - destroy the tokens
1254             // from the caller and issue them to the BancorNetwork contract
1255             if (fromToken == token) {
1256                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1257                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1258             } else {
1259                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1260                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1261             }
1262         }
1263 
1264         // execute the conversion and pass on the ETH with the call
1265         return bancorNetwork.convertForPrioritized2.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _v, _r, _s);
1266     }
1267 
1268     /**
1269         @dev buys the token with all connector tokens using the same percentage
1270         i.e. if the caller increases the supply by 10%, it will cost an amount equal to
1271         10% of each connector token balance
1272         can only be called if the max total weight is exactly 100% and while conversions are enabled
1273 
1274         @param _amount  amount to increase the supply by (in the smart token)
1275     */
1276     function fund(uint256 _amount)
1277         public
1278         maxTotalWeightOnly
1279         conversionsAllowed
1280     {
1281         uint256 supply = token.totalSupply();
1282 
1283         // iterate through the connector tokens and transfer a percentage equal to the ratio between _amount
1284         // and the total supply in each connector from the caller to the converter
1285         IERC20Token connectorToken;
1286         uint256 connectorBalance;
1287         uint256 connectorAmount;
1288         for (uint16 i = 0; i < connectorTokens.length; i++) {
1289             connectorToken = connectorTokens[i];
1290             connectorBalance = getConnectorBalance(connectorToken);
1291             connectorAmount = safeMul(_amount, connectorBalance) / supply;
1292 
1293             // update virtual balance if relevant
1294             Connector storage connector = connectors[connectorToken];
1295             if (connector.isVirtualBalanceEnabled)
1296                 connector.virtualBalance = safeAdd(connector.virtualBalance, connectorAmount);
1297 
1298             // transfer funds from the caller in the connector token
1299             assert(connectorToken.transferFrom(msg.sender, this, connectorAmount));
1300 
1301             // dispatch price data update for the smart token/connector
1302             emit PriceDataUpdate(connectorToken, supply + _amount, connectorBalance + connectorAmount, connector.weight);
1303         }
1304 
1305         // issue new funds to the caller in the smart token
1306         token.issue(msg.sender, _amount);
1307     }
1308 
1309     /**
1310         @dev sells the token for all connector tokens using the same percentage
1311         i.e. if the holder sells 10% of the supply, they will receive 10% of each
1312         connector token balance in return
1313         can only be called if the max total weight is exactly 100%
1314         note that the function can also be called if conversions are disabled
1315 
1316         @param _amount  amount to liquidate (in the smart token)
1317     */
1318     function liquidate(uint256 _amount) public maxTotalWeightOnly {
1319         uint256 supply = token.totalSupply();
1320 
1321         // destroy _amount from the caller's balance in the smart token
1322         token.destroy(msg.sender, _amount);
1323 
1324         // iterate through the connector tokens and send a percentage equal to the ratio between _amount
1325         // and the total supply from each connector balance to the caller
1326         IERC20Token connectorToken;
1327         uint256 connectorBalance;
1328         uint256 connectorAmount;
1329         for (uint16 i = 0; i < connectorTokens.length; i++) {
1330             connectorToken = connectorTokens[i];
1331             connectorBalance = getConnectorBalance(connectorToken);
1332             connectorAmount = safeMul(_amount, connectorBalance) / supply;
1333 
1334             // update virtual balance if relevant
1335             Connector storage connector = connectors[connectorToken];
1336             if (connector.isVirtualBalanceEnabled)
1337                 connector.virtualBalance = safeSub(connector.virtualBalance, connectorAmount);
1338 
1339             // transfer funds to the caller in the connector token
1340             // the transfer might fail if the actual connector balance is smaller than the virtual balance
1341             assert(connectorToken.transfer(msg.sender, connectorAmount));
1342 
1343             // dispatch price data update for the smart token/connector
1344             emit PriceDataUpdate(connectorToken, supply - _amount, connectorBalance - connectorAmount, connector.weight);
1345         }
1346     }
1347 
1348     // deprecated, backward compatibility
1349     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1350         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1351     }
1352 
1353     /**
1354         @dev helper, dispatches the Conversion event
1355 
1356         @param _fromToken       ERC20 token to convert from
1357         @param _toToken         ERC20 token to convert to
1358         @param _amount          amount purchased/sold (in the source token)
1359         @param _returnAmount    amount returned (in the target token)
1360     */
1361     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1362         // fee amount is converted to 255 bits -
1363         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1364         // currently the fee is always taken from the target token
1365         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1366         assert(_feeAmount <= 2 ** 255);
1367         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1368     }
1369 }