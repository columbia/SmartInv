1 /**
2 
3 ██████╗░░█████╗░███╗░░██╗██████╗░███████╗██████╗░██╗░░░██╗░██████╗░
4 ██╔══██╗██╔══██╗████╗░██║██╔══██╗██╔════╝██╔══██╗██║░░░██║██╔════╝░
5 ██████╔╝███████║██╔██╗██║██║░░██║█████╗░░██████╦╝██║░░░██║██║░░██╗░
6 ██╔═══╝░██╔══██║██║╚████║██║░░██║██╔══╝░░██╔══██╗██║░░░██║██║░░╚██╗
7 ██║░░░░░██║░░██║██║░╚███║██████╔╝███████╗██████╦╝╚██████╔╝╚██████╔╝
8 ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═════╝░░╚═════╝░░╚═════╝░
9 
10 Telegram: https://t.me/pandebugerc
11 Twitter:  https://twitter.com/pandebug
12 
13  */
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.17;
17  
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
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     using SafeMath for uint256;
190  
191     mapping(address => uint256) private _balances;
192  
193     mapping(address => mapping(address => uint256)) private _allowances;
194  
195     uint256 private _totalSupply;
196  
197     string private _name;
198     string private _symbol;
199  
200     /**
201      * @dev Sets the values for {name} and {symbol}.
202      *
203      * The default value of {decimals} is 18. To select a different value for
204      * {decimals} you should overload it.
205      *
206      * All two of these values are immutable: they can only be set once during
207      * construction.
208      */
209     constructor(string memory name_, string memory symbol_) {
210         _name = name_;
211         _symbol = symbol_;
212     }
213  
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view virtual override returns (string memory) {
218         return _name;
219     }
220  
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view virtual override returns (string memory) {
226         return _symbol;
227     }
228  
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei. This is the value {ERC20} uses, unless this function is
236      * overridden;
237      *
238      * NOTE: This information is only used for _display_ purposes: it in
239      * no way affects any of the arithmetic of the contract, including
240      * {IERC20-balanceOf} and {IERC20-transfer}.
241      */
242     function decimals() public view virtual override returns (uint8) {
243         return 18;
244     }
245  
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252  
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address account) public view virtual override returns (uint256) {
257         return _balances[account];
258     }
259  
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `recipient` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272  
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279  
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291  
292     /**
293      * @dev See {IERC20-transferFrom}.
294      *
295      * Emits an {Approval} event indicating the updated allowance. This is not
296      * required by the EIP. See the note at the beginning of {ERC20}.
297      *
298      * Requirements:
299      *
300      * - `sender` and `recipient` cannot be the zero address.
301      * - `sender` must have a balance of at least `amount`.
302      * - the caller must have allowance for ``sender``'s tokens of at least
303      * `amount`.
304      */
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) public virtual override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314  
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
329         return true;
330     }
331  
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
348         return true;
349     }
350  
351     /**
352      * @dev Moves tokens `amount` from `sender` to `recipient`.
353      *
354      * This is internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372  
373         _beforeTokenTransfer(sender, recipient, amount);
374  
375         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
376         _balances[recipient] = _balances[recipient].add(amount);
377         emit Transfer(sender, recipient, amount);
378     }
379  
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391  
392         _beforeTokenTransfer(address(0), account, amount);
393  
394         _totalSupply = _totalSupply.add(amount);
395         _balances[account] = _balances[account].add(amount);
396         emit Transfer(address(0), account, amount);
397     }
398  
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412  
413         _beforeTokenTransfer(account, address(0), amount);
414  
415         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
416         _totalSupply = _totalSupply.sub(amount);
417         emit Transfer(account, address(0), amount);
418     }
419  
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(
434         address owner,
435         address spender,
436         uint256 amount
437     ) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440  
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444  
445     /**
446      * @dev Hook that is called before any transfer of tokens. This includes
447      * minting and burning.
448      *
449      * Calling conditions:
450      *
451      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
452      * will be to transferred to `to`.
453      * - when `from` is zero, `amount` tokens will be minted for `to`.
454      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
455      * - `from` and `to` are never both zero.
456      *
457      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
458      */
459     function _beforeTokenTransfer(
460         address from,
461         address to,
462         uint256 amount
463     ) internal virtual {}
464 }
465  
466 library SafeMath {
467     /**
468      * @dev Returns the addition of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `+` operator.
472      *
473      * Requirements:
474      *
475      * - Addition cannot overflow.
476      */
477     function add(uint256 a, uint256 b) internal pure returns (uint256) {
478         uint256 c = a + b;
479         require(c >= a, "SafeMath: addition overflow");
480  
481         return c;
482     }
483  
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         return sub(a, b, "SafeMath: subtraction overflow");
496     }
497  
498     /**
499      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
500      * overflow (when the result is negative).
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b <= a, errorMessage);
510         uint256 c = a - b;
511  
512         return c;
513     }
514  
515     /**
516      * @dev Returns the multiplication of two unsigned integers, reverting on
517      * overflow.
518      *
519      * Counterpart to Solidity's `*` operator.
520      *
521      * Requirements:
522      *
523      * - Multiplication cannot overflow.
524      */
525     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
526         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
527         // benefit is lost if 'b' is also tested.
528         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
529         if (a == 0) {
530             return 0;
531         }
532  
533         uint256 c = a * b;
534         require(c / a == b, "SafeMath: multiplication overflow");
535  
536         return c;
537     }
538  
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         return div(a, b, "SafeMath: division by zero");
553     }
554  
555     /**
556      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * Counterpart to Solidity's `/` operator. Note: this function uses a
560      * `revert` opcode (which leaves remaining gas untouched) while Solidity
561      * uses an invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
568         require(b > 0, errorMessage);
569         uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571  
572         return c;
573     }
574  
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
588         return mod(a, b, "SafeMath: modulo by zero");
589     }
590  
591     /**
592      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
593      * Reverts with custom message when dividing by zero.
594      *
595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
596      * opcode (which leaves remaining gas untouched) while Solidity uses an
597      * invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b != 0, errorMessage);
605         return a % b;
606     }
607 }
608 
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
662 library SafeMathInt {
663     int256 private constant MIN_INT256 = int256(1) << 255;
664     int256 private constant MAX_INT256 = ~(int256(1) << 255);
665  
666     /**
667      * @dev Multiplies two int256 variables and fails on overflow.
668      */
669     function mul(int256 a, int256 b) internal pure returns (int256) {
670         int256 c = a * b;
671  
672         // Detect overflow when multiplying MIN_INT256 with -1
673         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
674         require((b == 0) || (c / b == a));
675         return c;
676     }
677  
678     /**
679      * @dev Division of two int256 variables and fails on overflow.
680      */
681     function div(int256 a, int256 b) internal pure returns (int256) {
682         // Prevent overflow when dividing MIN_INT256 by -1
683         require(b != -1 || a != MIN_INT256);
684  
685         // Solidity already throws when dividing by 0.
686         return a / b;
687     }
688  
689     /**
690      * @dev Subtracts two int256 variables and fails on overflow.
691      */
692     function sub(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a - b;
694         require((b >= 0 && c <= a) || (b < 0 && c > a));
695         return c;
696     }
697  
698     /**
699      * @dev Adds two int256 variables and fails on overflow.
700      */
701     function add(int256 a, int256 b) internal pure returns (int256) {
702         int256 c = a + b;
703         require((b >= 0 && c >= a) || (b < 0 && c < a));
704         return c;
705     }
706  
707     /**
708      * @dev Converts to absolute value, and fails on overflow.
709      */
710     function abs(int256 a) internal pure returns (int256) {
711         require(a != MIN_INT256);
712         return a < 0 ? -a : a;
713     }
714  
715  
716     function toUint256Safe(int256 a) internal pure returns (uint256) {
717         require(a >= 0);
718         return uint256(a);
719     }
720 }
721  
722 library SafeMathUint {
723   function toInt256Safe(uint256 a) internal pure returns (int256) {
724     int256 b = int256(a);
725     require(b >= 0);
726     return b;
727   }
728 }
729   
730 interface IUniswapV2Router01 {
731     function factory() external pure returns (address);
732     function WETH() external pure returns (address);
733  
734     function addLiquidity(
735         address tokenA,
736         address tokenB,
737         uint amountADesired,
738         uint amountBDesired,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountA, uint amountB, uint liquidity);
744     function addLiquidityETH(
745         address token,
746         uint amountTokenDesired,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline
751     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
752     function removeLiquidity(
753         address tokenA,
754         address tokenB,
755         uint liquidity,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountA, uint amountB);
761     function removeLiquidityETH(
762         address token,
763         uint liquidity,
764         uint amountTokenMin,
765         uint amountETHMin,
766         address to,
767         uint deadline
768     ) external returns (uint amountToken, uint amountETH);
769     function removeLiquidityWithPermit(
770         address tokenA,
771         address tokenB,
772         uint liquidity,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountA, uint amountB);
779     function removeLiquidityETHWithPermit(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountToken, uint amountETH);
788     function swapExactTokensForTokens(
789         uint amountIn,
790         uint amountOutMin,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external returns (uint[] memory amounts);
795     function swapTokensForExactTokens(
796         uint amountOut,
797         uint amountInMax,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external returns (uint[] memory amounts);
802     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
803         external
804         payable
805         returns (uint[] memory amounts);
806     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
810         external
811         returns (uint[] memory amounts);
812     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
813         external
814         payable
815         returns (uint[] memory amounts);
816  
817     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
818     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
819     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
820     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
821     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
822 }
823  
824 interface IUniswapV2Router02 is IUniswapV2Router01 {
825     function removeLiquidityETHSupportingFeeOnTransferTokens(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline
832     ) external returns (uint amountETH);
833     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
834         address token,
835         uint liquidity,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline,
840         bool approveMax, uint8 v, bytes32 r, bytes32 s
841     ) external returns (uint amountETH);
842  
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint amountIn,
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external;
850     function swapExactETHForTokensSupportingFeeOnTransferTokens(
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external payable;
856     function swapExactTokensForETHSupportingFeeOnTransferTokens(
857         uint amountIn,
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external;
863 }
864  
865 contract AntiBotStandardToken is ERC20, Ownable {
866     
867     using SafeMath for uint256;
868  
869     IUniswapV2Router02 public immutable uniswapV2Router;
870     address public immutable uniswapV2Pair;
871  
872     bool private swapping;
873  
874     address private marketingWallet=0x5a1beaCC97C50d80e42AdED46D1C1043834fAfc5;
875     address private DEVWallet=0x5a1beaCC97C50d80e42AdED46D1C1043834fAfc5;
876  
877     uint256 public maxTransactionAmount;
878     uint256 public swapTokensAtAmount;
879     uint256 public maxWalletAmount;
880  
881     bool public limitsInEffect = true;
882     bool public tradingActive = false;
883     bool public swapEnabled = true;
884  
885      // Anti-bot and anti-whale mappings and variables
886     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
887  
888    
889  
890     // Blacklist Map
891     mapping (address => bool) private _blacklist;
892     bool public transferDelayEnabled = true;
893  
894     uint256 private buyTotalFees;
895     uint256 private buyMarketingFee;
896     uint256 private buyLiquidityFee;
897     uint256 private buyDEVFee;
898  
899     uint256 private sellTotalFees;
900     uint256 private sellMarketingFee;
901     uint256 private sellLiquidityFee;
902     uint256 private sellDEVFee;
903  
904     uint256 private tokensForMarketing;
905     uint256 private tokensForLiquidity;
906     uint256 private tokensForDEV;
907  
908     // block number of opened trading
909     uint256 launchedAt;
910  
911     /******************/
912  
913     // exclude from fees and max transaction amount
914     mapping (address => bool) private _isExcludedFromFees;
915     mapping (address => bool) public _isExcludedMaxTransactionAmount;
916  
917     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
918     // could be subject to a maximum transfer amount
919     mapping (address => bool) public automatedMarketMakerPairs;
920  
921     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
922  
923     event ExcludeFromFees(address indexed account, bool isExcluded);
924  
925     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
926  
927     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
928  
929     event DEVWalletUpdated(address indexed newWallet, address indexed oldWallet);
930  
931     event SwapAndLiquify(
932         uint256 tokensSwapped,
933         uint256 ethReceived,
934         uint256 tokensIntoLiquidity
935     );
936  
937     constructor() ERC20("Pandebug", "PANDEBUG") { 
938  
939         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
940  
941         excludeFromMaxTransaction(address(_uniswapV2Router), true);
942         uniswapV2Router = _uniswapV2Router;
943  
944         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
945         excludeFromMaxTransaction(address(uniswapV2Pair), true);
946         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
947  
948         uint256 _buyMarketingFee = 29;
949         uint256 _buyLiquidityFee = 0;
950         uint256 _buyDEVFee = 0;
951 
952         uint256 _sellMarketingFee = 29;
953         uint256 _sellLiquidityFee = 0;
954         uint256 _sellDEVFee = 0;
955  
956         uint256 totalSupply = 888888888888 * 10 ** decimals(); // 
957  
958         maxTransactionAmount = 17777777777 * 10 ** decimals(); // 
959         maxWalletAmount = 17777777777 * 10 ** decimals(); // 
960         swapTokensAtAmount = 8888888888 * 10 ** decimals(); 
961  
962         buyMarketingFee = _buyMarketingFee;
963         buyLiquidityFee = _buyLiquidityFee;
964         buyDEVFee = _buyDEVFee;
965         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDEVFee;
966  
967         sellMarketingFee = _sellMarketingFee;
968         sellLiquidityFee = _sellLiquidityFee;
969         sellDEVFee = _sellDEVFee;
970         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDEVFee;
971  
972         // exclude from paying fees or having max transaction amount
973         excludeFromFees(owner(), true);
974         excludeFromFees(address(this), true);
975         excludeFromFees(address(0xdead), true);
976         
977  
978         excludeFromMaxTransaction(owner(), true);
979         excludeFromMaxTransaction(address(this), true);
980         excludeFromMaxTransaction(address(0xdead), true);
981  
982         /*
983             _mint is an internal function in ERC20.sol that is only called here,
984             and CANNOT be called ever again
985         */
986         _mint(msg.sender, totalSupply);
987     }
988  
989     receive() external payable {
990  
991     }
992  
993     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
994         tradingActive = EnableTrade;
995         swapEnabled = _swap;
996         launchedAt = block.number;
997     }
998  
999     // remove limits after token is stable
1000     function removeLimits() external onlyOwner returns (bool){
1001         limitsInEffect = false;
1002         return true;
1003     }
1004  
1005     // disable Transfer delay - cannot be reenabled
1006     function disableTransferDelay() external onlyOwner returns (bool){
1007         transferDelayEnabled = false;
1008         return true;
1009     }
1010  
1011      // change the minimum amount of tokens to sell from fees
1012     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1013         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1014         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1015         swapTokensAtAmount = newAmount;
1016         return true;
1017     }
1018  
1019     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1020         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1021         maxTransactionAmount = newNum;
1022     }
1023  
1024     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1025         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1026         maxWalletAmount = newNum;
1027     }
1028  
1029     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1030         _isExcludedMaxTransactionAmount[updAds] = isEx;
1031     }
1032  
1033    
1034     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DEVFee_) external onlyOwner {
1035         sellMarketingFee = _marketingFee;
1036         sellLiquidityFee = _liquidityFee;
1037         sellDEVFee = _DEVFee_;
1038         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDEVFee;
1039         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
1040     }
1041  
1042     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DEVFee_) external onlyOwner {
1043         buyMarketingFee = _marketingFee;
1044         buyLiquidityFee = _liquidityFee;
1045         buyDEVFee = _DEVFee_;
1046         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDEVFee;
1047         require(buyTotalFees <= 60, "Must keep fees at 40% or less");
1048     }
1049 
1050 
1051     function excludeFromFees(address account, bool excluded) public onlyOwner {
1052         _isExcludedFromFees[account] = excluded;
1053         emit ExcludeFromFees(account, excluded);
1054     }
1055  
1056     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1057         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1058  
1059         _setAutomatedMarketMakerPair(pair, value);
1060     }
1061  
1062     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1063         automatedMarketMakerPairs[pair] = value;
1064  
1065         emit SetAutomatedMarketMakerPair(pair, value);
1066     }
1067 
1068         function AddBots(address[] memory bots_) public onlyOwner {
1069 for (uint i = 0; i < bots_.length; i++) {
1070             _blacklist[bots_[i]] = true;
1071         
1072 }
1073     }
1074 
1075 function Del(address[] memory notbot) public onlyOwner {
1076       for (uint i = 0; i < notbot.length; i++) {
1077           _blacklist[notbot[i]] = false;
1078       }
1079     }
1080 
1081     function check(address wallet) public view returns (bool){
1082       return _blacklist[wallet];
1083     }
1084 
1085 
1086 
1087  
1088     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1089         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1090         marketingWallet = newMarketingWallet;
1091     }
1092  
1093     function updateDEVWallet(address newWallet) external onlyOwner {
1094         emit DEVWalletUpdated(newWallet, DEVWallet);
1095         DEVWallet = newWallet;
1096     }
1097  
1098     function isExcludedFromFees(address account) public view returns(bool) {
1099         return _isExcludedFromFees[account];
1100     }
1101 
1102 
1103 
1104   function Airdrop(
1105         address[] memory airdropWallets,
1106         uint256[] memory amount
1107     ) external onlyOwner {
1108         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1109         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1110         for (uint256 i = 0; i < airdropWallets.length; i++) {
1111             address wallet = airdropWallets[i];
1112             uint256 airdropAmount = amount[i] * (10**18);
1113             super._transfer(msg.sender, wallet, airdropAmount);
1114         }
1115     }
1116 
1117  
1118  
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 amount
1123     ) internal override {
1124         require(from != address(0), "ERC20: transfer from the zero address");
1125         require(to != address(0), "ERC20: transfer to the zero address");
1126         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1127          if(amount == 0) {
1128             super._transfer(from, to, 0);
1129             return;
1130         }
1131  
1132         if(limitsInEffect){
1133             if (
1134                 from != owner() &&
1135                 to != owner() &&
1136                 to != address(0) &&
1137                 to != address(0xdead) &&
1138                 !swapping
1139             ){
1140                 if(!tradingActive){
1141                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1142                 }
1143  
1144                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1145                 if (transferDelayEnabled){
1146                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1147                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1148                         _holderLastTransferTimestamp[tx.origin] = block.number;
1149                     }
1150                 }
1151  
1152                 //when buy
1153                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1154                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1155                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1156                 }
1157  
1158                 //when sell
1159                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1160                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1161                 }
1162                 else if(!_isExcludedMaxTransactionAmount[to]){
1163                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1164                 }
1165             }
1166         }
1167  
1168         // anti bot logic
1169         if (block.number <= (launchedAt + 0) && 
1170                 to != uniswapV2Pair && 
1171                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1172             ) { 
1173             _blacklist[to] = true;
1174         }
1175  
1176         uint256 contractTokenBalance = balanceOf(address(this));
1177  
1178         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1179  
1180         if( 
1181             canSwap &&
1182             swapEnabled &&
1183             !swapping &&
1184             !automatedMarketMakerPairs[from] &&
1185             !_isExcludedFromFees[from] &&
1186             !_isExcludedFromFees[to]
1187         ) {
1188             swapping = true;
1189  
1190             swapBack();
1191  
1192             swapping = false;
1193         }
1194  
1195         bool takeFee = !swapping;
1196  
1197         // if any account belongs to _isExcludedFromFee account then remove the fee
1198         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1199             takeFee = false;
1200         }
1201  
1202         uint256 fees = 0;
1203         // only take fees on buys/sells, do not take on wallet transfers
1204         if(takeFee){
1205             // on sell
1206             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1207                 fees = amount.mul(sellTotalFees).div(100);
1208                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1209                 tokensForDEV += fees * sellDEVFee / sellTotalFees;
1210                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1211             }
1212             // on buy
1213             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1214                 fees = amount.mul(buyTotalFees).div(100);
1215                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1216                 tokensForDEV += fees * buyDEVFee / buyTotalFees;
1217                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1218             }
1219  
1220             if(fees > 0){    
1221                 super._transfer(from, address(this), fees);
1222             }
1223  
1224             amount -= fees;
1225         }
1226  
1227         super._transfer(from, to, amount);
1228     }
1229  
1230     function swapTokensForEth(uint256 tokenAmount) private {
1231  
1232         // generate the uniswap pair path of token -> weth
1233         address[] memory path = new address[](2);
1234         path[0] = address(this);
1235         path[1] = uniswapV2Router.WETH();
1236  
1237         _approve(address(this), address(uniswapV2Router), tokenAmount);
1238  
1239         // make the swap
1240         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1241             tokenAmount,
1242             0, // accept any amount of ETH
1243             path,
1244             address(this),
1245             block.timestamp
1246         );
1247  
1248     }
1249  
1250     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1251         // approve token transfer to cover all possible scenarios
1252         _approve(address(this), address(uniswapV2Router), tokenAmount);
1253  
1254         // add the liquidity
1255         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1256             address(this),
1257             tokenAmount,
1258             0, // slippage is unavoidable
1259             0, // slippage is unavoidable
1260             address(this),
1261             block.timestamp
1262         );
1263     }
1264  
1265     function swapBack() private {
1266         uint256 contractBalance = balanceOf(address(this));
1267         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDEV;
1268         bool success;
1269  
1270         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1271  
1272         if(contractBalance > swapTokensAtAmount * 20){
1273           contractBalance = swapTokensAtAmount * 20;
1274         }
1275  
1276         // Halve the amount of liquidity tokens
1277         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1278         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1279  
1280         uint256 initialETHBalance = address(this).balance;
1281  
1282         swapTokensForEth(amountToSwapForETH); 
1283  
1284         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1285  
1286         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1287         uint256 ethForDEV = ethBalance.mul(tokensForDEV).div(totalTokensToSwap);
1288         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDEV;
1289  
1290  
1291         tokensForLiquidity = 0;
1292         tokensForMarketing = 0;
1293         tokensForDEV = 0;
1294  
1295         (success,) = address(DEVWallet).call{value: ethForDEV}("");
1296  
1297         if(liquidityTokens > 0 && ethForLiquidity > 0){
1298             addLiquidity(liquidityTokens, ethForLiquidity);
1299             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1300         }
1301  
1302         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1303     }
1304     
1305   
1306 }