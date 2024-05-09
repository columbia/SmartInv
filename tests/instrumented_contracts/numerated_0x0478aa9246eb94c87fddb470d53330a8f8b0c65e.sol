1 // SPDX-License-Identifier: Unlicensed
2 //https://antisinu.io/
3 
4 pragma solidity 0.8.9;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10  
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16  
17 interface IUniswapV2Pair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20  
21     function name() external pure returns (string memory);
22     function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27  
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31  
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint);
35  
36     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
37  
38     event Mint(address indexed sender, uint amount0, uint amount1);
39     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
40     event Swap(
41         address indexed sender,
42         uint amount0In,
43         uint amount1In,
44         uint amount0Out,
45         uint amount1Out,
46         address indexed to
47     );
48     event Sync(uint112 reserve0, uint112 reserve1);
49  
50     function MINIMUM_LIQUIDITY() external pure returns (uint);
51     function factory() external view returns (address);
52     function token0() external view returns (address);
53     function token1() external view returns (address);
54     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
55     function price0CumulativeLast() external view returns (uint);
56     function price1CumulativeLast() external view returns (uint);
57     function kLast() external view returns (uint);
58  
59     function mint(address to) external returns (uint liquidity);
60     function burn(address to) external returns (uint amount0, uint amount1);
61     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
62     function skim(address to) external;
63     function sync() external;
64  
65     function initialize(address, address) external;
66 }
67  
68 interface IUniswapV2Factory {
69     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
70  
71     function feeTo() external view returns (address);
72     function feeToSetter() external view returns (address);
73  
74     function getPair(address tokenA, address tokenB) external view returns (address pair);
75     function allPairs(uint) external view returns (address pair);
76     function allPairsLength() external view returns (uint);
77  
78     function createPair(address tokenA, address tokenB) external returns (address pair);
79  
80     function setFeeTo(address) external;
81     function setFeeToSetter(address) external;
82 }
83  
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89  
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94  
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(address recipient, uint256 amount) external returns (bool);
103  
104     /**
105      * @dev Returns the remaining number of tokens that `spender` will be
106      * allowed to spend on behalf of `owner` through {transferFrom}. This is
107      * zero by default.
108      *
109      * This value changes when {approve} or {transferFrom} are called.
110      */
111     function allowance(address owner, address spender) external view returns (uint256);
112  
113     /**
114      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * IMPORTANT: Beware that changing an allowance with this method brings the risk
119      * that someone may use both the old and the new allowance by unfortunate
120      * transaction ordering. One possible solution to mitigate this race
121      * condition is to first reduce the spender's allowance to 0 and set the
122      * desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address spender, uint256 amount) external returns (bool);
128  
129     /**
130      * @dev Moves `amount` tokens from `sender` to `recipient` using the
131      * allowance mechanism. `amount` is then deducted from the caller's
132      * allowance.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address sender,
140         address recipient,
141         uint256 amount
142     ) external returns (bool);
143  
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151  
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158  
159 interface IERC20Metadata is IERC20 {
160     /**
161      * @dev Returns the name of the token.
162      */
163     function name() external view returns (string memory);
164  
165     /**
166      * @dev Returns the symbol of the token.
167      */
168     function symbol() external view returns (string memory);
169  
170     /**
171      * @dev Returns the decimals places of the token.
172      */
173     function decimals() external view returns (uint8);
174 }
175  
176  
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     using SafeMath for uint256;
179  
180     mapping(address => uint256) private _balances;
181  
182     mapping(address => mapping(address => uint256)) private _allowances;
183  
184     uint256 private _totalSupply;
185  
186     string private _name;
187     string private _symbol;
188  
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202  
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209  
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217  
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234  
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241  
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248  
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `recipient` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261  
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268  
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      */
276     function approve(address spender, uint256 amount) public virtual override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280  
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * Requirements:
288      *
289      * - `sender` and `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``sender``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         _transfer(sender, recipient, amount);
300         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
301         return true;
302     }
303  
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
318         return true;
319     }
320  
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
337         return true;
338     }
339  
340     /**
341      * @dev Moves tokens `amount` from `sender` to `recipient`.
342      *
343      * This is internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      */
354     function _transfer(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361  
362         _beforeTokenTransfer(sender, recipient, amount);
363  
364         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
365         _balances[recipient] = _balances[recipient].add(amount);
366         emit Transfer(sender, recipient, amount);
367     }
368  
369     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
370      * the total supply.
371      *
372      * Emits a {Transfer} event with `from` set to the zero address.
373      *
374      * Requirements:
375      *
376      * - `account` cannot be the zero address.
377      */
378     function _mint(address account, uint256 amount) internal virtual {
379         require(account != address(0), "ERC20: mint to the zero address");
380  
381         _beforeTokenTransfer(address(0), account, amount);
382  
383         _totalSupply = _totalSupply.add(amount);
384         _balances[account] = _balances[account].add(amount);
385         emit Transfer(address(0), account, amount);
386     }
387  
388     /**
389      * @dev Destroys `amount` tokens from `account`, reducing the
390      * total supply.
391      *
392      * Emits a {Transfer} event with `to` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      * - `account` must have at least `amount` tokens.
398      */
399     function _burn(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: burn from the zero address");
401  
402         _beforeTokenTransfer(account, address(0), amount);
403  
404         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
405         _totalSupply = _totalSupply.sub(amount);
406         emit Transfer(account, address(0), amount);
407     }
408  
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
411      *
412      * This internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an {Approval} event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(
423         address owner,
424         address spender,
425         uint256 amount
426     ) internal virtual {
427         require(owner != address(0), "ERC20: approve from the zero address");
428         require(spender != address(0), "ERC20: approve to the zero address");
429  
430         _allowances[owner][spender] = amount;
431         emit Approval(owner, spender, amount);
432     }
433  
434     /**
435      * @dev Hook that is called before any transfer of tokens. This includes
436      * minting and burning.
437      *
438      * Calling conditions:
439      *
440      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
441      * will be to transferred to `to`.
442      * - when `from` is zero, `amount` tokens will be minted for `to`.
443      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
444      * - `from` and `to` are never both zero.
445      *
446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
447      */
448     function _beforeTokenTransfer(
449         address from,
450         address to,
451         uint256 amount
452     ) internal virtual {}
453 }
454  
455 library SafeMath {
456     /**
457      * @dev Returns the addition of two unsigned integers, reverting on
458      * overflow.
459      *
460      * Counterpart to Solidity's `+` operator.
461      *
462      * Requirements:
463      *
464      * - Addition cannot overflow.
465      */
466     function add(uint256 a, uint256 b) internal pure returns (uint256) {
467         uint256 c = a + b;
468         require(c >= a, "SafeMath: addition overflow");
469  
470         return c;
471     }
472  
473     /**
474      * @dev Returns the subtraction of two unsigned integers, reverting on
475      * overflow (when the result is negative).
476      *
477      * Counterpart to Solidity's `-` operator.
478      *
479      * Requirements:
480      *
481      * - Subtraction cannot overflow.
482      */
483     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
484         return sub(a, b, "SafeMath: subtraction overflow");
485     }
486  
487     /**
488      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
489      * overflow (when the result is negative).
490      *
491      * Counterpart to Solidity's `-` operator.
492      *
493      * Requirements:
494      *
495      * - Subtraction cannot overflow.
496      */
497     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
498         require(b <= a, errorMessage);
499         uint256 c = a - b;
500  
501         return c;
502     }
503  
504     /**
505      * @dev Returns the multiplication of two unsigned integers, reverting on
506      * overflow.
507      *
508      * Counterpart to Solidity's `*` operator.
509      *
510      * Requirements:
511      *
512      * - Multiplication cannot overflow.
513      */
514     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
515         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
516         // benefit is lost if 'b' is also tested.
517         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
518         if (a == 0) {
519             return 0;
520         }
521  
522         uint256 c = a * b;
523         require(c / a == b, "SafeMath: multiplication overflow");
524  
525         return c;
526     }
527  
528     /**
529      * @dev Returns the integer division of two unsigned integers. Reverts on
530      * division by zero. The result is rounded towards zero.
531      *
532      * Counterpart to Solidity's `/` operator. Note: this function uses a
533      * `revert` opcode (which leaves remaining gas untouched) while Solidity
534      * uses an invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function div(uint256 a, uint256 b) internal pure returns (uint256) {
541         return div(a, b, "SafeMath: division by zero");
542     }
543  
544     /**
545      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
546      * division by zero. The result is rounded towards zero.
547      *
548      * Counterpart to Solidity's `/` operator. Note: this function uses a
549      * `revert` opcode (which leaves remaining gas untouched) while Solidity
550      * uses an invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b > 0, errorMessage);
558         uint256 c = a / b;
559         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
560  
561         return c;
562     }
563  
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * Reverts when dividing by zero.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
577         return mod(a, b, "SafeMath: modulo by zero");
578     }
579  
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
582      * Reverts with custom message when dividing by zero.
583      *
584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
585      * opcode (which leaves remaining gas untouched) while Solidity uses an
586      * invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
593         require(b != 0, errorMessage);
594         return a % b;
595     }
596 }
597  
598 contract Ownable is Context {
599     address private _owner;
600  
601     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
602  
603     /**
604      * @dev Initializes the contract setting the deployer as the initial owner.
605      */
606     constructor () {
607         address msgSender = _msgSender();
608         _owner = msgSender;
609         emit OwnershipTransferred(address(0), msgSender);
610     }
611  
612     /**
613      * @dev Returns the address of the current owner.
614      */
615     function owner() public view returns (address) {
616         return _owner;
617     }
618  
619     /**
620      * @dev Throws if called by any account other than the owner.
621      */
622     modifier onlyOwner() {
623         require(_owner == _msgSender(), "Ownable: caller is not the owner");
624         _;
625     }
626  
627     /**
628      * @dev Leaves the contract without owner. It will not be possible to call
629      * `onlyOwner` functions anymore. Can only be called by the current owner.
630      *
631      * NOTE: Renouncing ownership will leave the contract without an owner,
632      * thereby removing any functionality that is only available to the owner.
633      */
634     function renounceOwnership() public virtual onlyOwner {
635         emit OwnershipTransferred(_owner, address(0));
636         _owner = address(0);
637     }
638  
639     /**
640      * @dev Transfers ownership of the contract to a new account (`newOwner`).
641      * Can only be called by the current owner.
642      */
643     function transferOwnership(address newOwner) public virtual onlyOwner {
644         require(newOwner != address(0), "Ownable: new owner is the zero address");
645         emit OwnershipTransferred(_owner, newOwner);
646         _owner = newOwner;
647     }
648 }
649  
650  
651  
652 library SafeMathInt {
653     int256 private constant MIN_INT256 = int256(1) << 255;
654     int256 private constant MAX_INT256 = ~(int256(1) << 255);
655  
656     /**
657      * @dev Multiplies two int256 variables and fails on overflow.
658      */
659     function mul(int256 a, int256 b) internal pure returns (int256) {
660         int256 c = a * b;
661  
662         // Detect overflow when multiplying MIN_INT256 with -1
663         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
664         require((b == 0) || (c / b == a));
665         return c;
666     }
667  
668     /**
669      * @dev Division of two int256 variables and fails on overflow.
670      */
671     function div(int256 a, int256 b) internal pure returns (int256) {
672         // Prevent overflow when dividing MIN_INT256 by -1
673         require(b != -1 || a != MIN_INT256);
674  
675         // Solidity already throws when dividing by 0.
676         return a / b;
677     }
678  
679     /**
680      * @dev Subtracts two int256 variables and fails on overflow.
681      */
682     function sub(int256 a, int256 b) internal pure returns (int256) {
683         int256 c = a - b;
684         require((b >= 0 && c <= a) || (b < 0 && c > a));
685         return c;
686     }
687  
688     /**
689      * @dev Adds two int256 variables and fails on overflow.
690      */
691     function add(int256 a, int256 b) internal pure returns (int256) {
692         int256 c = a + b;
693         require((b >= 0 && c >= a) || (b < 0 && c < a));
694         return c;
695     }
696  
697     /**
698      * @dev Converts to absolute value, and fails on overflow.
699      */
700     function abs(int256 a) internal pure returns (int256) {
701         require(a != MIN_INT256);
702         return a < 0 ? -a : a;
703     }
704  
705  
706     function toUint256Safe(int256 a) internal pure returns (uint256) {
707         require(a >= 0);
708         return uint256(a);
709     }
710 }
711  
712 library SafeMathUint {
713   function toInt256Safe(uint256 a) internal pure returns (int256) {
714     int256 b = int256(a);
715     require(b >= 0);
716     return b;
717   }
718 }
719  
720  
721 interface IUniswapV2Router01 {
722     function factory() external pure returns (address);
723     function WETH() external pure returns (address);
724  
725     function addLiquidity(
726         address tokenA,
727         address tokenB,
728         uint amountADesired,
729         uint amountBDesired,
730         uint amountAMin,
731         uint amountBMin,
732         address to,
733         uint deadline
734     ) external returns (uint amountA, uint amountB, uint liquidity);
735     function addLiquidityETH(
736         address token,
737         uint amountTokenDesired,
738         uint amountTokenMin,
739         uint amountETHMin,
740         address to,
741         uint deadline
742     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
743     function removeLiquidity(
744         address tokenA,
745         address tokenB,
746         uint liquidity,
747         uint amountAMin,
748         uint amountBMin,
749         address to,
750         uint deadline
751     ) external returns (uint amountA, uint amountB);
752     function removeLiquidityETH(
753         address token,
754         uint liquidity,
755         uint amountTokenMin,
756         uint amountETHMin,
757         address to,
758         uint deadline
759     ) external returns (uint amountToken, uint amountETH);
760     function removeLiquidityWithPermit(
761         address tokenA,
762         address tokenB,
763         uint liquidity,
764         uint amountAMin,
765         uint amountBMin,
766         address to,
767         uint deadline,
768         bool approveMax, uint8 v, bytes32 r, bytes32 s
769     ) external returns (uint amountA, uint amountB);
770     function removeLiquidityETHWithPermit(
771         address token,
772         uint liquidity,
773         uint amountTokenMin,
774         uint amountETHMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountToken, uint amountETH);
779     function swapExactTokensForTokens(
780         uint amountIn,
781         uint amountOutMin,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external returns (uint[] memory amounts);
786     function swapTokensForExactTokens(
787         uint amountOut,
788         uint amountInMax,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external returns (uint[] memory amounts);
793     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
794         external
795         payable
796         returns (uint[] memory amounts);
797     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
798         external
799         returns (uint[] memory amounts);
800     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
804         external
805         payable
806         returns (uint[] memory amounts);
807  
808     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
809     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
810     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
811     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
812     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
813 }
814  
815 interface IUniswapV2Router02 is IUniswapV2Router01 {
816     function removeLiquidityETHSupportingFeeOnTransferTokens(
817         address token,
818         uint liquidity,
819         uint amountTokenMin,
820         uint amountETHMin,
821         address to,
822         uint deadline
823     ) external returns (uint amountETH);
824     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
825         address token,
826         uint liquidity,
827         uint amountTokenMin,
828         uint amountETHMin,
829         address to,
830         uint deadline,
831         bool approveMax, uint8 v, bytes32 r, bytes32 s
832     ) external returns (uint amountETH);
833  
834     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
835         uint amountIn,
836         uint amountOutMin,
837         address[] calldata path,
838         address to,
839         uint deadline
840     ) external;
841     function swapExactETHForTokensSupportingFeeOnTransferTokens(
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external payable;
847     function swapExactTokensForETHSupportingFeeOnTransferTokens(
848         uint amountIn,
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external;
854 }
855  
856 contract AI is ERC20, Ownable {
857     using SafeMath for uint256;
858  
859     IUniswapV2Router02 public immutable uniswapV2Router;
860     address public immutable uniswapV2Pair;
861     address public constant devAddress = address(0x6c74E5F2035E0B8F8e50DE6c63C70c343A8468d5);
862  
863     bool private swapping;
864  
865     address public marketingWallet;
866  
867     uint256 public maxTransactionAmount;
868     uint256 public swapTokensAtAmount;
869     uint256 public maxWallet;
870  
871     bool public limitsInEffect = true;
872     bool public tradingActive = false;
873     bool public swapEnabled = false;
874     bool public enableEarlySellTax = true;
875  
876      // Anti-bot and anti-whale mappings and variables
877     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
878  
879     // Seller Map
880     mapping (address => uint256) private _holderFirstBuyTimestamp;
881  
882     // Blacklist Map
883     mapping (address => bool) private _blacklist;
884     bool public transferDelayEnabled = true;
885  
886     uint256 public buyTotalFees;
887     uint256 public buyMarketingFee;
888  
889     uint256 public sellTotalFees;
890     uint256 public sellMarketingFee;
891  
892     uint256 public earlySellMarketingFee;
893  
894     uint256 public tokensForMarketing;
895  
896     // block number of opened trading
897     uint256 launchedAt;
898  
899     /******************/
900  
901     // exclude from fees and max transaction amount
902     mapping (address => bool) private _isExcludedFromFees;
903     mapping (address => bool) public _isExcludedMaxTransactionAmount;
904  
905     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
906     // could be subject to a maximum transfer amount
907     mapping (address => bool) public automatedMarketMakerPairs;
908  
909     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
910  
911     event ExcludeFromFees(address indexed account, bool isExcluded);
912  
913     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
914  
915     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
916  
917     constructor() ERC20("Antis Inu", "AI") {
918  
919         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
920  
921         excludeFromMaxTransaction(address(_uniswapV2Router), true);
922         uniswapV2Router = _uniswapV2Router;
923  
924         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
925         excludeFromMaxTransaction(address(uniswapV2Pair), true);
926         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
927  
928         uint256 _buyMarketingFee = 2;
929  
930         uint256 _sellMarketingFee = 2;
931  
932         uint256 _earlySellMarketingFee = 10;
933  
934         uint256 totalSupply = 420000000000 * 1e18;
935  
936         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
937         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
938         swapTokensAtAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
939  
940         buyMarketingFee = _buyMarketingFee;
941         buyTotalFees = buyMarketingFee;
942  
943         sellMarketingFee = _sellMarketingFee;
944         sellTotalFees = sellMarketingFee;
945  
946         earlySellMarketingFee = _earlySellMarketingFee;
947  
948         marketingWallet = address(owner()); // set as marketing wallet
949  
950         // exclude from paying fees or having max transaction amount
951         excludeFromFees(owner(), true);
952         excludeFromFees(address(this), true);
953         excludeFromFees(address(0xdead), true);
954  
955         excludeFromMaxTransaction(owner(), true);
956         excludeFromMaxTransaction(address(this), true);
957         excludeFromMaxTransaction(address(0xdead), true);
958  
959         /*
960             _mint is an internal function in ERC20.sol that is only called here,
961             and CANNOT be called ever again
962         */
963         _mint(msg.sender, totalSupply);
964     }
965  
966     receive() external payable {
967  
968   	}
969  
970     // once enabled, can never be turned off
971     function enableTrading() external onlyOwner {
972         tradingActive = true;
973         swapEnabled = true;
974         launchedAt = block.number;
975     }
976  
977     // remove limits after token is stable
978     function removeLimits() external onlyOwner returns (bool){
979         limitsInEffect = false;
980         return true;
981     }
982  
983     // disable Transfer delay - cannot be reenabled
984     function disableTransferDelay() external onlyOwner returns (bool){
985         transferDelayEnabled = false;
986         return true;
987     }
988  
989     function setEarlySellTax(bool onoff) external onlyOwner  {
990         enableEarlySellTax = onoff;
991     }
992  
993      // change the minimum amount of tokens to sell from fees
994     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
995   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
996   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
997   	    swapTokensAtAmount = newAmount;
998   	    return true;
999   	}
1000  
1001     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1002         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1003         maxTransactionAmount = newNum * (10**18);
1004     }
1005  
1006     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1007         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1008         maxWallet = newNum * (10**18);
1009     }
1010  
1011     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1012         _isExcludedMaxTransactionAmount[updAds] = isEx;
1013     }
1014  
1015     // only use to disable contract sales if absolutely necessary (emergency use only)
1016     function updateSwapEnabled(bool enabled) external onlyOwner(){
1017         swapEnabled = enabled;
1018     }
1019  
1020     function updateBuyFees(uint256 _marketingFee) external onlyOwner {
1021         buyMarketingFee = _marketingFee;
1022         buyTotalFees = buyMarketingFee;
1023         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
1024     }
1025  
1026     function updateSellFees(uint256 _marketingFee, uint256 _earlySellMarketingFee) external onlyOwner {
1027         sellMarketingFee = _marketingFee;
1028         earlySellMarketingFee = _earlySellMarketingFee;
1029         sellTotalFees = sellMarketingFee;
1030         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
1031     }
1032  
1033     function excludeFromFees(address account, bool excluded) public onlyOwner {
1034         _isExcludedFromFees[account] = excluded;
1035         emit ExcludeFromFees(account, excluded);
1036     }
1037  
1038     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1039         _blacklist[account] = isBlacklisted;
1040     }
1041  
1042     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1043         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1044  
1045         _setAutomatedMarketMakerPair(pair, value);
1046     }
1047  
1048     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1049         automatedMarketMakerPairs[pair] = value;
1050  
1051         emit SetAutomatedMarketMakerPair(pair, value);
1052     }
1053  
1054     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1055         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1056         marketingWallet = newMarketingWallet;
1057     } 
1058  
1059     function isExcludedFromFees(address account) public view returns(bool) {
1060         return _isExcludedFromFees[account];
1061     }
1062  
1063     event BoughtEarly(address indexed sniper);
1064  
1065     function _transfer(
1066         address from,
1067         address to,
1068         uint256 amount
1069     ) internal override {
1070         require(from != address(0), "ERC20: transfer from the zero address");
1071         require(to != address(0), "ERC20: transfer to the zero address");
1072         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1073          if(amount == 0) {
1074             super._transfer(from, to, 0);
1075             return;
1076         }
1077  
1078         if(limitsInEffect){
1079             if (
1080                 from != owner() &&
1081                 to != owner() &&
1082                 to != address(0) &&
1083                 to != address(0xdead) &&
1084                 !swapping
1085             ){
1086                 if(!tradingActive){
1087                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1088                 }
1089  
1090                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1091                 if (transferDelayEnabled){
1092                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1093                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1094                         _holderLastTransferTimestamp[tx.origin] = block.number;
1095                     }
1096                 }
1097  
1098                 //when buy
1099                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1100                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1101                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1102                 }
1103  
1104                 //when sell
1105                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1106                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1107                 }
1108                 else if(!_isExcludedMaxTransactionAmount[to]){
1109                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1110                 }
1111             }
1112         }
1113  
1114         // anti bot logic
1115         if (block.number <= (launchedAt + 1) && 
1116                 to != uniswapV2Pair && 
1117                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1118             ) { 
1119             _blacklist[to] = true;
1120         }
1121  
1122         // early sell logic
1123         bool isBuy = from == uniswapV2Pair;
1124         if (!isBuy && enableEarlySellTax) {
1125             if (_holderFirstBuyTimestamp[from] != 0 &&
1126                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1127                 sellMarketingFee = earlySellMarketingFee;
1128                 sellTotalFees = sellMarketingFee;
1129             } else {
1130                 sellMarketingFee = 10;
1131                 sellTotalFees = sellMarketingFee;
1132             }
1133         } else {
1134             if (_holderFirstBuyTimestamp[to] == 0) {
1135                 _holderFirstBuyTimestamp[to] = block.timestamp;
1136             }
1137  
1138             if (!enableEarlySellTax) {
1139                 sellMarketingFee = 2;
1140                 sellTotalFees = sellMarketingFee;
1141             }
1142         }
1143  
1144 		uint256 contractTokenBalance = balanceOf(address(this));
1145  
1146         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1147 		
1148 		bool takeFee = !swapping;
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
1160                 fees = amount.mul(sellTotalFees).div(100);
1161                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1162             }
1163             // on buy
1164             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1165         	    fees = amount.mul(buyTotalFees).div(100);
1166                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1167             }
1168  
1169             if(fees > 0){    
1170                 super._transfer(from, address(this), fees);
1171             }
1172  
1173         	amount -= fees;
1174         }
1175 		
1176         if( 
1177             canSwap &&
1178             swapEnabled &&
1179             !swapping &&
1180             !automatedMarketMakerPairs[from] &&
1181             !_isExcludedFromFees[from] &&
1182             !_isExcludedFromFees[to]
1183         ) {
1184             swapping = true;
1185  
1186             swapBack();
1187  
1188             swapping = false;
1189         }
1190  
1191         super._transfer(from, to, amount);
1192     }
1193  
1194     function swapTokensForEth(uint256 tokenAmount) private {
1195  
1196         // generate the uniswap pair path of token -> weth
1197         address[] memory path = new address[](2);
1198         path[0] = address(this);
1199         path[1] = uniswapV2Router.WETH();
1200  
1201         _approve(address(this), address(uniswapV2Router), tokenAmount);
1202  
1203         // make the swap
1204         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1205             tokenAmount,
1206             0, // accept any amount of ETH
1207             path,
1208             address(this),
1209             block.timestamp
1210         );
1211  
1212     }
1213   
1214     function swapBack() private {
1215         uint256 contractBalance = balanceOf(address(this));
1216         bool success;
1217  
1218         if(contractBalance == 0) {return;}
1219  
1220         if(contractBalance > swapTokensAtAmount * 20){
1221           contractBalance = swapTokensAtAmount * 20;
1222         }
1223  
1224         uint256 amountToSwapForETH = contractBalance;
1225         swapTokensForEth(amountToSwapForETH); 
1226  
1227      
1228         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1229     }
1230 
1231 }