1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.1;
4 
5 interface ISushiswapV2Pair {
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
56 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
57 
58 library SafeMathSushiswap {
59     function add(uint x, uint y) internal pure returns (uint z) {
60         require((z = x + y) >= x, 'ds-math-add-overflow');
61     }
62 
63     function sub(uint x, uint y) internal pure returns (uint z) {
64         require((z = x - y) <= x, 'ds-math-sub-underflow');
65     }
66 
67     function mul(uint x, uint y) internal pure returns (uint z) {
68         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
69     }
70 }
71 
72 library SushiswapV2Library {
73     using SafeMathSushiswap for uint;
74 
75     // returns sorted token addresses, used to handle return values from pairs sorted in this order
76     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
77         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
78         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
79         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
80     }
81 
82     // calculates the CREATE2 address for a pair without making any external calls
83     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
84         (address token0, address token1) = sortTokens(tokenA, tokenB);
85         pair = address(uint160(uint256(keccak256(abi.encodePacked(
86                 hex'ff',
87                 factory,
88                 keccak256(abi.encodePacked(token0, token1)),
89                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
90             )))));
91     }
92 
93     // fetches and sorts the reserves for a pair
94     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
95         (address token0,) = sortTokens(tokenA, tokenB);
96         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
97         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
98     }
99 
100     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
101     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
102         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
103         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
104         amountB = amountA.mul(reserveB) / reserveA;
105     }
106 
107     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
108     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
109         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
110         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
111         uint amountInWithFee = amountIn.mul(997);
112         uint numerator = amountInWithFee.mul(reserveOut);
113         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
114         amountOut = numerator / denominator;
115     }
116 
117     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
118     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
119         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
120         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
121         uint numerator = reserveIn.mul(amountOut).mul(1000);
122         uint denominator = reserveOut.sub(amountOut).mul(997);
123         amountIn = (numerator / denominator).add(1);
124     }
125 
126     // performs chained getAmountOut calculations on any number of pairs
127     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
128         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
129         amounts = new uint[](path.length);
130         amounts[0] = amountIn;
131         for (uint i; i < path.length - 1; i++) {
132             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
133             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
134         }
135     }
136 
137     // performs chained getAmountIn calculations on any number of pairs
138     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
139         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
140         amounts = new uint[](path.length);
141         amounts[amounts.length - 1] = amountOut;
142         for (uint i = path.length - 1; i > 0; i--) {
143             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
144             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
145         }
146     }
147 }
148 
149 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
150 library TransferHelper {
151     function safeApprove(address token, address to, uint value) internal {
152         // bytes4(keccak256(bytes('approve(address,uint256)')));
153         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
154         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
155     }
156 
157     function safeTransfer(address token, address to, uint value) internal {
158         // bytes4(keccak256(bytes('transfer(address,uint256)')));
159         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
160         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
161     }
162 
163     function safeTransferFrom(address token, address from, address to, uint value) internal {
164         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
165         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
166         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
167     }
168 
169     function safeTransferNative(address to, uint value) internal {
170         (bool success,) = to.call{value:value}(new bytes(0));
171         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
172     }
173 }
174 
175 interface ISushiswapV2Factory {
176     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
177 
178     function feeTo() external view returns (address);
179     function feeToSetter() external view returns (address);
180     function migrator() external view returns (address);
181 
182     function getPair(address tokenA, address tokenB) external view returns (address pair);
183     function allPairs(uint) external view returns (address pair);
184     function allPairsLength() external view returns (uint);
185 
186     function createPair(address tokenA, address tokenB) external returns (address pair);
187 
188     function setFeeTo(address) external;
189     function setFeeToSetter(address) external;
190     function setMigrator(address) external;
191 }
192 
193 interface IwNATIVE {
194     function deposit() external payable;
195     function transfer(address to, uint value) external returns (bool);
196     function withdraw(uint) external;
197 }
198 
199 interface AnyswapV1ERC20 {
200     function mint(address to, uint256 amount) external returns (bool);
201     function burn(address from, uint256 amount) external returns (bool);
202     function changeVault(address newVault) external returns (bool);
203     function depositVault(uint amount, address to) external returns (uint);
204     function withdrawVault(address from, uint amount, address to) external returns (uint);
205     function underlying() external view returns (address);
206 }
207 
208 /**
209  * @dev Interface of the ERC20 standard as defined in the EIP.
210  */
211 interface IERC20 {
212     function totalSupply() external view returns (uint256);
213     function balanceOf(address account) external view returns (uint256);
214     function transfer(address recipient, uint256 amount) external returns (bool);
215     function allowance(address owner, address spender) external view returns (uint256);
216     function approve(address spender, uint256 amount) external returns (bool);
217     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
218     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
219     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
220 
221     event Transfer(address indexed from, address indexed to, uint256 value);
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 library Address {
226     function isContract(address account) internal view returns (bool) {
227         bytes32 codehash;
228         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
229         // solhint-disable-next-line no-inline-assembly
230         assembly { codehash := extcodehash(account) }
231         return (codehash != 0x0 && codehash != accountHash);
232     }
233 }
234 
235 library SafeERC20 {
236     using Address for address;
237 
238     function safeTransfer(IERC20 token, address to, uint value) internal {
239         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
240     }
241 
242     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
243         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
244     }
245 
246     function safeApprove(IERC20 token, address spender, uint value) internal {
247         require((value == 0) || (token.allowance(address(this), spender) == 0),
248             "SafeERC20: approve from non-zero to non-zero allowance"
249         );
250         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
251     }
252     function callOptionalReturn(IERC20 token, bytes memory data) private {
253         require(address(token).isContract(), "SafeERC20: call to non-contract");
254 
255         // solhint-disable-next-line avoid-low-level-calls
256         (bool success, bytes memory returndata) = address(token).call(data);
257         require(success, "SafeERC20: low-level call failed");
258 
259         if (returndata.length > 0) { // Return data is optional
260             // solhint-disable-next-line max-line-length
261             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
262         }
263     }
264 }
265 
266 contract AnyswapV1Vault {
267     using SafeERC20 for IERC20;
268     using SafeMathSushiswap for uint;
269 
270     address public immutable factory;
271     address public immutable wNATIVE;
272 
273     modifier ensure(uint deadline) {
274         require(deadline >= block.timestamp, 'SushiswapV2Router: EXPIRED');
275         _;
276     }
277 
278     constructor(address _factory, address _wNATIVE, address _mpc) {
279         _newMPC = _mpc;
280         _newMPCEffectiveTime = block.timestamp;
281         factory = _factory;
282         wNATIVE = _wNATIVE;
283     }
284 
285     receive() external payable {
286         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
287     }
288 
289     address private _oldMPC;
290     address private _newMPC;
291     uint256 private _newMPCEffectiveTime;
292 
293 
294     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
295     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
296     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
297     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
298     event LogAnySwapTradeTokensForTokens(address[] indexed path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
299     event LogAnySwapTradeTokensForNative(address[] indexed path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
300     event LogAnyCallQueue(address indexed callContract, uint value, bytes data, uint fromChainID, uint toChainID);
301     event LogAnyCallExecute(address indexed callContract, uint value, bytes data, bool success, uint fromChainID, uint toChainID);
302 
303     modifier onlyMPC() {
304         require(msg.sender == mpc(), "AnyswapV1Safe: FORBIDDEN");
305         _;
306     }
307 
308     function mpc() public view returns (address) {
309         if (block.timestamp >= _newMPCEffectiveTime) {
310             return _newMPC;
311         }
312         return _oldMPC;
313     }
314 
315     function cID() public view returns (uint id) {
316         assembly {id := chainid()}
317     }
318 
319     function changeMPC(address newMPC) public onlyMPC returns (bool) {
320         require(newMPC != address(0), "AnyswapV1Safe: address(0x0)");
321         _oldMPC = mpc();
322         _newMPC = newMPC;
323         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
324         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
325         return true;
326     }
327 
328     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
329         require(newVault != address(0), "AnyswapV1Safe: address(0x0)");
330         return AnyswapV1ERC20(token).changeVault(newVault);
331     }
332 
333     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
334         AnyswapV1ERC20(token).burn(from, amount);
335         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
336     }
337 
338     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
339     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
340         _anySwapOut(msg.sender, token, to, amount, toChainID);
341     }
342 
343     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
344     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
345         IERC20(AnyswapV1ERC20(token).underlying()).safeTransferFrom(msg.sender, token, amount);
346         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
347         _anySwapOut(msg.sender, token, to, amount, toChainID);
348     }
349 
350     function anySwapOutUnderlyingWithPermit(
351         address from,
352         address token,
353         address to,
354         uint amount,
355         uint deadline,
356         uint8 v,
357         bytes32 r,
358         bytes32 s,
359         uint toChainID
360     ) external {
361         address _underlying = AnyswapV1ERC20(token).underlying();
362         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
363         IERC20(_underlying).safeTransferFrom(from, token, amount);
364         AnyswapV1ERC20(token).depositVault(amount, from);
365         _anySwapOut(from, token, to, amount, toChainID);
366     }
367 
368     function anySwapOutUnderlyingWithTransferPermit(
369         address from,
370         address token,
371         address to,
372         uint amount,
373         uint deadline,
374         uint8 v,
375         bytes32 r,
376         bytes32 s,
377         uint toChainID
378     ) external {
379         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
380         AnyswapV1ERC20(token).depositVault(amount, from);
381         _anySwapOut(from, token, to, amount, toChainID);
382     }
383 
384     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
385         for (uint i = 0; i < tokens.length; i++) {
386             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
387         }
388     }
389 
390     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
391     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
392         AnyswapV1ERC20(token).mint(to, amount);
393         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
394     }
395 
396     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
397     // triggered by `anySwapOut`
398     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
399         _anySwapIn(txs, token, to, amount, fromChainID);
400     }
401 
402     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
403     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
404         _anySwapIn(txs, token, to, amount, fromChainID);
405         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
406     }
407 
408     // extracts mpc fee from bridge fees
409     function anySwapFeeTo(address token, uint amount) external onlyMPC {
410         address _mpc = mpc();
411         AnyswapV1ERC20(token).mint(_mpc, amount);
412         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
413     }
414 
415     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
416         for (uint i = 0; i < tokens.length; i++) {
417             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
418         }
419     }
420 
421     // **** SWAP ****
422     // requires the initial amount to have already been sent to the first pair
423     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
424         for (uint i; i < path.length - 1; i++) {
425             (address input, address output) = (path[i], path[i + 1]);
426             (address token0,) = SushiswapV2Library.sortTokens(input, output);
427             uint amountOut = amounts[i + 1];
428             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
429             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
430             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
431                 amount0Out, amount1Out, to, new bytes(0)
432             );
433         }
434     }
435 
436     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
437     function anySwapOutExactTokensForTokens(
438         uint amountIn,
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline,
443         uint toChainID
444     ) external virtual ensure(deadline) {
445         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
446         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
447     }
448 
449     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
450     function anySwapOutExactTokensForTokensUnderlying(
451         uint amountIn,
452         uint amountOutMin,
453         address[] calldata path,
454         address to,
455         uint deadline,
456         uint toChainID
457     ) external virtual ensure(deadline) {
458         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
459         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
460         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
461         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
462     }
463 
464     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
465     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
466         address from,
467         uint amountIn,
468         uint amountOutMin,
469         address[] calldata path,
470         address to,
471         uint deadline,
472         uint8 v,
473         bytes32 r,
474         bytes32 s,
475         uint toChainID
476     ) external virtual ensure(deadline) {
477         address _underlying = AnyswapV1ERC20(path[0]).underlying();
478         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
479         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
480         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
481         AnyswapV1ERC20(path[0]).burn(from, amountIn);
482         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
483     }
484 
485     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
486     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
487         address from,
488         uint amountIn,
489         uint amountOutMin,
490         address[] calldata path,
491         address to,
492         uint deadline,
493         uint8 v,
494         bytes32 r,
495         bytes32 s,
496         uint toChainID
497     ) external virtual ensure(deadline) {
498         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
499         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
500         AnyswapV1ERC20(path[0]).burn(from, amountIn);
501         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
502     }
503 
504     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
505     // Triggered by `anySwapOutExactTokensForTokens`
506     function anySwapInExactTokensForTokens(
507         bytes32 txs,
508         uint amountIn,
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline,
513         uint fromChainID
514     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
515         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
516         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
517         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
518         _swap(amounts, path, to);
519     }
520 
521     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
522     function anySwapOutExactTokensForNative(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline,
528         uint toChainID
529     ) external virtual ensure(deadline) {
530         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
531         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
532     }
533 
534     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
535     function anySwapOutExactTokensForNativeUnderlying(
536         uint amountIn,
537         uint amountOutMin,
538         address[] calldata path,
539         address to,
540         uint deadline,
541         uint toChainID
542     ) external virtual ensure(deadline) {
543         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
544         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
545         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
546         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
547     }
548 
549     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
550     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
551         address from,
552         uint amountIn,
553         uint amountOutMin,
554         address[] calldata path,
555         address to,
556         uint deadline,
557         uint8 v,
558         bytes32 r,
559         bytes32 s,
560         uint toChainID
561     ) external virtual ensure(deadline) {
562         address _underlying = AnyswapV1ERC20(path[0]).underlying();
563         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
564         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
565         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
566         AnyswapV1ERC20(path[0]).burn(from, amountIn);
567         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
568     }
569 
570     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
571     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
572         address from,
573         uint amountIn,
574         uint amountOutMin,
575         address[] calldata path,
576         address to,
577         uint deadline,
578         uint8 v,
579         bytes32 r,
580         bytes32 s,
581         uint toChainID
582     ) external virtual ensure(deadline) {
583         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
584         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
585         AnyswapV1ERC20(path[0]).burn(from, amountIn);
586         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
587     }
588 
589     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
590     // Triggered by `anySwapOutExactTokensForNative`
591     function anySwapInExactTokensForNative(
592         bytes32 txs,
593         uint amountIn,
594         uint amountOutMin,
595         address[] calldata path,
596         address to,
597         uint deadline,
598         uint fromChainID
599     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
600         require(path[path.length - 1] == wNATIVE, 'SushiswapV2Router: INVALID_PATH');
601         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
602         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
603         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
604         _swap(amounts, path, address(this));
605         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
606         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
607     }
608 
609     // **** LIBRARY FUNCTIONS ****
610     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
611         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
612     }
613 
614     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
615         public
616         pure
617         virtual
618         returns (uint amountOut)
619     {
620         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
621     }
622 
623     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
624         public
625         pure
626         virtual
627         returns (uint amountIn)
628     {
629         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
630     }
631 
632     function getAmountsOut(uint amountIn, address[] memory path)
633         public
634         view
635         virtual
636         returns (uint[] memory amounts)
637     {
638         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
639     }
640 
641     function getAmountsIn(uint amountOut, address[] memory path)
642         public
643         view
644         virtual
645         returns (uint[] memory amounts)
646     {
647         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
648     }
649 }
