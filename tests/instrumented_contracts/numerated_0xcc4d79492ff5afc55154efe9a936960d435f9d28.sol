1 // SPDX-License-Identifier: MIT
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
853 contract STARLIGHT is ERC20, Ownable {
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
864     uint256 private maxTransactionAmount;
865     uint256 private swapTokensAtAmount;
866     uint256 private maxWallet;
867  
868     bool private limitsInEffect = true;
869     bool private tradingActive = false;
870     bool public swapEnabled = false;
871     bool public enableEarlySellTax = true;
872  
873      // Anti-bot and anti-whale mappings and variables
874     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
875  
876     // Seller Map
877     mapping (address => uint256) private _holderFirstBuyTimestamp;
878  
879     // Blacklist Map
880     mapping (address => bool) private _blacklist;
881     bool public transferDelayEnabled = true;
882  
883     uint256 private buyTotalFees;
884     uint256 private buyMarketingFee;
885     uint256 private buyLiquidityFee;
886     uint256 private buyDevFee;
887  
888     uint256 private sellTotalFees;
889     uint256 private sellMarketingFee;
890     uint256 private sellLiquidityFee;
891     uint256 private sellDevFee;
892  
893     uint256 private earlySellLiquidityFee;
894     uint256 private earlySellMarketingFee;
895     uint256 private earlySellDevFee;
896  
897     uint256 private tokensForMarketing;
898     uint256 private tokensForLiquidity;
899     uint256 private tokensForDev;
900  
901     // block number of opened trading
902     uint256 launchedAt;
903  
904     /******************/
905  
906     // exclude from fees and max transaction amount
907     mapping (address => bool) private _isExcludedFromFees;
908     mapping (address => bool) public _isExcludedMaxTransactionAmount;
909  
910     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
911     // could be subject to a maximum transfer amount
912     mapping (address => bool) public automatedMarketMakerPairs;
913  
914     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
915  
916     event ExcludeFromFees(address indexed account, bool isExcluded);
917  
918     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
919  
920     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
921  
922     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
923  
924     event SwapAndLiquify(
925         uint256 tokensSwapped,
926         uint256 ethReceived,
927         uint256 tokensIntoLiquidity
928     );
929  
930     event AutoNukeLP();
931  
932     event ManualNukeLP();
933  
934     constructor() ERC20("Starlight Inu", "INUL") {
935  
936         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
937  
938         excludeFromMaxTransaction(address(_uniswapV2Router), true);
939         uniswapV2Router = _uniswapV2Router;
940  
941         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
942         excludeFromMaxTransaction(address(uniswapV2Pair), true);
943         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
944  
945         uint256 _buyMarketingFee = 3;
946         uint256 _buyLiquidityFee = 0;
947         uint256 _buyDevFee = 0;
948  
949         uint256 _sellMarketingFee = 3;
950         uint256 _sellLiquidityFee = 0;
951         uint256 _sellDevFee = 0;
952  
953         uint256 _earlySellLiquidityFee = 0;
954         uint256 _earlySellMarketingFee = 3;
955 	    uint256 _earlySellDevFee = 0
956  
957     ; uint256 totalSupply = 8 * 1e13 * 1e18;
958  
959         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
960         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
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
975 	earlySellDevFee = _earlySellDevFee;
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
1055         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1056     }
1057  
1058     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1059         sellMarketingFee = _marketingFee;
1060         sellLiquidityFee = _liquidityFee;
1061         sellDevFee = _devFee;
1062         earlySellLiquidityFee = _earlySellLiquidityFee;
1063         earlySellMarketingFee = _earlySellMarketingFee;
1064 	    earlySellDevFee = _earlySellDevFee;
1065         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1066         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
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
1168                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1169                 sellLiquidityFee = earlySellLiquidityFee;
1170                 sellMarketingFee = earlySellMarketingFee;
1171 		        sellDevFee = earlySellDevFee;
1172                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1173             } else {
1174                 sellLiquidityFee = 0;
1175                 sellMarketingFee = 4;
1176                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1177             }
1178         } else {
1179             if (_holderFirstBuyTimestamp[to] == 0) {
1180                 _holderFirstBuyTimestamp[to] = block.timestamp;
1181             }
1182  
1183             if (!enableEarlySellTax) {
1184                 sellLiquidityFee = 0;
1185                 sellMarketingFee = 4;
1186 		        sellDevFee = 0;
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