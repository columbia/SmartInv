1 /**
2  *Submitted for verification at BscScan.com on 2021-10-28
3 */
4 
5 /**
6  *Submitted for verification at arbiscan.io on 2021-09-22
7 */
8 
9 // SPDX-License-Identifier: GPL-3.0-or-later
10 
11 pragma solidity >=0.8.2;
12 
13 interface ISushiswapV2Pair {
14     event Approval(address indexed owner, address indexed spender, uint value);
15     event Transfer(address indexed from, address indexed to, uint value);
16 
17     function name() external pure returns (string memory);
18     function symbol() external pure returns (string memory);
19     function decimals() external pure returns (uint8);
20     function totalSupply() external view returns (uint);
21     function balanceOf(address owner) external view returns (uint);
22     function allowance(address owner, address spender) external view returns (uint);
23 
24     function approve(address spender, uint value) external returns (bool);
25     function transfer(address to, uint value) external returns (bool);
26     function transferFrom(address from, address to, uint value) external returns (bool);
27 
28     function DOMAIN_SEPARATOR() external view returns (bytes32);
29     function PERMIT_TYPEHASH() external pure returns (bytes32);
30     function nonces(address owner) external view returns (uint);
31 
32     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
33 
34     event Mint(address indexed sender, uint amount0, uint amount1);
35     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
36     event Swap(
37         address indexed sender,
38         uint amount0In,
39         uint amount1In,
40         uint amount0Out,
41         uint amount1Out,
42         address indexed to
43     );
44     event Sync(uint112 reserve0, uint112 reserve1);
45 
46     function MINIMUM_LIQUIDITY() external pure returns (uint);
47     function factory() external view returns (address);
48     function token0() external view returns (address);
49     function token1() external view returns (address);
50     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
51     function price0CumulativeLast() external view returns (uint);
52     function price1CumulativeLast() external view returns (uint);
53     function kLast() external view returns (uint);
54 
55     function mint(address to) external returns (uint liquidity);
56     function burn(address to) external returns (uint amount0, uint amount1);
57     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
58     function skim(address to) external;
59     function sync() external;
60 
61     function initialize(address, address) external;
62 }
63 
64 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
65 
66 library SafeMathSushiswap {
67     function add(uint x, uint y) internal pure returns (uint z) {
68         require((z = x + y) >= x, 'ds-math-add-overflow');
69     }
70 
71     function sub(uint x, uint y) internal pure returns (uint z) {
72         require((z = x - y) <= x, 'ds-math-sub-underflow');
73     }
74 
75     function mul(uint x, uint y) internal pure returns (uint z) {
76         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
77     }
78 }
79 
80 library SushiswapV2Library {
81     using SafeMathSushiswap for uint;
82 
83     // returns sorted token addresses, used to handle return values from pairs sorted in this order
84     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
85         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
86         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
87         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
88     }
89 
90     // calculates the CREATE2 address for a pair without making any external calls
91     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
92         (address token0, address token1) = sortTokens(tokenA, tokenB);
93         pair = address(uint160(uint256(keccak256(abi.encodePacked(
94                 hex'ff',
95                 factory,
96                 keccak256(abi.encodePacked(token0, token1)),
97                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
98             )))));
99     }
100 
101     // fetches and sorts the reserves for a pair
102     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
103         (address token0,) = sortTokens(tokenA, tokenB);
104         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
105         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
106     }
107 
108     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
109     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
110         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
111         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
112         amountB = amountA.mul(reserveB) / reserveA;
113     }
114 
115     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
116     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
117         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
118         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
119         uint amountInWithFee = amountIn.mul(997);
120         uint numerator = amountInWithFee.mul(reserveOut);
121         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
122         amountOut = numerator / denominator;
123     }
124 
125     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
126     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
127         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
128         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
129         uint numerator = reserveIn.mul(amountOut).mul(1000);
130         uint denominator = reserveOut.sub(amountOut).mul(997);
131         amountIn = (numerator / denominator).add(1);
132     }
133 
134     // performs chained getAmountOut calculations on any number of pairs
135     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
136         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
137         amounts = new uint[](path.length);
138         amounts[0] = amountIn;
139         for (uint i; i < path.length - 1; i++) {
140             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
141             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
142         }
143     }
144 
145     // performs chained getAmountIn calculations on any number of pairs
146     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
147         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
148         amounts = new uint[](path.length);
149         amounts[amounts.length - 1] = amountOut;
150         for (uint i = path.length - 1; i > 0; i--) {
151             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
152             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
153         }
154     }
155 }
156 
157 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
158 library TransferHelper {
159     function safeApprove(address token, address to, uint value) internal {
160         // bytes4(keccak256(bytes('approve(address,uint256)')));
161         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
162         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
163     }
164 
165     function safeTransfer(address token, address to, uint value) internal {
166         // bytes4(keccak256(bytes('transfer(address,uint256)')));
167         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
168         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
169     }
170 
171     function safeTransferFrom(address token, address from, address to, uint value) internal {
172         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
173         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
174         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
175     }
176 
177     function safeTransferNative(address to, uint value) internal {
178         (bool success,) = to.call{value:value}(new bytes(0));
179         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
180     }
181 }
182 
183 interface ISushiswapV2Factory {
184     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
185 
186     function feeTo() external view returns (address);
187     function feeToSetter() external view returns (address);
188     function migrator() external view returns (address);
189 
190     function getPair(address tokenA, address tokenB) external view returns (address pair);
191     function allPairs(uint) external view returns (address pair);
192     function allPairsLength() external view returns (uint);
193 
194     function createPair(address tokenA, address tokenB) external returns (address pair);
195 
196     function setFeeTo(address) external;
197     function setFeeToSetter(address) external;
198     function setMigrator(address) external;
199 }
200 
201 interface IwNATIVE {
202     function deposit() external payable;
203     function transfer(address to, uint value) external returns (bool);
204     function withdraw(uint) external;
205 }
206 
207 interface AnyswapV1ERC20 {
208     function mint(address to, uint256 amount) external returns (bool);
209     function burn(address from, uint256 amount) external returns (bool);
210     function changeVault(address newVault) external returns (bool);
211     function depositVault(uint amount, address to) external returns (uint);
212     function withdrawVault(address from, uint amount, address to) external returns (uint);
213     function underlying() external view returns (address);
214     function deposit(uint amount, address to) external returns (uint);
215     function withdraw(uint amount, address to) external returns (uint);
216 }
217 
218 /**
219  * @dev Interface of the ERC20 standard as defined in the EIP.
220  */
221 interface IERC20 {
222     function totalSupply() external view returns (uint256);
223     function balanceOf(address account) external view returns (uint256);
224     function transfer(address recipient, uint256 amount) external returns (bool);
225     function allowance(address owner, address spender) external view returns (uint256);
226     function approve(address spender, uint256 amount) external returns (bool);
227     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
228     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
229     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
230 
231     event Transfer(address indexed from, address indexed to, uint256 value);
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 library Address {
236     function isContract(address account) internal view returns (bool) {
237         bytes32 codehash;
238         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
239         // solhint-disable-next-line no-inline-assembly
240         assembly { codehash := extcodehash(account) }
241         return (codehash != 0x0 && codehash != accountHash);
242     }
243 }
244 
245 library SafeERC20 {
246     using Address for address;
247 
248     function safeTransfer(IERC20 token, address to, uint value) internal {
249         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
250     }
251 
252     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
253         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
254     }
255 
256     function safeApprove(IERC20 token, address spender, uint value) internal {
257         require((value == 0) || (token.allowance(address(this), spender) == 0),
258             "SafeERC20: approve from non-zero to non-zero allowance"
259         );
260         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
261     }
262     function callOptionalReturn(IERC20 token, bytes memory data) private {
263         require(address(token).isContract(), "SafeERC20: call to non-contract");
264 
265         // solhint-disable-next-line avoid-low-level-calls
266         (bool success, bytes memory returndata) = address(token).call(data);
267         require(success, "SafeERC20: low-level call failed");
268 
269         if (returndata.length > 0) { // Return data is optional
270             // solhint-disable-next-line max-line-length
271             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
272         }
273     }
274 }
275 
276 contract AnyswapV3Router {
277     using SafeERC20 for IERC20;
278     using SafeMathSushiswap for uint;
279 
280     address public immutable factory;
281     address public immutable wNATIVE;
282 
283     modifier ensure(uint deadline) {
284         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
285         _;
286     }
287 
288     constructor(address _factory, address _wNATIVE, address _mpc) {
289         _newMPC = _mpc;
290         _newMPCEffectiveTime = block.timestamp;
291         factory = _factory;
292         wNATIVE = _wNATIVE;
293     }
294 
295     receive() external payable {
296         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
297     }
298 
299     address private _oldMPC;
300     address private _newMPC;
301     uint256 private _newMPCEffectiveTime;
302 
303 
304     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
305     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
306     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
307     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
308     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
309     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
310 
311     modifier onlyMPC() {
312         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
313         _;
314     }
315 
316     function mpc() public view returns (address) {
317         if (block.timestamp >= _newMPCEffectiveTime) {
318             return _newMPC;
319         }
320         return _oldMPC;
321     }
322 
323     function cID() public view returns (uint id) {
324         assembly {id := chainid()}
325     }
326 
327     function changeMPC(address newMPC) public onlyMPC returns (bool) {
328         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
329         _oldMPC = mpc();
330         _newMPC = newMPC;
331         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
332         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
333         return true;
334     }
335 
336     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
337         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
338         return AnyswapV1ERC20(token).changeVault(newVault);
339     }
340 
341     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
342         AnyswapV1ERC20(token).burn(from, amount);
343         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
344     }
345 
346     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
347     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
348         _anySwapOut(msg.sender, token, to, amount, toChainID);
349     }
350 
351     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
352     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
353         IERC20(AnyswapV1ERC20(token).underlying()).safeTransferFrom(msg.sender, token, amount);
354         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
355         _anySwapOut(msg.sender, token, to, amount, toChainID);
356     }
357 
358     function anySwapOutNative(address token, address to, uint toChainID) external payable {
359         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
360         IwNATIVE(wNATIVE).deposit{value: msg.value}();
361         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
362         AnyswapV1ERC20(token).depositVault(msg.value, msg.sender);
363         _anySwapOut(msg.sender, token, to, msg.value, toChainID);
364     }
365 
366     function anySwapOutUnderlyingWithPermit(
367         address from,
368         address token,
369         address to,
370         uint amount,
371         uint deadline,
372         uint8 v,
373         bytes32 r,
374         bytes32 s,
375         uint toChainID
376     ) external {
377         address _underlying = AnyswapV1ERC20(token).underlying();
378         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
379         IERC20(_underlying).safeTransferFrom(from, token, amount);
380         AnyswapV1ERC20(token).depositVault(amount, from);
381         _anySwapOut(from, token, to, amount, toChainID);
382     }
383 
384     function anySwapOutUnderlyingWithTransferPermit(
385         address from,
386         address token,
387         address to,
388         uint amount,
389         uint deadline,
390         uint8 v,
391         bytes32 r,
392         bytes32 s,
393         uint toChainID
394     ) external {
395         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
396         AnyswapV1ERC20(token).depositVault(amount, from);
397         _anySwapOut(from, token, to, amount, toChainID);
398     }
399 
400     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
401         for (uint i = 0; i < tokens.length; i++) {
402             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
403         }
404     }
405 
406     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
407     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
408         AnyswapV1ERC20(token).mint(to, amount);
409         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
410     }
411 
412     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
413     // triggered by `anySwapOut`
414     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
415         _anySwapIn(txs, token, to, amount, fromChainID);
416     }
417 
418     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
419     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
420         _anySwapIn(txs, token, to, amount, fromChainID);
421         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
422     }
423 
424     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
425     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
426         _anySwapIn(txs, token, to, amount, fromChainID);
427         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
428         address _underlying = _anyToken.underlying();
429         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
430             if (_underlying == wNATIVE) {
431                 _anyToken.withdrawVault(to, amount, address(this));
432                 IwNATIVE(wNATIVE).withdraw(amount);
433                 TransferHelper.safeTransferNative(to, amount);
434             } else {
435                 _anyToken.withdrawVault(to, amount, to);
436             }
437         }
438     }
439 
440     function depositNative(address token, address to) external payable returns (uint) {
441         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
442         IwNATIVE(wNATIVE).deposit{value: msg.value}();
443         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
444         AnyswapV1ERC20(token).depositVault(msg.value, to);
445         return msg.value;
446     }
447 
448     function withdrawNative(address token, uint amount, address to) external returns (uint) {
449         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
450         AnyswapV1ERC20(token).withdrawVault(msg.sender, amount, address(this));
451         IwNATIVE(wNATIVE).withdraw(amount);
452         TransferHelper.safeTransferNative(to, amount);
453         return amount;
454     }
455 
456     // extracts mpc fee from bridge fees
457     function anySwapFeeTo(address token, uint amount) external onlyMPC {
458         address _mpc = mpc();
459         AnyswapV1ERC20(token).mint(_mpc, amount);
460         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
461     }
462 
463     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
464         for (uint i = 0; i < tokens.length; i++) {
465             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
466         }
467     }
468 
469     // **** SWAP ****
470     // requires the initial amount to have already been sent to the first pair
471     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
472         for (uint i; i < path.length - 1; i++) {
473             (address input, address output) = (path[i], path[i + 1]);
474             (address token0,) = SushiswapV2Library.sortTokens(input, output);
475             uint amountOut = amounts[i + 1];
476             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
477             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
478             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
479                 amount0Out, amount1Out, to, new bytes(0)
480             );
481         }
482     }
483 
484     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
485     function anySwapOutExactTokensForTokens(
486         uint amountIn,
487         uint amountOutMin,
488         address[] calldata path,
489         address to,
490         uint deadline,
491         uint toChainID
492     ) external virtual ensure(deadline) {
493         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
494         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
495     }
496 
497     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
498     function anySwapOutExactTokensForTokensUnderlying(
499         uint amountIn,
500         uint amountOutMin,
501         address[] calldata path,
502         address to,
503         uint deadline,
504         uint toChainID
505     ) external virtual ensure(deadline) {
506         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
507         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
508         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
509         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
510     }
511 
512     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
513     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
514         address from,
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline,
520         uint8 v,
521         bytes32 r,
522         bytes32 s,
523         uint toChainID
524     ) external virtual ensure(deadline) {
525         address _underlying = AnyswapV1ERC20(path[0]).underlying();
526         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
527         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
528         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
529         AnyswapV1ERC20(path[0]).burn(from, amountIn);
530         {
531         address[] memory _path = path;
532         address _from = from;
533         address _to = to;
534         uint _amountIn = amountIn;
535         uint _amountOutMin = amountOutMin;
536         uint _cID = cID();
537         uint _toChainID = toChainID;
538         emit LogAnySwapTradeTokensForTokens(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
539         }
540     }
541 
542     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
543     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
544         address from,
545         uint amountIn,
546         uint amountOutMin,
547         address[] calldata path,
548         address to,
549         uint deadline,
550         uint8 v,
551         bytes32 r,
552         bytes32 s,
553         uint toChainID
554     ) external virtual ensure(deadline) {
555         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
556         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
557         AnyswapV1ERC20(path[0]).burn(from, amountIn);
558         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
559     }
560 
561     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
562     // Triggered by `anySwapOutExactTokensForTokens`
563     function anySwapInExactTokensForTokens(
564         bytes32 txs,
565         uint amountIn,
566         uint amountOutMin,
567         address[] calldata path,
568         address to,
569         uint deadline,
570         uint fromChainID
571     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
572         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
573         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
574         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
575         _swap(amounts, path, to);
576     }
577 
578     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
579     function anySwapOutExactTokensForNative(
580         uint amountIn,
581         uint amountOutMin,
582         address[] calldata path,
583         address to,
584         uint deadline,
585         uint toChainID
586     ) external virtual ensure(deadline) {
587         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
588         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
589     }
590 
591     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
592     function anySwapOutExactTokensForNativeUnderlying(
593         uint amountIn,
594         uint amountOutMin,
595         address[] calldata path,
596         address to,
597         uint deadline,
598         uint toChainID
599     ) external virtual ensure(deadline) {
600         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
601         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
602         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
603         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
604     }
605 
606     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
607     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
608         address from,
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline,
614         uint8 v,
615         bytes32 r,
616         bytes32 s,
617         uint toChainID
618     ) external virtual ensure(deadline) {
619         address _underlying = AnyswapV1ERC20(path[0]).underlying();
620         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
621         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
622         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
623         AnyswapV1ERC20(path[0]).burn(from, amountIn);
624         {
625         address[] memory _path = path;
626         address _from = from;
627         address _to = to;
628         uint _amountIn = amountIn;
629         uint _amountOutMin = amountOutMin;
630         uint _cID = cID();
631         uint _toChainID = toChainID;
632         emit LogAnySwapTradeTokensForNative(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
633         }
634     }
635 
636     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
637     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
638         address from,
639         uint amountIn,
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline,
644         uint8 v,
645         bytes32 r,
646         bytes32 s,
647         uint toChainID
648     ) external virtual ensure(deadline) {
649         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
650         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
651         AnyswapV1ERC20(path[0]).burn(from, amountIn);
652         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
653     }
654 
655     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
656     // Triggered by `anySwapOutExactTokensForNative`
657     function anySwapInExactTokensForNative(
658         bytes32 txs,
659         uint amountIn,
660         uint amountOutMin,
661         address[] calldata path,
662         address to,
663         uint deadline,
664         uint fromChainID
665     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
666         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
667         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
668         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
669         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
670         _swap(amounts, path, address(this));
671         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
672         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
673     }
674 
675     // **** LIBRARY FUNCTIONS ****
676     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
677         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
678     }
679 
680     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
681         public
682         pure
683         virtual
684         returns (uint amountOut)
685     {
686         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
687     }
688 
689     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
690         public
691         pure
692         virtual
693         returns (uint amountIn)
694     {
695         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
696     }
697 
698     function getAmountsOut(uint amountIn, address[] memory path)
699         public
700         view
701         virtual
702         returns (uint[] memory amounts)
703     {
704         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
705     }
706 
707     function getAmountsIn(uint amountOut, address[] memory path)
708         public
709         view
710         virtual
711         returns (uint[] memory amounts)
712     {
713         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
714     }
715 }