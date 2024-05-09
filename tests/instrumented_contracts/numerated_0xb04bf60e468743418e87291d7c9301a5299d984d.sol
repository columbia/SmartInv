1 /**
2 
3 ███████╗░█████╗░██████╗░███████╗██╗░░░██╗███████╗██████╗░  ░██████╗██╗░░██╗██╗██████╗░░█████╗░
4 ██╔════╝██╔══██╗██╔══██╗██╔════╝██║░░░██║██╔════╝██╔══██╗  ██╔════╝██║░░██║██║██╔══██╗██╔══██╗
5 █████╗░░██║░░██║██████╔╝█████╗░░╚██╗░██╔╝█████╗░░██████╔╝  ╚█████╗░███████║██║██████╦╝███████║
6 ██╔══╝░░██║░░██║██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░██╔══██╗  ░╚═══██╗██╔══██║██║██╔══██╗██╔══██║
7 ██║░░░░░╚█████╔╝██║░░██║███████╗░░╚██╔╝░░███████╗██║░░██║  ██████╔╝██║░░██║██║██████╦╝██║░░██║
8 ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝  ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝
9 
10 Forever Means Forever - In Perpetuum Est In Aeternum!
11 
12 Community: https://t.me/FOREVERSHIBA
13 
14  */
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.17;
18  
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23  
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
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
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     using SafeMath for uint256;
191  
192     mapping(address => uint256) private _balances;
193  
194     mapping(address => mapping(address => uint256)) private _allowances;
195  
196     uint256 private _totalSupply;
197  
198     string private _name;
199     string private _symbol;
200  
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * The default value of {decimals} is 18. To select a different value for
205      * {decimals} you should overload it.
206      *
207      * All two of these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214  
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221  
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() public view virtual override returns (string memory) {
227         return _symbol;
228     }
229  
230     /**
231      * @dev Returns the number of decimals used to get its user representation.
232      * For example, if `decimals` equals `2`, a balance of `505` tokens should
233      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
234      *
235      * Tokens usually opt for a value of 18, imitating the relationship between
236      * Ether and Wei. This is the value {ERC20} uses, unless this function is
237      * overridden;
238      *
239      * NOTE: This information is only used for _display_ purposes: it in
240      * no way affects any of the arithmetic of the contract, including
241      * {IERC20-balanceOf} and {IERC20-transfer}.
242      */
243     function decimals() public view virtual override returns (uint8) {
244         return 18;
245     }
246  
247     /**
248      * @dev See {IERC20-totalSupply}.
249      */
250     function totalSupply() public view virtual override returns (uint256) {
251         return _totalSupply;
252     }
253  
254     /**
255      * @dev See {IERC20-balanceOf}.
256      */
257     function balanceOf(address account) public view virtual override returns (uint256) {
258         return _balances[account];
259     }
260  
261     /**
262      * @dev See {IERC20-transfer}.
263      *
264      * Requirements:
265      *
266      * - `recipient` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273  
274     /**
275      * @dev See {IERC20-allowance}.
276      */
277     function allowance(address owner, address spender) public view virtual override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280  
281     /**
282      * @dev See {IERC20-approve}.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292  
293     /**
294      * @dev See {IERC20-transferFrom}.
295      *
296      * Emits an {Approval} event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of {ERC20}.
298      *
299      * Requirements:
300      *
301      * - `sender` and `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      * - the caller must have allowance for ``sender``'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         _transfer(sender, recipient, amount);
312         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
313         return true;
314     }
315  
316     /**
317      * @dev Atomically increases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
330         return true;
331     }
332  
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
349         return true;
350     }
351  
352     /**
353      * @dev Moves tokens `amount` from `sender` to `recipient`.
354      *
355      * This is internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373  
374         _beforeTokenTransfer(sender, recipient, amount);
375  
376         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380  
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392  
393         _beforeTokenTransfer(address(0), account, amount);
394  
395         _totalSupply = _totalSupply.add(amount);
396         _balances[account] = _balances[account].add(amount);
397         emit Transfer(address(0), account, amount);
398     }
399  
400     /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: burn from the zero address");
413  
414         _beforeTokenTransfer(account, address(0), amount);
415  
416         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
417         _totalSupply = _totalSupply.sub(amount);
418         emit Transfer(account, address(0), amount);
419     }
420  
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
423      *
424      * This internal function is equivalent to `approve`, and can be used to
425      * e.g. set automatic allowances for certain subsystems, etc.
426      *
427      * Emits an {Approval} event.
428      *
429      * Requirements:
430      *
431      * - `owner` cannot be the zero address.
432      * - `spender` cannot be the zero address.
433      */
434     function _approve(
435         address owner,
436         address spender,
437         uint256 amount
438     ) internal virtual {
439         require(owner != address(0), "ERC20: approve from the zero address");
440         require(spender != address(0), "ERC20: approve to the zero address");
441  
442         _allowances[owner][spender] = amount;
443         emit Approval(owner, spender, amount);
444     }
445  
446     /**
447      * @dev Hook that is called before any transfer of tokens. This includes
448      * minting and burning.
449      *
450      * Calling conditions:
451      *
452      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
453      * will be to transferred to `to`.
454      * - when `from` is zero, `amount` tokens will be minted for `to`.
455      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
456      * - `from` and `to` are never both zero.
457      *
458      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
459      */
460     function _beforeTokenTransfer(
461         address from,
462         address to,
463         uint256 amount
464     ) internal virtual {}
465 }
466  
467 library SafeMath {
468     /**
469      * @dev Returns the addition of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `+` operator.
473      *
474      * Requirements:
475      *
476      * - Addition cannot overflow.
477      */
478     function add(uint256 a, uint256 b) internal pure returns (uint256) {
479         uint256 c = a + b;
480         require(c >= a, "SafeMath: addition overflow");
481  
482         return c;
483     }
484  
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting on
487      * overflow (when the result is negative).
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496         return sub(a, b, "SafeMath: subtraction overflow");
497     }
498  
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * Counterpart to Solidity's `-` operator.
504      *
505      * Requirements:
506      *
507      * - Subtraction cannot overflow.
508      */
509     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b <= a, errorMessage);
511         uint256 c = a - b;
512  
513         return c;
514     }
515  
516     /**
517      * @dev Returns the multiplication of two unsigned integers, reverting on
518      * overflow.
519      *
520      * Counterpart to Solidity's `*` operator.
521      *
522      * Requirements:
523      *
524      * - Multiplication cannot overflow.
525      */
526     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
527         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
528         // benefit is lost if 'b' is also tested.
529         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
530         if (a == 0) {
531             return 0;
532         }
533  
534         uint256 c = a * b;
535         require(c / a == b, "SafeMath: multiplication overflow");
536  
537         return c;
538     }
539  
540     /**
541      * @dev Returns the integer division of two unsigned integers. Reverts on
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
552     function div(uint256 a, uint256 b) internal pure returns (uint256) {
553         return div(a, b, "SafeMath: division by zero");
554     }
555  
556     /**
557      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
558      * division by zero. The result is rounded towards zero.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b > 0, errorMessage);
570         uint256 c = a / b;
571         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
572  
573         return c;
574     }
575  
576     /**
577      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
578      * Reverts when dividing by zero.
579      *
580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
581      * opcode (which leaves remaining gas untouched) while Solidity uses an
582      * invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
589         return mod(a, b, "SafeMath: modulo by zero");
590     }
591  
592     /**
593      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
594      * Reverts with custom message when dividing by zero.
595      *
596      * Counterpart to Solidity's `%` operator. This function uses a `revert`
597      * opcode (which leaves remaining gas untouched) while Solidity uses an
598      * invalid opcode to revert (consuming all remaining gas).
599      *
600      * Requirements:
601      *
602      * - The divisor cannot be zero.
603      */
604     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
605         require(b != 0, errorMessage);
606         return a % b;
607     }
608 }
609 
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
663 library SafeMathInt {
664     int256 private constant MIN_INT256 = int256(1) << 255;
665     int256 private constant MAX_INT256 = ~(int256(1) << 255);
666  
667     /**
668      * @dev Multiplies two int256 variables and fails on overflow.
669      */
670     function mul(int256 a, int256 b) internal pure returns (int256) {
671         int256 c = a * b;
672  
673         // Detect overflow when multiplying MIN_INT256 with -1
674         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
675         require((b == 0) || (c / b == a));
676         return c;
677     }
678  
679     /**
680      * @dev Division of two int256 variables and fails on overflow.
681      */
682     function div(int256 a, int256 b) internal pure returns (int256) {
683         // Prevent overflow when dividing MIN_INT256 by -1
684         require(b != -1 || a != MIN_INT256);
685  
686         // Solidity already throws when dividing by 0.
687         return a / b;
688     }
689  
690     /**
691      * @dev Subtracts two int256 variables and fails on overflow.
692      */
693     function sub(int256 a, int256 b) internal pure returns (int256) {
694         int256 c = a - b;
695         require((b >= 0 && c <= a) || (b < 0 && c > a));
696         return c;
697     }
698  
699     /**
700      * @dev Adds two int256 variables and fails on overflow.
701      */
702     function add(int256 a, int256 b) internal pure returns (int256) {
703         int256 c = a + b;
704         require((b >= 0 && c >= a) || (b < 0 && c < a));
705         return c;
706     }
707  
708     /**
709      * @dev Converts to absolute value, and fails on overflow.
710      */
711     function abs(int256 a) internal pure returns (int256) {
712         require(a != MIN_INT256);
713         return a < 0 ? -a : a;
714     }
715  
716  
717     function toUint256Safe(int256 a) internal pure returns (uint256) {
718         require(a >= 0);
719         return uint256(a);
720     }
721 }
722  
723 library SafeMathUint {
724   function toInt256Safe(uint256 a) internal pure returns (int256) {
725     int256 b = int256(a);
726     require(b >= 0);
727     return b;
728   }
729 }
730   
731 interface IUniswapV2Router01 {
732     function factory() external pure returns (address);
733     function WETH() external pure returns (address);
734  
735     function addLiquidity(
736         address tokenA,
737         address tokenB,
738         uint amountADesired,
739         uint amountBDesired,
740         uint amountAMin,
741         uint amountBMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountA, uint amountB, uint liquidity);
745     function addLiquidityETH(
746         address token,
747         uint amountTokenDesired,
748         uint amountTokenMin,
749         uint amountETHMin,
750         address to,
751         uint deadline
752     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
753     function removeLiquidity(
754         address tokenA,
755         address tokenB,
756         uint liquidity,
757         uint amountAMin,
758         uint amountBMin,
759         address to,
760         uint deadline
761     ) external returns (uint amountA, uint amountB);
762     function removeLiquidityETH(
763         address token,
764         uint liquidity,
765         uint amountTokenMin,
766         uint amountETHMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountToken, uint amountETH);
770     function removeLiquidityWithPermit(
771         address tokenA,
772         address tokenB,
773         uint liquidity,
774         uint amountAMin,
775         uint amountBMin,
776         address to,
777         uint deadline,
778         bool approveMax, uint8 v, bytes32 r, bytes32 s
779     ) external returns (uint amountA, uint amountB);
780     function removeLiquidityETHWithPermit(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline,
787         bool approveMax, uint8 v, bytes32 r, bytes32 s
788     ) external returns (uint amountToken, uint amountETH);
789     function swapExactTokensForTokens(
790         uint amountIn,
791         uint amountOutMin,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapTokensForExactTokens(
797         uint amountOut,
798         uint amountInMax,
799         address[] calldata path,
800         address to,
801         uint deadline
802     ) external returns (uint[] memory amounts);
803     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         payable
806         returns (uint[] memory amounts);
807     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
808         external
809         returns (uint[] memory amounts);
810     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
814         external
815         payable
816         returns (uint[] memory amounts);
817  
818     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
819     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
820     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
821     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
822     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
823 }
824  
825 interface IUniswapV2Router02 is IUniswapV2Router01 {
826     function removeLiquidityETHSupportingFeeOnTransferTokens(
827         address token,
828         uint liquidity,
829         uint amountTokenMin,
830         uint amountETHMin,
831         address to,
832         uint deadline
833     ) external returns (uint amountETH);
834     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline,
841         bool approveMax, uint8 v, bytes32 r, bytes32 s
842     ) external returns (uint amountETH);
843  
844     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
845         uint amountIn,
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external;
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external payable;
857     function swapExactTokensForETHSupportingFeeOnTransferTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external;
864 }
865 
866 //FOREVERSHIBA.sol
867 
868  
869 contract FOREVERSHIBA is ERC20, Ownable {
870     
871     using SafeMath for uint256;
872  
873     IUniswapV2Router02 public immutable uniswapV2Router;
874     address public immutable uniswapV2Pair;
875  
876     bool private swapping;
877  
878     address private marketingWallet=0xF926ecc6B8c940c28A748f56F7d55Af81D1b4583;
879     address private ForeverWallet=0x6A3A52b0697e8E29F29C46B12deC59F5a30d86F5;
880  
881     uint256 public maxTransactionAmount;
882     uint256 public swapTokensAtAmount;
883     uint256 public maxWalletAmount;
884  
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = true;
888  
889      // Anti-bot and anti-whale mappings and variables
890     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
891  
892    
893  
894     // Blacklist Map
895     mapping (address => bool) private _blacklist;
896     bool public transferDelayEnabled = true;
897  
898     uint256 public buyTotalFees;
899     uint256 public buyMarketingFee;
900     uint256 public buyLiquidityFee;
901     uint256 public buyForeverFee;
902  
903     uint256 public sellTotalFees;
904     uint256 public sellMarketingFee;
905     uint256 public sellLiquidityFee;
906     uint256 public sellForeverFee;
907  
908     uint256 public tokensForMarketing;
909     uint256 public tokensForLiquidity;
910     uint256 public tokensForForever;
911  
912     // block number of opened trading
913     uint256 launchedAt;
914  
915     /******************/
916  
917     // exclude from fees and max transaction amount
918     mapping (address => bool) private _isExcludedFromFees;
919     mapping (address => bool) public _isExcludedMaxTransactionAmount;
920  
921     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
922     // could be subject to a maximum transfer amount
923     mapping (address => bool) public automatedMarketMakerPairs;
924  
925     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
926  
927     event ExcludeFromFees(address indexed account, bool isExcluded);
928  
929     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
930  
931     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
932  
933     event ForeverWalletUpdated(address indexed newWallet, address indexed oldWallet);
934  
935     event SwapAndLiquify(
936         uint256 tokensSwapped,
937         uint256 ethReceived,
938         uint256 tokensIntoLiquidity
939     );
940  
941     constructor() ERC20("FOREVER SHIBA", "4SHIBA") { 
942  
943         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
944  
945         excludeFromMaxTransaction(address(_uniswapV2Router), true);
946         uniswapV2Router = _uniswapV2Router;
947  
948         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
949         excludeFromMaxTransaction(address(uniswapV2Pair), true);
950         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
951  
952         uint256 _buyMarketingFee = 6;
953         uint256 _buyLiquidityFee = 1;
954         uint256 _buyForeverFee = 1;
955 
956         uint256 _sellMarketingFee = 16;
957         uint256 _sellLiquidityFee = 4;
958         uint256 _sellForeverFee = 4;
959  
960         uint256 totalSupply = 1 * 10 ** 9 * 10 ** decimals(); // 1 Billion Supply
961  
962         maxTransactionAmount = 3 * 10 ** 7 * 10 ** decimals(); // 30 Million maxTransaction
963         maxWalletAmount = 3 * 10 ** 7 * 10 ** decimals(); // 30 Million  maxWallet
964         swapTokensAtAmount = 1 * 10 ** 7 * 10 ** decimals(); 
965  
966         buyMarketingFee = _buyMarketingFee;
967         buyLiquidityFee = _buyLiquidityFee;
968         buyForeverFee = _buyForeverFee;
969         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyForeverFee;
970  
971         sellMarketingFee = _sellMarketingFee;
972         sellLiquidityFee = _sellLiquidityFee;
973         sellForeverFee = _sellForeverFee;
974         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellForeverFee;
975  
976         // exclude from paying fees or having max transaction amount
977         excludeFromFees(owner(), true);
978         excludeFromFees(address(this), true);
979         excludeFromFees(address(0xdead), true);
980         
981  
982         excludeFromMaxTransaction(owner(), true);
983         excludeFromMaxTransaction(address(this), true);
984         excludeFromMaxTransaction(address(0xdead), true);
985  
986         /*
987             _mint is an internal function in ERC20.sol that is only called here,
988             and CANNOT be called ever again
989         */
990         _mint(msg.sender, totalSupply);
991     }
992  
993     receive() external payable {
994  
995     }
996  
997     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
998         tradingActive = EnableTrade;
999         swapEnabled = _swap;
1000         launchedAt = block.number;
1001     }
1002  
1003     // remove limits after token is stable
1004     function removeLimits() external onlyOwner returns (bool){
1005         limitsInEffect = false;
1006         return true;
1007     }
1008  
1009     // disable Transfer delay - cannot be reenabled
1010     function disableTransferDelay() external onlyOwner returns (bool){
1011         transferDelayEnabled = false;
1012         return true;
1013     }
1014  
1015      // change the minimum amount of tokens to sell from fees
1016     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1017         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1018         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1019         swapTokensAtAmount = newAmount;
1020         return true;
1021     }
1022  
1023     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1024         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1025         maxTransactionAmount = newNum;
1026     }
1027  
1028     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1029         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1030         maxWalletAmount = newNum;
1031     }
1032  
1033     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1034         _isExcludedMaxTransactionAmount[updAds] = isEx;
1035     }
1036  
1037    
1038     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _ForeverFee_) external onlyOwner {
1039         sellMarketingFee = _marketingFee;
1040         sellLiquidityFee = _liquidityFee;
1041         sellForeverFee = _ForeverFee_;
1042         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellForeverFee;
1043         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1044     }
1045  
1046     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _ForeverFee_) external onlyOwner {
1047         buyMarketingFee = _marketingFee;
1048         buyLiquidityFee = _liquidityFee;
1049         buyForeverFee = _ForeverFee_;
1050         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyForeverFee;
1051         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1052     }
1053 
1054 
1055     function excludeFromFees(address account, bool excluded) public onlyOwner {
1056         _isExcludedFromFees[account] = excluded;
1057         emit ExcludeFromFees(account, excluded);
1058     }
1059  
1060     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1061         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1062  
1063         _setAutomatedMarketMakerPair(pair, value);
1064     }
1065  
1066     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1067         automatedMarketMakerPairs[pair] = value;
1068  
1069         emit SetAutomatedMarketMakerPair(pair, value);
1070     }
1071 
1072         function AddBots(address[] memory bots_) public onlyOwner {
1073 for (uint i = 0; i < bots_.length; i++) {
1074             _blacklist[bots_[i]] = true;
1075         
1076 }
1077     }
1078 
1079 function Del(address[] memory notbot) public onlyOwner {
1080       for (uint i = 0; i < notbot.length; i++) {
1081           _blacklist[notbot[i]] = false;
1082       }
1083     }
1084 
1085     function check(address wallet) public view returns (bool){
1086       return _blacklist[wallet];
1087     }
1088 
1089 
1090 
1091  
1092     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1093         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1094         marketingWallet = newMarketingWallet;
1095     }
1096  
1097     function updateForeverWallet(address newWallet) external onlyOwner {
1098         emit ForeverWalletUpdated(newWallet, ForeverWallet);
1099         ForeverWallet = newWallet;
1100     }
1101  
1102     function isExcludedFromFees(address account) public view returns(bool) {
1103         return _isExcludedFromFees[account];
1104     }
1105 
1106 
1107 
1108   function Airdrop(
1109         address[] memory airdropWallets,
1110         uint256[] memory amount
1111     ) external onlyOwner {
1112         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1113         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1114         for (uint256 i = 0; i < airdropWallets.length; i++) {
1115             address wallet = airdropWallets[i];
1116             uint256 airdropAmount = amount[i] * (10**18);
1117             super._transfer(msg.sender, wallet, airdropAmount);
1118         }
1119     }
1120 
1121  
1122  
1123     function _transfer(
1124         address from,
1125         address to,
1126         uint256 amount
1127     ) internal override {
1128         require(from != address(0), "ERC20: transfer from the zero address");
1129         require(to != address(0), "ERC20: transfer to the zero address");
1130         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1131          if(amount == 0) {
1132             super._transfer(from, to, 0);
1133             return;
1134         }
1135  
1136         if(limitsInEffect){
1137             if (
1138                 from != owner() &&
1139                 to != owner() &&
1140                 to != address(0) &&
1141                 to != address(0xdead) &&
1142                 !swapping
1143             ){
1144                 if(!tradingActive){
1145                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1146                 }
1147  
1148                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1149                 if (transferDelayEnabled){
1150                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1151                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1152                         _holderLastTransferTimestamp[tx.origin] = block.number;
1153                     }
1154                 }
1155  
1156                 //when buy
1157                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1158                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1159                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1160                 }
1161  
1162                 //when sell
1163                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1164                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1165                 }
1166                 else if(!_isExcludedMaxTransactionAmount[to]){
1167                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1168                 }
1169             }
1170         }
1171  
1172         // anti bot logic
1173         if (block.number <= (launchedAt + 2) && 
1174                 to != uniswapV2Pair && 
1175                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1176             ) { 
1177             _blacklist[to] = true;
1178         }
1179  
1180         uint256 contractTokenBalance = balanceOf(address(this));
1181  
1182         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1183  
1184         if( 
1185             canSwap &&
1186             swapEnabled &&
1187             !swapping &&
1188             !automatedMarketMakerPairs[from] &&
1189             !_isExcludedFromFees[from] &&
1190             !_isExcludedFromFees[to]
1191         ) {
1192             swapping = true;
1193  
1194             swapBack();
1195  
1196             swapping = false;
1197         }
1198  
1199         bool takeFee = !swapping;
1200  
1201         // if any account belongs to _isExcludedFromFee account then remove the fee
1202         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1203             takeFee = false;
1204         }
1205  
1206         uint256 fees = 0;
1207         // only take fees on buys/sells, do not take on wallet transfers
1208         if(takeFee){
1209             // on sell
1210             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1211                 fees = amount.mul(sellTotalFees).div(100);
1212                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1213                 tokensForForever += fees * sellForeverFee / sellTotalFees;
1214                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1215             }
1216             // on buy
1217             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1218                 fees = amount.mul(buyTotalFees).div(100);
1219                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1220                 tokensForForever += fees * buyForeverFee / buyTotalFees;
1221                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1222             }
1223  
1224             if(fees > 0){    
1225                 super._transfer(from, address(this), fees);
1226             }
1227  
1228             amount -= fees;
1229         }
1230  
1231         super._transfer(from, to, amount);
1232     }
1233  
1234     function swapTokensForEth(uint256 tokenAmount) private {
1235  
1236         // generate the uniswap pair path of token -> weth
1237         address[] memory path = new address[](2);
1238         path[0] = address(this);
1239         path[1] = uniswapV2Router.WETH();
1240  
1241         _approve(address(this), address(uniswapV2Router), tokenAmount);
1242  
1243         // make the swap
1244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1245             tokenAmount,
1246             0, // accept any amount of ETH
1247             path,
1248             address(this),
1249             block.timestamp
1250         );
1251  
1252     }
1253  
1254     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1255         // approve token transfer to cover all possible scenarios
1256         _approve(address(this), address(uniswapV2Router), tokenAmount);
1257  
1258         // add the liquidity
1259         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1260             address(this),
1261             tokenAmount,
1262             0, // slippage is unavoidable
1263             0, // slippage is unavoidable
1264             address(this),
1265             block.timestamp
1266         );
1267     }
1268  
1269     function swapBack() private {
1270         uint256 contractBalance = balanceOf(address(this));
1271         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForForever;
1272         bool success;
1273  
1274         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1275  
1276         if(contractBalance > swapTokensAtAmount * 20){
1277           contractBalance = swapTokensAtAmount * 20;
1278         }
1279  
1280         // Halve the amount of liquidity tokens
1281         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1282         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1283  
1284         uint256 initialETHBalance = address(this).balance;
1285  
1286         swapTokensForEth(amountToSwapForETH); 
1287  
1288         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1289  
1290         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1291         uint256 ethForForever = ethBalance.mul(tokensForForever).div(totalTokensToSwap);
1292         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForForever;
1293  
1294  
1295         tokensForLiquidity = 0;
1296         tokensForMarketing = 0;
1297         tokensForForever = 0;
1298  
1299         (success,) = address(ForeverWallet).call{value: ethForForever}("");
1300  
1301         if(liquidityTokens > 0 && ethForLiquidity > 0){
1302             addLiquidity(liquidityTokens, ethForLiquidity);
1303             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1304         }
1305  
1306         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1307     }
1308     
1309   
1310 }