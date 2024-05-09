1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 /*
5 Website : dime.ooo
6 Telegram : https://t.me/paradime_erc20
7 
8 Tokenomics : 5% liquidity 4% burn 1% marketing 
9 
10 Renounced + Liquidity burned = SAFU
11 
12 Hyper deflationary and hyper liquidity combined to create a “Paradime” shift. Tokenomics designed to benefit the token and it’s holders.   
13 
14 */
15 pragma solidity 0.8.9;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IUniswapV2Pair {
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Transfer(address indexed from, address indexed to, uint value);
31 
32     function name() external pure returns (string memory);
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38 
39     function approve(address spender, uint value) external returns (bool);
40     function transfer(address to, uint value) external returns (bool);
41     function transferFrom(address from, address to, uint value) external returns (bool);
42 
43     function DOMAIN_SEPARATOR() external view returns (bytes32);
44     function PERMIT_TYPEHASH() external pure returns (bytes32);
45     function nonces(address owner) external view returns (uint);
46 
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48 
49     event Mint(address indexed sender, uint amount0, uint amount1);
50     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
51     event Swap(
52         address indexed sender,
53         uint amount0In,
54         uint amount1In,
55         uint amount0Out,
56         uint amount1Out,
57         address indexed to
58     );
59     event Sync(uint112 reserve0, uint112 reserve1);
60 
61     function MINIMUM_LIQUIDITY() external pure returns (uint);
62     function factory() external view returns (address);
63     function token0() external view returns (address);
64     function token1() external view returns (address);
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function price0CumulativeLast() external view returns (uint);
67     function price1CumulativeLast() external view returns (uint);
68     function kLast() external view returns (uint);
69 
70     function mint(address to) external returns (uint liquidity);
71     function burn(address to) external returns (uint amount0, uint amount1);
72     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
73     function skim(address to) external;
74     function sync() external;
75 
76     function initialize(address, address) external;
77 }
78 
79 interface IUniswapV2Factory {
80     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
81 
82     function feeTo() external view returns (address);
83     function feeToSetter() external view returns (address);
84 
85     function getPair(address tokenA, address tokenB) external view returns (address pair);
86     function allPairs(uint) external view returns (address pair);
87     function allPairsLength() external view returns (uint);
88 
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 
91     function setFeeTo(address) external;
92     function setFeeToSetter(address) external;
93 }
94 
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) external returns (bool);
154 
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 interface IERC20Metadata is IERC20 {
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() external view returns (string memory);
175 
176     /**
177      * @dev Returns the symbol of the token.
178      */
179     function symbol() external view returns (string memory);
180 
181     /**
182      * @dev Returns the decimals places of the token.
183      */
184     function decimals() external view returns (uint8);
185 }
186 
187 
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     using SafeMath for uint256;
190 
191     mapping(address => uint256) private _balances;
192 
193     mapping(address => mapping(address => uint256)) private _allowances;
194 
195     uint256 private _totalSupply;
196 
197     string private _name;
198     string private _symbol;
199 
200     /**
201      * @dev Sets the values for {name} and {symbol}.
202      *
203      * The default value of {decimals} is 18. To select a different value for
204      * {decimals} you should overload it.
205      *
206      * All two of these values are immutable: they can only be set once during
207      * construction.
208      */
209     constructor(string memory name_, string memory symbol_) {
210         _name = name_;
211         _symbol = symbol_;
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view virtual override returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view virtual override returns (string memory) {
226         return _symbol;
227     }
228 
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei. This is the value {ERC20} uses, unless this function is
236      * overridden;
237      *
238      * NOTE: This information is only used for _display_ purposes: it in
239      * no way affects any of the arithmetic of the contract, including
240      * {IERC20-balanceOf} and {IERC20-transfer}.
241      */
242     function decimals() public view virtual override returns (uint8) {
243         return 6;
244     }
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address account) public view virtual override returns (uint256) {
257         return _balances[account];
258     }
259 
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `recipient` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     /**
293      * @dev See {IERC20-transferFrom}.
294      *
295      * Emits an {Approval} event indicating the updated allowance. This is not
296      * required by the EIP. See the note at the beginning of {ERC20}.
297      *
298      * Requirements:
299      *
300      * - `sender` and `recipient` cannot be the zero address.
301      * - `sender` must have a balance of at least `amount`.
302      * - the caller must have allowance for ``sender``'s tokens of at least
303      * `amount`.
304      */
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) public virtual override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
348         return true;
349     }
350 
351     /**
352      * @dev Moves tokens `amount` from `sender` to `recipient`.
353      *
354      * This is internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(sender, recipient, amount);
374 
375         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
376         _balances[recipient] = _balances[recipient].add(amount);
377         emit Transfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply = _totalSupply.add(amount);
395         _balances[account] = _balances[account].add(amount);
396         emit Transfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
416         _totalSupply = _totalSupply.sub(amount);
417         emit Transfer(account, address(0), amount);
418     }
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(
434         address owner,
435         address spender,
436         uint256 amount
437     ) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440 
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444 
445     /**
446      * @dev Hook that is called before any transfer of tokens. This includes
447      * minting and burning.
448      *
449      * Calling conditions:
450      *
451      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
452      * will be to transferred to `to`.
453      * - when `from` is zero, `amount` tokens will be minted for `to`.
454      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
455      * - `from` and `to` are never both zero.
456      *
457      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
458      */
459     function _beforeTokenTransfer(
460         address from,
461         address to,
462         uint256 amount
463     ) internal virtual {}
464 }
465 
466 library SafeMath {
467     /**
468      * @dev Returns the addition of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `+` operator.
472      *
473      * Requirements:
474      *
475      * - Addition cannot overflow.
476      */
477     function add(uint256 a, uint256 b) internal pure returns (uint256) {
478         uint256 c = a + b;
479         require(c >= a, "SafeMath: addition overflow");
480 
481         return c;
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         return sub(a, b, "SafeMath: subtraction overflow");
496     }
497 
498     /**
499      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
500      * overflow (when the result is negative).
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b <= a, errorMessage);
510         uint256 c = a - b;
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the multiplication of two unsigned integers, reverting on
517      * overflow.
518      *
519      * Counterpart to Solidity's `*` operator.
520      *
521      * Requirements:
522      *
523      * - Multiplication cannot overflow.
524      */
525     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
526         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
527         // benefit is lost if 'b' is also tested.
528         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
529         if (a == 0) {
530             return 0;
531         }
532 
533         uint256 c = a * b;
534         require(c / a == b, "SafeMath: multiplication overflow");
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         return div(a, b, "SafeMath: division by zero");
553     }
554 
555     /**
556      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * Counterpart to Solidity's `/` operator. Note: this function uses a
560      * `revert` opcode (which leaves remaining gas untouched) while Solidity
561      * uses an invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
568         require(b > 0, errorMessage);
569         uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571 
572         return c;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
588         return mod(a, b, "SafeMath: modulo by zero");
589     }
590 
591     /**
592      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
593      * Reverts with custom message when dividing by zero.
594      *
595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
596      * opcode (which leaves remaining gas untouched) while Solidity uses an
597      * invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b != 0, errorMessage);
605         return a % b;
606     }
607 }
608 
609 contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613     
614     /**
615      * @dev Initializes the contract setting the deployer as the initial owner.
616      */
617     constructor () {
618         address msgSender = _msgSender();
619         _owner = msgSender;
620         emit OwnershipTransferred(address(0), msgSender);
621     }
622 
623     /**
624      * @dev Returns the address of the current owner.
625      */
626     function owner() public view returns (address) {
627         return _owner;
628     }
629 
630     /**
631      * @dev Throws if called by any account other than the owner.
632      */
633     modifier onlyOwner() {
634         require(_owner == _msgSender(), "Ownable: caller is not the owner");
635         _;
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions anymore. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby removing any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public virtual onlyOwner {
646         emit OwnershipTransferred(_owner, address(0));
647         _owner = address(0);
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Can only be called by the current owner.
653      */
654     function transferOwnership(address newOwner) public virtual onlyOwner {
655         require(newOwner != address(0), "Ownable: new owner is the zero address");
656         emit OwnershipTransferred(_owner, newOwner);
657         _owner = newOwner;
658     }
659 }
660 
661 
662 
663 library SafeMathInt {
664     int256 private constant MIN_INT256 = int256(1) << 255;
665     int256 private constant MAX_INT256 = ~(int256(1) << 255);
666 
667     /**
668      * @dev Multiplies two int256 variables and fails on overflow.
669      */
670     function mul(int256 a, int256 b) internal pure returns (int256) {
671         int256 c = a * b;
672 
673         // Detect overflow when multiplying MIN_INT256 with -1
674         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
675         require((b == 0) || (c / b == a));
676         return c;
677     }
678 
679     /**
680      * @dev Division of two int256 variables and fails on overflow.
681      */
682     function div(int256 a, int256 b) internal pure returns (int256) {
683         // Prevent overflow when dividing MIN_INT256 by -1
684         require(b != -1 || a != MIN_INT256);
685 
686         // Solidity already throws when dividing by 0.
687         return a / b;
688     }
689 
690     /**
691      * @dev Subtracts two int256 variables and fails on overflow.
692      */
693     function sub(int256 a, int256 b) internal pure returns (int256) {
694         int256 c = a - b;
695         require((b >= 0 && c <= a) || (b < 0 && c > a));
696         return c;
697     }
698 
699     /**
700      * @dev Adds two int256 variables and fails on overflow.
701      */
702     function add(int256 a, int256 b) internal pure returns (int256) {
703         int256 c = a + b;
704         require((b >= 0 && c >= a) || (b < 0 && c < a));
705         return c;
706     }
707 
708     /**
709      * @dev Converts to absolute value, and fails on overflow.
710      */
711     function abs(int256 a) internal pure returns (int256) {
712         require(a != MIN_INT256);
713         return a < 0 ? -a : a;
714     }
715 
716 
717     function toUint256Safe(int256 a) internal pure returns (uint256) {
718         require(a >= 0);
719         return uint256(a);
720     }
721 }
722 
723 library SafeMathUint {
724   function toInt256Safe(uint256 a) internal pure returns (int256) {
725     int256 b = int256(a);
726     require(b >= 0);
727     return b;
728   }
729 }
730 
731 
732 interface IUniswapV2Router01 {
733     function factory() external pure returns (address);
734     function WETH() external pure returns (address);
735 
736     function addLiquidity(
737         address tokenA,
738         address tokenB,
739         uint amountADesired,
740         uint amountBDesired,
741         uint amountAMin,
742         uint amountBMin,
743         address to,
744         uint deadline
745     ) external returns (uint amountA, uint amountB, uint liquidity);
746     function addLiquidityETH(
747         address token,
748         uint amountTokenDesired,
749         uint amountTokenMin,
750         uint amountETHMin,
751         address to,
752         uint deadline
753     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
754     function removeLiquidity(
755         address tokenA,
756         address tokenB,
757         uint liquidity,
758         uint amountAMin,
759         uint amountBMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountA, uint amountB);
763     function removeLiquidityETH(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline
770     ) external returns (uint amountToken, uint amountETH);
771     function removeLiquidityWithPermit(
772         address tokenA,
773         address tokenB,
774         uint liquidity,
775         uint amountAMin,
776         uint amountBMin,
777         address to,
778         uint deadline,
779         bool approveMax, uint8 v, bytes32 r, bytes32 s
780     ) external returns (uint amountA, uint amountB);
781     function removeLiquidityETHWithPermit(
782         address token,
783         uint liquidity,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external returns (uint amountToken, uint amountETH);
790     function swapExactTokensForTokens(
791         uint amountIn,
792         uint amountOutMin,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external returns (uint[] memory amounts);
797     function swapTokensForExactTokens(
798         uint amountOut,
799         uint amountInMax,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external returns (uint[] memory amounts);
804     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
805         external
806         payable
807         returns (uint[] memory amounts);
808     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
809         external
810         returns (uint[] memory amounts);
811     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
812         external
813         returns (uint[] memory amounts);
814     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
815         external
816         payable
817         returns (uint[] memory amounts);
818 
819     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
820     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
821     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
822     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
823     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
824 }
825 
826 interface IUniswapV2Router02 is IUniswapV2Router01 {
827     function removeLiquidityETHSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline
834     ) external returns (uint amountETH);
835     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
836         address token,
837         uint liquidity,
838         uint amountTokenMin,
839         uint amountETHMin,
840         address to,
841         uint deadline,
842         bool approveMax, uint8 v, bytes32 r, bytes32 s
843     ) external returns (uint amountETH);
844 
845     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
846         uint amountIn,
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external;
852     function swapExactETHForTokensSupportingFeeOnTransferTokens(
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external payable;
858     function swapExactTokensForETHSupportingFeeOnTransferTokens(
859         uint amountIn,
860         uint amountOutMin,
861         address[] calldata path,
862         address to,
863         uint deadline
864     ) external;
865 }
866 
867 contract Paradime is ERC20, Ownable {
868     using SafeMath for uint256;
869 
870     IUniswapV2Router02 public immutable uniswapV2Router;
871     address public immutable uniswapV2Pair;
872     address public constant deadAddress = address(0xdead);
873 
874     bool private swapping;
875 
876     address public devWallet;
877     
878     uint256 public maxTransactionAmount;
879     uint256 public swapTokensAtAmount;
880     uint256 public maxWallet;
881 
882     bool public limitsInEffect = true;
883     bool public tradingActive = false;
884     bool public swapEnabled = false;
885     
886      // Anti-bot and anti-whale mappings and variables
887     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
888 
889     bool public transferDelayEnabled = true;
890 
891     uint256 public buyTotalFees;
892     uint256 public buyBurnFee;
893     uint256 public buyLiquidityFee;
894     uint256 public buyDevFee;
895     
896     uint256 public sellTotalFees;
897     uint256 public sellBurnFee;
898     uint256 public sellLiquidityFee;
899     uint256 public sellDevFee;
900     
901     uint256 public tokensForBurn;
902     uint256 public tokensForLiquidity;
903     uint256 public tokensForDev;
904 
905     uint256 public walletDigit;
906     uint256 public transDigit;
907     uint256 public delayDigit;
908     uint256 public supply;
909     
910     /******************/
911 
912     // exlcude from fees and max transaction amount
913     mapping (address => bool) private _isExcludedFromFees;
914     mapping (address => bool) public _isExcludedMaxTransactionAmount;
915 
916     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
917     // could be subject to a maximum transfer amount
918     mapping (address => bool) public automatedMarketMakerPairs;
919 
920     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
921 
922     event ExcludeFromFees(address indexed account, bool isExcluded);
923 
924     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
925 
926     constructor() ERC20("ParaDIME", "DIME") {
927 
928         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
929         
930         excludeFromMaxTransaction(address(_uniswapV2Router), true);
931         uniswapV2Router = _uniswapV2Router;
932         
933         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
934         excludeFromMaxTransaction(address(uniswapV2Pair), true);
935         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
936         
937         uint256 _buyBurnFee = 5;
938         uint256 _buyLiquidityFee = 4;
939         uint256 _buyDevFee = 1;
940 
941         uint256 _sellBurnFee = 5;
942         uint256 _sellLiquidityFee = 4;
943         uint256 _sellDevFee = 1;
944         
945         uint256 totalSupply = 420 * 1e6 * 1e6;
946         supply += totalSupply;
947         
948         walletDigit = 1;
949         transDigit = 1;
950         delayDigit = 5;
951 
952         maxTransactionAmount = supply * transDigit / 100;
953         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
954         maxWallet = supply * walletDigit / 100;
955 
956         buyBurnFee = _buyBurnFee;
957         buyLiquidityFee = _buyLiquidityFee;
958         buyDevFee = _buyDevFee;
959         buyTotalFees = buyBurnFee + buyLiquidityFee + buyDevFee;
960         
961         sellBurnFee = _sellBurnFee;
962         sellLiquidityFee = _sellLiquidityFee;
963         sellDevFee = _sellDevFee;
964         sellTotalFees = sellBurnFee + sellLiquidityFee + sellDevFee;
965         
966         devWallet = 0x64a3BaB7d3b5E43c835F48c0F688a43DdaA255d6; // set as dev wallet
967 
968         // exclude from paying fees or having max transaction amount
969         excludeFromFees(owner(), true);
970         excludeFromFees(address(this), true);
971         excludeFromFees(address(0xdead), true);
972         
973         excludeFromMaxTransaction(owner(), true);
974         excludeFromMaxTransaction(address(this), true);
975         excludeFromMaxTransaction(address(0xdead), true);
976         
977         /*
978             _mint is an internal function in ERC20.sol that is only called here,
979             and CANNOT be called ever again
980         */
981         _mint(0x014b1fFc3059fA2a7f27dE780E265BCB50B935DD, 42 * 1e5 * 1e6);
982         _mint(0x72BCA1E011cE2e3E5c18405D0E45728fB264AAF1, 42 * 1e5 * 1e6);
983         _mint(0xF29239CC35ee344511443524240A5f91e28578eA, 42 * 1e5 * 1e6);
984         _mint(0x0B029062E5E7985C2f4C4ADa304A729bafC3d968, 42 * 1e5 * 1e6);
985         _mint(0xBCB6af403932adfc2011cF49fc39012DC0Ae4c55, 42 * 1e5 * 1e6);
986         _mint(0x6e19da8077b7E2B0A8c1FD9fc663A18ed877d594, 42 * 1e5 * 1e6);
987 
988 
989         _approve(owner(), address(uniswapV2Router), 394800000 * 1e6);
990         _mint(msg.sender, 394800000 * 1e6);
991 
992         tradingActive = true;
993         swapEnabled = true;
994 
995     }
996 
997     receive() external payable {
998 
999   	}
1000     // remove limits after token is stable
1001     function removeLimits() external onlyOwner returns (bool){
1002         limitsInEffect = false;
1003         return true;
1004     }
1005     
1006     // disable Transfer delay - cannot be reenabled
1007     function disableTransferDelay() external onlyOwner returns (bool){
1008         transferDelayEnabled = false;
1009         return true;
1010     }
1011     
1012      // change the minimum amount of tokens to sell from fees
1013     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1014   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1015   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1016   	    swapTokensAtAmount = newAmount;
1017   	    return true;
1018   	}
1019     
1020     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1021         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1022         maxTransactionAmount = newNum * (10**18);
1023     }
1024 
1025     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1026         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1027         maxWallet = newNum * (10**18);
1028     }
1029     
1030     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1031         _isExcludedMaxTransactionAmount[updAds] = isEx;
1032     }
1033 
1034     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1035         buyBurnFee = _marketingFee;
1036         buyLiquidityFee = _liquidityFee;
1037         buyDevFee = _devFee;
1038         buyTotalFees = buyBurnFee + buyLiquidityFee + buyDevFee;
1039         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1040     }
1041     
1042     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1043         sellBurnFee = _marketingFee;
1044         sellLiquidityFee = _liquidityFee;
1045         sellDevFee = _devFee;
1046         sellTotalFees = sellBurnFee + sellLiquidityFee + sellDevFee;
1047         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1048     }
1049 
1050     function excludeFromFees(address account, bool excluded) public onlyOwner {
1051         _isExcludedFromFees[account] = excluded;
1052         emit ExcludeFromFees(account, excluded);
1053     }
1054 
1055     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1056         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1057 
1058         _setAutomatedMarketMakerPair(pair, value);
1059     }
1060 
1061     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1062         automatedMarketMakerPairs[pair] = value;
1063 
1064         emit SetAutomatedMarketMakerPair(pair, value);
1065     }
1066 
1067     function updateDevWallet(address newWallet) external onlyOwner {
1068         devWallet = newWallet;
1069     }
1070     
1071 
1072     function isExcludedFromFees(address account) public view returns(bool) {
1073         return _isExcludedFromFees[account];
1074     }
1075 
1076     function updateLimits() private {
1077         maxTransactionAmount = supply * transDigit / 100;
1078         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1079         maxWallet = supply * walletDigit / 100;
1080     }
1081 
1082     function updateDigits(uint256 _walletDigit, uint256 _transDigit, uint256 _delayDigit) external onlyOwner{
1083         walletDigit = _walletDigit;
1084         transDigit = _transDigit;
1085         delayDigit = _delayDigit;
1086     }
1087     
1088     function _transfer(
1089         address from,
1090         address to,
1091         uint256 amount
1092     ) internal override {
1093         require(from != address(0), "ERC20: transfer from the zero address");
1094         require(to != address(0), "ERC20: transfer to the zero address");
1095         
1096          if(amount == 0) {
1097             super._transfer(from, to, 0);
1098             return;
1099         }
1100         
1101         if(limitsInEffect){
1102             if (
1103                 from != owner() &&
1104                 to != owner() &&
1105                 to != address(0) &&
1106                 to != address(0xdead) &&
1107                 !swapping
1108             ){
1109                 if(!tradingActive){
1110                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1111                 }
1112 
1113                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1114                 if (transferDelayEnabled){
1115                      if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1116                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1117                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1118                     }
1119                 }
1120 
1121                 //when buy
1122                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1123                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1124                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1125                 }
1126                 
1127                 //when sell
1128                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1129                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1130                 }
1131                 else if(!_isExcludedMaxTransactionAmount[to]){
1132                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1133                 }
1134             }
1135         }
1136         
1137         
1138         
1139 		uint256 contractTokenBalance = balanceOf(address(this));
1140         
1141         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1142 
1143         if( 
1144             canSwap &&
1145             swapEnabled &&
1146             !swapping &&
1147             !automatedMarketMakerPairs[from] &&
1148             !_isExcludedFromFees[from] &&
1149             !_isExcludedFromFees[to]
1150         ) {
1151             swapping = true;
1152             
1153             swapBack();
1154 
1155             swapping = false;
1156         }
1157         
1158         bool takeFee = !swapping;
1159 
1160         // if any account belongs to _isExcludedFromFee account then remove the fee
1161         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1162             takeFee = false;
1163         }
1164         
1165         uint256 fees = 0;
1166         // only take fees on buys/sells, do not take on wallet transfers
1167         if(takeFee){
1168             // on sell
1169             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1170                 fees = amount.mul(sellTotalFees).div(100);
1171                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1172                 tokensForDev += fees * sellDevFee / sellTotalFees;
1173                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1174             }
1175             // on buy
1176             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1177         	    fees = amount.mul(buyTotalFees).div(100);
1178         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1179                 tokensForDev += fees * buyDevFee / buyTotalFees;
1180                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
1181             }
1182             
1183             if(fees > 0){
1184                 super._transfer(from, address(this), fees);
1185                 if (tokensForBurn > 0) {
1186                     _burn(address(this), tokensForBurn);
1187                     supply = totalSupply();
1188                     updateLimits();
1189                     tokensForBurn = 0;
1190                 }
1191             }
1192         	
1193         	amount -= fees;
1194         }
1195 
1196         super._transfer(from, to, amount);
1197     }
1198 
1199     function swapTokensForEth(uint256 tokenAmount) private {
1200 
1201         // generate the uniswap pair path of token -> weth
1202         address[] memory path = new address[](2);
1203         path[0] = address(this);
1204         path[1] = uniswapV2Router.WETH();
1205 
1206         _approve(address(this), address(uniswapV2Router), tokenAmount);
1207 
1208         // make the swap
1209         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1210             tokenAmount,
1211             0, // accept any amount of ETH
1212             path,
1213             address(this),
1214             block.timestamp
1215         );
1216         
1217     }
1218     
1219     
1220     
1221     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1222         // approve token transfer to cover all possible scenarios
1223         _approve(address(this), address(uniswapV2Router), tokenAmount);
1224 
1225         // add the liquidity
1226         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1227             address(this),
1228             tokenAmount,
1229             0, // slippage is unavoidable
1230             0, // slippage is unavoidable
1231             deadAddress,
1232             block.timestamp
1233         );
1234     }
1235 
1236     function swapBack() private {
1237         uint256 contractBalance = balanceOf(address(this));
1238         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1239         bool success;
1240         
1241         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1242 
1243         if(contractBalance > swapTokensAtAmount * 20){
1244           contractBalance = swapTokensAtAmount * 20;
1245         }
1246         
1247         // Halve the amount of liquidity tokens
1248         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1249         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1250         
1251         uint256 initialETHBalance = address(this).balance;
1252 
1253         swapTokensForEth(amountToSwapForETH); 
1254         
1255         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1256         
1257         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1258         
1259         
1260         uint256 ethForLiquidity = ethBalance - ethForDev;
1261         
1262         
1263         tokensForLiquidity = 0;
1264         tokensForDev = 0;
1265         
1266         if(liquidityTokens > 0 && ethForLiquidity > 0){
1267             addLiquidity(liquidityTokens, ethForLiquidity);
1268         }
1269         
1270         
1271         (success,) = address(devWallet).call{value: address(this).balance}("");
1272     }
1273 
1274 
1275 }