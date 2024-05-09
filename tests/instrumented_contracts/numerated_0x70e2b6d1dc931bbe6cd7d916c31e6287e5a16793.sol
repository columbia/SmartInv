1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/utils/Address.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Collection of functions related to the address type,
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * This test is non-exhaustive, and there may be false-negatives: during the
202      * execution of a contract's constructor, its address will be reported as
203      * not containing a contract.
204      *
205      * > It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies in extcodesize, which returns 0 for contracts in
210         // construction, since the code is only stored at the end of the
211         // constructor execution.
212 
213         uint256 size;
214         // solhint-disable-next-line no-inline-assembly
215         assembly { size := extcodesize(account) }
216         return size > 0;
217     }
218 }
219 
220 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
221 
222 pragma solidity ^0.5.0;
223 
224 
225 
226 
227 /**
228  * @title SafeERC20
229  * @dev Wrappers around ERC20 operations that throw on failure (when the token
230  * contract returns false). Tokens that return no value (and instead revert or
231  * throw on failure) are also supported, non-reverting calls are assumed to be
232  * successful.
233  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
234  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
235  */
236 library SafeERC20 {
237     using SafeMath for uint256;
238     using Address for address;
239 
240     function safeTransfer(IERC20 token, address to, uint256 value) internal {
241         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
242     }
243 
244     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
245         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
246     }
247 
248     function safeApprove(IERC20 token, address spender, uint256 value) internal {
249         // safeApprove should only be called when setting an initial allowance,
250         // or when resetting it to zero. To increase and decrease it, use
251         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
252         // solhint-disable-next-line max-line-length
253         require((value == 0) || (token.allowance(address(this), spender) == 0),
254             "SafeERC20: approve from non-zero to non-zero allowance"
255         );
256         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
257     }
258 
259     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).add(value);
261         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
262     }
263 
264     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
265         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
266         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
267     }
268 
269     /**
270      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
271      * on the return value: the return value is optional (but if data is returned, it must not be false).
272      * @param token The token targeted by the call.
273      * @param data The call data (encoded using abi.encode or one of its variants).
274      */
275     function callOptionalReturn(IERC20 token, bytes memory data) private {
276         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
277         // we're implementing it ourselves.
278 
279         // A Solidity high level call has three parts:
280         //  1. The target address is checked to verify it contains contract code
281         //  2. The call itself is made, and success asserted
282         //  3. The return value is decoded, which in turn checks the size of the returned data.
283         // solhint-disable-next-line max-line-length
284         require(address(token).isContract(), "SafeERC20: call to non-contract");
285 
286         // solhint-disable-next-line avoid-low-level-calls
287         (bool success, bytes memory returndata) = address(token).call(data);
288         require(success, "SafeERC20: low-level call failed");
289 
290         if (returndata.length > 0) { // Return data is optional
291             // solhint-disable-next-line max-line-length
292             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
293         }
294     }
295 }
296 
297 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
298 
299 pragma solidity ^0.5.0;
300 
301 /**
302  * @dev Contract module which provides a basic access control mechanism, where
303  * there is an account (an owner) that can be granted exclusive access to
304  * specific functions.
305  *
306  * This module is used through inheritance. It will make available the modifier
307  * `onlyOwner`, which can be aplied to your functions to restrict their use to
308  * the owner.
309  */
310 contract Ownable {
311     address private _owner;
312 
313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor () internal {
319         _owner = msg.sender;
320         emit OwnershipTransferred(address(0), _owner);
321     }
322 
323     /**
324      * @dev Returns the address of the current owner.
325      */
326     function owner() public view returns (address) {
327         return _owner;
328     }
329 
330     /**
331      * @dev Throws if called by any account other than the owner.
332      */
333     modifier onlyOwner() {
334         require(isOwner(), "Ownable: caller is not the owner");
335         _;
336     }
337 
338     /**
339      * @dev Returns true if the caller is the current owner.
340      */
341     function isOwner() public view returns (bool) {
342         return msg.sender == _owner;
343     }
344 
345     /**
346      * @dev Leaves the contract without owner. It will not be possible to call
347      * `onlyOwner` functions anymore. Can only be called by the current owner.
348      *
349      * > Note: Renouncing ownership will leave the contract without an owner,
350      * thereby removing any functionality that is only available to the owner.
351      */
352     function renounceOwnership() public onlyOwner {
353         emit OwnershipTransferred(_owner, address(0));
354         _owner = address(0);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Can only be called by the current owner.
360      */
361     function transferOwnership(address newOwner) public onlyOwner {
362         _transferOwnership(newOwner);
363     }
364 
365     /**
366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
367      */
368     function _transferOwnership(address newOwner) internal {
369         require(newOwner != address(0), "Ownable: new owner is the zero address");
370         emit OwnershipTransferred(_owner, newOwner);
371         _owner = newOwner;
372     }
373 }
374 
375 // File: openzeppelin-solidity/contracts/drafts/TokenVesting.sol
376 
377 pragma solidity ^0.5.0;
378 
379 
380 
381 
382 /**
383  * @title TokenVesting
384  * @dev A token holder contract that can release its token balance gradually like a
385  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
386  * owner.
387  */
388 contract TokenVesting is Ownable {
389     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
390     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
391     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
392     // cliff period of a year and a duration of four years, are safe to use.
393     // solhint-disable not-rely-on-time
394 
395     using SafeMath for uint256;
396     using SafeERC20 for IERC20;
397 
398     event TokensReleased(address token, uint256 amount);
399     event TokenVestingRevoked(address token);
400 
401     // beneficiary of tokens after they are released
402     address private _beneficiary;
403 
404     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
405     uint256 private _cliff;
406     uint256 private _start;
407     uint256 private _duration;
408 
409     bool private _revocable;
410 
411     mapping (address => uint256) private _released;
412     mapping (address => bool) private _revoked;
413 
414     /**
415      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
416      * beneficiary, gradually in a linear fashion until start + duration. By then all
417      * of the balance will have vested.
418      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
419      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
420      * @param start the time (as Unix time) at which point vesting starts
421      * @param duration duration in seconds of the period in which the tokens will vest
422      * @param revocable whether the vesting is revocable or not
423      */
424     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
425         require(beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
426         // solhint-disable-next-line max-line-length
427         require(cliffDuration <= duration, "TokenVesting: cliff is longer than duration");
428         require(duration > 0, "TokenVesting: duration is 0");
429         // solhint-disable-next-line max-line-length
430         require(start.add(duration) > block.timestamp, "TokenVesting: final time is before current time");
431 
432         _beneficiary = beneficiary;
433         _revocable = revocable;
434         _duration = duration;
435         _cliff = start.add(cliffDuration);
436         _start = start;
437     }
438 
439     /**
440      * @return the beneficiary of the tokens.
441      */
442     function beneficiary() public view returns (address) {
443         return _beneficiary;
444     }
445 
446     /**
447      * @return the cliff time of the token vesting.
448      */
449     function cliff() public view returns (uint256) {
450         return _cliff;
451     }
452 
453     /**
454      * @return the start time of the token vesting.
455      */
456     function start() public view returns (uint256) {
457         return _start;
458     }
459 
460     /**
461      * @return the duration of the token vesting.
462      */
463     function duration() public view returns (uint256) {
464         return _duration;
465     }
466 
467     /**
468      * @return true if the vesting is revocable.
469      */
470     function revocable() public view returns (bool) {
471         return _revocable;
472     }
473 
474     /**
475      * @return the amount of the token released.
476      */
477     function released(address token) public view returns (uint256) {
478         return _released[token];
479     }
480 
481     /**
482      * @return true if the token is revoked.
483      */
484     function revoked(address token) public view returns (bool) {
485         return _revoked[token];
486     }
487 
488     /**
489      * @notice Transfers vested tokens to beneficiary.
490      * @param token ERC20 token which is being vested
491      */
492     function release(IERC20 token) public {
493         uint256 unreleased = _releasableAmount(token);
494 
495         require(unreleased > 0, "TokenVesting: no tokens are due");
496 
497         _released[address(token)] = _released[address(token)].add(unreleased);
498 
499         token.safeTransfer(_beneficiary, unreleased);
500 
501         emit TokensReleased(address(token), unreleased);
502     }
503 
504     /**
505      * @notice Allows the owner to revoke the vesting. Tokens already vested
506      * remain in the contract, the rest are returned to the owner.
507      * @param token ERC20 token which is being vested
508      */
509     function revoke(IERC20 token) public onlyOwner {
510         require(_revocable, "TokenVesting: cannot revoke");
511         require(!_revoked[address(token)], "TokenVesting: token already revoked");
512 
513         uint256 balance = token.balanceOf(address(this));
514 
515         uint256 unreleased = _releasableAmount(token);
516         uint256 refund = balance.sub(unreleased);
517 
518         _revoked[address(token)] = true;
519 
520         token.safeTransfer(owner(), refund);
521 
522         emit TokenVestingRevoked(address(token));
523     }
524 
525     /**
526      * @dev Calculates the amount that has already vested but hasn't been released yet.
527      * @param token ERC20 token which is being vested
528      */
529     function _releasableAmount(IERC20 token) private view returns (uint256) {
530         return _vestedAmount(token).sub(_released[address(token)]);
531     }
532 
533     /**
534      * @dev Calculates the amount that has already vested.
535      * @param token ERC20 token which is being vested
536      */
537     function _vestedAmount(IERC20 token) private view returns (uint256) {
538         uint256 currentBalance = token.balanceOf(address(this));
539         uint256 totalBalance = currentBalance.add(_released[address(token)]);
540 
541         if (block.timestamp < _cliff) {
542             return 0;
543         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
544             return totalBalance;
545         } else {
546             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
547         }
548     }
549 }