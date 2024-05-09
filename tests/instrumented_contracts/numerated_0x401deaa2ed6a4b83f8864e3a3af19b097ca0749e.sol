1 // https://scamspumpthehardest.com/
2 // https://twitter.com/SCAMPcoin
3 // https://t.me/scampportal
4 
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.13;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14  
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20  
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24  
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31  
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35  
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39  
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41  
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52  
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61  
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67  
68     function initialize(address, address) external;
69 }
70  
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73  
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76  
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80  
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82  
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86  
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence....
90      */
91     function totalSupply() external view returns (uint256);
92  
93     /**
94      * @dev Returns the amount of tokens owned by `account`...
95      */
96     function balanceOf(address account) external view returns (uint256);
97  
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106  
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115  
116     /**
117      *
118      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address spender, uint256 amount) external returns (bool);
123  
124     /**
125      * @dev Moves `amount` tokens from `sender` to `recipient` using the
126      * allowance mechanism. `amount` is then deducted from the caller's
127      * allowance.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address sender,
135         address recipient,
136         uint256 amount
137     ) external returns (bool);
138  
139     /**
140      * @dev Emitted when `value` tokens are moved from one account (`from`) to
141      * another (`to`).
142      *
143      * Note that `value` may be zero.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 value);
146  
147     /**
148      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
149      * a call to {approve}. `value` is the new allowance.
150      */
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153  
154 interface IERC20Metadata is IERC20 {
155     /**
156      * @dev Returns the name of the token.
157      */
158     function name() external view returns (string memory);
159  
160     /**
161      * @dev Returns the symbol of the token.
162      */
163     function symbol() external view returns (string memory);
164  
165     /**
166      * @dev Returns the decimals places of the token.
167      */
168     function decimals() external view returns (uint8);
169 }
170  
171  
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     using SafeMath for uint256;
174  
175     mapping(address => uint256) private _balances;
176  
177     mapping(address => mapping(address => uint256)) private _allowances;
178  
179     uint256 private _totalSupply;
180  
181     string private _name;
182     string private _symbol;
183  
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The default value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197  
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204  
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212  
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229  
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236  
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243  
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `recipient` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256  
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263  
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 amount) public virtual override returns (bool) {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275  
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * Requirements:
283      *
284      * - `sender` and `recipient` cannot be the zero address.
285      * - `sender` must have a balance of at least `amount`.
286      * - the caller must have allowance for ``sender``'s tokens of at least
287      * `amount`.
288      */
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) public virtual override returns (bool) {
294         _transfer(sender, recipient, amount);
295         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
296         return true;
297     }
298  
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
313         return true;
314     }
315  
316     /**
317      * @dev Atomically decreases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      * - `spender` must have allowance for the caller of at least
328      * `subtractedValue`.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
332         return true;
333     }
334  
335     /**
336      * @dev Moves tokens `amount` from `sender` to `recipient`.
337      *
338      * This is internal function is equivalent to {transfer}, and can be used to
339      * e.g. implement automatic token fees, slashing mechanisms, etc.
340      *
341      * Emits a {Transfer} event.
342      *
343      * Requirements:
344      *
345      * - `sender` cannot be the zero address.
346      * - `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      */
349     function _transfer(
350         address sender,
351         address recipient,
352         uint256 amount
353     ) internal virtual {
354         require(sender != address(0), "ERC20: transfer from the zero address");
355         require(recipient != address(0), "ERC20: transfer to the zero address");
356  
357         _beforeTokenTransfer(sender, recipient, amount);
358  
359         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
360         _balances[recipient] = _balances[recipient].add(amount);
361         emit Transfer(sender, recipient, amount);
362     }
363  
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375  
376         _beforeTokenTransfer(address(0), account, amount);
377  
378         _totalSupply = _totalSupply.add(amount);
379         _balances[account] = _balances[account].add(amount);
380         emit Transfer(address(0), account, amount);
381     }
382  
383     /**
384      * @dev Destroys `amount` tokens from `account`, reducing the
385      * total supply.
386      *
387      * Emits a {Transfer} event with `to` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      * - `account` must have at least `amount` tokens.
393      */
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396  
397         _beforeTokenTransfer(account, address(0), amount);
398  
399         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
400         _totalSupply = _totalSupply.sub(amount);
401         emit Transfer(account, address(0), amount);
402     }
403  
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
406      *
407      * This internal function is equivalent to `approve`, and can be used to
408      * e.g. set automatic allowances for certain subsystems, etc.
409      *
410      * Emits an {Approval} event.
411      *
412      * Requirements:
413      *
414      * - `owner` cannot be the zero address.
415      * - `spender` cannot be the zero address.
416      */
417     function _approve(
418         address owner,
419         address spender,
420         uint256 amount
421     ) internal virtual {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424  
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428  
429     /**
430      * @dev Hook that is called before any transfer of tokens. This includes
431      * minting and burning.
432      *
433      * Calling conditions:
434      *
435      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
436      * will be to transferred to `to`.
437      * - when `from` is zero, `amount` tokens will be minted for `to`.
438      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
439      * - `from` and `to` are never both zero.
440      *
441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
442      */
443     function _beforeTokenTransfer(
444         address from,
445         address to,
446         uint256 amount
447     ) internal virtual {}
448 }
449  
450 library SafeMath {
451     /**
452      * @dev Returns the addition of two unsigned integers, reverting on
453      * overflow.
454      *
455      * Counterpart to Solidity's `+` operator.
456      *
457      * Requirements:
458      *
459      * - Addition cannot overflow.
460      */
461     function add(uint256 a, uint256 b) internal pure returns (uint256) {
462         uint256 c = a + b;
463         require(c >= a, "SafeMath: addition overflow");
464  
465         return c;
466     }
467  
468     /**
469      * @dev Returns the subtraction of two unsigned integers, reverting on
470      * overflow (when the result is negative).
471      *
472      * Counterpart to Solidity's `-` operator.
473      *
474      * Requirements:
475      *
476      * - Subtraction cannot overflow.
477      */
478     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479         return sub(a, b, "SafeMath: subtraction overflow");
480     }
481  
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
493         require(b <= a, errorMessage);
494         uint256 c = a - b;
495  
496         return c;
497     }
498  
499     /**
500      * @dev Returns the multiplication of two unsigned integers, reverting on
501      * overflow.
502      *
503      * Counterpart to Solidity's `*` operator.
504      *
505      * Requirements:
506      *
507      * - Multiplication cannot overflow.
508      */
509     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
510         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
511         // benefit is lost if 'b' is also tested.
512         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
513         if (a == 0) {
514             return 0;
515         }
516  
517         uint256 c = a * b;
518         require(c / a == b, "SafeMath: multiplication overflow");
519  
520         return c;
521     }
522  
523     /**
524      * @dev Returns the integer division of two unsigned integers. Reverts on
525      * division by zero. The result is rounded towards zero.
526      *
527      * Counterpart to Solidity's `/` operator. Note: this function uses a
528      * `revert` opcode (which leaves remaining gas untouched) while Solidity
529      * uses an invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function div(uint256 a, uint256 b) internal pure returns (uint256) {
536         return div(a, b, "SafeMath: division by zero");
537     }
538  
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b > 0, errorMessage);
553         uint256 c = a / b;
554         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
555  
556         return c;
557     }
558  
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
561      * Reverts when dividing by zero.
562      *
563      * Counterpart to Solidity's `%` operator. This function uses a `revert`
564      * opcode (which leaves remaining gas untouched) while Solidity uses an
565      * invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
572         return mod(a, b, "SafeMath: modulo by zero");
573     }
574  
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts with custom message when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
588         require(b != 0, errorMessage);
589         return a % b;
590     }
591 }
592  
593 contract Ownable is Context {
594     address private _owner;
595  
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597  
598     /**
599      * @dev Initializes the contract setting the deployer as the initial owner.
600      */
601     constructor () {
602         address msgSender = _msgSender();
603         _owner = msgSender;
604         emit OwnershipTransferred(address(0), msgSender);
605     }
606  
607     /**
608      * @dev Returns the address of the current owner.
609      */
610     function owner() public view returns (address) {
611         return _owner;
612     }
613  
614     /**
615      * @dev Throws if called by any account other than the owner.
616      */
617     modifier onlyOwner() {
618         require(_owner == _msgSender(), "Ownable: caller is not the owner");
619         _;
620     }
621  
622     /**
623      * @dev Leaves the contract without owner. It will not be possible to call
624      * `onlyOwner` functions anymore. Can only be called by the current owner.
625      *
626      * NOTE: Renouncing ownership will leave the contract without an owner,
627      * thereby removing any functionality that is only available to the owner.
628      */
629     function renounceOwnership() public virtual onlyOwner {
630         emit OwnershipTransferred(_owner, address(0));
631         _owner = address(0);
632     }
633  
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      * Can only be called by the current owner.
637      */
638     function transferOwnership(address newOwner) public virtual onlyOwner {
639         require(newOwner != address(0), "Ownable: new owner is the zero address");
640         emit OwnershipTransferred(_owner, newOwner);
641         _owner = newOwner;
642     }
643 }
644  
645  
646  
647 library SafeMathInt {
648     int256 private constant MIN_INT256 = int256(1) << 255;
649     int256 private constant MAX_INT256 = ~(int256(1) << 255);
650  
651     /**
652      * @dev Multiplies two int256 variables and fails on overflow.
653      */
654     function mul(int256 a, int256 b) internal pure returns (int256) {
655         int256 c = a * b;
656  
657         // Detect overflow when multiplying MIN_INT256 with -1
658         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
659         require((b == 0) || (c / b == a));
660         return c;
661     }
662  
663     /**
664      * @dev Division of two int256 variables and fails on overflow.
665      */
666     function div(int256 a, int256 b) internal pure returns (int256) {
667         // Prevent overflow when dividing MIN_INT256 by -1
668         require(b != -1 || a != MIN_INT256);
669  
670         // Solidity already throws when dividing by 0.
671         return a / b;
672     }
673  
674     /**
675      * @dev Subtracts two int256 variables and fails on overflow.
676      */
677     function sub(int256 a, int256 b) internal pure returns (int256) {
678         int256 c = a - b;
679         require((b >= 0 && c <= a) || (b < 0 && c > a));
680         return c;
681     }
682  
683     /**
684      * @dev Adds two int256 variables and fails on overflow.
685      */
686     function add(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a + b;
688         require((b >= 0 && c >= a) || (b < 0 && c < a));
689         return c;
690     }
691  
692     /**
693      * @dev Converts to absolute value, and fails on overflow.
694      */
695     function abs(int256 a) internal pure returns (int256) {
696         require(a != MIN_INT256);
697         return a < 0 ? -a : a;
698     }
699  
700  
701     function toUint256Safe(int256 a) internal pure returns (uint256) {
702         require(a >= 0);
703         return uint256(a);
704     }
705 }
706  
707 library SafeMathUint {
708   function toInt256Safe(uint256 a) internal pure returns (int256) {
709     int256 b = int256(a);
710     require(b >= 0);
711     return b;
712   }
713 }
714  
715  
716 interface IUniswapV2Router01 {
717     function factory() external pure returns (address);
718     function WETH() external pure returns (address);
719  
720     function addLiquidity(
721         address tokenA,
722         address tokenB,
723         uint amountADesired,
724         uint amountBDesired,
725         uint amountAMin,
726         uint amountBMin,
727         address to,
728         uint deadline
729     ) external returns (uint amountA, uint amountB, uint liquidity);
730     function addLiquidityETH(
731         address token,
732         uint amountTokenDesired,
733         uint amountTokenMin,
734         uint amountETHMin,
735         address to,
736         uint deadline
737     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
738     function removeLiquidity(
739         address tokenA,
740         address tokenB,
741         uint liquidity,
742         uint amountAMin,
743         uint amountBMin,
744         address to,
745         uint deadline
746     ) external returns (uint amountA, uint amountB);
747     function removeLiquidityETH(
748         address token,
749         uint liquidity,
750         uint amountTokenMin,
751         uint amountETHMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountToken, uint amountETH);
755     function removeLiquidityWithPermit(
756         address tokenA,
757         address tokenB,
758         uint liquidity,
759         uint amountAMin,
760         uint amountBMin,
761         address to,
762         uint deadline,
763         bool approveMax, uint8 v, bytes32 r, bytes32 s
764     ) external returns (uint amountA, uint amountB);
765     function removeLiquidityETHWithPermit(
766         address token,
767         uint liquidity,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline,
772         bool approveMax, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint amountToken, uint amountETH);
774     function swapExactTokensForTokens(
775         uint amountIn,
776         uint amountOutMin,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external returns (uint[] memory amounts);
781     function swapTokensForExactTokens(
782         uint amountOut,
783         uint amountInMax,
784         address[] calldata path,
785         address to,
786         uint deadline
787     ) external returns (uint[] memory amounts);
788     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
789         external
790         payable
791         returns (uint[] memory amounts);
792     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
793         external
794         returns (uint[] memory amounts);
795     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
796         external
797         returns (uint[] memory amounts);
798     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
799         external
800         payable
801         returns (uint[] memory amounts);
802  
803     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
804     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
805     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
806     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
807     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
808 }
809  
810 interface IUniswapV2Router02 is IUniswapV2Router01 {
811     function removeLiquidityETHSupportingFeeOnTransferTokens(
812         address token,
813         uint liquidity,
814         uint amountTokenMin,
815         uint amountETHMin,
816         address to,
817         uint deadline
818     ) external returns (uint amountETH);
819     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline,
826         bool approveMax, uint8 v, bytes32 r, bytes32 s
827     ) external returns (uint amountETH);
828  
829     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
830         uint amountIn,
831         uint amountOutMin,
832         address[] calldata path,
833         address to,
834         uint deadline
835     ) external;
836     function swapExactETHForTokensSupportingFeeOnTransferTokens(
837         uint amountOutMin,
838         address[] calldata path,
839         address to,
840         uint deadline
841     ) external payable;
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external;
849 }
850  
851 contract SCAMP is ERC20, Ownable {
852     using SafeMath for uint256;
853  
854     IUniswapV2Router02 public immutable uniswapV2Router;
855     address public immutable uniswapV2Pair;
856  
857     bool private swapping;
858  
859     address private devOpsWallet;
860  
861     uint256 public maxTransactionAmount;
862     uint256 public swapTokensAtAmount;
863     uint256 public maxWallet;
864  
865     bool public limitsInEffect = true;
866     bool public tradingActive = false;
867     bool public swapEnabled = false;
868     bool public enableEarlySellTax = true;
869  
870      // Anti-bot and anti-whale mappings and variables
871     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
872  
873     // Seller Map
874     mapping (address => uint256) private _holderFirstBuyTimestamp;
875  
876     // Blacklist Map
877     mapping (address => bool) private _blacklist;
878     bool public transferDelayEnabled = true;
879  
880     uint256 public buyTotalFees;
881     uint256 public buyDevOpsFee;
882     uint256 public buyLiquidityFee;
883  
884     uint256 public sellTotalFees;
885     uint256 public sellDevOpsFee;
886     uint256 public sellLiquidityFee;
887  
888     uint256 public earlySellLiquidityFee;
889     uint256 public earlySellDevOpsFee;
890  
891     uint256 public tokensForDevOps;
892     uint256 public tokensForLiquidity;
893     uint256 public tokensForDev;
894  
895     // block number of opened trading
896     uint256 launchedAt;
897  
898     /******************/
899  
900     // exclude from fees and max transaction amount
901     mapping (address => bool) private _isExcludedFromFees;
902     mapping (address => bool) public _isExcludedMaxTransactionAmount;
903  
904     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
905     // could be subject to a maximum transfer amount
906     mapping (address => bool) public automatedMarketMakerPairs;
907  
908     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
909  
910     event ExcludeFromFees(address indexed account, bool isExcluded);
911  
912     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
913  
914     event devOpsWalletUpdated(address indexed newWallet, address indexed oldWallet);
915  
916  
917     event SwapAndLiquify(
918         uint256 tokensSwapped,
919         uint256 ethReceived,
920         uint256 tokensIntoLiquidity
921     );
922  
923     event AutoNukeLP();
924  
925     event ManualNukeLP();
926  
927     constructor() ERC20("scams pump the hardest", "SCAMP") {
928  
929         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
930  
931         excludeFromMaxTransaction(address(_uniswapV2Router), true);
932         uniswapV2Router = _uniswapV2Router;
933  
934         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
935         excludeFromMaxTransaction(address(uniswapV2Pair), true);
936         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
937  
938         uint256 _buyDevOpsFee = 0;
939         uint256 _buyLiquidityFee = 0;
940  
941         uint256 _sellDevOpsFee = 0;
942         uint256 _sellLiquidityFee = 0;
943  
944         uint256 _earlySellLiquidityFee = 0;
945         uint256 _earlySellDevOpsFee = 0;
946  
947         uint256 totalSupply = 1 * 1e13 * 1e18;
948  
949         maxTransactionAmount = totalSupply * 30 / 1000; // 3% maxTransactionAmountTxn
950         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
951         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
952  
953         buyDevOpsFee = _buyDevOpsFee;
954         buyLiquidityFee = _buyLiquidityFee;
955         buyTotalFees = buyDevOpsFee + buyLiquidityFee;
956  
957         sellDevOpsFee = _sellDevOpsFee;
958         sellLiquidityFee = _sellLiquidityFee;
959         sellTotalFees = sellDevOpsFee + sellLiquidityFee;
960  
961         earlySellLiquidityFee = _earlySellLiquidityFee;
962         earlySellDevOpsFee = _earlySellDevOpsFee;
963  
964         devOpsWallet = address(0x4cAFFc4388F856Ca99a96186E30aF6C05981d14d); // set as devOps wallet
965  
966         // exclude from paying fees or having max transaction amount
967         excludeFromFees(owner(), true);
968         excludeFromFees(address(this), true);
969         excludeFromFees(address(0xdead), true);
970         excludeFromFees(address(0x4cAFFc4388F856Ca99a96186E30aF6C05981d14d), true);
971  
972         excludeFromMaxTransaction(owner(), true);
973         excludeFromMaxTransaction(address(this), true);
974         excludeFromMaxTransaction(address(0xdead), true);
975         excludeFromMaxTransaction(address(0x4cAFFc4388F856Ca99a96186E30aF6C05981d14d), true);
976  
977         /*
978             _mint is an internal function in ERC20.sol that is only called here,
979             and CANNOT be called ever again
980         */
981         _mint(msg.sender, totalSupply);
982     }
983  
984     receive() external payable {
985  
986     }
987  
988     // once enabled, can never be turned off
989     function enableTrading() external onlyOwner {
990         tradingActive = true;
991         swapEnabled = true;
992         launchedAt = block.number;
993     }
994  
995     // remove limits after token is stable
996     function removeLimits() external onlyOwner returns (bool){
997         limitsInEffect = false;
998         return true;
999     }
1000  
1001     // disable Transfer delay - cannot be reenabled
1002     function disableTransferDelay() external onlyOwner returns (bool){
1003         transferDelayEnabled = false;
1004         return true;
1005     }
1006  
1007     function setEarlySellTax(bool onoff) external onlyOwner  {
1008         enableEarlySellTax = onoff;
1009     }
1010  
1011      // change the minimum amount of tokens to sell from fees
1012     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1013         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1014         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1015         swapTokensAtAmount = newAmount;
1016         return true;
1017     }
1018  
1019     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1020         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1021         maxTransactionAmount = newNum * (10**18);
1022     }
1023  
1024     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1025         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1026         maxWallet = newNum * (10**18);
1027     }
1028  
1029     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1030         _isExcludedMaxTransactionAmount[updAds] = isEx;
1031     }
1032  
1033     // only use to disable contract sales if absolutely necessary (emergency use only)
1034     function updateSwapEnabled(bool enabled) external onlyOwner(){
1035         swapEnabled = enabled;
1036     }
1037  
1038     function updateBuyFees(uint256 _devOpsFee, uint256 _liquidityFee) external onlyOwner {
1039         buyDevOpsFee = _devOpsFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buyTotalFees = buyDevOpsFee + buyLiquidityFee;
1042         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1043     }
1044  
1045     function updateSellFees(uint256 _devOpsFee, uint256 _liquidityFee, uint256 _earlySellLiquidityFee, uint256 _earlySellDevOpsFee) external onlyOwner {
1046         sellDevOpsFee = _devOpsFee;
1047         sellLiquidityFee = _liquidityFee;
1048         earlySellLiquidityFee = _earlySellLiquidityFee;
1049         earlySellDevOpsFee = _earlySellDevOpsFee;
1050         sellTotalFees = sellDevOpsFee + sellLiquidityFee;
1051         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1052     }
1053  
1054     function excludeFromFees(address account, bool excluded) public onlyOwner {
1055         _isExcludedFromFees[account] = excluded;
1056         emit ExcludeFromFees(account, excluded);
1057     }
1058  
1059     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1060         require(block.number < launchedAt + 40, "Waited too long to blacklist");
1061         _blacklist[account] = isBlacklisted;
1062     }
1063  
1064     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1065         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1066  
1067         _setAutomatedMarketMakerPair(pair, value);
1068     }
1069  
1070     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1071         automatedMarketMakerPairs[pair] = value;
1072  
1073         emit SetAutomatedMarketMakerPair(pair, value);
1074     }
1075  
1076     function updateDevOpsWallet(address newDevOpsWallet) external onlyOwner {
1077         emit devOpsWalletUpdated(newDevOpsWallet, devOpsWallet);
1078         devOpsWallet = newDevOpsWallet;
1079     }
1080  
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
1138         // early sell logic
1139         bool isBuy = from == uniswapV2Pair;
1140         if (!isBuy && enableEarlySellTax) {
1141             if (_holderFirstBuyTimestamp[from] != 0 &&
1142                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1143                 sellLiquidityFee = earlySellLiquidityFee;
1144                 sellDevOpsFee = earlySellDevOpsFee;
1145                 sellTotalFees = sellDevOpsFee + sellLiquidityFee;
1146             } 
1147         } else {
1148             if (_holderFirstBuyTimestamp[to] == 0) {
1149                 _holderFirstBuyTimestamp[to] = block.timestamp;
1150             }
1151         }
1152  
1153         uint256 contractTokenBalance = balanceOf(address(this));
1154  
1155         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1156  
1157         if( 
1158             canSwap &&
1159             swapEnabled &&
1160             !swapping &&
1161             !automatedMarketMakerPairs[from] &&
1162             !_isExcludedFromFees[from] &&
1163             !_isExcludedFromFees[to]
1164         ) {
1165             swapping = true;
1166  
1167             swapBack();
1168  
1169             swapping = false;
1170         }
1171  
1172         bool takeFee = !swapping;
1173  
1174         // if any account belongs to _isExcludedFromFee account then remove the fee
1175         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1176             takeFee = false;
1177         }
1178  
1179         uint256 fees = 0;
1180         // only take fees on buys/sells, do not take on wallet transfers
1181         if(takeFee){
1182             // on sell
1183             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1184                 fees = amount.mul(sellTotalFees).div(100);
1185                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1186                 tokensForDevOps += fees * sellDevOpsFee / sellTotalFees;
1187             }
1188             // on buy
1189             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1190                 fees = amount.mul(buyTotalFees).div(100);
1191                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1192                 tokensForDevOps += fees * buyDevOpsFee / buyTotalFees;
1193             }
1194  
1195             if(fees > 0){    
1196                 super._transfer(from, address(this), fees);
1197             }
1198  
1199             amount -= fees;
1200         }
1201  
1202         super._transfer(from, to, amount);
1203     }
1204  
1205     function swapTokensForEth(uint256 tokenAmount) private {
1206  
1207         // generate the uniswap pair path of token -> weth
1208         address[] memory path = new address[](2);
1209         path[0] = address(this);
1210         path[1] = uniswapV2Router.WETH();
1211  
1212         _approve(address(this), address(uniswapV2Router), tokenAmount);
1213  
1214         // make the swap
1215         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1216             tokenAmount,
1217             0, // accept any amount of ETH
1218             path,
1219             address(this),
1220             block.timestamp
1221         );
1222  
1223     }
1224  
1225     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1226         // approve token transfer to cover all possible scenarios
1227         _approve(address(this), address(uniswapV2Router), tokenAmount);
1228  
1229         // add the liquidity
1230         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1231             address(this),
1232             tokenAmount,
1233             0, // slippage is unavoidable
1234             0, // slippage is unavoidable
1235             address(this),
1236             block.timestamp
1237         );
1238     }
1239  
1240     function swapBack() private {
1241         uint256 contractBalance = balanceOf(address(this));
1242         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDevOps + tokensForDev;
1243         bool success;
1244  
1245         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1246  
1247         if(contractBalance > swapTokensAtAmount * 20){
1248           contractBalance = swapTokensAtAmount * 20;
1249         }
1250  
1251         // Halve the amount of liquidity tokens
1252         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1253         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1254  
1255         uint256 initialETHBalance = address(this).balance;
1256  
1257         swapTokensForEth(amountToSwapForETH); 
1258  
1259         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1260  
1261         uint256 ethForDevOps = ethBalance.mul(tokensForDevOps).div(totalTokensToSwap);
1262         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1263         uint256 ethForLiquidity = ethBalance - ethForDevOps - ethForDev;
1264  
1265  
1266         tokensForLiquidity = 0;
1267         tokensForDevOps = 0;
1268         tokensForDev = 0;
1269  
1270         if(liquidityTokens > 0 && ethForLiquidity > 0){
1271             addLiquidity(liquidityTokens, ethForLiquidity);
1272             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1273         }
1274  
1275         (success,) = address(devOpsWallet).call{value: address(this).balance}("");
1276     }
1277 
1278 }