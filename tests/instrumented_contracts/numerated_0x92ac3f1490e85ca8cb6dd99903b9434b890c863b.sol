1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b)
11         internal
12         pure
13         returns (bool, uint256)
14     {
15         unchecked {
16             uint256 c = a + b;
17             if (c < a) return (false, 0);
18             return (true, c);
19         }
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function trySub(uint256 a, uint256 b)
28         internal
29         pure
30         returns (bool, uint256)
31     {
32         unchecked {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35         }
36     }
37 
38     /**
39      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryMul(uint256 a, uint256 b)
44         internal
45         pure
46         returns (bool, uint256)
47     {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b)
65         internal
66         pure
67         returns (bool, uint256)
68     {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b)
81         internal
82         pure
83         returns (bool, uint256)
84     {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(
251         address indexed previousOwner,
252         address indexed newOwner
253     );
254 
255     /**
256      * @dev Initializes the contract setting the deployer as the initial owner.
257      */
258     constructor() {
259         _transferOwnership(_msgSender());
260     }
261 
262     /**
263      * @dev Throws if called by any account other than the owner.
264      */
265     modifier onlyOwner() {
266         _checkOwner();
267         _;
268     }
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view virtual returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if the sender is not the owner.
279      */
280     function _checkOwner() internal view virtual {
281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
282     }
283 
284     /**
285      * @dev Leaves the contract without owner. It will not be possible to call
286      * `onlyOwner` functions. Can only be called by the current owner.
287      *
288      * NOTE: Renouncing ownership will leave the contract without an owner,
289      * thereby disabling any functionality that is only available to the owner.
290      */
291     function renounceOwnership() public virtual onlyOwner {
292         _transferOwnership(address(0));
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public virtual onlyOwner {
300         require(
301             newOwner != address(0),
302             "Ownable: new owner is the zero address"
303         );
304         _transferOwnership(newOwner);
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Internal function without access restriction.
310      */
311     function _transferOwnership(address newOwner) internal virtual {
312         address oldOwner = _owner;
313         _owner = newOwner;
314         emit OwnershipTransferred(oldOwner, newOwner);
315     }
316 }
317 
318 interface IERC20 {
319     function totalSupply() external view returns (uint256);
320 
321     function balanceOf(address account) external view returns (uint256);
322 
323     function transfer(address recipient, uint256 amount)
324         external
325         returns (bool);
326 
327     function allowance(address owner, address spender)
328         external
329         view
330         returns (uint256);
331 
332     function approve(address spender, uint256 amount) external returns (bool);
333 
334     function transferFrom(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) external returns (bool);
339 
340     event Transfer(address indexed from, address indexed to, uint256 value);
341     event Approval(
342         address indexed owner,
343         address indexed spender,
344         uint256 value
345     );
346 }
347 
348 interface IUniswapV2Factory {
349     function getPair(address tokenA, address tokenB)
350         external
351         view
352         returns (address pair);
353 }
354 
355 interface IUniswapV2Router02 {
356     function addLiquidityETH(
357         address token,
358         uint256 amountTokenDesired,
359         uint256 amountTokenMin,
360         uint256 amountETHMin,
361         address to,
362         uint256 deadline
363     )
364         external
365         payable
366         returns (
367             uint256 amountToken,
368             uint256 amountETH,
369             uint256 liquidity
370         );
371 }
372 
373 contract Presale is Ownable {
374     using SafeMath for uint256;
375 
376     bool public isInit;
377     bool public isDeposit;
378     bool public isRefund;
379     bool public isFinish;
380     bool public burnTokens = true;
381     address public creatorWallet;
382     address public teamWallet;
383     address public weth;
384     uint8 public tokenDecimals = 18;
385     uint256 public ethRaised;
386     uint256 public percentageRaised;
387     uint256 public tokensSold;
388 
389     struct Pool {
390         uint64 startTime;
391         uint64 endTime;
392         uint256 tokenDeposit;
393         uint256 tokensForSale;
394         uint256 tokensForLiquidity;
395         uint8 liquidityPortion;
396         uint256 hardCap;
397         uint256 softCap;
398         uint256 maxBuy;
399         uint256 minBuy;
400     }
401 
402     IERC20 public tokenInstance;
403     IUniswapV2Factory public UniswapV2Factory;
404     IUniswapV2Router02 public UniswapV2Router02;
405     Pool public pool;
406 
407     mapping(address => uint256) public ethContribution;
408 
409     modifier onlyActive() {
410         require(block.timestamp >= pool.startTime, "Sale must be active.");
411         require(block.timestamp <= pool.endTime, "Sale must be active.");
412         _;
413     }
414 
415     modifier onlyInactive() {
416         require(
417             block.timestamp < pool.startTime ||
418                 block.timestamp > pool.endTime ||
419                 ethRaised >= pool.hardCap,
420             "Sale must be inactive."
421         );
422         _;
423     }
424 
425     modifier onlyRefund() {
426         require(
427             isRefund == true ||
428                 (block.timestamp > pool.endTime && ethRaised < pool.softCap),
429             "Refund unavailable."
430         );
431         _;
432     }
433 
434     constructor(
435         IERC20 _tokenInstance,
436         address _uniswapv2Router,
437         address _uniswapv2Factory,
438         address _teamWallet,
439         address _weth
440     ) {
441         require(_uniswapv2Router != address(0), "Invalid router address");
442         require(_uniswapv2Factory != address(0), "Invalid factory address");
443 
444         isInit = false;
445         isDeposit = false;
446         isFinish = false;
447         isRefund = false;
448         ethRaised = 0;
449 
450         teamWallet = _teamWallet;
451         weth = _weth;
452         tokenInstance = _tokenInstance;
453         creatorWallet = address(payable(msg.sender));
454         UniswapV2Router02 = IUniswapV2Router02(_uniswapv2Router);
455         UniswapV2Factory = IUniswapV2Factory(_uniswapv2Factory);
456 
457         require(
458             UniswapV2Factory.getPair(address(tokenInstance), weth) ==
459                 address(0),
460             "IUniswap: Pool exists."
461         );
462 
463         tokenInstance.approve(_uniswapv2Router, tokenInstance.totalSupply());
464     }
465 
466     event Liquified(
467         address indexed _token,
468         address indexed _router,
469         address indexed _pair
470     );
471 
472     event Canceled(
473         address indexed _inititator,
474         address indexed _token,
475         address indexed _presale
476     );
477 
478     event Bought(address indexed _buyer, uint256 _tokenAmount);
479 
480     event Refunded(address indexed _refunder, uint256 _tokenAmount);
481 
482     event Deposited(address indexed _initiator, uint256 _totalDeposit);
483 
484     event Claimed(address indexed _participent, uint256 _tokenAmount);
485 
486     event RefundedRemainder(address indexed _initiator, uint256 _amount);
487 
488     event BurntRemainder(address indexed _initiator, uint256 _amount);
489 
490     event Withdraw(address indexed _creator, uint256 _amount);
491 
492     /*
493      * Reverts ethers sent to this address whenever requirements are not met
494      */
495     receive() external payable {
496         if (
497             block.timestamp >= pool.startTime && block.timestamp <= pool.endTime
498         ) {
499             buyTokens(_msgSender());
500         } else {
501             revert("Presale is closed");
502         }
503     }
504 
505     /*
506     * Initiates the arguments of the sale
507     @dev arguments must be pa   ssed in wei (amount*10**18)
508     */
509     function initSale(
510         uint64 _startTime,
511         uint64 _endTime,
512         uint256 _tokenDeposit,
513         uint256 _tokensForSale,
514         uint256 _tokensForLiquidity,
515         uint8 _liquidityPortion,
516         uint256 _hardCap,
517         uint256 _softCap,
518         uint256 _maxBuy,
519         uint256 _minBuy
520     ) external onlyOwner onlyInactive {
521         require(isInit == false, "Sale no initialized");
522         require(_startTime >= block.timestamp, "Invalid start time.");
523         require(_endTime > block.timestamp, "Invalid end time.");
524         require(_tokenDeposit > 0, "Invalid token deposit.");
525         require(_tokensForSale < _tokenDeposit, "Invalid tokens for sale.");
526         require(
527             _tokensForLiquidity < _tokenDeposit,
528             "Invalid tokens for liquidity."
529         );
530         require(_softCap >= _hardCap / 2, "SC must be >= HC/2.");
531         require(_liquidityPortion >= 50, "Liquidity must be >=50.");
532         require(_liquidityPortion <= 100, "Invalid liquidity.");
533         require(_minBuy < _maxBuy, "Min buy must greater than max.");
534         require(_minBuy > 0, "Min buy must exceed 0.");
535 
536         Pool memory newPool = Pool(
537             _startTime,
538             _endTime,
539             _tokenDeposit,
540             _tokensForSale,
541             _tokensForLiquidity,
542             _liquidityPortion,
543             _hardCap,
544             _softCap,
545             _maxBuy,
546             _minBuy
547         );
548 
549         pool = newPool;
550 
551         isInit = true;
552     }
553 
554     /*
555      * Once called the owner deposits tokens into pool
556      */
557     function deposit() external onlyOwner {
558         require(!isDeposit, "Tokens already deposited.");
559         require(isInit, "Not initialized yet.");
560 
561         uint256 totalDeposit = _getTokenDeposit();
562 
563         isDeposit = true;
564 
565         require(
566             tokenInstance.transferFrom(msg.sender, address(this), totalDeposit),
567             "Deposit failed."
568         );
569 
570         emit Deposited(msg.sender, totalDeposit);
571     }
572 
573     /*
574      * Finish the sale - Create Uniswap v2 pair, add liquidity, take fees, withrdawal funds, burn/refund unused tokens
575      */
576     function finishSale() external onlyOwner onlyInactive {
577         require(ethRaised >= pool.softCap, "Soft Cap is not met.");
578         require(
579             block.timestamp > pool.startTime,
580             "Can not finish before start"
581         );
582         require(!isFinish, "Sale already launched.");
583         require(!isRefund, "Refund process.");
584 
585         percentageRaised = _getPercentageFromValue(ethRaised, pool.hardCap);
586         tokensSold = _getValueFromPercentage(
587             percentageRaised,
588             pool.tokensForSale
589         );
590         uint256 tokensForLiquidity = _getValueFromPercentage(
591             percentageRaised,
592             pool.tokensForLiquidity
593         );
594         isFinish = true;
595 
596         //add liquidity
597         (uint256 amountToken, uint256 amountETH, ) = UniswapV2Router02
598             .addLiquidityETH{value: _getLiquidityEth()}(
599             address(tokenInstance),
600             tokensForLiquidity,
601             tokensForLiquidity,
602             _getLiquidityEth(),
603             owner(),
604             block.timestamp + 600
605         );
606 
607         require(
608             amountToken == tokensForLiquidity &&
609                 amountETH == _getLiquidityEth(),
610             "Providing liquidity failed."
611         );
612 
613         emit Liquified(
614             address(tokenInstance),
615             address(UniswapV2Router02),
616             UniswapV2Factory.getPair(address(tokenInstance), weth)
617         );
618 
619         //withrawal eth
620         uint256 ownerShareEth = _getOwnerEth();
621 
622         if (ownerShareEth > 0) {
623             payable(creatorWallet).transfer(ownerShareEth);
624         }
625 
626         //If HC is not reached, burn or refund the remainder
627         if (ethRaised < pool.hardCap) {
628             uint256 remainder = _getUserTokens(pool.hardCap - ethRaised) +
629                 (pool.tokensForLiquidity - tokensForLiquidity);
630             if (burnTokens == true) {
631                 require(
632                     tokenInstance.transfer(
633                         0x000000000000000000000000000000000000dEaD,
634                         remainder
635                     ),
636                     "Unable to burn."
637                 );
638                 emit BurntRemainder(msg.sender, remainder);
639             } else {
640                 require(
641                     tokenInstance.transfer(creatorWallet, remainder),
642                     "Refund failed."
643                 );
644                 emit RefundedRemainder(msg.sender, remainder);
645             }
646         }
647     }
648 
649     /*
650     * The owner can decide to close the sale if it is still active
651     NOTE: Creator may call this function even if the Hard Cap is reached, to prevent it use:
652      require(ethRaised < pool.hardCap)
653     */
654     function cancelSale() external onlyOwner onlyActive {
655         require(!isFinish, "Sale finished.");
656         pool.endTime = 0;
657         isRefund = true;
658 
659         if (tokenInstance.balanceOf(address(this)) > 0) {
660             uint256 tokenDeposit = _getTokenDeposit();
661             tokenInstance.transfer(msg.sender, tokenDeposit);
662             emit Withdraw(msg.sender, tokenDeposit);
663         }
664         emit Canceled(msg.sender, address(tokenInstance), address(this));
665     }
666 
667     /*
668      * Allows participents to claim the tokens they purchased
669      */
670     function claimTokens() external onlyInactive {
671         require(isFinish, "Sale is still active.");
672         require(!isRefund, "Refund process.");
673 
674         uint256 tokensAmount = _getUserTokens(ethContribution[msg.sender]);
675         ethContribution[msg.sender] = 0;
676         require(
677             tokenInstance.transfer(msg.sender, tokensAmount),
678             "Claim failed."
679         );
680         emit Claimed(msg.sender, tokensAmount);
681     }
682 
683     /*
684      * Refunds the Eth to participents
685      */
686     function refund() external onlyInactive onlyRefund {
687         uint256 refundAmount = ethContribution[msg.sender];
688 
689         require(refundAmount > 0, "No refund amount");
690         require(address(this).balance >= refundAmount, "No amount available");
691 
692         ethContribution[msg.sender] = 0;
693         address payable refunder = payable(msg.sender);
694         refunder.transfer(refundAmount);
695         emit Refunded(refunder, refundAmount);
696     }
697 
698     /*
699      * Withdrawal tokens on refund
700      */
701     function withrawTokens() external onlyOwner onlyInactive onlyRefund {
702         if (tokenInstance.balanceOf(address(this)) > 0) {
703             uint256 tokenDeposit = _getTokenDeposit();
704             require(
705                 tokenInstance.transfer(msg.sender, tokenDeposit),
706                 "Withdraw failed."
707             );
708             emit Withdraw(msg.sender, tokenDeposit);
709         }
710     }
711 
712     /*
713      * If requirements are passed, updates user"s token balance based on their eth contribution
714      */
715     function buyTokens(address _contributor) public payable onlyActive {
716         require(isDeposit, "Tokens not deposited.");
717         require(_contributor != address(0), "Transfer to 0 address.");
718         require(msg.value != 0, "Wei Amount is 0");
719         require(msg.value >= pool.minBuy, "Min buy is not met.");
720         require(
721             msg.value + ethContribution[_contributor] <= pool.maxBuy,
722             "Max buy limit exceeded."
723         );
724         require(ethRaised + msg.value <= pool.hardCap, "HC Reached.");
725 
726         ethRaised += msg.value;
727         ethContribution[msg.sender] += msg.value;
728     }
729 
730     /*
731      * Internal functions, called when calculating balances
732      */
733     function _getUserTokens(uint256 _amount) internal view returns (uint256) {
734         return _amount.mul(tokensSold).div(ethRaised);
735     }
736 
737     function _getLiquidityEth() internal view returns (uint256) {
738         return _getValueFromPercentage(pool.liquidityPortion, ethRaised);
739     }
740 
741     function _getOwnerEth() internal view returns (uint256) {
742         uint256 liquidityEthFee = _getLiquidityEth();
743         return ethRaised - liquidityEthFee;
744     }
745 
746     function _getTokenDeposit() internal view returns (uint256) {
747         return pool.tokenDeposit;
748     }
749 
750     function _getPercentageFromValue(uint256 currentValue, uint256 maxValue)
751         private
752         pure
753         returns (uint256)
754     {
755         require(currentValue <= maxValue, "Number too high");
756 
757         return currentValue.mul(100).div(maxValue);
758     }
759 
760     function _getValueFromPercentage(
761         uint256 currentPercentage,
762         uint256 maxValue
763     ) private pure returns (uint256) {
764         require(currentPercentage <= 100, "Number too high");
765 
766         return maxValue.mul(currentPercentage).div(100);
767     }
768 }