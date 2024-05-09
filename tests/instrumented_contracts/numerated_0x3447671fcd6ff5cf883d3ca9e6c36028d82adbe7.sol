1 pragma solidity >=0.6.2;
2 
3 interface IUniswapV2Router01 {
4     function factory() external pure returns (address);
5     function WETH() external pure returns (address);
6 
7     function addLiquidity(
8         address tokenA,
9         address tokenB,
10         uint amountADesired,
11         uint amountBDesired,
12         uint amountAMin,
13         uint amountBMin,
14         address to,
15         uint deadline
16     ) external returns (uint amountA, uint amountB, uint liquidity);
17     function addLiquidityETH(
18         address token,
19         uint amountTokenDesired,
20         uint amountTokenMin,
21         uint amountETHMin,
22         address to,
23         uint deadline
24     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
25     function removeLiquidity(
26         address tokenA,
27         address tokenB,
28         uint liquidity,
29         uint amountAMin,
30         uint amountBMin,
31         address to,
32         uint deadline
33     ) external returns (uint amountA, uint amountB);
34     function removeLiquidityETH(
35         address token,
36         uint liquidity,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountToken, uint amountETH);
42     function removeLiquidityWithPermit(
43         address tokenA,
44         address tokenB,
45         uint liquidity,
46         uint amountAMin,
47         uint amountBMin,
48         address to,
49         uint deadline,
50         bool approveMax, uint8 v, bytes32 r, bytes32 s
51     ) external returns (uint amountA, uint amountB);
52     function removeLiquidityETHWithPermit(
53         address token,
54         uint liquidity,
55         uint amountTokenMin,
56         uint amountETHMin,
57         address to,
58         uint deadline,
59         bool approveMax, uint8 v, bytes32 r, bytes32 s
60     ) external returns (uint amountToken, uint amountETH);
61     function swapExactTokensForTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external returns (uint[] memory amounts);
68     function swapTokensForExactTokens(
69         uint amountOut,
70         uint amountInMax,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external returns (uint[] memory amounts);
75     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
76         external
77         payable
78         returns (uint[] memory amounts);
79     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
80         external
81         returns (uint[] memory amounts);
82     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
86         external
87         payable
88         returns (uint[] memory amounts);
89 
90     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
91     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
92     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
93     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
94     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
95 }
96 
97 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
98 
99 pragma solidity >=0.6.2;
100 
101 
102 interface IUniswapV2Router02 is IUniswapV2Router01 {
103     function removeLiquidityETHSupportingFeeOnTransferTokens(
104         address token,
105         uint liquidity,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountETH);
111     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
112         address token,
113         uint liquidity,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline,
118         bool approveMax, uint8 v, bytes32 r, bytes32 s
119     ) external returns (uint amountETH);
120 
121     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128     function swapExactETHForTokensSupportingFeeOnTransferTokens(
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external payable;
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external;
141 }
142 
143 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
144 
145 pragma solidity >=0.5.0;
146 
147 interface IUniswapV2Factory {
148     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
149 
150     function feeTo() external view returns (address);
151     function feeToSetter() external view returns (address);
152 
153     function getPair(address tokenA, address tokenB) external view returns (address pair);
154     function allPairs(uint) external view returns (address pair);
155     function allPairsLength() external view returns (uint);
156 
157     function createPair(address tokenA, address tokenB) external returns (address pair);
158 
159     function setFeeTo(address) external;
160     function setFeeToSetter(address) external;
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Interface of the ERC20 standard as defined in the EIP.
172  */
173 interface IERC20 {
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `to`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(address to, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through {transferFrom}. This is
210      * zero by default.
211      *
212      * This value changes when {approve} or {transferFrom} are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `from` to `to` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(address from, address to, uint256 amount) external returns (bool);
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 
252 /**
253  * @dev Interface for the optional metadata functions from the ERC20 standard.
254  *
255  * _Available since v4.1._
256  */
257 interface IERC20Metadata is IERC20 {
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the symbol of the token.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the decimals places of the token.
270      */
271     function decimals() external view returns (uint8);
272 }
273 
274 // File: @openzeppelin/contracts/utils/Context.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Provides information about the current execution context, including the
283  * sender of the transaction and its data. While these are generally available
284  * via msg.sender and msg.data, they should not be accessed in such a direct
285  * manner, since when dealing with meta-transactions the account sending and
286  * paying for execution may not be the actual sender (as far as an application
287  * is concerned).
288  *
289  * This contract is only required for intermediate, library-like contracts.
290  */
291 abstract contract Context {
292     function _msgSender() internal view virtual returns (address) {
293         return msg.sender;
294     }
295 
296     function _msgData() internal view virtual returns (bytes calldata) {
297         return msg.data;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 
310 
311 /**
312  * @dev Implementation of the {IERC20} interface.
313  *
314  * This implementation is agnostic to the way tokens are created. This means
315  * that a supply mechanism has to be added in a derived contract using {_mint}.
316  * For a generic mechanism see {ERC20PresetMinterPauser}.
317  *
318  * TIP: For a detailed writeup see our guide
319  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
320  * to implement supply mechanisms].
321  *
322  * The default value of {decimals} is 18. To change this, you should override
323  * this function so it returns a different value.
324  *
325  * We have followed general OpenZeppelin Contracts guidelines: functions revert
326  * instead returning `false` on failure. This behavior is nonetheless
327  * conventional and does not conflict with the expectations of ERC20
328  * applications.
329  *
330  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
331  * This allows applications to reconstruct the allowance for all accounts just
332  * by listening to said events. Other implementations of the EIP may not emit
333  * these events, as it isn't required by the specification.
334  *
335  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
336  * functions have been added to mitigate the well-known issues around setting
337  * allowances. See {IERC20-approve}.
338  */
339 contract ERC20 is Context, IERC20, IERC20Metadata {
340     mapping(address => uint256) private _balances;
341 
342     mapping(address => mapping(address => uint256)) private _allowances;
343 
344     uint256 private _totalSupply;
345 
346     string private _name;
347     string private _symbol;
348 
349     /**
350      * @dev Sets the values for {name} and {symbol}.
351      *
352      * All two of these values are immutable: they can only be set once during
353      * construction.
354      */
355     constructor(string memory name_, string memory symbol_) {
356         _name = name_;
357         _symbol = symbol_;
358     }
359 
360     /**
361      * @dev Returns the name of the token.
362      */
363     function name() public view virtual override returns (string memory) {
364         return _name;
365     }
366 
367     /**
368      * @dev Returns the symbol of the token, usually a shorter version of the
369      * name.
370      */
371     function symbol() public view virtual override returns (string memory) {
372         return _symbol;
373     }
374 
375     /**
376      * @dev Returns the number of decimals used to get its user representation.
377      * For example, if `decimals` equals `2`, a balance of `505` tokens should
378      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
379      *
380      * Tokens usually opt for a value of 18, imitating the relationship between
381      * Ether and Wei. This is the default value returned by this function, unless
382      * it's overridden.
383      *
384      * NOTE: This information is only used for _display_ purposes: it in
385      * no way affects any of the arithmetic of the contract, including
386      * {IERC20-balanceOf} and {IERC20-transfer}.
387      */
388     function decimals() public view virtual override returns (uint8) {
389         return 18;
390     }
391 
392     /**
393      * @dev See {IERC20-totalSupply}.
394      */
395     function totalSupply() public view virtual override returns (uint256) {
396         return _totalSupply;
397     }
398 
399     /**
400      * @dev See {IERC20-balanceOf}.
401      */
402     function balanceOf(address account) public view virtual override returns (uint256) {
403         return _balances[account];
404     }
405 
406     /**
407      * @dev See {IERC20-transfer}.
408      *
409      * Requirements:
410      *
411      * - `to` cannot be the zero address.
412      * - the caller must have a balance of at least `amount`.
413      */
414     function transfer(address to, uint256 amount) public virtual override returns (bool) {
415         address owner = _msgSender();
416         _transfer(owner, to, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-allowance}.
422      */
423     function allowance(address owner, address spender) public view virtual override returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     /**
428      * @dev See {IERC20-approve}.
429      *
430      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
431      * `transferFrom`. This is semantically equivalent to an infinite approval.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function approve(address spender, uint256 amount) public virtual override returns (bool) {
438         address owner = _msgSender();
439         _approve(owner, spender, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-transferFrom}.
445      *
446      * Emits an {Approval} event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of {ERC20}.
448      *
449      * NOTE: Does not update the allowance if the current allowance
450      * is the maximum `uint256`.
451      *
452      * Requirements:
453      *
454      * - `from` and `to` cannot be the zero address.
455      * - `from` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``from``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
460         address spender = _msgSender();
461         _spendAllowance(from, spender, amount);
462         _transfer(from, to, amount);
463         return true;
464     }
465 
466     /**
467      * @dev Atomically increases the allowance granted to `spender` by the caller.
468      *
469      * This is an alternative to {approve} that can be used as a mitigation for
470      * problems described in {IERC20-approve}.
471      *
472      * Emits an {Approval} event indicating the updated allowance.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      */
478     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
479         address owner = _msgSender();
480         _approve(owner, spender, allowance(owner, spender) + addedValue);
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
499         address owner = _msgSender();
500         uint256 currentAllowance = allowance(owner, spender);
501         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
502         unchecked {
503             _approve(owner, spender, currentAllowance - subtractedValue);
504         }
505 
506         return true;
507     }
508 
509     /**
510      * @dev Moves `amount` of tokens from `from` to `to`.
511      *
512      * This internal function is equivalent to {transfer}, and can be used to
513      * e.g. implement automatic token fees, slashing mechanisms, etc.
514      *
515      * Emits a {Transfer} event.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `from` must have a balance of at least `amount`.
522      */
523     function _transfer(address from, address to, uint256 amount) internal virtual {
524         require(from != address(0), "ERC20: transfer from the zero address");
525         require(to != address(0), "ERC20: transfer to the zero address");
526 
527         _beforeTokenTransfer(from, to, amount);
528 
529         uint256 fromBalance = _balances[from];
530         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
531         unchecked {
532             _balances[from] = fromBalance - amount;
533             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
534             // decrementing then incrementing.
535             _balances[to] += amount;
536         }
537 
538         emit Transfer(from, to, amount);
539 
540         _afterTokenTransfer(from, to, amount);
541     }
542 
543     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
544      * the total supply.
545      *
546      * Emits a {Transfer} event with `from` set to the zero address.
547      *
548      * Requirements:
549      *
550      * - `account` cannot be the zero address.
551      */
552     function _mint(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: mint to the zero address");
554 
555         _beforeTokenTransfer(address(0), account, amount);
556 
557         _totalSupply += amount;
558         unchecked {
559             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
560             _balances[account] += amount;
561         }
562         emit Transfer(address(0), account, amount);
563 
564         _afterTokenTransfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _beforeTokenTransfer(account, address(0), amount);
582 
583         uint256 accountBalance = _balances[account];
584         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
585         unchecked {
586             _balances[account] = accountBalance - amount;
587             // Overflow not possible: amount <= accountBalance <= totalSupply.
588             _totalSupply -= amount;
589         }
590 
591         emit Transfer(account, address(0), amount);
592 
593         _afterTokenTransfer(account, address(0), amount);
594     }
595 
596     /**
597      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
598      *
599      * This internal function is equivalent to `approve`, and can be used to
600      * e.g. set automatic allowances for certain subsystems, etc.
601      *
602      * Emits an {Approval} event.
603      *
604      * Requirements:
605      *
606      * - `owner` cannot be the zero address.
607      * - `spender` cannot be the zero address.
608      */
609     function _approve(address owner, address spender, uint256 amount) internal virtual {
610         require(owner != address(0), "ERC20: approve from the zero address");
611         require(spender != address(0), "ERC20: approve to the zero address");
612 
613         _allowances[owner][spender] = amount;
614         emit Approval(owner, spender, amount);
615     }
616 
617     /**
618      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
619      *
620      * Does not update the allowance amount in case of infinite allowance.
621      * Revert if not enough allowance is available.
622      *
623      * Might emit an {Approval} event.
624      */
625     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
626         uint256 currentAllowance = allowance(owner, spender);
627         if (currentAllowance != type(uint256).max) {
628             require(currentAllowance >= amount, "ERC20: insufficient allowance");
629             unchecked {
630                 _approve(owner, spender, currentAllowance - amount);
631             }
632         }
633     }
634 
635     /**
636      * @dev Hook that is called before any transfer of tokens. This includes
637      * minting and burning.
638      *
639      * Calling conditions:
640      *
641      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
642      * will be transferred to `to`.
643      * - when `from` is zero, `amount` tokens will be minted for `to`.
644      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
645      * - `from` and `to` are never both zero.
646      *
647      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
648      */
649     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
650 
651     /**
652      * @dev Hook that is called after any transfer of tokens. This includes
653      * minting and burning.
654      *
655      * Calling conditions:
656      *
657      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
658      * has been transferred to `to`.
659      * - when `from` is zero, `amount` tokens have been minted for `to`.
660      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
661      * - `from` and `to` are never both zero.
662      *
663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
664      */
665     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
666 }
667 
668 // File: @openzeppelin/contracts/access/Ownable.sol
669 
670 
671 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @dev Contract module which provides a basic access control mechanism, where
678  * there is an account (an owner) that can be granted exclusive access to
679  * specific functions.
680  *
681  * By default, the owner account will be the one that deploys the contract. This
682  * can later be changed with {transferOwnership}.
683  *
684  * This module is used through inheritance. It will make available the modifier
685  * `onlyOwner`, which can be applied to your functions to restrict their use to
686  * the owner.
687  */
688 abstract contract Ownable is Context {
689     address private _owner;
690 
691     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
692 
693     /**
694      * @dev Initializes the contract setting the deployer as the initial owner.
695      */
696     constructor() {
697         _transferOwnership(_msgSender());
698     }
699 
700     /**
701      * @dev Throws if called by any account other than the owner.
702      */
703     modifier onlyOwner() {
704         _checkOwner();
705         _;
706     }
707 
708     /**
709      * @dev Returns the address of the current owner.
710      */
711     function owner() public view virtual returns (address) {
712         return _owner;
713     }
714 
715     /**
716      * @dev Throws if the sender is not the owner.
717      */
718     function _checkOwner() internal view virtual {
719         require(owner() == _msgSender(), "Ownable: caller is not the owner");
720     }
721 
722     /**
723      * @dev Leaves the contract without owner. It will not be possible to call
724      * `onlyOwner` functions. Can only be called by the current owner.
725      *
726      * NOTE: Renouncing ownership will leave the contract without an owner,
727      * thereby disabling any functionality that is only available to the owner.
728      */
729     function renounceOwnership() public virtual onlyOwner {
730         _transferOwnership(address(0));
731     }
732 
733     /**
734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
735      * Can only be called by the current owner.
736      */
737     function transferOwnership(address newOwner) public virtual onlyOwner {
738         require(newOwner != address(0), "Ownable: new owner is the zero address");
739         _transferOwnership(newOwner);
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Internal function without access restriction.
745      */
746     function _transferOwnership(address newOwner) internal virtual {
747         address oldOwner = _owner;
748         _owner = newOwner;
749         emit OwnershipTransferred(oldOwner, newOwner);
750     }
751 }
752 
753 // File: template.sol
754 
755 //SPDX-License-Identifier: MIT
756 
757 pragma solidity =0.8.9;
758 
759 contract MILK is ERC20, Ownable {
760 
761     uint256 constant DECIMAL_POINTS = 10000;
762 
763     uint256 public developmentTax;
764     address public development;
765     uint256 public maxPerWallet;
766     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //uniswap router address
767     uint256 public slippage = 200;
768 
769     uint256 private _feesOnContract;
770 
771     mapping(address => bool) public blacklist;
772     mapping(address => bool) public whitelist;
773 
774     error Blacklisted();
775     error InvalidAddress();
776     error TransferLimitExceeded();
777 
778     event RouterUpdated(address router);
779     event developmentUpdated(address development);
780     event developmentTaxUpdated(uint256 developmentTax);
781     event SlippageUpdated(uint256 slippage);
782     event MaxPerWalletUpdated(uint256 maxPerWallet);
783 
784     constructor(
785         uint256 _developmentTax,
786         address _development,
787         uint256 _maxPerWallet
788     ) ERC20("Milk Supremacy", "MILK") {
789         if (_development == address(0)) revert InvalidAddress();
790 
791         _mint(msg.sender, 1_000_000_000_000 ether);
792 
793         developmentTax = _developmentTax;
794         development = _development;
795         maxPerWallet = _maxPerWallet;
796     }
797 
798     function _transfer(
799         address _from,
800         address _to,
801         uint256 _amount
802     ) internal virtual override {
803         if (blacklist[_from] || blacklist[_to]) revert Blacklisted();
804 
805         address _pair = _getPair(address(this), _getWETH());
806 
807         if (
808             _to != _pair &&
809             _to != address(this) &&
810             _to != owner() &&
811             !whitelist[_to]
812         ) {
813             _checkValidTransfer(_to, _amount);
814         }
815 
816         if (
817             (_pair == _to &&
818                 _from != address(this) &&
819                 _from != owner() &&
820                 !whitelist[_from]) ||
821             (_pair == _from &&
822                 _to != address(this) &&
823                 _to != owner() &&
824                 !whitelist[_to])
825         ) {
826             uint256 _feeAmount = (_amount * developmentTax) / DECIMAL_POINTS;
827 
828             super._transfer(_from, address(this), _feeAmount);
829 
830             _feesOnContract += _feeAmount;
831 
832             if (_from != _pair) {
833                 _swap(
834                     _feesOnContract,
835                     _getPath(address(this), _getWETH()),
836                     development
837                 );
838 
839                 _feesOnContract = 0;
840             } else {
841                 _checkValidTransfer(_to, _amount);
842             }
843 
844             return super._transfer(_from, _to, _amount - _feeAmount);
845         } else return super._transfer(_from, _to, _amount);
846     }
847 
848     function _checkValidTransfer(address _to, uint256 _amount) private view {
849         uint256 _validTokenTransfer = ((totalSupply() * maxPerWallet) /
850             DECIMAL_POINTS) - balanceOf(_to);
851         if (_amount > _validTokenTransfer) revert TransferLimitExceeded();
852     }
853 
854     function _getFactory() private view returns (address) {
855         return IUniswapV2Router02(router).factory();
856     }
857 
858     function _getWETH() private view returns (address) {
859         return IUniswapV2Router02(router).WETH();
860     }
861 
862     function _getPair(address _tokenA, address _tokenB)
863         private
864         view
865         returns (address)
866     {
867         return IUniswapV2Factory(_getFactory()).getPair(_tokenA, _tokenB);
868     }
869 
870     function _getPath(address _tokenA, address _tokenB)
871         private
872         view
873         returns (address[] memory)
874     {
875         address[] memory path;
876         address WETH = _getWETH();
877 
878         if (_tokenA == WETH || _tokenB == WETH) {
879             path = new address[](2);
880             path[0] = _tokenA;
881             path[1] = _tokenB;
882         } else {
883             path = new address[](3);
884             path[0] = _tokenA;
885             path[1] = WETH;
886             path[2] = _tokenB;
887         }
888 
889         return path;
890     }
891 
892     function _swap(
893         uint256 _amountIn,
894         address[] memory _path,
895         address _to
896     ) private {
897         if (_amountIn > 0) {
898             IERC20(_path[0]).approve(router, _amountIn);
899 
900             uint256 _amountOutMin = (IUniswapV2Router02(router).getAmountsOut(
901                 _amountIn,
902                 _path
903             )[_path.length - 1] * (DECIMAL_POINTS - slippage)) / DECIMAL_POINTS;
904 
905             IUniswapV2Router02(router)
906                 .swapExactTokensForTokensSupportingFeeOnTransferTokens(
907                     _amountIn,
908                     _amountOutMin,
909                     _path,
910                     _to,
911                     block.timestamp
912                 );
913         }
914     }
915 
916     function updateRouter(address _router) external onlyOwner {
917         if (_router == address(0)) revert InvalidAddress();
918         router = _router;
919 
920         emit RouterUpdated(_router);
921     }
922 
923     function updatedevelopment(address _development) external onlyOwner {
924         if (_development == address(0)) revert InvalidAddress();
925         development = _development;
926 
927         emit developmentUpdated(_development);
928     }
929 
930     function updatedevelopmentTax(uint256 _developmentTax) external onlyOwner {
931         developmentTax = _developmentTax;
932 
933         emit developmentTaxUpdated(_developmentTax);
934     }
935 
936     function updateMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
937         maxPerWallet = _maxPerWallet;
938 
939         emit MaxPerWalletUpdated(_maxPerWallet);
940     }
941 
942     function updateSlippage(uint256 _slippage) external onlyOwner {
943         slippage = _slippage;
944 
945         emit SlippageUpdated(_slippage);
946     }
947 
948     function addBlacklist(address _account) external onlyOwner {
949         require(!blacklist[_account]);
950         blacklist[_account] = true;
951     }
952 
953     function removeBlacklist(address _account) external onlyOwner {
954         require(blacklist[_account]);
955         blacklist[_account] = false;
956     }
957 
958     function addWhitelist(address _account) external onlyOwner {
959         require(!whitelist[_account]);
960         whitelist[_account] = true;
961     }
962 
963     function removeWhitelist(address _account) external onlyOwner {
964         require(whitelist[_account]);
965         whitelist[_account] = false;
966     }
967 }