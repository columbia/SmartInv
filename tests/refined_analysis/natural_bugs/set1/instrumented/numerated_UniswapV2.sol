1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-05
3  */
4 
5 // File: contracts/interfaces/IUniswapV2Pair.sol
6 
7 pragma solidity >=0.5.0;
8 
9 interface IUniswapV2Pair {
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     function name() external pure returns (string memory);
14 
15     function symbol() external pure returns (string memory);
16 
17     function decimals() external pure returns (uint8);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address owner) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 value) external returns (bool);
26 
27     function transfer(address to, uint256 value) external returns (bool);
28 
29     function transferFrom(
30         address from,
31         address to,
32         uint256 value
33     ) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36 
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38 
39     function nonces(address owner) external view returns (uint256);
40 
41     function permit(
42         address owner,
43         address spender,
44         uint256 value,
45         uint256 deadline,
46         uint8 v,
47         bytes32 r,
48         bytes32 s
49     ) external;
50 
51     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
52     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint256 amount0In,
56         uint256 amount1In,
57         uint256 amount0Out,
58         uint256 amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62 
63     function MINIMUM_LIQUIDITY() external pure returns (uint256);
64 
65     function factory() external view returns (address);
66 
67     function token0() external view returns (address);
68 
69     function token1() external view returns (address);
70 
71     function getReserves()
72         external
73         view
74         returns (
75             uint112 reserve0,
76             uint112 reserve1,
77             uint32 blockTimestampLast
78         );
79 
80     function price0CumulativeLast() external view returns (uint256);
81 
82     function price1CumulativeLast() external view returns (uint256);
83 
84     function kLast() external view returns (uint256);
85 
86     function mint(address to) external returns (uint256 liquidity);
87 
88     function burn(address to) external returns (uint256 amount0, uint256 amount1);
89 
90     function swap(
91         uint256 amount0Out,
92         uint256 amount1Out,
93         address to,
94         bytes calldata data
95     ) external;
96 
97     function skim(address to) external;
98 
99     function sync() external;
100 
101     function initialize(address, address) external;
102 }
103 
104 // File: contracts/interfaces/IUniswapV2ERC20.sol
105 
106 pragma solidity >=0.5.0;
107 
108 interface IUniswapV2ERC20 {
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     function name() external pure returns (string memory);
113 
114     function symbol() external pure returns (string memory);
115 
116     function decimals() external pure returns (uint8);
117 
118     function totalSupply() external view returns (uint256);
119 
120     function balanceOf(address owner) external view returns (uint256);
121 
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     function approve(address spender, uint256 value) external returns (bool);
125 
126     function transfer(address to, uint256 value) external returns (bool);
127 
128     function transferFrom(
129         address from,
130         address to,
131         uint256 value
132     ) external returns (bool);
133 
134     function DOMAIN_SEPARATOR() external view returns (bytes32);
135 
136     function PERMIT_TYPEHASH() external pure returns (bytes32);
137 
138     function nonces(address owner) external view returns (uint256);
139 
140     function permit(
141         address owner,
142         address spender,
143         uint256 value,
144         uint256 deadline,
145         uint8 v,
146         bytes32 r,
147         bytes32 s
148     ) external;
149 }
150 
151 // File: contracts/libraries/SafeMath.sol
152 
153 pragma solidity 0.6.9;
154 
155 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
156 
157 library SafeMath {
158     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
159         require((z = x + y) >= x, "ds-math-add-overflow");
160     }
161 
162     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
163         require((z = x - y) <= x, "ds-math-sub-underflow");
164     }
165 
166     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
167         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
168     }
169 }
170 
171 // File: contracts/UniswapV2ERC20.sol
172 
173 pragma solidity 0.6.9;
174 
175 contract UniswapV2ERC20 {
176     using SafeMath for uint256;
177 
178     string public constant name = "Uniswap V2";
179     string public constant symbol = "UNI-V2";
180     uint8 public constant decimals = 18;
181     uint256 public totalSupply;
182     mapping(address => uint256) public balanceOf;
183     mapping(address => mapping(address => uint256)) public allowance;
184 
185     bytes32 public DOMAIN_SEPARATOR;
186     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
187     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
188     mapping(address => uint256) public nonces;
189 
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     function _mint(address to, uint256 value) internal {
194         totalSupply = totalSupply.add(value);
195         balanceOf[to] = balanceOf[to].add(value);
196         emit Transfer(address(0), to, value);
197     }
198 
199     function _burn(address from, uint256 value) internal {
200         balanceOf[from] = balanceOf[from].sub(value);
201         totalSupply = totalSupply.sub(value);
202         emit Transfer(from, address(0), value);
203     }
204 
205     function _approve(
206         address owner,
207         address spender,
208         uint256 value
209     ) private {
210         allowance[owner][spender] = value;
211         emit Approval(owner, spender, value);
212     }
213 
214     function _transfer(
215         address from,
216         address to,
217         uint256 value
218     ) private {
219         balanceOf[from] = balanceOf[from].sub(value);
220         balanceOf[to] = balanceOf[to].add(value);
221         emit Transfer(from, to, value);
222     }
223 
224     function approve(address spender, uint256 value) external returns (bool) {
225         _approve(msg.sender, spender, value);
226         return true;
227     }
228 
229     function transfer(address to, uint256 value) external returns (bool) {
230         _transfer(msg.sender, to, value);
231         return true;
232     }
233 
234     function transferFrom(
235         address from,
236         address to,
237         uint256 value
238     ) external returns (bool) {
239         if (allowance[from][msg.sender] != uint256(-1)) {
240             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
241         }
242         _transfer(from, to, value);
243         return true;
244     }
245 
246     function permit(
247         address owner,
248         address spender,
249         uint256 value,
250         uint256 deadline,
251         uint8 v,
252         bytes32 r,
253         bytes32 s
254     ) external {
255         require(deadline >= block.timestamp, "UniswapV2: EXPIRED");
256         bytes32 digest = keccak256(
257             abi.encodePacked(
258                 "\x19\x01",
259                 DOMAIN_SEPARATOR,
260                 keccak256(
261                     abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
262                 )
263             )
264         );
265         address recoveredAddress = ecrecover(digest, v, r, s);
266         require(
267             recoveredAddress != address(0) && recoveredAddress == owner,
268             "UniswapV2: INVALID_SIGNATURE"
269         );
270         _approve(owner, spender, value);
271     }
272 }
273 
274 // File: contracts/libraries/Math.sol
275 
276 pragma solidity 0.6.9;
277 
278 // a library for performing various math operations
279 
280 library Math {
281     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
282         z = x < y ? x : y;
283     }
284 
285     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
286     function sqrt(uint256 y) internal pure returns (uint256 z) {
287         if (y > 3) {
288             z = y;
289             uint256 x = y / 2 + 1;
290             while (x < z) {
291                 z = x;
292                 x = (y / x + x) / 2;
293             }
294         } else if (y != 0) {
295             z = 1;
296         }
297     }
298 }
299 
300 // File: contracts/libraries/UQ112x112.sol
301 
302 pragma solidity 0.6.9;
303 
304 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
305 
306 // range: [0, 2**112 - 1]
307 // resolution: 1 / 2**112
308 
309 library UQ112x112 {
310     uint224 constant Q112 = 2**112;
311 
312     // encode a uint112 as a UQ112x112
313     function encode(uint112 y) internal pure returns (uint224 z) {
314         z = uint224(y) * Q112; // never overflows
315     }
316 
317     // divide a UQ112x112 by a uint112, returning a UQ112x112
318     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
319         z = x / uint224(y);
320     }
321 }
322 
323 // File: contracts/interfaces/IERC20.sol
324 
325 pragma solidity >=0.5.0;
326 
327 interface IERC20 {
328     event Approval(address indexed owner, address indexed spender, uint256 value);
329     event Transfer(address indexed from, address indexed to, uint256 value);
330 
331     function name() external view returns (string memory);
332 
333     function symbol() external view returns (string memory);
334 
335     function decimals() external view returns (uint8);
336 
337     function totalSupply() external view returns (uint256);
338 
339     function balanceOf(address owner) external view returns (uint256);
340 
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     function approve(address spender, uint256 value) external returns (bool);
344 
345     function transfer(address to, uint256 value) external returns (bool);
346 
347     function transferFrom(
348         address from,
349         address to,
350         uint256 value
351     ) external returns (bool);
352 }
353 
354 // File: contracts/interfaces/IUniswapV2Factory.sol
355 
356 pragma solidity >=0.5.0;
357 
358 interface IUniswapV2Factory {
359     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
360 
361     function feeTo() external view returns (address);
362 
363     function feeToSetter() external view returns (address);
364 
365     function getPair(address tokenA, address tokenB) external view returns (address pair);
366 
367     function allPairs(uint256) external view returns (address pair);
368 
369     function allPairsLength() external view returns (uint256);
370 
371     function createPair(address tokenA, address tokenB) external returns (address pair);
372 
373     function setFeeTo(address) external;
374 
375     function setFeeToSetter(address) external;
376 }
377 
378 // File: contracts/interfaces/IUniswapV2Callee.sol
379 
380 pragma solidity >=0.5.0;
381 
382 interface IUniswapV2Callee {
383     function uniswapV2Call(
384         address sender,
385         uint256 amount0,
386         uint256 amount1,
387         bytes calldata data
388     ) external;
389 }
390 
391 // File: contracts/UniswapV2Pair.sol
392 
393 pragma solidity 0.6.9;
394 
395 contract UniswapV2Pair is UniswapV2ERC20 {
396     using SafeMath for uint256;
397     using UQ112x112 for uint224;
398 
399     uint256 public constant MINIMUM_LIQUIDITY = 10**3;
400     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
401 
402     address public factory;
403     address public token0;
404     address public token1;
405 
406     uint112 private reserve0; // uses single storage slot, accessible via getReserves
407     uint112 private reserve1; // uses single storage slot, accessible via getReserves
408     uint32 private blockTimestampLast; // uses single storage slot, accessible via getReserves
409 
410     uint256 public price0CumulativeLast;
411     uint256 public price1CumulativeLast;
412     uint256 public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
413 
414     uint256 private unlocked = 1;
415     modifier lock() {
416         require(unlocked == 1, "UniswapV2: LOCKED");
417         unlocked = 0;
418         _;
419         unlocked = 1;
420     }
421 
422     function getReserves()
423         public
424         view
425         returns (
426             uint112 _reserve0,
427             uint112 _reserve1,
428             uint32 _blockTimestampLast
429         )
430     {
431         _reserve0 = reserve0;
432         _reserve1 = reserve1;
433         _blockTimestampLast = blockTimestampLast;
434     }
435 
436     function _safeTransfer(
437         address token,
438         address to,
439         uint256 value
440     ) private {
441         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
442         require(
443             success && (data.length == 0 || abi.decode(data, (bool))),
444             "UniswapV2: TRANSFER_FAILED"
445         );
446     }
447 
448     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
449     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
450     event Swap(
451         address indexed sender,
452         uint256 amount0In,
453         uint256 amount1In,
454         uint256 amount0Out,
455         uint256 amount1Out,
456         address indexed to
457     );
458     event Sync(uint112 reserve0, uint112 reserve1);
459 
460     constructor() public {
461         factory = msg.sender;
462     }
463 
464     // called once by the factory at time of deployment
465     function initialize(address _token0, address _token1) external {
466         require(msg.sender == factory, "UniswapV2: FORBIDDEN"); // sufficient check
467         token0 = _token0;
468         token1 = _token1;
469     }
470 
471     // update reserves and, on the first call per block, price accumulators
472     function _update(
473         uint256 balance0,
474         uint256 balance1,
475         uint112 _reserve0,
476         uint112 _reserve1
477     ) private {
478         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "UniswapV2: OVERFLOW");
479         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
480         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
481         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
482             // * never overflows, and + overflow is desired
483             price0CumulativeLast +=
484                 uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) *
485                 timeElapsed;
486             price1CumulativeLast +=
487                 uint256(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) *
488                 timeElapsed;
489         }
490         reserve0 = uint112(balance0);
491         reserve1 = uint112(balance1);
492         blockTimestampLast = blockTimestamp;
493         emit Sync(reserve0, reserve1);
494     }
495 
496     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
497     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
498         address feeTo = IUniswapV2Factory(factory).feeTo();
499         feeOn = feeTo != address(0);
500         uint256 _kLast = kLast; // gas savings
501         if (feeOn) {
502             if (_kLast != 0) {
503                 uint256 rootK = Math.sqrt(uint256(_reserve0).mul(_reserve1));
504                 uint256 rootKLast = Math.sqrt(_kLast);
505                 if (rootK > rootKLast) {
506                     uint256 numerator = totalSupply.mul(rootK.sub(rootKLast));
507                     uint256 denominator = rootK.mul(5).add(rootKLast);
508                     uint256 liquidity = numerator / denominator;
509                     if (liquidity > 0) _mint(feeTo, liquidity);
510                 }
511             }
512         } else if (_kLast != 0) {
513             kLast = 0;
514         }
515     }
516 
517     // this low-level function should be called from a contract which performs important safety checks
518     function mint(address to) external lock returns (uint256 liquidity) {
519         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
520         uint256 balance0 = IERC20(token0).balanceOf(address(this));
521         uint256 balance1 = IERC20(token1).balanceOf(address(this));
522         uint256 amount0 = balance0.sub(_reserve0);
523         uint256 amount1 = balance1.sub(_reserve1);
524 
525         bool feeOn = _mintFee(_reserve0, _reserve1);
526         uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
527         if (_totalSupply == 0) {
528             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
529             _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
530         } else {
531             liquidity = Math.min(
532                 amount0.mul(_totalSupply) / _reserve0,
533                 amount1.mul(_totalSupply) / _reserve1
534             );
535         }
536         require(liquidity > 0, "UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED");
537         _mint(to, liquidity);
538 
539         _update(balance0, balance1, _reserve0, _reserve1);
540         if (feeOn) kLast = uint256(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
541         emit Mint(msg.sender, amount0, amount1);
542     }
543 
544     // this low-level function should be called from a contract which performs important safety checks
545     function burn(address to) external lock returns (uint256 amount0, uint256 amount1) {
546         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
547         address _token0 = token0; // gas savings
548         address _token1 = token1; // gas savings
549         uint256 balance0 = IERC20(_token0).balanceOf(address(this));
550         uint256 balance1 = IERC20(_token1).balanceOf(address(this));
551         uint256 liquidity = balanceOf[address(this)];
552 
553         bool feeOn = _mintFee(_reserve0, _reserve1);
554         uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
555         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
556         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
557         require(amount0 > 0 && amount1 > 0, "UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED");
558         _burn(address(this), liquidity);
559         _safeTransfer(_token0, to, amount0);
560         _safeTransfer(_token1, to, amount1);
561         balance0 = IERC20(_token0).balanceOf(address(this));
562         balance1 = IERC20(_token1).balanceOf(address(this));
563 
564         _update(balance0, balance1, _reserve0, _reserve1);
565         if (feeOn) kLast = uint256(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
566         emit Burn(msg.sender, amount0, amount1, to);
567     }
568 
569     // this low-level function should be called from a contract which performs important safety checks
570     function swap(
571         uint256 amount0Out,
572         uint256 amount1Out,
573         address to,
574         bytes calldata data
575     ) external lock {
576         require(amount0Out > 0 || amount1Out > 0, "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT");
577         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
578         require(
579             amount0Out < _reserve0 && amount1Out < _reserve1,
580             "UniswapV2: INSUFFICIENT_LIQUIDITY"
581         );
582 
583         uint256 balance0;
584         uint256 balance1;
585         {
586             // scope for _token{0,1}, avoids stack too deep errors
587             address _token0 = token0;
588             address _token1 = token1;
589             require(to != _token0 && to != _token1, "UniswapV2: INVALID_TO");
590             if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
591             if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
592             if (data.length > 0)
593                 IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
594             balance0 = IERC20(_token0).balanceOf(address(this));
595             balance1 = IERC20(_token1).balanceOf(address(this));
596         }
597         uint256 amount0In = balance0 > _reserve0 - amount0Out
598             ? balance0 - (_reserve0 - amount0Out)
599             : 0;
600         uint256 amount1In = balance1 > _reserve1 - amount1Out
601             ? balance1 - (_reserve1 - amount1Out)
602             : 0;
603         require(amount0In > 0 || amount1In > 0, "UniswapV2: INSUFFICIENT_INPUT_AMOUNT");
604         {
605             // scope for reserve{0,1}Adjusted, avoids stack too deep errors
606             uint256 balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
607             uint256 balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
608             require(
609                 balance0Adjusted.mul(balance1Adjusted) >=
610                     uint256(_reserve0).mul(_reserve1).mul(1000**2),
611                 "UniswapV2: K"
612             );
613         }
614 
615         _update(balance0, balance1, _reserve0, _reserve1);
616         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
617     }
618 
619     // force balances to match reserves
620     function skim(address to) external lock {
621         address _token0 = token0; // gas savings
622         address _token1 = token1; // gas savings
623         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
624         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
625     }
626 
627     // force reserves to match balances
628     function sync() external lock {
629         _update(
630             IERC20(token0).balanceOf(address(this)),
631             IERC20(token1).balanceOf(address(this)),
632             reserve0,
633             reserve1
634         );
635     }
636 }
