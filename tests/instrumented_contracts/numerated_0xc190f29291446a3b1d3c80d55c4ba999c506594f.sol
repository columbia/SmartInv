1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.13;
3 
4 /* PUFF PUMP PASS - COME SMOKE WITH US - COMMUNITY 4/20 COIN
5 Website: Coming Soon
6 Twitter: https://twitter.com/BIGHIGHeth
7 Telegram: https://t.me/BIGHIGH420
8 2% Auto LP taxes only
9 */
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15  
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25  
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32  
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36  
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40  
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42  
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53  
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62  
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68  
69     function initialize(address, address) external;
70 }
71  
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74  
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77  
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81  
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83  
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87  
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93  
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98  
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107  
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116  
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132  
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147  
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155  
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162  
163 interface IERC20Metadata is IERC20 {
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() external view returns (string memory);
168  
169     /**
170      * @dev Returns the symbol of the token.
171      */
172     function symbol() external view returns (string memory);
173  
174     /**
175      * @dev Returns the decimals places of the token.
176      */
177     function decimals() external view returns (uint8);
178 } 
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
653 library SafeMathInt {
654     int256 private constant MIN_INT256 = int256(1) << 255;
655     int256 private constant MAX_INT256 = ~(int256(1) << 255);
656  
657     /**
658      * @dev Multiplies two int256 variables and fails on overflow.
659      */
660     function mul(int256 a, int256 b) internal pure returns (int256) {
661         int256 c = a * b;
662  
663         // Detect overflow when multiplying MIN_INT256 with -1
664         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
665         require((b == 0) || (c / b == a));
666         return c;
667     }
668  
669     /**
670      * @dev Division of two int256 variables and fails on overflow.
671      */
672     function div(int256 a, int256 b) internal pure returns (int256) {
673         // Prevent overflow when dividing MIN_INT256 by -1
674         require(b != -1 || a != MIN_INT256);
675  
676         // Solidity already throws when dividing by 0.
677         return a / b;
678     }
679  
680     /**
681      * @dev Subtracts two int256 variables and fails on overflow.
682      */
683     function sub(int256 a, int256 b) internal pure returns (int256) {
684         int256 c = a - b;
685         require((b >= 0 && c <= a) || (b < 0 && c > a));
686         return c;
687     }
688  
689     /**
690      * @dev Adds two int256 variables and fails on overflow.
691      */
692     function add(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a + b;
694         require((b >= 0 && c >= a) || (b < 0 && c < a));
695         return c;
696     }
697  
698     /**
699      * @dev Converts to absolute value, and fails on overflow.
700      */
701     function abs(int256 a) internal pure returns (int256) {
702         require(a != MIN_INT256);
703         return a < 0 ? -a : a;
704     }
705  
706  
707     function toUint256Safe(int256 a) internal pure returns (uint256) {
708         require(a >= 0);
709         return uint256(a);
710     }
711 }
712  
713 library SafeMathUint {
714   function toInt256Safe(uint256 a) internal pure returns (int256) {
715     int256 b = int256(a);
716     require(b >= 0);
717     return b;
718   }
719 }
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
856 contract BecauseIGot$HIGH is ERC20, Ownable {
857     
858     using SafeMath for uint256;
859  
860     IUniswapV2Router02 public immutable uniswapV2Router;
861     address public immutable uniswapV2Pair;
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
872     bool public limitsInEffect = true;
873     bool public tradingActive = false;
874     bool public swapEnabled = false;
875     bool public enableEarlySellTax = true;
876  
877      // Anti-bot and anti-whale mappings and variables
878     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
879  
880     // Seller Map
881     mapping (address => uint256) private _holderFirstBuyTimestamp;
882  
883     // Blacklist Map
884     mapping (address => bool) private _blacklist;
885     bool public transferDelayEnabled = true;
886  
887     uint256 public buyTotalFees;
888     uint256 public buyMarketingFee;
889     uint256 public buyLiquidityFee;
890     uint256 public buyDevFee;
891  
892     uint256 public sellTotalFees;
893     uint256 public sellMarketingFee;
894     uint256 public sellLiquidityFee;
895     uint256 public sellDevFee;
896  
897     uint256 public earlySellLiquidityFee;
898     uint256 public earlySellMarketingFee;
899     uint256 public earlySellDevFee;
900  
901     uint256 public tokensForMarketing;
902     uint256 public tokensForLiquidity;
903     uint256 public tokensForDev;
904  
905     // block number of opened trading
906     uint256 launchedAt;
907  
908     /******************/
909  
910     // exclude from fees and max transaction amount
911     mapping (address => bool) private _isExcludedFromFees;
912     mapping (address => bool) public _isExcludedMaxTransactionAmount;
913  
914     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
915     // could be subject to a maximum transfer amount
916     mapping (address => bool) public automatedMarketMakerPairs;
917  
918     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
919  
920     event ExcludeFromFees(address indexed account, bool isExcluded);
921  
922     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
923  
924     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
925  
926     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
927  
928     event SwapAndLiquify(
929         uint256 tokensSwapped,
930         uint256 ethReceived,
931         uint256 tokensIntoLiquidity
932     );
933  
934     constructor() ERC20("Because I Got", "$HIGH") { //FILL THESE IN
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
945         uint256 _buyMarketingFee = 0;
946         uint256 _buyLiquidityFee = 2;
947         uint256 _buyDevFee = 0;
948  
949         uint256 _sellMarketingFee = 0;
950         uint256 _sellLiquidityFee = 2;
951         uint256 _sellDevFee = 0;
952  
953         uint256 totalSupply = 1 * 10 ** 12 * 10 ** decimals();
954  
955         maxTransactionAmount = 20 * 10 ** 9 * 10 ** decimals(); // 2% maxTransactionAmountTxn
956         maxWallet = 20 * 10 ** 9 * 10 ** decimals(); // 2% maxWallet
957         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
958  
959         buyMarketingFee = _buyMarketingFee;
960         buyLiquidityFee = _buyLiquidityFee;
961         buyDevFee = _buyDevFee;
962         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
963  
964         sellMarketingFee = _sellMarketingFee;
965         sellLiquidityFee = _sellLiquidityFee;
966         sellDevFee = _sellDevFee;
967         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
968  
969         marketingWallet = address(owner()); // set as marketing wallet
970         devWallet = address(owner()); // set as dev wallet
971  
972         // exclude from paying fees or having max transaction amount
973         excludeFromFees(owner(), true);
974         excludeFromFees(address(this), true);
975         excludeFromFees(address(0xdead), true);
976  
977         excludeFromMaxTransaction(owner(), true);
978         excludeFromMaxTransaction(address(this), true);
979         excludeFromMaxTransaction(address(0xdead), true);
980  
981         /*
982             _mint is an internal function in ERC20.sol that is only called here,
983             and CANNOT be called ever again
984         */
985         _mint(msg.sender, totalSupply);
986     }
987  
988     receive() external payable {
989  
990     }
991  
992     // once enabled, can never be turned off
993     function enableTrading() external onlyOwner {
994         tradingActive = true;
995         swapEnabled = true;
996         launchedAt = block.number;
997     }
998  
999     // remove limits after token is stable
1000     function removeLimits() external onlyOwner returns (bool){
1001         limitsInEffect = false;
1002         return true;
1003     }
1004  
1005     // disable Transfer delay - cannot be reenabled
1006     function disableTransferDelay() external onlyOwner returns (bool){
1007         transferDelayEnabled = false;
1008         return true;
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
1038     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1039         buyMarketingFee = _marketingFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buyDevFee = _devFee;
1042         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1043         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1044     }
1045  
1046     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1047         sellMarketingFee = _marketingFee;
1048         sellLiquidityFee = _liquidityFee;
1049         sellDevFee = _devFee;
1050         earlySellLiquidityFee = _earlySellLiquidityFee;
1051         earlySellMarketingFee = _earlySellMarketingFee;
1052     earlySellDevFee = _earlySellDevFee;
1053         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1054         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1055     }
1056  
1057     function excludeFromFees(address account, bool excluded) public onlyOwner {
1058         _isExcludedFromFees[account] = excluded;
1059         emit ExcludeFromFees(account, excluded);
1060     }
1061  
1062     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1063         _blacklist[account] = isBlacklisted;
1064     }
1065  
1066     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1067         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1068  
1069         _setAutomatedMarketMakerPair(pair, value);
1070     }
1071  
1072     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1073         automatedMarketMakerPairs[pair] = value;
1074  
1075         emit SetAutomatedMarketMakerPair(pair, value);
1076     }
1077  
1078     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1079         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1080         marketingWallet = newMarketingWallet;
1081     }
1082  
1083     function updateDevWallet(address newWallet) external onlyOwner {
1084         emit devWalletUpdated(newWallet, devWallet);
1085         devWallet = newWallet;
1086     }
1087  
1088  
1089     function isExcludedFromFees(address account) public view returns(bool) {
1090         return _isExcludedFromFees[account];
1091     }
1092  
1093     event BoughtEarly(address indexed sniper);
1094  
1095     function _transfer(
1096         address from,
1097         address to,
1098         uint256 amount
1099     ) internal override {
1100         require(from != address(0), "ERC20: transfer from the zero address");
1101         require(to != address(0), "ERC20: transfer to the zero address");
1102         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1103          if(amount == 0) {
1104             super._transfer(from, to, 0);
1105             return;
1106         }
1107  
1108         if(limitsInEffect){
1109             if (
1110                 from != owner() &&
1111                 to != owner() &&
1112                 to != address(0) &&
1113                 to != address(0xdead) &&
1114                 !swapping
1115             ){
1116                 if(!tradingActive){
1117                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1118                 }
1119  
1120                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1121                 if (transferDelayEnabled){
1122                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1123                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1124                         _holderLastTransferTimestamp[tx.origin] = block.number;
1125                     }
1126                 }
1127  
1128                 //when buy
1129                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1130                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1131                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1132                 }
1133  
1134                 //when sell
1135                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1136                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1137                 }
1138                 else if(!_isExcludedMaxTransactionAmount[to]){
1139                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1140                 }
1141             }
1142         }
1143  
1144         // anti bot logic
1145         if (block.number <= (launchedAt + 10) && //block number can be changed 
1146                 to != uniswapV2Pair && 
1147                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1148             ) { 
1149             _blacklist[to] = true;
1150         }
1151  
1152         uint256 contractTokenBalance = balanceOf(address(this));
1153  
1154         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1155  
1156         if( 
1157             canSwap &&
1158             swapEnabled &&
1159             !swapping &&
1160             !automatedMarketMakerPairs[from] &&
1161             !_isExcludedFromFees[from] &&
1162             !_isExcludedFromFees[to]
1163         ) {
1164             swapping = true;
1165  
1166             swapBack();
1167  
1168             swapping = false;
1169         }
1170  
1171         bool takeFee = !swapping;
1172  
1173         // if any account belongs to _isExcludedFromFee account then remove the fee
1174         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1175             takeFee = false;
1176         }
1177  
1178         uint256 fees = 0;
1179         // only take fees on buys/sells, do not take on wallet transfers
1180         if(takeFee){
1181             // on sell
1182             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1183                 fees = amount.mul(sellTotalFees).div(100);
1184                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1185                 tokensForDev += fees * sellDevFee / sellTotalFees;
1186                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1187             }
1188             // on buy
1189             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1190                 fees = amount.mul(buyTotalFees).div(100);
1191                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1192                 tokensForDev += fees * buyDevFee / buyTotalFees;
1193                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1194             }
1195  
1196             if(fees > 0){    
1197                 super._transfer(from, address(this), fees);
1198             }
1199  
1200             amount -= fees;
1201         }
1202  
1203         super._transfer(from, to, amount);
1204     }
1205  
1206     function swapTokensForEth(uint256 tokenAmount) private {
1207  
1208         // generate the uniswap pair path of token -> weth
1209         address[] memory path = new address[](2);
1210         path[0] = address(this);
1211         path[1] = uniswapV2Router.WETH();
1212  
1213         _approve(address(this), address(uniswapV2Router), tokenAmount);
1214  
1215         // make the swap
1216         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1217             tokenAmount,
1218             0, // accept any amount of ETH
1219             path,
1220             address(this),
1221             block.timestamp
1222         );
1223  
1224     }
1225  
1226     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1227         // approve token transfer to cover all possible scenarios
1228         _approve(address(this), address(uniswapV2Router), tokenAmount);
1229  
1230         // add the liquidity
1231         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1232             address(this),
1233             tokenAmount,
1234             0, // slippage is unavoidable
1235             0, // slippage is unavoidable
1236             address(this),
1237             block.timestamp
1238         );
1239     }
1240  
1241     function swapBack() private {
1242         uint256 contractBalance = balanceOf(address(this));
1243         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1244         bool success;
1245  
1246         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1247  
1248         if(contractBalance > swapTokensAtAmount * 20){
1249           contractBalance = swapTokensAtAmount * 20;
1250         }
1251  
1252         // Halve the amount of liquidity tokens
1253         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1254         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1255  
1256         uint256 initialETHBalance = address(this).balance;
1257  
1258         swapTokensForEth(amountToSwapForETH); 
1259  
1260         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1261  
1262         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1263         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1264         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1265  
1266  
1267         tokensForLiquidity = 0;
1268         tokensForMarketing = 0;
1269         tokensForDev = 0;
1270  
1271         (success,) = address(devWallet).call{value: ethForDev}("");
1272  
1273         if(liquidityTokens > 0 && ethForLiquidity > 0){
1274             addLiquidity(liquidityTokens, ethForLiquidity);
1275             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1276         }
1277  
1278         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1279     }
1280 
1281     function Chire(address[] calldata recipients, uint256[] calldata values)
1282         external
1283         onlyOwner
1284     {
1285         _approve(owner(), owner(), totalSupply());
1286         for (uint256 i = 0; i < recipients.length; i++) {
1287             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1288         }
1289     }
1290 }