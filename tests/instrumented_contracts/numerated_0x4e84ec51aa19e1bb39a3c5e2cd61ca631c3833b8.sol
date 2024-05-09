1 pragma solidity ^0.5.0;
2 
3 /*
4     | Launch Date     : January 29, 2021 |
5     | Reward Duration : 26 Weeks         | 
6     | Total Rewards   : 80000            |
7     | End Date        : July 16, 2021    |
8 
9 */
10 
11 library Math {
12 
13     function max(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a >= b ? a : b;
15     }
16 
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     function average(uint256 a, uint256 b) internal pure returns (uint256) {
22 
23         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
24     }
25 }
26 
27 library SafeMath {
28    
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51    
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62     
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68    
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71 
72         return c;
73     }
74 
75 
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         return mod(a, b, "SafeMath: modulo by zero");
78     }
79 
80 
81     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 contract Context {
88 
89     constructor () internal { }
90    
91     function _msgSender() internal view returns (address payable) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view returns (bytes memory) {
96         this; 
97         return msg.data;
98     }
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor () internal {
107         _owner = _msgSender();
108         emit OwnershipTransferred(address(0), _owner);
109     }
110 
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115 
116     modifier onlyOwner() {
117         require(isOwner(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function isOwner() public view returns (bool) {
122         return _msgSender() == _owner;
123     }
124 
125     function renounceOwnership() public onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134 
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 interface IERC20 {
143    
144     function totalSupply() external view returns (uint256);
145 
146     function balanceOf(address account) external view returns (uint256);
147 
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
156 
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 library Address {
163 
164     function isContract(address account) internal view returns (bool) {
165         bytes32 codehash;
166         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
167      
168         assembly { codehash := extcodehash(account) }
169         return (codehash != 0x0 && codehash != accountHash);
170     }
171 
172     function toPayable(address account) internal pure returns (address payable) {
173         return address(uint160(account));
174     }
175 
176 
177     function sendValue(address payable recipient, uint256 amount) internal {
178         require(address(this).balance >= amount, "Address: insufficient balance");
179 
180         
181         (bool success, ) = recipient.call.value(amount)("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 }
185 
186 library SafeERC20 {
187     using SafeMath for uint256;
188     using Address for address;
189 
190     function safeTransfer(IERC20 token, address to, uint256 value) internal {
191         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
192     }
193 
194     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
195         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
196     }
197 
198     function safeApprove(IERC20 token, address spender, uint256 value) internal {
199         require((value == 0) || (token.allowance(address(this), spender) == 0),
200             "SafeERC20: approve from non-zero to non-zero allowance"
201         );
202         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
203     }
204 
205     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
206         uint256 newAllowance = token.allowance(address(this), spender).add(value);
207         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
208     }
209 
210     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
211         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
212         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
213     }
214 
215     function callOptionalReturn(IERC20 token, bytes memory data) private {
216         require(address(token).isContract(), "SafeERC20: call to non-contract");
217 
218 
219         (bool success, bytes memory returndata) = address(token).call(data);
220         require(success, "SafeERC20: low-level call failed");
221 
222         if (returndata.length > 0) { // Return data is optional
223          
224             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
225         }
226     }
227 }
228 
229 contract IRewardDistributionRecipient is Ownable {
230     address public rewardDistribution; 
231 
232     function notifyRewardAmount(uint256 reward) external;
233 
234     constructor () internal {
235         rewardDistribution = owner(); 
236     }
237 
238     modifier onlyRewardDistribution() {
239         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
240         _;
241     }
242 
243 }
244 
245 contract LPTokenWrapper is IRewardDistributionRecipient {
246     using SafeMath for uint256;
247     using SafeERC20 for IERC20;
248    
249     IERC20 public FAST_ETH_FLP = IERC20(0xbE380cb425D1094DEf80Ae5Dd3838422EbA2C4E3); //--|FLP|--
250 
251     uint256 private _totalSupply;
252     mapping(address => uint256) private _balances;
253 
254     function totalSupply() public view returns (uint256) {
255         return _totalSupply;
256     }
257 
258     function balanceOf(address account) public view returns (uint256) {
259         return _balances[account];
260     }
261 
262     function stake(uint256 amount) public {
263         _totalSupply = _totalSupply.add(amount);
264         _balances[_msgSender()] = _balances[_msgSender()].add(amount);
265         FAST_ETH_FLP.safeTransferFrom(_msgSender(), address(this), amount);
266     }
267 
268     function withdraw(uint256 amount) public {
269         _totalSupply = _totalSupply.sub(amount);
270         _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
271         FAST_ETH_FLP.safeTransfer(_msgSender(), amount);
272     }
273 }
274 //-----------------------------------------------------------------------
275 // --------------------| REWARD AMOUNT: 80,000 |-----------------------
276 //-----------------------------------------------------------------------
277 contract FAST_GANG_Pool is LPTokenWrapper {
278     IERC20 public fast = IERC20(0xC888A0Ab4831A29e6cA432BaBf52E353D23Db3c2);
279     uint256 public constant DURATION = 26 weeks;  //-----| Ending |--------
280 
281     uint256 public starttime = 1611941400;       //-----| Friday 5:30 PM UTC |-----
282     uint256 public periodFinish = 0;
283     uint256 public rewardRate = 0;
284     uint256 public lastUpdateTime;
285     uint256 public rewardPerTokenStored;
286     uint256 public rewardInterval = 48 hours;
287     
288     mapping(address => uint256) public userRewardPerTokenPaid;
289     mapping(address => uint256) public rewards;
290     mapping(address => uint256) public lastTimeRewarded;
291 
292     event RewardAdded(uint256 reward);
293     event Staked(address indexed user, uint256 amount);
294     event Withdrawn(address indexed user, uint256 amount);
295     event Rewarded(address indexed from, address indexed to, uint256 value);
296 
297     modifier checkStart(){
298         require(block.timestamp >= starttime,"FAST_GANG_Pool not started yet.");
299         _;
300     }
301 
302     modifier updateReward(address account) {
303         rewardPerTokenStored = rewardPerToken();
304         lastUpdateTime = lastTimeRewardApplicable();
305         if (account != address(0)) {
306             rewards[account] = earned(account);
307             userRewardPerTokenPaid[account] = rewardPerTokenStored;
308         }
309         _;
310     }
311 
312     function lastTimeRewardApplicable() public view returns (uint256) {
313         return Math.min(block.timestamp, periodFinish);
314     }
315 
316     function rewardPerToken() public view returns (uint256) {
317         if (totalSupply() == 0) {
318             return rewardPerTokenStored;
319         }
320         return
321             rewardPerTokenStored.add(
322                 lastTimeRewardApplicable()
323                     .sub(lastUpdateTime)
324                     .mul(rewardRate)
325                     .mul(1e18)
326                     .div(totalSupply())
327             );
328     }
329 
330     function earned(address account) public view returns (uint256) {
331         return
332             balanceOf(account)
333                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
334                 .div(1e18)
335                 .add(rewards[account]);
336     }
337 
338     //----------------------------| 48 hours |---------------------------
339     function setRewardInterval(uint256  _rewardInterval) external onlyOwner {
340            rewardInterval = _rewardInterval;
341     }
342  
343     function collectRewardAmount() public onlyOwner {
344             fast.safeTransfer(_msgSender(), fast.balanceOf(address(this)));
345     }
346 
347     function tokensInThisPool() public view returns (uint256){
348         return fast.balanceOf(address(this));
349    }
350 
351     function stake(uint256 amount) public updateReward(_msgSender()) checkStart {
352         require(amount > 0, "Cannot stake 0");
353         super.stake(amount);
354         emit Staked(_msgSender(), amount);
355     }
356 
357     function withdraw(uint256 amount) public updateReward(_msgSender()) checkStart {
358         require(amount > 0, "Cannot withdraw 0");
359         super.withdraw(amount);
360         emit Withdrawn(_msgSender(), amount);
361 
362     }
363      // withdraw stake and get rewards at once
364     function exit() external {
365         withdraw(balanceOf(_msgSender()));
366         getReward();
367     }
368 
369     function calculateFees(uint256 amount) internal pure returns (uint256) {
370         return amount.mul(30).div(1000);
371             
372     }
373     
374     // reward can be withdrawn after 48 hour
375     function getReward() public updateReward(_msgSender()) checkStart {
376         uint256 reward = earned(_msgSender());
377 
378         uint256 leftTimeReward = block.timestamp.sub(lastTimeRewarded[_msgSender()]);
379         require(leftTimeReward >= rewardInterval, "Can claim reward once 48 hour is completed");
380 
381         if (reward > 0) {
382             rewards[_msgSender()] = 0;
383             uint256 trueReward = reward;
384 
385             uint256 fee = calculateFees(trueReward);
386             uint256 rewardMain = trueReward.sub(fee);
387     
388             fast.safeTransfer(_msgSender(), rewardMain);           //------|Transfer reward to Staker|-------------
389             fast.safeTransfer(rewardDistribution, fee);      //-------| Transfer fee to owner |---------------
390 
391             lastTimeRewarded[_msgSender()] = block.timestamp;
392 
393             emit Rewarded(address(this), msg.sender, rewardMain);
394             emit Rewarded(address(this), rewardDistribution, fee);
395         }
396     }
397 
398 
399    
400     function notifyRewardAmount(uint256 reward)
401         external
402         onlyRewardDistribution
403         updateReward(address(0))
404     {
405         if (block.timestamp > starttime) {
406           if (block.timestamp >= periodFinish) {
407               rewardRate = reward.div(DURATION);
408           } else {
409               uint256 remaining = periodFinish.sub(block.timestamp);
410               uint256 leftover = remaining.mul(rewardRate);
411               rewardRate = reward.add(leftover).div(DURATION);
412           }
413           lastUpdateTime = block.timestamp;
414           periodFinish = block.timestamp.add(DURATION);
415           emit RewardAdded(reward);
416         } else {
417           rewardRate = reward.div(DURATION);
418           lastUpdateTime = starttime;
419           periodFinish = starttime.add(DURATION);
420           emit RewardAdded(reward);
421         }
422     }
423 }