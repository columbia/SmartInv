1 // File: contracts/interfaces/IMostERC20.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IMostERC20 {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8     event LogRebase(uint indexed epoch, uint totalSupply);
9 
10     function name() external pure returns (string memory);
11     function symbol() external pure returns (string memory);
12     function decimals() external pure returns (uint8);
13     function totalSupply() external view returns (uint);
14     function epoch() external view returns (uint);
15     function balanceOf(address owner) external view returns (uint);
16     function allowance(address owner, address spender) external view returns (uint);
17 
18     function approve(address spender, uint value) external returns (bool);
19     function transfer(address to, uint value) external returns (bool);
20     function transferFrom(address from, address to, uint value) external returns (bool);
21 
22     function PERIOD() external pure returns (uint);
23 
24     function pair() external view returns (address);
25     function rebaseSetter() external view returns (address);
26     function creator() external view returns (address);
27     function token0() external view returns (address);
28     function token1() external view returns (address);
29     function price0CumulativeLast() external view returns (uint);
30     function price1CumulativeLast() external view returns (uint);
31     function blockTimestampLast() external view returns (uint32);
32     function initialize(address, address) external;
33     function rebase() external returns (uint);
34     function setRebaseSetter(address) external;
35     function setCreator(address) external;
36     function consult(address token, uint amountIn) external view returns (uint amountOut);
37 }
38 
39 // File: contracts/interfaces/IERC20.sol
40 
41 pragma solidity >=0.5.0;
42 
43 interface IERC20 {
44     event Approval(address indexed owner, address indexed spender, uint value);
45     event Transfer(address indexed from, address indexed to, uint value);
46 
47     function name() external view returns (string memory);
48     function symbol() external view returns (string memory);
49     function decimals() external view returns (uint8);
50     function totalSupply() external view returns (uint);
51     function balanceOf(address owner) external view returns (uint);
52     function allowance(address owner, address spender) external view returns (uint);
53 
54     function approve(address spender, uint value) external returns (bool);
55     function transfer(address to, uint value) external returns (bool);
56     function transferFrom(address from, address to, uint value) external returns (bool);
57 }
58 
59 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
60 
61 pragma solidity >=0.5.0;
62 
63 interface IUniswapV2Pair {
64     event Approval(address indexed owner, address indexed spender, uint value);
65     event Transfer(address indexed from, address indexed to, uint value);
66 
67     function name() external pure returns (string memory);
68     function symbol() external pure returns (string memory);
69     function decimals() external pure returns (uint8);
70     function totalSupply() external view returns (uint);
71     function balanceOf(address owner) external view returns (uint);
72     function allowance(address owner, address spender) external view returns (uint);
73 
74     function approve(address spender, uint value) external returns (bool);
75     function transfer(address to, uint value) external returns (bool);
76     function transferFrom(address from, address to, uint value) external returns (bool);
77 
78     function DOMAIN_SEPARATOR() external view returns (bytes32);
79     function PERMIT_TYPEHASH() external pure returns (bytes32);
80     function nonces(address owner) external view returns (uint);
81 
82     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
83 
84     event Mint(address indexed sender, uint amount0, uint amount1);
85     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
86     event Swap(
87         address indexed sender,
88         uint amount0In,
89         uint amount1In,
90         uint amount0Out,
91         uint amount1Out,
92         address indexed to
93     );
94     event Sync(uint112 reserve0, uint112 reserve1);
95 
96     function MINIMUM_LIQUIDITY() external pure returns (uint);
97     function factory() external view returns (address);
98     function token0() external view returns (address);
99     function token1() external view returns (address);
100     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
101     function price0CumulativeLast() external view returns (uint);
102     function price1CumulativeLast() external view returns (uint);
103     function kLast() external view returns (uint);
104 
105     function mint(address to) external returns (uint liquidity);
106     function burn(address to) external returns (uint amount0, uint amount1);
107     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
108     function skim(address to) external;
109     function sync() external;
110 
111     function initialize(address, address) external;
112 }
113 
114 // File: @uniswap/lib/contracts/libraries/FixedPoint.sol
115 
116 pragma solidity >=0.4.0;
117 
118 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
119 library FixedPoint {
120     // range: [0, 2**112 - 1]
121     // resolution: 1 / 2**112
122     struct uq112x112 {
123         uint224 _x;
124     }
125 
126     // range: [0, 2**144 - 1]
127     // resolution: 1 / 2**112
128     struct uq144x112 {
129         uint _x;
130     }
131 
132     uint8 private constant RESOLUTION = 112;
133 
134     // encode a uint112 as a UQ112x112
135     function encode(uint112 x) internal pure returns (uq112x112 memory) {
136         return uq112x112(uint224(x) << RESOLUTION);
137     }
138 
139     // encodes a uint144 as a UQ144x112
140     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
141         return uq144x112(uint256(x) << RESOLUTION);
142     }
143 
144     // divide a UQ112x112 by a uint112, returning a UQ112x112
145     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
146         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
147         return uq112x112(self._x / uint224(x));
148     }
149 
150     // multiply a UQ112x112 by a uint, returning a UQ144x112
151     // reverts on overflow
152     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
153         uint z;
154         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
155         return uq144x112(z);
156     }
157 
158     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
159     // equivalent to encode(numerator).div(denominator)
160     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
161         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
162         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
163     }
164 
165     // decode a UQ112x112 into a uint112 by truncating after the radix point
166     function decode(uq112x112 memory self) internal pure returns (uint112) {
167         return uint112(self._x >> RESOLUTION);
168     }
169 
170     // decode a UQ144x112 into a uint144 by truncating after the radix point
171     function decode144(uq144x112 memory self) internal pure returns (uint144) {
172         return uint144(self._x >> RESOLUTION);
173     }
174 }
175 
176 // File: contracts/libraries/UniswapV2OracleLibrary.sol
177 
178 pragma solidity >=0.5.0;
179 
180 
181 
182 // library with helper methods for oracles that are concerned with computing average prices
183 library UniswapV2OracleLibrary {
184     using FixedPoint for *;
185 
186     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
187     function currentBlockTimestamp() internal view returns (uint32) {
188         return uint32(block.timestamp % 2 ** 32);
189     }
190 
191     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
192     function currentCumulativePrices(
193         address pair
194     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
195         blockTimestamp = currentBlockTimestamp();
196         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
197         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
198 
199         // if time has elapsed since the last update on the pair, mock the accumulated price values
200         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
201         if (blockTimestampLast != blockTimestamp) {
202             // subtraction overflow is desired
203             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
204             // addition overflow is desired
205             // counterfactual
206             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
207             // counterfactual
208             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
209         }
210     }
211 }
212 
213 // File: contracts/libraries/SafeMath.sol
214 
215 pragma solidity =0.6.6;
216 
217 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
218 
219 library SafeMath {
220     function add(uint x, uint y) internal pure returns (uint z) {
221         require((z = x + y) >= x, 'ds-math-add-overflow');
222     }
223 
224     function sub(uint x, uint y) internal pure returns (uint z) {
225         require((z = x - y) <= x, 'ds-math-sub-underflow');
226     }
227 
228     function mul(uint x, uint y) internal pure returns (uint z) {
229         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
230     }
231 
232     function abs(int a) internal pure returns (int) {
233         require(a != int256(1) << 255, 'ds-math-mul-overflow');
234         return a < 0 ? -a : a;
235     }
236 }
237 
238 // File: contracts/libraries/UniswapV2Library.sol
239 
240 pragma solidity >=0.5.0;
241 
242 
243 
244 library UniswapV2Library {
245     using SafeMath for uint;
246 
247     // returns sorted token addresses, used to handle return values from pairs sorted in this order
248     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
249         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
250         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
251         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
252     }
253 
254     // calculates the CREATE2 address for a pair without making any external calls
255     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
256         (address token0, address token1) = sortTokens(tokenA, tokenB);
257         pair = address(uint(keccak256(abi.encodePacked(
258                 hex'ff',
259                 factory,
260                 keccak256(abi.encodePacked(token0, token1)),
261                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
262             ))));
263     }
264 
265     // fetches and sorts the reserves for a pair
266     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
267         (address token0,) = sortTokens(tokenA, tokenB);
268         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
269         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
270     }
271 
272     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
273     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
274         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
275         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
276         amountB = amountA.mul(reserveB) / reserveA;
277     }
278 
279     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
280     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
281         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
282         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
283         uint amountInWithFee = amountIn.mul(997);
284         uint numerator = amountInWithFee.mul(reserveOut);
285         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
286         amountOut = numerator / denominator;
287     }
288 
289     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
290     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
291         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
292         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
293         uint numerator = reserveIn.mul(amountOut).mul(1000);
294         uint denominator = reserveOut.sub(amountOut).mul(997);
295         amountIn = (numerator / denominator).add(1);
296     }
297 
298     // performs chained getAmountOut calculations on any number of pairs
299     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
300         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
301         amounts = new uint[](path.length);
302         amounts[0] = amountIn;
303         for (uint i; i < path.length - 1; i++) {
304             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
305             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
306         }
307     }
308 
309     // performs chained getAmountIn calculations on any number of pairs
310     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
311         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
312         amounts = new uint[](path.length);
313         amounts[amounts.length - 1] = amountOut;
314         for (uint i = path.length - 1; i > 0; i--) {
315             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
316             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
317         }
318     }
319 }
320 
321 // File: contracts/MostERC20.sol
322 
323 pragma solidity =0.6.6;
324 
325 
326 
327 
328 
329 
330 
331 contract MostERC20 is IMostERC20 {
332     using FixedPoint for *;
333     using SafeMath for uint;
334     using SafeMath for int;
335 
336     string public constant override name = 'MOST';
337     string public constant override symbol = 'MOST';
338     uint8 public constant override decimals = 9;
339     uint public override totalSupply;
340     uint public override epoch;
341     mapping(address => uint) private gonBalanceOf;
342     mapping(address => mapping(address => uint)) public override allowance;
343 
344     uint public constant override PERIOD = 24 hours;
345 
346     uint private constant MAX_UINT256 = ~uint256(0);
347     uint private constant INITIAL_FRAGMENTS_SUPPLY = 1 * 10**6 * 10**uint(decimals);
348     uint8 private constant RATE_BASE = 100;
349     uint8 private constant UPPER_BOUND = 106;
350     uint8 private constant LOWER_BOUND = 96;
351 
352     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that gonsPerFragment is an integer.
353     // Use the highest value that fits in a uint256 for max granularity.
354     uint private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
355 
356     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
357     uint private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
358 
359     uint private gonsPerFragment;
360 
361     address public override pair;
362     address public override rebaseSetter;
363     address public override creator;
364     address public override token0;
365     address public override token1;
366 
367     uint public override price0CumulativeLast;
368     uint public override price1CumulativeLast;
369     uint32 public override blockTimestampLast;
370     FixedPoint.uq112x112 private price0Average;
371     FixedPoint.uq112x112 private price1Average;
372 
373     event Approval(address indexed owner, address indexed spender, uint value);
374     event Transfer(address indexed from, address indexed to, uint value);
375     event LogRebase(uint indexed epoch, uint totalSupply);
376 
377     constructor() public {
378         creator = msg.sender;
379 
380         totalSupply = INITIAL_FRAGMENTS_SUPPLY;
381         gonBalanceOf[msg.sender] = TOTAL_GONS;
382         gonsPerFragment = TOTAL_GONS / totalSupply;
383 
384         emit Transfer(address(0), msg.sender, totalSupply);
385     }
386 
387     function initialize(address factory, address tokenB) external override {
388         require(msg.sender == creator, 'MOST: FORBIDDEN'); // sufficient check
389 
390         IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, address(this), tokenB));
391         pair = address(_pair);
392         token0 = _pair.token0();
393         token1 = _pair.token1();
394         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
395         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
396         uint112 reserve0;
397         uint112 reserve1;
398         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
399         require(reserve0 != 0 && reserve1 != 0, 'MOST: NO_RESERVES'); // ensure that there's liquidity in the pair
400     }
401 
402     function _approve(address owner, address spender, uint value) private {
403         allowance[owner][spender] = value;
404         emit Approval(owner, spender, value);
405     }
406 
407     function _transfer(address from, address to, uint value) private {
408         uint gonValue = value.mul(gonsPerFragment);
409         gonBalanceOf[from] = gonBalanceOf[from].sub(gonValue);
410         gonBalanceOf[to] = gonBalanceOf[to].add(gonValue);
411         emit Transfer(from, to, value);
412     }
413 
414     function balanceOf(address owner) external view override returns (uint) {
415         return gonBalanceOf[owner] / gonsPerFragment;
416     }
417 
418     function approve(address spender, uint value) external override returns (bool) {
419         _approve(msg.sender, spender, value);
420         return true;
421     }
422 
423     function transfer(address to, uint value) external override returns (bool) {
424         _transfer(msg.sender, to, value);
425         return true;
426     }
427 
428     function transferFrom(address from, address to, uint value) external override returns (bool) {
429         if (allowance[from][msg.sender] != uint(-1)) {
430             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
431         }
432         _transfer(from, to, value);
433         return true;
434     }
435 
436     function rebase() external override returns (uint) {
437         require(msg.sender == rebaseSetter, 'MOST: FORBIDDEN'); // sufficient check
438 
439         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
440             UniswapV2OracleLibrary.currentCumulativePrices(pair);
441         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
442 
443         // ensure that at least one full period has passed since the last update
444         require(timeElapsed >= PERIOD, 'MOST: PERIOD_NOT_ELAPSED');
445 
446         epoch = epoch.add(1);
447 
448         // overflow is desired, casting never truncates
449         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
450         price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
451         price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));
452 
453         price0CumulativeLast = price0Cumulative;
454         price1CumulativeLast = price1Cumulative;
455         blockTimestampLast = blockTimestamp;
456 
457         uint priceAverage = consult(address(this), 10**uint(decimals));
458 
459         uint tokenBRemaining;
460         if (address(this) == token0) {
461             tokenBRemaining = 10 ** uint(IERC20(token1).decimals() - 2);
462         } else {
463             tokenBRemaining = 10 ** uint(IERC20(token0).decimals() - 2);
464         }
465         uint unitBase = RATE_BASE * tokenBRemaining;
466         int256 supplyDelta;
467         if (priceAverage > UPPER_BOUND * tokenBRemaining) {
468             supplyDelta = 0 - int(totalSupply.mul(priceAverage.sub(unitBase)) / priceAverage);
469         } else if (priceAverage < LOWER_BOUND * tokenBRemaining) {
470             supplyDelta = int(totalSupply.mul(unitBase.sub(priceAverage)) / unitBase);
471         } else {
472             supplyDelta = 0;
473         }
474 
475         supplyDelta = supplyDelta / 10;
476 
477         if (supplyDelta == 0) {
478             emit LogRebase(epoch, totalSupply);
479             return totalSupply;
480         }
481 
482         if (supplyDelta < 0) {
483             totalSupply = totalSupply.sub(uint256(supplyDelta.abs()));
484         } else {
485             totalSupply = totalSupply.add(uint256(supplyDelta));
486         }
487 
488         if (totalSupply > MAX_SUPPLY) {
489             totalSupply = MAX_SUPPLY;
490         }
491 
492         gonsPerFragment = TOTAL_GONS / totalSupply;
493 
494         // From this point forward, gonsPerFragment is taken as the source of truth.
495         // We recalculate a new totalSupply to be in agreement with the gonsPerFragment
496         // conversion rate.
497         // This means our applied supplyDelta can deviate from the requested supplyDelta,
498         // but this deviation is guaranteed to be < (totalSupply^2)/(TOTAL_GONS - totalSupply).
499         //
500         // In the case of totalSupply <= MAX_UINT128 (our current supply cap), this
501         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
502         // ever increased, it must be re-included.
503         // totalSupply = TOTAL_GONS / gonsPerFragment
504 
505         emit LogRebase(epoch, totalSupply);
506         return totalSupply;
507     }
508 
509     function setRebaseSetter(address _rebaseSetter) external override {
510         require(msg.sender == creator, 'MOST: FORBIDDEN');
511         rebaseSetter = _rebaseSetter;
512     }
513 
514     function setCreator(address _creator) external override {
515         require(msg.sender == creator, 'MOST: FORBIDDEN');
516         creator = _creator;
517     }
518 
519     // note this will always return 0 before update has been called successfully for the first time.
520     function consult(address token, uint amountIn) public view override returns (uint amountOut) {
521         if (token == token0) {
522             amountOut = price0Average.mul(amountIn).decode144();
523         } else {
524             require(token == token1, 'MOST: INVALID_TOKEN');
525             amountOut = price1Average.mul(amountIn).decode144();
526         }
527     }
528 }