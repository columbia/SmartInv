1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 // File: contracts/utils/SafeMath.sol
17 
18 // From
19 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ccf79ee483b12fb9759dc5bb5f947a31aa0a3bd6/contracts/math/SafeMath.sol
20 
21 pragma solidity ^0.6.0;
22 
23 /**
24  * @dev Wrappers over Solidity's arithmetic operations with added overflow
25  * checks.
26  *
27  * Arithmetic operations in Solidity wrap on overflow. This can easily result
28  * in bugs, because programmers usually assume that an overflow raises an
29  * error, which is the standard behavior in high level programming languages.
30  * `SafeMath` restores this intuition by reverting the transaction when an
31  * operation overflows.
32  *
33  * Using this library instead of the unchecked operations eliminates an entire
34  * class of bugs, so it's recommended to use it always.
35  */
36 library SafeMath {
37     /**
38      * @dev Returns the addition of two unsigned integers, reverting on
39      * overflow.
40      *
41      * Counterpart to Solidity's `+` operator.
42      *
43      * Requirements:
44      *
45      * - Addition cannot overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
70      * overflow (when the result is negative).
71      *
72      * Counterpart to Solidity's `-` operator.
73      *
74      * Requirements:
75      *
76      * - Subtraction cannot overflow.
77      */
78     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b <= a, errorMessage);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      *
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         return div(a, b, "SafeMath: division by zero");
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return mod(a, b, "SafeMath: modulo by zero");
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts with custom message when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b != 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/GSN/Context.sol
180 
181 pragma solidity >=0.6.0 <0.8.0;
182 
183 /*
184  * @dev Provides information about the current execution context, including the
185  * sender of the transaction and its data. While these are generally available
186  * via msg.sender and msg.data, they should not be accessed in such a direct
187  * manner, since when dealing with GSN meta-transactions the account sending and
188  * paying for execution may not be the actual sender (as far as an application
189  * is concerned).
190  *
191  * This contract is only required for intermediate, library-like contracts.
192  */
193 abstract contract Context {
194     function _msgSender() internal view virtual returns (address payable) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view virtual returns (bytes memory) {
199         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
200         return msg.data;
201     }
202 }
203 
204 // File: @openzeppelin/contracts/access/Ownable.sol
205 
206 pragma solidity >=0.6.0 <0.8.0;
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * By default, the owner account will be the one that deploys the contract. This
214  * can later be changed with {transferOwnership}.
215  *
216  * This module is used through inheritance. It will make available the modifier
217  * `onlyOwner`, which can be applied to your functions to restrict their use to
218  * the owner.
219  */
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor () internal {
229         address msgSender = _msgSender();
230         _owner = msgSender;
231         emit OwnershipTransferred(address(0), msgSender);
232     }
233 
234     /**
235      * @dev Returns the address of the current owner.
236      */
237     function owner() public view returns (address) {
238         return _owner;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(_owner == _msgSender(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     /**
250      * @dev Leaves the contract without owner. It will not be possible to call
251      * `onlyOwner` functions anymore. Can only be called by the current owner.
252      *
253      * NOTE: Renouncing ownership will leave the contract without an owner,
254      * thereby removing any functionality that is only available to the owner.
255      */
256     function renounceOwnership() public virtual onlyOwner {
257         emit OwnershipTransferred(_owner, address(0));
258         _owner = address(0);
259     }
260 
261     /**
262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
263      * Can only be called by the current owner.
264      */
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         emit OwnershipTransferred(_owner, newOwner);
268         _owner = newOwner;
269     }
270 }
271 
272 // File: contracts/PPTimedVesting.sol
273 
274 pragma solidity 0.6.12;
275 
276 
277 
278 interface IERC20 {
279   function totalSupply() external view returns (uint256);
280 
281   function transfer(address _to, uint256 _amount) external;
282 }
283 
284 interface CvpInterface {
285   function getPriorVotes(address account, uint256 blockNumber) external view returns (uint96);
286 }
287 
288 /**
289  * @title PowerPool Vesting Contract
290  * @author PowerPool
291  */
292 contract PPTimedVesting is CvpInterface, Ownable {
293   using SafeMath for uint256;
294 
295   // @notice Emitted once when the contract was deployed
296   event Init(address[] members);
297 
298   // @notice Emitted when the owner increases durationT correspondingly increasing the endT timestamp
299   event IncreaseDurationT(uint256 prevDurationT, uint256 prevEndT, uint256 newDurationT, uint256 newEndT);
300 
301   // @notice Emitted when a member delegates his votes to one of the delegates or to himself
302   event DelegateVotes(address indexed from, address indexed to, address indexed previousDelegate, uint96 adjustedVotes);
303 
304   // @notice Emitted when a member transfer his permission
305   event Transfer(
306     address indexed from,
307     address indexed to,
308     uint96 alreadyClaimedVotes,
309     uint96 alreadyClaimedTokens,
310     address currentDelegate
311   );
312 
313   /// @notice Emitted when a member claims available votes
314   event ClaimVotes(
315     address indexed member,
316     address indexed delegate,
317     uint96 lastAlreadyClaimedVotes,
318     uint96 lastAlreadyClaimedTokens,
319     uint96 newAlreadyClaimedVotes,
320     uint96 newAlreadyClaimedTokens,
321     uint96 lastMemberAdjustedVotes,
322     uint96 adjustedVotes,
323     uint96 diff
324   );
325 
326   /// @notice Emitted when a member claims available tokens
327   event ClaimTokens(
328     address indexed member,
329     address indexed to,
330     uint96 amount,
331     uint256 newAlreadyClaimed,
332     uint256 votesAvailable
333   );
334 
335   /// @notice A Emitted when a member unclaimed balance changes
336   event UnclaimedBalanceChanged(address indexed member, uint256 previousUnclaimed, uint256 newUnclaimed);
337 
338   /// @notice A member statuses and unclaimed balance tracker
339   struct Member {
340     bool active;
341     bool transferred;
342     uint96 alreadyClaimedVotes;
343     uint96 alreadyClaimedTokens;
344   }
345 
346   /// @notice A checkpoint for marking number of votes from a given block
347   struct Checkpoint {
348     uint32 fromBlock;
349     uint96 votes;
350   }
351 
352   /// @notice ERC20 token address
353   address public immutable token;
354 
355   /// @notice Start timestamp for vote vesting calculations
356   uint256 public immutable startV;
357 
358   /// @notice Duration of the vote vesting in seconds
359   uint256 public immutable durationV;
360 
361   /// @notice End vote vesting timestamp
362   uint256 public immutable endV;
363 
364   /// @notice Start timestamp for token vesting calculations
365   uint256 public immutable startT;
366 
367   /// @notice Number of the vesting contract members, used only from UI
368   uint256 public immutable memberCount;
369 
370   /// @notice Amount of ERC20 tokens to distribute during the vesting period
371   uint96 public immutable amountPerMember;
372 
373   /// @notice Duration of the token vesting in seconds
374   uint256 public durationT;
375 
376   /// @notice End token timestamp, used only from UI
377   uint256 public endT;
378 
379   /// @notice Member details by their address
380   mapping(address => Member) public members;
381 
382   /// @notice A record of vote checkpoints for each member, by index
383   mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
384 
385   /// @notice The number of checkpoints for each member
386   mapping(address => uint32) public numCheckpoints;
387 
388   /// @notice Vote delegations
389   mapping(address => address) public voteDelegations;
390 
391   /**
392    * @notice Constructs a new vesting contract
393    * @dev It's up to a deployer to allocate the correct amount of ERC20 tokens on this contract
394    * @param _tokenAddress The ERC20 token address to use with this vesting contract
395    * @param _startV The timestamp when the vote vesting period starts
396    * @param _durationV The duration in second the vote vesting period should last
397    * @param _startT The timestamp when the token vesting period starts
398    * @param _durationT The duration in seconds the token vesting period should last
399    * @param _memberList The list of addresses to distribute tokens to
400    * @param _amountPerMember The number of tokens to distribute to each vesting contract member
401    */
402   constructor(
403     address _tokenAddress,
404     uint256 _startV,
405     uint256 _durationV,
406     uint256 _startT,
407     uint256 _durationT,
408     address[] memory _memberList,
409     uint96 _amountPerMember
410   ) public {
411     require(_durationV > 1, "Vesting: Invalid durationV");
412     require(_durationT > 1, "Vesting: Invalid durationT");
413     require(_startV < _startT, "Vesting: Requires startV < startT");
414     // require((_startV + _durationV) <= (_startT + _durationT), "Vesting: Requires endV <= endT");
415     require((_startV.add(_durationV)) <= (_startT.add(_durationT)), "Vesting: Requires endV <= endT");
416     require(_amountPerMember > 0, "Vesting: Invalid amount per member");
417     require(IERC20(_tokenAddress).totalSupply() > 0, "Vesting: Missing supply of the token");
418 
419     token = _tokenAddress;
420 
421     startV = _startV;
422     durationV = _durationV;
423     endV = _startV + _durationV;
424 
425     startT = _startT;
426     durationT = _durationT;
427     endT = _startT + _durationT;
428 
429     amountPerMember = _amountPerMember;
430 
431     uint256 len = _memberList.length;
432     require(len > 0, "Vesting: Empty member list");
433 
434     memberCount = len;
435 
436     for (uint256 i = 0; i < len; i++) {
437       members[_memberList[i]].active = true;
438     }
439 
440     emit Init(_memberList);
441   }
442 
443   /**
444    * @notice Checks whether the vote vesting period has started or not
445    * @return true If the vote vesting period has started
446    */
447   function hasVoteVestingStarted() external view returns (bool) {
448     return block.timestamp >= startV;
449   }
450 
451   /**
452    * @notice Checks whether the vote vesting period has ended or not
453    * @return true If the vote vesting period has ended
454    */
455   function hasVoteVestingEnded() external view returns (bool) {
456     return block.timestamp >= endV;
457   }
458 
459   /**
460    * @notice Checks whether the token vesting period has started or not
461    * @return true If the token vesting period has started
462    */
463   function hasTokenVestingStarted() external view returns (bool) {
464     return block.timestamp >= startT;
465   }
466 
467   /**
468    * @notice Checks whether the token vesting period has ended or not
469    * @return true If the token vesting period has ended
470    */
471   function hasTokenVestingEnded() external view returns (bool) {
472     return block.timestamp >= endT;
473   }
474 
475   /**
476    * @notice Returns the address a _voteHolder delegated their votes to
477    * @param _voteHolder The address to fetch delegate for
478    * @return address The delegate address
479    */
480   function getVoteUser(address _voteHolder) public view returns (address) {
481     address currentDelegate = voteDelegations[_voteHolder];
482     if (currentDelegate == address(0)) {
483       return _voteHolder;
484     }
485     return currentDelegate;
486   }
487 
488   /**
489    * @notice Provides information about the last cached votes checkpoint with no other conditions
490    * @dev Provides a latest cached votes value. For actual votes information use `getPriorVotes()` which introduce
491    *      some additional logic constraints on top of this cached value.
492    * @param _member The member address to get votes for
493    */
494   function getLastCachedVotes(address _member) external view returns (uint256) {
495     uint32 dstRepNum = numCheckpoints[_member];
496     return dstRepNum > 0 ? checkpoints[_member][dstRepNum - 1].votes : 0;
497   }
498 
499   /**
500    * @notice Provides information about a member already claimed votes
501    * @dev Behaves like a CVP delegated balance, but with a member unclaimed balance
502    * @dev Block number must be a finalized block or else this function will revert to prevent misinformation
503    * @dev Returns 0 for non-member addresses, even for previously valid ones
504    * @dev This method is a copy from CVP token with several modifications
505    * @param account The address of the member to check
506    * @param blockNumber The block number to get the vote balance at
507    * @return The number of votes the account had as of the given block
508    */
509   function getPriorVotes(address account, uint256 blockNumber) public view override returns (uint96) {
510     require(blockNumber < block.number, "Vesting::getPriorVotes: Not yet determined");
511 
512     uint32 nCheckpoints = numCheckpoints[account];
513 
514     // Not a member
515     if (members[account].active == false) {
516       return 0;
517     }
518 
519     // (No one can use vesting votes left on the contract after endT, even for votings created before endT)
520     if (block.timestamp > endT) {
521       return 0;
522     }
523 
524     // (A member has not claimed any tokens yet) OR (The blockNumber is before the first checkpoint)
525     if (nCheckpoints == 0 || checkpoints[account][0].fromBlock > blockNumber) {
526       return 0;
527     }
528 
529     // Next check most recent balance
530     if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
531       return checkpoints[account][nCheckpoints - 1].votes;
532     }
533 
534     uint32 lower = 0;
535     uint32 upper = nCheckpoints - 1;
536     while (upper > lower) {
537       uint32 center = upper - (upper - lower) / 2;
538       // ceil, avoiding overflow
539       Checkpoint memory cp = checkpoints[account][center];
540       if (cp.fromBlock == blockNumber) {
541         return cp.votes;
542       } else if (cp.fromBlock < blockNumber) {
543         lower = center;
544       } else {
545         upper = center - 1;
546       }
547     }
548     return checkpoints[account][lower].votes;
549   }
550 
551   /*** Available to Claim calculation ***/
552 
553   /**
554    * @notice Returns available amount for a claim in the given timestamp
555    *         by the given member based on the current contract values
556    * @param _member The member address to return available balance for
557    * @return The available amount for a claim in the next block
558    */
559   function getAvailableTokensForMemberAt(uint256 _atTimestamp, address _member) external view returns (uint256) {
560     Member storage member = members[_member];
561     if (member.active == false) {
562       return 0;
563     }
564 
565     return getAvailable(_atTimestamp, startT, amountPerMember, durationT, member.alreadyClaimedTokens);
566   }
567 
568   /**
569    * @notice Returns available token amount for a claim by a given member in the current timestamp
570    *         based on the current contract values
571    * @param _member The member address to return available balance for
572    * @return The available amount for a claim in the current block
573    */
574   function getAvailableTokensForMember(address _member) external view returns (uint256) {
575     Member storage member = members[_member];
576     if (member.active == false) {
577       return 0;
578     }
579 
580     return getAvailableTokens(member.alreadyClaimedTokens);
581   }
582 
583   /**
584    * @notice Returns available vote amount for a claim by a given member at the moment
585    *         based on the current contract values
586    * @param _member The member address to return available balance for
587    * @return The available amount for a claim at the moment
588    */
589   function getAvailableVotesForMember(address _member) external view returns (uint256) {
590     Member storage member = members[_member];
591     if (member.active == false) {
592       return 0;
593     }
594 
595     return getAvailableVotes(member.alreadyClaimedVotes);
596   }
597 
598   /**
599    * @notice Returns available token amount for a claim based on the current contract values
600    *         and an already claimed amount input
601    * @dev Will return amountPerMember for non-members, so an external check is required for this case
602    * @param _alreadyClaimed amount
603    * @return The available amount for claim
604    */
605   function getAvailableTokens(uint256 _alreadyClaimed) public view returns (uint256) {
606     return getAvailable(block.timestamp, startT, amountPerMember, durationT, _alreadyClaimed);
607   }
608 
609   /**
610    * @notice Returns available vote amount for claim based on the current contract values
611    *         and an already claimed amount input
612    * @dev Will return amountPerMember for non-members, so an external check is required for this case
613    * @param _alreadyClaimed amount
614    * @return The available amount for claim
615    */
616   function getAvailableVotes(uint256 _alreadyClaimed) public view returns (uint256) {
617     if (block.timestamp > endT) {
618       return 0;
619     }
620     return getAvailable(block.timestamp, startV, amountPerMember, durationV, _alreadyClaimed);
621   }
622 
623   /**
624    * @notice Calculates available amount for a claim
625    * @dev A pure function which doesn't reads anything from state
626    * @param _now A timestamp to calculate the available amount
627    * @param _start The vesting period start timestamp
628    * @param _amountPerMember The amount of ERC20 tokens to be distributed to each member
629    *         during this vesting period
630    * @param _duration The vesting total duration in seconds
631    * @param _alreadyClaimed The amount of tokens already claimed by a member
632    * @return The available amount for a claim
633    */
634   function getAvailable(
635     uint256 _now,
636     uint256 _start,
637     uint256 _amountPerMember,
638     uint256 _duration,
639     uint256 _alreadyClaimed
640   ) public pure returns (uint256) {
641     if (_now <= _start) {
642       return 0;
643     }
644 
645     // uint256 vestingEndsAt = _start + _duration;
646     uint256 vestingEndsAt = _start.add(_duration);
647     uint256 to = _now > vestingEndsAt ? vestingEndsAt : _now;
648 
649     // uint256 accrued = (to - _start) * _amountPerMember / _duration;
650     uint256 accrued = ((to - _start).mul(_amountPerMember).div(_duration));
651 
652     // return accrued - _alreadyClaimed;
653     return accrued.sub(_alreadyClaimed);
654   }
655 
656   /*** Owner Methods ***/
657 
658   function increaseDurationT(uint256 _newDurationT) external onlyOwner {
659     require(_newDurationT > durationT, "Vesting::increaseDurationT: Too small duration");
660     require((_newDurationT - durationT) < 180 days, "Vesting::increaseDurationT: Too big duration");
661 
662     uint256 prevDurationT = durationT;
663     uint256 prevEndT = endT;
664 
665     durationT = _newDurationT;
666     uint256 newEndT = startT.add(_newDurationT);
667     endT = newEndT;
668 
669     emit IncreaseDurationT(prevDurationT, prevEndT, _newDurationT, newEndT);
670   }
671 
672   /*** Member Methods ***/
673 
674   /**
675    * @notice An active member claims a distributed amount of votes
676    * @dev Caches unclaimed balance per block number which could be used by voting contract
677    * @param _to address to claim votes to
678    */
679   function claimVotes(address _to) external {
680     Member memory member = members[_to];
681     require(member.active == true, "Vesting::claimVotes: User not active");
682 
683     uint256 votes = getAvailableVotes(member.alreadyClaimedVotes);
684 
685     require(block.timestamp <= endT, "Vesting::claimVotes: Vote vesting has ended");
686     require(votes > 0, "Vesting::claimVotes: Nothing to claim");
687 
688     _claimVotes(_to, member, votes);
689   }
690 
691   function _claimVotes(
692     address _memberAddress,
693     Member memory _member,
694     uint256 _availableVotes
695   ) internal {
696     uint96 newAlreadyClaimedVotes;
697 
698     if (_availableVotes > 0) {
699       uint96 amount = safe96(_availableVotes, "Vesting::_claimVotes: Amount overflow");
700 
701       // member.alreadyClaimed += amount
702       newAlreadyClaimedVotes = add96(
703         _member.alreadyClaimedVotes,
704         amount,
705         "Vesting::claimVotes: newAlreadyClaimed overflow"
706       );
707       members[_memberAddress].alreadyClaimedVotes = newAlreadyClaimedVotes;
708     } else {
709       newAlreadyClaimedVotes = _member.alreadyClaimedVotes;
710     }
711 
712     // Step #1. Get the accrued votes value
713     // lastMemberAdjustedVotes = claimedVotesBeforeTx - claimedTokensBeforeTx
714     uint96 lastMemberAdjustedVotes =
715       sub96(
716         _member.alreadyClaimedVotes,
717         _member.alreadyClaimedTokens,
718         "Vesting::_claimVotes: lastMemberAdjustedVotes overflow"
719       );
720 
721     // Step #2. Get the adjusted value in relation to the member itself.
722     // `adjustedVotes = votesAfterTx - claimedTokensBeforeTheCalculation`
723     // `claimedTokensBeforeTheCalculation` could be updated earlier in claimVotes() method in the same tx
724     uint96 adjustedVotes =
725       sub96(
726         newAlreadyClaimedVotes,
727         members[_memberAddress].alreadyClaimedTokens,
728         "Vesting::_claimVotes: adjustedVotes underflow"
729       );
730 
731     address delegate = getVoteUser(_memberAddress);
732     uint96 diff;
733 
734     // Step #3. Apply the adjusted value in relation to the delegate
735     if (adjustedVotes > lastMemberAdjustedVotes) {
736       diff = sub96(adjustedVotes, lastMemberAdjustedVotes, "Vesting::_claimVotes: Positive diff underflow");
737       _addDelegatedVotesCache(delegate, diff);
738     } else if (lastMemberAdjustedVotes > adjustedVotes) {
739       diff = sub96(lastMemberAdjustedVotes, adjustedVotes, "Vesting::_claimVotes: Negative diff underflow");
740       _subDelegatedVotesCache(delegate, diff);
741     }
742 
743     emit ClaimVotes(
744       _memberAddress,
745       delegate,
746       _member.alreadyClaimedVotes,
747       _member.alreadyClaimedTokens,
748       newAlreadyClaimedVotes,
749       members[_memberAddress].alreadyClaimedTokens,
750       lastMemberAdjustedVotes,
751       adjustedVotes,
752       diff
753     );
754   }
755 
756   /**
757    * @notice An active member claims a distributed amount of ERC20 tokens
758    * @param _to address to claim ERC20 tokens to
759    */
760   function claimTokens(address _to) external {
761     Member memory member = members[msg.sender];
762     require(member.active == true, "Vesting::claimTokens: User not active");
763 
764     uint256 bigAmount = getAvailableTokens(member.alreadyClaimedTokens);
765     require(bigAmount > 0, "Vesting::claimTokens: Nothing to claim");
766     uint96 amount = safe96(bigAmount, "Vesting::claimTokens: Amount overflow");
767 
768     // member.alreadyClaimed += amount
769     uint96 newAlreadyClaimed =
770       add96(member.alreadyClaimedTokens, amount, "Vesting::claimTokens: NewAlreadyClaimed overflow");
771     members[msg.sender].alreadyClaimedTokens = newAlreadyClaimed;
772 
773     uint256 votes = getAvailableVotes(member.alreadyClaimedVotes);
774 
775     if (block.timestamp <= endT) {
776       _claimVotes(msg.sender, member, votes);
777     }
778 
779     emit ClaimTokens(msg.sender, _to, amount, newAlreadyClaimed, votes);
780 
781     IERC20(token).transfer(_to, bigAmount);
782   }
783 
784   /**
785    * @notice Delegates an already claimed votes amount to the given address
786    * @param _to address to delegate votes
787    */
788   function delegateVotes(address _to) external {
789     Member memory member = members[msg.sender];
790     require(_to != address(0), "Vesting::delegateVotes: Can't delegate to 0 address");
791     require(member.active == true, "Vesting::delegateVotes: msg.sender not active");
792 
793     address currentDelegate = getVoteUser(msg.sender);
794     require(_to != currentDelegate, "Vesting::delegateVotes: Already delegated to this address");
795 
796     voteDelegations[msg.sender] = _to;
797     uint96 adjustedVotes =
798       sub96(member.alreadyClaimedVotes, member.alreadyClaimedTokens, "Vesting::claimVotes: AdjustedVotes underflow");
799 
800     _subDelegatedVotesCache(currentDelegate, adjustedVotes);
801     _addDelegatedVotesCache(_to, adjustedVotes);
802 
803     emit DelegateVotes(msg.sender, _to, currentDelegate, adjustedVotes);
804   }
805 
806   /**
807    * @notice Transfers a vested rights for a member funds to another address
808    * @dev A new member won't have any votes for a period between a start timestamp and a current timestamp
809    * @param _to address to transfer a vested right to
810    */
811   function transfer(address _to) external {
812     Member memory from = members[msg.sender];
813     Member memory to = members[_to];
814 
815     uint96 alreadyClaimedTokens = from.alreadyClaimedTokens;
816     uint96 alreadyClaimedVotes = from.alreadyClaimedVotes;
817 
818     require(from.active == true, "Vesting::transfer: From member is inactive");
819     require(to.active == false, "Vesting::transfer: To address is already active");
820     require(to.transferred == false, "Vesting::transfer: To address has been already used");
821 
822     members[msg.sender] = Member({ active: false, transferred: true, alreadyClaimedVotes: 0, alreadyClaimedTokens: 0 });
823     members[_to] = Member({
824       active: true,
825       transferred: false,
826       alreadyClaimedVotes: alreadyClaimedVotes,
827       alreadyClaimedTokens: alreadyClaimedTokens
828     });
829 
830     address currentDelegate = voteDelegations[msg.sender];
831 
832     uint32 currentBlockNumber = safe32(block.number, "Vesting::transfer: Block number exceeds 32 bits");
833 
834     checkpoints[_to][0] = Checkpoint(uint32(0), 0);
835     if (currentDelegate == address(0)) {
836       uint96 adjustedVotes =
837         sub96(from.alreadyClaimedVotes, from.alreadyClaimedTokens, "Vesting::claimVotes: AdjustedVotes underflow");
838       _subDelegatedVotesCache(msg.sender, adjustedVotes);
839       checkpoints[_to][1] = Checkpoint(currentBlockNumber, adjustedVotes);
840       numCheckpoints[_to] = 2;
841     } else {
842       numCheckpoints[_to] = 1;
843     }
844 
845     voteDelegations[_to] = voteDelegations[msg.sender];
846     delete voteDelegations[msg.sender];
847 
848     Member memory toMember = members[_to];
849 
850     emit Transfer(msg.sender, _to, alreadyClaimedVotes, alreadyClaimedTokens, currentDelegate);
851 
852     uint256 votes = getAvailableVotes(toMember.alreadyClaimedVotes);
853     _claimVotes(_to, toMember, votes);
854   }
855 
856   function _subDelegatedVotesCache(address _member, uint96 _subAmount) internal {
857     uint32 dstRepNum = numCheckpoints[_member];
858     uint96 dstRepOld = dstRepNum > 0 ? checkpoints[_member][dstRepNum - 1].votes : 0;
859     uint96 dstRepNew = sub96(dstRepOld, _subAmount, "Vesting::_cacheUnclaimed: Sub amount overflows");
860     _writeCheckpoint(_member, dstRepNum, dstRepOld, dstRepNew);
861   }
862 
863   function _addDelegatedVotesCache(address _member, uint96 _addAmount) internal {
864     uint32 dstRepNum = numCheckpoints[_member];
865     uint96 dstRepOld = dstRepNum > 0 ? checkpoints[_member][dstRepNum - 1].votes : 0;
866     uint96 dstRepNew = add96(dstRepOld, _addAmount, "Vesting::_cacheUnclaimed: Add amount overflows");
867     _writeCheckpoint(_member, dstRepNum, dstRepOld, dstRepNew);
868   }
869 
870   /// @dev A copy from CVP token, only the event name changed
871   function _writeCheckpoint(
872     address delegatee,
873     uint32 nCheckpoints,
874     uint96 oldVotes,
875     uint96 newVotes
876   ) internal {
877     uint32 blockNumber = safe32(block.number, "Vesting::_writeCheckpoint: Block number exceeds 32 bits");
878 
879     if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
880       checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
881     } else {
882       checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
883       numCheckpoints[delegatee] = nCheckpoints + 1;
884     }
885 
886     emit UnclaimedBalanceChanged(delegatee, oldVotes, newVotes);
887   }
888 
889   /// @dev The exact copy from CVP token
890   function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
891     require(n < 2**32, errorMessage);
892     return uint32(n);
893   }
894 
895   /// @dev The exact copy from CVP token
896   function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
897     require(n < 2**96, errorMessage);
898     return uint96(n);
899   }
900 
901   /// @dev The exact copy from CVP token
902   function sub96(
903     uint96 a,
904     uint96 b,
905     string memory errorMessage
906   ) internal pure returns (uint96) {
907     require(b <= a, errorMessage);
908     return a - b;
909   }
910 
911   /// @dev The exact copy from CVP token
912   function add96(
913     uint96 a,
914     uint96 b,
915     string memory errorMessage
916   ) internal pure returns (uint96) {
917     uint96 c = a + b;
918     require(c >= a, errorMessage);
919     return c;
920   }
921 }