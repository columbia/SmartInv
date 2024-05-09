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
75 
76 /*
77     Owned contract interface
78 */
79 contract IOwned {
80     // this function isn't abstract since the compiler emits automatically generated getter functions as external
81     function owner() public constant returns (address owner) { owner; }
82 
83     function transferOwnership(address _newOwner) public;
84     function acceptOwnership() public;
85 }
86 
87 
88 /*
89     Provides support and utilities for contract ownership
90 */
91 contract Owned is IOwned {
92     address public owner;
93     address public newOwner;
94 
95     event OwnerUpdate(address _prevOwner, address _newOwner);
96 
97     /**
98         @dev constructor
99     */
100     function Owned() {
101         owner = msg.sender;
102     }
103 
104     // allows execution by the owner only
105     modifier ownerOnly {
106         assert(msg.sender == owner);
107         _;
108     }
109 
110     /**
111         @dev allows transferring the contract ownership
112         the new owner still needs to accept the transfer
113         can only be called by the contract owner
114 
115         @param _newOwner    new contract owner
116     */
117     function transferOwnership(address _newOwner) public ownerOnly {
118         require(_newOwner != owner);
119         newOwner = _newOwner;
120     }
121 
122     /**
123         @dev used by a new owner to accept an ownership transfer
124     */
125     function acceptOwnership() public {
126         require(msg.sender == newOwner);
127         OwnerUpdate(owner, newOwner);
128         owner = newOwner;
129         newOwner = 0x0;
130     }
131 }
132 
133 
134 /*
135     Provides support and utilities for contract management
136 */
137 contract Managed {
138     address public manager;
139     address public newManager;
140 
141     event ManagerUpdate(address _prevManager, address _newManager);
142 
143     /**
144         @dev constructor
145     */
146     function Managed() {
147         manager = msg.sender;
148     }
149 
150     // allows execution by the manager only
151     modifier managerOnly {
152         assert(msg.sender == manager);
153         _;
154     }
155 
156     /**
157         @dev allows transferring the contract management
158         the new manager still needs to accept the transfer
159         can only be called by the contract manager
160 
161         @param _newManager    new contract manager
162     */
163     function transferManagement(address _newManager) public managerOnly {
164         require(_newManager != manager);
165         newManager = _newManager;
166     }
167 
168     /**
169         @dev used by a new manager to accept a management transfer
170     */
171     function acceptManagement() public {
172         require(msg.sender == newManager);
173         ManagerUpdate(manager, newManager);
174         manager = newManager;
175         newManager = 0x0;
176     }
177 }
178 
179 
180 /*
181     Token Holder interface
182 */
183 contract ITokenHolder is IOwned {
184     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
185 }
186 
187 
188 /*
189     We consider every contract to be a 'token holder' since it's currently not possible
190     for a contract to deny receiving tokens.
191 
192     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
193     the owner to send tokens that were sent to the contract by mistake back to their sender.
194 */
195 contract TokenHolder is ITokenHolder, Owned, Utils {
196     /**
197         @dev constructor
198     */
199     function TokenHolder() {
200     }
201 
202     /**
203         @dev withdraws tokens held by the contract and sends them to an account
204         can only be called by the owner
205 
206         @param _token   ERC20 token contract address
207         @param _to      account to receive the new amount
208         @param _amount  amount to withdraw
209     */
210     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
211         public
212         ownerOnly
213         validAddress(_token)
214         validAddress(_to)
215         notThis(_to)
216     {
217         assert(_token.transfer(_to, _amount));
218     }
219 }
220 
221 
222 /*
223     The smart token controller is an upgradable part of the smart token that allows
224     more functionality as well as fixes for bugs/exploits.
225     Once it accepts ownership of the token, it becomes the token's sole controller
226     that can execute any of its functions.
227 
228     To upgrade the controller, ownership must be transferred to a new controller, along with
229     any relevant data.
230 
231     The smart token must be set on construction and cannot be changed afterwards.
232     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
233 
234     Note that the controller can transfer token ownership to a new controller that
235     doesn't allow executing any function on the token, for a trustless solution.
236     Doing that will also remove the owner's ability to upgrade the controller.
237 */
238 contract SmartTokenController is TokenHolder {
239     ISmartToken public token;   // smart token
240 
241     /**
242         @dev constructor
243     */
244     function SmartTokenController(ISmartToken _token)
245         validAddress(_token)
246     {
247         token = _token;
248     }
249 
250     // ensures that the controller is the token's owner
251     modifier active() {
252         assert(token.owner() == address(this));
253         _;
254     }
255 
256     // ensures that the controller is not the token's owner
257     modifier inactive() {
258         assert(token.owner() != address(this));
259         _;
260     }
261 
262     /**
263         @dev allows transferring the token ownership
264         the new owner still need to accept the transfer
265         can only be called by the contract owner
266 
267         @param _newOwner    new token owner
268     */
269     function transferTokenOwnership(address _newOwner) public ownerOnly {
270         token.transferOwnership(_newOwner);
271     }
272 
273     /**
274         @dev used by a new owner to accept a token ownership transfer
275         can only be called by the contract owner
276     */
277     function acceptTokenOwnership() public ownerOnly {
278         token.acceptOwnership();
279     }
280 
281     /**
282         @dev disables/enables token transfers
283         can only be called by the contract owner
284 
285         @param _disable    true to disable transfers, false to enable them
286     */
287     function disableTokenTransfers(bool _disable) public ownerOnly {
288         token.disableTransfers(_disable);
289     }
290 
291     /**
292         @dev withdraws tokens held by the token and sends them to an account
293         can only be called by the owner
294 
295         @param _token   ERC20 token contract address
296         @param _to      account to receive the new amount
297         @param _amount  amount to withdraw
298     */
299     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
300         token.withdrawTokens(_token, _to, _amount);
301     }
302 }
303 
304 
305 /*
306     ERC20 Standard Token interface
307 */
308 contract IERC20Token {
309     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
310     function name() public constant returns (string name) { name; }
311     function symbol() public constant returns (string symbol) { symbol; }
312     function decimals() public constant returns (uint8 decimals) { decimals; }
313     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
314     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
315     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
316 
317     function transfer(address _to, uint256 _value) public returns (bool success);
318     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
319     function approve(address _spender, uint256 _value) public returns (bool success);
320 }
321 
322 
323 /*
324     Ether Token interface
325 */
326 contract IEtherToken is ITokenHolder, IERC20Token {
327     function deposit() public payable;
328     function withdraw(uint256 _amount) public;
329     function withdrawTo(address _to, uint256 _amount);
330 }
331 
332 
333 /*
334     Smart Token interface
335 */
336 contract ISmartToken is ITokenHolder, IERC20Token {
337     function disableTransfers(bool _disable) public;
338     function issue(address _to, uint256 _amount) public;
339     function destroy(address _from, uint256 _amount) public;
340 }
341 
342 
343 /*
344     Bancor Formula interface
345 */
346 contract IBancorFormula {
347     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
348     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
349 }
350 
351 
352 /*
353     EIP228 Token Changer interface
354 */
355 contract ITokenChanger {
356     function changeableTokenCount() public constant returns (uint16 count);
357     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress);
358     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount);
359     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount);
360 }
361 
362 
363 /*
364     Open issues:
365     - Add miner front-running attack protection. The issue is somewhat mitigated by the use of _minReturn when changing
366     - Possibly add getters for reserve fields so that the client won't need to rely on the order in the struct
367 */
368 
369 /*
370     Bancor Changer v0.2
371 
372     The Bancor version of the token changer, allows changing between a smart token and other ERC20 tokens and between different ERC20 tokens and themselves.
373 
374     ERC20 reserve token balance can be virtual, meaning that the calculations are based on the virtual balance instead of relying on
375     the actual reserve balance. This is a security mechanism that prevents the need to keep a very large (and valuable) balance in a single contract.
376 
377     The changer is upgradable (just like any SmartTokenController).
378 
379     A note on change paths -
380     Change path is a data structure that's used when changing a token to another token in the bancor network
381     when the change cannot necessarily be done by single changer and might require multiple 'hops'.
382     The path defines which changers should be used and what kind of change should be done in each step.
383 
384     The path format doesn't include complex structure and instead, it is represented by a single array
385     in which each 'hop' is represented by a 2-tuple - smart token & to token.
386     In addition, the first element is always the source token.
387     The smart token is only used as a pointer to a changer (since changer addresses are more likely to change).
388 
389     Format:
390     [source token, smart token, to token, smart token, to token...]
391 
392 
393     WARNING: It is NOT RECOMMENDED to use the changer with Smart Tokens that have less than 8 decimal digits
394              or with very small numbers because of precision loss
395 */
396 contract BancorChanger is ITokenChanger, SmartTokenController, Managed {
397     uint32 private constant MAX_CRR = 1000000;
398     uint32 private constant MAX_CHANGE_FEE = 1000000;
399 
400     struct Reserve {
401         uint256 virtualBalance;         // virtual balance
402         uint32 ratio;                   // constant reserve ratio (CRR), represented in ppm, 1-1000000
403         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
404         bool isPurchaseEnabled;         // is purchase of the smart token enabled with the reserve, can be set by the owner
405         bool isSet;                     // used to tell if the mapping element is defined
406     }
407 
408     string public version = '0.2';
409     string public changerType = 'bancor';
410 
411     IBancorFormula public formula;                  // bancor calculation formula contract
412     IERC20Token[] public reserveTokens;             // ERC20 standard token addresses
413     IERC20Token[] public quickBuyPath;              // change path that's used in order to buy the token with ETH
414     mapping (address => Reserve) public reserves;   // reserve token addresses -> reserve data
415     uint32 private totalReserveRatio = 0;           // used to efficiently prevent increasing the total reserve ratio above 100%
416     uint32 public maxChangeFee = 0;                 // maximum change fee for the lifetime of the contract, represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
417     uint32 public changeFee = 0;                    // current change fee, represented in ppm, 0...maxChangeFee
418     bool public changingEnabled = true;             // true if token changing is enabled, false if not
419 
420     // triggered when a change between two tokens occurs (TokenChanger event)
421     event Change(address indexed _fromToken, address indexed _toToken, address indexed _trader, uint256 _amount, uint256 _return,
422                  uint256 _currentPriceN, uint256 _currentPriceD);
423 
424     /**
425         @dev constructor
426 
427         @param  _token          smart token governed by the changer
428         @param  _formula        address of a bancor formula contract
429         @param  _maxChangeFee   maximum change fee, represented in ppm
430         @param  _reserveToken   optional, initial reserve, allows defining the first reserve at deployment time
431         @param  _reserveRatio   optional, ratio for the initial reserve
432     */
433     function BancorChanger(ISmartToken _token, IBancorFormula _formula, uint32 _maxChangeFee, IERC20Token _reserveToken, uint32 _reserveRatio)
434         SmartTokenController(_token)
435         validAddress(_formula)
436         validMaxChangeFee(_maxChangeFee)
437     {
438         formula = _formula;
439         maxChangeFee = _maxChangeFee;
440 
441         if (address(_reserveToken) != 0x0)
442             addReserve(_reserveToken, _reserveRatio, false);
443     }
444 
445     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
446     modifier validReserve(IERC20Token _address) {
447         require(reserves[_address].isSet);
448         _;
449     }
450 
451     // validates a token address - verifies that the address belongs to one of the changeable tokens
452     modifier validToken(IERC20Token _address) {
453         require(_address == token || reserves[_address].isSet);
454         _;
455     }
456 
457     // validates maximum change fee
458     modifier validMaxChangeFee(uint32 _changeFee) {
459         require(_changeFee >= 0 && _changeFee <= MAX_CHANGE_FEE);
460         _;
461     }
462 
463     // validates change fee
464     modifier validChangeFee(uint32 _changeFee) {
465         require(_changeFee >= 0 && _changeFee <= maxChangeFee);
466         _;
467     }
468 
469     // validates reserve ratio range
470     modifier validReserveRatio(uint32 _ratio) {
471         require(_ratio > 0 && _ratio <= MAX_CRR);
472         _;
473     }
474 
475     // validates a change path - verifies that the number of elements is odd and that maximum number of 'hops' is 10
476     modifier validChangePath(IERC20Token[] _path) {
477         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
478         _;
479     }
480 
481     // allows execution only when changing isn't disabled
482     modifier changingAllowed {
483         assert(changingEnabled);
484         _;
485     }
486 
487     /**
488         @dev returns the number of reserve tokens defined
489 
490         @return number of reserve tokens
491     */
492     function reserveTokenCount() public constant returns (uint16 count) {
493         return uint16(reserveTokens.length);
494     }
495 
496     /**
497         @dev returns the number of changeable tokens supported by the contract
498         note that the number of changeable tokens is the number of reserve token, plus 1 (that represents the smart token)
499 
500         @return number of changeable tokens
501     */
502     function changeableTokenCount() public constant returns (uint16 count) {
503         return reserveTokenCount() + 1;
504     }
505 
506     /**
507         @dev given a changeable token index, returns the changeable token contract address
508 
509         @param _tokenIndex  changeable token index
510 
511         @return number of changeable tokens
512     */
513     function changeableToken(uint16 _tokenIndex) public constant returns (address tokenAddress) {
514         if (_tokenIndex == 0)
515             return token;
516         return reserveTokens[_tokenIndex - 1];
517     }
518 
519     /*
520         @dev allows the owner to update the formula contract address
521 
522         @param _formula    address of a bancor formula contract
523     */
524     function setFormula(IBancorFormula _formula)
525         public
526         ownerOnly
527         validAddress(_formula)
528         notThis(_formula)
529     {
530         formula = _formula;
531     }
532 
533     /*
534         @dev allows the manager to update the quick buy path
535 
536         @param _path    new quick buy path, see change path format above
537     */
538     function setQuickBuyPath(IERC20Token[] _path)
539         public
540         ownerOnly
541         validChangePath(_path)
542     {
543         quickBuyPath = _path;
544     }
545 
546     /*
547         @dev allows the manager to clear the quick buy path
548     */
549     function clearQuickBuyPath() public ownerOnly {
550         quickBuyPath.length = 0;
551     }
552 
553     /**
554         @dev returns the length of the quick buy path array
555 
556         @return quick buy path length
557     */
558     function getQuickBuyPathLength() public constant returns (uint256 length) {
559         return quickBuyPath.length;
560     }
561 
562     /**
563         @dev returns true if ether token exists in the quick buy path, false if not
564         note that there should always be one in the quick buy path, if one is set
565 
566         @return true if ether token exists, false if not
567     */
568     function hasQuickBuyEtherToken() public constant returns (bool) {
569         return quickBuyPath.length > 0;
570     }
571 
572     /**
573         @dev returns the address of the ether token used by the quick buy functionality
574         note that it should always be the first element in the quick buy path, if one is set
575 
576         @return ether token address
577     */
578     function getQuickBuyEtherToken() public constant returns (IEtherToken etherToken) {
579         assert(quickBuyPath.length > 0);
580         return IEtherToken(quickBuyPath[0]);
581     }
582 
583     /**
584         @dev disables the entire change functionality
585         this is a safety mechanism in case of a emergency
586         can only be called by the manager
587 
588         @param _disable true to disable changing, false to re-enable it
589     */
590     function disableChanging(bool _disable) public managerOnly {
591         changingEnabled = !_disable;
592     }
593 
594     /**
595         @dev updates the current change fee
596         can only be called by the manager
597 
598         @param _changeFee new change fee, represented in ppm
599     */
600     function setChangeFee(uint32 _changeFee)
601         public
602         managerOnly
603         validChangeFee(_changeFee)
604     {
605         changeFee = _changeFee;
606     }
607 
608     /*
609         @dev returns the change fee amount for a given return amount
610 
611         @return change fee amount
612     */
613     function getChangeFeeAmount(uint256 _amount) public constant returns (uint256 feeAmount) {
614         return safeMul(_amount, changeFee) / MAX_CHANGE_FEE;
615     }
616 
617     /**
618         @dev defines a new reserve for the token
619         can only be called by the owner while the changer is inactive
620 
621         @param _token                  address of the reserve token
622         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
623         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
624     */
625     function addReserve(IERC20Token _token, uint32 _ratio, bool _enableVirtualBalance)
626         public
627         ownerOnly
628         inactive
629         validAddress(_token)
630         notThis(_token)
631         validReserveRatio(_ratio)
632     {
633         require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= MAX_CRR); // validate input
634 
635         reserves[_token].virtualBalance = 0;
636         reserves[_token].ratio = _ratio;
637         reserves[_token].isVirtualBalanceEnabled = _enableVirtualBalance;
638         reserves[_token].isPurchaseEnabled = true;
639         reserves[_token].isSet = true;
640         reserveTokens.push(_token);
641         totalReserveRatio += _ratio;
642     }
643 
644     /**
645         @dev updates one of the token reserves
646         can only be called by the owner
647 
648         @param _reserveToken           address of the reserve token
649         @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
650         @param _enableVirtualBalance   true to enable virtual balance for the reserve, false to disable it
651         @param _virtualBalance         new reserve's virtual balance
652     */
653     function updateReserve(IERC20Token _reserveToken, uint32 _ratio, bool _enableVirtualBalance, uint256 _virtualBalance)
654         public
655         ownerOnly
656         validReserve(_reserveToken)
657         validReserveRatio(_ratio)
658     {
659         Reserve storage reserve = reserves[_reserveToken];
660         require(totalReserveRatio - reserve.ratio + _ratio <= MAX_CRR); // validate input
661 
662         totalReserveRatio = totalReserveRatio - reserve.ratio + _ratio;
663         reserve.ratio = _ratio;
664         reserve.isVirtualBalanceEnabled = _enableVirtualBalance;
665         reserve.virtualBalance = _virtualBalance;
666     }
667 
668     /**
669         @dev disables purchasing with the given reserve token in case the reserve token got compromised
670         can only be called by the owner
671         note that selling is still enabled regardless of this flag and it cannot be disabled by the owner
672 
673         @param _reserveToken    reserve token contract address
674         @param _disable         true to disable the token, false to re-enable it
675     */
676     function disableReservePurchases(IERC20Token _reserveToken, bool _disable)
677         public
678         ownerOnly
679         validReserve(_reserveToken)
680     {
681         reserves[_reserveToken].isPurchaseEnabled = !_disable;
682     }
683 
684     /**
685         @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
686 
687         @param _reserveToken    reserve token contract address
688 
689         @return reserve balance
690     */
691     function getReserveBalance(IERC20Token _reserveToken)
692         public
693         constant
694         validReserve(_reserveToken)
695         returns (uint256 balance)
696     {
697         Reserve storage reserve = reserves[_reserveToken];
698         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
699     }
700 
701     /**
702         @dev returns the expected return for changing a specific amount of _fromToken to _toToken
703 
704         @param _fromToken  ERC20 token to change from
705         @param _toToken    ERC20 token to change to
706         @param _amount     amount to change, in fromToken
707 
708         @return expected change return amount
709     */
710     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public constant returns (uint256 amount) {
711         require(_fromToken != _toToken); // validate input
712 
713         // change between the token and one of its reserves
714         if (_toToken == token)
715             return getPurchaseReturn(_fromToken, _amount);
716         else if (_fromToken == token)
717             return getSaleReturn(_toToken, _amount);
718 
719         // change between 2 reserves
720         uint256 purchaseReturnAmount = getPurchaseReturn(_fromToken, _amount);
721         return getSaleReturn(_toToken, purchaseReturnAmount, safeAdd(token.totalSupply(), purchaseReturnAmount));
722     }
723 
724     /**
725         @dev returns the expected return for buying the token for a reserve token
726 
727         @param _reserveToken   reserve token contract address
728         @param _depositAmount  amount to deposit (in the reserve token)
729 
730         @return expected purchase return amount
731     */
732     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
733         public
734         constant
735         active
736         validReserve(_reserveToken)
737         returns (uint256 amount)
738     {
739         Reserve storage reserve = reserves[_reserveToken];
740         require(reserve.isPurchaseEnabled); // validate input
741 
742         uint256 tokenSupply = token.totalSupply();
743         uint256 reserveBalance = getReserveBalance(_reserveToken);
744         amount = formula.calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
745 
746         // deduct the fee from the return amount
747         uint256 feeAmount = getChangeFeeAmount(amount);
748         return safeSub(amount, feeAmount);
749     }
750 
751     /**
752         @dev returns the expected return for selling the token for one of its reserve tokens
753 
754         @param _reserveToken   reserve token contract address
755         @param _sellAmount     amount to sell (in the smart token)
756 
757         @return expected sale return amount
758     */
759     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount) public constant returns (uint256 amount) {
760         return getSaleReturn(_reserveToken, _sellAmount, token.totalSupply());
761     }
762 
763     /**
764         @dev changes a specific amount of _fromToken to _toToken
765 
766         @param _fromToken  ERC20 token to change from
767         @param _toToken    ERC20 token to change to
768         @param _amount     amount to change, in fromToken
769         @param _minReturn  if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
770 
771         @return change return amount
772     */
773     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 amount) {
774         require(_fromToken != _toToken); // validate input
775 
776         // change between the token and one of its reserves
777         if (_toToken == token)
778             return buy(_fromToken, _amount, _minReturn);
779         else if (_fromToken == token)
780             return sell(_toToken, _amount, _minReturn);
781 
782         // change between 2 reserves
783         uint256 purchaseAmount = buy(_fromToken, _amount, 1);
784         return sell(_toToken, purchaseAmount, _minReturn);
785     }
786 
787     /**
788         @dev buys the token by depositing one of its reserve tokens
789 
790         @param _reserveToken   reserve token contract address
791         @param _depositAmount  amount to deposit (in the reserve token)
792         @param _minReturn      if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
793 
794         @return buy return amount
795     */
796     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn)
797         public
798         changingAllowed
799         greaterThanZero(_minReturn)
800         returns (uint256 amount)
801     {
802         amount = getPurchaseReturn(_reserveToken, _depositAmount);
803         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
804 
805         // update virtual balance if relevant
806         Reserve storage reserve = reserves[_reserveToken];
807         if (reserve.isVirtualBalanceEnabled)
808             reserve.virtualBalance = safeAdd(reserve.virtualBalance, _depositAmount);
809 
810         assert(_reserveToken.transferFrom(msg.sender, this, _depositAmount)); // transfer _depositAmount funds from the caller in the reserve token
811         token.issue(msg.sender, amount); // issue new funds to the caller in the smart token
812 
813         // calculate the new price using the simple price formula
814         // price = reserve balance / (supply * CRR)
815         // CRR is represented in ppm, so multiplying by 1000000
816         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
817         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
818         Change(_reserveToken, token, msg.sender, _depositAmount, amount, reserveAmount, tokenAmount);
819         return amount;
820     }
821 
822     /**
823         @dev sells the token by withdrawing from one of its reserve tokens
824 
825         @param _reserveToken   reserve token contract address
826         @param _sellAmount     amount to sell (in the smart token)
827         @param _minReturn      if the change results in an amount smaller the minimum return - it is cancelled, must be nonzero
828 
829         @return sell return amount
830     */
831     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn)
832         public
833         changingAllowed
834         greaterThanZero(_minReturn)
835         returns (uint256 amount)
836     {
837         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
838 
839         amount = getSaleReturn(_reserveToken, _sellAmount);
840         assert(amount != 0 && amount >= _minReturn); // ensure the trade gives something in return and meets the minimum requested amount
841 
842         uint256 tokenSupply = token.totalSupply();
843         uint256 reserveBalance = getReserveBalance(_reserveToken);
844         // ensure that the trade will only deplete the reserve if the total supply is depleted as well
845         assert(amount < reserveBalance || (amount == reserveBalance && _sellAmount == tokenSupply));
846 
847         // update virtual balance if relevant
848         Reserve storage reserve = reserves[_reserveToken];
849         if (reserve.isVirtualBalanceEnabled)
850             reserve.virtualBalance = safeSub(reserve.virtualBalance, amount);
851 
852         token.destroy(msg.sender, _sellAmount); // destroy _sellAmount from the caller's balance in the smart token
853         assert(_reserveToken.transfer(msg.sender, amount)); // transfer funds to the caller in the reserve token
854                                                             // note that it might fail if the actual reserve balance is smaller than the virtual balance
855         // calculate the new price using the simple price formula
856         // price = reserve balance / (supply * CRR)
857         // CRR is represented in ppm, so multiplying by 1000000
858         uint256 reserveAmount = safeMul(getReserveBalance(_reserveToken), MAX_CRR);
859         uint256 tokenAmount = safeMul(token.totalSupply(), reserve.ratio);
860         Change(token, _reserveToken, msg.sender, _sellAmount, amount, tokenAmount, reserveAmount);
861         return amount;
862     }
863 
864     /**
865         @dev changes the token to any other token in the bancor network by following a predefined change path
866         note that when changing from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
867 
868         @param _path        change path, see change path format above
869         @param _amount      amount to change from (in the initial source token)
870         @param _minReturn   if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
871 
872         @return tokens issued in return
873     */
874     function quickChange(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
875         public
876         validChangePath(_path)
877         returns (uint256 amount)
878     {
879         // we need to transfer the tokens from the caller to the local contract before we
880         // follow the change path, to allow it to execute the change on behalf of the caller
881         IERC20Token fromToken = _path[0];
882         claimTokens(fromToken, msg.sender, _amount);
883 
884         ISmartToken smartToken;
885         IERC20Token toToken;
886         BancorChanger changer;
887         uint256 pathLength = _path.length;
888 
889         // iterate over the change path
890         for (uint256 i = 1; i < pathLength; i += 2) {
891             smartToken = ISmartToken(_path[i]);
892             toToken = _path[i + 1];
893             changer = BancorChanger(smartToken.owner());
894 
895             // if the smart token isn't the source (from token), the changer doesn't have control over it and thus we need to approve the request
896             if (smartToken != fromToken)
897                 ensureAllowance(fromToken, changer, _amount);
898 
899             // make the change - if it's the last one, also provide the minimum return value
900             _amount = changer.change(fromToken, toToken, _amount, i == pathLength - 2 ? _minReturn : 1);
901             fromToken = toToken;
902         }
903 
904         // finished the change, transfer the funds back to the caller
905         // if the last change resulted in ether tokens, withdraw them and send them as ETH to the caller
906         if (changer.hasQuickBuyEtherToken() && changer.getQuickBuyEtherToken() == toToken) {
907             IEtherToken etherToken = IEtherToken(toToken);
908             etherToken.withdrawTo(msg.sender, _amount);
909         }
910         else {
911             // not ETH, transfer the tokens to the caller
912             assert(toToken.transfer(msg.sender, _amount));
913         }
914 
915         return _amount;
916     }
917 
918     /**
919         @dev buys the smart token with ETH if the return amount meets the minimum requested
920         note that this function can eventually be moved into a separate contract
921 
922         @param _minReturn  if the change results in an amount smaller than the minimum return - it is cancelled, must be nonzero
923 
924         @return tokens issued in return
925     */
926     function quickBuy(uint256 _minReturn) public payable returns (uint256 amount) {
927         // ensure that the quick buy path was set
928         assert(quickBuyPath.length > 0);
929         // we assume that the initial source in the quick buy path is always an ether token
930         IEtherToken etherToken = IEtherToken(quickBuyPath[0]);
931         // deposit ETH in the ether token
932         etherToken.deposit.value(msg.value)();
933         // get the initial changer in the path
934         ISmartToken smartToken = ISmartToken(quickBuyPath[1]);
935         BancorChanger changer = BancorChanger(smartToken.owner());
936         // approve allowance for the changer in the ether token
937         ensureAllowance(etherToken, changer, msg.value);
938         // execute the change
939         uint256 returnAmount = changer.quickChange(quickBuyPath, msg.value, _minReturn);
940         // transfer the tokens to the caller
941         assert(token.transfer(msg.sender, returnAmount));
942         return returnAmount;
943     }
944 
945     /**
946         @dev utility, returns the expected return for selling the token for one of its reserve tokens, given a total supply override
947 
948         @param _reserveToken   reserve token contract address
949         @param _sellAmount     amount to sell (in the smart token)
950         @param _totalSupply    total token supply, overrides the actual token total supply when calculating the return
951 
952         @return sale return amount
953     */
954     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _totalSupply)
955         private
956         constant
957         active
958         validReserve(_reserveToken)
959         greaterThanZero(_totalSupply)
960         returns (uint256 amount)
961     {
962         Reserve storage reserve = reserves[_reserveToken];
963         uint256 reserveBalance = getReserveBalance(_reserveToken);
964         amount = formula.calculateSaleReturn(_totalSupply, reserveBalance, reserve.ratio, _sellAmount);
965 
966         // deduct the fee from the return amount
967         uint256 feeAmount = getChangeFeeAmount(amount);
968         return safeSub(amount, feeAmount);
969     }
970 
971     /**
972         @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't
973 
974         @param _token   token to check the allowance in
975         @param _spender approved address
976         @param _value   allowance amount
977     */
978     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
979         // check if allowance for the given amount already exists
980         if (_token.allowance(this, _spender) >= _value)
981             return;
982 
983         // if the allowance is nonzero, must reset it to 0 first
984         if (_token.allowance(this, _spender) != 0)
985             assert(_token.approve(_spender, 0));
986 
987         // approve the new allowance
988         assert(_token.approve(_spender, _value));
989     }
990 
991     /**
992         @dev utility, transfers tokens from an account to the local contract
993 
994         @param _token   token to claim
995         @param _from    account to claim the tokens from
996         @param _amount  amount to claim
997     */
998     function claimTokens(IERC20Token _token, address _from, uint256 _amount) private {
999         // if the token is the smart token, no allowance is required - destroy the tokens from the caller and issue them to the local contract
1000         if (_token == token) {
1001             token.destroy(_from, _amount); // destroy _amount tokens from the caller's balance in the smart token
1002             token.issue(this, _amount); // issue _amount new tokens to the local contract
1003             return;
1004         }
1005 
1006         // otherwise, we assume we already have allowance
1007         assert(_token.transferFrom(_from, this, _amount));
1008     }
1009 
1010     /**
1011         @dev fallback, buys the smart token with ETH
1012         note that the purchase will use the price at the time of the purchase
1013     */
1014     function() payable {
1015         quickBuy(1);
1016     }
1017 }