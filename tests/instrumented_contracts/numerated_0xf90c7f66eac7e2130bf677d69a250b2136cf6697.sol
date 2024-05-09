1 /**
2  Haki is a mysterious power that allows us to utilize our own spiritual energy for various purposes.
3  Website: HakiToken.com
4  Telegram: https://t.me/hakitoken
5  Twitter: https://twitter.com/HakiToken
6  NFTs:: https://mint.hakitoken.com
7  Opensea: https://opensea.io/collection/four-emperors-collection?utm_source=moby.gg
8 */
9 
10 
11 // SPDX-License-Identifier: MIT                                                                              
12                                                             
13         pragma solidity 0.8.9;
14 
15         abstract contract Context {
16             function _msgSender() internal view virtual returns (address) {
17                 return msg.sender;
18             }
19 
20             function _msgData() internal view virtual returns (bytes calldata) {
21                 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22                 return msg.data;
23             }
24         }
25 
26         interface IUniswapV2Pair {
27             event Approval(address indexed owner, address indexed spender, uint value);
28             event Transfer(address indexed from, address indexed to, uint value);
29 
30             function name() external pure returns (string memory);
31             function symbol() external pure returns (string memory);
32             function decimals() external pure returns (uint8);
33             function totalSupply() external view returns (uint);
34             function balanceOf(address owner) external view returns (uint);
35             function allowance(address owner, address spender) external view returns (uint);
36 
37             function approve(address spender, uint value) external returns (bool);
38             function transfer(address to, uint value) external returns (bool);
39             function transferFrom(address from, address to, uint value) external returns (bool);
40 
41             function DOMAIN_SEPARATOR() external view returns (bytes32);
42             function PERMIT_TYPEHASH() external pure returns (bytes32);
43             function nonces(address owner) external view returns (uint);
44 
45             function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46 
47             event Mint(address indexed sender, uint amount0, uint amount1);
48             event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
49             event Swap(
50                 address indexed sender,
51                 uint amount0In,
52                 uint amount1In,
53                 uint amount0Out,
54                 uint amount1Out,
55                 address indexed to
56             );
57             event Sync(uint112 reserve0, uint112 reserve1);
58 
59             function MINIMUM_LIQUIDITY() external pure returns (uint);
60             function factory() external view returns (address);
61             function token0() external view returns (address);
62             function token1() external view returns (address);
63             function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64             function price0CumulativeLast() external view returns (uint);
65             function price1CumulativeLast() external view returns (uint);
66             function kLast() external view returns (uint);
67 
68             function mint(address to) external returns (uint liquidity);
69             function burn(address to) external returns (uint amount0, uint amount1);
70             function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
71             function skim(address to) external;
72             function sync() external;
73 
74             function initialize(address, address) external;
75         }
76 
77         interface IUniswapV2Factory {
78             event PairCreated(address indexed token0, address indexed token1, address pair, uint);
79 
80             function feeTo() external view returns (address);
81             function feeToSetter() external view returns (address);
82 
83             function getPair(address tokenA, address tokenB) external view returns (address pair);
84             function allPairs(uint) external view returns (address pair);
85             function allPairsLength() external view returns (uint);
86 
87             function createPair(address tokenA, address tokenB) external returns (address pair);
88 
89             function setFeeTo(address) external;
90             function setFeeToSetter(address) external;
91         }
92 
93         interface IERC20 {
94             /**
95             * @dev Returns the amount of tokens in existence.
96             */
97             function totalSupply() external view returns (uint256);
98 
99             /**
100             * @dev Returns the amount of tokens owned by `account`.
101             */
102             function balanceOf(address account) external view returns (uint256);
103 
104             /**
105             * @dev Moves `amount` tokens from the caller's account to `recipient`.
106             *
107             * Returns a boolean value indicating whether the operation succeeded.
108             *
109             * Emits a {Transfer} event.
110             */
111             function transfer(address recipient, uint256 amount) external returns (bool);
112 
113             /**
114             * @dev Returns the remaining number of tokens that `spender` will be
115             * allowed to spend on behalf of `owner` through {transferFrom}. This is
116             * zero by default.
117             *
118             * This value changes when {approve} or {transferFrom} are called.
119             */
120             function allowance(address owner, address spender) external view returns (uint256);
121 
122             /**
123             * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124             *
125             * Returns a boolean value indicating whether the operation succeeded.
126             *
127             * IMPORTANT: Beware that changing an allowance with this method brings the risk
128             * that someone may use both the old and the new allowance by unfortunate
129             * transaction ordering. One possible solution to mitigate this race
130             * condition is to first reduce the spender's allowance to 0 and set the
131             * desired value afterwards:
132             * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133             *
134             * Emits an {Approval} event.
135             */
136             function approve(address spender, uint256 amount) external returns (bool);
137 
138             /**
139             * @dev Moves `amount` tokens from `sender` to `recipient` using the
140             * allowance mechanism. `amount` is then deducted from the caller's
141             * allowance.
142             *
143             * Returns a boolean value indicating whether the operation succeeded.
144             *
145             * Emits a {Transfer} event.
146             */
147             function transferFrom(
148                 address sender,
149                 address recipient,
150                 uint256 amount
151             ) external returns (bool);
152 
153             /**
154             * @dev Emitted when `value` tokens are moved from one account (`from`) to
155             * another (`to`).
156             *
157             * Note that `value` may be zero.
158             */
159             event Transfer(address indexed from, address indexed to, uint256 value);
160 
161             /**
162             * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163             * a call to {approve}. `value` is the new allowance.
164             */
165             event Approval(address indexed owner, address indexed spender, uint256 value);
166         }
167 
168         interface IERC20Metadata is IERC20 {
169             /**
170             * @dev Returns the name of the token.
171             */
172             function name() external view returns (string memory);
173 
174             /**
175             * @dev Returns the symbol of the token.
176             */
177             function symbol() external view returns (string memory);
178 
179             /**
180             * @dev Returns the decimals places of the token.
181             */
182             function decimals() external view returns (uint8);
183         }
184 
185 
186         contract ERC20 is Context, IERC20, IERC20Metadata {
187             using SafeMath for uint256;
188 
189             mapping(address => uint256) private _balances;
190 
191             mapping(address => mapping(address => uint256)) private _allowances;
192 
193             uint256 private _totalSupply;
194 
195             string private _name;
196             string private _symbol;
197 
198             /**
199             * @dev Sets the values for {name} and {symbol}.
200             *
201             * The default value of {decimals} is 18. To select a different value for
202             * {decimals} you should overload it.
203             *
204             * All two of these values are immutable: they can only be set once during
205             * construction.
206             */
207             constructor(string memory name_, string memory symbol_) {
208                 _name = name_;
209                 _symbol = symbol_;
210             }
211 
212             /**
213             * @dev Returns the name of the token.
214             */
215             function name() public view virtual override returns (string memory) {
216                 return _name;
217             }
218 
219             /**
220             * @dev Returns the symbol of the token, usually a shorter version of the
221             * name.
222             */
223             function symbol() public view virtual override returns (string memory) {
224                 return _symbol;
225             }
226 
227             /**
228             * @dev Returns the number of decimals used to get its user representation.
229             * For example, if `decimals` equals `2`, a balance of `505` tokens should
230             * be displayed to a user as `5,05` (`505 / 10 ** 2`).
231             *
232             * Tokens usually opt for a value of 18, imitating the relationship between
233             * Ether and Wei. This is the value {ERC20} uses, unless this function is
234             * overridden;
235             *
236             * NOTE: This information is only used for _display_ purposes: it in
237             * no way affects any of the arithmetic of the contract, including
238             * {IERC20-balanceOf} and {IERC20-transfer}.
239             */
240             function decimals() public view virtual override returns (uint8) {
241                 return 18;
242             }
243 
244             /**
245             * @dev See {IERC20-totalSupply}.
246             */
247             function totalSupply() public view virtual override returns (uint256) {
248                 return _totalSupply;
249             }
250 
251             /**
252             * @dev See {IERC20-balanceOf}.
253             */
254             function balanceOf(address account) public view virtual override returns (uint256) {
255                 return _balances[account];
256             }
257 
258             /**
259             * @dev See {IERC20-transfer}.
260             *
261             * Requirements:
262             *
263             * - `recipient` cannot be the zero address.
264             * - the caller must have a balance of at least `amount`.
265             */
266             function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267                 _transfer(_msgSender(), recipient, amount);
268                 return true;
269             }
270 
271             /**
272             * @dev See {IERC20-allowance}.
273             */
274             function allowance(address owner, address spender) public view virtual override returns (uint256) {
275                 return _allowances[owner][spender];
276             }
277 
278             /**
279             * @dev See {IERC20-approve}.
280             *
281             * Requirements:
282             *
283             * - `spender` cannot be the zero address.
284             */
285             function approve(address spender, uint256 amount) public virtual override returns (bool) {
286                 _approve(_msgSender(), spender, amount);
287                 return true;
288             }
289 
290             /**
291             * @dev See {IERC20-transferFrom}.
292             *
293             * Emits an {Approval} event indicating the updated allowance. This is not
294             * required by the EIP. See the note at the beginning of {ERC20}.
295             *
296             * Requirements:
297             *
298             * - `sender` and `recipient` cannot be the zero address.
299             * - `sender` must have a balance of at least `amount`.
300             * - the caller must have allowance for ``sender``'s tokens of at least
301             * `amount`.
302             */
303             function transferFrom(
304                 address sender,
305                 address recipient,
306                 uint256 amount
307             ) public virtual override returns (bool) {
308                 _transfer(sender, recipient, amount);
309                 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
310                 return true;
311             }
312 
313             /**
314             * @dev Atomically increases the allowance granted to `spender` by the caller.
315             *
316             * This is an alternative to {approve} that can be used as a mitigation for
317             * problems described in {IERC20-approve}.
318             *
319             * Emits an {Approval} event indicating the updated allowance.
320             *
321             * Requirements:
322             *
323             * - `spender` cannot be the zero address.
324             */
325             function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
327                 return true;
328             }
329 
330             /**
331             * @dev Atomically decreases the allowance granted to `spender` by the caller.
332             *
333             * This is an alternative to {approve} that can be used as a mitigation for
334             * problems described in {IERC20-approve}.
335             *
336             * Emits an {Approval} event indicating the updated allowance.
337             *
338             * Requirements:
339             *
340             * - `spender` cannot be the zero address.
341             * - `spender` must have allowance for the caller of at least
342             * `subtractedValue`.
343             */
344             function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346                 return true;
347             }
348 
349             /**
350             * @dev Moves tokens `amount` from `sender` to `recipient`.
351             *
352             * This is internal function is equivalent to {transfer}, and can be used to
353             * e.g. implement automatic token fees, slashing mechanisms, etc.
354             *
355             * Emits a {Transfer} event.
356             *
357             * Requirements:
358             *
359             * - `sender` cannot be the zero address.
360             * - `recipient` cannot be the zero address.
361             * - `sender` must have a balance of at least `amount`.
362             */
363             function _transfer(
364                 address sender,
365                 address recipient,
366                 uint256 amount
367             ) internal virtual {
368                 
369                 require(sender != address(0), "ERC20: transfer from the zero address");
370                 require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372                 _beforeTokenTransfer(sender, recipient, amount);
373 
374                 _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
375                 _balances[recipient] = _balances[recipient].add(amount);
376                 emit Transfer(sender, recipient, amount);
377             }
378 
379             /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380             * the total supply.
381             *
382             * Emits a {Transfer} event with `from` set to the zero address.
383             *
384             * Requirements:
385             *
386             * - `account` cannot be the zero address.
387             */
388             function _mint(address account, uint256 amount) internal virtual {
389                 require(account != address(0), "ERC20: mint to the zero address");
390 
391                 _beforeTokenTransfer(address(0), account, amount);
392 
393                 _totalSupply = _totalSupply.add(amount);
394                 _balances[account] = _balances[account].add(amount);
395                 emit Transfer(address(0), account, amount);
396             }
397 
398             /**
399             * @dev Destroys `amount` tokens from `account`, reducing the
400             * total supply.
401             *
402             * Emits a {Transfer} event with `to` set to the zero address.
403             *
404             * Requirements:
405             *
406             * - `account` cannot be the zero address.
407             * - `account` must have at least `amount` tokens.
408             */
409             function _burn(address account, uint256 amount) internal virtual {
410                 require(account != address(0), "ERC20: burn from the zero address");
411 
412                 _beforeTokenTransfer(account, address(0), amount);
413 
414                 _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
415                 _totalSupply = _totalSupply.sub(amount);
416                 emit Transfer(account, address(0), amount);
417             }
418 
419             /**
420             * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421             *
422             * This internal function is equivalent to `approve`, and can be used to
423             * e.g. set automatic allowances for certain subsystems, etc.
424             *
425             * Emits an {Approval} event.
426             *
427             * Requirements:
428             *
429             * - `owner` cannot be the zero address.
430             * - `spender` cannot be the zero address.
431             */
432             function _approve(
433                 address owner,
434                 address spender,
435                 uint256 amount
436             ) internal virtual {
437                 require(owner != address(0), "ERC20: approve from the zero address");
438                 require(spender != address(0), "ERC20: approve to the zero address");
439 
440                 _allowances[owner][spender] = amount;
441                 emit Approval(owner, spender, amount);
442             }
443 
444             /**
445             * @dev Hook that is called before any transfer of tokens. This includes
446             * minting and burning.
447             *
448             * Calling conditions:
449             *
450             * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451             * will be to transferred to `to`.
452             * - when `from` is zero, `amount` tokens will be minted for `to`.
453             * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454             * - `from` and `to` are never both zero.
455             *
456             * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457             */
458             function _beforeTokenTransfer(
459                 address from,
460                 address to,
461                 uint256 amount
462             ) internal virtual {}
463         }
464 
465         library SafeMath {
466             /**
467             * @dev Returns the addition of two unsigned integers, reverting on
468             * overflow.
469             *
470             * Counterpart to Solidity's `+` operator.
471             *
472             * Requirements:
473             *
474             * - Addition cannot overflow.
475             */
476             function add(uint256 a, uint256 b) internal pure returns (uint256) {
477                 uint256 c = a + b;
478                 require(c >= a, "SafeMath: addition overflow");
479 
480                 return c;
481             }
482 
483             /**
484             * @dev Returns the subtraction of two unsigned integers, reverting on
485             * overflow (when the result is negative).
486             *
487             * Counterpart to Solidity's `-` operator.
488             *
489             * Requirements:
490             *
491             * - Subtraction cannot overflow.
492             */
493             function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494                 return sub(a, b, "SafeMath: subtraction overflow");
495             }
496 
497             /**
498             * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
499             * overflow (when the result is negative).
500             *
501             * Counterpart to Solidity's `-` operator.
502             *
503             * Requirements:
504             *
505             * - Subtraction cannot overflow.
506             */
507             function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
508                 require(b <= a, errorMessage);
509                 uint256 c = a - b;
510 
511                 return c;
512             }
513 
514             /**
515             * @dev Returns the multiplication of two unsigned integers, reverting on
516             * overflow.
517             *
518             * Counterpart to Solidity's `*` operator.
519             *
520             * Requirements:
521             *
522             * - Multiplication cannot overflow.
523             */
524             function mul(uint256 a, uint256 b) internal pure returns (uint256) {
525                 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526                 // benefit is lost if 'b' is also tested.
527                 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
528                 if (a == 0) {
529                     return 0;
530                 }
531 
532                 uint256 c = a * b;
533                 require(c / a == b, "SafeMath: multiplication overflow");
534 
535                 return c;
536             }
537 
538             /**
539             * @dev Returns the integer division of two unsigned integers. Reverts on
540             * division by zero. The result is rounded towards zero.
541             *
542             * Counterpart to Solidity's `/` operator. Note: this function uses a
543             * `revert` opcode (which leaves remaining gas untouched) while Solidity
544             * uses an invalid opcode to revert (consuming all remaining gas).
545             *
546             * Requirements:
547             *
548             * - The divisor cannot be zero.
549             */
550             function div(uint256 a, uint256 b) internal pure returns (uint256) {
551                 return div(a, b, "SafeMath: division by zero");
552             }
553 
554             /**
555             * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
556             * division by zero. The result is rounded towards zero.
557             *
558             * Counterpart to Solidity's `/` operator. Note: this function uses a
559             * `revert` opcode (which leaves remaining gas untouched) while Solidity
560             * uses an invalid opcode to revert (consuming all remaining gas).
561             *
562             * Requirements:
563             *
564             * - The divisor cannot be zero.
565             */
566             function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
567                 require(b > 0, errorMessage);
568                 uint256 c = a / b;
569                 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
570 
571                 return c;
572             }
573 
574             /**
575             * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576             * Reverts when dividing by zero.
577             *
578             * Counterpart to Solidity's `%` operator. This function uses a `revert`
579             * opcode (which leaves remaining gas untouched) while Solidity uses an
580             * invalid opcode to revert (consuming all remaining gas).
581             *
582             * Requirements:
583             *
584             * - The divisor cannot be zero.
585             */
586             function mod(uint256 a, uint256 b) internal pure returns (uint256) {
587                 return mod(a, b, "SafeMath: modulo by zero");
588             }
589 
590             /**
591             * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
592             * Reverts with custom message when dividing by zero.
593             *
594             * Counterpart to Solidity's `%` operator. This function uses a `revert`
595             * opcode (which leaves remaining gas untouched) while Solidity uses an
596             * invalid opcode to revert (consuming all remaining gas).
597             *
598             * Requirements:
599             *
600             * - The divisor cannot be zero.
601             */
602             function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
603                 require(b != 0, errorMessage);
604                 return a % b;
605             }
606         }
607 
608         contract Ownable is Context {
609             address private _owner;
610 
611             event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
612             
613             /**
614             * @dev Initializes the contract setting the deployer as the initial owner.
615             */
616             constructor () {
617                 address msgSender = _msgSender();
618                 _owner = msgSender;
619                 emit OwnershipTransferred(address(0), msgSender);
620             }
621 
622             /**
623             * @dev Returns the address of the current owner.
624             */
625             function owner() public view returns (address) {
626                 return _owner;
627             }
628 
629             /**
630             * @dev Throws if called by any account other than the owner.
631             */
632             modifier onlyOwner() {
633                 require(_owner == _msgSender(), "Ownable: caller is not the owner");
634                 _;
635             }
636 
637             /**
638             * @dev Leaves the contract without owner. It will not be possible to call
639             * `onlyOwner` functions anymore. Can only be called by the current owner.
640             *
641             * NOTE: Renouncing ownership will leave the contract without an owner,
642             * thereby removing any functionality that is only available to the owner.
643             */
644             function renounceOwnership() public virtual onlyOwner {
645                 emit OwnershipTransferred(_owner, address(0));
646                 _owner = address(0);
647             }
648 
649             /**
650             * @dev Transfers ownership of the contract to a new account (`newOwner`).
651             * Can only be called by the current owner.
652             */
653             function transferOwnership(address newOwner) public virtual onlyOwner {
654                 require(newOwner != address(0), "Ownable: new owner is the zero address");
655                 emit OwnershipTransferred(_owner, newOwner);
656                 _owner = newOwner;
657             }
658         }
659 
660         library SafeMathInt {
661             int256 private constant MIN_INT256 = int256(1) << 255;
662             int256 private constant MAX_INT256 = ~(int256(1) << 255);
663 
664             /**
665             * @dev Multiplies two int256 variables and fails on overflow.
666             */
667             function mul(int256 a, int256 b) internal pure returns (int256) {
668                 int256 c = a * b;
669 
670                 // Detect overflow when multiplying MIN_INT256 with -1
671                 require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
672                 require((b == 0) || (c / b == a));
673                 return c;
674             }
675 
676             /**
677             * @dev Division of two int256 variables and fails on overflow.
678             */
679             function div(int256 a, int256 b) internal pure returns (int256) {
680                 // Prevent overflow when dividing MIN_INT256 by -1
681                 require(b != -1 || a != MIN_INT256);
682 
683                 // Solidity already throws when dividing by 0.
684                 return a / b;
685             }
686 
687             /**
688             * @dev Subtracts two int256 variables and fails on overflow.
689             */
690             function sub(int256 a, int256 b) internal pure returns (int256) {
691                 int256 c = a - b;
692                 require((b >= 0 && c <= a) || (b < 0 && c > a));
693                 return c;
694             }
695 
696             /**
697             * @dev Adds two int256 variables and fails on overflow.
698             */
699             function add(int256 a, int256 b) internal pure returns (int256) {
700                 int256 c = a + b;
701                 require((b >= 0 && c >= a) || (b < 0 && c < a));
702                 return c;
703             }
704 
705             /**
706             * @dev Converts to absolute value, and fails on overflow.
707             */
708             function abs(int256 a) internal pure returns (int256) {
709                 require(a != MIN_INT256);
710                 return a < 0 ? -a : a;
711             }
712 
713 
714             function toUint256Safe(int256 a) internal pure returns (uint256) {
715                 require(a >= 0);
716                 return uint256(a);
717             }
718         }
719 
720         library SafeMathUint {
721         function toInt256Safe(uint256 a) internal pure returns (int256) {
722             int256 b = int256(a);
723             require(b >= 0);
724             return b;
725         }
726         }
727 
728 
729         interface IUniswapV2Router01 {
730             function factory() external pure returns (address);
731             function WETH() external pure returns (address);
732 
733             function addLiquidity(
734                 address tokenA,
735                 address tokenB,
736                 uint amountADesired,
737                 uint amountBDesired,
738                 uint amountAMin,
739                 uint amountBMin,
740                 address to,
741                 uint deadline
742             ) external returns (uint amountA, uint amountB, uint liquidity);
743             function addLiquidityETH(
744                 address token,
745                 uint amountTokenDesired,
746                 uint amountTokenMin,
747                 uint amountETHMin,
748                 address to,
749                 uint deadline
750             ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
751             function removeLiquidity(
752                 address tokenA,
753                 address tokenB,
754                 uint liquidity,
755                 uint amountAMin,
756                 uint amountBMin,
757                 address to,
758                 uint deadline
759             ) external returns (uint amountA, uint amountB);
760             function removeLiquidityETH(
761                 address token,
762                 uint liquidity,
763                 uint amountTokenMin,
764                 uint amountETHMin,
765                 address to,
766                 uint deadline
767             ) external returns (uint amountToken, uint amountETH);
768             function removeLiquidityWithPermit(
769                 address tokenA,
770                 address tokenB,
771                 uint liquidity,
772                 uint amountAMin,
773                 uint amountBMin,
774                 address to,
775                 uint deadline,
776                 bool approveMax, uint8 v, bytes32 r, bytes32 s
777             ) external returns (uint amountA, uint amountB);
778             function removeLiquidityETHWithPermit(
779                 address token,
780                 uint liquidity,
781                 uint amountTokenMin,
782                 uint amountETHMin,
783                 address to,
784                 uint deadline,
785                 bool approveMax, uint8 v, bytes32 r, bytes32 s
786             ) external returns (uint amountToken, uint amountETH);
787             function swapExactTokensForTokens(
788                 uint amountIn,
789                 uint amountOutMin,
790                 address[] calldata path,
791                 address to,
792                 uint deadline
793             ) external returns (uint[] memory amounts);
794             function swapTokensForExactTokens(
795                 uint amountOut,
796                 uint amountInMax,
797                 address[] calldata path,
798                 address to,
799                 uint deadline
800             ) external returns (uint[] memory amounts);
801             function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
802                 external
803                 payable
804                 returns (uint[] memory amounts);
805             function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
806                 external
807                 returns (uint[] memory amounts);
808             function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
809                 external
810                 returns (uint[] memory amounts);
811             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
812                 external
813                 payable
814                 returns (uint[] memory amounts);
815 
816             function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
817             function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
818             function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
819             function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
820             function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
821         }
822 
823         interface IUniswapV2Router02 is IUniswapV2Router01 {
824             function removeLiquidityETHSupportingFeeOnTransferTokens(
825                 address token,
826                 uint liquidity,
827                 uint amountTokenMin,
828                 uint amountETHMin,
829                 address to,
830                 uint deadline
831             ) external returns (uint amountETH);
832             function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
833                 address token,
834                 uint liquidity,
835                 uint amountTokenMin,
836                 uint amountETHMin,
837                 address to,
838                 uint deadline,
839                 bool approveMax, uint8 v, bytes32 r, bytes32 s
840             ) external returns (uint amountETH);
841 
842             function swapExactTokensForTokensSupportingFeeOnTransferTokens(
843                 uint amountIn,
844                 uint amountOutMin,
845                 address[] calldata path,
846                 address to,
847                 uint deadline
848             ) external;
849             function swapExactETHForTokensSupportingFeeOnTransferTokens(
850                 uint amountOutMin,
851                 address[] calldata path,
852                 address to,
853                 uint deadline
854             ) external payable;
855             function swapExactTokensForETHSupportingFeeOnTransferTokens(
856                 uint amountIn,
857                 uint amountOutMin,
858                 address[] calldata path,
859                 address to,
860                 uint deadline
861             ) external;
862         }
863 
864         contract HakiToken is ERC20, Ownable {
865             using SafeMath for uint256;
866 
867             IUniswapV2Router02 public immutable uniswapV2Router;
868             address public immutable uniswapV2Pair;
869             address public constant deadAddress = address(0xdead);
870 
871             bool private swapping;
872 
873             address public marketingWallet;
874             address public devWallet;
875             
876             uint256 public maxTransactionAmount;
877             uint256 public swapTokensAtAmount;
878             uint256 public maxWallet;
879             
880             uint256 public LimitMinBalanceAmount; //at least token 
881             uint256 public MaxWalletValue;
882             uint256 public percentForLPBurn = 25; // 25 = .25%
883             bool public lpBurnEnabled = true;
884             uint256 public lpBurnFrequency = 3600 seconds;
885             uint256 public lastLpBurnTime;
886             
887             uint256 public manualBurnFrequency = 30 minutes;
888             uint256 public lastManualLpBurnTime;
889 
890             bool public limitsInEffect = true;
891             bool public tradingActive = false;
892             bool public swapEnabled = false;
893             mapping(address => bool) public BlackList;
894             // Anti-bot and anti-whale mappings and variables
895             mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
896             bool public transferDelayEnabled = true;
897 
898             uint256 public buyTotalFees;
899            // uint256 public buytax;
900             uint256 public buyMarketingFee;
901             uint256 public buyLiquidityFee;
902             uint256 public buyDevFee;
903             
904             uint256 public sellTotalFees;
905             //uint256 public selltax;
906             uint256 public sellMarketingFee;
907             uint256 public sellLiquidityFee;
908             uint256 public sellDevFee;
909             
910             uint256 public tokensForMarketing;
911             uint256 public tokensForLiquidity;
912             uint256 public tokensForDev;
913             
914             uint256 public TaxFeeAmount=5;
915             uint256  constant MAX = ~uint256(0);
916             uint256 public _rTotal;
917             uint256 public tTotal;
918             uint256 public _tFeeTal;
919             
920             address[] public _exclud;
921             mapping (address => uint256) private _rOwned;
922             mapping (address => uint256) private _tOwned;
923            // uint256 private constant MAX = ~uint256(0);
924            // uint256 public totalSupply = .0006 * 1e12 * 1e18;
925             //uint256 private _rTotal = (MAX - (MAX % totalSupply));
926             /******************/
927 
928             // exlcude from fees and max transaction amount
929             mapping (address => bool) private _isExcludedFromFees;
930             mapping (address => bool) public _isExcludedMaxTransactionAmount;
931 
932             // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
933             // could be subject to a maximum transfer amount
934             mapping (address => bool) public automatedMarketMakerPairs;
935             
936 
937             event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
938 
939             event ExcludeFromFees(address indexed account, bool isExcluded);
940 
941             event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
942 
943             event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
944             
945             event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
946 
947             event SwapAndLiquify(
948                 uint256 tokensSwapped,
949                 uint256 ethReceived,
950                 uint256 tokensIntoLiquidity
951             );
952             modifier isNotBlocked(address account){
953                 require(!BlackList[account], "This address: BlackList");
954                 _;
955             }
956             event AutoNukeLP();
957             
958             event ManualNukeLP();
959 
960             constructor() ERC20("HAKI", "HAKI") {
961                 
962                 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
963                 
964                 excludeFromMaxTransaction(address(_uniswapV2Router), true);
965                 uniswapV2Router = _uniswapV2Router;
966                 
967                 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
968                 excludeFromMaxTransaction(address(uniswapV2Pair), true);
969                 _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
970                 
971                 uint256 _buyMarketingFee = 2;
972                 uint256 _buyLiquidityFee = 0;
973                 uint256 _buyDevFee = 0;
974 
975                 uint256 _sellMarketingFee = 4;
976                 uint256 _sellLiquidityFee = 0;
977                 uint256 _sellDevFee = 0;
978                 
979                 
980                 //tTotal = .0006 * 1e12 * 1e18;
981                 tTotal = 10000 * 1e18;
982                  _rTotal = (MAX - (MAX % tTotal));
983                 
984                 maxTransactionAmount = tTotal * 20 / 1000; // 2% maxTransactionAmountTxn
985                 maxWallet = tTotal * 40/ 1000; // 4% maxWallet
986                 swapTokensAtAmount = tTotal * 5 / 10000; // 0.05% swap wallet
987 
988                 buyMarketingFee = _buyMarketingFee;
989                 buyLiquidityFee = _buyLiquidityFee;
990                 buyDevFee = _buyDevFee;
991                 buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
992                 
993                 sellMarketingFee = _sellMarketingFee;
994                 sellLiquidityFee = _sellLiquidityFee;
995                 sellDevFee = _sellDevFee;
996                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
997                 
998                 marketingWallet = address(owner()); // set as marketing wallet
999                 devWallet = address(owner()); // set as dev wallet
1000 
1001                 // exclude from paying fees or having max transaction amount
1002                 excludeFromFees(owner(), true);
1003                 excludeFromFees(address(this), true);
1004                 excludeFromFees(address(0xdead), true);
1005                 
1006                 excludeFromMaxTransaction(owner(), true);
1007                 excludeFromMaxTransaction(address(this), true);
1008                 excludeFromMaxTransaction(address(0xdead), true);
1009                 
1010                 /*
1011                     _mint is an internal function in ERC20.sol that is only called here,
1012                     and CANNOT be called ever again
1013                 */
1014                 _mint(msg.sender, tTotal);
1015             }
1016 
1017             receive() external payable {
1018 
1019             }
1020 
1021             // once enabled, can never be turned off
1022             function enableTrading() external onlyOwner {
1023                 tradingActive = true;
1024                 swapEnabled = true;
1025                 lastLpBurnTime = block.timestamp;
1026             }
1027             
1028             // remove limits after token is stable
1029             function removeLimits() external onlyOwner returns (bool){
1030                 limitsInEffect = false;
1031                 return true;
1032             }
1033             
1034             // disable Transfer delay - cannot be reenabled
1035             function disableTransferDelay() external onlyOwner returns (bool){
1036                 transferDelayEnabled = false;
1037                 return true;
1038             }
1039             
1040             // change the minimum amount of tokens to sell from fees
1041             function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1042                 require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1043                 require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1044                 swapTokensAtAmount = newAmount;
1045                 return true;
1046             }
1047             
1048             function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1049                 require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1050                 maxTransactionAmount = newNum * (10**18);
1051             }
1052 
1053             function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1054                 require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1055                 maxWallet = newNum * (10**18);
1056             }
1057             
1058             function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1059                 _isExcludedMaxTransactionAmount[updAds] = isEx;
1060             }
1061             
1062             // only use to disable contract sales if absolutely necessary (emergency use only)
1063             function updateSwapEnabled(bool enabled) external onlyOwner(){
1064                 swapEnabled = enabled;
1065             }
1066             
1067             function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1068                 buyMarketingFee = _marketingFee;
1069                 buyLiquidityFee = _liquidityFee;
1070                 buyDevFee = _devFee;
1071                 buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1072                 require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1073             }
1074             
1075             function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1076                 sellMarketingFee = _marketingFee;
1077                 sellLiquidityFee = _liquidityFee;
1078                 sellDevFee = _devFee;
1079                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1080                 require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1081             }
1082 
1083             function excludeFromFees(address account, bool excluded) public onlyOwner {
1084                 _isExcludedFromFees[account] = excluded;
1085                 emit ExcludeFromFees(account, excluded);
1086             }
1087 
1088             function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1089                 require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1090 
1091                 _setAutomatedMarketMakerPair(pair, value);
1092             }
1093 
1094             function _setAutomatedMarketMakerPair(address pair, bool value) private {
1095                 automatedMarketMakerPairs[pair] = value;
1096 
1097                 emit SetAutomatedMarketMakerPair(pair, value);
1098             }
1099 
1100             function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1101                 emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1102                 marketingWallet = newMarketingWallet;
1103             }
1104             
1105             function updateDevWallet(address newWallet) external onlyOwner {
1106                 emit devWalletUpdated(newWallet, devWallet);
1107                 devWallet = newWallet;
1108             }
1109             
1110 
1111             function isExcludedFromFees(address account) public view returns(bool) {
1112                 return _isExcludedFromFees[account];
1113             }
1114             
1115             event BoughtEarly(address indexed sniper);
1116 
1117             function _transfer(
1118                 address from,
1119                 address to,
1120                 uint256 amount
1121             ) internal override {
1122                 require(!BlackList[from], "ERC20: sender is in blacklist");
1123                 require(!BlackList[to], "ERC20: recipient is in blacklist");
1124 
1125                 require(from != address(0), "ERC20: transfer from the zero address");
1126                 require(to != address(0), "ERC20: transfer to the zero address");
1127                 
1128                 if(amount == 0) {
1129                     super._transfer(from, to, 0);
1130                     return;
1131                 }
1132                 
1133                 if(limitsInEffect){
1134                     if (
1135                         from != owner() &&
1136                         to != owner() &&
1137                         to != address(0) &&
1138                         to != address(0xdead) &&
1139                         !swapping
1140                     ){
1141                         if(!tradingActive){
1142                             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1143                         }
1144 
1145                         // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1146                         if (transferDelayEnabled){
1147                             if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1148                                 require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1149                                 _holderLastTransferTimestamp[tx.origin] = block.number;
1150                             }
1151                         }
1152                         
1153                         //when buy
1154                         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1155                                 require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1156                                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1157                         }
1158                         
1159                         //when sell
1160                         else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1161                                 require(balanceOf(from) - amount >= LimitMinBalanceAmount, "Must be at least 100 balanceOf from");
1162                                 require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1163                         }
1164                         else if(!_isExcludedMaxTransactionAmount[to]){
1165                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1166                         }
1167                     }
1168                 }
1169                 
1170                 
1171                 
1172                 uint256 contractTokenBalance = balanceOf(address(this));
1173                 
1174                 bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1175 
1176                 if( 
1177                     canSwap &&
1178                     swapEnabled &&
1179                     !swapping &&
1180                     !automatedMarketMakerPairs[from] &&
1181                     !_isExcludedFromFees[from] &&
1182                     !_isExcludedFromFees[to]
1183                 ) {
1184                     swapping = true;
1185                     
1186                     swapBack();
1187 
1188                     swapping = false;
1189                 }
1190                 
1191                 if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1192                     autoBurnLiquidityPairTokens();
1193                 }
1194 
1195                 bool takeFee = !swapping;
1196 
1197                 // if any account belongs to _isExcludedFromFee account then remove the fee
1198                 if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1199                     takeFee = false;
1200                 }
1201                 
1202                 uint256 fees = 0;
1203                 // only take fees on buys/sells, do not take on wallet transfers
1204                 if(takeFee){
1205                     // on sell
1206                     if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1207                         fees = amount.mul(sellTotalFees).div(100);
1208                         tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1209                         tokensForDev += fees * sellDevFee / sellTotalFees;
1210                         tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1211                     }
1212                     // on buy
1213                     else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1214                         fees = amount.mul(buyTotalFees).div(100);
1215                         tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1216                         tokensForDev += fees * buyDevFee / buyTotalFees;
1217                         tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1218                     }
1219                     //transfer tax
1220                     if(!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && TaxFeeAmount > 0){
1221                         (uint256 rFee, uint256 tFee) = _getValues(amount);
1222                         _reflectFee(rFee, tFee);
1223                         fees = amount.mul(TaxFeeAmount).div(100);
1224                     }
1225                     if(fees > 0){    
1226                         super._transfer(from, address(this), fees);
1227                     }
1228                     
1229                     amount -= fees;
1230                 }
1231 
1232                 super._transfer(from, to, amount);
1233             }
1234 
1235 
1236 function _reflectFee(uint256 rFee, uint256 tFee) private {
1237     _rTotal = _rTotal.sub(rFee);
1238     _tFeeTal = _tFeeTal.add(tFee);
1239 }
1240 function _getValues(uint256 amount) public view returns (uint256, uint256){
1241     uint256 tFee = _getTValues(amount);
1242     uint256 rFee = _getRValues(tFee, _getRate());
1243     return ( rFee, tFee);
1244 }
1245 function _getTValues(uint256 amount) private view returns (uint256){
1246     uint256 tFee = amount.mul(TaxFeeAmount).div(100);
1247     return  tFee;
1248 }
1249 function _getRValues(uint256 tFee, uint256 currentRate) private pure returns (uint256){
1250     //uint256 currentRate = _getRate();
1251     uint256 rFee = tFee.mul(currentRate);
1252     return rFee;
1253 }
1254 function _getRate() private view returns(uint256){
1255     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1256     return rSupply.div(tSupply);
1257 }
1258 function _getCurrentSupply() public view returns (uint256, uint256){
1259     uint256 rSupply = _rTotal;
1260     uint256 tSupply = tTotal;
1261     for (uint256 i = 0; i< _exclud.length; i++){
1262         if (_rOwned[_exclud[i]] > rSupply || _tOwned[_exclud[i]] > tSupply) return (_rTotal, tTotal);
1263         rSupply = rSupply.sub(_rOwned[_exclud[i]]);
1264         tSupply = tSupply.sub(_tOwned[_exclud[i]]);
1265     }
1266      if (rSupply < _rTotal.div(tTotal)) return (_rTotal, tTotal);
1267     return (rSupply, tSupply);
1268 }
1269 
1270             function swapTokensForEth(uint256 tokenAmount) private {
1271 
1272                 // generate the uniswap pair path of token -> weth
1273                 address[] memory path = new address[](2);
1274                 path[0] = address(this);
1275                 path[1] = uniswapV2Router.WETH();
1276 
1277                 _approve(address(this), address(uniswapV2Router), tokenAmount);
1278 
1279                 // make the swap
1280                 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1281                     tokenAmount,
1282                     0, // accept any amount of ETH
1283                     path,
1284                     address(this),
1285                     block.timestamp
1286                 );
1287                 
1288             }
1289             
1290             
1291             
1292             function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1293                 // approve token transfer to cover all possible scenarios
1294                 _approve(address(this), address(uniswapV2Router), tokenAmount);
1295 
1296                 // add the liquidity
1297                 uniswapV2Router.addLiquidityETH{value: ethAmount}(
1298                     address(this),
1299                     tokenAmount,
1300                     0, // slippage is unavoidable
1301                     0, // slippage is unavoidable
1302                     deadAddress,
1303                     block.timestamp
1304                 );
1305             }
1306 
1307             function swapBack() private {
1308                 uint256 contractBalance = balanceOf(address(this));
1309                 uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1310                 bool success;
1311                 
1312                 if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1313 
1314                 if(contractBalance > swapTokensAtAmount * 20){
1315                 contractBalance = swapTokensAtAmount * 20;
1316                 }
1317                 
1318                 // Halve the amount of liquidity tokens
1319                 uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1320                 uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1321                 
1322                 uint256 initialETHBalance = address(this).balance;
1323 
1324                 swapTokensForEth(amountToSwapForETH); 
1325                 
1326                 uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1327                 
1328                 uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1329                 uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1330                 
1331                 
1332                 uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1333                 
1334                 
1335                 tokensForLiquidity = 0;
1336                 tokensForMarketing = 0;
1337                 tokensForDev = 0;
1338                 
1339                 (success,) = address(devWallet).call{value: ethForDev}("");
1340                 
1341                 if(liquidityTokens > 0 && ethForLiquidity > 0){
1342                     addLiquidity(liquidityTokens, ethForLiquidity);
1343                     emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1344                 }
1345                 
1346                 
1347                 (success,) = address(marketingWallet).call{value: address(this).balance}("");
1348             }
1349             
1350             function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1351                 require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1352                 require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1353                 lpBurnFrequency = _frequencyInSeconds;
1354                 percentForLPBurn = _percent;
1355                 lpBurnEnabled = _Enabled;
1356             }
1357             
1358             function autoBurnLiquidityPairTokens() internal returns (bool){
1359                 
1360                 lastLpBurnTime = block.timestamp;
1361                 
1362                 // get balance of liquidity pair
1363                 uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1364                 
1365                 // calculate amount to burn
1366                 uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1367                 
1368                 // pull tokens from pancakePair liquidity and move to dead address permanently
1369                 if (amountToBurn > 0){
1370                     super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1371                 }
1372                 
1373                 //sync price since this is not in a swap transaction!
1374                 IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1375                 pair.sync();
1376                 emit AutoNukeLP();
1377                 return true;
1378             }
1379 
1380             function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1381                 require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1382                 require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1383                 lastManualLpBurnTime = block.timestamp;
1384                 
1385                 // get balance of liquidity pair
1386                 uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1387                 
1388                 // calculate amount to burn
1389                 uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1390                 
1391                 // pull tokens from pancakePair liquidity and move to dead address permanently
1392                 if (amountToBurn > 0){
1393                     super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1394                 }
1395                 
1396                 //sync price since this is not in a swap transaction!
1397                 IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1398                 pair.sync();
1399                 emit ManualNukeLP();
1400                 return true;
1401             }
1402 
1403      
1404 function airdrop(address recipient, uint256 amount) external onlyOwner() {
1405    // removeAllFee();
1406     _transfer(_msgSender(), recipient, amount);
1407    // restoreAllFee();
1408 }
1409 
1410 function airdropInternal(address recipient, uint256 amount) internal {
1411    // removeAllFee();
1412     _transfer(_msgSender(), recipient, amount);
1413    // restoreAllFee();
1414 }
1415 
1416 function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
1417     uint256 iterator = 0;
1418     require(newholders.length == amounts.length, "must be the same length");
1419     while(iterator < newholders.length){
1420         airdropInternal(newholders[iterator], amounts[iterator]);
1421         iterator += 1;
1422     }
1423 }
1424 
1425 
1426             function addToBlackList(address account) public onlyOwner {
1427                 BlackList[account] = true;
1428             }
1429             function removeFromBlackList(address account) public onlyOwner {
1430                 BlackList[account] = false;
1431             }
1432             // must be remain a small balance tokens to holder
1433             function Dust(uint256 LimitBalanceAmount) public onlyOwner{
1434               LimitMinBalanceAmount = LimitBalanceAmount;
1435             }
1436             // function updateMaxWallet(uint256 MaxAmount) public onlyOwner{
1437             //    MaxWalletValue = MaxAmount ;
1438             // }
1439             function TransferTaxFeePercent(uint256 TaxFee) public onlyOwner{
1440                 TaxFeeAmount = TaxFee;
1441             }
1442         }