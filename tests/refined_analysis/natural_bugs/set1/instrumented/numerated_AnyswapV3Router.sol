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
266 contract AnyswapV3Router {
267     using SafeERC20 for IERC20;
268     using SafeMathSushiswap for uint;
269 
270     address public immutable factory;
271     address public immutable wNATIVE;
272 
273     modifier ensure(uint deadline) {
274         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
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
298     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
299     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
300 
301     modifier onlyMPC() {
302         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
303         _;
304     }
305 
306     function mpc() public view returns (address) {
307         if (block.timestamp >= _newMPCEffectiveTime) {
308             return _newMPC;
309         }
310         return _oldMPC;
311     }
312 
313     function cID() public view returns (uint id) {
314         assembly {id := chainid()}
315     }
316 
317     function changeMPC(address newMPC) public onlyMPC returns (bool) {
318         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
319         _oldMPC = mpc();
320         _newMPC = newMPC;
321         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
322         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
323         return true;
324     }
325 
326     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
327         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
328         return AnyswapV1ERC20(token).changeVault(newVault);
329     }
330 
331     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
332         AnyswapV1ERC20(token).burn(from, amount);
333         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
334     }
335 
336     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
337     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
338         _anySwapOut(msg.sender, token, to, amount, toChainID);
339     }
340 
341     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
342     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
343         IERC20(AnyswapV1ERC20(token).underlying()).safeTransferFrom(msg.sender, token, amount);
344         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
345         _anySwapOut(msg.sender, token, to, amount, toChainID);
346     }
347 
348     function anySwapOutUnderlyingWithPermit(
349         address from,
350         address token,
351         address to,
352         uint amount,
353         uint deadline,
354         uint8 v,
355         bytes32 r,
356         bytes32 s,
357         uint toChainID
358     ) external {
359         address _underlying = AnyswapV1ERC20(token).underlying();
360         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
361         IERC20(_underlying).safeTransferFrom(from, token, amount);
362         AnyswapV1ERC20(token).depositVault(amount, from);
363         _anySwapOut(from, token, to, amount, toChainID);
364     }
365 
366     function anySwapOutUnderlyingWithTransferPermit(
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
377         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
378         AnyswapV1ERC20(token).depositVault(amount, from);
379         _anySwapOut(from, token, to, amount, toChainID);
380     }
381 
382     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
383         for (uint i = 0; i < tokens.length; i++) {
384             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
385         }
386     }
387 
388     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
389     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
390         AnyswapV1ERC20(token).mint(to, amount);
391         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
392     }
393 
394     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
395     // triggered by `anySwapOut`
396     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
397         _anySwapIn(txs, token, to, amount, fromChainID);
398     }
399 
400     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
401     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
402         _anySwapIn(txs, token, to, amount, fromChainID);
403         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
404     }
405 
406     // extracts mpc fee from bridge fees
407     function anySwapFeeTo(address token, uint amount) external onlyMPC {
408         address _mpc = mpc();
409         AnyswapV1ERC20(token).mint(_mpc, amount);
410         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
411     }
412 
413     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
414         for (uint i = 0; i < tokens.length; i++) {
415             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
416         }
417     }
418 
419     // **** SWAP ****
420     // requires the initial amount to have already been sent to the first pair
421     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
422         for (uint i; i < path.length - 1; i++) {
423             (address input, address output) = (path[i], path[i + 1]);
424             (address token0,) = SushiswapV2Library.sortTokens(input, output);
425             uint amountOut = amounts[i + 1];
426             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
427             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
428             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
429                 amount0Out, amount1Out, to, new bytes(0)
430             );
431         }
432     }
433 
434     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
435     function anySwapOutExactTokensForTokens(
436         uint amountIn,
437         uint amountOutMin,
438         address[] calldata path,
439         address to,
440         uint deadline,
441         uint toChainID
442     ) external virtual ensure(deadline) {
443         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
444         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
445     }
446 
447     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
448     function anySwapOutExactTokensForTokensUnderlying(
449         uint amountIn,
450         uint amountOutMin,
451         address[] calldata path,
452         address to,
453         uint deadline,
454         uint toChainID
455     ) external virtual ensure(deadline) {
456         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
457         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
458         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
459         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
460     }
461 
462     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
463     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
464         address from,
465         uint amountIn,
466         uint amountOutMin,
467         address[] calldata path,
468         address to,
469         uint deadline,
470         uint8 v,
471         bytes32 r,
472         bytes32 s,
473         uint toChainID
474     ) external virtual ensure(deadline) {
475         address _underlying = AnyswapV1ERC20(path[0]).underlying();
476         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
477         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
478         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
479         AnyswapV1ERC20(path[0]).burn(from, amountIn);
480         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
481     }
482 
483     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
484     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
485         address from,
486         uint amountIn,
487         uint amountOutMin,
488         address[] calldata path,
489         address to,
490         uint deadline,
491         uint8 v,
492         bytes32 r,
493         bytes32 s,
494         uint toChainID
495     ) external virtual ensure(deadline) {
496         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
497         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
498         AnyswapV1ERC20(path[0]).burn(from, amountIn);
499         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
500     }
501 
502     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
503     // Triggered by `anySwapOutExactTokensForTokens`
504     function anySwapInExactTokensForTokens(
505         bytes32 txs,
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline,
511         uint fromChainID
512     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
513         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
514         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
515         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
516         _swap(amounts, path, to);
517     }
518 
519     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
520     function anySwapOutExactTokensForNative(
521         uint amountIn,
522         uint amountOutMin,
523         address[] calldata path,
524         address to,
525         uint deadline,
526         uint toChainID
527     ) external virtual ensure(deadline) {
528         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
529         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
530     }
531 
532     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
533     function anySwapOutExactTokensForNativeUnderlying(
534         uint amountIn,
535         uint amountOutMin,
536         address[] calldata path,
537         address to,
538         uint deadline,
539         uint toChainID
540     ) external virtual ensure(deadline) {
541         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
542         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
543         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
544         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
545     }
546 
547     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
548     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
549         address from,
550         uint amountIn,
551         uint amountOutMin,
552         address[] calldata path,
553         address to,
554         uint deadline,
555         uint8 v,
556         bytes32 r,
557         bytes32 s,
558         uint toChainID
559     ) external virtual ensure(deadline) {
560         address _underlying = AnyswapV1ERC20(path[0]).underlying();
561         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
562         IERC20(_underlying).safeTransferFrom(from, path[0], amountIn);
563         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
564         AnyswapV1ERC20(path[0]).burn(from, amountIn);
565         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
566     }
567 
568     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
569     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
570         address from,
571         uint amountIn,
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline,
576         uint8 v,
577         bytes32 r,
578         bytes32 s,
579         uint toChainID
580     ) external virtual ensure(deadline) {
581         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
582         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
583         AnyswapV1ERC20(path[0]).burn(from, amountIn);
584         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
585     }
586 
587     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
588     // Triggered by `anySwapOutExactTokensForNative`
589     function anySwapInExactTokensForNative(
590         bytes32 txs,
591         uint amountIn,
592         uint amountOutMin,
593         address[] calldata path,
594         address to,
595         uint deadline,
596         uint fromChainID
597     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
598         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
599         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
600         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
601         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
602         _swap(amounts, path, address(this));
603         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
604         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
605     }
606 
607     // **** LIBRARY FUNCTIONS ****
608     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
609         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
610     }
611 
612     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
613         public
614         pure
615         virtual
616         returns (uint amountOut)
617     {
618         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
619     }
620 
621     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
622         public
623         pure
624         virtual
625         returns (uint amountIn)
626     {
627         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
628     }
629 
630     function getAmountsOut(uint amountIn, address[] memory path)
631         public
632         view
633         virtual
634         returns (uint[] memory amounts)
635     {
636         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
637     }
638 
639     function getAmountsIn(uint amountOut, address[] memory path)
640         public
641         view
642         virtual
643         returns (uint[] memory amounts)
644     {
645         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
646     }
647 }
