1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 pragma solidity ^0.5.2;
47 
48 
49 contract PauserRole {
50     using Roles for Roles.Role;
51 
52     event PauserAdded(address indexed account);
53     event PauserRemoved(address indexed account);
54 
55     Roles.Role private _pausers;
56 
57     constructor () internal {
58         _addPauser(msg.sender);
59     }
60 
61     modifier onlyPauser() {
62         require(isPauser(msg.sender));
63         _;
64     }
65 
66     function isPauser(address account) public view returns (bool) {
67         return _pausers.has(account);
68     }
69 
70     function addPauser(address account) public onlyPauser {
71         _addPauser(account);
72     }
73 
74     function renouncePauser() public {
75         _removePauser(msg.sender);
76     }
77 
78     function _addPauser(address account) internal {
79         _pausers.add(account);
80         emit PauserAdded(account);
81     }
82 
83     function _removePauser(address account) internal {
84         _pausers.remove(account);
85         emit PauserRemoved(account);
86     }
87 }
88 
89 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
90 
91 pragma solidity ^0.5.2;
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is PauserRole {
99     event Paused(address account);
100     event Unpaused(address account);
101 
102     bool private _paused;
103 
104     constructor () internal {
105         _paused = false;
106     }
107 
108     /**
109      * @return true if the contract is paused, false otherwise.
110      */
111     function paused() public view returns (bool) {
112         return _paused;
113     }
114 
115     /**
116      * @dev Modifier to make a function callable only when the contract is not paused.
117      */
118     modifier whenNotPaused() {
119         require(!_paused);
120         _;
121     }
122 
123     /**
124      * @dev Modifier to make a function callable only when the contract is paused.
125      */
126     modifier whenPaused() {
127         require(_paused);
128         _;
129     }
130 
131     /**
132      * @dev called by the owner to pause, triggers stopped state
133      */
134     function pause() public onlyPauser whenNotPaused {
135         _paused = true;
136         emit Paused(msg.sender);
137     }
138 
139     /**
140      * @dev called by the owner to unpause, returns to normal state
141      */
142     function unpause() public onlyPauser whenPaused {
143         _paused = false;
144         emit Unpaused(msg.sender);
145     }
146 }
147 
148 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
149 
150 pragma solidity ^0.5.2;
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://eips.ethereum.org/EIPS/eip-20
155  */
156 interface IERC20 {
157     function transfer(address to, uint256 value) external returns (bool);
158 
159     function approve(address spender, uint256 value) external returns (bool);
160 
161     function transferFrom(address from, address to, uint256 value) external returns (bool);
162 
163     function totalSupply() external view returns (uint256);
164 
165     function balanceOf(address who) external view returns (uint256);
166 
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
175 
176 pragma solidity ^0.5.2;
177 
178 /**
179  * @title SafeMath
180  * @dev Unsigned math operations with safety checks that revert on error
181  */
182 library SafeMath {
183     /**
184      * @dev Multiplies two unsigned integers, reverts on overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b);
196 
197         return c;
198     }
199 
200     /**
201      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Solidity only automatically asserts when dividing by 0
205         require(b > 0);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         require(b <= a);
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223      * @dev Adds two unsigned integers, reverts on overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a);
228 
229         return c;
230     }
231 
232     /**
233      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
234      * reverts when dividing by zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b != 0);
238         return a % b;
239     }
240 }
241 
242 // File: openzeppelin-solidity/contracts/utils/Address.sol
243 
244 pragma solidity ^0.5.2;
245 
246 /**
247  * Utility library of inline functions on addresses
248  */
249 library Address {
250     /**
251      * Returns whether the target address is a contract
252      * @dev This function will return false if invoked during the constructor of a contract,
253      * as the code is not actually created until after the constructor finishes.
254      * @param account address of the account to check
255      * @return whether the target address is a contract
256      */
257     function isContract(address account) internal view returns (bool) {
258         uint256 size;
259         // XXX Currently there is no better way to check if there is a contract in an address
260         // than to check the size of the code at that address.
261         // See https://ethereum.stackexchange.com/a/14016/36603
262         // for more details about how this works.
263         // TODO Check this again before the Serenity release, because all addresses will be
264         // contracts then.
265         // solhint-disable-next-line no-inline-assembly
266         assembly { size := extcodesize(account) }
267         return size > 0;
268     }
269 }
270 
271 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
272 
273 pragma solidity ^0.5.2;
274 
275 
276 
277 
278 /**
279  * @title SafeERC20
280  * @dev Wrappers around ERC20 operations that throw on failure (when the token
281  * contract returns false). Tokens that return no value (and instead revert or
282  * throw on failure) are also supported, non-reverting calls are assumed to be
283  * successful.
284  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
285  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
286  */
287 library SafeERC20 {
288     using SafeMath for uint256;
289     using Address for address;
290 
291     function safeTransfer(IERC20 token, address to, uint256 value) internal {
292         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
293     }
294 
295     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
296         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
297     }
298 
299     function safeApprove(IERC20 token, address spender, uint256 value) internal {
300         // safeApprove should only be called when setting an initial allowance,
301         // or when resetting it to zero. To increase and decrease it, use
302         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
303         require((value == 0) || (token.allowance(address(this), spender) == 0));
304         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
305     }
306 
307     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
308         uint256 newAllowance = token.allowance(address(this), spender).add(value);
309         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
310     }
311 
312     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
313         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
314         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
315     }
316 
317     /**
318      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
319      * on the return value: the return value is optional (but if data is returned, it must equal true).
320      * @param token The token targeted by the call.
321      * @param data The call data (encoded using abi.encode or one of its variants).
322      */
323     function callOptionalReturn(IERC20 token, bytes memory data) private {
324         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
325         // we're implementing it ourselves.
326 
327         // A Solidity high level call has three parts:
328         //  1. The target address is checked to verify it contains contract code
329         //  2. The call itself is made, and success asserted
330         //  3. The return value is decoded, which in turn checks the size of the returned data.
331 
332         require(address(token).isContract());
333 
334         // solhint-disable-next-line avoid-low-level-calls
335         (bool success, bytes memory returndata) = address(token).call(data);
336         require(success);
337 
338         if (returndata.length > 0) { // Return data is optional
339             require(abi.decode(returndata, (bool)));
340         }
341     }
342 }
343 
344 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
345 
346 pragma solidity ^0.5.2;
347 
348 /**
349  * @title Helps contracts guard against reentrancy attacks.
350  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
351  * @dev If you mark a function `nonReentrant`, you should also
352  * mark it `external`.
353  */
354 contract ReentrancyGuard {
355     /// @dev counter to allow mutex lock with only one SSTORE operation
356     uint256 private _guardCounter;
357 
358     constructor () internal {
359         // The counter starts at one to prevent changing it from zero to a non-zero
360         // value, which is a more expensive operation.
361         _guardCounter = 1;
362     }
363 
364     /**
365      * @dev Prevents a contract from calling itself, directly or indirectly.
366      * Calling a `nonReentrant` function from another `nonReentrant`
367      * function is not supported. It is possible to prevent this from happening
368      * by making the `nonReentrant` function external, and make it call a
369      * `private` function that does the actual work.
370      */
371     modifier nonReentrant() {
372         _guardCounter += 1;
373         uint256 localCounter = _guardCounter;
374         _;
375         require(localCounter == _guardCounter);
376     }
377 }
378 
379 // File: contracts/interfaces/IRewards.sol
380 
381 pragma solidity 0.5.4;
382 
383 
384 interface IRewards {
385     event Deposited(address indexed from, uint amount);
386     event Withdrawn(address indexed from, uint amount);
387     event Reclaimed(uint amount);
388 
389     function deposit(uint amount) external;
390     function withdraw() external;
391     function reclaimRewards() external;
392     function claimedRewards(address payee) external view returns (uint);
393     function unclaimedRewards(address payee) external view returns (uint);
394     function supply() external view returns (uint);
395     function isRunning() external view returns (bool);
396 }
397 
398 // File: contracts/rewards/RewardsFaucet.sol
399 
400 pragma solidity 0.5.4;
401 
402 
403 
404 
405 
406 
407 
408 
409 contract RewardsFaucet is Pausable, ReentrancyGuard {
410     event Released(address indexed from, uint amount);
411 
412     using SafeERC20 for IERC20;
413     using SafeMath for uint;
414 
415     IRewards public rewards; // contract
416     IERC20 public rewardsToken; // PAY tokens
417 
418     address public fundingSource; // Where PAY tokens are approved from
419     uint public start; // Vesting period start timestamp in seconds since the epoch
420     uint public duration; // Vesting period duration timestamp in seconds
421     uint public totalAmount; // 4M PAY tokens
422     uint public totalReleased;
423 
424     constructor(IRewards _rewards, IERC20 _rewardsToken, address _fundingSource, uint _totalAmount, uint _start, uint _duration) public {
425         require(_fundingSource != address(0), "Funding source cannot be zero address.");
426         require(_totalAmount > 0, "Total Amount cannot be zero.");
427 
428         rewards = _rewards;
429         rewardsToken = _rewardsToken;
430         fundingSource = _fundingSource;
431         totalAmount = _totalAmount;
432         start = _start;
433         duration = _duration;
434     }
435 
436     function () external payable { // Ether fallback function
437         require(msg.value == 0, "Received non-zero msg.value.");
438         release(); // solhint-disable-line
439     }
440 
441     /**
442     * @notice Release pending rewards
443     */
444     function release() public nonReentrant whenNotPaused {
445         uint amount = releasableAmount();
446         rewardsToken.safeTransferFrom(fundingSource, address(this), amount); // Top up this contract
447 
448         totalReleased = totalReleased.add(amount);
449         emit Released(msg.sender, amount);
450         rewardsToken.safeIncreaseAllowance(address(rewards), amount); // Approve funds to be taken from this contract
451         rewards.deposit(amount); // TransferFrom funds to the Rewards pool
452     }
453 
454     /**
455     * @notice Returns amount that can be released so far
456     */
457     function releasableAmount() public view returns (uint) {
458         return vestedAmount().sub(totalReleased);
459     }
460 
461     /**
462     * @notice Calculate amount of rewards vested so far
463     */
464     function vestedAmount() public view returns (uint) {
465         if (block.timestamp <= start) {
466             return 0;
467         } else if (block.timestamp >= start.add(duration)) {
468             return totalAmount;
469         } else {
470             return totalAmount.mul(vestedTime()).div(duration);
471         }
472     }
473 
474     /**
475     * @notice Returns amount of time passed since start
476     */
477     function vestedTime() public view returns (uint) {
478         uint currentTime = block.timestamp;
479         return currentTime.sub(start);
480     }
481 
482     function allowance() public view returns (uint) {
483         return rewardsToken.allowance(fundingSource, address(this));
484     }
485 }