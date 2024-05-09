1 /**
2 MemeBet is bridging the Gap between Betting and Memecoins.
3 Wager on over 100 sports and play over 50 casino games.
4 Wages and Payouts in Meme coins will earn up to a 5x multiplier on their winnings
5 Betting Dapp is at end stages of development. Previews after launch.
6 Ticket giveaways to World Cup, World Series, Super Bowl and other major sporting events.
7 Memebet brings a new twist to betting and we will unite the meme space
8 
9 Max TX: 2%
10 Max Wallet: 2%
11 Tax: 5%
12 Twitter: https://twitter.com/Meme_BetCasino
13 Medium: https://memebet.medium.com/memebet-mbet-4808587af55c
14 Telegram: https://t.me/memebeteth
15 
16 
17 */
18 //SPDX-License-Identifier: Unlicensed
19 pragma solidity 0.8.9;
20  
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25  
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31  
32 interface IUniswapV2Pair {
33     event Approval(address indexed owner, address indexed spender, uint value);
34     event Transfer(address indexed from, address indexed to, uint value);
35  
36     function name() external pure returns (string memory);
37     function symbol() external pure returns (string memory);
38     function decimals() external pure returns (uint8);
39     function totalSupply() external view returns (uint);
40     function balanceOf(address owner) external view returns (uint);
41     function allowance(address owner, address spender) external view returns (uint);
42  
43     function approve(address spender, uint value) external returns (bool);
44     function transfer(address to, uint value) external returns (bool);
45     function transferFrom(address from, address to, uint value) external returns (bool);
46  
47     function DOMAIN_SEPARATOR() external view returns (bytes32);
48     function PERMIT_TYPEHASH() external pure returns (bytes32);
49     function nonces(address owner) external view returns (uint);
50  
51     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52  
53     event Mint(address indexed sender, uint amount0, uint amount1);
54     event Swap(
55         address indexed sender,
56         uint amount0In,
57         uint amount1In,
58         uint amount0Out,
59         uint amount1Out,
60         address indexed to
61     );
62     event Sync(uint112 reserve0, uint112 reserve1);
63  
64     function MINIMUM_LIQUIDITY() external pure returns (uint);
65     function factory() external view returns (address);
66     function token0() external view returns (address);
67     function token1() external view returns (address);
68     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
69     function price0CumulativeLast() external view returns (uint);
70     function price1CumulativeLast() external view returns (uint);
71     function kLast() external view returns (uint);
72  
73     function mint(address to) external returns (uint liquidity);
74     function burn(address to) external returns (uint amount0, uint amount1);
75     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
76     function skim(address to) external;
77     function sync() external;
78  
79     function initialize(address, address) external;
80 }
81  
82 interface IUniswapV2Factory {
83     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
84  
85     function feeTo() external view returns (address);
86     function feeToSetter() external view returns (address);
87  
88     function getPair(address tokenA, address tokenB) external view returns (address pair);
89     function allPairs(uint) external view returns (address pair);
90     function allPairsLength() external view returns (uint);
91  
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93  
94     function setFeeTo(address) external;
95     function setFeeToSetter(address) external;
96 }
97  
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103  
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108  
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117  
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126  
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142  
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) external returns (bool);
157  
158     /**
159      * @dev Emitted when `value` tokens are moved from one account (`from`) to
160      * another (`to`).
161      *
162      * Note that `value` may be zero.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 value);
165  
166     /**
167      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
168      * a call to {approve}. `value` is the new allowance.
169      */
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172  
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178  
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183  
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189  
190  
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     using SafeMath for uint256;
193  
194     mapping(address => uint256) private _balances;
195  
196     mapping(address => mapping(address => uint256)) private _allowances;
197  
198     uint256 private _totalSupply;
199  
200     string private _name;
201     string private _symbol;
202  
203     /**
204      * @dev Sets the values for {name} and {symbol}.
205      *
206      * The default value of {decimals} is 18. To select a different value for
207      * {decimals} you should overload it.
208      *
209      * All two of these values are immutable: they can only be set once during
210      * construction.
211      */
212     constructor(string memory name_, string memory symbol_) {
213         _name = name_;
214         _symbol = symbol_;
215     }
216  
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() public view virtual override returns (string memory) {
221         return _name;
222     }
223  
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() public view virtual override returns (string memory) {
229         return _symbol;
230     }
231  
232     /**
233      * @dev Returns the number of decimals used to get its user representation.
234      * For example, if `decimals` equals `2`, a balance of `505` tokens should
235      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
236      *
237      * Tokens usually opt for a value of 18, imitating the relationship between
238      * Ether and Wei. This is the value {ERC20} uses, unless this function is
239      * overridden;
240      *
241      * NOTE: This information is only used for _display_ purposes: it in
242      * no way affects any of the arithmetic of the contract, including
243      * {IERC20-balanceOf} and {IERC20-transfer}.
244      */
245     function decimals() public view virtual override returns (uint8) {
246         return 18;
247     }
248  
249     /**
250      * @dev See {IERC20-totalSupply}.
251      */
252     function totalSupply() public view virtual override returns (uint256) {
253         return _totalSupply;
254     }
255  
256     /**
257      * @dev See {IERC20-balanceOf}.
258      */
259     function balanceOf(address account) public view virtual override returns (uint256) {
260         return _balances[account];
261     }
262  
263     /**
264      * @dev See {IERC20-transfer}.
265      *
266      * Requirements:
267      *
268      * - `recipient` cannot be the zero address.
269      * - the caller must have a balance of at least `amount`.
270      */
271     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275  
276     /**
277      * @dev See {IERC20-allowance}.
278      */
279     function allowance(address owner, address spender) public view virtual override returns (uint256) {
280         return _allowances[owner][spender];
281     }
282  
283     /**
284      * @dev See {IERC20-approve}.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount) public virtual override returns (bool) {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294  
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * Requirements:
302      *
303      * - `sender` and `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      * - the caller must have allowance for ``sender``'s tokens of at least
306      * `amount`.
307      */
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public virtual override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
315         return true;
316     }
317  
318     /**
319      * @dev Atomically increases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
332         return true;
333     }
334  
335     /**
336      * @dev Atomically decreases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      * - `spender` must have allowance for the caller of at least
347      * `subtractedValue`.
348      */
349     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
351         return true;
352     }
353  
354     /**
355      * @dev Moves tokens `amount` from `sender` to `recipient`.
356      *
357      * This is internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375  
376         _beforeTokenTransfer(sender, recipient, amount);
377  
378         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
379         _balances[recipient] = _balances[recipient].add(amount);
380         emit Transfer(sender, recipient, amount);
381     }
382  
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: mint to the zero address");
394  
395         _beforeTokenTransfer(address(0), account, amount);
396  
397         _totalSupply = _totalSupply.add(amount);
398         _balances[account] = _balances[account].add(amount);
399         emit Transfer(address(0), account, amount);
400     }
401  
402     /**
403      * @dev Destroys `amount` tokens from `account`, reducing the
404      * total supply.
405      *
406      * Emits a {Transfer} event with `to` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      * - `account` must have at least `amount` tokens.
412      */
413     function _burn(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: burn from the zero address");
415  
416         _beforeTokenTransfer(account, address(0), amount);
417  
418         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
419         _totalSupply = _totalSupply.sub(amount);
420         emit Transfer(account, address(0), amount);
421     }
422  
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(
437         address owner,
438         address spender,
439         uint256 amount
440     ) internal virtual {
441         require(owner != address(0), "ERC20: approve from the zero address");
442         require(spender != address(0), "ERC20: approve to the zero address");
443  
444         _allowances[owner][spender] = amount;
445         emit Approval(owner, spender, amount);
446     }
447  
448     /**
449      * @dev Hook that is called before any transfer of tokens. This includes
450      * minting and burning.
451      *
452      * Calling conditions:
453      *
454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
455      * will be to transferred to `to`.
456      * - when `from` is zero, `amount` tokens will be minted for `to`.
457      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
458      * - `from` and `to` are never both zero.
459      *
460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
461      */
462     function _beforeTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 }
468  
469 library SafeMath {
470     /**
471      * @dev Returns the addition of two unsigned integers, reverting on
472      * overflow.
473      *
474      * Counterpart to Solidity's `+` operator.
475      *
476      * Requirements:
477      *
478      * - Addition cannot overflow.
479      */
480     function add(uint256 a, uint256 b) internal pure returns (uint256) {
481         uint256 c = a + b;
482         require(c >= a, "SafeMath: addition overflow");
483  
484         return c;
485     }
486  
487     /**
488      * @dev Returns the subtraction of two unsigned integers, reverting on
489      * overflow (when the result is negative).
490      *
491      * Counterpart to Solidity's `-` operator.
492      *
493      * Requirements:
494      *
495      * - Subtraction cannot overflow.
496      */
497     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
498         return sub(a, b, "SafeMath: subtraction overflow");
499     }
500  
501     /**
502      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
503      * overflow (when the result is negative).
504      *
505      * Counterpart to Solidity's `-` operator.
506      *
507      * Requirements:
508      *
509      * - Subtraction cannot overflow.
510      */
511     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
512         require(b <= a, errorMessage);
513         uint256 c = a - b;
514  
515         return c;
516     }
517  
518     /**
519      * @dev Returns the multiplication of two unsigned integers, reverting on
520      * overflow.
521      *
522      * Counterpart to Solidity's `*` operator.
523      *
524      * Requirements:
525      *
526      * - Multiplication cannot overflow.
527      */
528     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
529         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
530         // benefit is lost if 'b' is also tested.
531         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
532         if (a == 0) {
533             return 0;
534         }
535  
536         uint256 c = a * b;
537         require(c / a == b, "SafeMath: multiplication overflow");
538  
539         return c;
540     }
541  
542     /**
543      * @dev Returns the integer division of two unsigned integers. Reverts on
544      * division by zero. The result is rounded towards zero.
545      *
546      * Counterpart to Solidity's `/` operator. Note: this function uses a
547      * `revert` opcode (which leaves remaining gas untouched) while Solidity
548      * uses an invalid opcode to revert (consuming all remaining gas).
549      *
550      * Requirements:
551      *
552      * - The divisor cannot be zero.
553      */
554     function div(uint256 a, uint256 b) internal pure returns (uint256) {
555         return div(a, b, "SafeMath: division by zero");
556     }
557  
558     /**
559      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
560      * division by zero. The result is rounded towards zero.
561      *
562      * Counterpart to Solidity's `/` operator. Note: this function uses a
563      * `revert` opcode (which leaves remaining gas untouched) while Solidity
564      * uses an invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
571         require(b > 0, errorMessage);
572         uint256 c = a / b;
573         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
574  
575         return c;
576     }
577  
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580      * Reverts when dividing by zero.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
591         return mod(a, b, "SafeMath: modulo by zero");
592     }
593  
594     /**
595      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
596      * Reverts with custom message when dividing by zero.
597      *
598      * Counterpart to Solidity's `%` operator. This function uses a `revert`
599      * opcode (which leaves remaining gas untouched) while Solidity uses an
600      * invalid opcode to revert (consuming all remaining gas).
601      *
602      * Requirements:
603      *
604      * - The divisor cannot be zero.
605      */
606     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
607         require(b != 0, errorMessage);
608         return a % b;
609     }
610 }
611  
612 contract Ownable is Context {
613     address private _owner;
614  
615     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
616  
617     /**
618      * @dev Initializes the contract setting the deployer as the initial owner.
619      */
620     constructor () {
621         address msgSender = _msgSender();
622         _owner = msgSender;
623         emit OwnershipTransferred(address(0), msgSender);
624     }
625  
626     /**
627      * @dev Returns the address of the current owner.
628      */
629     function owner() public view returns (address) {
630         return _owner;
631     }
632  
633     /**
634      * @dev Throws if called by any account other than the owner.
635      */
636     modifier onlyOwner() {
637         require(_owner == _msgSender(), "Ownable: caller is not the owner");
638         _;
639     }
640  
641     /**
642      * @dev Leaves the contract without owner. It will not be possible to call
643      * `onlyOwner` functions anymore. Can only be called by the current owner.
644      *
645      * NOTE: Renouncing ownership will leave the contract without an owner,
646      * thereby removing any functionality that is only available to the owner.
647      */
648     function renounceOwnership() public virtual onlyOwner {
649         emit OwnershipTransferred(_owner, address(0));
650         _owner = address(0);
651     }
652  
653     /**
654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
655      * Can only be called by the current owner.
656      */
657     function transferOwnership(address newOwner) public virtual onlyOwner {
658         require(newOwner != address(0), "Ownable: new owner is the zero address");
659         emit OwnershipTransferred(_owner, newOwner);
660         _owner = newOwner;
661     }
662 }
663  
664  
665  
666 library SafeMathInt {
667     int256 private constant MIN_INT256 = int256(1) << 255;
668     int256 private constant MAX_INT256 = ~(int256(1) << 255);
669  
670     /**
671      * @dev Multiplies two int256 variables and fails on overflow.
672      */
673     function mul(int256 a, int256 b) internal pure returns (int256) {
674         int256 c = a * b;
675  
676         // Detect overflow when multiplying MIN_INT256 with -1
677         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
678         require((b == 0) || (c / b == a));
679         return c;
680     }
681  
682     /**
683      * @dev Division of two int256 variables and fails on overflow.
684      */
685     function div(int256 a, int256 b) internal pure returns (int256) {
686         // Prevent overflow when dividing MIN_INT256 by -1
687         require(b != -1 || a != MIN_INT256);
688  
689         // Solidity already throws when dividing by 0.
690         return a / b;
691     }
692  
693     /**
694      * @dev Subtracts two int256 variables and fails on overflow.
695      */
696     function sub(int256 a, int256 b) internal pure returns (int256) {
697         int256 c = a - b;
698         require((b >= 0 && c <= a) || (b < 0 && c > a));
699         return c;
700     }
701  
702     /**
703      * @dev Adds two int256 variables and fails on overflow.
704      */
705     function add(int256 a, int256 b) internal pure returns (int256) {
706         int256 c = a + b;
707         require((b >= 0 && c >= a) || (b < 0 && c < a));
708         return c;
709     }
710  
711     /**
712      * @dev Converts to absolute value, and fails on overflow.
713      */
714     function abs(int256 a) internal pure returns (int256) {
715         require(a != MIN_INT256);
716         return a < 0 ? -a : a;
717     }
718  
719  
720     function toUint256Safe(int256 a) internal pure returns (uint256) {
721         require(a >= 0);
722         return uint256(a);
723     }
724 }
725  
726 library SafeMathUint {
727   function toInt256Safe(uint256 a) internal pure returns (int256) {
728     int256 b = int256(a);
729     require(b >= 0);
730     return b;
731   }
732 }
733  
734  
735 interface IUniswapV2Router01 {
736     function factory() external pure returns (address);
737     function WETH() external pure returns (address);
738  
739     function addLiquidity(
740         address tokenA,
741         address tokenB,
742         uint amountADesired,
743         uint amountBDesired,
744         uint amountAMin,
745         uint amountBMin,
746         address to,
747         uint deadline
748     ) external returns (uint amountA, uint amountB, uint liquidity);
749     function addLiquidityETH(
750         address token,
751         uint amountTokenDesired,
752         uint amountTokenMin,
753         uint amountETHMin,
754         address to,
755         uint deadline
756     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
757     function removeLiquidity(
758         address tokenA,
759         address tokenB,
760         uint liquidity,
761         uint amountAMin,
762         uint amountBMin,
763         address to,
764         uint deadline
765     ) external returns (uint amountA, uint amountB);
766     function removeLiquidityETH(
767         address token,
768         uint liquidity,
769         uint amountTokenMin,
770         uint amountETHMin,
771         address to,
772         uint deadline
773     ) external returns (uint amountToken, uint amountETH);
774     function removeLiquidityWithPermit(
775         address tokenA,
776         address tokenB,
777         uint liquidity,
778         uint amountAMin,
779         uint amountBMin,
780         address to,
781         uint deadline,
782         bool approveMax, uint8 v, bytes32 r, bytes32 s
783     ) external returns (uint amountA, uint amountB);
784     function removeLiquidityETHWithPermit(
785         address token,
786         uint liquidity,
787         uint amountTokenMin,
788         uint amountETHMin,
789         address to,
790         uint deadline,
791         bool approveMax, uint8 v, bytes32 r, bytes32 s
792     ) external returns (uint amountToken, uint amountETH);
793     function swapExactTokensForTokens(
794         uint amountIn,
795         uint amountOutMin,
796         address[] calldata path,
797         address to,
798         uint deadline
799     ) external returns (uint[] memory amounts);
800     function swapTokensForExactTokens(
801         uint amountOut,
802         uint amountInMax,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external returns (uint[] memory amounts);
807     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
808         external
809         payable
810         returns (uint[] memory amounts);
811     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
812         external
813         returns (uint[] memory amounts);
814     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
815         external
816         returns (uint[] memory amounts);
817     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
818         external
819         payable
820         returns (uint[] memory amounts);
821  
822     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
823     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
824     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
825     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
826     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
827 }
828  
829 interface IUniswapV2Router02 is IUniswapV2Router01 {
830     function removeLiquidityETHSupportingFeeOnTransferTokens(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline
837     ) external returns (uint amountETH);
838     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
839         address token,
840         uint liquidity,
841         uint amountTokenMin,
842         uint amountETHMin,
843         address to,
844         uint deadline,
845         bool approveMax, uint8 v, bytes32 r, bytes32 s
846     ) external returns (uint amountETH);
847  
848     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
849         uint amountIn,
850         uint amountOutMin,
851         address[] calldata path,
852         address to,
853         uint deadline
854     ) external;
855     function swapExactETHForTokensSupportingFeeOnTransferTokens(
856         uint amountOutMin,
857         address[] calldata path,
858         address to,
859         uint deadline
860     ) external payable;
861     function swapExactTokensForETHSupportingFeeOnTransferTokens(
862         uint amountIn,
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external;
868 }
869  
870 contract MemeBet is ERC20, Ownable {
871     using SafeMath for uint256;
872  
873     IUniswapV2Router02 public immutable uniswapV2Router;
874     address public immutable uniswapV2Pair;
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
888  
889      // Anti-bot and anti-whale mappings and variables
890     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
891  
892     // Seller Map
893     mapping (address => uint256) private _holderFirstBuyTimestamp;
894  
895     // Blacklist Map
896     mapping (address => bool) private _blacklist;
897     bool public transferDelayEnabled = true;
898  
899     uint256 public buyTotalFees;
900     uint256 public buyMarketingFee;
901     uint256 public buyLiquidityFee;
902     uint256 public buyDevFee;
903  
904     uint256 public sellTotalFees;
905     uint256 public sellMarketingFee;
906     uint256 public sellLiquidityFee;
907     uint256 public sellDevFee;
908  
909     uint256 public tokensForMarketing;
910     uint256 public tokensForLiquidity;
911     uint256 public tokensForDev;
912  
913     // block number of opened trading
914     uint256 launchedAt;
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
942     event AutoNukeLP();
943  
944     event ManualNukeLP();
945  
946     constructor() ERC20("Meme Bet", "MBET") {
947  
948         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
949  
950         excludeFromMaxTransaction(address(_uniswapV2Router), true);
951         uniswapV2Router = _uniswapV2Router;
952  
953         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
954         excludeFromMaxTransaction(address(uniswapV2Pair), true);
955         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
956  
957         uint256 _buyMarketingFee = 10;
958         uint256 _buyLiquidityFee = 0;
959         uint256 _buyDevFee = 0;
960  
961         uint256 _sellMarketingFee = 10;
962         uint256 _sellLiquidityFee = 0;
963         uint256 _sellDevFee = 0;
964  
965         uint256 totalSupply = 1 * 1e9 * 1e18;
966  
967         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
968         maxWallet = totalSupply * 20 / 1000; // 2% 
969         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
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
981         marketingWallet = address(owner()); // set as marketing wallet
982         devWallet = address(owner()); // set as dev wallet
983  
984         // exclude from paying fees or having max transaction amount
985         excludeFromFees(owner(), true);
986         excludeFromFees(address(this), true);
987         excludeFromFees(address(0xdead), true);
988  
989         excludeFromMaxTransaction(owner(), true);
990         excludeFromMaxTransaction(address(this), true);
991         excludeFromMaxTransaction(address(0xdead), true);
992  
993         /*
994             _mint is an internal function in ERC20.sol that is only called here,
995             and CANNOT be called ever again
996         */
997         _mint(msg.sender, totalSupply);
998     }
999  
1000     receive() external payable {
1001  
1002     }
1003  
1004     // once enabled, can never be turned off
1005     function enableTrading() external onlyOwner {
1006         tradingActive = true;
1007         swapEnabled = true;
1008         launchedAt = block.number;
1009     }
1010  
1011     // remove limits after token is stable
1012     function removeLimits() external onlyOwner returns (bool){
1013         limitsInEffect = false;
1014         return true;
1015     }
1016  
1017     // disable Transfer delay - cannot be reenabled
1018     function disableTransferDelay() external onlyOwner returns (bool){
1019         transferDelayEnabled = false;
1020         return true;
1021     }
1022  
1023      // change the minimum amount of tokens to sell from fees
1024     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1025         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1026         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1027         swapTokensAtAmount = newAmount;
1028         return true;
1029     }
1030  
1031     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1032         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1033         maxTransactionAmount = newNum * (10**18);
1034     }
1035  
1036     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1037         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1038         maxWallet = newNum * (10**18);
1039     }
1040  
1041     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1042         _isExcludedMaxTransactionAmount[updAds] = isEx;
1043     }
1044 
1045           function updateBuyFees(
1046         uint256 _devFee,
1047         uint256 _liquidityFee,
1048         uint256 _marketingFee
1049     ) external onlyOwner {
1050         buyDevFee = _devFee;
1051         buyLiquidityFee = _liquidityFee;
1052         buyMarketingFee = _marketingFee;
1053         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1054         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1055     }
1056 
1057     function updateSellFees(
1058         uint256 _devFee,
1059         uint256 _liquidityFee,
1060         uint256 _marketingFee
1061     ) external onlyOwner {
1062         sellDevFee = _devFee;
1063         sellLiquidityFee = _liquidityFee;
1064         sellMarketingFee = _marketingFee;
1065         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1066         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1067     }
1068  
1069     // only use to disable contract sales if absolutely necessary (emergency use only)
1070     function updateSwapEnabled(bool enabled) external onlyOwner(){
1071         swapEnabled = enabled;
1072     }
1073  
1074     function excludeFromFees(address account, bool excluded) public onlyOwner {
1075         _isExcludedFromFees[account] = excluded;
1076         emit ExcludeFromFees(account, excluded);
1077     }
1078  
1079     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1080         _blacklist[account] = isBlacklisted;
1081     }
1082  
1083     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1084         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1085  
1086         _setAutomatedMarketMakerPair(pair, value);
1087     }
1088  
1089     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1090         automatedMarketMakerPairs[pair] = value;
1091  
1092         emit SetAutomatedMarketMakerPair(pair, value);
1093     }
1094  
1095     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1096         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1097         marketingWallet = newMarketingWallet;
1098     }
1099  
1100     function updateDevWallet(address newWallet) external onlyOwner {
1101         emit devWalletUpdated(newWallet, devWallet);
1102         devWallet = newWallet;
1103     }
1104  
1105  
1106     function isExcludedFromFees(address account) public view returns(bool) {
1107         return _isExcludedFromFees[account];
1108     }
1109  
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 amount
1114     ) internal override {
1115         require(from != address(0), "ERC20: transfer from the zero address");
1116         require(to != address(0), "ERC20: transfer to the zero address");
1117         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1118          if(amount == 0) {
1119             super._transfer(from, to, 0);
1120             return;
1121         }
1122  
1123         if(limitsInEffect){
1124             if (
1125                 from != owner() &&
1126                 to != owner() &&
1127                 to != address(0) &&
1128                 to != address(0xdead) &&
1129                 !swapping
1130             ){
1131                 if(!tradingActive){
1132                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1133                 }
1134  
1135                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1136                 if (transferDelayEnabled){
1137                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1138                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1139                         _holderLastTransferTimestamp[tx.origin] = block.number;
1140                     }
1141                 }
1142  
1143                 //when buy
1144                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1145                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1146                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1147                 }
1148  
1149                 //when sell
1150                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1151                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1152                 }
1153                 else if(!_isExcludedMaxTransactionAmount[to]){
1154                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1155                 }
1156             }
1157         }
1158  
1159         uint256 contractTokenBalance = balanceOf(address(this));
1160  
1161         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1162  
1163         if( 
1164             canSwap &&
1165             swapEnabled &&
1166             !swapping &&
1167             !automatedMarketMakerPairs[from] &&
1168             !_isExcludedFromFees[from] &&
1169             !_isExcludedFromFees[to]
1170         ) {
1171             swapping = true;
1172  
1173             swapBack();
1174  
1175             swapping = false;
1176         }
1177  
1178         bool takeFee = !swapping;
1179  
1180         // if any account belongs to _isExcludedFromFee account then remove the fee
1181         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1182             takeFee = false;
1183         }
1184  
1185         uint256 fees = 0;
1186         // only take fees on buys/sells, do not take on wallet transfers
1187         if(takeFee){
1188             // on sell
1189             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1190                 fees = amount.mul(sellTotalFees).div(100);
1191                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1192                 tokensForDev += fees * sellDevFee / sellTotalFees;
1193                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1194             }
1195             // on buy
1196             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1197                 fees = amount.mul(buyTotalFees).div(100);
1198                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1199                 tokensForDev += fees * buyDevFee / buyTotalFees;
1200                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1201             }
1202  
1203             if(fees > 0){    
1204                 super._transfer(from, address(this), fees);
1205             }
1206  
1207             amount -= fees;
1208         }
1209  
1210         super._transfer(from, to, amount);
1211     }
1212  
1213     function swapTokensForEth(uint256 tokenAmount) private {
1214  
1215         // generate the uniswap pair path of token -> weth
1216         address[] memory path = new address[](2);
1217         path[0] = address(this);
1218         path[1] = uniswapV2Router.WETH();
1219  
1220         _approve(address(this), address(uniswapV2Router), tokenAmount);
1221  
1222         // make the swap
1223         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1224             tokenAmount,
1225             0, // accept any amount of ETH
1226             path,
1227             address(this),
1228             block.timestamp
1229         );
1230  
1231     }
1232  
1233     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1234         // approve token transfer to cover all possible scenarios
1235         _approve(address(this), address(uniswapV2Router), tokenAmount);
1236  
1237         // add the liquidity
1238         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1239             address(this),
1240             tokenAmount,
1241             0, // slippage is unavoidable
1242             0, // slippage is unavoidable
1243             address(this),
1244             block.timestamp
1245         );
1246     }
1247  
1248     function swapBack() private {
1249         uint256 contractBalance = balanceOf(address(this));
1250         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1251         bool success;
1252  
1253         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1254  
1255         if(contractBalance > swapTokensAtAmount * 20){
1256           contractBalance = swapTokensAtAmount * 20;
1257         }
1258  
1259         // Halve the amount of liquidity tokens
1260         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1261         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1262  
1263         uint256 initialETHBalance = address(this).balance;
1264  
1265         swapTokensForEth(amountToSwapForETH); 
1266  
1267         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1268  
1269         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1270         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1271         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1272  
1273  
1274         tokensForLiquidity = 0;
1275         tokensForMarketing = 0;
1276         tokensForDev = 0;
1277  
1278         (success,) = address(devWallet).call{value: ethForDev}("");
1279  
1280         if(liquidityTokens > 0 && ethForLiquidity > 0){
1281             addLiquidity(liquidityTokens, ethForLiquidity);
1282             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1283         }
1284  
1285         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1286     }
1287 }