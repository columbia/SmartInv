1 // File: contracts\sakeswap\libraries\SafeMath.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 pragma solidity =0.6.12;
5 
6 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
7 
8 library SafeMath {
9     function add(uint x, uint y) internal pure returns (uint z) {
10         require((z = x + y) >= x, 'ds-math-add-overflow');
11     }
12 
13     function sub(uint x, uint y) internal pure returns (uint z) {
14         require((z = x - y) <= x, 'ds-math-sub-underflow');
15     }
16 
17     function mul(uint x, uint y) internal pure returns (uint z) {
18         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
19     }
20 }
21 
22 // File: contracts\sakeswap\SakeSwapERC20.sol
23 
24 pragma solidity =0.6.12;
25 
26 
27 contract SakeSwapERC20 {
28     using SafeMath for uint;
29 
30     string public constant name = "SakeSwap LP Token";
31     string public constant symbol = "SLP";
32     uint8 public constant decimals = 18;
33     uint  public totalSupply;
34     mapping(address => uint) public balanceOf;
35     mapping(address => mapping(address => uint)) public allowance;
36 
37     bytes32 public DOMAIN_SEPARATOR;
38     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
39     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
40     mapping(address => uint) public nonces;
41 
42     event Approval(address indexed owner, address indexed spender, uint value);
43     event Transfer(address indexed from, address indexed to, uint value);
44 
45     constructor() public {
46         uint chainId;
47         assembly {
48             chainId := chainid()
49         }
50         DOMAIN_SEPARATOR = keccak256(
51             abi.encode(
52                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
53                 keccak256(bytes(name)),
54                 keccak256(bytes("1")),
55                 chainId,
56                 address(this)
57             )
58         );
59     }
60 
61     function _mint(address to, uint value) internal {
62         totalSupply = totalSupply.add(value);
63         balanceOf[to] = balanceOf[to].add(value);
64         emit Transfer(address(0), to, value);
65     }
66 
67     function _burn(address from, uint value) internal {
68         balanceOf[from] = balanceOf[from].sub(value);
69         totalSupply = totalSupply.sub(value);
70         emit Transfer(from, address(0), value);
71     }
72 
73     function _approve(address owner, address spender, uint value) private {
74         allowance[owner][spender] = value;
75         emit Approval(owner, spender, value);
76     }
77 
78     function _transfer(address from, address to, uint value) private {
79         balanceOf[from] = balanceOf[from].sub(value);
80         balanceOf[to] = balanceOf[to].add(value);
81         emit Transfer(from, to, value);
82     }
83 
84     function approve(address spender, uint value) external returns (bool) {
85         _approve(msg.sender, spender, value);
86         return true;
87     }
88 
89     function transfer(address to, uint value) external returns (bool) {
90         _transfer(msg.sender, to, value);
91         return true;
92     }
93 
94     function transferFrom(address from, address to, uint value) external returns (bool) {
95         if (allowance[from][msg.sender] != uint(-1)) {
96             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
97         }
98         _transfer(from, to, value);
99         return true;
100     }
101 
102     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
103         require(deadline >= block.timestamp, "SakeSwap: EXPIRED");
104         bytes32 digest = keccak256(
105             abi.encodePacked(
106                 "\x19\x01",
107                 DOMAIN_SEPARATOR,
108                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
109             )
110         );
111         address recoveredAddress = ecrecover(digest, v, r, s);
112         require(recoveredAddress != address(0) && recoveredAddress == owner, "SakeSwap: INVALID_SIGNATURE");
113         _approve(owner, spender, value);
114     }
115 }
116 
117 // File: contracts\sakeswap\libraries\Math.sol
118 
119 pragma solidity =0.6.12;
120 
121 // a library for performing various math operations
122 
123 library Math {
124     function min(uint x, uint y) internal pure returns (uint z) {
125         z = x < y ? x : y;
126     }
127 
128     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
129     function sqrt(uint y) internal pure returns (uint z) {
130         if (y > 3) {
131             z = y;
132             uint x = y / 2 + 1;
133             while (x < z) {
134                 z = x;
135                 x = (y / x + x) / 2;
136             }
137         } else if (y != 0) {
138             z = 1;
139         }
140     }
141 }
142 
143 // File: contracts\sakeswap\libraries\UQ112x112.sol
144 
145 pragma solidity =0.6.12;
146 
147 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
148 
149 // range: [0, 2**112 - 1]
150 // resolution: 1 / 2**112
151 
152 library UQ112x112 {
153     uint224 constant Q112 = 2**112;
154 
155     // encode a uint112 as a UQ112x112
156     function encode(uint112 y) internal pure returns (uint224 z) {
157         z = uint224(y) * Q112; // never overflows
158     }
159 
160     // divide a UQ112x112 by a uint112, returning a UQ112x112
161     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
162         z = x / uint224(y);
163     }
164 }
165 
166 // File: contracts\sakeswap\interfaces\IERC20.sol
167 
168 pragma solidity >=0.5.0;
169 
170 interface IERC20 {
171     event Approval(address indexed owner, address indexed spender, uint value);
172     event Transfer(address indexed from, address indexed to, uint value);
173 
174     function name() external view returns (string memory);
175     function symbol() external view returns (string memory);
176     function decimals() external view returns (uint8);
177     function totalSupply() external view returns (uint);
178     function balanceOf(address owner) external view returns (uint);
179     function allowance(address owner, address spender) external view returns (uint);
180 
181     function approve(address spender, uint value) external returns (bool);
182     function transfer(address to, uint value) external returns (bool);
183     function transferFrom(address from, address to, uint value) external returns (bool);
184     function mint(address to, uint value) external returns (bool);
185     function burn(address from, uint value) external returns (bool);
186 }
187 
188 // File: contracts\sakeswap\interfaces\ISakeSwapFactory.sol
189 
190 pragma solidity >=0.5.0;
191 
192 interface ISakeSwapFactory {
193     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
194 
195     function feeTo() external view returns (address);
196     function feeToSetter() external view returns (address);
197     function migrator() external view returns (address);
198 
199     function getPair(address tokenA, address tokenB) external view returns (address pair);
200     function allPairs(uint) external view returns (address pair);
201     function allPairsLength() external view returns (uint);
202 
203     function createPair(address tokenA, address tokenB) external returns (address pair);
204 
205     function setFeeTo(address) external;
206     function setFeeToSetter(address) external;
207     function setMigrator(address) external;
208 }
209 
210 // File: contracts\sakeswap\interfaces\ISakeSwapCallee.sol
211 
212 pragma solidity >=0.5.0;
213 
214 interface ISakeSwapCallee {
215     function SakeSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
216 }
217 
218 // File: contracts\sakeswap\interfaces\ISakeSwapPair.sol
219 
220 pragma solidity >=0.5.0;
221 
222 interface ISakeSwapPair {
223     event Approval(address indexed owner, address indexed spender, uint value);
224     event Transfer(address indexed from, address indexed to, uint value);
225 
226     function name() external pure returns (string memory);
227     function symbol() external pure returns (string memory);
228     function decimals() external pure returns (uint8);
229     function totalSupply() external view returns (uint);
230     function balanceOf(address owner) external view returns (uint);
231     function allowance(address owner, address spender) external view returns (uint);
232 
233     function approve(address spender, uint value) external returns (bool);
234     function transfer(address to, uint value) external returns (bool);
235     function transferFrom(address from, address to, uint value) external returns (bool);
236 
237     function DOMAIN_SEPARATOR() external view returns (bytes32);
238     function PERMIT_TYPEHASH() external pure returns (bytes32);
239     function nonces(address owner) external view returns (uint);
240 
241     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
242 
243     event Mint(address indexed sender, uint amount0, uint amount1);
244     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
245     event Swap(
246         address indexed sender,
247         uint amount0In,
248         uint amount1In,
249         uint amount0Out,
250         uint amount1Out,
251         address indexed to
252     );
253     event Sync(uint112 reserve0, uint112 reserve1);
254 
255     function MINIMUM_LIQUIDITY() external pure returns (uint);
256     function factory() external view returns (address);
257     function token0() external view returns (address);
258     function token1() external view returns (address);
259     function stoken() external view returns (address);
260     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
261     function price0CumulativeLast() external view returns (uint);
262     function price1CumulativeLast() external view returns (uint);
263     function kLast() external view returns (uint);
264 
265     function mint(address to) external returns (uint liquidity);
266     function burn(address to) external returns (uint amount0, uint amount1);
267     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
268     function skim(address to) external;
269     function sync() external;
270 
271     function initialize(address, address) external;
272     function dealSlippageWithIn(address[] calldata path, uint amountIn, address to, bool ifmint) external returns (uint amountOut);
273     function dealSlippageWithOut(address[] calldata path, uint amountOut, address to, bool ifmint) external returns (uint extra);
274     function getAmountOutMarket(address token, uint amountIn) external view returns (uint _out, uint t0Price);
275     function getAmountInMarket(address token, uint amountOut) external view returns (uint _in, uint t0Price);
276     function getAmountOutFinal(address token, uint256 amountIn) external view returns (uint256 amountOut, uint256 stokenAmount);
277     function getAmountInFinal(address token, uint256 amountOut) external view returns (uint256 amountIn, uint256 stokenAmount);
278     function getTokenMarketPrice(address token) external view returns (uint price);
279 }
280 
281 // File: contracts\sakeswap\SakeSwapSlippageToken.sol
282 
283 pragma solidity =0.6.12;
284 
285 
286 contract SakeSwapSlippageToken {
287     using SafeMath for uint;
288 
289     string public constant name = "SakeSwap Slippage Token";
290     string public constant symbol = "SST";
291     uint8 public constant decimals = 18;
292     uint  public totalSupply;
293     address private _owner;
294     mapping(address => uint) public balanceOf;
295     mapping(address => mapping(address => uint)) public allowance;
296 
297     event Approval(address indexed owner, address indexed spender, uint value);
298     event Transfer(address indexed from, address indexed to, uint value);
299 
300     modifier onlyOwner() {
301         require(_owner == msg.sender, "SlippageToken: Not Owner");
302         _;
303     }
304 
305     constructor(uint initialSupply) public {
306         _owner = msg.sender;
307         _mint(msg.sender, initialSupply);
308     }
309 
310     function _mint(address to, uint value) internal {
311         totalSupply = totalSupply.add(value);
312         balanceOf[to] = balanceOf[to].add(value);
313         emit Transfer(address(0), to, value);
314     }
315 
316     function _burn(address from, uint value) internal {
317         balanceOf[from] = balanceOf[from].sub(value);
318         totalSupply = totalSupply.sub(value);
319         emit Transfer(from, address(0), value);
320     }
321 
322     function _approve(address owner, address spender, uint value) private {
323         allowance[owner][spender] = value;
324         emit Approval(owner, spender, value);
325     }
326 
327     function _transfer(address from, address to, uint value) private {
328         balanceOf[from] = balanceOf[from].sub(value);
329         balanceOf[to] = balanceOf[to].add(value);
330         emit Transfer(from, to, value);
331     }
332 
333     function approve(address spender, uint value) external returns (bool) {
334         _approve(msg.sender, spender, value);
335         return true;
336     }
337 
338     function transfer(address to, uint value) external returns (bool) {
339         _transfer(msg.sender, to, value);
340         return true;
341     }
342 
343     function transferFrom(address from, address to, uint value) external returns (bool) {
344         if (allowance[from][msg.sender] != uint(-1)) {
345             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
346         }
347         _transfer(from, to, value);
348         return true;
349     }
350 
351     function mint(address to, uint value) external onlyOwner returns (bool) {
352         _mint(to, value);
353         return true;
354     }
355 
356     function burn(address from, uint value) external onlyOwner returns (bool) {
357         _burn(from, value);
358         return true;
359     }
360 }
361 
362 // File: contracts\sakeswap\SakeSwapPair.sol
363 
364 pragma solidity =0.6.12;
365 
366 
367 
368 
369 
370 
371 
372 
373 
374 interface IMigrator {
375     // Return the desired amount of liquidity token that the migrator wants.
376     function desiredLiquidity() external view returns (uint256);
377 }
378 
379 contract SakeSwapPair is SakeSwapERC20 {
380     using SafeMath for uint256;
381     using UQ112x112 for uint224;
382 
383     uint256 public constant MINIMUM_LIQUIDITY = 10**3;
384     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
385     uint256 public constant DECAY_PERIOD = 5 minutes;
386     uint256 public constant UQ112 = 2**112;
387 
388     address public factory;
389     address public token0;
390     address public token1;
391     SakeSwapSlippageToken public stoken;
392 
393     uint224 private virtualPrice; // token0 virtual price, uses single storage slot
394     uint32 private lastPriceTime; // the latest exchange time
395 
396     uint112 private reserve0; // uses single storage slot, accessible via getReserves
397     uint112 private reserve1; // uses single storage slot, accessible via getReserves
398     uint32 private blockTimestampLast; // uses single storage slot, accessible via getReserves
399 
400     uint256 public price0CumulativeLast;
401     uint256 public price1CumulativeLast;
402     uint256 public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
403 
404     uint256 private unlocked = 1;
405     modifier lock() {
406         require(unlocked == 1, "SakeSwap: LOCKED");
407         unlocked = 0;
408         _;
409         unlocked = 1;
410     }
411 
412     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
413         _reserve0 = reserve0;
414         _reserve1 = reserve1;
415         _blockTimestampLast = blockTimestampLast;
416     }
417 
418     function getVirtualPrice() public view returns (uint224 _virtualPrice, uint32 _lastPriceTime) {
419         _virtualPrice = virtualPrice;
420         _lastPriceTime = lastPriceTime;
421     }
422 
423     function _safeTransfer(address token, address to, uint256 value) private {
424         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
425         require(success && (data.length == 0 || abi.decode(data, (bool))), "SakeSwap: TRANSFER_FAILED");
426     }
427 
428     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
429     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
430     event Swap(
431         address indexed sender,
432         uint256 amount0In,
433         uint256 amount1In,
434         uint256 amount0Out,
435         uint256 amount1Out,
436         address indexed to
437     );
438     event Sync(uint112 reserve0, uint112 reserve1);
439 
440     constructor() public {
441         factory = msg.sender;
442     }
443 
444     // called once by the factory at time of deployment
445     function initialize(address _token0, address _token1) external {
446         require(msg.sender == factory, "SakeSwap: FORBIDDEN"); // sufficient check
447         token0 = _token0;
448         token1 = _token1;
449         stoken = new SakeSwapSlippageToken(0);
450     }
451 
452     // update reserves and, on the first call per block, price accumulators
453     function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private {
454         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "SakeSwap: OVERFLOW");
455         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
456         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
457         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
458             // * never overflows, and + overflow is desired
459             price0CumulativeLast += uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
460             price1CumulativeLast += uint256(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
461         }
462         reserve0 = uint112(balance0);
463         reserve1 = uint112(balance1);
464         blockTimestampLast = blockTimestamp;
465         emit Sync(reserve0, reserve1);
466     }
467 
468     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
469     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
470         address feeTo = ISakeSwapFactory(factory).feeTo();
471         feeOn = feeTo != address(0);
472         uint256 _kLast = kLast; // gas savings
473         if (feeOn) {
474             if (_kLast != 0) {
475                 uint256 rootK = Math.sqrt(uint256(_reserve0).mul(_reserve1));
476                 uint256 rootKLast = Math.sqrt(_kLast);
477                 if (rootK > rootKLast) {
478                     uint256 numerator = totalSupply.mul(rootK.sub(rootKLast));
479                     uint256 denominator = rootK.mul(5).add(rootKLast);
480                     uint256 liquidity = numerator / denominator;
481                     if (liquidity > 0) _mint(feeTo, liquidity);
482                 }
483             }
484         } else if (_kLast != 0) {
485             kLast = 0;
486         }
487     }
488 
489     // this low-level function should be called from a contract which performs important safety checks
490     function mint(address to) external lock returns (uint256 liquidity) {
491         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
492         uint balance0 = IERC20(token0).balanceOf(address(this));
493         uint balance1 = IERC20(token1).balanceOf(address(this));
494         uint amount0 = balance0.sub(_reserve0);
495         uint amount1 = balance1.sub(_reserve1);
496 
497         bool feeOn = _mintFee(_reserve0, _reserve1);
498         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
499         if (_totalSupply == 0) {
500             address migrator = ISakeSwapFactory(factory).migrator();
501             if (msg.sender == migrator) {
502                 liquidity = IMigrator(migrator).desiredLiquidity();
503                 require(liquidity > 0 && liquidity != uint256(-1), "SakeSwap: Bad desired liquidity");
504             } else {
505                 require(migrator == address(0), "SakeSwap: Must not have migrator");
506                 liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
507                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
508             }
509         } else {
510             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
511         }
512         require(liquidity > 0, "SakeSwap: INSUFFICIENT_LIQUIDITY_MINTED");
513         _mint(to, liquidity);
514 
515         _update(balance0, balance1, _reserve0, _reserve1);
516         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
517         emit Mint(msg.sender, amount0, amount1);
518     }
519 
520     // this low-level function should be called from a contract which performs important safety checks
521     function burn(address to) external lock returns (uint256 amount0, uint256 amount1) {
522         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
523         address _token0 = token0; // gas savings
524         address _token1 = token1; // gas savings
525         uint256 balance0 = IERC20(_token0).balanceOf(address(this));
526         uint256 balance1 = IERC20(_token1).balanceOf(address(this));
527 
528         bool feeOn = _mintFee(_reserve0, _reserve1);
529         {
530             uint256 liquidity = balanceOf[address(this)];
531             uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
532             amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
533             amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
534             require(amount0 > 0 && amount1 > 0, "SakeSwap: INSUFFICIENT_LIQUIDITY_BURNED");
535             _burn(address(this), liquidity);
536         }
537         _safeTransfer(_token0, to, amount0);
538         _safeTransfer(_token1, to, amount1);
539         balance0 = IERC20(_token0).balanceOf(address(this));
540         balance1 = IERC20(_token1).balanceOf(address(this));
541 
542         _update(balance0, balance1, _reserve0, _reserve1);
543         if (feeOn) kLast = uint256(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
544         emit Burn(msg.sender, amount0, amount1, to);
545     }
546 
547     function _updateVirtualPrice(uint112 _reserve0, uint112 _reserve1) internal {
548         (uint256 _virtualPrice, uint32 _lastPriceTime) = getVirtualPrice();
549         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
550         if (_lastPriceTime < blockTimestamp) {
551             uint256 currentPrice = uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0));
552             uint256 timePassed = Math.min(DECAY_PERIOD, block.timestamp.sub(_lastPriceTime));
553             uint256 timeRemain = DECAY_PERIOD.sub(timePassed);
554             uint256 price = _virtualPrice.mul(timeRemain).add(currentPrice.mul(timePassed)) / (DECAY_PERIOD);
555             virtualPrice = uint224(price);
556             lastPriceTime = blockTimestamp;
557         }
558     }
559 
560     // this low-level function should be called from a contract which performs important safety checks
561     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external lock {
562         require(amount0Out > 0 || amount1Out > 0, "SakeSwap: INSUFFICIENT_OUTPUT_AMOUNT");
563         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
564         require(amount0Out < _reserve0 && amount1Out < _reserve1, "SakeSwap: INSUFFICIENT_LIQUIDITY");
565 
566         uint256 balance0;
567         uint256 balance1;
568         {
569             // scope for _token{0,1}, avoids stack too deep errors
570             address _token0 = token0;
571             address _token1 = token1;
572             require(to != _token0 && to != _token1, "SakeSwap: INVALID_TO");
573             if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
574             if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
575             if (data.length > 0) ISakeSwapCallee(to).SakeSwapCall(msg.sender, amount0Out, amount1Out, data);
576             balance0 = IERC20(_token0).balanceOf(address(this));
577             balance1 = IERC20(_token1).balanceOf(address(this));
578         }
579         uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
580         uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
581         require(amount0In > 0 || amount1In > 0, "SakeSwap: INSUFFICIENT_INPUT_AMOUNT");
582         {
583             // scope for reserve{0,1}Adjusted, avoids stack too deep errors
584             uint256 balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
585             uint256 balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
586             require(
587                 balance0Adjusted.mul(balance1Adjusted) >= uint256(_reserve0).mul(_reserve1).mul(1000**2),
588                 "SakeSwap: K"
589             );
590         }
591 
592         _updateVirtualPrice(_reserve0, _reserve1);
593         _update(balance0, balance1, _reserve0, _reserve1);
594 
595         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
596     }
597 
598     function _getToken0MarketPrice() internal view returns (uint256 price) {
599         (uint256 _virtualPrice, uint32 _lastPriceTime) = getVirtualPrice();
600         (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
601         uint256 currentPrice = uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0));
602         uint256 timePassed = Math.min(DECAY_PERIOD, block.timestamp.sub(_lastPriceTime));
603         uint256 timeRemain = DECAY_PERIOD.sub(timePassed);
604         price = _virtualPrice.mul(timeRemain).add(currentPrice.mul(timePassed)) / (DECAY_PERIOD);
605     }
606 
607     function getTokenMarketPrice(address token) external view returns (uint256 price) {
608         uint256 t0Price = _getToken0MarketPrice();
609         token == token0 ? price = t0Price : price = UQ112.mul(UQ112) / t0Price;
610     }
611 
612     function _getAmountOut(address token, uint256 amountIn, uint256 t0Price) internal view returns (uint256 _out) {
613         uint256 amountInWithFee = amountIn.mul(997);
614         if (token == token0) {
615             uint256 numerator = amountInWithFee.mul(t0Price);
616             uint256 denominator = UQ112.mul(1000);
617             _out = numerator / denominator;
618         } else {
619             uint256 numerator = amountInWithFee.mul(UQ112);
620             uint256 denominator = t0Price.mul(1000);
621             _out = numerator / denominator;
622         }
623     }
624 
625     function _getAmountIn(address token, uint256 amountOut, uint256 t0Price) internal view returns (uint256 _in) {
626         if (token == token0) {
627             uint256 numerator = amountOut.mul(1000).mul(t0Price);
628             uint256 denominator = UQ112.mul(997);
629             _in = numerator / denominator;
630         } else {
631             uint256 numerator = amountOut.mul(1000).mul(UQ112);
632             uint256 denominator = t0Price.mul(997);
633             _in = numerator / denominator;
634         }
635     }
636 
637     function getAmountOutMarket(address token, uint256 amountIn) public view returns (uint256 _out, uint256 t0Price) {
638         t0Price = _getToken0MarketPrice();
639         _out = _getAmountOut(token, amountIn, t0Price);
640     }
641 
642     function getAmountInMarket(address token, uint256 amountOut) public view returns (uint256 _in, uint256 t0Price) {
643         t0Price = _getToken0MarketPrice();
644         _in = _getAmountIn(token, amountOut, t0Price);
645     }
646 
647     function getAmountOutPool(address token, uint256 amountIn) public view returns (uint256 _out, uint256 t0Price) {
648         (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
649         t0Price = uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0));
650         _out = _getAmountOut(token, amountIn, t0Price);
651     }
652 
653     function getAmountInPool(address token, uint256 amountOut) public view returns (uint256 _in, uint256 t0Price) {
654         (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
655         t0Price = uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0));
656         _in = _getAmountIn(token, amountOut, t0Price);
657     }
658 
659     function getAmountOutReal(uint256 amountIn, uint256 _reserveIn, uint256 _reserveOut) internal pure returns (uint256 _out) {
660         uint256 amountInWithFee = amountIn.mul(997);
661         uint256 numerator = amountInWithFee.mul(_reserveOut);
662         uint256 denominator = _reserveIn.mul(1000).add(amountInWithFee);
663         _out = numerator / denominator;
664     }
665 
666     function getAmountInReal(uint256 amountOut, uint256 _reserveIn, uint256 _reserveOut) internal pure returns (uint256 _in) {
667         uint256 numerator = _reserveIn.mul(amountOut).mul(1000);
668         uint256 denominator = _reserveOut.sub(amountOut).mul(997);
669         _in = (numerator / denominator).add(1);
670     }
671 
672     function getAmountOutFinal(address token, uint256 amountIn) external view returns (uint256 amountOut, uint256 stokenAmount) {
673         address _token0 = token0;
674         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
675         (uint256 _reserveIn, uint256 _reserveOut) = token == _token0 ? (_reserve0, _reserve1) : (_reserve1, _reserve0);
676 
677         uint256 amountOutReal = getAmountOutReal(amountIn, _reserveIn, _reserveOut);
678         (uint256 amountOutMarket, ) = getAmountOutMarket(token, amountIn);
679         amountOut = amountOutReal;
680 
681         // arbitrager
682         if (amountOutReal > amountOutMarket) {
683             uint256 slippage = amountOutReal.sub(amountOutMarket);
684             uint256 halfSlippage = slippage / 2;
685             amountOut = amountOutReal.sub(halfSlippage);
686         }
687 
688         (uint256 amountOutPool, uint256 t0Price) = getAmountOutPool(token, amountIn);
689         uint256 slippage = amountOutPool.sub(amountOutReal);
690         stokenAmount = token == _token0 ? slippage : slippage.mul(t0Price) / UQ112;
691     }
692 
693     function getAmountInFinal(address token, uint256 amountOut) external view returns (uint256 amountIn, uint256 stokenAmount) {
694         address _token0 = token0;
695         (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
696         (uint256 _reserveIn, uint256 _reserveOut) = token == _token0 ? (_reserve1, _reserve0) : (_reserve0, _reserve1);
697 
698         uint256 amountInReal = getAmountInReal(amountOut, _reserveIn, _reserveOut);
699         (uint256 amountInMarket, ) = getAmountInMarket(token, amountOut);
700         amountIn = amountInReal;
701 
702         // arbitrager
703         if (amountInReal < amountInMarket) {
704             uint256 slippage = amountInMarket.sub(amountInReal);
705             uint256 extra = slippage / 2;
706             amountIn = amountInReal.add(extra);
707         }
708 
709         (uint256 amountInPool, uint256 t0Price) = getAmountInPool(token, amountOut);
710         uint256 slippage = amountInReal.sub(amountInPool);
711         stokenAmount = token == _token0 ? slippage : slippage.mul(t0Price) / UQ112;
712     }
713 
714     function dealSlippageWithIn(address[] calldata path, uint256 amountIn, address to, bool ifmint) external lock returns (uint256 amountOut) {
715         require(path.length == 2, "SakeSwap: INVALID_PATH");
716         address _token0 = token0;
717         uint256 amountOutReal;
718         uint256 amountOutMarket;
719 
720         // avoids stack too deep errors
721         {
722             (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
723             (uint256 _reserveIn, uint256 _reserveOut) = path[0] == _token0
724                 ? (_reserve0, _reserve1)
725                 : (_reserve1, _reserve0);
726             amountOutReal = getAmountOutReal(amountIn, _reserveIn, _reserveOut);
727             amountOut = amountOutReal;
728             (amountOutMarket, ) = getAmountOutMarket(path[0], amountIn);
729             uint256 balance = IERC20(path[0]).balanceOf(address(this));
730             uint256 amount = balance.sub(_reserveIn);
731             require(amount >= amountIn, "SakeSwap: Invalid Amount");
732         }
733 
734         // arbitrager
735         if (amountOutReal > amountOutMarket) {
736             uint256 slippageExtra = amountOutReal.sub(amountOutMarket);
737             uint256 halfSlippage = slippageExtra / 2;
738             amountOut = amountOutReal.sub(halfSlippage);
739         }
740 
741         if (ifmint == true) {
742             (uint256 amountOutPool, uint256 t0Price) = getAmountOutPool(path[0], amountIn);
743             uint256 slippage = amountOutPool.sub(amountOutReal);
744             uint256 mintAmount = path[1] == _token0 ? slippage.mul(t0Price) / UQ112 : slippage;
745             stoken.mint(to, mintAmount);
746         }
747     }
748 
749     function dealSlippageWithOut(address[] calldata path, uint256 amountOut, address to, bool ifmint) external lock returns (uint256 extra) {
750         require(path.length == 2, "SakeSwap: INVALID_PATH");
751         address _token0 = token0;
752         uint256 amountInReal;
753         uint256 amountInMarket;
754 
755         // avoids stack too deep errors
756         {
757             (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
758             (uint256 _reserveIn, uint256 _reserveOut) = path[0] == _token0
759                 ? (_reserve0, _reserve1)
760                 : (_reserve1, _reserve0);
761             amountInReal = getAmountInReal(amountOut, _reserveIn, _reserveOut);
762             (amountInMarket, ) = getAmountInMarket(path[1], amountOut);
763         }
764 
765         // arbitrager
766         if (amountInReal < amountInMarket) {
767             uint256 slippageExtra = amountInMarket.sub(amountInReal);
768             extra = slippageExtra / 2;
769         }
770 
771         if (ifmint == true) {
772             (uint256 amountInPool, uint256 t0Price) = getAmountInPool(path[1], amountOut);
773             uint256 slippage = amountInReal.sub(amountInPool);
774             uint256 mintAmount = path[0] == _token0 ? slippage.mul(t0Price) / UQ112 : slippage;
775             stoken.mint(to, mintAmount);
776         }
777     }
778 
779     // force balances to match reserves
780     function skim(address to) external lock {
781         address _token0 = token0; // gas savings
782         address _token1 = token1; // gas savings
783         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
784         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
785     }
786 
787     // force reserves to match balances
788     function sync() external lock {
789         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
790     }
791 }