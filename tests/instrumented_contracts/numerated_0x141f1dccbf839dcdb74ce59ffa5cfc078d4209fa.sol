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
231     function notifyRewardAmount(uint256 reward, uint256 gdaoReward) external;
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
283  * GOF Pool 2.0
284  */
285 contract GOFPoolV2 is GOFTokenWrapper, IRewardDistributionRecipient {
286     //GDAO TOKEN 
287     IERC20 public gdao = IERC20(0x22a259f8a78CF2d38Dd5fF92aE9d1aE7BFFF7419);
288 
289     uint256 public constant DURATION = 7 days;
290     uint256 public constant startTime = 1608120000; //utc+8 2020-12-16 20:00:00
291 
292     uint256 public totalAccumulatedReward = 0;
293     uint256 public totalAccumulatedRewardGdao = 0;
294 
295     uint256 public periodFinish = 0;
296     uint256 public rewardRate = 0;
297     uint256 public rewardRateGdao = 0;
298     uint256 public lastUpdateTime;
299     uint256 public rewardPerTokenStored = 0;
300     uint256 public rewardPerTokenStoredGdao = 0;
301     bool private open = true;
302     uint256 private constant _gunit = 1e18;
303     mapping(address => uint256) public userRewardPerTokenPaid; 
304     mapping(address => uint256) public rewards; // Unclaimed rewards
305 
306     mapping(address => uint256) public userRewardPerTokenPaidGdao; 
307     mapping(address => uint256) public rewardsGdao; // Unclaimed rewards
308 
309     mapping(address => uint256) public lastStakeTimes;
310 
311     event RewardAdded(uint256 reward, uint256 gdaoReward);
312     event Staked(address indexed user, uint256 amount);
313     event Withdrawn(address indexed user, uint256 amount);
314     event RewardPaid(address indexed user, uint256 reward, uint256 gdaoReward);
315     event SetOpen(bool _open);
316 
317     modifier updateReward(address account) {
318         (rewardPerTokenStored, rewardPerTokenStoredGdao) = rewardPerToken();
319         lastUpdateTime = lastTimeRewardApplicable();
320         if (account != address(0)) {
321             rewards[account] = earned(account);
322             rewardsGdao[account] = earnedGDAO(account);
323             userRewardPerTokenPaid[account] = rewardPerTokenStored;
324             userRewardPerTokenPaidGdao[account] = rewardPerTokenStoredGdao;
325         }
326         _;
327     }
328 
329     function lastTimeRewardApplicable() public view returns (uint256) {
330         return Math.min(block.timestamp, periodFinish);
331     }
332 
333     /**
334      * Calculate the rewards for each token
335      */
336     function rewardPerToken() public view returns (uint256, uint256) {
337         if (totalSupply() == 0) {
338             return (rewardPerTokenStored, rewardPerTokenStoredGdao);
339         }
340         return
341         (
342             rewardPerTokenStored.add(
343                 lastTimeRewardApplicable()
344                     .sub(lastUpdateTime)
345                     .mul(rewardRate)
346                     .mul(_gunit)
347                     .div(totalSupply())
348             ),
349             rewardPerTokenStoredGdao.add(
350                 lastTimeRewardApplicable()
351                     .sub(lastUpdateTime)
352                     .mul(rewardRateGdao)
353                     .mul(_gunit)
354                     .div(totalSupply())
355             )
356         );
357     }
358 
359     function earned(address account) public view returns (uint256) {
360         uint256 _rpt;
361         (_rpt,) = rewardPerToken();
362 
363         uint256 calculatedEarned = 
364             balanceOf(account)
365                 .mul(_rpt.sub(userRewardPerTokenPaid[account]))
366                 .div(_gunit)
367                 .add(rewards[account]);
368         uint256 poolBalance = gof.balanceOf(address(this));
369         if (poolBalance < totalSupply()) return 0;
370         if (calculatedEarned.add(totalSupply()) > poolBalance) return poolBalance.sub(totalSupply());
371         return calculatedEarned;
372     }
373 
374     function earnedGDAO(address account) public view returns (uint256) {
375         uint256 _rpt;
376         (,_rpt) = rewardPerToken();
377 
378         return balanceOf(account)
379                 .mul(_rpt.sub(userRewardPerTokenPaidGdao[account]))
380                 .div(_gunit)
381                 .add(rewardsGdao[account]);
382     }
383 
384     function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ 
385         require(amount > 0, "Golff-GOF-POOL: Cannot stake 0");
386         super.stake(amount);
387         lastStakeTimes[msg.sender] = block.timestamp;
388         emit Staked(msg.sender, amount);
389     }
390 
391     function withdraw(uint256 amount) public checkStart updateReward(msg.sender){
392         require(amount > 0, "Golff-GOF-POOL: Cannot withdraw 0");
393         super.withdraw(amount);
394         emit Withdrawn(msg.sender, amount);
395     }
396 
397     function exit() external {
398         withdraw(balanceOf(msg.sender));
399         getReward();
400     }
401 
402     function getReward() public checkStart updateReward(msg.sender){
403         uint256 reward = earned(msg.sender);
404         uint256 rewardGdao = earnedGDAO(msg.sender);
405         if (reward > 0) {
406             rewards[msg.sender] = 0;
407             rewardsGdao[msg.sender] = 0;
408             gof.safeTransfer(msg.sender, reward);
409             gdao.safeTransfer(msg.sender, rewardGdao);
410             emit RewardPaid(msg.sender, reward, rewardGdao);
411         }
412     }
413 
414     modifier checkStart(){
415         require(block.timestamp > startTime,"Golff-GOF-POOL: not start");
416         _;
417     }
418 
419     modifier checkOpen() {
420         require(open, "Golff-GOF-POOL: Pool is closed");
421         _;
422     }
423 
424     function getPeriodFinish() external view returns (uint256) {
425         return periodFinish;
426     }
427 
428     function isOpen() external view returns (bool) {
429         return open;
430     }
431 
432     function setOpen(bool _open) external onlyOwner {
433         open = _open;
434         emit SetOpen(_open);
435     }
436 
437     /**
438      * @param reward gof reward amount
439      * @param gdaoReward gdao reward amount
440      */
441     function notifyRewardAmount(uint256 reward, uint256 gdaoReward)
442         external
443         onlyRewardDistribution
444         checkOpen
445         updateReward(address(0)) {
446         if (block.timestamp > startTime){
447             if (block.timestamp >= periodFinish) {
448                 uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);
449                 periodFinish = startTime.add(period.mul(DURATION));
450                 rewardRate = reward.div(periodFinish.sub(block.timestamp));
451                 rewardRateGdao = gdaoReward.div(periodFinish.sub(block.timestamp));
452             } else {
453                 uint256 remaining = periodFinish.sub(block.timestamp);
454                 uint256 leftover = remaining.mul(rewardRate);
455                 rewardRate = reward.add(leftover).div(remaining);
456                 rewardRateGdao = gdaoReward.add(remaining.mul(rewardRateGdao)).div(remaining);
457             }
458             lastUpdateTime = block.timestamp;
459         }else {
460           uint256 b = gof.balanceOf(address(this));
461           rewardRate = reward.add(b).div(DURATION);
462           rewardRateGdao = gdaoReward.div(DURATION);
463           periodFinish = startTime.add(DURATION);
464           lastUpdateTime = startTime;
465         }
466 
467         gof.mint(address(this), reward);
468         gdao.mint(address(this), gdaoReward);
469 
470         totalAccumulatedReward = totalAccumulatedReward.add(reward);
471         totalAccumulatedRewardGdao = totalAccumulatedRewardGdao.add(gdaoReward);
472 
473         emit RewardAdded(reward, gdaoReward);
474 
475         // avoid overflow to lock assets
476         _checkRewardRate();
477     }
478     
479     function _checkRewardRate() internal view returns (uint256) {
480         DURATION.mul(rewardRateGdao).mul(_gunit);// overflow
481         return DURATION.mul(rewardRate).mul(_gunit);
482     }
483 
484     /**
485      * @dev Withdraw unsupportedToken of Pool
486      */
487     function claimUnsupportedToken(IERC20 _token, uint256 amount, address to) external onlyOwner{
488         require(_token != gof, "Golff-GOF-POOL: Forbid withdraw GOF");
489         require(_token != gdao, "Golff-GOF-POOL: Forbid withdraw GDAO");
490         _token.safeTransfer(to, amount);
491     }
492 }