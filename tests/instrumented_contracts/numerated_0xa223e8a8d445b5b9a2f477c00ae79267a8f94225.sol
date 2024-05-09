1 /**
2  The purpose of the protocol is to give people a chance to place leverage on Memecoins. 
3  Use your knowledge of the meme space to make 2x- 1000x just by guessing if a token price will rise 
4  or fall. Users will be able to choose their leverage and the amounts. 
5  Theoretically a Memecoin master could make a substantial amount of money without having to buy any 
6  coins. Keep in mind that even though leverage trading can be extremely lucrative it can also be very
7 risky.
8 
9 Telegram: https://t.me/memeprotocoleth
10 Twitter: https://twitter.com/protocol_meme
11 Medium: https://memeprotocol.medium.com/meme-protocol-7f2ae956892a
12 
13 5% Tax
14 2% max tx and wallet until limits are lifted
15 
16 Telegram announcement channel is currently being used to avoid early fud and bot attcks
17 Community telegram will be made shortly
18 
19 
20 */
21 
22 
23 
24 //SPDX-License-Identifier: Unlicensed
25 pragma solidity 0.8.9;
26  
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31  
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37  
38 interface IUniswapV2Pair {
39     event Approval(address indexed owner, address indexed spender, uint value);
40     event Transfer(address indexed from, address indexed to, uint value);
41  
42     function name() external pure returns (string memory);
43     function symbol() external pure returns (string memory);
44     function decimals() external pure returns (uint8);
45     function totalSupply() external view returns (uint);
46     function balanceOf(address owner) external view returns (uint);
47     function allowance(address owner, address spender) external view returns (uint);
48  
49     function approve(address spender, uint value) external returns (bool);
50     function transfer(address to, uint value) external returns (bool);
51     function transferFrom(address from, address to, uint value) external returns (bool);
52  
53     function DOMAIN_SEPARATOR() external view returns (bytes32);
54     function PERMIT_TYPEHASH() external pure returns (bytes32);
55     function nonces(address owner) external view returns (uint);
56  
57     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
58  
59     event Mint(address indexed sender, uint amount0, uint amount1);
60     event Swap(
61         address indexed sender,
62         uint amount0In,
63         uint amount1In,
64         uint amount0Out,
65         uint amount1Out,
66         address indexed to
67     );
68     event Sync(uint112 reserve0, uint112 reserve1);
69  
70     function MINIMUM_LIQUIDITY() external pure returns (uint);
71     function factory() external view returns (address);
72     function token0() external view returns (address);
73     function token1() external view returns (address);
74     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
75     function price0CumulativeLast() external view returns (uint);
76     function price1CumulativeLast() external view returns (uint);
77     function kLast() external view returns (uint);
78  
79     function mint(address to) external returns (uint liquidity);
80     function burn(address to) external returns (uint amount0, uint amount1);
81     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
82     function skim(address to) external;
83     function sync() external;
84  
85     function initialize(address, address) external;
86 }
87  
88 interface IUniswapV2Factory {
89     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
90  
91     function feeTo() external view returns (address);
92     function feeToSetter() external view returns (address);
93  
94     function getPair(address tokenA, address tokenB) external view returns (address pair);
95     function allPairs(uint) external view returns (address pair);
96     function allPairsLength() external view returns (uint);
97  
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99  
100     function setFeeTo(address) external;
101     function setFeeToSetter(address) external;
102 }
103  
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109  
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114  
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123  
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132  
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148  
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) external returns (bool);
163  
164     /**
165      * @dev Emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * Note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171  
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178  
179 interface IERC20Metadata is IERC20 {
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() external view returns (string memory);
184  
185     /**
186      * @dev Returns the symbol of the token.
187      */
188     function symbol() external view returns (string memory);
189  
190     /**
191      * @dev Returns the decimals places of the token.
192      */
193     function decimals() external view returns (uint8);
194 }
195  
196  
197 contract ERC20 is Context, IERC20, IERC20Metadata {
198     using SafeMath for uint256;
199  
200     mapping(address => uint256) private _balances;
201  
202     mapping(address => mapping(address => uint256)) private _allowances;
203  
204     uint256 private _totalSupply;
205  
206     string private _name;
207     string private _symbol;
208  
209     /**
210      * @dev Sets the values for {name} and {symbol}.
211      *
212      * The default value of {decimals} is 18. To select a different value for
213      * {decimals} you should overload it.
214      *
215      * All two of these values are immutable: they can only be set once during
216      * construction.
217      */
218     constructor(string memory name_, string memory symbol_) {
219         _name = name_;
220         _symbol = symbol_;
221     }
222  
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() public view virtual override returns (string memory) {
227         return _name;
228     }
229  
230     /**
231      * @dev Returns the symbol of the token, usually a shorter version of the
232      * name.
233      */
234     function symbol() public view virtual override returns (string memory) {
235         return _symbol;
236     }
237  
238     /**
239      * @dev Returns the number of decimals used to get its user representation.
240      * For example, if `decimals` equals `2`, a balance of `505` tokens should
241      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
242      *
243      * Tokens usually opt for a value of 18, imitating the relationship between
244      * Ether and Wei. This is the value {ERC20} uses, unless this function is
245      * overridden;
246      *
247      * NOTE: This information is only used for _display_ purposes: it in
248      * no way affects any of the arithmetic of the contract, including
249      * {IERC20-balanceOf} and {IERC20-transfer}.
250      */
251     function decimals() public view virtual override returns (uint8) {
252         return 18;
253     }
254  
255     /**
256      * @dev See {IERC20-totalSupply}.
257      */
258     function totalSupply() public view virtual override returns (uint256) {
259         return _totalSupply;
260     }
261  
262     /**
263      * @dev See {IERC20-balanceOf}.
264      */
265     function balanceOf(address account) public view virtual override returns (uint256) {
266         return _balances[account];
267     }
268  
269     /**
270      * @dev See {IERC20-transfer}.
271      *
272      * Requirements:
273      *
274      * - `recipient` cannot be the zero address.
275      * - the caller must have a balance of at least `amount`.
276      */
277     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
278         _transfer(_msgSender(), recipient, amount);
279         return true;
280     }
281  
282     /**
283      * @dev See {IERC20-allowance}.
284      */
285     function allowance(address owner, address spender) public view virtual override returns (uint256) {
286         return _allowances[owner][spender];
287     }
288  
289     /**
290      * @dev See {IERC20-approve}.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function approve(address spender, uint256 amount) public virtual override returns (bool) {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300  
301     /**
302      * @dev See {IERC20-transferFrom}.
303      *
304      * Emits an {Approval} event indicating the updated allowance. This is not
305      * required by the EIP. See the note at the beginning of {ERC20}.
306      *
307      * Requirements:
308      *
309      * - `sender` and `recipient` cannot be the zero address.
310      * - `sender` must have a balance of at least `amount`.
311      * - the caller must have allowance for ``sender``'s tokens of at least
312      * `amount`.
313      */
314     function transferFrom(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) public virtual override returns (bool) {
319         _transfer(sender, recipient, amount);
320         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
321         return true;
322     }
323  
324     /**
325      * @dev Atomically increases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
338         return true;
339     }
340  
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
356         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
357         return true;
358     }
359  
360     /**
361      * @dev Moves tokens `amount` from `sender` to `recipient`.
362      *
363      * This is internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `sender` cannot be the zero address.
371      * - `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      */
374     function _transfer(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) internal virtual {
379         require(sender != address(0), "ERC20: transfer from the zero address");
380         require(recipient != address(0), "ERC20: transfer to the zero address");
381  
382         _beforeTokenTransfer(sender, recipient, amount);
383  
384         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
385         _balances[recipient] = _balances[recipient].add(amount);
386         emit Transfer(sender, recipient, amount);
387     }
388  
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400  
401         _beforeTokenTransfer(address(0), account, amount);
402  
403         _totalSupply = _totalSupply.add(amount);
404         _balances[account] = _balances[account].add(amount);
405         emit Transfer(address(0), account, amount);
406     }
407  
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421  
422         _beforeTokenTransfer(account, address(0), amount);
423  
424         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
425         _totalSupply = _totalSupply.sub(amount);
426         emit Transfer(account, address(0), amount);
427     }
428  
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449  
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453  
454     /**
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be to transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 }
474  
475 library SafeMath {
476     /**
477      * @dev Returns the addition of two unsigned integers, reverting on
478      * overflow.
479      *
480      * Counterpart to Solidity's `+` operator.
481      *
482      * Requirements:
483      *
484      * - Addition cannot overflow.
485      */
486     function add(uint256 a, uint256 b) internal pure returns (uint256) {
487         uint256 c = a + b;
488         require(c >= a, "SafeMath: addition overflow");
489  
490         return c;
491     }
492  
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
504         return sub(a, b, "SafeMath: subtraction overflow");
505     }
506  
507     /**
508      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
509      * overflow (when the result is negative).
510      *
511      * Counterpart to Solidity's `-` operator.
512      *
513      * Requirements:
514      *
515      * - Subtraction cannot overflow.
516      */
517     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b <= a, errorMessage);
519         uint256 c = a - b;
520  
521         return c;
522     }
523  
524     /**
525      * @dev Returns the multiplication of two unsigned integers, reverting on
526      * overflow.
527      *
528      * Counterpart to Solidity's `*` operator.
529      *
530      * Requirements:
531      *
532      * - Multiplication cannot overflow.
533      */
534     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
535         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
536         // benefit is lost if 'b' is also tested.
537         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
538         if (a == 0) {
539             return 0;
540         }
541  
542         uint256 c = a * b;
543         require(c / a == b, "SafeMath: multiplication overflow");
544  
545         return c;
546     }
547  
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts on
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
560     function div(uint256 a, uint256 b) internal pure returns (uint256) {
561         return div(a, b, "SafeMath: division by zero");
562     }
563  
564     /**
565      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
566      * division by zero. The result is rounded towards zero.
567      *
568      * Counterpart to Solidity's `/` operator. Note: this function uses a
569      * `revert` opcode (which leaves remaining gas untouched) while Solidity
570      * uses an invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
577         require(b > 0, errorMessage);
578         uint256 c = a / b;
579         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
580  
581         return c;
582     }
583  
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
597         return mod(a, b, "SafeMath: modulo by zero");
598     }
599  
600     /**
601      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
602      * Reverts with custom message when dividing by zero.
603      *
604      * Counterpart to Solidity's `%` operator. This function uses a `revert`
605      * opcode (which leaves remaining gas untouched) while Solidity uses an
606      * invalid opcode to revert (consuming all remaining gas).
607      *
608      * Requirements:
609      *
610      * - The divisor cannot be zero.
611      */
612     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
613         require(b != 0, errorMessage);
614         return a % b;
615     }
616 }
617  
618 contract Ownable is Context {
619     address private _owner;
620  
621     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
622  
623     /**
624      * @dev Initializes the contract setting the deployer as the initial owner.
625      */
626     constructor () {
627         address msgSender = _msgSender();
628         _owner = msgSender;
629         emit OwnershipTransferred(address(0), msgSender);
630     }
631  
632     /**
633      * @dev Returns the address of the current owner.
634      */
635     function owner() public view returns (address) {
636         return _owner;
637     }
638  
639     /**
640      * @dev Throws if called by any account other than the owner.
641      */
642     modifier onlyOwner() {
643         require(_owner == _msgSender(), "Ownable: caller is not the owner");
644         _;
645     }
646  
647     /**
648      * @dev Leaves the contract without owner. It will not be possible to call
649      * `onlyOwner` functions anymore. Can only be called by the current owner.
650      *
651      * NOTE: Renouncing ownership will leave the contract without an owner,
652      * thereby removing any functionality that is only available to the owner.
653      */
654     function renounceOwnership() public virtual onlyOwner {
655         emit OwnershipTransferred(_owner, address(0));
656         _owner = address(0);
657     }
658  
659     /**
660      * @dev Transfers ownership of the contract to a new account (`newOwner`).
661      * Can only be called by the current owner.
662      */
663     function transferOwnership(address newOwner) public virtual onlyOwner {
664         require(newOwner != address(0), "Ownable: new owner is the zero address");
665         emit OwnershipTransferred(_owner, newOwner);
666         _owner = newOwner;
667     }
668 }
669  
670  
671  
672 library SafeMathInt {
673     int256 private constant MIN_INT256 = int256(1) << 255;
674     int256 private constant MAX_INT256 = ~(int256(1) << 255);
675  
676     /**
677      * @dev Multiplies two int256 variables and fails on overflow.
678      */
679     function mul(int256 a, int256 b) internal pure returns (int256) {
680         int256 c = a * b;
681  
682         // Detect overflow when multiplying MIN_INT256 with -1
683         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
684         require((b == 0) || (c / b == a));
685         return c;
686     }
687  
688     /**
689      * @dev Division of two int256 variables and fails on overflow.
690      */
691     function div(int256 a, int256 b) internal pure returns (int256) {
692         // Prevent overflow when dividing MIN_INT256 by -1
693         require(b != -1 || a != MIN_INT256);
694  
695         // Solidity already throws when dividing by 0.
696         return a / b;
697     }
698  
699     /**
700      * @dev Subtracts two int256 variables and fails on overflow.
701      */
702     function sub(int256 a, int256 b) internal pure returns (int256) {
703         int256 c = a - b;
704         require((b >= 0 && c <= a) || (b < 0 && c > a));
705         return c;
706     }
707  
708     /**
709      * @dev Adds two int256 variables and fails on overflow.
710      */
711     function add(int256 a, int256 b) internal pure returns (int256) {
712         int256 c = a + b;
713         require((b >= 0 && c >= a) || (b < 0 && c < a));
714         return c;
715     }
716  
717     /**
718      * @dev Converts to absolute value, and fails on overflow.
719      */
720     function abs(int256 a) internal pure returns (int256) {
721         require(a != MIN_INT256);
722         return a < 0 ? -a : a;
723     }
724  
725  
726     function toUint256Safe(int256 a) internal pure returns (uint256) {
727         require(a >= 0);
728         return uint256(a);
729     }
730 }
731  
732 library SafeMathUint {
733   function toInt256Safe(uint256 a) internal pure returns (int256) {
734     int256 b = int256(a);
735     require(b >= 0);
736     return b;
737   }
738 }
739  
740  
741 interface IUniswapV2Router01 {
742     function factory() external pure returns (address);
743     function WETH() external pure returns (address);
744  
745     function addLiquidity(
746         address tokenA,
747         address tokenB,
748         uint amountADesired,
749         uint amountBDesired,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB, uint liquidity);
755     function addLiquidityETH(
756         address token,
757         uint amountTokenDesired,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
763     function removeLiquidity(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline
771     ) external returns (uint amountA, uint amountB);
772     function removeLiquidityETH(
773         address token,
774         uint liquidity,
775         uint amountTokenMin,
776         uint amountETHMin,
777         address to,
778         uint deadline
779     ) external returns (uint amountToken, uint amountETH);
780     function removeLiquidityWithPermit(
781         address tokenA,
782         address tokenB,
783         uint liquidity,
784         uint amountAMin,
785         uint amountBMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external returns (uint amountA, uint amountB);
790     function removeLiquidityETHWithPermit(
791         address token,
792         uint liquidity,
793         uint amountTokenMin,
794         uint amountETHMin,
795         address to,
796         uint deadline,
797         bool approveMax, uint8 v, bytes32 r, bytes32 s
798     ) external returns (uint amountToken, uint amountETH);
799     function swapExactTokensForTokens(
800         uint amountIn,
801         uint amountOutMin,
802         address[] calldata path,
803         address to,
804         uint deadline
805     ) external returns (uint[] memory amounts);
806     function swapTokensForExactTokens(
807         uint amountOut,
808         uint amountInMax,
809         address[] calldata path,
810         address to,
811         uint deadline
812     ) external returns (uint[] memory amounts);
813     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
814         external
815         payable
816         returns (uint[] memory amounts);
817     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
818         external
819         returns (uint[] memory amounts);
820     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
821         external
822         returns (uint[] memory amounts);
823     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
824         external
825         payable
826         returns (uint[] memory amounts);
827  
828     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
829     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
830     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
831     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
832     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
833 }
834  
835 interface IUniswapV2Router02 is IUniswapV2Router01 {
836     function removeLiquidityETHSupportingFeeOnTransferTokens(
837         address token,
838         uint liquidity,
839         uint amountTokenMin,
840         uint amountETHMin,
841         address to,
842         uint deadline
843     ) external returns (uint amountETH);
844     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
845         address token,
846         uint liquidity,
847         uint amountTokenMin,
848         uint amountETHMin,
849         address to,
850         uint deadline,
851         bool approveMax, uint8 v, bytes32 r, bytes32 s
852     ) external returns (uint amountETH);
853  
854     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
855         uint amountIn,
856         uint amountOutMin,
857         address[] calldata path,
858         address to,
859         uint deadline
860     ) external;
861     function swapExactETHForTokensSupportingFeeOnTransferTokens(
862         uint amountOutMin,
863         address[] calldata path,
864         address to,
865         uint deadline
866     ) external payable;
867     function swapExactTokensForETHSupportingFeeOnTransferTokens(
868         uint amountIn,
869         uint amountOutMin,
870         address[] calldata path,
871         address to,
872         uint deadline
873     ) external;
874 }
875  
876 contract MemeProtocol is ERC20, Ownable {
877     using SafeMath for uint256;
878  
879     IUniswapV2Router02 public immutable uniswapV2Router;
880     address public immutable uniswapV2Pair;
881  
882     bool private swapping;
883  
884     address private marketingWallet;
885     address private devWallet;
886  
887     uint256 public maxTransactionAmount;
888     uint256 public swapTokensAtAmount;
889     uint256 public maxWallet;
890  
891     bool public limitsInEffect = true;
892     bool public tradingActive = false;
893     bool public swapEnabled = false;
894  
895      // Anti-bot and anti-whale mappings and variables
896     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
897  
898     // Seller Map
899     mapping (address => uint256) private _holderFirstBuyTimestamp;
900  
901     // Blacklist Map
902     mapping (address => bool) private _blacklist;
903     bool public transferDelayEnabled = true;
904  
905     uint256 public buyTotalFees;
906     uint256 public buyMarketingFee;
907     uint256 public buyLiquidityFee;
908     uint256 public buyDevFee;
909  
910     uint256 public sellTotalFees;
911     uint256 public sellMarketingFee;
912     uint256 public sellLiquidityFee;
913     uint256 public sellDevFee;
914  
915     uint256 public tokensForMarketing;
916     uint256 public tokensForLiquidity;
917     uint256 public tokensForDev;
918  
919     // block number of opened trading
920     uint256 launchedAt;
921  
922     /******************/
923  
924     // exclude from fees and max transaction amount
925     mapping (address => bool) private _isExcludedFromFees;
926     mapping (address => bool) public _isExcludedMaxTransactionAmount;
927  
928     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
929     // could be subject to a maximum transfer amount
930     mapping (address => bool) public automatedMarketMakerPairs;
931  
932     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
933  
934     event ExcludeFromFees(address indexed account, bool isExcluded);
935  
936     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
937  
938     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
939  
940     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
941  
942     event SwapAndLiquify(
943         uint256 tokensSwapped,
944         uint256 ethReceived,
945         uint256 tokensIntoLiquidity
946     );
947  
948     event AutoNukeLP();
949  
950     event ManualNukeLP();
951  
952     constructor() ERC20("Meme Protocol", "MEME") {
953  
954         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
955  
956         excludeFromMaxTransaction(address(_uniswapV2Router), true);
957         uniswapV2Router = _uniswapV2Router;
958  
959         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
960         excludeFromMaxTransaction(address(uniswapV2Pair), true);
961         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
962  
963         uint256 _buyMarketingFee = 10;
964         uint256 _buyLiquidityFee = 0;
965         uint256 _buyDevFee = 0;
966  
967         uint256 _sellMarketingFee = 10;
968         uint256 _sellLiquidityFee = 0;
969         uint256 _sellDevFee = 0;
970  
971         uint256 totalSupply = 1 * 1e9 * 1e18;
972  
973         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
974         maxWallet = totalSupply * 20 / 1000; // 2% 
975         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
976  
977         buyMarketingFee = _buyMarketingFee;
978         buyLiquidityFee = _buyLiquidityFee;
979         buyDevFee = _buyDevFee;
980         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
981  
982         sellMarketingFee = _sellMarketingFee;
983         sellLiquidityFee = _sellLiquidityFee;
984         sellDevFee = _sellDevFee;
985         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
986  
987         marketingWallet = address(owner()); // set as marketing wallet
988         devWallet = address(owner()); // set as dev wallet
989  
990         // exclude from paying fees or having max transaction amount
991         excludeFromFees(owner(), true);
992         excludeFromFees(address(this), true);
993         excludeFromFees(address(0xdead), true);
994  
995         excludeFromMaxTransaction(owner(), true);
996         excludeFromMaxTransaction(address(this), true);
997         excludeFromMaxTransaction(address(0xdead), true);
998  
999         /*
1000             _mint is an internal function in ERC20.sol that is only called here,
1001             and CANNOT be called ever again
1002         */
1003         _mint(msg.sender, totalSupply);
1004     }
1005  
1006     receive() external payable {
1007  
1008     }
1009  
1010     // once enabled, can never be turned off
1011     function enableTrading() external onlyOwner {
1012         tradingActive = true;
1013         swapEnabled = true;
1014         launchedAt = block.number;
1015     }
1016  
1017     // remove limits after token is stable
1018     function removeLimits() external onlyOwner returns (bool){
1019         limitsInEffect = false;
1020         return true;
1021     }
1022  
1023     // disable Transfer delay - cannot be reenabled
1024     function disableTransferDelay() external onlyOwner returns (bool){
1025         transferDelayEnabled = false;
1026         return true;
1027     }
1028  
1029      // change the minimum amount of tokens to sell from fees
1030     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1031         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1032         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1033         swapTokensAtAmount = newAmount;
1034         return true;
1035     }
1036  
1037     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1038         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1039         maxTransactionAmount = newNum * (10**18);
1040     }
1041  
1042     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1043         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1044         maxWallet = newNum * (10**18);
1045     }
1046  
1047     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1048         _isExcludedMaxTransactionAmount[updAds] = isEx;
1049     }
1050 
1051           function updateBuyFees(
1052         uint256 _devFee,
1053         uint256 _liquidityFee,
1054         uint256 _marketingFee
1055     ) external onlyOwner {
1056         buyDevFee = _devFee;
1057         buyLiquidityFee = _liquidityFee;
1058         buyMarketingFee = _marketingFee;
1059         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1060         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1061     }
1062 
1063     function updateSellFees(
1064         uint256 _devFee,
1065         uint256 _liquidityFee,
1066         uint256 _marketingFee
1067     ) external onlyOwner {
1068         sellDevFee = _devFee;
1069         sellLiquidityFee = _liquidityFee;
1070         sellMarketingFee = _marketingFee;
1071         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1072         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1073     }
1074  
1075     // only use to disable contract sales if absolutely necessary (emergency use only)
1076     function updateSwapEnabled(bool enabled) external onlyOwner(){
1077         swapEnabled = enabled;
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
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 amount
1120     ) internal override {
1121         require(from != address(0), "ERC20: transfer from the zero address");
1122         require(to != address(0), "ERC20: transfer to the zero address");
1123         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1124          if(amount == 0) {
1125             super._transfer(from, to, 0);
1126             return;
1127         }
1128  
1129         if(limitsInEffect){
1130             if (
1131                 from != owner() &&
1132                 to != owner() &&
1133                 to != address(0) &&
1134                 to != address(0xdead) &&
1135                 !swapping
1136             ){
1137                 if(!tradingActive){
1138                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1139                 }
1140  
1141                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1142                 if (transferDelayEnabled){
1143                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1144                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1145                         _holderLastTransferTimestamp[tx.origin] = block.number;
1146                     }
1147                 }
1148  
1149                 //when buy
1150                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1151                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1152                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1153                 }
1154  
1155                 //when sell
1156                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1157                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1158                 }
1159                 else if(!_isExcludedMaxTransactionAmount[to]){
1160                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1161                 }
1162             }
1163         }
1164  
1165         uint256 contractTokenBalance = balanceOf(address(this));
1166  
1167         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1168  
1169         if( 
1170             canSwap &&
1171             swapEnabled &&
1172             !swapping &&
1173             !automatedMarketMakerPairs[from] &&
1174             !_isExcludedFromFees[from] &&
1175             !_isExcludedFromFees[to]
1176         ) {
1177             swapping = true;
1178  
1179             swapBack();
1180  
1181             swapping = false;
1182         }
1183  
1184         bool takeFee = !swapping;
1185  
1186         // if any account belongs to _isExcludedFromFee account then remove the fee
1187         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1188             takeFee = false;
1189         }
1190  
1191         uint256 fees = 0;
1192         // only take fees on buys/sells, do not take on wallet transfers
1193         if(takeFee){
1194             // on sell
1195             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1196                 fees = amount.mul(sellTotalFees).div(100);
1197                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1198                 tokensForDev += fees * sellDevFee / sellTotalFees;
1199                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1200             }
1201             // on buy
1202             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1203                 fees = amount.mul(buyTotalFees).div(100);
1204                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1205                 tokensForDev += fees * buyDevFee / buyTotalFees;
1206                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1207             }
1208  
1209             if(fees > 0){    
1210                 super._transfer(from, address(this), fees);
1211             }
1212  
1213             amount -= fees;
1214         }
1215  
1216         super._transfer(from, to, amount);
1217     }
1218  
1219     function swapTokensForEth(uint256 tokenAmount) private {
1220  
1221         // generate the uniswap pair path of token -> weth
1222         address[] memory path = new address[](2);
1223         path[0] = address(this);
1224         path[1] = uniswapV2Router.WETH();
1225  
1226         _approve(address(this), address(uniswapV2Router), tokenAmount);
1227  
1228         // make the swap
1229         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1230             tokenAmount,
1231             0, // accept any amount of ETH
1232             path,
1233             address(this),
1234             block.timestamp
1235         );
1236  
1237     }
1238  
1239     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1240         // approve token transfer to cover all possible scenarios
1241         _approve(address(this), address(uniswapV2Router), tokenAmount);
1242  
1243         // add the liquidity
1244         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1245             address(this),
1246             tokenAmount,
1247             0, // slippage is unavoidable
1248             0, // slippage is unavoidable
1249             address(this),
1250             block.timestamp
1251         );
1252     }
1253  
1254     function swapBack() private {
1255         uint256 contractBalance = balanceOf(address(this));
1256         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1257         bool success;
1258  
1259         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1260  
1261         if(contractBalance > swapTokensAtAmount * 20){
1262           contractBalance = swapTokensAtAmount * 20;
1263         }
1264  
1265         // Halve the amount of liquidity tokens
1266         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1267         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1268  
1269         uint256 initialETHBalance = address(this).balance;
1270  
1271         swapTokensForEth(amountToSwapForETH); 
1272  
1273         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1274  
1275         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1276         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1277         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1278  
1279  
1280         tokensForLiquidity = 0;
1281         tokensForMarketing = 0;
1282         tokensForDev = 0;
1283  
1284         (success,) = address(devWallet).call{value: ethForDev}("");
1285  
1286         if(liquidityTokens > 0 && ethForLiquidity > 0){
1287             addLiquidity(liquidityTokens, ethForLiquidity);
1288             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1289         }
1290  
1291         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1292     }
1293 }