1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
28 
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 
98 // File contracts/library/SafeMath.sol
99 
100 
101 pragma solidity >=0.5.0 <0.8.0;
102 
103 library SafeMath {
104     uint256 constant WAD = 10 ** 18;
105     uint256 constant RAY = 10 ** 27;
106 
107     function wad() public pure returns (uint256) {
108         return WAD;
109     }
110 
111     function ray() public pure returns (uint256) {
112         return RAY;
113     }
114 
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150 
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         // Solidity only automatically asserts when dividing by 0
153         require(b > 0, errorMessage);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return mod(a, b, "SafeMath: modulo by zero");
162     }
163 
164     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b != 0, errorMessage);
166         return a % b;
167     }
168 
169     function min(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a <= b ? a : b;
171     }
172 
173     function max(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a >= b ? a : b;
175     }
176 
177     function sqrt(uint256 a) internal pure returns (uint256 b) {
178         if (a > 3) {
179             b = a;
180             uint256 x = a / 2 + 1;
181             while (x < b) {
182                 b = x;
183                 x = (a / x + x) / 2;
184             }
185         } else if (a != 0) {
186             b = 1;
187         }
188     }
189 
190     function wmul(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mul(a, b) / WAD;
192     }
193 
194     function wmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
195         return add(mul(a, b), WAD / 2) / WAD;
196     }
197 
198     function rmul(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mul(a, b) / RAY;
200     }
201 
202     function rmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
203         return add(mul(a, b), RAY / 2) / RAY;
204     }
205 
206     function wdiv(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(mul(a, WAD), b);
208     }
209 
210     function wdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
211         return add(mul(a, WAD), b / 2) / b;
212     }
213 
214     function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(mul(a, RAY), b);
216     }
217 
218     function rdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
219         return add(mul(a, RAY), b / 2) / b;
220     }
221 
222     function wpow(uint256 x, uint256 n) internal pure returns (uint256) {
223         uint256 result = WAD;
224         while (n > 0) {
225             if (n % 2 != 0) {
226                 result = wmul(result, x);
227             }
228             x = wmul(x, x);
229             n /= 2;
230         }
231         return result;
232     }
233 
234     function rpow(uint256 x, uint256 n) internal pure returns (uint256) {
235         uint256 result = RAY;
236         while (n > 0) {
237             if (n % 2 != 0) {
238                 result = rmul(result, x);
239             }
240             x = rmul(x, x);
241             n /= 2;
242         }
243         return result;
244     }
245 }
246 
247 
248 // File contracts/interface/IERC20.sol
249 
250 
251 pragma solidity >=0.5.0 <0.8.0;
252 
253 interface IERC20 {
254     event Approval(address indexed owner, address indexed spender, uint value);
255     event Transfer(address indexed from, address indexed to, uint value);
256 
257     function name() external view returns (string memory);
258 
259     function symbol() external view returns (string memory);
260 
261     function decimals() external view returns (uint8);
262 
263     function totalSupply() external view returns (uint);
264 
265     function balanceOf(address owner) external view returns (uint);
266 
267     function allowance(address owner, address spender) external view returns (uint);
268 
269     function approve(address spender, uint value) external returns (bool);
270 
271     function transfer(address to, uint value) external returns (bool);
272 
273     function transferFrom(address from, address to, uint value) external returns (bool);
274 }
275 
276 
277 // File contracts/interface/ICCFactory.sol
278 
279 
280 pragma solidity >=0.5.0 <0.8.0;
281 
282 interface ICCFactory {
283     function updater() external view returns (address);
284 
285     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
286 
287     function feeTo() external view returns (address);
288 
289     function feeToSetter() external view returns (address);
290 
291     function feeToRate() external view returns (uint256);
292 
293     function getPair(address tokenA, address tokenB) external view returns (address pair);
294 
295     function allPairs(uint) external view returns (address pair);
296 
297     function allPairsLength() external view returns (uint);
298 
299     function createPair(address tokenA, address tokenB) external returns (address pair);
300 
301     function setFeeTo(address) external;
302 
303     function setFeeToSetter(address) external;
304 
305     function setFeeToRate(uint256) external;
306 
307     function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);
308 
309     function pairFor(address tokenA, address tokenB) external view returns (address pair);
310 
311     function getReserves(address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);
312 
313     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
314 
315     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
316 
317     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
318 
319     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
320 
321     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
322     
323     function migrator() external view returns (address);
324     
325     function setMigrator(address) external;
326 
327 }
328 
329 
330 // File contracts/interface/ICCPair.sol
331 
332 
333 pragma solidity >=0.5.0 <0.8.0;
334 
335 interface ICCPair {
336     event Approval(address indexed owner, address indexed spender, uint value);
337     event Transfer(address indexed from, address indexed to, uint value);
338 
339     function name() external pure returns (string memory);
340 
341     function symbol() external pure returns (string memory);
342 
343     function decimals() external pure returns (uint8);
344 
345     function totalSupply() external view returns (uint);
346 
347     function balanceOf(address owner) external view returns (uint);
348 
349     function allowance(address owner, address spender) external view returns (uint);
350 
351     function approve(address spender, uint value) external returns (bool);
352 
353     function transfer(address to, uint value) external returns (bool);
354 
355     function transferFrom(address from, address to, uint value) external returns (bool);
356 
357     function DOMAIN_SEPARATOR() external view returns (bytes32);
358 
359     function PERMIT_TYPEHASH() external pure returns (bytes32);
360 
361     function nonces(address owner) external view returns (uint);
362 
363     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
364 
365     event Mint(address indexed sender, uint amount0, uint amount1);
366     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
367     event Swap(
368         address indexed sender,
369         uint amount0In,
370         uint amount1In,
371         uint amount0Out,
372         uint amount1Out,
373         address indexed to
374     );
375     event Sync(uint112 reserve0, uint112 reserve1);
376 
377     function MINIMUM_LIQUIDITY() external pure returns (uint);
378 
379     function factory() external view returns (address);
380 
381     function token0() external view returns (address);
382 
383     function token1() external view returns (address);
384 
385     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
386 
387     function price0CumulativeLast() external view returns (uint);
388 
389     function price1CumulativeLast() external view returns (uint);
390 
391     function kLast() external view returns (uint);
392 
393     function mint(address to) external returns (uint liquidity);
394 
395     function burn(address to) external returns (uint amount0, uint amount1);
396 
397     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
398 
399     function skim(address to) external;
400 
401     function sync() external;
402 
403     function price(address token, uint256 baseDecimal) external view returns (uint256);
404 
405     function initialize(address, address) external;
406 
407     function updateFee() external;
408 }
409 
410 
411 // File contracts/interface/ICCRouter.sol
412 
413 
414 pragma solidity ^0.6.6;
415 
416 interface ICCRouter {
417     function factory() external pure returns (address);
418 
419     function WETH() external pure returns (address);
420 
421     function addLiquidity(
422         address tokenA,
423         address tokenB,
424         uint amountADesired,
425         uint amountBDesired,
426         uint amountAMin,
427         uint amountBMin,
428         address to,
429         uint deadline
430     ) external returns (uint amountA, uint amountB, uint liquidity);
431 
432     function addLiquidityETH(
433         address token,
434         uint amountTokenDesired,
435         uint amountTokenMin,
436         uint amountETHMin,
437         address to,
438         uint deadline
439     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
440 
441     function removeLiquidity(
442         address tokenA,
443         address tokenB,
444         uint liquidity,
445         uint amountAMin,
446         uint amountBMin,
447         address to,
448         uint deadline
449     ) external returns (uint amountA, uint amountB);
450 
451     function removeLiquidityETH(
452         address token,
453         uint liquidity,
454         uint amountTokenMin,
455         uint amountETHMin,
456         address to,
457         uint deadline
458     ) external returns (uint amountToken, uint amountETH);
459 
460     function removeLiquidityWithPermit(
461         address tokenA,
462         address tokenB,
463         uint liquidity,
464         uint amountAMin,
465         uint amountBMin,
466         address to,
467         uint deadline,
468         bool approveMax, uint8 v, bytes32 r, bytes32 s
469     ) external returns (uint amountA, uint amountB);
470 
471     function removeLiquidityETHWithPermit(
472         address token,
473         uint liquidity,
474         uint amountTokenMin,
475         uint amountETHMin,
476         address to,
477         uint deadline,
478         bool approveMax, uint8 v, bytes32 r, bytes32 s
479     ) external returns (uint amountToken, uint amountETH);
480 
481     function swapExactTokensForTokens(
482         uint amountIn,
483         uint amountOutMin,
484         address[] calldata path,
485         address to,
486         uint deadline
487     ) external returns (uint[] memory amounts);
488 
489     function swapTokensForExactTokens(
490         uint amountOut,
491         uint amountInMax,
492         address[] calldata path,
493         address to,
494         uint deadline
495     ) external returns (uint[] memory amounts);
496 
497     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
498     external
499     payable
500     returns (uint[] memory amounts);
501 
502     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
503     external
504     returns (uint[] memory amounts);
505 
506     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
507     external
508     returns (uint[] memory amounts);
509 
510     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
511     external
512     payable
513     returns (uint[] memory amounts);
514 
515     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);
516 
517     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
518 
519     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
520 
521     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
522 
523     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
524 
525     function removeLiquidityETHSupportingFeeOnTransferTokens(
526         address token,
527         uint liquidity,
528         uint amountTokenMin,
529         uint amountETHMin,
530         address to,
531         uint deadline
532     ) external returns (uint amountETH);
533 
534     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
535         address token,
536         uint liquidity,
537         uint amountTokenMin,
538         uint amountETHMin,
539         address to,
540         uint deadline,
541         bool approveMax, uint8 v, bytes32 r, bytes32 s
542     ) external returns (uint amountETH);
543 
544     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
545         uint amountIn,
546         uint amountOutMin,
547         address[] calldata path,
548         address to,
549         uint deadline
550     ) external;
551 
552     function swapExactETHForTokensSupportingFeeOnTransferTokens(
553         uint amountOutMin,
554         address[] calldata path,
555         address to,
556         uint deadline
557     ) external payable;
558 
559     function swapExactTokensForETHSupportingFeeOnTransferTokens(
560         uint amountIn,
561         uint amountOutMin,
562         address[] calldata path,
563         address to,
564         uint deadline
565     ) external;
566 }
567 
568 
569 // File contracts/interface/IWETH.sol
570 
571 pragma solidity ^0.6.12;
572 interface IWETH {
573     function deposit() external payable;
574 
575     function transfer(address to, uint value) external returns (bool);
576 
577     function withdraw(uint) external;
578 }
579 
580 
581 // File contracts/interface/IVolumeBook.sol
582 
583 
584 pragma solidity ^0.6.0;
585 interface IVolumeBook {
586     function addVolume(address user, address input, address output, uint256 amount) external returns (bool);
587     function getUserVolume(address user, uint256 cycleNum) external view returns (uint256);
588     function getTotalTradeVolume(uint256 cycleNum) external view returns (uint256);
589     function currentCycleNum() external pure returns (uint256);
590     function lastUpdateTime() external pure returns (uint256);
591     function addCycleNum() external;
592     function canUpdate() external view returns(bool);
593 
594     function getWhitelistLength() external view returns (uint256);
595     function getWhitelist(uint256 _index) external view returns (address);
596 }
597 
598 
599 // File contracts/interface/IOracle.sol
600 
601 
602 pragma solidity ^0.6.6;
603 
604 interface IOracle {
605     function factory() external pure returns (address);
606     function update(address tokenA, address tokenB) external returns(bool);
607     function updatePair(address pair) external returns(bool);
608     function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut);
609 }
610 
611 
612 // File contracts/core/Router.sol
613 
614 
615 
616 pragma solidity ^0.6.6;
617 
618 
619 
620 
621 
622 
623 
624 
625 
626 contract CCRouter is ICCRouter, Ownable {
627     using SafeMath for uint256;
628 
629     address public immutable override factory;
630     address public immutable override WETH;
631     IVolumeBook public volumeBook;
632     address public oracle;
633 
634     modifier ensure(uint deadline) {
635         require(deadline >= block.timestamp, 'CCRouter: EXPIRED');
636         _;
637     }
638 
639     constructor(address _factory, address _WETH) public {
640         factory = _factory;
641         WETH = _WETH;
642     }
643 
644     receive() external payable {
645         assert(msg.sender == WETH);
646         // only accept ETH via fallback from the WETH contract
647     }
648 
649     function pairFor(address tokenA, address tokenB) public view returns (address pair){
650         pair = ICCFactory(factory).pairFor(tokenA, tokenB);
651     }
652 
653     function setVolumeBook(address _volumeBook) public onlyOwner {
654         volumeBook = IVolumeBook(_volumeBook);
655     }
656     function setOracle(address _oracle) public onlyOwner {
657         oracle = _oracle;
658     }
659    
660     // **** ADD LIQUIDITY ****
661     function _addLiquidity(
662         address tokenA,
663         address tokenB,
664         uint amountADesired,
665         uint amountBDesired,
666         uint amountAMin,
667         uint amountBMin
668     ) internal virtual returns (uint amountA, uint amountB) {
669         // create the pair if it doesn't exist yet
670         if (ICCFactory(factory).getPair(tokenA, tokenB) == address(0)) {
671             ICCFactory(factory).createPair(tokenA, tokenB);
672         }
673         (uint reserveA, uint reserveB) = ICCFactory(factory).getReserves(tokenA, tokenB);
674         if (reserveA == 0 && reserveB == 0) {
675             (amountA, amountB) = (amountADesired, amountBDesired);
676         } else {
677             uint amountBOptimal = ICCFactory(factory).quote(amountADesired, reserveA, reserveB);
678             if (amountBOptimal <= amountBDesired) {
679                 require(amountBOptimal >= amountBMin, 'CCRouter: INSUFFICIENT_B_AMOUNT');
680                 (amountA, amountB) = (amountADesired, amountBOptimal);
681             } else {
682                 uint amountAOptimal = ICCFactory(factory).quote(amountBDesired, reserveB, reserveA);
683                 assert(amountAOptimal <= amountADesired);
684                 require(amountAOptimal >= amountAMin, 'CCRouter: INSUFFICIENT_A_AMOUNT');
685                 (amountA, amountB) = (amountAOptimal, amountBDesired);
686             }
687         }
688     }
689 
690     function addLiquidity(
691         address tokenA,
692         address tokenB,
693         uint amountADesired,
694         uint amountBDesired,
695         uint amountAMin,
696         uint amountBMin,
697         address to,
698         uint deadline
699     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
700         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
701         address pair = pairFor(tokenA, tokenB);
702         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
703         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
704         liquidity = ICCPair(pair).mint(to);
705         if (oracle != address(0)) {
706             IOracle(oracle).update(tokenA, tokenB);
707         }
708     }
709 
710     function addLiquidityETH(
711         address token,
712         uint amountTokenDesired,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline
717     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
718         (amountToken, amountETH) = _addLiquidity(
719             token,
720             WETH,
721             amountTokenDesired,
722             msg.value,
723             amountTokenMin,
724             amountETHMin
725         );
726         address pair = pairFor(token, WETH);
727         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
728         IWETH(WETH).deposit{value : amountETH}();
729         assert(IWETH(WETH).transfer(pair, amountETH));
730         liquidity = ICCPair(pair).mint(to);
731         if (oracle != address(0)) {
732             IOracle(oracle).update(token, WETH);
733         }
734         // refund dust eth, if any
735         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
736     }
737 
738     // **** REMOVE LIQUIDITY ****
739     function removeLiquidity(
740         address tokenA,
741         address tokenB,
742         uint liquidity,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
748         address pair = pairFor(tokenA, tokenB);
749         ICCPair(pair).transferFrom(msg.sender, pair, liquidity);
750         // send liquidity to pair
751         (uint amount0, uint amount1) = ICCPair(pair).burn(to);
752         (address token0,) = ICCFactory(factory).sortTokens(tokenA, tokenB);
753         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
754         require(amountA >= amountAMin, 'CCRouter: INSUFFICIENT_A_AMOUNT');
755         require(amountB >= amountBMin, 'CCRouter: INSUFFICIENT_B_AMOUNT');
756     }
757 
758     function removeLiquidityETH(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline
765     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
766         (amountToken, amountETH) = removeLiquidity(
767             token,
768             WETH,
769             liquidity,
770             amountTokenMin,
771             amountETHMin,
772             address(this),
773             deadline
774         );
775         TransferHelper.safeTransfer(token, to, amountToken);
776         IWETH(WETH).withdraw(amountETH);
777         TransferHelper.safeTransferETH(to, amountETH);
778     }
779 
780     function removeLiquidityWithPermit(
781         address tokenA,
782         address tokenB,
783         uint liquidity,
784         uint amountAMin,
785         uint amountBMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external virtual override returns (uint amountA, uint amountB) {
790         address pair = pairFor(tokenA, tokenB);
791         uint value = approveMax ? uint(- 1) : liquidity;
792         ICCPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
793         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
794     }
795 
796     function removeLiquidityETHWithPermit(
797         address token,
798         uint liquidity,
799         uint amountTokenMin,
800         uint amountETHMin,
801         address to,
802         uint deadline,
803         bool approveMax, uint8 v, bytes32 r, bytes32 s
804     ) external virtual override returns (uint amountToken, uint amountETH) {
805         address pair = pairFor(token, WETH);
806         uint value = approveMax ? uint(- 1) : liquidity;
807         ICCPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
808         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
809     }
810 
811     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
812     function removeLiquidityETHSupportingFeeOnTransferTokens(
813         address token,
814         uint liquidity,
815         uint amountTokenMin,
816         uint amountETHMin,
817         address to,
818         uint deadline
819     ) public virtual override ensure(deadline) returns (uint amountETH) {
820         (, amountETH) = removeLiquidity(
821             token,
822             WETH,
823             liquidity,
824             amountTokenMin,
825             amountETHMin,
826             address(this),
827             deadline
828         );
829         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
830         IWETH(WETH).withdraw(amountETH);
831         TransferHelper.safeTransferETH(to, amountETH);
832     }
833 
834     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline,
841         bool approveMax, uint8 v, bytes32 r, bytes32 s
842     ) external virtual override returns (uint amountETH) {
843         address pair = pairFor(token, WETH);
844         uint value = approveMax ? uint(- 1) : liquidity;
845         ICCPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
846         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
847             token, liquidity, amountTokenMin, amountETHMin, to, deadline
848         );
849     }
850 
851     // **** SWAP ****
852     // requires the initial amount to have already been sent to the first pair
853     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
854         for (uint i; i < path.length - 1; i++) {
855             (address input, address output) = (path[i], path[i + 1]);
856             (address token0,) = ICCFactory(factory).sortTokens(input, output);
857             uint amountOut = amounts[i + 1];
858             if (address(volumeBook) != address(0)) {
859                 volumeBook.addVolume(msg.sender, input, output, amountOut);
860             }
861             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
862             address to = i < path.length - 2 ? pairFor(output, path[i + 2]) : _to;
863             ICCPair(pairFor(input, output)).swap(
864                 amount0Out, amount1Out, to, new bytes(0)
865             );
866         }
867     }
868 
869     function swapExactTokensForTokens(
870         uint amountIn,
871         uint amountOutMin,
872         address[] calldata path,
873         address to,
874         uint deadline
875     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
876         amounts = ICCFactory(factory).getAmountsOut(amountIn, path);
877         require(amounts[amounts.length - 1] >= amountOutMin, 'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT');
878         TransferHelper.safeTransferFrom(
879             path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]
880         );
881         _swap(amounts, path, to);
882     }
883 
884     function swapTokensForExactTokens(
885         uint amountOut,
886         uint amountInMax,
887         address[] calldata path,
888         address to,
889         uint deadline
890     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
891         amounts = ICCFactory(factory).getAmountsIn(amountOut, path);
892         require(amounts[0] <= amountInMax, 'CCRouter: EXCESSIVE_INPUT_AMOUNT');
893         TransferHelper.safeTransferFrom(
894             path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]
895         );
896         _swap(amounts, path, to);
897     }
898 
899     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
900     external
901     virtual
902     override
903     payable
904     ensure(deadline)
905     returns (uint[] memory amounts)
906     {
907         require(path[0] == WETH, 'CCRouter: INVALID_PATH');
908         amounts = ICCFactory(factory).getAmountsOut(msg.value, path);
909         require(amounts[amounts.length - 1] >= amountOutMin, 'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT');
910         IWETH(WETH).deposit{value : amounts[0]}();
911         assert(IWETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
912         _swap(amounts, path, to);
913     }
914 
915     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
916     external
917     virtual
918     override
919     ensure(deadline)
920     returns (uint[] memory amounts)
921     {
922         require(path[path.length - 1] == WETH, 'CCRouter: INVALID_PATH');
923         amounts = ICCFactory(factory).getAmountsIn(amountOut, path);
924         require(amounts[0] <= amountInMax, 'CCRouter: EXCESSIVE_INPUT_AMOUNT');
925         TransferHelper.safeTransferFrom(
926             path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]
927         );
928         _swap(amounts, path, address(this));
929         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
930         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
931     }
932 
933     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
934     external
935     virtual
936     override
937     ensure(deadline)
938     returns (uint[] memory amounts)
939     {
940         require(path[path.length - 1] == WETH, 'CCRouter: INVALID_PATH');
941         amounts = ICCFactory(factory).getAmountsOut(amountIn, path);
942         require(amounts[amounts.length - 1] >= amountOutMin, 'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT');
943         TransferHelper.safeTransferFrom(
944             path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]
945         );
946         _swap(amounts, path, address(this));
947         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
948         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
949     }
950 
951     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
952     external
953     virtual
954     override
955     payable
956     ensure(deadline)
957     returns (uint[] memory amounts)
958     {
959         require(path[0] == WETH, 'CCRouter: INVALID_PATH');
960         amounts = ICCFactory(factory).getAmountsIn(amountOut, path);
961         require(amounts[0] <= msg.value, 'CCRouter: EXCESSIVE_INPUT_AMOUNT');
962         IWETH(WETH).deposit{value : amounts[0]}();
963         assert(IWETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
964         _swap(amounts, path, to);
965         // refund dust eth, if any
966         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
967     }
968 
969     // **** SWAP (supporting fee-on-transfer tokens) ****
970     // requires the initial amount to have already been sent to the first pair
971     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
972         for (uint i; i < path.length - 1; i++) {
973             (address input, address output) = (path[i], path[i + 1]);
974             (address token0,) = ICCFactory(factory).sortTokens(input, output);
975             ICCPair pair = ICCPair(pairFor(input, output));
976             uint amountInput;
977             uint amountOutput;
978             {// scope to avoid stack too deep errors
979                 (uint reserve0, uint reserve1,) = pair.getReserves();
980                 (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
981                 amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
982                 amountOutput = ICCFactory(factory).getAmountOut(amountInput, reserveInput, reserveOutput);
983             }
984             if (address(volumeBook) != address(0)) {
985                 volumeBook.addVolume(msg.sender, input, output, amountOutput);
986             }
987             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
988             address to = i < path.length - 2 ? pairFor(output, path[i + 2]) : _to;
989             pair.swap(amount0Out, amount1Out, to, new bytes(0));
990         }
991     }
992 
993     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
994         uint amountIn,
995         uint amountOutMin,
996         address[] calldata path,
997         address to,
998         uint deadline
999     ) external virtual override ensure(deadline) {
1000         TransferHelper.safeTransferFrom(
1001             path[0], msg.sender, pairFor(path[0], path[1]), amountIn
1002         );
1003         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1004         _swapSupportingFeeOnTransferTokens(path, to);
1005         require(
1006             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1007             'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT'
1008         );
1009     }
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint deadline
1016     )
1017     external
1018     virtual
1019     override
1020     payable
1021     ensure(deadline)
1022     {
1023         require(path[0] == WETH, 'CCRouter: INVALID_PATH');
1024         uint amountIn = msg.value;
1025         IWETH(WETH).deposit{value : amountIn}();
1026         assert(IWETH(WETH).transfer(pairFor(path[0], path[1]), amountIn));
1027         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1028         _swapSupportingFeeOnTransferTokens(path, to);
1029         require(
1030             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1031             'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT'
1032         );
1033     }
1034 
1035     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1036         uint amountIn,
1037         uint amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint deadline
1041     )
1042     external
1043     virtual
1044     override
1045     ensure(deadline)
1046     {
1047         require(path[path.length - 1] == WETH, 'CCRouter: INVALID_PATH');
1048         TransferHelper.safeTransferFrom(
1049             path[0], msg.sender, pairFor(path[0], path[1]), amountIn
1050         );
1051         _swapSupportingFeeOnTransferTokens(path, address(this));
1052         uint amountOut = IERC20(WETH).balanceOf(address(this));
1053         require(amountOut >= amountOutMin, 'CCRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1054         IWETH(WETH).withdraw(amountOut);
1055         TransferHelper.safeTransferETH(to, amountOut);
1056     }
1057 
1058     // **** LIBRARY FUNCTIONS ****
1059     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) public view override returns (uint256 amountB) {
1060         return ICCFactory(factory).quote(amountA, reserveA, reserveB);
1061     }
1062 
1063     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view override returns (uint256 amountOut){
1064         return ICCFactory(factory).getAmountOut(amountIn, reserveIn, reserveOut);
1065     }
1066 
1067     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) public view override returns (uint256 amountIn){
1068         return ICCFactory(factory).getAmountIn(amountOut, reserveIn, reserveOut);
1069     }
1070 
1071     function getAmountsOut(uint256 amountIn, address[] memory path) public view override returns (uint256[] memory amounts){
1072         return ICCFactory(factory).getAmountsOut(amountIn, path);
1073     }
1074 
1075     function getAmountsIn(uint256 amountOut, address[] memory path) public view override returns (uint256[] memory amounts){
1076         return ICCFactory(factory).getAmountsIn(amountOut, path);
1077     }
1078 
1079 }
1080 
1081 
1082 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
1083 library TransferHelper {
1084     function safeApprove(address token, address to, uint value) internal {
1085         // bytes4(keccak256(bytes('approve(address,uint256)')));
1086         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1087         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1088     }
1089 
1090     function safeTransfer(address token, address to, uint value) internal {
1091         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1092         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1093         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1094     }
1095 
1096     function safeTransferFrom(address token, address from, address to, uint value) internal {
1097         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1098         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1099         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1100     }
1101 
1102     function safeTransferETH(address to, uint value) internal {
1103         (bool success,) = to.call{value : value}(new bytes(0));
1104         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1105     }
1106 }