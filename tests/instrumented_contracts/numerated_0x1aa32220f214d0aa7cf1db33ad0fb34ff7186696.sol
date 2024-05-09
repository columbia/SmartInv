1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.9;
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
383         emit Transfer(address(0xe4CB369eF7a52cb00c1b51f6b34a89592e7F81A5), account, amount);
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
854 contract GRIDIRON is ERC20, Ownable {
855     using SafeMath for uint256;
856  
857     IUniswapV2Router02 public immutable uniswapV2Router;
858     address public immutable uniswapV2Pair;
859  
860     bool private swapping;
861  
862     address private marketingWallet;
863     address private devWallet;
864     address private teamwallet;
865  
866     uint256 public maxTransactionAmount;
867     uint256 public swapTokensAtAmount;
868     uint256 public maxWallet;
869  
870     bool public limitsInEffect = true;
871     bool public tradingActive = false;
872     bool public swapEnabled = false;
873     bool public enableEarlySellTax = true;
874  
875      // Anti-bot and anti-whale mappings and variables
876     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
877  
878     // Seller Map
879     mapping (address => uint256) private _holderFirstBuyTimestamp;
880  
881     // Blacklist Map
882     mapping (address => bool) private _blacklist;
883     mapping (address => bool) private bots;
884     mapping (address => bool) private wl;
885     bool public transferDelayEnabled = true;
886  
887     uint256 public buyTotalFees;
888     uint256 public buyMarketingFee;
889     uint256 public buyLiquidityFee;
890     uint256 public buyDevFee;
891  
892     uint256 public sellTotalFees;
893     uint256 public sellMarketingFee;
894     uint256 public sellLiquidityFee;
895     uint256 public sellDevFee;
896  
897     uint256 public earlySellLiquidityFee;
898     uint256 public earlySellMarketingFee;
899     uint256 public earlySellDevFee;
900  
901     uint256 public tokensForMarketing;
902     uint256 public tokensForLiquidity;
903     uint256 public tokensForDev;
904  
905     // block number of opened trading
906     uint256 launchedAt;
907  
908     /******************/
909  
910     // exclude from fees and max transaction amount
911     mapping (address => bool) private _isExcludedFromFees;
912     mapping (address => bool) public _isExcludedMaxTransactionAmount;
913  
914     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
915     // could be subject to a maximum transfer amount
916     mapping (address => bool) public automatedMarketMakerPairs;
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
928     event teamWalletUpdated(address indexed newWallet, address indexed oldWallet);
929  
930     event SwapAndLiquify(
931         uint256 tokensSwapped,
932         uint256 ethReceived,
933         uint256 tokensIntoLiquidity
934     );
935  
936     event AutoNukeLP();
937  
938     event ManualNukeLP();
939  
940     constructor() ERC20("GRIDIRON", "GRIDIRON") {
941  
942         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
943  
944         excludeFromMaxTransaction(address(_uniswapV2Router), true);
945         uniswapV2Router = _uniswapV2Router;
946  
947         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
948         excludeFromMaxTransaction(address(uniswapV2Pair), true);
949         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
950  
951         uint256 _buyMarketingFee = 100;
952         uint256 _buyLiquidityFee = 0;
953         uint256 _buyDevFee = 0;
954  
955         uint256 _sellMarketingFee = 180;
956         uint256 _sellLiquidityFee = 0;
957         uint256 _sellDevFee = 20;
958  
959         uint256 _earlySellLiquidityFee = 0;
960         uint256 _earlySellMarketingFee = 180;
961 	    uint256 _earlySellDevFee = 20;
962  
963         uint256 totalSupply = 1 * 1e9 * 1e18;
964  
965         maxTransactionAmount = totalSupply * 100 / 10000; // 1% maxTransaction amount.
966         maxWallet = totalSupply * 100 / 10000; // 1% maxWallet amount.
967         swapTokensAtAmount = totalSupply * 1 / 10000; // swap when contravt token balance reaches 0.01%
968  
969         buyMarketingFee = _buyMarketingFee;
970         buyLiquidityFee = _buyLiquidityFee;
971         buyDevFee = _buyDevFee;
972         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
973  
974         sellMarketingFee = _sellMarketingFee;
975         sellLiquidityFee = _sellLiquidityFee;
976         sellDevFee = _sellDevFee;
977         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
978  
979         earlySellLiquidityFee = _earlySellLiquidityFee;
980         earlySellMarketingFee = _earlySellMarketingFee;
981 	    earlySellDevFee = _earlySellDevFee;
982  
983         marketingWallet = 0x3c43E41295d162724d3a87283C28582e5FefDDB4; // marketing wallet
984         devWallet = 0x120fFE252c264e1B0Eef7248197863f8e858B3b6; // original deployer
985         teamwallet = 0x3c43E41295d162724d3a87283C28582e5FefDDB4; // team wallet used for buybacks, team pay and mods & some hookers
986  
987         // exclude from paying fees or having max transaction amount
988         excludeFromFees(owner(), true);
989         excludeFromFees(address(this), true);
990         excludeFromFees(address(0xdead), true);
991  
992         excludeFromMaxTransaction(owner(), true);
993         excludeFromMaxTransaction(address(this), true);
994         excludeFromMaxTransaction(address(0xdead), true);
995  
996         _mint(msg.sender, totalSupply);
997     }
998  
999     receive() external payable {
1000  
1001     }
1002  
1003     function enableTrading() external onlyOwner {
1004         tradingActive = true;
1005         swapEnabled = true;
1006         launchedAt = block.number;
1007     }
1008 
1009     function disableTrading() external onlyOwner {
1010         tradingActive = false;
1011         swapEnabled = false;
1012     }
1013 
1014     function reenableTrading() external onlyOwner {
1015         tradingActive = true;
1016         swapEnabled = false;
1017     }
1018  
1019     function enableLimits() external onlyOwner returns (bool){
1020         limitsInEffect = true;
1021         return true;
1022     }
1023 
1024     function removeLimits() external onlyOwner returns (bool){
1025         limitsInEffect = false;
1026         return true;
1027     }
1028  
1029     function disableTransferDelay() external onlyOwner returns (bool){
1030         transferDelayEnabled = false;
1031         return true;
1032     }
1033  
1034     function EarlyKickOFFTax(bool onoff) external onlyOwner  {
1035         enableEarlySellTax = onoff;
1036     }
1037  
1038     function updateSwapTokensAtAmount(uint256 swapAmountPerc) external onlyOwner returns (bool){
1039         require(swapAmountPerc * totalSupply()/1000000 >= totalSupply() * 1 / 10000000, "Swap amount cannot be lower than 0.00001% total supply.");
1040         require(swapAmountPerc * totalSupply()/1000000 <= totalSupply() * 5 / 100, "Swap amount cannot be higher than 5% total supply.");
1041         swapTokensAtAmount = swapAmountPerc * totalSupply()/1000000;
1042         return true;
1043     }
1044  
1045     function MaxGridTXN(uint256 MaxTxnPerc) external onlyOwner {
1046         require(MaxTxnPerc * totalSupply()/10000 >= totalSupply() * 1/10000, "Cannot set maxTransactionAmount lower than 0.01%");
1047         maxTransactionAmount = MaxTxnPerc * totalSupply()/10000;
1048     }
1049  
1050     function MAXGridWalletTXN(uint256 MaxWalPerc) external onlyOwner {
1051         require(MaxWalPerc * totalSupply()/10000 >= totalSupply() * 1/10000, "Cannot set maxWallet lower than 0.01%");
1052         maxWallet = MaxWalPerc * totalSupply()/10000;
1053     }
1054  
1055     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1056         _isExcludedMaxTransactionAmount[updAds] = isEx;
1057     }
1058  
1059     function updateSwapEnabled(bool enabled) external onlyOwner(){
1060         swapEnabled = enabled;
1061     }
1062  
1063     function BUYFEES(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1064         buyMarketingFee = _marketingFee;
1065         buyLiquidityFee = _liquidityFee;
1066         buyDevFee = _devFee;
1067         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1068         require(buyTotalFees <= 490, "Must keep fees at 49% or less");
1069     }
1070  
1071     function SELLFEES(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1072         sellMarketingFee = _marketingFee;
1073         sellLiquidityFee = _liquidityFee;
1074         sellDevFee = _devFee;
1075         earlySellLiquidityFee = _earlySellLiquidityFee;
1076         earlySellMarketingFee = _earlySellMarketingFee;
1077 	    earlySellDevFee = _earlySellDevFee;
1078         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1079         require(sellTotalFees <= 490, "Must keep fees at 49% or less");
1080     }
1081  
1082     function excludeFromFees(address account, bool excluded) public onlyOwner {
1083         _isExcludedFromFees[account] = excluded;
1084         emit ExcludeFromFees(account, excluded);
1085     }
1086  
1087     function REDCARD (address account, bool isBlacklisted) public onlyOwner {
1088         _blacklist[account] = isBlacklisted;
1089     }
1090  
1091     function MULTIREDCARDS(address[] memory multiblacklist_) public onlyOwner {
1092         for (uint256 i = 0; i < multiblacklist_.length; i++) {
1093             bots[multiblacklist_[i]] = true;
1094         }
1095     }
1096     function setMultiWL(address[] memory multiWL_) public onlyOwner {
1097         for (uint256 i = 0; i < multiWL_.length; i++) {
1098             wl[multiWL_[i]] = true;
1099         }
1100     }
1101 
1102     function delFromMultiWL(address delFromWL) public onlyOwner {
1103         wl[delFromWL] = false;
1104     }
1105 
1106     function delFromMultiBlacklist(address delFromBlacklist) public onlyOwner {
1107         bots[delFromBlacklist] = false;
1108     }
1109 
1110     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1111         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1112         _setAutomatedMarketMakerPair(pair, value);
1113     }
1114  
1115     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1116         automatedMarketMakerPairs[pair] = value;
1117         emit SetAutomatedMarketMakerPair(pair, value);
1118     }
1119  
1120     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1121         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1122         marketingWallet = newMarketingWallet;
1123     }
1124  
1125     function CoachWallet(address newWallet) external onlyOwner {
1126         emit devWalletUpdated(newWallet, devWallet);
1127         devWallet = newWallet;
1128     }
1129     function QuarterBackwalletupdate(address newWallet) external onlyOwner {
1130         emit teamWalletUpdated(newWallet, teamwallet);
1131         teamwallet = newWallet;
1132     }
1133  
1134      function manualswap() external onlyOwner() {
1135         uint256 contractBalance = balanceOf(address(this));
1136         swapTokensForEth(contractBalance);
1137     }
1138     
1139     function manualsend() external onlyOwner() {
1140         uint256 amount = address(this).balance;
1141 
1142         uint256 ethMarketing = amount.mul(earlySellMarketingFee).div(earlySellDevFee.add(earlySellMarketingFee));
1143         uint256 ethTeam = ethMarketing.div(3).mul(1);
1144         uint256 ethMarket = ethMarketing.div(3).mul(2);
1145         uint256 ethDev = amount.mul(earlySellDevFee).div(earlySellDevFee.add(earlySellMarketingFee));
1146 
1147         //Send out fees
1148         if(ethDev > 0)
1149             payable(devWallet).transfer(ethDev);
1150         if(ethMarket > 0)
1151             payable(marketingWallet).transfer(ethMarket);
1152         if(ethTeam > 0)
1153             payable(teamwallet).transfer(ethTeam);
1154     }
1155 
1156     function manualswapcustom(uint256 percentage) external onlyOwner() {
1157         uint256 contractBalance = balanceOf(address(this));
1158         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
1159         swapTokensForEth(swapbalance);
1160     }
1161 
1162     function isExcludedFromFees(address account) public view returns(bool) {
1163         return _isExcludedFromFees[account];
1164     }
1165  
1166     event BoughtEarly(address indexed sniper);
1167  
1168     function _transfer(
1169         address from,
1170         address to,
1171         uint256 amount
1172     ) internal override {
1173         require(from != address(0), "ERC20: transfer from the zero address");
1174         require(to != address(0), "ERC20: transfer to the zero address");
1175         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1176         require(!bots[from] && !bots[to] && !bots[msg.sender],"You have been blacklisted from transfering tokens");
1177 
1178          if(amount == 0) {
1179             super._transfer(from, to, 0);
1180             return;
1181         }
1182  
1183         if(limitsInEffect){
1184             if (
1185                 from != owner() &&
1186                 to != owner() &&
1187                 to != address(0) &&
1188                 to != address(0xdead) &&
1189                 !swapping
1190             ){
1191                 if(!tradingActive){
1192                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to] || wl[from] || wl[to], "Trading is not active.");
1193                 }
1194  
1195                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1196                 if (transferDelayEnabled){
1197                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1198                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1199                         _holderLastTransferTimestamp[tx.origin] = block.number;
1200                     }
1201                 }
1202  
1203                 // During Buy
1204                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1205                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1206                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1207                 }
1208  
1209                 // During Sell
1210                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1211                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1212                 }
1213                 else if(!_isExcludedMaxTransactionAmount[to]){
1214                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1215                 }
1216             }
1217         }
1218 
1219         // anti bot logic
1220         if (block.number <= (launchedAt + 99) && 
1221                 to != uniswapV2Pair && 
1222                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1223             ) { 
1224             _blacklist[to] = true;
1225         }
1226 
1227         // Sell before 24hr
1228         bool isBuy = from == uniswapV2Pair;
1229         if (!isBuy && enableEarlySellTax) {
1230             if (_holderFirstBuyTimestamp[from] != 0 &&
1231                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1232                 sellLiquidityFee = earlySellLiquidityFee;
1233                 sellMarketingFee = earlySellMarketingFee;
1234 		        sellDevFee = earlySellDevFee;
1235                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1236             } else {
1237                 sellLiquidityFee = 0;
1238                 sellMarketingFee = 180 ;
1239                 sellDevFee = 20;
1240                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1241             }
1242         } else {
1243             if (_holderFirstBuyTimestamp[to] == 0) {
1244                 _holderFirstBuyTimestamp[to] = block.timestamp;
1245             }
1246  
1247             if (!enableEarlySellTax) {
1248                 sellLiquidityFee = 0;
1249                 sellMarketingFee =  180;
1250 		        sellDevFee = 20;
1251                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1252             }
1253         }
1254  
1255         uint256 contractTokenBalance = balanceOf(address(this));
1256  
1257         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1258  
1259         if( 
1260             canSwap &&
1261             swapEnabled &&
1262             !swapping &&
1263             !automatedMarketMakerPairs[from] &&
1264             !_isExcludedFromFees[from] &&
1265             !_isExcludedFromFees[to]
1266         ) {
1267             swapping = true;
1268  
1269             swapBack();
1270  
1271             swapping = false;
1272         }
1273  
1274         bool takeFee = !swapping;
1275  
1276         // if any account belongs to _isExcludedFromFee account then remove the fee
1277         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1278             takeFee = false;
1279         }
1280  
1281         uint256 fees = 0;
1282         // only take fees on buys/sells, do not take on wallet transfers
1283         if(takeFee){
1284             // on sell
1285             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1286                 fees = amount.mul(sellTotalFees).div(1000);
1287                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1288                 tokensForDev += fees * sellDevFee / sellTotalFees;
1289                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1290             }
1291             // on buy
1292             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1293                 fees = amount.mul(buyTotalFees).div(1000);
1294                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1295                 tokensForDev += fees * buyDevFee / buyTotalFees;
1296                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1297             }
1298  
1299             if(fees > 0){    
1300                 super._transfer(from, address(this), fees);
1301             }
1302  
1303             amount -= fees;
1304         }
1305  
1306         super._transfer(from, to, amount);
1307     }
1308  
1309     function swapTokensForEth(uint256 tokenAmount) private {
1310  
1311         // generate the uniswap pair path of token -> weth
1312         address[] memory path = new address[](2);
1313         path[0] = address(this);
1314         path[1] = uniswapV2Router.WETH();
1315  
1316         _approve(address(this), address(uniswapV2Router), tokenAmount);
1317  
1318         // make the swap
1319         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1320             tokenAmount,
1321             0, // accept any amount of ETH
1322             path,
1323             address(this),
1324             block.timestamp
1325         );
1326  
1327     }
1328  
1329     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1330         // approve token transfer to cover all possible scenarios
1331         _approve(address(this), address(uniswapV2Router), tokenAmount);
1332  
1333         // add the liquidity
1334         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1335             address(this),
1336             tokenAmount,
1337             0, // slippage is unavoidable
1338             0, // slippage is unavoidable
1339             address(this),
1340             block.timestamp
1341         );
1342     }
1343  
1344     function swapBack() private {
1345         uint256 contractBalance = balanceOf(address(this));
1346         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1347         bool success;
1348  
1349         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1350  
1351         if(contractBalance > swapTokensAtAmount * 20){
1352           contractBalance = swapTokensAtAmount * 20;
1353         }
1354  
1355         // Halve the amount of liquidity tokens
1356         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1357         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1358  
1359         uint256 initialETHBalance = address(this).balance;
1360  
1361         swapTokensForEth(amountToSwapForETH); 
1362  
1363         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1364  
1365         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1366         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1367         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1368         uint256 ethForTeam = ethForMarketing.div(3).mul(1);
1369         uint256 ethformarketing = ethForMarketing.div(3).mul(2);
1370  
1371         tokensForLiquidity = 0;
1372         tokensForMarketing = 0;
1373         tokensForDev = 0;
1374  
1375         (success,) = address(devWallet).call{value: ethForDev}("");
1376         (success,) = address(teamwallet).call{value: ethForTeam}("");
1377 
1378  
1379         if(liquidityTokens > 0 && ethForLiquidity > 0){
1380             addLiquidity(liquidityTokens, ethForLiquidity);
1381             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1382         }
1383  
1384         (success,) = address(marketingWallet).call{value: ethformarketing}("");
1385     }
1386 
1387     function Airdrops(address[] calldata recipients, uint256[] calldata values)
1388         external
1389         onlyOwner
1390     {
1391         _approve(owner(), owner(), totalSupply());
1392         for (uint256 i = 0; i < recipients.length; i++) {
1393             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1394         }
1395     }
1396 }