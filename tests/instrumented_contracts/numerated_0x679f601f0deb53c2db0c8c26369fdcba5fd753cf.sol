1 pragma solidity ^0.4.18;
2 
3 
4 /*
5     Bancor Converter Extensions interface
6 */
7 contract IBancorConverterExtensions {
8     function formula() public view returns (IBancorFormula) {}
9     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
10     function quickConverter() public view returns (IBancorQuickConverter) {}
11 }
12 
13 
14 contract IBancorFormula {
15     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
16     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
17 }
18 
19 
20 contract IBancorGasPriceLimit {
21     function gasPrice() public view returns (uint256) {}
22 }
23 
24 
25 contract IBancorQuickConverter {
26     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
27     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
28 }
29 
30 
31 contract IERC20Token {
32     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
33     function name() public view returns (string) {}
34     function symbol() public view returns (string) {}
35     function decimals() public view returns (uint8) {}
36     function totalSupply() public view returns (uint256) {}
37     function balanceOf(address _owner) public view returns (uint256) { _owner; }
38     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success);
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 }
44 
45 
46 contract IOwned {
47     // this function isn't abstract since the compiler emits automatically generated getter functions as external
48     function owner() public view returns (address) {}
49 
50     function transferOwnership(address _newOwner) public;
51     function acceptOwnership() public;
52 }
53 
54 
55 contract ITokenHolder is IOwned {
56     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
57 }
58 
59 
60 contract IEtherToken is ITokenHolder, IERC20Token {
61     function deposit() public payable;
62     function withdraw(uint256 _amount) public;
63     function withdrawTo(address _to, uint256 _amount) public;
64 }
65 
66 
67 
68 contract ISmartToken is IOwned, IERC20Token {
69     function disableTransfers(bool _disable) public;
70     function issue(address _to, uint256 _amount) public;
71     function destroy(address _from, uint256 _amount) public;
72 }
73 
74 
75 contract ITokenConverter {
76     function convertibleTokenCount() public view returns (uint16);
77     function convertibleToken(uint16 _tokenIndex) public view returns (address);
78     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
79     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
80     // deprecated, backward compatibility
81     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
82 }
83 
84 
85 contract Owned is IOwned {
86     address public owner;
87     address public newOwner;
88 
89     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
90 
91     /**
92         @dev constructor
93     */
94     function Owned() public {
95         owner = msg.sender;
96     }
97 
98     // allows execution by the owner only
99     modifier ownerOnly {
100         assert(msg.sender == owner);
101         _;
102     }
103 
104     /**
105         @dev allows transferring the contract ownership
106         the new owner still needs to accept the transfer
107         can only be called by the contract owner
108 
109         @param _newOwner    new contract owner
110     */
111     function transferOwnership(address _newOwner) public ownerOnly {
112         require(_newOwner != owner);
113         newOwner = _newOwner;
114     }
115 
116     /**
117         @dev used by a new owner to accept an ownership transfer
118     */
119     function acceptOwnership() public {
120         require(msg.sender == newOwner);
121         OwnerUpdate(owner, newOwner);
122         owner = newOwner;
123         newOwner = address(0);
124     }
125 }
126 
127 
128 
129 contract Utils {
130     /**
131         constructor
132     */
133     function Utils() public {
134     }
135 
136     // verifies that an amount is greater than zero
137     modifier greaterThanZero(uint256 _amount) {
138         require(_amount > 0);
139         _;
140     }
141 
142     // validates an address - currently only checks that it isn't null
143     modifier validAddress(address _address) {
144         require(_address != address(0));
145         _;
146     }
147 
148     // verifies that the address is different than this contract address
149     modifier notThis(address _address) {
150         require(_address != address(this));
151         _;
152     }
153 
154     // Overflow protected math functions
155 
156     /**
157         @dev returns the sum of _x and _y, asserts if the calculation overflows
158 
159         @param _x   value 1
160         @param _y   value 2
161 
162         @return sum
163     */
164     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
165         uint256 z = _x + _y;
166         assert(z >= _x);
167         return z;
168     }
169 
170     /**
171         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
172 
173         @param _x   minuend
174         @param _y   subtrahend
175 
176         @return difference
177     */
178     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
179         assert(_x >= _y);
180         return _x - _y;
181     }
182 
183     /**
184         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
185 
186         @param _x   factor 1
187         @param _y   factor 2
188 
189         @return product
190     */
191     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
192         uint256 z = _x * _y;
193         assert(_x == 0 || z / _x == _y);
194         return z;
195     }
196 }
197 
198 
199 contract TokenHolder is ITokenHolder, Owned, Utils {
200     /**
201         @dev constructor
202     */
203     function TokenHolder() public {
204     }
205 
206     /**
207         @dev withdraws tokens held by the contract and sends them to an account
208         can only be called by the owner
209 
210         @param _token   ERC20 token contract address
211         @param _to      account to receive the new amount
212         @param _amount  amount to withdraw
213     */
214     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
215         public
216         ownerOnly
217         validAddress(_token)
218         validAddress(_to)
219         notThis(_to)
220     {
221         assert(_token.transfer(_to, _amount));
222     }
223 }
224 
225 
226 contract SmartTokenController is TokenHolder {
227     ISmartToken public token;   // smart token
228 
229     /**
230         @dev constructor
231     */
232     function SmartTokenController(ISmartToken _token)
233         public
234         validAddress(_token)
235     {
236         token = _token;
237     }
238 
239     // ensures that the controller is the token's owner
240     modifier active() {
241         assert(token.owner() == address(this));
242         _;
243     }
244 
245     // ensures that the controller is not the token's owner
246     modifier inactive() {
247         assert(token.owner() != address(this));
248         _;
249     }
250 
251     /**
252         @dev allows transferring the token ownership
253         the new owner still need to accept the transfer
254         can only be called by the contract owner
255 
256         @param _newOwner    new token owner
257     */
258     function transferTokenOwnership(address _newOwner) public ownerOnly {
259         token.transferOwnership(_newOwner);
260     }
261 
262     /**
263         @dev used by a new owner to accept a token ownership transfer
264         can only be called by the contract owner
265     */
266     function acceptTokenOwnership() public ownerOnly {
267         token.acceptOwnership();
268     }
269 
270     /**
271         @dev disables/enables token transfers
272         can only be called by the contract owner
273 
274         @param _disable    true to disable transfers, false to enable them
275     */
276     function disableTokenTransfers(bool _disable) public ownerOnly {
277         token.disableTransfers(_disable);
278     }
279 
280     /**
281         @dev withdraws tokens held by the controller and sends them to an account
282         can only be called by the owner
283 
284         @param _token   ERC20 token contract address
285         @param _to      account to receive the new amount
286         @param _amount  amount to withdraw
287     */
288     function withdrawFromToken(
289         IERC20Token _token, 
290         address _to, 
291         uint256 _amount
292     ) 
293         public
294         ownerOnly
295     {
296         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
297     }
298 }
299 
300 contract Managed {
301     address public manager;
302     address public newManager;
303 
304     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
305 
306     /**
307         @dev constructor
308     */
309     function Managed() public {
310         manager = msg.sender;
311     }
312 
313     // allows execution by the manager only
314     modifier managerOnly {
315         assert(msg.sender == manager);
316         _;
317     }
318 
319     /**
320         @dev allows transferring the contract management
321         the new manager still needs to accept the transfer
322         can only be called by the contract manager
323 
324         @param _newManager    new contract manager
325     */
326     function transferManagement(address _newManager) public managerOnly {
327         require(_newManager != manager);
328         newManager = _newManager;
329     }
330 
331     /**
332         @dev used by a new manager to accept a management transfer
333     */
334     function acceptManagement() public {
335         require(msg.sender == newManager);
336         ManagerUpdate(manager, newManager);
337         manager = newManager;
338         newManager = address(0);
339     }
340 }
341 
342 
343 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
344     uint32 private constant MAX_WEIGHT = 1000000;
345     uint32 private constant MAX_CONVERSION_FEE = 1000000;
346 
347     struct Connector {
348         uint256 virtualBalance;         // connector virtual balance
349         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
350         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
351         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
352         bool isSet;                     // used to tell if the mapping element is defined
353     }
354 
355     string public version = '0.7';
356     string public converterType = 'bancor';
357 
358     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
359     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
360     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
361     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
362     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
363     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
364     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
365     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
366 
367     // triggered when a conversion between two tokens occurs (TokenConverter event)
368     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
369                      int256 _conversionFee, uint256 _currentPriceN, uint256 _currentPriceD);
370     // triggered when the conversion fee is updated
371     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
372 
373     /**
374         @dev constructor
375 
376         @param  _token              smart token governed by the converter
377         @param  _extensions         address of a bancor converter extensions contract
378         @param  _maxConversionFee   maximum conversion fee, represented in ppm
379         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
380         @param  _connectorWeight    optional, weight for the initial connector
381     */
382     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
383         public
384         SmartTokenController(_token)
385         validAddress(_extensions)
386         validMaxConversionFee(_maxConversionFee)
387     {
388         extensions = _extensions;
389         maxConversionFee = _maxConversionFee;
390 
391         if (_connectorToken != address(0))
392             addConnector(_connectorToken, _connectorWeight, false);
393     }
394 
395     // validates a connector token address - verifies that the address belongs to one of the connector tokens
396     modifier validConnector(IERC20Token _address) {
397         require(connectors[_address].isSet);
398         _;
399     }
400 
401     // validates a token address - verifies that the address belongs to one of the convertible tokens
402     modifier validToken(IERC20Token _address) {
403         require(_address == token || connectors[_address].isSet);
404         _;
405     }
406 
407     // verifies that the gas price is lower than the universal limit
408     modifier validGasPrice() {
409         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
410         _;
411     }
412 
413     // validates maximum conversion fee
414     modifier validMaxConversionFee(uint32 _conversionFee) {
415         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
416         _;
417     }
418 
419     // validates conversion fee
420     modifier validConversionFee(uint32 _conversionFee) {
421         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
422         _;
423     }
424 
425     // validates connector weight range
426     modifier validConnectorWeight(uint32 _weight) {
427         require(_weight > 0 && _weight <= MAX_WEIGHT);
428         _;
429     }
430 
431     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
432     modifier validConversionPath(IERC20Token[] _path) {
433         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
434         _;
435     }
436 
437     // allows execution only when conversions aren't disabled
438     modifier conversionsAllowed {
439         assert(conversionsEnabled);
440         _;
441     }
442 
443     // allows execution only for owner or manager
444     modifier ownerOrManagerOnly {
445         require(msg.sender == owner || msg.sender == manager);
446         _;
447     }
448 
449     /**
450         @dev returns the number of connector tokens defined
451 
452         @return number of connector tokens
453     */
454     function connectorTokenCount() public view returns (uint16) {
455         return uint16(connectorTokens.length);
456     }
457 
458     /**
459         @dev returns the number of convertible tokens supported by the contract
460         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
461 
462         @return number of convertible tokens
463     */
464     function convertibleTokenCount() public view returns (uint16) {
465         return connectorTokenCount() + 1;
466     }
467 
468     /**
469         @dev given a convertible token index, returns its contract address
470 
471         @param _tokenIndex  convertible token index
472 
473         @return convertible token address
474     */
475     function convertibleToken(uint16 _tokenIndex) public view returns (address) {
476         if (_tokenIndex == 0)
477             return token;
478         return connectorTokens[_tokenIndex - 1];
479     }
480 
481     /*
482         @dev allows the owner to update the extensions contract address
483 
484         @param _extensions    address of a bancor converter extensions contract
485     */
486     function setExtensions(IBancorConverterExtensions _extensions)
487         public
488         ownerOnly
489         validAddress(_extensions)
490         notThis(_extensions)
491     {
492         extensions = _extensions;
493     }
494 
495     /*
496         @dev allows the manager to update the quick buy path
497 
498         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
499     */
500     function setQuickBuyPath(IERC20Token[] _path)
501         public
502         ownerOnly
503         validConversionPath(_path)
504     {
505         quickBuyPath = _path;
506     }
507 
508     /*
509         @dev allows the manager to clear the quick buy path
510     */
511     function clearQuickBuyPath() public ownerOnly {
512         quickBuyPath.length = 0;
513     }
514 
515     /**
516         @dev returns the length of the quick buy path array
517 
518         @return quick buy path length
519     */
520     function getQuickBuyPathLength() public view returns (uint256) {
521         return quickBuyPath.length;
522     }
523 
524     /**
525         @dev disables the entire conversion functionality
526         this is a safety mechanism in case of a emergency
527         can only be called by the manager
528 
529         @param _disable true to disable conversions, false to re-enable them
530     */
531     function disableConversions(bool _disable) public ownerOrManagerOnly {
532         conversionsEnabled = !_disable;
533     }
534 
535     /**
536         @dev updates the current conversion fee
537         can only be called by the manager
538 
539         @param _conversionFee new conversion fee, represented in ppm
540     */
541     function setConversionFee(uint32 _conversionFee)
542         public
543         ownerOrManagerOnly
544         validConversionFee(_conversionFee)
545     {
546         ConversionFeeUpdate(conversionFee, _conversionFee);
547         conversionFee = _conversionFee;
548     }
549 
550     /*
551         @dev returns the conversion fee amount for a given return amount
552 
553         @return conversion fee amount
554     */
555     function getConversionFeeAmount(uint256 _amount) public view returns (uint256) {
556         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
557     }
558 
559     /**
560         @dev defines a new connector for the token
561         can only be called by the owner while the converter is inactive
562 
563         @param _token                  address of the connector token
564         @param _weight                 constant connector weight, represented in ppm, 1-1000000
565         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
566     */
567     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
568         public
569         ownerOnly
570         inactive
571         validAddress(_token)
572         notThis(_token)
573         validConnectorWeight(_weight)
574     {
575         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
576 
577         connectors[_token].virtualBalance = 0;
578         connectors[_token].weight = _weight;
579         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
580         connectors[_token].isPurchaseEnabled = true;
581         connectors[_token].isSet = true;
582         connectorTokens.push(_token);
583         totalConnectorWeight += _weight;
584     }
585 
586     /**
587         @dev updates one of the token connectors
588         can only be called by the owner
589 
590         @param _connectorToken         address of the connector token
591         @param _weight                 constant connector weight, represented in ppm, 1-1000000
592         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
593         @param _virtualBalance         new connector's virtual balance
594     */
595     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
596         public
597         ownerOnly
598         validConnector(_connectorToken)
599         validConnectorWeight(_weight)
600     {
601         Connector storage connector = connectors[_connectorToken];
602         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
603 
604         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
605         connector.weight = _weight;
606         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
607         connector.virtualBalance = _virtualBalance;
608     }
609 
610     /**
611         @dev disables purchasing with the given connector token in case the connector token got compromised
612         can only be called by the owner
613         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
614 
615         @param _connectorToken  connector token contract address
616         @param _disable         true to disable the token, false to re-enable it
617     */
618     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
619         public
620         ownerOnly
621         validConnector(_connectorToken)
622     {
623         connectors[_connectorToken].isPurchaseEnabled = !_disable;
624     }
625 
626     /**
627         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
628 
629         @param _connectorToken  connector token contract address
630 
631         @return connector balance
632     */
633     function getConnectorBalance(IERC20Token _connectorToken)
634         public
635         view
636         validConnector(_connectorToken)
637         returns (uint256)
638     {
639         Connector storage connector = connectors[_connectorToken];
640         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
641     }
642 
643     /**
644         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
645 
646         @param _fromToken  ERC20 token to convert from
647         @param _toToken    ERC20 token to convert to
648         @param _amount     amount to convert, in fromToken
649 
650         @return expected conversion return amount
651     */
652     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
653         require(_fromToken != _toToken); // validate input
654 
655         // conversion between the token and one of its connectors
656         if (_toToken == token)
657             return getPurchaseReturn(_fromToken, _amount);
658         else if (_fromToken == token)
659             return getSaleReturn(_toToken, _amount);
660 
661         // conversion between 2 connectors
662         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
663         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
664     }
665 
666     /**
667         @dev returns the expected return for buying the token for a connector token
668 
669         @param _connectorToken  connector token contract address
670         @param _depositAmount   amount to deposit (in the connector token)
671 
672         @return expected purchase return amount
673     */
674     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
675         public
676         view
677         active
678         validConnector(_connectorToken)
679         returns (uint256)
680     {
681         Connector storage connector = connectors[_connectorToken];
682         require(connector.isPurchaseEnabled); // validate input
683 
684         uint256 tokenSupply = token.totalSupply();
685         uint256 connectorBalance = getConnectorBalance(_connectorToken);
686         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
687 
688         // deduct the fee from the return amount
689         uint256 feeAmount = getConversionFeeAmount(amount);
690         return safeSub(amount, feeAmount);
691     }
692 
693     /**
694         @dev returns the expected return for selling the token for one of its connector tokens
695 
696         @param _connectorToken  connector token contract address
697         @param _sellAmount      amount to sell (in the smart token)
698 
699         @return expected sale return amount
700     */
701     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public view returns (uint256) {
702         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
703     }
704 
705     /**
706         @dev converts a specific amount of _fromToken to _toToken
707 
708         @param _fromToken  ERC20 token to convert from
709         @param _toToken    ERC20 token to convert to
710         @param _amount     amount to convert, in fromToken
711         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
712 
713         @return conversion return amount
714     */
715     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
716         require(_fromToken != _toToken); // validate input
717 
718         // conversion between the token and one of its connectors
719         if (_toToken == token)
720             return buy(_fromToken, _amount, _minReturn);
721         else if (_fromToken == token)
722             return sell(_toToken, _amount, _minReturn);
723 
724         // conversion between 2 connectors
725         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
726         return sell(_toToken, purchaseAmount, _minReturn);
727     }
728 
729     /**
730         @dev buys the token by depositing one of its connector tokens
731 
732         @param _connectorToken  connector token contract address
733         @param _depositAmount   amount to deposit (in the connector token)
734         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
735 
736         @return buy return amount
737     */
738     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
739         public
740         conversionsAllowed
741         validGasPrice
742         greaterThanZero(_minReturn)
743         returns (uint256)
744     {
745         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
746         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
747 
748         // update virtual balance if relevant
749         Connector storage connector = connectors[_connectorToken];
750         if (connector.isVirtualBalanceEnabled)
751             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
752 
753         // transfer _depositAmount funds from the caller in the connector token
754         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
755         // issue new funds to the caller in the smart token
756         token.issue(msg.sender, amount);
757 
758         dispatchConversionEvent(_connectorToken, _depositAmount, amount, true);
759         return amount;
760     }
761 
762     /**
763         @dev sells the token by withdrawing from one of its connector tokens
764 
765         @param _connectorToken  connector token contract address
766         @param _sellAmount      amount to sell (in the smart token)
767         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
768 
769         @return sell return amount
770     */
771     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
772         public
773         conversionsAllowed
774         validGasPrice
775         greaterThanZero(_minReturn)
776         returns (uint256)
777     {
778         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
779 
780         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
781         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
782 
783         uint256 tokenSupply = token.totalSupply();
784         uint256 connectorBalance = getConnectorBalance(_connectorToken);
785         // ensure that the trade will only deplete the connector if the total supply is depleted as well
786         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
787 
788         // update virtual balance if relevant
789         Connector storage connector = connectors[_connectorToken];
790         if (connector.isVirtualBalanceEnabled)
791             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
792 
793         // destroy _sellAmount from the caller's balance in the smart token
794         token.destroy(msg.sender, _sellAmount);
795         // transfer funds to the caller in the connector token
796         // the transfer might fail if the actual connector balance is smaller than the virtual balance
797         assert(_connectorToken.transfer(msg.sender, amount));
798 
799         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
800         return amount;
801     }
802 
803     /**
804         @dev converts the token to any other token in the bancor network by following a predefined conversion path
805         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
806 
807         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
808         @param _amount      amount to convert from (in the initial source token)
809         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
810 
811         @return tokens issued in return
812     */
813     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
814         public
815         payable
816         validConversionPath(_path)
817         returns (uint256)
818     {
819         IERC20Token fromToken = _path[0];
820         IBancorQuickConverter quickConverter = extensions.quickConverter();
821 
822         // we need to transfer the source tokens from the caller to the quick converter,
823         // so it can execute the conversion on behalf of the caller
824         if (msg.value == 0) {
825             // not ETH, send the source tokens to the quick converter
826             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
827             if (fromToken == token) {
828                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
829                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
830             }
831             else {
832                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
833                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
834             }
835         }
836 
837         // execute the conversion and pass on the ETH with the call
838         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
839     }
840 
841     // deprecated, backward compatibility
842     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
843         return convert(_fromToken, _toToken, _amount, _minReturn);
844     }
845 
846     /**
847         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
848 
849         @param _connectorToken  connector token contract address
850         @param _sellAmount      amount to sell (in the smart token)
851         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
852 
853         @return sale return amount
854     */
855     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
856         private
857         view
858         active
859         validConnector(_connectorToken)
860         greaterThanZero(_totalSupply)
861         returns (uint256)
862     {
863         Connector storage connector = connectors[_connectorToken];
864         uint256 connectorBalance = getConnectorBalance(_connectorToken);
865         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
866 
867         // deduct the fee from the return amount
868         uint256 feeAmount = getConversionFeeAmount(amount);
869         return safeSub(amount, feeAmount);
870     }
871 
872     /**
873         @dev helper, dispatches the Conversion event
874         The function also takes the tokens' decimals into account when calculating the current price
875 
876         @param _connectorToken  connector token contract address
877         @param _amount          amount purchased/sold (in the source token)
878         @param _returnAmount    amount returned (in the target token)
879         @param isPurchase       true if it's a purchase, false if it's a sale
880     */
881     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
882         Connector storage connector = connectors[_connectorToken];
883 
884         // calculate the new price using the simple price formula
885         // price = connector balance / (supply * weight)
886         // weight is represented in ppm, so multiplying by 1000000
887         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
888         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
889 
890         // normalize values
891         uint8 tokenDecimals = token.decimals();
892         uint8 connectorTokenDecimals = _connectorToken.decimals();
893         if (tokenDecimals != connectorTokenDecimals) {
894             if (tokenDecimals > connectorTokenDecimals)
895                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
896             else
897                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
898         }
899 
900         uint256 feeAmount = getConversionFeeAmount(_returnAmount);
901         // ensure that the fee is capped at 255 bits to prevent overflow when converting it to a signed int
902         assert(feeAmount <= 2 ** 255);
903 
904         if (isPurchase)
905             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, int256(feeAmount), connectorAmount, tokenAmount);
906         else
907             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, int256(feeAmount), tokenAmount, connectorAmount);
908     }
909 
910     /**
911         @dev fallback, buys the smart token with ETH
912         note that the purchase will use the price at the time of the purchase
913     */
914     function() payable public {
915         quickConvert(quickBuyPath, msg.value, 1);
916     }
917 }
918 
919 contract BancorConverterExtensions is IBancorConverterExtensions, TokenHolder {
920     IBancorFormula public formula;  // bancor calculation formula contract
921     IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract
922     IBancorQuickConverter public quickConverter; // bancor quick converter contract
923 
924     /**
925         @dev constructor
926 
927         @param _formula         address of a bancor formula contract
928         @param _gasPriceLimit   address of a bancor gas price limit contract
929         @param _quickConverter  address of a bancor quick converter contract
930     */
931     function BancorConverterExtensions(IBancorFormula _formula, IBancorGasPriceLimit _gasPriceLimit, IBancorQuickConverter _quickConverter)
932         public
933         validAddress(_formula)
934         validAddress(_gasPriceLimit)
935         validAddress(_quickConverter)
936     {
937         formula = _formula;
938         gasPriceLimit = _gasPriceLimit;
939         quickConverter = _quickConverter;
940     }
941 
942     /*
943         @dev allows the owner to update the formula contract address
944 
945         @param _formula    address of a bancor formula contract
946     */
947     function setFormula(IBancorFormula _formula)
948         public
949         ownerOnly
950         validAddress(_formula)
951         notThis(_formula)
952     {
953         formula = _formula;
954     }
955 
956     /*
957         @dev allows the owner to update the gas price limit contract address
958 
959         @param _gasPriceLimit   address of a bancor gas price limit contract
960     */
961     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
962         public
963         ownerOnly
964         validAddress(_gasPriceLimit)
965         notThis(_gasPriceLimit)
966     {
967         gasPriceLimit = _gasPriceLimit;
968     }
969 
970     /*
971         @dev allows the owner to update the quick converter contract address
972 
973         @param _quickConverter  address of a bancor quick converter contract
974     */
975     function setQuickConverter(IBancorQuickConverter _quickConverter)
976         public
977         ownerOnly
978         validAddress(_quickConverter)
979         notThis(_quickConverter)
980     {
981         quickConverter = _quickConverter;
982     }
983 }
984 
985 contract BancorFormula is IBancorFormula, Utils {
986     string public version = '0.3';
987 
988     uint256 private constant ONE = 1;
989     uint32 private constant MAX_WEIGHT = 1000000;
990     uint8 private constant MIN_PRECISION = 32;
991     uint8 private constant MAX_PRECISION = 127;
992 
993     /**
994         The values below depend on MAX_PRECISION. If you choose to change it:
995         Apply the same change in file 'PrintIntScalingFactors.py', run it and paste the results below.
996     */
997     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
998     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
999     uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;
1000 
1001     /**
1002         The values below depend on MAX_PRECISION. If you choose to change it:
1003         Apply the same change in file 'PrintLn2ScalingFactors.py', run it and paste the results below.
1004     */
1005     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
1006     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
1007 
1008     /**
1009         The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
1010         Apply the same change in file 'PrintFunctionBancorFormula.py', run it and paste the results below.
1011     */
1012     uint256[128] private maxExpArray;
1013 
1014     function BancorFormula() public {
1015     //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
1016     //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
1017     //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
1018     //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
1019     //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
1020     //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
1021     //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
1022     //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
1023     //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
1024     //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
1025     //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
1026     //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
1027     //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
1028     //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
1029     //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
1030     //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
1031     //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
1032     //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
1033     //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
1034     //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
1035     //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
1036     //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
1037     //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
1038     //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
1039     //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
1040     //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
1041     //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
1042     //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
1043     //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
1044     //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
1045     //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
1046     //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
1047         maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
1048         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
1049         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
1050         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
1051         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
1052         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
1053         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
1054         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
1055         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
1056         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
1057         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
1058         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
1059         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
1060         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
1061         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
1062         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
1063         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
1064         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
1065         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
1066         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
1067         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
1068         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
1069         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
1070         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
1071         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
1072         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
1073         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
1074         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
1075         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
1076         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
1077         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
1078         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
1079         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
1080         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
1081         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
1082         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
1083         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
1084         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
1085         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
1086         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
1087         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
1088         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
1089         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
1090         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
1091         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
1092         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
1093         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
1094         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
1095         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
1096         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
1097         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
1098         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
1099         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
1100         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
1101         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
1102         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
1103         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
1104         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
1105         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
1106         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
1107         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
1108         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
1109         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
1110         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
1111         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
1112         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
1113         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
1114         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
1115         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
1116         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
1117         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
1118         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
1119         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
1120         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
1121         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
1122         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
1123         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
1124         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
1125         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
1126         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
1127         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
1128         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
1129         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
1130         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
1131         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
1132         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
1133         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
1134         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
1135         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
1136         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
1137         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
1138         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
1139         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
1140         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
1141         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
1142         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
1143     }
1144 
1145     /**
1146         @dev given a token supply, connector balance, weight and a deposit amount (in the connector token),
1147         calculates the return for a given conversion (in the main token)
1148 
1149         Formula:
1150         Return = _supply * ((1 + _depositAmount / _connectorBalance) ^ (_connectorWeight / 1000000) - 1)
1151 
1152         @param _supply              token total supply
1153         @param _connectorBalance    total connector balance
1154         @param _connectorWeight     connector weight, represented in ppm, 1-1000000
1155         @param _depositAmount       deposit amount, in connector token
1156 
1157         @return purchase return amount
1158     */
1159     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256) {
1160         // validate input
1161         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT);
1162 
1163         // special case for 0 deposit amount
1164         if (_depositAmount == 0)
1165             return 0;
1166 
1167         // special case if the weight = 100%
1168         if (_connectorWeight == MAX_WEIGHT)
1169             return safeMul(_supply, _depositAmount) / _connectorBalance;
1170 
1171         uint256 result;
1172         uint8 precision;
1173         uint256 baseN = safeAdd(_depositAmount, _connectorBalance);
1174         (result, precision) = power(baseN, _connectorBalance, _connectorWeight, MAX_WEIGHT);
1175         uint256 temp = safeMul(_supply, result) >> precision;
1176         return temp - _supply;
1177     }
1178 
1179     /**
1180         @dev given a token supply, connector balance, weight and a sell amount (in the main token),
1181         calculates the return for a given conversion (in the connector token)
1182 
1183         Formula:
1184         Return = _connectorBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_connectorWeight / 1000000)))
1185 
1186         @param _supply              token total supply
1187         @param _connectorBalance    total connector
1188         @param _connectorWeight     constant connector Weight, represented in ppm, 1-1000000
1189         @param _sellAmount          sell amount, in the token itself
1190 
1191         @return sale return amount
1192     */
1193     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256) {
1194         // validate input
1195         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT && _sellAmount <= _supply);
1196 
1197         // special case for 0 sell amount
1198         if (_sellAmount == 0)
1199             return 0;
1200 
1201         // special case for selling the entire supply
1202         if (_sellAmount == _supply)
1203             return _connectorBalance;
1204 
1205         // special case if the weight = 100%
1206         if (_connectorWeight == MAX_WEIGHT)
1207             return safeMul(_connectorBalance, _sellAmount) / _supply;
1208 
1209         uint256 result;
1210         uint8 precision;
1211         uint256 baseD = _supply - _sellAmount;
1212         (result, precision) = power(_supply, baseD, MAX_WEIGHT, _connectorWeight);
1213         uint256 temp1 = safeMul(_connectorBalance, result);
1214         uint256 temp2 = _connectorBalance << precision;
1215         return (temp1 - temp2) / result;
1216     }
1217 
1218     /**
1219         General Description:
1220             Determine a value of precision.
1221             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
1222             Return the result along with the precision used.
1223 
1224         Detailed Description:
1225             Instead of calculating "base ^ exp", we calculate "e ^ (ln(base) * exp)".
1226             The value of "ln(base)" is represented with an integer slightly smaller than "ln(base) * 2 ^ precision".
1227             The larger "precision" is, the more accurately this value represents the real value.
1228             However, the larger "precision" is, the more bits are required in order to store this value.
1229             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
1230             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
1231             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
1232             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
1233             This functions assumes that "_expN < (1 << 256) / ln(MAX_NUM, 1)", otherwise the multiplication should be replaced with a "safeMul".
1234     */
1235     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal view returns (uint256, uint8) {
1236         uint256 lnBaseTimesExp = ln(_baseN, _baseD) * _expN / _expD;
1237         uint8 precision = findPositionInMaxExpArray(lnBaseTimesExp);
1238         return (fixedExp(lnBaseTimesExp >> (MAX_PRECISION - precision), precision), precision);
1239     }
1240 
1241     /**
1242         Return floor(ln(numerator / denominator) * 2 ^ MAX_PRECISION), where:
1243         - The numerator   is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
1244         - The denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
1245         - The output      is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
1246         This functions assumes that the numerator is larger than or equal to the denominator, because the output would be negative otherwise.
1247     */
1248     function ln(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
1249         assert(_numerator <= MAX_NUM);
1250 
1251         uint256 res = 0;
1252         uint256 x = _numerator * FIXED_1 / _denominator;
1253 
1254         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
1255         if (x >= FIXED_2) {
1256             uint8 count = floorLog2(x / FIXED_1);
1257             x >>= count; // now x < 2
1258             res = count * FIXED_1;
1259         }
1260 
1261         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
1262         if (x > FIXED_1) {
1263             for (uint8 i = MAX_PRECISION; i > 0; --i) {
1264                 x = (x * x) / FIXED_1; // now 1 < x < 4
1265                 if (x >= FIXED_2) {
1266                     x >>= 1; // now 1 < x < 2
1267                     res += ONE << (i - 1);
1268                 }
1269             }
1270         }
1271 
1272         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
1273     }
1274 
1275     /**
1276         Compute the largest integer smaller than or equal to the binary logarithm of the input.
1277     */
1278     function floorLog2(uint256 _n) internal pure returns (uint8) {
1279         uint8 res = 0;
1280 
1281         if (_n < 256) {
1282             // At most 8 iterations
1283             while (_n > 1) {
1284                 _n >>= 1;
1285                 res += 1;
1286             }
1287         }
1288         else {
1289             // Exactly 8 iterations
1290             for (uint8 s = 128; s > 0; s >>= 1) {
1291                 if (_n >= (ONE << s)) {
1292                     _n >>= s;
1293                     res |= s;
1294                 }
1295             }
1296         }
1297 
1298         return res;
1299     }
1300 
1301     /**
1302         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
1303         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
1304         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
1305     */
1306     function findPositionInMaxExpArray(uint256 _x) internal view returns (uint8) {
1307         uint8 lo = MIN_PRECISION;
1308         uint8 hi = MAX_PRECISION;
1309 
1310         while (lo + 1 < hi) {
1311             uint8 mid = (lo + hi) / 2;
1312             if (maxExpArray[mid] >= _x)
1313                 lo = mid;
1314             else
1315                 hi = mid;
1316         }
1317 
1318         if (maxExpArray[hi] >= _x)
1319             return hi;
1320         if (maxExpArray[lo] >= _x)
1321             return lo;
1322 
1323         assert(false);
1324         return 0;
1325     }
1326 
1327     /**
1328         This function can be auto-generated by the script 'PrintFunctionFixedExp.py'.
1329         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
1330         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
1331         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
1332         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
1333     */
1334     function fixedExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
1335         uint256 xi = _x;
1336         uint256 res = 0;
1337 
1338         xi = (xi * _x) >> _precision;
1339         res += xi * 0x03442c4e6074a82f1797f72ac0000000; // add x^2 * (33! / 2!)
1340         xi = (xi * _x) >> _precision;
1341         res += xi * 0x0116b96f757c380fb287fd0e40000000; // add x^3 * (33! / 3!)
1342         xi = (xi * _x) >> _precision;
1343         res += xi * 0x0045ae5bdd5f0e03eca1ff4390000000; // add x^4 * (33! / 4!)
1344         xi = (xi * _x) >> _precision;
1345         res += xi * 0x000defabf91302cd95b9ffda50000000; // add x^5 * (33! / 5!)
1346         xi = (xi * _x) >> _precision;
1347         res += xi * 0x0002529ca9832b22439efff9b8000000; // add x^6 * (33! / 6!)
1348         xi = (xi * _x) >> _precision;
1349         res += xi * 0x000054f1cf12bd04e516b6da88000000; // add x^7 * (33! / 7!)
1350         xi = (xi * _x) >> _precision;
1351         res += xi * 0x00000a9e39e257a09ca2d6db51000000; // add x^8 * (33! / 8!)
1352         xi = (xi * _x) >> _precision;
1353         res += xi * 0x0000012e066e7b839fa050c309000000; // add x^9 * (33! / 9!)
1354         xi = (xi * _x) >> _precision;
1355         res += xi * 0x0000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
1356         xi = (xi * _x) >> _precision;
1357         res += xi * 0x00000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
1358         xi = (xi * _x) >> _precision;
1359         res += xi * 0x000000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
1360         xi = (xi * _x) >> _precision;
1361         res += xi * 0x00000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
1362         xi = (xi * _x) >> _precision;
1363         res += xi * 0x00000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
1364         xi = (xi * _x) >> _precision;
1365         res += xi * 0x0000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
1366         xi = (xi * _x) >> _precision;
1367         res += xi * 0x00000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
1368         xi = (xi * _x) >> _precision;
1369         res += xi * 0x000000000000052b6b54569976310000; // add x^17 * (33! / 17!)
1370         xi = (xi * _x) >> _precision;
1371         res += xi * 0x000000000000004985f67696bf748000; // add x^18 * (33! / 18!)
1372         xi = (xi * _x) >> _precision;
1373         res += xi * 0x0000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
1374         xi = (xi * _x) >> _precision;
1375         res += xi * 0x000000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
1376         xi = (xi * _x) >> _precision;
1377         res += xi * 0x0000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
1378         xi = (xi * _x) >> _precision;
1379         res += xi * 0x0000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
1380         xi = (xi * _x) >> _precision;
1381         res += xi * 0x00000000000000000001317c70077000; // add x^23 * (33! / 23!)
1382         xi = (xi * _x) >> _precision;
1383         res += xi * 0x000000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
1384         xi = (xi * _x) >> _precision;
1385         res += xi * 0x000000000000000000000082573a0a00; // add x^25 * (33! / 25!)
1386         xi = (xi * _x) >> _precision;
1387         res += xi * 0x000000000000000000000005035ad900; // add x^26 * (33! / 26!)
1388         xi = (xi * _x) >> _precision;
1389         res += xi * 0x0000000000000000000000002f881b00; // add x^27 * (33! / 27!)
1390         xi = (xi * _x) >> _precision;
1391         res += xi * 0x00000000000000000000000001b29340; // add x^28 * (33! / 28!)
1392         xi = (xi * _x) >> _precision;
1393         res += xi * 0x000000000000000000000000000efc40; // add x^29 * (33! / 29!)
1394         xi = (xi * _x) >> _precision;
1395         res += xi * 0x00000000000000000000000000007fe0; // add x^30 * (33! / 30!)
1396         xi = (xi * _x) >> _precision;
1397         res += xi * 0x00000000000000000000000000000420; // add x^31 * (33! / 31!)
1398         xi = (xi * _x) >> _precision;
1399         res += xi * 0x00000000000000000000000000000021; // add x^32 * (33! / 32!)
1400         xi = (xi * _x) >> _precision;
1401         res += xi * 0x00000000000000000000000000000001; // add x^33 * (33! / 33!)
1402 
1403         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
1404     }
1405 }
1406 
1407 contract BancorGasPriceLimit is IBancorGasPriceLimit, Owned, Utils {
1408     uint256 public gasPrice = 0 wei;    // maximum gas price for bancor transactions
1409 
1410     /**
1411         @dev constructor
1412 
1413         @param _gasPrice    gas price limit
1414     */
1415     function BancorGasPriceLimit(uint256 _gasPrice)
1416         public
1417         greaterThanZero(_gasPrice)
1418     {
1419         gasPrice = _gasPrice;
1420     }
1421 
1422     /*
1423         @dev allows the owner to update the gas price limit
1424 
1425         @param _gasPrice    new gas price limit
1426     */
1427     function setGasPrice(uint256 _gasPrice)
1428         public
1429         ownerOnly
1430         greaterThanZero(_gasPrice)
1431     {
1432         gasPrice = _gasPrice;
1433     }
1434 }
1435 
1436 contract BancorPriceFloor is Owned, TokenHolder {
1437     uint256 public constant TOKEN_PRICE_N = 1;      // crowdsale price in wei (numerator)
1438     uint256 public constant TOKEN_PRICE_D = 100;    // crowdsale price in wei (denominator)
1439 
1440     string public version = '0.1';
1441     ISmartToken public token; // smart token the contract allows selling
1442 
1443     /**
1444         @dev constructor
1445 
1446         @param _token   smart token the contract allows selling
1447     */
1448     function BancorPriceFloor(ISmartToken _token)
1449         public
1450         validAddress(_token)
1451     {
1452         token = _token;
1453     }
1454 
1455     /**
1456         @dev sells the smart token for ETH
1457         note that the function will sell the full allowance amount
1458 
1459         @return ETH sent in return
1460     */
1461     function sell() public returns (uint256 amount) {
1462         uint256 allowance = token.allowance(msg.sender, this); // get the full allowance amount
1463         assert(token.transferFrom(msg.sender, this, allowance)); // transfer all tokens from the sender to the contract
1464         uint256 etherValue = safeMul(allowance, TOKEN_PRICE_N) / TOKEN_PRICE_D; // calculate ETH value of the tokens
1465         msg.sender.transfer(etherValue); // send the ETH amount to the seller
1466         return etherValue;
1467     }
1468 
1469     /**
1470         @dev withdraws ETH from the contract
1471 
1472         @param _amount  amount of ETH to withdraw
1473     */
1474     function withdraw(uint256 _amount) public ownerOnly {
1475         msg.sender.transfer(_amount); // send the amount
1476     }
1477 
1478     /**
1479         @dev deposits ETH in the contract
1480     */
1481     function() public payable {
1482     }
1483 }
1484 
1485 contract BancorQuickConverter is IBancorQuickConverter, TokenHolder {
1486     mapping (address => bool) public etherTokens;   // list of all supported ether tokens
1487 
1488     /**
1489         @dev constructor
1490     */
1491     function BancorQuickConverter() public {
1492     }
1493 
1494     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
1495     modifier validConversionPath(IERC20Token[] _path) {
1496         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
1497         _;
1498     }
1499 
1500     /**
1501         @dev allows the owner to register/unregister ether tokens
1502 
1503         @param _token       ether token contract address
1504         @param _register    true to register, false to unregister
1505     */
1506     function registerEtherToken(IEtherToken _token, bool _register)
1507         public
1508         ownerOnly
1509         validAddress(_token)
1510         notThis(_token)
1511     {
1512         etherTokens[_token] = _register;
1513     }
1514 
1515     /**
1516         @dev converts the token to any other token in the bancor network by following
1517         a predefined conversion path and transfers the result tokens to a target account
1518         note that the converter should already own the source tokens
1519 
1520         @param _path        conversion path, see conversion path format above
1521         @param _amount      amount to convert from (in the initial source token)
1522         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1523         @param _for         account that will receive the conversion result
1524 
1525         @return tokens issued in return
1526     */
1527     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for)
1528         public
1529         payable
1530         validConversionPath(_path)
1531         returns (uint256)
1532     {
1533         // if ETH is provided, ensure that the amount is identical to _amount and verify that the source token is an ether token
1534         IERC20Token fromToken = _path[0];
1535         require(msg.value == 0 || (_amount == msg.value && etherTokens[fromToken]));
1536 
1537         ISmartToken smartToken;
1538         IERC20Token toToken;
1539         ITokenConverter converter;
1540         uint256 pathLength = _path.length;
1541 
1542         // if ETH was sent with the call, the source is an ether token - deposit the ETH in it
1543         // otherwise, we assume we already have the tokens
1544         if (msg.value > 0)
1545             IEtherToken(fromToken).deposit.value(msg.value)();
1546 
1547         // iterate over the conversion path
1548         for (uint256 i = 1; i < pathLength; i += 2) {
1549             smartToken = ISmartToken(_path[i]);
1550             toToken = _path[i + 1];
1551             converter = ITokenConverter(smartToken.owner());
1552 
1553             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
1554             if (smartToken != fromToken)
1555                 ensureAllowance(fromToken, converter, _amount);
1556 
1557             // make the conversion - if it's the last one, also provide the minimum return value
1558             _amount = converter.change(fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
1559             fromToken = toToken;
1560         }
1561 
1562         // finished the conversion, transfer the funds to the target account
1563         // if the target token is an ether token, withdraw the tokens and send them as ETH
1564         // otherwise, transfer the tokens as is
1565         if (etherTokens[toToken])
1566             IEtherToken(toToken).withdrawTo(_for, _amount);
1567         else
1568             assert(toToken.transfer(_for, _amount));
1569 
1570         return _amount;
1571     }
1572 
1573     /**
1574         @dev claims the caller's tokens, converts them to any other token in the bancor network
1575         by following a predefined conversion path and transfers the result tokens to a target account
1576         note that allowance must be set beforehand
1577 
1578         @param _path        conversion path, see conversion path format above
1579         @param _amount      amount to convert from (in the initial source token)
1580         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1581         @param _for         account that will receive the conversion result
1582 
1583         @return tokens issued in return
1584     */
1585     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public returns (uint256) {
1586         // we need to transfer the tokens from the caller to the converter before we follow
1587         // the conversion path, to allow it to execute the conversion on behalf of the caller
1588         // note: we assume we already have allowance
1589         IERC20Token fromToken = _path[0];
1590         assert(fromToken.transferFrom(msg.sender, this, _amount));
1591         return convertFor(_path, _amount, _minReturn, _for);
1592     }
1593 
1594     /**
1595         @dev converts the token to any other token in the bancor network by following
1596         a predefined conversion path and transfers the result tokens back to the sender
1597         note that the converter should already own the source tokens
1598 
1599         @param _path        conversion path, see conversion path format above
1600         @param _amount      amount to convert from (in the initial source token)
1601         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1602 
1603         @return tokens issued in return
1604     */
1605     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1606         return convertFor(_path, _amount, _minReturn, msg.sender);
1607     }
1608 
1609     /**
1610         @dev claims the caller's tokens, converts them to any other token in the bancor network
1611         by following a predefined conversion path and transfers the result tokens back to the sender
1612         note that allowance must be set beforehand
1613 
1614         @param _path        conversion path, see conversion path format above
1615         @param _amount      amount to convert from (in the initial source token)
1616         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1617 
1618         @return tokens issued in return
1619     */
1620     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1621         return claimAndConvertFor(_path, _amount, _minReturn, msg.sender);
1622     }
1623 
1624     /**
1625         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
1626 
1627         @param _token   token to check the allowance in
1628         @param _spender approved address
1629         @param _value   allowance amount
1630     */
1631     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1632         // check if allowance for the given amount already exists
1633         if (_token.allowance(this, _spender) >= _value)
1634             return;
1635 
1636         // if the allowance is nonzero, must reset it to 0 first
1637         if (_token.allowance(this, _spender) != 0)
1638             assert(_token.approve(_spender, 0));
1639 
1640         // approve the new allowance
1641         assert(_token.approve(_spender, _value));
1642     }
1643 }
1644 
1645 contract CrowdsaleController is SmartTokenController {
1646     uint256 public constant DURATION = 14 days;                 // crowdsale duration
1647     uint256 public constant TOKEN_PRICE_N = 1;                  // initial price in wei (numerator)
1648     uint256 public constant TOKEN_PRICE_D = 100;                // initial price in wei (denominator)
1649     uint256 public constant BTCS_ETHER_CAP = 50000 ether;       // maximum bitcoin suisse ether contribution
1650     uint256 public constant MAX_GAS_PRICE = 50000000000 wei;    // maximum gas price for contribution transactions
1651 
1652     string public version = '0.1';
1653 
1654     uint256 public startTime = 0;                   // crowdsale start time (in seconds)
1655     uint256 public endTime = 0;                     // crowdsale end time (in seconds)
1656     uint256 public totalEtherCap = 1000000 ether;   // current ether contribution cap, initialized with a temp value as a safety mechanism until the real cap is revealed
1657     uint256 public totalEtherContributed = 0;       // ether contributed so far
1658     bytes32 public realEtherCapHash;                // ensures that the real cap is predefined on deployment and cannot be changed later
1659     address public beneficiary = address(0);        // address to receive all ether contributions
1660     address public btcs = address(0);               // bitcoin suisse address
1661 
1662     // triggered on each contribution
1663     event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);
1664 
1665     /**
1666         @dev constructor
1667 
1668         @param _token          smart token the crowdsale is for
1669         @param _startTime      crowdsale start time
1670         @param _beneficiary    address to receive all ether contributions
1671         @param _btcs           bitcoin suisse address
1672     */
1673     function CrowdsaleController(ISmartToken _token, uint256 _startTime, address _beneficiary, address _btcs, bytes32 _realEtherCapHash)
1674         public
1675         SmartTokenController(_token)
1676         validAddress(_beneficiary)
1677         validAddress(_btcs)
1678         earlierThan(_startTime)
1679         greaterThanZero(uint256(_realEtherCapHash))
1680     {
1681         startTime = _startTime;
1682         endTime = startTime + DURATION;
1683         beneficiary = _beneficiary;
1684         btcs = _btcs;
1685         realEtherCapHash = _realEtherCapHash;
1686     }
1687 
1688     // verifies that the gas price is lower than 50 gwei
1689     modifier validGasPrice() {
1690         assert(tx.gasprice <= MAX_GAS_PRICE);
1691         _;
1692     }
1693 
1694     // verifies that the ether cap is valid based on the key provided
1695     modifier validEtherCap(uint256 _cap, uint256 _key) {
1696         require(computeRealCap(_cap, _key) == realEtherCapHash);
1697         _;
1698     }
1699 
1700     // ensures that it's earlier than the given time
1701     modifier earlierThan(uint256 _time) {
1702         assert(now < _time);
1703         _;
1704     }
1705 
1706     // ensures that the current time is between _startTime (inclusive) and _endTime (exclusive)
1707     modifier between(uint256 _startTime, uint256 _endTime) {
1708         assert(now >= _startTime && now < _endTime);
1709         _;
1710     }
1711 
1712     // ensures that the sender is bitcoin suisse
1713     modifier btcsOnly() {
1714         assert(msg.sender == btcs);
1715         _;
1716     }
1717 
1718     // ensures that we didn't reach the ether cap
1719     modifier etherCapNotReached(uint256 _contribution) {
1720         assert(safeAdd(totalEtherContributed, _contribution) <= totalEtherCap);
1721         _;
1722     }
1723 
1724     // ensures that we didn't reach the bitcoin suisse ether cap
1725     modifier btcsEtherCapNotReached(uint256 _ethContribution) {
1726         assert(safeAdd(totalEtherContributed, _ethContribution) <= BTCS_ETHER_CAP);
1727         _;
1728     }
1729 
1730     /**
1731         @dev computes the real cap based on the given cap & key
1732 
1733         @param _cap    cap
1734         @param _key    key used to compute the cap hash
1735 
1736         @return computed real cap hash
1737     */
1738     function computeRealCap(uint256 _cap, uint256 _key) public pure returns (bytes32) {
1739         return keccak256(_cap, _key);
1740     }
1741 
1742     /**
1743         @dev enables the real cap defined on deployment
1744 
1745         @param _cap    predefined cap
1746         @param _key    key used to compute the cap hash
1747     */
1748     function enableRealCap(uint256 _cap, uint256 _key)
1749         public
1750         ownerOnly
1751         active
1752         between(startTime, endTime)
1753         validEtherCap(_cap, _key)
1754     {
1755         require(_cap < totalEtherCap); // validate input
1756         totalEtherCap = _cap;
1757     }
1758 
1759     /**
1760         @dev computes the number of tokens that should be issued for a given contribution
1761 
1762         @param _contribution    contribution amount
1763 
1764         @return computed number of tokens
1765     */
1766     function computeReturn(uint256 _contribution) public pure returns (uint256) {
1767         return safeMul(_contribution, TOKEN_PRICE_D) / TOKEN_PRICE_N;
1768     }
1769 
1770     /**
1771         @dev ETH contribution
1772         can only be called during the crowdsale
1773 
1774         @return tokens issued in return
1775     */
1776     function contributeETH()
1777         public
1778         payable
1779         between(startTime, endTime)
1780         returns (uint256 amount)
1781     {
1782         return processContribution();
1783     }
1784 
1785     /**
1786         @dev Contribution through BTCs (Bitcoin Suisse only)
1787         can only be called before the crowdsale started
1788 
1789         @return tokens issued in return
1790     */
1791     function contributeBTCs()
1792         public
1793         payable
1794         btcsOnly
1795         btcsEtherCapNotReached(msg.value)
1796         earlierThan(startTime)
1797         returns (uint256 amount)
1798     {
1799         return processContribution();
1800     }
1801 
1802     /**
1803         @dev handles contribution logic
1804         note that the Contribution event is triggered using the sender as the contributor, regardless of the actual contributor
1805 
1806         @return tokens issued in return
1807     */
1808     function processContribution() private
1809         active
1810         etherCapNotReached(msg.value)
1811         validGasPrice
1812         returns (uint256 amount)
1813     {
1814         uint256 tokenAmount = computeReturn(msg.value);
1815         beneficiary.transfer(msg.value); // transfer the ether to the beneficiary account
1816         totalEtherContributed = safeAdd(totalEtherContributed, msg.value); // update the total contribution amount
1817         token.issue(msg.sender, tokenAmount); // issue new funds to the contributor in the smart token
1818         token.issue(beneficiary, tokenAmount); // issue tokens to the beneficiary
1819 
1820         Contribution(msg.sender, msg.value, tokenAmount);
1821         return tokenAmount;
1822     }
1823 
1824     // fallback
1825     function() payable public {
1826         contributeETH();
1827     }
1828 }
1829 
1830 contract ERC20Token is IERC20Token, Utils {
1831     string public standard = 'Token 0.1';
1832     string public name = '';
1833     string public symbol = '';
1834     uint8 public decimals = 0;
1835     uint256 public totalSupply = 0;
1836     mapping (address => uint256) public balanceOf;
1837     mapping (address => mapping (address => uint256)) public allowance;
1838 
1839     event Transfer(address indexed _from, address indexed _to, uint256 _value);
1840     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1841 
1842     /**
1843         @dev constructor
1844 
1845         @param _name        token name
1846         @param _symbol      token symbol
1847         @param _decimals    decimal points, for display purposes
1848     */
1849     function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
1850         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
1851 
1852         name = _name;
1853         symbol = _symbol;
1854         decimals = _decimals;
1855     }
1856 
1857     /**
1858         @dev send coins
1859         throws on any error rather then return a false flag to minimize user errors
1860 
1861         @param _to      target address
1862         @param _value   transfer amount
1863 
1864         @return true if the transfer was successful, false if it wasn't
1865     */
1866     function transfer(address _to, uint256 _value)
1867         public
1868         validAddress(_to)
1869         returns (bool success)
1870     {
1871         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
1872         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
1873         Transfer(msg.sender, _to, _value);
1874         return true;
1875     }
1876 
1877     /**
1878         @dev an account/contract attempts to get the coins
1879         throws on any error rather then return a false flag to minimize user errors
1880 
1881         @param _from    source address
1882         @param _to      target address
1883         @param _value   transfer amount
1884 
1885         @return true if the transfer was successful, false if it wasn't
1886     */
1887     function transferFrom(address _from, address _to, uint256 _value)
1888         public
1889         validAddress(_from)
1890         validAddress(_to)
1891         returns (bool success)
1892     {
1893         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
1894         balanceOf[_from] = safeSub(balanceOf[_from], _value);
1895         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
1896         Transfer(_from, _to, _value);
1897         return true;
1898     }
1899 
1900     /**
1901         @dev allow another account/contract to spend some tokens on your behalf
1902         throws on any error rather then return a false flag to minimize user errors
1903 
1904         also, to minimize the risk of the approve/transferFrom attack vector
1905         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
1906         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
1907 
1908         @param _spender approved address
1909         @param _value   allowance amount
1910 
1911         @return true if the approval was successful, false if it wasn't
1912     */
1913     function approve(address _spender, uint256 _value)
1914         public
1915         validAddress(_spender)
1916         returns (bool success)
1917     {
1918         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
1919         require(_value == 0 || allowance[msg.sender][_spender] == 0);
1920 
1921         allowance[msg.sender][_spender] = _value;
1922         Approval(msg.sender, _spender, _value);
1923         return true;
1924     }
1925 }
1926 
1927 contract EtherToken is IEtherToken, Owned, ERC20Token, TokenHolder {
1928     // triggered when the total supply is increased
1929     event Issuance(uint256 _amount);
1930     // triggered when the total supply is decreased
1931     event Destruction(uint256 _amount);
1932 
1933     /**
1934         @dev constructor
1935     */
1936     function EtherToken()
1937         public
1938         ERC20Token('Ether Token', 'ETH', 18) {
1939     }
1940 
1941     /**
1942         @dev deposit ether in the account
1943     */
1944     function deposit() public payable {
1945         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value); // add the value to the account balance
1946         totalSupply = safeAdd(totalSupply, msg.value); // increase the total supply
1947 
1948         Issuance(msg.value);
1949         Transfer(this, msg.sender, msg.value);
1950     }
1951 
1952     /**
1953         @dev withdraw ether from the account
1954 
1955         @param _amount  amount of ether to withdraw
1956     */
1957     function withdraw(uint256 _amount) public {
1958         withdrawTo(msg.sender, _amount);
1959     }
1960 
1961     /**
1962         @dev withdraw ether from the account to a target account
1963 
1964         @param _to      account to receive the ether
1965         @param _amount  amount of ether to withdraw
1966     */
1967     function withdrawTo(address _to, uint256 _amount)
1968         public
1969         notThis(_to)
1970     {
1971         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount); // deduct the amount from the account balance
1972         totalSupply = safeSub(totalSupply, _amount); // decrease the total supply
1973         _to.transfer(_amount); // send the amount to the target account
1974 
1975         Transfer(msg.sender, this, _amount);
1976         Destruction(_amount);
1977     }
1978 
1979     // ERC20 standard method overrides with some extra protection
1980 
1981     /**
1982         @dev send coins
1983         throws on any error rather then return a false flag to minimize user errors
1984 
1985         @param _to      target address
1986         @param _value   transfer amount
1987 
1988         @return true if the transfer was successful, false if it wasn't
1989     */
1990     function transfer(address _to, uint256 _value)
1991         public
1992         notThis(_to)
1993         returns (bool success)
1994     {
1995         assert(super.transfer(_to, _value));
1996         return true;
1997     }
1998 
1999     /**
2000         @dev an account/contract attempts to get the coins
2001         throws on any error rather then return a false flag to minimize user errors
2002 
2003         @param _from    source address
2004         @param _to      target address
2005         @param _value   transfer amount
2006 
2007         @return true if the transfer was successful, false if it wasn't
2008     */
2009     function transferFrom(address _from, address _to, uint256 _value)
2010         public
2011         notThis(_to)
2012         returns (bool success)
2013     {
2014         assert(super.transferFrom(_from, _to, _value));
2015         return true;
2016     }
2017 
2018     /**
2019         @dev deposit ether in the account
2020     */
2021     function() public payable {
2022         deposit();
2023     }
2024 }
2025 
2026 contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder {
2027     string public version = '0.3';
2028 
2029     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
2030 
2031     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
2032     event NewSmartToken(address _token);
2033     // triggered when the total supply is increased
2034     event Issuance(uint256 _amount);
2035     // triggered when the total supply is decreased
2036     event Destruction(uint256 _amount);
2037 
2038     /**
2039         @dev constructor
2040 
2041         @param _name       token name
2042         @param _symbol     token short symbol, minimum 1 character
2043         @param _decimals   for display purposes only
2044     */
2045     function SmartToken(string _name, string _symbol, uint8 _decimals)
2046         public
2047         ERC20Token(_name, _symbol, _decimals)
2048     {
2049         NewSmartToken(address(this));
2050     }
2051 
2052     // allows execution only when transfers aren't disabled
2053     modifier transfersAllowed {
2054         assert(transfersEnabled);
2055         _;
2056     }
2057 
2058     /**
2059         @dev disables/enables transfers
2060         can only be called by the contract owner
2061 
2062         @param _disable    true to disable transfers, false to enable them
2063     */
2064     function disableTransfers(bool _disable) public ownerOnly {
2065         transfersEnabled = !_disable;
2066     }
2067 
2068     /**
2069         @dev increases the token supply and sends the new tokens to an account
2070         can only be called by the contract owner
2071 
2072         @param _to         account to receive the new amount
2073         @param _amount     amount to increase the supply by
2074     */
2075     function issue(address _to, uint256 _amount)
2076         public
2077         ownerOnly
2078         validAddress(_to)
2079         notThis(_to)
2080     {
2081         totalSupply = safeAdd(totalSupply, _amount);
2082         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
2083 
2084         Issuance(_amount);
2085         Transfer(this, _to, _amount);
2086     }
2087 
2088     /**
2089         @dev removes tokens from an account and decreases the token supply
2090         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
2091 
2092         @param _from       account to remove the amount from
2093         @param _amount     amount to decrease the supply by
2094     */
2095     function destroy(address _from, uint256 _amount) public {
2096         require(msg.sender == _from || msg.sender == owner); // validate input
2097 
2098         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
2099         totalSupply = safeSub(totalSupply, _amount);
2100 
2101         Transfer(_from, this, _amount);
2102         Destruction(_amount);
2103     }
2104 
2105     // ERC20 standard method overrides with some extra functionality
2106 
2107     /**
2108         @dev send coins
2109         throws on any error rather then return a false flag to minimize user errors
2110         in addition to the standard checks, the function throws if transfers are disabled
2111 
2112         @param _to      target address
2113         @param _value   transfer amount
2114 
2115         @return true if the transfer was successful, false if it wasn't
2116     */
2117     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
2118         assert(super.transfer(_to, _value));
2119         return true;
2120     }
2121 
2122     /**
2123         @dev an account/contract attempts to get the coins
2124         throws on any error rather then return a false flag to minimize user errors
2125         in addition to the standard checks, the function throws if transfers are disabled
2126 
2127         @param _from    source address
2128         @param _to      target address
2129         @param _value   transfer amount
2130 
2131         @return true if the transfer was successful, false if it wasn't
2132     */
2133     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
2134         assert(super.transferFrom(_from, _to, _value));
2135         return true;
2136     }
2137 }