1 pragma solidity ^0.4.18;
2 
3 
4 
5 /*
6     Utilities & Common Modifiers
7 */
8 contract Utils {
9 
10     // verifies that an amount is greater than zero
11     modifier greaterThanZero(uint256 _amount) {
12         require(_amount > 0);
13         _;
14     }
15 
16     // validates an address - currently only checks that it isn't null
17     modifier validAddress(address _address) {
18         require(_address != address(0));
19         _;
20     }
21 
22     // verifies that the address is different than this contract address
23     modifier notThis(address _address) {
24         require(_address != address(this));
25         _;
26     }
27 
28     // Overflow protected math functions
29 
30     /**
31         @dev returns the sum of _x and _y, asserts if the calculation overflows
32 
33         @param _x   value 1
34         @param _y   value 2
35 
36         @return sum
37     */
38     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
39         uint256 z = _x + _y;
40         assert(z >= _x);
41         return z;
42     }
43 
44     /**
45         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
46 
47         @param _x   minuend
48         @param _y   subtrahend
49 
50         @return difference
51     */
52     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
53         assert(_x >= _y);
54         return _x - _y;
55     }
56 
57     /**
58         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
59 
60         @param _x   factor 1
61         @param _y   factor 2
62 
63         @return product
64     */
65     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
66         uint256 z = _x * _y;
67         assert(_x == 0 || z / _x == _y);
68         return z;
69     }
70 }
71 
72 
73 
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
86 
87 /*
88     ERC20 Standard Token interface
89 */
90 contract IERC20Token {
91     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
92     function name() public view returns (string) {}
93     function symbol() public view returns (string) {}
94     function decimals() public view returns (uint8) {}
95     function totalSupply() public view returns (uint256) {}
96     function balanceOf(address _owner) public view returns (uint256) { _owner; }
97     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
98 
99     function transfer(address _to, uint256 _value) public returns (bool success);
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
101     function approve(address _spender, uint256 _value) public returns (bool success);
102 }
103 
104 
105 
106 
107 /*
108     Bancor Quick Converter interface
109 */
110 contract IBancorQuickConverter {
111     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
112     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
113     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
114 }
115 
116 
117 /*
118     Bancor Gas Price Limit interface
119 */
120 contract IBancorGasPriceLimit {
121     function gasPrice() public view returns (uint256) {}
122     function validateGasPrice(uint256) public view;
123 }
124 
125 
126 /*
127     Bancor Formula interface
128 */
129 contract IBancorFormula {
130     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
131     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
132     function calculateCrossConnectorReturn(uint256 _connector1Balance, uint32 _connector1Weight, uint256 _connector2Balance, uint32 _connector2Weight, uint256 _amount) public view returns (uint256);
133 }
134 
135 
136 
137 
138 
139 /*
140     Bancor Converter Extensions interface
141 */
142 contract IBancorConverterExtensions {
143     function formula() public view returns (IBancorFormula) {}
144     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
145     function quickConverter() public view returns (IBancorQuickConverter) {}
146 }
147 
148 
149 
150 /*
151     EIP228 Token Converter interface
152 */
153 contract ITokenConverter {
154     function convertibleTokenCount() public view returns (uint16);
155     function convertibleToken(uint16 _tokenIndex) public view returns (address);
156     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
157     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
158     // deprecated, backward compatibility
159     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
160 }
161 
162 
163 /*
164     Provides support and utilities for contract management
165 */
166 contract Managed {
167     address public manager;
168     address public newManager;
169 
170     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
171 
172     /**
173         @dev constructor
174     */
175     function Managed() public {
176         manager = msg.sender;
177     }
178 
179     // allows execution by the manager only
180     modifier managerOnly {
181         assert(msg.sender == manager);
182         _;
183     }
184 
185     /**
186         @dev allows transferring the contract management
187         the new manager still needs to accept the transfer
188         can only be called by the contract manager
189 
190         @param _newManager    new contract manager
191     */
192     function transferManagement(address _newManager) public managerOnly {
193         require(_newManager != manager);
194         newManager = _newManager;
195     }
196 
197     /**
198         @dev used by a new manager to accept a management transfer
199     */
200     function acceptManagement() public {
201         require(msg.sender == newManager);
202         ManagerUpdate(manager, newManager);
203         manager = newManager;
204         newManager = address(0);
205     }
206 }
207 
208 
209 
210 
211 
212 
213 /*
214     Provides support and utilities for contract ownership
215 */
216 contract Owned is IOwned {
217     address public owner;
218     address public newOwner;
219 
220     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
221 
222     /**
223         @dev constructor
224     */
225     constructor () public {
226         owner = msg.sender;
227     }
228 
229     // allows execution by the owner only
230     modifier ownerOnly {
231         assert(msg.sender == owner);
232         _;
233     }
234 
235     /**
236         @dev allows transferring the contract ownership
237         the new owner still needs to accept the transfer
238         can only be called by the contract owner
239 
240         @param _newOwner    new contract owner
241     */
242     function transferOwnership(address _newOwner) public ownerOnly {
243         require(_newOwner != owner);
244         newOwner = _newOwner;
245     }
246 
247     /**
248         @dev used by a new owner to accept an ownership transfer
249     */
250     function acceptOwnership() public {
251         require(msg.sender == newOwner);
252         emit OwnerUpdate(owner, newOwner);
253         owner = newOwner;
254         newOwner = address(0);
255     }
256 }
257 
258 
259 
260 /*
261     Token Holder interface
262 */
263 contract ITokenHolder is IOwned {
264     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
265 }
266 
267 
268 
269 /*
270     We consider every contract to be a 'token holder' since it's currently not possible
271     for a contract to deny receiving tokens.
272 
273     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
274     the owner to send tokens that were sent to the contract by mistake back to their sender.
275 */
276 contract TokenHolder is ITokenHolder, Owned, Utils {
277 
278     /**
279         @dev withdraws tokens held by the contract and sends them to an account
280         can only be called by the owner
281 
282         @param _token   ERC20 token contract address
283         @param _to      account to receive the new amount
284         @param _amount  amount to withdraw
285     */
286     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
287         public
288         ownerOnly
289         validAddress(_token)
290         validAddress(_to)
291         notThis(_to)
292     {
293         assert(_token.transfer(_to, _amount));
294     }
295 }
296 
297 
298 
299 /*
300     The smart token controller is an upgradable part of the smart token that allows
301     more functionality as well as fixes for bugs/exploits.
302     Once it accepts ownership of the token, it becomes the token's sole controller
303     that can execute any of its functions.
304 
305     To upgrade the controller, ownership must be transferred to a new controller, along with
306     any relevant data.
307 
308     The smart token must be set on construction and cannot be changed afterwards.
309     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
310 
311     Note that the controller can transfer token ownership to a new controller that
312     doesn't allow executing any function on the token, for a trustless solution.
313     Doing that will also remove the owner's ability to upgrade the controller.
314 */
315 contract SmartTokenController is TokenHolder {
316     ISmartToken public token;   // smart token
317 
318     /**
319         @dev constructor
320     */
321     constructor(ISmartToken _token)
322         public
323         validAddress(_token)
324     {
325         token = _token;
326     }
327 
328     // ensures that the controller is the token's owner
329     modifier active() {
330         assert(token.owner() == address(this));
331         _;
332     }
333 
334     // ensures that the controller is not the token's owner
335     modifier inactive() {
336         assert(token.owner() != address(this));
337         _;
338     }
339 
340     /**
341         @dev allows transferring the token ownership
342         the new owner still need to accept the transfer
343         can only be called by the contract owner
344 
345         @param _newOwner    new token owner
346     */
347     function transferTokenOwnership(address _newOwner) public ownerOnly {
348         token.transferOwnership(_newOwner);
349     }
350 
351     /**
352         @dev used by a new owner to accept a token ownership transfer
353         can only be called by the contract owner
354     */
355     function acceptTokenOwnership() public ownerOnly {
356         token.acceptOwnership();
357     }
358 
359     /**
360         @dev disables/enables token transfers
361         can only be called by the contract owner
362 
363         @param _disable    true to disable transfers, false to enable them
364     */
365     function disableTokenTransfers(bool _disable) public ownerOnly {
366         token.disableTransfers(_disable);
367     }
368 
369     /**
370         @dev withdraws tokens held by the controller and sends them to an account
371         can only be called by the owner
372 
373         @param _token   ERC20 token contract address
374         @param _to      account to receive the new amount
375         @param _amount  amount to withdraw
376     */
377     function withdrawFromToken(
378         IERC20Token _token,
379         address _to,
380         uint256 _amount
381     )
382         public
383         ownerOnly
384     {
385         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
386     }
387 }
388 
389 
390 
391 
392 
393 
394 /*
395     Smart Token interface
396 */
397 contract ISmartToken is IOwned, IERC20Token {
398     function disableTransfers(bool _disable) public;
399     function issue(address _to, uint256 _amount) public;
400     function destroy(address _from, uint256 _amount) public;
401 }
402 
403 
404 
405 
406 
407 
408 
409 
410 
411 /*
412     Ether Token interface
413 */
414 contract IEtherToken is ITokenHolder, IERC20Token {
415     function deposit() public payable;
416     function withdraw(uint256 _amount) public;
417     function withdrawTo(address _to, uint256 _amount) public;
418 }
419 
420 
421 /*
422     Bancor Converter v0.8
423 
424     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
425 
426     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
427     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
428 
429     The converter is upgradable (just like any SmartTokenController).
430 
431     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
432              or with very small numbers because of precision loss
433 
434 
435     Open issues:
436     - Front-running attacks are currently mitigated by the following mechanisms:
437         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
438         - gas price limit prevents users from having control over the order of execution
439       Other potential solutions might include a commit/reveal based schemes
440     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
441 */
442 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
443     uint32 private constant MAX_WEIGHT = 1000000;
444     uint32 private constant MAX_CONVERSION_FEE = 1000000;
445 
446     struct Connector {
447         uint256 virtualBalance;         // connector virtual balance
448         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
449         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
450         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
451         bool isSet;                     // used to tell if the mapping element is defined
452     }
453 
454     string public version = '0.8';
455     string public converterType = 'bancor';
456 
457     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
458     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
459     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
460     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
461     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
462     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
463     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
464     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
465     IERC20Token[] private convertPath;
466 
467     // triggered when a conversion between two tokens occurs (TokenConverter event)
468     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
469                      int256 _conversionFee, uint256 _currentPriceN, uint256 _currentPriceD);
470     // triggered when the conversion fee is updated
471     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
472 
473     /**
474         @dev constructor
475 
476         @param  _token              smart token governed by the converter
477         @param  _extensions         address of a bancor converter extensions contract
478         @param  _maxConversionFee   maximum conversion fee, represented in ppm
479         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
480         @param  _connectorWeight    optional, weight for the initial connector
481     */
482     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
483         public
484         SmartTokenController(_token)
485         validAddress(_extensions)
486         validMaxConversionFee(_maxConversionFee)
487     {
488         extensions = _extensions;
489         maxConversionFee = _maxConversionFee;
490 
491         if (_connectorToken != address(0))
492             addConnector(_connectorToken, _connectorWeight, false);
493     }
494 
495     // validates a connector token address - verifies that the address belongs to one of the connector tokens
496     modifier validConnector(IERC20Token _address) {
497         require(connectors[_address].isSet);
498         _;
499     }
500 
501     // validates a token address - verifies that the address belongs to one of the convertible tokens
502     modifier validToken(IERC20Token _address) {
503         require(_address == token || connectors[_address].isSet);
504         _;
505     }
506 
507     // validates maximum conversion fee
508     modifier validMaxConversionFee(uint32 _conversionFee) {
509         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
510         _;
511     }
512 
513     // validates conversion fee
514     modifier validConversionFee(uint32 _conversionFee) {
515         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
516         _;
517     }
518 
519     // validates connector weight range
520     modifier validConnectorWeight(uint32 _weight) {
521         require(_weight > 0 && _weight <= MAX_WEIGHT);
522         _;
523     }
524 
525     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
526     modifier validConversionPath(IERC20Token[] _path) {
527         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
528         _;
529     }
530 
531     // allows execution only when conversions aren't disabled
532     modifier conversionsAllowed {
533         assert(conversionsEnabled);
534         _;
535     }
536 
537     // allows execution only for owner or manager
538     modifier ownerOrManagerOnly {
539         require(msg.sender == owner || msg.sender == manager);
540         _;
541     }
542 
543     // allows execution only for quick convreter
544     modifier quickConverterOnly {
545         require(msg.sender == address(extensions.quickConverter()));
546         _;
547     }
548 
549     /**
550         @dev returns the number of connector tokens defined
551 
552         @return number of connector tokens
553     */
554     function connectorTokenCount() public view returns (uint16) {
555         return uint16(connectorTokens.length);
556     }
557 
558     /**
559         @dev returns the number of convertible tokens supported by the contract
560         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
561 
562         @return number of convertible tokens
563     */
564     function convertibleTokenCount() public view returns (uint16) {
565         return connectorTokenCount() + 1;
566     }
567 
568     /**
569         @dev given a convertible token index, returns its contract address
570 
571         @param _tokenIndex  convertible token index
572 
573         @return convertible token address
574     */
575     function convertibleToken(uint16 _tokenIndex) public view returns (address) {
576         if (_tokenIndex == 0)
577             return token;
578         return connectorTokens[_tokenIndex - 1];
579     }
580 
581     /*
582         @dev allows the owner to update the extensions contract address
583 
584         @param _extensions    address of a bancor converter extensions contract
585     */
586     function setExtensions(IBancorConverterExtensions _extensions)
587         public
588         ownerOnly
589         validAddress(_extensions)
590         notThis(_extensions)
591     {
592         extensions = _extensions;
593     }
594 
595     /*
596         @dev allows the manager to update the quick buy path
597 
598         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
599     */
600     function setQuickBuyPath(IERC20Token[] _path)
601         public
602         ownerOnly
603         validConversionPath(_path)
604     {
605         quickBuyPath = _path;
606     }
607 
608     /*
609         @dev allows the manager to clear the quick buy path
610     */
611     function clearQuickBuyPath() public ownerOnly {
612         quickBuyPath.length = 0;
613     }
614 
615     /**
616         @dev returns the length of the quick buy path array
617 
618         @return quick buy path length
619     */
620     function getQuickBuyPathLength() public view returns (uint256) {
621         return quickBuyPath.length;
622     }
623 
624     /**
625         @dev disables the entire conversion functionality
626         this is a safety mechanism in case of a emergency
627         can only be called by the manager
628 
629         @param _disable true to disable conversions, false to re-enable them
630     */
631     function disableConversions(bool _disable) public ownerOrManagerOnly {
632         conversionsEnabled = !_disable;
633     }
634 
635     /**
636         @dev updates the current conversion fee
637         can only be called by the manager
638 
639         @param _conversionFee new conversion fee, represented in ppm
640     */
641     function setConversionFee(uint32 _conversionFee)
642         public
643         ownerOrManagerOnly
644         validConversionFee(_conversionFee)
645     {
646         ConversionFeeUpdate(conversionFee, _conversionFee);
647         conversionFee = _conversionFee;
648     }
649 
650     /*
651         @dev returns the conversion fee amount for a given return amount
652 
653         @return conversion fee amount
654     */
655     function getConversionFeeAmount(uint256 _amount) public view returns (uint256) {
656         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
657     }
658 
659     /**
660         @dev defines a new connector for the token
661         can only be called by the owner while the converter is inactive
662 
663         @param _token                  address of the connector token
664         @param _weight                 constant connector weight, represented in ppm, 1-1000000
665         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
666     */
667     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
668         public
669         ownerOnly
670         inactive
671         validAddress(_token)
672         notThis(_token)
673         validConnectorWeight(_weight)
674     {
675         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
676 
677         connectors[_token].virtualBalance = 0;
678         connectors[_token].weight = _weight;
679         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
680         connectors[_token].isPurchaseEnabled = true;
681         connectors[_token].isSet = true;
682         connectorTokens.push(_token);
683         totalConnectorWeight += _weight;
684     }
685 
686     /**
687         @dev updates one of the token connectors
688         can only be called by the owner
689 
690         @param _connectorToken         address of the connector token
691         @param _weight                 constant connector weight, represented in ppm, 1-1000000
692         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
693         @param _virtualBalance         new connector's virtual balance
694     */
695     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
696         public
697         ownerOnly
698         validConnector(_connectorToken)
699         validConnectorWeight(_weight)
700     {
701         Connector storage connector = connectors[_connectorToken];
702         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
703 
704         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
705         connector.weight = _weight;
706         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
707         connector.virtualBalance = _virtualBalance;
708     }
709 
710     /**
711         @dev disables purchasing with the given connector token in case the connector token got compromised
712         can only be called by the owner
713         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
714 
715         @param _connectorToken  connector token contract address
716         @param _disable         true to disable the token, false to re-enable it
717     */
718     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
719         public
720         ownerOnly
721         validConnector(_connectorToken)
722     {
723         connectors[_connectorToken].isPurchaseEnabled = !_disable;
724     }
725 
726     /**
727         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
728 
729         @param _connectorToken  connector token contract address
730 
731         @return connector balance
732     */
733     function getConnectorBalance(IERC20Token _connectorToken)
734         public
735         view
736         validConnector(_connectorToken)
737         returns (uint256)
738     {
739         Connector storage connector = connectors[_connectorToken];
740         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
741     }
742 
743     /**
744         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
745 
746         @param _fromToken  ERC20 token to convert from
747         @param _toToken    ERC20 token to convert to
748         @param _amount     amount to convert, in fromToken
749 
750         @return expected conversion return amount
751     */
752     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
753         require(_fromToken != _toToken); // validate input
754 
755         // conversion between the token and one of its connectors
756         if (_toToken == token)
757             return getPurchaseReturn(_fromToken, _amount);
758         else if (_fromToken == token)
759             return getSaleReturn(_toToken, _amount);
760 
761         // conversion between 2 connectors
762         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
763         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
764     }
765 
766     /**
767         @dev returns the expected return for buying the token for a connector token
768 
769         @param _connectorToken  connector token contract address
770         @param _depositAmount   amount to deposit (in the connector token)
771 
772         @return expected purchase return amount
773     */
774     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
775         public
776         view
777         active
778         validConnector(_connectorToken)
779         returns (uint256)
780     {
781         Connector storage connector = connectors[_connectorToken];
782         require(connector.isPurchaseEnabled); // validate input
783 
784         uint256 tokenSupply = token.totalSupply();
785         uint256 connectorBalance = getConnectorBalance(_connectorToken);
786         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
787 
788         // deduct the fee from the return amount
789         uint256 feeAmount = getConversionFeeAmount(amount);
790         return safeSub(amount, feeAmount);
791     }
792 
793     /**
794         @dev returns the expected return for selling the token for one of its connector tokens
795 
796         @param _connectorToken  connector token contract address
797         @param _sellAmount      amount to sell (in the smart token)
798 
799         @return expected sale return amount
800     */
801     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public view returns (uint256) {
802         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
803     }
804 
805     /**
806         @dev converts a specific amount of _fromToken to _toToken
807 
808         @param _fromToken  ERC20 token to convert from
809         @param _toToken    ERC20 token to convert to
810         @param _amount     amount to convert, in fromToken
811         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
812 
813         @return conversion return amount
814     */
815     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public quickConverterOnly returns (uint256) {
816         require(_fromToken != _toToken); // validate input
817 
818         // conversion between the token and one of its connectors
819         if (_toToken == token)
820             return buy(_fromToken, _amount, _minReturn);
821         else if (_fromToken == token)
822             return sell(_toToken, _amount, _minReturn);
823 
824         // conversion between 2 connectors
825         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
826         return sell(_toToken, purchaseAmount, _minReturn);
827     }
828 
829     /**
830         @dev converts a specific amount of _fromToken to _toToken
831 
832         @param _fromToken  ERC20 token to convert from
833         @param _toToken    ERC20 token to convert to
834         @param _amount     amount to convert, in fromToken
835         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
836 
837         @return conversion return amount
838     */
839     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
840             convertPath = [_fromToken, token, _toToken];
841             return quickConvert(convertPath, _amount, _minReturn);
842     }
843 
844     /**
845         @dev buys the token by depositing one of its connector tokens
846 
847         @param _connectorToken  connector token contract address
848         @param _depositAmount   amount to deposit (in the connector token)
849         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
850 
851         @return buy return amount
852     */
853     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
854         internal
855         conversionsAllowed
856         greaterThanZero(_minReturn)
857         returns (uint256)
858     {
859         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
860         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
861 
862         // update virtual balance if relevant
863         Connector storage connector = connectors[_connectorToken];
864         if (connector.isVirtualBalanceEnabled)
865             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
866 
867         // transfer _depositAmount funds from the caller in the connector token
868         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
869         // issue new funds to the caller in the smart token
870         token.issue(msg.sender, amount);
871 
872         dispatchConversionEvent(_connectorToken, _depositAmount, amount, true);
873         return amount;
874     }
875 
876     /**
877         @dev sells the token by withdrawing from one of its connector tokens
878 
879         @param _connectorToken  connector token contract address
880         @param _sellAmount      amount to sell (in the smart token)
881         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
882 
883         @return sell return amount
884     */
885     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
886         internal
887         conversionsAllowed
888         greaterThanZero(_minReturn)
889         returns (uint256)
890     {
891         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
892 
893         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
894         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
895 
896         uint256 tokenSupply = token.totalSupply();
897         uint256 connectorBalance = getConnectorBalance(_connectorToken);
898         // ensure that the trade will only deplete the connector if the total supply is depleted as well
899         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
900 
901         // update virtual balance if relevant
902         Connector storage connector = connectors[_connectorToken];
903         if (connector.isVirtualBalanceEnabled)
904             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
905 
906         // destroy _sellAmount from the caller's balance in the smart token
907         token.destroy(msg.sender, _sellAmount);
908         // transfer funds to the caller in the connector token
909         // the transfer might fail if the actual connector balance is smaller than the virtual balance
910         assert(_connectorToken.transfer(msg.sender, amount));
911 
912         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
913         return amount;
914     }
915 
916     /**
917         @dev converts the token to any other token in the bancor network by following a predefined conversion path
918         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
919 
920         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
921         @param _amount      amount to convert from (in the initial source token)
922         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
923 
924         @return tokens issued in return
925     */
926     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
927         public
928         payable
929         validConversionPath(_path)
930         returns (uint256)
931     {
932         return quickConvertPrioritized(_path, _amount, _minReturn, 0x0, 0x0, 0x0, 0x0, 0x0);
933     }
934 
935     /**
936         @dev converts the token to any other token in the bancor network by following a predefined conversion path
937         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
938 
939         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
940         @param _amount      amount to convert from (in the initial source token)
941         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
942         @param _block       if the current block exceeded the given parameter - it is cancelled
943         @param _nonce       the nonce of the sender address
944         @param _v           parameter that can be parsed from the transaction signature
945         @param _r           parameter that can be parsed from the transaction signature
946         @param _s           parameter that can be parsed from the transaction signature
947 
948         @return tokens issued in return
949     */
950     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)
951         public
952         payable
953         validConversionPath(_path)
954         returns (uint256)
955     {
956         IERC20Token fromToken = _path[0];
957         IBancorQuickConverter quickConverter = extensions.quickConverter();
958 
959         // we need to transfer the source tokens from the caller to the quick converter,
960         // so it can execute the conversion on behalf of the caller
961         if (msg.value == 0) {
962             // not ETH, send the source tokens to the quick converter
963             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
964             if (fromToken == token) {
965                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
966                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
967             } else {
968                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
969                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
970             }
971         }
972 
973         // execute the conversion and pass on the ETH with the call
974         return quickConverter.convertForPrioritized.value(msg.value)(_path, _amount, _minReturn, msg.sender, _block, _nonce, _v, _r, _s);
975     }
976 
977     // deprecated, backward compatibility
978     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
979         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
980     }
981 
982     /**
983         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
984 
985         @param _connectorToken  connector token contract address
986         @param _sellAmount      amount to sell (in the smart token)
987         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
988 
989         @return sale return amount
990     */
991     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
992         private
993         view
994         active
995         validConnector(_connectorToken)
996         greaterThanZero(_totalSupply)
997         returns (uint256)
998     {
999         Connector storage connector = connectors[_connectorToken];
1000         uint256 connectorBalance = getConnectorBalance(_connectorToken);
1001         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
1002 
1003         // deduct the fee from the return amount
1004         uint256 feeAmount = getConversionFeeAmount(amount);
1005         return safeSub(amount, feeAmount);
1006     }
1007 
1008     /**
1009         @dev helper, dispatches the Conversion event
1010         The function also takes the tokens' decimals into account when calculating the current price
1011 
1012         @param _connectorToken  connector token contract address
1013         @param _amount          amount purchased/sold (in the source token)
1014         @param _returnAmount    amount returned (in the target token)
1015         @param isPurchase       true if it's a purchase, false if it's a sale
1016     */
1017     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
1018         Connector storage connector = connectors[_connectorToken];
1019 
1020         // calculate the new price using the simple price formula
1021         // price = connector balance / (supply * weight)
1022         // weight is represented in ppm, so multiplying by 1000000
1023         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
1024         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
1025 
1026         // normalize values
1027         uint8 tokenDecimals = token.decimals();
1028         uint8 connectorTokenDecimals = _connectorToken.decimals();
1029         if (tokenDecimals != connectorTokenDecimals) {
1030             if (tokenDecimals > connectorTokenDecimals)
1031                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
1032             else
1033                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
1034         }
1035 
1036         uint256 feeAmount = getConversionFeeAmount(_returnAmount);
1037         // ensure that the fee is capped at 255 bits to prevent overflow when converting it to a signed int
1038         assert(feeAmount <= 2 ** 255);
1039 
1040         if (isPurchase)
1041             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, int256(feeAmount), connectorAmount, tokenAmount);
1042         else
1043             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, int256(feeAmount), tokenAmount, connectorAmount);
1044     }
1045 
1046     /**
1047         @dev fallback, buys the smart token with ETH
1048         note that the purchase will use the price at the time of the purchase
1049     */
1050     function() payable public {
1051         quickConvert(quickBuyPath, msg.value, 1);
1052     }
1053 }