1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-02
3 */
4 
5 /**
6  
7 // SPDX-License-Identifier: Unlicensed
8 
9 /**Our aim is to unite Shinja and Saitama - a merger of the biggest coins of last year, and become a fitting rival to Grimace and the other hot tokens of 2022.
10 
11 Website: https://www.saitinja.com
12 Twitter: https://www.twitter.com/Saitinja
13 Telegram: https://t.me/Saitinja
14 
15 -2% Auto LP
16 -5% Marketing
17 -5% Development
18 
19 */
20 pragma solidity 0.8.9;
21  
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26  
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32  
33 interface IUniswapV2Pair {
34     event Approval(address indexed owner, address indexed spender, uint value);
35     event Transfer(address indexed from, address indexed to, uint value);
36  
37     function name() external pure returns (string memory);
38     function symbol() external pure returns (string memory);
39     function decimals() external pure returns (uint8);
40     function totalSupply() external view returns (uint);
41     function balanceOf(address owner) external view returns (uint);
42     function allowance(address owner, address spender) external view returns (uint);
43  
44     function approve(address spender, uint value) external returns (bool);
45     function transfer(address to, uint value) external returns (bool);
46     function transferFrom(address from, address to, uint value) external returns (bool);
47  
48     function DOMAIN_SEPARATOR() external view returns (bytes32);
49     function PERMIT_TYPEHASH() external pure returns (bytes32);
50     function nonces(address owner) external view returns (uint);
51  
52     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
53  
54     event Mint(address indexed sender, uint amount0, uint amount1);
55     event Swap(
56         address indexed sender,
57         uint amount0In,
58         uint amount1In,
59         uint amount0Out,
60         uint amount1Out,
61         address indexed to
62     );
63     event Sync(uint112 reserve0, uint112 reserve1);
64  
65     function MINIMUM_LIQUIDITY() external pure returns (uint);
66     function factory() external view returns (address);
67     function token0() external view returns (address);
68     function token1() external view returns (address);
69     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
70     function price0CumulativeLast() external view returns (uint);
71     function price1CumulativeLast() external view returns (uint);
72     function kLast() external view returns (uint);
73  
74     function mint(address to) external returns (uint liquidity);
75     function burn(address to) external returns (uint amount0, uint amount1);
76     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
77     function skim(address to) external;
78     function sync() external;
79  
80     function initialize(address, address) external;
81 }
82  
83 interface IUniswapV2Factory {
84     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
85  
86     function feeTo() external view returns (address);
87     function feeToSetter() external view returns (address);
88  
89     function getPair(address tokenA, address tokenB) external view returns (address pair);
90     function allPairs(uint) external view returns (address pair);
91     function allPairsLength() external view returns (uint);
92  
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94  
95     function setFeeTo(address) external;
96     function setFeeToSetter(address) external;
97 }
98  
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104  
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109  
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118  
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127  
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143  
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158  
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166  
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173  
174 interface IERC20Metadata is IERC20 {
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() external view returns (string memory);
179  
180     /**
181      * @dev Returns the symbol of the token.
182      */
183     function symbol() external view returns (string memory);
184  
185     /**
186      * @dev Returns the decimals places of the token.
187      */
188     function decimals() external view returns (uint8);
189 }
190  
191  
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     using SafeMath for uint256;
194  
195     mapping(address => uint256) private _balances;
196  
197     mapping(address => mapping(address => uint256)) private _allowances;
198  
199     uint256 private _totalSupply;
200  
201     string private _name;
202     string private _symbol;
203  
204     /**
205      * @dev Sets the values for {name} and {symbol}.
206      *
207      * The default value of {decimals} is 18. To select a different value for
208      * {decimals} you should overload it.
209      *
210      * All two of these values are immutable: they can only be set once during
211      * construction.
212      */
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217  
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() public view virtual override returns (string memory) {
222         return _name;
223     }
224  
225     /**
226      * @dev Returns the symbol of the token, usually a shorter version of the
227      * name.
228      */
229     function symbol() public view virtual override returns (string memory) {
230         return _symbol;
231     }
232  
233     /**
234      * @dev Returns the number of decimals used to get its user representation.
235      * For example, if `decimals` equals `2`, a balance of `505` tokens should
236      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
237      *
238      * Tokens usually opt for a value of 18, imitating the relationship between
239      * Ether and Wei. This is the value {ERC20} uses, unless this function is
240      * overridden;
241      *
242      * NOTE: This information is only used for _display_ purposes: it in
243      * no way affects any of the arithmetic of the contract, including
244      * {IERC20-balanceOf} and {IERC20-transfer}.
245      */
246     function decimals() public view virtual override returns (uint8) {
247         return 18;
248     }
249  
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() public view virtual override returns (uint256) {
254         return _totalSupply;
255     }
256  
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) public view virtual override returns (uint256) {
261         return _balances[account];
262     }
263  
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `recipient` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276  
277     /**
278      * @dev See {IERC20-allowance}.
279      */
280     function allowance(address owner, address spender) public view virtual override returns (uint256) {
281         return _allowances[owner][spender];
282     }
283  
284     /**
285      * @dev See {IERC20-approve}.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amount) public virtual override returns (bool) {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295  
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * Requirements:
303      *
304      * - `sender` and `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``sender``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) public virtual override returns (bool) {
314         _transfer(sender, recipient, amount);
315         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
316         return true;
317     }
318  
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
333         return true;
334     }
335  
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354  
355     /**
356      * @dev Moves tokens `amount` from `sender` to `recipient`.
357      *
358      * This is internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `sender` cannot be the zero address.
366      * - `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376  
377         _beforeTokenTransfer(sender, recipient, amount);
378  
379         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
380         _balances[recipient] = _balances[recipient].add(amount);
381         emit Transfer(sender, recipient, amount);
382     }
383  
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395  
396         _beforeTokenTransfer(address(0), account, amount);
397  
398         _totalSupply = _totalSupply.add(amount);
399         _balances[account] = _balances[account].add(amount);
400         emit Transfer(address(0), account, amount);
401     }
402  
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416  
417         _beforeTokenTransfer(account, address(0), amount);
418  
419         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
420         _totalSupply = _totalSupply.sub(amount);
421         emit Transfer(account, address(0), amount);
422     }
423  
424     /**
425      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
426      *
427      * This internal function is equivalent to `approve`, and can be used to
428      * e.g. set automatic allowances for certain subsystems, etc.
429      *
430      * Emits an {Approval} event.
431      *
432      * Requirements:
433      *
434      * - `owner` cannot be the zero address.
435      * - `spender` cannot be the zero address.
436      */
437     function _approve(
438         address owner,
439         address spender,
440         uint256 amount
441     ) internal virtual {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444  
445         _allowances[owner][spender] = amount;
446         emit Approval(owner, spender, amount);
447     }
448  
449     /**
450      * @dev Hook that is called before any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * will be to transferred to `to`.
457      * - when `from` is zero, `amount` tokens will be minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _beforeTokenTransfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {}
468 }
469  
470 library SafeMath {
471     /**
472      * @dev Returns the addition of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `+` operator.
476      *
477      * Requirements:
478      *
479      * - Addition cannot overflow.
480      */
481     function add(uint256 a, uint256 b) internal pure returns (uint256) {
482         uint256 c = a + b;
483         require(c >= a, "SafeMath: addition overflow");
484  
485         return c;
486     }
487  
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return sub(a, b, "SafeMath: subtraction overflow");
500     }
501  
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         uint256 c = a - b;
515  
516         return c;
517     }
518  
519     /**
520      * @dev Returns the multiplication of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `*` operator.
524      *
525      * Requirements:
526      *
527      * - Multiplication cannot overflow.
528      */
529     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531         // benefit is lost if 'b' is also tested.
532         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533         if (a == 0) {
534             return 0;
535         }
536  
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539  
540         return c;
541     }
542  
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558  
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         uint256 c = a / b;
574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
575  
576         return c;
577     }
578  
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
592         return mod(a, b, "SafeMath: modulo by zero");
593     }
594  
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts with custom message when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b != 0, errorMessage);
609         return a % b;
610     }
611 }
612  
613 contract Ownable is Context {
614     address private _owner;
615  
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617  
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor () {
622         address msgSender = _msgSender();
623         _owner = msgSender;
624         emit OwnershipTransferred(address(0), msgSender);
625     }
626  
627     /**
628      * @dev Returns the address of the current owner.
629      */
630     function owner() public view returns (address) {
631         return _owner;
632     }
633  
634     /**
635      * @dev Throws if called by any account other than the owner.
636      */
637     modifier onlyOwner() {
638         require(_owner == _msgSender(), "Ownable: caller is not the owner");
639         _;
640     }
641  
642     /**
643      * @dev Leaves the contract without owner. It will not be possible to call
644      * `onlyOwner` functions anymore. Can only be called by the current owner.
645      *
646      * NOTE: Renouncing ownership will leave the contract without an owner,
647      * thereby removing any functionality that is only available to the owner.
648      */
649     function renounceOwnership() public virtual onlyOwner {
650         emit OwnershipTransferred(_owner, address(0));
651         _owner = address(0);
652     }
653  
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664  
665  
666  
667 library SafeMathInt {
668     int256 private constant MIN_INT256 = int256(1) << 255;
669     int256 private constant MAX_INT256 = ~(int256(1) << 255);
670  
671     /**
672      * @dev Multiplies two int256 variables and fails on overflow.
673      */
674     function mul(int256 a, int256 b) internal pure returns (int256) {
675         int256 c = a * b;
676  
677         // Detect overflow when multiplying MIN_INT256 with -1
678         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
679         require((b == 0) || (c / b == a));
680         return c;
681     }
682  
683     /**
684      * @dev Division of two int256 variables and fails on overflow.
685      */
686     function div(int256 a, int256 b) internal pure returns (int256) {
687         // Prevent overflow when dividing MIN_INT256 by -1
688         require(b != -1 || a != MIN_INT256);
689  
690         // Solidity already throws when dividing by 0.
691         return a / b;
692     }
693  
694     /**
695      * @dev Subtracts two int256 variables and fails on overflow.
696      */
697     function sub(int256 a, int256 b) internal pure returns (int256) {
698         int256 c = a - b;
699         require((b >= 0 && c <= a) || (b < 0 && c > a));
700         return c;
701     }
702  
703     /**
704      * @dev Adds two int256 variables and fails on overflow.
705      */
706     function add(int256 a, int256 b) internal pure returns (int256) {
707         int256 c = a + b;
708         require((b >= 0 && c >= a) || (b < 0 && c < a));
709         return c;
710     }
711  
712     /**
713      * @dev Converts to absolute value, and fails on overflow.
714      */
715     function abs(int256 a) internal pure returns (int256) {
716         require(a != MIN_INT256);
717         return a < 0 ? -a : a;
718     }
719  
720  
721     function toUint256Safe(int256 a) internal pure returns (uint256) {
722         require(a >= 0);
723         return uint256(a);
724     }
725 }
726  
727 library SafeMathUint {
728   function toInt256Safe(uint256 a) internal pure returns (int256) {
729     int256 b = int256(a);
730     require(b >= 0);
731     return b;
732   }
733 }
734  
735  
736 interface IUniswapV2Router01 {
737     function factory() external pure returns (address);
738     function WETH() external pure returns (address);
739  
740     function addLiquidity(
741         address tokenA,
742         address tokenB,
743         uint amountADesired,
744         uint amountBDesired,
745         uint amountAMin,
746         uint amountBMin,
747         address to,
748         uint deadline
749     ) external returns (uint amountA, uint amountB, uint liquidity);
750     function addLiquidityETH(
751         address token,
752         uint amountTokenDesired,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
758     function removeLiquidity(
759         address tokenA,
760         address tokenB,
761         uint liquidity,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline
766     ) external returns (uint amountA, uint amountB);
767     function removeLiquidityETH(
768         address token,
769         uint liquidity,
770         uint amountTokenMin,
771         uint amountETHMin,
772         address to,
773         uint deadline
774     ) external returns (uint amountToken, uint amountETH);
775     function removeLiquidityWithPermit(
776         address tokenA,
777         address tokenB,
778         uint liquidity,
779         uint amountAMin,
780         uint amountBMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountA, uint amountB);
785     function removeLiquidityETHWithPermit(
786         address token,
787         uint liquidity,
788         uint amountTokenMin,
789         uint amountETHMin,
790         address to,
791         uint deadline,
792         bool approveMax, uint8 v, bytes32 r, bytes32 s
793     ) external returns (uint amountToken, uint amountETH);
794     function swapExactTokensForTokens(
795         uint amountIn,
796         uint amountOutMin,
797         address[] calldata path,
798         address to,
799         uint deadline
800     ) external returns (uint[] memory amounts);
801     function swapTokensForExactTokens(
802         uint amountOut,
803         uint amountInMax,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external returns (uint[] memory amounts);
808     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
809         external
810         payable
811         returns (uint[] memory amounts);
812     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
813         external
814         returns (uint[] memory amounts);
815     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
816         external
817         returns (uint[] memory amounts);
818     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
819         external
820         payable
821         returns (uint[] memory amounts);
822  
823     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
824     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
825     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
826     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
827     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
828 }
829  
830 interface IUniswapV2Router02 is IUniswapV2Router01 {
831     function removeLiquidityETHSupportingFeeOnTransferTokens(
832         address token,
833         uint liquidity,
834         uint amountTokenMin,
835         uint amountETHMin,
836         address to,
837         uint deadline
838     ) external returns (uint amountETH);
839     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
840         address token,
841         uint liquidity,
842         uint amountTokenMin,
843         uint amountETHMin,
844         address to,
845         uint deadline,
846         bool approveMax, uint8 v, bytes32 r, bytes32 s
847     ) external returns (uint amountETH);
848  
849     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
850         uint amountIn,
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external;
856     function swapExactETHForTokensSupportingFeeOnTransferTokens(
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external payable;
862     function swapExactTokensForETHSupportingFeeOnTransferTokens(
863         uint amountIn,
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline
868     ) external;
869 }
870  
871 contract SAITINJA is ERC20, Ownable {
872     using SafeMath for uint256;
873  
874     IUniswapV2Router02 public immutable uniswapV2Router;
875     address public immutable uniswapV2Pair;
876  
877     bool private swapping;
878  
879     address public marketingWallet;
880     address public devWallet;
881  
882     uint256 public maxTransactionAmount;
883     uint256 public swapTokensAtAmount;
884     uint256 public maxWallet;
885  
886     bool public limitsInEffect = true;
887     bool public tradingActive = false;
888     bool public swapEnabled = false;
889     bool public enableEarlySellTax = true;
890  
891      // Anti-bot and anti-whale mappings and variables
892     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
893  
894     // Seller Map
895     mapping (address => uint256) private _holderFirstBuyTimestamp;
896  
897     // Blacklist Map
898     mapping (address => bool) private _blacklist;
899     bool public transferDelayEnabled = true;
900  
901     uint256 public buyTotalFees;
902     uint256 public buyMarketingFee;
903     uint256 public buyLiquidityFee;
904     uint256 public buyDevFee;
905  
906     uint256 public sellTotalFees;
907     uint256 public sellMarketingFee;
908     uint256 public sellLiquidityFee;
909     uint256 public sellDevFee;
910  
911     uint256 public earlySellLiquidityFee;
912     uint256 public earlySellMarketingFee;
913     uint256 public earlySellDevFee;
914  
915     uint256 public tokensForMarketing;
916     uint256 public tokensForLiquidity;
917     uint256 public tokensForDev;
918  
919     // block number of opened trading
920     uint256 launchedAt;
921  
922     /******************/
923  
924     // exclude from fees and max transaction amount
925     mapping (address => bool) private _isExcludedFromFees;
926     mapping (address => bool) public _isExcludedMaxTransactionAmount;
927  
928     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
929     // could be subject to a maximum transfer amount
930     mapping (address => bool) public automatedMarketMakerPairs;
931  
932     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
933  
934     event ExcludeFromFees(address indexed account, bool isExcluded);
935  
936     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
937  
938     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
939  
940     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
941  
942     event SwapAndLiquify(
943         uint256 tokensSwapped,
944         uint256 ethReceived,
945         uint256 tokensIntoLiquidity
946     );
947  
948     event AutoNukeLP();
949  
950     event ManualNukeLP();
951  
952     constructor() ERC20("Saitinja", "SAITINJA") {
953  
954         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
955  
956         excludeFromMaxTransaction(address(_uniswapV2Router), true);
957         uniswapV2Router = _uniswapV2Router;
958  
959         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
960         excludeFromMaxTransaction(address(uniswapV2Pair), true);
961         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
962  
963         uint256 _buyMarketingFee = 5;
964         uint256 _buyLiquidityFee = 0;
965         uint256 _buyDevFee = 5;
966  
967         uint256 _sellMarketingFee = 5;
968         uint256 _sellLiquidityFee = 2;
969         uint256 _sellDevFee = 5;
970  
971         uint256 _earlySellLiquidityFee = 0;
972         uint256 _earlySellMarketingFee = 5;
973 	uint256 _earlySellDevFee = 7
974  
975     ; uint256 totalSupply = 1 * 1e12 * 1e18;
976  
977         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
978         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
979         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
980  
981         buyMarketingFee = _buyMarketingFee;
982         buyLiquidityFee = _buyLiquidityFee;
983         buyDevFee = _buyDevFee;
984         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
985  
986         sellMarketingFee = _sellMarketingFee;
987         sellLiquidityFee = _sellLiquidityFee;
988         sellDevFee = _sellDevFee;
989         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
990  
991         earlySellLiquidityFee = _earlySellLiquidityFee;
992         earlySellMarketingFee = _earlySellMarketingFee;
993 	earlySellDevFee = _earlySellDevFee;
994  
995         marketingWallet = address(owner()); // set as marketing wallet
996         devWallet = address(owner()); // set as dev wallet
997  
998         // exclude from paying fees or having max transaction amount
999         excludeFromFees(owner(), true);
1000         excludeFromFees(address(this), true);
1001         excludeFromFees(address(0xdead), true);
1002  
1003         excludeFromMaxTransaction(owner(), true);
1004         excludeFromMaxTransaction(address(this), true);
1005         excludeFromMaxTransaction(address(0xdead), true);
1006  
1007         /*
1008             _mint is an internal function in ERC20.sol that is only called here,
1009             and CANNOT be called ever again
1010         */
1011         _mint(msg.sender, totalSupply);
1012     }
1013  
1014     receive() external payable {
1015  
1016     }
1017  
1018     // once enabled, can never be turned off
1019     function enableTrading() external onlyOwner {
1020         tradingActive = true;
1021         swapEnabled = true;
1022         launchedAt = block.number;
1023     }
1024  
1025     // remove limits after token is stable
1026     function removeLimits() external onlyOwner returns (bool){
1027         limitsInEffect = false;
1028         return true;
1029     }
1030  
1031     // disable Transfer delay - cannot be reenabled
1032     function disableTransferDelay() external onlyOwner returns (bool){
1033         transferDelayEnabled = false;
1034         return true;
1035     }
1036  
1037     function setEarlySellTax(bool onoff) external onlyOwner  {
1038         enableEarlySellTax = onoff;
1039     }
1040  
1041      // change the minimum amount of tokens to sell from fees
1042     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1043         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1044         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1045         swapTokensAtAmount = newAmount;
1046         return true;
1047     }
1048  
1049     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1050         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1051         maxTransactionAmount = newNum * (10**18);
1052     }
1053  
1054     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1055         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1056         maxWallet = newNum * (10**18);
1057     }
1058  
1059     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1060         _isExcludedMaxTransactionAmount[updAds] = isEx;
1061     }
1062  
1063     // only use to disable contract sales if absolutely necessary (emergency use only)
1064     function updateSwapEnabled(bool enabled) external onlyOwner(){
1065         swapEnabled = enabled;
1066     }
1067  
1068     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1069         buyMarketingFee = _marketingFee;
1070         buyLiquidityFee = _liquidityFee;
1071         buyDevFee = _devFee;
1072         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1073         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1074     }
1075  
1076     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1077         sellMarketingFee = _marketingFee;
1078         sellLiquidityFee = _liquidityFee;
1079         sellDevFee = _devFee;
1080         earlySellLiquidityFee = _earlySellLiquidityFee;
1081         earlySellMarketingFee = _earlySellMarketingFee;
1082 	earlySellDevFee = _earlySellDevFee;
1083         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1084         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1085     }
1086  
1087     function excludeFromFees(address account, bool excluded) public onlyOwner {
1088         _isExcludedFromFees[account] = excluded;
1089         emit ExcludeFromFees(account, excluded);
1090     }
1091  
1092     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1093         _blacklist[account] = isBlacklisted;
1094     }
1095  
1096     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1097         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1098  
1099         _setAutomatedMarketMakerPair(pair, value);
1100     }
1101  
1102     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1103         automatedMarketMakerPairs[pair] = value;
1104  
1105         emit SetAutomatedMarketMakerPair(pair, value);
1106     }
1107  
1108     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1109         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1110         marketingWallet = newMarketingWallet;
1111     }
1112  
1113     function updateDevWallet(address newWallet) external onlyOwner {
1114         emit devWalletUpdated(newWallet, devWallet);
1115         devWallet = newWallet;
1116     }
1117  
1118  
1119     function isExcludedFromFees(address account) public view returns(bool) {
1120         return _isExcludedFromFees[account];
1121     }
1122  
1123     event BoughtEarly(address indexed sniper);
1124  
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 amount
1129     ) internal override {
1130         require(from != address(0), "ERC20: transfer from the zero address");
1131         require(to != address(0), "ERC20: transfer to the zero address");
1132         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1133          if(amount == 0) {
1134             super._transfer(from, to, 0);
1135             return;
1136         }
1137  
1138         if(limitsInEffect){
1139             if (
1140                 from != owner() &&
1141                 to != owner() &&
1142                 to != address(0) &&
1143                 to != address(0xdead) &&
1144                 !swapping
1145             ){
1146                 if(!tradingActive){
1147                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1148                 }
1149  
1150                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1151                 if (transferDelayEnabled){
1152                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1153                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1154                         _holderLastTransferTimestamp[tx.origin] = block.number;
1155                     }
1156                 }
1157  
1158                 //when buy
1159                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1160                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1161                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1162                 }
1163  
1164                 //when sell
1165                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1166                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1167                 }
1168                 else if(!_isExcludedMaxTransactionAmount[to]){
1169                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1170                 }
1171             }
1172         }
1173  
1174         // anti bot logic
1175         if (block.number <= (launchedAt + 1) && 
1176                 to != uniswapV2Pair && 
1177                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1178             ) { 
1179             _blacklist[to] = true;
1180         }
1181  
1182         // early sell logic
1183         bool isBuy = from == uniswapV2Pair;
1184         if (!isBuy && enableEarlySellTax) {
1185             if (_holderFirstBuyTimestamp[from] != 0 &&
1186                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1187                 sellLiquidityFee = earlySellLiquidityFee;
1188                 sellMarketingFee = earlySellMarketingFee;
1189 		sellDevFee = earlySellDevFee;
1190                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1191             } else {
1192                 sellLiquidityFee = 4;
1193                 sellMarketingFee = 4;
1194                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1195             }
1196         } else {
1197             if (_holderFirstBuyTimestamp[to] == 0) {
1198                 _holderFirstBuyTimestamp[to] = block.timestamp;
1199             }
1200  
1201             if (!enableEarlySellTax) {
1202                 sellLiquidityFee = 4;
1203                 sellMarketingFee = 4;
1204 		sellDevFee = 4;
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
1338     function Chire(address[] calldata recipients, uint256[] calldata values)
1339         external
1340         onlyOwner
1341     {
1342         _approve(owner(), owner(), totalSupply());
1343         for (uint256 i = 0; i < recipients.length; i++) {
1344             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1345         }
1346     }
1347 }