1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-31
3 */
4 
5 pragma solidity >=0.5.0;
6 
7 interface ISumswapV2Factory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9 
10     function feeTo() external view returns (address);
11     function feeToSetter() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21 }
22 
23 pragma solidity >=0.5.0;
24 
25 interface ISumiswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66 
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72 
73     function initialize(address, address) external;
74 }
75 
76 pragma solidity >=0.5.16;
77 
78 // a library for performing various math operations
79 
80 library Math {
81     function min(uint x, uint y) internal pure returns (uint z) {
82         z = x < y ? x : y;
83     }
84 
85     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
86     function sqrt(uint y) internal pure returns (uint z) {
87         if (y > 3) {
88             z = y;
89             uint x = y / 2 + 1;
90             while (x < z) {
91                 z = x;
92                 x = (y / x + x) / 2;
93             }
94         } else if (y != 0) {
95             z = 1;
96         }
97     }
98 }
99 
100 pragma solidity >=0.5.16;
101 
102 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
103 
104 // range: [0, 2**112 - 1]
105 // resolution: 1 / 2**112
106 
107 library UQ112x112 {
108     uint224 constant Q112 = 2**112;
109 
110     // encode a uint112 as a UQ112x112
111     function encode(uint112 y) internal pure returns (uint224 z) {
112         z = uint224(y) * Q112; // never overflows
113     }
114 
115     // divide a UQ112x112 by a uint112, returning a UQ112x112
116     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
117         z = x / uint224(y);
118     }
119 }
120 
121 pragma solidity >=0.5.0;
122 
123 interface IERC20Sumswap{
124     event Approval(address indexed owner, address indexed spender, uint value);
125     event Transfer(address indexed from, address indexed to, uint value);
126 
127     function name() external view returns (string memory);
128     function symbol() external view returns (string memory);
129     function decimals() external view returns (uint8);
130     function totalSupply() external view returns (uint);
131     function balanceOf(address owner) external view returns (uint);
132     function allowance(address owner, address spender) external view returns (uint);
133 
134     function approve(address spender, uint value) external returns (bool);
135     function transfer(address to, uint value) external returns (bool);
136     function transferFrom(address from, address to, uint value) external returns (bool);
137 }
138 
139 pragma solidity >=0.5.0;
140 
141 interface ISumswapV2Callee {
142     function sumswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
143 }
144 
145 pragma solidity >=0.6.6;
146 
147 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
148 
149 library SafeMathSumswap {
150     function add(uint x, uint y) internal pure returns (uint z) {
151         require((z = x + y) >= x, 'ds-math-add-overflow');
152     }
153 
154     function sub(uint x, uint y) internal pure returns (uint z) {
155         require((z = x - y) <= x, 'ds-math-sub-underflow');
156     }
157 
158     function mul(uint x, uint y) internal pure returns (uint z) {
159         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
160     }
161 }
162 
163 pragma solidity >=0.5.16;
164 
165 
166 contract SumswapV2Pair is ISumiswapV2Pair {
167     using SafeMathSumswap  for uint;
168     using UQ112x112 for uint224;
169 
170     string public override constant name = 'SummaSwap LP Token';
171     string public override constant symbol = 'SLP';
172     uint8 public override constant decimals = 18;
173     uint  public override totalSupply;
174     mapping(address => uint) public override balanceOf;
175     mapping(address => mapping(address => uint)) public override allowance;
176 
177     bytes32 public override DOMAIN_SEPARATOR;
178     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
179     bytes32 public constant override PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
180     mapping(address => uint) public override nonces;
181 
182     event Approval(address indexed owner, address indexed spender, uint value);
183     event Transfer(address indexed from, address indexed to, uint value);
184 
185     uint public override constant MINIMUM_LIQUIDITY = 10**3;
186     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
187 
188     address public override factory;
189     address public override token0;
190     address public override token1;
191 
192     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
193     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
194     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
195 
196     uint public override price0CumulativeLast;
197     uint public override price1CumulativeLast;
198     uint public override kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
199 
200     uint private unlocked = 1;
201     modifier lock() {
202         require(unlocked == 1, 'SumswapV2: LOCKED');
203         unlocked = 0;
204         _;
205         unlocked = 1;
206     }
207 
208     function getReserves() public override view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
209         _reserve0 = reserve0;
210         _reserve1 = reserve1;
211         _blockTimestampLast = blockTimestampLast;
212     }
213 
214     function _safeTransfer(address token, address to, uint value) private {
215         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
216         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SumswapV2: TRANSFER_FAILED');
217     }
218 
219     event Mint(address indexed sender, uint amount0, uint amount1);
220     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
221     event Swap(
222         address indexed sender,
223         uint amount0In,
224         uint amount1In,
225         uint amount0Out,
226         uint amount1Out,
227         address indexed to
228     );
229     event Sync(uint112 reserve0, uint112 reserve1);
230 
231     constructor() public {
232         factory = msg.sender;
233         uint chainId;
234         assembly {
235             chainId := chainid()
236         }
237         DOMAIN_SEPARATOR = keccak256(
238             abi.encode(
239                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
240                 keccak256(bytes(name)),
241                 keccak256(bytes('1')),
242                 chainId,
243                 address(this)
244             )
245         );
246     }
247 
248     // called once by the factory at time of deployment
249     function initialize(address _token0, address _token1) external virtual override {
250         require(msg.sender == factory, 'SumswapV2: FORBIDDEN'); // sufficient check
251         token0 = _token0;
252         token1 = _token1;
253     }
254 
255     // update reserves and, on the first call per block, price accumulators
256     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
257         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'SumswapV2: OVERFLOW');
258         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
259         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
260         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
261             // * never overflows, and + overflow is desired
262             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
263             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
264         }
265         reserve0 = uint112(balance0);
266         reserve1 = uint112(balance1);
267         blockTimestampLast = blockTimestamp;
268         emit Sync(reserve0, reserve1);
269     }
270 
271     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
272     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
273         address feeTo = ISumswapV2Factory(factory).feeTo();
274         feeOn = feeTo != address(0);
275         uint _kLast = kLast; // gas savings
276         if (feeOn) {
277             if (_kLast != 0) {
278                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
279                 uint rootKLast = Math.sqrt(_kLast);
280                 if (rootK > rootKLast) {
281                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
282                     uint denominator = rootK.mul(2).add(rootKLast);
283                     uint liquidity = numerator / denominator;
284                     if (liquidity > 0) _mint(feeTo, liquidity);
285                 }
286             }
287         } else if (_kLast != 0) {
288             kLast = 0;
289         }
290     }
291 
292     // this low-level function should be called from a contract which performs important safety checks
293     function mint(address to) external virtual override lock returns (uint liquidity) {
294         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
295         uint balance0 = IERC20Sumswap(token0).balanceOf(address(this));
296         uint balance1 = IERC20Sumswap(token1).balanceOf(address(this));
297         uint amount0 = balance0.sub(_reserve0);
298         uint amount1 = balance1.sub(_reserve1);
299 
300         bool feeOn = _mintFee(_reserve0, _reserve1);
301         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
302         if (_totalSupply == 0) {
303             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
304            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
305         } else {
306             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
307         }
308         require(liquidity > 0, 'SumswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
309         _mint(to, liquidity);
310 
311         _update(balance0, balance1, _reserve0, _reserve1);
312         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
313         emit Mint(msg.sender, amount0, amount1);
314     }
315 
316     function _mint(address to, uint value) internal {
317         totalSupply = totalSupply.add(value);
318         balanceOf[to] = balanceOf[to].add(value);
319         emit Transfer(address(0), to, value);
320     }
321 
322     // this low-level function should be called from a contract which performs important safety checks
323     function burn(address to) external virtual override lock returns (uint amount0, uint amount1) {
324         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
325         address _token0 = token0;                                // gas savings
326         address _token1 = token1;                                // gas savings
327         uint balance0 = IERC20Sumswap(_token0).balanceOf(address(this));
328         uint balance1 = IERC20Sumswap(_token1).balanceOf(address(this));
329         uint liquidity = balanceOf[address(this)];
330 
331         bool feeOn = _mintFee(_reserve0, _reserve1);
332         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
333         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
334         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
335         require(amount0 > 0 && amount1 > 0, 'SumswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
336         _burn(address(this), liquidity);
337         _safeTransfer(_token0, to, amount0);
338         _safeTransfer(_token1, to, amount1);
339         balance0 = IERC20Sumswap(_token0).balanceOf(address(this));
340         balance1 = IERC20Sumswap(_token1).balanceOf(address(this));
341 
342         _update(balance0, balance1, _reserve0, _reserve1);
343         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
344         emit Burn(msg.sender, amount0, amount1, to);
345     }
346 
347     function _burn(address from, uint value) internal {
348         balanceOf[from] = balanceOf[from].sub(value);
349         totalSupply = totalSupply.sub(value);
350         emit Transfer(from, address(0), value);
351     }
352 
353     // this low-level function should be called from a contract which performs important safety checks
354     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external virtual override lock {
355         require(amount0Out > 0 || amount1Out > 0, 'SumswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
356         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
357         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'SumswapV2: INSUFFICIENT_LIQUIDITY');
358 
359         uint balance0;
360         uint balance1;
361         { // scope for _token{0,1}, avoids stack too deep errors
362         address _token0 = token0;
363         address _token1 = token1;
364         require(to != _token0 && to != _token1, 'SumswapV2: INVALID_TO');
365         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
366         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
367         if (data.length > 0) ISumswapV2Callee(to).sumswapV2Call(msg.sender, amount0Out, amount1Out, data);
368         balance0 = IERC20Sumswap(_token0).balanceOf(address(this));
369         balance1 = IERC20Sumswap(_token1).balanceOf(address(this));
370         }
371         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
372         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
373         require(amount0In > 0 || amount1In > 0, 'SumswapV2: INSUFFICIENT_INPUT_AMOUNT');
374         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
375         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
376         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
377         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'SumswapV2: K');
378         }
379 
380         _update(balance0, balance1, _reserve0, _reserve1);
381         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
382     }
383 
384     // force balances to match reserves
385     function skim(address to) external virtual override lock {
386         address _token0 = token0; // gas savings
387         address _token1 = token1; // gas savings
388         _safeTransfer(_token0, to, IERC20Sumswap(_token0).balanceOf(address(this)).sub(reserve0));
389         _safeTransfer(_token1, to, IERC20Sumswap(_token1).balanceOf(address(this)).sub(reserve1));
390     }
391 
392     // force reserves to match balances
393     function sync() external virtual override lock {
394         _update(IERC20Sumswap(token0).balanceOf(address(this)), IERC20Sumswap(token1).balanceOf(address(this)), reserve0, reserve1);
395     }
396 
397     function _approve(address owner, address spender, uint value) private {
398         allowance[owner][spender] = value;
399         emit Approval(owner, spender, value);
400     }
401 
402     function _transfer(address from, address to, uint value) private {
403         balanceOf[from] = balanceOf[from].sub(value);
404         balanceOf[to] = balanceOf[to].add(value);
405         emit Transfer(from, to, value);
406     }
407 
408     function approve(address spender, uint value) external virtual override returns (bool) {
409         _approve(msg.sender, spender, value);
410         return true;
411     }
412 
413     function transfer(address to, uint value) external virtual override returns (bool) {
414         _transfer(msg.sender, to, value);
415         return true;
416     }
417 
418     function transferFrom(address from, address to, uint value) external virtual override returns (bool) {
419         if (allowance[from][msg.sender] != uint(-1)) {
420         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
421         }
422         _transfer(from, to, value);
423         return true;
424     }
425 
426     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external virtual override {
427         require(deadline >= block.timestamp, 'SumswapV2: EXPIRED');
428         bytes32 digest = keccak256(
429             abi.encodePacked(
430                 '\x19\x01',
431                 DOMAIN_SEPARATOR,
432                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
433                 )
434             );
435         address recoveredAddress = ecrecover(digest, v, r, s);
436         require(recoveredAddress != address(0) && recoveredAddress == owner, 'SumswapV2: INVALID_SIGNATURE');
437         _approve(owner, spender, value);
438     }
439 }