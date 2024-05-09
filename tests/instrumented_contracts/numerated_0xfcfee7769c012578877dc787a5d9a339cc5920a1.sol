1 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function migrator() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20     function setMigrator(address) external;
21 }
22 
23 // File: contracts/uniswapv2/libraries/SafeMath.sol
24 
25 pragma solidity =0.6.12;
26 
27 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
28 
29 library SafeMathUniswap {
30     function add(uint x, uint y) internal pure returns (uint z) {
31         require((z = x + y) >= x, 'ds-math-add-overflow');
32     }
33 
34     function sub(uint x, uint y) internal pure returns (uint z) {
35         require((z = x - y) <= x, 'ds-math-sub-underflow');
36     }
37 
38     function mul(uint x, uint y) internal pure returns (uint z) {
39         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
40     }
41 }
42 
43 // File: contracts/uniswapv2/UniswapV2ERC20.sol
44 
45 pragma solidity =0.6.12;
46 
47 
48 contract UniswapV2ERC20 {
49     using SafeMathUniswap for uint;
50 
51     string public constant name = 'SushiSwap LP Token';
52     string public constant symbol = 'SLP';
53     uint8 public constant decimals = 18;
54     uint  public totalSupply;
55     mapping(address => uint) public balanceOf;
56     mapping(address => mapping(address => uint)) public allowance;
57 
58     bytes32 public DOMAIN_SEPARATOR;
59     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
60     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
61     mapping(address => uint) public nonces;
62 
63     event Approval(address indexed owner, address indexed spender, uint value);
64     event Transfer(address indexed from, address indexed to, uint value);
65 
66     constructor() public {
67         uint chainId;
68         assembly {
69             chainId := chainid()
70         }
71         DOMAIN_SEPARATOR = keccak256(
72             abi.encode(
73                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
74                 keccak256(bytes(name)),
75                 keccak256(bytes('1')),
76                 chainId,
77                 address(this)
78             )
79         );
80     }
81 
82     function _mint(address to, uint value) internal {
83         totalSupply = totalSupply.add(value);
84         balanceOf[to] = balanceOf[to].add(value);
85         emit Transfer(address(0), to, value);
86     }
87 
88     function _burn(address from, uint value) internal {
89         balanceOf[from] = balanceOf[from].sub(value);
90         totalSupply = totalSupply.sub(value);
91         emit Transfer(from, address(0), value);
92     }
93 
94     function _approve(address owner, address spender, uint value) private {
95         allowance[owner][spender] = value;
96         emit Approval(owner, spender, value);
97     }
98 
99     function _transfer(address from, address to, uint value) private {
100         balanceOf[from] = balanceOf[from].sub(value);
101         balanceOf[to] = balanceOf[to].add(value);
102         emit Transfer(from, to, value);
103     }
104 
105     function approve(address spender, uint value) external returns (bool) {
106         _approve(msg.sender, spender, value);
107         return true;
108     }
109 
110     function transfer(address to, uint value) external returns (bool) {
111         _transfer(msg.sender, to, value);
112         return true;
113     }
114 
115     function transferFrom(address from, address to, uint value) external returns (bool) {
116         if (allowance[from][msg.sender] != uint(-1)) {
117             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
118         }
119         _transfer(from, to, value);
120         return true;
121     }
122 
123     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
124         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
125         bytes32 digest = keccak256(
126             abi.encodePacked(
127                 '\x19\x01',
128                 DOMAIN_SEPARATOR,
129                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
130             )
131         );
132         address recoveredAddress = ecrecover(digest, v, r, s);
133         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
134         _approve(owner, spender, value);
135     }
136 }
137 
138 // File: contracts/uniswapv2/libraries/Math.sol
139 
140 pragma solidity =0.6.12;
141 
142 // a library for performing various math operations
143 
144 library Math {
145     function min(uint x, uint y) internal pure returns (uint z) {
146         z = x < y ? x : y;
147     }
148 
149     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
150     function sqrt(uint y) internal pure returns (uint z) {
151         if (y > 3) {
152             z = y;
153             uint x = y / 2 + 1;
154             while (x < z) {
155                 z = x;
156                 x = (y / x + x) / 2;
157             }
158         } else if (y != 0) {
159             z = 1;
160         }
161     }
162 }
163 
164 // File: contracts/uniswapv2/libraries/UQ112x112.sol
165 
166 pragma solidity =0.6.12;
167 
168 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
169 
170 // range: [0, 2**112 - 1]
171 // resolution: 1 / 2**112
172 
173 library UQ112x112 {
174     uint224 constant Q112 = 2**112;
175 
176     // encode a uint112 as a UQ112x112
177     function encode(uint112 y) internal pure returns (uint224 z) {
178         z = uint224(y) * Q112; // never overflows
179     }
180 
181     // divide a UQ112x112 by a uint112, returning a UQ112x112
182     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
183         z = x / uint224(y);
184     }
185 }
186 
187 // File: contracts/uniswapv2/interfaces/IERC20.sol
188 
189 pragma solidity >=0.5.0;
190 
191 interface IERC20Uniswap {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external view returns (string memory);
196     function symbol() external view returns (string memory);
197     function decimals() external view returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 }
206 
207 // File: contracts/uniswapv2/interfaces/IUniswapV2Callee.sol
208 
209 pragma solidity >=0.5.0;
210 
211 interface IUniswapV2Callee {
212     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
213 }
214 
215 // File: contracts/uniswapv2/UniswapV2Pair.sol
216 
217 pragma solidity =0.6.12;
218 
219 
220 
221 
222 
223 
224 
225 
226 interface IMigrator {
227     // Return the desired amount of liquidity token that the migrator wants.
228     function desiredLiquidity() external view returns (uint256);
229 }
230 
231 contract UniswapV2Pair is UniswapV2ERC20 {
232     using SafeMathUniswap  for uint;
233     using UQ112x112 for uint224;
234 
235     uint public constant MINIMUM_LIQUIDITY = 10**3;
236     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
237 
238     address public factory;
239     address public token0;
240     address public token1;
241 
242     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
243     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
244     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
245 
246     uint public price0CumulativeLast;
247     uint public price1CumulativeLast;
248     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
249 
250     uint private unlocked = 1;
251     modifier lock() {
252         require(unlocked == 1, 'UniswapV2: LOCKED');
253         unlocked = 0;
254         _;
255         unlocked = 1;
256     }
257 
258     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
259         _reserve0 = reserve0;
260         _reserve1 = reserve1;
261         _blockTimestampLast = blockTimestampLast;
262     }
263 
264     function _safeTransfer(address token, address to, uint value) private {
265         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
266         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
267     }
268 
269     event Mint(address indexed sender, uint amount0, uint amount1);
270     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
271     event Swap(
272         address indexed sender,
273         uint amount0In,
274         uint amount1In,
275         uint amount0Out,
276         uint amount1Out,
277         address indexed to
278     );
279     event Sync(uint112 reserve0, uint112 reserve1);
280 
281     constructor() public {
282         factory = msg.sender;
283     }
284 
285     // called once by the factory at time of deployment
286     function initialize(address _token0, address _token1) external {
287         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
288         token0 = _token0;
289         token1 = _token1;
290     }
291 
292     // update reserves and, on the first call per block, price accumulators
293     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
294         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
295         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
296         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
297         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
298             // * never overflows, and + overflow is desired
299             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
300             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
301         }
302         reserve0 = uint112(balance0);
303         reserve1 = uint112(balance1);
304         blockTimestampLast = blockTimestamp;
305         emit Sync(reserve0, reserve1);
306     }
307 
308     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
309     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
310         address feeTo = IUniswapV2Factory(factory).feeTo();
311         feeOn = feeTo != address(0);
312         uint _kLast = kLast; // gas savings
313         if (feeOn) {
314             if (_kLast != 0) {
315                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
316                 uint rootKLast = Math.sqrt(_kLast);
317                 if (rootK > rootKLast) {
318                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
319                     uint denominator = rootK.mul(5).add(rootKLast);
320                     uint liquidity = numerator / denominator;
321                     if (liquidity > 0) _mint(feeTo, liquidity);
322                 }
323             }
324         } else if (_kLast != 0) {
325             kLast = 0;
326         }
327     }
328 
329     // this low-level function should be called from a contract which performs important safety checks
330     function mint(address to) external lock returns (uint liquidity) {
331         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
332         uint balance0 = IERC20Uniswap(token0).balanceOf(address(this));
333         uint balance1 = IERC20Uniswap(token1).balanceOf(address(this));
334         uint amount0 = balance0.sub(_reserve0);
335         uint amount1 = balance1.sub(_reserve1);
336 
337         bool feeOn = _mintFee(_reserve0, _reserve1);
338         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
339         if (_totalSupply == 0) {
340             address migrator = IUniswapV2Factory(factory).migrator();
341             if (msg.sender == migrator) {
342                 liquidity = IMigrator(migrator).desiredLiquidity();
343                 require(liquidity > 0 && liquidity != uint256(-1), "Bad desired liquidity");
344             } else {
345                 require(migrator == address(0), "Must not have migrator");
346                 liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
347                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
348             }
349         } else {
350             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
351         }
352         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
353         _mint(to, liquidity);
354 
355         _update(balance0, balance1, _reserve0, _reserve1);
356         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
357         emit Mint(msg.sender, amount0, amount1);
358     }
359 
360     // this low-level function should be called from a contract which performs important safety checks
361     function burn(address to) external lock returns (uint amount0, uint amount1) {
362         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
363         address _token0 = token0;                                // gas savings
364         address _token1 = token1;                                // gas savings
365         uint balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
366         uint balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
367         uint liquidity = balanceOf[address(this)];
368 
369         bool feeOn = _mintFee(_reserve0, _reserve1);
370         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
371         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
372         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
373         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
374         _burn(address(this), liquidity);
375         _safeTransfer(_token0, to, amount0);
376         _safeTransfer(_token1, to, amount1);
377         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
378         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
379 
380         _update(balance0, balance1, _reserve0, _reserve1);
381         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
382         emit Burn(msg.sender, amount0, amount1, to);
383     }
384 
385     // this low-level function should be called from a contract which performs important safety checks
386     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
387         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
388         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
389         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
390 
391         uint balance0;
392         uint balance1;
393         { // scope for _token{0,1}, avoids stack too deep errors
394         address _token0 = token0;
395         address _token1 = token1;
396         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
397         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
398         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
399         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
400         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
401         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
402         }
403         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
404         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
405         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
406         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
407         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
408         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
409         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
410         }
411 
412         _update(balance0, balance1, _reserve0, _reserve1);
413         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
414     }
415 
416     // force balances to match reserves
417     function skim(address to) external lock {
418         address _token0 = token0; // gas savings
419         address _token1 = token1; // gas savings
420         _safeTransfer(_token0, to, IERC20Uniswap(_token0).balanceOf(address(this)).sub(reserve0));
421         _safeTransfer(_token1, to, IERC20Uniswap(_token1).balanceOf(address(this)).sub(reserve1));
422     }
423 
424     // force reserves to match balances
425     function sync() external lock {
426         _update(IERC20Uniswap(token0).balanceOf(address(this)), IERC20Uniswap(token1).balanceOf(address(this)), reserve0, reserve1);
427     }
428 }