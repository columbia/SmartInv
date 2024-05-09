1 // SPDX-License-Identifier: MIT
2 /**
3  * @title Furie's Pepe
4  * @notice All tax from the buys and sells go directly towards Matt Furie, we are doing what Pepe couldn’t do.
5  * Twitter : https://twitter.com/furies_pepe
6  */
7 
8 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
9 
10 pragma solidity >=0.6.2;
11 
12 interface IUniswapV2Router01 {
13     function factory() external pure returns (address);
14     function WETH() external pure returns (address);
15 
16     function addLiquidity(
17         address tokenA,
18         address tokenB,
19         uint amountADesired,
20         uint amountBDesired,
21         uint amountAMin,
22         uint amountBMin,
23         address to,
24         uint deadline
25     ) external returns (uint amountA, uint amountB, uint liquidity);
26     function addLiquidityETH(
27         address token,
28         uint amountTokenDesired,
29         uint amountTokenMin,
30         uint amountETHMin,
31         address to,
32         uint deadline
33     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
34     function removeLiquidity(
35         address tokenA,
36         address tokenB,
37         uint liquidity,
38         uint amountAMin,
39         uint amountBMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountA, uint amountB);
43     function removeLiquidityETH(
44         address token,
45         uint liquidity,
46         uint amountTokenMin,
47         uint amountETHMin,
48         address to,
49         uint deadline
50     ) external returns (uint amountToken, uint amountETH);
51     function removeLiquidityWithPermit(
52         address tokenA,
53         address tokenB,
54         uint liquidity,
55         uint amountAMin,
56         uint amountBMin,
57         address to,
58         uint deadline,
59         bool approveMax, uint8 v, bytes32 r, bytes32 s
60     ) external returns (uint amountA, uint amountB);
61     function removeLiquidityETHWithPermit(
62         address token,
63         uint liquidity,
64         uint amountTokenMin,
65         uint amountETHMin,
66         address to,
67         uint deadline,
68         bool approveMax, uint8 v, bytes32 r, bytes32 s
69     ) external returns (uint amountToken, uint amountETH);
70     function swapExactTokensForTokens(
71         uint amountIn,
72         uint amountOutMin,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapTokensForExactTokens(
78         uint amountOut,
79         uint amountInMax,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external returns (uint[] memory amounts);
84     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         payable
87         returns (uint[] memory amounts);
88     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
89         external
90         returns (uint[] memory amounts);
91     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
92         external
93         returns (uint[] memory amounts);
94     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
95         external
96         payable
97         returns (uint[] memory amounts);
98 
99     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
100     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
101     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
102     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
103     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
104 }
105 
106 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
107 
108 pragma solidity >=0.6.2;
109 
110 
111 interface IUniswapV2Router02 is IUniswapV2Router01 {
112     function removeLiquidityETHSupportingFeeOnTransferTokens(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external returns (uint amountETH);
120     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountETH);
129 
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
153 
154 pragma solidity >=0.5.0;
155 
156 interface IUniswapV2Pair {
157     event Approval(address indexed owner, address indexed spender, uint value);
158     event Transfer(address indexed from, address indexed to, uint value);
159 
160     function name() external pure returns (string memory);
161     function symbol() external pure returns (string memory);
162     function decimals() external pure returns (uint8);
163     function totalSupply() external view returns (uint);
164     function balanceOf(address owner) external view returns (uint);
165     function allowance(address owner, address spender) external view returns (uint);
166 
167     function approve(address spender, uint value) external returns (bool);
168     function transfer(address to, uint value) external returns (bool);
169     function transferFrom(address from, address to, uint value) external returns (bool);
170 
171     function DOMAIN_SEPARATOR() external view returns (bytes32);
172     function PERMIT_TYPEHASH() external pure returns (bytes32);
173     function nonces(address owner) external view returns (uint);
174 
175     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
176 
177     event Mint(address indexed sender, uint amount0, uint amount1);
178     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
179     event Swap(
180         address indexed sender,
181         uint amount0In,
182         uint amount1In,
183         uint amount0Out,
184         uint amount1Out,
185         address indexed to
186     );
187     event Sync(uint112 reserve0, uint112 reserve1);
188 
189     function MINIMUM_LIQUIDITY() external pure returns (uint);
190     function factory() external view returns (address);
191     function token0() external view returns (address);
192     function token1() external view returns (address);
193     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
194     function price0CumulativeLast() external view returns (uint);
195     function price1CumulativeLast() external view returns (uint);
196     function kLast() external view returns (uint);
197 
198     function mint(address to) external returns (uint liquidity);
199     function burn(address to) external returns (uint amount0, uint amount1);
200     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
201     function skim(address to) external;
202     function sync() external;
203 
204     function initialize(address, address) external;
205 }
206 
207 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
208 
209 pragma solidity >=0.5.0;
210 
211 interface IUniswapV2Factory {
212     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
213 
214     function feeTo() external view returns (address);
215     function feeToSetter() external view returns (address);
216 
217     function getPair(address tokenA, address tokenB) external view returns (address pair);
218     function allPairs(uint) external view returns (address pair);
219     function allPairsLength() external view returns (uint);
220 
221     function createPair(address tokenA, address tokenB) external returns (address pair);
222 
223     function setFeeTo(address) external;
224     function setFeeToSetter(address) external;
225 }
226 
227 // File: @openzeppelin/contracts/utils/Context.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         _checkOwner();
291         _;
292     }
293 
294     /**
295      * @dev Returns the address of the current owner.
296      */
297     function owner() public view virtual returns (address) {
298         return _owner;
299     }
300 
301     /**
302      * @dev Throws if the sender is not the owner.
303      */
304     function _checkOwner() internal view virtual {
305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public virtual onlyOwner {
316         _transferOwnership(address(0));
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         _transferOwnership(newOwner);
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Internal function without access restriction.
331      */
332     function _transferOwnership(address newOwner) internal virtual {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Interface of the ERC20 standard as defined in the EIP.
348  */
349 interface IERC20 {
350     /**
351      * @dev Emitted when `value` tokens are moved from one account (`from`) to
352      * another (`to`).
353      *
354      * Note that `value` may be zero.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 value);
357 
358     /**
359      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
360      * a call to {approve}. `value` is the new allowance.
361      */
362     event Approval(address indexed owner, address indexed spender, uint256 value);
363 
364     /**
365      * @dev Returns the amount of tokens in existence.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns the amount of tokens owned by `account`.
371      */
372     function balanceOf(address account) external view returns (uint256);
373 
374     /**
375      * @dev Moves `amount` tokens from the caller's account to `to`.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transfer(address to, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Returns the remaining number of tokens that `spender` will be
385      * allowed to spend on behalf of `owner` through {transferFrom}. This is
386      * zero by default.
387      *
388      * This value changes when {approve} or {transferFrom} are called.
389      */
390     function allowance(address owner, address spender) external view returns (uint256);
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
398      * that someone may use both the old and the new allowance by unfortunate
399      * transaction ordering. One possible solution to mitigate this race
400      * condition is to first reduce the spender's allowance to 0 and set the
401      * desired value afterwards:
402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address spender, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Moves `amount` tokens from `from` to `to` using the
410      * allowance mechanism. `amount` is then deducted from the caller's
411      * allowance.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 amount
421     ) external returns (bool);
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 
432 /**
433  * @dev Interface for the optional metadata functions from the ERC20 standard.
434  *
435  * _Available since v4.1._
436  */
437 interface IERC20Metadata is IERC20 {
438     /**
439      * @dev Returns the name of the token.
440      */
441     function name() external view returns (string memory);
442 
443     /**
444      * @dev Returns the symbol of the token.
445      */
446     function symbol() external view returns (string memory);
447 
448     /**
449      * @dev Returns the decimals places of the token.
450      */
451     function decimals() external view returns (uint8);
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
455 
456 
457 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 
463 
464 /**
465  * @dev Implementation of the {IERC20} interface.
466  *
467  * This implementation is agnostic to the way tokens are created. This means
468  * that a supply mechanism has to be added in a derived contract using {_mint}.
469  * For a generic mechanism see {ERC20PresetMinterPauser}.
470  *
471  * TIP: For a detailed writeup see our guide
472  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
473  * to implement supply mechanisms].
474  *
475  * We have followed general OpenZeppelin Contracts guidelines: functions revert
476  * instead returning `false` on failure. This behavior is nonetheless
477  * conventional and does not conflict with the expectations of ERC20
478  * applications.
479  *
480  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
481  * This allows applications to reconstruct the allowance for all accounts just
482  * by listening to said events. Other implementations of the EIP may not emit
483  * these events, as it isn't required by the specification.
484  *
485  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
486  * functions have been added to mitigate the well-known issues around setting
487  * allowances. See {IERC20-approve}.
488  */
489 contract ERC20 is Context, IERC20, IERC20Metadata {
490     mapping(address => uint256) private _balances;
491 
492     mapping(address => mapping(address => uint256)) private _allowances;
493 
494     uint256 private _totalSupply;
495 
496     string private _name;
497     string private _symbol;
498 
499     /**
500      * @dev Sets the values for {name} and {symbol}.
501      *
502      * The default value of {decimals} is 18. To select a different value for
503      * {decimals} you should overload it.
504      *
505      * All two of these values are immutable: they can only be set once during
506      * construction.
507      */
508     constructor(string memory name_, string memory symbol_) {
509         _name = name_;
510         _symbol = symbol_;
511     }
512 
513     /**
514      * @dev Returns the name of the token.
515      */
516     function name() public view virtual override returns (string memory) {
517         return _name;
518     }
519 
520     /**
521      * @dev Returns the symbol of the token, usually a shorter version of the
522      * name.
523      */
524     function symbol() public view virtual override returns (string memory) {
525         return _symbol;
526     }
527 
528     /**
529      * @dev Returns the number of decimals used to get its user representation.
530      * For example, if `decimals` equals `2`, a balance of `505` tokens should
531      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
532      *
533      * Tokens usually opt for a value of 18, imitating the relationship between
534      * Ether and Wei. This is the value {ERC20} uses, unless this function is
535      * overridden;
536      *
537      * NOTE: This information is only used for _display_ purposes: it in
538      * no way affects any of the arithmetic of the contract, including
539      * {IERC20-balanceOf} and {IERC20-transfer}.
540      */
541     function decimals() public view virtual override returns (uint8) {
542         return 18;
543     }
544 
545     /**
546      * @dev See {IERC20-totalSupply}.
547      */
548     function totalSupply() public view virtual override returns (uint256) {
549         return _totalSupply;
550     }
551 
552     /**
553      * @dev See {IERC20-balanceOf}.
554      */
555     function balanceOf(address account) public view virtual override returns (uint256) {
556         return _balances[account];
557     }
558 
559     /**
560      * @dev See {IERC20-transfer}.
561      *
562      * Requirements:
563      *
564      * - `to` cannot be the zero address.
565      * - the caller must have a balance of at least `amount`.
566      */
567     function transfer(address to, uint256 amount) public virtual override returns (bool) {
568         address owner = _msgSender();
569         _transfer(owner, to, amount);
570         return true;
571     }
572 
573     /**
574      * @dev See {IERC20-allowance}.
575      */
576     function allowance(address owner, address spender) public view virtual override returns (uint256) {
577         return _allowances[owner][spender];
578     }
579 
580     /**
581      * @dev See {IERC20-approve}.
582      *
583      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
584      * `transferFrom`. This is semantically equivalent to an infinite approval.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function approve(address spender, uint256 amount) public virtual override returns (bool) {
591         address owner = _msgSender();
592         _approve(owner, spender, amount);
593         return true;
594     }
595 
596     /**
597      * @dev See {IERC20-transferFrom}.
598      *
599      * Emits an {Approval} event indicating the updated allowance. This is not
600      * required by the EIP. See the note at the beginning of {ERC20}.
601      *
602      * NOTE: Does not update the allowance if the current allowance
603      * is the maximum `uint256`.
604      *
605      * Requirements:
606      *
607      * - `from` and `to` cannot be the zero address.
608      * - `from` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``from``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 amount
616     ) public virtual override returns (bool) {
617         address spender = _msgSender();
618         _spendAllowance(from, spender, amount);
619         _transfer(from, to, amount);
620         return true;
621     }
622 
623     /**
624      * @dev Atomically increases the allowance granted to `spender` by the caller.
625      *
626      * This is an alternative to {approve} that can be used as a mitigation for
627      * problems described in {IERC20-approve}.
628      *
629      * Emits an {Approval} event indicating the updated allowance.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      */
635     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
636         address owner = _msgSender();
637         _approve(owner, spender, allowance(owner, spender) + addedValue);
638         return true;
639     }
640 
641     /**
642      * @dev Atomically decreases the allowance granted to `spender` by the caller.
643      *
644      * This is an alternative to {approve} that can be used as a mitigation for
645      * problems described in {IERC20-approve}.
646      *
647      * Emits an {Approval} event indicating the updated allowance.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      * - `spender` must have allowance for the caller of at least
653      * `subtractedValue`.
654      */
655     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
656         address owner = _msgSender();
657         uint256 currentAllowance = allowance(owner, spender);
658         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
659         unchecked {
660             _approve(owner, spender, currentAllowance - subtractedValue);
661         }
662 
663         return true;
664     }
665 
666     /**
667      * @dev Moves `amount` of tokens from `from` to `to`.
668      *
669      * This internal function is equivalent to {transfer}, and can be used to
670      * e.g. implement automatic token fees, slashing mechanisms, etc.
671      *
672      * Emits a {Transfer} event.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `from` must have a balance of at least `amount`.
679      */
680     function _transfer(
681         address from,
682         address to,
683         uint256 amount
684     ) internal virtual {
685         require(from != address(0), "ERC20: transfer from the zero address");
686         require(to != address(0), "ERC20: transfer to the zero address");
687 
688         _beforeTokenTransfer(from, to, amount);
689 
690         uint256 fromBalance = _balances[from];
691         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
692         unchecked {
693             _balances[from] = fromBalance - amount;
694             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
695             // decrementing then incrementing.
696             _balances[to] += amount;
697         }
698 
699         emit Transfer(from, to, amount);
700 
701         _afterTokenTransfer(from, to, amount);
702     }
703 
704     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
705      * the total supply.
706      *
707      * Emits a {Transfer} event with `from` set to the zero address.
708      *
709      * Requirements:
710      *
711      * - `account` cannot be the zero address.
712      */
713     function _mint(address account, uint256 amount) internal virtual {
714         require(account != address(0), "ERC20: mint to the zero address");
715 
716         _beforeTokenTransfer(address(0), account, amount);
717 
718         _totalSupply += amount;
719         unchecked {
720             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
721             _balances[account] += amount;
722         }
723         emit Transfer(address(0), account, amount);
724 
725         _afterTokenTransfer(address(0), account, amount);
726     }
727 
728     /**
729      * @dev Destroys `amount` tokens from `account`, reducing the
730      * total supply.
731      *
732      * Emits a {Transfer} event with `to` set to the zero address.
733      *
734      * Requirements:
735      *
736      * - `account` cannot be the zero address.
737      * - `account` must have at least `amount` tokens.
738      */
739     function _burn(address account, uint256 amount) internal virtual {
740         require(account != address(0), "ERC20: burn from the zero address");
741 
742         _beforeTokenTransfer(account, address(0), amount);
743 
744         uint256 accountBalance = _balances[account];
745         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
746         unchecked {
747             _balances[account] = accountBalance - amount;
748             // Overflow not possible: amount <= accountBalance <= totalSupply.
749             _totalSupply -= amount;
750         }
751 
752         emit Transfer(account, address(0), amount);
753 
754         _afterTokenTransfer(account, address(0), amount);
755     }
756 
757     /**
758      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
759      *
760      * This internal function is equivalent to `approve`, and can be used to
761      * e.g. set automatic allowances for certain subsystems, etc.
762      *
763      * Emits an {Approval} event.
764      *
765      * Requirements:
766      *
767      * - `owner` cannot be the zero address.
768      * - `spender` cannot be the zero address.
769      */
770     function _approve(
771         address owner,
772         address spender,
773         uint256 amount
774     ) internal virtual {
775         require(owner != address(0), "ERC20: approve from the zero address");
776         require(spender != address(0), "ERC20: approve to the zero address");
777 
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     /**
783      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
784      *
785      * Does not update the allowance amount in case of infinite allowance.
786      * Revert if not enough allowance is available.
787      *
788      * Might emit an {Approval} event.
789      */
790     function _spendAllowance(
791         address owner,
792         address spender,
793         uint256 amount
794     ) internal virtual {
795         uint256 currentAllowance = allowance(owner, spender);
796         if (currentAllowance != type(uint256).max) {
797             require(currentAllowance >= amount, "ERC20: insufficient allowance");
798             unchecked {
799                 _approve(owner, spender, currentAllowance - amount);
800             }
801         }
802     }
803 
804     /**
805      * @dev Hook that is called before any transfer of tokens. This includes
806      * minting and burning.
807      *
808      * Calling conditions:
809      *
810      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
811      * will be transferred to `to`.
812      * - when `from` is zero, `amount` tokens will be minted for `to`.
813      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
814      * - `from` and `to` are never both zero.
815      *
816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
817      */
818     function _beforeTokenTransfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal virtual {}
823 
824     /**
825      * @dev Hook that is called after any transfer of tokens. This includes
826      * minting and burning.
827      *
828      * Calling conditions:
829      *
830      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
831      * has been transferred to `to`.
832      * - when `from` is zero, `amount` tokens have been minted for `to`.
833      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
834      * - `from` and `to` are never both zero.
835      *
836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
837      */
838     function _afterTokenTransfer(
839         address from,
840         address to,
841         uint256 amount
842     ) internal virtual {}
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
846 
847 
848 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 
853 
854 /**
855  * @dev Extension of {ERC20} that allows token holders to destroy both their own
856  * tokens and those that they have an allowance for, in a way that can be
857  * recognized off-chain (via event analysis).
858  */
859 abstract contract ERC20Burnable is Context, ERC20 {
860     /**
861      * @dev Destroys `amount` tokens from the caller.
862      *
863      * See {ERC20-_burn}.
864      */
865     function burn(uint256 amount) public virtual {
866         _burn(_msgSender(), amount);
867     }
868 
869     /**
870      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
871      * allowance.
872      *
873      * See {ERC20-_burn} and {ERC20-allowance}.
874      *
875      * Requirements:
876      *
877      * - the caller must have allowance for ``accounts``'s tokens of at least
878      * `amount`.
879      */
880     function burnFrom(address account, uint256 amount) public virtual {
881         _spendAllowance(account, _msgSender(), amount);
882         _burn(account, amount);
883     }
884 }
885 
886 // File: contracts/Furie.sol
887 
888 
889 /**
890  * @title Furie's Pepe
891  * @notice All tax from the buys and sells go directly towards Matt furie, we are doing what Pepe couldn’t do.
892  * Twitter: 
893  */
894 pragma solidity ^0.8.17;
895 
896 
897 
898 
899 
900 
901 
902 
903 contract FuriesPepe is ERC20, ERC20Burnable, Ownable {
904     uint256 public purchaseTax = 1;
905     uint256 public sellTax = 1;
906     address public _uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
907     uint256 MAX_WALLET_PERCENTAGE = 2; 
908     uint256 MAX_TX_PERCENTAGE = 2;
909     uint256 SWAP_TOKENS_AT_AMOUNT_PERCENTAGE = 1;
910     
911     address payable public marketingWallet = payable(0x826ffcd1514588947ec0ba19d94bF2ec353af398);
912     IUniswapV2Router02 public uniswapV2Router;
913     address public uniswapV2Pair;
914 
915     mapping(address => bool) private _isExcludedFromFee;
916     bool public tradingOpen = true;
917     bool public inSwap = false;
918     bool public swapEnabled = true;
919     modifier lockTheSwap {
920         inSwap = true;
921         _;
922         inSwap = false;
923     }
924 
925     constructor() ERC20("Furie's Pepe", "FPEPE") {
926         _mint(msg.sender, 420690000000000 * 10 ** decimals());
927         uniswapV2Router = IUniswapV2Router02(_uniswapV2Router);
928         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
929 
930         _isExcludedFromFee[owner()] = true;
931         _isExcludedFromFee[address(this)] = true;
932         _isExcludedFromFee[marketingWallet] = true;
933         _isExcludedFromFee[address(0xdead)] = true;
934     }
935 
936     function transfer(address recipient, uint256 amount) public override returns (bool) {
937         amount = transferTaxes(_msgSender(), recipient, amount);
938         _transfer(_msgSender(), recipient, amount);
939         return true;
940     }
941 
942     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
943         amount = transferTaxes(sender, recipient, amount);
944         _transfer(sender, recipient, amount);
945         _approve(sender, _msgSender(), allowance(sender, _msgSender()) - amount);
946         return true;
947     }
948 
949     function transferTaxes(address sender, address recipient, uint256 amount) private returns (uint256) {
950         if (sender != owner() && recipient != owner()) {
951             //Trade start check
952             if (!tradingOpen) {
953                 require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
954             }
955             if(recipient != uniswapV2Pair && recipient != address(this) && recipient != address(uniswapV2Router)) {
956                 require(amount <= getMaxTxAmount(), "TOKEN: Max Transaction Limit");
957             }
958             if(recipient != uniswapV2Pair && recipient != address(this) && recipient != address(uniswapV2Router)) {
959                 require(balanceOf(recipient) + amount  < getMaxWalletAmount(), "TOKEN: Balance exceeds wallet size!");
960             }
961             uint256 contractTokenBalance = balanceOf(address(this));
962             bool canSwap = contractTokenBalance >= getSwapTokensAtAmount();
963             if(contractTokenBalance >= getMaxTxAmount())
964             {
965                 contractTokenBalance = getMaxTxAmount();
966             }
967             if (canSwap && !inSwap && sender != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]) {
968                 swapTokensForEth(contractTokenBalance);
969                 uint256 contractETHBalance = address(this).balance;
970                 if (contractETHBalance > 0) {
971                     sendETHToFee(contractETHBalance);
972                 }
973             }
974             uint256 taxAmount = 0;   
975             if ((_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) || (sender != uniswapV2Pair && recipient != uniswapV2Pair)) {
976             } else {         
977                 if(sender == uniswapV2Pair && recipient != address(uniswapV2Router)) {
978                     taxAmount = amount * purchaseTax / 100;
979                 } else if (recipient == uniswapV2Pair && sender != address(uniswapV2Router)) {
980                     taxAmount = amount * sellTax / 100;
981                 }
982                 if (taxAmount > 0) {
983                     _transfer(sender, address(this), taxAmount);
984                     amount = amount - taxAmount;
985                 }
986             }
987         }
988         return amount;
989     }
990 
991     function setMarketingWallet(address newWallet) external onlyOwner {
992         marketingWallet = payable(newWallet);
993     }
994 
995     function enableTrading() external onlyOwner {
996         tradingOpen = true;
997     }
998 
999     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1000         address[] memory path = new address[](2);
1001         path[0] = address(this);
1002         path[1] = uniswapV2Router.WETH();
1003         _approve(address(this), address(uniswapV2Router), tokenAmount);
1004         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1005             tokenAmount,
1006             0,
1007             path,
1008             address(this),
1009             block.timestamp
1010         );
1011     }
1012 
1013     function sendETHToFee(uint256 amount) private {
1014         marketingWallet.transfer(amount);
1015     }
1016 
1017     function manualSwap() external {
1018         require(_msgSender() == marketingWallet);
1019         uint256 contractTokenBalance = balanceOf(address(this));
1020         swapTokensForEth(contractTokenBalance);
1021     }
1022 
1023     function manualSend() external {
1024         require(_msgSender() == marketingWallet);
1025         uint256 contractETHBalance = address(this).balance;
1026         sendETHToFee(contractETHBalance);
1027     }
1028 
1029     function toggleSwap (bool _swapEnabled) public onlyOwner {
1030         swapEnabled = _swapEnabled;
1031     }
1032 
1033     function getMaxWalletAmount() public view returns (uint256) {
1034         uint256 maxBalance = totalSupply() * MAX_WALLET_PERCENTAGE / 100;
1035         return maxBalance;
1036     }
1037 
1038     function setMaxWalletAmount(uint maxWalletAmount) external onlyOwner {
1039         require(maxWalletAmount <= 5, "Max wallet amount cannot be more than 5% of total supply");
1040         MAX_WALLET_PERCENTAGE = maxWalletAmount;
1041     }
1042 
1043     function getMaxTxAmount() public view returns (uint256) {
1044         uint256 maxTxAmount = totalSupply() * MAX_TX_PERCENTAGE / 100;
1045         return maxTxAmount;
1046     }
1047 
1048     function setMaxTxAmount(uint maxTxAmount) external onlyOwner {
1049         require(maxTxAmount <= 2, "Max TX amount cannot be more than 2% of total supply");
1050         MAX_TX_PERCENTAGE = maxTxAmount;
1051     }
1052 
1053     function getSwapTokensAtAmount() public view returns (uint256) {
1054         uint256 swapTokensAtAmount = totalSupply() * SWAP_TOKENS_AT_AMOUNT_PERCENTAGE / 100;
1055         return swapTokensAtAmount;
1056     }
1057 
1058     function adjustPurchaseTax(uint256 newPurchaseTax) external onlyOwner {
1059         require(newPurchaseTax <= 10, "Purchase tax cannot be more than 10%");
1060         purchaseTax = newPurchaseTax;
1061     }
1062 
1063     function adjustSellTax(uint256 newSellTax) external onlyOwner {
1064         require(newSellTax <= 10, "Sell tax cannot be more than 10%");
1065         sellTax = newSellTax;
1066     }
1067 
1068     function setSwapTokensAtAmount(uint swapTokensAtAmount) external onlyOwner {
1069         require(swapTokensAtAmount <= 5, "Swap tokens at amount cannot be more than 5% of total supply");
1070         SWAP_TOKENS_AT_AMOUNT_PERCENTAGE = swapTokensAtAmount;
1071     }
1072 
1073     receive() external payable {}
1074 }