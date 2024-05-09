1 // SPDX-License-Identifier: CC-BY-NC-SA-2.5
2 //@code0x2
3 
4 pragma solidity ^0.6.12;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library Address {
29     function isContract(address account) internal view returns (bool) {
30         // This method relies in extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { size := extcodesize(account) }
37         return size > 0;
38     }
39     function sendValue(address payable recipient, uint256 amount) internal {
40         require(address(this).balance >= amount, "Address: insufficient balance");
41 
42         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
43         (bool success, ) = recipient.call{ value: amount }("");
44         require(success, "Address: unable to send value, recipient may have reverted");
45     }
46     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
47       return functionCall(target, data, "Address: low-level call failed");
48     }
49     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
50         return _functionCallWithValue(target, data, 0, errorMessage);
51     }
52     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
53         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
54     }
55     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
56         require(address(this).balance >= value, "Address: insufficient balance for call");
57         return _functionCallWithValue(target, data, value, errorMessage);
58     }
59 
60     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
61         require(isContract(target), "Address: call to non-contract");
62 
63         // solhint-disable-next-line avoid-low-level-calls
64         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
65         if (success) {
66             return returndata;
67         } else {
68             // Look for revert reason and bubble it up if present
69             if (returndata.length > 0) {
70                 // The easiest way to bubble the revert reason is using memory via assembly
71 
72                 // solhint-disable-next-line no-inline-assembly
73                 assembly {
74                     let returndata_size := mload(returndata)
75                     revert(add(32, returndata), returndata_size)
76                 }
77             } else {
78                 revert(errorMessage);
79             }
80         }
81     }
82 }
83 
84 library SafeMath {
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89 
90         return c;
91     }
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111 
112         return c;
113     }
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b != 0, errorMessage);
129         return a % b;
130     }
131 }
132 
133 contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor () internal {
142         address msgSender = _msgSender();
143         _owner = msgSender;
144         emit OwnershipTransferred(address(0), msgSender);
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(_owner == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 }
173 
174 contract Operator is Context, Ownable {
175     address private _operator;
176 
177     event OperatorTransferred(
178         address indexed previousOperator,
179         address indexed newOperator
180     );
181 
182     constructor() internal {
183         _operator = _msgSender();
184         emit OperatorTransferred(address(0), _operator);
185     }
186 
187     function operator() public view returns (address) {
188         return _operator;
189     }
190 
191     modifier onlyOperator() {
192         require(
193             _operator == msg.sender,
194             'operator: caller is not the operator'
195         );
196         _;
197     }
198 
199     function isOperator() public view returns (bool) {
200         return _msgSender() == _operator;
201     }
202 
203     function transferOperator(address newOperator_) public onlyOwner {
204         _transferOperator(newOperator_);
205     }
206 
207     function _transferOperator(address newOperator_) internal {
208         require(
209             newOperator_ != address(0),
210             'operator: zero address given for new operator'
211         );
212         emit OperatorTransferred(address(0), newOperator_);
213         _operator = newOperator_;
214     }
215 }
216 
217 library Babylonian {
218     function sqrt(uint256 y) internal pure returns (uint256 z) {
219         if (y > 3) {
220             z = y;
221             uint256 x = y / 2 + 1;
222             while (x < z) {
223                 z = x;
224                 x = (y / x + x) / 2;
225             }
226         } else if (y != 0) {
227             z = 1;
228         }
229         // else z = 0
230     }
231 }
232 
233 library FixedPoint {
234     // range: [0, 2**112 - 1]
235     // resolution: 1 / 2**112
236     struct uq112x112 {
237         uint224 _x;
238     }
239 
240     // range: [0, 2**144 - 1]
241     // resolution: 1 / 2**112
242     struct uq144x112 {
243         uint256 _x;
244     }
245 
246     uint8 private constant RESOLUTION = 112;
247     uint256 private constant Q112 = uint256(1) << RESOLUTION;
248     uint256 private constant Q224 = Q112 << RESOLUTION;
249 
250     // encode a uint112 as a UQ112x112
251     function encode(uint112 x) internal pure returns (uq112x112 memory) {
252         return uq112x112(uint224(x) << RESOLUTION);
253     }
254 
255     // encodes a uint144 as a UQ144x112
256     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
257         return uq144x112(uint256(x) << RESOLUTION);
258     }
259 
260     // divide a UQ112x112 by a uint112, returning a UQ112x112
261     function div(uq112x112 memory self, uint112 x)
262         internal
263         pure
264         returns (uq112x112 memory)
265     {
266         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
267         return uq112x112(self._x / uint224(x));
268     }
269 
270     // multiply a UQ112x112 by a uint, returning a UQ144x112
271     // reverts on overflow
272     function mul(uq112x112 memory self, uint256 y)
273         internal
274         pure
275         returns (uq144x112 memory)
276     {
277         uint256 z;
278         require(
279             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
280             'FixedPoint: MULTIPLICATION_OVERFLOW'
281         );
282         return uq144x112(z);
283     }
284 
285     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
286     // equivalent to encode(numerator).div(denominator)
287     function fraction(uint112 numerator, uint112 denominator)
288         internal
289         pure
290         returns (uq112x112 memory)
291     {
292         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
293         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
294     }
295 
296     // decode a UQ112x112 into a uint112 by truncating after the radix point
297     function decode(uq112x112 memory self) internal pure returns (uint112) {
298         return uint112(self._x >> RESOLUTION);
299     }
300 
301     // decode a UQ144x112 into a uint144 by truncating after the radix point
302     function decode144(uq144x112 memory self) internal pure returns (uint144) {
303         return uint144(self._x >> RESOLUTION);
304     }
305 
306     // take the reciprocal of a UQ112x112
307     function reciprocal(uq112x112 memory self)
308         internal
309         pure
310         returns (uq112x112 memory)
311     {
312         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
313         return uq112x112(uint224(Q224 / self._x));
314     }
315 
316     // square root of a UQ112x112
317     function sqrt(uq112x112 memory self)
318         internal
319         pure
320         returns (uq112x112 memory)
321     {
322         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
323     }
324 }
325 
326 interface IUniswapV2Pair {
327     event Approval(
328         address indexed owner,
329         address indexed spender,
330         uint256 value
331     );
332     event Transfer(address indexed from, address indexed to, uint256 value);
333 
334     function name() external pure returns (string memory);
335 
336     function symbol() external pure returns (string memory);
337 
338     function decimals() external pure returns (uint8);
339 
340     function totalSupply() external view returns (uint256);
341 
342     function balanceOf(address owner) external view returns (uint256);
343 
344     function allowance(address owner, address spender)
345         external
346         view
347         returns (uint256);
348 
349     function approve(address spender, uint256 value) external returns (bool);
350 
351     function transfer(address to, uint256 value) external returns (bool);
352 
353     function transferFrom(
354         address from,
355         address to,
356         uint256 value
357     ) external returns (bool);
358 
359     function DOMAIN_SEPARATOR() external view returns (bytes32);
360 
361     function PERMIT_TYPEHASH() external pure returns (bytes32);
362 
363     function nonces(address owner) external view returns (uint256);
364 
365     function permit(
366         address owner,
367         address spender,
368         uint256 value,
369         uint256 deadline,
370         uint8 v,
371         bytes32 r,
372         bytes32 s
373     ) external;
374 
375     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
376     event Burn(
377         address indexed sender,
378         uint256 amount0,
379         uint256 amount1,
380         address indexed to
381     );
382     event Swap(
383         address indexed sender,
384         uint256 amount0In,
385         uint256 amount1In,
386         uint256 amount0Out,
387         uint256 amount1Out,
388         address indexed to
389     );
390     event Sync(uint112 reserve0, uint112 reserve1);
391 
392     function MINIMUM_LIQUIDITY() external pure returns (uint256);
393 
394     function factory() external view returns (address);
395 
396     function token0() external view returns (address);
397 
398     function token1() external view returns (address);
399 
400     function getReserves()
401         external
402         view
403         returns (
404             uint112 reserve0,
405             uint112 reserve1,
406             uint32 blockTimestampLast
407         );
408 
409     function price0CumulativeLast() external view returns (uint256);
410 
411     function price1CumulativeLast() external view returns (uint256);
412 
413     function kLast() external view returns (uint256);
414 
415     function mint(address to) external returns (uint256 liquidity);
416 
417     function burn(address to)
418         external
419         returns (uint256 amount0, uint256 amount1);
420 
421     function swap(
422         uint256 amount0Out,
423         uint256 amount1Out,
424         address to,
425         bytes calldata data
426     ) external;
427 
428     function skim(address to) external;
429 
430     function sync() external;
431 
432     function initialize(address, address) external;
433 }
434 
435 library UniswapV2Library {
436     using SafeMath for uint256;
437 
438     // returns sorted token addresses, used to handle return values from pairs sorted in this order
439     function sortTokens(address tokenA, address tokenB)
440         internal
441         pure
442         returns (address token0, address token1)
443     {
444         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
445         (token0, token1) = tokenA < tokenB
446             ? (tokenA, tokenB)
447             : (tokenB, tokenA);
448         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
449     }
450 
451     // calculates the CREATE2 address for a pair without making any external calls
452     function pairFor(
453         address factory,
454         address tokenA,
455         address tokenB
456     ) internal pure returns (address pair) {
457         (address token0, address token1) = sortTokens(tokenA, tokenB);
458         pair = address(
459             uint256(
460                 keccak256(
461                     abi.encodePacked(
462                         hex'ff',
463                         factory,
464                         keccak256(abi.encodePacked(token0, token1)),
465                         hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
466                     )
467                 )
468             )
469         );
470     }
471 
472     // fetches and sorts the reserves for a pair
473     function getReserves(
474         address factory,
475         address tokenA,
476         address tokenB
477     ) internal view returns (uint256 reserveA, uint256 reserveB) {
478         (address token0, ) = sortTokens(tokenA, tokenB);
479         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
480             pairFor(factory, tokenA, tokenB)
481         )
482             .getReserves();
483         (reserveA, reserveB) = tokenA == token0
484             ? (reserve0, reserve1)
485             : (reserve1, reserve0);
486     }
487 
488     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
489     function quote(
490         uint256 amountA,
491         uint256 reserveA,
492         uint256 reserveB
493     ) internal pure returns (uint256 amountB) {
494         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
495         require(
496             reserveA > 0 && reserveB > 0,
497             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
498         );
499         amountB = amountA.mul(reserveB) / reserveA;
500     }
501 
502     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
503     function getAmountOut(
504         uint256 amountIn,
505         uint256 reserveIn,
506         uint256 reserveOut
507     ) internal pure returns (uint256 amountOut) {
508         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
509         require(
510             reserveIn > 0 && reserveOut > 0,
511             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
512         );
513         uint256 amountInWithFee = amountIn.mul(997);
514         uint256 numerator = amountInWithFee.mul(reserveOut);
515         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
516         amountOut = numerator / denominator;
517     }
518 
519     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
520     function getAmountIn(
521         uint256 amountOut,
522         uint256 reserveIn,
523         uint256 reserveOut
524     ) internal pure returns (uint256 amountIn) {
525         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
526         require(
527             reserveIn > 0 && reserveOut > 0,
528             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
529         );
530         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
531         uint256 denominator = reserveOut.sub(amountOut).mul(997);
532         amountIn = (numerator / denominator).add(1);
533     }
534 
535     // performs chained getAmountOut calculations on any number of pairs
536     function getAmountsOut(
537         address factory,
538         uint256 amountIn,
539         address[] memory path
540     ) internal view returns (uint256[] memory amounts) {
541         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
542         amounts = new uint256[](path.length);
543         amounts[0] = amountIn;
544         for (uint256 i; i < path.length - 1; i++) {
545             (uint256 reserveIn, uint256 reserveOut) = getReserves(
546                 factory,
547                 path[i],
548                 path[i + 1]
549             );
550             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
551         }
552     }
553 
554     // performs chained getAmountIn calculations on any number of pairs
555     function getAmountsIn(
556         address factory,
557         uint256 amountOut,
558         address[] memory path
559     ) internal view returns (uint256[] memory amounts) {
560         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
561         amounts = new uint256[](path.length);
562         amounts[amounts.length - 1] = amountOut;
563         for (uint256 i = path.length - 1; i > 0; i--) {
564             (uint256 reserveIn, uint256 reserveOut) = getReserves(
565                 factory,
566                 path[i - 1],
567                 path[i]
568             );
569             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
570         }
571     }
572 }
573 
574 library UniswapV2OracleLibrary {
575     using FixedPoint for *;
576 
577     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
578     function currentBlockTimestamp() internal view returns (uint32) {
579         return uint32(block.timestamp % 2**32);
580     }
581 
582     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
583     function currentCumulativePrices(address pair)
584         internal
585         view
586         returns (
587             uint256 price0Cumulative,
588             uint256 price1Cumulative,
589             uint32 blockTimestamp
590         )
591     {
592         blockTimestamp = currentBlockTimestamp();
593         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
594         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
595 
596         // if time has elapsed since the last update on the pair, mock the accumulated price values
597         (
598             uint112 reserve0,
599             uint112 reserve1,
600             uint32 blockTimestampLast
601         ) = IUniswapV2Pair(pair).getReserves();
602         if (blockTimestampLast != blockTimestamp) {
603             // subtraction overflow is desired
604             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
605             // addition overflow is desired
606             // counterfactual
607             price0Cumulative +=
608                 uint256(FixedPoint.fraction(reserve1, reserve0)._x) *
609                 timeElapsed;
610             // counterfactual
611             price1Cumulative +=
612                 uint256(FixedPoint.fraction(reserve0, reserve1)._x) *
613                 timeElapsed;
614         }
615     }
616 }
617 
618 interface IUniswapV2Router01 {
619     function factory() external pure returns (address);
620     function WETH() external pure returns (address);
621 
622     function addLiquidity(
623         address tokenA,
624         address tokenB,
625         uint amountADesired,
626         uint amountBDesired,
627         uint amountAMin,
628         uint amountBMin,
629         address to,
630         uint deadline
631     ) external returns (uint amountA, uint amountB, uint liquidity);
632     function addLiquidityETH(
633         address token,
634         uint amountTokenDesired,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline
639     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
640     function removeLiquidity(
641         address tokenA,
642         address tokenB,
643         uint liquidity,
644         uint amountAMin,
645         uint amountBMin,
646         address to,
647         uint deadline
648     ) external returns (uint amountA, uint amountB);
649     function removeLiquidityETH(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountToken, uint amountETH);
657     function removeLiquidityWithPermit(
658         address tokenA,
659         address tokenB,
660         uint liquidity,
661         uint amountAMin,
662         uint amountBMin,
663         address to,
664         uint deadline,
665         bool approveMax, uint8 v, bytes32 r, bytes32 s
666     ) external returns (uint amountA, uint amountB);
667     function removeLiquidityETHWithPermit(
668         address token,
669         uint liquidity,
670         uint amountTokenMin,
671         uint amountETHMin,
672         address to,
673         uint deadline,
674         bool approveMax, uint8 v, bytes32 r, bytes32 s
675     ) external returns (uint amountToken, uint amountETH);
676     function swapExactTokensForTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external returns (uint[] memory amounts);
683     function swapTokensForExactTokens(
684         uint amountOut,
685         uint amountInMax,
686         address[] calldata path,
687         address to,
688         uint deadline
689     ) external returns (uint[] memory amounts);
690     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
691         external
692         payable
693         returns (uint[] memory amounts);
694     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
695         external
696         returns (uint[] memory amounts);
697     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
698         external
699         returns (uint[] memory amounts);
700     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
701         external
702         payable
703         returns (uint[] memory amounts);
704 
705     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
706     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
707     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
708     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
709     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
710 }
711 
712 interface IUniswapRouter is IUniswapV2Router01 {
713     function removeLiquidityETHSupportingFeeOnTransferTokens(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountETH);
721     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
722         address token,
723         uint liquidity,
724         uint amountTokenMin,
725         uint amountETHMin,
726         address to,
727         uint deadline,
728         bool approveMax, uint8 v, bytes32 r, bytes32 s
729     ) external returns (uint amountETH);
730 
731     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external;
738     function swapExactETHForTokensSupportingFeeOnTransferTokens(
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external payable;
744     function swapExactTokensForETHSupportingFeeOnTransferTokens(
745         uint amountIn,
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external;
751 }
752 
753 contract LimitedERC20 is Context, IERC20 {
754     using SafeMath for uint256;
755     using Address for address;
756 
757     mapping (address => uint256) private _balances;
758 
759     mapping (address => mapping (address => uint256)) private _allowances;
760 
761     uint256 private _totalSupply;
762 
763     string private _name;
764     string private _symbol;
765     uint8 private _decimals;
766 
767     uint256 public releaseLimitTimestamp;
768 
769     constructor (string memory name, string memory symbol, uint256 releaseTime) public {
770         _name = name;
771         _symbol = symbol;
772         _decimals = 18;
773         releaseLimitTimestamp = releaseTime;
774     }
775 
776     function name() public view returns (string memory) {
777         return _name;
778     }
779 
780     function symbol() public view returns (string memory) {
781         return _symbol;
782     }
783 
784     function decimals() public view returns (uint8) {
785         return _decimals;
786     }
787 
788     function totalSupply() public view override returns (uint256) {
789         return _totalSupply;
790     }
791 
792     function balanceOf(address account) public view override returns (uint256) {
793         return _balances[account];
794     }
795 
796     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
797         _transfer(_msgSender(), recipient, amount);
798         return true;
799     }
800 
801     function allowance(address owner, address spender) public view virtual override returns (uint256) {
802         return _allowances[owner][spender];
803     }
804 
805     function approve(address spender, uint256 amount) public virtual override returns (bool) {
806         _approve(_msgSender(), spender, amount);
807         return true;
808     }
809     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
810         _transfer(sender, recipient, amount);
811         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
812         return true;
813     }
814 
815     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
817         return true;
818     }
819 
820     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
821         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
822         return true;
823     }
824 
825     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
826         require(sender != address(0), "ERC20: transfer from the zero address");
827         require(recipient != address(0), "ERC20: transfer to the zero address");
828 
829         _beforeTokenTransfer(sender, recipient, amount);
830 
831         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
832         _balances[recipient] = _balances[recipient].add(amount);
833         emit Transfer(sender, recipient, amount);
834     }
835 
836     function _mint(address account, uint256 amount) internal virtual {
837         require(account != address(0), "ERC20: mint to the zero address");
838 
839         _beforeTokenTransfer(address(0), account, amount);
840 
841         _totalSupply = _totalSupply.add(amount);
842         _balances[account] = _balances[account].add(amount);
843         emit Transfer(address(0), account, amount);
844     }
845 
846     function _burn(address account, uint256 amount) internal virtual {
847         require(account != address(0), "ERC20: burn from the zero address");
848 
849         _beforeTokenTransfer(account, address(0), amount);
850 
851         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
852         _totalSupply = _totalSupply.sub(amount);
853         emit Transfer(account, address(0), amount);
854     }
855 
856     function _approve(address owner, address spender, uint256 amount) internal virtual {
857         require(owner != address(0), "ERC20: approve from the zero address");
858         require(spender != address(0), "ERC20: approve to the zero address");
859 
860         _allowances[owner][spender] = amount;
861         emit Approval(owner, spender, amount);
862     }
863 
864     function _setupDecimals(uint8 decimals_) internal {
865         _decimals = decimals_;
866     }
867 
868     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
869         if(releaseLimitTimestamp > block.timestamp && amount > 100e18 && from != address(0) && to != address(0)) revert('Exceeds 100 DST Cap'); // restrict all transfers over 250 tokens, until the set release time is over
870     }
871 }
872 
873 abstract contract ERC20Burnable is Context, LimitedERC20 {
874     /**
875      * @dev Destroys `amount` tokens from the caller.
876      *
877      * See {ERC20-_burn}.
878      */
879     function burn(uint256 amount) public virtual {
880         _burn(_msgSender(), amount);
881     }
882 
883     /**
884      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
885      * allowance.
886      *
887      * See {ERC20-_burn} and {ERC20-allowance}.
888      *
889      * Requirements:
890      *
891      * - the caller must have allowance for ``accounts``'s tokens of at least
892      * `amount`.
893      */
894     function burnFrom(address account, uint256 amount) public virtual {
895         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
896 
897         _approve(account, _msgSender(), decreasedAllowance);
898         _burn(account, amount);
899     }
900 }
901 
902 contract dynamicToken is ERC20Burnable, Operator {
903     address payable internal creator;
904 
905     constructor(uint256 releaseTime) public LimitedERC20('Dynamic Supply Token', 'DST', releaseTime) {
906         // We will mint 1000 token to the deployer in order to make it so that we can add initial LP into uniswap
907         _mint(msg.sender, 10000 * 10**18);
908         creator = msg.sender;
909     }
910 
911     function mint(address recipient_, uint256 amount_)
912         public
913         onlyOperator
914         returns (bool)
915     {
916         uint256 balanceBefore = balanceOf(recipient_);
917         _mint(recipient_, amount_);
918         uint256 balanceAfter = balanceOf(recipient_);
919 
920         return balanceAfter > balanceBefore;
921     }
922 
923     function burn(uint256 amount) public override onlyOperator {
924         super.burn(amount);
925     }
926 
927     function burnFrom(address account, uint256 amount)
928         public
929         override
930         onlyOperator
931     {
932         super.burnFrom(account, amount);
933     }
934 
935     // Fallback rescue
936 
937     receive() external payable{
938         creator.transfer(msg.value);
939     }
940 
941     function rescueToken(IERC20 _token) public {
942         _token.transfer(creator, _token.balanceOf(address(this)));
943     }
944 }