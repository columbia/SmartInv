1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 
6 interface IUniswapV2Factory {
7     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
8 
9     function feeTo() external view returns (address);
10     function feeToSetter() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25 
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32 
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36 
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40 
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42 
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54 
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63 
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69 
70     function initialize(address, address) external;
71 }
72 
73 interface IUniswapV2Router01 {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95     function removeLiquidity(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline
103     ) external returns (uint amountA, uint amountB);
104     function removeLiquidityETH(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountToken, uint amountETH);
112     function removeLiquidityWithPermit(
113         address tokenA,
114         address tokenB,
115         uint liquidity,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountA, uint amountB);
122     function removeLiquidityETHWithPermit(
123         address token,
124         uint liquidity,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountToken, uint amountETH);
131     function swapExactTokensForTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external returns (uint[] memory amounts);
138     function swapTokensForExactTokens(
139         uint amountOut,
140         uint amountInMax,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         returns (uint[] memory amounts);
155     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
156         external
157         payable
158         returns (uint[] memory amounts);
159 
160     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
161     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
162     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
163     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
164     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
165 }
166 
167 
168 interface IUniswapV2Router02 is IUniswapV2Router01 {
169     function removeLiquidityETHSupportingFeeOnTransferTokens(
170         address token,
171         uint liquidity,
172         uint amountTokenMin,
173         uint amountETHMin,
174         address to,
175         uint deadline
176     ) external returns (uint amountETH);
177     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
178         address token,
179         uint liquidity,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline,
184         bool approveMax, uint8 v, bytes32 r, bytes32 s
185     ) external returns (uint amountETH);
186 
187     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
188         uint amountIn,
189         uint amountOutMin,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external;
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external payable;
200     function swapExactTokensForETHSupportingFeeOnTransferTokens(
201         uint amountIn,
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external;
207 }
208 // File: misc-tokens/Ryoshi/IERC20.sol
209 
210 
211 
212 pragma solidity ^0.8.4;
213 
214 interface IERC20 {
215 
216     function totalSupply() external view returns (uint256);
217 
218     /**
219      * @dev Returns the amount of tokens owned by `account`.
220      */
221     function balanceOf(address account) external view returns (uint256);
222 
223     /**
224      * @dev Moves `amount` tokens from the caller's account to `recipient`.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transfer(address recipient, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Returns the remaining number of tokens that `spender` will be
234      * allowed to spend on behalf of `owner` through {transferFrom}. This is
235      * zero by default.
236      *
237      * This value changes when {approve} or {transferFrom} are called.
238      */
239     function allowance(address owner, address spender) external view returns (uint256);
240 
241     /**
242      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * IMPORTANT: Beware that changing an allowance with this method brings the risk
247      * that someone may use both the old and the new allowance by unfortunate
248      * transaction ordering. One possible solution to mitigate this race
249      * condition is to first reduce the spender's allowance to 0 and set the
250      * desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Moves `amount` tokens from `sender` to `recipient` using the
259      * allowance mechanism. `amount` is then deducted from the caller's
260      * allowance.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Emitted when `value` tokens are moved from one account (`from`) to
270      * another (`to`).
271      *
272      * Note that `value` may be zero.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     /**
277      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
278      * a call to {approve}. `value` is the new allowance.
279      */
280     event Approval(address indexed owner, address indexed spender, uint256 value);
281 }
282 // File: misc-tokens/Ryoshi/IERC20Metadata.sol
283 
284 
285 
286 pragma solidity ^0.8.4;
287 
288 
289 /**
290  * @dev Interface for the optional metadata functions from the ERC20 standard.
291  *
292  * _Available since v4.1._
293  */
294 interface IERC20Metadata is IERC20 {
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() external view returns (string memory);
299 
300     /**
301      * @dev Returns the symbol of the token.
302      */
303     function symbol() external view returns (string memory);
304 
305     /**
306      * @dev Returns the decimals places of the token.
307      */
308     function decimals() external view returns (uint8);
309 }
310 // File: misc-tokens/Ryoshi/Context.sol
311 
312 
313 
314 pragma solidity ^0.8.4;
315 
316 abstract contract Context {
317     function _msgSender() internal view virtual returns (address payable) {
318         return payable(msg.sender);
319     }
320 
321     function _msgData() internal view virtual returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 // File: misc-tokens/Ryoshi/Ownable.sol
327 
328 
329 
330 pragma solidity ^0.8.4;
331 
332 
333 /**
334  * @dev Contract module which provides a basic access control mechanism, where
335  * there is an account (an owner) that can be granted exclusive access to
336  * specific functions.
337  *
338  * By default, the owner account will be the one that deploys the contract. This
339  * can later be changed with {transferOwnership}.
340  *
341  * This module is used through inheritance. It will make available the modifier
342  * `onlyOwner`, which can be applied to your functions to restrict their use to
343  * the owner.
344  */
345 contract Ownable is Context {
346     address private _owner;
347 
348     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
349 
350     /**
351      * @dev Initializes the contract setting the deployer as the initial owner.
352      */
353     constructor () {
354         address msgSender = _msgSender();
355         _owner = msgSender;
356         emit OwnershipTransferred(address(0), msgSender);
357     }
358 
359     /**
360      * @dev Returns the address of the current owner.
361      */
362     function owner() public view returns (address) {
363         return _owner;
364     }
365     
366     /**
367      * @dev Throws if called by any account other than the owner. Modifier gas savings
368      */
369     function _onlyOwner() private view {
370         require(_owner == _msgSender(), "Ownable: caller is not the owner");
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         _onlyOwner();
378         _;
379     }
380 
381      /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         emit OwnershipTransferred(_owner, address(0));
390         _owner = address(0);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "Ownable: new owner is the zero address");
399         emit OwnershipTransferred(_owner, newOwner);
400         _owner = newOwner;
401     }
402 }
403 // File: misc-tokens/Ryoshi/ERC20.sol
404 
405 
406 
407 pragma solidity ^0.8.4;
408 
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20PresetMinterPauser}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20, IERC20Metadata {
436     mapping(address => uint256) private _balances;
437     
438     mapping(address => mapping(address => uint256)) private _allowances;
439     
440     uint256 private _totalSupply;
441     uint8 private _decimals;
442 
443     string private _name;
444     string private _symbol;
445 
446     /**
447      * @dev Sets the values for {name} and {symbol}.
448      *
449      * The default value of {decimals} is 18. To select a different value for
450      * {decimals} you should overload it.
451      *
452      * All two of these values are immutable: they can only be set once during
453      * construction.
454      */
455     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
456         _name = name_;
457         _symbol = symbol_;
458         _decimals = decimals_;
459     }
460 
461     /**
462      * @dev Returns the name of the token.
463      */
464     function name() public view virtual override returns (string memory) {
465         return _name;
466     }
467 
468     /**
469      * @dev Returns the symbol of the token, usually a shorter version of the
470      * name.
471      */
472     function symbol() public view virtual override returns (string memory) {
473         return _symbol;
474     }
475 
476     /**
477      * @dev Returns the number of decimals used to get its user representation.
478      * For example, if `decimals` equals `2`, a balance of `505` tokens should
479      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
480      *
481      * Tokens usually opt for a value of 18, imitating the relationship between
482      * Ether and Wei. This is the value {ERC20} uses, unless this function is
483      * overridden;
484      *
485      * NOTE: This information is only used for _display_ purposes: it in
486      * no way affects any of the arithmetic of the contract, including
487      * {IERC20-balanceOf} and {IERC20-transfer}.
488      */
489     function decimals() public view virtual override returns (uint8) {
490         return _decimals;
491     }
492 
493     /**
494      * @dev See {IERC20-totalSupply}.
495      */
496     function totalSupply() public view virtual override returns (uint256) {
497         return _totalSupply;
498     }
499 
500     /**
501      * @dev See {IERC20-balanceOf}.
502      */
503     function balanceOf(address account) public view virtual override returns (uint256) {
504         return _balances[account];
505     }
506 
507     /**
508      * @dev See {IERC20-transfer}.
509      *
510      * Requirements:
511      *
512      * - `recipient` cannot be the zero address.
513      * - the caller must have a balance of at least `amount`.
514      */
515     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
516         _transfer(_msgSender(), recipient, amount);
517         return true;
518     }
519 
520     /**
521      * @dev See {IERC20-allowance}.
522      */
523     function allowance(address owner, address spender) public view virtual override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     /**
528      * @dev See {IERC20-approve}.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function approve(address spender, uint256 amount) public virtual override returns (bool) {
535         _approve(_msgSender(), spender, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-transferFrom}.
541      *
542      * Emits an {Approval} event indicating the updated allowance. This is not
543      * required by the EIP. See the note at the beginning of {ERC20}.
544      *
545      * Requirements:
546      *
547      * - `sender` and `recipient` cannot be the zero address.
548      * - `sender` must have a balance of at least `amount`.
549      * - the caller must have allowance for ``sender``'s tokens of at least
550      * `amount`.
551      */
552     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
553         _transfer(sender, recipient, amount);
554         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
555         return true;
556     }
557 
558     /**
559      * @dev Atomically increases the allowance granted to `spender` by the caller.
560      *
561      * This is an alternative to {approve} that can be used as a mitigation for
562      * problems described in {IERC20-approve}.
563      *
564      * Emits an {Approval} event indicating the updated allowance.
565      *
566      * Requirements:
567      *
568      * - `spender` cannot be the zero address.
569      */
570     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
572         return true;
573     }
574 
575     /**
576      * @dev Atomically decreases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      * - `spender` must have allowance for the caller of at least
587      * `subtractedValue`.
588      */
589     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
591         return true;
592     }
593 
594     /**
595      * @dev Moves tokens `amount` from `sender` to `recipient`.
596      *
597      * This is internal function is equivalent to {transfer}, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a {Transfer} event.
601      *
602      * Requirements:
603      *
604      * - `sender` cannot be the zero address.
605      * - `recipient` cannot be the zero address.
606      * - `sender` must have a balance of at least `amount`.
607      */
608     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
609         require(sender != address(0), "ERC20: transfer from the zero address");
610         require(recipient != address(0), "ERC20: transfer to the zero address");
611 
612         _beforeTokenTransfer(sender, recipient, amount);
613 
614         _balances[sender] -= amount;
615         _balances[recipient] += amount;
616         emit Transfer(sender, recipient, amount);
617     }
618 
619     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
620      * the total supply.
621      *
622      * Emits a {Transfer} event with `from` set to the zero address.
623      *
624      * Requirements:
625      *
626      * - `account` cannot be the zero address.
627      */
628     function _mint(address account, uint256 amount) internal virtual {
629         require(account != address(0), "ERC20: mint to the zero address");
630 
631         _beforeTokenTransfer(address(0), account, amount);
632 
633         _totalSupply += amount;
634         _balances[account] += amount;
635         emit Transfer(address(0), account, amount);
636     }
637 
638     /**
639      * @dev Destroys `amount` tokens from `account`, reducing the
640      * total supply.
641      *
642      * Emits a {Transfer} event with `to` set to the zero address.
643      *
644      * Requirements:
645      *
646      * - `account` cannot be the zero address.
647      * - `account` must have at least `amount` tokens.
648      */
649     function _burn(address account, uint256 amount) internal virtual {
650         require(account != address(0), "ERC20: burn from the zero address");
651 
652         _beforeTokenTransfer(account, address(0), amount);
653 
654         _balances[account] -= amount;
655         _totalSupply -= amount;
656         emit Transfer(account, address(0), amount);
657     }
658 
659     /**
660      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
661      *
662      * This internal function is equivalent to `approve`, and can be used to
663      * e.g. set automatic allowances for certain subsystems, etc.
664      *
665      * Emits an {Approval} event.
666      *
667      * Requirements:
668      *
669      * - `owner` cannot be the zero address.
670      * - `spender` cannot be the zero address.
671      */
672     function _approve(address owner, address spender, uint256 amount) internal virtual {
673         require(owner != address(0), "ERC20: approve from the zero address");
674         require(spender != address(0), "ERC20: approve to the zero address");
675 
676         _allowances[owner][spender] = amount;
677         emit Approval(owner, spender, amount);
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be to transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
695 }
696 // File: misc-tokens/Ryoshi/Address.sol
697 
698 
699 
700 pragma solidity ^0.8.4;
701 
702 /**
703  * @dev Collection of functions related to the address type
704  */
705 library Address {
706     /**
707      * @dev Returns true if `account` is a contract.
708      *
709      * [IMPORTANT]
710      * ====
711      * It is unsafe to assume that an address for which this function returns
712      * false is an externally-owned account (EOA) and not a contract.
713      *
714      * Among others, `isContract` will return false for the following
715      * types of addresses:
716      *
717      *  - an externally-owned account
718      *  - a contract in construction
719      *  - an address where a contract will be created
720      *  - an address where a contract lived, but was destroyed
721      * ====
722      */
723     function isContract(address account) internal view returns (bool) {
724         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
725         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
726         // for accounts without code, i.e. `keccak256('')`
727         bytes32 codehash;
728         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
729         // solhint-disable-next-line no-inline-assembly
730         assembly { codehash := extcodehash(account) }
731         return (codehash != accountHash && codehash != 0x0);
732     }
733 
734     /**
735      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
736      * `recipient`, forwarding all available gas and reverting on errors.
737      *
738      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
739      * of certain opcodes, possibly making contracts go over the 2300 gas limit
740      * imposed by `transfer`, making them unable to receive funds via
741      * `transfer`. {sendValue} removes this limitation.
742      *
743      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
744      *
745      * IMPORTANT: because control is transferred to `recipient`, care must be
746      * taken to not create reentrancy vulnerabilities. Consider using
747      * {ReentrancyGuard} or the
748      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
749      */
750     function sendValue(address payable recipient, uint256 amount) internal {
751         require(address(this).balance >= amount, "Address: insufficient balance");
752         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
753         (bool success, ) = recipient.call{ value: amount }("");
754         require(success, "Address: unable to send value, recipient may have reverted");
755     }
756 
757     /**
758      * @dev Performs a Solidity function call using a low level `call`. A
759      * plain`call` is an unsafe replacement for a function call: use this
760      * function instead.
761      *
762      * If `target` reverts with a revert reason, it is bubbled up by this
763      * function (like regular Solidity function calls).
764      *
765      * Returns the raw returned data. To convert to the expected return value,
766      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
767      *
768      * Requirements:
769      *
770      * - `target` must be a contract.
771      * - calling `target` with `data` must not revert.
772      *
773      * _Available since v3.1._
774      */
775     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
776       return functionCall(target, data, "Address: low-level call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
781      * `errorMessage` as a fallback revert reason when `target` reverts.
782      *
783      * _Available since v3.1._
784      */
785     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
786         return _functionCallWithValue(target, data, 0, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but also transferring `value` wei to `target`.
792      *
793      * Requirements:
794      *
795      * - the calling contract must have an ETH balance of at least `value`.
796      * - the called Solidity function must be `payable`.
797      *
798      * _Available since v3.1._
799      */
800     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
806      * with `errorMessage` as a fallback revert reason when `target` reverts.
807      *
808      * _Available since v3.1._
809      */
810     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
811         require(address(this).balance >= value, "Address: insufficient balance for call");
812         return _functionCallWithValue(target, data, value, errorMessage);
813     }
814 
815     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
816         require(isContract(target), "Address: call to non-contract");
817 
818         // solhint-disable-next-line avoid-low-level-calls
819         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
820         if (success) {
821             return returndata;
822         } else {
823             // Look for revert reason and bubble it up if present
824             if (returndata.length > 0) {
825                 // The easiest way to bubble the revert reason is using memory via assembly
826 
827                 // solhint-disable-next-line no-inline-assembly
828                 assembly {
829                     let returndata_size := mload(returndata)
830                     revert(add(32, returndata), returndata_size)
831                 }
832             } else {
833                 revert(errorMessage);
834             }
835         }
836     }
837 }
838 
839 pragma solidity ^0.8.4;
840 
841 contract RYOSHI is ERC20, Ownable {
842     using Address for address payable;
843 
844     IUniswapV2Router02 private uniswapV2Router;
845     address public uniswapV2Pair;
846 
847     mapping(address => bool) private isExcludedFromFee;
848     mapping(address => bool) private isBlacklisted;
849     mapping(address => bool) private automatedMarketMakerPairs;
850     
851     uint8 private liquidityFee = 1;
852     uint8 private marketingFee = 2;
853     uint8 private burnFee = 2;
854     uint8 public totalFees = liquidityFee + marketingFee + burnFee;
855     address public marketingWallet = 0x958C4edB417399Bb9440dc2435De7Fbd03b67176;
856     
857     bool private inSwapAndLiquify;
858     bool private swapAndLiquifyEnabled = true;
859     
860     uint48 private antibotEndTime;
861     
862     address private constant BURN_WALLET = 0x000000000000000000000000000000000000dEaD;
863 
864     uint256 public _maxTxAmount;
865     uint256 private numTokensSellToAddToLiquidity;
866 
867     string private constant ALREADY_SET = "Already set";
868     string private constant ZERO_ADDRESS = "Zero address";
869     
870     event MinTokensBeforeSwapUpdated (uint256 minTokensBeforeSwap);
871     event SwapAndLiquifyEnabledUpdated (bool enabled); 
872     event AccidentallySentTokenWithdrawn (address token, uint256 amount);
873     event AccidentallySentBNBWithdrawn (uint256 amount);
874     event ExcludeFromFee (address account, bool isExcluded);
875     event UpdateUniswapV2Router (address newAddress, address oldAddress);
876     event MarketingWalletUpdated (address oldMarketingWallet, address newMarketingWallet);
877     event MaxTxAmountChanged (uint256 oldMaxTxAmount, uint256 newMaxTxAmount);
878     event SetAutomatedMarketMakerPair (address pair, bool value);
879     event FeesUpdated (uint8 oldMarketingFee, uint8 newMarketingFee, uint8 oldLiquidityFee, uint8 newLiquidityFee, uint8 oldBurnFee, uint8 newBurnFee);
880         
881     constructor() ERC20 ("RYOSHI TOKEN", "RYOSHI", 9) {
882         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
883         uniswapV2Router = _uniswapV2Router;
884         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
885         automatedMarketMakerPairs[_uniswapV2Pair] = true;
886         uniswapV2Pair = _uniswapV2Pair;
887         
888         //exclude owner and this contract from fee
889         isExcludedFromFee[msg.sender] = true;
890         isExcludedFromFee[address(this)] = true;
891         isExcludedFromFee[marketingWallet] = true;
892         isExcludedFromFee[BURN_WALLET] = true;
893         
894         _mint (msg.sender, 1 * 10**15 * 10**9);
895         _maxTxAmount = 1 * 10**15 * 10**9 / 100;
896         numTokensSellToAddToLiquidity = 1 * 10**15 * 10**9 / 10000;
897     }
898 
899     function setAutomatedMarketMakerPair (address pair, bool value) external onlyOwner {
900         require (pair != uniswapV2Pair || value, "Can't remove");
901         
902         automatedMarketMakerPairs[pair] = value;
903         emit SetAutomatedMarketMakerPair (pair, value);
904     }
905     
906     function excludeFromFee(address account, bool excluded) external onlyOwner {
907         isExcludedFromFee[account] = excluded;
908         emit ExcludeFromFee (account, excluded);
909     }
910     
911     function setMarketingWallet(address _marketingWallet) external onlyOwner() {
912         require (_marketingWallet != address(0), ZERO_ADDRESS);
913         emit MarketingWalletUpdated (marketingWallet, _marketingWallet);
914         marketingWallet = _marketingWallet;
915     }
916     
917     function setMaxTxPercent (uint256 maxTxPercent) external onlyOwner() {
918         require (maxTxPercent != 0, "Can't set");
919         uint256 maxTxAmount = totalSupply() * maxTxPercent / 100;
920         emit MaxTxAmountChanged (_maxTxAmount, maxTxAmount);
921         _maxTxAmount = maxTxAmount;
922     }
923     
924     function setFees (uint8 newMarketingFee, uint8 newLiquidityFee, uint8 newBurnFee) external onlyOwner {
925         uint8 newTotalFees = newMarketingFee + newLiquidityFee + newBurnFee;
926         require (newTotalFees <= 25, "must be <= 25%");
927         
928         emit FeesUpdated (marketingFee, newMarketingFee, liquidityFee, newLiquidityFee, burnFee, newBurnFee);
929         
930         marketingFee = newMarketingFee;
931         liquidityFee = newLiquidityFee;
932         burnFee = newBurnFee;
933         totalFees = newTotalFees;
934     }
935 
936     function updateUniswapV2Router (IUniswapV2Router02 newAddress) external onlyOwner {
937         require(address(newAddress) != address(uniswapV2Router), ALREADY_SET);
938         require(address(newAddress) != address(0), ZERO_ADDRESS);
939 
940         emit UpdateUniswapV2Router (address(newAddress), address(uniswapV2Router));
941         
942         uniswapV2Router = IUniswapV2Router02 (newAddress);
943         
944         address _uniswapV2Pair = IUniswapV2Factory (newAddress.factory()).createPair (address(this), newAddress.WETH());
945         automatedMarketMakerPairs[_uniswapV2Pair] =  true;
946         uniswapV2Pair = _uniswapV2Pair;
947     }
948 
949     function blacklistAddress (address account, bool blacklist) external onlyOwner {
950         require (isBlacklisted[account] != blacklist, ALREADY_SET);
951         require (account != uniswapV2Pair, "Can't blacklist");
952         isBlacklisted[account] = blacklist;
953     }
954 
955     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
956         swapAndLiquifyEnabled = _enabled;
957         emit SwapAndLiquifyEnabledUpdated(_enabled);
958     }
959     
960      //to recieve ETH from uniswapV2Router when swapping
961     receive() external payable {}
962 
963 
964     function _getValues(address sender, uint256 amount) private returns (uint256 transferAmount) {
965     }
966 
967     // Help users who accidentally send tokens to the contract address
968     function withdrawOtherTokens (address _token) external onlyOwner {
969         require (_token != address(this), "Can't withdraw");
970         require (_token != address(0), ZERO_ADDRESS);
971         IERC20 token = IERC20(_token);
972         uint256 tokenBalance = token.balanceOf (address(this));
973 
974         if (tokenBalance > 0) {
975             token.transfer (owner(), tokenBalance);
976             emit AccidentallySentTokenWithdrawn (_token, tokenBalance);
977         }
978     }
979     
980     // Help users who accidentally send BNB to the contract address - this only removes BNB that has been manually transferred to the contract address
981     // BNB that is created as part of the liquidity provision process will be sent to the PCS pair address immediately and so cannot be affected by this action
982     function withdrawExcessBNB() external onlyOwner {
983         uint256 contractBNBBalance = address(this).balance;
984         
985         if (contractBNBBalance > 0)
986             payable(owner()).sendValue(contractBNBBalance);
987         
988         emit AccidentallySentBNBWithdrawn (contractBNBBalance);
989     }
990 
991     function _transfer (address sender, address recipient, uint256 amount) internal override  {
992         require (sender != address(0) && recipient != address(0), ZERO_ADDRESS);
993         require (!isBlacklisted[sender] && !isBlacklisted[recipient], "Blacklisted");
994         address theOwner = owner();
995 
996         if (amount == 0)
997             super._transfer (sender, recipient, 0);
998 
999         if (sender != theOwner && recipient != theOwner && sender != address(this))
1000             require(amount <= _maxTxAmount, "> maxTxAmount");
1001         else if (sender == theOwner && automatedMarketMakerPairs[recipient] && antibotEndTime == 0)
1002             antibotEndTime = uint48(block.timestamp + 12);
1003 
1004         // If selling, contract balance > numTokensSellToAddToLiquidity and not already swapping then swap
1005         if (balanceOf(address(this)) >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && !automatedMarketMakerPairs[sender] && swapAndLiquifyEnabled) {
1006             inSwapAndLiquify = true;
1007             uint256 _marketingFee = marketingFee;
1008             uint256 marketingTokensToSwap = numTokensSellToAddToLiquidity * _marketingFee / (_marketingFee + liquidityFee);
1009             uint256 liquidityTokens = (numTokensSellToAddToLiquidity - marketingTokensToSwap) / 2;
1010             swapTokensForEth (numTokensSellToAddToLiquidity - liquidityTokens);
1011             addLiquidity (liquidityTokens, address(this).balance);
1012 
1013             if (address(this).balance > 0)
1014                 payable(marketingWallet).sendValue (address(this).balance);
1015             
1016             inSwapAndLiquify = false;
1017         }
1018         
1019         // if any account is excluded from fees make sure we don't take fees        
1020         if (!(isExcludedFromFee[sender] || isExcludedFromFee[recipient])) {
1021             uint256 feeDenominator = block.timestamp > antibotEndTime ? 100 : totalFees + 1;
1022             uint256 burnFeeAmount = (amount * burnFee) / feeDenominator;
1023             super._transfer (sender, BURN_WALLET, burnFeeAmount);
1024             uint256 otherFeeAmount = (amount * (liquidityFee + marketingFee)) / feeDenominator;
1025             super._transfer (sender, address(this), otherFeeAmount);
1026             amount -= (burnFeeAmount + otherFeeAmount);
1027         }
1028             
1029         super._transfer (sender, recipient, amount);
1030     }
1031 
1032     function swapTokensForEth (uint256 tokenAmount) private {
1033         IUniswapV2Router02 _uniswapV2Router = uniswapV2Router;
1034         // generate the uniswap pair path of token -> weth
1035         address[] memory path = new address[](2);
1036         path[0] = address(this);
1037         path[1] = _uniswapV2Router.WETH();
1038 
1039         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1040         uint256[] memory amounts = _uniswapV2Router.getAmountsOut (tokenAmount, path);
1041 
1042         // make the swap
1043         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1044             tokenAmount,
1045             amounts[1] * 95 / 100, // allow 5% slippage
1046             path,
1047             address(this),
1048             block.timestamp
1049         );
1050     }
1051 
1052     function addLiquidity (uint256 tokenAmount, uint256 ethAmount) private {
1053         if (tokenAmount > 0) {
1054             IUniswapV2Router02 _uniswapV2Router = uniswapV2Router;
1055             // approve token transfer to cover all possible scenarios
1056             _approve(address(this), address(_uniswapV2Router), tokenAmount);
1057 
1058             // add the liquidity
1059             _uniswapV2Router.addLiquidityETH{value: ethAmount}(
1060                 address(this),
1061                 tokenAmount,
1062                 0, // slippage is unavoidable
1063                 0, // slippage is unavoidable
1064                 owner(),
1065                 block.timestamp
1066             );
1067         }
1068     }
1069 }