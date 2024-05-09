1 // File: @openzeppelin/contracts@3.4.1/utils/Context.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts@3.4.1/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: pancake/interfaces/IWETH.sol
99 
100 
101 pragma solidity >=0.5.0;
102 
103 interface IWETH {
104     function deposit() external payable;
105 
106     function transfer(address to, uint256 value) external returns (bool);
107 
108     function withdraw(uint256) external;
109 }
110 
111 // File: pancake/interfaces/IERC20.sol
112 
113 
114 pragma solidity >=0.5.0;
115 
116 interface IERC20 {
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     function name() external view returns (string memory);
121 
122     function symbol() external view returns (string memory);
123 
124     function decimals() external view returns (uint8);
125 
126     function totalSupply() external view returns (uint256);
127 
128     function balanceOf(address owner) external view returns (uint256);
129 
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     function approve(address spender, uint256 value) external returns (bool);
133 
134     function transfer(address to, uint256 value) external returns (bool);
135 
136     function transferFrom(
137         address from,
138         address to,
139         uint256 value
140     ) external returns (bool);
141 }
142 
143 // File: pancake/interfaces/IGrovePair.sol
144 
145 
146 pragma solidity >=0.5.0;
147 
148 interface IGrovePair {
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     function name() external pure returns (string memory);
153 
154     function symbol() external pure returns (string memory);
155 
156     function decimals() external pure returns (uint8);
157 
158     function totalSupply() external view returns (uint256);
159 
160     function balanceOf(address owner) external view returns (uint256);
161 
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     function approve(address spender, uint256 value) external returns (bool);
165 
166     function transfer(address to, uint256 value) external returns (bool);
167 
168     function transferFrom(
169         address from,
170         address to,
171         uint256 value
172     ) external returns (bool);
173 
174     function DOMAIN_SEPARATOR() external view returns (bytes32);
175 
176     function PERMIT_TYPEHASH() external pure returns (bytes32);
177 
178     function nonces(address owner) external view returns (uint256);
179 
180     function permit(
181         address owner,
182         address spender,
183         uint256 value,
184         uint256 deadline,
185         uint8 v,
186         bytes32 r,
187         bytes32 s
188     ) external;
189 
190     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
191     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
192     event Swap(
193         address indexed sender,
194         uint256 amount0In,
195         uint256 amount1In,
196         uint256 amount0Out,
197         uint256 amount1Out,
198         address indexed to
199     );
200     event Sync(uint112 reserve0, uint112 reserve1);
201 
202     function MINIMUM_LIQUIDITY() external pure returns (uint256);
203 
204     function factory() external view returns (address);
205 
206     function token0() external view returns (address);
207 
208     function token1() external view returns (address);
209 
210     function getReserves()
211         external
212         view
213         returns (
214             uint112 reserve0,
215             uint112 reserve1,
216             uint32 blockTimestampLast
217         );
218 
219     function price0CumulativeLast() external view returns (uint256);
220 
221     function price1CumulativeLast() external view returns (uint256);
222 
223     function kLast() external view returns (uint256);
224 
225     function mint(address to) external returns (uint256 liquidity);
226 
227     function burn(address to) external returns (uint256 amount0, uint256 amount1);
228 
229     function swap(
230         uint256 amount0Out,
231         uint256 amount1Out,
232         address to,
233         bytes calldata data
234     ) external;
235 
236     function skim(address to) external;
237 
238     function sync() external;
239 
240     function initialize(address, address) external;
241 }
242 
243 // File: pancake/libraries/SafeMath.sol
244 
245 
246 pragma solidity >=0.5.0 <0.7.0;
247 
248 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
249 
250 library SafeMath {
251     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
252         require((z = x + y) >= x, "ds-math-add-overflow");
253     }
254 
255     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
256         require((z = x - y) <= x, "ds-math-sub-underflow");
257     }
258 
259     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
260         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
261     }
262 }
263 
264 // File: pancake/interfaces/IGroveFactory.sol
265 
266 
267 pragma solidity >=0.5.0;
268 
269 interface IGroveFactory {
270     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
271 
272     function feeTo() external view returns (address);
273 
274     function feeToSetter() external view returns (address);
275 
276     function getPair(address tokenA, address tokenB) external view returns (address pair);
277 
278     function allPairs(uint256) external view returns (address pair);
279 
280     function allPairsLength() external view returns (uint256);
281 
282     function createPair(address tokenA, address tokenB) external returns (address pair);
283 
284     function setFeeTo(address) external;
285 
286     function setFeeToSetter(address) external;
287 
288     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
289 }
290 
291 // File: pancake/libraries/GroveLibrary.sol
292 
293 
294 pragma solidity >=0.5.0;
295 
296 
297 
298 
299 library GroveLibrary {
300     using SafeMath for uint256;
301 
302     // returns sorted token addresses, used to handle return values from pairs sorted in this order
303     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
304         require(tokenA != tokenB, "GroveLibrary: IDENTICAL_ADDRESSES");
305         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
306         require(token0 != address(0), "GroveLibrary: ZERO_ADDRESS");
307     }
308 
309     // calculates the CREATE2 address for a pair without making any external calls
310     function pairFor(
311         address factory,
312         address tokenA,
313         address tokenB
314     ) internal pure returns (address pair) {
315         (address token0, address token1) = sortTokens(tokenA, tokenB);
316         pair = address(
317             uint256(
318                 keccak256(
319                     abi.encodePacked(
320                         hex"ff",
321                         factory,
322                         keccak256(abi.encodePacked(token0, token1)),
323                         hex"52e084bf7808906b58ff24c0cd6e39d5b5e8b86a688b1efe65844b85542587ae" // init code hash
324                     )
325                 )
326             )
327         );
328     }
329 
330     // fetches and sorts the reserves for a pair
331     function getReserves(
332         address factory,
333         address tokenA,
334         address tokenB
335     ) internal view returns (uint256 reserveA, uint256 reserveB) {
336         (address token0, ) = sortTokens(tokenA, tokenB);
337         pairFor(factory, tokenA, tokenB);
338         (uint256 reserve0, uint256 reserve1, ) = IGrovePair(pairFor(factory, tokenA, tokenB)).getReserves();
339         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
340     }
341 
342     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
343     function quote(
344         uint256 amountA,
345         uint256 reserveA,
346         uint256 reserveB
347     ) internal pure returns (uint256 amountB) {
348         require(amountA > 0, "GroveLibrary: INSUFFICIENT_AMOUNT");
349         require(reserveA > 0 && reserveB > 0, "GroveLibrary: INSUFFICIENT_LIQUIDITY");
350         amountB = amountA.mul(reserveB) / reserveA;
351     }
352 
353     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
354     function getAmountOut(
355         uint256 amountIn,
356         uint256 reserveIn,
357         uint256 reserveOut
358     ) internal pure returns (uint256 amountOut) {
359         require(amountIn > 0, "GroveLibrary: INSUFFICIENT_INPUT_AMOUNT");
360         require(reserveIn > 0 && reserveOut > 0, "GroveLibrary: INSUFFICIENT_LIQUIDITY");
361         uint256 amountInWithFee = amountIn.mul(9930);
362         uint256 numerator = amountInWithFee.mul(reserveOut);
363         uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
364         amountOut = numerator / denominator;
365     }
366 
367     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
368     function getAmountIn(
369         uint256 amountOut,
370         uint256 reserveIn,
371         uint256 reserveOut
372     ) internal pure returns (uint256 amountIn) {
373         require(amountOut > 0, "GroveLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
374         require(reserveIn > 0 && reserveOut > 0, "GroveLibrary: INSUFFICIENT_LIQUIDITY");
375         uint256 numerator = reserveIn.mul(amountOut).mul(10000);
376         uint256 denominator = reserveOut.sub(amountOut).mul(9930);
377         amountIn = (numerator / denominator).add(1);
378     }
379 
380     // performs chained getAmountOut calculations on any number of pairs
381     function getAmountsOut(
382         address factory,
383         uint256 amountIn,
384         address[] memory path
385     ) internal view returns (uint256[] memory amounts) {
386         require(path.length >= 2, "GroveLibrary: INVALID_PATH");
387         amounts = new uint256[](path.length);
388         amounts[0] = amountIn;
389         for (uint256 i; i < path.length - 1; i++) {
390             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i], path[i + 1]);
391             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
392         }
393     }
394 
395     // performs chained getAmountIn calculations on any number of pairs
396     function getAmountsIn(
397         address factory,
398         uint256 amountOut,
399         address[] memory path
400     ) internal view returns (uint256[] memory amounts) {
401         require(path.length >= 2, "GroveLibrary: INVALID_PATH");
402         amounts = new uint256[](path.length);
403         amounts[amounts.length - 1] = amountOut;
404         for (uint256 i = path.length - 1; i > 0; i--) {
405             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i - 1], path[i]);
406             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
407         }
408     }
409 }
410 
411 // File: pancake/interfaces/IGroveRouter01.sol
412 
413 
414 pragma solidity >=0.6.2;
415 
416 interface IGroveRouter01 {
417     function factory() external pure returns (address);
418 
419     function WETH() external pure returns (address);
420 
421     function addLiquidity(
422         address tokenA,
423         address tokenB,
424         uint256 amountADesired,
425         uint256 amountBDesired,
426         uint256 amountAMin,
427         uint256 amountBMin,
428         address to,
429         uint256 deadline
430     )
431         external
432         returns (
433             uint256 amountA,
434             uint256 amountB,
435             uint256 liquidity
436         );
437 
438     function addLiquidityETH(
439         address token,
440         uint256 amountTokenDesired,
441         uint256 amountTokenMin,
442         uint256 amountETHMin,
443         address to,
444         uint256 deadline
445     )
446         external
447         payable
448         returns (
449             uint256 amountToken,
450             uint256 amountETH,
451             uint256 liquidity
452         );
453 
454     function removeLiquidity(
455         address tokenA,
456         address tokenB,
457         uint256 liquidity,
458         uint256 amountAMin,
459         uint256 amountBMin,
460         address to,
461         uint256 deadline
462     ) external returns (uint256 amountA, uint256 amountB);
463 
464     function removeLiquidityETH(
465         address token,
466         uint256 liquidity,
467         uint256 amountTokenMin,
468         uint256 amountETHMin,
469         address to,
470         uint256 deadline
471     ) external returns (uint256 amountToken, uint256 amountETH);
472 
473     function removeLiquidityWithPermit(
474         address tokenA,
475         address tokenB,
476         uint256 liquidity,
477         uint256 amountAMin,
478         uint256 amountBMin,
479         address to,
480         uint256 deadline,
481         bool approveMax,
482         uint8 v,
483         bytes32 r,
484         bytes32 s
485     ) external returns (uint256 amountA, uint256 amountB);
486 
487     function removeLiquidityETHWithPermit(
488         address token,
489         uint256 liquidity,
490         uint256 amountTokenMin,
491         uint256 amountETHMin,
492         address to,
493         uint256 deadline,
494         bool approveMax,
495         uint8 v,
496         bytes32 r,
497         bytes32 s
498     ) external returns (uint256 amountToken, uint256 amountETH);
499 
500     function swapExactTokensForTokens(
501         uint256 amountIn,
502         uint256 amountOutMin,
503         address[] calldata path,
504         address to,
505         uint256 deadline
506     ) external returns (uint256[] memory amounts);
507 
508     function swapTokensForExactTokens(
509         uint256 amountOut,
510         uint256 amountInMax,
511         address[] calldata path,
512         address to,
513         uint256 deadline
514     ) external returns (uint256[] memory amounts);
515 
516     function swapExactETHForTokens(
517         uint256 amountOutMin,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external payable returns (uint256[] memory amounts);
522 
523     function swapTokensForExactETH(
524         uint256 amountOut,
525         uint256 amountInMax,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external returns (uint256[] memory amounts);
530 
531     function swapExactTokensForETH(
532         uint256 amountIn,
533         uint256 amountOutMin,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external returns (uint256[] memory amounts);
538 
539     function swapETHForExactTokens(
540         uint256 amountOut,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external payable returns (uint256[] memory amounts);
545 
546     function quote(
547         uint256 amountA,
548         uint256 reserveA,
549         uint256 reserveB
550     ) external pure returns (uint256 amountB);
551 
552     function getAmountOut(
553         uint256 amountIn,
554         uint256 reserveIn,
555         uint256 reserveOut
556     ) external pure returns (uint256 amountOut);
557 
558     function getAmountIn(
559         uint256 amountOut,
560         uint256 reserveIn,
561         uint256 reserveOut
562     ) external pure returns (uint256 amountIn);
563 
564     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
565 
566     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
567 }
568 
569 // File: pancake/interfaces/IGroveRouter02.sol
570 
571 
572 pragma solidity >=0.6.2;
573 
574 
575 interface IGroveRouter02 is IGroveRouter01 {
576     function removeLiquidityETHSupportingFeeOnTransferTokens(
577         address token,
578         uint256 liquidity,
579         uint256 amountTokenMin,
580         uint256 amountETHMin,
581         address to,
582         uint256 deadline
583     ) external returns (uint256 amountETH);
584 
585     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
586         address token,
587         uint256 liquidity,
588         uint256 amountTokenMin,
589         uint256 amountETHMin,
590         address to,
591         uint256 deadline,
592         bool approveMax,
593         uint8 v,
594         bytes32 r,
595         bytes32 s
596     ) external returns (uint256 amountETH);
597 
598     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
599         uint256 amountIn,
600         uint256 amountOutMin,
601         address[] calldata path,
602         address to,
603         uint256 deadline
604     ) external;
605 
606     function swapExactETHForTokensSupportingFeeOnTransferTokens(
607         uint256 amountOutMin,
608         address[] calldata path,
609         address to,
610         uint256 deadline
611     ) external payable;
612 
613     function swapExactTokensForETHSupportingFeeOnTransferTokens(
614         uint256 amountIn,
615         uint256 amountOutMin,
616         address[] calldata path,
617         address to,
618         uint256 deadline
619     ) external;
620 }
621 
622 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
623 
624 
625 
626 pragma solidity >=0.6.0;
627 
628 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
629 library TransferHelper {
630     function safeApprove(
631         address token,
632         address to,
633         uint256 value
634     ) internal {
635         // bytes4(keccak256(bytes('approve(address,uint256)')));
636         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
637         require(
638             success && (data.length == 0 || abi.decode(data, (bool))),
639             'TransferHelper::safeApprove: approve failed'
640         );
641     }
642 
643     function safeTransfer(
644         address token,
645         address to,
646         uint256 value
647     ) internal {
648         // bytes4(keccak256(bytes('transfer(address,uint256)')));
649         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
650         require(
651             success && (data.length == 0 || abi.decode(data, (bool))),
652             'TransferHelper::safeTransfer: transfer failed'
653         );
654     }
655 
656     function safeTransferFrom(
657         address token,
658         address from,
659         address to,
660         uint256 value
661     ) internal {
662         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
663         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
664         require(
665             success && (data.length == 0 || abi.decode(data, (bool))),
666             'TransferHelper::transferFrom: transferFrom failed'
667         );
668     }
669 
670     function safeTransferETH(address to, uint256 value) internal {
671         (bool success, ) = to.call{value: value}(new bytes(0));
672         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
673     }
674 }
675 
676 // File: pancake/GroveRouter.sol
677 
678 
679 pragma solidity =0.6.6;
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 contract GroveRouter is IGroveRouter02, Ownable {
690     using SafeMath for uint256;
691 
692     address public immutable override factory;
693     address public immutable override WETH;
694 
695     mapping(address => bool) private _isTokenWhiteList;
696 
697     modifier ensure(uint256 deadline) {
698         require(deadline >= block.timestamp, "GroveRouter: EXPIRED");
699         _;
700     }
701 
702     // Copied from: @openzeppelin/contracts/security/ReentrancyGuard.sol
703     uint256 private constant _NOT_ENTERED = 0;
704     uint256 private constant _ENTERED = 1;
705 
706     uint256 private _status;
707 
708     modifier nonReentrant() {
709         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
710 
711         _status = _ENTERED;
712 
713         _;
714 
715         _status = _NOT_ENTERED;
716     }
717 
718     constructor(address _factory, address _WETH) public {
719         factory = _factory;
720         WETH = _WETH;
721     }
722 
723     receive() external payable {
724         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
725     }
726 
727     // **** ADD LIQUIDITY ****
728     function _addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint256 amountADesired,
732         uint256 amountBDesired,
733         uint256 amountAMin,
734         uint256 amountBMin
735     ) internal virtual returns (uint256 amountA, uint256 amountB) {
736         // create the pair if it doesn't exist yet
737         if (IGroveFactory(factory).getPair(tokenA, tokenB) == address(0)) {
738             IGroveFactory(factory).createPair(tokenA, tokenB);
739         }
740         (uint256 reserveA, uint256 reserveB) = GroveLibrary.getReserves(
741             factory,
742             tokenA,
743             tokenB
744         );
745         if (reserveA == 0 && reserveB == 0) {
746             (amountA, amountB) = (amountADesired, amountBDesired);
747         } else {
748             uint256 amountBOptimal = GroveLibrary.quote(
749                 amountADesired,
750                 reserveA,
751                 reserveB
752             );
753             if (amountBOptimal <= amountBDesired) {
754                 require(
755                     amountBOptimal >= amountBMin,
756                     "GroveRouter: INSUFFICIENT_B_AMOUNT"
757                 );
758                 (amountA, amountB) = (amountADesired, amountBOptimal);
759             } else {
760                 uint256 amountAOptimal = GroveLibrary.quote(
761                     amountBDesired,
762                     reserveB,
763                     reserveA
764                 );
765                 assert(amountAOptimal <= amountADesired);
766                 require(
767                     amountAOptimal >= amountAMin,
768                     "GroveRouter: INSUFFICIENT_A_AMOUNT"
769                 );
770                 (amountA, amountB) = (amountAOptimal, amountBDesired);
771             }
772         }
773     }
774 
775     function addLiquidity(
776         address tokenA,
777         address tokenB,
778         uint256 amountADesired,
779         uint256 amountBDesired,
780         uint256 amountAMin,
781         uint256 amountBMin,
782         address to,
783         uint256 deadline
784     )
785         external
786         virtual
787         override
788         ensure(deadline)
789         returns (
790             uint256 amountA,
791             uint256 amountB,
792             uint256 liquidity
793         )
794     {
795         require(_isTokenWhiteList[tokenA], "Token not in White List!");
796         require(_isTokenWhiteList[tokenB], "Token not in White List!");
797 
798         (amountA, amountB) = _addLiquidity(
799             tokenA,
800             tokenB,
801             amountADesired,
802             amountBDesired,
803             amountAMin,
804             amountBMin
805         );
806         address pair = GroveLibrary.pairFor(factory, tokenA, tokenB);
807         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
808         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
809         liquidity = IGrovePair(pair).mint(to);
810     }
811 
812     function addLiquidityETH(
813         address token,
814         uint256 amountTokenDesired,
815         uint256 amountTokenMin,
816         uint256 amountETHMin,
817         address to,
818         uint256 deadline
819     )
820         external
821         payable
822         virtual
823         override
824         ensure(deadline)
825         returns (
826             uint256 amountToken,
827             uint256 amountETH,
828             uint256 liquidity
829         )
830     {
831         require(_isTokenWhiteList[token], "Token not in White List!");
832 
833         (amountToken, amountETH) = _addLiquidity(
834             token,
835             WETH,
836             amountTokenDesired,
837             msg.value,
838             amountTokenMin,
839             amountETHMin
840         );
841         address pair = GroveLibrary.pairFor(factory, token, WETH);
842         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
843         IWETH(WETH).deposit{value: amountETH}();
844         assert(IWETH(WETH).transfer(pair, amountETH));
845         liquidity = IGrovePair(pair).mint(to);
846         // refund dust eth, if any
847         if (msg.value > amountETH)
848             TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
849     }
850 
851     // **** REMOVE LIQUIDITY ****
852     function removeLiquidity(
853         address tokenA,
854         address tokenB,
855         uint256 liquidity,
856         uint256 amountAMin,
857         uint256 amountBMin,
858         address to,
859         uint256 deadline
860     )
861         public
862         virtual
863         override
864         ensure(deadline)
865         returns (uint256 amountA, uint256 amountB)
866     {
867         require(_isTokenWhiteList[tokenA], "Token not in White List!");
868         require(_isTokenWhiteList[tokenB], "Token not in White List!");
869 
870         address pair = GroveLibrary.pairFor(factory, tokenA, tokenB);
871         IGrovePair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
872         (uint256 amount0, uint256 amount1) = IGrovePair(pair).burn(to);
873         (address token0, ) = GroveLibrary.sortTokens(tokenA, tokenB);
874         (amountA, amountB) = tokenA == token0
875             ? (amount0, amount1)
876             : (amount1, amount0);
877         require(amountA >= amountAMin, "GroveRouter: INSUFFICIENT_A_AMOUNT");
878         require(amountB >= amountBMin, "GroveRouter: INSUFFICIENT_B_AMOUNT");
879     }
880 
881     function removeLiquidityETH(
882         address token,
883         uint256 liquidity,
884         uint256 amountTokenMin,
885         uint256 amountETHMin,
886         address to,
887         uint256 deadline
888     )
889         public
890         virtual
891         override
892         ensure(deadline)
893         returns (uint256 amountToken, uint256 amountETH)
894     {
895         require(_isTokenWhiteList[token], "Token not in White List!");
896 
897         (amountToken, amountETH) = removeLiquidity(
898             token,
899             WETH,
900             liquidity,
901             amountTokenMin,
902             amountETHMin,
903             address(this),
904             deadline
905         );
906         TransferHelper.safeTransfer(token, to, amountToken);
907         IWETH(WETH).withdraw(amountETH);
908         TransferHelper.safeTransferETH(to, amountETH);
909     }
910 
911     function removeLiquidityWithPermit(
912         address tokenA,
913         address tokenB,
914         uint256 liquidity,
915         uint256 amountAMin,
916         uint256 amountBMin,
917         address to,
918         uint256 deadline,
919         bool approveMax,
920         uint8 v,
921         bytes32 r,
922         bytes32 s
923     ) external virtual override returns (uint256 amountA, uint256 amountB) {
924         address pair = GroveLibrary.pairFor(factory, tokenA, tokenB);
925         uint256 value = approveMax ? uint256(-1) : liquidity;
926         IGrovePair(pair).permit(
927             msg.sender,
928             address(this),
929             value,
930             deadline,
931             v,
932             r,
933             s
934         );
935         (amountA, amountB) = removeLiquidity(
936             tokenA,
937             tokenB,
938             liquidity,
939             amountAMin,
940             amountBMin,
941             to,
942             deadline
943         );
944     }
945 
946     function removeLiquidityETHWithPermit(
947         address token,
948         uint256 liquidity,
949         uint256 amountTokenMin,
950         uint256 amountETHMin,
951         address to,
952         uint256 deadline,
953         bool approveMax,
954         uint8 v,
955         bytes32 r,
956         bytes32 s
957     )
958         external
959         virtual
960         override
961         returns (uint256 amountToken, uint256 amountETH)
962     {
963         address pair = GroveLibrary.pairFor(factory, token, WETH);
964         uint256 value = approveMax ? uint256(-1) : liquidity;
965         IGrovePair(pair).permit(
966             msg.sender,
967             address(this),
968             value,
969             deadline,
970             v,
971             r,
972             s
973         );
974         (amountToken, amountETH) = removeLiquidityETH(
975             token,
976             liquidity,
977             amountTokenMin,
978             amountETHMin,
979             to,
980             deadline
981         );
982     }
983 
984     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
985     function removeLiquidityETHSupportingFeeOnTransferTokens(
986         address token,
987         uint256 liquidity,
988         uint256 amountTokenMin,
989         uint256 amountETHMin,
990         address to,
991         uint256 deadline
992     ) public virtual override ensure(deadline) returns (uint256 amountETH) {
993         (, amountETH) = removeLiquidity(
994             token,
995             WETH,
996             liquidity,
997             amountTokenMin,
998             amountETHMin,
999             address(this),
1000             deadline
1001         );
1002         TransferHelper.safeTransfer(
1003             token,
1004             to,
1005             IERC20(token).balanceOf(address(this))
1006         );
1007         IWETH(WETH).withdraw(amountETH);
1008         TransferHelper.safeTransferETH(to, amountETH);
1009     }
1010 
1011     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1012         address token,
1013         uint256 liquidity,
1014         uint256 amountTokenMin,
1015         uint256 amountETHMin,
1016         address to,
1017         uint256 deadline,
1018         bool approveMax,
1019         uint8 v,
1020         bytes32 r,
1021         bytes32 s
1022     ) external virtual override returns (uint256 amountETH) {
1023         address pair = GroveLibrary.pairFor(factory, token, WETH);
1024         uint256 value = approveMax ? uint256(-1) : liquidity;
1025         IGrovePair(pair).permit(
1026             msg.sender,
1027             address(this),
1028             value,
1029             deadline,
1030             v,
1031             r,
1032             s
1033         );
1034         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
1035             token,
1036             liquidity,
1037             amountTokenMin,
1038             amountETHMin,
1039             to,
1040             deadline
1041         );
1042     }
1043 
1044     // **** SWAP ****
1045     // requires the initial amount to have already been sent to the first pair
1046     function _swap(
1047         uint256[] memory amounts,
1048         address[] memory path,
1049         address _to
1050     ) internal virtual {
1051         for (uint256 i; i < path.length - 1; i++) {
1052             (address input, address output) = (path[i], path[i + 1]);
1053             (address token0, ) = GroveLibrary.sortTokens(input, output);
1054             uint256 amountOut = amounts[i + 1];
1055             (uint256 amount0Out, uint256 amount1Out) = input == token0
1056                 ? (uint256(0), amountOut)
1057                 : (amountOut, uint256(0));
1058             address to = i < path.length - 2
1059                 ? GroveLibrary.pairFor(factory, output, path[i + 2])
1060                 : _to;
1061             IGrovePair(GroveLibrary.pairFor(factory, input, output)).swap(
1062                 amount0Out,
1063                 amount1Out,
1064                 to,
1065                 new bytes(0)
1066             );
1067         }
1068     }
1069 
1070     function swapExactTokensForTokens(
1071         uint256 amountIn,
1072         uint256 amountOutMin,
1073         address[] calldata path,
1074         address to,
1075         uint256 deadline
1076     )
1077         external
1078         virtual
1079         override
1080         ensure(deadline)
1081         returns (uint256[] memory amounts)
1082     {
1083         amounts = GroveLibrary.getAmountsOut(factory, amountIn, path);
1084         require(
1085             amounts[amounts.length - 1] >= amountOutMin,
1086             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1087         );
1088         TransferHelper.safeTransferFrom(
1089             path[0],
1090             msg.sender,
1091             GroveLibrary.pairFor(factory, path[0], path[1]),
1092             amounts[0]
1093         );
1094         _swap(amounts, path, to);
1095     }
1096 
1097     function swapTokensForExactTokens(
1098         uint256 amountOut,
1099         uint256 amountInMax,
1100         address[] calldata path,
1101         address to,
1102         uint256 deadline
1103     )
1104         external
1105         virtual
1106         override
1107         ensure(deadline)
1108         returns (uint256[] memory amounts)
1109     {
1110         amounts = GroveLibrary.getAmountsIn(factory, amountOut, path);
1111         require(
1112             amounts[0] <= amountInMax,
1113             "GroveRouter: EXCESSIVE_INPUT_AMOUNT"
1114         );
1115         TransferHelper.safeTransferFrom(
1116             path[0],
1117             msg.sender,
1118             GroveLibrary.pairFor(factory, path[0], path[1]),
1119             amounts[0]
1120         );
1121         _swap(amounts, path, to);
1122     }
1123 
1124     function swapExactETHForTokens(
1125         uint256 amountOutMin,
1126         address[] calldata path,
1127         address to,
1128         uint256 deadline
1129     )
1130         external
1131         payable
1132         virtual
1133         override
1134         ensure(deadline)
1135         returns (uint256[] memory amounts)
1136     {
1137         require(path[0] == WETH, "GroveRouter: INVALID_PATH");
1138         amounts = GroveLibrary.getAmountsOut(factory, msg.value, path);
1139         require(
1140             amounts[amounts.length - 1] >= amountOutMin,
1141             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1142         );
1143         IWETH(WETH).deposit{value: amounts[0]}();
1144         assert(
1145             IWETH(WETH).transfer(
1146                 GroveLibrary.pairFor(factory, path[0], path[1]),
1147                 amounts[0]
1148             )
1149         );
1150         _swap(amounts, path, to);
1151     }
1152 
1153     function swapTokensForExactETH(
1154         uint256 amountOut,
1155         uint256 amountInMax,
1156         address[] calldata path,
1157         address to,
1158         uint256 deadline
1159     )
1160         external
1161         virtual
1162         override
1163         ensure(deadline)
1164         returns (uint256[] memory amounts)
1165     {
1166         require(path[path.length - 1] == WETH, "GroveRouter: INVALID_PATH");
1167         amounts = GroveLibrary.getAmountsIn(factory, amountOut, path);
1168         require(
1169             amounts[0] <= amountInMax,
1170             "GroveRouter: EXCESSIVE_INPUT_AMOUNT"
1171         );
1172         TransferHelper.safeTransferFrom(
1173             path[0],
1174             msg.sender,
1175             GroveLibrary.pairFor(factory, path[0], path[1]),
1176             amounts[0]
1177         );
1178         _swap(amounts, path, address(this));
1179         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1180         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1181     }
1182 
1183     function swapExactTokensForETH(
1184         uint256 amountIn,
1185         uint256 amountOutMin,
1186         address[] calldata path,
1187         address to,
1188         uint256 deadline
1189     )
1190         external
1191         virtual
1192         override
1193         ensure(deadline)
1194         returns (uint256[] memory amounts)
1195     {
1196         require(path[path.length - 1] == WETH, "GroveRouter: INVALID_PATH");
1197         amounts = GroveLibrary.getAmountsOut(factory, amountIn, path);
1198         require(
1199             amounts[amounts.length - 1] >= amountOutMin,
1200             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1201         );
1202         TransferHelper.safeTransferFrom(
1203             path[0],
1204             msg.sender,
1205             GroveLibrary.pairFor(factory, path[0], path[1]),
1206             amounts[0]
1207         );
1208         _swap(amounts, path, address(this));
1209         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1210         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1211     }
1212 
1213     function swapETHForExactTokens(
1214         uint256 amountOut,
1215         address[] calldata path,
1216         address to,
1217         uint256 deadline
1218     )
1219         external
1220         payable
1221         virtual
1222         override
1223         ensure(deadline)
1224         returns (uint256[] memory amounts)
1225     {
1226         require(path[0] == WETH, "GroveRouter: INVALID_PATH");
1227         amounts = GroveLibrary.getAmountsIn(factory, amountOut, path);
1228         require(amounts[0] <= msg.value, "GroveRouter: EXCESSIVE_INPUT_AMOUNT");
1229         IWETH(WETH).deposit{value: amounts[0]}();
1230         assert(
1231             IWETH(WETH).transfer(
1232                 GroveLibrary.pairFor(factory, path[0], path[1]),
1233                 amounts[0]
1234             )
1235         );
1236         _swap(amounts, path, to);
1237         // refund dust eth, if any
1238         if (msg.value > amounts[0])
1239             TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
1240     }
1241 
1242     // **** SWAP (supporting fee-on-transfer tokens) ****
1243     // requires the initial amount to have already been sent to the first pair
1244     function _swapSupportingFeeOnTransferTokens(
1245         address[] memory path,
1246         address _to
1247     ) internal virtual {
1248         for (uint256 i; i < path.length - 1; i++) {
1249             (address input, address output) = (path[i], path[i + 1]);
1250             (address token0, ) = GroveLibrary.sortTokens(input, output);
1251             IGrovePair pair = IGrovePair(
1252                 GroveLibrary.pairFor(factory, input, output)
1253             );
1254             uint256 amountInput;
1255             uint256 amountOutput;
1256             {
1257                 // scope to avoid stack too deep errors
1258                 (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
1259                 (uint256 reserveInput, uint256 reserveOutput) = input == token0
1260                     ? (reserve0, reserve1)
1261                     : (reserve1, reserve0);
1262                 amountInput = IERC20(input).balanceOf(address(pair)).sub(
1263                     reserveInput
1264                 );
1265                 amountOutput = GroveLibrary.getAmountOut(
1266                     amountInput,
1267                     reserveInput,
1268                     reserveOutput
1269                 );
1270             }
1271             (uint256 amount0Out, uint256 amount1Out) = input == token0
1272                 ? (uint256(0), amountOutput)
1273                 : (amountOutput, uint256(0));
1274             address to = i < path.length - 2
1275                 ? GroveLibrary.pairFor(factory, output, path[i + 2])
1276                 : _to;
1277             pair.swap(amount0Out, amount1Out, to, new bytes(0));
1278         }
1279     }
1280 
1281     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1282         uint256 amountIn,
1283         uint256 amountOutMin,
1284         address[] calldata path,
1285         address to,
1286         uint256 deadline
1287     ) external virtual override ensure(deadline) {
1288         TransferHelper.safeTransferFrom(
1289             path[0],
1290             msg.sender,
1291             GroveLibrary.pairFor(factory, path[0], path[1]),
1292             amountIn
1293         );
1294         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1295         _swapSupportingFeeOnTransferTokens(path, to);
1296         require(
1297             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >=
1298                 amountOutMin,
1299             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1300         );
1301     }
1302 
1303     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1304         uint256 amountOutMin,
1305         address[] calldata path,
1306         address to,
1307         uint256 deadline
1308     ) external payable virtual override ensure(deadline) {
1309         require(path[0] == WETH, "GroveRouter: INVALID_PATH");
1310         uint256 amountIn = msg.value;
1311         IWETH(WETH).deposit{value: amountIn}();
1312         assert(
1313             IWETH(WETH).transfer(
1314                 GroveLibrary.pairFor(factory, path[0], path[1]),
1315                 amountIn
1316             )
1317         );
1318         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1319         _swapSupportingFeeOnTransferTokens(path, to);
1320         require(
1321             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >=
1322                 amountOutMin,
1323             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1324         );
1325     }
1326 
1327     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1328         uint256 amountIn,
1329         uint256 amountOutMin,
1330         address[] calldata path,
1331         address to,
1332         uint256 deadline
1333     ) external virtual override ensure(deadline) {
1334         require(path[path.length - 1] == WETH, "GroveRouter: INVALID_PATH");
1335         TransferHelper.safeTransferFrom(
1336             path[0],
1337             msg.sender,
1338             GroveLibrary.pairFor(factory, path[0], path[1]),
1339             amountIn
1340         );
1341         _swapSupportingFeeOnTransferTokens(path, address(this));
1342         uint256 amountOut = IERC20(WETH).balanceOf(address(this));
1343         require(
1344             amountOut >= amountOutMin,
1345             "GroveRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1346         );
1347         IWETH(WETH).withdraw(amountOut);
1348         TransferHelper.safeTransferETH(to, amountOut);
1349     }
1350 
1351     // **** LIBRARY FUNCTIONS ****
1352     function quote(
1353         uint256 amountA,
1354         uint256 reserveA,
1355         uint256 reserveB
1356     ) public pure virtual override returns (uint256 amountB) {
1357         return GroveLibrary.quote(amountA, reserveA, reserveB);
1358     }
1359 
1360     function getAmountOut(
1361         uint256 amountIn,
1362         uint256 reserveIn,
1363         uint256 reserveOut
1364     ) public pure virtual override returns (uint256 amountOut) {
1365         return GroveLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
1366     }
1367 
1368     function getAmountIn(
1369         uint256 amountOut,
1370         uint256 reserveIn,
1371         uint256 reserveOut
1372     ) public pure virtual override returns (uint256 amountIn) {
1373         return GroveLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
1374     }
1375 
1376     function getAmountsOut(uint256 amountIn, address[] memory path)
1377         public
1378         view
1379         virtual
1380         override
1381         returns (uint256[] memory amounts)
1382     {
1383         return GroveLibrary.getAmountsOut(factory, amountIn, path);
1384     }
1385 
1386     function getAmountsIn(uint256 amountOut, address[] memory path)
1387         public
1388         view
1389         virtual
1390         override
1391         returns (uint256[] memory amounts)
1392     {
1393         return GroveLibrary.getAmountsIn(factory, amountOut, path);
1394     }
1395 
1396     function excludeFromWhiteList(address token) public onlyOwner {
1397         _isTokenWhiteList[token] = false;
1398     }
1399 
1400     function includeInWhiteList(address token) public onlyOwner {
1401         _isTokenWhiteList[token] = true;
1402     }
1403 
1404     function checkWhiteList(address token) public view returns (bool) {
1405         return _isTokenWhiteList[token];
1406     }
1407 
1408     function withdraw(
1409         address tokenAddr,
1410         address payable to,
1411         uint256 amount
1412     ) external nonReentrant onlyOwner {
1413         require(to != address(0), "invalid recipient");
1414         if (tokenAddr == address(0)) {
1415             (bool success, ) = to.call{value: amount}("");
1416             require(success, "transfer BNB failed");
1417         } else {
1418             IERC20(tokenAddr).transfer(to, amount);
1419         }
1420     }
1421 }