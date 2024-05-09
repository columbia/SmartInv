1 /*
2 
3 Telegram
4 https://t.me/Shibagun
5 
6 Website
7 https://shibashogun.com/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.6.12;
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 /*
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
132         return msg.data;
133     }
134 }
135 
136 contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor () public {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
188 library SafeMath {
189     /**
190      * @dev Returns the addition of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `+` operator.
194      *
195      * Requirements:
196      *
197      * - Addition cannot overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         uint256 c = a + b;
201         require(c >= a, "SafeMath: addition overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      *
214      * - Subtraction cannot overflow.
215      */
216     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217         return sub(a, b, "SafeMath: subtraction overflow");
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b <= a, errorMessage);
232         uint256 c = a - b;
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      *
245      * - Multiplication cannot overflow.
246      */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249         // benefit is lost if 'b' is also tested.
250         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b, "SafeMath: multiplication overflow");
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers. Reverts on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return div(a, b, "SafeMath: division by zero");
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         uint256 c = a / b;
292         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
293 
294         return c;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * Reverts when dividing by zero.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
310         return mod(a, b, "SafeMath: modulo by zero");
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts with custom message when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         require(b != 0, errorMessage);
327         return a % b;
328     }
329 }
330 
331 interface IUniswapV2Pair {
332     event Approval(address indexed owner, address indexed spender, uint value);
333     event Transfer(address indexed from, address indexed to, uint value);
334 
335     function name() external pure returns (string memory);
336     function symbol() external pure returns (string memory);
337     function decimals() external pure returns (uint8);
338     function totalSupply() external view returns (uint);
339     function balanceOf(address owner) external view returns (uint);
340     function allowance(address owner, address spender) external view returns (uint);
341 
342     function approve(address spender, uint value) external returns (bool);
343     function transfer(address to, uint value) external returns (bool);
344     function transferFrom(address from, address to, uint value) external returns (bool);
345 
346     function DOMAIN_SEPARATOR() external view returns (bytes32);
347     function PERMIT_TYPEHASH() external pure returns (bytes32);
348     function nonces(address owner) external view returns (uint);
349 
350     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
351 
352     event Mint(address indexed sender, uint amount0, uint amount1);
353     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
354     event Swap(
355         address indexed sender,
356         uint amount0In,
357         uint amount1In,
358         uint amount0Out,
359         uint amount1Out,
360         address indexed to
361     );
362     event Sync(uint112 reserve0, uint112 reserve1);
363 
364     function MINIMUM_LIQUIDITY() external pure returns (uint);
365     function factory() external view returns (address);
366     function token0() external view returns (address);
367     function token1() external view returns (address);
368     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
369     function price0CumulativeLast() external view returns (uint);
370     function price1CumulativeLast() external view returns (uint);
371     function kLast() external view returns (uint);
372 
373     function mint(address to) external returns (uint liquidity);
374     function burn(address to) external returns (uint amount0, uint amount1);
375     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
376     function skim(address to) external;
377     function sync() external;
378 
379     function initialize(address, address) external;
380 }
381 
382 interface IUniswapV2Factory {
383     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
384 
385     function feeTo() external view returns (address);
386     function feeToSetter() external view returns (address);
387 
388     function getPair(address tokenA, address tokenB) external view returns (address pair);
389     function allPairs(uint) external view returns (address pair);
390     function allPairsLength() external view returns (uint);
391 
392     function createPair(address tokenA, address tokenB) external returns (address pair);
393 
394     function setFeeTo(address) external;
395     function setFeeToSetter(address) external;
396 }
397 
398 interface IUniswapV2Router01 {
399     function factory() external pure returns (address);
400     function WETH() external pure returns (address);
401 
402     function addLiquidity(
403         address tokenA,
404         address tokenB,
405         uint amountADesired,
406         uint amountBDesired,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountA, uint amountB, uint liquidity);
412     function addLiquidityETH(
413         address token,
414         uint amountTokenDesired,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
420     function removeLiquidity(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountA, uint amountB);
429     function removeLiquidityETH(
430         address token,
431         uint liquidity,
432         uint amountTokenMin,
433         uint amountETHMin,
434         address to,
435         uint deadline
436     ) external returns (uint amountToken, uint amountETH);
437     function removeLiquidityWithPermit(
438         address tokenA,
439         address tokenB,
440         uint liquidity,
441         uint amountAMin,
442         uint amountBMin,
443         address to,
444         uint deadline,
445         bool approveMax, uint8 v, bytes32 r, bytes32 s
446     ) external returns (uint amountA, uint amountB);
447     function removeLiquidityETHWithPermit(
448         address token,
449         uint liquidity,
450         uint amountTokenMin,
451         uint amountETHMin,
452         address to,
453         uint deadline,
454         bool approveMax, uint8 v, bytes32 r, bytes32 s
455     ) external returns (uint amountToken, uint amountETH);
456     function swapExactTokensForTokens(
457         uint amountIn,
458         uint amountOutMin,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external returns (uint[] memory amounts);
463     function swapTokensForExactTokens(
464         uint amountOut,
465         uint amountInMax,
466         address[] calldata path,
467         address to,
468         uint deadline
469     ) external returns (uint[] memory amounts);
470     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
471         external
472         payable
473         returns (uint[] memory amounts);
474     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
475         external
476         returns (uint[] memory amounts);
477     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
478         external
479         returns (uint[] memory amounts);
480     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
481         external
482         payable
483         returns (uint[] memory amounts);
484 
485     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
486     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
487     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
488     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
489     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
490 }
491 
492 interface IUniswapV2Router02 is IUniswapV2Router01 {
493     function removeLiquidityETHSupportingFeeOnTransferTokens(
494         address token,
495         uint liquidity,
496         uint amountTokenMin,
497         uint amountETHMin,
498         address to,
499         uint deadline
500     ) external returns (uint amountETH);
501     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
502         address token,
503         uint liquidity,
504         uint amountTokenMin,
505         uint amountETHMin,
506         address to,
507         uint deadline,
508         bool approveMax, uint8 v, bytes32 r, bytes32 s
509     ) external returns (uint amountETH);
510 
511     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
512         uint amountIn,
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external;
518     function swapExactETHForTokensSupportingFeeOnTransferTokens(
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external payable;
524     function swapExactTokensForETHSupportingFeeOnTransferTokens(
525         uint amountIn,
526         uint amountOutMin,
527         address[] calldata path,
528         address to,
529         uint deadline
530     ) external;
531 }
532 
533 /**
534  * @dev Implementation of the {IERC20} interface.
535  *
536  * This implementation is agnostic to the way tokens are created. This means
537  * that a supply mechanism has to be added in a derived contract using {_mint}.
538  * For a generic mechanism see {ERC20PresetMinterPauser}.
539  *
540  * TIP: For a detailed writeup see our guide
541  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
542  * to implement supply mechanisms].
543  *
544  * We have followed general OpenZeppelin guidelines: functions revert instead
545  * of returning `false` on failure. This behavior is nonetheless conventional
546  * and does not conflict with the expectations of ERC20 applications.
547  *
548  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
549  * This allows applications to reconstruct the allowance for all accounts just
550  * by listening to said events. Other implementations of the EIP may not emit
551  * these events, as it isn't required by the specification.
552  *
553  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
554  * functions have been added to mitigate the well-known issues around setting
555  * allowances. See {IERC20-approve}.
556  */
557 contract ERC20 is Context, IERC20, IERC20Metadata {
558     using SafeMath for uint256;
559 
560     mapping(address => uint256) private _balances;
561 
562     mapping(address => mapping(address => uint256)) private _allowances;
563 
564     uint256 private _totalSupply;
565 
566     string private _name;
567     string private _symbol;
568 
569     /**
570      * @dev Sets the values for {name} and {symbol}.
571      *
572      * The default value of {decimals} is 18. To select a different value for
573      * {decimals} you should overload it.
574      *
575      * All two of these values are immutable: they can only be set once during
576      * construction.
577      */
578     constructor(string memory name_, string memory symbol_) public {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev Returns the name of the token.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev Returns the symbol of the token, usually a shorter version of the
592      * name.
593      */
594     function symbol() public view virtual override returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev Returns the number of decimals used to get its user representation.
600      * For example, if `decimals` equals `2`, a balance of `505` tokens should
601      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
602      *
603      * Tokens usually opt for a value of 18, imitating the relationship between
604      * Ether and Wei. This is the value {ERC20} uses, unless this function is
605      * overridden;
606      *
607      * NOTE: This information is only used for _display_ purposes: it in
608      * no way affects any of the arithmetic of the contract, including
609      * {IERC20-balanceOf} and {IERC20-transfer}.
610      */
611     function decimals() public view virtual override returns (uint8) {
612         return 9;
613     }
614 
615     /**
616      * @dev See {IERC20-totalSupply}.
617      */
618     function totalSupply() public view virtual override returns (uint256) {
619         return _totalSupply;
620     }
621 
622     /**
623      * @dev See {IERC20-balanceOf}.
624      */
625     function balanceOf(address account) public view virtual override returns (uint256) {
626         return _balances[account];
627     }
628 
629     /**
630      * @dev See {IERC20-transfer}.
631      *
632      * Requirements:
633      *
634      * - `recipient` cannot be the zero address.
635      * - the caller must have a balance of at least `amount`.
636      */
637     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(_msgSender(), recipient, amount);
639         return true;
640     }
641 
642     /**
643      * @dev See {IERC20-allowance}.
644      */
645     function allowance(address owner, address spender) public view virtual override returns (uint256) {
646         return _allowances[owner][spender];
647     }
648 
649     /**
650      * @dev See {IERC20-approve}.
651      *
652      * Requirements:
653      *
654      * - `spender` cannot be the zero address.
655      */
656     function approve(address spender, uint256 amount) public virtual override returns (bool) {
657         _approve(_msgSender(), spender, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-transferFrom}.
663      *
664      * Emits an {Approval} event indicating the updated allowance. This is not
665      * required by the EIP. See the note at the beginning of {ERC20}.
666      *
667      * Requirements:
668      *
669      * - `sender` and `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      * - the caller must have allowance for ``sender``'s tokens of at least
672      * `amount`.
673      */
674     function transferFrom(
675         address sender,
676         address recipient,
677         uint256 amount
678     ) public virtual override returns (bool) {
679         _transfer(sender, recipient, amount);
680         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
681         return true;
682     }
683 
684     /**
685      * @dev Atomically increases the allowance granted to `spender` by the caller.
686      *
687      * This is an alternative to {approve} that can be used as a mitigation for
688      * problems described in {IERC20-approve}.
689      *
690      * Emits an {Approval} event indicating the updated allowance.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      */
696     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
697         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
698         return true;
699     }
700 
701     /**
702      * @dev Atomically decreases the allowance granted to `spender` by the caller.
703      *
704      * This is an alternative to {approve} that can be used as a mitigation for
705      * problems described in {IERC20-approve}.
706      *
707      * Emits an {Approval} event indicating the updated allowance.
708      *
709      * Requirements:
710      *
711      * - `spender` cannot be the zero address.
712      * - `spender` must have allowance for the caller of at least
713      * `subtractedValue`.
714      */
715     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
716         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
717         return true;
718     }
719 
720     /**
721      * @dev Moves tokens `amount` from `sender` to `recipient`.
722      *
723      * This is internal function is equivalent to {transfer}, and can be used to
724      * e.g. implement automatic token fees, slashing mechanisms, etc.
725      *
726      * Emits a {Transfer} event.
727      *
728      * Requirements:
729      *
730      * - `sender` cannot be the zero address.
731      * - `recipient` cannot be the zero address.
732      * - `sender` must have a balance of at least `amount`.
733      */
734     function _transfer(
735         address sender,
736         address recipient,
737         uint256 amount
738     ) internal virtual {
739         require(sender != address(0), "ERC20: transfer from the zero address");
740         require(recipient != address(0), "ERC20: transfer to the zero address");
741 
742         _beforeTokenTransfer(sender, recipient, amount);
743 
744         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
745         _balances[recipient] = _balances[recipient].add(amount);
746         emit Transfer(sender, recipient, amount);
747     }
748 
749     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
750      * the total supply.
751      *
752      * Emits a {Transfer} event with `from` set to the zero address.
753      *
754      * Requirements:
755      *
756      * - `account` cannot be the zero address.
757      */
758     function _mint(address account, uint256 amount) internal virtual {
759         require(account != address(0), "ERC20: mint to the zero address");
760 
761         _beforeTokenTransfer(address(0), account, amount);
762 
763         _totalSupply = _totalSupply.add(amount);
764         _balances[account] = _balances[account].add(amount);
765         emit Transfer(address(0), account, amount);
766     }
767 
768     /**
769      * @dev Destroys `amount` tokens from `account`, reducing the
770      * total supply.
771      *
772      * Emits a {Transfer} event with `to` set to the zero address.
773      *
774      * Requirements:
775      *
776      * - `account` cannot be the zero address.
777      * - `account` must have at least `amount` tokens.
778      */
779     function _burn(address account, uint256 amount) internal virtual {
780         require(account != address(0), "ERC20: burn from the zero address");
781 
782         _beforeTokenTransfer(account, address(0), amount);
783 
784         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
785         _totalSupply = _totalSupply.sub(amount);
786         emit Transfer(account, address(0), amount);
787     }
788 
789     /**
790      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
791      *
792      * This internal function is equivalent to `approve`, and can be used to
793      * e.g. set automatic allowances for certain subsystems, etc.
794      *
795      * Emits an {Approval} event.
796      *
797      * Requirements:
798      *
799      * - `owner` cannot be the zero address.
800      * - `spender` cannot be the zero address.
801      */
802     function _approve(
803         address owner,
804         address spender,
805         uint256 amount
806     ) internal virtual {
807         require(owner != address(0), "ERC20: approve from the zero address");
808         require(spender != address(0), "ERC20: approve to the zero address");
809 
810         _allowances[owner][spender] = amount;
811         emit Approval(owner, spender, amount);
812     }
813 
814     /**
815      * @dev Hook that is called before any transfer of tokens. This includes
816      * minting and burning.
817      *
818      * Calling conditions:
819      *
820      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
821      * will be to transferred to `to`.
822      * - when `from` is zero, `amount` tokens will be minted for `to`.
823      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
824      * - `from` and `to` are never both zero.
825      *
826      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
827      */
828     function _beforeTokenTransfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal virtual {}
833 }
834 
835 contract SHIBAGUN is ERC20, Ownable {
836     using SafeMath for uint256;
837 
838     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
839 
840     uint256 public txFees = 9;
841 
842     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
843     uint256 public swapAtAmount = _tTotal.mul(10).div(10000);       // 0.10% of total supply
844     uint256 public maxTxLimit = _tTotal.mul(75).div(10000);         // 0.75% of total supply
845     uint256 public maxWalletLimit = _tTotal.mul(150).div(10000);    // 1.50% of total supply
846 
847     address public dev;
848     address public uniswapV2Pair;
849 
850     uint256 private launchBlock;
851     bool private swapping;
852 
853     bool public isLaunched;
854 
855     // exclude from fees
856     mapping (address => bool) public isExcludedFromFees;
857 
858     // exclude from max transaction amount
859     mapping (address => bool) public isExcludedFromTxLimit;
860 
861     // exclude from max wallet limit
862     mapping (address => bool) public isExcludedFromWalletLimit;
863 
864     // if the account is blacklisted from transacting
865     mapping (address => bool) public isBlacklisted;
866 
867 
868     constructor(address _dev) public ERC20("Shiba Shogun", "SHIBAGUN") {
869 
870         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
871 
872         // exclude from fees, wallet limit and transaction limit
873         excludeFromAllLimits(owner(), true);
874         excludeFromAllLimits(address(this), true);
875         excludeFromWalletLimit(uniswapV2Pair, true);
876 
877         dev = _dev;
878 
879         /*
880             _mint is an internal function in ERC20.sol that is only called here,
881             and CANNOT be called ever again
882         */
883         _mint(owner(), _tTotal);
884     }
885 
886     function excludeFromFees(address account, bool value) public onlyOwner() {
887         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
888         isExcludedFromFees[account] = value;
889     }
890 
891     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
892         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
893         isExcludedFromTxLimit[account] = value;
894     }
895 
896     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
897         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
898         isExcludedFromWalletLimit[account] = value;
899     }
900 
901     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
902         excludeFromFees(account, value);
903         excludeFromTxLimit(account, value);
904         excludeFromWalletLimit(account, value);
905     }
906 
907     function setFee(uint256 newFee) external onlyOwner() {
908         txFees = newFee;
909     }
910 
911     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
912         maxTxLimit = newLimit * (10**9);
913     }
914 
915     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
916         maxWalletLimit = newLimit * (10**9);
917     }
918 
919     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
920         swapAtAmount = amountToSwap * (10**9);
921     }
922 
923     function updateDevWallet(address newWallet) external onlyOwner() {
924         dev = newWallet;
925     }
926 
927     function addBlacklist(address account) external onlyOwner() {
928         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
929         require(account != uniswapV2Pair, "Cannot blacklist pair");
930         _setBlacklist(account, true);
931     }
932 
933     function removeBlacklist(address account) external onlyOwner() {
934         require(isBlacklisted[account], "Blacklist: Not blacklisted");
935         _setBlacklist(account, false);
936     }
937 
938     function launchNow() external onlyOwner() {
939         require(!isLaunched, "Contract is already launched");
940         isLaunched = true;
941         launchBlock = block.number;
942     }
943 
944     function _transfer(address from, address to, uint256 amount) internal override {
945         require(from != address(0), "transfer from the zero address");
946         require(to != address(0), "transfer to the zero address");
947         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
948         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
949         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
950         require(!isBlacklisted[from], "Sender is blacklisted");
951 
952         if(amount == 0) {
953             super._transfer(from, to, 0);
954             return;
955         }
956 
957         uint256 contractTokenBalance = balanceOf(address(this));
958         bool canSwap = contractTokenBalance >= swapAtAmount;
959 
960         if(
961             from != uniswapV2Pair &&
962             canSwap &&
963             !swapping
964         ) {
965             swapping = true;
966             _swapTokensForETH(swapAtAmount);
967             swapping = false;
968         } else if(
969             from == uniswapV2Pair && 
970             to != uniswapV2Pair && 
971             block.number < launchBlock + 2 &&
972             !isExcludedFromFees[to]
973         ) {
974             _setBlacklist(to, true);
975         }
976 
977         bool takeFee = !swapping;
978 
979         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
980             takeFee = false;
981         }
982 
983         if(takeFee) {
984             uint256 fees = amount.mul(txFees).div(100);
985             amount = amount.sub(fees);
986             super._transfer(from, address(this), fees);
987         }
988 
989         super._transfer(from, to, amount);
990     }
991 
992     function _swapTokensForETH(uint256 tokenAmount) private {
993 
994         address[] memory path = new address[](2);
995         path[0] = address(this);
996         path[1] = uniswapV2Router.WETH();
997 
998         _approve(address(this), address(uniswapV2Router), tokenAmount);
999 
1000         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1001             tokenAmount,
1002             0,
1003             path,
1004             dev,
1005             block.timestamp
1006         );
1007     }
1008 
1009     function _setBlacklist(address account, bool value) internal {
1010         isBlacklisted[account] = value;
1011     }
1012 
1013     receive() external payable {}
1014 }