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
206 interface IUSDT {
207     function totalSupply() external view returns (uint);
208     function balanceOf(address who) external view returns (uint);
209     function transfer(address to, uint value) external;
210     function allowance(address owner, address spender) external view returns (uint);
211     function transferFrom(address from, address to, uint value) external;
212     function approve(address spender, uint value) external;
213     event Transfer(address indexed from, address indexed to, uint value);
214     event Approval(address indexed owner, address indexed spender, uint value);
215 }
216 
217 // File: @openzeppelin/contracts/utils/Address.sol
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * This test is non-exhaustive, and there may be false-negatives: during the
226      * execution of a contract's constructor, its address will be reported as
227      * not containing a contract.
228      *
229      * IMPORTANT: It is unsafe to assume that an address for which this
230      * function returns false is an externally-owned account (EOA) and not a
231      * contract.
232      */
233     function isContract(address account) internal view returns (bool) {
234         // This method relies in extcodesize, which returns 0 for contracts in
235         // construction, since the code is only stored at the end of the
236         // constructor execution.
237 
238         uint256 size;
239         // solhint-disable-next-line no-inline-assembly
240         assembly { size := extcodesize(account) }
241         return size > 0;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
246 /**
247  * @title SafeERC20
248  * @dev Wrappers around ERC20 operations that throw on failure (when the token
249  * contract returns false). Tokens that return no value (and instead revert or
250  * throw on failure) are also supported, non-reverting calls are assumed to be
251  * successful.
252  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
253  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
254  */
255 library SafeERC20 {
256     using SafeMath for uint256;
257     using Address for address;
258 
259     function safeTransfer(IERC20 token, address to, uint256 value) internal {
260         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
261     }
262 
263     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
264         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
265     }
266 
267     /**
268      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
269      * on the return value: the return value is optional (but if data is returned, it must not be false).
270      * @param token The token targeted by the call.
271      * @param data The call data (encoded using abi.encode or one of its variants).
272      */
273     function callOptionalReturn(IERC20 token, bytes memory data) private {
274         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
275         // we're implementing it ourselves.
276 
277         // A Solidity high level call has three parts:
278         //  1. The target address is checked to verify it contains contract code
279         //  2. The call itself is made, and success asserted
280         //  3. The return value is decoded, which in turn checks the size of the returned data.
281         // solhint-disable-next-line max-line-length
282         require(address(token).isContract(), "SafeERC20: call to non-contract");
283 
284         // solhint-disable-next-line avoid-low-level-calls
285         (bool success, bytes memory returndata) = address(token).call(data);
286       
287         require(success, "SafeERC20: low-level call failed");
288 
289         if (returndata.length > 0) { // Return data is optional
290             // solhint-disable-next-line max-line-length
291             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
292         }
293     }
294 }
295 
296 library SafeUSDT {
297     using SafeMath for uint256;
298     using Address for address;
299 
300     function safeTransfer(IUSDT token, address to, uint256 value) internal {
301         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
302     }
303 
304     function safeTransferFrom(IUSDT token, address from, address to, uint256 value) internal {
305         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
306     }
307 
308     /**
309      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
310      * on the return value: the return value is optional (but if data is returned, it must not be false).
311      * @param token The token targeted by the call.
312      * @param data The call data (encoded using abi.encode or one of its variants).
313      */
314     function callOptionalReturn(IUSDT token, bytes memory data) private {
315         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
316         // we're implementing it ourselves.
317 
318         // A Solidity high level call has three parts:
319         //  1. The target address is checked to verify it contains contract code
320         //  2. The call itself is made, and success asserted
321         //  3. The return value is decoded, which in turn checks the size of the returned data.
322         // solhint-disable-next-line max-line-length
323         require(address(token).isContract(), "SafeERC20: call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = address(token).call(data);
327       
328         require(success, "SafeERC20: low-level call failed");
329 
330         if (returndata.length > 0) { // Return data is optional
331             // solhint-disable-next-line max-line-length
332             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
333         }
334     }
335 }
336 
337 contract IMinableERC20 is IERC20 {
338     function mint(address account, uint amount) public;
339 }
340 
341 contract USDTPool {
342     using SafeMath for uint256;
343     using Address for address;
344     using SafeUSDT for IUSDT;
345     using SafeERC20 for IMinableERC20;
346 
347     IUSDT public stakeToken;
348     IMinableERC20 public rewardToken;
349     
350     bool public started;
351     uint256 public totalSupply;
352     uint256 public rewardFinishTime = 0;
353     uint256 public rewardRate = 0;
354     uint256 public lastUpdateTime;
355     uint256 public rewardPerTokenStored;
356     mapping(address => uint256) public userRewardPerTokenPaid;
357     mapping(address => uint256) public rewards;
358     mapping(address => uint256) public balanceOf;
359     address private governance;
360 
361     event RewardAdded(uint256 reward);
362     event Staked(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);
363     event Withdrawn(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);
364     event RewardPaid(address indexed user, uint256 reward, uint256 beforeT, uint256 afterT);
365 
366     modifier updateReward(address account) {
367         rewardPerTokenStored = rewardPerToken();
368         lastUpdateTime = lastTimeRewardApplicable();
369         if (account != address(0)) {
370             rewards[account] = earned(account);
371             userRewardPerTokenPaid[account] = rewardPerTokenStored;
372         }
373         _;
374     }
375 
376     modifier onlyOwner() {
377         require(msg.sender == governance, "!governance");
378         _;
379     }
380 
381     constructor () public {
382         governance = msg.sender;
383     }
384 
385     function start(address stake_token, address reward_token, uint256 reward, uint256 duration) public onlyOwner {
386         require(!started, "already started");
387         require(stake_token != address(0) && stake_token.isContract(), "stake token is non-contract");
388         require(reward_token != address(0) && reward_token.isContract(), "reward token is non-contract");
389 
390         started = true;
391         stakeToken = IUSDT(stake_token);
392         rewardToken = IMinableERC20(reward_token);
393         rewardRate = reward.mul(1e18).div(duration);
394         lastUpdateTime = block.timestamp;
395         rewardFinishTime = block.timestamp.add(duration);
396     }
397 
398     function lastTimeRewardApplicable() internal view returns (uint256) {
399         return block.timestamp < rewardFinishTime ? block.timestamp : rewardFinishTime;
400     }
401 
402     function rewardPerToken() public view returns (uint256) {
403         if (totalSupply == 0) {
404             return rewardPerTokenStored;
405         }
406         return
407         rewardPerTokenStored.add(
408             lastTimeRewardApplicable()
409             .sub(lastUpdateTime)
410             .mul(rewardRate)
411             .mul(1e18)
412             .div(totalSupply)
413         );
414     }
415 
416     function earned(address account) public view returns (uint256) {
417         return
418         balanceOf[account]
419         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
420         .div(1e18)
421         .add(rewards[account]);
422     }
423 
424     function stake(uint256 amount) public updateReward(msg.sender) {
425         require(started, "Not start yet");
426         require(amount > 0, "Cannot stake 0");
427         require(stakeToken.balanceOf(msg.sender) >= amount, "insufficient balance to stake");
428         uint256 beforeT = stakeToken.balanceOf(address(this));
429         
430         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
431         totalSupply = totalSupply.add(amount);
432         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
433         
434         uint256 afterT = stakeToken.balanceOf(address(this));
435         emit Staked(msg.sender, amount, beforeT, afterT);
436     }
437 
438     function withdraw(uint256 amount) public updateReward(msg.sender) {
439         require(started, "Not start yet");
440         require(amount > 0, "Cannot withdraw 0");
441         require(balanceOf[msg.sender] >= amount, "insufficient balance to withdraw");
442         uint256 beforeT = stakeToken.balanceOf(address(this));
443         
444         totalSupply = totalSupply.sub(amount);
445         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
446         stakeToken.safeTransfer(msg.sender, amount);
447 
448         uint256 afterT = stakeToken.balanceOf(address(this));
449         emit Withdrawn(msg.sender, amount, beforeT, afterT);
450     }
451 
452     function exit() external {
453         require(started, "Not start yet");
454         withdraw(balanceOf[msg.sender]);
455         getReward();
456     }
457 
458     function getReward() public updateReward(msg.sender) {
459         require(started, "Not start yet");
460         
461         uint256 reward = earned(msg.sender);
462         if (reward > 0) {
463             rewards[msg.sender] = 0;
464             uint256 beforeT = rewardToken.balanceOf(address(this));
465             rewardToken.mint(msg.sender, reward);
466             //rewardToken.safeTransfer(msg.sender, reward);
467             uint256 afterT = rewardToken.balanceOf(address(this));
468             emit RewardPaid(msg.sender, reward, beforeT, afterT);
469         }
470     }
471 }