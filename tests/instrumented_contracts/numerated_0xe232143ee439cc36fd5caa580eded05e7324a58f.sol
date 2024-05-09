1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 contract Ownable is Context {
14     address private _owner;
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     constructor () internal {
17         address msgSender = _msgSender();
18         _owner = msgSender;
19         emit OwnershipTransferred(address(0), msgSender);
20     }
21     function owner() public view returns (address) {
22         return _owner;
23     }
24     modifier onlyOwner() {
25         require(_owner == _msgSender(), "Ownable: caller is not the owner");
26         _;
27     }
28     function renounceOwnership() public virtual onlyOwner {
29         emit OwnershipTransferred(_owner, address(0));
30         _owner = address(0);
31     }
32     function transferOwnership(address newOwner) public virtual onlyOwner {
33         require(newOwner != address(0), "Ownable: new owner is the zero address");
34         emit OwnershipTransferred(_owner, newOwner);
35         _owner = newOwner;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         return mod(a, b, "SafeMath: modulo by zero");
83     }
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 library Address {
91     function isContract(address account) internal view returns (bool) {
92         uint256 size;
93         assembly { size := extcodesize(account) }
94         return size > 0;
95     }
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102       return functionCall(target, data, "Address: low-level call failed");
103     }
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
111         require(address(this).balance >= value, "Address: insufficient balance for call");
112         return _functionCallWithValue(target, data, value, errorMessage);
113     }
114     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
115         require(isContract(target), "Address: call to non-contract");
116         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
117         if (success) {
118             return returndata;
119         } else {
120             if (returndata.length > 0) {
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 interface IAward {
133     function addFreeAward(address _user, uint256 _amount) external;
134     function addAward(address _user, uint256 _amount) external;
135     function withdraw(uint256 _amount) external;
136     function destroy(uint256 amount) external;
137 }
138 
139 interface IERC20Token is IERC20 {
140     function maxSupply() external view returns (uint256);
141     function issue(address account, uint256 amount) external returns (bool);
142     function burn(uint256 amount) external returns (bool);
143 }
144 
145 interface ILPMining {
146     function add(address pool, uint256 index, uint256 allocP) external;
147     function set(uint256 pid, uint256 allocPoint) external;
148     function updateReferenceToken(uint256 pid, uint256 rIndex) external;
149     function batchSharePools() external;
150     function onTransferLiquidity(address from, address to, uint256 lpAmount) external;
151     function claimUserShares(uint pid, address user) external;
152     function claimLiquidityShares(address user, address[] calldata tokens, uint256[] calldata balances, uint256[] calldata weights, uint256 amount, bool _add) external;
153 }
154 
155 interface IOracle {
156     function requestTokenPrice(address token) external returns(uint8 decimal, uint256 price);
157 }
158 
159 interface IPool is IERC20 {
160     function getCurrentTokens() external view returns (address[] memory);
161     function getNormalizedWeight(address token) external view returns (uint);
162     function getBalance(address token) external view returns (uint);
163 }
164 
165 contract LPMiningV1 is ILPMining, Ownable {
166 
167     using SafeMath for uint256;
168 
169     struct ShareInfo {
170         uint256 tvl;
171         uint256 accPoolPerShare;
172         uint256 lastRewardBlock;
173     }
174 
175     struct PoolInfo {
176         IPool mPool;
177         //reference currency for tvl calculation
178         uint256 poolIndex;
179         uint256 referIndex;
180         uint256 allocPoint;       // How many allocation points assigned to this pool. token to distribute per block.
181         uint256 lastTvl;
182         uint256 accTokenPerShare;
183         uint256 rewardDebt;
184         address[] tokens;
185         uint256[] balances;
186         uint256[] weights;
187     }
188 
189     struct UserInfo {
190         uint256 rewardDebt;
191     }
192 
193     // pool info
194     address[] public pools;
195     mapping(address => PoolInfo) public poolInfo;
196     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
197 
198     // top share info
199     ShareInfo public shareInfo;
200 
201     // contract governors
202     mapping(address => bool) private governors;
203     modifier onlyGovernor{
204         require(governors[_msgSender()], "LPMiningV1: caller is not the governor");
205         _;
206     }
207 
208     IOracle public priceOracle;
209     // The block number when Token mining starts.
210     uint256 immutable public startBlock;
211     // The block number when triple rewards mining ends.
212     uint256 immutable public endTripleBlock;
213     // The block number when Token mining ends.
214     uint256 public endBlock;
215 
216     // tokens created per block changed with Token price.
217     uint256 public tokenPerBlock = 15 * 10 ** 17;
218 
219     // award
220     IAward  public award;
221 
222     event Initialization(address award, uint256 _tokenPerBlock, uint256 startBlock, uint256 endTripleBlock, uint256 endBlock, address oracle);
223     event Add(address mPool, uint256 index, uint256 allocP);
224     event Set(uint256 pid, uint256 allocPoint);
225     event ReferCurrencyChanged(address pool, uint256 oldIndex, uint256 newIndex);
226     event ClaimLiquidityShares(address pool, address user, uint256 rewards);
227     event ClaimUserShares(uint pid, address user, uint256 rewards);
228     event OnTransferLiquidity(address from, address to, uint256 lpAmount, uint256 fromAwards, uint256 toAwards);
229 
230     // init LPMiningV1
231     // constructor params
232     constructor(
233         address _award,
234         uint256 _tokenPerBlock,
235         uint256 _startBlock,
236         uint256 _endTripleBlock,
237         uint256 _endBlock,
238         address _oracle
239     ) public {
240         require(_award != address(0), "LPMiningV1: award invalid");
241         require(_startBlock < _endTripleBlock && _endTripleBlock < _endBlock, "LPMiningV1: blocks range invalid");
242         require(_oracle != address(0), "LPMiningV1: oracle invalid");
243         award = IAward(_award);
244         tokenPerBlock = _tokenPerBlock;
245         endTripleBlock = _endTripleBlock;
246         governors[_msgSender()] = true;
247         startBlock = _startBlock;
248         endBlock = _endBlock;
249         shareInfo.lastRewardBlock = block.number > _startBlock ? block.number : _startBlock;
250         priceOracle = IOracle(_oracle);
251         emit Initialization(_award, _tokenPerBlock, _startBlock, _endTripleBlock, _endBlock, _oracle);
252     }
253 
254     function poolIn(address pool) view public returns (bool){
255         if (address(poolInfo[pool].mPool) == address(0)) {
256             return false;
257         }
258         return true;
259     }
260 
261     function indexOfPool(address pool) view public returns (uint256){
262         if (poolIn(pool)) {
263             return poolInfo[pool].poolIndex;
264         }
265         return uint256(- 1);
266     }
267 
268     function setEndBlock(uint256 _endBlock) onlyOwner external{
269         endBlock = _endBlock;
270     }
271 
272     // add pool
273     function add(address pool, uint256 index, uint256 allocP) override onlyGovernor external {
274         require(!poolIn(pool), "LPMiningV1: pool duplicate");
275         require(pools.length.add(1) < uint256(- 1), "LPMiningV1: pools list overflow");
276         IPool pPool = IPool(pool);
277         require(index < pPool.getCurrentTokens().length, "LPMiningV1: reference token not exist");
278         address[] memory tokens = pPool.getCurrentTokens();
279         uint256[] memory _balances = new uint256[](tokens.length);
280         uint256[] memory _weights = new uint256[](tokens.length);
281         for (uint i = 0; i < tokens.length; i++) {
282             _balances[i] = pPool.getBalance(tokens[i]);
283             _weights[i] = pPool.getNormalizedWeight(tokens[i]);
284         }
285         poolInfo[pool] = PoolInfo({
286         mPool : pPool,
287         poolIndex : pools.length,
288         referIndex : index,
289         lastTvl : 0,
290         allocPoint : allocP,
291         accTokenPerShare : 0,
292         rewardDebt : 0,
293         tokens : tokens,
294         balances : _balances,
295         weights : _weights
296         });
297         pools.push(pool);
298         updateRewards();
299         sharePoolRewards(poolInfo[pool]);
300         emit Add(pool, index, allocP);
301     }
302 
303     function set(uint256 pid, uint256 allocPoint) override onlyGovernor external {
304         require(pid < pools.length, "LPMiningV1: pool not exist");
305         PoolInfo storage info = poolInfo[pools[pid]];
306         poolInfo[pools[pid]].allocPoint = allocPoint;
307         updateRewards();
308         sharePoolRewards(info);
309         emit Set(pid, allocPoint);
310     }
311 
312     // add governor
313     function addGovernor(address governor) onlyOwner external {
314         governors[governor] = true;
315     }
316     // remove governor
317     function removeGovernor(address governor) onlyOwner external {
318         governors[governor] = false;
319     }
320 
321     function updateOracle(address oracle) onlyGovernor external {
322         require(oracle != address(0), "LPMiningV1: oracle invalid");
323         priceOracle = IOracle(oracle);
324     }
325 
326     // batch share pool rewards
327     function batchSharePools() override external {
328         updateRewards();
329         for (uint i = 0; i < pools.length; i = i.add(1)) {
330             sharePoolRewards(poolInfo[pools[i]]);
331         }
332     }
333 
334     // update award
335     function updateAward(address _award) external onlyOwner {
336         require(_award != address(0), "LPMiningV1: award invalid");
337         award = IAward(_award);
338     }
339 
340     // update Reference token index
341     function updateReferenceToken(uint256 pid, uint256 rIndex) override onlyGovernor external {
342         require(pid < pools.length, "LPMiningV1: pool not exist");
343         address pool = pools[pid];
344         require(rIndex < IPool(pool).getCurrentTokens().length, "LPMiningV1: reference token not exist");
345         PoolInfo storage info = poolInfo[pool];
346         uint256 old = info.referIndex;
347         info.referIndex = rIndex;
348         updateRewards();
349         sharePoolRewards(info);
350         emit ReferCurrencyChanged(pool, old, rIndex);
351     }
352 
353     function claimUserShares(uint pid, address user) override external {
354         require(pid < pools.length, "LPMiningV1: pool not exist");
355         uint256 rewards = calUserRewards(pid, user, 0, true);
356         if (rewards > 0) {
357             award.addAward(user, rewards);
358         }
359         emit ClaimUserShares(pid, user, rewards);
360     }
361 
362     function claimLiquidityShares(address user, address[] calldata tokens, uint256[] calldata balances, uint256[] calldata weights, uint256 amount, bool _add) override external {
363         uint256 pid = indexOfPool(msg.sender);
364         if (pid != uint256(- 1)) {
365             PoolInfo storage pool = poolInfo[msg.sender];
366             pool.tokens = tokens;
367             pool.balances = balances;
368             pool.weights = weights;
369             uint256 rewards = calUserRewards(pid, user, amount, _add);
370             if (rewards > 0) {
371                 award.addAward(user, rewards);
372             }
373             emit ClaimLiquidityShares(msg.sender, user, rewards);
374         }
375     }
376 
377     // View function to see  pool and user's pending Token on frontend.
378     function pendingShares(uint256 pid, address user) public view returns (uint256) {
379         PoolInfo memory info = poolInfo[pools[pid]];
380         UserInfo memory uinfo = userInfo[pid][user];
381         if (info.mPool.totalSupply() == 0 || shareInfo.tvl == 0 || shareInfo.lastRewardBlock >= block.number) {
382             return 0;
383         }
384 
385         uint256 accPoolPerShare = shareInfo.accPoolPerShare;
386         uint256 multiplier = getMultiplier(shareInfo.lastRewardBlock, block.number);
387         uint256 rewards = multiplier.mul(tokenPerBlock).mul(1e18).div(shareInfo.tvl);
388         accPoolPerShare = accPoolPerShare.add(rewards);
389 
390         uint256 accTokenPerShare = info.accTokenPerShare;
391         rewards = accPoolPerShare.mul(info.lastTvl).sub(info.rewardDebt).div(info.mPool.totalSupply());
392         accTokenPerShare = accTokenPerShare.add(rewards);
393         return accTokenPerShare.mul(info.mPool.balanceOf(user)).sub(uinfo.rewardDebt).div(1e18);
394     }
395 
396     function onTransferLiquidity(address from, address to, uint256 lpAmount) override external {
397         uint256 pid = indexOfPool(msg.sender);
398         if (pid != uint256(- 1)) {
399             uint256 fromAwards = calUserRewards(pid, from, lpAmount, false);
400             uint256 toAwards = calUserRewards(pid, to, lpAmount, true);
401             if (fromAwards > 0) {
402                 if (Address.isContract(from)) {
403                     award.destroy(fromAwards);
404                 } else {
405                     award.addAward(from, fromAwards);
406                 }
407             }
408             if (toAwards > 0) {
409                 if (Address.isContract(to)) {
410                     award.destroy(toAwards);
411                 } else {
412                     award.addAward(to, toAwards);
413                 }
414             }
415             emit OnTransferLiquidity(from, to, lpAmount, fromAwards, toAwards);
416         }
417     }
418 
419     //cal pending rewards per tvl of pools
420     function updateRewards() private {
421         if (shareInfo.tvl > 0 && block.number > shareInfo.lastRewardBlock) {
422             uint256 multiplier = getMultiplier(shareInfo.lastRewardBlock, block.number);
423             uint256 rewards = multiplier.mul(tokenPerBlock).mul(1e18).div(shareInfo.tvl);
424             shareInfo.accPoolPerShare = shareInfo.accPoolPerShare.add(rewards);
425         }
426         shareInfo.lastRewardBlock = block.number > startBlock ? block.number : startBlock;
427     }
428 
429     //cal pending rewards for given pool
430     function sharePoolRewards(PoolInfo storage info) private {
431         _sharePoolRewards(info, 0, true);
432     }
433 
434     //cal pending rewards for given pool
435     function _sharePoolRewards(PoolInfo storage info, uint256 lpAmount, bool _add) private {
436         uint newTotalLiquidity = info.mPool.totalSupply();
437         uint lastTotalLiquidity = _add ? newTotalLiquidity.sub(lpAmount) : newTotalLiquidity.add(lpAmount);
438         if (lastTotalLiquidity > 0) {
439             uint256 rewards = shareInfo.accPoolPerShare.mul(info.lastTvl).sub(info.rewardDebt).div(lastTotalLiquidity);
440             info.accTokenPerShare = info.accTokenPerShare.add(rewards);
441         }
442         uint256 newTvl = getPoolTvl(info);
443         info.rewardDebt = shareInfo.accPoolPerShare.mul(newTvl);
444         shareInfo.tvl = shareInfo.tvl.add(newTvl).sub(info.lastTvl);
445         info.lastTvl = newTvl;
446     }
447 
448     // cal user shares
449     function calUserRewards(uint256 pid, address user, uint256 lpAmount, bool _add) private returns (uint256){
450         updateRewards();
451         PoolInfo storage info = poolInfo[pools[pid]];
452         _sharePoolRewards(info, lpAmount, _add);
453 
454         UserInfo storage user_info = userInfo[pid][user];
455         uint256 newAmount = info.mPool.balanceOf(user);
456         uint256 lastAmount = _add ? newAmount.sub(lpAmount) : newAmount.add(lpAmount);
457         uint256 shares = info.accTokenPerShare.mul(lastAmount).sub(user_info.rewardDebt).div(1e18);
458         user_info.rewardDebt = newAmount.mul(info.accTokenPerShare);
459         return shares;
460     }
461 
462     function getPoolTvl(PoolInfo memory info) private returns (uint256){
463         address baseToken = info.tokens[info.referIndex];
464         uint256 balance = info.balances[info.referIndex];
465         uint256 nw = info.weights[info.referIndex];
466         uint256 totalBalance = bdiv(balance, nw);
467         (uint8 decimal, uint256 price) = priceOracle.requestTokenPrice(baseToken);
468         require(price > 0, "LPMiningV1: token price invalid");
469         uint256 divisor = 10 ** uint256(decimal);
470         return totalBalance.mul(price).mul(info.allocPoint).div(divisor);
471     }
472 
473     // Return reward multiplier over the given _from to _to block.
474     function getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
475         if (_to <= endBlock) {
476             if (_to <= endTripleBlock) {
477                 return _to.sub(_from).mul(3);
478             } else if (_from < endTripleBlock) {
479                 return endTripleBlock.sub(_from).mul(3).add(_to.sub(endTripleBlock));
480             }
481             return _to.sub(_from);
482         } else if (_from >= endBlock) {
483             return 0;
484         } else {
485             if (_from < endTripleBlock) {
486                 return endTripleBlock.sub(_from).mul(3).add(endBlock.sub(endTripleBlock));
487             }
488             return endBlock.sub(_from);
489         }
490     }
491 
492     function bdiv(uint a, uint b) internal pure returns (uint){
493         require(b != 0, "ERR_DIV_ZERO");
494         uint c0 = a * 1e18;
495         require(a == 0 || c0 / a == 1e18, "ERR_DIV_INTERNAL");
496         // bmul overflow
497         uint c1 = c0 + (b / 2);
498         require(c1 >= c0, "ERR_DIV_INTERNAL");
499         //  badd require
500         uint c2 = c1 / b;
501         return c2;
502     }
503 }