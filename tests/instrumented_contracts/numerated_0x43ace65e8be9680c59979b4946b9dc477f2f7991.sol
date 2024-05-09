1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*
4  _______  _        ______   _______  _______ 
5 (  ____ \( (    /|(  __  \ (  ____ \(  ____ )
6 | (    \/|  \  ( || (  \  )| (    \/| (    )|
7 | (__    |   \ | || |   ) || (__    | (____)|
8 |  __)   | (\ \) || |   | ||  __)   |     __)
9 | (      | | \   || |   ) || (      | (\ (   
10 | (____/\| )  \  || (__/  )| (____/\| ) \ \__
11 (_______/|/    )_)(______/ (_______/|/   \__/
12 
13 The Ender Dragon was a legendary beast which inhabited The End, 
14 and was hostile to anyone who came to its dimension…
15 
16 Only the super-deflationary, true-burning Ender Tokens can defeat 
17 the Dragon, and lead the brave fighters to the wealth they seek!
18 
19 https://t.me/enderdragonportal
20 
21 */
22 pragma solidity 0.8.9;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IUniswapV2Pair {
36     event Approval(address indexed owner, address indexed spender, uint value);
37     event Transfer(address indexed from, address indexed to, uint value);
38 
39     function name() external pure returns (string memory);
40     function symbol() external pure returns (string memory);
41     function decimals() external pure returns (uint8);
42     function totalSupply() external view returns (uint);
43     function balanceOf(address owner) external view returns (uint);
44     function allowance(address owner, address spender) external view returns (uint);
45 
46     function approve(address spender, uint value) external returns (bool);
47     function transfer(address to, uint value) external returns (bool);
48     function transferFrom(address from, address to, uint value) external returns (bool);
49 
50     function DOMAIN_SEPARATOR() external view returns (bytes32);
51     function PERMIT_TYPEHASH() external pure returns (bytes32);
52     function nonces(address owner) external view returns (uint);
53 
54     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
55 
56     event Mint(address indexed sender, uint amount0, uint amount1);
57     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
58     event Swap(
59         address indexed sender,
60         uint amount0In,
61         uint amount1In,
62         uint amount0Out,
63         uint amount1Out,
64         address indexed to
65     );
66     event Sync(uint112 reserve0, uint112 reserve1);
67 
68     function MINIMUM_LIQUIDITY() external pure returns (uint);
69     function factory() external view returns (address);
70     function token0() external view returns (address);
71     function token1() external view returns (address);
72     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
73     function price0CumulativeLast() external view returns (uint);
74     function price1CumulativeLast() external view returns (uint);
75     function kLast() external view returns (uint);
76 
77     function mint(address to) external returns (uint liquidity);
78     function burn(address to) external returns (uint amount0, uint amount1);
79     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
80     function skim(address to) external;
81     function sync() external;
82 
83     function initialize(address, address) external;
84 }
85 
86 interface IUniswapV2Factory {
87     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
88 
89     function feeTo() external view returns (address);
90     function feeToSetter() external view returns (address);
91 
92     function getPair(address tokenA, address tokenB) external view returns (address pair);
93     function allPairs(uint) external view returns (address pair);
94     function allPairsLength() external view returns (uint);
95 
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 
98     function setFeeTo(address) external;
99     function setFeeToSetter(address) external;
100 }
101 
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     /**
109      * @dev Returns the amount of tokens owned by `account`.
110      */
111     function balanceOf(address account) external view returns (uint256);
112 
113     /**
114      * @dev Moves `amount` tokens from the caller's account to `recipient`.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transfer(address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender) external view returns (uint256);
130 
131     /**
132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * IMPORTANT: Beware that changing an allowance with this method brings the risk
137      * that someone may use both the old and the new allowance by unfortunate
138      * transaction ordering. One possible solution to mitigate this race
139      * condition is to first reduce the spender's allowance to 0 and set the
140      * desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient` using the
149      * allowance mechanism. `amount` is then deducted from the caller's
150      * allowance.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transferFrom(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) external returns (bool);
161 
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 interface IERC20Metadata is IERC20 {
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the symbol of the token.
185      */
186     function symbol() external view returns (string memory);
187 
188     /**
189      * @dev Returns the decimals places of the token.
190      */
191     function decimals() external view returns (uint8);
192 }
193 
194 
195 contract ERC20 is Context, IERC20, IERC20Metadata {
196     using SafeMath for uint256;
197 
198     mapping(address => uint256) private _balances;
199 
200     mapping(address => mapping(address => uint256)) private _allowances;
201 
202     uint256 private _totalSupply;
203 
204     string private _name;
205     string private _symbol;
206 
207     /**
208      * @dev Sets the values for {name} and {symbol}.
209      *
210      * The default value of {decimals} is 18. To select a different value for
211      * {decimals} you should overload it.
212      *
213      * All two of these values are immutable: they can only be set once during
214      * construction.
215      */
216     constructor(string memory name_, string memory symbol_) {
217         _name = name_;
218         _symbol = symbol_;
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual override returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual override returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overridden;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual override returns (uint8) {
250         return 6;
251     }
252 
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `recipient` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
335         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
336         return true;
337     }
338 
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
355         return true;
356     }
357 
358     /**
359      * @dev Moves tokens `amount` from `sender` to `recipient`.
360      *
361      * This is internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) internal virtual {
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(sender, recipient, amount);
381 
382         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
383         _balances[recipient] = _balances[recipient].add(amount);
384         emit Transfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply = _totalSupply.add(amount);
402         _balances[account] = _balances[account].add(amount);
403         emit Transfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
423         _totalSupply = _totalSupply.sub(amount);
424         emit Transfer(account, address(0), amount);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447 
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     /**
453      * @dev Hook that is called before any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * will be to transferred to `to`.
460      * - when `from` is zero, `amount` tokens will be minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _beforeTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 }
472 
473 library SafeMath {
474     /**
475      * @dev Returns the addition of two unsigned integers, reverting on
476      * overflow.
477      *
478      * Counterpart to Solidity's `+` operator.
479      *
480      * Requirements:
481      *
482      * - Addition cannot overflow.
483      */
484     function add(uint256 a, uint256 b) internal pure returns (uint256) {
485         uint256 c = a + b;
486         require(c >= a, "SafeMath: addition overflow");
487 
488         return c;
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
502         return sub(a, b, "SafeMath: subtraction overflow");
503     }
504 
505     /**
506      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
507      * overflow (when the result is negative).
508      *
509      * Counterpart to Solidity's `-` operator.
510      *
511      * Requirements:
512      *
513      * - Subtraction cannot overflow.
514      */
515     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b <= a, errorMessage);
517         uint256 c = a - b;
518 
519         return c;
520     }
521 
522     /**
523      * @dev Returns the multiplication of two unsigned integers, reverting on
524      * overflow.
525      *
526      * Counterpart to Solidity's `*` operator.
527      *
528      * Requirements:
529      *
530      * - Multiplication cannot overflow.
531      */
532     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
533         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
534         // benefit is lost if 'b' is also tested.
535         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
536         if (a == 0) {
537             return 0;
538         }
539 
540         uint256 c = a * b;
541         require(c / a == b, "SafeMath: multiplication overflow");
542 
543         return c;
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers. Reverts on
548      * division by zero. The result is rounded towards zero.
549      *
550      * Counterpart to Solidity's `/` operator. Note: this function uses a
551      * `revert` opcode (which leaves remaining gas untouched) while Solidity
552      * uses an invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function div(uint256 a, uint256 b) internal pure returns (uint256) {
559         return div(a, b, "SafeMath: division by zero");
560     }
561 
562     /**
563      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
564      * division by zero. The result is rounded towards zero.
565      *
566      * Counterpart to Solidity's `/` operator. Note: this function uses a
567      * `revert` opcode (which leaves remaining gas untouched) while Solidity
568      * uses an invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
575         require(b > 0, errorMessage);
576         uint256 c = a / b;
577         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
578 
579         return c;
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
595         return mod(a, b, "SafeMath: modulo by zero");
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
600      * Reverts with custom message when dividing by zero.
601      *
602      * Counterpart to Solidity's `%` operator. This function uses a `revert`
603      * opcode (which leaves remaining gas untouched) while Solidity uses an
604      * invalid opcode to revert (consuming all remaining gas).
605      *
606      * Requirements:
607      *
608      * - The divisor cannot be zero.
609      */
610     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         require(b != 0, errorMessage);
612         return a % b;
613     }
614 }
615 
616 contract Ownable is Context {
617     address private _owner;
618 
619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
620     
621     /**
622      * @dev Initializes the contract setting the deployer as the initial owner.
623      */
624     constructor () {
625         address msgSender = _msgSender();
626         _owner = msgSender;
627         emit OwnershipTransferred(address(0), msgSender);
628     }
629 
630     /**
631      * @dev Returns the address of the current owner.
632      */
633     function owner() public view returns (address) {
634         return _owner;
635     }
636 
637     /**
638      * @dev Throws if called by any account other than the owner.
639      */
640     modifier onlyOwner() {
641         require(_owner == _msgSender(), "Ownable: caller is not the owner");
642         _;
643     }
644 
645     /**
646      * @dev Leaves the contract without owner. It will not be possible to call
647      * `onlyOwner` functions anymore. Can only be called by the current owner.
648      *
649      * NOTE: Renouncing ownership will leave the contract without an owner,
650      * thereby removing any functionality that is only available to the owner.
651      */
652     function renounceOwnership() public virtual onlyOwner {
653         emit OwnershipTransferred(_owner, address(0));
654         _owner = address(0);
655     }
656 
657     /**
658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
659      * Can only be called by the current owner.
660      */
661     function transferOwnership(address newOwner) public virtual onlyOwner {
662         require(newOwner != address(0), "Ownable: new owner is the zero address");
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667 
668 
669 
670 library SafeMathInt {
671     int256 private constant MIN_INT256 = int256(1) << 255;
672     int256 private constant MAX_INT256 = ~(int256(1) << 255);
673 
674     /**
675      * @dev Multiplies two int256 variables and fails on overflow.
676      */
677     function mul(int256 a, int256 b) internal pure returns (int256) {
678         int256 c = a * b;
679 
680         // Detect overflow when multiplying MIN_INT256 with -1
681         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
682         require((b == 0) || (c / b == a));
683         return c;
684     }
685 
686     /**
687      * @dev Division of two int256 variables and fails on overflow.
688      */
689     function div(int256 a, int256 b) internal pure returns (int256) {
690         // Prevent overflow when dividing MIN_INT256 by -1
691         require(b != -1 || a != MIN_INT256);
692 
693         // Solidity already throws when dividing by 0.
694         return a / b;
695     }
696 
697     /**
698      * @dev Subtracts two int256 variables and fails on overflow.
699      */
700     function sub(int256 a, int256 b) internal pure returns (int256) {
701         int256 c = a - b;
702         require((b >= 0 && c <= a) || (b < 0 && c > a));
703         return c;
704     }
705 
706     /**
707      * @dev Adds two int256 variables and fails on overflow.
708      */
709     function add(int256 a, int256 b) internal pure returns (int256) {
710         int256 c = a + b;
711         require((b >= 0 && c >= a) || (b < 0 && c < a));
712         return c;
713     }
714 
715     /**
716      * @dev Converts to absolute value, and fails on overflow.
717      */
718     function abs(int256 a) internal pure returns (int256) {
719         require(a != MIN_INT256);
720         return a < 0 ? -a : a;
721     }
722 
723 
724     function toUint256Safe(int256 a) internal pure returns (uint256) {
725         require(a >= 0);
726         return uint256(a);
727     }
728 }
729 
730 library SafeMathUint {
731   function toInt256Safe(uint256 a) internal pure returns (int256) {
732     int256 b = int256(a);
733     require(b >= 0);
734     return b;
735   }
736 }
737 
738 
739 interface IUniswapV2Router01 {
740     function factory() external pure returns (address);
741     function WETH() external pure returns (address);
742 
743     function addLiquidity(
744         address tokenA,
745         address tokenB,
746         uint amountADesired,
747         uint amountBDesired,
748         uint amountAMin,
749         uint amountBMin,
750         address to,
751         uint deadline
752     ) external returns (uint amountA, uint amountB, uint liquidity);
753     function addLiquidityETH(
754         address token,
755         uint amountTokenDesired,
756         uint amountTokenMin,
757         uint amountETHMin,
758         address to,
759         uint deadline
760     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
761     function removeLiquidity(
762         address tokenA,
763         address tokenB,
764         uint liquidity,
765         uint amountAMin,
766         uint amountBMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountA, uint amountB);
770     function removeLiquidityETH(
771         address token,
772         uint liquidity,
773         uint amountTokenMin,
774         uint amountETHMin,
775         address to,
776         uint deadline
777     ) external returns (uint amountToken, uint amountETH);
778     function removeLiquidityWithPermit(
779         address tokenA,
780         address tokenB,
781         uint liquidity,
782         uint amountAMin,
783         uint amountBMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountA, uint amountB);
788     function removeLiquidityETHWithPermit(
789         address token,
790         uint liquidity,
791         uint amountTokenMin,
792         uint amountETHMin,
793         address to,
794         uint deadline,
795         bool approveMax, uint8 v, bytes32 r, bytes32 s
796     ) external returns (uint amountToken, uint amountETH);
797     function swapExactTokensForTokens(
798         uint amountIn,
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external returns (uint[] memory amounts);
804     function swapTokensForExactTokens(
805         uint amountOut,
806         uint amountInMax,
807         address[] calldata path,
808         address to,
809         uint deadline
810     ) external returns (uint[] memory amounts);
811     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
812         external
813         payable
814         returns (uint[] memory amounts);
815     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
816         external
817         returns (uint[] memory amounts);
818     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
819         external
820         returns (uint[] memory amounts);
821     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
822         external
823         payable
824         returns (uint[] memory amounts);
825 
826     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
827     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
828     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
829     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
830     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
831 }
832 
833 interface IUniswapV2Router02 is IUniswapV2Router01 {
834     function removeLiquidityETHSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline
841     ) external returns (uint amountETH);
842     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
843         address token,
844         uint liquidity,
845         uint amountTokenMin,
846         uint amountETHMin,
847         address to,
848         uint deadline,
849         bool approveMax, uint8 v, bytes32 r, bytes32 s
850     ) external returns (uint amountETH);
851 
852     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
853         uint amountIn,
854         uint amountOutMin,
855         address[] calldata path,
856         address to,
857         uint deadline
858     ) external;
859     function swapExactETHForTokensSupportingFeeOnTransferTokens(
860         uint amountOutMin,
861         address[] calldata path,
862         address to,
863         uint deadline
864     ) external payable;
865     function swapExactTokensForETHSupportingFeeOnTransferTokens(
866         uint amountIn,
867         uint amountOutMin,
868         address[] calldata path,
869         address to,
870         uint deadline
871     ) external;
872 }
873 
874 pragma solidity 0.8.9;
875 
876 contract ENDER is ERC20, Ownable {
877     using SafeMath for uint256;
878 
879     IUniswapV2Router02 public immutable uniswapV2Router;
880     address public immutable uniswapV2Pair;
881     address public constant deadAddress = address(0xdead);
882 
883     bool private swapping;
884         
885     uint256 public maxTransactionAmount;
886     uint256 public swapTokensAtAmount;
887     uint256 public maxWallet;
888     
889     uint256 public supply;
890 
891     address public devWallet;
892     
893     bool public limitsInEffect = true;
894     bool public tradingActive = true;
895     bool public swapEnabled = true;
896 
897     mapping(address => uint256) private _holderLastTransferTimestamp;
898     mapping(address => bool) public bots;
899 
900     bool public transferDelayEnabled = true;
901 
902     uint256 public buyBurnFee;
903     uint256 public buyDevFee;
904     uint256 public buyTotalFees;
905 
906     uint256 public sellBurnFee;
907     uint256 public sellDevFee;
908     uint256 public sellTotalFees;   
909     
910     uint256 public tokensForBurn;
911     uint256 public tokensForDev;
912 
913     uint256 public walletDigit;
914     uint256 public transDigit;
915     uint256 public delayDigit;
916     
917     /******************/
918 
919     // exlcude from fees and max transaction amount
920     mapping (address => bool) private _isExcludedFromFees;
921     mapping (address => bool) public _isExcludedMaxTransactionAmount;
922 
923     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
924     // could be subject to a maximum transfer amount
925     mapping (address => bool) public automatedMarketMakerPairs;
926 
927     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
928 
929     event ExcludeFromFees(address indexed account, bool isExcluded);
930 
931     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
932 
933     constructor() ERC20("Ender Dragon", "END") {
934         
935         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
936         
937         excludeFromMaxTransaction(address(_uniswapV2Router), true);
938         uniswapV2Router = _uniswapV2Router;
939         
940         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
941         excludeFromMaxTransaction(address(uniswapV2Pair), true);
942         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
943         
944         uint256 _buyBurnFee = 5;
945         uint256 _buyDevFee = 0;
946 
947         uint256 _sellBurnFee = 5;
948         uint256 _sellDevFee = 5;
949         
950         uint256 totalSupply = 1 * 1e6 * 1e6;
951         supply += totalSupply;
952         
953         walletDigit = 1;
954         transDigit = 1;
955         delayDigit = 0;
956 
957         maxTransactionAmount = supply * transDigit / 100;
958         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
959         maxWallet = supply * walletDigit / 100;
960 
961         buyBurnFee = _buyBurnFee;
962         buyDevFee = _buyDevFee;
963         buyTotalFees = buyBurnFee + buyDevFee;
964         
965         sellBurnFee = _sellBurnFee;
966         sellDevFee = _sellDevFee;
967         sellTotalFees = sellBurnFee + sellDevFee;
968         
969         devWallet = 0xb8972dB64B56764366dc198285a82ee068247a04;
970 
971         excludeFromFees(owner(), true);
972         excludeFromFees(address(this), true);
973         excludeFromFees(address(0xdead), true);
974         
975         excludeFromMaxTransaction(owner(), true);
976         excludeFromMaxTransaction(address(this), true);
977         excludeFromMaxTransaction(address(0xdead), true);
978 
979         _approve(owner(), address(uniswapV2Router), totalSupply);
980         _mint(msg.sender, totalSupply);
981 
982     }
983 
984     receive() external payable {
985 
986   	}
987     function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
988 
989 	function unblockBot(address notbot) public onlyOwner {
990 			bots[notbot] = false;
991 	}
992     function enableTrading() external onlyOwner {
993         buyBurnFee = 5;
994         buyDevFee = 0;
995         buyTotalFees = buyBurnFee + buyDevFee;
996 
997         sellBurnFee = 5;
998         sellDevFee = 5;
999         sellTotalFees = sellBurnFee + sellDevFee;
1000 
1001         delayDigit = 0;
1002     }
1003     
1004     function updateTransDigit(uint256 newNum) external onlyOwner {
1005         require(newNum >= 1);
1006         transDigit = newNum;
1007         updateLimits();
1008     }
1009 
1010     function updateWalletDigit(uint256 newNum) external onlyOwner {
1011         require(newNum >= 1);
1012         walletDigit = newNum;
1013         updateLimits();
1014     }
1015 
1016     function updateDelayDigit(uint256 newNum) external onlyOwner{
1017         delayDigit = newNum;
1018     }
1019     
1020     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1021         _isExcludedMaxTransactionAmount[updAds] = isEx;
1022     }
1023     
1024     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1025         buyBurnFee = _burnFee;
1026         buyDevFee = _devFee;
1027         buyTotalFees = buyBurnFee + buyDevFee;
1028         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
1029     }
1030     
1031     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1032         sellBurnFee = _burnFee;
1033         sellDevFee = _devFee;
1034         sellTotalFees = sellBurnFee + sellDevFee;
1035         require(sellTotalFees <= 15, "Must keep fees at 25% or less");
1036     }
1037 
1038     function updateDevWallet(address newWallet) external onlyOwner {
1039         devWallet = newWallet;
1040     }
1041 
1042     function excludeFromFees(address account, bool excluded) public onlyOwner {
1043         _isExcludedFromFees[account] = excluded;
1044         emit ExcludeFromFees(account, excluded);
1045     }
1046 
1047     function updateLimits() private {
1048         maxTransactionAmount = supply * transDigit / 100;
1049         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1050         maxWallet = supply * walletDigit / 100;
1051     }
1052 
1053     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1054         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1055 
1056         _setAutomatedMarketMakerPair(pair, value);
1057     }
1058 
1059     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1060         automatedMarketMakerPairs[pair] = value;
1061 
1062         emit SetAutomatedMarketMakerPair(pair, value);
1063     }
1064 
1065     function isExcludedFromFees(address account) public view returns(bool) {
1066         return _isExcludedFromFees[account];
1067     }
1068     
1069     function _transfer(
1070         address from,
1071         address to,
1072         uint256 amount
1073     ) internal override {
1074         require(from != address(0), "ERC20: transfer from the zero address");
1075         require(to != address(0), "ERC20: transfer to the zero address");
1076         require(!bots[from] && !bots[to], "This account is blacklisted");
1077         
1078          if(amount == 0) {
1079             super._transfer(from, to, 0);
1080             return;
1081         }
1082         
1083         if(limitsInEffect){
1084             if (
1085                 from != owner() &&
1086                 to != owner() &&
1087                 to != address(0) &&
1088                 to != address(0xdead) &&
1089                 !swapping
1090             ){
1091                 if(!tradingActive){
1092                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1093                 }
1094 
1095                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1096                 if (transferDelayEnabled){
1097                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1098                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1099                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1100                     }
1101                 }
1102                  
1103                 //when buy
1104                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1105                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1106                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1107                 }
1108                 
1109                 //when sell
1110                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1111                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1112                 }
1113                 else if(!_isExcludedMaxTransactionAmount[to]){
1114                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1115                 }
1116             }
1117         }
1118         uint256 contractTokenBalance = balanceOf(address(this));
1119         
1120         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1121 
1122         if( 
1123             canSwap &&
1124             !swapping &&
1125             swapEnabled &&
1126             !automatedMarketMakerPairs[from] &&
1127             !_isExcludedFromFees[from] &&
1128             !_isExcludedFromFees[to]
1129         ) {
1130             swapping = true;
1131             
1132             swapBack();
1133 
1134             swapping = false;
1135         }
1136         
1137         bool takeFee = !swapping;
1138 
1139         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1140             takeFee = false;
1141         }
1142         
1143         uint256 fees = 0;
1144 
1145         if(takeFee){
1146             // on sell
1147             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1148                 fees = amount.mul(sellTotalFees).div(100);
1149                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1150                 tokensForDev += fees * sellDevFee / sellTotalFees;
1151             }
1152 
1153             // on buy
1154             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1155 
1156         	    fees = amount.mul(buyTotalFees).div(100);
1157         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1158                 tokensForDev += fees * buyDevFee / buyTotalFees;
1159             }
1160             
1161             if(fees > 0){    
1162                 super._transfer(from, address(this), fees);
1163                 if (tokensForBurn > 0) {
1164                     _burn(address(this), tokensForBurn);
1165                     supply = totalSupply();
1166                     updateLimits();
1167                     tokensForBurn = 0;
1168                 }
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
1197     function swapBack() private {
1198         uint256 contractBalance = balanceOf(address(this));
1199         bool success;
1200         
1201         if(contractBalance == 0) {return;}
1202 
1203         if(contractBalance > swapTokensAtAmount * 20){
1204           contractBalance = swapTokensAtAmount * 20;
1205         }
1206 
1207         swapTokensForEth(contractBalance); 
1208         
1209         tokensForDev = 0;
1210 
1211         (success,) = address(devWallet).call{value: address(this).balance}("");
1212     }
1213 
1214 }