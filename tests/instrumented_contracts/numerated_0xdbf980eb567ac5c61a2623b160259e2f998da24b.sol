1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
111      * Reverts when dividing by zero.
112      *
113      * Counterpart to Solidity's `%` operator. This function uses a `revert`
114      * opcode (which leaves remaining gas untouched) while Solidity uses an
115      * invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         return mod(a, b, "SafeMath: modulo by zero");
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts with custom message when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 interface IERC20 {
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 /**
213  * @dev Contract module that helps prevent reentrant calls to a function.
214  *
215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
216  * available, which can be applied to functions to make sure there are no nested
217  * (reentrant) calls to them.
218  *
219  * Note that because there is a single `nonReentrant` guard, functions marked as
220  * `nonReentrant` may not call one another. This can be worked around by making
221  * those functions `private`, and then adding `external` `nonReentrant` entry
222  * points to them.
223  *
224  * TIP: If you would like to learn more about reentrancy and alternative ways
225  * to protect against it, check out our blog post
226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
227  */
228 abstract contract ReentrancyGuard {
229     // Booleans are more expensive than uint256 or any type that takes up a full
230     // word because each write operation emits an extra SLOAD to first read the
231     // slot's contents, replace the bits taken up by the boolean, and then write
232     // back. This is the compiler's defense against contract upgrades and
233     // pointer aliasing, and it cannot be disabled.
234 
235     // The values being non-zero value makes deployment a bit more expensive,
236     // but in exchange the refund on every call to nonReentrant will be lower in
237     // amount. Since refunds are capped to a percentage of the total
238     // transaction's gas, it is best to keep them low in cases like this one, to
239     // increase the likelihood of the full refund coming into effect.
240     uint256 private constant _NOT_ENTERED = 1;
241     uint256 private constant _ENTERED = 2;
242 
243     uint256 private _status;
244 
245     constructor () internal {
246         _status = _NOT_ENTERED;
247     }
248 
249     /**
250      * @dev Prevents a contract from calling itself, directly or indirectly.
251      * Calling a `nonReentrant` function from another `nonReentrant`
252      * function is not supported. It is possible to prevent this from happening
253      * by making the `nonReentrant` function external, and make it call a
254      * `private` function that does the actual work.
255      */
256     modifier nonReentrant() {
257         // On the first call to nonReentrant, _notEntered will be true
258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
259 
260         // Any calls to nonReentrant after this point will fail
261         _status = _ENTERED;
262 
263         _;
264 
265         // By storing the original value once again, a refund is triggered (see
266         // https://eips.ethereum.org/EIPS/eip-2200)
267         _status = _NOT_ENTERED;
268     }
269 }
270 
271 contract LinearVesting is ReentrancyGuard {
272     using SafeMath for uint256;
273 
274     /// @notice event emitted when a vesting schedule is created
275     event ScheduleCreated(address indexed _beneficiary);
276 
277     /// @notice event emitted when a successful drawn down of vesting tokens is made
278     event DrawDown(address indexed _beneficiary, uint256 indexed _amount);
279 
280     /// @notice start of vesting period as a timestamp
281     uint256 public start;
282 
283     /// @notice end of vesting period as a timestamp
284     uint256 public end;
285 
286     /// @notice cliff duration in seconds
287     uint256 public cliffDuration;
288 
289     /// @notice owner address set on construction
290     address public owner;
291 
292     /// @notice amount vested for a beneficiary. Note beneficiary address can not be reused
293     mapping(address => uint256) public vestedAmount;
294 
295     /// @notice cumulative total of tokens drawn down (and transferred from the deposit account) per beneficiary
296     mapping(address => uint256) public totalDrawn;
297 
298     /// @notice last drawn down time (seconds) per beneficiary
299     mapping(address => uint256) public lastDrawnAt;
300 
301     /// @notice ERC20 token we are vesting
302     IERC20 public token;
303 
304     /**
305      * @notice Construct a new vesting contract
306      * @param _token ERC20 token
307      * @param _start start timestamp
308      * @param _end end timestamp
309      * @param _cliffDurationInSecs cliff duration in seconds
310      * @dev caller on constructor set as owner; this can not be changed
311      */
312     constructor(IERC20 _token, uint256 _start, uint256 _end, uint256 _cliffDurationInSecs) public {
313         require(address(_token) != address(0), "VestingContract::constructor: Invalid token");
314         require(_end >= _start, "VestingContract::constructor: Start must be before end");
315 
316         token = _token;
317         owner = msg.sender;
318 
319         start = _start;
320         end = _end;
321         cliffDuration = _cliffDurationInSecs;
322     }
323 
324     /**
325      * @notice Create new vesting schedules in a batch
326      * @notice A transfer is used to bring tokens into the VestingDepositAccount so pre-approval is required
327      * @param _beneficiaries array of beneficiaries of the vested tokens
328      * @param _amounts array of amount of tokens (in wei)
329      * @dev array index of address should be the same as the array index of the amount
330      */
331     function createVestingSchedules(
332         address[] calldata _beneficiaries,
333         uint256[] calldata _amounts
334     ) external returns (bool) {
335         require(msg.sender == owner, "VestingContract::createVestingSchedules: Only Owner");
336         require(_beneficiaries.length > 0, "VestingContract::createVestingSchedules: Empty Data");
337         require(
338             _beneficiaries.length == _amounts.length,
339             "VestingContract::createVestingSchedules: Array lengths do not match"
340         );
341 
342         bool result = true;
343 
344         for(uint i = 0; i < _beneficiaries.length; i++) {
345             address beneficiary = _beneficiaries[i];
346             uint256 amount = _amounts[i];
347             _createVestingSchedule(beneficiary, amount);
348         }
349 
350         return result;
351     }
352 
353     /**
354      * @notice Create a new vesting schedule
355      * @notice A transfer is used to bring tokens into the VestingDepositAccount so pre-approval is required
356      * @param _beneficiary beneficiary of the vested tokens
357      * @param _amount amount of tokens (in wei)
358      */
359     function createVestingSchedule(address _beneficiary, uint256 _amount) external returns (bool) {
360         require(msg.sender == owner, "VestingContract::createVestingSchedule: Only Owner");
361         return _createVestingSchedule(_beneficiary, _amount);
362     }
363 
364     /**
365      * @notice Transfers ownership role
366      * @notice Changes the owner of this contract to a new address
367      * @dev Only owner
368      * @param _newOwner beneficiary to vest remaining tokens to
369      */
370     function transferOwnership(address _newOwner) external {
371         require(msg.sender == owner, "VestingContract::transferOwnership: Only owner");
372         owner = _newOwner;
373     }
374 
375     /**
376      * @notice Draws down any vested tokens due
377      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
378      */
379     function drawDown() nonReentrant external returns (bool) {
380         return _drawDown(msg.sender);
381     }
382 
383 
384     // Accessors
385 
386     /**
387      * @notice Vested token balance for a beneficiary
388      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
389      * @return _tokenBalance total balance proxied via the ERC20 token
390      */
391     function tokenBalance() external view returns (uint256) {
392         return token.balanceOf(address(this));
393     }
394 
395     /**
396      * @notice Vesting schedule and associated data for a beneficiary
397      * @dev Must be called directly by the beneficiary assigned the tokens in the schedule
398      * @return _amount
399      * @return _totalDrawn
400      * @return _lastDrawnAt
401      * @return _remainingBalance
402      */
403     function vestingScheduleForBeneficiary(address _beneficiary)
404     external view
405     returns (uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _remainingBalance) {
406         return (
407         vestedAmount[_beneficiary],
408         totalDrawn[_beneficiary],
409         lastDrawnAt[_beneficiary],
410         vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary])
411         );
412     }
413 
414     /**
415      * @notice Draw down amount currently available (based on the block timestamp)
416      * @param _beneficiary beneficiary of the vested tokens
417      * @return _amount tokens due from vesting schedule
418      */
419     function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount) {
420         return _availableDrawDownAmount(_beneficiary);
421     }
422 
423     /**
424      * @notice Balance remaining in vesting schedule
425      * @param _beneficiary beneficiary of the vested tokens
426      * @return _remainingBalance tokens still due (and currently locked) from vesting schedule
427      */
428     function remainingBalance(address _beneficiary) external view returns (uint256) {
429         return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
430     }
431 
432     // Internal
433 
434     function _createVestingSchedule(address _beneficiary, uint256 _amount) internal returns (bool) {
435         require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");
436         require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");
437 
438         // Ensure one per address
439         require(vestedAmount[_beneficiary] == 0, "VestingContract::createVestingSchedule: Schedule already in flight");
440 
441         vestedAmount[_beneficiary] = _amount;
442 
443         // Vest the tokens into the deposit account and delegate to the beneficiary
444         require(
445             token.transferFrom(msg.sender, address(this), _amount),
446             "VestingContract::createVestingSchedule: Unable to escrow tokens"
447         );
448 
449         emit ScheduleCreated(_beneficiary);
450 
451         return true;
452     }
453 
454     function _drawDown(address _beneficiary) internal returns (bool) {
455         require(vestedAmount[_beneficiary] > 0, "VestingContract::_drawDown: There is no schedule currently in flight");
456 
457         uint256 amount = _availableDrawDownAmount(_beneficiary);
458         require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");
459 
460         // Update last drawn to now
461         lastDrawnAt[_beneficiary] = _getNow();
462 
463         // Increase total drawn amount
464         totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);
465 
466         // Safety measure - this should never trigger
467         require(
468             totalDrawn[_beneficiary] <= vestedAmount[_beneficiary],
469             "VestingContract::_drawDown: Safety Mechanism - Drawn exceeded Amount Vested"
470         );
471 
472         // Issue tokens to beneficiary
473         require(token.transfer(_beneficiary, amount), "VestingContract::_drawDown: Unable to transfer tokens");
474 
475         emit DrawDown(_beneficiary, amount);
476 
477         return true;
478     }
479 
480     function _getNow() internal view returns (uint256) {
481         return block.timestamp;
482     }
483     
484 
485     function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount) {
486 
487         // Cliff Period
488         if (_getNow() <= start.add(cliffDuration)) {
489             // the cliff period has not ended, no tokens to draw down
490             return 0;
491         }
492 
493         // Schedule complete
494         if (_getNow() > end) {
495             return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
496         }
497 
498         // Schedule is active
499 
500         // Work out when the last invocation was
501         uint256 timeLastDrawnOrStart = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];
502 
503         // Find out how much time has past since last invocation
504         uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawnOrStart);
505 
506         // Work out how many due tokens - time passed * rate per second
507         uint256 drawDownRate = vestedAmount[_beneficiary].div(end.sub(start));
508         uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);
509 
510         return amount;
511     }
512 }