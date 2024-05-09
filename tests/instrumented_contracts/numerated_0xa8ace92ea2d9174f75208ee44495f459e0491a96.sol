1 pragma solidity ^0.4.18;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() public {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // validates an address - currently only checks that it isn't null
20     modifier validAddress(address _address) {
21         require(_address != address(0));
22         _;
23     }
24 
25     // verifies that the address is different than this contract address
26     modifier notThis(address _address) {
27         require(_address != address(this));
28         _;
29     }
30 
31     // Overflow protected math functions
32 
33     /**
34         @dev returns the sum of _x and _y, asserts if the calculation overflows
35 
36         @param _x   value 1
37         @param _y   value 2
38 
39         @return sum
40     */
41     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     /**
48         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
49 
50         @param _x   minuend
51         @param _y   subtrahend
52 
53         @return difference
54     */
55     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
56         assert(_x >= _y);
57         return _x - _y;
58     }
59 
60     /**
61         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
62 
63         @param _x   factor 1
64         @param _y   factor 2
65 
66         @return product
67     */
68     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public view returns (address) {}
81 
82     function transferOwnership(address _newOwner) public;
83     function acceptOwnership() public;
84 }
85 
86 /*
87     Provides support and utilities for contract ownership
88 */
89 contract Owned is IOwned {
90     address public owner;
91     address public newOwner;
92 
93     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() public {
99         owner = msg.sender;
100     }
101 
102     // allows execution by the owner only
103     modifier ownerOnly {
104         assert(msg.sender == owner);
105         _;
106     }
107 
108     /**
109         @dev allows transferring the contract ownership
110         the new owner still needs to accept the transfer
111         can only be called by the contract owner
112 
113         @param _newOwner    new contract owner
114     */
115     function transferOwnership(address _newOwner) public ownerOnly {
116         require(_newOwner != owner);
117         newOwner = _newOwner;
118     }
119 
120     /**
121         @dev used by a new owner to accept an ownership transfer
122     */
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         OwnerUpdate(owner, newOwner);
126         owner = newOwner;
127         newOwner = address(0);
128     }
129 }
130 
131 /*
132     Provides support and utilities for contract management
133 */
134 contract Managed {
135     address public manager;
136     address public newManager;
137 
138     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
139 
140     /**
141         @dev constructor
142     */
143     function Managed() public {
144         manager = msg.sender;
145     }
146 
147     // allows execution by the manager only
148     modifier managerOnly {
149         assert(msg.sender == manager);
150         _;
151     }
152 
153     /**
154         @dev allows transferring the contract management
155         the new manager still needs to accept the transfer
156         can only be called by the contract manager
157 
158         @param _newManager    new contract manager
159     */
160     function transferManagement(address _newManager) public managerOnly {
161         require(_newManager != manager);
162         newManager = _newManager;
163     }
164 
165     /**
166         @dev used by a new manager to accept a management transfer
167     */
168     function acceptManagement() public {
169         require(msg.sender == newManager);
170         ManagerUpdate(manager, newManager);
171         manager = newManager;
172         newManager = address(0);
173     }
174 }
175 
176 /*
177     ERC20 Standard Token interface
178 */
179 contract IERC20Token {
180     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
181     function name() public view returns (string) {}
182     function symbol() public view returns (string) {}
183     function decimals() public view returns (uint8) {}
184     function totalSupply() public view returns (uint256) {}
185     function balanceOf(address _owner) public view returns (uint256) { _owner; }
186     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
187 
188     function transfer(address _to, uint256 _value) public returns (bool success);
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
190     function approve(address _spender, uint256 _value) public returns (bool success);
191 }
192 
193 /*
194     Smart Token interface
195 */
196 contract ISmartToken is IOwned, IERC20Token {
197     function disableTransfers(bool _disable) public;
198     function issue(address _to, uint256 _amount) public;
199     function destroy(address _from, uint256 _amount) public;
200 }
201 
202 /*
203     Token Holder interface
204 */
205 contract ITokenHolder is IOwned {
206     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
207 }
208 
209 /*
210     We consider every contract to be a 'token holder' since it's currently not possible
211     for a contract to deny receiving tokens.
212 
213     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
214     the owner to send tokens that were sent to the contract by mistake back to their sender.
215 */
216 contract TokenHolder is ITokenHolder, Owned, Utils {
217     /**
218         @dev constructor
219     */
220     function TokenHolder() public {
221     }
222 
223     /**
224         @dev withdraws tokens held by the contract and sends them to an account
225         can only be called by the owner
226 
227         @param _token   ERC20 token contract address
228         @param _to      account to receive the new amount
229         @param _amount  amount to withdraw
230     */
231     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
232         public
233         ownerOnly
234         validAddress(_token)
235         validAddress(_to)
236         notThis(_to)
237     {
238         assert(_token.transfer(_to, _amount));
239     }
240 }
241 
242 /*
243     The smart token controller is an upgradable part of the smart token that allows
244     more functionality as well as fixes for bugs/exploits.
245     Once it accepts ownership of the token, it becomes the token's sole controller
246     that can execute any of its functions.
247 
248     To upgrade the controller, ownership must be transferred to a new controller, along with
249     any relevant data.
250 
251     The smart token must be set on construction and cannot be changed afterwards.
252     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
253 
254     Note that the controller can transfer token ownership to a new controller that
255     doesn't allow executing any function on the token, for a trustless solution.
256     Doing that will also remove the owner's ability to upgrade the controller.
257 */
258 contract SmartTokenController is TokenHolder {
259     ISmartToken public token;   // smart token
260 
261     /**
262         @dev constructor
263     */
264     function SmartTokenController(ISmartToken _token)
265         public
266         validAddress(_token)
267     {
268         token = _token;
269     }
270 
271     // ensures that the controller is the token's owner
272     modifier active() {
273         assert(token.owner() == address(this));
274         _;
275     }
276 
277     // ensures that the controller is not the token's owner
278     modifier inactive() {
279         assert(token.owner() != address(this));
280         _;
281     }
282 
283     /**
284         @dev allows transferring the token ownership
285         the new owner still need to accept the transfer
286         can only be called by the contract owner
287 
288         @param _newOwner    new token owner
289     */
290     function transferTokenOwnership(address _newOwner) public ownerOnly {
291         token.transferOwnership(_newOwner);
292     }
293 
294     /**
295         @dev used by a new owner to accept a token ownership transfer
296         can only be called by the contract owner
297     */
298     function acceptTokenOwnership() public ownerOnly {
299         token.acceptOwnership();
300     }
301 
302     /**
303         @dev disables/enables token transfers
304         can only be called by the contract owner
305 
306         @param _disable    true to disable transfers, false to enable them
307     */
308     function disableTokenTransfers(bool _disable) public ownerOnly {
309         token.disableTransfers(_disable);
310     }
311 
312     /**
313         @dev withdraws tokens held by the controller and sends them to an account
314         can only be called by the owner
315 
316         @param _token   ERC20 token contract address
317         @param _to      account to receive the new amount
318         @param _amount  amount to withdraw
319     */
320     function withdrawFromToken(
321         IERC20Token _token, 
322         address _to, 
323         uint256 _amount
324     ) 
325         public
326         ownerOnly
327     {
328         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
329     }
330 }
331 
332 /*
333     Bancor Formula interface
334 */
335 contract IBancorFormula {
336     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
337     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
338     function calculateCrossConnectorReturn(uint256 _connector1Balance, uint32 _connector1Weight, uint256 _connector2Balance, uint32 _connector2Weight, uint256 _amount) public view returns (uint256);
339 }
340 
341 /*
342     Bancor Gas Price Limit interface
343 */
344 contract IBancorGasPriceLimit {
345     function gasPrice() public view returns (uint256) {}
346     function validateGasPrice(uint256) public view;
347 }
348 
349 /*
350     Bancor Quick Converter interface
351 */
352 contract IBancorQuickConverter {
353     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
354     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
355     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
356 }
357 
358 /*
359     Bancor Converter Extensions interface
360 */
361 contract IBancorConverterExtensions {
362     function formula() public view returns (IBancorFormula) {}
363     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
364     function quickConverter() public view returns (IBancorQuickConverter) {}
365 }
366 
367 /*
368     EIP228 Token Converter interface
369 */
370 contract ITokenConverter {
371     function convertibleTokenCount() public view returns (uint16);
372     function convertibleToken(uint16 _tokenIndex) public view returns (address);
373     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
374     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
375     // deprecated, backward compatibility
376     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
377 }
378 
379 /*
380     Bancor Converter v0.8
381 
382     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
383 
384     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
385     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
386 
387     The converter is upgradable (just like any SmartTokenController).
388 
389     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
390              or with very small numbers because of precision loss
391 
392 
393     Open issues:
394     - Front-running attacks are currently mitigated by the following mechanisms:
395         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
396         - gas price limit prevents users from having control over the order of execution
397       Other potential solutions might include a commit/reveal based schemes
398     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
399 */
400 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
401     uint32 private constant MAX_WEIGHT = 1000000;
402     uint32 private constant MAX_CONVERSION_FEE = 1000000;
403 
404     struct Connector {
405         uint256 virtualBalance;         // connector virtual balance
406         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
407         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
408         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
409         bool isSet;                     // used to tell if the mapping element is defined
410     }
411 
412     string public version = '0.8';
413     string public converterType = 'bancor';
414 
415     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
416     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
417     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
418     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
419     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
420     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
421     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
422     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
423     IERC20Token[] private convertPath;
424 
425     // triggered when a conversion between two tokens occurs (TokenConverter event)
426     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
427                      int256 _conversionFee, uint256 _currentPriceN, uint256 _currentPriceD);
428     // triggered when the conversion fee is updated
429     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
430 
431     /**
432         @dev constructor
433 
434         @param  _token              smart token governed by the converter
435         @param  _extensions         address of a bancor converter extensions contract
436         @param  _maxConversionFee   maximum conversion fee, represented in ppm
437         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
438         @param  _connectorWeight    optional, weight for the initial connector
439     */
440     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
441         public
442         SmartTokenController(_token)
443         validAddress(_extensions)
444         validMaxConversionFee(_maxConversionFee)
445     {
446         extensions = _extensions;
447         maxConversionFee = _maxConversionFee;
448 
449         if (_connectorToken != address(0))
450             addConnector(_connectorToken, _connectorWeight, false);
451     }
452 
453     // validates a connector token address - verifies that the address belongs to one of the connector tokens
454     modifier validConnector(IERC20Token _address) {
455         require(connectors[_address].isSet);
456         _;
457     }
458 
459     // validates a token address - verifies that the address belongs to one of the convertible tokens
460     modifier validToken(IERC20Token _address) {
461         require(_address == token || connectors[_address].isSet);
462         _;
463     }
464 
465     // validates maximum conversion fee
466     modifier validMaxConversionFee(uint32 _conversionFee) {
467         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
468         _;
469     }
470 
471     // validates conversion fee
472     modifier validConversionFee(uint32 _conversionFee) {
473         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
474         _;
475     }
476 
477     // validates connector weight range
478     modifier validConnectorWeight(uint32 _weight) {
479         require(_weight > 0 && _weight <= MAX_WEIGHT);
480         _;
481     }
482 
483     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
484     modifier validConversionPath(IERC20Token[] _path) {
485         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
486         _;
487     }
488 
489     // allows execution only when conversions aren't disabled
490     modifier conversionsAllowed {
491         assert(conversionsEnabled);
492         _;
493     }
494 
495     // allows execution only for owner or manager
496     modifier ownerOrManagerOnly {
497         require(msg.sender == owner || msg.sender == manager);
498         _;
499     }
500 
501     // allows execution only for quick convreter
502     modifier quickConverterOnly {
503         require(msg.sender == address(extensions.quickConverter()));
504         _;
505     }
506 
507     /**
508         @dev returns the number of connector tokens defined
509 
510         @return number of connector tokens
511     */
512     function connectorTokenCount() public view returns (uint16) {
513         return uint16(connectorTokens.length);
514     }
515 
516     /**
517         @dev returns the number of convertible tokens supported by the contract
518         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
519 
520         @return number of convertible tokens
521     */
522     function convertibleTokenCount() public view returns (uint16) {
523         return connectorTokenCount() + 1;
524     }
525 
526     /**
527         @dev given a convertible token index, returns its contract address
528 
529         @param _tokenIndex  convertible token index
530 
531         @return convertible token address
532     */
533     function convertibleToken(uint16 _tokenIndex) public view returns (address) {
534         if (_tokenIndex == 0)
535             return token;
536         return connectorTokens[_tokenIndex - 1];
537     }
538 
539     /*
540         @dev allows the owner to update the extensions contract address
541 
542         @param _extensions    address of a bancor converter extensions contract
543     */
544     function setExtensions(IBancorConverterExtensions _extensions)
545         public
546         ownerOnly
547         validAddress(_extensions)
548         notThis(_extensions)
549     {
550         extensions = _extensions;
551     }
552 
553     /*
554         @dev allows the manager to update the quick buy path
555 
556         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
557     */
558     function setQuickBuyPath(IERC20Token[] _path)
559         public
560         ownerOnly
561         validConversionPath(_path)
562     {
563         quickBuyPath = _path;
564     }
565 
566     /*
567         @dev allows the manager to clear the quick buy path
568     */
569     function clearQuickBuyPath() public ownerOnly {
570         quickBuyPath.length = 0;
571     }
572 
573     /**
574         @dev returns the length of the quick buy path array
575 
576         @return quick buy path length
577     */
578     function getQuickBuyPathLength() public view returns (uint256) {
579         return quickBuyPath.length;
580     }
581 
582     /**
583         @dev disables the entire conversion functionality
584         this is a safety mechanism in case of a emergency
585         can only be called by the manager
586 
587         @param _disable true to disable conversions, false to re-enable them
588     */
589     function disableConversions(bool _disable) public ownerOrManagerOnly {
590         conversionsEnabled = !_disable;
591     }
592 
593     /**
594         @dev updates the current conversion fee
595         can only be called by the manager
596 
597         @param _conversionFee new conversion fee, represented in ppm
598     */
599     function setConversionFee(uint32 _conversionFee)
600         public
601         ownerOrManagerOnly
602         validConversionFee(_conversionFee)
603     {
604         ConversionFeeUpdate(conversionFee, _conversionFee);
605         conversionFee = _conversionFee;
606     }
607 
608     /*
609         @dev returns the conversion fee amount for a given return amount
610 
611         @return conversion fee amount
612     */
613     function getConversionFeeAmount(uint256 _amount) public view returns (uint256) {
614         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
615     }
616 
617     /**
618         @dev defines a new connector for the token
619         can only be called by the owner while the converter is inactive
620 
621         @param _token                  address of the connector token
622         @param _weight                 constant connector weight, represented in ppm, 1-1000000
623         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
624     */
625     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
626         public
627         ownerOnly
628         inactive
629         validAddress(_token)
630         notThis(_token)
631         validConnectorWeight(_weight)
632     {
633         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
634 
635         connectors[_token].virtualBalance = 0;
636         connectors[_token].weight = _weight;
637         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
638         connectors[_token].isPurchaseEnabled = true;
639         connectors[_token].isSet = true;
640         connectorTokens.push(_token);
641         totalConnectorWeight += _weight;
642     }
643 
644     /**
645         @dev updates one of the token connectors
646         can only be called by the owner
647 
648         @param _connectorToken         address of the connector token
649         @param _weight                 constant connector weight, represented in ppm, 1-1000000
650         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
651         @param _virtualBalance         new connector's virtual balance
652     */
653     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
654         public
655         ownerOnly
656         validConnector(_connectorToken)
657         validConnectorWeight(_weight)
658     {
659         Connector storage connector = connectors[_connectorToken];
660         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
661 
662         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
663         connector.weight = _weight;
664         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
665         connector.virtualBalance = _virtualBalance;
666     }
667 
668     /**
669         @dev disables purchasing with the given connector token in case the connector token got compromised
670         can only be called by the owner
671         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
672 
673         @param _connectorToken  connector token contract address
674         @param _disable         true to disable the token, false to re-enable it
675     */
676     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
677         public
678         ownerOnly
679         validConnector(_connectorToken)
680     {
681         connectors[_connectorToken].isPurchaseEnabled = !_disable;
682     }
683 
684     /**
685         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
686 
687         @param _connectorToken  connector token contract address
688 
689         @return connector balance
690     */
691     function getConnectorBalance(IERC20Token _connectorToken)
692         public
693         view
694         validConnector(_connectorToken)
695         returns (uint256)
696     {
697         Connector storage connector = connectors[_connectorToken];
698         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
699     }
700 
701     /**
702         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
703 
704         @param _fromToken  ERC20 token to convert from
705         @param _toToken    ERC20 token to convert to
706         @param _amount     amount to convert, in fromToken
707 
708         @return expected conversion return amount
709     */
710     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
711         require(_fromToken != _toToken); // validate input
712 
713         // conversion between the token and one of its connectors
714         if (_toToken == token)
715             return getPurchaseReturn(_fromToken, _amount);
716         else if (_fromToken == token)
717             return getSaleReturn(_toToken, _amount);
718 
719         // conversion between 2 connectors
720         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
721         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
722     }
723 
724     /**
725         @dev returns the expected return for buying the token for a connector token
726 
727         @param _connectorToken  connector token contract address
728         @param _depositAmount   amount to deposit (in the connector token)
729 
730         @return expected purchase return amount
731     */
732     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
733         public
734         view
735         active
736         validConnector(_connectorToken)
737         returns (uint256)
738     {
739         Connector storage connector = connectors[_connectorToken];
740         require(connector.isPurchaseEnabled); // validate input
741 
742         uint256 tokenSupply = token.totalSupply();
743         uint256 connectorBalance = getConnectorBalance(_connectorToken);
744         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
745 
746         // deduct the fee from the return amount
747         uint256 feeAmount = getConversionFeeAmount(amount);
748         return safeSub(amount, feeAmount);
749     }
750 
751     /**
752         @dev returns the expected return for selling the token for one of its connector tokens
753 
754         @param _connectorToken  connector token contract address
755         @param _sellAmount      amount to sell (in the smart token)
756 
757         @return expected sale return amount
758     */
759     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public view returns (uint256) {
760         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
761     }
762 
763     /**
764         @dev converts a specific amount of _fromToken to _toToken
765 
766         @param _fromToken  ERC20 token to convert from
767         @param _toToken    ERC20 token to convert to
768         @param _amount     amount to convert, in fromToken
769         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
770 
771         @return conversion return amount
772     */
773     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public quickConverterOnly returns (uint256) {
774         require(_fromToken != _toToken); // validate input
775 
776         // conversion between the token and one of its connectors
777         if (_toToken == token)
778             return buy(_fromToken, _amount, _minReturn);
779         else if (_fromToken == token)
780             return sell(_toToken, _amount, _minReturn);
781 
782         // conversion between 2 connectors
783         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
784         return sell(_toToken, purchaseAmount, _minReturn);
785     }
786 
787     /**
788         @dev converts a specific amount of _fromToken to _toToken
789 
790         @param _fromToken  ERC20 token to convert from
791         @param _toToken    ERC20 token to convert to
792         @param _amount     amount to convert, in fromToken
793         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
794 
795         @return conversion return amount
796     */
797     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
798             convertPath = [_fromToken, token, _toToken];
799             return quickConvert(convertPath, _amount, _minReturn);
800     }
801 
802     /**
803         @dev buys the token by depositing one of its connector tokens
804 
805         @param _connectorToken  connector token contract address
806         @param _depositAmount   amount to deposit (in the connector token)
807         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
808 
809         @return buy return amount
810     */
811     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
812         internal
813         conversionsAllowed
814         greaterThanZero(_minReturn)
815         returns (uint256)
816     {
817         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
818         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
819 
820         // update virtual balance if relevant
821         Connector storage connector = connectors[_connectorToken];
822         if (connector.isVirtualBalanceEnabled)
823             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
824 
825         // transfer _depositAmount funds from the caller in the connector token
826         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
827         // issue new funds to the caller in the smart token
828         token.issue(msg.sender, amount);
829 
830         dispatchConversionEvent(_connectorToken, _depositAmount, amount, true);
831         return amount;
832     }
833 
834     /**
835         @dev sells the token by withdrawing from one of its connector tokens
836 
837         @param _connectorToken  connector token contract address
838         @param _sellAmount      amount to sell (in the smart token)
839         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
840 
841         @return sell return amount
842     */
843     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
844         internal
845         conversionsAllowed
846         greaterThanZero(_minReturn)
847         returns (uint256)
848     {
849         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
850 
851         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
852         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
853 
854         uint256 tokenSupply = token.totalSupply();
855         uint256 connectorBalance = getConnectorBalance(_connectorToken);
856         // ensure that the trade will only deplete the connector if the total supply is depleted as well
857         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
858 
859         // update virtual balance if relevant
860         Connector storage connector = connectors[_connectorToken];
861         if (connector.isVirtualBalanceEnabled)
862             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
863 
864         // destroy _sellAmount from the caller's balance in the smart token
865         token.destroy(msg.sender, _sellAmount);
866         // transfer funds to the caller in the connector token
867         // the transfer might fail if the actual connector balance is smaller than the virtual balance
868         assert(_connectorToken.transfer(msg.sender, amount));
869 
870         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
871         return amount;
872     }
873 
874     /**
875         @dev converts the token to any other token in the bancor network by following a predefined conversion path
876         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
877 
878         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
879         @param _amount      amount to convert from (in the initial source token)
880         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
881 
882         @return tokens issued in return
883     */
884     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
885         public
886         payable
887         validConversionPath(_path)
888         returns (uint256)
889     {
890         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0, 0x0);
891     }
892 
893     /**
894         @dev converts the token to any other token in the bancor network by following a predefined conversion path
895         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
896 
897         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
898         @param _amount      amount to convert from (in the initial source token)
899         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
900         @param _block       if the current block exceeded the given parameter - it is cancelled
901         @param _nonce       the nonce of the sender address
902         @param _v           parameter that can be parsed from the transaction signature
903         @param _r           parameter that can be parsed from the transaction signature
904         @param _s           parameter that can be parsed from the transaction signature
905 
906         @return tokens issued in return
907     */
908     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
909         public
910         payable
911         validConversionPath(_path)
912         returns (uint256)
913     {
914         IERC20Token fromToken = _path[0];
915         IBancorQuickConverter quickConverter = extensions.quickConverter();
916 
917         // we need to transfer the source tokens from the caller to the quick converter,
918         // so it can execute the conversion on behalf of the caller
919         if (msg.value == 0) {
920             // not ETH, send the source tokens to the quick converter
921             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
922             if (fromToken == token) {
923                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
924                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
925             } else {
926                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
927                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
928             }
929         }
930 
931         // execute the conversion and pass on the ETH with the call
932         return quickConverter.convertForPrioritized.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _nonce, _v, _r, _s);
933     }
934 
935     // deprecated, backward compatibility
936     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
937         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
938     }
939 
940     /**
941         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
942 
943         @param _connectorToken  connector token contract address
944         @param _sellAmount      amount to sell (in the smart token)
945         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
946 
947         @return sale return amount
948     */
949     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
950         private
951         view
952         active
953         validConnector(_connectorToken)
954         greaterThanZero(_totalSupply)
955         returns (uint256)
956     {
957         Connector storage connector = connectors[_connectorToken];
958         uint256 connectorBalance = getConnectorBalance(_connectorToken);
959         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
960 
961         // deduct the fee from the return amount
962         uint256 feeAmount = getConversionFeeAmount(amount);
963         return safeSub(amount, feeAmount);
964     }
965 
966     /**
967         @dev helper, dispatches the Conversion event
968         The function also takes the tokens' decimals into account when calculating the current price
969 
970         @param _connectorToken  connector token contract address
971         @param _amount          amount purchased/sold (in the source token)
972         @param _returnAmount    amount returned (in the target token)
973         @param isPurchase       true if it's a purchase, false if it's a sale
974     */
975     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
976         Connector storage connector = connectors[_connectorToken];
977 
978         // calculate the new price using the simple price formula
979         // price = connector balance / (supply * weight)
980         // weight is represented in ppm, so multiplying by 1000000
981         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
982         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
983 
984         // normalize values
985         uint8 tokenDecimals = token.decimals();
986         uint8 connectorTokenDecimals = _connectorToken.decimals();
987         if (tokenDecimals != connectorTokenDecimals) {
988             if (tokenDecimals > connectorTokenDecimals)
989                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
990             else
991                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
992         }
993 
994         uint256 feeAmount = getConversionFeeAmount(_returnAmount);
995         // ensure that the fee is capped at 255 bits to prevent overflow when converting it to a signed int
996         assert(feeAmount <= 2 ** 255);
997 
998         if (isPurchase)
999             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, int256(feeAmount), connectorAmount, tokenAmount);
1000         else
1001             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, int256(feeAmount), tokenAmount, connectorAmount);
1002     }
1003 
1004     /**
1005         @dev fallback, buys the smart token with ETH
1006         note that the purchase will use the price at the time of the purchase
1007     */
1008     function() payable public {
1009         quickConvert(quickBuyPath, msg.value, 1);
1010     }
1011 }