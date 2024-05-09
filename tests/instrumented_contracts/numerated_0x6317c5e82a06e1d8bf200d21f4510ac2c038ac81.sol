1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity 0.5.12;
15 pragma experimental ABIEncoderV2;
16 
17 
18 contract PoolInterface {
19     function swapExactAmountIn(address, uint, address, uint, uint) external returns (uint, uint);
20     function swapExactAmountOut(address, uint, address, uint, uint) external returns (uint, uint);
21 }
22 
23 contract TokenInterface {
24     function balanceOf(address) public returns (uint);
25     function allowance(address, address) public returns (uint);
26     function approve(address, uint) public returns (bool);
27     function transfer(address, uint) public returns (bool);
28     function transferFrom(address, address, uint) public returns (bool);
29     function deposit() public payable;
30     function withdraw(uint) public;
31 }
32 
33 contract ExchangeProxy {
34 
35     struct Swap {
36         address pool;
37         uint    tokenInParam; // tokenInAmount / maxAmountIn / limitAmountIn
38         uint    tokenOutParam; // minAmountOut / tokenAmountOut / limitAmountOut
39         uint    maxPrice;
40     }
41 
42     event LOG_CALL(
43         bytes4  indexed sig,
44         address indexed caller,
45         bytes           data
46     ) anonymous;
47 
48     modifier _logs_() {
49         emit LOG_CALL(msg.sig, msg.sender, msg.data);
50         _;
51     }
52 
53     modifier _lock_() {
54         require(!_mutex, "ERR_REENTRY");
55         _mutex = true;
56         _;
57         _mutex = false;
58     }
59 
60     bool private _mutex;
61     TokenInterface weth;
62 
63     constructor(address _weth) public {
64         weth = TokenInterface(_weth);
65     }
66 
67     function add(uint a, uint b) internal pure returns (uint) {
68         uint c = a + b;
69         require(c >= a, "ERR_ADD_OVERFLOW");
70         return c;
71     }
72 
73     function batchSwapExactIn(
74         Swap[] memory swaps,
75         address tokenIn,
76         address tokenOut,
77         uint totalAmountIn,
78         uint minTotalAmountOut
79     )   
80         public
81         _logs_
82         _lock_
83         returns (uint totalAmountOut)
84     {
85         TokenInterface TI = TokenInterface(tokenIn);
86         TokenInterface TO = TokenInterface(tokenOut);
87         require(TI.transferFrom(msg.sender, address(this), totalAmountIn), "ERR_TRANSFER_FAILED");
88         for (uint i = 0; i < swaps.length; i++) {
89             Swap memory swap = swaps[i];
90             
91             PoolInterface pool = PoolInterface(swap.pool);
92             if (TI.allowance(address(this), swap.pool) < totalAmountIn) {
93                 TI.approve(swap.pool, uint(-1));
94             }
95             (uint tokenAmountOut,) = pool.swapExactAmountIn(
96                                         tokenIn,
97                                         swap.tokenInParam,
98                                         tokenOut,
99                                         swap.tokenOutParam,
100                                         swap.maxPrice
101                                     );
102             totalAmountOut = add(tokenAmountOut, totalAmountOut);
103         }
104         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
105         require(TO.transfer(msg.sender, TO.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
106         require(TI.transfer(msg.sender, TI.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
107         return totalAmountOut;
108     }
109 
110     function batchSwapExactOut(
111         Swap[] memory swaps,
112         address tokenIn,
113         address tokenOut,
114         uint maxTotalAmountIn
115     )
116         public
117         _logs_
118         _lock_
119         returns (uint totalAmountIn)
120     {
121         TokenInterface TI = TokenInterface(tokenIn);
122         TokenInterface TO = TokenInterface(tokenOut);
123         require(TI.transferFrom(msg.sender, address(this), maxTotalAmountIn), "ERR_TRANSFER_FAILED");
124         for (uint i = 0; i < swaps.length; i++) {
125             Swap memory swap = swaps[i];
126             PoolInterface pool = PoolInterface(swap.pool);
127             if (TI.allowance(address(this), swap.pool) < maxTotalAmountIn) {
128                 TI.approve(swap.pool, uint(-1));
129             }
130             (uint tokenAmountIn,) = pool.swapExactAmountOut(
131                                         tokenIn,
132                                         swap.tokenInParam,
133                                         tokenOut,
134                                         swap.tokenOutParam,
135                                         swap.maxPrice
136                                     );
137             totalAmountIn = add(tokenAmountIn, totalAmountIn);
138         }
139         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
140         require(TO.transfer(msg.sender, TO.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
141         require(TI.transfer(msg.sender, TI.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
142         return totalAmountIn;
143     }
144 
145     function batchEthInSwapExactIn(
146         Swap[] memory swaps,
147         address tokenOut,
148         uint minTotalAmountOut
149     )
150         public payable
151         _logs_
152         _lock_
153         returns (uint totalAmountOut)
154     {
155         TokenInterface TO = TokenInterface(tokenOut);
156         weth.deposit.value(msg.value)();
157         for (uint i = 0; i < swaps.length; i++) {
158             Swap memory swap = swaps[i];
159             PoolInterface pool = PoolInterface(swap.pool);
160             if (weth.allowance(address(this), swap.pool) < msg.value) {
161                 weth.approve(swap.pool, uint(-1));
162             }
163             (uint tokenAmountOut,) = pool.swapExactAmountIn(
164                                         address(weth),
165                                         swap.tokenInParam,
166                                         tokenOut,
167                                         swap.tokenOutParam,
168                                         swap.maxPrice
169                                     );
170             totalAmountOut = add(tokenAmountOut, totalAmountOut);
171         }
172         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
173         require(TO.transfer(msg.sender, TO.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
174         uint wethBalance = weth.balanceOf(address(this));
175         if (wethBalance > 0) {
176             weth.withdraw(wethBalance);
177             (bool xfer,) = msg.sender.call.value(wethBalance)("");
178             require(xfer, "ERR_ETH_FAILED");
179         }
180         return totalAmountOut;
181     }
182 
183     function batchEthOutSwapExactIn(
184         Swap[] memory swaps,
185         address tokenIn,
186         uint totalAmountIn,
187         uint minTotalAmountOut
188     )
189         public
190         _logs_
191         _lock_
192         returns (uint totalAmountOut)
193     {
194         TokenInterface TI = TokenInterface(tokenIn);
195         require(TI.transferFrom(msg.sender, address(this), totalAmountIn), "ERR_TRANSFER_FAILED");
196         for (uint i = 0; i < swaps.length; i++) {
197             Swap memory swap = swaps[i];
198             PoolInterface pool = PoolInterface(swap.pool);
199             if (TI.allowance(address(this), swap.pool) < totalAmountIn) {
200                 TI.approve(swap.pool, uint(-1));
201             }
202             (uint tokenAmountOut,) = pool.swapExactAmountIn(
203                                         tokenIn,
204                                         swap.tokenInParam,
205                                         address(weth),
206                                         swap.tokenOutParam,
207                                         swap.maxPrice
208                                     );
209 
210             totalAmountOut = add(tokenAmountOut, totalAmountOut);
211         }
212         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
213         uint wethBalance = weth.balanceOf(address(this));
214         weth.withdraw(wethBalance);
215         (bool xfer,) = msg.sender.call.value(wethBalance)("");
216         require(xfer, "ERR_ETH_FAILED");
217         require(TI.transfer(msg.sender, TI.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
218         return totalAmountOut;
219     }
220 
221     function batchEthInSwapExactOut(
222         Swap[] memory swaps,
223         address tokenOut
224     )
225         public payable
226         _logs_
227         _lock_
228         returns (uint totalAmountIn)
229     {
230         TokenInterface TO = TokenInterface(tokenOut);
231         weth.deposit.value(msg.value)();
232         for (uint i = 0; i < swaps.length; i++) {
233             Swap memory swap = swaps[i];
234             PoolInterface pool = PoolInterface(swap.pool);
235             if (weth.allowance(address(this), swap.pool) < msg.value) {
236                 weth.approve(swap.pool, uint(-1));
237             }
238             (uint tokenAmountIn,) = pool.swapExactAmountOut(
239                                         address(weth),
240                                         swap.tokenInParam,
241                                         tokenOut,
242                                         swap.tokenOutParam,
243                                         swap.maxPrice
244                                     );
245 
246             totalAmountIn = add(tokenAmountIn, totalAmountIn);
247         }
248         require(TO.transfer(msg.sender, TO.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
249         uint wethBalance = weth.balanceOf(address(this));
250         if (wethBalance > 0) {
251             weth.withdraw(wethBalance);
252             (bool xfer,) = msg.sender.call.value(wethBalance)("");
253             require(xfer, "ERR_ETH_FAILED");
254         }
255         return totalAmountIn;
256     }
257 
258     function batchEthOutSwapExactOut(
259         Swap[] memory swaps,
260         address tokenIn,
261         uint maxTotalAmountIn
262     )
263         public
264         _logs_
265         _lock_
266         returns (uint totalAmountIn)
267     {
268         TokenInterface TI = TokenInterface(tokenIn);
269         require(TI.transferFrom(msg.sender, address(this), maxTotalAmountIn), "ERR_TRANSFER_FAILED");
270         for (uint i = 0; i < swaps.length; i++) {
271             Swap memory swap = swaps[i];
272             PoolInterface pool = PoolInterface(swap.pool);
273             if (TI.allowance(address(this), swap.pool) < maxTotalAmountIn) {
274                 TI.approve(swap.pool, uint(-1));
275             }
276             (uint tokenAmountIn,) = pool.swapExactAmountOut(
277                                         tokenIn,
278                                         swap.tokenInParam,
279                                         address(weth),
280                                         swap.tokenOutParam,
281                                         swap.maxPrice
282                                     );
283 
284             totalAmountIn = add(tokenAmountIn, totalAmountIn);
285         }
286         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
287         require(TI.transfer(msg.sender, TI.balanceOf(address(this))), "ERR_TRANSFER_FAILED");
288         uint wethBalance = weth.balanceOf(address(this));
289         weth.withdraw(wethBalance);
290         (bool xfer,) = msg.sender.call.value(wethBalance)("");
291         require(xfer, "ERR_ETH_FAILED");
292         return totalAmountIn;
293     }
294 
295     function() external payable {}
296 }