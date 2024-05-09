1 pragma solidity ^0.4.11;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() {
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
21         require(_address != 0x0);
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
41     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
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
80     function owner() public constant returns (address) {}
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
93     event OwnerUpdate(address _prevOwner, address _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() {
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
127         newOwner = 0x0;
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
138     event ManagerUpdate(address _prevManager, address _newManager);
139 
140     /**
141         @dev constructor
142     */
143     function Managed() {
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
172         newManager = 0x0;
173     }
174 }
175 
176 /*
177     ERC20 Standard Token interface
178 */
179 contract IERC20Token {
180     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
181     function name() public constant returns (string) {}
182     function symbol() public constant returns (string) {}
183     function decimals() public constant returns (uint8) {}
184     function totalSupply() public constant returns (uint256) {}
185     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
186     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
187 
188     function transfer(address _to, uint256 _value) public returns (bool success);
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
190     function approve(address _spender, uint256 _value) public returns (bool success);
191 }
192 
193 /*
194     EIP228 Token Converter interface
195 */
196 contract ITokenConverter {
197     function convertibleTokenCount() public constant returns (uint16);
198     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
199     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
200     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
201     // deprecated, backward compatibility
202     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
203 }
204 
205 /*
206     Token Holder interface
207 */
208 contract ITokenHolder is IOwned {
209     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
210 }
211 
212 /*
213     Smart Token interface
214 */
215 contract ISmartToken is IOwned, IERC20Token {
216     function disableTransfers(bool _disable) public;
217     function issue(address _to, uint256 _amount) public;
218     function destroy(address _from, uint256 _amount) public;
219 }
220 
221 /*
222     Bancor Formula interface
223 */
224 contract IBancorFormula {
225     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
226     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
227 }
228 
229 /*
230     Bancor Gas Price Limit interface
231 */
232 contract IBancorGasPriceLimit {
233     function gasPrice() public constant returns (uint256) {}
234 }
235 
236 /*
237     Bancor Quick Converter interface
238 */
239 contract IBancorQuickConverter {
240     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
241     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
242 }
243 
244 /*
245     Bancor Converter Extensions interface
246 */
247 contract IBancorConverterExtensions {
248     function formula() public constant returns (IBancorFormula) {}
249     function gasPriceLimit() public constant returns (IBancorGasPriceLimit) {}
250     function quickConverter() public constant returns (IBancorQuickConverter) {}
251 }
252 
253 /*
254     We consider every contract to be a 'token holder' since it's currently not possible
255     for a contract to deny receiving tokens.
256 
257     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
258     the owner to send tokens that were sent to the contract by mistake back to their sender.
259 */
260 contract TokenHolder is ITokenHolder, Owned, Utils {
261     /**
262         @dev constructor
263     */
264     function TokenHolder() {
265     }
266 
267     /**
268         @dev withdraws tokens held by the contract and sends them to an account
269         can only be called by the owner
270 
271         @param _token   ERC20 token contract address
272         @param _to      account to receive the new amount
273         @param _amount  amount to withdraw
274     */
275     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
276         public
277         ownerOnly
278         validAddress(_token)
279         validAddress(_to)
280         notThis(_to)
281     {
282         assert(_token.transfer(_to, _amount));
283     }
284 }
285 
286 /*
287     The smart token controller is an upgradable part of the smart token that allows
288     more functionality as well as fixes for bugs/exploits.
289     Once it accepts ownership of the token, it becomes the token's sole controller
290     that can execute any of its functions.
291 
292     To upgrade the controller, ownership must be transferred to a new controller, along with
293     any relevant data.
294 
295     The smart token must be set on construction and cannot be changed afterwards.
296     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
297 
298     Note that the controller can transfer token ownership to a new controller that
299     doesn't allow executing any function on the token, for a trustless solution.
300     Doing that will also remove the owner's ability to upgrade the controller.
301 */
302 contract SmartTokenController is TokenHolder {
303     ISmartToken public token;   // smart token
304 
305     /**
306         @dev constructor
307     */
308     function SmartTokenController(ISmartToken _token)
309         validAddress(_token)
310     {
311         token = _token;
312     }
313 
314     // ensures that the controller is the token's owner
315     modifier active() {
316         assert(token.owner() == address(this));
317         _;
318     }
319 
320     // ensures that the controller is not the token's owner
321     modifier inactive() {
322         assert(token.owner() != address(this));
323         _;
324     }
325 
326     /**
327         @dev allows transferring the token ownership
328         the new owner still need to accept the transfer
329         can only be called by the contract owner
330 
331         @param _newOwner    new token owner
332     */
333     function transferTokenOwnership(address _newOwner) public ownerOnly {
334         token.transferOwnership(_newOwner);
335     }
336 
337     /**
338         @dev used by a new owner to accept a token ownership transfer
339         can only be called by the contract owner
340     */
341     function acceptTokenOwnership() public ownerOnly {
342         token.acceptOwnership();
343     }
344 
345     /**
346         @dev disables/enables token transfers
347         can only be called by the contract owner
348 
349         @param _disable    true to disable transfers, false to enable them
350     */
351     function disableTokenTransfers(bool _disable) public ownerOnly {
352         token.disableTransfers(_disable);
353     }
354 
355     /**
356         @dev withdraws tokens held by the token and sends them to an account
357         can only be called by the owner
358 
359         @param _token   ERC20 token contract address
360         @param _to      account to receive the new amount
361         @param _amount  amount to withdraw
362     */
363     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
364         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
365     }
366 }
367 
368 /*
369     Bancor Converter v0.5
370 
371     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
372 
373     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
374     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
375 
376     The converter is upgradable (just like any SmartTokenController).
377 
378     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
379              or with very small numbers because of precision loss
380 
381 
382     Open issues:
383     - Front-running attacks are currently mitigated by the following mechanisms:
384         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
385         - gas price limit prevents users from having control over the order of execution
386       Other potential solutions might include a commit/reveal based schemes
387     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
388 */
389 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
390     uint32 private constant MAX_WEIGHT = 1000000;
391     uint32 private constant MAX_CONVERSION_FEE = 1000000;
392 
393     struct Connector {
394         uint256 virtualBalance;         // connector virtual balance
395         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
396         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
397         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
398         bool isSet;                     // used to tell if the mapping element is defined
399     }
400 
401     string public version = '0.5';
402     string public converterType = 'bancor';
403 
404     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
405     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
406     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
407     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
408     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
409     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
410     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
411     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
412 
413     // triggered when a conversion between two tokens occurs (TokenConverter event)
414     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
415                      uint256 _currentPriceN, uint256 _currentPriceD);
416 
417     /**
418         @dev constructor
419 
420         @param  _token              smart token governed by the converter
421         @param  _extensions         address of a bancor converter extensions contract
422         @param  _maxConversionFee   maximum conversion fee, represented in ppm
423         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
424         @param  _connectorWeight    optional, weight for the initial connector
425     */
426     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
427         SmartTokenController(_token)
428         validAddress(_extensions)
429         validMaxConversionFee(_maxConversionFee)
430     {
431         extensions = _extensions;
432         maxConversionFee = _maxConversionFee;
433 
434         if (address(_connectorToken) != 0x0)
435             addConnector(_connectorToken, _connectorWeight, false);
436     }
437 
438     // validates a connector token address - verifies that the address belongs to one of the connector tokens
439     modifier validConnector(IERC20Token _address) {
440         require(connectors[_address].isSet);
441         _;
442     }
443 
444     // validates a token address - verifies that the address belongs to one of the convertible tokens
445     modifier validToken(IERC20Token _address) {
446         require(_address == token || connectors[_address].isSet);
447         _;
448     }
449 
450     // verifies that the gas price is lower than the universal limit
451     modifier validGasPrice() {
452         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
453         _;
454     }
455 
456     // validates maximum conversion fee
457     modifier validMaxConversionFee(uint32 _conversionFee) {
458         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
459         _;
460     }
461 
462     // validates conversion fee
463     modifier validConversionFee(uint32 _conversionFee) {
464         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
465         _;
466     }
467 
468     // validates connector weight range
469     modifier validConnectorWeight(uint32 _weight) {
470         require(_weight > 0 && _weight <= MAX_WEIGHT);
471         _;
472     }
473 
474     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
475     modifier validConversionPath(IERC20Token[] _path) {
476         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
477         _;
478     }
479 
480     // allows execution only when conversions aren't disabled
481     modifier conversionsAllowed {
482         assert(conversionsEnabled);
483         _;
484     }
485 
486     /**
487         @dev returns the number of connector tokens defined
488 
489         @return number of connector tokens
490     */
491     function connectorTokenCount() public constant returns (uint16) {
492         return uint16(connectorTokens.length);
493     }
494 
495     /**
496         @dev returns the number of convertible tokens supported by the contract
497         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
498 
499         @return number of convertible tokens
500     */
501     function convertibleTokenCount() public constant returns (uint16) {
502         return connectorTokenCount() + 1;
503     }
504 
505     /**
506         @dev given a convertible token index, returns its contract address
507 
508         @param _tokenIndex  convertible token index
509 
510         @return convertible token address
511     */
512     function convertibleToken(uint16 _tokenIndex) public constant returns (address) {
513         if (_tokenIndex == 0)
514             return token;
515         return connectorTokens[_tokenIndex - 1];
516     }
517 
518     /*
519         @dev allows the owner to update the extensions contract address
520 
521         @param _extensions    address of a bancor converter extensions contract
522     */
523     function setExtensions(IBancorConverterExtensions _extensions)
524         public
525         ownerOnly
526         validAddress(_extensions)
527         notThis(_extensions)
528     {
529         extensions = _extensions;
530     }
531 
532     /*
533         @dev allows the manager to update the quick buy path
534 
535         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
536     */
537     function setQuickBuyPath(IERC20Token[] _path)
538         public
539         ownerOnly
540         validConversionPath(_path)
541     {
542         quickBuyPath = _path;
543     }
544 
545     /*
546         @dev allows the manager to clear the quick buy path
547     */
548     function clearQuickBuyPath() public ownerOnly {
549         quickBuyPath.length = 0;
550     }
551 
552     /**
553         @dev returns the length of the quick buy path array
554 
555         @return quick buy path length
556     */
557     function getQuickBuyPathLength() public constant returns (uint256) {
558         return quickBuyPath.length;
559     }
560 
561     /**
562         @dev disables the entire conversion functionality
563         this is a safety mechanism in case of a emergency
564         can only be called by the manager
565 
566         @param _disable true to disable conversions, false to re-enable them
567     */
568     function disableConversions(bool _disable) public managerOnly {
569         conversionsEnabled = !_disable;
570     }
571 
572     /**
573         @dev updates the current conversion fee
574         can only be called by the manager
575 
576         @param _conversionFee new conversion fee, represented in ppm
577     */
578     function setConversionFee(uint32 _conversionFee)
579         public
580         managerOnly
581         validConversionFee(_conversionFee)
582     {
583         conversionFee = _conversionFee;
584     }
585 
586     /*
587         @dev returns the conversion fee amount for a given return amount
588 
589         @return conversion fee amount
590     */
591     function getConversionFeeAmount(uint256 _amount) public constant returns (uint256) {
592         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
593     }
594 
595     /**
596         @dev defines a new connector for the token
597         can only be called by the owner while the converter is inactive
598 
599         @param _token                  address of the connector token
600         @param _weight                 constant connector weight, represented in ppm, 1-1000000
601         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
602     */
603     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
604         public
605         ownerOnly
606         inactive
607         validAddress(_token)
608         notThis(_token)
609         validConnectorWeight(_weight)
610     {
611         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
612 
613         connectors[_token].virtualBalance = 0;
614         connectors[_token].weight = _weight;
615         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
616         connectors[_token].isPurchaseEnabled = true;
617         connectors[_token].isSet = true;
618         connectorTokens.push(_token);
619         totalConnectorWeight += _weight;
620     }
621 
622     /**
623         @dev updates one of the token connectors
624         can only be called by the owner
625 
626         @param _connectorToken         address of the connector token
627         @param _weight                 constant connector weight, represented in ppm, 1-1000000
628         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
629         @param _virtualBalance         new connector's virtual balance
630     */
631     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
632         public
633         ownerOnly
634         validConnector(_connectorToken)
635         validConnectorWeight(_weight)
636     {
637         Connector storage connector = connectors[_connectorToken];
638         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
639 
640         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
641         connector.weight = _weight;
642         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
643         connector.virtualBalance = _virtualBalance;
644     }
645 
646     /**
647         @dev disables purchasing with the given connector token in case the connector token got compromised
648         can only be called by the owner
649         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
650 
651         @param _connectorToken  connector token contract address
652         @param _disable         true to disable the token, false to re-enable it
653     */
654     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
655         public
656         ownerOnly
657         validConnector(_connectorToken)
658     {
659         connectors[_connectorToken].isPurchaseEnabled = !_disable;
660     }
661 
662     /**
663         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
664 
665         @param _connectorToken  connector token contract address
666 
667         @return connector balance
668     */
669     function getConnectorBalance(IERC20Token _connectorToken)
670         public
671         constant
672         validConnector(_connectorToken)
673         returns (uint256)
674     {
675         Connector storage connector = connectors[_connectorToken];
676         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
677     }
678 
679     /**
680         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
681 
682         @param _fromToken  ERC20 token to convert from
683         @param _toToken    ERC20 token to convert to
684         @param _amount     amount to convert, in fromToken
685 
686         @return expected conversion return amount
687     */
688     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256) {
689         require(_fromToken != _toToken); // validate input
690 
691         // conversion between the token and one of its connectors
692         if (_toToken == token)
693             return getPurchaseReturn(_fromToken, _amount);
694         else if (_fromToken == token)
695             return getSaleReturn(_toToken, _amount);
696 
697         // conversion between 2 connectors
698         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
699         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
700     }
701 
702     /**
703         @dev returns the expected return for buying the token for a connector token
704 
705         @param _connectorToken  connector token contract address
706         @param _depositAmount   amount to deposit (in the connector token)
707 
708         @return expected purchase return amount
709     */
710     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
711         public
712         constant
713         active
714         validConnector(_connectorToken)
715         returns (uint256)
716     {
717         Connector storage connector = connectors[_connectorToken];
718         require(connector.isPurchaseEnabled); // validate input
719 
720         uint256 tokenSupply = token.totalSupply();
721         uint256 connectorBalance = getConnectorBalance(_connectorToken);
722         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
723 
724         // deduct the fee from the return amount
725         uint256 feeAmount = getConversionFeeAmount(amount);
726         return safeSub(amount, feeAmount);
727     }
728 
729     /**
730         @dev returns the expected return for selling the token for one of its connector tokens
731 
732         @param _connectorToken  connector token contract address
733         @param _sellAmount      amount to sell (in the smart token)
734 
735         @return expected sale return amount
736     */
737     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public constant returns (uint256) {
738         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
739     }
740 
741     /**
742         @dev converts a specific amount of _fromToken to _toToken
743 
744         @param _fromToken  ERC20 token to convert from
745         @param _toToken    ERC20 token to convert to
746         @param _amount     amount to convert, in fromToken
747         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
748 
749         @return conversion return amount
750     */
751     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
752         require(_fromToken != _toToken); // validate input
753 
754         // conversion between the token and one of its connectors
755         if (_toToken == token)
756             return buy(_fromToken, _amount, _minReturn);
757         else if (_fromToken == token)
758             return sell(_toToken, _amount, _minReturn);
759 
760         // conversion between 2 connectors
761         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
762         return sell(_toToken, purchaseAmount, _minReturn);
763     }
764 
765     /**
766         @dev buys the token by depositing one of its connector tokens
767 
768         @param _connectorToken  connector token contract address
769         @param _depositAmount   amount to deposit (in the connector token)
770         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
771 
772         @return buy return amount
773     */
774     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
775         public
776         conversionsAllowed
777         validGasPrice
778         greaterThanZero(_minReturn)
779         returns (uint256)
780     {
781         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
782         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
783 
784         // update virtual balance if relevant
785         Connector storage connector = connectors[_connectorToken];
786         if (connector.isVirtualBalanceEnabled)
787             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
788 
789         // transfer _depositAmount funds from the caller in the connector token
790         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
791         // issue new funds to the caller in the smart token
792         token.issue(msg.sender, amount);
793 
794         // calculate the new price using the simple price formula
795         // price = connector balance / (supply * weight)
796         // weight is represented in ppm, so multiplying by 1000000
797         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
798         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
799         Conversion(_connectorToken, token, msg.sender, _depositAmount, amount, connectorAmount, tokenAmount);
800         return amount;
801     }
802 
803     /**
804         @dev sells the token by withdrawing from one of its connector tokens
805 
806         @param _connectorToken  connector token contract address
807         @param _sellAmount      amount to sell (in the smart token)
808         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
809 
810         @return sell return amount
811     */
812     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
813         public
814         conversionsAllowed
815         validGasPrice
816         greaterThanZero(_minReturn)
817         returns (uint256)
818     {
819         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
820 
821         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
822         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
823 
824         uint256 tokenSupply = token.totalSupply();
825         uint256 connectorBalance = getConnectorBalance(_connectorToken);
826         // ensure that the trade will only deplete the connector if the total supply is depleted as well
827         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
828 
829         // update virtual balance if relevant
830         Connector storage connector = connectors[_connectorToken];
831         if (connector.isVirtualBalanceEnabled)
832             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
833 
834         // destroy _sellAmount from the caller's balance in the smart token
835         token.destroy(msg.sender, _sellAmount);
836         // transfer funds to the caller in the connector token
837         // the transfer might fail if the actual connector balance is smaller than the virtual balance
838         assert(_connectorToken.transfer(msg.sender, amount));
839 
840         // calculate the new price using the simple price formula
841         // price = connector balance / (supply * weight)
842         // weight is represented in ppm, so multiplying by 1000000
843         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
844         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
845         Conversion(token, _connectorToken, msg.sender, _sellAmount, amount, tokenAmount, connectorAmount);
846         return amount;
847     }
848 
849     /**
850         @dev converts the token to any other token in the bancor network by following a predefined conversion path
851         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
852 
853         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
854         @param _amount      amount to convert from (in the initial source token)
855         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
856 
857         @return tokens issued in return
858     */
859     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
860         public
861         payable
862         validConversionPath(_path)
863         returns (uint256)
864     {
865         IERC20Token fromToken = _path[0];
866         IBancorQuickConverter quickConverter = extensions.quickConverter();
867 
868         // we need to transfer the source tokens from the caller to the quick converter,
869         // so it can execute the conversion on behalf of the caller
870         if (msg.value == 0) {
871             // not ETH, send the source tokens to the quick converter
872             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
873             if (fromToken == token) {
874                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
875                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
876             }
877             else {
878                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
879                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
880             }
881         }
882 
883         // execute the conversion and pass on the ETH with the call
884         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
885     }
886 
887     // deprecated, backward compatibility
888     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
889         return convert(_fromToken, _toToken, _amount, _minReturn);
890     }
891 
892     /**
893         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
894 
895         @param _connectorToken  connector token contract address
896         @param _sellAmount      amount to sell (in the smart token)
897         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
898 
899         @return sale return amount
900     */
901     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
902         private
903         constant
904         active
905         validConnector(_connectorToken)
906         greaterThanZero(_totalSupply)
907         returns (uint256)
908     {
909         Connector storage connector = connectors[_connectorToken];
910         uint256 connectorBalance = getConnectorBalance(_connectorToken);
911         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
912 
913         // deduct the fee from the return amount
914         uint256 feeAmount = getConversionFeeAmount(amount);
915         return safeSub(amount, feeAmount);
916     }
917 
918     /**
919         @dev fallback, buys the smart token with ETH
920         note that the purchase will use the price at the time of the purchase
921     */
922     function() payable {
923         quickConvert(quickBuyPath, msg.value, 1);
924     }
925 }