1 // https://t.me/zlda_coin
2 // https://www.zlda.xyz
3 // https://twitter.com/ZLDACOIN
4 
5 // File: contracts/IUniswapV2Router01.sol
6 
7 pragma solidity >=0.6.2;
8 
9 interface IUniswapV2Router01 {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12 
13     function addLiquidity(
14         address tokenA,
15         address tokenB,
16         uint amountADesired,
17         uint amountBDesired,
18         uint amountAMin,
19         uint amountBMin,
20         address to,
21         uint deadline
22     ) external returns (uint amountA, uint amountB, uint liquidity);
23     function addLiquidityETH(
24         address token,
25         uint amountTokenDesired,
26         uint amountTokenMin,
27         uint amountETHMin,
28         address to,
29         uint deadline
30     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
31     function removeLiquidity(
32         address tokenA,
33         address tokenB,
34         uint liquidity,
35         uint amountAMin,
36         uint amountBMin,
37         address to,
38         uint deadline
39     ) external returns (uint amountA, uint amountB);
40     function removeLiquidityETH(
41         address token,
42         uint liquidity,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountToken, uint amountETH);
48     function removeLiquidityWithPermit(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline,
56         bool approveMax, uint8 v, bytes32 r, bytes32 s
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETHWithPermit(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountToken, uint amountETH);
67     function swapExactTokensForTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external returns (uint[] memory amounts);
74     function swapTokensForExactTokens(
75         uint amountOut,
76         uint amountInMax,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external returns (uint[] memory amounts);
81     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
82         external
83         payable
84         returns (uint[] memory amounts);
85     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
89         external
90         returns (uint[] memory amounts);
91     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
92         external
93         payable
94         returns (uint[] memory amounts);
95 
96     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
97     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
98     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
99     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
100     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
101 }
102 // File: contracts/IUniswapV2Router02.sol
103 
104 
105 pragma solidity >=0.6.2;
106 
107 
108 interface IUniswapV2Router02 is IUniswapV2Router01 {
109     function removeLiquidityETHSupportingFeeOnTransferTokens(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountETH);
117     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
118         address token,
119         uint liquidity,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline,
124         bool approveMax, uint8 v, bytes32 r, bytes32 s
125     ) external returns (uint amountETH);
126 
127     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function swapExactETHForTokensSupportingFeeOnTransferTokens(
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external payable;
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147 }
148 // File: contracts/IUniswapV2Factory.sol
149 
150 
151 pragma solidity >=0.5.0;
152 
153 interface IUniswapV2Factory {
154     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
155 
156     function feeTo() external view returns (address);
157     function feeToSetter() external view returns (address);
158 
159     function getPair(address tokenA, address tokenB) external view returns (address pair);
160     function allPairs(uint) external view returns (address pair);
161     function allPairsLength() external view returns (uint);
162 
163     function createPair(address tokenA, address tokenB) external returns (address pair);
164 
165     function setFeeTo(address) external;
166     function setFeeToSetter(address) external;
167 }
168 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
169 
170 
171 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 // CAUTION
176 // This version of SafeMath should only be used with Solidity 0.8 or later,
177 // because it relies on the compiler's built in overflow checks.
178 
179 /**
180  * @dev Wrappers over Solidity's arithmetic operations.
181  *
182  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
183  * now has built in overflow checking.
184  */
185 library SafeMath {
186     /**
187      * @dev Returns the addition of two unsigned integers, with an overflow flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
192         unchecked {
193             uint256 c = a + b;
194             if (c < a) return (false, 0);
195             return (true, c);
196         }
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
201      *
202      * _Available since v3.4._
203      */
204     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             if (b > a) return (false, 0);
207             return (true, a - b);
208         }
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
213      *
214      * _Available since v3.4._
215      */
216     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         unchecked {
218             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219             // benefit is lost if 'b' is also tested.
220             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
221             if (a == 0) return (true, 0);
222             uint256 c = a * b;
223             if (c / a != b) return (false, 0);
224             return (true, c);
225         }
226     }
227 
228     /**
229      * @dev Returns the division of two unsigned integers, with a division by zero flag.
230      *
231      * _Available since v3.4._
232      */
233     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         unchecked {
235             if (b == 0) return (false, 0);
236             return (true, a / b);
237         }
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
242      *
243      * _Available since v3.4._
244      */
245     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             if (b == 0) return (false, 0);
248             return (true, a % b);
249         }
250     }
251 
252     /**
253      * @dev Returns the addition of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `+` operator.
257      *
258      * Requirements:
259      *
260      * - Addition cannot overflow.
261      */
262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a + b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a - b;
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, reverting on
282      * overflow.
283      *
284      * Counterpart to Solidity's `*` operator.
285      *
286      * Requirements:
287      *
288      * - Multiplication cannot overflow.
289      */
290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a * b;
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers, reverting on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator.
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a / b;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a % b;
322     }
323 
324     /**
325      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
326      * overflow (when the result is negative).
327      *
328      * CAUTION: This function is deprecated because it requires allocating memory for the error
329      * message unnecessarily. For custom revert reasons use {trySub}.
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         unchecked {
339             require(b <= a, errorMessage);
340             return a - b;
341         }
342     }
343 
344     /**
345      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
346      * division by zero. The result is rounded towards zero.
347      *
348      * Counterpart to Solidity's `/` operator. Note: this function uses a
349      * `revert` opcode (which leaves remaining gas untouched) while Solidity
350      * uses an invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
357         unchecked {
358             require(b > 0, errorMessage);
359             return a / b;
360         }
361     }
362 
363     /**
364      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
365      * reverting with custom message when dividing by zero.
366      *
367      * CAUTION: This function is deprecated because it requires allocating memory for the error
368      * message unnecessarily. For custom revert reasons use {tryMod}.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
379         unchecked {
380             require(b > 0, errorMessage);
381             return a % b;
382         }
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/Context.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/access/Ownable.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership}.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be applied to your functions to restrict their use to
431  * the owner.
432  */
433 abstract contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor() {
442         _transferOwnership(_msgSender());
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         _checkOwner();
450         _;
451     }
452 
453     /**
454      * @dev Returns the address of the current owner.
455      */
456     function owner() public view virtual returns (address) {
457         return _owner;
458     }
459 
460     /**
461      * @dev Throws if the sender is not the owner.
462      */
463     function _checkOwner() internal view virtual {
464         require(owner() == _msgSender(), "Ownable: caller is not the owner");
465     }
466 
467     /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby disabling any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public virtual onlyOwner {
475         _transferOwnership(address(0));
476     }
477 
478     /**
479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
480      * Can only be called by the current owner.
481      */
482     function transferOwnership(address newOwner) public virtual onlyOwner {
483         require(newOwner != address(0), "Ownable: new owner is the zero address");
484         _transferOwnership(newOwner);
485     }
486 
487     /**
488      * @dev Transfers ownership of the contract to a new account (`newOwner`).
489      * Internal function without access restriction.
490      */
491     function _transferOwnership(address newOwner) internal virtual {
492         address oldOwner = _owner;
493         _owner = newOwner;
494         emit OwnershipTransferred(oldOwner, newOwner);
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
499 
500 
501 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC20 standard as defined in the EIP.
507  */
508 interface IERC20 {
509     /**
510      * @dev Emitted when `value` tokens are moved from one account (`from`) to
511      * another (`to`).
512      *
513      * Note that `value` may be zero.
514      */
515     event Transfer(address indexed from, address indexed to, uint256 value);
516 
517     /**
518      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
519      * a call to {approve}. `value` is the new allowance.
520      */
521     event Approval(address indexed owner, address indexed spender, uint256 value);
522 
523     /**
524      * @dev Returns the amount of tokens in existence.
525      */
526     function totalSupply() external view returns (uint256);
527 
528     /**
529      * @dev Returns the amount of tokens owned by `account`.
530      */
531     function balanceOf(address account) external view returns (uint256);
532 
533     /**
534      * @dev Moves `amount` tokens from the caller's account to `to`.
535      *
536      * Returns a boolean value indicating whether the operation succeeded.
537      *
538      * Emits a {Transfer} event.
539      */
540     function transfer(address to, uint256 amount) external returns (bool);
541 
542     /**
543      * @dev Returns the remaining number of tokens that `spender` will be
544      * allowed to spend on behalf of `owner` through {transferFrom}. This is
545      * zero by default.
546      *
547      * This value changes when {approve} or {transferFrom} are called.
548      */
549     function allowance(address owner, address spender) external view returns (uint256);
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
553      *
554      * Returns a boolean value indicating whether the operation succeeded.
555      *
556      * IMPORTANT: Beware that changing an allowance with this method brings the risk
557      * that someone may use both the old and the new allowance by unfortunate
558      * transaction ordering. One possible solution to mitigate this race
559      * condition is to first reduce the spender's allowance to 0 and set the
560      * desired value afterwards:
561      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
562      *
563      * Emits an {Approval} event.
564      */
565     function approve(address spender, uint256 amount) external returns (bool);
566 
567     /**
568      * @dev Moves `amount` tokens from `from` to `to` using the
569      * allowance mechanism. `amount` is then deducted from the caller's
570      * allowance.
571      *
572      * Returns a boolean value indicating whether the operation succeeded.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(address from, address to, uint256 amount) external returns (bool);
577 }
578 
579 // File: @openzeppelin/contracts/interfaces/IERC20.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Interface for the optional metadata functions from the ERC20 standard.
597  *
598  * _Available since v4.1._
599  */
600 interface IERC20Metadata is IERC20 {
601     /**
602      * @dev Returns the name of the token.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the symbol of the token.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the decimals places of the token.
613      */
614     function decimals() external view returns (uint8);
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
618 
619 
620 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 
626 
627 /**
628  * @dev Implementation of the {IERC20} interface.
629  *
630  * This implementation is agnostic to the way tokens are created. This means
631  * that a supply mechanism has to be added in a derived contract using {_mint}.
632  * For a generic mechanism see {ERC20PresetMinterPauser}.
633  *
634  * TIP: For a detailed writeup see our guide
635  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
636  * to implement supply mechanisms].
637  *
638  * The default value of {decimals} is 18. To change this, you should override
639  * this function so it returns a different value.
640  *
641  * We have followed general OpenZeppelin Contracts guidelines: functions revert
642  * instead returning `false` on failure. This behavior is nonetheless
643  * conventional and does not conflict with the expectations of ERC20
644  * applications.
645  *
646  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
647  * This allows applications to reconstruct the allowance for all accounts just
648  * by listening to said events. Other implementations of the EIP may not emit
649  * these events, as it isn't required by the specification.
650  *
651  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
652  * functions have been added to mitigate the well-known issues around setting
653  * allowances. See {IERC20-approve}.
654  */
655 contract ERC20 is Context, IERC20, IERC20Metadata {
656     mapping(address => uint256) private _balances;
657 
658     mapping(address => mapping(address => uint256)) private _allowances;
659 
660     uint256 private _totalSupply;
661 
662     string private _name;
663     string private _symbol;
664 
665     /**
666      * @dev Sets the values for {name} and {symbol}.
667      *
668      * All two of these values are immutable: they can only be set once during
669      * construction.
670      */
671     constructor(string memory name_, string memory symbol_) {
672         _name = name_;
673         _symbol = symbol_;
674     }
675 
676     /**
677      * @dev Returns the name of the token.
678      */
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the symbol of the token, usually a shorter version of the
685      * name.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev Returns the number of decimals used to get its user representation.
693      * For example, if `decimals` equals `2`, a balance of `505` tokens should
694      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
695      *
696      * Tokens usually opt for a value of 18, imitating the relationship between
697      * Ether and Wei. This is the default value returned by this function, unless
698      * it's overridden.
699      *
700      * NOTE: This information is only used for _display_ purposes: it in
701      * no way affects any of the arithmetic of the contract, including
702      * {IERC20-balanceOf} and {IERC20-transfer}.
703      */
704     function decimals() public view virtual override returns (uint8) {
705         return 18;
706     }
707 
708     /**
709      * @dev See {IERC20-totalSupply}.
710      */
711     function totalSupply() public view virtual override returns (uint256) {
712         return _totalSupply;
713     }
714 
715     /**
716      * @dev See {IERC20-balanceOf}.
717      */
718     function balanceOf(address account) public view virtual override returns (uint256) {
719         return _balances[account];
720     }
721 
722     /**
723      * @dev See {IERC20-transfer}.
724      *
725      * Requirements:
726      *
727      * - `to` cannot be the zero address.
728      * - the caller must have a balance of at least `amount`.
729      */
730     function transfer(address to, uint256 amount) public virtual override returns (bool) {
731         address owner = _msgSender();
732         _transfer(owner, to, amount);
733         return true;
734     }
735 
736     /**
737      * @dev See {IERC20-allowance}.
738      */
739     function allowance(address owner, address spender) public view virtual override returns (uint256) {
740         return _allowances[owner][spender];
741     }
742 
743     /**
744      * @dev See {IERC20-approve}.
745      *
746      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
747      * `transferFrom`. This is semantically equivalent to an infinite approval.
748      *
749      * Requirements:
750      *
751      * - `spender` cannot be the zero address.
752      */
753     function approve(address spender, uint256 amount) public virtual override returns (bool) {
754         address owner = _msgSender();
755         _approve(owner, spender, amount);
756         return true;
757     }
758 
759     /**
760      * @dev See {IERC20-transferFrom}.
761      *
762      * Emits an {Approval} event indicating the updated allowance. This is not
763      * required by the EIP. See the note at the beginning of {ERC20}.
764      *
765      * NOTE: Does not update the allowance if the current allowance
766      * is the maximum `uint256`.
767      *
768      * Requirements:
769      *
770      * - `from` and `to` cannot be the zero address.
771      * - `from` must have a balance of at least `amount`.
772      * - the caller must have allowance for ``from``'s tokens of at least
773      * `amount`.
774      */
775     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
776         address spender = _msgSender();
777         _spendAllowance(from, spender, amount);
778         _transfer(from, to, amount);
779         return true;
780     }
781 
782     /**
783      * @dev Atomically increases the allowance granted to `spender` by the caller.
784      *
785      * This is an alternative to {approve} that can be used as a mitigation for
786      * problems described in {IERC20-approve}.
787      *
788      * Emits an {Approval} event indicating the updated allowance.
789      *
790      * Requirements:
791      *
792      * - `spender` cannot be the zero address.
793      */
794     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
795         address owner = _msgSender();
796         _approve(owner, spender, allowance(owner, spender) + addedValue);
797         return true;
798     }
799 
800     /**
801      * @dev Atomically decreases the allowance granted to `spender` by the caller.
802      *
803      * This is an alternative to {approve} that can be used as a mitigation for
804      * problems described in {IERC20-approve}.
805      *
806      * Emits an {Approval} event indicating the updated allowance.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      * - `spender` must have allowance for the caller of at least
812      * `subtractedValue`.
813      */
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         address owner = _msgSender();
816         uint256 currentAllowance = allowance(owner, spender);
817         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
818         unchecked {
819             _approve(owner, spender, currentAllowance - subtractedValue);
820         }
821 
822         return true;
823     }
824 
825     /**
826      * @dev Moves `amount` of tokens from `from` to `to`.
827      *
828      * This internal function is equivalent to {transfer}, and can be used to
829      * e.g. implement automatic token fees, slashing mechanisms, etc.
830      *
831      * Emits a {Transfer} event.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `from` must have a balance of at least `amount`.
838      */
839     function _transfer(address from, address to, uint256 amount) internal virtual {
840         require(from != address(0), "ERC20: transfer from the zero address");
841         require(to != address(0), "ERC20: transfer to the zero address");
842 
843         _beforeTokenTransfer(from, to, amount);
844 
845         uint256 fromBalance = _balances[from];
846         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
847         unchecked {
848             _balances[from] = fromBalance - amount;
849             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
850             // decrementing then incrementing.
851             _balances[to] += amount;
852         }
853 
854         emit Transfer(from, to, amount);
855 
856         _afterTokenTransfer(from, to, amount);
857     }
858 
859     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
860      * the total supply.
861      *
862      * Emits a {Transfer} event with `from` set to the zero address.
863      *
864      * Requirements:
865      *
866      * - `account` cannot be the zero address.
867      */
868     function _mint(address account, uint256 amount) internal virtual {
869         require(account != address(0), "ERC20: mint to the zero address");
870 
871         _beforeTokenTransfer(address(0), account, amount);
872 
873         _totalSupply += amount;
874         unchecked {
875             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
876             _balances[account] += amount;
877         }
878         emit Transfer(address(0), account, amount);
879 
880         _afterTokenTransfer(address(0), account, amount);
881     }
882 
883     /**
884      * @dev Destroys `amount` tokens from `account`, reducing the
885      * total supply.
886      *
887      * Emits a {Transfer} event with `to` set to the zero address.
888      *
889      * Requirements:
890      *
891      * - `account` cannot be the zero address.
892      * - `account` must have at least `amount` tokens.
893      */
894     function _burn(address account, uint256 amount) internal virtual {
895         require(account != address(0), "ERC20: burn from the zero address");
896 
897         _beforeTokenTransfer(account, address(0), amount);
898 
899         uint256 accountBalance = _balances[account];
900         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
901         unchecked {
902             _balances[account] = accountBalance - amount;
903             // Overflow not possible: amount <= accountBalance <= totalSupply.
904             _totalSupply -= amount;
905         }
906 
907         emit Transfer(account, address(0), amount);
908 
909         _afterTokenTransfer(account, address(0), amount);
910     }
911 
912     /**
913      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
914      *
915      * This internal function is equivalent to `approve`, and can be used to
916      * e.g. set automatic allowances for certain subsystems, etc.
917      *
918      * Emits an {Approval} event.
919      *
920      * Requirements:
921      *
922      * - `owner` cannot be the zero address.
923      * - `spender` cannot be the zero address.
924      */
925     function _approve(address owner, address spender, uint256 amount) internal virtual {
926         require(owner != address(0), "ERC20: approve from the zero address");
927         require(spender != address(0), "ERC20: approve to the zero address");
928 
929         _allowances[owner][spender] = amount;
930         emit Approval(owner, spender, amount);
931     }
932 
933     /**
934      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
935      *
936      * Does not update the allowance amount in case of infinite allowance.
937      * Revert if not enough allowance is available.
938      *
939      * Might emit an {Approval} event.
940      */
941     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
942         uint256 currentAllowance = allowance(owner, spender);
943         if (currentAllowance != type(uint256).max) {
944             require(currentAllowance >= amount, "ERC20: insufficient allowance");
945             unchecked {
946                 _approve(owner, spender, currentAllowance - amount);
947             }
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any transfer of tokens. This includes
953      * minting and burning.
954      *
955      * Calling conditions:
956      *
957      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
958      * will be transferred to `to`.
959      * - when `from` is zero, `amount` tokens will be minted for `to`.
960      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
966 
967     /**
968      * @dev Hook that is called after any transfer of tokens. This includes
969      * minting and burning.
970      *
971      * Calling conditions:
972      *
973      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
974      * has been transferred to `to`.
975      * - when `from` is zero, `amount` tokens have been minted for `to`.
976      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
982 }
983 
984 // File: contracts/MyToken.sol
985 
986 
987 pragma solidity ^0.8.0;
988 
989 
990 
991 
992 
993 
994 
995 
996 contract ZLDA is ERC20, Ownable {
997     using SafeMath for uint256;
998 
999     IUniswapV2Router02 public immutable router;
1000     address public immutable uniswapV2Pair;
1001 
1002     // addresses
1003     address public devWallet;
1004     address private marketingWallet;
1005 
1006     // limits
1007     uint256 private maxBuyAmount;
1008     uint256 private maxSellAmount;
1009     uint256 private maxWalletAmount;
1010 
1011     uint256 private thresholdSwapAmount;
1012 
1013     // status flags
1014     bool private isTrading = false;
1015     bool public swapEnabled = false;
1016     bool public isSwapping;
1017 
1018     struct Fees {
1019         uint8 buyTotalFees;
1020         uint8 buyMarketingFee;
1021         uint8 buyDevFee;
1022         uint8 buyLiquidityFee;
1023 
1024         uint8 sellTotalFees;
1025         uint8 sellMarketingFee;
1026         uint8 sellDevFee;
1027         uint8 sellLiquidityFee;
1028     }
1029 
1030     Fees public _fees = Fees({
1031         buyTotalFees: 0,
1032         buyMarketingFee: 0,
1033         buyDevFee: 0,
1034         buyLiquidityFee: 0,
1035 
1036         sellTotalFees: 0,
1037         sellMarketingFee: 0,
1038         sellDevFee: 0,
1039         sellLiquidityFee: 0
1040     });
1041 
1042     uint256 public tokensForMarketing;
1043     uint256 public tokensForLiquidity;
1044     uint256 public tokensForDev;
1045     uint256 private taxTill;
1046     // exclude from fees and max transaction amount
1047     mapping(address => bool) private _isExcludedFromFees;
1048     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1049     mapping(address => bool) public _isExcludedMaxWalletAmount;
1050 
1051     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1052     // could be subject to a maximum transfer amount
1053     mapping(address => bool) public marketPair;
1054     mapping(address => bool) public _isBlacklisted;
1055 
1056     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived);
1057 
1058     constructor() ERC20("ZLDA", "ZLDA") {
1059         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1060 
1061         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
1062 
1063         _isExcludedMaxTransactionAmount[address(router)] = true;
1064         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
1065         _isExcludedMaxTransactionAmount[owner()] = true;
1066         _isExcludedMaxTransactionAmount[address(this)] = true;
1067 
1068         _isExcludedFromFees[owner()] = true;
1069         _isExcludedFromFees[address(this)] = true;
1070 
1071         _isExcludedMaxWalletAmount[owner()] = true;
1072         _isExcludedMaxWalletAmount[address(this)] = true;
1073         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
1074 
1075         marketPair[address(uniswapV2Pair)] = true;
1076 
1077         approve(address(router), type(uint256).max);
1078         uint256 totalSupply = 1e9 * 1e18;
1079 
1080         maxBuyAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
1081         maxSellAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
1082         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
1083         thresholdSwapAmount = totalSupply * 1 / 1000; // 0.01% swap wallet
1084 
1085         _fees.buyMarketingFee = 2;
1086         _fees.buyLiquidityFee = 1;
1087         _fees.buyDevFee = 1;
1088         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
1089 
1090         _fees.sellMarketingFee = 2;
1091         _fees.sellLiquidityFee = 1;
1092         _fees.sellDevFee = 1;
1093         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
1094 
1095         marketingWallet = address(0xC1b8d8D2aE4D737D7C072543F5Ee60fDdbb9df7C);
1096         devWallet = address(0xC1b8d8D2aE4D737D7C072543F5Ee60fDdbb9df7C);
1097 
1098         _mint(msg.sender, totalSupply);
1099     }
1100 
1101     receive() external payable {}
1102 
1103     function startTrading() external onlyOwner {
1104         isTrading = true;
1105         swapEnabled = true;
1106         taxTill = block.number + 3;
1107     }
1108 
1109     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns (bool) {
1110         thresholdSwapAmount = newAmount;
1111         return true;
1112     }
1113 
1114     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
1115         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
1116         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
1117         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
1118         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
1119     }
1120 
1121     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
1122         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
1123         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
1124     }
1125 
1126     function toggleSwapEnabled(bool enabled) external onlyOwner() {
1127         swapEnabled = enabled;
1128     }
1129 
1130     function blacklistAddress(address account, bool value) external onlyOwner {
1131         _isBlacklisted[account] = value;
1132     }
1133 
1134     function updateFees(
1135         uint8 _marketingFeeBuy,
1136         uint8 _liquidityFeeBuy,
1137         uint8 _devFeeBuy,
1138         uint8 _marketingFeeSell,
1139         uint8 _liquidityFeeSell,
1140         uint8 _devFeeSell
1141     ) external onlyOwner {
1142         _fees.buyMarketingFee = _marketingFeeBuy;
1143         _fees.buyLiquidityFee = _liquidityFeeBuy;
1144         _fees.buyDevFee = _devFeeBuy;
1145         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
1146 
1147         _fees.sellMarketingFee = _marketingFeeSell;
1148         _fees.sellLiquidityFee = _liquidityFeeSell;
1149         _fees.sellDevFee = _devFeeSell;
1150         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
1151         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");
1152         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
1153     }
1154 
1155     function excludeFromFees(address account, bool excluded) public onlyOwner {
1156         _isExcludedFromFees[account] = excluded;
1157     }
1158 
1159     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
1160         _isExcludedMaxWalletAmount[account] = excluded;
1161     }
1162 
1163     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1164         _isExcludedMaxTransactionAmount[updAds] = isEx;
1165     }
1166 
1167     function setMarketPair(address pair, bool value) public onlyOwner {
1168         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
1169         marketPair[pair] = value;
1170     }
1171 
1172     function setWallets(address _marketingWallet, address _devWallet) external onlyOwner {
1173         marketingWallet = _marketingWallet;
1174         devWallet = _devWallet;
1175     }
1176 
1177     function isExcludedFromFees(address account) public view returns (bool) {
1178         return _isExcludedFromFees[account];
1179     }
1180 
1181     function _transfer(
1182         address sender,
1183         address recipient,
1184         uint256 amount
1185     ) internal override {
1186         if (amount == 0) {
1187             super._transfer(sender, recipient, 0);
1188             return;
1189         }
1190 
1191         if (
1192             sender != owner() &&
1193             recipient != owner() &&
1194             !isSwapping
1195         ) {
1196             if (!isTrading) {
1197                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
1198             }
1199             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
1200                 require(amount <= maxBuyAmount, "buy transfer over max amount");
1201             } else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
1202                 require(amount <= maxSellAmount, "Sell transfer over max amount");
1203             }
1204 
1205             if (!_isExcludedMaxWalletAmount[recipient]) {
1206                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
1207             }
1208             require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
1209         }
1210 
1211         uint256 contractTokenBalance = balanceOf(address(this));
1212 
1213         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
1214 
1215         if (
1216             canSwap &&
1217             swapEnabled &&
1218             !isSwapping &&
1219             marketPair[recipient] &&
1220             !_isExcludedFromFees[sender] &&
1221             !_isExcludedFromFees[recipient]
1222         ) {
1223             isSwapping = true;
1224             swapBack();
1225             isSwapping = false;
1226         }
1227 
1228         bool takeFee = !isSwapping;
1229 
1230         // if any account belongs to _isExcludedFromFee account then remove the fee
1231         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1232             takeFee = false;
1233         }
1234 
1235         // only take fees on buys/sells, do not take on wallet transfers
1236         if (takeFee) {
1237             uint256 fees = 0;
1238             if (block.number < taxTill) {
1239                 fees = amount.mul(99).div(100);
1240                 tokensForMarketing += (fees * 94) / 99;
1241                 tokensForDev += (fees * 5) / 99;
1242             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
1243                 fees = amount.mul(_fees.sellTotalFees).div(100);
1244                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
1245                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
1246                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
1247             }
1248             // on buy
1249             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
1250                 fees = amount.mul(_fees.buyTotalFees).div(100);
1251                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
1252                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
1253                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
1254             }
1255 
1256             if (fees > 0) {
1257                 super._transfer(sender, address(this), fees);
1258             }
1259 
1260             amount -= fees;
1261         }
1262 
1263         super._transfer(sender, recipient, amount);
1264     }
1265 
1266     function swapTokensForEth(uint256 tAmount) private {
1267         // generate the uniswap pair path of token -> weth
1268         address[] memory path = new address[](2);
1269         path[0] = address(this);
1270         path[1] = router.WETH();
1271 
1272         _approve(address(this), address(router), tAmount);
1273 
1274         // make the swap
1275         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1276             tAmount,
1277             0, // accept any amount of ETH
1278             path,
1279             address(this),
1280             block.timestamp
1281         );
1282     }
1283 
1284     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
1285         // approve token transfer to cover all possible scenarios
1286         _approve(address(this), address(router), tAmount);
1287 
1288         // add the liquidity
1289         router.addLiquidityETH{value: ethAmount}(
1290             address(this),
1291             tAmount,
1292             0,
1293             0,
1294             address(this),
1295             block.timestamp
1296         );
1297     }
1298 
1299     function swapBack() private {
1300         uint256 contractTokenBalance = balanceOf(address(this));
1301         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1302         bool success;
1303 
1304         if (contractTokenBalance == 0 || toSwap == 0) {
1305             return;
1306         }
1307 
1308         if (contractTokenBalance > thresholdSwapAmount * 20) {
1309             contractTokenBalance = thresholdSwapAmount * 20;
1310         }
1311 
1312         // Halve the amount of liquidity tokens
1313         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
1314         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
1315 
1316         uint256 initialETHBalance = address(this).balance;
1317 
1318         swapTokensForEth(amountToSwapForETH);
1319 
1320         uint256 newBalance = address(this).balance.sub(initialETHBalance);
1321 
1322         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
1323         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
1324         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
1325 
1326         tokensForLiquidity = 0;
1327         tokensForMarketing = 0;
1328         tokensForDev = 0;
1329 
1330         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1331             addLiquidity(liquidityTokens, ethForLiquidity);
1332             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1333         }
1334 
1335         (success, ) = address(devWallet).call{value: (address(this).balance - ethForMarketing)}("");
1336         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1337     }
1338 }