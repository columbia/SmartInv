1 // SPDX-License-Identifier: MIT
2 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
3 
4 pragma solidity >=0.6.2;
5 
6 interface IUniswapV2Router01 {
7     function factory() external pure returns (address);
8     function WETH() external pure returns (address);
9 
10     function addLiquidity(
11         address tokenA,
12         address tokenB,
13         uint amountADesired,
14         uint amountBDesired,
15         uint amountAMin,
16         uint amountBMin,
17         address to,
18         uint deadline
19     ) external returns (uint amountA, uint amountB, uint liquidity);
20     function addLiquidityETH(
21         address token,
22         uint amountTokenDesired,
23         uint amountTokenMin,
24         uint amountETHMin,
25         address to,
26         uint deadline
27     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
28     function removeLiquidity(
29         address tokenA,
30         address tokenB,
31         uint liquidity,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB);
37     function removeLiquidityETH(
38         address token,
39         uint liquidity,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external returns (uint amountToken, uint amountETH);
45     function removeLiquidityWithPermit(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline,
53         bool approveMax, uint8 v, bytes32 r, bytes32 s
54     ) external returns (uint amountA, uint amountB);
55     function removeLiquidityETHWithPermit(
56         address token,
57         uint liquidity,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline,
62         bool approveMax, uint8 v, bytes32 r, bytes32 s
63     ) external returns (uint amountToken, uint amountETH);
64     function swapExactTokensForTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external returns (uint[] memory amounts);
71     function swapTokensForExactTokens(
72         uint amountOut,
73         uint amountInMax,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
79         external
80         payable
81         returns (uint[] memory amounts);
82     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
89         external
90         payable
91         returns (uint[] memory amounts);
92 
93     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
94     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
95     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
96     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
97     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
98 }
99 
100 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
101 
102 pragma solidity >=0.6.2;
103 
104 
105 interface IUniswapV2Router02 is IUniswapV2Router01 {
106     function removeLiquidityETHSupportingFeeOnTransferTokens(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountETH);
114     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline,
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122     ) external returns (uint amountETH);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131     function swapExactETHForTokensSupportingFeeOnTransferTokens(
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external payable;
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 }
145 
146 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
147 
148 pragma solidity >=0.5.0;
149 
150 interface IUniswapV2Pair {
151     event Approval(address indexed owner, address indexed spender, uint value);
152     event Transfer(address indexed from, address indexed to, uint value);
153 
154     function name() external pure returns (string memory);
155     function symbol() external pure returns (string memory);
156     function decimals() external pure returns (uint8);
157     function totalSupply() external view returns (uint);
158     function balanceOf(address owner) external view returns (uint);
159     function allowance(address owner, address spender) external view returns (uint);
160 
161     function approve(address spender, uint value) external returns (bool);
162     function transfer(address to, uint value) external returns (bool);
163     function transferFrom(address from, address to, uint value) external returns (bool);
164 
165     function DOMAIN_SEPARATOR() external view returns (bytes32);
166     function PERMIT_TYPEHASH() external pure returns (bytes32);
167     function nonces(address owner) external view returns (uint);
168 
169     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
170 
171     event Mint(address indexed sender, uint amount0, uint amount1);
172     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
173     event Swap(
174         address indexed sender,
175         uint amount0In,
176         uint amount1In,
177         uint amount0Out,
178         uint amount1Out,
179         address indexed to
180     );
181     event Sync(uint112 reserve0, uint112 reserve1);
182 
183     function MINIMUM_LIQUIDITY() external pure returns (uint);
184     function factory() external view returns (address);
185     function token0() external view returns (address);
186     function token1() external view returns (address);
187     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
188     function price0CumulativeLast() external view returns (uint);
189     function price1CumulativeLast() external view returns (uint);
190     function kLast() external view returns (uint);
191 
192     function mint(address to) external returns (uint liquidity);
193     function burn(address to) external returns (uint amount0, uint amount1);
194     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
195     function skim(address to) external;
196     function sync() external;
197 
198     function initialize(address, address) external;
199 }
200 
201 // File: @openzeppelin/contracts/utils/Context.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/access/Ownable.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 abstract contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor() {
257         _transferOwnership(_msgSender());
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         _checkOwner();
265         _;
266     }
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view virtual returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if the sender is not the owner.
277      */
278     function _checkOwner() internal view virtual {
279         require(owner() == _msgSender(), "Ownable: caller is not the owner");
280     }
281 
282     /**
283      * @dev Leaves the contract without owner. It will not be possible to call
284      * `onlyOwner` functions anymore. Can only be called by the current owner.
285      *
286      * NOTE: Renouncing ownership will leave the contract without an owner,
287      * thereby removing any functionality that is only available to the owner.
288      */
289     function renounceOwnership() public virtual onlyOwner {
290         _transferOwnership(address(0));
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Can only be called by the current owner.
296      */
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         _transferOwnership(newOwner);
300     }
301 
302     /**
303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
304      * Internal function without access restriction.
305      */
306     function _transferOwnership(address newOwner) internal virtual {
307         address oldOwner = _owner;
308         _owner = newOwner;
309         emit OwnershipTransferred(oldOwner, newOwner);
310     }
311 }
312 
313 // File: @openzeppelin/contracts/security/Pausable.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Contract module which allows children to implement an emergency stop
323  * mechanism that can be triggered by an authorized account.
324  *
325  * This module is used through inheritance. It will make available the
326  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
327  * the functions of your contract. Note that they will not be pausable by
328  * simply including this module, only once the modifiers are put in place.
329  */
330 abstract contract Pausable is Context {
331     /**
332      * @dev Emitted when the pause is triggered by `account`.
333      */
334     event Paused(address account);
335 
336     /**
337      * @dev Emitted when the pause is lifted by `account`.
338      */
339     event Unpaused(address account);
340 
341     bool private _paused;
342 
343     /**
344      * @dev Initializes the contract in unpaused state.
345      */
346     constructor() {
347         _paused = false;
348     }
349 
350     /**
351      * @dev Modifier to make a function callable only when the contract is not paused.
352      *
353      * Requirements:
354      *
355      * - The contract must not be paused.
356      */
357     modifier whenNotPaused() {
358         _requireNotPaused();
359         _;
360     }
361 
362     /**
363      * @dev Modifier to make a function callable only when the contract is paused.
364      *
365      * Requirements:
366      *
367      * - The contract must be paused.
368      */
369     modifier whenPaused() {
370         _requirePaused();
371         _;
372     }
373 
374     /**
375      * @dev Returns true if the contract is paused, and false otherwise.
376      */
377     function paused() public view virtual returns (bool) {
378         return _paused;
379     }
380 
381     /**
382      * @dev Throws if the contract is paused.
383      */
384     function _requireNotPaused() internal view virtual {
385         require(!paused(), "Pausable: paused");
386     }
387 
388     /**
389      * @dev Throws if the contract is not paused.
390      */
391     function _requirePaused() internal view virtual {
392         require(paused(), "Pausable: not paused");
393     }
394 
395     /**
396      * @dev Triggers stopped state.
397      *
398      * Requirements:
399      *
400      * - The contract must not be paused.
401      */
402     function _pause() internal virtual whenNotPaused {
403         _paused = true;
404         emit Paused(_msgSender());
405     }
406 
407     /**
408      * @dev Returns to normal state.
409      *
410      * Requirements:
411      *
412      * - The contract must be paused.
413      */
414     function _unpause() internal virtual whenPaused {
415         _paused = false;
416         emit Unpaused(_msgSender());
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
421 
422 
423 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @dev Interface of the ERC20 standard as defined in the EIP.
429  */
430 interface IERC20 {
431     /**
432      * @dev Emitted when `value` tokens are moved from one account (`from`) to
433      * another (`to`).
434      *
435      * Note that `value` may be zero.
436      */
437     event Transfer(address indexed from, address indexed to, uint256 value);
438 
439     /**
440      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
441      * a call to {approve}. `value` is the new allowance.
442      */
443     event Approval(address indexed owner, address indexed spender, uint256 value);
444 
445     /**
446      * @dev Returns the amount of tokens in existence.
447      */
448     function totalSupply() external view returns (uint256);
449 
450     /**
451      * @dev Returns the amount of tokens owned by `account`.
452      */
453     function balanceOf(address account) external view returns (uint256);
454 
455     /**
456      * @dev Moves `amount` tokens from the caller's account to `to`.
457      *
458      * Returns a boolean value indicating whether the operation succeeded.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transfer(address to, uint256 amount) external returns (bool);
463 
464     /**
465      * @dev Returns the remaining number of tokens that `spender` will be
466      * allowed to spend on behalf of `owner` through {transferFrom}. This is
467      * zero by default.
468      *
469      * This value changes when {approve} or {transferFrom} are called.
470      */
471     function allowance(address owner, address spender) external view returns (uint256);
472 
473     /**
474      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
475      *
476      * Returns a boolean value indicating whether the operation succeeded.
477      *
478      * IMPORTANT: Beware that changing an allowance with this method brings the risk
479      * that someone may use both the old and the new allowance by unfortunate
480      * transaction ordering. One possible solution to mitigate this race
481      * condition is to first reduce the spender's allowance to 0 and set the
482      * desired value afterwards:
483      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
484      *
485      * Emits an {Approval} event.
486      */
487     function approve(address spender, uint256 amount) external returns (bool);
488 
489     /**
490      * @dev Moves `amount` tokens from `from` to `to` using the
491      * allowance mechanism. `amount` is then deducted from the caller's
492      * allowance.
493      *
494      * Returns a boolean value indicating whether the operation succeeded.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 amount
502     ) external returns (bool);
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Interface for the optional metadata functions from the ERC20 standard.
515  *
516  * _Available since v4.1._
517  */
518 interface IERC20Metadata is IERC20 {
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the symbol of the token.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the decimals places of the token.
531      */
532     function decimals() external view returns (uint8);
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 
544 
545 /**
546  * @dev Implementation of the {IERC20} interface.
547  *
548  * This implementation is agnostic to the way tokens are created. This means
549  * that a supply mechanism has to be added in a derived contract using {_mint}.
550  * For a generic mechanism see {ERC20PresetMinterPauser}.
551  *
552  * TIP: For a detailed writeup see our guide
553  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
554  * to implement supply mechanisms].
555  *
556  * We have followed general OpenZeppelin Contracts guidelines: functions revert
557  * instead returning `false` on failure. This behavior is nonetheless
558  * conventional and does not conflict with the expectations of ERC20
559  * applications.
560  *
561  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
562  * This allows applications to reconstruct the allowance for all accounts just
563  * by listening to said events. Other implementations of the EIP may not emit
564  * these events, as it isn't required by the specification.
565  *
566  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
567  * functions have been added to mitigate the well-known issues around setting
568  * allowances. See {IERC20-approve}.
569  */
570 contract ERC20 is Context, IERC20, IERC20Metadata {
571     mapping(address => uint256) private _balances;
572 
573     mapping(address => mapping(address => uint256)) private _allowances;
574 
575     uint256 private _totalSupply;
576 
577     string private _name;
578     string private _symbol;
579 
580     /**
581      * @dev Sets the values for {name} and {symbol}.
582      *
583      * The default value of {decimals} is 18. To select a different value for
584      * {decimals} you should overload it.
585      *
586      * All two of these values are immutable: they can only be set once during
587      * construction.
588      */
589     constructor(string memory name_, string memory symbol_) {
590         _name = name_;
591         _symbol = symbol_;
592     }
593 
594     /**
595      * @dev Returns the name of the token.
596      */
597     function name() public view virtual override returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev Returns the symbol of the token, usually a shorter version of the
603      * name.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev Returns the number of decimals used to get its user representation.
611      * For example, if `decimals` equals `2`, a balance of `505` tokens should
612      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
613      *
614      * Tokens usually opt for a value of 18, imitating the relationship between
615      * Ether and Wei. This is the value {ERC20} uses, unless this function is
616      * overridden;
617      *
618      * NOTE: This information is only used for _display_ purposes: it in
619      * no way affects any of the arithmetic of the contract, including
620      * {IERC20-balanceOf} and {IERC20-transfer}.
621      */
622     function decimals() public view virtual override returns (uint8) {
623         return 18;
624     }
625 
626     /**
627      * @dev See {IERC20-totalSupply}.
628      */
629     function totalSupply() public view virtual override returns (uint256) {
630         return _totalSupply;
631     }
632 
633     /**
634      * @dev See {IERC20-balanceOf}.
635      */
636     function balanceOf(address account) public view virtual override returns (uint256) {
637         return _balances[account];
638     }
639 
640     /**
641      * @dev See {IERC20-transfer}.
642      *
643      * Requirements:
644      *
645      * - `to` cannot be the zero address.
646      * - the caller must have a balance of at least `amount`.
647      */
648     function transfer(address to, uint256 amount) public virtual override returns (bool) {
649         address owner = _msgSender();
650         _transfer(owner, to, amount);
651         return true;
652     }
653 
654     /**
655      * @dev See {IERC20-allowance}.
656      */
657     function allowance(address owner, address spender) public view virtual override returns (uint256) {
658         return _allowances[owner][spender];
659     }
660 
661     /**
662      * @dev See {IERC20-approve}.
663      *
664      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
665      * `transferFrom`. This is semantically equivalent to an infinite approval.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function approve(address spender, uint256 amount) public virtual override returns (bool) {
672         address owner = _msgSender();
673         _approve(owner, spender, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-transferFrom}.
679      *
680      * Emits an {Approval} event indicating the updated allowance. This is not
681      * required by the EIP. See the note at the beginning of {ERC20}.
682      *
683      * NOTE: Does not update the allowance if the current allowance
684      * is the maximum `uint256`.
685      *
686      * Requirements:
687      *
688      * - `from` and `to` cannot be the zero address.
689      * - `from` must have a balance of at least `amount`.
690      * - the caller must have allowance for ``from``'s tokens of at least
691      * `amount`.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 amount
697     ) public virtual override returns (bool) {
698         address spender = _msgSender();
699         _spendAllowance(from, spender, amount);
700         _transfer(from, to, amount);
701         return true;
702     }
703 
704     /**
705      * @dev Atomically increases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      */
716     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
717         address owner = _msgSender();
718         _approve(owner, spender, allowance(owner, spender) + addedValue);
719         return true;
720     }
721 
722     /**
723      * @dev Atomically decreases the allowance granted to `spender` by the caller.
724      *
725      * This is an alternative to {approve} that can be used as a mitigation for
726      * problems described in {IERC20-approve}.
727      *
728      * Emits an {Approval} event indicating the updated allowance.
729      *
730      * Requirements:
731      *
732      * - `spender` cannot be the zero address.
733      * - `spender` must have allowance for the caller of at least
734      * `subtractedValue`.
735      */
736     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
737         address owner = _msgSender();
738         uint256 currentAllowance = allowance(owner, spender);
739         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
740         unchecked {
741             _approve(owner, spender, currentAllowance - subtractedValue);
742         }
743 
744         return true;
745     }
746 
747     /**
748      * @dev Moves `amount` of tokens from `from` to `to`.
749      *
750      * This internal function is equivalent to {transfer}, and can be used to
751      * e.g. implement automatic token fees, slashing mechanisms, etc.
752      *
753      * Emits a {Transfer} event.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `from` must have a balance of at least `amount`.
760      */
761     function _transfer(
762         address from,
763         address to,
764         uint256 amount
765     ) internal virtual {
766         require(from != address(0), "ERC20: transfer from the zero address");
767         require(to != address(0), "ERC20: transfer to the zero address");
768 
769         _beforeTokenTransfer(from, to, amount);
770 
771         uint256 fromBalance = _balances[from];
772         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
773         unchecked {
774             _balances[from] = fromBalance - amount;
775             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
776             // decrementing then incrementing.
777             _balances[to] += amount;
778         }
779 
780         emit Transfer(from, to, amount);
781 
782         _afterTokenTransfer(from, to, amount);
783     }
784 
785     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
786      * the total supply.
787      *
788      * Emits a {Transfer} event with `from` set to the zero address.
789      *
790      * Requirements:
791      *
792      * - `account` cannot be the zero address.
793      */
794     function _mint(address account, uint256 amount) internal virtual {
795         require(account != address(0), "ERC20: mint to the zero address");
796 
797         _beforeTokenTransfer(address(0), account, amount);
798 
799         _totalSupply += amount;
800         unchecked {
801             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
802             _balances[account] += amount;
803         }
804         emit Transfer(address(0), account, amount);
805 
806         _afterTokenTransfer(address(0), account, amount);
807     }
808 
809     /**
810      * @dev Destroys `amount` tokens from `account`, reducing the
811      * total supply.
812      *
813      * Emits a {Transfer} event with `to` set to the zero address.
814      *
815      * Requirements:
816      *
817      * - `account` cannot be the zero address.
818      * - `account` must have at least `amount` tokens.
819      */
820     function _burn(address account, uint256 amount) internal virtual {
821         require(account != address(0), "ERC20: burn from the zero address");
822 
823         _beforeTokenTransfer(account, address(0), amount);
824 
825         uint256 accountBalance = _balances[account];
826         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
827         unchecked {
828             _balances[account] = accountBalance - amount;
829             // Overflow not possible: amount <= accountBalance <= totalSupply.
830             _totalSupply -= amount;
831         }
832 
833         emit Transfer(account, address(0), amount);
834 
835         _afterTokenTransfer(account, address(0), amount);
836     }
837 
838     /**
839      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
840      *
841      * This internal function is equivalent to `approve`, and can be used to
842      * e.g. set automatic allowances for certain subsystems, etc.
843      *
844      * Emits an {Approval} event.
845      *
846      * Requirements:
847      *
848      * - `owner` cannot be the zero address.
849      * - `spender` cannot be the zero address.
850      */
851     function _approve(
852         address owner,
853         address spender,
854         uint256 amount
855     ) internal virtual {
856         require(owner != address(0), "ERC20: approve from the zero address");
857         require(spender != address(0), "ERC20: approve to the zero address");
858 
859         _allowances[owner][spender] = amount;
860         emit Approval(owner, spender, amount);
861     }
862 
863     /**
864      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
865      *
866      * Does not update the allowance amount in case of infinite allowance.
867      * Revert if not enough allowance is available.
868      *
869      * Might emit an {Approval} event.
870      */
871     function _spendAllowance(
872         address owner,
873         address spender,
874         uint256 amount
875     ) internal virtual {
876         uint256 currentAllowance = allowance(owner, spender);
877         if (currentAllowance != type(uint256).max) {
878             require(currentAllowance >= amount, "ERC20: insufficient allowance");
879             unchecked {
880                 _approve(owner, spender, currentAllowance - amount);
881             }
882         }
883     }
884 
885     /**
886      * @dev Hook that is called before any transfer of tokens. This includes
887      * minting and burning.
888      *
889      * Calling conditions:
890      *
891      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
892      * will be transferred to `to`.
893      * - when `from` is zero, `amount` tokens will be minted for `to`.
894      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
895      * - `from` and `to` are never both zero.
896      *
897      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
898      */
899     function _beforeTokenTransfer(
900         address from,
901         address to,
902         uint256 amount
903     ) internal virtual {}
904 
905     /**
906      * @dev Hook that is called after any transfer of tokens. This includes
907      * minting and burning.
908      *
909      * Calling conditions:
910      *
911      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
912      * has been transferred to `to`.
913      * - when `from` is zero, `amount` tokens have been minted for `to`.
914      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
915      * - `from` and `to` are never both zero.
916      *
917      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
918      */
919     function _afterTokenTransfer(
920         address from,
921         address to,
922         uint256 amount
923     ) internal virtual {}
924 }
925 
926 // File: MuzzleToken.sol
927 
928 
929 // ..
930 pragma solidity ^0.8.19;
931 
932 
933 
934 
935 
936 
937 contract MuzzleToken is ERC20, Pausable, Ownable {
938     IUniswapV2Router02 public uniswapV2Router;
939     IUniswapV2Pair public uniswapV2Pair;
940     
941     address public development = 0x040235C58C65E66Ac538d46473B8B6A4F6177E8C;
942     address public muzzleLock = 0x218f04bB5ECB45F9D36e95daB6AdA575905de44D;
943     uint256 public sellTax = 500; // 5%
944     uint256 public buyTax = 400; // 4%
945     uint256 public unit = 10**18; // hoerutai
946     
947     bool private _notEntered;
948 
949 
950     constructor(address _uniswapV2Pair) ERC20("MuzzleToken", "MUZZ") {
951     _notEntered = true;
952     uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // dirección del router de Uniswap en la red Ethereum
953     uniswapV2Pair = IUniswapV2Pair(_uniswapV2Pair);
954     _mint(msg.sender, 21000000000 * 10 ** decimals());
955     }
956     
957     
958     modifier nonReentrant() {
959         require(_notEntered, "Reentrant call");
960         _notEntered = false;
961         _;
962         _notEntered = true;
963     }
964 
965 
966     function _transfer(address sender, address recipient, uint256 amount) internal virtual override nonReentrant {
967         if (recipient == address(0) || recipient == address(this)) {
968             // Burning or Liquidity Injection
969             super._transfer(sender, recipient, amount);
970         } else if (sender == owner() || recipient == owner()) {
971             // Owner can send and receive tokens without tax
972             super._transfer(sender, recipient, amount);
973         } else {
974             uint256 taxAmount;
975             if (msg.sender == address(uniswapV2Pair)) {
976                 // Buying tokens
977                 taxAmount = (amount * buyTax) / 10000;
978                 super._transfer(sender, development, (taxAmount * 3) / 4);
979                 super._transfer(sender, muzzleLock, (taxAmount * 1) / 4);                    
980                
981             } else {
982                 // Selling tokens
983                 if (sender != muzzleLock && sender != development) {
984                     // Excluding the addresses from tax when selling tokens   
985                     taxAmount = (amount * sellTax) / 10000;
986                     super._transfer(sender, muzzleLock, (taxAmount * 4) / 5);
987                     super._transfer(sender, development, (taxAmount * 1) / 5);
988                 } else {
989                     // No tax for excluded addresses when selling tokens
990                     super._transfer(sender, recipient, amount);
991                     return;
992                 }
993             }
994             super._transfer(sender, recipient, amount - taxAmount);
995         }            
996     }
997     function setSellTax(uint256 newSellTax) external onlyOwner {
998         require(newSellTax <= 400, "Sell tax too high");
999         sellTax = newSellTax;
1000     }
1001 
1002     function setBuyTax(uint256 newBuyTax) external onlyOwner {
1003         require(newBuyTax <= 400, "Buy tax too high");
1004         buyTax = newBuyTax;
1005     }
1006 
1007     function setOwner(address newOwner) external onlyOwner {
1008         transferOwnership(newOwner); 
1009     }
1010     // ..we are back..
1011     function pause() external onlyOwner {
1012         _pause();
1013     }
1014 
1015     function unpause() external onlyOwner {
1016         _unpause();
1017     }
1018 
1019     function withdrawTokens(address token, uint256 amount) external onlyOwner {
1020         IERC20(token).transfer(msg.sender, amount);
1021     }
1022 
1023     function withdrawETH(uint256 amount) external onlyOwner {
1024         payable(msg.sender).transfer(amount);
1025     }
1026 }