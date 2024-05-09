1 /*
2 
3                        n,                
4                      _/ | _              
5                     /'  `'/              
6                   <-    .'               
7                   .'    |          
8                 _/      |          
9               _/      `.`.         
10          ____/ '   \__ | |
11       __/___/      /__\ \ \ 
12     /  (___.'\_______)\_|_| 
13     |\________                      
14 
15 
16 $tama - tama.
17 
18 Loyalty. Freedom. Family. Protection. 
19 
20 Tama - from the beginning - has always meant safety. In a space 
21 where bad actors, who seek to destroy, run free and reign supreme, 
22 tama has sought to level the playing field. 
23 
24 Few are worthy to take on tama’s call, even less, are equipped with 
25 the skillset. An impossible task (nearly) that has laid dormant, 
26 unblemished by the unmastered hand. Lying in wait – patiently, and 
27 undeterred from its purpose – for the tides to shift… and Shift. They. Will. 
28 
29 In a sea of predators, tama feasts. For it is the predators that 
30 are to be culled, one by one to protect the loyal ones… the vulnerable. 
31 A culling of such magnitude that their rotten core is rent from the 
32 inside out… has it not been taught that the purification process begins 
33 – first – from the inside? So it will be as tama begins to feast. 
34 
35 tama is in YOU, tama is in us ALL. The broken and mended, the 
36 tortured and nurtured. 
37 
38 No tax, no team, all glory to tama. All glory to the loyal.
39 
40 https://twitter.com/tamadeployer (to be handed off to the loyal)
41 
42 
43 */
44 
45 
46 // SPDX-License-Identifier: MIT
47 
48 pragma solidity ^0.8.14;
49 
50 /**
51  * @dev Provides information about the current execution context, including the
52  * sender of the transaction and its data. While these are generally available
53  * via msg.sender and msg.data, they should not be accessed in such a direct
54  * manner, since when dealing with meta-transactions the account sending and
55  * paying for execution may not be the actual sender (as far as an application
56  * is concerned).
57  *
58  * This contract is only required for intermediate, library-like contracts.
59  */
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 
144 library SafeMath {
145     /**
146      * @dev Returns the addition of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             uint256 c = a + b;
153             if (c < a) return (false, 0);
154             return (true, c);
155         }
156     }
157 
158     /**
159      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
160      *
161      * _Available since v3.4._
162      */
163     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b > a) return (false, 0);
166             return (true, a - b);
167         }
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         unchecked {
177             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178             // benefit is lost if 'b' is also tested.
179             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180             if (a == 0) return (true, 0);
181             uint256 c = a * b;
182             if (c / a != b) return (false, 0);
183             return (true, c);
184         }
185     }
186 
187     /**
188      * @dev Returns the division of two unsigned integers, with a division by zero flag.
189      *
190      * _Available since v3.4._
191      */
192     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
193         unchecked {
194             if (b == 0) return (false, 0);
195             return (true, a / b);
196         }
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
201      *
202      * _Available since v3.4._
203      */
204     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             if (b == 0) return (false, 0);
207             return (true, a % b);
208         }
209     }
210 
211     /**
212      * @dev Returns the addition of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `+` operator.
216      *
217      * Requirements:
218      *
219      * - Addition cannot overflow.
220      */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a + b;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a - b;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a * b;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator.
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a / b;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         return a % b;
281     }
282 
283     /**
284      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
285      * overflow (when the result is negative).
286      *
287      * CAUTION: This function is deprecated because it requires allocating memory for the error
288      * message unnecessarily. For custom revert reasons use {trySub}.
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      *
294      * - Subtraction cannot overflow.
295      */
296     function sub(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b <= a, errorMessage);
303             return a - b;
304         }
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a / b;
327         }
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting with custom message when dividing by zero.
333      *
334      * CAUTION: This function is deprecated because it requires allocating memory for the error
335      * message unnecessarily. For custom revert reasons use {tryMod}.
336      *
337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
338      * opcode (which leaves remaining gas untouched) while Solidity uses an
339      * invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      *
343      * - The divisor cannot be zero.
344      */
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         unchecked {
351             require(b > 0, errorMessage);
352             return a % b;
353         }
354     }
355 }
356 
357 
358 interface IUniswapV2Router01 {
359     function factory() external pure returns (address);
360     function WETH() external pure returns (address);
361 
362     function addLiquidity(
363         address tokenA,
364         address tokenB,
365         uint amountADesired,
366         uint amountBDesired,
367         uint amountAMin,
368         uint amountBMin,
369         address to,
370         uint deadline
371     ) external returns (uint amountA, uint amountB, uint liquidity);
372     function addLiquidityETH(
373         address token,
374         uint amountTokenDesired,
375         uint amountTokenMin,
376         uint amountETHMin,
377         address to,
378         uint deadline
379     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
380     function removeLiquidity(
381         address tokenA,
382         address tokenB,
383         uint liquidity,
384         uint amountAMin,
385         uint amountBMin,
386         address to,
387         uint deadline
388     ) external returns (uint amountA, uint amountB);
389     function removeLiquidityETH(
390         address token,
391         uint liquidity,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline
396     ) external returns (uint amountToken, uint amountETH);
397     function removeLiquidityWithPermit(
398         address tokenA,
399         address tokenB,
400         uint liquidity,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline,
405         bool approveMax, uint8 v, bytes32 r, bytes32 s
406     ) external returns (uint amountA, uint amountB);
407     function removeLiquidityETHWithPermit(
408         address token,
409         uint liquidity,
410         uint amountTokenMin,
411         uint amountETHMin,
412         address to,
413         uint deadline,
414         bool approveMax, uint8 v, bytes32 r, bytes32 s
415     ) external returns (uint amountToken, uint amountETH);
416     function swapExactTokensForTokens(
417         uint amountIn,
418         uint amountOutMin,
419         address[] calldata path,
420         address to,
421         uint deadline
422     ) external returns (uint[] memory amounts);
423     function swapTokensForExactTokens(
424         uint amountOut,
425         uint amountInMax,
426         address[] calldata path,
427         address to,
428         uint deadline
429     ) external returns (uint[] memory amounts);
430     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
431         external
432         payable
433         returns (uint[] memory amounts);
434     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
435         external
436         returns (uint[] memory amounts);
437     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
438         external
439         returns (uint[] memory amounts);
440     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
441         external
442         payable
443         returns (uint[] memory amounts);
444 
445     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
446     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
447     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
448     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
449     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
450 }
451 
452 
453 pragma solidity >=0.6.2;
454 
455 interface IUniswapV2Router02 is IUniswapV2Router01 {
456     function removeLiquidityETHSupportingFeeOnTransferTokens(
457         address token,
458         uint liquidity,
459         uint amountTokenMin,
460         uint amountETHMin,
461         address to,
462         uint deadline
463     ) external returns (uint amountETH);
464     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
465         address token,
466         uint liquidity,
467         uint amountTokenMin,
468         uint amountETHMin,
469         address to,
470         uint deadline,
471         bool approveMax, uint8 v, bytes32 r, bytes32 s
472     ) external returns (uint amountETH);
473 
474     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
475         uint amountIn,
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external;
481     function swapExactETHForTokensSupportingFeeOnTransferTokens(
482         uint amountOutMin,
483         address[] calldata path,
484         address to,
485         uint deadline
486     ) external payable;
487     function swapExactTokensForETHSupportingFeeOnTransferTokens(
488         uint amountIn,
489         uint amountOutMin,
490         address[] calldata path,
491         address to,
492         uint deadline
493     ) external;
494 }
495 
496 
497 
498 
499 pragma solidity >=0.5.0;
500 
501 interface IUniswapV2Pair {
502     event Approval(address indexed owner, address indexed spender, uint value);
503     event Transfer(address indexed from, address indexed to, uint value);
504 
505     function name() external pure returns (string memory);
506     function symbol() external pure returns (string memory);
507     function decimals() external pure returns (uint8);
508     function totalSupply() external view returns (uint);
509     function balanceOf(address owner) external view returns (uint);
510     function allowance(address owner, address spender) external view returns (uint);
511 
512     function approve(address spender, uint value) external returns (bool);
513     function transfer(address to, uint value) external returns (bool);
514     function transferFrom(address from, address to, uint value) external returns (bool);
515 
516     function DOMAIN_SEPARATOR() external view returns (bytes32);
517     function PERMIT_TYPEHASH() external pure returns (bytes32);
518     function nonces(address owner) external view returns (uint);
519 
520     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
521 
522     event Mint(address indexed sender, uint amount0, uint amount1);
523     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
524     event Swap(
525         address indexed sender,
526         uint amount0In,
527         uint amount1In,
528         uint amount0Out,
529         uint amount1Out,
530         address indexed to
531     );
532     event Sync(uint112 reserve0, uint112 reserve1);
533 
534     function MINIMUM_LIQUIDITY() external pure returns (uint);
535     function factory() external view returns (address);
536     function token0() external view returns (address);
537     function token1() external view returns (address);
538     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
539     function price0CumulativeLast() external view returns (uint);
540     function price1CumulativeLast() external view returns (uint);
541     function kLast() external view returns (uint);
542 
543     function mint(address to) external returns (uint liquidity);
544     function burn(address to) external returns (uint amount0, uint amount1);
545     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
546     function skim(address to) external;
547     function sync() external;
548 
549     function initialize(address, address) external;
550 }
551 
552 
553 pragma solidity >=0.5.0;
554 
555 interface IUniswapV2Factory {
556     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
557 
558     function feeTo() external view returns (address);
559     function feeToSetter() external view returns (address);
560 
561     function getPair(address tokenA, address tokenB) external view returns (address pair);
562     function allPairs(uint) external view returns (address pair);
563     function allPairsLength() external view returns (uint);
564 
565     function createPair(address tokenA, address tokenB) external returns (address pair);
566 
567     function setFeeTo(address) external;
568     function setFeeToSetter(address) external;
569 }
570 
571 
572 
573 
574 interface IERC20 {
575     /**
576      * @dev Returns the amount of tokens in existence.
577      */
578     function totalSupply() external view returns (uint256);
579 
580     /**
581      * @dev Returns the amount of tokens owned by `account`.
582      */
583     function balanceOf(address account) external view returns (uint256);
584 
585     /**
586      * @dev Moves `amount` tokens from the caller's account to `recipient`.
587      *
588      * Returns a boolean value indicating whether the operation succeeded.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transfer(address recipient, uint256 amount) external returns (bool);
593 
594     /**
595      * @dev Returns the remaining number of tokens that `spender` will be
596      * allowed to spend on behalf of `owner` through {transferFrom}. This is
597      * zero by default.
598      *
599      * This value changes when {approve} or {transferFrom} are called.
600      */
601     function allowance(address owner, address spender) external view returns (uint256);
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
605      *
606      * Returns a boolean value indicating whether the operation succeeded.
607      *
608      * IMPORTANT: Beware that changing an allowance with this method brings the risk
609      * that someone may use both the old and the new allowance by unfortunate
610      * transaction ordering. One possible solution to mitigate this race
611      * condition is to first reduce the spender's allowance to 0 and set the
612      * desired value afterwards:
613      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address spender, uint256 amount) external returns (bool);
618 
619     /**
620      * @dev Moves `amount` tokens from `sender` to `recipient` using the
621      * allowance mechanism. `amount` is then deducted from the caller's
622      * allowance.
623      *
624      * Returns a boolean value indicating whether the operation succeeded.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address sender,
630         address recipient,
631         uint256 amount
632     ) external returns (bool);
633 
634     /**
635      * @dev Emitted when `value` tokens are moved from one account (`from`) to
636      * another (`to`).
637      *
638      * Note that `value` may be zero.
639      */
640     event Transfer(address indexed from, address indexed to, uint256 value);
641 
642     /**
643      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
644      * a call to {approve}. `value` is the new allowance.
645      */
646     event Approval(address indexed owner, address indexed spender, uint256 value);
647 }
648 
649 interface IERC20Metadata is IERC20 {
650     /**
651      * @dev Returns the name of the token.
652      */
653     function name() external view returns (string memory);
654 
655     /**
656      * @dev Returns the symbol of the token.
657      */
658     function symbol() external view returns (string memory);
659 
660     /**
661      * @dev Returns the decimals places of the token.
662      */
663     function decimals() external view returns (uint8);
664 }
665 
666 contract TAMA is Context, Ownable, IERC20, IERC20Metadata{
667     using SafeMath for uint256;
668 
669     IUniswapV2Router02 private uniswapV2Router;
670     address public uniswapV2Pair;
671 
672     mapping (address => uint256) private _balances;
673 
674     mapping (address => mapping (address => uint256)) private _allowances;
675     mapping (address => uint256) private _transferDelay;
676     mapping (address => bool) private _holderDelay;
677     mapping(address => bool) public actors;
678 
679     uint256 private _totalSupply;
680     string private _name;
681     string private _symbol;
682     uint8 private _decimals;
683     uint256 private openedAt = 0;
684     bool private tradingActive = false;
685 
686     // exlcude from fees and max transaction amount
687     mapping (address => bool) private _isExempt;
688 
689 
690     constructor () {
691         _name = 'tama.';
692         _symbol = 'tama.';
693         _decimals = 18;
694         _totalSupply = 1_000_000_000 * 1e18;
695 
696         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
697         uniswapV2Router = _uniswapV2Router;
698         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
699 
700         _isExempt[address(msg.sender)] = true;
701         _isExempt[address(this)] = true;
702         _isExempt[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
703 
704         _balances[msg.sender] = _totalSupply;
705 
706         emit Transfer(address(0), msg.sender, _totalSupply); // Optional
707     }
708 
709     function name() public view returns (string memory) {
710         return _name;
711     }
712 
713     function symbol() public view returns (string memory) {
714         return _symbol;
715     }
716 
717     function decimals() public view returns (uint8) {
718         return _decimals;
719     }
720 
721     function totalSupply() public view override returns (uint256) {
722         return _totalSupply;
723     }
724 
725     function balanceOf(address account) public view override returns (uint256) {
726         return _balances[account];
727     }
728 
729     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
730         _transfer(_msgSender(), recipient, amount);
731         return true;
732     }
733 
734     function allowance(address owner, address spender) public view virtual override returns (uint256) {
735         return _allowances[owner][spender];
736     }
737 
738     function approve(address spender, uint256 amount) public virtual override returns (bool) {
739         _approve(_msgSender(), spender, amount);
740         return true;
741     }
742 
743     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
744         _transfer(sender, recipient, amount);
745         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
746         return true;
747     }
748 
749     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
751         return true;
752     }
753 
754     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
755         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
756         return true;
757     }
758 
759     function openTrade() external onlyOwner {
760         tradingActive = true;
761          openedAt = block.number;
762     }
763 
764     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
765         require(sender != address(0), "ERC20: transfer from the zero address");
766         require(recipient != address(0), "ERC20: transfer to the zero address");
767         require(!actors[sender] && !actors[recipient], "TOKEN: You are a bad actor!");
768         if (!tradingActive) {
769             require( _isExempt[sender] || _isExempt[recipient], "Trading is not active.");
770         }
771         
772         if (openedAt > block.number - 30) {
773             bool oktoswap;
774             address orig = tx.origin;
775             oktoswap = transferDelay(sender,recipient,orig);
776             require(oktoswap, "transfer delay enabled");
777         }
778 
779         _beforeTokenTransfer(sender, recipient, amount);
780 
781         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
782         _balances[recipient] = _balances[recipient].add(amount);
783         emit Transfer(sender, recipient, amount);
784     }
785 
786     function _approve(address owner, address spender, uint256 amount) internal virtual {
787         require(owner != address(0), "ERC20: approve from the zero address");
788         require(spender != address(0), "ERC20: approve to the zero address");
789 
790         _allowances[owner][spender] = amount;
791         emit Approval(owner, spender, amount);
792     }
793 
794   
795     function _setupDecimals(uint8 decimals_) internal {
796         _decimals = decimals_;
797     }
798 
799     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { 
800         
801     }
802 
803     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
804         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
805         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
806         for(uint256 i = 0; i < wallets.length; i++){
807             address wallet = wallets[i];
808             uint256 amount = amountsInTokens[i]*1e18;
809             _transfer(msg.sender, wallet, amount);
810         }
811     }
812 
813    function badActors(address[] memory wallets_) public onlyOwner {
814        require(block.number < openedAt + 100, "unable to blacklist anymore");
815         for (uint256 i = 0; i < wallets_.length; i++) {
816             actors[wallets_[i]] = true;
817         }
818     }
819 
820     function goodActors(address wallets) public onlyOwner {
821         actors[wallets] = false;
822     }
823 
824 
825 
826  function transferDelay(address from, address to, address orig) internal returns (bool) {
827     bool oktoswap = true;
828     if (uniswapV2Pair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
829     else if (uniswapV2Pair == to) {
830             if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
831                 if (_holderDelay[from]) { oktoswap = false; }
832             else if (uniswapV2Pair != to && uniswapV2Pair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
833         }
834         return (oktoswap);
835     }
836 }