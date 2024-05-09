1 // File: contracts/interfaces/ICroDefiSwapPair.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ICroDefiSwapPair {
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
56 // File: contracts/interfaces/ICroDefiSwapERC20.sol
57 
58 pragma solidity >=0.5.0;
59 
60 interface ICroDefiSwapERC20 {
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
102 // File: contracts/CroDefiSwapERC20.sol
103 
104 pragma solidity =0.5.16;
105 
106 
107 
108 contract CroDefiSwapERC20 is ICroDefiSwapERC20 {
109     using SafeMath for uint;
110 
111     string public constant name = 'CRO Defi Swap';
112     string public constant symbol = 'CRO-SWAP';
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
184         require(deadline >= block.timestamp, 'CroDefiSwap: EXPIRED');
185         bytes32 digest = keccak256(
186             abi.encodePacked(
187                 '\x19\x01',
188                 DOMAIN_SEPARATOR,
189                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
190             )
191         );
192         address recoveredAddress = ecrecover(digest, v, r, s);
193         require(recoveredAddress != address(0) && recoveredAddress == owner, 'CroDefiSwap: INVALID_SIGNATURE');
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
267 // File: contracts/interfaces/ICroDefiSwapFactory.sol
268 
269 pragma solidity >=0.5.0;
270 
271 interface ICroDefiSwapFactory {
272     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
273 
274     function feeTo() external view returns (address);
275     function feeToBasisPoint() external view returns (uint);
276 
277     // technically must be bigger than or equal to feeToBasisPoint
278     function totalFeeBasisPoint() external view returns (uint);
279 
280     function feeSetter() external view returns (address);
281 
282     function getPair(address tokenA, address tokenB) external view returns (address pair);
283     function allPairs(uint) external view returns (address pair);
284     function allPairsLength() external view returns (uint);
285 
286     function createPair(address tokenA, address tokenB) external returns (address pair);
287 
288     function setFeeTo(address) external;
289     function setFeeToBasisPoint(uint) external;
290     function setTotalFeeBasisPoint(uint) external;
291 
292     function setFeeSetter(address) external;
293 }
294 
295 // File: contracts/interfaces/ICroDefiSwapCallee.sol
296 
297 pragma solidity >=0.5.0;
298 
299 interface ICroDefiSwapCallee {
300     function croDefiSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
301 }
302 
303 // File: contracts/CroDefiSwapPair.sol
304 
305 pragma solidity =0.5.16;
306 
307 
308 
309 
310 
311 
312 
313 
314 contract CroDefiSwapPair is ICroDefiSwapPair, CroDefiSwapERC20 {
315     using SafeMath  for uint;
316     using UQ112x112 for uint224;
317 
318     uint public constant MINIMUM_LIQUIDITY = 10**3;
319     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
320 
321     address public factory;
322     address public token0;
323     address public token1;
324 
325     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
326     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
327     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
328 
329     uint public price0CumulativeLast;
330     uint public price1CumulativeLast;
331     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
332 
333     uint private unlocked = 1;
334     modifier lock() {
335         require(unlocked == 1, 'CroDefiSwap: LOCKED');
336         unlocked = 0;
337         _;
338         unlocked = 1;
339     }
340 
341     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
342         _reserve0 = reserve0;
343         _reserve1 = reserve1;
344         _blockTimestampLast = blockTimestampLast;
345     }
346 
347     function _safeTransfer(address token, address to, uint value) private {
348         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
349         require(success && (data.length == 0 || abi.decode(data, (bool))), 'CroDefiSwap: TRANSFER_FAILED');
350     }
351 
352     event Mint(address indexed sender, uint amount0, uint amount1);
353     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
354     event Swap(
355         address indexed sender,
356         uint amount0In,
357         uint amount1In,
358         uint amount0Out,
359         uint amount1Out,
360         address indexed to
361     );
362     event Sync(uint112 reserve0, uint112 reserve1);
363 
364     constructor() public {
365         factory = msg.sender;
366     }
367 
368     // called once by the factory at time of deployment
369     function initialize(address _token0, address _token1) external {
370         require(msg.sender == factory, 'CroDefiSwap: FORBIDDEN'); // sufficient check
371         token0 = _token0;
372         token1 = _token1;
373     }
374 
375     // update reserves and, on the first call per block, price accumulators
376     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
377         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'CroDefiSwap: OVERFLOW');
378         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
379         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
380         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
381             // * never overflows, and + overflow is desired
382             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
383             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
384         }
385         reserve0 = uint112(balance0);
386         reserve1 = uint112(balance1);
387         blockTimestampLast = blockTimestamp;
388         emit Sync(reserve0, reserve1);
389     }
390 
391     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
392     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
393         address feeTo = ICroDefiSwapFactory(factory).feeTo();
394         uint feeToBasisPoint = ICroDefiSwapFactory(factory).feeToBasisPoint();
395 
396         feeOn = (feeTo != address(0)) && (feeToBasisPoint > 0);
397         uint _kLast = kLast; // gas savings
398         if (feeOn) {
399             if (_kLast != 0) {
400                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
401                 uint rootKLast = Math.sqrt(_kLast);
402                 if (rootK > rootKLast) {
403                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
404                     uint denominator = rootK.mul(feeToBasisPoint).add(rootKLast);
405                     uint liquidity = numerator / denominator;
406                     if (liquidity > 0) _mint(feeTo, liquidity);
407                 }
408             }
409         } else if (_kLast != 0) {
410             kLast = 0;
411         }
412     }
413 
414     // this low-level function should be called from a contract which performs important safety checks
415     function mint(address to) external lock returns (uint liquidity) {
416         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
417         uint balance0 = IERC20(token0).balanceOf(address(this));
418         uint balance1 = IERC20(token1).balanceOf(address(this));
419         uint amount0 = balance0.sub(_reserve0);
420         uint amount1 = balance1.sub(_reserve1);
421 
422         bool feeOn = _mintFee(_reserve0, _reserve1);
423         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
424         if (_totalSupply == 0) {
425             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
426            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
427         } else {
428             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
429         }
430         require(liquidity > 0, 'CroDefiSwap: INSUFFICIENT_LIQUIDITY_MINTED');
431         _mint(to, liquidity);
432 
433         _update(balance0, balance1, _reserve0, _reserve1);
434         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
435         emit Mint(msg.sender, amount0, amount1);
436     }
437 
438     // this low-level function should be called from a contract which performs important safety checks
439     function burn(address to) external lock returns (uint amount0, uint amount1) {
440         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
441         address _token0 = token0;                                // gas savings
442         address _token1 = token1;                                // gas savings
443         uint balance0 = IERC20(_token0).balanceOf(address(this));
444         uint balance1 = IERC20(_token1).balanceOf(address(this));
445         uint liquidity = balanceOf[address(this)];
446 
447         bool feeOn = _mintFee(_reserve0, _reserve1);
448         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
449         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
450         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
451         require(amount0 > 0 && amount1 > 0, 'CroDefiSwap: INSUFFICIENT_LIQUIDITY_BURNED');
452         _burn(address(this), liquidity);
453         _safeTransfer(_token0, to, amount0);
454         _safeTransfer(_token1, to, amount1);
455         balance0 = IERC20(_token0).balanceOf(address(this));
456         balance1 = IERC20(_token1).balanceOf(address(this));
457 
458         _update(balance0, balance1, _reserve0, _reserve1);
459         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
460         emit Burn(msg.sender, amount0, amount1, to);
461     }
462 
463     // this low-level function should be called from a contract which performs important safety checks
464     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
465         require(amount0Out > 0 || amount1Out > 0, 'CroDefiSwap: INSUFFICIENT_OUTPUT_AMOUNT');
466         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
467         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'CroDefiSwap: INSUFFICIENT_LIQUIDITY');
468 
469         uint balance0;
470         uint balance1;
471         { // scope for _token{0,1}, avoids stack too deep errors
472         address _token0 = token0;
473         address _token1 = token1;
474         require(to != _token0 && to != _token1, 'CroDefiSwap: INVALID_TO');
475         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
476         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
477         if (data.length > 0) ICroDefiSwapCallee(to).croDefiSwapCall(msg.sender, amount0Out, amount1Out, data);
478         balance0 = IERC20(_token0).balanceOf(address(this));
479         balance1 = IERC20(_token1).balanceOf(address(this));
480         }
481         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
482         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
483         require(amount0In > 0 || amount1In > 0, 'CroDefiSwap: INSUFFICIENT_INPUT_AMOUNT');
484         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
485         uint magnifier = 10000;
486         uint totalFeeBasisPoint = ICroDefiSwapFactory(factory).totalFeeBasisPoint();
487         uint balance0Adjusted = balance0.mul(magnifier).sub(amount0In.mul(totalFeeBasisPoint));
488         uint balance1Adjusted = balance1.mul(magnifier).sub(amount1In.mul(totalFeeBasisPoint));
489         // reference: https://uniswap.org/docs/v2/protocol-overview/glossary/#constant-product-formula
490         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(magnifier**2), 'CroDefiSwap: Constant product formula condition not met!');
491         }
492 
493         _update(balance0, balance1, _reserve0, _reserve1);
494         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
495     }
496 
497     // force balances to match reserves
498     function skim(address to) external lock {
499         address _token0 = token0; // gas savings
500         address _token1 = token1; // gas savings
501         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
502         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
503     }
504 
505     // force reserves to match balances
506     function sync() external lock {
507         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
508     }
509 }