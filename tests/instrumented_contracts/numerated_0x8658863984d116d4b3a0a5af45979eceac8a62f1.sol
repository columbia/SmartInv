1 pragma solidity ^0.4.21;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public view returns (address) {}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public view returns (string) {}
20     function symbol() public view returns (string) {}
21     function decimals() public view returns (uint8) {}
22     function totalSupply() public view returns (uint256) {}
23     function balanceOf(address _owner) public view returns (uint256) { _owner; }
24     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     Smart Token interface
33 */
34 contract ISmartToken is IOwned, IERC20Token {
35     function disableTransfers(bool _disable) public;
36     function issue(address _to, uint256 _amount) public;
37     function destroy(address _from, uint256 _amount) public;
38 }
39 
40 /*
41     Contract Registry interface
42 */
43 contract IContractRegistry {
44     function getAddress(bytes32 _contractName) public view returns (address);
45 }
46 
47 /*
48     Contract Features interface
49 */
50 contract IContractFeatures {
51     function isSupported(address _contract, uint256 _features) public view returns (bool);
52     function enableFeatures(uint256 _features, bool _enable) public;
53 }
54 
55 /*
56     Whitelist interface
57 */
58 contract IWhitelist {
59     function isWhitelisted(address _address) public view returns (bool);
60 }
61 
62 /*
63     Token Holder interface
64 */
65 contract ITokenHolder is IOwned {
66     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
67 }
68 
69 /*
70     Bancor Formula interface
71 */
72 contract IBancorFormula {
73     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
74     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
75     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
76 }
77 
78 /*
79     Bancor Converter interface
80 */
81 contract IBancorConverter {
82     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
83     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
84     function conversionWhitelist() public view returns (IWhitelist) {}
85     // deprecated, backward compatibility
86     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
87 }
88 
89 /*
90     Bancor Network interface
91 */
92 contract IBancorNetwork {
93     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
94     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
95     function convertForPrioritized2(
96         IERC20Token[] _path,
97         uint256 _amount,
98         uint256 _minReturn,
99         address _for,
100         uint256 _block,
101         uint8 _v,
102         bytes32 _r,
103         bytes32 _s)
104         public payable returns (uint256);
105 
106     // deprecated, backward compatibility
107     function convertForPrioritized(
108         IERC20Token[] _path,
109         uint256 _amount,
110         uint256 _minReturn,
111         address _for,
112         uint256 _block,
113         uint256 _nonce,
114         uint8 _v,
115         bytes32 _r,
116         bytes32 _s)
117         public payable returns (uint256);
118 }
119 
120 /*
121     Utilities & Common Modifiers
122 */
123 contract Utils {
124     /**
125         constructor
126     */
127     function Utils() public {
128     }
129 
130     // verifies that an amount is greater than zero
131     modifier greaterThanZero(uint256 _amount) {
132         require(_amount > 0);
133         _;
134     }
135 
136     // validates an address - currently only checks that it isn't null
137     modifier validAddress(address _address) {
138         require(_address != address(0));
139         _;
140     }
141 
142     // verifies that the address is different than this contract address
143     modifier notThis(address _address) {
144         require(_address != address(this));
145         _;
146     }
147 
148     // Overflow protected math functions
149 
150     /**
151         @dev returns the sum of _x and _y, asserts if the calculation overflows
152 
153         @param _x   value 1
154         @param _y   value 2
155 
156         @return sum
157     */
158     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
159         uint256 z = _x + _y;
160         assert(z >= _x);
161         return z;
162     }
163 
164     /**
165         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
166 
167         @param _x   minuend
168         @param _y   subtrahend
169 
170         @return difference
171     */
172     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
173         assert(_x >= _y);
174         return _x - _y;
175     }
176 
177     /**
178         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
179 
180         @param _x   factor 1
181         @param _y   factor 2
182 
183         @return product
184     */
185     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
186         uint256 z = _x * _y;
187         assert(_x == 0 || z / _x == _y);
188         return z;
189     }
190 }
191 
192 /*
193     Provides support and utilities for contract ownership
194 */
195 contract Owned is IOwned {
196     address public owner;
197     address public newOwner;
198 
199     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
200 
201     /**
202         @dev constructor
203     */
204     function Owned() public {
205         owner = msg.sender;
206     }
207 
208     // allows execution by the owner only
209     modifier ownerOnly {
210         assert(msg.sender == owner);
211         _;
212     }
213 
214     /**
215         @dev allows transferring the contract ownership
216         the new owner still needs to accept the transfer
217         can only be called by the contract owner
218 
219         @param _newOwner    new contract owner
220     */
221     function transferOwnership(address _newOwner) public ownerOnly {
222         require(_newOwner != owner);
223         newOwner = _newOwner;
224     }
225 
226     /**
227         @dev used by a new owner to accept an ownership transfer
228     */
229     function acceptOwnership() public {
230         require(msg.sender == newOwner);
231         emit OwnerUpdate(owner, newOwner);
232         owner = newOwner;
233         newOwner = address(0);
234     }
235 }
236 
237 /*
238     Provides support and utilities for contract management
239     Note that a managed contract must also have an owner
240 */
241 contract Managed is Owned {
242     address public manager;
243     address public newManager;
244 
245     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
246 
247     /**
248         @dev constructor
249     */
250     function Managed() public {
251         manager = msg.sender;
252     }
253 
254     // allows execution by the manager only
255     modifier managerOnly {
256         assert(msg.sender == manager);
257         _;
258     }
259 
260     // allows execution by either the owner or the manager only
261     modifier ownerOrManagerOnly {
262         require(msg.sender == owner || msg.sender == manager);
263         _;
264     }
265 
266     /**
267         @dev allows transferring the contract management
268         the new manager still needs to accept the transfer
269         can only be called by the contract manager
270 
271         @param _newManager    new contract manager
272     */
273     function transferManagement(address _newManager) public ownerOrManagerOnly {
274         require(_newManager != manager);
275         newManager = _newManager;
276     }
277 
278     /**
279         @dev used by a new manager to accept a management transfer
280     */
281     function acceptManagement() public {
282         require(msg.sender == newManager);
283         emit ManagerUpdate(manager, newManager);
284         manager = newManager;
285         newManager = address(0);
286     }
287 }
288 
289 /**
290     Id definitions for bancor contracts
291 
292     Can be used in conjunction with the contract registry to get contract addresses
293 */
294 contract ContractIds {
295     // generic
296     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
297 
298     // bancor logic
299     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
300     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
301     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
302 
303     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
304     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
305 
306     // tokens
307     bytes32 public constant BNT_TOKEN = "BNTToken";
308 }
309 
310 /**
311     Id definitions for bancor contract features
312 
313     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
314 */
315 contract FeatureIds {
316     // converter features
317     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
318 }
319 
320 /*
321     We consider every contract to be a 'token holder' since it's currently not possible
322     for a contract to deny receiving tokens.
323 
324     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
325     the owner to send tokens that were sent to the contract by mistake back to their sender.
326 */
327 contract TokenHolder is ITokenHolder, Owned, Utils {
328     /**
329         @dev constructor
330     */
331     function TokenHolder() public {
332     }
333 
334     /**
335         @dev withdraws tokens held by the contract and sends them to an account
336         can only be called by the owner
337 
338         @param _token   ERC20 token contract address
339         @param _to      account to receive the new amount
340         @param _amount  amount to withdraw
341     */
342     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
343         public
344         ownerOnly
345         validAddress(_token)
346         validAddress(_to)
347         notThis(_to)
348     {
349         assert(_token.transfer(_to, _amount));
350     }
351 }
352 
353 /*
354     The smart token controller is an upgradable part of the smart token that allows
355     more functionality as well as fixes for bugs/exploits.
356     Once it accepts ownership of the token, it becomes the token's sole controller
357     that can execute any of its functions.
358 
359     To upgrade the controller, ownership must be transferred to a new controller, along with
360     any relevant data.
361 
362     The smart token must be set on construction and cannot be changed afterwards.
363     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
364 
365     Note that the controller can transfer token ownership to a new controller that
366     doesn't allow executing any function on the token, for a trustless solution.
367     Doing that will also remove the owner's ability to upgrade the controller.
368 */
369 contract SmartTokenController is TokenHolder {
370     ISmartToken public token;   // smart token
371 
372     /**
373         @dev constructor
374     */
375     function SmartTokenController(ISmartToken _token)
376         public
377         validAddress(_token)
378     {
379         token = _token;
380     }
381 
382     // ensures that the controller is the token's owner
383     modifier active() {
384         assert(token.owner() == address(this));
385         _;
386     }
387 
388     // ensures that the controller is not the token's owner
389     modifier inactive() {
390         assert(token.owner() != address(this));
391         _;
392     }
393 
394     /**
395         @dev allows transferring the token ownership
396         the new owner still need to accept the transfer
397         can only be called by the contract owner
398 
399         @param _newOwner    new token owner
400     */
401     function transferTokenOwnership(address _newOwner) public ownerOnly {
402         token.transferOwnership(_newOwner);
403     }
404 
405     /**
406         @dev used by a new owner to accept a token ownership transfer
407         can only be called by the contract owner
408     */
409     function acceptTokenOwnership() public ownerOnly {
410         token.acceptOwnership();
411     }
412 
413     /**
414         @dev disables/enables token transfers
415         can only be called by the contract owner
416 
417         @param _disable    true to disable transfers, false to enable them
418     */
419     function disableTokenTransfers(bool _disable) public ownerOnly {
420         token.disableTransfers(_disable);
421     }
422 
423     /**
424         @dev withdraws tokens held by the controller and sends them to an account
425         can only be called by the owner
426 
427         @param _token   ERC20 token contract address
428         @param _to      account to receive the new amount
429         @param _amount  amount to withdraw
430     */
431     function withdrawFromToken(
432         IERC20Token _token, 
433         address _to, 
434         uint256 _amount
435     ) 
436         public
437         ownerOnly
438     {
439         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
440     }
441 }
442 
443 /*
444     Bancor Converter v0.9
445 
446     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
447 
448     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
449     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
450 
451     The converter is upgradable (just like any SmartTokenController).
452 
453     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
454              or with very small numbers because of precision loss
455 
456     Open issues:
457     - Front-running attacks are currently mitigated by the following mechanisms:
458         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
459         - gas price limit prevents users from having control over the order of execution
460         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
461       Other potential solutions might include a commit/reveal based schemes
462     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
463 */
464 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
465     uint32 private constant MAX_WEIGHT = 1000000;
466     uint64 private constant MAX_CONVERSION_FEE = 1000000;
467 
468     struct Connector {
469         uint256 virtualBalance;         // connector virtual balance
470         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
471         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
472         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
473         bool isSet;                     // used to tell if the mapping element is defined
474     }
475 
476     string public version = '0.9';
477     string public converterType = 'bancor';
478 
479     IContractRegistry public registry;                  // contract registry contract
480     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
481     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
482     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
483     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
484     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
485     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
486                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
487     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
488     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
489     IERC20Token[] private convertPath;
490 
491     // triggered when a conversion between two tokens occurs
492     event Conversion(
493         address indexed _fromToken,
494         address indexed _toToken,
495         address indexed _trader,
496         uint256 _amount,
497         uint256 _return,
498         int256 _conversionFee
499     );
500     // triggered after a conversion with new price data
501     event PriceDataUpdate(
502         address indexed _connectorToken,
503         uint256 _tokenSupply,
504         uint256 _connectorBalance,
505         uint32 _connectorWeight
506     );
507     // triggered when the conversion fee is updated
508     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
509 
510     /**
511         @dev constructor
512 
513         @param  _token              smart token governed by the converter
514         @param  _registry           address of a contract registry contract
515         @param  _maxConversionFee   maximum conversion fee, represented in ppm
516         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
517         @param  _connectorWeight    optional, weight for the initial connector
518     */
519     function BancorConverter(
520         ISmartToken _token,
521         IContractRegistry _registry,
522         uint32 _maxConversionFee,
523         IERC20Token _connectorToken,
524         uint32 _connectorWeight
525     )
526         public
527         SmartTokenController(_token)
528         validAddress(_registry)
529         validMaxConversionFee(_maxConversionFee)
530     {
531         registry = _registry;
532         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
533 
534         // initialize supported features
535         if (features != address(0))
536             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
537 
538         maxConversionFee = _maxConversionFee;
539 
540         if (_connectorToken != address(0))
541             addConnector(_connectorToken, _connectorWeight, false);
542     }
543 
544     // validates a connector token address - verifies that the address belongs to one of the connector tokens
545     modifier validConnector(IERC20Token _address) {
546         require(connectors[_address].isSet);
547         _;
548     }
549 
550     // validates a token address - verifies that the address belongs to one of the convertible tokens
551     modifier validToken(IERC20Token _address) {
552         require(_address == token || connectors[_address].isSet);
553         _;
554     }
555 
556     // validates maximum conversion fee
557     modifier validMaxConversionFee(uint32 _conversionFee) {
558         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
559         _;
560     }
561 
562     // validates conversion fee
563     modifier validConversionFee(uint32 _conversionFee) {
564         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
565         _;
566     }
567 
568     // validates connector weight range
569     modifier validConnectorWeight(uint32 _weight) {
570         require(_weight > 0 && _weight <= MAX_WEIGHT);
571         _;
572     }
573 
574     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
575     modifier validConversionPath(IERC20Token[] _path) {
576         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
577         _;
578     }
579 
580     // allows execution only when conversions aren't disabled
581     modifier conversionsAllowed {
582         assert(conversionsEnabled);
583         _;
584     }
585 
586     // allows execution by the BancorNetwork contract only
587     modifier bancorNetworkOnly {
588         IBancorNetwork bancorNetwork = IBancorNetwork(registry.getAddress(ContractIds.BANCOR_NETWORK));
589         require(msg.sender == address(bancorNetwork));
590         _;
591     }
592 
593     /**
594         @dev returns the number of connector tokens defined
595 
596         @return number of connector tokens
597     */
598     function connectorTokenCount() public view returns (uint16) {
599         return uint16(connectorTokens.length);
600     }
601 
602     /*
603         @dev allows the owner to update the registry contract address
604 
605         @param _registry    address of a bancor converter registry contract
606     */
607     function setRegistry(IContractRegistry _registry)
608         public
609         ownerOnly
610         validAddress(_registry)
611         notThis(_registry)
612     {
613         registry = _registry;
614     }
615 
616     /*
617         @dev allows the owner to update & enable the conversion whitelist contract address
618         when set, only addresses that are whitelisted are actually allowed to use the converter
619         note that the whitelist check is actually done by the BancorNetwork contract
620 
621         @param _whitelist    address of a whitelist contract
622     */
623     function setConversionWhitelist(IWhitelist _whitelist)
624         public
625         ownerOnly
626         notThis(_whitelist)
627     {
628         conversionWhitelist = _whitelist;
629     }
630 
631     /*
632         @dev allows the manager to update the quick buy path
633 
634         @param _path    new quick buy path, see conversion path format in the bancorNetwork contract
635     */
636     function setQuickBuyPath(IERC20Token[] _path)
637         public
638         ownerOnly
639         validConversionPath(_path)
640     {
641         quickBuyPath = _path;
642     }
643 
644     /*
645         @dev allows the manager to clear the quick buy path
646     */
647     function clearQuickBuyPath() public ownerOnly {
648         quickBuyPath.length = 0;
649     }
650 
651     /**
652         @dev returns the length of the quick buy path array
653 
654         @return quick buy path length
655     */
656     function getQuickBuyPathLength() public view returns (uint256) {
657         return quickBuyPath.length;
658     }
659 
660     /**
661         @dev disables the entire conversion functionality
662         this is a safety mechanism in case of a emergency
663         can only be called by the manager
664 
665         @param _disable true to disable conversions, false to re-enable them
666     */
667     function disableConversions(bool _disable) public ownerOrManagerOnly {
668         conversionsEnabled = !_disable;
669     }
670 
671     /**
672         @dev updates the current conversion fee
673         can only be called by the manager
674 
675         @param _conversionFee new conversion fee, represented in ppm
676     */
677     function setConversionFee(uint32 _conversionFee)
678         public
679         ownerOrManagerOnly
680         validConversionFee(_conversionFee)
681     {
682         emit ConversionFeeUpdate(conversionFee, _conversionFee);
683         conversionFee = _conversionFee;
684     }
685 
686     /*
687         @dev given a return amount, returns the amount minus the conversion fee
688 
689         @param _amount      return amount
690         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
691 
692         @return return amount minus conversion fee
693     */
694     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
695         return safeMul(_amount, (MAX_CONVERSION_FEE - conversionFee) ** _magnitude) / MAX_CONVERSION_FEE ** _magnitude;
696     }
697 
698     /**
699         @dev defines a new connector for the token
700         can only be called by the owner while the converter is inactive
701 
702         @param _token                  address of the connector token
703         @param _weight                 constant connector weight, represented in ppm, 1-1000000
704         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
705     */
706     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
707         public
708         ownerOnly
709         inactive
710         validAddress(_token)
711         notThis(_token)
712         validConnectorWeight(_weight)
713     {
714         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
715 
716         connectors[_token].virtualBalance = 0;
717         connectors[_token].weight = _weight;
718         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
719         connectors[_token].isPurchaseEnabled = true;
720         connectors[_token].isSet = true;
721         connectorTokens.push(_token);
722         totalConnectorWeight += _weight;
723     }
724 
725     /**
726         @dev updates one of the token connectors
727         can only be called by the owner
728 
729         @param _connectorToken         address of the connector token
730         @param _weight                 constant connector weight, represented in ppm, 1-1000000
731         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
732         @param _virtualBalance         new connector's virtual balance
733     */
734     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
735         public
736         ownerOnly
737         validConnector(_connectorToken)
738         validConnectorWeight(_weight)
739     {
740         Connector storage connector = connectors[_connectorToken];
741         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
742 
743         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
744         connector.weight = _weight;
745         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
746         connector.virtualBalance = _virtualBalance;
747     }
748 
749     /**
750         @dev disables purchasing with the given connector token in case the connector token got compromised
751         can only be called by the owner
752         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
753 
754         @param _connectorToken  connector token contract address
755         @param _disable         true to disable the token, false to re-enable it
756     */
757     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
758         public
759         ownerOnly
760         validConnector(_connectorToken)
761     {
762         connectors[_connectorToken].isPurchaseEnabled = !_disable;
763     }
764 
765     /**
766         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
767 
768         @param _connectorToken  connector token contract address
769 
770         @return connector balance
771     */
772     function getConnectorBalance(IERC20Token _connectorToken)
773         public
774         view
775         validConnector(_connectorToken)
776         returns (uint256)
777     {
778         Connector storage connector = connectors[_connectorToken];
779         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
780     }
781 
782     /**
783         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
784 
785         @param _fromToken  ERC20 token to convert from
786         @param _toToken    ERC20 token to convert to
787         @param _amount     amount to convert, in fromToken
788 
789         @return expected conversion return amount
790     */
791     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
792         require(_fromToken != _toToken); // validate input
793 
794         // conversion between the token and one of its connectors
795         if (_toToken == token)
796             return getPurchaseReturn(_fromToken, _amount);
797         else if (_fromToken == token)
798             return getSaleReturn(_toToken, _amount);
799 
800         // conversion between 2 connectors
801         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
802     }
803 
804     /**
805         @dev returns the expected return for buying the token for a connector token
806 
807         @param _connectorToken  connector token contract address
808         @param _depositAmount   amount to deposit (in the connector token)
809 
810         @return expected purchase return amount
811     */
812     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
813         public
814         view
815         active
816         validConnector(_connectorToken)
817         returns (uint256)
818     {
819         Connector storage connector = connectors[_connectorToken];
820         require(connector.isPurchaseEnabled); // validate input
821 
822         uint256 tokenSupply = token.totalSupply();
823         uint256 connectorBalance = getConnectorBalance(_connectorToken);
824         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
825         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
826 
827         // return the amount minus the conversion fee
828         return getFinalAmount(amount, 1);
829     }
830 
831     /**
832         @dev returns the expected return for selling the token for one of its connector tokens
833 
834         @param _connectorToken  connector token contract address
835         @param _sellAmount      amount to sell (in the smart token)
836 
837         @return expected sale return amount
838     */
839     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
840         public
841         view
842         active
843         validConnector(_connectorToken)
844         returns (uint256)
845     {
846         Connector storage connector = connectors[_connectorToken];
847         uint256 tokenSupply = token.totalSupply();
848         uint256 connectorBalance = getConnectorBalance(_connectorToken);
849         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
850         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
851 
852         // return the amount minus the conversion fee
853         return getFinalAmount(amount, 1);
854     }
855 
856     /**
857         @dev returns the expected return for selling one of the connector tokens for another connector token
858 
859         @param _fromConnectorToken  contract address of the connector token to convert from
860         @param _toConnectorToken    contract address of the connector token to convert to
861         @param _sellAmount          amount to sell (in the from connector token)
862 
863         @return expected sale return amount (in the to connector token)
864     */
865     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
866         public
867         view
868         active
869         validConnector(_fromConnectorToken)
870         validConnector(_toConnectorToken)
871         returns (uint256)
872     {
873         Connector storage fromConnector = connectors[_fromConnectorToken];
874         Connector storage toConnector = connectors[_toConnectorToken];
875         require(toConnector.isPurchaseEnabled); // validate input
876 
877         uint256 fromConnectorBalance = getConnectorBalance(_fromConnectorToken);
878         uint256 toConnectorBalance = getConnectorBalance(_toConnectorToken);
879 
880         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
881         uint256 amount = formula.calculateCrossConnectorReturn(fromConnectorBalance, fromConnector.weight, toConnectorBalance, toConnector.weight, _sellAmount);
882 
883         // return the amount minus the conversion fee
884         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
885         return getFinalAmount(amount, 2);
886     }
887 
888     /**
889         @dev converts a specific amount of _fromToken to _toToken
890 
891         @param _fromToken  ERC20 token to convert from
892         @param _toToken    ERC20 token to convert to
893         @param _amount     amount to convert, in fromToken
894         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
895 
896         @return conversion return amount
897     */
898     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
899         public
900         bancorNetworkOnly
901         conversionsAllowed
902         greaterThanZero(_minReturn)
903         returns (uint256)
904     {
905         require(_fromToken != _toToken); // validate input
906 
907         // conversion between the token and one of its connectors
908         if (_toToken == token)
909             return buy(_fromToken, _amount, _minReturn);
910         else if (_fromToken == token)
911             return sell(_toToken, _amount, _minReturn);
912 
913         // conversion between 2 connectors
914         uint256 amount = getCrossConnectorReturn(_fromToken, _toToken, _amount);
915         // ensure the trade gives something in return and meets the minimum requested amount
916         require(amount != 0 && amount >= _minReturn);
917 
918         // update the source token virtual balance if relevant
919         Connector storage fromConnector = connectors[_fromToken];
920         if (fromConnector.isVirtualBalanceEnabled)
921             fromConnector.virtualBalance = safeAdd(fromConnector.virtualBalance, _amount);
922 
923         // update the target token virtual balance if relevant
924         Connector storage toConnector = connectors[_toToken];
925         if (toConnector.isVirtualBalanceEnabled)
926             toConnector.virtualBalance = safeSub(toConnector.virtualBalance, amount);
927 
928         // ensure that the trade won't deplete the connector balance
929         uint256 toConnectorBalance = getConnectorBalance(_toToken);
930         assert(amount < toConnectorBalance);
931 
932         // transfer funds from the caller in the from connector token
933         assert(_fromToken.transferFrom(msg.sender, this, _amount));
934         // transfer funds to the caller in the to connector token
935         // the transfer might fail if the actual connector balance is smaller than the virtual balance
936         assert(_toToken.transfer(msg.sender, amount));
937 
938         // calculate conversion fee and dispatch the conversion event
939         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
940         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 2));
941         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
942 
943         // dispatch price data updates for the smart token / both connectors
944         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
945         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
946         return amount;
947     }
948 
949     /**
950         @dev converts a specific amount of _fromToken to _toToken
951 
952         @param _fromToken  ERC20 token to convert from
953         @param _toToken    ERC20 token to convert to
954         @param _amount     amount to convert, in fromToken
955         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
956 
957         @return conversion return amount
958     */
959     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
960         convertPath = [_fromToken, token, _toToken];
961         return quickConvert(convertPath, _amount, _minReturn);
962     }
963 
964     /**
965         @dev buys the token by depositing one of its connector tokens
966 
967         @param _connectorToken  connector token contract address
968         @param _depositAmount   amount to deposit (in the connector token)
969         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
970 
971         @return buy return amount
972     */
973     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
974         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
975         // ensure the trade gives something in return and meets the minimum requested amount
976         require(amount != 0 && amount >= _minReturn);
977 
978         // update virtual balance if relevant
979         Connector storage connector = connectors[_connectorToken];
980         if (connector.isVirtualBalanceEnabled)
981             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
982 
983         // transfer funds from the caller in the connector token
984         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
985         // issue new funds to the caller in the smart token
986         token.issue(msg.sender, amount);
987 
988         // calculate conversion fee and dispatch the conversion event
989         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
990         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
991 
992         // dispatch price data update for the smart token/connector
993         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
994         return amount;
995     }
996 
997     /**
998         @dev sells the token by withdrawing from one of its connector tokens
999 
1000         @param _connectorToken  connector token contract address
1001         @param _sellAmount      amount to sell (in the smart token)
1002         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1003 
1004         @return sell return amount
1005     */
1006     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1007         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1008 
1009         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
1010         // ensure the trade gives something in return and meets the minimum requested amount
1011         require(amount != 0 && amount >= _minReturn);
1012 
1013         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1014         uint256 tokenSupply = token.totalSupply();
1015         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1016         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1017 
1018         // update virtual balance if relevant
1019         Connector storage connector = connectors[_connectorToken];
1020         if (connector.isVirtualBalanceEnabled)
1021             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1022 
1023         // destroy _sellAmount from the caller's balance in the smart token
1024         token.destroy(msg.sender, _sellAmount);
1025         // transfer funds to the caller in the connector token
1026         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1027         assert(_connectorToken.transfer(msg.sender, amount));
1028 
1029         // calculate conversion fee and dispatch the conversion event
1030         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
1031         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1032 
1033         // dispatch price data update for the smart token/connector
1034         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1035         return amount;
1036     }
1037 
1038     /**
1039         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1040         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1041 
1042         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1043         @param _amount      amount to convert from (in the initial source token)
1044         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1045 
1046         @return tokens issued in return
1047     */
1048     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1049         public
1050         payable
1051         validConversionPath(_path)
1052         returns (uint256)
1053     {
1054         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1055     }
1056 
1057     /**
1058         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1059         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1060 
1061         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1062         @param _amount      amount to convert from (in the initial source token)
1063         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1064         @param _block       if the current block exceeded the given parameter - it is cancelled
1065         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1066         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1067         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1068 
1069         @return tokens issued in return
1070     */
1071     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1072         public
1073         payable
1074         validConversionPath(_path)
1075         returns (uint256)
1076     {
1077         IERC20Token fromToken = _path[0];
1078         IBancorNetwork bancorNetwork = IBancorNetwork(registry.getAddress(ContractIds.BANCOR_NETWORK));
1079 
1080         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1081         // so it can execute the conversion on behalf of the caller
1082         if (msg.value == 0) {
1083             // not ETH, send the source tokens to the BancorNetwork contract
1084             // if the token is the smart token, no allowance is required - destroy the tokens
1085             // from the caller and issue them to the BancorNetwork contract
1086             if (fromToken == token) {
1087                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1088                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1089             } else {
1090                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1091                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1092             }
1093         }
1094 
1095         // execute the conversion and pass on the ETH with the call
1096         return bancorNetwork.convertForPrioritized2.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _v, _r, _s);
1097     }
1098 
1099     // deprecated, backward compatibility
1100     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1101         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1102     }
1103 
1104     /**
1105         @dev helper, dispatches the Conversion event
1106 
1107         @param _fromToken       ERC20 token to convert from
1108         @param _toToken         ERC20 token to convert to
1109         @param _amount          amount purchased/sold (in the source token)
1110         @param _returnAmount    amount returned (in the target token)
1111     */
1112     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1113         // fee amount is converted to 255 bits -
1114         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1115         // currently the fee is always taken from the target token
1116         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1117         assert(_feeAmount <= 2 ** 255);
1118         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1119     }
1120 
1121     /**
1122         @dev fallback, buys the smart token with ETH
1123         note that the purchase will use the price at the time of the purchase
1124     */
1125     function() payable public {
1126         quickConvert(quickBuyPath, msg.value, 1);
1127     }
1128 }