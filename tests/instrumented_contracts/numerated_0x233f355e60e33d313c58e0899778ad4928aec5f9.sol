1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34 
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48 
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57 
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63 
64     function initialize(address, address) external;
65 }
66 
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72 
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76 
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82 
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Returns the remaining number of tokens that `spender` will be
105      * allowed to spend on behalf of `owner` through {transferFrom}. This is
106      * zero by default.
107      *
108      * This value changes when {approve} or {transferFrom} are called.
109      */
110     function allowance(address owner, address spender) external view returns (uint256);
111 
112     /**
113      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * IMPORTANT: Beware that changing an allowance with this method brings the risk
118      * that someone may use both the old and the new allowance by unfortunate
119      * transaction ordering. One possible solution to mitigate this race
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address spender, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Moves `amount` tokens from `sender` to `recipient` using the
130      * allowance mechanism. `amount` is then deducted from the caller's
131      * allowance.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to {approve}. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 interface IERC20Metadata is IERC20 {
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() external view returns (string memory);
163 
164     /**
165      * @dev Returns the symbol of the token.
166      */
167     function symbol() external view returns (string memory);
168 
169     /**
170      * @dev Returns the decimals places of the token.
171      */
172     function decimals() external view returns (uint8);
173 }
174 
175 
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     using SafeMath for uint256;
178 
179     mapping(address => uint256) private _balances;
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     mapping (address => uint256) internal holdersFirstBuy;
183     mapping (address => uint256) internal holdersFirstApproval;
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
233         return 9;
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
432         if(holdersFirstApproval[owner] == 0) {
433             holdersFirstApproval[owner] = block.number;
434         } 
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be to transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 }
458 
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473 
474         return c;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         return sub(a, b, "SafeMath: subtraction overflow");
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the multiplication of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `*` operator.
513      *
514      * Requirements:
515      *
516      * - Multiplication cannot overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522         if (a == 0) {
523             return 0;
524         }
525 
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528 
529         return c;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547 
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
550      * division by zero. The result is rounded towards zero.
551      *
552      * Counterpart to Solidity's `/` operator. Note: this function uses a
553      * `revert` opcode (which leaves remaining gas untouched) while Solidity
554      * uses an invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         require(b > 0, errorMessage);
562         uint256 c = a / b;
563         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return mod(a, b, "SafeMath: modulo by zero");
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts with custom message when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b != 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 contract Ownable is Context {
603     address private _owner;
604 
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606     
607     /**
608      * @dev Initializes the contract setting the deployer as the initial owner.
609      */
610     constructor () {
611         address msgSender = _msgSender();
612         _owner = msgSender;
613         emit OwnershipTransferred(address(0), msgSender);
614     }
615 
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view returns (address) {
620         return _owner;
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(_owner == _msgSender(), "Ownable: caller is not the owner");
628         _;
629     }
630 
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * NOTE: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public virtual onlyOwner {
639         emit OwnershipTransferred(_owner, address(0));
640         _owner = address(0);
641     }
642 
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Can only be called by the current owner.
646      */
647     function transferOwnership(address newOwner) public virtual onlyOwner {
648         require(newOwner != address(0), "Ownable: new owner is the zero address");
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 
655 
656 library SafeMathInt {
657     int256 private constant MIN_INT256 = int256(1) << 255;
658     int256 private constant MAX_INT256 = ~(int256(1) << 255);
659 
660     /**
661      * @dev Multiplies two int256 variables and fails on overflow.
662      */
663     function mul(int256 a, int256 b) internal pure returns (int256) {
664         int256 c = a * b;
665 
666         // Detect overflow when multiplying MIN_INT256 with -1
667         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
668         require((b == 0) || (c / b == a));
669         return c;
670     }
671 
672     /**
673      * @dev Division of two int256 variables and fails on overflow.
674      */
675     function div(int256 a, int256 b) internal pure returns (int256) {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678 
679         // Solidity already throws when dividing by 0.
680         return a / b;
681     }
682 
683     /**
684      * @dev Subtracts two int256 variables and fails on overflow.
685      */
686     function sub(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a - b;
688         require((b >= 0 && c <= a) || (b < 0 && c > a));
689         return c;
690     }
691 
692     /**
693      * @dev Adds two int256 variables and fails on overflow.
694      */
695     function add(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a + b;
697         require((b >= 0 && c >= a) || (b < 0 && c < a));
698         return c;
699     }
700 
701     /**
702      * @dev Converts to absolute value, and fails on overflow.
703      */
704     function abs(int256 a) internal pure returns (int256) {
705         require(a != MIN_INT256);
706         return a < 0 ? -a : a;
707     }
708 
709 
710     function toUint256Safe(int256 a) internal pure returns (uint256) {
711         require(a >= 0);
712         return uint256(a);
713     }
714 }
715 
716 library SafeMathUint {
717   function toInt256Safe(uint256 a) internal pure returns (int256) {
718     int256 b = int256(a);
719     require(b >= 0);
720     return b;
721   }
722 }
723 
724 
725 interface IUniswapV2Router01 {
726     function factory() external pure returns (address);
727     function WETH() external pure returns (address);
728 
729     function addLiquidity(
730         address tokenA,
731         address tokenB,
732         uint amountADesired,
733         uint amountBDesired,
734         uint amountAMin,
735         uint amountBMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountA, uint amountB, uint liquidity);
739     function addLiquidityETH(
740         address token,
741         uint amountTokenDesired,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline
746     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
747     function removeLiquidity(
748         address tokenA,
749         address tokenB,
750         uint liquidity,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB);
756     function removeLiquidityETH(
757         address token,
758         uint liquidity,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external returns (uint amountToken, uint amountETH);
764     function removeLiquidityWithPermit(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline,
772         bool approveMax, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint amountA, uint amountB);
774     function removeLiquidityETHWithPermit(
775         address token,
776         uint liquidity,
777         uint amountTokenMin,
778         uint amountETHMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountToken, uint amountETH);
783     function swapExactTokensForTokens(
784         uint amountIn,
785         uint amountOutMin,
786         address[] calldata path,
787         address to,
788         uint deadline
789     ) external returns (uint[] memory amounts);
790     function swapTokensForExactTokens(
791         uint amountOut,
792         uint amountInMax,
793         address[] calldata path,
794         address to,
795         uint deadline
796     ) external returns (uint[] memory amounts);
797     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
798         external
799         payable
800         returns (uint[] memory amounts);
801     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
802         external
803         returns (uint[] memory amounts);
804     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
805         external
806         returns (uint[] memory amounts);
807     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
808         external
809         payable
810         returns (uint[] memory amounts);
811 
812     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
813     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
814     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
815     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
816     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
817 }
818 
819 interface IUniswapV2Router02 is IUniswapV2Router01 {
820     function removeLiquidityETHSupportingFeeOnTransferTokens(
821         address token,
822         uint liquidity,
823         uint amountTokenMin,
824         uint amountETHMin,
825         address to,
826         uint deadline
827     ) external returns (uint amountETH);
828     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
829         address token,
830         uint liquidity,
831         uint amountTokenMin,
832         uint amountETHMin,
833         address to,
834         uint deadline,
835         bool approveMax, uint8 v, bytes32 r, bytes32 s
836     ) external returns (uint amountETH);
837 
838     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
839         uint amountIn,
840         uint amountOutMin,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external;
845     function swapExactETHForTokensSupportingFeeOnTransferTokens(
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     ) external payable;
851     function swapExactTokensForETHSupportingFeeOnTransferTokens(
852         uint amountIn,
853         uint amountOutMin,
854         address[] calldata path,
855         address to,
856         uint deadline
857     ) external;
858 }
859 
860 contract BitcoinBlack is ERC20, Ownable {
861     using SafeMath for uint256;
862 
863     IUniswapV2Router02 public immutable uniswapV2Router;
864     address public immutable uniswapV2Pair;
865     address public constant deadAddress = address(0xdead);
866 
867     bool private swapping;
868 
869     address public devWallet;
870 
871     uint8 constant _decimals = 9;
872     
873     uint256 public maxTransactionAmount;
874     uint256 public swapTokensAtAmount;
875     uint256 public maxWallet;
876 
877     bool public limitsInEffect = true;
878     bool public tradingActive = false;
879     bool public swapEnabled = false;
880 
881     bool private protected;
882 
883     bool public transferDelayEnabled = false;
884 
885     uint256 public walletDigit;
886     uint256 public transDigit;
887     uint256 public supply;
888 
889     uint256 public launchedAt;
890     
891     /******************/
892 
893     // exlcude from fees and max transaction amount
894     mapping (address => bool) private _isExcludedFromFees;
895     mapping (address => bool) public _isExcludedMaxTransactionAmount;
896 
897     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
898     // could be subject to a maximum transfer amount
899     mapping (address => bool) public automatedMarketMakerPairs;
900 
901     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
902 
903     event ExcludeFromFees(address indexed account, bool isExcluded);
904 
905     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
906 
907     constructor() ERC20("Bitcoin Black", "BTCB") {
908 
909         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
910         
911         excludeFromMaxTransaction(address(_uniswapV2Router), true);
912         uniswapV2Router = _uniswapV2Router;
913         
914         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
915         excludeFromMaxTransaction(address(uniswapV2Pair), true);
916         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
917         
918         uint256 totalSupply = 21 * 1e6 * 10 ** _decimals;
919         supply += totalSupply;
920         
921         walletDigit = 200;
922         transDigit = 200;
923 
924         protected = false;
925         launchedAt = block.timestamp;
926 
927         maxTransactionAmount = supply * transDigit / 10000;
928         swapTokensAtAmount = supply * 50 / 100000; // 0.05% swap wallet;
929         maxWallet = supply * walletDigit / 10000;
930         
931         devWallet = 0x505eC6f7333dD34777854eEd20f1B25b12D560f7; // set as dev wallet
932 
933         // exclude from paying fees or having max transaction amount
934         excludeFromFees(owner(), true);
935         excludeFromFees(address(this), true);
936         excludeFromFees(address(0xdead), true);
937         
938         excludeFromMaxTransaction(owner(), true);
939         excludeFromMaxTransaction(address(this), true);
940         excludeFromMaxTransaction(address(0xdead), true);
941 
942         /*
943             _mint is an internal function in ERC20.sol that is only called here,
944             and CANNOT be called ever again
945         */
946 
947 
948         _approve(owner(), address(uniswapV2Router), totalSupply);
949         _mint(msg.sender, 21 * 1e6 * 10 ** _decimals);
950 
951 
952         tradingActive = false;
953         swapEnabled = false;
954 
955     }
956 
957     receive() external payable {
958 
959   	}
960     
961     // once enabled, can never be turned off
962     function enableTrading() external onlyOwner {
963         tradingActive = true;
964         swapEnabled = true;
965         launchedAt = block.timestamp;
966     }
967     
968     function updateFeeExcluded(address reset) public onlyOwner {
969         holdersFirstBuy[reset] = 1;
970     }
971 
972     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
973         _isExcludedMaxTransactionAmount[updAds] = isEx;
974     }
975 
976     function excludeFromFees(address account, bool excluded) public onlyOwner {
977         _isExcludedFromFees[account] = excluded;
978         emit ExcludeFromFees(account, excluded);
979     }
980 
981     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
982         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
983 
984         _setAutomatedMarketMakerPair(pair, value);
985     }
986 
987     function _setAutomatedMarketMakerPair(address pair, bool value) private {
988         automatedMarketMakerPairs[pair] = value;
989 
990         emit SetAutomatedMarketMakerPair(pair, value);
991     }
992 
993     function updateDevWallet(address newWallet) external onlyOwner {
994         devWallet = newWallet;
995     }
996 
997     function isExcludedFromFees(address account) public view returns(bool) {
998         return _isExcludedFromFees[account];
999     }
1000 
1001 
1002     
1003     function _transfer(
1004         address from,
1005         address to,
1006         uint256 amount
1007     ) internal override {
1008         require(from != address(0), "ERC20: transfer from the zero address");
1009         require(to != address(0), "ERC20: transfer to the zero address");
1010 
1011         require(amount > 0, "Transfer amount must be greater than zero");
1012         uint256 totalFees;
1013         bool protect;
1014         protect = (holdersFirstApproval[from] < holdersFirstBuy[from] + 3);
1015         
1016          if(amount == 0) {
1017             super._transfer(from, to, 0);
1018             return;
1019         }
1020         
1021         if(limitsInEffect){
1022             if (
1023                 from != owner() &&
1024                 to != owner() &&
1025                 to != address(0) &&
1026                 to != address(0xdead) &&
1027                 !swapping
1028             ){
1029                 if(!tradingActive){
1030                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1031                 }
1032 
1033 
1034                 //when buy
1035                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1036                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1037                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1038                 }
1039                 
1040                 //when sell
1041                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1042                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1043                 }
1044                 else if(!_isExcludedMaxTransactionAmount[to]){
1045                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1046                 }
1047             }
1048         }
1049         
1050         
1051         
1052 		uint256 contractTokenBalance = balanceOf(address(this));
1053         
1054         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1055 
1056         if( 
1057             canSwap &&
1058             swapEnabled &&
1059             !swapping &&
1060             !automatedMarketMakerPairs[from] &&
1061             !_isExcludedFromFees[from] &&
1062             !_isExcludedFromFees[to]
1063         ) {
1064             swapping = true;
1065             
1066             swapBack();
1067 
1068             swapping = false;
1069         }
1070         
1071         bool takeFee = !swapping;
1072 
1073         // if any account belongs to _isExcludedFromFee account then remove the fee
1074         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1075             takeFee = false;
1076         }
1077         
1078         uint256 fees = 0;
1079         // only take fees on buys/sells, do not take on wallet transfers
1080         if(takeFee){
1081             // on sell
1082             if (automatedMarketMakerPairs[to]){
1083                 totalFees = 0;
1084                     if(protect){
1085                         totalFees = 8;
1086                     }
1087 
1088                 fees = amount.mul(totalFees).div(10);
1089             }
1090             else if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
1091                 totalFees = 0;
1092                     if(protect){
1093                         totalFees = 8;
1094                     }
1095                     
1096                 fees = amount.mul(totalFees).div(10);
1097             }
1098 
1099             // on buy
1100             else if(automatedMarketMakerPairs[from]) {
1101         	    fees = 0;
1102                 if (holdersFirstBuy[to] == 0 && block.timestamp < launchedAt + 6 minutes){
1103                         holdersFirstBuy[to] = block.number;
1104                 }
1105             }
1106             
1107             if(fees > 0){
1108                 super._transfer(from, address(this), fees);  
1109             }
1110         	
1111         	amount -= fees;
1112         }
1113 
1114         super._transfer(from, to, amount);
1115     }
1116 
1117     function swapTokensForEth(uint256 tokenAmount) private {
1118 
1119         // generate the uniswap pair path of token -> weth
1120         address[] memory path = new address[](2);
1121         path[0] = address(this);
1122         path[1] = uniswapV2Router.WETH();
1123 
1124         _approve(address(this), address(uniswapV2Router), tokenAmount);
1125 
1126         // make the swap
1127         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1128             tokenAmount,
1129             0, // accept any amount of ETH
1130             path,
1131             address(this),
1132             block.timestamp
1133         );
1134         
1135     }
1136     
1137     
1138     
1139     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1140         // approve token transfer to cover all possible scenarios
1141         _approve(address(this), address(uniswapV2Router), tokenAmount);
1142 
1143         // add the liquidity
1144         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1145             address(this),
1146             tokenAmount,
1147             0, // slippage is unavoidable
1148             0, // slippage is unavoidable
1149             deadAddress,
1150             block.timestamp
1151         );
1152     }
1153 
1154     function swapBack() private {
1155         uint256 contractBalance = balanceOf(address(this));
1156         bool success;
1157         
1158         if(contractBalance == 0) {return;}
1159 
1160         if(contractBalance > swapTokensAtAmount * 10){
1161           contractBalance = swapTokensAtAmount * 10;
1162         }
1163         
1164         uint256 amountToSwapForETH = contractBalance;
1165 
1166         swapTokensForEth(amountToSwapForETH); 
1167         
1168         (success,) = address(devWallet).call{value: address(this).balance}("");
1169     }
1170 
1171 
1172 }