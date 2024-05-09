1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6     function WETH() external pure returns (address);
7 
8     function addLiquidity(
9         address tokenA,
10         address tokenB,
11         uint amountADesired,
12         uint amountBDesired,
13         uint amountAMin,
14         uint amountBMin,
15         address to,
16         uint deadline
17     ) external returns (uint amountA, uint amountB, uint liquidity);
18     function addLiquidityETH(
19         address token,
20         uint amountTokenDesired,
21         uint amountTokenMin,
22         uint amountETHMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26     function removeLiquidity(
27         address tokenA,
28         address tokenB,
29         uint liquidity,
30         uint amountAMin,
31         uint amountBMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountA, uint amountB);
35     function removeLiquidityETH(
36         address token,
37         uint liquidity,
38         uint amountTokenMin,
39         uint amountETHMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountToken, uint amountETH);
43     function removeLiquidityWithPermit(
44         address tokenA,
45         address tokenB,
46         uint liquidity,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline,
51         bool approveMax, uint8 v, bytes32 r, bytes32 s
52     ) external returns (uint amountA, uint amountB);
53     function removeLiquidityETHWithPermit(
54         address token,
55         uint liquidity,
56         uint amountTokenMin,
57         uint amountETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountToken, uint amountETH);
62     function swapExactTokensForTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external returns (uint[] memory amounts);
69     function swapTokensForExactTokens(
70         uint amountOut,
71         uint amountInMax,
72         address[] calldata path,
73         address to,
74         uint deadline
75     ) external returns (uint[] memory amounts);
76     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
77     external
78     payable
79     returns (uint[] memory amounts);
80     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
81     external
82     returns (uint[] memory amounts);
83     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
84     external
85     returns (uint[] memory amounts);
86     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
87     external
88     payable
89     returns (uint[] memory amounts);
90 
91     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
92     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
93     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
94     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
95     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
96 }
97 
98 interface IUniswapV2Router02 is IUniswapV2Router01 {
99     function removeLiquidityETHSupportingFeeOnTransferTokens(
100         address token,
101         uint liquidity,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountETH);
107     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
108         address token,
109         uint liquidity,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline,
114         bool approveMax, uint8 v, bytes32 r, bytes32 s
115     ) external returns (uint amountETH);
116 
117     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function swapExactETHForTokensSupportingFeeOnTransferTokens(
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external payable;
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 }
138 
139 interface IERC20 {
140 
141     function totalSupply() external view returns (uint256);
142     
143     function symbol() external view returns(string memory);
144     
145     function name() external view returns(string memory);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151     
152     /**
153      * @dev Returns the number of decimal places
154      */
155     function decimals() external view returns (uint8);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `recipient`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175     /**
176      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * IMPORTANT: Beware that changing an allowance with this method brings the risk
181      * that someone may use both the old and the new allowance by unfortunate
182      * transaction ordering. One possible solution to mitigate this race
183      * condition is to first reduce the spender's allowance to 0 and set the
184      * desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address spender, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Moves `amount` tokens from `sender` to `recipient` using the
193      * allowance mechanism. `amount` is then deducted from the caller's
194      * allowance.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Emitted when `value` tokens are moved from one account (`from`) to
204      * another (`to`).
205      *
206      * Note that `value` may be zero.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     /**
211      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
212      * a call to {approve}. `value` is the new allowance.
213      */
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 interface IOwnedContract {
218     function getOwner() external view returns (address);
219 }
220 
221 interface IYieldFarm {
222     function depositRewards(uint256 amount) external;
223 }
224 
225 contract FeeReceiver {
226 
227     // Token
228     address public immutable token;
229 
230     // Recipients Of Fees
231     address public treasury;
232     address public yieldFarm;
233     address public stakingPool;
234 
235     // Fee Percentages
236     uint256 public treasuryPercent  = 60;
237     uint256 public yieldFarmPercent = 30;
238     uint256 public stakingPercent   = 10;
239     uint256 public bountyPercent    = 2;
240 
241     // Token -> BNB
242     address[] private path;
243 
244     // router
245     IUniswapV2Router02 public constant router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
246 
247     // Events
248     event UpdatedFees(uint256 treasury_, uint256 yield_, uint256 stake_);
249 
250     modifier onlyOwner(){
251         require(
252             msg.sender == IOwnedContract(token).getOwner(),
253             'Only Token Owner'
254         );
255         _;
256     }
257 
258     constructor(address token_, address treasury_) {
259         token = token_;
260         treasury = treasury_;
261         path = new address[](2);
262         path[0] = token_;
263         path[1] = router.WETH();
264         IERC20(token_).approve(address(router), 10**65);
265     }
266 
267     function trigger() external {
268 
269         // Bounty Reward For Triggerer
270         uint bounty = currentBounty();
271         if (bounty > 0) {
272             IERC20(token).transfer(msg.sender, bounty);
273         }
274 
275         // Split up remaining balance
276         uint bal = IERC20(token).balanceOf(address(this));
277         uint tBal = bal * treasuryPercent / 100;
278         uint yBal = bal * yieldFarmPercent / 100;
279         uint sBal = bal - ( tBal + yBal );
280 
281         // Sell Percentage Of Tokens For Treasury
282         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tBal, 0, path, treasury, block.timestamp + 300);
283 
284         // Deposit Tokens Into Yield Farm
285         IYieldFarm(yieldFarm).depositRewards(yBal);
286 
287         // Give Tokens To Staking
288         IERC20(token).transfer(stakingPool, sBal);
289     }
290 
291     function updateFeePercentages(uint treasury_, uint yield_, uint stake_) external onlyOwner {
292         require(
293             treasury_ + yield_ + stake_ == 100, 'Invalid Fees'
294         );
295         treasuryPercent = treasury_;
296         yieldFarmPercent = yield_;
297         stakingPercent = stake_;
298 
299         emit UpdatedFees(treasury_, yield_, stake_);
300     }
301 
302     function setBountyPercent(uint256 bountyPercent_) external onlyOwner {
303         require(bountyPercent_ <= 50);
304         bountyPercent = bountyPercent_;
305     }
306 
307     function setTreasury(address treasury_) external onlyOwner {
308         require(treasury_ != address(0));
309         treasury = treasury_;
310     }
311 
312     function setYieldFarm(address yieldFarm_) external onlyOwner {
313         require(yieldFarm_ != address(0));
314         yieldFarm = yieldFarm_;
315         IERC20(token).approve(yieldFarm_, ~uint(0));
316     }
317     
318     function setStakingPool(address stakingPool_) external onlyOwner {
319         require(stakingPool_ != address(0));
320         stakingPool = stakingPool_;
321     }
322 
323     function redoApprovals() external onlyOwner {
324         IERC20(token).approve(address(router), ~uint(0));
325         IERC20(token).approve(yieldFarm, ~uint(0));
326     }
327     
328     function withdraw() external onlyOwner {
329         (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
330         require(s);
331     }
332     
333     function withdraw(address _token) external onlyOwner {
334         IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
335     }
336 
337     receive() external payable {}
338 
339     function currentBounty() public view returns (uint256) {
340         return (IERC20(token).balanceOf(address(this)) * bountyPercent ) / 100;
341     }
342 }