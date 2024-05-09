1 // Sources flattened with buidler v1.4.3 https://buidler.dev
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      *
57      * - Addition cannot overflow.
58      */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      *
88      * - Subtraction cannot overflow.
89      */
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      *
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 
192 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
193 
194 pragma solidity ^0.6.0;
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor () internal {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     /**
223      * @dev Returns the address of the current owner.
224      */
225     function owner() public view returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(_owner == _msgSender(), "Ownable: caller is not the owner");
234         _;
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 
261 // File @openzeppelin/contracts/utils/Pausable.sol@v3.1.0
262 
263 pragma solidity ^0.6.0;
264 
265 
266 /**
267  * @dev Contract module which allows children to implement an emergency stop
268  * mechanism that can be triggered by an authorized account.
269  *
270  * This module is used through inheritance. It will make available the
271  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
272  * the functions of your contract. Note that they will not be pausable by
273  * simply including this module, only once the modifiers are put in place.
274  */
275 contract Pausable is Context {
276     /**
277      * @dev Emitted when the pause is triggered by `account`.
278      */
279     event Paused(address account);
280 
281     /**
282      * @dev Emitted when the pause is lifted by `account`.
283      */
284     event Unpaused(address account);
285 
286     bool private _paused;
287 
288     /**
289      * @dev Initializes the contract in unpaused state.
290      */
291     constructor () internal {
292         _paused = false;
293     }
294 
295     /**
296      * @dev Returns true if the contract is paused, and false otherwise.
297      */
298     function paused() public view returns (bool) {
299         return _paused;
300     }
301 
302     /**
303      * @dev Modifier to make a function callable only when the contract is not paused.
304      *
305      * Requirements:
306      *
307      * - The contract must not be paused.
308      */
309     modifier whenNotPaused() {
310         require(!_paused, "Pausable: paused");
311         _;
312     }
313 
314     /**
315      * @dev Modifier to make a function callable only when the contract is paused.
316      *
317      * Requirements:
318      *
319      * - The contract must be paused.
320      */
321     modifier whenPaused() {
322         require(_paused, "Pausable: not paused");
323         _;
324     }
325 
326     /**
327      * @dev Triggers stopped state.
328      *
329      * Requirements:
330      *
331      * - The contract must not be paused.
332      */
333     function _pause() internal virtual whenNotPaused {
334         _paused = true;
335         emit Paused(_msgSender());
336     }
337 
338     /**
339      * @dev Returns to normal state.
340      *
341      * Requirements:
342      *
343      * - The contract must be paused.
344      */
345     function _unpause() internal virtual whenPaused {
346         _paused = false;
347         emit Unpaused(_msgSender());
348     }
349 }
350 
351 
352 // File @animoca/f1dt-ethereum-contracts/contracts/game/TimeTrialEliteLeague.sol@v0.4.0
353 
354 pragma solidity 0.6.8;
355 
356 
357 
358 
359 
360 /// Minimal transfers-only ERC20 interface
361 interface IERC20Transfers {
362     function transfer(address recipient, uint256 amount) external returns (bool);
363     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
364 }
365 
366 struct ParticipantData {
367         uint256 timestamp;
368         uint256 amount;
369     }
370 
371 /**
372  * @title TimeTrialEliteLeague.
373  * Contract which manages the participation status of players to the elite tiers.
374  * Entering a tier requires the participant to escrow some ERC20 gaming token, which
375  * is given back to the participant when they leave the tier.
376  */
377 contract TimeTrialEliteLeague is Context, Pausable, Ownable {
378     using SafeMath for uint256;
379     /**
380      * Event emitted when a player's particiation in a tier is updated.
381      * @param participant The address of the participant.
382      * @param tierId The tier identifier.
383      * @param deposit Amount escrowed in tier. 0 means non participant.
384      */
385     event ParticipationUpdated(address participant, bytes32 tierId, uint256 deposit);
386 
387     IERC20Transfers public immutable gamingToken;
388     uint256 public immutable lockingPeriod;
389     mapping(bytes32 => uint256) public tiers; // tierId => minimumAmountToEscrow
390     mapping(address => mapping(bytes32 => ParticipantData)) public participants; // participant => tierId => ParticipantData
391     /**
392      * @dev Reverts if `gamingToken_` is the zero address.
393      * @dev Reverts if `lockingPeriod` is zero.
394      * @dev Reverts if `tierIds` and `amounts` have different lengths.
395      * @dev Reverts if any element of `amounts` is zero.
396      * @param gamingToken_ An ERC20-compliant contract address.
397      * @param lockingPeriod_ The period that a participant needs to wait for leaving a tier after entering it.
398      * @param tierIds The identifiers of each supported tier.
399      * @param amounts The amounts of gaming token to escrow for participation, for each one of the `tierIds`.
400      */
401     constructor(
402         IERC20Transfers gamingToken_,
403         uint256 lockingPeriod_,
404         bytes32[] memory tierIds,
405         uint256[] memory amounts
406     ) public {
407         require(gamingToken_ != IERC20Transfers(0), "Leagues: zero address");
408         require(lockingPeriod_ != 0, "Leagues: zero lock");
409         gamingToken = gamingToken_;
410         lockingPeriod = lockingPeriod_;
411 
412         uint256 length = tierIds.length;
413         require(length == amounts.length, "Leagues: inconsistent arrays");
414         for (uint256 i = 0; i < length; ++i) {
415             uint256 amount = amounts[i];
416             require(amount != 0, "Leagues: zero amount");
417             tiers[tierIds[i]] = amount;
418         }
419     }
420 
421     /**
422      * Updates amount staked for participant in tier
423      * @dev Reverts if `tierId` does not exist.  
424      * @dev Reverts if user is not in tier.     
425      * @dev Emits a ParticipationUpdated event.
426      * @dev An amount of ERC20 `gamingToken` is transferred from the sender to this contract.
427      * @param tierId The identifier of the tier to increase the deposit for.
428      * @param amount The amount to deposit.
429      */
430     function increaseDeposit(bytes32 tierId, uint256 amount) whenNotPaused public {
431         address sender = _msgSender();
432         require(tiers[tierId] != 0, "Leagues: tier not found");
433         ParticipantData memory pd = participants[sender][tierId];
434         require(pd.timestamp != 0, "Leagues: non participant");
435         uint256 newAmount = amount.add(pd.amount);
436         participants[sender][tierId] = ParticipantData(block.timestamp,newAmount);
437         require(
438             gamingToken.transferFrom(sender, address(this), amount),
439             "Leagues: transfer in failed"
440         );
441         emit ParticipationUpdated(sender, tierId, newAmount);
442     }
443 
444     /**
445      * Enables the participation of a player in a tier. Requires the escrowing of an amount of gaming token.
446      * @dev Reverts if `tierId` does not exist.
447      * @dev Reverts if 'deposit' is less than minimumAmountToEscrow
448      * @dev Reverts if the sender is already participant in the tier.
449      * @dev Emits a ParticipationUpdated event.
450      * @dev An amount of ERC20 `gamingToken` is transferred from the sender to this contract.
451      * @param tierId The identifier of the tier to enter.
452      * @param deposit The amount to deposit.
453      */
454     function enterTier(bytes32 tierId, uint256 deposit) whenNotPaused public {
455         address sender = _msgSender();
456         uint256 minDeposit = tiers[tierId];
457         require(minDeposit != 0, "Leagues: tier not found");
458         require(minDeposit <= deposit, "Leagues: insufficient amount");
459         require(participants[sender][tierId].timestamp == 0, "Leagues: already participant");
460         participants[sender][tierId] = ParticipantData(block.timestamp,deposit);
461         require(
462             gamingToken.transferFrom(sender, address(this), deposit),
463             "Leagues: transfer in failed"
464         );
465         emit ParticipationUpdated(sender, tierId, deposit);
466     }
467 
468     /**
469      * Disables the participation of a player in a tier. Releases the amount of gaming token escrowed for this tier.
470      * @dev Reverts if the sender is not a participant in the tier.
471      * @dev Reverts if the tier participation of the sender is still time-locked.
472      * @dev Emits a ParticipationUpdated event.
473      * @dev An amount of ERC20 `gamingToken` is transferred from this contract to the sender.
474      * @param tierId The identifier of the tier to exit.
475      */
476     function exitTier(bytes32 tierId) public {
477         address sender = _msgSender();
478         ParticipantData memory pd = participants[sender][tierId];
479         require(pd.timestamp != 0, "Leagues: non-participant");
480         
481         require(block.timestamp - pd.timestamp > lockingPeriod, "Leagues: time-locked");
482         participants[sender][tierId] = ParticipantData(0,0);
483         emit ParticipationUpdated(sender, tierId, 0);
484         require(
485             gamingToken.transfer(sender, pd.amount),
486             "Leagues: transfer out failed"
487         );
488     }
489 
490     /**
491      * Gets the partricipation status of several tiers for a participant.
492      * @param participant The participant to check the status of.
493      * @param tierIds The tier identifiers to check.
494      * @return timestamps The enter timestamp for each of the the `tierIds`. Zero values mean non-participant.
495      */
496     function participantStatus(address participant, bytes32[] calldata tierIds)
497         external
498         view
499         returns (uint256[] memory timestamps)
500     {
501         uint256 length = tierIds.length;
502         timestamps = new uint256[](length);
503         for (uint256 i = 0; i < length; ++i) {
504             timestamps[i] = participants[participant][tierIds[i]].timestamp;
505         }
506     }
507 
508      /**
509      * Pauses the deposit operations.
510      * @dev Reverts if the sender is not the contract owner.
511      * @dev Reverts if the contract is paused already.
512      */
513     function pause() external onlyOwner {
514         _pause();
515     }
516 
517     /**
518      * Unpauses the deposit operations.
519      * @dev Reverts if the sender is not the contract owner.
520      * @dev Reverts if the contract is not paused.
521      */
522     function unpause() external onlyOwner {
523         _unpause();
524     }
525 
526 }