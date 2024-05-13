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
33 * SOFTWARE.
34 */
35 
36 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
38 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
39 
40 import "../interfaces/IPancakePair.sol";
41 import "../interfaces/IPancakeRouter02.sol";
42 import "../interfaces/IZap.sol";
43 import "../interfaces/ISafeSwapBNB.sol";
44 
45 contract ZapBSC is IZap, OwnableUpgradeable {
46     using SafeMath for uint;
47     using SafeBEP20 for IBEP20;
48 
49     /* ========== CONSTANT VARIABLES ========== */
50 
51     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
52     address private constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
53     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
54     address private constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
55     address private constant USDT = 0x55d398326f99059fF775485246999027B3197955;
56     address private constant DAI = 0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3;
57     address private constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
58     address private constant VAI = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
59     address private constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
60     address private constant ETH = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
61     address private constant DOT = 0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402;
62 
63     IPancakeRouter02 private constant ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
64 
65     /* ========== STATE VARIABLES ========== */
66 
67     mapping(address => bool) private notFlip;
68     mapping(address => address) private routePairAddresses;
69     address[] public tokens;
70     address public safeSwapBNB;
71 
72     /* ========== INITIALIZER ========== */
73 
74     function initialize() external initializer {
75         __Ownable_init();
76         require(owner() != address(0), "Zap: owner must be set");
77 
78         setNotFlip(CAKE);
79         setNotFlip(BUNNY);
80         setNotFlip(WBNB);
81         setNotFlip(BUSD);
82         setNotFlip(USDT);
83         setNotFlip(DAI);
84         setNotFlip(USDC);
85         setNotFlip(VAI);
86         setNotFlip(BTCB);
87         setNotFlip(ETH);
88         setNotFlip(DOT);
89 
90         setRoutePairAddress(VAI, BUSD);
91         setRoutePairAddress(USDC, BUSD);
92         setRoutePairAddress(DAI, BUSD);
93     }
94 
95     receive() external payable {}
96 
97 
98     /* ========== View Functions ========== */
99 
100     function isFlip(address _address) public view returns (bool) {
101         return !notFlip[_address];
102     }
103 
104     function routePair(address _address) external view returns(address) {
105         return routePairAddresses[_address];
106     }
107 
108     /* ========== External Functions ========== */
109 
110     function zapInToken(address _from, uint amount, address _to) external override {
111         IBEP20(_from).safeTransferFrom(msg.sender, address(this), amount);
112         _approveTokenIfNeeded(_from);
113 
114         if (isFlip(_to)) {
115             IPancakePair pair = IPancakePair(_to);
116             address token0 = pair.token0();
117             address token1 = pair.token1();
118             if (_from == token0 || _from == token1) {
119                 // swap half amount for other
120                 address other = _from == token0 ? token1 : token0;
121                 _approveTokenIfNeeded(other);
122                 uint sellAmount = amount.div(2);
123                 uint otherAmount = _swap(_from, sellAmount, other, address(this));
124                 pair.skim(address(this));
125                 ROUTER.addLiquidity(_from, other, amount.sub(sellAmount), otherAmount, 0, 0, msg.sender, block.timestamp);
126             } else {
127                 uint bnbAmount = _from == WBNB ? _safeSwapToBNB(amount) : _swapTokenForBNB(_from, amount, address(this));
128                 _swapBNBToFlip(_to, bnbAmount, msg.sender);
129             }
130         } else {
131             _swap(_from, amount, _to, msg.sender);
132         }
133     }
134 
135     function zapIn(address _to) external payable override {
136         _swapBNBToFlip(_to, msg.value, msg.sender);
137     }
138 
139     function zapOut(address _from, uint amount) external override {
140         IBEP20(_from).safeTransferFrom(msg.sender, address(this), amount);
141         _approveTokenIfNeeded(_from);
142 
143         if (!isFlip(_from)) {
144             _swapTokenForBNB(_from, amount, msg.sender);
145         } else {
146             IPancakePair pair = IPancakePair(_from);
147             address token0 = pair.token0();
148             address token1 = pair.token1();
149 
150             if (pair.balanceOf(_from) > 0) {
151                 pair.burn(address(this));
152             }
153 
154             if (token0 == WBNB || token1 == WBNB) {
155                 ROUTER.removeLiquidityETH(token0 != WBNB ? token0 : token1, amount, 0, 0, msg.sender, block.timestamp);
156             } else {
157                 ROUTER.removeLiquidity(token0, token1, amount, 0, 0, msg.sender, block.timestamp);
158             }
159         }
160     }
161 
162     /* ========== Private Functions ========== */
163 
164     function _approveTokenIfNeeded(address token) private {
165         if (IBEP20(token).allowance(address(this), address(ROUTER)) == 0) {
166             IBEP20(token).safeApprove(address(ROUTER), uint(- 1));
167         }
168     }
169 
170     function _swapBNBToFlip(address flip, uint amount, address receiver) private {
171         if (!isFlip(flip)) {
172             _swapBNBForToken(flip, amount, receiver);
173         } else {
174             // flip
175             IPancakePair pair = IPancakePair(flip);
176             address token0 = pair.token0();
177             address token1 = pair.token1();
178             if (token0 == WBNB || token1 == WBNB) {
179                 address token = token0 == WBNB ? token1 : token0;
180                 uint swapValue = amount.div(2);
181                 uint tokenAmount = _swapBNBForToken(token, swapValue, address(this));
182 
183                 _approveTokenIfNeeded(token);
184                 pair.skim(address(this));
185                 ROUTER.addLiquidityETH{value : amount.sub(swapValue)}(token, tokenAmount, 0, 0, receiver, block.timestamp);
186             } else {
187                 uint swapValue = amount.div(2);
188                 uint token0Amount = _swapBNBForToken(token0, swapValue, address(this));
189                 uint token1Amount = _swapBNBForToken(token1, amount.sub(swapValue), address(this));
190 
191                 _approveTokenIfNeeded(token0);
192                 _approveTokenIfNeeded(token1);
193                 pair.skim(address(this));
194                 ROUTER.addLiquidity(token0, token1, token0Amount, token1Amount, 0, 0, receiver, block.timestamp);
195             }
196         }
197     }
198 
199     function _swapBNBForToken(address token, uint value, address receiver) private returns (uint) {
200         address[] memory path;
201 
202         if (routePairAddresses[token] != address(0)) {
203             path = new address[](3);
204             path[0] = WBNB;
205             path[1] = routePairAddresses[token];
206             path[2] = token;
207         } else {
208             path = new address[](2);
209             path[0] = WBNB;
210             path[1] = token;
211         }
212 
213         uint[] memory amounts = ROUTER.swapExactETHForTokens{value : value}(0, path, receiver, block.timestamp);
214         return amounts[amounts.length - 1];
215     }
216 
217     function _swapTokenForBNB(address token, uint amount, address receiver) private returns (uint) {
218         address[] memory path;
219         if (routePairAddresses[token] != address(0)) {
220             path = new address[](3);
221             path[0] = token;
222             path[1] = routePairAddresses[token];
223             path[2] = WBNB;
224         } else {
225             path = new address[](2);
226             path[0] = token;
227             path[1] = WBNB;
228         }
229 
230         uint[] memory amounts = ROUTER.swapExactTokensForETH(amount, 0, path, receiver, block.timestamp);
231         return amounts[amounts.length - 1];
232     }
233 
234     function _swap(address _from, uint amount, address _to, address receiver) private returns (uint) {
235         address intermediate = routePairAddresses[_from];
236         if (intermediate == address(0)) {
237             intermediate = routePairAddresses[_to];
238         }
239 
240         address[] memory path;
241         if (intermediate != address(0) && (_from == WBNB || _to == WBNB)) {
242             // [WBNB, BUSD, VAI] or [VAI, BUSD, WBNB]
243             path = new address[](3);
244             path[0] = _from;
245             path[1] = intermediate;
246             path[2] = _to;
247         } else if (intermediate != address(0) && (_from == intermediate || _to == intermediate)) {
248             // [VAI, BUSD] or [BUSD, VAI]
249             path = new address[](2);
250             path[0] = _from;
251             path[1] = _to;
252         } else if (intermediate != address(0) && routePairAddresses[_from] == routePairAddresses[_to]) {
253             // [VAI, DAI] or [VAI, USDC]
254             path = new address[](3);
255             path[0] = _from;
256             path[1] = intermediate;
257             path[2] = _to;
258         } else if (routePairAddresses[_from] != address(0) && routePairAddresses[_to] != address(0) && routePairAddresses[_from] != routePairAddresses[_to]) {
259             // routePairAddresses[xToken] = xRoute
260             // [VAI, BUSD, WBNB, xRoute, xToken]
261             path = new address[](5);
262             path[0] = _from;
263             path[1] = routePairAddresses[_from];
264             path[2] = WBNB;
265             path[3] = routePairAddresses[_to];
266             path[4] = _to;
267         } else if (intermediate != address(0) && routePairAddresses[_from] != address(0)) {
268             // [VAI, BUSD, WBNB, BUNNY]
269             path = new address[](4);
270             path[0] = _from;
271             path[1] = intermediate;
272             path[2] = WBNB;
273             path[3] = _to;
274         } else if (intermediate != address(0) && routePairAddresses[_to] != address(0)) {
275             // [BUNNY, WBNB, BUSD, VAI]
276             path = new address[](4);
277             path[0] = _from;
278             path[1] = WBNB;
279             path[2] = intermediate;
280             path[3] = _to;
281         } else if (_from == WBNB || _to == WBNB) {
282             // [WBNB, BUNNY] or [BUNNY, WBNB]
283             path = new address[](2);
284             path[0] = _from;
285             path[1] = _to;
286         } else {
287             // [USDT, BUNNY] or [BUNNY, USDT]
288             path = new address[](3);
289             path[0] = _from;
290             path[1] = WBNB;
291             path[2] = _to;
292         }
293 
294         uint[] memory amounts = ROUTER.swapExactTokensForTokens(amount, 0, path, receiver, block.timestamp);
295         return amounts[amounts.length - 1];
296     }
297 
298     function _safeSwapToBNB(uint amount) private returns (uint) {
299         require(IBEP20(WBNB).balanceOf(address(this)) >= amount, "Zap: Not enough WBNB balance");
300         require(safeSwapBNB != address(0), "Zap: safeSwapBNB is not set");
301         uint beforeBNB = address(this).balance;
302         ISafeSwapBNB(safeSwapBNB).withdraw(amount);
303         return (address(this).balance).sub(beforeBNB);
304     }
305 
306     /* ========== RESTRICTED FUNCTIONS ========== */
307 
308     function setRoutePairAddress(address asset, address route) public onlyOwner {
309         routePairAddresses[asset] = route;
310     }
311 
312     function setNotFlip(address token) public onlyOwner {
313         bool needPush = notFlip[token] == false;
314         notFlip[token] = true;
315         if (needPush) {
316             tokens.push(token);
317         }
318     }
319 
320     function removeToken(uint i) external onlyOwner {
321         address token = tokens[i];
322         notFlip[token] = false;
323         tokens[i] = tokens[tokens.length - 1];
324         tokens.pop();
325     }
326 
327     function sweep() external onlyOwner {
328         for (uint i = 0; i < tokens.length; i++) {
329             address token = tokens[i];
330             if (token == address(0)) continue;
331             uint amount = IBEP20(token).balanceOf(address(this));
332             if (amount > 0) {
333                 _swapTokenForBNB(token, amount, owner());
334             }
335         }
336     }
337 
338     function withdraw(address token) external onlyOwner {
339         if (token == address(0)) {
340             payable(owner()).transfer(address(this).balance);
341             return;
342         }
343 
344         IBEP20(token).transfer(owner(), IBEP20(token).balanceOf(address(this)));
345     }
346 
347     function setSafeSwapBNB(address _safeSwapBNB) external onlyOwner {
348         require(safeSwapBNB == address(0), "Zap: safeSwapBNB already set!");
349         safeSwapBNB = _safeSwapBNB;
350         IBEP20(WBNB).approve(_safeSwapBNB, uint(-1));
351     }
352 }
