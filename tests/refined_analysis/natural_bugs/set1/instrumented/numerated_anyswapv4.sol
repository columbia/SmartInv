1 
2 // SPDX-License-Identifier: GPL-3.0-or-later
3 
4 pragma solidity >=0.8.0;
5 
6 interface ISushiswapV2Pair {
7     function factory() external view returns (address);
8     function token0() external view returns (address);
9     function token1() external view returns (address);
10     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
11     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
12 }
13 
14 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
15 
16 library SafeMathSushiswap {
17     function add(uint x, uint y) internal pure returns (uint z) {
18         require((z = x + y) >= x, 'ds-math-add-overflow');
19     }
20 
21     function sub(uint x, uint y) internal pure returns (uint z) {
22         require((z = x - y) <= x, 'ds-math-sub-underflow');
23     }
24 
25     function mul(uint x, uint y) internal pure returns (uint z) {
26         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
27     }
28 }
29 
30 library SushiswapV2Library {
31     using SafeMathSushiswap for uint;
32 
33     // returns sorted token addresses, used to handle return values from pairs sorted in this order
34     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
35         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
36         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
37         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
38     }
39 
40     // calculates the CREATE2 address for a pair without making any external calls
41     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
42         (address token0, address token1) = sortTokens(tokenA, tokenB);
43         pair = address(uint160(uint256(keccak256(abi.encodePacked(
44                 hex'ff',
45                 factory,
46                 keccak256(abi.encodePacked(token0, token1)),
47                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
48             )))));
49     }
50 
51     // fetches and sorts the reserves for a pair
52     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
53         (address token0,) = sortTokens(tokenA, tokenB);
54         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
55         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
56     }
57 
58     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
59     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
60         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
61         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
62         amountB = amountA.mul(reserveB) / reserveA;
63     }
64 
65     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
66     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
67         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
68         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
69         uint amountInWithFee = amountIn.mul(997);
70         uint numerator = amountInWithFee.mul(reserveOut);
71         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
72         amountOut = numerator / denominator;
73     }
74 
75     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
76     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
77         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
78         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
79         uint numerator = reserveIn.mul(amountOut).mul(1000);
80         uint denominator = reserveOut.sub(amountOut).mul(997);
81         amountIn = (numerator / denominator).add(1);
82     }
83 
84     // performs chained getAmountOut calculations on any number of pairs
85     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
86         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
87         amounts = new uint[](path.length);
88         amounts[0] = amountIn;
89         for (uint i; i < path.length - 1; i++) {
90             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
91             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
92         }
93     }
94 
95     // performs chained getAmountIn calculations on any number of pairs
96     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
97         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
98         amounts = new uint[](path.length);
99         amounts[amounts.length - 1] = amountOut;
100         for (uint i = path.length - 1; i > 0; i--) {
101             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
102             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
103         }
104     }
105 }
106 
107 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
108 library TransferHelper {
109     function safeApprove(address token, address to, uint value) internal {
110         // bytes4(keccak256(bytes('approve(address,uint256)')));
111         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
112         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
113     }
114 
115     function safeTransfer(address token, address to, uint value) internal {
116         // bytes4(keccak256(bytes('transfer(address,uint256)')));
117         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
118         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
119     }
120 
121     function safeTransferFrom(address token, address from, address to, uint value) internal {
122         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
123         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
124         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
125     }
126 
127     function safeTransferNative(address to, uint value) internal {
128         (bool success,) = to.call{value:value}(new bytes(0));
129         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
130     }
131 }
132 
133 interface IwNATIVE {
134     function deposit() external payable;
135     function transfer(address to, uint value) external returns (bool);
136     function withdraw(uint) external;
137 }
138 
139 interface AnyswapV1ERC20 {
140     function mint(address to, uint256 amount) external returns (bool);
141     function burn(address from, uint256 amount) external returns (bool);
142     function changeVault(address newVault) external returns (bool);
143     function depositVault(uint amount, address to) external returns (uint);
144     function withdrawVault(address from, uint amount, address to) external returns (uint);
145     function underlying() external view returns (address);
146 }
147 
148 /**
149  * @dev Interface of the ERC20 standard as defined in the EIP.
150  */
151 interface IERC20 {
152     function totalSupply() external view returns (uint256);
153     function balanceOf(address account) external view returns (uint256);
154     function transfer(address recipient, uint256 amount) external returns (bool);
155     function allowance(address owner, address spender) external view returns (uint256);
156     function approve(address spender, uint256 amount) external returns (bool);
157     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 contract AnyswapV4Router {
166     using SafeMathSushiswap for uint;
167 
168     address public immutable factory;
169     address public immutable wNATIVE;
170 
171     modifier ensure(uint deadline) {
172         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
173         _;
174     }
175 
176     constructor(address _factory, address _wNATIVE, address _mpc) {
177         _newMPC = _mpc;
178         _newMPCEffectiveTime = block.timestamp;
179         factory = _factory;
180         wNATIVE = _wNATIVE;
181     }
182 
183     receive() external payable {
184         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
185     }
186 
187     address private _oldMPC;
188     address private _newMPC;
189     uint256 private _newMPCEffectiveTime;
190 
191 
192     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
193     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
194     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
195     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
196     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
197     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
198 
199     modifier onlyMPC() {
200         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
201         _;
202     }
203 
204     function mpc() public view returns (address) {
205         if (block.timestamp >= _newMPCEffectiveTime) {
206             return _newMPC;
207         }
208         return _oldMPC;
209     }
210 
211     function cID() public view returns (uint id) {
212         assembly {id := chainid()}
213     }
214 
215     function changeMPC(address newMPC) public onlyMPC returns (bool) {
216         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
217         _oldMPC = mpc();
218         _newMPC = newMPC;
219         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
220         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
221         return true;
222     }
223 
224     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
225         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
226         return AnyswapV1ERC20(token).changeVault(newVault);
227     }
228 
229     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
230         AnyswapV1ERC20(token).burn(from, amount);
231         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
232     }
233 
234     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
235     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
236         _anySwapOut(msg.sender, token, to, amount, toChainID);
237     }
238 
239     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
240     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
241         TransferHelper.safeTransferFrom(AnyswapV1ERC20(token).underlying(), msg.sender, token, amount);
242         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
243         _anySwapOut(msg.sender, token, to, amount, toChainID);
244     }
245 
246     function anySwapOutUnderlyingWithPermit(
247         address from,
248         address token,
249         address to,
250         uint amount,
251         uint deadline,
252         uint8 v,
253         bytes32 r,
254         bytes32 s,
255         uint toChainID
256     ) external {
257         address _underlying = AnyswapV1ERC20(token).underlying();
258         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
259         TransferHelper.safeTransferFrom(_underlying, from, token, amount);
260         AnyswapV1ERC20(token).depositVault(amount, from);
261         _anySwapOut(from, token, to, amount, toChainID);
262     }
263 
264     function anySwapOutUnderlyingWithTransferPermit(
265         address from,
266         address token,
267         address to,
268         uint amount,
269         uint deadline,
270         uint8 v,
271         bytes32 r,
272         bytes32 s,
273         uint toChainID
274     ) external {
275         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
276         AnyswapV1ERC20(token).depositVault(amount, from);
277         _anySwapOut(from, token, to, amount, toChainID);
278     }
279 
280     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
281         for (uint i = 0; i < tokens.length; i++) {
282             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
283         }
284     }
285 
286     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
287     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
288         AnyswapV1ERC20(token).mint(to, amount);
289         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
290     }
291 
292     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
293     // triggered by `anySwapOut`
294     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
295         _anySwapIn(txs, token, to, amount, fromChainID);
296     }
297 
298     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
299     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
300         _anySwapIn(txs, token, to, amount, fromChainID);
301         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
302     }
303 
304     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
305     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
306         _anySwapIn(txs, token, to, amount, fromChainID);
307         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
308         address _underlying = _anyToken.underlying();
309         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
310             _anyToken.withdrawVault(to, amount, to);
311         }
312     }
313 
314     // extracts mpc fee from bridge fees
315     function anySwapFeeTo(address token, uint amount) external onlyMPC {
316         address _mpc = mpc();
317         AnyswapV1ERC20(token).mint(_mpc, amount);
318         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
319     }
320 
321     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
322         for (uint i = 0; i < tokens.length; i++) {
323             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
324         }
325     }
326 
327     // **** SWAP ****
328     // requires the initial amount to have already been sent to the first pair
329     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
330         for (uint i; i < path.length - 1; i++) {
331             (address input, address output) = (path[i], path[i + 1]);
332             (address token0,) = SushiswapV2Library.sortTokens(input, output);
333             uint amountOut = amounts[i + 1];
334             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
335             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
336             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
337                 amount0Out, amount1Out, to, new bytes(0)
338             );
339         }
340     }
341 
342     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
343     function anySwapOutExactTokensForTokens(
344         uint amountIn,
345         uint amountOutMin,
346         address[] calldata path,
347         address to,
348         uint deadline,
349         uint toChainID
350     ) external virtual ensure(deadline) {
351         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
352         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
353     }
354 
355     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
356     function anySwapOutExactTokensForTokensUnderlying(
357         uint amountIn,
358         uint amountOutMin,
359         address[] calldata path,
360         address to,
361         uint deadline,
362         uint toChainID
363     ) external virtual ensure(deadline) {
364         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
365         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
366         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
367         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
368     }
369 
370     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
371     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
372         address from,
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline,
378         uint8 v,
379         bytes32 r,
380         bytes32 s,
381         uint toChainID
382     ) external virtual ensure(deadline) {
383         address _underlying = AnyswapV1ERC20(path[0]).underlying();
384         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
385         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
386         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
387         AnyswapV1ERC20(path[0]).burn(from, amountIn);
388         {
389         address[] memory _path = path;
390         address _from = from;
391         address _to = to;
392         uint _amountIn = amountIn;
393         uint _amountOutMin = amountOutMin;
394         uint _cID = cID();
395         uint _toChainID = toChainID;
396         emit LogAnySwapTradeTokensForTokens(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
397         }
398     }
399 
400     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
401     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
402         address from,
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline,
408         uint8 v,
409         bytes32 r,
410         bytes32 s,
411         uint toChainID
412     ) external virtual ensure(deadline) {
413         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
414         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
415         AnyswapV1ERC20(path[0]).burn(from, amountIn);
416         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
417     }
418 
419     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
420     // Triggered by `anySwapOutExactTokensForTokens`
421     function anySwapInExactTokensForTokens(
422         bytes32 txs,
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline,
428         uint fromChainID
429     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
430         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
431         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
432         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
433         _swap(amounts, path, to);
434     }
435 
436     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
437     function anySwapOutExactTokensForNative(
438         uint amountIn,
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline,
443         uint toChainID
444     ) external virtual ensure(deadline) {
445         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
446         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
447     }
448 
449     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
450     function anySwapOutExactTokensForNativeUnderlying(
451         uint amountIn,
452         uint amountOutMin,
453         address[] calldata path,
454         address to,
455         uint deadline,
456         uint toChainID
457     ) external virtual ensure(deadline) {
458         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
459         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
460         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
461         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
462     }
463 
464     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
465     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
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
479         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
480         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
481         AnyswapV1ERC20(path[0]).burn(from, amountIn);
482         {
483         address[] memory _path = path;
484         address _from = from;
485         address _to = to;
486         uint _amountIn = amountIn;
487         uint _amountOutMin = amountOutMin;
488         uint _cID = cID();
489         uint _toChainID = toChainID;
490         emit LogAnySwapTradeTokensForNative(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
491         }
492     }
493 
494     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
495     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
496         address from,
497         uint amountIn,
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline,
502         uint8 v,
503         bytes32 r,
504         bytes32 s,
505         uint toChainID
506     ) external virtual ensure(deadline) {
507         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
508         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
509         AnyswapV1ERC20(path[0]).burn(from, amountIn);
510         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
511     }
512 
513     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
514     // Triggered by `anySwapOutExactTokensForNative`
515     function anySwapInExactTokensForNative(
516         bytes32 txs,
517         uint amountIn,
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline,
522         uint fromChainID
523     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
524         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
525         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
526         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
527         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
528         _swap(amounts, path, address(this));
529         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
530         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
531     }
532 
533     // **** LIBRARY FUNCTIONS ****
534     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
535         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
536     }
537 
538     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
539         public
540         pure
541         virtual
542         returns (uint amountOut)
543     {
544         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
545     }
546 
547     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
548         public
549         pure
550         virtual
551         returns (uint amountIn)
552     {
553         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
554     }
555 
556     function getAmountsOut(uint amountIn, address[] memory path)
557         public
558         view
559         virtual
560         returns (uint[] memory amounts)
561     {
562         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
563     }
564 
565     function getAmountsIn(uint amountOut, address[] memory path)
566         public
567         view
568         virtual
569         returns (uint[] memory amounts)
570     {
571         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
572     }
573 }