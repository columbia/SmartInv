1 // File: contracts/uniswapv2/libraries/SafeMath.sol
2 
3 pragma solidity =0.6.12;
4 
5 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
6 
7 library SafeMathUniswap {
8     function add(uint x, uint y) internal pure returns (uint z) {
9         require((z = x + y) >= x, 'ds-math-add-overflow');
10     }
11 
12     function sub(uint x, uint y) internal pure returns (uint z) {
13         require((z = x - y) <= x, 'ds-math-sub-underflow');
14     }
15 
16     function mul(uint x, uint y) internal pure returns (uint z) {
17         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
18     }
19 }
20 
21 // File: contracts/uniswapv2/UniswapV2ERC20.sol
22 
23 pragma solidity =0.6.12;
24 
25 
26 contract UniswapV2ERC20 {
27     using SafeMathUniswap for uint;
28 
29     // SMARTXXX: string public constant name = 'Uniswap V2';
30     string public constant name = 'Equalizer LP Token';
31     // SMARTXXX: string public constant symbol = 'UNI-V2';
32     string public constant symbol = 'EQLP';
33     uint8 public constant decimals = 18;
34     uint  public totalSupply;
35     mapping(address => uint) public balanceOf;
36     mapping(address => mapping(address => uint)) public allowance;
37 
38     bytes32 public DOMAIN_SEPARATOR;
39     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
40     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
41     mapping(address => uint) public nonces;
42 
43     event Approval(address indexed owner, address indexed spender, uint value);
44     event Transfer(address indexed from, address indexed to, uint value);
45 
46     constructor() public {
47         uint chainId;
48         assembly {
49             chainId := chainid()
50         }
51         DOMAIN_SEPARATOR = keccak256(
52             abi.encode(
53                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
54                 keccak256(bytes(name)),
55                 keccak256(bytes('1')),
56                 chainId,
57                 address(this)
58             )
59         );
60     }
61 
62     function _mint(address to, uint value) internal {
63         totalSupply = totalSupply.add(value);
64         balanceOf[to] = balanceOf[to].add(value);
65         emit Transfer(address(0), to, value);
66     }
67 
68     function _burn(address from, uint value) internal {
69         balanceOf[from] = balanceOf[from].sub(value);
70         totalSupply = totalSupply.sub(value);
71         emit Transfer(from, address(0), value);
72     }
73 
74     function _approve(address owner, address spender, uint value) private {
75         allowance[owner][spender] = value;
76         emit Approval(owner, spender, value);
77     }
78 
79     function _transfer(address from, address to, uint value) private {
80         balanceOf[from] = balanceOf[from].sub(value);
81         balanceOf[to] = balanceOf[to].add(value);
82         emit Transfer(from, to, value);
83     }
84 
85     function approve(address spender, uint value) external returns (bool) {
86         _approve(msg.sender, spender, value);
87         return true;
88     }
89 
90     function transfer(address to, uint value) external returns (bool) {
91         _transfer(msg.sender, to, value);
92         return true;
93     }
94 
95     function transferFrom(address from, address to, uint value) external returns (bool) {
96         if (allowance[from][msg.sender] != uint(-1)) {
97             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
98         }
99         _transfer(from, to, value);
100         return true;
101     }
102 
103     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
104         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
105         bytes32 digest = keccak256(
106             abi.encodePacked(
107                 '\x19\x01',
108                 DOMAIN_SEPARATOR,
109                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
110             )
111         );
112         address recoveredAddress = ecrecover(digest, v, r, s);
113         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
114         _approve(owner, spender, value);
115     }
116 }
117 
118 // File: contracts/uniswapv2/libraries/Math.sol
119 
120 pragma solidity =0.6.12;
121 
122 // a library for performing various math operations
123 
124 library Math {
125     function min(uint x, uint y) internal pure returns (uint z) {
126         z = x < y ? x : y;
127     }
128 
129     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
130     function sqrt(uint y) internal pure returns (uint z) {
131         if (y > 3) {
132             z = y;
133             uint x = y / 2 + 1;
134             while (x < z) {
135                 z = x;
136                 x = (y / x + x) / 2;
137             }
138         } else if (y != 0) {
139             z = 1;
140         }
141     }
142 }
143 
144 // File: contracts/uniswapv2/libraries/UQ112x112.sol
145 
146 pragma solidity =0.6.12;
147 
148 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
149 
150 // range: [0, 2**112 - 1]
151 // resolution: 1 / 2**112
152 
153 library UQ112x112 {
154     uint224 constant Q112 = 2**112;
155 
156     // encode a uint112 as a UQ112x112
157     function encode(uint112 y) internal pure returns (uint224 z) {
158         z = uint224(y) * Q112; // never overflows
159     }
160 
161     // divide a UQ112x112 by a uint112, returning a UQ112x112
162     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
163         z = x / uint224(y);
164     }
165 }
166 
167 // File: contracts/uniswapv2/interfaces/IERC20.sol
168 
169 pragma solidity >=0.5.0;
170 
171 interface IERC20Uniswap {
172     event Approval(address indexed owner, address indexed spender, uint value);
173     event Transfer(address indexed from, address indexed to, uint value);
174 
175     function name() external view returns (string memory);
176     function symbol() external view returns (string memory);
177     function decimals() external view returns (uint8);
178     function totalSupply() external view returns (uint);
179     function balanceOf(address owner) external view returns (uint);
180     function allowance(address owner, address spender) external view returns (uint);
181 
182     function approve(address spender, uint value) external returns (bool);
183     function transfer(address to, uint value) external returns (bool);
184     function transferFrom(address from, address to, uint value) external returns (bool);
185 }
186 
187 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
188 
189 pragma solidity >=0.5.0;
190 
191 interface IUniswapV2Factory {
192     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
193 
194     // SMARTXXX: function feeTo() external view returns (address);
195     // SMARTXXX: function feeToSetter() external view returns (address);
196     function feeInfoSetter() external view returns (address);
197 
198     function getPair(address tokenA, address tokenB) external view returns (address pair);
199     function allPairs(uint) external view returns (address pair);
200     function allPairsLength() external view returns (uint);
201 
202     function createPair(address tokenA, address tokenB) external returns (address pair);
203 
204     // SMARTXXX: function setFeeTo(address) external;
205     function setFeeInfo(address, uint32, uint32) external;
206     // SMARTXXX: function setFeeToSetter(address) external;
207     function setFeeInfoSetter(address) external;
208 
209     // SMARTXXX: fee info getter
210     function getFeeInfo() external view returns (address, uint32, uint32);
211 }
212 
213 // File: contracts/uniswapv2/interfaces/IUniswapV2Callee.sol
214 
215 pragma solidity >=0.5.0;
216 
217 interface IUniswapV2Callee {
218     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
219 }
220 
221 // File: contracts/uniswapv2/UniswapV2Pair.sol
222 
223 pragma solidity =0.6.12;
224 
225 
226 
227 
228 
229 
230 
231 
232 contract UniswapV2Pair is UniswapV2ERC20 {
233     using SafeMathUniswap  for uint;
234     using UQ112x112 for uint224;
235 
236     uint public constant MINIMUM_LIQUIDITY = 10**3;
237     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
238 
239     address public factory;
240     address public token0;
241     address public token1;
242 
243     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
244     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
245     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
246 
247     uint public price0CumulativeLast;
248     uint public price1CumulativeLast;
249     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
250 
251     uint private unlocked = 1;
252     modifier lock() {
253         require(unlocked == 1, 'UniswapV2: LOCKED');
254         unlocked = 2;
255         _;
256         unlocked = 1;
257     }
258 
259     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
260         _reserve0 = reserve0;
261         _reserve1 = reserve1;
262         _blockTimestampLast = blockTimestampLast;
263     }
264 
265     function _safeTransfer(address token, address to, uint value) private {
266         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
267         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
268     }
269 
270     event Mint(address indexed sender, uint amount0, uint amount1);
271     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
272     event Swap(
273         address indexed sender,
274         uint amount0In,
275         uint amount1In,
276         uint amount0Out,
277         uint amount1Out,
278         address indexed to
279     );
280     event Sync(uint112 reserve0, uint112 reserve1);
281 
282     constructor() public {
283         factory = msg.sender;
284     }
285 
286     // called once by the factory at time of deployment
287     function initialize(address _token0, address _token1) external {
288         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
289         token0 = _token0;
290         token1 = _token1;
291     }
292 
293     // update reserves and, on the first call per block, price accumulators
294     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
295         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
296         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
297         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
298         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
299             // * never overflows, and + overflow is desired
300             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
301             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
302         }
303         reserve0 = uint112(balance0);
304         reserve1 = uint112(balance1);
305         blockTimestampLast = blockTimestamp;
306         emit Sync(reserve0, reserve1);
307     }
308 
309     // if fee is on, mint liquidity equivalent to n/m th of the growth in sqrt(k)
310     // where n and m are parameters read from factory
311     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
312         // SMARTXXX: address feeTo = IUniswapV2Factory(factory).feeTo();
313         (address feeTo, uint32 numMul, uint32 denomMul) = IUniswapV2Factory(factory).getFeeInfo();
314         require(numMul <= denomMul, "Invalid fee info");
315         feeOn = feeTo != address(0);
316         uint _kLast = kLast; // gas savings
317         if (feeOn) {
318             if (_kLast != 0) {
319                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
320                 uint rootKLast = Math.sqrt(_kLast);
321                 if (rootK > rootKLast) {
322                     // SMARTXXX: uint numerator = totalSupply.mul(rootK.sub(rootKLast));
323                     uint numerator = totalSupply.mul(rootK.sub(rootKLast).mul(numMul));
324                     // SMARTXXX: uint denominator = rootK.mul(5).add(rootKLast);
325                     uint denominator = rootK.mul(denomMul).add(rootKLast);
326                     uint liquidity = numerator / denominator;
327                     if (liquidity > 0) _mint(feeTo, liquidity);
328                 }
329             }
330         } else if (_kLast != 0) {
331             kLast = 0;
332         }
333     }
334 
335     // this low-level function should be called from a contract which performs important safety checks
336     function mint(address to) external lock returns (uint liquidity) {
337         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
338         uint balance0 = IERC20Uniswap(token0).balanceOf(address(this));
339         uint balance1 = IERC20Uniswap(token1).balanceOf(address(this));
340         uint amount0 = balance0.sub(_reserve0);
341         uint amount1 = balance1.sub(_reserve1);
342 
343         bool feeOn = _mintFee(_reserve0, _reserve1);
344         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
345         if (_totalSupply == 0) {
346             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
347             _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
348         } else {
349             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
350         }
351         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
352         _mint(to, liquidity);
353 
354         _update(balance0, balance1, _reserve0, _reserve1);
355         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
356         emit Mint(msg.sender, amount0, amount1);
357     }
358 
359     // this low-level function should be called from a contract which performs important safety checks
360     function burn(address to) external lock returns (uint amount0, uint amount1) {
361         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
362         address _token0 = token0;                                // gas savings
363         address _token1 = token1;                                // gas savings
364         uint balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
365         uint balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
366         uint liquidity = balanceOf[address(this)];
367 
368         bool feeOn = _mintFee(_reserve0, _reserve1);
369         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
370         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
371         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
372         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
373         _burn(address(this), liquidity);
374         _safeTransfer(_token0, to, amount0);
375         _safeTransfer(_token1, to, amount1);
376         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
377         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
378 
379         _update(balance0, balance1, _reserve0, _reserve1);
380         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
381         emit Burn(msg.sender, amount0, amount1, to);
382     }
383 
384     // this low-level function should be called from a contract which performs important safety checks
385     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
386         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
387         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
388         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
389 
390         uint balance0;
391         uint balance1;
392         { // scope for _token{0,1}, avoids stack too deep errors
393         address _token0 = token0;
394         address _token1 = token1;
395         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
396         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
397         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
398         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
399         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
400         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
401         }
402         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
403         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
404         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
405         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
406         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
407         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
408         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
409         }
410 
411         _update(balance0, balance1, _reserve0, _reserve1);
412         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
413     }
414 
415     // force balances to match reserves
416     function skim(address to) external lock {
417         address _token0 = token0; // gas savings
418         address _token1 = token1; // gas savings
419         _safeTransfer(_token0, to, IERC20Uniswap(_token0).balanceOf(address(this)).sub(reserve0));
420         _safeTransfer(_token1, to, IERC20Uniswap(_token1).balanceOf(address(this)).sub(reserve1));
421     }
422 
423     // force reserves to match balances
424     function sync() external lock {
425         _update(IERC20Uniswap(token0).balanceOf(address(this)), IERC20Uniswap(token1).balanceOf(address(this)), reserve0, reserve1);
426     }
427 }