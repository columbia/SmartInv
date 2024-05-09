1 pragma solidity =0.6.12;
2 
3 interface IUniswapV2Factory {
4     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
5 
6     function feeTo() external view returns (address);
7     function feeToSetter() external view returns (address);
8     function migrator() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18     function setMigrator(address) external;
19 }
20 
21 library Math {
22     function min(uint x, uint y) internal pure returns (uint z) {
23         z = x < y ? x : y;
24     }
25 
26     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
27     function sqrt(uint y) internal pure returns (uint z) {
28         if (y > 3) {
29             z = y;
30             uint x = y / 2 + 1;
31             while (x < z) {
32                 z = x;
33                 x = (y / x + x) / 2;
34             }
35         } else if (y != 0) {
36             z = 1;
37         }
38     }
39 }
40 
41 library SafeMathUniswap {
42     function add(uint x, uint y) internal pure returns (uint z) {
43         require((z = x + y) >= x, 'ds-math-add-overflow');
44     }
45 
46     function sub(uint x, uint y) internal pure returns (uint z) {
47         require((z = x - y) <= x, 'ds-math-sub-underflow');
48     }
49 
50     function mul(uint x, uint y) internal pure returns (uint z) {
51         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
52     }
53 }
54 
55 contract UniswapV2ERC20 {
56     using SafeMathUniswap for uint;
57 
58     string public constant name = 'SunflowerSwap LP Token';
59     string public constant symbol = 'SLP';
60     uint8 public constant decimals = 18;
61     uint  public totalSupply;
62     mapping(address => uint) public balanceOf;
63     mapping(address => mapping(address => uint)) public allowance;
64 
65     bytes32 public DOMAIN_SEPARATOR;
66     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
67     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
68     mapping(address => uint) public nonces;
69 
70     event Approval(address indexed owner, address indexed spender, uint value);
71     event Transfer(address indexed from, address indexed to, uint value);
72 
73     constructor() public {
74         uint chainId;
75         assembly {
76             chainId := chainid()
77         }
78         DOMAIN_SEPARATOR = keccak256(
79             abi.encode(
80                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
81                 keccak256(bytes(name)),
82                 keccak256(bytes('1')),
83                 chainId,
84                 address(this)
85             )
86         );
87     }
88 
89     function _mint(address to, uint value) internal {
90         totalSupply = totalSupply.add(value);
91         balanceOf[to] = balanceOf[to].add(value);
92         emit Transfer(address(0), to, value);
93     }
94 
95     function _burn(address from, uint value) internal {
96         balanceOf[from] = balanceOf[from].sub(value);
97         totalSupply = totalSupply.sub(value);
98         emit Transfer(from, address(0), value);
99     }
100 
101     function _approve(address owner, address spender, uint value) private {
102         allowance[owner][spender] = value;
103         emit Approval(owner, spender, value);
104     }
105 
106     function _transfer(address from, address to, uint value) private {
107         balanceOf[from] = balanceOf[from].sub(value);
108         balanceOf[to] = balanceOf[to].add(value);
109         emit Transfer(from, to, value);
110     }
111 
112     function approve(address spender, uint value) external returns (bool) {
113         _approve(msg.sender, spender, value);
114         return true;
115     }
116 
117     function transfer(address to, uint value) external returns (bool) {
118         _transfer(msg.sender, to, value);
119         return true;
120     }
121 
122     function transferFrom(address from, address to, uint value) external returns (bool) {
123         if (allowance[from][msg.sender] != uint(-1)) {
124             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
125         }
126         _transfer(from, to, value);
127         return true;
128     }
129 
130     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
131         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
132         bytes32 digest = keccak256(
133             abi.encodePacked(
134                 '\x19\x01',
135                 DOMAIN_SEPARATOR,
136                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
137             )
138         );
139         address recoveredAddress = ecrecover(digest, v, r, s);
140         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
141         _approve(owner, spender, value);
142     }
143 }
144 
145 
146 library UQ112x112 {
147     uint224 constant Q112 = 2**112;
148 
149     // encode a uint112 as a UQ112x112
150     function encode(uint112 y) internal pure returns (uint224 z) {
151         z = uint224(y) * Q112; // never overflows
152     }
153 
154     // divide a UQ112x112 by a uint112, returning a UQ112x112
155     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
156         z = x / uint224(y);
157     }
158 }
159 
160 interface IERC20Uniswap {
161     event Approval(address indexed owner, address indexed spender, uint value);
162     event Transfer(address indexed from, address indexed to, uint value);
163 
164     function name() external view returns (string memory);
165     function symbol() external view returns (string memory);
166     function decimals() external view returns (uint8);
167     function totalSupply() external view returns (uint);
168     function balanceOf(address owner) external view returns (uint);
169     function allowance(address owner, address spender) external view returns (uint);
170 
171     function approve(address spender, uint value) external returns (bool);
172     function transfer(address to, uint value) external returns (bool);
173     function transferFrom(address from, address to, uint value) external returns (bool);
174 }
175 
176 interface IUniswapV2Callee {
177     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
178 }
179 
180 
181 interface IMigrator {
182     // Return the desired amount of liquidity token that the migrator wants.
183     function desiredLiquidity() external view returns (uint256);
184 }
185 
186 contract UniswapV2Pair is UniswapV2ERC20 {
187     using SafeMathUniswap  for uint;
188     using UQ112x112 for uint224;
189 
190     uint public constant MINIMUM_LIQUIDITY = 10**3;
191     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
192 
193     address public factory;
194     address public token0;
195     address public token1;
196 
197     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
198     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
199     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
200 
201     uint public price0CumulativeLast;
202     uint public price1CumulativeLast;
203     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
204 
205     uint private unlocked = 1;
206     modifier lock() {
207         require(unlocked == 1, 'UniswapV2: LOCKED');
208         unlocked = 0;
209         _;
210         unlocked = 1;
211     }
212 
213     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
214         _reserve0 = reserve0;
215         _reserve1 = reserve1;
216         _blockTimestampLast = blockTimestampLast;
217     }
218 
219     function _safeTransfer(address token, address to, uint value) private {
220         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
221         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
222     }
223 
224     event Mint(address indexed sender, uint amount0, uint amount1);
225     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
226     event Swap(
227         address indexed sender,
228         uint amount0In,
229         uint amount1In,
230         uint amount0Out,
231         uint amount1Out,
232         address indexed to
233     );
234     event Sync(uint112 reserve0, uint112 reserve1);
235 
236     constructor() public {
237         factory = msg.sender;
238     }
239 
240     // called once by the factory at time of deployment
241     function initialize(address _token0, address _token1) external {
242         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
243         token0 = _token0;
244         token1 = _token1;
245     }
246 
247     // update reserves and, on the first call per block, price accumulators
248     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
249         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
250         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
251         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
252         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
253             // * never overflows, and + overflow is desired
254             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
255             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
256         }
257         reserve0 = uint112(balance0);
258         reserve1 = uint112(balance1);
259         blockTimestampLast = blockTimestamp;
260         emit Sync(reserve0, reserve1);
261     }
262 
263     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
264     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
265         address feeTo = IUniswapV2Factory(factory).feeTo();
266         feeOn = feeTo != address(0);
267         uint _kLast = kLast; // gas savings
268         if (feeOn) {
269             if (_kLast != 0) {
270                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
271                 uint rootKLast = Math.sqrt(_kLast);
272                 if (rootK > rootKLast) {
273                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
274                     uint denominator = rootK.mul(5).add(rootKLast);
275                     uint liquidity = numerator / denominator;
276                     if (liquidity > 0) _mint(feeTo, liquidity);
277                 }
278             }
279         } else if (_kLast != 0) {
280             kLast = 0;
281         }
282     }
283 
284     // this low-level function should be called from a contract which performs important safety checks
285     function mint(address to) external lock returns (uint liquidity) {
286         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
287         uint balance0 = IERC20Uniswap(token0).balanceOf(address(this));
288         uint balance1 = IERC20Uniswap(token1).balanceOf(address(this));
289         uint amount0 = balance0.sub(_reserve0);
290         uint amount1 = balance1.sub(_reserve1);
291 
292         bool feeOn = _mintFee(_reserve0, _reserve1);
293         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
294         if (_totalSupply == 0) {
295             address migrator = IUniswapV2Factory(factory).migrator();
296             if (msg.sender == migrator) {
297                 liquidity = IMigrator(migrator).desiredLiquidity();
298                 require(liquidity > 0 && liquidity != uint256(-1), "Bad desired liquidity");
299             } else {
300                 require(migrator == address(0), "Must not have migrator");
301                 liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
302                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
303             }
304         } else {
305             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
306         }
307         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
308         _mint(to, liquidity);
309 
310         _update(balance0, balance1, _reserve0, _reserve1);
311         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
312         emit Mint(msg.sender, amount0, amount1);
313     }
314 
315     // this low-level function should be called from a contract which performs important safety checks
316     function burn(address to) external lock returns (uint amount0, uint amount1) {
317         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
318         address _token0 = token0;                                // gas savings
319         address _token1 = token1;                                // gas savings
320         uint balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
321         uint balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
322         uint liquidity = balanceOf[address(this)];
323 
324         bool feeOn = _mintFee(_reserve0, _reserve1);
325         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
326         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
327         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
328         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
329         _burn(address(this), liquidity);
330         _safeTransfer(_token0, to, amount0);
331         _safeTransfer(_token1, to, amount1);
332         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
333         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
334 
335         _update(balance0, balance1, _reserve0, _reserve1);
336         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
337         emit Burn(msg.sender, amount0, amount1, to);
338     }
339 
340     // this low-level function should be called from a contract which performs important safety checks
341     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
342         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
343         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
344         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
345 
346         uint balance0;
347         uint balance1;
348         { // scope for _token{0,1}, avoids stack too deep errors
349         address _token0 = token0;
350         address _token1 = token1;
351         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
352         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
353         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
354         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
355         balance0 = IERC20Uniswap(_token0).balanceOf(address(this));
356         balance1 = IERC20Uniswap(_token1).balanceOf(address(this));
357         }
358         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
359         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
360         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
361         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
362         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
363         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
364         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
365         }
366 
367         _update(balance0, balance1, _reserve0, _reserve1);
368         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
369     }
370 
371     // force balances to match reserves
372     function skim(address to) external lock {
373         address _token0 = token0; // gas savings
374         address _token1 = token1; // gas savings
375         _safeTransfer(_token0, to, IERC20Uniswap(_token0).balanceOf(address(this)).sub(reserve0));
376         _safeTransfer(_token1, to, IERC20Uniswap(_token1).balanceOf(address(this)).sub(reserve1));
377     }
378 
379     // force reserves to match balances
380     function sync() external lock {
381         _update(IERC20Uniswap(token0).balanceOf(address(this)), IERC20Uniswap(token1).balanceOf(address(this)), reserve0, reserve1);
382     }
383 }
384 
385 contract UniswapV2Factory is IUniswapV2Factory {
386     address public override feeTo;
387     address public override feeToSetter;
388     address public override migrator;
389 
390     mapping(address => mapping(address => address)) public override getPair;
391     address[] public override allPairs;
392 
393     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
394 
395     constructor(address _feeToSetter) public {
396         feeToSetter = _feeToSetter;
397     }
398 
399     function allPairsLength() external override view returns (uint) {
400         return allPairs.length;
401     }
402 
403     function pairCodeHash() external pure returns (bytes32) {
404         return keccak256(type(UniswapV2Pair).creationCode);
405     }
406 
407     function createPair(address tokenA, address tokenB) external override returns (address pair) {
408         require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
409         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
410         require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
411         require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
412         bytes memory bytecode = type(UniswapV2Pair).creationCode;
413         bytes32 salt = keccak256(abi.encodePacked(token0, token1));
414         assembly {
415             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
416         }
417         UniswapV2Pair(pair).initialize(token0, token1);
418         getPair[token0][token1] = pair;
419         getPair[token1][token0] = pair; // populate mapping in the reverse direction
420         allPairs.push(pair);
421         emit PairCreated(token0, token1, pair, allPairs.length);
422     }
423 
424     function setFeeTo(address _feeTo) external override {
425         require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
426         feeTo = _feeTo;
427     }
428 
429     function setMigrator(address _migrator) external override {
430         require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
431         migrator = _migrator;
432     }
433 
434     function setFeeToSetter(address _feeToSetter) external override {
435         require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
436         feeToSetter = _feeToSetter;
437     }
438 
439 }