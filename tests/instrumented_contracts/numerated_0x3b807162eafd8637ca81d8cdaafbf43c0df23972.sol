1 // SPDX-License-Identifier: MIT                                                                              
2                                                             
3         pragma solidity 0.8.9;
4 
5         abstract contract Context {
6             function _msgSender() internal view virtual returns (address) {
7                 return msg.sender;
8             }
9 
10             function _msgData() internal view virtual returns (bytes calldata) {
11                 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12                 return msg.data;
13             }
14         }
15 
16         interface IUniswapV2Pair {
17             event Approval(address indexed owner, address indexed spender, uint value);
18             event Transfer(address indexed from, address indexed to, uint value);
19 
20             function name() external pure returns (string memory);
21             function symbol() external pure returns (string memory);
22             function decimals() external pure returns (uint8);
23             function totalSupply() external view returns (uint);
24             function balanceOf(address owner) external view returns (uint);
25             function allowance(address owner, address spender) external view returns (uint);
26 
27             function approve(address spender, uint value) external returns (bool);
28             function transfer(address to, uint value) external returns (bool);
29             function transferFrom(address from, address to, uint value) external returns (bool);
30 
31             function DOMAIN_SEPARATOR() external view returns (bytes32);
32             function PERMIT_TYPEHASH() external pure returns (bytes32);
33             function nonces(address owner) external view returns (uint);
34 
35             function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37             event Mint(address indexed sender, uint amount0, uint amount1);
38             event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39             event Swap(
40                 address indexed sender,
41                 uint amount0In,
42                 uint amount1In,
43                 uint amount0Out,
44                 uint amount1Out,
45                 address indexed to
46             );
47             event Sync(uint112 reserve0, uint112 reserve1);
48 
49             function MINIMUM_LIQUIDITY() external pure returns (uint);
50             function factory() external view returns (address);
51             function token0() external view returns (address);
52             function token1() external view returns (address);
53             function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54             function price0CumulativeLast() external view returns (uint);
55             function price1CumulativeLast() external view returns (uint);
56             function kLast() external view returns (uint);
57 
58             function mint(address to) external returns (uint liquidity);
59             function burn(address to) external returns (uint amount0, uint amount1);
60             function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61             function skim(address to) external;
62             function sync() external;
63 
64             function initialize(address, address) external;
65         }
66 
67         interface IUniswapV2Factory {
68             event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70             function feeTo() external view returns (address);
71             function feeToSetter() external view returns (address);
72 
73             function getPair(address tokenA, address tokenB) external view returns (address pair);
74             function allPairs(uint) external view returns (address pair);
75             function allPairsLength() external view returns (uint);
76 
77             function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79             function setFeeTo(address) external;
80             function setFeeToSetter(address) external;
81         }
82 
83         interface IERC20 {
84             /**
85             * @dev Returns the amount of tokens in existence.
86             */
87             function totalSupply() external view returns (uint256);
88 
89             /**
90             * @dev Returns the amount of tokens owned by `account`.
91             */
92             function balanceOf(address account) external view returns (uint256);
93 
94             /**
95             * @dev Moves `amount` tokens from the caller's account to `recipient`.
96             *
97             * Returns a boolean value indicating whether the operation succeeded.
98             *
99             * Emits a {Transfer} event.
100             */
101             function transfer(address recipient, uint256 amount) external returns (bool);
102 
103             /**
104             * @dev Returns the remaining number of tokens that `spender` will be
105             * allowed to spend on behalf of `owner` through {transferFrom}. This is
106             * zero by default.
107             *
108             * This value changes when {approve} or {transferFrom} are called.
109             */
110             function allowance(address owner, address spender) external view returns (uint256);
111 
112             /**
113             * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114             *
115             * Returns a boolean value indicating whether the operation succeeded.
116             *
117             * IMPORTANT: Beware that changing an allowance with this method brings the risk
118             * that someone may use both the old and the new allowance by unfortunate
119             * transaction ordering. One possible solution to mitigate this race
120             * condition is to first reduce the spender's allowance to 0 and set the
121             * desired value afterwards:
122             * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123             *
124             * Emits an {Approval} event.
125             */
126             function approve(address spender, uint256 amount) external returns (bool);
127 
128             /**
129             * @dev Moves `amount` tokens from `sender` to `recipient` using the
130             * allowance mechanism. `amount` is then deducted from the caller's
131             * allowance.
132             *
133             * Returns a boolean value indicating whether the operation succeeded.
134             *
135             * Emits a {Transfer} event.
136             */
137             function transferFrom(
138                 address sender,
139                 address recipient,
140                 uint256 amount
141             ) external returns (bool);
142 
143             /**
144             * @dev Emitted when `value` tokens are moved from one account (`from`) to
145             * another (`to`).
146             *
147             * Note that `value` may be zero.
148             */
149             event Transfer(address indexed from, address indexed to, uint256 value);
150 
151             /**
152             * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153             * a call to {approve}. `value` is the new allowance.
154             */
155             event Approval(address indexed owner, address indexed spender, uint256 value);
156         }
157 
158         interface IERC20Metadata is IERC20 {
159             /**
160             * @dev Returns the name of the token.
161             */
162             function name() external view returns (string memory);
163 
164             /**
165             * @dev Returns the symbol of the token.
166             */
167             function symbol() external view returns (string memory);
168 
169             /**
170             * @dev Returns the decimals places of the token.
171             */
172             function decimals() external view returns (uint8);
173         }
174 
175 
176         contract ERC20 is Context, IERC20, IERC20Metadata {
177             using SafeMath for uint256;
178 
179             mapping(address => uint256) private _balances;
180 
181             mapping(address => mapping(address => uint256)) private _allowances;
182 
183             uint256 private _totalSupply;
184 
185             string private _name;
186             string private _symbol;
187 
188             /**
189             * @dev Sets the values for {name} and {symbol}.
190             *
191             * The default value of {decimals} is 18. To select a different value for
192             * {decimals} you should overload it.
193             *
194             * All two of these values are immutable: they can only be set once during
195             * construction.
196             */
197             constructor(string memory name_, string memory symbol_) {
198                 _name = name_;
199                 _symbol = symbol_;
200             }
201 
202             /**
203             * @dev Returns the name of the token.
204             */
205             function name() public view virtual override returns (string memory) {
206                 return _name;
207             }
208 
209             /**
210             * @dev Returns the symbol of the token, usually a shorter version of the
211             * name.
212             */
213             function symbol() public view virtual override returns (string memory) {
214                 return _symbol;
215             }
216 
217             /**
218             * @dev Returns the number of decimals used to get its user representation.
219             * For example, if `decimals` equals `2`, a balance of `505` tokens should
220             * be displayed to a user as `5,05` (`505 / 10 ** 2`).
221             *
222             * Tokens usually opt for a value of 18, imitating the relationship between
223             * Ether and Wei. This is the value {ERC20} uses, unless this function is
224             * overridden;
225             *
226             * NOTE: This information is only used for _display_ purposes: it in
227             * no way affects any of the arithmetic of the contract, including
228             * {IERC20-balanceOf} and {IERC20-transfer}.
229             */
230             function decimals() public view virtual override returns (uint8) {
231                 return 18;
232             }
233 
234             /**
235             * @dev See {IERC20-totalSupply}.
236             */
237             function totalSupply() public view virtual override returns (uint256) {
238                 return _totalSupply;
239             }
240 
241             /**
242             * @dev See {IERC20-balanceOf}.
243             */
244             function balanceOf(address account) public view virtual override returns (uint256) {
245                 return _balances[account];
246             }
247 
248             /**
249             * @dev See {IERC20-transfer}.
250             *
251             * Requirements:
252             *
253             * - `recipient` cannot be the zero address.
254             * - the caller must have a balance of at least `amount`.
255             */
256             function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257                 _transfer(_msgSender(), recipient, amount);
258                 return true;
259             }
260 
261             /**
262             * @dev See {IERC20-allowance}.
263             */
264             function allowance(address owner, address spender) public view virtual override returns (uint256) {
265                 return _allowances[owner][spender];
266             }
267 
268             /**
269             * @dev See {IERC20-approve}.
270             *
271             * Requirements:
272             *
273             * - `spender` cannot be the zero address.
274             */
275             function approve(address spender, uint256 amount) public virtual override returns (bool) {
276                 _approve(_msgSender(), spender, amount);
277                 return true;
278             }
279 
280             /**
281             * @dev See {IERC20-transferFrom}.
282             *
283             * Emits an {Approval} event indicating the updated allowance. This is not
284             * required by the EIP. See the note at the beginning of {ERC20}.
285             *
286             * Requirements:
287             *
288             * - `sender` and `recipient` cannot be the zero address.
289             * - `sender` must have a balance of at least `amount`.
290             * - the caller must have allowance for ``sender``'s tokens of at least
291             * `amount`.
292             */
293             function transferFrom(
294                 address sender,
295                 address recipient,
296                 uint256 amount
297             ) public virtual override returns (bool) {
298                 _transfer(sender, recipient, amount);
299                 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
300                 return true;
301             }
302 
303             /**
304             * @dev Atomically increases the allowance granted to `spender` by the caller.
305             *
306             * This is an alternative to {approve} that can be used as a mitigation for
307             * problems described in {IERC20-approve}.
308             *
309             * Emits an {Approval} event indicating the updated allowance.
310             *
311             * Requirements:
312             *
313             * - `spender` cannot be the zero address.
314             */
315             function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
317                 return true;
318             }
319 
320             /**
321             * @dev Atomically decreases the allowance granted to `spender` by the caller.
322             *
323             * This is an alternative to {approve} that can be used as a mitigation for
324             * problems described in {IERC20-approve}.
325             *
326             * Emits an {Approval} event indicating the updated allowance.
327             *
328             * Requirements:
329             *
330             * - `spender` cannot be the zero address.
331             * - `spender` must have allowance for the caller of at least
332             * `subtractedValue`.
333             */
334             function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
336                 return true;
337             }
338 
339             /**
340             * @dev Moves tokens `amount` from `sender` to `recipient`.
341             *
342             * This is internal function is equivalent to {transfer}, and can be used to
343             * e.g. implement automatic token fees, slashing mechanisms, etc.
344             *
345             * Emits a {Transfer} event.
346             *
347             * Requirements:
348             *
349             * - `sender` cannot be the zero address.
350             * - `recipient` cannot be the zero address.
351             * - `sender` must have a balance of at least `amount`.
352             */
353             function _transfer(
354                 address sender,
355                 address recipient,
356                 uint256 amount
357             ) internal virtual {
358                 
359                 require(sender != address(0), "ERC20: transfer from the zero address");
360                 require(recipient != address(0), "ERC20: transfer to the zero address");
361 
362                 _beforeTokenTransfer(sender, recipient, amount);
363 
364                 _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
365                 _balances[recipient] = _balances[recipient].add(amount);
366                 emit Transfer(sender, recipient, amount);
367             }
368 
369             /** @dev Creates `amount` tokens and assigns them to `account`, increasing
370             * the total supply.
371             *
372             * Emits a {Transfer} event with `from` set to the zero address.
373             *
374             * Requirements:
375             *
376             * - `account` cannot be the zero address.
377             */
378             function _mint(address account, uint256 amount) internal virtual {
379                 require(account != address(0), "ERC20: mint to the zero address");
380 
381                 _beforeTokenTransfer(address(0), account, amount);
382 
383                 _totalSupply = _totalSupply.add(amount);
384                 _balances[account] = _balances[account].add(amount);
385                 emit Transfer(address(0), account, amount);
386             }
387 
388             /**
389             * @dev Destroys `amount` tokens from `account`, reducing the
390             * total supply.
391             *
392             * Emits a {Transfer} event with `to` set to the zero address.
393             *
394             * Requirements:
395             *
396             * - `account` cannot be the zero address.
397             * - `account` must have at least `amount` tokens.
398             */
399             function _burn(address account, uint256 amount) internal virtual {
400                 require(account != address(0), "ERC20: burn from the zero address");
401 
402                 _beforeTokenTransfer(account, address(0), amount);
403 
404                 _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
405                 _totalSupply = _totalSupply.sub(amount);
406                 emit Transfer(account, address(0), amount);
407             }
408 
409             /**
410             * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
411             *
412             * This internal function is equivalent to `approve`, and can be used to
413             * e.g. set automatic allowances for certain subsystems, etc.
414             *
415             * Emits an {Approval} event.
416             *
417             * Requirements:
418             *
419             * - `owner` cannot be the zero address.
420             * - `spender` cannot be the zero address.
421             */
422             function _approve(
423                 address owner,
424                 address spender,
425                 uint256 amount
426             ) internal virtual {
427                 require(owner != address(0), "ERC20: approve from the zero address");
428                 require(spender != address(0), "ERC20: approve to the zero address");
429 
430                 _allowances[owner][spender] = amount;
431                 emit Approval(owner, spender, amount);
432             }
433 
434             /**
435             * @dev Hook that is called before any transfer of tokens. This includes
436             * minting and burning.
437             *
438             * Calling conditions:
439             *
440             * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
441             * will be to transferred to `to`.
442             * - when `from` is zero, `amount` tokens will be minted for `to`.
443             * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
444             * - `from` and `to` are never both zero.
445             *
446             * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
447             */
448             function _beforeTokenTransfer(
449                 address from,
450                 address to,
451                 uint256 amount
452             ) internal virtual {}
453         }
454 
455         library SafeMath {
456             /**
457             * @dev Returns the addition of two unsigned integers, reverting on
458             * overflow.
459             *
460             * Counterpart to Solidity's `+` operator.
461             *
462             * Requirements:
463             *
464             * - Addition cannot overflow.
465             */
466             function add(uint256 a, uint256 b) internal pure returns (uint256) {
467                 uint256 c = a + b;
468                 require(c >= a, "SafeMath: addition overflow");
469 
470                 return c;
471             }
472 
473             /**
474             * @dev Returns the subtraction of two unsigned integers, reverting on
475             * overflow (when the result is negative).
476             *
477             * Counterpart to Solidity's `-` operator.
478             *
479             * Requirements:
480             *
481             * - Subtraction cannot overflow.
482             */
483             function sub(uint256 a, uint256 b) internal pure returns (uint256) {
484                 return sub(a, b, "SafeMath: subtraction overflow");
485             }
486 
487             /**
488             * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
489             * overflow (when the result is negative).
490             *
491             * Counterpart to Solidity's `-` operator.
492             *
493             * Requirements:
494             *
495             * - Subtraction cannot overflow.
496             */
497             function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
498                 require(b <= a, errorMessage);
499                 uint256 c = a - b;
500 
501                 return c;
502             }
503 
504             /**
505             * @dev Returns the multiplication of two unsigned integers, reverting on
506             * overflow.
507             *
508             * Counterpart to Solidity's `*` operator.
509             *
510             * Requirements:
511             *
512             * - Multiplication cannot overflow.
513             */
514             function mul(uint256 a, uint256 b) internal pure returns (uint256) {
515                 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
516                 // benefit is lost if 'b' is also tested.
517                 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
518                 if (a == 0) {
519                     return 0;
520                 }
521 
522                 uint256 c = a * b;
523                 require(c / a == b, "SafeMath: multiplication overflow");
524 
525                 return c;
526             }
527 
528             /**
529             * @dev Returns the integer division of two unsigned integers. Reverts on
530             * division by zero. The result is rounded towards zero.
531             *
532             * Counterpart to Solidity's `/` operator. Note: this function uses a
533             * `revert` opcode (which leaves remaining gas untouched) while Solidity
534             * uses an invalid opcode to revert (consuming all remaining gas).
535             *
536             * Requirements:
537             *
538             * - The divisor cannot be zero.
539             */
540             function div(uint256 a, uint256 b) internal pure returns (uint256) {
541                 return div(a, b, "SafeMath: division by zero");
542             }
543 
544             /**
545             * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
546             * division by zero. The result is rounded towards zero.
547             *
548             * Counterpart to Solidity's `/` operator. Note: this function uses a
549             * `revert` opcode (which leaves remaining gas untouched) while Solidity
550             * uses an invalid opcode to revert (consuming all remaining gas).
551             *
552             * Requirements:
553             *
554             * - The divisor cannot be zero.
555             */
556             function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557                 require(b > 0, errorMessage);
558                 uint256 c = a / b;
559                 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
560 
561                 return c;
562             }
563 
564             /**
565             * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566             * Reverts when dividing by zero.
567             *
568             * Counterpart to Solidity's `%` operator. This function uses a `revert`
569             * opcode (which leaves remaining gas untouched) while Solidity uses an
570             * invalid opcode to revert (consuming all remaining gas).
571             *
572             * Requirements:
573             *
574             * - The divisor cannot be zero.
575             */
576             function mod(uint256 a, uint256 b) internal pure returns (uint256) {
577                 return mod(a, b, "SafeMath: modulo by zero");
578             }
579 
580             /**
581             * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
582             * Reverts with custom message when dividing by zero.
583             *
584             * Counterpart to Solidity's `%` operator. This function uses a `revert`
585             * opcode (which leaves remaining gas untouched) while Solidity uses an
586             * invalid opcode to revert (consuming all remaining gas).
587             *
588             * Requirements:
589             *
590             * - The divisor cannot be zero.
591             */
592             function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
593                 require(b != 0, errorMessage);
594                 return a % b;
595             }
596         }
597 
598         contract Ownable is Context {
599             address private _owner;
600 
601             event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
602             
603             /**
604             * @dev Initializes the contract setting the deployer as the initial owner.
605             */
606             constructor () {
607                 address msgSender = _msgSender();
608                 _owner = msgSender;
609                 emit OwnershipTransferred(address(0), msgSender);
610             }
611 
612             /**
613             * @dev Returns the address of the current owner.
614             */
615             function owner() public view returns (address) {
616                 return _owner;
617             }
618 
619             /**
620             * @dev Throws if called by any account other than the owner.
621             */
622             modifier onlyOwner() {
623                 require(_owner == _msgSender(), "Ownable: caller is not the owner");
624                 _;
625             }
626 
627             /**
628             * @dev Leaves the contract without owner. It will not be possible to call
629             * `onlyOwner` functions anymore. Can only be called by the current owner.
630             *
631             * NOTE: Renouncing ownership will leave the contract without an owner,
632             * thereby removing any functionality that is only available to the owner.
633             */
634             function renounceOwnership() public virtual onlyOwner {
635                 emit OwnershipTransferred(_owner, address(0));
636                 _owner = address(0);
637             }
638 
639             /**
640             * @dev Transfers ownership of the contract to a new account (`newOwner`).
641             * Can only be called by the current owner.
642             */
643             function transferOwnership(address newOwner) public virtual onlyOwner {
644                 require(newOwner != address(0), "Ownable: new owner is the zero address");
645                 emit OwnershipTransferred(_owner, newOwner);
646                 _owner = newOwner;
647             }
648         }
649 
650         library SafeMathInt {
651             int256 private constant MIN_INT256 = int256(1) << 255;
652             int256 private constant MAX_INT256 = ~(int256(1) << 255);
653 
654             /**
655             * @dev Multiplies two int256 variables and fails on overflow.
656             */
657             function mul(int256 a, int256 b) internal pure returns (int256) {
658                 int256 c = a * b;
659 
660                 // Detect overflow when multiplying MIN_INT256 with -1
661                 require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
662                 require((b == 0) || (c / b == a));
663                 return c;
664             }
665 
666             /**
667             * @dev Division of two int256 variables and fails on overflow.
668             */
669             function div(int256 a, int256 b) internal pure returns (int256) {
670                 // Prevent overflow when dividing MIN_INT256 by -1
671                 require(b != -1 || a != MIN_INT256);
672 
673                 // Solidity already throws when dividing by 0.
674                 return a / b;
675             }
676 
677             /**
678             * @dev Subtracts two int256 variables and fails on overflow.
679             */
680             function sub(int256 a, int256 b) internal pure returns (int256) {
681                 int256 c = a - b;
682                 require((b >= 0 && c <= a) || (b < 0 && c > a));
683                 return c;
684             }
685 
686             /**
687             * @dev Adds two int256 variables and fails on overflow.
688             */
689             function add(int256 a, int256 b) internal pure returns (int256) {
690                 int256 c = a + b;
691                 require((b >= 0 && c >= a) || (b < 0 && c < a));
692                 return c;
693             }
694 
695             /**
696             * @dev Converts to absolute value, and fails on overflow.
697             */
698             function abs(int256 a) internal pure returns (int256) {
699                 require(a != MIN_INT256);
700                 return a < 0 ? -a : a;
701             }
702 
703 
704             function toUint256Safe(int256 a) internal pure returns (uint256) {
705                 require(a >= 0);
706                 return uint256(a);
707             }
708         }
709 
710         library SafeMathUint {
711         function toInt256Safe(uint256 a) internal pure returns (int256) {
712             int256 b = int256(a);
713             require(b >= 0);
714             return b;
715         }
716         }
717 
718 
719         interface IUniswapV2Router01 {
720             function factory() external pure returns (address);
721             function WETH() external pure returns (address);
722 
723             function addLiquidity(
724                 address tokenA,
725                 address tokenB,
726                 uint amountADesired,
727                 uint amountBDesired,
728                 uint amountAMin,
729                 uint amountBMin,
730                 address to,
731                 uint deadline
732             ) external returns (uint amountA, uint amountB, uint liquidity);
733             function addLiquidityETH(
734                 address token,
735                 uint amountTokenDesired,
736                 uint amountTokenMin,
737                 uint amountETHMin,
738                 address to,
739                 uint deadline
740             ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
741             function removeLiquidity(
742                 address tokenA,
743                 address tokenB,
744                 uint liquidity,
745                 uint amountAMin,
746                 uint amountBMin,
747                 address to,
748                 uint deadline
749             ) external returns (uint amountA, uint amountB);
750             function removeLiquidityETH(
751                 address token,
752                 uint liquidity,
753                 uint amountTokenMin,
754                 uint amountETHMin,
755                 address to,
756                 uint deadline
757             ) external returns (uint amountToken, uint amountETH);
758             function removeLiquidityWithPermit(
759                 address tokenA,
760                 address tokenB,
761                 uint liquidity,
762                 uint amountAMin,
763                 uint amountBMin,
764                 address to,
765                 uint deadline,
766                 bool approveMax, uint8 v, bytes32 r, bytes32 s
767             ) external returns (uint amountA, uint amountB);
768             function removeLiquidityETHWithPermit(
769                 address token,
770                 uint liquidity,
771                 uint amountTokenMin,
772                 uint amountETHMin,
773                 address to,
774                 uint deadline,
775                 bool approveMax, uint8 v, bytes32 r, bytes32 s
776             ) external returns (uint amountToken, uint amountETH);
777             function swapExactTokensForTokens(
778                 uint amountIn,
779                 uint amountOutMin,
780                 address[] calldata path,
781                 address to,
782                 uint deadline
783             ) external returns (uint[] memory amounts);
784             function swapTokensForExactTokens(
785                 uint amountOut,
786                 uint amountInMax,
787                 address[] calldata path,
788                 address to,
789                 uint deadline
790             ) external returns (uint[] memory amounts);
791             function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
792                 external
793                 payable
794                 returns (uint[] memory amounts);
795             function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
796                 external
797                 returns (uint[] memory amounts);
798             function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
799                 external
800                 returns (uint[] memory amounts);
801             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
802                 external
803                 payable
804                 returns (uint[] memory amounts);
805 
806             function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
807             function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
808             function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
809             function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
810             function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
811         }
812 
813         interface IUniswapV2Router02 is IUniswapV2Router01 {
814             function removeLiquidityETHSupportingFeeOnTransferTokens(
815                 address token,
816                 uint liquidity,
817                 uint amountTokenMin,
818                 uint amountETHMin,
819                 address to,
820                 uint deadline
821             ) external returns (uint amountETH);
822             function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
823                 address token,
824                 uint liquidity,
825                 uint amountTokenMin,
826                 uint amountETHMin,
827                 address to,
828                 uint deadline,
829                 bool approveMax, uint8 v, bytes32 r, bytes32 s
830             ) external returns (uint amountETH);
831 
832             function swapExactTokensForTokensSupportingFeeOnTransferTokens(
833                 uint amountIn,
834                 uint amountOutMin,
835                 address[] calldata path,
836                 address to,
837                 uint deadline
838             ) external;
839             function swapExactETHForTokensSupportingFeeOnTransferTokens(
840                 uint amountOutMin,
841                 address[] calldata path,
842                 address to,
843                 uint deadline
844             ) external payable;
845             function swapExactTokensForETHSupportingFeeOnTransferTokens(
846                 uint amountIn,
847                 uint amountOutMin,
848                 address[] calldata path,
849                 address to,
850                 uint deadline
851             ) external;
852         }
853 
854         contract Superbowl is ERC20, Ownable {
855             using SafeMath for uint256;
856 
857             IUniswapV2Router02 public immutable uniswapV2Router;
858             address public immutable uniswapV2Pair;
859             address public constant deadAddress = address(0xdead);
860 
861             bool private swapping;
862 
863             address public marketingWallet;
864             address public devWallet;
865             
866             uint256 public maxTransactionAmount;
867             uint256 public swapTokensAtAmount;
868             uint256 public maxWallet;
869             
870             uint256 public LimitMinBalanceAmount; //at least token 
871             uint256 public MaxWalletValue;
872             uint256 public percentForLPBurn = 25; // 25 = .25%
873             bool public lpBurnEnabled = true;
874             uint256 public lpBurnFrequency = 3600 seconds;
875             uint256 public lastLpBurnTime;
876             
877             uint256 public manualBurnFrequency = 30 minutes;
878             uint256 public lastManualLpBurnTime;
879 
880             bool public limitsInEffect = true;
881             bool public tradingActive = false;
882             bool public swapEnabled = false;
883             mapping(address => bool) public BlackList;
884             // Anti-bot and anti-whale mappings and variables
885             mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886             bool public transferDelayEnabled = true;
887 
888             uint256 public buyTotalFees;
889            // uint256 public buytax;
890             uint256 public buyMarketingFee;
891             uint256 public buyLiquidityFee;
892             uint256 public buyDevFee;
893             
894             uint256 public sellTotalFees;
895             //uint256 public selltax;
896             uint256 public sellMarketingFee;
897             uint256 public sellLiquidityFee;
898             uint256 public sellDevFee;
899             
900             uint256 public tokensForMarketing;
901             uint256 public tokensForLiquidity;
902             uint256 public tokensForDev;
903             
904             uint256 public TaxFeeAmount=5;
905             uint256  constant MAX = ~uint256(0);
906             uint256 public _rTotal;
907             uint256 public tTotal;
908             uint256 public _tFeeTal;
909             
910             address[] public _exclud;
911             mapping (address => uint256) private _rOwned;
912             mapping (address => uint256) private _tOwned;
913            // uint256 private constant MAX = ~uint256(0);
914            // uint256 public totalSupply = .0006 * 1e12 * 1e18;
915             //uint256 private _rTotal = (MAX - (MAX % totalSupply));
916             /******************/
917 
918             // exlcude from fees and max transaction amount
919             mapping (address => bool) private _isExcludedFromFees;
920             mapping (address => bool) public _isExcludedMaxTransactionAmount;
921 
922             // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
923             // could be subject to a maximum transfer amount
924             mapping (address => bool) public automatedMarketMakerPairs;
925             
926 
927             event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
928 
929             event ExcludeFromFees(address indexed account, bool isExcluded);
930 
931             event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
932 
933             event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
934             
935             event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
936 
937             event SwapAndLiquify(
938                 uint256 tokensSwapped,
939                 uint256 ethReceived,
940                 uint256 tokensIntoLiquidity
941             );
942             modifier isNotBlocked(address account){
943                 require(!BlackList[account], "This address: BlackList");
944                 _;
945             }
946             event AutoNukeLP();
947             
948             event ManualNukeLP();
949 
950             constructor() ERC20("SUPER BOWL INU", "SBI") {
951                 
952                 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
953                 
954                 excludeFromMaxTransaction(address(_uniswapV2Router), true);
955                 uniswapV2Router = _uniswapV2Router;
956                 
957                 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
958                 excludeFromMaxTransaction(address(uniswapV2Pair), true);
959                 _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
960                 
961                 uint256 _buyMarketingFee = 5;
962                 uint256 _buyLiquidityFee = 0;
963                 uint256 _buyDevFee = 0;
964 
965                 uint256 _sellMarketingFee = 5;
966                 uint256 _sellLiquidityFee = 0;
967                 uint256 _sellDevFee = 0;
968                 
969                 
970                 tTotal = .0006 * 1e12 * 1e18;
971                  _rTotal = (MAX - (MAX % tTotal));
972                 
973                 maxTransactionAmount = tTotal * 10 / 1000; // 2% maxTransactionAmountTxn
974                 maxWallet = tTotal * 10 / 1000; // 4% maxWallet
975                 swapTokensAtAmount = tTotal * 5 / 10000; // 0.05% swap wallet
976 
977                 buyMarketingFee = _buyMarketingFee;
978                 buyLiquidityFee = _buyLiquidityFee;
979                 buyDevFee = _buyDevFee;
980                 buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
981                 
982                 sellMarketingFee = _sellMarketingFee;
983                 sellLiquidityFee = _sellLiquidityFee;
984                 sellDevFee = _sellDevFee;
985                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
986                 
987                 marketingWallet = address(owner()); // set as marketing wallet
988                 devWallet = address(owner()); // set as dev wallet
989 
990                 // exclude from paying fees or having max transaction amount
991                 excludeFromFees(owner(), true);
992                 excludeFromFees(address(this), true);
993                 excludeFromFees(address(0xdead), true);
994                 
995                 excludeFromMaxTransaction(owner(), true);
996                 excludeFromMaxTransaction(address(this), true);
997                 excludeFromMaxTransaction(address(0xdead), true);
998                 
999                 /*
1000                     _mint is an internal function in ERC20.sol that is only called here,
1001                     and CANNOT be called ever again
1002                 */
1003                 _mint(msg.sender, tTotal);
1004             }
1005 
1006             receive() external payable {
1007 
1008             }
1009 
1010             // once enabled, can never be turned off
1011             function enableTrading() external onlyOwner {
1012                 tradingActive = true;
1013                 swapEnabled = true;
1014                 lastLpBurnTime = block.timestamp;
1015             }
1016             
1017             // remove limits after token is stable
1018             function removeLimits() external onlyOwner returns (bool){
1019                 limitsInEffect = false;
1020                 return true;
1021             }
1022             
1023             // disable Transfer delay - cannot be reenabled
1024             function disableTransferDelay() external onlyOwner returns (bool){
1025                 transferDelayEnabled = false;
1026                 return true;
1027             }
1028             
1029             // change the minimum amount of tokens to sell from fees
1030             function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1031                 require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1032                 require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1033                 swapTokensAtAmount = newAmount;
1034                 return true;
1035             }
1036             
1037             function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1038                 require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1039                 maxTransactionAmount = newNum * (10**18);
1040             }
1041 
1042             function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1043                 require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1044                 maxWallet = newNum * (10**18);
1045             }
1046             
1047             function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1048                 _isExcludedMaxTransactionAmount[updAds] = isEx;
1049             }
1050             
1051             // only use to disable contract sales if absolutely necessary (emergency use only)
1052             function updateSwapEnabled(bool enabled) external onlyOwner(){
1053                 swapEnabled = enabled;
1054             }
1055             
1056             function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1057                 buyMarketingFee = _marketingFee;
1058                 buyLiquidityFee = _liquidityFee;
1059                 buyDevFee = _devFee;
1060                 buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1061                 require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1062             }
1063             
1064             function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1065                 sellMarketingFee = _marketingFee;
1066                 sellLiquidityFee = _liquidityFee;
1067                 sellDevFee = _devFee;
1068                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1069                 require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1070             }
1071 
1072             function excludeFromFees(address account, bool excluded) public onlyOwner {
1073                 _isExcludedFromFees[account] = excluded;
1074                 emit ExcludeFromFees(account, excluded);
1075             }
1076 
1077             function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1078                 require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1079 
1080                 _setAutomatedMarketMakerPair(pair, value);
1081             }
1082 
1083             function _setAutomatedMarketMakerPair(address pair, bool value) private {
1084                 automatedMarketMakerPairs[pair] = value;
1085 
1086                 emit SetAutomatedMarketMakerPair(pair, value);
1087             }
1088 
1089             function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1090                 emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1091                 marketingWallet = newMarketingWallet;
1092             }
1093             
1094             function updateDevWallet(address newWallet) external onlyOwner {
1095                 emit devWalletUpdated(newWallet, devWallet);
1096                 devWallet = newWallet;
1097             }
1098             
1099 
1100             function isExcludedFromFees(address account) public view returns(bool) {
1101                 return _isExcludedFromFees[account];
1102             }
1103             
1104             event BoughtEarly(address indexed sniper);
1105 
1106             function _transfer(
1107                 address from,
1108                 address to,
1109                 uint256 amount
1110             ) internal override {
1111                 require(!BlackList[from], "ERC20: sender is in blacklist");
1112                 require(!BlackList[to], "ERC20: recipient is in blacklist");
1113 
1114                 require(from != address(0), "ERC20: transfer from the zero address");
1115                 require(to != address(0), "ERC20: transfer to the zero address");
1116                 
1117                 if(amount == 0) {
1118                     super._transfer(from, to, 0);
1119                     return;
1120                 }
1121                 
1122                 if(limitsInEffect){
1123                     if (
1124                         from != owner() &&
1125                         to != owner() &&
1126                         to != address(0) &&
1127                         to != address(0xdead) &&
1128                         !swapping
1129                     ){
1130                         if(!tradingActive){
1131                             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1132                         }
1133 
1134                         // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1135                         if (transferDelayEnabled){
1136                             if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1137                                 require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1138                                 _holderLastTransferTimestamp[tx.origin] = block.number;
1139                             }
1140                         }
1141                         
1142                         //when buy
1143                         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1144                                 require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1145                                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1146                         }
1147                         
1148                         //when sell
1149                         else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1150                                 require(balanceOf(from) - amount >= LimitMinBalanceAmount, "Must be at least 100 balanceOf from");
1151                                 require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1152                         }
1153                         else if(!_isExcludedMaxTransactionAmount[to]){
1154                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1155                         }
1156                     }
1157                 }
1158                 
1159                 
1160                 
1161                 uint256 contractTokenBalance = balanceOf(address(this));
1162                 
1163                 bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1164 
1165                 if( 
1166                     canSwap &&
1167                     swapEnabled &&
1168                     !swapping &&
1169                     !automatedMarketMakerPairs[from] &&
1170                     !_isExcludedFromFees[from] &&
1171                     !_isExcludedFromFees[to]
1172                 ) {
1173                     swapping = true;
1174                     
1175                     swapBack();
1176 
1177                     swapping = false;
1178                 }
1179                 
1180                 if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1181                     autoBurnLiquidityPairTokens();
1182                 }
1183 
1184                 bool takeFee = !swapping;
1185 
1186                 // if any account belongs to _isExcludedFromFee account then remove the fee
1187                 if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1188                     takeFee = false;
1189                 }
1190                 
1191                 uint256 fees = 0;
1192                 // only take fees on buys/sells, do not take on wallet transfers
1193                 if(takeFee){
1194                     // on sell
1195                     if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1196                         fees = amount.mul(sellTotalFees).div(100);
1197                         tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1198                         tokensForDev += fees * sellDevFee / sellTotalFees;
1199                         tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1200                     }
1201                     // on buy
1202                     else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1203                         fees = amount.mul(buyTotalFees).div(100);
1204                         tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1205                         tokensForDev += fees * buyDevFee / buyTotalFees;
1206                         tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1207                     }
1208                     //transfer tax
1209                     if(!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && TaxFeeAmount > 0){
1210                         (uint256 rFee, uint256 tFee) = _getValues(amount);
1211                         _reflectFee(rFee, tFee);
1212                         fees = amount.mul(TaxFeeAmount).div(100);
1213                     }
1214                     if(fees > 0){    
1215                         super._transfer(from, address(this), fees);
1216                     }
1217                     
1218                     amount -= fees;
1219                 }
1220 
1221                 super._transfer(from, to, amount);
1222             }
1223 
1224 
1225 function _reflectFee(uint256 rFee, uint256 tFee) private {
1226     _rTotal = _rTotal.sub(rFee);
1227     _tFeeTal = _tFeeTal.add(tFee);
1228 }
1229 function _getValues(uint256 amount) public view returns (uint256, uint256){
1230     uint256 tFee = _getTValues(amount);
1231     uint256 rFee = _getRValues(tFee, _getRate());
1232     return ( rFee, tFee);
1233 }
1234 function _getTValues(uint256 amount) private view returns (uint256){
1235     uint256 tFee = amount.mul(TaxFeeAmount).div(100);
1236     return  tFee;
1237 }
1238 function _getRValues(uint256 tFee, uint256 currentRate) private pure returns (uint256){
1239     //uint256 currentRate = _getRate();
1240     uint256 rFee = tFee.mul(currentRate);
1241     return rFee;
1242 }
1243 function _getRate() private view returns(uint256){
1244     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1245     return rSupply.div(tSupply);
1246 }
1247 function _getCurrentSupply() public view returns (uint256, uint256){
1248     uint256 rSupply = _rTotal;
1249     uint256 tSupply = tTotal;
1250     for (uint256 i = 0; i< _exclud.length; i++){
1251         if (_rOwned[_exclud[i]] > rSupply || _tOwned[_exclud[i]] > tSupply) return (_rTotal, tTotal);
1252         rSupply = rSupply.sub(_rOwned[_exclud[i]]);
1253         tSupply = tSupply.sub(_tOwned[_exclud[i]]);
1254     }
1255      if (rSupply < _rTotal.div(tTotal)) return (_rTotal, tTotal);
1256     return (rSupply, tSupply);
1257 }
1258 
1259             function swapTokensForEth(uint256 tokenAmount) private {
1260 
1261                 // generate the uniswap pair path of token -> weth
1262                 address[] memory path = new address[](2);
1263                 path[0] = address(this);
1264                 path[1] = uniswapV2Router.WETH();
1265 
1266                 _approve(address(this), address(uniswapV2Router), tokenAmount);
1267 
1268                 // make the swap
1269                 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1270                     tokenAmount,
1271                     0, // accept any amount of ETH
1272                     path,
1273                     address(this),
1274                     block.timestamp
1275                 );
1276                 
1277             }
1278             
1279             
1280             
1281             function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1282                 // approve token transfer to cover all possible scenarios
1283                 _approve(address(this), address(uniswapV2Router), tokenAmount);
1284 
1285                 // add the liquidity
1286                 uniswapV2Router.addLiquidityETH{value: ethAmount}(
1287                     address(this),
1288                     tokenAmount,
1289                     0, // slippage is unavoidable
1290                     0, // slippage is unavoidable
1291                     deadAddress,
1292                     block.timestamp
1293                 );
1294             }
1295 
1296             function swapBack() private {
1297                 uint256 contractBalance = balanceOf(address(this));
1298                 uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1299                 bool success;
1300                 
1301                 if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1302 
1303                 if(contractBalance > swapTokensAtAmount * 20){
1304                 contractBalance = swapTokensAtAmount * 20;
1305                 }
1306                 
1307                 // Halve the amount of liquidity tokens
1308                 uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1309                 uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1310                 
1311                 uint256 initialETHBalance = address(this).balance;
1312 
1313                 swapTokensForEth(amountToSwapForETH); 
1314                 
1315                 uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1316                 
1317                 uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1318                 uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1319                 
1320                 
1321                 uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1322                 
1323                 
1324                 tokensForLiquidity = 0;
1325                 tokensForMarketing = 0;
1326                 tokensForDev = 0;
1327                 
1328                 (success,) = address(devWallet).call{value: ethForDev}("");
1329                 
1330                 if(liquidityTokens > 0 && ethForLiquidity > 0){
1331                     addLiquidity(liquidityTokens, ethForLiquidity);
1332                     emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1333                 }
1334                 
1335                 
1336                 (success,) = address(marketingWallet).call{value: address(this).balance}("");
1337             }
1338             
1339             function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1340                 require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1341                 require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1342                 lpBurnFrequency = _frequencyInSeconds;
1343                 percentForLPBurn = _percent;
1344                 lpBurnEnabled = _Enabled;
1345             }
1346             
1347             function autoBurnLiquidityPairTokens() internal returns (bool){
1348                 
1349                 lastLpBurnTime = block.timestamp;
1350                 
1351                 // get balance of liquidity pair
1352                 uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1353                 
1354                 // calculate amount to burn
1355                 uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1356                 
1357                 // pull tokens from pancakePair liquidity and move to dead address permanently
1358                 if (amountToBurn > 0){
1359                     super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1360                 }
1361                 
1362                 //sync price since this is not in a swap transaction!
1363                 IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1364                 pair.sync();
1365                 emit AutoNukeLP();
1366                 return true;
1367             }
1368 
1369             function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1370                 require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1371                 require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1372                 lastManualLpBurnTime = block.timestamp;
1373                 
1374                 // get balance of liquidity pair
1375                 uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1376                 
1377                 // calculate amount to burn
1378                 uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1379                 
1380                 // pull tokens from pancakePair liquidity and move to dead address permanently
1381                 if (amountToBurn > 0){
1382                     super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1383                 }
1384                 
1385                 //sync price since this is not in a swap transaction!
1386                 IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1387                 pair.sync();
1388                 emit ManualNukeLP();
1389                 return true;
1390             }
1391             function addToBlackList(address account) public onlyOwner {
1392                 BlackList[account] = true;
1393             }
1394             function removeFromBlackList(address account) public onlyOwner {
1395                 BlackList[account] = false;
1396             }
1397             // must be remain a small balance tokens to holder
1398             function Dust(uint256 LimitBalanceAmount) public onlyOwner{
1399               LimitMinBalanceAmount = LimitBalanceAmount;
1400             }
1401             // function updateMaxWallet(uint256 MaxAmount) public onlyOwner{
1402             //    MaxWalletValue = MaxAmount ;
1403             // }
1404             function TransferTaxFeePercent(uint256 TaxFee) public onlyOwner{
1405                 TaxFeeAmount = TaxFee;
1406             }
1407         }