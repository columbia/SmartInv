1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity =0.8.1;
4 
5 interface IERC20 {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external view returns (string memory);
10     function symbol() external view returns (string memory);
11     function decimals() external view returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 }
20 
21 library Address {
22     function isContract(address account) internal view returns (bool) {
23         bytes32 codehash;
24         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { codehash := extcodehash(account) }
27         return (codehash != 0x0 && codehash != accountHash);
28     }
29 }
30 
31 library SafeERC20 {
32     using Address for address;
33 
34     function safeTransfer(IERC20 token, address to, uint value) internal {
35         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
36     }
37 
38     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
39         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
40     }
41 
42     function safeApprove(IERC20 token, address spender, uint value) internal {
43         require((value == 0) || (token.allowance(address(this), spender) == 0),
44             "SafeERC20: approve from non-zero to non-zero allowance"
45         );
46         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
47     }
48     function callOptionalReturn(IERC20 token, bytes memory data) private {
49         require(address(token).isContract(), "SafeERC20: call to non-contract");
50 
51         // solhint-disable-next-line avoid-low-level-calls
52         (bool success, bytes memory returndata) = address(token).call(data);
53         require(success, "SafeERC20: low-level call failed");
54 
55         if (returndata.length > 0) { // Return data is optional
56             // solhint-disable-next-line max-line-length
57             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
58         }
59     }
60 }
61 interface IAnyswapV1Factory {
62     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
63 
64     function feeTo() external view returns (address);
65     function feeToSetter() external view returns (address);
66     function migrator() external view returns (address);
67 
68     function getPair(address tokenA, address tokenB) external view returns (address pair);
69     function allPairs(uint) external view returns (address pair);
70     function allPairsLength() external view returns (uint);
71 
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 
74     function setFeeTo(address) external;
75     function setFeeToSetter(address) external;
76     function setMigrator(address) external;
77 }
78 
79 library SafeMathAnyswap {
80     function add(uint x, uint y) internal pure returns (uint z) {
81         require((z = x + y) >= x, 'ds-math-add-overflow');
82     }
83 
84     function sub(uint x, uint y) internal pure returns (uint z) {
85         require((z = x - y) <= x, 'ds-math-sub-underflow');
86     }
87 
88     function mul(uint x, uint y) internal pure returns (uint z) {
89         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
90     }
91 }
92 
93 contract AnyswapV1ERC20 {
94     using SafeMathAnyswap for uint;
95 
96     string public constant name = 'Anyswap LP Token';
97     string public constant symbol = 'SLP';
98     uint8 public constant decimals = 18;
99     uint  public totalSupply;
100     mapping(address => uint) public balanceOf;
101     mapping(address => mapping(address => uint)) public allowance;
102 
103     bytes32 public DOMAIN_SEPARATOR;
104     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
105     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
106     mapping(address => uint) public nonces;
107 
108     event Approval(address indexed owner, address indexed spender, uint value);
109     event Transfer(address indexed from, address indexed to, uint value);
110 
111     constructor() {
112         uint chainId;
113         assembly {
114             chainId := chainid()
115         }
116         DOMAIN_SEPARATOR = keccak256(
117             abi.encode(
118                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
119                 keccak256(bytes(name)),
120                 keccak256(bytes('1')),
121                 chainId,
122                 address(this)
123             )
124         );
125     }
126 
127     function _mint(address to, uint value) internal {
128         totalSupply = totalSupply.add(value);
129         balanceOf[to] = balanceOf[to].add(value);
130         emit Transfer(address(0), to, value);
131     }
132 
133     function _burn(address from, uint value) internal {
134         balanceOf[from] = balanceOf[from].sub(value);
135         totalSupply = totalSupply.sub(value);
136         emit Transfer(from, address(0), value);
137     }
138 
139     function _approve(address owner, address spender, uint value) private {
140         allowance[owner][spender] = value;
141         emit Approval(owner, spender, value);
142     }
143 
144     function _transfer(address from, address to, uint value) private {
145         balanceOf[from] = balanceOf[from].sub(value);
146         balanceOf[to] = balanceOf[to].add(value);
147         emit Transfer(from, to, value);
148     }
149 
150     function approve(address spender, uint value) external returns (bool) {
151         _approve(msg.sender, spender, value);
152         return true;
153     }
154 
155     function transfer(address to, uint value) external returns (bool) {
156         _transfer(msg.sender, to, value);
157         return true;
158     }
159 
160     function transferFrom(address from, address to, uint value) external returns (bool) {
161         if (allowance[from][msg.sender] != type(uint).max) {
162             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
163         }
164         _transfer(from, to, value);
165         return true;
166     }
167 
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
169         require(deadline >= block.timestamp, 'AnyswapV1: EXPIRED');
170         bytes32 digest = keccak256(
171             abi.encodePacked(
172                 '\x19\x01',
173                 DOMAIN_SEPARATOR,
174                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
175             )
176         );
177         address recoveredAddress = ecrecover(digest, v, r, s);
178         require(recoveredAddress != address(0) && recoveredAddress == owner, 'AnyswapV1: INVALID_SIGNATURE');
179         _approve(owner, spender, value);
180     }
181 }
182 
183 // a library for performing various math operations
184 
185 library Math {
186     function min(uint x, uint y) internal pure returns (uint z) {
187         z = x < y ? x : y;
188     }
189 
190     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
191     function sqrt(uint y) internal pure returns (uint z) {
192         if (y > 3) {
193             z = y;
194             uint x = y / 2 + 1;
195             while (x < z) {
196                 z = x;
197                 x = (y / x + x) / 2;
198             }
199         } else if (y != 0) {
200             z = 1;
201         }
202     }
203 }
204 
205 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
206 
207 // range: [0, 2**112 - 1]
208 // resolution: 1 / 2**112
209 
210 library UQ112x112 {
211     uint224 constant Q112 = 2**112;
212 
213     // encode a uint112 as a UQ112x112
214     function encode(uint112 y) internal pure returns (uint224 z) {
215         z = uint224(y) * Q112; // never overflows
216     }
217 
218     // divide a UQ112x112 by a uint112, returning a UQ112x112
219     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
220         z = x / uint224(y);
221     }
222 }
223 
224 interface IERC20Anyswap {
225     event Approval(address indexed owner, address indexed spender, uint value);
226     event Transfer(address indexed from, address indexed to, uint value);
227 
228     function name() external view returns (string memory);
229     function symbol() external view returns (string memory);
230     function decimals() external view returns (uint8);
231     function totalSupply() external view returns (uint);
232     function balanceOf(address owner) external view returns (uint);
233     function allowance(address owner, address spender) external view returns (uint);
234 
235     function approve(address spender, uint value) external returns (bool);
236     function transfer(address to, uint value) external returns (bool);
237     function transferFrom(address from, address to, uint value) external returns (bool);
238 }
239 
240 interface IAnyswapV1Callee {
241     function AnyswapV1Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
242 }
243 
244 contract AnyswapV1Pair is AnyswapV1ERC20 {
245     using SafeMathAnyswap  for uint;
246     using SafeERC20 for IERC20;
247     using UQ112x112 for uint224;
248 
249     uint public constant MINIMUM_LIQUIDITY = 10**3;
250     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
251 
252     address public factory;
253     address public token0;
254     address public token1;
255 
256     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
257     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
258     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
259 
260     uint public price0CumulativeLast;
261     uint public price1CumulativeLast;
262     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
263 
264     uint private unlocked = 1;
265     modifier lock() {
266         require(unlocked == 1, 'AnyswapV1: LOCKED');
267         unlocked = 0;
268         _;
269         unlocked = 1;
270     }
271 
272     function getAmountOut(address tokenIn, uint amountIn) external view returns (uint amountOut) {
273          (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
274          if (tokenIn == token0) {
275              return _getAmountOut(amountIn, _reserve0, _reserve1);
276          } else {
277              return _getAmountOut(amountIn, _reserve1, _reserve0);
278          }
279     }
280 
281     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
282     function _getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
283         require(amountIn > 0, 'AnyswapV1: INSUFFICIENT_INPUT_AMOUNT');
284         require(reserveIn > 0 && reserveOut > 0, 'AnyswapV1: INSUFFICIENT_LIQUIDITY');
285         uint amountInWithFee = amountIn.mul(997);
286         uint numerator = amountInWithFee.mul(reserveOut);
287         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
288         amountOut = numerator / denominator;
289     }
290 
291     function getAmountIn(address tokenOut, uint amountOut) external view returns (uint amountIn) {
292          (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
293          if (tokenOut == token0) {
294              return _getAmountIn(amountOut, _reserve1, _reserve0);
295          } else {
296              return _getAmountIn(amountOut, _reserve0, _reserve1);
297          }
298     }
299 
300     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
301     function _getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
302         require(amountOut > 0, 'AnyswapV1: INSUFFICIENT_OUTPUT_AMOUNT');
303         require(reserveIn > 0 && reserveOut > 0, 'AnyswapV1: INSUFFICIENT_LIQUIDITY');
304         uint numerator = reserveIn.mul(amountOut).mul(1000);
305         uint denominator = reserveOut.sub(amountOut).mul(997);
306         amountIn = (numerator / denominator).add(1);
307     }
308 
309     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
310         _reserve0 = reserve0;
311         _reserve1 = reserve1;
312         _blockTimestampLast = blockTimestampLast;
313     }
314 
315     function _safeTransfer(address token, address to, uint value) private {
316         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
317         require(success && (data.length == 0 || abi.decode(data, (bool))), 'AnyswapV1: TRANSFER_FAILED');
318     }
319 
320     event Mint(address indexed sender, uint amount0, uint amount1);
321     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
322     event Swap(
323         address indexed sender,
324         uint amount0In,
325         uint amount1In,
326         uint amount0Out,
327         uint amount1Out,
328         address indexed to
329     );
330     event Sync(uint112 reserve0, uint112 reserve1);
331 
332     constructor() {
333         factory = msg.sender;
334     }
335 
336     // called once by the factory at time of deployment
337     function initialize(address _token0, address _token1) external {
338         require(msg.sender == factory, 'AnyswapV1: FORBIDDEN'); // sufficient check
339         token0 = _token0;
340         token1 = _token1;
341     }
342 
343     // update reserves and, on the first call per block, price accumulators
344     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
345         require(balance0 <= type(uint112).max && balance1 <= type(uint112).max, 'AnyswapV1: OVERFLOW');
346         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
347         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
348         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
349             // * never overflows, and + overflow is desired
350             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
351             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
352         }
353         reserve0 = uint112(balance0);
354         reserve1 = uint112(balance1);
355         blockTimestampLast = blockTimestamp;
356         emit Sync(reserve0, reserve1);
357     }
358 
359     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
360     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
361         address feeTo = IAnyswapV1Factory(factory).feeTo();
362         feeOn = feeTo != address(0);
363         uint _kLast = kLast; // gas savings
364         if (feeOn) {
365             if (_kLast != 0) {
366                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
367                 uint rootKLast = Math.sqrt(_kLast);
368                 if (rootK > rootKLast) {
369                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
370                     uint denominator = rootK.mul(5).add(rootKLast);
371                     uint liquidity = numerator / denominator;
372                     if (liquidity > 0) _mint(feeTo, liquidity);
373                 }
374             }
375         } else if (_kLast != 0) {
376             kLast = 0;
377         }
378     }
379 
380     // this low-level function should be called from a contract which performs important safety checks
381     function mint(address to) external lock returns (uint liquidity) {
382         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
383         uint balance0 = IERC20Anyswap(token0).balanceOf(address(this));
384         uint balance1 = IERC20Anyswap(token1).balanceOf(address(this));
385         uint amount0 = balance0.sub(_reserve0);
386         uint amount1 = balance1.sub(_reserve1);
387 
388         bool feeOn = _mintFee(_reserve0, _reserve1);
389         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
390         if (_totalSupply == 0) {
391             liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
392             _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
393         } else {
394             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
395         }
396         require(liquidity > 0, 'AnyswapV1: INSUFFICIENT_LIQUIDITY_MINTED');
397         _mint(to, liquidity);
398 
399         _update(balance0, balance1, _reserve0, _reserve1);
400         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
401         emit Mint(msg.sender, amount0, amount1);
402     }
403 
404     // this low-level function should be called from a contract which performs important safety checks
405     function burn(address to) external lock returns (uint amount0, uint amount1) {
406         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
407         address _token0 = token0;                                // gas savings
408         address _token1 = token1;                                // gas savings
409         uint balance0 = IERC20Anyswap(_token0).balanceOf(address(this));
410         uint balance1 = IERC20Anyswap(_token1).balanceOf(address(this));
411         uint liquidity = balanceOf[address(this)];
412 
413         bool feeOn = _mintFee(_reserve0, _reserve1);
414         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
415         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
416         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
417         require(amount0 > 0 && amount1 > 0, 'AnyswapV1: INSUFFICIENT_LIQUIDITY_BURNED');
418         _burn(address(this), liquidity);
419         _safeTransfer(_token0, to, amount0);
420         _safeTransfer(_token1, to, amount1);
421         balance0 = IERC20Anyswap(_token0).balanceOf(address(this));
422         balance1 = IERC20Anyswap(_token1).balanceOf(address(this));
423 
424         _update(balance0, balance1, _reserve0, _reserve1);
425         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
426         emit Burn(msg.sender, amount0, amount1, to);
427     }
428 
429     // this low-level function should be called from a contract which performs important safety checks
430     function swap(address tokenIn, uint amountIn, uint minOut, address to) external lock {
431         require(amountIn > 0, 'AnyswapV1: INSUFFICIENT_OUTPUT_AMOUNT');
432         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savingsuint numerator = reserveIn.mul(amountOut).mul(1000);
433 
434         uint _balance0;
435         uint _balance1;
436         uint _amount0Out;
437         uint _amount1Out;
438 
439         { // scope for _token{0,1}, avoids stack too deep errors
440         IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
441         address _token0 = token0;
442         address _token1 = token1;
443         uint _amountOut;
444         address _tokenOut = tokenIn == _token0 ? _token1 : _token0;
445         if (tokenIn == _token0) {
446             _amountOut = _getAmountOut(amountIn, _reserve0, _reserve1);
447             require(_amountOut < _reserve1, 'AnyswapV1: INSUFFICIENT_LIQUIDITY');
448         } else {
449             _amountOut = _getAmountOut(amountIn, _reserve1, _reserve0);
450             require(_amountOut < _reserve0, 'AnyswapV1: INSUFFICIENT_LIQUIDITY');
451         }
452         require(_amountOut >= minOut, 'AnyswapV1: INSUFFICIENT_OUTPUT_AMOUNT');
453         require(to != _token0 && to != _token1, 'AnyswapV1: INVALID_TO');
454         _safeTransfer(_tokenOut, to, _amountOut); // optimistically transfer tokens
455         _balance0 = IERC20Anyswap(_token0).balanceOf(address(this));
456         _balance1 = IERC20Anyswap(_token1).balanceOf(address(this));
457         (_amount0Out, _amount1Out) = tokenIn == _token0 ? (uint(0), _amountOut) : (_amountOut, uint(0));
458         }
459 
460         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
461         uint _amount0In = _balance0 > _reserve0 - _amount0Out ? _balance0 - (_reserve0 - _amount0Out) : 0;
462         uint _amount1In = _balance1 > _reserve1 - _amount1Out ? _balance1 - (_reserve1 - _amount1Out) : 0;
463         require(_amount0In > 0 || _amount1In > 0, 'AnyswapV1: INSUFFICIENT_INPUT_AMOUNT');
464         uint _balance0Adjusted = _balance0.mul(1000).sub(_amount0In.mul(3));
465         uint _balance1Adjusted = _balance1.mul(1000).sub(_amount1In.mul(3));
466         require(_balance0Adjusted.mul(_balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'AnyswapV1: K');
467         emit Swap(msg.sender, _amount0In, _amount1In, _amount0Out, _amount1Out, to);
468         }
469 
470         _update(_balance0, _balance1, _reserve0, _reserve1);
471     }
472 
473     // this low-level function should be called from a contract which performs important safety checks
474     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
475         require(amount0Out > 0 || amount1Out > 0, 'AnyswapV1: INSUFFICIENT_OUTPUT_AMOUNT');
476         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
477         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'AnyswapV1: INSUFFICIENT_LIQUIDITY');
478 
479         uint balance0;
480         uint balance1;
481         { // scope for _token{0,1}, avoids stack too deep errors
482         address _token0 = token0;
483         address _token1 = token1;
484         require(to != _token0 && to != _token1, 'AnyswapV1: INVALID_TO');
485         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
486         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
487         if (data.length > 0) IAnyswapV1Callee(to).AnyswapV1Call(msg.sender, amount0Out, amount1Out, data);
488         balance0 = IERC20Anyswap(_token0).balanceOf(address(this));
489         balance1 = IERC20Anyswap(_token1).balanceOf(address(this));
490         }
491         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
492         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
493         require(amount0In > 0 || amount1In > 0, 'AnyswapV1: INSUFFICIENT_INPUT_AMOUNT');
494         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
495         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
496         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
497         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'AnyswapV1: K');
498         }
499 
500         _update(balance0, balance1, _reserve0, _reserve1);
501         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
502     }
503 
504     // force balances to match reserves
505     function skim(address to) external lock {
506         address _token0 = token0; // gas savings
507         address _token1 = token1; // gas savings
508         _safeTransfer(_token0, to, IERC20Anyswap(_token0).balanceOf(address(this)).sub(reserve0));
509         _safeTransfer(_token1, to, IERC20Anyswap(_token1).balanceOf(address(this)).sub(reserve1));
510     }
511 
512     // force reserves to match balances
513     function sync() external lock {
514         _update(IERC20Anyswap(token0).balanceOf(address(this)), IERC20Anyswap(token1).balanceOf(address(this)), reserve0, reserve1);
515     }
516 }
