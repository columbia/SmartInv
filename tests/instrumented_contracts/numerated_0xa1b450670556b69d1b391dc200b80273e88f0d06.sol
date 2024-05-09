1 pragma solidity 0.5.16;
2 
3 
4 library Math {
5     function max(uint256 a, uint256 b) internal pure returns (uint256) {
6         return a >= b ? a : b;
7     }
8     function min(uint256 a, uint256 b) internal pure returns (uint256) {
9         return a < b ? a : b;
10     }
11     function average(uint256 a, uint256 b) internal pure returns (uint256) {
12         // (a + b) / 2 can overflow, so we distribute
13         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
14     }
15 }
16 
17 library SafeMath {
18     
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29 
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33 
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47 
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 contract Context {
75     // Empty internal constructor, to prevent people from mistakenly deploying
76     // an instance of this contract, which should be used via inheritance.
77     constructor () internal { }
78     // solhint-disable-previous-line no-empty-blocks
79 
80     function _msgSender() internal view returns (address payable) {
81         return msg.sender;
82     }
83 
84     function _msgData() internal view returns (bytes memory) {
85         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
86         return msg.data;
87     }
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor () internal {
96         _owner = _msgSender();
97         emit OwnershipTransferred(address(0), _owner);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(isOwner(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function isOwner() public view returns (bool) {
110         return _msgSender() == _owner;
111     }
112 
113     function renounceOwnership() public onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     function _transferOwnership(address newOwner) internal {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         emit OwnershipTransferred(_owner, newOwner);
125         _owner = newOwner;
126     }
127 }
128 
129 interface IERC20 {
130     function totalSupply() external view returns (uint256);
131     function balanceOf(address account) external view returns (uint256);
132     function transfer(address recipient, uint256 amount) external returns (bool);
133     function mint(address account, uint amount) external;
134     function allowance(address owner, address spender) external view returns (uint256);
135     function approve(address spender, uint256 amount) external returns (bool);
136     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 library Address {
142     function isContract(address account) internal view returns (bool) {
143         // This method relies in extcodesize, which returns 0 for contracts in
144         // construction, since the code is only stored at the end of the
145         // constructor execution.
146 
147         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
148         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
149         // for accounts without code, i.e. `keccak256('')`
150         bytes32 codehash;
151         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
152         // solhint-disable-next-line no-inline-assembly
153         assembly { codehash := extcodehash(account) }
154         return (codehash != 0x0 && codehash != accountHash);
155     }
156 
157     function toPayable(address account) internal pure returns (address payable) {
158         return address(uint160(account));
159     }
160 
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(address(this).balance >= amount, "Address: insufficient balance");
163 
164         // solhint-disable-next-line avoid-call-value
165         (bool success, ) = recipient.call.value(amount)("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 }
169 
170 library SafeERC20 {
171     using SafeMath for uint256;
172     using Address for address;
173 
174     function safeTransfer(IERC20 token, address to, uint256 value) internal {
175         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
176     }
177 
178     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
179         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
180     }
181 
182     function safeApprove(IERC20 token, address spender, uint256 value) internal {
183         // safeApprove should only be called when setting an initial allowance,
184         // or when resetting it to zero. To increase and decrease it, use
185         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
186         // solhint-disable-next-line max-line-length
187         require((value == 0) || (token.allowance(address(this), spender) == 0),
188             "SafeERC20: approve from non-zero to non-zero allowance"
189         );
190         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
191     }
192 
193     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
194         uint256 newAllowance = token.allowance(address(this), spender).add(value);
195         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
196     }
197 
198     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
199         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
200         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
201     }
202 
203     function callOptionalReturn(IERC20 token, bytes memory data) private {
204         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
205         // we're implementing it ourselves.
206 
207         // A Solidity high level call has three parts:
208         //  1. The target address is checked to verify it contains contract code
209         //  2. The call itself is made, and success asserted
210         //  3. The return value is decoded, which in turn checks the size of the returned data.
211         // solhint-disable-next-line max-line-length
212         require(address(token).isContract(), "SafeERC20: call to non-contract");
213 
214         // solhint-disable-next-line avoid-low-level-calls
215         (bool success, bytes memory returndata) = address(token).call(data);
216         require(success, "SafeERC20: low-level call failed");
217 
218         if (returndata.length > 0) { // Return data is optional
219             // solhint-disable-next-line max-line-length
220             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
221         }
222     }
223 }
224 
225 /**
226  * Reward Amount Interface
227  */
228 contract IRewardDistributionRecipient is Ownable {
229     address rewardDistribution;
230 
231     function notifyRewardAmount(uint256 reward) external;
232 
233     modifier onlyRewardDistribution() {
234         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
235         _;
236     }
237 
238     function setRewardDistribution(address _rewardDistribution)
239         external
240         onlyOwner
241     {
242         rewardDistribution = _rewardDistribution;
243     }
244 }
245 
246 /**
247  * Staking Token Wrapper
248  */
249 pragma solidity 0.5.16;
250 
251 contract GOFTokenWrapper {
252     using SafeMath for uint256;
253     using SafeERC20 for IERC20;
254 
255     //GOF TOKEN 
256     IERC20 public gof = IERC20(0x488E0369f9BC5C40C002eA7c1fe4fd01A198801c);
257 
258     uint256 private _totalSupply;
259     mapping(address => uint256) private _balances;
260 
261     function totalSupply() public view returns (uint256) {
262         return _totalSupply;
263     }
264 
265     function balanceOf(address account) public view returns (uint256) {
266         return _balances[account];
267     }
268 
269     function stake(uint256 amount) public {
270         _totalSupply = _totalSupply.add(amount);
271         _balances[msg.sender] = _balances[msg.sender].add(amount);
272         gof.safeTransferFrom(msg.sender, address(this), amount);
273     }
274 
275     function withdraw(uint256 amount) public {
276         _totalSupply = _totalSupply.sub(amount);
277         _balances[msg.sender] = _balances[msg.sender].sub(amount);
278         gof.safeTransfer(msg.sender, amount);
279     }
280 }
281 
282 /**
283  * GOF Pool
284  */
285 contract GOFPool is GOFTokenWrapper, IRewardDistributionRecipient {
286 
287     uint256 public constant DURATION = 7 days;
288     uint256 public constant FROZEN_STAKING_TIME = 24 hours;
289 
290     uint256 public constant startTime = 1601467200; //utc+8 2020-09-30 20:00:00
291     uint256 public periodFinish = 0;
292     uint256 public rewardRate = 0;
293     uint256 public lastUpdateTime;
294     uint256 public rewardPerTokenStored = 0;
295     bool private open = true;
296     uint256 private constant _gunit = 1e18;
297     mapping(address => uint256) public userRewardPerTokenPaid; 
298     mapping(address => uint256) public rewards; // Unclaimed rewards
299 
300     mapping(address => uint256) public lastStakeTimes;
301 
302     event RewardAdded(uint256 reward);
303     event Staked(address indexed user, uint256 amount);
304     event Withdrawn(address indexed user, uint256 amount);
305     event RewardPaid(address indexed user, uint256 reward);
306     event SetOpen(bool _open);
307 
308     modifier updateReward(address account) {
309         rewardPerTokenStored = rewardPerToken();
310         lastUpdateTime = lastTimeRewardApplicable();
311         if (account != address(0)) {
312             rewards[account] = earned(account);
313             userRewardPerTokenPaid[account] = rewardPerTokenStored;
314         }
315         _;
316     }
317 
318     function lastTimeRewardApplicable() public view returns (uint256) {
319         return Math.min(block.timestamp, periodFinish);
320     }
321 
322     /**
323      * Calculate the rewards for each token
324      */
325     function rewardPerToken() public view returns (uint256) {
326         if (totalSupply() == 0) {
327             return rewardPerTokenStored;
328         }
329         return
330             rewardPerTokenStored.add(
331                 lastTimeRewardApplicable()
332                     .sub(lastUpdateTime)
333                     .mul(rewardRate)
334                     .mul(_gunit)
335                     .div(totalSupply())
336             );
337     }
338 
339     function earned(address account) public view returns (uint256) {
340         uint256 calculatedEarned = 
341             balanceOf(account)
342                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
343                 .div(_gunit)
344                 .add(rewards[account]);
345         uint256 poolBalance = gof.balanceOf(address(this));
346         if (poolBalance < totalSupply()) return 0;
347         if (calculatedEarned.add(totalSupply()) > poolBalance) return poolBalance.sub(totalSupply());
348         return calculatedEarned;
349     }
350 
351     function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ 
352         require(amount > 0, "Golff-GOF-POOL: Cannot stake 0");
353         super.stake(amount);
354         lastStakeTimes[msg.sender] = block.timestamp;
355         emit Staked(msg.sender, amount);
356     }
357 
358     function unfrozenStakeTime(address account) public view returns (uint256) {
359         return lastStakeTimes[account] + FROZEN_STAKING_TIME;
360     }
361 
362     function withdraw(uint256 amount) public checkStart updateReward(msg.sender){
363         require(amount > 0, "Golff-GOF-POOL: Cannot withdraw 0");
364         super.withdraw(amount);
365         emit Withdrawn(msg.sender, amount);
366     }
367 
368     function exit() external {
369         withdraw(balanceOf(msg.sender));
370         getReward();
371     }
372 
373     function getReward() public checkStart updateReward(msg.sender){
374         uint256 reward = earned(msg.sender);
375         if (reward > 0) {
376             rewards[msg.sender] = 0;
377             gof.safeTransfer(msg.sender, reward);
378             emit RewardPaid(msg.sender, reward);
379         }
380     }
381 
382     modifier checkStart(){
383         require(block.timestamp > startTime,"Golff-GOF-POOL: not start");
384         _;
385     }
386 
387     modifier checkOpen() {
388         require(open, "Golff-GOF-POOL: Pool is closed");
389         _;
390     }
391 
392     function getPeriodFinish() external view returns (uint256) {
393         return periodFinish;
394     }
395 
396     function isOpen() external view returns (bool) {
397         return open;
398     }
399 
400     function setOpen(bool _open) external onlyOwner {
401         open = _open;
402         emit SetOpen(_open);
403     }
404 
405     function notifyRewardAmount(uint256 reward)
406         external
407         onlyRewardDistribution
408         checkOpen
409         updateReward(address(0)) {
410         if (block.timestamp > startTime){
411             if (block.timestamp >= periodFinish) {
412                 uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);
413                 periodFinish = startTime.add(period.mul(DURATION));
414                 rewardRate = reward.div(periodFinish.sub(block.timestamp));
415             } else {
416                 uint256 remaining = periodFinish.sub(block.timestamp);
417                 uint256 leftover = remaining.mul(rewardRate);
418                 rewardRate = reward.add(leftover).div(remaining);
419             }
420             lastUpdateTime = block.timestamp;
421         }else {
422           uint256 b = gof.balanceOf(address(this));
423           rewardRate = reward.add(b).div(DURATION);
424           periodFinish = startTime.add(DURATION);
425           lastUpdateTime = startTime;
426         }
427 
428         gof.mint(address(this),reward);
429         emit RewardAdded(reward);
430 
431         // avoid overflow to lock assets
432         _checkRewardRate();
433     }
434     
435     function _checkRewardRate() internal view returns (uint256) {
436         return DURATION.mul(rewardRate).mul(_gunit);
437     }
438 }