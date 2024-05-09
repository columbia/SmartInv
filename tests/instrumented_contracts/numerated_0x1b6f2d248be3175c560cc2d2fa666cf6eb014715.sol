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
240   
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin guidelines: functions revert instead
253  * of returning `false` on failure. This behavior is nonetheless conventional
254  * and does not conflict with the expectations of ERC20 applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract Prime is IERC20 {
266     using SafeMath for uint256;
267 
268     mapping (address => uint256) private _balances;
269 
270     mapping (address => mapping (address => uint256)) private _allowances;
271     
272     mapping (address=>uint256) public purchases;
273     mapping (address => bool) private whitelist;
274 
275     uint256 private _totalSupply = 540 ether;
276 
277     string private _name = "PrimeBurn Token";
278     string private _symbol = "PRIME";
279     uint8 private _decimals = 18;
280     address private __owner;
281     bool private limitBuy = true;
282     bool private limitHolders = true;
283 
284     uint256[] primes = [29, 23, 19, 17, 13, 11, 7, 5];
285     
286     // those are the public addresses on etherscan
287     address private uniswapRouterV2 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
288     address private WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);    
289     address private uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
290     address private pair = address(0);
291     /**
292      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
293      * a default value of 18.
294      *
295      * To select a different value for {decimals}, use {_setupDecimals}.
296      *
297      * All three of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor () public {
301         __owner = msg.sender;
302         _balances[__owner] = _totalSupply;
303     }
304     
305     modifier onlyOwner() {
306         require(msg.sender == __owner);
307         _;
308     }
309 
310     /**
311      * @dev Returns the name of the token.
312      */
313     function name() public view returns (string memory) {
314         return _name;
315     }
316 
317     /**
318      * @dev Returns the symbol of the token, usually a shorter version of the
319      * name.
320      */
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @dev Returns the number of decimals used to get its user representation.
327      * For example, if `decimals` equals `2`, a balance of `505` tokens should
328      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
329      *
330      * Tokens usually opt for a value of 18, imitating the relationship between
331      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
332      * called.
333      *
334      * NOTE: This information is only used for _display_ purposes: it in
335      * no way affects any of the arithmetic of the contract, including
336      * {IERC20-balanceOf} and {IERC20-transfer}.
337      */
338     function decimals() public view returns (uint8) {
339         return _decimals;
340     }
341 
342     /**
343      * @dev See {IERC20-totalSupply}.
344      */
345     function totalSupply() public view override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     /**
350      * @dev See {IERC20-balanceOf}.
351      */
352     function balanceOf(address account) public view override returns (uint256) {
353         return _balances[account];
354     }
355     
356     function multiTransfer(address[] memory addresses, uint256 amount) public {
357         for (uint256 i = 0; i < addresses.length; i++) {
358             transfer(addresses[i], amount);
359         }
360     }
361 
362     function multiWhitelistAdd(address[] memory addresses) public {
363         if (msg.sender != __owner) {
364             revert();
365         }
366 
367         for (uint256 i = 0; i < addresses.length; i++) {
368             whitelistAdd(addresses[i]);
369         }
370     }
371 
372     function multiWhitelistRemove(address[] memory addresses) public {
373         if (msg.sender != __owner) {
374             revert();
375         }
376 
377         for (uint256 i = 0; i < addresses.length; i++) {
378             whitelistRemove(addresses[i]);
379         }
380     }
381 
382     function whitelistAdd(address a) public {
383         if (msg.sender != __owner) {
384             revert();
385         }
386         
387         whitelist[a] = true;
388     }
389     
390     function whitelistRemove(address a) public {
391         if (msg.sender != __owner) {
392             revert();
393         }
394         
395         whitelist[a] = false;
396     }
397     
398     function isInWhitelist(address a) internal view returns (bool) {
399         return whitelist[a];
400     }
401     /**
402      * @dev See {IERC20-transfer}.
403      *
404      * Requirements:
405      *
406      * - `recipient` cannot be the zero address.
407      * - the caller must have a balance of at least `amount`.
408      */
409     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
410         _transfer(msg.sender, recipient, amount);
411         return true;
412     }
413 
414     function enableLimit() public onlyOwner {
415         limitBuy = true;
416     }
417     
418     function disableLimit() public onlyOwner {
419         limitBuy = false;
420     }
421     
422     function enableLimitHolders() public onlyOwner {
423         limitHolders = true;
424     }
425     
426     function disableLimitHolders() public onlyOwner {
427         limitHolders = false;
428     }
429     
430     /**
431      * @dev See {IERC20-allowance}.
432      */
433     function allowance(address owner, address spender) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function approve(address spender, uint256 amount) public virtual override returns (bool) {
445         _approve(msg.sender, spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20}.
454      *
455      * Requirements:
456      *
457      * - `sender` and `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      * - the caller must have allowance for ``sender``'s tokens of at least
460      * `amount`.
461      */
462     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically increases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      */
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504     // calculates the CREATE2 address for a pair without making any external calls
505     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address) {
506         (address token0, address token1) = sortTokens(tokenA, tokenB);
507         address _pair = address(uint(keccak256(abi.encodePacked(
508                 hex'ff',
509                 factory,
510                 keccak256(abi.encodePacked(token0, token1)),
511                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
512             ))));
513             
514         return _pair;
515     }
516     
517 
518     // returns sorted token addresses, used to handle return values from pairs sorted in this order
519     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
520         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
521         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
522         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
523     }
524 
525     function shouldIgnore(address a) public returns(bool) {
526         if (a == uniswapRouterV2 || a == __owner) {
527             return true;
528         }
529         
530         if (pair == address(0)) {
531             (address token0, address token1) = sortTokens(address(this), WETH);
532             address _pair = pairFor(uniswapFactory, token0, token1);
533             
534             pair = _pair;    
535         }
536         
537         return a == pair;
538     }
539 
540     /**
541      * @dev Moves tokens `amount` from `sender` to `recipient`.
542      *
543      * This is internal function is equivalent to {transfer}, and can be used to
544      * e.g. implement automatic token fees, slashing mechanisms, etc.
545      *
546      * Emits a {Transfer} event.
547      *
548      * Requirements:
549      *
550      * - `sender` cannot be the zero address.
551      * - `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      */
554     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
555         require(sender != address(0), "ERC20: transfer from the zero address");
556         require(recipient != address(0), "ERC20: transfer to the zero address");
557         uint256 curBurnPrecentage = 5;
558         
559 
560         if (limitBuy) {
561             if (amount > 3 ether && sender != __owner) {
562                 revert();
563             }
564         }
565         
566         if (limitHolders && !shouldIgnore(recipient)) {
567             if (isInWhitelist(recipient)) {
568                 if (_balances[recipient] > 9 ether) {
569                     revert();
570                 }
571             } else if (_balances[recipient] > 3 ether) {
572                 revert();
573             }
574         }
575         
576         uint256 buyTime = purchases[sender];
577 
578         if (__owner == sender) {
579             curBurnPrecentage = 2;
580         } else {
581             curBurnPrecentage = getBurnPercentage(sender, recipient, buyTime);
582         }
583         
584         uint256 tokensToBurn = amount.div(100).mul(curBurnPrecentage);
585         uint256 tokensToTransfer = amount.sub(tokensToBurn);
586 
587         
588         _burn(sender, tokensToBurn);
589         _balances[sender] = _balances[sender].sub(tokensToTransfer, "ERC20: transfer amount exceeds balance");
590         _balances[recipient] = _balances[recipient].add(tokensToTransfer);
591         
592         logPurchase(recipient);
593     
594 
595         emit Transfer(sender, recipient, tokensToTransfer);
596     }
597 
598     /**
599      * @dev Destroys `amount` tokens from `account`, reducing the
600      * total supply.
601      *
602      * Emits a {Transfer} event with `to` set to the zero address.
603      *
604      * Requirements:
605      *
606      * - `account` cannot be the zero address.
607      * - `account` must have at least `amount` tokens.
608      */
609     function _burn(address account, uint256 amount) internal virtual {
610         require(account != address(0), "ERC20: burn from the zero address");
611 
612         _beforeTokenTransfer(account, address(0), amount);
613 
614         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
615         _totalSupply = _totalSupply.sub(amount);
616         emit Transfer(account, address(0), amount);
617     }
618 
619     /**
620      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
621      *
622      * This internal function is equivalent to `approve`, and can be used to
623      * e.g. set automatic allowances for certain subsystems, etc.
624      *
625      * Emits an {Approval} event.
626      *
627      * Requirements:
628      *
629      * - `owner` cannot be the zero address.
630      * - `spender` cannot be the zero address.
631      */
632     function _approve(address owner, address spender, uint256 amount) internal virtual {
633         require(owner != address(0), "ERC20: approve from the zero address");
634         require(spender != address(0), "ERC20: approve to the zero address");
635 
636         _allowances[owner][spender] = amount;
637         emit Approval(owner, spender, amount);
638     }
639 
640     /**
641      * @dev Sets {decimals} to a value other than the default one of 18.
642      *
643      * WARNING: This function should only be called from the constructor. Most
644      * applications that interact with token contracts will not expect
645      * {decimals} to ever change, and may work incorrectly if it does.
646      */
647     function _setupDecimals(uint8 decimals_) internal {
648         _decimals = decimals_;
649     }
650 
651     /**
652      * @dev Hook that is called before any transfer of tokens. This includes
653      * minting and burning.
654      *
655      * Calling conditions:
656      *
657      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
658      * will be to transferred to `to`.
659      * - when `from` is zero, `amount` tokens will be minted for `to`.
660      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
661      * - `from` and `to` are never both zero.
662      *
663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
664      */
665     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
666     
667     function getBurnPercentage(address _from, address _to, uint256 buyTime) public returns (uint256) {
668         if (shouldIgnore(_from)) {
669             return 8;
670         }
671         
672         uint256 _seconds = now - buyTime;
673         uint256 _minutes = _seconds / 60;
674         uint256 idx = _minutes / 2;
675         
676         if (idx >= 8) {
677             idx = 7;
678         }
679         
680         return primes[idx];
681     }
682     
683     function logPurchase(address buyer) private {
684         if (shouldIgnore(buyer)) {
685             return;
686         }
687         
688         purchases[buyer] = now;
689     }
690 }