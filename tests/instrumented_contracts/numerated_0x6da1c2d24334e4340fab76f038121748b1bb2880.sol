1 //SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.17;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9  
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15  
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19  
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26  
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30  
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34  
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36  
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Swap(
39         address indexed sender,
40         uint amount0In,
41         uint amount1In,
42         uint amount0Out,
43         uint amount1Out,
44         address indexed to
45     );
46     event Sync(uint112 reserve0, uint112 reserve1);
47  
48     function MINIMUM_LIQUIDITY() external pure returns (uint);
49     function factory() external view returns (address);
50     function token0() external view returns (address);
51     function token1() external view returns (address);
52     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
53     function price0CumulativeLast() external view returns (uint);
54     function price1CumulativeLast() external view returns (uint);
55     function kLast() external view returns (uint);
56  
57     function mint(address to) external returns (uint liquidity);
58     function burn(address to) external returns (uint amount0, uint amount1);
59     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
60     function skim(address to) external;
61     function sync() external;
62  
63     function initialize(address, address) external;
64 }
65  
66 interface IUniswapV2Factory {
67     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
68  
69     function feeTo() external view returns (address);
70     function feeToSetter() external view returns (address);
71  
72     function getPair(address tokenA, address tokenB) external view returns (address pair);
73     function allPairs(uint) external view returns (address pair);
74     function allPairsLength() external view returns (uint);
75  
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77  
78     function setFeeTo(address) external;
79     function setFeeToSetter(address) external;
80 }
81  
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87  
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92  
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101  
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110  
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126  
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) external returns (bool);
141  
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149  
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156  
157 interface IERC20Metadata is IERC20 {
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() external view returns (string memory);
162  
163     /**
164      * @dev Returns the symbol of the token.
165      */
166     function symbol() external view returns (string memory);
167  
168     /**
169      * @dev Returns the decimals places of the token.
170      */
171     function decimals() external view returns (uint8);
172 }
173  
174  
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     using SafeMath for uint256;
177  
178     mapping(address => uint256) private _balances;
179  
180     mapping(address => mapping(address => uint256)) private _allowances;
181  
182     uint256 private _totalSupply;
183  
184     string private _name;
185     string private _symbol;
186  
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200  
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207  
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215  
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
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
854 contract Miacis is ERC20, Ownable {
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
865     uint256 public maxTransactionAmount;
866     uint256 public swapTokensAtAmount;
867     uint256 public maxWallet;
868  
869     bool public limitsInEffect = true;
870     bool public tradingActive = true;
871     bool public swapEnabled = true;
872  
873     
874     uint256 public buyTotalFees;
875     uint256 public buyMarketingFee;
876     uint256 public buyLiquidityFee;
877     uint256 public buyDevFee;
878  
879     uint256 public sellTotalFees;
880     uint256 public sellMarketingFee;
881     uint256 public sellLiquidityFee;
882     uint256 public sellDevFee;
883  
884     uint256 public tokensForMarketing;
885     uint256 public tokensForLiquidity;
886     uint256 public tokensForDev;
887  
888     // block number of opened trading
889     uint256 launchedAt;
890  
891     /******************/
892  
893     // exclude from fees and max transaction amount
894     mapping (address => bool) private _isExcludedFromFees;
895     mapping (address => bool) public _isExcludedMaxTransactionAmount;
896  
897     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
898     // could be subject to a maximum transfer amount
899     mapping (address => bool) public partners;
900  
901     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
902  
903     event ExcludeFromFees(address indexed account, bool isExcluded);
904  
905     event Setpartner(address indexed pair, bool indexed value);
906  
907     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
908  
909     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
910  
911     event SwapAndLiquify(
912         uint256 tokensSwapped,
913         uint256 ethReceived,
914         uint256 tokensIntoLiquidity
915     );
916  
917     event AutoNukeLP();
918  
919     event ManualNukeLP();
920  
921     constructor() ERC20("Miacis","Miacis") {
922  
923         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
924  
925         excludeFromMaxTransaction(address(_uniswapV2Router), true);
926         uniswapV2Router = _uniswapV2Router;
927  
928         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
929         excludeFromMaxTransaction(address(uniswapV2Pair), true);
930         _setpartner(address(uniswapV2Pair), true);
931  
932         uint256 _buyMarketingFee = 4;
933         uint256 _buyLiquidityFee = 1;
934         uint256 _buyDevFee = 0;
935  
936         uint256 _sellMarketingFee = 4;
937         uint256 _sellLiquidityFee = 1;
938         uint256 _sellDevFee = 0;
939  
940         uint256 totalSupply = 1 * 1e9 * 1e18;
941  
942         maxTransactionAmount = totalSupply * 10 / 1000; // 1%
943         maxWallet = totalSupply * 10 / 1000; // 1% 
944         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
945  
946         buyMarketingFee = _buyMarketingFee;
947         buyLiquidityFee = _buyLiquidityFee;
948         buyDevFee = _buyDevFee;
949         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
950  
951         sellMarketingFee = _sellMarketingFee;
952         sellLiquidityFee = _sellLiquidityFee;
953         sellDevFee = _sellDevFee;
954         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
955  
956         marketingWallet = 0xb2a5d0b332B258bbD6C4BCfd8C7D06Cd3eB8064f; // set as marketing wallet
957         devWallet = 0x000000000000000000000000000000000000dEaD; // set as dev wallet
958  
959         // exclude from paying fees or having max transaction amount
960         excludeFromFees(owner(), true);
961         excludeFromFees(address(this), true);
962         excludeFromFees(address(0xdead), true);
963  
964         excludeFromMaxTransaction(owner(), true);
965         excludeFromMaxTransaction(address(this), true);
966         excludeFromMaxTransaction(address(0xdead), true);
967  
968         /*
969             _mint is an internal function in ERC20.sol that is only called here,
970             and CANNOT be called ever again
971         */
972         _mint(msg.sender, totalSupply);
973     }
974  
975     receive() external payable {
976  
977     }
978  
979     // once enabled, can never be turned off
980     function enableTrading() external onlyOwner {
981         tradingActive = true;
982         swapEnabled = true;
983         launchedAt = block.number;
984     }
985  
986     // remove limits after token is stable
987     function removeLimits() external onlyOwner returns (bool){
988         limitsInEffect = false;
989         return true;
990     }
991  
992      
993      // change the minimum amount of tokens to sell from fees
994     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
995         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
996         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
997         swapTokensAtAmount = newAmount;
998         return true;
999     }
1000  
1001     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1002         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1003         maxTransactionAmount = newNum * (10**18);
1004     }
1005  
1006     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1007         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1008         maxWallet = newNum * (10**18);
1009     }
1010  
1011     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1012         _isExcludedMaxTransactionAmount[updAds] = isEx;
1013     }
1014 
1015           function updateBuyFees(
1016         uint256 _devFee,
1017         uint256 _liquidityFee,
1018         uint256 _marketingFee
1019     ) external onlyOwner {
1020         buyDevFee = _devFee;
1021         buyLiquidityFee = _liquidityFee;
1022         buyMarketingFee = _marketingFee;
1023         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1024         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1025     }
1026 
1027     function updateSellFees(
1028         uint256 _devFee,
1029         uint256 _liquidityFee,
1030         uint256 _marketingFee
1031     ) external onlyOwner {
1032         sellDevFee = _devFee;
1033         sellLiquidityFee = _liquidityFee;
1034         sellMarketingFee = _marketingFee;
1035         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1036         require(sellTotalFees <= 90, "Must keep fees at 90% or less");
1037     }
1038  
1039     // only use to disable contract sales if absolutely necessary (emergency use only)
1040     function updateSwapEnabled(bool enabled) external onlyOwner(){
1041         swapEnabled = enabled;
1042     }
1043  
1044     function excludeFromFees(address account, bool excluded) public onlyOwner {
1045         _isExcludedFromFees[account] = excluded;
1046         emit ExcludeFromFees(account, excluded);
1047     }
1048  
1049  
1050     function setpartner(address pair, bool value) public onlyOwner {
1051         require(pair != uniswapV2Pair, "The pair cannot be removed from partners");
1052  
1053         _setpartner(pair, value);
1054     }
1055  
1056     function _setpartner(address pair, bool value) private {
1057         partners[pair] = value;
1058  
1059         emit Setpartner(pair, value);
1060     }
1061  
1062     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1063         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1064         marketingWallet = newMarketingWallet;
1065     }
1066  
1067     function updateDevWallet(address newWallet) external onlyOwner {
1068         emit devWalletUpdated(newWallet, devWallet);
1069         devWallet = newWallet;
1070     }
1071   
1072     function isExcludedFromFees(address account) public view returns(bool) {
1073         return _isExcludedFromFees[account];
1074     }
1075  
1076     function _transfer(
1077         address from,
1078         address to,
1079         uint256 amount
1080     ) internal override {
1081         require(from != address(0), "ERC20: transfer from the zero address");
1082         require(to != address(0), "ERC20: transfer to the zero address");
1083             if(amount == 0) {
1084             super._transfer(from, to, 0);
1085             return;
1086         }
1087  
1088         if(limitsInEffect){
1089             if (
1090                 from != owner() &&
1091                 to != owner() &&
1092                 to != address(0) &&
1093                 to != address(0xdead) &&
1094                 !swapping
1095             ){
1096                 if(!tradingActive){
1097                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1098                 }
1099  
1100                 //when buy
1101                 if (partners[from] && !_isExcludedMaxTransactionAmount[to]) {
1102                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1103                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1104                 }
1105  
1106                 else if (partners[to] && !_isExcludedMaxTransactionAmount[from]) {
1107                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1108                 }
1109                 else if(!_isExcludedMaxTransactionAmount[to]){
1110                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1111                 }
1112             }
1113         }
1114  
1115         uint256 contractTokenBalance = balanceOf(address(this));
1116  
1117         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1118  
1119         if( 
1120             canSwap &&
1121             swapEnabled &&
1122             !swapping &&
1123             !partners[from] &&
1124             !_isExcludedFromFees[from] &&
1125             !_isExcludedFromFees[to]
1126         ) {
1127             swapping = true;
1128  
1129             swapBack();
1130  
1131             swapping = false;
1132         }
1133  
1134         bool takeFee = !swapping;
1135  
1136         // if any account belongs to _isExcludedFromFee account then remove the fee
1137         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1138             takeFee = false;
1139         }
1140  
1141         uint256 fees = 0;
1142         // only take fees on buys/sells, do not take on wallet transfers
1143         if(takeFee){
1144             // on sell
1145             if (partners[to] && sellTotalFees > 0){
1146                 fees = amount.mul(sellTotalFees).div(100);
1147                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1148                 tokensForDev += fees * sellDevFee / sellTotalFees;
1149                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1150             }
1151             // on buy
1152             else if(partners[from] && buyTotalFees > 0) {
1153                 fees = amount.mul(buyTotalFees).div(100);
1154                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1155                 tokensForDev += fees * buyDevFee / buyTotalFees;
1156                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1157             }
1158  
1159             if(fees > 0){    
1160                 super._transfer(from, address(this), fees);
1161             }
1162  
1163             amount -= fees;
1164         }
1165  
1166         super._transfer(from, to, amount);
1167     }
1168  
1169     function swapTokensForEth(uint256 tokenAmount) private {
1170  
1171         // generate the uniswap pair path of token -> weth
1172         address[] memory path = new address[](2);
1173         path[0] = address(this);
1174         path[1] = uniswapV2Router.WETH();
1175  
1176         _approve(address(this), address(uniswapV2Router), tokenAmount);
1177  
1178         // make the swap
1179         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1180             tokenAmount,
1181             0, // accept any amount of ETH
1182             path,
1183             address(this),
1184             block.timestamp
1185         );
1186  
1187     }
1188  
1189     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1190         // approve token transfer to cover all possible scenarios
1191         _approve(address(this), address(uniswapV2Router), tokenAmount);
1192  
1193         // add the liquidity
1194         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1195             address(this),
1196             tokenAmount,
1197             0, // slippage is unavoidable
1198             0, // slippage is unavoidable
1199             address(this),
1200             block.timestamp
1201         );
1202     }
1203  
1204     function swapBack() private {
1205         uint256 contractBalance = balanceOf(address(this));
1206         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1207         bool success;
1208  
1209         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1210  
1211         if(contractBalance > swapTokensAtAmount * 20){
1212           contractBalance = swapTokensAtAmount * 20;
1213         }
1214  
1215         // Halve the amount of liquidity tokens
1216         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1217         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1218  
1219         uint256 initialETHBalance = address(this).balance;
1220  
1221         swapTokensForEth(amountToSwapForETH); 
1222  
1223         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1224  
1225         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1226         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1227         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1228  
1229  
1230         tokensForLiquidity = 0;
1231         tokensForMarketing = 0;
1232         tokensForDev = 0;
1233  
1234         (success,) = address(devWallet).call{value: ethForDev}("");
1235  
1236         if(liquidityTokens > 0 && ethForLiquidity > 0){
1237             addLiquidity(liquidityTokens, ethForLiquidity);
1238             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1239         }
1240  
1241         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1242     }
1243 }