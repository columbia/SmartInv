1 /**
2 https://www.0xculture.net/
3 https://t.me/CULTuretoken
4 */
5 
6 pragma solidity ^0.6.12;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 /*
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
125         return msg.data;
126     }
127 }
128 
129 contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor () public {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         emit OwnershipTransferred(address(0), msgSender);
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(_owner == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         emit OwnershipTransferred(_owner, address(0));
167         _owner = address(0);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         emit OwnershipTransferred(_owner, newOwner);
177         _owner = newOwner;
178     }
179 }
180 
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      *
190      * - Addition cannot overflow.
191      */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         require(c >= a, "SafeMath: addition overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b <= a, errorMessage);
225         uint256 c = a - b;
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the multiplication of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `*` operator.
235      *
236      * Requirements:
237      *
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return div(a, b, "SafeMath: division by zero");
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b > 0, errorMessage);
284         uint256 c = a / b;
285         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
292      * Reverts when dividing by zero.
293      *
294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
295      * opcode (which leaves remaining gas untouched) while Solidity uses an
296      * invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b != 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 interface IUniswapV2Pair {
325     event Approval(address indexed owner, address indexed spender, uint value);
326     event Transfer(address indexed from, address indexed to, uint value);
327 
328     function name() external pure returns (string memory);
329     function symbol() external pure returns (string memory);
330     function decimals() external pure returns (uint8);
331     function totalSupply() external view returns (uint);
332     function balanceOf(address owner) external view returns (uint);
333     function allowance(address owner, address spender) external view returns (uint);
334 
335     function approve(address spender, uint value) external returns (bool);
336     function transfer(address to, uint value) external returns (bool);
337     function transferFrom(address from, address to, uint value) external returns (bool);
338 
339     function DOMAIN_SEPARATOR() external view returns (bytes32);
340     function PERMIT_TYPEHASH() external pure returns (bytes32);
341     function nonces(address owner) external view returns (uint);
342 
343     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
344 
345     event Mint(address indexed sender, uint amount0, uint amount1);
346     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
347     event Swap(
348         address indexed sender,
349         uint amount0In,
350         uint amount1In,
351         uint amount0Out,
352         uint amount1Out,
353         address indexed to
354     );
355     event Sync(uint112 reserve0, uint112 reserve1);
356 
357     function MINIMUM_LIQUIDITY() external pure returns (uint);
358     function factory() external view returns (address);
359     function token0() external view returns (address);
360     function token1() external view returns (address);
361     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
362     function price0CumulativeLast() external view returns (uint);
363     function price1CumulativeLast() external view returns (uint);
364     function kLast() external view returns (uint);
365 
366     function mint(address to) external returns (uint liquidity);
367     function burn(address to) external returns (uint amount0, uint amount1);
368     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
369     function skim(address to) external;
370     function sync() external;
371 
372     function initialize(address, address) external;
373 }
374 
375 interface IUniswapV2Factory {
376     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
377 
378     function feeTo() external view returns (address);
379     function feeToSetter() external view returns (address);
380 
381     function getPair(address tokenA, address tokenB) external view returns (address pair);
382     function allPairs(uint) external view returns (address pair);
383     function allPairsLength() external view returns (uint);
384 
385     function createPair(address tokenA, address tokenB) external returns (address pair);
386 
387     function setFeeTo(address) external;
388     function setFeeToSetter(address) external;
389 }
390 
391 interface IUniswapV2Router01 {
392     function factory() external pure returns (address);
393     function WETH() external pure returns (address);
394 
395     function addLiquidity(
396         address tokenA,
397         address tokenB,
398         uint amountADesired,
399         uint amountBDesired,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountA, uint amountB, uint liquidity);
405     function addLiquidityETH(
406         address token,
407         uint amountTokenDesired,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline
412     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
413     function removeLiquidity(
414         address tokenA,
415         address tokenB,
416         uint liquidity,
417         uint amountAMin,
418         uint amountBMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountA, uint amountB);
422     function removeLiquidityETH(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountToken, uint amountETH);
430     function removeLiquidityWithPermit(
431         address tokenA,
432         address tokenB,
433         uint liquidity,
434         uint amountAMin,
435         uint amountBMin,
436         address to,
437         uint deadline,
438         bool approveMax, uint8 v, bytes32 r, bytes32 s
439     ) external returns (uint amountA, uint amountB);
440     function removeLiquidityETHWithPermit(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline,
447         bool approveMax, uint8 v, bytes32 r, bytes32 s
448     ) external returns (uint amountToken, uint amountETH);
449     function swapExactTokensForTokens(
450         uint amountIn,
451         uint amountOutMin,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external returns (uint[] memory amounts);
456     function swapTokensForExactTokens(
457         uint amountOut,
458         uint amountInMax,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external returns (uint[] memory amounts);
463     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
471         external
472         returns (uint[] memory amounts);
473     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
474         external
475         payable
476         returns (uint[] memory amounts);
477 
478     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
479     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
480     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
481     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
482     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
483 }
484 
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountETH);
494     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountETH);
503 
504     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactETHForTokensSupportingFeeOnTransferTokens(
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external payable;
517     function swapExactTokensForETHSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524 }
525 
526 /**
527  * @dev Implementation of the {IERC20} interface.
528  *
529  * This implementation is agnostic to the way tokens are created. This means
530  * that a supply mechanism has to be added in a derived contract using {_mint}.
531  * For a generic mechanism see {ERC20PresetMinterPauser}.
532  *
533  * TIP: For a detailed writeup see our guide
534  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
535  * to implement supply mechanisms].
536  *
537  * We have followed general OpenZeppelin guidelines: functions revert instead
538  * of returning `false` on failure. This behavior is nonetheless conventional
539  * and does not conflict with the expectations of ERC20 applications.
540  *
541  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
542  * This allows applications to reconstruct the allowance for all accounts just
543  * by listening to said events. Other implementations of the EIP may not emit
544  * these events, as it isn't required by the specification.
545  *
546  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
547  * functions have been added to mitigate the well-known issues around setting
548  * allowances. See {IERC20-approve}.
549  */
550 contract ERC20 is Context, IERC20, IERC20Metadata {
551     using SafeMath for uint256;
552 
553     mapping(address => uint256) private _balances;
554 
555     mapping(address => mapping(address => uint256)) private _allowances;
556 
557     uint256 private _totalSupply;
558 
559     string private _name;
560     string private _symbol;
561 
562     /**
563      * @dev Sets the values for {name} and {symbol}.
564      *
565      * The default value of {decimals} is 18. To select a different value for
566      * {decimals} you should overload it.
567      *
568      * All two of these values are immutable: they can only be set once during
569      * construction.
570      */
571     constructor(string memory name_, string memory symbol_) public {
572         _name = name_;
573         _symbol = symbol_;
574     }
575 
576     /**
577      * @dev Returns the name of the token.
578      */
579     function name() public view virtual override returns (string memory) {
580         return _name;
581     }
582 
583     /**
584      * @dev Returns the symbol of the token, usually a shorter version of the
585      * name.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     /**
592      * @dev Returns the number of decimals used to get its user representation.
593      * For example, if `decimals` equals `2`, a balance of `505` tokens should
594      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
595      *
596      * Tokens usually opt for a value of 18, imitating the relationship between
597      * Ether and Wei. This is the value {ERC20} uses, unless this function is
598      * overridden;
599      *
600      * NOTE: This information is only used for _display_ purposes: it in
601      * no way affects any of the arithmetic of the contract, including
602      * {IERC20-balanceOf} and {IERC20-transfer}.
603      */
604     function decimals() public view virtual override returns (uint8) {
605         return 9;
606     }
607 
608     /**
609      * @dev See {IERC20-totalSupply}.
610      */
611     function totalSupply() public view virtual override returns (uint256) {
612         return _totalSupply;
613     }
614 
615     /**
616      * @dev See {IERC20-balanceOf}.
617      */
618     function balanceOf(address account) public view virtual override returns (uint256) {
619         return _balances[account];
620     }
621 
622     /**
623      * @dev See {IERC20-transfer}.
624      *
625      * Requirements:
626      *
627      * - `recipient` cannot be the zero address.
628      * - the caller must have a balance of at least `amount`.
629      */
630     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
631         _transfer(_msgSender(), recipient, amount);
632         return true;
633     }
634 
635     /**
636      * @dev See {IERC20-allowance}.
637      */
638     function allowance(address owner, address spender) public view virtual override returns (uint256) {
639         return _allowances[owner][spender];
640     }
641 
642     /**
643      * @dev See {IERC20-approve}.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      */
649     function approve(address spender, uint256 amount) public virtual override returns (bool) {
650         _approve(_msgSender(), spender, amount);
651         return true;
652     }
653 
654     /**
655      * @dev See {IERC20-transferFrom}.
656      *
657      * Emits an {Approval} event indicating the updated allowance. This is not
658      * required by the EIP. See the note at the beginning of {ERC20}.
659      *
660      * Requirements:
661      *
662      * - `sender` and `recipient` cannot be the zero address.
663      * - `sender` must have a balance of at least `amount`.
664      * - the caller must have allowance for ``sender``'s tokens of at least
665      * `amount`.
666      */
667     function transferFrom(
668         address sender,
669         address recipient,
670         uint256 amount
671     ) public virtual override returns (bool) {
672         _transfer(sender, recipient, amount);
673         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
674         return true;
675     }
676 
677     /**
678      * @dev Atomically increases the allowance granted to `spender` by the caller.
679      *
680      * This is an alternative to {approve} that can be used as a mitigation for
681      * problems described in {IERC20-approve}.
682      *
683      * Emits an {Approval} event indicating the updated allowance.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      */
689     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
690         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
691         return true;
692     }
693 
694     /**
695      * @dev Atomically decreases the allowance granted to `spender` by the caller.
696      *
697      * This is an alternative to {approve} that can be used as a mitigation for
698      * problems described in {IERC20-approve}.
699      *
700      * Emits an {Approval} event indicating the updated allowance.
701      *
702      * Requirements:
703      *
704      * - `spender` cannot be the zero address.
705      * - `spender` must have allowance for the caller of at least
706      * `subtractedValue`.
707      */
708     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
709         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
710         return true;
711     }
712 
713     /**
714      * @dev Moves tokens `amount` from `sender` to `recipient`.
715      *
716      * This is internal function is equivalent to {transfer}, and can be used to
717      * e.g. implement automatic token fees, slashing mechanisms, etc.
718      *
719      * Emits a {Transfer} event.
720      *
721      * Requirements:
722      *
723      * - `sender` cannot be the zero address.
724      * - `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      */
727     function _transfer(
728         address sender,
729         address recipient,
730         uint256 amount
731     ) internal virtual {
732         require(sender != address(0), "ERC20: transfer from the zero address");
733         require(recipient != address(0), "ERC20: transfer to the zero address");
734 
735         _beforeTokenTransfer(sender, recipient, amount);
736 
737         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
738         _balances[recipient] = _balances[recipient].add(amount);
739         emit Transfer(sender, recipient, amount);
740     }
741 
742     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
743      * the total supply.
744      *
745      * Emits a {Transfer} event with `from` set to the zero address.
746      *
747      * Requirements:
748      *
749      * - `account` cannot be the zero address.
750      */
751     function _mint(address account, uint256 amount) internal virtual {
752         require(account != address(0), "ERC20: mint to the zero address");
753 
754         _beforeTokenTransfer(address(0), account, amount);
755 
756         _totalSupply = _totalSupply.add(amount);
757         _balances[account] = _balances[account].add(amount);
758         emit Transfer(address(0), account, amount);
759     }
760 
761     /**
762      * @dev Destroys `amount` tokens from `account`, reducing the
763      * total supply.
764      *
765      * Emits a {Transfer} event with `to` set to the zero address.
766      *
767      * Requirements:
768      *
769      * - `account` cannot be the zero address.
770      * - `account` must have at least `amount` tokens.
771      */
772     function _burn(address account, uint256 amount) internal virtual {
773         require(account != address(0), "ERC20: burn from the zero address");
774 
775         _beforeTokenTransfer(account, address(0), amount);
776 
777         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
778         _totalSupply = _totalSupply.sub(amount);
779         emit Transfer(account, address(0), amount);
780     }
781 
782     /**
783      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
784      *
785      * This internal function is equivalent to `approve`, and can be used to
786      * e.g. set automatic allowances for certain subsystems, etc.
787      *
788      * Emits an {Approval} event.
789      *
790      * Requirements:
791      *
792      * - `owner` cannot be the zero address.
793      * - `spender` cannot be the zero address.
794      */
795     function _approve(
796         address owner,
797         address spender,
798         uint256 amount
799     ) internal virtual {
800         require(owner != address(0), "ERC20: approve from the zero address");
801         require(spender != address(0), "ERC20: approve to the zero address");
802 
803         _allowances[owner][spender] = amount;
804         emit Approval(owner, spender, amount);
805     }
806 
807     /**
808      * @dev Hook that is called before any transfer of tokens. This includes
809      * minting and burning.
810      *
811      * Calling conditions:
812      *
813      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
814      * will be to transferred to `to`.
815      * - when `from` is zero, `amount` tokens will be minted for `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal virtual {}
826 }
827 
828 contract CULTure is ERC20, Ownable {
829     using SafeMath for uint256;
830 
831     address public constant DEAD_ADDRESS = address(0xdead);
832     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
833 
834     uint256 public buyLiquidityFee = 1;
835     uint256 public sellLiquidityFee = 1;
836     uint256 public buyTxFee = 9;
837     uint256 public sellTxFee = 9;
838     uint256 public tokensForLiquidity;
839     uint256 public tokensForTax;
840 
841     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
842     uint256 public swapAtAmount = _tTotal.mul(10).div(10000);       // 0.10% of total supply
843     uint256 public maxTxLimit = _tTotal.mul(50).div(10000);         // 0.50% of total supply
844     uint256 public maxWalletLimit = _tTotal.mul(100).div(10000);    // 1.00% of total supply
845 
846     address public dev;
847     address public uniswapV2Pair;
848 
849     uint256 private launchBlock;
850     bool private swapping;
851     bool public isLaunched;
852 
853     // exclude from fees
854     mapping (address => bool) public isExcludedFromFees;
855 
856     // exclude from max transaction amount
857     mapping (address => bool) public isExcludedFromTxLimit;
858 
859     // exclude from max wallet limit
860     mapping (address => bool) public isExcludedFromWalletLimit;
861 
862     // if the account is blacklisted from transacting
863     mapping (address => bool) public isBlacklisted;
864 
865 
866     constructor(address _dev) public ERC20("CULTure", "CULTure") {
867 
868         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
869         _approve(address(this), address(uniswapV2Router), type(uint256).max);
870 
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
907     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
908         buyLiquidityFee = liquidityFee;
909         buyTxFee = txFee;
910     }
911 
912     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
913         sellLiquidityFee = liquidityFee;
914         sellTxFee = txFee;
915     }
916 
917     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
918         maxTxLimit = newLimit * (10**9);
919     }
920 
921     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
922         maxWalletLimit = newLimit * (10**9);
923     }
924 
925     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
926         swapAtAmount = amountToSwap * (10**9);
927     }
928 
929     function updateDevWallet(address newWallet) external onlyOwner() {
930         dev = newWallet;
931     }
932 
933     function addBlacklist(address account) external onlyOwner() {
934         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
935         require(account != uniswapV2Pair, "Cannot blacklist pair");
936         _setBlacklist(account, true);
937     }
938 
939     function removeBlacklist(address account) external onlyOwner() {
940         require(isBlacklisted[account], "Blacklist: Not blacklisted");
941         _setBlacklist(account, false);
942     }
943 
944     function BeginAscension() external onlyOwner() {
945         require(!isLaunched, "Contract is already launched");
946         isLaunched = true;
947         launchBlock = block.number;
948     }
949 
950     function _transfer(address from, address to, uint256 amount) internal override {
951         require(from != address(0), "transfer from the zero address");
952         require(to != address(0), "transfer to the zero address");
953         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
954         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
955         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
956         require(!isBlacklisted[from], "Sender is blacklisted");
957 
958         if(amount == 0) {
959             super._transfer(from, to, 0);
960             return;
961         }
962 
963         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
964         bool canSwap = totalTokensForFee >= swapAtAmount;
965 
966         if(
967             from != uniswapV2Pair &&
968             canSwap &&
969             !swapping
970         ) {
971             swapping = true;
972             swapBack(totalTokensForFee);
973             swapping = false;
974         } else if(
975             from == uniswapV2Pair &&
976             to != uniswapV2Pair &&
977             block.number < launchBlock + 1 &&
978             !isExcludedFromFees[to]
979         ) {
980             _setBlacklist(to, true);
981         }
982 
983         bool takeFee = !swapping;
984 
985         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
986             takeFee = false;
987         }
988 
989         if(takeFee) {
990             uint256 fees;
991             // on sell
992             if (to == uniswapV2Pair) {
993                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
994                 fees = amount.mul(sellTotalFees).div(100);
995                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
996                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
997             }
998             // on buy & wallet transfers
999             else {
1000                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
1001                 fees = amount.mul(buyTotalFees).div(100);
1002                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
1003                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
1004             }
1005 
1006             if(fees > 0){
1007                 super._transfer(from, address(this), fees);
1008                 amount = amount.sub(fees);
1009             }
1010         }
1011 
1012         super._transfer(from, to, amount);
1013     }
1014 
1015     function swapBack(uint256 totalTokensForFee) private {
1016         uint256 toSwap = swapAtAmount;
1017 
1018         // Halve the amount of liquidity tokens
1019         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
1020         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
1021         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
1022 
1023         _swapTokensForETH(amountToSwapForETH);
1024 
1025         uint256 ethBalance = address(this).balance;
1026         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
1027         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
1028 
1029         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
1030         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
1031 
1032         payable(address(dev)).transfer(ethForTax);
1033         _addLiquidity(liquidityTokens, ethForLiquidity);
1034     }
1035 
1036     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1037 
1038         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1039             address(this),
1040             tokenAmount,
1041             0,
1042             0,
1043             DEAD_ADDRESS,
1044             block.timestamp
1045         );
1046     }
1047 
1048     function _swapTokensForETH(uint256 tokenAmount) private {
1049 
1050         address[] memory path = new address[](2);
1051         path[0] = address(this);
1052         path[1] = uniswapV2Router.WETH();
1053 
1054         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1055             tokenAmount,
1056             0,
1057             path,
1058             address(this),
1059             block.timestamp
1060         );
1061     }
1062 
1063     function _setBlacklist(address account, bool value) internal {
1064         isBlacklisted[account] = value;
1065     }
1066 
1067     receive() external payable {}
1068 }