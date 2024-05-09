1 /**
2  *Submitted for verification at BscScan.com on 2021-04-15
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-04-08
7 */
8 
9 /**
10  *Submitted for verification at hecoinfo.com on 2021-04-08
11 */
12 
13 // SPDX-License-Identifier: GPL-3.0-or-later
14 
15 pragma solidity >=0.8.0;
16 
17 interface ISushiswapV2Pair {
18     function factory() external view returns (address);
19     function token0() external view returns (address);
20     function token1() external view returns (address);
21     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
22     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
23 }
24 
25 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
26 
27 library SafeMathSushiswap {
28     function add(uint x, uint y) internal pure returns (uint z) {
29         require((z = x + y) >= x, 'ds-math-add-overflow');
30     }
31 
32     function sub(uint x, uint y) internal pure returns (uint z) {
33         require((z = x - y) <= x, 'ds-math-sub-underflow');
34     }
35 
36     function mul(uint x, uint y) internal pure returns (uint z) {
37         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
38     }
39 }
40 
41 library SushiswapV2Library {
42     using SafeMathSushiswap for uint;
43 
44     // returns sorted token addresses, used to handle return values from pairs sorted in this order
45     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
46         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
47         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
48         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
49     }
50 
51     // calculates the CREATE2 address for a pair without making any external calls
52     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
53         (address token0, address token1) = sortTokens(tokenA, tokenB);
54         pair = address(uint160(uint256(keccak256(abi.encodePacked(
55                 hex'ff',
56                 factory,
57                 keccak256(abi.encodePacked(token0, token1)),
58                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
59             )))));
60     }
61 
62     // fetches and sorts the reserves for a pair
63     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
64         (address token0,) = sortTokens(tokenA, tokenB);
65         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
66         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
67     }
68 
69     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
70     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
71         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
72         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
73         amountB = amountA.mul(reserveB) / reserveA;
74     }
75 
76     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
77     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
78         require(amountIn > 0, 'SushiswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
79         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
80         uint amountInWithFee = amountIn.mul(997);
81         uint numerator = amountInWithFee.mul(reserveOut);
82         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
83         amountOut = numerator / denominator;
84     }
85 
86     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
87     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
88         require(amountOut > 0, 'SushiswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
89         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
90         uint numerator = reserveIn.mul(amountOut).mul(1000);
91         uint denominator = reserveOut.sub(amountOut).mul(997);
92         amountIn = (numerator / denominator).add(1);
93     }
94 
95     // performs chained getAmountOut calculations on any number of pairs
96     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
97         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
98         amounts = new uint[](path.length);
99         amounts[0] = amountIn;
100         for (uint i; i < path.length - 1; i++) {
101             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
102             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
103         }
104     }
105 
106     // performs chained getAmountIn calculations on any number of pairs
107     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
108         require(path.length >= 2, 'SushiswapV2Library: INVALID_PATH');
109         amounts = new uint[](path.length);
110         amounts[amounts.length - 1] = amountOut;
111         for (uint i = path.length - 1; i > 0; i--) {
112             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
113             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
114         }
115     }
116 }
117 
118 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
119 library TransferHelper {
120     function safeApprove(address token, address to, uint value) internal {
121         // bytes4(keccak256(bytes('approve(address,uint256)')));
122         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
123         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
124     }
125 
126     function safeTransfer(address token, address to, uint value) internal {
127         // bytes4(keccak256(bytes('transfer(address,uint256)')));
128         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
129         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
130     }
131 
132     function safeTransferFrom(address token, address from, address to, uint value) internal {
133         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
134         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
135         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
136     }
137 
138     function safeTransferNative(address to, uint value) internal {
139         (bool success,) = to.call{value:value}(new bytes(0));
140         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
141     }
142 }
143 
144 interface IwNATIVE {
145     function deposit() external payable;
146     function transfer(address to, uint value) external returns (bool);
147     function withdraw(uint) external;
148 }
149 
150 interface AnyswapV1ERC20 {
151     function mint(address to, uint256 amount) external returns (bool);
152     function burn(address from, uint256 amount) external returns (bool);
153     function changeVault(address newVault) external returns (bool);
154     function depositVault(uint amount, address to) external returns (uint);
155     function withdrawVault(address from, uint amount, address to) external returns (uint);
156     function underlying() external view returns (address);
157 }
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP.
161  */
162 interface IERC20 {
163     function totalSupply() external view returns (uint256);
164     function balanceOf(address account) external view returns (uint256);
165     function transfer(address recipient, uint256 amount) external returns (bool);
166     function allowance(address owner, address spender) external view returns (uint256);
167     function approve(address spender, uint256 amount) external returns (bool);
168     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
169     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
170     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
171 
172     event Transfer(address indexed from, address indexed to, uint256 value);
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 contract AnyswapV4Router {
177     using SafeMathSushiswap for uint;
178 
179     address public immutable factory;
180     address public immutable wNATIVE;
181 
182     modifier ensure(uint deadline) {
183         require(deadline >= block.timestamp, 'AnyswapV3Router: EXPIRED');
184         _;
185     }
186 
187     constructor(address _factory, address _wNATIVE, address _mpc) {
188         _newMPC = _mpc;
189         _newMPCEffectiveTime = block.timestamp;
190         factory = _factory;
191         wNATIVE = _wNATIVE;
192     }
193 
194     receive() external payable {
195         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
196     }
197 
198     address private _oldMPC;
199     address private _newMPC;
200     uint256 private _newMPCEffectiveTime;
201 
202 
203     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
204     event LogChangeRouter(address indexed oldRouter, address indexed newRouter, uint chainID);
205     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
206     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
207     event LogAnySwapTradeTokensForTokens(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
208     event LogAnySwapTradeTokensForNative(address[] path, address indexed from, address indexed to, uint amountIn, uint amountOutMin, uint fromChainID, uint toChainID);
209 
210     modifier onlyMPC() {
211         require(msg.sender == mpc(), "AnyswapV3Router: FORBIDDEN");
212         _;
213     }
214 
215     function mpc() public view returns (address) {
216         if (block.timestamp >= _newMPCEffectiveTime) {
217             return _newMPC;
218         }
219         return _oldMPC;
220     }
221 
222     function cID() public view returns (uint id) {
223         assembly {id := chainid()}
224     }
225 
226     function changeMPC(address newMPC) public onlyMPC returns (bool) {
227         require(newMPC != address(0), "AnyswapV3Router: address(0x0)");
228         _oldMPC = mpc();
229         _newMPC = newMPC;
230         _newMPCEffectiveTime = block.timestamp + 2*24*3600;
231         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
232         return true;
233     }
234 
235     function changeVault(address token, address newVault) public onlyMPC returns (bool) {
236         require(newVault != address(0), "AnyswapV3Router: address(0x0)");
237         return AnyswapV1ERC20(token).changeVault(newVault);
238     }
239 
240     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
241         AnyswapV1ERC20(token).burn(from, amount);
242         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
243     }
244 
245     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
246     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
247         _anySwapOut(msg.sender, token, to, amount, toChainID);
248     }
249 
250     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
251     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
252         TransferHelper.safeTransferFrom(AnyswapV1ERC20(token).underlying(), msg.sender, token, amount);
253         AnyswapV1ERC20(token).depositVault(amount, msg.sender);
254         _anySwapOut(msg.sender, token, to, amount, toChainID);
255     }
256 
257     function anySwapOutUnderlyingWithPermit(
258         address from,
259         address token,
260         address to,
261         uint amount,
262         uint deadline,
263         uint8 v,
264         bytes32 r,
265         bytes32 s,
266         uint toChainID
267     ) external {
268         address _underlying = AnyswapV1ERC20(token).underlying();
269         IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
270         TransferHelper.safeTransferFrom(_underlying, from, token, amount);
271         AnyswapV1ERC20(token).depositVault(amount, from);
272         _anySwapOut(from, token, to, amount, toChainID);
273     }
274 
275     function anySwapOutUnderlyingWithTransferPermit(
276         address from,
277         address token,
278         address to,
279         uint amount,
280         uint deadline,
281         uint8 v,
282         bytes32 r,
283         bytes32 s,
284         uint toChainID
285     ) external {
286         IERC20(AnyswapV1ERC20(token).underlying()).transferWithPermit(from, token, amount, deadline, v, r, s);
287         AnyswapV1ERC20(token).depositVault(amount, from);
288         _anySwapOut(from, token, to, amount, toChainID);
289     }
290 
291     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
292         for (uint i = 0; i < tokens.length; i++) {
293             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
294         }
295     }
296 
297     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
298     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
299         AnyswapV1ERC20(token).mint(to, amount);
300         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
301     }
302 
303     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
304     // triggered by `anySwapOut`
305     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
306         _anySwapIn(txs, token, to, amount, fromChainID);
307     }
308 
309     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
310     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
311         _anySwapIn(txs, token, to, amount, fromChainID);
312         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
313     }
314 
315     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
316     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
317         _anySwapIn(txs, token, to, amount, fromChainID);
318         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
319         address _underlying = _anyToken.underlying();
320         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
321             _anyToken.withdrawVault(to, amount, to);
322         }
323     }
324 
325     // extracts mpc fee from bridge fees
326     function anySwapFeeTo(address token, uint amount) external onlyMPC {
327         address _mpc = mpc();
328         AnyswapV1ERC20(token).mint(_mpc, amount);
329         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
330     }
331 
332     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
333         for (uint i = 0; i < tokens.length; i++) {
334             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
335         }
336     }
337 
338     // **** SWAP ****
339     // requires the initial amount to have already been sent to the first pair
340     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
341         for (uint i; i < path.length - 1; i++) {
342             (address input, address output) = (path[i], path[i + 1]);
343             (address token0,) = SushiswapV2Library.sortTokens(input, output);
344             uint amountOut = amounts[i + 1];
345             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
346             address to = i < path.length - 2 ? SushiswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
347             ISushiswapV2Pair(SushiswapV2Library.pairFor(factory, input, output)).swap(
348                 amount0Out, amount1Out, to, new bytes(0)
349             );
350         }
351     }
352 
353     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
354     function anySwapOutExactTokensForTokens(
355         uint amountIn,
356         uint amountOutMin,
357         address[] calldata path,
358         address to,
359         uint deadline,
360         uint toChainID
361     ) external virtual ensure(deadline) {
362         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
363         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
364     }
365 
366     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
367     function anySwapOutExactTokensForTokensUnderlying(
368         uint amountIn,
369         uint amountOutMin,
370         address[] calldata path,
371         address to,
372         uint deadline,
373         uint toChainID
374     ) external virtual ensure(deadline) {
375         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
376         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
377         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
378         emit LogAnySwapTradeTokensForTokens(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
379     }
380 
381     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
382     function anySwapOutExactTokensForTokensUnderlyingWithPermit(
383         address from,
384         uint amountIn,
385         uint amountOutMin,
386         address[] calldata path,
387         address to,
388         uint deadline,
389         uint8 v,
390         bytes32 r,
391         bytes32 s,
392         uint toChainID
393     ) external virtual ensure(deadline) {
394         address _underlying = AnyswapV1ERC20(path[0]).underlying();
395         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
396         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
397         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
398         AnyswapV1ERC20(path[0]).burn(from, amountIn);
399         {
400         address[] memory _path = path;
401         address _from = from;
402         address _to = to;
403         uint _amountIn = amountIn;
404         uint _amountOutMin = amountOutMin;
405         uint _cID = cID();
406         uint _toChainID = toChainID;
407         emit LogAnySwapTradeTokensForTokens(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
408         }
409     }
410 
411     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
412     function anySwapOutExactTokensForTokensUnderlyingWithTransferPermit(
413         address from,
414         uint amountIn,
415         uint amountOutMin,
416         address[] calldata path,
417         address to,
418         uint deadline,
419         uint8 v,
420         bytes32 r,
421         bytes32 s,
422         uint toChainID
423     ) external virtual ensure(deadline) {
424         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
425         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
426         AnyswapV1ERC20(path[0]).burn(from, amountIn);
427         emit LogAnySwapTradeTokensForTokens(path, from, to, amountIn, amountOutMin, cID(), toChainID);
428     }
429 
430     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
431     // Triggered by `anySwapOutExactTokensForTokens`
432     function anySwapInExactTokensForTokens(
433         bytes32 txs,
434         uint amountIn,
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline,
439         uint fromChainID
440     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
441         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
442         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
443         _anySwapIn(txs, path[0], SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
444         _swap(amounts, path, to);
445     }
446 
447     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
448     function anySwapOutExactTokensForNative(
449         uint amountIn,
450         uint amountOutMin,
451         address[] calldata path,
452         address to,
453         uint deadline,
454         uint toChainID
455     ) external virtual ensure(deadline) {
456         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
457         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
458     }
459 
460     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
461     function anySwapOutExactTokensForNativeUnderlying(
462         uint amountIn,
463         uint amountOutMin,
464         address[] calldata path,
465         address to,
466         uint deadline,
467         uint toChainID
468     ) external virtual ensure(deadline) {
469         TransferHelper.safeTransferFrom(AnyswapV1ERC20(path[0]).underlying(), msg.sender, path[0], amountIn);
470         AnyswapV1ERC20(path[0]).depositVault(amountIn, msg.sender);
471         AnyswapV1ERC20(path[0]).burn(msg.sender, amountIn);
472         emit LogAnySwapTradeTokensForNative(path, msg.sender, to, amountIn, amountOutMin, cID(), toChainID);
473     }
474 
475     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
476     function anySwapOutExactTokensForNativeUnderlyingWithPermit(
477         address from,
478         uint amountIn,
479         uint amountOutMin,
480         address[] calldata path,
481         address to,
482         uint deadline,
483         uint8 v,
484         bytes32 r,
485         bytes32 s,
486         uint toChainID
487     ) external virtual ensure(deadline) {
488         address _underlying = AnyswapV1ERC20(path[0]).underlying();
489         IERC20(_underlying).permit(from, address(this), amountIn, deadline, v, r, s);
490         TransferHelper.safeTransferFrom(_underlying, from, path[0], amountIn);
491         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
492         AnyswapV1ERC20(path[0]).burn(from, amountIn);
493         {
494         address[] memory _path = path;
495         address _from = from;
496         address _to = to;
497         uint _amountIn = amountIn;
498         uint _amountOutMin = amountOutMin;
499         uint _cID = cID();
500         uint _toChainID = toChainID;
501         emit LogAnySwapTradeTokensForNative(_path, _from, _to, _amountIn, _amountOutMin, _cID, _toChainID);
502         }
503     }
504 
505     // sets up a cross-chain trade from this chain to `toChainID` for `path` trades to `to`
506     function anySwapOutExactTokensForNativeUnderlyingWithTransferPermit(
507         address from,
508         uint amountIn,
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline,
513         uint8 v,
514         bytes32 r,
515         bytes32 s,
516         uint toChainID
517     ) external virtual ensure(deadline) {
518         IERC20(AnyswapV1ERC20(path[0]).underlying()).transferWithPermit(from, path[0], amountIn, deadline, v, r, s);
519         AnyswapV1ERC20(path[0]).depositVault(amountIn, from);
520         AnyswapV1ERC20(path[0]).burn(from, amountIn);
521         emit LogAnySwapTradeTokensForNative(path, from, to, amountIn, amountOutMin, cID(), toChainID);
522     }
523 
524     // Swaps `amounts[path.length-1]` `path[path.length-1]` to `to` on this chain
525     // Triggered by `anySwapOutExactTokensForNative`
526     function anySwapInExactTokensForNative(
527         bytes32 txs,
528         uint amountIn,
529         uint amountOutMin,
530         address[] calldata path,
531         address to,
532         uint deadline,
533         uint fromChainID
534     ) external onlyMPC virtual ensure(deadline) returns (uint[] memory amounts) {
535         require(path[path.length - 1] == wNATIVE, 'AnyswapV3Router: INVALID_PATH');
536         amounts = SushiswapV2Library.getAmountsOut(factory, amountIn, path);
537         require(amounts[amounts.length - 1] >= amountOutMin, 'AnyswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
538         _anySwapIn(txs, path[0],  SushiswapV2Library.pairFor(factory, path[0], path[1]), amounts[0], fromChainID);
539         _swap(amounts, path, address(this));
540         IwNATIVE(wNATIVE).withdraw(amounts[amounts.length - 1]);
541         TransferHelper.safeTransferNative(to, amounts[amounts.length - 1]);
542     }
543 
544     // **** LIBRARY FUNCTIONS ****
545     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
546         return SushiswapV2Library.quote(amountA, reserveA, reserveB);
547     }
548 
549     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
550         public
551         pure
552         virtual
553         returns (uint amountOut)
554     {
555         return SushiswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
556     }
557 
558     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
559         public
560         pure
561         virtual
562         returns (uint amountIn)
563     {
564         return SushiswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
565     }
566 
567     function getAmountsOut(uint amountIn, address[] memory path)
568         public
569         view
570         virtual
571         returns (uint[] memory amounts)
572     {
573         return SushiswapV2Library.getAmountsOut(factory, amountIn, path);
574     }
575 
576     function getAmountsIn(uint amountOut, address[] memory path)
577         public
578         view
579         virtual
580         returns (uint[] memory amounts)
581     {
582         return SushiswapV2Library.getAmountsIn(factory, amountOut, path);
583     }
584 }