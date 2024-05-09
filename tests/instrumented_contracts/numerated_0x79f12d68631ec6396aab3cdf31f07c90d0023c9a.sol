1 pragma solidity =0.6.6;
2 
3 
4 interface IUnifiFactory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function feeTo() external view returns (address);
8     function feeToSetter() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }
19 
20 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
21 library TransferHelper {
22     function safeApprove(address token, address to, uint value) internal {
23         // bytes4(keccak256(bytes('approve(address,uint256)')));
24         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
25         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
26     }
27 
28     function safeTransfer(address token, address to, uint value) internal {
29         // bytes4(keccak256(bytes('transfer(address,uint256)')));
30         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
31         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
32     }
33 
34     function safeTransferFrom(address token, address from, address to, uint value) internal {
35         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
36         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
37         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
38     }
39 
40     function safeTransferETH(address to, uint value) internal {
41         (bool success,) = to.call{value:value}(new bytes(0));
42         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
43     }
44 }
45 
46 interface IUnifiRouter01 {
47     function factory() external pure returns (address);
48     function WETH() external pure returns (address);
49 
50     function addLiquidity(
51         address tokenA,
52         address tokenB,
53         uint amountADesired,
54         uint amountBDesired,
55         uint amountAMin,
56         uint amountBMin,
57         address to,
58         uint deadline
59     ) external returns (uint amountA, uint amountB, uint liquidity);
60     function addLiquidityETH(
61         address token,
62         uint amountTokenDesired,
63         uint amountTokenMin,
64         uint amountETHMin,
65         address to,
66         uint deadline
67     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
68     function removeLiquidity(
69         address tokenA,
70         address tokenB,
71         uint liquidity,
72         uint amountAMin,
73         uint amountBMin,
74         address to,
75         uint deadline
76     ) external returns (uint amountA, uint amountB);
77     function removeLiquidityETH(
78         address token,
79         uint liquidity,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external returns (uint amountToken, uint amountETH);
85     function removeLiquidityWithPermit(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline,
93         bool approveMax, uint8 v, bytes32 r, bytes32 s
94     ) external returns (uint amountA, uint amountB);
95     function removeLiquidityETHWithPermit(
96         address token,
97         uint liquidity,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline,
102         bool approveMax, uint8 v, bytes32 r, bytes32 s
103     ) external returns (uint amountToken, uint amountETH);
104     function swapExactTokensForTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external returns (uint[] memory amounts);
111     function swapTokensForExactTokens(
112         uint amountOut,
113         uint amountInMax,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external returns (uint[] memory amounts);
118     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
119         external
120         payable
121         returns (uint[] memory amounts);
122     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
123         external
124         returns (uint[] memory amounts);
125     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
126         external
127         returns (uint[] memory amounts);
128     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
129         external
130         payable
131         returns (uint[] memory amounts);
132 
133     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
134     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint fee) external pure returns (uint amountOut);
135     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint fee) external pure returns (uint amountIn);
136     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
137     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
138 }
139 
140 interface IUnifiRouter02 is IUnifiRouter01 {
141     function removeLiquidityETHSupportingFeeOnTransferTokens(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external returns (uint amountETH);
149     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
150         address token,
151         uint liquidity,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline,
156         bool approveMax, uint8 v, bytes32 r, bytes32 s
157     ) external returns (uint amountETH);
158 
159     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166     function swapExactETHForTokensSupportingFeeOnTransferTokens(
167         uint amountOutMin,
168         address[] calldata path,
169         address to,
170         uint deadline
171     ) external payable;
172     function swapExactTokensForETHSupportingFeeOnTransferTokens(
173         uint amountIn,
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external;
179 }
180 
181 interface IUnifiPair {
182     event Approval(address indexed owner, address indexed spender, uint value);
183     event Transfer(address indexed from, address indexed to, uint value);
184 
185     function name() external pure returns (string memory);
186     function symbol() external pure returns (string memory);
187     function decimals() external pure returns (uint8);
188     function totalSupply() external view returns (uint);
189     function balanceOf(address owner) external view returns (uint);
190     function allowance(address owner, address spender) external view returns (uint);
191 
192     function approve(address spender, uint value) external returns (bool);
193     function transfer(address to, uint value) external returns (bool);
194     function transferFrom(address from, address to, uint value) external returns (bool);
195 
196     function DOMAIN_SEPARATOR() external view returns (bytes32);
197     function PERMIT_TYPEHASH() external pure returns (bytes32);
198     function nonces(address owner) external view returns (uint);
199 
200     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
201 
202     event Mint(address indexed sender, uint amount0, uint amount1);
203     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
204     event Swap(
205         address indexed sender,
206         uint amount0In,
207         uint amount1In,
208         uint amount0Out,
209         uint amount1Out,
210         address indexed to
211     );
212     event Sync(uint112 reserve0, uint112 reserve1);
213 
214     function MINIMUM_LIQUIDITY() external pure returns (uint);
215     function factory() external view returns (address);
216     function token0() external view returns (address);
217     function token1() external view returns (address);
218     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
219     function price0CumulativeLast() external view returns (uint);
220     function price1CumulativeLast() external view returns (uint);
221     function kLast() external view returns (uint);
222 
223     function mint(address to) external returns (uint liquidity);
224     function burn(address to) external returns (uint amount0, uint amount1);
225     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
226     function skim(address to) external;
227     function sync() external;
228 
229     function initialize(address, address) external;
230 }
231 
232 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
233 library SafeMath {
234     function add(uint x, uint y) internal pure returns (uint z) {
235         require((z = x + y) >= x, 'ds-math-add-overflow');
236     }
237 
238     function sub(uint x, uint y) internal pure returns (uint z) {
239         require((z = x - y) <= x, 'ds-math-sub-underflow');
240     }
241 
242     function mul(uint x, uint y) internal pure returns (uint z) {
243         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
244     }
245     
246     function div(uint x, uint y) internal pure returns (uint z) {
247         require(y !=0, 'ds-math-mul-overflow');
248         z = x / y;
249     }
250 }
251 
252 library UnifiLibrary {
253     using SafeMath for uint;
254 
255     // returns sorted token addresses, used to handle return values from pairs sorted in this order
256     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
257         require(tokenA != tokenB, 'UnifiLibrary: IDENTICAL_ADDRESSES');
258         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
259         require(token0 != address(0), 'UnifiLibrary: ZERO_ADDRESS');
260     }
261 
262     // calculates the CREATE2 address for a pair without making any external calls
263     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
264         (address token0, address token1) = sortTokens(tokenA, tokenB);
265         pair = address(uint(keccak256(abi.encodePacked(
266                 hex'ff',
267                 factory,
268                 keccak256(abi.encodePacked(token0, token1)),
269                 hex'd0d4c4cd0848c93cb4fd1f498d7013ee6bfb25783ea21593d5834f5d250ece66' // init code hash
270             ))));
271     }
272 
273     // fetches and sorts the reserves for a pair
274     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
275         (address token0,) = sortTokens(tokenA, tokenB);
276         pairFor(factory, tokenA, tokenB);
277         (uint reserve0, uint reserve1,) = IUnifiPair(pairFor(factory, tokenA, tokenB)).getReserves();
278         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
279     }
280 
281     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
282     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
283         require(amountA > 0, 'UnifiLibraryR: INSUFFICIENT_AMOUNT');
284         require(reserveA > 0 && reserveB > 0, 'UnifiLibrary: INSUFFICIENT_LIQUIDITY');
285         amountB = amountA.mul(reserveB) / reserveA;
286     }
287 
288 
289 
290 
291 
292 }
293 
294 interface IERC20 {
295     event Approval(address indexed owner, address indexed spender, uint value);
296     event Transfer(address indexed from, address indexed to, uint value);
297 
298     function name() external view returns (string memory);
299     function symbol() external view returns (string memory);
300     function decimals() external view returns (uint8);
301     function totalSupply() external view returns (uint);
302     function balanceOf(address owner) external view returns (uint);
303     function allowance(address owner, address spender) external view returns (uint);
304 
305     function approve(address spender, uint value) external returns (bool);
306     function transfer(address to, uint value) external returns (bool);
307     function transferFrom(address from, address to, uint value) external returns (bool);
308 }
309 
310 interface IWETH {
311     function deposit() external payable;
312     function transfer(address to, uint value) external returns (bool);
313     function withdraw(uint) external;
314 }
315 
316 
317 interface IUnifiController {
318     function lp_BuyBackAmount(address pool) external pure returns(uint);
319     function feeSetter() external pure returns (address);
320     function WBNB() external pure returns (address);
321     function nativeFee() external pure returns(uint);
322     function nativeFeeTo() external pure returns(address);
323     function UNIFIUPVault() external pure returns (address);
324     function maxFee() external pure returns (uint );
325     function defaultFee() external pure returns (uint );
326     function isDisableFlashLoan(address pool) external pure returns (bool);
327     function pairFees(address pool) external pure returns (uint );
328     function UPMintable(address pool) external pure returns (bool );
329     function getMintRate(address _pool ) external pure returns (uint );
330     function getPairFee(address _pair) external view returns (uint);
331     function setUNIFIUPVault(address _UNIFIUPVault) external ;
332     function setDefaultFee( uint _fee) external ; 
333     function getPairUPFee(address _pair) external view returns(uint);
334     function defaultUPFeesTo() external view  returns(address);
335     function setPairFee(address _pair, uint _fee)external ;
336     function setFeeSetter(address _feeSetter)external ;
337     function getMintFeeConfig(address _pool) external view returns(uint,uint);
338     function poolPaused(address _pool)external view returns(bool);
339     function owner() external pure returns (address);
340     function ufc() external pure returns (address);
341     function uptoken() external pure returns (address);
342     function lp_UP_Balance(address pool) external pure returns (uint );
343     function lp_RewardPerToken(address pool) external pure returns (uint );
344     function lp_FeeState(address pool) external view returns (uint);
345     function lp_LastTrade(address pool) external returns (uint);
346     function lp_UPRemaining(address pool) external returns (uint);
347     function setMaxFee( uint _fee) external ; 
348     function lp_pathToTrade (address pool) external returns( address[] memory path);
349     function pathToTrade(address _pool)external view returns (address []memory path);
350     function setUPMintable( address _pair , bool _value) external ; 
351     function updateLPBalance(address _pair, uint _fee)external returns (bool);
352     function updateLPFeeState(address _pair, uint _fee)external returns (bool);
353     function updateLPLastTrade(address _pair, uint _fee)external returns (bool);
354     function updateLPLUPRemaining(address _pair, uint _fee)external returns (bool);
355     function mintUP(address toLP , uint amountETH )external payable  returns (uint);
356     function claimUP(address to,address upRecipient , uint liquidity,bool isDeposit,bool isWithdrawl, bool isClaim )external  returns (uint);
357 }
358 
359 contract UnifiRouter is IUnifiRouter02 {
360     using SafeMath for uint;
361 struct depositor{
362     uint amountA;
363     uint amountB;
364     uint tokenARemaining;
365     uint tokenBRemaining;
366     uint reserveA;
367     uint reserveB;
368     uint tokenAAmountThatWillChangetoTokenB;
369     uint amountBOptimal;
370     uint amountAOptimal;
371  
372     address[]  path;
373 }
374     address public owner ;
375     address public immutable override factory;
376     address public immutable override WETH;
377      IUnifiController public iuc ;
378     modifier ensure(uint deadline) {
379         require(deadline >= block.timestamp, 'UnifiRouter: EXPIRED');
380         _;
381     }
382 
383        constructor(address _factory,address _weth , address _iuc) public{
384         factory = _factory;
385         WETH = _weth;
386         iuc = IUnifiController(_iuc);
387         owner = msg.sender;
388     }
389 
390     function setUC(address _uc) public {
391         if(msg.sender == owner){
392             iuc = IUnifiController(_uc);
393         }
394     }
395     function transferOWnership(address _newOwner) public {
396         if(msg.sender == owner){
397             owner = _newOwner;
398         }
399     }
400     receive() external payable {
401         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
402     }
403 
404     // **** ADD LIQUIDITY ****
405     function _addLiquidity(
406         address tokenA,
407         address tokenB,
408         uint amountADesired,
409         uint amountBDesired,
410         uint amountAMin,
411         uint amountBMin
412     ) internal virtual returns (uint amountA, uint amountB) {
413         // create the pair if it doesn't exist yet
414         if (IUnifiFactory(factory).getPair(tokenA, tokenB) == address(0)) {
415             IUnifiFactory(factory).createPair(tokenA, tokenB);
416         }
417         (uint reserveA, uint reserveB) =  getReserves( tokenA, tokenB);
418         if (reserveA == 0 && reserveB == 0) {
419             (amountA, amountB) = (amountADesired, amountBDesired);
420         } else {
421             uint amountBOptimal = UnifiLibrary.quote(amountADesired, reserveA, reserveB);
422             if (amountBOptimal <= amountBDesired) {
423                 require(amountBOptimal >= amountBMin, 'UnifiRouter: INSUFFICIENT_B_AMOUNT');
424                 (amountA, amountB) = (amountADesired, amountBOptimal);
425             } else {
426                 uint amountAOptimal = UnifiLibrary.quote(amountBDesired, reserveB, reserveA);
427                 assert(amountAOptimal <= amountADesired);
428                 require(amountAOptimal >= amountAMin, 'UnifiRouter: INSUFFICIENT_A_AMOUNT');
429                 (amountA, amountB) = (amountAOptimal, amountBDesired);
430             }
431         }
432     }
433 
434 	
435     
436     
437     function addLiquidity(
438         address tokenA,
439         address tokenB,
440         uint amountADesired,
441         uint amountBDesired,
442         uint amountAMin,
443         uint amountBMin,
444         address to,
445         uint deadline
446     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
447         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
448         address pair = (IUnifiFactory(factory).getPair(tokenA, tokenB));
449         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
450         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
451         liquidity = IUnifiPair(pair).mint(to);
452     }
453     
454     
455     
456 
457 
458     
459     function getReserves(        address tokenA,      address tokenB) public view returns(uint reserveA, uint reserveB){
460         (address token0,address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
461         address pair = IUnifiFactory(factory).getPair(token0, token1) ;
462         (uint reserve0, uint reserve1,) = IUnifiPair(pair).getReserves();
463         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
464    
465     }
466 
467     function withdrawEth() external {
468 
469         require(iuc.owner() != address(0),"UnifiRouter: Not found");
470         uint balance = address(this).balance;
471         if(balance > 0 ){
472          payable(address(iuc.owner())).transfer( balance);
473         }
474     }
475     
476     function transferAccidentalTokens(IERC20 token ) external {
477 
478         require(iuc.owner() != address(0),"UnifiRouter: Not found");
479         uint balance = IERC20(token).balanceOf(address(this));
480         if(balance > 0 ){
481             IERC20(token).transfer(iuc.owner() ,balance);
482         }
483     }
484     function addLiquidityETH(
485         address token,
486         uint amountTokenDesired,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline
491     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
492         (amountToken, amountETH) = _addLiquidity(
493             token,
494             WETH,
495             amountTokenDesired,
496             msg.value,
497             amountTokenMin,
498             amountETHMin
499         );
500         address pair =IUnifiFactory(factory).getPair( token, WETH);
501         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
502         IWETH(WETH).deposit{value: amountETH}();
503         assert(IWETH(WETH).transfer(pair, amountETH));
504         liquidity = IUnifiPair(pair).mint(to);
505         // refund dust eth, if any
506         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
507     }
508 
509     // **** REMOVE LIQUIDITY ****
510     function removeLiquidity(
511         address tokenA,
512         address tokenB,
513         uint liquidity,
514         uint amountAMin,
515         uint amountBMin,
516         address to,
517         uint deadline
518     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
519         address pair = IUnifiFactory(factory).getPair( tokenA, tokenB);
520         IUnifiPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
521         (uint amount0, uint amount1) = IUnifiPair(pair).burn(to);
522         (address token0,) = UnifiLibrary.sortTokens(tokenA, tokenB);
523         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
524         require(amountA >= amountAMin, 'UnifiRouter: INSUFFICIENT_A_AMOUNT');
525         require(amountB >= amountBMin, 'UnifiRouter: INSUFFICIENT_B_AMOUNT');
526     }
527     
528 
529     
530 
531     
532 
533     function removeLiquidityETH(
534         address token,
535         uint liquidity,
536         uint amountTokenMin,
537         uint amountETHMin,
538         address to,
539         uint deadline
540     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
541         (amountToken, amountETH) = removeLiquidity(
542             token,
543             WETH,
544             liquidity,
545             amountTokenMin,
546             amountETHMin,
547             address(this),
548             deadline
549         );
550         TransferHelper.safeTransfer(token, to, amountToken);
551         IWETH(WETH).withdraw(amountETH);
552         TransferHelper.safeTransferETH(to, amountETH);
553     }
554     function removeLiquidityWithPermit(
555         address tokenA,
556         address tokenB,
557         uint liquidity,
558         uint amountAMin,
559         uint amountBMin,
560         address to,
561         uint deadline,
562         bool approveMax, uint8 v, bytes32 r, bytes32 s
563     ) external virtual override returns (uint amountA, uint amountB) {
564         address pair = IUnifiFactory(factory).getPair( tokenA, tokenB);
565         uint value = approveMax ? uint(-1) : liquidity;
566         IUnifiPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
567         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
568     }
569     function removeLiquidityETHWithPermit(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline,
576         bool approveMax, uint8 v, bytes32 r, bytes32 s
577     ) external virtual override returns (uint amountToken, uint amountETH) {
578         address pair = IUnifiFactory(factory).getPair(token, WETH);
579         uint value = approveMax ? uint(-1) : liquidity;
580         IUnifiPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
581         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
582     }
583 
584     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
585     function removeLiquidityETHSupportingFeeOnTransferTokens(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) public virtual override ensure(deadline) returns (uint amountETH) {
593         (, amountETH) = removeLiquidity(
594             token,
595             WETH,
596             liquidity,
597             amountTokenMin,
598             amountETHMin,
599             address(this),
600             deadline
601         );
602         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
603         IWETH(WETH).withdraw(amountETH);
604         TransferHelper.safeTransferETH(to, amountETH);
605     }
606     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external virtual override returns (uint amountETH) {
615         address pair = IUnifiFactory(factory).getPair( token, WETH);
616         uint value = approveMax ? uint(-1) : liquidity;
617         IUnifiPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
618         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
619             token, liquidity, amountTokenMin, amountETHMin, to, deadline
620         );
621     }
622 
623     // **** SWAP ****
624     // requires the initial amount to have already been sent to the first pair
625     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
626         for (uint i; i < path.length - 1; i++) {
627             (address input, address output) = (path[i], path[i + 1]);
628             (address token0,) = UnifiLibrary.sortTokens(input, output);
629             uint amountOut = amounts[i + 1];
630             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
631             address to = i < path.length - 2 ? IUnifiFactory(factory).getPair( output, path[i + 2]) : _to;
632             IUnifiPair(IUnifiFactory(factory).getPair( input, output)).swap(
633                 amount0Out, amount1Out, to, new bytes(0)
634             );
635         }
636     }
637     function swapExactTokensForTokens(
638         uint amountIn,
639         uint amountOutMin,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
644         amounts = getAmountsOut( amountIn, path);
645         require(amounts[amounts.length - 1] >= amountOutMin, 'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT');
646         TransferHelper.safeTransferFrom(
647             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amounts[0]
648         );
649         _swap(amounts, path, to);
650     }
651     function swapTokensForExactTokens(
652         uint amountOut,
653         uint amountInMax,
654         address[] calldata path,
655         address to,
656         uint deadline
657     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
658         amounts = getAmountsIn( amountOut, path);
659         require(amounts[0] <= amountInMax, 'UnifiRouter: EXCESSIVE_INPUT_AMOUNT');
660         TransferHelper.safeTransferFrom(
661             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amounts[0]
662         );
663         _swap(amounts, path, to);
664     }
665     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
666         external
667         virtual
668         override
669         payable
670         ensure(deadline)
671         returns (uint[] memory amounts)
672     {
673         require(path[0] == WETH, 'UnifiRouter: INVALID_PATH');
674         amounts = getAmountsOut( msg.value, path);
675         require(amounts[amounts.length - 1] >= amountOutMin, 'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT');
676         IWETH(WETH).deposit{value: amounts[0]}();
677         assert(IWETH(WETH).transfer(IUnifiFactory(factory).getPair( path[0], path[1]), amounts[0]));
678         _swap(amounts, path, to);
679     }
680     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
681         external
682         virtual
683         override
684         ensure(deadline)
685         returns (uint[] memory amounts)
686     {
687         require(path[path.length - 1] == WETH, 'UnifiRouter: INVALID_PATH');
688         amounts = getAmountsIn( amountOut, path);
689         require(amounts[0] <= amountInMax, 'UnifiRouter: EXCESSIVE_INPUT_AMOUNT');
690         TransferHelper.safeTransferFrom(
691             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amounts[0]
692         );
693         _swap(amounts, path, address(this));
694         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
695         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
696     }
697     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
698         external
699         virtual
700         override
701         ensure(deadline)
702         returns (uint[] memory amounts)
703     {
704         require(path[path.length - 1] == WETH, 'UnifiRouter: INVALID_PATH');
705         amounts = getAmountsOut( amountIn, path);
706         require(amounts[amounts.length - 1] >= amountOutMin, 'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT');
707         TransferHelper.safeTransferFrom(
708             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amounts[0]
709         );
710         _swap(amounts, path, address(this));
711         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
712         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
713     }
714     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
715         external
716         virtual
717         override
718         payable
719         ensure(deadline)
720         returns (uint[] memory amounts)
721     {
722         require(path[0] == WETH, 'UnifiRouter: INVALID_PATH');
723         amounts = getAmountsIn( amountOut, path);
724         require(amounts[0] <= msg.value, 'UnifiRouter: EXCESSIVE_INPUT_AMOUNT');
725         IWETH(WETH).deposit{value: amounts[0]}();
726         assert(IWETH(WETH).transfer(IUnifiFactory(factory).getPair(path[0], path[1]), amounts[0]));
727         _swap(amounts, path, to);
728         // refund dust eth, if any
729         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
730     }
731 
732     // **** SWAP (supporting fee-on-transfer tokens) ****
733     // requires the initial amount to have already been sent to the first pair
734     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
735         for (uint i; i < path.length - 1; i++) {
736             (address input, address output) = (path[i], path[i + 1]);
737             (address token0,) = UnifiLibrary.sortTokens(input, output);
738             IUnifiPair pair = IUnifiPair(IUnifiFactory(factory).getPair( input, output));
739             uint amountInput;
740             uint amountOutput;
741             uint fee= iuc.getPairFee(IUnifiFactory(factory).getPair(path[i],path[i+1]));
742             { // scope to avoid stack too deep errors
743             (uint reserve0, uint reserve1,) = pair.getReserves();
744             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
745             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
746             amountOutput = getAmountOut(amountInput, reserveInput, reserveOutput,fee);
747             }
748             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
749             address to = i < path.length - 2 ? IUnifiFactory(factory).getPair(output, path[i + 2]) : _to;
750             pair.swap(amount0Out, amount1Out, to, new bytes(0));
751         }
752     }
753     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
754         uint amountIn,
755         uint amountOutMin,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external virtual override ensure(deadline) {
760         TransferHelper.safeTransferFrom(
761             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amountIn
762         );
763         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
764         _swapSupportingFeeOnTransferTokens(path, to);
765         require(
766             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
767             'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT'
768         );
769     }
770     function swapExactETHForTokensSupportingFeeOnTransferTokens(
771         uint amountOutMin,
772         address[] calldata path,
773         address to,
774         uint deadline
775     )
776         external
777         virtual
778         override
779         payable
780         ensure(deadline)
781     {
782         require(path[0] == WETH, 'UnifiRouter: INVALID_PATH');
783         uint amountIn = msg.value;
784         IWETH(WETH).deposit{value: amountIn}();
785         assert(IWETH(WETH).transfer(IUnifiFactory(factory).getPair(path[0], path[1]), amountIn));
786         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
787         _swapSupportingFeeOnTransferTokens(path, to);
788         require(
789             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
790             'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT'
791         );
792     }
793     function swapExactTokensForETHSupportingFeeOnTransferTokens(
794         uint amountIn,
795         uint amountOutMin,
796         address[] calldata path,
797         address to,
798         uint deadline
799     )
800         external
801         virtual
802         override
803         ensure(deadline)
804     {
805         require(path[path.length - 1] == WETH, 'UnifiRouter: INVALID_PATH');
806         TransferHelper.safeTransferFrom(
807             path[0], msg.sender, IUnifiFactory(factory).getPair( path[0], path[1]), amountIn
808         );
809         _swapSupportingFeeOnTransferTokens(path, address(this));
810         uint amountOut = IERC20(WETH).balanceOf(address(this));
811         require(amountOut >= amountOutMin, 'UnifiRouter: INSUFFICIENT_OUTPUT_AMOUNT');
812         IWETH(WETH).withdraw(amountOut);
813         TransferHelper.safeTransferETH(to, amountOut);
814     }
815 
816     // **** LIBRARY FUNCTIONS ****
817     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
818         return UnifiLibrary.quote(amountA, reserveA, reserveB);
819     }
820 
821 
822 
823     function getAmountsOut(uint amountIn, address[] memory path)
824         public
825         view
826         virtual
827         override
828         returns (uint[] memory amounts)
829     {
830         require(path.length >= 2, 'UnifiLibrary: INVALID_PATH');
831         amounts = new uint[](path.length);
832         amounts[0] = amountIn;
833         for (uint i; i < path.length - 1; i++) {
834             (uint reserveIn, uint reserveOut) = getReserves(path[i], path[i + 1]);
835             uint fee = iuc.getPairFee(IUnifiFactory(factory).getPair(path[i],path[i+1]));
836             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut,fee);
837         }
838     }
839 
840 
841     function getAmountsIn(uint amountOut, address[] memory path)
842         public
843         view
844         virtual
845         override
846         returns (uint[] memory amounts)
847     {
848         
849        require(path.length >= 2, 'UnifiLibrary: INVALID_PATH');
850         amounts = new uint[](path.length);
851         amounts[amounts.length - 1] = amountOut;
852         for (uint i = path.length - 1; i > 0; i--) {
853             (uint reserveIn, uint reserveOut) = getReserves( path[i - 1], path[i]);
854             uint fee = iuc.getPairFee(IUnifiFactory(factory).getPair(path[i],path[i-1]));
855             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut,fee);
856         }
857 
858       
859     }
860     
861 
862       // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
863     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut,uint fee)       public
864         pure
865         virtual
866         override
867         returns (uint amountOut) {
868         require(amountIn > 0, 'UnifiLibrary: INSUFFICIENT_INPUT_AMOUNT');
869         require(reserveIn > 0 && reserveOut > 0, 'UnifiLibrary: INSUFFICIENT_LIQUIDITY');
870         uint amountInWithFee = amountIn.mul((1000-fee));
871         uint numerator = amountInWithFee.mul(reserveOut);
872         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
873         amountOut = numerator / denominator;
874     }
875 
876     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
877     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut,uint fee)       public
878         pure
879         virtual
880         override
881         returns (uint amountIn) {
882         require(amountOut > 0, 'UnifiLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
883         require(reserveIn > 0 && reserveOut > 0, 'UnifiLibrary: INSUFFICIENT_LIQUIDITY');
884         uint numerator = reserveIn.mul(amountOut).mul(1000);
885         uint denominator = reserveOut.sub(amountOut).mul(1000- fee);
886         amountIn = (numerator / denominator).add(1);
887     }  
888     
889     function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1) {
890         require(tokenA != tokenB, 'UnifiLibrary: IDENTICAL_ADDRESSES');
891         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
892         require(token0 != address(0), 'UnifiLibrary: ZERO_ADDRESS');
893     }
894 
895 }