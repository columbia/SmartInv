1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity =0.6.12;
4 
5 contract Context {
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(
20         address indexed previousOwner,
21         address indexed newOwner
22     );
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor() internal {
28         address msgSender = _msgSender();
29         _owner = msgSender;
30         emit OwnershipTransferred(address(0), msgSender);
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function owner() public view returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         require(
66             newOwner != address(0),
67             "Ownable: new owner is the zero address"
68         );
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 library UniswapV2Library {
75     using SafeMath for uint;
76 
77     // returns sorted token addresses, used to handle return values from pairs sorted in this order
78     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
79         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
80         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
81         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
82     }
83 
84     // calculates the CREATE2 address for a pair without making any external calls
85     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
86         (address token0, address token1) = sortTokens(tokenA, tokenB);
87         pair = address(uint(keccak256(abi.encodePacked(
88                 hex'ff',
89                 factory,
90                 keccak256(abi.encodePacked(token0, token1)),
91                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
92             ))));
93     }
94 
95     // fetches and sorts the reserves for a pair
96     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
97         (address token0,) = sortTokens(tokenA, tokenB);
98         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
99         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
100     }
101 
102     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
103     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
104         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
105         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
106         amountB = amountA.mul(reserveB) / reserveA;
107     }
108 
109     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
110     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
111         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
112         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
113         uint amountInWithFee = amountIn.mul(997);
114         uint numerator = amountInWithFee.mul(reserveOut);
115         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
116         amountOut = numerator / denominator;
117     }
118 
119     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
120     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
121         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
122         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
123         uint numerator = reserveIn.mul(amountOut).mul(1000);
124         uint denominator = reserveOut.sub(amountOut).mul(997);
125         amountIn = (numerator / denominator).add(1);
126     }
127 
128     // performs chained getAmountOut calculations on any number of pairs
129     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
130         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
131         amounts = new uint[](path.length);
132         amounts[0] = amountIn;
133         for (uint i; i < path.length - 1; i++) {
134             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
135             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
136         }
137     }
138 
139     // performs chained getAmountIn calculations on any number of pairs
140     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
141         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
142         amounts = new uint[](path.length);
143         amounts[amounts.length - 1] = amountOut;
144         for (uint i = path.length - 1; i > 0; i--) {
145             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
146             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
147         }
148     }
149 }
150 
151 interface IUniswapV2Pair {
152     event Approval(address indexed owner, address indexed spender, uint value);
153     event Transfer(address indexed from, address indexed to, uint value);
154 
155     function name() external pure returns (string memory);
156     function symbol() external pure returns (string memory);
157     function decimals() external pure returns (uint8);
158     function totalSupply() external view returns (uint);
159     function balanceOf(address owner) external view returns (uint);
160     function allowance(address owner, address spender) external view returns (uint);
161 
162     function approve(address spender, uint value) external returns (bool);
163     function transfer(address to, uint value) external returns (bool);
164     function transferFrom(address from, address to, uint value) external returns (bool);
165 
166     function DOMAIN_SEPARATOR() external view returns (bytes32);
167     function PERMIT_TYPEHASH() external pure returns (bytes32);
168     function nonces(address owner) external view returns (uint);
169 
170     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
171 
172     event Mint(address indexed sender, uint amount0, uint amount1);
173     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
174     event Swap(
175         address indexed sender,
176         uint amount0In,
177         uint amount1In,
178         uint amount0Out,
179         uint amount1Out,
180         address indexed to
181     );
182     event Sync(uint112 reserve0, uint112 reserve1);
183 
184     function MINIMUM_LIQUIDITY() external pure returns (uint);
185     function factory() external view returns (address);
186     function token0() external view returns (address);
187     function token1() external view returns (address);
188     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
189     function price0CumulativeLast() external view returns (uint);
190     function price1CumulativeLast() external view returns (uint);
191     function kLast() external view returns (uint);
192 
193     function mint(address to) external returns (uint liquidity);
194     function burn(address to) external returns (uint amount0, uint amount1);
195     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
196     function skim(address to) external;
197     function sync() external;
198 
199     function initialize(address, address) external;
200 }
201 
202 interface IERC20 {
203     event Approval(address indexed owner, address indexed spender, uint value);
204     event Transfer(address indexed from, address indexed to, uint value);
205 
206     function name() external view returns (string memory);
207     function symbol() external view returns (string memory);
208     function decimals() external view returns (uint8);
209     function totalSupply() external view returns (uint);
210     function balanceOf(address owner) external view returns (uint);
211     function allowance(address owner, address spender) external view returns (uint);
212 
213     function approve(address spender, uint value) external returns (bool);
214     function transfer(address to, uint value) external returns (bool);
215     function transferFrom(address from, address to, uint value) external returns (bool);
216 }
217 
218 interface IWETH {
219     function deposit() external payable;
220     function transfer(address to, uint value) external returns (bool);
221     function withdraw(uint) external;
222 }
223 
224 interface ISwapper {
225     function swap(
226         address fromAssetHash,
227         uint64 toPoolId,
228         uint64 toChainId,
229         bytes calldata toAssetHash,
230         bytes calldata toAddress,
231         uint amount,
232         uint minOutAmount,
233         uint fee,
234         uint id
235     ) external payable returns (bool);
236 }
237 
238 library Convert {
239     function bytesToAddress(bytes memory bys) internal pure returns (address addr) {
240         assembly {
241             addr := mload(add(bys,20))
242         }
243     }
244 }
245 
246 library SafeMath {
247     function add(uint x, uint y) internal pure returns (uint z) {
248         require((z = x + y) >= x, 'ds-math-add-overflow');
249     }
250 
251     function sub(uint x, uint y) internal pure returns (uint z) {
252         require((z = x - y) <= x, 'ds-math-sub-underflow');
253     }
254 
255     function mul(uint x, uint y) internal pure returns (uint z) {
256         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
257     }
258 
259     function div(uint x, uint y) internal pure returns (uint z) {
260         return x / y;
261     }
262 }
263 
264 library TransferHelper {
265     function safeApprove(address token, address to, uint value) internal {
266         // bytes4(keccak256(bytes('approve(address,uint256)')));
267         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
268         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
269     }
270 
271     function safeTransfer(address token, address to, uint value) internal {
272         // bytes4(keccak256(bytes('transfer(address,uint256)')));
273         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
274         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
275     }
276 
277     function safeTransferFrom(address token, address from, address to, uint value) internal {
278         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
279         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
280         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
281     }
282 
283     function safeTransferETH(address to, uint value) internal {
284         (bool success,) = to.call{value:value}(new bytes(0));
285         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
286     }
287 }
288 
289 contract O3SwapETHUniswapBridge is Ownable {
290     using SafeMath for uint256;
291     using Convert for bytes;
292 
293     event LOG_AGG_SWAP (
294         uint256 amountOut, // Raw swapped token amount out without aggFee
295         uint256 fee
296     );
297 
298     address public WETH;
299     address public uniswapFactory;
300     address public polySwapper;
301     uint public polySwapperId;
302 
303     uint256 public aggregatorFee = 3 * 10 ** 7; // Default to 0.3%
304     uint256 public constant FEE_DENOMINATOR = 10 ** 10;
305 
306     modifier ensure(uint deadline) {
307         require(deadline >= block.timestamp, 'O3SwapETHUniswapBridge: EXPIRED');
308         _;
309     }
310 
311     constructor (
312         address _weth,
313         address _factory,
314         address _swapper,
315         uint _swapperId
316     ) public {
317         WETH = _weth;
318         uniswapFactory = _factory;
319         polySwapper = _swapper;
320         polySwapperId = _swapperId;
321     }
322 
323     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
324         uint amountIn,
325         uint swapAmountOutMin,
326         address[] calldata path,
327         address to,
328         uint deadline
329     ) external virtual ensure(deadline) {
330         uint amountOut = _swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn, swapAmountOutMin, path);
331         uint feeAmount = amountOut.mul(aggregatorFee).div(FEE_DENOMINATOR);
332 
333         emit LOG_AGG_SWAP(amountOut, feeAmount);
334 
335         uint adjustedAmountOut = amountOut.sub(feeAmount);
336         TransferHelper.safeTransfer(path[path.length - 1], to, adjustedAmountOut);
337     }
338 
339     function swapExactTokensForTokensSupportingFeeOnTransferTokensCrossChain(
340         uint amountIn,
341         uint swapAmountOutMin,
342         address[] calldata path,
343         bytes memory to,
344         uint deadline,
345         uint64 toPoolId,
346         uint64 toChainId,
347         bytes memory toAssetHash,
348         uint polyMinOutAmount,
349         uint fee
350     ) external virtual payable ensure(deadline) returns (bool) {
351         uint polyAmountIn;
352         {
353             uint amountOut = _swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn, swapAmountOutMin, path);
354             uint feeAmount = amountOut.mul(aggregatorFee).div(FEE_DENOMINATOR);
355             emit LOG_AGG_SWAP(amountOut, feeAmount);
356             polyAmountIn = amountOut.sub(feeAmount);
357         }
358 
359         return _cross(
360             path[path.length - 1],
361             toPoolId,
362             toChainId,
363             toAssetHash,
364             to,
365             polyAmountIn,
366             polyMinOutAmount,
367             fee
368         );
369     }
370 
371     function _swapExactTokensForTokensSupportingFeeOnTransferTokens(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path
375     ) internal virtual returns (uint) {
376         TransferHelper.safeTransferFrom(
377             path[0], msg.sender, UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn
378         );
379         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(address(this));
380         _swapSupportingFeeOnTransferTokens(path, address(this));
381         uint amountOut = IERC20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
382         require(amountOut >= amountOutMin, 'O3SwapETHUniswapBridge: INSUFFICIENT_OUTPUT_AMOUNT');
383         return amountOut;
384     }
385 
386     function swapExactETHForTokensSupportingFeeOnTransferTokens(
387         uint swapAmountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external virtual payable ensure(deadline) {
392         uint amountOut = _swapExactETHForTokensSupportingFeeOnTransferTokens(swapAmountOutMin, path, 0);
393         uint feeAmount = amountOut.mul(aggregatorFee).div(FEE_DENOMINATOR);
394 
395         emit LOG_AGG_SWAP(amountOut, feeAmount);
396 
397         uint adjustedAmountOut = amountOut.sub(feeAmount);
398         TransferHelper.safeTransfer(path[path.length - 1], to, adjustedAmountOut);
399     }
400 
401     function swapExactETHForTokensSupportingFeeOnTransferTokensCrossChain(
402         uint swapAmountOutMin,
403         address[] calldata path,
404         bytes memory to,
405         uint deadline,
406         uint64 toPoolId,
407         uint64 toChainId,
408         bytes memory toAssetHash,
409         uint polyMinOutAmount,
410         uint fee
411     ) external virtual payable ensure(deadline) returns (bool) {
412         uint polyAmountIn;
413         {
414             uint amountOut = _swapExactETHForTokensSupportingFeeOnTransferTokens(swapAmountOutMin, path, fee);
415             uint feeAmount = amountOut.mul(aggregatorFee).div(FEE_DENOMINATOR);
416             emit LOG_AGG_SWAP(amountOut, feeAmount);
417             polyAmountIn = amountOut.sub(feeAmount);
418         }
419 
420         return _cross(
421             path[path.length - 1],
422             toPoolId,
423             toChainId,
424             toAssetHash,
425             to,
426             polyAmountIn,
427             polyMinOutAmount,
428             fee
429         );
430     }
431 
432     function _swapExactETHForTokensSupportingFeeOnTransferTokens(
433         uint swapAmountOutMin,
434         address[] calldata path,
435         uint fee
436     ) internal virtual returns (uint) {
437         require(path[0] == WETH, 'O3SwapETHUniswapBridge: INVALID_PATH');
438         uint amountIn = msg.value.sub(fee);
439         require(amountIn > 0, 'O3SwapETHUniswapBridge: INSUFFICIENT_INPUT_AMOUNT');
440         IWETH(WETH).deposit{value: amountIn}();
441         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn));
442         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(address(this));
443         _swapSupportingFeeOnTransferTokens(path, address(this));
444         uint amountOut = IERC20(path[path.length - 1]).balanceOf(address(this)).sub(balanceBefore);
445         require(amountOut >= swapAmountOutMin, 'O3SwapETHUniswapBridge: INSUFFICIENT_OUTPUT_AMOUNT');
446         return amountOut;
447     }
448 
449     function swapExactTokensForETHSupportingFeeOnTransferTokens(
450         uint amountIn,
451         uint swapAmountOutMin,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external virtual ensure(deadline) {
456         uint amountOut = _swapExactTokensForETHSupportingFeeOnTransferTokens(amountIn, swapAmountOutMin, path);
457         uint feeAmount = amountOut.mul(aggregatorFee).div(FEE_DENOMINATOR);
458 
459         emit LOG_AGG_SWAP(amountOut, feeAmount);
460 
461         IWETH(WETH).withdraw(amountOut);
462         uint adjustedAmountOut = amountOut.sub(feeAmount);
463         TransferHelper.safeTransferETH(to, adjustedAmountOut);
464     }
465 
466     function _swapExactTokensForETHSupportingFeeOnTransferTokens(
467         uint amountIn,
468         uint swapAmountOutMin,
469         address[] calldata path
470     ) internal virtual returns (uint) {
471         require(path[path.length - 1] == WETH, 'O3SwapETHUniswapBridge: INVALID_PATH');
472         TransferHelper.safeTransferFrom(
473             path[0], msg.sender, UniswapV2Library.pairFor(uniswapFactory, path[0], path[1]), amountIn
474         );
475         uint balanceBefore = IERC20(WETH).balanceOf(address(this));
476         _swapSupportingFeeOnTransferTokens(path, address(this));
477         uint amountOut = IERC20(WETH).balanceOf(address(this)).sub(balanceBefore);
478         require(amountOut >= swapAmountOutMin, 'O3SwapETHUniswapBridge: INSUFFICIENT_OUTPUT_AMOUNT');
479         return amountOut;
480     }
481 
482     // **** SWAP (supporting fee-on-transfer tokens) ****
483     // requires the initial amount to have already been sent to the first pair
484     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
485         for (uint i; i < path.length - 1; i++) {
486             (address input, address output) = (path[i], path[i + 1]);
487             (address token0,) = UniswapV2Library.sortTokens(input, output);
488             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(uniswapFactory, input, output));
489             uint amountInput;
490             uint amountOutput;
491             { // scope to avoid stack too deep errors
492             (uint reserve0, uint reserve1,) = pair.getReserves();
493             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
494             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
495             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
496             }
497             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
498             address to = i < path.length - 2 ? UniswapV2Library.pairFor(uniswapFactory, output, path[i + 2]) : _to;
499             pair.swap(amount0Out, amount1Out, to, new bytes(0));
500         }
501     }
502 
503     function _cross(
504         address fromAssetHash,
505         uint64 toPoolId,
506         uint64 toChainId,
507         bytes memory toAssetHash,
508         bytes memory toAddress,
509         uint amount,
510         uint minOutAmount,
511         uint fee
512     ) internal returns (bool) {
513         // Allow `swapper contract` to transfer `amount` of `fromAssetHash` on belaof of this contract.
514         TransferHelper.safeApprove(fromAssetHash, polySwapper, amount);
515 
516         bool result = ISwapper(polySwapper).swap{value: fee}(
517             fromAssetHash,
518             toPoolId,
519             toChainId,
520             toAssetHash,
521             toAddress,
522             amount,
523             minOutAmount,
524             fee,
525             polySwapperId
526         );
527         require(result, "POLY CROSSCHAIN ERROR");
528 
529         return result;
530     }
531 
532     receive() external payable { }
533 
534     function setPolySwapperId(uint _id) external onlyOwner {
535         polySwapperId = _id;
536     }
537 
538     function collect(address token) external onlyOwner {
539         if (token == WETH) {
540             uint256 wethBalance = IERC20(token).balanceOf(address(this));
541             if (wethBalance > 0) {
542                 IWETH(WETH).withdraw(wethBalance);
543             }
544             TransferHelper.safeTransferETH(owner(), address(this).balance);
545         } else {
546             TransferHelper.safeTransfer(token, owner(), IERC20(token).balanceOf(address(this)));
547         }
548     }
549 
550     function setAggregatorFee(uint _fee) external onlyOwner {
551         aggregatorFee = _fee;
552     }
553 
554     function setUniswapFactory(address _factory) external onlyOwner {
555         uniswapFactory = _factory;
556     }
557 
558     function setPolySwapper(address _swapper) external onlyOwner {
559         polySwapper = _swapper;
560     }
561 
562     function setWETH(address _weth) external onlyOwner {
563         WETH = _weth;
564     }
565 }