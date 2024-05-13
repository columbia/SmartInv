1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 import "@openzeppelin/contracts/math/SafeMath.sol";
36 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
37 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
38 
39 import "../interfaces/IUniswapV2Pair.sol";
40 import "../interfaces/IUniswapV2Router02.sol";
41 import "../interfaces/IZap.sol";
42 import "../interfaces/IWETH.sol";
43 
44 
45 contract ZapETH is IZap, OwnableUpgradeable {
46     using SafeMath for uint;
47     using SafeERC20 for IERC20;
48 
49     /* ========== CONSTANT VARIABLES ========== */
50 
51     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
52     address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
53     address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
54     address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
55 
56     IUniswapV2Router02 private constant ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
57 
58     /* ========== STATE VARIABLES ========== */
59 
60     mapping(address => bool) private notLP;
61     mapping(address => address) private routePairAddresses;
62     address[] public tokens;
63 
64     /* ========== INITIALIZER ========== */
65 
66     function initialize() external initializer {
67         __Ownable_init();
68         require(owner() != address(0), "ZapETH: owner must be set");
69 
70         setNotLP(WETH);
71         setNotLP(USDT);
72         setNotLP(USDC);
73         setNotLP(DAI);
74     }
75 
76     receive() external payable {}
77 
78     /* ========== View Functions ========== */
79 
80     function isLP(address _address) public view returns (bool) {
81         return !notLP[_address];
82     }
83 
84     function routePair(address _address) external view returns(address) {
85         return routePairAddresses[_address];
86     }
87 
88     /* ========== External Functions ========== */
89 
90     function zapInToken(address _from, uint amount, address _to) external override {
91         IERC20(_from).safeTransferFrom(msg.sender, address(this), amount);
92         _approveTokenIfNeeded(_from);
93 
94         if (isLP(_to)) {
95             IUniswapV2Pair pair = IUniswapV2Pair(_to);
96             address token0 = pair.token0();
97             address token1 = pair.token1();
98             if (_from == token0 || _from == token1) {
99                 // swap half amount for other
100                 address other = _from == token0 ? token1 : token0;
101                 _approveTokenIfNeeded(other);
102                 uint sellAmount = amount.div(2);
103                 uint otherAmount = _swap(_from, sellAmount, other, address(this));
104                 ROUTER.addLiquidity(_from, other, amount.sub(sellAmount), otherAmount, 0, 0, msg.sender, block.timestamp);
105             } else {
106                 uint ethAmount = _swapTokenForETH(_from, amount, address(this));
107                 _swapETHToLP(_to, ethAmount, msg.sender);
108             }
109         } else {
110             _swap(_from, amount, _to, msg.sender);
111         }
112     }
113 
114     function zapIn(address _to) external payable override {
115         _swapETHToLP(_to, msg.value, msg.sender);
116     }
117 
118     function zapOut(address _from, uint amount) external override {
119         IERC20(_from).safeTransferFrom(msg.sender, address(this), amount);
120         _approveTokenIfNeeded(_from);
121 
122         if (!isLP(_from)) {
123             _swapTokenForETH(_from, amount, msg.sender);
124         } else {
125             IUniswapV2Pair pair = IUniswapV2Pair(_from);
126             address token0 = pair.token0();
127             address token1 = pair.token1();
128             if (token0 == WETH || token1 == WETH) {
129                 ROUTER.removeLiquidityETH(token0 != WETH ? token0 : token1, amount, 0, 0, msg.sender, block.timestamp);
130             } else {
131                 ROUTER.removeLiquidity(token0, token1, amount, 0, 0, msg.sender, block.timestamp);
132             }
133         }
134     }
135 
136     /* ========== Private Functions ========== */
137 
138     function _approveTokenIfNeeded(address token) private {
139         if (IERC20(token).allowance(address(this), address(ROUTER)) == 0) {
140             IERC20(token).safeApprove(address(ROUTER), uint(- 1));
141         }
142     }
143 
144     function _swapETHToLP(address lp, uint amount, address receiver) private {
145         if (!isLP(lp)) {
146             _swapETHForToken(lp, amount, receiver);
147         } else {
148             // lp
149             IUniswapV2Pair pair = IUniswapV2Pair(lp);
150             address token0 = pair.token0();
151             address token1 = pair.token1();
152             if (token0 == WETH || token1 == WETH) {
153                 address token = token0 == WETH ? token1 : token0;
154                 uint swapValue = amount.div(2);
155                 uint tokenAmount = _swapETHForToken(token, swapValue, address(this));
156 
157                 _approveTokenIfNeeded(token);
158                 ROUTER.addLiquidityETH{value : amount.sub(swapValue)}(token, tokenAmount, 0, 0, receiver, block.timestamp);
159             } else {
160                 uint swapValue = amount.div(2);
161                 uint token0Amount = _swapETHForToken(token0, swapValue, address(this));
162                 uint token1Amount = _swapETHForToken(token1, amount.sub(swapValue), address(this));
163 
164                 _approveTokenIfNeeded(token0);
165                 _approveTokenIfNeeded(token1);
166                 ROUTER.addLiquidity(token0, token1, token0Amount, token1Amount, 0, 0, receiver, block.timestamp);
167             }
168         }
169     }
170 
171     function _swapETHForToken(address token, uint value, address receiver) private returns (uint) {
172         address[] memory path;
173 
174         if (routePairAddresses[token] != address(0)) {
175             path = new address[](3);
176             path[0] = WETH;
177             path[1] = routePairAddresses[token];
178             path[2] = token;
179         } else {
180             path = new address[](2);
181             path[0] = WETH;
182             path[1] = token;
183         }
184 
185         uint[] memory amounts = ROUTER.swapExactETHForTokens{value : value}(0, path, receiver, block.timestamp);
186         return amounts[amounts.length - 1];
187     }
188 
189     function _swapTokenForETH(address token, uint amount, address receiver) private returns (uint) {
190         address[] memory path;
191         if (routePairAddresses[token] != address(0)) {
192             path = new address[](3);
193             path[0] = token;
194             path[1] = routePairAddresses[token];
195             path[2] = WETH;
196         } else {
197             path = new address[](2);
198             path[0] = token;
199             path[1] = WETH;
200         }
201 
202         uint[] memory amounts = ROUTER.swapExactTokensForETH(amount, 0, path, receiver, block.timestamp);
203         return amounts[amounts.length - 1];
204     }
205 
206     function _swap(address _from, uint amount, address _to, address receiver) private returns (uint) {
207         address intermediate = routePairAddresses[_from];
208         if (intermediate == address(0)) {
209             intermediate = routePairAddresses[_to];
210         }
211 
212         address[] memory path;
213         if (intermediate != address(0) && (_from == WETH || _to == WETH)) {
214             // [WETH, BUSD, VAI] or [VAI, BUSD, WETH]
215             path = new address[](3);
216             path[0] = _from;
217             path[1] = intermediate;
218             path[2] = _to;
219         } else if (intermediate != address(0) && (_from == intermediate || _to == intermediate)) {
220             // [VAI, BUSD] or [BUSD, VAI]
221             path = new address[](2);
222             path[0] = _from;
223             path[1] = _to;
224         } else if (intermediate != address(0) && routePairAddresses[_from] == routePairAddresses[_to]) {
225             // [VAI, DAI] or [VAI, USDC]
226             path = new address[](3);
227             path[0] = _from;
228             path[1] = intermediate;
229             path[2] = _to;
230         } else if (routePairAddresses[_from] != address(0) && routePairAddresses[_from] != address(0) && routePairAddresses[_from] != routePairAddresses[_to]) {
231             // routePairAddresses[xToken] = xRoute
232             // [VAI, BUSD, WETH, xRoute, xToken]
233             path = new address[](5);
234             path[0] = _from;
235             path[1] = routePairAddresses[_from];
236             path[2] = WETH;
237             path[3] = routePairAddresses[_to];
238             path[4] = _to;
239         } else if (intermediate != address(0) && routePairAddresses[_from] != address(0)) {
240             // [VAI, BUSD, WETH, BUNNY]
241             path = new address[](4);
242             path[0] = _from;
243             path[1] = intermediate;
244             path[2] = WETH;
245             path[3] = _to;
246         } else if (intermediate != address(0) && routePairAddresses[_to] != address(0)) {
247             // [BUNNY, WETH, BUSD, VAI]
248             path = new address[](4);
249             path[0] = _from;
250             path[1] = WETH;
251             path[2] = intermediate;
252             path[3] = _to;
253         } else if (_from == WETH || _to == WETH) {
254             // [WETH, BUNNY] or [BUNNY, WETH]
255             path = new address[](2);
256             path[0] = _from;
257             path[1] = _to;
258         } else {
259             // [USDT, BUNNY] or [BUNNY, USDT]
260             path = new address[](3);
261             path[0] = _from;
262             path[1] = WETH;
263             path[2] = _to;
264         }
265 
266         uint[] memory amounts = ROUTER.swapExactTokensForTokens(amount, 0, path, receiver, block.timestamp);
267         return amounts[amounts.length - 1];
268     }
269 
270     /* ========== RESTRICTED FUNCTIONS ========== */
271 
272     function setRoutePairAddress(address asset, address route) external onlyOwner {
273         routePairAddresses[asset] = route;
274     }
275 
276     function setNotLP(address token) public onlyOwner {
277         bool needPush = notLP[token] == false;
278         notLP[token] = true;
279         if (needPush) {
280             tokens.push(token);
281         }
282     }
283 
284     function removeToken(uint i) external onlyOwner {
285         address token = tokens[i];
286         notLP[token] = false;
287         tokens[i] = tokens[tokens.length - 1];
288         tokens.pop();
289     }
290 
291     function sweep() external onlyOwner {
292         for (uint i = 0; i < tokens.length; i++) {
293             address token = tokens[i];
294             if (token == address(0)) continue;
295             uint amount = IERC20(token).balanceOf(address(this));
296             if (amount > 0) {
297                 if (token == WETH) {
298                     IWETH(token).withdraw(amount);
299                 } else {
300                     _swapTokenForETH(token, amount, owner());
301                 }
302             }
303         }
304 
305         uint balance = address(this).balance;
306         if (balance > 0) {
307             payable(owner()).transfer(balance);
308         }
309     }
310 
311     function withdraw(address token) external onlyOwner {
312         if (token == address(0)) {
313             payable(owner()).transfer(address(this).balance);
314             return;
315         }
316 
317         IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
318     }
319 }
