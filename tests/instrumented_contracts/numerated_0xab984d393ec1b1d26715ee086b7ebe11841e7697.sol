1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 // TransferHelper Library
7 library TransferHelper {
8     function safeApprove(address token, address to, uint value) internal {
9         // bytes4(keccak256(bytes('approve(address,uint256)')));
10         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
11         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
12     }
13 
14     function safeTransfer(address token, address to, uint value) internal {
15         // bytes4(keccak256(bytes('transfer(address,uint256)')));
16         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
17         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
18     }
19 
20     function safeTransferFrom(address token, address from, address to, uint value) internal {
21         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
22         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
23         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
24     }
25 
26     function safeTransferETH(address to, uint value) internal {
27         (bool success,) = to.call{value:value}(new bytes(0));
28         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
29     }
30 }
31 
32 // Safemath Library
33 library SafeMath {
34     function add(uint x, uint y) internal pure returns (uint z) {
35         require((z = x + y) >= x, 'ds-math-add-overflow');
36     }
37 
38     function sub(uint x, uint y) internal pure returns (uint z) {
39         require((z = x - y) <= x, 'ds-math-sub-underflow');
40     }
41 
42     function mul(uint x, uint y) internal pure returns (uint z) {
43         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
44     }
45 }
46 
47 // DEXLibrary Library
48 interface IDEXPair {
49     event Approval(address indexed owner, address indexed spender, uint value);
50     event Transfer(address indexed from, address indexed to, uint value);
51 
52     function name() external pure returns (string memory);
53     function symbol() external pure returns (string memory);
54     function decimals() external pure returns (uint8);
55     function totalSupply() external view returns (uint);
56     function balanceOf(address owner) external view returns (uint);
57     function allowance(address owner, address spender) external view returns (uint);
58 
59     function approve(address spender, uint value) external returns (bool);
60     function transfer(address to, uint value) external returns (bool);
61     function transferFrom(address from, address to, uint value) external returns (bool);
62 
63     function DOMAIN_SEPARATOR() external view returns (bytes32);
64     function PERMIT_TYPEHASH() external pure returns (bytes32);
65     function nonces(address owner) external view returns (uint);
66 
67     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
68 
69     event Mint(address indexed sender, uint amount0, uint amount1);
70     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
71     event Swap(
72         address indexed sender,
73         uint amount0In,
74         uint amount1In,
75         uint amount0Out,
76         uint amount1Out,
77         address indexed to
78     );
79     event Sync(uint112 reserve0, uint112 reserve1);
80 
81     function MINIMUM_LIQUIDITY() external pure returns (uint);
82     function factory() external view returns (address);
83     function token0() external view returns (address);
84     function token1() external view returns (address);
85     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
86     function price0CumulativeLast() external view returns (uint);
87     function price1CumulativeLast() external view returns (uint);
88     function kLast() external view returns (uint);
89 
90     function mint(address to) external returns (uint liquidity);
91     function burn(address to) external returns (uint amount0, uint amount1);
92     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
93     function skim(address to) external;
94     function sync() external;
95 
96     function initialize(address, address) external;
97 }
98 library DEXLibrary {
99     using SafeMath for uint;
100 
101     // returns sorted token addresses, used to handle return values from pairs sorted in this order
102     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
103         require(tokenA != tokenB, 'DEXLibrary: IDENTICAL_ADDRESSES');
104         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
105         require(token0 != address(0), 'DEXLibrary: ZERO_ADDRESS');
106     }
107 
108     // calculates the CREATE2 address for a pair without making any external calls
109     function pairFor(bytes32 initHash, address factory, address tokenA, address tokenB) internal pure returns (address pair) {
110         (address token0, address token1) = sortTokens(tokenA, tokenB);
111         pair = address(uint(keccak256(abi.encodePacked(
112                 hex'ff',
113                 factory,
114                 keccak256(abi.encodePacked(token0, token1)),
115                 initHash // init code hash
116             ))));
117     }
118 
119     // fetches and sorts the reserves for a pair
120     function getReserves(bytes32 initHash, address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
121         (address token0,) = sortTokens(tokenA, tokenB);
122         pairFor(initHash, factory, tokenA, tokenB);
123         (uint reserve0, uint reserve1,) = IDEXPair(pairFor(initHash, factory, tokenA, tokenB)).getReserves();
124         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
125     }
126 
127     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
128     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
129         require(amountA > 0, 'DEXLibrary: INSUFFICIENT_AMOUNT');
130         require(reserveA > 0 && reserveB > 0, 'DEXLibrary: INSUFFICIENT_LIQUIDITY');
131         amountB = amountA.mul(reserveB) / reserveA;
132     }
133 
134     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
135     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint fee) internal pure returns (uint amountOut) {
136         require(amountIn > 0, 'DEXLibrary: INSUFFICIENT_INPUT_AMOUNT');
137         require(reserveIn > 0 && reserveOut > 0, 'DEXLibrary: INSUFFICIENT_LIQUIDITY');
138         uint amountInWithFee = amountIn.mul(fee);
139         uint numerator = amountInWithFee.mul(reserveOut);
140         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
141         amountOut = numerator / denominator;
142     }
143 
144     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
145     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint fee) internal pure returns (uint amountIn) {
146         require(amountOut > 0, 'DEXLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
147         require(reserveIn > 0 && reserveOut > 0, 'DEXLibrary: INSUFFICIENT_LIQUIDITY');
148         uint numerator = reserveIn.mul(amountOut).mul(10000);
149         uint denominator = reserveOut.sub(amountOut).mul(fee);
150         amountIn = (numerator / denominator).add(1);
151     }
152 
153     // performs chained getAmountOut calculations on any number of pairs
154     function getAmountsOut(bytes32 initHash, address factory, uint amountIn, address[] memory path, uint fee) internal view returns (uint[] memory amounts) {
155         require(path.length >= 2, 'DEXLibrary: INVALID_PATH');
156         amounts = new uint[](path.length);
157         amounts[0] = amountIn;
158         for (uint i; i < path.length - 1; i++) {
159             (uint reserveIn, uint reserveOut) = getReserves(initHash, factory, path[i], path[i + 1]);
160             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, fee);
161         }
162     }
163 
164     // performs chained getAmountIn calculations on any number of pairs
165     function getAmountsIn(bytes32 initHash, address factory, uint amountOut, address[] memory path, uint fee) internal view returns (uint[] memory amounts) {
166         require(path.length >= 2, 'DEXLibrary: INVALID_PATH');
167         amounts = new uint[](path.length);
168         amounts[amounts.length - 1] = amountOut;
169         for (uint i = path.length - 1; i > 0; i--) {
170             (uint reserveIn, uint reserveOut) = getReserves(initHash, factory, path[i - 1], path[i]);
171             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, fee);
172         }
173     }
174 }
175 
176 // Ownable Contract
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes memory) {
183         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
184         return msg.data;
185     }
186 }
187 contract Ownable is Context {
188     address private _owner;
189     address private _previousOwner;
190     uint256 private _lockTime;
191 
192     event OwnershipTransferred(
193         address indexed previousOwner,
194         address indexed newOwner
195     );
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() public{
201         address msgSender = _msgSender();
202         _owner = msgSender;
203         emit OwnershipTransferred(address(0), msgSender);
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(_owner == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         emit OwnershipTransferred(_owner, address(0));
230         _owner = address(0);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Can only be called by the current owner.
236      */
237     function transferOwnership(address newOwner) public virtual onlyOwner {
238         require(
239             newOwner != address(0),
240             "Ownable: new owner is the zero address"
241         );
242         emit OwnershipTransferred(_owner, newOwner);
243         _owner = newOwner;
244     }
245 
246     function geUnlockTime() public view returns (uint256) {
247         return _lockTime;
248     }
249 
250     //Locks the contract for owner for the amount of time provided
251     function lock(uint256 time) public virtual onlyOwner {
252         _previousOwner = _owner;
253         _owner = address(0);
254         _lockTime = block.timestamp + time;
255         emit OwnershipTransferred(_owner, address(0));
256     }
257 
258     //Unlocks the contract for owner when _lockTime is exceeds
259     function unlock() public virtual {
260         require(
261             _previousOwner == msg.sender,
262             "You don't have permission to unlock"
263         );
264         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
265         emit OwnershipTransferred(_owner, _previousOwner);
266         _owner = _previousOwner;
267     }
268 }
269 
270 // interface IDEXRouter
271 interface IDEXRouter01 {
272     function factory() external pure returns (address);
273     function WETH() external pure returns (address);
274 
275     // function swapExactTokensForTokens(
276     //     uint amountIn,
277     //     uint amountOutMin,
278     //     address[] calldata path,
279     //     address to,
280     //     uint deadline
281     // ) external returns (uint[] memory amounts);
282     // function swapTokensForExactTokens(
283     //     uint amountOut,
284     //     uint amountInMax,
285     //     address[] calldata path,
286     //     address to,
287     //     uint deadline
288     // ) external returns (uint[] memory amounts);
289     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
290         external
291         payable
292         returns (uint[] memory amounts);
293     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
294         external
295         returns (uint[] memory amounts);
296     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
297         external
298         returns (uint[] memory amounts);
299     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
300         external
301         payable
302         returns (uint[] memory amounts);
303 
304     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
305     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
306     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
307     function getAmountsOut(uint amountIn, address[] calldata path, uint256 dexId) external view returns (uint[] memory amounts);
308     function getAmountsIn(uint amountOut, address[] calldata path, uint256 dexId) external view returns (uint[] memory amounts);
309 }
310 interface IDEXRouter02 is IDEXRouter01 {
311     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
312         uint amountIn,
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline,
317         uint256 dexId
318     ) external;
319     function swapExactETHForTokensSupportingFeeOnTransferTokens(
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline,
324         uint256 usd,
325         uint256 dexId
326     ) external payable;
327     function swapExactTokensForETHSupportingFeeOnTransferTokens(
328         uint amountIn,
329         uint amountOutMin,
330         address[] calldata path,
331         address to,
332         uint deadline,
333         uint256 usd,
334         uint256 dexId
335     ) external;
336 }
337 
338 // interface IERC20
339 interface IERC20 {
340     event Approval(address indexed owner, address indexed spender, uint value);
341     event Transfer(address indexed from, address indexed to, uint value);
342 
343     function name() external view returns (string memory);
344     function symbol() external view returns (string memory);
345     function decimals() external view returns (uint8);
346     function totalSupply() external view returns (uint);
347     function balanceOf(address owner) external view returns (uint);
348     function allowance(address owner, address spender) external view returns (uint);
349 
350     function approve(address spender, uint value) external returns (bool);
351     function transfer(address to, uint value) external returns (bool);
352     function transferFrom(address from, address to, uint value) external returns (bool);
353 }
354 
355 // interface IWETH
356 interface IWETH {
357     function deposit() external payable;
358     function transfer(address to, uint value) external returns (bool);
359     function withdraw(uint) external;
360     function balanceOf(address owner) external view returns (uint);
361 }
362 
363 interface IDEXFactory {
364     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
365 
366     function feeTo() external view returns (address);
367     function feeToSetter() external view returns (address);
368 
369     function getPair(address tokenA, address tokenB) external view returns (address pair);
370     function allPairs(uint) external view returns (address pair);
371     function allPairsLength() external view returns (uint);
372 
373     function createPair(address tokenA, address tokenB) external returns (address pair);
374 
375     function setFeeTo(address) external;
376     function setFeeToSetter(address) external;
377 }
378 
379 interface AnjiReferral {
380     function referralBuy(address referrer, uint256 bnbBuy, address tokenAddr) external;
381 }
382 
383 interface AnjiFees {
384     function distributeDividend() external;
385 }
386 
387 contract AnjiRouter is IDEXRouter02, Ownable {
388     using SafeMath for uint;
389 
390     struct DEX {
391         string name;
392         address factory;
393         address router;
394         bytes32 initHash;
395         uint256 fee;
396         bool enabled;
397         uint256 id;
398     }
399 
400     mapping (uint256 => DEX) public dexList;
401     uint256 public dexCount;
402 
403     event Result(string);
404     address public override factory;
405     address public override WETH;
406     address public anjiReferral;
407     uint256 public busdThreshold = 100;
408 
409     address public feeReceiver;
410     bool public feeOFF = false;
411     bool public feeDistribute;
412 
413     modifier ensure(uint deadline) {
414         require(deadline >= block.timestamp, 'AnjiRouter: EXPIRED');
415         _;
416     }
417 
418     constructor(
419         address _WETH,
420         bool _feeDistribute,
421         string[] memory dexNames,
422         address[] memory dexFactories,
423         address[] memory dexRouters,
424         bytes32[] memory dexInitHashes,
425         uint256[] memory dexFees
426     ) public {
427         feeDistribute = _feeDistribute;
428         WETH = _WETH;
429         feeReceiver = msg.sender;
430 
431         for (uint256 index = 0; index < dexNames.length; index++) {
432             dexCount++;
433             dexList[dexCount] = DEX({
434                 name: dexNames[index],
435                 factory: dexFactories[index],
436                 router: dexRouters[index],
437                 initHash: dexInitHashes[index],
438                 fee: dexFees[index],
439                 enabled: true,
440                 id: dexCount
441             });
442         }
443     }
444 
445     function addDex(string memory name, address _factory, address router, bytes32 _initHash, uint256 fee, bool enabled) external onlyOwner {
446         dexCount++;
447         dexList[dexCount] = DEX({
448             name: name,
449             factory: _factory,
450             router: router,
451             initHash: _initHash,
452             fee: fee,
453             enabled: enabled,
454             id: dexCount
455         });
456     }
457 
458     function setDEXEnabled(uint256 dexID, bool enabled) external onlyOwner {
459         dexList[dexID].enabled = enabled;
460     }
461 
462     function getLargestDEX(address tokenA, address tokenB) public view returns (uint256) {
463         uint256 largestReserve = 0;
464         uint256 dexId = 0;
465 
466         // DEX Id's start at 1
467         for(uint256 i = 1; i < dexCount; i++){
468             if(!dexList[i].enabled){ continue; }
469 
470             if(IDEXFactory(dexList[i].factory).getPair(tokenA, tokenB) != address(0)){
471                 (uint256 reserve0, uint256 reserve1) = DEXLibrary.getReserves(dexList[i].initHash, dexList[i].factory, tokenA, tokenB);
472 
473                 if(reserve0 + reserve1 > largestReserve){
474                     largestReserve = reserve0 + reserve1;
475 
476                     dexId = dexList[i].id;
477                 }
478             }
479         }
480 
481         return dexId;
482     }
483 
484     receive() external payable {
485         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
486     }
487 
488     function setReceiverAddress(address _feeReceiver) public onlyOwner {
489         feeReceiver = _feeReceiver;
490     }
491 
492     function setBUSDThreshold(uint256 _threshold) public onlyOwner {
493         busdThreshold = _threshold;
494     }
495 
496     function setFeeDistribute(bool _feeDistribute) public onlyOwner {
497         feeDistribute = _feeDistribute;
498     }
499 
500     function setAnjiReferral(address _anjiReferral) public onlyOwner {
501         anjiReferral = _anjiReferral;
502     }
503 
504     function _feeAmount(uint amount, bool isReferrer, uint usd) public view returns (uint) {
505         if (isReferrer == true){
506             return amount.mul(2)/1000;
507         }
508 
509         if (usd>= busdThreshold) {
510             return amount.mul(1)/1000;
511 
512         } else {
513             return amount.mul(2)/1000;
514         }
515     }
516 
517     // **** SWAP ****
518     // requires the initial amount to have already been sent to the first pair
519     function _swap(uint[] memory amounts, address[] memory path, address _to, bytes32 initHash, address _factory) internal virtual {
520         for (uint i; i < path.length - 1; i++) {
521             (address input, address output) = (path[i], path[i + 1]);
522             (address token0,) = DEXLibrary.sortTokens(input, output);
523             uint amountOut = amounts[i + 1];
524             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
525             address to = i < path.length - 2 ? DEXLibrary.pairFor(initHash, _factory, output, path[i + 2]) : _to;
526             IDEXPair(DEXLibrary.pairFor(initHash, _factory, input, output)).swap(
527                 amount0Out, amount1Out, to, new bytes(0)
528             );
529         }
530     }
531 
532     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
533         external
534         virtual
535         override
536         payable
537         ensure(deadline)
538         returns (uint[] memory amounts)
539     {
540         require(path[0] == WETH, 'AnjiR: INVALID_PATH');
541         //uint amountIn = msg.value;
542         uint fee = _feeAmount(msg.value, false, usd);
543         uint amount = msg.value - fee;
544         amounts = DEXLibrary.getAmountsOut(dexList[dexId].initHash, dexList[dexId].factory, amount, path, dexList[dexId].fee);
545         require(amounts[amounts.length - 1] >= amountOutMin, 'AnjiR: INSUF_OUTA');
546         IWETH(WETH).deposit{value: amounts[0]}();
547         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]));
548         _swap(amounts, path, to, dexList[dexId].initHash, dexList[dexId].factory);
549         //send the fee to the fee receiver
550         if (fee > 0) {
551             TransferHelper.safeTransferETH(feeReceiver, fee);
552         }
553 
554         if(feeDistribute && address(feeReceiver).balance > 3){
555             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
556                 emit Result("success");
557             } catch (bytes memory) {
558                 emit Result("failed");
559             }
560         }
561 
562     }
563 
564     function referrerSwapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, address referrer, uint deadline, uint256 usd, uint256 dexId)
565         external
566         virtual
567         payable
568         ensure(deadline)
569         returns (uint[] memory amounts)
570     {
571         require(msg.sender != referrer, "Sender=Referrer");
572         require(referrer != address(0), "No Referrer");
573         require(path[0] == WETH, 'AnjiR: INVALID_PATH');
574         //uint amountIn = msg.value;
575         uint fee = _feeAmount(msg.value, true, usd);
576         //uint amount = msg.value - fee;
577 
578         amounts = DEXLibrary.getAmountsOut(dexList[dexId].initHash, dexList[dexId].factory, msg.value - fee, path, dexList[dexId].fee);
579         require(amounts[amounts.length - 1] >= amountOutMin, 'AnjiR: INSUF_OUTA');
580         IWETH(WETH).deposit{value: amounts[0]}();
581         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]));
582         _swap(amounts, path, to, dexList[dexId].initHash, dexList[dexId].factory);
583         //send the fee to the fee receiver
584         if (fee > 0) {
585             TransferHelper.safeTransferETH(feeReceiver, fee/2);
586             TransferHelper.safeTransferETH(referrer, fee/2);
587         }
588 
589         if(feeDistribute && address(feeReceiver).balance > 3){
590             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
591                 emit Result("success");
592             } catch (bytes memory) {
593                 emit Result("failed");
594             }
595         }
596 
597         AnjiReferral(anjiReferral).referralBuy(referrer, msg.value, path[1]);
598     }
599 
600     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
601         external
602         virtual
603         override
604         payable
605         ensure(deadline)
606         returns (uint[] memory amounts)
607     {
608 
609         require(path[0] == WETH, 'AnjiR: INVALID_PATH');
610 
611         amounts = DEXLibrary.getAmountsIn(dexList[dexId].initHash, dexList[dexId].factory, amountOut, path, dexList[dexId].fee);
612         require(amounts[0] <= msg.value, 'AnjiR: EXC_INA');
613         IWETH(WETH).deposit{value: amounts[0]}();
614         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]));
615         _swap(amounts, path, to, dexList[dexId].initHash, dexList[dexId].factory);
616 
617         //send the fee to the fee receiver
618         uint fee = _feeAmount(amounts[0], false, usd);
619         if (fee > 0) {
620             TransferHelper.safeTransferETH(feeReceiver, fee);
621         }
622 
623         if(feeDistribute && address(feeReceiver).balance > 3){
624             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
625                 emit Result("success");
626             } catch (bytes memory) {
627                 emit Result("failed");
628             }
629         }
630 
631         // refund dust eth, if any
632         if (msg.value - fee > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0] - fee);
633     }
634 
635     function referrerSwapETHForExactTokens(uint amountOut, address[] calldata path, address to, address referrer, uint deadline, uint256 usd, uint256 dexId)
636         external
637         virtual
638         payable
639         ensure(deadline)
640         returns (uint[] memory amounts)
641     {
642         require(msg.sender != referrer, "Sender=Referrer");
643         require(referrer != address(0), "No Referrer");
644         require(path[0] == WETH, 'AnjiR: INVALID_PATH');
645         amounts = DEXLibrary.getAmountsIn(dexList[dexId].initHash, dexList[dexId].factory, amountOut, path, dexList[dexId].fee);
646         require(amounts[0] <= msg.value, 'AnjiR: EXCINA');
647         IWETH(WETH).deposit{value: amounts[0]}();
648         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]));
649         _swap(amounts, path, to, dexList[dexId].initHash, dexList[dexId].factory);
650 
651         //send the fee to the fee receiver
652         uint fee = _feeAmount(amounts[0], true, usd);
653         if (fee > 0) {
654             TransferHelper.safeTransferETH(feeReceiver, fee/2);
655             TransferHelper.safeTransferETH(referrer, fee/2);
656         }
657 
658         if(feeDistribute && address(feeReceiver).balance > 3){
659             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
660                 emit Result("success");
661             } catch (bytes memory) {
662                 emit Result("failed");
663             }
664         }
665 
666         // refund dust eth, if any
667         if (msg.value - fee > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0] - fee);
668 
669         AnjiReferral(anjiReferral).referralBuy(referrer, msg.value, path[1]);
670     }
671 
672     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
673         external
674         virtual
675         override
676         ensure(deadline)
677         returns (uint[] memory amounts)
678     {
679         require(path[path.length - 1] == WETH, 'AnjiR: INVALID_PATH');
680         amounts = DEXLibrary.getAmountsIn(dexList[dexId].initHash, dexList[dexId].factory, amountOut, path, dexList[dexId].fee);
681         require(amounts[0] <= amountInMax, 'AnjiR: EXCIA');
682         TransferHelper.safeTransferFrom(
683             path[0], msg.sender, DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]
684         );
685         _swap(amounts, path, address(this), dexList[dexId].initHash, dexList[dexId].factory);
686 
687         uint fee = _feeAmount(amounts[amounts.length - 1], false, usd);
688         uint sendingAmount = amounts[amounts.length - 1].sub(fee);
689 
690         if (fee > 0){
691             IWETH(WETH).withdraw(fee);
692             TransferHelper.safeTransferETH(feeReceiver, fee);
693         }
694 
695         if(feeDistribute && address(feeReceiver).balance > 3){
696             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
697                 emit Result("success");
698             } catch (bytes memory) {
699                 emit Result("failed");
700             }
701         }
702 
703         IWETH(WETH).withdraw(sendingAmount);
704         TransferHelper.safeTransferETH(to, sendingAmount);
705 
706     }
707     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline, uint256 usd, uint256 dexId)
708         external
709         virtual
710         override
711         ensure(deadline)
712         returns (uint[] memory amounts)
713     {
714         require(path[path.length - 1] == WETH, 'AnjiR: INVALID_PATH');
715         amounts = DEXLibrary.getAmountsOut(dexList[dexId].initHash, dexList[dexId].factory, amountIn, path, dexList[dexId].fee);
716         require(amounts[amounts.length - 1] >= amountOutMin, 'AnjiR: INSUFOUTA');
717         TransferHelper.safeTransferFrom(
718             path[0], msg.sender, DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amounts[0]
719         );
720         _swap(amounts, path, address(this), dexList[dexId].initHash, dexList[dexId].factory);
721 
722         uint fee = _feeAmount(amounts[amounts.length - 1], false, usd);
723         uint sendingAmount = amounts[amounts.length - 1].sub(fee);
724 
725         if (fee > 0){
726             IWETH(WETH).withdraw(fee);
727             TransferHelper.safeTransferETH(feeReceiver, fee);
728         }
729 
730         if(feeDistribute && address(feeReceiver).balance > 3){
731             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
732                 emit Result("success");
733             } catch (bytes memory) {
734                 emit Result("failed");
735             }
736         }
737 
738         IWETH(WETH).withdraw(sendingAmount);
739         TransferHelper.safeTransferETH(to, sendingAmount);
740     }
741 
742 
743     // **** SWAP (supporting fee-on-transfer tokens) ****
744     // requires the initial amount to have already been sent to the first pair
745     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to, DEX memory dex) internal virtual {
746         for (uint i; i < path.length - 1; i++) {
747             (address input, address output) = (path[i], path[i + 1]);
748             (address token0,) = DEXLibrary.sortTokens(input, output);
749             IDEXPair pair = IDEXPair(DEXLibrary.pairFor(dex.initHash, dex.factory, input, output));
750             // uint amountInput;
751             uint amountOutput;
752             { // scope to avoid stack too deep errors
753             (uint reserve0, uint reserve1,) = pair.getReserves();
754             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
755             // amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
756             amountOutput = DEXLibrary.getAmountOut(IERC20(input).balanceOf(address(pair)).sub(reserveInput), reserveInput, reserveOutput, dex.fee);
757             }
758             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
759             address to = i < path.length - 2 ? DEXLibrary.pairFor(dex.initHash, dex.factory, output, path[i + 2]) : _to;
760             pair.swap(amount0Out, amount1Out, to, new bytes(0));
761         }
762     }
763     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline,
769         uint256 dexId
770     ) external virtual override ensure(deadline) {
771         TransferHelper.safeTransferFrom(
772             path[0], msg.sender, DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amountIn
773         );
774         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
775         _swapSupportingFeeOnTransferTokens(path, to, dexList[dexId]);
776         require(
777             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
778             'AnjiR: INSUFOA'
779         );
780     }
781     function swapExactETHForTokensSupportingFeeOnTransferTokens(
782         uint amountOutMin,
783         address[] calldata path,
784         address to,
785         uint deadline,
786         uint256 usd,
787         uint256 dexId
788     )
789         external
790         virtual
791         override
792         payable
793         ensure(deadline)
794     {
795         require(path[0] == WETH, 'AnjiR:INVALID_PATH');
796         //uint amountIn = msg.value;
797         uint fee = _feeAmount(msg.value, false, usd);
798         uint amount = msg.value - fee;
799         IWETH(WETH).deposit{value: amount}();
800         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amount));
801         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
802         _swapSupportingFeeOnTransferTokens(path, to, dexList[dexId]);
803         if (fee > 0) {
804             TransferHelper.safeTransferETH(feeReceiver, fee);
805         }
806 
807         if(feeDistribute && address(feeReceiver).balance > 3){
808             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
809                 emit Result("success");
810             } catch (bytes memory) {
811                 emit Result("failed");
812             }
813         }
814 
815         require(
816             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
817             'AnjiR:INSUFOA'
818         );
819     }
820 
821     function referralSwapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, address referrer, uint deadline, uint256 usd, uint256 dexId)
822         external
823         virtual
824         payable
825         ensure(deadline)
826     {
827         require(msg.sender != referrer, "Sender=Referrer");
828         require(referrer != address(0), "NoReferrer");
829         require(path[0] == WETH, 'AnjiR:INVALID_PATH');
830         //uint amountIn = msg.value;
831         uint fee = _feeAmount(msg.value, true, usd);
832         //uint amount = msg.value - fee;
833         IWETH(WETH).deposit{value: msg.value - fee}();
834         assert(IWETH(WETH).transfer(DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), msg.value - fee));
835         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
836         _swapSupportingFeeOnTransferTokens(path, to, dexList[dexId]);
837         if (fee > 0) {
838             TransferHelper.safeTransferETH(feeReceiver, fee/2);
839             TransferHelper.safeTransferETH(referrer, fee/2);
840         }
841 
842         if(feeDistribute && address(feeReceiver).balance > 3){
843             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
844                 emit Result("success");
845             } catch (bytes memory) {
846                 emit Result("failed");
847             }
848         }
849 
850         require(
851             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
852             'AnjiR:INSUFOA'
853         );
854         AnjiReferral(anjiReferral).referralBuy(referrer, msg.value, path[1]);
855     }
856 
857     function swapExactTokensForETHSupportingFeeOnTransferTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline,
863         uint256 usd,
864         uint256 dexId
865     )
866         external
867         virtual
868         override
869         ensure(deadline)
870     {
871         require(path[path.length - 1] == WETH, 'AnjiR:INVALID_PATH');
872         TransferHelper.safeTransferFrom(
873             path[0], msg.sender, DEXLibrary.pairFor(dexList[dexId].initHash, dexList[dexId].factory, path[0], path[1]), amountIn
874         );
875         _swapSupportingFeeOnTransferTokens(path, address(this), dexList[dexId]);
876         uint amountOut = IERC20(WETH).balanceOf(address(this));
877         require(amountOut >= amountOutMin, 'AnjiR:INSUFOA');
878 
879         uint fee = _feeAmount(amountOut, false, usd);
880         uint sendingAmount = amountOut.sub(fee);
881 
882         if (fee > 0){
883             IWETH(WETH).withdraw(fee);
884             TransferHelper.safeTransferETH(feeReceiver, fee);
885         }
886 
887         if(feeDistribute && address(feeReceiver).balance > 3){
888             try AnjiFees(feeReceiver).distributeDividend{gas: 77589 }() {
889                 emit Result("success");
890             } catch (bytes memory) {
891                 emit Result("failed");
892             }
893         }
894 
895         IWETH(WETH).withdraw(sendingAmount);
896         TransferHelper.safeTransferETH(to, sendingAmount);
897     }
898 
899     // **** LIBRARY FUNCTIONS ****
900     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
901         return DEXLibrary.quote(amountA, reserveA, reserveB);
902     }
903 
904     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
905         public
906         pure
907         virtual
908         override
909         returns (uint amountOut)
910     {
911         return DEXLibrary.getAmountOut(amountIn, reserveIn, reserveOut,9975);
912     }
913 
914     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
915         public
916         pure
917         virtual
918         override
919         returns (uint amountIn)
920     {
921         return DEXLibrary.getAmountIn(amountOut, reserveIn, reserveOut, 9975);
922     }
923 
924     function getAmountsOut(uint amountIn, address[] memory path, uint256 dexId)
925         public
926         view
927         virtual
928         override
929         returns (uint[] memory amounts)
930     {
931         return DEXLibrary.getAmountsOut(dexList[dexId].initHash, dexList[dexId].factory, amountIn, path, dexList[dexId].fee);
932     }
933 
934     function getAmountsIn(uint amountOut, address[] memory path, uint256 dexId)
935         public
936         view
937         virtual
938         override
939         returns (uint[] memory amounts)
940     {
941         return DEXLibrary.getAmountsIn(dexList[dexId].initHash, dexList[dexId].factory, amountOut, path, dexList[dexId].fee);
942     }
943 }