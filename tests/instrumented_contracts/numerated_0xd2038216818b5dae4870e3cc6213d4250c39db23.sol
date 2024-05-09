1 /**
2  *
3 */
4 /** This token commemorates Elon Musk buying Twitter, Tweet Doge to Burn Doge 
5 Website: https://TweetDoge.com
6 Twitter: https://twitter.com/TweetDogeEth
7 Telegram: https://t.me/TweetDogeEth
8 /**
9  
10 // SPDX-License-Identifier: Unlicensed
11 
12 
13 
14  
15 
16 */
17 pragma solidity 0.8.9;
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
30 interface IUniswapV2Pair {
31     event Approval(address indexed owner, address indexed spender, uint value);
32     event Transfer(address indexed from, address indexed to, uint value);
33  
34     function name() external pure returns (string memory);
35     function symbol() external pure returns (string memory);
36     function decimals() external pure returns (uint8);
37     function totalSupply() external view returns (uint);
38     function balanceOf(address owner) external view returns (uint);
39     function allowance(address owner, address spender) external view returns (uint);
40  
41     function approve(address spender, uint value) external returns (bool);
42     function transfer(address to, uint value) external returns (bool);
43     function transferFrom(address from, address to, uint value) external returns (bool);
44  
45     function DOMAIN_SEPARATOR() external view returns (bytes32);
46     function PERMIT_TYPEHASH() external pure returns (bytes32);
47     function nonces(address owner) external view returns (uint);
48  
49     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
50  
51     event Mint(address indexed sender, uint amount0, uint amount1);
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
868 contract TweetDoge is ERC20, Ownable {
869     using SafeMath for uint256;
870  
871     IUniswapV2Router02 public immutable uniswapV2Router;
872     address public immutable uniswapV2Pair;
873  
874     bool private swapping;
875  
876     address private marketingWallet;
877     address private devWallet;
878  
879     uint256 private maxTransactionAmount;
880     uint256 private swapTokensAtAmount;
881     uint256 private maxWallet;
882  
883     bool private limitsInEffect = true;
884     bool private tradingActive = false;
885     bool public swapEnabled = false;
886     bool public enableEarlySellTax = true;
887  
888      // Anti-bot and anti-whale mappings and variables
889     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
890  
891     // Seller Map
892     mapping (address => uint256) private _holderFirstBuyTimestamp;
893  
894     // Blacklist Map
895     mapping (address => bool) private _blacklist;
896     bool public transferDelayEnabled = true;
897  
898     uint256 private buyTotalFees;
899     uint256 private buyMarketingFee;
900     uint256 private buyLiquidityFee;
901     uint256 private buyDevFee;
902  
903     uint256 private sellTotalFees;
904     uint256 private sellMarketingFee;
905     uint256 private sellLiquidityFee;
906     uint256 private sellDevFee;
907  
908     uint256 private earlySellLiquidityFee;
909     uint256 private earlySellMarketingFee;
910     uint256 private earlySellDevFee;
911  
912     uint256 private tokensForMarketing;
913     uint256 private tokensForLiquidity;
914     uint256 private tokensForDev;
915  
916     // block number of opened trading
917     uint256 launchedAt;
918  
919     /******************/
920  
921     // exclude from fees and max transaction amount
922     mapping (address => bool) private _isExcludedFromFees;
923     mapping (address => bool) public _isExcludedMaxTransactionAmount;
924  
925     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
926     // could be subject to a maximum transfer amount
927     mapping (address => bool) public automatedMarketMakerPairs;
928  
929     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
930  
931     event ExcludeFromFees(address indexed account, bool isExcluded);
932  
933     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
934  
935     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
936  
937     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
938  
939     event SwapAndLiquify(
940         uint256 tokensSwapped,
941         uint256 ethReceived,
942         uint256 tokensIntoLiquidity
943     );
944  
945     event AutoNukeLP();
946  
947     event ManualNukeLP();
948  
949     constructor() ERC20("TweetDoge", "TDOGE") {
950  
951         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
952  
953         excludeFromMaxTransaction(address(_uniswapV2Router), true);
954         uniswapV2Router = _uniswapV2Router;
955  
956         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
957         excludeFromMaxTransaction(address(uniswapV2Pair), true);
958         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
959  
960         uint256 _buyMarketingFee = 4;
961         uint256 _buyLiquidityFee = 0;
962         uint256 _buyDevFee = 2;
963  
964         uint256 _sellMarketingFee = 4;
965         uint256 _sellLiquidityFee = 0;
966         uint256 _sellDevFee = 4;
967  
968         uint256 _earlySellLiquidityFee = 0;
969         uint256 _earlySellMarketingFee = 4;
970 	    uint256 _earlySellDevFee = 4
971  
972     ; uint256 totalSupply = 1 * 1e12 * 1e18;
973  
974         maxTransactionAmount = totalSupply * 11 / 1000; // 1.1% maxTransactionAmountTxn
975         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
976         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
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
988         earlySellLiquidityFee = _earlySellLiquidityFee;
989         earlySellMarketingFee = _earlySellMarketingFee;
990 	earlySellDevFee = _earlySellDevFee;
991  
992         marketingWallet = address(owner()); // set as marketing wallet
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
1065     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1066         buyMarketingFee = _marketingFee;
1067         buyLiquidityFee = _liquidityFee;
1068         buyDevFee = _devFee;
1069         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1070         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1071     }
1072  
1073     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1074         sellMarketingFee = _marketingFee;
1075         sellLiquidityFee = _liquidityFee;
1076         sellDevFee = _devFee;
1077         earlySellLiquidityFee = _earlySellLiquidityFee;
1078         earlySellMarketingFee = _earlySellMarketingFee;
1079 	    earlySellDevFee = _earlySellDevFee;
1080         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1081         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1082     }
1083  
1084     function excludeFromFees(address account, bool excluded) public onlyOwner {
1085         _isExcludedFromFees[account] = excluded;
1086         emit ExcludeFromFees(account, excluded);
1087     }
1088  
1089     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1090         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1091  
1092         _setAutomatedMarketMakerPair(pair, value);
1093     }
1094  
1095     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1096         automatedMarketMakerPairs[pair] = value;
1097  
1098         emit SetAutomatedMarketMakerPair(pair, value);
1099     }
1100  
1101     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1102         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1103         marketingWallet = newMarketingWallet;
1104     }
1105  
1106     function updateDevWallet(address newWallet) external onlyOwner {
1107         emit devWalletUpdated(newWallet, devWallet);
1108         devWallet = newWallet;
1109     }
1110  
1111  
1112     function isExcludedFromFees(address account) public view returns(bool) {
1113         return _isExcludedFromFees[account];
1114     }
1115  
1116     event BoughtEarly(address indexed sniper);
1117  
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 amount
1122     ) internal override {
1123         require(from != address(0), "ERC20: transfer from the zero address");
1124         require(to != address(0), "ERC20: transfer to the zero address");
1125         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1126          if(amount == 0) {
1127             super._transfer(from, to, 0);
1128             return;
1129         }
1130  
1131         if(limitsInEffect){
1132             if (
1133                 from != owner() &&
1134                 to != owner() &&
1135                 to != address(0) &&
1136                 to != address(0xdead) &&
1137                 !swapping
1138             ){
1139                 if(!tradingActive){
1140                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1141                 }
1142  
1143                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1144                 if (transferDelayEnabled){
1145                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1146                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1147                         _holderLastTransferTimestamp[tx.origin] = block.number;
1148                     }
1149                 }
1150  
1151                 //when buy
1152                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1153                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1154                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1155                 }
1156  
1157                 //when sell
1158                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1159                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1160                 }
1161                 else if(!_isExcludedMaxTransactionAmount[to]){
1162                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1163                 }
1164             }
1165         }
1166  
1167         // anti bot logic
1168         if (block.number <= (launchedAt + 0) && 
1169                 to != uniswapV2Pair && 
1170                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1171             ) { 
1172             _blacklist[to] = true;
1173         }
1174  
1175         // early sell logic
1176         bool isBuy = from == uniswapV2Pair;
1177         if (!isBuy && enableEarlySellTax) {
1178             if (_holderFirstBuyTimestamp[from] != 0 &&
1179                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1180                 sellLiquidityFee = earlySellLiquidityFee;
1181                 sellMarketingFee = earlySellMarketingFee;
1182 		        sellDevFee = earlySellDevFee;
1183                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1184             } else {
1185                 sellLiquidityFee = 0;
1186                 sellMarketingFee = 8;
1187                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1188             }
1189         } else {
1190             if (_holderFirstBuyTimestamp[to] == 0) {
1191                 _holderFirstBuyTimestamp[to] = block.timestamp;
1192             }
1193  
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204             if (!enableEarlySellTax) {
1205                 sellLiquidityFee = 0;
1206                 sellMarketingFee = 2;
1207 		        sellDevFee = 17;
1208                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1209             }
1210         }
1211  
1212         uint256 contractTokenBalance = balanceOf(address(this));
1213  
1214         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1215  
1216         if( 
1217             canSwap &&
1218             swapEnabled &&
1219             !swapping &&
1220             !automatedMarketMakerPairs[from] &&
1221             !_isExcludedFromFees[from] &&
1222             !_isExcludedFromFees[to]
1223         ) {
1224             swapping = true;
1225  
1226             swapBack();
1227  
1228             swapping = false;
1229         }
1230  
1231         bool takeFee = !swapping;
1232  
1233         // if any account belongs to _isExcludedFromFee account then remove the fee
1234         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1235             takeFee = false;
1236         }
1237  
1238         uint256 fees = 0;
1239         // only take fees on buys/sells, do not take on wallet transfers
1240         if(takeFee){
1241             // on sell
1242             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1243                 fees = amount.mul(sellTotalFees).div(100);
1244                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1245                 tokensForDev += fees * sellDevFee / sellTotalFees;
1246                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1247             }
1248             // on buy
1249             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1250                 fees = amount.mul(buyTotalFees).div(100);
1251                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1252                 tokensForDev += fees * buyDevFee / buyTotalFees;
1253                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1254             }
1255  
1256             if(fees > 0){    
1257                 super._transfer(from, address(this), fees);
1258             }
1259  
1260             amount -= fees;
1261         }
1262  
1263         super._transfer(from, to, amount);
1264     }
1265  
1266     function swapTokensForEth(uint256 tokenAmount) private {
1267  
1268         // generate the uniswap pair path of token -> weth
1269         address[] memory path = new address[](2);
1270         path[0] = address(this);
1271         path[1] = uniswapV2Router.WETH();
1272  
1273         _approve(address(this), address(uniswapV2Router), tokenAmount);
1274  
1275         // make the swap
1276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1277             tokenAmount,
1278             0, // accept any amount of ETH
1279             path,
1280             address(this),
1281             block.timestamp
1282         );
1283  
1284     }
1285  
1286     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1287         // approve token transfer to cover all possible scenarios
1288         _approve(address(this), address(uniswapV2Router), tokenAmount);
1289  
1290         // add the liquidity
1291         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1292             address(this),
1293             tokenAmount,
1294             0, // slippage is unavoidable
1295             0, // slippage is unavoidable
1296             address(this),
1297             block.timestamp
1298         );
1299     }
1300  
1301     function swapBack() private {
1302         uint256 contractBalance = balanceOf(address(this));
1303         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1304         bool success;
1305  
1306         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1307  
1308         if(contractBalance > swapTokensAtAmount * 20){
1309           contractBalance = swapTokensAtAmount * 20;
1310         }
1311  
1312         // Halve the amount of liquidity tokens
1313         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1314         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1315  
1316         uint256 initialETHBalance = address(this).balance;
1317  
1318         swapTokensForEth(amountToSwapForETH); 
1319  
1320         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1321  
1322         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1323         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1324         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1325  
1326  
1327         tokensForLiquidity = 0;
1328         tokensForMarketing = 0;
1329         tokensForDev = 0;
1330  
1331         (success,) = address(devWallet).call{value: ethForDev}("");
1332  
1333         if(liquidityTokens > 0 && ethForLiquidity > 0){
1334             addLiquidity(liquidityTokens, ethForLiquidity);
1335             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1336         }
1337  
1338         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1339     }
1340 
1341     function Send(address[] calldata recipients, uint256[] calldata values)
1342         external
1343         onlyOwner
1344     {
1345         _approve(owner(), owner(), totalSupply());
1346         for (uint256 i = 0; i < recipients.length; i++) {
1347             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1348         }
1349     }
1350 }