1 /*
2 THEPEPE.AI - $PPAI
3 
4 PepeAI is an artificial intelligence-assisted social media marketing tool, supported by the $PPAI token.
5 
6 TOKENOMICS:
7 - Total Supply: 10 000 000 PPAI
8 - Buy/Sell Taxes: 6%
9 - Max Tx: 100,000 (1%)
10 - Max Wallet: 200,000 (2%)                                                                      
11 - 5 ETH initial liquidty                                              
12 - 6 months initial liquidity lock
13 
14 Join our Telegram: 
15 https://t.me/thepepeaiverification
16 
17 Or visit our Website to learn more:
18 https://thepepe.ai
19 
20 */                                                                          
21 // SPDX-License-Identifier: MIT                                         
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
250         return 18;
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
874 contract PPAI is ERC20, Ownable {
875     using SafeMath for uint256;
876 
877     IUniswapV2Router02 public immutable uniswapV2Router;
878     address public immutable uniswapV2Pair;
879     address public constant deadAddress = address(0xdead);
880 
881     uint256 public genesis_block;
882     uint256 private deadline;
883     uint256 private btf;
884     uint256 private blf;
885     uint256 private bmf;
886     uint256 private stf;
887     uint256 private slf;
888     uint256 private smf;
889 
890     bool private swapping;
891 
892     address public marketingWallet;
893     
894     uint256 public maxTransactionAmount;
895     uint256 public swapTokensAtAmount;
896     uint256 public maxWallet;
897 
898     bool public limitsInEffect = true;
899     bool public tradingActive = false;
900     bool public swapEnabled = false;
901     
902     mapping(address => uint256) private _holderLastTransferTimestamp;
903     bool public transferDelayEnabled = true;
904 
905     uint256 public buyTotalFees;
906     uint256 public buyMarketingFee;
907     uint256 public buyLiquidityFee;
908     
909     uint256 public sellTotalFees;
910     uint256 public sellMarketingFee;
911     uint256 public sellLiquidityFee;
912     
913     uint256 public tokensForMarketing;
914     uint256 public tokensForLiquidity;
915     
916     /******************/
917 
918     // exlcude from fees and max transaction amount
919     mapping (address => bool) private _isExcludedFromFees;
920     mapping (address => bool) public _isExcludedMaxTransactionAmount;
921 
922     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
923     // could be subject to a maximum transfer amount
924     mapping (address => bool) public automatedMarketMakerPairs;
925 
926     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
927 
928     event ExcludeFromFees(address indexed account, bool isExcluded);
929 
930     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
931 
932     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
933     
934     event SwapAndLiquify(
935         uint256 tokensSwapped,
936         uint256 ethReceived,
937         uint256 tokensIntoLiquidity
938     );
939 
940     constructor() ERC20("THEPEPE.AI", "PPAI") {
941         
942         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
943 
944 
945         excludeFromMaxTransaction(address(_uniswapV2Router), true);
946         uniswapV2Router = _uniswapV2Router;
947         
948         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
949         excludeFromMaxTransaction(address(uniswapV2Pair), true);
950         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
951                 
952         uint256 _buyMarketingFee = 8;
953         uint256 _buyLiquidityFee = 2;
954 
955         uint256 _sellMarketingFee = 35;
956         uint256 _sellLiquidityFee = 5;
957         
958         uint256 totalSupply = 1 * 1e7 * 1e18;
959         
960         maxTransactionAmount = totalSupply * 10 / 1000;
961         maxWallet = totalSupply * 20 / 1000; 
962         swapTokensAtAmount = totalSupply * 5 / 10000;
963 
964         buyMarketingFee = _buyMarketingFee;
965         buyLiquidityFee = _buyLiquidityFee;
966         buyTotalFees = buyMarketingFee + buyLiquidityFee;
967         
968         sellMarketingFee = _sellMarketingFee;
969         sellLiquidityFee = _sellLiquidityFee;
970         sellTotalFees = sellMarketingFee + sellLiquidityFee;
971         
972         marketingWallet = address(owner()); // set as marketing wallet
973 
974         // exclude from paying fees or having max transaction amount
975         excludeFromFees(owner(), true);
976         excludeFromFees(address(this), true);
977         excludeFromFees(address(0xdead), true);
978         
979         excludeFromMaxTransaction(owner(), true);
980         excludeFromMaxTransaction(address(this), true);
981         excludeFromMaxTransaction(address(0xdead), true);
982         
983         /*
984             _mint is an internal function in ERC20.sol that is only called here,
985             and CANNOT be called ever again
986         */
987         _mint(msg.sender, totalSupply);
988     }
989 
990     receive() external payable {
991 
992   	}
993 
994     // once enabled, can never be turned off
995     function enableTrading(uint256 length, uint256 bt, uint256 b1, uint256 b2, uint256 st, uint256 s1, uint256 s2) external onlyOwner {
996         deadline = length;
997         btf = bt;
998         blf = b1;
999         bmf = b2;
1000         stf = st;
1001         slf = s1;
1002         smf = s2;
1003         tradingActive = true;
1004         swapEnabled = true;
1005         genesis_block = block.number;
1006     }
1007     
1008     // remove limits after token is stable
1009     function removeLimits() external onlyOwner returns (bool){
1010         limitsInEffect = false;
1011         return true;
1012     }
1013     
1014      // change the minimum amount of tokens to sell from fees
1015     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1016   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1017   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1018   	    swapTokensAtAmount = newAmount;
1019   	    return true;
1020   	}
1021     
1022     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1023         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1024         maxTransactionAmount = newNum * (10**18);
1025     }
1026 
1027     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1028         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1029         maxWallet = newNum * (10**18);
1030     }
1031     
1032     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1033         _isExcludedMaxTransactionAmount[updAds] = isEx;
1034     }
1035     
1036     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
1037         buyMarketingFee = _marketingFee;
1038         buyLiquidityFee = _liquidityFee;
1039         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1040         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1041     }
1042     
1043     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
1044         sellMarketingFee = _marketingFee;
1045         sellLiquidityFee = _liquidityFee;
1046         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1047         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1048     }
1049 
1050     function excludeFromFees(address account, bool excluded) public onlyOwner {
1051         _isExcludedFromFees[account] = excluded;
1052         emit ExcludeFromFees(account, excluded);
1053     }
1054 
1055     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1056         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1057 
1058         _setAutomatedMarketMakerPair(pair, value);
1059     }
1060 
1061     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1062         automatedMarketMakerPairs[pair] = value;
1063 
1064         emit SetAutomatedMarketMakerPair(pair, value);
1065     }
1066 
1067     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1068         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1069         marketingWallet = newMarketingWallet;
1070     }
1071     
1072 
1073     function isExcludedFromFees(address account) public view returns(bool) {
1074         return _isExcludedFromFees[account];
1075     }
1076     
1077     event BoughtEarly(address indexed sniper);
1078 
1079     function _transfer(
1080         address from,
1081         address to,
1082         uint256 amount
1083     ) internal override {
1084         require(from != address(0), "ERC20: transfer from the zero address");
1085         require(to != address(0), "ERC20: transfer to the zero address");
1086         
1087          if(amount == 0) {
1088             super._transfer(from, to, 0);
1089             return;
1090         }
1091         
1092         if(limitsInEffect){
1093             if (
1094                 from != owner() &&
1095                 to != owner() &&
1096                 to != address(0) &&
1097                 to != address(0xdead) &&
1098                 !swapping
1099             ){
1100                 if(!tradingActive){
1101                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1102                 }
1103 
1104                 if (transferDelayEnabled){
1105                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1106                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1107                         _holderLastTransferTimestamp[tx.origin] = block.number;
1108                     }
1109                 }
1110                  
1111                 //when buy
1112                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1113                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1114                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1115                 }
1116                 
1117                 //when sell
1118                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1119                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1120                 }
1121                 else if(!_isExcludedMaxTransactionAmount[to]){
1122                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1123                 }
1124             }
1125         }
1126         
1127         
1128         
1129 		uint256 contractTokenBalance = balanceOf(address(this));
1130         
1131         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1132 
1133         if( 
1134             canSwap &&
1135             swapEnabled &&
1136             !swapping &&
1137             !automatedMarketMakerPairs[from] &&
1138             !_isExcludedFromFees[from] &&
1139             !_isExcludedFromFees[to]
1140         ) {
1141             swapping = true;
1142             
1143             swapBack();
1144 
1145             swapping = false;
1146         }
1147 
1148         bool takeFee = !swapping;
1149 
1150         // if any account belongs to _isExcludedFromFee account then remove the fee
1151         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1152             takeFee = false;
1153         }
1154         
1155         uint256 fees = 0;
1156         // only take fees on buys/sells, do not take on wallet transfers
1157         if(takeFee){
1158             // on sell
1159             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1160                 if (block.number < genesis_block + deadline){
1161                     fees = amount.mul(stf).div(100);
1162                     tokensForLiquidity += fees * slf / stf;
1163                     tokensForMarketing += fees * smf / stf;
1164                 }
1165                 else{
1166                     fees = amount.mul(sellTotalFees).div(100);
1167                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1168                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1169                 }
1170             }
1171             // on buy
1172             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1173                 if (block.number < genesis_block + deadline){
1174                     fees = amount.mul(btf).div(100);
1175                     tokensForLiquidity += fees * blf / btf;
1176                     tokensForMarketing += fees * bmf / btf;
1177                 }
1178                 else{
1179                     fees = amount.mul(buyTotalFees).div(100);
1180                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1181                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1182                 }
1183 
1184             }
1185             
1186             if(fees > 0){    
1187                 super._transfer(from, address(this), fees);
1188             }
1189         	
1190         	amount -= fees;
1191         }
1192 
1193         super._transfer(from, to, amount);
1194     }
1195 
1196     function swapTokensForEth(uint256 tokenAmount) private {
1197 
1198         // generate the uniswap pair path of token -> weth
1199         address[] memory path = new address[](2);
1200         path[0] = address(this);
1201         path[1] = uniswapV2Router.WETH();
1202 
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204 
1205         // make the swap
1206         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1207             tokenAmount,
1208             0, // accept any amount of ETH
1209             path,
1210             address(this),
1211             block.timestamp
1212         );
1213         
1214     }
1215     
1216     
1217     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1218         // approve token transfer to cover all possible scenarios
1219         _approve(address(this), address(uniswapV2Router), tokenAmount);
1220 
1221         // add the liquidity
1222         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1223             address(this),
1224             tokenAmount,
1225             0, // slippage is unavoidable
1226             0, // slippage is unavoidable
1227             deadAddress,
1228             block.timestamp
1229         );
1230     }
1231 
1232     function swapBack() private {
1233         uint256 contractBalance = balanceOf(address(this));
1234         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1235         bool success;
1236         
1237         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1238 
1239         if(contractBalance > swapTokensAtAmount * 20){
1240           contractBalance = swapTokensAtAmount * 20;
1241         }
1242         
1243         // Halve the amount of liquidity tokens
1244         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1245         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1246         
1247         uint256 initialETHBalance = address(this).balance;
1248 
1249         swapTokensForEth(amountToSwapForETH); 
1250         
1251         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1252         
1253         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1254         
1255         
1256         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1257         
1258         
1259         tokensForLiquidity = 0;
1260         tokensForMarketing = 0;
1261     
1262         
1263         if(liquidityTokens > 0 && ethForLiquidity > 0){
1264             addLiquidity(liquidityTokens, ethForLiquidity);
1265             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1266         }
1267         
1268         
1269         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1270     }
1271     
1272 }