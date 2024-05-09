1 /*
2 Welcome To The Top G Token. Real G’s Dont Sit Around Gossiping In Telegram Like Girls. 
3 When We Get Into Something We Dont Back Out, We Work Hard Like Men And Make It Happen. 
4 This Token Does Not Welcome Any Brokeys That Do Not Want A 100X. Now Buy, Spread The Word, And Shut UP! 
5 Stop Asking For A Website Like A Little Girl That Will Be Coming Soon. 
6 What You Need To Worry About Is How Can You Become A Top G Holder And BE RICH! 
7 
8 Oh Yeah Top G Charges 3% Tax For Buys/Sells You Dont Like It Then Top G Doesnt Want You Here.
9 
10 -TOP G
11 
12 https://t.me/TopGTokenEth
13 
14 */
15 
16  // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity 0.8.9;
19  
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24  
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30  
31 interface IUniswapV2Pair {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34  
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41  
42     function approve(address spender, uint value) external returns (bool);
43     function transfer(address to, uint value) external returns (bool);
44     function transferFrom(address from, address to, uint value) external returns (bool);
45  
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47     function PERMIT_TYPEHASH() external pure returns (bytes32);
48     function nonces(address owner) external view returns (uint);
49  
50     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
51  
52     event Mint(address indexed sender, uint amount0, uint amount1);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62  
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71  
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77  
78     function initialize(address, address) external;
79 }
80  
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83  
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86  
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90  
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92  
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96  
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102  
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107  
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116  
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125  
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141  
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156  
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164  
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171  
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177  
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182  
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188  
189  
190 contract ERC20 is Context, IERC20, IERC20Metadata {
191     using SafeMath for uint256;
192  
193     mapping(address => uint256) private _balances;
194  
195     mapping(address => mapping(address => uint256)) private _allowances;
196  
197     uint256 private _totalSupply;
198  
199     string private _name;
200     string private _symbol;
201  
202     /**
203      * @dev Sets the values for {name} and {symbol}.
204      *
205      * The default value of {decimals} is 18. To select a different value for
206      * {decimals} you should overload it.
207      *
208      * All two of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }
215  
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() public view virtual override returns (string memory) {
220         return _name;
221     }
222  
223     /**
224      * @dev Returns the symbol of the token, usually a shorter version of the
225      * name.
226      */
227     function symbol() public view virtual override returns (string memory) {
228         return _symbol;
229     }
230  
231     /**
232      * @dev Returns the number of decimals used to get its user representation.
233      * For example, if `decimals` equals `2`, a balance of `505` tokens should
234      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
235      *
236      * Tokens usually opt for a value of 18, imitating the relationship between
237      * Ether and Wei. This is the value {ERC20} uses, unless this function is
238      * overridden;
239      *
240      * NOTE: This information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * {IERC20-balanceOf} and {IERC20-transfer}.
243      */
244     function decimals() public view virtual override returns (uint8) {
245         return 18;
246     }
247  
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view virtual override returns (uint256) {
252         return _totalSupply;
253     }
254  
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261  
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274  
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281  
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293  
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * Requirements:
301      *
302      * - `sender` and `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      * - the caller must have allowance for ``sender``'s tokens of at least
305      * `amount`.
306      */
307     function transferFrom(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) public virtual override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
314         return true;
315     }
316  
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
331         return true;
332     }
333  
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
350         return true;
351     }
352  
353     /**
354      * @dev Moves tokens `amount` from `sender` to `recipient`.
355      *
356      * This is internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374  
375         _beforeTokenTransfer(sender, recipient, amount);
376  
377         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
378         _balances[recipient] = _balances[recipient].add(amount);
379         emit Transfer(sender, recipient, amount);
380     }
381  
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393  
394         _beforeTokenTransfer(address(0), account, amount);
395  
396         _totalSupply = _totalSupply.add(amount);
397         _balances[account] = _balances[account].add(amount);
398         emit Transfer(address(0), account, amount);
399     }
400  
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414  
415         _beforeTokenTransfer(account, address(0), amount);
416  
417         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
418         _totalSupply = _totalSupply.sub(amount);
419         emit Transfer(account, address(0), amount);
420     }
421  
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442  
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446  
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be to transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 }
467  
468 library SafeMath {
469     /**
470      * @dev Returns the addition of two unsigned integers, reverting on
471      * overflow.
472      *
473      * Counterpart to Solidity's `+` operator.
474      *
475      * Requirements:
476      *
477      * - Addition cannot overflow.
478      */
479     function add(uint256 a, uint256 b) internal pure returns (uint256) {
480         uint256 c = a + b;
481         require(c >= a, "SafeMath: addition overflow");
482  
483         return c;
484     }
485  
486     /**
487      * @dev Returns the subtraction of two unsigned integers, reverting on
488      * overflow (when the result is negative).
489      *
490      * Counterpart to Solidity's `-` operator.
491      *
492      * Requirements:
493      *
494      * - Subtraction cannot overflow.
495      */
496     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
497         return sub(a, b, "SafeMath: subtraction overflow");
498     }
499  
500     /**
501      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
502      * overflow (when the result is negative).
503      *
504      * Counterpart to Solidity's `-` operator.
505      *
506      * Requirements:
507      *
508      * - Subtraction cannot overflow.
509      */
510     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b <= a, errorMessage);
512         uint256 c = a - b;
513  
514         return c;
515     }
516  
517     /**
518      * @dev Returns the multiplication of two unsigned integers, reverting on
519      * overflow.
520      *
521      * Counterpart to Solidity's `*` operator.
522      *
523      * Requirements:
524      *
525      * - Multiplication cannot overflow.
526      */
527     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
528         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
529         // benefit is lost if 'b' is also tested.
530         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
531         if (a == 0) {
532             return 0;
533         }
534  
535         uint256 c = a * b;
536         require(c / a == b, "SafeMath: multiplication overflow");
537  
538         return c;
539     }
540  
541     /**
542      * @dev Returns the integer division of two unsigned integers. Reverts on
543      * division by zero. The result is rounded towards zero.
544      *
545      * Counterpart to Solidity's `/` operator. Note: this function uses a
546      * `revert` opcode (which leaves remaining gas untouched) while Solidity
547      * uses an invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function div(uint256 a, uint256 b) internal pure returns (uint256) {
554         return div(a, b, "SafeMath: division by zero");
555     }
556  
557     /**
558      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
559      * division by zero. The result is rounded towards zero.
560      *
561      * Counterpart to Solidity's `/` operator. Note: this function uses a
562      * `revert` opcode (which leaves remaining gas untouched) while Solidity
563      * uses an invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
570         require(b > 0, errorMessage);
571         uint256 c = a / b;
572         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
573  
574         return c;
575     }
576  
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * Reverts when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
590         return mod(a, b, "SafeMath: modulo by zero");
591     }
592  
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * Reverts with custom message when dividing by zero.
596      *
597      * Counterpart to Solidity's `%` operator. This function uses a `revert`
598      * opcode (which leaves remaining gas untouched) while Solidity uses an
599      * invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
606         require(b != 0, errorMessage);
607         return a % b;
608     }
609 }
610  
611 contract Ownable is Context {
612     address private _owner;
613  
614     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
615  
616     /**
617      * @dev Initializes the contract setting the deployer as the initial owner.
618      */
619     constructor () {
620         address msgSender = _msgSender();
621         _owner = msgSender;
622         emit OwnershipTransferred(address(0), msgSender);
623     }
624  
625     /**
626      * @dev Returns the address of the current owner.
627      */
628     function owner() public view returns (address) {
629         return _owner;
630     }
631  
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         require(_owner == _msgSender(), "Ownable: caller is not the owner");
637         _;
638     }
639  
640     /**
641      * @dev Leaves the contract without owner. It will not be possible to call
642      * `onlyOwner` functions anymore. Can only be called by the current owner.
643      *
644      * NOTE: Renouncing ownership will leave the contract without an owner,
645      * thereby removing any functionality that is only available to the owner.
646      */
647     function renounceOwnership() public virtual onlyOwner {
648         emit OwnershipTransferred(_owner, address(0));
649         _owner = address(0);
650     }
651  
652     /**
653      * @dev Transfers ownership of the contract to a new account (`newOwner`).
654      * Can only be called by the current owner.
655      */
656     function transferOwnership(address newOwner) public virtual onlyOwner {
657         require(newOwner != address(0), "Ownable: new owner is the zero address");
658         emit OwnershipTransferred(_owner, newOwner);
659         _owner = newOwner;
660     }
661 }
662  
663  
664  
665 library SafeMathInt {
666     int256 private constant MIN_INT256 = int256(1) << 255;
667     int256 private constant MAX_INT256 = ~(int256(1) << 255);
668  
669     /**
670      * @dev Multiplies two int256 variables and fails on overflow.
671      */
672     function mul(int256 a, int256 b) internal pure returns (int256) {
673         int256 c = a * b;
674  
675         // Detect overflow when multiplying MIN_INT256 with -1
676         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
677         require((b == 0) || (c / b == a));
678         return c;
679     }
680  
681     /**
682      * @dev Division of two int256 variables and fails on overflow.
683      */
684     function div(int256 a, int256 b) internal pure returns (int256) {
685         // Prevent overflow when dividing MIN_INT256 by -1
686         require(b != -1 || a != MIN_INT256);
687  
688         // Solidity already throws when dividing by 0.
689         return a / b;
690     }
691  
692     /**
693      * @dev Subtracts two int256 variables and fails on overflow.
694      */
695     function sub(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a - b;
697         require((b >= 0 && c <= a) || (b < 0 && c > a));
698         return c;
699     }
700  
701     /**
702      * @dev Adds two int256 variables and fails on overflow.
703      */
704     function add(int256 a, int256 b) internal pure returns (int256) {
705         int256 c = a + b;
706         require((b >= 0 && c >= a) || (b < 0 && c < a));
707         return c;
708     }
709  
710     /**
711      * @dev Converts to absolute value, and fails on overflow.
712      */
713     function abs(int256 a) internal pure returns (int256) {
714         require(a != MIN_INT256);
715         return a < 0 ? -a : a;
716     }
717  
718  
719     function toUint256Safe(int256 a) internal pure returns (uint256) {
720         require(a >= 0);
721         return uint256(a);
722     }
723 }
724  
725 library SafeMathUint {
726   function toInt256Safe(uint256 a) internal pure returns (int256) {
727     int256 b = int256(a);
728     require(b >= 0);
729     return b;
730   }
731 }
732  
733  
734 interface IUniswapV2Router01 {
735     function factory() external pure returns (address);
736     function WETH() external pure returns (address);
737  
738     function addLiquidity(
739         address tokenA,
740         address tokenB,
741         uint amountADesired,
742         uint amountBDesired,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountA, uint amountB, uint liquidity);
748     function addLiquidityETH(
749         address token,
750         uint amountTokenDesired,
751         uint amountTokenMin,
752         uint amountETHMin,
753         address to,
754         uint deadline
755     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
756     function removeLiquidity(
757         address tokenA,
758         address tokenB,
759         uint liquidity,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline
764     ) external returns (uint amountA, uint amountB);
765     function removeLiquidityETH(
766         address token,
767         uint liquidity,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountToken, uint amountETH);
773     function removeLiquidityWithPermit(
774         address tokenA,
775         address tokenB,
776         uint liquidity,
777         uint amountAMin,
778         uint amountBMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountA, uint amountB);
783     function removeLiquidityETHWithPermit(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline,
790         bool approveMax, uint8 v, bytes32 r, bytes32 s
791     ) external returns (uint amountToken, uint amountETH);
792     function swapExactTokensForTokens(
793         uint amountIn,
794         uint amountOutMin,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapTokensForExactTokens(
800         uint amountOut,
801         uint amountInMax,
802         address[] calldata path,
803         address to,
804         uint deadline
805     ) external returns (uint[] memory amounts);
806     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
814         external
815         returns (uint[] memory amounts);
816     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
817         external
818         payable
819         returns (uint[] memory amounts);
820  
821     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
822     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
823     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
824     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
825     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
826 }
827  
828 interface IUniswapV2Router02 is IUniswapV2Router01 {
829     function removeLiquidityETHSupportingFeeOnTransferTokens(
830         address token,
831         uint liquidity,
832         uint amountTokenMin,
833         uint amountETHMin,
834         address to,
835         uint deadline
836     ) external returns (uint amountETH);
837     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline,
844         bool approveMax, uint8 v, bytes32 r, bytes32 s
845     ) external returns (uint amountETH);
846  
847     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
848         uint amountIn,
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external;
854     function swapExactETHForTokensSupportingFeeOnTransferTokens(
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external payable;
860     function swapExactTokensForETHSupportingFeeOnTransferTokens(
861         uint amountIn,
862         uint amountOutMin,
863         address[] calldata path,
864         address to,
865         uint deadline
866     ) external;
867 }
868  
869 contract TGT is ERC20, Ownable {
870     using SafeMath for uint256;
871  
872     IUniswapV2Router02 public immutable uniswapV2Router;
873     address public immutable uniswapV2Pair;
874     address public constant deadAddress = address(0xdead);
875  
876     bool private swapping;
877  
878     address private marketingWallet;
879     address private devWallet;
880  
881     uint256 public maxTransactionAmount;
882     uint256 public swapTokensAtAmount;
883     uint256 public maxWallet;
884  
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = false;
888     bool public enableEarlySellTax = true;
889  
890      // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892  
893     // Seller Map
894     mapping (address => uint256) private _holderFirstBuyTimestamp;
895  
896     bool public transferDelayEnabled = true;
897  
898     uint256 public buyTotalFees;
899     uint256 public buyMarketingFee;
900     uint256 public buyLiquidityFee;
901     uint256 public buyDevFee;
902  
903     uint256 public sellTotalFees;
904     uint256 public sellMarketingFee;
905     uint256 public sellLiquidityFee;
906     uint256 public sellDevFee;
907  
908     uint256 public earlySellLiquidityFee;
909     uint256 public earlySellMarketingFee;
910     uint256 public earlySellDevFee;
911  
912     uint256 public tokensForMarketing;
913     uint256 public tokensForLiquidity;
914     uint256 public tokensForDev;
915  
916     /******************/
917  
918     // exclude from fees and max transaction amount
919     mapping (address => bool) private _isExcludedFromFees;
920     mapping (address => bool) public _isExcludedMaxTransactionAmount;
921  
922     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
923     // could be subject to a maximum transfer amount
924     mapping (address => bool) public automatedMarketMakerPairs;
925  
926     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
927  
928     event ExcludeFromFees(address indexed account, bool isExcluded);
929  
930     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
931  
932     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
933  
934     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
935  
936     event SwapAndLiquify(
937         uint256 tokensSwapped,
938         uint256 ethReceived,
939         uint256 tokensIntoLiquidity
940     );
941  
942     constructor() ERC20("Top G Token", "TGT") {
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
953         uint256 _buyMarketingFee = 3;
954         uint256 _buyLiquidityFee = 0;
955         uint256 _buyDevFee = 0;
956  
957         uint256 _sellMarketingFee = 3;
958         uint256 _sellLiquidityFee = 0;
959         uint256 _sellDevFee = 0;
960  
961         uint256 _earlySellLiquidityFee = 0;
962         uint256 _earlySellMarketingFee = 3;
963 	    uint256 _earlySellDevFee = 0;
964  
965         uint256 totalSupply = 1 * 1e10 * 1e18;
966  
967         maxTransactionAmount = totalSupply * 15 / 1000; // 1.5% maxTransactionAmountTxn
968         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
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
983 	    earlySellDevFee = _earlySellDevFee;
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
1012     }
1013  
1014     // remove limits after token is stable
1015     function removeLimits() external onlyOwner returns (bool){
1016         limitsInEffect = false;
1017         return true;
1018     }
1019  
1020     // disable Transfer delay - cannot be reenabled
1021     function disableTransferDelay() external onlyOwner returns (bool){
1022         transferDelayEnabled = false;
1023         return true;
1024     }
1025  
1026     function setEarlySellTax(bool onoff) external onlyOwner  {
1027         enableEarlySellTax = onoff;
1028     }
1029  
1030     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1031         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1032         maxTransactionAmount = newNum * (10**18);
1033     }
1034  
1035     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1036         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1037         maxWallet = newNum * (10**18);
1038     }
1039  
1040     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1041         _isExcludedMaxTransactionAmount[updAds] = isEx;
1042     }
1043  
1044     // only use to disable contract sales if absolutely necessary (emergency use only)
1045     function updateSwapEnabled(bool enabled) external onlyOwner(){
1046         swapEnabled = enabled;
1047     }
1048  
1049     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner(){
1050         buyMarketingFee = _marketingFee;
1051         buyLiquidityFee = _liquidityFee;
1052         buyDevFee = _devFee;
1053         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1054         require(buyTotalFees <= 20, "Must keep buy fees at 20% or less");
1055     }
1056  
1057     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner(){
1058         sellMarketingFee = _marketingFee;
1059         sellLiquidityFee = _liquidityFee;
1060         sellDevFee = _devFee;
1061         earlySellLiquidityFee = _earlySellLiquidityFee;
1062         earlySellMarketingFee = _earlySellMarketingFee;
1063 	    earlySellDevFee = _earlySellDevFee;
1064         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1065         require(sellTotalFees <= 20, "Must keep sell fees at 20% or less");
1066         uint256 earlySellTotalFees = _earlySellMarketingFee + _earlySellLiquidityFee + _earlySellDevFee;
1067         require(earlySellTotalFees <= 20, "Must keep early sell fee at 20% or less");
1068     }
1069  
1070     function excludeFromFees(address account, bool excluded) public onlyOwner {
1071         _isExcludedFromFees[account] = excluded;
1072         emit ExcludeFromFees(account, excluded);
1073     }
1074  
1075     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1076         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1077  
1078         _setAutomatedMarketMakerPair(pair, value);
1079     }
1080  
1081     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1082         automatedMarketMakerPairs[pair] = value;
1083  
1084         emit SetAutomatedMarketMakerPair(pair, value);
1085     }
1086  
1087     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1088         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1089         marketingWallet = newMarketingWallet;
1090         excludeFromFees(marketingWallet,true);
1091         excludeFromMaxTransaction(marketingWallet,true);
1092     }
1093  
1094     function updateDevWallet(address newWallet) external onlyOwner {
1095         emit devWalletUpdated(newWallet, devWallet);
1096         devWallet = newWallet;
1097         excludeFromFees(devWallet,true);
1098         excludeFromMaxTransaction(devWallet,true);
1099     }
1100  
1101  
1102     function isExcludedFromFees(address account) public view returns(bool) {
1103         return _isExcludedFromFees[account];
1104     }
1105  
1106     function _transfer(
1107         address from,
1108         address to,
1109         uint256 amount
1110     ) internal override {
1111         require(from != address(0), "ERC20: transfer from the zero address");
1112         require(to != address(0), "ERC20: transfer to the zero address");
1113         if(amount == 0) {
1114             super._transfer(from, to, 0);
1115             return;
1116         }
1117  
1118         if(limitsInEffect){
1119             if (
1120                 from != owner() &&
1121                 to != owner() &&
1122                 to != address(0) &&
1123                 to != address(0xdead) &&
1124                 !swapping
1125             ){
1126                 if(!tradingActive){
1127                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1128                 }
1129  
1130                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1131                 if (transferDelayEnabled){
1132                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1133                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1134                         _holderLastTransferTimestamp[tx.origin] = block.number;
1135                     }
1136                 }
1137  
1138                 //when buy
1139                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1140                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1141                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1142                 }
1143  
1144                 //when sell
1145                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1146                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1147                 }
1148                 else if(!_isExcludedMaxTransactionAmount[to]){
1149                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1150                 }
1151             }
1152         }
1153  
1154         // early sell logic
1155         bool isBuy = from == uniswapV2Pair;
1156         if (!isBuy && enableEarlySellTax) {
1157             if (_holderFirstBuyTimestamp[from] != 0 &&
1158                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1159                 sellLiquidityFee = earlySellLiquidityFee;
1160                 sellMarketingFee = earlySellMarketingFee;
1161 		        sellDevFee = earlySellDevFee;
1162                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1163             } else {
1164                 sellLiquidityFee = 1;
1165                 sellMarketingFee = 4;
1166                 sellDevFee = 1;
1167                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1168             }
1169         } else {
1170             if (_holderFirstBuyTimestamp[to] == 0) {
1171                 _holderFirstBuyTimestamp[to] = block.timestamp;
1172             }
1173  
1174             if (!enableEarlySellTax) {
1175                 sellLiquidityFee = 1;
1176                 sellMarketingFee = 4;
1177 		        sellDevFee = 1;
1178                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1179             }
1180         }
1181  
1182         uint256 contractTokenBalance = balanceOf(address(this));
1183  
1184         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1185  
1186         if( 
1187             canSwap &&
1188             swapEnabled &&
1189             !swapping &&
1190             !automatedMarketMakerPairs[from] &&
1191             !_isExcludedFromFees[from] &&
1192             !_isExcludedFromFees[to]
1193         ) {
1194             swapping = true;
1195  
1196             swapBack();
1197  
1198             swapping = false;
1199         }
1200  
1201         bool takeFee = !swapping;
1202  
1203         // if any account belongs to _isExcludedFromFee account then remove the fee
1204         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1205             takeFee = false;
1206         }
1207  
1208         uint256 fees = 0;
1209         // only take fees on buys/sells, do not take on wallet transfers
1210         if(takeFee){
1211             // on sell
1212             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1213                 fees = amount.mul(sellTotalFees).div(100);
1214                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1215                 tokensForDev += fees * sellDevFee / sellTotalFees;
1216                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1217             }
1218             // on buy
1219             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1220                 fees = amount.mul(buyTotalFees).div(100);
1221                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1222                 tokensForDev += fees * buyDevFee / buyTotalFees;
1223                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1224             }
1225  
1226             if(fees > 0){    
1227                 super._transfer(from, address(this), fees);
1228             }
1229  
1230             amount -= fees;
1231         }
1232  
1233         super._transfer(from, to, amount);
1234     }
1235  
1236     function swapTokensForEth(uint256 tokenAmount) private {
1237  
1238         // generate the uniswap pair path of token -> weth
1239         address[] memory path = new address[](2);
1240         path[0] = address(this);
1241         path[1] = uniswapV2Router.WETH();
1242  
1243         _approve(address(this), address(uniswapV2Router), tokenAmount);
1244  
1245         // make the swap
1246         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1247             tokenAmount,
1248             0, // accept any amount of ETH
1249             path,
1250             address(this),
1251             block.timestamp
1252         );
1253  
1254     }
1255  
1256     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1257         // approve token transfer to cover all possible scenarios
1258         _approve(address(this), address(uniswapV2Router), tokenAmount);
1259  
1260         // add the liquidity
1261         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1262             address(this),
1263             tokenAmount,
1264             0, // slippage is unavoidable
1265             0, // slippage is unavoidable
1266             deadAddress,
1267             block.timestamp
1268         );
1269     }
1270  
1271     function swapBack() private {
1272         uint256 contractBalance = balanceOf(address(this));
1273         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1274         bool success;
1275  
1276         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1277  
1278         if(contractBalance > swapTokensAtAmount * 20){
1279           contractBalance = swapTokensAtAmount * 20;
1280         }
1281  
1282         // Halve the amount of liquidity tokens
1283         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1284         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1285  
1286         uint256 initialETHBalance = address(this).balance;
1287  
1288         swapTokensForEth(amountToSwapForETH); 
1289  
1290         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1291  
1292         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1293         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1294         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1295  
1296  
1297         tokensForLiquidity = 0;
1298         tokensForMarketing = 0;
1299         tokensForDev = 0;
1300  
1301         (success,) = address(devWallet).call{value: ethForDev}("");
1302  
1303         if(liquidityTokens > 0 && ethForLiquidity > 0){
1304             addLiquidity(liquidityTokens, ethForLiquidity);
1305             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1306         }
1307  
1308         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1309     }
1310 
1311 }