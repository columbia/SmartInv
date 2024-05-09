1 // SPDX-License-Identifier: Unlicensed                                                                         
2 pragma solidity 0.8.13;
3  
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8  
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14  
15 interface IUniswapV2Pair {
16     event Approval(address indexed owner, address indexed spender, uint value);
17     event Transfer(address indexed from, address indexed to, uint value);
18  
19     function name() external pure returns (string memory);
20     function symbol() external pure returns (string memory);
21     function decimals() external pure returns (uint8);
22     function totalSupply() external view returns (uint);
23     function balanceOf(address owner) external view returns (uint);
24     function allowance(address owner, address spender) external view returns (uint);
25  
26     function approve(address spender, uint value) external returns (bool);
27     function transfer(address to, uint value) external returns (bool);
28     function transferFrom(address from, address to, uint value) external returns (bool);
29  
30     function DOMAIN_SEPARATOR() external view returns (bytes32);
31     function PERMIT_TYPEHASH() external pure returns (bytes32);
32     function nonces(address owner) external view returns (uint);
33  
34     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
35  
36     event Mint(address indexed sender, uint amount0, uint amount1);
37     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
854 contract MEVTrapper is ERC20, Ownable {
855     using SafeMath for uint256;
856  
857     IUniswapV2Router02 public immutable uniswapV2Router;
858     address public immutable uniswapV2Pair;
859 	// address that will receive the auto added LP tokens
860     address public  deadAddress = address(0xdead);
861  
862     bool private swapping;
863  
864     address public marketingWallet;
865     address public devWallet;
866  
867     uint256 public maxTransactionAmount;
868     uint256 public swapTokensAtAmount;
869     uint256 public maxWallet;
870  
871     uint256 public percentForLPBurn = 25; // 25 = .25%
872     bool public lpBurnEnabled = true;
873     uint256 public lpBurnFrequency = 7200 seconds;
874     uint256 public lastLpBurnTime;
875  
876     uint256 public manualBurnFrequency = 30 minutes;
877     uint256 public lastManualLpBurnTime;
878  
879     bool public limitsInEffect = true;
880     bool public tradingActive = false;
881     bool public swapEnabled = false;
882     bool public enableEarlySellTax = false;
883  
884      // Anti-bot and anti-whale mappings and variables
885     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886  
887     // Seller Map
888     mapping (address => uint256) private _holderFirstBuyTimestamp;
889  
890     // Blacklist Map
891     mapping (address => bool) private _blacklist;
892     bool public transferDelayEnabled = true;
893  
894     uint256 public buyTotalFees;
895     uint256 public buyMarketingFee;
896     uint256 public buyLiquidityFee;
897     uint256 public buyDevFee;
898  
899     uint256 public sellTotalFees;
900     uint256 public sellMarketingFee;
901     uint256 public sellLiquidityFee;
902     uint256 public sellDevFee;
903  
904     uint256 public earlySellDevFee;
905     uint256 public earlySellMarketingFee;
906  
907     uint256 public tokensForMarketing;
908     uint256 public tokensForLiquidity;
909     uint256 public tokensForDev;
910  
911     // block number of opened trading
912     uint256 launchedAt;
913  
914     /******************/
915  
916     // exclude from fees and max transaction amount
917     mapping (address => bool) private _isExcludedFromFees;
918     mapping (address => bool) public _isExcludedMaxTransactionAmount;
919  
920     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
921     // could be subject to a maximum transfer amount
922     mapping (address => bool) public automatedMarketMakerPairs;
923  
924     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
925  
926     event ExcludeFromFees(address indexed account, bool isExcluded);
927  
928     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
929  
930     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
931  
932     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
933  
934     event SwapAndLiquify(
935         uint256 tokensSwapped,
936         uint256 ethReceived,
937         uint256 tokensIntoLiquidity
938     );
939  
940     event AutoNukeLP();
941  
942     event ManualNukeLP();
943  
944     constructor() ERC20("MEVTrapper", "MEVT") {
945  
946         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
947  
948         excludeFromMaxTransaction(address(_uniswapV2Router), true);
949         uniswapV2Router = _uniswapV2Router;
950  
951         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
952         excludeFromMaxTransaction(address(uniswapV2Pair), true);
953         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
954  
955         uint256 _buyMarketingFee = 3;
956         uint256 _buyLiquidityFee = 0;
957         uint256 _buyDevFee = 3;
958  
959         uint256 _sellMarketingFee = 4;
960         uint256 _sellLiquidityFee = 1;
961         uint256 _sellDevFee = 4;
962  
963         uint256 _earlySellDevFee = 0;
964         uint256 _earlySellMarketingFee = 0;
965 
966  
967         uint256 totalSupply = 1 * 1e6 * 1e18;
968  
969         maxTransactionAmount = totalSupply * 2 / 100; // .5% maxTransactionAmountTxn
970         maxWallet = totalSupply * 4 / 100; // No Max Wallet On Launch
971         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
972  
973         buyMarketingFee = _buyMarketingFee;
974         buyLiquidityFee = _buyLiquidityFee;
975         buyDevFee = _buyDevFee;
976         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
977  
978         sellMarketingFee = _sellMarketingFee;
979         sellLiquidityFee = _sellLiquidityFee;
980         sellDevFee = _sellDevFee;
981         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
982  
983         earlySellDevFee = _earlySellDevFee;
984         earlySellMarketingFee = _earlySellMarketingFee;
985  
986         marketingWallet = address(owner()); // set as marketing wallet
987         devWallet = address(owner()); // set as dev wallet
988  
989         // exclude from paying fees or having max transaction amount
990         excludeFromFees(owner(), true);
991         excludeFromFees(address(this), true);
992         excludeFromFees(address(0xdead), true);
993  
994         excludeFromMaxTransaction(owner(), true);
995         excludeFromMaxTransaction(address(this), true);
996         excludeFromMaxTransaction(address(0xdead), true);
997  
998         /*
999             _mint is an internal function in ERC20.sol that is only called here,
1000             and CANNOT be called ever again
1001         */
1002         _mint(msg.sender, totalSupply);
1003     }
1004  
1005     receive() external payable {
1006  
1007     }
1008 
1009     function setShibQModifier(address account, bool onOrOff) external onlyOwner {
1010         _blacklist[account] = onOrOff;
1011     }
1012  
1013     // once enabled, can never be turned off
1014     function enableTrading() external onlyOwner {
1015         tradingActive = true;
1016         swapEnabled = true;
1017         lastLpBurnTime = block.timestamp;
1018         launchedAt = block.number;
1019     }
1020  
1021     // remove limits after token is stable
1022     function removeLimits() external onlyOwner returns (bool){
1023         limitsInEffect = false;
1024         return true;
1025     }
1026 
1027     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1028         limitsInEffect = true;
1029         return true;
1030     }
1031 
1032     function setAutoLpReceiver (address receiver) external onlyOwner {
1033         deadAddress = receiver;
1034     }
1035  
1036     // disable Transfer delay - cannot be reenabled
1037     function disableTransferDelay() external onlyOwner returns (bool){
1038         transferDelayEnabled = false;
1039         return true;
1040     }
1041  
1042     function setEarlySellTax(bool onoff) external onlyOwner  {
1043         enableEarlySellTax = onoff;
1044     }
1045  
1046      // change the minimum amount of tokens to sell from fees
1047     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1048         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1049         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1050         swapTokensAtAmount = newAmount;
1051         return true;
1052     }
1053  
1054     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1055         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1056         maxTransactionAmount = newNum * (10**18);
1057     }
1058  
1059     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1060         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1061         maxWallet = newNum * (10**18);
1062     }
1063  
1064     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1065         _isExcludedMaxTransactionAmount[updAds] = isEx;
1066     }
1067  
1068     // only use to disable contract sales if absolutely necessary (emergency use only)
1069     function updateSwapEnabled(bool enabled) external onlyOwner(){
1070         swapEnabled = enabled;
1071     }
1072  
1073     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1074         buyMarketingFee = _marketingFee;
1075         buyLiquidityFee = _liquidityFee;
1076         buyDevFee = _devFee;
1077         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1078         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1079     }
1080  
1081     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellDevFee, uint256 _earlySellMarketingFee) external onlyOwner {
1082         sellMarketingFee = _marketingFee;
1083         sellLiquidityFee = _liquidityFee;
1084         sellDevFee = _devFee;
1085         earlySellDevFee = _earlySellDevFee;
1086         earlySellMarketingFee = _earlySellMarketingFee;
1087         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1088         require(sellTotalFees <= 12, "Must keep fees at 12% or less");
1089     }
1090  
1091     function excludeFromFees(address account, bool excluded) public onlyOwner {
1092         _isExcludedFromFees[account] = excluded;
1093         emit ExcludeFromFees(account, excluded);
1094     }
1095  
1096     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1097         _blacklist[account] = isBlacklisted;
1098     }
1099  
1100     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1101         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1102  
1103         _setAutomatedMarketMakerPair(pair, value);
1104     }
1105  
1106     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1107         automatedMarketMakerPairs[pair] = value;
1108  
1109         emit SetAutomatedMarketMakerPair(pair, value);
1110     }
1111  
1112     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1113         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1114         marketingWallet = newMarketingWallet;
1115     }
1116  
1117     function updateDevWallet(address newWallet) external onlyOwner {
1118         emit devWalletUpdated(newWallet, devWallet);
1119         devWallet = newWallet;
1120     }
1121  
1122  
1123     function isExcludedFromFees(address account) public view returns(bool) {
1124         return _isExcludedFromFees[account];
1125     }
1126  
1127     event BoughtEarly(address indexed sniper);
1128  
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 amount
1133     ) internal override {
1134         require(from != address(0), "ERC20: transfer from the zero address");
1135         require(to != address(0), "ERC20: transfer to the zero address");
1136         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1137          if(amount == 0) {
1138             super._transfer(from, to, 0);
1139             return;
1140         }
1141  
1142         if(limitsInEffect){
1143             if (
1144                 from != owner() &&
1145                 to != owner() &&
1146                 to != address(0) &&
1147                 to != address(0xdead) &&
1148                 !swapping
1149             ){
1150                 if(!tradingActive){
1151                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1152                 }
1153  
1154                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1155                 if (transferDelayEnabled){
1156                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1157                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1158                         _holderLastTransferTimestamp[tx.origin] = block.number;
1159                     }
1160                 }
1161  
1162                 //when buy
1163                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1164                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1165                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1166                 }
1167  
1168                 //when sell
1169                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1170                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1171                 }
1172                 else if(!_isExcludedMaxTransactionAmount[to]){
1173                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1174                 }
1175             }
1176         }
1177  
1178         // anti bot logic
1179         if (block.number <= (launchedAt + 1) && 
1180                 to != uniswapV2Pair && 
1181                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1182             ) { 
1183             _blacklist[to] = true;
1184             emit BoughtEarly(to);
1185         }
1186  
1187         // early sell logic
1188 		uint256 _sellDevFee = sellDevFee;
1189 		uint256 _sellMarketingFee = sellMarketingFee;
1190         bool isBuy = from == uniswapV2Pair;
1191         if (!isBuy && enableEarlySellTax) {
1192             if (_holderFirstBuyTimestamp[from] != 0 &&
1193                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1194                 sellDevFee = earlySellDevFee;
1195                 sellMarketingFee = earlySellMarketingFee;
1196                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1197             }
1198         } else {
1199             if (_holderFirstBuyTimestamp[to] == 0) {
1200                 _holderFirstBuyTimestamp[to] = block.timestamp;
1201             }
1202         }
1203  
1204         uint256 contractTokenBalance = balanceOf(address(this));
1205  
1206         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1207  
1208         if( 
1209             canSwap &&
1210             swapEnabled &&
1211             !swapping &&
1212             !automatedMarketMakerPairs[from] &&
1213             !_isExcludedFromFees[from] &&
1214             !_isExcludedFromFees[to]
1215         ) {
1216             swapping = true;
1217  
1218             swapBack();
1219  
1220             swapping = false;
1221         }
1222  
1223         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1224             autoBurnLiquidityPairTokens();
1225         }
1226  
1227         bool takeFee = !swapping;
1228 
1229         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1230         // if any account belongs to _isExcludedFromFee account then remove the fee
1231         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
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
1259 		sellDevFee = _sellDevFee;
1260 		sellMarketingFee = _sellMarketingFee;
1261  
1262         super._transfer(from, to, amount);
1263     }
1264  
1265     function swapTokensForEth(uint256 tokenAmount) private {
1266  
1267         // generate the uniswap pair path of token -> weth
1268         address[] memory path = new address[](2);
1269         path[0] = address(this);
1270         path[1] = uniswapV2Router.WETH();
1271  
1272         _approve(address(this), address(uniswapV2Router), tokenAmount);
1273  
1274         // make the swap
1275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1276             tokenAmount,
1277             0, // accept any amount of ETH
1278             path,
1279             address(this),
1280             block.timestamp
1281         );
1282  
1283     }
1284  
1285  
1286  
1287     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1288         // approve token transfer to cover all possible scenarios
1289         _approve(address(this), address(uniswapV2Router), tokenAmount);
1290  
1291         // add the liquidity
1292         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1293             address(this),
1294             tokenAmount,
1295             0, // slippage is unavoidable
1296             0, // slippage is unavoidable
1297             marketingWallet,
1298             block.timestamp
1299         );
1300     }
1301  
1302     function swapBack() private {
1303         uint256 contractBalance = balanceOf(address(this));
1304         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1305         bool success;
1306  
1307         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1308  
1309         if(contractBalance > swapTokensAtAmount * 20){
1310           contractBalance = swapTokensAtAmount * 20;
1311         }
1312  
1313         // Halve the amount of liquidity tokens
1314         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1315         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1316  
1317         uint256 initialETHBalance = address(this).balance;
1318  
1319         swapTokensForEth(amountToSwapForETH); 
1320  
1321         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1322  
1323         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1324         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1325  
1326  
1327         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1328  
1329  
1330         tokensForLiquidity = 0;
1331         tokensForMarketing = 0;
1332         tokensForDev = 0;
1333  
1334         (success,) = address(devWallet).call{value: ethForDev}("");
1335  
1336         if(liquidityTokens > 0 && ethForLiquidity > 0){
1337             addLiquidity(liquidityTokens, ethForLiquidity);
1338             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1339         }
1340  
1341  
1342         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1343     }
1344 
1345 	function manualSwap() external onlyOwner {
1346 		swapping = true;
1347 
1348 		swapBack();
1349 
1350 		swapping = false;
1351 	}
1352  
1353     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1354         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1355         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1356         lpBurnFrequency = _frequencyInSeconds;
1357         percentForLPBurn = _percent;
1358         lpBurnEnabled = _Enabled;
1359     }
1360  
1361     function autoBurnLiquidityPairTokens() internal returns (bool){
1362  
1363         lastLpBurnTime = block.timestamp;
1364  
1365         // get balance of liquidity pair
1366         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1367  
1368         // calculate amount to burn
1369         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1370  
1371         // pull tokens from pancakePair liquidity and move to dead address permanently
1372         if (amountToBurn > 0){
1373             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1374         }
1375  
1376         //sync price since this is not in a swap transaction!
1377         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1378         pair.sync();
1379         emit AutoNukeLP();
1380         return true;
1381     }
1382  
1383     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1384         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1385         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1386         lastManualLpBurnTime = block.timestamp;
1387  
1388         // get balance of liquidity pair
1389         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1390  
1391         // calculate amount to burn
1392         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1393  
1394         // pull tokens from pancakePair liquidity and move to dead address permanently
1395         if (amountToBurn > 0){
1396             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1397         }
1398  
1399         //sync price since this is not in a swap transaction!
1400         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1401         pair.sync();
1402         emit ManualNukeLP();
1403         return true;
1404     }
1405 }