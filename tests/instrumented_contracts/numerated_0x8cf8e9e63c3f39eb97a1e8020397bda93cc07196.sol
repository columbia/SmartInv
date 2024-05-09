1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, with an overflow flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             uint256 c = a + b;
109             if (c < a) return (false, 0);
110             return (true, c);
111         }
112     }
113 
114     /**
115      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b > a) return (false, 0);
122             return (true, a - b);
123         }
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         unchecked {
133             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134             // benefit is lost if 'b' is also tested.
135             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136             if (a == 0) return (true, 0);
137             uint256 c = a * b;
138             if (c / a != b) return (false, 0);
139             return (true, c);
140         }
141     }
142 
143     /**
144      * @dev Returns the division of two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a / b);
152         }
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b == 0) return (false, 0);
163             return (true, a % b);
164         }
165     }
166 
167     /**
168      * @dev Returns the addition of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `+` operator.
172      *
173      * Requirements:
174      *
175      * - Addition cannot overflow.
176      */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a + b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a - b;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      *
203      * - Multiplication cannot overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a * b;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers, reverting on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator.
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a % b;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {trySub}.
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(
253         uint256 a,
254         uint256 b,
255         string memory errorMessage
256     ) internal pure returns (uint256) {
257         unchecked {
258             require(b <= a, errorMessage);
259             return a - b;
260         }
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(
276         uint256 a,
277         uint256 b,
278         string memory errorMessage
279     ) internal pure returns (uint256) {
280         unchecked {
281             require(b > 0, errorMessage);
282             return a / b;
283         }
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * reverting with custom message when dividing by zero.
289      *
290      * CAUTION: This function is deprecated because it requires allocating memory for the error
291      * message unnecessarily. For custom revert reasons use {tryMod}.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a % b;
309         }
310     }
311 }
312 
313 
314 interface IUniswapV2Router01 {
315     function factory() external pure returns (address);
316     function WETH() external pure returns (address);
317 
318     function addLiquidity(
319         address tokenA,
320         address tokenB,
321         uint amountADesired,
322         uint amountBDesired,
323         uint amountAMin,
324         uint amountBMin,
325         address to,
326         uint deadline
327     ) external returns (uint amountA, uint amountB, uint liquidity);
328     function addLiquidityETH(
329         address token,
330         uint amountTokenDesired,
331         uint amountTokenMin,
332         uint amountETHMin,
333         address to,
334         uint deadline
335     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
336     function removeLiquidity(
337         address tokenA,
338         address tokenB,
339         uint liquidity,
340         uint amountAMin,
341         uint amountBMin,
342         address to,
343         uint deadline
344     ) external returns (uint amountA, uint amountB);
345     function removeLiquidityETH(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline
352     ) external returns (uint amountToken, uint amountETH);
353     function removeLiquidityWithPermit(
354         address tokenA,
355         address tokenB,
356         uint liquidity,
357         uint amountAMin,
358         uint amountBMin,
359         address to,
360         uint deadline,
361         bool approveMax, uint8 v, bytes32 r, bytes32 s
362     ) external returns (uint amountA, uint amountB);
363     function removeLiquidityETHWithPermit(
364         address token,
365         uint liquidity,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline,
370         bool approveMax, uint8 v, bytes32 r, bytes32 s
371     ) external returns (uint amountToken, uint amountETH);
372     function swapExactTokensForTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external returns (uint[] memory amounts);
379     function swapTokensForExactTokens(
380         uint amountOut,
381         uint amountInMax,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external returns (uint[] memory amounts);
386     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
387         external
388         payable
389         returns (uint[] memory amounts);
390     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
391         external
392         returns (uint[] memory amounts);
393     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
394         external
395         returns (uint[] memory amounts);
396     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
397         external
398         payable
399         returns (uint[] memory amounts);
400 
401     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
402     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
403     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
404     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
405     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
406 }
407 
408 
409 pragma solidity >=0.6.2;
410 
411 interface IUniswapV2Router02 is IUniswapV2Router01 {
412     function removeLiquidityETHSupportingFeeOnTransferTokens(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountETH);
420     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
421         address token,
422         uint liquidity,
423         uint amountTokenMin,
424         uint amountETHMin,
425         address to,
426         uint deadline,
427         bool approveMax, uint8 v, bytes32 r, bytes32 s
428     ) external returns (uint amountETH);
429 
430     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
431         uint amountIn,
432         uint amountOutMin,
433         address[] calldata path,
434         address to,
435         uint deadline
436     ) external;
437     function swapExactETHForTokensSupportingFeeOnTransferTokens(
438         uint amountOutMin,
439         address[] calldata path,
440         address to,
441         uint deadline
442     ) external payable;
443     function swapExactTokensForETHSupportingFeeOnTransferTokens(
444         uint amountIn,
445         uint amountOutMin,
446         address[] calldata path,
447         address to,
448         uint deadline
449     ) external;
450 }
451 
452 
453 
454 
455 pragma solidity >=0.5.0;
456 
457 interface IUniswapV2Pair {
458     event Approval(address indexed owner, address indexed spender, uint value);
459     event Transfer(address indexed from, address indexed to, uint value);
460 
461     function name() external pure returns (string memory);
462     function symbol() external pure returns (string memory);
463     function decimals() external pure returns (uint8);
464     function totalSupply() external view returns (uint);
465     function balanceOf(address owner) external view returns (uint);
466     function allowance(address owner, address spender) external view returns (uint);
467 
468     function approve(address spender, uint value) external returns (bool);
469     function transfer(address to, uint value) external returns (bool);
470     function transferFrom(address from, address to, uint value) external returns (bool);
471 
472     function DOMAIN_SEPARATOR() external view returns (bytes32);
473     function PERMIT_TYPEHASH() external pure returns (bytes32);
474     function nonces(address owner) external view returns (uint);
475 
476     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
477 
478     event Mint(address indexed sender, uint amount0, uint amount1);
479     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
480     event Swap(
481         address indexed sender,
482         uint amount0In,
483         uint amount1In,
484         uint amount0Out,
485         uint amount1Out,
486         address indexed to
487     );
488     event Sync(uint112 reserve0, uint112 reserve1);
489 
490     function MINIMUM_LIQUIDITY() external pure returns (uint);
491     function factory() external view returns (address);
492     function token0() external view returns (address);
493     function token1() external view returns (address);
494     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
495     function price0CumulativeLast() external view returns (uint);
496     function price1CumulativeLast() external view returns (uint);
497     function kLast() external view returns (uint);
498 
499     function mint(address to) external returns (uint liquidity);
500     function burn(address to) external returns (uint amount0, uint amount1);
501     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
502     function skim(address to) external;
503     function sync() external;
504 
505     function initialize(address, address) external;
506 }
507 
508 
509 pragma solidity >=0.5.0;
510 
511 interface IUniswapV2Factory {
512     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
513 
514     function feeTo() external view returns (address);
515     function feeToSetter() external view returns (address);
516 
517     function getPair(address tokenA, address tokenB) external view returns (address pair);
518     function allPairs(uint) external view returns (address pair);
519     function allPairsLength() external view returns (uint);
520 
521     function createPair(address tokenA, address tokenB) external returns (address pair);
522 
523     function setFeeTo(address) external;
524     function setFeeToSetter(address) external;
525 }
526 
527 
528 
529 
530 interface IERC20 {
531     /**
532      * @dev Returns the amount of tokens in existence.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     /**
537      * @dev Returns the amount of tokens owned by `account`.
538      */
539     function balanceOf(address account) external view returns (uint256);
540 
541     /**
542      * @dev Moves `amount` tokens from the caller's account to `recipient`.
543      *
544      * Returns a boolean value indicating whether the operation succeeded.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transfer(address recipient, uint256 amount) external returns (bool);
549 
550     /**
551      * @dev Returns the remaining number of tokens that `spender` will be
552      * allowed to spend on behalf of `owner` through {transferFrom}. This is
553      * zero by default.
554      *
555      * This value changes when {approve} or {transferFrom} are called.
556      */
557     function allowance(address owner, address spender) external view returns (uint256);
558 
559     /**
560      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
561      *
562      * Returns a boolean value indicating whether the operation succeeded.
563      *
564      * IMPORTANT: Beware that changing an allowance with this method brings the risk
565      * that someone may use both the old and the new allowance by unfortunate
566      * transaction ordering. One possible solution to mitigate this race
567      * condition is to first reduce the spender's allowance to 0 and set the
568      * desired value afterwards:
569      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
570      *
571      * Emits an {Approval} event.
572      */
573     function approve(address spender, uint256 amount) external returns (bool);
574 
575     /**
576      * @dev Moves `amount` tokens from `sender` to `recipient` using the
577      * allowance mechanism. `amount` is then deducted from the caller's
578      * allowance.
579      *
580      * Returns a boolean value indicating whether the operation succeeded.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address sender,
586         address recipient,
587         uint256 amount
588     ) external returns (bool);
589 
590     /**
591      * @dev Emitted when `value` tokens are moved from one account (`from`) to
592      * another (`to`).
593      *
594      * Note that `value` may be zero.
595      */
596     event Transfer(address indexed from, address indexed to, uint256 value);
597 
598     /**
599      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
600      * a call to {approve}. `value` is the new allowance.
601      */
602     event Approval(address indexed owner, address indexed spender, uint256 value);
603 }
604 
605 interface IERC20Metadata is IERC20 {
606     /**
607      * @dev Returns the name of the token.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the symbol of the token.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the decimals places of the token.
618      */
619     function decimals() external view returns (uint8);
620 }
621 
622 contract FURBALL is Context, Ownable, IERC20, IERC20Metadata{
623     using SafeMath for uint256;
624 
625     IUniswapV2Router02 private uniswapV2Router;
626     address public uniswapV2Pair;
627 
628     mapping (address => uint256) private _balances;
629 
630     mapping (address => mapping (address => uint256)) private _allowances;
631     mapping (address => uint256) private _transferDelay;
632     mapping (address => bool) private _holderDelay;
633     mapping (address => bool) private _presaleList;
634     mapping (address => bool) public blacklist;
635 
636     uint256 private _totalSupply;
637     string private _name;
638     string private _symbol;
639     uint8 private _decimals;
640     uint256 private openedAt = 0;
641     bool private tradingActive = false;
642     bool private presaleActive = false;
643     bool private _transferDelayEnabled = false;
644     bool private _blacklistEnabled = true;
645     bool private _taxEnabled = true;
646     bool public _limitsEnabled;
647     uint256 private maxTxAmount;
648     uint256 private maxWallet;
649     address private uniswapV3NFT;
650     bool private protectUniV3LPAdd = true;
651 
652     // exlcude from fees and max transaction amount
653     mapping (address => bool) public _isExempt;
654 
655 
656     constructor() {
657         _name = 'FUR BALL';
658         _symbol = 'FUR';
659         _decimals = 18;
660         _totalSupply = 1_000_000_000 * 1e18;
661 
662        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // uniswapv2
663         uniswapV2Router = _uniswapV2Router;
664         uniswapV3NFT = address(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
665 
666         _isExempt[address(msg.sender)] = true;
667         _isExempt[address(this)] = true;
668         _isExempt[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
669         _isExempt[address(0xdead)];
670         
671 
672         _balances[msg.sender] = _totalSupply;
673 
674         emit Transfer(address(0), msg.sender, _totalSupply); // Optional
675     }
676 
677     function name() public view returns (string memory) {
678         return _name;
679     }
680 
681     function setPair(address _univ2pair) external onlyOwner {
682         uniswapV2Pair = _univ2pair;
683     }
684 
685     function symbol() public view returns (string memory) {
686         return _symbol;
687     }
688 
689     function decimals() public view returns (uint8) {
690         return _decimals;
691     }
692 
693     function totalSupply() public view override returns (uint256) {
694         return _totalSupply;
695     }
696 
697     function balanceOf(address account) public view override returns (uint256) {
698         return _balances[account];
699     }
700 
701     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
702         _transfer(_msgSender(), recipient, amount);
703         return true;
704     }
705 
706     function allowance(address owner, address spender) public view virtual override returns (uint256) {
707         return _allowances[owner][spender];
708     }
709 
710     function approve(address spender, uint256 amount) public virtual override returns (bool) {
711         _approve(_msgSender(), spender, amount);
712         return true;
713     }
714 
715     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
716         _transfer(sender, recipient, amount);
717         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
718         return true;
719     }
720 
721     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
722         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
723         return true;
724     }
725 
726     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
728         return true;
729     }
730 
731     function openTrade() external onlyOwner {
732         tradingActive = true;
733          openedAt = block.number;
734     }
735 
736     function openPresale() external onlyOwner {
737         maxTxAmount = _totalSupply.div(200); // 0.5%
738         maxWallet = _totalSupply.div(200); // 0.5%
739         _limitsEnabled = true;
740         _transferDelayEnabled = true;
741         presaleActive = true;
742     }
743 
744     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
745         require(sender != address(0), "ERC20: transfer from the zero address");
746         require(recipient != address(0), "ERC20: transfer to the zero address");
747         require(!blacklist[sender] && !blacklist[recipient], "TOKEN: You are a bad actor!");
748 
749         if (!presaleActive) {
750             require( _isExempt[sender] || _isExempt[recipient], "Presale Trading is not active."); 
751         }
752 
753         if (!tradingActive) {
754             require( _isExempt[sender] || _isExempt[recipient] || _presaleList[sender] || _presaleList[recipient], "Trading is not active.");
755         }
756 
757         if (protectUniV3LPAdd && (sender == uniswapV3NFT || recipient == uniswapV3NFT)) {
758             require(_isExempt[sender] || _isExempt[recipient], "You are not authorized to add LP to Univ3");
759         }
760         
761         if (_transferDelayEnabled) {
762             bool oktoswap;
763             oktoswap = transferDelay(sender,recipient,tx.origin);
764             require(oktoswap, "transfer delay enabled");
765         }
766 
767         if (_limitsEnabled) {
768             //on buys
769             if (sender == uniswapV2Pair && !_isExempt[recipient]) {
770                 require(amount <= maxTxAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
771                 require(amount + _balances[recipient] <= maxWallet, "Max wallet exceeded");
772             }
773             //on sells
774             else if (recipient == uniswapV2Pair && !_isExempt[sender]) {
775                 require(amount <= maxTxAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
776             }
777             // on transfers
778             else if(!_isExempt[recipient]){
779                 require(amount + _balances[recipient] <= maxWallet, "Max wallet exceeded");
780             }
781         }
782 
783         _beforeTokenTransfer(sender, recipient, amount);
784 
785         if (_taxEnabled && !((_isExempt[sender]) || (_isExempt[recipient]))) {
786             uint256 burnAmount = amount.mul(10).div(100); // 10%
787             amount = amount.sub(burnAmount);
788             burnEarlyTaxes(sender,burnAmount);
789         }
790        
791         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
792         _balances[recipient] = _balances[recipient].add(amount);
793         emit Transfer(sender, recipient, amount);
794     }
795 
796     function _approve(address owner, address spender, uint256 amount) internal virtual {
797         require(owner != address(0), "ERC20: approve from the zero address");
798         require(spender != address(0), "ERC20: approve to the zero address");
799 
800         _allowances[owner][spender] = amount;
801         emit Approval(owner, spender, amount);
802     }
803 
804     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { 
805     }
806 
807     function airdropPresalers(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
808         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
809         require(wallets.length < 200, "200 limit for gas fees");
810         for(uint256 i = 0; i < wallets.length; i++){
811             address wallet = wallets[i];
812             uint256 amount = amountsInTokens[i]*1e18;
813             _presaleList[wallet] = true;
814             _transfer(msg.sender, wallet, amount);
815         }
816     }
817 
818    function setBlacklist(address[] memory wallets_) public onlyOwner {
819        require(_blacklistEnabled, "unable to blacklist anymore");
820         for (uint256 i = 0; i < wallets_.length; i++) {
821             blacklist[wallets_[i]] = true;
822         }
823     }
824 
825     function disableTransferDelay() public onlyOwner {
826         _transferDelayEnabled = false;
827     }
828 
829 
830     function disableUniV3LPProtect() public onlyOwner {
831         protectUniV3LPAdd = false;
832     }
833 
834     function disableBlacklist() public onlyOwner {
835         _blacklistEnabled = false;
836     }
837 
838     function disableTax() public onlyOwner {
839         _taxEnabled = false;
840     }
841 
842     function disableLimits() public onlyOwner {
843         _limitsEnabled = false;
844     }
845 
846     function removeBlacklist(address wallets) public onlyOwner {
847         blacklist[wallets] = false;
848     }
849 
850     function prepMigration() public onlyOwner {
851         _transferDelayEnabled = false;
852         _taxEnabled = false;
853         _limitsEnabled = false;
854     }
855 
856     function withdrawStuckETH() external onlyOwner {
857         bool success;
858         (success, ) = address(msg.sender).call{value: address(this).balance}(
859             ""
860         );
861     }
862 
863     function updateLimits(uint256 _txAmount, uint256 _walletAmount)
864         external
865         onlyOwner
866     {
867         maxTxAmount = _txAmount*1e18;
868         maxWallet = _walletAmount*1e18;
869     }
870 
871     function burnEarlyTaxes(address sender, uint256 _amount) private {
872         if (_amount == 0) {
873             return;
874         }
875         address deadAddress = address(0xdead);
876         _balances[sender] = _balances[sender].sub(_amount, "ERC20: transfer amount exceeds balance");
877         _balances[deadAddress] = _balances[deadAddress].add(_amount);
878         emit Transfer(sender, deadAddress, _amount);
879     }
880 
881     function transferDelay(address from, address to, address orig) internal returns (bool) {
882      bool oktoswap = true;
883         if (uniswapV2Pair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
884         else if (uniswapV2Pair == to) {
885             if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
886                 if (_holderDelay[from]) { oktoswap = false; }
887             else if (uniswapV2Pair != to && uniswapV2Pair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
888         }
889         return (oktoswap);
890     }
891 }