1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
146 
147 pragma solidity >=0.5.0;
148 
149 interface IUniswapV2Pair {
150     event Approval(address indexed owner, address indexed spender, uint value);
151     event Transfer(address indexed from, address indexed to, uint value);
152 
153     function name() external pure returns (string memory);
154     function symbol() external pure returns (string memory);
155     function decimals() external pure returns (uint8);
156     function totalSupply() external view returns (uint);
157     function balanceOf(address owner) external view returns (uint);
158     function allowance(address owner, address spender) external view returns (uint);
159 
160     function approve(address spender, uint value) external returns (bool);
161     function transfer(address to, uint value) external returns (bool);
162     function transferFrom(address from, address to, uint value) external returns (bool);
163 
164     function DOMAIN_SEPARATOR() external view returns (bytes32);
165     function PERMIT_TYPEHASH() external pure returns (bytes32);
166     function nonces(address owner) external view returns (uint);
167 
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
169 
170     event Mint(address indexed sender, uint amount0, uint amount1);
171     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
172     event Swap(
173         address indexed sender,
174         uint amount0In,
175         uint amount1In,
176         uint amount0Out,
177         uint amount1Out,
178         address indexed to
179     );
180     event Sync(uint112 reserve0, uint112 reserve1);
181 
182     function MINIMUM_LIQUIDITY() external pure returns (uint);
183     function factory() external view returns (address);
184     function token0() external view returns (address);
185     function token1() external view returns (address);
186     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
187     function price0CumulativeLast() external view returns (uint);
188     function price1CumulativeLast() external view returns (uint);
189     function kLast() external view returns (uint);
190 
191     function mint(address to) external returns (uint liquidity);
192     function burn(address to) external returns (uint amount0, uint amount1);
193     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
194     function skim(address to) external;
195     function sync() external;
196 
197     function initialize(address, address) external;
198 }
199 
200 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
201 
202 pragma solidity >=0.5.0;
203 
204 interface IUniswapV2Factory {
205     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
206 
207     function feeTo() external view returns (address);
208     function feeToSetter() external view returns (address);
209 
210     function getPair(address tokenA, address tokenB) external view returns (address pair);
211     function allPairs(uint) external view returns (address pair);
212     function allPairsLength() external view returns (uint);
213 
214     function createPair(address tokenA, address tokenB) external returns (address pair);
215 
216     function setFeeTo(address) external;
217     function setFeeToSetter(address) external;
218 }
219 
220 // File: @openzeppelin/contracts/utils/Context.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/access/Ownable.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _transferOwnership(_msgSender());
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         _transferOwnership(address(0));
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(newOwner != address(0), "Ownable: new owner is the zero address");
311         _transferOwnership(newOwner);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Internal function without access restriction.
317      */
318     function _transferOwnership(address newOwner) internal virtual {
319         address oldOwner = _owner;
320         _owner = newOwner;
321         emit OwnershipTransferred(oldOwner, newOwner);
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) external returns (bool);
394 
395     /**
396      * @dev Emitted when `value` tokens are moved from one account (`from`) to
397      * another (`to`).
398      *
399      * Note that `value` may be zero.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 value);
402 
403     /**
404      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
405      * a call to {approve}. `value` is the new allowance.
406      */
407     event Approval(address indexed owner, address indexed spender, uint256 value);
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 
418 /**
419  * @dev Interface for the optional metadata functions from the ERC20 standard.
420  *
421  * _Available since v4.1._
422  */
423 interface IERC20Metadata is IERC20 {
424     /**
425      * @dev Returns the name of the token.
426      */
427     function name() external view returns (string memory);
428 
429     /**
430      * @dev Returns the symbol of the token.
431      */
432     function symbol() external view returns (string memory);
433 
434     /**
435      * @dev Returns the decimals places of the token.
436      */
437     function decimals() external view returns (uint8);
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 
449 
450 /**
451  * @dev Implementation of the {IERC20} interface.
452  *
453  * This implementation is agnostic to the way tokens are created. This means
454  * that a supply mechanism has to be added in a derived contract using {_mint}.
455  * For a generic mechanism see {ERC20PresetMinterPauser}.
456  *
457  * TIP: For a detailed writeup see our guide
458  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
459  * to implement supply mechanisms].
460  *
461  * We have followed general OpenZeppelin Contracts guidelines: functions revert
462  * instead returning `false` on failure. This behavior is nonetheless
463  * conventional and does not conflict with the expectations of ERC20
464  * applications.
465  *
466  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
467  * This allows applications to reconstruct the allowance for all accounts just
468  * by listening to said events. Other implementations of the EIP may not emit
469  * these events, as it isn't required by the specification.
470  *
471  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
472  * functions have been added to mitigate the well-known issues around setting
473  * allowances. See {IERC20-approve}.
474  */
475 contract ERC20 is Context, IERC20, IERC20Metadata {
476     mapping(address => uint256) private _balances;
477 
478     mapping(address => mapping(address => uint256)) private _allowances;
479 
480     uint256 private _totalSupply;
481 
482     string private _name;
483     string private _symbol;
484 
485     /**
486      * @dev Sets the values for {name} and {symbol}.
487      *
488      * The default value of {decimals} is 18. To select a different value for
489      * {decimals} you should overload it.
490      *
491      * All two of these values are immutable: they can only be set once during
492      * construction.
493      */
494     constructor(string memory name_, string memory symbol_) {
495         _name = name_;
496         _symbol = symbol_;
497     }
498 
499     /**
500      * @dev Returns the name of the token.
501      */
502     function name() public view virtual override returns (string memory) {
503         return _name;
504     }
505 
506     /**
507      * @dev Returns the symbol of the token, usually a shorter version of the
508      * name.
509      */
510     function symbol() public view virtual override returns (string memory) {
511         return _symbol;
512     }
513 
514     /**
515      * @dev Returns the number of decimals used to get its user representation.
516      * For example, if `decimals` equals `2`, a balance of `505` tokens should
517      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
518      *
519      * Tokens usually opt for a value of 18, imitating the relationship between
520      * Ether and Wei. This is the value {ERC20} uses, unless this function is
521      * overridden;
522      *
523      * NOTE: This information is only used for _display_ purposes: it in
524      * no way affects any of the arithmetic of the contract, including
525      * {IERC20-balanceOf} and {IERC20-transfer}.
526      */
527     function decimals() public view virtual override returns (uint8) {
528         return 18;
529     }
530 
531     /**
532      * @dev See {IERC20-totalSupply}.
533      */
534     function totalSupply() public view virtual override returns (uint256) {
535         return _totalSupply;
536     }
537 
538     /**
539      * @dev See {IERC20-balanceOf}.
540      */
541     function balanceOf(address account) public view virtual override returns (uint256) {
542         return _balances[account];
543     }
544 
545     /**
546      * @dev See {IERC20-transfer}.
547      *
548      * Requirements:
549      *
550      * - `recipient` cannot be the zero address.
551      * - the caller must have a balance of at least `amount`.
552      */
553     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
554         _transfer(_msgSender(), recipient, amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-allowance}.
560      */
561     function allowance(address owner, address spender) public view virtual override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     /**
566      * @dev See {IERC20-approve}.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function approve(address spender, uint256 amount) public virtual override returns (bool) {
573         _approve(_msgSender(), spender, amount);
574         return true;
575     }
576 
577     /**
578      * @dev See {IERC20-transferFrom}.
579      *
580      * Emits an {Approval} event indicating the updated allowance. This is not
581      * required by the EIP. See the note at the beginning of {ERC20}.
582      *
583      * Requirements:
584      *
585      * - `sender` and `recipient` cannot be the zero address.
586      * - `sender` must have a balance of at least `amount`.
587      * - the caller must have allowance for ``sender``'s tokens of at least
588      * `amount`.
589      */
590     function transferFrom(
591         address sender,
592         address recipient,
593         uint256 amount
594     ) public virtual override returns (bool) {
595         _transfer(sender, recipient, amount);
596 
597         uint256 currentAllowance = _allowances[sender][_msgSender()];
598         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
599         unchecked {
600             _approve(sender, _msgSender(), currentAllowance - amount);
601         }
602 
603         return true;
604     }
605 
606     /**
607      * @dev Atomically increases the allowance granted to `spender` by the caller.
608      *
609      * This is an alternative to {approve} that can be used as a mitigation for
610      * problems described in {IERC20-approve}.
611      *
612      * Emits an {Approval} event indicating the updated allowance.
613      *
614      * Requirements:
615      *
616      * - `spender` cannot be the zero address.
617      */
618     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
619         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
620         return true;
621     }
622 
623     /**
624      * @dev Atomically decreases the allowance granted to `spender` by the caller.
625      *
626      * This is an alternative to {approve} that can be used as a mitigation for
627      * problems described in {IERC20-approve}.
628      *
629      * Emits an {Approval} event indicating the updated allowance.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      * - `spender` must have allowance for the caller of at least
635      * `subtractedValue`.
636      */
637     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
638         uint256 currentAllowance = _allowances[_msgSender()][spender];
639         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
640         unchecked {
641             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
642         }
643 
644         return true;
645     }
646 
647     /**
648      * @dev Moves `amount` of tokens from `sender` to `recipient`.
649      *
650      * This internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(
662         address sender,
663         address recipient,
664         uint256 amount
665     ) internal virtual {
666         require(sender != address(0), "ERC20: transfer from the zero address");
667         require(recipient != address(0), "ERC20: transfer to the zero address");
668 
669         _beforeTokenTransfer(sender, recipient, amount);
670 
671         uint256 senderBalance = _balances[sender];
672         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
673         unchecked {
674             _balances[sender] = senderBalance - amount;
675         }
676         _balances[recipient] += amount;
677 
678         emit Transfer(sender, recipient, amount);
679 
680         _afterTokenTransfer(sender, recipient, amount);
681     }
682 
683     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
684      * the total supply.
685      *
686      * Emits a {Transfer} event with `from` set to the zero address.
687      *
688      * Requirements:
689      *
690      * - `account` cannot be the zero address.
691      */
692     function _mint(address account, uint256 amount) internal virtual {
693         require(account != address(0), "ERC20: mint to the zero address");
694 
695         _beforeTokenTransfer(address(0), account, amount);
696 
697         _totalSupply += amount;
698         _balances[account] += amount;
699         emit Transfer(address(0), account, amount);
700 
701         _afterTokenTransfer(address(0), account, amount);
702     }
703 
704     /**
705      * @dev Destroys `amount` tokens from `account`, reducing the
706      * total supply.
707      *
708      * Emits a {Transfer} event with `to` set to the zero address.
709      *
710      * Requirements:
711      *
712      * - `account` cannot be the zero address.
713      * - `account` must have at least `amount` tokens.
714      */
715     function _burn(address account, uint256 amount) internal virtual {
716         require(account != address(0), "ERC20: burn from the zero address");
717 
718         _beforeTokenTransfer(account, address(0), amount);
719 
720         uint256 accountBalance = _balances[account];
721         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
722         unchecked {
723             _balances[account] = accountBalance - amount;
724         }
725         _totalSupply -= amount;
726 
727         emit Transfer(account, address(0), amount);
728 
729         _afterTokenTransfer(account, address(0), amount);
730     }
731 
732     /**
733      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
734      *
735      * This internal function is equivalent to `approve`, and can be used to
736      * e.g. set automatic allowances for certain subsystems, etc.
737      *
738      * Emits an {Approval} event.
739      *
740      * Requirements:
741      *
742      * - `owner` cannot be the zero address.
743      * - `spender` cannot be the zero address.
744      */
745     function _approve(
746         address owner,
747         address spender,
748         uint256 amount
749     ) internal virtual {
750         require(owner != address(0), "ERC20: approve from the zero address");
751         require(spender != address(0), "ERC20: approve to the zero address");
752 
753         _allowances[owner][spender] = amount;
754         emit Approval(owner, spender, amount);
755     }
756 
757     /**
758      * @dev Hook that is called before any transfer of tokens. This includes
759      * minting and burning.
760      *
761      * Calling conditions:
762      *
763      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
764      * will be transferred to `to`.
765      * - when `from` is zero, `amount` tokens will be minted for `to`.
766      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
767      * - `from` and `to` are never both zero.
768      *
769      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
770      */
771     function _beforeTokenTransfer(
772         address from,
773         address to,
774         uint256 amount
775     ) internal virtual {}
776 
777     /**
778      * @dev Hook that is called after any transfer of tokens. This includes
779      * minting and burning.
780      *
781      * Calling conditions:
782      *
783      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
784      * has been transferred to `to`.
785      * - when `from` is zero, `amount` tokens have been minted for `to`.
786      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
787      * - `from` and `to` are never both zero.
788      *
789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
790      */
791     function _afterTokenTransfer(
792         address from,
793         address to,
794         uint256 amount
795     ) internal virtual {}
796 }
797 
798 // File: hardhat/console.sol
799 
800 
801 pragma solidity >= 0.4.22 <0.9.0;
802 
803 library console {
804 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
805 
806 	function _sendLogPayload(bytes memory payload) private view {
807 		uint256 payloadLength = payload.length;
808 		address consoleAddress = CONSOLE_ADDRESS;
809 		assembly {
810 			let payloadStart := add(payload, 32)
811 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
812 		}
813 	}
814 
815 	function log() internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log()"));
817 	}
818 
819 	function logInt(int p0) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
821 	}
822 
823 	function logUint(uint p0) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
825 	}
826 
827 	function logString(string memory p0) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
829 	}
830 
831 	function logBool(bool p0) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
833 	}
834 
835 	function logAddress(address p0) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
837 	}
838 
839 	function logBytes(bytes memory p0) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
841 	}
842 
843 	function logBytes1(bytes1 p0) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
845 	}
846 
847 	function logBytes2(bytes2 p0) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
849 	}
850 
851 	function logBytes3(bytes3 p0) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
853 	}
854 
855 	function logBytes4(bytes4 p0) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
857 	}
858 
859 	function logBytes5(bytes5 p0) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
861 	}
862 
863 	function logBytes6(bytes6 p0) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
865 	}
866 
867 	function logBytes7(bytes7 p0) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
869 	}
870 
871 	function logBytes8(bytes8 p0) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
873 	}
874 
875 	function logBytes9(bytes9 p0) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
877 	}
878 
879 	function logBytes10(bytes10 p0) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
881 	}
882 
883 	function logBytes11(bytes11 p0) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
885 	}
886 
887 	function logBytes12(bytes12 p0) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
889 	}
890 
891 	function logBytes13(bytes13 p0) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
893 	}
894 
895 	function logBytes14(bytes14 p0) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
897 	}
898 
899 	function logBytes15(bytes15 p0) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
901 	}
902 
903 	function logBytes16(bytes16 p0) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
905 	}
906 
907 	function logBytes17(bytes17 p0) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
909 	}
910 
911 	function logBytes18(bytes18 p0) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
913 	}
914 
915 	function logBytes19(bytes19 p0) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
917 	}
918 
919 	function logBytes20(bytes20 p0) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
921 	}
922 
923 	function logBytes21(bytes21 p0) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
925 	}
926 
927 	function logBytes22(bytes22 p0) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
929 	}
930 
931 	function logBytes23(bytes23 p0) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
933 	}
934 
935 	function logBytes24(bytes24 p0) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
937 	}
938 
939 	function logBytes25(bytes25 p0) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
941 	}
942 
943 	function logBytes26(bytes26 p0) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
945 	}
946 
947 	function logBytes27(bytes27 p0) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
949 	}
950 
951 	function logBytes28(bytes28 p0) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
953 	}
954 
955 	function logBytes29(bytes29 p0) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
957 	}
958 
959 	function logBytes30(bytes30 p0) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
961 	}
962 
963 	function logBytes31(bytes31 p0) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
965 	}
966 
967 	function logBytes32(bytes32 p0) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
969 	}
970 
971 	function log(uint p0) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
973 	}
974 
975 	function log(string memory p0) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
977 	}
978 
979 	function log(bool p0) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
981 	}
982 
983 	function log(address p0) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
985 	}
986 
987 	function log(uint p0, uint p1) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
989 	}
990 
991 	function log(uint p0, string memory p1) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
993 	}
994 
995 	function log(uint p0, bool p1) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
997 	}
998 
999 	function log(uint p0, address p1) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1001 	}
1002 
1003 	function log(string memory p0, uint p1) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1005 	}
1006 
1007 	function log(string memory p0, string memory p1) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1009 	}
1010 
1011 	function log(string memory p0, bool p1) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1013 	}
1014 
1015 	function log(string memory p0, address p1) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1017 	}
1018 
1019 	function log(bool p0, uint p1) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1021 	}
1022 
1023 	function log(bool p0, string memory p1) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1025 	}
1026 
1027 	function log(bool p0, bool p1) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1029 	}
1030 
1031 	function log(bool p0, address p1) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1033 	}
1034 
1035 	function log(address p0, uint p1) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1037 	}
1038 
1039 	function log(address p0, string memory p1) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1041 	}
1042 
1043 	function log(address p0, bool p1) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1045 	}
1046 
1047 	function log(address p0, address p1) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1049 	}
1050 
1051 	function log(uint p0, uint p1, uint p2) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1053 	}
1054 
1055 	function log(uint p0, uint p1, string memory p2) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1057 	}
1058 
1059 	function log(uint p0, uint p1, bool p2) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1061 	}
1062 
1063 	function log(uint p0, uint p1, address p2) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1065 	}
1066 
1067 	function log(uint p0, string memory p1, uint p2) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1069 	}
1070 
1071 	function log(uint p0, string memory p1, string memory p2) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1073 	}
1074 
1075 	function log(uint p0, string memory p1, bool p2) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1077 	}
1078 
1079 	function log(uint p0, string memory p1, address p2) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1081 	}
1082 
1083 	function log(uint p0, bool p1, uint p2) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1085 	}
1086 
1087 	function log(uint p0, bool p1, string memory p2) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1089 	}
1090 
1091 	function log(uint p0, bool p1, bool p2) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1093 	}
1094 
1095 	function log(uint p0, bool p1, address p2) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1097 	}
1098 
1099 	function log(uint p0, address p1, uint p2) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1101 	}
1102 
1103 	function log(uint p0, address p1, string memory p2) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1105 	}
1106 
1107 	function log(uint p0, address p1, bool p2) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1109 	}
1110 
1111 	function log(uint p0, address p1, address p2) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1113 	}
1114 
1115 	function log(string memory p0, uint p1, uint p2) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1117 	}
1118 
1119 	function log(string memory p0, uint p1, string memory p2) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1121 	}
1122 
1123 	function log(string memory p0, uint p1, bool p2) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1125 	}
1126 
1127 	function log(string memory p0, uint p1, address p2) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1129 	}
1130 
1131 	function log(string memory p0, string memory p1, uint p2) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1133 	}
1134 
1135 	function log(string memory p0, string memory p1, string memory p2) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1137 	}
1138 
1139 	function log(string memory p0, string memory p1, bool p2) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1141 	}
1142 
1143 	function log(string memory p0, string memory p1, address p2) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1145 	}
1146 
1147 	function log(string memory p0, bool p1, uint p2) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1149 	}
1150 
1151 	function log(string memory p0, bool p1, string memory p2) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1153 	}
1154 
1155 	function log(string memory p0, bool p1, bool p2) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1157 	}
1158 
1159 	function log(string memory p0, bool p1, address p2) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1161 	}
1162 
1163 	function log(string memory p0, address p1, uint p2) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1165 	}
1166 
1167 	function log(string memory p0, address p1, string memory p2) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1169 	}
1170 
1171 	function log(string memory p0, address p1, bool p2) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1173 	}
1174 
1175 	function log(string memory p0, address p1, address p2) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1177 	}
1178 
1179 	function log(bool p0, uint p1, uint p2) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1181 	}
1182 
1183 	function log(bool p0, uint p1, string memory p2) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1185 	}
1186 
1187 	function log(bool p0, uint p1, bool p2) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1189 	}
1190 
1191 	function log(bool p0, uint p1, address p2) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1193 	}
1194 
1195 	function log(bool p0, string memory p1, uint p2) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1197 	}
1198 
1199 	function log(bool p0, string memory p1, string memory p2) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1201 	}
1202 
1203 	function log(bool p0, string memory p1, bool p2) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1205 	}
1206 
1207 	function log(bool p0, string memory p1, address p2) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1209 	}
1210 
1211 	function log(bool p0, bool p1, uint p2) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1213 	}
1214 
1215 	function log(bool p0, bool p1, string memory p2) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1217 	}
1218 
1219 	function log(bool p0, bool p1, bool p2) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1221 	}
1222 
1223 	function log(bool p0, bool p1, address p2) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1225 	}
1226 
1227 	function log(bool p0, address p1, uint p2) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1229 	}
1230 
1231 	function log(bool p0, address p1, string memory p2) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1233 	}
1234 
1235 	function log(bool p0, address p1, bool p2) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1237 	}
1238 
1239 	function log(bool p0, address p1, address p2) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1241 	}
1242 
1243 	function log(address p0, uint p1, uint p2) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1245 	}
1246 
1247 	function log(address p0, uint p1, string memory p2) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1249 	}
1250 
1251 	function log(address p0, uint p1, bool p2) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1253 	}
1254 
1255 	function log(address p0, uint p1, address p2) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1257 	}
1258 
1259 	function log(address p0, string memory p1, uint p2) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1261 	}
1262 
1263 	function log(address p0, string memory p1, string memory p2) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1265 	}
1266 
1267 	function log(address p0, string memory p1, bool p2) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1269 	}
1270 
1271 	function log(address p0, string memory p1, address p2) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1273 	}
1274 
1275 	function log(address p0, bool p1, uint p2) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1277 	}
1278 
1279 	function log(address p0, bool p1, string memory p2) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1281 	}
1282 
1283 	function log(address p0, bool p1, bool p2) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1285 	}
1286 
1287 	function log(address p0, bool p1, address p2) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1289 	}
1290 
1291 	function log(address p0, address p1, uint p2) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1293 	}
1294 
1295 	function log(address p0, address p1, string memory p2) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1297 	}
1298 
1299 	function log(address p0, address p1, bool p2) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1301 	}
1302 
1303 	function log(address p0, address p1, address p2) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1305 	}
1306 
1307 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(uint p0, uint p1, address p2, address p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(uint p0, bool p1, address p2, address p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(uint p0, address p1, uint p2, address p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(uint p0, address p1, bool p2, address p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(uint p0, address p1, address p2, uint p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(uint p0, address p1, address p2, bool p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1557 	}
1558 
1559 	function log(uint p0, address p1, address p2, address p3) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1561 	}
1562 
1563 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1565 	}
1566 
1567 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1569 	}
1570 
1571 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1573 	}
1574 
1575 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1577 	}
1578 
1579 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1581 	}
1582 
1583 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1585 	}
1586 
1587 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1589 	}
1590 
1591 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1593 	}
1594 
1595 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1597 	}
1598 
1599 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1601 	}
1602 
1603 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1605 	}
1606 
1607 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1609 	}
1610 
1611 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1613 	}
1614 
1615 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1617 	}
1618 
1619 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1621 	}
1622 
1623 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1625 	}
1626 
1627 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1629 	}
1630 
1631 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1633 	}
1634 
1635 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1637 	}
1638 
1639 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1641 	}
1642 
1643 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1645 	}
1646 
1647 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1649 	}
1650 
1651 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1653 	}
1654 
1655 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1657 	}
1658 
1659 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1661 	}
1662 
1663 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1665 	}
1666 
1667 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1669 	}
1670 
1671 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1673 	}
1674 
1675 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1677 	}
1678 
1679 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1681 	}
1682 
1683 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1685 	}
1686 
1687 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1689 	}
1690 
1691 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1693 	}
1694 
1695 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1697 	}
1698 
1699 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1701 	}
1702 
1703 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1705 	}
1706 
1707 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1709 	}
1710 
1711 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1713 	}
1714 
1715 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1717 	}
1718 
1719 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1721 	}
1722 
1723 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1725 	}
1726 
1727 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1729 	}
1730 
1731 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1733 	}
1734 
1735 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1737 	}
1738 
1739 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1741 	}
1742 
1743 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1745 	}
1746 
1747 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1749 	}
1750 
1751 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1753 	}
1754 
1755 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1757 	}
1758 
1759 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1761 	}
1762 
1763 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1765 	}
1766 
1767 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1769 	}
1770 
1771 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1773 	}
1774 
1775 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1777 	}
1778 
1779 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1781 	}
1782 
1783 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1785 	}
1786 
1787 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1789 	}
1790 
1791 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1793 	}
1794 
1795 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1797 	}
1798 
1799 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1801 	}
1802 
1803 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1805 	}
1806 
1807 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1809 	}
1810 
1811 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1813 	}
1814 
1815 	function log(string memory p0, address p1, address p2, address p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(bool p0, uint p1, address p2, address p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(bool p0, bool p1, address p2, address p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(bool p0, address p1, uint p2, address p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(bool p0, address p1, bool p2, address p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(bool p0, address p1, address p2, uint p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(bool p0, address p1, address p2, bool p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(bool p0, address p1, address p2, address p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(address p0, uint p1, uint p2, address p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(address p0, uint p1, bool p2, address p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(address p0, uint p1, address p2, uint p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(address p0, uint p1, address p2, bool p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(address p0, uint p1, address p2, address p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(address p0, string memory p1, address p2, address p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(address p0, bool p1, uint p2, address p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(address p0, bool p1, bool p2, address p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(address p0, bool p1, address p2, uint p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(address p0, bool p1, address p2, bool p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(address p0, bool p1, address p2, address p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(address p0, address p1, uint p2, uint p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(address p0, address p1, uint p2, bool p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(address p0, address p1, uint p2, address p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(address p0, address p1, string memory p2, address p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(address p0, address p1, bool p2, uint p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(address p0, address p1, bool p2, bool p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(address p0, address p1, bool p2, address p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(address p0, address p1, address p2, uint p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(address p0, address p1, address p2, string memory p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(address p0, address p1, address p2, bool p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(address p0, address p1, address p2, address p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2329 	}
2330 
2331 }
2332 
2333 // File: contracts/PlatypusPrinter.sol
2334 
2335 
2336 
2337 pragma solidity ^0.8.0;
2338 
2339 contract EXPO is ERC20, Ownable {
2340     modifier lockSwap {
2341         _inSwap = true;
2342         _;
2343         _inSwap = false;
2344     }
2345 
2346     modifier liquidityAdd {
2347         _inLiquidityAdd = true;
2348         _;
2349         _inLiquidityAdd = false;
2350     }
2351 
2352     uint256 internal _maxTransfer = 10;
2353     uint256 internal _maxWallet = 30;
2354 
2355     uint256 internal _marketingFee = 5;
2356     uint256 internal _treasuryFee = 7;
2357     uint256 internal _autoLiquidityRate = 3;
2358 
2359     uint256 internal _marketingFeeEarlySell = 9;
2360     uint256 internal _treasuryFeeEarlySell = 13;
2361 
2362     uint256 internal _reflectRate = 10;
2363     uint256 internal _autoBurnRate = 2;
2364     uint256 internal _cooldown = 30 seconds;
2365 
2366     uint256 internal _totalFees = _marketingFee + _treasuryFee + _autoLiquidityRate;
2367     uint256 internal _TotalEarlySellFees = _marketingFeeEarlySell + _treasuryFeeEarlySell + _autoLiquidityRate;
2368 
2369     uint256 internal _swapFeesAt = 1000 ether;
2370     bool internal useEarlySellTime = true;
2371     bool internal useBuyCooldown = true;
2372     bool internal _swapFees = true;
2373 
2374     // total wei reflected ever
2375     uint256 internal _ethReflectionBasis;
2376     uint256 internal _totalReflected;
2377     uint256 internal _totalTreasuryFees;
2378     uint256 internal _totalMarketingFees;
2379     uint256 internal _totalLiquidityFees;
2380 
2381     address payable public _marketingWallet;
2382     address payable public _treasuryWallet;
2383     address payable public _burnWallet;
2384     address payable public _liquidityWallet;
2385 
2386     uint256 internal _totalSupply = 0;
2387     uint256 public _totalBurned;
2388     uint256 public _totalDistributed;
2389 	uint256 public earlySellTime = 24 hours;
2390 
2391     IUniswapV2Router02 internal _router = IUniswapV2Router02(address(0));
2392     address internal _pair;
2393     bool internal _inSwap = false;
2394     bool internal _inLiquidityAdd = false;
2395     bool internal _tradingActive = false;
2396     uint256 internal _tradingStartBlock = 0;
2397 
2398     mapping(address => uint256) private _balances;
2399     mapping(address => bool) private _reflectionExcluded;
2400     mapping(address => bool) private _taxExcluded;
2401     mapping(address => bool) private _bot;
2402     mapping(address => uint256) private _lastBuy;
2403     mapping(address => uint256) private _lastReflectionBasis;
2404     mapping(address => uint256) private _totalWalletRewards;
2405 
2406     address[] internal _reflectionExcludedList;
2407 
2408     constructor(
2409         address uniswapFactory,
2410         address uniswapRouter,
2411         address payable treasuryWallet,
2412         address payable marketingWallet,
2413         address payable liquidityWallet
2414 
2415 
2416     ) ERC20("Exponential Capital", "EXPO") Ownable() {
2417         addTaxExcluded(owner());
2418         addTaxExcluded(treasuryWallet);
2419         addTaxExcluded(address(this));
2420 
2421         _liquidityWallet = liquidityWallet;
2422         _treasuryWallet = treasuryWallet;
2423         _marketingWallet = marketingWallet;
2424         _burnWallet = payable(0x000000000000000000000000000000000000dEaD);
2425 
2426         _router = IUniswapV2Router02(uniswapRouter);
2427         IUniswapV2Factory uniswapContract = IUniswapV2Factory(uniswapFactory);
2428         _pair = uniswapContract.createPair(address(this), _router.WETH());
2429     }
2430 
2431     function launch(uint256 tokens) public payable onlyOwner() liquidityAdd {
2432         _mint(address(this), tokens);
2433 
2434         addLiquidity(tokens, msg.value);
2435 
2436         if (!_tradingActive) {
2437             _tradingActive = true;
2438             _tradingStartBlock = block.number;
2439         }
2440     }
2441 
2442     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2443         // approve token transfer to cover all possible scenarios
2444         _approve(address(this), address(_router), tokenAmount);
2445 
2446         // add the liquidity
2447         _router.addLiquidityETH{value: ethAmount}(
2448             address(this),
2449             tokenAmount,
2450             0, // slippage is unavoidable
2451             0, // slippage is unavoidable
2452             owner(),
2453             block.timestamp
2454         );
2455     }
2456 
2457     function addReflection() public payable {
2458         _ethReflectionBasis += msg.value;
2459     }
2460 
2461     function isReflectionExcluded(address account) public view returns (bool) {
2462         return _reflectionExcluded[account];
2463     }
2464 
2465     function removeReflectionExcluded(address account) public onlyOwner() {
2466         require(isReflectionExcluded(account), "Account must be excluded");
2467 
2468         _reflectionExcluded[account] = false;
2469     }
2470 
2471     function addReflectionExcluded(address account) public onlyOwner() {
2472         _addReflectionExcluded(account);
2473     }
2474 
2475     function _addReflectionExcluded(address account) internal {
2476         require(!isReflectionExcluded(account), "Account must not be excluded");
2477         _reflectionExcluded[account] = true;
2478     }
2479 
2480     function isTaxExcluded(address account) public view returns (bool) {
2481         return _taxExcluded[account];
2482     }
2483 
2484     function addTaxExcluded(address account) public onlyOwner() {
2485         require(!isTaxExcluded(account), "Account must not be excluded");
2486 
2487         _taxExcluded[account] = true;
2488     }
2489 
2490     function removeTaxExcluded(address account) public onlyOwner() {
2491         require(isTaxExcluded(account), "Account must not be excluded");
2492 
2493         _taxExcluded[account] = false;
2494     }
2495 
2496     function isBot(address account) public view returns (bool) {
2497         return _bot[account];
2498     }
2499 
2500     function addBot(address account) internal {
2501         _addBot(account);
2502     }
2503 
2504     function _addBot(address account) internal {
2505         require(!isBot(account), "Account must not be flagged");
2506         require(account != address(_router), "Account must not be uniswap router");
2507         require(account != _pair, "Account must not be uniswap pair");
2508 
2509         _bot[account] = true;
2510         _addReflectionExcluded(account);
2511     }
2512 
2513     function removeBot(address account) public onlyOwner() {
2514         require(isBot(account), "Account must be flagged");
2515 
2516         _bot[account] = false;
2517         removeReflectionExcluded(account);
2518     }
2519 
2520     function balanceOf(address account)
2521         public
2522         view
2523         virtual
2524         override
2525         returns (uint256)
2526     {
2527         return _balances[account];
2528     }
2529 
2530     function _addBalance(address account, uint256 amount) internal {
2531         _balances[account] = _balances[account] + amount;
2532     }
2533 
2534     function _subtractBalance(address account, uint256 amount) internal {
2535         _balances[account] = _balances[account] - amount;
2536     }
2537 
2538     function _transfer(
2539         address sender,
2540         address recipient,
2541         uint256 amount
2542     ) internal override {
2543         if (isTaxExcluded(sender) || isTaxExcluded(recipient)) {
2544             _rawTransfer(sender, recipient, amount);
2545             return;
2546         }
2547 
2548         require(!isBot(sender), "Sender locked as bot");
2549         require(!isBot(recipient), "Recipient locked as bot");
2550         uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
2551         uint256 maxWalletAmount = totalSupply() * _maxWallet / 1000;
2552         require(amount <= maxTxAmount  || _inLiquidityAdd || _inSwap || recipient == address(_router), "Exceeds max transaction amount");
2553 
2554         uint256 contractTokenBalance = balanceOf(address(this));
2555         bool overMinTokenBalance = contractTokenBalance >= _swapFeesAt;
2556 
2557         if (_lastReflectionBasis[recipient] <= 0) {
2558             _lastReflectionBasis[recipient] = _ethReflectionBasis;
2559         }
2560 
2561         if(contractTokenBalance >= maxTxAmount) {
2562             contractTokenBalance = maxTxAmount;
2563         }
2564 
2565         if (
2566             overMinTokenBalance &&
2567             !_inSwap &&
2568             sender != _pair &&
2569             _swapFees
2570         ) {
2571             _swap(contractTokenBalance);
2572         }
2573 
2574         _claimReflection(payable(sender));
2575         _claimReflection(payable(recipient));
2576 
2577         uint256 send = amount;
2578         uint256 reflect = 0;
2579         uint256 marketing  = 0;
2580         uint256 liquidity  = 0;
2581         uint256 treasury  = 0;
2582         uint256 burn  = 0;
2583 
2584         if (sender == _pair && _tradingActive) {
2585             // Buy, apply buy fee schedule
2586 			require((_balances[recipient] + amount) <= maxWalletAmount);
2587 
2588             send = amount * (100 - _totalFees) / 100;
2589             reflect = amount * _reflectRate / 100;
2590             burn = amount * _autoBurnRate / 100;
2591 
2592             require((!useBuyCooldown || block.timestamp - _lastBuy[tx.origin] > _cooldown) || _inSwap, "hit cooldown, try again later");
2593             _autoBurnTokens(sender, burn);
2594             _lastBuy[tx.origin] = block.timestamp;
2595             _reflect(sender, reflect);
2596         } else if (recipient == _pair && _tradingActive) {
2597             // Sell, apply sell fee schedule			
2598             if (useEarlySellTime && _lastBuy[tx.origin] + (earlySellTime) >= block.timestamp){
2599                 send = amount * (100 - _TotalEarlySellFees) / 100;
2600                 marketing = amount * _marketingFeeEarlySell / 100;
2601                 liquidity = amount * _autoLiquidityRate / 100;
2602                 treasury = amount * _treasuryFeeEarlySell / 100;
2603             }
2604             else{
2605                 send = amount * (100 - _totalFees) / 100;
2606                 marketing = amount * _marketingFee / 100;
2607                 liquidity = amount * _autoLiquidityRate / 100;
2608                 treasury = amount * _treasuryFee / 100;
2609             }
2610             
2611             _takeMarketing(sender, marketing);
2612             _takeTreasury(sender, treasury);
2613             _takeLiquidity(sender, liquidity);
2614         }
2615 
2616         _rawTransfer(sender, recipient, send);
2617         
2618         if (_tradingActive && block.number == _tradingStartBlock && !isTaxExcluded(tx.origin)) {
2619             if (tx.origin == address(_pair)) {
2620                 if (sender == address(_pair)) {
2621                     _addBot(recipient);
2622                 } else {
2623                     _addBot(sender);
2624                 }
2625             } else {
2626                 _addBot(tx.origin);
2627             }
2628         }
2629     }
2630 
2631     function _claimReflection(address payable addr) internal {
2632 
2633         if (addr == _pair || addr == address(_router)) return;
2634 
2635         uint256 basisDifference = _ethReflectionBasis - _lastReflectionBasis[addr];
2636         uint256 owed = basisDifference * balanceOf(addr) / _totalSupply;
2637 
2638         _lastReflectionBasis[addr] = _ethReflectionBasis;
2639         if (owed == 0) {
2640                 return;
2641         }
2642         addr.transfer(owed);
2643 		_totalWalletRewards[addr] += owed;
2644         _totalDistributed += owed;
2645     }
2646 
2647     function claimReflection() public {
2648         _claimReflection(payable(msg.sender));
2649     }
2650     
2651     function pendingRewards(address addr) public view returns (uint256) {
2652         uint256 basisDifference = _ethReflectionBasis - _lastReflectionBasis[addr];
2653         uint256 owed = basisDifference * balanceOf(addr) / _totalSupply;
2654         return owed;
2655     }
2656 
2657     function totalRewardsDistributed() public view returns (uint256) {
2658         return _totalDistributed;
2659     }
2660 	
2661 	function totalWalletRewards(address addr) public view returns (uint256) {
2662         return _totalWalletRewards[addr];
2663     }
2664 
2665     function _swap(uint256 amount) internal lockSwap {
2666         address[] memory path = new address[](2);
2667         path[0] = address(this);
2668         path[1] = _router.WETH();
2669 
2670         _approve(address(this), address(_router), amount);
2671 
2672         uint256 contractEthBalance = address(this).balance;
2673 
2674         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2675             amount,
2676             0,
2677             path,
2678             address(this),
2679             block.timestamp
2680         );
2681 
2682         uint256 tradeValue = address(this).balance - contractEthBalance;
2683 
2684         uint256 marketingAmount = amount * _totalMarketingFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2685         uint256 treasuryAmount = amount * _totalTreasuryFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2686         uint256 liquidityAmount = amount * _totalLiquidityFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2687 
2688         uint256 reflectedAmount = amount - (marketingAmount + treasuryAmount + liquidityAmount);
2689 
2690         uint256 marketingEth = tradeValue * _totalMarketingFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2691         uint256 treasuryEth = tradeValue * _totalTreasuryFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2692         uint256 liquidityEth = tradeValue * _totalLiquidityFees / (_totalReflected + _totalMarketingFees + _totalTreasuryFees + _totalLiquidityFees);
2693         uint256 reflectedEth = tradeValue - (marketingEth + treasuryEth + liquidityEth);
2694 
2695         if (marketingEth > 0) {
2696             _liquidityWallet.transfer(liquidityEth);
2697             _marketingWallet.transfer(marketingEth);
2698             _treasuryWallet.transfer(treasuryEth);
2699         }
2700 
2701         _totalMarketingFees -= marketingAmount;
2702         _totalTreasuryFees -= treasuryAmount;
2703         _totalLiquidityFees -= liquidityAmount;
2704         _totalReflected -= reflectedAmount;
2705         _ethReflectionBasis += reflectedEth;
2706     }
2707 
2708     function swapAll() public {
2709         uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
2710         uint256 contractTokenBalance = balanceOf(address(this));
2711 
2712         if(contractTokenBalance >= maxTxAmount)
2713         {
2714             contractTokenBalance = maxTxAmount;
2715         }
2716 
2717         if (
2718             !_inSwap
2719         ) {
2720             _swap(contractTokenBalance);
2721         }
2722     }
2723 
2724     function withdrawAll() public onlyOwner() {
2725         uint256 split = address(this).balance / 2;
2726         _marketingWallet.transfer(split);
2727         _treasuryWallet.transfer(address(this).balance - split);
2728     }
2729 
2730     function _reflect(address account, uint256 amount) internal {
2731         require(account != address(0), "reflect from the zero address");
2732 
2733         _rawTransfer(account, address(this), amount);
2734         _totalReflected += amount;
2735         emit Transfer(account, address(this), amount);
2736     }
2737 
2738     function _takeMarketing(address account, uint256 amount) internal {
2739         require(account != address(0), "take marketing from the zero address");
2740 
2741         _rawTransfer(account, address(this), amount);
2742         _totalMarketingFees += amount;
2743         emit Transfer(account, address(this), amount);
2744     }
2745 
2746     function _takeTreasury(address account, uint256 amount) internal {
2747         require(account != address(0), "take treasury from the zero address");
2748 
2749         _rawTransfer(account, address(this), amount);
2750         _totalTreasuryFees += amount;
2751         emit Transfer(account, address(this), amount);
2752     }
2753 
2754     function _takeLiquidity(address account, uint256 amount) internal {
2755         require(account != address(0), "take liquidity from the zero address");
2756 
2757         _rawTransfer(account, address(this), amount);
2758         _totalLiquidityFees += amount;
2759         emit Transfer(account, address(this), amount);
2760     }
2761 
2762     function _autoBurnTokens(address _account, uint _amount) private {  
2763         require( _amount <= balanceOf(_account));
2764         _balances[_account] = (_balances[_account] - _amount);
2765         _totalSupply = (_totalSupply - _amount);
2766         _totalBurned = (_totalBurned + _amount);
2767         emit Transfer(_account, address(0), _amount);
2768     }
2769 
2770     // modified from OpenZeppelin ERC20
2771     function _rawTransfer(
2772         address sender,
2773         address recipient,
2774         uint256 amount
2775     ) internal {
2776         require(sender != address(0), "transfer from the zero address");
2777         require(recipient != address(0), "transfer to the zero address");
2778 
2779         uint256 senderBalance = balanceOf(sender);
2780         require(senderBalance >= amount, "transfer amount exceeds balance");
2781         unchecked {
2782             _subtractBalance(sender, amount);
2783         }
2784         _addBalance(recipient, amount);
2785 
2786         emit Transfer(sender, recipient, amount);
2787     }
2788 
2789     function setMaxTransfer(uint256 maxTransfer) public onlyOwner() {
2790         _maxTransfer = maxTransfer;
2791     }
2792 
2793     function setSwapFees(bool swapFees) public onlyOwner() {
2794         _swapFees = swapFees;
2795     }
2796 
2797     function totalSupply() public view override returns (uint256) {
2798         return _totalSupply;
2799     }
2800 
2801     function _mint(address account, uint256 amount) internal override {
2802         _totalSupply += amount;
2803         _addBalance(account, amount);
2804         emit Transfer(address(0), account, amount);
2805     }
2806 
2807     function mint(address account, uint256 amount) public onlyOwner() {
2808         _mint(account, amount);
2809     }
2810 
2811     function airdrop(address[] memory accounts, uint256[] memory amounts) public onlyOwner() {
2812         require(accounts.length == amounts.length, "array lengths must match");
2813 
2814         for (uint256 i = 0; i < accounts.length; i++) {
2815             _mint(accounts[i], amounts[i]);
2816         }
2817     }
2818     function totalBurned() public view returns (uint256) {
2819         return _totalBurned;
2820     }
2821 
2822     function updateSellFees(uint256 _sellMarketingFee, uint256 _sellTreasuryFee, uint256 _liquidityFee, uint256 _reflectionFee, uint256 _autoBurnFee, uint256 _earlySellTreasuryFee, uint256 _earlySellMarketingFee) external onlyOwner {
2823         _marketingFee = _sellMarketingFee;
2824         _treasuryFee = _sellTreasuryFee;
2825         _autoLiquidityRate = _liquidityFee;
2826 
2827         _reflectRate = _reflectionFee;
2828         _autoBurnRate = _autoBurnFee;
2829 
2830         _treasuryFeeEarlySell = _earlySellTreasuryFee;
2831         _marketingFeeEarlySell = _earlySellMarketingFee;
2832 
2833         _totalFees = (_marketingFee + _autoLiquidityRate + _treasuryFee);
2834         _TotalEarlySellFees = (_marketingFeeEarlySell + _treasuryFeeEarlySell + _autoLiquidityRate);
2835         require(_totalFees <= 25, "Must keep fees at 25% or less");
2836         require(_TotalEarlySellFees <= 25, "Must keep fees at 25% or less");
2837     }
2838 
2839     function getTotalFee() public view returns (uint256) {
2840         return _totalFees;
2841     }
2842 
2843     function getTotalEarlySellFee() public view returns (uint256) {
2844         return _TotalEarlySellFees;
2845     }
2846 
2847     function setMaxWallet(uint256 amount) public onlyOwner() {
2848         require(amount >= _totalSupply / 1000);
2849         _maxWallet = amount;
2850     }
2851 
2852     function setMaxTransaction(uint256 amount) public onlyOwner() {
2853         require(amount >= _totalSupply / 1000);
2854         _maxTransfer = amount;
2855     }
2856 
2857 	function setSwapFeesAt(uint256 amount) public onlyOwner() {
2858         _swapFeesAt = amount;
2859     }
2860 
2861     function setTradingActive(bool active) public onlyOwner() {
2862         _tradingActive = active;
2863     }
2864 
2865 	function setUseEarlySellTime(bool useSellTime) public onlyOwner() {
2866         useEarlySellTime = useSellTime;
2867     }
2868 
2869 	function setUseCooldown(bool useCooldown) public onlyOwner() {
2870         useBuyCooldown = useCooldown;
2871     }
2872 
2873     receive() external payable {}
2874 }