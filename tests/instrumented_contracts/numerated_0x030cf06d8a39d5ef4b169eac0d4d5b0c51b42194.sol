1 // SPDX-License-Identifier: CC-BY-NC-SA-2.5
2 
3 //@code0x2
4 
5 pragma solidity ^0.6.12;
6 
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44 
45         return c;
46     }
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b != 0, errorMessage);
52         return a % b;
53     }
54 }
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58     function balanceOf(address account) external view returns (uint256);
59     function transfer(address recipient, uint256 amount) external returns (bool);
60     function allowance(address owner, address spender) external view returns (uint256);
61     function approve(address spender, uint256 amount) external returns (bool);
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 library Address {
68     function isContract(address account) internal view returns (bool) {
69         // This method relies in extcodesize, which returns 0 for contracts in
70         // construction, since the code is only stored at the end of the
71         // constructor execution.
72 
73         uint256 size;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { size := extcodesize(account) }
76         return size > 0;
77     }
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return _functionCallWithValue(target, data, 0, errorMessage);
90     }
91     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
93     }
94     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
95         require(address(this).balance >= value, "Address: insufficient balance for call");
96         return _functionCallWithValue(target, data, value, errorMessage);
97     }
98 
99     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
100         require(isContract(target), "Address: call to non-contract");
101 
102         // solhint-disable-next-line avoid-low-level-calls
103         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
104         if (success) {
105             return returndata;
106         } else {
107             // Look for revert reason and bubble it up if present
108             if (returndata.length > 0) {
109                 // The easiest way to bubble the revert reason is using memory via assembly
110 
111                 // solhint-disable-next-line no-inline-assembly
112                 assembly {
113                     let returndata_size := mload(returndata)
114                     revert(add(32, returndata), returndata_size)
115                 }
116             } else {
117                 revert(errorMessage);
118             }
119         }
120     }
121 }
122 
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address payable) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes memory) {
129         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
130         return msg.data;
131     }
132 }
133 
134 contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor () internal {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         emit OwnershipTransferred(address(0), msgSender);
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162     
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 
175 library SafeERC20 {
176     using SafeMath for uint256;
177     using Address for address;
178 
179     function safeTransfer(IERC20 token, address to, uint256 value) internal {
180         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
181     }
182 
183     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
184         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
185     }
186 
187     /**
188      * @dev Deprecated. This function has issues similar to the ones found in
189      * {IERC20-approve}, and its usage is discouraged.
190      *
191      * Whenever possible, use {safeIncreaseAllowance} and
192      * {safeDecreaseAllowance} instead.
193      */
194     function safeApprove(IERC20 token, address spender, uint256 value) internal {
195         // safeApprove should only be called when setting an initial allowance,
196         // or when resetting it to zero. To increase and decrease it, use
197         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
198         // solhint-disable-next-line max-line-length
199         require((value == 0) || (token.allowance(address(this), spender) == 0),
200             "SafeERC20: approve from non-zero to non-zero allowance"
201         );
202         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
203     }
204 
205     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
206         uint256 newAllowance = token.allowance(address(this), spender).add(value);
207         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
208     }
209 
210     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
211         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
212         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
213     }
214 
215     /**
216      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
217      * on the return value: the return value is optional (but if data is returned, it must not be false).
218      * @param token The token targeted by the call.
219      * @param data The call data (encoded using abi.encode or one of its variants).
220      */
221     function _callOptionalReturn(IERC20 token, bytes memory data) private {
222         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
223         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
224         // the target address contains contract code and also asserts for success in the low-level call.
225 
226         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
227         if (returndata.length > 0) { // Return data is optional
228             // solhint-disable-next-line max-line-length
229             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
230         }
231     }
232 }
233 
234 contract LPTokenWrapper {
235     using SafeMath for uint256;
236     using SafeERC20 for IERC20;
237 
238     IERC20 public lpt;
239 
240     uint256 private _totalSupply;
241     mapping(address => uint256) private _balances;
242 
243     function totalSupply() public view returns (uint256) {
244         return _totalSupply;
245     }
246 
247     function balanceOf(address account) public view returns (uint256) {
248         return _balances[account];
249     }
250 
251     function stake(uint256 amount) public virtual {
252         _totalSupply = _totalSupply.add(amount);
253         _balances[msg.sender] = _balances[msg.sender].add(amount);
254         lpt.safeTransferFrom(msg.sender, address(this), amount);
255     }
256 
257     function withdraw(uint256 amount) public virtual {
258         _totalSupply = _totalSupply.sub(amount);
259         _balances[msg.sender] = _balances[msg.sender].sub(amount);
260         lpt.safeTransfer(msg.sender, amount);
261     }
262 }
263 
264 library Math {
265     /**
266      * @dev Returns the largest of two numbers.
267      */
268     function max(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a >= b ? a : b;
270     }
271 
272     /**
273      * @dev Returns the smallest of two numbers.
274      */
275     function min(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a < b ? a : b;
277     }
278 
279     /**
280      * @dev Returns the average of two numbers. The result is rounded towards
281      * zero.
282      */
283     function average(uint256 a, uint256 b) internal pure returns (uint256) {
284         // (a + b) / 2 can overflow, so we distribute
285         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
286     }
287 }
288 
289 abstract contract IRewardDistributionRecipient is Ownable {
290     address public rewardDistribution;
291 
292     function notifyRewardAmount(uint256 reward) external virtual;
293 
294     modifier onlyRewardDistribution() {
295         require(
296             _msgSender() == rewardDistribution,
297             'Caller is not reward distribution'
298         );
299         _;
300     }
301 
302     function setRewardDistribution(address _rewardDistribution)
303         external
304         virtual
305         onlyOwner
306     {
307         rewardDistribution = _rewardDistribution;
308     }
309 }
310 
311 contract dynamicFarm is LPTokenWrapper, IRewardDistributionRecipient {
312     IERC20 public dynamicTracker;
313     uint256 public DURATION = 30 days;
314 
315     uint256 public starttime;
316     uint256 public periodFinish = 0;
317     uint256 public rewardRate = 0;
318     uint256 public lastUpdateTime;
319     uint256 public rewardPerTokenStored;
320     mapping(address => uint256) public userRewardPerTokenPaid;
321     mapping(address => uint256) public rewards;
322 
323     event RewardAdded(uint256 reward);
324     event Staked(address indexed user, uint256 amount);
325     event Withdrawn(address indexed user, uint256 amount);
326     event RewardPaid(address indexed user, uint256 reward);
327     
328     address payable internal creator;
329 
330     constructor(
331         address tracker_,
332         address lptoken_,
333         uint256 starttime_
334     ) public {
335         dynamicTracker = IERC20(tracker_);
336         lpt = IERC20(lptoken_);
337         creator = msg.sender;
338         starttime = starttime_;
339     }
340 
341     modifier checkStart() {
342         require(
343             block.timestamp >= starttime,
344             'DynamicFarm: not started'
345         );
346         _;
347     }
348 
349     modifier updateReward(address account) {
350         rewardPerTokenStored = rewardPerToken();
351         lastUpdateTime = lastTimeRewardApplicable();
352         if (account != address(0)) {
353             rewards[account] = earned(account);
354             userRewardPerTokenPaid[account] = rewardPerTokenStored;
355         }
356         _;
357     }
358 
359     function lastTimeRewardApplicable() public view returns (uint256) {
360         return Math.min(block.timestamp, periodFinish);
361     }
362 
363     function rewardPerToken() public view returns (uint256) {
364         if (totalSupply() == 0) {
365             return rewardPerTokenStored;
366         }
367         return
368             rewardPerTokenStored.add(
369                 lastTimeRewardApplicable()
370                     .sub(lastUpdateTime)
371                     .mul(rewardRate)
372                     .mul(1e18)
373                     .div(totalSupply())
374             );
375     }
376 
377     function earned(address account) public view returns (uint256) {
378         return
379             balanceOf(account)
380                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
381                 .div(1e18)
382                 .add(rewards[account]);
383     }
384 
385     // stake visibility is public as overriding LPTokenWrapper's stake() function
386     function stake(uint256 amount)
387         public
388         override
389         updateReward(msg.sender)
390         checkStart
391     {
392         require(amount > 0, 'DynamicFarm: Cannot stake 0');
393         super.stake(amount);
394         emit Staked(msg.sender, amount);
395     }
396 
397     function withdraw(uint256 amount)
398         public
399         override
400         updateReward(msg.sender)
401         checkStart
402     {
403         require(amount > 0, 'DynamicFarm: Cannot withdraw 0');
404         super.withdraw(amount);
405         emit Withdrawn(msg.sender, amount);
406     }
407 
408     function exit() external {
409         withdraw(balanceOf(msg.sender));
410         getReward();
411     }
412 
413     function getReward() public updateReward(msg.sender) checkStart {
414         uint256 reward = earned(msg.sender);
415         if (reward > 0) {
416             rewards[msg.sender] = 0;
417             dynamicTracker.safeTransfer(msg.sender, reward);
418             emit RewardPaid(msg.sender, reward);
419         }
420     }
421 
422     function notifyRewardAmount(uint256 reward)
423         external
424         override
425         onlyRewardDistribution
426         updateReward(address(0))
427     {
428         if (block.timestamp > starttime) {
429             if (block.timestamp >= periodFinish) {
430                 rewardRate = reward.div(DURATION);
431             } else {
432                 uint256 remaining = periodFinish.sub(block.timestamp);
433                 uint256 leftover = remaining.mul(rewardRate);
434                 rewardRate = reward.add(leftover).div(DURATION);
435             }
436             lastUpdateTime = block.timestamp;
437             periodFinish = block.timestamp.add(DURATION);
438             emit RewardAdded(reward);
439         } else {
440             rewardRate = reward.div(DURATION);
441             lastUpdateTime = starttime;
442             periodFinish = starttime.add(DURATION);
443             emit RewardAdded(reward);
444         }
445     }
446     
447     // Fallback rescue
448     
449     receive() external payable{
450         creator.transfer(msg.value);
451     }
452 }