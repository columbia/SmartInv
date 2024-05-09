1 /*
2 Hayate INU
3 $HINU 
4 come join us on tg: https://t.me/HINU_ERC
5 https://hayateinu.io
6 */
7 // SPDX-License-Identifier: MIT                                                                               
8                                                     
9 pragma solidity 0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
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
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75 
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78 
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82 
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88 
89 interface IERC20 {
90     /**
91      * @dev Returns the amount of tokens in existence.
92      */
93     function totalSupply() external view returns (uint256);
94 
95     /**
96      * @dev Returns the amount of tokens owned by `account`.
97      */
98     function balanceOf(address account) external view returns (uint256);
99 
100     /**
101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Returns the remaining number of tokens that `spender` will be
111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117 
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 interface IERC20Metadata is IERC20 {
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() external view returns (string memory);
169 
170     /**
171      * @dev Returns the symbol of the token.
172      */
173     function symbol() external view returns (string memory);
174 
175     /**
176      * @dev Returns the decimals places of the token.
177      */
178     function decimals() external view returns (uint8);
179 }
180 
181 
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     using SafeMath for uint256;
184 
185     mapping(address => uint256) private _balances;
186 
187     mapping(address => mapping(address => uint256)) private _allowances;
188 
189     uint256 private _totalSupply;
190 
191     string private _name;
192     string private _symbol;
193 
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 18;
238     }
239 
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
342         return true;
343     }
344 
345     /**
346      * @dev Moves tokens `amount` from `sender` to `recipient`.
347      *
348      * This is internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _beforeTokenTransfer(sender, recipient, amount);
368 
369         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
370         _balances[recipient] = _balances[recipient].add(amount);
371         emit Transfer(sender, recipient, amount);
372     }
373 
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385 
386         _beforeTokenTransfer(address(0), account, amount);
387 
388         _totalSupply = _totalSupply.add(amount);
389         _balances[account] = _balances[account].add(amount);
390         emit Transfer(address(0), account, amount);
391     }
392 
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406 
407         _beforeTokenTransfer(account, address(0), amount);
408 
409         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
410         _totalSupply = _totalSupply.sub(amount);
411         emit Transfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be to transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 }
459 
460 library SafeMath {
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return sub(a, b, "SafeMath: subtraction overflow");
490     }
491 
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
494      * overflow (when the result is negative).
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         uint256 c = a - b;
505 
506         return c;
507     }
508 
509     /**
510      * @dev Returns the multiplication of two unsigned integers, reverting on
511      * overflow.
512      *
513      * Counterpart to Solidity's `*` operator.
514      *
515      * Requirements:
516      *
517      * - Multiplication cannot overflow.
518      */
519     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
520         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
521         // benefit is lost if 'b' is also tested.
522         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
523         if (a == 0) {
524             return 0;
525         }
526 
527         uint256 c = a * b;
528         require(c / a == b, "SafeMath: multiplication overflow");
529 
530         return c;
531     }
532 
533     /**
534      * @dev Returns the integer division of two unsigned integers. Reverts on
535      * division by zero. The result is rounded towards zero.
536      *
537      * Counterpart to Solidity's `/` operator. Note: this function uses a
538      * `revert` opcode (which leaves remaining gas untouched) while Solidity
539      * uses an invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function div(uint256 a, uint256 b) internal pure returns (uint256) {
546         return div(a, b, "SafeMath: division by zero");
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         uint256 c = a / b;
564         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
565 
566         return c;
567     }
568 
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * Reverts when dividing by zero.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
582         return mod(a, b, "SafeMath: modulo by zero");
583     }
584 
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts with custom message when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b != 0, errorMessage);
599         return a % b;
600     }
601 }
602 
603 contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607     
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor () {
612         address msgSender = _msgSender();
613         _owner = msgSender;
614         emit OwnershipTransferred(address(0), msgSender);
615     }
616 
617     /**
618      * @dev Returns the address of the current owner.
619      */
620     function owner() public view returns (address) {
621         return _owner;
622     }
623 
624     /**
625      * @dev Throws if called by any account other than the owner.
626      */
627     modifier onlyOwner() {
628         require(_owner == _msgSender(), "Ownable: caller is not the owner");
629         _;
630     }
631 
632     /**
633      * @dev Leaves the contract without owner. It will not be possible to call
634      * `onlyOwner` functions anymore. Can only be called by the current owner.
635      *
636      * NOTE: Renouncing ownership will leave the contract without an owner,
637      * thereby removing any functionality that is only available to the owner.
638      */
639     function renounceOwnership() public virtual onlyOwner {
640         emit OwnershipTransferred(_owner, address(0));
641         _owner = address(0);
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      * Can only be called by the current owner.
647      */
648     function transferOwnership(address newOwner) public virtual onlyOwner {
649         require(newOwner != address(0), "Ownable: new owner is the zero address");
650         emit OwnershipTransferred(_owner, newOwner);
651         _owner = newOwner;
652     }
653 }
654 
655 
656 
657 library SafeMathInt {
658     int256 private constant MIN_INT256 = int256(1) << 255;
659     int256 private constant MAX_INT256 = ~(int256(1) << 255);
660 
661     /**
662      * @dev Multiplies two int256 variables and fails on overflow.
663      */
664     function mul(int256 a, int256 b) internal pure returns (int256) {
665         int256 c = a * b;
666 
667         // Detect overflow when multiplying MIN_INT256 with -1
668         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
669         require((b == 0) || (c / b == a));
670         return c;
671     }
672 
673     /**
674      * @dev Division of two int256 variables and fails on overflow.
675      */
676     function div(int256 a, int256 b) internal pure returns (int256) {
677         // Prevent overflow when dividing MIN_INT256 by -1
678         require(b != -1 || a != MIN_INT256);
679 
680         // Solidity already throws when dividing by 0.
681         return a / b;
682     }
683 
684     /**
685      * @dev Subtracts two int256 variables and fails on overflow.
686      */
687     function sub(int256 a, int256 b) internal pure returns (int256) {
688         int256 c = a - b;
689         require((b >= 0 && c <= a) || (b < 0 && c > a));
690         return c;
691     }
692 
693     /**
694      * @dev Adds two int256 variables and fails on overflow.
695      */
696     function add(int256 a, int256 b) internal pure returns (int256) {
697         int256 c = a + b;
698         require((b >= 0 && c >= a) || (b < 0 && c < a));
699         return c;
700     }
701 
702     /**
703      * @dev Converts to absolute value, and fails on overflow.
704      */
705     function abs(int256 a) internal pure returns (int256) {
706         require(a != MIN_INT256);
707         return a < 0 ? -a : a;
708     }
709 
710 
711     function toUint256Safe(int256 a) internal pure returns (uint256) {
712         require(a >= 0);
713         return uint256(a);
714     }
715 }
716 
717 library SafeMathUint {
718   function toInt256Safe(uint256 a) internal pure returns (int256) {
719     int256 b = int256(a);
720     require(b >= 0);
721     return b;
722   }
723 }
724 
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
861 contract HayateINU is ERC20, Ownable {
862     using SafeMath for uint256;
863 
864     IUniswapV2Router02 public immutable uniswapV2Router;
865     address public immutable uniswapV2Pair;
866     address public constant deadAddress = address(0xdead);
867 
868     bool private swapping;
869 
870     address public marketingWallet;
871     address public devWallet;
872     
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876     
877     uint256 public percentForLPBurn = 25; // 25 = .25%
878     bool public lpBurnEnabled = true;
879     uint256 public lpBurnFrequency = 3600 seconds;
880     uint256 public lastLpBurnTime;
881     
882     uint256 public manualBurnFrequency = 30 minutes;
883     uint256 public lastManualLpBurnTime;
884 
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = false;
888     
889      // Anti-bot and anti-whale mappings and variables
890     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
891     bool public transferDelayEnabled = true;
892 
893     uint256 public buyTotalFees;
894     uint256 public buyMarketingFee;
895     uint256 public buyLiquidityFee;
896     uint256 public buyDevFee;
897     
898     uint256 public sellTotalFees;
899     uint256 public sellMarketingFee;
900     uint256 public sellLiquidityFee;
901     uint256 public sellDevFee;
902     
903     uint256 public tokensForMarketing;
904     uint256 public tokensForLiquidity;
905     uint256 public tokensForDev;
906     
907     /******************/
908 
909     // exlcude from fees and max transaction amount
910     mapping (address => bool) private _isExcludedFromFees;
911     mapping (address => bool) public _isExcludedMaxTransactionAmount;
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
925     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
926 
927     event SwapAndLiquify(
928         uint256 tokensSwapped,
929         uint256 ethReceived,
930         uint256 tokensIntoLiquidity
931     );
932     
933     event AutoNukeLP();
934     
935     event ManualNukeLP();
936 
937     constructor() ERC20("Hayate INU", "HINU") {
938         
939         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
940         
941         excludeFromMaxTransaction(address(_uniswapV2Router), true);
942         uniswapV2Router = _uniswapV2Router;
943         
944         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
945         excludeFromMaxTransaction(address(uniswapV2Pair), true);
946         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
947         
948         uint256 _buyMarketingFee = 4;
949         uint256 _buyLiquidityFee = 10;
950         uint256 _buyDevFee = 1;
951 
952         uint256 _sellMarketingFee = 5;
953         uint256 _sellLiquidityFee = 14;
954         uint256 _sellDevFee = 1;
955         
956         uint256 totalSupply = 1 * 1e12 * 1e18;
957         
958         maxTransactionAmount = totalSupply * 30 / 1000; // 3% maxTransactionAmountTxn
959         maxWallet = totalSupply * 5 / 1000; // .5% maxWallet
960         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
961 
962         buyMarketingFee = _buyMarketingFee;
963         buyLiquidityFee = _buyLiquidityFee;
964         buyDevFee = _buyDevFee;
965         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
966         
967         sellMarketingFee = _sellMarketingFee;
968         sellLiquidityFee = _sellLiquidityFee;
969         sellDevFee = _sellDevFee;
970         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
971         
972         marketingWallet = address(owner()); // set as marketing wallet
973         devWallet = address(owner()); // set as dev wallet
974 
975         // exclude from paying fees or having max transaction amount
976         excludeFromFees(owner(), true);
977         excludeFromFees(address(this), true);
978         excludeFromFees(address(0xdead), true);
979         
980         excludeFromMaxTransaction(owner(), true);
981         excludeFromMaxTransaction(address(this), true);
982         excludeFromMaxTransaction(address(0xdead), true);
983         
984         /*
985             _mint is an internal function in ERC20.sol that is only called here,
986             and CANNOT be called ever again
987         */
988         _mint(msg.sender, totalSupply);
989     }
990 
991     receive() external payable {
992 
993   	}
994 
995     // once enabled, can never be turned off
996     function enableTrading() external onlyOwner {
997         tradingActive = true;
998         swapEnabled = true;
999         lastLpBurnTime = block.timestamp;
1000     }
1001     
1002     // remove limits after token is stable
1003     function removeLimits() external onlyOwner returns (bool){
1004         limitsInEffect = false;
1005         return true;
1006     }
1007     
1008     // disable Transfer delay - cannot be reenabled
1009     function disableTransferDelay() external onlyOwner returns (bool){
1010         transferDelayEnabled = false;
1011         return true;
1012     }
1013     
1014      // change the minimum amount of tokens to sell from fees
1015     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1016   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1017   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1018   	    swapTokensAtAmount = newAmount;
1019   	    return true;
1020   	}
1021     
1022     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1023         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1024         maxTransactionAmount = newNum * (10**18);
1025     }
1026 
1027     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1028         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1029         maxWallet = newNum * (10**18);
1030     }
1031     
1032     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1033         _isExcludedMaxTransactionAmount[updAds] = isEx;
1034     }
1035     
1036     // only use to disable contract sales if absolutely necessary (emergency use only)
1037     function updateSwapEnabled(bool enabled) external onlyOwner(){
1038         swapEnabled = enabled;
1039     }
1040     
1041     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1042         buyMarketingFee = _marketingFee;
1043         buyLiquidityFee = _liquidityFee;
1044         buyDevFee = _devFee;
1045         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1046         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1047     }
1048     
1049     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1050         sellMarketingFee = _marketingFee;
1051         sellLiquidityFee = _liquidityFee;
1052         sellDevFee = _devFee;
1053         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1054         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1055     }
1056 
1057     function excludeFromFees(address account, bool excluded) public onlyOwner {
1058         _isExcludedFromFees[account] = excluded;
1059         emit ExcludeFromFees(account, excluded);
1060     }
1061 
1062     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1063         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1064 
1065         _setAutomatedMarketMakerPair(pair, value);
1066     }
1067 
1068     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1069         automatedMarketMakerPairs[pair] = value;
1070 
1071         emit SetAutomatedMarketMakerPair(pair, value);
1072     }
1073 
1074     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1075         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1076         marketingWallet = newMarketingWallet;
1077     }
1078     
1079     function updateDevWallet(address newWallet) external onlyOwner {
1080         emit devWalletUpdated(newWallet, devWallet);
1081         devWallet = newWallet;
1082     }
1083     
1084 
1085     function isExcludedFromFees(address account) public view returns(bool) {
1086         return _isExcludedFromFees[account];
1087     }
1088     
1089     event BoughtEarly(address indexed sniper);
1090 
1091     function _transfer(
1092         address from,
1093         address to,
1094         uint256 amount
1095     ) internal override {
1096         require(from != address(0), "ERC20: transfer from the zero address");
1097         require(to != address(0), "ERC20: transfer to the zero address");
1098         
1099          if(amount == 0) {
1100             super._transfer(from, to, 0);
1101             return;
1102         }
1103         
1104         if(limitsInEffect){
1105             if (
1106                 from != owner() &&
1107                 to != owner() &&
1108                 to != address(0) &&
1109                 to != address(0xdead) &&
1110                 !swapping
1111             ){
1112                 if(!tradingActive){
1113                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1114                 }
1115 
1116                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1117                 if (transferDelayEnabled){
1118                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1119                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1120                         _holderLastTransferTimestamp[tx.origin] = block.number;
1121                     }
1122                 }
1123                  
1124                 //when buy
1125                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1126                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1127                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1128                 }
1129                 
1130                 //when sell
1131                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1132                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1133                 }
1134                 else if(!_isExcludedMaxTransactionAmount[to]){
1135                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1136                 }
1137             }
1138         }
1139         
1140         
1141         
1142 		uint256 contractTokenBalance = balanceOf(address(this));
1143         
1144         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1145 
1146         if( 
1147             canSwap &&
1148             swapEnabled &&
1149             !swapping &&
1150             !automatedMarketMakerPairs[from] &&
1151             !_isExcludedFromFees[from] &&
1152             !_isExcludedFromFees[to]
1153         ) {
1154             swapping = true;
1155             
1156             swapBack();
1157 
1158             swapping = false;
1159         }
1160         
1161         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1162             autoBurnLiquidityPairTokens();
1163         }
1164 
1165         bool takeFee = !swapping;
1166 
1167         // if any account belongs to _isExcludedFromFee account then remove the fee
1168         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1169             takeFee = false;
1170         }
1171         
1172         uint256 fees = 0;
1173         // only take fees on buys/sells, do not take on wallet transfers
1174         if(takeFee){
1175             // on sell
1176             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1177                 fees = amount.mul(sellTotalFees).div(100);
1178                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1179                 tokensForDev += fees * sellDevFee / sellTotalFees;
1180                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1181             }
1182             // on buy
1183             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1184         	    fees = amount.mul(buyTotalFees).div(100);
1185         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1186                 tokensForDev += fees * buyDevFee / buyTotalFees;
1187                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1188             }
1189             
1190             if(fees > 0){    
1191                 super._transfer(from, address(this), fees);
1192             }
1193         	
1194         	amount -= fees;
1195         }
1196 
1197         super._transfer(from, to, amount);
1198     }
1199 
1200     function swapTokensForEth(uint256 tokenAmount) private {
1201 
1202         // generate the uniswap pair path of token -> weth
1203         address[] memory path = new address[](2);
1204         path[0] = address(this);
1205         path[1] = uniswapV2Router.WETH();
1206 
1207         _approve(address(this), address(uniswapV2Router), tokenAmount);
1208 
1209         // make the swap
1210         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1211             tokenAmount,
1212             0, // accept any amount of ETH
1213             path,
1214             address(this),
1215             block.timestamp
1216         );
1217         
1218     }
1219     
1220     
1221     
1222     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1223         // approve token transfer to cover all possible scenarios
1224         _approve(address(this), address(uniswapV2Router), tokenAmount);
1225 
1226         // add the liquidity
1227         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1228             address(this),
1229             tokenAmount,
1230             0, // slippage is unavoidable
1231             0, // slippage is unavoidable
1232             deadAddress,
1233             block.timestamp
1234         );
1235     }
1236 
1237     function swapBack() private {
1238         uint256 contractBalance = balanceOf(address(this));
1239         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1240         bool success;
1241         
1242         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1243 
1244         if(contractBalance > swapTokensAtAmount * 20){
1245           contractBalance = swapTokensAtAmount * 20;
1246         }
1247         
1248         // Halve the amount of liquidity tokens
1249         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1250         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1251         
1252         uint256 initialETHBalance = address(this).balance;
1253 
1254         swapTokensForEth(amountToSwapForETH); 
1255         
1256         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1257         
1258         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1259         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1260         
1261         
1262         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1263         
1264         
1265         tokensForLiquidity = 0;
1266         tokensForMarketing = 0;
1267         tokensForDev = 0;
1268         
1269         (success,) = address(devWallet).call{value: ethForDev}("");
1270         
1271         if(liquidityTokens > 0 && ethForLiquidity > 0){
1272             addLiquidity(liquidityTokens, ethForLiquidity);
1273             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1274         }
1275         
1276         
1277         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1278     }
1279     
1280     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1281         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1282         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1283         lpBurnFrequency = _frequencyInSeconds;
1284         percentForLPBurn = _percent;
1285         lpBurnEnabled = _Enabled;
1286     }
1287     
1288     function autoBurnLiquidityPairTokens() internal returns (bool){
1289         
1290         lastLpBurnTime = block.timestamp;
1291         
1292         // get balance of liquidity pair
1293         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1294         
1295         // calculate amount to burn
1296         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1297         
1298         // pull tokens from pancakePair liquidity and move to dead address permanently
1299         if (amountToBurn > 0){
1300             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1301         }
1302         
1303         //sync price since this is not in a swap transaction!
1304         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1305         pair.sync();
1306         emit AutoNukeLP();
1307         return true;
1308     }
1309 
1310     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1311         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1312         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1313         lastManualLpBurnTime = block.timestamp;
1314         
1315         // get balance of liquidity pair
1316         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1317         
1318         // calculate amount to burn
1319         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1320         
1321         // pull tokens from pancakePair liquidity and move to dead address permanently
1322         if (amountToBurn > 0){
1323             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1324         }
1325         
1326         //sync price since this is not in a swap transaction!
1327         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1328         pair.sync();
1329         emit ManualNukeLP();
1330         return true;
1331     }
1332 }