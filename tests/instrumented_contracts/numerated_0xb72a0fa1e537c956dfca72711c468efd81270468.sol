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
80     function owner() public constant returns (address owner) { owner; }
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
177     Token Holder interface
178 */
179 contract ITokenHolder is IOwned {
180     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
181 }
182 
183 /*
184     We consider every contract to be a 'token holder' since it's currently not possible
185     for a contract to deny receiving tokens.
186 
187     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
188     the owner to send tokens that were sent to the contract by mistake back to their sender.
189 */
190 contract TokenHolder is ITokenHolder, Owned, Utils {
191     /**
192         @dev constructor
193     */
194     function TokenHolder() {
195     }
196 
197     /**
198         @dev withdraws tokens held by the contract and sends them to an account
199         can only be called by the owner
200 
201         @param _token   ERC20 token contract address
202         @param _to      account to receive the new amount
203         @param _amount  amount to withdraw
204     */
205     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
206         public
207         ownerOnly
208         validAddress(_token)
209         validAddress(_to)
210         notThis(_to)
211     {
212         assert(_token.transfer(_to, _amount));
213     }
214 }
215 
216 /*
217     The smart token controller is an upgradable part of the smart token that allows
218     more functionality as well as fixes for bugs/exploits.
219     Once it accepts ownership of the token, it becomes the token's sole controller
220     that can execute any of its functions.
221 
222     To upgrade the controller, ownership must be transferred to a new controller, along with
223     any relevant data.
224 
225     The smart token must be set on construction and cannot be changed afterwards.
226     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
227 
228     Note that the controller can transfer token ownership to a new controller that
229     doesn't allow executing any function on the token, for a trustless solution.
230     Doing that will also remove the owner's ability to upgrade the controller.
231 */
232 contract SmartTokenController is TokenHolder {
233     ISmartToken public token;   // smart token
234 
235     /**
236         @dev constructor
237     */
238     function SmartTokenController(ISmartToken _token)
239         validAddress(_token)
240     {
241         token = _token;
242     }
243 
244     // ensures that the controller is the token's owner
245     modifier active() {
246         assert(token.owner() == address(this));
247         _;
248     }
249 
250     // ensures that the controller is not the token's owner
251     modifier inactive() {
252         assert(token.owner() != address(this));
253         _;
254     }
255 
256     /**
257         @dev allows transferring the token ownership
258         the new owner still need to accept the transfer
259         can only be called by the contract owner
260 
261         @param _newOwner    new token owner
262     */
263     function transferTokenOwnership(address _newOwner) public ownerOnly {
264         token.transferOwnership(_newOwner);
265     }
266 
267     /**
268         @dev used by a new owner to accept a token ownership transfer
269         can only be called by the contract owner
270     */
271     function acceptTokenOwnership() public ownerOnly {
272         token.acceptOwnership();
273     }
274 
275     /**
276         @dev disables/enables token transfers
277         can only be called by the contract owner
278 
279         @param _disable    true to disable transfers, false to enable them
280     */
281     function disableTokenTransfers(bool _disable) public ownerOnly {
282         token.disableTransfers(_disable);
283     }
284 
285     /**
286         @dev withdraws tokens held by the token and sends them to an account
287         can only be called by the owner
288 
289         @param _token   ERC20 token contract address
290         @param _to      account to receive the new amount
291         @param _amount  amount to withdraw
292     */
293     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
294         token.withdrawTokens(_token, _to, _amount);
295     }
296 }
297 
298 /*
299     ERC20 Standard Token interface
300 */
301 contract IERC20Token {
302     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
303     function name() public constant returns (string name) { name; }
304     function symbol() public constant returns (string symbol) { symbol; }
305     function decimals() public constant returns (uint8 decimals) { decimals; }
306     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
307     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
308     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
309 
310     function transfer(address _to, uint256 _value) public returns (bool success);
311     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
312     function approve(address _spender, uint256 _value) public returns (bool success);
313 }
314 
315 /*
316     Ether Token interface
317 */
318 contract IEtherToken is ITokenHolder, IERC20Token {
319     function deposit() public payable;
320     function withdraw(uint256 _amount) public;
321     function withdrawTo(address _to, uint256 _amount);
322 }
323 
324 /*
325     Smart Token interface
326 */
327 contract ISmartToken is ITokenHolder, IERC20Token {
328     function disableTransfers(bool _disable) public;
329     function issue(address _to, uint256 _amount) public;
330     function destroy(address _from, uint256 _amount) public;
331 }
332 
333 /*
334     Bancor Formula interface
335 */
336 contract IBancorFormula {
337     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
338     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
339 }
340 
341 /*
342     EIP228 Token Changer interface
343 */
344 contract ITokenChanger {
345     function changeableTokenCount() public constant returns (uint16 count);
346     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress);
347     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount);
348     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount);
349 }
350 
351 /*
352     Open issues:
353     - Add miner front-running attack protection. The issue is somewhat mitigated by the use of _minReturn when changing
354     - Possibly add getters for reserve fields so that the client won't need to rely on the order in the struct
355 */
356 
357 /*
358     Bancor Changer v0.2
359 
360     The Bancor version of the token changer, allows changing between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
361 
362     ERC20 reserve token balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
363     the actual reserve balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
364 
365     The changer is upgradable (just like any SmartTokenController).
366 
367     A note on change paths -
368     Change path is a data structure that's used when changing a token to another token in the bancor network
369     when the change cannot necessarily be done by single changer and might require multiple 'hops'.
370     The path defines which changers should be used and what kind of change should be done in each step.
371 
372     The path format doesn't include complex structure and instead, it is represented by a single array
373     in which each 'hop' is represented by a 2-tuple - smart token & to token.
374     In addition, the first element is always the source token.
375     The smart token is only used as a pointer to a changer (since changer addresses are more likely to change).
376 
377     Format:
378     [source token, smart token, to token, smart token, to token...]
379 
380 
381     WARNING: It is NOT RECOMMENDED to use the changer with Smart Tokens that have less than 8 decimal digits
382              or with very small numbers because of precision loss
383 */
384 contract BancorChanger is ITokenChanger, SmartTokenController, Managed {
385     uint32 private constant MAX_CRR = 1000000;
386     uint32 private constant MAX_CHANGE_FEE = 1000000;
387 
388     struct Reserve {
389         uint256 virtualBalance;         // virtual balance
390         uint32 ratio;                   // constant reserve ratio (CRR), represented in ppm, 1-1000000
391         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
392         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the reserve, can be set by the owner
393         bool isSet;                     // used to tell if the mapping element is defined
394     }
395 
396     string public version = '0.2';
397     string public changerType = 'bancor';
398 
399     IBancorFormula public formula;                  // bancor calculation formula contract
400     IERC20Token[] public reserveTokens;             // ERC20 standard token addresses
401     IERC20Token[] public quickBuyPath;              // change path that's used in order to buy the token with ETH
402     mapping (address => Reserve) public reserves;   // reserve token addresses -> reserve data
403     uint32 private totalReserveRatio = 0;           // used to efficiently prevent increasing the total reserve ratio above 100%
404     uint32 public maxChangeFee = 0;                 // maximum change fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
405     uint32 public changeFee = 0;                    // current change fee, represented in ppm, 0...maxChangeFee
406     bool public changingEnabled = true;             // true if token changing is enabled, false if not
407 
408     // triggered when a change between two tokens occurs (TokenChanger event)
409     event Change(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
410                  uint256 _currentPriceN, uint256 _currentPriceD);
411 
412     /**
413         @dev constructor
414 
415         @param  _token          smart token governed by the changer
416         @param  _formula        address of a bancor formula contract
417         @param  _maxChangeFee   maximum change fee, represented in ppm
418         @param  _reserveToken   optional, initial reserve, allows defining the first reserve at deployment time
419         @param  _reserveRatio   optional, ratio for the initial reserve
420     */
421     function BancorChanger(ISmartToken _token, IBancorFormula _formula, uint32 _maxChangeFee, IERC20Token _reserveToken, uint32 _reserveRatio)
422         SmartTokenController(_token)
423         validAddress(_formula)
424         validMaxChangeFee(_maxChangeFee)
425     {
426         formula = _formula;
427         maxChangeFee = _maxChangeFee;
428 
429         if (address(_reserveToken) != 0x0)
430             addReserve(_reserveToken, _reserveRatio, false);
431     }
432 
433     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
434     modifier validReserve(IERC20Token _address) {
435         require(reserves[_address].isSet);
436         _;
437     }
438 
439     // validates a token address - verifies that the address belongs to one of the changeable tokens
440     modifier validToken(IERC20Token _address) {
441         require(_address == token || reserves[_address].isSet);
442         _;
443     }
444 
445     // validates maximum change fee
446     modifier validMaxChangeFee(uint32 _changeFee) {
447         require(_changeFee >= 0 && _changeFee <= MAX_CHANGE_FEE);
448         _;
449     }
450 
451     // validates change fee
452     modifier validChangeFee(uint32 _changeFee) {
453         require(_changeFee >= 0 && _changeFee <= maxChangeFee);
454         _;
455     }
456 
457     // validates reserve ratio range
458     modifier validReserveRatio(uint32 _ratio) {
459         require(_ratio > 0 && _ratio <= MAX_CRR);
460         _;
461     }
462 
463     // validates a change path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
464     modifier validChangePath(IERC20Token[] _path) {
465         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
466         _;
467     }
468 
469     // allows execution only when changing isn't disabled
470     modifier changingAllowed {
471         assert(changingEnabled);
472         _;
473     }
474 
475     /**
476         @dev returns the number of reserve tokens defined
477 
478         @return number of reserve tokens
479     */
480     function reserveTokenCount() public constant returns (uint16 count) {
481         return uint16(reserveTokens.length);
482     }
483 
484     /**
485         @dev returns the number of changeable tokens supported by the contract
486         note that the number of changeable tokens is the number of reserve token, plus 1 (that represents the smart token)
487 
488         @return number of changeable tokens
489     */
490     function changeableTokenCount() public constant returns (uint16 count) {
491         return reserveTokenCount() + 1;
492     }
493 
494     /**
495         @dev given a changeable token index, returns the changeable token contract address
496 
497         @param _tokenIndex  changeable token index
498 
499         @return number of changeable tokens
500     */
501     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress) {
502         if (_tokenIndex == 0)
503             return token;
504         return reserveTokens[_tokenIndex - 1];
505     }
506 
507     /*
508         @dev allows the owner to update the formula contract address
509 
510         @param _formula    address of a bancor formula contract
511     */
512     function setFormula(IBancorFormula _formula)
513         public
514         ownerOnly
515         validAddress(_formula)
516         notThis(_formula)
517     {
518         formula = _formula;
519     }
520 
521     /*
522         @dev allows the manager to update the quick buy path
523 
524         @param _path    new quick buy path, see change path format above
525     */
526     function setQuickBuyPath(IERC20Token[] _path)
527         public
528         ownerOnly
529         validChangePath(_path)
530     {
531         quickBuyPath = _path;
532     }
533 
534     /*
535         @dev allows the manager to clear the quick buy path
536     */
537     function clearQuickBuyPath() public ownerOnly {
538         quickBuyPath.length = 0;
539     }
540 
541     /**
542         @dev returns the length of the quick buy path array
543 
544         @return quick buy path length
545     */
546     function getQuickBuyPathLength() public constant returns (uint256 length) {
547         return quickBuyPath.length;
548     }
549 
550     /**
551         @dev returns true if ether token exists in the quick buy path, false if not
552         note that there should always be one in the quick buy path, if one is set
553 
554         @return true if ether token exists, false if not
555     */
556     function hasQuickBuyEtherToken() public constant returns (bool) {
557         return quickBuyPath.length > 0;
558     }
559 
560     /**
561         @dev returns the address of the ether token used by the quick buy functionality
562         note that it should always be the first element in the quick buy path, if one is set
563 
564         @return ether token address
565     */
566     function getQuickBuyEtherToken() public constant returns (IEtherToken etherToken) {
567         assert(quickBuyPath.length > 0);
568         return IEtherToken(quickBuyPath[0]);
569     }
570 
571     /**
572         @dev disables the entire change functionality
573         this is a safety mechanism in case of a emergency
574         can only be called by the manager
575 
576         @param _disable true to disable changing, false to re-enable it
577     */
578     function disableChanging(bool _disable) public managerOnly {
579         changingEnabled = !_disable;
580     }
581 
582     /**
583         @dev updates the current change fee
584         can only be called by the manager
585 
586         @param _changeFee new change fee, represented in ppm
587     */
588     function setChangeFee(uint32 _changeFee)
589         public
590         managerOnly
591         validChangeFee(_changeFee)
592     {
593         changeFee = _changeFee;
594     }
595 
596     /*
597         @dev returns the change fee amount for a given return amount
598 
599         @return change fee amount
600     */
601     function getChangeFeeAmount(uint256 _amount) public constant returns (uint256 feeAmount) {
602         return safeMul(_amount, changeFee) / MAX_CHANGE_FEE;
603     }
604 
605     /**
606         @dev defines a new reserve for the token
607         can only be called by the owner while the changer is inactive
608 
609         @param _token                  address of the reserve token
610         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
611         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
612     */
613     function addReserve(IERC20Token _token, uint32 _ratio, bool _enableVirtualBalance)
614         public
615         ownerOnly
616         inactive
617         validAddress(_token)
618         notThis(_token)
619         validReserveRatio(_ratio)
620     {
621         require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= MAX_CRR); // validate input
622 
623         reserves[_token].virtualBalance = 0;
624         reserves[_token].ratio = _ratio;
625         reserves[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
626         reserves[_token].isPurchaseEnabled = true;
627         reserves[_token].isSet = true;
628         reserveTokens.push(_token);
629         totalReserveRatio += _ratio;
630     }
631 
632     /**
633         @dev updates one of the token reserves
634         can only be called by the owner
635 
636         @param _reserveToken           address of the reserve token
637         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
638         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
639         @param _virtualBalance         new reserve's virtual balance
640     */
641     function updateReserve(IERC20Token _reserveToken, uint32 _ratio, bool _enableVirtualBalance, uint256 _virtualBalance)
642         public
643         ownerOnly
644         validReserve(_reserveToken)
645         validReserveRatio(_ratio)
646     {
647         Reserve storage reserve = reserves[_reserveToken];
648         require(totalReserveRatio - reserve.ratio + _ratio <= MAX_CRR); // validate input
649 
650         totalReserveRatio = totalReserveRatio - reserve.ratio + _ratio;
651         reserve.ratio = _ratio;
652         reserve.isVirtualBalanceEnabled = _enableVirtualBalance;
653         reserve.virtualBalance = _virtualBalance;
654     }
655 
656     /**
657         @dev disables purchasing with the given reserve token in case the reserve token got compromised
658         can only be called by the owner
659         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
660 
661         @param _reserveToken    reserve token contract address
662         @param _disable         true to disable the token, false to re-enable it
663     */
664     function disableReservePurchases(IERC20Token _reserveToken, bool _disable)
665         public
666         ownerOnly
667         validReserve(_reserveToken)
668     {
669         reserves[_reserveToken].isPurchaseEnabled = !_disable;
670     }
671 
672     /**
673         @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
674 
675         @param _reserveToken    reserve token contract address
676 
677         @return reserve balance
678     */
679     function getReserveBalance(IERC20Token _reserveToken)
680         public
681         constant
682         validReserve(_reserveToken)
683         returns (uint256 balance)
684     {
685         Reserve storage reserve = reserves[_reserveToken];
686         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
687     }
688 
689     /**
690         @dev returns the expected return for changing a specific amount of _fromToken to _toToken
691 
692         @param _fromToken  ERC20 token to change from
693         @param _toToken    ERC20 token to change to
694         @param _amount     amount to change, in fromToken
695 
696         @return expected change return amount
697     */
698     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount) {
699         require(_fromToken != _toToken); // validate input
700 
701         // change between the token and one of its reserves
702         if (_toToken == token)
703             return getPurchaseReturn(_fromToken, _amount);
704         else if (_fromToken == token)
705             return getSaleReturn(_toToken, _amount);
706 
707         // change between 2 reserves
708         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
709         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
710     }
711 
712     /**
713         @dev returns the expected return for buying the token for a reserve token
714 
715         @param _reserveToken   reserve token contract address
716         @param _depositAmount  amount to deposit (in the reserve token)
717 
718         @return expected purchase return amount
719     */
720     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
721         public
722         constant
723         active
724         validReserve(_reserveToken)
725         returns (uint256 amount)
726     {
727         Reserve storage reserve = reserves[_reserveToken];
728         require(reserve.isPurchaseEnabled); // validate input
729 
730         uint256 tokenSupply = token.totalSupply();
731         uint256 reserveBalance = getReserveBalance(_reserveToken);
732         amount = formula.calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
733 
734         // deduct the fee from the return amount
735         uint256 feeAmount = getChangeFeeAmount(amount);
736         return safeSub(amount, feeAmount);
737     }
738 
739     /**
740         @dev returns the expected return for selling the token for one of its reserve tokens
741 
742         @param _reserveToken   reserve token contract address
743         @param _sellAmount     amount to sell (in the smart token)
744 
745         @return expected sale return amount
746     */
747     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount) public constant returns (uint256 amount) {
748         return getSaleReturn(_reserveToken, _sellAmount, token.totalSupply());
749     }
750 
751     /**
752         @dev changes a specific amount of _fromToken to _toToken
753 
754         @param _fromToken  ERC20 token to change from
755         @param _toToken    ERC20 token to change to
756         @param _amount     amount to change, in fromToken
757         @param _minReturn  if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
758 
759         @return change return amount
760     */
761     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount) {
762         require(_fromToken != _toToken); // validate input
763 
764         // change between the token and one of its reserves
765         if (_toToken == token)
766             return buy(_fromToken, _amount, _minReturn);
767         else if (_fromToken == token)
768             return sell(_toToken, _amount, _minReturn);
769 
770         // change between 2 reserves
771         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
772         return sell(_toToken, purchaseAmount, _minReturn);
773     }
774 
775     /**
776         @dev buys the token by depositing one of its reserve tokens
777 
778         @param _reserveToken   reserve token contract address
779         @param _depositAmount  amount to deposit (in the reserve token)
780         @param _minReturn      if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
781 
782         @return buy return amount
783     */
784     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn)
785         public
786         changingAllowed
787         greaterThanZero(_minReturn)
788         returns (uint256 amount)
789     {
790         amount = getPurchaseReturn(_reserveToken, _depositAmount);
791         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
792 
793         // update virtual balance if relevant
794         Reserve storage reserve = reserves[_reserveToken];
795         if (reserve.isVirtualBalanceEnabled)
796             reserve.virtualBalance = safeAdd(reserve.virtualBalance, _depositAmount);
797 
798         assert(_reserveToken.transferFrom(msg.sender, this, _depositAmount)); // transfer _depositAmount funds from the caller in the reserve token
799         token.issue(msg.sender, amount); // issue new funds to the caller in the smart token
800 
801         // calculate the new price using the simple price formula
802         // price = reserve balance / (supply * CRR)
803         // CRR is represented in ppm, so multiplying by 1000000
804         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
805         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
806         Change(_reserveToken, token, msg.sender, _depositAmount, amount, reserveAmount, tokenAmount);
807         return amount;
808     }
809 
810     /**
811         @dev sells the token by withdrawing from one of its reserve tokens
812 
813         @param _reserveToken   reserve token contract address
814         @param _sellAmount     amount to sell (in the smart token)
815         @param _minReturn      if the change results in an amount smaller the minimum return - it is cancelled, must be nonzero
816 
817         @return sell return amount
818     */
819     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn)
820         public
821         changingAllowed
822         greaterThanZero(_minReturn)
823         returns (uint256 amount)
824     {
825         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
826 
827         amount = getSaleReturn(_reserveToken, _sellAmount);
828         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
829 
830         uint256 tokenSupply = token.totalSupply();
831         uint256 reserveBalance = getReserveBalance(_reserveToken);
832         // ensure that the trade will only deplete the reserve if the total supply is depleted as well
833         assert(amount < reserveBalance || (amount == reserveBalance && _sellAmount == tokenSupply));
834 
835         // update virtual balance if relevant
836         Reserve storage reserve = reserves[_reserveToken];
837         if (reserve.isVirtualBalanceEnabled)
838             reserve.virtualBalance = safeSub(reserve.virtualBalance, amount);
839 
840         token.destroy(msg.sender, _sellAmount); // destroy _sellAmount from the caller's balance in the smart token
841         assert(_reserveToken.transfer(msg.sender, amount)); // transfer funds to the caller in the reserve token
842                                                             // note that it might fail if the actual reserve balance is smaller than the virtual balance
843         // calculate the new price using the simple price formula
844         // price = reserve balance / (supply * CRR)
845         // CRR is represented in ppm, so multiplying by 1000000
846         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
847         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
848         Change(token, _reserveToken, msg.sender, _sellAmount, amount, tokenAmount, reserveAmount);
849         return amount;
850     }
851 
852     /**
853         @dev changes the token to any other token in the bancor network by following a predefined change path
854         note that when changing from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
855 
856         @param _path        change path, see change path format above
857         @param _amount      amount to change from (in the initial source token)
858         @param _minReturn   if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
859 
860         @return tokens issued in return
861     */
862     function quickChange(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
863         public
864         validChangePath(_path)
865         returns (uint256 amount)
866     {
867         // we need to transfer the tokens from the caller to the local contract before we
868         // follow the change path, to allow it to execute the change on behalf of the caller
869         IERC20Token fromToken = _path[0];
870         claimTokens(fromToken, msg.sender, _amount);
871 
872         ISmartToken smartToken;
873         IERC20Token toToken;
874         BancorChanger changer;
875         uint256 pathLength = _path.length;
876 
877         // iterate over the change path
878         for (uint256 i = 1; i < pathLength; i += 2) {
879             smartToken = ISmartToken(_path[i]);
880             toToken = _path[i + 1];
881             changer = BancorChanger(smartToken.owner());
882 
883             // if the smart token isn't the source (from token), the changer doesn't have control over it and thus we need to approve the request
884             if (smartToken != fromToken)
885                 ensureAllowance(fromToken, changer, _amount);
886 
887             // make the change - if it's the last one, also provide the minimum return value
888             _amount = changer.change(fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
889             fromToken = toToken;
890         }
891 
892         // finished the change, transfer the funds back to the caller
893         // if the last change resulted in ether tokens, withdraw them and send them as ETH to the caller
894         if (changer.hasQuickBuyEtherToken() && changer.getQuickBuyEtherToken() == toToken) {
895             IEtherToken etherToken = IEtherToken(toToken);
896             etherToken.withdrawTo(msg.sender, _amount);
897         }
898         else {
899             // not ETH, transfer the tokens to the caller
900             assert(toToken.transfer(msg.sender, _amount));
901         }
902 
903         return _amount;
904     }
905 
906     /**
907         @dev buys the smart token with ETH if the return amount meets the minimum requested
908         note that this function can eventually be moved into a separate contract
909 
910         @param _minReturn  if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
911 
912         @return tokens issued in return
913     */
914     function quickBuy(uint256 _minReturn) public payable returns (uint256 amount) {
915         // ensure that the quick buy path was set
916         assert(quickBuyPath.length > 0);
917         // we assume that the initial source in the quick buy path is always an ether token
918         IEtherToken etherToken = IEtherToken(quickBuyPath[0]);
919         // deposit ETH in the ether token
920         etherToken.deposit.value(msg.value)();
921         // get the initial changer in the path
922         ISmartToken smartToken = ISmartToken(quickBuyPath[1]);
923         BancorChanger changer = BancorChanger(smartToken.owner());
924         // approve allowance for the changer in the ether token
925         ensureAllowance(etherToken, changer, msg.value);
926         // execute the change
927         uint256 returnAmount = changer.quickChange(quickBuyPath, msg.value, _minReturn);
928         // transfer the tokens to the caller
929         assert(token.transfer(msg.sender, returnAmount));
930         return returnAmount;
931     }
932 
933     /**
934         @dev utility, returns the expected return for selling the token for one of its reserve tokens, given a total supply override
935 
936         @param _reserveToken   reserve token contract address
937         @param _sellAmount     amount to sell (in the smart token)
938         @param _totalSupply    total token supply, overrides the actual token total supply when calculating the return
939 
940         @return sale return amount
941     */
942     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _totalSupply)
943         private
944         constant
945         active
946         validReserve(_reserveToken)
947         greaterThanZero(_totalSupply)
948         returns (uint256 amount)
949     {
950         Reserve storage reserve = reserves[_reserveToken];
951         uint256 reserveBalance = getReserveBalance(_reserveToken);
952         amount = formula.calculateSaleReturn(_totalSupply, reserveBalance, reserve.ratio, _sellAmount);
953 
954         // deduct the fee from the return amount
955         uint256 feeAmount = getChangeFeeAmount(amount);
956         return safeSub(amount, feeAmount);
957     }
958 
959     /**
960         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
961 
962         @param _token   token to check the allowance in
963         @param _spender approved address
964         @param _value   allowance amount
965     */
966     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
967         // check if allowance for the given amount already exists
968         if (_token.allowance(this, _spender) >= _value)
969             return;
970 
971         // if the allowance is nonzero, must reset it to 0 first
972         if (_token.allowance(this, _spender) != 0)
973             assert(_token.approve(_spender, 0));
974 
975         // approve the new allowance
976         assert(_token.approve(_spender, _value));
977     }
978 
979     /**
980         @dev utility, transfers tokens from an account to the local contract
981 
982         @param _token   token to claim
983         @param _from    account to claim the tokens from
984         @param _amount  amount to claim
985     */
986     function claimTokens(IERC20Token _token, address _from, uint256 _amount) private {
987         // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the local contract
988         if (_token == token) {
989             token.destroy(_from, _amount); // destroy _amount tokens from the caller's balance in the smart token
990             token.issue(this, _amount); // issue _amount new tokens to the local contract
991             return;
992         }
993 
994         // otherwise, we assume we already have allowance
995         assert(_token.transferFrom(_from, this, _amount));
996     }
997 
998     /**
999         @dev fallback, buys the smart token with ETH
1000         note that the purchase will use the price at the time of the purchase
1001     */
1002     function() payable {
1003         quickBuy(1);
1004     }
1005 }