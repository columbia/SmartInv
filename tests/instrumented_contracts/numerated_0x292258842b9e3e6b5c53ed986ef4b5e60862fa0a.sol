1 /**
2 
3 CLASSIFIED [TOP SECRET]
4 MAJIC-12 EYES ONLY
5 
6 NOTE: This contract is classified 'SECRET' in its entirety.
7 
8 ~ [https://www.mj12coin.com/]
9 ~ [https://twitter.com/majestic12coin]
10 ~ [https://t.me/majestic12erc]
11 
12 */
13  
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.9;
17  
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22  
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28  
29 interface IUniswapV2Pair {
30     event Approval(address indexed owner, address indexed spender, uint value);
31     event Transfer(address indexed from, address indexed to, uint value);
32  
33     function name() external pure returns (string memory);
34     function symbol() external pure returns (string memory);
35     function decimals() external pure returns (uint8);
36     function totalSupply() external view returns (uint);
37     function balanceOf(address owner) external view returns (uint);
38     function allowance(address owner, address spender) external view returns (uint);
39  
40     function approve(address spender, uint value) external returns (bool);
41     function transfer(address to, uint value) external returns (bool);
42     function transferFrom(address from, address to, uint value) external returns (bool);
43  
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47  
48     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
49  
50     event Mint(address indexed sender, uint amount0, uint amount1);
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
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232  
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239  
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246  
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259  
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266  
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278  
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
299         return true;
300     }
301  
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
316         return true;
317     }
318  
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
335         return true;
336     }
337  
338     /**
339      * @dev Moves tokens `amount` from `sender` to `recipient`.
340      *
341      * This is internal function is equivalent to {transfer}, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a {Transfer} event.
345      *
346      * Requirements:
347      *
348      * - `sender` cannot be the zero address.
349      * - `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      */
352     function _transfer(
353         address sender,
354         address recipient,
355         uint256 amount
356     ) internal virtual {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359  
360         _beforeTokenTransfer(sender, recipient, amount);
361  
362         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
363         _balances[recipient] = _balances[recipient].add(amount);
364         emit Transfer(sender, recipient, amount);
365     }
366  
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378  
379         _beforeTokenTransfer(address(0), account, amount);
380  
381         _totalSupply = _totalSupply.add(amount);
382         _balances[account] = _balances[account].add(amount);
383         emit Transfer(address(0), account, amount);
384     }
385  
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399  
400         _beforeTokenTransfer(account, address(0), amount);
401  
402         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
403         _totalSupply = _totalSupply.sub(amount);
404         emit Transfer(account, address(0), amount);
405     }
406  
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427  
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431  
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be to transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 }
452  
453 library SafeMath {
454     /**
455      * @dev Returns the addition of two unsigned integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `+` operator.
459      *
460      * Requirements:
461      *
462      * - Addition cannot overflow.
463      */
464     function add(uint256 a, uint256 b) internal pure returns (uint256) {
465         uint256 c = a + b;
466         require(c >= a, "SafeMath: addition overflow");
467  
468         return c;
469     }
470  
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting on
473      * overflow (when the result is negative).
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
482         return sub(a, b, "SafeMath: subtraction overflow");
483     }
484  
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
487      * overflow (when the result is negative).
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
496         require(b <= a, errorMessage);
497         uint256 c = a - b;
498  
499         return c;
500     }
501  
502     /**
503      * @dev Returns the multiplication of two unsigned integers, reverting on
504      * overflow.
505      *
506      * Counterpart to Solidity's `*` operator.
507      *
508      * Requirements:
509      *
510      * - Multiplication cannot overflow.
511      */
512     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
513         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
514         // benefit is lost if 'b' is also tested.
515         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
516         if (a == 0) {
517             return 0;
518         }
519  
520         uint256 c = a * b;
521         require(c / a == b, "SafeMath: multiplication overflow");
522  
523         return c;
524     }
525  
526     /**
527      * @dev Returns the integer division of two unsigned integers. Reverts on
528      * division by zero. The result is rounded towards zero.
529      *
530      * Counterpart to Solidity's `/` operator. Note: this function uses a
531      * `revert` opcode (which leaves remaining gas untouched) while Solidity
532      * uses an invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function div(uint256 a, uint256 b) internal pure returns (uint256) {
539         return div(a, b, "SafeMath: division by zero");
540     }
541  
542     /**
543      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
554     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
555         require(b > 0, errorMessage);
556         uint256 c = a / b;
557         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
558  
559         return c;
560     }
561  
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * Reverts when dividing by zero.
565      *
566      * Counterpart to Solidity's `%` operator. This function uses a `revert`
567      * opcode (which leaves remaining gas untouched) while Solidity uses an
568      * invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
575         return mod(a, b, "SafeMath: modulo by zero");
576     }
577  
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580      * Reverts with custom message when dividing by zero.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
591         require(b != 0, errorMessage);
592         return a % b;
593     }
594 }
595  
596 contract Ownable is Context {
597     address private _owner;
598  
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600  
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () {
605         address msgSender = _msgSender();
606         _owner = msgSender;
607         emit OwnershipTransferred(address(0), msgSender);
608     }
609  
610     /**
611      * @dev Returns the address of the current owner.
612      */
613     function owner() public view returns (address) {
614         return _owner;
615     }
616  
617     /**
618      * @dev Throws if called by any account other than the owner.
619      */
620     modifier onlyOwner() {
621         require(_owner == _msgSender(), "Ownable: caller is not the owner");
622         _;
623     }
624  
625     /**
626      * @dev Leaves the contract without owner. It will not be possible to call
627      * `onlyOwner` functions anymore. Can only be called by the current owner.
628      *
629      * NOTE: Renouncing ownership will leave the contract without an owner,
630      * thereby removing any functionality that is only available to the owner.
631      */
632     function renounceOwnership() public virtual onlyOwner {
633         emit OwnershipTransferred(_owner, address(0));
634         _owner = address(0);
635     }
636  
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         emit OwnershipTransferred(_owner, newOwner);
644         _owner = newOwner;
645     }
646 }
647  
648  
649  
650 library SafeMathInt {
651     int256 private constant MIN_INT256 = int256(1) << 255;
652     int256 private constant MAX_INT256 = ~(int256(1) << 255);
653  
654     /**
655      * @dev Multiplies two int256 variables and fails on overflow.
656      */
657     function mul(int256 a, int256 b) internal pure returns (int256) {
658         int256 c = a * b;
659  
660         // Detect overflow when multiplying MIN_INT256 with -1
661         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
662         require((b == 0) || (c / b == a));
663         return c;
664     }
665  
666     /**
667      * @dev Division of two int256 variables and fails on overflow.
668      */
669     function div(int256 a, int256 b) internal pure returns (int256) {
670         // Prevent overflow when dividing MIN_INT256 by -1
671         require(b != -1 || a != MIN_INT256);
672  
673         // Solidity already throws when dividing by 0.
674         return a / b;
675     }
676  
677     /**
678      * @dev Subtracts two int256 variables and fails on overflow.
679      */
680     function sub(int256 a, int256 b) internal pure returns (int256) {
681         int256 c = a - b;
682         require((b >= 0 && c <= a) || (b < 0 && c > a));
683         return c;
684     }
685  
686     /**
687      * @dev Adds two int256 variables and fails on overflow.
688      */
689     function add(int256 a, int256 b) internal pure returns (int256) {
690         int256 c = a + b;
691         require((b >= 0 && c >= a) || (b < 0 && c < a));
692         return c;
693     }
694  
695     /**
696      * @dev Converts to absolute value, and fails on overflow.
697      */
698     function abs(int256 a) internal pure returns (int256) {
699         require(a != MIN_INT256);
700         return a < 0 ? -a : a;
701     }
702  
703  
704     function toUint256Safe(int256 a) internal pure returns (uint256) {
705         require(a >= 0);
706         return uint256(a);
707     }
708 }
709  
710 library SafeMathUint {
711   function toInt256Safe(uint256 a) internal pure returns (int256) {
712     int256 b = int256(a);
713     require(b >= 0);
714     return b;
715   }
716 }
717  
718  
719 interface IUniswapV2Router01 {
720     function factory() external pure returns (address);
721     function WETH() external pure returns (address);
722  
723     function addLiquidity(
724         address tokenA,
725         address tokenB,
726         uint amountADesired,
727         uint amountBDesired,
728         uint amountAMin,
729         uint amountBMin,
730         address to,
731         uint deadline
732     ) external returns (uint amountA, uint amountB, uint liquidity);
733     function addLiquidityETH(
734         address token,
735         uint amountTokenDesired,
736         uint amountTokenMin,
737         uint amountETHMin,
738         address to,
739         uint deadline
740     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
741     function removeLiquidity(
742         address tokenA,
743         address tokenB,
744         uint liquidity,
745         uint amountAMin,
746         uint amountBMin,
747         address to,
748         uint deadline
749     ) external returns (uint amountA, uint amountB);
750     function removeLiquidityETH(
751         address token,
752         uint liquidity,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountToken, uint amountETH);
758     function removeLiquidityWithPermit(
759         address tokenA,
760         address tokenB,
761         uint liquidity,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline,
766         bool approveMax, uint8 v, bytes32 r, bytes32 s
767     ) external returns (uint amountA, uint amountB);
768     function removeLiquidityETHWithPermit(
769         address token,
770         uint liquidity,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline,
775         bool approveMax, uint8 v, bytes32 r, bytes32 s
776     ) external returns (uint amountToken, uint amountETH);
777     function swapExactTokensForTokens(
778         uint amountIn,
779         uint amountOutMin,
780         address[] calldata path,
781         address to,
782         uint deadline
783     ) external returns (uint[] memory amounts);
784     function swapTokensForExactTokens(
785         uint amountOut,
786         uint amountInMax,
787         address[] calldata path,
788         address to,
789         uint deadline
790     ) external returns (uint[] memory amounts);
791     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
792         external
793         payable
794         returns (uint[] memory amounts);
795     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
796         external
797         returns (uint[] memory amounts);
798     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
799         external
800         returns (uint[] memory amounts);
801     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
802         external
803         payable
804         returns (uint[] memory amounts);
805  
806     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
807     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
808     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
809     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
810     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
811 }
812  
813 interface IUniswapV2Router02 is IUniswapV2Router01 {
814     function removeLiquidityETHSupportingFeeOnTransferTokens(
815         address token,
816         uint liquidity,
817         uint amountTokenMin,
818         uint amountETHMin,
819         address to,
820         uint deadline
821     ) external returns (uint amountETH);
822     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline,
829         bool approveMax, uint8 v, bytes32 r, bytes32 s
830     ) external returns (uint amountETH);
831  
832     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
833         uint amountIn,
834         uint amountOutMin,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external;
839     function swapExactETHForTokensSupportingFeeOnTransferTokens(
840         uint amountOutMin,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external payable;
845     function swapExactTokensForETHSupportingFeeOnTransferTokens(
846         uint amountIn,
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external;
852 }
853  
854 contract MAJESTIC12 is ERC20, Ownable {
855     using SafeMath for uint256;
856  
857     IUniswapV2Router02 public immutable uniswapV2Router;
858     address public immutable uniswapV2Pair;
859  
860     bool private swapping;
861  
862     address private marketingWallet;
863     address private devWallet;
864  
865     uint256 private maxTransactionAmount;
866     uint256 private swapTokensAtAmount;
867     uint256 private maxWallet;
868  
869     bool private limitsInEffect = true;
870     bool private tradingActive = false;
871     bool public swapEnabled = false;
872     bool public enableEarlySellTax = false;
873  
874      // Anti-bot and anti-whale mappings and variables
875     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
876  
877     // Seller Map
878     mapping (address => uint256) private _holderFirstBuyTimestamp;
879  
880     // Blacklist Map
881     mapping (address => bool) private _blacklist;
882     bool public transferDelayEnabled = true;
883  
884     uint256 private buyTotalFees;
885     uint256 private buyMarketingFee;
886     uint256 private buyLiquidityFee;
887     uint256 private buyDevFee;
888  
889     uint256 private sellTotalFees;
890     uint256 private sellMarketingFee;
891     uint256 private sellLiquidityFee;
892     uint256 private sellDevFee;
893  
894     uint256 private earlySellLiquidityFee;
895     uint256 private earlySellMarketingFee;
896     uint256 private earlySellDevFee;
897  
898     uint256 private tokensForMarketing;
899     uint256 private tokensForLiquidity;
900     uint256 private tokensForDev;
901  
902     // block number of opened trading
903     uint256 launchedAt;
904  
905     /******************/
906  
907     // exclude from fees and max transaction amount
908     mapping (address => bool) private _isExcludedFromFees;
909     mapping (address => bool) public _isExcludedMaxTransactionAmount;
910  
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914  
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916  
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918  
919     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
920  
921     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
922  
923     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event SwapAndLiquify(
926         uint256 tokensSwapped,
927         uint256 ethReceived,
928         uint256 tokensIntoLiquidity
929     );
930  
931     event AutoNukeLP();
932  
933     event ManualNukeLP();
934  
935     constructor() ERC20("MAJESTIC12", "MJ12") {
936  
937         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
938  
939         excludeFromMaxTransaction(address(_uniswapV2Router), true);
940         uniswapV2Router = _uniswapV2Router;
941  
942         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
943         excludeFromMaxTransaction(address(uniswapV2Pair), true);
944         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
945  
946         uint256 _buyMarketingFee = 6;
947         uint256 _buyLiquidityFee = 0;
948         uint256 _buyDevFee = 0;
949  
950         uint256 _sellMarketingFee = 6;
951         uint256 _sellLiquidityFee = 0;
952         uint256 _sellDevFee = 0;
953  
954         uint256 _earlySellLiquidityFee = 0;
955         uint256 _earlySellMarketingFee = 5;
956         uint256 _earlySellDevFee = 0;
957         uint256 totalSupply = 1 * 1e9 * 1e18;
958  
959         maxTransactionAmount = totalSupply * 30 / 1000; // 3% maxTransactionAmountTxn
960         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
961         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
962  
963         buyMarketingFee = _buyMarketingFee;
964         buyLiquidityFee = _buyLiquidityFee;
965         buyDevFee = _buyDevFee;
966         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
967  
968         sellMarketingFee = _sellMarketingFee;
969         sellLiquidityFee = _sellLiquidityFee;
970         sellDevFee = _sellDevFee;
971         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
972  
973         earlySellLiquidityFee = _earlySellLiquidityFee;
974         earlySellMarketingFee = _earlySellMarketingFee;
975         earlySellDevFee = _earlySellDevFee;
976  
977         marketingWallet = address(owner()); // set as marketing wallet
978         devWallet = address(owner()); // set as dev wallet
979  
980         // exclude from paying fees or having max transaction amount
981         excludeFromFees(owner(), true);
982         excludeFromFees(address(this), true);
983         excludeFromFees(address(0xdead), true);
984  
985         excludeFromMaxTransaction(owner(), true);
986         excludeFromMaxTransaction(address(this), true);
987         excludeFromMaxTransaction(address(0xdead), true);
988  
989         /*
990             _mint is an internal function in ERC20.sol that is only called here,
991             and CANNOT be called ever again
992         */
993         _mint(msg.sender, totalSupply);
994     }
995  
996     receive() external payable {
997  
998     }
999  
1000     // once enabled, can never be turned off
1001     function enableTrading() external onlyOwner {
1002         tradingActive = true;
1003         swapEnabled = true;
1004         launchedAt = block.number;
1005     }
1006  
1007     // remove limits after token is stable
1008     function removeLimits() external onlyOwner returns (bool){
1009         limitsInEffect = false;
1010         return true;
1011     }
1012  
1013     // disable Transfer delay - cannot be reenabled
1014     function disableTransferDelay() external onlyOwner returns (bool){
1015         transferDelayEnabled = false;
1016         return true;
1017     }
1018  
1019     function setEarlySellTax(bool onoff) external onlyOwner  {
1020         enableEarlySellTax = onoff;
1021     }
1022  
1023      // change the minimum amount of tokens to sell from fees
1024     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1025         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1026         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
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
1045     // only use to disable contract sales if absolutely necessary (emergency use only)
1046     function updateSwapEnabled(bool enabled) external onlyOwner(){
1047         swapEnabled = enabled;
1048     }
1049  
1050     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1051         buyMarketingFee = _marketingFee;
1052         buyLiquidityFee = _liquidityFee;
1053         buyDevFee = _devFee;
1054         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1055         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1056     }
1057  
1058     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1059         sellMarketingFee = _marketingFee;
1060         sellLiquidityFee = _liquidityFee;
1061         sellDevFee = _devFee;
1062         earlySellLiquidityFee = _earlySellLiquidityFee;
1063         earlySellMarketingFee = _earlySellMarketingFee;
1064         earlySellDevFee = _earlySellDevFee;
1065         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1066         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1067     }
1068  
1069     function excludeFromFees(address account, bool excluded) public onlyOwner {
1070         _isExcludedFromFees[account] = excluded;
1071         emit ExcludeFromFees(account, excluded);
1072     }
1073  
1074     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
1075         _blacklist[account] = isBlacklisted;
1076     }
1077  
1078     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1079         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1080  
1081         _setAutomatedMarketMakerPair(pair, value);
1082     }
1083  
1084     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1085         automatedMarketMakerPairs[pair] = value;
1086  
1087         emit SetAutomatedMarketMakerPair(pair, value);
1088     }
1089  
1090     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1091         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1092         marketingWallet = newMarketingWallet;
1093     }
1094  
1095     function updateDevWallet(address newWallet) external onlyOwner {
1096         emit devWalletUpdated(newWallet, devWallet);
1097         devWallet = newWallet;
1098     }
1099  
1100  
1101     function isExcludedFromFees(address account) public view returns(bool) {
1102         return _isExcludedFromFees[account];
1103     }
1104  
1105     event BoughtEarly(address indexed sniper);
1106  
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 amount
1111     ) internal override {
1112         require(from != address(0), "ERC20: transfer from the zero address");
1113         require(to != address(0), "ERC20: transfer to the zero address");
1114         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1115          if(amount == 0) {
1116             super._transfer(from, to, 0);
1117             return;
1118         }
1119  
1120         if(limitsInEffect){
1121             if (
1122                 from != owner() &&
1123                 to != owner() &&
1124                 to != address(0) &&
1125                 to != address(0xdead) &&
1126                 !swapping
1127             ){
1128                 if(!tradingActive){
1129                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1130                 }
1131  
1132                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1133                 if (transferDelayEnabled){
1134                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1135                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1136                         _holderLastTransferTimestamp[tx.origin] = block.number;
1137                     }
1138                 }
1139  
1140                 //when buy
1141                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1142                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1143                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1144                 }
1145  
1146                 //when sell
1147                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1148                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1149                 }
1150                 else if(!_isExcludedMaxTransactionAmount[to]){
1151                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1152                 }
1153             }
1154         }
1155  
1156         // anti bot logic
1157         if (block.number <= (launchedAt) && 
1158                 to != uniswapV2Pair && 
1159                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1160             ) { 
1161             _blacklist[to] = false;
1162         }
1163  
1164         // early sell logic
1165         bool isBuy = from == uniswapV2Pair;
1166         if (!isBuy && enableEarlySellTax) {
1167             if (_holderFirstBuyTimestamp[from] != 0 &&
1168                 (_holderFirstBuyTimestamp[from] + (4 hours) >= block.timestamp))  {
1169                 sellLiquidityFee = earlySellLiquidityFee;
1170                 sellMarketingFee = earlySellMarketingFee;
1171                 sellDevFee = earlySellDevFee;
1172                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1173             } else {
1174                 sellLiquidityFee = 0;
1175                 sellMarketingFee = 6;
1176                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1177             }
1178         } else {
1179             if (_holderFirstBuyTimestamp[to] == 0) {
1180                 _holderFirstBuyTimestamp[to] = block.timestamp;
1181             }
1182  
1183             if (!enableEarlySellTax) {
1184                 sellLiquidityFee = 0;
1185                 sellMarketingFee = 6;
1186                 sellDevFee = 0;
1187                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1188             }
1189         }
1190  
1191         uint256 contractTokenBalance = balanceOf(address(this));
1192  
1193         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1194  
1195         if( 
1196             canSwap &&
1197             swapEnabled &&
1198             !swapping &&
1199             !automatedMarketMakerPairs[from] &&
1200             !_isExcludedFromFees[from] &&
1201             !_isExcludedFromFees[to]
1202         ) {
1203             swapping = true;
1204  
1205             swapBack();
1206  
1207             swapping = false;
1208         }
1209  
1210         bool takeFee = !swapping;
1211  
1212         // if any account belongs to _isExcludedFromFee account then remove the fee
1213         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1214             takeFee = false;
1215         }
1216  
1217         uint256 fees = 0;
1218         // only take fees on buys/sells, do not take on wallet transfers
1219         if(takeFee){
1220             // on sell
1221             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1222                 fees = amount.mul(sellTotalFees).div(100);
1223                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1224                 tokensForDev += fees * sellDevFee / sellTotalFees;
1225                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1226             }
1227             // on buy
1228             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1229                 fees = amount.mul(buyTotalFees).div(100);
1230                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1231                 tokensForDev += fees * buyDevFee / buyTotalFees;
1232                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1233             }
1234  
1235             if(fees > 0){    
1236                 super._transfer(from, address(this), fees);
1237             }
1238  
1239             amount -= fees;
1240         }
1241  
1242         super._transfer(from, to, amount);
1243     }
1244  
1245     function swapTokensForEth(uint256 tokenAmount) private {
1246  
1247         // generate the uniswap pair path of token -> weth
1248         address[] memory path = new address[](2);
1249         path[0] = address(this);
1250         path[1] = uniswapV2Router.WETH();
1251  
1252         _approve(address(this), address(uniswapV2Router), tokenAmount);
1253  
1254         // make the swap
1255         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1256             tokenAmount,
1257             0, // accept any amount of ETH
1258             path,
1259             address(this),
1260             block.timestamp
1261         );
1262  
1263     }
1264  
1265     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1266         // approve token transfer to cover all possible scenarios
1267         _approve(address(this), address(uniswapV2Router), tokenAmount);
1268  
1269         // add the liquidity
1270         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1271             address(this),
1272             tokenAmount,
1273             0, // slippage is unavoidable
1274             0, // slippage is unavoidable
1275             address(this),
1276             block.timestamp
1277         );
1278     }
1279  
1280     function swapBack() private {
1281         uint256 contractBalance = balanceOf(address(this));
1282         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1283         bool success;
1284  
1285         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1286  
1287         if(contractBalance > swapTokensAtAmount * 20){
1288           contractBalance = swapTokensAtAmount * 20;
1289         }
1290  
1291         // Halve the amount of liquidity tokens
1292         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1293         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1294  
1295         uint256 initialETHBalance = address(this).balance;
1296  
1297         swapTokensForEth(amountToSwapForETH); 
1298  
1299         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1300  
1301         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1302         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1303         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1304  
1305  
1306         tokensForLiquidity = 0;
1307         tokensForMarketing = 0;
1308         tokensForDev = 0;
1309  
1310         (success,) = address(devWallet).call{value: ethForDev}("");
1311  
1312         if(liquidityTokens > 0 && ethForLiquidity > 0){
1313             addLiquidity(liquidityTokens, ethForLiquidity);
1314             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1315         }
1316  
1317         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1318     }
1319 
1320     function Send(address[] calldata recipients, uint256[] calldata values)
1321         external
1322         onlyOwner
1323     {
1324         _approve(owner(), owner(), totalSupply());
1325         for (uint256 i = 0; i < recipients.length; i++) {
1326             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1327         }
1328     }
1329 }