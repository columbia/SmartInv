1 /**
2  Project Plutus  $PLU
3  Visit Our Telegram: https://t.me/projectplutus_global
4  Visit Our Website  https://plutus.property/
5    
6 */
7 
8 // SPDX-License-Identifier: MIT                                                                                                                                                             
9                                                     
10 pragma solidity 0.8.9;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26 
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33 
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37 
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41 
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43 
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
603 contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607     
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor () {
612         address msgSender = _msgSender();
613         _owner = msgSender;
614         emit OwnershipTransferred(address(0), msgSender);
615     }
616 
617     /**
618      * @dev Returns the address of the current owner.
619      */
620     function owner() public view returns (address) {
621         return _owner;
622     }
623 
624     /**
625      * @dev Throws if called by any account other than the owner.
626      */
627     modifier onlyOwner() {
628         require(_owner == _msgSender(), "Ownable: caller is not the owner");
629         _;
630     }
631 
632     /**
633      * @dev Leaves the contract without owner. It will not be possible to call
634      * `onlyOwner` functions anymore. Can only be called by the current owner.
635      *
636      * NOTE: Renouncing ownership will leave the contract without an owner,
637      * thereby removing any functionality that is only available to the owner.
638      */
639     function renounceOwnership() public virtual onlyOwner {
640         emit OwnershipTransferred(_owner, address(0));
641         _owner = address(0);
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      * Can only be called by the current owner.
647      */
648     function transferOwnership(address newOwner) public virtual onlyOwner {
649         require(newOwner != address(0), "Ownable: new owner is the zero address");
650         emit OwnershipTransferred(_owner, newOwner);
651         _owner = newOwner;
652     }
653 }
654 
655 library SafeMathInt {
656     int256 private constant MIN_INT256 = int256(1) << 255;
657     int256 private constant MAX_INT256 = ~(int256(1) << 255);
658 
659     /**
660      * @dev Multiplies two int256 variables and fails on overflow.
661      */
662     function mul(int256 a, int256 b) internal pure returns (int256) {
663         int256 c = a * b;
664 
665         // Detect overflow when multiplying MIN_INT256 with -1
666         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
667         require((b == 0) || (c / b == a));
668         return c;
669     }
670 
671     /**
672      * @dev Division of two int256 variables and fails on overflow.
673      */
674     function div(int256 a, int256 b) internal pure returns (int256) {
675         // Prevent overflow when dividing MIN_INT256 by -1
676         require(b != -1 || a != MIN_INT256);
677 
678         // Solidity already throws when dividing by 0.
679         return a / b;
680     }
681 
682     /**
683      * @dev Subtracts two int256 variables and fails on overflow.
684      */
685     function sub(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a - b;
687         require((b >= 0 && c <= a) || (b < 0 && c > a));
688         return c;
689     }
690 
691     /**
692      * @dev Adds two int256 variables and fails on overflow.
693      */
694     function add(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a + b;
696         require((b >= 0 && c >= a) || (b < 0 && c < a));
697         return c;
698     }
699 
700     /**
701      * @dev Converts to absolute value, and fails on overflow.
702      */
703     function abs(int256 a) internal pure returns (int256) {
704         require(a != MIN_INT256);
705         return a < 0 ? -a : a;
706     }
707 
708 
709     function toUint256Safe(int256 a) internal pure returns (uint256) {
710         require(a >= 0);
711         return uint256(a);
712     }
713 }
714 
715 library SafeMathUint {
716   function toInt256Safe(uint256 a) internal pure returns (int256) {
717     int256 b = int256(a);
718     require(b >= 0);
719     return b;
720   }
721 }
722 
723 interface IUniswapV2Router01 {
724     function factory() external pure returns (address);
725     function WETH() external pure returns (address);
726 
727     function addLiquidity(
728         address tokenA,
729         address tokenB,
730         uint amountADesired,
731         uint amountBDesired,
732         uint amountAMin,
733         uint amountBMin,
734         address to,
735         uint deadline
736     ) external returns (uint amountA, uint amountB, uint liquidity);
737     function addLiquidityETH(
738         address token,
739         uint amountTokenDesired,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline
744     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
745     function removeLiquidity(
746         address tokenA,
747         address tokenB,
748         uint liquidity,
749         uint amountAMin,
750         uint amountBMin,
751         address to,
752         uint deadline
753     ) external returns (uint amountA, uint amountB);
754     function removeLiquidityETH(
755         address token,
756         uint liquidity,
757         uint amountTokenMin,
758         uint amountETHMin,
759         address to,
760         uint deadline
761     ) external returns (uint amountToken, uint amountETH);
762     function removeLiquidityWithPermit(
763         address tokenA,
764         address tokenB,
765         uint liquidity,
766         uint amountAMin,
767         uint amountBMin,
768         address to,
769         uint deadline,
770         bool approveMax, uint8 v, bytes32 r, bytes32 s
771     ) external returns (uint amountA, uint amountB);
772     function removeLiquidityETHWithPermit(
773         address token,
774         uint liquidity,
775         uint amountTokenMin,
776         uint amountETHMin,
777         address to,
778         uint deadline,
779         bool approveMax, uint8 v, bytes32 r, bytes32 s
780     ) external returns (uint amountToken, uint amountETH);
781     function swapExactTokensForTokens(
782         uint amountIn,
783         uint amountOutMin,
784         address[] calldata path,
785         address to,
786         uint deadline
787     ) external returns (uint[] memory amounts);
788     function swapTokensForExactTokens(
789         uint amountOut,
790         uint amountInMax,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external returns (uint[] memory amounts);
795     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
796         external
797         payable
798         returns (uint[] memory amounts);
799     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
800         external
801         returns (uint[] memory amounts);
802     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
803         external
804         returns (uint[] memory amounts);
805     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
806         external
807         payable
808         returns (uint[] memory amounts);
809 
810     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
811     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
812     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
813     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
814     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
815 }
816 
817 interface IUniswapV2Router02 is IUniswapV2Router01 {
818     function removeLiquidityETHSupportingFeeOnTransferTokens(
819         address token,
820         uint liquidity,
821         uint amountTokenMin,
822         uint amountETHMin,
823         address to,
824         uint deadline
825     ) external returns (uint amountETH);
826     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
827         address token,
828         uint liquidity,
829         uint amountTokenMin,
830         uint amountETHMin,
831         address to,
832         uint deadline,
833         bool approveMax, uint8 v, bytes32 r, bytes32 s
834     ) external returns (uint amountETH);
835 
836     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
837         uint amountIn,
838         uint amountOutMin,
839         address[] calldata path,
840         address to,
841         uint deadline
842     ) external;
843     function swapExactETHForTokensSupportingFeeOnTransferTokens(
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external payable;
849     function swapExactTokensForETHSupportingFeeOnTransferTokens(
850         uint amountIn,
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external;
856 }
857 
858 contract ProjectPlutus is ERC20, Ownable {
859     using SafeMath for uint256;
860 
861     IUniswapV2Router02 public immutable uniswapV2Router;
862     address public immutable uniswapV2Pair;
863 
864     bool private swapping;
865     bool private um = true;
866 
867     address public marketingWallet;
868     address public devWallet;
869     
870     uint256 public maxTransactionAmount;
871     uint256 public swapTokensAtAmount;
872     uint256 public maxWallet;
873     
874     bool public limitsInEffect = true;
875     bool public tradingActive = false;
876     bool public swapEnabled = false;
877     mapping (address => bool) private bots;
878     
879     // Anti-bot and anti-whale mappings and variables
880     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
881     bool public transferDelayEnabled = true;
882 
883     uint256 public buyTotalFees;
884     uint256 public buyMarketingFee;
885     uint256 public buyLiquidityFee;
886     uint256 public buyDevFee;
887     
888     uint256 public sellTotalFees;
889     uint256 public sellMarketingFee;
890     uint256 public sellLiquidityFee;
891     uint256 public sellDevFee;
892     
893     uint256 public tokensForMarketing;
894     uint256 public tokensForLiquidity;
895     uint256 public tokensForDev;
896     
897     /******************/
898 
899     // exlcude from fees and max transaction amount
900     mapping (address => bool) private _isExcludedFromFees;
901     mapping (address => bool) public _isExcludedMaxTransactionAmount;
902 
903     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
904     // could be subject to a maximum transfer amount
905     mapping (address => bool) public automatedMarketMakerPairs;
906 
907     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
908 
909     event ExcludeFromFees(address indexed account, bool isExcluded);
910 
911     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
912 
913     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
914     
915     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
916 
917     event SwapAndLiquify(
918         uint256 tokensSwapped,
919         uint256 ethReceived,
920         uint256 tokensIntoLiquidity
921     );
922 
923     constructor() ERC20("Project Plutus", "PLU") {
924         
925         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
926         
927         excludeFromMaxTransaction(address(_uniswapV2Router), true);
928         uniswapV2Router = _uniswapV2Router;
929         
930         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
931         excludeFromMaxTransaction(address(uniswapV2Pair), true);
932         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
933         
934         uint256 _buyMarketingFee = 1;
935         uint256 _buyLiquidityFee = 3;
936         uint256 _buyDevFee = 1;
937 
938         uint256 _sellMarketingFee = 9;
939         uint256 _sellLiquidityFee = 2;
940         uint256 _sellDevFee = 9;
941         
942         uint256 totalSupply = 1 * 1e9 * 1e18;
943         
944         maxTransactionAmount = totalSupply * 25 / 10000; // 0.25% maxTransactionAmountTxn
945         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
946         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
947 
948         buyMarketingFee = _buyMarketingFee;
949         buyLiquidityFee = _buyLiquidityFee;
950         buyDevFee = _buyDevFee;
951         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
952         
953         sellMarketingFee = _sellMarketingFee;
954         sellLiquidityFee = _sellLiquidityFee;
955         sellDevFee = _sellDevFee;
956         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
957         
958         marketingWallet = payable(0x13473941dC3f124D7215F1E4a52249e8CDFE3e20); 
959         devWallet = payable(0xb35F9905CA5B059721aab66306306Ff4006d75D1);
960 
961         // exclude from paying fees or having max transaction amount
962         excludeFromFees(owner(), true);
963         excludeFromFees(address(this), true);
964         excludeFromFees(address(devWallet), true);
965         excludeFromFees(address(marketingWallet), true);
966         
967         excludeFromMaxTransaction(owner(), true);
968         excludeFromMaxTransaction(address(this), true);
969         excludeFromMaxTransaction(address(devWallet), true);
970         excludeFromMaxTransaction(address(marketingWallet), true);
971         
972         /*
973             _mint is an internal function in ERC20.sol that is only called here,
974             and CANNOT be called ever again
975         */
976         _mint(msg.sender, totalSupply);
977     }
978 
979     receive() external payable {
980 
981   	}
982 
983     // once enabled, can never be turned off
984     function enableTrading() external onlyOwner {
985         tradingActive = true;
986         swapEnabled = true;
987     }
988     
989     // remove limits after token is stable
990     function removeLimits() external onlyOwner returns (bool){
991         limitsInEffect = false;
992         return true;
993     }
994     
995     // disable Transfer delay - cannot be reenabled
996     function disableTransferDelay() external onlyOwner returns (bool){
997         transferDelayEnabled = false;
998         return true;
999     }
1000     
1001      // change the minimum amount of tokens to sell from fees
1002     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1003   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1004   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1005   	    swapTokensAtAmount = newAmount;
1006   	    return true;
1007   	}
1008     
1009     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1010         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1011         maxTransactionAmount = newNum * (10**18);
1012     }
1013 
1014     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1015         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1016         maxWallet = newNum * (10**18);
1017     }
1018     
1019     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1020         _isExcludedMaxTransactionAmount[updAds] = isEx;
1021     }
1022     
1023     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1024         buyMarketingFee = _marketingFee;
1025         buyLiquidityFee = _liquidityFee;
1026         buyDevFee = _devFee;
1027         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1028         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1029     }
1030     
1031     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1032         sellMarketingFee = _marketingFee;
1033         sellLiquidityFee = _liquidityFee;
1034         sellDevFee = _devFee;
1035         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1036         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1037     }
1038 
1039     function excludeFromFees(address account, bool excluded) public onlyOwner {
1040         _isExcludedFromFees[account] = excluded;
1041         emit ExcludeFromFees(account, excluded);
1042     }
1043 
1044     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1045         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1046 
1047         _setAutomatedMarketMakerPair(pair, value);
1048     }
1049 
1050     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1051         automatedMarketMakerPairs[pair] = value;
1052 
1053         emit SetAutomatedMarketMakerPair(pair, value);
1054     }
1055 
1056     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1057         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1058         marketingWallet = newMarketingWallet;
1059     }
1060     
1061     function updateDevWallet(address newWallet) external onlyOwner {
1062         emit devWalletUpdated(newWallet, devWallet);
1063         devWallet = newWallet;
1064     }
1065     
1066 
1067     function isExcludedFromFees(address account) public view returns(bool) {
1068         return _isExcludedFromFees[account];
1069     }
1070     
1071     function _transfer(
1072         address from,
1073         address to,
1074         uint256 amount
1075     ) internal override {
1076         require(from != address(0), "ERC20: transfer from the zero address");
1077         require(to != address(0), "ERC20: transfer to the zero address");
1078         
1079          if(amount == 0) {
1080             super._transfer(from, to, 0);
1081             return;
1082         }
1083         
1084         if(limitsInEffect){
1085             if (
1086                 from != owner() &&
1087                 to != owner() &&
1088                 to != address(0) &&
1089                 to != address(0xdead) &&
1090                 !swapping
1091             ){
1092                 require(!bots[from] && !bots[to]);
1093                 if(!tradingActive){
1094                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1095                 }
1096 
1097                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1098                 if (transferDelayEnabled){
1099                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1100                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1101                         _holderLastTransferTimestamp[tx.origin] = block.number;
1102                     }
1103                 }
1104                  
1105                 //when buy
1106                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1107                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1108                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1109                 }
1110                 
1111                 //when sell
1112                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1113                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1114                 }
1115                 else if(!_isExcludedMaxTransactionAmount[to]){
1116                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1117                 }
1118             }
1119         }
1120         
1121         
1122         
1123 		uint256 contractTokenBalance = balanceOf(address(this));
1124         
1125         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1126 
1127         if( 
1128             canSwap &&
1129             swapEnabled &&
1130             !swapping &&
1131             !automatedMarketMakerPairs[from] &&
1132             !_isExcludedFromFees[from] &&
1133             !_isExcludedFromFees[to]
1134         ) {
1135             swapping = true;
1136             
1137             swapBack();
1138 
1139             swapping = false;
1140         }
1141 
1142         bool takeFee = !swapping;
1143 
1144         // if any account belongs to _isExcludedFromFee account then remove the fee
1145         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1146             takeFee = false;
1147         }
1148         
1149         uint256 fees = 0;
1150         // only take fees on buys/sells, do not take on wallet transfers
1151         if(takeFee){
1152             // on sell
1153             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1154                 fees = amount.mul(sellTotalFees).div(100);
1155                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1156                 tokensForDev += fees * sellDevFee / sellTotalFees;
1157                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1158             }
1159             // on buy
1160             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1161         	    fees = amount.mul(buyTotalFees).div(100);
1162         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1163                 tokensForDev += fees * buyDevFee / buyTotalFees;
1164                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1165             }
1166             
1167             if(fees > 0){    
1168                 super._transfer(from, address(this), fees);
1169             }
1170         	
1171         	amount -= fees;
1172         }
1173 
1174         super._transfer(from, to, amount);
1175     }
1176 
1177     function swapTokensForEth(uint256 tokenAmount) private {
1178 
1179         // generate the uniswap pair path of token -> weth
1180         address[] memory path = new address[](2);
1181         path[0] = address(this);
1182         path[1] = uniswapV2Router.WETH();
1183 
1184         _approve(address(this), address(uniswapV2Router), tokenAmount);
1185 
1186         // make the swap
1187         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1188             tokenAmount,
1189             0, // accept any amount of ETH
1190             path,
1191             address(this),
1192             block.timestamp
1193         );
1194         
1195     }
1196     
1197     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1198         // approve token transfer to cover all possible scenarios
1199         _approve(address(this), address(uniswapV2Router), tokenAmount);
1200 
1201         // add the liquidity
1202         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1203             address(this),
1204             tokenAmount,
1205             0, // slippage is unavoidable
1206             0, // slippage is unavoidable
1207             owner(),
1208             block.timestamp
1209         );
1210     }
1211 
1212     function swapBack() private {
1213         uint256 contractBalance = balanceOf(address(this));
1214         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1215         bool success;
1216         
1217         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1218 
1219         if(contractBalance > swapTokensAtAmount * 20){
1220           contractBalance = swapTokensAtAmount * 20;
1221         }
1222         
1223         // Halve the amount of liquidity tokens
1224         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1225         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1226         
1227         uint256 initialETHBalance = address(this).balance;
1228 
1229         swapTokensForEth(amountToSwapForETH); 
1230         
1231         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1232         
1233         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1234         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1235         
1236         
1237         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1238         
1239         
1240         tokensForLiquidity = 0;
1241         tokensForMarketing = 0;
1242         tokensForDev = 0;
1243         
1244         (success,) = address(devWallet).call{value: ethForDev}("");
1245         
1246         if(liquidityTokens > 0 && ethForLiquidity > 0){
1247             addLiquidity(liquidityTokens, ethForLiquidity);
1248             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1249         }
1250         
1251         
1252         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1253     }
1254 
1255     function setBots(address[] memory bots_) public onlyOwner {
1256         for (uint i = 0; i < bots_.length; i++) {
1257             bots[bots_[i]] = true;
1258         }
1259     }
1260     
1261     function delBot(address notbot) public onlyOwner {
1262         bots[notbot] = false;
1263     }
1264 
1265 }