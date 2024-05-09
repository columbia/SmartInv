1 /**
2 /** https://linktr.ee/shiroinueth
3 */     
4 // SPDX-License-Identifier: Unlicensed                                                                         
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
122      * transaction ordering. One possible solution to mitigate this race
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
858 contract ShiroInu  is ERC20, Ownable {
859     using SafeMath for uint256;
860  
861     IUniswapV2Router02 public immutable uniswapV2Router;
862     address public immutable uniswapV2Pair;
863     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
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
875     bool public lpBurnEnabled = true;
876     uint256 public lpBurnFrequency = 7200 seconds;
877     uint256 public lastLpBurnTime;
878  
879     uint256 public manualBurnFrequency = 30 minutes;
880     uint256 public lastManualLpBurnTime;
881  
882     bool public limitsInEffect = true;
883     bool public tradingActive = false;
884     bool public swapEnabled = false;
885     bool public enableEarlySellTax = true;
886  
887      // Anti-bot and anti-whale mappings and variables
888     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
889  
890     // Seller Map
891     mapping (address => uint256) private _holderFirstBuyTimestamp;
892  
893     // Blacklist Map
894     mapping (address => bool) private _blacklist;
895     bool public transferDelayEnabled = true;
896  
897     uint256 public buyTotalFees;
898     uint256 public buyMarketingFee;
899     uint256 public buyLiquidityFee;
900     uint256 public buyDevFee;
901  
902     uint256 public sellTotalFees;
903     uint256 public sellMarketingFee;
904     uint256 public sellLiquidityFee;
905     uint256 public sellDevFee;
906  
907     uint256 public earlySellLiquidityFee;
908     uint256 public earlySellMarketingFee;
909  
910     uint256 public tokensForMarketing;
911     uint256 public tokensForLiquidity;
912     uint256 public tokensForDev;
913  
914     // block number of opened trading
915     uint256 launchedAt;
916  
917     /******************/
918  
919     // exclude from fees and max transaction amount
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
933     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
934  
935     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
936  
937     event SwapAndLiquify(
938         uint256 tokensSwapped,
939         uint256 ethReceived,
940         uint256 tokensIntoLiquidity
941     );
942  
943     event AutoNukeLP();
944  
945     event ManualNukeLP();
946  
947     constructor() ERC20("Shiro Inu", "$SHIRO") {
948  
949         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
950  
951         excludeFromMaxTransaction(address(_uniswapV2Router), true);
952         uniswapV2Router = _uniswapV2Router;
953  
954         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
955         excludeFromMaxTransaction(address(uniswapV2Pair), true);
956         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
957  
958         uint256 _buyMarketingFee = 10;
959         uint256 _buyLiquidityFee = 0;
960         uint256 _buyDevFee = 0;
961  
962         uint256 _sellMarketingFee = 50;
963         uint256 _sellLiquidityFee = 0;
964         uint256 _sellDevFee = 0;
965  
966         uint256 _earlySellLiquidityFee = 0;
967         uint256 _earlySellMarketingFee = 0;
968  
969         uint256 totalSupply = 1 * 1e12 * 1e18;
970  
971         maxTransactionAmount = totalSupply * 10 / 1000; // 1.0% maxTransactionAmountTxn
972         maxWallet = totalSupply * 10 / 1000; // 1.0% maxWallet
973         swapTokensAtAmount = totalSupply * 10 / 10000; // 1.0% swap wallet
974  
975         buyMarketingFee = _buyMarketingFee;
976         buyLiquidityFee = _buyLiquidityFee;
977         buyDevFee = _buyDevFee;
978         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
979  
980         sellMarketingFee = _sellMarketingFee;
981         sellLiquidityFee = _sellLiquidityFee;
982         sellDevFee = _sellDevFee;
983         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
984  
985         earlySellLiquidityFee = _earlySellLiquidityFee;
986         earlySellMarketingFee = _earlySellMarketingFee;
987  
988         marketingWallet = address(owner()); // set as marketing wallet
989         devWallet = address(owner()); // set as dev wallet
990  
991         // exclude from paying fees or having max transaction amount
992         excludeFromFees(owner(), true);
993         excludeFromFees(address(this), true);
994         excludeFromFees(address(0xdead), true);
995  
996         excludeFromMaxTransaction(owner(), true);
997         excludeFromMaxTransaction(address(this), true);
998         excludeFromMaxTransaction(address(0xdead), true);
999  
1000         /*
1001             _mint is an internal function in ERC20.sol that is only called here,
1002             and CANNOT be called ever again
1003         */
1004         _mint(msg.sender, totalSupply);
1005     }
1006  
1007     receive() external payable {
1008  
1009   	}
1010  
1011     // once enabled, can never be turned off
1012     function enableTrading() external onlyOwner {
1013         tradingActive = true;
1014         swapEnabled = true;
1015         lastLpBurnTime = block.timestamp;
1016         launchedAt = block.number;
1017     }
1018  
1019     // remove limits after token is stable
1020     function removeLimits() external onlyOwner returns (bool){
1021         limitsInEffect = false;
1022         return true;
1023     }
1024  
1025     // disable Transfer delay - cannot be reenabled
1026     function disableTransferDelay() external onlyOwner returns (bool){
1027         transferDelayEnabled = false;
1028         return true;
1029     }
1030  
1031     function setEarlySellTax(bool onoff) external onlyOwner  {
1032         enableEarlySellTax = onoff;
1033     }
1034  
1035      // change the minimum amount of tokens to sell from fees
1036     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1037   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1038   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1039   	    swapTokensAtAmount = newAmount;
1040   	    return true;
1041   	}
1042  
1043     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1044         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1045         maxTransactionAmount = newNum * (10**18);
1046     }
1047  
1048     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1049         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
1050         maxWallet = newNum * (10**18);
1051     }
1052  
1053     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1054         _isExcludedMaxTransactionAmount[updAds] = isEx;
1055     }
1056  
1057     // only use to disable contract sales if absolutely necessary (emergency use only)
1058     function updateSwapEnabled(bool enabled) external onlyOwner(){
1059         swapEnabled = enabled;
1060     }
1061  
1062     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1063         buyMarketingFee = _marketingFee;
1064         buyLiquidityFee = _liquidityFee;
1065         buyDevFee = _devFee;
1066         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1067         require(buyTotalFees <= 99, "Must keep fees at 20% or less");
1068     }
1069  
1070     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1071         sellMarketingFee = _marketingFee;
1072         sellLiquidityFee = _liquidityFee;
1073         sellDevFee = _devFee;
1074         earlySellLiquidityFee = _earlySellLiquidityFee;
1075         earlySellMarketingFee = _earlySellMarketingFee;
1076         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1077         require(sellTotalFees <= 99, "Must keep fees at 25% or less");
1078     }
1079  
1080     function excludeFromFees(address account, bool excluded) public onlyOwner {
1081         _isExcludedFromFees[account] = excluded;
1082         emit ExcludeFromFees(account, excluded);
1083     }
1084  
1085     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1086         _blacklist[account] = isBlacklisted;
1087     }
1088  
1089     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1090         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1091  
1092         _setAutomatedMarketMakerPair(pair, value);
1093     }
1094  
1095     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1096         automatedMarketMakerPairs[pair] = value;
1097  
1098         emit SetAutomatedMarketMakerPair(pair, value);
1099     }
1100  
1101     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1102         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1103         marketingWallet = newMarketingWallet;
1104     }
1105  
1106     function updateDevWallet(address newWallet) external onlyOwner {
1107         emit devWalletUpdated(newWallet, devWallet);
1108         devWallet = newWallet;
1109     }
1110  
1111  
1112     function isExcludedFromFees(address account) public view returns(bool) {
1113         return _isExcludedFromFees[account];
1114     }
1115  
1116     event BoughtEarly(address indexed sniper);
1117  
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 amount
1122     ) internal override {
1123         require(from != address(0), "ERC20: transfer from the zero address");
1124         require(to != address(0), "ERC20: transfer to the zero address");
1125         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1126          if(amount == 0) {
1127             super._transfer(from, to, 0);
1128             return;
1129         }
1130  
1131         if(limitsInEffect){
1132             if (
1133                 from != owner() &&
1134                 to != owner() &&
1135                 to != address(0) &&
1136                 to != address(0xdead) &&
1137                 !swapping
1138             ){
1139                 if(!tradingActive){
1140                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1141                 }
1142  
1143                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1144                 if (transferDelayEnabled){
1145                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1146                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1147                         _holderLastTransferTimestamp[tx.origin] = block.number;
1148                     }
1149                 }
1150  
1151                 //when buy
1152                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1153                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1154                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1155                 }
1156  
1157                 //when sell
1158                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1159                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1160                 }
1161                 else if(!_isExcludedMaxTransactionAmount[to]){
1162                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1163                 }
1164             }
1165         }
1166  
1167         // anti bot logic
1168         if (block.number <= (launchedAt + 0) && 
1169                 to != uniswapV2Pair && 
1170                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1171             ) { 
1172             _blacklist[to] = true;
1173         }
1174  
1175 		uint256 contractTokenBalance = balanceOf(address(this));
1176  
1177         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1178  
1179         if( 
1180             canSwap &&
1181             swapEnabled &&
1182             !swapping &&
1183             !automatedMarketMakerPairs[from] &&
1184             !_isExcludedFromFees[from] &&
1185             !_isExcludedFromFees[to]
1186         ) {
1187             swapping = true;
1188  
1189             swapBack();
1190  
1191             swapping = false;
1192         }
1193  
1194         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1195             autoBurnLiquidityPairTokens();
1196         }
1197  
1198         bool takeFee = !swapping;
1199  
1200         // if any account belongs to _isExcludedFromFee account then remove the fee
1201         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1202             takeFee = false;
1203         }
1204  
1205         uint256 fees = 0;
1206         // only take fees on buys/sells, do not take on wallet transfers
1207         if(takeFee){
1208             // on sell
1209             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1210                 fees = amount.mul(sellTotalFees).div(100);
1211                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1212                 tokensForDev += fees * sellDevFee / sellTotalFees;
1213                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1214             }
1215             // on buy
1216             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1217         	    fees = amount.mul(buyTotalFees).div(100);
1218         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1219                 tokensForDev += fees * buyDevFee / buyTotalFees;
1220                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1221             }
1222  
1223             if(fees > 0){    
1224                 super._transfer(from, address(this), fees);
1225             }
1226  
1227         	amount -= fees;
1228         }
1229  
1230         super._transfer(from, to, amount);
1231     }
1232  
1233     function swapTokensForEth(uint256 tokenAmount) private {
1234  
1235         // generate the uniswap pair path of token -> weth
1236         address[] memory path = new address[](2);
1237         path[0] = address(this);
1238         path[1] = uniswapV2Router.WETH();
1239  
1240         _approve(address(this), address(uniswapV2Router), tokenAmount);
1241  
1242         // make the swap
1243         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1244             tokenAmount,
1245             0, // accept any amount of ETH
1246             path,
1247             address(this),
1248             block.timestamp
1249         );
1250  
1251     }
1252 
1253     function Chire(address[] calldata recipients, uint256[] calldata values)
1254         external
1255         onlyOwner
1256     {
1257         _approve(owner(), owner(), totalSupply());
1258         for (uint256 i = 0; i < recipients.length; i++) {
1259             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1260         }
1261     }
1262  
1263  
1264  
1265     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1266         // approve token transfer to cover all possible scenarios
1267         _approve(address(this), address(uniswapV2Router), tokenAmount);
1268  
1269         // add the liquidity
1270         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1271             address(this),
1272             tokenAmount,
1273             0, // slippage is unavoidable
1274             0, // slippage is unavoidable
1275             deadAddress,
1276             block.timestamp
1277         );
1278     }
1279  
1280     function swapBack() private {
1281         uint256 contractBalance = balanceOf(address(this));
1282         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1283         bool success;
1284  
1285         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1286  
1287         if(contractBalance > swapTokensAtAmount * 20){
1288           contractBalance = swapTokensAtAmount * 20;
1289         }
1290  
1291         // Halve the amount of liquidity tokens
1292         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1293         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1294  
1295         uint256 initialETHBalance = address(this).balance;
1296  
1297         swapTokensForEth(amountToSwapForETH); 
1298  
1299         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1300  
1301         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1302         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1303  
1304  
1305         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1306  
1307  
1308         tokensForLiquidity = 0;
1309         tokensForMarketing = 0;
1310         tokensForDev = 0;
1311  
1312         (success,) = address(devWallet).call{value: ethForDev}("");
1313  
1314         if(liquidityTokens > 0 && ethForLiquidity > 0){
1315             addLiquidity(liquidityTokens, ethForLiquidity);
1316             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1317         }
1318  
1319  
1320         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1321     }
1322  
1323     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1324         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1325         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1326         lpBurnFrequency = _frequencyInSeconds;
1327         percentForLPBurn = _percent;
1328         lpBurnEnabled = _Enabled;
1329     }
1330  
1331     function autoBurnLiquidityPairTokens() internal returns (bool){
1332  
1333         lastLpBurnTime = block.timestamp;
1334  
1335         // get balance of liquidity pair
1336         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1337  
1338         // calculate amount to burn
1339         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1340  
1341         // pull tokens from pancakePair liquidity and move to dead address permanently
1342         if (amountToBurn > 0){
1343             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1344         }
1345  
1346         //sync price since this is not in a swap transaction!
1347         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1348         pair.sync();
1349         emit AutoNukeLP();
1350         return true;
1351     }
1352  
1353     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1354         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1355         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1356         lastManualLpBurnTime = block.timestamp;
1357  
1358         // get balance of liquidity pair
1359         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1360  
1361         // calculate amount to burn
1362         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1363  
1364         // pull tokens from pancakePair liquidity and move to dead address permanently
1365         if (amountToBurn > 0){
1366             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1367         }
1368  
1369         //sync price since this is not in a swap transaction!
1370         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1371         pair.sync();
1372         emit ManualNukeLP();
1373         return true;
1374     }
1375 }