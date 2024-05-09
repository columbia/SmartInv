1 // File: contracts/interfaces/IUniswapV2Pair.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Pair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address, address) external;
54 }
55 
56 // File: contracts/interfaces/IUniswapV2ERC20.sol
57 
58 pragma solidity >=0.5.0;
59 
60 interface IUniswapV2ERC20 {
61     event Approval(address indexed owner, address indexed spender, uint value);
62     event Transfer(address indexed from, address indexed to, uint value);
63 
64     function name() external pure returns (string memory);
65     function symbol() external pure returns (string memory);
66     function decimals() external pure returns (uint8);
67     function totalSupply() external view returns (uint);
68     function balanceOf(address owner) external view returns (uint);
69     function allowance(address owner, address spender) external view returns (uint);
70 
71     function approve(address spender, uint value) external returns (bool);
72     function transfer(address to, uint value) external returns (bool);
73     function transferFrom(address from, address to, uint value) external returns (bool);
74 
75     function DOMAIN_SEPARATOR() external view returns (bytes32);
76     function PERMIT_TYPEHASH() external pure returns (bytes32);
77     function nonces(address owner) external view returns (uint);
78 
79     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
80 }
81 
82 // File: contracts/libraries/SafeMath.sol
83 
84 pragma solidity =0.6.12;
85 
86 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
87 
88 library SafeMath {
89     function add(uint x, uint y) internal pure returns (uint z) {
90         require((z = x + y) >= x, 'ds-math-add-overflow');
91     }
92 
93     function sub(uint x, uint y) internal pure returns (uint z) {
94         require((z = x - y) <= x, 'ds-math-sub-underflow');
95     }
96 
97     function mul(uint x, uint y) internal pure returns (uint z) {
98         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
99     }
100 }
101 
102 // File: contracts/UniswapV2ERC20.sol
103 
104 pragma solidity =0.6.12;
105 
106 
107 
108 contract UniswapV2ERC20 is IUniswapV2ERC20 {
109     using SafeMath for uint;
110 
111     string public override constant name = 'SashimiSwap';
112     string public override constant symbol = 'SALP';
113     uint8 public override constant decimals = 18;
114     uint  public override totalSupply;
115     mapping(address => uint) public override balanceOf;
116     mapping(address => mapping(address => uint)) public override allowance;
117 
118     bytes32 public override DOMAIN_SEPARATOR;
119     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
120     bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
121     mapping(address => uint) public override nonces;
122 
123     event Approval(address indexed owner, address indexed spender, uint value);
124     event Transfer(address indexed from, address indexed to, uint value);
125 
126     constructor() public {
127         uint chainId;
128         assembly {
129             chainId := chainid()
130         }
131         DOMAIN_SEPARATOR = keccak256(
132             abi.encode(
133                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
134                 keccak256(bytes(name)),
135                 keccak256(bytes('1')),
136                 chainId,
137                 address(this)
138             )
139         );
140     }
141 
142     function _mint(address to, uint value) internal {
143         totalSupply = totalSupply.add(value);
144         balanceOf[to] = balanceOf[to].add(value);
145         emit Transfer(address(0), to, value);
146     }
147 
148     function _burn(address from, uint value) internal {
149         balanceOf[from] = balanceOf[from].sub(value);
150         totalSupply = totalSupply.sub(value);
151         emit Transfer(from, address(0), value);
152     }
153 
154     function _approve(address owner, address spender, uint value) private {
155         allowance[owner][spender] = value;
156         emit Approval(owner, spender, value);
157     }
158 
159     function _transfer(address from, address to, uint value) private {
160         balanceOf[from] = balanceOf[from].sub(value);
161         balanceOf[to] = balanceOf[to].add(value);
162         emit Transfer(from, to, value);
163     }
164 
165     function approve(address spender, uint value) external override returns (bool) {
166         _approve(msg.sender, spender, value);
167         return true;
168     }
169 
170     function transfer(address to, uint value) external override returns (bool){
171         _transfer(msg.sender, to, value);
172         return true;
173     }
174 
175     function transferFrom(address from, address to, uint value) external override returns (bool) {
176         if (allowance[from][msg.sender] != uint(-1)) {
177             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
178         }
179         _transfer(from, to, value);
180         return true;
181     }
182 
183     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
184         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
185         bytes32 digest = keccak256(
186             abi.encodePacked(
187                 '\x19\x01',
188                 DOMAIN_SEPARATOR,
189                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
190             )
191         );
192         address recoveredAddress = ecrecover(digest, v, r, s);
193         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
194         _approve(owner, spender, value);
195     }
196 }
197 
198 // File: contracts/libraries/Math.sol
199 
200 pragma solidity =0.6.12;
201 
202 // a library for performing various math operations
203 
204 library Math {
205     function min(uint x, uint y) internal pure returns (uint z) {
206         z = x < y ? x : y;
207     }
208 
209     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
210     function sqrt(uint y) internal pure returns (uint z) {
211         if (y > 3) {
212             z = y;
213             uint x = y / 2 + 1;
214             while (x < z) {
215                 z = x;
216                 x = (y / x + x) / 2;
217             }
218         } else if (y != 0) {
219             z = 1;
220         }
221     }
222 }
223 
224 // File: contracts/libraries/UQ112x112.sol
225 
226 pragma solidity =0.6.12;
227 
228 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
229 
230 // range: [0, 2**112 - 1]
231 // resolution: 1 / 2**112
232 
233 library UQ112x112 {
234     uint224 constant Q112 = 2**112;
235 
236     // encode a uint112 as a UQ112x112
237     function encode(uint112 y) internal pure returns (uint224 z) {
238         z = uint224(y) * Q112; // never overflows
239     }
240 
241     // divide a UQ112x112 by a uint112, returning a UQ112x112
242     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
243         z = x / uint224(y);
244     }
245 }
246 
247 // File: contracts/interfaces/IERC20.sol
248 
249 pragma solidity >=0.5.0;
250 
251 interface IERC20 {
252     event Approval(address indexed owner, address indexed spender, uint value);
253     event Transfer(address indexed from, address indexed to, uint value);
254 
255     function name() external view returns (string memory);
256     function symbol() external view returns (string memory);
257     function decimals() external view returns (uint8);
258     function totalSupply() external view returns (uint);
259     function balanceOf(address owner) external view returns (uint);
260     function allowance(address owner, address spender) external view returns (uint);
261 
262     function approve(address spender, uint value) external returns (bool);
263     function transfer(address to, uint value) external returns (bool);
264     function transferFrom(address from, address to, uint value) external returns (bool);
265 }
266 
267 // File: contracts/interfaces/IUniswapV2Factory.sol
268 
269 pragma solidity >=0.5.0;
270 
271 interface IUniswapV2Factory {
272     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
273 
274     function feeTo() external view returns (address);
275     function feeToSetter() external view returns (address);
276     function migrator() external view returns (address);
277 
278     function getPair(address tokenA, address tokenB) external view returns (address pair);
279     function allPairs(uint) external view returns (address pair);
280     function allPairsLength() external view returns (uint);
281 
282     function createPair(address tokenA, address tokenB) external returns (address pair);
283 
284     function setFeeTo(address) external;
285     function setFeeToSetter(address) external;
286     function setMigrator(address) external;
287 }
288 
289 // File: contracts/interfaces/IUniswapV2Callee.sol
290 
291 pragma solidity >=0.5.0;
292 
293 interface IUniswapV2Callee {
294     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
295 }
296 
297 // File: @sashimiswap/periphery/contracts/interfaces/IUniswapV2Router01.sol
298 
299 pragma solidity >=0.6.2;
300 
301 interface IUniswapV2Router01 {
302     function factory() external pure returns (address);
303     function WETH() external pure returns (address);
304 
305     function addLiquidity(
306         address tokenA,
307         address tokenB,
308         uint amountADesired,
309         uint amountBDesired,
310         uint amountAMin,
311         uint amountBMin,
312         address to,
313         uint deadline
314     ) external returns (uint amountA, uint amountB, uint liquidity);
315     function addLiquidityETH(
316         address token,
317         uint amountTokenDesired,
318         uint amountTokenMin,
319         uint amountETHMin,
320         address to,
321         uint deadline
322     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
323     function removeLiquidity(
324         address tokenA,
325         address tokenB,
326         uint liquidity,
327         uint amountAMin,
328         uint amountBMin,
329         address to,
330         uint deadline
331     ) external returns (uint amountA, uint amountB);
332     function removeLiquidityETH(
333         address token,
334         uint liquidity,
335         uint amountTokenMin,
336         uint amountETHMin,
337         address to,
338         uint deadline
339     ) external returns (uint amountToken, uint amountETH);
340     function removeLiquidityWithPermit(
341         address tokenA,
342         address tokenB,
343         uint liquidity,
344         uint amountAMin,
345         uint amountBMin,
346         address to,
347         uint deadline,
348         bool approveMax, uint8 v, bytes32 r, bytes32 s
349     ) external returns (uint amountA, uint amountB);
350     function removeLiquidityETHWithPermit(
351         address token,
352         uint liquidity,
353         uint amountTokenMin,
354         uint amountETHMin,
355         address to,
356         uint deadline,
357         bool approveMax, uint8 v, bytes32 r, bytes32 s
358     ) external returns (uint amountToken, uint amountETH);
359     function swapExactTokensForTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external returns (uint[] memory amounts);
366     function swapTokensForExactTokens(
367         uint amountOut,
368         uint amountInMax,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external returns (uint[] memory amounts);
373     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
374         external
375         payable
376         returns (uint[] memory amounts);
377     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
378         external
379         returns (uint[] memory amounts);
380     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
381         external
382         returns (uint[] memory amounts);
383     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
384         external
385         payable
386         returns (uint[] memory amounts);
387 
388     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
389     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
390     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
391     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
392     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
393 }
394 
395 // File: @sashimiswap/periphery/contracts/interfaces/IUniswapV2Router02.sol
396 
397 pragma solidity >=0.6.2;
398 
399 
400 interface IUniswapV2Router02 is IUniswapV2Router01 {
401     function vault() external pure returns (address);
402     function owner() external pure returns (address);
403     function removeLiquidityETHSupportingFeeOnTransferTokens(
404         address token,
405         uint liquidity,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external returns (uint amountETH);
411     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline,
418         bool approveMax, uint8 v, bytes32 r, bytes32 s
419     ) external returns (uint amountETH);
420 
421     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
422         uint amountIn,
423         uint amountOutMin,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external;
428     function swapExactETHForTokensSupportingFeeOnTransferTokens(
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external payable;
434     function swapExactTokensForETHSupportingFeeOnTransferTokens(
435         uint amountIn,
436         uint amountOutMin,
437         address[] calldata path,
438         address to,
439         uint deadline
440     ) external;
441     function changeOwner(
442         address vaultAddress
443     ) external;
444     function setVault(
445         address vaultAddress
446     ) external;
447     function take(
448         address token, 
449         uint amount
450     ) external;
451     function getTokenInPair(address pair, address token) external view returns (uint balance);    
452 }
453 
454 // File: contracts/UniswapV2Pair.sol
455 
456 // SPDX-License-Identifier: MIT
457 pragma solidity =0.6.12;
458 
459 
460 
461 
462 
463 
464 
465 
466 
467 interface IMigrator {
468     // Return the desired amount of liquidity token that the migrator wants.
469     function desiredLiquidity() external view returns (uint256);
470 }
471 
472 contract UniswapV2Pair is UniswapV2ERC20 {
473     using SafeMath  for uint;
474     using UQ112x112 for uint224;
475 
476     uint public constant MINIMUM_LIQUIDITY = 10**3;
477     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
478 
479     address public factory;
480     address public router;
481     address public token0;
482     address public token1;
483 
484     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
485     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
486     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
487 
488     uint public price0CumulativeLast;
489     uint public price1CumulativeLast;
490     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
491 
492     uint private unlocked = 1;
493     modifier lock() {
494         require(unlocked == 1, 'UniswapV2: LOCKED');
495         unlocked = 0;
496         _;
497         unlocked = 1;
498     }
499 
500     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
501         _reserve0 = reserve0;
502         _reserve1 = reserve1;
503         _blockTimestampLast = blockTimestampLast;
504     }
505 
506     function _safeTransfer(address token, address to, uint value) private {
507         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
508         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
509     }
510 
511     event Mint(address indexed sender, uint amount0, uint amount1);
512     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
513     event Swap(
514         address indexed sender,
515         uint amount0In,
516         uint amount1In,
517         uint amount0Out,
518         uint amount1Out,
519         address indexed to
520     );
521     event Sync(uint112 reserve0, uint112 reserve1);
522 
523     constructor() public {
524         factory = msg.sender;
525     }
526 
527     function _getBalance(address _token) private view returns(uint balance){
528         return IUniswapV2Router02(router).getTokenInPair(address(this),_token);
529     }
530 
531     // called once by the factory at time of deployment
532     function initialize(address _token0, address _token1, address _router) external {
533         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
534         token0 = _token0;
535         token1 = _token1;
536         router = _router;
537     }
538 
539     // update reserves and, on the first call per block, price accumulators
540     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
541         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
542         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
543         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
544         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
545             // * never overflows, and + overflow is desired
546             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
547             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
548         }
549         reserve0 = uint112(balance0);
550         reserve1 = uint112(balance1);
551         blockTimestampLast = blockTimestamp;
552         emit Sync(reserve0, reserve1);
553     }
554 
555     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
556     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
557         address feeTo = IUniswapV2Factory(factory).feeTo();
558         feeOn = feeTo != address(0);
559         uint _kLast = kLast; // gas savings
560         if (feeOn) {
561             if (_kLast != 0) {
562                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
563                 uint rootKLast = Math.sqrt(_kLast);
564                 if (rootK > rootKLast) {
565                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
566                     uint denominator = rootK.mul(5).add(rootKLast);
567                     uint liquidity = numerator / denominator;
568                     if (liquidity > 0) _mint(feeTo, liquidity);
569                 }
570             }
571         } else if (_kLast != 0) {
572             kLast = 0;
573         }
574     }
575 
576     // this low-level function should be called from a contract which performs important safety checks
577     function mint(address to) external lock returns (uint liquidity) {
578         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
579         uint balance0 = _getBalance(token0);
580         uint balance1 = _getBalance(token1);
581         uint amount0 = balance0.sub(_reserve0);
582         uint amount1 = balance1.sub(_reserve1);
583 
584         bool feeOn = _mintFee(_reserve0, _reserve1);
585         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
586         if (_totalSupply == 0) {
587             address migrator = IUniswapV2Factory(factory).migrator();
588             if(migrator != address(0) && msg.sender == router){
589                 liquidity = IMigrator(migrator).desiredLiquidity();
590                 require(liquidity > 0 && liquidity != uint256(-1), "Bad desired liquidity");
591             } else {
592                 require(migrator == address(0), "Must not have migrator");
593                 liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
594                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
595             }
596         } else {
597             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
598         }
599         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
600         _mint(to, liquidity);
601 
602         _update(balance0, balance1, _reserve0, _reserve1);
603         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
604         emit Mint(msg.sender, amount0, amount1);
605     }
606 
607     // this low-level function should be called from a contract which performs important safety checks
608     function burn(address to) external lock returns (uint amount0, uint amount1) {
609         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
610         address _token0 = token0;                                // gas savings
611         address _token1 = token1;                                // gas savings
612         uint balance0 = _getBalance(_token0);
613         uint balance1 = _getBalance(_token1);
614         uint liquidity = balanceOf[address(this)];
615 
616         bool feeOn = _mintFee(_reserve0, _reserve1);
617         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
618         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
619         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
620         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
621         _burn(address(this), liquidity);
622         balance0 = balance0.sub(amount0);
623         balance1 = balance1.sub(amount1);
624 
625         _update(balance0, balance1, _reserve0, _reserve1);
626         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
627         emit Burn(msg.sender, amount0, amount1, to);
628     }
629 
630     // this low-level function should be called from a contract which performs important safety checks
631     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
632         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
633         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
634         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
635 
636         uint balance0;
637         uint balance1;
638         { // scope for _token{0,1}, avoids stack too deep errors
639         address _token0 = token0;
640         address _token1 = token1;
641         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
642         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
643         balance0 = _getBalance(_token0);
644         balance1 = _getBalance(_token1);
645         }
646         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
647         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
648         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
649         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
650         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
651         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
652         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
653         }
654 
655         _update(balance0, balance1, _reserve0, _reserve1);
656         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
657     }
658 
659     // force reserves to match balances
660     function sync() external lock {
661         _update(_getBalance(token0), _getBalance(token1), reserve0, reserve1);
662     }
663 }