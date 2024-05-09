1 pragma solidity ^0.4.23;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public view returns (string) {}
9     function symbol() public view returns (string) {}
10     function decimals() public view returns (uint8) {}
11     function totalSupply() public view returns (uint256) {}
12     function balanceOf(address _owner) public view returns (uint256) { _owner; }
13     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 
21 /*
22     Owned contract interface
23 */
24 contract IOwned {
25     // this function isn't abstract since the compiler emits automatically generated getter functions as external
26     function owner() public view returns (address) {}
27 
28     function transferOwnership(address _newOwner) public;
29     function acceptOwnership() public;
30     function setOwner(address _newOwner) public;
31 }
32 
33 
34 /*
35     Whitelist interface
36 */
37 contract IWhitelist {
38     function isWhitelisted(address _address) public view returns (bool);
39 }
40 
41 
42 /*
43     Contract Features interface
44 */
45 contract IContractFeatures {
46     function isSupported(address _contract, uint256 _features) public view returns (bool);
47     function enableFeatures(uint256 _features, bool _enable) public;
48 }
49 
50 
51 /*
52     Contract Registry interface
53 */
54 contract IContractRegistry {
55     function addressOf(bytes32 _contractName) public view returns (address);
56 
57     // deprecated, backward compatibility
58     function getAddress(bytes32 _contractName) public view returns (address);
59 }
60 
61 
62 /**
63     Id definitions for bancor contracts
64 
65     Can be used in conjunction with the contract registry to get contract addresses
66 */
67 contract ContractIds {
68     // generic
69     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
70 
71     // bancor logic
72     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
73     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
74     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
75     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
76 }
77 
78 
79 
80 /*
81     Bancor Network interface
82 */
83 contract IBancorNetwork {
84     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
85     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
86     function convertForPrioritized2(
87         IERC20Token[] _path,
88         uint256 _amount,
89         uint256 _minReturn,
90         address _for,
91         uint256 _block,
92         uint8 _v,
93         bytes32 _r,
94         bytes32 _s)
95         public payable returns (uint256);
96 
97     // deprecated, backward compatibility
98     function convertForPrioritized(
99         IERC20Token[] _path,
100         uint256 _amount,
101         uint256 _minReturn,
102         address _for,
103         uint256 _block,
104         uint256 _nonce,
105         uint8 _v,
106         bytes32 _r,
107         bytes32 _s)
108         public payable returns (uint256);
109 }
110 
111 
112 /*
113     Bancor Formula interface
114 */
115 contract IBancorFormula {
116     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
117     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
118     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
119 }
120 
121 
122 
123 
124 /*
125     Bancor Converter interface
126 */
127 contract IBancorConverter {
128     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
129     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
130     function conversionWhitelist() public view returns (IWhitelist) {}
131     // deprecated, backward compatibility
132     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
133 }
134 
135 
136 
137 
138 
139 
140 
141 /**
142     Id definitions for bancor contract features
143 
144     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
145 */
146 contract FeatureIds {
147     // converter features
148     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
149 }
150 
151 
152 
153 
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
173         assert(msg.sender == owner);
174         _;
175     }
176 
177     function setOwner(address _newOwner) public ownerOnly {
178         require(_newOwner != owner && _newOwner != address(0));
179         emit OwnerUpdate(owner, _newOwner);
180         owner = _newOwner;
181         newOwner = address(0);
182     }
183 
184     /**
185         @dev allows transferring the contract ownership
186         the new owner still needs to accept the transfer
187         can only be called by the contract owner
188 
189         @param _newOwner    new contract owner
190     */
191     function transferOwnership(address _newOwner) public ownerOnly {
192         require(_newOwner != owner);
193         newOwner = _newOwner;
194     }
195 
196     /**
197         @dev used by a new owner to accept an ownership transfer
198     */
199     function acceptOwnership() public {
200         require(msg.sender == newOwner);
201         emit OwnerUpdate(owner, newOwner);
202         owner = newOwner;
203         newOwner = address(0);
204     }
205 }
206 
207 
208 /*
209     Provides support and utilities for contract management
210     Note that a managed contract must also have an owner
211 */
212 contract Managed is Owned {
213     address public manager;
214     address public newManager;
215 
216     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
217 
218     /**
219         @dev constructor
220     */
221     constructor() public {
222         manager = msg.sender;
223     }
224 
225     // allows execution by the manager only
226     modifier managerOnly {
227         assert(msg.sender == manager);
228         _;
229     }
230 
231     // allows execution by either the owner or the manager only
232     modifier ownerOrManagerOnly {
233         require(msg.sender == owner || msg.sender == manager);
234         _;
235     }
236 
237     /**
238         @dev allows transferring the contract management
239         the new manager still needs to accept the transfer
240         can only be called by the contract manager
241 
242         @param _newManager    new contract manager
243     */
244     function transferManagement(address _newManager) public ownerOrManagerOnly {
245         require(_newManager != manager);
246         newManager = _newManager;
247     }
248 
249     /**
250         @dev used by a new manager to accept a management transfer
251     */
252     function acceptManagement() public {
253         require(msg.sender == newManager);
254         emit ManagerUpdate(manager, newManager);
255         manager = newManager;
256         newManager = address(0);
257     }
258 
259     function setManager(address _newManager) public managerOnly {
260         require(_newManager != manager && _newManager != address(0));
261         emit ManagerUpdate(manager, _newManager);
262         manager = _newManager;
263         newManager = address(0);
264     }
265     
266 }
267 
268 
269 
270 /*
271     Utilities & Common Modifiers
272 */
273 contract Utils {
274     /**
275         constructor
276     */
277     constructor() public {
278     }
279 
280     // verifies that an amount is greater than zero
281     modifier greaterThanZero(uint256 _amount) {
282         require(_amount > 0);
283         _;
284     }
285 
286     // validates an address - currently only checks that it isn't null
287     modifier validAddress(address _address) {
288         require(_address != address(0));
289         _;
290     }
291 
292     // verifies that the address is different than this contract address
293     modifier notThis(address _address) {
294         require(_address != address(this));
295         _;
296     }
297 
298     // Overflow protected math functions
299 
300     /**
301         @dev returns the sum of _x and _y, asserts if the calculation overflows
302 
303         @param _x   value 1
304         @param _y   value 2
305 
306         @return sum
307     */
308     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
309         uint256 z = _x + _y;
310         assert(z >= _x);
311         return z;
312     }
313 
314     /**
315         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
316 
317         @param _x   minuend
318         @param _y   subtrahend
319 
320         @return difference
321     */
322     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
323         assert(_x >= _y);
324         return _x - _y;
325     }
326 
327     /**
328         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
329 
330         @param _x   factor 1
331         @param _y   factor 2
332 
333         @return product
334     */
335     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
336         uint256 z = _x * _y;
337         assert(_x == 0 || z / _x == _y);
338         return z;
339     }
340 }
341 
342 
343 
344 
345 
346 
347 
348 /*
349     Token Holder interface
350 */
351 contract ITokenHolder is IOwned {
352     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
353 }
354 
355 
356 
357 
358 /*
359     We consider every contract to be a 'token holder' since it's currently not possible
360     for a contract to deny receiving tokens.
361 
362     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
363     the owner to send tokens that were sent to the contract by mistake back to their sender.
364 */
365 contract TokenHolder is ITokenHolder, Owned, Utils {
366     /**
367         @dev constructor
368     */
369     constructor() public {
370     }
371 
372     /**
373         @dev withdraws tokens held by the contract and sends them to an account
374         can only be called by the owner
375 
376         @param _token   ERC20 token contract address
377         @param _to      account to receive the new amount
378         @param _amount  amount to withdraw
379     */
380     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
381         public
382         ownerOnly
383         validAddress(_token)
384         validAddress(_to)
385         notThis(_to)
386     {
387         assert(_token.transfer(_to, _amount));
388     }
389 }
390 
391 
392 /*
393     The smart token controller is an upgradable part of the smart token that allows
394     more functionality as well as fixes for bugs/exploits.
395     Once it accepts ownership of the token, it becomes the token's sole controller
396     that can execute any of its functions.
397 
398     To upgrade the controller, ownership must be transferred to a new controller, along with
399     any relevant data.
400 
401     The smart token must be set on construction and cannot be changed afterwards.
402     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
403 
404     Note that the controller can transfer token ownership to a new controller that
405     doesn't allow executing any function on the token, for a trustless solution.
406     Doing that will also remove the owner's ability to upgrade the controller.
407 */
408 contract SmartTokenController is TokenHolder {
409     ISmartToken public token;   // smart token
410 
411     /**
412         @dev constructor
413     */
414     constructor(ISmartToken _token)
415         public
416         validAddress(_token)
417     {
418         token = _token;
419     }
420 
421     // ensures that the controller is the token's owner
422     modifier active() {
423         assert(token.owner() == address(this));
424         _;
425     }
426 
427     // ensures that the controller is not the token's owner
428     modifier inactive() {
429         assert(token.owner() != address(this));
430         _;
431     }
432 
433     /**
434         @dev allows transferring the token ownership
435         the new owner still need to accept the transfer
436         can only be called by the contract owner
437 
438         @param _newOwner    new token owner
439     */
440     function transferTokenOwnership(address _newOwner) public ownerOnly {
441         token.transferOwnership(_newOwner);
442     }
443 
444     /**
445         @dev used by a new owner to accept a token ownership transfer
446         can only be called by the contract owner
447     */
448     function acceptTokenOwnership() public ownerOnly {
449         token.acceptOwnership();
450     }
451 
452     /**
453         @dev disables/enables token transfers
454         can only be called by the contract owner
455 
456         @param _disable    true to disable transfers, false to enable them
457     */
458     function disableTokenTransfers(bool _disable) public ownerOnly {
459         token.disableTransfers(_disable);
460     }
461 
462     /**
463         @dev withdraws tokens held by the controller and sends them to an account
464         can only be called by the owner
465 
466         @param _token   ERC20 token contract address
467         @param _to      account to receive the new amount
468         @param _amount  amount to withdraw
469     */
470     function withdrawFromToken(
471         IERC20Token _token, 
472         address _to, 
473         uint256 _amount
474     ) 
475         public
476         ownerOnly
477     {
478         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
479     }
480 }
481 
482 
483 
484 
485 
486 /*
487     Smart Token interface
488 */
489 contract ISmartToken is IOwned, IERC20Token {
490     function disableTransfers(bool _disable) public;
491     function issue(address _to, uint256 _amount) public;
492     function destroy(address _from, uint256 _amount) public;
493 }
494 
495 
496 
497 
498 
499 
500 
501 
502 
503 /*
504     Ether Token interface
505 */
506 contract IEtherToken is ITokenHolder, IERC20Token {
507     function deposit() public payable;
508     function withdraw(uint256 _amount) public;
509     function withdrawTo(address _to, uint256 _amount) public;
510 }
511 
512 
513 /*
514     Bancor Converter v0.10
515 
516     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
517 
518     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
519     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
520 
521     The converter is upgradable (just like any SmartTokenController).
522 
523     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
524              or with very small numbers because of precision loss
525 
526     Open issues:
527     - Front-running attacks are currently mitigated by the following mechanisms:
528         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
529         - gas price limit prevents users from having control over the order of execution
530         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
531       Other potential solutions might include a commit/reveal based schemes
532     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
533 */
534 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
535     uint32 private constant MAX_WEIGHT = 1000000;
536     uint64 private constant MAX_CONVERSION_FEE = 1000000;
537 
538     struct Connector {
539         uint256 virtualBalance;         // connector virtual balance
540         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
541         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
542         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
543         bool isSet;                     // used to tell if the mapping element is defined
544     }
545 
546     string public version = '0.10';
547     string public converterType = 'bancor';
548 
549     IContractRegistry public registry;                  // contract registry contract
550     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
551     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
552     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
553     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
554     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
555     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
556                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
557     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
558     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
559     IERC20Token[] private convertPath;
560 
561     // triggered when a conversion between two tokens occurs
562     event Conversion(
563         address indexed _fromToken,
564         address indexed _toToken,
565         address indexed _trader,
566         uint256 _amount,
567         uint256 _return,
568         int256 _conversionFee
569     );
570     // triggered after a conversion with new price data
571     event PriceDataUpdate(
572         address indexed _connectorToken,
573         uint256 _tokenSupply,
574         uint256 _connectorBalance,
575         uint32 _connectorWeight
576     );
577     // triggered when the conversion fee is updated
578     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
579 
580     /**
581         @dev constructor
582 
583         @param  _token              smart token governed by the converter
584         @param  _registry           address of a contract registry contract
585         @param  _maxConversionFee   maximum conversion fee, represented in ppm
586         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
587         @param  _connectorWeight    optional, weight for the initial connector
588     */
589     constructor(
590         ISmartToken _token,
591         IContractRegistry _registry,
592         uint32 _maxConversionFee,
593         IERC20Token _connectorToken,
594         uint32 _connectorWeight
595     )
596         public
597         SmartTokenController(_token)
598         validAddress(_registry)
599         validMaxConversionFee(_maxConversionFee)
600     {
601         registry = _registry;
602         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
603 
604         // initialize supported features
605         if (features != address(0))
606             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
607 
608         maxConversionFee = _maxConversionFee;
609 
610         if (_connectorToken != address(0))
611             addConnector(_connectorToken, _connectorWeight, false);
612     }
613 
614     // validates a connector token address - verifies that the address belongs to one of the connector tokens
615     modifier validConnector(IERC20Token _address) {
616         require(connectors[_address].isSet);
617         _;
618     }
619 
620     // validates a token address - verifies that the address belongs to one of the convertible tokens
621     modifier validToken(IERC20Token _address) {
622         require(_address == token || connectors[_address].isSet);
623         _;
624     }
625 
626     // validates maximum conversion fee
627     modifier validMaxConversionFee(uint32 _conversionFee) {
628         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
629         _;
630     }
631 
632     // validates conversion fee
633     modifier validConversionFee(uint32 _conversionFee) {
634         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
635         _;
636     }
637 
638     // validates connector weight range
639     modifier validConnectorWeight(uint32 _weight) {
640         require(_weight > 0 && _weight <= MAX_WEIGHT);
641         _;
642     }
643 
644     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
645     modifier validConversionPath(IERC20Token[] _path) {
646         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
647         _;
648     }
649 
650     // allows execution only when conversions aren't disabled
651     modifier conversionsAllowed {
652         assert(conversionsEnabled);
653         _;
654     }
655 
656     // allows execution by the BancorNetwork contract only
657     modifier bancorNetworkOnly {
658         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
659         require(msg.sender == address(bancorNetwork));
660         _;
661     }
662 
663     /**
664         @dev returns the number of connector tokens defined
665 
666         @return number of connector tokens
667     */
668     function connectorTokenCount() public view returns (uint16) {
669         return uint16(connectorTokens.length);
670     }
671 
672     /*
673         @dev allows the owner to update the contract registry contract address
674 
675         @param _registry   address of a contract registry contract
676     */
677     function setRegistry(IContractRegistry _registry)
678         public
679         ownerOnly
680         validAddress(_registry)
681         notThis(_registry)
682     {
683         registry = _registry;
684     }
685 
686     /*
687         @dev allows the owner to update & enable the conversion whitelist contract address
688         when set, only addresses that are whitelisted are actually allowed to use the converter
689         note that the whitelist check is actually done by the BancorNetwork contract
690 
691         @param _whitelist    address of a whitelist contract
692     */
693     function setConversionWhitelist(IWhitelist _whitelist)
694         public
695         ownerOnly
696         notThis(_whitelist)
697     {
698         conversionWhitelist = _whitelist;
699     }
700 
701     /*
702         @dev allows the manager to update the quick buy path
703 
704         @param _path    new quick buy path, see conversion path format in the bancorNetwork contract
705     */
706     function setQuickBuyPath(IERC20Token[] _path)
707         public
708         ownerOnly
709         validConversionPath(_path)
710     {
711         quickBuyPath = _path;
712     }
713 
714     /*
715         @dev allows the manager to clear the quick buy path
716     */
717     function clearQuickBuyPath() public ownerOnly {
718         quickBuyPath.length = 0;
719     }
720 
721     /**
722         @dev returns the length of the quick buy path array
723 
724         @return quick buy path length
725     */
726     function getQuickBuyPathLength() public view returns (uint256) {
727         return quickBuyPath.length;
728     }
729 
730     /**
731         @dev disables the entire conversion functionality
732         this is a safety mechanism in case of a emergency
733         can only be called by the manager
734 
735         @param _disable true to disable conversions, false to re-enable them
736     */
737     function disableConversions(bool _disable) public ownerOrManagerOnly {
738         conversionsEnabled = !_disable;
739     }
740 
741     /**
742         @dev updates the current conversion fee
743         can only be called by the manager
744 
745         @param _conversionFee new conversion fee, represented in ppm
746     */
747     function setConversionFee(uint32 _conversionFee)
748         public
749         ownerOrManagerOnly
750         validConversionFee(_conversionFee)
751     {
752         emit ConversionFeeUpdate(conversionFee, _conversionFee);
753         conversionFee = _conversionFee;
754     }
755 
756     /*
757         @dev given a return amount, returns the amount minus the conversion fee
758 
759         @param _amount      return amount
760         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
761 
762         @return return amount minus conversion fee
763     */
764     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
765         return safeMul(_amount, (MAX_CONVERSION_FEE - conversionFee) ** _magnitude) / MAX_CONVERSION_FEE ** _magnitude;
766     }
767 
768     /**
769         @dev defines a new connector for the token
770         can only be called by the owner while the converter is inactive
771 
772         @param _token                  address of the connector token
773         @param _weight                 constant connector weight, represented in ppm, 1-1000000
774         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
775     */
776     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
777         public
778         ownerOnly
779         inactive
780         validAddress(_token)
781         notThis(_token)
782         validConnectorWeight(_weight)
783     {
784         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
785 
786         connectors[_token].virtualBalance = 0;
787         connectors[_token].weight = _weight;
788         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
789         connectors[_token].isPurchaseEnabled = true;
790         connectors[_token].isSet = true;
791         connectorTokens.push(_token);
792         totalConnectorWeight += _weight;
793     }
794 
795     /**
796         @dev updates one of the token connectors
797         can only be called by the owner
798 
799         @param _connectorToken         address of the connector token
800         @param _weight                 constant connector weight, represented in ppm, 1-1000000
801         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
802         @param _virtualBalance         new connector's virtual balance
803     */
804     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
805         public
806         ownerOnly
807         validConnector(_connectorToken)
808         validConnectorWeight(_weight)
809     {
810         Connector storage connector = connectors[_connectorToken];
811         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
812 
813         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
814         connector.weight = _weight;
815         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
816         connector.virtualBalance = _virtualBalance;
817     }
818 
819     /**
820         @dev disables purchasing with the given connector token in case the connector token got compromised
821         can only be called by the owner
822         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
823 
824         @param _connectorToken  connector token contract address
825         @param _disable         true to disable the token, false to re-enable it
826     */
827     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
828         public
829         ownerOnly
830         validConnector(_connectorToken)
831     {
832         connectors[_connectorToken].isPurchaseEnabled = !_disable;
833     }
834 
835     /**
836         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
837 
838         @param _connectorToken  connector token contract address
839 
840         @return connector balance
841     */
842     function getConnectorBalance(IERC20Token _connectorToken)
843         public
844         view
845         validConnector(_connectorToken)
846         returns (uint256)
847     {
848         Connector storage connector = connectors[_connectorToken];
849         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
850     }
851 
852     /**
853         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
854 
855         @param _fromToken  ERC20 token to convert from
856         @param _toToken    ERC20 token to convert to
857         @param _amount     amount to convert, in fromToken
858 
859         @return expected conversion return amount
860     */
861     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
862         require(_fromToken != _toToken); // validate input
863 
864         // conversion between the token and one of its connectors
865         if (_toToken == token)
866             return getPurchaseReturn(_fromToken, _amount);
867         else if (_fromToken == token)
868             return getSaleReturn(_toToken, _amount);
869 
870         // conversion between 2 connectors
871         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
872     }
873 
874     /**
875         @dev returns the expected return for buying the token for a connector token
876 
877         @param _connectorToken  connector token contract address
878         @param _depositAmount   amount to deposit (in the connector token)
879 
880         @return expected purchase return amount
881     */
882     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
883         public
884         view
885         active
886         validConnector(_connectorToken)
887         returns (uint256)
888     {
889         Connector storage connector = connectors[_connectorToken];
890         require(connector.isPurchaseEnabled); // validate input
891 
892         uint256 tokenSupply = token.totalSupply();
893         uint256 connectorBalance = getConnectorBalance(_connectorToken);
894         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
895         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
896 
897         // return the amount minus the conversion fee
898         return getFinalAmount(amount, 1);
899     }
900 
901     /**
902         @dev returns the expected return for selling the token for one of its connector tokens
903 
904         @param _connectorToken  connector token contract address
905         @param _sellAmount      amount to sell (in the smart token)
906 
907         @return expected sale return amount
908     */
909     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
910         public
911         view
912         active
913         validConnector(_connectorToken)
914         returns (uint256)
915     {
916         Connector storage connector = connectors[_connectorToken];
917         uint256 tokenSupply = token.totalSupply();
918         uint256 connectorBalance = getConnectorBalance(_connectorToken);
919         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
920         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
921 
922         // return the amount minus the conversion fee
923         return getFinalAmount(amount, 1);
924     }
925 
926     /**
927         @dev returns the expected return for selling one of the connector tokens for another connector token
928 
929         @param _fromConnectorToken  contract address of the connector token to convert from
930         @param _toConnectorToken    contract address of the connector token to convert to
931         @param _sellAmount          amount to sell (in the from connector token)
932 
933         @return expected sale return amount (in the to connector token)
934     */
935     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
936         public
937         view
938         active
939         validConnector(_fromConnectorToken)
940         validConnector(_toConnectorToken)
941         returns (uint256)
942     {
943         Connector storage fromConnector = connectors[_fromConnectorToken];
944         Connector storage toConnector = connectors[_toConnectorToken];
945         require(toConnector.isPurchaseEnabled); // validate input
946 
947         uint256 fromConnectorBalance = getConnectorBalance(_fromConnectorToken);
948         uint256 toConnectorBalance = getConnectorBalance(_toConnectorToken);
949 
950         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
951         uint256 amount = formula.calculateCrossConnectorReturn(fromConnectorBalance, fromConnector.weight, toConnectorBalance, toConnector.weight, _sellAmount);
952 
953         // return the amount minus the conversion fee
954         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
955         return getFinalAmount(amount, 2);
956     }
957 
958     /**
959         @dev converts a specific amount of _fromToken to _toToken
960 
961         @param _fromToken  ERC20 token to convert from
962         @param _toToken    ERC20 token to convert to
963         @param _amount     amount to convert, in fromToken
964         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
965 
966         @return conversion return amount
967     */
968     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
969         public
970         bancorNetworkOnly
971         conversionsAllowed
972         greaterThanZero(_minReturn)
973         returns (uint256)
974     {
975         require(_fromToken != _toToken); // validate input
976 
977         // conversion between the token and one of its connectors
978         if (_toToken == token)
979             return buy(_fromToken, _amount, _minReturn);
980         else if (_fromToken == token)
981             return sell(_toToken, _amount, _minReturn);
982 
983         // conversion between 2 connectors
984         uint256 amount = getCrossConnectorReturn(_fromToken, _toToken, _amount);
985         // ensure the trade gives something in return and meets the minimum requested amount
986         require(amount != 0 && amount >= _minReturn);
987 
988         // update the source token virtual balance if relevant
989         Connector storage fromConnector = connectors[_fromToken];
990         if (fromConnector.isVirtualBalanceEnabled)
991             fromConnector.virtualBalance = safeAdd(fromConnector.virtualBalance, _amount);
992 
993         // update the target token virtual balance if relevant
994         Connector storage toConnector = connectors[_toToken];
995         if (toConnector.isVirtualBalanceEnabled)
996             toConnector.virtualBalance = safeSub(toConnector.virtualBalance, amount);
997 
998         // ensure that the trade won't deplete the connector balance
999         uint256 toConnectorBalance = getConnectorBalance(_toToken);
1000         assert(amount < toConnectorBalance);
1001 
1002         // transfer funds from the caller in the from connector token
1003         assert(_fromToken.transferFrom(msg.sender, this, _amount));
1004         // transfer funds to the caller in the to connector token
1005         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1006         assert(_toToken.transfer(msg.sender, amount));
1007 
1008         // calculate conversion fee and dispatch the conversion event
1009         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
1010         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 2));
1011         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1012 
1013         // dispatch price data updates for the smart token / both connectors
1014         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
1015         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
1016         return amount;
1017     }
1018 
1019     /**
1020         @dev converts a specific amount of _fromToken to _toToken
1021 
1022         @param _fromToken  ERC20 token to convert from
1023         @param _toToken    ERC20 token to convert to
1024         @param _amount     amount to convert, in fromToken
1025         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1026 
1027         @return conversion return amount
1028     */
1029     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1030         convertPath = [_fromToken, token, _toToken];
1031         return quickConvert(convertPath, _amount, _minReturn);
1032     }
1033 
1034     /**
1035         @dev buys the token by depositing one of its connector tokens
1036 
1037         @param _connectorToken  connector token contract address
1038         @param _depositAmount   amount to deposit (in the connector token)
1039         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1040 
1041         @return buy return amount
1042     */
1043     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1044         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
1045         // ensure the trade gives something in return and meets the minimum requested amount
1046         require(amount != 0 && amount >= _minReturn);
1047 
1048         // update virtual balance if relevant
1049         Connector storage connector = connectors[_connectorToken];
1050         if (connector.isVirtualBalanceEnabled)
1051             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
1052 
1053         // transfer funds from the caller in the connector token
1054         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
1055         // issue new funds to the caller in the smart token
1056         token.issue(msg.sender, amount);
1057 
1058         // calculate conversion fee and dispatch the conversion event
1059         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
1060         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
1061 
1062         // dispatch price data update for the smart token/connector
1063         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1064         return amount;
1065     }
1066 
1067     /**
1068         @dev sells the token by withdrawing from one of its connector tokens
1069 
1070         @param _connectorToken  connector token contract address
1071         @param _sellAmount      amount to sell (in the smart token)
1072         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1073 
1074         @return sell return amount
1075     */
1076     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1077         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1078 
1079         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
1080         // ensure the trade gives something in return and meets the minimum requested amount
1081         require(amount != 0 && amount >= _minReturn);
1082 
1083         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1084         uint256 tokenSupply = token.totalSupply();
1085         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1086         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1087 
1088         // update virtual balance if relevant
1089         Connector storage connector = connectors[_connectorToken];
1090         if (connector.isVirtualBalanceEnabled)
1091             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1092 
1093         // destroy _sellAmount from the caller's balance in the smart token
1094         token.destroy(msg.sender, _sellAmount);
1095         // transfer funds to the caller in the connector token
1096         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1097         assert(_connectorToken.transfer(msg.sender, amount));
1098 
1099         // calculate conversion fee and dispatch the conversion event
1100         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
1101         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1102 
1103         // dispatch price data update for the smart token/connector
1104         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1105         return amount;
1106     }
1107 
1108     /**
1109         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1110         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1111 
1112         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1113         @param _amount      amount to convert from (in the initial source token)
1114         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1115 
1116         @return tokens issued in return
1117     */
1118     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1119         public
1120         payable
1121         validConversionPath(_path)
1122         returns (uint256)
1123     {
1124         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1125     }
1126 
1127     /**
1128         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1129         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1130 
1131         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1132         @param _amount      amount to convert from (in the initial source token)
1133         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1134         @param _block       if the current block exceeded the given parameter - it is cancelled
1135         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1136         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1137         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1138 
1139         @return tokens issued in return
1140     */
1141     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1142         public
1143         payable
1144         validConversionPath(_path)
1145         returns (uint256)
1146     {
1147         IERC20Token fromToken = _path[0];
1148         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1149 
1150         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1151         // so it can execute the conversion on behalf of the caller
1152         if (msg.value == 0) {
1153             // not ETH, send the source tokens to the BancorNetwork contract
1154             // if the token is the smart token, no allowance is required - destroy the tokens
1155             // from the caller and issue them to the BancorNetwork contract
1156             if (fromToken == token) {
1157                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1158                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1159             } else {
1160                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1161                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1162             }
1163         }
1164 
1165         // execute the conversion and pass on the ETH with the call
1166         return bancorNetwork.convertForPrioritized2.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _v, _r, _s);
1167     }
1168 
1169     // deprecated, backward compatibility
1170     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1171         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1172     }
1173 
1174     /**
1175         @dev helper, dispatches the Conversion event
1176 
1177         @param _fromToken       ERC20 token to convert from
1178         @param _toToken         ERC20 token to convert to
1179         @param _amount          amount purchased/sold (in the source token)
1180         @param _returnAmount    amount returned (in the target token)
1181     */
1182     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1183         // fee amount is converted to 255 bits -
1184         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1185         // currently the fee is always taken from the target token
1186         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1187         assert(_feeAmount <= 2 ** 255);
1188         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1189     }
1190 
1191     /**
1192         @dev fallback, buys the smart token with ETH
1193         note that the purchase will use the price at the time of the purchase
1194     */
1195     function() payable public {
1196         quickConvert(quickBuyPath, msg.value, 1);
1197     }
1198 }