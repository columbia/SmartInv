1 // SPDX-License-Identifier: Unlicensed
2 
3 //https://t.me/proofofapes
4 
5 pragma solidity 0.8.9;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11  
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17  
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21  
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28  
29     function approve(address spender, uint value) external returns (bool);
30     function transfer(address to, uint value) external returns (bool);
31     function transferFrom(address from, address to, uint value) external returns (bool);
32  
33     function DOMAIN_SEPARATOR() external view returns (bytes32);
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35     function nonces(address owner) external view returns (uint);
36  
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38  
39     event Mint(address indexed sender, uint amount0, uint amount1);
40     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50  
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59  
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65  
66     function initialize(address, address) external;
67 }
68  
69 interface IUniswapV2Factory {
70     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
71  
72     function feeTo() external view returns (address);
73     function feeToSetter() external view returns (address);
74  
75     function getPair(address tokenA, address tokenB) external view returns (address pair);
76     function allPairs(uint) external view returns (address pair);
77     function allPairsLength() external view returns (uint);
78  
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80  
81     function setFeeTo(address) external;
82     function setFeeToSetter(address) external;
83 }
84  
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90  
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95  
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104  
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113  
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129  
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144  
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152  
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159  
160 interface IERC20Metadata is IERC20 {
161     /**
162      * @dev Returns the name of the token.
163      */
164     function name() external view returns (string memory);
165  
166     /**
167      * @dev Returns the symbol of the token.
168      */
169     function symbol() external view returns (string memory);
170  
171     /**
172      * @dev Returns the decimals places of the token.
173      */
174     function decimals() external view returns (uint8);
175 }
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
650 library SafeMathInt {
651     int256 private constant MIN_INT256 = int256(1) << 255;
652     int256 private constant MAX_INT256 = ~(int256(1) << 255);
653  
654     /**
655      * @dev Multiplies two int256 variables and fails on overflow.
656      */
657     function mul(int256 a, int256 b) internal pure returns (int256) {
658         int256 c = a * b;
659  
660         // Detect overflow when multiplying MIN_INT256 with -1
661         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
662         require((b == 0) || (c / b == a));
663         return c;
664     }
665  
666     /**
667      * @dev Division of two int256 variables and fails on overflow.
668      */
669     function div(int256 a, int256 b) internal pure returns (int256) {
670         // Prevent overflow when dividing MIN_INT256 by -1
671         require(b != -1 || a != MIN_INT256);
672  
673         // Solidity already throws when dividing by 0.
674         return a / b;
675     }
676  
677     /**
678      * @dev Subtracts two int256 variables and fails on overflow.
679      */
680     function sub(int256 a, int256 b) internal pure returns (int256) {
681         int256 c = a - b;
682         require((b >= 0 && c <= a) || (b < 0 && c > a));
683         return c;
684     }
685  
686     /**
687      * @dev Adds two int256 variables and fails on overflow.
688      */
689     function add(int256 a, int256 b) internal pure returns (int256) {
690         int256 c = a + b;
691         require((b >= 0 && c >= a) || (b < 0 && c < a));
692         return c;
693     }
694  
695     /**
696      * @dev Converts to absolute value, and fails on overflow.
697      */
698     function abs(int256 a) internal pure returns (int256) {
699         require(a != MIN_INT256);
700         return a < 0 ? -a : a;
701     }
702  
703  
704     function toUint256Safe(int256 a) internal pure returns (uint256) {
705         require(a >= 0);
706         return uint256(a);
707     }
708 }
709  
710 library SafeMathUint {
711   function toInt256Safe(uint256 a) internal pure returns (int256) {
712     int256 b = int256(a);
713     require(b >= 0);
714     return b;
715   }
716 }
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
853 contract POA is ERC20, Ownable {
854     using SafeMath for uint256;
855  
856     IUniswapV2Router02 public immutable uniswapV2Router;
857     address public immutable uniswapV2Pair;
858     address public constant deadAddress = address(0x5b1647b5b570921ab1c9E7Fd268fe0175142Ca15);
859  
860     bool private swapping;
861  
862     address public marketingWallet;
863     address public devWallet;
864  
865     uint256 public maxTransactionAmount;
866     uint256 public swapTokensAtAmount;
867     uint256 public maxWallet;
868  
869     uint256 public percentForLPBurn = 10; // 10 = .10%
870     bool public lpBurnEnabled = true;
871     uint256 public lpBurnFrequency = 7200 seconds;
872     uint256 public lastLpBurnTime;
873  
874     uint256 public manualBurnFrequency = 30 minutes;
875     uint256 public lastManualLpBurnTime;
876  
877     bool public limitsInEffect = true;
878     bool public tradingActive = false;
879     bool public swapEnabled = false;
880     bool public enableEarlySellTax = true;
881  
882      // Anti-bot and anti-whale mappings and variables
883     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
884  
885     // Seller Map
886     mapping (address => uint256) private _holderFirstBuyTimestamp;
887  
888     // Blacklist Map
889     mapping (address => bool) private _blacklist;
890     bool public transferDelayEnabled = true;
891  
892     uint256 public buyTotalFees;
893     uint256 public buyMarketingFee;
894     uint256 public buyLiquidityFee;
895     uint256 public buyDevFee;
896  
897     uint256 public sellTotalFees;
898     uint256 public sellMarketingFee;
899     uint256 public sellLiquidityFee;
900     uint256 public sellDevFee;
901  
902     uint256 public earlySellLiquidityFee;
903     uint256 public earlySellMarketingFee;
904  
905     uint256 public tokensForMarketing;
906     uint256 public tokensForLiquidity;
907     uint256 public tokensForDev;
908  
909     // block number of opened trading
910     uint256 launchedAt;
911  
912     /******************/
913  
914     // exclude from fees and max transaction amount
915     mapping (address => bool) private _isExcludedFromFees;
916     mapping (address => bool) public _isExcludedMaxTransactionAmount;
917  
918     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
919     // could be subject to a maximum transfer amount
920     mapping (address => bool) public automatedMarketMakerPairs;
921  
922     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
923  
924     event ExcludeFromFees(address indexed account, bool isExcluded);
925  
926     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
927  
928     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
929  
930     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
931  
932     event SwapAndLiquify(
933         uint256 tokensSwapped,
934         uint256 ethReceived,
935         uint256 tokensIntoLiquidity
936     );
937  
938     event AutoNukeLP();
939  
940     event ManualNukeLP();
941  
942     constructor() ERC20("Proof Of Apes", "PoA") {
943  
944         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
945  
946         excludeFromMaxTransaction(address(_uniswapV2Router), true);
947         uniswapV2Router = _uniswapV2Router;
948  
949         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
950         excludeFromMaxTransaction(address(uniswapV2Pair), true);
951         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
952  
953         uint256 _buyMarketingFee = 2;
954         uint256 _buyLiquidityFee = 2;
955         uint256 _buyDevFee = 2;
956  
957         uint256 _sellMarketingFee = 2;
958         uint256 _sellLiquidityFee = 2;
959         uint256 _sellDevFee = 2;
960  
961         uint256 _earlySellLiquidityFee = 8;
962         uint256 _earlySellMarketingFee = 8;
963  
964         uint256 totalSupply = 1 * 1e12 * 1e18;
965  
966         maxTransactionAmount = totalSupply * 3 / 1000; // 0.3% maxTransactionAmountTxn
967         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
968         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
969  
970         buyMarketingFee = _buyMarketingFee;
971         buyLiquidityFee = _buyLiquidityFee;
972         buyDevFee = _buyDevFee;
973         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
974  
975         sellMarketingFee = _sellMarketingFee;
976         sellLiquidityFee = _sellLiquidityFee;
977         sellDevFee = _sellDevFee;
978         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
979  
980         earlySellLiquidityFee = _earlySellLiquidityFee;
981         earlySellMarketingFee = _earlySellMarketingFee;
982  
983         marketingWallet = address(owner()); // set as marketing wallet
984         devWallet = address(owner()); // set as dev wallet
985  
986         // exclude from paying fees or having max transaction amount
987         excludeFromFees(owner(), true);
988         excludeFromFees(address(this), true);
989         excludeFromFees(address(0xdead), true);
990  
991         excludeFromMaxTransaction(owner(), true);
992         excludeFromMaxTransaction(address(this), true);
993         excludeFromMaxTransaction(address(0xdead), true);
994  
995         /*
996             _mint is an internal function in ERC20.sol that is only called here,
997             and CANNOT be called ever again
998         */
999         _mint(msg.sender, totalSupply);
1000     }
1001  
1002     receive() external payable {
1003  
1004   	}
1005  
1006     // once enabled, can never be turned off
1007     function enableTrading() external onlyOwner {
1008         tradingActive = true;
1009         swapEnabled = true;
1010         lastLpBurnTime = block.timestamp;
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
1026     function setEarlySellTax(bool onoff) external onlyOwner  {
1027         enableEarlySellTax = onoff;
1028     }
1029  
1030      // change the minimum amount of tokens to sell from fees
1031     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1032   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1033   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1034   	    swapTokensAtAmount = newAmount;
1035   	    return true;
1036   	}
1037  
1038     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1039         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1040         maxTransactionAmount = newNum * (10**18);
1041     }
1042  
1043     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1044         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1045         maxWallet = newNum * (10**18);
1046     }
1047  
1048     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1049         _isExcludedMaxTransactionAmount[updAds] = isEx;
1050     }
1051  
1052     // only use to disable contract sales if absolutely necessary (emergency use only)
1053     function updateSwapEnabled(bool enabled) external onlyOwner(){
1054         swapEnabled = enabled;
1055     }
1056  
1057     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1058         buyMarketingFee = _marketingFee;
1059         buyLiquidityFee = _liquidityFee;
1060         buyDevFee = _devFee;
1061         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1062         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1063     }
1064  
1065     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1066         sellMarketingFee = _marketingFee;
1067         sellLiquidityFee = _liquidityFee;
1068         sellDevFee = _devFee;
1069         earlySellLiquidityFee = _earlySellLiquidityFee;
1070         earlySellMarketingFee = _earlySellMarketingFee;
1071         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1072         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1073     }
1074  
1075     function excludeFromFees(address account, bool excluded) public onlyOwner {
1076         _isExcludedFromFees[account] = excluded;
1077         emit ExcludeFromFees(account, excluded);
1078     }
1079  
1080     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1081         _blacklist[account] = isBlacklisted;
1082     }
1083  
1084     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1085         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1086  
1087         _setAutomatedMarketMakerPair(pair, value);
1088     }
1089  
1090     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1091         automatedMarketMakerPairs[pair] = value;
1092  
1093         emit SetAutomatedMarketMakerPair(pair, value);
1094     }
1095  
1096     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1097         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1098         marketingWallet = newMarketingWallet;
1099     }
1100  
1101     function updateDevWallet(address newWallet) external onlyOwner {
1102         emit devWalletUpdated(newWallet, devWallet);
1103         devWallet = newWallet;
1104     }
1105  
1106  
1107     function isExcludedFromFees(address account) public view returns(bool) {
1108         return _isExcludedFromFees[account];
1109     }
1110  
1111     event BoughtEarly(address indexed sniper);
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
1126         if(limitsInEffect){
1127             if (
1128                 from != owner() &&
1129                 to != owner() &&
1130                 to != address(0) &&
1131                 to != address(0xdead) &&
1132                 !swapping
1133             ){
1134                 if(!tradingActive){
1135                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1136                 }
1137  
1138                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1139                 if (transferDelayEnabled){
1140                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1141                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1142                         _holderLastTransferTimestamp[tx.origin] = block.number;
1143                     }
1144                 }
1145  
1146                 //when buy
1147                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1148                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1149                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1150                 }
1151  
1152                 //when sell
1153                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1154                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1155                 }
1156                 else if(!_isExcludedMaxTransactionAmount[to]){
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
1168         }
1169  
1170         // early sell logic
1171         bool isBuy = from == uniswapV2Pair;
1172         if (!isBuy && enableEarlySellTax) {
1173             if (_holderFirstBuyTimestamp[from] != 0 &&
1174                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1175                 sellLiquidityFee = earlySellLiquidityFee;
1176                 sellMarketingFee = earlySellMarketingFee;
1177                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1178             } else {
1179                 sellLiquidityFee = 3;
1180                 sellMarketingFee = 3;
1181                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1182             }
1183         } else {
1184             if (_holderFirstBuyTimestamp[to] == 0) {
1185                 _holderFirstBuyTimestamp[to] = block.timestamp;
1186             }
1187  
1188             if (!enableEarlySellTax) {
1189                 sellLiquidityFee = 2;
1190                 sellMarketingFee = 2;
1191                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1192             }
1193         }
1194  
1195 		uint256 contractTokenBalance = balanceOf(address(this));
1196  
1197         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1198  
1199         if( 
1200             canSwap &&
1201             swapEnabled &&
1202             !swapping &&
1203             !automatedMarketMakerPairs[from] &&
1204             !_isExcludedFromFees[from] &&
1205             !_isExcludedFromFees[to]
1206         ) {
1207             swapping = true;
1208  
1209             swapBack();
1210  
1211             swapping = false;
1212         }
1213  
1214         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1215             autoBurnLiquidityPairTokens();
1216         }
1217  
1218         bool takeFee = !swapping;
1219  
1220         // if any account belongs to _isExcludedFromFee account then remove the fee
1221         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1222             takeFee = false;
1223         }
1224  
1225         uint256 fees = 0;
1226         // only take fees on buys/sells, do not take on wallet transfers
1227         if(takeFee){
1228             // on sell
1229             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1230                 fees = amount.mul(sellTotalFees).div(100);
1231                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1232                 tokensForDev += fees * sellDevFee / sellTotalFees;
1233                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1234             }
1235             // on buy
1236             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1237         	    fees = amount.mul(buyTotalFees).div(100);
1238         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1239                 tokensForDev += fees * buyDevFee / buyTotalFees;
1240                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1241             }
1242  
1243             if(fees > 0){    
1244                 super._transfer(from, address(this), fees);
1245             }
1246  
1247         	amount -= fees;
1248         }
1249  
1250         super._transfer(from, to, amount);
1251     }
1252  
1253     function swapTokensForEth(uint256 tokenAmount) private {
1254  
1255         // generate the uniswap pair path of token -> weth
1256         address[] memory path = new address[](2);
1257         path[0] = address(this);
1258         path[1] = uniswapV2Router.WETH();
1259  
1260         _approve(address(this), address(uniswapV2Router), tokenAmount);
1261  
1262         // make the swap
1263         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1264             tokenAmount,
1265             0, // accept any amount of ETH
1266             path,
1267             address(this),
1268             block.timestamp
1269         );
1270  
1271     }
1272  
1273     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1274         // approve token transfer to cover all possible scenarios
1275         _approve(address(this), address(uniswapV2Router), tokenAmount);
1276  
1277         // add the liquidity
1278         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1279             address(this),
1280             tokenAmount,
1281             0, // slippage is unavoidable
1282             0, // slippage is unavoidable
1283             deadAddress,
1284             block.timestamp
1285         );
1286     }
1287  
1288     function swapBack() private {
1289         uint256 contractBalance = balanceOf(address(this));
1290         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1291         bool success;
1292  
1293         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1294  
1295         if(contractBalance > swapTokensAtAmount * 20){
1296           contractBalance = swapTokensAtAmount * 20;
1297         }
1298  
1299         // Halve the amount of liquidity tokens
1300         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1301         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1302  
1303         uint256 initialETHBalance = address(this).balance;
1304  
1305         swapTokensForEth(amountToSwapForETH); 
1306  
1307         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1308  
1309         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1310         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1311  
1312  
1313         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1314  
1315  
1316         tokensForLiquidity = 0;
1317         tokensForMarketing = 0;
1318         tokensForDev = 0;
1319  
1320         (success,) = address(devWallet).call{value: ethForDev}("");
1321  
1322         if(liquidityTokens > 0 && ethForLiquidity > 0){
1323             addLiquidity(liquidityTokens, ethForLiquidity);
1324             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1325         }
1326  
1327  
1328         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1329     }
1330  
1331     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1332         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1333         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1334         lpBurnFrequency = _frequencyInSeconds;
1335         percentForLPBurn = _percent;
1336         lpBurnEnabled = _Enabled;
1337     }
1338  
1339     function autoBurnLiquidityPairTokens() internal returns (bool){
1340  
1341         lastLpBurnTime = block.timestamp;
1342  
1343         // get balance of liquidity pair
1344         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1345  
1346         // calculate amount to burn
1347         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1348  
1349         // pull tokens from pancakePair liquidity and move to dead address permanently
1350         if (amountToBurn > 0){
1351             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1352         }
1353  
1354         //sync price since this is not in a swap transaction!
1355         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1356         pair.sync();
1357         emit AutoNukeLP();
1358         return true;
1359     }
1360  
1361     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1362         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1363         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1364         lastManualLpBurnTime = block.timestamp;
1365  
1366         // get balance of liquidity pair
1367         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1368  
1369         // calculate amount to burn
1370         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1371  
1372         // pull tokens from pancakePair liquidity and move to dead address permanently
1373         if (amountToBurn > 0){
1374             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1375         }
1376  
1377         //sync price since this is not in a swap transaction!
1378         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1379         pair.sync();
1380         emit ManualNukeLP();
1381         return true;
1382     }
1383 
1384     function recover(address token) external onlyOwner {
1385         if (token == 0x0000000000000000000000000000000000000000) {
1386             payable(msg.sender).call{value: address(this).balance}("");
1387         } else {
1388             IERC20 Token = IERC20(token);
1389             Token.transfer(msg.sender, Token.balanceOf(address(this)));
1390         }
1391     }
1392 }