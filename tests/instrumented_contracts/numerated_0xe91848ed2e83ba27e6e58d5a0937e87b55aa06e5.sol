1 pragma solidity 0.8.9;
2  
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7  
8     function _msgData() internal view virtual returns (bytes calldata) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13  
14 interface IUniswapV2Pair {
15     event Approval(address indexed owner, address indexed spender, uint value);
16     event Transfer(address indexed from, address indexed to, uint value);
17  
18     function name() external pure returns (string memory);
19     function symbol() external pure returns (string memory);
20     function decimals() external pure returns (uint8);
21     function totalSupply() external view returns (uint);
22     function balanceOf(address owner) external view returns (uint);
23     function allowance(address owner, address spender) external view returns (uint);
24  
25     function approve(address spender, uint value) external returns (bool);
26     function transfer(address to, uint value) external returns (bool);
27     function transferFrom(address from, address to, uint value) external returns (bool);
28  
29     function DOMAIN_SEPARATOR() external view returns (bytes32);
30     function PERMIT_TYPEHASH() external pure returns (bytes32);
31     function nonces(address owner) external view returns (uint);
32  
33     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
34  
35     event Mint(address indexed sender, uint amount0, uint amount1);
36     event Swap(
37         address indexed sender,
38         uint amount0In,
39         uint amount1In,
40         uint amount0Out,
41         uint amount1Out,
42         address indexed to
43     );
44     event Sync(uint112 reserve0, uint112 reserve1);
45  
46     function MINIMUM_LIQUIDITY() external pure returns (uint);
47     function factory() external view returns (address);
48     function token0() external view returns (address);
49     function token1() external view returns (address);
50     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
51     function price0CumulativeLast() external view returns (uint);
52     function price1CumulativeLast() external view returns (uint);
53     function kLast() external view returns (uint);
54  
55     function mint(address to) external returns (uint liquidity);
56     function burn(address to) external returns (uint amount0, uint amount1);
57     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
58     function skim(address to) external;
59     function sync() external;
60  
61     function initialize(address, address) external;
62 }
63  
64 interface IUniswapV2Factory {
65     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
66  
67     function feeTo() external view returns (address);
68     function feeToSetter() external view returns (address);
69  
70     function getPair(address tokenA, address tokenB) external view returns (address pair);
71     function allPairs(uint) external view returns (address pair);
72     function allPairsLength() external view returns (uint);
73  
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75  
76     function setFeeTo(address) external;
77     function setFeeToSetter(address) external;
78 }
79  
80 interface IERC20 {
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85  
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90  
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `recipient`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address recipient, uint256 amount) external returns (bool);
99  
100     /**
101      * @dev Returns the remaining number of tokens that `spender` will be
102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
103      * zero by default.
104      *
105      * This value changes when {approve} or {transferFrom} are called.
106      */
107     function allowance(address owner, address spender) external view returns (uint256);
108  
109     /**
110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
115      * that someone may use both the old and the new allowance by unfortunate
116      * transaction ordering. One possible solution to mitigate this race
117      * condition is to first reduce the spender's allowance to 0 and set the
118      * desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address spender, uint256 amount) external returns (bool);
124  
125     /**
126      * @dev Moves `amount` tokens from `sender` to `recipient` using the
127      * allowance mechanism. `amount` is then deducted from the caller's
128      * allowance.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) external returns (bool);
139  
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147  
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154  
155 interface IERC20Metadata is IERC20 {
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() external view returns (string memory);
160  
161     /**
162      * @dev Returns the symbol of the token.
163      */
164     function symbol() external view returns (string memory);
165  
166     /**
167      * @dev Returns the decimals places of the token.
168      */
169     function decimals() external view returns (uint8);
170 }
171  
172  
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     using SafeMath for uint256;
175  
176     mapping(address => uint256) private _balances;
177  
178     mapping(address => mapping(address => uint256)) private _allowances;
179  
180     uint256 private _totalSupply;
181  
182     string private _name;
183     string private _symbol;
184  
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The default value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor(string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198  
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205  
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213  
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230  
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237  
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244  
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - `recipient` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257  
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264  
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276  
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * Requirements:
284      *
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``sender``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         _transfer(sender, recipient, amount);
296         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
297         return true;
298     }
299  
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
314         return true;
315     }
316  
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
333         return true;
334     }
335  
336     /**
337      * @dev Moves tokens `amount` from `sender` to `recipient`.
338      *
339      * This is internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(
351         address sender,
352         address recipient,
353         uint256 amount
354     ) internal virtual {
355         require(sender != address(0), "ERC20: transfer from the zero address");
356         require(recipient != address(0), "ERC20: transfer to the zero address");
357  
358         _beforeTokenTransfer(sender, recipient, amount);
359  
360         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
361         _balances[recipient] = _balances[recipient].add(amount);
362         emit Transfer(sender, recipient, amount);
363     }
364  
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `account` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376  
377         _beforeTokenTransfer(address(0), account, amount);
378  
379         _totalSupply = _totalSupply.add(amount);
380         _balances[account] = _balances[account].add(amount);
381         emit Transfer(address(0), account, amount);
382     }
383  
384     /**
385      * @dev Destroys `amount` tokens from `account`, reducing the
386      * total supply.
387      *
388      * Emits a {Transfer} event with `to` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      * - `account` must have at least `amount` tokens.
394      */
395     function _burn(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: burn from the zero address");
397  
398         _beforeTokenTransfer(account, address(0), amount);
399  
400         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
401         _totalSupply = _totalSupply.sub(amount);
402         emit Transfer(account, address(0), amount);
403     }
404  
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(
419         address owner,
420         address spender,
421         uint256 amount
422     ) internal virtual {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425  
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429  
430     /**
431      * @dev Hook that is called before any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * will be to transferred to `to`.
438      * - when `from` is zero, `amount` tokens will be minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _beforeTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 }
450  
451 library SafeMath {
452     /**
453      * @dev Returns the addition of two unsigned integers, reverting on
454      * overflow.
455      *
456      * Counterpart to Solidity's `+` operator.
457      *
458      * Requirements:
459      *
460      * - Addition cannot overflow.
461      */
462     function add(uint256 a, uint256 b) internal pure returns (uint256) {
463         uint256 c = a + b;
464         require(c >= a, "SafeMath: addition overflow");
465  
466         return c;
467     }
468  
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting on
471      * overflow (when the result is negative).
472      *
473      * Counterpart to Solidity's `-` operator.
474      *
475      * Requirements:
476      *
477      * - Subtraction cannot overflow.
478      */
479     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
480         return sub(a, b, "SafeMath: subtraction overflow");
481     }
482  
483     /**
484      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
485      * overflow (when the result is negative).
486      *
487      * Counterpart to Solidity's `-` operator.
488      *
489      * Requirements:
490      *
491      * - Subtraction cannot overflow.
492      */
493     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
494         require(b <= a, errorMessage);
495         uint256 c = a - b;
496  
497         return c;
498     }
499  
500     /**
501      * @dev Returns the multiplication of two unsigned integers, reverting on
502      * overflow.
503      *
504      * Counterpart to Solidity's `*` operator.
505      *
506      * Requirements:
507      *
508      * - Multiplication cannot overflow.
509      */
510     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
511         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
512         // benefit is lost if 'b' is also tested.
513         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
514         if (a == 0) {
515             return 0;
516         }
517  
518         uint256 c = a * b;
519         require(c / a == b, "SafeMath: multiplication overflow");
520  
521         return c;
522     }
523  
524     /**
525      * @dev Returns the integer division of two unsigned integers. Reverts on
526      * division by zero. The result is rounded towards zero.
527      *
528      * Counterpart to Solidity's `/` operator. Note: this function uses a
529      * `revert` opcode (which leaves remaining gas untouched) while Solidity
530      * uses an invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function div(uint256 a, uint256 b) internal pure returns (uint256) {
537         return div(a, b, "SafeMath: division by zero");
538     }
539  
540     /**
541      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
542      * division by zero. The result is rounded towards zero.
543      *
544      * Counterpart to Solidity's `/` operator. Note: this function uses a
545      * `revert` opcode (which leaves remaining gas untouched) while Solidity
546      * uses an invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
553         require(b > 0, errorMessage);
554         uint256 c = a / b;
555         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
556  
557         return c;
558     }
559  
560     /**
561      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
562      * Reverts when dividing by zero.
563      *
564      * Counterpart to Solidity's `%` operator. This function uses a `revert`
565      * opcode (which leaves remaining gas untouched) while Solidity uses an
566      * invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
573         return mod(a, b, "SafeMath: modulo by zero");
574     }
575  
576     /**
577      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
578      * Reverts with custom message when dividing by zero.
579      *
580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
581      * opcode (which leaves remaining gas untouched) while Solidity uses an
582      * invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
589         require(b != 0, errorMessage);
590         return a % b;
591     }
592 }
593  
594 contract Ownable is Context {
595     address private _owner;
596  
597     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
598  
599     /**
600      * @dev Initializes the contract setting the deployer as the initial owner.
601      */
602     constructor () {
603         address msgSender = _msgSender();
604         _owner = msgSender;
605         emit OwnershipTransferred(address(0), msgSender);
606     }
607  
608     /**
609      * @dev Returns the address of the current owner.
610      */
611     function owner() public view returns (address) {
612         return _owner;
613     }
614  
615     /**
616      * @dev Throws if called by any account other than the owner.
617      */
618     modifier onlyOwner() {
619         require(_owner == _msgSender(), "Ownable: caller is not the owner");
620         _;
621     }
622  
623     /**
624      * @dev Leaves the contract without owner. It will not be possible to call
625      * `onlyOwner` functions anymore. Can only be called by the current owner.
626      *
627      * NOTE: Renouncing ownership will leave the contract without an owner,
628      * thereby removing any functionality that is only available to the owner.
629      */
630     function renounceOwnership() public virtual onlyOwner {
631         emit OwnershipTransferred(_owner, address(0));
632         _owner = address(0);
633     }
634  
635     /**
636      * @dev Transfers ownership of the contract to a new account (`newOwner`).
637      * Can only be called by the current owner.
638      */
639     function transferOwnership(address newOwner) public virtual onlyOwner {
640         require(newOwner != address(0), "Ownable: new owner is the zero address");
641         emit OwnershipTransferred(_owner, newOwner);
642         _owner = newOwner;
643     }
644 }
645  
646  
647  
648 library SafeMathInt {
649     int256 private constant MIN_INT256 = int256(1) << 255;
650     int256 private constant MAX_INT256 = ~(int256(1) << 255);
651  
652     /**
653      * @dev Multiplies two int256 variables and fails on overflow.
654      */
655     function mul(int256 a, int256 b) internal pure returns (int256) {
656         int256 c = a * b;
657  
658         // Detect overflow when multiplying MIN_INT256 with -1
659         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
660         require((b == 0) || (c / b == a));
661         return c;
662     }
663  
664     /**
665      * @dev Division of two int256 variables and fails on overflow.
666      */
667     function div(int256 a, int256 b) internal pure returns (int256) {
668         // Prevent overflow when dividing MIN_INT256 by -1
669         require(b != -1 || a != MIN_INT256);
670  
671         // Solidity already throws when dividing by 0.
672         return a / b;
673     }
674  
675     /**
676      * @dev Subtracts two int256 variables and fails on overflow.
677      */
678     function sub(int256 a, int256 b) internal pure returns (int256) {
679         int256 c = a - b;
680         require((b >= 0 && c <= a) || (b < 0 && c > a));
681         return c;
682     }
683  
684     /**
685      * @dev Adds two int256 variables and fails on overflow.
686      */
687     function add(int256 a, int256 b) internal pure returns (int256) {
688         int256 c = a + b;
689         require((b >= 0 && c >= a) || (b < 0 && c < a));
690         return c;
691     }
692  
693     /**
694      * @dev Converts to absolute value, and fails on overflow.
695      */
696     function abs(int256 a) internal pure returns (int256) {
697         require(a != MIN_INT256);
698         return a < 0 ? -a : a;
699     }
700  
701  
702     function toUint256Safe(int256 a) internal pure returns (uint256) {
703         require(a >= 0);
704         return uint256(a);
705     }
706 }
707  
708 library SafeMathUint {
709   function toInt256Safe(uint256 a) internal pure returns (int256) {
710     int256 b = int256(a);
711     require(b >= 0);
712     return b;
713   }
714 }
715  
716  
717 interface IUniswapV2Router01 {
718     function factory() external pure returns (address);
719     function WETH() external pure returns (address);
720  
721     function addLiquidity(
722         address tokenA,
723         address tokenB,
724         uint amountADesired,
725         uint amountBDesired,
726         uint amountAMin,
727         uint amountBMin,
728         address to,
729         uint deadline
730     ) external returns (uint amountA, uint amountB, uint liquidity);
731     function addLiquidityETH(
732         address token,
733         uint amountTokenDesired,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline
738     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
739     function removeLiquidity(
740         address tokenA,
741         address tokenB,
742         uint liquidity,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountA, uint amountB);
748     function removeLiquidityETH(
749         address token,
750         uint liquidity,
751         uint amountTokenMin,
752         uint amountETHMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountToken, uint amountETH);
756     function removeLiquidityWithPermit(
757         address tokenA,
758         address tokenB,
759         uint liquidity,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline,
764         bool approveMax, uint8 v, bytes32 r, bytes32 s
765     ) external returns (uint amountA, uint amountB);
766     function removeLiquidityETHWithPermit(
767         address token,
768         uint liquidity,
769         uint amountTokenMin,
770         uint amountETHMin,
771         address to,
772         uint deadline,
773         bool approveMax, uint8 v, bytes32 r, bytes32 s
774     ) external returns (uint amountToken, uint amountETH);
775     function swapExactTokensForTokens(
776         uint amountIn,
777         uint amountOutMin,
778         address[] calldata path,
779         address to,
780         uint deadline
781     ) external returns (uint[] memory amounts);
782     function swapTokensForExactTokens(
783         uint amountOut,
784         uint amountInMax,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
790         external
791         payable
792         returns (uint[] memory amounts);
793     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
794         external
795         returns (uint[] memory amounts);
796     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         returns (uint[] memory amounts);
799     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
800         external
801         payable
802         returns (uint[] memory amounts);
803  
804     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
805     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
806     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
807     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
808     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
809 }
810  
811 interface IUniswapV2Router02 is IUniswapV2Router01 {
812     function removeLiquidityETHSupportingFeeOnTransferTokens(
813         address token,
814         uint liquidity,
815         uint amountTokenMin,
816         uint amountETHMin,
817         address to,
818         uint deadline
819     ) external returns (uint amountETH);
820     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
821         address token,
822         uint liquidity,
823         uint amountTokenMin,
824         uint amountETHMin,
825         address to,
826         uint deadline,
827         bool approveMax, uint8 v, bytes32 r, bytes32 s
828     ) external returns (uint amountETH);
829  
830     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
831         uint amountIn,
832         uint amountOutMin,
833         address[] calldata path,
834         address to,
835         uint deadline
836     ) external;
837     function swapExactETHForTokensSupportingFeeOnTransferTokens(
838         uint amountOutMin,
839         address[] calldata path,
840         address to,
841         uint deadline
842     ) external payable;
843     function swapExactTokensForETHSupportingFeeOnTransferTokens(
844         uint amountIn,
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external;
850 }
851  
852 contract THESYSTEM is ERC20, Ownable {
853     using SafeMath for uint256;
854  
855     IUniswapV2Router02 public immutable uniswapV2Router;
856     address public immutable uniswapV2Pair;
857  
858     bool private swapping;
859  
860     address private marketingWallet;
861     address private devWallet;
862  
863     uint256 public maxTransactionAmount;
864     uint256 public swapTokensAtAmount;
865     uint256 public maxWallet;
866  
867     bool public limitsInEffect = true;
868     bool public tradingActive = true;
869     bool public swapEnabled = true;
870  
871      // Anti-bot and anti-whale mappings and variables
872     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
873  
874     // Seller Map
875     mapping (address => uint256) private _holderFirstBuyTimestamp;
876  
877     // Blacklist Map
878     mapping (address => bool) private _blacklist;
879     bool public transferDelayEnabled = true;
880  
881     uint256 public buyTotalFees;
882     uint256 public buyMarketingFee;
883     uint256 public buyLiquidityFee;
884     uint256 public buyDevFee;
885  
886     uint256 public sellTotalFees;
887     uint256 public sellMarketingFee;
888     uint256 public sellLiquidityFee;
889     uint256 public sellDevFee;
890  
891     uint256 public tokensForMarketing;
892     uint256 public tokensForLiquidity;
893     uint256 public tokensForDev;
894  
895     // block number of opened trading
896     uint256 launchedAt;
897  
898     /******************/
899  
900     // exclude from fees and max transaction amount
901     mapping (address => bool) private _isExcludedFromFees;
902     mapping (address => bool) public _isExcludedMaxTransactionAmount;
903  
904     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
905     // could be subject to a maximum transfer amount
906     mapping (address => bool) public automatedMarketMakerPairs;
907  
908     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
909  
910     event ExcludeFromFees(address indexed account, bool isExcluded);
911  
912     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
913  
914     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
915  
916     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
917  
918     event SwapAndLiquify(
919         uint256 tokensSwapped,
920         uint256 ethReceived,
921         uint256 tokensIntoLiquidity
922     );
923  
924     event AutoNukeLP();
925  
926     event ManualNukeLP();
927  
928     constructor() ERC20("The System", "SYS") {
929  
930         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
931  
932         excludeFromMaxTransaction(address(_uniswapV2Router), true);
933         uniswapV2Router = _uniswapV2Router;
934  
935         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
936         excludeFromMaxTransaction(address(uniswapV2Pair), true);
937         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
938  
939         uint256 _buyMarketingFee = 0;
940         uint256 _buyLiquidityFee = 0;
941         uint256 _buyDevFee = 5;
942  
943         uint256 _sellMarketingFee = 0;
944         uint256 _sellLiquidityFee = 0;
945         uint256 _sellDevFee = 5;
946  
947         uint256 totalSupply = 1 * 1e12 * 1e18;
948  
949         maxTransactionAmount = totalSupply * 10 / 1000; // 0.5% maxTransactionAmountTxn
950         maxWallet = totalSupply * 30 / 1000; // 2% maxWallet
951         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1% swap wallet
952  
953         buyMarketingFee = _buyMarketingFee;
954         buyLiquidityFee = _buyLiquidityFee;
955         buyDevFee = _buyDevFee;
956         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
957  
958         sellMarketingFee = _sellMarketingFee;
959         sellLiquidityFee = _sellLiquidityFee;
960         sellDevFee = _sellDevFee;
961         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
962  
963         marketingWallet = address(owner()); // set as marketing wallet
964         devWallet = address(owner()); // set as dev wallet
965  
966         // exclude from paying fees or having max transaction amount
967         excludeFromFees(owner(), true);
968         excludeFromFees(address(this), true);
969         excludeFromFees(address(0xdead), true);
970  
971         excludeFromMaxTransaction(owner(), true);
972         excludeFromMaxTransaction(address(this), true);
973         excludeFromMaxTransaction(address(0xdead), true);
974  
975         /*
976             _mint is an internal function in ERC20.sol that is only called here,
977             and CANNOT be called ever again
978         */
979         _mint(msg.sender, totalSupply);
980     }
981  
982     receive() external payable {
983  
984     }
985  
986     // once enabled, can never be turned off
987     function enableTrading() external onlyOwner {
988         tradingActive = true;
989         swapEnabled = true;
990         launchedAt = block.number;
991     }
992  
993     // remove limits after token is stable
994     function removeLimits() external onlyOwner returns (bool){
995         limitsInEffect = false;
996         return true;
997     }
998  
999     // disable Transfer delay - cannot be reenabled
1000     function disableTransferDelay() external onlyOwner returns (bool){
1001         transferDelayEnabled = false;
1002         return true;
1003     }
1004  
1005      // change the minimum amount of tokens to sell from fees
1006     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1007         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1008         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1009         swapTokensAtAmount = newAmount;
1010         return true;
1011     }
1012  
1013     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1014         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1015         maxTransactionAmount = newNum * (10**18);
1016     }
1017  
1018     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1019         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1020         maxWallet = newNum * (10**18);
1021     }
1022  
1023     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1024         _isExcludedMaxTransactionAmount[updAds] = isEx;
1025     }
1026  
1027     // only use to disable contract sales if absolutely necessary (emergency use only)
1028     function updateSwapEnabled(bool enabled) external onlyOwner(){
1029         swapEnabled = enabled;
1030     }
1031  
1032     function excludeFromFees(address account, bool excluded) public onlyOwner {
1033         _isExcludedFromFees[account] = excluded;
1034         emit ExcludeFromFees(account, excluded);
1035     }
1036  
1037     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1038         _blacklist[account] = isBlacklisted;
1039     }
1040  
1041     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1042         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1043  
1044         _setAutomatedMarketMakerPair(pair, value);
1045     }
1046  
1047     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1048         automatedMarketMakerPairs[pair] = value;
1049  
1050         emit SetAutomatedMarketMakerPair(pair, value);
1051     }
1052  
1053     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1054         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1055         marketingWallet = newMarketingWallet;
1056     }
1057  
1058     function updateDevWallet(address newWallet) external onlyOwner {
1059         emit devWalletUpdated(newWallet, devWallet);
1060         devWallet = newWallet;
1061     }
1062  
1063  
1064     function isExcludedFromFees(address account) public view returns(bool) {
1065         return _isExcludedFromFees[account];
1066     }
1067  
1068     function _transfer(
1069         address from,
1070         address to,
1071         uint256 amount
1072     ) internal override {
1073         require(from != address(0), "ERC20: transfer from the zero address");
1074         require(to != address(0), "ERC20: transfer to the zero address");
1075         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1076          if(amount == 0) {
1077             super._transfer(from, to, 0);
1078             return;
1079         }
1080  
1081         if(limitsInEffect){
1082             if (
1083                 from != owner() &&
1084                 to != owner() &&
1085                 to != address(0) &&
1086                 to != address(0xdead) &&
1087                 !swapping
1088             ){
1089                 if(!tradingActive){
1090                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1091                 }
1092  
1093                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1094                 if (transferDelayEnabled){
1095                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1096                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1097                         _holderLastTransferTimestamp[tx.origin] = block.number;
1098                     }
1099                 }
1100  
1101                 //when buy
1102                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1103                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1104                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1105                 }
1106  
1107                 //when sell
1108                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1109                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1110                 }
1111                 else if(!_isExcludedMaxTransactionAmount[to]){
1112                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1113                 }
1114             }
1115         }
1116  
1117         uint256 contractTokenBalance = balanceOf(address(this));
1118  
1119         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1120  
1121         if( 
1122             canSwap &&
1123             swapEnabled &&
1124             !swapping &&
1125             !automatedMarketMakerPairs[from] &&
1126             !_isExcludedFromFees[from] &&
1127             !_isExcludedFromFees[to]
1128         ) {
1129             swapping = true;
1130  
1131             swapBack();
1132  
1133             swapping = false;
1134         }
1135  
1136         bool takeFee = !swapping;
1137  
1138         // if any account belongs to _isExcludedFromFee account then remove the fee
1139         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1140             takeFee = false;
1141         }
1142  
1143         uint256 fees = 0;
1144         // only take fees on buys/sells, do not take on wallet transfers
1145         if(takeFee){
1146             // on sell
1147             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1148                 fees = amount.mul(sellTotalFees).div(100);
1149                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1150                 tokensForDev += fees * sellDevFee / sellTotalFees;
1151                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1152             }
1153             // on buy
1154             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1155                 fees = amount.mul(buyTotalFees).div(100);
1156                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1157                 tokensForDev += fees * buyDevFee / buyTotalFees;
1158                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1159             }
1160  
1161             if(fees > 0){    
1162                 super._transfer(from, address(this), fees);
1163             }
1164  
1165             amount -= fees;
1166         }
1167  
1168         super._transfer(from, to, amount);
1169     }
1170  
1171     function swapTokensForEth(uint256 tokenAmount) private {
1172  
1173         // generate the uniswap pair path of token -> weth
1174         address[] memory path = new address[](2);
1175         path[0] = address(this);
1176         path[1] = uniswapV2Router.WETH();
1177  
1178         _approve(address(this), address(uniswapV2Router), tokenAmount);
1179  
1180         // make the swap
1181         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1182             tokenAmount,
1183             0, // accept any amount of ETH
1184             path,
1185             address(this),
1186             block.timestamp
1187         );
1188  
1189     }
1190  
1191     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1192         // approve token transfer to cover all possible scenarios
1193         _approve(address(this), address(uniswapV2Router), tokenAmount);
1194  
1195         // add the liquidity
1196         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1197             address(this),
1198             tokenAmount,
1199             0, // slippage is unavoidable
1200             0, // slippage is unavoidable
1201             address(this),
1202             block.timestamp
1203         );
1204     }
1205  
1206     function swapBack() private {
1207         uint256 contractBalance = balanceOf(address(this));
1208         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1209         bool success;
1210  
1211         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1212  
1213         if(contractBalance > swapTokensAtAmount * 20){
1214           contractBalance = swapTokensAtAmount * 20;
1215         }
1216  
1217         // Halve the amount of liquidity tokens
1218         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1219         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1220  
1221         uint256 initialETHBalance = address(this).balance;
1222  
1223         swapTokensForEth(amountToSwapForETH); 
1224  
1225         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1226  
1227         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1228         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1229         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1230  
1231  
1232         tokensForLiquidity = 0;
1233         tokensForMarketing = 0;
1234         tokensForDev = 0;
1235  
1236         (success,) = address(devWallet).call{value: ethForDev}("");
1237  
1238         if(liquidityTokens > 0 && ethForLiquidity > 0){
1239             addLiquidity(liquidityTokens, ethForLiquidity);
1240             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1241         }
1242  
1243         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1244     }
1245 }