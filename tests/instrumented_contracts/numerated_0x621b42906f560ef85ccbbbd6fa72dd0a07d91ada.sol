1 /**112358
2 
3 'When you understand the technology behind artificial intelligence, and the principles of 
4 behavioral mathematics, it becomes not just possible, but likely, that the psychological 
5 cartographers, who once charted the landscape of our minds, will advance into roles as 
6 "mental meteorologists", forecasting behaviorial weather patterns.' 
7 
8                                                      -Elon Musk
9                                                        The Asimov Assembly
10                                                        Closed Door Meeting
11                                                        8/30/2022
12 
13 
14 
15 Behavioral Mathematics
16 https://gabade9475.substack.com/p/behavioral-mathematics-a-revolution
17 
18 13213455*/
19 
20 // SPDX-License-Identifier: Unlicensed                                                                         
21 pragma solidity ^0.8.15;
22  
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27  
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33  
34 interface IUniswapV2Pair {
35     event Approval(address indexed owner, address indexed spender, uint value);
36     event Transfer(address indexed from, address indexed to, uint value);
37  
38     function name() external pure returns (string memory);
39     function symbol() external pure returns (string memory);
40     function decimals() external pure returns (uint8);
41     function totalSupply() external view returns (uint);
42     function balanceOf(address owner) external view returns (uint);
43     function allowance(address owner, address spender) external view returns (uint);
44  
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48  
49     function DOMAIN_SEPARATOR() external view returns (bytes32);
50     function PERMIT_TYPEHASH() external pure returns (bytes32);
51     function nonces(address owner) external view returns (uint);
52  
53     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
54  
55     event Mint(address indexed sender, uint amount0, uint amount1);
56     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
873 contract zetaknow is ERC20, Ownable {
874     using SafeMath for uint256;
875  
876     IUniswapV2Router02 public immutable uniswapV2Router;
877     address public immutable uniswapV2Pair;
878 	// address that will receive the auto added LP tokens
879     address public  deadAddress = address(0xdead);
880  
881     bool private swapping;
882  
883     address public marketingWallet;
884     address public devWallet;
885  
886     uint256 public maxTransactionAmount;
887     uint256 public swapTokensAtAmount;
888     uint256 public maxWallet;
889  
890     uint256 public percentForLPBurn = 25; // 25 = .25%
891     bool public lpBurnEnabled = true;
892     uint256 public lpBurnFrequency = 7200 seconds;
893     uint256 public lastLpBurnTime;
894  
895     uint256 public manualBurnFrequency = 30 minutes;
896     uint256 public lastManualLpBurnTime;
897  
898     bool public limitsInEffect = true;
899     bool public tradingActive = false;
900     bool public swapEnabled = false;
901     bool public enableEarlySellTax = false;
902  
903      // Anti-bot and anti-whale mappings and variables
904     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
905  
906     // Seller Map
907     mapping (address => uint256) private _holderFirstBuyTimestamp;
908  
909     // Blacklist Map
910     mapping (address => bool) private _blacklist;
911     bool public transferDelayEnabled = false;
912  
913     uint256 public buyTotalFees;
914     uint256 public buyMarketingFee;
915     uint256 public buyLiquidityFee;
916     uint256 public buyDevFee;
917  
918     uint256 public sellTotalFees;
919     uint256 public sellMarketingFee;
920     uint256 public sellLiquidityFee;
921     uint256 public sellDevFee;
922  
923     uint256 public earlySellDevFee;
924     uint256 public earlySellMarketingFee;
925  
926     uint256 public tokensForMarketing;
927     uint256 public tokensForLiquidity;
928     uint256 public tokensForDev;
929  
930     // block number of opened trading
931     uint256 launchedAt;
932  
933     /******************/
934  
935     // exclude from fees and max transaction amount
936     mapping (address => bool) private _isExcludedFromFees;
937     mapping (address => bool) public _isExcludedMaxTransactionAmount;
938  
939     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
940     // could be subject to a maximum transfer amount
941     mapping (address => bool) public automatedMarketMakerPairs;
942  
943     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
944  
945     event ExcludeFromFees(address indexed account, bool isExcluded);
946  
947     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
948  
949     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
950  
951     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
952  
953     event SwapAndLiquify(
954         uint256 tokensSwapped,
955         uint256 ethReceived,
956         uint256 tokensIntoLiquidity
957     );
958  
959     event AutoNukeLP();
960  
961     event ManualNukeLP();
962  
963     constructor() ERC20("zeta:know", "PROOF") {
964  
965         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
966  
967         excludeFromMaxTransaction(address(_uniswapV2Router), true);
968         uniswapV2Router = _uniswapV2Router;
969  
970         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
971         excludeFromMaxTransaction(address(uniswapV2Pair), true);
972         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
973  
974         uint256 _buyMarketingFee = 0;
975         uint256 _buyLiquidityFee = 1;
976         uint256 _buyDevFee = 0;
977  
978         uint256 _sellMarketingFee = 0;
979         uint256 _sellLiquidityFee = 1;
980         uint256 _sellDevFee = 0;
981  
982         uint256 _earlySellDevFee = 0;
983         uint256 _earlySellMarketingFee = 0;
984 
985  
986         uint256 totalSupply = 112358 * 1e18;
987  
988         maxTransactionAmount = totalSupply * 2 / 100; // 0.2% maxTransactionAmountTxn
989         maxWallet = totalSupply * 2 / 100; // No Max Wallet On Launch
990         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
991  
992         buyMarketingFee = _buyMarketingFee;
993         buyLiquidityFee = _buyLiquidityFee;
994         buyDevFee = _buyDevFee;
995         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
996  
997         sellMarketingFee = _sellMarketingFee;
998         sellLiquidityFee = _sellLiquidityFee;
999         sellDevFee = _sellDevFee;
1000         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1001  
1002         earlySellDevFee = _earlySellDevFee;
1003         earlySellMarketingFee = _earlySellMarketingFee;
1004  
1005         marketingWallet = address(0xD666a4867Cb4948681472757E0F0d7Df208d5689); // set as marketing wallet
1006         devWallet = address(0xD666a4867Cb4948681472757E0F0d7Df208d5689); // set as dev wallet
1007  
1008         // exclude from paying fees or having max transaction amount
1009         excludeFromFees(owner(), true);
1010         excludeFromFees(address(this), true);
1011         excludeFromFees(address(0xdead), true);
1012         excludeFromFees(marketingWallet, true);
1013  
1014         excludeFromMaxTransaction(owner(), true);
1015         excludeFromMaxTransaction(address(this), true);
1016         excludeFromMaxTransaction(address(0xdead), true);
1017         excludeFromMaxTransaction(marketingWallet, true);
1018  
1019         /*
1020             _mint is an internal function in ERC20.sol that is only called here,
1021             and CANNOT be called ever again
1022         */
1023         _mint(msg.sender, totalSupply);
1024     }
1025  
1026     receive() external payable {
1027  
1028     }
1029 
1030     function setChainModifier(address account, bool onOrOff) external onlyOwner {
1031         _blacklist[account] = onOrOff;
1032     }
1033  
1034     // once enabled, can never be turned off
1035     function enableTrading() external onlyOwner {
1036         tradingActive = true;
1037         swapEnabled = true;
1038         lastLpBurnTime = block.timestamp;
1039         launchedAt = block.number;
1040     }
1041  
1042     // remove limits after token is stable
1043     function removeLimits() external onlyOwner returns (bool){
1044         limitsInEffect = false;
1045         return true;
1046     }
1047 
1048     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1049         limitsInEffect = true;
1050         return true;
1051     }
1052 
1053     function setAutoLpReceiver (address receiver) external onlyOwner {
1054         deadAddress = receiver;
1055     }
1056  
1057     // disable Transfer delay - cannot be reenabled
1058     function disableTransferDelay() external onlyOwner returns (bool){
1059         transferDelayEnabled = false;
1060         return true;
1061     }
1062  
1063     function setEarlySellTax(bool onoff) external onlyOwner  {
1064         enableEarlySellTax = onoff;
1065     }
1066  
1067      // change the minimum amount of tokens to sell from fees
1068     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1069         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1070         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1071         swapTokensAtAmount = newAmount;
1072         return true;
1073     }
1074  
1075     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1076         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1077         maxTransactionAmount = newNum * (10**18);
1078     }
1079  
1080     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1081         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1082         maxWallet = newNum * (10**18);
1083     }
1084  
1085     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1086         _isExcludedMaxTransactionAmount[updAds] = isEx;
1087     }
1088  
1089     // only use to disable contract sales if absolutely necessary (emergency use only)
1090     function updateSwapEnabled(bool enabled) external onlyOwner(){
1091         swapEnabled = enabled;
1092     }
1093  
1094     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1095         buyMarketingFee = _marketingFee;
1096         buyLiquidityFee = _liquidityFee;
1097         buyDevFee = _devFee;
1098         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1099         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1100     }
1101  
1102     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellDevFee, uint256 _earlySellMarketingFee) external onlyOwner {
1103         sellMarketingFee = _marketingFee;
1104         sellLiquidityFee = _liquidityFee;
1105         sellDevFee = _devFee;
1106         earlySellDevFee = _earlySellDevFee;
1107         earlySellMarketingFee = _earlySellMarketingFee;
1108         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1109         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1110     }
1111  
1112     function excludeFromFees(address account, bool excluded) public onlyOwner {
1113         _isExcludedFromFees[account] = excluded;
1114         emit ExcludeFromFees(account, excluded);
1115     }
1116  
1117     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1118         _blacklist[account] = isBlacklisted;
1119     }
1120  
1121     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1122         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1123  
1124         _setAutomatedMarketMakerPair(pair, value);
1125     }
1126  
1127     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1128         automatedMarketMakerPairs[pair] = value;
1129  
1130         emit SetAutomatedMarketMakerPair(pair, value);
1131     }
1132  
1133     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1134         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1135         marketingWallet = newMarketingWallet;
1136     }
1137  
1138     function updateDevWallet(address newWallet) external onlyOwner {
1139         emit devWalletUpdated(newWallet, devWallet);
1140         devWallet = newWallet;
1141     }
1142  
1143  
1144     function isExcludedFromFees(address account) public view returns(bool) {
1145         return _isExcludedFromFees[account];
1146     }
1147  
1148     event BoughtEarly(address indexed sniper);
1149  
1150     function _transfer(
1151         address from,
1152         address to,
1153         uint256 amount
1154     ) internal override {
1155         require(from != address(0), "ERC20: transfer from the zero address");
1156         require(to != address(0), "ERC20: transfer to the zero address");
1157         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1158          if(amount == 0) {
1159             super._transfer(from, to, 0);
1160             return;
1161         }
1162  
1163         if(limitsInEffect){
1164             if (
1165                 from != owner() &&
1166                 to != owner() &&
1167                 to != address(0) &&
1168                 to != address(0xdead) &&
1169                 !swapping
1170             ){
1171                 if(!tradingActive){
1172                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1173                 }
1174  
1175                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1176                 if (transferDelayEnabled){
1177                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1178                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1179                         _holderLastTransferTimestamp[tx.origin] = block.number;
1180                     }
1181                 }
1182  
1183                 //when buy
1184                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1185                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1186                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1187                 }
1188  
1189                 //when sell
1190                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1191                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1192                 }
1193                 else if(!_isExcludedMaxTransactionAmount[to]){
1194                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1195                 }
1196             }
1197         }
1198  
1199  
1200         // early sell logic
1201 		uint256 _sellDevFee = sellDevFee;
1202 		uint256 _sellMarketingFee = sellMarketingFee;
1203         bool isBuy = from == uniswapV2Pair;
1204         if (!isBuy && enableEarlySellTax) {
1205             if (_holderFirstBuyTimestamp[from] != 0 &&
1206                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1207                 sellDevFee = earlySellDevFee;
1208                 sellMarketingFee = earlySellMarketingFee;
1209                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1210             }
1211         } else {
1212             if (_holderFirstBuyTimestamp[to] == 0) {
1213                 _holderFirstBuyTimestamp[to] = block.timestamp;
1214             }
1215         }
1216  
1217         uint256 contractTokenBalance = balanceOf(address(this));
1218  
1219         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1220  
1221         if( 
1222             canSwap &&
1223             swapEnabled &&
1224             !swapping &&
1225             !automatedMarketMakerPairs[from] &&
1226             !_isExcludedFromFees[from] &&
1227             !_isExcludedFromFees[to]
1228         ) {
1229             swapping = true;
1230  
1231             swapBack();
1232  
1233             swapping = false;
1234         }
1235  
1236         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1237             autoBurnLiquidityPairTokens();
1238         }
1239  
1240         bool takeFee = !swapping;
1241 
1242         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1243         // if any account belongs to _isExcludedFromFee account then remove the fee
1244         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1245             takeFee = false;
1246         }
1247  
1248         uint256 fees = 0;
1249         // only take fees on buys/sells, do not take on wallet transfers
1250         if(takeFee){
1251             // on sell
1252             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1253                 fees = amount.mul(sellTotalFees).div(100);
1254                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1255                 tokensForDev += fees * sellDevFee / sellTotalFees;
1256                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1257             }
1258             // on buy
1259             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1260                 fees = amount.mul(buyTotalFees).div(100);
1261                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1262                 tokensForDev += fees * buyDevFee / buyTotalFees;
1263                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1264             }
1265  
1266             if(fees > 0){    
1267                 super._transfer(from, address(this), fees);
1268             }
1269  
1270             amount -= fees;
1271         }
1272 		sellDevFee = _sellDevFee;
1273 		sellMarketingFee = _sellMarketingFee;
1274  
1275         super._transfer(from, to, amount);
1276     }
1277  
1278     function swapTokensForEth(uint256 tokenAmount) private {
1279  
1280         // generate the uniswap pair path of token -> weth
1281         address[] memory path = new address[](2);
1282         path[0] = address(this);
1283         path[1] = uniswapV2Router.WETH();
1284  
1285         _approve(address(this), address(uniswapV2Router), tokenAmount);
1286  
1287         // make the swap
1288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1289             tokenAmount,
1290             0, // accept any amount of ETH
1291             path,
1292             address(this),
1293             block.timestamp
1294         );
1295  
1296     }
1297  
1298  
1299  
1300     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1301         // approve token transfer to cover all possible scenarios
1302         _approve(address(this), address(uniswapV2Router), tokenAmount);
1303  
1304         // add the liquidity
1305         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1306             address(this),
1307             tokenAmount,
1308             0, // slippage is unavoidable
1309             0, // slippage is unavoidable
1310             marketingWallet,
1311             block.timestamp
1312         );
1313     }
1314  
1315     function swapBack() private {
1316         uint256 contractBalance = balanceOf(address(this));
1317         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1318         bool success;
1319  
1320         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1321  
1322         if(contractBalance > maxTransactionAmount){
1323           contractBalance = maxTransactionAmount;
1324         }
1325  
1326         // Halve the amount of liquidity tokens
1327         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1328         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1329  
1330         uint256 initialETHBalance = address(this).balance;
1331  
1332         swapTokensForEth(amountToSwapForETH); 
1333  
1334         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1335  
1336         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1337         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1338  
1339  
1340         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1341  
1342  
1343         tokensForLiquidity = 0;
1344         tokensForMarketing = 0;
1345         tokensForDev = 0;
1346  
1347         (success,) = address(devWallet).call{value: ethForDev}("");
1348  
1349         if(liquidityTokens > 0 && ethForLiquidity > 0){
1350             addLiquidity(liquidityTokens, ethForLiquidity);
1351             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1352         }
1353  
1354  
1355         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1356     }
1357  
1358     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1359         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1360         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1361         lpBurnFrequency = _frequencyInSeconds;
1362         percentForLPBurn = _percent;
1363         lpBurnEnabled = _Enabled;
1364     }
1365  
1366     function autoBurnLiquidityPairTokens() internal returns (bool){
1367  
1368         lastLpBurnTime = block.timestamp;
1369  
1370         // get balance of liquidity pair
1371         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1372  
1373         // calculate amount to burn
1374         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1375  
1376         // pull tokens from pancakePair liquidity and move to dead address permanently
1377         if (amountToBurn > 0){
1378             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1379         }
1380  
1381         //sync price since this is not in a swap transaction!
1382         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1383         pair.sync();
1384         emit AutoNukeLP();
1385         return true;
1386     }
1387  
1388     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1389         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1390         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1391         lastManualLpBurnTime = block.timestamp;
1392  
1393         // get balance of liquidity pair
1394         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1395  
1396         // calculate amount to burn
1397         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1398  
1399         // pull tokens from pancakePair liquidity and move to dead address permanently
1400         if (amountToBurn > 0){
1401             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1402         }
1403  
1404         //sync price since this is not in a swap transaction!
1405         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1406         pair.sync();
1407         emit ManualNukeLP();
1408         return true;
1409     }
1410 
1411     function manualSwap() external {
1412         swapping = true;
1413  
1414         swapBack();
1415 
1416         swapping = false;
1417     }
1418 }