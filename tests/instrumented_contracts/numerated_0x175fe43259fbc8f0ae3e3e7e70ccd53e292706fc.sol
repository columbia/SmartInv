1 /**
2 
3 Scan, Analyze and Empower Your Wallet's Potential with Alpha Insight. 
4 
5 Website:   https://AlphaInsight.tech
6 Twitter:   https://twitter.com/AlphaInsightETH
7 Telegram:  https://t.me/AlphaInsightETH
8 
9  */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95  
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100  
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109  
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118  
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134  
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) external returns (bool);
149  
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157  
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164  
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170  
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175  
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181  
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     using SafeMath for uint256;
184  
185     mapping(address => uint256) private _balances;
186  
187     mapping(address => mapping(address => uint256)) private _allowances;
188  
189     uint256 private _totalSupply;
190  
191     string private _name;
192     string private _symbol;
193  
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207  
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214  
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222  
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 18;
238     }
239  
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246  
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253  
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266  
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273  
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
306         return true;
307     }
308  
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
323         return true;
324     }
325  
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
342         return true;
343     }
344  
345     /**
346      * @dev Moves tokens `amount` from `sender` to `recipient`.
347      *
348      * This is internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366  
367         _beforeTokenTransfer(sender, recipient, amount);
368  
369         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
370         _balances[recipient] = _balances[recipient].add(amount);
371         emit Transfer(sender, recipient, amount);
372     }
373  
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385  
386         _beforeTokenTransfer(address(0), account, amount);
387  
388         _totalSupply = _totalSupply.add(amount);
389         _balances[account] = _balances[account].add(amount);
390         emit Transfer(address(0), account, amount);
391     }
392  
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406  
407         _beforeTokenTransfer(account, address(0), amount);
408  
409         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
410         _totalSupply = _totalSupply.sub(amount);
411         emit Transfer(account, address(0), amount);
412     }
413  
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434  
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438  
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be to transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 }
459  
460 library SafeMath {
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474  
475         return c;
476     }
477  
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return sub(a, b, "SafeMath: subtraction overflow");
490     }
491  
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
494      * overflow (when the result is negative).
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         uint256 c = a - b;
505  
506         return c;
507     }
508  
509     /**
510      * @dev Returns the multiplication of two unsigned integers, reverting on
511      * overflow.
512      *
513      * Counterpart to Solidity's `*` operator.
514      *
515      * Requirements:
516      *
517      * - Multiplication cannot overflow.
518      */
519     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
520         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
521         // benefit is lost if 'b' is also tested.
522         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
523         if (a == 0) {
524             return 0;
525         }
526  
527         uint256 c = a * b;
528         require(c / a == b, "SafeMath: multiplication overflow");
529  
530         return c;
531     }
532  
533     /**
534      * @dev Returns the integer division of two unsigned integers. Reverts on
535      * division by zero. The result is rounded towards zero.
536      *
537      * Counterpart to Solidity's `/` operator. Note: this function uses a
538      * `revert` opcode (which leaves remaining gas untouched) while Solidity
539      * uses an invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function div(uint256 a, uint256 b) internal pure returns (uint256) {
546         return div(a, b, "SafeMath: division by zero");
547     }
548  
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         uint256 c = a / b;
564         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
565  
566         return c;
567     }
568  
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * Reverts when dividing by zero.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
582         return mod(a, b, "SafeMath: modulo by zero");
583     }
584  
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts with custom message when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b != 0, errorMessage);
599         return a % b;
600     }
601 }
602 
603  
604 contract Ownable is Context {
605     address private _owner;
606  
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608  
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor () {
613         address msgSender = _msgSender();
614         _owner = msgSender;
615         emit OwnershipTransferred(address(0), msgSender);
616     }
617  
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view returns (address) {
622         return _owner;
623     }
624  
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(_owner == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632  
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         emit OwnershipTransferred(_owner, address(0));
642         _owner = address(0);
643     }
644  
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655  
656 library SafeMathInt {
657     int256 private constant MIN_INT256 = int256(1) << 255;
658     int256 private constant MAX_INT256 = ~(int256(1) << 255);
659  
660     /**
661      * @dev Multiplies two int256 variables and fails on overflow.
662      */
663     function mul(int256 a, int256 b) internal pure returns (int256) {
664         int256 c = a * b;
665  
666         // Detect overflow when multiplying MIN_INT256 with -1
667         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
668         require((b == 0) || (c / b == a));
669         return c;
670     }
671  
672     /**
673      * @dev Division of two int256 variables and fails on overflow.
674      */
675     function div(int256 a, int256 b) internal pure returns (int256) {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678  
679         // Solidity already throws when dividing by 0.
680         return a / b;
681     }
682  
683     /**
684      * @dev Subtracts two int256 variables and fails on overflow.
685      */
686     function sub(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a - b;
688         require((b >= 0 && c <= a) || (b < 0 && c > a));
689         return c;
690     }
691  
692     /**
693      * @dev Adds two int256 variables and fails on overflow.
694      */
695     function add(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a + b;
697         require((b >= 0 && c >= a) || (b < 0 && c < a));
698         return c;
699     }
700  
701     /**
702      * @dev Converts to absolute value, and fails on overflow.
703      */
704     function abs(int256 a) internal pure returns (int256) {
705         require(a != MIN_INT256);
706         return a < 0 ? -a : a;
707     }
708  
709  
710     function toUint256Safe(int256 a) internal pure returns (uint256) {
711         require(a >= 0);
712         return uint256(a);
713     }
714 }
715  
716 library SafeMathUint {
717   function toInt256Safe(uint256 a) internal pure returns (int256) {
718     int256 b = int256(a);
719     require(b >= 0);
720     return b;
721   }
722 }
723   
724 interface IUniswapV2Router01 {
725     function factory() external pure returns (address);
726     function WETH() external pure returns (address);
727  
728     function addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint amountADesired,
732         uint amountBDesired,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountA, uint amountB, uint liquidity);
738     function addLiquidityETH(
739         address token,
740         uint amountTokenDesired,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline
745     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
746     function removeLiquidity(
747         address tokenA,
748         address tokenB,
749         uint liquidity,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETH(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountToken, uint amountETH);
763     function removeLiquidityWithPermit(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountToken, uint amountETH);
782     function swapExactTokensForTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapTokensForExactTokens(
790         uint amountOut,
791         uint amountInMax,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810  
811     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
812     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
814     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
815     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
816 }
817  
818 interface IUniswapV2Router02 is IUniswapV2Router01 {
819     function removeLiquidityETHSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline
826     ) external returns (uint amountETH);
827     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountETH);
836  
837     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
838         uint amountIn,
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external;
844     function swapExactETHForTokensSupportingFeeOnTransferTokens(
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external payable;
850     function swapExactTokensForETHSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857 }
858  
859 contract AI is ERC20, Ownable {
860     
861     using SafeMath for uint256;
862  
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865  
866     bool private swapping;
867  
868     address private alphamarketing=0x17E403dcEA57Dd048Cc085B22398C700fF7E0e10;
869     address private alphadevelopment=0x17E403dcEA57Dd048Cc085B22398C700fF7E0e10;
870  
871     uint256 private maxTransactionAmount;
872     uint256 public swapTokensAtAmount;
873     uint256 private maxWalletAmount;
874  
875     bool public limitsInEffect = true;
876     bool public tradingActive = false;
877     bool public swapEnabled = true;
878  
879      // Anti-bot and anti-whale mappings and variables
880     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
881  
882    
883  
884     // Blacklist Map
885     mapping (address => bool) private _blacklist;
886     bool public transferDelayEnabled = false;
887  
888     uint256 private buyTotalFees;
889     uint256 private buyMarketingFee;
890     uint256 private buyLiquidityFee;
891     uint256 private buydevFee;
892  
893     uint256 private sellTotalFees;
894     uint256 private sellMarketingFee;
895     uint256 private sellLiquidityFee;
896     uint256 private selldevFee;
897  
898     uint256 private tokensForMarketing;
899     uint256 private tokensForLiquidity;
900     uint256 private tokensFordev;
901  
902     // block number of opened trading
903     uint256 launchedAt;
904  
905     /******************/
906  
907     // exclude from fees and max transaction amount
908     mapping (address => bool) private _isExcludedFromFees;
909     mapping (address => bool) private Allow;
910  
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914  
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916  
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918  
919     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
920  
921     event alphamarketingUpdated(address indexed newWallet, address indexed oldWallet);
922  
923     event alphadevelopmentUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event SwapAndLiquify(
926         uint256 tokensSwapped,
927         uint256 ethReceived,
928         uint256 tokensIntoLiquidity
929     );
930  
931     constructor() ERC20("Alpha Insight", "AI") { 
932  
933         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
934  
935         excludeFromMaxTransaction(address(_uniswapV2Router), true);
936         uniswapV2Router = _uniswapV2Router;
937  
938         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
939         excludeFromMaxTransaction(address(uniswapV2Pair), true);
940         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
941  
942         uint256 _buyMarketingFee = 40;
943         uint256 _buyLiquidityFee = 0;
944         uint256 _buydevFee = 0;
945 
946         uint256 _sellMarketingFee = 20;
947         uint256 _sellLiquidityFee = 0;
948         uint256 _selldevFee = 0;
949  
950         uint256 totalSupply = 1000000 * 10 ** decimals(); 
951  
952         maxTransactionAmount = 20000 * 10 ** decimals(); 
953         maxWalletAmount = 20000 * 10 ** decimals(); 
954         swapTokensAtAmount = 10000 * 10 ** decimals(); 
955  
956         buyMarketingFee = _buyMarketingFee;
957         buyLiquidityFee = _buyLiquidityFee;
958         buydevFee = _buydevFee;
959         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevFee;
960  
961         sellMarketingFee = _sellMarketingFee;
962         sellLiquidityFee = _sellLiquidityFee;
963         selldevFee = _selldevFee;
964         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevFee;
965  
966         excludeFromFees(owner(), true);
967         excludeFromFees(address(this), true);
968         excludeFromFees(address(0xdead), true);
969         
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
986     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
987         tradingActive = EnableTrade;
988         swapEnabled = _swap;
989         launchedAt = block.number;
990     }
991  
992     function removeLimits() external onlyOwner returns (bool){
993         limitsInEffect = false;
994         return true;
995     }
996  
997     function disableTransferDelay() external onlyOwner returns (bool){
998         transferDelayEnabled = false;
999         return true;
1000     }
1001  
1002      // change the minimum amount of tokens to sell from fees
1003     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1004         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1005         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1006         swapTokensAtAmount = newAmount;
1007         return true;
1008     }
1009  
1010     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1011         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1012         maxTransactionAmount = newNum;
1013     }
1014  
1015     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1016         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1017         maxWalletAmount = newNum;
1018     }
1019  
1020     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1021         Allow[updAds] = isEx;
1022     }
1023  
1024    
1025     function TaxOut(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee_) external onlyOwner {
1026         sellMarketingFee = _marketingFee;
1027         sellLiquidityFee = _liquidityFee;
1028         selldevFee = _devFee_;
1029         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevFee;
1030         require(sellTotalFees <= 25, "Limit 25%");
1031     }
1032  
1033     function TaxIn(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee_) external onlyOwner {
1034         buyMarketingFee = _marketingFee;
1035         buyLiquidityFee = _liquidityFee;
1036         buydevFee = _devFee_;
1037         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevFee;
1038         require(buyTotalFees <= 50, "Limit 50%");
1039     }
1040 
1041 
1042     function excludeFromFees(address account, bool excluded) public onlyOwner {
1043         _isExcludedFromFees[account] = excluded;
1044         emit ExcludeFromFees(account, excluded);
1045     }
1046  
1047     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1048         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1049  
1050         _setAutomatedMarketMakerPair(pair, value);
1051     }
1052  
1053     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1054         automatedMarketMakerPairs[pair] = value;
1055  
1056         emit SetAutomatedMarketMakerPair(pair, value);
1057     }
1058 
1059         function AddBots(address[] memory bots_) public onlyOwner {
1060 for (uint i = 0; i < bots_.length; i++) {
1061             _blacklist[bots_[i]] = true;
1062         
1063 }
1064     }
1065 
1066 function Remove(address[] memory notbot) public onlyOwner {
1067       for (uint i = 0; i < notbot.length; i++) {
1068           _blacklist[notbot[i]] = false;
1069       }
1070     }
1071 
1072     function Add(address wallet) public view returns (bool){
1073       return _blacklist[wallet];
1074     }
1075 
1076     function updatealphamarketing(address newalphamarketing) external onlyOwner {
1077         emit alphamarketingUpdated(newalphamarketing, alphamarketing);
1078         alphamarketing = newalphamarketing;
1079     }
1080  
1081     function updatealphadevelopment(address newWallet) external onlyOwner {
1082         emit alphadevelopmentUpdated(newWallet, alphadevelopment);
1083         alphadevelopment = newWallet;
1084     }
1085  
1086     function isExcludedFromFees(address account) public view returns(bool) {
1087         return _isExcludedFromFees[account];
1088     }
1089 
1090   function Airdrop(
1091         address[] memory airdropWallets,
1092         uint256[] memory amount
1093     ) external onlyOwner {
1094         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1095         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1096         for (uint256 i = 0; i < airdropWallets.length; i++) {
1097             address wallet = airdropWallets[i];
1098             uint256 airdropAmount = amount[i] * (10**18);
1099             super._transfer(msg.sender, wallet, airdropAmount);
1100         }
1101     }
1102 
1103     function _transfer(
1104         address from,
1105         address to,
1106         uint256 amount
1107     ) internal override {
1108         require(from != address(0), "ERC20: transfer from the zero address");
1109         require(to != address(0), "ERC20: transfer to the zero address");
1110         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1111          if(amount == 0) {
1112             super._transfer(from, to, 0);
1113             return;
1114         }
1115  
1116         if(limitsInEffect){
1117             if (
1118                 from != owner() &&
1119                 to != owner() &&
1120                 to != address(0) &&
1121                 to != address(0xdead) &&
1122                 !swapping
1123             ){
1124                 if(!tradingActive){
1125                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1126                 }
1127  
1128                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1129                 if (transferDelayEnabled){
1130                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1131                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1132                         _holderLastTransferTimestamp[tx.origin] = block.number;
1133                     }
1134                 }
1135  
1136                 //when buy
1137                 if (automatedMarketMakerPairs[from] && !Allow[to]) {
1138                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1139                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1140                 }
1141  
1142                 //when sell
1143                 else if (automatedMarketMakerPairs[to] && !Allow[from]) {
1144                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1145                 }
1146                 else if(!Allow[to]){
1147                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1148                 }
1149             }
1150         }
1151  
1152         // anti bot logic
1153         if (block.number <= (launchedAt + 0) && 
1154                 to != uniswapV2Pair && 
1155                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1156             ) { 
1157             _blacklist[to] = false;
1158         }
1159  
1160         uint256 contractTokenBalance = balanceOf(address(this));
1161  
1162         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1163  
1164         if( 
1165             canSwap &&
1166             swapEnabled &&
1167             !swapping &&
1168             !automatedMarketMakerPairs[from] &&
1169             !_isExcludedFromFees[from] &&
1170             !_isExcludedFromFees[to]
1171         ) {
1172             swapping = true;
1173  
1174             swapBack();
1175  
1176             swapping = false;
1177         }
1178  
1179         bool takeFee = !swapping;
1180  
1181         // if any account belongs to _isExcludedFromFee account then remove the fee
1182         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1183             takeFee = false;
1184         }
1185  
1186         uint256 fees = 0;
1187         // only take fees on buys/sells, do not take on wallet transfers
1188         if(takeFee){
1189             // on sell
1190             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1191                 fees = amount.mul(sellTotalFees).div(100);
1192                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1193                 tokensFordev += fees * selldevFee / sellTotalFees;
1194                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1195             }
1196             // on buy
1197             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1198                 fees = amount.mul(buyTotalFees).div(100);
1199                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1200                 tokensFordev += fees * buydevFee / buyTotalFees;
1201                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1202             }
1203  
1204             if(fees > 0){    
1205                 super._transfer(from, address(this), fees);
1206             }
1207  
1208             amount -= fees;
1209         }
1210  
1211         super._transfer(from, to, amount);
1212     }
1213  
1214     function swapTokensForEth(uint256 tokenAmount) private {
1215  
1216         // generate the uniswap pair path of token -> weth
1217         address[] memory path = new address[](2);
1218         path[0] = address(this);
1219         path[1] = uniswapV2Router.WETH();
1220  
1221         _approve(address(this), address(uniswapV2Router), tokenAmount);
1222  
1223         // make the swap
1224         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1225             tokenAmount,
1226             0, // accept any amount of ETH
1227             path,
1228             address(this),
1229             block.timestamp
1230         );
1231  
1232     }
1233  
1234     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1235         // approve token transfer to cover all possible scenarios
1236         _approve(address(this), address(uniswapV2Router), tokenAmount);
1237  
1238         // add the liquidity
1239         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1240             address(this),
1241             tokenAmount,
1242             0, // slippage is unavoidable
1243             0, // slippage is unavoidable
1244             address(this),
1245             block.timestamp
1246         );
1247     }
1248  
1249     function swapBack() private {
1250         uint256 contractBalance = balanceOf(address(this));
1251         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensFordev;
1252         bool success;
1253  
1254         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1255  
1256         if(contractBalance > swapTokensAtAmount * 20){
1257           contractBalance = swapTokensAtAmount * 20;
1258         }
1259  
1260         // Halve the amount of liquidity tokens
1261         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1262         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1263  
1264         uint256 initialETHBalance = address(this).balance;
1265  
1266         swapTokensForEth(amountToSwapForETH); 
1267  
1268         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1269  
1270         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1271         uint256 ethFordev = ethBalance.mul(tokensFordev).div(totalTokensToSwap);
1272         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethFordev;
1273  
1274  
1275         tokensForLiquidity = 0;
1276         tokensForMarketing = 0;
1277         tokensFordev = 0;
1278  
1279         (success,) = address(alphadevelopment).call{value: ethFordev}("");
1280  
1281         if(liquidityTokens > 0 && ethForLiquidity > 0){
1282             addLiquidity(liquidityTokens, ethForLiquidity);
1283             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1284         }
1285  
1286         (success,) = address(alphamarketing).call{value: address(this).balance}("");
1287     }
1288     
1289   
1290 }