1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-05
3 */
4 
5 // File: contracts/interfaces/IUniswapV2Pair.sol
6 
7 pragma solidity >=0.5.0;
8 
9 interface IUniswapV2Pair {
10     event Approval(address indexed owner, address indexed spender, uint value);
11     event Transfer(address indexed from, address indexed to, uint value);
12 
13     function name() external pure returns (string memory);
14     function symbol() external pure returns (string memory);
15     function decimals() external pure returns (uint8);
16     function totalSupply() external view returns (uint);
17     function balanceOf(address owner) external view returns (uint);
18     function allowance(address owner, address spender) external view returns (uint);
19 
20     function approve(address spender, uint value) external returns (bool);
21     function transfer(address to, uint value) external returns (bool);
22     function transferFrom(address from, address to, uint value) external returns (bool);
23 
24     function DOMAIN_SEPARATOR() external view returns (bytes32);
25     function PERMIT_TYPEHASH() external pure returns (bytes32);
26     function nonces(address owner) external view returns (uint);
27 
28     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
29 
30     event Mint(address indexed sender, uint amount0, uint amount1);
31     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
32     event Swap(
33         address indexed sender,
34         uint amount0In,
35         uint amount1In,
36         uint amount0Out,
37         uint amount1Out,
38         address indexed to
39     );
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function MINIMUM_LIQUIDITY() external pure returns (uint);
43     function factory() external view returns (address);
44     function token0() external view returns (address);
45     function token1() external view returns (address);
46     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
47     function price0CumulativeLast() external view returns (uint);
48     function price1CumulativeLast() external view returns (uint);
49     function kLast() external view returns (uint);
50 
51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;
56 
57     function initialize(address, address) external;
58 }
59 
60 // File: contracts/interfaces/IUniswapV2ERC20.sol
61 
62 pragma solidity >=0.5.0;
63 
64 interface IUniswapV2ERC20 {
65     event Approval(address indexed owner, address indexed spender, uint value);
66     event Transfer(address indexed from, address indexed to, uint value);
67 
68     function name() external pure returns (string memory);
69     function symbol() external pure returns (string memory);
70     function decimals() external pure returns (uint8);
71     function totalSupply() external view returns (uint);
72     function balanceOf(address owner) external view returns (uint);
73     function allowance(address owner, address spender) external view returns (uint);
74 
75     function approve(address spender, uint value) external returns (bool);
76     function transfer(address to, uint value) external returns (bool);
77     function transferFrom(address from, address to, uint value) external returns (bool);
78 
79     function DOMAIN_SEPARATOR() external view returns (bytes32);
80     function PERMIT_TYPEHASH() external pure returns (bytes32);
81     function nonces(address owner) external view returns (uint);
82 
83     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
84 }
85 
86 // File: contracts/libraries/SafeMath.sol
87 
88 pragma solidity =0.5.16;
89 
90 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
91 
92 library SafeMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x, 'ds-math-add-overflow');
95     }
96 
97     function sub(uint x, uint y) internal pure returns (uint z) {
98         require((z = x - y) <= x, 'ds-math-sub-underflow');
99     }
100 
101     function mul(uint x, uint y) internal pure returns (uint z) {
102         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
103     }
104 }
105 
106 // File: contracts/UniswapV2ERC20.sol
107 
108 pragma solidity =0.5.16;
109 
110 
111 
112 contract UniswapV2ERC20 is IUniswapV2ERC20 {
113     using SafeMath for uint;
114 
115     string public constant name = 'Uniswap V2';
116     string public constant symbol = 'UNI-V2';
117     uint8 public constant decimals = 18;
118     uint  public totalSupply;
119     mapping(address => uint) public balanceOf;
120     mapping(address => mapping(address => uint)) public allowance;
121 
122     bytes32 public DOMAIN_SEPARATOR;
123     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
124     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
125     mapping(address => uint) public nonces;
126 
127     event Approval(address indexed owner, address indexed spender, uint value);
128     event Transfer(address indexed from, address indexed to, uint value);
129 
130     constructor() public {
131         uint chainId;
132         assembly {
133             chainId := chainid
134         }
135         DOMAIN_SEPARATOR = keccak256(
136             abi.encode(
137                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
138                 keccak256(bytes(name)),
139                 keccak256(bytes('1')),
140                 chainId,
141                 address(this)
142             )
143         );
144     }
145 
146     function _mint(address to, uint value) internal {
147         totalSupply = totalSupply.add(value);
148         balanceOf[to] = balanceOf[to].add(value);
149         emit Transfer(address(0), to, value);
150     }
151 
152     function _burn(address from, uint value) internal {
153         balanceOf[from] = balanceOf[from].sub(value);
154         totalSupply = totalSupply.sub(value);
155         emit Transfer(from, address(0), value);
156     }
157 
158     function _approve(address owner, address spender, uint value) private {
159         allowance[owner][spender] = value;
160         emit Approval(owner, spender, value);
161     }
162 
163     function _transfer(address from, address to, uint value) private {
164         balanceOf[from] = balanceOf[from].sub(value);
165         balanceOf[to] = balanceOf[to].add(value);
166         emit Transfer(from, to, value);
167     }
168 
169     function approve(address spender, uint value) external returns (bool) {
170         _approve(msg.sender, spender, value);
171         return true;
172     }
173 
174     function transfer(address to, uint value) external returns (bool) {
175         _transfer(msg.sender, to, value);
176         return true;
177     }
178 
179     function transferFrom(address from, address to, uint value) external returns (bool) {
180         if (allowance[from][msg.sender] != uint(-1)) {
181             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
182         }
183         _transfer(from, to, value);
184         return true;
185     }
186 
187     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
188         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
189         bytes32 digest = keccak256(
190             abi.encodePacked(
191                 '\x19\x01',
192                 DOMAIN_SEPARATOR,
193                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
194             )
195         );
196         address recoveredAddress = ecrecover(digest, v, r, s);
197         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
198         _approve(owner, spender, value);
199     }
200 }
201 
202 // File: contracts/libraries/Math.sol
203 
204 pragma solidity =0.5.16;
205 
206 // a library for performing various math operations
207 
208 library Math {
209     function min(uint x, uint y) internal pure returns (uint z) {
210         z = x < y ? x : y;
211     }
212 
213     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
214     function sqrt(uint y) internal pure returns (uint z) {
215         if (y > 3) {
216             z = y;
217             uint x = y / 2 + 1;
218             while (x < z) {
219                 z = x;
220                 x = (y / x + x) / 2;
221             }
222         } else if (y != 0) {
223             z = 1;
224         }
225     }
226 }
227 
228 // File: contracts/libraries/UQ112x112.sol
229 
230 pragma solidity =0.5.16;
231 
232 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
233 
234 // range: [0, 2**112 - 1]
235 // resolution: 1 / 2**112
236 
237 library UQ112x112 {
238     uint224 constant Q112 = 2**112;
239 
240     // encode a uint112 as a UQ112x112
241     function encode(uint112 y) internal pure returns (uint224 z) {
242         z = uint224(y) * Q112; // never overflows
243     }
244 
245     // divide a UQ112x112 by a uint112, returning a UQ112x112
246     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
247         z = x / uint224(y);
248     }
249 }
250 
251 // File: contracts/interfaces/IERC20.sol
252 
253 pragma solidity >=0.5.0;
254 
255 interface IERC20 {
256     event Approval(address indexed owner, address indexed spender, uint value);
257     event Transfer(address indexed from, address indexed to, uint value);
258 
259     function name() external view returns (string memory);
260     function symbol() external view returns (string memory);
261     function decimals() external view returns (uint8);
262     function totalSupply() external view returns (uint);
263     function balanceOf(address owner) external view returns (uint);
264     function allowance(address owner, address spender) external view returns (uint);
265 
266     function approve(address spender, uint value) external returns (bool);
267     function transfer(address to, uint value) external returns (bool);
268     function transferFrom(address from, address to, uint value) external returns (bool);
269 }
270 
271 // File: contracts/interfaces/IUniswapV2Factory.sol
272 
273 pragma solidity >=0.5.0;
274 
275 interface IUniswapV2Factory {
276     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
277 
278     function feeTo() external view returns (address);
279     function feeToSetter() external view returns (address);
280 
281     function getPair(address tokenA, address tokenB) external view returns (address pair);
282     function allPairs(uint) external view returns (address pair);
283     function allPairsLength() external view returns (uint);
284 
285     function createPair(address tokenA, address tokenB) external returns (address pair);
286 
287     function setFeeTo(address) external;
288     function setFeeToSetter(address) external;
289 }
290 
291 // File: contracts/interfaces/IUniswapV2Callee.sol
292 
293 pragma solidity >=0.5.0;
294 
295 interface IUniswapV2Callee {
296     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
297 }
298 
299 // File: contracts/UniswapV2Pair.sol
300 
301 pragma solidity =0.5.16;
302 
303 
304 
305 
306 
307 
308 
309 
310 contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {
311     using SafeMath  for uint;
312     using UQ112x112 for uint224;
313 
314     uint public constant MINIMUM_LIQUIDITY = 10**3;
315     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
316 
317     address public factory;
318     address public token0;
319     address public token1;
320 
321     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
322     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
323     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
324 
325     uint public price0CumulativeLast;
326     uint public price1CumulativeLast;
327     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
328 
329     uint private unlocked = 1;
330     modifier lock() {
331         require(unlocked == 1, 'UniswapV2: LOCKED');
332         unlocked = 0;
333         _;
334         unlocked = 1;
335     }
336 
337     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
338         _reserve0 = reserve0;
339         _reserve1 = reserve1;
340         _blockTimestampLast = blockTimestampLast;
341     }
342 
343     function _safeTransfer(address token, address to, uint value) private {
344         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
345         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
346     }
347 
348     event Mint(address indexed sender, uint amount0, uint amount1);
349     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
350     event Swap(
351         address indexed sender,
352         uint amount0In,
353         uint amount1In,
354         uint amount0Out,
355         uint amount1Out,
356         address indexed to
357     );
358     event Sync(uint112 reserve0, uint112 reserve1);
359 
360     constructor() public {
361         factory = msg.sender;
362     }
363 
364     // called once by the factory at time of deployment
365     function initialize(address _token0, address _token1) external {
366         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
367         token0 = _token0;
368         token1 = _token1;
369     }
370 
371     // update reserves and, on the first call per block, price accumulators
372     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
373         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
374         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
375         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
376         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
377             // * never overflows, and + overflow is desired
378             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
379             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
380         }
381         reserve0 = uint112(balance0);
382         reserve1 = uint112(balance1);
383         blockTimestampLast = blockTimestamp;
384         emit Sync(reserve0, reserve1);
385     }
386 
387     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
388     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
389         address feeTo = IUniswapV2Factory(factory).feeTo();
390         feeOn = feeTo != address(0);
391         uint _kLast = kLast; // gas savings
392         if (feeOn) {
393             if (_kLast != 0) {
394                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
395                 uint rootKLast = Math.sqrt(_kLast);
396                 if (rootK > rootKLast) {
397                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
398                     uint denominator = rootK.mul(5).add(rootKLast);
399                     uint liquidity = numerator / denominator;
400                     if (liquidity > 0) _mint(feeTo, liquidity);
401                 }
402             }
403         } else if (_kLast != 0) {
404             kLast = 0;
405         }
406     }
407 
408     // this low-level function should be called from a contract which performs important safety checks
409     function mint(address to) external lock returns (uint liquidity) {
410         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
411         uint balance0 = IERC20(token0).balanceOf(address(this));
412         uint balance1 = IERC20(token1).balanceOf(address(this));
413         uint amount0 = balance0.sub(_reserve0);
414         uint amount1 = balance1.sub(_reserve1);
415 
416         bool feeOn = _mintFee(_reserve0, _reserve1);
417         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
418         if (_totalSupply == 0) {
419             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
420            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
421         } else {
422             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
423         }
424         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
425         _mint(to, liquidity);
426 
427         _update(balance0, balance1, _reserve0, _reserve1);
428         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
429         emit Mint(msg.sender, amount0, amount1);
430     }
431 
432     // this low-level function should be called from a contract which performs important safety checks
433     function burn(address to) external lock returns (uint amount0, uint amount1) {
434         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
435         address _token0 = token0;                                // gas savings
436         address _token1 = token1;                                // gas savings
437         uint balance0 = IERC20(_token0).balanceOf(address(this));
438         uint balance1 = IERC20(_token1).balanceOf(address(this));
439         uint liquidity = balanceOf[address(this)];
440 
441         bool feeOn = _mintFee(_reserve0, _reserve1);
442         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
443         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
444         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
445         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
446         _burn(address(this), liquidity);
447         _safeTransfer(_token0, to, amount0);
448         _safeTransfer(_token1, to, amount1);
449         balance0 = IERC20(_token0).balanceOf(address(this));
450         balance1 = IERC20(_token1).balanceOf(address(this));
451 
452         _update(balance0, balance1, _reserve0, _reserve1);
453         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
454         emit Burn(msg.sender, amount0, amount1, to);
455     }
456 
457     // this low-level function should be called from a contract which performs important safety checks
458     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
459         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
460         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
461         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
462 
463         uint balance0;
464         uint balance1;
465         { // scope for _token{0,1}, avoids stack too deep errors
466         address _token0 = token0;
467         address _token1 = token1;
468         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
469         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
470         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
471         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
472         balance0 = IERC20(_token0).balanceOf(address(this));
473         balance1 = IERC20(_token1).balanceOf(address(this));
474         }
475         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
476         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
477         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
478         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
479         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
480         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
481         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
482         }
483 
484         _update(balance0, balance1, _reserve0, _reserve1);
485         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
486     }
487 
488     // force balances to match reserves
489     function skim(address to) external lock {
490         address _token0 = token0; // gas savings
491         address _token1 = token1; // gas savings
492         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
493         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
494     }
495 
496     // force reserves to match balances
497     function sync() external lock {
498         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
499     }
500 }