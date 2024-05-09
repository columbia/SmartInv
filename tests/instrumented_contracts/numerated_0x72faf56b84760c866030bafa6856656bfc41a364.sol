1 pragma solidity ^0.4.11;
2 
3 
4 /*
5     ERC20 Standard Token interface
6 */
7 contract IERC20Token {
8     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
9     function name() public constant returns (string) {}
10     function symbol() public constant returns (string) {}
11     function decimals() public constant returns (uint8) {}
12     function totalSupply() public constant returns (uint256) {}
13     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
14     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
15 
16     function transfer(address _to, uint256 _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18     function approve(address _spender, uint256 _value) public returns (bool success);
19 }
20 
21 
22 contract IOwned {
23     // this function isn't abstract since the compiler emits automatically generated getter functions as external
24     function owner() public constant returns (address) {}
25 
26     function transferOwnership(address _newOwner) public;
27     function acceptOwnership() public;
28 }
29 
30 contract ITokenHolder is IOwned {
31     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
32 }
33 
34 
35 /*
36     Ether Token interface
37 */
38 contract IEtherToken is ITokenHolder, IERC20Token {
39     function deposit() public payable;
40     function withdraw(uint256 _amount) public;
41     function withdrawTo(address _to, uint256 _amount);
42 }
43 
44 
45 /*
46     Bancor Quick Converter interface
47 */
48 contract IBancorQuickConverter {
49     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
50     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
51 }
52 
53 
54 contract IBancorGasPriceLimit {
55     function gasPrice() public constant returns (uint256) {}
56 }
57 
58 
59 contract IBancorFormula {
60     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
61     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
62 }
63 
64 
65 /*
66     Bancor Converter Extensions interface
67 */
68 contract IBancorConverterExtensions {
69     function formula() public constant returns (IBancorFormula) {}
70     function gasPriceLimit() public constant returns (IBancorGasPriceLimit) {}
71     function quickConverter() public constant returns (IBancorQuickConverter) {}
72 }
73 
74 
75 
76 
77 /*
78     Smart Token interface
79 */
80 contract ISmartToken is IOwned, IERC20Token {
81     function disableTransfers(bool _disable) public;
82     function issue(address _to, uint256 _amount) public;
83     function destroy(address _from, uint256 _amount) public;
84 }
85 
86 
87 /*
88     EIP228 Token Converter interface
89 */
90 contract ITokenConverter {
91     function convertibleTokenCount() public constant returns (uint16);
92     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
93     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
94     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
95     // deprecated, backward compatibility
96     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
97 }
98 
99 
100 /*
101     Provides support and utilities for contract ownership
102 */
103 contract Owned is IOwned {
104     address public owner;
105     address public newOwner;
106 
107     event OwnerUpdate(address _prevOwner, address _newOwner);
108 
109     /**
110         @dev constructor
111     */
112     function Owned() {
113         owner = msg.sender;
114     }
115 
116     // allows execution by the owner only
117     modifier ownerOnly {
118         assert(msg.sender == owner);
119         _;
120     }
121 
122     /**
123         @dev allows transferring the contract ownership
124         the new owner still needs to accept the transfer
125         can only be called by the contract owner
126 
127         @param _newOwner    new contract owner
128     */
129     function transferOwnership(address _newOwner) public ownerOnly {
130         require(_newOwner != owner);
131         newOwner = _newOwner;
132     }
133 
134     /**
135         @dev used by a new owner to accept an ownership transfer
136     */
137     function acceptOwnership() public {
138         require(msg.sender == newOwner);
139         OwnerUpdate(owner, newOwner);
140         owner = newOwner;
141         newOwner = 0x0;
142     }
143 }
144 
145 
146 /*
147     Utilities & Common Modifiers
148 */
149 contract Utils {
150     /**
151         constructor
152     */
153     function Utils() {
154     }
155 
156     // verifies that an amount is greater than zero
157     modifier greaterThanZero(uint256 _amount) {
158         require(_amount > 0);
159         _;
160     }
161 
162     // validates an address - currently only checks that it isn't null
163     modifier validAddress(address _address) {
164         require(_address != 0x0);
165         _;
166     }
167 
168     // verifies that the address is different than this contract address
169     modifier notThis(address _address) {
170         require(_address != address(this));
171         _;
172     }
173 
174     // Overflow protected math functions
175 
176     /**
177         @dev returns the sum of _x and _y, asserts if the calculation overflows
178 
179         @param _x   value 1
180         @param _y   value 2
181 
182         @return sum
183     */
184     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
185         uint256 z = _x + _y;
186         assert(z >= _x);
187         return z;
188     }
189 
190     /**
191         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
192 
193         @param _x   minuend
194         @param _y   subtrahend
195 
196         @return difference
197     */
198     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
199         assert(_x >= _y);
200         return _x - _y;
201     }
202 
203     /**
204         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
205 
206         @param _x   factor 1
207         @param _y   factor 2
208 
209         @return product
210     */
211     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
212         uint256 z = _x * _y;
213         assert(_x == 0 || z / _x == _y);
214         return z;
215     }
216 }
217 
218 
219 contract Managed {
220     address public manager;
221     address public newManager;
222 
223     event ManagerUpdate(address _prevManager, address _newManager);
224 
225     /**
226         @dev constructor
227     */
228     function Managed() {
229         manager = msg.sender;
230     }
231 
232     // allows execution by the manager only
233     modifier managerOnly {
234         assert(msg.sender == manager);
235         _;
236     }
237 
238     /**
239         @dev allows transferring the contract management
240         the new manager still needs to accept the transfer
241         can only be called by the contract manager
242 
243         @param _newManager    new contract manager
244     */
245     function transferManagement(address _newManager) public managerOnly {
246         require(_newManager != manager);
247         newManager = _newManager;
248     }
249 
250     /**
251         @dev used by a new manager to accept a management transfer
252     */
253     function acceptManagement() public {
254         require(msg.sender == newManager);
255         ManagerUpdate(manager, newManager);
256         manager = newManager;
257         newManager = 0x0;
258     }
259 }
260 
261 
262 /*
263     We consider every contract to be a 'token holder' since it's currently not possible
264     for a contract to deny receiving tokens.
265 
266     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
267     the owner to send tokens that were sent to the contract by mistake back to their sender.
268 */
269 contract TokenHolder is ITokenHolder, Owned, Utils {
270     /**
271         @dev constructor
272     */
273     function TokenHolder() {
274     }
275 
276     /**
277         @dev withdraws tokens held by the contract and sends them to an account
278         can only be called by the owner
279 
280         @param _token   ERC20 token contract address
281         @param _to      account to receive the new amount
282         @param _amount  amount to withdraw
283     */
284     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
285         public
286         ownerOnly
287         validAddress(_token)
288         validAddress(_to)
289         notThis(_to)
290     {
291         assert(_token.transfer(_to, _amount));
292     }
293 }
294 
295 /*
296     The smart token controller is an upgradable part of the smart token that allows
297     more functionality as well as fixes for bugs/exploits.
298     Once it accepts ownership of the token, it becomes the token's sole controller
299     that can execute any of its functions.
300 
301     To upgrade the controller, ownership must be transferred to a new controller, along with
302     any relevant data.
303 
304     The smart token must be set on construction and cannot be changed afterwards.
305     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
306 
307     Note that the controller can transfer token ownership to a new controller that
308     doesn't allow executing any function on the token, for a trustless solution.
309     Doing that will also remove the owner's ability to upgrade the controller.
310 */
311 contract SmartTokenController is TokenHolder {
312     ISmartToken public token;   // smart token
313 
314     /**
315         @dev constructor
316     */
317     function SmartTokenController(ISmartToken _token)
318         validAddress(_token)
319     {
320         token = _token;
321     }
322 
323     // ensures that the controller is the token's owner
324     modifier active() {
325         assert(token.owner() == address(this));
326         _;
327     }
328 
329     // ensures that the controller is not the token's owner
330     modifier inactive() {
331         assert(token.owner() != address(this));
332         _;
333     }
334 
335     /**
336         @dev allows transferring the token ownership
337         the new owner still need to accept the transfer
338         can only be called by the contract owner
339 
340         @param _newOwner    new token owner
341     */
342     function transferTokenOwnership(address _newOwner) public ownerOnly {
343         token.transferOwnership(_newOwner);
344     }
345 
346     /**
347         @dev used by a new owner to accept a token ownership transfer
348         can only be called by the contract owner
349     */
350     function acceptTokenOwnership() public ownerOnly {
351         token.acceptOwnership();
352     }
353 
354     /**
355         @dev disables/enables token transfers
356         can only be called by the contract owner
357 
358         @param _disable    true to disable transfers, false to enable them
359     */
360     function disableTokenTransfers(bool _disable) public ownerOnly {
361         token.disableTransfers(_disable);
362     }
363 
364     /**
365         @dev withdraws tokens held by the token and sends them to an account
366         can only be called by the owner
367 
368         @param _token   ERC20 token contract address
369         @param _to      account to receive the new amount
370         @param _amount  amount to withdraw
371     */
372     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
373         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
374     }
375 }
376 
377 
378 /*
379     Bancor Converter v0.4
380 
381     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
382 
383     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
384     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
385 
386     The converter is upgradable (just like any SmartTokenController).
387 
388     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
389              or with very small numbers because of precision loss
390 
391 
392     Open issues:
393     - Front-running attacks are currently mitigated by the following mechanisms:
394         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
395         - gas price limit prevents users from having control over the order of execution
396       Other potential solutions might include a commit/reveal based schemes
397     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
398 */
399 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
400     uint32 private constant MAX_WEIGHT = 1000000;
401     uint32 private constant MAX_CONVERSION_FEE = 1000000;
402 
403     struct Connector {
404         uint256 virtualBalance;         // connector virtual balance
405         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
406         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
407         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
408         bool isSet;                     // used to tell if the mapping element is defined
409     }
410 
411     string public version = '0.5';
412     string public converterType = 'bancor';
413 
414     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
415     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
416     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
417     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
418     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
419     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
420     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
421     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
422 
423     // triggered when a conversion between two tokens occurs (TokenConverter event)
424     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
425                      uint256 _currentPriceN, uint256 _currentPriceD);
426 
427     /**
428         @dev constructor
429 
430         @param  _token              smart token governed by the converter
431         @param  _extensions         address of a bancor converter extensions contract
432         @param  _maxConversionFee   maximum conversion fee, represented in ppm
433         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
434         @param  _connectorWeight    optional, weight for the initial connector
435     */
436     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
437         SmartTokenController(_token)
438         validAddress(_extensions)
439         validMaxConversionFee(_maxConversionFee)
440     {
441         extensions = _extensions;
442         maxConversionFee = _maxConversionFee;
443 
444         if (address(_connectorToken) != 0x0)
445             addConnector(_connectorToken, _connectorWeight, false);
446     }
447 
448     // validates a connector token address - verifies that the address belongs to one of the connector tokens
449     modifier validConnector(IERC20Token _address) {
450         require(connectors[_address].isSet);
451         _;
452     }
453 
454     // validates a token address - verifies that the address belongs to one of the convertible tokens
455     modifier validToken(IERC20Token _address) {
456         require(_address == token || connectors[_address].isSet);
457         _;
458     }
459 
460     // verifies that the gas price is lower than the universal limit
461     modifier validGasPrice() {
462         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
463         _;
464     }
465 
466     // validates maximum conversion fee
467     modifier validMaxConversionFee(uint32 _conversionFee) {
468         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
469         _;
470     }
471 
472     // validates conversion fee
473     modifier validConversionFee(uint32 _conversionFee) {
474         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
475         _;
476     }
477 
478     // validates connector weight range
479     modifier validConnectorWeight(uint32 _weight) {
480         require(_weight > 0 && _weight <= MAX_WEIGHT);
481         _;
482     }
483 
484     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
485     modifier validConversionPath(IERC20Token[] _path) {
486         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
487         _;
488     }
489 
490     // allows execution only when conversions aren't disabled
491     modifier conversionsAllowed {
492         assert(conversionsEnabled);
493         _;
494     }
495 
496     /**
497         @dev returns the number of connector tokens defined
498 
499         @return number of connector tokens
500     */
501     function connectorTokenCount() public constant returns (uint16) {
502         return uint16(connectorTokens.length);
503     }
504 
505     /**
506         @dev returns the number of convertible tokens supported by the contract
507         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
508 
509         @return number of convertible tokens
510     */
511     function convertibleTokenCount() public constant returns (uint16) {
512         return connectorTokenCount() + 1;
513     }
514 
515     /**
516         @dev given a convertible token index, returns its contract address
517 
518         @param _tokenIndex  convertible token index
519 
520         @return convertible token address
521     */
522     function convertibleToken(uint16 _tokenIndex) public constant returns (address) {
523         if (_tokenIndex == 0)
524             return token;
525         return connectorTokens[_tokenIndex - 1];
526     }
527 
528     /*
529         @dev allows the owner to update the extensions contract address
530 
531         @param _extensions    address of a bancor converter extensions contract
532     */
533     function setExtensions(IBancorConverterExtensions _extensions)
534         public
535         ownerOnly
536         validAddress(_extensions)
537         notThis(_extensions)
538     {
539         extensions = _extensions;
540     }
541 
542     /*
543         @dev allows the manager to update the quick buy path
544 
545         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
546     */
547     function setQuickBuyPath(IERC20Token[] _path)
548         public
549         ownerOnly
550         validConversionPath(_path)
551     {
552         quickBuyPath = _path;
553     }
554 
555     /*
556         @dev allows the manager to clear the quick buy path
557     */
558     function clearQuickBuyPath() public ownerOnly {
559         quickBuyPath.length = 0;
560     }
561 
562     /**
563         @dev returns the length of the quick buy path array
564 
565         @return quick buy path length
566     */
567     function getQuickBuyPathLength() public constant returns (uint256) {
568         return quickBuyPath.length;
569     }
570 
571     /**
572         @dev disables the entire conversion functionality
573         this is a safety mechanism in case of a emergency
574         can only be called by the manager
575 
576         @param _disable true to disable conversions, false to re-enable them
577     */
578     function disableConversions(bool _disable) public managerOnly {
579         conversionsEnabled = !_disable;
580     }
581 
582     /**
583         @dev updates the current conversion fee
584         can only be called by the manager
585 
586         @param _conversionFee new conversion fee, represented in ppm
587     */
588     function setConversionFee(uint32 _conversionFee)
589         public
590         managerOnly
591         validConversionFee(_conversionFee)
592     {
593         conversionFee = _conversionFee;
594     }
595 
596     /*
597         @dev returns the conversion fee amount for a given return amount
598 
599         @return conversion fee amount
600     */
601     function getConversionFeeAmount(uint256 _amount) public constant returns (uint256) {
602         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
603     }
604 
605     /**
606         @dev defines a new connector for the token
607         can only be called by the owner while the converter is inactive
608 
609         @param _token                  address of the connector token
610         @param _weight                 constant connector weight, represented in ppm, 1-1000000
611         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
612     */
613     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
614         public
615         ownerOnly
616         inactive
617         validAddress(_token)
618         notThis(_token)
619         validConnectorWeight(_weight)
620     {
621         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
622 
623         connectors[_token].virtualBalance = 0;
624         connectors[_token].weight = _weight;
625         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
626         connectors[_token].isPurchaseEnabled = true;
627         connectors[_token].isSet = true;
628         connectorTokens.push(_token);
629         totalConnectorWeight += _weight;
630     }
631 
632     /**
633         @dev updates one of the token connectors
634         can only be called by the owner
635 
636         @param _connectorToken         address of the connector token
637         @param _weight                 constant connector weight, represented in ppm, 1-1000000
638         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
639         @param _virtualBalance         new connector's virtual balance
640     */
641     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
642         public
643         ownerOnly
644         validConnector(_connectorToken)
645         validConnectorWeight(_weight)
646     {
647         Connector storage connector = connectors[_connectorToken];
648         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
649 
650         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
651         connector.weight = _weight;
652         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
653         connector.virtualBalance = _virtualBalance;
654     }
655 
656     /**
657         @dev disables purchasing with the given connector token in case the connector token got compromised
658         can only be called by the owner
659         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
660 
661         @param _connectorToken  connector token contract address
662         @param _disable         true to disable the token, false to re-enable it
663     */
664     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
665         public
666         ownerOnly
667         validConnector(_connectorToken)
668     {
669         connectors[_connectorToken].isPurchaseEnabled = !_disable;
670     }
671 
672     /**
673         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
674 
675         @param _connectorToken  connector token contract address
676 
677         @return connector balance
678     */
679     function getConnectorBalance(IERC20Token _connectorToken)
680         public
681         constant
682         validConnector(_connectorToken)
683         returns (uint256)
684     {
685         Connector storage connector = connectors[_connectorToken];
686         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
687     }
688 
689     /**
690         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
691 
692         @param _fromToken  ERC20 token to convert from
693         @param _toToken    ERC20 token to convert to
694         @param _amount     amount to convert, in fromToken
695 
696         @return expected conversion return amount
697     */
698     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256) {
699         require(_fromToken != _toToken); // validate input
700 
701         // conversion between the token and one of its connectors
702         if (_toToken == token)
703             return getPurchaseReturn(_fromToken, _amount);
704         else if (_fromToken == token)
705             return getSaleReturn(_toToken, _amount);
706 
707         // conversion between 2 connectors
708         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
709         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
710     }
711 
712     /**
713         @dev returns the expected return for buying the token for a connector token
714 
715         @param _connectorToken  connector token contract address
716         @param _depositAmount   amount to deposit (in the connector token)
717 
718         @return expected purchase return amount
719     */
720     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
721         public
722         constant
723         active
724         validConnector(_connectorToken)
725         returns (uint256)
726     {
727         Connector storage connector = connectors[_connectorToken];
728         require(connector.isPurchaseEnabled); // validate input
729 
730         uint256 tokenSupply = token.totalSupply();
731         uint256 connectorBalance = getConnectorBalance(_connectorToken);
732         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
733 
734         // deduct the fee from the return amount
735         uint256 feeAmount = getConversionFeeAmount(amount);
736         return safeSub(amount, feeAmount);
737     }
738 
739     /**
740         @dev returns the expected return for selling the token for one of its connector tokens
741 
742         @param _connectorToken  connector token contract address
743         @param _sellAmount      amount to sell (in the smart token)
744 
745         @return expected sale return amount
746     */
747     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public constant returns (uint256) {
748         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
749     }
750 
751     /**
752         @dev converts a specific amount of _fromToken to _toToken
753 
754         @param _fromToken  ERC20 token to convert from
755         @param _toToken    ERC20 token to convert to
756         @param _amount     amount to convert, in fromToken
757         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
758 
759         @return conversion return amount
760     */
761     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
762         require(_fromToken != _toToken); // validate input
763 
764         // conversion between the token and one of its connectors
765         if (_toToken == token)
766             return buy(_fromToken, _amount, _minReturn);
767         else if (_fromToken == token)
768             return sell(_toToken, _amount, _minReturn);
769 
770         // conversion between 2 connectors
771         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
772         return sell(_toToken, purchaseAmount, _minReturn);
773     }
774 
775     /**
776         @dev buys the token by depositing one of its connector tokens
777 
778         @param _connectorToken  connector token contract address
779         @param _depositAmount   amount to deposit (in the connector token)
780         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
781 
782         @return buy return amount
783     */
784     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
785         public
786         conversionsAllowed
787         validGasPrice
788         greaterThanZero(_minReturn)
789         returns (uint256)
790     {
791         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
792         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
793 
794         // update virtual balance if relevant
795         Connector storage connector = connectors[_connectorToken];
796         if (connector.isVirtualBalanceEnabled)
797             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
798 
799         // transfer _depositAmount funds from the caller in the connector token
800         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
801         // issue new funds to the caller in the smart token
802         token.issue(msg.sender, amount);
803 
804         // calculate the new price using the simple price formula
805         // price = connector balance / (supply * weight)
806         // weight is represented in ppm, so multiplying by 1000000
807         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
808         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
809         Conversion(_connectorToken, token, msg.sender, _depositAmount, amount, connectorAmount, tokenAmount);
810         return amount;
811     }
812 
813     /**
814         @dev sells the token by withdrawing from one of its connector tokens
815 
816         @param _connectorToken  connector token contract address
817         @param _sellAmount      amount to sell (in the smart token)
818         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
819 
820         @return sell return amount
821     */
822     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
823         public
824         conversionsAllowed
825         validGasPrice
826         greaterThanZero(_minReturn)
827         returns (uint256)
828     {
829         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
830 
831         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
832         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
833 
834         uint256 tokenSupply = token.totalSupply();
835         uint256 connectorBalance = getConnectorBalance(_connectorToken);
836         // ensure that the trade will only deplete the connector if the total supply is depleted as well
837         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
838 
839         // update virtual balance if relevant
840         Connector storage connector = connectors[_connectorToken];
841         if (connector.isVirtualBalanceEnabled)
842             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
843 
844         // destroy _sellAmount from the caller's balance in the smart token
845         token.destroy(msg.sender, _sellAmount);
846         // transfer funds to the caller in the connector token
847         // the transfer might fail if the actual connector balance is smaller than the virtual balance
848         assert(_connectorToken.transfer(msg.sender, amount));
849 
850         // calculate the new price using the simple price formula
851         // price = connector balance / (supply * weight)
852         // weight is represented in ppm, so multiplying by 1000000
853         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
854         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
855         Conversion(token, _connectorToken, msg.sender, _sellAmount, amount, tokenAmount, connectorAmount);
856         return amount;
857     }
858 
859     /**
860         @dev converts the token to any other token in the bancor network by following a predefined conversion path
861         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
862 
863         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
864         @param _amount      amount to convert from (in the initial source token)
865         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
866 
867         @return tokens issued in return
868     */
869     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
870         public
871         payable
872         validConversionPath(_path)
873         returns (uint256)
874     {
875         IERC20Token fromToken = _path[0];
876         IBancorQuickConverter quickConverter = extensions.quickConverter();
877 
878         // we need to transfer the source tokens from the caller to the quick converter,
879         // so it can execute the conversion on behalf of the caller
880         if (msg.value == 0) {
881             // not ETH, send the source tokens to the quick converter
882             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
883             if (fromToken == token) {
884                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
885                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
886             }
887             else {
888                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
889                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
890             }
891         }
892 
893         // execute the conversion and pass on the ETH with the call
894         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
895     }
896 
897     // deprecated, backward compatibility
898     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
899         return convert(_fromToken, _toToken, _amount, _minReturn);
900     }
901 
902     /**
903         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
904 
905         @param _connectorToken  connector token contract address
906         @param _sellAmount      amount to sell (in the smart token)
907         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
908 
909         @return sale return amount
910     */
911     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
912         private
913         constant
914         active
915         validConnector(_connectorToken)
916         greaterThanZero(_totalSupply)
917         returns (uint256)
918     {
919         Connector storage connector = connectors[_connectorToken];
920         uint256 connectorBalance = getConnectorBalance(_connectorToken);
921         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
922 
923         // deduct the fee from the return amount
924         uint256 feeAmount = getConversionFeeAmount(amount);
925         return safeSub(amount, feeAmount);
926     }
927 
928     /**
929         @dev fallback, buys the smart token with ETH
930         note that the purchase will use the price at the time of the purchase
931     */
932     function() payable {
933         quickConvert(quickBuyPath, msg.value, 1);
934     }
935 }