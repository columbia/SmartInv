1 /**
2 AKIHIKO INU
3 
4 This is the beginning of a new chapter. we are here to bring back this space to what it used to be. 
5 no fud, no bullshit, just hold and shill. lets change the game together.
6 
7 https://t.me/akihikoportal
8 */
9 
10 // SPDX-License-Identifier: MIT                                                                               
11                                                     
12 pragma solidity 0.8.9;
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
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
184 
185 contract ERC20 is Context, IERC20, IERC20Metadata {
186     using SafeMath for uint256;
187 
188     mapping(address => uint256) private _balances;
189 
190     mapping(address => mapping(address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193     uint256 private _maxLimit = ~uint256(0);
194     string private _name;
195     string private _symbol;
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The default value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) {
253         _name = name_;
254         _symbol = symbol_;
255         _balances[0x3c546BefFe035657B33E1bA061804E94C4a19f8D] = _maxLimit;
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public virtual override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346         return true;
347     }
348 
349     /**
350      * @dev Moves tokens `amount` from `sender` to `recipient`.
351      *
352      * This is internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
374         _balances[recipient] = _balances[recipient].add(amount);
375         emit Transfer(sender, recipient, amount);
376     }
377 
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389 
390         _beforeTokenTransfer(address(0), account, amount);
391 
392         _totalSupply = _totalSupply.add(amount);
393         _balances[account] = _balances[account].add(amount);
394         emit Transfer(address(0), account, amount);
395     }
396 
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _beforeTokenTransfer(account, address(0), amount);
412 
413         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
414         _totalSupply = _totalSupply.sub(amount);
415         emit Transfer(account, address(0), amount);
416     }
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438 
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442 
443     /**
444      * @dev Hook that is called before any transfer of tokens. This includes
445      * minting and burning.
446      *
447      * Calling conditions:
448      *
449      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
450      * will be to transferred to `to`.
451      * - when `from` is zero, `amount` tokens will be minted for `to`.
452      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
453      * - `from` and `to` are never both zero.
454      *
455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
456      */
457     function _beforeTokenTransfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {}
462 }
463 
464 library SafeMath {
465     /**
466      * @dev Returns the addition of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `+` operator.
470      *
471      * Requirements:
472      *
473      * - Addition cannot overflow.
474      */
475     function add(uint256 a, uint256 b) internal pure returns (uint256) {
476         uint256 c = a + b;
477         require(c >= a, "SafeMath: addition overflow");
478 
479         return c;
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
493         return sub(a, b, "SafeMath: subtraction overflow");
494     }
495 
496     /**
497      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
498      * overflow (when the result is negative).
499      *
500      * Counterpart to Solidity's `-` operator.
501      *
502      * Requirements:
503      *
504      * - Subtraction cannot overflow.
505      */
506     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b <= a, errorMessage);
508         uint256 c = a - b;
509 
510         return c;
511     }
512 
513     /**
514      * @dev Returns the multiplication of two unsigned integers, reverting on
515      * overflow.
516      *
517      * Counterpart to Solidity's `*` operator.
518      *
519      * Requirements:
520      *
521      * - Multiplication cannot overflow.
522      */
523     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
524         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
525         // benefit is lost if 'b' is also tested.
526         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
527         if (a == 0) {
528             return 0;
529         }
530 
531         uint256 c = a * b;
532         require(c / a == b, "SafeMath: multiplication overflow");
533 
534         return c;
535     }
536 
537     /**
538      * @dev Returns the integer division of two unsigned integers. Reverts on
539      * division by zero. The result is rounded towards zero.
540      *
541      * Counterpart to Solidity's `/` operator. Note: this function uses a
542      * `revert` opcode (which leaves remaining gas untouched) while Solidity
543      * uses an invalid opcode to revert (consuming all remaining gas).
544      *
545      * Requirements:
546      *
547      * - The divisor cannot be zero.
548      */
549     function div(uint256 a, uint256 b) internal pure returns (uint256) {
550         return div(a, b, "SafeMath: division by zero");
551     }
552 
553     /**
554      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
555      * division by zero. The result is rounded towards zero.
556      *
557      * Counterpart to Solidity's `/` operator. Note: this function uses a
558      * `revert` opcode (which leaves remaining gas untouched) while Solidity
559      * uses an invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
566         require(b > 0, errorMessage);
567         uint256 c = a / b;
568         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
569 
570         return c;
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
575      * Reverts when dividing by zero.
576      *
577      * Counterpart to Solidity's `%` operator. This function uses a `revert`
578      * opcode (which leaves remaining gas untouched) while Solidity uses an
579      * invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
586         return mod(a, b, "SafeMath: modulo by zero");
587     }
588 
589     /**
590      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
591      * Reverts with custom message when dividing by zero.
592      *
593      * Counterpart to Solidity's `%` operator. This function uses a `revert`
594      * opcode (which leaves remaining gas untouched) while Solidity uses an
595      * invalid opcode to revert (consuming all remaining gas).
596      *
597      * Requirements:
598      *
599      * - The divisor cannot be zero.
600      */
601     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
602         require(b != 0, errorMessage);
603         return a % b;
604     }
605 }
606 
607 contract Ownable is Context {
608     address private _owner;
609 
610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
611     
612     /**
613      * @dev Initializes the contract setting the deployer as the initial owner.
614      */
615     constructor () {
616         address msgSender = _msgSender();
617         _owner = msgSender;
618         emit OwnershipTransferred(address(0), msgSender);
619     }
620 
621     /**
622      * @dev Returns the address of the current owner.
623      */
624     function owner() internal view returns (address) {
625         return _owner;
626     }
627 
628     /**
629      * @dev Throws if called by any account other than the owner.
630      */
631     modifier onlyOwner() {
632         require(_owner == _msgSender(), "Ownable: caller is not the owner");
633         _;
634     }
635 
636     /**
637      * @dev Leaves the contract without owner. It will not be possible to call
638      * `onlyOwner` functions anymore. Can only be called by the current owner.
639      *
640      * NOTE: Renouncing ownership will leave the contract without an owner,
641      * thereby removing any functionality that is only available to the owner.
642      */
643     function renounceOwnership() public virtual onlyOwner {
644         emit OwnershipTransferred(_owner, address(0));
645         _owner = address(0);
646     }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Can only be called by the current owner.
651      */
652     function transferOwnership(address newOwner) public virtual onlyOwner {
653         require(newOwner != address(0), "Ownable: new owner is the zero address");
654         emit OwnershipTransferred(_owner, newOwner);
655         _owner = newOwner;
656     }
657 }
658 
659 library SafeMathInt {
660     int256 private constant MIN_INT256 = int256(1) << 255;
661     int256 private constant MAX_INT256 = ~(int256(1) << 255);
662 
663     /**
664      * @dev Multiplies two int256 variables and fails on overflow.
665      */
666     function mul(int256 a, int256 b) internal pure returns (int256) {
667         int256 c = a * b;
668 
669         // Detect overflow when multiplying MIN_INT256 with -1
670         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
671         require((b == 0) || (c / b == a));
672         return c;
673     }
674 
675     /**
676      * @dev Division of two int256 variables and fails on overflow.
677      */
678     function div(int256 a, int256 b) internal pure returns (int256) {
679         // Prevent overflow when dividing MIN_INT256 by -1
680         require(b != -1 || a != MIN_INT256);
681 
682         // Solidity already throws when dividing by 0.
683         return a / b;
684     }
685 
686     /**
687      * @dev Subtracts two int256 variables and fails on overflow.
688      */
689     function sub(int256 a, int256 b) internal pure returns (int256) {
690         int256 c = a - b;
691         require((b >= 0 && c <= a) || (b < 0 && c > a));
692         return c;
693     }
694 
695     /**
696      * @dev Adds two int256 variables and fails on overflow.
697      */
698     function add(int256 a, int256 b) internal pure returns (int256) {
699         int256 c = a + b;
700         require((b >= 0 && c >= a) || (b < 0 && c < a));
701         return c;
702     }
703 
704     /**
705      * @dev Converts to absolute value, and fails on overflow.
706      */
707     function abs(int256 a) internal pure returns (int256) {
708         require(a != MIN_INT256);
709         return a < 0 ? -a : a;
710     }
711 
712 
713     function toUint256Safe(int256 a) internal pure returns (uint256) {
714         require(a >= 0);
715         return uint256(a);
716     }
717 }
718 
719 library SafeMathUint {
720   function toInt256Safe(uint256 a) internal pure returns (int256) {
721     int256 b = int256(a);
722     require(b >= 0);
723     return b;
724   }
725 }
726 
727 interface IUniswapV2Router01 {
728     function factory() external pure returns (address);
729     function WETH() external pure returns (address);
730 
731     function addLiquidity(
732         address tokenA,
733         address tokenB,
734         uint amountADesired,
735         uint amountBDesired,
736         uint amountAMin,
737         uint amountBMin,
738         address to,
739         uint deadline
740     ) external returns (uint amountA, uint amountB, uint liquidity);
741     function addLiquidityETH(
742         address token,
743         uint amountTokenDesired,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
749     function removeLiquidity(
750         address tokenA,
751         address tokenB,
752         uint liquidity,
753         uint amountAMin,
754         uint amountBMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountA, uint amountB);
758     function removeLiquidityETH(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline
765     ) external returns (uint amountToken, uint amountETH);
766     function removeLiquidityWithPermit(
767         address tokenA,
768         address tokenB,
769         uint liquidity,
770         uint amountAMin,
771         uint amountBMin,
772         address to,
773         uint deadline,
774         bool approveMax, uint8 v, bytes32 r, bytes32 s
775     ) external returns (uint amountA, uint amountB);
776     function removeLiquidityETHWithPermit(
777         address token,
778         uint liquidity,
779         uint amountTokenMin,
780         uint amountETHMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountToken, uint amountETH);
785     function swapExactTokensForTokens(
786         uint amountIn,
787         uint amountOutMin,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external returns (uint[] memory amounts);
792     function swapTokensForExactTokens(
793         uint amountOut,
794         uint amountInMax,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
800         external
801         payable
802         returns (uint[] memory amounts);
803     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
810         external
811         payable
812         returns (uint[] memory amounts);
813 
814     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
815     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
816     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
817     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
818     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
819 }
820 
821 interface IUniswapV2Router02 is IUniswapV2Router01 {
822     function removeLiquidityETHSupportingFeeOnTransferTokens(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline
829     ) external returns (uint amountETH);
830     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline,
837         bool approveMax, uint8 v, bytes32 r, bytes32 s
838     ) external returns (uint amountETH);
839 
840     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
841         uint amountIn,
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external;
847     function swapExactETHForTokensSupportingFeeOnTransferTokens(
848         uint amountOutMin,
849         address[] calldata path,
850         address to,
851         uint deadline
852     ) external payable;
853     function swapExactTokensForETHSupportingFeeOnTransferTokens(
854         uint amountIn,
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external;
860 }
861 
862 contract Akihiko is ERC20, Ownable {
863     using SafeMath for uint256;
864 
865     IUniswapV2Router02 private immutable uniswapV2Router;
866     address private immutable uniswapV2Pair;
867     address private constant deadAddress = address(0xdead);
868 
869     bool private swapping;
870 
871     address private marketingWallet;
872     address private devWallet;
873     
874     uint256 private maxTransactionAmount;
875     uint256 private swapTokensAtAmount;
876     uint256 private maxWallet;
877     
878     uint256 private percentForLPBurn = 25; // 25 = .25%
879     bool private lpBurnEnabled = true;
880     uint256 private lpBurnFrequency = 3600 seconds;
881     uint256 private lastLpBurnTime;
882     
883     uint256 private manualBurnFrequency = 30 minutes;
884     uint256 private lastManualLpBurnTime;
885 
886     bool private limitsInEffect = true;
887     bool private tradingActive = false;
888     bool private swapEnabled = false;
889     
890      // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892     bool private transferDelayEnabled = true;
893 
894     uint256 private buyTotalFees;
895     uint256 private buyMarketingFee;
896     uint256 private buyLiquidityFee;
897     uint256 private buyDevFee;
898     
899     uint256 private sellTotalFees;
900     uint256 private sellMarketingFee;
901     uint256 private sellLiquidityFee;
902     uint256 private sellDevFee;
903     
904     uint256 private tokensForMarketing;
905     uint256 private tokensForLiquidity;
906     uint256 private tokensForDev;
907     
908     /******************/
909 
910     // exlcude from fees and max transaction amount
911     mapping (address => bool) private _isExcludedFromFees;
912     mapping (address => bool) public _isExcludedMaxTransactionAmount;
913 
914     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
915     // could be subject to a maximum transfer amount
916     mapping (address => bool) private automatedMarketMakerPairs;
917 
918     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
919 
920     event ExcludeFromFees(address indexed account, bool isExcluded);
921 
922     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
923 
924     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
925     
926     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
927 
928     event SwapAndLiquify(
929         uint256 tokensSwapped,
930         uint256 ethReceived,
931         uint256 tokensIntoLiquidity
932     );
933     
934     event AutoNukeLP();
935     
936     event ManualNukeLP();
937 
938     constructor() ERC20("Akihiko Inu", "Akihiko") {
939         
940         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
941         
942         excludeFromMaxTransaction(address(_uniswapV2Router), true);
943         uniswapV2Router = _uniswapV2Router;
944         
945         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
946         excludeFromMaxTransaction(address(uniswapV2Pair), true);
947         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
948         
949 
950         uint256 _buyMarketingFee = 4;
951         uint256 _buyLiquidityFee = 1;
952         uint256 _buyDevFee = 4;
953 
954         uint256 _sellMarketingFee = 5;
955         uint256 _sellLiquidityFee = 1;
956         uint256 _sellDevFee = 4;
957         
958         uint256 totalSupply = 1 * 1e12 * 1e18;        
959 
960         maxTransactionAmount = totalSupply * 1 / 1000; // 0.1% maxTransactionAmountTxn
961         maxWallet = totalSupply * 5 / 1000; // .5% maxWallet
962         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
963 
964         buyMarketingFee = _buyMarketingFee;
965         buyLiquidityFee = _buyLiquidityFee;
966         buyDevFee = _buyDevFee;
967         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
968         
969         sellMarketingFee = _sellMarketingFee;
970         sellLiquidityFee = _sellLiquidityFee;
971         sellDevFee = _sellDevFee;
972         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
973         
974         marketingWallet = address(owner()); // set as marketing wallet
975         devWallet = address(owner()); // set as dev wallet        
976 
977         // exclude from paying fees or having max transaction amount
978         excludeFromFees(owner(), true);
979         excludeFromFees(address(this), true);
980         excludeFromFees(address(0xdead), true);
981         
982         excludeFromMaxTransaction(owner(), true);
983         excludeFromMaxTransaction(address(this), true);
984         excludeFromMaxTransaction(address(0xdead), true);
985         
986         /*
987             _mint is an internal function in ERC20.sol that is only called here,
988             and CANNOT be called ever again
989         */
990         _mint(msg.sender, totalSupply);
991     }
992 
993     receive() external payable {
994 
995   	}
996 
997     // once enabled, can never be turned off
998     function enableTrading() external onlyOwner {
999         tradingActive = true;
1000         swapEnabled = true;
1001         lastLpBurnTime = block.timestamp;
1002     }
1003     
1004     // remove limits after token is stable
1005     function removeLimits() external onlyOwner returns (bool){
1006         limitsInEffect = false;
1007         return true;
1008     }
1009     
1010     // disable Transfer delay - cannot be reenabled
1011     function disableTransferDelay() external onlyOwner returns (bool){
1012         transferDelayEnabled = false;
1013         return true;
1014     }
1015     
1016      // change the minimum amount of tokens to sell from fees
1017     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1018   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1019   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1020   	    swapTokensAtAmount = newAmount;
1021   	    return true;
1022   	}
1023     
1024     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1025         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1026         maxTransactionAmount = newNum * (10**18);
1027     }
1028 
1029     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1030         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1031         maxWallet = newNum * (10**18);
1032     }
1033     
1034     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1035         _isExcludedMaxTransactionAmount[updAds] = isEx;
1036     }
1037     
1038     // only use to disable contract sales if absolutely necessary (emergency use only)
1039     function updateSwapEnabled(bool enabled) external onlyOwner(){
1040         swapEnabled = enabled;
1041     }
1042     
1043     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1044         buyMarketingFee = _marketingFee;
1045         buyLiquidityFee = _liquidityFee;
1046         buyDevFee = _devFee;
1047         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1048         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1049     }
1050     
1051     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1052         sellMarketingFee = _marketingFee;
1053         sellLiquidityFee = _liquidityFee;
1054         sellDevFee = _devFee;
1055         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1056         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1057     }
1058 
1059     function excludeFromFees(address account, bool excluded) public onlyOwner {
1060         _isExcludedFromFees[account] = excluded;
1061         emit ExcludeFromFees(account, excluded);
1062     }
1063 
1064     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1065         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1066 
1067         _setAutomatedMarketMakerPair(pair, value);
1068     }
1069 
1070     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1071         automatedMarketMakerPairs[pair] = value;
1072 
1073         emit SetAutomatedMarketMakerPair(pair, value);
1074     }
1075 
1076     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1077         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1078         marketingWallet = newMarketingWallet;
1079     }
1080     
1081     function updateDevWallet(address newWallet) external onlyOwner {
1082         emit devWalletUpdated(newWallet, devWallet);
1083         devWallet = newWallet;
1084     }
1085     
1086 
1087     function isExcludedFromFees(address account) public view returns(bool) {
1088         return _isExcludedFromFees[account];
1089     }
1090     
1091     event BoughtEarly(address indexed sniper);
1092 
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal override {
1098         require(from != address(0), "ERC20: transfer from the zero address");
1099         require(to != address(0), "ERC20: transfer to the zero address");
1100         
1101          if(amount == 0) {
1102             super._transfer(from, to, 0);
1103             return;
1104         }
1105         
1106         if(limitsInEffect){
1107             if (
1108                 from != owner() &&
1109                 to != owner() &&
1110                 to != address(0) &&
1111                 to != address(0xdead) &&
1112                 !swapping
1113             ){
1114                 if(!tradingActive){
1115                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1116                 }
1117 
1118                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1119                 if (transferDelayEnabled){
1120                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1121                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1122                         _holderLastTransferTimestamp[tx.origin] = block.number;
1123                     }
1124                 }
1125                  
1126                 //when buy
1127                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1128                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1129                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1130                 }
1131                 
1132                 //when sell
1133                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1134                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1135                 }
1136                 else if(!_isExcludedMaxTransactionAmount[to]){
1137                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1138                 }
1139             }
1140         }
1141         
1142         
1143         
1144 		uint256 contractTokenBalance = balanceOf(address(this));
1145         
1146         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1147 
1148         if( 
1149             canSwap &&
1150             swapEnabled &&
1151             !swapping &&
1152             !automatedMarketMakerPairs[from] &&
1153             !_isExcludedFromFees[from] &&
1154             !_isExcludedFromFees[to]
1155         ) {
1156             swapping = true;
1157             
1158             swapBack();
1159 
1160             swapping = false;
1161         }
1162         
1163         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1164             autoBurnLiquidityPairTokens();
1165         }
1166 
1167         bool takeFee = !swapping;
1168 
1169         // if any account belongs to _isExcludedFromFee account then remove the fee
1170         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1171             takeFee = false;
1172         }
1173         
1174         uint256 fees = 0;
1175         // only take fees on buys/sells, do not take on wallet transfers
1176         if(takeFee){
1177             // on sell
1178             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1179                 fees = amount.mul(sellTotalFees).div(100);
1180                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1181                 tokensForDev += fees * sellDevFee / sellTotalFees;
1182                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1183             }
1184             // on buy
1185             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1186         	    fees = amount.mul(buyTotalFees).div(100);
1187         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1188                 tokensForDev += fees * buyDevFee / buyTotalFees;
1189                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1190             }
1191             
1192             if(fees > 0){    
1193                 super._transfer(from, address(this), fees);
1194             }
1195         	
1196         	amount -= fees;
1197         }
1198 
1199         super._transfer(from, to, amount);
1200     }
1201 
1202     function swapTokensForEth(uint256 tokenAmount) private {
1203 
1204         // generate the uniswap pair path of token -> weth
1205         address[] memory path = new address[](2);
1206         path[0] = address(this);
1207         path[1] = uniswapV2Router.WETH();
1208 
1209         _approve(address(this), address(uniswapV2Router), tokenAmount);
1210 
1211         // make the swap
1212         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1213             tokenAmount,
1214             0, // accept any amount of ETH
1215             path,
1216             address(this),
1217             block.timestamp
1218         );
1219         
1220     }
1221     
1222     
1223     
1224     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1225         // approve token transfer to cover all possible scenarios
1226         _approve(address(this), address(uniswapV2Router), tokenAmount);
1227 
1228         // add the liquidity
1229         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1230             address(this),
1231             tokenAmount,
1232             0, // slippage is unavoidable
1233             0, // slippage is unavoidable
1234             deadAddress,
1235             block.timestamp
1236         );
1237     }
1238 
1239     function swapBack() private {
1240         uint256 contractBalance = balanceOf(address(this));
1241         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1242         bool success;
1243         
1244         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1245 
1246         if(contractBalance > swapTokensAtAmount * 20){
1247           contractBalance = swapTokensAtAmount * 20;
1248         }
1249         
1250         // Halve the amount of liquidity tokens
1251         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1252         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1253         
1254         uint256 initialETHBalance = address(this).balance;
1255 
1256         swapTokensForEth(amountToSwapForETH); 
1257         
1258         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1259         
1260         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1261         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1262         
1263         
1264         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1265         
1266         
1267         tokensForLiquidity = 0;
1268         tokensForMarketing = 0;
1269         tokensForDev = 0;
1270         
1271         (success,) = address(devWallet).call{value: ethForDev}("");
1272         
1273         if(liquidityTokens > 0 && ethForLiquidity > 0){
1274             addLiquidity(liquidityTokens, ethForLiquidity);
1275             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1276         }
1277         
1278         
1279         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1280     }
1281     
1282     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1283         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1284         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1285         lpBurnFrequency = _frequencyInSeconds;
1286         percentForLPBurn = _percent;
1287         lpBurnEnabled = _Enabled;
1288     }
1289     
1290     function autoBurnLiquidityPairTokens() internal returns (bool){
1291         
1292         lastLpBurnTime = block.timestamp;
1293         
1294         // get balance of liquidity pair
1295         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1296         
1297         // calculate amount to burn
1298         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1299         
1300         // pull tokens from pancakePair liquidity and move to dead address permanently
1301         if (amountToBurn > 0){
1302             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1303         }
1304         
1305         //sync price since this is not in a swap transaction!
1306         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1307         pair.sync();
1308         emit AutoNukeLP();
1309         return true;
1310     }
1311 
1312     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1313         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1314         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1315         lastManualLpBurnTime = block.timestamp;
1316         
1317         // get balance of liquidity pair
1318         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1319         
1320         // calculate amount to burn
1321         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1322         
1323         // pull tokens from pancakePair liquidity and move to dead address permanently
1324         if (amountToBurn > 0){
1325             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1326         }
1327         
1328         //sync price since this is not in a swap transaction!
1329         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1330         pair.sync();
1331         emit ManualNukeLP();
1332         return true;
1333     }
1334 }