1 /**
2 One Dollar Millionaire - $DOLLAR
3 $Dollar token will add exactly 1$ worth of ethereum against all of the supply. We will start off with 1$ worth of liquidity.
4 
5 But to boost it as we grow we will add 5% liqudity tax for buying and selling which will in return grow our initial liquidity.
6 
7  
8 
9 Dollar tokens only utility is to reach 1 million marketcap starting out with just a single $ worth of liquidity.
10 
11 TG: https://t.me/OneDollarMillionaire
12 
13 Twitter: https://twitter.com/DOLLARERC
14 
15 Website: http://onedollarmillionaire.net/
16 /*
17  
18 // SPDX-License-Identifier: Unlicensed
19 
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
57     event Swap(
58         address indexed sender,
59         uint amount0In,
60         uint amount1In,
61         uint amount0Out,
62         uint amount1Out,
63         address indexed to
64     );
65     event Sync(uint112 reserve0, uint112 reserve1);
66  
67     function MINIMUM_LIQUIDITY() external pure returns (uint);
68     function factory() external view returns (address);
69     function token0() external view returns (address);
70     function token1() external view returns (address);
71     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
72     function price0CumulativeLast() external view returns (uint);
73     function price1CumulativeLast() external view returns (uint);
74     function kLast() external view returns (uint);
75  
76     function mint(address to) external returns (uint liquidity);
77     function burn(address to) external returns (uint amount0, uint amount1);
78     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
79     function skim(address to) external;
80     function sync() external;
81  
82     function initialize(address, address) external;
83 }
84  
85 interface IUniswapV2Factory {
86     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
87  
88     function feeTo() external view returns (address);
89     function feeToSetter() external view returns (address);
90  
91     function getPair(address tokenA, address tokenB) external view returns (address pair);
92     function allPairs(uint) external view returns (address pair);
93     function allPairsLength() external view returns (uint);
94  
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96  
97     function setFeeTo(address) external;
98     function setFeeToSetter(address) external;
99 }
100  
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106  
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111  
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120  
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129  
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145  
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160  
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168  
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175  
176 interface IERC20Metadata is IERC20 {
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() external view returns (string memory);
181  
182     /**
183      * @dev Returns the symbol of the token.
184      */
185     function symbol() external view returns (string memory);
186  
187     /**
188      * @dev Returns the decimals places of the token.
189      */
190     function decimals() external view returns (uint8);
191 }
192  
193  
194 contract ERC20 is Context, IERC20, IERC20Metadata {
195     using SafeMath for uint256;
196  
197     mapping(address => uint256) private _balances;
198  
199     mapping(address => mapping(address => uint256)) private _allowances;
200  
201     uint256 private _totalSupply;
202  
203     string private _name;
204     string private _symbol;
205  
206     /**
207      * @dev Sets the values for {name} and {symbol}.
208      *
209      * The default value of {decimals} is 18. To select a different value for
210      * {decimals} you should overload it.
211      *
212      * All two of these values are immutable: they can only be set once during
213      * construction.
214      */
215     constructor(string memory name_, string memory symbol_) {
216         _name = name_;
217         _symbol = symbol_;
218     }
219  
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() public view virtual override returns (string memory) {
224         return _name;
225     }
226  
227     /**
228      * @dev Returns the symbol of the token, usually a shorter version of the
229      * name.
230      */
231     function symbol() public view virtual override returns (string memory) {
232         return _symbol;
233     }
234  
235     /**
236      * @dev Returns the number of decimals used to get its user representation.
237      * For example, if `decimals` equals `2`, a balance of `505` tokens should
238      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
239      *
240      * Tokens usually opt for a value of 18, imitating the relationship between
241      * Ether and Wei. This is the value {ERC20} uses, unless this function is
242      * overridden;
243      *
244      * NOTE: This information is only used for _display_ purposes: it in
245      * no way affects any of the arithmetic of the contract, including
246      * {IERC20-balanceOf} and {IERC20-transfer}.
247      */
248     function decimals() public view virtual override returns (uint8) {
249         return 18;
250     }
251  
252     /**
253      * @dev See {IERC20-totalSupply}.
254      */
255     function totalSupply() public view virtual override returns (uint256) {
256         return _totalSupply;
257     }
258  
259     /**
260      * @dev See {IERC20-balanceOf}.
261      */
262     function balanceOf(address account) public view virtual override returns (uint256) {
263         return _balances[account];
264     }
265  
266     /**
267      * @dev See {IERC20-transfer}.
268      *
269      * Requirements:
270      *
271      * - `recipient` cannot be the zero address.
272      * - the caller must have a balance of at least `amount`.
273      */
274     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
275         _transfer(_msgSender(), recipient, amount);
276         return true;
277     }
278  
279     /**
280      * @dev See {IERC20-allowance}.
281      */
282     function allowance(address owner, address spender) public view virtual override returns (uint256) {
283         return _allowances[owner][spender];
284     }
285  
286     /**
287      * @dev See {IERC20-approve}.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function approve(address spender, uint256 amount) public virtual override returns (bool) {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297  
298     /**
299      * @dev See {IERC20-transferFrom}.
300      *
301      * Emits an {Approval} event indicating the updated allowance. This is not
302      * required by the EIP. See the note at the beginning of {ERC20}.
303      *
304      * Requirements:
305      *
306      * - `sender` and `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      * - the caller must have allowance for ``sender``'s tokens of at least
309      * `amount`.
310      */
311     function transferFrom(
312         address sender,
313         address recipient,
314         uint256 amount
315     ) public virtual override returns (bool) {
316         _transfer(sender, recipient, amount);
317         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
318         return true;
319     }
320  
321     /**
322      * @dev Atomically increases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
335         return true;
336     }
337  
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
353         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
354         return true;
355     }
356  
357     /**
358      * @dev Moves tokens `amount` from `sender` to `recipient`.
359      *
360      * This is internal function is equivalent to {transfer}, and can be used to
361      * e.g. implement automatic token fees, slashing mechanisms, etc.
362      *
363      * Emits a {Transfer} event.
364      *
365      * Requirements:
366      *
367      * - `sender` cannot be the zero address.
368      * - `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      */
371     function _transfer(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) internal virtual {
376         require(sender != address(0), "ERC20: transfer from the zero address");
377         require(recipient != address(0), "ERC20: transfer to the zero address");
378  
379         _beforeTokenTransfer(sender, recipient, amount);
380  
381         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
382         _balances[recipient] = _balances[recipient].add(amount);
383         emit Transfer(sender, recipient, amount);
384     }
385  
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397  
398         _beforeTokenTransfer(address(0), account, amount);
399  
400         _totalSupply = _totalSupply.add(amount);
401         _balances[account] = _balances[account].add(amount);
402         emit Transfer(address(0), account, amount);
403     }
404  
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418  
419         _beforeTokenTransfer(account, address(0), amount);
420  
421         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
422         _totalSupply = _totalSupply.sub(amount);
423         emit Transfer(account, address(0), amount);
424     }
425  
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
428      *
429      * This internal function is equivalent to `approve`, and can be used to
430      * e.g. set automatic allowances for certain subsystems, etc.
431      *
432      * Emits an {Approval} event.
433      *
434      * Requirements:
435      *
436      * - `owner` cannot be the zero address.
437      * - `spender` cannot be the zero address.
438      */
439     function _approve(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446  
447         _allowances[owner][spender] = amount;
448         emit Approval(owner, spender, amount);
449     }
450  
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be to transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 }
471  
472 library SafeMath {
473     /**
474      * @dev Returns the addition of two unsigned integers, reverting on
475      * overflow.
476      *
477      * Counterpart to Solidity's `+` operator.
478      *
479      * Requirements:
480      *
481      * - Addition cannot overflow.
482      */
483     function add(uint256 a, uint256 b) internal pure returns (uint256) {
484         uint256 c = a + b;
485         require(c >= a, "SafeMath: addition overflow");
486  
487         return c;
488     }
489  
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
501         return sub(a, b, "SafeMath: subtraction overflow");
502     }
503  
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
506      * overflow (when the result is negative).
507      *
508      * Counterpart to Solidity's `-` operator.
509      *
510      * Requirements:
511      *
512      * - Subtraction cannot overflow.
513      */
514     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b <= a, errorMessage);
516         uint256 c = a - b;
517  
518         return c;
519     }
520  
521     /**
522      * @dev Returns the multiplication of two unsigned integers, reverting on
523      * overflow.
524      *
525      * Counterpart to Solidity's `*` operator.
526      *
527      * Requirements:
528      *
529      * - Multiplication cannot overflow.
530      */
531     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
532         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
533         // benefit is lost if 'b' is also tested.
534         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
535         if (a == 0) {
536             return 0;
537         }
538  
539         uint256 c = a * b;
540         require(c / a == b, "SafeMath: multiplication overflow");
541  
542         return c;
543     }
544  
545     /**
546      * @dev Returns the integer division of two unsigned integers. Reverts on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b) internal pure returns (uint256) {
558         return div(a, b, "SafeMath: division by zero");
559     }
560  
561     /**
562      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
563      * division by zero. The result is rounded towards zero.
564      *
565      * Counterpart to Solidity's `/` operator. Note: this function uses a
566      * `revert` opcode (which leaves remaining gas untouched) while Solidity
567      * uses an invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
574         require(b > 0, errorMessage);
575         uint256 c = a / b;
576         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
577  
578         return c;
579     }
580  
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * Reverts when dividing by zero.
584      *
585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
586      * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
594         return mod(a, b, "SafeMath: modulo by zero");
595     }
596  
597     /**
598      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
599      * Reverts with custom message when dividing by zero.
600      *
601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
602      * opcode (which leaves remaining gas untouched) while Solidity uses an
603      * invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      *
607      * - The divisor cannot be zero.
608      */
609     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
610         require(b != 0, errorMessage);
611         return a % b;
612     }
613 }
614  
615 contract Ownable is Context {
616     address private _owner;
617  
618     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619  
620     /**
621      * @dev Initializes the contract setting the deployer as the initial owner.
622      */
623     constructor () {
624         address msgSender = _msgSender();
625         _owner = msgSender;
626         emit OwnershipTransferred(address(0), msgSender);
627     }
628  
629     /**
630      * @dev Returns the address of the current owner.
631      */
632     function owner() public view returns (address) {
633         return _owner;
634     }
635  
636     /**
637      * @dev Throws if called by any account other than the owner.
638      */
639     modifier onlyOwner() {
640         require(_owner == _msgSender(), "Ownable: caller is not the owner");
641         _;
642     }
643  
644     /**
645      * @dev Leaves the contract without owner. It will not be possible to call
646      * `onlyOwner` functions anymore. Can only be called by the current owner.
647      *
648      * NOTE: Renouncing ownership will leave the contract without an owner,
649      * thereby removing any functionality that is only available to the owner.
650      */
651     function renounceOwnership() public virtual onlyOwner {
652         emit OwnershipTransferred(_owner, address(0));
653         _owner = address(0);
654     }
655  
656     /**
657      * @dev Transfers ownership of the contract to a new account (`newOwner`).
658      * Can only be called by the current owner.
659      */
660     function transferOwnership(address newOwner) public virtual onlyOwner {
661         require(newOwner != address(0), "Ownable: new owner is the zero address");
662         emit OwnershipTransferred(_owner, newOwner);
663         _owner = newOwner;
664     }
665 }
666  
667  
668  
669 library SafeMathInt {
670     int256 private constant MIN_INT256 = int256(1) << 255;
671     int256 private constant MAX_INT256 = ~(int256(1) << 255);
672  
673     /**
674      * @dev Multiplies two int256 variables and fails on overflow.
675      */
676     function mul(int256 a, int256 b) internal pure returns (int256) {
677         int256 c = a * b;
678  
679         // Detect overflow when multiplying MIN_INT256 with -1
680         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
681         require((b == 0) || (c / b == a));
682         return c;
683     }
684  
685     /**
686      * @dev Division of two int256 variables and fails on overflow.
687      */
688     function div(int256 a, int256 b) internal pure returns (int256) {
689         // Prevent overflow when dividing MIN_INT256 by -1
690         require(b != -1 || a != MIN_INT256);
691  
692         // Solidity already throws when dividing by 0.
693         return a / b;
694     }
695  
696     /**
697      * @dev Subtracts two int256 variables and fails on overflow.
698      */
699     function sub(int256 a, int256 b) internal pure returns (int256) {
700         int256 c = a - b;
701         require((b >= 0 && c <= a) || (b < 0 && c > a));
702         return c;
703     }
704  
705     /**
706      * @dev Adds two int256 variables and fails on overflow.
707      */
708     function add(int256 a, int256 b) internal pure returns (int256) {
709         int256 c = a + b;
710         require((b >= 0 && c >= a) || (b < 0 && c < a));
711         return c;
712     }
713  
714     /**
715      * @dev Converts to absolute value, and fails on overflow.
716      */
717     function abs(int256 a) internal pure returns (int256) {
718         require(a != MIN_INT256);
719         return a < 0 ? -a : a;
720     }
721  
722  
723     function toUint256Safe(int256 a) internal pure returns (uint256) {
724         require(a >= 0);
725         return uint256(a);
726     }
727 }
728  
729 library SafeMathUint {
730   function toInt256Safe(uint256 a) internal pure returns (int256) {
731     int256 b = int256(a);
732     require(b >= 0);
733     return b;
734   }
735 }
736  
737  
738 interface IUniswapV2Router01 {
739     function factory() external pure returns (address);
740     function WETH() external pure returns (address);
741  
742     function addLiquidity(
743         address tokenA,
744         address tokenB,
745         uint amountADesired,
746         uint amountBDesired,
747         uint amountAMin,
748         uint amountBMin,
749         address to,
750         uint deadline
751     ) external returns (uint amountA, uint amountB, uint liquidity);
752     function addLiquidityETH(
753         address token,
754         uint amountTokenDesired,
755         uint amountTokenMin,
756         uint amountETHMin,
757         address to,
758         uint deadline
759     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
760     function removeLiquidity(
761         address tokenA,
762         address tokenB,
763         uint liquidity,
764         uint amountAMin,
765         uint amountBMin,
766         address to,
767         uint deadline
768     ) external returns (uint amountA, uint amountB);
769     function removeLiquidityETH(
770         address token,
771         uint liquidity,
772         uint amountTokenMin,
773         uint amountETHMin,
774         address to,
775         uint deadline
776     ) external returns (uint amountToken, uint amountETH);
777     function removeLiquidityWithPermit(
778         address tokenA,
779         address tokenB,
780         uint liquidity,
781         uint amountAMin,
782         uint amountBMin,
783         address to,
784         uint deadline,
785         bool approveMax, uint8 v, bytes32 r, bytes32 s
786     ) external returns (uint amountA, uint amountB);
787     function removeLiquidityETHWithPermit(
788         address token,
789         uint liquidity,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline,
794         bool approveMax, uint8 v, bytes32 r, bytes32 s
795     ) external returns (uint amountToken, uint amountETH);
796     function swapExactTokensForTokens(
797         uint amountIn,
798         uint amountOutMin,
799         address[] calldata path,
800         address to,
801         uint deadline
802     ) external returns (uint[] memory amounts);
803     function swapTokensForExactTokens(
804         uint amountOut,
805         uint amountInMax,
806         address[] calldata path,
807         address to,
808         uint deadline
809     ) external returns (uint[] memory amounts);
810     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
811         external
812         payable
813         returns (uint[] memory amounts);
814     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
815         external
816         returns (uint[] memory amounts);
817     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
818         external
819         returns (uint[] memory amounts);
820     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
821         external
822         payable
823         returns (uint[] memory amounts);
824  
825     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
826     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
827     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
828     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
829     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
830 }
831  
832 interface IUniswapV2Router02 is IUniswapV2Router01 {
833     function removeLiquidityETHSupportingFeeOnTransferTokens(
834         address token,
835         uint liquidity,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline
840     ) external returns (uint amountETH);
841     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
842         address token,
843         uint liquidity,
844         uint amountTokenMin,
845         uint amountETHMin,
846         address to,
847         uint deadline,
848         bool approveMax, uint8 v, bytes32 r, bytes32 s
849     ) external returns (uint amountETH);
850  
851     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
852         uint amountIn,
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external;
858     function swapExactETHForTokensSupportingFeeOnTransferTokens(
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external payable;
864     function swapExactTokensForETHSupportingFeeOnTransferTokens(
865         uint amountIn,
866         uint amountOutMin,
867         address[] calldata path,
868         address to,
869         uint deadline
870     ) external;
871 }
872  
873 contract DOLLAR is ERC20, Ownable {
874     using SafeMath for uint256;
875  
876     IUniswapV2Router02 public immutable uniswapV2Router;
877     address public immutable uniswapV2Pair;
878  
879     bool private swapping;
880  
881     address private marketingWallet;
882     address private devWallet;
883  
884     uint256 public maxTransactionAmount;
885     uint256 public swapTokensAtAmount;
886     uint256 public maxWallet;
887  
888     bool public limitsInEffect = true;
889     bool public tradingActive = false;
890     bool public swapEnabled = false;
891  
892      // Anti-bot and anti-whale mappings and variables
893     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
894  
895     // Seller Map
896     mapping (address => uint256) private _holderFirstBuyTimestamp;
897  
898     // Blacklist Map
899     mapping (address => bool) private _blacklist;
900     bool public transferDelayEnabled = true;
901  
902     uint256 public buyTotalFees;
903     uint256 public buyMarketingFee;
904     uint256 public buyLiquidityFee;
905     uint256 public buyDevFee;
906  
907     uint256 public sellTotalFees;
908     uint256 public sellMarketingFee;
909     uint256 public sellLiquidityFee;
910     uint256 public sellDevFee;
911  
912     uint256 public tokensForMarketing;
913     uint256 public tokensForLiquidity;
914     uint256 public tokensForDev;
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
949     constructor() ERC20("One Dollar Millionaire", "DOLLAR") {
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
960         uint256 _buyMarketingFee = 0;
961         uint256 _buyLiquidityFee = 5;
962         uint256 _buyDevFee = 0;
963  
964         uint256 _sellMarketingFee = 0;
965         uint256 _sellLiquidityFee = 5;
966         uint256 _sellDevFee = 0;
967  
968         uint256 totalSupply = 1 * 1e12 * 1e18;
969  
970         maxTransactionAmount = totalSupply * 10 / 1000; // 2% maxTransactionAmountTxn
971         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
972         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1% swap wallet
973  
974         buyMarketingFee = _buyMarketingFee;
975         buyLiquidityFee = _buyLiquidityFee;
976         buyDevFee = _buyDevFee;
977         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
978  
979         sellMarketingFee = _sellMarketingFee;
980         sellLiquidityFee = _sellLiquidityFee;
981         sellDevFee = _sellDevFee;
982         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
983  
984         marketingWallet = address(owner()); // set as marketing wallet
985         devWallet = address(owner()); // set as dev wallet
986  
987         // exclude from paying fees or having max transaction amount
988         excludeFromFees(owner(), true);
989         excludeFromFees(address(this), true);
990         excludeFromFees(address(0xdead), true);
991  
992         excludeFromMaxTransaction(owner(), true);
993         excludeFromMaxTransaction(address(this), true);
994         excludeFromMaxTransaction(address(0xdead), true);
995  
996         /*
997             _mint is an internal function in ERC20.sol that is only called here,
998             and CANNOT be called ever again
999         */
1000         _mint(msg.sender, totalSupply);
1001     }
1002  
1003     receive() external payable {
1004  
1005     }
1006  
1007     // once enabled, can never be turned off
1008     function enableTrading() external onlyOwner {
1009         tradingActive = true;
1010         swapEnabled = true;
1011         launchedAt = block.number;
1012     }
1013  
1014     // remove limits after token is stable
1015     function removeLimits() external onlyOwner returns (bool){
1016         limitsInEffect = false;
1017         return true;
1018     }
1019  
1020     // disable Transfer delay - cannot be reenabled
1021     function disableTransferDelay() external onlyOwner returns (bool){
1022         transferDelayEnabled = false;
1023         return true;
1024     }
1025  
1026      // change the minimum amount of tokens to sell from fees
1027     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1028         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1029         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1030         swapTokensAtAmount = newAmount;
1031         return true;
1032     }
1033  
1034     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1035         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1036         maxTransactionAmount = newNum * (10**18);
1037     }
1038  
1039     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1040         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1041         maxWallet = newNum * (10**18);
1042     }
1043  
1044     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1045         _isExcludedMaxTransactionAmount[updAds] = isEx;
1046     }
1047  
1048     // only use to disable contract sales if absolutely necessary (emergency use only)
1049     function updateSwapEnabled(bool enabled) external onlyOwner(){
1050         swapEnabled = enabled;
1051     }
1052  
1053     function excludeFromFees(address account, bool excluded) public onlyOwner {
1054         _isExcludedFromFees[account] = excluded;
1055         emit ExcludeFromFees(account, excluded);
1056     }
1057  
1058     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1059         _blacklist[account] = isBlacklisted;
1060     }
1061  
1062     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1063         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1064  
1065         _setAutomatedMarketMakerPair(pair, value);
1066     }
1067  
1068     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1069         automatedMarketMakerPairs[pair] = value;
1070  
1071         emit SetAutomatedMarketMakerPair(pair, value);
1072     }
1073  
1074     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1075         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1076         marketingWallet = newMarketingWallet;
1077     }
1078  
1079     function updateDevWallet(address newWallet) external onlyOwner {
1080         emit devWalletUpdated(newWallet, devWallet);
1081         devWallet = newWallet;
1082     }
1083  
1084  
1085     function isExcludedFromFees(address account) public view returns(bool) {
1086         return _isExcludedFromFees[account];
1087     }
1088  
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 amount
1093     ) internal override {
1094         require(from != address(0), "ERC20: transfer from the zero address");
1095         require(to != address(0), "ERC20: transfer to the zero address");
1096         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1097          if(amount == 0) {
1098             super._transfer(from, to, 0);
1099             return;
1100         }
1101  
1102         if(limitsInEffect){
1103             if (
1104                 from != owner() &&
1105                 to != owner() &&
1106                 to != address(0) &&
1107                 to != address(0xdead) &&
1108                 !swapping
1109             ){
1110                 if(!tradingActive){
1111                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1112                 }
1113  
1114                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1115                 if (transferDelayEnabled){
1116                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1117                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1118                         _holderLastTransferTimestamp[tx.origin] = block.number;
1119                     }
1120                 }
1121  
1122                 //when buy
1123                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1124                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1125                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1126                 }
1127  
1128                 //when sell
1129                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1130                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1131                 }
1132                 else if(!_isExcludedMaxTransactionAmount[to]){
1133                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1134                 }
1135             }
1136         }
1137  
1138         uint256 contractTokenBalance = balanceOf(address(this));
1139  
1140         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1141  
1142         if( 
1143             canSwap &&
1144             swapEnabled &&
1145             !swapping &&
1146             !automatedMarketMakerPairs[from] &&
1147             !_isExcludedFromFees[from] &&
1148             !_isExcludedFromFees[to]
1149         ) {
1150             swapping = true;
1151  
1152             swapBack();
1153  
1154             swapping = false;
1155         }
1156  
1157         bool takeFee = !swapping;
1158  
1159         // if any account belongs to _isExcludedFromFee account then remove the fee
1160         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1161             takeFee = false;
1162         }
1163  
1164         uint256 fees = 0;
1165         // only take fees on buys/sells, do not take on wallet transfers
1166         if(takeFee){
1167             // on sell
1168             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1169                 fees = amount.mul(sellTotalFees).div(100);
1170                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1171                 tokensForDev += fees * sellDevFee / sellTotalFees;
1172                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1173             }
1174             // on buy
1175             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1176                 fees = amount.mul(buyTotalFees).div(100);
1177                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1178                 tokensForDev += fees * buyDevFee / buyTotalFees;
1179                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1180             }
1181  
1182             if(fees > 0){    
1183                 super._transfer(from, address(this), fees);
1184             }
1185  
1186             amount -= fees;
1187         }
1188  
1189         super._transfer(from, to, amount);
1190     }
1191  
1192     function swapTokensForEth(uint256 tokenAmount) private {
1193  
1194         // generate the uniswap pair path of token -> weth
1195         address[] memory path = new address[](2);
1196         path[0] = address(this);
1197         path[1] = uniswapV2Router.WETH();
1198  
1199         _approve(address(this), address(uniswapV2Router), tokenAmount);
1200  
1201         // make the swap
1202         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1203             tokenAmount,
1204             0, // accept any amount of ETH
1205             path,
1206             address(this),
1207             block.timestamp
1208         );
1209  
1210     }
1211  
1212     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1213         // approve token transfer to cover all possible scenarios
1214         _approve(address(this), address(uniswapV2Router), tokenAmount);
1215  
1216         // add the liquidity
1217         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1218             address(this),
1219             tokenAmount,
1220             0, // slippage is unavoidable
1221             0, // slippage is unavoidable
1222             address(this),
1223             block.timestamp
1224         );
1225     }
1226  
1227     function swapBack() private {
1228         uint256 contractBalance = balanceOf(address(this));
1229         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1230         bool success;
1231  
1232         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1233  
1234         if(contractBalance > swapTokensAtAmount * 20){
1235           contractBalance = swapTokensAtAmount * 20;
1236         }
1237  
1238         // Halve the amount of liquidity tokens
1239         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1240         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1241  
1242         uint256 initialETHBalance = address(this).balance;
1243  
1244         swapTokensForEth(amountToSwapForETH); 
1245  
1246         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1247  
1248         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1249         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1250         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1251  
1252  
1253         tokensForLiquidity = 0;
1254         tokensForMarketing = 0;
1255         tokensForDev = 0;
1256  
1257         (success,) = address(devWallet).call{value: ethForDev}("");
1258  
1259         if(liquidityTokens > 0 && ethForLiquidity > 0){
1260             addLiquidity(liquidityTokens, ethForLiquidity);
1261             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1262         }
1263  
1264         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1265     }
1266 }