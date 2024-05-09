1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 contract Pausable is Context {
17     /**
18      * @dev Emitted when the pause is triggered by `account`.
19      */
20     event Paused(address account);
21 
22     /**
23      * @dev Emitted when the pause is lifted by `account`.
24      */
25     event Unpaused(address account);
26 
27     bool private _paused;
28 
29     /**
30      * @dev Initializes the contract in unpaused state.
31      */
32     constructor () internal {
33         _paused = false;
34     }
35 
36     /**
37      * @dev Returns true if the contract is paused, and false otherwise.
38      */
39     function paused() public view returns (bool) {
40         return _paused;
41     }
42 
43     /**
44      * @dev Modifier to make a function callable only when the contract is not paused.
45      *
46      * Requirements:
47      *
48      * - The contract must not be paused.
49      */
50     modifier whenNotPaused() {
51         require(!_paused, "Pausable: paused");
52         _;
53     }
54 
55     /**
56      * @dev Modifier to make a function callable only when the contract is paused.
57      *
58      * Requirements:
59      *
60      * - The contract must be paused.
61      */
62     modifier whenPaused() {
63         require(_paused, "Pausable: not paused");
64         _;
65     }
66 
67     /**
68      * @dev Triggers stopped state.
69      *
70      * Requirements:
71      *
72      * - The contract must not be paused.
73      */
74     function _pause() internal virtual whenNotPaused {
75         _paused = true;
76         emit Paused(_msgSender());
77     }
78 
79     /**
80      * @dev Returns to normal state.
81      *
82      * Requirements:
83      *
84      * - The contract must be paused.
85      */
86     function _unpause() internal virtual whenPaused {
87         _paused = false;
88         emit Unpaused(_msgSender());
89     }
90 }
91 
92 
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
113         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
114         // for accounts without code, i.e. `keccak256('')`
115         bytes32 codehash;
116         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
117         // solhint-disable-next-line no-inline-assembly
118         assembly { codehash := extcodehash(account) }
119         return (codehash != accountHash && codehash != 0x0);
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
142         (bool success, ) = recipient.call{ value: amount }("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain`call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165       return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
175         return _functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         return _functionCallWithValue(target, data, value, errorMessage);
202     }
203 
204     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
205         require(isContract(target), "Address: call to non-contract");
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 // solhint-disable-next-line no-inline-assembly
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 library SafeMath {
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      *
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, "SafeMath: addition overflow");
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         uint256 c = a - b;
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, reverting on
280      * overflow.
281      *
282      * Counterpart to Solidity's `*` operator.
283      *
284      * Requirements:
285      *
286      * - Multiplication cannot overflow.
287      */
288     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
289         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
290         // benefit is lost if 'b' is also tested.
291         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
292         if (a == 0) {
293             return 0;
294         }
295 
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         return div(a, b, "SafeMath: division by zero");
316     }
317 
318     /**
319      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
320      * division by zero. The result is rounded towards zero.
321      *
322      * Counterpart to Solidity's `/` operator. Note: this function uses a
323      * `revert` opcode (which leaves remaining gas untouched) while Solidity
324      * uses an invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b > 0, errorMessage);
332         uint256 c = a / b;
333         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         return mod(a, b, "SafeMath: modulo by zero");
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * Reverts with custom message when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b != 0, errorMessage);
368         return a % b;
369     }
370 }
371 
372 
373 interface IERC20 {
374     
375     function name() external view returns (string memory);
376 
377     function symbol() external view returns (string memory);
378 
379     function decimals() external view returns (uint8);
380 
381     function totalSupply() external view returns (uint);
382 
383     function balanceOf(address owner) external view returns (uint);
384 
385     function allowance(address owner, address spender) external view returns (uint);
386 
387     function transfer(address to, uint value) external returns (bool);
388 
389     function approve(address spender, uint value) external returns (bool);
390 
391     function transferFrom(
392         address from,
393         address to,
394         uint value
395     ) external returns (bool);
396 
397     event Transfer(address indexed from, address indexed to, uint value);
398 
399     event Approval(address indexed owner, address indexed spender, uint value);
400 }
401 
402 
403 contract LnAdmin {
404     address public admin;
405     address public candidate;
406 
407     constructor(address _admin) public {
408         require(_admin != address(0), "admin address cannot be 0");
409         admin = _admin;
410         emit AdminChanged(address(0), _admin);
411     }
412 
413     function setCandidate(address _candidate) external onlyAdmin {
414         address old = candidate;
415         candidate = _candidate;
416         emit candidateChanged( old, candidate);
417     }
418 
419     function becomeAdmin( ) external {
420         require( msg.sender == candidate, "Only candidate can become admin");
421         address old = admin;
422         admin = candidate;
423         emit AdminChanged( old, admin ); 
424     }
425 
426     modifier onlyAdmin {
427         require( (msg.sender == admin), "Only the contract admin can perform this action");
428         _;
429     }
430 
431     event candidateChanged(address oldCandidate, address newCandidate );
432     event AdminChanged(address oldAdmin, address newAdmin);
433 }
434 
435 
436 
437 // approve
438 contract LnTokenLocker is LnAdmin, Pausable {
439     using SafeMath for uint;
440 
441     IERC20 private token;
442     struct LockInfo {
443         uint256 amount;
444         uint256 lockTimestamp; // lock time at block.timestamp
445         uint256 lockDays;
446         uint256 claimedAmount;
447     }
448     mapping (address => LockInfo) public lockData;
449     
450     constructor(address _token, address _admin) public LnAdmin(_admin) {
451         token = IERC20(_token);
452     }
453     
454     function sendLockTokenMany(address[] calldata _users, uint256[] calldata _amounts, uint256[] calldata _lockdays) external onlyAdmin {
455         require(_users.length == _amounts.length, "array length not eq");
456         require(_users.length == _lockdays.length, "array length not eq");
457         for (uint256 i=0; i < _users.length; i++) {
458             sendLockToken(_users[i], _amounts[i], _lockdays[i]);
459         }
460     }
461 
462     // 1. msg.sender/admin approve many token to this contract
463     function sendLockToken(address _user, uint256 _amount, uint256 _lockdays) public onlyAdmin returns (bool) {
464         require(_amount > 0, "amount can not zero");
465         require(lockData[_user].amount == 0, "this address has locked");
466         require(_lockdays > 0, "lock days need more than zero");
467         
468         LockInfo memory lockinfo = LockInfo({
469             amount:_amount,
470             lockTimestamp:block.timestamp,
471             lockDays:_lockdays,
472             claimedAmount:0
473         });
474 
475         lockData[_user] = lockinfo;
476         return true;
477     }
478     
479     function claimToken(uint256 _amount) external returns (uint256) {
480         require(_amount > 0, "Invalid parameter amount");
481         address _user = msg.sender;
482         require(lockData[_user].amount > 0, "No lock token to claim");
483 
484         uint256 passdays = block.timestamp.sub(lockData[_user].lockTimestamp).div(1 days);
485         require(passdays > 0, "need wait for one day at least");
486 
487         uint256 available = 0;
488         if (passdays >= lockData[_user].lockDays) {
489             available = lockData[_user].amount;
490         } else {
491             available = lockData[_user].amount.div(lockData[_user].lockDays).mul(passdays);
492         }
493         available = available.sub(lockData[_user].claimedAmount);
494         require(available > 0, "not available claim");
495         //require(_amount <= available, "insufficient available");
496         uint256 claim = _amount;
497         if (_amount > available) { // claim as much as possible
498             claim = available;
499         }
500 
501         lockData[_user].claimedAmount = lockData[_user].claimedAmount.add(claim);
502 
503         token.transfer(_user, claim);
504 
505         return claim;
506     }
507 }
508 
509 
510 
511 contract LnTokenCliffLocker is LnAdmin, Pausable {
512     using SafeMath for uint;
513 
514     IERC20 private token;
515     struct LockInfo {
516         uint256 amount;
517         uint256 lockTimestamp; // lock time at block.timestamp
518         uint256 claimedAmount;
519     }
520     mapping (address => LockInfo) public lockData;
521     
522     constructor(address _token, address _admin) public LnAdmin(_admin) {
523         token = IERC20(_token);
524     }
525     
526     function sendLockTokenMany(address[] calldata _users, uint256[] calldata _amounts, uint256[] calldata _locktimes) external onlyAdmin {
527         require(_users.length == _amounts.length, "array length not eq");
528         require(_users.length == _locktimes.length, "array length not eq");
529         for (uint256 i=0; i < _users.length; i++) {
530             sendLockToken(_users[i], _amounts[i], _locktimes[i]);
531         }
532     }
533 
534     function avaible(address _user ) external view returns( uint256 ){
535         require(lockData[_user].amount > 0, "No lock token to claim");
536         if( now < lockData[_user].lockTimestamp ){
537             return 0;
538         }
539 
540         uint256 available = 0;
541         available = lockData[_user].amount;
542         available = available.sub(lockData[_user].claimedAmount);
543         return available;
544     }
545 
546     // 1. msg.sender/admin approve many token to this contract
547     function sendLockToken(address _user, uint256 _amount, uint256 _locktimes ) public onlyAdmin returns (bool) {
548         require(_amount > 0, "amount can not zero");
549         require(lockData[_user].amount == 0, "this address has locked");
550         require(_locktimes > 0, "lock days need more than zero");
551         
552         LockInfo memory lockinfo = LockInfo({
553             amount:_amount,
554             lockTimestamp:_locktimes,
555             claimedAmount:0
556         });
557 
558         lockData[_user] = lockinfo;
559         return true;
560     }
561     
562     function claimToken(uint256 _amount) external returns (uint256) {
563         require(_amount > 0, "Invalid parameter amount");
564         address _user = msg.sender;
565         require(lockData[_user].amount > 0, "No lock token to claim");
566         require( now >= lockData[_user].lockTimestamp, "Not time to claim" );
567 
568         uint256 available = 0;
569         available = lockData[_user].amount;
570         available = available.sub(lockData[_user].claimedAmount);
571         require(available > 0, "not available claim");
572 
573         uint256 claim = _amount;
574         if (_amount > available) { // claim as much as possible
575             claim = available;
576         }
577 
578         lockData[_user].claimedAmount = lockData[_user].claimedAmount.add(claim);
579 
580         token.transfer(_user, claim);
581 
582         return claim;
583     }
584 }