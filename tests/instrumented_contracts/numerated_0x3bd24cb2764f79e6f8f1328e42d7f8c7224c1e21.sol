1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-19
3 */
4 
5 /*
6 
7     USTAMA
8 
9     The american Tama. Fighting for freedome while making crypto safer.
10     
11     Telegram: https://t.me/ustamatoken
12     Website: https://ustamatoken.com
13 
14     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
15     | * * * * * * * * *  :::::::::::::::::::::::::|
16     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
17     | * * * * * * * * *  :::::::::::::::::::::::::|
18     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
19     | * * * * * * * * *  ::::::::::::::::::::;::::|
20     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
21     |:::::::::::::::::::::::::::::::::::::::::::::|
22     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
23     |:::::::::::::::::::::::::::::::::::::::::::::|
24     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
25     |:::::::::::::::::::::::::::::::::::::::::::::|
26     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
27  
28 */
29 
30 
31 // SPDX-License-Identifier: MIT                                                                               
32                                                     
33 pragma solidity 0.8.8;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 interface IUniswapV2Pair {
47     event Approval(address indexed owner, address indexed spender, uint value);
48     event Transfer(address indexed from, address indexed to, uint value);
49 
50     function name() external pure returns (string memory);
51     function symbol() external pure returns (string memory);
52     function decimals() external pure returns (uint8);
53     function totalSupply() external view returns (uint);
54     function balanceOf(address owner) external view returns (uint);
55     function allowance(address owner, address spender) external view returns (uint);
56 
57     function approve(address spender, uint value) external returns (bool);
58     function transfer(address to, uint value) external returns (bool);
59     function transferFrom(address from, address to, uint value) external returns (bool);
60 
61     function DOMAIN_SEPARATOR() external view returns (bytes32);
62     function PERMIT_TYPEHASH() external pure returns (bytes32);
63     function nonces(address owner) external view returns (uint);
64 
65     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
66 
67     event Mint(address indexed sender, uint amount0, uint amount1);
68     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
69     event Swap(
70         address indexed sender,
71         uint amount0In,
72         uint amount1In,
73         uint amount0Out,
74         uint amount1Out,
75         address indexed to
76     );
77     event Sync(uint112 reserve0, uint112 reserve1);
78 
79     function MINIMUM_LIQUIDITY() external pure returns (uint);
80     function factory() external view returns (address);
81     function token0() external view returns (address);
82     function token1() external view returns (address);
83     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
84     function price0CumulativeLast() external view returns (uint);
85     function price1CumulativeLast() external view returns (uint);
86     function kLast() external view returns (uint);
87 
88     function mint(address to) external returns (uint liquidity);
89     function burn(address to) external returns (uint amount0, uint amount1);
90     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
91     function skim(address to) external;
92     function sync() external;
93 
94     function initialize(address, address) external;
95 }
96 
97 interface IUniswapV2Factory {
98     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
99 
100     function feeTo() external view returns (address);
101     function feeToSetter() external view returns (address);
102 
103     function getPair(address tokenA, address tokenB) external view returns (address pair);
104     function allPairs(uint) external view returns (address pair);
105     function allPairsLength() external view returns (uint);
106 
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 
109     function setFeeTo(address) external;
110     function setFeeToSetter(address) external;
111 }
112 
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 
206 contract ERC20 is Context, IERC20, IERC20Metadata {
207     using SafeMath for uint256;
208 
209     mapping(address => uint256) private _balances;
210 
211     mapping(address => mapping(address => uint256)) private _allowances;
212 
213     uint256 private _totalSupply;
214 
215     string private _name;
216     string private _symbol;
217 
218     /**
219      * @dev Sets the values for {name} and {symbol}.
220      *
221      * The default value of {decimals} is 18. To select a different value for
222      * {decimals} you should overload it.
223      *
224      * All two of these values are immutable: they can only be set once during
225      * construction.
226      */
227     constructor(string memory name_, string memory symbol_) {
228         _name = name_;
229         _symbol = symbol_;
230     }
231 
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() public view virtual override returns (string memory) {
236         return _name;
237     }
238 
239     /**
240      * @dev Returns the symbol of the token, usually a shorter version of the
241      * name.
242      */
243     function symbol() public view virtual override returns (string memory) {
244         return _symbol;
245     }
246 
247     /**
248      * @dev Returns the number of decimals used to get its user representation.
249      * For example, if `decimals` equals `2`, a balance of `505` tokens should
250      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
251      *
252      * Tokens usually opt for a value of 18, imitating the relationship between
253      * Ether and Wei. This is the value {ERC20} uses, unless this function is
254      * overridden;
255      *
256      * NOTE: This information is only used for _display_ purposes: it in
257      * no way affects any of the arithmetic of the contract, including
258      * {IERC20-balanceOf} and {IERC20-transfer}.
259      */
260     function decimals() public view virtual override returns (uint8) {
261         return 18;
262     }
263 
264     /**
265      * @dev See {IERC20-totalSupply}.
266      */
267     function totalSupply() public view virtual override returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272      * @dev See {IERC20-balanceOf}.
273      */
274     function balanceOf(address account) public view virtual override returns (uint256) {
275         return _balances[account];
276     }
277 
278     /**
279      * @dev See {IERC20-transfer}.
280      *
281      * Requirements:
282      *
283      * - `recipient` cannot be the zero address.
284      * - the caller must have a balance of at least `amount`.
285      */
286     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
287         _transfer(_msgSender(), recipient, amount);
288         return true;
289     }
290 
291     /**
292      * @dev See {IERC20-allowance}.
293      */
294     function allowance(address owner, address spender) public view virtual override returns (uint256) {
295         return _allowances[owner][spender];
296     }
297 
298     /**
299      * @dev See {IERC20-approve}.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function approve(address spender, uint256 amount) public virtual override returns (bool) {
306         _approve(_msgSender(), spender, amount);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-transferFrom}.
312      *
313      * Emits an {Approval} event indicating the updated allowance. This is not
314      * required by the EIP. See the note at the beginning of {ERC20}.
315      *
316      * Requirements:
317      *
318      * - `sender` and `recipient` cannot be the zero address.
319      * - `sender` must have a balance of at least `amount`.
320      * - the caller must have allowance for ``sender``'s tokens of at least
321      * `amount`.
322      */
323     function transferFrom(
324         address sender,
325         address recipient,
326         uint256 amount
327     ) public virtual override returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
365         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
366         return true;
367     }
368 
369     /**
370      * @dev Moves tokens `amount` from `sender` to `recipient`.
371      *
372      * This is internal function is equivalent to {transfer}, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a {Transfer} event.
376      *
377      * Requirements:
378      *
379      * - `sender` cannot be the zero address.
380      * - `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      */
383     function _transfer(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) internal virtual {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390 
391         _beforeTokenTransfer(sender, recipient, amount);
392 
393         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
394         _balances[recipient] = _balances[recipient].add(amount);
395         emit Transfer(sender, recipient, amount);
396     }
397 
398     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
399      * the total supply.
400      *
401      * Emits a {Transfer} event with `from` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      */
407     function _mint(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: mint to the zero address");
409 
410         _beforeTokenTransfer(address(0), account, amount);
411 
412         _totalSupply = _totalSupply.add(amount);
413         _balances[account] = _balances[account].add(amount);
414         emit Transfer(address(0), account, amount);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
434         _totalSupply = _totalSupply.sub(amount);
435         emit Transfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Hook that is called before any transfer of tokens. This includes
465      * minting and burning.
466      *
467      * Calling conditions:
468      *
469      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
470      * will be to transferred to `to`.
471      * - when `from` is zero, `amount` tokens will be minted for `to`.
472      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
473      * - `from` and `to` are never both zero.
474      *
475      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
476      */
477     function _beforeTokenTransfer(
478         address from,
479         address to,
480         uint256 amount
481     ) internal virtual {}
482 }
483 
484 library SafeMath {
485     /**
486      * @dev Returns the addition of two unsigned integers, reverting on
487      * overflow.
488      *
489      * Counterpart to Solidity's `+` operator.
490      *
491      * Requirements:
492      *
493      * - Addition cannot overflow.
494      */
495     function add(uint256 a, uint256 b) internal pure returns (uint256) {
496         uint256 c = a + b;
497         require(c >= a, "SafeMath: addition overflow");
498 
499         return c;
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
513         return sub(a, b, "SafeMath: subtraction overflow");
514     }
515 
516     /**
517      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
518      * overflow (when the result is negative).
519      *
520      * Counterpart to Solidity's `-` operator.
521      *
522      * Requirements:
523      *
524      * - Subtraction cannot overflow.
525      */
526     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b <= a, errorMessage);
528         uint256 c = a - b;
529 
530         return c;
531     }
532 
533     /**
534      * @dev Returns the multiplication of two unsigned integers, reverting on
535      * overflow.
536      *
537      * Counterpart to Solidity's `*` operator.
538      *
539      * Requirements:
540      *
541      * - Multiplication cannot overflow.
542      */
543     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
544         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
545         // benefit is lost if 'b' is also tested.
546         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
547         if (a == 0) {
548             return 0;
549         }
550 
551         uint256 c = a * b;
552         require(c / a == b, "SafeMath: multiplication overflow");
553 
554         return c;
555     }
556 
557     /**
558      * @dev Returns the integer division of two unsigned integers. Reverts on
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
569     function div(uint256 a, uint256 b) internal pure returns (uint256) {
570         return div(a, b, "SafeMath: division by zero");
571     }
572 
573     /**
574      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
575      * division by zero. The result is rounded towards zero.
576      *
577      * Counterpart to Solidity's `/` operator. Note: this function uses a
578      * `revert` opcode (which leaves remaining gas untouched) while Solidity
579      * uses an invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
586         require(b > 0, errorMessage);
587         uint256 c = a / b;
588         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
589 
590         return c;
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * Reverts when dividing by zero.
596      *
597      * Counterpart to Solidity's `%` operator. This function uses a `revert`
598      * opcode (which leaves remaining gas untouched) while Solidity uses an
599      * invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
606         return mod(a, b, "SafeMath: modulo by zero");
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
611      * Reverts with custom message when dividing by zero.
612      *
613      * Counterpart to Solidity's `%` operator. This function uses a `revert`
614      * opcode (which leaves remaining gas untouched) while Solidity uses an
615      * invalid opcode to revert (consuming all remaining gas).
616      *
617      * Requirements:
618      *
619      * - The divisor cannot be zero.
620      */
621     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
622         require(b != 0, errorMessage);
623         return a % b;
624     }
625 }
626 
627 contract Ownable is Context {
628     address private _owner;
629 
630     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
631     
632     /**
633      * @dev Initializes the contract setting the deployer as the initial owner.
634      */
635     constructor () {
636         address msgSender = _msgSender();
637         _owner = msgSender;
638         emit OwnershipTransferred(address(0), msgSender);
639     }
640 
641     /**
642      * @dev Returns the address of the current owner.
643      */
644     function owner() public view returns (address) {
645         return _owner;
646     }
647 
648     /**
649      * @dev Throws if called by any account other than the owner.
650      */
651     modifier onlyOwner() {
652         require(_owner == _msgSender(), "Ownable: caller is not the owner");
653         _;
654     }
655 
656     /**
657      * @dev Leaves the contract without owner. It will not be possible to call
658      * `onlyOwner` functions anymore. Can only be called by the current owner.
659      *
660      * NOTE: Renouncing ownership will leave the contract without an owner,
661      * thereby removing any functionality that is only available to the owner.
662      */
663     function renounceOwnership() public virtual onlyOwner {
664         emit OwnershipTransferred(_owner, address(0));
665         _owner = address(0);
666     }
667 
668     /**
669      * @dev Transfers ownership of the contract to a new account (`newOwner`).
670      * Can only be called by the current owner.
671      */
672     function transferOwnership(address newOwner) public virtual onlyOwner {
673         require(newOwner != address(0), "Ownable: new owner is the zero address");
674         emit OwnershipTransferred(_owner, newOwner);
675         _owner = newOwner;
676     }
677 }
678 
679 
680 
681 library SafeMathInt {
682     int256 private constant MIN_INT256 = int256(1) << 255;
683     int256 private constant MAX_INT256 = ~(int256(1) << 255);
684 
685     /**
686      * @dev Multiplies two int256 variables and fails on overflow.
687      */
688     function mul(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a * b;
690 
691         // Detect overflow when multiplying MIN_INT256 with -1
692         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
693         require((b == 0) || (c / b == a));
694         return c;
695     }
696 
697     /**
698      * @dev Division of two int256 variables and fails on overflow.
699      */
700     function div(int256 a, int256 b) internal pure returns (int256) {
701         // Prevent overflow when dividing MIN_INT256 by -1
702         require(b != -1 || a != MIN_INT256);
703 
704         // Solidity already throws when dividing by 0.
705         return a / b;
706     }
707 
708     /**
709      * @dev Subtracts two int256 variables and fails on overflow.
710      */
711     function sub(int256 a, int256 b) internal pure returns (int256) {
712         int256 c = a - b;
713         require((b >= 0 && c <= a) || (b < 0 && c > a));
714         return c;
715     }
716 
717     /**
718      * @dev Adds two int256 variables and fails on overflow.
719      */
720     function add(int256 a, int256 b) internal pure returns (int256) {
721         int256 c = a + b;
722         require((b >= 0 && c >= a) || (b < 0 && c < a));
723         return c;
724     }
725 
726     /**
727      * @dev Converts to absolute value, and fails on overflow.
728      */
729     function abs(int256 a) internal pure returns (int256) {
730         require(a != MIN_INT256);
731         return a < 0 ? -a : a;
732     }
733 
734 
735     function toUint256Safe(int256 a) internal pure returns (uint256) {
736         require(a >= 0);
737         return uint256(a);
738     }
739 }
740 
741 library SafeMathUint {
742   function toInt256Safe(uint256 a) internal pure returns (int256) {
743     int256 b = int256(a);
744     require(b >= 0);
745     return b;
746   }
747 }
748 
749 
750 interface IUniswapV2Router01 {
751     function factory() external pure returns (address);
752     function WETH() external pure returns (address);
753 
754     function addLiquidity(
755         address tokenA,
756         address tokenB,
757         uint amountADesired,
758         uint amountBDesired,
759         uint amountAMin,
760         uint amountBMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountA, uint amountB, uint liquidity);
764     function addLiquidityETH(
765         address token,
766         uint amountTokenDesired,
767         uint amountTokenMin,
768         uint amountETHMin,
769         address to,
770         uint deadline
771     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
772     function removeLiquidity(
773         address tokenA,
774         address tokenB,
775         uint liquidity,
776         uint amountAMin,
777         uint amountBMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountA, uint amountB);
781     function removeLiquidityETH(
782         address token,
783         uint liquidity,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline
788     ) external returns (uint amountToken, uint amountETH);
789     function removeLiquidityWithPermit(
790         address tokenA,
791         address tokenB,
792         uint liquidity,
793         uint amountAMin,
794         uint amountBMin,
795         address to,
796         uint deadline,
797         bool approveMax, uint8 v, bytes32 r, bytes32 s
798     ) external returns (uint amountA, uint amountB);
799     function removeLiquidityETHWithPermit(
800         address token,
801         uint liquidity,
802         uint amountTokenMin,
803         uint amountETHMin,
804         address to,
805         uint deadline,
806         bool approveMax, uint8 v, bytes32 r, bytes32 s
807     ) external returns (uint amountToken, uint amountETH);
808     function swapExactTokensForTokens(
809         uint amountIn,
810         uint amountOutMin,
811         address[] calldata path,
812         address to,
813         uint deadline
814     ) external returns (uint[] memory amounts);
815     function swapTokensForExactTokens(
816         uint amountOut,
817         uint amountInMax,
818         address[] calldata path,
819         address to,
820         uint deadline
821     ) external returns (uint[] memory amounts);
822     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
823         external
824         payable
825         returns (uint[] memory amounts);
826     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
827         external
828         returns (uint[] memory amounts);
829     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
830         external
831         returns (uint[] memory amounts);
832     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
833         external
834         payable
835         returns (uint[] memory amounts);
836 
837     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
838     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
839     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
840     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
841     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
842 }
843 
844 interface IUniswapV2Router02 is IUniswapV2Router01 {
845     function removeLiquidityETHSupportingFeeOnTransferTokens(
846         address token,
847         uint liquidity,
848         uint amountTokenMin,
849         uint amountETHMin,
850         address to,
851         uint deadline
852     ) external returns (uint amountETH);
853     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
854         address token,
855         uint liquidity,
856         uint amountTokenMin,
857         uint amountETHMin,
858         address to,
859         uint deadline,
860         bool approveMax, uint8 v, bytes32 r, bytes32 s
861     ) external returns (uint amountETH);
862 
863     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
864         uint amountIn,
865         uint amountOutMin,
866         address[] calldata path,
867         address to,
868         uint deadline
869     ) external;
870     function swapExactETHForTokensSupportingFeeOnTransferTokens(
871         uint amountOutMin,
872         address[] calldata path,
873         address to,
874         uint deadline
875     ) external payable;
876     function swapExactTokensForETHSupportingFeeOnTransferTokens(
877         uint amountIn,
878         uint amountOutMin,
879         address[] calldata path,
880         address to,
881         uint deadline
882     ) external;
883 }
884 
885 contract USTAMA is ERC20, Ownable {
886     using SafeMath for uint256;
887 
888     IUniswapV2Router02 public immutable uniswapV2Router;
889     address public immutable uniswapV2Pair;
890     address public constant deadAddress = address(0xdead);
891 
892     bool private swapping;
893 
894     address public marketingWallet;
895     address public devWallet;
896     
897     uint256 public maxTransactionAmount;
898     uint256 public swapTokensAtAmount;
899     uint256 public maxWallet;
900     
901     uint256 public percentForLPBurn = 25; // 25 = .25%
902     bool public lpBurnEnabled = true;
903     uint256 public lpBurnFrequency = 7200 seconds;
904     uint256 public lastLpBurnTime;
905     
906     uint256 public manualBurnFrequency = 5 minutes;
907     uint256 public lastManualLpBurnTime;
908 
909     bool public limitsInEffect = true;
910     bool public tradingActive = false;
911     bool public swapEnabled = false;
912     
913      // Anti-bot and anti-whale mappings and variables
914     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
915     bool public transferDelayEnabled = true;
916 
917     uint256 public buyTotalFees;
918     uint256 public buyMarketingFee;
919     uint256 public buyLiquidityFee;
920     uint256 public buyDevFee;
921     
922     uint256 public sellTotalFees;
923     uint256 public sellMarketingFee;
924     uint256 public sellLiquidityFee;
925     uint256 public sellDevFee;
926     
927     uint256 public tokensForMarketing;
928     uint256 public tokensForLiquidity;
929     uint256 public tokensForDev;
930     
931     /******************/
932 
933     // exlcude from fees and max transaction amount
934     mapping (address => bool) private _isExcludedFromFees;
935     mapping (address => bool) public _isExcludedMaxTransactionAmount;
936 
937     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
938     // could be subject to a maximum transfer amount
939     mapping (address => bool) public automatedMarketMakerPairs;
940 
941     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
942 
943     event ExcludeFromFees(address indexed account, bool isExcluded);
944 
945     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
946 
947     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
948     
949     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
950 
951     event SwapAndLiquify(
952         uint256 tokensSwapped,
953         uint256 ethReceived,
954         uint256 tokensIntoLiquidity
955     );
956     
957     event AutoNukeLP();
958     
959     event ManualNukeLP();
960 
961     constructor() ERC20("USTama", "USTAMA") {
962         
963         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
964         
965         excludeFromMaxTransaction(address(_uniswapV2Router), true);
966         uniswapV2Router = _uniswapV2Router;
967         
968         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
969         excludeFromMaxTransaction(address(uniswapV2Pair), true);
970         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
971         
972         uint256 _buyMarketingFee = 4;
973         uint256 _buyLiquidityFee = 1;
974         uint256 _buyDevFee = 2;
975 
976         uint256 _sellMarketingFee = 4;
977         uint256 _sellLiquidityFee = 2;
978         uint256 _sellDevFee = 2;
979         
980         uint256 totalSupply = 1 * 1e12 * 1e18;
981         
982         maxTransactionAmount = totalSupply * 60 / 1000;
983         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
984         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
985 
986         buyMarketingFee = _buyMarketingFee;
987         buyLiquidityFee = _buyLiquidityFee;
988         buyDevFee = _buyDevFee;
989         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
990         
991         sellMarketingFee = _sellMarketingFee;
992         sellLiquidityFee = _sellLiquidityFee;
993         sellDevFee = _sellDevFee;
994         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
995         
996         marketingWallet = address(owner()); // set as marketing wallet
997         devWallet = address(owner()); // set as dev wallet
998 
999         // exclude from paying fees or having max transaction amount
1000         excludeFromFees(owner(), true);
1001         excludeFromFees(address(this), true);
1002         excludeFromFees(address(0xdead), true);
1003         
1004         excludeFromMaxTransaction(owner(), true);
1005         excludeFromMaxTransaction(address(this), true);
1006         excludeFromMaxTransaction(address(0xdead), true);
1007         
1008         /*
1009             _mint is an internal function in ERC20.sol that is only called here,
1010             and CANNOT be called ever again
1011         */
1012         _mint(msg.sender, totalSupply);
1013     }
1014 
1015     receive() external payable {
1016 
1017   	}
1018 
1019     // once enabled, can never be turned off
1020     function enableTrading() external onlyOwner {
1021         tradingActive = true;
1022         swapEnabled = true;
1023         lastLpBurnTime = block.timestamp;
1024     }
1025     
1026     // remove limits after token is stable
1027     function removeLimits() external onlyOwner returns (bool){
1028         limitsInEffect = false;
1029         return true;
1030     }
1031     
1032     // disable Transfer delay - cannot be reenabled
1033     function disableTransferDelay() external onlyOwner returns (bool){
1034         transferDelayEnabled = false;
1035         return true;
1036     }
1037     
1038      // change the minimum amount of tokens to sell from fees
1039     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1040   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1041   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1042   	    swapTokensAtAmount = newAmount;
1043   	    return true;
1044   	}
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
1073     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1074         sellMarketingFee = _marketingFee;
1075         sellLiquidityFee = _liquidityFee;
1076         sellDevFee = _devFee;
1077         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1078         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1079     }
1080 
1081     function excludeFromFees(address account, bool excluded) public onlyOwner {
1082         _isExcludedFromFees[account] = excluded;
1083         emit ExcludeFromFees(account, excluded);
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
1113     event BoughtEarly(address indexed sniper);
1114 
1115     function _transfer(
1116         address from,
1117         address to,
1118         uint256 amount
1119     ) internal override {
1120         require(from != address(0), "ERC20: transfer from the zero address");
1121         require(to != address(0), "ERC20: transfer to the zero address");
1122         
1123          if(amount == 0) {
1124             super._transfer(from, to, 0);
1125             return;
1126         }
1127         
1128         if(limitsInEffect){
1129             if (
1130                 from != owner() &&
1131                 to != owner() &&
1132                 to != address(0) &&
1133                 to != address(0xdead) &&
1134                 !swapping
1135             ){
1136                 if(!tradingActive){
1137                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1138                 }
1139 
1140                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1141                 if (transferDelayEnabled){
1142                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1143                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1144                         _holderLastTransferTimestamp[tx.origin] = block.number;
1145                     }
1146                 }
1147                  
1148                 //when buy
1149                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1150                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1151                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1152                 }
1153                 
1154                 //when sell
1155                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1156                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1157                 }
1158                 else if(!_isExcludedMaxTransactionAmount[to]){
1159                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1160                 }
1161             }
1162         }
1163         
1164         
1165         
1166 		uint256 contractTokenBalance = balanceOf(address(this));
1167         
1168         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1169 
1170         if( 
1171             canSwap &&
1172             swapEnabled &&
1173             !swapping &&
1174             !automatedMarketMakerPairs[from] &&
1175             !_isExcludedFromFees[from] &&
1176             !_isExcludedFromFees[to]
1177         ) {
1178             swapping = true;
1179             
1180             swapBack();
1181 
1182             swapping = false;
1183         }
1184         
1185         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1186             autoBurnLiquidityPairTokens();
1187         }
1188 
1189         bool takeFee = !swapping;
1190 
1191         // if any account belongs to _isExcludedFromFee account then remove the fee
1192         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1193             takeFee = false;
1194         }
1195         
1196         uint256 fees = 0;
1197         // only take fees on buys/sells, do not take on wallet transfers
1198         if(takeFee){
1199             // on sell
1200             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1201                 fees = amount.mul(sellTotalFees).div(100);
1202                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1203                 tokensForDev += fees * sellDevFee / sellTotalFees;
1204                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1205             }
1206             // on buy
1207             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1208         	    fees = amount.mul(buyTotalFees).div(100);
1209         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1210                 tokensForDev += fees * buyDevFee / buyTotalFees;
1211                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1212             }
1213             
1214             if(fees > 0){    
1215                 super._transfer(from, address(this), fees);
1216             }
1217         	
1218         	amount -= fees;
1219         }
1220 
1221         super._transfer(from, to, amount);
1222     }
1223 
1224     function swapTokensForEth(uint256 tokenAmount) private {
1225 
1226         // generate the uniswap pair path of token -> weth
1227         address[] memory path = new address[](2);
1228         path[0] = address(this);
1229         path[1] = uniswapV2Router.WETH();
1230 
1231         _approve(address(this), address(uniswapV2Router), tokenAmount);
1232 
1233         // make the swap
1234         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1235             tokenAmount,
1236             0, // accept any amount of ETH
1237             path,
1238             address(this),
1239             block.timestamp
1240         );
1241         
1242     }
1243     
1244     
1245     
1246     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1247         // approve token transfer to cover all possible scenarios
1248         _approve(address(this), address(uniswapV2Router), tokenAmount);
1249 
1250         // add the liquidity
1251         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1252             address(this),
1253             tokenAmount,
1254             0, // slippage is unavoidable
1255             0, // slippage is unavoidable
1256             deadAddress,
1257             block.timestamp
1258         );
1259     }
1260 
1261     function swapBack() private {
1262         uint256 contractBalance = balanceOf(address(this));
1263         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1264         bool success;
1265         
1266         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1267 
1268         if(contractBalance > swapTokensAtAmount * 20){
1269           contractBalance = swapTokensAtAmount * 20;
1270         }
1271         
1272         // Halve the amount of liquidity tokens
1273         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1274         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1275         
1276         uint256 initialETHBalance = address(this).balance;
1277 
1278         swapTokensForEth(amountToSwapForETH); 
1279         
1280         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1281         
1282         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1283         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1284         
1285         
1286         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1287         
1288         
1289         tokensForLiquidity = 0;
1290         tokensForMarketing = 0;
1291         tokensForDev = 0;
1292         
1293         (success,) = address(devWallet).call{value: ethForDev}("");
1294         
1295         if(liquidityTokens > 0 && ethForLiquidity > 0){
1296             addLiquidity(liquidityTokens, ethForLiquidity);
1297             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1298         }
1299         
1300         
1301         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1302     }
1303     
1304     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1305         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1306         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1307         lpBurnFrequency = _frequencyInSeconds;
1308         percentForLPBurn = _percent;
1309         lpBurnEnabled = _Enabled;
1310     }
1311     
1312     function autoBurnLiquidityPairTokens() internal returns (bool){
1313         
1314         lastLpBurnTime = block.timestamp;
1315         
1316         // get balance of liquidity pair
1317         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1318         
1319         // calculate amount to burn
1320         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1321         
1322         // pull tokens from pancakePair liquidity and move to dead address permanently
1323         if (amountToBurn > 0){
1324             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1325         }
1326         
1327         //sync price since this is not in a swap transaction!
1328         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1329         pair.sync();
1330         emit AutoNukeLP();
1331         return true;
1332     }
1333 
1334     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1335         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1336         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1337         lastManualLpBurnTime = block.timestamp;
1338         
1339         // get balance of liquidity pair
1340         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1341         
1342         // calculate amount to burn
1343         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1344         
1345         // pull tokens from pancakePair liquidity and move to dead address permanently
1346         if (amountToBurn > 0){
1347             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1348         }
1349         
1350         //sync price since this is not in a swap transaction!
1351         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1352         pair.sync();
1353         emit ManualNukeLP();
1354         return true;
1355     }
1356 }