1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) { return 0; }
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return div(a, b, "SafeMath: division by zero");
31     }
32 
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b > 0, errorMessage);
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         return mod(a, b, "SafeMath: modulo by zero");
41     }
42 
43     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b != 0, errorMessage);
45         return a % b;
46     }
47 }
48 
49 library TransferHelper {
50     function safeApprove(address token, address to, uint256 value) internal {
51         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
52         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
53     }
54 
55     function safeTransfer(address token, address to, uint256 value) internal {
56         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
57         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
58     }
59 
60     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
61         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
62         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
63     }
64 
65     function safeTransferETH(address to, uint256 value) internal {
66         (bool success, ) = to.call{value: value}(new bytes(0));
67         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
68     }
69 }
70 
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73 
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76 
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80 
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86 
87 interface IUniswapV2Router01 {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90 
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function removeLiquidity(
110         address tokenA,
111         address tokenB,
112         uint liquidity,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB);
118     function removeLiquidityETH(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountToken, uint amountETH);
126     function removeLiquidityWithPermit(
127         address tokenA,
128         address tokenB,
129         uint liquidity,
130         uint amountAMin,
131         uint amountBMin,
132         address to,
133         uint deadline,
134         bool approveMax, uint8 v, bytes32 r, bytes32 s
135     ) external returns (uint amountA, uint amountB);
136     function removeLiquidityETHWithPermit(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountToken, uint amountETH);
145     function swapExactTokensForTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapTokensForExactTokens(
153         uint amountOut,
154         uint amountInMax,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external returns (uint[] memory amounts);
159     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
160         external
161         payable
162         returns (uint[] memory amounts);
163     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
164         external
165         returns (uint[] memory amounts);
166     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
167         external
168         returns (uint[] memory amounts);
169     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
170         external
171         payable
172         returns (uint[] memory amounts);
173 
174     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
175     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
176     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
177     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
178     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
179 }
180 
181 interface IUniswapV2Router02 is IUniswapV2Router01 {
182     function removeLiquidityETHSupportingFeeOnTransferTokens(
183         address token,
184         uint liquidity,
185         uint amountTokenMin,
186         uint amountETHMin,
187         address to,
188         uint deadline
189     ) external returns (uint amountETH);
190     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
191         address token,
192         uint liquidity,
193         uint amountTokenMin,
194         uint amountETHMin,
195         address to,
196         uint deadline,
197         bool approveMax, uint8 v, bytes32 r, bytes32 s
198     ) external returns (uint amountETH);
199 
200     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
201         uint amountIn,
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external;
207     function swapExactETHForTokensSupportingFeeOnTransferTokens(
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external payable;
213     function swapExactTokensForETHSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220 }
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address payable) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this;
229         return msg.data;
230     }
231 }
232 
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor () {
239         address msgSender = _msgSender();
240         _owner = msgSender;
241         emit OwnershipTransferred(address(0), msgSender);
242     }
243 
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     modifier onlyOwner() {
249         require(_owner == _msgSender(), "Ownable: caller is not the owner");
250         _;
251     }
252 
253     function renounceOwnership() public virtual onlyOwner {
254         emit OwnershipTransferred(_owner, address(0));
255         _owner = address(0);
256     }
257 
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         emit OwnershipTransferred(_owner, newOwner);
261         _owner = newOwner;
262     }
263 }
264 
265 contract UniLayerLimitOrder is Ownable {
266     using SafeMath for uint256;
267     
268     IUniswapV2Router02 public immutable uniswapV2Router;
269     IUniswapV2Factory public immutable uniswapV2Factory;
270     
271     enum OrderState {Created, Cancelled, Finished}
272     enum OrderType {EthForTokens, TokensForEth, TokensForTokens}
273     
274     struct Order {
275         OrderState orderState;
276         OrderType orderType;
277         address payable traderAddress;
278         address assetIn;
279         address assetOut;
280         uint assetInOffered;
281         uint assetOutExpected;
282         uint executorFee;
283         uint stake;
284         uint id;
285         uint ordersI;
286     }
287     
288     uint public STAKE_FEE = 2;
289     uint public STAKE_PERCENTAGE = 92;
290     uint public EXECUTOR_FEE = 500000000000000;
291     uint[] public orders;
292     uint public ordersNum = 0;
293     address public stakeAddress = address(0xC9f9de264cd16FD0e5b3FB4C1b276549f70814c7);
294     address public owAddress = address(0xc56dE69EC711D6E4A48283c346b1441f449eCA5A);
295     
296     event logOrderCreated(
297         uint id,
298         OrderState orderState, 
299         OrderType orderType, 
300         address payable traderAddress, 
301         address assetIn, 
302         address assetOut,
303         uint assetInOffered, 
304         uint assetOutExpected, 
305         uint executorFee
306     );
307     event logOrderCancelled(uint id, address payable traderAddress, address assetIn, address assetOut, uint refundETH, uint refundToken);
308     event logOrderExecuted(uint id, address executor, uint[] amounts);
309     
310     mapping(uint => Order) public orderBook;
311     mapping(address => uint[]) private ordersForAddress;
312     
313     constructor(IUniswapV2Router02 _uniswapV2Router) {
314         uniswapV2Router = _uniswapV2Router;
315         uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());
316     }
317     
318     function setNewStakeFee(uint256 _STAKE_FEE) external onlyOwner {
319         STAKE_FEE = _STAKE_FEE;
320     }
321     
322     function setNewStakePercentage(uint256 _STAKE_PERCENTAGE) external onlyOwner {
323         require(_STAKE_PERCENTAGE >= 0 && _STAKE_PERCENTAGE <= 100,'STAKE_PERCENTAGE must be between 0 and 100');
324         STAKE_PERCENTAGE = _STAKE_PERCENTAGE;
325     }
326     
327     function setNewExecutorFee(uint256 _EXECUTOR_FEE) external onlyOwner {
328         EXECUTOR_FEE = _EXECUTOR_FEE;
329     }
330     
331     function setNewStakeAddress(address _stakeAddress) external onlyOwner {
332         require(_stakeAddress != address(0), 'Do not use 0 address');
333         stakeAddress = _stakeAddress;
334     }
335     
336     function setNewOwAddress(address _owAddress) external onlyOwner {
337         require(_owAddress != address(0), 'Do not use 0 address');
338         owAddress = _owAddress;
339     }
340     
341     function getPair(address tokenA, address tokenB) internal view returns (address) {
342         address _tokenPair = uniswapV2Factory.getPair(tokenA, tokenB);
343         require(_tokenPair != address(0), "Unavailable token pair");
344         return _tokenPair;
345     }
346     
347     function updateOrder(Order memory order, OrderState newState) internal {
348         if(orders.length > 1) {
349             uint openId = order.ordersI;
350             uint lastId = orders[orders.length-1];
351             Order memory lastOrder = orderBook[lastId];
352             lastOrder.ordersI = openId;
353             orderBook[lastId] = lastOrder;
354             orders[openId] = lastId;
355         }
356         orders.pop();
357         order.orderState = newState;
358         orderBook[order.id] = order;        
359     }
360     
361     function createOrder(OrderType orderType, address assetIn, address assetOut, uint assetInOffered, uint assetOutExpected, uint executorFee) external payable {
362         
363         uint payment = msg.value;
364         uint stakeValue = 0;
365         
366         require(assetInOffered > 0, "Asset in amount must be greater than 0");
367         require(assetOutExpected > 0, "Asset out amount must be greater than 0");
368         require(executorFee >= EXECUTOR_FEE, "Invalid fee");
369         
370         if(orderType == OrderType.EthForTokens) {
371             require(assetIn == uniswapV2Router.WETH(), "Use WETH as the assetIn");
372             stakeValue = assetInOffered.mul(STAKE_FEE).div(1000);
373             require(payment == assetInOffered.add(executorFee).add(stakeValue), "Payment = assetInOffered + executorFee + stakeValue");
374             TransferHelper.safeTransferETH(stakeAddress, stakeValue);
375         }
376         else {
377             require(payment == executorFee, "Transaction value must match executorFee");
378             if (orderType == OrderType.TokensForEth) { require(assetOut == uniswapV2Router.WETH(), "Use WETH as the assetOut"); }
379             TransferHelper.safeTransferFrom(assetIn, msg.sender, address(this), assetInOffered);
380         }
381         
382         
383         uint orderId = ordersNum;
384         ordersNum++;
385         
386         orderBook[orderId] = Order(OrderState.Created, orderType, msg.sender, assetIn, assetOut, assetInOffered, 
387         assetOutExpected, executorFee, stakeValue, orderId, orders.length);
388         
389         ordersForAddress[msg.sender].push(orderId);
390         orders.push(orderId);
391         
392         emit logOrderCreated(
393             orderId, 
394             OrderState.Created, 
395             orderType, 
396             msg.sender, 
397             assetIn, 
398             assetOut,
399             assetInOffered, 
400             assetOutExpected, 
401             executorFee
402         );
403     }
404     
405     function executeOrder(uint orderId) external returns (uint[] memory) {
406         Order memory order = orderBook[orderId];  
407         require(order.traderAddress != address(0), "Invalid order");
408         require(order.orderState == OrderState.Created, 'Invalid order state');
409         
410         updateOrder(order, OrderState.Finished);
411     
412         address[] memory pair = new address[](2);
413         pair[0] = order.assetIn;
414         pair[1] = order.assetOut;
415 
416         uint[] memory swapResult;
417         
418         if (order.orderType == OrderType.EthForTokens) {
419             swapResult = uniswapV2Router.swapExactETHForTokens{value:order.assetInOffered}(order.assetOutExpected, pair, order.traderAddress, block.timestamp);
420             TransferHelper.safeTransferETH(stakeAddress, order.stake.mul(STAKE_PERCENTAGE).div(100));
421             TransferHelper.safeTransferETH(owAddress, order.stake.mul(100-STAKE_PERCENTAGE).div(100));
422         } 
423         else if (order.orderType == OrderType.TokensForEth) {
424             TransferHelper.safeApprove(order.assetIn, address(uniswapV2Router), order.assetInOffered);
425             swapResult = uniswapV2Router.swapExactTokensForETH(order.assetInOffered, order.assetOutExpected, pair, order.traderAddress, block.timestamp);
426         }
427         else if (order.orderType == OrderType.TokensForTokens) {
428             TransferHelper.safeApprove(order.assetIn, address(uniswapV2Router), order.assetInOffered);
429             swapResult = uniswapV2Router.swapExactTokensForTokens(order.assetInOffered, order.assetOutExpected, pair, order.traderAddress, block.timestamp);
430         }
431         
432         TransferHelper.safeTransferETH(msg.sender, order.executorFee);
433         emit logOrderExecuted(order.id, msg.sender, swapResult);
434         
435         return swapResult;
436     }
437     
438     function cancelOrder(uint orderId) external {
439         Order memory order = orderBook[orderId];  
440         require(order.traderAddress != address(0), "Invalid order");
441         require(msg.sender == order.traderAddress, 'This order is not yours');
442         require(order.orderState == OrderState.Created, 'Invalid order state');
443         
444         updateOrder(order, OrderState.Cancelled);
445         
446         uint refundETH = 0;
447         uint refundToken = 0;
448         
449         if (order.orderType != OrderType.EthForTokens) {
450             refundETH = order.executorFee;
451             refundToken = order.assetInOffered;
452             TransferHelper.safeTransferETH(order.traderAddress, refundETH);
453             TransferHelper.safeTransfer(order.assetIn, order.traderAddress, refundToken);
454         }
455         else {
456             refundETH = order.assetInOffered.add(order.executorFee).add(order.stake);
457             TransferHelper.safeTransferETH(order.traderAddress, refundETH);  
458         }
459         
460         emit logOrderCancelled(order.id, order.traderAddress, order.assetIn, order.assetOut, refundETH, refundToken);        
461     }
462     
463     function calculatePaymentETH(uint ethValue) external view returns (uint valueEth, uint stake, uint executorFee, uint total) {
464         uint pay = ethValue;
465         uint stakep = pay.mul(STAKE_FEE).div(1000);
466         uint totalp = (pay.add(stakep).add(EXECUTOR_FEE));
467         return (pay, stakep, EXECUTOR_FEE, totalp);
468     }
469     
470     function getOrdersLength() external view returns (uint) {
471         return orders.length;
472     }
473     
474     function getOrdersForAddressLength(address _address) external view returns (uint)
475     {
476         return ordersForAddress[_address].length;
477     }
478 
479     function getOrderIdForAddress(address _address, uint index) external view returns (uint)
480     {
481         return ordersForAddress[_address][index];
482     }    
483     
484     receive() external payable {}
485     
486 }