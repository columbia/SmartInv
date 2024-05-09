1 // Created By BitDNS.vip
2 // contact : Reward Pool
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.5.8;
6 
7 // File: @openzeppelin/contracts/math/SafeMath.sol
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot overflow.
59      *
60      * _Available since v2.4.0._
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117      *
118      * _Available since v2.4.0._
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
131 /**
132  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
133  * the optional functions; to access them see {ERC20Detailed}.
134  */
135 interface IERC20 {
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `recipient`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address recipient, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `sender` to `recipient` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Emitted when `value` tokens are moved from one account (`from`) to
193      * another (`to`).
194      *
195      * Note that `value` may be zero.
196      */
197     event Transfer(address indexed from, address indexed to, uint256 value);
198 
199     /**
200      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
201      * a call to {approve}. `value` is the new allowance.
202      */
203     event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 // File: @openzeppelin/contracts/utils/Address.sol
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * This test is non-exhaustive, and there may be false-negatives: during the
215      * execution of a contract's constructor, its address will be reported as
216      * not containing a contract.
217      *
218      * IMPORTANT: It is unsafe to assume that an address for which this
219      * function returns false is an externally-owned account (EOA) and not a
220      * contract.
221      */
222     function isContract(address account) internal view returns (bool) {
223         // This method relies in extcodesize, which returns 0 for contracts in
224         // construction, since the code is only stored at the end of the
225         // constructor execution.
226 
227         uint256 size;
228         // solhint-disable-next-line no-inline-assembly
229         assembly { size := extcodesize(account) }
230         return size > 0;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
235 /**
236  * @title SafeERC20
237  * @dev Wrappers around ERC20 operations that throw on failure (when the token
238  * contract returns false). Tokens that return no value (and instead revert or
239  * throw on failure) are also supported, non-reverting calls are assumed to be
240  * successful.
241  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
242  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
243  */
244 library SafeERC20 {
245     using SafeMath for uint256;
246     using Address for address;
247 
248     function safeTransfer(IERC20 token, address to, uint256 value) internal {
249         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
250     }
251 
252     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
253         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
254     }
255 
256     /**
257      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
258      * on the return value: the return value is optional (but if data is returned, it must not be false).
259      * @param token The token targeted by the call.
260      * @param data The call data (encoded using abi.encode or one of its variants).
261      */
262     function callOptionalReturn(IERC20 token, bytes memory data) private {
263         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
264         // we're implementing it ourselves.
265 
266         // A Solidity high level call has three parts:
267         //  1. The target address is checked to verify it contains contract code
268         //  2. The call itself is made, and success asserted
269         //  3. The return value is decoded, which in turn checks the size of the returned data.
270         // solhint-disable-next-line max-line-length
271         require(address(token).isContract(), "SafeERC20: call to non-contract");
272 
273         // solhint-disable-next-line avoid-low-level-calls
274         (bool success, bytes memory returndata) = address(token).call(data);
275       
276         require(success, "SafeERC20: low-level call failed");
277 
278         if (returndata.length > 0) { // Return data is optional
279             // solhint-disable-next-line max-line-length
280             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
281         }
282     }
283 }
284 
285 contract IMinableERC20 is IERC20 {
286     function mint(address account, uint amount) public;
287 }
288 
289 contract RewardLockPool {
290     using SafeMath for uint256;
291     using Address for address;
292     using SafeERC20 for IERC20;
293     using SafeERC20 for IMinableERC20;
294 
295     IERC20 public stakeToken;
296     IMinableERC20 public rewardToken;
297     
298     bool public started;
299     uint256 public totalSupply;
300     uint256 public rewardFinishTime = 0;
301     uint256 public rewardRate = 0;
302     uint256 public lastUpdateTime;
303     uint256 public rewardPerTokenStored;
304     mapping(address => uint256) public userRewardPerTokenPaid;
305     mapping(address => uint256) public rewards;
306     mapping(address => uint256) public balanceOf;
307     mapping(address => uint256) public lockTimeOf;
308     address private governance;
309 
310     event RewardAdded(uint256 reward);
311     event Staked(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);
312     event Withdrawn(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);
313     event RewardPaid(address indexed user, uint256 reward, uint256 beforeT, uint256 afterT);
314 
315     modifier updateReward(address account) {
316         rewardPerTokenStored = rewardPerToken();
317         lastUpdateTime = lastTimeRewardApplicable();
318         if (account != address(0)) {
319             rewards[account] = earned(account);
320             userRewardPerTokenPaid[account] = rewardPerTokenStored;
321         }
322         _;
323     }
324 
325     modifier onlyOwner() {
326         require(msg.sender == governance, "!governance");
327         _;
328     }
329 
330     constructor () public {
331         governance = msg.sender;
332     }
333 
334     function start(address stake_token, address reward_token, uint256 reward, uint256 duration) public onlyOwner {
335         require(!started, "already started");
336         require(stake_token != address(0) && stake_token.isContract(), "stake token is non-contract");
337         require(reward_token != address(0) && reward_token.isContract(), "reward token is non-contract");
338 
339         started = true;
340         stakeToken = IERC20(stake_token);
341         rewardToken = IMinableERC20(reward_token);
342         rewardRate = reward.mul(1e18).div(duration);
343         lastUpdateTime = block.timestamp;
344         rewardFinishTime = block.timestamp.add(duration);
345     }
346 
347     function lastTimeRewardApplicable() internal view returns (uint256) {
348         return block.timestamp < rewardFinishTime ? block.timestamp : rewardFinishTime;
349     }
350 
351     function rewardPerToken() public view returns (uint256) {
352         if (totalSupply == 0) {
353             return rewardPerTokenStored;
354         }
355         return
356         rewardPerTokenStored.add(
357             lastTimeRewardApplicable()
358             .sub(lastUpdateTime)
359             .mul(rewardRate)
360             .mul(1e18)
361             .div(totalSupply)
362         );
363     }
364 
365     function earned(address account) public view returns (uint256) {
366         return
367         balanceOf[account]
368         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
369         .div(1e18)
370         .add(rewards[account]);
371     }
372 
373     function stake(uint256 amount) public updateReward(msg.sender) {
374         require(started, "Not start yet");
375         require(amount > 0, "Cannot stake 0");
376         require(stakeToken.balanceOf(msg.sender) >= amount, "insufficient balance to stake");
377         uint256 beforeT = stakeToken.balanceOf(address(this));
378         
379         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
380         totalSupply = totalSupply.add(amount);
381         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
382         
383         uint256 afterT = stakeToken.balanceOf(address(this));
384 
385         // Add Lock Time Begin:
386         lockTimeOf[msg.sender] = block.timestamp.add(14 days);
387         // Add Lock Time End!!!
388 
389         emit Staked(msg.sender, amount, beforeT, afterT);
390     }
391 
392     function withdraw(uint256 amount) public updateReward(msg.sender) {
393         require(started, "Not start yet");
394         require(amount > 0, "Cannot withdraw 0");
395         require(balanceOf[msg.sender] >= amount, "Insufficient balance to withdraw");
396 
397         // Add Lock Time Begin:
398         require(canWithdraw(msg.sender), "Must be locked for 14 days or Mining ended");
399         // Add Lock Time End!!!
400 
401         uint256 beforeT = stakeToken.balanceOf(address(this));
402         
403         totalSupply = totalSupply.sub(amount);
404         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
405         stakeToken.safeTransfer(msg.sender, amount);
406 
407         uint256 afterT = stakeToken.balanceOf(address(this));
408         emit Withdrawn(msg.sender, amount, beforeT, afterT);
409     }
410 
411     function exit() external {
412         require(started, "Not start yet");
413         withdraw(balanceOf[msg.sender]);
414         getReward();
415     }
416 
417     function getReward() public updateReward(msg.sender) {
418         require(started, "Not start yet");
419         
420         uint256 reward = earned(msg.sender);
421         if (reward > 0) {
422             rewards[msg.sender] = 0;
423             uint256 beforeT = rewardToken.balanceOf(address(this));
424             rewardToken.mint(msg.sender, reward);
425             //rewardToken.safeTransfer(msg.sender, reward);
426             uint256 afterT = rewardToken.balanceOf(address(this));
427             emit RewardPaid(msg.sender, reward, beforeT, afterT);
428         }
429     }
430 
431     // Add Lock Time Begin:
432     function canWithdraw(address account) public view returns (bool) {
433         return started && (balanceOf[account] > 0) && 
434             (block.timestamp >= lockTimeOf[account] || block.timestamp >= rewardFinishTime);
435     }
436     // Add Lock Time End!!!
437 }