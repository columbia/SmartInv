1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.6.6;
3 
4 interface IRibeToken
5 {
6     function buyFeePercentage() external view returns(uint);
7     function onBuyFeeCollected(address tokenAddress, uint amount) external;
8     function sellFeePercentage() external view returns(uint);
9     function onSellFeeCollected(address tokenAddress, uint amount) external;
10 }
11 
12 interface IHatiSacrifice
13 {
14     function depositToken(address lpAddress, address addressBaseToken, uint amount) external;
15 }
16 
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
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor () internal {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * NOTE: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 pragma solidity >=0.5.0;
81 
82 interface IERC20 {
83     event Approval(address indexed owner, address indexed spender, uint value);
84     event Transfer(address indexed from, address indexed to, uint value);
85 
86     function name() external view returns (string memory);
87     function symbol() external view returns (string memory);
88     function decimals() external view returns (uint8);
89     function totalSupply() external view returns (uint);
90     function balanceOf(address owner) external view returns (uint);
91     function allowance(address owner, address spender) external view returns (uint);
92 
93     function approve(address spender, uint value) external returns (bool);
94     function transfer(address to, uint value) external returns (bool);
95     function transferFrom(address from, address to, uint value) external returns (bool);
96 }
97 
98 pragma solidity >=0.5.0;
99 
100 interface IRibeSwapFactory {
101     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
102 
103     function feeTo() external view returns (address);
104     function feeToSetter() external view returns (address);
105 
106     function getPair(address tokenA, address tokenB) external view returns (address pair);
107     function allPairs(uint) external view returns (address pair);
108     function allPairsLength() external view returns (uint);
109 
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 
112     function setFeeTo(address) external;
113     function setFeeToSetter(address) external;
114 
115     // Changes
116     function setBaseToken(address tokenAddress, bool value) external;
117     function setRouterAddress(address routerAddress, bool value) external;
118     function isBaseTokenFunction(address _address) external view returns(bool);
119     function addressIsRouter(address routerAddress) external view returns(bool);
120     function getHatiSacrificeAddress() external view returns(address);
121     // End changes
122 }
123 
124 pragma solidity >=0.6.2;
125 
126 interface IRibeSwapRouter01 {
127     function factory() external pure returns (address);
128     function WETH() external pure returns (address);
129 
130     function swapExactTokensForTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external returns (uint[] memory amounts);
137     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
138         external
139         payable
140         returns (uint[] memory amounts);
141     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
142         external
143         returns (uint[] memory amounts);
144 
145     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
146     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
147     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
148     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
149     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
150 }
151 
152 pragma solidity >=0.5.0;
153 
154 interface IWETH {
155     function deposit() external payable;
156     function transfer(address to, uint value) external returns (bool);
157     function withdraw(uint) external;
158 }
159 
160 pragma solidity >=0.5.0;
161 
162 interface IRibeSwapPair {
163     event Approval(address indexed owner, address indexed spender, uint value);
164     event Transfer(address indexed from, address indexed to, uint value);
165 
166     function name() external pure returns (string memory);
167     function symbol() external pure returns (string memory);
168     function decimals() external pure returns (uint8);
169     function totalSupply() external view returns (uint);
170     function balanceOf(address owner) external view returns (uint);
171     function allowance(address owner, address spender) external view returns (uint);
172 
173     function approve(address spender, uint value) external returns (bool);
174     function transfer(address to, uint value) external returns (bool);
175     function transferFrom(address from, address to, uint value) external returns (bool);
176 
177     function DOMAIN_SEPARATOR() external view returns (bytes32);
178     function PERMIT_TYPEHASH() external pure returns (bytes32);
179     function nonces(address owner) external view returns (uint);
180 
181     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
182 
183     event Mint(address indexed sender, uint amount0, uint amount1);
184     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
185     event Swap(
186         address indexed sender,
187         uint amount0In,
188         uint amount1In,
189         uint amount0Out,
190         uint amount1Out,
191         address indexed to
192     );
193     event Sync(uint112 reserve0, uint112 reserve1);
194 
195     function MINIMUM_LIQUIDITY() external pure returns (uint);
196     function factory() external view returns (address);
197     function token0() external view returns (address);
198     function token1() external view returns (address);
199     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
200     function price0CumulativeLast() external view returns (uint);
201     function price1CumulativeLast() external view returns (uint);
202     function kLast() external view returns (uint);
203 
204     function mint(address to) external returns (uint liquidity);
205     function burn(address to) external returns (uint amount0, uint amount1);
206     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
207     function skim(address to) external;
208     function sync() external;
209 
210     function initialize(address, address) external;
211 }
212 
213 pragma solidity =0.6.6;
214 
215 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
216 
217 library SafeMath {
218     function add(uint x, uint y) internal pure returns (uint z) {
219         require((z = x + y) >= x, 'ds-math-add-overflow');
220     }
221 
222     function sub(uint x, uint y) internal pure returns (uint z) {
223         require((z = x - y) <= x, 'ds-math-sub-underflow');
224     }
225 
226     function mul(uint x, uint y) internal pure returns (uint z) {
227         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
228     }
229 }
230 
231 pragma solidity >=0.5.0;
232 
233 library RibeSwapLibrary {
234     using SafeMath for uint;
235 
236     // returns sorted token addresses, used to handle return values from pairs sorted in this order
237     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
238         require(tokenA != tokenB, 'RibeSwapLibrary: IDENTICAL_ADDRESSES');
239         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
240         require(token0 != address(0), 'RibeSwapLibrary: ZERO_ADDRESS');
241     }
242 
243     // calculates the CREATE2 address for a pair without making any external calls
244     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
245         // Change
246         pair = IRibeSwapFactory(factory).getPair(tokenA, tokenB);
247         /*
248         (address token0, address token1) = sortTokens(tokenA, tokenB);
249         pair = address(uint(keccak256(abi.encodePacked(
250                 hex'ff',
251                 factory,
252                 keccak256(abi.encodePacked(token0, token1)),
253                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
254             ))));
255         */
256         // End change
257     }
258 
259     // fetches and sorts the reserves for a pair
260     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
261         (address token0,) = sortTokens(tokenA, tokenB);
262         (uint reserve0, uint reserve1,) = IRibeSwapPair(pairFor(factory, tokenA, tokenB)).getReserves();
263         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
264     }
265 
266     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
267     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
268         require(amountA > 0, 'RibeSwapLibrary: INSUFFICIENT_AMOUNT');
269         require(reserveA > 0 && reserveB > 0, 'RibeSwapLibrary: INSUFFICIENT_LIQUIDITY');
270         amountB = amountA.mul(reserveB) / reserveA;
271     }
272 
273     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
274     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
275         require(amountIn > 0, 'RibeSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
276         require(reserveIn > 0 && reserveOut > 0, 'RibeSwapLibrary: INSUFFICIENT_LIQUIDITY');
277         uint amountInWithFee = amountIn.mul(997);
278         uint numerator = amountInWithFee.mul(reserveOut);
279         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
280         amountOut = numerator / denominator;
281     }
282 
283     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
284     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
285         require(amountOut > 0, 'RibeSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
286         require(reserveIn > 0 && reserveOut > 0, 'RibeSwapLibrary: INSUFFICIENT_LIQUIDITY');
287         uint numerator = reserveIn.mul(amountOut).mul(1000);
288         uint denominator = reserveOut.sub(amountOut).mul(997);
289         amountIn = (numerator / denominator).add(1);
290     }
291 
292     // performs chained getAmountOut calculations on any number of pairs
293     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
294         require(path.length >= 2, 'RibeSwapLibrary: INVALID_PATH');
295         amounts = new uint[](path.length);
296         amounts[0] = amountIn;
297         for (uint i; i < path.length - 1; i++) {
298             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
299             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
300         }
301     }
302 
303     // performs chained getAmountIn calculations on any number of pairs
304     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
305         require(path.length >= 2, 'RibeSwapLibrary: INVALID_PATH');
306         amounts = new uint[](path.length);
307         amounts[amounts.length - 1] = amountOut;
308         for (uint i = path.length - 1; i > 0; i--) {
309             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
310             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
311         }
312     }
313 }
314 
315 pragma solidity >=0.6.0;
316 
317 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
318 library TransferHelper {
319     function safeApprove(
320         address token,
321         address to,
322         uint256 value
323     ) internal {
324         // bytes4(keccak256(bytes('approve(address,uint256)')));
325         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
326         require(
327             success && (data.length == 0 || abi.decode(data, (bool))),
328             'TransferHelper::safeApprove: approve failed'
329         );
330     }
331 
332     function safeTransfer(
333         address token,
334         address to,
335         uint256 value
336     ) internal {
337         // bytes4(keccak256(bytes('transfer(address,uint256)')));
338         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
339         require(
340             success && (data.length == 0 || abi.decode(data, (bool))),
341             'TransferHelper::safeTransfer: transfer failed'
342         );
343     }
344 
345     function safeTransferFrom(
346         address token,
347         address from,
348         address to,
349         uint256 value
350     ) internal {
351         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
352         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
353         require(
354             success && (data.length == 0 || abi.decode(data, (bool))),
355             'TransferHelper::transferFrom: transferFrom failed'
356         );
357     }
358 
359     function safeTransferETH(address to, uint256 value) internal {
360         (bool success, ) = to.call{value: value}(new bytes(0));
361         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
362     }
363 }
364 
365 pragma solidity =0.6.6;
366 
367 contract RibeSwapRouter is IRibeSwapRouter01, Ownable{
368     using SafeMath for uint;
369 
370     // Changes
371     function calculateFee(uint256 feePercentage, uint256 amount, uint256 feeDecimal) internal pure returns(uint256) {
372         return (amount * feePercentage) / (10**(feeDecimal + 2));
373     }
374 
375     // Anti bots
376     mapping(address => uint256) public _blockNumberByAddress;
377     bool public antiBotsActive = false;
378     mapping(address => bool) public isContractExempt;
379     uint public blockCooldownAmount = 1;
380 
381     function isContract(address account) internal view returns (bool) {
382         uint256 size;
383         assembly {
384             size := extcodesize(account)
385         }
386         return size > 0;
387     }
388 
389     function ensureMaxTxFrequency(address addr) internal view {
390         bool isAllowed = _blockNumberByAddress[addr] == 0 ||
391             ((_blockNumberByAddress[addr] + blockCooldownAmount) < (block.number + 1));
392         require(isAllowed, "Max tx frequency exceeded!");
393     }
394 
395     function setAntiBotsActive(bool value) external onlyOwner {
396         antiBotsActive = value;
397     }
398 
399     function setBlockCooldown(uint value) external onlyOwner {
400         blockCooldownAmount = value;
401     }
402 
403     function setContractExempt(address account, bool value) external onlyOwner {
404         isContractExempt[account] = value;
405     }
406 
407     function enforceAntiBots(address participant) internal {
408         if(antiBotsActive)
409         {
410             if(!isContractExempt[participant])
411             {
412                 require(!isContract(participant), "No bots allowed!");
413                 ensureMaxTxFrequency(participant);
414                 _blockNumberByAddress[participant] = block.number;
415             }
416         }
417     }
418     // End anti bots
419     // End changes
420 
421     address public immutable override factory;
422     address public immutable override WETH;
423 
424     modifier ensure(uint deadline) {
425         require(deadline >= block.timestamp, 'RibeSwapRouter: EXPIRED');
426         _;
427     }
428 
429     constructor(address _factory, address _WETH) public {
430         factory = _factory;
431         WETH = _WETH;
432     }
433 
434     receive() external payable {
435         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
436     }
437 
438     // **** SWAP ****
439     // requires the initial amount to have already been sent to the first pair
440     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
441         for (uint i; i < path.length - 1; i++) {
442             (address input, address output) = (path[i], path[i + 1]);
443             (address token0,) = RibeSwapLibrary.sortTokens(input, output);
444             uint amountOut = amounts[i + 1];
445             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
446             address to = i < path.length - 2 ? RibeSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
447             IRibeSwapPair(RibeSwapLibrary.pairFor(factory, input, output)).swap(
448                 amount0Out, amount1Out, to, new bytes(0)
449             );
450         }
451     }
452     function processBuyFee(uint amountIn, address tokenInAddress, address tokenOutAddress) internal returns(uint256)
453     {
454         if(IRibeSwapFactory(factory).isBaseTokenFunction(tokenInAddress)) // is Buy
455         {
456             require(IRibeToken(tokenOutAddress).buyFeePercentage() <= 1000, 'RibeSwapRouter: BUY FEE IS TOO HIGH'); // %10 maximum fee
457             uint tokenFee = calculateFee(IRibeToken(tokenOutAddress).buyFeePercentage(), amountIn, 2);
458             uint platformFee = calculateFee(30, amountIn, 2); // 0.3% Hati Sacrifice Fee
459             amountIn -= tokenFee;
460             amountIn -= platformFee;
461             TransferHelper.safeTransferFrom(
462                 tokenInAddress, msg.sender, tokenOutAddress, tokenFee
463             );
464             TransferHelper.safeTransferFrom(
465                 tokenInAddress, msg.sender, address(this), platformFee
466             );
467             IERC20(tokenInAddress).approve(IRibeSwapFactory(factory).getHatiSacrificeAddress(), platformFee);
468             IHatiSacrifice(IRibeSwapFactory(factory).getHatiSacrificeAddress()).depositToken(tokenOutAddress, tokenInAddress, platformFee);
469             IRibeToken(tokenOutAddress).onBuyFeeCollected(tokenInAddress, tokenFee);
470         }
471         return amountIn;
472     }
473 
474     function processSellFeeETH(uint amountOut, address tokenAddress) internal returns(uint256)
475     {
476         require(IRibeToken(tokenAddress).sellFeePercentage() <= 1000, 'RibeSwapRouter: SELL FEE IS TOO HIGH'); // %10 maximum fee
477         uint tokenFee = calculateFee(IRibeToken(tokenAddress).sellFeePercentage(), amountOut, 2);
478         uint platformFee = calculateFee(30, amountOut, 2); // 0.3% Hati Sacrifice Fee
479         amountOut -= tokenFee;
480         amountOut -= platformFee;
481         TransferHelper.safeTransferFrom(
482             WETH, address(this), tokenAddress, tokenFee
483         );
484         IERC20(WETH).approve(IRibeSwapFactory(factory).getHatiSacrificeAddress(), platformFee);
485         IHatiSacrifice(IRibeSwapFactory(factory).getHatiSacrificeAddress()).depositToken(tokenAddress, WETH, platformFee);
486 
487         IRibeToken(tokenAddress).onSellFeeCollected(WETH, tokenFee);
488         return amountOut;
489     }
490 
491     function processBuyFeeWETH(uint amountIn, address tokenInAddress, address tokenOutAddress) internal returns(uint256)
492     {
493         if(IRibeSwapFactory(factory).isBaseTokenFunction(tokenInAddress)) // is Buy
494         {
495             require(IRibeToken(tokenOutAddress).buyFeePercentage() <= 1000, 'RibeSwapRouter: BUY FEE IS TOO HIGH'); // %10 maximum fee
496             uint tokenFee = calculateFee(IRibeToken(tokenOutAddress).buyFeePercentage(), amountIn, 2);
497             uint platformFee = calculateFee(30, amountIn, 2); // 0.3% Hati Sacrifice Fee
498             amountIn -= tokenFee;
499             amountIn -= platformFee;
500             TransferHelper.safeTransferFrom(
501                 tokenInAddress, address(this), tokenOutAddress, tokenFee
502             );
503             IERC20(tokenInAddress).approve(IRibeSwapFactory(factory).getHatiSacrificeAddress(), platformFee);
504             IHatiSacrifice(IRibeSwapFactory(factory).getHatiSacrificeAddress()).depositToken(tokenOutAddress, tokenInAddress, platformFee);
505 
506             IRibeToken(tokenOutAddress).onBuyFeeCollected(tokenInAddress, tokenFee);
507         }
508         return amountIn;
509     }
510 
511     function swapExactTokensForTokens(
512         uint amountIn,
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
518 
519         // Changes
520         // Anti bots
521         enforceAntiBots(msg.sender);
522         // End anti bots
523         amountIn = processBuyFee(amountIn, path[0], path[path.length-1]);
524         // End changes
525 
526         amounts = RibeSwapLibrary.getAmountsOut(factory, amountIn, path);
527         require(amounts[amounts.length - 1] >= amountOutMin, 'RibeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
528         TransferHelper.safeTransferFrom(
529             path[0], msg.sender, RibeSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
530         );
531         _swap(amounts, path, to);
532     }
533 
534     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
535         external
536         virtual
537         override
538         payable
539         ensure(deadline)
540         returns (uint[] memory amounts)
541     {
542         require(path[0] == WETH, 'RibeSwapRouter: INVALID_PATH');
543         IWETH(WETH).deposit{value: msg.value}();
544 
545         // Changes
546         // Anti bots
547         enforceAntiBots(msg.sender);
548         // End anti bots
549         uint256 amountIn = processBuyFeeWETH(msg.value, path[0], path[path.length-1]);
550         // End changes
551 
552         amounts = RibeSwapLibrary.getAmountsOut(factory, amountIn, path);
553         require(amounts[amounts.length - 1] >= amountOutMin, 'RibeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
554         assert(IWETH(WETH).transfer(RibeSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
555         _swap(amounts, path, to);
556     }
557 
558     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
559         external
560         virtual
561         override
562         ensure(deadline)
563         returns (uint[] memory amounts)
564     {
565         // Changes
566         // Anti bots
567         enforceAntiBots(msg.sender);
568         // End anti bots
569         amountIn = processBuyFee(amountIn, path[0], path[path.length-1]);
570         // End changes
571         
572         require(path[path.length - 1] == WETH, 'RibeSwapRouter: INVALID_PATH');
573         amounts = RibeSwapLibrary.getAmountsOut(factory, amountIn, path);
574         require(amounts[amounts.length - 1] >= amountOutMin, 'RibeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
575         TransferHelper.safeTransferFrom(
576             path[0], msg.sender, RibeSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
577         );
578         _swap(amounts, path, address(this));
579         // Changes
580         amounts[amounts.length - 1] = processSellFeeETH(amounts[amounts.length - 1], path[0]);
581         // End changes
582         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
583         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
584     }
585 
586     // **** LIBRARY FUNCTIONS ****
587     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
588         return RibeSwapLibrary.quote(amountA, reserveA, reserveB);
589     }
590 
591     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
592         public
593         pure
594         virtual
595         override
596         returns (uint amountOut)
597     {
598         return RibeSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
599     }
600 
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
602         public
603         pure
604         virtual
605         override
606         returns (uint amountIn)
607     {
608         return RibeSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
609     }
610 
611     function getAmountsOut(uint amountIn, address[] memory path)
612         public
613         view
614         virtual
615         override
616         returns (uint[] memory amounts)
617     {
618         return RibeSwapLibrary.getAmountsOut(factory, amountIn, path);
619     }
620 
621     function getAmountsIn(uint amountOut, address[] memory path)
622         public
623         view
624         virtual
625         override
626         returns (uint[] memory amounts)
627     {
628         return RibeSwapLibrary.getAmountsIn(factory, amountOut, path);
629     }
630 }