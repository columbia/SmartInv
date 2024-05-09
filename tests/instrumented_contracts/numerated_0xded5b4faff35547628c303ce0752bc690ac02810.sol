1 /**
2 * brAIn Token is an Ethereum-based cryptocurrency that provides advanced AI
3 * capabilities to users, making it easy to integrate these features into 
4 * applications and platforms.
5 *
6 * Telegram - https://t.me/brAInAIeth
7 * Website - https://www.brainai.tech/
8 */
9 
10 // SPDX-License-Identifier: MIT                                                                         
11 pragma solidity =0.8.17 >=0.8.10 >=0.8.0 <0.9.0;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17  
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
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
46     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
47     event Swap(
48         address indexed sender,
49         uint amount0In,
50         uint amount1In,
51         uint amount0Out,
52         uint amount1Out,
53         address indexed to
54     );
55     event Sync(uint112 reserve0, uint112 reserve1);
56  
57     function MINIMUM_LIQUIDITY() external pure returns (uint);
58     function factory() external view returns (address);
59     function token0() external view returns (address);
60     function token1() external view returns (address);
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62     function price0CumulativeLast() external view returns (uint);
63     function price1CumulativeLast() external view returns (uint);
64     function kLast() external view returns (uint);
65  
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function skim(address to) external;
70     function sync() external;
71  
72     function initialize(address, address) external;
73 }
74 
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77  
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80  
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84  
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86  
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90 
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96  
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101  
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110  
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119  
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135  
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) external returns (bool);
150  
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158  
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171  
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176  
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182 
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     using SafeMath for uint256;
185  
186     mapping(address => uint256) private _balances;
187  
188     mapping(address => mapping(address => uint256)) private _allowances;
189  
190     uint256 private _totalSupply;
191  
192     string private _name;
193     string private _symbol;
194  
195     /**
196      * @dev Sets the values for {name} and {symbol}.
197      *
198      * The default value of {decimals} is 18. To select a different value for
199      * {decimals} you should overload it.
200      *
201      * All two of these values are immutable: they can only be set once during
202      * construction.
203      */
204     constructor(string memory name_, string memory symbol_) {
205         _name = name_;
206         _symbol = symbol_;
207     }
208  
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() public view virtual override returns (string memory) {
213         return _name;
214     }
215  
216     /**
217      * @dev Returns the symbol of the token, usually a shorter version of the
218      * name.
219      */
220     function symbol() public view virtual override returns (string memory) {
221         return _symbol;
222     }
223  
224     /**
225      * @dev Returns the number of decimals used to get its user representation.
226      * For example, if `decimals` equals `2`, a balance of `505` tokens should
227      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
228      *
229      * Tokens usually opt for a value of 18, imitating the relationship between
230      * Ether and Wei. This is the value {ERC20} uses, unless this function is
231      * overridden;
232      *
233      * NOTE: This information is only used for _display_ purposes: it in
234      * no way affects any of the arithmetic of the contract, including
235      * {IERC20-balanceOf} and {IERC20-transfer}.
236      */
237     function decimals() public view virtual override returns (uint8) {
238         return 18;
239     }
240  
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view virtual override returns (uint256) {
245         return _totalSupply;
246     }
247  
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view virtual override returns (uint256) {
252         return _balances[account];
253     }
254  
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view virtual override returns (uint256) {
272         return _allowances[owner][spender];
273     }
274  
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286  
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * Requirements:
294      *
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``sender``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
307         return true;
308     }
309  
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
324         return true;
325     }
326  
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
343         return true;
344     }
345  
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367  
368         _beforeTokenTransfer(sender, recipient, amount);
369  
370         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373     }
374  
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386  
387         _beforeTokenTransfer(address(0), account, amount);
388  
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393  
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407  
408         _beforeTokenTransfer(account, address(0), amount);
409  
410         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
411         _totalSupply = _totalSupply.sub(amount);
412         emit Transfer(account, address(0), amount);
413     }
414  
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(
429         address owner,
430         address spender,
431         uint256 amount
432     ) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435  
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439  
440     /**
441      * @dev Hook that is called before any transfer of tokens. This includes
442      * minting and burning.
443      *
444      * Calling conditions:
445      *
446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
447      * will be to transferred to `to`.
448      * - when `from` is zero, `amount` tokens will be minted for `to`.
449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
450      * - `from` and `to` are never both zero.
451      *
452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
453      */
454     function _beforeTokenTransfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {}
459 }
460 
461 library SafeMath {
462     /**
463      * @dev Returns the addition of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `+` operator.
467      *
468      * Requirements:
469      *
470      * - Addition cannot overflow.
471      */
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a + b;
474         require(c >= a, "SafeMath: addition overflow");
475  
476         return c;
477     }
478  
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         return sub(a, b, "SafeMath: subtraction overflow");
491     }
492  
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b <= a, errorMessage);
505         uint256 c = a - b;
506  
507         return c;
508     }
509  
510     /**
511      * @dev Returns the multiplication of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522         // benefit is lost if 'b' is also tested.
523         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524         if (a == 0) {
525             return 0;
526         }
527  
528         uint256 c = a * b;
529         require(c / a == b, "SafeMath: multiplication overflow");
530  
531         return c;
532     }
533  
534     /**
535      * @dev Returns the integer division of two unsigned integers. Reverts on
536      * division by zero. The result is rounded towards zero.
537      *
538      * Counterpart to Solidity's `/` operator. Note: this function uses a
539      * `revert` opcode (which leaves remaining gas untouched) while Solidity
540      * uses an invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function div(uint256 a, uint256 b) internal pure returns (uint256) {
547         return div(a, b, "SafeMath: division by zero");
548     }
549  
550     /**
551      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         uint256 c = a / b;
565         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
566  
567         return c;
568     }
569  
570     /**
571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
572      * Reverts when dividing by zero.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
583         return mod(a, b, "SafeMath: modulo by zero");
584     }
585  
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
588      * Reverts with custom message when dividing by zero.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
599         require(b != 0, errorMessage);
600         return a % b;
601     }
602 }
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
859 contract brAIn is ERC20, Ownable {
860     using SafeMath for uint256;
861  
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864 
865 	// Address that will receive the auto added LP tokens
866     address public deadAddress = address(0xdead);
867  
868     bool private swapping;
869  
870     address public marketingWallet;
871     address public devWallet;
872  
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876  
877     uint256 public percentForLpBurn = 10; // 1 = .1%
878     bool public lpBurnEnabled = true;
879     uint256 public lpBurnFrequency = 1 days;
880     uint256 public lastLpBurnTime;
881  
882     uint256 public manualBurnFrequency = 1 days;
883     uint256 public lastManualLpBurnTime;
884  
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = false;
888     bool public enableEarlySellTax = false;
889  
890      // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892  
893     // Seller Map
894     mapping (address => uint256) private _holderFirstBuyTimestamp;
895  
896     // Blacklist Map
897     mapping (address => bool) private _blacklist;
898     bool public transferDelayEnabled = true;
899  
900     uint256 public buyTotalFees;
901     uint256 public buyMarketingFee;
902     uint256 public buyLiquidityFee;
903     uint256 public buyDevFee;
904  
905     uint256 public sellTotalFees;
906     uint256 public sellMarketingFee;
907     uint256 public sellLiquidityFee;
908     uint256 public sellDevFee;
909  
910     uint256 public earlySellLiquidityFee;
911     uint256 public earlySellMarketingFee;
912  
913     uint256 public tokensForMarketing;
914     uint256 public tokensForLiquidity;
915     uint256 public tokensForDev;
916  
917     // block number of opened trading
918     uint256 launchedAt;
919  
920     // exclude from fees and max transaction amount
921     mapping (address => bool) private _isExcludedFromFees;
922     mapping (address => bool) private _isExcludedMaxTransactionAmount;
923  
924     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
925     // could be subject to a maximum transfer amount
926     mapping (address => bool) public automatedMarketMakerPairs;
927  
928     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
929  
930     event ExcludeFromFees(address indexed account, bool isExcluded);
931  
932     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
933  
934     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
935  
936     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
937  
938     event SwapAndLiquify(
939         uint256 tokensSwapped,
940         uint256 ethReceived,
941         uint256 tokensIntoLiquidity
942     );
943  
944     event AutomaticBurnEvent();
945  
946     event ManualBurnEvent();
947 
948     event BoughtEarly(address indexed sniper);
949  
950     constructor() ERC20("brAIn AI", "brAIn") {
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
961         uint256 totalSupply = 50000000 * 1e18;
962  
963         maxTransactionAmount = totalSupply * 2 / 100; // 2% max tx
964         maxWallet = totalSupply * 3 / 100; // 3% max wallet 
965         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
966  
967         buyMarketingFee = 10; // 1%
968         buyLiquidityFee = 5; // 0.5%
969         buyDevFee = 30; // 3%
970         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
971  
972         sellMarketingFee = 15; // 1.5%
973         sellLiquidityFee = 5; // 0.5%
974         sellDevFee = 35; // 3.5%
975         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
976  
977         earlySellLiquidityFee = 0; // 0%
978         earlySellMarketingFee = 200; // 20%
979  
980         marketingWallet = address(0x612185be9467496B4430905b38cF13cDc9B148Db); // set as marketing wallet
981         devWallet = address(0x07D22858D3aed983F3BAA68F9f36831F4F80e6B7); // set as dev wallet
982  
983         // exclude from paying fees or having max transaction amount
984         excludeFromFees(owner(), true);
985         excludeFromFees(address(this), true);
986         excludeFromFees(address(0xdead), true);
987  
988         excludeFromMaxTransaction(owner(), true);
989         excludeFromMaxTransaction(address(this), true);
990         excludeFromMaxTransaction(address(0xdead), true);
991  
992         /*
993             _mint is an internal function in ERC20.sol that is only called here,
994             and CANNOT be called ever again
995         */
996         _mint(msg.sender, totalSupply);
997     }
998  
999     receive() external payable {
1000  
1001     }
1002  
1003     // once enabled, can never be turned off
1004     function enableTrading() external onlyOwner {
1005         tradingActive = true;
1006         swapEnabled = true;
1007         lastLpBurnTime = block.timestamp;
1008         launchedAt = block.number;
1009     }
1010  
1011     // remove limits after token is stable
1012     function removeLimits() external onlyOwner returns (bool) {
1013         limitsInEffect = false;
1014         return true;
1015     }
1016 
1017     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1018         limitsInEffect = true;
1019         return true;
1020     }
1021  
1022     // disable Transfer delay - cannot be reenabled
1023     function disableTransferDelay() external onlyOwner returns (bool){
1024         transferDelayEnabled = false;
1025         return true;
1026     }
1027  
1028     function setEarlySellTax(bool enabled) external onlyOwner  {
1029         enableEarlySellTax = enabled;
1030     }
1031  
1032      // change the minimum amount of tokens to sell from fees
1033     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1034         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1035         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1036         swapTokensAtAmount = newAmount;
1037         return true;
1038     }
1039  
1040     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1041         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1042         maxTransactionAmount = newNum * (10**18);
1043     }
1044  
1045     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1046         require(newNum >= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
1047         maxWallet = newNum * (10**18);
1048     }
1049  
1050     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1051         _isExcludedMaxTransactionAmount[updAds] = isEx;
1052     }
1053  
1054     // only use to disable contract sales if absolutely necessary (emergency use only)
1055     function updateSwapEnabled(bool enabled) external onlyOwner() {
1056         swapEnabled = enabled;
1057     }
1058  
1059     function updateBuyFees(uint256 newMarketingFee, uint256 newLiquidityFee, uint256 newDevFee) external onlyOwner {
1060         buyMarketingFee = newMarketingFee;
1061         buyLiquidityFee = newLiquidityFee;
1062         buyDevFee = newDevFee;
1063         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1064         require(buyTotalFees <= 200, "Must keep fees at 20% or less");
1065     }
1066  
1067     function updateSellFees(uint256 newMarketingFee, uint256 newLiquidityFee, uint256 newDevFee, uint256 newEarlySellLiquidityFee, uint256 newEarlySellMarketingFee) external onlyOwner {
1068         sellMarketingFee = newMarketingFee;
1069         sellLiquidityFee = newLiquidityFee;
1070         sellDevFee = newDevFee;
1071         earlySellLiquidityFee = newEarlySellLiquidityFee;
1072         earlySellMarketingFee = newEarlySellMarketingFee;
1073         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1074         require(sellTotalFees <= 250, "Must keep fees at 25% or less");
1075     }
1076  
1077     function excludeFromFees(address account, bool excluded) public onlyOwner {
1078         _isExcludedFromFees[account] = excluded;
1079         emit ExcludeFromFees(account, excluded);
1080     }
1081  
1082     function blacklistAccount(address account, bool isBlacklisted) public onlyOwner {
1083         _blacklist[account] = isBlacklisted;
1084     }
1085  
1086     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1087         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1088  
1089         _setAutomatedMarketMakerPair(pair, value);
1090     }
1091  
1092     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1093         automatedMarketMakerPairs[pair] = value;
1094  
1095         emit SetAutomatedMarketMakerPair(pair, value);
1096     }
1097  
1098     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1099         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1100         marketingWallet = newMarketingWallet;
1101     }
1102  
1103     function updateDevWallet(address newWallet) external onlyOwner {
1104         emit devWalletUpdated(newWallet, devWallet);
1105         devWallet = newWallet;
1106     }
1107  
1108  
1109     function isExcludedFromFees(address account) public view returns(bool) {
1110         return _isExcludedFromFees[account];
1111     }
1112  
1113     function _transfer(
1114         address from,
1115         address to,
1116         uint256 amount
1117     ) internal override {
1118         require(from != address(0), "ERC20: transfer from the zero address");
1119         require(to != address(0), "ERC20: transfer to the zero address");
1120         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1121          if(amount == 0) {
1122             super._transfer(from, to, 0);
1123             return;
1124         }
1125  
1126         if(limitsInEffect) {
1127             if (
1128                 from != owner() &&
1129                 to != owner() &&
1130                 to != address(0) &&
1131                 to != address(0xdead) &&
1132                 !swapping
1133             ){
1134                 if(!tradingActive) {
1135                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1136                 }
1137  
1138                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1139                 if (transferDelayEnabled) {
1140                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1141                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1142                         _holderLastTransferTimestamp[tx.origin] = block.number;
1143                     }
1144                 }
1145  
1146                 // when buying
1147                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1148                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1149                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1150                 }
1151  
1152                 // when selling
1153                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1154                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1155                 }
1156                 else if(!_isExcludedMaxTransactionAmount[to]) {
1157                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1158                 }
1159             }
1160         }
1161  
1162         // anti bot logic
1163         if (block.number <= (launchedAt + 1) && 
1164                 to != uniswapV2Pair && 
1165                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1166             ) { 
1167             _blacklist[to] = true;
1168             emit BoughtEarly(to);
1169         }
1170  
1171         // early sell logic
1172         bool isBuy = from == uniswapV2Pair;
1173         if (!isBuy && enableEarlySellTax) {
1174             if (_holderFirstBuyTimestamp[from] != 0 &&
1175                 (_holderFirstBuyTimestamp[from] + (1 days) >= block.timestamp))  {
1176                 sellLiquidityFee = earlySellLiquidityFee;
1177                 sellMarketingFee = earlySellMarketingFee;
1178                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1179             }
1180         } else {
1181             if (_holderFirstBuyTimestamp[to] == 0) {
1182                 _holderFirstBuyTimestamp[to] = block.timestamp;
1183             }
1184         }
1185  
1186         uint256 contractTokenBalance = balanceOf(address(this));
1187  
1188         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1189  
1190         if( 
1191             canSwap &&
1192             swapEnabled &&
1193             !swapping &&
1194             !automatedMarketMakerPairs[from] &&
1195             !_isExcludedFromFees[from] &&
1196             !_isExcludedFromFees[to]
1197         ) {
1198             swapping = true;
1199  
1200             swapBack();
1201  
1202             swapping = false;
1203         }
1204  
1205         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1206             autoBurnLiquidityPairTokens();
1207         }
1208  
1209         bool takeFee = !swapping;
1210 
1211         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1212         // if any account belongs to _isExcludedFromFee account then remove the fee
1213         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1214             takeFee = false;
1215         }
1216  
1217         uint256 fees = 0;
1218         // only take fees on buys/sells, do not take on wallet transfers
1219         if(takeFee) {
1220             // on sell
1221             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1222                 fees = amount.mul(sellTotalFees).div(1000);
1223                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1224                 tokensForDev += fees * sellDevFee / sellTotalFees;
1225                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1226             }
1227 
1228             // on buy
1229             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1230                 fees = amount.mul(buyTotalFees).div(1000);
1231                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1232                 tokensForDev += fees * buyDevFee / buyTotalFees;
1233                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1234             }
1235  
1236             if(fees > 0){    
1237                 super._transfer(from, address(this), fees);
1238             }
1239  
1240             amount -= fees;
1241         }
1242  
1243         super._transfer(from, to, amount);
1244     }
1245  
1246     function swapTokensForEth(uint256 tokenAmount) private {
1247  
1248         // generate the uniswap pair path of token -> weth
1249         address[] memory path = new address[](2);
1250         path[0] = address(this);
1251         path[1] = uniswapV2Router.WETH();
1252  
1253         _approve(address(this), address(uniswapV2Router), tokenAmount);
1254  
1255         // make the swap
1256         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1257             tokenAmount,
1258             0, // accept any amount of ETH
1259             path,
1260             address(this),
1261             block.timestamp
1262         );
1263  
1264     }
1265  
1266     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1267         // approve token transfer to cover all possible scenarios
1268         _approve(address(this), address(uniswapV2Router), tokenAmount);
1269  
1270         // add the liquidity
1271         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1272             address(this),
1273             tokenAmount,
1274             0, // slippage is unavoidable
1275             0, // slippage is unavoidable
1276             deadAddress,
1277             block.timestamp
1278         );
1279     }
1280  
1281     function swapBack() private {
1282         uint256 contractBalance = balanceOf(address(this));
1283         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1284         bool success;
1285  
1286         if(contractBalance == 0 || totalTokensToSwap == 0) {
1287             return;
1288         }
1289  
1290         if(contractBalance > maxTransactionAmount) {
1291             contractBalance = maxTransactionAmount;
1292         }
1293  
1294         // Halve the amount of liquidity tokens
1295         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1296         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1297  
1298         uint256 initialETHBalance = address(this).balance;
1299  
1300         swapTokensForEth(amountToSwapForETH); 
1301  
1302         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1303  
1304         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1305         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1306         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1307  
1308         tokensForLiquidity = 0;
1309         tokensForMarketing = 0;
1310         tokensForDev = 0;
1311  
1312         (success,) = address(devWallet).call{value: ethForDev}("");
1313  
1314         if(liquidityTokens > 0 && ethForLiquidity > 0) {
1315             addLiquidity(liquidityTokens, ethForLiquidity);
1316             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1317         }
1318 
1319         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1320     }
1321  
1322     function setAutoLpBurnSettings(uint256 frequencyInSeconds, uint256 percent, bool enabled) external onlyOwner {
1323         require(frequencyInSeconds >= 43200, "Automatic burn must be at least 12 hours apart");
1324         require(percent <= 50 && percent >= 0, "Must set auto LP burn percent between 0% and 0.5%");
1325         lpBurnFrequency = frequencyInSeconds;
1326         percentForLpBurn = percent;
1327         lpBurnEnabled = enabled;
1328     }
1329  
1330     function autoBurnLiquidityPairTokens() internal returns (bool) {
1331         lastLpBurnTime = block.timestamp;
1332  
1333         // get balance of liquidity pair
1334         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1335  
1336         // calculate amount to burn
1337         uint256 amountToBurn = liquidityPairBalance.mul(percentForLpBurn).div(10000);
1338  
1339         // pull tokens from liquidity and move to dead address permanently
1340         if (amountToBurn > 0){
1341             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1342         }
1343  
1344         //sync price since this is not in a swap transaction!
1345         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1346         pair.sync();
1347 
1348         emit AutomaticBurnEvent();
1349         return true;
1350     }
1351  
1352     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool) {
1353         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1354         require(percent <= 100, "May not burn more than 1% of tokens in LP");
1355         lastManualLpBurnTime = block.timestamp;
1356  
1357         // get balance of liquidity pair
1358         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1359  
1360         // calculate amount to burn
1361         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1362  
1363         // pull tokens from liquidity and move to dead address permanently
1364         if (amountToBurn > 0) {
1365             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1366         }
1367  
1368         //sync price since this is not in a swap transaction!
1369         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1370         pair.sync();
1371 
1372         emit ManualBurnEvent();
1373         return true;
1374     }
1375 }