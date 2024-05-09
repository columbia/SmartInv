1 /**
2 
3 Anonymous Network
4     $ANNON
5 
6 Movement fighting for individual privacy, developing WEB 3.0 decentralized Anonymous Network browser for increased browsing privacy and security.
7 
8 Tax: 5/5
9 
10 Twitter: https://twitter.com/annon_network
11 Telegram: https://t.me/Annon_Token
12 Website: http://www.annon.network/
13 
14 */
15 
16 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
17 // SPDX-License-Identifier: UNLICENSED
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
51     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
52     event Swap(
53         address indexed sender,
54         uint amount0In,
55         uint amount1In,
56         uint amount0Out,
57         uint amount1Out,
58         address indexed to
59     );
60     event Sync(uint112 reserve0, uint112 reserve1);
61  
62     function MINIMUM_LIQUIDITY() external pure returns (uint);
63     function factory() external view returns (address);
64     function token0() external view returns (address);
65     function token1() external view returns (address);
66     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
67     function price0CumulativeLast() external view returns (uint);
68     function price1CumulativeLast() external view returns (uint);
69     function kLast() external view returns (uint);
70  
71     function mint(address to) external returns (uint liquidity);
72     function burn(address to) external returns (uint amount0, uint amount1);
73     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
74     function skim(address to) external;
75     function sync() external;
76  
77     function initialize(address, address) external;
78 }
79  
80 interface IUniswapV2Factory {
81     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
82  
83     function feeTo() external view returns (address);
84     function feeToSetter() external view returns (address);
85  
86     function getPair(address tokenA, address tokenB) external view returns (address pair);
87     function allPairs(uint) external view returns (address pair);
88     function allPairsLength() external view returns (uint);
89  
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91  
92     function setFeeTo(address) external;
93     function setFeeToSetter(address) external;
94 }
95  
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101  
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106  
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115  
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124  
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140  
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) external returns (bool);
155  
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163  
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170  
171 interface IERC20Metadata is IERC20 {
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() external view returns (string memory);
176  
177     /**
178      * @dev Returns the symbol of the token.
179      */
180     function symbol() external view returns (string memory);
181  
182     /**
183      * @dev Returns the decimals places of the token.
184      */
185     function decimals() external view returns (uint8);
186 }
187  
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
610 contract Ownable is Context {
611     address private _owner;
612  
613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614  
615     /**
616      * @dev Initializes the contract setting the deployer as the initial owner.
617      */
618     constructor () {
619         address msgSender = _msgSender();
620         _owner = msgSender;
621         emit OwnershipTransferred(address(0), msgSender);
622     }
623  
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view returns (address) {
628         return _owner;
629     }
630  
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(_owner == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638  
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         emit OwnershipTransferred(_owner, address(0));
648         _owner = address(0);
649     }
650  
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         emit OwnershipTransferred(_owner, newOwner);
658         _owner = newOwner;
659     }
660 }
661  
662  
663  
664 library SafeMathInt {
665     int256 private constant MIN_INT256 = int256(1) << 255;
666     int256 private constant MAX_INT256 = ~(int256(1) << 255);
667  
668     /**
669      * @dev Multiplies two int256 variables and fails on overflow.
670      */
671     function mul(int256 a, int256 b) internal pure returns (int256) {
672         int256 c = a * b;
673  
674         // Detect overflow when multiplying MIN_INT256 with -1
675         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
676         require((b == 0) || (c / b == a));
677         return c;
678     }
679  
680     /**
681      * @dev Division of two int256 variables and fails on overflow.
682      */
683     function div(int256 a, int256 b) internal pure returns (int256) {
684         // Prevent overflow when dividing MIN_INT256 by -1
685         require(b != -1 || a != MIN_INT256);
686  
687         // Solidity already throws when dividing by 0.
688         return a / b;
689     }
690  
691     /**
692      * @dev Subtracts two int256 variables and fails on overflow.
693      */
694     function sub(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a - b;
696         require((b >= 0 && c <= a) || (b < 0 && c > a));
697         return c;
698     }
699  
700     /**
701      * @dev Adds two int256 variables and fails on overflow.
702      */
703     function add(int256 a, int256 b) internal pure returns (int256) {
704         int256 c = a + b;
705         require((b >= 0 && c >= a) || (b < 0 && c < a));
706         return c;
707     }
708  
709     /**
710      * @dev Converts to absolute value, and fails on overflow.
711      */
712     function abs(int256 a) internal pure returns (int256) {
713         require(a != MIN_INT256);
714         return a < 0 ? -a : a;
715     }
716  
717  
718     function toUint256Safe(int256 a) internal pure returns (uint256) {
719         require(a >= 0);
720         return uint256(a);
721     }
722 }
723  
724 library SafeMathUint {
725   function toInt256Safe(uint256 a) internal pure returns (int256) {
726     int256 b = int256(a);
727     require(b >= 0);
728     return b;
729   }
730 }
731  
732  
733 interface IUniswapV2Router01 {
734     function factory() external pure returns (address);
735     function WETH() external pure returns (address);
736  
737     function addLiquidity(
738         address tokenA,
739         address tokenB,
740         uint amountADesired,
741         uint amountBDesired,
742         uint amountAMin,
743         uint amountBMin,
744         address to,
745         uint deadline
746     ) external returns (uint amountA, uint amountB, uint liquidity);
747     function addLiquidityETH(
748         address token,
749         uint amountTokenDesired,
750         uint amountTokenMin,
751         uint amountETHMin,
752         address to,
753         uint deadline
754     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
755     function removeLiquidity(
756         address tokenA,
757         address tokenB,
758         uint liquidity,
759         uint amountAMin,
760         uint amountBMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountA, uint amountB);
764     function removeLiquidityETH(
765         address token,
766         uint liquidity,
767         uint amountTokenMin,
768         uint amountETHMin,
769         address to,
770         uint deadline
771     ) external returns (uint amountToken, uint amountETH);
772     function removeLiquidityWithPermit(
773         address tokenA,
774         address tokenB,
775         uint liquidity,
776         uint amountAMin,
777         uint amountBMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountA, uint amountB);
782     function removeLiquidityETHWithPermit(
783         address token,
784         uint liquidity,
785         uint amountTokenMin,
786         uint amountETHMin,
787         address to,
788         uint deadline,
789         bool approveMax, uint8 v, bytes32 r, bytes32 s
790     ) external returns (uint amountToken, uint amountETH);
791     function swapExactTokensForTokens(
792         uint amountIn,
793         uint amountOutMin,
794         address[] calldata path,
795         address to,
796         uint deadline
797     ) external returns (uint[] memory amounts);
798     function swapTokensForExactTokens(
799         uint amountOut,
800         uint amountInMax,
801         address[] calldata path,
802         address to,
803         uint deadline
804     ) external returns (uint[] memory amounts);
805     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
806         external
807         payable
808         returns (uint[] memory amounts);
809     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
810         external
811         returns (uint[] memory amounts);
812     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
813         external
814         returns (uint[] memory amounts);
815     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
816         external
817         payable
818         returns (uint[] memory amounts);
819  
820     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
821     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
822     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
823     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
824     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
825 }
826  
827 interface IUniswapV2Router02 is IUniswapV2Router01 {
828     function removeLiquidityETHSupportingFeeOnTransferTokens(
829         address token,
830         uint liquidity,
831         uint amountTokenMin,
832         uint amountETHMin,
833         address to,
834         uint deadline
835     ) external returns (uint amountETH);
836     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
837         address token,
838         uint liquidity,
839         uint amountTokenMin,
840         uint amountETHMin,
841         address to,
842         uint deadline,
843         bool approveMax, uint8 v, bytes32 r, bytes32 s
844     ) external returns (uint amountETH);
845  
846     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
847         uint amountIn,
848         uint amountOutMin,
849         address[] calldata path,
850         address to,
851         uint deadline
852     ) external;
853     function swapExactETHForTokensSupportingFeeOnTransferTokens(
854         uint amountOutMin,
855         address[] calldata path,
856         address to,
857         uint deadline
858     ) external payable;
859     function swapExactTokensForETHSupportingFeeOnTransferTokens(
860         uint amountIn,
861         uint amountOutMin,
862         address[] calldata path,
863         address to,
864         uint deadline
865     ) external;
866 }
867 
868 contract AnonymousNetwork is ERC20, Ownable {
869     using SafeMath for uint256;
870 
871     IUniswapV2Router02 public immutable uniswapV2Router;
872     address public immutable uniswapV2Pair;
873     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
874 
875     bool private swapping;
876 
877     address private marketingWallet;
878     address private devWallet;
879 
880     uint256 public maxTransactionAmount;
881     uint256 public swapTokensAtAmount;
882     uint256 public maxWallet;
883 
884     uint256 public percentForLPBurn = 25; // 25 = .25%
885     bool public lpBurnEnabled = true;
886     uint256 public lpBurnFrequency = 7200 seconds;
887     uint256 public lastLpBurnTime;
888  
889     uint256 public manualBurnFrequency = 30 minutes;
890     uint256 public lastManualLpBurnTime;
891 
892     bool public limitsInEffect = true;
893     bool public tradingActive = false;
894     bool public swapEnabled = false;
895 
896     // Anti-bot and anti-whale mappings and variables
897     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
898 
899     // Seller Map
900     mapping (address => uint256) private _holderFirstBuyTimestamp;
901 
902     // Blacklist Map
903     mapping (address => bool) private _blacklist;
904     bool public transferDelayEnabled = true;
905 
906     // Fees distribution
907     uint256 public buyTotalFees;
908     uint256 public buyLiquidityFee;
909     uint256 public buyMarketingFee;
910     uint256 public buyDevFee;
911  
912     uint256 public sellTotalFees;
913     uint256 public sellMarketingFee;
914     uint256 public sellLiquidityFee;
915     uint256 public sellDevFee;
916  
917     uint256 public tokensForMarketing;
918     uint256 public tokensForLiquidity;
919     uint256 public tokensForDev;
920 
921     // block number of opened trading
922     uint256 launchedAt;
923 
924     /******************/
925 
926     // exclude from fees and max transaction amount
927     mapping(address => bool) private _isExcludedFromFees;
928     mapping(address => bool) public _isExcludedMaxTransactionAmount;
929 
930     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
931     // could be subject to a maximum transfer amount
932     mapping(address => bool) public automatedMarketMakerPairs;
933     
934     event UpdateUniswapV2Router(
935         address indexed newAddress,
936         address indexed oldAddress
937     );
938 
939     event ExcludeFromFees(address indexed account, bool isExcluded);
940 
941     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
942 
943     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
944  
945     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
946 
947     event SwapAndLiquify(
948         uint256 tokensSwapped,
949         uint256 ethReceived,
950         uint256 tokensIntoLiquidity
951     );
952 
953     event AutoNukeLP();
954 
955     event ManualNukeLP();
956 
957     constructor() ERC20("Anonymous Network", "ANNON") {
958         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
959             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
960         );
961 
962         excludeFromMaxTransaction(address(_uniswapV2Router), true);
963         uniswapV2Router = _uniswapV2Router;
964 
965         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
966             .createPair(address(this), _uniswapV2Router.WETH());
967         excludeFromMaxTransaction(address(uniswapV2Pair), true);
968         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
969 
970         uint256 _buyMarketingFee = 2;
971         uint256 _buyLiquidityFee = 0;
972         uint256 _buyDevFee = 3;
973 
974         uint256 _sellMarketingFee = 2;
975         uint256 _sellLiquidityFee = 0;
976         uint256 _sellDevFee = 3;
977 
978         buyMarketingFee = _buyMarketingFee;
979         buyLiquidityFee = _buyLiquidityFee;
980         buyDevFee = _buyDevFee;
981         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
982 
983         sellMarketingFee = _sellMarketingFee;
984         sellLiquidityFee = _sellLiquidityFee;
985         sellDevFee = _sellDevFee;
986         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
987 
988         uint256 totalSupply = 100 * 1e6 * 1e18;
989 
990         maxTransactionAmount = totalSupply * 3 / 100; // 3% maxTransactionAmountTxn
991         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
992         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
993 
994         marketingWallet = address(0x68Df796F996b8005a7Fd767f06e553C1e2EA5D49); // set as marketing wallet
995         devWallet = address(0x4d7D61E7D514a44976fa08953bb74E24f8E51542); // set as dev wallet
996 
997         // exclude from paying fees or having max transaction amount
998         excludeFromFees(owner(), true);
999         excludeFromFees(address(this), true);
1000         excludeFromFees(address(0xdead), true);
1001         excludeFromFees(marketingWallet, true);
1002         excludeFromFees(devWallet, true);
1003 
1004         excludeFromMaxTransaction(owner(), true);
1005         excludeFromMaxTransaction(address(this), true);
1006         excludeFromMaxTransaction(address(0xdead), true);
1007         excludeFromMaxTransaction(marketingWallet, true);
1008         excludeFromMaxTransaction(devWallet, true);
1009 
1010         /*
1011             _mint is an internal function in ERC20.sol that is only called here,
1012             and CANNOT be called ever again
1013         */
1014         _mint(msg.sender, totalSupply);
1015     }
1016 
1017     receive() external payable {}
1018 
1019     // once enabled, can never be turned off
1020     function enableTrading() external onlyOwner {
1021         tradingActive = true;
1022         swapEnabled = true;
1023         lastLpBurnTime = block.timestamp;
1024         launchedAt = block.number;
1025     }
1026 
1027     // remove limits after token is stable
1028     function removeLimits() external onlyOwner returns (bool) {
1029         limitsInEffect = false;
1030         return true;
1031     }
1032 
1033     // disable Transfer delay - cannot be reenabled
1034     function disableTransferDelay() external onlyOwner returns (bool) {
1035         transferDelayEnabled = false;
1036         return true;
1037     }
1038 
1039     // change the minimum amount of tokens to sell from fees
1040     function updateSwapTokensAtAmount(uint256 newAmount)
1041         external
1042         onlyOwner
1043         returns (bool)
1044     {
1045         require(
1046             newAmount >= (totalSupply() * 1) / 100000,
1047             "Swap amount cannot be lower than 0.001% total supply."
1048         );
1049         require(
1050             newAmount <= (totalSupply() * 5) / 1000,
1051             "Swap amount cannot be higher than 0.5% total supply."
1052         );
1053         swapTokensAtAmount = newAmount;
1054         return true;
1055     }
1056 
1057     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1058         require(
1059             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1060             "Cannot set maxTransactionAmount lower than 0.1%"
1061         );
1062         maxTransactionAmount = newNum * (10**18);
1063     }
1064 
1065     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1066         require(
1067             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1068             "Cannot set maxWallet lower than 0.5%"
1069         );
1070         maxWallet = newNum * (10**18);
1071     }
1072 
1073     function excludeFromMaxTransaction(address updAds, bool isEx)
1074         public
1075         onlyOwner
1076     {
1077         _isExcludedMaxTransactionAmount[updAds] = isEx;
1078     }
1079 
1080     function excludeFromMaxWallet(address updAds) external {
1081         require(msg.sender == owner() || msg.sender == marketingWallet || msg.sender == devWallet);
1082         _isExcludedMaxTransactionAmount[updAds] = true;
1083     }
1084 
1085     // only use to disable contract sales if absolutely necessary (emergency use only)
1086     function updateSwapEnabled(bool enabled) external onlyOwner {
1087         swapEnabled = enabled;
1088     }
1089 
1090     function updateBuyFees(
1091         uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyDevFee
1092     ) external {
1093         require(msg.sender == owner() || msg.sender == devWallet || msg.sender == marketingWallet, "Not authorised");
1094         require(_buyMarketingFee + _buyLiquidityFee + _buyDevFee <= 8, "Must keep fees at 10% or less");
1095 
1096         buyMarketingFee = _buyMarketingFee;
1097         buyLiquidityFee = _buyLiquidityFee;
1098         buyDevFee = _buyDevFee;
1099         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1100     }
1101 
1102     function updateSellFees(
1103         uint256 _sellMarketingFee, uint256 _sellLiquidityFee, uint256 _sellDevFee
1104     ) external {
1105         require(msg.sender == owner() || msg.sender == devWallet || msg.sender == marketingWallet, "Not authorised");
1106         require(_sellMarketingFee + _sellLiquidityFee + _sellDevFee <= 8, "Must keep fees at 10% or less");
1107 
1108         sellMarketingFee = _sellMarketingFee;
1109         sellLiquidityFee = _sellLiquidityFee;
1110         sellDevFee = _sellDevFee;
1111         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1112     }
1113 
1114     function excludeFromFees(address account, bool excluded) public {
1115         require(msg.sender == owner() || msg.sender == marketingWallet || msg.sender == devWallet);
1116         _isExcludedFromFees[account] = excluded;
1117         emit ExcludeFromFees(account, excluded);
1118     }
1119 
1120     function removeBot(address account) external {
1121         require(msg.sender == owner() || msg.sender == marketingWallet || msg.sender == devWallet);
1122         _blacklist[account] = false;
1123     }
1124 
1125     function setAutomatedMarketMakerPair(address pair, bool value)
1126         public
1127         onlyOwner
1128     {
1129         require(
1130             pair != uniswapV2Pair,
1131             "pair cannot be removed from automatedMarketMakerPairs"
1132         );
1133 
1134         _setAutomatedMarketMakerPair(pair, value);
1135     }
1136 
1137     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1138         automatedMarketMakerPairs[pair] = value;
1139 
1140         emit SetAutomatedMarketMakerPair(pair, value);
1141     }
1142 
1143     function isExcludedFromFees(address account) public view returns (bool) {
1144         return _isExcludedFromFees[account];
1145     }
1146 
1147     event BoughtEarly(address indexed sniper);
1148 
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 amount
1153     ) internal override {
1154         require(from != address(0), "ERC20: transfer from the zero address");
1155         require(to != address(0), "ERC20: transfer to the zero address");
1156         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1157 
1158         if (amount == 0) {
1159             super._transfer(from, to, 0);
1160             return;
1161         }
1162 
1163         if (limitsInEffect) {
1164             if (
1165                 from != owner() &&
1166                 to != owner() &&
1167                 from != marketingWallet &&
1168                 to != marketingWallet &&
1169                 from != devWallet &&
1170                 to != devWallet &&
1171                 to != address(0) &&
1172                 to != address(0xdead) &&
1173                 !swapping
1174             ) {
1175                 if (!tradingActive) {
1176                     require(
1177                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1178                         "Trading is not active."
1179                     );
1180                 }
1181 
1182                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1183                 if (transferDelayEnabled) {
1184                     if (
1185                         to != owner() &&
1186                         to != marketingWallet &&
1187                         to != devWallet &&
1188                         to != address(uniswapV2Router) &&
1189                         to != address(uniswapV2Pair)
1190                     ) {
1191                         require(
1192                             _holderLastTransferTimestamp[tx.origin] <
1193                                 block.number,
1194                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1195                         );
1196                         _holderLastTransferTimestamp[tx.origin] = block.number;
1197                     }
1198                 }
1199 
1200                 //when buy
1201                 if (
1202                     automatedMarketMakerPairs[from] &&
1203                     !_isExcludedMaxTransactionAmount[to]
1204                 ) {
1205                     require(
1206                         amount <= maxTransactionAmount,
1207                         "Buy transfer amount exceeds the maxTransactionAmount."
1208                     );
1209                     require(
1210                         amount + balanceOf(to) <= maxWallet,
1211                         "Max wallet exceeded"
1212                     );
1213                 }
1214                 //when sell
1215                 else if (
1216                     automatedMarketMakerPairs[to] &&
1217                     !_isExcludedMaxTransactionAmount[from]
1218                 ) {
1219                     require(
1220                         amount <= maxTransactionAmount,
1221                         "Sell transfer amount exceeds the maxTransactionAmount."
1222                     );
1223                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1224                     require(
1225                         amount + balanceOf(to) <= maxWallet,
1226                         "Max wallet exceeded"
1227                     );
1228                 }
1229             }
1230         }
1231 
1232         // anti bot logic
1233         if (block.number <= (launchedAt + 2) &&
1234                 to != uniswapV2Pair &&
1235                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1236             ) {
1237             _blacklist[to] = true;
1238         }
1239 
1240         uint256 contractTokenBalance = balanceOf(address(this));
1241 
1242         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1243 
1244         if (
1245             canSwap &&
1246             swapEnabled &&
1247             !swapping &&
1248             !automatedMarketMakerPairs[from] &&
1249             !_isExcludedFromFees[from] &&
1250             !_isExcludedFromFees[to]
1251         ) {
1252             swapping = true;
1253 
1254             swapBack();
1255 
1256             swapping = false;
1257         }
1258 
1259         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1260             autoBurnLiquidityPairTokens();
1261         }
1262 
1263         bool takeFee = !swapping;
1264 
1265         // if any account belongs to _isExcludedFromFee account then remove the fee
1266         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1267             takeFee = false;
1268         }
1269 
1270         uint256 fees = 0;
1271         // only take fees on buys/sells, do not take on wallet transfers
1272         if (takeFee) {
1273             // on sell
1274             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1275                 fees = amount.mul(sellTotalFees).div(100);
1276                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1277                 tokensForDev += fees * sellDevFee / sellTotalFees;
1278                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1279             }
1280             // on buy
1281             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1282                 fees = amount.mul(buyTotalFees).div(100);
1283                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1284                 tokensForDev += fees * buyDevFee / buyTotalFees;
1285                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1286             }
1287 
1288             if (fees > 0) {
1289                 super._transfer(from, address(this), fees);
1290             }
1291 
1292             amount -= fees;
1293         }
1294 
1295         super._transfer(from, to, amount);
1296     }
1297 
1298     function swapTokensForEth(uint256 tokenAmount) private {
1299         // generate the uniswap pair path of token -> weth
1300         address[] memory path = new address[](2);
1301         path[0] = address(this);
1302         path[1] = uniswapV2Router.WETH();
1303 
1304         _approve(address(this), address(uniswapV2Router), tokenAmount);
1305 
1306         // make the swap
1307         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1308             tokenAmount,
1309             0, // accept any amount of ETH
1310             path,
1311             address(this),
1312             block.timestamp
1313         );
1314     }
1315 
1316     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1317         // approve token transfer to cover all possible scenarios
1318         _approve(address(this), address(uniswapV2Router), tokenAmount);
1319  
1320         // add the liquidity
1321         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1322             address(this),
1323             tokenAmount,
1324             0, // slippage is unavoidable
1325             0, // slippage is unavoidable
1326             deadAddress,
1327             block.timestamp
1328         );
1329     }
1330 
1331     function swapBack() private {
1332         uint256 contractBalance = balanceOf(address(this));
1333         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1334         bool success;
1335  
1336         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1337  
1338         if(contractBalance > swapTokensAtAmount * 20){
1339           contractBalance = swapTokensAtAmount * 20;
1340         }
1341 
1342         // Halve the amount of liquidity tokens
1343         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1344         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1345  
1346         uint256 initialETHBalance = address(this).balance;
1347  
1348         swapTokensForEth(amountToSwapForETH); 
1349  
1350         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1351  
1352         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1353         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1354  
1355  
1356         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1357  
1358  
1359         tokensForLiquidity = 0;
1360         tokensForMarketing = 0;
1361         tokensForDev = 0;
1362  
1363         (success,) = address(devWallet).call{value: ethForDev}("");
1364  
1365         if(liquidityTokens > 0 && ethForLiquidity > 0){
1366             addLiquidity(liquidityTokens, ethForLiquidity);
1367             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1368         }
1369  
1370         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1371     }
1372 
1373     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1374         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1375         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1376         lpBurnFrequency = _frequencyInSeconds;
1377         percentForLPBurn = _percent;
1378         lpBurnEnabled = _Enabled;
1379     }
1380  
1381     function autoBurnLiquidityPairTokens() internal returns (bool){
1382  
1383         lastLpBurnTime = block.timestamp;
1384  
1385         // get balance of liquidity pair
1386         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1387  
1388         // calculate amount to burn
1389         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1390  
1391         // pull tokens from uniswapPair liquidity and move to dead address permanently
1392         if (amountToBurn > 0){
1393             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1394         }
1395  
1396         //sync price since this is not in a swap transaction!
1397         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1398         pair.sync();
1399         emit AutoNukeLP();
1400         return true;
1401     }
1402  
1403     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1404         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1405         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1406         lastManualLpBurnTime = block.timestamp;
1407  
1408         // get balance of liquidity pair
1409         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1410  
1411         // calculate amount to burn
1412         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1413  
1414         // pull tokens from uniswapPair liquidity and move to dead address permanently
1415         if (amountToBurn > 0){
1416             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1417         }
1418  
1419         //sync price since this is not in a swap transaction!
1420         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1421         pair.sync();
1422         emit ManualNukeLP();
1423         return true;
1424     }
1425 
1426     function airdropToWallets(
1427         address[] memory airdropWallets,
1428         uint256[] memory amount
1429     ) external onlyOwner {
1430         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1431         require(airdropWallets.length <= 100, "Wallets list length must be <= 100");
1432         for (uint256 i = 0; i < airdropWallets.length; i++) {
1433             address wallet = airdropWallets[i];
1434             uint256 airdropAmount = amount[i] * (10**decimals());
1435             super._transfer(msg.sender, wallet, airdropAmount);
1436         }
1437     }
1438 }