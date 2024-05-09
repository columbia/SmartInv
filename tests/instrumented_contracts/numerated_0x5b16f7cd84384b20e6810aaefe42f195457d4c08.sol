1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*
4 Telegram: https://t.me/Juice4Apes
5 Twitter: https://twitter.com/apejuice_erc
6 Website: https://apejuiceerc.com
7 */
8 
9 pragma solidity 0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25 
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32 
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36 
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40 
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42 
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54 
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63 
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69 
70     function initialize(address, address) external;
71 }
72 
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75 
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78 
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82 
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88 
89 interface IERC20 {
90     /**
91      * @dev Returns the amount of tokens in existence.
92      */
93     function totalSupply() external view returns (uint256);
94 
95     /**
96      * @dev Returns the amount of tokens owned by `account`.
97      */
98     function balanceOf(address account) external view returns (uint256);
99 
100     /**
101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Returns the remaining number of tokens that `spender` will be
111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117 
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 interface IERC20Metadata is IERC20 {
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() external view returns (string memory);
169 
170     /**
171      * @dev Returns the symbol of the token.
172      */
173     function symbol() external view returns (string memory);
174 
175     /**
176      * @dev Returns the decimals places of the token.
177      */
178     function decimals() external view returns (uint8);
179 }
180 
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
603 contract Ownable is Context {
604     address private _owner;
605     address private _manager;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608     event ManagementTransferred(address indexed previousManager, address indexed newManager);
609     
610     constructor () {
611         address msgSender = _msgSender();
612         _owner = msgSender;
613         _manager = msgSender;
614         emit OwnershipTransferred(address(0), msgSender);
615         emit ManagementTransferred(address(0), msgSender);
616     }
617 //Owner
618     function owner() public view returns (address) {
619         return _owner;
620     }
621 
622     modifier onlyOwner() {
623         require(_owner == _msgSender(), "Ownable: caller is not the owner");
624         _;
625     }
626 
627     function renounceOwnership() public virtual onlyOwner {
628         emit OwnershipTransferred(_owner, address(0));
629         _owner = address(0);
630     }
631 
632     function transferOwnership(address newOwner) public virtual onlyOwner {
633         require(newOwner != address(0), "Ownable: new owner is the zero address");
634         emit OwnershipTransferred(_owner, newOwner);
635         _owner = newOwner;
636     }
637 
638 //Manager
639     function manager() public view returns (address) {
640         return _manager;
641     }
642 
643     modifier onlyManager() {
644         require(_manager == _msgSender(), "Ownable: caller is not the owner");
645         _;
646     }
647 
648     function renounceManagement() public virtual onlyOwner {
649         emit ManagementTransferred(_manager, address(0));
650         _manager = address(0);
651     }
652 
653     function transferManagement(address newManager) public virtual onlyOwner {
654         require(newManager != address(0), "Ownable: new owner is the zero address");
655         emit ManagementTransferred(_manager, newManager);
656         _manager = newManager;
657     }
658 }
659 library SafeMathInt {
660     int256 private constant MIN_INT256 = int256(1) << 255;
661     int256 private constant MAX_INT256 = ~(int256(1) << 255);
662     /**
663      * @dev Multiplies two int256 variables and fails on overflow.
664      */
665     function mul(int256 a, int256 b) internal pure returns (int256) {
666         int256 c = a * b;
667         // Detect overflow when multiplying MIN_INT256 with -1
668         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
669         require((b == 0) || (c / b == a));
670         return c;
671     }
672     /**
673      * @dev Division of two int256 variables and fails on overflow.
674      */
675     function div(int256 a, int256 b) internal pure returns (int256) {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678         // Solidity already throws when dividing by 0.
679         return a / b;
680     }
681     /**
682      * @dev Subtracts two int256 variables and fails on overflow.
683      */
684     function sub(int256 a, int256 b) internal pure returns (int256) {
685         int256 c = a - b;
686         require((b >= 0 && c <= a) || (b < 0 && c > a));
687         return c;
688     }
689     /**
690      * @dev Adds two int256 variables and fails on overflow.
691      */
692     function add(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a + b;
694         require((b >= 0 && c >= a) || (b < 0 && c < a));
695         return c;
696     }
697     /**
698      * @dev Converts to absolute value, and fails on overflow.
699      */
700     function abs(int256 a) internal pure returns (int256) {
701         require(a != MIN_INT256);
702         return a < 0 ? -a : a;
703     }
704     function toUint256Safe(int256 a) internal pure returns (uint256) {
705         require(a >= 0);
706         return uint256(a);
707     }
708 }
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
853 contract Token is ERC20, Ownable {
854     using SafeMath for uint256;
855 
856     mapping (address => uint256) private _rOwned;
857     uint256 private constant MAX = ~uint256(0);
858     uint256 private constant _tTotal = 1 * 1e6 * 1e18;
859     uint256 private _rTotal = (MAX - (MAX % _tTotal));
860     uint256 private _tFeeTotal;
861     
862     uint256 public maxTransactionAmount = _tTotal * 1/1000;
863     uint256 public maxWallet = _tTotal * 1 / 1000;
864 
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867     address public constant deadAddress = address(0xdead);
868 
869     bool private swapping;
870 
871     bool public limitsInEffect = true;
872     bool public tradingActive = false;
873     
874      // Anti-bot and anti-whale mappings and variables
875     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
876     mapping(address => uint256) private _holderLastBuyTimestamp; //Sets penalty fee after each buy
877     bool public transferDelayEnabled = true;
878 
879 
880     uint256 public ReflectionFee = 4;
881     uint256 public JuicePoolFee = 4;
882 
883     // Penalty Fee for Sell
884     uint256 public earlySellReflectionFee = 12;
885     uint256 public earlySellPoolFee = 12;
886 
887     // Penalty Fee Time
888     uint256 public penaltyFeeTime = 900; // by seconds units
889 
890     // block number of opened trading
891     uint256 launchedAt;
892     
893     uint256 public max;
894     bool public poolEnabled = false;
895     /******************/
896 
897     // exclude from fees, max transaction amount and max wallet amount
898     mapping (address => bool) private _isExcludedFromFees;
899     mapping (address => bool) public _isExcludedMaxTransactionAmount;
900     mapping (address => bool) public _isExcludedMaxWalletAmount;
901 
902     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
903     // could be subject to a maximum transfer amount
904     mapping (address => bool) public automatedMarketMakerPairs;
905 
906     event ExcludeFromFees(address indexed account, bool isExcluded);
907 
908     event ExcludeFromMaxTransaction(address indexed account, bool isExcluded);
909 
910     event ExcludeFromMaxWallet(address indexed account, bool isExcluded);
911 
912     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
913 
914     constructor() ERC20("Ape Juice", "$JUICE") {
915         
916         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
917         
918         excludeFromMaxTransaction(address(_uniswapV2Router), true);
919         excludeFromMaxWallet(address(_uniswapV2Router), true);
920         uniswapV2Router = _uniswapV2Router;
921         
922         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
923         excludeFromMaxTransaction(address(uniswapV2Pair), true);
924         excludeFromMaxWallet(address(uniswapV2Pair), true);
925         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
926 
927         _rOwned[_msgSender()] = _rTotal;
928 
929         // exclude from paying fees or having max transaction amount, max wallet amount
930         excludeFromFees(owner(), true);
931         excludeFromFees(address(this), true);
932         excludeFromFees(address(0xdead), true);
933         
934         excludeFromMaxTransaction(owner(), true);
935         excludeFromMaxTransaction(address(this), true);
936         excludeFromMaxTransaction(address(0xdead), true);
937 
938         excludeFromMaxWallet(owner(), true);
939         excludeFromMaxWallet(address(this), true);
940         excludeFromMaxWallet(address(0xdead), true);
941 
942         _approve(owner(), address(uniswapV2Router), _tTotal);
943         _mint(msg.sender, _tTotal);
944     }
945 
946     receive() external payable {}
947 
948     function enableTrading() external onlyOwner {
949         tradingActive = true;
950         launchedAt = block.number;
951         maxTransactionAmount = _tTotal * 1 / 100;
952         maxWallet = _tTotal * 1 / 100;
953     }
954     
955     function removeLimits() external onlyManager returns (bool) {
956         limitsInEffect = false;
957         return true;
958     }
959     
960     function disableTransferDelay() external onlyManager returns (bool) {
961         transferDelayEnabled = false;
962         return true;
963     }
964     
965     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
966         require(newNum <= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.5%");
967         maxTransactionAmount = newNum * (10**18);
968     }
969 
970     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
971         require(newNum <= (totalSupply() * 2 / 100) / 1e18, "Cannot set maxWallet lower than 2%");
972         maxWallet = newNum * (10**18);
973     }
974     
975     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
976         _isExcludedMaxTransactionAmount[updAds] = isEx;
977         emit ExcludeFromMaxTransaction(updAds, isEx);
978     }
979 
980     function excludeFromMaxWallet(address updAds, bool isEx) public onlyOwner {
981         _isExcludedMaxWalletAmount[updAds] = isEx;
982         emit ExcludeFromMaxWallet(updAds, isEx);
983     }
984     
985     function updateFees(uint256 _juicePoolFee, uint256 _reflectionFee) external onlyOwner {
986         ReflectionFee = _reflectionFee;
987         JuicePoolFee = _juicePoolFee;
988         require(JuicePoolFee + ReflectionFee <= 16, "Must keep fees at 16% or less");
989     }
990     
991     function updatePenaltyFees(uint256 _juicePoolFee, uint256 _reflectionFee) external onlyManager {
992         earlySellReflectionFee = _reflectionFee;
993         earlySellPoolFee = _juicePoolFee;
994         require(JuicePoolFee + ReflectionFee <= 25, "Must keep fees at 16% or less");
995     }
996 
997     function updatePenaltyFeeTimer(uint256 _penaltyFeeTime) external onlyManager {
998         penaltyFeeTime = _penaltyFeeTime;
999     }
1000 
1001     function excludeFromFees(address account, bool excluded) public onlyOwner {
1002         _isExcludedFromFees[account] = excluded;
1003         emit ExcludeFromFees(account, excluded);
1004     }
1005 
1006     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1007         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1008 
1009         _setAutomatedMarketMakerPair(pair, value);
1010     }
1011     
1012     function updateMaxReward(uint256 _max) external onlyManager {
1013         max = _max;
1014     }
1015 
1016     function enablePoolRewards(uint256 _startingMaxReward) external onlyManager{
1017             poolEnabled = true;
1018             max = _startingMaxReward;
1019     }
1020 
1021     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1022         automatedMarketMakerPairs[pair] = value;
1023 
1024         emit SetAutomatedMarketMakerPair(pair, value);
1025     }
1026 
1027     function isExcludedFromFees(address account) external view returns(bool) {
1028         return _isExcludedFromFees[account];
1029     }
1030 
1031     function Burn(uint256 _amount) external onlyManager{
1032         _burn(msg.sender, _amount);
1033     }
1034 
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 amount
1039     ) internal override {
1040         require(from != address(0), "ERC20: transfer from the zero address");
1041         require(to != address(0), "ERC20: transfer to the zero address");
1042         require(amount > 0, "Transfer amount must be greater than zero");
1043         
1044         if (limitsInEffect) {
1045             if (
1046                 from != owner() &&
1047                 to != owner() &&
1048                 to != address(0) &&
1049                 to != address(0xdead) &&
1050                 !swapping
1051             ) {
1052                 if (!tradingActive) {
1053                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1054                 }
1055 
1056                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1057                 if (transferDelayEnabled) {
1058                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1059                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1060                         _holderLastTransferTimestamp[tx.origin] = block.number;
1061                     }
1062                 }
1063 
1064                 // when buy
1065                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1066                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1067                 }
1068 
1069                 if (!_isExcludedMaxTransactionAmount[from]) {
1070                     require(amount <= maxTransactionAmount, "transfer amount exceeds the maxTransactionAmount.");
1071                 }
1072 
1073                 if (!_isExcludedMaxWalletAmount[to]) {
1074                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1075                 }
1076             }
1077         }
1078 
1079         bool takeFee = !swapping;
1080 
1081         // if any account belongs to _isExcludedFromFee account then remove the fee
1082         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1083             takeFee = false;
1084         }
1085 
1086         uint256 fees = 0;
1087         uint256 reflectionFee = 0;
1088         uint256 P = balanceOf(address(this));
1089 
1090         // only take fees on buys/sells, do not take on wallet transfers after penalty time
1091         if (takeFee) {
1092             // on buy
1093             if (automatedMarketMakerPairs[from] && to != address(uniswapV2Router)) {
1094                 fees = amount.mul(JuicePoolFee).div(100);
1095                 reflectionFee = ReflectionFee;
1096                 _holderLastBuyTimestamp[to] = block.timestamp;
1097             }
1098             // on sell
1099             else if (automatedMarketMakerPairs[to] && from != address(uniswapV2Router)) {
1100                 if (_holderLastBuyTimestamp[from] != 0 && (_holderLastBuyTimestamp[from] + penaltyFeeTime >= block.timestamp)) {
1101                     fees = amount.mul(earlySellPoolFee).div(100);
1102                     reflectionFee = earlySellReflectionFee;
1103                 }
1104                 else{
1105                     fees = amount.mul(JuicePoolFee).div(100);
1106                     reflectionFee = ReflectionFee;
1107                 }
1108             }
1109             
1110             // on transfer
1111             else if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
1112                 if (_holderLastBuyTimestamp[from] != 0 && (_holderLastBuyTimestamp[from] + penaltyFeeTime >= block.timestamp)) {
1113                     fees = amount.mul(earlySellPoolFee).div(100);
1114                     reflectionFee = earlySellReflectionFee;
1115                 }
1116             }
1117 
1118             if (fees > 0) {
1119                 _tokenTransfer(from, address(this), fees, 0);
1120         	    amount -= fees;
1121             }
1122         }
1123 
1124         uint256 A = amount;
1125         _tokenTransfer(from, to, amount, reflectionFee);
1126 
1127     uint256 R = 0;
1128     if(poolEnabled){
1129         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]){
1130             if(A > P){R = P;
1131                 if(P > max){R=max;}
1132             }
1133             if(A <= P){R = A;
1134                 if(A > max){R = max;}
1135             }
1136             if(R + balanceOf(to) >= maxWallet){
1137                 R = (maxWallet - (balanceOf(to)));}
1138 
1139             _tokenTransfer(address(this), to, R, 0);
1140         } 
1141     }  
1142     }
1143 
1144     // Reflection
1145     function totalSupply() public pure override returns (uint256) {
1146         return _tTotal;
1147     }
1148 
1149     function balanceOf(address account) public view override returns (uint256) {
1150         return tokenFromReflection(_rOwned[account]);
1151     }
1152 
1153     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1154         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1155         uint256 currentRate =  _getRate();
1156         return rAmount.div(currentRate);
1157     }
1158 
1159     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 reflectionFee) private {      
1160         _transferStandard(sender, recipient, amount, reflectionFee);
1161     }
1162 
1163     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 reflectionFee) private {
1164         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, reflectionFee);
1165         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }
1170 
1171     function _reflectFee(uint256 rFee, uint256 tFee) private {
1172         _rTotal = _rTotal.sub(rFee);
1173         _tFeeTotal = _tFeeTotal.add(tFee);
1174     }
1175 
1176     function _getValues(uint256 tAmount, uint256 reflectionFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
1177         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, reflectionFee);
1178         uint256 currentRate =  _getRate();
1179         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1180         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1181     }
1182 
1183     function _getTValues(uint256 tAmount, uint256 reflectionFee) private pure returns (uint256, uint256) {
1184         uint256 tFee = tAmount.mul(reflectionFee).div(100);
1185         uint256 tTransferAmount = tAmount.sub(tFee);
1186         return (tTransferAmount, tFee);
1187     }
1188 
1189     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1190         uint256 rAmount = tAmount.mul(currentRate);
1191         uint256 rFee = tFee.mul(currentRate);
1192         uint256 rTransferAmount = rAmount.sub(rFee);
1193         return (rAmount, rTransferAmount, rFee);
1194     }
1195 
1196     function _getRate() private view returns(uint256) {
1197         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1198         return rSupply.div(tSupply);
1199     }
1200 
1201     function _getCurrentSupply() private view returns(uint256, uint256) {
1202         uint256 rSupply = _rTotal;
1203         uint256 tSupply = _tTotal;
1204 
1205         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1206         return (rSupply, tSupply);
1207     }
1208 
1209 }