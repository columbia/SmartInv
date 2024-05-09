1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             uint256 c = a + b;
108             if (c < a) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b > a) return (false, 0);
121             return (true, a - b);
122         }
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133             // benefit is lost if 'b' is also tested.
134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135             if (a == 0) return (true, 0);
136             uint256 c = a * b;
137             if (c / a != b) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b == 0) return (false, 0);
150             return (true, a / b);
151         }
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a % b);
163         }
164     }
165 
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      *
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a + b;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a - b;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a * b;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator.
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b <= a, errorMessage);
258             return a - b;
259         }
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a / b;
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * reverting with custom message when dividing by zero.
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {tryMod}.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a % b;
308         }
309     }
310 }
311 
312 
313 interface IUniswapV2Router01 {
314     function factory() external pure returns (address);
315     function WETH() external pure returns (address);
316 
317     function addLiquidity(
318         address tokenA,
319         address tokenB,
320         uint amountADesired,
321         uint amountBDesired,
322         uint amountAMin,
323         uint amountBMin,
324         address to,
325         uint deadline
326     ) external returns (uint amountA, uint amountB, uint liquidity);
327     function addLiquidityETH(
328         address token,
329         uint amountTokenDesired,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline
334     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
335     function removeLiquidity(
336         address tokenA,
337         address tokenB,
338         uint liquidity,
339         uint amountAMin,
340         uint amountBMin,
341         address to,
342         uint deadline
343     ) external returns (uint amountA, uint amountB);
344     function removeLiquidityETH(
345         address token,
346         uint liquidity,
347         uint amountTokenMin,
348         uint amountETHMin,
349         address to,
350         uint deadline
351     ) external returns (uint amountToken, uint amountETH);
352     function removeLiquidityWithPermit(
353         address tokenA,
354         address tokenB,
355         uint liquidity,
356         uint amountAMin,
357         uint amountBMin,
358         address to,
359         uint deadline,
360         bool approveMax, uint8 v, bytes32 r, bytes32 s
361     ) external returns (uint amountA, uint amountB);
362     function removeLiquidityETHWithPermit(
363         address token,
364         uint liquidity,
365         uint amountTokenMin,
366         uint amountETHMin,
367         address to,
368         uint deadline,
369         bool approveMax, uint8 v, bytes32 r, bytes32 s
370     ) external returns (uint amountToken, uint amountETH);
371     function swapExactTokensForTokens(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external returns (uint[] memory amounts);
378     function swapTokensForExactTokens(
379         uint amountOut,
380         uint amountInMax,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external returns (uint[] memory amounts);
385     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
386         external
387         payable
388         returns (uint[] memory amounts);
389     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
390         external
391         returns (uint[] memory amounts);
392     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
393         external
394         returns (uint[] memory amounts);
395     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
396         external
397         payable
398         returns (uint[] memory amounts);
399 
400     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
401     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
402     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
403     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
404     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
405 }
406 
407 
408 pragma solidity >=0.6.2;
409 
410 interface IUniswapV2Router02 is IUniswapV2Router01 {
411     function removeLiquidityETHSupportingFeeOnTransferTokens(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountETH);
419     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
420         address token,
421         uint liquidity,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline,
426         bool approveMax, uint8 v, bytes32 r, bytes32 s
427     ) external returns (uint amountETH);
428 
429     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
430         uint amountIn,
431         uint amountOutMin,
432         address[] calldata path,
433         address to,
434         uint deadline
435     ) external;
436     function swapExactETHForTokensSupportingFeeOnTransferTokens(
437         uint amountOutMin,
438         address[] calldata path,
439         address to,
440         uint deadline
441     ) external payable;
442     function swapExactTokensForETHSupportingFeeOnTransferTokens(
443         uint amountIn,
444         uint amountOutMin,
445         address[] calldata path,
446         address to,
447         uint deadline
448     ) external;
449 }
450 
451 
452 
453 
454 pragma solidity >=0.5.0;
455 
456 interface IUniswapV2Pair {
457     event Approval(address indexed owner, address indexed spender, uint value);
458     event Transfer(address indexed from, address indexed to, uint value);
459 
460     function name() external pure returns (string memory);
461     function symbol() external pure returns (string memory);
462     function decimals() external pure returns (uint8);
463     function totalSupply() external view returns (uint);
464     function balanceOf(address owner) external view returns (uint);
465     function allowance(address owner, address spender) external view returns (uint);
466 
467     function approve(address spender, uint value) external returns (bool);
468     function transfer(address to, uint value) external returns (bool);
469     function transferFrom(address from, address to, uint value) external returns (bool);
470 
471     function DOMAIN_SEPARATOR() external view returns (bytes32);
472     function PERMIT_TYPEHASH() external pure returns (bytes32);
473     function nonces(address owner) external view returns (uint);
474 
475     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
476 
477     event Mint(address indexed sender, uint amount0, uint amount1);
478     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
479     event Swap(
480         address indexed sender,
481         uint amount0In,
482         uint amount1In,
483         uint amount0Out,
484         uint amount1Out,
485         address indexed to
486     );
487     event Sync(uint112 reserve0, uint112 reserve1);
488 
489     function MINIMUM_LIQUIDITY() external pure returns (uint);
490     function factory() external view returns (address);
491     function token0() external view returns (address);
492     function token1() external view returns (address);
493     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
494     function price0CumulativeLast() external view returns (uint);
495     function price1CumulativeLast() external view returns (uint);
496     function kLast() external view returns (uint);
497 
498     function mint(address to) external returns (uint liquidity);
499     function burn(address to) external returns (uint amount0, uint amount1);
500     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
501     function skim(address to) external;
502     function sync() external;
503 
504     function initialize(address, address) external;
505 }
506 
507 
508 pragma solidity >=0.5.0;
509 
510 interface IUniswapV2Factory {
511     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
512 
513     function feeTo() external view returns (address);
514     function feeToSetter() external view returns (address);
515 
516     function getPair(address tokenA, address tokenB) external view returns (address pair);
517     function allPairs(uint) external view returns (address pair);
518     function allPairsLength() external view returns (uint);
519 
520     function createPair(address tokenA, address tokenB) external returns (address pair);
521 
522     function setFeeTo(address) external;
523     function setFeeToSetter(address) external;
524 }
525 
526 
527 interface IERC20 {
528     /**
529      * @dev Returns the amount of tokens in existence.
530      */
531     function totalSupply() external view returns (uint256);
532 
533     /**
534      * @dev Returns the amount of tokens owned by `account`.
535      */
536     function balanceOf(address account) external view returns (uint256);
537 
538     /**
539      * @dev Moves `amount` tokens from the caller's account to `recipient`.
540      *
541      * Returns a boolean value indicating whether the operation succeeded.
542      *
543      * Emits a {Transfer} event.
544      */
545     function transfer(address recipient, uint256 amount) external returns (bool);
546 
547     /**
548      * @dev Returns the remaining number of tokens that `spender` will be
549      * allowed to spend on behalf of `owner` through {transferFrom}. This is
550      * zero by default.
551      *
552      * This value changes when {approve} or {transferFrom} are called.
553      */
554     function allowance(address owner, address spender) external view returns (uint256);
555 
556     /**
557      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
558      *
559      * Returns a boolean value indicating whether the operation succeeded.
560      *
561      * IMPORTANT: Beware that changing an allowance with this method brings the risk
562      * that someone may use both the old and the new allowance by unfortunate
563      * transaction ordering. One possible solution to mitigate this race
564      * condition is to first reduce the spender's allowance to 0 and set the
565      * desired value afterwards:
566      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
567      *
568      * Emits an {Approval} event.
569      */
570     function approve(address spender, uint256 amount) external returns (bool);
571 
572     /**
573      * @dev Moves `amount` tokens from `sender` to `recipient` using the
574      * allowance mechanism. `amount` is then deducted from the caller's
575      * allowance.
576      *
577      * Returns a boolean value indicating whether the operation succeeded.
578      *
579      * Emits a {Transfer} event.
580      */
581     function transferFrom(
582         address sender,
583         address recipient,
584         uint256 amount
585     ) external returns (bool);
586 
587     /**
588      * @dev Emitted when `value` tokens are moved from one account (`from`) to
589      * another (`to`).
590      *
591      * Note that `value` may be zero.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 value);
594 
595     /**
596      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
597      * a call to {approve}. `value` is the new allowance.
598      */
599     event Approval(address indexed owner, address indexed spender, uint256 value);
600 }
601 
602 interface IERC20Metadata is IERC20 {
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() external view returns (string memory);
607 
608     /**
609      * @dev Returns the symbol of the token.
610      */
611     function symbol() external view returns (string memory);
612 
613     /**
614      * @dev Returns the decimals places of the token.
615      */
616     function decimals() external view returns (uint8);
617 }
618 
619 contract HUNTER is Context, Ownable, IERC20, IERC20Metadata{
620     using SafeMath for uint256;
621 
622     IUniswapV2Router02 private uniswapV2Router;
623     address public uniswapV2Pair;
624 
625     mapping (address => uint256) private _balances;
626 
627     mapping (address => mapping (address => uint256)) private _allowances;
628     mapping (address => uint256) private _transferDelay;
629     mapping (address => bool) private _holderDelay;
630     mapping(address => bool) public nomorewhales;
631 
632     uint256 private _totalSupply;
633     string private _name;
634     string private _symbol;
635     uint8 private _decimals;
636     uint256 private wentLive = 0;
637     bool private tradingActive = false;
638 
639     // exlcude from fees and max transaction amount
640     mapping (address => bool) private _isExempt;
641 
642 
643     constructor () {
644         _name = 'The Twitter Files';
645         _symbol = 'FILES';
646         _decimals = 18;
647         _totalSupply = 1_000_000_000 * 1e18;
648 
649         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
650         uniswapV2Router = _uniswapV2Router;
651         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
652 
653         _isExempt[address(msg.sender)] = true;
654         _isExempt[address(this)] = true;
655         _isExempt[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
656 
657         _balances[msg.sender] = _totalSupply;
658 
659         emit Transfer(address(0), msg.sender, _totalSupply); // Optional
660     }
661 
662     function name() public view returns (string memory) {
663         return _name;
664     }
665 
666     function symbol() public view returns (string memory) {
667         return _symbol;
668     }
669 
670     function decimals() public view returns (uint8) {
671         return _decimals;
672     }
673 
674     function totalSupply() public view override returns (uint256) {
675         return _totalSupply;
676     }
677 
678     function balanceOf(address account) public view override returns (uint256) {
679         return _balances[account];
680     }
681 
682     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
683         _transfer(_msgSender(), recipient, amount);
684         return true;
685     }
686 
687     function allowance(address owner, address spender) public view virtual override returns (uint256) {
688         return _allowances[owner][spender];
689     }
690 
691     function approve(address spender, uint256 amount) public virtual override returns (bool) {
692         _approve(_msgSender(), spender, amount);
693         return true;
694     }
695 
696     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
697         _transfer(sender, recipient, amount);
698         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
699         return true;
700     }
701 
702     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
703         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
704         return true;
705     }
706 
707     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
708         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
709         return true;
710     }
711 
712     function tradingLive() external onlyOwner {
713         tradingActive = true;
714         wentLive = block.number;
715     }
716 
717     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
718         require(sender != address(0), "ERC20: transfer from the zero address");
719         require(recipient != address(0), "ERC20: transfer to the zero address");
720         require(!nomorewhales[sender] && !nomorewhales[recipient], "TOKEN: You are a bad actor!");
721         if (!tradingActive) {
722             require( _isExempt[sender] || _isExempt[recipient], "Trading is not active.");
723         }
724         
725         if (wentLive > block.number - 50) {
726             bool oktoswap;
727             address orig = tx.origin;
728             oktoswap = transferDelay(sender,recipient,orig);
729             require(oktoswap, "transfer delay enabled");
730         }
731 
732         _beforeTokenTransfer(sender, recipient, amount);
733 
734         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
735         _balances[recipient] = _balances[recipient].add(amount);
736         emit Transfer(sender, recipient, amount);
737     }
738 
739     function _approve(address owner, address spender, uint256 amount) internal virtual {
740         require(owner != address(0), "ERC20: approve from the zero address");
741         require(spender != address(0), "ERC20: approve to the zero address");
742 
743         _allowances[owner][spender] = amount;
744         emit Approval(owner, spender, amount);
745     }
746 
747   
748     function _setupDecimals(uint8 decimals_) internal {
749         _decimals = decimals_;
750     }
751 
752     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { 
753         
754     }
755 
756    function unwantedWallets(address[] memory wallets_) public onlyOwner {
757        require(block.number < wentLive + 100, "unable to blacklist anymore");
758         for (uint256 i = 0; i < wallets_.length; i++) {
759             nomorewhales[wallets_[i]] = true;
760         }
761     }
762 
763     function wantedWallets(address wallets) public onlyOwner {
764         nomorewhales[wallets] = false;
765     }
766 
767  function transferDelay(address from, address to, address orig) internal returns (bool) {
768     bool oktoswap = true;
769     if (uniswapV2Pair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
770     else if (uniswapV2Pair == to) {
771             if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
772                 if (_holderDelay[from]) { oktoswap = false; }
773             else if (uniswapV2Pair != to && uniswapV2Pair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
774         }
775         return (oktoswap);
776     }
777 }