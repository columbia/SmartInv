1 //   _   _   U _____ u U  ___ u   ____     U  ___ u _____   
2 //  | \ |"|  \| ___"|/  \/"_ \/U | __")u    \/"_ \/|_ " _|  
3 // <|  \| |>  |  _|"    | | | | \|  _ \/    | | | |  | |    
4 // U| |\  |u  | |___.-,_| |_| |  | |_) |.-,_| |_| | /| |\   
5 //  |_| \_|   |_____|\_)-\___/   |____/  \_)-\___/ u |_|U   
6 //  ||   \\,-.<<   >>     \\    _|| \\_       \\   _// \\_  
7 //  (_")  (_/(__) (__)   (__)  (__) (__)     (__) (__) (__) 
8 
9 // TG: https://t.me/NeoBot_Portal
10 // Twitter:  https://twitter.com/neobot_erc
11 
12 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
13 
14 // SPDX-License-Identifier: MIT
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
41 
42 // 
43 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
119 
120 // 
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
206 // 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 
234 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2
235 
236 // 
237 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * The default value of {decimals} is 18. To select a different value for
282      * {decimals} you should overload it.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the value {ERC20} uses, unless this function is
314      * overridden;
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 18;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view virtual override returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `recipient` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view virtual override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public virtual override returns (bool) {
366         _approve(_msgSender(), spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * Requirements:
377      *
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``sender``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) public virtual override returns (bool) {
388         _transfer(sender, recipient, amount);
389 
390         uint256 currentAllowance = _allowances[sender][_msgSender()];
391         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
392         unchecked {
393             _approve(sender, _msgSender(), currentAllowance - amount);
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         uint256 currentAllowance = _allowances[_msgSender()][spender];
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `sender` to `recipient`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `sender` cannot be the zero address.
451      * - `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         uint256 senderBalance = _balances[sender];
465         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[sender] = senderBalance - amount;
468         }
469         _balances[recipient] += amount;
470 
471         emit Transfer(sender, recipient, amount);
472 
473         _afterTokenTransfer(sender, recipient, amount);
474     }
475 
476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
477      * the total supply.
478      *
479      * Emits a {Transfer} event with `from` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      */
485     function _mint(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: mint to the zero address");
487 
488         _beforeTokenTransfer(address(0), account, amount);
489 
490         _totalSupply += amount;
491         _balances[account] += amount;
492         emit Transfer(address(0), account, amount);
493 
494         _afterTokenTransfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         uint256 accountBalance = _balances[account];
514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
515         unchecked {
516             _balances[account] = accountBalance - amount;
517         }
518         _totalSupply -= amount;
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
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
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 
570     /**
571      * @dev Hook that is called after any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * has been transferred to `to`.
578      * - when `from` is zero, `amount` tokens have been minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _afterTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 }
590 
591 
592 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
593 
594 pragma solidity >=0.6.2;
595 
596 interface IUniswapV2Router01 {
597     function factory() external pure returns (address);
598     function WETH() external pure returns (address);
599 
600     function addLiquidity(
601         address tokenA,
602         address tokenB,
603         uint amountADesired,
604         uint amountBDesired,
605         uint amountAMin,
606         uint amountBMin,
607         address to,
608         uint deadline
609     ) external returns (uint amountA, uint amountB, uint liquidity);
610     function addLiquidityETH(
611         address token,
612         uint amountTokenDesired,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline
617     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
618     function removeLiquidity(
619         address tokenA,
620         address tokenB,
621         uint liquidity,
622         uint amountAMin,
623         uint amountBMin,
624         address to,
625         uint deadline
626     ) external returns (uint amountA, uint amountB);
627     function removeLiquidityETH(
628         address token,
629         uint liquidity,
630         uint amountTokenMin,
631         uint amountETHMin,
632         address to,
633         uint deadline
634     ) external returns (uint amountToken, uint amountETH);
635     function removeLiquidityWithPermit(
636         address tokenA,
637         address tokenB,
638         uint liquidity,
639         uint amountAMin,
640         uint amountBMin,
641         address to,
642         uint deadline,
643         bool approveMax, uint8 v, bytes32 r, bytes32 s
644     ) external returns (uint amountA, uint amountB);
645     function removeLiquidityETHWithPermit(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline,
652         bool approveMax, uint8 v, bytes32 r, bytes32 s
653     ) external returns (uint amountToken, uint amountETH);
654     function swapExactTokensForTokens(
655         uint amountIn,
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external returns (uint[] memory amounts);
661     function swapTokensForExactTokens(
662         uint amountOut,
663         uint amountInMax,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external returns (uint[] memory amounts);
668     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
669         external
670         payable
671         returns (uint[] memory amounts);
672     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
673         external
674         returns (uint[] memory amounts);
675     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
676         external
677         returns (uint[] memory amounts);
678     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
679         external
680         payable
681         returns (uint[] memory amounts);
682 
683     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
684     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
685     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
686     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
687     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
688 }
689 
690 
691 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
692 
693 pragma solidity >=0.6.2;
694 
695 interface IUniswapV2Router02 is IUniswapV2Router01 {
696     function removeLiquidityETHSupportingFeeOnTransferTokens(
697         address token,
698         uint liquidity,
699         uint amountTokenMin,
700         uint amountETHMin,
701         address to,
702         uint deadline
703     ) external returns (uint amountETH);
704     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
705         address token,
706         uint liquidity,
707         uint amountTokenMin,
708         uint amountETHMin,
709         address to,
710         uint deadline,
711         bool approveMax, uint8 v, bytes32 r, bytes32 s
712     ) external returns (uint amountETH);
713 
714     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
715         uint amountIn,
716         uint amountOutMin,
717         address[] calldata path,
718         address to,
719         uint deadline
720     ) external;
721     function swapExactETHForTokensSupportingFeeOnTransferTokens(
722         uint amountOutMin,
723         address[] calldata path,
724         address to,
725         uint deadline
726     ) external payable;
727     function swapExactTokensForETHSupportingFeeOnTransferTokens(
728         uint amountIn,
729         uint amountOutMin,
730         address[] calldata path,
731         address to,
732         uint deadline
733     ) external;
734 }
735 
736 
737 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
738 
739 pragma solidity >=0.5.0;
740 
741 interface IUniswapV2Factory {
742     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
743 
744     function feeTo() external view returns (address);
745     function feeToSetter() external view returns (address);
746 
747     function getPair(address tokenA, address tokenB) external view returns (address pair);
748     function allPairs(uint) external view returns (address pair);
749     function allPairsLength() external view returns (uint);
750 
751     function createPair(address tokenA, address tokenB) external returns (address pair);
752 
753     function setFeeTo(address) external;
754     function setFeeToSetter(address) external;
755 }
756 
757 
758 // File contracts/NeoBot.sol
759 
760 pragma solidity ^0.8.18;
761 
762 
763 //   _   _   U _____ u U  ___ u   ____     U  ___ u _____   
764 //  | \ |"|  \| ___"|/  \/"_ \/U | __")u    \/"_ \/|_ " _|  
765 // <|  \| |>  |  _|"    | | | | \|  _ \/    | | | |  | |    
766 // U| |\  |u  | |___.-,_| |_| |  | |_) |.-,_| |_| | /| |\   
767 //  |_| \_|   |_____|\_)-\___/   |____/  \_)-\___/ u |_|U   
768 //  ||   \\,-.<<   >>     \\    _|| \\_       \\   _// \\_  
769 //  (_")  (_/(__) (__)   (__)  (__) (__)     (__) (__) (__) 
770 
771 // TG:  neobot.live
772 // Twitter:  neobot.live
773 contract NeoBot is ERC20, Ownable {
774     string private _name = "NeoBot";
775     string private _symbol = "NEOBOT";
776     bool public _isPublicLaunched = false;
777     uint256 private _supply        = 10_000_000 ether;
778     uint256 public maxTxAmount     = 200_000 ether;
779     uint256 public maxWalletAmount = 200_000 ether;
780     address public operationsWallet = 0x6833cF33C18c43DA13b5F561177Db2e1350B8eD5;
781     address public DEAD = 0x000000000000000000000000000000000000dEaD;
782 
783     mapping(address => bool) public _hasFee;
784     mapping(address => bool) public wladdress;
785 
786     mapping(address => bool) public step1wallets;
787 
788     enum Phase {Phase1, Phase2, Phase3, Phase4}
789     Phase public currentphase;
790 
791     bool progress_swap = false;
792 
793     uint256 public operationsTaxBuy = 10;
794     uint256 public operationsTaxSell = 40;
795     uint256 private step1tax = 40;
796 
797     IUniswapV2Router02 public immutable uniswapV2Router;
798     address public uniswapV2Pair;
799 
800     uint256 public operationsFunds;
801 
802     
803     modifier onlyOwnerOrOperations() {
804         require(owner() == _msgSender() || operationsWallet == _msgSender(), "Caller is not the owner or the specific wallet");
805         _;
806     }
807 
808     constructor() ERC20(_name, _symbol) {
809         _mint(msg.sender, (_supply));
810 
811         currentphase = Phase.Phase1;
812         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
813         uniswapV2Router = _uniswapV2Router;
814         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
815     
816         wladdress[owner()] = true;
817         wladdress[operationsWallet] = true;
818         wladdress[address(this)] = true;
819         wladdress[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
820         _hasFee[address(uniswapV2Router)] = true;
821         _hasFee[msg.sender] = true;
822         _hasFee[operationsWallet] = true;
823         _hasFee[address(this)] = true;
824     }
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal override {
831 
832         require(from != address(0), "ERC20: transfer from the zero address");
833         require(to != address(0), "ERC20: transfer to the zero address");
834 
835         if (!wladdress[from] && !wladdress[to] ) {
836             if (to != uniswapV2Pair) {
837                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount bef");
838                 require(
839                     (amount + balanceOf(to)) <= maxWalletAmount,
840                     "ERC20: balance amount exceeded max wallet amount limit"
841                 );
842             }
843         }
844 
845         uint256 transferAmount = amount;
846         if (!_hasFee[from] && !_hasFee[to]) {
847             if ((from == uniswapV2Pair || to == uniswapV2Pair)) {
848                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
849  
850                 // Buy 
851                 if (
852                     operationsTaxBuy > 0 && 
853                     uniswapV2Pair == from &&
854                     !wladdress[to] &&
855                     from != address(this)
856                 ) {
857 
858                     if (currentphase == Phase.Phase1) {
859                         step1wallets[to] = true;
860                     }
861 
862                     uint256 feeTokens = (amount * operationsTaxBuy) / 100;
863                     super._transfer(from, address(this), feeTokens);
864                     transferAmount = amount - feeTokens;
865                 }
866 
867                 // Sell
868                 if (
869                     uniswapV2Pair == to &&
870                     !wladdress[from] &&
871                     to != address(this) &&
872                     !progress_swap
873                 ) {
874                     
875                     uint256 taxSell = operationsTaxSell;
876                     if (step1wallets[from] == true) {
877                         taxSell = step1tax;
878                     }
879 
880                     progress_swap = true;
881                     swapAndLiquify();
882                     progress_swap = false;
883 
884                     uint256 feeTokens = (amount * taxSell) / 100;
885                     super._transfer(from, address(this), feeTokens);
886                     transferAmount = amount - feeTokens;
887                 }
888             }
889             else {
890                 // Transfer out for step1 wallets
891                 if (
892                     step1wallets[from] == true &&
893                     uniswapV2Pair != to
894                 ) {
895                     uint256 feeTokens = (amount * step1tax) / 100;
896                     super._transfer(from, address(this), feeTokens);
897                     transferAmount = amount - feeTokens;
898                 }
899             }
900         }
901         super._transfer(from, to, transferAmount);
902     }
903 
904     function swapAndLiquify() internal {
905         if (balanceOf(address(this)) == 0) {
906             return;
907         }
908         uint256 receivedETH;
909         {
910             uint256 contractTokenBalance = balanceOf(address(this));
911             uint256 beforeBalance = address(this).balance;
912 
913             if (contractTokenBalance > 0) {
914                 beforeBalance = address(this).balance;
915                 _swapTokensForEth(contractTokenBalance, 0);
916                 receivedETH = address(this).balance - beforeBalance;
917                 operationsFunds += receivedETH;
918             }
919         }
920     }
921  
922     function withdrawOperations() external onlyOwnerOrOperations returns (bool) {
923         payable(operationsWallet).transfer(operationsFunds);
924         operationsFunds = 0;
925         return true;
926     }
927 
928     /**
929      * @dev Swaps Token Amount to ETH
930      *
931      * @param tokenAmount Token Amount to be swapped
932      * @param tokenAmountOut Expected ETH amount out of swap
933      */
934     function _swapTokensForEth(
935         uint256 tokenAmount,
936         uint256 tokenAmountOut
937     ) internal {
938         address[] memory path = new address[](2);
939         path[0] = address(this);
940         path[1] = uniswapV2Router.WETH();
941 
942         IERC20(address(this)).approve(
943             address(uniswapV2Router),
944             type(uint256).max
945         );
946 
947         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
948             tokenAmount,
949             tokenAmountOut,
950             path,
951             address(this),
952             block.timestamp
953         );
954     }
955 
956      function setPhaseTwo() external onlyOwner returns (bool) {
957         currentphase = Phase.Phase2;
958         operationsTaxBuy = 20;
959         operationsTaxSell = 20;
960 
961         return true;
962     }
963       function setPhaseThree() external onlyOwner returns (bool) {
964         currentphase = Phase.Phase3;
965         operationsTaxBuy = 7;
966         operationsTaxSell = 7;
967 
968         return true;
969     }
970       function setPhaseFour() external onlyOwner returns (bool) {
971         currentphase = Phase.Phase4;
972         operationsTaxBuy = 5;
973         operationsTaxSell = 5;
974 
975         return true;
976     }
977 
978     function _getETHAmountsOut(
979         uint256 _tokenAmount
980     ) internal view returns (uint256) {
981         address[] memory path = new address[](2);
982         path[0] = address(this);
983         path[1] = uniswapV2Router.WETH();
984 
985         uint256[] memory amountOut = uniswapV2Router.getAmountsOut(
986             _tokenAmount,
987             path
988         );
989 
990         return amountOut[1];
991     }
992 
993     function updatePair(address _pair) external onlyOwnerOrOperations {
994         require(_pair != DEAD, "LP Pair cannot be the Dead wallet!");
995         require(_pair != address(0), "LP Pair cannot be 0!");
996         uniswapV2Pair = _pair;
997     }
998 
999     function updateoperationsWallet(
1000         address _newWallet
1001     ) public onlyOwnerOrOperations returns (bool) {
1002         require(
1003             _newWallet != DEAD,
1004             "Operations Wallet cannot be the Dead wallet!"
1005         );
1006         require(_newWallet != address(0), "Operations Wallet cannot be 0!");
1007         operationsWallet = _newWallet;
1008         wladdress[operationsWallet] = true;
1009         _hasFee[operationsWallet] = true;
1010 
1011         return true;
1012     }
1013 
1014     function updateTaxForOperations(
1015         uint256 _operationsTaxBuy,
1016         uint256 _operationsTaxSell
1017     ) public onlyOwner returns (bool) {
1018         require(
1019             _operationsTaxBuy <= 40,
1020             "Operations Tax cannot be more than 40%"
1021         );
1022         require(
1023             _operationsTaxSell <= 40,
1024             "Operations Tax cannot be more than 40%"
1025         );
1026         operationsTaxBuy = _operationsTaxBuy;
1027         operationsTaxSell = _operationsTaxSell;
1028         return true;
1029     }
1030 
1031 
1032     function maxTxAmountChange(
1033         uint256 _maxTxAmount
1034     ) public onlyOwner returns (bool) {
1035         uint256 maxValue = (_supply * 10) / 100;
1036         uint256 minValue = (_supply * 1) / 200;
1037         require(
1038             _maxTxAmount <= maxValue,
1039             "Cannot set maxTxAmountChange to more than 10% of the supply"
1040         );
1041         require(
1042             _maxTxAmount >= minValue,
1043             "Cannot set maxTxAmountChange to less than .5% of the supply"
1044         );
1045         maxTxAmount = _maxTxAmount;
1046 
1047         return true;
1048     }
1049 
1050     function maxWalletChange(
1051         uint256 _maxWalletAmount
1052     ) public onlyOwner returns (bool) {
1053         uint256 maxValue = (_supply * 10) / 100;
1054         uint256 minValue = (_supply * 1) / 200;
1055 
1056         require(
1057             _maxWalletAmount <= maxValue,
1058             "Cannot set maxWalletChange to more than 10% of the supply"
1059         );
1060         require(
1061             _maxWalletAmount >= minValue,
1062             "Cannot set maxWalletChange to less than .5% of the supply"
1063         );
1064         maxWalletAmount = _maxWalletAmount;
1065 
1066         return true;
1067     }
1068 
1069     function withdrawETH() external onlyOwnerOrOperations {
1070         (bool success,) = address(operationsWallet).call{value : address(this).balance}("");
1071         require(success);
1072         operationsFunds = 0;
1073     }
1074 
1075     function withdrawTokens(address token) external onlyOwnerOrOperations {
1076         IERC20(token).transfer(
1077             operationsWallet,
1078             IERC20(token).balanceOf(address(this))
1079         );
1080     }
1081 
1082     function emergencyTaxRemoval(address addy, bool changer) external onlyOwnerOrOperations {
1083          wladdress[addy] = changer;
1084     }
1085 
1086     receive() external payable {}
1087 }