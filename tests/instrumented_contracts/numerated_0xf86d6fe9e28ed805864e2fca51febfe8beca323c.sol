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
53     function initialize(address, address) external;
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
84 pragma solidity =0.5.16;
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
104 pragma solidity =0.5.16;
105 
106 
107 
108 contract UniswapV2ERC20 is IUniswapV2ERC20 {
109     using SafeMath for uint;
110 
111     string public constant name = 'Uniswap V2';
112     string public constant symbol = 'UNI-V2';
113     uint8 public constant decimals = 18;
114     uint  public totalSupply;
115     mapping(address => uint) public balanceOf;
116     mapping(address => mapping(address => uint)) public allowance;
117 
118     bytes32 public DOMAIN_SEPARATOR;
119     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
120     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
121     mapping(address => uint) public nonces;
122 
123     event Approval(address indexed owner, address indexed spender, uint value);
124     event Transfer(address indexed from, address indexed to, uint value);
125 
126     constructor() public {
127         uint chainId;
128         assembly {
129             chainId := chainid
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
165     function approve(address spender, uint value) external returns (bool) {
166         _approve(msg.sender, spender, value);
167         return true;
168     }
169 
170     function transfer(address to, uint value) external returns (bool) {
171         _transfer(msg.sender, to, value);
172         return true;
173     }
174 
175     function transferFrom(address from, address to, uint value) external returns (bool) {
176         if (allowance[from][msg.sender] != uint(-1)) {
177             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
178         }
179         _transfer(from, to, value);
180         return true;
181     }
182 
183     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
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
200 pragma solidity =0.5.16;
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
226 pragma solidity =0.5.16;
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
276 
277     function getPair(address tokenA, address tokenB) external view returns (address pair);
278     function allPairs(uint) external view returns (address pair);
279     function allPairsLength() external view returns (uint);
280 
281     function createPair(address tokenA, address tokenB) external returns (address pair);
282 
283     function setFeeTo(address) external;
284     function setFeeToSetter(address) external;
285 }
286 
287 // File: contracts/interfaces/IUniswapV2Callee.sol
288 
289 pragma solidity >=0.5.0;
290 
291 interface IUniswapV2Callee {
292     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
293 }
294 
295 // File: contracts/UniswapV2Pair.sol
296 
297 pragma solidity =0.5.16;
298 
299 
300 
301 
302 
303 
304 
305 
306 contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {
307     using SafeMath  for uint;
308     using UQ112x112 for uint224;
309 
310     uint public constant MINIMUM_LIQUIDITY = 10**3;
311     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
312 
313     address public factory;
314     address public token0;
315     address public token1;
316 
317     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
318     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
319     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
320 
321     uint public price0CumulativeLast;
322     uint public price1CumulativeLast;
323     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
324 
325     uint private unlocked = 1;
326     modifier lock() {
327         require(unlocked == 1, 'UniswapV2: LOCKED');
328         unlocked = 0;
329         _;
330         unlocked = 1;
331     }
332 
333     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
334         _reserve0 = reserve0;
335         _reserve1 = reserve1;
336         _blockTimestampLast = blockTimestampLast;
337     }
338 
339     function _safeTransfer(address token, address to, uint value) private {
340         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
341         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
342     }
343 
344     event Mint(address indexed sender, uint amount0, uint amount1);
345     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
346     event Swap(
347         address indexed sender,
348         uint amount0In,
349         uint amount1In,
350         uint amount0Out,
351         uint amount1Out,
352         address indexed to
353     );
354     event Sync(uint112 reserve0, uint112 reserve1);
355 
356     constructor() public {
357         factory = msg.sender;
358     }
359 
360     // called once by the factory at time of deployment
361     function initialize(address _token0, address _token1) external {
362         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
363         token0 = _token0;
364         token1 = _token1;
365     }
366 
367     // update reserves and, on the first call per block, price accumulators
368     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
369         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
370         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
371         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
372         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
373             // * never overflows, and + overflow is desired
374             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
375             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
376         }
377         reserve0 = uint112(balance0);
378         reserve1 = uint112(balance1);
379         blockTimestampLast = blockTimestamp;
380         emit Sync(reserve0, reserve1);
381     }
382 
383     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
384     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
385         address feeTo = IUniswapV2Factory(factory).feeTo();
386         feeOn = feeTo != address(0);
387         uint _kLast = kLast; // gas savings
388         if (feeOn) {
389             if (_kLast != 0) {
390                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
391                 uint rootKLast = Math.sqrt(_kLast);
392                 if (rootK > rootKLast) {
393                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
394                     uint denominator = rootK.mul(5).add(rootKLast);
395                     uint liquidity = numerator / denominator;
396                     if (liquidity > 0) _mint(feeTo, liquidity);
397                 }
398             }
399         } else if (_kLast != 0) {
400             kLast = 0;
401         }
402     }
403 
404     // this low-level function should be called from a contract which performs important safety checks
405     function mint(address to) external lock returns (uint liquidity) {
406         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
407         uint balance0 = IERC20(token0).balanceOf(address(this));
408         uint balance1 = IERC20(token1).balanceOf(address(this));
409         uint amount0 = balance0.sub(_reserve0);
410         uint amount1 = balance1.sub(_reserve1);
411 
412         bool feeOn = _mintFee(_reserve0, _reserve1);
413         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
414         if (_totalSupply == 0) {
415             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
416            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
417         } else {
418             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
419         }
420         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
421         _mint(to, liquidity);
422 
423         _update(balance0, balance1, _reserve0, _reserve1);
424         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
425         emit Mint(msg.sender, amount0, amount1);
426     }
427 
428     // this low-level function should be called from a contract which performs important safety checks
429     function burn(address to) external lock returns (uint amount0, uint amount1) {
430         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
431         address _token0 = token0;                                // gas savings
432         address _token1 = token1;                                // gas savings
433         uint balance0 = IERC20(_token0).balanceOf(address(this));
434         uint balance1 = IERC20(_token1).balanceOf(address(this));
435         uint liquidity = balanceOf[address(this)];
436 
437         bool feeOn = _mintFee(_reserve0, _reserve1);
438         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
439         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
440         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
441         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
442         _burn(address(this), liquidity);
443         _safeTransfer(_token0, to, amount0);
444         _safeTransfer(_token1, to, amount1);
445         balance0 = IERC20(_token0).balanceOf(address(this));
446         balance1 = IERC20(_token1).balanceOf(address(this));
447 
448         _update(balance0, balance1, _reserve0, _reserve1);
449         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
450         emit Burn(msg.sender, amount0, amount1, to);
451     }
452 
453     // this low-level function should be called from a contract which performs important safety checks
454     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
455         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
456         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
457         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
458 
459         uint balance0;
460         uint balance1;
461         { // scope for _token{0,1}, avoids stack too deep errors
462         address _token0 = token0;
463         address _token1 = token1;
464         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
465         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
466         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
467         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
468         balance0 = IERC20(_token0).balanceOf(address(this));
469         balance1 = IERC20(_token1).balanceOf(address(this));
470         }
471         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
472         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
473         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
474         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
475         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
476         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
477         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
478         }
479 
480         _update(balance0, balance1, _reserve0, _reserve1);
481         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
482     }
483 
484     // force balances to match reserves
485     function skim(address to) external lock {
486         address _token0 = token0; // gas savings
487         address _token1 = token1; // gas savings
488         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
489         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
490     }
491 
492     // force reserves to match balances
493     function sync() external lock {
494         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
495     }
496 }