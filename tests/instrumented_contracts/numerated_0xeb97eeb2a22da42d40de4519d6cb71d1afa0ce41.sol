1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface ofƒice the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233     
234     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
235         uint256 c = add(a,m);
236         uint256 d = sub(c,1);
237         return mul(div(d,m),m);
238     }
239 }
240   struct holderDetails {
241         uint256  totalBuyIn15Min;
242         uint256  lastBuyTime;
243         uint256  lastSellTime;
244 
245          }
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin guidelines: functions revert instead
259  * of returning `false` on failure. This behavior is nonetheless conventional
260  * and does not conflict with the expectations of ERC20 applications.
261  *
262  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
263  * This allows applications to reconstruct the allowance for all accounts just
264  * by listening to said events. Other implementations of the EIP may not emit
265  * these events, as it isn't required by the specification.
266  *
267  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
268  * functions have been added to mitigate the well-known issues around setting
269  * allowances. See {IERC20-approve}.
270  */
271 contract OneChad is IERC20 {
272     using SafeMath for uint256;
273 
274     mapping (address => uint256) private _balances;
275 
276     mapping (address => mapping (address => uint256)) private _allowances;
277     
278     mapping (address => bool) private whitelist;
279     uint256 holderIndex = 0;
280     mapping (uint256=>address) private tokenHolders;
281     mapping (address=>holderDetails) public holderDetailInTimeSlot;
282     mapping (address => uint256) private winnersHistory;
283     
284     uint256 timeBetweenPrizes = 15 minutes;
285     uint256 winnerCooldown = 1 hours; 
286 
287     uint256 public lastPrizeTime = 0;
288     uint256 private precentageTokenToBurnBot = 20;
289     uint256 private sidePotPrizePrecentage = 50;
290     uint256 private precentageTokenToSidePot = 5;
291     uint256 private precentageTokenToBurn = 5;
292 
293     // Two minutes minimum diff between selling and buying time
294     uint256 private minimumDiffSellBuyTime = 2 minutes;
295     
296     uint256 private _totalSupply = 500 ether;
297 
298     string private _name = "OneChad.network";
299     string private _symbol = "1Chad";
300     uint8 private _decimals = 18;
301     address private __owner;
302     bool public beginning = true;
303     bool private limitBuy = true;
304 
305     // those are the public addresses on etherscan
306     address private uniswapRouterV2 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307     address private WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
308     address private uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
309     address sidepotAddress = 0x000000000000000000000000000000000000dEaD;
310 
311     event Chad(address indexed who);
312 
313     /**
314      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
315      * a default value of 18.
316      *
317      * To select a different value for {decimals}, use {_setupDecimals}.
318      *
319      * All three of these values are immutable: they can only be set once during
320      * construction.
321      */
322     constructor () public {
323         __owner = msg.sender;
324         _balances[__owner] = _totalSupply;
325     }
326 
327     /**
328      * @dev Returns the name of the token.
329      */
330     function name() public view returns (string memory) {
331         return _name;
332     }
333 
334     /**
335      * @dev Returns the symbol of the token, usually a shorter version of the
336      * name.
337      */
338     function symbol() public view returns (string memory) {
339         return _symbol;
340     }
341 
342     /**
343      * @dev Returns the number of decimals used to get its user representation.
344      * For example, if `decimals` equals `2`, a balance of `505` tokens should
345      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
346      *
347      * Tokens usually opt for a value of 18, imitating the relationship between
348      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
349      * called.
350      *
351      * NOTE: This information is only used for _display_ purposes: it in
352      * no way affects any of the arithmetic of the contract, including
353      * {IERC20-balanceOf} and {IERC20-transfer}.
354      */
355     function decimals() public view returns (uint8) {
356         return _decimals;
357     }
358     
359     function multiWhitelistAdd(address[] memory addresses) public {
360         if (msg.sender != __owner) {
361             revert();
362         }
363 
364         for (uint256 i = 0; i < addresses.length; i++) {
365             whitelistAdd(addresses[i]);
366         }
367     }
368 
369     function multiWhitelistRemove(address[] memory addresses) public {
370         if (msg.sender != __owner) {
371             revert();
372         }
373 
374         for (uint256 i = 0; i < addresses.length; i++) {
375             whitelistRemove(addresses[i]);
376         }
377     }
378 
379     function whitelistAdd(address a) public {
380         if (msg.sender != __owner) {
381             revert();
382         }
383         
384         whitelist[a] = true;
385     }
386     
387     function whitelistRemove(address a) public {
388         if (msg.sender != __owner) {
389             revert();
390         }
391         
392         whitelist[a] = false;
393     }
394     
395     function isInWhitelist(address a) internal view returns (bool) {
396         return whitelist[a];
397     }
398 
399     /**
400      * @dev See {IERC20-totalSupply}.
401      */
402     function totalSupply() public view override returns (uint256) {
403         return _totalSupply;
404     }
405 
406     /**
407      * @dev See {IERC20-balanceOf}.
408      */
409     function balanceOf(address account) public view override returns (uint256) {
410         return _balances[account];
411     }
412     
413     function multiTransfer(address[] memory addresses, uint256 amount) public {
414         for (uint256 i = 0; i < addresses.length; i++) {
415             transfer(addresses[i], amount);
416         }
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(msg.sender, recipient, amount);
429         return true;
430     }
431 
432     function enableLimit() public {
433         if (msg.sender != __owner) {
434             revert();
435         }
436         
437         limitBuy = true;
438     }
439     
440     function disableLimit() public {
441         if (msg.sender != __owner) {
442             revert();
443         }
444         
445         limitBuy = false;
446     }
447     /**
448      * @dev See {IERC20-allowance}.
449      */
450     function allowance(address owner, address spender) public view virtual override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     /**
455      * @dev See {IERC20-approve}.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(address spender, uint256 amount) public virtual override returns (bool) {
462         _approve(msg.sender, spender, amount);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-transferFrom}.
468      *
469      * Emits an {Approval} event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of {ERC20}.
471      *
472      * Requirements:
473      *
474      * - `sender` and `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      * - the caller must have allowance for ``sender``'s tokens of at least
477      * `amount`.
478      */
479     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
480         _transfer(sender, recipient, amount);
481         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically increases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      */
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
499         return true;
500     }
501 
502     /**
503      * @dev Atomically decreases the allowance granted to `spender` by the caller.
504      *
505      * This is an alternative to {approve} that can be used as a mitigation for
506      * problems described in {IERC20-approve}.
507      *
508      * Emits an {Approval} event indicating the updated allowance.
509      *
510      * Requirements:
511      *
512      * - `spender` cannot be the zero address.
513      * - `spender` must have allowance for the caller of at least
514      * `subtractedValue`.
515      */
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520       
521     function isPrizetime() public view returns(bool) {
522         return (timeBetweenPrizes + now)>=lastPrizeTime;
523     }
524     
525     
526     function addAddressWonPrize(address holder) private{
527         winnersHistory[holder] = now;
528     }
529     
530     function canWin(address recipient) public view returns (bool){
531         if(winnersHistory[recipient] != 0){
532             return (now - (winnersHistory[recipient])) >= winnerCooldown;
533         }
534 
535         return true;
536     }
537     
538     function getBiggestholder() private returns (address){
539         uint256 max = 0;
540         uint256 bought = 0;
541 
542         address winnerAddress = sidepotAddress;
543         address curAddress;
544         
545         for(uint256 i=0; i < holderIndex; i++){
546             curAddress = tokenHolders[i];
547             bought = holderDetailInTimeSlot[curAddress].totalBuyIn15Min;
548 
549             if(bought > max){
550                 if(canWin(curAddress) && isVirgin(curAddress) == false && curAddress != sidepotAddress && !shouldIgnore(curAddress)) {
551                     winnerAddress = curAddress;
552                     max = bought;
553                 }
554                 
555             }
556         }
557         return winnerAddress;
558     }
559 
560     function transferPrice(address winner) private {
561         uint256 amount = _balances[sidepotAddress].div(100).mul(sidePotPrizePrecentage);
562         _beforeTokenTransfer(winner, sidepotAddress ,amount);
563         _balances[sidepotAddress] = _balances[sidepotAddress].sub(amount, "ERC20: burn amount exceeds balance");
564         _balances[winner] += amount;
565         emit Transfer(sidepotAddress, winner, amount);
566         
567     }
568     function rememberBuyerTransaction(address holderAddress, uint256 amount) private {
569         if(holderDetailInTimeSlot[holderAddress].totalBuyIn15Min != 0){
570             holderDetailInTimeSlot[holderAddress].totalBuyIn15Min  +=  amount;
571             holderDetailInTimeSlot[holderAddress].lastBuyTime = now;
572 
573         }
574         else{
575             tokenHolders[holderIndex] = holderAddress;
576             holderDetailInTimeSlot[holderAddress] = holderDetails(amount, now, 0);
577             holderIndex +=1;
578             holderIndex %= 400;
579         }
580     }
581     
582     function rememberSellerTransaction(address holderAddress, uint256 amount) private {
583         if(holderDetailInTimeSlot[holderAddress].totalBuyIn15Min != 0){
584             holderDetailInTimeSlot[holderAddress].totalBuyIn15Min  -=  amount;
585             holderDetailInTimeSlot[holderAddress].lastSellTime = now;
586         }
587     }
588 
589     // calculates the CREATE2 address for a pair without making any external calls
590     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
591         (address token0, address token1) = sortTokens(tokenA, tokenB);
592         pair = address(uint(keccak256(abi.encodePacked(
593                 hex'ff',
594                 factory,
595                 keccak256(abi.encodePacked(token0, token1)),
596                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
597             ))));
598     }
599     
600 
601     // returns sorted token addresses, used to handle return values from pairs sorted in this order
602     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
603         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
604         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
605         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
606     }
607     
608     function isVirgin(address holderAddress) public view returns(bool){
609         if (holderDetailInTimeSlot[holderAddress].lastSellTime == 0) {
610             return false;
611         }
612         
613         return (holderDetailInTimeSlot[holderAddress].lastSellTime - holderDetailInTimeSlot[holderAddress].lastBuyTime) < minimumDiffSellBuyTime;
614     }
615     
616     function shouldIgnore(address a) public view returns(bool) {
617         if (a == uniswapRouterV2 || a == __owner) {
618             return true;
619         }
620 
621         (address token0, address token1) = sortTokens(address(this), WETH);
622         address pair = pairFor(uniswapFactory, token0, token1);
623 
624         if (a == pair) {
625             return true;
626         }
627 
628         return false;
629     }
630     function clearTransactionHistory() internal {
631         for (uint256 i = 0; i < holderIndex; i++) {
632             holderDetailInTimeSlot[tokenHolders[i]] = holderDetails(0, 0, 0);
633         }
634 
635         holderIndex = 0;
636     }
637     
638     /**
639      * @dev Moves tokens `amount` from `sender` to `recipient`.
640      *
641      * This is internal function is equivalent to {transfer}, and can be used to
642      * e.g. implement automatic token fees, slashing mechanisms, etc.
643      *
644      * Emits a {Transfer} event.
645      *
646      * Requirements:
647      *
648      * - `sender` cannot be the zero address.
649      * - `recipient` cannot be the zero address.
650      * - `sender` must have a balance of at least `amount`.
651      */
652     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
653         require(sender != address(0), "ERC20: transfer from the zero address");
654         require(recipient != address(0), "ERC20: transfer to the zero address");
655         uint256 curBurnPrecentage = precentageTokenToBurn;
656         uint256 curSidepotPrecentage = precentageTokenToSidePot;
657         
658 
659         if (limitBuy) {
660             if (amount > 5 ether && sender != __owner) {
661                 revert('buy/sell limit in place');
662             }
663             
664             if ((now - holderDetailInTimeSlot[sender].lastBuyTime) < minimumDiffSellBuyTime && !shouldIgnore(sender)){
665                 curBurnPrecentage = precentageTokenToBurnBot;
666             }
667             
668             if (beginning && isInWhitelist(sender)) {
669                 curBurnPrecentage = precentageTokenToBurnBot;
670             }
671         }
672         
673         if (__owner == sender) {
674             curBurnPrecentage = 1; // small burn for listing
675         }
676         
677         _beforeTokenTransfer(sender, recipient, amount);
678         
679         uint256 tokensToBurn = amount.div(100).mul(curBurnPrecentage);
680         uint256 tokensToSidePot = amount.div(100).mul(curSidepotPrecentage);
681         
682         uint256 tokensToTransfer = amount.sub(tokensToBurn).sub(tokensToSidePot);
683 
684         
685         _burn(sender, tokensToBurn);
686         _transferToSidePot(sender, tokensToSidePot);
687         _balances[sender] = _balances[sender].sub(tokensToTransfer, "ERC20: transfer amount exceeds balance");
688         _balances[recipient] = _balances[recipient].add(tokensToTransfer);
689         
690         rememberSellerTransaction(sender, amount);
691         rememberBuyerTransaction(recipient, amount);
692     
693         if(isPrizetime()){
694             address winner = getBiggestholder();
695             if (winner != sidepotAddress) {
696                 // we have a winner
697                 addAddressWonPrize(winner);
698                 clearTransactionHistory();
699                 transferPrice(winner);
700                 lastPrizeTime = now;
701                 
702                 emit Chad(winner);    
703             }
704         }
705 
706         emit Transfer(sender, recipient, tokensToTransfer);
707     }
708 
709     /**
710      * @dev Destroys `amount` tokens from `account`, reducing the
711      * total supply.
712      *
713      * Emits a {Transfer} event with `to` set to the zero address.
714      *
715      * Requirements:
716      *
717      * - `account` cannot be the zero address.
718      * - `account` must have at least `amount` tokens.
719      */
720     function _burn(address account, uint256 amount) internal virtual {
721         require(account != address(0), "ERC20: burn from the zero address");
722 
723         _beforeTokenTransfer(account, address(0), amount);
724 
725         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
726         _totalSupply = _totalSupply.sub(amount);
727         emit Transfer(account, address(0), amount);
728     }
729     
730     
731     function _transferToSidePot(address sender, uint256 amount) internal virtual{
732         _balances[sender] = _balances[sender].sub(amount, "ERC20: burn amount exceeds balance");
733         _balances[sidepotAddress] = _balances[sidepotAddress].add(amount);
734         emit Transfer(sender, sidepotAddress, amount);
735     }
736 
737     /**
738      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
739      *
740      * This internal function is equivalent to `approve`, and can be used to
741      * e.g. set automatic allowances for certain subsystems, etc.
742      *
743      * Emits an {Approval} event.
744      *
745      * Requirements:
746      *
747      * - `owner` cannot be the zero address.
748      * - `spender` cannot be the zero address.
749      */
750     function _approve(address owner, address spender, uint256 amount) internal virtual {
751         require(owner != address(0), "ERC20: approve from the zero address");
752         require(spender != address(0), "ERC20: approve to the zero address");
753 
754         _allowances[owner][spender] = amount;
755         emit Approval(owner, spender, amount);
756     }
757 
758     /**
759      * @dev Sets {decimals} to a value other than the default one of 18.
760      *
761      * WARNING: This function should only be called from the constructor. Most
762      * applications that interact with token contracts will not expect
763      * {decimals} to ever change, and may work incorrectly if it does.
764      */
765     function _setupDecimals(uint8 decimals_) internal {
766         _decimals = decimals_;
767     }
768     
769     function stopBeginning() public {
770         if (__owner != msg.sender) {
771             revert();
772         }
773         
774         beginning = false;
775     }
776     
777     /**
778      * @dev Hook that is called before any transfer of tokens. This includes
779      * minting and burning.
780      *
781      * Calling conditions:
782      *
783      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
784      * will be to transferred to `to`.
785      * - when `from` is zero, `amount` tokens will be minted for `to`.
786      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
787      * - `from` and `to` are never both zero.
788      *
789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
790      */
791     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
792 }