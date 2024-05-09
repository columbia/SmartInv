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
104     Token Holder interface
105 */
106 contract ITokenHolder is IOwned {
107     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
108 }
109 
110 /*
111     EIP228 Token Converter interface
112 */
113 contract ITokenConverter {
114     function convertibleTokenCount() public constant returns (uint16);
115     function convertibleToken(uint16 _tokenIndex) public constant returns (address);
116     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256);
117     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
118     // deprecated, backward compatibility
119     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
120 }
121 
122 /*
123     Standard Token interface
124 */
125 contract IStandardToken is IOwned, IERC20Token {
126     function disableTransfers(bool _disable) public;
127     function issue(address _to, uint256 _amount) public;
128     function destroy(address _from, uint256 _amount) public;
129 }
130 
131 /*
132     Standard Converter Extensions interface
133 */
134 contract IStandardConverterExtensions {
135     function formula() public constant returns (IStandardFormula) {}
136     function gasPriceLimit() public constant returns (IStandardGasPriceLimit) {}
137     function quickConverter() public constant returns (IStandardQuickConverter) {}
138 }
139 
140 /*
141     Standard Formula interface
142 */
143 contract IStandardFormula {
144     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
145     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
146 }
147 
148 /*
149     Standard Gas Price Limit interface
150 */
151 contract IStandardGasPriceLimit {
152     function gasPrice() public constant returns (uint256) {}
153 }
154 
155 /*
156     Standard Quick Converter interface
157 */
158 contract IStandardQuickConverter {
159     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
160     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
161 }
162 
163 /*
164     Ether Token interface
165 */
166 contract IEtherToken is ITokenHolder, IERC20Token {
167     function deposit() public payable;
168     function withdraw(uint256 _amount) public;
169     function withdrawTo(address _to, uint256 _amount);
170 }
171 
172 /*
173     Provides support and utilities for contract ownership
174 */
175 contract Owned is IOwned {
176     address public owner;
177     address public newOwner;
178 
179     event OwnerUpdate(address _prevOwner, address _newOwner);
180 
181     /**
182         @dev constructor
183     */
184     function Owned() {
185         owner = msg.sender;
186     }
187 
188     // allows execution by the owner only
189     modifier ownerOnly {
190         assert(msg.sender == owner);
191         _;
192     }
193 
194     /**
195         @dev allows transferring the contract ownership
196         the new owner still needs to accept the transfer
197         can only be called by the contract owner
198 
199         @param _newOwner    new contract owner
200     */
201     function transferOwnership(address _newOwner) public ownerOnly {
202         require(_newOwner != owner);
203         newOwner = _newOwner;
204     }
205 
206     /**
207         @dev used by a new owner to accept an ownership transfer
208     */
209     function acceptOwnership() public {
210         require(msg.sender == newOwner);
211         OwnerUpdate(owner, newOwner);
212         owner = newOwner;
213         newOwner = 0x0;
214     }
215 }
216 
217 /*
218     Provides support and utilities for contract management
219 */
220 contract Managed {
221     address public manager;
222     address public newManager;
223 
224     event ManagerUpdate(address _prevManager, address _newManager);
225 
226     /**
227         @dev constructor
228     */
229     function Managed() {
230         manager = msg.sender;
231     }
232 
233     // allows execution by the manager only
234     modifier managerOnly {
235         assert(msg.sender == manager);
236         _;
237     }
238 
239     /**
240         @dev allows transferring the contract management
241         the new manager still needs to accept the transfer
242         can only be called by the contract manager
243 
244         @param _newManager    new contract manager
245     */
246     function transferManagement(address _newManager) public managerOnly {
247         require(_newManager != manager);
248         newManager = _newManager;
249     }
250 
251     /**
252         @dev used by a new manager to accept a management transfer
253     */
254     function acceptManagement() public {
255         require(msg.sender == newManager);
256         ManagerUpdate(manager, newManager);
257         manager = newManager;
258         newManager = 0x0;
259     }
260 }
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
296     The standard token controller is an upgradable part of the standard token that allows
297     more functionality as well as fixes for bugs/exploits.
298     Once it accepts ownership of the token, it becomes the token's sole controller
299     that can execute any of its functions.
300 
301     To upgrade the controller, ownership must be transferred to a new controller, along with
302     any relevant data.
303 
304     The standard token must be set on construction and cannot be changed afterwards.
305     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
306 
307     Note that the controller can transfer token ownership to a new controller that
308     doesn't allow executing any function on the token, for a trustless solution.
309     Doing that will also remove the owner's ability to upgrade the controller.
310 */
311 contract StandardTokenController is TokenHolder {
312     IStandardToken public token;   // standard token
313 
314     /**
315         @dev constructor
316     */
317     function StandardTokenController(IStandardToken _token)
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
377 /*
378     Standard Converter v0.4
379 
380     The Standard version of the token converter, allows conversion between a standard token and other ERC20 tokens and between different ERC20 tokens and themselves.
381 
382     ERC20 reserve token balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
383     the actual reserve balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
384 
385     The converter is upgradable (just like any StandardTokenController).
386 
387     WARNING: It is NOT RECOMMENDED to use the converter with Standard Tokens that have less than 8 decimal digits
388              or with very small numbers because of precision loss
389 
390 
391     Open issues:
392     - Front-running attacks are currently mitigated by the following mechanisms:
393         - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
394         - gas price limit prevents users from having control over the order of execution
395       Other potential solutions might include a commit/reveal based schemes
396     - Possibly add getters for reserve fields so that the client won't need to rely on the order in the struct
397 */
398 contract StandardConverter is ITokenConverter, StandardTokenController, Managed {
399     uint32 private constant MAX_CRR = 1000000;
400     uint32 private constant MAX_CONVERSION_FEE = 1000000;
401 
402     struct Reserve {
403         uint256 virtualBalance;         // virtual balance
404         uint32 ratio;                   // constant reserve ratio (CRR), represented in ppm, 1-1000000
405         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
406         bool isPurchaseEnabled;         // is purchase of the standard token enabled with the reserve, can be set by the owner
407         bool isSet;                     // used to tell if the mapping element is defined
408     }
409 
410     string public version = '0.4';
411     string public converterType = 'standard';
412 
413     IStandardConverterExtensions public extensions;   // standard converter extensions contract
414     IERC20Token[] public reserveTokens;             // ERC20 standard token addresses
415     IERC20Token[] public quickBuyPath;              // conversion path that's used in order to buy the token with ETH
416     mapping (address => Reserve) public reserves;   // reserve token addresses -> reserve data
417     uint32 private totalReserveRatio = 0;           // used to efficiently prevent increasing the total reserve ratio above 100%
418     uint32 public maxConversionFee = 0;             // maximum conversion fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
419     uint32 public conversionFee = 0;                // current conversion fee, represented in ppm, 0...maxConversionFee
420     bool public conversionsEnabled = true;          // true if token conversions is enabled, false if not
421 
422     // triggered when a conversion between two tokens occurs (TokenConverter event)
423     event Conversion(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
424                      uint256 _currentPriceN, uint256 _currentPriceD);
425 
426     /**
427         @dev constructor
428 
429         @param  _token              standard token governed by the converter
430         @param  _extensions         address of a standard converter extensions contract
431         @param  _maxConversionFee   maximum conversion fee, represented in ppm
432         @param  _reserveToken       optional, initial reserve, allows defining the first reserve at deployment time
433         @param  _reserveRatio       optional, ratio for the initial reserve
434     */
435     function StandardConverter(IStandardToken _token, IStandardConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _reserveToken, uint32 _reserveRatio)
436         StandardTokenController(_token)
437         validAddress(_extensions)
438         validMaxConversionFee(_maxConversionFee)
439     {
440         extensions = _extensions;
441         maxConversionFee = _maxConversionFee;
442 
443         if (address(_reserveToken) != 0x0)
444             addReserve(_reserveToken, _reserveRatio, false);
445     }
446 
447     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
448     modifier validReserve(IERC20Token _address) {
449         require(reserves[_address].isSet);
450         _;
451     }
452 
453     // validates a token address - verifies that the address belongs to one of the convertible tokens
454     modifier validToken(IERC20Token _address) {
455         require(_address == token || reserves[_address].isSet);
456         _;
457     }
458 
459     // verifies that the gas price is lower than the universal limit
460     modifier validGasPrice() {
461         assert(tx.gasprice <= extensions.gasPriceLimit().gasPrice());
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
477     // validates reserve ratio range
478     modifier validReserveRatio(uint32 _ratio) {
479         require(_ratio > 0 && _ratio <= MAX_CRR);
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
495     /**
496         @dev returns the number of reserve tokens defined
497 
498         @return number of reserve tokens
499     */
500     function reserveTokenCount() public constant returns (uint16) {
501         return uint16(reserveTokens.length);
502     }
503 
504     /**
505         @dev returns the number of convertible tokens supported by the contract
506         note that the number of convertible tokens is the number of reserve token, plus 1 (that represents the standard token)
507 
508         @return number of convertible tokens
509     */
510     function convertibleTokenCount() public constant returns (uint16) {
511         return reserveTokenCount() + 1;
512     }
513 
514     /**
515         @dev given a convertible token index, returns its contract address
516 
517         @param _tokenIndex  convertible token index
518 
519         @return convertible token address
520     */
521     function convertibleToken(uint16 _tokenIndex) public constant returns (address) {
522         if (_tokenIndex == 0)
523             return token;
524         return reserveTokens[_tokenIndex - 1];
525     }
526 
527     /*
528         @dev allows the owner to update the extensions contract address
529 
530         @param _extensions    address of a standard converter extensions contract
531     */
532     function setExtensions(IStandardConverterExtensions _extensions)
533         public
534         ownerOnly
535         validAddress(_extensions)
536         notThis(_extensions)
537     {
538         extensions = _extensions;
539     }
540 
541     /*
542         @dev allows the manager to update the quick buy path
543 
544         @param _path    new quick buy path, see conversion path format in the StandardQuickConverter contract
545     */
546     function setQuickBuyPath(IERC20Token[] _path)
547         public
548         ownerOnly
549         validConversionPath(_path)
550     {
551         quickBuyPath = _path;
552     }
553 
554     /*
555         @dev allows the manager to clear the quick buy path
556     */
557     function clearQuickBuyPath() public ownerOnly {
558         quickBuyPath.length = 0;
559     }
560 
561     /**
562         @dev returns the length of the quick buy path array
563 
564         @return quick buy path length
565     */
566     function getQuickBuyPathLength() public constant returns (uint256) {
567         return quickBuyPath.length;
568     }
569 
570     /**
571         @dev disables the entire conversion functionality
572         this is a safety mechanism in case of a emergency
573         can only be called by the manager
574 
575         @param _disable true to disable conversions, false to re-enable them
576     */
577     function disableConversions(bool _disable) public managerOnly {
578         conversionsEnabled = !_disable;
579     }
580 
581     /**
582         @dev updates the current conversion fee
583         can only be called by the manager
584 
585         @param _conversionFee new conversion fee, represented in ppm
586     */
587     function setConversionFee(uint32 _conversionFee)
588         public
589         managerOnly
590         validConversionFee(_conversionFee)
591     {
592         conversionFee = _conversionFee;
593     }
594 
595     /*
596         @dev returns the conversion fee amount for a given return amount
597 
598         @return conversion fee amount
599     */
600     function getConversionFeeAmount(uint256 _amount) public constant returns (uint256) {
601         return safeMul(_amount, conversionFee) / MAX_CONVERSION_FEE;
602     }
603 
604     /**
605         @dev defines a new reserve for the token
606         can only be called by the owner while the converter is inactive
607 
608         @param _token                  address of the reserve token
609         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
610         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
611     */
612     function addReserve(IERC20Token _token, uint32 _ratio, bool _enableVirtualBalance)
613         public
614         ownerOnly
615         inactive
616         validAddress(_token)
617         notThis(_token)
618         validReserveRatio(_ratio)
619     {
620         require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= MAX_CRR); // validate input
621 
622         reserves[_token].virtualBalance = 0;
623         reserves[_token].ratio = _ratio;
624         reserves[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
625         reserves[_token].isPurchaseEnabled = true;
626         reserves[_token].isSet = true;
627         reserveTokens.push(_token);
628         totalReserveRatio += _ratio;
629     }
630 
631     /**
632         @dev updates one of the token reserves
633         can only be called by the owner
634 
635         @param _reserveToken           address of the reserve token
636         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
637         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
638         @param _virtualBalance         new reserve's virtual balance
639     */
640     function updateReserve(IERC20Token _reserveToken, uint32 _ratio, bool _enableVirtualBalance, uint256 _virtualBalance)
641         public
642         ownerOnly
643         validReserve(_reserveToken)
644         validReserveRatio(_ratio)
645     {
646         Reserve storage reserve = reserves[_reserveToken];
647         require(totalReserveRatio - reserve.ratio + _ratio <= MAX_CRR); // validate input
648 
649         totalReserveRatio = totalReserveRatio - reserve.ratio + _ratio;
650         reserve.ratio = _ratio;
651         reserve.isVirtualBalanceEnabled = _enableVirtualBalance;
652         reserve.virtualBalance = _virtualBalance;
653     }
654 
655     /**
656         @dev disables purchasing with the given reserve token in case the reserve token got compromised
657         can only be called by the owner
658         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
659 
660         @param _reserveToken    reserve token contract address
661         @param _disable         true to disable the token, false to re-enable it
662     */
663     function disableReservePurchases(IERC20Token _reserveToken, bool _disable)
664         public
665         ownerOnly
666         validReserve(_reserveToken)
667     {
668         reserves[_reserveToken].isPurchaseEnabled = !_disable;
669     }
670 
671     /**
672         @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
673 
674         @param _reserveToken    reserve token contract address
675 
676         @return reserve balance
677     */
678     function getReserveBalance(IERC20Token _reserveToken)
679         public
680         constant
681         validReserve(_reserveToken)
682         returns (uint256)
683     {
684         Reserve storage reserve = reserves[_reserveToken];
685         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
686     }
687 
688     /**
689         @dev returns the expected return for converting a specific amount of _fromToken to _toToken
690 
691         @param _fromToken  ERC20 token to convert from
692         @param _toToken    ERC20 token to convert to
693         @param _amount     amount to convert, in fromToken
694 
695         @return expected conversion return amount
696     */
697     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256) {
698         require(_fromToken != _toToken); // validate input
699 
700         // conversion between the token and one of its reserves
701         if (_toToken == token)
702             return getPurchaseReturn(_fromToken, _amount);
703         else if (_fromToken == token)
704             return getSaleReturn(_toToken, _amount);
705 
706         // conversion between 2 reserves
707         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
708         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
709     }
710 
711     /**
712         @dev returns the expected return for buying the token for a reserve token
713 
714         @param _reserveToken   reserve token contract address
715         @param _depositAmount  amount to deposit (in the reserve token)
716 
717         @return expected purchase return amount
718     */
719     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
720         public
721         constant
722         active
723         validReserve(_reserveToken)
724         returns (uint256)
725     {
726         Reserve storage reserve = reserves[_reserveToken];
727         require(reserve.isPurchaseEnabled); // validate input
728 
729         uint256 tokenSupply = token.totalSupply();
730         uint256 reserveBalance = getReserveBalance(_reserveToken);
731         uint256 amount = extensions.formula().calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
732 
733         // deduct the fee from the return amount
734         uint256 feeAmount = getConversionFeeAmount(amount);
735         return safeSub(amount, feeAmount);
736     }
737 
738     /**
739         @dev returns the expected return for selling the token for one of its reserve tokens
740 
741         @param _reserveToken   reserve token contract address
742         @param _sellAmount     amount to sell (in the standard token)
743 
744         @return expected sale return amount
745     */
746     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount) public constant returns (uint256) {
747         return getSaleReturn(_reserveToken, _sellAmount, token.totalSupply());
748     }
749 
750     /**
751         @dev converts a specific amount of _fromToken to _toToken
752 
753         @param _fromToken  ERC20 token to convert from
754         @param _toToken    ERC20 token to convert to
755         @param _amount     amount to convert, in fromToken
756         @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
757 
758         @return conversion return amount
759     */
760     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
761         require(_fromToken != _toToken); // validate input
762 
763         // conversion between the token and one of its reserves
764         if (_toToken == token)
765             return buy(_fromToken, _amount, _minReturn);
766         else if (_fromToken == token)
767             return sell(_toToken, _amount, _minReturn);
768 
769         // conversion between 2 reserves
770         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
771         return sell(_toToken, purchaseAmount, _minReturn);
772     }
773 
774     /**
775         @dev buys the token by depositing one of its reserve tokens
776 
777         @param _reserveToken   reserve token contract address
778         @param _depositAmount  amount to deposit (in the reserve token)
779         @param _minReturn      if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
780 
781         @return buy return amount
782     */
783     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn)
784         public
785         conversionsAllowed
786         validGasPrice
787         greaterThanZero(_minReturn)
788         returns (uint256)
789     {
790         uint256 amount = getPurchaseReturn(_reserveToken, _depositAmount);
791         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
792 
793         // update virtual balance if relevant
794         Reserve storage reserve = reserves[_reserveToken];
795         if (reserve.isVirtualBalanceEnabled)
796             reserve.virtualBalance = safeAdd(reserve.virtualBalance, _depositAmount);
797 
798         // transfer _depositAmount funds from the caller in the reserve token
799         assert(_reserveToken.transferFrom(msg.sender, this, _depositAmount));
800         // issue new funds to the caller in the standard token
801         token.issue(msg.sender, amount);
802 
803         // calculate the new price using the simple price formula
804         // price = reserve balance / (supply * CRR)
805         // CRR is represented in ppm, so multiplying by 1000000
806         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
807         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
808         Conversion(_reserveToken, token, msg.sender, _depositAmount, amount, reserveAmount, tokenAmount);
809         return amount;
810     }
811 
812     /**
813         @dev sells the token by withdrawing from one of its reserve tokens
814 
815         @param _reserveToken   reserve token contract address
816         @param _sellAmount     amount to sell (in the standard token)
817         @param _minReturn      if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
818 
819         @return sell return amount
820     */
821     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn)
822         public
823         conversionsAllowed
824         validGasPrice
825         greaterThanZero(_minReturn)
826         returns (uint256)
827     {
828         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
829 
830         uint256 amount = getSaleReturn(_reserveToken, _sellAmount);
831         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
832 
833         uint256 tokenSupply = token.totalSupply();
834         uint256 reserveBalance = getReserveBalance(_reserveToken);
835         // ensure that the trade will only deplete the reserve if the total supply is depleted as well
836         assert(amount < reserveBalance || (amount == reserveBalance && _sellAmount == tokenSupply));
837 
838         // update virtual balance if relevant
839         Reserve storage reserve = reserves[_reserveToken];
840         if (reserve.isVirtualBalanceEnabled)
841             reserve.virtualBalance = safeSub(reserve.virtualBalance, amount);
842 
843         // destroy _sellAmount from the caller's balance in the standard token
844         token.destroy(msg.sender, _sellAmount);
845         // transfer funds to the caller in the reserve token
846         // the transfer might fail if the actual reserve balance is smaller than the virtual balance
847         assert(_reserveToken.transfer(msg.sender, amount));
848 
849         // calculate the new price using the simple price formula
850         // price = reserve balance / (supply * CRR)
851         // CRR is represented in ppm, so multiplying by 1000000
852         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
853         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
854         Conversion(token, _reserveToken, msg.sender, _sellAmount, amount, tokenAmount, reserveAmount);
855         return amount;
856     }
857 
858     /**
859         @dev converts the token to any other token in the standard network by following a predefined conversion path
860         note that when converting from an ERC20 token (as opposed to a standard token), allowance must be set beforehand
861 
862         @param _path        conversion path, see conversion path format in the StandardQuickConverter contract
863         @param _amount      amount to convert from (in the initial source token)
864         @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
865 
866         @return tokens issued in return
867     */
868     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
869         public
870         payable
871         validConversionPath(_path)
872         returns (uint256)
873     {
874         IERC20Token fromToken = _path[0];
875         IStandardQuickConverter quickConverter = extensions.quickConverter();
876 
877         // we need to transfer the source tokens from the caller to the quick converter,
878         // so it can execute the conversion on behalf of the caller
879         if (msg.value == 0) {
880             // not ETH, send the source tokens to the quick converter
881             // if the token is the standard token, no allowance is required - destroy the tokens from the caller and issue them to the quick converter
882             if (fromToken == token) {
883                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the standard token
884                 token.issue(quickConverter, _amount); // issue _amount new tokens to the quick converter
885             }
886             else {
887                 // otherwise, we assume we already have allowance, transfer the tokens directly to the quick converter
888                 assert(fromToken.transferFrom(msg.sender, quickConverter, _amount));
889             }
890         }
891 
892         // execute the conversion and pass on the ETH with the call
893         return quickConverter.convertFor.value(msg.value)(_path, _amount, _minReturn, msg.sender);
894     }
895 
896     // deprecated, backward compatibility
897     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
898         return convert(_fromToken, _toToken, _amount, _minReturn);
899     }
900 
901     // deprecated, backward compatibility
902     function quickChange(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
903         return quickConvert(_path, _amount, _minReturn);
904     }
905 
906     // deprecated, backward compatibility
907     function quickBuy(uint256 _minReturn) public payable returns (uint256) {
908         return quickConvert(quickBuyPath, msg.value, _minReturn);
909     }
910 
911     // deprecated, backward compatibility
912     function hasQuickBuyEtherToken() public constant returns (bool) {
913         return quickBuyPath.length > 0;
914     }
915 
916     // deprecated, backward compatibility
917     function getQuickBuyEtherToken() public constant returns (IEtherToken) {
918         assert(quickBuyPath.length > 0);
919         return IEtherToken(quickBuyPath[0]);
920     }
921 
922     /**
923         @dev utility, returns the expected return for selling the token for one of its reserve tokens, given a total supply override
924 
925         @param _reserveToken   reserve token contract address
926         @param _sellAmount     amount to sell (in the standard token)
927         @param _totalSupply    total token supply, overrides the actual token total supply when calculating the return
928 
929         @return sale return amount
930     */
931     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _totalSupply)
932         private
933         constant
934         active
935         validReserve(_reserveToken)
936         greaterThanZero(_totalSupply)
937         returns (uint256)
938     {
939         Reserve storage reserve = reserves[_reserveToken];
940         uint256 reserveBalance = getReserveBalance(_reserveToken);
941         uint256 amount = extensions.formula().calculateSaleReturn(_totalSupply, reserveBalance, reserve.ratio, _sellAmount);
942 
943         // deduct the fee from the return amount
944         uint256 feeAmount = getConversionFeeAmount(amount);
945         return safeSub(amount, feeAmount);
946     }
947 
948     /**
949         @dev fallback, buys the standard token with ETH
950         note that the purchase will use the price at the time of the purchase
951     */
952     function() payable {
953         quickConvert(quickBuyPath, msg.value, 1);
954     }
955 }