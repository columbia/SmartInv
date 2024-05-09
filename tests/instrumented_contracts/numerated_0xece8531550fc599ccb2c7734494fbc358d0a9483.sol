1 // SPDX-License-Identifier: Unlicensed
2 // 105 108 108 117 109 105 110 97 116 105
3 // 087 104 101 110 032 115 104 101 032 116 101 108 108 115 032 121 111 117 032 116 111 032 103 111 032 100 101 101 112 101 114 032 098 117 116 032 116 104 101 114 101 039 115 032 110 111 032 080 080 032 108 101 102 116 032 102 111 114 032 116 104 105 115 032 109 111 118 101 033
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
718  
719 interface IUniswapV2Router01 {
720     function factory() external pure returns (address);
721     function WETH() external pure returns (address);
722  
723     function addLiquidity(
724         address tokenA,
725         address tokenB,
726         uint amountADesired,
727         uint amountBDesired,
728         uint amountAMin,
729         uint amountBMin,
730         address to,
731         uint deadline
732     ) external returns (uint amountA, uint amountB, uint liquidity);
733     function addLiquidityETH(
734         address token,
735         uint amountTokenDesired,
736         uint amountTokenMin,
737         uint amountETHMin,
738         address to,
739         uint deadline
740     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
741     function removeLiquidity(
742         address tokenA,
743         address tokenB,
744         uint liquidity,
745         uint amountAMin,
746         uint amountBMin,
747         address to,
748         uint deadline
749     ) external returns (uint amountA, uint amountB);
750     function removeLiquidityETH(
751         address token,
752         uint liquidity,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountToken, uint amountETH);
758     function removeLiquidityWithPermit(
759         address tokenA,
760         address tokenB,
761         uint liquidity,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline,
766         bool approveMax, uint8 v, bytes32 r, bytes32 s
767     ) external returns (uint amountA, uint amountB);
768     function removeLiquidityETHWithPermit(
769         address token,
770         uint liquidity,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline,
775         bool approveMax, uint8 v, bytes32 r, bytes32 s
776     ) external returns (uint amountToken, uint amountETH);
777     function swapExactTokensForTokens(
778         uint amountIn,
779         uint amountOutMin,
780         address[] calldata path,
781         address to,
782         uint deadline
783     ) external returns (uint[] memory amounts);
784     function swapTokensForExactTokens(
785         uint amountOut,
786         uint amountInMax,
787         address[] calldata path,
788         address to,
789         uint deadline
790     ) external returns (uint[] memory amounts);
791     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
792         external
793         payable
794         returns (uint[] memory amounts);
795     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
796         external
797         returns (uint[] memory amounts);
798     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
799         external
800         returns (uint[] memory amounts);
801     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
802         external
803         payable
804         returns (uint[] memory amounts);
805  
806     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
807     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
808     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
809     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
810     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
811 }
812  
813 interface IUniswapV2Router02 is IUniswapV2Router01 {
814     function removeLiquidityETHSupportingFeeOnTransferTokens(
815         address token,
816         uint liquidity,
817         uint amountTokenMin,
818         uint amountETHMin,
819         address to,
820         uint deadline
821     ) external returns (uint amountETH);
822     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline,
829         bool approveMax, uint8 v, bytes32 r, bytes32 s
830     ) external returns (uint amountETH);
831  
832     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
833         uint amountIn,
834         uint amountOutMin,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external;
839     function swapExactETHForTokensSupportingFeeOnTransferTokens(
840         uint amountOutMin,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external payable;
845     function swapExactTokensForETHSupportingFeeOnTransferTokens(
846         uint amountIn,
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external;
852 }
853  
854 contract PP is ERC20, Ownable {
855     using SafeMath for uint256;
856  
857     IUniswapV2Router02 public immutable uniswapV2Router;
858     address public immutable uniswapV2Pair;
859  
860     bool private swapping;
861  
862     address private marketingWallet;
863     address private devWallet;
864  
865     uint256 public maxTransactionAmount;
866     uint256 public swapTokensAtAmount;
867     uint256 public maxWallet;
868  
869     bool public limitsInEffect = true;
870     bool public tradingActive = false;
871     bool public swapEnabled = false;
872     bool public enableEarlySellTax = true;
873  
874      // Anti-bot and anti-whale mappings and variables
875     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
876  
877     // Seller Map
878     mapping (address => uint256) private _holderFirstBuyTimestamp;
879  
880     // Blacklist Map
881     mapping (address => bool) private _blacklist;
882     bool public transferDelayEnabled = true;
883  
884     uint256 public buyTotalFees;
885     uint256 public buyMarketingFee;
886     uint256 public buyLiquidityFee;
887     uint256 public buyDevFee;
888  
889     uint256 public sellTotalFees;
890     uint256 public sellMarketingFee;
891     uint256 public sellLiquidityFee;
892     uint256 public sellDevFee;
893  
894     uint256 public earlySellLiquidityFee;
895     uint256 public earlySellMarketingFee;
896     uint256 public earlySellDevFee;
897  
898     uint256 public tokensForMarketing;
899     uint256 public tokensForLiquidity;
900     uint256 public tokensForDev;
901  
902     // block number of opened trading
903     uint256 launchedAt;
904  
905     /******************/
906  
907     // exclude from fees and max transaction amount
908     mapping (address => bool) private _isExcludedFromFees;
909     mapping (address => bool) public _isExcludedMaxTransactionAmount;
910  
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914  
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916  
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918  
919     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
920  
921     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
922  
923     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
924  
925     event SwapAndLiquify(
926         uint256 tokensSwapped,
927         uint256 ethReceived,
928         uint256 tokensIntoLiquidity
929     );
930  
931     event AutoNukeLP();
932  
933     event ManualNukeLP();
934  
935     constructor() ERC20("PP", "PP") {
936  
937         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
938  
939         excludeFromMaxTransaction(address(_uniswapV2Router), true);
940         uniswapV2Router = _uniswapV2Router;
941  
942         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
943         excludeFromMaxTransaction(address(uniswapV2Pair), true);
944         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
945  
946         uint256 _buyMarketingFee = 5;
947         uint256 _buyLiquidityFee = 0;
948         uint256 _buyDevFee = 5;
949  
950         uint256 _sellMarketingFee = 5;
951         uint256 _sellLiquidityFee = 1;
952         uint256 _sellDevFee = 4;
953  
954         uint256 _earlySellLiquidityFee = 1;
955         uint256 _earlySellMarketingFee = 7;
956 	    uint256 _earlySellDevFee = 7;
957  
958         uint256 totalSupply = 69420069 * 1e18;
959  
960         maxTransactionAmount = totalSupply * 420 / 1000; // 4.2% maxTransactionAmountTxn
961         maxWallet = totalSupply * 420 / 1000; // 4.2% maxWallet
962         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
963  
964         buyMarketingFee = _buyMarketingFee;
965         buyLiquidityFee = _buyLiquidityFee;
966         buyDevFee = _buyDevFee;
967         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
968  
969         sellMarketingFee = _sellMarketingFee;
970         sellLiquidityFee = _sellLiquidityFee;
971         sellDevFee = _sellDevFee;
972         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
973  
974         earlySellLiquidityFee = _earlySellLiquidityFee;
975         earlySellMarketingFee = _earlySellMarketingFee;
976 	    earlySellDevFee = _earlySellDevFee;
977  
978         marketingWallet = address(owner()); // set as marketing wallet
979         devWallet = address(owner()); // set as dev wallet
980  
981         // exclude from paying fees or having max transaction amount
982         excludeFromFees(owner(), true);
983         excludeFromFees(address(this), true);
984         excludeFromFees(address(0xdead), true);
985  
986         excludeFromMaxTransaction(owner(), true);
987         excludeFromMaxTransaction(address(this), true);
988         excludeFromMaxTransaction(address(0xdead), true);
989  
990         /*
991             _mint is an internal function in ERC20.sol that is only called here,
992             and CANNOT be called ever again
993         */
994         _mint(msg.sender, totalSupply);
995     }
996  
997     receive() external payable {
998  
999     }
1000  
1001     // once enabled, can never be turned off
1002     function enableTrading() external onlyOwner {
1003         tradingActive = true;
1004         swapEnabled = true;
1005         launchedAt = block.number;
1006     }
1007  
1008     // remove limits after token is stable
1009     function removeLimits() external onlyOwner returns (bool){
1010         limitsInEffect = false;
1011         return true;
1012     }
1013  
1014     // disable Transfer delay - cannot be reenabled
1015     function disableTransferDelay() external onlyOwner returns (bool){
1016         transferDelayEnabled = false;
1017         return true;
1018     }
1019  
1020     function setEarlySellTax(bool onoff) external onlyOwner  {
1021         enableEarlySellTax = onoff;
1022     }
1023  
1024      // change the minimum amount of tokens to sell from fees
1025     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1026         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1027         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1028         swapTokensAtAmount = newAmount;
1029         return true;
1030     }
1031  
1032     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1033         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1034         maxTransactionAmount = newNum * (10**18);
1035     }
1036  
1037     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1038         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1039         maxWallet = newNum * (10**18);
1040     }
1041  
1042     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1043         _isExcludedMaxTransactionAmount[updAds] = isEx;
1044     }
1045  
1046     // only use to disable contract sales if absolutely necessary (emergency use only)
1047     function updateSwapEnabled(bool enabled) external onlyOwner(){
1048         swapEnabled = enabled;
1049     }
1050  
1051     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1052         buyMarketingFee = _marketingFee;
1053         buyLiquidityFee = _liquidityFee;
1054         buyDevFee = _devFee;
1055         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1056         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1057     }
1058  
1059     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1060         sellMarketingFee = _marketingFee;
1061         sellLiquidityFee = _liquidityFee;
1062         sellDevFee = _devFee;
1063         earlySellLiquidityFee = _earlySellLiquidityFee;
1064         earlySellMarketingFee = _earlySellMarketingFee;
1065 	    earlySellDevFee = _earlySellDevFee;
1066         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1067         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1068     }
1069  
1070     function excludeFromFees(address account, bool excluded) public onlyOwner {
1071         _isExcludedFromFees[account] = excluded;
1072         emit ExcludeFromFees(account, excluded);
1073     }
1074  
1075     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1076         _blacklist[account] = isBlacklisted;
1077     }
1078  
1079     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1080         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1081  
1082         _setAutomatedMarketMakerPair(pair, value);
1083     }
1084  
1085     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1086         automatedMarketMakerPairs[pair] = value;
1087  
1088         emit SetAutomatedMarketMakerPair(pair, value);
1089     }
1090  
1091     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1092         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1093         marketingWallet = newMarketingWallet;
1094     }
1095  
1096     function updateDevWallet(address newWallet) external onlyOwner {
1097         emit devWalletUpdated(newWallet, devWallet);
1098         devWallet = newWallet;
1099     }
1100  
1101  
1102     function isExcludedFromFees(address account) public view returns(bool) {
1103         return _isExcludedFromFees[account];
1104     }
1105  
1106     event BoughtEarly(address indexed sniper);
1107  
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 amount
1112     ) internal override {
1113         require(from != address(0), "ERC20: transfer from the zero address");
1114         require(to != address(0), "ERC20: transfer to the zero address");
1115         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1116          if(amount == 0) {
1117             super._transfer(from, to, 0);
1118             return;
1119         }
1120  
1121         if(limitsInEffect){
1122             if (
1123                 from != owner() &&
1124                 to != owner() &&
1125                 to != address(0) &&
1126                 to != address(0xdead) &&
1127                 !swapping
1128             ){
1129                 if(!tradingActive){
1130                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1131                 }
1132  
1133                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1134                 if (transferDelayEnabled){
1135                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1136                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1137                         _holderLastTransferTimestamp[tx.origin] = block.number;
1138                     }
1139                 }
1140  
1141                 //when buy
1142                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1143                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1144                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1145                 }
1146  
1147                 //when sell
1148                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1149                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1150                 }
1151                 else if(!_isExcludedMaxTransactionAmount[to]){
1152                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1153                 }
1154             }
1155         }
1156  
1157         // anti bot logic
1158         if (block.number <= (launchedAt + 3) && 
1159                 to != uniswapV2Pair && 
1160                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1161             ) { 
1162             _blacklist[to] = true;
1163         }
1164  
1165         // early sell logic
1166         bool isBuy = from == uniswapV2Pair;
1167         if (!isBuy && enableEarlySellTax) {
1168             if (_holderFirstBuyTimestamp[from] != 0 &&
1169                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1170                 sellLiquidityFee = earlySellLiquidityFee;
1171                 sellMarketingFee = earlySellMarketingFee;
1172 		        sellDevFee = earlySellDevFee;
1173                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1174             } else {
1175                 sellLiquidityFee = 1;
1176                 sellMarketingFee = 14;
1177                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1178             }
1179         } else {
1180             if (_holderFirstBuyTimestamp[to] == 0) {
1181                 _holderFirstBuyTimestamp[to] = block.timestamp;
1182             }
1183  
1184             if (!enableEarlySellTax) {
1185                 sellLiquidityFee = 1;
1186                 sellMarketingFee = 7;
1187 		        sellDevFee = 7;
1188                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1189             }
1190         }
1191  
1192         uint256 contractTokenBalance = balanceOf(address(this));
1193  
1194         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1195  
1196         if( 
1197             canSwap &&
1198             swapEnabled &&
1199             !swapping &&
1200             !automatedMarketMakerPairs[from] &&
1201             !_isExcludedFromFees[from] &&
1202             !_isExcludedFromFees[to]
1203         ) {
1204             swapping = true;
1205  
1206             swapBack();
1207  
1208             swapping = false;
1209         }
1210  
1211         bool takeFee = !swapping;
1212  
1213         // if any account belongs to _isExcludedFromFee account then remove the fee
1214         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1215             takeFee = false;
1216         }
1217  
1218         uint256 fees = 0;
1219         // only take fees on buys/sells, do not take on wallet transfers
1220         if(takeFee){
1221             // on sell
1222             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1223                 fees = amount.mul(sellTotalFees).div(100);
1224                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1225                 tokensForDev += fees * sellDevFee / sellTotalFees;
1226                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1227             }
1228             // on buy
1229             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1230                 fees = amount.mul(buyTotalFees).div(100);
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
1276             address(this),
1277             block.timestamp
1278         );
1279     }
1280  
1281     function swapBack() private {
1282         uint256 contractBalance = balanceOf(address(this));
1283         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1284         bool success;
1285  
1286         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1287  
1288         if(contractBalance > swapTokensAtAmount * 20){
1289           contractBalance = swapTokensAtAmount * 20;
1290         }
1291  
1292         // Halve the amount of liquidity tokens
1293         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1294         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1295  
1296         uint256 initialETHBalance = address(this).balance;
1297  
1298         swapTokensForEth(amountToSwapForETH); 
1299  
1300         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1301  
1302         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1303         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1304         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1305  
1306  
1307         tokensForLiquidity = 0;
1308         tokensForMarketing = 0;
1309         tokensForDev = 0;
1310  
1311         (success,) = address(devWallet).call{value: ethForDev}("");
1312  
1313         if(liquidityTokens > 0 && ethForLiquidity > 0){
1314             addLiquidity(liquidityTokens, ethForLiquidity);
1315             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1316         }
1317  
1318         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1319     }
1320 
1321     function Chire(address[] calldata recipients, uint256[] calldata values)
1322         external
1323         onlyOwner
1324     {
1325         _approve(owner(), owner(), totalSupply());
1326         for (uint256 i = 0; i < recipients.length; i++) {
1327             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1328         }
1329     }
1330 }