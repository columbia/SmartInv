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
328 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Emitted when `value` tokens are moved from one account (`from`) to
338      * another (`to`).
339      *
340      * Note that `value` may be zero.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 value);
343 
344     /**
345      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
346      * a call to {approve}. `value` is the new allowance.
347      */
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349 
350     /**
351      * @dev Returns the amount of tokens in existence.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @dev Returns the amount of tokens owned by `account`.
357      */
358     function balanceOf(address account) external view returns (uint256);
359 
360     /**
361      * @dev Moves `amount` tokens from the caller's account to `to`.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transfer(address to, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Returns the remaining number of tokens that `spender` will be
371      * allowed to spend on behalf of `owner` through {transferFrom}. This is
372      * zero by default.
373      *
374      * This value changes when {approve} or {transferFrom} are called.
375      */
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * IMPORTANT: Beware that changing an allowance with this method brings the risk
384      * that someone may use both the old and the new allowance by unfortunate
385      * transaction ordering. One possible solution to mitigate this race
386      * condition is to first reduce the spender's allowance to 0 and set the
387      * desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address spender, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Moves `amount` tokens from `from` to `to` using the
396      * allowance mechanism. `amount` is then deducted from the caller's
397      * allowance.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(
404         address from,
405         address to,
406         uint256 amount
407     ) external returns (bool);
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
443 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
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
550      * - `to` cannot be the zero address.
551      * - the caller must have a balance of at least `amount`.
552      */
553     function transfer(address to, uint256 amount) public virtual override returns (bool) {
554         address owner = _msgSender();
555         _transfer(owner, to, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-allowance}.
561      */
562     function allowance(address owner, address spender) public view virtual override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
570      * `transferFrom`. This is semantically equivalent to an infinite approval.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      */
576     function approve(address spender, uint256 amount) public virtual override returns (bool) {
577         address owner = _msgSender();
578         _approve(owner, spender, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-transferFrom}.
584      *
585      * Emits an {Approval} event indicating the updated allowance. This is not
586      * required by the EIP. See the note at the beginning of {ERC20}.
587      *
588      * NOTE: Does not update the allowance if the current allowance
589      * is the maximum `uint256`.
590      *
591      * Requirements:
592      *
593      * - `from` and `to` cannot be the zero address.
594      * - `from` must have a balance of at least `amount`.
595      * - the caller must have allowance for ``from``'s tokens of at least
596      * `amount`.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 amount
602     ) public virtual override returns (bool) {
603         address spender = _msgSender();
604         _spendAllowance(from, spender, amount);
605         _transfer(from, to, amount);
606         return true;
607     }
608 
609     /**
610      * @dev Atomically increases the allowance granted to `spender` by the caller.
611      *
612      * This is an alternative to {approve} that can be used as a mitigation for
613      * problems described in {IERC20-approve}.
614      *
615      * Emits an {Approval} event indicating the updated allowance.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      */
621     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
622         address owner = _msgSender();
623         _approve(owner, spender, allowance(owner, spender) + addedValue);
624         return true;
625     }
626 
627     /**
628      * @dev Atomically decreases the allowance granted to `spender` by the caller.
629      *
630      * This is an alternative to {approve} that can be used as a mitigation for
631      * problems described in {IERC20-approve}.
632      *
633      * Emits an {Approval} event indicating the updated allowance.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      * - `spender` must have allowance for the caller of at least
639      * `subtractedValue`.
640      */
641     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
642         address owner = _msgSender();
643         uint256 currentAllowance = allowance(owner, spender);
644         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
645         unchecked {
646             _approve(owner, spender, currentAllowance - subtractedValue);
647         }
648 
649         return true;
650     }
651 
652     /**
653      * @dev Moves `amount` of tokens from `sender` to `recipient`.
654      *
655      * This internal function is equivalent to {transfer}, and can be used to
656      * e.g. implement automatic token fees, slashing mechanisms, etc.
657      *
658      * Emits a {Transfer} event.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `from` must have a balance of at least `amount`.
665      */
666     function _transfer(
667         address from,
668         address to,
669         uint256 amount
670     ) internal virtual {
671         require(from != address(0), "ERC20: transfer from the zero address");
672         require(to != address(0), "ERC20: transfer to the zero address");
673 
674         _beforeTokenTransfer(from, to, amount);
675 
676         uint256 fromBalance = _balances[from];
677         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
678         unchecked {
679             _balances[from] = fromBalance - amount;
680         }
681         _balances[to] += amount;
682 
683         emit Transfer(from, to, amount);
684 
685         _afterTokenTransfer(from, to, amount);
686     }
687 
688     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
689      * the total supply.
690      *
691      * Emits a {Transfer} event with `from` set to the zero address.
692      *
693      * Requirements:
694      *
695      * - `account` cannot be the zero address.
696      */
697     function _mint(address account, uint256 amount) internal virtual {
698         require(account != address(0), "ERC20: mint to the zero address");
699 
700         _beforeTokenTransfer(address(0), account, amount);
701 
702         _totalSupply += amount;
703         _balances[account] += amount;
704         emit Transfer(address(0), account, amount);
705 
706         _afterTokenTransfer(address(0), account, amount);
707     }
708 
709     /**
710      * @dev Destroys `amount` tokens from `account`, reducing the
711      * total supply.
712      *
713      * Emits a {Transfer} event with `to` set to the zero address.
714      *
715      * Requirements:
716      *
717      * - `account` cannot be the zero address.
718      * - `account` must have at least `amount` tokens.
719      */
720     function _burn(address account, uint256 amount) internal virtual {
721         require(account != address(0), "ERC20: burn from the zero address");
722 
723         _beforeTokenTransfer(account, address(0), amount);
724 
725         uint256 accountBalance = _balances[account];
726         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
727         unchecked {
728             _balances[account] = accountBalance - amount;
729         }
730         _totalSupply -= amount;
731 
732         emit Transfer(account, address(0), amount);
733 
734         _afterTokenTransfer(account, address(0), amount);
735     }
736 
737     /**
738      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
739      *
740      * This internal function is equivalent to `approve`, and can be used to
741      * e.g. set automatic allowances for certain subsystems, etc.
742      *
743      * Emits an {Approval} event.
744      *
745      * Requirements:
746      *
747      * - `owner` cannot be the zero address.
748      * - `spender` cannot be the zero address.
749      */
750     function _approve(
751         address owner,
752         address spender,
753         uint256 amount
754     ) internal virtual {
755         require(owner != address(0), "ERC20: approve from the zero address");
756         require(spender != address(0), "ERC20: approve to the zero address");
757 
758         _allowances[owner][spender] = amount;
759         emit Approval(owner, spender, amount);
760     }
761 
762     /**
763      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
764      *
765      * Does not update the allowance amount in case of infinite allowance.
766      * Revert if not enough allowance is available.
767      *
768      * Might emit an {Approval} event.
769      */
770     function _spendAllowance(
771         address owner,
772         address spender,
773         uint256 amount
774     ) internal virtual {
775         uint256 currentAllowance = allowance(owner, spender);
776         if (currentAllowance != type(uint256).max) {
777             require(currentAllowance >= amount, "ERC20: insufficient allowance");
778             unchecked {
779                 _approve(owner, spender, currentAllowance - amount);
780             }
781         }
782     }
783 
784     /**
785      * @dev Hook that is called before any transfer of tokens. This includes
786      * minting and burning.
787      *
788      * Calling conditions:
789      *
790      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
791      * will be transferred to `to`.
792      * - when `from` is zero, `amount` tokens will be minted for `to`.
793      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
794      * - `from` and `to` are never both zero.
795      *
796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
797      */
798     function _beforeTokenTransfer(
799         address from,
800         address to,
801         uint256 amount
802     ) internal virtual {}
803 
804     /**
805      * @dev Hook that is called after any transfer of tokens. This includes
806      * minting and burning.
807      *
808      * Calling conditions:
809      *
810      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
811      * has been transferred to `to`.
812      * - when `from` is zero, `amount` tokens have been minted for `to`.
813      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
814      * - `from` and `to` are never both zero.
815      *
816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
817      */
818     function _afterTokenTransfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal virtual {}
823 }
824 
825 // File: hardhat/console.sol
826 
827 
828 pragma solidity >= 0.4.22 <0.9.0;
829 
830 library console {
831 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
832 
833 	function _sendLogPayload(bytes memory payload) private view {
834 		uint256 payloadLength = payload.length;
835 		address consoleAddress = CONSOLE_ADDRESS;
836 		assembly {
837 			let payloadStart := add(payload, 32)
838 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
839 		}
840 	}
841 
842 	function log() internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log()"));
844 	}
845 
846 	function logInt(int p0) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
848 	}
849 
850 	function logUint(uint p0) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
852 	}
853 
854 	function logString(string memory p0) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
856 	}
857 
858 	function logBool(bool p0) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
860 	}
861 
862 	function logAddress(address p0) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
864 	}
865 
866 	function logBytes(bytes memory p0) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
868 	}
869 
870 	function logBytes1(bytes1 p0) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
872 	}
873 
874 	function logBytes2(bytes2 p0) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
876 	}
877 
878 	function logBytes3(bytes3 p0) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
880 	}
881 
882 	function logBytes4(bytes4 p0) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
884 	}
885 
886 	function logBytes5(bytes5 p0) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
888 	}
889 
890 	function logBytes6(bytes6 p0) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
892 	}
893 
894 	function logBytes7(bytes7 p0) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
896 	}
897 
898 	function logBytes8(bytes8 p0) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
900 	}
901 
902 	function logBytes9(bytes9 p0) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
904 	}
905 
906 	function logBytes10(bytes10 p0) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
908 	}
909 
910 	function logBytes11(bytes11 p0) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
912 	}
913 
914 	function logBytes12(bytes12 p0) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
916 	}
917 
918 	function logBytes13(bytes13 p0) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
920 	}
921 
922 	function logBytes14(bytes14 p0) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
924 	}
925 
926 	function logBytes15(bytes15 p0) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
928 	}
929 
930 	function logBytes16(bytes16 p0) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
932 	}
933 
934 	function logBytes17(bytes17 p0) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
936 	}
937 
938 	function logBytes18(bytes18 p0) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
940 	}
941 
942 	function logBytes19(bytes19 p0) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
944 	}
945 
946 	function logBytes20(bytes20 p0) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
948 	}
949 
950 	function logBytes21(bytes21 p0) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
952 	}
953 
954 	function logBytes22(bytes22 p0) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
956 	}
957 
958 	function logBytes23(bytes23 p0) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
960 	}
961 
962 	function logBytes24(bytes24 p0) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
964 	}
965 
966 	function logBytes25(bytes25 p0) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
968 	}
969 
970 	function logBytes26(bytes26 p0) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
972 	}
973 
974 	function logBytes27(bytes27 p0) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
976 	}
977 
978 	function logBytes28(bytes28 p0) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
980 	}
981 
982 	function logBytes29(bytes29 p0) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
984 	}
985 
986 	function logBytes30(bytes30 p0) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
988 	}
989 
990 	function logBytes31(bytes31 p0) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
992 	}
993 
994 	function logBytes32(bytes32 p0) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
996 	}
997 
998 	function log(uint p0) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1000 	}
1001 
1002 	function log(string memory p0) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1004 	}
1005 
1006 	function log(bool p0) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1008 	}
1009 
1010 	function log(address p0) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1012 	}
1013 
1014 	function log(uint p0, uint p1) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1016 	}
1017 
1018 	function log(uint p0, string memory p1) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1020 	}
1021 
1022 	function log(uint p0, bool p1) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1024 	}
1025 
1026 	function log(uint p0, address p1) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1028 	}
1029 
1030 	function log(string memory p0, uint p1) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1032 	}
1033 
1034 	function log(string memory p0, string memory p1) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1036 	}
1037 
1038 	function log(string memory p0, bool p1) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1040 	}
1041 
1042 	function log(string memory p0, address p1) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1044 	}
1045 
1046 	function log(bool p0, uint p1) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1048 	}
1049 
1050 	function log(bool p0, string memory p1) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1052 	}
1053 
1054 	function log(bool p0, bool p1) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1056 	}
1057 
1058 	function log(bool p0, address p1) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1060 	}
1061 
1062 	function log(address p0, uint p1) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1064 	}
1065 
1066 	function log(address p0, string memory p1) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1068 	}
1069 
1070 	function log(address p0, bool p1) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1072 	}
1073 
1074 	function log(address p0, address p1) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1076 	}
1077 
1078 	function log(uint p0, uint p1, uint p2) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1080 	}
1081 
1082 	function log(uint p0, uint p1, string memory p2) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1084 	}
1085 
1086 	function log(uint p0, uint p1, bool p2) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1088 	}
1089 
1090 	function log(uint p0, uint p1, address p2) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1092 	}
1093 
1094 	function log(uint p0, string memory p1, uint p2) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1096 	}
1097 
1098 	function log(uint p0, string memory p1, string memory p2) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1100 	}
1101 
1102 	function log(uint p0, string memory p1, bool p2) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1104 	}
1105 
1106 	function log(uint p0, string memory p1, address p2) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1108 	}
1109 
1110 	function log(uint p0, bool p1, uint p2) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1112 	}
1113 
1114 	function log(uint p0, bool p1, string memory p2) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1116 	}
1117 
1118 	function log(uint p0, bool p1, bool p2) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1120 	}
1121 
1122 	function log(uint p0, bool p1, address p2) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1124 	}
1125 
1126 	function log(uint p0, address p1, uint p2) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1128 	}
1129 
1130 	function log(uint p0, address p1, string memory p2) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1132 	}
1133 
1134 	function log(uint p0, address p1, bool p2) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1136 	}
1137 
1138 	function log(uint p0, address p1, address p2) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1140 	}
1141 
1142 	function log(string memory p0, uint p1, uint p2) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1144 	}
1145 
1146 	function log(string memory p0, uint p1, string memory p2) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1148 	}
1149 
1150 	function log(string memory p0, uint p1, bool p2) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1152 	}
1153 
1154 	function log(string memory p0, uint p1, address p2) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1156 	}
1157 
1158 	function log(string memory p0, string memory p1, uint p2) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1160 	}
1161 
1162 	function log(string memory p0, string memory p1, string memory p2) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1164 	}
1165 
1166 	function log(string memory p0, string memory p1, bool p2) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1168 	}
1169 
1170 	function log(string memory p0, string memory p1, address p2) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1172 	}
1173 
1174 	function log(string memory p0, bool p1, uint p2) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1176 	}
1177 
1178 	function log(string memory p0, bool p1, string memory p2) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1180 	}
1181 
1182 	function log(string memory p0, bool p1, bool p2) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1184 	}
1185 
1186 	function log(string memory p0, bool p1, address p2) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1188 	}
1189 
1190 	function log(string memory p0, address p1, uint p2) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1192 	}
1193 
1194 	function log(string memory p0, address p1, string memory p2) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1196 	}
1197 
1198 	function log(string memory p0, address p1, bool p2) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1200 	}
1201 
1202 	function log(string memory p0, address p1, address p2) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1204 	}
1205 
1206 	function log(bool p0, uint p1, uint p2) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1208 	}
1209 
1210 	function log(bool p0, uint p1, string memory p2) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1212 	}
1213 
1214 	function log(bool p0, uint p1, bool p2) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1216 	}
1217 
1218 	function log(bool p0, uint p1, address p2) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1220 	}
1221 
1222 	function log(bool p0, string memory p1, uint p2) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1224 	}
1225 
1226 	function log(bool p0, string memory p1, string memory p2) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1228 	}
1229 
1230 	function log(bool p0, string memory p1, bool p2) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1232 	}
1233 
1234 	function log(bool p0, string memory p1, address p2) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1236 	}
1237 
1238 	function log(bool p0, bool p1, uint p2) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1240 	}
1241 
1242 	function log(bool p0, bool p1, string memory p2) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1244 	}
1245 
1246 	function log(bool p0, bool p1, bool p2) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1248 	}
1249 
1250 	function log(bool p0, bool p1, address p2) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1252 	}
1253 
1254 	function log(bool p0, address p1, uint p2) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1256 	}
1257 
1258 	function log(bool p0, address p1, string memory p2) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1260 	}
1261 
1262 	function log(bool p0, address p1, bool p2) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1264 	}
1265 
1266 	function log(bool p0, address p1, address p2) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1268 	}
1269 
1270 	function log(address p0, uint p1, uint p2) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1272 	}
1273 
1274 	function log(address p0, uint p1, string memory p2) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1276 	}
1277 
1278 	function log(address p0, uint p1, bool p2) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1280 	}
1281 
1282 	function log(address p0, uint p1, address p2) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1284 	}
1285 
1286 	function log(address p0, string memory p1, uint p2) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1288 	}
1289 
1290 	function log(address p0, string memory p1, string memory p2) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1292 	}
1293 
1294 	function log(address p0, string memory p1, bool p2) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1296 	}
1297 
1298 	function log(address p0, string memory p1, address p2) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1300 	}
1301 
1302 	function log(address p0, bool p1, uint p2) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1304 	}
1305 
1306 	function log(address p0, bool p1, string memory p2) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1308 	}
1309 
1310 	function log(address p0, bool p1, bool p2) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1312 	}
1313 
1314 	function log(address p0, bool p1, address p2) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1316 	}
1317 
1318 	function log(address p0, address p1, uint p2) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1320 	}
1321 
1322 	function log(address p0, address p1, string memory p2) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1324 	}
1325 
1326 	function log(address p0, address p1, bool p2) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1328 	}
1329 
1330 	function log(address p0, address p1, address p2) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1332 	}
1333 
1334 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(uint p0, uint p1, address p2, address p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(uint p0, bool p1, address p2, address p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1532 	}
1533 
1534 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1536 	}
1537 
1538 	function log(uint p0, address p1, uint p2, address p3) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1540 	}
1541 
1542 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1544 	}
1545 
1546 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1548 	}
1549 
1550 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1552 	}
1553 
1554 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1556 	}
1557 
1558 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1560 	}
1561 
1562 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1564 	}
1565 
1566 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1568 	}
1569 
1570 	function log(uint p0, address p1, bool p2, address p3) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1572 	}
1573 
1574 	function log(uint p0, address p1, address p2, uint p3) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1576 	}
1577 
1578 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1580 	}
1581 
1582 	function log(uint p0, address p1, address p2, bool p3) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1584 	}
1585 
1586 	function log(uint p0, address p1, address p2, address p3) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1588 	}
1589 
1590 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1592 	}
1593 
1594 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1596 	}
1597 
1598 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1600 	}
1601 
1602 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1604 	}
1605 
1606 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1608 	}
1609 
1610 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1612 	}
1613 
1614 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1616 	}
1617 
1618 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1620 	}
1621 
1622 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1624 	}
1625 
1626 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1628 	}
1629 
1630 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1632 	}
1633 
1634 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1636 	}
1637 
1638 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1640 	}
1641 
1642 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1644 	}
1645 
1646 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1648 	}
1649 
1650 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1652 	}
1653 
1654 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1656 	}
1657 
1658 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1660 	}
1661 
1662 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1664 	}
1665 
1666 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1668 	}
1669 
1670 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1672 	}
1673 
1674 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1676 	}
1677 
1678 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1680 	}
1681 
1682 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1684 	}
1685 
1686 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1688 	}
1689 
1690 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1692 	}
1693 
1694 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1696 	}
1697 
1698 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1700 	}
1701 
1702 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1704 	}
1705 
1706 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1708 	}
1709 
1710 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1712 	}
1713 
1714 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1716 	}
1717 
1718 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1720 	}
1721 
1722 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1724 	}
1725 
1726 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1728 	}
1729 
1730 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1732 	}
1733 
1734 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1736 	}
1737 
1738 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1740 	}
1741 
1742 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1744 	}
1745 
1746 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1748 	}
1749 
1750 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1752 	}
1753 
1754 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1756 	}
1757 
1758 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1760 	}
1761 
1762 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1764 	}
1765 
1766 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1768 	}
1769 
1770 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1772 	}
1773 
1774 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1776 	}
1777 
1778 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1780 	}
1781 
1782 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1784 	}
1785 
1786 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1788 	}
1789 
1790 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1792 	}
1793 
1794 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1796 	}
1797 
1798 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1800 	}
1801 
1802 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1804 	}
1805 
1806 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1808 	}
1809 
1810 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1812 	}
1813 
1814 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1816 	}
1817 
1818 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1820 	}
1821 
1822 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1824 	}
1825 
1826 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1828 	}
1829 
1830 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1832 	}
1833 
1834 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1836 	}
1837 
1838 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1840 	}
1841 
1842 	function log(string memory p0, address p1, address p2, address p3) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1844 	}
1845 
1846 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1848 	}
1849 
1850 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1852 	}
1853 
1854 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1856 	}
1857 
1858 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1860 	}
1861 
1862 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1864 	}
1865 
1866 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1868 	}
1869 
1870 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1872 	}
1873 
1874 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1876 	}
1877 
1878 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1880 	}
1881 
1882 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1884 	}
1885 
1886 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1888 	}
1889 
1890 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1892 	}
1893 
1894 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1896 	}
1897 
1898 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1900 	}
1901 
1902 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1904 	}
1905 
1906 	function log(bool p0, uint p1, address p2, address p3) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1908 	}
1909 
1910 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1912 	}
1913 
1914 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1916 	}
1917 
1918 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1920 	}
1921 
1922 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1924 	}
1925 
1926 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1928 	}
1929 
1930 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1932 	}
1933 
1934 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1936 	}
1937 
1938 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1940 	}
1941 
1942 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1944 	}
1945 
1946 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1948 	}
1949 
1950 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1952 	}
1953 
1954 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1956 	}
1957 
1958 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1960 	}
1961 
1962 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1964 	}
1965 
1966 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1968 	}
1969 
1970 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1972 	}
1973 
1974 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1976 	}
1977 
1978 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1980 	}
1981 
1982 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1984 	}
1985 
1986 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1988 	}
1989 
1990 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1992 	}
1993 
1994 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1996 	}
1997 
1998 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2000 	}
2001 
2002 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2004 	}
2005 
2006 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2008 	}
2009 
2010 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2012 	}
2013 
2014 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2016 	}
2017 
2018 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2020 	}
2021 
2022 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2024 	}
2025 
2026 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2028 	}
2029 
2030 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2032 	}
2033 
2034 	function log(bool p0, bool p1, address p2, address p3) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2036 	}
2037 
2038 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2040 	}
2041 
2042 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2044 	}
2045 
2046 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2048 	}
2049 
2050 	function log(bool p0, address p1, uint p2, address p3) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2052 	}
2053 
2054 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2056 	}
2057 
2058 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2060 	}
2061 
2062 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2064 	}
2065 
2066 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2068 	}
2069 
2070 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2072 	}
2073 
2074 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2076 	}
2077 
2078 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2080 	}
2081 
2082 	function log(bool p0, address p1, bool p2, address p3) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2084 	}
2085 
2086 	function log(bool p0, address p1, address p2, uint p3) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2088 	}
2089 
2090 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2092 	}
2093 
2094 	function log(bool p0, address p1, address p2, bool p3) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2096 	}
2097 
2098 	function log(bool p0, address p1, address p2, address p3) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2100 	}
2101 
2102 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2104 	}
2105 
2106 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2108 	}
2109 
2110 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2112 	}
2113 
2114 	function log(address p0, uint p1, uint p2, address p3) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2116 	}
2117 
2118 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2120 	}
2121 
2122 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2124 	}
2125 
2126 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2128 	}
2129 
2130 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2132 	}
2133 
2134 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2136 	}
2137 
2138 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2140 	}
2141 
2142 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2144 	}
2145 
2146 	function log(address p0, uint p1, bool p2, address p3) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2148 	}
2149 
2150 	function log(address p0, uint p1, address p2, uint p3) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2152 	}
2153 
2154 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2156 	}
2157 
2158 	function log(address p0, uint p1, address p2, bool p3) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2160 	}
2161 
2162 	function log(address p0, uint p1, address p2, address p3) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2164 	}
2165 
2166 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2168 	}
2169 
2170 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2172 	}
2173 
2174 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2176 	}
2177 
2178 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2180 	}
2181 
2182 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2184 	}
2185 
2186 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2188 	}
2189 
2190 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2192 	}
2193 
2194 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2196 	}
2197 
2198 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2200 	}
2201 
2202 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2204 	}
2205 
2206 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2208 	}
2209 
2210 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2212 	}
2213 
2214 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2216 	}
2217 
2218 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2220 	}
2221 
2222 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2224 	}
2225 
2226 	function log(address p0, string memory p1, address p2, address p3) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2228 	}
2229 
2230 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2232 	}
2233 
2234 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2236 	}
2237 
2238 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2240 	}
2241 
2242 	function log(address p0, bool p1, uint p2, address p3) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2244 	}
2245 
2246 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2248 	}
2249 
2250 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2252 	}
2253 
2254 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2256 	}
2257 
2258 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2260 	}
2261 
2262 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2264 	}
2265 
2266 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2268 	}
2269 
2270 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2272 	}
2273 
2274 	function log(address p0, bool p1, bool p2, address p3) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2276 	}
2277 
2278 	function log(address p0, bool p1, address p2, uint p3) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2280 	}
2281 
2282 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2284 	}
2285 
2286 	function log(address p0, bool p1, address p2, bool p3) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2288 	}
2289 
2290 	function log(address p0, bool p1, address p2, address p3) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2292 	}
2293 
2294 	function log(address p0, address p1, uint p2, uint p3) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2296 	}
2297 
2298 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2300 	}
2301 
2302 	function log(address p0, address p1, uint p2, bool p3) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2304 	}
2305 
2306 	function log(address p0, address p1, uint p2, address p3) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2308 	}
2309 
2310 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2312 	}
2313 
2314 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2316 	}
2317 
2318 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2320 	}
2321 
2322 	function log(address p0, address p1, string memory p2, address p3) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2324 	}
2325 
2326 	function log(address p0, address p1, bool p2, uint p3) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2328 	}
2329 
2330 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2332 	}
2333 
2334 	function log(address p0, address p1, bool p2, bool p3) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2336 	}
2337 
2338 	function log(address p0, address p1, bool p2, address p3) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2340 	}
2341 
2342 	function log(address p0, address p1, address p2, uint p3) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2344 	}
2345 
2346 	function log(address p0, address p1, address p2, string memory p3) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2348 	}
2349 
2350 	function log(address p0, address p1, address p2, bool p3) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2352 	}
2353 
2354 	function log(address p0, address p1, address p2, address p3) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2356 	}
2357 
2358 }
2359 
2360 // File: contracts/KANGO.sol
2361 
2362 //SPDX-License-Identifier: Unlicense
2363 pragma solidity = 0.8.7;
2364 
2365 
2366 
2367 
2368 
2369 
2370 
2371 
2372 
2373 
2374 contract KANGO is ERC20, Ownable {
2375 
2376     modifier lockSwap {
2377         _inSwap = true;
2378         _;
2379         _inSwap = false;
2380     }
2381 
2382     modifier liquidityAdd {
2383         _inLiquidityAdd = true;
2384         _;
2385         _inLiquidityAdd = false;
2386     }
2387 
2388     bool internal _inSwap = false;
2389     bool internal _inLiquidityAdd = false;
2390     bool public tradingActive = false;
2391     address internal _pair;
2392 
2393     uint public constant MAX_SUPPLY = 100_000_000 ether;
2394 
2395     uint internal _maxTransfer = 5;
2396 
2397     uint public buyTax = 90;
2398     uint public sellTax = 90;
2399     uint public antiJeetTax = 240;
2400 
2401     uint public minSwapThreshold = 100_000 ether;
2402     uint public maxWallet = 1_000_000 ether;
2403     bool public swapFees = true;
2404 
2405     address payable public marketingWallet;
2406 
2407     uint internal _totalSupply = 0;
2408     IUniswapV2Router02 internal _router = IUniswapV2Router02(address(0));
2409 
2410     mapping(address => uint) private _balances;
2411     mapping(address => bool) private _taxExcluded;
2412     mapping(address => uint256) public taxReliefStartDate;
2413 
2414     constructor(
2415         address _uniswapFactory,
2416         address _uniswapRouter,
2417         address payable _marketingWallet
2418     ) ERC20("KANGO", "KANGO") Ownable() {
2419         addTaxExcluded(owner());
2420         addTaxExcluded(address(0));
2421         addTaxExcluded(_marketingWallet);
2422         addTaxExcluded(address(this));
2423 
2424         marketingWallet = _marketingWallet;
2425 
2426         _router = IUniswapV2Router02(_uniswapRouter);
2427         IUniswapV2Factory uniswapContract = IUniswapV2Factory(_uniswapFactory);
2428         _pair = uniswapContract.createPair(address(this), _router.WETH());
2429     }
2430 
2431     /// @notice Change the address of the marketing wallet
2432     /// @param _marketingWallet The new address of the marketing wallet
2433     function setMarketingWallet(address payable _marketingWallet) external onlyOwner() {
2434         marketingWallet = _marketingWallet;
2435     }
2436 
2437     /// @notice Change the buy tax rate
2438     /// @param _buyTax - 1 digit precision e.g. _buyTax = 60 results in a 6% buy tax
2439     function setBuyTax(uint _buyTax) external onlyOwner() {
2440         require(_buyTax <= 900, "Buy tax cannot be higher than 90%");
2441         buyTax = _buyTax;
2442     }
2443 
2444     /// @notice Change the sell tax rate
2445     /// @param _sellTax - 1 digit precision e.g. _sellTax = 60 results in a 6% sell tax
2446     function setSellTax(uint _sellTax) external onlyOwner() {
2447         require(_sellTax <= 900, "Sell tax cannot be higher than 90%");
2448         sellTax = _sellTax;
2449     }
2450 
2451     /// @notice Change the anti-jeet sell tax rate
2452     /// @param _antiJeetTax - 1 digit precision e.g. _antiJeetTax = 200 results in a 20% anti-jeet sell tax
2453     function setAntiJeetTax(uint _antiJeetTax) external onlyOwner() {
2454         require(_antiJeetTax <= 900, "Anti-jeet sell tax cannot be higher than 90%");
2455         antiJeetTax = _antiJeetTax;
2456     }
2457 
2458     /// @notice Change the minimum contract KANGO balance before `_swap` gets invoked
2459     /// @param _minSwapThreshold The new minimum balance
2460     function setMinSwapThreshold(uint _minSwapThreshold) external onlyOwner() {
2461         minSwapThreshold = _minSwapThreshold;
2462     }
2463 
2464     /// @notice Rescue KANGO from the marketing amount
2465     /// @dev Should only be used in an emergency
2466     /// @param _amount The amount of KANGO to rescue
2467     /// @param _recipient The recipient of the rescued KANGO
2468     function rescueMarketingTokens(uint _amount, address _recipient) external onlyOwner() {
2469         uint amount = balanceOf(address(this));
2470         uint marketingAmount = amount / 2;
2471         require(_amount <= marketingAmount, "Amount cannot be greater than the available marketing tokens");
2472         _rawTransfer(address(this), _recipient, _amount);
2473     }
2474 
2475     /// @notice Rescue KANGO from the liquidity amount
2476     /// @dev Should only be used in an emergency
2477     /// @param _amount The amount of KANGO to rescue
2478     /// @param _recipient The recipient of the rescued KANGO
2479     function rescueLiquidityTokens(uint _amount, address _recipient) external onlyOwner() {
2480         uint amount = balanceOf(address(this));
2481         uint liquidityAmount = amount / 2;
2482         require(_amount <= liquidityAmount, "Amount cannot be greater than the available liquidity tokens");
2483         _rawTransfer(address(this), _recipient, _amount);
2484     }
2485 
2486     /// @notice Add to the liquidity
2487     /// @param tokens Amount of KANGO tokens
2488     function addLiquidity(uint tokens) external payable onlyOwner() liquidityAdd {
2489         _mint(address(this), tokens);
2490         _approve(address(this), address(_router), tokens);
2491 
2492         _router.addLiquidityETH{value : msg.value}(
2493             address(this),
2494             tokens,
2495             0,
2496             0,
2497             owner(),
2498             block.timestamp
2499         );
2500     }
2501 
2502     /// @notice Enables trading on Uniswap v2
2503     function enableTrading() external onlyOwner {
2504         tradingActive = true;
2505     }
2506 
2507     /// @notice Disables trading on Uniswap v2
2508     function disableTrading() external onlyOwner {
2509         tradingActive = false;
2510     }
2511 
2512     /// @notice Check if a wallet is excluded from tax
2513     /// @param account Address
2514     function isTaxExcluded(address account) public view returns (bool) {
2515         return _taxExcluded[account];
2516     }
2517 
2518     /// @notice Add a wallet to be excluded from tax
2519     /// @param account Address
2520     function addTaxExcluded(address account) public onlyOwner() {
2521         require(!isTaxExcluded(account), "Account must not be excluded");
2522 
2523         _taxExcluded[account] = true;
2524     }
2525 
2526     /// @notice Remove a wallet from being excluded from tax
2527     /// @param account Address
2528     function removeTaxExcluded(address account) external onlyOwner() {
2529         require(isTaxExcluded(account), "Account must not be excluded");
2530 
2531         _taxExcluded[account] = false;
2532     }
2533 
2534     function balanceOf(address account)
2535     public
2536     view
2537     virtual
2538     override
2539     returns (uint)
2540     {
2541         return _balances[account];
2542     }
2543 
2544     function _addBalance(address account, uint amount) internal {
2545         _balances[account] = _balances[account] + amount;
2546     }
2547 
2548     function _subtractBalance(address account, uint amount) internal {
2549         _balances[account] = _balances[account] - amount;
2550     }
2551 
2552     function _transfer(
2553         address sender,
2554         address recipient,
2555         uint amount
2556     ) internal override {
2557         if (isTaxExcluded(sender) || isTaxExcluded(recipient)) {
2558             _rawTransfer(sender, recipient, amount);
2559             return;
2560         }
2561 
2562         uint maxTxAmount = totalSupply() * _maxTransfer / 1000;
2563         require(amount <= maxTxAmount || _inLiquidityAdd || _inSwap || recipient == address(_router), "Exceeds max transaction amount");
2564 
2565         uint amountToSwap = balanceOf(address(this));
2566         bool overMinSwapThreshold = amountToSwap >= minSwapThreshold;
2567 
2568         if (
2569             overMinSwapThreshold &&
2570             !_inSwap &&
2571             sender != _pair &&
2572             swapFees
2573         ) {
2574             _swap(minSwapThreshold);
2575         }
2576 
2577         uint send = amount;
2578         if (sender == _pair || recipient == _pair) {
2579             require(tradingActive, "Trading is not yet active");
2580             if (sender == _pair) {
2581                 // buy
2582                 if (balanceOf(recipient) <= 1 ether) {
2583                     taxReliefStartDate[recipient] = block.timestamp;
2584                 }
2585                 send = _getTaxAmounts(buyTax, amount);
2586                 require(balanceOf(recipient) + send <= maxWallet, "Cannot buy over the maximum wallet limit");
2587             }
2588             if (recipient == _pair) {
2589                 // sell
2590                 uint userTaxReliefStartDate = getTaxReliefStartDate(sender);
2591                 uint userSellTax = sellTax;
2592                 if (userTaxReliefStartDate > 0 && block.timestamp < userTaxReliefStartDate + 1 days) {
2593                     userSellTax = antiJeetTax;
2594                 }
2595                 send = _getTaxAmounts(userSellTax, amount);
2596             }
2597         } else {
2598             // normal transfer between wallets
2599             if (balanceOf(recipient) <= 1 ether) {
2600                 taxReliefStartDate[recipient] = block.timestamp;
2601             }
2602             require(balanceOf(recipient) + send <= maxWallet, "Cannot transfer to a wallet that would exceed the maximum wallet limit");
2603         }
2604         _rawTransfer(sender, recipient, send);
2605 
2606         uint totalAmount = amount - send;
2607         _rawTransfer(sender, address(this), totalAmount);
2608     }
2609 
2610     /// @notice Perform a Uniswap v2 swap from KANGO to ETH and handle tax distribution
2611     /// @param amount The amount of KANGO to swap in wei
2612     /// @dev `amount` is always <= this contract's ETH balance. Calculate and distribute marketing and reflection taxes
2613     function _swap(uint amount) internal lockSwap {
2614         uint liquidityAmount = amount / 2;
2615         // put aside half for liquidity
2616         uint totalTokensToSwap = amount - (liquidityAmount / 2);
2617 
2618         // approve the total amount so that the KANGO->ETH swap can take place as well as the addition to liquidity
2619         uint contractEthBalance = address(this).balance;
2620         _approve(address(this), address(_router), amount);
2621 
2622         address[] memory path = new address[](2);
2623         path[0] = address(this);
2624         path[1] = _router.WETH();
2625         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2626             totalTokensToSwap,
2627             0,
2628             path,
2629             address(this),
2630             block.timestamp
2631         );
2632 
2633         uint tradeValue = address(this).balance - contractEthBalance;
2634         uint marketing = tradeValue * 2 / 3;
2635         uint liquidity = tradeValue - marketing;
2636 
2637         marketingWallet.transfer(marketing);
2638         _addToKANGOLiquidity(liquidityAmount, liquidity);
2639     }
2640 
2641     function getTaxReliefStartDate(address addr) public view returns (uint256) {
2642         return taxReliefStartDate[addr];
2643     }
2644 
2645     function _addToKANGOLiquidity(uint tokenAmount, uint ethAmount) private liquidityAdd {
2646         _approve(address(this), address(_router), tokenAmount);
2647         _router.addLiquidityETH{value : ethAmount}(
2648             address(this),
2649             tokenAmount,
2650             0,
2651             0,
2652             address(0xdead),
2653             block.timestamp
2654         );
2655     }
2656 
2657     function swapAll() external onlyOwner() {
2658         uint maxTxAmount = totalSupply() * _maxTransfer / 1000;
2659         uint amountToSwap = balanceOf(address(this));
2660 
2661         if (amountToSwap >= maxTxAmount)
2662         {
2663             amountToSwap = maxTxAmount;
2664         }
2665 
2666         if (
2667             !_inSwap
2668         ) {
2669             _swap(amountToSwap);
2670         }
2671     }
2672 
2673     function withdrawAll() external onlyOwner() {
2674         payable(owner()).transfer(address(this).balance);
2675     }
2676 
2677     function _getTaxAmounts(uint tax, uint amount)
2678     internal pure returns (uint send)
2679     {
2680         uint totalTaxAmount = amount * tax / 1000;
2681         uint marketingTaxAmount = totalTaxAmount / 2;
2682         uint liquidityTaxAmount = totalTaxAmount - marketingTaxAmount;
2683         send = amount - marketingTaxAmount - liquidityTaxAmount;
2684     }
2685 
2686     function _rawTransfer(
2687         address sender,
2688         address recipient,
2689         uint amount
2690     ) internal {
2691         require(sender != address(0) && recipient != address(0), "transfer from the zero address");
2692         uint senderBalance = balanceOf(sender);
2693         require(senderBalance >= amount, "transfer amount exceeds balance");
2694         _subtractBalance(sender, amount);
2695         _addBalance(recipient, amount);
2696         emit Transfer(sender, recipient, amount);
2697     }
2698 
2699     /// @notice Set a maximum possible transfer limit
2700     /// @param maxTransfer - 1 digit precision in percent e.g. maxTransfer = 10 results in a maximum transfer limit of 1% for a given transfer
2701     function setMaxTransfer(uint maxTransfer) external onlyOwner() {
2702         require(maxTransfer <= maxWallet, "Max transfer cannot exceed max wallet");
2703         _maxTransfer = maxTransfer;
2704     }
2705 
2706     /// @notice Set a maximum wallet limit
2707     /// @param _maxWallet - maximum number of tokens (including 18 decimals)
2708     function setMaxWallet(uint _maxWallet) external onlyOwner() {
2709         require(_maxWallet <= totalSupply(), "Max wallet cannot exceed 100%");
2710         maxWallet = _maxWallet;
2711     }
2712 
2713     /// @notice Enable/disable whether or not swaps should occur
2714     /// @param _swapFees enabled = true, disabled = false
2715     function setSwapFees(bool _swapFees) external onlyOwner() {
2716         swapFees = _swapFees;
2717     }
2718 
2719     function totalSupply() public view override returns (uint) {
2720         return _totalSupply;
2721     }
2722 
2723     function _mint(address account, uint amount) internal override {
2724         require(_totalSupply + amount <= MAX_SUPPLY, "Max supply exceeded");
2725         _totalSupply += amount;
2726         _addBalance(account, amount);
2727         emit Transfer(address(0), account, amount);
2728     }
2729 
2730     function mint(address account, uint amount) external onlyOwner() {
2731         _mint(account, amount);
2732     }
2733 
2734     function airdrop(address[] memory accounts, uint[] memory amounts) external onlyOwner() {
2735         require(accounts.length == amounts.length, "array lengths must match");
2736 
2737         for (uint i = 0; i < accounts.length; i++) {
2738             _mint(accounts[i], amounts[i]);
2739         }
2740     }
2741 
2742     receive() external payable {}
2743 }