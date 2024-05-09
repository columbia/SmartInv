1 //            __            __                                                __       
2 //           |  \          |  \                                              |  \      
3 //   ______  | $$  ______  | $$____    ______    ______   __    __   _______ | $$____  
4 //  |      \ | $$ /      \ | $$    \  |      \  /      \ |  \  |  \ /       \| $$    \ 
5 //   \$$$$$$\| $$|  $$$$$$\| $$$$$$$\  \$$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$$| $$$$$$$\
6 //  /      $$| $$| $$  | $$| $$  | $$ /      $$| $$   \$$| $$  | $$ \$$    \ | $$  | $$
7 // |  $$$$$$$| $$| $$__/ $$| $$  | $$|  $$$$$$$| $$      | $$__/ $$ _\$$$$$$\| $$  | $$
8 //  \$$    $$| $$| $$    $$| $$  | $$ \$$    $$| $$       \$$    $$|       $$| $$  | $$
9 //   \$$$$$$$ \$$| $$$$$$$  \$$   \$$  \$$$$$$$ \$$        \$$$$$$  \$$$$$$$  \$$   \$$
10 //               | $$                                                                  
11 //               | $$                                                                  
12 //                \$$                                                                  
13 
14 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
15 
16 // SPDX-License-Identifier: MIT
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 
42 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
43 
44 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 
119 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
120 
121 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) external returns (bool);
187 
188     /**
189      * @dev Emitted when `value` tokens are moved from one account (`from`) to
190      * another (`to`).
191      *
192      * Note that `value` may be zero.
193      */
194     event Transfer(address indexed from, address indexed to, uint256 value);
195 
196     /**
197      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
198      * a call to {approve}. `value` is the new allowance.
199      */
200     event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 
204 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 
233 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2
234 
235 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
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
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view virtual override returns (uint256) {
333         return _balances[account];
334     }
335 
336     /**
337      * @dev See {IERC20-transfer}.
338      *
339      * Requirements:
340      *
341      * - `recipient` cannot be the zero address.
342      * - the caller must have a balance of at least `amount`.
343      */
344     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
345         _transfer(_msgSender(), recipient, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-allowance}.
351      */
352     function allowance(address owner, address spender) public view virtual override returns (uint256) {
353         return _allowances[owner][spender];
354     }
355 
356     /**
357      * @dev See {IERC20-approve}.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         _approve(_msgSender(), spender, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-transferFrom}.
370      *
371      * Emits an {Approval} event indicating the updated allowance. This is not
372      * required by the EIP. See the note at the beginning of {ERC20}.
373      *
374      * Requirements:
375      *
376      * - `sender` and `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      * - the caller must have allowance for ``sender``'s tokens of at least
379      * `amount`.
380      */
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) public virtual override returns (bool) {
386         _transfer(sender, recipient, amount);
387 
388         uint256 currentAllowance = _allowances[sender][_msgSender()];
389         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
390         unchecked {
391             _approve(sender, _msgSender(), currentAllowance - amount);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         uint256 currentAllowance = _allowances[_msgSender()][spender];
430         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
431         unchecked {
432             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
433         }
434 
435         return true;
436     }
437 
438     /**
439      * @dev Moves `amount` of tokens from `sender` to `recipient`.
440      *
441      * This internal function is equivalent to {transfer}, and can be used to
442      * e.g. implement automatic token fees, slashing mechanisms, etc.
443      *
444      * Emits a {Transfer} event.
445      *
446      * Requirements:
447      *
448      * - `sender` cannot be the zero address.
449      * - `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      */
452     function _transfer(
453         address sender,
454         address recipient,
455         uint256 amount
456     ) internal virtual {
457         require(sender != address(0), "ERC20: transfer from the zero address");
458         require(recipient != address(0), "ERC20: transfer to the zero address");
459 
460         _beforeTokenTransfer(sender, recipient, amount);
461 
462         uint256 senderBalance = _balances[sender];
463         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
464         unchecked {
465             _balances[sender] = senderBalance - amount;
466         }
467         _balances[recipient] += amount;
468 
469         emit Transfer(sender, recipient, amount);
470 
471         _afterTokenTransfer(sender, recipient, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         _balances[account] += amount;
490         emit Transfer(address(0), account, amount);
491 
492         _afterTokenTransfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         uint256 accountBalance = _balances[account];
512         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
513         unchecked {
514             _balances[account] = accountBalance - amount;
515         }
516         _totalSupply -= amount;
517 
518         emit Transfer(account, address(0), amount);
519 
520         _afterTokenTransfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Hook that is called before any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * will be transferred to `to`.
556      * - when `from` is zero, `amount` tokens will be minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _beforeTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 
568     /**
569      * @dev Hook that is called after any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * has been transferred to `to`.
576      * - when `from` is zero, `amount` tokens have been minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _afterTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 }
588 
589 
590 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
591 
592 pragma solidity >=0.6.2;
593 
594 interface IUniswapV2Router01 {
595     function factory() external pure returns (address);
596     function WETH() external pure returns (address);
597 
598     function addLiquidity(
599         address tokenA,
600         address tokenB,
601         uint amountADesired,
602         uint amountBDesired,
603         uint amountAMin,
604         uint amountBMin,
605         address to,
606         uint deadline
607     ) external returns (uint amountA, uint amountB, uint liquidity);
608     function addLiquidityETH(
609         address token,
610         uint amountTokenDesired,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline
615     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
616     function removeLiquidity(
617         address tokenA,
618         address tokenB,
619         uint liquidity,
620         uint amountAMin,
621         uint amountBMin,
622         address to,
623         uint deadline
624     ) external returns (uint amountA, uint amountB);
625     function removeLiquidityETH(
626         address token,
627         uint liquidity,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline
632     ) external returns (uint amountToken, uint amountETH);
633     function removeLiquidityWithPermit(
634         address tokenA,
635         address tokenB,
636         uint liquidity,
637         uint amountAMin,
638         uint amountBMin,
639         address to,
640         uint deadline,
641         bool approveMax, uint8 v, bytes32 r, bytes32 s
642     ) external returns (uint amountA, uint amountB);
643     function removeLiquidityETHWithPermit(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline,
650         bool approveMax, uint8 v, bytes32 r, bytes32 s
651     ) external returns (uint amountToken, uint amountETH);
652     function swapExactTokensForTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external returns (uint[] memory amounts);
659     function swapTokensForExactTokens(
660         uint amountOut,
661         uint amountInMax,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external returns (uint[] memory amounts);
666     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
667         external
668         payable
669         returns (uint[] memory amounts);
670     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
671         external
672         returns (uint[] memory amounts);
673     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
674         external
675         returns (uint[] memory amounts);
676     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
677         external
678         payable
679         returns (uint[] memory amounts);
680 
681     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
682     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
683     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
684     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
685     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
686 }
687 
688 
689 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
690 
691 pragma solidity >=0.6.2;
692 
693 interface IUniswapV2Router02 is IUniswapV2Router01 {
694     function removeLiquidityETHSupportingFeeOnTransferTokens(
695         address token,
696         uint liquidity,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountETH);
702     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline,
709         bool approveMax, uint8 v, bytes32 r, bytes32 s
710     ) external returns (uint amountETH);
711 
712     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
713         uint amountIn,
714         uint amountOutMin,
715         address[] calldata path,
716         address to,
717         uint deadline
718     ) external;
719     function swapExactETHForTokensSupportingFeeOnTransferTokens(
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external payable;
725     function swapExactTokensForETHSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external;
732 }
733 
734 
735 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
736 
737 pragma solidity >=0.5.0;
738 
739 interface IUniswapV2Factory {
740     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
741 
742     function feeTo() external view returns (address);
743     function feeToSetter() external view returns (address);
744 
745     function getPair(address tokenA, address tokenB) external view returns (address pair);
746     function allPairs(uint) external view returns (address pair);
747     function allPairsLength() external view returns (uint);
748 
749     function createPair(address tokenA, address tokenB) external returns (address pair);
750 
751     function setFeeTo(address) external;
752     function setFeeToSetter(address) external;
753 }
754 
755 
756 // File contracts/Main.sol
757 
758 pragma solidity ^0.8.18;
759 //import "hardhat/console.sol";
760 /**
761  * @dev Implementation of the {IERC20} interface.
762  *
763  * This implementation is agnostic to the way tokens are created. This means
764  * that a supply mechanism has to be added in a derived contract using {_mint}.
765  * For a generic mechanism see {ERC20PresetMinterPauser}.
766  *
767  * TIP: For a detailed writeup see our guide
768  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
769  * to implement supply mechanisms].
770  *
771  * We have followed general OpenZeppelin Contracts guidelines: functions revert
772  * instead returning `false` on failure. This behavior is nonetheless
773  * conventional and does not conflict with the expectations of ERC20
774  * applications.
775  *
776  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
777  * This allows applications to reconstruct the allowance for all accounts just
778  * by listening to said events. Other implementations of the EIP may not emit
779  * these events, as it isn't required by the specification.
780  *
781  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
782  * functions have been added to mitigate the well-known issues around setting
783  * allowances. See {IERC20-approve}.
784  */
785 
786 
787 contract rushAI is ERC20, Ownable {
788     string private _name = "AlphaRushAI";
789     string private _symbol = "rushAI";
790     bool public _isPublicLaunched = false;
791     uint256 private _supply        = 1_000_000_000 ether;
792     uint256 public maxTxAmount     = 1_000_000_000 ether;
793     uint256 public maxWalletAmount = 1_000_000_000 ether;
794     address public honorariumWallet = 0xD8b70558F410BaC78e4655a09F4325ac262EF56D;
795     address public liquidityWallet = 0x90385Db8166036b5998871458E18FAAfee2240eB;
796     address public DEAD = 0x000000000000000000000000000000000000dEaD;
797     mapping(address => bool) public _isExcludedFromFee;
798     mapping(address => bool) public whitelist;
799     bool swapping = false;
800 
801     // Taxes against bots
802     uint256 public taxForLiquidity = 50;
803     uint256 public taxForHonorarium = 50;
804 
805     function publicLaunch() public onlyOwner {
806         taxForLiquidity = 10;
807         taxForHonorarium = 0;
808         maxTxAmount = 30000000 ether;
809         maxWalletAmount = 30000000 ether;
810         _isPublicLaunched = true;
811     }
812 
813     IUniswapV2Router02 public immutable uniswapV2Router;
814     address public uniswapV2Pair;
815 
816     uint256 public honorariumFunds;
817     uint256 public liquidityEthFunds;
818     uint256 public liquidityTokenFunds;
819 
820     /**
821      * @dev Sets the values for {name} and {symbol}.
822      *
823      * The default value of {decimals} is 18. To select a different value for
824      * {decimals} you should overload it.
825      *
826      * All two of these values are immutable: they can only be set once during
827      * construction.
828      */
829     constructor() ERC20(_name, _symbol) {
830         _mint(msg.sender, (_supply));
831 
832         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
833         uniswapV2Router = _uniswapV2Router;
834         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
835         whitelist[owner()] = true;
836         whitelist[address(this)] = true;
837         _isExcludedFromFee[address(uniswapV2Router)] = true;
838         _isExcludedFromFee[msg.sender] = true;
839         _isExcludedFromFee[honorariumWallet] = true;
840         _isExcludedFromFee[address(this)] = true;
841     }
842 
843     /**
844      * @dev Moves `amount` of tokens from `from` to `to`.
845      *
846      * This internal function is equivalent to {transfer}, and can be used to
847      * e.g. implement automatic token fees, slashing mechanisms, etc.
848      *
849      * Emits a {Transfer} event.
850      *
851      * Requirements:
852      *
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `from` must have a balance of at least `amount`.
857      */
858     function _transfer(
859         address from,
860         address to,
861         uint256 amount
862     ) internal override {
863         require(from != address(0), "ERC20: transfer from the zero address");
864         require(to != address(0), "ERC20: transfer to the zero address");
865 
866         if (!whitelist[from] && !whitelist[to]) {
867             if (to != uniswapV2Pair) {
868                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
869                 require(
870                     (amount + balanceOf(to)) <= maxWalletAmount,
871                     "ERC20: balance amount exceeded max wallet amount limit"
872                 );
873             }
874         }
875 
876         uint256 transferAmount = amount;
877         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
878             if ((from == uniswapV2Pair || to == uniswapV2Pair)) {
879                 require(
880                     _isPublicLaunched,
881                     "Public Trading is not yet available"
882                 );
883                 uint256 totalTax = taxForHonorarium + taxForLiquidity;
884                 if (totalTax > 0) {
885                     uint256 feeTokens = (amount * totalTax) / 100;
886                     super._transfer(from, address(this), feeTokens);
887                     transferAmount = amount - feeTokens;
888                     if (
889                         uniswapV2Pair == to &&
890                         !whitelist[from] &&
891                         !whitelist[to] &&
892                         from != address(this) &&
893                         !swapping
894                     ) {
895                         swapping = true;
896                         swapAndLiquify(totalTax);
897                         swapping = false;
898                     }
899                 }
900             }
901         }
902         super._transfer(from, to, transferAmount);
903     }
904 
905     function swapAndLiquify(uint256 totalTax) internal {
906         if (balanceOf(address(this)) == 0) {
907             return;
908         }
909         uint256 receivedETH;
910         uint256 honorariumTaxAmount;
911         uint256 liquidityTaxAmount;
912         {
913             uint256 contractTokenBalance = balanceOf(address(this));
914             honorariumTaxAmount =
915             (contractTokenBalance * taxForHonorarium) /
916             totalTax;
917             liquidityTaxAmount =
918             (contractTokenBalance * taxForLiquidity) /
919             totalTax;
920             uint256 beforeBalance = address(this).balance;
921             if (liquidityTaxAmount > 0) {
922                 _swapTokensForEth(liquidityTaxAmount / 2, 0);
923                 receivedETH = address(this).balance - beforeBalance;
924                 liquidityEthFunds += receivedETH;
925                 liquidityTokenFunds +=
926                 liquidityTaxAmount -
927                 (liquidityTaxAmount / 2);
928             }
929             if (honorariumTaxAmount > 0) {
930                 beforeBalance = address(this).balance;
931                 _swapTokensForEth(honorariumTaxAmount, 0);
932                 receivedETH = address(this).balance - beforeBalance;
933                 honorariumFunds += receivedETH;
934             }
935         }
936     }
937 
938     /**
939      * @dev Transfers Honorarium ETH Funds to Honorarium Wallet
940      */
941     function withdrawHonorarium() external onlyOwner returns (bool) {
942         payable(honorariumWallet).transfer(honorariumFunds);
943         honorariumFunds = 0;
944         return true;
945     }
946 
947     /**
948      * @dev Transfers Liquidity Funds (ETH + TOKENS) to Liquidity Wallet
949      */
950     function withdrawLiquidity() public onlyOwner returns (bool) {
951         payable(liquidityWallet).transfer(liquidityEthFunds);
952         IERC20(address(this)).transfer(liquidityWallet, liquidityTokenFunds);
953         liquidityEthFunds = 0;
954         liquidityTokenFunds = 0;
955         return true;
956     }
957 
958     /**
959      * @dev Excludes an address from Fees
960      *
961      * @param _address address to be exempt from fee
962      * @param _status address fee status
963      */
964     function excludeFromFee(address _address, bool _status) external onlyOwner {
965         _isExcludedFromFee[_address] = _status;
966     }
967 
968     /**
969      * @dev Excludes batch of addresses from Fees
970      *
971      * @param _address Array of addresses to be exempt from fee
972      * @param _status Addresses fee status
973      */
974     function batchExcludeFromFee(
975         address[] memory _address,
976         bool _status
977     ) external onlyOwner {
978         address[] memory addresses = _address;
979         for (uint i; i < addresses.length; i++) {
980             _isExcludedFromFee[addresses[i]] = _status;
981         }
982     }
983 
984     /**
985      * @dev Adds and address to Whitelist
986      *
987      * @param _address address to be added
988      * @param status address whitelist status
989      */
990     function addToWhitelist(address _address, bool status) external onlyOwner {
991         whitelist[_address] = status;
992     }
993 
994     /**
995      * @dev Adds batch of addresses to Whitelist
996      *
997      * @param _address Array of addresses to be added to whitelist
998      * @param _status Addresses Whitelist status
999      */
1000     function addBatchToWhitelist(
1001         address[] memory _address,
1002         bool _status
1003     ) external onlyOwner {
1004         address[] memory addresses = _address;
1005         for (uint i; i < addresses.length; i++) {
1006             whitelist[addresses[i]] = _status;
1007         }
1008     }
1009 
1010     /**
1011      * @dev Swaps Token Amount to ETH
1012      *
1013      * @param tokenAmount Token Amount to be swapped
1014      * @param tokenAmountOut Expected ETH amount out of swap
1015      */
1016     function _swapTokensForEth(
1017         uint256 tokenAmount,
1018         uint256 tokenAmountOut
1019     ) internal {
1020         address[] memory path = new address[](2);
1021         path[0] = address(this);
1022         path[1] = uniswapV2Router.WETH();
1023 
1024         IERC20(address(this)).approve(
1025             address(uniswapV2Router),
1026             type(uint256).max
1027         );
1028 
1029         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1030             tokenAmount,
1031             tokenAmountOut,
1032             path,
1033             address(this),
1034             block.timestamp
1035         );
1036     }
1037 
1038     /**
1039      * @dev Calculates amount of ETH to be receieved from Swap Transaction
1040      *
1041      * @param _tokenAmount Token Amount to be used for swap
1042      */
1043     function _getETHAmountsOut(
1044         uint256 _tokenAmount
1045     ) internal view returns (uint256) {
1046         address[] memory path = new address[](2);
1047         path[0] = address(this);
1048         path[1] = uniswapV2Router.WETH();
1049 
1050         uint256[] memory amountOut = uniswapV2Router.getAmountsOut(
1051             _tokenAmount,
1052             path
1053         );
1054 
1055         return amountOut[1];
1056     }
1057 
1058     /**
1059      * @dev Updates Token LP pair
1060      *
1061      * @param _pair Token LP Pair address
1062      */
1063     function updatePair(address _pair) external onlyOwner {
1064         require(_pair != DEAD, "LP Pair cannot be the Dead wallet!");
1065         require(_pair != address(0), "LP Pair cannot be 0!");
1066         uniswapV2Pair = _pair;
1067     }
1068 
1069     /**
1070      * @dev Updates Honorarium wallet address
1071      *
1072      * @param _newWallet Honorarium wallet address
1073      */
1074     function updateHonorariumWallet(
1075         address _newWallet
1076     ) public onlyOwner returns (bool) {
1077         require(
1078             _newWallet != DEAD,
1079             "Honorarium Wallet cannot be the Dead wallet!"
1080         );
1081         require(_newWallet != address(0), "Honorarium Wallet cannot be 0!");
1082         honorariumWallet = _newWallet;
1083         return true;
1084     }
1085 
1086     /**
1087      * @dev Updates Liquidity wallet address
1088      *
1089      * @param _newWallet Liquidity wallet address
1090      */
1091     function updateLiquidityWallet(
1092         address _newWallet
1093     ) public onlyOwner returns (bool) {
1094         require(
1095             _newWallet != DEAD,
1096             "Honorarium Wallet cannot be the Dead wallet!"
1097         );
1098         require(_newWallet != address(0), "Honorarium Wallet cannot be 0!");
1099         liquidityWallet = _newWallet;
1100         return true;
1101     }
1102 
1103     /**
1104      * @dev Updates the tax fee for both Early Wallet Status and Honorarium
1105      * @param _taxForLiquidity Early Wallet Tax fee
1106      * @param _taxForHonorarium Honorarium Tax fee
1107      */
1108     function updateTaxForLiquidityAndHonorarium(
1109         uint256 _taxForLiquidity,
1110         uint256 _taxForHonorarium
1111     ) public onlyOwner returns (bool) {
1112         require(
1113             _taxForLiquidity <= 15,
1114             "Liquidity Tax cannot be more than 15%"
1115         );
1116         require(
1117             _taxForHonorarium <= 15,
1118             "Honorarium Tax cannot be more than 15%"
1119         );
1120         taxForLiquidity = _taxForLiquidity;
1121         taxForHonorarium = _taxForHonorarium;
1122 
1123         return true;
1124     }
1125 
1126     /**
1127      * @dev Updates maximum transaction amount for wallet
1128      *
1129      * @param _maxTxAmount Maximum transaction amount
1130      */
1131     function updateMaxTxAmount(
1132         uint256 _maxTxAmount
1133     ) public onlyOwner returns (bool) {
1134         uint256 maxValue = (_supply * 10) / 100;
1135         uint256 minValue = (_supply * 1) / 200;
1136         require(
1137             _maxTxAmount <= maxValue,
1138             "Cannot set maxTxAmount to more than 10% of the supply"
1139         );
1140         require(
1141             _maxTxAmount >= minValue,
1142             "Cannot set maxTxAmount to less than .5% of the supply"
1143         );
1144         maxTxAmount = _maxTxAmount;
1145 
1146         return true;
1147     }
1148 
1149     /**
1150      * @dev Updates Maximum Amount of tokens a wallet can hold
1151      *
1152      * @param _maxWalletAmount Maximum Amount of Tokens a wallet can hold
1153      */
1154     function updateMaxWalletAmount(
1155         uint256 _maxWalletAmount
1156     ) public onlyOwner returns (bool) {
1157         uint256 maxValue = (_supply * 10) / 100;
1158         uint256 minValue = (_supply * 1) / 200;
1159 
1160         require(
1161             _maxWalletAmount <= maxValue,
1162             "Cannot set maxWalletAmount to more than 10% of the supply"
1163         );
1164         require(
1165             _maxWalletAmount >= minValue,
1166             "Cannot set maxWalletAmount to less than .5% of the supply"
1167         );
1168         maxWalletAmount = _maxWalletAmount;
1169 
1170         return true;
1171     }
1172 
1173     function withdrawETH() external onlyOwner {
1174         (bool success,) = address(honorariumWallet).call{value : address(this).balance}("");
1175         require(success);
1176         honorariumFunds = 0;
1177         liquidityEthFunds = 0;
1178     }
1179 
1180     function withdrawTokens(address token) external onlyOwner {
1181         IERC20(token).transfer(
1182             honorariumWallet,
1183             IERC20(token).balanceOf(address(this))
1184         );
1185         if (token == address(this)) {
1186             liquidityTokenFunds = 0;
1187         }
1188     }
1189 
1190     receive() external payable {}
1191 }
1192 
1193 
1194 // File contracts/testFlatten.sol