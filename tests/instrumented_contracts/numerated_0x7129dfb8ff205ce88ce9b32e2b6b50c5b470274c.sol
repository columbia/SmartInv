1 // File: contracts/AJINU.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-03-28
5 */
6 
7 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
8 
9 pragma solidity >=0.6.2;
10 
11 interface IUniswapV2Router01 {
12     function factory() external pure returns (address);
13 
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
26 
27     function addLiquidityETH(
28         address token,
29         uint amountTokenDesired,
30         uint amountTokenMin,
31         uint amountETHMin,
32         address to,
33         uint deadline
34     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35 
36     function removeLiquidity(
37         address tokenA,
38         address tokenB,
39         uint liquidity,
40         uint amountAMin,
41         uint amountBMin,
42         address to,
43         uint deadline
44     ) external returns (uint amountA, uint amountB);
45 
46     function removeLiquidityETH(
47         address token,
48         uint liquidity,
49         uint amountTokenMin,
50         uint amountETHMin,
51         address to,
52         uint deadline
53     ) external returns (uint amountToken, uint amountETH);
54 
55     function removeLiquidityWithPermit(
56         address tokenA,
57         address tokenB,
58         uint liquidity,
59         uint amountAMin,
60         uint amountBMin,
61         address to,
62         uint deadline,
63         bool approveMax, uint8 v, bytes32 r, bytes32 s
64     ) external returns (uint amountA, uint amountB);
65 
66     function removeLiquidityETHWithPermit(
67         address token,
68         uint liquidity,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline,
73         bool approveMax, uint8 v, bytes32 r, bytes32 s
74     ) external returns (uint amountToken, uint amountETH);
75 
76     function swapExactTokensForTokens(
77         uint amountIn,
78         uint amountOutMin,
79         address[] calldata path,
80         address to,
81         uint deadline
82     ) external returns (uint[] memory amounts);
83 
84     function swapTokensForExactTokens(
85         uint amountOut,
86         uint amountInMax,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external returns (uint[] memory amounts);
91 
92     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
93     external
94     payable
95     returns (uint[] memory amounts);
96 
97     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
98     external
99     returns (uint[] memory amounts);
100 
101     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
102     external
103     returns (uint[] memory amounts);
104 
105     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
106     external
107     payable
108     returns (uint[] memory amounts);
109 
110     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
111 
112     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
113 
114     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
115 
116     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
117 
118     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
119 }
120 
121 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
122 
123 pragma solidity >=0.6.2;
124 
125 
126 interface IUniswapV2Router02 is IUniswapV2Router01 {
127     function removeLiquidityETHSupportingFeeOnTransferTokens(
128         address token,
129         uint liquidity,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external returns (uint amountETH);
135 
136     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountETH);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 
154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external payable;
160 
161     function swapExactTokensForETHSupportingFeeOnTransferTokens(
162         uint amountIn,
163         uint amountOutMin,
164         address[] calldata path,
165         address to,
166         uint deadline
167     ) external;
168 }
169 
170 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
171 
172 pragma solidity >=0.5.0;
173 
174 interface IUniswapV2Pair {
175     event Approval(address indexed owner, address indexed spender, uint value);
176     event Transfer(address indexed from, address indexed to, uint value);
177 
178     function name() external pure returns (string memory);
179 
180     function symbol() external pure returns (string memory);
181 
182     function decimals() external pure returns (uint8);
183 
184     function totalSupply() external view returns (uint);
185 
186     function balanceOf(address owner) external view returns (uint);
187 
188     function allowance(address owner, address spender) external view returns (uint);
189 
190     function approve(address spender, uint value) external returns (bool);
191 
192     function transfer(address to, uint value) external returns (bool);
193 
194     function transferFrom(address from, address to, uint value) external returns (bool);
195 
196     function DOMAIN_SEPARATOR() external view returns (bytes32);
197 
198     function PERMIT_TYPEHASH() external pure returns (bytes32);
199 
200     function nonces(address owner) external view returns (uint);
201 
202     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
203 
204     event Mint(address indexed sender, uint amount0, uint amount1);
205     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
206     event Swap(
207         address indexed sender,
208         uint amount0In,
209         uint amount1In,
210         uint amount0Out,
211         uint amount1Out,
212         address indexed to
213     );
214     event Sync(uint112 reserve0, uint112 reserve1);
215 
216     function MINIMUM_LIQUIDITY() external pure returns (uint);
217 
218     function factory() external view returns (address);
219 
220     function token0() external view returns (address);
221 
222     function token1() external view returns (address);
223 
224     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
225 
226     function price0CumulativeLast() external view returns (uint);
227 
228     function price1CumulativeLast() external view returns (uint);
229 
230     function kLast() external view returns (uint);
231 
232     function mint(address to) external returns (uint liquidity);
233 
234     function burn(address to) external returns (uint amount0, uint amount1);
235 
236     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
237 
238     function skim(address to) external;
239 
240     function sync() external;
241 
242     function initialize(address, address) external;
243 }
244 
245 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
246 
247 pragma solidity >=0.5.0;
248 
249 interface IUniswapV2Factory {
250     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
251 
252     function feeTo() external view returns (address);
253 
254     function feeToSetter() external view returns (address);
255 
256     function getPair(address tokenA, address tokenB) external view returns (address pair);
257 
258     function allPairs(uint) external view returns (address pair);
259 
260     function allPairsLength() external view returns (uint);
261 
262     function createPair(address tokenA, address tokenB) external returns (address pair);
263 
264     function setFeeTo(address) external;
265 
266     function setFeeToSetter(address) external;
267 }
268 
269 // File: @openzeppelin/contracts/utils/Context.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/access/Ownable.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 
304 /**
305  * @dev Contract module which provides a basic access control mechanism, where
306  * there is an account (an owner) that can be granted exclusive access to
307  * specific functions.
308  *
309  * By default, the owner account will be the one that deploys the contract. This
310  * can later be changed with {transferOwnership}.
311  *
312  * This module is used through inheritance. It will make available the modifier
313  * `onlyOwner`, which can be applied to your functions to restrict their use to
314  * the owner.
315  */
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev Initializes the contract setting the deployer as the initial owner.
323      */
324     constructor() {
325         _transferOwnership(_msgSender());
326     }
327 
328     /**
329      * @dev Returns the address of the current owner.
330      */
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     /**
336      * @dev Throws if called by any account other than the owner.
337      */
338     modifier onlyOwner() {
339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
340         _;
341     }
342 
343     /**
344      * @dev Leaves the contract without owner. It will not be possible to call
345      * `onlyOwner` functions anymore. Can only be called by the current owner.
346      *
347      * NOTE: Renouncing ownership will leave the contract without an owner,
348      * thereby removing any functionality that is only available to the owner.
349      */
350     function renounceOwnership() public virtual onlyOwner {
351         _transferOwnership(address(0));
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Can only be called by the current owner.
357      */
358     function transferOwnership(address newOwner) public virtual onlyOwner {
359         require(newOwner != address(0), "Ownable: new owner is the zero address");
360         _transferOwnership(newOwner);
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Internal function without access restriction.
366      */
367     function _transferOwnership(address newOwner) internal virtual {
368         address oldOwner = _owner;
369         _owner = newOwner;
370         emit OwnershipTransferred(oldOwner, newOwner);
371     }
372 }
373 
374 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
375 
376 
377 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Interface of the ERC20 standard as defined in the EIP.
383  */
384 interface IERC20 {
385     /**
386      * @dev Returns the amount of tokens in existence.
387      */
388     function totalSupply() external view returns (uint256);
389 
390     /**
391      * @dev Returns the amount of tokens owned by `account`.
392      */
393     function balanceOf(address account) external view returns (uint256);
394 
395     /**
396      * @dev Moves `amount` tokens from the caller's account to `to`.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transfer(address to, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Returns the remaining number of tokens that `spender` will be
406      * allowed to spend on behalf of `owner` through {transferFrom}. This is
407      * zero by default.
408      *
409      * This value changes when {approve} or {transferFrom} are called.
410      */
411     function allowance(address owner, address spender) external view returns (uint256);
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
415      *
416      * Returns a boolean value indicating whether the operation succeeded.
417      *
418      * IMPORTANT: Beware that changing an allowance with this method brings the risk
419      * that someone may use both the old and the new allowance by unfortunate
420      * transaction ordering. One possible solution to mitigate this race
421      * condition is to first reduce the spender's allowance to 0 and set the
422      * desired value afterwards:
423      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address spender, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Moves `amount` tokens from `from` to `to` using the
431      * allowance mechanism. `amount` is then deducted from the caller's
432      * allowance.
433      *
434      * Returns a boolean value indicating whether the operation succeeded.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 amount
442     ) external returns (bool);
443 
444     /**
445      * @dev Emitted when `value` tokens are moved from one account (`from`) to
446      * another (`to`).
447      *
448      * Note that `value` may be zero.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 value);
451 
452     /**
453      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
454      * a call to {approve}. `value` is the new allowance.
455      */
456     event Approval(address indexed owner, address indexed spender, uint256 value);
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Interface for the optional metadata functions from the ERC20 standard.
469  *
470  * _Available since v4.1._
471  */
472 interface IERC20Metadata is IERC20 {
473     /**
474      * @dev Returns the name of the token.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the symbol of the token.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the decimals places of the token.
485      */
486     function decimals() external view returns (uint8);
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 
498 
499 /**
500  * @dev Implementation of the {IERC20} interface.
501  *
502  * This implementation is agnostic to the way tokens are created. This means
503  * that a supply mechanism has to be added in a derived contract using {_mint}.
504  * For a generic mechanism see {ERC20PresetMinterPauser}.
505  *
506  * TIP: For a detailed writeup see our guide
507  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
508  * to implement supply mechanisms].
509  *
510  * We have followed general OpenZeppelin Contracts guidelines: functions revert
511  * instead returning `false` on failure. This behavior is nonetheless
512  * conventional and does not conflict with the expectations of ERC20
513  * applications.
514  *
515  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
516  * This allows applications to reconstruct the allowance for all accounts just
517  * by listening to said events. Other implementations of the EIP may not emit
518  * these events, as it isn't required by the specification.
519  *
520  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
521  * functions have been added to mitigate the well-known issues around setting
522  * allowances. See {IERC20-approve}.
523  */
524 contract ERC20 is Context, IERC20, IERC20Metadata {
525     mapping(address => uint256) private _balances;
526 
527     mapping(address => mapping(address => uint256)) private _allowances;
528 
529     uint256 private _totalSupply;
530 
531     string private _name;
532     string private _symbol;
533 
534     /**
535      * @dev Sets the values for {name} and {symbol}.
536      *
537      * The default value of {decimals} is 18. To select a different value for
538      * {decimals} you should overload it.
539      *
540      * All two of these values are immutable: they can only be set once during
541      * construction.
542      */
543     constructor(string memory name_, string memory symbol_) {
544         _name = name_;
545         _symbol = symbol_;
546     }
547 
548     /**
549      * @dev Returns the name of the token.
550      */
551     function name() public view virtual override returns (string memory) {
552         return _name;
553     }
554 
555     /**
556      * @dev Returns the symbol of the token, usually a shorter version of the
557      * name.
558      */
559     function symbol() public view virtual override returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev Returns the number of decimals used to get its user representation.
565      * For example, if `decimals` equals `2`, a balance of `505` tokens should
566      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
567      *
568      * Tokens usually opt for a value of 18, imitating the relationship between
569      * Ether and Wei. This is the value {ERC20} uses, unless this function is
570      * overridden;
571      *
572      * NOTE: This information is only used for _display_ purposes: it in
573      * no way affects any of the arithmetic of the contract, including
574      * {IERC20-balanceOf} and {IERC20-transfer}.
575      */
576     function decimals() public view virtual override returns (uint8) {
577         return 18;
578     }
579 
580     /**
581      * @dev See {IERC20-totalSupply}.
582      */
583     function totalSupply() public view virtual override returns (uint256) {
584         return _totalSupply;
585     }
586 
587     /**
588      * @dev See {IERC20-balanceOf}.
589      */
590     function balanceOf(address account) public view virtual override returns (uint256) {
591         return _balances[account];
592     }
593 
594     /**
595      * @dev See {IERC20-transfer}.
596      *
597      * Requirements:
598      *
599      * - `to` cannot be the zero address.
600      * - the caller must have a balance of at least `amount`.
601      */
602     function transfer(address to, uint256 amount) public virtual override returns (bool) {
603         address owner = _msgSender();
604         _transfer(owner, to, amount);
605         return true;
606     }
607 
608     /**
609      * @dev See {IERC20-allowance}.
610      */
611     function allowance(address owner, address spender) public view virtual override returns (uint256) {
612         return _allowances[owner][spender];
613     }
614 
615     /**
616      * @dev See {IERC20-approve}.
617      *
618      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
619      * `transferFrom`. This is semantically equivalent to an infinite approval.
620      *
621      * Requirements:
622      *
623      * - `spender` cannot be the zero address.
624      */
625     function approve(address spender, uint256 amount) public virtual override returns (bool) {
626         address owner = _msgSender();
627         _approve(owner, spender, amount);
628         return true;
629     }
630 
631     /**
632      * @dev See {IERC20-transferFrom}.
633      *
634      * Emits an {Approval} event indicating the updated allowance. This is not
635      * required by the EIP. See the note at the beginning of {ERC20}.
636      *
637      * NOTE: Does not update the allowance if the current allowance
638      * is the maximum `uint256`.
639      *
640      * Requirements:
641      *
642      * - `from` and `to` cannot be the zero address.
643      * - `from` must have a balance of at least `amount`.
644      * - the caller must have allowance for ``from``'s tokens of at least
645      * `amount`.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 amount
651     ) public virtual override returns (bool) {
652         address spender = _msgSender();
653         _spendAllowance(from, spender, amount);
654         _transfer(from, to, amount);
655         return true;
656     }
657 
658     /**
659      * @dev Atomically increases the allowance granted to `spender` by the caller.
660      *
661      * This is an alternative to {approve} that can be used as a mitigation for
662      * problems described in {IERC20-approve}.
663      *
664      * Emits an {Approval} event indicating the updated allowance.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      */
670     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
671         address owner = _msgSender();
672         _approve(owner, spender, _allowances[owner][spender] + addedValue);
673         return true;
674     }
675 
676     /**
677      * @dev Atomically decreases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      * - `spender` must have allowance for the caller of at least
688      * `subtractedValue`.
689      */
690     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
691         address owner = _msgSender();
692         uint256 currentAllowance = _allowances[owner][spender];
693         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
694     unchecked {
695         _approve(owner, spender, currentAllowance - subtractedValue);
696     }
697 
698         return true;
699     }
700 
701     /**
702      * @dev Moves `amount` of tokens from `sender` to `recipient`.
703      *
704      * This internal function is equivalent to {transfer}, and can be used to
705      * e.g. implement automatic token fees, slashing mechanisms, etc.
706      *
707      * Emits a {Transfer} event.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `from` must have a balance of at least `amount`.
714      */
715     function _transfer(
716         address from,
717         address to,
718         uint256 amount
719     ) internal virtual {
720         require(from != address(0), "ERC20: transfer from the zero address");
721         require(to != address(0), "ERC20: transfer to the zero address");
722 
723         _beforeTokenTransfer(from, to, amount);
724 
725         uint256 fromBalance = _balances[from];
726         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
727     unchecked {
728         _balances[from] = fromBalance - amount;
729     }
730         _balances[to] += amount;
731 
732         emit Transfer(from, to, amount);
733 
734         _afterTokenTransfer(from, to, amount);
735     }
736 
737     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
738      * the total supply.
739      *
740      * Emits a {Transfer} event with `from` set to the zero address.
741      *
742      * Requirements:
743      *
744      * - `account` cannot be the zero address.
745      */
746     function _mint(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: mint to the zero address");
748 
749         _beforeTokenTransfer(address(0), account, amount);
750 
751         _totalSupply += amount;
752         _balances[account] += amount;
753         emit Transfer(address(0), account, amount);
754 
755         _afterTokenTransfer(address(0), account, amount);
756     }
757 
758     /**
759      * @dev Destroys `amount` tokens from `account`, reducing the
760      * total supply.
761      *
762      * Emits a {Transfer} event with `to` set to the zero address.
763      *
764      * Requirements:
765      *
766      * - `account` cannot be the zero address.
767      * - `account` must have at least `amount` tokens.
768      */
769     function _burn(address account, uint256 amount) internal virtual {
770         require(account != address(0), "ERC20: burn from the zero address");
771 
772         _beforeTokenTransfer(account, address(0), amount);
773 
774         uint256 accountBalance = _balances[account];
775         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
776     unchecked {
777         _balances[account] = accountBalance - amount;
778     }
779         _totalSupply -= amount;
780 
781         emit Transfer(account, address(0), amount);
782 
783         _afterTokenTransfer(account, address(0), amount);
784     }
785 
786     /**
787      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
788      *
789      * This internal function is equivalent to `approve`, and can be used to
790      * e.g. set automatic allowances for certain subsystems, etc.
791      *
792      * Emits an {Approval} event.
793      *
794      * Requirements:
795      *
796      * - `owner` cannot be the zero address.
797      * - `spender` cannot be the zero address.
798      */
799     function _approve(
800         address owner,
801         address spender,
802         uint256 amount
803     ) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
813      *
814      * Does not update the allowance amount in case of infinite allowance.
815      * Revert if not enough allowance is available.
816      *
817      * Might emit an {Approval} event.
818      */
819     function _spendAllowance(
820         address owner,
821         address spender,
822         uint256 amount
823     ) internal virtual {
824         uint256 currentAllowance = allowance(owner, spender);
825         if (currentAllowance != type(uint256).max) {
826             require(currentAllowance >= amount, "ERC20: insufficient allowance");
827         unchecked {
828             _approve(owner, spender, currentAllowance - amount);
829         }
830         }
831     }
832 
833     /**
834      * @dev Hook that is called before any transfer of tokens. This includes
835      * minting and burning.
836      *
837      * Calling conditions:
838      *
839      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
840      * will be transferred to `to`.
841      * - when `from` is zero, `amount` tokens will be minted for `to`.
842      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
843      * - `from` and `to` are never both zero.
844      *
845      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
846      */
847     function _beforeTokenTransfer(
848         address from,
849         address to,
850         uint256 amount
851     ) internal virtual {}
852 
853     /**
854      * @dev Hook that is called after any transfer of tokens. This includes
855      * minting and burning.
856      *
857      * Calling conditions:
858      *
859      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
860      * has been transferred to `to`.
861      * - when `from` is zero, `amount` tokens have been minted for `to`.
862      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
863      * - `from` and `to` are never both zero.
864      *
865      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
866      */
867     function _afterTokenTransfer(
868         address from,
869         address to,
870         uint256 amount
871     ) internal virtual {}
872 }
873 
874 // File: contracts/AJINU.sol
875 
876 
877 pragma solidity ^0.8.0;
878 
879 contract AJINU is ERC20, Ownable {
880 
881     modifier lockSwap {
882         _inSwap = true;
883         _;
884         _inSwap = false;
885     }
886 
887     modifier liquidityAdd {
888         _inLiquidityAdd = true;
889         _;
890         _inLiquidityAdd = false;
891     }
892 
893     uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
894 
895     // _maxTransfer set to 10 means the max transfer is 0.10% of the total supply
896     uint256 internal _maxTransfer = 10;
897     bool internal _isMaxBuyTransferEnabled = true;
898     uint256 internal _taxReliefInterval = 7 days;
899     uint256 public treasuryRate = 15;
900     uint256 public reflectRate = 15;
901     uint256 public cooldownPeriod = 1 days;
902     /// @notice Contract AJINU balance threshold before `_swap` is invoked
903     uint256 public minTokenBalance = 1000000 ether;
904     bool public swapFees = true;
905 
906     // total wei reflected ever
907     uint256 public ethReflectionBasis;
908     uint256 public totalReflected;
909     uint256 public totalTreasury;
910 
911     address payable public treasuryWallet;
912 
913     uint256 internal _totalSupply = 0;
914     IUniswapV2Router02 internal _router = IUniswapV2Router02(address(0));
915     address internal _pair;
916     bool internal _inSwap = false;
917     bool internal _inLiquidityAdd = false;
918     bool public tradingActive = false;
919 
920     mapping(address => uint256) private _balances;
921     mapping(address => bool) private _taxExcluded;
922     mapping(address => uint256) public lastReflectionBasis;
923     mapping(address => uint256) public cooldownExpiresAt;
924     mapping(address => uint256) public taxReliefStartDate;
925 
926     constructor(
927         address _uniswapFactory,
928         address _uniswapRouter,
929         address payable _treasuryWallet
930     ) ERC20("AntiJeet Inu", "AJINU") Ownable() {
931         addTaxExcluded(owner());
932         addTaxExcluded(address(0));
933         addTaxExcluded(_treasuryWallet);
934         addTaxExcluded(address(this));
935 
936         treasuryWallet = _treasuryWallet;
937 
938         _router = IUniswapV2Router02(_uniswapRouter);
939         IUniswapV2Factory uniswapContract = IUniswapV2Factory(_uniswapFactory);
940         _pair = uniswapContract.createPair(address(this), _router.WETH());
941     }
942 
943     /// @notice Change the address of the treasury wallet
944     /// @param _treasuryWallet The new address of the treasury wallet
945     function setTreasuryWallet(address payable _treasuryWallet) external onlyOwner() {
946         treasuryWallet = _treasuryWallet;
947     }
948 
949     /// @notice Change the treasury tax rate
950     /// @param _treasuryRate The new treasury tax rate
951     function setTreasuryRate(uint256 _treasuryRate) external onlyOwner() {
952         require(_treasuryRate <= 100, "_treasuryRate cannot exceed 100%");
953         treasuryRate = _treasuryRate;
954     }
955 
956     /// @notice Change the reflection tax rate
957     /// @param _reflectRate The new reflection tax rate
958     function setReflectRate(uint256 _reflectRate) external onlyOwner() {
959         require(_reflectRate <= 100, "_reflectRate cannot exceed 100%");
960         reflectRate = _reflectRate;
961     }
962 
963     /// @notice Change the minimum contract AJINU balance before `_swap` gets invoked
964     /// @param _minTokenBalance The new minimum balance
965     function setMinTokenBalance(uint256 _minTokenBalance) external onlyOwner() {
966         minTokenBalance = _minTokenBalance;
967     }
968 
969     /// @notice Change the cooldown period
970     /// @param _cooldownPeriod The new cooldown period
971     function setCooldownPeriod(uint256 _cooldownPeriod) external onlyOwner() {
972         require(_cooldownPeriod <= 1 days && _cooldownPeriod > 0, "_cooldownPeriod must be less than 1 day");
973         cooldownPeriod = _cooldownPeriod;
974     }
975 
976     /// @notice Rescue AJINU from the treasury amount
977     /// @dev Should only be used in an emergency
978     /// @param _amount The amount of AJINU to rescue
979     /// @param _recipient The recipient of the rescued AJINU
980     function rescueTreasuryTokens(uint256 _amount, address _recipient) external onlyOwner() {
981         require(_amount <= totalTreasury, "Amount cannot be greater than totalTreasury");
982         _rawTransfer(address(this), _recipient, _amount);
983         totalTreasury -= _amount;
984     }
985 
986     /// @notice Rescue AJINU from the reflection amount
987     /// @dev Should only be used in an emergency
988     /// @param _amount The amount of AJINU to rescue
989     /// @param _recipient The recipient of the rescued AJINU
990     function rescueReflectionTokens(uint256 _amount, address _recipient) external onlyOwner() {
991         require(_amount <= totalReflected, "Amount cannot be greater than totalReflected");
992         _rawTransfer(address(this), _recipient, _amount);
993         totalReflected -= _amount;
994     }
995 
996     function addLiquidity(uint256 tokens) external payable onlyOwner() liquidityAdd {
997         _mint(address(this), tokens);
998         _approve(address(this), address(_router), tokens);
999 
1000         _router.addLiquidityETH{value : msg.value}(
1001             address(this),
1002             tokens,
1003             0,
1004             0,
1005             owner(),
1006         // solhint-disable-next-line not-rely-on-time
1007             block.timestamp
1008         );
1009     }
1010 
1011     /// @notice Enables trading on Uniswap
1012     function enableTrading() external onlyOwner {
1013         tradingActive = true;
1014     }
1015 
1016     /// @notice Disables trading on Uniswap
1017     function disableTrading() external onlyOwner {
1018         tradingActive = false;
1019     }
1020 
1021     function addReflection() external payable {
1022         ethReflectionBasis += msg.value;
1023     }
1024 
1025     function isTaxExcluded(address account) public view returns (bool) {
1026         return _taxExcluded[account];
1027     }
1028 
1029     function addTaxExcluded(address account) public onlyOwner() {
1030         require(!isTaxExcluded(account), "Account must not be excluded");
1031 
1032         _taxExcluded[account] = true;
1033     }
1034 
1035     function removeTaxExcluded(address account) external onlyOwner() {
1036         require(isTaxExcluded(account), "Account must not be excluded");
1037 
1038         _taxExcluded[account] = false;
1039     }
1040 
1041     function balanceOf(address account)
1042     public
1043     view
1044     virtual
1045     override
1046     returns (uint256)
1047     {
1048         return _balances[account];
1049     }
1050 
1051     function _addBalance(address account, uint256 amount) internal {
1052         _balances[account] = _balances[account] + amount;
1053     }
1054 
1055     function _subtractBalance(address account, uint256 amount) internal {
1056         _balances[account] = _balances[account] - amount;
1057     }
1058 
1059     function _transfer(
1060         address sender,
1061         address recipient,
1062         uint256 amount
1063     ) internal override {
1064         if (isTaxExcluded(sender) || isTaxExcluded(recipient)) {
1065             _rawTransfer(sender, recipient, amount);
1066             return;
1067         }
1068 
1069         uint256 maxTxAmount = totalSupply() * _maxTransfer / 10000;
1070 
1071         if(_isMaxBuyTransferEnabled && sender == _pair) {
1072             require(amount <= maxTxAmount);
1073         }
1074 
1075         require(amount <= maxTxAmount || sender == _pair || _inLiquidityAdd || _inSwap || recipient == address(_router), "Exceeds max transaction amount");
1076 
1077         uint256 contractTokenBalance = balanceOf(address(this));
1078         bool overMinTokenBalance = contractTokenBalance >= minTokenBalance;
1079 
1080         if (contractTokenBalance >= maxTxAmount) {
1081             contractTokenBalance = maxTxAmount;
1082         }
1083 
1084         if (
1085             overMinTokenBalance &&
1086             !_inSwap &&
1087             sender != _pair &&
1088             swapFees
1089         ) {
1090             _swap(contractTokenBalance);
1091         }
1092 
1093         _claimReflection(payable(sender));
1094         _claimReflection(payable(recipient));
1095 
1096         uint256 send = amount;
1097         uint256 reflect;
1098         uint256 treasury;
1099         if (sender == _pair || recipient == _pair) {
1100             require(tradingActive, "Trading is not yet active");
1101             uint256 userTaxReliefStartDate = getTaxReliefStartDate(recipient);
1102             if (sender == _pair && userTaxReliefStartDate == 0) {
1103                 taxReliefStartDate[recipient] = block.timestamp;
1104             }
1105             if (recipient == _pair) {
1106                 // sell
1107                 require(block.timestamp >= getCooldownExpiration(sender));
1108                 (
1109                 send,
1110                 reflect,
1111                 treasury
1112                 ) = _getTaxAmounts(amount, getUserTaxRelief(sender));
1113 
1114                 // set cooldown period
1115                 cooldownExpiresAt[sender] = block.timestamp + cooldownPeriod;
1116                 // reset taxReliefStartDate
1117                 if (balanceOf(sender) - amount < 1 ether) {
1118                     taxReliefStartDate[sender] = 0;
1119                 }
1120 
1121                 _takeTaxes(sender, treasury, reflect);
1122             }
1123         }
1124         _rawTransfer(sender, recipient, send);
1125     }
1126 
1127     function getCooldownExpiration(address addr) public view returns (uint256) {
1128         return cooldownExpiresAt[addr];
1129     }
1130 
1131     function getTaxReliefStartDate(address addr) public view returns (uint256) {
1132         return taxReliefStartDate[addr];
1133     }
1134 
1135     function getUserTaxRelief(address addr) public view returns (uint8) {
1136         uint256 userTaxReliefStartDate = getTaxReliefStartDate(addr);
1137 
1138         // get tax relief
1139         uint8 taxReliefInterval = 0;
1140 
1141         if(userTaxReliefStartDate > 0) {
1142             // calculate the difference in weeks between the current time vs when the users tax relief starts
1143             uint256 taxReliefDateDifference = (block.timestamp - userTaxReliefStartDate) / _taxReliefInterval;
1144             if(taxReliefDateDifference > 4) {
1145                 taxReliefInterval = 4;
1146             } else {
1147                 taxReliefInterval = uint8(taxReliefDateDifference);
1148             }
1149         }
1150 
1151         return taxReliefInterval;
1152     }
1153 
1154     function unclaimedReflection(address addr) public view returns (uint256) {
1155         if (addr == _pair || addr == address(_router)) return 0;
1156 
1157         uint256 basisDifference = ethReflectionBasis - lastReflectionBasis[addr];
1158         return basisDifference * balanceOf(addr) / _totalSupply;
1159     }
1160 
1161     /// @notice Claims reflection pool ETH
1162     /// @param addr The address to claim the reflection for
1163     function _claimReflection(address payable addr) internal {
1164         uint256 unclaimed = unclaimedReflection(addr);
1165         lastReflectionBasis[addr] = ethReflectionBasis;
1166         if (unclaimed > 0) {
1167             addr.transfer(unclaimed);
1168         }
1169     }
1170 
1171     function claimReflection() external {
1172         _claimReflection(payable(msg.sender));
1173     }
1174 
1175     /// @notice Perform a Uniswap v2 swap from AJINU to ETH and handle tax distribution
1176     /// @param amount The amount of AJINU to swap in wei
1177     /// @dev `amount` is always <= this contract's ETH balance. Calculate and distribute treasury and reflection taxes
1178     function _swap(uint256 amount) internal lockSwap {
1179         address[] memory path = new address[](2);
1180         path[0] = address(this);
1181         path[1] = _router.WETH();
1182 
1183         _approve(address(this), address(_router), amount);
1184 
1185         uint256 contractEthBalance = address(this).balance;
1186 
1187         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1188             amount,
1189             0,
1190             path,
1191             address(this),
1192             block.timestamp
1193         );
1194 
1195         uint256 tradeValue = address(this).balance - contractEthBalance;
1196 
1197         uint256 totalTaxes = totalTreasury + totalReflected;
1198         uint256 treasuryAmount = amount * totalTreasury / totalTaxes;
1199         uint256 reflectedAmount = amount - treasuryAmount;
1200 
1201         uint256 treasuryEth = tradeValue * totalTreasury / totalTaxes;
1202         uint256 reflectedEth = tradeValue - treasuryEth;
1203 
1204         if (treasuryEth > 0) {
1205             treasuryWallet.transfer(treasuryEth);
1206         }
1207         totalTreasury = totalTreasury - treasuryAmount;
1208         totalReflected = totalReflected - reflectedAmount;
1209         ethReflectionBasis = ethReflectionBasis + reflectedEth;
1210     }
1211 
1212     function swapAll() external onlyOwner() {
1213         uint256 maxTxAmount = totalSupply() * _maxTransfer / 10000;
1214         uint256 contractTokenBalance = balanceOf(address(this));
1215 
1216         if (contractTokenBalance >= maxTxAmount)
1217         {
1218             contractTokenBalance = maxTxAmount;
1219         }
1220 
1221         if (
1222             !_inSwap
1223         ) {
1224             _swap(contractTokenBalance);
1225         }
1226     }
1227 
1228     function withdrawAll() external onlyOwner() {
1229         payable(owner()).transfer(address(this).balance);
1230     }
1231 
1232     /// @notice Transfers AJINU from an account to this contract for taxes
1233     /// @param _account The account to transfer AJINU from
1234     /// @param _treasuryAmount The amount of treasury tax to transfer
1235     /// @param _reflectAmount The amount of reflection tax to transfer
1236     function _takeTaxes(
1237         address _account,
1238         uint256 _treasuryAmount,
1239         uint256 _reflectAmount
1240     ) internal {
1241         require(_account != address(0), "taxation from the zero address");
1242 
1243         uint256 totalAmount = _treasuryAmount + _reflectAmount;
1244         _rawTransfer(_account, address(this), totalAmount);
1245         totalTreasury += _treasuryAmount;
1246         totalReflected += _reflectAmount;
1247     }
1248 
1249     /// @notice Get a breakdown of send and tax amounts
1250     /// @param amount The amount to tax in wei
1251     /// @return send The raw amount to send
1252     /// @return reflect The raw reflection tax amount
1253     /// @return treasury The raw treasury tax amount
1254     function _getTaxAmounts(uint256 amount, uint8 taxReliefInterval)
1255     internal
1256     view
1257     returns (
1258         uint256 send,
1259         uint256 reflect,
1260         uint256 treasury
1261     )
1262     {
1263         uint256 taxRelief = 1000;
1264 
1265         if(taxReliefInterval == 1) {
1266             taxRelief = 833;
1267         } else if (taxReliefInterval == 2) {
1268             taxRelief = 666;
1269         } else if (taxReliefInterval == 3) {
1270             taxRelief = 500;
1271         } else if (taxReliefInterval == 4) {
1272             taxRelief = 333;
1273         }
1274 
1275         reflect = amount * reflectRate * taxRelief / 100000;
1276         treasury = amount * treasuryRate * taxRelief / 100000;
1277         send = amount - reflect - treasury;
1278     }
1279 
1280     // modified from OpenZeppelin ERC20
1281     function _rawTransfer(
1282         address sender,
1283         address recipient,
1284         uint256 amount
1285     ) internal {
1286         require(sender != address(0), "transfer from the zero address");
1287         require(recipient != address(0), "transfer to the zero address");
1288 
1289         uint256 senderBalance = balanceOf(sender);
1290         require(senderBalance >= amount, "transfer amount exceeds balance");
1291     unchecked {
1292         _subtractBalance(sender, amount);
1293     }
1294         _addBalance(recipient, amount);
1295 
1296         emit Transfer(sender, recipient, amount);
1297     }
1298 
1299     function setMaxTransfer(uint256 maxTransfer) external onlyOwner() {
1300         require(maxTransfer < 2000, "Cannot set max transfer above 20 percent");
1301         _maxTransfer = maxTransfer;
1302     }
1303 
1304     function setIsMaxBuyTransferEnabled(bool isMaxBuyTransferEnabled) external onlyOwner() {
1305         _isMaxBuyTransferEnabled = isMaxBuyTransferEnabled;
1306     }
1307 
1308     /// @notice Enable or disable whether swap occurs during `_transfer`
1309     /// @param _swapFees If true, enables swap during `_transfer`
1310     function setSwapFees(bool _swapFees) external onlyOwner() {
1311         swapFees = _swapFees;
1312     }
1313 
1314     function totalSupply() public view override returns (uint256) {
1315         return _totalSupply;
1316     }
1317 
1318     function _mint(address account, uint256 amount) internal override {
1319         require(_totalSupply + amount <= MAX_SUPPLY, "Max supply exceeded");
1320         _totalSupply += amount;
1321         _addBalance(account, amount);
1322         emit Transfer(address(0), account, amount);
1323     }
1324 
1325     function mint(address account, uint256 amount) external onlyOwner() {
1326         _mint(account, amount);
1327     }
1328 
1329     function airdrop(address[] memory accounts, uint256[] memory amounts) external onlyOwner() {
1330         require(accounts.length == amounts.length, "array lengths must match");
1331 
1332         for (uint256 i = 0; i < accounts.length; i++) {
1333             _mint(accounts[i], amounts[i]);
1334         }
1335     }
1336 
1337     receive() external payable {}
1338 }