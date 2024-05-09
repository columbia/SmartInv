1 // SPDX-License-Identifier: MIT              
2 
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
120      * transacgtion ordering. One possible solution to mitigate this race
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
856 contract TSUKA is ERC20, Ownable {
857     using SafeMath for uint256;
858 
859     IUniswapV2Router02 public immutable uniswapV2Router;
860     address public immutable uniswapV2Pair;
861     address public constant deadAddress = address(0xdead);
862 
863     bool private swapping;
864 
865     address public marketingWallet;
866     address public devWallet;
867     
868     uint256 public maxTransactionAmount;
869     uint256 public swapTokensAtAmount;
870     uint256 public maxWallet;
871     
872     uint256 public percentForLPBurn = 25; // 25 = .25%
873     bool public lpBurnEnabled = true;
874     uint256 public lpBurnFrequency = 3600 seconds;
875     uint256 public lastLpBurnTime;
876     
877     uint256 public manualBurnFrequency = 30 minutes;
878     uint256 public lastManualLpBurnTime;
879 
880     bool public limitsInEffect = true;
881     bool public tradingActive = false;
882     bool public swapEnabled = false;
883     
884      // Anti-bot and anti-whale mappings and variables
885     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
886     bool public transferDelayEnabled = true;
887 
888     uint256 public buyTotalFees;
889     uint256 public buyMarketingFee;
890     uint256 public buyLiquidityFee;
891     uint256 public buyDevFee;
892     
893     uint256 public sellTotalFees;
894     uint256 public sellMarketingFee;
895     uint256 public sellLiquidityFee;
896     uint256 public sellDevFee;
897     
898     uint256 public tokensForMarketing;
899     uint256 public tokensForLiquidity;
900     uint256 public tokensForDev;
901     
902     /******************/
903 
904     // exlcude from fees and max transaction amount
905     mapping (address => bool) private _isExcludedFromFees;
906     mapping (address => bool) public _isExcludedMaxTransactionAmount;
907 
908     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
909     // could be subject to a maximum transfer amount
910     mapping (address => bool) public automatedMarketMakerPairs;
911 
912     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
913 
914     event ExcludeFromFees(address indexed account, bool isExcluded);
915 
916     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
917 
918     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
919     
920     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
921 
922     event SwapAndLiquify(
923         uint256 tokensSwapped,
924         uint256 ethReceived,
925         uint256 tokensIntoLiquidity
926     );
927     
928     event AutoNukeLP();
929     
930     event ManualNukeLP();
931 
932     constructor() ERC20("Dejitaru Tsuka 2.0", "TSUKA 2.0") {
933         
934         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
935         
936         excludeFromMaxTransaction(address(_uniswapV2Router), true);
937         uniswapV2Router = _uniswapV2Router;
938         
939         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
940         excludeFromMaxTransaction(address(uniswapV2Pair), true);
941         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
942         
943         uint256 _buyMarketingFee = 0;
944         uint256 _buyLiquidityFee = 0;
945         uint256 _buyDevFee = 5;
946 
947         uint256 _sellMarketingFee = 0;
948         uint256 _sellLiquidityFee = 0;
949         uint256 _sellDevFee = 99;
950         
951         uint256 totalSupply = 1 * 1e12 * 1e18;
952         
953         //maxTransactionAmount = totalSupply * 50 / 1000; // 1.50% maxTransactionAmountTxn
954         maxTransactionAmount = 15000000000 * 1e18;
955         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
956         swapTokensAtAmount = totalSupply * 15 / 10000; // 0.15% swap wallet
957 
958         buyMarketingFee = _buyMarketingFee;
959         buyLiquidityFee = _buyLiquidityFee;
960         buyDevFee = _buyDevFee;
961         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
962         
963         sellMarketingFee = _sellMarketingFee;
964         sellLiquidityFee = _sellLiquidityFee;
965         sellDevFee = _sellDevFee;
966         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
967         
968         marketingWallet = address(owner()); // set as marketing wallet
969         devWallet = address(owner()); // set as dev wallet
970 
971         // exclude from paying fees or having max transaction amount
972         excludeFromFees(owner(), true);
973         excludeFromFees(address(this), true);
974         excludeFromFees(address(0xdead), true);
975         
976         excludeFromMaxTransaction(owner(), true);
977         excludeFromMaxTransaction(address(this), true);
978         excludeFromMaxTransaction(address(0xdead), true);
979         
980         /*
981             _mint is an internal function in ERC20.sol that is only called here,
982             and CANNOT be called ever again
983         */
984         _mint(msg.sender, totalSupply);
985     }
986 
987     receive() external payable {
988 
989   	}
990 
991     // once enabled, can never be turned off
992     function ReadySetGo() external onlyOwner {
993         tradingActive = true;
994         swapEnabled = true;
995         lastLpBurnTime = block.timestamp;
996     }
997     
998     // remove limits after token is stable
999     function removeLimitsNow() external onlyOwner returns (bool){
1000         limitsInEffect = false;
1001         return true;
1002     }
1003     
1004     // disable Transfer delay - cannot be reenabled
1005     function disableTransferDelay() external onlyOwner returns (bool){
1006         transferDelayEnabled = false;
1007         return true;
1008     }
1009     
1010      // change the minimum amount of tokens to sell from fees
1011     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1012   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1013   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1014   	    swapTokensAtAmount = newAmount;
1015   	    return true;
1016   	}
1017     
1018     function updateMaxTransactAmount(uint256 newNum) external onlyOwner {
1019         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1020         maxTransactionAmount = newNum * (10**18);
1021     }
1022 
1023     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1024         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1025         maxWallet = newNum * (10**18);
1026     }
1027     
1028     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1029         _isExcludedMaxTransactionAmount[updAds] = isEx;
1030     }
1031     
1032     // only use to disable contract sales if absolutely necessary (emergency use only)
1033     function updateSwapEnabled(bool enabled) external onlyOwner(){
1034         swapEnabled = enabled;
1035     }
1036     
1037     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1038         buyMarketingFee = _marketingFee;
1039         buyLiquidityFee = _liquidityFee;
1040         buyDevFee = _devFee;
1041         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1042         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1043     }
1044     
1045     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1046         sellMarketingFee = _marketingFee;
1047         sellLiquidityFee = _liquidityFee;
1048         sellDevFee = _devFee;
1049         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1050         require(sellTotalFees <= 100, "Must keep fees at 25% or less");
1051     }
1052 
1053     function excludeFromFees(address account, bool excluded) public onlyOwner {
1054         _isExcludedFromFees[account] = excluded;
1055         emit ExcludeFromFees(account, excluded);
1056     }
1057 
1058     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1059         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1060 
1061         _setAutomatedMarketMakerPair(pair, value);
1062     }
1063 
1064     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1065         automatedMarketMakerPairs[pair] = value;
1066 
1067         emit SetAutomatedMarketMakerPair(pair, value);
1068     }
1069 
1070     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1071         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1072         marketingWallet = newMarketingWallet;
1073     }
1074     
1075     function updateDevWallet(address newWallet) external onlyOwner {
1076         emit devWalletUpdated(newWallet, devWallet);
1077         devWallet = newWallet;
1078     }
1079     
1080 
1081     function isExcludedFromFees(address account) public view returns(bool) {
1082         return _isExcludedFromFees[account];
1083     }
1084     
1085     event BoughtEarly(address indexed sniper);
1086 
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 amount
1091     ) internal override {
1092         require(from != address(0), "ERC20: transfer from the zero address");
1093         require(to != address(0), "ERC20: transfer to the zero address");
1094         
1095          if(amount == 0) {
1096             super._transfer(from, to, 0);
1097             return;
1098         }
1099         
1100         if(limitsInEffect){
1101             if (
1102                 from != owner() &&
1103                 to != owner() &&
1104                 to != address(0) &&
1105                 to != address(0xdead) &&
1106                 !swapping
1107             ){
1108                 if(!tradingActive){
1109                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1110                 }
1111 
1112                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1113                 if (transferDelayEnabled){
1114                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1115                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1116                         _holderLastTransferTimestamp[tx.origin] = block.number;
1117                     }
1118                 }
1119                  
1120                 //when buy
1121                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1122                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1123                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1124                 }
1125                 
1126                 //when sell
1127                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1128                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1129                 }
1130                 else if(!_isExcludedMaxTransactionAmount[to]){
1131                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1132                 }
1133             }
1134         }
1135         
1136         
1137         
1138 		uint256 contractTokenBalance = balanceOf(address(this));
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
1157         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1158             autoBurnLiquidityPairTokens();
1159         }
1160 
1161         bool takeFee = !swapping;
1162 
1163         // if any account belongs to _isExcludedFromFee account then remove the fee
1164         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1165             takeFee = false;
1166         }
1167         
1168         uint256 fees = 0;
1169         // only take fees on buys/sells, do not take on wallet transfers
1170         if(takeFee){
1171             // on sell
1172             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1173                 fees = amount.mul(sellTotalFees).div(100);
1174                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1175                 tokensForDev += fees * sellDevFee / sellTotalFees;
1176                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1177             }
1178             // on buy
1179             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1180         	    fees = amount.mul(buyTotalFees).div(100);
1181         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1182                 tokensForDev += fees * buyDevFee / buyTotalFees;
1183                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
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
1217     
1218     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1219         // approve token transfer to cover all possible scenarios
1220         _approve(address(this), address(uniswapV2Router), tokenAmount);
1221 
1222         // add the liquidity
1223         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1224             address(this),
1225             tokenAmount,
1226             0, // slippage is unavoidable
1227             0, // slippage is unavoidable
1228             deadAddress,
1229             block.timestamp
1230         );
1231     }
1232 
1233     function swapBack() private {
1234         uint256 contractBalance = balanceOf(address(this));
1235         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1236         bool success;
1237         
1238         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1239 
1240         if(contractBalance > swapTokensAtAmount * 20){
1241           contractBalance = swapTokensAtAmount * 20;
1242         }
1243         
1244         // Halve the amount of liquidity tokens
1245         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1246         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1247         
1248         uint256 initialETHBalance = address(this).balance;
1249 
1250         swapTokensForEth(amountToSwapForETH); 
1251         
1252         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1253         
1254         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1255         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1256         
1257         
1258         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1259         
1260         
1261         tokensForLiquidity = 0;
1262         tokensForMarketing = 0;
1263         tokensForDev = 0;
1264         
1265         (success,) = address(devWallet).call{value: ethForDev}("");
1266         
1267         if(liquidityTokens > 0 && ethForLiquidity > 0){
1268             addLiquidity(liquidityTokens, ethForLiquidity);
1269             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1270         }
1271         
1272         
1273         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1274     }
1275     
1276     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1277         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1278         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1279         lpBurnFrequency = _frequencyInSeconds;
1280         percentForLPBurn = _percent;
1281         lpBurnEnabled = _Enabled;
1282     }
1283     
1284     function autoBurnLiquidityPairTokens() internal returns (bool){
1285         
1286         lastLpBurnTime = block.timestamp;
1287         
1288         // get balance of liquidity pair
1289         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1290         
1291         // calculate amount to burn
1292         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1293         
1294         // pull tokens from pancakePair liquidity and move to dead address permanently
1295         if (amountToBurn > 0){
1296             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1297         }
1298         
1299         //sync price since this is not in a swap transaction!
1300         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1301         pair.sync();
1302         emit AutoNukeLP();
1303         return true;
1304     }
1305 
1306     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1307         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1308         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1309         lastManualLpBurnTime = block.timestamp;
1310         
1311         // get balance of liquidity pair
1312         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1313         
1314         // calculate amount to burn
1315         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1316         
1317         // pull tokens from pancakePair liquidity and move to dead address permanently
1318         if (amountToBurn > 0){
1319             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1320         }
1321         
1322         //sync price since this is not in a swap transaction!
1323         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1324         pair.sync();
1325         emit ManualNukeLP();
1326         return true;
1327     }
1328 }