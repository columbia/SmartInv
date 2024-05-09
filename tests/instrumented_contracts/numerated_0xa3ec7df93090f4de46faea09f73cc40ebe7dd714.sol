1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-02
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later Or MIT
6 // File: contracts\Context.sol
7 
8 
9 
10 pragma solidity >=0.6.0 <0.8.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: contracts\Ownable.sol
34 
35 
36 
37 pragma solidity >=0.6.0 <0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor () internal {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 // File: contracts\IBEP20.sol
104 
105 pragma solidity >=0.6.4;
106 
107 interface IBEP20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the token decimals.
115      */
116     function decimals() external view returns (uint8);
117 
118     /**
119      * @dev Returns the token symbol.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the token name.
125      */
126     function name() external view returns (string memory);
127 
128     /**
129      * @dev Returns the bep token owner.
130      */
131     function getOwner() external view returns (address);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `recipient`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address _owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `sender` to `recipient` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 // File: contracts\SafeMath.sol
199 
200 
201 
202 pragma solidity >=0.6.0 <0.8.0;
203 
204 /**
205  * @dev Wrappers over Solidity's arithmetic operations with added overflow
206  * checks.
207  *
208  * Arithmetic operations in Solidity wrap on overflow. This can easily result
209  * in bugs, because programmers usually assume that an overflow raises an
210  * error, which is the standard behavior in high level programming languages.
211  * `SafeMath` restores this intuition by reverting the transaction when an
212  * operation overflows.
213  *
214  * Using this library instead of the unchecked operations eliminates an entire
215  * class of bugs, so it's recommended to use it always.
216  */
217 library SafeMath {
218     /**
219      * @dev Returns the addition of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `+` operator.
223      *
224      * Requirements:
225      *
226      * - Addition cannot overflow.
227      */
228     function add(uint256 a, uint256 b) internal pure returns (uint256) {
229         uint256 c = a + b;
230         require(c >= a, "SafeMath: addition overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246         return sub(a, b, "SafeMath: subtraction overflow");
247     }
248 
249     /**
250      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
251      * overflow (when the result is negative).
252      *
253      * Counterpart to Solidity's `-` operator.
254      *
255      * Requirements:
256      *
257      * - Subtraction cannot overflow.
258      */
259     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b <= a, errorMessage);
261         uint256 c = a - b;
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the multiplication of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `*` operator.
271      *
272      * Requirements:
273      *
274      * - Multiplication cannot overflow.
275      */
276     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
277         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
278         // benefit is lost if 'b' is also tested.
279         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
280         if (a == 0) {
281             return 0;
282         }
283 
284         uint256 c = a * b;
285         require(c / a == b, "SafeMath: multiplication overflow");
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers. Reverts on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return div(a, b, "SafeMath: division by zero");
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b > 0, errorMessage);
320         uint256 c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * Reverts when dividing by zero.
329      *
330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
331      * opcode (which leaves remaining gas untouched) while Solidity uses an
332      * invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
339         return mod(a, b, "SafeMath: modulo by zero");
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * Reverts with custom message when dividing by zero.
345      *
346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
347      * opcode (which leaves remaining gas untouched) while Solidity uses an
348      * invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b != 0, errorMessage);
356         return a % b;
357     }
358 }
359 
360 // File: contracts\BEP20.sol
361 
362 
363 
364 pragma solidity >=0.4.0;
365 
366 
367 
368 
369 
370 /**
371  * @dev Implementation of the {IBEP20} interface.
372  *
373  * This implementation is agnostic to the way tokens are created. This means
374  * that a supply mechanism has to be added in a derived contract using {_mint}.
375  * For a generic mechanism see {BEP20PresetMinterPauser}.
376  *
377  * TIP: For a detailed writeup see our guide
378  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
379  * to implement supply mechanisms].
380  *
381  * We have followed general OpenZeppelin guidelines: functions revert instead
382  * of returning `false` on failure. This behavior is nonetheless conventional
383  * and does not conflict with the expectations of BEP20 applications.
384  *
385  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
386  * This allows applications to reconstruct the allowance for all accounts just
387  * by listening to said events. Other implementations of the EIP may not emit
388  * these events, as it isn't required by the specification.
389  *
390  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
391  * functions have been added to mitigate the well-known issues around setting
392  * allowances. See {IBEP20-approve}.
393  */
394 contract BEP20 is Context, IBEP20, Ownable {
395     using SafeMath for uint256;
396 
397     mapping(address => uint256) private _balances;
398 
399     mapping(address => mapping(address => uint256)) private _allowances;
400 
401     uint256 private _totalSupply;
402 
403     string private _name;
404     string private _symbol;
405     uint8 private _decimals;
406 
407     /**
408      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
409      * a default value of 18.
410      *
411      * To select a different value for {decimals}, use {_setupDecimals}.
412      *
413      * All three of these values are immutable: they can only be set once during
414      * construction.
415      */
416     constructor(string memory name, string memory symbol) public {
417         _name = name;
418         _symbol = symbol;
419         _decimals = 18;
420     }
421 
422     /**
423      * @dev Returns the bep token owner.
424      */
425     function getOwner() external override view returns (address) {
426         return owner();
427     }
428 
429     /**
430      * @dev Returns the name of the token.
431      */
432     function name() public override view returns (string memory) {
433         return _name;
434     }
435 
436     /**
437      * @dev Returns the symbol of the token, usually a shorter version of the
438      * name.
439      */
440     function symbol() public override view returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445     * @dev Returns the number of decimals used to get its user representation.
446     */
447     function decimals() public override view returns (uint8) {
448         return _decimals;
449     }
450 
451     /**
452      * @dev See {BEP20-totalSupply}.
453      */
454     function totalSupply() public override view returns (uint256) {
455         return _totalSupply;
456     }
457 
458     /**
459      * @dev See {BEP20-balanceOf}.
460      */
461     function balanceOf(address account) public override view returns (uint256) {
462         return _balances[account];
463     }
464 
465     /**
466      * @dev See {BEP20-transfer}.
467      *
468      * Requirements:
469      *
470      * - `recipient` cannot be the zero address.
471      * - the caller must have a balance of at least `amount`.
472      */
473     function transfer(address recipient, uint256 amount) public override returns (bool) {
474         _transfer(_msgSender(), recipient, amount);
475         return true;
476     }
477 
478     /**
479      * @dev See {BEP20-allowance}.
480      */
481     function allowance(address owner, address spender) public override view returns (uint256) {
482         return _allowances[owner][spender];
483     }
484 
485     /**
486      * @dev See {BEP20-approve}.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function approve(address spender, uint256 amount) public override returns (bool) {
493         _approve(_msgSender(), spender, amount);
494         return true;
495     }
496 
497     /**
498      * @dev See {BEP20-transferFrom}.
499      *
500      * Emits an {Approval} event indicating the updated allowance. This is not
501      * required by the EIP. See the note at the beginning of {BEP20};
502      *
503      * Requirements:
504      * - `sender` and `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      * - the caller must have allowance for `sender`'s tokens of at least
507      * `amount`.
508      */
509     function transferFrom (address sender, address recipient, uint256 amount) public override returns (bool) {
510         _transfer(sender, recipient, amount);
511         _approve(
512             sender,
513             _msgSender(),
514             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
515         );
516         return true;
517     }
518 
519     /**
520      * @dev Atomically increases the allowance granted to `spender` by the caller.
521      *
522      * This is an alternative to {approve} that can be used as a mitigation for
523      * problems described in {BEP20-approve}.
524      *
525      * Emits an {Approval} event indicating the updated allowance.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      */
531     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
532         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
533         return true;
534     }
535 
536     /**
537      * @dev Atomically decreases the allowance granted to `spender` by the caller.
538      *
539      * This is an alternative to {approve} that can be used as a mitigation for
540      * problems described in {BEP20-approve}.
541      *
542      * Emits an {Approval} event indicating the updated allowance.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      * - `spender` must have allowance for the caller of at least
548      * `subtractedValue`.
549      */
550     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero'));
552         return true;
553     }
554 
555     /**
556      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
557      * the total supply.
558      *
559      * Requirements
560      *
561      * - `msg.sender` must be the token owner
562      */
563     function mint(uint256 amount) public onlyOwner returns (bool) {
564         _mint(_msgSender(), amount);
565         return true;
566     }
567 
568     /**
569      * @dev Moves tokens `amount` from `sender` to `recipient`.
570      *
571      * This is internal function is equivalent to {transfer}, and can be used to
572      * e.g. implement automatic token fees, slashing mechanisms, etc.
573      *
574      * Emits a {Transfer} event.
575      *
576      * Requirements:
577      *
578      * - `sender` cannot be the zero address.
579      * - `recipient` cannot be the zero address.
580      * - `sender` must have a balance of at least `amount`.
581      */
582     function _transfer (address sender, address recipient, uint256 amount) internal virtual {
583         require(sender != address(0), 'BEP20: transfer from the zero address');
584         require(recipient != address(0), 'BEP20: transfer to the zero address');
585 
586         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
587         _balances[recipient] = _balances[recipient].add(amount);
588         emit Transfer(sender, recipient, amount);
589     }
590 
591     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
592      * the total supply.
593      *
594      * Emits a {Transfer} event with `from` set to the zero address.
595      *
596      * Requirements
597      *
598      * - `to` cannot be the zero address.
599      */
600     function _mint(address account, uint256 amount) internal {
601         require(account != address(0), 'BEP20: mint to the zero address');
602 
603         _totalSupply = _totalSupply.add(amount);
604         _balances[account] = _balances[account].add(amount);
605         emit Transfer(address(0), account, amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`, reducing the
610      * total supply.
611      *
612      * Emits a {Transfer} event with `to` set to the zero address.
613      *
614      * Requirements
615      *
616      * - `account` cannot be the zero address.
617      * - `account` must have at least `amount` tokens.
618      */
619     function _burn(address account, uint256 amount) internal {
620         require(account != address(0), 'BEP20: burn from the zero address');
621 
622         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
623         _totalSupply = _totalSupply.sub(amount);
624         emit Transfer(account, address(0), amount);
625     }
626 
627     /**
628      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
629      *
630      * This is internal function is equivalent to `approve`, and can be used to
631      * e.g. set automatic allowances for certain subsystems, etc.
632      *
633      * Emits an {Approval} event.
634      *
635      * Requirements:
636      *
637      * - `owner` cannot be the zero address.
638      * - `spender` cannot be the zero address.
639      */
640     function _approve (address owner, address spender, uint256 amount) internal {
641         require(owner != address(0), 'BEP20: approve from the zero address');
642         require(spender != address(0), 'BEP20: approve to the zero address');
643 
644         _allowances[owner][spender] = amount;
645         emit Approval(owner, spender, amount);
646     }
647 
648     /**
649      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
650      * from the caller's allowance.
651      *
652      * See {_burn} and {_approve}.
653      */
654     function _burnFrom(address account, uint256 amount) internal {
655         _burn(account, amount);
656         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance'));
657     }
658 }
659 
660 // File: contracts\IUniswapV2Router01.sol
661 
662 pragma solidity >=0.6.2;
663 
664 interface IUniswapV2Router01 {
665     function factory() external pure returns (address);
666     function WETH() external pure returns (address);
667 
668     function addLiquidity(
669         address tokenA,
670         address tokenB,
671         uint amountADesired,
672         uint amountBDesired,
673         uint amountAMin,
674         uint amountBMin,
675         address to,
676         uint deadline
677     ) external returns (uint amountA, uint amountB, uint liquidity);
678     function addLiquidityETH(
679         address token,
680         uint amountTokenDesired,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline
685     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
686     function removeLiquidity(
687         address tokenA,
688         address tokenB,
689         uint liquidity,
690         uint amountAMin,
691         uint amountBMin,
692         address to,
693         uint deadline
694     ) external returns (uint amountA, uint amountB);
695     function removeLiquidityETH(
696         address token,
697         uint liquidity,
698         uint amountTokenMin,
699         uint amountETHMin,
700         address to,
701         uint deadline
702     ) external returns (uint amountToken, uint amountETH);
703     function removeLiquidityWithPermit(
704         address tokenA,
705         address tokenB,
706         uint liquidity,
707         uint amountAMin,
708         uint amountBMin,
709         address to,
710         uint deadline,
711         bool approveMax, uint8 v, bytes32 r, bytes32 s
712     ) external returns (uint amountA, uint amountB);
713     function removeLiquidityETHWithPermit(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline,
720         bool approveMax, uint8 v, bytes32 r, bytes32 s
721     ) external returns (uint amountToken, uint amountETH);
722     function swapExactTokensForTokens(
723         uint amountIn,
724         uint amountOutMin,
725         address[] calldata path,
726         address to,
727         uint deadline
728     ) external returns (uint[] memory amounts);
729     function swapTokensForExactTokens(
730         uint amountOut,
731         uint amountInMax,
732         address[] calldata path,
733         address to,
734         uint deadline
735     ) external returns (uint[] memory amounts);
736     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
737         external
738         payable
739         returns (uint[] memory amounts);
740     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
741         external
742         returns (uint[] memory amounts);
743     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
744         external
745         returns (uint[] memory amounts);
746     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
747         external
748         payable
749         returns (uint[] memory amounts);
750 
751     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
752     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
753     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
754     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
755     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
756 }
757 
758 // File: contracts\IUniswapV2Router02.sol
759 
760 pragma solidity >=0.6.2;
761 
762 
763 interface IUniswapV2Router02 is IUniswapV2Router01 {
764     function removeLiquidityETHSupportingFeeOnTransferTokens(
765         address token,
766         uint liquidity,
767         uint amountTokenMin,
768         uint amountETHMin,
769         address to,
770         uint deadline
771     ) external returns (uint amountETH);
772     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
773         address token,
774         uint liquidity,
775         uint amountTokenMin,
776         uint amountETHMin,
777         address to,
778         uint deadline,
779         bool approveMax, uint8 v, bytes32 r, bytes32 s
780     ) external returns (uint amountETH);
781 
782     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external;
789     function swapExactETHForTokensSupportingFeeOnTransferTokens(
790         uint amountOutMin,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external payable;
795     function swapExactTokensForETHSupportingFeeOnTransferTokens(
796         uint amountIn,
797         uint amountOutMin,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external;
802 }
803 
804 // File: contracts\IUniswapV2Pair.sol
805 
806 pragma solidity >=0.5.0;
807 
808 interface IUniswapV2Pair {
809     event Approval(address indexed owner, address indexed spender, uint value);
810     event Transfer(address indexed from, address indexed to, uint value);
811 
812     function name() external pure returns (string memory);
813     function symbol() external pure returns (string memory);
814     function decimals() external pure returns (uint8);
815     function totalSupply() external view returns (uint);
816     function balanceOf(address owner) external view returns (uint);
817     function allowance(address owner, address spender) external view returns (uint);
818 
819     function approve(address spender, uint value) external returns (bool);
820     function transfer(address to, uint value) external returns (bool);
821     function transferFrom(address from, address to, uint value) external returns (bool);
822 
823     function DOMAIN_SEPARATOR() external view returns (bytes32);
824     function PERMIT_TYPEHASH() external pure returns (bytes32);
825     function nonces(address owner) external view returns (uint);
826 
827     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
828 
829     event Mint(address indexed sender, uint amount0, uint amount1);
830     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
831     event Swap(
832         address indexed sender,
833         uint amount0In,
834         uint amount1In,
835         uint amount0Out,
836         uint amount1Out,
837         address indexed to
838     );
839     event Sync(uint112 reserve0, uint112 reserve1);
840 
841     function MINIMUM_LIQUIDITY() external pure returns (uint);
842     function factory() external view returns (address);
843     function token0() external view returns (address);
844     function token1() external view returns (address);
845     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
846     function price0CumulativeLast() external view returns (uint);
847     function price1CumulativeLast() external view returns (uint);
848     function kLast() external view returns (uint);
849 
850     function mint(address to) external returns (uint liquidity);
851     function burn(address to) external returns (uint amount0, uint amount1);
852     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
853     function skim(address to) external;
854     function sync() external;
855 
856     function initialize(address, address) external;
857 }
858 
859 // File: contracts\IUniswapV2Factory.sol
860 
861 pragma solidity >=0.5.0;
862 
863 interface IUniswapV2Factory {
864     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
865 
866     function feeTo() external view returns (address);
867     function feeToSetter() external view returns (address);
868 
869     function getPair(address tokenA, address tokenB) external view returns (address pair);
870     function allPairs(uint) external view returns (address pair);
871     function allPairsLength() external view returns (uint);
872 
873     function createPair(address tokenA, address tokenB) external returns (address pair);
874 
875     function setFeeTo(address) external;
876     function setFeeToSetter(address) external;
877 }
878 
879 // File: contracts\WUKONGToken.sol
880 
881 pragma solidity 0.6.12;
882 
883 
884 
885 
886 
887 library EnumerableSet {
888     // To implement this library for multiple types with as little code
889     // repetition as possible, we write it in terms of a generic Set type with
890     // bytes32 values.
891     // The Set implementation uses private functions, and user-facing
892     // implementations (such as AddressSet) are just wrappers around the
893     // underlying Set.
894     // This means that we can only create new EnumerableSets for types that fit
895     // in bytes32.
896 
897     struct Set {
898         // Storage of set values
899         bytes32[] _values;
900         // Position of the value in the `values` array, plus 1 because index 0
901         // means a value is not in the set.
902         mapping(bytes32 => uint256) _indexes;
903     }
904 
905     /**
906      * @dev Add a value to a set. O(1).
907      *
908      * Returns true if the value was added to the set, that is if it was not
909      * already present.
910      */
911     function _add(Set storage set, bytes32 value) private returns (bool) {
912         if (!_contains(set, value)) {
913             set._values.push(value);
914             // The value is stored at length-1, but we add 1 to all indexes
915             // and use 0 as a sentinel value
916             set._indexes[value] = set._values.length;
917             return true;
918         } else {
919             return false;
920         }
921     }
922 
923     /**
924      * @dev Removes a value from a set. O(1).
925      *
926      * Returns true if the value was removed from the set, that is if it was
927      * present.
928      */
929     function _remove(Set storage set, bytes32 value) private returns (bool) {
930         // We read and store the value's index to prevent multiple reads from the same storage slot
931         uint256 valueIndex = set._indexes[value];
932 
933         if (valueIndex != 0) {
934             // Equivalent to contains(set, value)
935             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
936             // the array, and then remove the last element (sometimes called as 'swap and pop').
937             // This modifies the order of the array, as noted in {at}.
938 
939             uint256 toDeleteIndex = valueIndex - 1;
940             uint256 lastIndex = set._values.length - 1;
941 
942             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
943             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
944 
945             bytes32 lastvalue = set._values[lastIndex];
946 
947             // Move the last value to the index where the value to delete is
948             set._values[toDeleteIndex] = lastvalue;
949             // Update the index for the moved value
950             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
951 
952             // Delete the slot where the moved value was stored
953             set._values.pop();
954 
955             // Delete the index for the deleted slot
956             delete set._indexes[value];
957 
958             return true;
959         } else {
960             return false;
961         }
962     }
963 
964     /**
965      * @dev Returns true if the value is in the set. O(1).
966      */
967     function _contains(Set storage set, bytes32 value) private view returns (bool) {
968         return set._indexes[value] != 0;
969     }
970 
971     /**
972      * @dev Returns the number of values on the set. O(1).
973      */
974     function _length(Set storage set) private view returns (uint256) {
975         return set._values.length;
976     }
977 
978     /**
979      * @dev Returns the value stored at position `index` in the set. O(1).
980      *
981      * Note that there are no guarantees on the ordering of values inside the
982      * array, and it may change when more values are added or removed.
983      *
984      * Requirements:
985      *
986      * - `index` must be strictly less than {length}.
987      */
988     function _at(Set storage set, uint256 index) private view returns (bytes32) {
989         require(set._values.length > index, 'EnumerableSet: index out of bounds');
990         return set._values[index];
991     }
992 
993     // AddressSet
994 
995     struct AddressSet {
996         Set _inner;
997     }
998 
999     /**
1000      * @dev Add a value to a set. O(1).
1001      *
1002      * Returns true if the value was added to the set, that is if it was not
1003      * already present.
1004      */
1005     function add(AddressSet storage set, address value) internal returns (bool) {
1006         return _add(set._inner, bytes32(uint256(value)));
1007     }
1008 
1009     /**
1010      * @dev Removes a value from a set. O(1).
1011      *
1012      * Returns true if the value was removed from the set, that is if it was
1013      * present.
1014      */
1015     function remove(AddressSet storage set, address value) internal returns (bool) {
1016         return _remove(set._inner, bytes32(uint256(value)));
1017     }
1018 
1019     /**
1020      * @dev Returns true if the value is in the set. O(1).
1021      */
1022     function contains(AddressSet storage set, address value) internal view returns (bool) {
1023         return _contains(set._inner, bytes32(uint256(value)));
1024     }
1025 
1026     /**
1027      * @dev Returns the number of values in the set. O(1).
1028      */
1029     function length(AddressSet storage set) internal view returns (uint256) {
1030         return _length(set._inner);
1031     }
1032 
1033     /**
1034      * @dev Returns the value stored at position `index` in the set. O(1).
1035      *
1036      * Note that there are no guarantees on the ordering of values inside the
1037      * array, and it may change when more values are added or removed.
1038      *
1039      * Requirements:
1040      *
1041      * - `index` must be strictly less than {length}.
1042      */
1043     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1044         return address(uint256(_at(set._inner, index)));
1045     }
1046 
1047     // UintSet
1048 
1049     struct UintSet {
1050         Set _inner;
1051     }
1052 
1053     /**
1054      * @dev Add a value to a set. O(1).
1055      *
1056      * Returns true if the value was added to the set, that is if it was not
1057      * already present.
1058      */
1059     function add(UintSet storage set, uint256 value) internal returns (bool) {
1060         return _add(set._inner, bytes32(value));
1061     }
1062 
1063     /**
1064      * @dev Removes a value from a set. O(1).
1065      *
1066      * Returns true if the value was removed from the set, that is if it was
1067      * present.
1068      */
1069     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1070         return _remove(set._inner, bytes32(value));
1071     }
1072 
1073     /**
1074      * @dev Returns true if the value is in the set. O(1).
1075      */
1076     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1077         return _contains(set._inner, bytes32(value));
1078     }
1079 
1080     /**
1081      * @dev Returns the number of values on the set. O(1).
1082      */
1083     function length(UintSet storage set) internal view returns (uint256) {
1084         return _length(set._inner);
1085     }
1086 
1087     /**
1088      * @dev Returns the value stored at position `index` in the set. O(1).
1089      *
1090      * Note that there are no guarantees on the ordering of values inside the
1091      * array, and it may change when more values are added or removed.
1092      *
1093      * Requirements:
1094      *
1095      * - `index` must be strictly less than {length}.
1096      */
1097     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1098         return uint256(_at(set._inner, index));
1099     }
1100 }
1101 
1102 // MonkeyKing with Governance.
1103 contract MonkeyKing is BEP20 {
1104     // Transfer tax rate in basis points. (default 1%)
1105     uint16 public transferTaxRate = 100;
1106 
1107     // Burn rate % of transfer tax. (default 20% x 1% = 0.2% of total amount).
1108     uint16 public burnRate = 20;
1109     // Max transfer tax rate: 10%.
1110     uint16 public constant MAXIMUM_TRANSFER_TAX_RATE = 1000;
1111     // Burn address
1112     address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1113 
1114     // Max transfer amount rate in basis points. (default is 0.00012% of total supply)
1115     uint16 public maxTransferAmountRate = 12;
1116     // Addresses that excluded from antiWhale
1117     mapping(address => bool) private _excludedFromAntiWhale;
1118     // Automatic swap and liquify enabled
1119     bool public swapAndLiquifyEnabled = false;    
1120     // Min amount to liquify. (default 500 WUKONGs)
1121     uint256 public minAmountToLiquify = 500 ether;
1122     // The swap router, modifiable. Will be changed to Wukong's router when our own AMM release
1123     IUniswapV2Router02 public wukongRouter;
1124     // The trading pair
1125     address public wukongPair;
1126     // In swap and liquify
1127     bool private _inSwapAndLiquify;
1128 
1129     // The operator can only update the transfer tax rate
1130     address private _operator;
1131 
1132     EnumerableSet.AddressSet private _minters;
1133     EnumerableSet.AddressSet private _blockAddrs;
1134 
1135     // Open Trade
1136     bool public tradingOpen;
1137     // Max Wallet Size
1138     uint256 public _maxWalletSize = 1000000*10**18; //1M
1139 
1140     // Events
1141     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
1142     event TransferTaxRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1143     event BurnRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1144     event MaxTransferAmountRateUpdated(address indexed operator, uint256 previousRate, uint256 newRate);
1145     event SwapAndLiquifyEnabledUpdated(address indexed operator, bool enabled);
1146     event MinAmountToLiquifyUpdated(address indexed operator, uint256 previousAmount, uint256 newAmount);
1147     event WukongRouterUpdated(address indexed operator, address indexed router, address indexed pair);
1148     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
1149 
1150     modifier onlyOperator() {
1151         require(_operator == msg.sender, "operator: caller is not the operator");
1152         _;
1153     }
1154 
1155     //Check all wale activity here
1156     modifier antiWhale(address sender, address recipient, uint256 amount) {
1157         if (
1158             _excludedFromAntiWhale[sender] == false
1159             && _excludedFromAntiWhale[recipient] == false
1160         ) {
1161             //Check Max Transfer
1162             require(amount <= maxTransferAmount(), "WUKONG::antiWhale: Transfer amount exceeds the maxTransferAmount");
1163             
1164             //Check Max Wallet at buy
1165             if(sender == wukongPair && recipient != address(wukongRouter)) {
1166                 require(balanceOf(recipient) + amount < _maxWalletSize, "Balance exceeds wallet size!");
1167             }
1168 
1169             //Check open trade
1170             require(tradingOpen, "Trading is not open");
1171         }
1172         _;
1173     }
1174 
1175     modifier lockTheSwap {
1176         _inSwapAndLiquify = true;
1177         _;
1178         _inSwapAndLiquify = false;
1179     }
1180 
1181     modifier transferTaxFree {
1182         uint16 _transferTaxRate = transferTaxRate;
1183         transferTaxRate = 0;
1184         _;
1185         transferTaxRate = _transferTaxRate;
1186     }
1187 
1188     /**
1189      * @notice Constructs the WUKONG Token contract.
1190      */
1191     constructor() public BEP20("Monkey King", "WUKONG") {
1192         _operator = _msgSender();
1193         emit OperatorTransferred(address(0), _operator);
1194 
1195         _excludedFromAntiWhale[msg.sender] = true;
1196         _excludedFromAntiWhale[address(0)] = true;
1197         _excludedFromAntiWhale[address(this)] = true;
1198         _excludedFromAntiWhale[BURN_ADDRESS] = true;
1199     }
1200 
1201     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1202     function mint(address _to, uint256 _amount) public onlyMinter returns(bool) {
1203         _mint(_to, _amount);
1204         _moveDelegates(address(0), _delegates[_to], _amount);
1205         return true;
1206     }
1207 
1208     /// @dev overrides transfer function to meet tokenomics of WUKONG
1209     function _transfer(address sender, address recipient, uint256 amount) internal virtual override antiWhale(sender, recipient, amount) {
1210         require(sender != address(0), "WUKONG::sender is not valid");
1211 
1212         //Check Block Addr
1213         require(!isBlockAddr(sender), "sender can't be blockaddr");
1214         require(!isBlockAddr(recipient), "recipient can't be blockaddr");
1215 
1216         // swap and liquify
1217         if (
1218             swapAndLiquifyEnabled == true
1219             && _inSwapAndLiquify == false
1220             && address(wukongRouter) != address(0)
1221             && wukongPair != address(0)
1222             && sender != wukongPair
1223             && sender != owner()
1224         ) {
1225             swapAndLiquify();
1226         }
1227 
1228         if (recipient == BURN_ADDRESS || transferTaxRate == 0) {
1229             super._transfer(sender, recipient, amount);
1230             if (recipient != BURN_ADDRESS) {
1231                 _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1232             }
1233         } else {
1234             // default tax is 5% of every transfer
1235             uint256 taxAmount = amount.mul(transferTaxRate).div(10000);
1236             uint256 burnAmount = taxAmount.mul(burnRate).div(100);
1237             uint256 liquidityAmount = taxAmount.sub(burnAmount);
1238             require(taxAmount == burnAmount + liquidityAmount, "WUKONG::transfer: Burn value invalid");
1239 
1240             // default 95% of transfer sent to recipient
1241             uint256 sendAmount = amount.sub(taxAmount);
1242             require(amount == sendAmount + taxAmount, "WUKONG::transfer: Tax value invalid");
1243 
1244             super._transfer(sender, BURN_ADDRESS, burnAmount);
1245             super._transfer(sender, address(this), liquidityAmount);
1246             super._transfer(sender, recipient, sendAmount);
1247             _moveDelegates(_delegates[sender], _delegates[recipient], sendAmount);
1248             amount = sendAmount;
1249         }
1250     }
1251 
1252     /// @dev Swap and liquify
1253     function swapAndLiquify() private lockTheSwap transferTaxFree {
1254         uint256 contractTokenBalance = balanceOf(address(this));
1255         uint256 maxTransferAmount = maxTransferAmount();
1256         contractTokenBalance = contractTokenBalance > maxTransferAmount ? maxTransferAmount : contractTokenBalance;
1257 
1258         if (contractTokenBalance >= minAmountToLiquify) {
1259             // only min amount to liquify
1260             uint256 liquifyAmount = minAmountToLiquify;
1261 
1262             // split the liquify amount into halves
1263             uint256 half = liquifyAmount.div(2);
1264             uint256 otherHalf = liquifyAmount.sub(half);
1265 
1266             // capture the contract's current ETH balance.
1267             // this is so that we can capture exactly the amount of ETH that the
1268             // swap creates, and not make the liquidity event include any ETH that
1269             // has been manually sent to the contract
1270             uint256 initialBalance = address(this).balance;
1271 
1272             // swap tokens for ETH
1273             swapTokensForEth(half);
1274 
1275             // how much ETH did we just swap into?
1276             uint256 newBalance = address(this).balance.sub(initialBalance);
1277 
1278             // add liquidity
1279             addLiquidity(otherHalf, newBalance);
1280 
1281             emit SwapAndLiquify(half, newBalance, otherHalf);
1282         }
1283     }
1284 
1285     /// @dev Swap tokens for eth
1286     function swapTokensForEth(uint256 tokenAmount) private {
1287         // generate the wukong pair path of token -> weth
1288         address[] memory path = new address[](2);
1289         path[0] = address(this);
1290         path[1] = wukongRouter.WETH();
1291 
1292         _approve(address(this), address(wukongRouter), tokenAmount);
1293 
1294         // make the swap
1295         wukongRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1296             tokenAmount,
1297             0, // accept any amount of ETH
1298             path,
1299             address(this),
1300             block.timestamp
1301         );
1302     }
1303 
1304     /// @dev Add liquidity
1305     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1306         // approve token transfer to cover all possible scenarios
1307         _approve(address(this), address(wukongRouter), tokenAmount);
1308 
1309         // add the liquidity
1310         wukongRouter.addLiquidityETH{value: ethAmount}(
1311             address(this),
1312             tokenAmount,
1313             0, // slippage is unavoidable
1314             0, // slippage is unavoidable
1315             operator(),
1316             block.timestamp
1317         );
1318     }
1319 
1320     /**
1321      * @dev Returns the max transfer amount.
1322      */
1323     function maxTransferAmount() public view returns (uint256) {
1324         return totalSupply().mul(maxTransferAmountRate).div(10000000);
1325     }
1326 
1327     /**
1328      * @dev Returns the address is excluded from antiWhale or not.
1329      */
1330     function isExcludedFromAntiWhale(address _account) public view returns (bool) {
1331         return _excludedFromAntiWhale[_account];
1332     }
1333 
1334     // To receive BNB from wukongRouter when swapping
1335     receive() external payable {}
1336 
1337     /**
1338      * @dev Update the transfer tax rate.
1339      * Can only be called by the current operator.
1340      */
1341     function updateTransferTaxRate(uint16 _transferTaxRate) public onlyOperator {
1342         require(_transferTaxRate <= MAXIMUM_TRANSFER_TAX_RATE, "WUKONG::updateTransferTaxRate: Transfer tax rate must not exceed the maximum rate.");
1343         emit TransferTaxRateUpdated(msg.sender, transferTaxRate, _transferTaxRate);
1344         transferTaxRate = _transferTaxRate;
1345     }
1346 
1347     /**
1348      * @dev Update the burn rate.
1349      * Can only be called by the current operator.
1350      */
1351     function updateBurnRate(uint16 _burnRate) public onlyOperator {
1352         require(_burnRate <= 100, "WUKONG::updateBurnRate: Burn rate must not exceed the maximum rate.");
1353         emit BurnRateUpdated(msg.sender, burnRate, _burnRate);
1354         burnRate = _burnRate;
1355     }
1356 
1357     /**
1358      * @dev Update the max transfer amount rate.
1359      * Can only be called by the current operator.
1360      */
1361     function updateMaxTransferAmountRate(uint16 _maxTransferAmountRate) public onlyOperator {
1362         require(_maxTransferAmountRate <= 10000, "WUKONG::updateMaxTransferAmountRate: Max transfer amount rate must not exceed the maximum rate.");
1363         emit MaxTransferAmountRateUpdated(msg.sender, maxTransferAmountRate, _maxTransferAmountRate);
1364         maxTransferAmountRate = _maxTransferAmountRate;
1365     }
1366 
1367     /**
1368      * @dev Update the min amount to liquify.
1369      * Can only be called by the current operator.
1370      */
1371     function updateMinAmountToLiquify(uint256 _minAmount) public onlyOperator {
1372         emit MinAmountToLiquifyUpdated(msg.sender, minAmountToLiquify, _minAmount);
1373         minAmountToLiquify = _minAmount;
1374     }
1375 
1376     /**
1377      * @dev Exclude or include an address from antiWhale.
1378      * Can only be called by the current operator.
1379      */
1380     function setExcludedFromAntiWhale(address _account, bool _excluded) public onlyOperator {
1381         _excludedFromAntiWhale[_account] = _excluded;
1382     }
1383 
1384     /**
1385      * @dev Update the swapAndLiquifyEnabled.
1386      * Can only be called by the current operator.
1387      */
1388     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOperator {
1389         emit SwapAndLiquifyEnabledUpdated(msg.sender, _enabled);
1390         swapAndLiquifyEnabled = _enabled;
1391     }
1392 
1393     /**
1394      * @dev Update the swap router.
1395      * Can only be called by the current operator.
1396      */
1397     function updateWukongRouter(address _router) public onlyOperator {
1398         wukongRouter = IUniswapV2Router02(_router);
1399         wukongPair = IUniswapV2Factory(wukongRouter.factory()).getPair(address(this), wukongRouter.WETH());
1400         require(wukongPair != address(0), "WUKONG::updateWukongRouter: Invalid pair address.");
1401         emit WukongRouterUpdated(msg.sender, address(wukongRouter), wukongPair);
1402     }
1403 
1404     /**
1405      * @dev Returns the address of the current operator.
1406      */
1407     function operator() public view returns (address) {
1408         return _operator;
1409     }
1410 
1411     /**
1412      * @dev Transfers operator of the contract to a new account (`newOperator`).
1413      * Can only be called by the current operator.
1414      */
1415     function transferOperator(address newOperator) public onlyOperator {
1416         require(newOperator != address(0), "WUKONG::transferOperator: new operator is the zero address");
1417         emit OperatorTransferred(_operator, newOperator);
1418         _operator = newOperator;
1419     }
1420 
1421     // Copied and modified from YAM code:
1422     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1423     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1424     // Which is copied and modified from COMPOUND:
1425     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1426 
1427     /// @dev A record of each accounts delegate
1428     mapping (address => address) internal _delegates;
1429 
1430     /// @notice A checkpoint for marking number of votes from a given block
1431     struct Checkpoint {
1432         uint32 fromBlock;
1433         uint256 votes;
1434     }
1435 
1436     /// @notice A record of votes checkpoints for each account, by index
1437     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1438 
1439     /// @notice The number of checkpoints for each account
1440     mapping (address => uint32) public numCheckpoints;
1441 
1442     /// @notice The EIP-712 typehash for the contract's domain
1443     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1444 
1445     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1446     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1447 
1448     /// @notice A record of states for signing / validating signatures
1449     mapping (address => uint) public nonces;
1450 
1451       /// @notice An event thats emitted when an account changes its delegate
1452     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1453 
1454     /// @notice An event thats emitted when a delegate account's vote balance changes
1455     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1456 
1457     /**
1458      * @notice Delegate votes from `msg.sender` to `delegatee`
1459      * @param delegator The address to get delegatee for
1460      */
1461     function delegates(address delegator)
1462         external
1463         view
1464         returns (address)
1465     {
1466         return _delegates[delegator];
1467     }
1468 
1469    /**
1470     * @notice Delegate votes from `msg.sender` to `delegatee`
1471     * @param delegatee The address to delegate votes to
1472     */
1473     function delegate(address delegatee) external {
1474         return _delegate(msg.sender, delegatee);
1475     }
1476 
1477     /**
1478      * @notice Delegates votes from signatory to `delegatee`
1479      * @param delegatee The address to delegate votes to
1480      * @param nonce The contract state required to match the signature
1481      * @param expiry The time at which to expire the signature
1482      * @param v The recovery byte of the signature
1483      * @param r Half of the ECDSA signature pair
1484      * @param s Half of the ECDSA signature pair
1485      */
1486     function delegateBySig(
1487         address delegatee,
1488         uint nonce,
1489         uint expiry,
1490         uint8 v,
1491         bytes32 r,
1492         bytes32 s
1493     )
1494         external
1495     {
1496         bytes32 domainSeparator = keccak256(
1497             abi.encode(
1498                 DOMAIN_TYPEHASH,
1499                 keccak256(bytes(name())),
1500                 getChainId(),
1501                 address(this)
1502             )
1503         );
1504 
1505         bytes32 structHash = keccak256(
1506             abi.encode(
1507                 DELEGATION_TYPEHASH,
1508                 delegatee,
1509                 nonce,
1510                 expiry
1511             )
1512         );
1513 
1514         bytes32 digest = keccak256(
1515             abi.encodePacked(
1516                 "\x19\x01",
1517                 domainSeparator,
1518                 structHash
1519             )
1520         );
1521 
1522         address signatory = ecrecover(digest, v, r, s);
1523         require(signatory != address(0), "WUKONG::delegateBySig: invalid signature");
1524         require(nonce == nonces[signatory]++, "WUKONG::delegateBySig: invalid nonce");
1525         require(now <= expiry, "WUKONG::delegateBySig: signature expired");
1526         return _delegate(signatory, delegatee);
1527     }
1528 
1529     /**
1530      * @notice Gets the current votes balance for `account`
1531      * @param account The address to get votes balance
1532      * @return The number of current votes for `account`
1533      */
1534     function getCurrentVotes(address account)
1535         external
1536         view
1537         returns (uint256)
1538     {
1539         uint32 nCheckpoints = numCheckpoints[account];
1540         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1541     }
1542 
1543     /**
1544      * @notice Determine the prior number of votes for an account as of a block number
1545      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1546      * @param account The address of the account to check
1547      * @param blockNumber The block number to get the vote balance at
1548      * @return The number of votes the account had as of the given block
1549      */
1550     function getPriorVotes(address account, uint blockNumber)
1551         external
1552         view
1553         returns (uint256)
1554     {
1555         require(blockNumber < block.number, "WUKONG::getPriorVotes: not yet determined");
1556 
1557         uint32 nCheckpoints = numCheckpoints[account];
1558         if (nCheckpoints == 0) {
1559             return 0;
1560         }
1561 
1562         // First check most recent balance
1563         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1564             return checkpoints[account][nCheckpoints - 1].votes;
1565         }
1566 
1567         // Next check implicit zero balance
1568         if (checkpoints[account][0].fromBlock > blockNumber) {
1569             return 0;
1570         }
1571 
1572         uint32 lower = 0;
1573         uint32 upper = nCheckpoints - 1;
1574         while (upper > lower) {
1575             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1576             Checkpoint memory cp = checkpoints[account][center];
1577             if (cp.fromBlock == blockNumber) {
1578                 return cp.votes;
1579             } else if (cp.fromBlock < blockNumber) {
1580                 lower = center;
1581             } else {
1582                 upper = center - 1;
1583             }
1584         }
1585         return checkpoints[account][lower].votes;
1586     }
1587 
1588     function _delegate(address delegator, address delegatee)
1589         internal
1590     {
1591         address currentDelegate = _delegates[delegator];
1592         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying WUKONGs (not scaled);
1593         _delegates[delegator] = delegatee;
1594 
1595         emit DelegateChanged(delegator, currentDelegate, delegatee);
1596 
1597         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1598     }
1599 
1600     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1601         if (srcRep != dstRep && amount > 0) {
1602             if (srcRep != address(0)) {
1603                 // decrease old representative
1604                 uint32 srcRepNum = numCheckpoints[srcRep];
1605                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1606                 uint256 srcRepNew = srcRepOld.sub(amount);
1607                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1608             }
1609 
1610             if (dstRep != address(0)) {
1611                 // increase new representative
1612                 uint32 dstRepNum = numCheckpoints[dstRep];
1613                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1614                 uint256 dstRepNew = dstRepOld.add(amount);
1615                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1616             }
1617         }
1618     }
1619 
1620     function _writeCheckpoint(
1621         address delegatee,
1622         uint32 nCheckpoints,
1623         uint256 oldVotes,
1624         uint256 newVotes
1625     )
1626         internal
1627     {
1628         uint32 blockNumber = safe32(block.number, "WUKONG::_writeCheckpoint: block number exceeds 32 bits");
1629 
1630         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1631             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1632         } else {
1633             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1634             numCheckpoints[delegatee] = nCheckpoints + 1;
1635         }
1636 
1637         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1638     }
1639 
1640     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1641         require(n < 2**32, errorMessage);
1642         return uint32(n);
1643     }
1644 
1645     function getChainId() internal pure returns (uint) {
1646         uint256 chainId;
1647         assembly { chainId := chainid() }
1648         return chainId;
1649     }
1650 
1651     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1652         require(_addMinter != address(0), "WUKONG: _addMinter is the zero address");
1653         return EnumerableSet.add(_minters, _addMinter);
1654     }
1655 
1656     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1657         require(_delMinter != address(0), "WUKONG: _delMinter is the zero address");
1658         return EnumerableSet.remove(_minters, _delMinter);
1659     }
1660 
1661     function getMinterLength() public view returns (uint256) {
1662         return EnumerableSet.length(_minters);
1663     }
1664 
1665     function isMinter(address account) public view returns (bool) {
1666         return EnumerableSet.contains(_minters, account);
1667     }
1668 
1669     function getMinter(uint256 _index) public view onlyOwner returns (address){
1670         require(_index <= getMinterLength() - 1, "WUKONG: index out of bounds");
1671         return EnumerableSet.at(_minters, _index);
1672     }
1673 
1674     // modifier for mint function
1675     modifier onlyMinter() {
1676         require(isMinter(msg.sender), "caller is not the minter");
1677         _;
1678     }
1679     
1680     function addBlockAddr(address _addBlockAddr) public onlyOwner returns (bool) {
1681         require(_addBlockAddr != address(0), "WUKONG: _addBlockAddr is the zero address");
1682         return EnumerableSet.add(_blockAddrs, _addBlockAddr);
1683     }
1684 
1685     function delBlockAddr(address _delblockAddr) public onlyOwner returns (bool) {
1686         require(_delblockAddr != address(0), "WUKONG: _delblockAddr is the zero address");
1687         return EnumerableSet.remove(_blockAddrs, _delblockAddr);
1688     }
1689 
1690     function getBlockAddrLength() public view returns (uint256) {
1691         return EnumerableSet.length(_blockAddrs);
1692     }
1693 
1694     function isBlockAddr(address account) public view returns (bool) {
1695         return EnumerableSet.contains(_blockAddrs, account);
1696     }
1697 
1698     function getBlockAddr(uint256 _index) public view onlyOwner returns (address){
1699         require(_index <= getBlockAddrLength() - 1, "WUKONG: index out of bounds");
1700         return EnumerableSet.at(_blockAddrs, _index);
1701     }
1702 
1703     // Set trading
1704     function setTrading(bool _tradingOpen) public onlyOwner {
1705         tradingOpen = _tradingOpen;
1706     }
1707 
1708     function setMaxWalletAmount(uint256 maxWalletSize) public onlyOwner() {
1709         _maxWalletSize = maxWalletSize;
1710     }
1711 
1712     // Airdrop
1713     function multiSend(address[] calldata addresses, uint256[] calldata amounts) external {
1714         require(addresses.length == amounts.length, "Must be the same length");
1715         for(uint256 i = 0; i < addresses.length; i++){
1716             _transfer(_msgSender(), addresses[i], amounts[i] * 10**18);
1717         }
1718     }
1719     
1720 }