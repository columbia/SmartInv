1 pragma solidity ^0.4.23;
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
15     Whitelist interface
16 */
17 contract IWhitelist {
18     function isWhitelisted(address _address) public view returns (bool);
19 }
20 
21 /*
22     Contract Registry interface
23 */
24 contract IContractRegistry {
25     function addressOf(bytes32 _contractName) public view returns (address);
26 
27     // deprecated, backward compatibility
28     function getAddress(bytes32 _contractName) public view returns (address);
29 }
30 
31 /*
32     Contract Features interface
33 */
34 contract IContractFeatures {
35     function isSupported(address _contract, uint256 _features) public view returns (bool);
36     function enableFeatures(uint256 _features, bool _enable) public;
37 }
38 
39 /*
40     ERC20 Standard Token interface
41 */
42 contract IERC20Token {
43     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
44     function name() public view returns (string) {}
45     function symbol() public view returns (string) {}
46     function decimals() public view returns (uint8) {}
47     function totalSupply() public view returns (uint256) {}
48     function balanceOf(address _owner) public view returns (uint256) { _owner; }
49     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
50 
51     function transfer(address _to, uint256 _value) public returns (bool success);
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53     function approve(address _spender, uint256 _value) public returns (bool success);
54 }
55 
56 /*
57     Smart Token interface
58 */
59 contract ISmartToken is IOwned, IERC20Token {
60     function disableTransfers(bool _disable) public;
61     function issue(address _to, uint256 _amount) public;
62     function destroy(address _from, uint256 _amount) public;
63 }
64 
65 /*
66     Token Holder interface
67 */
68 contract ITokenHolder is IOwned {
69     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
70 }
71 
72 /*
73     Bancor Converter interface
74 */
75 contract IBancorConverter {
76     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
77     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
78     function conversionWhitelist() public view returns (IWhitelist) {}
79     // deprecated, backward compatibility
80     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
81 }
82 
83 /*
84     Bancor Formula interface
85 */
86 contract IBancorFormula {
87     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
88     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
89     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
90 }
91 
92 /*
93     Bancor Network interface
94 */
95 contract IBancorNetwork {
96     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
97     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
98     function convertForPrioritized2(
99         IERC20Token[] _path,
100         uint256 _amount,
101         uint256 _minReturn,
102         address _for,
103         uint256 _block,
104         uint8 _v,
105         bytes32 _r,
106         bytes32 _s)
107         public payable returns (uint256);
108 
109     // deprecated, backward compatibility
110     function convertForPrioritized(
111         IERC20Token[] _path,
112         uint256 _amount,
113         uint256 _minReturn,
114         address _for,
115         uint256 _block,
116         uint256 _nonce,
117         uint8 _v,
118         bytes32 _r,
119         bytes32 _s)
120         public payable returns (uint256);
121 }
122 
123 /*
124     Utilities & Common Modifiers
125 */
126 contract Utils {
127     /**
128         constructor
129     */
130     constructor() public {
131     }
132 
133     // verifies that an amount is greater than zero
134     modifier greaterThanZero(uint256 _amount) {
135         require(_amount > 0);
136         _;
137     }
138 
139     // validates an address - currently only checks that it isn't null
140     modifier validAddress(address _address) {
141         require(_address != address(0));
142         _;
143     }
144 
145     // verifies that the address is different than this contract address
146     modifier notThis(address _address) {
147         require(_address != address(this));
148         _;
149     }
150 
151     // Overflow protected math functions
152 
153     /**
154         @dev returns the sum of _x and _y, asserts if the calculation overflows
155 
156         @param _x   value 1
157         @param _y   value 2
158 
159         @return sum
160     */
161     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
162         uint256 z = _x + _y;
163         assert(z >= _x);
164         return z;
165     }
166 
167     /**
168         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
169 
170         @param _x   minuend
171         @param _y   subtrahend
172 
173         @return difference
174     */
175     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
176         assert(_x >= _y);
177         return _x - _y;
178     }
179 
180     /**
181         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
182 
183         @param _x   factor 1
184         @param _y   factor 2
185 
186         @return product
187     */
188     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
189         uint256 z = _x * _y;
190         assert(_x == 0 || z / _x == _y);
191         return z;
192     }
193 }
194 
195 /*
196     Provides support and utilities for contract ownership
197 */
198 contract Owned is IOwned {
199     address public owner;
200     address public newOwner;
201 
202     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
203 
204     /**
205         @dev constructor
206     */
207     constructor() public {
208         owner = msg.sender;
209     }
210 
211     // allows execution by the owner only
212     modifier ownerOnly {
213         assert(msg.sender == owner);
214         _;
215     }
216 
217     /**
218         @dev allows transferring the contract ownership
219         the new owner still needs to accept the transfer
220         can only be called by the contract owner
221 
222         @param _newOwner    new contract owner
223     */
224     function transferOwnership(address _newOwner) public ownerOnly {
225         require(_newOwner != owner);
226         newOwner = _newOwner;
227     }
228 
229     /**
230         @dev used by a new owner to accept an ownership transfer
231     */
232     function acceptOwnership() public {
233         require(msg.sender == newOwner);
234         emit OwnerUpdate(owner, newOwner);
235         owner = newOwner;
236         newOwner = address(0);
237     }
238 }
239 
240 /*
241     Provides support and utilities for contract management
242     Note that a managed contract must also have an owner
243 */
244 contract Managed is Owned {
245     address public manager;
246     address public newManager;
247 
248     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
249 
250     /**
251         @dev constructor
252     */
253     constructor() public {
254         manager = msg.sender;
255     }
256 
257     // allows execution by the manager only
258     modifier managerOnly {
259         assert(msg.sender == manager);
260         _;
261     }
262 
263     // allows execution by either the owner or the manager only
264     modifier ownerOrManagerOnly {
265         require(msg.sender == owner || msg.sender == manager);
266         _;
267     }
268 
269     /**
270         @dev allows transferring the contract management
271         the new manager still needs to accept the transfer
272         can only be called by the contract manager
273 
274         @param _newManager    new contract manager
275     */
276     function transferManagement(address _newManager) public ownerOrManagerOnly {
277         require(_newManager != manager);
278         newManager = _newManager;
279     }
280 
281     /**
282         @dev used by a new manager to accept a management transfer
283     */
284     function acceptManagement() public {
285         require(msg.sender == newManager);
286         emit ManagerUpdate(manager, newManager);
287         manager = newManager;
288         newManager = address(0);
289     }
290 }
291 
292 /**
293     Id definitions for bancor contracts
294 
295     Can be used in conjunction with the contract registry to get contract addresses
296 */
297 contract ContractIds {
298     // generic
299     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
300 
301     // bancor logic
302     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
303     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
304     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
305     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
306 }
307 
308 /**
309     Id definitions for bancor contract features
310 
311     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
312 */
313 contract FeatureIds {
314     // converter features
315     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
316 }
317 
318 /*
319     We consider every contract to be a 'token holder' since it's currently not possible
320     for a contract to deny receiving tokens.
321 
322     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
323     the owner to send tokens that were sent to the contract by mistake back to their sender.
324 */
325 contract TokenHolder is ITokenHolder, Owned, Utils {
326     /**
327         @dev constructor
328     */
329     constructor() public {
330     }
331 
332     /**
333         @dev withdraws tokens held by the contract and sends them to an account
334         can only be called by the owner
335 
336         @param _token   ERC20 token contract address
337         @param _to      account to receive the new amount
338         @param _amount  amount to withdraw
339     */
340     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
341         public
342         ownerOnly
343         validAddress(_token)
344         validAddress(_to)
345         notThis(_to)
346     {
347         assert(_token.transfer(_to, _amount));
348     }
349 }
350 
351 /*
352     The smart token controller is an upgradable part of the smart token that allows
353     more functionality as well as fixes for bugs/exploits.
354     Once it accepts ownership of the token, it becomes the token's sole controller
355     that can execute any of its functions.
356 
357     To upgrade the controller, ownership must be transferred to a new controller, along with
358     any relevant data.
359 
360     The smart token must be set on construction and cannot be changed afterwards.
361     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
362 
363     Note that the controller can transfer token ownership to a new controller that
364     doesn't allow executing any function on the token, for a trustless solution.
365     Doing that will also remove the owner's ability to upgrade the controller.
366 */
367 contract SmartTokenController is TokenHolder {
368     ISmartToken public token;   // smart token
369 
370     /**
371         @dev constructor
372     */
373     constructor(ISmartToken _token)
374         public
375         validAddress(_token)
376     {
377         token = _token;
378     }
379 
380     // ensures that the controller is the token's owner
381     modifier active() {
382         assert(token.owner() == address(this));
383         _;
384     }
385 
386     // ensures that the controller is not the token's owner
387     modifier inactive() {
388         assert(token.owner() != address(this));
389         _;
390     }
391 
392     /**
393         @dev allows transferring the token ownership
394         the new owner still need to accept the transfer
395         can only be called by the contract owner
396 
397         @param _newOwner    new token owner
398     */
399     function transferTokenOwnership(address _newOwner) public ownerOnly {
400         token.transferOwnership(_newOwner);
401     }
402 
403     /**
404         @dev used by a new owner to accept a token ownership transfer
405         can only be called by the contract owner
406     */
407     function acceptTokenOwnership() public ownerOnly {
408         token.acceptOwnership();
409     }
410 
411     /**
412         @dev disables/enables token transfers
413         can only be called by the contract owner
414 
415         @param _disable    true to disable transfers, false to enable them
416     */
417     function disableTokenTransfers(bool _disable) public ownerOnly {
418         token.disableTransfers(_disable);
419     }
420 
421     /**
422         @dev withdraws tokens held by the controller and sends them to an account
423         can only be called by the owner
424 
425         @param _token   ERC20 token contract address
426         @param _to      account to receive the new amount
427         @param _amount  amount to withdraw
428     */
429     function withdrawFromToken(
430         IERC20Token _token, 
431         address _to, 
432         uint256 _amount
433     ) 
434         public
435         ownerOnly
436     {
437         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
438     }
439 }
440 
441 /*
442     Bancor Converter v0.10
443 
444     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
445 
446     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
447     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
448 
449     The converter is upgradable (just like any SmartTokenController).
450 
451     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
452              or with very small numbers because of precision loss
453 
454     Open issues:
455     - Front-running attacks are currently mitigated by the following mechanisms:
456         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
457         - gas price limit prevents users from having control over the order of execution
458         - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
459       Other potential solutions might include a commit/reveal based schemes
460     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
461 */
462 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
463     uint32 private constant MAX_WEIGHT = 1000000;
464     uint64 private constant MAX_CONVERSION_FEE = 1000000;
465 
466     struct Connector {
467         uint256 virtualBalance;         // connector virtual balance
468         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
469         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
470         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
471         bool isSet;                     // used to tell if the mapping element is defined
472     }
473 
474     string public version = '0.10';
475     string public converterType = 'bancor';
476 
477     IContractRegistry public registry;                  // contract registry contract
478     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
479     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
480     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
481     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
482     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
483     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
484                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
485     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
486     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
487     IERC20Token[] private convertPath;
488 
489     // triggered when a conversion between two tokens occurs
490     event Conversion(
491         address indexed _fromToken,
492         address indexed _toToken,
493         address indexed _trader,
494         uint256 _amount,
495         uint256 _return,
496         int256 _conversionFee
497     );
498     // triggered after a conversion with new price data
499     event PriceDataUpdate(
500         address indexed _connectorToken,
501         uint256 _tokenSupply,
502         uint256 _connectorBalance,
503         uint32 _connectorWeight
504     );
505     // triggered when the conversion fee is updated
506     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
507 
508     /**
509         @dev constructor
510 
511         @param  _token              smart token governed by the converter
512         @param  _registry           address of a contract registry contract
513         @param  _maxConversionFee   maximum conversion fee, represented in ppm
514         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
515         @param  _connectorWeight    optional, weight for the initial connector
516     */
517     constructor(
518         ISmartToken _token,
519         IContractRegistry _registry,
520         uint32 _maxConversionFee,
521         IERC20Token _connectorToken,
522         uint32 _connectorWeight
523     )
524         public
525         SmartTokenController(_token)
526         validAddress(_registry)
527         validMaxConversionFee(_maxConversionFee)
528     {
529         registry = _registry;
530         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
531 
532         // initialize supported features
533         if (features != address(0))
534             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
535 
536         maxConversionFee = _maxConversionFee;
537 
538         if (_connectorToken != address(0))
539             addConnector(_connectorToken, _connectorWeight, false);
540     }
541 
542     // validates a connector token address - verifies that the address belongs to one of the connector tokens
543     modifier validConnector(IERC20Token _address) {
544         require(connectors[_address].isSet);
545         _;
546     }
547 
548     // validates a token address - verifies that the address belongs to one of the convertible tokens
549     modifier validToken(IERC20Token _address) {
550         require(_address == token || connectors[_address].isSet);
551         _;
552     }
553 
554     // validates maximum conversion fee
555     modifier validMaxConversionFee(uint32 _conversionFee) {
556         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
557         _;
558     }
559 
560     // validates conversion fee
561     modifier validConversionFee(uint32 _conversionFee) {
562         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
563         _;
564     }
565 
566     // validates connector weight range
567     modifier validConnectorWeight(uint32 _weight) {
568         require(_weight > 0 && _weight <= MAX_WEIGHT);
569         _;
570     }
571 
572     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
573     modifier validConversionPath(IERC20Token[] _path) {
574         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
575         _;
576     }
577 
578     // allows execution only when conversions aren't disabled
579     modifier conversionsAllowed {
580         assert(conversionsEnabled);
581         _;
582     }
583 
584     // allows execution by the BancorNetwork contract only
585     modifier bancorNetworkOnly {
586         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
587         require(msg.sender == address(bancorNetwork));
588         _;
589     }
590 
591     /**
592         @dev returns the number of connector tokens defined
593 
594         @return number of connector tokens
595     */
596     function connectorTokenCount() public view returns (uint16) {
597         return uint16(connectorTokens.length);
598     }
599 
600     /*
601         @dev allows the owner to update the contract registry contract address
602 
603         @param _registry   address of a contract registry contract
604     */
605     function setRegistry(IContractRegistry _registry)
606         public
607         ownerOnly
608         validAddress(_registry)
609         notThis(_registry)
610     {
611         registry = _registry;
612     }
613 
614     /*
615         @dev allows the owner to update & enable the conversion whitelist contract address
616         when set, only addresses that are whitelisted are actually allowed to use the converter
617         note that the whitelist check is actually done by the BancorNetwork contract
618 
619         @param _whitelist    address of a whitelist contract
620     */
621     function setConversionWhitelist(IWhitelist _whitelist)
622         public
623         ownerOnly
624         notThis(_whitelist)
625     {
626         conversionWhitelist = _whitelist;
627     }
628 
629     /*
630         @dev allows the manager to update the quick buy path
631 
632         @param _path    new quick buy path, see conversion path format in the bancorNetwork contract
633     */
634     function setQuickBuyPath(IERC20Token[] _path)
635         public
636         ownerOnly
637         validConversionPath(_path)
638     {
639         quickBuyPath = _path;
640     }
641 
642     /*
643         @dev allows the manager to clear the quick buy path
644     */
645     function clearQuickBuyPath() public ownerOnly {
646         quickBuyPath.length = 0;
647     }
648 
649     /**
650         @dev returns the length of the quick buy path array
651 
652         @return quick buy path length
653     */
654     function getQuickBuyPathLength() public view returns (uint256) {
655         return quickBuyPath.length;
656     }
657 
658     /**
659         @dev disables the entire conversion functionality
660         this is a safety mechanism in case of a emergency
661         can only be called by the manager
662 
663         @param _disable true to disable conversions, false to re-enable them
664     */
665     function disableConversions(bool _disable) public ownerOrManagerOnly {
666         conversionsEnabled = !_disable;
667     }
668 
669     /**
670         @dev updates the current conversion fee
671         can only be called by the manager
672 
673         @param _conversionFee new conversion fee, represented in ppm
674     */
675     function setConversionFee(uint32 _conversionFee)
676         public
677         ownerOrManagerOnly
678         validConversionFee(_conversionFee)
679     {
680         emit ConversionFeeUpdate(conversionFee, _conversionFee);
681         conversionFee = _conversionFee;
682     }
683 
684     /*
685         @dev given a return amount, returns the amount minus the conversion fee
686 
687         @param _amount      return amount
688         @param _magnitude   1 for standard conversion, 2 for cross connector conversion
689 
690         @return return amount minus conversion fee
691     */
692     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
693         return safeMul(_amount, (MAX_CONVERSION_FEE - conversionFee) ** _magnitude) / MAX_CONVERSION_FEE ** _magnitude;
694     }
695 
696     /**
697         @dev defines a new connector for the token
698         can only be called by the owner while the converter is inactive
699 
700         @param _token                  address of the connector token
701         @param _weight                 constant connector weight, represented in ppm, 1-1000000
702         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
703     */
704     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
705         public
706         ownerOnly
707         inactive
708         validAddress(_token)
709         notThis(_token)
710         validConnectorWeight(_weight)
711     {
712         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
713 
714         connectors[_token].virtualBalance = 0;
715         connectors[_token].weight = _weight;
716         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
717         connectors[_token].isPurchaseEnabled = true;
718         connectors[_token].isSet = true;
719         connectorTokens.push(_token);
720         totalConnectorWeight += _weight;
721     }
722 
723     /**
724         @dev updates one of the token connectors
725         can only be called by the owner
726 
727         @param _connectorToken         address of the connector token
728         @param _weight                 constant connector weight, represented in ppm, 1-1000000
729         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
730         @param _virtualBalance         new connector's virtual balance
731     */
732     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
733         public
734         ownerOnly
735         validConnector(_connectorToken)
736         validConnectorWeight(_weight)
737     {
738         Connector storage connector = connectors[_connectorToken];
739         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
740 
741         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
742         connector.weight = _weight;
743         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
744         connector.virtualBalance = _virtualBalance;
745     }
746 
747     /**
748         @dev disables purchasing with the given connector token in case the connector token got compromised
749         can only be called by the owner
750         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
751 
752         @param _connectorToken  connector token contract address
753         @param _disable         true to disable the token, false to re-enable it
754     */
755     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
756         public
757         ownerOnly
758         validConnector(_connectorToken)
759     {
760         connectors[_connectorToken].isPurchaseEnabled = !_disable;
761     }
762 
763     /**
764         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
765 
766         @param _connectorToken  connector token contract address
767 
768         @return connector balance
769     */
770     function getConnectorBalance(IERC20Token _connectorToken)
771         public
772         view
773         validConnector(_connectorToken)
774         returns (uint256)
775     {
776         Connector storage connector = connectors[_connectorToken];
777         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
778     }
779 
780     /**
781         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
782 
783         @param _fromToken  ERC20 token to convert from
784         @param _toToken    ERC20 token to convert to
785         @param _amount     amount to convert, in fromToken
786 
787         @return expected conversion return amount
788     */
789     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
790         require(_fromToken != _toToken); // validate input
791 
792         // conversion between the token and one of its connectors
793         if (_toToken == token)
794             return getPurchaseReturn(_fromToken, _amount);
795         else if (_fromToken == token)
796             return getSaleReturn(_toToken, _amount);
797 
798         // conversion between 2 connectors
799         return getCrossConnectorReturn(_fromToken, _toToken, _amount);
800     }
801 
802     /**
803         @dev returns the expected return for buying the token for a connector token
804 
805         @param _connectorToken  connector token contract address
806         @param _depositAmount   amount to deposit (in the connector token)
807 
808         @return expected purchase return amount
809     */
810     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
811         public
812         view
813         active
814         validConnector(_connectorToken)
815         returns (uint256)
816     {
817         Connector storage connector = connectors[_connectorToken];
818         require(connector.isPurchaseEnabled); // validate input
819 
820         uint256 tokenSupply = token.totalSupply();
821         uint256 connectorBalance = getConnectorBalance(_connectorToken);
822         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
823         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
824 
825         // return the amount minus the conversion fee
826         return getFinalAmount(amount, 1);
827     }
828 
829     /**
830         @dev returns the expected return for selling the token for one of its connector tokens
831 
832         @param _connectorToken  connector token contract address
833         @param _sellAmount      amount to sell (in the smart token)
834 
835         @return expected sale return amount
836     */
837     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount)
838         public
839         view
840         active
841         validConnector(_connectorToken)
842         returns (uint256)
843     {
844         Connector storage connector = connectors[_connectorToken];
845         uint256 tokenSupply = token.totalSupply();
846         uint256 connectorBalance = getConnectorBalance(_connectorToken);
847         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
848         uint256 amount = formula.calculateSaleReturn(tokenSupply, connectorBalance, connector.weight, _sellAmount);
849 
850         // return the amount minus the conversion fee
851         return getFinalAmount(amount, 1);
852     }
853 
854     /**
855         @dev returns the expected return for selling one of the connector tokens for another connector token
856 
857         @param _fromConnectorToken  contract address of the connector token to convert from
858         @param _toConnectorToken    contract address of the connector token to convert to
859         @param _sellAmount          amount to sell (in the from connector token)
860 
861         @return expected sale return amount (in the to connector token)
862     */
863     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _sellAmount)
864         public
865         view
866         active
867         validConnector(_fromConnectorToken)
868         validConnector(_toConnectorToken)
869         returns (uint256)
870     {
871         Connector storage fromConnector = connectors[_fromConnectorToken];
872         Connector storage toConnector = connectors[_toConnectorToken];
873         require(toConnector.isPurchaseEnabled); // validate input
874 
875         uint256 fromConnectorBalance = getConnectorBalance(_fromConnectorToken);
876         uint256 toConnectorBalance = getConnectorBalance(_toConnectorToken);
877 
878         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
879         uint256 amount = formula.calculateCrossConnectorReturn(fromConnectorBalance, fromConnector.weight, toConnectorBalance, toConnector.weight, _sellAmount);
880 
881         // return the amount minus the conversion fee
882         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
883         return getFinalAmount(amount, 2);
884     }
885 
886     /**
887         @dev converts a specific amount of _fromToken to _toToken
888 
889         @param _fromToken  ERC20 token to convert from
890         @param _toToken    ERC20 token to convert to
891         @param _amount     amount to convert, in fromToken
892         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
893 
894         @return conversion return amount
895     */
896     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
897         public
898         bancorNetworkOnly
899         conversionsAllowed
900         greaterThanZero(_minReturn)
901         returns (uint256)
902     {
903         require(_fromToken != _toToken); // validate input
904 
905         // conversion between the token and one of its connectors
906         if (_toToken == token)
907             return buy(_fromToken, _amount, _minReturn);
908         else if (_fromToken == token)
909             return sell(_toToken, _amount, _minReturn);
910 
911         // conversion between 2 connectors
912         uint256 amount = getCrossConnectorReturn(_fromToken, _toToken, _amount);
913         // ensure the trade gives something in return and meets the minimum requested amount
914         require(amount != 0 && amount >= _minReturn);
915 
916         // update the source token virtual balance if relevant
917         Connector storage fromConnector = connectors[_fromToken];
918         if (fromConnector.isVirtualBalanceEnabled)
919             fromConnector.virtualBalance = safeAdd(fromConnector.virtualBalance, _amount);
920 
921         // update the target token virtual balance if relevant
922         Connector storage toConnector = connectors[_toToken];
923         if (toConnector.isVirtualBalanceEnabled)
924             toConnector.virtualBalance = safeSub(toConnector.virtualBalance, amount);
925 
926         // ensure that the trade won't deplete the connector balance
927         uint256 toConnectorBalance = getConnectorBalance(_toToken);
928         assert(amount < toConnectorBalance);
929 
930         // transfer funds from the caller in the from connector token
931         assert(_fromToken.transferFrom(msg.sender, this, _amount));
932         // transfer funds to the caller in the to connector token
933         // the transfer might fail if the actual connector balance is smaller than the virtual balance
934         assert(_toToken.transfer(msg.sender, amount));
935 
936         // calculate conversion fee and dispatch the conversion event
937         // the fee is higher (magnitude = 2) since cross connector conversion equals 2 conversions (from / to the smart token)
938         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 2));
939         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
940 
941         // dispatch price data updates for the smart token / both connectors
942         emit PriceDataUpdate(_fromToken, token.totalSupply(), getConnectorBalance(_fromToken), fromConnector.weight);
943         emit PriceDataUpdate(_toToken, token.totalSupply(), getConnectorBalance(_toToken), toConnector.weight);
944         return amount;
945     }
946 
947     /**
948         @dev converts a specific amount of _fromToken to _toToken
949 
950         @param _fromToken  ERC20 token to convert from
951         @param _toToken    ERC20 token to convert to
952         @param _amount     amount to convert, in fromToken
953         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
954 
955         @return conversion return amount
956     */
957     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
958         convertPath = [_fromToken, token, _toToken];
959         return quickConvert(convertPath, _amount, _minReturn);
960     }
961 
962     /**
963         @dev buys the token by depositing one of its connector tokens
964 
965         @param _connectorToken  connector token contract address
966         @param _depositAmount   amount to deposit (in the connector token)
967         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
968 
969         @return buy return amount
970     */
971     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
972         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
973         // ensure the trade gives something in return and meets the minimum requested amount
974         require(amount != 0 && amount >= _minReturn);
975 
976         // update virtual balance if relevant
977         Connector storage connector = connectors[_connectorToken];
978         if (connector.isVirtualBalanceEnabled)
979             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
980 
981         // transfer funds from the caller in the connector token
982         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
983         // issue new funds to the caller in the smart token
984         token.issue(msg.sender, amount);
985 
986         // calculate conversion fee and dispatch the conversion event
987         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
988         dispatchConversionEvent(_connectorToken, token, _depositAmount, amount, feeAmount);
989 
990         // dispatch price data update for the smart token/connector
991         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
992         return amount;
993     }
994 
995     /**
996         @dev sells the token by withdrawing from one of its connector tokens
997 
998         @param _connectorToken  connector token contract address
999         @param _sellAmount      amount to sell (in the smart token)
1000         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1001 
1002         @return sell return amount
1003     */
1004     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1005         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1006 
1007         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
1008         // ensure the trade gives something in return and meets the minimum requested amount
1009         require(amount != 0 && amount >= _minReturn);
1010 
1011         // ensure that the trade will only deplete the connector balance if the total supply is depleted as well
1012         uint256 tokenSupply = token.totalSupply();
1013         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1014         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
1015 
1016         // update virtual balance if relevant
1017         Connector storage connector = connectors[_connectorToken];
1018         if (connector.isVirtualBalanceEnabled)
1019             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
1020 
1021         // destroy _sellAmount from the caller's balance in the smart token
1022         token.destroy(msg.sender, _sellAmount);
1023         // transfer funds to the caller in the connector token
1024         // the transfer might fail if the actual connector balance is smaller than the virtual balance
1025         assert(_connectorToken.transfer(msg.sender, amount));
1026 
1027         // calculate conversion fee and dispatch the conversion event
1028         uint256 feeAmount = safeSub(amount, getFinalAmount(amount, 1));
1029         dispatchConversionEvent(token, _connectorToken, _sellAmount, amount, feeAmount);
1030 
1031         // dispatch price data update for the smart token/connector
1032         emit PriceDataUpdate(_connectorToken, token.totalSupply(), getConnectorBalance(_connectorToken), connector.weight);
1033         return amount;
1034     }
1035 
1036     /**
1037         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1038         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1039 
1040         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1041         @param _amount      amount to convert from (in the initial source token)
1042         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1043 
1044         @return tokens issued in return
1045     */
1046     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
1047         public
1048         payable
1049         validConversionPath(_path)
1050         returns (uint256)
1051     {
1052         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0);
1053     }
1054 
1055     /**
1056         @dev converts the token to any other token in the bancor network by following a predefined conversion path
1057         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1058 
1059         @param _path        conversion path, see conversion path format in the BancorNetwork contract
1060         @param _amount      amount to convert from (in the initial source token)
1061         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1062         @param _block       if the current block exceeded the given parameter - it is cancelled
1063         @param _v           (signature[128:130]) associated with the signer address and helps validating if the signature is legit
1064         @param _r           (signature[0:64]) associated with the signer address and helps validating if the signature is legit
1065         @param _s           (signature[64:128]) associated with the signer address and helps validating if the signature is legit
1066 
1067         @return tokens issued in return
1068     */
1069     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s)
1070         public
1071         payable
1072         validConversionPath(_path)
1073         returns (uint256)
1074     {
1075         IERC20Token fromToken = _path[0];
1076         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1077 
1078         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1079         // so it can execute the conversion on behalf of the caller
1080         if (msg.value == 0) {
1081             // not ETH, send the source tokens to the BancorNetwork contract
1082             // if the token is the smart token, no allowance is required - destroy the tokens
1083             // from the caller and issue them to the BancorNetwork contract
1084             if (fromToken == token) {
1085                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1086                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1087             } else {
1088                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1089                 assert(fromToken.transferFrom(msg.sender, bancorNetwork, _amount));
1090             }
1091         }
1092 
1093         // execute the conversion and pass on the ETH with the call
1094         return bancorNetwork.convertForPrioritized2.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _v, _r, _s);
1095     }
1096 
1097     // deprecated, backward compatibility
1098     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1099         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1100     }
1101 
1102     /**
1103         @dev helper, dispatches the Conversion event
1104 
1105         @param _fromToken       ERC20 token to convert from
1106         @param _toToken         ERC20 token to convert to
1107         @param _amount          amount purchased/sold (in the source token)
1108         @param _returnAmount    amount returned (in the target token)
1109     */
1110     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1111         // fee amount is converted to 255 bits -
1112         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1113         // currently the fee is always taken from the target token
1114         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1115         assert(_feeAmount <= 2 ** 255);
1116         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1117     }
1118 
1119     /**
1120         @dev fallback, buys the smart token with ETH
1121         note that the purchase will use the price at the time of the purchase
1122     */
1123     function() payable public {
1124         quickConvert(quickBuyPath, msg.value, 1);
1125     }
1126 }