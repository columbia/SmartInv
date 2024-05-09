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
295     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
296     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
297     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
298 }
299 
300 /**
301     Id definitions for bancor contract features
302 
303     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
304 */
305 contract FeatureIds {
306     // converter features
307     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
308 }
309 
310 /*
311     We consider every contract to be a 'token holder' since it's currently not possible
312     for a contract to deny receiving tokens.
313 
314     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
315     the owner to send tokens that were sent to the contract by mistake back to their sender.
316 */
317 contract TokenHolder is ITokenHolder, Owned, Utils {
318     /**
319         @dev constructor
320     */
321     function TokenHolder() public {
322     }
323 
324     /**
325         @dev withdraws tokens held by the contract and sends them to an account
326         can only be called by the owner
327 
328         @param _token   ERC20 token contract address
329         @param _to      account to receive the new amount
330         @param _amount  amount to withdraw
331     */
332     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
333         public
334         ownerOnly
335         validAddress(_token)
336         validAddress(_to)
337         notThis(_to)
338     {
339         assert(_token.transfer(_to, _amount));
340     }
341 }
342 
343 /*
344     The smart token controller is an upgradable part of the smart token that allows
345     more functionality as well as fixes for bugs/exploits.
346     Once it accepts ownership of the token, it becomes the token's sole controller
347     that can execute any of its functions.
348 
349     To upgrade the controller, ownership must be transferred to a new controller, along with
350     any relevant data.
351 
352     The smart token must be set on construction and cannot be changed afterwards.
353     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
354 
355     Note that the controller can transfer token ownership to a new controller that
356     doesn't allow executing any function on the token, for a trustless solution.
357     Doing that will also remove the owner's ability to upgrade the controller.
358 */
359 contract SmartTokenController is TokenHolder {
360     ISmartToken public token;   // smart token
361 
362     /**
363         @dev constructor
364     */
365     function SmartTokenController(ISmartToken _token)
366         public
367         validAddress(_token)
368     {
369         token = _token;
370     }
371 
372     // ensures that the controller is the token's owner
373     modifier active() {
374         assert(token.owner() == address(this));
375         _;
376     }
377 
378     // ensures that the controller is not the token's owner
379     modifier inactive() {
380         assert(token.owner() != address(this));
381         _;
382     }
383 
384     /**
385         @dev allows transferring the token ownership
386         the new owner still need to accept the transfer
387         can only be called by the contract owner
388 
389         @param _newOwner    new token owner
390     */
391     function transferTokenOwnership(address _newOwner) public ownerOnly {
392         token.transferOwnership(_newOwner);
393     }
394 
395     /**
396         @dev used by a new owner to accept a token ownership transfer
397         can only be called by the contract owner
398     */
399     function acceptTokenOwnership() public ownerOnly {
400         token.acceptOwnership();
401     }
402 
403     /**
404         @dev disables/enables token transfers
405         can only be called by the contract owner
406 
407         @param _disable    true to disable transfers, false to enable them
408     */
409     function disableTokenTransfers(bool _disable) public ownerOnly {
410         token.disableTransfers(_disable);
411     }
412 
413     /**
414         @dev withdraws tokens held by the controller and sends them to an account
415         can only be called by the owner
416 
417         @param _token   ERC20 token contract address
418         @param _to      account to receive the new amount
419         @param _amount  amount to withdraw
420     */
421     function withdrawFromToken(
422         IERC20Token _token, 
423         address _to, 
424         uint256 _amount
425     ) 
426         public
427         ownerOnly
428     {
429         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
430     }
431 }
432 
433 /*
434     Bancor Converter v0.9
435 
436     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
437 
438     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
439     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
440 
441     The converter is upgradable (just like any SmartTokenController).
442 
443     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
444              or with very small numbers because of precision loss
445 
446     Open issues:
447     - Front-running attacks are currently mitigated by the following mechanisms:
448         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
449         - gas price limit prevents users from having control over the order of execution
450         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
451       Other potential solutions might include a commit/reveal based schemes
452     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
453 */
454 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
455     uint32 private constant MAX_WEIGHT = 1000000;
456     uint64 private constant MAX_CONVERSION_FEE = 1000000;
457 
458     struct Connector {
459         uint256 virtualBalance;         // connector virtual balance
460         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
461         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
462         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
463         bool isSet;                     // used to tell if the mapping element is defined
464     }
465 
466     string public version = '0.9';
467     string public converterType = 'bancor';
468 
469     IContractRegistry public registry;                  // contract registry contract
470     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
471     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
472     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
473     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
474     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
475     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
476                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
477     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
478     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
479     IERC20Token[] private convertPath;
480 
481     // triggered when a conversion between two tokens occurs
482     event Conversion(
483         address indexed _fromToken,
484         address indexed _toToken,
485         address indexed _trader,
486         uint256 _amount,
487         uint256 _return,
488         int256 _conversionFee
489     );
490     // triggered after a conversion with new price data
491     event PriceDataUpdate(
492         address indexed _connectorToken,
493         uint256 _tokenSupply,
494         uint256 _connectorBalance,
495         uint32 _connectorWeight
496     );
497     // triggered when the conversion fee is updated
498     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
499 
500     /**
501         @dev constructor
502 
503         @param  _token              smart token governed by the converter
504         @param  _registry           address of a contract registry contract
505         @param  _maxConversionFee   maximum conversion fee, represented in ppm
506         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
507         @param  _connectorWeight    optional, weight for the initial connector
508     */
509     function BancorConverter(
510         ISmartToken _token,
511         IContractRegistry _registry,
512         uint32 _maxConversionFee,
513         IERC20Token _connectorToken,
514         uint32 _connectorWeight
515     )
516         public
517         SmartTokenController(_token)
518         validAddress(_registry)
519         validMaxConversionFee(_maxConversionFee)
520     {
521         registry = _registry;
522         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
523 
524         // initialize supported features
525         if (features != address(0))
526             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
527 
528         maxConversionFee = _maxConversionFee;
529 
530         if (_connectorToken != address(0))
531             addConnector(_connectorToken, _connectorWeight, false);
532     }
533 
534     // validates a connector token address - verifies that the address belongs to one of the connector tokens
535     modifier validConnector(IERC20Token _address) {
536         require(connectors[_address].isSet);
537         _;
538     }
539 
540     // validates a token address - verifies that the address belongs to one of the convertible tokens
541     modifier validToken(IERC20Token _address) {
542         require(_address == token || connectors[_address].isSet);
543         _;
544     }
545 
546     // validates maximum conversion fee
547     modifier validMaxConversionFee(uint32 _conversionFee) {
548         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
549         _;
550     }
551 
552     // validates conversion fee
553     modifier validConversionFee(uint32 _conversionFee) {
554         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
555         _;
556     }
557 
558     // validates connector weight range
559     modifier validConnectorWeight(uint32 _weight) {
560         require(_weight > 0 && _weight <= MAX_WEIGHT);
561         _;
562     }
563 
564     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
565     modifier validConversionPath(IERC20Token[] _path) {
566         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
567         _;
568     }
569 
570     // allows execution only when conversions aren't disabled
571     modifier conversionsAllowed {
572         assert(conversionsEnabled);
573         _;
574     }
575 
576     // allows execution by the BancorNetwork contract only
577     modifier bancorNetworkOnly {
578         IBancorNetwork bancorNetwork = IBancorNetwork(registry.getAddress(ContractIds.BANCOR_NETWORK));
579         require(msg.sender == address(bancorNetwork));
580         _;
581     }
582 
583     /**
584         @dev returns the number of connector tokens defined
585 
586         @return number of connector tokens
587     */
588     function connectorTokenCount() public view returns (uint16) {
589         return uint16(connectorTokens.length);
590     }
591 
592     /*
593         @dev allows the owner to update the registry contract address
594 
595         @param _registry    address of a bancor converter registry contract
596     */
597     function setRegistry(IContractRegistry _registry)
598         public
599         ownerOnly
600         validAddress(_registry)
601         notThis(_registry)
602     {
603         registry = _registry;
604     }
605 
606     /*
607         @dev allows the owner to update & enable the conversion whitelist contract address
608         when set, only addresses that are whitelisted are actually allowed to use the converter
609         note that the whitelist check is actually done by the BancorNetwork contract
610 
611         @param _whitelist    address of a whitelist contract
612     */
613     function setConversionWhitelist(IWhitelist _whitelist)
614         public
615         ownerOnly
616         notThis(_whitelist)
617     {
618         conversionWhitelist = _whitelist;
619     }
620 
621     /*
622         @dev allows the manager to update the quick buy path
623 
624         @param _path    new quick buy path, see conversion path format in the bancorNetwork contract
625     */
626     function setQuickBuyPath(IERC20Token[] _path)
627         public
628         ownerOnly
629         validConversionPath(_path)
630     {
631         quickBuyPath = _path;
632     }
633 
634     /*
635         @dev allows the manager to clear the quick buy path
636     */
637     function clearQuickBuyPath() public ownerOnly {
638         quickBuyPath.length = 0;
639     }
640 
641     /**
642         @dev returns the length of the quick buy path array
643 
644         @return quick buy path length
645     */
646     function getQuickBuyPathLength() public view returns (uint256) {
647         return quickBuyPath.length;
648     }
649 
650     /**
651         @dev disables the entire conversion functionality
652         this is a safety mechanism in case of a emergency
653         can only be called by the manager
654 
655         @param _disable true to disable conversions, false to re-enable them
656     */
657     function disableConversions(bool _disable) public ownerOrManagerOnly {
658         conversionsEnabled = !_disable;
659     }
660 
661     /**
662         @dev updates the current conversion fee
663         can only be called by the manager
664 
665         @param _conversionFee new conversion fee, represented in ppm
666     */
667     function setConversionFee(uint32 _conversionFee)
668         public
669         ownerOrManagerOnly
670         validConversionFee(_conversionFee)
671     {
672         emit ConversionFeeUpdate(conversionFee, _conversionFee);
673         conversionFee = _conversionFee;
674     }
675 
676     /*
677         @dev given a return amount, returns the amount minus the conversion fee
678 
679         @param _amount      return amount
680         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
681 
682         @return return amount minus conversion fee
683     */
684     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
685         return safeMul(_amount, (MAX_CONVERSION_FEE - conversionFee) ** _magnitude) / MAX_CONVERSION_FEE ** _magnitude;
686     }
687 
688     /**
689         @dev defines a new connector for the token
690         can only be called by the owner while the converter is inactive
691 
692         @param _token                  address of the connector token
693         @param _weight                 constant connector weight, represented in ppm, 1-1000000
694         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
695     */
696     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
697         public
698         ownerOnly
699         inactive
700         validAddress(_token)
701         notThis(_token)
702         validConnectorWeight(_weight)
703     {
704         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
705 
706         connectors[_token].virtualBalance = 0;
707         connectors[_token].weight = _weight;
708         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
709         connectors[_token].isPurchaseEnabled = true;
710         connectors[_token].isSet = true;
711         connectorTokens.push(_token);
712         totalConnectorWeight += _weight;
713     }
714 
715     /**
716         @dev updates one of the token connectors
717         can only be called by the owner
718 
719         @param _connectorToken         address of the connector token
720         @param _weight                 constant connector weight, represented in ppm, 1-1000000
721         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
722         @param _virtualBalance         new connector's virtual balance
723     */
724     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
725         public
726         ownerOnly
727         validConnector(_connectorToken)
728         validConnectorWeight(_weight)
729     {
730         Connector storage connector = connectors[_connectorToken];
731         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
732 
733         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
734         connector.weight = _weight;
735         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
736         connector.virtualBalance = _virtualBalance;
737     }
738 
739     /**
740         @dev disables purchasing with the given connector token in case the connector token got compromised
741         can only be called by the owner
742         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
743 
744         @param _connectorToken  connector token contract address
745         @param _disable         true to disable the token, false to re-enable it
746     */
747     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
748         public
749         ownerOnly
750         validConnector(_connectorToken)
751     {
752         connectors[_connectorToken].isPurchaseEnabled = !_disable;
753     }
754 
755     /**
756         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
757 
758         @param _connectorToken  connector token contract address
759 
760         @return connector balance
761     */
762     function getConnectorBalance(IERC20Token _connectorToken)
763         public
764         view
765         validConnector(_connectorToken)
766         returns (uint256)
767     {
768         Connector storage connector = connectors[_connectorToken];
769         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
770     }
771 
772     /**
773         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
774 
775         @param _fromToken  ERC20 token to convert from
776         @param _toToken    ERC20 token to convert to
777         @param _amount     amount to convert, in fromToken
778 
779         @return expected conversion return amount
780     */
781     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
782         require(_fromToken != _toToken); // validate input
783 
784         // conversion between the token and one of its connectors
785         if (_toToken == token)
786             return getPurchaseReturn(_fromToken, _amount);
787         else if (_fromToken == token)
788             return getSaleReturn(_toToken, _amount);
789 
790         // conversion between 2 connectors
791         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
792     }
793 
794     /**
795         @dev returns the expected return for buying the token for a connector token
796 
797         @param _connectorToken  connector token contract address
798         @param _depositAmount   amount to deposit (in the connector token)
799 
800         @return expected purchase return amount
801     */
802     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
803         public
804         view
805         active
806         validConnector(_connectorToken)
807         returns (uint256)
808     {
809         Connector storage connector = connectors[_connectorToken];
810         require(connector.isPurchaseEnabled); // validate input
811 
812         uint256 tokenSupply = token.totalSupply();
813         uint256 connectorBalance = getConnectorBalance(_connectorToken);
814         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
815         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
816 
817         // return the amount minus the conversion fee
818         return getFinalAmount(amount, 1);
819     }
820 
821     /**
822         @dev returns the expected return for selling the token for one of its connector tokens
823 
824         @param _connectorToken  connector token contract address
825         @param _sellAmount      amount to sell (in the smart token)
826 
827         @return expected sale return amount
828     */
829     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
830         public
831         view
832         active
833         validConnector(_connectorToken)
834         returns (uint256)
835     {
836         Connector storage connector = connectors[_connectorToken];
837         uint256 tokenSupply = token.totalSupply();
838         uint256 connectorBalance = getConnectorBalance(_connectorToken);
839         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
840         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
841 
842         // return the amount minus the conversion fee
843         return getFinalAmount(amount, 1);
844     }
845 
846     /**
847         @dev returns the expected return for selling one of the connector tokens for another connector token
848 
849         @param _fromConnectorToken  contract address of the connector token to convert from
850         @param _toConnectorToken    contract address of the connector token to convert to
851         @param _sellAmount          amount to sell (in the from connector token)
852 
853         @return expected sale return amount (in the to connector token)
854     */
855     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
856         public
857         view
858         active
859         validConnector(_fromConnectorToken)
860         validConnector(_toConnectorToken)
861         returns (uint256)
862     {
863         Connector storage fromConnector = connectors[_fromConnectorToken];
864         Connector storage toConnector = connectors[_toConnectorToken];
865         require(toConnector.isPurchaseEnabled); // validate input
866 
867         uint256 fromConnectorBalance = getConnectorBalance(_fromConnectorToken);
868         uint256 toConnectorBalance = getConnectorBalance(_toConnectorToken);
869 
870         IBancorFormula formula = IBancorFormula(registry.getAddress(ContractIds.BANCOR_FORMULA));
871         uint256 amount = formula.calculateCrossConnectorReturn(fromConnectorBalance, fromConnector.weight, toConnectorBalance, toConnector.weight, _sellAmount);
872 
873         // return the amount minus the conversion fee
874         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
875         return getFinalAmount(amount, 2);
876     }
877 
878     /**
879         @dev converts a specific amount of _fromToken to _toToken
880 
881         @param _fromToken  ERC20 token to convert from
882         @param _toToken    ERC20 token to convert to
883         @param _amount     amount to convert, in fromToken
884         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
885 
886         @return conversion return amount
887     */
888     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
889         public
890         bancorNetworkOnly
891         conversionsAllowed
892         greaterThanZero(_minReturn)
893         returns (uint256)
894     {
895         require(_fromToken != _toToken); // validate input
896 
897         // conversion between the token and one of its connectors
898         if (_toToken == token)
899             return buy(_fromToken, _amount, _minReturn);
900         else if (_fromToken == token)
901             return sell(_toToken, _amount, _minReturn);
902 
903         // conversion between 2 connectors
904         uint256 amount = getCrossConnectorReturn(_fromToken, _toToken, _amount);
905         // ensure the trade gives something in return and meets the minimum requested amount
906         require(amount != 0 && amount >= _minReturn);
907 
908         // update the source token virtual balance if relevant
909         Connector storage fromConnector = connectors[_fromToken];
910         if (fromConnector.isVirtualBalanceEnabled)
911             fromConnector.virtualBalance = safeAdd(fromConnector.virtualBalance, _amount);
912 
913         // update the target token virtual balance if relevant
914         Connector storage toConnector = connectors[_toToken];
915         if (toConnector.isVirtualBalanceEnabled)
916             toConnector.virtualBalance = safeSub(toConnector.virtualBalance, amount);
917 
918         // ensure that the trade won't deplete the connector balance
919         uint256 toConnectorBalance = getConnectorBalance(_toToken);
920         assert(amount < toConnectorBalance);
921 
922         // transfer funds from the caller in the from connector token
923         assert(_fromToken.transferFrom(msg.sender, this, _amount));
924         // transfer funds to the caller in the to connector token
925         // the transfer might fail if the actual connector balance is smaller than the virtual balance
926         assert(_toToken.transfer(msg.sender, amount));
927 
928         // calculate conversion fee and dispatch the conversion event
929         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
930         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 2));
931         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
932 
933         // dispatch price data updates for the smart token / both connectors
934         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
935         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
936         return amount;
937     }
938 
939     /**
940         @dev converts a specific amount of _fromToken to _toToken
941 
942         @param _fromToken  ERC20 token to convert from
943         @param _toToken    ERC20 token to convert to
944         @param _amount     amount to convert, in fromToken
945         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
946 
947         @return conversion return amount
948     */
949     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
950         convertPath = [_fromToken, token, _toToken];
951         return quickConvert(convertPath, _amount, _minReturn);
952     }
953 
954     /**
955         @dev buys the token by depositing one of its connector tokens
956 
957         @param _connectorToken  connector token contract address
958         @param _depositAmount   amount to deposit (in the connector token)
959         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
960 
961         @return buy return amount
962     */
963     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
964         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
965         // ensure the trade gives something in return and meets the minimum requested amount
966         require(amount != 0 && amount >= _minReturn);
967 
968         // update virtual balance if relevant
969         Connector storage connector = connectors[_connectorToken];
970         if (connector.isVirtualBalanceEnabled)
971             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
972 
973         // transfer funds from the caller in the connector token
974         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
975         // issue new funds to the caller in the smart token
976         token.issue(msg.sender, amount);
977 
978         // calculate conversion fee and dispatch the conversion event
979         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
980         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
981 
982         // dispatch price data update for the smart token/connector
983         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
984         return amount;
985     }
986 
987     /**
988         @dev sells the token by withdrawing from one of its connector tokens
989 
990         @param _connectorToken  connector token contract address
991         @param _sellAmount      amount to sell (in the smart token)
992         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
993 
994         @return sell return amount
995     */
996     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
997         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
998 
999         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
1000         // ensure the trade gives something in return and meets the minimum requested amount
1001         require(amount != 0 && amount >= _minReturn);
1002 
1003         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1004         uint256 tokenSupply = token.totalSupply();
1005         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1006         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1007 
1008         // update virtual balance if relevant
1009         Connector storage connector = connectors[_connectorToken];
1010         if (connector.isVirtualBalanceEnabled)
1011             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1012 
1013         // destroy _sellAmount from the caller's balance in the smart token
1014         token.destroy(msg.sender, _sellAmount);
1015         // transfer funds to the caller in the connector token
1016         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1017         assert(_connectorToken.transfer(msg.sender, amount));
1018 
1019         // calculate conversion fee and dispatch the conversion event
1020         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
1021         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1022 
1023         // dispatch price data update for the smart token/connector
1024         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1025         return amount;
1026     }
1027 
1028     /**
1029         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1030         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1031 
1032         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1033         @param _amount      amount to convert from (in the initial source token)
1034         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1035 
1036         @return tokens issued in return
1037     */
1038     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1039         public
1040         payable
1041         validConversionPath(_path)
1042         returns (uint256)
1043     {
1044         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1045     }
1046 
1047     /**
1048         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1049         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1050 
1051         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1052         @param _amount      amount to convert from (in the initial source token)
1053         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1054         @param _block       if the current block exceeded the given parameter - it is cancelled
1055         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1056         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1057         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1058 
1059         @return tokens issued in return
1060     */
1061     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1062         public
1063         payable
1064         validConversionPath(_path)
1065         returns (uint256)
1066     {
1067         IERC20Token fromToken = _path[0];
1068         IBancorNetwork bancorNetwork = IBancorNetwork(registry.getAddress(ContractIds.BANCOR_NETWORK));
1069 
1070         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1071         // so it can execute the conversion on behalf of the caller
1072         if (msg.value == 0) {
1073             // not ETH, send the source tokens to the BancorNetwork contract
1074             // if the token is the smart token, no allowance is required - destroy the tokens
1075             // from the caller and issue them to the BancorNetwork contract
1076             if (fromToken == token) {
1077                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1078                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1079             } else {
1080                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1081                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1082             }
1083         }
1084 
1085         // execute the conversion and pass on the ETH with the call
1086         return bancorNetwork.convertForPrioritized2.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _v, _r, _s);
1087     }
1088 
1089     // deprecated, backward compatibility
1090     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1091         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1092     }
1093 
1094     /**
1095         @dev helper, dispatches the Conversion event
1096 
1097         @param _fromToken       ERC20 token to convert from
1098         @param _toToken         ERC20 token to convert to
1099         @param _amount          amount purchased/sold (in the source token)
1100         @param _returnAmount    amount returned (in the target token)
1101     */
1102     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1103         // fee amount is converted to 255 bits -
1104         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1105         // currently the fee is always taken from the target token
1106         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1107         assert(_feeAmount <= 2 ** 255);
1108         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1109     }
1110 
1111     /**
1112         @dev fallback, buys the smart token with ETH
1113         note that the purchase will use the price at the time of the purchase
1114     */
1115     function() payable public {
1116         quickConvert(quickBuyPath, msg.value, 1);
1117     }
1118 }