1 pragma solidity 0.6.11;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 // File: contracts\GSN\Context.sol
6 
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: contracts\token\ERC20\IERC20.sol
31 
32 
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: contracts\math\SafeMath.sol
109 
110 
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: contracts\token\ERC20\ERC20.sol
269 
270 
271 
272 
273 
274 
275 /**
276  * @dev Implementation of the {IERC20} interface.
277  *
278  * This implementation is agnostic to the way tokens are created. This means
279  * that a supply mechanism has to be added in a derived contract using {_mint}.
280  * For a generic mechanism see {ERC20PresetMinterPauser}.
281  *
282  * TIP: For a detailed writeup see our guide
283  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
284  * to implement supply mechanisms].
285  *
286  * We have followed general OpenZeppelin guidelines: functions revert instead
287  * of returning `false` on failure. This behavior is nonetheless conventional
288  * and does not conflict with the expectations of ERC20 applications.
289  *
290  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
291  * This allows applications to reconstruct the allowance for all accounts just
292  * by listening to said events. Other implementations of the EIP may not emit
293  * these events, as it isn't required by the specification.
294  *
295  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
296  * functions have been added to mitigate the well-known issues around setting
297  * allowances. See {IERC20-approve}.
298  */
299 contract ERC20 is Context, IERC20 {
300     using SafeMath for uint256;
301 
302     mapping (address => uint256) private _balances;
303 
304     mapping (address => mapping (address => uint256)) private _allowances;
305 
306     uint256 private _totalSupply;
307 
308     string private _name;
309     string private _symbol;
310     uint8 private _decimals;
311 
312     /**
313      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
314      * a default value of 18.
315      *
316      * To select a different value for {decimals}, use {_setupDecimals}.
317      *
318      * All three of these values are immutable: they can only be set once during
319      * construction.
320      */
321     constructor (string memory name, string memory symbol) public {
322         _name = name;
323         _symbol = symbol;
324         _decimals = 18;
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
359     /**
360      * @dev See {IERC20-totalSupply}.
361      */
362     function totalSupply() public view override returns (uint256) {
363         return _totalSupply;
364     }
365 
366     /**
367      * @dev See {IERC20-balanceOf}.
368      */
369     function balanceOf(address account) public view override returns (uint256) {
370         return _balances[account];
371     }
372 
373     /**
374      * @dev See {IERC20-transfer}.
375      *
376      * Requirements:
377      *
378      * - `recipient` cannot be the zero address.
379      * - the caller must have a balance of at least `amount`.
380      */
381     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-allowance}.
388      */
389     function allowance(address owner, address spender) public view virtual override returns (uint256) {
390         return _allowances[owner][spender];
391     }
392 
393     /**
394      * @dev See {IERC20-approve}.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount) public virtual override returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-transferFrom}.
407      *
408      * Emits an {Approval} event indicating the updated allowance. This is not
409      * required by the EIP. See the note at the beginning of {ERC20}.
410      *
411      * Requirements:
412      *
413      * - `sender` and `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      * - the caller must have allowance for ``sender``'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
419         _transfer(sender, recipient, amount);
420         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
438         return true;
439     }
440 
441     /**
442      * @dev Atomically decreases the allowance granted to `spender` by the caller.
443      *
444      * This is an alternative to {approve} that can be used as a mitigation for
445      * problems described in {IERC20-approve}.
446      *
447      * Emits an {Approval} event indicating the updated allowance.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      * - `spender` must have allowance for the caller of at least
453      * `subtractedValue`.
454      */
455     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
457         return true;
458     }
459 
460     /**
461      * @dev Moves tokens `amount` from `sender` to `recipient`.
462      *
463      * This is internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `sender` cannot be the zero address.
471      * - `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      */
474     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478         _beforeTokenTransfer(sender, recipient, amount);
479 
480         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
481         _balances[recipient] = _balances[recipient].add(amount);
482         emit Transfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply = _totalSupply.add(amount);
500         _balances[account] = _balances[account].add(amount);
501         emit Transfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
521         _totalSupply = _totalSupply.sub(amount);
522         emit Transfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(address owner, address spender, uint256 amount) internal virtual {
539         require(owner != address(0), "ERC20: approve from the zero address");
540         require(spender != address(0), "ERC20: approve to the zero address");
541 
542         _allowances[owner][spender] = amount;
543         emit Approval(owner, spender, amount);
544     }
545 
546     /**
547      * @dev Sets {decimals} to a value other than the default one of 18.
548      *
549      * WARNING: This function should only be called from the constructor. Most
550      * applications that interact with token contracts will not expect
551      * {decimals} to ever change, and may work incorrectly if it does.
552      */
553     function _setupDecimals(uint8 decimals_) internal {
554         _decimals = decimals_;
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be to transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
572 }
573 
574 // File: contracts\token\ERC20\ERC20Burnable.sol
575 
576 
577 
578 
579 
580 /**
581  * @dev Extension of {ERC20} that allows token holders to destroy both their own
582  * tokens and those that they have an allowance for, in a way that can be
583  * recognized off-chain (via event analysis).
584  */
585 abstract contract ERC20Burnable is Context, ERC20 {
586     /**
587      * @dev Destroys `amount` tokens from the caller.
588      *
589      * See {ERC20-_burn}.
590      */
591     function burn(uint256 amount) public virtual {
592         _burn(_msgSender(), amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
597      * allowance.
598      *
599      * See {ERC20-_burn} and {ERC20-allowance}.
600      *
601      * Requirements:
602      *
603      * - the caller must have allowance for ``accounts``'s tokens of at least
604      * `amount`.
605      */
606     function burnFrom(address account, uint256 amount) public virtual {
607         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
608 
609         _approve(account, _msgSender(), decreasedAllowance);
610         _burn(account, amount);
611     }
612 }
613 
614 /**
615  * @title Ownable
616  * @dev The Ownable contract has an owner address, and provides basic authorization control
617  * functions, this simplifies the implementation of "user permissions".
618  */
619 contract Ownable {
620   address public owner;
621 
622 
623   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
624 
625 
626   /**
627    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
628    * account.
629    */
630   constructor() public {
631     owner = msg.sender;
632   }
633 
634 
635   /**
636    * @dev Throws if called by any account other than the owner.
637    */
638   modifier onlyOwner() {
639     require(msg.sender == owner);
640     _;
641   }
642 
643 
644   /**
645    * @dev Allows the current owner to transfer control of the contract to a newOwner.
646    * @param newOwner The address to transfer ownership to.
647    */
648   function transferOwnership(address newOwner) onlyOwner public {
649     require(newOwner != address(0));
650     emit OwnershipTransferred(owner, newOwner);
651     owner = newOwner;
652   }
653 }
654 
655 
656 interface tokenRecipient { 
657     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
658 }
659 
660 interface OldIERC20 {
661     function transfer(address to, uint amount) external;
662 }
663 
664 interface IUniswapV2Factory {
665     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
666 
667     function feeTo() external view returns (address);
668     function feeToSetter() external view returns (address);
669     function migrator() external view returns (address);
670 
671     function getPair(address tokenA, address tokenB) external view returns (address pair);
672     function allPairs(uint) external view returns (address pair);
673     function allPairsLength() external view returns (uint);
674 
675     function createPair(address tokenA, address tokenB) external returns (address pair);
676 
677     function setFeeTo(address) external;
678     function setFeeToSetter(address) external;
679     function setMigrator(address) external;
680 }
681 
682 interface IUniswapV2Router01 {
683     function factory() external pure returns (address);
684     function WETH() external pure returns (address);
685 
686     function addLiquidity(
687         address tokenA,
688         address tokenB,
689         uint amountADesired,
690         uint amountBDesired,
691         uint amountAMin,
692         uint amountBMin,
693         address to,
694         uint deadline
695     ) external returns (uint amountA, uint amountB, uint liquidity);
696     function addLiquidityETH(
697         address token,
698         uint amountTokenDesired,
699         uint amountTokenMin,
700         uint amountETHMin,
701         address to,
702         uint deadline
703     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
704     function removeLiquidity(
705         address tokenA,
706         address tokenB,
707         uint liquidity,
708         uint amountAMin,
709         uint amountBMin,
710         address to,
711         uint deadline
712     ) external returns (uint amountA, uint amountB);
713     function removeLiquidityETH(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountToken, uint amountETH);
721     function removeLiquidityWithPermit(
722         address tokenA,
723         address tokenB,
724         uint liquidity,
725         uint amountAMin,
726         uint amountBMin,
727         address to,
728         uint deadline,
729         bool approveMax, uint8 v, bytes32 r, bytes32 s
730     ) external returns (uint amountA, uint amountB);
731     function removeLiquidityETHWithPermit(
732         address token,
733         uint liquidity,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline,
738         bool approveMax, uint8 v, bytes32 r, bytes32 s
739     ) external returns (uint amountToken, uint amountETH);
740     function swapExactTokensForTokens(
741         uint amountIn,
742         uint amountOutMin,
743         address[] calldata path,
744         address to,
745         uint deadline
746     ) external returns (uint[] memory amounts);
747     function swapTokensForExactTokens(
748         uint amountOut,
749         uint amountInMax,
750         address[] calldata path,
751         address to,
752         uint deadline
753     ) external returns (uint[] memory amounts);
754     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
755         external
756         payable
757         returns (uint[] memory amounts);
758     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
759         external
760         returns (uint[] memory amounts);
761     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
762         external
763         returns (uint[] memory amounts);
764     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
765         external
766         payable
767         returns (uint[] memory amounts);
768 
769     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
770     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
771     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
772     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
773     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
774 }
775 
776 interface IUniswapV2Router02 is IUniswapV2Router01 {
777     function removeLiquidityETHSupportingFeeOnTransferTokens(
778         address token,
779         uint liquidity,
780         uint amountTokenMin,
781         uint amountETHMin,
782         address to,
783         uint deadline
784     ) external returns (uint amountETH);
785     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
786         address token,
787         uint liquidity,
788         uint amountTokenMin,
789         uint amountETHMin,
790         address to,
791         uint deadline,
792         bool approveMax, uint8 v, bytes32 r, bytes32 s
793     ) external returns (uint amountETH);
794 
795     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
796         uint amountIn,
797         uint amountOutMin,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external;
802     function swapExactETHForTokensSupportingFeeOnTransferTokens(
803         uint amountOutMin,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external payable;
808     function swapExactTokensForETHSupportingFeeOnTransferTokens(
809         uint amountIn,
810         uint amountOutMin,
811         address[] calldata path,
812         address to,
813         uint deadline
814     ) external;
815 }
816 
817 contract SwissToken is ERC20Burnable, Ownable {
818     
819     address public fees_wallet_swiss = 0x991AC37b1cBD28131560A8e9ddb4D51F4dBcb8c9;
820     address public fees_wallet_decash = 0xF033789a125545738D1ECCf0237083E62Ff21499;
821     
822     uint public swissFeePercentX100 = 2e2;
823     uint public deshFeePercentX100 = 1e2;
824     
825     address public uniswap_pair_address;
826     uint public liquidityAdditionTime;
827     
828     IUniswapV2Router02 public uniswapRouterV2;
829     IUniswapV2Factory public uniswapFactory;
830     
831     constructor() public ERC20("Swiss Token", "SWISS") {
832         _mint(_msgSender(), 10000e18);
833         uniswapRouterV2 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
834         uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
835         uniswap_pair_address = createUniswapPairMainnet();
836     }
837     
838     // owner is supposed to be a Swiss Governance Contract
839     function setSwissFeePercentX100(uint _swissFeePercentX100) public onlyOwner {
840         swissFeePercentX100 = _swissFeePercentX100;
841     }
842     function setDeshFeePercentX100(uint _deshFeePercentX100) public onlyOwner {
843         deshFeePercentX100 = _deshFeePercentX100;
844     }
845     function setSwissFeeWallet(address _fees_wallet_swiss) public onlyOwner {
846         fees_wallet_swiss = _fees_wallet_swiss;
847     }
848     function setDecashFeeWallet(address _fees_wallet_decash) public onlyOwner {
849         fees_wallet_decash = _fees_wallet_decash;
850     }
851     
852     function startMaxBuyLimitTimer() public onlyOwner {
853         require(liquidityAdditionTime == 0, "Timer already started!");
854         liquidityAdditionTime = now;
855     }
856     
857     function createUniswapPairMainnet() public returns (address) {
858         require(uniswap_pair_address == address(0), "Token: pool already created");
859         uniswap_pair_address = uniswapFactory.createPair(
860             address(uniswapRouterV2.WETH()),
861             address(this)
862         );
863         return uniswap_pair_address;
864     }
865     
866     /**
867      * @dev See {IERC20-transfer}.
868      *
869      * Requirements:
870      *
871      * - `recipient` cannot be the zero address.
872      * - the caller must have a balance of at least `amount`.
873      */
874     function transfer(address recipient, uint256 amount) public override returns (bool) {
875         
876         if (_msgSender() == uniswap_pair_address || recipient == uniswap_pair_address) {
877             _transferWithFee(_msgSender(), recipient, amount);
878         } else {
879             _transfer(_msgSender(), recipient, amount);    
880         }
881         
882         return true;
883     }
884     
885     /**
886      * @dev See {IERC20-transferFrom}.
887      *
888      * Emits an {Approval} event indicating the updated allowance. This is not
889      * required by the EIP. See the note at the beginning of {ERC20}.
890      *
891      * Requirements:
892      *
893      * - `sender` and `recipient` cannot be the zero address.
894      * - `sender` must have a balance of at least `amount`.
895      * - the caller must have allowance for ``sender``'s tokens of at least
896      * `amount`.
897      */
898     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
899         if (sender == uniswap_pair_address || recipient == uniswap_pair_address) {
900             _transferWithFee(sender, recipient, amount);
901         } else {
902             _transfer(sender, recipient, amount);
903         }
904         _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "ERC20: transfer amount exceeds allowance"));
905         return true;
906     }
907     
908     function _transferWithFee(address sender, address recipient, uint256 amount) internal {
909         if (now < liquidityAdditionTime.add(20 minutes)) {
910             // limit buys and sells, liquidity additions and removals 
911             // if token sender is not contract owner
912             require(sender == owner || amount <= 6552e16, "Cannot transfer more than 65.52 Tokens for now!");
913         
914             // do not charge fee on initial liquidity addition
915             // owner is supposed to startMaxBuyLimitTimer before adding liquidity
916             // and then add liquidity immediately
917             if (sender == owner) {
918                 _transfer(sender, recipient, amount);
919                 return;
920             }
921         }
922         
923         uint swissFee = amount.mul(swissFeePercentX100).div(100e2);
924         uint deshFee = amount.mul(deshFeePercentX100).div(100e2);
925         uint amountAfterFee = amount.sub(swissFee).sub(deshFee);
926         
927         _transfer(sender, fees_wallet_swiss, swissFee);
928         _transfer(sender, fees_wallet_decash, deshFee);
929         _transfer(sender, recipient, amountAfterFee);
930     }
931     
932     
933     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
934         external
935         returns (bool success) 
936     {
937         tokenRecipient spender = tokenRecipient(_spender);
938         if (approve(_spender, _value)) {
939             spender.receiveApproval(msg.sender, _value, _extraData);
940             return true;
941         }
942     }
943     
944     
945     function transferAnyERC20Token(address _tokenAddress, address _to, uint _amount) public onlyOwner {
946         IERC20(_tokenAddress).transfer(_to, _amount);
947     }
948     function transferAnyOldERC20Token(address _tokenAddress, address _to, uint _amount) public onlyOwner {
949         OldIERC20(_tokenAddress).transfer(_to, _amount);
950     }
951 }