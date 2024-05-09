1 // https://t.me/flokariumofficial
2 // https://flokarium.com/
3 // https://twitter.com/flokarium
4 
5 // SPDX-License-Identifier: Unlicensed                                                                         
6  
7 pragma solidity 0.8.17;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13  
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19  
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23  
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30  
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34  
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38  
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40  
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92  
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
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
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131  
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146  
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154  
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161  
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167  
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172  
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178  
179  
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     using SafeMath for uint256;
182  
183     mapping(address => uint256) private _balances;
184  
185     mapping(address => mapping(address => uint256)) private _allowances;
186  
187     uint256 private _totalSupply;
188  
189     string private _name;
190     string private _symbol;
191  
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205  
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212  
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220  
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 18;
236     }
237  
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244  
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251  
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264  
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271  
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283  
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
304         return true;
305     }
306  
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
321         return true;
322     }
323  
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342  
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364  
365         _beforeTokenTransfer(sender, recipient, amount);
366  
367         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
368         _balances[recipient] = _balances[recipient].add(amount);
369         emit Transfer(sender, recipient, amount);
370     }
371  
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383  
384         _beforeTokenTransfer(address(0), account, amount);
385  
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390  
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404  
405         _beforeTokenTransfer(account, address(0), amount);
406  
407         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
408         _totalSupply = _totalSupply.sub(amount);
409         emit Transfer(account, address(0), amount);
410     }
411  
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432  
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436  
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be to transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 }
457  
458 library SafeMath {
459     /**
460      * @dev Returns the addition of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `+` operator.
464      *
465      * Requirements:
466      *
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472  
473         return c;
474     }
475  
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487         return sub(a, b, "SafeMath: subtraction overflow");
488     }
489  
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b <= a, errorMessage);
502         uint256 c = a - b;
503  
504         return c;
505     }
506  
507     /**
508      * @dev Returns the multiplication of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `*` operator.
512      *
513      * Requirements:
514      *
515      * - Multiplication cannot overflow.
516      */
517     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
519         // benefit is lost if 'b' is also tested.
520         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
521         if (a == 0) {
522             return 0;
523         }
524  
525         uint256 c = a * b;
526         require(c / a == b, "SafeMath: multiplication overflow");
527  
528         return c;
529     }
530  
531     /**
532      * @dev Returns the integer division of two unsigned integers. Reverts on
533      * division by zero. The result is rounded towards zero.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         return div(a, b, "SafeMath: division by zero");
545     }
546  
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b > 0, errorMessage);
561         uint256 c = a / b;
562         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
563  
564         return c;
565     }
566  
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * Reverts when dividing by zero.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
580         return mod(a, b, "SafeMath: modulo by zero");
581     }
582  
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * Reverts with custom message when dividing by zero.
586      *
587      * Counterpart to Solidity's `%` operator. This function uses a `revert`
588      * opcode (which leaves remaining gas untouched) while Solidity uses an
589      * invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b != 0, errorMessage);
597         return a % b;
598     }
599 }
600  
601 contract Ownable is Context {
602     address private _owner;
603  
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605  
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () {
610         address msgSender = _msgSender();
611         _owner = msgSender;
612         emit OwnershipTransferred(address(0), msgSender);
613     }
614  
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621  
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(_owner == _msgSender(), "Ownable: caller is not the owner");
627         _;
628     }
629  
630     /**
631      * @dev Leaves the contract without owner. It will not be possible to call
632      * `onlyOwner` functions anymore. Can only be called by the current owner.
633      *
634      * NOTE: Renouncing ownership will leave the contract without an owner,
635      * thereby removing any functionality that is only available to the owner.
636      */
637     function renounceOwnership() public virtual onlyOwner {
638         emit OwnershipTransferred(_owner, address(0));
639         _owner = address(0);
640     }
641  
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Can only be called by the current owner.
645      */
646     function transferOwnership(address newOwner) public virtual onlyOwner {
647         require(newOwner != address(0), "Ownable: new owner is the zero address");
648         emit OwnershipTransferred(_owner, newOwner);
649         _owner = newOwner;
650     }
651 }
652  
653  
654  
655 library SafeMathInt {
656     int256 private constant MIN_INT256 = int256(1) << 255;
657     int256 private constant MAX_INT256 = ~(int256(1) << 255);
658  
659     /**
660      * @dev Multiplies two int256 variables and fails on overflow.
661      */
662     function mul(int256 a, int256 b) internal pure returns (int256) {
663         int256 c = a * b;
664  
665         // Detect overflow when multiplying MIN_INT256 with -1
666         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
667         require((b == 0) || (c / b == a));
668         return c;
669     }
670  
671     /**
672      * @dev Division of two int256 variables and fails on overflow.
673      */
674     function div(int256 a, int256 b) internal pure returns (int256) {
675         // Prevent overflow when dividing MIN_INT256 by -1
676         require(b != -1 || a != MIN_INT256);
677  
678         // Solidity already throws when dividing by 0.
679         return a / b;
680     }
681  
682     /**
683      * @dev Subtracts two int256 variables and fails on overflow.
684      */
685     function sub(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a - b;
687         require((b >= 0 && c <= a) || (b < 0 && c > a));
688         return c;
689     }
690  
691     /**
692      * @dev Adds two int256 variables and fails on overflow.
693      */
694     function add(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a + b;
696         require((b >= 0 && c >= a) || (b < 0 && c < a));
697         return c;
698     }
699  
700     /**
701      * @dev Converts to absolute value, and fails on overflow.
702      */
703     function abs(int256 a) internal pure returns (int256) {
704         require(a != MIN_INT256);
705         return a < 0 ? -a : a;
706     }
707  
708  
709     function toUint256Safe(int256 a) internal pure returns (uint256) {
710         require(a >= 0);
711         return uint256(a);
712     }
713 }
714  
715 library SafeMathUint {
716   function toInt256Safe(uint256 a) internal pure returns (int256) {
717     int256 b = int256(a);
718     require(b >= 0);
719     return b;
720   }
721 }
722  
723  
724 interface IUniswapV2Router01 {
725     function factory() external pure returns (address);
726     function WETH() external pure returns (address);
727  
728     function addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint amountADesired,
732         uint amountBDesired,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountA, uint amountB, uint liquidity);
738     function addLiquidityETH(
739         address token,
740         uint amountTokenDesired,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline
745     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
746     function removeLiquidity(
747         address tokenA,
748         address tokenB,
749         uint liquidity,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETH(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountToken, uint amountETH);
763     function removeLiquidityWithPermit(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountToken, uint amountETH);
782     function swapExactTokensForTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapTokensForExactTokens(
790         uint amountOut,
791         uint amountInMax,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810  
811     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
812     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
814     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
815     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
816 }
817  
818 interface IUniswapV2Router02 is IUniswapV2Router01 {
819     function removeLiquidityETHSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline
826     ) external returns (uint amountETH);
827     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountETH);
836  
837     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
838         uint amountIn,
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external;
844     function swapExactETHForTokensSupportingFeeOnTransferTokens(
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external payable;
850     function swapExactTokensForETHSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857 }
858  
859 contract Flokarium is ERC20, Ownable {
860     using SafeMath for uint256;
861  
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
865  
866     bool private swapping;
867  
868     address public marketingWallet;
869     address public devWallet;
870  
871     uint256 public maxTransactionAmount;
872     uint256 public swapTokensAtAmount;
873     uint256 public maxWallet;
874  
875     uint256 public percentForLPBurn = 25; // 25 = .25%
876     bool public lpBurnEnabled = true;
877     uint256 public lpBurnFrequency = 7200 seconds;
878     uint256 public lastLpBurnTime;
879  
880     uint256 public manualBurnFrequency = 30 minutes;
881     uint256 public lastManualLpBurnTime;
882  
883     bool public limitsInEffect = true;
884     bool public tradingActive = false;
885     bool public swapEnabled = false;
886     bool public enableEarlySellTax = true;
887  
888      // Anti-bot and anti-whale mappings and variables
889     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
890  
891     // Seller Map
892     mapping (address => uint256) private _holderFirstBuyTimestamp;
893  
894     // Blacklist Map
895     mapping (address => bool) private _blacklist;
896     bool public transferDelayEnabled = true;
897  
898     uint256 public buyTotalFees;
899     uint256 public buyMarketingFee;
900     uint256 public buyLiquidityFee;
901     uint256 public buyDevFee;
902  
903     uint256 public sellTotalFees;
904     uint256 public sellMarketingFee;
905     uint256 public sellLiquidityFee;
906     uint256 public sellDevFee;
907  
908     uint256 public earlySellLiquidityFee;
909     uint256 public earlySellMarketingFee;
910  
911     uint256 public tokensForMarketing;
912     uint256 public tokensForLiquidity;
913     uint256 public tokensForDev;
914  
915     // block number of opened trading
916     uint256 launchedAt;
917  
918     /******************/
919  
920     // exclude from fees and max transaction amount
921     mapping (address => bool) private _isExcludedFromFees;
922     mapping (address => bool) public _isExcludedMaxTransactionAmount;
923  
924     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
925     // could be subject to a maximum transfer amount
926     mapping (address => bool) public automatedMarketMakerPairs;
927  
928     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
929  
930     event ExcludeFromFees(address indexed account, bool isExcluded);
931  
932     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
933  
934     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
935  
936     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
937  
938     event SwapAndLiquify(
939         uint256 tokensSwapped,
940         uint256 ethReceived,
941         uint256 tokensIntoLiquidity
942     );
943  
944     event AutoNukeLP();
945  
946     event ManualNukeLP();
947  
948     constructor() ERC20("Flokarium", "FLOK") {
949  
950         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
951  
952         excludeFromMaxTransaction(address(_uniswapV2Router), true);
953         uniswapV2Router = _uniswapV2Router;
954  
955         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
956         excludeFromMaxTransaction(address(uniswapV2Pair), true);
957         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
958  
959         uint256 _buyMarketingFee = 10;
960         uint256 _buyLiquidityFee = 0;
961         uint256 _buyDevFee = 10;
962  
963         uint256 _sellMarketingFee = 20;
964         uint256 _sellLiquidityFee = 0;
965         uint256 _sellDevFee = 20;
966  
967         uint256 _earlySellLiquidityFee = 0;
968         uint256 _earlySellMarketingFee = 0;
969  
970         uint256 totalSupply = 10000 * 1e8 * 1e18;
971  
972         maxTransactionAmount = totalSupply * 15 / 1000; // 1% 
973         maxWallet = totalSupply * 30 / 1000; // 1.5% 
974         swapTokensAtAmount = totalSupply * 7 / 10000; // 0.07% 
975  
976         buyMarketingFee = _buyMarketingFee;
977         buyLiquidityFee = _buyLiquidityFee;
978         buyDevFee = _buyDevFee;
979         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
980  
981         sellMarketingFee = _sellMarketingFee;
982         sellLiquidityFee = _sellLiquidityFee;
983         sellDevFee = _sellDevFee;
984         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
985  
986         earlySellLiquidityFee = _earlySellLiquidityFee;
987         earlySellMarketingFee = _earlySellMarketingFee;
988  
989         marketingWallet = address(0x15c603d1E14dD47080B8ad68576a740c324c0e28); // set as marketing wallet
990         devWallet = address(0x40220aA612Ef322Db6fB69FFF5BE174FaB8F3249); // set as dev wallet
991  
992         // exclude from paying fees or having max transaction amount
993         excludeFromFees(owner(), true);
994         excludeFromFees(address(this), true);
995         excludeFromFees(address(0xdead), true);
996  
997         excludeFromMaxTransaction(owner(), true);
998         excludeFromMaxTransaction(address(this), true);
999         excludeFromMaxTransaction(address(0xdead), true);
1000  
1001         /*
1002             _mint is an internal function in ERC20.sol that is only called here,
1003             and CANNOT be called ever again
1004         */
1005         _mint(msg.sender, totalSupply);
1006     }
1007  
1008     receive() external payable {
1009  
1010   	}
1011  
1012     // once enabled, can never be turned off
1013     function enableTrading() external onlyOwner {
1014         tradingActive = true;
1015         swapEnabled = true;
1016         lastLpBurnTime = block.timestamp;
1017         launchedAt = block.number;
1018     }
1019  
1020     // remove limits after token is stable
1021     function removeLimits() external onlyOwner returns (bool){
1022         limitsInEffect = false;
1023         return true;
1024     }
1025  
1026     // disable Transfer delay - cannot be reenabled
1027     function disableTransferDelay() external onlyOwner returns (bool){
1028         transferDelayEnabled = false;
1029         return true;
1030     }
1031  
1032     function setEarlySellTax(bool onoff) external onlyOwner  {
1033         enableEarlySellTax = onoff;
1034     }
1035  
1036      // change the minimum amount of tokens to sell from fees
1037     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1038   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1039   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1040   	    swapTokensAtAmount = newAmount;
1041   	    return true;
1042   	}
1043  
1044     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1045         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1046         maxTransactionAmount = newNum * (10**18);
1047     }
1048  
1049     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1050         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
1051         maxWallet = newNum * (10**18);
1052     }
1053  
1054     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1055         _isExcludedMaxTransactionAmount[updAds] = isEx;
1056     }
1057  
1058     // only use to disable contract sales if absolutely necessary (emergency use only)
1059     function updateSwapEnabled(bool enabled) external onlyOwner(){
1060         swapEnabled = enabled;
1061     }
1062  
1063     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1064         buyMarketingFee = _marketingFee;
1065         buyLiquidityFee = _liquidityFee;
1066         buyDevFee = _devFee;
1067         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1068         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1069     }
1070  
1071     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1072         sellMarketingFee = _marketingFee;
1073         sellLiquidityFee = _liquidityFee;
1074         sellDevFee = _devFee;
1075         earlySellLiquidityFee = _earlySellLiquidityFee;
1076         earlySellMarketingFee = _earlySellMarketingFee;
1077         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1078         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1079     }
1080  
1081     function excludeFromFees(address account, bool excluded) public onlyOwner {
1082         _isExcludedFromFees[account] = excluded;
1083         emit ExcludeFromFees(account, excluded);
1084     }
1085  
1086     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1087         _blacklist[account] = isBlacklisted;
1088     }
1089  
1090     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1091         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1092  
1093         _setAutomatedMarketMakerPair(pair, value);
1094     }
1095  
1096     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1097         automatedMarketMakerPairs[pair] = value;
1098  
1099         emit SetAutomatedMarketMakerPair(pair, value);
1100     }
1101  
1102     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1103         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1104         marketingWallet = newMarketingWallet;
1105     }
1106  
1107     function updateDevWallet(address newWallet) external onlyOwner {
1108         emit devWalletUpdated(newWallet, devWallet);
1109         devWallet = newWallet;
1110     }
1111  
1112  
1113     function isExcludedFromFees(address account) public view returns(bool) {
1114         return _isExcludedFromFees[account];
1115     }
1116  
1117     event BoughtEarly(address indexed sniper);
1118  
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 amount
1123     ) internal override {
1124         require(from != address(0), "ERC20: transfer from the zero address");
1125         require(to != address(0), "ERC20: transfer to the zero address");
1126         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1127          if(amount == 0) {
1128             super._transfer(from, to, 0);
1129             return;
1130         }
1131  
1132         if(limitsInEffect){
1133             if (
1134                 from != owner() &&
1135                 to != owner() &&
1136                 to != address(0) &&
1137                 to != address(0xdead) &&
1138                 !swapping
1139             ){
1140                 if(!tradingActive){
1141                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1142                 }
1143  
1144                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1145                 if (transferDelayEnabled){
1146                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1147                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1148                         _holderLastTransferTimestamp[tx.origin] = block.number;
1149                     }
1150                 }
1151  
1152                 //when buy
1153                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1154                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1155                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1156                 }
1157  
1158                 //when sell
1159                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1160                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1161                 }
1162                 else if(!_isExcludedMaxTransactionAmount[to]){
1163                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1164                 }
1165             }
1166         }
1167  
1168         // anti bot logic
1169         if (block.number <= (launchedAt + 0) && 
1170                 to != uniswapV2Pair && 
1171                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1172             ) { 
1173             _blacklist[to] = false;
1174         }
1175  
1176 		uint256 contractTokenBalance = balanceOf(address(this));
1177  
1178         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1179  
1180         if( 
1181             canSwap &&
1182             swapEnabled &&
1183             !swapping &&
1184             !automatedMarketMakerPairs[from] &&
1185             !_isExcludedFromFees[from] &&
1186             !_isExcludedFromFees[to]
1187         ) {
1188             swapping = true;
1189  
1190             swapBack();
1191  
1192             swapping = false;
1193         }
1194  
1195         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1196             autoBurnLiquidityPairTokens();
1197         }
1198  
1199         bool takeFee = !swapping;
1200  
1201         // if any account belongs to _isExcludedFromFee account then remove the fee
1202         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1203             takeFee = false;
1204         }
1205  
1206         uint256 fees = 0;
1207         // only take fees on buys/sells, do not take on wallet transfers
1208         if(takeFee){
1209             // on sell
1210             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1211                 fees = amount.mul(sellTotalFees).div(100);
1212                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1213                 tokensForDev += fees * sellDevFee / sellTotalFees;
1214                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1215             }
1216             // on buy
1217             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1218         	    fees = amount.mul(buyTotalFees).div(100);
1219         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1220                 tokensForDev += fees * buyDevFee / buyTotalFees;
1221                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1222             }
1223  
1224             if(fees > 0){    
1225                 super._transfer(from, address(this), fees);
1226             }
1227  
1228         	amount -= fees;
1229         }
1230  
1231         super._transfer(from, to, amount);
1232     }
1233  
1234     function swapTokensForEth(uint256 tokenAmount) private {
1235  
1236         address[] memory path = new address[](2);
1237         path[0] = address(this);
1238         path[1] = uniswapV2Router.WETH();
1239  
1240         _approve(address(this), address(uniswapV2Router), tokenAmount);
1241  
1242         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1243             tokenAmount,
1244             0, // accept any amount of ETH
1245             path,
1246             address(this),
1247             block.timestamp
1248         );
1249  
1250     }
1251 
1252     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1253         _approve(address(this), address(uniswapV2Router), tokenAmount);
1254  
1255         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1256             address(this),
1257             tokenAmount,
1258             0, // slippage is unavoidable
1259             0, // slippage is unavoidable
1260             deadAddress,
1261             block.timestamp
1262         );
1263     }
1264  
1265     function swapBack() private {
1266         uint256 contractBalance = balanceOf(address(this));
1267         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1268         bool success;
1269  
1270         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1271  
1272         if(contractBalance > swapTokensAtAmount * 20){
1273           contractBalance = swapTokensAtAmount * 20;
1274         }
1275  
1276         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1277         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1278  
1279         uint256 initialETHBalance = address(this).balance;
1280  
1281         swapTokensForEth(amountToSwapForETH); 
1282  
1283         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1284  
1285         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1286         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1287  
1288  
1289         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1290  
1291  
1292         tokensForLiquidity = 0;
1293         tokensForMarketing = 0;
1294         tokensForDev = 0;
1295  
1296         (success,) = address(devWallet).call{value: ethForDev}("");
1297  
1298         if(liquidityTokens > 0 && ethForLiquidity > 0){
1299             addLiquidity(liquidityTokens, ethForLiquidity);
1300             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1301         }
1302  
1303  
1304         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1305     }
1306  
1307     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1308         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1309         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1310         lpBurnFrequency = _frequencyInSeconds;
1311         percentForLPBurn = _percent;
1312         lpBurnEnabled = _Enabled;
1313     }
1314  
1315     function autoBurnLiquidityPairTokens() internal returns (bool){
1316  
1317         lastLpBurnTime = block.timestamp;
1318  
1319         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1320  
1321         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1322  
1323         if (amountToBurn > 0){
1324             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1325         }
1326  
1327         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1328         pair.sync();
1329         emit AutoNukeLP();
1330         return true;
1331     }
1332  
1333     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1334         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1335         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1336         lastManualLpBurnTime = block.timestamp;
1337  
1338         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1339  
1340         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1341  
1342         if (amountToBurn > 0){
1343             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1344         }
1345  
1346         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1347         pair.sync();
1348         emit ManualNukeLP();
1349         return true;
1350     }
1351 }