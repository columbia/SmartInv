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
41     function safeAdd(uint256 _x, uint256 _y) internal constant returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal constant returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal constant returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     ERC20 Standard Token interface
77 */
78 contract IERC20Token {
79     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
80     function name() public constant returns (string) {}
81     function symbol() public constant returns (string) {}
82     function decimals() public constant returns (uint8) {}
83     function totalSupply() public constant returns (uint256) {}
84     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
85     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 }
91 
92 /*
93     Owned contract interface
94 */
95 contract IOwned {
96     // this function isn't abstract since the compiler emits automatically generated getter functions as external
97     function owner() public constant returns (address) {}
98 
99     function transferOwnership(address _newOwner) public;
100     function acceptOwnership() public;
101 }
102 
103 /*
104     Provides support and utilities for contract ownership
105 */
106 contract Owned is IOwned {
107     address public owner;
108     address public newOwner;
109 
110     event OwnerUpdate(address _prevOwner, address _newOwner);
111 
112     /**
113         @dev constructor
114     */
115     function Owned() {
116         owner = msg.sender;
117     }
118 
119     // allows execution by the owner only
120     modifier ownerOnly {
121         assert(msg.sender == owner);
122         _;
123     }
124 
125     /**
126         @dev allows transferring the contract ownership
127         the new owner still needs to accept the transfer
128         can only be called by the contract owner
129 
130         @param _newOwner    new contract owner
131     */
132     function transferOwnership(address _newOwner) public ownerOnly {
133         require(_newOwner != owner);
134         newOwner = _newOwner;
135     }
136 
137     /**
138         @dev used by a new owner to accept an ownership transfer
139     */
140     function acceptOwnership() public {
141         require(msg.sender == newOwner);
142         OwnerUpdate(owner, newOwner);
143         owner = newOwner;
144         newOwner = 0x0;
145     }
146 }
147 
148 /*
149     Provides support and utilities for contract management
150 */
151 contract Managed {
152     address public manager;
153     address public newManager;
154 
155     event ManagerUpdate(address _prevManager, address _newManager);
156 
157     /**
158         @dev constructor
159     */
160     function Managed() {
161         manager = msg.sender;
162     }
163 
164     // allows execution by the manager only
165     modifier managerOnly {
166         assert(msg.sender == manager);
167         _;
168     }
169 
170     /**
171         @dev allows transferring the contract management
172         the new manager still needs to accept the transfer
173         can only be called by the contract manager
174 
175         @param _newManager    new contract manager
176     */
177     function transferManagement(address _newManager) public managerOnly {
178         require(_newManager != manager);
179         newManager = _newManager;
180     }
181 
182     /**
183         @dev used by a new manager to accept a management transfer
184     */
185     function acceptManagement() public {
186         require(msg.sender == newManager);
187         ManagerUpdate(manager, newManager);
188         manager = newManager;
189         newManager = 0x0;
190     }
191 }
192 
193 /*
194     Token Holder interface
195 */
196 contract ITokenHolder is IOwned {
197     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
198 }
199 
200 /*
201     EIP228 Token Converter interface
202 */
203 contract ITokenConverter {
204     function convertibleTokenCount() public constant returns (uint16);
205     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
206     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
207     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
208     // deprecated, backward compatibility
209     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
210 }
211 
212 /*
213     We consider every contract to be a 'token holder' since it's currently not possible
214     for a contract to deny receiving tokens.
215 
216     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
217     the owner to send tokens that were sent to the contract by mistake back to their sender.
218 */
219 contract TokenHolder is ITokenHolder, Owned, Utils {
220     /**
221         @dev constructor
222     */
223     function TokenHolder() {
224     }
225 
226     /**
227         @dev withdraws tokens held by the contract and sends them to an account
228         can only be called by the owner
229 
230         @param _token   ERC20 token contract address
231         @param _to      account to receive the new amount
232         @param _amount  amount to withdraw
233     */
234     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
235         public
236         ownerOnly
237         validAddress(_token)
238         validAddress(_to)
239         notThis(_to)
240     {
241         assert(_token.transfer(_to, _amount));
242     }
243 }
244 
245 /*
246     Smart Token interface
247 */
248 contract ISmartToken is IOwned, IERC20Token {
249     function disableTransfers(bool _disable) public;
250     function issue(address _to, uint256 _amount) public;
251     function destroy(address _from, uint256 _amount) public;
252 }
253 
254 /*
255     Bancor Formula interface
256 */
257 contract IBancorFormula {
258     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
259     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
260 }
261 
262 /*
263     Bancor Gas Price Limit interface
264 */
265 contract IBancorGasPriceLimit {
266     function gasPrice() public constant returns (uint256) {}
267 }
268 
269 /*
270     Bancor Quick Converter interface
271 */
272 contract IBancorQuickConverter {
273     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
274     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
275 }
276 
277 /*
278     Bancor Converter Extensions interface
279 */
280 contract IBancorConverterExtensions {
281     function formula() public constant returns (IBancorFormula) {}
282     function gasPriceLimit() public constant returns (IBancorGasPriceLimit) {}
283     function quickConverter() public constant returns (IBancorQuickConverter) {}
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
369     Bancor Converter v0.6
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
401     string public version = '0.6';
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
416     // triggered when the conversion fee is updated
417     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
418 
419     /**
420         @dev constructor
421 
422         @param  _token              smart token governed by the converter
423         @param  _extensions         address of a bancor converter extensions contract
424         @param  _maxConversionFee   maximum conversion fee, represented in ppm
425         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
426         @param  _connectorWeight    optional, weight for the initial connector
427     */
428     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
429         SmartTokenController(_token)
430         validAddress(_extensions)
431         validMaxConversionFee(_maxConversionFee)
432     {
433         extensions = _extensions;
434         maxConversionFee = _maxConversionFee;
435 
436         if (address(_connectorToken) != 0x0)
437             addConnector(_connectorToken, _connectorWeight, false);
438     }
439 
440     // validates a connector token address - verifies that the address belongs to one of the connector tokens
441     modifier validConnector(IERC20Token _address) {
442         require(connectors[_address].isSet);
443         _;
444     }
445 
446     // validates a token address - verifies that the address belongs to one of the convertible tokens
447     modifier validToken(IERC20Token _address) {
448         require(_address == token || connectors[_address].isSet);
449         _;
450     }
451 
452     // verifies that the gas price is lower than the universal limit
453     modifier validGasPrice() {
454         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
455         _;
456     }
457 
458     // validates maximum conversion fee
459     modifier validMaxConversionFee(uint32 _conversionFee) {
460         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
461         _;
462     }
463 
464     // validates conversion fee
465     modifier validConversionFee(uint32 _conversionFee) {
466         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
467         _;
468     }
469 
470     // validates connector weight range
471     modifier validConnectorWeight(uint32 _weight) {
472         require(_weight > 0 && _weight <= MAX_WEIGHT);
473         _;
474     }
475 
476     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
477     modifier validConversionPath(IERC20Token[] _path) {
478         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
479         _;
480     }
481 
482     // allows execution only when conversions aren't disabled
483     modifier conversionsAllowed {
484         assert(conversionsEnabled);
485         _;
486     }
487 
488     /**
489         @dev returns the number of connector tokens defined
490 
491         @return number of connector tokens
492     */
493     function connectorTokenCount() public constant returns (uint16) {
494         return uint16(connectorTokens.length);
495     }
496 
497     /**
498         @dev returns the number of convertible tokens supported by the contract
499         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
500 
501         @return number of convertible tokens
502     */
503     function convertibleTokenCount() public constant returns (uint16) {
504         return connectorTokenCount() + 1;
505     }
506 
507     /**
508         @dev given a convertible token index, returns its contract address
509 
510         @param _tokenIndex  convertible token index
511 
512         @return convertible token address
513     */
514     function convertibleToken(uint16 _tokenIndex) public constant returns (address) {
515         if (_tokenIndex == 0)
516             return token;
517         return connectorTokens[_tokenIndex - 1];
518     }
519 
520     /*
521         @dev allows the owner to update the extensions contract address
522 
523         @param _extensions    address of a bancor converter extensions contract
524     */
525     function setExtensions(IBancorConverterExtensions _extensions)
526         public
527         ownerOnly
528         validAddress(_extensions)
529         notThis(_extensions)
530     {
531         extensions = _extensions;
532     }
533 
534     /*
535         @dev allows the manager to update the quick buy path
536 
537         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
538     */
539     function setQuickBuyPath(IERC20Token[] _path)
540         public
541         ownerOnly
542         validConversionPath(_path)
543     {
544         quickBuyPath = _path;
545     }
546 
547     /*
548         @dev allows the manager to clear the quick buy path
549     */
550     function clearQuickBuyPath() public ownerOnly {
551         quickBuyPath.length = 0;
552     }
553 
554     /**
555         @dev returns the length of the quick buy path array
556 
557         @return quick buy path length
558     */
559     function getQuickBuyPathLength() public constant returns (uint256) {
560         return quickBuyPath.length;
561     }
562 
563     /**
564         @dev disables the entire conversion functionality
565         this is a safety mechanism in case of a emergency
566         can only be called by the manager
567 
568         @param _disable true to disable conversions, false to re-enable them
569     */
570     function disableConversions(bool _disable) public managerOnly {
571         conversionsEnabled = !_disable;
572     }
573 
574     /**
575         @dev updates the current conversion fee
576         can only be called by the manager
577 
578         @param _conversionFee new conversion fee, represented in ppm
579     */
580     function setConversionFee(uint32 _conversionFee)
581         public
582         managerOnly
583         validConversionFee(_conversionFee)
584     {
585         ConversionFeeUpdate(conversionFee, _conversionFee);
586         conversionFee = _conversionFee;
587     }
588 
589     /*
590         @dev returns the conversion fee amount for a given return amount
591 
592         @return conversion fee amount
593     */
594     function getConversionFeeAmount(uint256 _amount) public constant returns (uint256) {
595         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
596     }
597 
598     /**
599         @dev defines a new connector for the token
600         can only be called by the owner while the converter is inactive
601 
602         @param _token                  address of the connector token
603         @param _weight                 constant connector weight, represented in ppm, 1-1000000
604         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
605     */
606     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
607         public
608         ownerOnly
609         inactive
610         validAddress(_token)
611         notThis(_token)
612         validConnectorWeight(_weight)
613     {
614         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
615 
616         connectors[_token].virtualBalance = 0;
617         connectors[_token].weight = _weight;
618         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
619         connectors[_token].isPurchaseEnabled = true;
620         connectors[_token].isSet = true;
621         connectorTokens.push(_token);
622         totalConnectorWeight += _weight;
623     }
624 
625     /**
626         @dev updates one of the token connectors
627         can only be called by the owner
628 
629         @param _connectorToken         address of the connector token
630         @param _weight                 constant connector weight, represented in ppm, 1-1000000
631         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
632         @param _virtualBalance         new connector's virtual balance
633     */
634     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
635         public
636         ownerOnly
637         validConnector(_connectorToken)
638         validConnectorWeight(_weight)
639     {
640         Connector storage connector = connectors[_connectorToken];
641         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
642 
643         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
644         connector.weight = _weight;
645         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
646         connector.virtualBalance = _virtualBalance;
647     }
648 
649     /**
650         @dev disables purchasing with the given connector token in case the connector token got compromised
651         can only be called by the owner
652         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
653 
654         @param _connectorToken  connector token contract address
655         @param _disable         true to disable the token, false to re-enable it
656     */
657     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
658         public
659         ownerOnly
660         validConnector(_connectorToken)
661     {
662         connectors[_connectorToken].isPurchaseEnabled = !_disable;
663     }
664 
665     /**
666         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
667 
668         @param _connectorToken  connector token contract address
669 
670         @return connector balance
671     */
672     function getConnectorBalance(IERC20Token _connectorToken)
673         public
674         constant
675         validConnector(_connectorToken)
676         returns (uint256)
677     {
678         Connector storage connector = connectors[_connectorToken];
679         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
680     }
681 
682     /**
683         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
684 
685         @param _fromToken  ERC20 token to convert from
686         @param _toToken    ERC20 token to convert to
687         @param _amount     amount to convert, in fromToken
688 
689         @return expected conversion return amount
690     */
691     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256) {
692         require(_fromToken != _toToken); // validate input
693 
694         // conversion between the token and one of its connectors
695         if (_toToken == token)
696             return getPurchaseReturn(_fromToken, _amount);
697         else if (_fromToken == token)
698             return getSaleReturn(_toToken, _amount);
699 
700         // conversion between 2 connectors
701         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
702         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
703     }
704 
705     /**
706         @dev returns the expected return for buying the token for a connector token
707 
708         @param _connectorToken  connector token contract address
709         @param _depositAmount   amount to deposit (in the connector token)
710 
711         @return expected purchase return amount
712     */
713     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
714         public
715         constant
716         active
717         validConnector(_connectorToken)
718         returns (uint256)
719     {
720         Connector storage connector = connectors[_connectorToken];
721         require(connector.isPurchaseEnabled); // validate input
722 
723         uint256 tokenSupply = token.totalSupply();
724         uint256 connectorBalance = getConnectorBalance(_connectorToken);
725         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
726 
727         // deduct the fee from the return amount
728         uint256 feeAmount = getConversionFeeAmount(amount);
729         return safeSub(amount, feeAmount);
730     }
731 
732     /**
733         @dev returns the expected return for selling the token for one of its connector tokens
734 
735         @param _connectorToken  connector token contract address
736         @param _sellAmount      amount to sell (in the smart token)
737 
738         @return expected sale return amount
739     */
740     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public constant returns (uint256) {
741         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
742     }
743 
744     /**
745         @dev converts a specific amount of _fromToken to _toToken
746 
747         @param _fromToken  ERC20 token to convert from
748         @param _toToken    ERC20 token to convert to
749         @param _amount     amount to convert, in fromToken
750         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
751 
752         @return conversion return amount
753     */
754     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
755         require(_fromToken != _toToken); // validate input
756 
757         // conversion between the token and one of its connectors
758         if (_toToken == token)
759             return buy(_fromToken, _amount, _minReturn);
760         else if (_fromToken == token)
761             return sell(_toToken, _amount, _minReturn);
762 
763         // conversion between 2 connectors
764         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
765         return sell(_toToken, purchaseAmount, _minReturn);
766     }
767 
768     /**
769         @dev buys the token by depositing one of its connector tokens
770 
771         @param _connectorToken  connector token contract address
772         @param _depositAmount   amount to deposit (in the connector token)
773         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
774 
775         @return buy return amount
776     */
777     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
778         public
779         conversionsAllowed
780         validGasPrice
781         greaterThanZero(_minReturn)
782         returns (uint256)
783     {
784         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
785         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
786 
787         // update virtual balance if relevant
788         Connector storage connector = connectors[_connectorToken];
789         if (connector.isVirtualBalanceEnabled)
790             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
791 
792         // transfer _depositAmount funds from the caller in the connector token
793         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
794         // issue new funds to the caller in the smart token
795         token.issue(msg.sender, amount);
796 
797         dispatchConversionEvent(_connectorToken, _depositAmount, amount, true);
798         return amount;
799     }
800 
801     /**
802         @dev sells the token by withdrawing from one of its connector tokens
803 
804         @param _connectorToken  connector token contract address
805         @param _sellAmount      amount to sell (in the smart token)
806         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
807 
808         @return sell return amount
809     */
810     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
811         public
812         conversionsAllowed
813         validGasPrice
814         greaterThanZero(_minReturn)
815         returns (uint256)
816     {
817         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
818 
819         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
820         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
821 
822         uint256 tokenSupply = token.totalSupply();
823         uint256 connectorBalance = getConnectorBalance(_connectorToken);
824         // ensure that the trade will only deplete the connector if the total supply is depleted as well
825         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
826 
827         // update virtual balance if relevant
828         Connector storage connector = connectors[_connectorToken];
829         if (connector.isVirtualBalanceEnabled)
830             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
831 
832         // destroy _sellAmount from the caller's balance in the smart token
833         token.destroy(msg.sender, _sellAmount);
834         // transfer funds to the caller in the connector token
835         // the transfer might fail if the actual connector balance is smaller than the virtual balance
836         assert(_connectorToken.transfer(msg.sender, amount));
837 
838         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
839         return amount;
840     }
841 
842     /**
843         @dev converts the token to any other token in the bancor network by following a predefined conversion path
844         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
845 
846         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
847         @param _amount      amount to convert from (in the initial source token)
848         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
849 
850         @return tokens issued in return
851     */
852     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
853         public
854         payable
855         validConversionPath(_path)
856         returns (uint256)
857     {
858         IERC20Token fromToken = _path[0];
859         IBancorQuickConverter quickConverter = extensions.quickConverter();
860 
861         // we need to transfer the source tokens from the caller to the quick converter,
862         // so it can execute the conversion on behalf of the caller
863         if (msg.value == 0) {
864             // not ETH, send the source tokens to the quick converter
865             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
866             if (fromToken == token) {
867                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
868                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
869             }
870             else {
871                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
872                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
873             }
874         }
875 
876         // execute the conversion and pass on the ETH with the call
877         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
878     }
879 
880     // deprecated, backward compatibility
881     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
882         return convert(_fromToken, _toToken, _amount, _minReturn);
883     }
884 
885     /**
886         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
887 
888         @param _connectorToken  connector token contract address
889         @param _sellAmount      amount to sell (in the smart token)
890         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
891 
892         @return sale return amount
893     */
894     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
895         private
896         constant
897         active
898         validConnector(_connectorToken)
899         greaterThanZero(_totalSupply)
900         returns (uint256)
901     {
902         Connector storage connector = connectors[_connectorToken];
903         uint256 connectorBalance = getConnectorBalance(_connectorToken);
904         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
905 
906         // deduct the fee from the return amount
907         uint256 feeAmount = getConversionFeeAmount(amount);
908         return safeSub(amount, feeAmount);
909     }
910 
911     /**
912         @dev helper, dispatches the Conversion event
913         The function also takes the tokens' decimals into account when calculating the current price
914 
915         @param _connectorToken  connector token contract address
916         @param _amount          amount purchased/sold (in the source token)
917         @param _returnAmount    amount returned (in the target token)
918         @param isPurchase       true if it's a purchase, false if it's a sale
919     */
920     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
921         Connector storage connector = connectors[_connectorToken];
922 
923         // calculate the new price using the simple price formula
924         // price = connector balance / (supply * weight)
925         // weight is represented in ppm, so multiplying by 1000000
926         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
927         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
928 
929         // normalize values
930         uint8 tokenDecimals = token.decimals();
931         uint8 connectorTokenDecimals = _connectorToken.decimals();
932         if (tokenDecimals != connectorTokenDecimals) {
933             if (tokenDecimals > connectorTokenDecimals)
934                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
935             else
936                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
937         }
938 
939         if (isPurchase)
940             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, connectorAmount, tokenAmount);
941         else
942             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, tokenAmount, connectorAmount);
943     }
944 
945     /**
946         @dev fallback, buys the smart token with ETH
947         note that the purchase will use the price at the time of the purchase
948     */
949     function() payable {
950         quickConvert(quickBuyPath, msg.value, 1);
951     }
952 }