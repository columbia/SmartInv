1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
4 import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
5 
6 import './libraries/UniswapV2Library.sol';
7 import './interfaces/IUniswapV2Router01.sol';
8 import './interfaces/IERC20.sol';
9 import './interfaces/IWETH.sol';
10 
11 contract UniswapV2Router01 is IUniswapV2Router01 {
12     address public immutable override factory;
13     address public immutable override WETH;
14 
15     modifier ensure(uint deadline) {
16         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
17         _;
18     }
19 
20     constructor(address _factory, address _WETH) public {
21         factory = _factory;
22         WETH = _WETH;
23     }
24 
25     receive() external payable {
26         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
27     }
28 
29     // **** ADD LIQUIDITY ****
30     function _addLiquidity(
31         address tokenA,
32         address tokenB,
33         uint amountADesired,
34         uint amountBDesired,
35         uint amountAMin,
36         uint amountBMin
37     ) private returns (uint amountA, uint amountB) {
38         // create the pair if it doesn't exist yet
39         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
40             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
41         }
42         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
43         if (reserveA == 0 && reserveB == 0) {
44             (amountA, amountB) = (amountADesired, amountBDesired);
45         } else {
46             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
47             if (amountBOptimal <= amountBDesired) {
48                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
49                 (amountA, amountB) = (amountADesired, amountBOptimal);
50             } else {
51                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
52                 assert(amountAOptimal <= amountADesired);
53                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
54                 (amountA, amountB) = (amountAOptimal, amountBDesired);
55             }
56         }
57     }
58     function addLiquidity(
59         address tokenA,
60         address tokenB,
61         uint amountADesired,
62         uint amountBDesired,
63         uint amountAMin,
64         uint amountBMin,
65         address to,
66         uint deadline
67     ) external override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
68         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
69         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
70         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
71         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
72         liquidity = IUniswapV2Pair(pair).mint(to);
73     }
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
82         (amountToken, amountETH) = _addLiquidity(
83             token,
84             WETH,
85             amountTokenDesired,
86             msg.value,
87             amountTokenMin,
88             amountETHMin
89         );
90         address pair = UniswapV2Library.pairFor(factory, token, WETH);
91         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
92         IWETH(WETH).deposit{value: amountETH}();
93         assert(IWETH(WETH).transfer(pair, amountETH));
94         liquidity = IUniswapV2Pair(pair).mint(to);
95         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH); // refund dust eth, if any
96     }
97 
98     // **** REMOVE LIQUIDITY ****
99     function removeLiquidity(
100         address tokenA,
101         address tokenB,
102         uint liquidity,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline
107     ) public override ensure(deadline) returns (uint amountA, uint amountB) {
108         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
109         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
110         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
111         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
112         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
113         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
114         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
115     }
116     function removeLiquidityETH(
117         address token,
118         uint liquidity,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) public override ensure(deadline) returns (uint amountToken, uint amountETH) {
124         (amountToken, amountETH) = removeLiquidity(
125             token,
126             WETH,
127             liquidity,
128             amountTokenMin,
129             amountETHMin,
130             address(this),
131             deadline
132         );
133         TransferHelper.safeTransfer(token, to, amountToken);
134         IWETH(WETH).withdraw(amountETH);
135         TransferHelper.safeTransferETH(to, amountETH);
136     }
137     function removeLiquidityWithPermit(
138         address tokenA,
139         address tokenB,
140         uint liquidity,
141         uint amountAMin,
142         uint amountBMin,
143         address to,
144         uint deadline,
145         bool approveMax, uint8 v, bytes32 r, bytes32 s
146     ) external override returns (uint amountA, uint amountB) {
147         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
148         uint value = approveMax ? uint(-1) : liquidity;
149         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
150         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
151     }
152     function removeLiquidityETHWithPermit(
153         address token,
154         uint liquidity,
155         uint amountTokenMin,
156         uint amountETHMin,
157         address to,
158         uint deadline,
159         bool approveMax, uint8 v, bytes32 r, bytes32 s
160     ) external override returns (uint amountToken, uint amountETH) {
161         address pair = UniswapV2Library.pairFor(factory, token, WETH);
162         uint value = approveMax ? uint(-1) : liquidity;
163         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
164         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
165     }
166 
167     // **** SWAP ****
168     // requires the initial amount to have already been sent to the first pair
169     function _swap(uint[] memory amounts, address[] memory path, address _to) private {
170         for (uint i; i < path.length - 1; i++) {
171             (address input, address output) = (path[i], path[i + 1]);
172             (address token0,) = UniswapV2Library.sortTokens(input, output);
173             uint amountOut = amounts[i + 1];
174             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
175             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
176             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
177         }
178     }
179     function swapExactTokensForTokens(
180         uint amountIn,
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external override ensure(deadline) returns (uint[] memory amounts) {
186         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
187         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
188         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
189         _swap(amounts, path, to);
190     }
191     function swapTokensForExactTokens(
192         uint amountOut,
193         uint amountInMax,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external override ensure(deadline) returns (uint[] memory amounts) {
198         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
199         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
200         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
201         _swap(amounts, path, to);
202     }
203     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
204         external
205         override
206         payable
207         ensure(deadline)
208         returns (uint[] memory amounts)
209     {
210         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
211         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
212         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
213         IWETH(WETH).deposit{value: amounts[0]}();
214         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
215         _swap(amounts, path, to);
216     }
217     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
218         external
219         override
220         ensure(deadline)
221         returns (uint[] memory amounts)
222     {
223         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
224         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
225         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
226         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
227         _swap(amounts, path, address(this));
228         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
229         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
230     }
231     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
232         external
233         override
234         ensure(deadline)
235         returns (uint[] memory amounts)
236     {
237         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
238         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
239         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
240         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
241         _swap(amounts, path, address(this));
242         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
243         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
244     }
245     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
246         external
247         override
248         payable
249         ensure(deadline)
250         returns (uint[] memory amounts)
251     {
252         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
253         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
254         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
255         IWETH(WETH).deposit{value: amounts[0]}();
256         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
257         _swap(amounts, path, to);
258         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]); // refund dust eth, if any
259     }
260 
261     function quote(uint amountA, uint reserveA, uint reserveB) public pure override returns (uint amountB) {
262         return UniswapV2Library.quote(amountA, reserveA, reserveB);
263     }
264 
265     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure override returns (uint amountOut) {
266         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
267     }
268 
269     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public pure override returns (uint amountIn) {
270         return UniswapV2Library.getAmountOut(amountOut, reserveIn, reserveOut);
271     }
272 
273     function getAmountsOut(uint amountIn, address[] memory path) public view override returns (uint[] memory amounts) {
274         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
275     }
276 
277     function getAmountsIn(uint amountOut, address[] memory path) public view override returns (uint[] memory amounts) {
278         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
279     }
280 }
