1 //SPDX-License-Identifier: MIT
2 // pragma solidity ^0.8;
3 pragma solidity ^0.8.0;
4 
5 // https://uniswap.org/docs/v2/smart-contracts
6 
7 interface IUniswapV2Router {
8   function getAmountsOut(uint amountIn, address[] memory path)
9     external
10     view
11     returns (uint[] memory amounts);
12     // function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
13     // function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
14     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
15 
16     function getPair(address tokenA, address tokenB)
17         external
18         view
19         returns (address pair);
20 
21     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
22         uint256 amountIn,
23         uint256 amountOutMin,
24         address[] calldata path,
25         address to,
26         uint256 deadline
27     ) external;
28 
29     function swapExactETHForTokensSupportingFeeOnTransferTokens(
30         uint256 amountOutMin,
31         address[] calldata path,
32         address to,
33         uint256 deadline
34     ) external payable;
35 
36     function swapExactTokensForETHSupportingFeeOnTransferTokens(
37         uint256 amountIn,
38         uint256 amountOutMin,
39         address[] calldata path,
40         address to,
41         uint256 deadline
42     ) external;
43 
44   function swapExactTokensForTokens(
45     uint amountIn,
46     uint amountOutMin,
47     address[] calldata path,
48     address to,
49     uint deadline
50   ) external returns (uint[] memory amounts);
51 
52   function swapExactTokensForETH(
53     uint amountIn,
54     uint amountOutMin,
55     address[] calldata path,
56     address to,
57     uint deadline
58   ) external returns (uint[] memory amounts);
59 
60   function swapExactETHForTokens(
61     uint amountOutMin,
62     address[] calldata path,
63     address to,
64     uint deadline
65   ) external payable returns (uint[] memory amounts);
66 
67   function addLiquidity(
68     address tokenA,
69     address tokenB,
70     uint amountADesired,
71     uint amountBDesired,
72     uint amountAMin,
73     uint amountBMin,
74     address to,
75     uint deadline
76   )
77     external
78     returns (
79       uint amountA,
80       uint amountB,
81       uint liquidity
82     );
83 
84   function removeLiquidity(
85     address tokenA,
86     address tokenB,
87     uint liquidity,
88     uint amountAMin,
89     uint amountBMin,
90     address to,
91     uint deadline
92   ) external returns (uint amountA, uint amountB);  
93 
94     function WETH() external pure returns (address);
95 
96     function factory() external pure returns (address);
97 }
98 
99 interface IUniswapV2Pair {
100   function token0() external view returns (address);
101 
102   function token1() external view returns (address);
103 
104   function getReserves()
105     external
106     view
107     returns (
108       uint112 reserve0,
109       uint112 reserve1,
110       uint32 blockTimestampLast
111     );
112 
113   function swap(
114     uint amount0Out,
115     uint amount1Out,
116     address to,
117     bytes calldata data
118   ) external;
119 }
120 
121 interface IUniswapV2Factory {
122   function getPair(address token0, address token1) external view returns (address);
123   function createPair(address tokenA, address tokenB) external returns (address);
124 }
125 
126 interface Pair {
127   function token0() external view returns (address);
128   function token1() external view returns (address);
129 }
130 // File: interfaces/IAddressContract.sol
131 
132 
133 pragma solidity ^0.8.0;
134 
135 
136 interface IAddressContract {
137 
138     function getDao() external view returns (address);
139     
140     function getTreasury() external view returns (address);
141    
142     function getScarabNFT() external view returns (address);
143     
144     function getScarab() external view returns (address);
145 
146     function getBarac() external view returns (address);
147     
148 }
149 
150 // File: @openzeppelin/contracts/utils/Context.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 abstract contract Context {
168     function _msgSender() internal view virtual returns (address) {
169         return msg.sender;
170     }
171 
172     function _msgData() internal view virtual returns (bytes calldata) {
173         return msg.data;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/access/Ownable.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * By default, the owner account will be the one that deploys the contract. This
191  * can later be changed with {transferOwnership}.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _transferOwnership(_msgSender());
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner.
211      */
212     modifier onlyOwner() {
213         _checkOwner();
214         _;
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view virtual returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if the sender is not the owner.
226      */
227     function _checkOwner() internal view virtual {
228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby disabling any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public virtual onlyOwner {
239         _transferOwnership(address(0));
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Can only be called by the current owner.
245      */
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         require(newOwner != address(0), "Ownable: new owner is the zero address");
248         _transferOwnership(newOwner);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Internal function without access restriction.
254      */
255     function _transferOwnership(address newOwner) internal virtual {
256         address oldOwner = _owner;
257         _owner = newOwner;
258         emit OwnershipTransferred(oldOwner, newOwner);
259     }
260 }
261 
262 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273     /**
274      * @dev Emitted when `value` tokens are moved from one account (`from`) to
275      * another (`to`).
276      *
277      * Note that `value` may be zero.
278      */
279     event Transfer(address indexed from, address indexed to, uint256 value);
280 
281     /**
282      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
283      * a call to {approve}. `value` is the new allowance.
284      */
285     event Approval(address indexed owner, address indexed spender, uint256 value);
286 
287     /**
288      * @dev Returns the amount of tokens in existence.
289      */
290     function totalSupply() external view returns (uint256);
291 
292     /**
293      * @dev Returns the amount of tokens owned by `account`.
294      */
295     function balanceOf(address account) external view returns (uint256);
296 
297     /**
298      * @dev Moves `amount` tokens from the caller's account to `to`.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transfer(address to, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Returns the remaining number of tokens that `spender` will be
308      * allowed to spend on behalf of `owner` through {transferFrom}. This is
309      * zero by default.
310      *
311      * This value changes when {approve} or {transferFrom} are called.
312      */
313     function allowance(address owner, address spender) external view returns (uint256);
314 
315     /**
316      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * IMPORTANT: Beware that changing an allowance with this method brings the risk
321      * that someone may use both the old and the new allowance by unfortunate
322      * transaction ordering. One possible solution to mitigate this race
323      * condition is to first reduce the spender's allowance to 0 and set the
324      * desired value afterwards:
325      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326      *
327      * Emits an {Approval} event.
328      */
329     function approve(address spender, uint256 amount) external returns (bool);
330 
331     /**
332      * @dev Moves `amount` tokens from `from` to `to` using the
333      * allowance mechanism. `amount` is then deducted from the caller's
334      * allowance.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transferFrom(address from, address to, uint256 amount) external returns (bool);
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 
351 /**
352  * @dev Interface for the optional metadata functions from the ERC20 standard.
353  *
354  * _Available since v4.1._
355  */
356 interface IERC20Metadata is IERC20 {
357     /**
358      * @dev Returns the name of the token.
359      */
360     function name() external view returns (string memory);
361 
362     /**
363      * @dev Returns the symbol of the token.
364      */
365     function symbol() external view returns (string memory);
366 
367     /**
368      * @dev Returns the decimals places of the token.
369      */
370     function decimals() external view returns (uint8);
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
374 
375 
376 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 
381 
382 
383 /**
384  * @dev Implementation of the {IERC20} interface.
385  *
386  * This implementation is agnostic to the way tokens are created. This means
387  * that a supply mechanism has to be added in a derived contract using {_mint}.
388  * For a generic mechanism see {ERC20PresetMinterPauser}.
389  *
390  * TIP: For a detailed writeup see our guide
391  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
392  * to implement supply mechanisms].
393  *
394  * The default value of {decimals} is 18. To change this, you should override
395  * this function so it returns a different value.
396  *
397  * We have followed general OpenZeppelin Contracts guidelines: functions revert
398  * instead returning `false` on failure. This behavior is nonetheless
399  * conventional and does not conflict with the expectations of ERC20
400  * applications.
401  *
402  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
403  * This allows applications to reconstruct the allowance for all accounts just
404  * by listening to said events. Other implementations of the EIP may not emit
405  * these events, as it isn't required by the specification.
406  *
407  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
408  * functions have been added to mitigate the well-known issues around setting
409  * allowances. See {IERC20-approve}.
410  */
411 contract ERC20 is Context, IERC20, IERC20Metadata {
412     mapping(address => uint256) private _balances;
413 
414     mapping(address => mapping(address => uint256)) private _allowances;
415 
416     uint256 private _totalSupply;
417 
418     string private _name;
419     string private _symbol;
420 
421     /**
422      * @dev Sets the values for {name} and {symbol}.
423      *
424      * All two of these values are immutable: they can only be set once during
425      * construction.
426      */
427     constructor(string memory name_, string memory symbol_) {
428         _name = name_;
429         _symbol = symbol_;
430     }
431 
432     /**
433      * @dev Returns the name of the token.
434      */
435     function name() public view virtual override returns (string memory) {
436         return _name;
437     }
438 
439     /**
440      * @dev Returns the symbol of the token, usually a shorter version of the
441      * name.
442      */
443     function symbol() public view virtual override returns (string memory) {
444         return _symbol;
445     }
446 
447     /**
448      * @dev Returns the number of decimals used to get its user representation.
449      * For example, if `decimals` equals `2`, a balance of `505` tokens should
450      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
451      *
452      * Tokens usually opt for a value of 18, imitating the relationship between
453      * Ether and Wei. This is the default value returned by this function, unless
454      * it's overridden.
455      *
456      * NOTE: This information is only used for _display_ purposes: it in
457      * no way affects any of the arithmetic of the contract, including
458      * {IERC20-balanceOf} and {IERC20-transfer}.
459      */
460     function decimals() public view virtual override returns (uint8) {
461         return 18;
462     }
463 
464     /**
465      * @dev See {IERC20-totalSupply}.
466      */
467     function totalSupply() public view virtual override returns (uint256) {
468         return _totalSupply;
469     }
470 
471     /**
472      * @dev See {IERC20-balanceOf}.
473      */
474     function balanceOf(address account) public view virtual override returns (uint256) {
475         return _balances[account];
476     }
477 
478     /**
479      * @dev See {IERC20-transfer}.
480      *
481      * Requirements:
482      *
483      * - `to` cannot be the zero address.
484      * - the caller must have a balance of at least `amount`.
485      */
486     function transfer(address to, uint256 amount) public virtual override returns (bool) {
487         address owner = _msgSender();
488         _transfer(owner, to, amount);
489         return true;
490     }
491 
492     /**
493      * @dev See {IERC20-allowance}.
494      */
495     function allowance(address owner, address spender) public view virtual override returns (uint256) {
496         return _allowances[owner][spender];
497     }
498 
499     /**
500      * @dev See {IERC20-approve}.
501      *
502      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
503      * `transferFrom`. This is semantically equivalent to an infinite approval.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      */
509     function approve(address spender, uint256 amount) public virtual override returns (bool) {
510         address owner = _msgSender();
511         _approve(owner, spender, amount);
512         return true;
513     }
514 
515     /**
516      * @dev See {IERC20-transferFrom}.
517      *
518      * Emits an {Approval} event indicating the updated allowance. This is not
519      * required by the EIP. See the note at the beginning of {ERC20}.
520      *
521      * NOTE: Does not update the allowance if the current allowance
522      * is the maximum `uint256`.
523      *
524      * Requirements:
525      *
526      * - `from` and `to` cannot be the zero address.
527      * - `from` must have a balance of at least `amount`.
528      * - the caller must have allowance for ``from``'s tokens of at least
529      * `amount`.
530      */
531     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
532         address spender = _msgSender();
533         _spendAllowance(from, spender, amount);
534         _transfer(from, to, amount);
535         return true;
536     }
537 
538     /**
539      * @dev Atomically increases the allowance granted to `spender` by the caller.
540      *
541      * This is an alternative to {approve} that can be used as a mitigation for
542      * problems described in {IERC20-approve}.
543      *
544      * Emits an {Approval} event indicating the updated allowance.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
551         address owner = _msgSender();
552         _approve(owner, spender, allowance(owner, spender) + addedValue);
553         return true;
554     }
555 
556     /**
557      * @dev Atomically decreases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      * - `spender` must have allowance for the caller of at least
568      * `subtractedValue`.
569      */
570     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
571         address owner = _msgSender();
572         uint256 currentAllowance = allowance(owner, spender);
573         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
574         unchecked {
575             _approve(owner, spender, currentAllowance - subtractedValue);
576         }
577 
578         return true;
579     }
580 
581     /**
582      * @dev Moves `amount` of tokens from `from` to `to`.
583      *
584      * This internal function is equivalent to {transfer}, and can be used to
585      * e.g. implement automatic token fees, slashing mechanisms, etc.
586      *
587      * Emits a {Transfer} event.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `from` must have a balance of at least `amount`.
594      */
595     function _transfer(address from, address to, uint256 amount) internal virtual {
596         require(from != address(0), "ERC20: transfer from the zero address");
597         require(to != address(0), "ERC20: transfer to the zero address");
598 
599         _beforeTokenTransfer(from, to, amount);
600 
601         uint256 fromBalance = _balances[from];
602         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
603         unchecked {
604             _balances[from] = fromBalance - amount;
605             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
606             // decrementing then incrementing.
607             _balances[to] += amount;
608         }
609 
610         emit Transfer(from, to, amount);
611 
612         _afterTokenTransfer(from, to, amount);
613     }
614 
615     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
616      * the total supply.
617      *
618      * Emits a {Transfer} event with `from` set to the zero address.
619      *
620      * Requirements:
621      *
622      * - `account` cannot be the zero address.
623      */
624     function _mint(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: mint to the zero address");
626 
627         _beforeTokenTransfer(address(0), account, amount);
628 
629         _totalSupply += amount;
630         unchecked {
631             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
632             _balances[account] += amount;
633         }
634         emit Transfer(address(0), account, amount);
635 
636         _afterTokenTransfer(address(0), account, amount);
637     }
638 
639     /**
640      * @dev Destroys `amount` tokens from `account`, reducing the
641      * total supply.
642      *
643      * Emits a {Transfer} event with `to` set to the zero address.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      * - `account` must have at least `amount` tokens.
649      */
650     function _burn(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: burn from the zero address");
652 
653         _beforeTokenTransfer(account, address(0), amount);
654 
655         uint256 accountBalance = _balances[account];
656         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
657         unchecked {
658             _balances[account] = accountBalance - amount;
659             // Overflow not possible: amount <= accountBalance <= totalSupply.
660             _totalSupply -= amount;
661         }
662 
663         emit Transfer(account, address(0), amount);
664 
665         _afterTokenTransfer(account, address(0), amount);
666     }
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
670      *
671      * This internal function is equivalent to `approve`, and can be used to
672      * e.g. set automatic allowances for certain subsystems, etc.
673      *
674      * Emits an {Approval} event.
675      *
676      * Requirements:
677      *
678      * - `owner` cannot be the zero address.
679      * - `spender` cannot be the zero address.
680      */
681     function _approve(address owner, address spender, uint256 amount) internal virtual {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     /**
690      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
691      *
692      * Does not update the allowance amount in case of infinite allowance.
693      * Revert if not enough allowance is available.
694      *
695      * Might emit an {Approval} event.
696      */
697     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
698         uint256 currentAllowance = allowance(owner, spender);
699         if (currentAllowance != type(uint256).max) {
700             require(currentAllowance >= amount, "ERC20: insufficient allowance");
701             unchecked {
702                 _approve(owner, spender, currentAllowance - amount);
703             }
704         }
705     }
706 
707     /**
708      * @dev Hook that is called before any transfer of tokens. This includes
709      * minting and burning.
710      *
711      * Calling conditions:
712      *
713      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
714      * will be transferred to `to`.
715      * - when `from` is zero, `amount` tokens will be minted for `to`.
716      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
717      * - `from` and `to` are never both zero.
718      *
719      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
720      */
721     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
722 
723     /**
724      * @dev Hook that is called after any transfer of tokens. This includes
725      * minting and burning.
726      *
727      * Calling conditions:
728      *
729      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
730      * has been transferred to `to`.
731      * - when `from` is zero, `amount` tokens have been minted for `to`.
732      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
733      * - `from` and `to` are never both zero.
734      *
735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
736      */
737     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
738 }
739 
740 // File: ScarabToken.sol
741 
742 
743 pragma solidity 0.8.19;
744 
745 
746 
747 
748 
749 
750 interface IUniswapV2Router01 {
751     function factory() external pure returns (address);
752     function WETH() external pure returns (address);
753     function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
754 } 
755 
756 interface IUniswapV2Router02 is IUniswapV2Router01 {
757     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
758 }
759  
760 // interface IUniswapV2Factory {
761 //      function createPair(address tokenA, address tokenB) external returns (address pair);
762 // }
763 
764 contract SCARAB is ERC20, Ownable {
765     
766     // state vars
767     IUniswapV2Router02 public uniswapV2Router; 
768     
769     bool private swapping;
770     bool public tradeEnabled = false;
771 
772     uint256 public buyTax = 25;
773     uint256 public sellTax = 25;
774     uint256 public treasuryShare = 50;
775 
776     uint public pendingTax;
777     uint public swapThreshhold = 777_777_777 ether;
778     address public treasury = 0xC49e049bAd4Bd71178d7918d86533d53ba33f31C;
779     address public marketingWallet = 0xC49e049bAd4Bd71178d7918d86533d53ba33f31C;
780     address public uniswapV2Pair;
781 
782     mapping (address => bool) public automatedMarketMakerPairs;
783     mapping(address => bool) public isExcludedFromTax;
784     
785     // events
786     event TreasuryAddressUpdated(address newTreasury);
787     event ExcludeAddress(address whitelistAccount, bool value);
788     event TaxUpdated(uint256 buyTax, uint256 sellTax);
789     event RedeemTax(uint scrabToken, uint ethAmount);
790     event TradeEnabled();
791 
792 
793     constructor() ERC20("Scarab DAO", "SCARAB") {
794         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
795         uniswapV2Router = _uniswapV2Router;
796         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
797         uniswapV2Pair = _uniswapV2Pair;
798         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
799         isExcludedFromTax[address(this)] = true;
800         isExcludedFromTax[owner()] = true;
801         isExcludedFromTax[marketingWallet] = true;
802         _mint(msg.sender, 777_777_777_777_777 ether);
803     }
804 
805     receive() external payable {}
806   
807     function updateUniswapV2Router(address newAddress) external onlyOwner {
808         require(newAddress != address(uniswapV2Router), "The router already has that address");
809         uniswapV2Router = IUniswapV2Router02(newAddress);
810         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
811         uniswapV2Pair = _uniswapV2Pair;
812     }
813 
814     function setContractAddresses(IAddressContract _contractFactory) external onlyOwner {
815         address _treasury = _contractFactory.getTreasury();
816         treasury = _treasury;
817         isExcludedFromTax[_treasury] = true;
818         isExcludedFromTax[_contractFactory.getDao()] = true;
819         isExcludedFromTax[_contractFactory.getScarabNFT()] = true;
820         isExcludedFromTax[_contractFactory.getBarac()] = true;
821         emit TreasuryAddressUpdated(_treasury);
822     }
823     
824     function setswapThreshhold(uint256 _newlimit) external onlyOwner {
825         swapThreshhold = _newlimit;
826     }
827 
828     function setTax(uint256 _buyTax, uint _sellTax) external onlyOwner {
829         require(_buyTax <= 25, "_buyTax: too high");
830         require(_sellTax <= 50, "_sellTax: too high");
831         buyTax = _buyTax;
832         sellTax = _sellTax;
833         emit TaxUpdated(_buyTax, _sellTax);
834     }
835 
836     function changeTreasuryShare(uint _newShare) external onlyOwner {
837         require(_newShare <= 100, "share: too high");
838         treasuryShare = _newShare;
839     }
840 
841     function setmarkeitngWallet(address _newWallet) external onlyOwner {
842         require(_newWallet != address(0), "setmarkeitngWallet: invalid");
843         isExcludedFromTax[_newWallet] = true;
844         marketingWallet = _newWallet;
845     }
846 
847     function setTreasury(address _newTreasury) external onlyOwner {
848         require(_newTreasury != address(0), "setTreasury: invalid");
849         isExcludedFromTax[_newTreasury] = true;
850         treasury = _newTreasury;
851         emit TreasuryAddressUpdated(_newTreasury);
852     }
853 
854     function excludeFromTax(address account, bool excluded) external onlyOwner {
855         require(account != address(0), "excludeFromTax: Zero address");
856         isExcludedFromTax[account] = excluded;
857         emit ExcludeAddress(account, excluded);
858     }
859 
860     function excludeMultipleAccountsFromTax(address[] memory accounts, bool excluded) external onlyOwner {
861         for(uint256 i = 0; i < accounts.length; i++) {
862             isExcludedFromTax[accounts[i]] = excluded;
863         }
864     }
865 
866     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
867         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
868         _setAutomatedMarketMakerPair(pair, value);
869     }
870 
871     function redeemTax() external onlyOwner {
872        _redeemTax();
873     }
874 
875     function enableTrading() external onlyOwner {
876         require(!tradeEnabled, "Cannot reenable trading");
877         tradeEnabled = true;
878         emit TradeEnabled();
879     }
880 
881     function burn(uint amount) external {
882         require(msg.sender == treasury, "only treasury can burn");
883         _burn(msg.sender, amount);
884     }
885     
886     function _transfer(
887         address sender,
888         address recipient,
889         uint256 amount
890     ) internal override {  
891         
892         require(sender != address(0), "ERC20: transfer from the zero address");
893         require(recipient != address(0), "ERC20: transfer to the zero address");
894 
895         if(amount == 0) {
896             super._transfer(sender, recipient, 0);
897             return;
898         }
899 
900         if(!isExcludedFromTax[sender] && !isExcludedFromTax[recipient]) {
901             require(tradeEnabled, "Trading is currently disabled");
902         }
903 
904         bool canRedeemTax = swapThreshhold < balanceOf(address(this));
905 
906         if( canRedeemTax &&
907             !swapping &&
908             !automatedMarketMakerPairs[sender] &&
909             sender != owner() &&
910             recipient != owner()
911         ) 
912         {
913             _redeemTax();
914         } 
915 
916         bool takeFee = !swapping;
917         if(isExcludedFromTax[sender] || isExcludedFromTax[recipient]) {
918             takeFee = false;
919         }   
920 
921         uint taxAmount;
922         if (takeFee) {        
923             if (automatedMarketMakerPairs[recipient]) {
924                 taxAmount = amount * sellTax / 100;
925             }
926             else if (automatedMarketMakerPairs[sender]) {
927                 taxAmount = amount * buyTax / 100;
928             }
929         }    
930 
931         if (taxAmount > 0) {
932             pendingTax = pendingTax + taxAmount;
933             amount = amount - taxAmount;
934             super._transfer(sender, address(this), taxAmount);
935         }
936 
937         super._transfer(sender, recipient, amount);
938     }
939 
940     function _redeemTax() internal {
941         require(treasury != address(0) && marketingWallet != address(0), "redeemTax: Address not set");
942         uint _pendingTax = pendingTax;
943         if (_pendingTax > 0) {
944             swapping = true;    
945             swapTokensForEth(_pendingTax);
946             pendingTax = balanceOf(address(this));
947             uint ethAmount = address(this).balance;
948             uint treasuryAmount = (ethAmount * treasuryShare) / 100; 
949             if (treasuryAmount > 0) {
950                 (bool successTreasury, ) = address(treasury).call{ value: treasuryAmount }("");
951                 require(successTreasury, "treasury transfer failed");
952             }
953             uint marketingAmount = ethAmount - treasuryAmount;
954             if (marketingAmount > 0) {
955                 (bool successMarketing, ) = address(marketingWallet).call{ value: marketingAmount }("");
956                 require(successMarketing, "marketing transfer failed");
957             }
958             swapping = false;         
959             emit RedeemTax(_pendingTax, ethAmount);
960         }
961     }
962 
963     function swapTokensForEth(uint256 tokenAmount) private {
964         address[] memory path = new address[](2);
965         path[0] = address(this);
966         path[1] = uniswapV2Router.WETH();
967         _approve(address(this), address(uniswapV2Router), tokenAmount);
968         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
969             tokenAmount,
970             0, 
971             path,
972             address(this),
973             block.timestamp
974         );
975     }
976 
977     function _setAutomatedMarketMakerPair(address pair, bool value) private {
978         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
979         automatedMarketMakerPairs[pair] = value;
980     }
981 }