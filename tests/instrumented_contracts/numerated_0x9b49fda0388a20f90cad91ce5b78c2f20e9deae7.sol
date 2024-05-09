1 pragma solidity ^0.7.1;
2 
3 contract DFOStake {
4 
5     address private constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
6 
7     address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
8 
9     address private WETH_ADDRESS = IUniswapV2Router(UNISWAP_V2_ROUTER).WETH();
10 
11     address[] private TOKENS;
12 
13     mapping(uint256 => uint256) private _totalPoolAmount;
14 
15     uint256[] private TIME_WINDOWS;
16 
17     uint256[] private REWARD_MULTIPLIERS;
18 
19     uint256[] private REWARD_DIVIDERS;
20 
21     uint256[] private REWARD_SPLIT_TRANCHES;
22 
23     address private _doubleProxy;
24 
25     struct StakeInfo {
26         address sender;
27         uint256 poolPosition;
28         uint256 firstAmount;
29         uint256 secondAmount;
30         uint256 poolAmount;
31         uint256 reward;
32         uint256 endBlock;
33         uint256[] partialRewardBlockTimes;
34         uint256 splittedReward;
35     }
36 
37     uint256 private _startBlock;
38 
39     mapping(uint256 => mapping(uint256 => StakeInfo)) private _stakeInfo;
40     mapping(uint256 => uint256) private _stakeInfoLength;
41 
42     event Staked(address indexed sender, uint256 indexed tier, uint256 indexed poolPosition, uint256 firstAmount, uint256 secondAmount, uint256 poolAmount, uint256 reward, uint256 endBlock, uint256[] partialRewardBlockTimes, uint256 splittedReward);
43     event Withdrawn(address sender, address indexed receiver, uint256 indexed tier, uint256 indexed poolPosition, uint256 firstAmount, uint256 secondAmount, uint256 poolAmount, uint256 reward);
44     event PartialWithdrawn(address sender, address indexed receiver, uint256 indexed tier, uint256 reward);
45 
46     constructor(uint256 startBlock, address doubleProxy, address[] memory tokens, uint256[] memory timeWindows, uint256[] memory rewardMultipliers, uint256[] memory rewardDividers, uint256[] memory rewardSplitTranches) public {
47 
48         _startBlock = startBlock;
49 
50         _doubleProxy = doubleProxy;
51 
52         for(uint256 i = 0; i < tokens.length; i++) {
53             TOKENS.push(tokens[i]);
54         }
55 
56         assert(timeWindows.length == rewardMultipliers.length && rewardMultipliers.length == rewardDividers.length && rewardDividers.length == rewardSplitTranches.length);
57         for(uint256 i = 0; i < timeWindows.length; i++) {
58             TIME_WINDOWS.push(timeWindows[i]);
59         }
60 
61         for(uint256 i = 0; i < rewardMultipliers.length; i++) {
62             REWARD_MULTIPLIERS.push(rewardMultipliers[i]);
63         }
64 
65         for(uint256 i = 0; i < rewardDividers.length; i++) {
66             REWARD_DIVIDERS.push(rewardDividers[i]);
67         }
68 
69         for(uint256 i = 0; i < rewardSplitTranches.length; i++) {
70             REWARD_SPLIT_TRANCHES.push(rewardSplitTranches[i]);
71         }
72     }
73 
74     function doubleProxy() public view returns(address) {
75         return _doubleProxy;
76     }
77 
78     function tokens() public view returns(address[] memory) {
79         return TOKENS;
80     }
81 
82     function tierData() public view returns(uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory) {
83         return (TIME_WINDOWS, REWARD_MULTIPLIERS, REWARD_DIVIDERS, REWARD_SPLIT_TRANCHES);
84     }
85 
86     function startBlock() public view returns(uint256) {
87         return _startBlock;
88     }
89 
90     function totalPoolAmount(uint256 poolPosition) public view returns(uint256) {
91         return _totalPoolAmount[poolPosition];
92     }
93 
94     function setDoubleProxy(address newDoubleProxy) public {
95         require(IMVDFunctionalitiesManager(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");
96         _doubleProxy = newDoubleProxy;
97     }
98 
99     function emergencyFlush() public {
100         IMVDProxy proxy = IMVDProxy(IDoubleProxy(_doubleProxy).proxy());
101         require(IMVDFunctionalitiesManager(proxy.getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");
102         address walletAddress = proxy.getMVDWalletAddress();
103         address tokenAddress = proxy.getToken();
104         IERC20 token = IERC20(tokenAddress);
105         uint256 balanceOf = token.balanceOf(address(this));
106         if(balanceOf > 0) {
107             token.transfer(walletAddress, balanceOf);
108         }
109         balanceOf = 0;
110         for(uint256 i = 0; i < TOKENS.length; i++) {
111             token = IERC20(IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(tokenAddress, TOKENS[i]));
112             balanceOf = token.balanceOf(address(this));
113             if(balanceOf > 0) {
114                 token.transfer(walletAddress, balanceOf);
115                 _totalPoolAmount[i] = 0;
116             }
117             balanceOf = 0;
118         }
119     }
120 
121     function stake(uint256 tier, uint256 poolPosition, uint256 originalFirstAmount, uint256 firstAmountMin, uint256 value, uint256 secondAmountMin) public payable {
122         require(block.number >= _startBlock, "Staking is still not available");
123         require(poolPosition < TOKENS.length, "Unknown Pool");
124         require(tier < TIME_WINDOWS.length, "Unknown tier");
125 
126         require(originalFirstAmount > 0, "First amount must be greater than 0");
127 
128         uint256 originalSecondAmount = TOKENS[poolPosition] == WETH_ADDRESS ? msg.value : value;
129         require(originalSecondAmount > 0, "Second amount must be greater than 0");
130 
131         IMVDProxy proxy = IMVDProxy(IDoubleProxy(_doubleProxy).proxy());
132         address tokenAddress = proxy.getToken();
133 
134         _transferTokensAndCheckAllowance(tokenAddress, originalFirstAmount);
135         _transferTokensAndCheckAllowance(TOKENS[poolPosition], originalSecondAmount);
136 
137         address secondToken = TOKENS[poolPosition];
138 
139         (uint256 firstAmount, uint256 secondAmount, uint256 poolAmount) = _createPoolToken(originalFirstAmount, firstAmountMin, originalSecondAmount, secondAmountMin, tokenAddress, secondToken);
140 
141         _totalPoolAmount[poolPosition] += poolAmount;
142 
143         (uint256 minCap,, uint256 remainingToStake) = getStakingInfo(tier);
144         require(firstAmount >= minCap, "Amount to stake is less than the current min cap");
145         require(firstAmount <= remainingToStake, "Amount to stake must be less than the current remaining one");
146 
147         calculateRewardAndAddStakingPosition(tier, poolPosition, firstAmount, secondAmount, poolAmount, proxy);
148     }
149 
150     function getStakingInfo(uint256 tier) public view returns(uint256 minCap, uint256 hardCap, uint256 remainingToStake) {
151         (minCap, hardCap) = getStakingCap(tier);
152         remainingToStake = hardCap;
153         uint256 length = _stakeInfoLength[tier];
154         for(uint256 i = 0; i < length; i++) {
155             if(_stakeInfo[tier][i].endBlock > block.number) {
156                 remainingToStake -= _stakeInfo[tier][i].firstAmount;
157             }
158         }
159     }
160 
161     function getStakingCap(uint256 tier) public view returns(uint256, uint256) {
162         IStateHolder stateHolder = IStateHolder(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getStateHolderAddress());
163         string memory tierString = _toString(tier);
164         string memory addressString = _toLowerCase(_toString(address(this)));
165         return (
166             stateHolder.getUint256(string(abi.encodePacked("staking.", addressString, ".tiers[", tierString, "].minCap"))),
167             stateHolder.getUint256(string(abi.encodePacked("staking.", addressString, ".tiers[", tierString, "].hardCap")))
168         );
169     }
170 
171     function _transferTokensAndCheckAllowance(address tokenAddress, uint256 value) private {
172         if(tokenAddress == WETH_ADDRESS) {
173             return;
174         }
175         IERC20 token = IERC20(tokenAddress);
176         token.transferFrom(msg.sender, address(this), value);
177         if(token.allowance(address(this), UNISWAP_V2_ROUTER) <= value) {
178             token.approve(UNISWAP_V2_ROUTER, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
179         }
180     }
181 
182     function _createPoolToken(uint256 originalFirstAmount, uint256 firstAmountMin, uint256 originalSecondAmount, uint256 secondAmountMin, address firstToken, address secondToken) private returns(uint256 firstAmount, uint256 secondAmount, uint256 poolAmount) {
183         if(secondToken == WETH_ADDRESS) {
184             (firstAmount, secondAmount, poolAmount) = IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidityETH{value: originalSecondAmount}(
185                 firstToken,
186                 originalFirstAmount,
187                 firstAmountMin,
188                 secondAmountMin,
189                 address(this),
190                 block.timestamp + 1000
191             );
192         } else {
193             (firstAmount, secondAmount, poolAmount) = IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidity(
194                 firstToken,
195                 secondToken,
196                 originalFirstAmount,
197                 originalSecondAmount,
198                 firstAmountMin,
199                 secondAmountMin,
200                 address(this),
201                 block.timestamp + 1000
202             );
203         }
204         if(firstAmount < originalFirstAmount) {
205             IERC20(firstToken).transfer(msg.sender, originalFirstAmount - firstAmount);
206         }
207         if(secondAmount < originalSecondAmount) {
208             if(secondToken == WETH_ADDRESS) {
209                 payable(msg.sender).transfer(originalSecondAmount - secondAmount);
210             } else {
211                 IERC20(secondToken).transfer(msg.sender, originalSecondAmount - secondAmount);
212             }
213         }
214     }
215 
216     function calculateRewardAndAddStakingPosition(uint256 tier, uint256 poolPosition, uint256 firstAmount, uint256 secondAmount, uint256 poolAmount, IMVDProxy proxy) private {
217         uint256 partialRewardSingleBlockTime = TIME_WINDOWS[tier] / REWARD_SPLIT_TRANCHES[tier];
218         uint256[] memory partialRewardBlockTimes = new uint256[](REWARD_SPLIT_TRANCHES[tier]);
219         if(partialRewardBlockTimes.length > 0) {
220             partialRewardBlockTimes[0] = block.number + partialRewardSingleBlockTime;
221             for(uint256 i = 1; i < partialRewardBlockTimes.length; i++) {
222                 partialRewardBlockTimes[i] = partialRewardBlockTimes[i - 1] + partialRewardSingleBlockTime;
223             }
224         }
225         uint256 reward = firstAmount * REWARD_MULTIPLIERS[tier] / REWARD_DIVIDERS[tier];
226         StakeInfo memory stakeInfo = StakeInfo(msg.sender, poolPosition, firstAmount, secondAmount, poolAmount, reward, block.number + TIME_WINDOWS[tier], partialRewardBlockTimes, reward / REWARD_SPLIT_TRANCHES[tier]);
227         _add(tier, stakeInfo);
228         proxy.submit("stakingTransfer", abi.encode(address(0), 0, reward, address(this)));
229         emit Staked(msg.sender, tier, poolPosition, firstAmount, secondAmount, poolAmount, reward, stakeInfo.endBlock, partialRewardBlockTimes, stakeInfo.splittedReward);
230     }
231 
232     function _add(uint256 tier, StakeInfo memory element) private returns(uint256, uint256) {
233         _stakeInfo[tier][_stakeInfoLength[tier]] = element;
234         _stakeInfoLength[tier] = _stakeInfoLength[tier] + 1;
235         return (element.reward, element.endBlock);
236     }
237 
238     function _remove(uint256 tier, uint256 i) private {
239         if(_stakeInfoLength[tier] <= i) {
240             return;
241         }
242         _stakeInfoLength[tier] = _stakeInfoLength[tier] - 1;
243         if(_stakeInfoLength[tier] > i) {
244             _stakeInfo[tier][i] = _stakeInfo[tier][_stakeInfoLength[tier]];
245         }
246         delete _stakeInfo[tier][_stakeInfoLength[tier]];
247     }
248 
249     function length(uint256 tier) public view returns(uint256) {
250         return _stakeInfoLength[tier];
251     }
252 
253     function stakeInfo(uint256 tier, uint256 position) public view returns(
254         address,
255         uint256,
256         uint256,
257         uint256,
258         uint256,
259         uint256,
260         uint256,
261         uint256[] memory,
262         uint256
263     ) {
264         StakeInfo memory tierStakeInfo = _stakeInfo[tier][position];
265         return(
266             tierStakeInfo.sender,
267             tierStakeInfo.poolPosition,
268             tierStakeInfo.firstAmount,
269             tierStakeInfo.secondAmount,
270             tierStakeInfo.poolAmount,
271             tierStakeInfo.reward,
272             tierStakeInfo.endBlock,
273             tierStakeInfo.partialRewardBlockTimes,
274             tierStakeInfo.splittedReward
275         );
276     }
277 
278     function partialReward(uint256 tier, uint256 position) public {
279         StakeInfo memory tierStakeInfo = _stakeInfo[tier][position];
280         if(block.number >= tierStakeInfo.endBlock) {
281             return withdraw(tier, position);
282         }
283         require(tierStakeInfo.reward > 0, "No more reward for this staking position");
284         uint256 reward = 0;
285         for(uint256 i = 0; i < tierStakeInfo.partialRewardBlockTimes.length; i++) {
286             if(tierStakeInfo.partialRewardBlockTimes[i] > 0 && block.number >= tierStakeInfo.partialRewardBlockTimes[i]) {
287                 reward += tierStakeInfo.splittedReward;
288                 tierStakeInfo.partialRewardBlockTimes[i] = 0;
289             }
290         }
291         reward = reward > tierStakeInfo.reward ? tierStakeInfo.reward : reward;
292         require(reward > 0, "No reward to redeem");
293         IERC20 token = IERC20(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getToken());
294         token.transfer(tierStakeInfo.sender, reward);
295         tierStakeInfo.reward = tierStakeInfo.reward - reward;
296         _stakeInfo[tier][position] = tierStakeInfo;
297         emit PartialWithdrawn(msg.sender, tierStakeInfo.sender, tier, reward);
298     }
299 
300     function withdraw(uint256 tier, uint256 position) public {
301         StakeInfo memory tierStakeInfo = _stakeInfo[tier][position];
302         require(block.number >= tierStakeInfo.endBlock, "Cannot actually withdraw this position");
303         IERC20 token = IERC20(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getToken());
304         if(tierStakeInfo.reward > 0) {
305             token.transfer(tierStakeInfo.sender, tierStakeInfo.reward);
306         }
307         token = IERC20(IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(address(token), TOKENS[tierStakeInfo.poolPosition]));
308         token.transfer(tierStakeInfo.sender, tierStakeInfo.poolAmount);
309         _totalPoolAmount[tierStakeInfo.poolPosition] = _totalPoolAmount[tierStakeInfo.poolPosition] - tierStakeInfo.poolAmount;
310         emit Withdrawn(msg.sender, tierStakeInfo.sender, tier, tierStakeInfo.poolPosition, tierStakeInfo.firstAmount, tierStakeInfo.secondAmount, tierStakeInfo.poolAmount, tierStakeInfo.reward);
311         _remove(tier, position);
312     }
313 
314     function _toString(uint _i) private pure returns(string memory) {
315         if (_i == 0) {
316             return "0";
317         }
318         uint j = _i;
319         uint len;
320         while (j != 0) {
321             len++;
322             j /= 10;
323         }
324         bytes memory bstr = new bytes(len);
325         uint k = len - 1;
326         while (_i != 0) {
327             bstr[k--] = byte(uint8(48 + _i % 10));
328             _i /= 10;
329         }
330         return string(bstr);
331     }
332 
333     function _toString(address _addr) private pure returns(string memory) {
334         bytes32 value = bytes32(uint256(_addr));
335         bytes memory alphabet = "0123456789abcdef";
336 
337         bytes memory str = new bytes(42);
338         str[0] = '0';
339         str[1] = 'x';
340         for (uint i = 0; i < 20; i++) {
341             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
342             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
343         }
344         return string(str);
345     }
346 
347     function _toLowerCase(string memory str) private pure returns(string memory) {
348         bytes memory bStr = bytes(str);
349         for (uint i = 0; i < bStr.length; i++) {
350             bStr[i] = bStr[i] >= 0x41 && bStr[i] <= 0x5A ? bytes1(uint8(bStr[i]) + 0x20) : bStr[i];
351         }
352         return string(bStr);
353     }
354 }
355 
356 interface IMVDProxy {
357     function getToken() external view returns(address);
358     function getStateHolderAddress() external view returns(address);
359     function getMVDWalletAddress() external view returns(address);
360     function getMVDFunctionalitiesManagerAddress() external view returns(address);
361     function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
362 }
363 
364 interface IStateHolder {
365     function setUint256(string calldata name, uint256 value) external returns(uint256);
366     function getUint256(string calldata name) external view returns(uint256);
367     function getBool(string calldata varName) external view returns (bool);
368     function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);
369 }
370 
371 interface IMVDFunctionalitiesManager {
372     function isAuthorizedFunctionality(address functionality) external view returns(bool);
373 }
374 
375 interface IERC20 {
376     function balanceOf(address account) external view returns (uint256);
377     function allowance(address owner, address spender) external view returns (uint256);
378     function approve(address spender, uint256 amount) external returns (bool);
379     function transfer(address recipient, uint256 amount) external returns (bool);
380     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
381 }
382 
383 interface IUniswapV2Router {
384     function WETH() external pure returns (address);
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint amountADesired,
389         uint amountBDesired,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB, uint liquidity);
395 
396     function addLiquidityETH(
397         address token,
398         uint amountTokenDesired,
399         uint amountTokenMin,
400         uint amountETHMin,
401         address to,
402         uint deadline
403     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
404 }
405 
406 interface IUniswapV2Factory {
407     function getPair(address tokenA, address tokenB) external view returns (address pair);
408 }
409 
410 interface IDoubleProxy {
411     function proxy() external view returns(address);
412 }