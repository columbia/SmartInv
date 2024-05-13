1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract Ownable {
17     address public owner;
18     address public newOwner;
19 
20     event OwnershipTransferred(address indexed from, address indexed to);
21 
22     constructor() {
23         owner = msg.sender;
24         emit OwnershipTransferred(address(0), owner);
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner, "LPReward: Caller is not the owner");
29         _;
30     }
31 
32     function getOwner() external view returns (address) {
33         return owner;
34     }
35 
36     function transferOwnership(address transferOwner) external onlyOwner {
37         require(transferOwner != newOwner);
38         newOwner = transferOwner;
39     }
40 
41     function acceptOwnership() virtual external {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 interface INimbusRouter {
50     function getAmountsOut(uint amountIn, address[] calldata path) external  view returns (uint[] memory amounts);
51 }
52 
53 interface INimbusFactory {
54     function getPair(address tokenA, address tokenB) external  view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56 }
57 
58 library Math {
59     function min(uint x, uint y) internal pure returns (uint z) {
60         z = x < y ? x : y;
61     }
62 
63     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
64     function sqrt(uint y) internal pure returns (uint z) {
65         if (y > 3) {
66             z = y;
67             uint x = y / 2 + 1;
68             while (x < z) {
69                 z = x;
70                 x = (y / x + x) / 2;
71             }
72         } else if (y != 0) {
73             z = 1;
74         }
75     }
76 }
77 
78 contract LPReward is Ownable {
79     uint public lpRewardMaxAmount = 100_000_000e18;
80     uint public lpRewardUsed;
81     uint public immutable startReward;
82     uint public constant rewardPeriod = 365 days;
83 
84     address public immutable NBU;
85     address public swapRouter;
86     INimbusFactory public immutable swapFactory;
87 
88     mapping (address => mapping (address => uint)) public lpTokenAmounts;
89     mapping (address => mapping (address => uint)) public weightedRatio;
90     mapping (address => mapping (address => uint)) public ratioUpdateLast;
91     mapping (address => mapping (address => uint[])) public unclaimedAmounts;
92     mapping (address => bool) public allowedPairs;
93     mapping (address => address[]) public pairTokens;
94 
95     event RecordAddLiquidity(address indexed recipient, address indexed pair, uint ratio, uint weightedRatio, uint oldWeighted, uint liquidity);
96     event RecordRemoveLiquidityUnclaimed(address indexed recipient, address indexed pair, uint amountA, uint amountB, uint liquidity);
97     event RecordRemoveLiquidityGiveNbu(address indexed recipient, address indexed pair, uint nbu, uint amountA, uint amountB, uint liquidity);
98     event ClaimLiquidityNbu(address indexed recipient, address indexed pair, uint nbu, uint amountA, uint amountB);
99     event Rescue(address indexed to, uint amount);
100     event RescueToken(address indexed token, address indexed to, uint amount); 
101 
102     constructor(address nbu, address factory) {
103         require(nbu != address(0) && factory != address(0), "LPReward: Zero address(es)");
104         swapFactory = INimbusFactory(factory);
105         NBU = nbu;
106         startReward = block.timestamp;
107     }
108     
109     uint private unlocked = 1;
110     modifier lock() {
111         require(unlocked == 1, "LPReward: LOCKED");
112         unlocked = 0;
113         _;
114         unlocked = 1;
115     }
116 
117     modifier onlyRouter() {
118         require(msg.sender == swapRouter, "LPReward: Caller is not the allowed router");
119         _;
120     }
121     
122     function recordAddLiquidity(address recipient, address pair, uint amountA, uint amountB, uint liquidity) external onlyRouter {
123         if (!allowedPairs[pair]) return;
124         uint ratio = Math.sqrt(amountA * amountB) * 1e18 / liquidity;   
125         uint previousRatio = weightedRatio[recipient][pair];
126         if (ratio < previousRatio) {
127             return;
128         }
129         uint previousAmount = lpTokenAmounts[recipient][pair];
130         uint newAmount = previousAmount + liquidity;
131         uint weighted =  (previousRatio * previousAmount / newAmount) + (ratio * liquidity / newAmount); 
132         weightedRatio[recipient][pair] = weighted;
133         lpTokenAmounts[recipient][pair] = newAmount;
134         ratioUpdateLast[recipient][pair] = block.timestamp;
135         emit RecordAddLiquidity(recipient, pair, ratio, weighted, previousRatio, liquidity);
136     }
137 
138     function recordRemoveLiquidity(address recipient, address tokenA, address tokenB, uint amountA, uint amountB, uint liquidity) external lock onlyRouter { 
139         address pair = swapFactory.getPair(tokenA, tokenB);
140         if (!allowedPairs[pair]) return;
141         uint amount0;
142         uint amount1;
143         {
144         uint previousAmount = lpTokenAmounts[recipient][pair];
145         if (previousAmount == 0) return;
146         uint ratio = Math.sqrt(amountA * amountB) * 1e18 / liquidity;   
147         uint previousRatio = weightedRatio[recipient][pair];
148         if (previousRatio == 0 || (previousRatio != 0 && ratio < previousRatio)) return;
149         uint difference = ratio - previousRatio;
150         if (previousAmount < liquidity) liquidity = previousAmount;
151         weightedRatio[recipient][pair] = (previousRatio * (previousAmount - liquidity) / previousAmount) + (ratio * liquidity / previousAmount);    
152         lpTokenAmounts[recipient][pair] = previousAmount - liquidity;
153         amount0 = amountA * difference / 1e18;
154         amount1 = amountB * difference / 1e18; 
155         }
156 
157         uint amountNbu;
158         if (tokenA != NBU && tokenB != NBU) {
159             address tokenToNbuPair = swapFactory.getPair(tokenA, NBU);
160             if (tokenToNbuPair != address(0)) {
161                 amountNbu = INimbusRouter(swapRouter).getAmountsOut(amount0, getPathForToken(tokenA))[1];
162             }
163 
164             tokenToNbuPair = swapFactory.getPair(tokenB, NBU);
165             if (tokenToNbuPair != address(0)) {
166                 if (amountNbu != 0) {
167                     amountNbu = amountNbu + INimbusRouter(swapRouter).getAmountsOut(amount1, getPathForToken(tokenB))[1];
168                 } else  {
169                     amountNbu = INimbusRouter(swapRouter).getAmountsOut(amount1, getPathForToken(tokenB))[1] * 2;
170                 }
171             } else {
172                 amountNbu = amountNbu * 2;
173             }
174         } else if (tokenA == NBU) { 
175             amountNbu = amount0 * 2;
176         } else {
177             amountNbu = amount1 * 2;
178         }
179         
180         if (amountNbu != 0 && amountNbu <= availableReward() && IBEP20(NBU).balanceOf(address(this)) >= amountNbu) {
181             require(IBEP20(NBU).transfer(recipient, amountNbu), "LPReward: Erroe while transfering");
182             lpRewardUsed = lpRewardUsed + amountNbu;
183             emit RecordRemoveLiquidityGiveNbu(recipient, pair, amountNbu, amountA, amountB, liquidity);            
184         } else {
185             uint amountS0;
186             uint amountS1;
187             {
188             (address token0,) = sortTokens(tokenA, tokenB);
189             (amountS0, amountS1) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
190             }
191             if (unclaimedAmounts[recipient][pair].length == 0) { 
192                 unclaimedAmounts[recipient][pair].push(amountS0);
193                 unclaimedAmounts[recipient][pair].push(amountS1);
194             } else {
195                 unclaimedAmounts[recipient][pair][0] += amountS0;
196                 unclaimedAmounts[recipient][pair][1] += amountS1;
197             }
198             
199             emit RecordRemoveLiquidityUnclaimed(recipient, pair, amount0, amount1, liquidity);
200         }
201         ratioUpdateLast[recipient][pair] = block.timestamp;
202     }
203     
204     function claimBonusBatch(address[] memory pairs, address recipient) external {
205         for (uint i; i < pairs.length; i++) {
206             claimBonus(pairs[i],recipient);
207         }
208     }
209     
210     function claimBonus(address pair, address recipient) public lock {
211         require (allowedPairs[pair], "LPReward: Not allowed pair");
212         require (unclaimedAmounts[recipient][pair].length > 0 && (unclaimedAmounts[recipient][pair][0] > 0 || unclaimedAmounts[recipient][pair][1] > 0), "LPReward: No undistributed fee bonuses");
213         uint amountA;
214         uint amountB;
215         amountA = unclaimedAmounts[recipient][pair][0];
216         amountB = unclaimedAmounts[recipient][pair][1];
217         unclaimedAmounts[recipient][pair][0] = 0;
218         unclaimedAmounts[recipient][pair][1] = 0;
219 
220         uint amountNbu = nbuAmountForPair(pair, amountA, amountB);
221         require (amountNbu > 0, "LPReward: No NBU pairs to token A and token B");
222         require (amountNbu <= availableReward(), "LPReward: Available reward for the period is used");
223         
224         require(IBEP20(NBU).transfer(recipient, amountNbu), "LPReward: Error while transfering");
225         lpRewardUsed += amountNbu;
226         emit ClaimLiquidityNbu(recipient, pair, amountNbu, amountA, amountB);            
227     }
228 
229     function unclaimedAmountNbu(address recipient, address pair) external view returns (uint) {
230         uint amountA;
231         uint amountB;
232         if (unclaimedAmounts[recipient][pair].length != 0) {
233             amountA = unclaimedAmounts[recipient][pair][0];
234             amountB = unclaimedAmounts[recipient][pair][1];
235         } else  {
236             return 0;
237         }
238 
239         return nbuAmountForPair(pair, amountA, amountB);
240     }
241 
242     function unclaimedAmount(address recipient, address pair) external view returns (uint amountA, uint amountB) {
243         if (unclaimedAmounts[recipient][pair].length != 0) {
244             amountA = unclaimedAmounts[recipient][pair][0];
245             amountB = unclaimedAmounts[recipient][pair][1];
246         }
247     }
248 
249     function availableReward() public view returns (uint) {
250         uint rewardForPeriod = lpRewardMaxAmount * (block.timestamp - startReward) / rewardPeriod;
251         if (rewardForPeriod > lpRewardUsed) return rewardForPeriod - lpRewardUsed;
252         else return 0;
253     }
254 
255     function nbuAmountForPair(address pair, uint amountA, uint amountB) private view returns (uint amountNbu) {
256         address tokenA = pairTokens[pair][0];
257         address tokenB = pairTokens[pair][1];
258         if (tokenA != NBU && tokenB != NBU) {
259             address tokenToNbuPair = swapFactory.getPair(tokenA, NBU);
260             if (tokenToNbuPair != address(0)) {
261                 amountNbu = INimbusRouter(swapRouter).getAmountsOut(amountA, getPathForToken(tokenA))[1];
262             }
263 
264             tokenToNbuPair = swapFactory.getPair(tokenB, NBU);
265             if (tokenToNbuPair != address(0)) {
266                 if (amountNbu != 0) {
267                     amountNbu = amountNbu + INimbusRouter(swapRouter).getAmountsOut(amountB, getPathForToken(tokenB))[1];
268                 } else  {
269                     amountNbu = INimbusRouter(swapRouter).getAmountsOut(amountB, getPathForToken(tokenB))[1] * 2;
270                 }
271             } else {
272                 amountNbu = amountNbu * 2;
273             }
274         } else if (tokenA == NBU) {
275             amountNbu = amountA * 2;
276         } else {
277             amountNbu = amountB * 2;
278         }
279     }
280 
281     function getPathForToken(address token) private view returns (address[] memory) {
282         address[] memory path = new address[](2);
283         path[0] = token;
284         path[1] = NBU;
285         return path;
286     }
287 
288     function sortTokens(address tokenA, address tokenB) private pure returns (address token0, address token1) {
289         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
290     }
291 
292 
293 
294     function rescue(address payable to, uint256 amount) external onlyOwner {
295         require(to != address(0), "LPReward: Address is zero");
296         require(amount > 0, "LPReward: Should be greater than 0");
297         TransferHelper.safeTransferBNB(to, amount);
298         emit Rescue(to, amount);
299     }
300 
301     function rescue(address to, address token, uint256 amount) external onlyOwner {
302         require(to != address(0), "LPReward: Address is zero");
303         require(amount > 0, "LPReward: Should be greater than 0");
304         TransferHelper.safeTransfer(token, to, amount);
305         emit RescueToken(token, to, amount);
306     }
307 
308     function updateSwapRouter(address newRouter) external onlyOwner {
309         require (newRouter != address(0), "LPReward: Zero address");
310         swapRouter = newRouter;
311     }
312 
313     function updateAllowedPair(address tokenA, address tokenB, bool isAllowed) external onlyOwner {
314         require (tokenA != address(0) && tokenB != address(0) && tokenA != tokenB, "LPReward: Wrong addresses");
315         address pair = swapFactory.getPair(tokenA, tokenB);
316         require (pair != address(0), "LPReward: Pair not exists");
317         if (!allowedPairs[pair]) {
318             (address token0, address token1) = sortTokens(tokenA, tokenB);
319             pairTokens[pair].push(token0);
320             pairTokens[pair].push(token1);
321         }
322         allowedPairs[pair] = isAllowed;
323     }
324 
325     function updateRewardMaxAmount(uint newAmount) external onlyOwner {
326         lpRewardMaxAmount = newAmount;
327     }
328 }
329 
330 library TransferHelper {
331     function safeApprove(address token, address to, uint value) internal {
332         // bytes4(keccak256(bytes('approve(address,uint256)')));
333         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
334         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
335     }
336 
337     function safeTransfer(address token, address to, uint value) internal {
338         // bytes4(keccak256(bytes('transfer(address,uint256)')));
339         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
340         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
341     }
342 
343     function safeTransferFrom(address token, address from, address to, uint value) internal {
344         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
345         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
346         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
347     }
348 
349     function safeTransferBNB(address to, uint value) internal {
350         (bool success,) = to.call{value:value}(new bytes(0));
351         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
352     }
353 }