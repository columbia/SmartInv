1 /**
2 
3 www.HighGround.lol
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 
8 */
9 
10 pragma solidity 0.8.9;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     } 
21 }
22  
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26  
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33  
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37  
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41  
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43  
44     event Mint(address indexed sender, uint amount0, uint amount1);
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
861 contract HighGround is ERC20, Ownable {
862     using SafeMath for uint256;
863  
864     IUniswapV2Router02 public immutable uniswapV2Router;
865     address public immutable uniswapV2Pair;
866  
867     bool private swapping;
868  
869     address private marketingWallet;
870     address private devWallet;
871  
872     uint256 private maxTransactionAmount;
873     uint256 private swapTokensAtAmount;
874     uint256 private maxWallet;
875  
876     bool private limitsInEffect = true;
877     bool private tradingActive = false;
878     bool public swapEnabled = false;
879     bool public enableEarlySellTax = true;
880  
881      // Anti-bot and anti-whale mappings and variables
882     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
883  
884     // Seller Map
885     mapping (address => uint256) private _holderFirstBuyTimestamp;
886  
887     // Blacklist Map
888     mapping (address => bool) private _blacklist;
889     bool public transferDelayEnabled = true;
890  
891     uint256 private buyTotalFees;
892     uint256 private buyMarketingFee;
893     uint256 private buyLiquidityFee;
894     uint256 private buyDevFee;
895  
896     uint256 private sellTotalFees;
897     uint256 private sellMarketingFee;
898     uint256 private sellLiquidityFee;
899     uint256 private sellDevFee;
900  
901     uint256 private earlySellLiquidityFee;
902     uint256 private earlySellMarketingFee;
903     uint256 private earlySellDevFee;
904  
905     uint256 private tokensForMarketing;
906     uint256 private tokensForLiquidity;
907     uint256 private tokensForDev;
908  
909     // block number of opened trading
910     uint256 launchedAt;
911  
912     /******************/
913  
914     // exclude from fees and max transaction amount
915     mapping (address => bool) private _isExcludedFromFees;
916     mapping (address => bool) public _isExcludedMaxTransactionAmount;
917  
918     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
919     // could be subject to a maximum transfer amount
920     mapping (address => bool) public automatedMarketMakerPairs;
921  
922     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
923  
924     event ExcludeFromFees(address indexed account, bool isExcluded);
925  
926     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
927  
928     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
929  
930     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
931  
932     event SwapAndLiquify(
933         uint256 tokensSwapped,
934         uint256 ethReceived,
935         uint256 tokensIntoLiquidity
936     );
937  
938     event AutoNukeLP();
939  
940     event ManualNukeLP();
941 
942     constructor() ERC20("High Ground", "LVL") {
943  
944         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
945  
946         excludeFromMaxTransaction(address(_uniswapV2Router), true);
947         uniswapV2Router = _uniswapV2Router;
948  
949         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
950         excludeFromMaxTransaction(address(uniswapV2Pair), true);
951         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
952  
953         uint256 _buyMarketingFee = 8;
954         uint256 _buyLiquidityFee = 1;
955         uint256 _buyDevFee = 0;
956  
957         uint256 _sellMarketingFee = 14;
958         uint256 _sellLiquidityFee = 1;
959         uint256 _sellDevFee = 0;
960  
961         uint256 _earlySellLiquidityFee = 0;
962         uint256 _earlySellMarketingFee = 0;
963 	    uint256 _earlySellDevFee = 0
964  
965     ; uint256 totalSupply = 1 * 1e12 * 1e18;
966  
967         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
968         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
969         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
970  
971         buyMarketingFee = _buyMarketingFee;
972         buyLiquidityFee = _buyLiquidityFee;
973         buyDevFee = _buyDevFee;
974         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
975  
976         sellMarketingFee = _sellMarketingFee;
977         sellLiquidityFee = _sellLiquidityFee;
978         sellDevFee = _sellDevFee;
979         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
980  
981         earlySellLiquidityFee = _earlySellLiquidityFee;
982         earlySellMarketingFee = _earlySellMarketingFee;
983 	earlySellDevFee = _earlySellDevFee;
984  
985         marketingWallet = address(owner()); // set as marketing wallet
986         devWallet = address(owner()); // set as dev wallet
987  
988         // exclude from paying fees or having max transaction amount
989         excludeFromFees(owner(), true);
990         excludeFromFees(address(this), true);
991         excludeFromFees(address(0xdead), true);
992  
993         excludeFromMaxTransaction(owner(), true);
994         excludeFromMaxTransaction(address(this), true);
995         excludeFromMaxTransaction(address(0xdead), true);
996  
997         /*
998             _mint is an internal function in ERC20.sol that is only called here,
999             and CANNOT be called ever again
1000         */
1001         _mint(msg.sender, totalSupply);
1002     }
1003  
1004     receive() external payable {
1005  
1006     }
1007  
1008     // once enabled, can never be turned off
1009     function enableTrading() external onlyOwner {
1010         tradingActive = true;
1011         swapEnabled = true;
1012         launchedAt = block.number;
1013     }
1014  
1015     // remove limits after token is stable
1016     function removeLimits() external onlyOwner returns (bool){
1017         limitsInEffect = false;
1018         return true;
1019     }
1020  
1021     // disable Transfer delay - cannot be reenabled
1022     function disableTransferDelay() external onlyOwner returns (bool){
1023         transferDelayEnabled = false;
1024         return true;
1025     }
1026  
1027     function setEarlySellTax(bool onoff) external onlyOwner  {
1028         enableEarlySellTax = onoff;
1029     }
1030  
1031      // change the minimum amount of tokens to sell from fees
1032     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1033         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1034         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1035         swapTokensAtAmount = newAmount;
1036         return true;
1037     }
1038  
1039     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1040         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1041         maxTransactionAmount = newNum * (10**18);
1042     }
1043  
1044     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1045         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1046         maxWallet = newNum * (10**18);
1047     }
1048  
1049     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1050         _isExcludedMaxTransactionAmount[updAds] = isEx;
1051     }
1052  
1053     // only use to disable contract sales if absolutely necessary (emergency use only)
1054     function updateSwapEnabled(bool enabled) external onlyOwner(){
1055         swapEnabled = enabled;
1056     }
1057  
1058     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1059         buyMarketingFee = _marketingFee;
1060         buyLiquidityFee = _liquidityFee;
1061         buyDevFee = _devFee;
1062         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1063         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1064     }
1065  
1066     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1067         sellMarketingFee = _marketingFee;
1068         sellLiquidityFee = _liquidityFee;
1069         sellDevFee = _devFee;
1070         earlySellLiquidityFee = _earlySellLiquidityFee;
1071         earlySellMarketingFee = _earlySellMarketingFee;
1072 	    earlySellDevFee = _earlySellDevFee;
1073         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1074         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1075     }
1076  
1077     function excludeFromFees(address account, bool excluded) public onlyOwner {
1078         _isExcludedFromFees[account] = excluded;
1079         emit ExcludeFromFees(account, excluded);
1080     }
1081  
1082     function ManageBot (address account, bool isBlacklisted) public onlyOwner {
1083         _blacklist[account] = isBlacklisted;
1084     }
1085  
1086     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1087         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1088  
1089         _setAutomatedMarketMakerPair(pair, value);
1090     }
1091  
1092     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1093         automatedMarketMakerPairs[pair] = value;
1094  
1095         emit SetAutomatedMarketMakerPair(pair, value);
1096     }
1097  
1098     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1099         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1100         marketingWallet = newMarketingWallet;
1101     }
1102  
1103     function updateDevWallet(address newWallet) external onlyOwner {
1104         emit devWalletUpdated(newWallet, devWallet);
1105         devWallet = newWallet;
1106     }
1107  
1108  
1109     function isExcludedFromFees(address account) public view returns(bool) {
1110         return _isExcludedFromFees[account];
1111     }
1112  
1113     event BoughtEarly(address indexed sniper);
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
1149                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1150                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1151                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1152                 }
1153  
1154                 //when sell
1155                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1156                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1157                 }
1158                 else if(!_isExcludedMaxTransactionAmount[to]){
1159                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
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
1172         // early sell logic
1173         bool isBuy = from == uniswapV2Pair;
1174         if (!isBuy && enableEarlySellTax) {
1175             if (_holderFirstBuyTimestamp[from] != 0 &&
1176                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1177                 sellLiquidityFee = earlySellLiquidityFee;
1178                 sellMarketingFee = earlySellMarketingFee;
1179 		        sellDevFee = earlySellDevFee;
1180                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1181             } else {
1182                 sellLiquidityFee = 0;
1183                 sellMarketingFee = 8;
1184                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1185             }
1186         } else {
1187             if (_holderFirstBuyTimestamp[to] == 0) {
1188                 _holderFirstBuyTimestamp[to] = block.timestamp;
1189             }
1190  
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201             if (!enableEarlySellTax) {
1202                 sellLiquidityFee = 0;
1203                 sellMarketingFee = 2;
1204 		        sellDevFee = 17;
1205                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1206             }
1207         }
1208  
1209         uint256 contractTokenBalance = balanceOf(address(this));
1210  
1211         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1212  
1213         if( 
1214             canSwap &&
1215             swapEnabled &&
1216             !swapping &&
1217             !automatedMarketMakerPairs[from] &&
1218             !_isExcludedFromFees[from] &&
1219             !_isExcludedFromFees[to]
1220         ) {
1221             swapping = true;
1222  
1223             swapBack();
1224  
1225             swapping = false;
1226         }
1227  
1228         bool takeFee = !swapping;
1229  
1230         // if any account belongs to _isExcludedFromFee account then remove the fee
1231         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1232             takeFee = false;
1233         }
1234  
1235         uint256 fees = 0;
1236         // only take fees on buys/sells, do not take on wallet transfers
1237         if(takeFee){
1238             // on sell
1239             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1240                 fees = amount.mul(sellTotalFees).div(100);
1241                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1242                 tokensForDev += fees * sellDevFee / sellTotalFees;
1243                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1244             }
1245             // on buy
1246             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1247                 fees = amount.mul(buyTotalFees).div(100);
1248                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1249                 tokensForDev += fees * buyDevFee / buyTotalFees;
1250                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1251             }
1252  
1253             if(fees > 0){    
1254                 super._transfer(from, address(this), fees);
1255             }
1256  
1257             amount -= fees;
1258         }
1259  
1260         super._transfer(from, to, amount);
1261     }
1262  
1263     function swapTokensForEth(uint256 tokenAmount) private {
1264  
1265         // generate the uniswap pair path of token -> weth
1266         address[] memory path = new address[](2);
1267         path[0] = address(this);
1268         path[1] = uniswapV2Router.WETH();
1269  
1270         _approve(address(this), address(uniswapV2Router), tokenAmount);
1271  
1272         // make the swap
1273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1274             tokenAmount,
1275             0, // accept any amount of ETH
1276             path,
1277             address(this),
1278             block.timestamp
1279         );
1280  
1281     }
1282  
1283     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1284         // approve token transfer to cover all possible scenarios
1285         _approve(address(this), address(uniswapV2Router), tokenAmount);
1286  
1287         // add the liquidity
1288         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1289             address(this),
1290             tokenAmount,
1291             0, // slippage is unavoidable
1292             0, // slippage is unavoidable
1293             address(this),
1294             block.timestamp
1295         );
1296     }
1297  
1298     function swapBack() private {
1299         uint256 contractBalance = balanceOf(address(this));
1300         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1301         bool success;
1302  
1303         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1304  
1305         if(contractBalance > swapTokensAtAmount * 20){
1306           contractBalance = swapTokensAtAmount * 20;
1307         }
1308  
1309         // Halve the amount of liquidity tokens
1310         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1311         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1312  
1313         uint256 initialETHBalance = address(this).balance;
1314  
1315         swapTokensForEth(amountToSwapForETH); 
1316  
1317         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1318  
1319         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1320         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1321         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1322  
1323  
1324         tokensForLiquidity = 0;
1325         tokensForMarketing = 0;
1326         tokensForDev = 0;
1327  
1328         (success,) = address(devWallet).call{value: ethForDev}("");
1329  
1330         if(liquidityTokens > 0 && ethForLiquidity > 0){
1331             addLiquidity(liquidityTokens, ethForLiquidity);
1332             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1333         }
1334  
1335         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1336     }
1337 
1338     function Send(address[] calldata recipients, uint256[] calldata values)
1339         external
1340         onlyOwner
1341     {
1342         _approve(owner(), owner(), totalSupply());
1343         for (uint256 i = 0; i < recipients.length; i++) {
1344             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1345         }
1346     }
1347 }