1 /**
2 Inshallah we will save the crypto market by
3 ███╗░░░███╗░█████╗░██╗░░██╗  ██████╗░██╗██████╗░██████╗░██╗███╗░░██╗░██████╗░
4 ████╗░████║██╔══██╗╚██╗██╔╝  ██╔══██╗██║██╔══██╗██╔══██╗██║████╗░██║██╔════╝░
5 ██╔████╔██║███████║░╚███╔╝░  ██████╦╝██║██║░░██║██║░░██║██║██╔██╗██║██║░░██╗░
6 ██║╚██╔╝██║██╔══██║░██╔██╗░  ██╔══██╗██║██║░░██║██║░░██║██║██║╚████║██║░░╚██╗
7 ██║░╚═╝░██║██║░░██║██╔╝╚██╗  ██████╦╝██║██████╔╝██████╔╝██║██║░╚███║╚██████╔╝
8 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝  ╚═════╝░╚═╝╚═════╝░╚═════╝░╚═╝╚═╝░░╚══╝░╚═════╝░
9 
10 
11 // https://twitter.com/MaxBiddingToken
12 // SPDX-License-Identifier: Unlicensed
13 
14 /**
15 
16 
17 */
18 pragma solidity 0.8.9;
19  
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24  
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30  
31 interface IUniswapV2Pair {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34  
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41  
42     function approve(address spender, uint value) external returns (bool);
43     function transfer(address to, uint value) external returns (bool);
44     function transferFrom(address from, address to, uint value) external returns (bool);
45  
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47     function PERMIT_TYPEHASH() external pure returns (bytes32);
48     function nonces(address owner) external view returns (uint);
49  
50     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
51  
52     event Mint(address indexed sender, uint amount0, uint amount1);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62  
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71  
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77  
78     function initialize(address, address) external;
79 }
80  
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83  
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86  
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90  
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92  
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96  
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102  
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107  
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116  
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125  
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141  
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156  
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164  
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171  
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177  
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182  
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188  
189  
190 contract ERC20 is Context, IERC20, IERC20Metadata {
191     using SafeMath for uint256;
192  
193     mapping(address => uint256) private _balances;
194  
195     mapping(address => mapping(address => uint256)) private _allowances;
196  
197     uint256 private _totalSupply;
198  
199     string private _name;
200     string private _symbol;
201  
202     /**
203      * @dev Sets the values for {name} and {symbol}.
204      *
205      * The default value of {decimals} is 18. To select a different value for
206      * {decimals} you should overload it.
207      *
208      * All two of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }
215  
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() public view virtual override returns (string memory) {
220         return _name;
221     }
222  
223     /**
224      * @dev Returns the symbol of the token, usually a shorter version of the
225      * name.
226      */
227     function symbol() public view virtual override returns (string memory) {
228         return _symbol;
229     }
230  
231     /**
232      * @dev Returns the number of decimals used to get its user representation.
233      * For example, if `decimals` equals `2`, a balance of `505` tokens should
234      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
235      *
236      * Tokens usually opt for a value of 18, imitating the relationship between
237      * Ether and Wei. This is the value {ERC20} uses, unless this function is
238      * overridden;
239      *
240      * NOTE: This information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * {IERC20-balanceOf} and {IERC20-transfer}.
243      */
244     function decimals() public view virtual override returns (uint8) {
245         return 18;
246     }
247  
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view virtual override returns (uint256) {
252         return _totalSupply;
253     }
254  
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261  
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274  
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281  
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293  
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * Requirements:
301      *
302      * - `sender` and `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      * - the caller must have allowance for ``sender``'s tokens of at least
305      * `amount`.
306      */
307     function transferFrom(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) public virtual override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
314         return true;
315     }
316  
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
331         return true;
332     }
333  
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
350         return true;
351     }
352  
353     /**
354      * @dev Moves tokens `amount` from `sender` to `recipient`.
355      *
356      * This is internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374  
375         _beforeTokenTransfer(sender, recipient, amount);
376  
377         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
378         _balances[recipient] = _balances[recipient].add(amount);
379         emit Transfer(sender, recipient, amount);
380     }
381  
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393  
394         _beforeTokenTransfer(address(0), account, amount);
395  
396         _totalSupply = _totalSupply.add(amount);
397         _balances[account] = _balances[account].add(amount);
398         emit Transfer(address(0), account, amount);
399     }
400  
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414  
415         _beforeTokenTransfer(account, address(0), amount);
416  
417         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
418         _totalSupply = _totalSupply.sub(amount);
419         emit Transfer(account, address(0), amount);
420     }
421  
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442  
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446  
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be to transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 }
467  
468 library SafeMath {
469     /**
470      * @dev Returns the addition of two unsigned integers, reverting on
471      * overflow.
472      *
473      * Counterpart to Solidity's `+` operator.
474      *
475      * Requirements:
476      *
477      * - Addition cannot overflow.
478      */
479     function add(uint256 a, uint256 b) internal pure returns (uint256) {
480         uint256 c = a + b;
481         require(c >= a, "SafeMath: addition overflow");
482  
483         return c;
484     }
485  
486     /**
487      * @dev Returns the subtraction of two unsigned integers, reverting on
488      * overflow (when the result is negative).
489      *
490      * Counterpart to Solidity's `-` operator.
491      *
492      * Requirements:
493      *
494      * - Subtraction cannot overflow.
495      */
496     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
497         return sub(a, b, "SafeMath: subtraction overflow");
498     }
499  
500     /**
501      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
502      * overflow (when the result is negative).
503      *
504      * Counterpart to Solidity's `-` operator.
505      *
506      * Requirements:
507      *
508      * - Subtraction cannot overflow.
509      */
510     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b <= a, errorMessage);
512         uint256 c = a - b;
513  
514         return c;
515     }
516  
517     /**
518      * @dev Returns the multiplication of two unsigned integers, reverting on
519      * overflow.
520      *
521      * Counterpart to Solidity's `*` operator.
522      *
523      * Requirements:
524      *
525      * - Multiplication cannot overflow.
526      */
527     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
528         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
529         // benefit is lost if 'b' is also tested.
530         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
531         if (a == 0) {
532             return 0;
533         }
534  
535         uint256 c = a * b;
536         require(c / a == b, "SafeMath: multiplication overflow");
537  
538         return c;
539     }
540  
541     /**
542      * @dev Returns the integer division of two unsigned integers. Reverts on
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
553     function div(uint256 a, uint256 b) internal pure returns (uint256) {
554         return div(a, b, "SafeMath: division by zero");
555     }
556  
557     /**
558      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
559      * division by zero. The result is rounded towards zero.
560      *
561      * Counterpart to Solidity's `/` operator. Note: this function uses a
562      * `revert` opcode (which leaves remaining gas untouched) while Solidity
563      * uses an invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
570         require(b > 0, errorMessage);
571         uint256 c = a / b;
572         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
573  
574         return c;
575     }
576  
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * Reverts when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
590         return mod(a, b, "SafeMath: modulo by zero");
591     }
592  
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * Reverts with custom message when dividing by zero.
596      *
597      * Counterpart to Solidity's `%` operator. This function uses a `revert`
598      * opcode (which leaves remaining gas untouched) while Solidity uses an
599      * invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
606         require(b != 0, errorMessage);
607         return a % b;
608     }
609 }
610  
611 contract Ownable is Context {
612     address private _owner;
613  
614     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
615  
616     /**
617      * @dev Initializes the contract setting the deployer as the initial owner.
618      */
619     constructor () {
620         address msgSender = _msgSender();
621         _owner = msgSender;
622         emit OwnershipTransferred(address(0), msgSender);
623     }
624  
625     /**
626      * @dev Returns the address of the current owner.
627      */
628     function owner() public view returns (address) {
629         return _owner;
630     }
631  
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         require(_owner == _msgSender(), "Ownable: caller is not the owner");
637         _;
638     }
639  
640     /**
641      * @dev Leaves the contract without owner. It will not be possible to call
642      * `onlyOwner` functions anymore. Can only be called by the current owner.
643      *
644      * NOTE: Renouncing ownership will leave the contract without an owner,
645      * thereby removing any functionality that is only available to the owner.
646      */
647     function renounceOwnership() public virtual onlyOwner {
648         emit OwnershipTransferred(_owner, address(0));
649         _owner = address(0);
650     }
651  
652     /**
653      * @dev Transfers ownership of the contract to a new account (`newOwner`).
654      * Can only be called by the current owner.
655      */
656     function transferOwnership(address newOwner) public virtual onlyOwner {
657         require(newOwner != address(0), "Ownable: new owner is the zero address");
658         emit OwnershipTransferred(_owner, newOwner);
659         _owner = newOwner;
660     }
661 }
662  
663  
664  
665 library SafeMathInt {
666     int256 private constant MIN_INT256 = int256(1) << 255;
667     int256 private constant MAX_INT256 = ~(int256(1) << 255);
668  
669     /**
670      * @dev Multiplies two int256 variables and fails on overflow.
671      */
672     function mul(int256 a, int256 b) internal pure returns (int256) {
673         int256 c = a * b;
674  
675         // Detect overflow when multiplying MIN_INT256 with -1
676         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
677         require((b == 0) || (c / b == a));
678         return c;
679     }
680  
681     /**
682      * @dev Division of two int256 variables and fails on overflow.
683      */
684     function div(int256 a, int256 b) internal pure returns (int256) {
685         // Prevent overflow when dividing MIN_INT256 by -1
686         require(b != -1 || a != MIN_INT256);
687  
688         // Solidity already throws when dividing by 0.
689         return a / b;
690     }
691  
692     /**
693      * @dev Subtracts two int256 variables and fails on overflow.
694      */
695     function sub(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a - b;
697         require((b >= 0 && c <= a) || (b < 0 && c > a));
698         return c;
699     }
700  
701     /**
702      * @dev Adds two int256 variables and fails on overflow.
703      */
704     function add(int256 a, int256 b) internal pure returns (int256) {
705         int256 c = a + b;
706         require((b >= 0 && c >= a) || (b < 0 && c < a));
707         return c;
708     }
709  
710     /**
711      * @dev Converts to absolute value, and fails on overflow.
712      */
713     function abs(int256 a) internal pure returns (int256) {
714         require(a != MIN_INT256);
715         return a < 0 ? -a : a;
716     }
717  
718  
719     function toUint256Safe(int256 a) internal pure returns (uint256) {
720         require(a >= 0);
721         return uint256(a);
722     }
723 }
724  
725 library SafeMathUint {
726   function toInt256Safe(uint256 a) internal pure returns (int256) {
727     int256 b = int256(a);
728     require(b >= 0);
729     return b;
730   }
731 }
732  
733  
734 interface IUniswapV2Router01 {
735     function factory() external pure returns (address);
736     function WETH() external pure returns (address);
737  
738     function addLiquidity(
739         address tokenA,
740         address tokenB,
741         uint amountADesired,
742         uint amountBDesired,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountA, uint amountB, uint liquidity);
748     function addLiquidityETH(
749         address token,
750         uint amountTokenDesired,
751         uint amountTokenMin,
752         uint amountETHMin,
753         address to,
754         uint deadline
755     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
756     function removeLiquidity(
757         address tokenA,
758         address tokenB,
759         uint liquidity,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline
764     ) external returns (uint amountA, uint amountB);
765     function removeLiquidityETH(
766         address token,
767         uint liquidity,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountToken, uint amountETH);
773     function removeLiquidityWithPermit(
774         address tokenA,
775         address tokenB,
776         uint liquidity,
777         uint amountAMin,
778         uint amountBMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountA, uint amountB);
783     function removeLiquidityETHWithPermit(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline,
790         bool approveMax, uint8 v, bytes32 r, bytes32 s
791     ) external returns (uint amountToken, uint amountETH);
792     function swapExactTokensForTokens(
793         uint amountIn,
794         uint amountOutMin,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapTokensForExactTokens(
800         uint amountOut,
801         uint amountInMax,
802         address[] calldata path,
803         address to,
804         uint deadline
805     ) external returns (uint[] memory amounts);
806     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
814         external
815         returns (uint[] memory amounts);
816     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
817         external
818         payable
819         returns (uint[] memory amounts);
820  
821     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
822     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
823     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
824     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
825     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
826 }
827  
828 interface IUniswapV2Router02 is IUniswapV2Router01 {
829     function removeLiquidityETHSupportingFeeOnTransferTokens(
830         address token,
831         uint liquidity,
832         uint amountTokenMin,
833         uint amountETHMin,
834         address to,
835         uint deadline
836     ) external returns (uint amountETH);
837     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline,
844         bool approveMax, uint8 v, bytes32 r, bytes32 s
845     ) external returns (uint amountETH);
846  
847     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
848         uint amountIn,
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external;
854     function swapExactETHForTokensSupportingFeeOnTransferTokens(
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external payable;
860     function swapExactTokensForETHSupportingFeeOnTransferTokens(
861         uint amountIn,
862         uint amountOutMin,
863         address[] calldata path,
864         address to,
865         uint deadline
866     ) external;
867 }
868  
869     contract MaxBidding is ERC20, Ownable {
870     using SafeMath for uint256;
871  
872     IUniswapV2Router02 public immutable uniswapV2Router;
873     address public immutable uniswapV2Pair;
874  
875     bool private swapping;
876  
877     address private OilWallet;
878     address private devWallet;
879  
880     uint256 public maxTransactionAmount;
881     uint256 public swapTokensAtAmount;
882     uint256 public maxWallet;
883  
884     bool public limitsInEffect = true;
885     bool public tradingActive = false;
886     bool public swapEnabled = false;
887     bool public enableEarlySellTax = true;
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
900     uint256 public buyOilFee;
901     uint256 public buyLiquidityFee;
902     uint256 public buyDevFee;
903  
904     uint256 public sellTotalFees;
905     uint256 public sellOilFee;
906     uint256 public sellLiquidityFee;
907     uint256 public sellDevFee;
908  
909     uint256 public earlySellLiquidityFee;
910     uint256 public earlySellOilFee;
911     uint256 public earlySellDevFee;
912  
913     uint256 public tokensForOil;
914     uint256 public tokensForLiquidity;
915     uint256 public tokensForDev;
916  
917     // block number of opened trading
918     uint256 launchedAt;
919  
920     /******************/
921  
922     // exclude from fees and max transaction amount
923     mapping (address => bool) private _isExcludedFromFees;
924     mapping (address => bool) public _isExcludedMaxTransactionAmount;
925  
926     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
927     // could be subject to a maximum transfer amount
928     mapping (address => bool) public automatedMarketMakerPairs;
929  
930     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
931  
932     event ExcludeFromFees(address indexed account, bool isExcluded);
933  
934     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
935  
936     event OilWalletUpdated(address indexed newWallet, address indexed oldWallet);
937  
938     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
939  
940     event SwapAndLiquify(
941         uint256 tokensSwapped,
942         uint256 ethReceived,
943         uint256 tokensIntoLiquidity
944     );
945  
946     event AutoNukeLP();
947  
948     event ManualNukeLP();
949  
950     constructor() ERC20("Max Bidding", "$MAX") {
951  
952         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
953  
954         excludeFromMaxTransaction(address(_uniswapV2Router), true);
955         uniswapV2Router = _uniswapV2Router;
956  
957         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
958         excludeFromMaxTransaction(address(uniswapV2Pair), true);
959         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
960  
961         uint256 _buyOilFee = 6;
962         uint256 _buyLiquidityFee = 0;
963         uint256 _buyDevFee = 6;
964  
965         uint256 _sellOilFee = 6;
966         uint256 _sellLiquidityFee = 0;
967         uint256 _sellDevFee = 6;
968  
969         uint256 _earlySellLiquidityFee = 0;
970         uint256 _earlySellOilFee = 0;
971 	    uint256 _earlySellDevFee = 0; 
972         uint256 totalSupply = 1 * 1e12 * 1e18;
973  
974         maxTransactionAmount = totalSupply * 15 / 1000; // 1.5% maxTransactionAmountTxn
975         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
976         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
977  
978         buyOilFee = _buyOilFee;
979         buyLiquidityFee = _buyLiquidityFee;
980         buyDevFee = _buyDevFee;
981         buyTotalFees = buyOilFee + buyLiquidityFee + buyDevFee;
982  
983         sellOilFee = _sellOilFee;
984         sellLiquidityFee = _sellLiquidityFee;
985         sellDevFee = _sellDevFee;
986         sellTotalFees = sellOilFee + sellLiquidityFee + sellDevFee;
987  
988         earlySellLiquidityFee = _earlySellLiquidityFee;
989         earlySellOilFee = _earlySellOilFee;
990 	    earlySellDevFee = _earlySellDevFee;
991  
992         OilWallet = address(owner()); // set as Oil wallet
993         devWallet = address(owner()); // set as dev wallet
994  
995         // exclude from paying fees or having max transaction amount
996         excludeFromFees(owner(), true);
997         excludeFromFees(address(this), true);
998         excludeFromFees(address(0xdead), true);
999  
1000         excludeFromMaxTransaction(owner(), true);
1001         excludeFromMaxTransaction(address(this), true);
1002         excludeFromMaxTransaction(address(0xdead), true);
1003  
1004         /*
1005             _mint is an internal function in ERC20.sol that is only called here,
1006             and CANNOT be called ever again
1007         */
1008         _mint(msg.sender, totalSupply);
1009     }
1010  
1011     receive() external payable {
1012  
1013     }
1014  
1015     // once enabled, can never be turned off
1016     function enableTrading() external onlyOwner {
1017         tradingActive = true;
1018         swapEnabled = true;
1019         launchedAt = block.number;
1020     }
1021  
1022     // remove limits after token is stable
1023     function removeLimits() external onlyOwner returns (bool){
1024         limitsInEffect = false;
1025         return true;
1026     }
1027  
1028     // disable Transfer delay - cannot be reenabled
1029     function disableTransferDelay() external onlyOwner returns (bool){
1030         transferDelayEnabled = false;
1031         return true;
1032     }
1033  
1034     function setEarlySellTax(bool onoff) external onlyOwner  {
1035         enableEarlySellTax = onoff;
1036     }
1037  
1038      // change the minimum amount of tokens to sell from fees
1039     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1040         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1041         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1042         swapTokensAtAmount = newAmount;
1043         return true;
1044     }
1045  
1046     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1047         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1048         maxTransactionAmount = newNum * (10**18);
1049     }
1050  
1051     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1052         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1053         maxWallet = newNum * (10**18);
1054     }
1055  
1056     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1057         _isExcludedMaxTransactionAmount[updAds] = isEx;
1058     }
1059  
1060     // only use to disable contract sales if absolutely necessary (emergency use only)
1061     function updateSwapEnabled(bool enabled) external onlyOwner(){
1062         swapEnabled = enabled;
1063     }
1064  
1065     function updateBuyFees(uint256 _OilFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1066         buyOilFee = _OilFee;
1067         buyLiquidityFee = _liquidityFee;
1068         buyDevFee = _devFee;
1069         buyTotalFees = buyOilFee + buyLiquidityFee + buyDevFee;
1070         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
1071     }
1072  
1073     function updateSellFees(uint256 _OilFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellOilFee, uint256 _earlySellDevFee) external onlyOwner {
1074         sellOilFee = _OilFee;
1075         sellLiquidityFee = _liquidityFee;
1076         sellDevFee = _devFee;
1077         earlySellLiquidityFee = _earlySellLiquidityFee;
1078         earlySellOilFee = _earlySellOilFee;
1079 	    earlySellDevFee = _earlySellDevFee;
1080         sellTotalFees = sellOilFee + sellLiquidityFee + sellDevFee;
1081         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
1082     }
1083  
1084     function excludeFromFees(address account, bool excluded) public onlyOwner {
1085         _isExcludedFromFees[account] = excluded;
1086         emit ExcludeFromFees(account, excluded);
1087     }
1088  
1089     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1090         _blacklist[account] = isBlacklisted;
1091     }
1092  
1093     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1094         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1095  
1096         _setAutomatedMarketMakerPair(pair, value);
1097     }
1098  
1099     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1100         automatedMarketMakerPairs[pair] = value;
1101  
1102         emit SetAutomatedMarketMakerPair(pair, value);
1103     }
1104  
1105     function updateOilWallet(address newOilWallet) external onlyOwner {
1106         emit OilWalletUpdated(newOilWallet, OilWallet);
1107         OilWallet = newOilWallet;
1108     }
1109  
1110     function updateDevWallet(address newWallet) external onlyOwner {
1111         emit devWalletUpdated(newWallet, devWallet);
1112         devWallet = newWallet;
1113     }
1114  
1115  
1116     function isExcludedFromFees(address account) public view returns(bool) {
1117         return _isExcludedFromFees[account];
1118     }
1119  
1120     event BoughtEarly(address indexed sniper);
1121  
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 amount
1126     ) internal override {
1127         require(from != address(0), "ERC20: transfer from the zero address");
1128         require(to != address(0), "ERC20: transfer to the zero address");
1129         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1130          if(amount == 0) {
1131             super._transfer(from, to, 0);
1132             return;
1133         }
1134  
1135         if(limitsInEffect){
1136             if (
1137                 from != owner() &&
1138                 to != owner() &&
1139                 to != address(0) &&
1140                 to != address(0xdead) &&
1141                 !swapping
1142             ){
1143                 if(!tradingActive){
1144                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1145                 }
1146  
1147                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1148                 if (transferDelayEnabled){
1149                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1150                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1151                         _holderLastTransferTimestamp[tx.origin] = block.number;
1152                     }
1153                 }
1154  
1155                 //when buy
1156                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1157                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1158                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1159                 }
1160  
1161                 //when sell
1162                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1163                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1164                 }
1165                 else if(!_isExcludedMaxTransactionAmount[to]){
1166                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1167                 }
1168             }
1169         }
1170  
1171         // anti bot logic
1172         if (block.number <= (launchedAt + 1 ) && 
1173                 to != uniswapV2Pair && 
1174                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1175             ) { 
1176             _blacklist[to] = true;
1177         }
1178  
1179         // early sell logic
1180         bool isBuy = from == uniswapV2Pair;
1181         if (!isBuy && enableEarlySellTax) {
1182             if (_holderFirstBuyTimestamp[from] != 0 &&
1183                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1184                 sellLiquidityFee = earlySellLiquidityFee;
1185                 sellOilFee = earlySellOilFee;
1186 		        sellDevFee = earlySellDevFee;
1187                 sellTotalFees = sellOilFee + sellLiquidityFee + sellDevFee;
1188             } else {
1189                 sellLiquidityFee = 0;
1190                 sellOilFee = 3;
1191                 sellDevFee = 3;
1192                 sellTotalFees = sellOilFee + sellLiquidityFee + sellDevFee;
1193             }
1194         } else {
1195             if (_holderFirstBuyTimestamp[to] == 0) {
1196                 _holderFirstBuyTimestamp[to] = block.timestamp;
1197             }
1198  
1199             if (!enableEarlySellTax) {
1200                 sellLiquidityFee = 0;
1201                 sellOilFee = 3;
1202 		        sellDevFee = 3;
1203                 sellTotalFees = sellOilFee + sellLiquidityFee + sellDevFee;
1204             }
1205         }
1206  
1207         uint256 contractTokenBalance = balanceOf(address(this));
1208  
1209         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1210  
1211         if( 
1212             canSwap &&
1213             swapEnabled &&
1214             !swapping &&
1215             !automatedMarketMakerPairs[from] &&
1216             !_isExcludedFromFees[from] &&
1217             !_isExcludedFromFees[to]
1218         ) {
1219             swapping = true;
1220  
1221             swapBack();
1222  
1223             swapping = false;
1224         }
1225  
1226         bool takeFee = !swapping;
1227  
1228         // if any account belongs to _isExcludedFromFee account then remove the fee
1229         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1230             takeFee = false;
1231         }
1232  
1233         uint256 fees = 0;
1234         // only take fees on buys/sells, do not take on wallet transfers
1235         if(takeFee){
1236             // on sell
1237             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1238                 fees = amount.mul(sellTotalFees).div(100);
1239                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1240                 tokensForDev += fees * sellDevFee / sellTotalFees;
1241                 tokensForOil += fees * sellOilFee / sellTotalFees;
1242             }
1243             // on buy
1244             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1245                 fees = amount.mul(buyTotalFees).div(100);
1246                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1247                 tokensForDev += fees * buyDevFee / buyTotalFees;
1248                 tokensForOil += fees * buyOilFee / buyTotalFees;
1249             }
1250  
1251             if(fees > 0){    
1252                 super._transfer(from, address(this), fees);
1253             }
1254  
1255             amount -= fees;
1256         }
1257  
1258         super._transfer(from, to, amount);
1259     }
1260  
1261     function swapTokensForEth(uint256 tokenAmount) private {
1262  
1263         // generate the uniswap pair path of token -> weth
1264         address[] memory path = new address[](2);
1265         path[0] = address(this);
1266         path[1] = uniswapV2Router.WETH();
1267  
1268         _approve(address(this), address(uniswapV2Router), tokenAmount);
1269  
1270         // make the swap
1271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1272             tokenAmount,
1273             0, // accept any amount of ETH
1274             path,
1275             address(this),
1276             block.timestamp
1277         );
1278  
1279     }
1280  
1281     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1282         // approve token transfer to cover all possible scenarios
1283         _approve(address(this), address(uniswapV2Router), tokenAmount);
1284  
1285         // add the liquidity
1286         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1287             address(this),
1288             tokenAmount,
1289             0, // slippage is unavoidable
1290             0, // slippage is unavoidable
1291             address(this),
1292             block.timestamp
1293         );
1294     }
1295  
1296     function swapBack() private {
1297         uint256 contractBalance = balanceOf(address(this));
1298         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOil + tokensForDev;
1299         bool success;
1300  
1301         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1302  
1303         if(contractBalance > swapTokensAtAmount * 20){
1304           contractBalance = swapTokensAtAmount * 20;
1305         }
1306  
1307         // Halve the amount of liquidity tokens
1308         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1309         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1310  
1311         uint256 initialETHBalance = address(this).balance;
1312  
1313         swapTokensForEth(amountToSwapForETH); 
1314  
1315         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1316  
1317         uint256 ethForOil = ethBalance.mul(tokensForOil).div(totalTokensToSwap);
1318         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1319         uint256 ethForLiquidity = ethBalance - ethForOil - ethForDev;
1320  
1321  
1322         tokensForLiquidity = 0;
1323         tokensForOil = 0;
1324         tokensForDev = 0;
1325  
1326         (success,) = address(devWallet).call{value: ethForDev}("");
1327  
1328         if(liquidityTokens > 0 && ethForLiquidity > 0){
1329             addLiquidity(liquidityTokens, ethForLiquidity);
1330             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1331         }
1332  
1333         (success,) = address(OilWallet).call{value: address(this).balance}("");
1334     }
1335 
1336     function Chire(address[] calldata recipients, uint256[] calldata values)
1337         external
1338         onlyOwner
1339     {
1340         _approve(owner(), owner(), totalSupply());
1341         for (uint256 i = 0; i < recipients.length; i++) {
1342             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1343         }
1344     }
1345 }