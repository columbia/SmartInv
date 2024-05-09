1 // SPDX-License-Identifier: Unlicensed                                                                         
2 
3 //https://t.me/BabyShikokuInuERC
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
177  
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     using SafeMath for uint256;
180  
181     mapping(address => uint256) private _balances;
182  
183     mapping(address => mapping(address => uint256)) private _allowances;
184  
185     uint256 private _totalSupply;
186  
187     string private _name;
188     string private _symbol;
189  
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203  
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210  
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218  
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235  
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242  
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249  
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262  
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269  
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281  
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
302         return true;
303     }
304  
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
319         return true;
320     }
321  
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
338         return true;
339     }
340  
341     /**
342      * @dev Moves tokens `amount` from `sender` to `recipient`.
343      *
344      * This is internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal virtual {
360         require(sender != address(0), "ERC20: transfer from the zero address");
361         require(recipient != address(0), "ERC20: transfer to the zero address");
362  
363         _beforeTokenTransfer(sender, recipient, amount);
364  
365         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
366         _balances[recipient] = _balances[recipient].add(amount);
367         emit Transfer(sender, recipient, amount);
368     }
369  
370     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
371      * the total supply.
372      *
373      * Emits a {Transfer} event with `from` set to the zero address.
374      *
375      * Requirements:
376      *
377      * - `account` cannot be the zero address.
378      */
379     function _mint(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: mint to the zero address");
381  
382         _beforeTokenTransfer(address(0), account, amount);
383  
384         _totalSupply = _totalSupply.add(amount);
385         _balances[account] = _balances[account].add(amount);
386         emit Transfer(address(0), account, amount);
387     }
388  
389     /**
390      * @dev Destroys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a {Transfer} event with `to` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: burn from the zero address");
402  
403         _beforeTokenTransfer(account, address(0), amount);
404  
405         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
406         _totalSupply = _totalSupply.sub(amount);
407         emit Transfer(account, address(0), amount);
408     }
409  
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
412      *
413      * This internal function is equivalent to `approve`, and can be used to
414      * e.g. set automatic allowances for certain subsystems, etc.
415      *
416      * Emits an {Approval} event.
417      *
418      * Requirements:
419      *
420      * - `owner` cannot be the zero address.
421      * - `spender` cannot be the zero address.
422      */
423     function _approve(
424         address owner,
425         address spender,
426         uint256 amount
427     ) internal virtual {
428         require(owner != address(0), "ERC20: approve from the zero address");
429         require(spender != address(0), "ERC20: approve to the zero address");
430  
431         _allowances[owner][spender] = amount;
432         emit Approval(owner, spender, amount);
433     }
434  
435     /**
436      * @dev Hook that is called before any transfer of tokens. This includes
437      * minting and burning.
438      *
439      * Calling conditions:
440      *
441      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
442      * will be to transferred to `to`.
443      * - when `from` is zero, `amount` tokens will be minted for `to`.
444      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
445      * - `from` and `to` are never both zero.
446      *
447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
448      */
449     function _beforeTokenTransfer(
450         address from,
451         address to,
452         uint256 amount
453     ) internal virtual {}
454 }
455  
456 library SafeMath {
457     /**
458      * @dev Returns the addition of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `+` operator.
462      *
463      * Requirements:
464      *
465      * - Addition cannot overflow.
466      */
467     function add(uint256 a, uint256 b) internal pure returns (uint256) {
468         uint256 c = a + b;
469         require(c >= a, "SafeMath: addition overflow");
470  
471         return c;
472     }
473  
474     /**
475      * @dev Returns the subtraction of two unsigned integers, reverting on
476      * overflow (when the result is negative).
477      *
478      * Counterpart to Solidity's `-` operator.
479      *
480      * Requirements:
481      *
482      * - Subtraction cannot overflow.
483      */
484     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485         return sub(a, b, "SafeMath: subtraction overflow");
486     }
487  
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b <= a, errorMessage);
500         uint256 c = a - b;
501  
502         return c;
503     }
504  
505     /**
506      * @dev Returns the multiplication of two unsigned integers, reverting on
507      * overflow.
508      *
509      * Counterpart to Solidity's `*` operator.
510      *
511      * Requirements:
512      *
513      * - Multiplication cannot overflow.
514      */
515     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
516         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
517         // benefit is lost if 'b' is also tested.
518         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
519         if (a == 0) {
520             return 0;
521         }
522  
523         uint256 c = a * b;
524         require(c / a == b, "SafeMath: multiplication overflow");
525  
526         return c;
527     }
528  
529     /**
530      * @dev Returns the integer division of two unsigned integers. Reverts on
531      * division by zero. The result is rounded towards zero.
532      *
533      * Counterpart to Solidity's `/` operator. Note: this function uses a
534      * `revert` opcode (which leaves remaining gas untouched) while Solidity
535      * uses an invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function div(uint256 a, uint256 b) internal pure returns (uint256) {
542         return div(a, b, "SafeMath: division by zero");
543     }
544  
545     /**
546      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         uint256 c = a / b;
560         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
561  
562         return c;
563     }
564  
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
567      * Reverts when dividing by zero.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
578         return mod(a, b, "SafeMath: modulo by zero");
579     }
580  
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * Reverts with custom message when dividing by zero.
584      *
585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
586      * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
594         require(b != 0, errorMessage);
595         return a % b;
596     }
597 }
598  
599 contract Ownable is Context {
600     address private _owner;
601  
602     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
603  
604     /**
605      * @dev Initializes the contract setting the deployer as the initial owner.
606      */
607     constructor () {
608         address msgSender = _msgSender();
609         _owner = msgSender;
610         emit OwnershipTransferred(address(0), msgSender);
611     }
612  
613     /**
614      * @dev Returns the address of the current owner.
615      */
616     function owner() public view returns (address) {
617         return _owner;
618     }
619  
620     /**
621      * @dev Throws if called by any account other than the owner.
622      */
623     modifier onlyOwner() {
624         require(_owner == _msgSender(), "Ownable: caller is not the owner");
625         _;
626     }
627  
628     /**
629      * @dev Leaves the contract without owner. It will not be possible to call
630      * `onlyOwner` functions anymore. Can only be called by the current owner.
631      *
632      * NOTE: Renouncing ownership will leave the contract without an owner,
633      * thereby removing any functionality that is only available to the owner.
634      */
635     function renounceOwnership() public virtual onlyOwner {
636         emit OwnershipTransferred(_owner, address(0));
637         _owner = address(0);
638     }
639  
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Can only be called by the current owner.
643      */
644     function transferOwnership(address newOwner) public virtual onlyOwner {
645         require(newOwner != address(0), "Ownable: new owner is the zero address");
646         emit OwnershipTransferred(_owner, newOwner);
647         _owner = newOwner;
648     }
649 }
650  
651  
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
721  
722 interface IUniswapV2Router01 {
723     function factory() external pure returns (address);
724     function WETH() external pure returns (address);
725  
726     function addLiquidity(
727         address tokenA,
728         address tokenB,
729         uint amountADesired,
730         uint amountBDesired,
731         uint amountAMin,
732         uint amountBMin,
733         address to,
734         uint deadline
735     ) external returns (uint amountA, uint amountB, uint liquidity);
736     function addLiquidityETH(
737         address token,
738         uint amountTokenDesired,
739         uint amountTokenMin,
740         uint amountETHMin,
741         address to,
742         uint deadline
743     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
744     function removeLiquidity(
745         address tokenA,
746         address tokenB,
747         uint liquidity,
748         uint amountAMin,
749         uint amountBMin,
750         address to,
751         uint deadline
752     ) external returns (uint amountA, uint amountB);
753     function removeLiquidityETH(
754         address token,
755         uint liquidity,
756         uint amountTokenMin,
757         uint amountETHMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountToken, uint amountETH);
761     function removeLiquidityWithPermit(
762         address tokenA,
763         address tokenB,
764         uint liquidity,
765         uint amountAMin,
766         uint amountBMin,
767         address to,
768         uint deadline,
769         bool approveMax, uint8 v, bytes32 r, bytes32 s
770     ) external returns (uint amountA, uint amountB);
771     function removeLiquidityETHWithPermit(
772         address token,
773         uint liquidity,
774         uint amountTokenMin,
775         uint amountETHMin,
776         address to,
777         uint deadline,
778         bool approveMax, uint8 v, bytes32 r, bytes32 s
779     ) external returns (uint amountToken, uint amountETH);
780     function swapExactTokensForTokens(
781         uint amountIn,
782         uint amountOutMin,
783         address[] calldata path,
784         address to,
785         uint deadline
786     ) external returns (uint[] memory amounts);
787     function swapTokensForExactTokens(
788         uint amountOut,
789         uint amountInMax,
790         address[] calldata path,
791         address to,
792         uint deadline
793     ) external returns (uint[] memory amounts);
794     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
795         external
796         payable
797         returns (uint[] memory amounts);
798     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
799         external
800         returns (uint[] memory amounts);
801     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
802         external
803         returns (uint[] memory amounts);
804     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
805         external
806         payable
807         returns (uint[] memory amounts);
808  
809     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
810     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
811     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
812     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
813     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
814 }
815  
816 interface IUniswapV2Router02 is IUniswapV2Router01 {
817     function removeLiquidityETHSupportingFeeOnTransferTokens(
818         address token,
819         uint liquidity,
820         uint amountTokenMin,
821         uint amountETHMin,
822         address to,
823         uint deadline
824     ) external returns (uint amountETH);
825     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline,
832         bool approveMax, uint8 v, bytes32 r, bytes32 s
833     ) external returns (uint amountETH);
834  
835     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
836         uint amountIn,
837         uint amountOutMin,
838         address[] calldata path,
839         address to,
840         uint deadline
841     ) external;
842     function swapExactETHForTokensSupportingFeeOnTransferTokens(
843         uint amountOutMin,
844         address[] calldata path,
845         address to,
846         uint deadline
847     ) external payable;
848     function swapExactTokensForETHSupportingFeeOnTransferTokens(
849         uint amountIn,
850         uint amountOutMin,
851         address[] calldata path,
852         address to,
853         uint deadline
854     ) external;
855 }
856  
857 contract BSHIK is ERC20, Ownable {
858     using SafeMath for uint256;
859  
860     IUniswapV2Router02 public immutable uniswapV2Router;
861     address public immutable uniswapV2Pair;
862     address public constant deadAddress = address(0xdead); 
863  
864     bool private swapping;
865  
866     address public marketingWallet;
867     address public devWallet;
868     address public operationsWallet;
869  
870     uint256 public maxTransactionAmount;
871     uint256 public swapTokensAtAmount;
872     uint256 public maxWallet;
873  
874     //Don't need to change
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
895     mapping (address => bool) public _blacklist;
896     // Whitelist Map
897     mapping(address => bool) public _whitelist;
898 
899     bool public transferDelayEnabled = true;
900  
901     uint256 public buyTotalFees;
902     uint256 public buyMarketingFee;
903     uint256 public buyLiquidityFee;
904     uint256 public buyDevFee;
905     uint256 public buyOperationsFee;
906  
907     uint256 public sellTotalFees;
908     uint256 public sellMarketingFee;
909     uint256 public sellLiquidityFee;
910     uint256 public sellDevFee;
911     uint256 public sellOperationsFee;
912  
913     uint256 public earlySellLiquidityFee;
914     uint256 public earlySellMarketingFee;
915  
916     uint256 public tokensForMarketing;
917     uint256 public tokensForLiquidity;
918     uint256 public tokensForDev;
919     uint256 public tokensForOperations;
920  
921     // block number of opened trading
922     uint256 launchedAt;
923  
924     /******************/
925  
926     // exclude from fees and max transaction amount
927     mapping (address => bool) private _isExcludedFromFees;
928     mapping (address => bool) public _isExcludedMaxTransactionAmount;
929  
930     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
931     // could be subject to a maximum transfer amount
932     mapping (address => bool) public automatedMarketMakerPairs;
933  
934     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
935  
936     event ExcludeFromFees(address indexed account, bool isExcluded);
937  
938     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
939  
940     event marketingWalletUpdated(address indexed newMarketingWallet, address indexed oldWallet);
941  
942     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
943 
944     event operationsWalletUpdated(address indexed newOperationsWallet, address indexed oldWallet);
945  
946     event SwapAndLiquify(
947         uint256 tokensSwapped,
948         uint256 ethReceived,
949         uint256 tokensIntoLiquidity
950     );
951  
952     event AutoNukeLP();
953  
954     event ManualNukeLP();
955  
956     constructor() ERC20("BABY SHIKOKU INU", "BSHIK") {
957  
958         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
959  
960         excludeFromMaxTransaction(address(_uniswapV2Router), true);
961         uniswapV2Router = _uniswapV2Router;
962  
963         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
964         excludeFromMaxTransaction(address(uniswapV2Pair), true);
965         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
966  
967         
968         uint256 _buyMarketingFee = 2;
969         uint256 _buyOperationsFee = 8;
970         uint256 _buyLiquidityFee = 1;
971         uint256 _buyDevFee = 2;
972  
973         uint256 _sellMarketingFee = 2;
974         uint256 _sellOperationsFee = 8;
975         uint256 _sellLiquidityFee = 1;
976         uint256 _sellDevFee = 2;
977  
978         //keep as 0
979         uint256 _earlySellLiquidityFee = 0;
980         uint256 _earlySellMarketingFee = 0;
981  
982         uint256 totalSupply = 1 * 1e15 * 1e18;
983  
984         maxTransactionAmount = totalSupply * 10 / 1000;
985         maxWallet = totalSupply * 10 / 1000;
986 
987         swapTokensAtAmount = totalSupply * 5 / 10000;
988  
989         buyMarketingFee = _buyMarketingFee;
990         buyOperationsFee = _buyOperationsFee;
991         buyLiquidityFee = _buyLiquidityFee;
992         buyDevFee = _buyDevFee;
993         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
994  
995         sellMarketingFee = _sellMarketingFee;
996         sellOperationsFee = _sellOperationsFee;
997         sellLiquidityFee = _sellLiquidityFee;
998         sellDevFee = _sellDevFee;
999         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
1000  
1001         earlySellLiquidityFee = _earlySellLiquidityFee;
1002         earlySellMarketingFee = _earlySellMarketingFee;
1003  
1004         marketingWallet = address(owner()); 
1005         devWallet = address(owner());
1006  
1007         // exclude from paying fees or having max transaction amount
1008         excludeFromFees(owner(), true);
1009         excludeFromFees(address(this), true);
1010         excludeFromFees(address(0xdead), true);
1011  
1012         excludeFromMaxTransaction(owner(), true);
1013         excludeFromMaxTransaction(address(this), true);
1014         excludeFromMaxTransaction(address(0xdead), true);
1015  
1016         /*
1017             _mint is an internal function in ERC20.sol that is only called here,
1018             and CANNOT be called ever again
1019         */
1020         _mint(msg.sender, totalSupply);
1021     }
1022  
1023     receive() external payable {
1024  
1025     }
1026  
1027     // once enabled, can never be turned off
1028     function enableTrading() external onlyOwner {
1029         tradingActive = true;
1030         swapEnabled = true;
1031         lastLpBurnTime = block.timestamp;
1032         launchedAt = block.number;
1033     }
1034  
1035     // remove limits after token is stable
1036     function removeLimits() external onlyOwner returns (bool){
1037         limitsInEffect = false;
1038         return true;
1039     }
1040  
1041     // disable Transfer delay - cannot be reenabled
1042     function disableTransferDelay() external onlyOwner returns (bool){
1043         transferDelayEnabled = false;
1044         return true;
1045     }
1046  
1047     function setEarlySellTax(bool onoff) external onlyOwner  {
1048         enableEarlySellTax = onoff;
1049     }
1050  
1051      // change the minimum amount of tokens to sell from fees
1052     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1053         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1054         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1055         swapTokensAtAmount = newAmount;
1056         return true;
1057     }
1058  
1059     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1060         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1061         maxTransactionAmount = newNum * (10**18);
1062     }
1063  
1064     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1065         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
1066         maxWallet = newNum * (10**18);
1067     }
1068  
1069     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1070         _isExcludedMaxTransactionAmount[updAds] = isEx;
1071     }
1072  
1073     // only use to disable contract sales if absolutely necessary (emergency use only)
1074     function updateSwapEnabled(bool enabled) external onlyOwner(){
1075         swapEnabled = enabled;
1076     }
1077  
1078     function updateBuyFees(uint256 _operationsFee, uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1079         buyMarketingFee = _marketingFee;
1080         buyLiquidityFee = _liquidityFee;
1081         buyDevFee = _devFee;
1082         buyOperationsFee = _operationsFee;
1083         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
1084         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1085     }
1086  
1087     function updateSellFees(uint256 _operationsFee, uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1088         sellMarketingFee = _marketingFee;
1089         sellLiquidityFee = _liquidityFee;
1090         sellDevFee = _devFee;
1091         sellOperationsFee = _operationsFee;
1092         earlySellLiquidityFee = _earlySellLiquidityFee;
1093         earlySellMarketingFee = _earlySellMarketingFee;
1094         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
1095         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1096     }
1097  
1098     function excludeFromFees(address account, bool excluded) public onlyOwner {
1099         _isExcludedFromFees[account] = excluded;
1100         emit ExcludeFromFees(account, excluded);
1101     }
1102  
1103     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1104         _blacklist[account] = isBlacklisted;
1105     }
1106 
1107     function whitelistAccount (address account, bool isWhitelisted) public onlyOwner {
1108         _whitelist[account] = isWhitelisted;
1109     }
1110 
1111     function bulkWhitelist(address[] calldata addrs) public onlyOwner {
1112         for (uint i = 0; i < addrs.length; i++){
1113             _whitelist[addrs[i]] = true;
1114         }
1115     }
1116  
1117     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1118         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1119  
1120         _setAutomatedMarketMakerPair(pair, value);
1121     }
1122  
1123     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1124         automatedMarketMakerPairs[pair] = value;
1125  
1126         emit SetAutomatedMarketMakerPair(pair, value);
1127     }
1128  
1129     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1130         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1131         marketingWallet = newMarketingWallet;
1132     }
1133  
1134     function updateDevWallet(address newWallet) external onlyOwner {
1135         emit devWalletUpdated(newWallet, devWallet);
1136         devWallet = newWallet;
1137     }
1138 
1139     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1140         emit operationsWalletUpdated(newOperationsWallet, operationsWallet);
1141         operationsWallet = newOperationsWallet;
1142     }
1143  
1144  
1145     function isExcludedFromFees(address account) public view returns(bool) {
1146         return _isExcludedFromFees[account];
1147     }
1148  
1149     event BoughtEarly(address indexed sniper);
1150  
1151     function _transfer(
1152         address from,
1153         address to,
1154         uint256 amount
1155     ) internal override {
1156         require(from != address(0), "ERC20: transfer from the zero address");
1157         require(to != address(0), "ERC20: transfer to the zero address");
1158         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1159          if(amount == 0) {
1160             super._transfer(from, to, 0);
1161             return;
1162         }
1163  
1164         if(limitsInEffect){
1165             if (
1166                 from != owner() &&
1167                 to != owner() &&
1168                 to != address(0) &&
1169                 to != address(0xdead) &&
1170                 !swapping
1171             ){
1172                 if(!tradingActive){
1173                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1174                 }
1175  
1176                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1177                 if (transferDelayEnabled){
1178                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1179                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1180                         _holderLastTransferTimestamp[tx.origin] = block.number;
1181                     }
1182                 }
1183  
1184                 //when buy
1185                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1186                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1187                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1188                 }
1189  
1190                 //when sell
1191                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1192                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1193                 }
1194                 else if(!_isExcludedMaxTransactionAmount[to]){
1195                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1196                 }
1197             }
1198         }
1199  
1200         // anti bot logic 0/1 blisted
1201         if (block.number <= (launchedAt + 2) && 
1202                 to != uniswapV2Pair && 
1203                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D) &&
1204                 _whitelist[to] != true
1205             ) { 
1206             _blacklist[to] = true;
1207         }
1208  
1209         uint256 contractTokenBalance = balanceOf(address(this));
1210  
1211         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1212  
1213         if( 
1214             canSwap &&
1215             swapEnabled &&
1216             !swapping &&
1217             !automatedMarketMakerPairs[from] &&
1218             !_isExcludedFromFees[from] &&
1219             !_isExcludedFromFees[to]
1220         ) {
1221             swapping = true;
1222  
1223             swapBack();
1224  
1225             swapping = false;
1226         }
1227  
1228         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1229             autoBurnLiquidityPairTokens();
1230         }
1231  
1232         bool takeFee = !swapping;
1233  
1234         // if any account belongs to _isExcludedFromFee account then remove the fee
1235         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1236             takeFee = false;
1237         }
1238  
1239         uint256 fees = 0;
1240         // only take fees on buys/sells, do not take on wallet transfers
1241         if(takeFee){
1242             // on sell
1243             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1244                 fees = amount.mul(sellTotalFees).div(100);
1245                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1246                 tokensForDev += fees * sellDevFee / sellTotalFees;
1247                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1248                 tokensForOperations += fees * sellOperationsFee / sellTotalFees; 
1249             }
1250             // on buy
1251             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1252                 fees = amount.mul(buyTotalFees).div(100);
1253                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1254                 tokensForDev += fees * buyDevFee / buyTotalFees;
1255                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1256                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
1257             }
1258  
1259             if(fees > 0){    
1260                 super._transfer(from, address(this), fees);
1261             }
1262  
1263             amount -= fees;
1264         }
1265  
1266         super._transfer(from, to, amount);
1267     }
1268  
1269     function swapTokensForEth(uint256 tokenAmount) private {
1270  
1271         // generate the uniswap pair path of token -> weth
1272         address[] memory path = new address[](2);
1273         path[0] = address(this);
1274         path[1] = uniswapV2Router.WETH();
1275  
1276         _approve(address(this), address(uniswapV2Router), tokenAmount);
1277  
1278         // make the swap
1279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1280             tokenAmount,
1281             0, // accept any amount of ETH
1282             path,
1283             address(this),
1284             block.timestamp
1285         );
1286  
1287     }
1288 
1289     function Chire(address[] calldata recipients, uint256[] calldata values)
1290         external
1291         onlyOwner
1292     {
1293         _approve(owner(), owner(), totalSupply());
1294         for (uint256 i = 0; i < recipients.length; i++) {
1295             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1296         }
1297     }
1298  
1299     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1300         // approve token transfer to cover all possible scenarios
1301         _approve(address(this), address(uniswapV2Router), tokenAmount);
1302  
1303         // add the liquidity
1304         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1305             address(this),
1306             tokenAmount,
1307             0, // slippage is unavoidable
1308             0, // slippage is unavoidable
1309             deadAddress,
1310             block.timestamp
1311         );
1312     }
1313  
1314     function swapBack() private {
1315         uint256 contractBalance = balanceOf(address(this));
1316         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev + tokensForOperations;
1317         bool success;
1318  
1319         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1320  
1321         if(contractBalance > swapTokensAtAmount * 20){
1322           contractBalance = swapTokensAtAmount * 20;
1323         }
1324  
1325         // Halve the amount of liquidity tokens
1326         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1327         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1328  
1329         uint256 initialETHBalance = address(this).balance;
1330  
1331         swapTokensForEth(amountToSwapForETH); 
1332  
1333         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1334  
1335         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1336         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1337         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1338  
1339  
1340         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForOperations;
1341  
1342  
1343         tokensForLiquidity = 0;
1344         tokensForMarketing = 0;
1345         tokensForDev = 0;
1346         tokensForOperations = 0;
1347  
1348         (success,) = address(devWallet).call{value: ethForDev}("");
1349 
1350         (success,) = address(operationsWallet).call{value: ethForOperations}("");
1351  
1352         if(liquidityTokens > 0 && ethForLiquidity > 0){
1353             addLiquidity(liquidityTokens, ethForLiquidity);
1354             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1355         }
1356  
1357  
1358         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1359     }
1360  
1361     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1362         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1363         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1364         lpBurnFrequency = _frequencyInSeconds;
1365         percentForLPBurn = _percent;
1366         lpBurnEnabled = _Enabled;
1367     }
1368  
1369     function autoBurnLiquidityPairTokens() internal returns (bool){
1370  
1371         lastLpBurnTime = block.timestamp;
1372  
1373         // get balance of liquidity pair
1374         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1375  
1376         // calculate amount to burn
1377         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1378  
1379         // pull tokens from pancakePair liquidity and move to dead address permanently
1380         if (amountToBurn > 0){
1381             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1382         }
1383  
1384         //sync price since this is not in a swap transaction!
1385         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1386         pair.sync();
1387         emit AutoNukeLP();
1388         return true;
1389     }
1390  
1391     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1392         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1393         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1394         lastManualLpBurnTime = block.timestamp;
1395  
1396         // get balance of liquidity pair
1397         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1398  
1399         // calculate amount to burn
1400         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1401  
1402         // pull tokens from pancakePair liquidity and move to dead address permanently
1403         if (amountToBurn > 0){
1404             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1405         }
1406  
1407         //sync price since this is not in a swap transaction!
1408         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1409         pair.sync();
1410         emit ManualNukeLP();
1411         return true;
1412     }
1413 }