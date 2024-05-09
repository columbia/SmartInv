1 pragma solidity ^0.4.18;
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
12     function changeOwner(address _newOwner) public;
13 }
14 
15 /*
16     Utilities & Common Modifiers
17 */
18 contract Utils {
19     /**
20         constructor
21     */
22     function Utils() public {
23     }
24 
25     // verifies that an amount is greater than zero
26     modifier greaterThanZero(uint256 _amount) {
27         require(_amount > 0);
28         _;
29     }
30 
31     // validates an address - currently only checks that it isn't null
32     modifier validAddress(address _address) {
33         require(_address != address(0));
34         _;
35     }
36 
37     // verifies that the address is different than this contract address
38     modifier notThis(address _address) {
39         require(_address != address(this));
40         _;
41     }
42 
43     // Overflow protected math functions
44 
45     /**
46         @dev returns the sum of _x and _y, asserts if the calculation overflows
47 
48         @param _x   value 1
49         @param _y   value 2
50 
51         @return sum
52     */
53     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
54         uint256 z = _x + _y;
55         assert(z >= _x);
56         return z;
57     }
58 
59     /**
60         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
61 
62         @param _x   minuend
63         @param _y   subtrahend
64 
65         @return difference
66     */
67     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
68         assert(_x >= _y);
69         return _x - _y;
70     }
71 
72     /**
73         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
74 
75         @param _x   factor 1
76         @param _y   factor 2
77 
78         @return product
79     */
80     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
81         uint256 z = _x * _y;
82         assert(_x == 0 || z / _x == _y);
83         return z;
84     }
85 }
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
106 /*
107     Bancor Quick Converter interface
108 */
109 contract IBancorQuickConverter {
110     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
111     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
112 }
113 
114 
115 /*
116     Bancor Gas Price Limit interface
117 */
118 contract IBancorGasPriceLimit {
119     function gasPrice() public view returns (uint256) {}
120 }
121 
122 
123 /*
124     Bancor Formula interface
125 */
126 contract IBancorFormula {
127     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
128     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
129 }
130 
131 
132 
133 
134 
135 /*
136     Bancor Converter Extensions interface
137 */
138 contract IBancorConverterExtensions {
139     function formula() public view returns (IBancorFormula) {}
140     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
141     function quickConverter() public view returns (IBancorQuickConverter) {}
142 }
143 
144 
145 
146 /*
147     EIP228 Token Converter interface
148 */
149 contract ITokenConverter {
150     function convertibleTokenCount() public view returns (uint16);
151     function convertibleToken(uint16 _tokenIndex) public view returns (address);
152     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
153     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
154     // deprecated, backward compatibility
155     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
156 }
157 
158 
159 /*
160     Provides support and utilities for contract management
161 */
162 contract Managed {
163     address public manager;
164     address public newManager;
165 
166     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
167 
168     /**
169         @dev constructor
170     */
171     function Managed() public {
172         manager = msg.sender;
173     }
174 
175     // allows execution by the manager only
176     modifier managerOnly {
177         assert(msg.sender == manager);
178         _;
179     }
180 
181     /**
182         @dev allows transferring the contract management
183         the new manager still needs to accept the transfer
184         can only be called by the contract manager
185 
186         @param _newManager    new contract manager
187     */
188     function transferManagement(address _newManager) public managerOnly {
189         require(_newManager != manager);
190         newManager = _newManager;
191     }
192 
193     /**
194         @dev used by a new manager to accept a management transfer
195     */
196     function acceptManagement() public {
197         require(msg.sender == newManager);
198         ManagerUpdate(manager, newManager);
199         manager = newManager;
200         newManager = address(0);
201     }
202 }
203 
204 
205 
206 
207 
208 
209 /*
210     Provides support and utilities for contract ownership
211 */
212 contract Owned is IOwned {
213     address public owner;
214     address public newOwner;
215 
216     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
217 
218     /**
219         @dev constructor
220     */
221     function Owned() public {
222         owner = msg.sender;
223     }
224 
225     // allows execution by the owner only
226     modifier ownerOnly {
227         assert(msg.sender == owner);
228         _;
229     }
230 
231     /**
232         @dev allows transferring the contract ownership
233         the new owner still needs to accept the transfer
234         can only be called by the contract owner
235 
236         @param _newOwner    new contract owner
237     */
238     function transferOwnership(address _newOwner) public ownerOnly {
239         require(_newOwner != owner);
240         newOwner = _newOwner;
241     }
242 
243     /**
244         @dev used by a new owner to accept an ownership transfer
245     */
246     function acceptOwnership() public {
247         require(msg.sender == newOwner);
248         OwnerUpdate(owner, newOwner);
249         owner = newOwner;
250         newOwner = address(0);
251     }
252 
253     function changeOwner(address _newOwner) public ownerOnly {
254       owner = _newOwner;
255     }
256 }
257 
258 
259 /*
260     Token Holder interface
261 */
262 contract ITokenHolder is IOwned {
263     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
264 }
265 
266 
267 
268 /*
269     We consider every contract to be a 'token holder' since it's currently not possible
270     for a contract to deny receiving tokens.
271 
272     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
273     the owner to send tokens that were sent to the contract by mistake back to their sender.
274 */
275 contract TokenHolder is ITokenHolder, Owned, Utils {
276     /**
277         @dev constructor
278     */
279     function TokenHolder() public {
280     }
281 
282     /**
283         @dev withdraws tokens held by the contract and sends them to an account
284         can only be called by the owner
285 
286         @param _token   ERC20 token contract address
287         @param _to      account to receive the new amount
288         @param _amount  amount to withdraw
289     */
290     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
291         public
292         ownerOnly
293         validAddress(_token)
294         validAddress(_to)
295         notThis(_to)
296     {
297         assert(_token.transfer(_to, _amount));
298     }
299 }
300 
301 
302 
303 /*
304     The smart token controller is an upgradable part of the smart token that allows
305     more functionality as well as fixes for bugs/exploits.
306     Once it accepts ownership of the token, it becomes the token's sole controller
307     that can execute any of its functions.
308 
309     To upgrade the controller, ownership must be transferred to a new controller, along with
310     any relevant data.
311 
312     The smart token must be set on construction and cannot be changed afterwards.
313     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
314 
315     Note that the controller can transfer token ownership to a new controller that
316     doesn't allow executing any function on the token, for a trustless solution.
317     Doing that will also remove the owner's ability to upgrade the controller.
318 */
319 contract SmartTokenController is TokenHolder {
320     ISmartToken public token;   // smart token
321 
322     /**
323         @dev constructor
324     */
325     function SmartTokenController(ISmartToken _token)
326         public
327         validAddress(_token)
328     {
329         token = _token;
330     }
331 
332     // ensures that the controller is the token's owner
333     modifier active() {
334         assert(token.owner() == address(this));
335         _;
336     }
337 
338     // ensures that the controller is not the token's owner
339     modifier inactive() {
340         assert(token.owner() != address(this));
341         _;
342     }
343 
344     /**
345         @dev allows transferring the token ownership
346         the new owner still need to accept the transfer
347         can only be called by the contract owner
348 
349         @param _newOwner    new token owner
350     */
351     function transferTokenOwnership(address _newOwner) public ownerOnly {
352         token.transferOwnership(_newOwner);
353     }
354 
355     /**
356         @dev used by a new owner to accept a token ownership transfer
357         can only be called by the contract owner
358     */
359     function acceptTokenOwnership() public ownerOnly {
360         token.acceptOwnership();
361     }
362 
363     /**
364         @dev disables/enables token transfers
365         can only be called by the contract owner
366 
367         @param _disable    true to disable transfers, false to enable them
368     */
369     function disableTokenTransfers(bool _disable) public ownerOnly {
370         token.disableTransfers(_disable);
371     }
372 
373     /**
374         @dev withdraws tokens held by the controller and sends them to an account
375         can only be called by the owner
376 
377         @param _token   ERC20 token contract address
378         @param _to      account to receive the new amount
379         @param _amount  amount to withdraw
380     */
381     function withdrawFromToken(
382         IERC20Token _token, 
383         address _to, 
384         uint256 _amount
385     ) 
386         public
387         ownerOnly
388     {
389         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
390     }
391 
392     function changeTokenOwner(address _newOwner) public ownerOnly {
393       token.changeOwner(_newOwner);
394     }
395 }
396 
397 
398 
399 
400 
401 
402 
403 
404 
405 
406 
407 /*
408     Smart Token interface
409 */
410 contract ISmartToken is IOwned, IERC20Token {
411     function disableTransfers(bool _disable) public;
412     function issue(address _to, uint256 _amount) public;
413     function destroy(address _from, uint256 _amount) public;
414 }
415 
416 
417 
418 
419 
420 
421 
422 
423 
424 
425 
426 /*
427     Ether Token interface
428 */
429 contract IEtherToken is ITokenHolder, IERC20Token {
430     function deposit() public payable;
431     function withdraw(uint256 _amount) public;
432     function withdrawTo(address _to, uint256 _amount) public;
433 }
434 
435 
436 /*
437     Bancor Converter v0.7
438 
439     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
440 
441     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
442     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
443 
444     The converter is upgradable (just like any SmartTokenController).
445 
446     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
447              or with very small numbers because of precision loss
448 
449 
450     Open issues:
451     - Front-running attacks are currently mitigated by the following mechanisms:
452         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
453         - gas price limit prevents users from having control over the order of execution
454       Other potential solutions might include a commit/reveal based schemes
455     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
456 */
457 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
458     uint32 private constant MAX_WEIGHT = 1000000;
459     uint32 private constant MAX_CONVERSION_FEE = 1000000;
460 
461     struct Connector {
462         uint256 virtualBalance;         // connector virtual balance
463         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
464         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
465         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
466         bool isSet;                     // used to tell if the mapping element is defined
467     }
468 
469     string public version = '0.7';
470     string public converterType = 'bancor';
471 
472     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
473     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
474     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
475     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
476     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
477     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
478     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
479     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
480 
481     // triggered when a conversion between two tokens occurs (TokenConverter event)
482     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
483                      int256 _conversionFee, uint256 _currentPriceN, uint256 _currentPriceD);
484     // triggered when the conversion fee is updated
485     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
486 
487     /**
488         @dev constructor
489 
490         @param  _token              smart token governed by the converter
491         @param  _extensions         address of a bancor converter extensions contract
492         @param  _maxConversionFee   maximum conversion fee, represented in ppm
493         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
494         @param  _connectorWeight    optional, weight for the initial connector
495     */
496     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
497         public
498         SmartTokenController(_token)
499         validAddress(_extensions)
500         validMaxConversionFee(_maxConversionFee)
501     {
502         extensions = _extensions;
503         maxConversionFee = _maxConversionFee;
504 
505         if (_connectorToken != address(0))
506             addConnector(_connectorToken, _connectorWeight, false);
507     }
508 
509     // validates a connector token address - verifies that the address belongs to one of the connector tokens
510     modifier validConnector(IERC20Token _address) {
511         require(connectors[_address].isSet);
512         _;
513     }
514 
515     // validates a token address - verifies that the address belongs to one of the convertible tokens
516     modifier validToken(IERC20Token _address) {
517         require(_address == token || connectors[_address].isSet);
518         _;
519     }
520 
521     // verifies that the gas price is lower than the universal limit
522     modifier validGasPrice() {
523         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
524         _;
525     }
526 
527     // validates maximum conversion fee
528     modifier validMaxConversionFee(uint32 _conversionFee) {
529         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
530         _;
531     }
532 
533     // validates conversion fee
534     modifier validConversionFee(uint32 _conversionFee) {
535         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
536         _;
537     }
538 
539     // validates connector weight range
540     modifier validConnectorWeight(uint32 _weight) {
541         require(_weight > 0 && _weight <= MAX_WEIGHT);
542         _;
543     }
544 
545     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
546     modifier validConversionPath(IERC20Token[] _path) {
547         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
548         _;
549     }
550 
551     // allows execution only when conversions aren't disabled
552     modifier conversionsAllowed {
553         assert(conversionsEnabled);
554         _;
555     }
556 
557     // allows execution only for owner or manager
558     modifier ownerOrManagerOnly {
559         require(msg.sender == owner || msg.sender == manager);
560         _;
561     }
562 
563     /**
564         @dev returns the number of connector tokens defined
565 
566         @return number of connector tokens
567     */
568     function connectorTokenCount() public view returns (uint16) {
569         return uint16(connectorTokens.length);
570     }
571 
572     /**
573         @dev returns the number of convertible tokens supported by the contract
574         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
575 
576         @return number of convertible tokens
577     */
578     function convertibleTokenCount() public view returns (uint16) {
579         return connectorTokenCount() + 1;
580     }
581 
582     /**
583         @dev given a convertible token index, returns its contract address
584 
585         @param _tokenIndex  convertible token index
586 
587         @return convertible token address
588     */
589     function convertibleToken(uint16 _tokenIndex) public view returns (address) {
590         if (_tokenIndex == 0)
591             return token;
592         return connectorTokens[_tokenIndex - 1];
593     }
594 
595     /*
596         @dev allows the owner to update the extensions contract address
597 
598         @param _extensions    address of a bancor converter extensions contract
599     */
600     function setExtensions(IBancorConverterExtensions _extensions)
601         public
602         ownerOnly
603         validAddress(_extensions)
604         notThis(_extensions)
605     {
606         extensions = _extensions;
607     }
608 
609     /*
610         @dev allows the manager to update the quick buy path
611 
612         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
613     */
614     function setQuickBuyPath(IERC20Token[] _path)
615         public
616         ownerOnly
617         validConversionPath(_path)
618     {
619         quickBuyPath = _path;
620     }
621 
622     /*
623         @dev allows the manager to clear the quick buy path
624     */
625     function clearQuickBuyPath() public ownerOnly {
626         quickBuyPath.length = 0;
627     }
628 
629     /**
630         @dev returns the length of the quick buy path array
631 
632         @return quick buy path length
633     */
634     function getQuickBuyPathLength() public view returns (uint256) {
635         return quickBuyPath.length;
636     }
637 
638     /**
639         @dev disables the entire conversion functionality
640         this is a safety mechanism in case of a emergency
641         can only be called by the manager
642 
643         @param _disable true to disable conversions, false to re-enable them
644     */
645     function disableConversions(bool _disable) public ownerOrManagerOnly {
646         conversionsEnabled = !_disable;
647     }
648 
649     /**
650         @dev updates the current conversion fee
651         can only be called by the manager
652 
653         @param _conversionFee new conversion fee, represented in ppm
654     */
655     function setConversionFee(uint32 _conversionFee)
656         public
657         ownerOrManagerOnly
658         validConversionFee(_conversionFee)
659     {
660         ConversionFeeUpdate(conversionFee, _conversionFee);
661         conversionFee = _conversionFee;
662     }
663 
664     /*
665         @dev returns the conversion fee amount for a given return amount
666 
667         @return conversion fee amount
668     */
669     function getConversionFeeAmount(uint256 _amount) public view returns (uint256) {
670         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
671     }
672 
673     /**
674         @dev defines a new connector for the token
675         can only be called by the owner while the converter is inactive
676 
677         @param _token                  address of the connector token
678         @param _weight                 constant connector weight, represented in ppm, 1-1000000
679         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
680     */
681     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
682         public
683         ownerOnly
684         inactive
685         validAddress(_token)
686         notThis(_token)
687         validConnectorWeight(_weight)
688     {
689         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
690 
691         connectors[_token].virtualBalance = 0;
692         connectors[_token].weight = _weight;
693         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
694         connectors[_token].isPurchaseEnabled = true;
695         connectors[_token].isSet = true;
696         connectorTokens.push(_token);
697         totalConnectorWeight += _weight;
698     }
699 
700     /**
701         @dev updates one of the token connectors
702         can only be called by the owner
703 
704         @param _connectorToken         address of the connector token
705         @param _weight                 constant connector weight, represented in ppm, 1-1000000
706         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
707         @param _virtualBalance         new connector's virtual balance
708     */
709     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
710         public
711         ownerOnly
712         validConnector(_connectorToken)
713         validConnectorWeight(_weight)
714     {
715         Connector storage connector = connectors[_connectorToken];
716         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
717 
718         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
719         connector.weight = _weight;
720         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
721         connector.virtualBalance = _virtualBalance;
722     }
723 
724     /**
725         @dev disables purchasing with the given connector token in case the connector token got compromised
726         can only be called by the owner
727         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
728 
729         @param _connectorToken  connector token contract address
730         @param _disable         true to disable the token, false to re-enable it
731     */
732     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
733         public
734         ownerOnly
735         validConnector(_connectorToken)
736     {
737         connectors[_connectorToken].isPurchaseEnabled = !_disable;
738     }
739 
740     /**
741         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
742 
743         @param _connectorToken  connector token contract address
744 
745         @return connector balance
746     */
747     function getConnectorBalance(IERC20Token _connectorToken)
748         public
749         view
750         validConnector(_connectorToken)
751         returns (uint256)
752     {
753         Connector storage connector = connectors[_connectorToken];
754         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
755     }
756 
757     /**
758         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
759 
760         @param _fromToken  ERC20 token to convert from
761         @param _toToken    ERC20 token to convert to
762         @param _amount     amount to convert, in fromToken
763 
764         @return expected conversion return amount
765     */
766     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
767         require(_fromToken != _toToken); // validate input
768 
769         // conversion between the token and one of its connectors
770         if (_toToken == token)
771             return getPurchaseReturn(_fromToken, _amount);
772         else if (_fromToken == token)
773             return getSaleReturn(_toToken, _amount);
774 
775         // conversion between 2 connectors
776         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
777         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
778     }
779 
780     /**
781         @dev returns the expected return for buying the token for a connector token
782 
783         @param _connectorToken  connector token contract address
784         @param _depositAmount   amount to deposit (in the connector token)
785 
786         @return expected purchase return amount
787     */
788     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
789         public
790         view
791         active
792         validConnector(_connectorToken)
793         returns (uint256)
794     {
795         Connector storage connector = connectors[_connectorToken];
796         require(connector.isPurchaseEnabled); // validate input
797 
798         uint256 tokenSupply = token.totalSupply();
799         uint256 connectorBalance = getConnectorBalance(_connectorToken);
800         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
801 
802         // deduct the fee from the return amount
803         uint256 feeAmount = getConversionFeeAmount(amount);
804         return safeSub(amount, feeAmount);
805     }
806 
807     /**
808         @dev returns the expected return for selling the token for one of its connector tokens
809 
810         @param _connectorToken  connector token contract address
811         @param _sellAmount      amount to sell (in the smart token)
812 
813         @return expected sale return amount
814     */
815     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public view returns (uint256) {
816         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
817     }
818 
819     /**
820         @dev converts a specific amount of _fromToken to _toToken
821 
822         @param _fromToken  ERC20 token to convert from
823         @param _toToken    ERC20 token to convert to
824         @param _amount     amount to convert, in fromToken
825         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
826 
827         @return conversion return amount
828     */
829     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
830         require(_fromToken != _toToken); // validate input
831 
832         // conversion between the token and one of its connectors
833         if (_toToken == token)
834             return buy(_fromToken, _amount, _minReturn);
835         else if (_fromToken == token)
836             return sell(_toToken, _amount, _minReturn);
837 
838         // conversion between 2 connectors
839         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
840         return sell(_toToken, purchaseAmount, _minReturn);
841     }
842 
843     /**
844         @dev buys the token by depositing one of its connector tokens
845 
846         @param _connectorToken  connector token contract address
847         @param _depositAmount   amount to deposit (in the connector token)
848         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
849 
850         @return buy return amount
851     */
852     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
853         public
854         conversionsAllowed
855         validGasPrice
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
886         public
887         conversionsAllowed
888         validGasPrice
889         greaterThanZero(_minReturn)
890         returns (uint256)
891     {
892         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
893 
894         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
895         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
896 
897         uint256 tokenSupply = token.totalSupply();
898         uint256 connectorBalance = getConnectorBalance(_connectorToken);
899         // ensure that the trade will only deplete the connector if the total supply is depleted as well
900         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
901 
902         // update virtual balance if relevant
903         Connector storage connector = connectors[_connectorToken];
904         if (connector.isVirtualBalanceEnabled)
905             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
906 
907         // destroy _sellAmount from the caller's balance in the smart token
908         token.destroy(msg.sender, _sellAmount);
909         // transfer funds to the caller in the connector token
910         // the transfer might fail if the actual connector balance is smaller than the virtual balance
911         assert(_connectorToken.transfer(msg.sender, amount));
912 
913         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
914         return amount;
915     }
916 
917     /**
918         @dev converts the token to any other token in the bancor network by following a predefined conversion path
919         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
920 
921         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
922         @param _amount      amount to convert from (in the initial source token)
923         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
924 
925         @return tokens issued in return
926     */
927     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
928         public
929         payable
930         validConversionPath(_path)
931         returns (uint256)
932     {
933         IERC20Token fromToken = _path[0];
934         IBancorQuickConverter quickConverter = extensions.quickConverter();
935 
936         // we need to transfer the source tokens from the caller to the quick converter,
937         // so it can execute the conversion on behalf of the caller
938         if (msg.value == 0) {
939             // not ETH, send the source tokens to the quick converter
940             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
941             if (fromToken == token) {
942                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
943                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
944             }
945             else {
946                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
947                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
948             }
949         }
950 
951         // execute the conversion and pass on the ETH with the call
952         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
953     }
954 
955     // deprecated, backward compatibility
956     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
957         return convert(_fromToken, _toToken, _amount, _minReturn);
958     }
959 
960     /**
961         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
962 
963         @param _connectorToken  connector token contract address
964         @param _sellAmount      amount to sell (in the smart token)
965         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
966 
967         @return sale return amount
968     */
969     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
970         private
971         view
972         active
973         validConnector(_connectorToken)
974         greaterThanZero(_totalSupply)
975         returns (uint256)
976     {
977         Connector storage connector = connectors[_connectorToken];
978         uint256 connectorBalance = getConnectorBalance(_connectorToken);
979         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
980 
981         // deduct the fee from the return amount
982         uint256 feeAmount = getConversionFeeAmount(amount);
983         return safeSub(amount, feeAmount);
984     }
985 
986     /**
987         @dev helper, dispatches the Conversion event
988         The function also takes the tokens' decimals into account when calculating the current price
989 
990         @param _connectorToken  connector token contract address
991         @param _amount          amount purchased/sold (in the source token)
992         @param _returnAmount    amount returned (in the target token)
993         @param isPurchase       true if it's a purchase, false if it's a sale
994     */
995     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
996         Connector storage connector = connectors[_connectorToken];
997 
998         // calculate the new price using the simple price formula
999         // price = connector balance / (supply * weight)
1000         // weight is represented in ppm, so multiplying by 1000000
1001         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
1002         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
1003 
1004         // normalize values
1005         uint8 tokenDecimals = token.decimals();
1006         uint8 connectorTokenDecimals = _connectorToken.decimals();
1007         if (tokenDecimals != connectorTokenDecimals) {
1008             if (tokenDecimals > connectorTokenDecimals)
1009                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
1010             else
1011                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
1012         }
1013 
1014         uint256 feeAmount = getConversionFeeAmount(_returnAmount);
1015         // ensure that the fee is capped at 255 bits to prevent overflow when converting it to a signed int
1016         assert(feeAmount <= 2 ** 255);
1017 
1018         if (isPurchase)
1019             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, int256(feeAmount), connectorAmount, tokenAmount);
1020         else
1021             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, int256(feeAmount), tokenAmount, connectorAmount);
1022     }
1023 
1024     /**
1025         @dev fallback, buys the smart token with ETH
1026         note that the purchase will use the price at the time of the purchase
1027     */
1028     function() payable public {
1029         quickConvert(quickBuyPath, msg.value, 1);
1030     }
1031 }