1 /**
2 
3 Hasten slowly and ye shall soon arrive     
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.20;
10 
11 /**
12  * @dev Interface of the BEP20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 /**
84  * @dev Interface for the optional metadata functions from the BEP20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 /*
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 /**
125  * @dev Contract module which provides a basic access control mechanism, where
126  * there is an account (an owner) that can be granted exclusive access to
127  * specific functions.
128  *
129  * By default, the owner account will be the one that deploys the contract. This
130  * can later be changed with {transferOwnership}.
131  *
132  * This module is used through inheritance. It will make available the modifier
133  * `onlyOwner`, which can be applied to your functions to restrict their use to
134  * the owner.
135  */
136 abstract contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view virtual returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164 
165     /**
166      * @dev Leaves the contract without owner. It will not be possible to call
167      * `onlyOwner` functions anymore. Can only be called by the current owner.
168      *
169      * NOTE: Renouncing ownership will leave the contract without an owner,
170      * thereby removing any functionality that is only available to the owner.
171      */
172     function renounceOwnership() public virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 }
187 
188 /**
189  * @dev Implementation of the {IERC20} interface.
190  *
191  * This implementation is agnostic to the way tokens are created. This means
192  * that a supply mechanism has to be added in a derived contract using {_mint}.
193  * For a generic mechanism see {ERC20PresetMinterPauser}.
194  *
195  * TIP: For a detailed writeup see our guide
196  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
197  * to implement supply mechanisms].
198  *
199  * We have followed general OpenZeppelin guidelines: functions revert instead
200  * of returning `false` on failure. This behavior is nonetheless conventional
201  * and does not conflict with the expectations of ERC20 applications.
202  *
203  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
204  * This allows applications to reconstruct the allowance for all accounts just
205  * by listening to said events. Other implementations of the EIP may not emit
206  * these events, as it isn't required by the specification.
207  *
208  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
209  * functions have been added to mitigate the well-known issues around setting
210  * allowances. See {IERC20-approve}.
211  */
212 
213  interface IUniswapV2Factory {
214     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
215 
216     function feeTo() external view returns (address);
217     function feeToSetter() external view returns (address);
218 
219     function getPair(address tokenA, address tokenB) external view returns (address pair);
220     function allPairs(uint) external view returns (address pair);
221     function allPairsLength() external view returns (uint);
222 
223     function createPair(address tokenA, address tokenB) external returns (address pair);
224 
225     function setFeeTo(address) external;
226     function setFeeToSetter(address) external;
227 }
228 
229 interface IUniswapV2Pair {
230     event Approval(address indexed owner, address indexed spender, uint value);
231     event Transfer(address indexed from, address indexed to, uint value);
232 
233     function name() external pure returns (string memory);
234     function symbol() external pure returns (string memory);
235     function decimals() external pure returns (uint8);
236     function totalSupply() external view returns (uint);
237     function balanceOf(address owner) external view returns (uint);
238     function allowance(address owner, address spender) external view returns (uint);
239 
240     function approve(address spender, uint value) external returns (bool);
241     function transfer(address to, uint value) external returns (bool);
242     function transferFrom(address from, address to, uint value) external returns (bool);
243 
244     function DOMAIN_SEPARATOR() external view returns (bytes32);
245     function PERMIT_TYPEHASH() external pure returns (bytes32);
246     function nonces(address owner) external view returns (uint);
247 
248     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
249 
250     event Mint(address indexed sender, uint amount0, uint amount1);
251     event Swap(
252         address indexed sender,
253         uint amount0In,
254         uint amount1In,
255         uint amount0Out,
256         uint amount1Out,
257         address indexed to
258     );
259     event Sync(uint112 reserve0, uint112 reserve1);
260 
261     function MINIMUM_LIQUIDITY() external pure returns (uint);
262     function factory() external view returns (address);
263     function token0() external view returns (address);
264     function token1() external view returns (address);
265     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
266     function price0CumulativeLast() external view returns (uint);
267     function price1CumulativeLast() external view returns (uint);
268     function kLast() external view returns (uint);
269 
270     function mint(address to) external returns (uint liquidity);
271     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
272     function skim(address to) external;
273     function sync() external;
274 
275     function initialize(address, address) external;
276 }
277 
278 interface IUniswapV2Router01 {
279     function factory() external pure returns (address);
280     function WETH() external pure returns (address);
281 
282     function addLiquidity(
283         address tokenA,
284         address tokenB,
285         uint amountADesired,
286         uint amountBDesired,
287         uint amountAMin,
288         uint amountBMin,
289         address to,
290         uint deadline
291     ) external returns (uint amountA, uint amountB, uint liquidity);
292     function addLiquidityETH(
293         address token,
294         uint amountTokenDesired,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline
299     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
300     function removeLiquidity(
301         address tokenA,
302         address tokenB,
303         uint liquidity,
304         uint amountAMin,
305         uint amountBMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountA, uint amountB);
309     function removeLiquidityETH(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline
316     ) external returns (uint amountToken, uint amountETH);
317     function removeLiquidityWithPermit(
318         address tokenA,
319         address tokenB,
320         uint liquidity,
321         uint amountAMin,
322         uint amountBMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns (uint amountA, uint amountB);
327     function removeLiquidityETHWithPermit(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountToken, uint amountETH);
336     function swapExactTokensForTokens(
337         uint amountIn,
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external returns (uint[] memory amounts);
343     function swapTokensForExactTokens(
344         uint amountOut,
345         uint amountInMax,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external returns (uint[] memory amounts);
350     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
351         external
352         payable
353         returns (uint[] memory amounts);
354     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
355         external
356         returns (uint[] memory amounts);
357     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
358         external
359         returns (uint[] memory amounts);
360     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
361         external
362         payable
363         returns (uint[] memory amounts);
364 
365     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
366     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
367     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
368     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
369     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
370 }
371 
372 interface IUniswapV2Router02 is IUniswapV2Router01 {
373     function removeLiquidityETHSupportingFeeOnTransferTokens(
374         address token,
375         uint liquidity,
376         uint amountTokenMin,
377         uint amountETHMin,
378         address to,
379         uint deadline
380     ) external returns (uint amountETH);
381     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
382         address token,
383         uint liquidity,
384         uint amountTokenMin,
385         uint amountETHMin,
386         address to,
387         uint deadline,
388         bool approveMax, uint8 v, bytes32 r, bytes32 s
389     ) external returns (uint amountETH);
390 
391     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
392         uint amountIn,
393         uint amountOutMin,
394         address[] calldata path,
395         address to,
396         uint deadline
397     ) external;
398     function swapExactETHForTokensSupportingFeeOnTransferTokens(
399         uint amountOutMin,
400         address[] calldata path,
401         address to,
402         uint deadline
403     ) external payable;
404     function swapExactTokensForETHSupportingFeeOnTransferTokens(
405         uint amountIn,
406         uint amountOutMin,
407         address[] calldata path,
408         address to,
409         uint deadline
410     ) external;
411 }
412 
413 contract Ravensgrave is Context, IERC20, IERC20Metadata, Ownable{
414     mapping (address => uint256) private _balances;
415 
416     mapping (address => mapping (address => uint256)) private _allowances;
417 
418 
419     uint256 private _totalSupply;
420     uint256 public maxWalletAmount;
421 
422     event UpdatedMaxWalletAmount(uint256 newAmount);
423     bool public tradingActive = false;
424     event EnabledTrading();
425 
426     string private _name;
427     string private _symbol;
428 
429     /**
430      * @dev Sets the values for {name} and {symbol}.
431      *
432      * The defaut value of {decimals} is 18. To select a different value for
433      * {decimals} you should overload it.
434      *
435      * All two of these values are immutable: they can only be set once during
436      * construction.
437      */
438 
439      IUniswapV2Router02 public immutable uniswapV2Router;
440     address public immutable uniswapV2Pair;
441 
442 
443     constructor () {
444         _name = "Ravens";
445         _symbol = "Grave";
446          _mint(msg.sender, 100000000000  * 10 ** (decimals()));
447           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
448          // Create a uniswap pair for this new token
449         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
450             .createPair(address(this), _uniswapV2Router.WETH());
451 
452         // set the rest of the contract variables
453         uniswapV2Router = _uniswapV2Router;
454 
455 
456         maxWalletAmount = 2000000001  * 10 ** (decimals());
457     }
458     
459     /**
460      * @dev Returns the name of the token.
461      */
462     function name() public view virtual override returns (string memory) {
463         return _name;
464     }
465 
466     /**
467      * @dev Returns the symbol of the token, usually a shorter version of the
468      * name.
469      */
470     function symbol() public view virtual override returns (string memory) {
471         return _symbol;
472     }
473 
474     /**
475      * @dev Returns the number of decimals used to get its user representation.
476      * For example, if `decimals` equals `2`, a balance of `505` tokens should
477      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
478      *
479      * Tokens usually opt for a value of 18, imitating the relationship between
480      * Ether and Wei. This is the value {ERC20} uses, unless this function is
481      * overridden;
482      *
483      * NOTE: This information is only used for _display_ purposes: it in
484      * no way affects any of the arithmetic of the contract, including
485      * {IERC20-balanceOf} and {IERC20-transfer}.
486      */
487     function decimals() public view virtual override returns (uint8) {
488         return 18;
489     }
490 
491     /**
492      * @dev See {IERC20-totalSupply}.
493      */
494     function totalSupply() public view virtual override returns (uint256) {
495         return _totalSupply;
496     }
497 
498     /**
499      * @dev See {IERC20-balanceOf}.
500      */
501     function balanceOf(address account) public view virtual override returns (uint256) {
502         return _balances[account];
503     }
504 
505     /**
506      * @dev See {IERC20-transfer}.
507      *
508      * Requirements:
509      *
510      * - `recipient` cannot be the zero address.
511      * - the caller must have a balance of at least `amount`.
512      */
513     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-allowance}.
520      */
521     function allowance(address owner, address spender) public view virtual override returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     /**
526      * @dev See {IERC20-approve}.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function approve(address spender, uint256 amount) public virtual override returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-transferFrom}.
539      *
540      * Emits an {Approval} event indicating the updated allowance. This is not
541      * required by the EIP. See the note at the beginning of {BEP20}.
542      *
543      * Requirements:
544      *
545      * - `sender` and `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      * - the caller must have allowance for ``sender``'s tokens of at least
548      * `amount`.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(sender, recipient, amount);
552 
553         uint256 currentAllowance = _allowances[sender][_msgSender()];
554         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
555         _approve(sender, _msgSender(), currentAllowance - amount);
556 
557         return true;
558     }
559 
560     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
561         require(newNum >= (totalSupply() * 25 / 10000)/1e18, "Cannot set maxWallet lower than 0.25%");
562         maxWalletAmount = newNum * (10**18);
563         emit UpdatedMaxWalletAmount(maxWalletAmount);
564     }
565 
566      /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         uint256 currentAllowance = _allowances[_msgSender()][spender];
599         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
600         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
601 
602         return true;
603     }
604 
605     /**
606      * @dev Moves tokens `amount` from `sender` to `recipient`.
607      *
608      * This is internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
620         require(sender != address(0), "BEP2020: transfer from the zero address");
621         require(recipient != address(0), "BEP20: transfer to the zero address");
622         if(!tradingActive){
623         require(sender == owner() || recipient == owner(), "Trading is not active.");
624                 }
625 
626         
627          if (
628             sender != owner() &&
629             recipient != owner() &&
630             recipient != address(0) &&
631             recipient != address(0xdead) &&
632             recipient != uniswapV2Pair
633         ) {
634 
635             uint256 contractBalanceRecepient = balanceOf(recipient);
636             require(
637                 contractBalanceRecepient + amount <= maxWalletAmount,
638                 "Exceeds maximum wallet token amount."
639             );
640             
641         }
642         _beforeTokenTransfer(sender, recipient, amount);
643 
644         uint256 senderBalance = _balances[sender];
645         require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
646         _balances[sender] = senderBalance - amount;
647         _balances[recipient] += amount;
648 
649         emit Transfer(sender, recipient, amount);
650     }
651 
652     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
653      * the total supply.
654      *
655      * Emits a {Transfer} event with `from` set to the zero address.
656      *
657      * Requirements:
658      *
659      * - `to` cannot be the zero address.
660      */
661     function _mint(address account, uint256 amount) internal virtual {
662         require(account != address(0), "BEP20: mint to the zero address");
663 
664         _beforeTokenTransfer(address(0), account, amount);
665 
666         _totalSupply += amount;
667         _balances[account] += amount;
668         emit Transfer(address(0), account, amount);
669     }
670 
671     /**
672      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
673      *
674      * This internal function is equivalent to `approve`, and can be used to
675      * e.g. set automatic allowances for certain subsystems, etc.
676      *
677      * Emits an {Approval} event.
678      *
679      * Requirements:
680      *
681      * - `owner` cannot be the zero address.
682      * - `spender` cannot be the zero address.
683      */
684     function _approve(address owner, address spender, uint256 amount) internal virtual {
685         require(owner != address(0), "BEP20: approve from the zero address");
686         require(spender != address(0), "BEP20: approve to the zero address");
687 
688         _allowances[owner][spender] = amount;
689         emit Approval(owner, spender, amount);
690     }
691 
692         function enableTrading() external onlyOwner {
693         require(!tradingActive, "Cannot reenable trading");
694         tradingActive = true;
695         emit EnabledTrading();
696     }
697 
698     /**
699      * @dev Hook that is called before any transfer of tokens. This includes
700      * minting.
701      *
702      * Calling conditions:
703      *
704      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
705      * will be to transferred to `to`.
706      * - when `from` is zero, `amount` tokens will be minted for `to`.
707      * - `from` and `to` are never both zero.
708      *
709      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
710      */
711     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
712 }