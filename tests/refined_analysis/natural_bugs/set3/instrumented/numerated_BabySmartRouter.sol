1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../libraries/BabyLibrarySmartRouter.sol";
7 import "../interfaces/IBabySmartRouter.sol";
8 import "../libraries/TransferHelper.sol";
9 import "../interfaces/ISwapMining.sol";
10 import "../interfaces/IERC20.sol";
11 import "../interfaces/IWETH.sol";
12 import "./BabyBaseRouter.sol";
13 import "hardhat/console.sol";
14 
15 contract BabySmartRouter is BabyBaseRouter, IBabySmartRouter {
16     using SafeMath for uint;
17 
18     address immutable public normalRouter;
19 
20     constructor(
21         address _factory, 
22         address _WETH, 
23         address _swapMining, 
24         address _routerFeeReceiver,
25         address _normalRouter
26     ) BabyBaseRouter(_factory, _WETH, _swapMining, _routerFeeReceiver) {
27         normalRouter = _normalRouter;
28     }
29 
30     function routerFee(address _factory, address _user, address _token, uint _amount) internal returns (uint) {
31         if (routerFeeReceiver != address(0) && _factory == factory) {
32             uint fee = _amount.mul(1).div(1000);
33             if (fee > 0) {
34                 if (_user == address(this)) {
35                     TransferHelper.safeTransfer(_token, routerFeeReceiver, fee);
36                 } else {
37                     TransferHelper.safeTransferFrom(
38                         _token, msg.sender, routerFeeReceiver, fee
39                     );
40                 }
41                 _amount = _amount.sub(fee);
42             }
43         }
44         return _amount;
45     }
46 
47     fallback() external payable {
48         babyRouterDelegateCall(msg.data);
49     }
50 
51     function babyRouterDelegateCall(bytes memory data) internal {
52         (bool success, ) = normalRouter.delegatecall(data);
53 
54         assembly {
55             let free_mem_ptr := mload(0x40)
56             returndatacopy(free_mem_ptr, 0, returndatasize())
57 
58             switch success
59             case 0 { revert(free_mem_ptr, returndatasize()) }
60             default { return(free_mem_ptr, returndatasize()) }
61         }
62     }
63 
64     function _swap(
65         uint[] memory amounts, 
66         address[] memory path, 
67         address[] memory factories, 
68         address _to
69     ) internal virtual {
70         for (uint i; i < path.length - 1; i++) {
71             (address input, address output) = (path[i], path[i + 1]);
72             (address token0,) = BabyLibrarySmartRouter.sortTokens(input, output);
73             uint amountOut = amounts[i + 1];
74             if (swapMining != address(0)) {
75                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOut);
76             }
77             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
78             address to = i < path.length - 2 ? address(this) : _to;
79             IBabyPair(BabyLibrarySmartRouter.pairFor(factories[i], input, output)).swap(
80                 amount0Out, amount1Out, to, new bytes(0)
81             );
82             if (i < path.length - 2) {
83                 amounts[i + 1] = routerFee(factories[i + 1], address(this), path[i + 1], amounts[i + 1]);
84                 TransferHelper.safeTransfer(path[i + 1], BabyLibrarySmartRouter.pairFor(factories[i + 1], output, path[i + 2]), amounts[i + 1]);
85             }
86         }
87     }
88 
89     function swapExactTokensForTokens(
90         uint amountIn,
91         uint amountOutMin,
92         address[] memory path,
93         address[] memory factories,
94         uint[] memory fees,
95         address to,
96         uint deadline
97     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
98         amounts = BabyLibrarySmartRouter.getAggregationAmountsOut(factories, fees, amountIn, path);
99         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
100         amounts[0] = routerFee(factories[0], msg.sender, path[0], amounts[0]);
101         TransferHelper.safeTransferFrom(
102             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]
103         );
104         _swap(amounts, path, factories, to);
105     }
106 
107     function swapTokensForExactTokens(
108         uint amountOut,
109         uint amountInMax,
110         address[] memory path,
111         address[] memory factories,
112         uint[] memory fees,
113         address to,
114         uint deadline
115     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
116         amounts = BabyLibrarySmartRouter.getAggregationAmountsIn(factories, fees, amountOut, path);
117         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
118         amounts[0] = routerFee(factories[0], msg.sender, path[0], amounts[0]);
119         TransferHelper.safeTransferFrom(
120             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]
121         );
122         _swap(amounts, path, factories, to);
123     }
124 
125     function swapExactETHForTokens(
126         uint amountOutMin, 
127         address[] memory path, 
128         address[] memory factories, 
129         uint[] memory fees, 
130         address to, 
131         uint deadline
132     ) external virtual override payable ensure(deadline) returns (uint[] memory amounts) {
133         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
134         amounts = BabyLibrarySmartRouter.getAggregationAmountsOut(factories, fees,  msg.value, path);
135         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
136         IWETH(WETH).deposit{value: amounts[0]}();
137         amounts[0] = routerFee(factories[0], address(this), path[0], amounts[0]);
138         assert(IWETH(WETH).transfer(BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]));
139         _swap(amounts, path, factories, to);
140     }
141 
142     function swapTokensForExactETH(
143         uint amountOut, 
144         uint amountInMax, 
145         address[] memory path, 
146         address[] memory factories, 
147         uint[] memory fees, 
148         address to, 
149         uint deadline
150     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
151         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
152         amounts = BabyLibrarySmartRouter.getAggregationAmountsIn(factories, fees, amountOut, path);
153         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
154         amounts[0] = routerFee(factories[0], msg.sender, path[0], amounts[0]);
155         TransferHelper.safeTransferFrom(
156             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]
157         );
158         _swap(amounts, path, factories, address(this));
159         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
160         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
161     }
162 
163     function swapExactTokensForETH(
164         uint amountIn, 
165         uint amountOutMin, 
166         address[] memory path, 
167         address[] memory factories, 
168         uint[] memory fees, 
169         address to, 
170         uint deadline
171     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
172         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
173         amounts = BabyLibrarySmartRouter.getAggregationAmountsOut(factories, fees, amountIn, path);
174         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
175         amounts[0] = routerFee(factories[0], msg.sender, path[0], amounts[0]);
176         TransferHelper.safeTransferFrom(
177             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]
178         );
179         _swap(amounts, path, factories, address(this));
180         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
181         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
182     }
183 
184     function swapETHForExactTokens(
185         uint amountOut, 
186         address[] memory path, 
187         address[] memory factories, 
188         uint[] memory fees, 
189         address to, 
190         uint deadline
191     ) external virtual override payable ensure(deadline) returns (uint[] memory amounts) {
192         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
193         amounts = BabyLibrarySmartRouter.getAggregationAmountsIn(factories, fees, amountOut, path);
194         require(amounts[0] <= msg.value, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
195         IWETH(WETH).deposit{value: amounts[0]}();
196         uint oldAmount = amounts[0];
197         amounts[0] = routerFee(factories[0], address(this), path[0], amounts[0]);
198         assert(IWETH(WETH).transfer(BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amounts[0]));
199         _swap(amounts, path, factories, to);
200         // refund dust eth, if any
201         if (msg.value > oldAmount) TransferHelper.safeTransferETH(msg.sender, msg.value.sub(oldAmount));
202     }
203 
204     function _swapSupportingFeeOnTransferTokens(
205         address[] memory path, 
206         address[] memory factories, 
207         uint[] memory fees, 
208         address _to
209     ) internal virtual {
210         for (uint i; i < path.length - 1; i++) {
211             (address input, address output) = (path[i], path[i + 1]);
212             (address token0,) = BabyLibrarySmartRouter.sortTokens(input, output);
213             IBabyPair pair = IBabyPair(BabyLibrarySmartRouter.pairFor(factories[i], input, output));
214             //uint amountInput;
215             //uint amountOutput;
216             uint[] memory amounts = new uint[](2);
217             { // scope to avoid stack too deep errors
218             (uint reserve0, uint reserve1,) = pair.getReserves();
219             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
220             amounts[0] = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
221             amounts[1] = BabyLibrarySmartRouter.getAmountOutWithFee(amounts[0], reserveInput, reserveOutput, fees[i]);
222             }
223             if (swapMining != address(0)) {
224                 ISwapMining(swapMining).swap(msg.sender, input, output, amounts[1]);
225             }
226             (amounts[0], amounts[1]) = input == token0 ? (uint(0), amounts[1]) : (amounts[1], uint(0));
227             address to = i < path.length - 2 ? address(this) : _to;
228             pair.swap(amounts[0], amounts[1], to, new bytes(0));
229             if (i < path.length - 2) {
230                 routerFee(factories[i + 1], address(this), output, IERC20(output).balanceOf(address(this)));
231                 TransferHelper.safeTransfer(path[i + 1], BabyLibrarySmartRouter.pairFor(factories[i + 1], output, path[i + 2]), IERC20(output).balanceOf(address(this)));
232             }
233         }
234     }
235 
236     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
237         uint amountIn,
238         uint amountOutMin,
239         address[] memory path,
240         address[] memory factories,
241         uint[] memory fees,
242         address to,
243         uint deadline
244     ) external virtual override ensure(deadline) {
245         amountIn = routerFee(factories[0], msg.sender, path[0], amountIn);
246         TransferHelper.safeTransferFrom(
247             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amountIn
248         );
249         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
250         _swapSupportingFeeOnTransferTokens(path, factories, fees,  to);
251         require(
252             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
253             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
254         );
255     }
256 
257     function swapExactETHForTokensSupportingFeeOnTransferTokens(
258         uint amountOutMin,
259         address[] memory path,
260         address[] memory factories,
261         uint[] memory fees,
262         address to,
263         uint deadline
264     ) external virtual override payable ensure(deadline) {
265         require(path[0] == WETH, 'BabyRouter');
266         uint amountIn = msg.value;
267         IWETH(WETH).deposit{value: amountIn}();
268         amountIn = routerFee(factories[0], address(this), path[0], amountIn);
269         assert(IWETH(WETH).transfer(BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amountIn));
270         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
271         _swapSupportingFeeOnTransferTokens(path, factories, fees, to);
272         uint balanceAfter = IERC20(path[path.length - 1]).balanceOf(to);
273         require(
274             balanceAfter.sub(balanceBefore) >= amountOutMin,
275             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
276         );
277     }
278     
279     function swapExactTokensForETHSupportingFeeOnTransferTokens(
280         uint amountIn,
281         uint amountOutMin,
282         address[] memory path,
283         address[] memory factories,
284         uint[] memory fees,
285         address to,
286         uint deadline
287     ) external virtual override ensure(deadline) {
288         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
289         amountIn = routerFee(factories[0], msg.sender, path[0], amountIn);
290         TransferHelper.safeTransferFrom(
291             path[0], msg.sender, BabyLibrarySmartRouter.pairFor(factories[0], path[0], path[1]), amountIn
292         );
293         _swapSupportingFeeOnTransferTokens(path, factories, fees, address(this));
294         uint amountOut = IERC20(WETH).balanceOf(address(this));
295         require(amountOut >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
296         IWETH(WETH).withdraw(amountOut);
297         TransferHelper.safeTransferETH(to, amountOut);
298     }
299 }
