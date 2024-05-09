1 /**
2  *Submitted for verification at BscScan.com on 2022-01-28
3 */
4 
5 /**
6  *Submitted for verification at snowtrace.io on 2022-01-28
7 */
8 
9 // SPDX-License-Identifier: GPL-3.0-or-later
10 
11 pragma solidity >=0.8.2;
12 
13 interface ISushiswapV2Pair {
14     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
15     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
16 }
17 
18 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
19 
20 library SafeMathSushiswap {
21     function add(uint x, uint y) internal pure returns (uint z) {
22         unchecked {
23             require((z = x + y) >= x, 'ds-math-add-overflow');
24         }
25     }
26 
27     function sub(uint x, uint y) internal pure returns (uint z) {
28         unchecked {
29             require((z = x - y) <= x, 'ds-math-sub-underflow');
30         }
31     }
32 
33     function mul(uint x, uint y) internal pure returns (uint z) {
34         unchecked {
35             require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
36         }
37     }
38 }
39 
40 library SushiswapV2Library {
41     using SafeMathSushiswap for uint;
42 
43     // returns sorted token addresses, used to handle return values from pairs sorted in this order
44     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
45         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
46         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
47         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
48     }
49 
50     // calculates the CREATE2 address for a pair without making any external calls
51     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
52         (address token0, address token1) = sortTokens(tokenA, tokenB);
53         pair = address(uint160(uint256(keccak256(abi.encodePacked(
54                 hex'ff',
55                 factory,
56                 keccak256(abi.encodePacked(token0, token1)),
57                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
58             )))));
59     }
60 
61     // fetches and sorts the reserves for a pair
62     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
63         (address token0,) = sortTokens(tokenA, tokenB);
64         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
65         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
66     }
67 
68     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
69     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
70         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
71         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
72         amountB = amountA.mul(reserveB) / reserveA;
73     }
74 
75     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
76     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
77         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
78         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
79         uint amountInWithFee = amountIn.mul(997);
80         uint numerator = amountInWithFee.mul(reserveOut);
81         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
82         amountOut = numerator / denominator;
83     }
84 
85     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
86     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
87         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
88         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
89         uint numerator = reserveIn.mul(amountOut).mul(1000);
90         uint denominator = reserveOut.sub(amountOut).mul(997);
91         amountIn = (numerator / denominator).add(1);
92     }
93 
94     // performs chained getAmountOut calculations on any number of pairs
95     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
96         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
97         amounts = new uint[](path.length);
98         amounts[0] = amountIn;
99         for (uint i; i < path.length - 1; i++) {
100             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
101             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
102         }
103     }
104 
105     // performs chained getAmountIn calculations on any number of pairs
106     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
107         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
108         amounts = new uint[](path.length);
109         amounts[amounts.length - 1] = amountOut;
110         for (uint i = path.length - 1; i > 0; i--) {
111             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
112             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
113         }
114     }
115 }
116 
117 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
118 library TransferHelper {
119     function safeApprove(address token, address to, uint value) internal {
120         // bytes4(keccak256(bytes('approve(address,uint256)')));
121         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
122         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
123     }
124 
125     function safeTransfer(address token, address to, uint value) internal {
126         // bytes4(keccak256(bytes('transfer(address,uint256)')));
127         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
128         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
129     }
130 
131     function safeTransferFrom(address token, address from, address to, uint value) internal {
132         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
133         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
134         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
135     }
136 
137     function safeTransferNative(address to, uint value) internal {
138         (bool success,) = to.call{value:value}(new bytes(0));
139         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
140     }
141 }
142 
143 interface IwNATIVE {
144     function deposit() external payable;
145     function transfer(address to, uint value) external returns (bool);
146     function withdraw(uint) external;
147 }
148 
149 interface AnyswapV1ERC20 {
150     function mint(address to, uint256 amount) external returns (bool);
151     function burn(address from, uint256 amount) external returns (bool);
152     function setMinter(address _auth) external;
153     function applyMinter() external;
154     function revokeMinter(address _auth) external;
155     function changeVault(address newVault) external returns (bool);
156     function depositVault(uint amount, address to) external returns (uint);
157     function withdrawVault(address from, uint amount, address to) external returns (uint);
158     function underlying() external view returns (address);
159     function deposit(uint amount, address to) external returns (uint);
160     function withdraw(uint amount, address to) external returns (uint);
161 }
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167     function totalSupply() external view returns (uint256);
168     function balanceOf(address account) external view returns (uint256);
169     function transfer(address recipient, uint256 amount) external returns (bool);
170     function allowance(address owner, address spender) external view returns (uint256);
171     function approve(address spender, uint256 amount) external returns (bool);
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     event Transfer(address indexed from, address indexed to, uint256 value);
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 library Address {
179     function isContract(address account) internal view returns (bool) {
180         bytes32 codehash;
181         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
182         // solhint-disable-next-line no-inline-assembly
183         assembly { codehash := extcodehash(account) }
184         return (codehash != 0x0 && codehash != accountHash);
185     }
186 }
187 
188 library SafeERC20 {
189     using Address for address;
190 
191     function safeTransfer(IERC20 token, address to, uint value) internal {
192         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
193     }
194 
195     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
196         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
197     }
198 
199     function safeApprove(IERC20 token, address spender, uint value) internal {
200         require((value == 0) || (token.allowance(address(this), spender) == 0),
201             "SafeERC20: approve from non-zero to non-zero allowance"
202         );
203         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
204     }
205     function callOptionalReturn(IERC20 token, bytes memory data) private {
206         require(address(token).isContract(), "SafeERC20: call to non-contract");
207 
208         // solhint-disable-next-line avoid-low-level-calls
209         (bool success, bytes memory returndata) = address(token).call(data);
210         require(success, "SafeERC20: low-level call failed");
211 
212         if (returndata.length > 0) { // Return data is optional
213             // solhint-disable-next-line max-line-length
214             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
215         }
216     }
217 }
218 
219 contract AnyswapV6Router {
220     using SafeERC20 for IERC20;
221     using SafeMathSushiswap for uint;
222 
223     address public immutable factory;
224     address public immutable wNATIVE;
225 
226     bool public enableSwapTrade;
227     modifier swapTradeEnabled() {
228         require(enableSwapTrade, 'AnyswapV6Router: SwapTrade disabled');
229         _;
230     }
231 
232     modifier ensure(uint deadline) {
233         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
234         _;
235     }
236 
237     constructor(address _factory, address _wNATIVE, address _mpc) {
238         _newMPC = _mpc;
239         _newMPCEffectiveTime = block.timestamp;
240         factory = _factory;
241         wNATIVE = _wNATIVE;
242     }
243 
244     receive() external payable {
245         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
246     }
247 
248     address private _oldMPC;
249     address private _newMPC;
250     uint256 private _newMPCEffectiveTime;
251 
252 
253     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
254     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
255     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
256     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
257     event LogAnySwapOut(address indexed token, address indexed from, string to, uint amount, uint fromChainID, uint toChainID);
258     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
259     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
260 
261     modifier onlyMPC() {
262         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
263         _;
264     }
265 
266     function mpc() public view returns (address) {
267         if (block.timestamp >= _newMPCEffectiveTime) {
268             return _newMPC;
269         }
270         return _oldMPC;
271     }
272 
273     function cID() public view returns (uint id) {
274         assembly {id := chainid()}
275     }
276 
277     function setEnableSwapTrade(bool enable) external onlyMPC {
278         enableSwapTrade = enable;
279     }
280 
281     function changeMPC(address newMPC) public onlyMPC returns (bool) {
282         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
283         _oldMPC = mpc();
284         _newMPC = newMPC;
285         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
286         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
287         return true;
288     }
289 
290     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
291         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
292         return AnyswapV1ERC20(token).changeVault(newVault);
293     }
294 
295     function setMinter(address token, address _auth) external onlyMPC {
296         return AnyswapV1ERC20(token).setMinter(_auth);
297     }
298 
299     function applyMinter(address token) external onlyMPC {
300         return AnyswapV1ERC20(token).applyMinter();
301     }
302 
303     function revokeMinter(address token, address _auth) external onlyMPC {
304         return AnyswapV1ERC20(token).revokeMinter(_auth);
305     }
306 
307     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
308         AnyswapV1ERC20(token).burn(from, amount);
309         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
310     }
311 
312     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
313     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
314         _anySwapOut(msg.sender, token, to, amount, toChainID);
315     }
316 
317     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
318     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
319         IERC20(AnyswapV1ERC20(token).underlying()).safeTransferFrom(msg.sender, token, amount);
320         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
321     }
322 
323     function anySwapOutNative(address token, address to, uint toChainID) external payable {
324         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
325         IwNATIVE(wNATIVE).deposit{value: msg.value}();
326         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
327         emit LogAnySwapOut(token, msg.sender, to, msg.value, cID(), toChainID);
328     }
329 
330     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
331         for (uint i = 0; i < tokens.length; i++) {
332             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
333         }
334     }
335 
336     function anySwapOut(address token, string memory to, uint amount, uint toChainID) external {
337         AnyswapV1ERC20(token).burn(msg.sender, amount);
338         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
339     }
340 
341     function anySwapOutUnderlying(address token, string memory to, uint amount, uint toChainID) external {
342         IERC20(AnyswapV1ERC20(token).underlying()).safeTransferFrom(msg.sender, token, amount);
343         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
344     }
345 
346     function anySwapOutNative(address token, string memory to, uint toChainID) external payable {
347         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
348         IwNATIVE(wNATIVE).deposit{value: msg.value}();
349         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
350         emit LogAnySwapOut(token, msg.sender, to, msg.value, cID(), toChainID);
351     }
352 
353     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
354     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
355         AnyswapV1ERC20(token).mint(to, amount);
356         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
357     }
358 
359     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
360     // triggered by `anySwapOut`
361     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
362         _anySwapIn(txs, token, to, amount, fromChainID);
363     }
364 
365     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
366     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
367         _anySwapIn(txs, token, to, amount, fromChainID);
368         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
369     }
370 
371     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
372     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
373         _anySwapIn(txs, token, to, amount, fromChainID);
374         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
375         address _underlying = _anyToken.underlying();
376         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
377             if (_underlying == wNATIVE) {
378                 _anyToken.withdrawVault(to, amount, address(this));
379                 IwNATIVE(wNATIVE).withdraw(amount);
380                 TransferHelper.safeTransferNative(to, amount);
381             } else {
382                 _anyToken.withdrawVault(to, amount, to);
383             }
384         }
385     }
386 
387     function depositNative(address token, address to) external payable returns (uint) {
388         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
389         IwNATIVE(wNATIVE).deposit{value: msg.value}();
390         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
391         AnyswapV1ERC20(token).depositVault(msg.value, to);
392         return msg.value;
393     }
394 
395     function withdrawNative(address token, uint amount, address to) external returns (uint) {
396         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV3Router: underlying is not wNATIVE");
397         AnyswapV1ERC20(token).withdrawVault(msg.sender, amount, address(this));
398         IwNATIVE(wNATIVE).withdraw(amount);
399         TransferHelper.safeTransferNative(to, amount);
400         return amount;
401     }
402 
403     // extracts mpc fee from bridge fees
404     function anySwapFeeTo(address token, uint amount) external onlyMPC {
405         address _mpc = mpc();
406         AnyswapV1ERC20(token).mint(_mpc, amount);
407         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
408     }
409 
410     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
411         for (uint i = 0; i < tokens.length; i++) {
412             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
413         }
414     }
415 
416     // **** SWAP ****
417     // requires the initial amount to have already been sent to the first pair
418     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
419         for (uint i; i < path.length - 1; i++) {
420             (address input, address output) = (path[i], path[i + 1]);
421             (address token0,) = SushiswapV2Library.sortTokens(input, output);
422             uint amountOut = amounts[i + 1];
423             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
424             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
425             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
426                 amount0Out, amount1Out, to, new bytes(0)
427             );
428         }
429     }
430 
431     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
432     function anySwapOutExactTokensForTokens(
433         uint amountIn,
434         uint amountOutMin,
435         address[] calldata path,
436         address to,
437         uint deadline,
438         uint toChainID
439     ) external virtual swapTradeEnabled ensure(deadline) {
440         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
441         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
442     }
443 
444     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
445     function anySwapOutExactTokensForTokensUnderlying(
446         uint amountIn,
447         uint amountOutMin,
448         address[] calldata path,
449         address to,
450         uint deadline,
451         uint toChainID
452     ) external virtual swapTradeEnabled ensure(deadline) {
453         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
454         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
455         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
456         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
457     }
458 
459     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
460     // Triggered by `anySwapOutExactTokensForTokens`
461     function anySwapInExactTokensForTokens(
462         bytes32 txs,
463         uint amountIn,
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline,
468         uint fromChainID
469     ) external onlyMPC virtual swapTradeEnabled ensure(deadline) returns (uint[] memory amounts) {
470         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
471         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
472         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
473         _swap(amounts, path, to);
474     }
475 
476     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
477     function anySwapOutExactTokensForNative(
478         uint amountIn,
479         uint amountOutMin,
480         address[] calldata path,
481         address to,
482         uint deadline,
483         uint toChainID
484     ) external virtual swapTradeEnabled ensure(deadline) {
485         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
486         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
487     }
488 
489     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
490     function anySwapOutExactTokensForNativeUnderlying(
491         uint amountIn,
492         uint amountOutMin,
493         address[] calldata path,
494         address to,
495         uint deadline,
496         uint toChainID
497     ) external virtual swapTradeEnabled ensure(deadline) {
498         IERC20(AnyswapV1ERC20(path[0]).underlying()).safeTransferFrom(msg.sender, path[0], amountIn);
499         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
500         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
501         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
502     }
503 
504     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
505     // Triggered by `anySwapOutExactTokensForNative`
506     function anySwapInExactTokensForNative(
507         bytes32 txs,
508         uint amountIn,
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline,
513         uint fromChainID
514     ) external onlyMPC virtual swapTradeEnabled ensure(deadline) returns (uint[] memory amounts) {
515         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
516         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
517         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
518         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
519         _swap(amounts, path, address(this));
520         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
521         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
522     }
523 
524     // **** LIBRARY FUNCTIONS ****
525     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
526         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
527     }
528 
529     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
530         public
531         pure
532         virtual
533         returns (uint amountOut)
534     {
535         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
536     }
537 
538     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
539         public
540         pure
541         virtual
542         returns (uint amountIn)
543     {
544         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
545     }
546 
547     function getAmountsOut(uint amountIn, address[] memory path)
548         public
549         view
550         virtual
551         returns (uint[] memory amounts)
552     {
553         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
554     }
555 
556     function getAmountsIn(uint amountOut, address[] memory path)
557         public
558         view
559         virtual
560         returns (uint[] memory amounts)
561     {
562         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
563     }
564 }