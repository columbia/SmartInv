1 /**
2 
3 Unleash the hidden power of wealth multiplication with Cryptosis, the ultimate catalyst for crypto metamorphosis.
4 
5 Website:   https://cryptosis.tech
6 Twitter:   https://twitter.com/CryptosisETH
7 Telegram:  https://t.me/CryptosisETH
8 
9  */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25  
26 interface IUniswapV2Pair {
27     event Approval(address indexed owner, address indexed spender, uint value);
28     event Transfer(address indexed from, address indexed to, uint value);
29  
30     function name() external pure returns (string memory);
31     function symbol() external pure returns (string memory);
32     function decimals() external pure returns (uint8);
33     function totalSupply() external view returns (uint);
34     function balanceOf(address owner) external view returns (uint);
35     function allowance(address owner, address spender) external view returns (uint);
36  
37     function approve(address spender, uint value) external returns (bool);
38     function transfer(address to, uint value) external returns (bool);
39     function transferFrom(address from, address to, uint value) external returns (bool);
40  
41     function DOMAIN_SEPARATOR() external view returns (bytes32);
42     function PERMIT_TYPEHASH() external pure returns (bytes32);
43     function nonces(address owner) external view returns (uint);
44  
45     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46  
47     event Mint(address indexed sender, uint amount0, uint amount1);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57  
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66  
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72  
73     function initialize(address, address) external;
74 }
75  
76 interface IUniswapV2Factory {
77     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
78  
79     function feeTo() external view returns (address);
80     function feeToSetter() external view returns (address);
81  
82     function getPair(address tokenA, address tokenB) external view returns (address pair);
83     function allPairs(uint) external view returns (address pair);
84     function allPairsLength() external view returns (uint);
85  
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87  
88     function setFeeTo(address) external;
89     function setFeeToSetter(address) external;
90 }
91  
92 interface IERC20 {
93     /**
94      * @dev Returns the amount of tokens in existence.
95      */
96     function totalSupply() external view returns (uint256);
97  
98     /**
99      * @dev Returns the amount of tokens owned by `account`.
100      */
101     function balanceOf(address account) external view returns (uint256);
102  
103     /**
104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transfer(address recipient, uint256 amount) external returns (bool);
111  
112     /**
113      * @dev Returns the remaining number of tokens that `spender` will be
114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
115      * zero by default.
116      *
117      * This value changes when {approve} or {transferFrom} are called.
118      */
119     function allowance(address owner, address spender) external view returns (uint256);
120  
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136  
137     /**
138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
139      * allowance mechanism. `amount` is then deducted from the caller's
140      * allowance.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) external returns (bool);
151  
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159  
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166  
167 interface IERC20Metadata is IERC20 {
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() external view returns (string memory);
172  
173     /**
174      * @dev Returns the symbol of the token.
175      */
176     function symbol() external view returns (string memory);
177  
178     /**
179      * @dev Returns the decimals places of the token.
180      */
181     function decimals() external view returns (uint8);
182 }
183  
184 contract ERC20 is Context, IERC20, IERC20Metadata {
185     using SafeMath for uint256;
186  
187     mapping(address => uint256) private _balances;
188  
189     mapping(address => mapping(address => uint256)) private _allowances;
190  
191     uint256 private _totalSupply;
192  
193     string private _name;
194     string private _symbol;
195  
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209  
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216  
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224  
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 18;
240     }
241  
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248  
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255  
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268  
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view virtual override returns (uint256) {
273         return _allowances[owner][spender];
274     }
275  
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public virtual override returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287  
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * Requirements:
295      *
296      * - `sender` and `recipient` cannot be the zero address.
297      * - `sender` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``sender``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
308         return true;
309     }
310  
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
325         return true;
326     }
327  
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
344         return true;
345     }
346  
347     /**
348      * @dev Moves tokens `amount` from `sender` to `recipient`.
349      *
350      * This is internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368  
369         _beforeTokenTransfer(sender, recipient, amount);
370  
371         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
372         _balances[recipient] = _balances[recipient].add(amount);
373         emit Transfer(sender, recipient, amount);
374     }
375  
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387  
388         _beforeTokenTransfer(address(0), account, amount);
389  
390         _totalSupply = _totalSupply.add(amount);
391         _balances[account] = _balances[account].add(amount);
392         emit Transfer(address(0), account, amount);
393     }
394  
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: burn from the zero address");
408  
409         _beforeTokenTransfer(account, address(0), amount);
410  
411         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
412         _totalSupply = _totalSupply.sub(amount);
413         emit Transfer(account, address(0), amount);
414     }
415  
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
418      *
419      * This internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436  
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440  
441     /**
442      * @dev Hook that is called before any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * will be to transferred to `to`.
449      * - when `from` is zero, `amount` tokens will be minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _beforeTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461  
462 library SafeMath {
463     /**
464      * @dev Returns the addition of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `+` operator.
468      *
469      * Requirements:
470      *
471      * - Addition cannot overflow.
472      */
473     function add(uint256 a, uint256 b) internal pure returns (uint256) {
474         uint256 c = a + b;
475         require(c >= a, "SafeMath: addition overflow");
476  
477         return c;
478     }
479  
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting on
482      * overflow (when the result is negative).
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         return sub(a, b, "SafeMath: subtraction overflow");
492     }
493  
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         uint256 c = a - b;
507  
508         return c;
509     }
510  
511     /**
512      * @dev Returns the multiplication of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `*` operator.
516      *
517      * Requirements:
518      *
519      * - Multiplication cannot overflow.
520      */
521     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
523         // benefit is lost if 'b' is also tested.
524         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
525         if (a == 0) {
526             return 0;
527         }
528  
529         uint256 c = a * b;
530         require(c / a == b, "SafeMath: multiplication overflow");
531  
532         return c;
533     }
534  
535     /**
536      * @dev Returns the integer division of two unsigned integers. Reverts on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return div(a, b, "SafeMath: division by zero");
549     }
550  
551     /**
552      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
553      * division by zero. The result is rounded towards zero.
554      *
555      * Counterpart to Solidity's `/` operator. Note: this function uses a
556      * `revert` opcode (which leaves remaining gas untouched) while Solidity
557      * uses an invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b > 0, errorMessage);
565         uint256 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567  
568         return c;
569     }
570  
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * Reverts when dividing by zero.
574      *
575      * Counterpart to Solidity's `%` operator. This function uses a `revert`
576      * opcode (which leaves remaining gas untouched) while Solidity uses an
577      * invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
584         return mod(a, b, "SafeMath: modulo by zero");
585     }
586  
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts with custom message when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b != 0, errorMessage);
601         return a % b;
602     }
603 }
604 
605  
606 contract Ownable is Context {
607     address private _owner;
608  
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610  
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor () {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619  
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626  
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), "Ownable: caller is not the owner");
632         _;
633     }
634  
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646  
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public virtual onlyOwner {
652         require(newOwner != address(0), "Ownable: new owner is the zero address");
653         emit OwnershipTransferred(_owner, newOwner);
654         _owner = newOwner;
655     }
656 }
657  
658 library SafeMathInt {
659     int256 private constant MIN_INT256 = int256(1) << 255;
660     int256 private constant MAX_INT256 = ~(int256(1) << 255);
661  
662     /**
663      * @dev Multiplies two int256 variables and fails on overflow.
664      */
665     function mul(int256 a, int256 b) internal pure returns (int256) {
666         int256 c = a * b;
667  
668         // Detect overflow when multiplying MIN_INT256 with -1
669         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
670         require((b == 0) || (c / b == a));
671         return c;
672     }
673  
674     /**
675      * @dev Division of two int256 variables and fails on overflow.
676      */
677     function div(int256 a, int256 b) internal pure returns (int256) {
678         // Prevent overflow when dividing MIN_INT256 by -1
679         require(b != -1 || a != MIN_INT256);
680  
681         // Solidity already throws when dividing by 0.
682         return a / b;
683     }
684  
685     /**
686      * @dev Subtracts two int256 variables and fails on overflow.
687      */
688     function sub(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a - b;
690         require((b >= 0 && c <= a) || (b < 0 && c > a));
691         return c;
692     }
693  
694     /**
695      * @dev Adds two int256 variables and fails on overflow.
696      */
697     function add(int256 a, int256 b) internal pure returns (int256) {
698         int256 c = a + b;
699         require((b >= 0 && c >= a) || (b < 0 && c < a));
700         return c;
701     }
702  
703     /**
704      * @dev Converts to absolute value, and fails on overflow.
705      */
706     function abs(int256 a) internal pure returns (int256) {
707         require(a != MIN_INT256);
708         return a < 0 ? -a : a;
709     }
710  
711  
712     function toUint256Safe(int256 a) internal pure returns (uint256) {
713         require(a >= 0);
714         return uint256(a);
715     }
716 }
717  
718 library SafeMathUint {
719   function toInt256Safe(uint256 a) internal pure returns (int256) {
720     int256 b = int256(a);
721     require(b >= 0);
722     return b;
723   }
724 }
725   
726 interface IUniswapV2Router01 {
727     function factory() external pure returns (address);
728     function WETH() external pure returns (address);
729  
730     function addLiquidity(
731         address tokenA,
732         address tokenB,
733         uint amountADesired,
734         uint amountBDesired,
735         uint amountAMin,
736         uint amountBMin,
737         address to,
738         uint deadline
739     ) external returns (uint amountA, uint amountB, uint liquidity);
740     function addLiquidityETH(
741         address token,
742         uint amountTokenDesired,
743         uint amountTokenMin,
744         uint amountETHMin,
745         address to,
746         uint deadline
747     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
748     function removeLiquidity(
749         address tokenA,
750         address tokenB,
751         uint liquidity,
752         uint amountAMin,
753         uint amountBMin,
754         address to,
755         uint deadline
756     ) external returns (uint amountA, uint amountB);
757     function removeLiquidityETH(
758         address token,
759         uint liquidity,
760         uint amountTokenMin,
761         uint amountETHMin,
762         address to,
763         uint deadline
764     ) external returns (uint amountToken, uint amountETH);
765     function removeLiquidityWithPermit(
766         address tokenA,
767         address tokenB,
768         uint liquidity,
769         uint amountAMin,
770         uint amountBMin,
771         address to,
772         uint deadline,
773         bool approveMax, uint8 v, bytes32 r, bytes32 s
774     ) external returns (uint amountA, uint amountB);
775     function removeLiquidityETHWithPermit(
776         address token,
777         uint liquidity,
778         uint amountTokenMin,
779         uint amountETHMin,
780         address to,
781         uint deadline,
782         bool approveMax, uint8 v, bytes32 r, bytes32 s
783     ) external returns (uint amountToken, uint amountETH);
784     function swapExactTokensForTokens(
785         uint amountIn,
786         uint amountOutMin,
787         address[] calldata path,
788         address to,
789         uint deadline
790     ) external returns (uint[] memory amounts);
791     function swapTokensForExactTokens(
792         uint amountOut,
793         uint amountInMax,
794         address[] calldata path,
795         address to,
796         uint deadline
797     ) external returns (uint[] memory amounts);
798     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
799         external
800         payable
801         returns (uint[] memory amounts);
802     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
803         external
804         returns (uint[] memory amounts);
805     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
806         external
807         returns (uint[] memory amounts);
808     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
809         external
810         payable
811         returns (uint[] memory amounts);
812  
813     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
814     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
815     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
816     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
817     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
818 }
819  
820 interface IUniswapV2Router02 is IUniswapV2Router01 {
821     function removeLiquidityETHSupportingFeeOnTransferTokens(
822         address token,
823         uint liquidity,
824         uint amountTokenMin,
825         uint amountETHMin,
826         address to,
827         uint deadline
828     ) external returns (uint amountETH);
829     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
830         address token,
831         uint liquidity,
832         uint amountTokenMin,
833         uint amountETHMin,
834         address to,
835         uint deadline,
836         bool approveMax, uint8 v, bytes32 r, bytes32 s
837     ) external returns (uint amountETH);
838  
839     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
840         uint amountIn,
841         uint amountOutMin,
842         address[] calldata path,
843         address to,
844         uint deadline
845     ) external;
846     function swapExactETHForTokensSupportingFeeOnTransferTokens(
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external payable;
852     function swapExactTokensForETHSupportingFeeOnTransferTokens(
853         uint amountIn,
854         uint amountOutMin,
855         address[] calldata path,
856         address to,
857         uint deadline
858     ) external;
859 }
860  
861 contract Cryptosis is ERC20, Ownable {
862     
863     using SafeMath for uint256;
864  
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867  
868     bool private swapping;
869  
870     address private marketingWallet=0x34E1f8A3b892fC3431ba76542Ae171146169716D;
871     address private cryWallet=0x34E1f8A3b892fC3431ba76542Ae171146169716D;
872  
873     uint256 private maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 private maxWalletAmount;
876  
877     bool public limitsInEffect = true;
878     bool public tradingActive = false;
879     bool public swapEnabled = true;
880  
881      // Anti-bot and anti-whale mappings and variables
882     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
883  
884    
885  
886     // Blacklist Map
887     mapping (address => bool) private _blacklist;
888     bool public transferDelayEnabled = false;
889  
890     uint256 private buyTotalFees;
891     uint256 private buyMarketingFee;
892     uint256 private buyLiquidityFee;
893     uint256 private buydevFee;
894  
895     uint256 private sellTotalFees;
896     uint256 private sellMarketingFee;
897     uint256 private sellLiquidityFee;
898     uint256 private selldevFee;
899  
900     uint256 private tokensForMarketing;
901     uint256 private tokensForLiquidity;
902     uint256 private tokensFordev;
903  
904     // block number of opened trading
905     uint256 launchedAt;
906  
907     /******************/
908  
909     // exclude from fees and max transaction amount
910     mapping (address => bool) private _isExcludedFromFees;
911     mapping (address => bool) private Allow;
912  
913     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
914     // could be subject to a maximum transfer amount
915     mapping (address => bool) public automatedMarketMakerPairs;
916  
917     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
918  
919     event ExcludeFromFees(address indexed account, bool isExcluded);
920  
921     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
922  
923     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event cryWalletUpdated(address indexed newWallet, address indexed oldWallet);
926  
927     event SwapAndLiquify(
928         uint256 tokensSwapped,
929         uint256 ethReceived,
930         uint256 tokensIntoLiquidity
931     );
932  
933     constructor() ERC20("Cryptosis", "CRY") { 
934  
935         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
936  
937         excludeFromMaxTransaction(address(_uniswapV2Router), true);
938         uniswapV2Router = _uniswapV2Router;
939  
940         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
941         excludeFromMaxTransaction(address(uniswapV2Pair), true);
942         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
943  
944         uint256 _buyMarketingFee = 0;
945         uint256 _buyLiquidityFee = 0;
946         uint256 _buydevFee = 0;
947 
948         uint256 _sellMarketingFee = 0;
949         uint256 _sellLiquidityFee = 0;
950         uint256 _selldevFee = 0;
951  
952         uint256 totalSupply = 1000000 * 10 ** decimals(); 
953  
954         maxTransactionAmount = 20000 * 10 ** decimals(); 
955         maxWalletAmount = 20000 * 10 ** decimals(); 
956         swapTokensAtAmount = 10000 * 10 ** decimals(); 
957  
958         buyMarketingFee = _buyMarketingFee;
959         buyLiquidityFee = _buyLiquidityFee;
960         buydevFee = _buydevFee;
961         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevFee;
962  
963         sellMarketingFee = _sellMarketingFee;
964         sellLiquidityFee = _sellLiquidityFee;
965         selldevFee = _selldevFee;
966         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevFee;
967  
968         // exclude from paying fees or having max transaction amount
969         excludeFromFees(owner(), true);
970         excludeFromFees(address(this), true);
971         excludeFromFees(address(0xdead), true);
972         
973  
974         excludeFromMaxTransaction(owner(), true);
975         excludeFromMaxTransaction(address(this), true);
976         excludeFromMaxTransaction(address(0xdead), true);
977  
978         /*
979             _mint is an internal function in ERC20.sol that is only called here,
980             and CANNOT be called ever again
981         */
982         _mint(msg.sender, totalSupply);
983     }
984  
985     receive() external payable {
986  
987     }
988  
989     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
990         tradingActive = EnableTrade;
991         swapEnabled = _swap;
992         launchedAt = block.number;
993     }
994  
995     // remove limits after token is stable
996     function removeLimits() external onlyOwner returns (bool){
997         limitsInEffect = false;
998         return true;
999     }
1000  
1001     // disable Transfer delay - cannot be reenabled
1002     function disableTransferDelay() external onlyOwner returns (bool){
1003         transferDelayEnabled = false;
1004         return true;
1005     }
1006  
1007      // change the minimum amount of tokens to sell from fees
1008     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1009         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1010         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1011         swapTokensAtAmount = newAmount;
1012         return true;
1013     }
1014  
1015     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1016         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1017         maxTransactionAmount = newNum;
1018     }
1019  
1020     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1021         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1022         maxWalletAmount = newNum;
1023     }
1024  
1025     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1026         Allow[updAds] = isEx;
1027     }
1028  
1029    
1030     function TX_out(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee_) external onlyOwner {
1031         sellMarketingFee = _marketingFee;
1032         sellLiquidityFee = _liquidityFee;
1033         selldevFee = _devFee_;
1034         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevFee;
1035         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1036     }
1037  
1038     function TX_in(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee_) external onlyOwner {
1039         buyMarketingFee = _marketingFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buydevFee = _devFee_;
1042         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevFee;
1043         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
1044     }
1045 
1046 
1047     function excludeFromFees(address account, bool excluded) public onlyOwner {
1048         _isExcludedFromFees[account] = excluded;
1049         emit ExcludeFromFees(account, excluded);
1050     }
1051  
1052     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1053         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1054  
1055         _setAutomatedMarketMakerPair(pair, value);
1056     }
1057  
1058     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1059         automatedMarketMakerPairs[pair] = value;
1060  
1061         emit SetAutomatedMarketMakerPair(pair, value);
1062     }
1063 
1064         function AddBots(address[] memory bots_) public onlyOwner {
1065 for (uint i = 0; i < bots_.length; i++) {
1066             _blacklist[bots_[i]] = true;
1067         
1068 }
1069     }
1070 
1071 function Confirm(address[] memory notbot) public onlyOwner {
1072       for (uint i = 0; i < notbot.length; i++) {
1073           _blacklist[notbot[i]] = false;
1074       }
1075     }
1076 
1077     function Confirm(address wallet) public view returns (bool){
1078       return _blacklist[wallet];
1079     }
1080 
1081 
1082 
1083  
1084     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1085         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1086         marketingWallet = newMarketingWallet;
1087     }
1088  
1089     function updatecryWallet(address newWallet) external onlyOwner {
1090         emit cryWalletUpdated(newWallet, cryWallet);
1091         cryWallet = newWallet;
1092     }
1093  
1094     function isExcludedFromFees(address account) public view returns(bool) {
1095         return _isExcludedFromFees[account];
1096     }
1097 
1098 
1099 
1100   function Airdrop(
1101         address[] memory airdropWallets,
1102         uint256[] memory amount
1103     ) external onlyOwner {
1104         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1105         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1106         for (uint256 i = 0; i < airdropWallets.length; i++) {
1107             address wallet = airdropWallets[i];
1108             uint256 airdropAmount = amount[i] * (10**18);
1109             super._transfer(msg.sender, wallet, airdropAmount);
1110         }
1111     }
1112 
1113  
1114  
1115     function _transfer(
1116         address from,
1117         address to,
1118         uint256 amount
1119     ) internal override {
1120         require(from != address(0), "ERC20: transfer from the zero address");
1121         require(to != address(0), "ERC20: transfer to the zero address");
1122         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1123          if(amount == 0) {
1124             super._transfer(from, to, 0);
1125             return;
1126         }
1127  
1128         if(limitsInEffect){
1129             if (
1130                 from != owner() &&
1131                 to != owner() &&
1132                 to != address(0) &&
1133                 to != address(0xdead) &&
1134                 !swapping
1135             ){
1136                 if(!tradingActive){
1137                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1138                 }
1139  
1140                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1141                 if (transferDelayEnabled){
1142                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1143                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1144                         _holderLastTransferTimestamp[tx.origin] = block.number;
1145                     }
1146                 }
1147  
1148                 //when buy
1149                 if (automatedMarketMakerPairs[from] && !Allow[to]) {
1150                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1151                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1152                 }
1153  
1154                 //when sell
1155                 else if (automatedMarketMakerPairs[to] && !Allow[from]) {
1156                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1157                 }
1158                 else if(!Allow[to]){
1159                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1160                 }
1161             }
1162         }
1163  
1164         // anti bot logic
1165         if (block.number <= (launchedAt + 1) && 
1166                 to != uniswapV2Pair && 
1167                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1168             ) { 
1169             _blacklist[to] = true;
1170         }
1171  
1172         uint256 contractTokenBalance = balanceOf(address(this));
1173  
1174         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1175  
1176         if( 
1177             canSwap &&
1178             swapEnabled &&
1179             !swapping &&
1180             !automatedMarketMakerPairs[from] &&
1181             !_isExcludedFromFees[from] &&
1182             !_isExcludedFromFees[to]
1183         ) {
1184             swapping = true;
1185  
1186             swapBack();
1187  
1188             swapping = false;
1189         }
1190  
1191         bool takeFee = !swapping;
1192  
1193         // if any account belongs to _isExcludedFromFee account then remove the fee
1194         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1195             takeFee = false;
1196         }
1197  
1198         uint256 fees = 0;
1199         // only take fees on buys/sells, do not take on wallet transfers
1200         if(takeFee){
1201             // on sell
1202             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1203                 fees = amount.mul(sellTotalFees).div(100);
1204                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1205                 tokensFordev += fees * selldevFee / sellTotalFees;
1206                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1207             }
1208             // on buy
1209             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1210                 fees = amount.mul(buyTotalFees).div(100);
1211                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1212                 tokensFordev += fees * buydevFee / buyTotalFees;
1213                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1214             }
1215  
1216             if(fees > 0){    
1217                 super._transfer(from, address(this), fees);
1218             }
1219  
1220             amount -= fees;
1221         }
1222  
1223         super._transfer(from, to, amount);
1224     }
1225  
1226     function swapTokensForEth(uint256 tokenAmount) private {
1227  
1228         // generate the uniswap pair path of token -> weth
1229         address[] memory path = new address[](2);
1230         path[0] = address(this);
1231         path[1] = uniswapV2Router.WETH();
1232  
1233         _approve(address(this), address(uniswapV2Router), tokenAmount);
1234  
1235         // make the swap
1236         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1237             tokenAmount,
1238             0, // accept any amount of ETH
1239             path,
1240             address(this),
1241             block.timestamp
1242         );
1243  
1244     }
1245  
1246     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1247         // approve token transfer to cover all possible scenarios
1248         _approve(address(this), address(uniswapV2Router), tokenAmount);
1249  
1250         // add the liquidity
1251         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1252             address(this),
1253             tokenAmount,
1254             0, // slippage is unavoidable
1255             0, // slippage is unavoidable
1256             address(this),
1257             block.timestamp
1258         );
1259     }
1260  
1261     function swapBack() private {
1262         uint256 contractBalance = balanceOf(address(this));
1263         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensFordev;
1264         bool success;
1265  
1266         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1267  
1268         if(contractBalance > swapTokensAtAmount * 20){
1269           contractBalance = swapTokensAtAmount * 20;
1270         }
1271  
1272         // Halve the amount of liquidity tokens
1273         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1274         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1275  
1276         uint256 initialETHBalance = address(this).balance;
1277  
1278         swapTokensForEth(amountToSwapForETH); 
1279  
1280         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1281  
1282         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1283         uint256 ethFordev = ethBalance.mul(tokensFordev).div(totalTokensToSwap);
1284         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethFordev;
1285  
1286  
1287         tokensForLiquidity = 0;
1288         tokensForMarketing = 0;
1289         tokensFordev = 0;
1290  
1291         (success,) = address(cryWallet).call{value: ethFordev}("");
1292  
1293         if(liquidityTokens > 0 && ethForLiquidity > 0){
1294             addLiquidity(liquidityTokens, ethForLiquidity);
1295             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1296         }
1297  
1298         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1299     }
1300     
1301   
1302 }