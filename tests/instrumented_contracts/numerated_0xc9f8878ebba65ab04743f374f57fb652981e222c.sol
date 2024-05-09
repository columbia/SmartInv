1 pragma solidity >=0.6.2;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 abstract contract Ownable is Context {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor () internal {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(_owner == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Can only be called by the current owner.
57      */
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 interface IUniswapV2Factory {
65     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
66 
67     function feeTo() external view returns (address);
68     function feeToSetter() external view returns (address);
69 
70     function getPair(address tokenA, address tokenB) external view returns (address pair);
71     function allPairs(uint) external view returns (address pair);
72     function allPairsLength() external view returns (uint);
73 
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 
76     function setFeeTo(address) external;
77     function setFeeToSetter(address) external;
78 }
79 
80 interface IUniswapV2Pair {
81     event Approval(address indexed owner, address indexed spender, uint value);
82     event Transfer(address indexed from, address indexed to, uint value);
83 
84     function name() external pure returns (string memory);
85     function symbol() external pure returns (string memory);
86     function decimals() external pure returns (uint8);
87     function totalSupply() external view returns (uint);
88     function balanceOf(address owner) external view returns (uint);
89     function allowance(address owner, address spender) external view returns (uint);
90 
91     function approve(address spender, uint value) external returns (bool);
92     function transfer(address to, uint value) external returns (bool);
93     function transferFrom(address from, address to, uint value) external returns (bool);
94 
95     function DOMAIN_SEPARATOR() external view returns (bytes32);
96     function PERMIT_TYPEHASH() external pure returns (bytes32);
97     function nonces(address owner) external view returns (uint);
98 
99     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
100 
101     event Mint(address indexed sender, uint amount0, uint amount1);
102     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
103     event Swap(
104         address indexed sender,
105         uint amount0In,
106         uint amount1In,
107         uint amount0Out,
108         uint amount1Out,
109         address indexed to
110     );
111     event Sync(uint112 reserve0, uint112 reserve1);
112 
113     function MINIMUM_LIQUIDITY() external pure returns (uint);
114     function factory() external view returns (address);
115     function token0() external view returns (address);
116     function token1() external view returns (address);
117     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
118     function price0CumulativeLast() external view returns (uint);
119     function price1CumulativeLast() external view returns (uint);
120     function kLast() external view returns (uint);
121 
122     function mint(address to) external returns (uint liquidity);
123     function burn(address to) external returns (uint amount0, uint amount1);
124     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
125     function skim(address to) external;
126     function sync() external;
127 
128     function initialize(address, address) external;
129 }
130 
131 interface IUniswapV2Router01 {
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134 
135     function addLiquidity(
136         address tokenA,
137         address tokenB,
138         uint amountADesired,
139         uint amountBDesired,
140         uint amountAMin,
141         uint amountBMin,
142         address to,
143         uint deadline
144     ) external returns (uint amountA, uint amountB, uint liquidity);
145     function addLiquidityETH(
146         address token,
147         uint amountTokenDesired,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline
152     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
153     function removeLiquidity(
154         address tokenA,
155         address tokenB,
156         uint liquidity,
157         uint amountAMin,
158         uint amountBMin,
159         address to,
160         uint deadline
161     ) external returns (uint amountA, uint amountB);
162     function removeLiquidityETH(
163         address token,
164         uint liquidity,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external returns (uint amountToken, uint amountETH);
170     function removeLiquidityWithPermit(
171         address tokenA,
172         address tokenB,
173         uint liquidity,
174         uint amountAMin,
175         uint amountBMin,
176         address to,
177         uint deadline,
178         bool approveMax, uint8 v, bytes32 r, bytes32 s
179     ) external returns (uint amountA, uint amountB);
180     function removeLiquidityETHWithPermit(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline,
187         bool approveMax, uint8 v, bytes32 r, bytes32 s
188     ) external returns (uint amountToken, uint amountETH);
189     function swapExactTokensForTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external returns (uint[] memory amounts);
196     function swapTokensForExactTokens(
197         uint amountOut,
198         uint amountInMax,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external returns (uint[] memory amounts);
203     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
204         external
205         payable
206         returns (uint[] memory amounts);
207     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
208         external
209         returns (uint[] memory amounts);
210     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
211         external
212         returns (uint[] memory amounts);
213     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
214         external
215         payable
216         returns (uint[] memory amounts);
217 
218     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
219     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
220     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
221     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
222     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
223 }
224 
225 interface IUniswapV2Router02 is IUniswapV2Router01 {
226     function removeLiquidityETHSupportingFeeOnTransferTokens(
227         address token,
228         uint liquidity,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountETH);
234     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
235         address token,
236         uint liquidity,
237         uint amountTokenMin,
238         uint amountETHMin,
239         address to,
240         uint deadline,
241         bool approveMax, uint8 v, bytes32 r, bytes32 s
242     ) external returns (uint amountETH);
243 
244     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external;
251     function swapExactETHForTokensSupportingFeeOnTransferTokens(
252         uint amountOutMin,
253         address[] calldata path,
254         address to,
255         uint deadline
256     ) external payable;
257     function swapExactTokensForETHSupportingFeeOnTransferTokens(
258         uint amountIn,
259         uint amountOutMin,
260         address[] calldata path,
261         address to,
262         uint deadline
263     ) external;
264 }
265 
266 interface IERC20 {
267     event Approval(address indexed owner, address indexed spender, uint value);
268     event Transfer(address indexed from, address indexed to, uint value);
269 
270     function name() external view returns (string memory);
271     function symbol() external view returns (string memory);
272     function decimals() external view returns (uint8);
273     function totalSupply() external view returns (uint);
274     function balanceOf(address owner) external view returns (uint);
275     function allowance(address owner, address spender) external view returns (uint);
276 
277     function approve(address spender, uint value) external returns (bool);
278     function transfer(address to, uint value) external returns (bool);
279     function transferFrom(address from, address to, uint value) external returns (bool);
280 }
281 
282 interface IWETH {
283     function deposit() external payable;
284     function transfer(address to, uint value) external returns (bool);
285     function withdraw(uint) external;
286 }
287 
288 contract UniswapV2Router02 is IUniswapV2Router02, Ownable {
289     using SafeMath for uint;
290 
291     address public override factory;
292     address public override WETH;
293     address public _feeTarget0;
294     modifier ensure(uint deadline) {
295         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
296         _;
297     }
298 
299     constructor(address _factory, address _WETH) public {
300         factory = _factory;
301         WETH = _WETH;
302     }
303 
304     receive() external payable {
305         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
306     }
307 
308     uint256 _fee = 0;
309     uint256 _feeDivisor = 0;
310     event feeUpdate(uint256 fee, uint256 divisor);
311     event feeTarget(address target);
312     event updateWeth(address target);
313     event updateFactory(address target);
314     function updateFee (uint256 fee, uint256 divisor) public onlyOwner returns(bool){
315         _fee = fee;
316         _feeDivisor = divisor;
317         emit feeUpdate(fee,divisor);
318         return true;
319      }
320      function updateFeeTarget (address target) public onlyOwner returns(bool){
321         _feeTarget0 = target;
322         emit feeTarget(target);
323         return true;
324      }
325     function fee(uint256 amount) internal view returns(uint256){
326        uint256 feeTotal = amount * _fee/_feeDivisor;
327        uint256 receivable = amount - feeTotal;
328        return receivable;
329     }
330     function setWeth(address newWeth) public onlyOwner returns(bool){
331         WETH = newWeth;
332         emit updateWeth(newWeth);
333         return true;
334     }
335     function setFactory(address newFactory) public onlyOwner returns(bool){
336         factory = newFactory;
337         emit updateFactory(newFactory);
338         return true;
339     }
340     // **** ADD LIQUIDITY ****
341     function _addLiquidity(
342         address tokenA,
343         address tokenB,
344         uint amountADesired,
345         uint amountBDesired,
346         uint amountAMin,
347         uint amountBMin
348     ) internal virtual returns (uint amountA, uint amountB) {
349         // create the pair if it doesn't exist yet
350         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
351             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
352         }
353         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
354         if (reserveA == 0 && reserveB == 0) {
355             (amountA, amountB) = (amountADesired, amountBDesired);
356         } else {
357             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
358             if (amountBOptimal <= amountBDesired) {
359                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
360                 (amountA, amountB) = (amountADesired, amountBOptimal);
361             } else {
362                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
363                 assert(amountAOptimal <= amountADesired);
364                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
365                 (amountA, amountB) = (amountAOptimal, amountBDesired);
366             }
367         }
368     }
369     function addLiquidity(
370         address tokenA,
371         address tokenB,
372         uint amountADesired,
373         uint amountBDesired,
374         uint amountAMin,
375         uint amountBMin,
376         address to,
377         uint deadline
378     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
379         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
380         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
381         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
382         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
383         liquidity = IUniswapV2Pair(pair).mint(to);
384     }
385     function addLiquidityETH(
386         address token,
387         uint amountTokenDesired,
388         uint amountTokenMin,
389         uint amountETHMin,
390         address to,
391         uint deadline
392     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
393         (amountToken, amountETH) = _addLiquidity(
394             token,
395             WETH,
396             amountTokenDesired,
397             msg.value,
398             amountTokenMin,
399             amountETHMin
400         );
401         address pair = UniswapV2Library.pairFor(factory, token, WETH);
402         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
403         IWETH(WETH).deposit{value: amountETH}();
404         assert(IWETH(WETH).transfer(pair, amountETH));
405         liquidity = IUniswapV2Pair(pair).mint(to);
406         // refund dust eth, if any
407         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
408     }
409 
410     // **** REMOVE LIQUIDITY ****
411     function removeLiquidity(
412         address tokenA,
413         address tokenB,
414         uint liquidity,
415         uint amountAMin,
416         uint amountBMin,
417         address to,
418         uint deadline
419     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
420         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
421         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
422         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
423         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
424         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
425         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
426         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
427     }
428     function removeLiquidityETH(
429         address token,
430         uint liquidity,
431         uint amountTokenMin,
432         uint amountETHMin,
433         address to,
434         uint deadline
435     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
436         (amountToken, amountETH) = removeLiquidity(
437             token,
438             WETH,
439             liquidity,
440             amountTokenMin,
441             amountETHMin,
442             address(this),
443             deadline
444         );
445         TransferHelper.safeTransfer(token, to, amountToken);
446         IWETH(WETH).withdraw(amountETH);
447         TransferHelper.safeTransferETH(to, amountETH);
448     }
449     function removeLiquidityWithPermit(
450         address tokenA,
451         address tokenB,
452         uint liquidity,
453         uint amountAMin,
454         uint amountBMin,
455         address to,
456         uint deadline,
457         bool approveMax, uint8 v, bytes32 r, bytes32 s
458     ) external virtual override returns (uint amountA, uint amountB) {
459         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
460         uint value = approveMax ? uint(-1) : liquidity;
461         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
462         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
463     }
464     function removeLiquidityETHWithPermit(
465         address token,
466         uint liquidity,
467         uint amountTokenMin,
468         uint amountETHMin,
469         address to,
470         uint deadline,
471         bool approveMax, uint8 v, bytes32 r, bytes32 s
472     ) external virtual override returns (uint amountToken, uint amountETH) {
473         address pair = UniswapV2Library.pairFor(factory, token, WETH);
474         uint value = approveMax ? uint(-1) : liquidity;
475         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
476         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
477     }
478 
479     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
480     function removeLiquidityETHSupportingFeeOnTransferTokens(
481         address token,
482         uint liquidity,
483         uint amountTokenMin,
484         uint amountETHMin,
485         address to,
486         uint deadline
487     ) public virtual override ensure(deadline) returns (uint amountETH) {
488         (, amountETH) = removeLiquidity(
489             token,
490             WETH,
491             liquidity,
492             amountTokenMin,
493             amountETHMin,
494             address(this),
495             deadline
496         );
497         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
498         IWETH(WETH).withdraw(amountETH);
499         TransferHelper.safeTransferETH(to, amountETH);
500     }
501     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
502         address token,
503         uint liquidity,
504         uint amountTokenMin,
505         uint amountETHMin,
506         address to,
507         uint deadline,
508         bool approveMax, uint8 v, bytes32 r, bytes32 s
509     ) external virtual override returns (uint amountETH) {
510         address pair = UniswapV2Library.pairFor(factory, token, WETH);
511         uint value = approveMax ? uint(-1) : liquidity;
512         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
513         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
514             token, liquidity, amountTokenMin, amountETHMin, to, deadline
515         );
516     }
517 
518     // **** SWAP ****
519     // requires the initial amount to have already been sent to the first pair
520     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
521         for (uint i; i < path.length - 1; i++) {
522             (address input, address output) = (path[i], path[i + 1]);
523             (address token0,) = UniswapV2Library.sortTokens(input, output);
524             uint amountOut = amounts[i + 1];
525             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
526             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
527             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
528                 amount0Out, amount1Out, to, new bytes(0)
529             );
530         }
531     }
532     function swapExactTokensForTokens(
533         uint amountIn,
534         uint amountOutMin,
535         address[] calldata path,
536         address to,
537         uint deadline
538     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
539         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
540         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
541         uint256 fees = amounts[0]-fee(amounts[0]);
542         amounts[0] = fee(amounts[0]);
543         TransferHelper.safeTransferFrom(
544             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
545         );
546         TransferHelper.safeTransferFrom(
547             path[0], msg.sender, _feeTarget0, fees
548         );
549         _swap(amounts, path, to);
550     }
551     function swapTokensForExactTokens(
552         uint amountOut,
553         uint amountInMax,
554         address[] calldata path,
555         address to,
556         uint deadline
557     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
558         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
559         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
560         uint256 fees = amounts[0]-fee(amounts[0]);
561         amounts[0] = fee(amounts[0]);
562         TransferHelper.safeTransferFrom(
563             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
564         );
565         TransferHelper.safeTransferFrom(
566             path[0], msg.sender, _feeTarget0, fees
567         );
568         _swap(amounts, path, to);
569     }
570     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
571         external
572         virtual
573         override
574         payable
575         ensure(deadline)
576         returns (uint[] memory amounts)
577     {
578         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
579         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
580         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
581         IWETH(WETH).deposit{value: amounts[0]}();
582         uint256 fees = amounts[0]-fee(amounts[0]);
583         amounts[0] = fee(amounts[0]);
584         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
585         IWETH(WETH).transfer(_feeTarget0,fees);
586         _swap(amounts, path, to);
587     }
588     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589         external
590         virtual
591         override
592         ensure(deadline)
593         returns (uint[] memory amounts)
594     {
595         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
596         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
597         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
598         uint256 fees = amounts[0]-fee(amounts[0]);
599         amounts[0] = fee(amounts[0]);
600         TransferHelper.safeTransferFrom(
601             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
602         );
603         TransferHelper.safeTransferFrom(
604             path[0], msg.sender, _feeTarget0, fees
605         );
606         _swap(amounts, path, address(this));
607         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
608         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
609     }
610     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
611         external
612         virtual
613         override
614         ensure(deadline)
615         returns (uint[] memory amounts)
616     {
617         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
618         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
619         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
620         uint256 fees = amounts[0]-fee(amounts[0]);
621         amounts[0] = fee(amounts[0]);
622         TransferHelper.safeTransferFrom(
623             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
624         );
625         TransferHelper.safeTransferFrom(
626             path[0], msg.sender, _feeTarget0, fees
627         );
628         _swap(amounts, path, address(this));
629         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
630         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
631     }
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         virtual
635         override
636         payable
637         ensure(deadline)
638         returns (uint[] memory amounts)
639     {
640         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
641         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
642         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
643         IWETH(WETH).deposit{value: amounts[0]}();
644         uint256 fees = amounts[0]-fee(amounts[0]);
645         amounts[0] = fee(amounts[0]);
646         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
647         IWETH(WETH).transfer(_feeTarget0,fees);
648         _swap(amounts, path, to);
649         // refund dust eth, if any
650         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(_feeTarget0, msg.value - amounts[0]);
651     }
652 
653     // **** SWAP (supporting fee-on-transfer tokens) ****
654     // requires the initial amount to have already been sent to the first pair
655     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
656         for (uint i; i < path.length - 1; i++) {
657             (address input, address output) = (path[i], path[i + 1]);
658             (address token0,) = UniswapV2Library.sortTokens(input, output);
659             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
660             uint amountInput;
661             uint amountOutput;
662             { // scope to avoid stack too deep errors
663             (uint reserve0, uint reserve1,) = pair.getReserves();
664             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
665             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
666             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
667             }
668             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
669             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
670             pair.swap(amount0Out, amount1Out, to, new bytes(0));
671         }
672     }
673     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external virtual override ensure(deadline) {
680         uint256 newAmt = fee(amountIn);
681         uint256 fees = amountIn-newAmt;
682         TransferHelper.safeTransferFrom(
683             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), newAmt
684         );
685         TransferHelper.safeTransferFrom(
686             path[0], msg.sender, _feeTarget0, fees
687         );
688         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
689         _swapSupportingFeeOnTransferTokens(path, to);
690         require(
691             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
692             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
693         );
694     }
695     function swapExactETHForTokensSupportingFeeOnTransferTokens(
696         uint amountOutMin,
697         address[] calldata path,
698         address to,
699         uint deadline
700     )
701         external
702         virtual
703         override
704         payable
705         ensure(deadline)
706     {
707         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
708         uint amountIn = msg.value;
709         uint256 newAmt = fee(amountIn);
710         uint256 fees = amountIn-newAmt;
711         IWETH(WETH).deposit{value: amountIn}();
712         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), newAmt));
713         IWETH(WETH).transfer(_feeTarget0,fees);
714         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
715         _swapSupportingFeeOnTransferTokens(path, to);
716         require(
717             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
718             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
719         );
720     }
721     function swapExactTokensForETHSupportingFeeOnTransferTokens(
722         uint amountIn,
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     )
728         external
729         virtual
730         override
731         ensure(deadline)
732     {
733         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
734         TransferHelper.safeTransferFrom(
735             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
736         );
737         _swapSupportingFeeOnTransferTokens(path, address(this));
738         uint amountOut = IERC20(WETH).balanceOf(address(this));
739         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
740         uint256 newAmt = fee(amountOut);
741         uint256 fees = amountOut-newAmt;
742         IWETH(WETH).withdraw(amountOut);
743         TransferHelper.safeTransferETH(to, newAmt);
744         TransferHelper.safeTransferETH(_feeTarget0, fees);
745     }
746 
747     // **** LIBRARY FUNCTIONS ****
748     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
749         return UniswapV2Library.quote(amountA, reserveA, reserveB);
750     }
751 
752     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
753         public
754         pure
755         virtual
756         override
757         returns (uint amountOut)
758     {
759         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
760     }
761 
762     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
763         public
764         pure
765         virtual
766         override
767         returns (uint amountIn)
768     {
769         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
770     }
771 
772     function getAmountsOut(uint amountIn, address[] memory path)
773         public
774         view
775         virtual
776         override
777         returns (uint[] memory amounts)
778     {
779         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
780     }
781 
782     function getAmountsIn(uint amountOut, address[] memory path)
783         public
784         view
785         virtual
786         override
787         returns (uint[] memory amounts)
788     {
789         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
790     }
791 }
792 
793 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
794 
795 library SafeMath {
796     function add(uint x, uint y) internal pure returns (uint z) {
797         require((z = x + y) >= x, 'ds-math-add-overflow');
798     }
799 
800     function sub(uint x, uint y) internal pure returns (uint z) {
801         require((z = x - y) <= x, 'ds-math-sub-underflow');
802     }
803 
804     function mul(uint x, uint y) internal pure returns (uint z) {
805         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
806     }
807 }
808 
809 library UniswapV2Library {
810     using SafeMath for uint;
811 
812     // returns sorted token addresses, used to handle return values from pairs sorted in this order
813     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
814         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
815         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
816         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
817     }
818 
819     // calculates the CREATE2 address for a pair without making any external calls
820     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
821         (address token0, address token1) = sortTokens(tokenA, tokenB);
822         pair = address(uint(keccak256(abi.encodePacked(
823                 hex'ff',
824                 factory,
825                 keccak256(abi.encodePacked(token0, token1)),
826                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
827             ))));
828     }
829 
830     // fetches and sorts the reserves for a pair
831     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
832         (address token0,) = sortTokens(tokenA, tokenB);
833         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
834         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
835     }
836 
837     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
838     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
839         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
840         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
841         amountB = amountA.mul(reserveB) / reserveA;
842     }
843 
844     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
845     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
846         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
847         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
848         uint amountInWithFee = amountIn.mul(997);
849         uint numerator = amountInWithFee.mul(reserveOut);
850         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
851         amountOut = numerator / denominator;
852     }
853 
854     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
855     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
856         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
857         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
858         uint numerator = reserveIn.mul(amountOut).mul(1000);
859         uint denominator = reserveOut.sub(amountOut).mul(997);
860         amountIn = (numerator / denominator).add(1);
861     }
862 
863     // performs chained getAmountOut calculations on any number of pairs
864     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
865         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
866         amounts = new uint[](path.length);
867         amounts[0] = amountIn;
868         for (uint i; i < path.length - 1; i++) {
869             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
870             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
871         }
872     }
873 
874     // performs chained getAmountIn calculations on any number of pairs
875     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
876         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
877         amounts = new uint[](path.length);
878         amounts[amounts.length - 1] = amountOut;
879         for (uint i = path.length - 1; i > 0; i--) {
880             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
881             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
882         }
883     }
884 }
885 
886 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
887 library TransferHelper {
888     function safeApprove(address token, address to, uint value) internal {
889         // bytes4(keccak256(bytes('approve(address,uint256)')));
890         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
891         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
892     }
893 
894     function safeTransfer(address token, address to, uint value) internal {
895         // bytes4(keccak256(bytes('transfer(address,uint256)')));
896         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
897         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
898     }
899 
900     function safeTransferFrom(address token, address from, address to, uint value) internal {
901         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
902         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
903         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
904     }
905 
906     function safeTransferETH(address to, uint value) internal {
907         (bool success,) = to.call{value:value}(new bytes(0));
908         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
909     }
910 }