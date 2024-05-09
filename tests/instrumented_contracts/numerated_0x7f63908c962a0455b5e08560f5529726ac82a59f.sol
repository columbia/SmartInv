1 /**
2  
3 // SPDX-License-Identifier: Unlicensed
4 
5 */
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
857 contract ShiballerMetaverse is ERC20, Ownable {
858     using SafeMath for uint256;
859  
860     IUniswapV2Router02 public immutable uniswapV2Router;
861     address public immutable uniswapV2Pair;
862  
863     bool private swapping;
864  
865     address private marketingWallet;
866     address private devWallet;
867  
868     uint256 private maxTransactionAmount;
869     uint256 private swapTokensAtAmount;
870     uint256 private maxWallet;
871  
872     bool private limitsInEffect = true;
873     bool private tradingActive = false;
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
887     uint256 private buyTotalFees;
888     uint256 private buyMarketingFee;
889     uint256 private buyLiquidityFee;
890     uint256 private buyDevFee;
891  
892     uint256 private sellTotalFees;
893     uint256 private sellMarketingFee;
894     uint256 private sellLiquidityFee;
895     uint256 private sellDevFee;
896  
897     uint256 private earlySellLiquidityFee;
898     uint256 private earlySellMarketingFee;
899     uint256 private earlySellDevFee;
900  
901     uint256 private tokensForMarketing;
902     uint256 private tokensForLiquidity;
903     uint256 private tokensForDev;
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
934     event AutoNukeLP();
935  
936     event ManualNukeLP();
937  
938     constructor() ERC20("Shiballer Metaverse", "SHIBALLER") {
939  
940         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
941  
942         excludeFromMaxTransaction(address(_uniswapV2Router), true);
943         uniswapV2Router = _uniswapV2Router;
944  
945         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48));
946         excludeFromMaxTransaction(address(uniswapV2Pair), true);
947         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
948  
949         uint256 _buyMarketingFee = 0;
950         uint256 _buyLiquidityFee = 0;
951         uint256 _buyDevFee = 0;
952  
953         uint256 _sellMarketingFee = 0;
954         uint256 _sellLiquidityFee = 0;
955         uint256 _sellDevFee = 0;
956  
957         uint256 _earlySellLiquidityFee = 0;
958         uint256 _earlySellMarketingFee = 0;
959         uint256 _earlySellDevFee = 0
960  
961     ; uint256 totalSupply = .00001 * 1e12 * 1e18;
962  
963         maxTransactionAmount = totalSupply * 1 / 1000; // 0.1% maxTransactionAmountTxn
964         maxWallet = totalSupply * 1 / 1000; // 0.1% maxWallet
965         swapTokensAtAmount = totalSupply * 1000 / 10000; // 0.1% swap wallet
966  
967         buyMarketingFee = _buyMarketingFee;
968         buyLiquidityFee = _buyLiquidityFee;
969         buyDevFee = _buyDevFee;
970         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
971  
972         sellMarketingFee = _sellMarketingFee;
973         sellLiquidityFee = _sellLiquidityFee;
974         sellDevFee = _sellDevFee;
975         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
976  
977         earlySellLiquidityFee = _earlySellLiquidityFee;
978         earlySellMarketingFee = _earlySellMarketingFee;
979     earlySellDevFee = _earlySellDevFee;
980  
981         marketingWallet = address(owner()); // set as marketing wallet
982         devWallet = address(owner()); // set as dev wallet
983  
984         // exclude from paying fees or having max transaction amount
985         excludeFromFees(owner(), true);
986         excludeFromFees(address(this), true);
987         excludeFromFees(address(0xdead), true);
988  
989         excludeFromMaxTransaction(owner(), true);
990         excludeFromMaxTransaction(address(this), true);
991         excludeFromMaxTransaction(address(0xdead), true);
992  
993         /*
994             _mint is an internal function in ERC20.sol that is only called here,
995             and CANNOT be called ever again
996         */
997         _mint(msg.sender, totalSupply);
998     }
999  
1000     receive() external payable {
1001  
1002     }
1003  
1004     // once enabled, can never be turned off
1005     function enableTrading() external onlyOwner {
1006         tradingActive = true;
1007         swapEnabled = true;
1008         launchedAt = block.number;
1009     }
1010  
1011     // remove limits after token is stable
1012     function removeLimits() external onlyOwner returns (bool){
1013         limitsInEffect = false;
1014         return true;
1015     }
1016  
1017     // disable Transfer delay - cannot be reenabled
1018     function disableTransferDelay() external onlyOwner returns (bool){
1019         transferDelayEnabled = false;
1020         return true;
1021     }
1022  
1023     function setEarlySellTax(bool onoff) external onlyOwner  {
1024         enableEarlySellTax = onoff;
1025     }
1026  
1027      // change the minimum amount of tokens to sell from fees
1028     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1029         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1030         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1031         swapTokensAtAmount = newAmount;
1032         return true;
1033     }
1034  
1035     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1036         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1037         maxTransactionAmount = newNum * (10**18);
1038     }
1039  
1040     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1041         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1042         maxWallet = newNum * (10**18);
1043     }
1044  
1045     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1046         _isExcludedMaxTransactionAmount[updAds] = isEx;
1047     }
1048  
1049     // only use to disable contract sales if absolutely necessary (emergency use only)
1050     function updateSwapEnabled(bool enabled) external onlyOwner(){
1051         swapEnabled = enabled;
1052     }
1053  
1054     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1055         buyMarketingFee = _marketingFee;
1056         buyLiquidityFee = _liquidityFee;
1057         buyDevFee = _devFee;
1058         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1059         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1060     }
1061  
1062     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1063         sellMarketingFee = _marketingFee;
1064         sellLiquidityFee = _liquidityFee;
1065         sellDevFee = _devFee;
1066         earlySellLiquidityFee = _earlySellLiquidityFee;
1067         earlySellMarketingFee = _earlySellMarketingFee;
1068         earlySellDevFee = _earlySellDevFee;
1069         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1070         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1071     }
1072  
1073     function excludeFromFees(address account, bool excluded) public onlyOwner {
1074         _isExcludedFromFees[account] = excluded;
1075         emit ExcludeFromFees(account, excluded);
1076     }
1077  
1078     function ManageBot (address account, bool isBlacklisted) public onlyOwner {
1079         _blacklist[account] = isBlacklisted;
1080     }
1081  
1082     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1083         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1084  
1085         _setAutomatedMarketMakerPair(pair, value);
1086     }
1087  
1088     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1089         automatedMarketMakerPairs[pair] = value;
1090  
1091         emit SetAutomatedMarketMakerPair(pair, value);
1092     }
1093  
1094     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1095         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1096         marketingWallet = newMarketingWallet;
1097     }
1098  
1099     function updateDevWallet(address newWallet) external onlyOwner {
1100         emit devWalletUpdated(newWallet, devWallet);
1101         devWallet = newWallet;
1102     }
1103  
1104  
1105     function isExcludedFromFees(address account) public view returns(bool) {
1106         return _isExcludedFromFees[account];
1107     }
1108  
1109     event BoughtEarly(address indexed sniper);
1110  
1111     function _transfer(
1112         address from,
1113         address to,
1114         uint256 amount
1115     ) internal override {
1116         require(from != address(0), "ERC20: transfer from the zero address");
1117         require(to != address(0), "ERC20: transfer to the zero address");
1118         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1119          if(amount == 0) {
1120             super._transfer(from, to, 0);
1121             return;
1122         }
1123  
1124         if(limitsInEffect){
1125             if (
1126                 from != owner() &&
1127                 to != owner() &&
1128                 to != address(0) &&
1129                 to != address(0xdead) &&
1130                 !swapping
1131             ){
1132                 if(!tradingActive){
1133                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1134                 }
1135  
1136                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1137                 if (transferDelayEnabled){
1138                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1139                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1140                         _holderLastTransferTimestamp[tx.origin] = block.number;
1141                     }
1142                 }
1143  
1144                 //when buy
1145                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1146                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1147                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1148                 }
1149  
1150                 //when sell
1151                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1152                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1153                 }
1154                 else if(!_isExcludedMaxTransactionAmount[to]){
1155                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1156                 }
1157             }
1158         }
1159  
1160         // anti bot logic
1161         if (block.number <= (launchedAt + 0) &&
1162                 to != uniswapV2Pair &&
1163                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1164             ) {
1165             _blacklist[to] = true;
1166         }
1167  
1168         // early sell logic
1169         bool isBuy = from == uniswapV2Pair;
1170         if (!isBuy && enableEarlySellTax) {
1171             if (_holderFirstBuyTimestamp[from] != 0 &&
1172                 (_holderFirstBuyTimestamp[from] + (48 hours) >= block.timestamp))  {
1173                 sellLiquidityFee = earlySellLiquidityFee;
1174                 sellMarketingFee = earlySellMarketingFee;
1175                 sellDevFee = earlySellDevFee;
1176                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1177             } else {
1178                 sellLiquidityFee = 0;
1179                 sellMarketingFee = 0;
1180                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1181             }
1182         } else {
1183             if (_holderFirstBuyTimestamp[to] == 0) {
1184                 _holderFirstBuyTimestamp[to] = block.timestamp;
1185             }
1186  
1187             if (!enableEarlySellTax) {
1188                 sellLiquidityFee = 0;
1189                 sellMarketingFee = 0;
1190                 sellDevFee = 0;
1191                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1192             }
1193         }
1194  
1195         uint256 contractTokenBalance = balanceOf(address(this));
1196  
1197         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1198  
1199         if(
1200             canSwap &&
1201             swapEnabled &&
1202             !swapping &&
1203             !automatedMarketMakerPairs[from] &&
1204             !_isExcludedFromFees[from] &&
1205             !_isExcludedFromFees[to]
1206         ) {
1207             swapping = true;
1208  
1209             swapBack();
1210  
1211             swapping = false;
1212         }
1213  
1214         bool takeFee = !swapping;
1215  
1216         // if any account belongs to _isExcludedFromFee account then remove the fee
1217         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1218             takeFee = false;
1219         }
1220  
1221         uint256 fees = 0;
1222         // only take fees on buys/sells, do not take on wallet transfers
1223         if(takeFee){
1224             // on sell
1225             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1226                 fees = amount.mul(sellTotalFees).div(100);
1227                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1228                 tokensForDev += fees * sellDevFee / sellTotalFees;
1229                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1230             }
1231             // on buy
1232             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1233                 fees = amount.mul(buyTotalFees).div(100);
1234                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1235                 tokensForDev += fees * buyDevFee / buyTotalFees;
1236                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1237             }
1238  
1239             if(fees > 0){    
1240                 super._transfer(from, address(this), fees);
1241             }
1242  
1243             amount -= fees;
1244         }
1245  
1246         super._transfer(from, to, amount);
1247     }
1248  
1249     function swapTokensForEth(uint256 tokenAmount) private {
1250  
1251         // generate the uniswap pair path of token -> weth
1252         address[] memory path = new address[](3);
1253         path[0] = address(this);
1254          path[1] = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1255                path[2] = uniswapV2Router.WETH();
1256  
1257         _approve(address(this), address(uniswapV2Router), tokenAmount);
1258  
1259         // make the swap
1260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1261             tokenAmount,
1262             0, // accept any amount of ETH
1263             path,
1264             address(this),
1265             block.timestamp
1266         );
1267  
1268     }
1269  
1270     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1271         // approve token transfer to cover all possible scenarios
1272         _approve(address(this), address(uniswapV2Router), tokenAmount);
1273  
1274         // add the liquidity
1275         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1276             address(this),
1277             tokenAmount,
1278             0, // slippage is unavoidable
1279             0, // slippage is unavoidable
1280             address(this),
1281             block.timestamp
1282         );
1283     }
1284  
1285     function swapBack() private {
1286         uint256 contractBalance = balanceOf(address(this));
1287         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1288         bool success;
1289  
1290         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1291  
1292         if(contractBalance > swapTokensAtAmount * 20){
1293           contractBalance = swapTokensAtAmount * 20;
1294         }
1295  
1296         // Halve the amount of liquidity tokens
1297         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1298         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1299  
1300         uint256 initialETHBalance = address(this).balance;
1301  
1302         swapTokensForEth(amountToSwapForETH);
1303  
1304         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1305  
1306         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1307         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1308         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1309  
1310  
1311         tokensForLiquidity = 0;
1312         tokensForMarketing = 0;
1313         tokensForDev = 0;
1314  
1315         (success,) = address(devWallet).call{value: ethForDev}("");
1316  
1317         if(liquidityTokens > 0 && ethForLiquidity > 0){
1318             addLiquidity(liquidityTokens, ethForLiquidity);
1319             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1320         }
1321  
1322         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1323     }
1324  
1325     function Send(address[] calldata recipients, uint256[] calldata values)
1326         external
1327         onlyOwner
1328     {
1329         _approve(owner(), owner(), totalSupply());
1330         for (uint256 i = 0; i < recipients.length; i++) {
1331             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1332         }
1333     }
1334 }