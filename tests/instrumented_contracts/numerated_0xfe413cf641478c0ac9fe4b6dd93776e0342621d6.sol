1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title SafeERC20
103  * @dev Wrappers around ERC20 operations that throw on failure.
104  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
105  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
106  */
107 library SafeERC20 {
108     using SafeMath for uint256;
109 
110     function safeTransfer(IERC20 token, address to, uint256 value) internal {
111         require(token.transfer(to, value));
112     }
113 
114     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
115         require(token.transferFrom(from, to, value));
116     }
117 
118     function safeApprove(IERC20 token, address spender, uint256 value) internal {
119         // safeApprove should only be called when setting an initial allowance,
120         // or when resetting it to zero. To increase and decrease it, use
121         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
122         require((value == 0) || (token.allowance(address(this), spender) == 0));
123         require(token.approve(spender, value));
124     }
125 
126     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
127         uint256 newAllowance = token.allowance(address(this), spender).add(value);
128         require(token.approve(spender, newAllowance));
129     }
130 
131     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
132         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
133         require(token.approve(spender, newAllowance));
134     }
135 }
136 
137 // File: openzeppelin-solidity/contracts/access/Roles.sol
138 
139 pragma solidity ^0.5.0;
140 
141 /**
142  * @title Roles
143  * @dev Library for managing addresses assigned to a Role.
144  */
145 library Roles {
146     struct Role {
147         mapping (address => bool) bearer;
148     }
149 
150     /**
151      * @dev give an account access to this role
152      */
153     function add(Role storage role, address account) internal {
154         require(account != address(0));
155         require(!has(role, account));
156 
157         role.bearer[account] = true;
158     }
159 
160     /**
161      * @dev remove an account's access to this role
162      */
163     function remove(Role storage role, address account) internal {
164         require(account != address(0));
165         require(has(role, account));
166 
167         role.bearer[account] = false;
168     }
169 
170     /**
171      * @dev check if an account has this role
172      * @return bool
173      */
174     function has(Role storage role, address account) internal view returns (bool) {
175         require(account != address(0));
176         return role.bearer[account];
177     }
178 }
179 
180 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
181 
182 pragma solidity ^0.5.0;
183 
184 
185 contract PauserRole {
186     using Roles for Roles.Role;
187 
188     event PauserAdded(address indexed account);
189     event PauserRemoved(address indexed account);
190 
191     Roles.Role private _pausers;
192 
193     constructor () internal {
194         _addPauser(msg.sender);
195     }
196 
197     modifier onlyPauser() {
198         require(isPauser(msg.sender));
199         _;
200     }
201 
202     function isPauser(address account) public view returns (bool) {
203         return _pausers.has(account);
204     }
205 
206     function addPauser(address account) public onlyPauser {
207         _addPauser(account);
208     }
209 
210     function renouncePauser() public {
211         _removePauser(msg.sender);
212     }
213 
214     function _addPauser(address account) internal {
215         _pausers.add(account);
216         emit PauserAdded(account);
217     }
218 
219     function _removePauser(address account) internal {
220         _pausers.remove(account);
221         emit PauserRemoved(account);
222     }
223 }
224 
225 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
226 
227 pragma solidity ^0.5.0;
228 
229 
230 /**
231  * @title Pausable
232  * @dev Base contract which allows children to implement an emergency stop mechanism.
233  */
234 contract Pausable is PauserRole {
235     event Paused(address account);
236     event Unpaused(address account);
237 
238     bool private _paused;
239 
240     constructor () internal {
241         _paused = false;
242     }
243 
244     /**
245      * @return true if the contract is paused, false otherwise.
246      */
247     function paused() public view returns (bool) {
248         return _paused;
249     }
250 
251     /**
252      * @dev Modifier to make a function callable only when the contract is not paused.
253      */
254     modifier whenNotPaused() {
255         require(!_paused);
256         _;
257     }
258 
259     /**
260      * @dev Modifier to make a function callable only when the contract is paused.
261      */
262     modifier whenPaused() {
263         require(_paused);
264         _;
265     }
266 
267     /**
268      * @dev called by the owner to pause, triggers stopped state
269      */
270     function pause() public onlyPauser whenNotPaused {
271         _paused = true;
272         emit Paused(msg.sender);
273     }
274 
275     /**
276      * @dev called by the owner to unpause, returns to normal state
277      */
278     function unpause() public onlyPauser whenPaused {
279         _paused = false;
280         emit Unpaused(msg.sender);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
285 
286 pragma solidity ^0.5.0;
287 
288 /**
289  * @title Ownable
290  * @dev The Ownable contract has an owner address, and provides basic authorization control
291  * functions, this simplifies the implementation of "user permissions".
292  */
293 contract Ownable {
294     address private _owner;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     /**
299      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
300      * account.
301      */
302     constructor () internal {
303         _owner = msg.sender;
304         emit OwnershipTransferred(address(0), _owner);
305     }
306 
307     /**
308      * @return the address of the owner.
309      */
310     function owner() public view returns (address) {
311         return _owner;
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         require(isOwner());
319         _;
320     }
321 
322     /**
323      * @return true if `msg.sender` is the owner of the contract.
324      */
325     function isOwner() public view returns (bool) {
326         return msg.sender == _owner;
327     }
328 
329     /**
330      * @dev Allows the current owner to relinquish control of the contract.
331      * @notice Renouncing to ownership will leave the contract without an owner.
332      * It will not be possible to call the functions with the `onlyOwner`
333      * modifier anymore.
334      */
335     function renounceOwnership() public onlyOwner {
336         emit OwnershipTransferred(_owner, address(0));
337         _owner = address(0);
338     }
339 
340     /**
341      * @dev Allows the current owner to transfer control of the contract to a newOwner.
342      * @param newOwner The address to transfer ownership to.
343      */
344     function transferOwnership(address newOwner) public onlyOwner {
345         _transferOwnership(newOwner);
346     }
347 
348     /**
349      * @dev Transfers control of the contract to a newOwner.
350      * @param newOwner The address to transfer ownership to.
351      */
352     function _transferOwnership(address newOwner) internal {
353         require(newOwner != address(0));
354         emit OwnershipTransferred(_owner, newOwner);
355         _owner = newOwner;
356     }
357 }
358 
359 // File: contracts/lib/interface/ISGN.sol
360 
361 pragma solidity 0.5.17;
362 
363 /**
364  * @title SGN interface
365  */
366 interface ISGN {
367     // functions
368     function updateSidechainAddr(bytes calldata _sidechainAddr) external;
369 
370     function subscribe(uint _amount) external;
371 
372     function redeemReward(bytes calldata _rewardRequest) external;
373 
374     // events
375     event UpdateSidechainAddr(address indexed candidate, bytes indexed oldSidechainAddr, bytes indexed newSidechainAddr);
376 
377     event AddSubscriptionBalance(address indexed consumer, uint amount);
378 
379     event RedeemReward(address indexed receiver, uint cumulativeMiningReward, uint serviceReward, uint servicePool);
380 }
381 
382 // File: contracts/lib/interface/IDPoS.sol
383 
384 pragma solidity 0.5.17;
385 
386 /**
387  * @title DPoS interface
388  */
389 interface IDPoS {
390     enum ValidatorChangeType { Add, Removal }
391 
392     // functions
393     function contributeToMiningPool(uint _amount) external;
394 
395     function redeemMiningReward(address _receiver, uint _cumulativeReward) external;
396 
397     function registerSidechain(address _addr) external;
398 
399     function initializeCandidate(uint _minSelfStake, uint _commissionRate, uint _rateLockEndTime) external;
400 
401     function announceIncreaseCommissionRate(uint _newRate, uint _newLockEndTime) external;
402 
403     function confirmIncreaseCommissionRate() external;
404 
405     function nonIncreaseCommissionRate(uint _newRate, uint _newLockEndTime) external;
406 
407     function updateMinSelfStake(uint256 _minSelfStake) external;
408 
409     function delegate(address _candidateAddr, uint _amount) external;
410 
411     function withdrawFromUnbondedCandidate(address _candidateAddr, uint _amount) external;
412 
413     function intendWithdraw(address _candidateAddr, uint _amount) external;
414 
415     function confirmWithdraw(address _candidateAddr) external;
416 
417     function claimValidator() external;
418 
419     function confirmUnbondedCandidate(address _candidateAddr) external;
420 
421     function slash(bytes calldata _penaltyRequest) external;
422 
423     function validateMultiSigMessage(bytes calldata _request) external returns(bool);
424 
425     function isValidDPoS() external view returns (bool);
426 
427     function isValidator(address _addr) external view returns (bool);
428 
429     function getValidatorNum() external view returns (uint);
430 
431     function getMinStakingPool() external view returns (uint);
432 
433     function getCandidateInfo(address _candidateAddr) external view returns (bool, uint, uint, uint, uint, uint, uint);
434 
435     function getDelegatorInfo(address _candidateAddr, address _delegatorAddr) external view returns (uint, uint, uint[] memory, uint[] memory);
436 
437     function getMinQuorumStakingPool() external view returns(uint);
438 
439     function getTotalValidatorStakingPool() external view returns(uint);
440 
441     // TODO: interface can't be inherited, so VoteType is not declared here
442     // function voteParam(uint _proposalId, VoteType _vote) external;
443 
444     // function confirmParamProposal(uint _proposalId) external;
445 
446     // function voteSidechain(uint _proposalId, VoteType _vote) external;
447 
448     // function confirmSidechainProposal(uint _proposalId) external;
449 
450     // events
451     event InitializeCandidate(address indexed candidate, uint minSelfStake, uint commissionRate, uint rateLockEndTime);
452 
453     event CommissionRateAnnouncement(address indexed candidate, uint announcedRate, uint announcedLockEndTime);
454 
455     event UpdateCommissionRate(address indexed candidate, uint newRate, uint newLockEndTime);
456 
457     event UpdateMinSelfStake(address indexed candidate, uint minSelfStake);
458 
459     event Delegate(address indexed delegator, address indexed candidate, uint newStake, uint stakingPool);
460 
461     event ValidatorChange(address indexed ethAddr, ValidatorChangeType indexed changeType);
462 
463     event WithdrawFromUnbondedCandidate(address indexed delegator, address indexed candidate, uint amount);
464 
465     event IntendWithdraw(address indexed delegator, address indexed candidate, uint withdrawAmount, uint proposedTime);
466 
467     event ConfirmWithdraw(address indexed delegator, address indexed candidate, uint amount);
468 
469     event Slash(address indexed validator, address indexed delegator, uint amount);
470 
471     event UpdateDelegatedStake(address indexed delegator, address indexed candidate, uint delegatorStake, uint candidatePool);
472 
473     event Compensate(address indexed indemnitee, uint amount);
474 
475     event CandidateUnbonded(address indexed candidate);
476 
477     event RedeemMiningReward(address indexed receiver, uint reward, uint miningPool);
478 
479     event MiningPoolContribution(address indexed contributor, uint contribution, uint miningPoolSize);
480 }
481 
482 // File: contracts/lib/data/Pb.sol
483 
484 pragma solidity 0.5.17;
485 
486 // runtime proto sol library
487 library Pb {
488     enum WireType { Varint, Fixed64, LengthDelim, StartGroup, EndGroup, Fixed32 }
489 
490     struct Buffer {
491         uint idx;  // the start index of next read. when idx=b.length, we're done
492         bytes b;   // hold serialized proto msg, readonly
493     }
494 
495     // create a new in-memory Buffer object from raw msg bytes
496     function fromBytes(bytes memory raw) internal pure returns (Buffer memory buf) {
497         buf.b = raw;
498         buf.idx = 0;
499     }
500 
501     // whether there are unread bytes
502     function hasMore(Buffer memory buf) internal pure returns (bool) {
503         return buf.idx < buf.b.length;
504     }
505 
506     // decode current field number and wiretype
507     function decKey(Buffer memory buf) internal pure returns (uint tag, WireType wiretype) {
508         uint v = decVarint(buf);
509         tag = v / 8;
510         wiretype = WireType(v & 7);
511     }
512 
513     // count tag occurrences, return an array due to no memory map support
514 	// have to create array for (maxtag+1) size. cnts[tag] = occurrences
515 	// should keep buf.idx unchanged because this is only a count function
516     function cntTags(Buffer memory buf, uint maxtag) internal pure returns (uint[] memory cnts) {
517         uint originalIdx = buf.idx;
518         cnts = new uint[](maxtag+1);  // protobuf's tags are from 1 rather than 0
519         uint tag;
520         WireType wire;
521         while (hasMore(buf)) {
522             (tag, wire) = decKey(buf);
523             cnts[tag] += 1;
524             skipValue(buf, wire);
525         }
526         buf.idx = originalIdx;
527     }
528 
529     // read varint from current buf idx, move buf.idx to next read, return the int value
530     function decVarint(Buffer memory buf) internal pure returns (uint v) {
531         bytes10 tmp;  // proto int is at most 10 bytes (7 bits can be used per byte)
532         bytes memory bb = buf.b;  // get buf.b mem addr to use in assembly
533         v = buf.idx;  // use v to save one additional uint variable
534         assembly {
535             tmp := mload(add(add(bb, 32), v)) // load 10 bytes from buf.b[buf.idx] to tmp
536         }
537         uint b; // store current byte content
538         v = 0; // reset to 0 for return value
539         for (uint i=0; i<10; i++) {
540             assembly {
541                 b := byte(i, tmp)  // don't use tmp[i] because it does bound check and costs extra
542             }
543             v |= (b & 0x7F) << (i * 7);
544             if (b & 0x80 == 0) {
545                 buf.idx += i + 1;
546                 return v;
547             }
548         }
549         revert(); // i=10, invalid varint stream
550     }
551 
552     // read length delimited field and return bytes
553     function decBytes(Buffer memory buf) internal pure returns (bytes memory b) {
554         uint len = decVarint(buf);
555         uint end = buf.idx + len;
556         require(end <= buf.b.length);  // avoid overflow
557         b = new bytes(len);
558         bytes memory bufB = buf.b;  // get buf.b mem addr to use in assembly
559         uint bStart;
560         uint bufBStart = buf.idx;
561         assembly {
562             bStart := add(b, 32)
563             bufBStart := add(add(bufB, 32), bufBStart)
564         }
565         for (uint i=0; i<len; i+=32) {
566             assembly{
567                 mstore(add(bStart, i), mload(add(bufBStart, i)))
568             }
569         }
570         buf.idx = end;
571     }
572 
573     // return packed ints
574     function decPacked(Buffer memory buf) internal pure returns (uint[] memory t) {
575         uint len = decVarint(buf);
576         uint end = buf.idx + len;
577         require(end <= buf.b.length);  // avoid overflow
578         // array in memory must be init w/ known length
579         // so we have to create a tmp array w/ max possible len first
580         uint[] memory tmp = new uint[](len);
581         uint i; // count how many ints are there
582         while (buf.idx < end) {
583             tmp[i] = decVarint(buf);
584             i++;
585         }
586         t = new uint[](i); // init t with correct length
587         for (uint j=0; j<i; j++) {
588             t[j] = tmp[j];
589         }
590         return t;
591     }
592 
593     // move idx pass current value field, to beginning of next tag or msg end
594     function skipValue(Buffer memory buf, WireType wire) internal pure {
595         if (wire == WireType.Varint) { decVarint(buf); }
596         else if (wire == WireType.LengthDelim) {
597             uint len = decVarint(buf);
598             buf.idx += len; // skip len bytes value data
599             require(buf.idx <= buf.b.length);  // avoid overflow
600         } else { revert(); }  // unsupported wiretype
601     }
602 
603     // type conversion help utils
604     function _bool(uint x) internal pure returns (bool v) {
605         return x != 0;
606     }
607 
608     function _uint256(bytes memory b) internal pure returns (uint256 v) {
609         require(b.length <= 32);  // b's length must be smaller than or equal to 32
610         assembly { v := mload(add(b, 32)) }  // load all 32bytes to v
611         v = v >> (8 * (32 - b.length));  // only first b.length is valid
612     }
613 
614     function _address(bytes memory b) internal pure returns (address v) {
615         v = _addressPayable(b);
616     }
617 
618     function _addressPayable(bytes memory b) internal pure returns (address payable v) {
619         require(b.length == 20);
620         //load 32bytes then shift right 12 bytes
621         assembly { v := div(mload(add(b, 32)), 0x1000000000000000000000000) }
622     }
623 
624     function _bytes32(bytes memory b) internal pure returns (bytes32 v) {
625         require(b.length == 32);
626         assembly { v := mload(add(b, 32)) }
627     }
628 
629     // uint[] to uint8[]
630     function uint8s(uint[] memory arr) internal pure returns (uint8[] memory t) {
631         t = new uint8[](arr.length);
632         for (uint i = 0; i < t.length; i++) { t[i] = uint8(arr[i]); }
633     }
634 
635     function uint32s(uint[] memory arr) internal pure returns (uint32[] memory t) {
636         t = new uint32[](arr.length);
637         for (uint i = 0; i < t.length; i++) { t[i] = uint32(arr[i]); }
638     }
639 
640     function uint64s(uint[] memory arr) internal pure returns (uint64[] memory t) {
641         t = new uint64[](arr.length);
642         for (uint i = 0; i < t.length; i++) { t[i] = uint64(arr[i]); }
643     }
644 
645     function bools(uint[] memory arr) internal pure returns (bool[] memory t) {
646         t = new bool[](arr.length);
647         for (uint i = 0; i < t.length; i++) { t[i] = arr[i]!=0; }
648     }
649 }
650 
651 // File: contracts/lib/data/PbSgn.sol
652 
653 // Code generated by protoc-gen-sol. DO NOT EDIT.
654 // source: sgn.proto
655 pragma solidity 0.5.17;
656 
657 
658 library PbSgn {
659     using Pb for Pb.Buffer;  // so we can call Pb funcs on Buffer obj
660 
661     struct MultiSigMessage {
662         bytes msg;   // tag: 1
663         bytes[] sigs;   // tag: 2
664     } // end struct MultiSigMessage
665 
666     function decMultiSigMessage(bytes memory raw) internal pure returns (MultiSigMessage memory m) {
667         Pb.Buffer memory buf = Pb.fromBytes(raw);
668 
669         uint[] memory cnts = buf.cntTags(2);
670         m.sigs = new bytes[](cnts[2]);
671         cnts[2] = 0;  // reset counter for later use
672         
673         uint tag;
674         Pb.WireType wire;
675         while (buf.hasMore()) {
676             (tag, wire) = buf.decKey();
677             if (false) {} // solidity has no switch/case
678             else if (tag == 1) {
679                 m.msg = bytes(buf.decBytes());
680             }
681             else if (tag == 2) {
682                 m.sigs[cnts[2]] = bytes(buf.decBytes());
683                 cnts[2]++;
684             }
685             else { buf.skipValue(wire); } // skip value of unknown tag
686         }
687     } // end decoder MultiSigMessage
688 
689     struct PenaltyRequest {
690         bytes penalty;   // tag: 1
691         bytes[] sigs;   // tag: 2
692     } // end struct PenaltyRequest
693 
694     function decPenaltyRequest(bytes memory raw) internal pure returns (PenaltyRequest memory m) {
695         Pb.Buffer memory buf = Pb.fromBytes(raw);
696 
697         uint[] memory cnts = buf.cntTags(2);
698         m.sigs = new bytes[](cnts[2]);
699         cnts[2] = 0;  // reset counter for later use
700         
701         uint tag;
702         Pb.WireType wire;
703         while (buf.hasMore()) {
704             (tag, wire) = buf.decKey();
705             if (false) {} // solidity has no switch/case
706             else if (tag == 1) {
707                 m.penalty = bytes(buf.decBytes());
708             }
709             else if (tag == 2) {
710                 m.sigs[cnts[2]] = bytes(buf.decBytes());
711                 cnts[2]++;
712             }
713             else { buf.skipValue(wire); } // skip value of unknown tag
714         }
715     } // end decoder PenaltyRequest
716 
717     struct RewardRequest {
718         bytes reward;   // tag: 1
719         bytes[] sigs;   // tag: 2
720     } // end struct RewardRequest
721 
722     function decRewardRequest(bytes memory raw) internal pure returns (RewardRequest memory m) {
723         Pb.Buffer memory buf = Pb.fromBytes(raw);
724 
725         uint[] memory cnts = buf.cntTags(2);
726         m.sigs = new bytes[](cnts[2]);
727         cnts[2] = 0;  // reset counter for later use
728         
729         uint tag;
730         Pb.WireType wire;
731         while (buf.hasMore()) {
732             (tag, wire) = buf.decKey();
733             if (false) {} // solidity has no switch/case
734             else if (tag == 1) {
735                 m.reward = bytes(buf.decBytes());
736             }
737             else if (tag == 2) {
738                 m.sigs[cnts[2]] = bytes(buf.decBytes());
739                 cnts[2]++;
740             }
741             else { buf.skipValue(wire); } // skip value of unknown tag
742         }
743     } // end decoder RewardRequest
744 
745     struct Penalty {
746         uint64 nonce;   // tag: 1
747         uint64 expireTime;   // tag: 2
748         address validatorAddress;   // tag: 3
749         AccountAmtPair[] penalizedDelegators;   // tag: 4
750         AccountAmtPair[] beneficiaries;   // tag: 5
751     } // end struct Penalty
752 
753     function decPenalty(bytes memory raw) internal pure returns (Penalty memory m) {
754         Pb.Buffer memory buf = Pb.fromBytes(raw);
755 
756         uint[] memory cnts = buf.cntTags(5);
757         m.penalizedDelegators = new AccountAmtPair[](cnts[4]);
758         cnts[4] = 0;  // reset counter for later use
759         m.beneficiaries = new AccountAmtPair[](cnts[5]);
760         cnts[5] = 0;  // reset counter for later use
761         
762         uint tag;
763         Pb.WireType wire;
764         while (buf.hasMore()) {
765             (tag, wire) = buf.decKey();
766             if (false) {} // solidity has no switch/case
767             else if (tag == 1) {
768                 m.nonce = uint64(buf.decVarint());
769             }
770             else if (tag == 2) {
771                 m.expireTime = uint64(buf.decVarint());
772             }
773             else if (tag == 3) {
774                 m.validatorAddress = Pb._address(buf.decBytes());
775             }
776             else if (tag == 4) {
777                 m.penalizedDelegators[cnts[4]] = decAccountAmtPair(buf.decBytes());
778                 cnts[4]++;
779             }
780             else if (tag == 5) {
781                 m.beneficiaries[cnts[5]] = decAccountAmtPair(buf.decBytes());
782                 cnts[5]++;
783             }
784             else { buf.skipValue(wire); } // skip value of unknown tag
785         }
786     } // end decoder Penalty
787 
788     struct AccountAmtPair {
789         address account;   // tag: 1
790         uint256 amt;   // tag: 2
791     } // end struct AccountAmtPair
792 
793     function decAccountAmtPair(bytes memory raw) internal pure returns (AccountAmtPair memory m) {
794         Pb.Buffer memory buf = Pb.fromBytes(raw);
795 
796         uint tag;
797         Pb.WireType wire;
798         while (buf.hasMore()) {
799             (tag, wire) = buf.decKey();
800             if (false) {} // solidity has no switch/case
801             else if (tag == 1) {
802                 m.account = Pb._address(buf.decBytes());
803             }
804             else if (tag == 2) {
805                 m.amt = Pb._uint256(buf.decBytes());
806             }
807             else { buf.skipValue(wire); } // skip value of unknown tag
808         }
809     } // end decoder AccountAmtPair
810 
811     struct Reward {
812         address receiver;   // tag: 1
813         uint256 cumulativeMiningReward;   // tag: 2
814         uint256 cumulativeServiceReward;   // tag: 3
815     } // end struct Reward
816 
817     function decReward(bytes memory raw) internal pure returns (Reward memory m) {
818         Pb.Buffer memory buf = Pb.fromBytes(raw);
819 
820         uint tag;
821         Pb.WireType wire;
822         while (buf.hasMore()) {
823             (tag, wire) = buf.decKey();
824             if (false) {} // solidity has no switch/case
825             else if (tag == 1) {
826                 m.receiver = Pb._address(buf.decBytes());
827             }
828             else if (tag == 2) {
829                 m.cumulativeMiningReward = Pb._uint256(buf.decBytes());
830             }
831             else if (tag == 3) {
832                 m.cumulativeServiceReward = Pb._uint256(buf.decBytes());
833             }
834             else { buf.skipValue(wire); } // skip value of unknown tag
835         }
836     } // end decoder Reward
837 
838 }
839 
840 // File: contracts/lib/DPoSCommon.sol
841 
842 pragma solidity 0.5.17;
843 
844 /**
845  * @title DPoS contract common Library
846  * @notice Common items used in DPoS contract
847  */
848 library DPoSCommon {
849     // Unbonded: not a validator and not responsible for previous validator behaviors if any.
850     //   Delegators now are free to withdraw stakes (directly).
851     // Bonded: active validator. Delegators have to wait for slashTimeout to withdraw stakes.
852     // Unbonding: transitional status from Bonded to Unbonded. Candidate has lost the right of
853     //   validator but is still responsible for any misbehaviour done during being validator.
854     //   Delegators should wait until candidate's unbondTime to freely withdraw stakes.
855     enum CandidateStatus { Unbonded, Bonded, Unbonding }
856 }
857 
858 // File: contracts/SGN.sol
859 
860 pragma solidity 0.5.17;
861 
862 
863 
864 
865 
866 
867 
868 
869 
870 
871 /**
872  * @title Sidechain contract of State Guardian Network
873  * @notice This contract implements the mainchain logic of Celer State Guardian Network sidechain
874  * @dev specs: https://www.celer.network/docs/celercore/sgn/sidechain.html#mainchain-contracts
875  */
876 contract SGN is ISGN, Ownable, Pausable {
877     using SafeMath for uint256;
878     using SafeERC20 for IERC20;
879 
880     IERC20 public celerToken;
881     IDPoS public dPoSContract;
882     mapping(address => uint256) public subscriptionDeposits;
883     uint256 public servicePool;
884     mapping(address => uint256) public redeemedServiceReward;
885     mapping(address => bytes) public sidechainAddrMap;
886 
887     /**
888      * @notice Throws if SGN sidechain is not valid
889      * @dev Check this before sidechain's operations
890      */
891     modifier onlyValidSidechain() {
892         require(dPoSContract.isValidDPoS(), 'DPoS is not valid');
893         _;
894     }
895 
896     /**
897      * @notice SGN constructor
898      * @dev Need to deploy DPoS contract first before deploying SGN contract
899      * @param _celerTokenAddress address of Celer Token Contract
900      * @param _DPoSAddress address of DPoS Contract
901      */
902     constructor(address _celerTokenAddress, address _DPoSAddress) public {
903         celerToken = IERC20(_celerTokenAddress);
904         dPoSContract = IDPoS(_DPoSAddress);
905     }
906 
907     /**
908      * @notice Owner drains one type of tokens when the contract is paused
909      * @dev This is for emergency situations.
910      * @param _amount drained token amount
911      */
912     function drainToken(uint256 _amount) external whenPaused onlyOwner {
913         celerToken.safeTransfer(msg.sender, _amount);
914     }
915 
916     /**
917      * @notice Update sidechain address
918      * @dev Note that the "sidechain address" here means the address in the offchain sidechain system,
919          which is different from the sidechain contract address
920      * @param _sidechainAddr the new address in the offchain sidechain system
921      */
922     function updateSidechainAddr(bytes calldata _sidechainAddr) external {
923         address msgSender = msg.sender;
924 
925         (bool initialized, , , uint256 status, , , ) = dPoSContract.getCandidateInfo(msgSender);
926         require(
927             status == uint256(DPoSCommon.CandidateStatus.Unbonded),
928             'msg.sender is not unbonded'
929         );
930         require(initialized, 'Candidate is not initialized');
931 
932         bytes memory oldSidechainAddr = sidechainAddrMap[msgSender];
933         sidechainAddrMap[msgSender] = _sidechainAddr;
934 
935         emit UpdateSidechainAddr(msgSender, oldSidechainAddr, _sidechainAddr);
936     }
937 
938     /**
939      * @notice Subscribe the guardian service
940      * @param _amount subscription fee paid along this function call in CELR tokens
941      */
942     function subscribe(uint256 _amount) external whenNotPaused onlyValidSidechain {
943         address msgSender = msg.sender;
944 
945         servicePool = servicePool.add(_amount);
946         subscriptionDeposits[msgSender] = subscriptionDeposits[msgSender].add(_amount);
947 
948         celerToken.safeTransferFrom(msgSender, address(this), _amount);
949 
950         emit AddSubscriptionBalance(msgSender, _amount);
951     }
952 
953     /**
954      * @notice Redeem rewards
955      * @dev The rewards include both the service reward and mining reward
956      * @dev SGN contract acts as an interface for users to redeem mining rewards
957      * @param _rewardRequest reward request bytes coded in protobuf
958      */
959     function redeemReward(bytes calldata _rewardRequest) external whenNotPaused onlyValidSidechain {
960         require(
961             dPoSContract.validateMultiSigMessage(_rewardRequest),
962             'Validator sigs verification failed'
963         );
964 
965         PbSgn.RewardRequest memory rewardRequest = PbSgn.decRewardRequest(_rewardRequest);
966         PbSgn.Reward memory reward = PbSgn.decReward(rewardRequest.reward);
967         uint256 newServiceReward = reward.cumulativeServiceReward.sub(
968             redeemedServiceReward[reward.receiver]
969         );
970 
971         require(servicePool >= newServiceReward, 'Service pool is smaller than new service reward');
972         redeemedServiceReward[reward.receiver] = reward.cumulativeServiceReward;
973         servicePool = servicePool.sub(newServiceReward);
974 
975         dPoSContract.redeemMiningReward(reward.receiver, reward.cumulativeMiningReward);
976         celerToken.safeTransfer(reward.receiver, newServiceReward);
977 
978         emit RedeemReward(
979             reward.receiver,
980             reward.cumulativeMiningReward,
981             newServiceReward,
982             servicePool
983         );
984     }
985 }