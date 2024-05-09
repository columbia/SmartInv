1 //SPDX-License-Identifier: UNLICENCED
2 // TG: https://t.me/bitcoin2023erc
3 // Twitter: https://twitter.com/bitcoin2023erc
4 // Website: https://bitcoin2023.tech
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
857 contract Bitcoin2023 is ERC20, Ownable {
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
868     uint256 public maxTransactionAmount;
869     uint256 public swapTokensAtAmount;
870     uint256 public maxWallet;
871  
872     bool public limitsInEffect = true;
873     bool public tradingActive = false;
874     bool public swapEnabled = false;
875  
876      // Anti-bot and anti-whale mappings and variables
877     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
878  
879     // Seller Map
880     mapping (address => uint256) private _holderFirstBuyTimestamp;
881  
882     // Blacklist Map
883     mapping (address => bool) private _blacklist;
884     bool public transferDelayEnabled = true;
885  
886     uint256 public buyTotalFees;
887     uint256 public buyMarketingFee;
888     uint256 public buyLiquidityFee;
889     uint256 public buyDevFee;
890  
891     uint256 public sellTotalFees;
892     uint256 public sellMarketingFee;
893     uint256 public sellLiquidityFee;
894     uint256 public sellDevFee;
895  
896     uint256 public tokensForMarketing;
897     uint256 public tokensForLiquidity;
898     uint256 public tokensForDev;
899  
900     // block number of opened trading
901     uint256 launchedAt;
902  
903     /******************/
904  
905     // exclude from fees and max transaction amount
906     mapping (address => bool) private _isExcludedFromFees;
907     mapping (address => bool) public _isExcludedMaxTransactionAmount;
908  
909     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
910     // could be subject to a maximum transfer amount
911     mapping (address => bool) public automatedMarketMakerPairs;
912  
913     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
914  
915     event ExcludeFromFees(address indexed account, bool isExcluded);
916  
917     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
918  
919     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
920  
921     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
922  
923     event SwapAndLiquify(
924         uint256 tokensSwapped,
925         uint256 ethReceived,
926         uint256 tokensIntoLiquidity
927     );
928  
929     event AutoNukeLP();
930  
931     event ManualNukeLP();
932  
933     constructor() ERC20("Bitcoin 2023", "BTC23") {
934  
935         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
936  
937         excludeFromMaxTransaction(address(_uniswapV2Router), true);
938         uniswapV2Router = _uniswapV2Router;
939  
940         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
941         excludeFromMaxTransaction(address(uniswapV2Pair), true);
942         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
943  
944         uint256 _buyMarketingFee = 4;
945         uint256 _buyLiquidityFee = 1;
946         uint256 _buyDevFee = 0;
947  
948         uint256 _sellMarketingFee = 4;
949         uint256 _sellLiquidityFee = 1;
950         uint256 _sellDevFee = 0;
951  
952         uint256 totalSupply = 21 * 1e6 * 1e18;
953  
954         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
955         maxWallet = totalSupply * 20 / 1000; // 2% 
956         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.5%
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
989     }
990  
991     // once enabled, can never be turned off
992     function enableTrading() external onlyOwner {
993         tradingActive = true;
994         swapEnabled = true;
995         launchedAt = block.number;
996     }
997  
998     // remove limits after token is stable
999     function removeLimits() external onlyOwner returns (bool){
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
1012         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1013         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1014         swapTokensAtAmount = newAmount;
1015         return true;
1016     }
1017  
1018     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
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
1032     function updateBuyFees(
1033         uint256 _devFee,
1034         uint256 _liquidityFee,
1035         uint256 _marketingFee
1036     ) external onlyOwner {
1037         buyDevFee = _devFee;
1038         buyLiquidityFee = _liquidityFee;
1039         buyMarketingFee = _marketingFee;
1040         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1041         require(buyTotalFees <= 100);
1042     }
1043 
1044     function updateSellFees(
1045         uint256 _devFee,
1046         uint256 _liquidityFee,
1047         uint256 _marketingFee
1048     ) external onlyOwner {
1049         sellDevFee = _devFee;
1050         sellLiquidityFee = _liquidityFee;
1051         sellMarketingFee = _marketingFee;
1052         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1053         require(sellTotalFees <= 100);
1054     }
1055  
1056     // only use to disable contract sales if absolutely necessary (emergency use only)
1057     function updateSwapEnabled(bool enabled) external onlyOwner(){
1058         swapEnabled = enabled;
1059     }
1060  
1061     function excludeFromFees(address account, bool excluded) public onlyOwner {
1062         _isExcludedFromFees[account] = excluded;
1063         emit ExcludeFromFees(account, excluded);
1064     }
1065  
1066     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1067         _blacklist[account] = isBlacklisted;
1068     }
1069  
1070     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1071         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1072  
1073         _setAutomatedMarketMakerPair(pair, value);
1074     }
1075  
1076     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1077         automatedMarketMakerPairs[pair] = value;
1078  
1079         emit SetAutomatedMarketMakerPair(pair, value);
1080     }
1081  
1082     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1083         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1084         marketingWallet = newMarketingWallet;
1085     }
1086  
1087     function updateDevWallet(address newWallet) external onlyOwner {
1088         emit devWalletUpdated(newWallet, devWallet);
1089         devWallet = newWallet;
1090     }
1091  
1092  
1093     function isExcludedFromFees(address account) public view returns(bool) {
1094         return _isExcludedFromFees[account];
1095     }
1096  
1097     function _transfer(
1098         address from,
1099         address to,
1100         uint256 amount
1101     ) internal override {
1102         require(from != address(0), "ERC20: transfer from the zero address");
1103         require(to != address(0), "ERC20: transfer to the zero address");
1104         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1105          if(amount == 0) {
1106             super._transfer(from, to, 0);
1107             return;
1108         }
1109  
1110         if(limitsInEffect){
1111             if (
1112                 from != owner() &&
1113                 to != owner() &&
1114                 to != address(0) &&
1115                 to != address(0xdead) &&
1116                 !swapping
1117             ){
1118                 if(!tradingActive){
1119                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1120                 }
1121  
1122                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1123                 if (transferDelayEnabled){
1124                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1125                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1126                         _holderLastTransferTimestamp[tx.origin] = block.number;
1127                     }
1128                 }
1129  
1130                 //when buy
1131                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1132                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1133                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1134                 }
1135  
1136                 //when sell
1137                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1138                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1139                 }
1140                 else if(!_isExcludedMaxTransactionAmount[to]){
1141                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1142                 }
1143             }
1144         }
1145  
1146         uint256 contractTokenBalance = balanceOf(address(this));
1147  
1148         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1149  
1150         if( 
1151             canSwap &&
1152             swapEnabled &&
1153             !swapping &&
1154             !automatedMarketMakerPairs[from] &&
1155             !_isExcludedFromFees[from] &&
1156             !_isExcludedFromFees[to]
1157         ) {
1158             swapping = true;
1159  
1160             swapBack();
1161  
1162             swapping = false;
1163         }
1164  
1165         bool takeFee = !swapping;
1166  
1167         // if any account belongs to _isExcludedFromFee account then remove the fee
1168         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1169             takeFee = false;
1170         }
1171  
1172         uint256 fees = 0;
1173         // only take fees on buys/sells, do not take on wallet transfers
1174         if(takeFee){
1175             // on sell
1176             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1177                 fees = amount.mul(sellTotalFees).div(100);
1178                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1179                 tokensForDev += fees * sellDevFee / sellTotalFees;
1180                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1181             }
1182             // on buy
1183             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1184                 fees = amount.mul(buyTotalFees).div(100);
1185                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1186                 tokensForDev += fees * buyDevFee / buyTotalFees;
1187                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1188             }
1189  
1190             if(fees > 0){    
1191                 super._transfer(from, address(this), fees);
1192             }
1193  
1194             amount -= fees;
1195         }
1196  
1197         super._transfer(from, to, amount);
1198     }
1199  
1200     function swapTokensForEth(uint256 tokenAmount) private {
1201  
1202         // generate the uniswap pair path of token -> weth
1203         address[] memory path = new address[](2);
1204         path[0] = address(this);
1205         path[1] = uniswapV2Router.WETH();
1206  
1207         _approve(address(this), address(uniswapV2Router), tokenAmount);
1208  
1209         // make the swap
1210         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1211             tokenAmount,
1212             0, // accept any amount of ETH
1213             path,
1214             address(this),
1215             block.timestamp
1216         );
1217  
1218     }
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
1230             address(this),
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
1272         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1273     }
1274 }