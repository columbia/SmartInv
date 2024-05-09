1 /**
2  *Submitted for verification at FtmScan.com on 2021-05-31
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-04-15
7 */
8 
9 /**
10  *Submitted for verification at BscScan.com on 2021-04-08
11 */
12 
13 /**
14  *Submitted for verification at hecoinfo.com on 2021-04-08
15 */
16 
17 // SPDX-License-Identifier: GPL-3.0-or-later
18 
19 pragma solidity >=0.8.0;
20 
21 interface ISushiswapV2Pair {
22     function factory() external view returns (address);
23     function token0() external view returns (address);
24     function token1() external view returns (address);
25     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
26     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
27 }
28 
29 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
30 
31 library SafeMathSushiswap {
32     function add(uint x, uint y) internal pure returns (uint z) {
33         require((z = x + y) >= x, 'ds-math-add-overflow');
34     }
35 
36     function sub(uint x, uint y) internal pure returns (uint z) {
37         require((z = x - y) <= x, 'ds-math-sub-underflow');
38     }
39 
40     function mul(uint x, uint y) internal pure returns (uint z) {
41         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
42     }
43 }
44 
45 library SushiswapV2Library {
46     using SafeMathSushiswap for uint;
47 
48     // returns sorted token addresses, used to handle return values from pairs sorted in this order
49     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
50         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
51         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
52         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
53     }
54 
55     // calculates the CREATE2 address for a pair without making any external calls
56     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
57         (address token0, address token1) = sortTokens(tokenA, tokenB);
58         pair = address(uint160(uint256(keccak256(abi.encodePacked(
59                 hex'ff',
60                 factory,
61                 keccak256(abi.encodePacked(token0, token1)),
62                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
63             )))));
64     }
65 
66     // fetches and sorts the reserves for a pair
67     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
68         (address token0,) = sortTokens(tokenA, tokenB);
69         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
70         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
71     }
72 
73     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
74     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
75         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
76         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
77         amountB = amountA.mul(reserveB) / reserveA;
78     }
79 
80     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
81     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
82         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
83         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
84         uint amountInWithFee = amountIn.mul(997);
85         uint numerator = amountInWithFee.mul(reserveOut);
86         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
87         amountOut = numerator / denominator;
88     }
89 
90     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
91     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
92         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
93         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
94         uint numerator = reserveIn.mul(amountOut).mul(1000);
95         uint denominator = reserveOut.sub(amountOut).mul(997);
96         amountIn = (numerator / denominator).add(1);
97     }
98 
99     // performs chained getAmountOut calculations on any number of pairs
100     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
101         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
102         amounts = new uint[](path.length);
103         amounts[0] = amountIn;
104         for (uint i; i < path.length - 1; i++) {
105             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
106             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
107         }
108     }
109 
110     // performs chained getAmountIn calculations on any number of pairs
111     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
112         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
113         amounts = new uint[](path.length);
114         amounts[amounts.length - 1] = amountOut;
115         for (uint i = path.length - 1; i > 0; i--) {
116             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
117             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
118         }
119     }
120 }
121 
122 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
123 library TransferHelper {
124     function safeApprove(address token, address to, uint value) internal {
125         // bytes4(keccak256(bytes('approve(address,uint256)')));
126         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
127         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
128     }
129 
130     function safeTransfer(address token, address to, uint value) internal {
131         // bytes4(keccak256(bytes('transfer(address,uint256)')));
132         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
133         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
134     }
135 
136     function safeTransferFrom(address token, address from, address to, uint value) internal {
137         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
138         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
139         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
140     }
141 
142     function safeTransferNative(address to, uint value) internal {
143         (bool success,) = to.call{value:value}(new bytes(0));
144         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
145     }
146 }
147 
148 interface IwNATIVE {
149     function deposit() external payable;
150     function transfer(address to, uint value) external returns (bool);
151     function withdraw(uint) external;
152 }
153 
154 interface AnyswapV1ERC20 {
155     function mint(address to, uint256 amount) external returns (bool);
156     function burn(address from, uint256 amount) external returns (bool);
157     function changeVault(address newVault) external returns (bool);
158     function depositVault(uint amount, address to) external returns (uint);
159     function withdrawVault(address from, uint amount, address to) external returns (uint);
160     function underlying() external view returns (address);
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
172     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
175 
176     event Transfer(address indexed from, address indexed to, uint256 value);
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 contract AnyswapV4Router {
181     using SafeMathSushiswap for uint;
182 
183     address public immutable factory;
184     address public immutable wNATIVE;
185 
186     modifier ensure(uint deadline) {
187         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
188         _;
189     }
190 
191     constructor(address _factory, address _wNATIVE, address _mpc) {
192         _newMPC = _mpc;
193         _newMPCEffectiveTime = block.timestamp;
194         factory = _factory;
195         wNATIVE = _wNATIVE;
196     }
197 
198     receive() external payable {
199         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
200     }
201 
202     address private _oldMPC;
203     address private _newMPC;
204     uint256 private _newMPCEffectiveTime;
205 
206 
207     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
208     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
209     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
210     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
211     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
212     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
213 
214     modifier onlyMPC() {
215         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
216         _;
217     }
218 
219     function mpc() public view returns (address) {
220         if (block.timestamp >= _newMPCEffectiveTime) {
221             return _newMPC;
222         }
223         return _oldMPC;
224     }
225 
226     function cID() public view returns (uint id) {
227         assembly {id := chainid()}
228     }
229 
230     function changeMPC(address newMPC) public onlyMPC returns (bool) {
231         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
232         _oldMPC = mpc();
233         _newMPC = newMPC;
234         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
235         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
236         return true;
237     }
238 
239     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
240         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
241         return AnyswapV1ERC20(token).changeVault(newVault);
242     }
243 
244     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
245         AnyswapV1ERC20(token).burn(from, amount);
246         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
247     }
248 
249     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
250     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
251         _anySwapOut(msg.sender, token, to, amount, toChainID);
252     }
253 
254     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
255     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
256         TransferHelper.safeTransferFrom(AnyswapV1ERC20(token).underlying(), msg.sender, token, amount);
257         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
258         _anySwapOut(msg.sender, token, to, amount, toChainID);
259     }
260 
261     function anySwapOutUnderlyingWithPermit(
262         address from,
263         address token,
264         address to,
265         uint amount,
266         uint deadline,
267         uint8 v,
268         bytes32 r,
269         bytes32 s,
270         uint toChainID
271     ) external {
272         address _underlying = AnyswapV1ERC20(token).underlying();
273         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
274         TransferHelper.safeTransferFrom(_underlying, from, token, amount);
275         AnyswapV1ERC20(token).depositVault(amount, from);
276         _anySwapOut(from, token, to, amount, toChainID);
277     }
278 
279     function anySwapOutUnderlyingWithTransferPermit(
280         address from,
281         address token,
282         address to,
283         uint amount,
284         uint deadline,
285         uint8 v,
286         bytes32 r,
287         bytes32 s,
288         uint toChainID
289     ) external {
290         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
291         AnyswapV1ERC20(token).depositVault(amount, from);
292         _anySwapOut(from, token, to, amount, toChainID);
293     }
294 
295     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
296         for (uint i = 0; i < tokens.length; i++) {
297             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
298         }
299     }
300 
301     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
302     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
303         AnyswapV1ERC20(token).mint(to, amount);
304         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
305     }
306 
307     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
308     // triggered by `anySwapOut`
309     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
310         _anySwapIn(txs, token, to, amount, fromChainID);
311     }
312 
313     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
314     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
315         _anySwapIn(txs, token, to, amount, fromChainID);
316         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
317     }
318 
319     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
320     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
321         _anySwapIn(txs, token, to, amount, fromChainID);
322         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
323         address _underlying = _anyToken.underlying();
324         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
325             _anyToken.withdrawVault(to, amount, to);
326         }
327     }
328 
329     // extracts mpc fee from bridge fees
330     function anySwapFeeTo(address token, uint amount) external onlyMPC {
331         address _mpc = mpc();
332         AnyswapV1ERC20(token).mint(_mpc, amount);
333         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
334     }
335 
336     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
337         for (uint i = 0; i < tokens.length; i++) {
338             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
339         }
340     }
341 
342     // **** SWAP ****
343     // requires the initial amount to have already been sent to the first pair
344     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
345         for (uint i; i < path.length - 1; i++) {
346             (address input, address output) = (path[i], path[i + 1]);
347             (address token0,) = SushiswapV2Library.sortTokens(input, output);
348             uint amountOut = amounts[i + 1];
349             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
350             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
351             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
352                 amount0Out, amount1Out, to, new bytes(0)
353             );
354         }
355     }
356 
357     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
358     function anySwapOutExactTokensForTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline,
364         uint toChainID
365     ) external virtual ensure(deadline) {
366         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
367         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
368     }
369 
370     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
371     function anySwapOutExactTokensForTokensUnderlying(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline,
377         uint toChainID
378     ) external virtual ensure(deadline) {
379         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
380         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
381         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
382         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
383     }
384 
385     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
386     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
387         address from,
388         uint amountIn,
389         uint amountOutMin,
390         address[] calldata path,
391         address to,
392         uint deadline,
393         uint8 v,
394         bytes32 r,
395         bytes32 s,
396         uint toChainID
397     ) external virtual ensure(deadline) {
398         address _underlying = AnyswapV1ERC20(path[0]).underlying();
399         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
400         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
401         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
402         AnyswapV1ERC20(path[0]).burn(from, amountIn);
403         {
404         address[] memory _path = path;
405         address _from = from;
406         address _to = to;
407         uint _amountIn = amountIn;
408         uint _amountOutMin = amountOutMin;
409         uint _cID = cID();
410         uint _toChainID = toChainID;
411         emit LogAnySwapTradeTokensForTokens(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
412         }
413     }
414 
415     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
416     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
417         address from,
418         uint amountIn,
419         uint amountOutMin,
420         address[] calldata path,
421         address to,
422         uint deadline,
423         uint8 v,
424         bytes32 r,
425         bytes32 s,
426         uint toChainID
427     ) external virtual ensure(deadline) {
428         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
429         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
430         AnyswapV1ERC20(path[0]).burn(from, amountIn);
431         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
432     }
433 
434     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
435     // Triggered by `anySwapOutExactTokensForTokens`
436     function anySwapInExactTokensForTokens(
437         bytes32 txs,
438         uint amountIn,
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline,
443         uint fromChainID
444     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
445         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
446         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
447         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
448         _swap(amounts, path, to);
449     }
450 
451     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
452     function anySwapOutExactTokensForNative(
453         uint amountIn,
454         uint amountOutMin,
455         address[] calldata path,
456         address to,
457         uint deadline,
458         uint toChainID
459     ) external virtual ensure(deadline) {
460         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
461         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
462     }
463 
464     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
465     function anySwapOutExactTokensForNativeUnderlying(
466         uint amountIn,
467         uint amountOutMin,
468         address[] calldata path,
469         address to,
470         uint deadline,
471         uint toChainID
472     ) external virtual ensure(deadline) {
473         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
474         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
475         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
476         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
477     }
478 
479     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
480     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
481         address from,
482         uint amountIn,
483         uint amountOutMin,
484         address[] calldata path,
485         address to,
486         uint deadline,
487         uint8 v,
488         bytes32 r,
489         bytes32 s,
490         uint toChainID
491     ) external virtual ensure(deadline) {
492         address _underlying = AnyswapV1ERC20(path[0]).underlying();
493         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
494         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
495         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
496         AnyswapV1ERC20(path[0]).burn(from, amountIn);
497         {
498         address[] memory _path = path;
499         address _from = from;
500         address _to = to;
501         uint _amountIn = amountIn;
502         uint _amountOutMin = amountOutMin;
503         uint _cID = cID();
504         uint _toChainID = toChainID;
505         emit LogAnySwapTradeTokensForNative(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
506         }
507     }
508 
509     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
510     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
511         address from,
512         uint amountIn,
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline,
517         uint8 v,
518         bytes32 r,
519         bytes32 s,
520         uint toChainID
521     ) external virtual ensure(deadline) {
522         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
523         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
524         AnyswapV1ERC20(path[0]).burn(from, amountIn);
525         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
526     }
527 
528     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
529     // Triggered by `anySwapOutExactTokensForNative`
530     function anySwapInExactTokensForNative(
531         bytes32 txs,
532         uint amountIn,
533         uint amountOutMin,
534         address[] calldata path,
535         address to,
536         uint deadline,
537         uint fromChainID
538     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
539         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
540         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
541         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
542         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
543         _swap(amounts, path, address(this));
544         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
545         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
546     }
547 
548     // **** LIBRARY FUNCTIONS ****
549     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
550         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
551     }
552 
553     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
554         public
555         pure
556         virtual
557         returns (uint amountOut)
558     {
559         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
560     }
561 
562     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
563         public
564         pure
565         virtual
566         returns (uint amountIn)
567     {
568         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
569     }
570 
571     function getAmountsOut(uint amountIn, address[] memory path)
572         public
573         view
574         virtual
575         returns (uint[] memory amounts)
576     {
577         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
578     }
579 
580     function getAmountsIn(uint amountOut, address[] memory path)
581         public
582         view
583         virtual
584         returns (uint[] memory amounts)
585     {
586         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
587     }
588 }