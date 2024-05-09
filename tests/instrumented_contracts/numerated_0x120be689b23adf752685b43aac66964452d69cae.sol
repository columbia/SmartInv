1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-19
3 */
4 
5 // SPDX-License-Identifier: MIT  
6 pragma solidity ^0.8.17;
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
858 
859 /*
860 In a quiet meadow, Charlie, a unicorn, is resting, before he is awakened by a blue and a pink unicorn. As Charlie awakes from his slumber, 
861 the two inform him that they have found a map to the magical Candy Mountain, and that he must come with them on their journey. 
862 Charlie initially refuses and goes back to sleep. The blue unicorn begins to jump on Charlie, insistent that he should come, and both 
863 begin to pester him with details of the mountain, causing him to begrudgingly give in to their demands.
864 
865 The trio begin their journey in a forest, where the blue and pink unicorns lead Charlie to a Magical Liopleurodon, who supposedly tells
866 them the way with unintelligible gurgles. The trio then cross a bridge, while the blue unicorn badgers Charlie by repeating his name and 
867 reminding him they are on a bridge. When the trio arrives at Candy Mountain, the letters of the CANDY sign come to life and the "Y" sings 
868 a song (sung to the tune of the Clarinet Polka) imploring Charlie to go into the Candy Cave. After the letters explode, Charlie reluctantly
869 goes into the cave, and the blue and pink unicorns say goodbye as Charlie is trapped inside and knocked out by an unknown assailant. 
870 When Charlie awakens in the meadow, he realizes that they have taken one of his kidneys, much to his dismay.
871 
872 https://www.youtube.com/watch?v=CsGYh8AacgY
873 
874 ⠀⠀⠀⠀⠀⠑⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
875 ⠀⠀⠀⠀⠀⠀⠀⠙⢷⣦⣀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
876 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣿⣾⣿⣧⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
877 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣇⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
878 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣥⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
879 ⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠟⠉⠉⢹⣿⣿⣿⣿⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
880 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
881 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀
882 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
883 ⠀⠀⠀⢀⣠⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀
884 ⢀⣴⠿⠛⠉⢸⡏⠁⠉⠙⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀
885 ⠉⠉⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀
886 ⠀⠀⠀⠀⠀⠈⠿⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
887 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣧⡀⠀
888 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⠟⢿⣷⡄
889 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡟⠀⢠⣾⣿⣿
890 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣀⣾⣿⡿⠃
891 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠏⠀⠀
892 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣿⣿⠻⣿⣿⡀⠀⠀
893 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠋⣹⣿⠃⠀⠈⣿⣿⣴⠇
894 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣾⠟⠀⠀⠀⠀⠘⠉⠛⠀
895 
896 
897 */
898 contract CandyMountain is ERC20, Ownable  {
899     using SafeMath for uint256;
900 
901     IUniswapV2Router02 public immutable uniswapV2Router;
902     address public immutable uniswapV2Pair;
903     address public constant deadAddress = address(0xdead);
904 
905     bool private swapping;
906 
907     address public marketingWallet;
908     address public devWallet;
909     
910     uint256 public maxTransactionAmount;
911     uint256 public swapTokensAtAmount;
912     uint256 public maxWallet;
913     
914     uint256 public percentForLPBurn = 1; // 25 = .25%
915     bool public lpBurnEnabled = false;
916     uint256 public lpBurnFrequency = 1360000000000 seconds;
917     uint256 public lastLpBurnTime;
918     
919     uint256 public manualBurnFrequency = 43210 minutes;
920     uint256 public lastManualLpBurnTime;
921 
922     bool public limitsInEffect = true;
923     bool public tradingActive = true;
924     bool public swapEnabled = true;
925     
926      // Anti-bot and anti-whale mappings and variables
927     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
928     bool public transferDelayEnabled = true;
929 
930     uint256 public buyTotalFees;
931     uint256 public buyMarketingFee;
932     uint256 public buyLiquidityFee;
933     uint256 public buyDevFee;
934     
935     uint256 public sellTotalFees;
936     uint256 public sellMarketingFee;
937     uint256 public sellLiquidityFee;
938     uint256 public sellDevFee;
939     
940     uint256 public tokensForMarketing;
941     uint256 public tokensForLiquidity;
942     uint256 public tokensForDev;
943     
944     /******************/
945 
946     // exlcude from fees and max transaction amount
947     mapping (address => bool) private _isExcludedFromFees;
948     mapping (address => bool) public _isExcludedMaxTransactionAmount;
949 
950     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
951     // could be subject to a maximum transfer amount
952     mapping (address => bool) public automatedMarketMakerPairs;
953 
954     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
955 
956     event ExcludeFromFees(address indexed account, bool isExcluded);
957 
958     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
959 
960     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
961     
962     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
963 
964     event SwapAndLiquify(
965         uint256 tokensSwapped,
966         uint256 ethReceived,
967         uint256 tokensIntoLiquidity
968     );
969     
970     event AutoNukeLP();
971     
972     event ManualNukeLP();
973 
974     constructor() ERC20("Candy Mountain", "CHARLIE") {
975         
976         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
977         
978         excludeFromMaxTransaction(address(_uniswapV2Router), true);
979         uniswapV2Router = _uniswapV2Router;
980         
981         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
982         excludeFromMaxTransaction(address(uniswapV2Pair), true);
983         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
984         
985         uint256 _buyMarketingFee = 90;
986         uint256 _buyLiquidityFee = 0;
987         uint256 _buyDevFee = 0;
988 
989         uint256 _sellMarketingFee = 90;
990         uint256 _sellLiquidityFee = 0;
991         uint256 _sellDevFee = 0;
992         
993         uint256 totalSupply = 69 * 1e10 * 1e18;
994         
995         //maxTransactionAmount 
996         maxTransactionAmount = 1000000000000000000000000; 
997         maxWallet = 20000000000000000000000; 
998         swapTokensAtAmount = totalSupply * 10 /2000; 
999 
1000         buyMarketingFee = _buyMarketingFee;
1001         buyLiquidityFee = _buyLiquidityFee;
1002         buyDevFee = _buyDevFee;
1003         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1004         
1005         sellMarketingFee = _sellMarketingFee;
1006         sellLiquidityFee = _sellLiquidityFee;
1007         sellDevFee = _sellDevFee;
1008         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1009         
1010         marketingWallet = address(owner()); // set as marketing wallet
1011         devWallet = address(owner()); // set as dev wallet
1012 
1013         // exclude from paying fees or having max transaction amount
1014         excludeFromFees(owner(), true);
1015         excludeFromFees(address(this), true);
1016         excludeFromFees(address(0xdead), true);
1017         
1018         excludeFromMaxTransaction(owner(), true);
1019         excludeFromMaxTransaction(address(this), true);
1020         excludeFromMaxTransaction(address(0xdead), true);
1021         
1022         /*
1023             _mint is an internal function in ERC20.sol that is only called here,
1024             and CANNOT be called ever again
1025         */
1026         _mint(msg.sender, totalSupply);
1027     }
1028 
1029     receive() external payable {
1030 
1031     }
1032 
1033     // once enabled, can never be turned off
1034     function enableTrading() external onlyOwner {
1035         tradingActive = true;
1036         swapEnabled = true;
1037         lastLpBurnTime = block.timestamp;
1038     }
1039     
1040     // remove limits after token is stable
1041     function removeLimits() external onlyOwner returns (bool){
1042         limitsInEffect = false;
1043         return true;
1044     }
1045     
1046     // disable Transfer delay - cannot be reenabled
1047     function disableTransferDelay() external onlyOwner returns (bool){
1048         transferDelayEnabled = false;
1049         return true;
1050     }
1051     
1052      // change the minimum amount of tokens to sell from fees
1053     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1054         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1055         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1056         swapTokensAtAmount = newAmount;
1057         return true;
1058     }
1059     
1060     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1061         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1062         maxTransactionAmount = newNum * (10**18);
1063     }
1064 
1065     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1066         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1067         maxWallet = newNum * (10**18);
1068     }
1069     
1070     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1071         _isExcludedMaxTransactionAmount[updAds] = isEx;
1072     }
1073     
1074     // only use to disable contract sales if absolutely necessary (emergency use only)
1075     function updateSwapEnabled(bool enabled) external onlyOwner(){
1076         swapEnabled = enabled;
1077     }
1078     
1079     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1080         buyMarketingFee = _marketingFee;
1081         buyLiquidityFee = _liquidityFee;
1082         buyDevFee = _devFee;
1083         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1084         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1085     }
1086     
1087     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1088         sellMarketingFee = _marketingFee;
1089         sellLiquidityFee = _liquidityFee;
1090         sellDevFee = _devFee;
1091         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1092         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1093     }
1094 
1095     function excludeFromFees(address account, bool excluded) public onlyOwner {
1096         _isExcludedFromFees[account] = excluded;
1097         emit ExcludeFromFees(account, excluded);
1098     }
1099 
1100     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1101         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1102 
1103         _setAutomatedMarketMakerPair(pair, value);
1104     }
1105 
1106     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1107         automatedMarketMakerPairs[pair] = value;
1108 
1109         emit SetAutomatedMarketMakerPair(pair, value);
1110     }
1111 
1112     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1113         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1114         marketingWallet = newMarketingWallet;
1115     }
1116     
1117     function updateDevWallet(address newWallet) external onlyOwner {
1118         emit devWalletUpdated(newWallet, devWallet);
1119         devWallet = newWallet;
1120     }
1121     
1122 
1123     function isExcludedFromFees(address account) public view returns(bool) {
1124         return _isExcludedFromFees[account];
1125     }
1126     
1127     event BoughtEarly(address indexed sniper);
1128 
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 amount
1133     ) internal override {
1134         require(from != address(0), "ERC20: transfer from the zero address");
1135         require(to != address(0), "ERC20: transfer to the zero address");
1136         
1137          if(amount == 0) {
1138             super._transfer(from, to, 0);
1139             return;
1140         }
1141         
1142         if(limitsInEffect){
1143             if (
1144                 from != owner() &&
1145                 to != owner() &&
1146                 to != address(0) &&
1147                 to != address(0xdead) &&
1148                 !swapping
1149             ){
1150                 if(!tradingActive){
1151                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1152                 }
1153 
1154                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1155                 if (transferDelayEnabled){
1156                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1157                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1158                         _holderLastTransferTimestamp[tx.origin] = block.number;
1159                     }
1160                 }
1161                  
1162                 //when buy
1163                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1164                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1165                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1166                 }
1167                 
1168                 //when sell
1169                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1170                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1171                 }
1172                 else if(!_isExcludedMaxTransactionAmount[to]){
1173                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1174                 }
1175             }
1176         }
1177         
1178         
1179         
1180         uint256 contractTokenBalance = balanceOf(address(this));
1181         
1182         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1183 
1184         if( 
1185             canSwap &&
1186             swapEnabled &&
1187             !swapping &&
1188             !automatedMarketMakerPairs[from] &&
1189             !_isExcludedFromFees[from] &&
1190             !_isExcludedFromFees[to]
1191         ) {
1192             swapping = true;
1193             
1194             swapBack();
1195 
1196             swapping = false;
1197         }
1198         
1199         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1200             autoBurnLiquidityPairTokens();
1201         }
1202 
1203         bool takeFee = !swapping;
1204 
1205         // if any account belongs to _isExcludedFromFee account then remove the fee
1206         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1207             takeFee = false;
1208         }
1209         
1210         uint256 fees = 0;
1211         // only take fees on buys/sells, do not take on wallet transfers
1212         if(takeFee){
1213             // on sell
1214             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1215                 fees = amount.mul(sellTotalFees).div(100);
1216                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1217                 tokensForDev += fees * sellDevFee / sellTotalFees;
1218                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1219             }
1220             // on buy
1221             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1222                 fees = amount.mul(buyTotalFees).div(100);
1223                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1224                 tokensForDev += fees * buyDevFee / buyTotalFees;
1225                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1226             }
1227             
1228             if(fees > 0){    
1229                 super._transfer(from, address(this), fees);
1230             }
1231             
1232             amount -= fees;
1233         }
1234 
1235         super._transfer(from, to, amount);
1236     }
1237 
1238     function swapTokensForEth(uint256 tokenAmount) private {
1239 
1240         // generate the uniswap pair path of token -> weth
1241         address[] memory path = new address[](2);
1242         path[0] = address(this);
1243         path[1] = uniswapV2Router.WETH();
1244 
1245         _approve(address(this), address(uniswapV2Router), tokenAmount);
1246 
1247         // make the swap
1248         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1249             tokenAmount,
1250             0, // accept any amount of ETH
1251             path,
1252             address(this),
1253             block.timestamp
1254         );
1255         
1256     }
1257     
1258     
1259     
1260     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1261         // approve token transfer to cover all possible scenarios
1262         _approve(address(this), address(uniswapV2Router), tokenAmount);
1263 
1264         // add the liquidity
1265         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1266             address(this),
1267             tokenAmount,
1268             0, // slippage is unavoidable
1269             0, // slippage is unavoidable
1270             deadAddress,
1271             block.timestamp
1272         );
1273     }
1274 
1275     function swapBack() private {
1276         uint256 contractBalance = balanceOf(address(this));
1277         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1278         bool success;
1279         
1280         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1281 
1282         if(contractBalance > swapTokensAtAmount * 20){
1283           contractBalance = swapTokensAtAmount * 20;
1284         }
1285         
1286         // Halve the amount of liquidity tokens
1287         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1288         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1289         
1290         uint256 initialETHBalance = address(this).balance;
1291 
1292         swapTokensForEth(amountToSwapForETH); 
1293         
1294         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1295         
1296         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1297         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1298         
1299         
1300         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1301         
1302         
1303         tokensForLiquidity = 0;
1304         tokensForMarketing = 0;
1305         tokensForDev = 0;
1306         
1307         (success,) = address(devWallet).call{value: ethForDev}("");
1308         
1309         if(liquidityTokens > 0 && ethForLiquidity > 0){
1310             addLiquidity(liquidityTokens, ethForLiquidity);
1311             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1312         }
1313         
1314         
1315         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1316     }
1317     
1318     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1319         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1320         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1321         lpBurnFrequency = _frequencyInSeconds;
1322         percentForLPBurn = _percent;
1323         lpBurnEnabled = _Enabled;
1324     }
1325     
1326     function autoBurnLiquidityPairTokens() internal returns (bool){
1327         
1328         lastLpBurnTime = block.timestamp;
1329         
1330         // get balance of liquidity pair
1331         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1332         
1333         // calculate amount to burn
1334         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1335         
1336         // pull tokens from pancakePair liquidity and move to dead address permanently
1337         if (amountToBurn > 0){
1338             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1339         }
1340         
1341         //sync price since this is not in a swap transaction!
1342         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1343         pair.sync();
1344         emit AutoNukeLP();
1345         return true;
1346     }
1347 
1348     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1349         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1350         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1351         lastManualLpBurnTime = block.timestamp;
1352         
1353         // get balance of liquidity pair
1354         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1355         
1356         // calculate amount to burn
1357         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1358         
1359         // pull tokens from pancakePair liquidity and move to dead address permanently
1360         if (amountToBurn > 0){
1361             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1362         }
1363         
1364         //sync price since this is not in a swap transaction!
1365         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1366         pair.sync();
1367         emit ManualNukeLP();
1368         return true;
1369     }
1370 }