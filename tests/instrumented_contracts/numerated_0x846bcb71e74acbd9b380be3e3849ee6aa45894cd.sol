1 // File: node_modules\@uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
146 
147 // SPDX-License-Identifier: MIT
148 
149 pragma solidity ^0.6.0;
150 
151 /**
152  * @dev Interface of the ERC20 standard as defined in the EIP.
153  */
154 interface IERC20 {
155     /**
156      * @dev Returns the amount of tokens in existence.
157      */
158     function totalSupply() external view returns (uint256);
159 
160     /**
161      * @dev Returns the amount of tokens owned by `account`.
162      */
163     function balanceOf(address account) external view returns (uint256);
164 
165     /**
166      * @dev Moves `amount` tokens from the caller's account to `recipient`.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transfer(address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Returns the remaining number of tokens that `spender` will be
176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
177      * zero by default.
178      *
179      * This value changes when {approve} or {transferFrom} are called.
180      */
181     function allowance(address owner, address spender) external view returns (uint256);
182 
183     /**
184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
189      * that someone may use both the old and the new allowance by unfortunate
190      * transaction ordering. One possible solution to mitigate this race
191      * condition is to first reduce the spender's allowance to 0 and set the
192      * desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Moves `amount` tokens from `sender` to `recipient` using the
201      * allowance mechanism. `amount` is then deducted from the caller's
202      * allowance.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to {approve}. `value` is the new allowance.
221      */
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 // File: contracts\Sniper.sol
226 
227 pragma solidity >=0.5.0;
228 
229 
230 
231 contract Sniper {
232     address payable public manager;
233     uint256 public buyAmt;
234 
235     mapping (address => bool) whitelistedAddresses;
236     // address private whitelistedAddresses[];
237     IUniswapV2Router02 router;
238 
239     receive() external payable {
240         // emit Received(msg.sender, msg.value);
241     }
242 
243     modifier restricted() {
244         require(msg.sender == manager, "manager allowed only");
245         _;
246     }
247     modifier whitelisted() {
248         require(whitelistedAddresses[msg.sender] == true || msg.sender == manager, "not whitelisted");
249         _;
250     }
251 
252     constructor(address _router) public {
253         manager = msg.sender;
254         router = IUniswapV2Router02(_router);
255     }
256 
257     function setBuyAmt(uint256 _buyAmt) external restricted {
258         buyAmt = _buyAmt;
259     }
260 
261     function buy(address[] memory path, bool fee) external whitelisted  {
262         // address[] memory path = new address[](2);
263         // path[0] = router.WETH();
264         // path[1] = tok;
265         require(address(this).balance >= buyAmt,"bo");
266 
267         if (fee){
268             router.swapExactETHForTokensSupportingFeeOnTransferTokens.value(buyAmt)(
269                 0,
270                 path,
271                 address(manager),
272                 block.timestamp
273             );
274         }else {
275             router.swapExactETHForTokens.value(buyAmt)(
276                 0,
277                 path,
278                 address(manager),
279                 block.timestamp
280             );
281 
282         }
283         // emit Bought(amts[1]);
284     }
285     function buy(address[] memory path, uint256 amtReceived, bool fee) external whitelisted{
286         // address[] memory path = new address[](2);
287         // path[0] = router.WETH();
288         // path[1] = tok;
289         require(address(this).balance >= buyAmt,"bo");
290 
291         require((router.getAmountsOut(buyAmt, path))[1] >= amtReceived, "amt");
292         if (fee){
293             router.swapExactETHForTokensSupportingFeeOnTransferTokens.value(buyAmt)(
294                 amtReceived,
295                 path,
296                 address(manager),
297                 block.timestamp
298             );
299         }else {
300             router.swapExactETHForTokens.value(buyAmt)(
301                 amtReceived,
302                 path,
303                 address(manager),
304                 block.timestamp
305             );
306 
307         }
308 
309         // emit Bought(amts[1]);
310     }
311     function kill() external restricted {
312         selfdestruct(manager);
313     }
314 
315     // function approve(address _token, address payable _uni) external restricted {
316     //     IERC20 token = IERC20(_token);
317     //     token.approve(
318     //         _uni,
319     //         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
320     //     );
321     // }
322     function drainEth() external restricted {
323         uint256 b = address(this).balance;
324         manager.send(b);
325     }
326 
327     function drainToken(IERC20 _token) external restricted {
328         IERC20 token = IERC20(_token);
329         uint256 tokenBalance = token.balanceOf(address(this));
330         token.transfer(manager, tokenBalance);
331     }
332 
333     function sendEth(address payable dest) payable external whitelisted{
334         dest.send(msg.value);
335     }
336     function setWhitelist(address[] memory addresses) external restricted {
337         for (uint i=0; i < addresses.length; i++) {
338             whitelistedAddresses[addresses[i]] = true;
339         }
340 
341     }
342     function isWhitelist(address a) view external returns (bool isW){
343         return whitelistedAddresses[a];
344     }
345 }