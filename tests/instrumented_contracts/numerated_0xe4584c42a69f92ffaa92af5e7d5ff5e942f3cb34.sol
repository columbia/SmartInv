1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Contract module that helps prevent reentrant calls to a function.
208  *
209  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
210  * available, which can be applied to functions to make sure there are no nested
211  * (reentrant) calls to them.
212  *
213  * Note that because there is a single `nonReentrant` guard, functions marked as
214  * `nonReentrant` may not call one another. This can be worked around by making
215  * those functions `private`, and then adding `external` `nonReentrant` entry
216  * points to them.
217  *
218  * TIP: If you would like to learn more about reentrancy and alternative ways
219  * to protect against it, check out our blog post
220  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
221  */
222 abstract contract ReentrancyGuard {
223     // Booleans are more expensive than uint256 or any type that takes up a full
224     // word because each write operation emits an extra SLOAD to first read the
225     // slot's contents, replace the bits taken up by the boolean, and then write
226     // back. This is the compiler's defense against contract upgrades and
227     // pointer aliasing, and it cannot be disabled.
228 
229     // The values being non-zero value makes deployment a bit more expensive,
230     // but in exchange the refund on every call to nonReentrant will be lower in
231     // amount. Since refunds are capped to a percentage of the total
232     // transaction's gas, it is best to keep them low in cases like this one, to
233     // increase the likelihood of the full refund coming into effect.
234     uint256 private constant _NOT_ENTERED = 1;
235     uint256 private constant _ENTERED = 2;
236 
237     uint256 private _status;
238 
239     constructor() {
240         _status = _NOT_ENTERED;
241     }
242 
243     /**
244      * @dev Prevents a contract from calling itself, directly or indirectly.
245      * Calling a `nonReentrant` function from another `nonReentrant`
246      * function is not supported. It is possible to prevent this from happening
247      * by making the `nonReentrant` function external, and making it call a
248      * `private` function that does the actual work.
249      */
250     modifier nonReentrant() {
251         _nonReentrantBefore();
252         _;
253         _nonReentrantAfter();
254     }
255 
256     function _nonReentrantBefore() private {
257         // On the first call to nonReentrant, _status will be _NOT_ENTERED
258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
259 
260         // Any calls to nonReentrant after this point will fail
261         _status = _ENTERED;
262     }
263 
264     function _nonReentrantAfter() private {
265         // By storing the original value once again, a refund is triggered (see
266         // https://eips.ethereum.org/EIPS/eip-2200)
267         _status = _NOT_ENTERED;
268     }
269 }
270 
271 // File: LinqStaQing.sol
272 
273 
274 //If you are here to forQ the code for this Qontract, good lucQ figuring out how to keep track of your MilQ
275 
276 //With Love, LinQ & Aevum DeFi - Creating a New Paradigm in DeFi.
277 
278 pragma solidity ^0.8.0;
279 
280 
281 
282 interface IUniswapV2Router01 {
283     function factory() external pure returns (address);
284     function WETH() external pure returns (address);
285 
286     function addLiquidity(
287         address tokenA,
288         address tokenB,
289         uint amountADesired,
290         uint amountBDesired,
291         uint amountAMin,
292         uint amountBMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountA, uint amountB, uint liquidity);
296     function addLiquidityETH(
297         address token,
298         uint amountTokenDesired,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline
303     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
304     function removeLiquidity(
305         address tokenA,
306         address tokenB,
307         uint liquidity,
308         uint amountAMin,
309         uint amountBMin,
310         address to,
311         uint deadline
312     ) external returns (uint amountA, uint amountB);
313     function removeLiquidityETH(
314         address token,
315         uint liquidity,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline
320     ) external returns (uint amountToken, uint amountETH);
321     function removeLiquidityWithPermit(
322         address tokenA,
323         address tokenB,
324         uint liquidity,
325         uint amountAMin,
326         uint amountBMin,
327         address to,
328         uint deadline,
329         bool approveMax, uint8 v, bytes32 r, bytes32 s
330     ) external returns (uint amountA, uint amountB);
331     function removeLiquidityETHWithPermit(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline,
338         bool approveMax, uint8 v, bytes32 r, bytes32 s
339     ) external returns (uint amountToken, uint amountETH);
340     function swapExactTokensForTokens(
341         uint amountIn,
342         uint amountOutMin,
343         address[] calldata path,
344         address to,
345         uint deadline
346     ) external returns (uint[] memory amounts);
347     function swapTokensForExactTokens(
348         uint amountOut,
349         uint amountInMax,
350         address[] calldata path,
351         address to,
352         uint deadline
353     ) external returns (uint[] memory amounts);
354     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
355         external
356         payable
357         returns (uint[] memory amounts);
358     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
359         external
360         returns (uint[] memory amounts);
361     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
362         external
363         returns (uint[] memory amounts);
364     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
365         external
366         payable
367         returns (uint[] memory amounts);
368 
369     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
370     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
371     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
372     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
373     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
374 }
375 interface IUniswapV2Router02 is IUniswapV2Router01 {
376     function removeLiquidityETHSupportingFeeOnTransferTokens(
377         address token,
378         uint liquidity,
379         uint amountTokenMin,
380         uint amountETHMin,
381         address to,
382         uint deadline
383     ) external returns (uint amountETH);
384     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
385         address token,
386         uint liquidity,
387         uint amountTokenMin,
388         uint amountETHMin,
389         address to,
390         uint deadline,
391         bool approveMax, uint8 v, bytes32 r, bytes32 s
392     ) external returns (uint amountETH);
393 
394     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
395         uint amountIn,
396         uint amountOutMin,
397         address[] calldata path,
398         address to,
399         uint deadline
400     ) external;
401     function swapExactETHForTokensSupportingFeeOnTransferTokens(
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external payable;
407     function swapExactTokensForETHSupportingFeeOnTransferTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external;
414 }
415 
416 interface iLinq{
417     function claim() external;
418 }
419 
420 contract MilQFarm is Ownable, ReentrancyGuard {
421 
422     IERC20 private linQ;
423     IERC20 private milQ;
424     IERC20 private glinQ;
425     iLinq public ILINQ;
426     IUniswapV2Router02 private uniswapRouter;
427 
428     constructor(address _linqAddress, address _milQAddress, address _glinQAddress, address _oddysParlour, address _uniswapRouterAddress) {    
429         linQ = IERC20(_linqAddress);
430         ILINQ = iLinq(_linqAddress);
431         milQ = IERC20(_milQAddress);
432         glinQ = IERC20(_glinQAddress);
433         oddysParlour = _oddysParlour;
434         uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
435     }   
436    
437     bool private staQingPaused = true;
438 
439     address public oddysParlour;
440 
441     address private swapLinq = 0x3e34eabF5858a126cb583107E643080cEE20cA64;
442    
443     uint256 public daisys = 0; 
444 
445     uint256 public bessies = 0;
446 
447     uint256 public linQers = 0;
448 
449     uint256 public milQers = 0;
450 
451     uint256 public vitaliksMilkShipped = 0;
452 
453     uint256 public vitaliksMilkQompounded = 0;
454 
455     uint256 private daisysToOddysParlour = 15;
456 
457     uint256 private bessiesToOddysParlour = 15;
458 
459     uint256 public daisysMilkProduced = 0;
460 
461     uint256 public bessiesMilkProduced = 0;
462 
463     uint256 public daisysRentalTime;
464 
465     uint256 public bessiesRentalTime;
466 
467     uint256 public roundUpDaisysTime;
468 
469     uint256 public roundUpBessiesTime;
470 
471     uint256 public totalVitaliksMilkShipments = 0;
472 
473     uint256 public MilqShipments = 0;
474 
475     uint256 private minLinQ = 10000000000000000000;
476 
477     uint256 private minMilQ = 1000000000000000000;
478 
479     uint256 public totalMilQClaimed = 0;
480 
481     uint256 private highClaimThreshold = 5000000000000000000;
482 
483     event highClaim(address User, uint256 Amount);
484 
485     function sethighClaimThreshold(uint256 weiAmount) public onlyOwner {
486         highClaimThreshold = weiAmount;
487     }
488 
489     uint256 private lowBalanceThreshold = 10000000000000000000;
490 
491     event lowBalance(uint256 time, uint256 balance);
492 
493     function setLowBalanceThreshold(uint256 weiAmount) public onlyOwner {
494         lowBalanceThreshold = weiAmount;
495     }
496 
497     event rewardChange(uint256 index ,uint256 newBessies, uint256 newDaisys);
498 
499     event Qompound(address user, uint256 _ethAmount, uint256 boughtAmount);
500 
501     event newStaQe(address user, uint256 linq, uint256 milq);
502 
503     struct LinQerParlour {
504         uint256 daisys;
505         uint256 rentedDaisysSince;
506         uint256 rentedDaisysTill;
507         uint256 vitaliksMilkShipped;
508         uint256 lastShippedVitaliksMilk;
509         uint256 vitaliksMilkClaimable;
510         uint256 QompoundedMilk;
511         uint256 daisysOwnedSince;
512         uint256 daisysOwnedTill;
513         bool hasDaisys;
514         bool ownsDaisys;
515         bool owedMilk;
516         uint256 shipmentsRecieved;
517     }
518 
519     struct LpClaim {
520         uint256 lastClaimed;
521         uint256 totalClaimed;
522     }
523 
524     struct MilQerParlour {
525         uint256 bessies;
526         uint256 rentedBessiesSince;
527         uint256 rentedBessiesTill;
528         uint256 milQClaimed;
529         uint256 vitaliksMilkShipped;
530         uint256 lastShippedVitaliksMilk;
531         uint256 vitaliksMilkClaimable;
532         uint256 bessiesOwnedSince;
533         uint256 bessiesOwnedTill;
534         bool hasBessies;
535         bool ownsBessies;
536         bool owedMilk;
537         uint256 shipmentsRecieved;
538     }
539 
540     struct MilQShipment {
541         uint256 blockTimestamp;
542         uint256 MilQShipped;
543         uint256 totallinQStaked;
544         uint256 rewardPerlinQ;
545     }
546 
547     struct VitaliksMilkShipment {
548         uint256 timestamp;
549         uint256 daisysOutput;
550         uint256 bessiesOutput;
551     }
552 
553     mapping(address => LpClaim) public LpClaims;
554     mapping(address => LinQerParlour) public LinQerParlours;
555     mapping(address => MilQerParlour) public MilQerParlours;
556     mapping(uint256 => MilQShipment) public MilQShipments;
557     mapping(uint256 => VitaliksMilkShipment) public VitaliksMilkShipments;
558 
559     function rushOddyFee(uint256 _daisysToOddysParlour, uint256 _bessiesToOddysParlour) public onlyOwner{
560         require(_daisysToOddysParlour + _bessiesToOddysParlour <= 60);        
561         daisysToOddysParlour = _daisysToOddysParlour;
562         bessiesToOddysParlour = _bessiesToOddysParlour;
563     }
564 
565     function zeroFees() public onlyOwner {
566         daisysToOddysParlour = 0;
567         bessiesToOddysParlour = 0;
568     }
569 
570     function setOddysParlour(address _oddysParlour) public onlyOwner {
571         oddysParlour = _oddysParlour;
572     }
573 
574     function setGlinQAddress(IERC20 _glinQ) public onlyOwner {
575         glinQ = _glinQ;
576     }   
577 
578     function prepShipment(uint256 _daisysOutput, uint256 _bessiesOutput) public onlyOwner {
579         totalVitaliksMilkShipments ++;
580         uint256 index = totalVitaliksMilkShipments;
581         VitaliksMilkShipments[index] = VitaliksMilkShipment(block.timestamp, _daisysOutput, _bessiesOutput);
582         emit rewardChange(index, _daisysOutput, _bessiesOutput);
583     }
584 
585     function getprepShipment(uint256 index) public view returns (uint256, uint256, uint256) {
586         require(index < totalVitaliksMilkShipments);
587         VitaliksMilkShipment memory shipment = VitaliksMilkShipments[index];
588         return (shipment.timestamp, shipment.daisysOutput, shipment.bessiesOutput);
589     }
590 
591     function pauseStaQing(bool _state) public onlyOwner {
592         staQingPaused = _state;
593     }
594 
595     function removeVitaliksMilk(uint256 amount) external onlyOwner {
596         require(address(this).balance >= amount);
597         payable(oddysParlour).transfer(amount);
598     }
599 
600     function withdrawERC20(address _ERC20, uint256 _Amt) external onlyOwner {
601         IERC20(_ERC20).transfer(msg.sender, _Amt);
602     }
603 
604     function changeDaisysRentalTime(uint256 _daisysRentalTime) external onlyOwner {
605         daisysRentalTime = _daisysRentalTime;
606     }
607 
608     function changeBessiesRentalTime(uint256 _bessiesRentalTime) external onlyOwner {
609         bessiesRentalTime = _bessiesRentalTime;
610     }
611 
612     function changeRoundUpDaisysTime(uint256 _roundUpDaisysTime) external onlyOwner {
613         roundUpDaisysTime = _roundUpDaisysTime;
614     }
615 
616     function changeRoundUpBessiesTime(uint256 _roundUpBessiesTime) external onlyOwner {
617         roundUpBessiesTime = _roundUpBessiesTime;
618     }
619 
620     function changeMinLinQ(uint256 _minLinQ) external onlyOwner {
621         minLinQ = _minLinQ;
622     }
623 
624     function changeMinMilQ(uint256 _minMilQ) external onlyOwner {
625         minMilQ = _minMilQ;
626     }
627 
628     function staQe(uint256 _amountLinQ, uint256 _amountMilQ, uint256 _token) external {
629         require(!staQingPaused);
630         require(_token == 0 || _token == 1);
631 
632         if (LinQerParlours[msg.sender].hasDaisys == true || MilQerParlours[msg.sender].hasBessies == true ) {
633             howMuchMilkV3();
634         }
635 
636         if (_token == 0) {
637             require(_amountLinQ >= minLinQ);
638             
639             if (LinQerParlours[msg.sender].hasDaisys == true) {
640                 uint256 milQToClaim = checkEstMilQRewards(msg.sender);
641                 
642                 if (milQToClaim > 0) {
643                     shipLinQersMilQ();
644                 }
645                 
646                 getMoreDaisys(_amountLinQ);
647             }        
648 
649             if (LinQerParlours[msg.sender].hasDaisys == false){
650                 firstStaQeLinQ(_amountLinQ);
651             }      
652         }
653 
654         if (_token == 1) { 
655             require(_amountMilQ >= minMilQ);
656             if (MilQerParlours[msg.sender].hasBessies == true){
657                 getMoreBessies(_amountMilQ);
658             } 
659 
660             if (MilQerParlours[msg.sender].hasBessies == false){
661                 firstStaQeMilQ(_amountMilQ);
662             }
663         }
664         emit newStaQe(msg.sender,_amountLinQ, _amountMilQ);
665     }
666 
667     function getMoreDaisys(uint256 amountLinQ) internal {
668         
669         linQ.approve(address(this), amountLinQ);
670         linQ.transferFrom(msg.sender, address(this), amountLinQ);
671         
672         if (LinQerParlours[msg.sender].ownsDaisys == true) {
673             glinQ.transfer(msg.sender, amountLinQ);
674         } 
675 
676         LinQerParlours[msg.sender].daisys += amountLinQ;
677         daisys += amountLinQ; 
678     }
679 
680     function getMoreBessies(uint256 amountMilQ) internal {
681         milQ.approve(address(this), amountMilQ);
682         milQ.transferFrom(msg.sender, address(this), amountMilQ);
683         MilQerParlours[msg.sender].bessies += amountMilQ;
684         bessies += amountMilQ;    
685     }
686    
687     function firstStaQeLinQ(uint256 amountLinQ) internal {
688         linQ.approve(address(this), amountLinQ);
689         linQ.transferFrom(msg.sender, address(this), amountLinQ);
690         LinQerParlours[msg.sender].daisys += amountLinQ;
691         LinQerParlours[msg.sender].rentedDaisysSince = block.timestamp;
692         LinQerParlours[msg.sender].rentedDaisysTill = block.timestamp + daisysRentalTime; 
693         LinQerParlours[msg.sender].daisysOwnedSince = 0;
694         LinQerParlours[msg.sender].daisysOwnedTill = 32503680000;
695         LinQerParlours[msg.sender].hasDaisys = true;
696         LinQerParlours[msg.sender].ownsDaisys = false;
697         LinQerParlours[msg.sender].vitaliksMilkShipped = 0;
698         LinQerParlours[msg.sender].QompoundedMilk = 0;
699         LinQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
700         LinQerParlours[msg.sender].shipmentsRecieved = totalVitaliksMilkShipments;
701         LinQerParlours[msg.sender].vitaliksMilkClaimable = 0;
702         LinQerParlours[msg.sender].owedMilk = true;
703         LpClaims[msg.sender].lastClaimed = totalMilQClaimed;
704         LpClaims[msg.sender].totalClaimed = 0;
705         daisys += amountLinQ;
706         linQers ++;
707     }
708 
709     function firstStaQeMilQ(uint256 amountMilQ) internal {
710         milQ.approve(address(this), amountMilQ);
711         milQ.transferFrom(msg.sender, address(this), amountMilQ);
712         MilQerParlours[msg.sender].bessies += amountMilQ;
713         MilQerParlours[msg.sender].rentedBessiesSince = block.timestamp;
714         MilQerParlours[msg.sender].rentedBessiesTill = block.timestamp + bessiesRentalTime;
715         MilQerParlours[msg.sender].hasBessies = true;
716         MilQerParlours[msg.sender].bessiesOwnedSince = 0;
717         MilQerParlours[msg.sender].bessiesOwnedTill = 32503680000;
718         MilQerParlours[msg.sender].ownsBessies = false;
719         MilQerParlours[msg.sender].vitaliksMilkShipped = 0;
720         MilQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
721         MilQerParlours[msg.sender].shipmentsRecieved = totalVitaliksMilkShipments;
722         MilQerParlours[msg.sender].milQClaimed = 0;
723         MilQerParlours[msg.sender].vitaliksMilkClaimable = 0;
724         MilQerParlours[msg.sender].owedMilk = true;
725         bessies += amountMilQ;
726         milQers ++;
727     }
728 
729     function ownCows(uint256 _cow) external {
730         require(!staQingPaused);
731         require( _cow == 0 || _cow == 1);
732 
733         if (_cow == 0) {
734             require(LinQerParlours[msg.sender].ownsDaisys == false);
735             require(LinQerParlours[msg.sender].hasDaisys == true);
736             require(LinQerParlours[msg.sender].rentedDaisysTill < block.timestamp);
737             require(glinQ.transfer(msg.sender, LinQerParlours[msg.sender].daisys));
738             LinQerParlours[msg.sender].ownsDaisys = true;
739             LinQerParlours[msg.sender].daisysOwnedSince = LinQerParlours[msg.sender].rentedDaisysTill;
740             LinQerParlours[msg.sender].owedMilk = true;
741         }    
742 
743         if (_cow == 1) {
744             require(MilQerParlours[msg.sender].ownsBessies == false);
745             require(MilQerParlours[msg.sender].hasBessies == true);
746             require(MilQerParlours[msg.sender].rentedBessiesTill < block.timestamp);
747             MilQerParlours[msg.sender].ownsBessies = true;
748             MilQerParlours[msg.sender].bessiesOwnedSince = MilQerParlours[msg.sender].rentedBessiesTill;
749             MilQerParlours[msg.sender].owedMilk = true;
750         }
751     }
752 
753     function roundUpCows(uint256 _cow) external {
754         require(!staQingPaused);
755         require(_cow == 0 && LinQerParlours[msg.sender].ownsDaisys == true || _cow == 1 && MilQerParlours[msg.sender].ownsBessies == true);
756 
757             if (_cow == 0) {
758                 uint256 newTimestamp = block.timestamp + roundUpDaisysTime; //make this time variable    
759                 LinQerParlours[msg.sender].daisysOwnedTill = newTimestamp;
760             }
761 
762             if (_cow == 1) {
763                 uint256 newTimestamp = block.timestamp + roundUpBessiesTime; 
764                 MilQerParlours[msg.sender].bessiesOwnedTill = newTimestamp;
765             }
766     }
767 
768     function unstaQe(uint256 _amtLinQ, uint256 _amtMilQ, uint256 _token) external { 
769         require(!staQingPaused); 
770         require(_token == 0 || _token == 1); 
771         uint256 totalMilk = viewHowMuchMilk(msg.sender); 
772  
773         if (totalMilk > 0) {   
774             shipMilk(); 
775         } 
776  
777         if (_token == 0) { 
778             require(_amtLinQ > 0); 
779             require(LinQerParlours[msg.sender].daisys >= _amtLinQ);
780             require(LinQerParlours[msg.sender].hasDaisys == true); 
781             unstaQeLinQ(_amtLinQ); 
782         } 
783  
784         if (_token == 1) { 
785             require(_amtMilQ > 0); 
786             require(MilQerParlours[msg.sender].bessies >= _amtMilQ);
787             require(MilQerParlours[msg.sender].hasBessies == true); 
788             unstaQeMilQ(_amtMilQ); 
789         }     
790     }
791 
792     function unstaQeLinQ(uint256 amtLinQ) internal {        
793         if (LinQerParlours[msg.sender].ownsDaisys == true) {
794             glinQ.approve(address(this), amtLinQ);
795             glinQ.transferFrom(msg.sender, address(this), amtLinQ);
796         }
797 
798         uint256 amtToClaim = checkEstMilQRewards(msg.sender);
799         
800         if (amtToClaim > 0) {
801             shipLinQersMilQ();
802         }
803 
804         uint256 transferLinQ;
805         uint256 dToOddysParlour;
806 
807             if (LinQerParlours[msg.sender].daisysOwnedTill < block.timestamp && LinQerParlours[msg.sender].ownsDaisys == true){
808                 linQ.transfer(msg.sender, amtLinQ);
809                 LinQerParlours[msg.sender].daisys -= amtLinQ; 
810             }
811 
812             if (LinQerParlours[msg.sender].rentedDaisysTill < block.timestamp && LinQerParlours[msg.sender].ownsDaisys == false){
813                 linQ.transfer(msg.sender, amtLinQ);
814                 LinQerParlours[msg.sender].daisys -= amtLinQ; 
815             }
816 
817             if (LinQerParlours[msg.sender].daisysOwnedTill > block.timestamp && LinQerParlours[msg.sender].ownsDaisys == true){
818                 dToOddysParlour = (amtLinQ * daisysToOddysParlour / 100);
819                 transferLinQ = (amtLinQ - dToOddysParlour);
820                 linQ.transfer(msg.sender, transferLinQ);
821                 linQ.transfer(oddysParlour, dToOddysParlour);
822                 LinQerParlours[msg.sender].daisys -= amtLinQ;          
823             }
824 
825             if (LinQerParlours[msg.sender].rentedDaisysTill > block.timestamp && LinQerParlours[msg.sender].ownsDaisys == false){
826                 dToOddysParlour = (amtLinQ * daisysToOddysParlour / 100);
827                 transferLinQ = (amtLinQ - dToOddysParlour);
828                 linQ.transfer(msg.sender, transferLinQ);
829                 linQ.transfer(oddysParlour, dToOddysParlour);
830                 LinQerParlours[msg.sender].daisys -= amtLinQ;  
831             }   
832 
833             if (LinQerParlours[msg.sender].daisys < minLinQ) {
834                 LinQerParlours[msg.sender].daisys = 0;
835                 LinQerParlours[msg.sender].rentedDaisysSince = 0;
836                 LinQerParlours[msg.sender].rentedDaisysTill = 0;
837                 LinQerParlours[msg.sender].vitaliksMilkShipped = 0;
838                 LinQerParlours[msg.sender].lastShippedVitaliksMilk = 0;
839                 LinQerParlours[msg.sender].vitaliksMilkClaimable = 0;
840                 LinQerParlours[msg.sender].QompoundedMilk = 0;
841                 LinQerParlours[msg.sender].daisysOwnedSince = 0;
842                 LinQerParlours[msg.sender].daisysOwnedTill = 0;
843                 LinQerParlours[msg.sender].hasDaisys = false;
844                 LinQerParlours[msg.sender].ownsDaisys = false;
845                 LinQerParlours[msg.sender].owedMilk = false;
846                 LinQerParlours[msg.sender].shipmentsRecieved = 0;
847                 linQers --;
848             }       
849     }
850 
851     function unstaQeMilQ(uint256 amtMilQ) internal {
852         uint256 transferMilQ;
853         uint256 bToOddysParlour;
854 
855             if (MilQerParlours[msg.sender].bessiesOwnedTill <= block.timestamp && MilQerParlours[msg.sender].ownsBessies == true){
856                 transferMilQ = amtMilQ;
857                 milQ.transfer(msg.sender, transferMilQ);
858                 MilQerParlours[msg.sender].bessies -= amtMilQ;
859             }
860 
861             if (MilQerParlours[msg.sender].rentedBessiesTill <= block.timestamp && MilQerParlours[msg.sender].ownsBessies == false){
862                 transferMilQ = amtMilQ;
863                 milQ.transfer(msg.sender, transferMilQ);
864                 MilQerParlours[msg.sender].bessies -= amtMilQ;
865             }
866 
867             if (MilQerParlours[msg.sender].bessiesOwnedTill > block.timestamp && MilQerParlours[msg.sender].ownsBessies == true){
868                 bToOddysParlour = (amtMilQ * bessiesToOddysParlour / 100);
869                 transferMilQ = (amtMilQ - bToOddysParlour);
870                 milQ.transfer(msg.sender, transferMilQ);
871                 milQ.transfer(oddysParlour, bToOddysParlour);
872                 MilQerParlours[msg.sender].bessies -= amtMilQ;
873             }
874 
875             if (MilQerParlours[msg.sender].rentedBessiesTill > block.timestamp && MilQerParlours[msg.sender].ownsBessies == false){
876                 bToOddysParlour = (amtMilQ * bessiesToOddysParlour / 100);
877                 transferMilQ = (amtMilQ - bToOddysParlour);
878                 milQ.transfer(msg.sender, transferMilQ);
879                 milQ.transfer(oddysParlour, bToOddysParlour);
880                 MilQerParlours[msg.sender].bessies -= amtMilQ;
881             }
882 
883             if (MilQerParlours[msg.sender].bessies < minMilQ) {
884                 MilQerParlours[msg.sender].bessies = 0;
885                 MilQerParlours[msg.sender].rentedBessiesSince = 0;
886                 MilQerParlours[msg.sender].rentedBessiesTill = 0;
887                 MilQerParlours[msg.sender].milQClaimed = 0;
888                 MilQerParlours[msg.sender].vitaliksMilkShipped = 0;
889                 MilQerParlours[msg.sender].lastShippedVitaliksMilk = 0;
890                 MilQerParlours[msg.sender].vitaliksMilkClaimable = 0;
891                 MilQerParlours[msg.sender].bessiesOwnedSince = 0;
892                 MilQerParlours[msg.sender].bessiesOwnedTill = 0;
893                 MilQerParlours[msg.sender].hasBessies = false;
894                 MilQerParlours[msg.sender].ownsBessies = false;
895                 MilQerParlours[msg.sender].owedMilk = false;
896                 MilQerParlours[msg.sender].shipmentsRecieved = 0;
897                 milQers --;
898             }
899     }
900 
901     function howMuchMilkV3() internal {
902         uint256 milkFromDaisys = 0;
903         uint256 milkFromBessies = 0;
904         if (LinQerParlours[msg.sender].ownsDaisys == true && LinQerParlours[msg.sender].daisysOwnedTill > block.timestamp) {
905             if (LinQerParlours[msg.sender].shipmentsRecieved != totalVitaliksMilkShipments) {
906                 for (uint256 i = LinQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
907                     milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
908                     LinQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
909                     LinQerParlours[msg.sender].shipmentsRecieved ++;
910                 }
911             }
912             
913             if (LinQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
914                 milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (block.timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
915                 LinQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
916             }
917         }
918 
919         if (LinQerParlours[msg.sender].ownsDaisys == false && LinQerParlours[msg.sender].hasDaisys == true && LinQerParlours[msg.sender].rentedDaisysTill > block.timestamp) {
920             if (LinQerParlours[msg.sender].shipmentsRecieved != totalVitaliksMilkShipments) {
921                 for (uint256 i = LinQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
922                     milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
923                     LinQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
924                     LinQerParlours[msg.sender].shipmentsRecieved ++;
925                 }
926             }
927             
928             if (LinQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
929                 milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (block.timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
930                 LinQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
931             }
932         }
933 
934         if (LinQerParlours[msg.sender].ownsDaisys == true && LinQerParlours[msg.sender].daisysOwnedTill <= block.timestamp && LinQerParlours[msg.sender].owedMilk == true) {
935             if(LinQerParlours[msg.sender].shipmentsRecieved < totalVitaliksMilkShipments) { 
936                 for (uint256 i = LinQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
937 
938                     if (LinQerParlours[msg.sender].daisysOwnedTill > VitaliksMilkShipments[i+1].timestamp) {
939                         milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
940                         LinQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
941                         LinQerParlours[msg.sender].shipmentsRecieved ++;
942                     }
943             
944                     if (LinQerParlours[msg.sender].daisysOwnedTill <= VitaliksMilkShipments[i+1].timestamp) {
945                         uint256 time = LinQerParlours[msg.sender].daisysOwnedTill - LinQerParlours[msg.sender].lastShippedVitaliksMilk;
946                         milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * time;
947                         LinQerParlours[msg.sender].lastShippedVitaliksMilk = LinQerParlours[msg.sender].daisysOwnedTill;
948                         LinQerParlours[msg.sender].owedMilk = false;
949                         break;   
950                     }   
951                 }
952             }
953 
954             if (LinQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
955                 milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (LinQerParlours[msg.sender].daisysOwnedTill - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
956                 LinQerParlours[msg.sender].lastShippedVitaliksMilk = LinQerParlours[msg.sender].daisysOwnedTill;
957                 LinQerParlours[msg.sender].owedMilk = false;
958             } 
959         }
960 
961         if (LinQerParlours[msg.sender].ownsDaisys == false && LinQerParlours[msg.sender].hasDaisys == true && LinQerParlours[msg.sender].rentedDaisysTill <= block.timestamp && LinQerParlours[msg.sender].owedMilk == true) {
962             if(LinQerParlours[msg.sender].shipmentsRecieved < totalVitaliksMilkShipments){
963                 for (uint256 i = LinQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
964                     if (LinQerParlours[msg.sender].rentedDaisysTill > VitaliksMilkShipments[i+1].timestamp) {
965                         milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
966                         LinQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
967                         LinQerParlours[msg.sender].shipmentsRecieved ++;
968                     }
969          
970                     if (LinQerParlours[msg.sender].rentedDaisysTill <= VitaliksMilkShipments[i+1].timestamp && LinQerParlours[msg.sender].owedMilk == true){
971                         uint256 time = LinQerParlours[msg.sender].rentedDaisysTill - LinQerParlours[msg.sender].lastShippedVitaliksMilk;
972                         milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * time;
973                         LinQerParlours[msg.sender].lastShippedVitaliksMilk = LinQerParlours[msg.sender].rentedDaisysTill;
974                         LinQerParlours[msg.sender].owedMilk = false;
975                         break;   
976                     }   
977                 }  
978             }
979 
980             if (LinQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
981                 milkFromDaisys += (LinQerParlours[msg.sender].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (LinQerParlours[msg.sender].rentedDaisysTill - LinQerParlours[msg.sender].lastShippedVitaliksMilk);
982                 LinQerParlours[msg.sender].lastShippedVitaliksMilk = LinQerParlours[msg.sender].rentedDaisysTill;
983                 LinQerParlours[msg.sender].owedMilk = false;
984             }       
985         }
986 
987         if (MilQerParlours[msg.sender].ownsBessies == true && MilQerParlours[msg.sender].bessiesOwnedTill > block.timestamp) {
988             if (MilQerParlours[msg.sender].shipmentsRecieved != totalVitaliksMilkShipments) {
989                 for (uint256 i = MilQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
990                     milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
991                     MilQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
992                     MilQerParlours[msg.sender].shipmentsRecieved ++;
993                 }
994             }
995 
996             if (MilQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments) {
997                 milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (block.timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
998                 MilQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
999             }
1000         }
1001 
1002         if (MilQerParlours[msg.sender].ownsBessies == false && MilQerParlours[msg.sender].hasBessies == true && MilQerParlours[msg.sender].rentedBessiesTill > block.timestamp && MilQerParlours[msg.sender].owedMilk == true) {
1003             if (MilQerParlours[msg.sender].shipmentsRecieved != totalVitaliksMilkShipments) {
1004                 for (uint256 i = MilQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
1005                     milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1006                     MilQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
1007                     MilQerParlours[msg.sender].shipmentsRecieved ++;
1008                 }
1009             }
1010 
1011             if (MilQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
1012                 milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (block.timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1013                 MilQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
1014             }
1015         }
1016         
1017         if (MilQerParlours[msg.sender].ownsBessies == true && MilQerParlours[msg.sender].bessiesOwnedTill <= block.timestamp && MilQerParlours[msg.sender].owedMilk == true) { 
1018             if (MilQerParlours[msg.sender].shipmentsRecieved < totalVitaliksMilkShipments) {
1019                 for (uint256 i = MilQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
1020                     if (MilQerParlours[msg.sender].bessiesOwnedTill > VitaliksMilkShipments[i+1].timestamp) {
1021                         milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1022                         MilQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
1023                         MilQerParlours[msg.sender].shipmentsRecieved ++;
1024                     }
1025             
1026                     if (MilQerParlours[msg.sender].bessiesOwnedTill <= VitaliksMilkShipments[i+1].timestamp){
1027                         uint256 time = MilQerParlours[msg.sender].bessiesOwnedTill - MilQerParlours[msg.sender].lastShippedVitaliksMilk;
1028                         milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * time;
1029                         MilQerParlours[msg.sender].lastShippedVitaliksMilk = MilQerParlours[msg.sender].bessiesOwnedTill;
1030                         MilQerParlours[msg.sender].owedMilk = false;
1031                         break;   
1032                     }   
1033                 }
1034             }
1035 
1036             if (MilQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
1037                 milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (MilQerParlours[msg.sender].bessiesOwnedTill - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1038                 MilQerParlours[msg.sender].lastShippedVitaliksMilk = MilQerParlours[msg.sender].bessiesOwnedTill;
1039                 MilQerParlours[msg.sender].owedMilk = false;
1040             }    
1041         }
1042   
1043         if (MilQerParlours[msg.sender].ownsBessies == false && MilQerParlours[msg.sender].hasBessies == true && MilQerParlours[msg.sender].rentedBessiesTill <= block.timestamp  && MilQerParlours[msg.sender].owedMilk == true) {
1044             if(MilQerParlours[msg.sender].shipmentsRecieved != totalVitaliksMilkShipments){
1045                 for (uint256 i = MilQerParlours[msg.sender].shipmentsRecieved; i < totalVitaliksMilkShipments; i++) {
1046                     if (MilQerParlours[msg.sender].rentedBessiesTill > VitaliksMilkShipments[i+1].timestamp) {
1047                         milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1048                         MilQerParlours[msg.sender].lastShippedVitaliksMilk = VitaliksMilkShipments[i+1].timestamp;
1049                         MilQerParlours[msg.sender].shipmentsRecieved ++;
1050                     }
1051         
1052                     if (MilQerParlours[msg.sender].rentedBessiesTill <= VitaliksMilkShipments[i+1].timestamp){
1053                         uint256 time = MilQerParlours[msg.sender].rentedBessiesTill - MilQerParlours[msg.sender].lastShippedVitaliksMilk;
1054                         milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * time;
1055                         MilQerParlours[msg.sender].lastShippedVitaliksMilk = MilQerParlours[msg.sender].rentedBessiesTill;
1056                         MilQerParlours[msg.sender].owedMilk = false;
1057                         break;   
1058                     }   
1059                 }  
1060             }
1061 
1062             if (MilQerParlours[msg.sender].shipmentsRecieved == totalVitaliksMilkShipments){
1063                 milkFromBessies += (MilQerParlours[msg.sender].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (MilQerParlours[msg.sender].rentedBessiesTill - MilQerParlours[msg.sender].lastShippedVitaliksMilk);
1064                 MilQerParlours[msg.sender].lastShippedVitaliksMilk = MilQerParlours[msg.sender].rentedBessiesTill;
1065                 MilQerParlours[msg.sender].owedMilk = false;
1066             }       
1067         }
1068 
1069         LinQerParlours[msg.sender].vitaliksMilkClaimable += milkFromDaisys;
1070         MilQerParlours[msg.sender].vitaliksMilkClaimable += milkFromBessies;
1071         daisysMilkProduced += milkFromDaisys;
1072         bessiesMilkProduced += milkFromBessies;      
1073     }
1074 
1075     function viewHowMuchMilk(address user) public view returns (uint256 Total) {
1076         uint256 daisysShipped = LinQerParlours[user].shipmentsRecieved;
1077         uint256 daisysTimeShipped = LinQerParlours[user].lastShippedVitaliksMilk;
1078         uint256 bessiesShipped = MilQerParlours[user].shipmentsRecieved;
1079         uint256 bessiesTimeShipped = MilQerParlours[user].lastShippedVitaliksMilk;
1080         uint256 milkFromDaisys = 0;
1081         uint256 milkFromBessies = 0;
1082 
1083         if (LinQerParlours[user].ownsDaisys == true && LinQerParlours[user].daisysOwnedTill > block.timestamp) {
1084             if (daisysShipped != totalVitaliksMilkShipments) {
1085                 for (uint256 i = daisysShipped; i < totalVitaliksMilkShipments; i++) {
1086                     milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - daisysTimeShipped);
1087                     daisysTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1088                     daisysShipped ++;
1089                 }
1090             }
1091             
1092             if (daisysShipped == totalVitaliksMilkShipments){
1093                 milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (block.timestamp - daisysTimeShipped);
1094             }
1095         }
1096 
1097         if (LinQerParlours[user].ownsDaisys == false && LinQerParlours[user].hasDaisys == true && LinQerParlours[user].rentedDaisysTill > block.timestamp) {
1098             if (daisysShipped != totalVitaliksMilkShipments) {
1099                 for (uint256 i = daisysShipped; i < totalVitaliksMilkShipments; i++) {
1100                     milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - daisysTimeShipped);
1101                     daisysTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1102                     daisysShipped ++;
1103                 }
1104             }
1105             
1106             if (daisysShipped == totalVitaliksMilkShipments){
1107                 milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (block.timestamp - daisysTimeShipped);
1108             }
1109         }
1110 
1111         if (LinQerParlours[user].ownsDaisys == true && LinQerParlours[user].daisysOwnedTill <= block.timestamp && LinQerParlours[user].owedMilk == true) {
1112             if(daisysShipped < totalVitaliksMilkShipments) { 
1113                 for (uint256 i = daisysShipped; i < totalVitaliksMilkShipments; i++) {
1114 
1115                     if (LinQerParlours[user].daisysOwnedTill > VitaliksMilkShipments[i+1].timestamp) {
1116                         milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - daisysTimeShipped);
1117                         daisysTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1118                         daisysShipped ++;
1119                     }
1120             
1121                     if (LinQerParlours[user].daisysOwnedTill <= VitaliksMilkShipments[i+1].timestamp) {
1122                         uint256 time = LinQerParlours[user].daisysOwnedTill - daisysTimeShipped;
1123                         milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * time;
1124                         break;   
1125                     }   
1126                 }
1127             }
1128 
1129             if (daisysShipped == totalVitaliksMilkShipments){
1130                 milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (LinQerParlours[user].daisysOwnedTill - daisysTimeShipped);
1131             } 
1132         }
1133 
1134         if (LinQerParlours[user].ownsDaisys == false && LinQerParlours[user].hasDaisys == true && LinQerParlours[user].rentedDaisysTill <= block.timestamp && LinQerParlours[user].owedMilk == true) {
1135             if(daisysShipped < totalVitaliksMilkShipments){
1136                 for (uint256 i = daisysShipped; i < totalVitaliksMilkShipments; i++) {
1137                     if (LinQerParlours[user].rentedDaisysTill > VitaliksMilkShipments[i+1].timestamp) {
1138                         milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * (VitaliksMilkShipments[i+1].timestamp - daisysTimeShipped);
1139                         daisysTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1140                         daisysShipped ++;
1141                     }
1142          
1143                     if (LinQerParlours[user].rentedDaisysTill <= VitaliksMilkShipments[i+1].timestamp && LinQerParlours[user].owedMilk == true){
1144                         uint256 time = LinQerParlours[user].rentedDaisysTill - daisysTimeShipped;
1145                         milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[i].daisysOutput * time;
1146                         break;   
1147                     }   
1148                 }  
1149             }
1150 
1151             if (daisysShipped == totalVitaliksMilkShipments){
1152                 milkFromDaisys += (LinQerParlours[user].daisys / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].daisysOutput * (LinQerParlours[user].rentedDaisysTill - daisysTimeShipped);
1153             }       
1154         }
1155 
1156         if (MilQerParlours[user].ownsBessies == true && MilQerParlours[user].bessiesOwnedTill > block.timestamp) {
1157             if (bessiesShipped != totalVitaliksMilkShipments) {
1158                 for (uint256 i = bessiesShipped; i < totalVitaliksMilkShipments; i++) {
1159                     milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - bessiesTimeShipped);
1160                     bessiesTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1161                     bessiesShipped ++;
1162                 }
1163             }
1164 
1165             if (bessiesShipped == totalVitaliksMilkShipments) {
1166                 milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (block.timestamp - bessiesTimeShipped);
1167             }
1168         }
1169 
1170         if (MilQerParlours[user].ownsBessies == false && MilQerParlours[user].hasBessies == true && MilQerParlours[user].rentedBessiesTill > block.timestamp && MilQerParlours[user].owedMilk == true) {
1171             if (bessiesShipped != totalVitaliksMilkShipments) {
1172                 for (uint256 i = bessiesShipped; i < totalVitaliksMilkShipments; i++) {
1173                     milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - bessiesTimeShipped);
1174                     bessiesTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1175                     bessiesShipped ++;
1176                 }
1177             }
1178 
1179             if (bessiesShipped == totalVitaliksMilkShipments){
1180                 milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (block.timestamp - bessiesTimeShipped);
1181             }
1182 
1183         }
1184 
1185         if (MilQerParlours[user].ownsBessies == true && MilQerParlours[user].bessiesOwnedTill <= block.timestamp) { 
1186             if (bessiesShipped != totalVitaliksMilkShipments) {
1187                 for (uint256 i = bessiesShipped; i < totalVitaliksMilkShipments; i++) {
1188                     if (MilQerParlours[user].bessiesOwnedTill > VitaliksMilkShipments[i+1].timestamp) {
1189                         milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - bessiesTimeShipped);
1190                         bessiesTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1191                         bessiesShipped ++;
1192                     }
1193             
1194                     if (MilQerParlours[user].bessiesOwnedTill <= VitaliksMilkShipments[i+1].timestamp && MilQerParlours[user].owedMilk == true){
1195                         uint256 time = MilQerParlours[user].bessiesOwnedTill - bessiesTimeShipped;
1196                         milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * time;
1197                         break;   
1198                     }   
1199                 }
1200             }
1201 
1202             if (bessiesShipped == totalVitaliksMilkShipments){
1203                 milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (MilQerParlours[user].bessiesOwnedTill - bessiesTimeShipped);
1204             }    
1205         }
1206 
1207         if (MilQerParlours[user].ownsBessies == false && MilQerParlours[user].hasBessies == true && MilQerParlours[user].rentedBessiesTill <= block.timestamp) {
1208             if(bessiesShipped != totalVitaliksMilkShipments){
1209                 for (uint256 i = bessiesShipped; i < totalVitaliksMilkShipments; i++) {
1210                     if (MilQerParlours[user].rentedBessiesTill > VitaliksMilkShipments[i+1].timestamp) {
1211                         milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * (VitaliksMilkShipments[i+1].timestamp - bessiesTimeShipped);
1212                         bessiesTimeShipped = VitaliksMilkShipments[i+1].timestamp;
1213                         bessiesShipped ++;
1214                     }
1215         
1216                     if (MilQerParlours[user].rentedBessiesTill <= VitaliksMilkShipments[i+1].timestamp && MilQerParlours[user].owedMilk == true){
1217                         uint256 time = MilQerParlours[user].rentedBessiesTill - bessiesTimeShipped;
1218                         milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[i].bessiesOutput * time;
1219                         break;   
1220                     }   
1221                 }  
1222             }
1223 
1224             if (bessiesShipped == totalVitaliksMilkShipments){
1225                 milkFromBessies += (MilQerParlours[user].bessies / 1000000000000000000) * VitaliksMilkShipments[totalVitaliksMilkShipments].bessiesOutput * (MilQerParlours[user].rentedBessiesTill - bessiesTimeShipped);
1226             }       
1227         }
1228 
1229         Total = milkFromDaisys + milkFromBessies; 
1230         return (Total);       
1231     }
1232 
1233     function QompoundLinQ(uint256 slippage) external {  
1234         if (LinQerParlours[msg.sender].hasDaisys == true){
1235             shipLinQersMilQ();
1236         }
1237 
1238         howMuchMilkV3();  
1239   
1240         uint256 linqAmt = LinQerParlours[msg.sender].vitaliksMilkClaimable; 
1241         uint256 milqAmt = MilQerParlours[msg.sender].vitaliksMilkClaimable; 
1242         uint256 _ethAmount = linqAmt + milqAmt; 
1243   
1244         address[] memory path = new address[](2);  
1245         path[0] = uniswapRouter.WETH();  
1246         path[1] = swapLinq;  
1247   
1248         uint256[] memory amountsOut = uniswapRouter.getAmountsOut(_ethAmount, path);  
1249         uint256 minLinQAmount = amountsOut[1];   
1250   
1251       
1252         uint256 beforeBalance = IERC20(linQ).balanceOf(address(this));  
1253         uint256 amountSlip = (minLinQAmount * slippage) / 100;  
1254         uint256 amountAfterSlip = minLinQAmount - amountSlip;  
1255   
1256       
1257         uniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: _ethAmount}(  
1258             amountAfterSlip,  
1259             path,  
1260             address(this),  
1261             block.timestamp  
1262         );  
1263   
1264         uint256 afterBalance = IERC20(linQ).balanceOf(address(this));  
1265   
1266         uint256 boughtAmount = afterBalance - beforeBalance;
1267 
1268         if (LinQerParlours[msg.sender].ownsDaisys == true) {
1269             glinQ.transfer(msg.sender, boughtAmount);
1270         }
1271 
1272         if (LinQerParlours[msg.sender].hasDaisys == true) { 
1273             LinQerParlours[msg.sender].daisys += boughtAmount;  
1274             LinQerParlours[msg.sender].QompoundedMilk += _ethAmount;  
1275             LinQerParlours[msg.sender].vitaliksMilkClaimable = 0; 
1276             MilQerParlours[msg.sender].vitaliksMilkClaimable = 0;
1277         }
1278 
1279         if (LinQerParlours[msg.sender].hasDaisys == false) {
1280             LinQerParlours[msg.sender].daisys += boughtAmount;
1281             LinQerParlours[msg.sender].rentedDaisysSince = block.timestamp;
1282             LinQerParlours[msg.sender].rentedDaisysTill = block.timestamp + daisysRentalTime; 
1283             LinQerParlours[msg.sender].daisysOwnedSince = 0;
1284             LinQerParlours[msg.sender].daisysOwnedTill = 32503680000;
1285             LinQerParlours[msg.sender].hasDaisys = true;
1286             LinQerParlours[msg.sender].ownsDaisys = false;
1287             LinQerParlours[msg.sender].vitaliksMilkShipped = 0;
1288             LinQerParlours[msg.sender].QompoundedMilk = 0;
1289             LinQerParlours[msg.sender].lastShippedVitaliksMilk = block.timestamp;
1290             LinQerParlours[msg.sender].shipmentsRecieved = totalVitaliksMilkShipments;
1291             LinQerParlours[msg.sender].vitaliksMilkClaimable = 0;
1292             LinQerParlours[msg.sender].owedMilk = true;
1293             LpClaims[msg.sender].lastClaimed = totalMilQClaimed;
1294             LpClaims[msg.sender].totalClaimed = 0;
1295             MilQerParlours[msg.sender].vitaliksMilkClaimable = 0;
1296             daisys += boughtAmount;
1297             linQers ++;
1298         }
1299 
1300         daisys += boughtAmount;
1301         vitaliksMilkQompounded += _ethAmount;
1302         emit Qompound(msg.sender, _ethAmount, boughtAmount);
1303     }
1304         
1305     function shipMilk() public {   
1306           
1307         howMuchMilkV3();
1308 
1309         uint256 linq = LinQerParlours[msg.sender].vitaliksMilkClaimable;
1310         uint256 lp = MilQerParlours[msg.sender].vitaliksMilkClaimable;
1311         uint256 amount = linq + lp;
1312 
1313         require(address(this).balance >= amount);
1314 
1315         payable(msg.sender).transfer(amount);
1316 
1317         LinQerParlours[msg.sender].vitaliksMilkShipped += linq;
1318         MilQerParlours[msg.sender].vitaliksMilkShipped += lp;
1319         LinQerParlours[msg.sender].vitaliksMilkClaimable = 0;
1320         MilQerParlours[msg.sender].vitaliksMilkClaimable = 0;
1321         vitaliksMilkShipped += amount;
1322 
1323         if (amount > highClaimThreshold){
1324             emit highClaim(msg.sender,amount);
1325         }
1326 
1327         if(address(this).balance < lowBalanceThreshold){
1328             emit lowBalance(block.timestamp,address(this).balance);
1329         }    
1330     }
1331 
1332     function shipFarmMilQ() external onlyOwner {
1333 
1334         uint256 beforeBalance = IERC20(milQ).balanceOf(address(this)); 
1335 
1336         ILINQ.claim();
1337 
1338         uint256 afterBalance = IERC20(milQ).balanceOf(address(this));
1339 
1340         uint256 claimed = afterBalance - beforeBalance;
1341 
1342          uint256 PerLinQ = (claimed * 10**18) / daisys;
1343 
1344         uint256 index = MilqShipments;
1345 
1346         MilQShipments[index] = MilQShipment(block.timestamp, claimed, daisys,PerLinQ);
1347 
1348         MilqShipments++;
1349 
1350         totalMilQClaimed += claimed;
1351     }
1352 
1353     function shipLinQersMilQ() public {  
1354         uint256 CurrrentDis = totalMilQClaimed - LpClaims[msg.sender].lastClaimed;  
1355         uint256 tokensStaked = LinQerParlours[msg.sender].daisys;  
1356          uint256 divDaisys = daisys / 10**18; 
1357         uint256 percentOwned = ((tokensStaked * 100) / divDaisys); 
1358         uint256 userDistro = CurrrentDis * (percentOwned / 100); 
1359         uint256 userDistroAmount = userDistro / 10**18; 
1360         milQ.transfer(msg.sender, userDistroAmount); 
1361   
1362         MilQerParlours[msg.sender].milQClaimed += userDistroAmount;
1363         LpClaims[msg.sender].lastClaimed = totalMilQClaimed;  
1364         LpClaims[msg.sender].totalClaimed += userDistroAmount;  
1365     }  
1366   
1367     function checkEstMilQRewards(address user) public view returns (uint256){  
1368         uint256 CurrrentDis = totalMilQClaimed - LpClaims[user].lastClaimed;  
1369         uint256 tokensStaked = LinQerParlours[user].daisys;  
1370         uint256 divDaisys = daisys / 10**18; 
1371         uint256 percentOwned = ((tokensStaked * 100) / divDaisys); 
1372         uint256 userDistro = CurrrentDis * (percentOwned / 100); 
1373         uint256 userDistroAmount = userDistro / 10**18; 
1374  
1375         return userDistroAmount;  
1376     }
1377 
1378     receive() external payable {}
1379 }