1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.9;
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
173  
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     using SafeMath for uint256;
176  
177     mapping(address => uint256) private _balances;
178  
179     mapping(address => mapping(address => uint256)) private _allowances;
180  
181     uint256 private _totalSupply;
182  
183     string private _name;
184     string private _symbol;
185  
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199  
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206  
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214  
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231  
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238  
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245  
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258  
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265  
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277  
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      * - the caller must have allowance for ``sender``'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public virtual override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
298         return true;
299     }
300  
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
315         return true;
316     }
317  
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
334         return true;
335     }
336  
337     /**
338      * @dev Moves tokens `amount` from `sender` to `recipient`.
339      *
340      * This is internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) internal virtual {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358  
359         _beforeTokenTransfer(sender, recipient, amount);
360  
361         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
362         _balances[recipient] = _balances[recipient].add(amount);
363         emit Transfer(sender, recipient, amount);
364     }
365  
366     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
367      * the total supply.
368      *
369      * Emits a {Transfer} event with `from` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      */
375     function _mint(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: mint to the zero address");
377  
378         _beforeTokenTransfer(address(0), account, amount);
379  
380         _totalSupply = _totalSupply.add(amount);
381         _balances[account] = _balances[account].add(amount);
382         emit Transfer(address(0), account, amount);
383     }
384  
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398  
399         _beforeTokenTransfer(account, address(0), amount);
400  
401         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
402         _totalSupply = _totalSupply.sub(amount);
403         emit Transfer(account, address(0), amount);
404     }
405  
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(
420         address owner,
421         address spender,
422         uint256 amount
423     ) internal virtual {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426  
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430  
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be to transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {}
450 }
451  
452 library SafeMath {
453     /**
454      * @dev Returns the addition of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `+` operator.
458      *
459      * Requirements:
460      *
461      * - Addition cannot overflow.
462      */
463     function add(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a, "SafeMath: addition overflow");
466  
467         return c;
468     }
469  
470     /**
471      * @dev Returns the subtraction of two unsigned integers, reverting on
472      * overflow (when the result is negative).
473      *
474      * Counterpart to Solidity's `-` operator.
475      *
476      * Requirements:
477      *
478      * - Subtraction cannot overflow.
479      */
480     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
481         return sub(a, b, "SafeMath: subtraction overflow");
482     }
483  
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
495         require(b <= a, errorMessage);
496         uint256 c = a - b;
497  
498         return c;
499     }
500  
501     /**
502      * @dev Returns the multiplication of two unsigned integers, reverting on
503      * overflow.
504      *
505      * Counterpart to Solidity's `*` operator.
506      *
507      * Requirements:
508      *
509      * - Multiplication cannot overflow.
510      */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
513         // benefit is lost if 'b' is also tested.
514         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
515         if (a == 0) {
516             return 0;
517         }
518  
519         uint256 c = a * b;
520         require(c / a == b, "SafeMath: multiplication overflow");
521  
522         return c;
523     }
524  
525     /**
526      * @dev Returns the integer division of two unsigned integers. Reverts on
527      * division by zero. The result is rounded towards zero.
528      *
529      * Counterpart to Solidity's `/` operator. Note: this function uses a
530      * `revert` opcode (which leaves remaining gas untouched) while Solidity
531      * uses an invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function div(uint256 a, uint256 b) internal pure returns (uint256) {
538         return div(a, b, "SafeMath: division by zero");
539     }
540  
541     /**
542      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
553     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
554         require(b > 0, errorMessage);
555         uint256 c = a / b;
556         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
557  
558         return c;
559     }
560  
561     /**
562      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
563      * Reverts when dividing by zero.
564      *
565      * Counterpart to Solidity's `%` operator. This function uses a `revert`
566      * opcode (which leaves remaining gas untouched) while Solidity uses an
567      * invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
574         return mod(a, b, "SafeMath: modulo by zero");
575     }
576  
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * Reverts with custom message when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
590         require(b != 0, errorMessage);
591         return a % b;
592     }
593 }
594  
595 contract Ownable is Context {
596     address private _owner;
597  
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599  
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor () {
604         address msgSender = _msgSender();
605         _owner = msgSender;
606         emit OwnershipTransferred(address(0), msgSender);
607     }
608  
609     /**
610      * @dev Returns the address of the current owner.
611      */
612     function owner() public view returns (address) {
613         return _owner;
614     }
615  
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         require(_owner == _msgSender(), "Ownable: caller is not the owner");
621         _;
622     }
623  
624     /**
625      * @dev Leaves the contract without owner. It will not be possible to call
626      * `onlyOwner` functions anymore. Can only be called by the current owner.
627      *
628      * NOTE: Renouncing ownership will leave the contract without an owner,
629      * thereby removing any functionality that is only available to the owner.
630      */
631     function renounceOwnership() public virtual onlyOwner {
632         emit OwnershipTransferred(_owner, address(0));
633         _owner = address(0);
634     }
635  
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      * Can only be called by the current owner.
639      */
640     function transferOwnership(address newOwner) public virtual onlyOwner {
641         require(newOwner != address(0), "Ownable: new owner is the zero address");
642         emit OwnershipTransferred(_owner, newOwner);
643         _owner = newOwner;
644     }
645 }
646  
647  
648  
649 library SafeMathInt {
650     int256 private constant MIN_INT256 = int256(1) << 255;
651     int256 private constant MAX_INT256 = ~(int256(1) << 255);
652  
653     /**
654      * @dev Multiplies two int256 variables and fails on overflow.
655      */
656     function mul(int256 a, int256 b) internal pure returns (int256) {
657         int256 c = a * b;
658  
659         // Detect overflow when multiplying MIN_INT256 with -1
660         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
661         require((b == 0) || (c / b == a));
662         return c;
663     }
664  
665     /**
666      * @dev Division of two int256 variables and fails on overflow.
667      */
668     function div(int256 a, int256 b) internal pure returns (int256) {
669         // Prevent overflow when dividing MIN_INT256 by -1
670         require(b != -1 || a != MIN_INT256);
671  
672         // Solidity already throws when dividing by 0.
673         return a / b;
674     }
675  
676     /**
677      * @dev Subtracts two int256 variables and fails on overflow.
678      */
679     function sub(int256 a, int256 b) internal pure returns (int256) {
680         int256 c = a - b;
681         require((b >= 0 && c <= a) || (b < 0 && c > a));
682         return c;
683     }
684  
685     /**
686      * @dev Adds two int256 variables and fails on overflow.
687      */
688     function add(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a + b;
690         require((b >= 0 && c >= a) || (b < 0 && c < a));
691         return c;
692     }
693  
694     /**
695      * @dev Converts to absolute value, and fails on overflow.
696      */
697     function abs(int256 a) internal pure returns (int256) {
698         require(a != MIN_INT256);
699         return a < 0 ? -a : a;
700     }
701  
702  
703     function toUint256Safe(int256 a) internal pure returns (uint256) {
704         require(a >= 0);
705         return uint256(a);
706     }
707 }
708  
709 library SafeMathUint {
710   function toInt256Safe(uint256 a) internal pure returns (int256) {
711     int256 b = int256(a);
712     require(b >= 0);
713     return b;
714   }
715 }
716  
717  
718 interface IUniswapV2Router01 {
719     function factory() external pure returns (address);
720     function WETH() external pure returns (address);
721  
722     function addLiquidity(
723         address tokenA,
724         address tokenB,
725         uint amountADesired,
726         uint amountBDesired,
727         uint amountAMin,
728         uint amountBMin,
729         address to,
730         uint deadline
731     ) external returns (uint amountA, uint amountB, uint liquidity);
732     function addLiquidityETH(
733         address token,
734         uint amountTokenDesired,
735         uint amountTokenMin,
736         uint amountETHMin,
737         address to,
738         uint deadline
739     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
740     function removeLiquidity(
741         address tokenA,
742         address tokenB,
743         uint liquidity,
744         uint amountAMin,
745         uint amountBMin,
746         address to,
747         uint deadline
748     ) external returns (uint amountA, uint amountB);
749     function removeLiquidityETH(
750         address token,
751         uint liquidity,
752         uint amountTokenMin,
753         uint amountETHMin,
754         address to,
755         uint deadline
756     ) external returns (uint amountToken, uint amountETH);
757     function removeLiquidityWithPermit(
758         address tokenA,
759         address tokenB,
760         uint liquidity,
761         uint amountAMin,
762         uint amountBMin,
763         address to,
764         uint deadline,
765         bool approveMax, uint8 v, bytes32 r, bytes32 s
766     ) external returns (uint amountA, uint amountB);
767     function removeLiquidityETHWithPermit(
768         address token,
769         uint liquidity,
770         uint amountTokenMin,
771         uint amountETHMin,
772         address to,
773         uint deadline,
774         bool approveMax, uint8 v, bytes32 r, bytes32 s
775     ) external returns (uint amountToken, uint amountETH);
776     function swapExactTokensForTokens(
777         uint amountIn,
778         uint amountOutMin,
779         address[] calldata path,
780         address to,
781         uint deadline
782     ) external returns (uint[] memory amounts);
783     function swapTokensForExactTokens(
784         uint amountOut,
785         uint amountInMax,
786         address[] calldata path,
787         address to,
788         uint deadline
789     ) external returns (uint[] memory amounts);
790     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
791         external
792         payable
793         returns (uint[] memory amounts);
794     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
795         external
796         returns (uint[] memory amounts);
797     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
798         external
799         returns (uint[] memory amounts);
800     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
801         external
802         payable
803         returns (uint[] memory amounts);
804  
805     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
806     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
807     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
808     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
809     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
810 }
811  
812 interface IUniswapV2Router02 is IUniswapV2Router01 {
813     function removeLiquidityETHSupportingFeeOnTransferTokens(
814         address token,
815         uint liquidity,
816         uint amountTokenMin,
817         uint amountETHMin,
818         address to,
819         uint deadline
820     ) external returns (uint amountETH);
821     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
822         address token,
823         uint liquidity,
824         uint amountTokenMin,
825         uint amountETHMin,
826         address to,
827         uint deadline,
828         bool approveMax, uint8 v, bytes32 r, bytes32 s
829     ) external returns (uint amountETH);
830  
831     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
832         uint amountIn,
833         uint amountOutMin,
834         address[] calldata path,
835         address to,
836         uint deadline
837     ) external;
838     function swapExactETHForTokensSupportingFeeOnTransferTokens(
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external payable;
844     function swapExactTokensForETHSupportingFeeOnTransferTokens(
845         uint amountIn,
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external;
851 }
852  
853 contract HexMachine is ERC20, Ownable {
854     using SafeMath for uint256;
855  
856     IUniswapV2Router02 public immutable uniswapV2Router;
857     address public immutable uniswapV2Pair;
858  
859     bool private swapping;
860  
861     address private marketingWallet;
862     address private devWallet;
863  
864     uint256 public maxTransactionAmount;
865     uint256 public swapTokensAtAmount;
866     uint256 public maxWallet;
867  
868     bool public limitsInEffect = true;
869     bool public tradingActive = false;
870     bool public swapEnabled = false;
871  
872      // Anti-bot and anti-whale mappings and variables
873     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
874  
875     // Seller Map
876     mapping (address => uint256) private _holderFirstBuyTimestamp;
877  
878     // Blacklist Map
879     mapping (address => bool) private _blacklist;
880     bool public transferDelayEnabled = true;
881  
882     uint256 public buyTotalFees;
883     uint256 public buyMarketingFee;
884     uint256 public buyLiquidityFee;
885     uint256 public buyDevFee;
886  
887     uint256 public sellTotalFees;
888     uint256 public sellMarketingFee;
889     uint256 public sellLiquidityFee;
890     uint256 public sellDevFee;
891  
892     uint256 public tokensForMarketing;
893     uint256 public tokensForLiquidity;
894     uint256 public tokensForDev;
895  
896     // block number of opened trading
897     uint256 launchedAt;
898  
899     /******************/
900  
901     // exclude from fees and max transaction amount
902     mapping (address => bool) private _isExcludedFromFees;
903     mapping (address => bool) public _isExcludedMaxTransactionAmount;
904  
905     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
906     // could be subject to a maximum transfer amount
907     mapping (address => bool) public automatedMarketMakerPairs;
908  
909     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
910  
911     event ExcludeFromFees(address indexed account, bool isExcluded);
912  
913     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
914  
915     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
916  
917     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
918  
919     event SwapAndLiquify(
920         uint256 tokensSwapped,
921         uint256 ethReceived,
922         uint256 tokensIntoLiquidity
923     );
924  
925     event AutoNukeLP();
926  
927     event ManualNukeLP();
928  
929     constructor() ERC20("Hex Machine", "HEXM") {
930  
931         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
932  
933         excludeFromMaxTransaction(address(_uniswapV2Router), true);
934         uniswapV2Router = _uniswapV2Router;
935  
936         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
937         excludeFromMaxTransaction(address(uniswapV2Pair), true);
938         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
939  
940         uint256 _buyMarketingFee = 5;
941         uint256 _buyLiquidityFee = 0;
942         uint256 _buyDevFee = 0;
943  
944         uint256 _sellMarketingFee = 5;
945         uint256 _sellLiquidityFee = 0;
946         uint256 _sellDevFee = 0;
947  
948         uint256 totalSupply = 1 * 1e9 * 1e18;
949  
950         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
951         maxWallet = totalSupply * 20 / 1000; // 2% 
952         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
953  
954         buyMarketingFee = _buyMarketingFee;
955         buyLiquidityFee = _buyLiquidityFee;
956         buyDevFee = _buyDevFee;
957         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
958  
959         sellMarketingFee = _sellMarketingFee;
960         sellLiquidityFee = _sellLiquidityFee;
961         sellDevFee = _sellDevFee;
962         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
963  
964         marketingWallet = address(owner()); // set as marketing wallet
965         devWallet = address(owner()); // set as dev wallet
966  
967         // exclude from paying fees or having max transaction amount
968         excludeFromFees(owner(), true);
969         excludeFromFees(address(this), true);
970         excludeFromFees(address(0xdead), true);
971  
972         excludeFromMaxTransaction(owner(), true);
973         excludeFromMaxTransaction(address(this), true);
974         excludeFromMaxTransaction(address(0xdead), true);
975  
976         /*
977             _mint is an internal function in ERC20.sol that is only called here,
978             and CANNOT be called ever again
979         */
980         _mint(msg.sender, totalSupply);
981     }
982  
983     receive() external payable {
984  
985     }
986  
987     // once enabled, can never be turned off
988     function enableTrading() external onlyOwner {
989         tradingActive = true;
990         swapEnabled = true;
991         launchedAt = block.number;
992     }
993  
994     // remove limits after token is stable
995     function removeLimits() external onlyOwner returns (bool){
996         limitsInEffect = false;
997         return true;
998     }
999  
1000     // disable Transfer delay - cannot be reenabled
1001     function disableTransferDelay() external onlyOwner returns (bool){
1002         transferDelayEnabled = false;
1003         return true;
1004     }
1005  
1006      // change the minimum amount of tokens to sell from fees
1007     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1008         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1009         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1010         swapTokensAtAmount = newAmount;
1011         return true;
1012     }
1013  
1014     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1015         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1016         maxTransactionAmount = newNum * (10**18);
1017     }
1018  
1019     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1020         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1021         maxWallet = newNum * (10**18);
1022     }
1023  
1024     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1025         _isExcludedMaxTransactionAmount[updAds] = isEx;
1026     }
1027 
1028           function updateBuyFees(
1029         uint256 _devFee,
1030         uint256 _liquidityFee,
1031         uint256 _marketingFee
1032     ) external onlyOwner {
1033         buyDevFee = _devFee;
1034         buyLiquidityFee = _liquidityFee;
1035         buyMarketingFee = _marketingFee;
1036         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1037         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1038     }
1039 
1040     function updateSellFees(
1041         uint256 _devFee,
1042         uint256 _liquidityFee,
1043         uint256 _marketingFee
1044     ) external onlyOwner {
1045         sellDevFee = _devFee;
1046         sellLiquidityFee = _liquidityFee;
1047         sellMarketingFee = _marketingFee;
1048         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1049         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1050     }
1051  
1052     // only use to disable contract sales if absolutely necessary (emergency use only)
1053     function updateSwapEnabled(bool enabled) external onlyOwner(){
1054         swapEnabled = enabled;
1055     }
1056  
1057     function excludeFromFees(address account, bool excluded) public onlyOwner {
1058         _isExcludedFromFees[account] = excluded;
1059         emit ExcludeFromFees(account, excluded);
1060     }
1061  
1062     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1063         _blacklist[account] = isBlacklisted;
1064     }
1065  
1066     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1067         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1068  
1069         _setAutomatedMarketMakerPair(pair, value);
1070     }
1071  
1072     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1073         automatedMarketMakerPairs[pair] = value;
1074  
1075         emit SetAutomatedMarketMakerPair(pair, value);
1076     }
1077  
1078     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1079         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1080         marketingWallet = newMarketingWallet;
1081     }
1082  
1083     function updateDevWallet(address newWallet) external onlyOwner {
1084         emit devWalletUpdated(newWallet, devWallet);
1085         devWallet = newWallet;
1086     }
1087  
1088  
1089     function isExcludedFromFees(address account) public view returns(bool) {
1090         return _isExcludedFromFees[account];
1091     }
1092  
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal override {
1098         require(from != address(0), "ERC20: transfer from the zero address");
1099         require(to != address(0), "ERC20: transfer to the zero address");
1100         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1101          if(amount == 0) {
1102             super._transfer(from, to, 0);
1103             return;
1104         }
1105  
1106         if(limitsInEffect){
1107             if (
1108                 from != owner() &&
1109                 to != owner() &&
1110                 to != address(0) &&
1111                 to != address(0xdead) &&
1112                 !swapping
1113             ){
1114                 if(!tradingActive){
1115                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1116                 }
1117  
1118                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1119                 if (transferDelayEnabled){
1120                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1121                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1122                         _holderLastTransferTimestamp[tx.origin] = block.number;
1123                     }
1124                 }
1125  
1126                 //when buy
1127                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1128                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1129                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1130                 }
1131  
1132                 //when sell
1133                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1134                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1135                 }
1136                 else if(!_isExcludedMaxTransactionAmount[to]){
1137                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1138                 }
1139             }
1140         }
1141  
1142         uint256 contractTokenBalance = balanceOf(address(this));
1143  
1144         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1145  
1146         if( 
1147             canSwap &&
1148             swapEnabled &&
1149             !swapping &&
1150             !automatedMarketMakerPairs[from] &&
1151             !_isExcludedFromFees[from] &&
1152             !_isExcludedFromFees[to]
1153         ) {
1154             swapping = true;
1155  
1156             swapBack();
1157  
1158             swapping = false;
1159         }
1160  
1161         bool takeFee = !swapping;
1162  
1163         // if any account belongs to _isExcludedFromFee account then remove the fee
1164         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1165             takeFee = false;
1166         }
1167  
1168         uint256 fees = 0;
1169         // only take fees on buys/sells, do not take on wallet transfers
1170         if(takeFee){
1171             // on sell
1172             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1173                 fees = amount.mul(sellTotalFees).div(100);
1174                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1175                 tokensForDev += fees * sellDevFee / sellTotalFees;
1176                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1177             }
1178             // on buy
1179             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1180                 fees = amount.mul(buyTotalFees).div(100);
1181                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1182                 tokensForDev += fees * buyDevFee / buyTotalFees;
1183                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1184             }
1185  
1186             if(fees > 0){    
1187                 super._transfer(from, address(this), fees);
1188             }
1189  
1190             amount -= fees;
1191         }
1192  
1193         super._transfer(from, to, amount);
1194     }
1195  
1196     function swapTokensForEth(uint256 tokenAmount) private {
1197  
1198         // generate the uniswap pair path of token -> weth
1199         address[] memory path = new address[](2);
1200         path[0] = address(this);
1201         path[1] = uniswapV2Router.WETH();
1202  
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204  
1205         // make the swap
1206         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1207             tokenAmount,
1208             0, // accept any amount of ETH
1209             path,
1210             address(this),
1211             block.timestamp
1212         );
1213  
1214     }
1215  
1216     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1217         // approve token transfer to cover all possible scenarios
1218         _approve(address(this), address(uniswapV2Router), tokenAmount);
1219  
1220         // add the liquidity
1221         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1222             address(this),
1223             tokenAmount,
1224             0, // slippage is unavoidable
1225             0, // slippage is unavoidable
1226             address(this),
1227             block.timestamp
1228         );
1229     }
1230  
1231     function swapBack() private {
1232         uint256 contractBalance = balanceOf(address(this));
1233         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1234         bool success;
1235  
1236         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1237  
1238         if(contractBalance > swapTokensAtAmount * 20){
1239           contractBalance = swapTokensAtAmount * 20;
1240         }
1241  
1242         // Halve the amount of liquidity tokens
1243         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1244         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1245  
1246         uint256 initialETHBalance = address(this).balance;
1247  
1248         swapTokensForEth(amountToSwapForETH); 
1249  
1250         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1251  
1252         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1253         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1254         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1255  
1256  
1257         tokensForLiquidity = 0;
1258         tokensForMarketing = 0;
1259         tokensForDev = 0;
1260  
1261         (success,) = address(devWallet).call{value: ethForDev}("");
1262  
1263         if(liquidityTokens > 0 && ethForLiquidity > 0){
1264             addLiquidity(liquidityTokens, ethForLiquidity);
1265             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1266         }
1267  
1268         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1269     }
1270 }