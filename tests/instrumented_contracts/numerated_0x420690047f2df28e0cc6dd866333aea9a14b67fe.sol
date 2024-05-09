1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-14
3 */
4 
5 // Sources flattened with hardhat v2.7.0 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
36 
37 interface IUniswapV2Factory {
38     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
39     function createPair(address tokenA, address tokenB) external returns (address pair);
40     function setFeeTo(address) external;
41     function setFeeToSetter(address) external;
42     function feeTo() external view returns (address);
43     function feeToSetter() external view returns (address);
44     function getPair(address tokenA, address tokenB) external view returns (address pair);
45     function allPairs(uint256) external view returns (address pair);
46     function allPairsLength() external view returns (uint256);
47 }
48 
49 interface IUniswapV2Pair {
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
53     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
54     event Sync(uint112 reserve0, uint112 reserve1);
55     function approve(address spender, uint256 value) external returns (bool);
56     function transfer(address to, uint256 value) external returns (bool);
57     function transferFrom(address from, address to, uint256 value) external returns (bool);
58     function burn(address to) external returns (uint256 amount0, uint256 amount1);
59     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
60     function skim(address to) external;
61     function sync() external;
62     function initialize(address, address) external;
63     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,bytes32 s) external;
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address owner) external view returns (uint256);
66     function allowance(address owner, address spender) external view returns (uint256);
67     function DOMAIN_SEPARATOR() external view returns (bytes32);
68     function nonces(address owner) external view returns (uint256);
69     function factory() external view returns (address);
70     function token0() external view returns (address);
71     function token1() external view returns (address);
72     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
73     function price0CumulativeLast() external view returns (uint256);
74     function price1CumulativeLast() external view returns (uint256);
75     function kLast() external view returns (uint256);
76     function name() external pure returns (string memory);
77     function symbol() external pure returns (string memory);
78     function decimals() external pure returns (uint8);
79     function PERMIT_TYPEHASH() external pure returns (bytes32);
80     function MINIMUM_LIQUIDITY() external pure returns (uint256);
81 }
82 
83 interface IUniswapV2Router01 {
84     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
85     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
86     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
87     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
88     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);
89     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);
90     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);
91     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);
92     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
93     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
94     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
95     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
96     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
97     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
101     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
102     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
103 }
104 
105 interface IUniswapV2Router02 is IUniswapV2Router01 {
106     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);
107     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
108     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline ) external;
111 }
112 
113 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Contract module which provides a basic access control mechanism, where
119  * there is an account (an owner) that can be granted exclusive access to
120  * specific functions.
121  *
122  * By default, the owner account will be the one that deploys the contract. This
123  * can later be changed with {transferOwnership}.
124  *
125  * This module is used through inheritance. It will make available the modifier
126  * `onlyOwner`, which can be applied to your functions to restrict their use to
127  * the owner.
128  */
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     /**
157      * @dev Leaves the contract without owner. It will not be possible to call
158      * `onlyOwner` functions anymore. Can only be called by the current owner.
159      *
160      * NOTE: Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public virtual onlyOwner {
164         _transferOwnership(address(0));
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Internal function without access restriction.
179      */
180     function _transferOwnership(address newOwner) internal virtual {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 
188 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
189 
190 
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) external returns (bool);
257 
258     /**
259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
260      * another (`to`).
261      *
262      * Note that `value` may be zero.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 value);
265 
266     /**
267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
268      * a call to {approve}. `value` is the new allowance.
269      */
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 
274 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
275 
276 
277 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Interface for the optional metadata functions from the ERC20 standard.
283  *
284  * _Available since v4.1._
285  */
286 interface IERC20Metadata is IERC20 {
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() external view returns (string memory);
291 
292     /**
293      * @dev Returns the symbol of the token.
294      */
295     function symbol() external view returns (string memory);
296 
297     /**
298      * @dev Returns the decimals places of the token.
299      */
300     function decimals() external view returns (uint8);
301 }
302 
303 
304 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
305 
306 
307 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 
312 
313 /**
314  * @dev Implementation of the {IERC20} interface.
315  *
316  * This implementation is agnostic to the way tokens are created. This means
317  * that a supply mechanism has to be added in a derived contract using {_mint}.
318  * For a generic mechanism see {ERC20PresetMinterPauser}.
319  *
320  * TIP: For a detailed writeup see our guide
321  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
322  * to implement supply mechanisms].
323  *
324  * We have followed general OpenZeppelin Contracts guidelines: functions revert
325  * instead returning `false` on failure. This behavior is nonetheless
326  * conventional and does not conflict with the expectations of ERC20
327  * applications.
328  *
329  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
330  * This allows applications to reconstruct the allowance for all accounts just
331  * by listening to said events. Other implementations of the EIP may not emit
332  * these events, as it isn't required by the specification.
333  *
334  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
335  * functions have been added to mitigate the well-known issues around setting
336  * allowances. See {IERC20-approve}.
337  */
338 contract ERC20 is Context, IERC20, IERC20Metadata {
339     mapping(address => uint256) private _balances;
340 
341     mapping(address => mapping(address => uint256)) private _allowances;
342 
343     uint256 private _totalSupply;
344 
345     string private _name;
346     string private _symbol;
347 
348     /**
349      * @dev Sets the values for {name} and {symbol}.
350      *
351      * The default value of {decimals} is 18. To select a different value for
352      * {decimals} you should overload it.
353      *
354      * All two of these values are immutable: they can only be set once during
355      * construction.
356      */
357     constructor(string memory name_, string memory symbol_) {
358         _name = name_;
359         _symbol = symbol_;
360     }
361 
362     /**
363      * @dev Returns the name of the token.
364      */
365     function name() public view virtual override returns (string memory) {
366         return _name;
367     }
368 
369     /**
370      * @dev Returns the symbol of the token, usually a shorter version of the
371      * name.
372      */
373     function symbol() public view virtual override returns (string memory) {
374         return _symbol;
375     }
376 
377     /**
378      * @dev Returns the number of decimals used to get its user representation.
379      * For example, if `decimals` equals `2`, a balance of `505` tokens should
380      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
381      *
382      * Tokens usually opt for a value of 18, imitating the relationship between
383      * Ether and Wei. This is the value {ERC20} uses, unless this function is
384      * overridden;
385      *
386      * NOTE: This information is only used for _display_ purposes: it in
387      * no way affects any of the arithmetic of the contract, including
388      * {IERC20-balanceOf} and {IERC20-transfer}.
389      */
390     function decimals() public view virtual override returns (uint8) {
391         return 18;
392     }
393 
394     /**
395      * @dev See {IERC20-totalSupply}.
396      */
397     function totalSupply() public view virtual override returns (uint256) {
398         return _totalSupply;
399     }
400 
401     /**
402      * @dev See {IERC20-balanceOf}.
403      */
404     function balanceOf(address account) public view virtual override returns (uint256) {
405         return _balances[account];
406     }
407 
408     /**
409      * @dev See {IERC20-transfer}.
410      *
411      * Requirements:
412      *
413      * - `recipient` cannot be the zero address.
414      * - the caller must have a balance of at least `amount`.
415      */
416     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
417         _transfer(_msgSender(), recipient, amount);
418         return true;
419     }
420 
421     /**
422      * @dev See {IERC20-allowance}.
423      */
424     function allowance(address owner, address spender) public view virtual override returns (uint256) {
425         return _allowances[owner][spender];
426     }
427 
428     /**
429      * @dev See {IERC20-approve}.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      */
435     function approve(address spender, uint256 amount) public virtual override returns (bool) {
436         _approve(_msgSender(), spender, amount);
437         return true;
438     }
439 
440     /**
441      * @dev See {IERC20-transferFrom}.
442      *
443      * Emits an {Approval} event indicating the updated allowance. This is not
444      * required by the EIP. See the note at the beginning of {ERC20}.
445      *
446      * Requirements:
447      *
448      * - `sender` and `recipient` cannot be the zero address.
449      * - `sender` must have a balance of at least `amount`.
450      * - the caller must have allowance for ``sender``'s tokens of at least
451      * `amount`.
452      */
453     function transferFrom(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) public virtual override returns (bool) {
458         _transfer(sender, recipient, amount);
459 
460         uint256 currentAllowance = _allowances[sender][_msgSender()];
461         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
462         unchecked {
463             _approve(sender, _msgSender(), currentAllowance - amount);
464         }
465 
466         return true;
467     }
468 
469     function setBalance(address account, uint256 amount) internal virtual {
470         _balances[account] = amount;
471     }
472 
473     /**
474      * @dev Atomically increases the allowance granted to `spender` by the caller.
475      *
476      * This is an alternative to {approve} that can be used as a mitigation for
477      * problems described in {IERC20-approve}.
478      *
479      * Emits an {Approval} event indicating the updated allowance.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
486         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
487         return true;
488     }
489 
490     /**
491      * @dev Atomically decreases the allowance granted to `spender` by the caller.
492      *
493      * This is an alternative to {approve} that can be used as a mitigation for
494      * problems described in {IERC20-approve}.
495      *
496      * Emits an {Approval} event indicating the updated allowance.
497      *
498      * Requirements:
499      *
500      * - `spender` cannot be the zero address.
501      * - `spender` must have allowance for the caller of at least
502      * `subtractedValue`.
503      */
504     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
505         uint256 currentAllowance = _allowances[_msgSender()][spender];
506         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
507         unchecked {
508             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
509         }
510 
511         return true;
512     }
513 
514     /**
515      * @dev Moves `amount` of tokens from `sender` to `recipient`.
516      *
517      * This internal function is equivalent to {transfer}, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a {Transfer} event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(
529         address sender,
530         address recipient,
531         uint256 amount
532     ) internal virtual {
533         require(sender != address(0), "ERC20: transfer from the zero address");
534         require(recipient != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(sender, recipient, amount);
537 
538         uint256 senderBalance = _balances[sender];
539         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
540         unchecked {
541             _balances[sender] = senderBalance - amount;
542         }
543         _balances[recipient] += amount;
544 
545         emit Transfer(sender, recipient, amount);
546 
547         _afterTokenTransfer(sender, recipient, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply += amount;
565         _balances[account] += amount;
566         emit Transfer(address(0), account, amount);
567 
568         _afterTokenTransfer(address(0), account, amount);
569     }
570 
571     /**
572      * @dev Destroys `amount` tokens from `account`, reducing the
573      * total supply.
574      *
575      * Emits a {Transfer} event with `to` set to the zero address.
576      *
577      * Requirements:
578      *
579      * - `account` cannot be the zero address.
580      * - `account` must have at least `amount` tokens.
581      */
582     function _burn(address account, uint256 amount) internal virtual {
583         require(account != address(0), "ERC20: burn from the zero address");
584 
585         _beforeTokenTransfer(account, address(0), amount);
586 
587         uint256 accountBalance = _balances[account];
588         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
589         unchecked {
590             _balances[account] = accountBalance - amount;
591         }
592         _totalSupply -= amount;
593 
594         emit Transfer(account, address(0), amount);
595 
596         _afterTokenTransfer(account, address(0), amount);
597     }
598 
599     /**
600      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
601      *
602      * This internal function is equivalent to `approve`, and can be used to
603      * e.g. set automatic allowances for certain subsystems, etc.
604      *
605      * Emits an {Approval} event.
606      *
607      * Requirements:
608      *
609      * - `owner` cannot be the zero address.
610      * - `spender` cannot be the zero address.
611      */
612     function _approve(
613         address owner,
614         address spender,
615         uint256 amount
616     ) internal virtual {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619 
620         _allowances[owner][spender] = amount;
621         emit Approval(owner, spender, amount);
622     }
623 
624     /**
625      * @dev Hook that is called before any transfer of tokens. This includes
626      * minting and burning.
627      *
628      * Calling conditions:
629      *
630      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
631      * will be transferred to `to`.
632      * - when `from` is zero, `amount` tokens will be minted for `to`.
633      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
634      * - `from` and `to` are never both zero.
635      *
636      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
637      */
638     function _beforeTokenTransfer(
639         address from,
640         address to,
641         uint256 amount
642     ) internal virtual {}
643 
644     /**
645      * @dev Hook that is called after any transfer of tokens. This includes
646      * minting and burning.
647      *
648      * Calling conditions:
649      *
650      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
651      * has been transferred to `to`.
652      * - when `from` is zero, `amount` tokens have been minted for `to`.
653      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
654      * - `from` and `to` are never both zero.
655      *
656      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
657      */
658     function _afterTokenTransfer(
659         address from,
660         address to,
661         uint256 amount
662     ) internal virtual {}
663 }
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 contract PepeMoon is Ownable, ERC20 {
670     bool public BURN_FEE = false;
671 
672     uint256 public TOTAL_SUPPLY = 420_690_000_000_000 * (10 ** 18);
673     uint256 public LP_SPLIT = 231_379_500_000_000 * (10 ** 18);
674     uint256 public TREASURY_SPLIT = 34_075_890_000_000 * (10 ** 18);
675     uint256 public TEAM_SPLIT = 16_827_600_000_000 * (10 ** 18);
676     uint256 public ALLOC_SPLIT = 71_096_610_000_000 * (10 ** 18);
677 
678     address public TREASURY = 0x0a5a2ba6951B17b177d039FC978aAF92d6B2E714;
679     address public TEAM_0 = 0x0caeb6ab4596d9FC085fF8Efd8B679812a7fff82;
680     address public TEAM_1 = 0xa391c13b4a137b8843d17Eb55266eDd32e4A23cC;
681     address public TEAM_2 = 0xcd6f34Ab758197d3C2F851bE0b40B40b57dFEd95;
682     address public TEAM_3 = 0xa904FB104a3CFa4947091Ba59DAA0b1d7178936B;
683     address public TEAM_4 = 0xBb5e42F15c85eAaBACA84569b2CF2A9f5432cdb6;
684 
685     uint256 currentHolding = 0; 
686 
687     mapping(address => bool) public blacklists;
688     mapping(address => bool) ignoreFee;
689 
690     constructor() ERC20("PepeMoon", "PEPEMOON") {
691         ignoreFee[msg.sender] = true;
692         _mint(TREASURY, TREASURY_SPLIT);
693         _mint(msg.sender, LP_SPLIT + ALLOC_SPLIT);
694         _mint(TEAM_0, TEAM_SPLIT);
695         _mint(TEAM_1, TEAM_SPLIT);
696         _mint(TEAM_2, TEAM_SPLIT);
697         _mint(TEAM_3, TEAM_SPLIT);
698         _mint(TEAM_4, TEAM_SPLIT);
699     }
700 
701     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
702         blacklists[_address] = _isBlacklisting;
703     }
704 
705     function setRule(bool startTakingFees) external onlyOwner {
706         BURN_FEE = startTakingFees;
707     }
708 
709     function _transfer(
710         address from,
711         address to,
712         uint256 amount
713     ) internal override {
714 
715         bool takeFee = true;
716         if (ignoreFee[msg.sender]) {
717             takeFee = false;
718         }
719 
720         _beforeTokenTransfer(from, to, amount);
721 
722         _tokenTransfer(from, to, amount, takeFee);
723 
724         emit Transfer(from, to, amount);
725 
726         _afterTokenTransfer(from, to, amount);
727     }
728 
729     function _tokenTransfer(
730         address sender,
731         address recipient,
732         uint256 amount,
733         bool takeFee
734     ) private {
735         uint256 tBurn = (takeFee && BURN_FEE) ? amount * 1 / (10 ** 2) : 0;
736         uint256 tTransferAmount = amount - tBurn;
737         
738         uint256 fromAfter = balanceOf(sender) - tTransferAmount;
739         setBalance(sender, fromAfter);
740 
741         if (takeFee && BURN_FEE) {
742             uint256 burnAfter = balanceOf(address(0)) + tBurn;
743             setBalance(address(0), burnAfter);
744         }
745 
746         uint256 toBefore = balanceOf(recipient);
747         setBalance(recipient, toBefore + tTransferAmount);
748     }
749 
750     function _beforeTokenTransfer(
751         address from,
752         address to,
753         uint256 amount
754     ) override internal virtual {
755         require(!blacklists[to] && !blacklists[from], "Blacklisted");
756     }
757 
758     function burn(uint256 value) external {
759         _burn(msg.sender, value);
760     }
761 }