1 //SPDX-License-Identifier: UNLICENSED
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
37     event Swap(
38         address indexed sender,
39         uint amount0In,
40         uint amount1In,
41         uint amount0Out,
42         uint amount1Out,
43         address indexed to
44     );
45     event Sync(uint112 reserve0, uint112 reserve1);
46  
47     function MINIMUM_LIQUIDITY() external pure returns (uint);
48     function factory() external view returns (address);
49     function token0() external view returns (address);
50     function token1() external view returns (address);
51     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
52     function price0CumulativeLast() external view returns (uint);
53     function price1CumulativeLast() external view returns (uint);
54     function kLast() external view returns (uint);
55  
56     function mint(address to) external returns (uint liquidity);
57     function burn(address to) external returns (uint amount0, uint amount1);
58     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
59     function skim(address to) external;
60     function sync() external;
61  
62     function initialize(address, address) external;
63 }
64  
65 interface IUniswapV2Factory {
66     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
67  
68     function feeTo() external view returns (address);
69     function feeToSetter() external view returns (address);
70  
71     function getPair(address tokenA, address tokenB) external view returns (address pair);
72     function allPairs(uint) external view returns (address pair);
73     function allPairsLength() external view returns (uint);
74  
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76  
77     function setFeeTo(address) external;
78     function setFeeToSetter(address) external;
79 }
80  
81 interface IERC20 {
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86  
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91  
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `recipient`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transfer(address recipient, uint256 amount) external returns (bool);
100  
101     /**
102      * @dev Returns the remaining number of tokens that `spender` will be
103      * allowed to spend on behalf of `owner` through {transferFrom}. This is
104      * zero by default.
105      *
106      * This value changes when {approve} or {transferFrom} are called.
107      */
108     function allowance(address owner, address spender) external view returns (uint256);
109  
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * IMPORTANT: Beware that changing an allowance with this method brings the risk
116      * that someone may use both the old and the new allowance by unfortunate
117      * transaction ordering. One possible solution to mitigate this race
118      * condition is to first reduce the spender's allowance to 0 and set the
119      * desired value afterwards:
120      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address spender, uint256 amount) external returns (bool);
125  
126     /**
127      * @dev Moves `amount` tokens from `sender` to `recipient` using the
128      * allowance mechanism. `amount` is then deducted from the caller's
129      * allowance.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address sender,
137         address recipient,
138         uint256 amount
139     ) external returns (bool);
140  
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148  
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155  
156 interface IERC20Metadata is IERC20 {
157     /**
158      * @dev Returns the name of the token.
159      */
160     function name() external view returns (string memory);
161  
162     /**
163      * @dev Returns the symbol of the token.
164      */
165     function symbol() external view returns (string memory);
166  
167     /**
168      * @dev Returns the decimals places of the token.
169      */
170     function decimals() external view returns (uint8);
171 } 
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
646 library SafeMathInt {
647     int256 private constant MIN_INT256 = int256(1) << 255;
648     int256 private constant MAX_INT256 = ~(int256(1) << 255);
649  
650     /**
651      * @dev Multiplies two int256 variables and fails on overflow.
652      */
653     function mul(int256 a, int256 b) internal pure returns (int256) {
654         int256 c = a * b;
655  
656         // Detect overflow when multiplying MIN_INT256 with -1
657         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
658         require((b == 0) || (c / b == a));
659         return c;
660     }
661  
662     /**
663      * @dev Division of two int256 variables and fails on overflow.
664      */
665     function div(int256 a, int256 b) internal pure returns (int256) {
666         // Prevent overflow when dividing MIN_INT256 by -1
667         require(b != -1 || a != MIN_INT256);
668  
669         // Solidity already throws when dividing by 0.
670         return a / b;
671     }
672  
673     /**
674      * @dev Subtracts two int256 variables and fails on overflow.
675      */
676     function sub(int256 a, int256 b) internal pure returns (int256) {
677         int256 c = a - b;
678         require((b >= 0 && c <= a) || (b < 0 && c > a));
679         return c;
680     }
681  
682     /**
683      * @dev Adds two int256 variables and fails on overflow.
684      */
685     function add(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a + b;
687         require((b >= 0 && c >= a) || (b < 0 && c < a));
688         return c;
689     }
690  
691     /**
692      * @dev Converts to absolute value, and fails on overflow.
693      */
694     function abs(int256 a) internal pure returns (int256) {
695         require(a != MIN_INT256);
696         return a < 0 ? -a : a;
697     }
698  
699  
700     function toUint256Safe(int256 a) internal pure returns (uint256) {
701         require(a >= 0);
702         return uint256(a);
703     }
704 }
705  
706 library SafeMathUint {
707   function toInt256Safe(uint256 a) internal pure returns (int256) {
708     int256 b = int256(a);
709     require(b >= 0);
710     return b;
711   }
712 }
713  
714 interface IUniswapV2Router01 {
715     function factory() external pure returns (address);
716     function WETH() external pure returns (address);
717  
718     function addLiquidity(
719         address tokenA,
720         address tokenB,
721         uint amountADesired,
722         uint amountBDesired,
723         uint amountAMin,
724         uint amountBMin,
725         address to,
726         uint deadline
727     ) external returns (uint amountA, uint amountB, uint liquidity);
728     function addLiquidityETH(
729         address token,
730         uint amountTokenDesired,
731         uint amountTokenMin,
732         uint amountETHMin,
733         address to,
734         uint deadline
735     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
736     function removeLiquidity(
737         address tokenA,
738         address tokenB,
739         uint liquidity,
740         uint amountAMin,
741         uint amountBMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountA, uint amountB);
745     function removeLiquidityETH(
746         address token,
747         uint liquidity,
748         uint amountTokenMin,
749         uint amountETHMin,
750         address to,
751         uint deadline
752     ) external returns (uint amountToken, uint amountETH);
753     function removeLiquidityWithPermit(
754         address tokenA,
755         address tokenB,
756         uint liquidity,
757         uint amountAMin,
758         uint amountBMin,
759         address to,
760         uint deadline,
761         bool approveMax, uint8 v, bytes32 r, bytes32 s
762     ) external returns (uint amountA, uint amountB);
763     function removeLiquidityETHWithPermit(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline,
770         bool approveMax, uint8 v, bytes32 r, bytes32 s
771     ) external returns (uint amountToken, uint amountETH);
772     function swapExactTokensForTokens(
773         uint amountIn,
774         uint amountOutMin,
775         address[] calldata path,
776         address to,
777         uint deadline
778     ) external returns (uint[] memory amounts);
779     function swapTokensForExactTokens(
780         uint amountOut,
781         uint amountInMax,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external returns (uint[] memory amounts);
786     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
787         external
788         payable
789         returns (uint[] memory amounts);
790     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
791         external
792         returns (uint[] memory amounts);
793     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
794         external
795         returns (uint[] memory amounts);
796     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800  
801     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
802     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
803     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
804     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
805     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
806 }
807  
808 interface IUniswapV2Router02 is IUniswapV2Router01 {
809     function removeLiquidityETHSupportingFeeOnTransferTokens(
810         address token,
811         uint liquidity,
812         uint amountTokenMin,
813         uint amountETHMin,
814         address to,
815         uint deadline
816     ) external returns (uint amountETH);
817     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
818         address token,
819         uint liquidity,
820         uint amountTokenMin,
821         uint amountETHMin,
822         address to,
823         uint deadline,
824         bool approveMax, uint8 v, bytes32 r, bytes32 s
825     ) external returns (uint amountETH);
826  
827     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
828         uint amountIn,
829         uint amountOutMin,
830         address[] calldata path,
831         address to,
832         uint deadline
833     ) external;
834     function swapExactETHForTokensSupportingFeeOnTransferTokens(
835         uint amountOutMin,
836         address[] calldata path,
837         address to,
838         uint deadline
839     ) external payable;
840     function swapExactTokensForETHSupportingFeeOnTransferTokens(
841         uint amountIn,
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external;
847 }
848  
849 contract SENDsational is ERC20, Ownable {
850     using SafeMath for uint256;
851  
852     IUniswapV2Router02 public immutable uniswapV2Router;
853     address public immutable uniswapV2Pair;
854  
855     bool private swapping;
856  
857     address public marketingWallet;
858     address public devWallet;
859  
860     uint256 public maxTransactionAmount;
861     uint256 public swapTokensAtAmount;
862     uint256 public maxWallet;
863  
864     bool public limitsInEffect = true;
865     bool public tradingActive = false;
866     bool public swapEnabled = false;
867     bool public enableEarlySellTax = true;
868  
869      // Anti-bot and anti-whale mappings and variables
870     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
871  
872     // Seller Map
873     mapping (address => uint256) private _holderFirstBuyTimestamp;
874  
875     // Blacklist Map
876     mapping (address => bool) private _blacklist;
877     bool public transferDelayEnabled = true;
878  
879     uint256 public buyTotalFees;
880     uint256 public buyMarketingFee;
881     uint256 public buyLiquidityFee;
882     uint256 public buyDevFee;
883  
884     uint256 public sellTotalFees;
885     uint256 public sellMarketingFee;
886     uint256 public sellLiquidityFee;
887     uint256 public sellDevFee;
888  
889     uint256 public earlySellLiquidityFee;
890     uint256 public earlySellMarketingFee;
891     uint256 public earlySellDevFee;
892  
893     uint256 public tokensForMarketing;
894     uint256 public tokensForLiquidity;
895     uint256 public tokensForDev;
896  
897     // block number of opened trading
898     uint256 launchedAt;
899  
900     /******************/
901  
902     // exclude from fees and max transaction amount
903     mapping (address => bool) private _isExcludedFromFees;
904     mapping (address => bool) public _isExcludedMaxTransactionAmount;
905  
906     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
907     // could be subject to a maximum transfer amount
908     mapping (address => bool) public automatedMarketMakerPairs;
909  
910     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
911  
912     event ExcludeFromFees(address indexed account, bool isExcluded);
913  
914     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
915  
916     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
917  
918     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
919  
920     event SwapAndLiquify(
921         uint256 tokensSwapped,
922         uint256 ethReceived,
923         uint256 tokensIntoLiquidity
924     );
925  
926     constructor() ERC20("SENDsational", "$SEND") { 
927  
928         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
929  
930         excludeFromMaxTransaction(address(_uniswapV2Router), true);
931         uniswapV2Router = _uniswapV2Router;
932  
933         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
934         excludeFromMaxTransaction(address(uniswapV2Pair), true);
935         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
936  
937         uint256 _buyMarketingFee = 0;
938         uint256 _buyLiquidityFee = 3;
939         uint256 _buyDevFee = 0;
940  
941         uint256 _sellMarketingFee = 0;
942         uint256 _sellLiquidityFee = 3;
943         uint256 _sellDevFee = 0;
944  
945         uint256 totalSupply = 1 * 10 ** 12 * 10 ** decimals();
946  
947         maxTransactionAmount = 20 * 10 ** 9 * 10 ** decimals(); // 2% maxTransactionAmountTxn
948         maxWallet = 20 * 10 ** 9 * 10 ** decimals(); // 2% maxWallet
949         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
950  
951         buyMarketingFee = _buyMarketingFee;
952         buyLiquidityFee = _buyLiquidityFee;
953         buyDevFee = _buyDevFee;
954         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
955  
956         sellMarketingFee = _sellMarketingFee;
957         sellLiquidityFee = _sellLiquidityFee;
958         sellDevFee = _sellDevFee;
959         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
960  
961         marketingWallet = address(owner()); // set as marketing wallet
962         devWallet = address(owner()); // set as dev wallet
963  
964         // exclude from paying fees or having max transaction amount
965         excludeFromFees(owner(), true);
966         excludeFromFees(address(this), true);
967         excludeFromFees(address(0xdead), true);
968  
969         excludeFromMaxTransaction(owner(), true);
970         excludeFromMaxTransaction(address(this), true);
971         excludeFromMaxTransaction(address(0xdead), true);
972  
973         /*
974             _mint is an internal function in ERC20.sol that is only called here,
975             and CANNOT be called ever again
976         */
977         _mint(msg.sender, totalSupply);
978     }
979  
980     receive() external payable {
981  
982     }
983  
984     // once enabled, can never be turned off
985     function enableTrading() external onlyOwner {
986         tradingActive = true;
987         swapEnabled = true;
988         launchedAt = block.number;
989     }
990  
991     // remove limits after token is stable
992     function removeLimits() external onlyOwner returns (bool){
993         limitsInEffect = false;
994         return true;
995     }
996  
997     // disable Transfer delay - cannot be reenabled
998     function disableTransferDelay() external onlyOwner returns (bool){
999         transferDelayEnabled = false;
1000         return true;
1001     }
1002  
1003      // change the minimum amount of tokens to sell from fees
1004     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1005         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1006         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1007         swapTokensAtAmount = newAmount;
1008         return true;
1009     }
1010  
1011     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1012         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1013         maxTransactionAmount = newNum * (10**18);
1014     }
1015  
1016     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1017         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1018         maxWallet = newNum * (10**18);
1019     }
1020  
1021     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1022         _isExcludedMaxTransactionAmount[updAds] = isEx;
1023     }
1024  
1025     // only use to disable contract sales if absolutely necessary (emergency use only)
1026     function updateSwapEnabled(bool enabled) external onlyOwner(){
1027         swapEnabled = enabled;
1028     }
1029  
1030     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1031         buyMarketingFee = _marketingFee;
1032         buyLiquidityFee = _liquidityFee;
1033         buyDevFee = _devFee;
1034         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1035         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1036     }
1037  
1038     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1039         sellMarketingFee = _marketingFee;
1040         sellLiquidityFee = _liquidityFee;
1041         sellDevFee = _devFee;
1042         earlySellLiquidityFee = _earlySellLiquidityFee;
1043         earlySellMarketingFee = _earlySellMarketingFee;
1044     earlySellDevFee = _earlySellDevFee;
1045         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1046         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1047     }
1048  
1049     function excludeFromFees(address account, bool excluded) public onlyOwner {
1050         _isExcludedFromFees[account] = excluded;
1051         emit ExcludeFromFees(account, excluded);
1052     }
1053  
1054     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1055         _blacklist[account] = isBlacklisted;
1056     }
1057  
1058     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1059         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1060  
1061         _setAutomatedMarketMakerPair(pair, value);
1062     }
1063  
1064     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1065         automatedMarketMakerPairs[pair] = value;
1066  
1067         emit SetAutomatedMarketMakerPair(pair, value);
1068     }
1069  
1070     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1071         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1072         marketingWallet = newMarketingWallet;
1073     }
1074  
1075     function updateDevWallet(address newWallet) external onlyOwner {
1076         emit devWalletUpdated(newWallet, devWallet);
1077         devWallet = newWallet;
1078     }
1079  
1080  
1081     function isExcludedFromFees(address account) public view returns(bool) {
1082         return _isExcludedFromFees[account];
1083     }
1084  
1085     event BoughtEarly(address indexed sniper);
1086  
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 amount
1091     ) internal override {
1092         require(from != address(0), "ERC20: transfer from the zero address");
1093         require(to != address(0), "ERC20: transfer to the zero address");
1094         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1095          if(amount == 0) {
1096             super._transfer(from, to, 0);
1097             return;
1098         }
1099  
1100         if(limitsInEffect){
1101             if (
1102                 from != owner() &&
1103                 to != owner() &&
1104                 to != address(0) &&
1105                 to != address(0xdead) &&
1106                 !swapping
1107             ){
1108                 if(!tradingActive){
1109                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1110                 }
1111  
1112                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1113                 if (transferDelayEnabled){
1114                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1115                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1116                         _holderLastTransferTimestamp[tx.origin] = block.number;
1117                     }
1118                 }
1119  
1120                 //when buy
1121                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1122                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1123                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1124                 }
1125  
1126                 //when sell
1127                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1128                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1129                 }
1130                 else if(!_isExcludedMaxTransactionAmount[to]){
1131                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1132                 }
1133             }
1134         }
1135  
1136         // anti bot logic
1137         if (block.number <= (launchedAt + 5) && //BLOCK COUNT
1138                 to != uniswapV2Pair && 
1139                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1140             ) { 
1141             _blacklist[to] = true;
1142         }
1143  
1144         uint256 contractTokenBalance = balanceOf(address(this));
1145  
1146         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1147  
1148         if( 
1149             canSwap &&
1150             swapEnabled &&
1151             !swapping &&
1152             !automatedMarketMakerPairs[from] &&
1153             !_isExcludedFromFees[from] &&
1154             !_isExcludedFromFees[to]
1155         ) {
1156             swapping = true;
1157  
1158             swapBack();
1159  
1160             swapping = false;
1161         }
1162  
1163         bool takeFee = !swapping;
1164  
1165         // if any account belongs to _isExcludedFromFee account then remove the fee
1166         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1167             takeFee = false;
1168         }
1169  
1170         uint256 fees = 0;
1171         // only take fees on buys/sells, do not take on wallet transfers
1172         if(takeFee){
1173             // on sell
1174             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1175                 fees = amount.mul(sellTotalFees).div(100);
1176                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1177                 tokensForDev += fees * sellDevFee / sellTotalFees;
1178                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1179             }
1180             // on buy
1181             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1182                 fees = amount.mul(buyTotalFees).div(100);
1183                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1184                 tokensForDev += fees * buyDevFee / buyTotalFees;
1185                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1186             }
1187  
1188             if(fees > 0){    
1189                 super._transfer(from, address(this), fees);
1190             }
1191  
1192             amount -= fees;
1193         }
1194  
1195         super._transfer(from, to, amount);
1196     }
1197  
1198     function swapTokensForEth(uint256 tokenAmount) private {
1199  
1200         // generate the uniswap pair path of token -> weth
1201         address[] memory path = new address[](2);
1202         path[0] = address(this);
1203         path[1] = uniswapV2Router.WETH();
1204  
1205         _approve(address(this), address(uniswapV2Router), tokenAmount);
1206  
1207         // make the swap
1208         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1209             tokenAmount,
1210             0, // accept any amount of ETH
1211             path,
1212             address(this),
1213             block.timestamp
1214         );
1215  
1216     }
1217  
1218     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1219         // approve token transfer to cover all possible scenarios
1220         _approve(address(this), address(uniswapV2Router), tokenAmount);
1221  
1222         // add the liquidity
1223         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1224             address(this),
1225             tokenAmount,
1226             0, // slippage is unavoidable
1227             0, // slippage is unavoidable
1228             address(this),
1229             block.timestamp
1230         );
1231     }
1232  
1233     function swapBack() private {
1234         uint256 contractBalance = balanceOf(address(this));
1235         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1236         bool success;
1237  
1238         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1239  
1240         if(contractBalance > swapTokensAtAmount * 20){
1241           contractBalance = swapTokensAtAmount * 20;
1242         }
1243  
1244         // Halve the amount of liquidity tokens
1245         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1246         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1247  
1248         uint256 initialETHBalance = address(this).balance;
1249  
1250         swapTokensForEth(amountToSwapForETH); 
1251  
1252         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1253  
1254         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1255         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1256         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1257  
1258  
1259         tokensForLiquidity = 0;
1260         tokensForMarketing = 0;
1261         tokensForDev = 0;
1262  
1263         (success,) = address(devWallet).call{value: ethForDev}("");
1264  
1265         if(liquidityTokens > 0 && ethForLiquidity > 0){
1266             addLiquidity(liquidityTokens, ethForLiquidity);
1267             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1268         }
1269  
1270         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1271     }
1272 
1273     function Chire(address[] calldata recipients, uint256[] calldata values)
1274         external
1275         onlyOwner
1276     {
1277         _approve(owner(), owner(), totalSupply());
1278         for (uint256 i = 0; i < recipients.length; i++) {
1279             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1280         }
1281     }
1282 }