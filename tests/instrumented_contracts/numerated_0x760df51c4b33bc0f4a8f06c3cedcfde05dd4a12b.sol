1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-05
3 */
4 
5 pragma solidity =0.6.6;
6 
7 interface IPokeFactory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9     function getPair(address tokenA, address tokenB) external view returns (address pair);
10     function createPair(address tokenA, address tokenB) external returns (address pair);
11 }
12 
13 interface IPokePair {
14 
15     function name() external pure returns (string memory);
16     function symbol() external pure returns (string memory);
17     function decimals() external pure returns (uint8);
18     function totalSupply() external view returns (uint);
19     function balanceOf(address owner) external view returns (uint);
20     function allowance(address owner, address spender) external view returns (uint);
21 
22     function approve(address spender, uint value) external returns (bool);
23     function transfer(address to, uint value) external returns (bool);
24     function transferFrom(address from, address to, uint value) external returns (bool);
25 
26     function DOMAIN_SEPARATOR() external view returns (bytes32);
27     function PERMIT_TYPEHASH() external pure returns (bytes32);
28     function nonces(address owner) external view returns (uint);
29 
30     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
31 
32 
33     function MINIMUM_LIQUIDITY() external pure returns (uint);
34     function factory() external view returns (address);
35     function token0() external view returns (address);
36     function token1() external view returns (address);
37     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
38     function price0CumulativeLast() external view returns (uint);
39     function price1CumulativeLast() external view returns (uint);
40     function kLast() external view returns (uint);
41 
42     function mint(address to) external returns (uint liquidity);
43     function burn(address to) external returns (uint amount0, uint amount1);
44     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
45     function skim(address to) external;
46     function sync() external;
47 
48     function initialize(address, address) external;
49 }
50 
51 interface IPokeRouter01 {
52     function factory() external pure returns (address);
53     function WETH() external pure returns (address);
54 
55     function addLiquidity(
56         address tokenA,
57         address tokenB,
58         uint amountADesired,
59         uint amountBDesired,
60         uint amountAMin,
61         uint amountBMin,
62         address to,
63         uint deadline
64     ) external returns (uint amountA, uint amountB, uint liquidity);
65     function addLiquidityETH(
66         address token,
67         uint amountTokenDesired,
68         uint amountTokenMin,
69         uint amountETHMin,
70         address to,
71         uint deadline
72     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
73     function removeLiquidity(
74         address tokenA,
75         address tokenB,
76         uint liquidity,
77         uint amountAMin,
78         uint amountBMin,
79         address to,
80         uint deadline
81     ) external returns (uint amountA, uint amountB);
82     function removeLiquidityETH(
83         address token,
84         uint liquidity,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external returns (uint amountToken, uint amountETH);
90     function removeLiquidityWithPermit(
91         address tokenA,
92         address tokenB,
93         uint liquidity,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline,
98         bool approveMax, uint8 v, bytes32 r, bytes32 s
99     ) external returns (uint amountA, uint amountB);
100     function removeLiquidityETHWithPermit(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline,
107         bool approveMax, uint8 v, bytes32 r, bytes32 s
108     ) external returns (uint amountToken, uint amountETH);
109     function swapExactTokensForTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external returns (uint[] memory amounts);
116     function swapTokensForExactTokens(
117         uint amountOut,
118         uint amountInMax,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external returns (uint[] memory amounts);
123     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
124         external
125         payable
126         returns (uint[] memory amounts);
127     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
128         external
129         returns (uint[] memory amounts);
130     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
131         external
132         returns (uint[] memory amounts);
133     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
134         external
135         payable
136         returns (uint[] memory amounts);
137 
138     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
139     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
140     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
141     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
142     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
143 }
144 
145 interface IPokeRouter02 is IPokeRouter01 {
146     function removeLiquidityETHSupportingFeeOnTransferTokens(
147         address token,
148         uint liquidity,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) external returns (uint amountETH);
154     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
155         address token,
156         uint liquidity,
157         uint amountTokenMin,
158         uint amountETHMin,
159         address to,
160         uint deadline,
161         bool approveMax, uint8 v, bytes32 r, bytes32 s
162     ) external returns (uint amountETH);
163 
164     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171     function swapExactETHForTokensSupportingFeeOnTransferTokens(
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external payable;
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 }
185 
186 interface IERC20 {
187     event Approval(address indexed owner, address indexed spender, uint value);
188     event Transfer(address indexed from, address indexed to, uint value);
189 
190     function name() external view returns (string memory);
191     function symbol() external view returns (string memory);
192     function decimals() external view returns (uint8);
193     function totalSupply() external view returns (uint);
194     function balanceOf(address owner) external view returns (uint);
195     function allowance(address owner, address spender) external view returns (uint);
196 
197     function approve(address spender, uint value) external returns (bool);
198     function transfer(address to, uint value) external returns (bool);
199     function transferFrom(address from, address to, uint value) external returns (bool);
200 }
201 
202 interface IWETH {
203     function deposit() external payable;
204     function transfer(address to, uint value) external returns (bool);
205     function withdraw(uint) external;
206 }
207 
208 interface IBallsReward {
209     function getTotalAllocPoint() external view returns(uint);
210     function setPairUserPeriodAmount(address,address,uint) external;
211 
212 }
213 
214 contract PokeRouter is IPokeRouter02 {
215     using SafeMath for uint;
216 
217     address public immutable override factory;
218     address public immutable override WETH;
219     address public stakingAddress;
220     address public ballsToken;
221     address public owner;
222     address public rewardAddress;
223 
224     modifier ensure(uint deadline) {
225         require(deadline >= block.timestamp, 'PokeRouter: EXPIRED');
226         _;
227     }
228     modifier onlyOwner() {
229         require(owner == msg.sender);
230         _;
231     }
232     constructor(address _factory, address _WETH,address _skating ,address _ballsToken) public {
233         factory = _factory;
234         WETH = _WETH;
235         stakingAddress = _skating;
236         ballsToken = _ballsToken;
237         owner = msg.sender;
238     }
239     function setNewOwner(address _newOwner) public onlyOwner {
240         owner = _newOwner;
241     }
242     
243     function setRewardAddress(address _newReward) public onlyOwner {
244         rewardAddress = _newReward;
245     }
246     receive() external payable {
247         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
248     }
249 
250     
251     function _updatePairTradeAmount(address _pair,address _token ,address _sender,uint _amount) internal {
252         require(IBallsReward(rewardAddress).getTotalAllocPoint() > 0);
253         if(_token!=WETH){
254             address[] memory path = new address[](2);
255             path[0] = _token;
256             path[1] = WETH;
257             uint[] memory _amount_eth = PokeLibrary.getAmountsOut(factory, _amount, path);
258             _amount = _amount_eth[1];
259         }
260         IBallsReward(rewardAddress).setPairUserPeriodAmount(_pair,_sender,_amount);
261     }
262     
263     function _toBuyPlatToken(address _sender,address _token, uint _amount ,address[] memory path) internal {
264         //buyback plattoken
265         if(_token!=WETH && _token != ballsToken){
266             path[1] = WETH;
267             uint[] memory amounts = PokeLibrary.getAmountsOut(factory, _amount, path);
268             TransferHelper.safeTransferFrom(
269                     _token, _sender, PokeLibrary.pairFor(factory, path[0], path[1]), _amount
270                 );
271             _swap( amounts,  path,  address(this));
272             _token = WETH;
273         }
274         if(_token == WETH){
275             path[0] = WETH;
276             path[1] = ballsToken;
277             uint[] memory amounts1 = PokeLibrary.getAmountsOut(factory, IERC20(WETH).balanceOf(address(this)), path);
278             assert(IWETH(WETH).transfer(PokeLibrary.pairFor(factory, path[0], path[1]), IERC20(WETH).balanceOf(address(this))));
279             _swap( amounts1,  path,  address(this));
280         }
281         if(_token == ballsToken){
282             TransferHelper.safeTransferFrom(
283                     _token, _sender, stakingAddress, _amount
284                 );
285         }
286         
287         TransferHelper.safeTransfer( ballsToken, stakingAddress, IERC20(ballsToken).balanceOf(address(this)));
288     }
289    
290 
291     // **** ADD LIQUIDITY ****
292     function _addLiquidity(
293         address tokenA,
294         address tokenB,
295         uint amountADesired,
296         uint amountBDesired,
297         uint amountAMin,
298         uint amountBMin
299     ) internal virtual returns (uint amountA, uint amountB) {
300         // create the pair if it doesn't exist yet
301         if (IPokeFactory(factory).getPair(tokenA, tokenB) == address(0)) {
302             IPokeFactory(factory).createPair(tokenA, tokenB);
303         }
304         (uint reserveA, uint reserveB) = PokeLibrary.getReserves(factory, tokenA, tokenB);
305         if (reserveA == 0 && reserveB == 0) {
306             (amountA, amountB) = (amountADesired, amountBDesired);
307         } else {
308             uint amountBOptimal = PokeLibrary.quote(amountADesired, reserveA, reserveB);
309             if (amountBOptimal <= amountBDesired) {
310                 require(amountBOptimal >= amountBMin, 'PokeRouter: INSUFFICIENT_B_AMOUNT');
311                 (amountA, amountB) = (amountADesired, amountBOptimal);
312             } else {
313                 uint amountAOptimal = PokeLibrary.quote(amountBDesired, reserveB, reserveA);
314                 assert(amountAOptimal <= amountADesired);
315                 require(amountAOptimal >= amountAMin, 'PokeRouter: INSUFFICIENT_A_AMOUNT');
316                 (amountA, amountB) = (amountAOptimal, amountBDesired);
317             }
318         }
319     }
320     function addLiquidity(
321         address tokenA,
322         address tokenB,
323         uint amountADesired,
324         uint amountBDesired,
325         uint amountAMin,
326         uint amountBMin,
327         address to,
328         uint deadline
329     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
330         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
331         address pair = PokeLibrary.pairFor(factory, tokenA, tokenB);
332         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
333         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
334         liquidity = IPokePair(pair).mint(to);
335     }
336     function addLiquidityETH(
337         address token,
338         uint amountTokenDesired,
339         uint amountTokenMin,
340         uint amountETHMin,
341         address to,
342         uint deadline
343     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
344         (amountToken, amountETH) = _addLiquidity(
345             token,
346             WETH,
347             amountTokenDesired,
348             msg.value,
349             amountTokenMin,
350             amountETHMin
351         );
352         address pair = PokeLibrary.pairFor(factory, token, WETH);
353         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
354         IWETH(WETH).deposit{value: amountETH}();
355         assert(IWETH(WETH).transfer(pair, amountETH));
356         liquidity = IPokePair(pair).mint(to);
357         // refund dust eth, if any
358         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
359     }
360 
361     // **** REMOVE LIQUIDITY ****
362     function removeLiquidity(
363         address tokenA,
364         address tokenB,
365         uint liquidity,
366         uint amountAMin,
367         uint amountBMin,
368         address to,
369         uint deadline
370     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
371         address pair = PokeLibrary.pairFor(factory, tokenA, tokenB);
372         IPokePair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
373         (uint amount0, uint amount1) = IPokePair(pair).burn(to);
374         (address token0,) = PokeLibrary.sortTokens(tokenA, tokenB);
375         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
376         require(amountA >= amountAMin, 'PokeRouter: INSUFFICIENT_A_AMOUNT');
377         require(amountB >= amountBMin, 'PokeRouter: INSUFFICIENT_B_AMOUNT');
378     }
379     function removeLiquidityETH(
380         address token,
381         uint liquidity,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline
386     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
387         (amountToken, amountETH) = removeLiquidity(
388             token,
389             WETH,
390             liquidity,
391             amountTokenMin,
392             amountETHMin,
393             address(this),
394             deadline
395         );
396         TransferHelper.safeTransfer(token, to, amountToken);
397         IWETH(WETH).withdraw(amountETH);
398         TransferHelper.safeTransferETH(to, amountETH);
399     }
400     function removeLiquidityWithPermit(
401         address tokenA,
402         address tokenB,
403         uint liquidity,
404         uint amountAMin,
405         uint amountBMin,
406         address to,
407         uint deadline,
408         bool approveMax, uint8 v, bytes32 r, bytes32 s
409     ) external virtual override returns (uint amountA, uint amountB) {
410         address pair = PokeLibrary.pairFor(factory, tokenA, tokenB);
411         uint value = approveMax ? uint(-1) : liquidity;
412         IPokePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
413         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
414     }
415     function removeLiquidityETHWithPermit(
416         address token,
417         uint liquidity,
418         uint amountTokenMin,
419         uint amountETHMin,
420         address to,
421         uint deadline,
422         bool approveMax, uint8 v, bytes32 r, bytes32 s
423     ) external virtual override returns (uint amountToken, uint amountETH) {
424         address pair = PokeLibrary.pairFor(factory, token, WETH);
425         uint value = approveMax ? uint(-1) : liquidity;
426         IPokePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
427         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
428     }
429 
430     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
431     function removeLiquidityETHSupportingFeeOnTransferTokens(
432         address token,
433         uint liquidity,
434         uint amountTokenMin,
435         uint amountETHMin,
436         address to,
437         uint deadline
438     ) public virtual override ensure(deadline) returns (uint amountETH) {
439         (, amountETH) = removeLiquidity(
440             token,
441             WETH,
442             liquidity,
443             amountTokenMin,
444             amountETHMin,
445             address(this),
446             deadline
447         );
448         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
449         IWETH(WETH).withdraw(amountETH);
450         TransferHelper.safeTransferETH(to, amountETH);
451     }
452     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline,
459         bool approveMax, uint8 v, bytes32 r, bytes32 s
460     ) external virtual override returns (uint amountETH) {
461         address pair = PokeLibrary.pairFor(factory, token, WETH);
462         uint value = approveMax ? uint(-1) : liquidity;
463         IPokePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
464         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
465             token, liquidity, amountTokenMin, amountETHMin, to, deadline
466         );
467     }
468 
469     // **** SWAP ****
470     // requires the initial amount to have already been sent to the first pair
471     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
472         for (uint i; i < path.length - 1; i++) {
473             (address input, address output) = (path[i], path[i + 1]);
474             (address token0,) = PokeLibrary.sortTokens(input, output);
475             uint amountOut = amounts[i + 1];
476             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
477             address to = i < path.length - 2 ? PokeLibrary.pairFor(factory, output, path[i + 2]) : _to;
478             IPokePair(PokeLibrary.pairFor(factory, input, output)).swap(
479                 amount0Out, amount1Out, to, new bytes(0)
480             );
481         }
482     }
483     function swapExactTokensForTokens(
484         uint amountIn,
485         uint amountOutMin,
486         address[] calldata path,
487         address to,
488         uint deadline
489     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
490         uint feeValue = amountIn*5/10000;
491         amounts = PokeLibrary.getAmountsOut(factory, amountIn.sub(feeValue), path);
492         require(amounts[amounts.length - 1] >= amountOutMin, 'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
493         TransferHelper.safeTransferFrom(
494             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
495         );
496         _swap(amounts, path, to);
497         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
498         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
499     }
500     function swapTokensForExactTokens(
501         uint amountOut,
502         uint amountInMax,
503         address[] calldata path,
504         address to,
505         uint deadline
506     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
507         uint feeValue = amountOut*5/10000;
508         amounts = PokeLibrary.getAmountsIn(factory, amountOut.sub(feeValue), path);
509         require(amounts[0] <= amountInMax, 'PokeRouter: EXCESSIVE_INPUT_AMOUNT');
510         TransferHelper.safeTransferFrom(
511             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
512         );
513         _swap(amounts, path, to);
514         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
515         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
516     }
517     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
518         external
519         virtual
520         override
521         payable
522         ensure(deadline)
523         returns (uint[] memory amounts)
524     {
525         require(path[0] == WETH, 'PokeRouter: INVALID_PATH');
526         
527         uint feeValue = msg.value*5/10000 ;
528         amounts = PokeLibrary.getAmountsOut(factory, msg.value.sub(feeValue), path);
529         require(amounts[amounts.length - 1] >= amountOutMin, 'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
530         IWETH(WETH).deposit{value: msg.value}();
531         assert(IWETH(WETH).transfer(PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
532         _swap(amounts, path, to);
533         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
534         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
535     }
536     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
537         external
538         virtual
539         override
540         ensure(deadline)
541         returns (uint[] memory amounts)
542     {
543         require(path[path.length - 1] == WETH, 'PokeRouter: INVALID_PATH');
544         
545         uint feeValue = amountOut*5/10000 ;
546         amounts = PokeLibrary.getAmountsIn(factory, amountOut.sub(feeValue), path);
547         require(amounts[0] <= amountInMax, 'PokeRouter: EXCESSIVE_INPUT_AMOUNT');
548         TransferHelper.safeTransferFrom(
549             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
550         );
551         _swap(amounts, path, address(this));
552         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
553         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
554         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
555         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
556     }
557     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
558         external
559         virtual
560         override
561         ensure(deadline)
562         returns (uint[] memory amounts)
563     {
564         require(path[path.length - 1] == WETH, 'PokeRouter: INVALID_PATH');
565         
566         uint feeValue = amountIn*5/10000 ;
567         amounts = PokeLibrary.getAmountsOut(factory, amountIn.sub(feeValue), path);
568         require(amounts[amounts.length - 1] >= amountOutMin, 'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
569         TransferHelper.safeTransferFrom(
570             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
571         );
572         _swap(amounts, path, address(this));
573         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
574         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
575         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
576         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
577     }
578     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
579         external
580         virtual
581         override
582         payable
583         ensure(deadline)
584         returns (uint[] memory amounts)
585     {
586         require(path[0] == WETH, 'PokeRouter: INVALID_PATH');
587         
588         uint feeValue = amountOut*5/10000 ;
589         amounts = PokeLibrary.getAmountsIn(factory, amountOut.sub(feeValue), path);
590         require(amounts[0] <= msg.value, 'PokeRouter: EXCESSIVE_INPUT_AMOUNT');
591         IWETH(WETH).deposit{value: amountOut}();
592         assert(IWETH(WETH).transfer(PokeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
593         _swap(amounts, path, to);
594         // refund dust eth, if any
595         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
596         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
597         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amounts[0]);
598     }
599 
600     // **** SWAP (supporting fee-on-transfer tokens) ****
601     // requires the initial amount to have already been sent to the first pair
602     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
603         for (uint i; i < path.length - 1; i++) {
604             (address input, address output) = (path[i], path[i + 1]);
605             (address token0,) = PokeLibrary.sortTokens(input, output);
606             IPokePair pair = IPokePair(PokeLibrary.pairFor(factory, input, output));
607             uint amountInput;
608             uint amountOutput;
609             { // scope to avoid stack too deep errors
610             (uint reserve0, uint reserve1,) = pair.getReserves();
611             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
612             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
613             amountOutput = PokeLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
614             }
615             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
616             address to = i < path.length - 2 ? PokeLibrary.pairFor(factory, output, path[i + 2]) : _to;
617             pair.swap(amount0Out, amount1Out, to, new bytes(0));
618         }
619     }
620     
621     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
622         uint amountIn,
623         uint amountOutMin,
624         address[] calldata path,
625         address to,
626         uint deadline
627     ) external virtual override ensure(deadline) {
628         
629         uint feeValue = amountIn*5/10000 ;
630         TransferHelper.safeTransferFrom(
631             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amountIn.sub(feeValue)
632         );
633         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
634         _swapSupportingFeeOnTransferTokens(path, to);
635         require(
636             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
637             'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
638         );
639         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
640         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amountIn.sub(feeValue));
641     }
642     function swapExactETHForTokensSupportingFeeOnTransferTokens(
643         uint amountOutMin,
644         address[] calldata path,
645         address to,
646         uint deadline
647     )
648         external
649         virtual
650         override
651         payable
652         ensure(deadline)
653     {
654         require(path[0] == WETH, 'PokeRouter: INVALID_PATH');
655         
656         uint amountIn = msg.value;
657         IWETH(WETH).deposit{value: amountIn}();
658         uint feeValue = amountIn*5/10000 ;
659         assert(IWETH(WETH).transfer(PokeLibrary.pairFor(factory, path[0], path[1]), amountIn.sub(feeValue)));
660         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
661         _swapSupportingFeeOnTransferTokens(path, to);
662         require(
663             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
664             'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
665         );
666         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
667         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amountIn.sub(feeValue));
668     }
669     function swapExactTokensForETHSupportingFeeOnTransferTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     )
676         external
677         virtual
678         override
679         ensure(deadline)
680     {
681         require(path[path.length - 1] == WETH, 'PokeRouter: INVALID_PATH');
682         
683         uint feeValue = amountIn*5/10000 ;
684         TransferHelper.safeTransferFrom(
685             path[0], msg.sender, PokeLibrary.pairFor(factory, path[0], path[1]), amountIn.sub(feeValue)
686         );
687         _swapSupportingFeeOnTransferTokens(path, address(this));
688         uint amountOut = IERC20(WETH).balanceOf(address(this));
689         require(amountOut >= amountOutMin, 'PokeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
690         IWETH(WETH).withdraw(amountOut);
691         TransferHelper.safeTransferETH(to, amountOut);
692         _toBuyPlatToken( msg.sender, path[0],  feeValue ,path);
693         _updatePairTradeAmount(PokeLibrary.pairFor(factory, path[0], path[1]),path[0],msg.sender,amountIn.sub(feeValue));
694     }
695 
696     // **** LIBRARY FUNCTIONS ****
697     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
698         return PokeLibrary.quote(amountA, reserveA, reserveB);
699     }
700 
701     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
702         public
703         pure
704         virtual
705         override
706         returns (uint amountOut)
707     {
708         return PokeLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
709     }
710 
711     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
712         public
713         pure
714         virtual
715         override
716         returns (uint amountIn)
717     {
718         return PokeLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
719     }
720 
721     function getAmountsOut(uint amountIn, address[] memory path)
722         public
723         view
724         virtual
725         override
726         returns (uint[] memory amounts)
727     {
728         return PokeLibrary.getAmountsOut(factory, amountIn, path);
729     }
730 
731     function getAmountsIn(uint amountOut, address[] memory path)
732         public
733         view
734         virtual
735         override
736         returns (uint[] memory amounts)
737     {
738         return PokeLibrary.getAmountsIn(factory, amountOut, path);
739     }
740 }
741 
742 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
743 
744 library SafeMath {
745     function add(uint x, uint y) internal pure returns (uint z) {
746         require((z = x + y) >= x, 'ds-math-add-overflow');
747     }
748 
749     function sub(uint x, uint y) internal pure returns (uint z) {
750         require((z = x - y) <= x, 'ds-math-sub-underflow');
751     }
752 
753     function mul(uint x, uint y) internal pure returns (uint z) {
754         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
755     }
756     
757     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
758         require(b > 0, errorMessage);
759         uint256 c = a / b;
760         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
761 
762         return c;
763     }
764     function div(uint256 a, uint256 b) internal pure returns (uint256) {
765         return div(a, b, "SafeMath: division by zero");
766     }
767 }
768 
769 library PokeLibrary {
770     using SafeMath for uint;
771 
772     // returns sorted token addresses, used to handle return values from pairs sorted in this order
773     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
774         require(tokenA != tokenB, 'PokeLibrary: IDENTICAL_ADDRESSES');
775         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
776         require(token0 != address(0), 'PokeLibrary: ZERO_ADDRESS');
777     }
778 
779     // calculates the CREATE2 address for a pair without making any external calls
780     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
781         (address token0, address token1) = sortTokens(tokenA, tokenB);
782         pair = address(uint(keccak256(abi.encodePacked(
783                 hex'ff',
784                 factory,
785                 keccak256(abi.encodePacked(token0, token1)),
786                 hex'4937e9c51bcbbc6d7614d23716d92f73a77dc8682a71192b746780302a9d64be' // init code hash
787             ))));
788     }
789 
790     // fetches and sorts the reserves for a pair
791     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
792         (address token0,) = sortTokens(tokenA, tokenB);
793         (uint reserve0, uint reserve1,) = IPokePair(pairFor(factory, tokenA, tokenB)).getReserves();
794         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
795     }
796 
797     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
798     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
799         require(amountA > 0, 'PokeLibrary: INSUFFICIENT_AMOUNT');
800         require(reserveA > 0 && reserveB > 0, 'PokeLibrary: INSUFFICIENT_LIQUIDITY');
801         amountB = amountA.mul(reserveB) / reserveA;
802     }
803 
804     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
805     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
806         require(amountIn > 0, 'PokeLibrary: INSUFFICIENT_INPUT_AMOUNT');
807         require(reserveIn > 0 && reserveOut > 0, 'PokeLibrary: INSUFFICIENT_LIQUIDITY');
808         uint amountInWithFee = amountIn.mul(9975);
809         uint numerator = amountInWithFee.mul(reserveOut);
810         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
811         amountOut = numerator / denominator;
812     }
813 
814     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
815     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
816         require(amountOut > 0, 'PokeLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
817         require(reserveIn > 0 && reserveOut > 0, 'PokeLibrary: INSUFFICIENT_LIQUIDITY');
818         uint numerator = reserveIn.mul(amountOut).mul(10000);
819         uint denominator = reserveOut.sub(amountOut).mul(9975);
820         amountIn = (numerator / denominator).add(1);
821     }
822 
823     // performs chained getAmountOut calculations on any number of pairs
824     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
825         require(path.length >= 2, 'PokeLibrary: INVALID_PATH');
826         amounts = new uint[](path.length);
827         amounts[0] = amountIn;
828         for (uint i; i < path.length - 1; i++) {
829             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
830             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
831         }
832     }
833 
834     // performs chained getAmountIn calculations on any number of pairs
835     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
836         require(path.length >= 2, 'PokeLibrary: INVALID_PATH');
837         amounts = new uint[](path.length);
838         amounts[amounts.length - 1] = amountOut;
839         for (uint i = path.length - 1; i > 0; i--) {
840             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
841             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
842         }
843     }
844 }
845 
846 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
847 library TransferHelper {
848     function safeApprove(address token, address to, uint value) internal {
849         // bytes4(keccak256(bytes('approve(address,uint256)')));
850         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
851         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
852     }
853 
854     function safeTransfer(address token, address to, uint value) internal {
855         // bytes4(keccak256(bytes('transfer(address,uint256)')));
856         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
857         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
858     }
859 
860     function safeTransferFrom(address token, address from, address to, uint value) internal {
861         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
862         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
863         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
864     }
865 
866     function safeTransferETH(address to, uint value) internal {
867         (bool success,) = to.call{value:value}(new bytes(0));
868         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
869     }
870 }