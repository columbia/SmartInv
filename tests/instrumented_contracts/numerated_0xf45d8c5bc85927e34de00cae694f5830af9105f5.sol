1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT                                                                               
5                                                     
6 pragma solidity 0.8.9;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22 
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29 
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33 
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37 
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39 
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51 
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60 
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66 
67     function initialize(address, address) external;
68 }
69 
70 interface IUniswapV2Factory {
71     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
72 
73     function feeTo() external view returns (address);
74     function feeToSetter() external view returns (address);
75 
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function allPairs(uint) external view returns (address pair);
78     function allPairsLength() external view returns (uint);
79 
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 
82     function setFeeTo(address) external;
83     function setFeeToSetter(address) external;
84 }
85 
86 interface IERC20 {
87     /**
88      * @dev Returns the amount of tokens in existence.
89      */
90     function totalSupply() external view returns (uint256);
91 
92     /**
93      * @dev Returns the amount of tokens owned by `account`.
94      */
95     function balanceOf(address account) external view returns (uint256);
96 
97     /**
98      * @dev Moves `amount` tokens from the caller's account to `recipient`.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transfer(address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through {transferFrom}. This is
109      * zero by default.
110      *
111      * This value changes when {approve} or {transferFrom} are called.
112      */
113     function allowance(address owner, address spender) external view returns (uint256);
114 
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * IMPORTANT: Beware that changing an allowance with this method brings the risk
121      * that someone may use both the old and the new allowance by unfortunate
122      * transacgtion ordering. One possible solution to mitigate this race
123      * condition is to first reduce the spender's allowance to 0 and set the
124      * desired value afterwards:
125      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Moves `amount` tokens from `sender` to `recipient` using the
133      * allowance mechanism. `amount` is then deducted from the caller's
134      * allowance.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) external returns (bool);
145 
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 interface IERC20Metadata is IERC20 {
162     /**
163      * @dev Returns the name of the token.
164      */
165     function name() external view returns (string memory);
166 
167     /**
168      * @dev Returns the symbol of the token.
169      */
170     function symbol() external view returns (string memory);
171 
172     /**
173      * @dev Returns the decimals places of the token.
174      */
175     function decimals() external view returns (uint8);
176 }
177 
178 
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     using SafeMath for uint256;
181 
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `recipient` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * Requirements:
290      *
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``sender``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
339         return true;
340     }
341 
342     /**
343      * @dev Moves tokens `amount` from `sender` to `recipient`.
344      *
345      * This is internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(
357         address sender,
358         address recipient,
359         uint256 amount
360     ) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(sender, recipient, amount);
365 
366         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
367         _balances[recipient] = _balances[recipient].add(amount);
368         emit Transfer(sender, recipient, amount);
369     }
370 
371     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
372      * the total supply.
373      *
374      * Emits a {Transfer} event with `from` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      */
380     function _mint(address account, uint256 amount) internal virtual {
381         require(account != address(0), "ERC20: mint to the zero address");
382 
383         _beforeTokenTransfer(address(0), account, amount);
384 
385         _totalSupply = _totalSupply.add(amount);
386         _balances[account] = _balances[account].add(amount);
387         emit Transfer(address(0), account, amount);
388     }
389 
390     /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _beforeTokenTransfer(account, address(0), amount);
405 
406         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
407         _totalSupply = _totalSupply.sub(amount);
408         emit Transfer(account, address(0), amount);
409     }
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
413      *
414      * This internal function is equivalent to `approve`, and can be used to
415      * e.g. set automatic allowances for certain subsystems, etc.
416      *
417      * Emits an {Approval} event.
418      *
419      * Requirements:
420      *
421      * - `owner` cannot be the zero address.
422      * - `spender` cannot be the zero address.
423      */
424     function _approve(
425         address owner,
426         address spender,
427         uint256 amount
428     ) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
443      * will be to transferred to `to`.
444      * - when `from` is zero, `amount` tokens will be minted for `to`.
445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
446      * - `from` and `to` are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(
451         address from,
452         address to,
453         uint256 amount
454     ) internal virtual {}
455 }
456 
457 library SafeMath {
458     /**
459      * @dev Returns the addition of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `+` operator.
463      *
464      * Requirements:
465      *
466      * - Addition cannot overflow.
467      */
468     function add(uint256 a, uint256 b) internal pure returns (uint256) {
469         uint256 c = a + b;
470         require(c >= a, "SafeMath: addition overflow");
471 
472         return c;
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting on
477      * overflow (when the result is negative).
478      *
479      * Counterpart to Solidity's `-` operator.
480      *
481      * Requirements:
482      *
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         return sub(a, b, "SafeMath: subtraction overflow");
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
491      * overflow (when the result is negative).
492      *
493      * Counterpart to Solidity's `-` operator.
494      *
495      * Requirements:
496      *
497      * - Subtraction cannot overflow.
498      */
499     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b <= a, errorMessage);
501         uint256 c = a - b;
502 
503         return c;
504     }
505 
506     /**
507      * @dev Returns the multiplication of two unsigned integers, reverting on
508      * overflow.
509      *
510      * Counterpart to Solidity's `*` operator.
511      *
512      * Requirements:
513      *
514      * - Multiplication cannot overflow.
515      */
516     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
517         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
518         // benefit is lost if 'b' is also tested.
519         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
520         if (a == 0) {
521             return 0;
522         }
523 
524         uint256 c = a * b;
525         require(c / a == b, "SafeMath: multiplication overflow");
526 
527         return c;
528     }
529 
530     /**
531      * @dev Returns the integer division of two unsigned integers. Reverts on
532      * division by zero. The result is rounded towards zero.
533      *
534      * Counterpart to Solidity's `/` operator. Note: this function uses a
535      * `revert` opcode (which leaves remaining gas untouched) while Solidity
536      * uses an invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
543         return div(a, b, "SafeMath: division by zero");
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
558     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
559         require(b > 0, errorMessage);
560         uint256 c = a / b;
561         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
562 
563         return c;
564     }
565 
566     /**
567      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
568      * Reverts when dividing by zero.
569      *
570      * Counterpart to Solidity's `%` operator. This function uses a `revert`
571      * opcode (which leaves remaining gas untouched) while Solidity uses an
572      * invalid opcode to revert (consuming all remaining gas).
573      *
574      * Requirements:
575      *
576      * - The divisor cannot be zero.
577      */
578     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
579         return mod(a, b, "SafeMath: modulo by zero");
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts with custom message when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
595         require(b != 0, errorMessage);
596         return a % b;
597     }
598 }
599 
600 contract Ownable is Context {
601     address private _owner;
602 
603     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
604     
605     /**
606      * @dev Initializes the contract setting the deployer as the initial owner.
607      */
608     constructor () {
609         address msgSender = _msgSender();
610         _owner = msgSender;
611         emit OwnershipTransferred(address(0), msgSender);
612     }
613 
614     /**
615      * @dev Returns the address of the current owner.
616      */
617     function owner() public view returns (address) {
618         return _owner;
619     }
620 
621     /**
622      * @dev Throws if called by any account other than the owner.
623      */
624     modifier onlyOwner() {
625         require(_owner == _msgSender(), "Ownable: caller is not the owner");
626         _;
627     }
628 
629     /**
630      * @dev Leaves the contract without owner. It will not be possible to call
631      * `onlyOwner` functions anymore. Can only be called by the current owner.
632      *
633      * NOTE: Renouncing ownership will leave the contract without an owner,
634      * thereby removing any functionality that is only available to the owner.
635      */
636     function renounceOwnership() public virtual onlyOwner {
637         emit OwnershipTransferred(_owner, address(0));
638         _owner = address(0);
639     }
640 
641     /**
642      * @dev Transfers ownership of the contract to a new account (`newOwner`).
643      * Can only be called by the current owner.
644      */
645     function transferOwnership(address newOwner) public virtual onlyOwner {
646         require(newOwner != address(0), "Ownable: new owner is the zero address");
647         emit OwnershipTransferred(_owner, newOwner);
648         _owner = newOwner;
649     }
650 }
651 
652 
653 
654 library SafeMathInt {
655     int256 private constant MIN_INT256 = int256(1) << 255;
656     int256 private constant MAX_INT256 = ~(int256(1) << 255);
657 
658     /**
659      * @dev Multiplies two int256 variables and fails on overflow.
660      */
661     function mul(int256 a, int256 b) internal pure returns (int256) {
662         int256 c = a * b;
663 
664         // Detect overflow when multiplying MIN_INT256 with -1
665         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
666         require((b == 0) || (c / b == a));
667         return c;
668     }
669 
670     /**
671      * @dev Division of two int256 variables and fails on overflow.
672      */
673     function div(int256 a, int256 b) internal pure returns (int256) {
674         // Prevent overflow when dividing MIN_INT256 by -1
675         require(b != -1 || a != MIN_INT256);
676 
677         // Solidity already throws when dividing by 0.
678         return a / b;
679     }
680 
681     /**
682      * @dev Subtracts two int256 variables and fails on overflow.
683      */
684     function sub(int256 a, int256 b) internal pure returns (int256) {
685         int256 c = a - b;
686         require((b >= 0 && c <= a) || (b < 0 && c > a));
687         return c;
688     }
689 
690     /**
691      * @dev Adds two int256 variables and fails on overflow.
692      */
693     function add(int256 a, int256 b) internal pure returns (int256) {
694         int256 c = a + b;
695         require((b >= 0 && c >= a) || (b < 0 && c < a));
696         return c;
697     }
698 
699     /**
700      * @dev Converts to absolute value, and fails on overflow.
701      */
702     function abs(int256 a) internal pure returns (int256) {
703         require(a != MIN_INT256);
704         return a < 0 ? -a : a;
705     }
706 
707 
708     function toUint256Safe(int256 a) internal pure returns (uint256) {
709         require(a >= 0);
710         return uint256(a);
711     }
712 }
713 
714 library SafeMathUint {
715   function toInt256Safe(uint256 a) internal pure returns (int256) {
716     int256 b = int256(a);
717     require(b >= 0);
718     return b;
719   }
720 }
721 
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
858 contract RizzInu is ERC20, Ownable {
859     using SafeMath for uint256;
860 
861     IUniswapV2Router02 public immutable uniswapV2Router;
862     address public immutable uniswapV2Pair;
863     address public constant deadAddress = address(0xdead);
864 
865     bool private swapping;
866 
867     address public marketingWallet;
868     address public devWallet;
869     
870     uint256 public maxTransactionAmount;
871     uint256 public swapTokensAtAmount;
872     uint256 public maxWallet;
873     
874     uint256 public percentForLPBurn = 25; // 25 = .25%
875     bool public lpBurnEnabled = false;
876     uint256 public lpBurnFrequency = 3600 seconds;
877     uint256 public lastLpBurnTime;
878     
879     uint256 public manualBurnFrequency = 30 minutes;
880     uint256 public lastManualLpBurnTime;
881 
882     bool public limitsInEffect = true;
883     bool public tradingActive = false;
884     bool public swapEnabled = false;
885     
886      // Anti-bot and anti-whale mappings and variables
887     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
888     bool public transferDelayEnabled = true;
889 
890     uint256 public buyTotalFees;
891     uint256 public buyMarketingFee;
892     uint256 public buyLiquidityFee;
893     uint256 public buyDevFee;
894     
895     uint256 public sellTotalFees;
896     uint256 public sellMarketingFee;
897     uint256 public sellLiquidityFee;
898     uint256 public sellDevFee;
899     
900     uint256 public tokensForMarketing;
901     uint256 public tokensForLiquidity;
902     uint256 public tokensForDev;
903     
904     /******************/
905 
906     // exlcude from fees and max transaction amount
907     mapping (address => bool) private _isExcludedFromFees;
908     mapping (address => bool) public _isExcludedMaxTransactionAmount;
909 
910     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
911     // could be subject to a maximum transfer amount
912     mapping (address => bool) public automatedMarketMakerPairs;
913 
914     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
915 
916     event ExcludeFromFees(address indexed account, bool isExcluded);
917 
918     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
919 
920     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
921     
922     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
923 
924     event SwapAndLiquify(
925         uint256 tokensSwapped,
926         uint256 ethReceived,
927         uint256 tokensIntoLiquidity
928     );
929     
930     event AutoNukeLP();
931     
932     event ManualNukeLP();
933 
934     constructor() ERC20("Rizz Inu", "RIZZ") {
935         
936         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
937         
938         excludeFromMaxTransaction(address(_uniswapV2Router), true);
939         uniswapV2Router = _uniswapV2Router;
940         
941         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
942         excludeFromMaxTransaction(address(uniswapV2Pair), true);
943         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
944         
945         uint256 _buyMarketingFee = 33;
946         uint256 _buyLiquidityFee = 0;
947         uint256 _buyDevFee = 0;
948 
949         uint256 _sellMarketingFee = 47;
950         uint256 _sellLiquidityFee = 0;
951         uint256 _sellDevFee = 0;
952         
953         uint256 totalSupply = 1 * 1e9 * 1e18;
954         
955         //maxTransactionAmount = totalSupply * 2.5 / 1000; // 0.25% maxTransactionAmountTxn
956         maxTransactionAmount = 2500000 * 1e18;
957         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
958         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
959 
960         buyMarketingFee = _buyMarketingFee;
961         buyLiquidityFee = _buyLiquidityFee;
962         buyDevFee = _buyDevFee;
963         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
964         
965         sellMarketingFee = _sellMarketingFee;
966         sellLiquidityFee = _sellLiquidityFee;
967         sellDevFee = _sellDevFee;
968         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
969         
970         marketingWallet = address(owner()); // set as marketing wallet
971         devWallet = address(owner()); // set as dev wallet
972 
973         // exclude from paying fees or having max transaction amount
974         excludeFromFees(owner(), true);
975         excludeFromFees(address(this), true);
976         excludeFromFees(address(0xdead), true);
977         
978         excludeFromMaxTransaction(owner(), true);
979         excludeFromMaxTransaction(address(this), true);
980         excludeFromMaxTransaction(address(0xdead), true);
981         
982         /*
983             _mint is an internal function in ERC20.sol that is only called here,
984             and CANNOT be called ever again
985         */
986         _mint(msg.sender, totalSupply);
987     }
988 
989     receive() external payable {
990 
991   	}
992 
993     // once enabled, can never be turned off
994     function enableTrading() external onlyOwner {
995         tradingActive = true;
996         swapEnabled = true;
997         lastLpBurnTime = block.timestamp;
998     }
999     
1000     // remove limits after token is stable
1001     function removeLimits() external onlyOwner returns (bool){
1002         limitsInEffect = false;
1003         return true;
1004     }
1005     
1006     // disable Transfer delay - cannot be reenabled
1007     function disableTransferDelay() external onlyOwner returns (bool){
1008         transferDelayEnabled = false;
1009         return true;
1010     }
1011     
1012      // change the minimum amount of tokens to sell from fees
1013     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1014   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1015   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1016   	    swapTokensAtAmount = newAmount;
1017   	    return true;
1018   	}
1019     
1020     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1021         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1022         maxTransactionAmount = newNum * (10**18);
1023     }
1024 
1025     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1026         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1027         maxWallet = newNum * (10**18);
1028     }
1029     
1030     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1031         _isExcludedMaxTransactionAmount[updAds] = isEx;
1032     }
1033     
1034     // only use to disable contract sales if absolutely necessary (emergency use only)
1035     function updateSwapEnabled(bool enabled) external onlyOwner(){
1036         swapEnabled = enabled;
1037     }
1038     
1039     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1040         buyMarketingFee = _marketingFee;
1041         buyLiquidityFee = _liquidityFee;
1042         buyDevFee = _devFee;
1043         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1044         require(buyTotalFees <= 49, "Must keep fees at 49% or less");
1045     }
1046     
1047     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1048         sellMarketingFee = _marketingFee;
1049         sellLiquidityFee = _liquidityFee;
1050         sellDevFee = _devFee;
1051         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1052         require(sellTotalFees <= 49, "Must keep fees at 49% or less");
1053     }
1054 
1055     function excludeFromFees(address account, bool excluded) public onlyOwner {
1056         _isExcludedFromFees[account] = excluded;
1057         emit ExcludeFromFees(account, excluded);
1058     }
1059 
1060     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1061         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1062 
1063         _setAutomatedMarketMakerPair(pair, value);
1064     }
1065 
1066     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1067         automatedMarketMakerPairs[pair] = value;
1068 
1069         emit SetAutomatedMarketMakerPair(pair, value);
1070     }
1071 
1072     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1073         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1074         marketingWallet = newMarketingWallet;
1075     }
1076     
1077     function updateDevWallet(address newWallet) external onlyOwner {
1078         emit devWalletUpdated(newWallet, devWallet);
1079         devWallet = newWallet;
1080     }
1081     
1082 
1083     function isExcludedFromFees(address account) public view returns(bool) {
1084         return _isExcludedFromFees[account];
1085     }
1086     
1087     event BoughtEarly(address indexed sniper);
1088 
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 amount
1093     ) internal override {
1094         require(from != address(0), "ERC20: transfer from the zero address");
1095         require(to != address(0), "ERC20: transfer to the zero address");
1096         
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
1138         
1139         
1140 		uint256 contractTokenBalance = balanceOf(address(this));
1141         
1142         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1143 
1144         if( 
1145             canSwap &&
1146             swapEnabled &&
1147             !swapping &&
1148             !automatedMarketMakerPairs[from] &&
1149             !_isExcludedFromFees[from] &&
1150             !_isExcludedFromFees[to]
1151         ) {
1152             swapping = true;
1153             
1154             swapBack();
1155 
1156             swapping = false;
1157         }
1158         
1159         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1160             autoBurnLiquidityPairTokens();
1161         }
1162 
1163         bool takeFee = !swapping;
1164 
1165         // if any account belongs to _isExcludedFromFee account then remove the fee
1166         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1167             takeFee = false;
1168         }
1169         
1170         uint256 fees = 0;
1171         // only take fees on buys/sells, do not take on wallet transfers
1172         if(takeFee){
1173             // on sell
1174             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1175                 fees = amount.mul(sellTotalFees).div(100);
1176                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1177                 tokensForDev += fees * sellDevFee / sellTotalFees;
1178                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1179             }
1180             // on buy
1181             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1182         	    fees = amount.mul(buyTotalFees).div(100);
1183         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1184                 tokensForDev += fees * buyDevFee / buyTotalFees;
1185                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1186             }
1187             
1188             if(fees > 0){    
1189                 super._transfer(from, address(this), fees);
1190             }
1191         	
1192         	amount -= fees;
1193         }
1194 
1195         super._transfer(from, to, amount);
1196     }
1197 
1198     function swapTokensForEth(uint256 tokenAmount) private {
1199 
1200         // generate the uniswap pair path of token -> weth
1201         address[] memory path = new address[](2);
1202         path[0] = address(this);
1203         path[1] = uniswapV2Router.WETH();
1204 
1205         _approve(address(this), address(uniswapV2Router), tokenAmount);
1206 
1207         // make the swap
1208         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1209             tokenAmount,
1210             0, // accept any amount of ETH
1211             path,
1212             address(this),
1213             block.timestamp
1214         );
1215         
1216     }
1217     
1218     
1219     
1220     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1221         // approve token transfer to cover all possible scenarios
1222         _approve(address(this), address(uniswapV2Router), tokenAmount);
1223 
1224         // add the liquidity
1225         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1226             address(this),
1227             tokenAmount,
1228             0, // slippage is unavoidable
1229             0, // slippage is unavoidable
1230             deadAddress,
1231             block.timestamp
1232         );
1233     }
1234 
1235     function swapBack() private {
1236         uint256 contractBalance = balanceOf(address(this));
1237         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1238         bool success;
1239         
1240         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1241 
1242         if(contractBalance > swapTokensAtAmount * 20){
1243           contractBalance = swapTokensAtAmount * 20;
1244         }
1245         
1246         // Halve the amount of liquidity tokens
1247         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1248         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1249         
1250         uint256 initialETHBalance = address(this).balance;
1251 
1252         swapTokensForEth(amountToSwapForETH); 
1253         
1254         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1255         
1256         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1257         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1258         
1259         
1260         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1261         
1262         
1263         tokensForLiquidity = 0;
1264         tokensForMarketing = 0;
1265         tokensForDev = 0;
1266         
1267         (success,) = address(devWallet).call{value: ethForDev}("");
1268         
1269         if(liquidityTokens > 0 && ethForLiquidity > 0){
1270             addLiquidity(liquidityTokens, ethForLiquidity);
1271             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1272         }
1273         
1274         
1275         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1276     }
1277     
1278     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1279         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1280         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1281         lpBurnFrequency = _frequencyInSeconds;
1282         percentForLPBurn = _percent;
1283         lpBurnEnabled = _Enabled;
1284     }
1285     
1286     function autoBurnLiquidityPairTokens() internal returns (bool){
1287         
1288         lastLpBurnTime = block.timestamp;
1289         
1290         // get balance of liquidity pair
1291         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1292         
1293         // calculate amount to burn
1294         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1295         
1296         // pull tokens from pancakePair liquidity and move to dead address permanently
1297         if (amountToBurn > 0){
1298             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1299         }
1300         
1301         //sync price since this is not in a swap transaction!
1302         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1303         pair.sync();
1304         emit AutoNukeLP();
1305         return true;
1306     }
1307 
1308     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1309         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1310         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1311         lastManualLpBurnTime = block.timestamp;
1312         
1313         // get balance of liquidity pair
1314         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1315         
1316         // calculate amount to burn
1317         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1318         
1319         // pull tokens from pancakePair liquidity and move to dead address permanently
1320         if (amountToBurn > 0){
1321             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1322         }
1323         
1324         //sync price since this is not in a swap transaction!
1325         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1326         pair.sync();
1327         emit ManualNukeLP();
1328         return true;
1329     }
1330 }