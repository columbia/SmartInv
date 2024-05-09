1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-29
3 */
4 
5 //SPDX-License-Identifier: UNLICENCED
6 
7 
8 pragma solidity 0.8.9;
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
859 contract HARUINU is ERC20, Ownable {
860     using SafeMath for uint256;
861  
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864  
865     bool private swapping;
866  
867     address private marketingWallet;
868     address private devWallet;
869  
870     uint256 public maxTransactionAmount;
871     uint256 public swapTokensAtAmount;
872     uint256 public maxWallet;
873  
874     bool public limitsInEffect = true;
875     bool public tradingActive = false;
876     bool public swapEnabled = false;
877  
878      // Anti-bot and anti-whale mappings and variables
879     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
880  
881     // Seller Map
882     mapping (address => uint256) private _holderFirstBuyTimestamp;
883  
884     // Blacklist Map
885     mapping (address => bool) private _blacklist;
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
935     constructor() ERC20("HARU INU", "$HARU") {
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
946         uint256 _buyMarketingFee = 25;
947         uint256 _buyLiquidityFee = 0;
948         uint256 _buyDevFee = 0;
949  
950         uint256 _sellMarketingFee = 25;
951         uint256 _sellLiquidityFee = 0;
952         uint256 _sellDevFee = 0;
953  
954         uint256 totalSupply = 1 * 1e9 * 1e18;
955  
956         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
957         maxWallet = totalSupply * 20 / 1000; // 2% 
958         swapTokensAtAmount = totalSupply * 10 / 10000; // 5%
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
991     }
992  
993     // once enabled, can never be turned off
994     function enableTrading() external onlyOwner {
995         tradingActive = true;
996         swapEnabled = true;
997         launchedAt = block.number;
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
1014         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1015         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1016         swapTokensAtAmount = newAmount;
1017         return true;
1018     }
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
1034     function updateBuyFees(
1035         uint256 _devFee,
1036         uint256 _liquidityFee,
1037         uint256 _marketingFee
1038     ) external onlyOwner {
1039         buyDevFee = _devFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buyMarketingFee = _marketingFee;
1042         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1043         require(buyTotalFees <= 100);
1044     }
1045 
1046     function updateSellFees(
1047         uint256 _devFee,
1048         uint256 _liquidityFee,
1049         uint256 _marketingFee
1050     ) external onlyOwner {
1051         sellDevFee = _devFee;
1052         sellLiquidityFee = _liquidityFee;
1053         sellMarketingFee = _marketingFee;
1054         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1055         require(sellTotalFees <= 100);
1056     }
1057  
1058     // only use to disable contract sales if absolutely necessary (emergency use only)
1059     function updateSwapEnabled(bool enabled) external onlyOwner(){
1060         swapEnabled = enabled;
1061     }
1062  
1063     function excludeFromFees(address account, bool excluded) public onlyOwner {
1064         _isExcludedFromFees[account] = excluded;
1065         emit ExcludeFromFees(account, excluded);
1066     }
1067  
1068     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1069         _blacklist[account] = isBlacklisted;
1070     }
1071  
1072     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1073         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1074  
1075         _setAutomatedMarketMakerPair(pair, value);
1076     }
1077  
1078     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1079         automatedMarketMakerPairs[pair] = value;
1080  
1081         emit SetAutomatedMarketMakerPair(pair, value);
1082     }
1083  
1084     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1085         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1086         marketingWallet = newMarketingWallet;
1087     }
1088  
1089     function updateDevWallet(address newWallet) external onlyOwner {
1090         emit devWalletUpdated(newWallet, devWallet);
1091         devWallet = newWallet;
1092     }
1093  
1094  
1095     function isExcludedFromFees(address account) public view returns(bool) {
1096         return _isExcludedFromFees[account];
1097     }
1098  
1099     function _transfer(
1100         address from,
1101         address to,
1102         uint256 amount
1103     ) internal override {
1104         require(from != address(0), "ERC20: transfer from the zero address");
1105         require(to != address(0), "ERC20: transfer to the zero address");
1106         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1107          if(amount == 0) {
1108             super._transfer(from, to, 0);
1109             return;
1110         }
1111  
1112         if(limitsInEffect){
1113             if (
1114                 from != owner() &&
1115                 to != owner() &&
1116                 to != address(0) &&
1117                 to != address(0xdead) &&
1118                 !swapping
1119             ){
1120                 if(!tradingActive){
1121                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1122                 }
1123  
1124                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1125                 if (transferDelayEnabled){
1126                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1127                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1128                         _holderLastTransferTimestamp[tx.origin] = block.number;
1129                     }
1130                 }
1131  
1132                 //when buy
1133                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1134                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1135                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1136                 }
1137  
1138                 //when sell
1139                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1140                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1141                 }
1142                 else if(!_isExcludedMaxTransactionAmount[to]){
1143                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1144                 }
1145             }
1146         }
1147  
1148         uint256 contractTokenBalance = balanceOf(address(this));
1149  
1150         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1151  
1152         if( 
1153             canSwap &&
1154             swapEnabled &&
1155             !swapping &&
1156             !automatedMarketMakerPairs[from] &&
1157             !_isExcludedFromFees[from] &&
1158             !_isExcludedFromFees[to]
1159         ) {
1160             swapping = true;
1161  
1162             swapBack();
1163  
1164             swapping = false;
1165         }
1166  
1167         bool takeFee = !swapping;
1168  
1169         // if any account belongs to _isExcludedFromFee account then remove the fee
1170         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1171             takeFee = false;
1172         }
1173  
1174         uint256 fees = 0;
1175         // only take fees on buys/sells, do not take on wallet transfers
1176         if(takeFee){
1177             // on sell
1178             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1179                 fees = amount.mul(sellTotalFees).div(100);
1180                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1181                 tokensForDev += fees * sellDevFee / sellTotalFees;
1182                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1183             }
1184             // on buy
1185             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1186                 fees = amount.mul(buyTotalFees).div(100);
1187                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1188                 tokensForDev += fees * buyDevFee / buyTotalFees;
1189                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1190             }
1191  
1192             if(fees > 0){    
1193                 super._transfer(from, address(this), fees);
1194             }
1195  
1196             amount -= fees;
1197         }
1198  
1199         super._transfer(from, to, amount);
1200     }
1201  
1202     function swapTokensForEth(uint256 tokenAmount) private {
1203  
1204         // generate the uniswap pair path of token -> weth
1205         address[] memory path = new address[](2);
1206         path[0] = address(this);
1207         path[1] = uniswapV2Router.WETH();
1208  
1209         _approve(address(this), address(uniswapV2Router), tokenAmount);
1210  
1211         // make the swap
1212         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1213             tokenAmount,
1214             0, // accept any amount of ETH
1215             path,
1216             address(this),
1217             block.timestamp
1218         );
1219  
1220     }
1221  
1222     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1223         // approve token transfer to cover all possible scenarios
1224         _approve(address(this), address(uniswapV2Router), tokenAmount);
1225  
1226         // add the liquidity
1227         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1228             address(this),
1229             tokenAmount,
1230             0, // slippage is unavoidable
1231             0, // slippage is unavoidable
1232             address(this),
1233             block.timestamp
1234         );
1235     }
1236  
1237     function swapBack() private {
1238         uint256 contractBalance = balanceOf(address(this));
1239         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1240         bool success;
1241  
1242         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1243  
1244         if(contractBalance > swapTokensAtAmount * 20){
1245           contractBalance = swapTokensAtAmount * 20;
1246         }
1247  
1248         // Halve the amount of liquidity tokens
1249         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1250         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1251  
1252         uint256 initialETHBalance = address(this).balance;
1253  
1254         swapTokensForEth(amountToSwapForETH); 
1255  
1256         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1257  
1258         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1259         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
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
1274         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1275     }
1276 }