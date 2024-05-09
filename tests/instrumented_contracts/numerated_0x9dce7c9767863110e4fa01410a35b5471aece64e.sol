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
127     bytes32 public constant NON_STANDARD_TOKEN_REGISTRY = "NonStandardTokenRegistry";
128 
129     // bancor logic
130     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
131     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
132     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
133     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
134     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
135 
136     // BNT core
137     bytes32 public constant BNT_TOKEN = "BNTToken";
138     bytes32 public constant BNT_CONVERTER = "BNTConverter";
139 
140     // BancorX
141     bytes32 public constant BANCOR_X = "BancorX";
142     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
143 }
144 
145 // File: contracts/FeatureIds.sol
146 
147 /**
148     Id definitions for bancor contract features
149 
150     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
151 */
152 contract FeatureIds {
153     // converter features
154     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
155 }
156 
157 // File: contracts/utility/interfaces/IOwned.sol
158 
159 /*
160     Owned contract interface
161 */
162 contract IOwned {
163     // this function isn't abstract since the compiler emits automatically generated getter functions as external
164     function owner() public view returns (address) {}
165 
166     function transferOwnership(address _newOwner) public;
167     function acceptOwnership() public;
168 }
169 
170 // File: contracts/utility/Owned.sol
171 
172 /*
173     Provides support and utilities for contract ownership
174 */
175 contract Owned is IOwned {
176     address public owner;
177     address public newOwner;
178 
179     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
180 
181     /**
182         @dev constructor
183     */
184     constructor() public {
185         owner = msg.sender;
186     }
187 
188     // allows execution by the owner only
189     modifier ownerOnly {
190         require(msg.sender == owner);
191         _;
192     }
193 
194     /**
195         @dev allows transferring the contract ownership
196         the new owner still needs to accept the transfer
197         can only be called by the contract owner
198 
199         @param _newOwner    new contract owner
200     */
201     function transferOwnership(address _newOwner) public ownerOnly {
202         require(_newOwner != owner);
203         newOwner = _newOwner;
204     }
205 
206     /**
207         @dev used by a new owner to accept an ownership transfer
208     */
209     function acceptOwnership() public {
210         require(msg.sender == newOwner);
211         emit OwnerUpdate(owner, newOwner);
212         owner = newOwner;
213         newOwner = address(0);
214     }
215 }
216 
217 // File: contracts/utility/Managed.sol
218 
219 /*
220     Provides support and utilities for contract management
221     Note that a managed contract must also have an owner
222 */
223 contract Managed is Owned {
224     address public manager;
225     address public newManager;
226 
227     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
228 
229     /**
230         @dev constructor
231     */
232     constructor() public {
233         manager = msg.sender;
234     }
235 
236     // allows execution by the manager only
237     modifier managerOnly {
238         assert(msg.sender == manager);
239         _;
240     }
241 
242     // allows execution by either the owner or the manager only
243     modifier ownerOrManagerOnly {
244         require(msg.sender == owner || msg.sender == manager);
245         _;
246     }
247 
248     /**
249         @dev allows transferring the contract management
250         the new manager still needs to accept the transfer
251         can only be called by the contract manager
252 
253         @param _newManager    new contract manager
254     */
255     function transferManagement(address _newManager) public ownerOrManagerOnly {
256         require(_newManager != manager);
257         newManager = _newManager;
258     }
259 
260     /**
261         @dev used by a new manager to accept a management transfer
262     */
263     function acceptManagement() public {
264         require(msg.sender == newManager);
265         emit ManagerUpdate(manager, newManager);
266         manager = newManager;
267         newManager = address(0);
268     }
269 }
270 
271 // File: contracts/utility/Utils.sol
272 
273 /*
274     Utilities & Common Modifiers
275 */
276 contract Utils {
277     /**
278         constructor
279     */
280     constructor() public {
281     }
282 
283     // verifies that an amount is greater than zero
284     modifier greaterThanZero(uint256 _amount) {
285         require(_amount > 0);
286         _;
287     }
288 
289     // validates an address - currently only checks that it isn't null
290     modifier validAddress(address _address) {
291         require(_address != address(0));
292         _;
293     }
294 
295     // verifies that the address is different than this contract address
296     modifier notThis(address _address) {
297         require(_address != address(this));
298         _;
299     }
300 
301 }
302 
303 // File: contracts/utility/SafeMath.sol
304 
305 /*
306     Library for basic math operations with overflow/underflow protection
307 */
308 library SafeMath {
309     /**
310         @dev returns the sum of _x and _y, reverts if the calculation overflows
311 
312         @param _x   value 1
313         @param _y   value 2
314 
315         @return sum
316     */
317     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
318         uint256 z = _x + _y;
319         require(z >= _x);
320         return z;
321     }
322 
323     /**
324         @dev returns the difference of _x minus _y, reverts if the calculation underflows
325 
326         @param _x   minuend
327         @param _y   subtrahend
328 
329         @return difference
330     */
331     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
332         require(_x >= _y);
333         return _x - _y;
334     }
335 
336     /**
337         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
338 
339         @param _x   factor 1
340         @param _y   factor 2
341 
342         @return product
343     */
344     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
345         // gas optimization
346         if (_x == 0)
347             return 0;
348 
349         uint256 z = _x * _y;
350         require(z / _x == _y);
351         return z;
352     }
353 
354       /**
355         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
356 
357         @param _x   dividend
358         @param _y   divisor
359 
360         @return quotient
361     */
362     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
363         require(_y > 0);
364         uint256 c = _x / _y;
365 
366         return c;
367     }
368 }
369 
370 // File: contracts/utility/interfaces/IContractRegistry.sol
371 
372 /*
373     Contract Registry interface
374 */
375 contract IContractRegistry {
376     function addressOf(bytes32 _contractName) public view returns (address);
377 
378     // deprecated, backward compatibility
379     function getAddress(bytes32 _contractName) public view returns (address);
380 }
381 
382 // File: contracts/utility/interfaces/IContractFeatures.sol
383 
384 /*
385     Contract Features interface
386 */
387 contract IContractFeatures {
388     function isSupported(address _contract, uint256 _features) public view returns (bool);
389     function enableFeatures(uint256 _features, bool _enable) public;
390 }
391 
392 // File: contracts/utility/interfaces/IAddressList.sol
393 
394 /*
395     Address list interface
396 */
397 contract IAddressList {
398     mapping (address => bool) public listedAddresses;
399 }
400 
401 // File: contracts/token/interfaces/ISmartToken.sol
402 
403 /*
404     Smart Token interface
405 */
406 contract ISmartToken is IOwned, IERC20Token {
407     function disableTransfers(bool _disable) public;
408     function issue(address _to, uint256 _amount) public;
409     function destroy(address _from, uint256 _amount) public;
410 }
411 
412 // File: contracts/utility/interfaces/ITokenHolder.sol
413 
414 /*
415     Token Holder interface
416 */
417 contract ITokenHolder is IOwned {
418     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
419 }
420 
421 // File: contracts/token/interfaces/INonStandardERC20.sol
422 
423 /*
424     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
425 */
426 contract INonStandardERC20 {
427     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
428     function name() public view returns (string) {}
429     function symbol() public view returns (string) {}
430     function decimals() public view returns (uint8) {}
431     function totalSupply() public view returns (uint256) {}
432     function balanceOf(address _owner) public view returns (uint256) { _owner; }
433     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
434 
435     function transfer(address _to, uint256 _value) public;
436     function transferFrom(address _from, address _to, uint256 _value) public;
437     function approve(address _spender, uint256 _value) public;
438 }
439 
440 // File: contracts/utility/TokenHolder.sol
441 
442 /*
443     We consider every contract to be a 'token holder' since it's currently not possible
444     for a contract to deny receiving tokens.
445 
446     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
447     the owner to send tokens that were sent to the contract by mistake back to their sender.
448 
449     Note that we use the non standard ERC-20 interface which has no return value for transfer
450     in order to support both non standard as well as standard token contracts.
451     see https://github.com/ethereum/solidity/issues/4116
452 */
453 contract TokenHolder is ITokenHolder, Owned, Utils {
454     /**
455         @dev constructor
456     */
457     constructor() public {
458     }
459 
460     /**
461         @dev withdraws tokens held by the contract and sends them to an account
462         can only be called by the owner
463 
464         @param _token   ERC20 token contract address
465         @param _to      account to receive the new amount
466         @param _amount  amount to withdraw
467     */
468     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
469         public
470         ownerOnly
471         validAddress(_token)
472         validAddress(_to)
473         notThis(_to)
474     {
475         INonStandardERC20(_token).transfer(_to, _amount);
476     }
477 }
478 
479 // File: contracts/token/SmartTokenController.sol
480 
481 /*
482     The smart token controller is an upgradable part of the smart token that allows
483     more functionality as well as fixes for bugs/exploits.
484     Once it accepts ownership of the token, it becomes the token's sole controller
485     that can execute any of its functions.
486 
487     To upgrade the controller, ownership must be transferred to a new controller, along with
488     any relevant data.
489 
490     The smart token must be set on construction and cannot be changed afterwards.
491     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
492 
493     Note that the controller can transfer token ownership to a new controller that
494     doesn't allow executing any function on the token, for a trustless solution.
495     Doing that will also remove the owner's ability to upgrade the controller.
496 */
497 contract SmartTokenController is TokenHolder {
498     ISmartToken public token;   // smart token
499 
500     /**
501         @dev constructor
502     */
503     constructor(ISmartToken _token)
504         public
505         validAddress(_token)
506     {
507         token = _token;
508     }
509 
510     // ensures that the controller is the token's owner
511     modifier active() {
512         require(token.owner() == address(this));
513         _;
514     }
515 
516     // ensures that the controller is not the token's owner
517     modifier inactive() {
518         require(token.owner() != address(this));
519         _;
520     }
521 
522     /**
523         @dev allows transferring the token ownership
524         the new owner needs to accept the transfer
525         can only be called by the contract owner
526 
527         @param _newOwner    new token owner
528     */
529     function transferTokenOwnership(address _newOwner) public ownerOnly {
530         token.transferOwnership(_newOwner);
531     }
532 
533     /**
534         @dev used by a new owner to accept a token ownership transfer
535         can only be called by the contract owner
536     */
537     function acceptTokenOwnership() public ownerOnly {
538         token.acceptOwnership();
539     }
540 
541     /**
542         @dev disables/enables token transfers
543         can only be called by the contract owner
544 
545         @param _disable    true to disable transfers, false to enable them
546     */
547     function disableTokenTransfers(bool _disable) public ownerOnly {
548         token.disableTransfers(_disable);
549     }
550 
551     /**
552         @dev withdraws tokens held by the controller and sends them to an account
553         can only be called by the owner
554 
555         @param _token   ERC20 token contract address
556         @param _to      account to receive the new amount
557         @param _amount  amount to withdraw
558     */
559     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
560         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
561     }
562 }
563 
564 // File: contracts/token/interfaces/IEtherToken.sol
565 
566 /*
567     Ether Token interface
568 */
569 contract IEtherToken is ITokenHolder, IERC20Token {
570     function deposit() public payable;
571     function withdraw(uint256 _amount) public;
572     function withdrawTo(address _to, uint256 _amount) public;
573 }
574 
575 // File: contracts/bancorx/interfaces/IBancorX.sol
576 
577 contract IBancorX {
578     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
579     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
580 }
581 
582 // File: contracts/converter/BancorConverter.sol
583 
584 /*
585     Bancor Converter v13
586 
587     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
588 
589     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
590     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
591 
592     The converter is upgradable (just like any SmartTokenController).
593 
594     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
595              or with very small numbers because of precision loss
596 
597     Open issues:
598     - Front-running attacks are currently mitigated by the following mechanisms:
599         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
600         - gas price limit prevents users from having control over the order of execution
601         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
602       Other potential solutions might include a commit/reveal based schemes
603     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
604 */
605 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
606     using SafeMath for uint256;
607 
608     
609     uint32 private constant MAX_WEIGHT = 1000000;
610     uint64 private constant MAX_CONVERSION_FEE = 1000000;
611 
612     struct Connector {
613         uint256 virtualBalance;         // connector virtual balance
614         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
615         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
616         bool isSaleEnabled;             // is sale of the connector token enabled, can be set by the owner
617         bool isSet;                     // used to tell if the mapping element is defined
618     }
619 
620     uint16 public version = 13;
621     string public converterType = 'bancor';
622 
623     bool public allowRegistryUpdate = true;             // allows the owner to prevent/allow the registry to be updated
624     bool public claimTokensEnabled = false;             // allows BancorX contract to claim tokens without allowance (one transaction instread of two)
625     IContractRegistry public prevRegistry;              // address of previous registry as security mechanism
626     IContractRegistry public registry;                  // contract registry contract
627     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
628     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
629     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
630     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
631     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
632                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
633     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
634     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
635     IERC20Token[] private convertPath;
636 
637     // triggered when a conversion between two tokens occurs
638     event Conversion(
639         address indexed _fromToken,
640         address indexed _toToken,
641         address indexed _trader,
642         uint256 _amount,
643         uint256 _return,
644         int256 _conversionFee
645     );
646     // triggered after a conversion with new price data
647     event PriceDataUpdate(
648         address indexed _connectorToken,
649         uint256 _tokenSupply,
650         uint256 _connectorBalance,
651         uint32 _connectorWeight
652     );
653     // triggered when the conversion fee is updated
654     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
655 
656     // triggered when conversions are enabled/disabled
657     event ConversionsEnable(bool _conversionsEnabled);
658 
659     /**
660         @dev constructor
661 
662         @param  _token              smart token governed by the converter
663         @param  _registry           address of a contract registry contract
664         @param  _maxConversionFee   maximum conversion fee, represented in ppm
665         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
666         @param  _connectorWeight    optional, weight for the initial connector
667     */
668     constructor(
669         ISmartToken _token,
670         IContractRegistry _registry,
671         uint32 _maxConversionFee,
672         IERC20Token _connectorToken,
673         uint32 _connectorWeight
674     )
675         public
676         SmartTokenController(_token)
677         validAddress(_registry)
678         validMaxConversionFee(_maxConversionFee)
679     {
680         registry = _registry;
681         prevRegistry = _registry;
682         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
683 
684         // initialize supported features
685         if (features != address(0))
686             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
687 
688         maxConversionFee = _maxConversionFee;
689 
690         if (_connectorToken != address(0))
691             addConnector(_connectorToken, _connectorWeight, false);
692     }
693 
694     // validates a connector token address - verifies that the address belongs to one of the connector tokens
695     modifier validConnector(IERC20Token _address) {
696         require(connectors[_address].isSet);
697         _;
698     }
699 
700     // validates a token address - verifies that the address belongs to one of the convertible tokens
701     modifier validToken(IERC20Token _address) {
702         require(_address == token || connectors[_address].isSet);
703         _;
704     }
705 
706     // validates maximum conversion fee
707     modifier validMaxConversionFee(uint32 _conversionFee) {
708         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
709         _;
710     }
711 
712     // validates conversion fee
713     modifier validConversionFee(uint32 _conversionFee) {
714         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
715         _;
716     }
717 
718     // validates connector weight range
719     modifier validConnectorWeight(uint32 _weight) {
720         require(_weight > 0 && _weight <= MAX_WEIGHT);
721         _;
722     }
723 
724     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
725     modifier validConversionPath(IERC20Token[] _path) {
726         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
727         _;
728     }
729 
730     // allows execution only when the total weight is 100%
731     modifier maxTotalWeightOnly() {
732         require(totalConnectorWeight == MAX_WEIGHT);
733         _;
734     }
735 
736     // allows execution only when conversions aren't disabled
737     modifier conversionsAllowed {
738         assert(conversionsEnabled);
739         _;
740     }
741 
742     // allows execution by the BancorNetwork contract only
743     modifier bancorNetworkOnly {
744         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
745         require(msg.sender == address(bancorNetwork));
746         _;
747     }
748 
749     // allows execution by the converter upgrader contract only
750     modifier converterUpgraderOnly {
751         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
752         require(owner == converterUpgrader);
753         _;
754     }
755 
756     // allows execution only when claim tokens is enabled
757     modifier whenClaimTokensEnabled {
758         require(claimTokensEnabled);
759         _;
760     }
761 
762     /**
763         @dev sets the contract registry to whichever address the current registry is pointing to
764      */
765     function updateRegistry() public {
766         // require that upgrading is allowed or that the caller is the owner
767         require(allowRegistryUpdate || msg.sender == owner);
768 
769         // get the address of whichever registry the current registry is pointing to
770         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
771 
772         // if the new registry hasn't changed or is the zero address, revert
773         require(newRegistry != address(registry) && newRegistry != address(0));
774 
775         // set the previous registry as current registry and current registry as newRegistry
776         prevRegistry = registry;
777         registry = IContractRegistry(newRegistry);
778     }
779 
780     /**
781         @dev security mechanism allowing the converter owner to revert to the previous registry,
782         to be used in emergency scenario
783     */
784     function restoreRegistry() public ownerOrManagerOnly {
785         // set the registry as previous registry
786         registry = prevRegistry;
787 
788         // after a previous registry is restored, only the owner can allow future updates
789         allowRegistryUpdate = false;
790     }
791 
792     /**
793         @dev disables the registry update functionality
794         this is a safety mechanism in case of a emergency
795         can only be called by the manager or owner
796 
797         @param _disable    true to disable registry updates, false to re-enable them
798     */
799     function disableRegistryUpdate(bool _disable) public ownerOrManagerOnly {
800         allowRegistryUpdate = !_disable;
801     }
802 
803     /**
804         @dev disables/enables the claim tokens functionality
805 
806         @param _enable    true to enable claiming of tokens, false to disable
807      */
808     function enableClaimTokens(bool _enable) public ownerOnly {
809         claimTokensEnabled = _enable;
810     }
811 
812     /**
813         @dev returns the number of connector tokens defined
814 
815         @return number of connector tokens
816     */
817     function connectorTokenCount() public view returns (uint16) {
818         return uint16(connectorTokens.length);
819     }
820 
821     /**
822         @dev allows the owner to update & enable the conversion whitelist contract address
823         when set, only addresses that are whitelisted are actually allowed to use the converter
824         note that the whitelist check is actually done by the BancorNetwork contract
825 
826         @param _whitelist    address of a whitelist contract
827     */
828     function setConversionWhitelist(IWhitelist _whitelist)
829         public
830         ownerOnly
831         notThis(_whitelist)
832     {
833         conversionWhitelist = _whitelist;
834     }
835 
836     /**
837         @dev disables the entire conversion functionality
838         this is a safety mechanism in case of a emergency
839         can only be called by the manager
840 
841         @param _disable true to disable conversions, false to re-enable them
842     */
843     function disableConversions(bool _disable) public ownerOrManagerOnly {
844         if (conversionsEnabled == _disable) {
845             conversionsEnabled = !_disable;
846             emit ConversionsEnable(conversionsEnabled);
847         }
848     }
849 
850     /**
851         @dev allows transferring the token ownership
852         the new owner needs to accept the transfer
853         can only be called by the contract owner
854         note that token ownership can only be transferred while the owner is the converter upgrader contract
855 
856         @param _newOwner    new token owner
857     */
858     function transferTokenOwnership(address _newOwner)
859         public
860         ownerOnly
861         converterUpgraderOnly
862     {
863         super.transferTokenOwnership(_newOwner);
864     }
865 
866     /**
867         @dev updates the current conversion fee
868         can only be called by the manager
869 
870         @param _conversionFee new conversion fee, represented in ppm
871     */
872     function setConversionFee(uint32 _conversionFee)
873         public
874         ownerOrManagerOnly
875         validConversionFee(_conversionFee)
876     {
877         emit ConversionFeeUpdate(conversionFee, _conversionFee);
878         conversionFee = _conversionFee;
879     }
880 
881     /**
882         @dev given a return amount, returns the amount minus the conversion fee
883 
884         @param _amount      return amount
885         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
886 
887         @return return amount minus conversion fee
888     */
889     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
890         return _amount.mul((MAX_CONVERSION_FEE - conversionFee) ** _magnitude).div(MAX_CONVERSION_FEE ** _magnitude);
891     }
892 
893     /**
894         @dev withdraws tokens held by the converter and sends them to an account
895         can only be called by the owner
896         note that connector tokens can only be withdrawn by the owner while the converter is inactive
897         unless the owner is the converter upgrader contract
898 
899         @param _token   ERC20 token contract address
900         @param _to      account to receive the new amount
901         @param _amount  amount to withdraw
902     */
903     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
904         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
905 
906         // if the token is not a connector token, allow withdrawal
907         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
908         require(!connectors[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
909         super.withdrawTokens(_token, _to, _amount);
910     }
911 
912     /**
913         @dev allows the BancorX contract to claim BNT from any address (so that users
914         dont have to first give allowance when calling BancorX)
915 
916         @param _from      address to claim the BNT from
917         @param _amount    the amount to claim
918      */
919     function claimTokens(address _from, uint256 _amount) public whenClaimTokensEnabled {
920         address bancorX = registry.addressOf(ContractIds.BANCOR_X);
921 
922         // only the bancorX contract may call this method
923         require(msg.sender == bancorX);
924 
925         // destroy the tokens belonging to _from, and issue the same amount to bancorX contract
926         token.destroy(_from, _amount);
927         token.issue(msg.sender, _amount);
928     }
929 
930     /**
931         @dev upgrades the converter to the latest version
932         can only be called by the owner
933         note that the owner needs to call acceptOwnership/acceptManagement on the new converter after the upgrade
934     */
935     function upgrade() public ownerOnly {
936         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER));
937 
938         transferOwnership(converterUpgrader);
939         converterUpgrader.upgrade(version);
940         acceptOwnership();
941     }
942 
943     /**
944         @dev defines a new connector for the token
945         can only be called by the owner while the converter is inactive
946 
947         @param _token                  address of the connector token
948         @param _weight                 constant connector weight, represented in ppm, 1-1000000
949         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
950     */
951     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
952         public
953         ownerOnly
954         inactive
955         validAddress(_token)
956         notThis(_token)
957         validConnectorWeight(_weight)
958     {
959         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
960 
961         connectors[_token].virtualBalance = 0;
962         connectors[_token].weight = _weight;
963         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
964         connectors[_token].isSaleEnabled = true;
965         connectors[_token].isSet = true;
966         connectorTokens.push(_token);
967         totalConnectorWeight += _weight;
968     }
969 
970     /**
971         @dev updates one of the token connectors
972         can only be called by the owner
973 
974         @param _connectorToken         address of the connector token
975         @param _weight                 constant connector weight, represented in ppm, 1-1000000
976         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
977         @param _virtualBalance         new connector's virtual balance
978     */
979     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
980         public
981         ownerOnly
982         validConnector(_connectorToken)
983         validConnectorWeight(_weight)
984     {
985         Connector storage connector = connectors[_connectorToken];
986         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
987 
988         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
989         connector.weight = _weight;
990         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
991         connector.virtualBalance = _virtualBalance;
992     }
993 
994     /**
995         @dev disables converting from the given connector token in case the connector token got compromised
996         can only be called by the owner
997         note that converting to the token is still enabled regardless of this flag and it cannot be disabled by the owner
998 
999         @param _connectorToken  connector token contract address
1000         @param _disable         true to disable the token, false to re-enable it
1001     */
1002     function disableConnectorSale(IERC20Token _connectorToken, bool _disable)
1003         public
1004         ownerOnly
1005         validConnector(_connectorToken)
1006     {
1007         connectors[_connectorToken].isSaleEnabled = !_disable;
1008     }
1009 
1010     /**
1011         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
1012 
1013         @param _connectorToken  connector token contract address
1014 
1015         @return connector balance
1016     */
1017     function getConnectorBalance(IERC20Token _connectorToken)
1018         public
1019         view
1020         validConnector(_connectorToken)
1021         returns (uint256)
1022     {
1023         Connector storage connector = connectors[_connectorToken];
1024         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
1025     }
1026 
1027     /**
1028         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
1029 
1030         @param _fromToken  ERC20 token to convert from
1031         @param _toToken    ERC20 token to convert to
1032         @param _amount     amount to convert, in fromToken
1033 
1034         @return expected conversion return amount and conversion fee
1035     */
1036     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
1037         require(_fromToken != _toToken); // validate input
1038 
1039         // conversion between the token and one of its connectors
1040         if (_toToken == token)
1041             return getPurchaseReturn(_fromToken, _amount);
1042         else if (_fromToken == token)
1043             return getSaleReturn(_toToken, _amount);
1044 
1045         // conversion between 2 connectors
1046         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
1047     }
1048 
1049     /**
1050         @dev returns the expected return for buying the token for a connector token
1051 
1052         @param _connectorToken  connector token contract address
1053         @param _depositAmount   amount to deposit (in the connector token)
1054 
1055         @return expected purchase return amount and conversion fee
1056     */
1057     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
1058         public
1059         view
1060         active
1061         validConnector(_connectorToken)
1062         returns (uint256, uint256)
1063     {
1064         Connector storage connector = connectors[_connectorToken];
1065         require(connector.isSaleEnabled); // validate input
1066 
1067         uint256 tokenSupply = token.totalSupply();
1068         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1069         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1070         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
1071         uint256 finalAmount = getFinalAmount(amount, 1);
1072 
1073         // return the amount minus the conversion fee and the conversion fee
1074         return (finalAmount, amount - finalAmount);
1075     }
1076 
1077     /**
1078         @dev returns the expected return for selling the token for one of its connector tokens
1079 
1080         @param _connectorToken  connector token contract address
1081         @param _sellAmount      amount to sell (in the smart token)
1082 
1083         @return expected sale return amount and conversion fee
1084     */
1085     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
1086         public
1087         view
1088         active
1089         validConnector(_connectorToken)
1090         returns (uint256, uint256)
1091     {
1092         Connector storage connector = connectors[_connectorToken];
1093         uint256 tokenSupply = token.totalSupply();
1094         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1095         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1096         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
1097         uint256 finalAmount = getFinalAmount(amount, 1);
1098 
1099         // return the amount minus the conversion fee and the conversion fee
1100         return (finalAmount, amount - finalAmount);
1101     }
1102 
1103     /**
1104         @dev returns the expected return for selling one of the connector tokens for another connector token
1105 
1106         @param _fromConnectorToken  contract address of the connector token to convert from
1107         @param _toConnectorToken    contract address of the connector token to convert to
1108         @param _sellAmount          amount to sell (in the from connector token)
1109 
1110         @return expected sale return amount and conversion fee (in the to connector token)
1111     */
1112     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
1113         public
1114         view
1115         active
1116         validConnector(_fromConnectorToken)
1117         validConnector(_toConnectorToken)
1118         returns (uint256, uint256)
1119     {
1120         Connector storage fromConnector = connectors[_fromConnectorToken];
1121         Connector storage toConnector = connectors[_toConnectorToken];
1122         require(fromConnector.isSaleEnabled); // validate input
1123 
1124         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1125         uint256 amount = formula.calculateCrossConnectorReturn(
1126             getConnectorBalance(_fromConnectorToken), 
1127             fromConnector.weight, 
1128             getConnectorBalance(_toConnectorToken), 
1129             toConnector.weight, 
1130             _sellAmount);
1131         uint256 finalAmount = getFinalAmount(amount, 2);
1132 
1133         // return the amount minus the conversion fee and the conversion fee
1134         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1135         return (finalAmount, amount - finalAmount);
1136     }
1137 
1138     /**
1139         @dev converts a specific amount of _fromToken to _toToken
1140 
1141         @param _fromToken  ERC20 token to convert from
1142         @param _toToken    ERC20 token to convert to
1143         @param _amount     amount to convert, in fromToken
1144         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1145 
1146         @return conversion return amount
1147     */
1148     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1149         public
1150         bancorNetworkOnly
1151         conversionsAllowed
1152         greaterThanZero(_minReturn)
1153         returns (uint256)
1154     {
1155         require(_fromToken != _toToken); // validate input
1156 
1157         // conversion between the token and one of its connectors
1158         if (_toToken == token)
1159             return buy(_fromToken, _amount, _minReturn);
1160         else if (_fromToken == token)
1161             return sell(_toToken, _amount, _minReturn);
1162 
1163         uint256 amount;
1164         uint256 feeAmount;
1165 
1166         // conversion between 2 connectors
1167         (amount, feeAmount) = getCrossConnectorReturn(_fromToken, _toToken, _amount);
1168         // ensure the trade gives something in return and meets the minimum requested amount
1169         require(amount != 0 && amount >= _minReturn);
1170 
1171         // update the source token virtual balance if relevant
1172         Connector storage fromConnector = connectors[_fromToken];
1173         if (fromConnector.isVirtualBalanceEnabled)
1174             fromConnector.virtualBalance = fromConnector.virtualBalance.add(_amount);
1175 
1176         // update the target token virtual balance if relevant
1177         Connector storage toConnector = connectors[_toToken];
1178         if (toConnector.isVirtualBalanceEnabled)
1179             toConnector.virtualBalance = toConnector.virtualBalance.sub(amount);
1180 
1181         // ensure that the trade won't deplete the connector balance
1182         uint256 toConnectorBalance = getConnectorBalance(_toToken);
1183         assert(amount < toConnectorBalance);
1184 
1185         // transfer funds from the caller in the from connector token
1186         ensureTransferFrom(_fromToken, msg.sender, this, _amount);
1187         // transfer funds to the caller in the to connector token
1188         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1189         ensureTransfer(_toToken, msg.sender, amount);
1190 
1191         // dispatch the conversion event
1192         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1193         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1194 
1195         // dispatch price data updates for the smart token / both connectors
1196         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
1197         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
1198         return amount;
1199     }
1200 
1201     /**
1202         @dev converts a specific amount of _fromToken to _toToken
1203 
1204         @param _fromToken  ERC20 token to convert from
1205         @param _toToken    ERC20 token to convert to
1206         @param _amount     amount to convert, in fromToken
1207         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1208 
1209         @return conversion return amount
1210     */
1211     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1212         convertPath = [_fromToken, token, _toToken];
1213         return quickConvert(convertPath, _amount, _minReturn);
1214     }
1215 
1216     /**
1217         @dev buys the token by depositing one of its connector tokens
1218 
1219         @param _connectorToken  connector token contract address
1220         @param _depositAmount   amount to deposit (in the connector token)
1221         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1222 
1223         @return buy return amount
1224     */
1225     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1226         uint256 amount;
1227         uint256 feeAmount;
1228         (amount, feeAmount) = getPurchaseReturn(_connectorToken, _depositAmount);
1229         // ensure the trade gives something in return and meets the minimum requested amount
1230         require(amount != 0 && amount >= _minReturn);
1231 
1232         // update virtual balance if relevant
1233         Connector storage connector = connectors[_connectorToken];
1234         if (connector.isVirtualBalanceEnabled)
1235             connector.virtualBalance = connector.virtualBalance.add(_depositAmount);
1236 
1237         // transfer funds from the caller in the connector token
1238         ensureTransferFrom(_connectorToken, msg.sender, this, _depositAmount);
1239         // issue new funds to the caller in the smart token
1240         token.issue(msg.sender, amount);
1241 
1242         // dispatch the conversion event
1243         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
1244 
1245         // dispatch price data update for the smart token/connector
1246         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1247         return amount;
1248     }
1249 
1250     /**
1251         @dev sells the token by withdrawing from one of its connector tokens
1252 
1253         @param _connectorToken  connector token contract address
1254         @param _sellAmount      amount to sell (in the smart token)
1255         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1256 
1257         @return sell return amount
1258     */
1259     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1260         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1261         uint256 amount;
1262         uint256 feeAmount;
1263         (amount, feeAmount) = getSaleReturn(_connectorToken, _sellAmount);
1264         // ensure the trade gives something in return and meets the minimum requested amount
1265         require(amount != 0 && amount >= _minReturn);
1266 
1267         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1268         uint256 tokenSupply = token.totalSupply();
1269         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1270         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1271 
1272         // update virtual balance if relevant
1273         Connector storage connector = connectors[_connectorToken];
1274         if (connector.isVirtualBalanceEnabled)
1275             connector.virtualBalance = connector.virtualBalance.sub(amount);
1276 
1277         // destroy _sellAmount from the caller's balance in the smart token
1278         token.destroy(msg.sender, _sellAmount);
1279         // transfer funds to the caller in the connector token
1280         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1281         ensureTransfer(_connectorToken, msg.sender, amount);
1282 
1283         // dispatch the conversion event
1284         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1285 
1286         // dispatch price data update for the smart token/connector
1287         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1288         return amount;
1289     }
1290 
1291     /**
1292         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1293         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1294 
1295         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1296         @param _amount      amount to convert from (in the initial source token)
1297         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1298 
1299         @return tokens issued in return
1300     */
1301     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1302         public
1303         payable
1304         returns (uint256)
1305     {
1306         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1307     }
1308 
1309     /**
1310         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1311         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1312 
1313         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1314         @param _amount      amount to convert from (in the initial source token)
1315         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1316         @param _block       if the current block exceeded the given parameter - it is cancelled
1317         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1318         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1319         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1320 
1321         @return tokens issued in return
1322     */
1323     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1324         public
1325         payable
1326         returns (uint256)
1327     {
1328         IERC20Token fromToken = _path[0];
1329         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1330 
1331         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1332         // so it can execute the conversion on behalf of the caller
1333         if (msg.value == 0) {
1334             // not ETH, send the source tokens to the BancorNetwork contract
1335             // if the token is the smart token, no allowance is required - destroy the tokens
1336             // from the caller and issue them to the BancorNetwork contract
1337             if (fromToken == token) {
1338                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1339                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1340             } else {
1341                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1342                 ensureTransferFrom(fromToken, msg.sender, bancorNetwork, _amount);
1343             }
1344         }
1345 
1346         // execute the conversion and pass on the ETH with the call
1347         return bancorNetwork.convertForPrioritized3.value(msg.value)(_path, _amount, _minReturn, msg.sender, _amount, _block, _v, _r, _s);
1348     }
1349 
1350     /**
1351         @dev allows a user to convert BNT that was sent from another blockchain into any other
1352         token on the BancorNetwork without specifying the amount of BNT to be converted, but
1353         rather by providing the xTransferId which allows us to get the amount from BancorX.
1354 
1355         @param _path             conversion path, see conversion path format in the BancorNetwork contract
1356         @param _minReturn        if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1357         @param _conversionId     pre-determined unique (if non zero) id which refers to this transaction 
1358         @param _block            if the current block exceeded the given parameter - it is cancelled
1359         @param _v                (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1360         @param _r                (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1361         @param _s                (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1362 
1363         @return tokens issued in return
1364     */
1365     function completeXConversion(
1366         IERC20Token[] _path,
1367         uint256 _minReturn,
1368         uint256 _conversionId,
1369         uint256 _block,
1370         uint8 _v,
1371         bytes32 _r,
1372         bytes32 _s
1373     )
1374         public
1375         returns (uint256)
1376     {
1377         IBancorX bancorX = IBancorX(registry.addressOf(ContractIds.BANCOR_X));
1378         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1379 
1380         // verify that the first token in the path is BNT
1381         require(_path[0] == registry.addressOf(ContractIds.BNT_TOKEN));
1382 
1383         // get conversion amount from BancorX contract
1384         uint256 amount = bancorX.getXTransferAmount(_conversionId, msg.sender);
1385 
1386         // send BNT from msg.sender to the BancorNetwork contract
1387         token.destroy(msg.sender, amount);
1388         token.issue(bancorNetwork, amount);
1389 
1390         return bancorNetwork.convertForPrioritized3(_path, amount, _minReturn, msg.sender, _conversionId, _block, _v, _r, _s);
1391     }
1392 
1393     /**
1394         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1395         true on success but revert on failure instead
1396 
1397         @param _token     the token to transfer
1398         @param _to        the address to transfer the tokens to
1399         @param _amount    the amount to transfer
1400     */
1401     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1402         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1403 
1404         if (addressList.listedAddresses(_token)) {
1405             uint256 prevBalance = _token.balanceOf(_to);
1406             // we have to cast the token contract in an interface which has no return value
1407             INonStandardERC20(_token).transfer(_to, _amount);
1408             uint256 postBalance = _token.balanceOf(_to);
1409             assert(postBalance > prevBalance);
1410         } else {
1411             // if the token isn't whitelisted, we assert on transfer
1412             assert(_token.transfer(_to, _amount));
1413         }
1414     }
1415 
1416     /**
1417         @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1418         true on success but revert on failure instead
1419 
1420         @param _token     the token to transfer
1421         @param _from      the address to transfer the tokens from
1422         @param _to        the address to transfer the tokens to
1423         @param _amount    the amount to transfer
1424     */
1425     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1426         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1427 
1428         if (addressList.listedAddresses(_token)) {
1429             uint256 prevBalance = _token.balanceOf(_to);
1430             // we have to cast the token contract in an interface which has no return value
1431             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1432             uint256 postBalance = _token.balanceOf(_to);
1433             assert(postBalance > prevBalance);
1434         } else {
1435             // if the token is standard, we assert on transfer
1436             assert(_token.transferFrom(_from, _to, _amount));
1437         }
1438     }
1439 
1440     /**
1441         @dev buys the token with all connector tokens using the same percentage
1442         i.e. if the caller increases the supply by 10%, it will cost an amount equal to
1443         10% of each connector token balance
1444         can only be called if the max total weight is exactly 100% and while conversions are enabled
1445 
1446         @param _amount  amount to increase the supply by (in the smart token)
1447     */
1448     function fund(uint256 _amount)
1449         public
1450         maxTotalWeightOnly
1451         conversionsAllowed
1452     {
1453         uint256 supply = token.totalSupply();
1454 
1455         // iterate through the connector tokens and transfer a percentage equal to the ratio between _amount
1456         // and the total supply in each connector from the caller to the converter
1457         IERC20Token connectorToken;
1458         uint256 connectorBalance;
1459         uint256 connectorAmount;
1460         for (uint16 i = 0; i < connectorTokens.length; i++) {
1461             connectorToken = connectorTokens[i];
1462             connectorBalance = getConnectorBalance(connectorToken);
1463             connectorAmount = _amount.mul(connectorBalance).div(supply);
1464 
1465             // update virtual balance if relevant
1466             Connector storage connector = connectors[connectorToken];
1467             if (connector.isVirtualBalanceEnabled)
1468                 connector.virtualBalance = connector.virtualBalance.add(connectorAmount);
1469 
1470             // transfer funds from the caller in the connector token
1471             ensureTransferFrom(connectorToken, msg.sender, this, connectorAmount);
1472 
1473             // dispatch price data update for the smart token/connector
1474             emit PriceDataUpdate(connectorToken, supply + _amount, connectorBalance + connectorAmount, connector.weight);
1475         }
1476 
1477         // issue new funds to the caller in the smart token
1478         token.issue(msg.sender, _amount);
1479     }
1480 
1481     /**
1482         @dev sells the token for all connector tokens using the same percentage
1483         i.e. if the holder sells 10% of the supply, they will receive 10% of each
1484         connector token balance in return
1485         can only be called if the max total weight is exactly 100%
1486         note that the function can also be called if conversions are disabled
1487 
1488         @param _amount  amount to liquidate (in the smart token)
1489     */
1490     function liquidate(uint256 _amount) public maxTotalWeightOnly {
1491         uint256 supply = token.totalSupply();
1492 
1493         // destroy _amount from the caller's balance in the smart token
1494         token.destroy(msg.sender, _amount);
1495 
1496         // iterate through the connector tokens and send a percentage equal to the ratio between _amount
1497         // and the total supply from each connector balance to the caller
1498         IERC20Token connectorToken;
1499         uint256 connectorBalance;
1500         uint256 connectorAmount;
1501         for (uint16 i = 0; i < connectorTokens.length; i++) {
1502             connectorToken = connectorTokens[i];
1503             connectorBalance = getConnectorBalance(connectorToken);
1504             connectorAmount = _amount.mul(connectorBalance).div(supply);
1505 
1506             // update virtual balance if relevant
1507             Connector storage connector = connectors[connectorToken];
1508             if (connector.isVirtualBalanceEnabled)
1509                 connector.virtualBalance = connector.virtualBalance.sub(connectorAmount);
1510 
1511             // transfer funds to the caller in the connector token
1512             // the transfer might fail if the actual connector balance is smaller than the virtual balance
1513             ensureTransfer(connectorToken, msg.sender, connectorAmount);
1514 
1515             // dispatch price data update for the smart token/connector
1516             emit PriceDataUpdate(connectorToken, supply - _amount, connectorBalance - connectorAmount, connector.weight);
1517         }
1518     }
1519 
1520     // deprecated, backward compatibility
1521     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1522         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1523     }
1524 
1525     /**
1526         @dev helper, dispatches the Conversion event
1527 
1528         @param _fromToken       ERC20 token to convert from
1529         @param _toToken         ERC20 token to convert to
1530         @param _amount          amount purchased/sold (in the source token)
1531         @param _returnAmount    amount returned (in the target token)
1532     */
1533     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1534         // fee amount is converted to 255 bits -
1535         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1536         // currently the fee is always taken from the target token
1537         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1538         assert(_feeAmount <= 2 ** 255);
1539         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1540     }
1541 }