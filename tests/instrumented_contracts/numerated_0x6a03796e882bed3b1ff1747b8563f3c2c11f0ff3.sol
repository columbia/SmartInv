1 pragma solidity ^0.5.16;
2 
3 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
4 // Subject to the MIT license.
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, errorMessage);
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot underflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction underflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot underflow.
69      */
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, errorMessage);
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers.
123      * Reverts on division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers.
138      * Reverts with custom message on division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }
187 
188 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
189 // Subject to the MIT license.
190 
191 /**
192  * @dev Contract module that helps prevent reentrant calls to a function.
193  *
194  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
195  * available, which can be applied to functions to make sure there are no nested
196  * (reentrant) calls to them.
197  *
198  * Note that because there is a single `nonReentrant` guard, functions marked as
199  * `nonReentrant` may not call one another. This can be worked around by making
200  * those functions `private`, and then adding `external` `nonReentrant` entry
201  * points to them.
202  */
203 contract ReentrancyGuard {
204     // counter to allow mutex lock with only one SSTORE operation
205     uint256 private _guardCounter;
206 
207     constructor () internal {
208         // The counter starts at one to prevent changing it from zero to a non-zero
209         // value, which is a more expensive operation.
210         _guardCounter = 1;
211     }
212 
213     /**
214      * @dev Prevents a contract from calling itself, directly or indirectly.
215      * Calling a `nonReentrant` function from another `nonReentrant`
216      * function is not supported. It is possible to prevent this from happening
217      * by making the `nonReentrant` function external, and make it call a
218      * `private` function that does the actual work.
219      */
220     modifier nonReentrant() {
221         _guardCounter += 1;
222         uint256 localCounter = _guardCounter;
223         _;
224         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
225     }
226 }
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 /// @author BlockRocket
303 contract VestingContractWithoutDelegation is ReentrancyGuard {
304     using SafeMath for uint256;
305 
306     /// @notice event emitted when a vesting schedule is created
307     event ScheduleCreated(address indexed _beneficiary);
308 
309     /// @notice event emitted when a successful drawn down of vesting tokens is made
310     event DrawDown(address indexed _beneficiary, uint256 indexed _amount);
311 
312     /// @notice start of vesting period as a timestamp
313     uint256 public start;
314 
315     /// @notice end of vesting period as a timestamp
316     uint256 public end;
317 
318     /// @notice cliff duration in seconds
319     uint256 public cliffDuration;
320 
321     /// @notice owner address set on construction
322     address public owner;
323 
324     /// @notice amount vested for a beneficiary. Note beneficiary address can not be reused
325     mapping(address => uint256) public vestedAmount;
326 
327     /// @notice cumulative total of tokens drawn down (and transferred from the deposit account) per beneficiary
328     mapping(address => uint256) public totalDrawn;
329 
330     /// @notice last drawn down time (seconds) per beneficiary
331     mapping(address => uint256) public lastDrawnAt;
332 
333     /// @notice ERC20 token we are vesting
334     IERC20 public token;
335 
336     /**
337      * @notice Construct a new vesting contract
338      * @param _token ERC20 token
339      * @param _start start timestamp
340      * @param _end end timestamp
341      * @param _cliffDurationInSecs cliff duration in seconds
342      * @dev caller on constructor set as owner; this can not be changed
343      */
344     constructor(IERC20 _token, uint256 _start, uint256 _end, uint256 _cliffDurationInSecs) public {
345         require(address(_token) != address(0), "VestingContract::constructor: Invalid token");
346         require(_end >= _start, "VestingContract::constructor: Start must be before end");
347 
348         token = _token;
349         owner = msg.sender;
350 
351         start = _start;
352         end = _end;
353         cliffDuration = _cliffDurationInSecs;
354     }
355 
356     /**
357      * @notice Create new vesting schedules in a batch
358      * @notice A transfer is used to bring tokens into the VestingDepositAccount so pre-approval is required
359      * @param _beneficiaries array of beneficiaries of the vested tokens
360      * @param _amounts array of amount of tokens (in wei)
361      * @dev array index of address should be the same as the array index of the amount
362      */
363     function createVestingSchedules(
364         address[] calldata _beneficiaries,
365         uint256[] calldata _amounts
366     ) external returns (bool) {
367         require(msg.sender == owner, "VestingContract::createVestingSchedules: Only Owner");
368         require(_beneficiaries.length > 0, "VestingContract::createVestingSchedules: Empty Data");
369         require(
370             _beneficiaries.length == _amounts.length,
371             "VestingContract::createVestingSchedules: Array lengths do not match"
372         );
373 
374         bool result = true;
375 
376         for(uint i = 0; i < _beneficiaries.length; i++) {
377             address beneficiary = _beneficiaries[i];
378             uint256 amount = _amounts[i];
379             _createVestingSchedule(beneficiary, amount);
380         }
381 
382         return result;
383     }
384 
385     /**
386      * @notice Create a new vesting schedule
387      * @notice A transfer is used to bring tokens into the VestingDepositAccount so pre-approval is required
388      * @param _beneficiary beneficiary of the vested tokens
389      * @param _amount amount of tokens (in wei)
390      */
391     function createVestingSchedule(address _beneficiary, uint256 _amount) external returns (bool) {
392         require(msg.sender == owner, "VestingContract::createVestingSchedule: Only Owner");
393         return _createVestingSchedule(_beneficiary, _amount);
394     }
395 
396     /**
397      * @notice Transfers ownership role
398      * @notice Changes the owner of this contract to a new address
399      * @dev Only owner
400      * @param _newOwner beneficiary to vest remaining tokens to
401      */
402     function transferOwnership(address _newOwner) external {
403         require(msg.sender == owner, "VestingContract::transferOwnership: Only owner");
404         owner = _newOwner;
405     }
406 
407     /**
408      * @notice Draws down any vested tokens due
409      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
410      */
411     function drawDown() nonReentrant external returns (bool) {
412         return _drawDown(msg.sender);
413     }
414 
415 
416     // Accessors
417 
418     /**
419      * @notice Vested token balance for a beneficiary
420      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
421      * @return _tokenBalance total balance proxied via the ERC20 token
422      */
423     function tokenBalance() external view returns (uint256) {
424         return token.balanceOf(address(this));
425     }
426 
427     /**
428      * @notice Vesting schedule and associated data for a beneficiary
429      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
430      * @return _amount
431      * @return _totalDrawn
432      * @return _lastDrawnAt
433      * @return _remainingBalance
434      */
435     function vestingScheduleForBeneficiary(address _beneficiary)
436     external view
437     returns (uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _remainingBalance) {
438         return (
439         vestedAmount[_beneficiary],
440         totalDrawn[_beneficiary],
441         lastDrawnAt[_beneficiary],
442         vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary])
443         );
444     }
445 
446     /**
447      * @notice Draw down amount currently available (based on the block timestamp)
448      * @param _beneficiary beneficiary of the vested tokens
449      * @return _amount tokens due from vesting schedule
450      */
451     function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount) {
452         return _availableDrawDownAmount(_beneficiary);
453     }
454 
455     /**
456      * @notice Balance remaining in vesting schedule
457      * @param _beneficiary beneficiary of the vested tokens
458      * @return _remainingBalance tokens still due (and currently locked) from vesting schedule
459      */
460     function remainingBalance(address _beneficiary) external view returns (uint256) {
461         return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
462     }
463 
464     // Internal
465 
466     function _createVestingSchedule(address _beneficiary, uint256 _amount) internal returns (bool) {
467         require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");
468         require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");
469 
470         // Ensure one per address
471         require(vestedAmount[_beneficiary] == 0, "VestingContract::createVestingSchedule: Schedule already in flight");
472 
473         vestedAmount[_beneficiary] = _amount;
474 
475         // Vest the tokens into the deposit account and delegate to the beneficiary
476         require(
477             token.transferFrom(msg.sender, address(this), _amount),
478             "VestingContract::createVestingSchedule: Unable to escrow tokens"
479         );
480 
481         emit ScheduleCreated(_beneficiary);
482 
483         return true;
484     }
485 
486     function _drawDown(address _beneficiary) internal returns (bool) {
487         require(vestedAmount[_beneficiary] > 0, "VestingContract::_drawDown: There is no schedule currently in flight");
488 
489         uint256 amount = _availableDrawDownAmount(_beneficiary);
490         require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");
491 
492         // Update last drawn to now
493         lastDrawnAt[_beneficiary] = _getNow();
494 
495         // Increase total drawn amount
496         totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);
497 
498         // Safety measure - this should never trigger
499         require(
500             totalDrawn[_beneficiary] <= vestedAmount[_beneficiary],
501             "VestingContract::_drawDown: Safety Mechanism - Drawn exceeded Amount Vested"
502         );
503 
504         // Issue tokens to beneficiary
505         require(token.transfer(_beneficiary, amount), "VestingContract::_drawDown: Unable to transfer tokens");
506 
507         emit DrawDown(_beneficiary, amount);
508 
509         return true;
510     }
511 
512     function _getNow() internal view returns (uint256) {
513         return block.timestamp;
514     }
515 
516     function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount) {
517 
518         // Cliff Period
519         if (_getNow() <= start.add(cliffDuration)) {
520             // the cliff period has not ended, no tokens to draw down
521             return 0;
522         }
523 
524         // Schedule complete
525         if (_getNow() > end) {
526             return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
527         }
528 
529         // Schedule is active
530 
531         // Work out when the last invocation was
532         uint256 timeLastDrawnOrStart = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];
533 
534         // Find out how much time has past since last invocation
535         uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawnOrStart);
536 
537         // Work out how many due tokens - time passed * rate per second
538         uint256 drawDownRate = vestedAmount[_beneficiary].div(end.sub(start));
539         uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);
540 
541         return amount;
542     }
543 }