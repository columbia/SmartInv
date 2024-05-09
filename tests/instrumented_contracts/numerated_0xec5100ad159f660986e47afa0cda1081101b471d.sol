1 // Dependency file: contracts/libraries/SafeMath.sol
2 
3 // pragma solidity =0.6.12;
4 
5 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
6 
7 library SafeMath {
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
21 // Dependency file: contracts/interfaces/IUnicSwapV2Callee.sol
22 
23 // pragma solidity >=0.5.0;
24 
25 interface IUnicSwapV2Callee {
26     function unicSwapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
27 }
28 
29 // Dependency file: contracts/interfaces/IUnicSwapV2Factory.sol
30 
31 // pragma solidity >=0.5.0;
32 
33 interface IUnicSwapV2Factory {
34     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
35 
36     function feeTo() external view returns (address);
37     function feeToSetter() external view returns (address);
38 
39     function getPair(address tokenA, address tokenB) external view returns (address pair);
40     function allPairs(uint) external view returns (address pair);
41     function allPairsLength() external view returns (uint);
42 
43     function createPair(address tokenA, address tokenB) external returns (address pair);
44 
45     function setFeeTo(address) external;
46     function setFeeToSetter(address) external;
47 }
48 
49 // Dependency file: contracts/interfaces/IERC20.sol
50 
51 // pragma solidity >=0.5.0;
52 
53 interface IERC20 {
54     event Approval(address indexed owner, address indexed spender, uint value);
55     event Transfer(address indexed from, address indexed to, uint value);
56 
57     function name() external view returns (string memory);
58     function symbol() external view returns (string memory);
59     function decimals() external view returns (uint8);
60     function totalSupply() external view returns (uint);
61     function balanceOf(address owner) external view returns (uint);
62     function allowance(address owner, address spender) external view returns (uint);
63 
64     function approve(address spender, uint value) external returns (bool);
65     function transfer(address to, uint value) external returns (bool);
66     function transferFrom(address from, address to, uint value) external returns (bool);
67 }
68 
69 // Dependency file: contracts/libraries/UQ112x112.sol
70 
71 // pragma solidity 0.6.12;
72 
73 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
74 
75 // range: [0, 2**112 - 1]
76 // resolution: 1 / 2**112
77 
78 library UQ112x112 {
79     uint224 constant Q112 = 2**112;
80 
81     // encode a uint112 as a UQ112x112
82     function encode(uint112 y) internal pure returns (uint224 z) {
83         z = uint224(y) * Q112; // never overflows
84     }
85 
86     // divide a UQ112x112 by a uint112, returning a UQ112x112
87     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
88         z = x / uint224(y);
89     }
90 }
91 
92 // Dependency file: contracts/libraries/Math.sol
93 
94 // pragma solidity =0.6.12;
95 
96 // a library for performing various math operations
97 
98 library Math {
99     function min(uint x, uint y) internal pure returns (uint z) {
100         z = x < y ? x : y;
101     }
102 
103     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
104     function sqrt(uint y) internal pure returns (uint z) {
105         if (y > 3) {
106             z = y;
107             uint x = y / 2 + 1;
108             while (x < z) {
109                 z = x;
110                 x = (y / x + x) / 2;
111             }
112         } else if (y != 0) {
113             z = 1;
114         }
115     }
116 }
117 
118 // Dependency file: contracts/UnicSwapV2ERC20.sol
119 
120 // pragma solidity =0.6.12;
121 
122 // import './libraries/SafeMath.sol';
123 
124 contract UnicSwapV2ERC20 {
125     using SafeMath for uint;
126 
127     string public constant name = 'UnicSwap LP Token';
128     string public constant symbol = 'UPT';
129     uint8 public constant decimals = 18;
130     uint  public totalSupply;
131     mapping(address => uint) public balanceOf;
132     mapping(address => mapping(address => uint)) public allowance;
133 
134     bytes32 public DOMAIN_SEPARATOR;
135     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
136     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
137     mapping(address => uint) public nonces;
138 
139     event Approval(address indexed owner, address indexed spender, uint value);
140     event Transfer(address indexed from, address indexed to, uint value);
141 
142     constructor() public {
143         uint chainId;
144         assembly {
145             chainId := chainid()
146         }
147         DOMAIN_SEPARATOR = keccak256(
148             abi.encode(
149                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
150                 keccak256(bytes(name)),
151                 keccak256(bytes('1')),
152                 chainId,
153                 address(this)
154             )
155         );
156     }
157 
158     function _mint(address to, uint value) internal {
159         totalSupply = totalSupply.add(value);
160         balanceOf[to] = balanceOf[to].add(value);
161         emit Transfer(address(0), to, value);
162     }
163 
164     function _burn(address from, uint value) internal {
165         balanceOf[from] = balanceOf[from].sub(value);
166         totalSupply = totalSupply.sub(value);
167         emit Transfer(from, address(0), value);
168     }
169 
170     function _approve(address owner, address spender, uint value) private {
171         allowance[owner][spender] = value;
172         emit Approval(owner, spender, value);
173     }
174 
175     function _transfer(address from, address to, uint value) private {
176         balanceOf[from] = balanceOf[from].sub(value);
177         balanceOf[to] = balanceOf[to].add(value);
178         emit Transfer(from, to, value);
179     }
180 
181     function approve(address spender, uint value) external returns (bool) {
182         _approve(msg.sender, spender, value);
183         return true;
184     }
185 
186     function transfer(address to, uint value) external returns (bool) {
187         _transfer(msg.sender, to, value);
188         return true;
189     }
190 
191     function transferFrom(address from, address to, uint value) external returns (bool) {
192         if (allowance[from][msg.sender] != uint(-1)) {
193             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
194         }
195         _transfer(from, to, value);
196         return true;
197     }
198 
199     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
200         require(deadline >= block.timestamp, 'UnicSwap: EXPIRED');
201         bytes32 digest = keccak256(
202             abi.encodePacked(
203                 '\x19\x01',
204                 DOMAIN_SEPARATOR,
205                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
206             )
207         );
208         address recoveredAddress = ecrecover(digest, v, r, s);
209         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UnicSwap: INVALID_SIGNATURE');
210         _approve(owner, spender, value);
211     }
212 }
213 
214 pragma solidity =0.6.12;
215 
216 // import './UnicSwapV2ERC20.sol';
217 // import './libraries/Math.sol';
218 // import './libraries/UQ112x112.sol';
219 // import './interfaces/IERC20.sol';
220 // import './interfaces/IUnicSwapV2Factory.sol';
221 // import './interfaces/IUnicSwapV2Callee.sol';
222 
223 contract UnicSwapV2Pair is UnicSwapV2ERC20 {
224     using SafeMath  for uint;
225     using UQ112x112 for uint224;
226 
227     uint public constant MINIMUM_LIQUIDITY = 10**3;
228     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
229 
230     address public factory;
231     address public token0;
232     address public token1;
233 
234     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
235     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
236     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
237 
238     uint public price0CumulativeLast;
239     uint public price1CumulativeLast;
240     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
241 
242     uint private unlocked = 1;
243     modifier lock() {
244         require(unlocked == 1, 'UnicSwap: LOCKED');
245         unlocked = 0;
246         _;
247         unlocked = 1;
248     }
249 
250     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
251         _reserve0 = reserve0;
252         _reserve1 = reserve1;
253         _blockTimestampLast = blockTimestampLast;
254     }
255 
256     function _safeTransfer(address token, address to, uint value) private {
257         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
258         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UnicSwap: TRANSFER_FAILED');
259     }
260 
261     event Mint(address indexed sender, uint amount0, uint amount1);
262     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
263     event Swap(
264         address indexed sender,
265         uint amount0In,
266         uint amount1In,
267         uint amount0Out,
268         uint amount1Out,
269         address indexed to
270     );
271     event Sync(uint112 reserve0, uint112 reserve1);
272 
273     constructor() public {
274         factory = msg.sender;
275     }
276 
277     // called once by the factory at time of deployment
278     function initialize(address _token0, address _token1) external {
279         require(msg.sender == factory, 'UnicSwap: FORBIDDEN'); // sufficient check
280         token0 = _token0;
281         token1 = _token1;
282     }
283 
284     // update reserves and, on the first call per block, price accumulators
285     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
286         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UnicSwap: OVERFLOW');
287         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
288         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
289         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
290             // * never overflows, and + overflow is desired
291             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
292             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
293         }
294         reserve0 = uint112(balance0);
295         reserve1 = uint112(balance1);
296         blockTimestampLast = blockTimestamp;
297         emit Sync(reserve0, reserve1);
298     }
299 
300     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
301     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
302         address feeTo = IUnicSwapV2Factory(factory).feeTo();
303         feeOn = feeTo != address(0);
304         uint _kLast = kLast; // gas savings
305         if (feeOn) {
306             if (_kLast != 0) {
307                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
308                 uint rootKLast = Math.sqrt(_kLast);
309                 if (rootK > rootKLast) {
310                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
311                     uint denominator = rootK.mul(5).add(rootKLast);
312                     uint liquidity = numerator / denominator;
313                     if (liquidity > 0) _mint(feeTo, liquidity);
314                 }
315             }
316         } else if (_kLast != 0) {
317             kLast = 0;
318         }
319     }
320 
321     // this low-level function should be called from a contract which performs // important safety checks
322     function mint(address to) external lock returns (uint liquidity) {
323         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
324         uint balance0 = IERC20(token0).balanceOf(address(this));
325         uint balance1 = IERC20(token1).balanceOf(address(this));
326         uint amount0 = balance0.sub(_reserve0);
327         uint amount1 = balance1.sub(_reserve1);
328 
329         bool feeOn = _mintFee(_reserve0, _reserve1);
330         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
331         if (_totalSupply == 0) {
332             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
333            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
334         } else {
335             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
336         }
337         require(liquidity > 0, 'UnicSwap: INSUFFICIENT_LIQUIDITY_MINTED');
338         _mint(to, liquidity);
339 
340         _update(balance0, balance1, _reserve0, _reserve1);
341         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
342         emit Mint(msg.sender, amount0, amount1);
343     }
344 
345     // this low-level function should be called from a contract which performs // important safety checks
346     function burn(address to) external lock returns (uint amount0, uint amount1) {
347         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
348         address _token0 = token0;                                // gas savings
349         address _token1 = token1;                                // gas savings
350         uint balance0 = IERC20(_token0).balanceOf(address(this));
351         uint balance1 = IERC20(_token1).balanceOf(address(this));
352         uint liquidity = balanceOf[address(this)];
353 
354         bool feeOn = _mintFee(_reserve0, _reserve1);
355         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
356         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
357         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
358         require(amount0 > 0 && amount1 > 0, 'UnicSwap: INSUFFICIENT_LIQUIDITY_BURNED');
359         _burn(address(this), liquidity);
360         _safeTransfer(_token0, to, amount0);
361         _safeTransfer(_token1, to, amount1);
362         balance0 = IERC20(_token0).balanceOf(address(this));
363         balance1 = IERC20(_token1).balanceOf(address(this));
364 
365         _update(balance0, balance1, _reserve0, _reserve1);
366         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
367         emit Burn(msg.sender, amount0, amount1, to);
368     }
369 
370     // this low-level function should be called from a contract which performs // important safety checks
371     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
372         require(amount0Out > 0 || amount1Out > 0, 'UnicSwap: INSUFFICIENT_OUTPUT_AMOUNT');
373         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
374         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UnicSwap: INSUFFICIENT_LIQUIDITY');
375 
376         uint balance0;
377         uint balance1;
378         { // scope for _token{0,1}, avoids stack too deep errors
379         address _token0 = token0;
380         address _token1 = token1;
381         require(to != _token0 && to != _token1, 'UnicSwap: INVALID_TO');
382         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
383         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
384         if (data.length > 0) IUnicSwapV2Callee(to).unicSwapV2Call(msg.sender, amount0Out, amount1Out, data);
385         balance0 = IERC20(_token0).balanceOf(address(this));
386         balance1 = IERC20(_token1).balanceOf(address(this));
387         }
388         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
389         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
390         require(amount0In > 0 || amount1In > 0, 'UnicSwap: INSUFFICIENT_INPUT_AMOUNT');
391         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
392         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
393         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
394         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UnicSwap: K');
395         }
396 
397         _update(balance0, balance1, _reserve0, _reserve1);
398         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
399     }
400 
401     // force balances to match reserves
402     function skim(address to) external lock {
403         address _token0 = token0; // gas savings
404         address _token1 = token1; // gas savings
405         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
406         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
407     }
408 
409     // force reserves to match balances
410     function sync() external lock {
411         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
412     }
413 }