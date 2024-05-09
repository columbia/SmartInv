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
76     Provides support and utilities for contract management
77 */
78 contract Managed {
79     address public manager;
80     address public newManager;
81 
82     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
83 
84     /**
85         @dev constructor
86     */
87     function Managed() public {
88         manager = msg.sender;
89     }
90 
91     // allows execution by the manager only
92     modifier managerOnly {
93         assert(msg.sender == manager);
94         _;
95     }
96 
97     /**
98         @dev allows transferring the contract management
99         the new manager still needs to accept the transfer
100         can only be called by the contract manager
101 
102         @param _newManager    new contract manager
103     */
104     function transferManagement(address _newManager) public managerOnly {
105         require(_newManager != manager);
106         newManager = _newManager;
107     }
108 
109     /**
110         @dev used by a new manager to accept a management transfer
111     */
112     function acceptManagement() public {
113         require(msg.sender == newManager);
114         ManagerUpdate(manager, newManager);
115         manager = newManager;
116         newManager = address(0);
117     }
118 }
119 
120 /*
121     Owned contract interface
122 */
123 contract IOwned {
124     // this function isn't abstract since the compiler emits automatically generated getter functions as external
125     function owner() public view returns (address) {}
126 
127     function transferOwnership(address _newOwner) public;
128     function acceptOwnership() public;
129 }
130 
131 /*
132     Provides support and utilities for contract ownership
133 */
134 contract Owned is IOwned {
135     address public owner;
136     address public newOwner;
137 
138     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
139 
140     /**
141         @dev constructor
142     */
143     function Owned() public {
144         owner = msg.sender;
145     }
146 
147     // allows execution by the owner only
148     modifier ownerOnly {
149         assert(msg.sender == owner);
150         _;
151     }
152 
153     /**
154         @dev allows transferring the contract ownership
155         the new owner still needs to accept the transfer
156         can only be called by the contract owner
157 
158         @param _newOwner    new contract owner
159     */
160     function transferOwnership(address _newOwner) public ownerOnly {
161         require(_newOwner != owner);
162         newOwner = _newOwner;
163     }
164 
165     /**
166         @dev used by a new owner to accept an ownership transfer
167     */
168     function acceptOwnership() public {
169         require(msg.sender == newOwner);
170         OwnerUpdate(owner, newOwner);
171         owner = newOwner;
172         newOwner = address(0);
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
194     Token Holder interface
195 */
196 contract ITokenHolder is IOwned {
197     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
198 }
199 
200 /*
201     We consider every contract to be a 'token holder' since it's currently not possible
202     for a contract to deny receiving tokens.
203 
204     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
205     the owner to send tokens that were sent to the contract by mistake back to their sender.
206 */
207 contract TokenHolder is ITokenHolder, Owned, Utils {
208     /**
209         @dev constructor
210     */
211     function TokenHolder() public {
212     }
213 
214     /**
215         @dev withdraws tokens held by the contract and sends them to an account
216         can only be called by the owner
217 
218         @param _token   ERC20 token contract address
219         @param _to      account to receive the new amount
220         @param _amount  amount to withdraw
221     */
222     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
223         public
224         ownerOnly
225         validAddress(_token)
226         validAddress(_to)
227         notThis(_to)
228     {
229         assert(_token.transfer(_to, _amount));
230     }
231 }
232 
233 /*
234     Ether Token interface
235 */
236 contract IEtherToken is ITokenHolder, IERC20Token {
237     function deposit() public payable;
238     function withdraw(uint256 _amount) public;
239     function withdrawTo(address _to, uint256 _amount) public;
240 }
241 
242 /*
243     Smart Token interface
244 */
245 contract ISmartToken is IOwned, IERC20Token {
246     function disableTransfers(bool _disable) public;
247     function issue(address _to, uint256 _amount) public;
248     function destroy(address _from, uint256 _amount) public;
249 }
250 
251 /*
252     The smart token controller is an upgradable part of the smart token that allows
253     more functionality as well as fixes for bugs/exploits.
254     Once it accepts ownership of the token, it becomes the token's sole controller
255     that can execute any of its functions.
256 
257     To upgrade the controller, ownership must be transferred to a new controller, along with
258     any relevant data.
259 
260     The smart token must be set on construction and cannot be changed afterwards.
261     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
262 
263     Note that the controller can transfer token ownership to a new controller that
264     doesn't allow executing any function on the token, for a trustless solution.
265     Doing that will also remove the owner's ability to upgrade the controller.
266 */
267 contract SmartTokenController is TokenHolder {
268     ISmartToken public token;   // smart token
269 
270     /**
271         @dev constructor
272     */
273     function SmartTokenController(ISmartToken _token)
274         public
275         validAddress(_token)
276     {
277         token = _token;
278     }
279 
280     // ensures that the controller is the token's owner
281     modifier active() {
282         assert(token.owner() == address(this));
283         _;
284     }
285 
286     // ensures that the controller is not the token's owner
287     modifier inactive() {
288         assert(token.owner() != address(this));
289         _;
290     }
291 
292     /**
293         @dev allows transferring the token ownership
294         the new owner still need to accept the transfer
295         can only be called by the contract owner
296 
297         @param _newOwner    new token owner
298     */
299     function transferTokenOwnership(address _newOwner) public ownerOnly {
300         token.transferOwnership(_newOwner);
301     }
302 
303     /**
304         @dev used by a new owner to accept a token ownership transfer
305         can only be called by the contract owner
306     */
307     function acceptTokenOwnership() public ownerOnly {
308         token.acceptOwnership();
309     }
310 
311     /**
312         @dev disables/enables token transfers
313         can only be called by the contract owner
314 
315         @param _disable    true to disable transfers, false to enable them
316     */
317     function disableTokenTransfers(bool _disable) public ownerOnly {
318         token.disableTransfers(_disable);
319     }
320 
321     /**
322         @dev withdraws tokens held by the controller and sends them to an account
323         can only be called by the owner
324 
325         @param _token   ERC20 token contract address
326         @param _to      account to receive the new amount
327         @param _amount  amount to withdraw
328     */
329     function withdrawFromToken(
330         IERC20Token _token, 
331         address _to, 
332         uint256 _amount
333     ) 
334         public
335         ownerOnly
336     {
337         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
338     }
339 }
340 
341 /*
342     Bancor Formula interface
343 */
344 contract IBancorFormula {
345     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
346     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
347 }
348 
349 /*
350     Bancor Gas Price Limit interface
351 */
352 contract IBancorGasPriceLimit {
353     function gasPrice() public view returns (uint256) {}
354 }
355 
356 /*
357     Bancor Quick Converter interface
358 */
359 contract IBancorQuickConverter {
360     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
361     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
362 }
363 
364 /*
365     Bancor Converter Extensions interface
366 */
367 contract IBancorConverterExtensions {
368     function formula() public view returns (IBancorFormula) {}
369     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
370     function quickConverter() public view returns (IBancorQuickConverter) {}
371 }
372 
373 /*
374     EIP228 Token Converter interface
375 */
376 contract ITokenConverter {
377     function convertibleTokenCount() public view returns (uint16);
378     function convertibleToken(uint16 _tokenIndex) public view returns (address);
379     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
380     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
381     // deprecated, backward compatibility
382     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
383 }
384 
385 /*
386     Bancor Converter v0.7
387 
388     The Bancor version of the token converter, allows conversion between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
389 
390     ERC20 connector balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
391     the actual connector balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
392 
393     The converter is upgradable (just like any SmartTokenController).
394 
395     WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits
396              or with very small numbers because of precision loss
397 
398 
399     Open issues:
400     - Front-running attacks are currently mitigated by the following mechanisms:
401         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
402         - gas price limit prevents users from having control over the order of execution
403       Other potential solutions might include a commit/reveal based schemes
404     - Possibly add getters for the connector fields so that the client won't need to rely on the order in the struct
405 */
406 contract BancorConverter is ITokenConverter, SmartTokenController, Managed {
407     uint32 private constant MAX_WEIGHT = 1000000;
408     uint32 private constant MAX_CONVERSION_FEE = 1000000;
409 
410     struct Connector {
411         uint256 virtualBalance;         // connector virtual balance
412         uint32 weight;                  // connector weight, represented in ppm, 1-1000000
413         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
414         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the connector, can be set by the owner
415         bool isSet;                     // used to tell if the mapping element is defined
416     }
417 
418     string public version = '0.7';
419     string public converterType = 'bancor';
420 
421     IBancorConverterExtensions public extensions;       // bancor converter extensions contract
422     IERC20Token[] public connectorTokens;               // ERC20 standard token addresses
423     IERC20Token[] public quickBuyPath;                  // conversion path that's used in order to buy the token with ETH
424     mapping (address => Connector) public connectors;   // connector token addresses -> connector data
425     uint32 private totalConnectorWeight = 0;            // used to efficiently prevent increasing the total connector weight above 100%
426     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
427     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
428     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
429 
430     // triggered when a conversion between two tokens occurs (TokenConverter event)
431     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
432                      int256 _conversionFee, uint256 _currentPriceN, uint256 _currentPriceD);
433     // triggered when the conversion fee is updated
434     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
435 
436     /**
437         @dev constructor
438 
439         @param  _token              smart token governed by the converter
440         @param  _extensions         address of a bancor converter extensions contract
441         @param  _maxConversionFee   maximum conversion fee, represented in ppm
442         @param  _connectorToken     optional, initial connector, allows defining the first connector at deployment time
443         @param  _connectorWeight    optional, weight for the initial connector
444     */
445     function BancorConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight)
446         public
447         SmartTokenController(_token)
448         validAddress(_extensions)
449         validMaxConversionFee(_maxConversionFee)
450     {
451         extensions = _extensions;
452         maxConversionFee = _maxConversionFee;
453 
454         if (_connectorToken != address(0))
455             addConnector(_connectorToken, _connectorWeight, false);
456     }
457 
458     // validates a connector token address - verifies that the address belongs to one of the connector tokens
459     modifier validConnector(IERC20Token _address) {
460         require(connectors[_address].isSet);
461         _;
462     }
463 
464     // validates a token address - verifies that the address belongs to one of the convertible tokens
465     modifier validToken(IERC20Token _address) {
466         require(_address == token || connectors[_address].isSet);
467         _;
468     }
469 
470     // verifies that the gas price is lower than the universal limit
471     modifier validGasPrice() {
472         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
473         _;
474     }
475 
476     // validates maximum conversion fee
477     modifier validMaxConversionFee(uint32 _conversionFee) {
478         require(_conversionFee >= 0 && _conversionFee <= MAX_CONVERSION_FEE);
479         _;
480     }
481 
482     // validates conversion fee
483     modifier validConversionFee(uint32 _conversionFee) {
484         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
485         _;
486     }
487 
488     // validates connector weight range
489     modifier validConnectorWeight(uint32 _weight) {
490         require(_weight > 0 && _weight <= MAX_WEIGHT);
491         _;
492     }
493 
494     // validates a conversion path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
495     modifier validConversionPath(IERC20Token[] _path) {
496         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
497         _;
498     }
499 
500     // allows execution only when conversions aren't disabled
501     modifier conversionsAllowed {
502         assert(conversionsEnabled);
503         _;
504     }
505 
506     // allows execution only for owner or manager
507     modifier ownerOrManagerOnly {
508         require(msg.sender == owner || msg.sender == manager);
509         _;
510     }
511 
512     /**
513         @dev returns the number of connector tokens defined
514 
515         @return number of connector tokens
516     */
517     function connectorTokenCount() public view returns (uint16) {
518         return uint16(connectorTokens.length);
519     }
520 
521     /**
522         @dev returns the number of convertible tokens supported by the contract
523         note that the number of convertible tokens is the number of connector token, plus 1 (that represents the smart token)
524 
525         @return number of convertible tokens
526     */
527     function convertibleTokenCount() public view returns (uint16) {
528         return connectorTokenCount() + 1;
529     }
530 
531     /**
532         @dev given a convertible token index, returns its contract address
533 
534         @param _tokenIndex  convertible token index
535 
536         @return convertible token address
537     */
538     function convertibleToken(uint16 _tokenIndex) public view returns (address) {
539         if (_tokenIndex == 0)
540             return token;
541         return connectorTokens[_tokenIndex - 1];
542     }
543 
544     /*
545         @dev allows the owner to update the extensions contract address
546 
547         @param _extensions    address of a bancor converter extensions contract
548     */
549     function setExtensions(IBancorConverterExtensions _extensions)
550         public
551         ownerOnly
552         validAddress(_extensions)
553         notThis(_extensions)
554     {
555         extensions = _extensions;
556     }
557 
558     /*
559         @dev allows the manager to update the quick buy path
560 
561         @param _path    new quick buy path, see conversion path format in the BancorQuickConverter contract
562     */
563     function setQuickBuyPath(IERC20Token[] _path)
564         public
565         ownerOnly
566         validConversionPath(_path)
567     {
568         quickBuyPath = _path;
569     }
570 
571     /*
572         @dev allows the manager to clear the quick buy path
573     */
574     function clearQuickBuyPath() public ownerOnly {
575         quickBuyPath.length = 0;
576     }
577 
578     /**
579         @dev returns the length of the quick buy path array
580 
581         @return quick buy path length
582     */
583     function getQuickBuyPathLength() public view returns (uint256) {
584         return quickBuyPath.length;
585     }
586 
587     /**
588         @dev disables the entire conversion functionality
589         this is a safety mechanism in case of a emergency
590         can only be called by the manager
591 
592         @param _disable true to disable conversions, false to re-enable them
593     */
594     function disableConversions(bool _disable) public ownerOrManagerOnly {
595         conversionsEnabled = !_disable;
596     }
597 
598     /**
599         @dev updates the current conversion fee
600         can only be called by the manager
601 
602         @param _conversionFee new conversion fee, represented in ppm
603     */
604     function setConversionFee(uint32 _conversionFee)
605         public
606         ownerOrManagerOnly
607         validConversionFee(_conversionFee)
608     {
609         ConversionFeeUpdate(conversionFee, _conversionFee);
610         conversionFee = _conversionFee;
611     }
612 
613     /*
614         @dev returns the conversion fee amount for a given return amount
615 
616         @return conversion fee amount
617     */
618     function getConversionFeeAmount(uint256 _amount) public view returns (uint256) {
619         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
620     }
621 
622     /**
623         @dev defines a new connector for the token
624         can only be called by the owner while the converter is inactive
625 
626         @param _token                  address of the connector token
627         @param _weight                 constant connector weight, represented in ppm, 1-1000000
628         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
629     */
630     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance)
631         public
632         ownerOnly
633         inactive
634         validAddress(_token)
635         notThis(_token)
636         validConnectorWeight(_weight)
637     {
638         require(_token != token && !connectors[_token].isSet && totalConnectorWeight + _weight <= MAX_WEIGHT); // validate input
639 
640         connectors[_token].virtualBalance = 0;
641         connectors[_token].weight = _weight;
642         connectors[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
643         connectors[_token].isPurchaseEnabled = true;
644         connectors[_token].isSet = true;
645         connectorTokens.push(_token);
646         totalConnectorWeight += _weight;
647     }
648 
649     /**
650         @dev updates one of the token connectors
651         can only be called by the owner
652 
653         @param _connectorToken         address of the connector token
654         @param _weight                 constant connector weight, represented in ppm, 1-1000000
655         @param _enableVirtualBalance   true to enable virtual balance for the connector, false to disable it
656         @param _virtualBalance         new connector's virtual balance
657     */
658     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance)
659         public
660         ownerOnly
661         validConnector(_connectorToken)
662         validConnectorWeight(_weight)
663     {
664         Connector storage connector = connectors[_connectorToken];
665         require(totalConnectorWeight - connector.weight + _weight <= MAX_WEIGHT); // validate input
666 
667         totalConnectorWeight = totalConnectorWeight - connector.weight + _weight;
668         connector.weight = _weight;
669         connector.isVirtualBalanceEnabled = _enableVirtualBalance;
670         connector.virtualBalance = _virtualBalance;
671     }
672 
673     /**
674         @dev disables purchasing with the given connector token in case the connector token got compromised
675         can only be called by the owner
676         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
677 
678         @param _connectorToken  connector token contract address
679         @param _disable         true to disable the token, false to re-enable it
680     */
681     function disableConnectorPurchases(IERC20Token _connectorToken, bool _disable)
682         public
683         ownerOnly
684         validConnector(_connectorToken)
685     {
686         connectors[_connectorToken].isPurchaseEnabled = !_disable;
687     }
688 
689     /**
690         @dev returns the connector's virtual balance if one is defined, otherwise returns the actual balance
691 
692         @param _connectorToken  connector token contract address
693 
694         @return connector balance
695     */
696     function getConnectorBalance(IERC20Token _connectorToken)
697         public
698         view
699         validConnector(_connectorToken)
700         returns (uint256)
701     {
702         Connector storage connector = connectors[_connectorToken];
703         return connector.isVirtualBalanceEnabled ? connector.virtualBalance : _connectorToken.balanceOf(this);
704     }
705 
706     /**
707         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
708 
709         @param _fromToken  ERC20 token to convert from
710         @param _toToken    ERC20 token to convert to
711         @param _amount     amount to convert, in fromToken
712 
713         @return expected conversion return amount
714     */
715     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256) {
716         require(_fromToken != _toToken); // validate input
717 
718         // conversion between the token and one of its connectors
719         if (_toToken == token)
720             return getPurchaseReturn(_fromToken, _amount);
721         else if (_fromToken == token)
722             return getSaleReturn(_toToken, _amount);
723 
724         // conversion between 2 connectors
725         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
726         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
727     }
728 
729     /**
730         @dev returns the expected return for buying the token for a connector token
731 
732         @param _connectorToken  connector token contract address
733         @param _depositAmount   amount to deposit (in the connector token)
734 
735         @return expected purchase return amount
736     */
737     function getPurchaseReturn(IERC20Token _connectorToken, uint256 _depositAmount)
738         public
739         view
740         active
741         validConnector(_connectorToken)
742         returns (uint256)
743     {
744         Connector storage connector = connectors[_connectorToken];
745         require(connector.isPurchaseEnabled); // validate input
746 
747         uint256 tokenSupply = token.totalSupply();
748         uint256 connectorBalance = getConnectorBalance(_connectorToken);
749         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, connectorBalance, connector.weight, _depositAmount);
750 
751         // deduct the fee from the return amount
752         uint256 feeAmount = getConversionFeeAmount(amount);
753         return safeSub(amount, feeAmount);
754     }
755 
756     /**
757         @dev returns the expected return for selling the token for one of its connector tokens
758 
759         @param _connectorToken  connector token contract address
760         @param _sellAmount      amount to sell (in the smart token)
761 
762         @return expected sale return amount
763     */
764     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount) public view returns (uint256) {
765         return getSaleReturn(_connectorToken, _sellAmount, token.totalSupply());
766     }
767 
768     /**
769         @dev converts a specific amount of _fromToken to _toToken
770 
771         @param _fromToken  ERC20 token to convert from
772         @param _toToken    ERC20 token to convert to
773         @param _amount     amount to convert, in fromToken
774         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
775 
776         @return conversion return amount
777     */
778     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
779         require(_fromToken != _toToken); // validate input
780 
781         // conversion between the token and one of its connectors
782         if (_toToken == token)
783             return buy(_fromToken, _amount, _minReturn);
784         else if (_fromToken == token)
785             return sell(_toToken, _amount, _minReturn);
786 
787         // conversion between 2 connectors
788         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
789         return sell(_toToken, purchaseAmount, _minReturn);
790     }
791 
792     /**
793         @dev buys the token by depositing one of its connector tokens
794 
795         @param _connectorToken  connector token contract address
796         @param _depositAmount   amount to deposit (in the connector token)
797         @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
798 
799         @return buy return amount
800     */
801     function buy(IERC20Token _connectorToken, uint256 _depositAmount, uint256 _minReturn)
802         public
803         conversionsAllowed
804         validGasPrice
805         greaterThanZero(_minReturn)
806         returns (uint256)
807     {
808         uint256 amount = getPurchaseReturn(_connectorToken, _depositAmount);
809         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
810 
811         // update virtual balance if relevant
812         Connector storage connector = connectors[_connectorToken];
813         if (connector.isVirtualBalanceEnabled)
814             connector.virtualBalance = safeAdd(connector.virtualBalance, _depositAmount);
815 
816         // transfer _depositAmount funds from the caller in the connector token
817         assert(_connectorToken.transferFrom(msg.sender, this, _depositAmount));
818         // issue new funds to the caller in the smart token
819         token.issue(msg.sender, amount);
820 
821         dispatchConversionEvent(_connectorToken, _depositAmount, amount, true);
822         return amount;
823     }
824 
825     /**
826         @dev sells the token by withdrawing from one of its connector tokens
827 
828         @param _connectorToken  connector token contract address
829         @param _sellAmount      amount to sell (in the smart token)
830         @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
831 
832         @return sell return amount
833     */
834     function sell(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _minReturn)
835         public
836         conversionsAllowed
837         validGasPrice
838         greaterThanZero(_minReturn)
839         returns (uint256)
840     {
841         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
842 
843         uint256 amount = getSaleReturn(_connectorToken, _sellAmount);
844         require(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
845 
846         uint256 tokenSupply = token.totalSupply();
847         uint256 connectorBalance = getConnectorBalance(_connectorToken);
848         // ensure that the trade will only deplete the connector if the total supply is depleted as well
849         assert(amount < connectorBalance || (amount == connectorBalance && _sellAmount == tokenSupply));
850 
851         // update virtual balance if relevant
852         Connector storage connector = connectors[_connectorToken];
853         if (connector.isVirtualBalanceEnabled)
854             connector.virtualBalance = safeSub(connector.virtualBalance, amount);
855 
856         // destroy _sellAmount from the caller's balance in the smart token
857         token.destroy(msg.sender, _sellAmount);
858         // transfer funds to the caller in the connector token
859         // the transfer might fail if the actual connector balance is smaller than the virtual balance
860         assert(_connectorToken.transfer(msg.sender, amount));
861 
862         dispatchConversionEvent(_connectorToken, _sellAmount, amount, false);
863         return amount;
864     }
865 
866     /**
867         @dev converts the token to any other token in the bancor network by following a predefined conversion path
868         note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
869 
870         @param _path        conversion path, see conversion path format in the BancorQuickConverter contract
871         @param _amount      amount to convert from (in the initial source token)
872         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
873 
874         @return tokens issued in return
875     */
876     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
877         public
878         payable
879         validConversionPath(_path)
880         returns (uint256)
881     {
882         IERC20Token fromToken = _path[0];
883         IBancorQuickConverter quickConverter = extensions.quickConverter();
884 
885         // we need to transfer the source tokens from the caller to the quick converter,
886         // so it can execute the conversion on behalf of the caller
887         if (msg.value == 0) {
888             // not ETH, send the source tokens to the quick converter
889             // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
890             if (fromToken == token) {
891                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
892                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
893             }
894             else {
895                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
896                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
897             }
898         }
899 
900         // execute the conversion and pass on the ETH with the call
901         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
902     }
903 
904     // deprecated, backward compatibility
905     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
906         return convert(_fromToken, _toToken, _amount, _minReturn);
907     }
908 
909     /**
910         @dev utility, returns the expected return for selling the token for one of its connector tokens, given a total supply override
911 
912         @param _connectorToken  connector token contract address
913         @param _sellAmount      amount to sell (in the smart token)
914         @param _totalSupply     total token supply, overrides the actual token total supply when calculating the return
915 
916         @return sale return amount
917     */
918     function getSaleReturn(IERC20Token _connectorToken, uint256 _sellAmount, uint256 _totalSupply)
919         private
920         view
921         active
922         validConnector(_connectorToken)
923         greaterThanZero(_totalSupply)
924         returns (uint256)
925     {
926         Connector storage connector = connectors[_connectorToken];
927         uint256 connectorBalance = getConnectorBalance(_connectorToken);
928         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, connectorBalance, connector.weight, _sellAmount);
929 
930         // deduct the fee from the return amount
931         uint256 feeAmount = getConversionFeeAmount(amount);
932         return safeSub(amount, feeAmount);
933     }
934 
935     /**
936         @dev helper, dispatches the Conversion event
937         The function also takes the tokens' decimals into account when calculating the current price
938 
939         @param _connectorToken  connector token contract address
940         @param _amount          amount purchased/sold (in the source token)
941         @param _returnAmount    amount returned (in the target token)
942         @param isPurchase       true if it's a purchase, false if it's a sale
943     */
944     function dispatchConversionEvent(IERC20Token _connectorToken, uint256 _amount, uint256 _returnAmount, bool isPurchase) private {
945         Connector storage connector = connectors[_connectorToken];
946 
947         // calculate the new price using the simple price formula
948         // price = connector balance / (supply * weight)
949         // weight is represented in ppm, so multiplying by 1000000
950         uint256 connectorAmount = safeMul(getConnectorBalance(_connectorToken), MAX_WEIGHT);
951         uint256 tokenAmount = safeMul(token.totalSupply(), connector.weight);
952 
953         // normalize values
954         uint8 tokenDecimals = token.decimals();
955         uint8 connectorTokenDecimals = _connectorToken.decimals();
956         if (tokenDecimals != connectorTokenDecimals) {
957             if (tokenDecimals > connectorTokenDecimals)
958                 connectorAmount = safeMul(connectorAmount, 10 ** uint256(tokenDecimals - connectorTokenDecimals));
959             else
960                 tokenAmount = safeMul(tokenAmount, 10 ** uint256(connectorTokenDecimals - tokenDecimals));
961         }
962 
963         uint256 feeAmount = getConversionFeeAmount(_returnAmount);
964         // ensure that the fee is capped at 255 bits to prevent overflow when converting it to a signed int
965         assert(feeAmount <= 2 ** 255);
966 
967         if (isPurchase)
968             Conversion(_connectorToken, token, msg.sender, _amount, _returnAmount, int256(feeAmount), connectorAmount, tokenAmount);
969         else
970             Conversion(token, _connectorToken, msg.sender, _amount, _returnAmount, int256(feeAmount), tokenAmount, connectorAmount);
971     }
972 
973     /**
974         @dev fallback, buys the smart token with ETH
975         note that the purchase will use the price at the time of the purchase
976     */
977     function() payable public {
978         quickConvert(quickBuyPath, msg.value, 1);
979     }
980 }