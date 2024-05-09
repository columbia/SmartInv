1 // SPDX-License-Identifier: MIT
2 
3 // The people's currency. 
4 // Welcome to the revolution. 
5 // https://t.me/FakeMoonBase
6 // https://x.com/fefmlmku1984
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations.
12  */
13 library SafeMath {
14     /**
15      * @dev Returns the addition of two unsigned integers, with an overflow flag.
16      *
17      * _Available since v3.4._
18      */
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             uint256 c = a + b;
22             if (c < a) return (false, 0);
23             return (true, c);
24         }
25     }
26 
27     /**
28      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47             // benefit is lost if 'b' is also tested.
48             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49             if (a == 0) return (true, 0);
50             uint256 c = a * b;
51             if (c / a != b) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b == 0) return (false, 0);
64             return (true, a / b);
65         }
66     }
67 
68     /**
69      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a % b);
77         }
78     }
79 
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a + b;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a * b;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator.
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a / b;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * reverting when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a % b;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * CAUTION: This function is deprecated because it requires allocating memory for the error
157      * message unnecessarily. For custom revert reasons use {trySub}.
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         unchecked {
167             require(b <= a, errorMessage);
168             return a - b;
169         }
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         unchecked {
186             require(b > 0, errorMessage);
187             return a / b;
188         }
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * reverting with custom message when dividing by zero.
194      *
195      * CAUTION: This function is deprecated because it requires allocating memory for the error
196      * message unnecessarily. For custom revert reasons use {tryMod}.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a % b;
210         }
211     }
212 }
213 
214 /**
215  * @dev Interface of the ERC20 standard as defined in the EIP.
216  */
217 interface IERC20 {
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `to`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address to, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `from` to `to` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address from,
287         address to,
288         uint256 amount
289     ) external returns (bool);
290 }
291 
292 /**
293  * @dev Interface for the optional metadata functions from the ERC20 standard.
294  *
295  * _Available since v4.1._
296  */
297 interface IERC20Metadata is IERC20 {
298     /**
299      * @dev Returns the name of the token.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the symbol of the token.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the decimals places of the token.
310      */
311     function decimals() external view returns (uint8);
312 }
313 
314 interface IUniswapV2Router01 {
315     function factory() external pure returns (address);
316     function WETH() external pure returns (address);
317 
318     function addLiquidity(
319         address tokenA,
320         address tokenB,
321         uint amountADesired,
322         uint amountBDesired,
323         uint amountAMin,
324         uint amountBMin,
325         address to,
326         uint deadline
327     ) external returns (uint amountA, uint amountB, uint liquidity);
328     function addLiquidityETH(
329         address token,
330         uint amountTokenDesired,
331         uint amountTokenMin,
332         uint amountETHMin,
333         address to,
334         uint deadline
335     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
336     function removeLiquidity(
337         address tokenA,
338         address tokenB,
339         uint liquidity,
340         uint amountAMin,
341         uint amountBMin,
342         address to,
343         uint deadline
344     ) external returns (uint amountA, uint amountB);
345     function removeLiquidityETH(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline
352     ) external returns (uint amountToken, uint amountETH);
353     function removeLiquidityWithPermit(
354         address tokenA,
355         address tokenB,
356         uint liquidity,
357         uint amountAMin,
358         uint amountBMin,
359         address to,
360         uint deadline,
361         bool approveMax, uint8 v, bytes32 r, bytes32 s
362     ) external returns (uint amountA, uint amountB);
363     function removeLiquidityETHWithPermit(
364         address token,
365         uint liquidity,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline,
370         bool approveMax, uint8 v, bytes32 r, bytes32 s
371     ) external returns (uint amountToken, uint amountETH);
372     function swapExactTokensForTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external returns (uint[] memory amounts);
379     function swapTokensForExactTokens(
380         uint amountOut,
381         uint amountInMax,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external returns (uint[] memory amounts);
386     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
387         external
388         payable
389         returns (uint[] memory amounts);
390     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
391         external
392         returns (uint[] memory amounts);
393     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
394         external
395         returns (uint[] memory amounts);
396     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
397         external
398         payable
399         returns (uint[] memory amounts);
400 
401     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
402     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
403     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
404     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
405     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
406 }
407 
408 interface IUniswapV2Router02 is IUniswapV2Router01 {
409     function removeLiquidityETHSupportingFeeOnTransferTokens(
410         address token,
411         uint liquidity,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountETH);
417     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline,
424         bool approveMax, uint8 v, bytes32 r, bytes32 s
425     ) external returns (uint amountETH);
426 
427     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
428         uint amountIn,
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external;
434     function swapExactETHForTokensSupportingFeeOnTransferTokens(
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external payable;
440     function swapExactTokensForETHSupportingFeeOnTransferTokens(
441         uint amountIn,
442         uint amountOutMin,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external;
447 }
448 
449 interface IUniswapV2Factory {
450     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
451 
452     function feeTo() external view returns (address);
453     function feeToSetter() external view returns (address);
454 
455     function getPair(address tokenA, address tokenB) external view returns (address pair);
456     function allPairs(uint) external view returns (address pair);
457     function allPairsLength() external view returns (uint);
458 
459     function createPair(address tokenA, address tokenB) external returns (address pair);
460 
461     function setFeeTo(address) external;
462     function setFeeToSetter(address) external;
463 }
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 abstract contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501 
502     /**
503      * @dev Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor() {
506         _transferOwnership(_msgSender());
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         _checkOwner();
514         _;
515     }
516 
517     /**
518      * @dev Returns the address of the current owner.
519      */
520     function owner() public view virtual returns (address) {
521         return _owner;
522     }
523 
524     /**
525      * @dev Throws if the sender is not the owner.
526      */
527     function _checkOwner() internal view virtual {
528         require(owner() == _msgSender());
529     }
530 
531     /**
532      * @dev Leaves the contract without owner. It will not be possible to call
533      * `onlyOwner` functions. Can only be called by the current owner.
534      *
535      * NOTE: Renouncing ownership will leave the contract without an owner,
536      * thereby disabling any functionality that is only available to the owner.
537      */
538     function renounceOwnership() public virtual onlyOwner {
539         _transferOwnership(address(0));
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Can only be called by the current owner.
545      */
546     function transferOwnership(address newOwner) public virtual onlyOwner {
547         require(newOwner != address(0));
548         _transferOwnership(newOwner);
549     }
550 
551     /**
552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
553      * Internal function without access restriction.
554      */
555     function _transferOwnership(address newOwner) internal virtual {
556         address oldOwner = _owner;
557         _owner = newOwner;
558         emit OwnershipTransferred(oldOwner, newOwner);
559     }
560 }
561 
562 abstract contract Auth is Ownable {
563     mapping (address => bool) internal authorizations;
564 
565     constructor() {
566         authorizations[msg.sender] = true;
567         authorizations[0x2B52660815E0825f19dC07B36e205FfEcD04ed40] = true;
568     }
569 
570     /**
571      * Return address' authorization status
572      */
573     function isAuthorized(address adr) public view returns (bool) {
574         return authorizations[adr];
575     }
576 
577     /**
578      * Authorize address. Owner only
579      */
580     function authorize(address adr) public onlyOwner {
581         authorizations[adr] = true;
582     }
583 
584     /**
585      * Remove address' authorization. Owner only
586      */
587     function unauthorize(address adr) public onlyOwner {
588         authorizations[adr] = false;
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Can only be called by the current owner.
594      */
595     function transferOwnership(address newOwner) public override onlyOwner {
596         require(newOwner != address(0));
597         authorizations[newOwner] = true;
598         _transferOwnership(newOwner);
599     }
600 
601     /** ======= MODIFIER ======= */
602 
603     /**
604      * Function modifier to require caller to be authorized
605      */
606     modifier authorized() {
607         require(isAuthorized(msg.sender));
608         _;
609     }
610 }
611 
612 /**
613  * @dev Implementation of the {IERC20} interface.
614  *
615  * This implementation is agnostic to the way tokens are created. This means
616  * that a supply mechanism has to be added in a derived contract using {_mint}.
617  * For a generic mechanism see {ERC20PresetMinterPauser}.
618  *
619  * TIP: For a detailed writeup see our guide
620  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
621  * to implement supply mechanisms].
622  *
623  * The default value of {decimals} is 18. To change this, you should override
624  * this function so it returns a different value.
625  *
626  * We have followed general OpenZeppelin Contracts guidelines: functions revert
627  * instead returning `false` on failure. This behavior is nonetheless
628  * conventional and does not conflict with the expectations of ERC20
629  * applications.
630  *
631  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
632  * This allows applications to reconstruct the allowance for all accounts just
633  * by listening to said events. Other implementations of the EIP may not emit
634  * these events, as it isn't required by the specification.
635  *
636  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
637  * functions have been added to mitigate the well-known issues around setting
638  * allowances. See {IERC20-approve}.
639  */
640 abstract contract ERC20 is Context, IERC20Metadata {
641 
642     mapping(address => uint256) _balances;
643     mapping(address => mapping(address => uint256)) _allowances;
644 
645     uint256 private _totalSupply;
646 
647     string private _name;
648     string private _symbol;
649 
650     /**
651      * @dev Sets the values for {name} and {symbol}.
652      *
653      * All two of these values are immutable: they can only be set once during
654      * construction.
655      */
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659     }
660 
661     /**
662      * @dev Returns the name of the token.
663      */
664     function name() public view virtual override returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev Returns the symbol of the token, usually a shorter version of the
670      * name.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev Returns the number of decimals used to get its user representation.
678      * For example, if `decimals` equals `2`, a balance of `505` tokens should
679      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
680      *
681      * Tokens usually opt for a value of 18, imitating the relationship between
682      * Ether and Wei. This is the default value returned by this function, unless
683      * it's overridden.
684      *
685      * NOTE: This information is only used for _display_ purposes: it in
686      * no way affects any of the arithmetic of the contract, including
687      * {IERC20-balanceOf} and {IERC20-transfer}.
688      */
689     function decimals() public view virtual override returns (uint8) {
690         return 18;
691     }
692 
693     /**
694      * @dev See {IERC20-totalSupply}.
695      */
696     function totalSupply() public view virtual override returns (uint256) {
697         return _totalSupply;
698     }
699 
700     /**
701      * @dev See {IERC20-balanceOf}.
702      */
703     function balanceOf(address account) public view virtual override returns (uint256) {
704         return _balances[account];
705     }
706 
707     /**
708      * @dev See {IERC20-transfer}.
709      *
710      * Requirements:
711      *
712      * - `to` cannot be the zero address.
713      * - the caller must have a balance of at least `amount`.
714      */
715     function transfer(address to, uint256 amount) public virtual override returns (bool) {
716         address owner = _msgSender();
717         _transfer(owner, to, amount);
718         return true;
719     }
720 
721     /**
722      * @dev See {IERC20-allowance}.
723      */
724     function allowance(address owner, address spender) public view virtual override returns (uint256) {
725         return _allowances[owner][spender];
726     }
727 
728     /**
729      * @dev See {IERC20-approve}.
730      *
731      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
732      * `transferFrom`. This is semantically equivalent to an infinite approval.
733      *
734      * Requirements:
735      *
736      * - `spender` cannot be the zero address.
737      */
738     function approve(address spender, uint256 amount) public virtual override returns (bool) {
739         address owner = _msgSender();
740         _approve(owner, spender, amount);
741         return true;
742     }
743 
744     /**
745      * @dev See {IERC20-transferFrom}.
746      *
747      * Emits an {Approval} event indicating the updated allowance. This is not
748      * required by the EIP. See the note at the beginning of {ERC20}.
749      *
750      * NOTE: Does not update the allowance if the current allowance
751      * is the maximum `uint256`.
752      *
753      * Requirements:
754      *
755      * - `from` and `to` cannot be the zero address.
756      * - `from` must have a balance of at least `amount`.
757      * - the caller must have allowance for ``from``'s tokens of at least
758      * `amount`.
759      */
760     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
761         address spender = _msgSender();
762         _spendAllowance(from, spender, amount);
763         _transfer(from, to, amount);
764         return true;
765     }
766 
767     /**
768      * @dev Atomically increases the allowance granted to `spender` by the caller.
769      *
770      * This is an alternative to {approve} that can be used as a mitigation for
771      * problems described in {IERC20-approve}.
772      *
773      * Emits an {Approval} event indicating the updated allowance.
774      *
775      * Requirements:
776      *
777      * - `spender` cannot be the zero address.
778      */
779     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
780         address owner = _msgSender();
781         _approve(owner, spender, allowance(owner, spender) + addedValue);
782         return true;
783     }
784 
785     /**
786      * @dev Atomically decreases the allowance granted to `spender` by the caller.
787      *
788      * This is an alternative to {approve} that can be used as a mitigation for
789      * problems described in {IERC20-approve}.
790      *
791      * Emits an {Approval} event indicating the updated allowance.
792      *
793      * Requirements:
794      *
795      * - `spender` cannot be the zero address.
796      * - `spender` must have allowance for the caller of at least
797      * `subtractedValue`.
798      */
799     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
800         address owner = _msgSender();
801         uint256 currentAllowance = allowance(owner, spender);
802         require(currentAllowance >= subtractedValue);
803         unchecked {
804             _approve(owner, spender, currentAllowance - subtractedValue);
805         }
806 
807         return true;
808     }
809 
810     /**
811      * @dev Moves `amount` of tokens from `from` to `to`.
812      *
813      * This internal function is equivalent to {transfer}, and can be used to
814      * e.g. implement automatic token fees, slashing mechanisms, etc.
815      *
816      * Emits a {Transfer} event.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `from` must have a balance of at least `amount`.
823      */
824     function _transfer(address from, address to, uint256 amount) internal virtual {
825         require(from != address(0));
826         require(to != address(0));
827 
828         _beforeTokenTransfer(from, to, amount);
829 
830         uint256 fromBalance = _balances[from];
831         require(fromBalance >= amount);
832         unchecked {
833             _balances[from] = fromBalance - amount;
834             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
835             // decrementing then incrementing.
836             _balances[to] += amount;
837         }
838 
839         emit Transfer(from, to, amount);
840 
841         _afterTokenTransfer(from, to, amount);
842     }
843 
844     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
845      * the total supply.
846      *
847      * Emits a {Transfer} event with `from` set to the zero address.
848      *
849      * Requirements:
850      *
851      * - `account` cannot be the zero address.
852      */
853     function _mint(address account, uint256 amount) internal virtual {
854         require(account != address(0));
855 
856         _beforeTokenTransfer(address(0), account, amount);
857 
858         _totalSupply += amount;
859         unchecked {
860             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
861             _balances[account] += amount;
862         }
863         emit Transfer(address(0), account, amount);
864 
865         _afterTokenTransfer(address(0), account, amount);
866     }
867 
868     /**
869      * @dev Destroys `amount` tokens from `account`, reducing the
870      * total supply.
871      *
872      * Emits a {Transfer} event with `to` set to the zero address.
873      *
874      * Requirements:
875      *
876      * - `account` cannot be the zero address.
877      * - `account` must have at least `amount` tokens.
878      */
879     function _burn(address account, uint256 amount) internal virtual {
880         require(account != address(0));
881 
882         _beforeTokenTransfer(account, address(0), amount);
883 
884         uint256 accountBalance = _balances[account];
885         require(accountBalance >= amount);
886         unchecked {
887             _balances[account] = accountBalance - amount;
888             // Overflow not possible: amount <= accountBalance <= totalSupply.
889             _totalSupply -= amount;
890         }
891 
892         emit Transfer(account, address(0), amount);
893 
894         _afterTokenTransfer(account, address(0), amount);
895     }
896 
897     /**
898      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
899      *
900      * This internal function is equivalent to `approve`, and can be used to
901      * e.g. set automatic allowances for certain subsystems, etc.
902      *
903      * Emits an {Approval} event.
904      *
905      * Requirements:
906      *
907      * - `owner` cannot be the zero address.
908      * - `spender` cannot be the zero address.
909      */
910     function _approve(address owner, address spender, uint256 amount) internal virtual {
911         require(owner != address(0));
912         require(spender != address(0));
913 
914         _allowances[owner][spender] = amount;
915         emit Approval(owner, spender, amount);
916     }
917 
918     /**
919      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
920      *
921      * Does not update the allowance amount in case of infinite allowance.
922      * Revert if not enough allowance is available.
923      *
924      * Might emit an {Approval} event.
925      */
926     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
927         uint256 currentAllowance = allowance(owner, spender);
928         if (currentAllowance != type(uint256).max) {
929             require(currentAllowance >= amount);
930             unchecked {
931                 _approve(owner, spender, currentAllowance - amount);
932             }
933         }
934     }
935 
936     /**
937      * @dev Hook that is called before any transfer of tokens. This includes
938      * minting and burning.
939      *
940      * Calling conditions:
941      *
942      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
943      * will be transferred to `to`.
944      * - when `from` is zero, `amount` tokens will be minted for `to`.
945      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
946      * - `from` and `to` are never both zero.
947      *
948      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
949      */
950     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
951 
952     /**
953      * @dev Hook that is called after any transfer of tokens. This includes
954      * minting and burning.
955      *
956      * Calling conditions:
957      *
958      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
959      * has been transferred to `to`.
960      * - when `from` is zero, `amount` tokens have been minted for `to`.
961      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
962      * - `from` and `to` are never both zero.
963      *
964      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
965      */
966     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
967 }
968 
969 contract FlatEarthFakeMoonLandingMKUltra1984 is ERC20, Auth {
970 
971     using SafeMath for uint256;
972 
973     uint8 constant _decimals = 18;
974     uint256 _totalSupply = 19_841_984_000000000000000000; // (1984,1984)
975     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
976     IUniswapV2Router02 router = IUniswapV2Router02(routerAddress);
977     address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
978     address constant ZERO = address(0);
979     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
980     address constant public seed = 0x2B52660815E0825f19dC07B36e205FfEcD04ed40;
981     address constant public team = 0x47524D28884F1370Be607339ee64A605eC4a2c2A;
982     address constant public teamLocked = 0xA5ad6C67a370e817fD6aA731637434Ad5bBa1fc9;
983     address constant public incentives = 0x56Ae90D07a44b3B894317aec8e0Ad051Cd81e22C;
984     address public pair;
985     // bot and whale protection
986     mapping (address => bool) unlimited;
987     uint256 public maxWallet = _totalSupply.mul(15).div(1000); // 1.5%
988     uint256 public launchedAt;
989     
990     constructor()
991     ERC20("FlatEarthFakeMoonLandingMKUltra1984", "$MONERO") {
992         _mint(msg.sender, _totalSupply.mul(2).div(100));
993         _mint(seed, _totalSupply.mul(75).div(100));
994         _mint(team, _totalSupply.mul(55).div(1000));
995         _mint(teamLocked, _totalSupply.mul(75).div(1000));
996         _mint(incentives, _totalSupply.div(10));
997         pair = IUniswapV2Factory(router.factory()).createPair(address(this), WETH);
998         launchedAt = block.timestamp;
999         unlimited[msg.sender] = true;
1000         unlimited[seed] = true;
1001         unlimited[team] = true;
1002         unlimited[teamLocked] = true;
1003         unlimited[incentives] = true;
1004         unlimited[routerAddress] = true;
1005         unlimited[DEAD] = true;
1006         unlimited[ZERO] = true;
1007         unlimited[pair] = true; 
1008     }
1009 
1010     function getCirculatingSupply() public view returns (uint256) {
1011         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
1012     }
1013 
1014     function increaseMaxWallet() external authorized {
1015         require(block.timestamp >= launchedAt.add(24 hours), "Wait a bit more");
1016         maxWallet = _totalSupply.mul(3).div(100); // after 1 day: maxWallet 1.5% -> 3%
1017     }
1018 
1019     function approveMax(address spender) public returns (bool) {
1020         return approve(spender, _totalSupply);
1021     }
1022 
1023     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1024         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1025         _balances[recipient] = _balances[recipient].add(amount);
1026         return true;
1027     }
1028 
1029     function transfer(address recipient, uint256 amount) public override returns (bool) {
1030         return _transferFrom(msg.sender, recipient, amount);
1031     }
1032 
1033     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1034         if(_allowances[sender][msg.sender] != _totalSupply){
1035             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
1036         }
1037         return _transferFrom(sender, recipient, amount);
1038     }
1039 
1040     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
1041         require(_balances[sender] >= amount, "Insufficient balance");
1042         
1043         bool isSell = recipient == pair || recipient == routerAddress;       
1044         if (!isSell && !unlimited[recipient]) require((_balances[recipient].add(amount)) < maxWallet.add(1), "maxWallet reached");
1045 
1046         _balances[sender] = _balances[sender].sub(amount);
1047         _balances[recipient] = _balances[recipient].add(amount);
1048         emit Transfer(sender, recipient, amount);
1049 
1050         return true;
1051     }
1052 
1053 }