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
137 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
138 
139 pragma solidity ^0.5.0;
140 
141 /**
142  * @title Elliptic curve signature operations
143  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
144  * TODO Remove this library once solidity supports passing a signature to ecrecover.
145  * See https://github.com/ethereum/solidity/issues/864
146  */
147 
148 library ECDSA {
149     /**
150      * @dev Recover signer address from a message by using their signature
151      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
152      * @param signature bytes signature, the signature is generated using web3.eth.sign()
153      */
154     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
155         bytes32 r;
156         bytes32 s;
157         uint8 v;
158 
159         // Check the signature length
160         if (signature.length != 65) {
161             return (address(0));
162         }
163 
164         // Divide the signature in r, s and v variables
165         // ecrecover takes the signature parameters, and the only way to get them
166         // currently is to use assembly.
167         // solhint-disable-next-line no-inline-assembly
168         assembly {
169             r := mload(add(signature, 0x20))
170             s := mload(add(signature, 0x40))
171             v := byte(0, mload(add(signature, 0x60)))
172         }
173 
174         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
175         if (v < 27) {
176             v += 27;
177         }
178 
179         // If the version is correct return the signer address
180         if (v != 27 && v != 28) {
181             return (address(0));
182         } else {
183             return ecrecover(hash, v, r, s);
184         }
185     }
186 
187     /**
188      * toEthSignedMessageHash
189      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
190      * and hash the result
191      */
192     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
193         // 32 is the length in bytes of hash,
194         // enforced by the type signature above
195         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
196     }
197 }
198 
199 // File: openzeppelin-solidity/contracts/access/Roles.sol
200 
201 pragma solidity ^0.5.0;
202 
203 /**
204  * @title Roles
205  * @dev Library for managing addresses assigned to a Role.
206  */
207 library Roles {
208     struct Role {
209         mapping (address => bool) bearer;
210     }
211 
212     /**
213      * @dev give an account access to this role
214      */
215     function add(Role storage role, address account) internal {
216         require(account != address(0));
217         require(!has(role, account));
218 
219         role.bearer[account] = true;
220     }
221 
222     /**
223      * @dev remove an account's access to this role
224      */
225     function remove(Role storage role, address account) internal {
226         require(account != address(0));
227         require(has(role, account));
228 
229         role.bearer[account] = false;
230     }
231 
232     /**
233      * @dev check if an account has this role
234      * @return bool
235      */
236     function has(Role storage role, address account) internal view returns (bool) {
237         require(account != address(0));
238         return role.bearer[account];
239     }
240 }
241 
242 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
243 
244 pragma solidity ^0.5.0;
245 
246 
247 /**
248  * @title WhitelistAdminRole
249  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
250  */
251 contract WhitelistAdminRole {
252     using Roles for Roles.Role;
253 
254     event WhitelistAdminAdded(address indexed account);
255     event WhitelistAdminRemoved(address indexed account);
256 
257     Roles.Role private _whitelistAdmins;
258 
259     constructor () internal {
260         _addWhitelistAdmin(msg.sender);
261     }
262 
263     modifier onlyWhitelistAdmin() {
264         require(isWhitelistAdmin(msg.sender));
265         _;
266     }
267 
268     function isWhitelistAdmin(address account) public view returns (bool) {
269         return _whitelistAdmins.has(account);
270     }
271 
272     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
273         _addWhitelistAdmin(account);
274     }
275 
276     function renounceWhitelistAdmin() public {
277         _removeWhitelistAdmin(msg.sender);
278     }
279 
280     function _addWhitelistAdmin(address account) internal {
281         _whitelistAdmins.add(account);
282         emit WhitelistAdminAdded(account);
283     }
284 
285     function _removeWhitelistAdmin(address account) internal {
286         _whitelistAdmins.remove(account);
287         emit WhitelistAdminRemoved(account);
288     }
289 }
290 
291 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
292 
293 pragma solidity ^0.5.0;
294 
295 
296 
297 /**
298  * @title WhitelistedRole
299  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
300  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
301  * it), and not Whitelisteds themselves.
302  */
303 contract WhitelistedRole is WhitelistAdminRole {
304     using Roles for Roles.Role;
305 
306     event WhitelistedAdded(address indexed account);
307     event WhitelistedRemoved(address indexed account);
308 
309     Roles.Role private _whitelisteds;
310 
311     modifier onlyWhitelisted() {
312         require(isWhitelisted(msg.sender));
313         _;
314     }
315 
316     function isWhitelisted(address account) public view returns (bool) {
317         return _whitelisteds.has(account);
318     }
319 
320     function addWhitelisted(address account) public onlyWhitelistAdmin {
321         _addWhitelisted(account);
322     }
323 
324     function removeWhitelisted(address account) public onlyWhitelistAdmin {
325         _removeWhitelisted(account);
326     }
327 
328     function renounceWhitelisted() public {
329         _removeWhitelisted(msg.sender);
330     }
331 
332     function _addWhitelisted(address account) internal {
333         _whitelisteds.add(account);
334         emit WhitelistedAdded(account);
335     }
336 
337     function _removeWhitelisted(address account) internal {
338         _whitelisteds.remove(account);
339         emit WhitelistedRemoved(account);
340     }
341 }
342 
343 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
344 
345 pragma solidity ^0.5.0;
346 
347 
348 contract PauserRole {
349     using Roles for Roles.Role;
350 
351     event PauserAdded(address indexed account);
352     event PauserRemoved(address indexed account);
353 
354     Roles.Role private _pausers;
355 
356     constructor () internal {
357         _addPauser(msg.sender);
358     }
359 
360     modifier onlyPauser() {
361         require(isPauser(msg.sender));
362         _;
363     }
364 
365     function isPauser(address account) public view returns (bool) {
366         return _pausers.has(account);
367     }
368 
369     function addPauser(address account) public onlyPauser {
370         _addPauser(account);
371     }
372 
373     function renouncePauser() public {
374         _removePauser(msg.sender);
375     }
376 
377     function _addPauser(address account) internal {
378         _pausers.add(account);
379         emit PauserAdded(account);
380     }
381 
382     function _removePauser(address account) internal {
383         _pausers.remove(account);
384         emit PauserRemoved(account);
385     }
386 }
387 
388 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
389 
390 pragma solidity ^0.5.0;
391 
392 
393 /**
394  * @title Pausable
395  * @dev Base contract which allows children to implement an emergency stop mechanism.
396  */
397 contract Pausable is PauserRole {
398     event Paused(address account);
399     event Unpaused(address account);
400 
401     bool private _paused;
402 
403     constructor () internal {
404         _paused = false;
405     }
406 
407     /**
408      * @return true if the contract is paused, false otherwise.
409      */
410     function paused() public view returns (bool) {
411         return _paused;
412     }
413 
414     /**
415      * @dev Modifier to make a function callable only when the contract is not paused.
416      */
417     modifier whenNotPaused() {
418         require(!_paused);
419         _;
420     }
421 
422     /**
423      * @dev Modifier to make a function callable only when the contract is paused.
424      */
425     modifier whenPaused() {
426         require(_paused);
427         _;
428     }
429 
430     /**
431      * @dev called by the owner to pause, triggers stopped state
432      */
433     function pause() public onlyPauser whenNotPaused {
434         _paused = true;
435         emit Paused(msg.sender);
436     }
437 
438     /**
439      * @dev called by the owner to unpause, returns to normal state
440      */
441     function unpause() public onlyPauser whenPaused {
442         _paused = false;
443         emit Unpaused(msg.sender);
444     }
445 }
446 
447 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
448 
449 pragma solidity ^0.5.0;
450 
451 /**
452  * @title Ownable
453  * @dev The Ownable contract has an owner address, and provides basic authorization control
454  * functions, this simplifies the implementation of "user permissions".
455  */
456 contract Ownable {
457     address private _owner;
458 
459     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
460 
461     /**
462      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
463      * account.
464      */
465     constructor () internal {
466         _owner = msg.sender;
467         emit OwnershipTransferred(address(0), _owner);
468     }
469 
470     /**
471      * @return the address of the owner.
472      */
473     function owner() public view returns (address) {
474         return _owner;
475     }
476 
477     /**
478      * @dev Throws if called by any account other than the owner.
479      */
480     modifier onlyOwner() {
481         require(isOwner());
482         _;
483     }
484 
485     /**
486      * @return true if `msg.sender` is the owner of the contract.
487      */
488     function isOwner() public view returns (bool) {
489         return msg.sender == _owner;
490     }
491 
492     /**
493      * @dev Allows the current owner to relinquish control of the contract.
494      * @notice Renouncing to ownership will leave the contract without an owner.
495      * It will not be possible to call the functions with the `onlyOwner`
496      * modifier anymore.
497      */
498     function renounceOwnership() public onlyOwner {
499         emit OwnershipTransferred(_owner, address(0));
500         _owner = address(0);
501     }
502 
503     /**
504      * @dev Allows the current owner to transfer control of the contract to a newOwner.
505      * @param newOwner The address to transfer ownership to.
506      */
507     function transferOwnership(address newOwner) public onlyOwner {
508         _transferOwnership(newOwner);
509     }
510 
511     /**
512      * @dev Transfers control of the contract to a newOwner.
513      * @param newOwner The address to transfer ownership to.
514      */
515     function _transferOwnership(address newOwner) internal {
516         require(newOwner != address(0));
517         emit OwnershipTransferred(_owner, newOwner);
518         _owner = newOwner;
519     }
520 }
521 
522 // File: contracts/lib/interface/IDPoS.sol
523 
524 pragma solidity 0.5.17;
525 
526 /**
527  * @title DPoS interface
528  */
529 interface IDPoS {
530     enum ValidatorChangeType { Add, Removal }
531 
532     // functions
533     function contributeToMiningPool(uint _amount) external;
534 
535     function redeemMiningReward(address _receiver, uint _cumulativeReward) external;
536 
537     function registerSidechain(address _addr) external;
538 
539     function initializeCandidate(uint _minSelfStake, uint _commissionRate, uint _rateLockEndTime) external;
540 
541     function announceIncreaseCommissionRate(uint _newRate, uint _newLockEndTime) external;
542 
543     function confirmIncreaseCommissionRate() external;
544 
545     function nonIncreaseCommissionRate(uint _newRate, uint _newLockEndTime) external;
546 
547     function updateMinSelfStake(uint256 _minSelfStake) external;
548 
549     function delegate(address _candidateAddr, uint _amount) external;
550 
551     function withdrawFromUnbondedCandidate(address _candidateAddr, uint _amount) external;
552 
553     function intendWithdraw(address _candidateAddr, uint _amount) external;
554 
555     function confirmWithdraw(address _candidateAddr) external;
556 
557     function claimValidator() external;
558 
559     function confirmUnbondedCandidate(address _candidateAddr) external;
560 
561     function slash(bytes calldata _penaltyRequest) external;
562 
563     function validateMultiSigMessage(bytes calldata _request) external returns(bool);
564 
565     function isValidDPoS() external view returns (bool);
566 
567     function isValidator(address _addr) external view returns (bool);
568 
569     function getValidatorNum() external view returns (uint);
570 
571     function getMinStakingPool() external view returns (uint);
572 
573     function getCandidateInfo(address _candidateAddr) external view returns (bool, uint, uint, uint, uint, uint, uint);
574 
575     function getDelegatorInfo(address _candidateAddr, address _delegatorAddr) external view returns (uint, uint, uint[] memory, uint[] memory);
576 
577     function getMinQuorumStakingPool() external view returns(uint);
578 
579     function getTotalValidatorStakingPool() external view returns(uint);
580 
581     // TODO: interface can't be inherited, so VoteType is not declared here
582     // function voteParam(uint _proposalId, VoteType _vote) external;
583 
584     // function confirmParamProposal(uint _proposalId) external;
585 
586     // function voteSidechain(uint _proposalId, VoteType _vote) external;
587 
588     // function confirmSidechainProposal(uint _proposalId) external;
589 
590     // events
591     event InitializeCandidate(address indexed candidate, uint minSelfStake, uint commissionRate, uint rateLockEndTime);
592 
593     event CommissionRateAnnouncement(address indexed candidate, uint announcedRate, uint announcedLockEndTime);
594 
595     event UpdateCommissionRate(address indexed candidate, uint newRate, uint newLockEndTime);
596 
597     event UpdateMinSelfStake(address indexed candidate, uint minSelfStake);
598 
599     event Delegate(address indexed delegator, address indexed candidate, uint newStake, uint stakingPool);
600 
601     event ValidatorChange(address indexed ethAddr, ValidatorChangeType indexed changeType);
602 
603     event WithdrawFromUnbondedCandidate(address indexed delegator, address indexed candidate, uint amount);
604 
605     event IntendWithdraw(address indexed delegator, address indexed candidate, uint withdrawAmount, uint proposedTime);
606 
607     event ConfirmWithdraw(address indexed delegator, address indexed candidate, uint amount);
608 
609     event Slash(address indexed validator, address indexed delegator, uint amount);
610 
611     event UpdateDelegatedStake(address indexed delegator, address indexed candidate, uint delegatorStake, uint candidatePool);
612 
613     event Compensate(address indexed indemnitee, uint amount);
614 
615     event CandidateUnbonded(address indexed candidate);
616 
617     event RedeemMiningReward(address indexed receiver, uint reward, uint miningPool);
618 
619     event MiningPoolContribution(address indexed contributor, uint contribution, uint miningPoolSize);
620 }
621 
622 // File: contracts/lib/data/Pb.sol
623 
624 pragma solidity 0.5.17;
625 
626 // runtime proto sol library
627 library Pb {
628     enum WireType { Varint, Fixed64, LengthDelim, StartGroup, EndGroup, Fixed32 }
629 
630     struct Buffer {
631         uint idx;  // the start index of next read. when idx=b.length, we're done
632         bytes b;   // hold serialized proto msg, readonly
633     }
634 
635     // create a new in-memory Buffer object from raw msg bytes
636     function fromBytes(bytes memory raw) internal pure returns (Buffer memory buf) {
637         buf.b = raw;
638         buf.idx = 0;
639     }
640 
641     // whether there are unread bytes
642     function hasMore(Buffer memory buf) internal pure returns (bool) {
643         return buf.idx < buf.b.length;
644     }
645 
646     // decode current field number and wiretype
647     function decKey(Buffer memory buf) internal pure returns (uint tag, WireType wiretype) {
648         uint v = decVarint(buf);
649         tag = v / 8;
650         wiretype = WireType(v & 7);
651     }
652 
653     // count tag occurrences, return an array due to no memory map support
654 	// have to create array for (maxtag+1) size. cnts[tag] = occurrences
655 	// should keep buf.idx unchanged because this is only a count function
656     function cntTags(Buffer memory buf, uint maxtag) internal pure returns (uint[] memory cnts) {
657         uint originalIdx = buf.idx;
658         cnts = new uint[](maxtag+1);  // protobuf's tags are from 1 rather than 0
659         uint tag;
660         WireType wire;
661         while (hasMore(buf)) {
662             (tag, wire) = decKey(buf);
663             cnts[tag] += 1;
664             skipValue(buf, wire);
665         }
666         buf.idx = originalIdx;
667     }
668 
669     // read varint from current buf idx, move buf.idx to next read, return the int value
670     function decVarint(Buffer memory buf) internal pure returns (uint v) {
671         bytes10 tmp;  // proto int is at most 10 bytes (7 bits can be used per byte)
672         bytes memory bb = buf.b;  // get buf.b mem addr to use in assembly
673         v = buf.idx;  // use v to save one additional uint variable
674         assembly {
675             tmp := mload(add(add(bb, 32), v)) // load 10 bytes from buf.b[buf.idx] to tmp
676         }
677         uint b; // store current byte content
678         v = 0; // reset to 0 for return value
679         for (uint i=0; i<10; i++) {
680             assembly {
681                 b := byte(i, tmp)  // don't use tmp[i] because it does bound check and costs extra
682             }
683             v |= (b & 0x7F) << (i * 7);
684             if (b & 0x80 == 0) {
685                 buf.idx += i + 1;
686                 return v;
687             }
688         }
689         revert(); // i=10, invalid varint stream
690     }
691 
692     // read length delimited field and return bytes
693     function decBytes(Buffer memory buf) internal pure returns (bytes memory b) {
694         uint len = decVarint(buf);
695         uint end = buf.idx + len;
696         require(end <= buf.b.length);  // avoid overflow
697         b = new bytes(len);
698         bytes memory bufB = buf.b;  // get buf.b mem addr to use in assembly
699         uint bStart;
700         uint bufBStart = buf.idx;
701         assembly {
702             bStart := add(b, 32)
703             bufBStart := add(add(bufB, 32), bufBStart)
704         }
705         for (uint i=0; i<len; i+=32) {
706             assembly{
707                 mstore(add(bStart, i), mload(add(bufBStart, i)))
708             }
709         }
710         buf.idx = end;
711     }
712 
713     // return packed ints
714     function decPacked(Buffer memory buf) internal pure returns (uint[] memory t) {
715         uint len = decVarint(buf);
716         uint end = buf.idx + len;
717         require(end <= buf.b.length);  // avoid overflow
718         // array in memory must be init w/ known length
719         // so we have to create a tmp array w/ max possible len first
720         uint[] memory tmp = new uint[](len);
721         uint i; // count how many ints are there
722         while (buf.idx < end) {
723             tmp[i] = decVarint(buf);
724             i++;
725         }
726         t = new uint[](i); // init t with correct length
727         for (uint j=0; j<i; j++) {
728             t[j] = tmp[j];
729         }
730         return t;
731     }
732 
733     // move idx pass current value field, to beginning of next tag or msg end
734     function skipValue(Buffer memory buf, WireType wire) internal pure {
735         if (wire == WireType.Varint) { decVarint(buf); }
736         else if (wire == WireType.LengthDelim) {
737             uint len = decVarint(buf);
738             buf.idx += len; // skip len bytes value data
739             require(buf.idx <= buf.b.length);  // avoid overflow
740         } else { revert(); }  // unsupported wiretype
741     }
742 
743     // type conversion help utils
744     function _bool(uint x) internal pure returns (bool v) {
745         return x != 0;
746     }
747 
748     function _uint256(bytes memory b) internal pure returns (uint256 v) {
749         require(b.length <= 32);  // b's length must be smaller than or equal to 32
750         assembly { v := mload(add(b, 32)) }  // load all 32bytes to v
751         v = v >> (8 * (32 - b.length));  // only first b.length is valid
752     }
753 
754     function _address(bytes memory b) internal pure returns (address v) {
755         v = _addressPayable(b);
756     }
757 
758     function _addressPayable(bytes memory b) internal pure returns (address payable v) {
759         require(b.length == 20);
760         //load 32bytes then shift right 12 bytes
761         assembly { v := div(mload(add(b, 32)), 0x1000000000000000000000000) }
762     }
763 
764     function _bytes32(bytes memory b) internal pure returns (bytes32 v) {
765         require(b.length == 32);
766         assembly { v := mload(add(b, 32)) }
767     }
768 
769     // uint[] to uint8[]
770     function uint8s(uint[] memory arr) internal pure returns (uint8[] memory t) {
771         t = new uint8[](arr.length);
772         for (uint i = 0; i < t.length; i++) { t[i] = uint8(arr[i]); }
773     }
774 
775     function uint32s(uint[] memory arr) internal pure returns (uint32[] memory t) {
776         t = new uint32[](arr.length);
777         for (uint i = 0; i < t.length; i++) { t[i] = uint32(arr[i]); }
778     }
779 
780     function uint64s(uint[] memory arr) internal pure returns (uint64[] memory t) {
781         t = new uint64[](arr.length);
782         for (uint i = 0; i < t.length; i++) { t[i] = uint64(arr[i]); }
783     }
784 
785     function bools(uint[] memory arr) internal pure returns (bool[] memory t) {
786         t = new bool[](arr.length);
787         for (uint i = 0; i < t.length; i++) { t[i] = arr[i]!=0; }
788     }
789 }
790 
791 // File: contracts/lib/data/PbSgn.sol
792 
793 // Code generated by protoc-gen-sol. DO NOT EDIT.
794 // source: sgn.proto
795 pragma solidity 0.5.17;
796 
797 
798 library PbSgn {
799     using Pb for Pb.Buffer;  // so we can call Pb funcs on Buffer obj
800 
801     struct MultiSigMessage {
802         bytes msg;   // tag: 1
803         bytes[] sigs;   // tag: 2
804     } // end struct MultiSigMessage
805 
806     function decMultiSigMessage(bytes memory raw) internal pure returns (MultiSigMessage memory m) {
807         Pb.Buffer memory buf = Pb.fromBytes(raw);
808 
809         uint[] memory cnts = buf.cntTags(2);
810         m.sigs = new bytes[](cnts[2]);
811         cnts[2] = 0;  // reset counter for later use
812         
813         uint tag;
814         Pb.WireType wire;
815         while (buf.hasMore()) {
816             (tag, wire) = buf.decKey();
817             if (false) {} // solidity has no switch/case
818             else if (tag == 1) {
819                 m.msg = bytes(buf.decBytes());
820             }
821             else if (tag == 2) {
822                 m.sigs[cnts[2]] = bytes(buf.decBytes());
823                 cnts[2]++;
824             }
825             else { buf.skipValue(wire); } // skip value of unknown tag
826         }
827     } // end decoder MultiSigMessage
828 
829     struct PenaltyRequest {
830         bytes penalty;   // tag: 1
831         bytes[] sigs;   // tag: 2
832     } // end struct PenaltyRequest
833 
834     function decPenaltyRequest(bytes memory raw) internal pure returns (PenaltyRequest memory m) {
835         Pb.Buffer memory buf = Pb.fromBytes(raw);
836 
837         uint[] memory cnts = buf.cntTags(2);
838         m.sigs = new bytes[](cnts[2]);
839         cnts[2] = 0;  // reset counter for later use
840         
841         uint tag;
842         Pb.WireType wire;
843         while (buf.hasMore()) {
844             (tag, wire) = buf.decKey();
845             if (false) {} // solidity has no switch/case
846             else if (tag == 1) {
847                 m.penalty = bytes(buf.decBytes());
848             }
849             else if (tag == 2) {
850                 m.sigs[cnts[2]] = bytes(buf.decBytes());
851                 cnts[2]++;
852             }
853             else { buf.skipValue(wire); } // skip value of unknown tag
854         }
855     } // end decoder PenaltyRequest
856 
857     struct RewardRequest {
858         bytes reward;   // tag: 1
859         bytes[] sigs;   // tag: 2
860     } // end struct RewardRequest
861 
862     function decRewardRequest(bytes memory raw) internal pure returns (RewardRequest memory m) {
863         Pb.Buffer memory buf = Pb.fromBytes(raw);
864 
865         uint[] memory cnts = buf.cntTags(2);
866         m.sigs = new bytes[](cnts[2]);
867         cnts[2] = 0;  // reset counter for later use
868         
869         uint tag;
870         Pb.WireType wire;
871         while (buf.hasMore()) {
872             (tag, wire) = buf.decKey();
873             if (false) {} // solidity has no switch/case
874             else if (tag == 1) {
875                 m.reward = bytes(buf.decBytes());
876             }
877             else if (tag == 2) {
878                 m.sigs[cnts[2]] = bytes(buf.decBytes());
879                 cnts[2]++;
880             }
881             else { buf.skipValue(wire); } // skip value of unknown tag
882         }
883     } // end decoder RewardRequest
884 
885     struct Penalty {
886         uint64 nonce;   // tag: 1
887         uint64 expireTime;   // tag: 2
888         address validatorAddress;   // tag: 3
889         AccountAmtPair[] penalizedDelegators;   // tag: 4
890         AccountAmtPair[] beneficiaries;   // tag: 5
891     } // end struct Penalty
892 
893     function decPenalty(bytes memory raw) internal pure returns (Penalty memory m) {
894         Pb.Buffer memory buf = Pb.fromBytes(raw);
895 
896         uint[] memory cnts = buf.cntTags(5);
897         m.penalizedDelegators = new AccountAmtPair[](cnts[4]);
898         cnts[4] = 0;  // reset counter for later use
899         m.beneficiaries = new AccountAmtPair[](cnts[5]);
900         cnts[5] = 0;  // reset counter for later use
901         
902         uint tag;
903         Pb.WireType wire;
904         while (buf.hasMore()) {
905             (tag, wire) = buf.decKey();
906             if (false) {} // solidity has no switch/case
907             else if (tag == 1) {
908                 m.nonce = uint64(buf.decVarint());
909             }
910             else if (tag == 2) {
911                 m.expireTime = uint64(buf.decVarint());
912             }
913             else if (tag == 3) {
914                 m.validatorAddress = Pb._address(buf.decBytes());
915             }
916             else if (tag == 4) {
917                 m.penalizedDelegators[cnts[4]] = decAccountAmtPair(buf.decBytes());
918                 cnts[4]++;
919             }
920             else if (tag == 5) {
921                 m.beneficiaries[cnts[5]] = decAccountAmtPair(buf.decBytes());
922                 cnts[5]++;
923             }
924             else { buf.skipValue(wire); } // skip value of unknown tag
925         }
926     } // end decoder Penalty
927 
928     struct AccountAmtPair {
929         address account;   // tag: 1
930         uint256 amt;   // tag: 2
931     } // end struct AccountAmtPair
932 
933     function decAccountAmtPair(bytes memory raw) internal pure returns (AccountAmtPair memory m) {
934         Pb.Buffer memory buf = Pb.fromBytes(raw);
935 
936         uint tag;
937         Pb.WireType wire;
938         while (buf.hasMore()) {
939             (tag, wire) = buf.decKey();
940             if (false) {} // solidity has no switch/case
941             else if (tag == 1) {
942                 m.account = Pb._address(buf.decBytes());
943             }
944             else if (tag == 2) {
945                 m.amt = Pb._uint256(buf.decBytes());
946             }
947             else { buf.skipValue(wire); } // skip value of unknown tag
948         }
949     } // end decoder AccountAmtPair
950 
951     struct Reward {
952         address receiver;   // tag: 1
953         uint256 cumulativeMiningReward;   // tag: 2
954         uint256 cumulativeServiceReward;   // tag: 3
955     } // end struct Reward
956 
957     function decReward(bytes memory raw) internal pure returns (Reward memory m) {
958         Pb.Buffer memory buf = Pb.fromBytes(raw);
959 
960         uint tag;
961         Pb.WireType wire;
962         while (buf.hasMore()) {
963             (tag, wire) = buf.decKey();
964             if (false) {} // solidity has no switch/case
965             else if (tag == 1) {
966                 m.receiver = Pb._address(buf.decBytes());
967             }
968             else if (tag == 2) {
969                 m.cumulativeMiningReward = Pb._uint256(buf.decBytes());
970             }
971             else if (tag == 3) {
972                 m.cumulativeServiceReward = Pb._uint256(buf.decBytes());
973             }
974             else { buf.skipValue(wire); } // skip value of unknown tag
975         }
976     } // end decoder Reward
977 
978 }
979 
980 // File: contracts/lib/DPoSCommon.sol
981 
982 pragma solidity 0.5.17;
983 
984 /**
985  * @title DPoS contract common Library
986  * @notice Common items used in DPoS contract
987  */
988 library DPoSCommon {
989     // Unbonded: not a validator and not responsible for previous validator behaviors if any.
990     //   Delegators now are free to withdraw stakes (directly).
991     // Bonded: active validator. Delegators have to wait for slashTimeout to withdraw stakes.
992     // Unbonding: transitional status from Bonded to Unbonded. Candidate has lost the right of
993     //   validator but is still responsible for any misbehaviour done during being validator.
994     //   Delegators should wait until candidate's unbondTime to freely withdraw stakes.
995     enum CandidateStatus { Unbonded, Bonded, Unbonding }
996 }
997 
998 // File: contracts/lib/interface/IGovern.sol
999 
1000 pragma solidity 0.5.17;
1001 
1002 /**
1003  * @title Govern interface
1004  */
1005 interface IGovern {
1006     enum ParamNames { ProposalDeposit, GovernVoteTimeout, SlashTimeout, MinValidatorNum, MaxValidatorNum, MinStakeInPool, AdvanceNoticePeriod, MigrationTime }
1007 
1008     enum ProposalStatus { Uninitiated, Voting, Closed }
1009 
1010     enum VoteType { Unvoted, Yes, No, Abstain }
1011 
1012     // functions
1013     function getUIntValue(uint _record) external view returns (uint);
1014 
1015     function getParamProposalVote(uint _proposalId, address _voter) external view returns (VoteType);
1016 
1017     function isSidechainRegistered(address _sidechainAddr) external view returns (bool);
1018 
1019     function getSidechainProposalVote(uint _proposalId, address _voter) external view returns (VoteType);
1020 
1021     function createParamProposal(uint _record, uint _value) external;
1022 
1023     function registerSidechain(address _addr) external;
1024 
1025     function createSidechainProposal(address _sidechainAddr, bool _registered) external;
1026 
1027     // events
1028     event CreateParamProposal(uint proposalId, address proposer, uint deposit, uint voteDeadline, uint record, uint newValue);
1029 
1030     event VoteParam(uint proposalId, address voter, VoteType voteType);
1031 
1032     event ConfirmParamProposal(uint proposalId, bool passed, uint record, uint newValue);
1033 
1034     event CreateSidechainProposal(uint proposalId, address proposer, uint deposit, uint voteDeadline, address sidechainAddr, bool registered);
1035 
1036     event VoteSidechain(uint proposalId, address voter, VoteType voteType);
1037 
1038     event ConfirmSidechainProposal(uint proposalId, bool passed, address sidechainAddr, bool registered);
1039 }
1040 
1041 // File: contracts/lib/Govern.sol
1042 
1043 pragma solidity 0.5.17;
1044 
1045 
1046 
1047 
1048 
1049 
1050 /**
1051  * @title Governance module for DPoS contract
1052  * @notice Govern contract implements the basic governance logic
1053  * @dev DPoS contract should inherit this contract
1054  * @dev Some specific functions of governance are defined in DPoS contract
1055  */
1056 contract Govern is IGovern, Ownable {
1057     using SafeMath for uint256;
1058     using SafeERC20 for IERC20;
1059 
1060     struct ParamProposal {
1061         address proposer;
1062         uint256 deposit;
1063         uint256 voteDeadline;
1064         uint256 record;
1065         uint256 newValue;
1066         ProposalStatus status;
1067         mapping(address => VoteType) votes;
1068     }
1069 
1070     struct SidechainProposal {
1071         address proposer;
1072         uint256 deposit;
1073         uint256 voteDeadline;
1074         address sidechainAddr;
1075         bool registered;
1076         ProposalStatus status;
1077         mapping(address => VoteType) votes;
1078     }
1079 
1080     IERC20 public celerToken;
1081     // parameters
1082     mapping(uint256 => uint256) public UIntStorage;
1083     mapping(uint256 => ParamProposal) public paramProposals;
1084     uint256 public nextParamProposalId;
1085     // registered sidechain addresses
1086     mapping(address => bool) public registeredSidechains;
1087     mapping(uint256 => SidechainProposal) public sidechainProposals;
1088     uint256 public nextSidechainProposalId;
1089 
1090     /**
1091      * @notice Govern constructor
1092      * @dev set celerToken and initialize all parameters
1093      * @param _celerTokenAddress address of the governance token
1094      * @param _governProposalDeposit required deposit amount for a governance proposal
1095      * @param _governVoteTimeout voting timeout for a governance proposal
1096      * @param _slashTimeout the locking time for funds to be potentially slashed
1097      * @param _minValidatorNum the minimum number of validators
1098      * @param _maxValidatorNum the maximum number of validators
1099      * @param _minStakeInPool the global minimum requirement of staking pool for each validator
1100      * @param _advanceNoticePeriod the time after the announcement and prior to the effective time of an update
1101      */
1102     constructor(
1103         address _celerTokenAddress,
1104         uint256 _governProposalDeposit,
1105         uint256 _governVoteTimeout,
1106         uint256 _slashTimeout,
1107         uint256 _minValidatorNum,
1108         uint256 _maxValidatorNum,
1109         uint256 _minStakeInPool,
1110         uint256 _advanceNoticePeriod
1111     ) public {
1112         celerToken = IERC20(_celerTokenAddress);
1113 
1114         UIntStorage[uint256(ParamNames.ProposalDeposit)] = _governProposalDeposit;
1115         UIntStorage[uint256(ParamNames.GovernVoteTimeout)] = _governVoteTimeout;
1116         UIntStorage[uint256(ParamNames.SlashTimeout)] = _slashTimeout;
1117         UIntStorage[uint256(ParamNames.MinValidatorNum)] = _minValidatorNum;
1118         UIntStorage[uint256(ParamNames.MaxValidatorNum)] = _maxValidatorNum;
1119         UIntStorage[uint256(ParamNames.MinStakeInPool)] = _minStakeInPool;
1120         UIntStorage[uint256(ParamNames.AdvanceNoticePeriod)] = _advanceNoticePeriod;
1121     }
1122 
1123     /********** Get functions **********/
1124     /**
1125      * @notice Get the value of a specific uint parameter
1126      * @param _record the key of this parameter
1127      * @return the value of this parameter
1128      */
1129     function getUIntValue(uint256 _record) public view returns (uint256) {
1130         return UIntStorage[_record];
1131     }
1132 
1133     /**
1134      * @notice Get the vote type of a voter on a parameter proposal
1135      * @param _proposalId the proposal id
1136      * @param _voter the voter address
1137      * @return the vote type of the given voter on the given parameter proposal
1138      */
1139     function getParamProposalVote(uint256 _proposalId, address _voter)
1140         public
1141         view
1142         returns (VoteType)
1143     {
1144         return paramProposals[_proposalId].votes[_voter];
1145     }
1146 
1147     /**
1148      * @notice Get whether a sidechain is registered or not
1149      * @param _sidechainAddr the sidechain contract address
1150      * @return whether the given sidechain is registered or not
1151      */
1152     function isSidechainRegistered(address _sidechainAddr) public view returns (bool) {
1153         return registeredSidechains[_sidechainAddr];
1154     }
1155 
1156     /**
1157      * @notice Get the vote type of a voter on a sidechain proposal
1158      * @param _proposalId the proposal id
1159      * @param _voter the voter address
1160      * @return the vote type of the given voter on the given sidechain proposal
1161      */
1162     function getSidechainProposalVote(uint256 _proposalId, address _voter)
1163         public
1164         view
1165         returns (VoteType)
1166     {
1167         return sidechainProposals[_proposalId].votes[_voter];
1168     }
1169 
1170     /********** Governance functions **********/
1171     /**
1172      * @notice Create a parameter proposal
1173      * @param _record the key of this parameter
1174      * @param _value the new proposed value of this parameter
1175      */
1176     function createParamProposal(uint256 _record, uint256 _value) external {
1177         ParamProposal storage p = paramProposals[nextParamProposalId];
1178         nextParamProposalId = nextParamProposalId + 1;
1179         address msgSender = msg.sender;
1180         uint256 deposit = UIntStorage[uint256(ParamNames.ProposalDeposit)];
1181 
1182         p.proposer = msgSender;
1183         p.deposit = deposit;
1184         p.voteDeadline = block.number.add(UIntStorage[uint256(ParamNames.GovernVoteTimeout)]);
1185         p.record = _record;
1186         p.newValue = _value;
1187         p.status = ProposalStatus.Voting;
1188 
1189         celerToken.safeTransferFrom(msgSender, address(this), deposit);
1190 
1191         emit CreateParamProposal(
1192             nextParamProposalId - 1,
1193             msgSender,
1194             deposit,
1195             p.voteDeadline,
1196             _record,
1197             _value
1198         );
1199     }
1200 
1201     /**
1202      * @notice Internal function to vote for a parameter proposal
1203      * @dev Must be used in DPoS contract
1204      * @param _proposalId the proposal id
1205      * @param _voter the voter address
1206      * @param _vote the vote type
1207      */
1208     function internalVoteParam(
1209         uint256 _proposalId,
1210         address _voter,
1211         VoteType _vote
1212     ) internal {
1213         ParamProposal storage p = paramProposals[_proposalId];
1214         require(p.status == ProposalStatus.Voting, 'Invalid proposal status');
1215         require(block.number < p.voteDeadline, 'Vote deadline reached');
1216         require(p.votes[_voter] == VoteType.Unvoted, 'Voter has voted');
1217 
1218         p.votes[_voter] = _vote;
1219 
1220         emit VoteParam(_proposalId, _voter, _vote);
1221     }
1222 
1223     /**
1224      * @notice Internal function to confirm a parameter proposal
1225      * @dev Must be used in DPoS contract
1226      * @param _proposalId the proposal id
1227      * @param _passed proposal passed or not
1228      */
1229     function internalConfirmParamProposal(uint256 _proposalId, bool _passed) internal {
1230         ParamProposal storage p = paramProposals[_proposalId];
1231         require(p.status == ProposalStatus.Voting, 'Invalid proposal status');
1232         require(block.number >= p.voteDeadline, 'Vote deadline not reached');
1233 
1234         p.status = ProposalStatus.Closed;
1235         if (_passed) {
1236             celerToken.safeTransfer(p.proposer, p.deposit);
1237             UIntStorage[p.record] = p.newValue;
1238         }
1239 
1240         emit ConfirmParamProposal(_proposalId, _passed, p.record, p.newValue);
1241     }
1242 
1243     //
1244     /**
1245      * @notice Register a sidechain by contract owner
1246      * @dev Owner can renounce Ownership if needed for this function
1247      * @param _addr the sidechain contract address
1248      */
1249     function registerSidechain(address _addr) external onlyOwner {
1250         registeredSidechains[_addr] = true;
1251     }
1252 
1253     /**
1254      * @notice Create a sidechain proposal
1255      * @param _sidechainAddr the sidechain contract address
1256      * @param _registered the new proposed registration status
1257      */
1258     function createSidechainProposal(address _sidechainAddr, bool _registered) external {
1259         SidechainProposal storage p = sidechainProposals[nextSidechainProposalId];
1260         nextSidechainProposalId = nextSidechainProposalId + 1;
1261         address msgSender = msg.sender;
1262         uint256 deposit = UIntStorage[uint256(ParamNames.ProposalDeposit)];
1263 
1264         p.proposer = msgSender;
1265         p.deposit = deposit;
1266         p.voteDeadline = block.number.add(UIntStorage[uint256(ParamNames.GovernVoteTimeout)]);
1267         p.sidechainAddr = _sidechainAddr;
1268         p.registered = _registered;
1269         p.status = ProposalStatus.Voting;
1270 
1271         celerToken.safeTransferFrom(msgSender, address(this), deposit);
1272 
1273         emit CreateSidechainProposal(
1274             nextSidechainProposalId - 1,
1275             msgSender,
1276             deposit,
1277             p.voteDeadline,
1278             _sidechainAddr,
1279             _registered
1280         );
1281     }
1282 
1283     /**
1284      * @notice Internal function to vote for a sidechain proposal
1285      * @dev Must be used in DPoS contract
1286      * @param _proposalId the proposal id
1287      * @param _voter the voter address
1288      * @param _vote the vote type
1289      */
1290     function internalVoteSidechain(
1291         uint256 _proposalId,
1292         address _voter,
1293         VoteType _vote
1294     ) internal {
1295         SidechainProposal storage p = sidechainProposals[_proposalId];
1296         require(p.status == ProposalStatus.Voting, 'Invalid proposal status');
1297         require(block.number < p.voteDeadline, 'Vote deadline reached');
1298         require(p.votes[_voter] == VoteType.Unvoted, 'Voter has voted');
1299 
1300         p.votes[_voter] = _vote;
1301 
1302         emit VoteSidechain(_proposalId, _voter, _vote);
1303     }
1304 
1305     /**
1306      * @notice Internal function to confirm a sidechain proposal
1307      * @dev Must be used in DPoS contract
1308      * @param _proposalId the proposal id
1309      * @param _passed proposal passed or not
1310      */
1311     function internalConfirmSidechainProposal(uint256 _proposalId, bool _passed) internal {
1312         SidechainProposal storage p = sidechainProposals[_proposalId];
1313         require(p.status == ProposalStatus.Voting, 'Invalid proposal status');
1314         require(block.number >= p.voteDeadline, 'Vote deadline not reached');
1315 
1316         p.status = ProposalStatus.Closed;
1317         if (_passed) {
1318             celerToken.safeTransfer(p.proposer, p.deposit);
1319             registeredSidechains[p.sidechainAddr] = p.registered;
1320         }
1321 
1322         emit ConfirmSidechainProposal(_proposalId, _passed, p.sidechainAddr, p.registered);
1323     }
1324 }
1325 
1326 // File: contracts/DPoS.sol
1327 
1328 pragma solidity 0.5.17;
1329 
1330 
1331 
1332 
1333 
1334 
1335 
1336 
1337 
1338 
1339 
1340 
1341 /**
1342  * @title A DPoS contract shared by every sidechain
1343  * @notice This contract holds the basic logic of DPoS in Celer's coherent sidechain system
1344  */
1345 contract DPoS is IDPoS, Ownable, Pausable, WhitelistedRole, Govern {
1346     using SafeMath for uint256;
1347     using SafeERC20 for IERC20;
1348     using ECDSA for bytes32;
1349 
1350     enum MathOperation { Add, Sub }
1351 
1352     struct WithdrawIntent {
1353         uint256 amount;
1354         uint256 proposedTime;
1355     }
1356 
1357     struct Delegator {
1358         uint256 delegatedStake;
1359         uint256 undelegatingStake;
1360         mapping(uint256 => WithdrawIntent) withdrawIntents;
1361         // valid intent range is [intentStartIndex, intentEndIndex)
1362         uint256 intentStartIndex;
1363         uint256 intentEndIndex;
1364     }
1365 
1366     struct ValidatorCandidate {
1367         bool initialized;
1368         uint256 minSelfStake;
1369         uint256 stakingPool; // sum of all delegations to this candidate
1370         mapping(address => Delegator) delegatorProfiles;
1371         DPoSCommon.CandidateStatus status;
1372         uint256 unbondTime;
1373         uint256 commissionRate; // equal to real commission rate * COMMISSION_RATE_BASE
1374         uint256 rateLockEndTime; // must be monotonic increasing. Use block number
1375         // for the announcement of increasing commission rate
1376         uint256 announcedRate;
1377         uint256 announcedLockEndTime;
1378         uint256 announcementTime;
1379         // for decreasing minSelfStake
1380         uint256 earliestBondTime;
1381     }
1382 
1383     mapping(uint256 => address) public validatorSet;
1384     mapping(uint256 => bool) public usedPenaltyNonce;
1385     // used in checkValidatorSigs(). mapping has to be storage type.
1386     mapping(address => bool) public checkedValidators;
1387     // struct ValidatorCandidate includes a mapping and therefore candidateProfiles can't be public
1388     mapping(address => ValidatorCandidate) private candidateProfiles;
1389     mapping(address => uint256) public redeemedMiningReward;
1390 
1391     /********** Constants **********/
1392     uint256 constant DECIMALS_MULTIPLIER = 10**18;
1393     uint256 public constant COMMISSION_RATE_BASE = 10000; // 1 commissionRate means 0.01%
1394 
1395     uint256 public dposGoLiveTime; // used when bootstrapping initial validators
1396     uint256 public miningPool;
1397     bool public enableWhitelist;
1398     bool public enableSlash;
1399 
1400     /**
1401      * @notice Throws if given address is zero address
1402      * @param _addr address to be checked
1403      */
1404     modifier onlyNonZeroAddr(address _addr) {
1405         require(_addr != address(0), '0 address');
1406         _;
1407     }
1408 
1409     /**
1410      * @notice Throws if DPoS is not valid
1411      * @dev Need to be checked before DPoS's operations
1412      */
1413     modifier onlyValidDPoS() {
1414         require(isValidDPoS(), 'DPoS is not valid');
1415         _;
1416     }
1417 
1418     /**
1419      * @notice Throws if msg.sender is not a registered sidechain
1420      */
1421     modifier onlyRegisteredSidechains() {
1422         require(isSidechainRegistered(msg.sender), 'Sidechain not registered');
1423         _;
1424     }
1425 
1426     /**
1427      * @notice Check if the sender is in the whitelist
1428      */
1429     modifier onlyWhitelist() {
1430         if (enableWhitelist) {
1431             require(
1432                 isWhitelisted(msg.sender),
1433                 'WhitelistedRole: caller does not have the Whitelisted role'
1434             );
1435         }
1436         _;
1437     }
1438 
1439     /**
1440      * @notice Throws if contract in migrating state
1441      */
1442     modifier onlyNotMigrating() {
1443         require(!isMigrating(), 'contract migrating');
1444         _;
1445     }
1446 
1447     /**
1448      * @notice Throws if amount is smaller than minimum
1449      */
1450     modifier minAmount(uint256 _amount, uint256 _min) {
1451         require(_amount >= _min, 'Amount is smaller than minimum requirement');
1452         _;
1453     }
1454 
1455     /**
1456      * @notice Throws if sender is not validator
1457      */
1458     modifier onlyValidator() {
1459         require(isValidator(msg.sender), 'msg sender is not a validator');
1460         _;
1461     }
1462 
1463     /**
1464      * @notice Throws if candidate is not initialized
1465      */
1466     modifier isCandidateInitialized() {
1467         require(candidateProfiles[msg.sender].initialized, 'Candidate is not initialized');
1468         _;
1469     }
1470 
1471     /**
1472      * @notice DPoS constructor
1473      * @dev will initialize parent contract Govern first
1474      * @param _celerTokenAddress address of Celer Token Contract
1475      * @param _governProposalDeposit required deposit amount for a governance proposal
1476      * @param _governVoteTimeout voting timeout for a governance proposal
1477      * @param _slashTimeout the locking time for funds to be potentially slashed
1478      * @param _minValidatorNum the minimum number of validators
1479      * @param _maxValidatorNum the maximum number of validators
1480      * @param _minStakeInPool the global minimum requirement of staking pool for each validator
1481      * @param _advanceNoticePeriod the wait time after the announcement and prior to the effective date of an update
1482      * @param _dposGoLiveTimeout the timeout for DPoS to go live after contract creation
1483      */
1484     constructor(
1485         address _celerTokenAddress,
1486         uint256 _governProposalDeposit,
1487         uint256 _governVoteTimeout,
1488         uint256 _slashTimeout,
1489         uint256 _minValidatorNum,
1490         uint256 _maxValidatorNum,
1491         uint256 _minStakeInPool,
1492         uint256 _advanceNoticePeriod,
1493         uint256 _dposGoLiveTimeout
1494     )
1495         public
1496         Govern(
1497             _celerTokenAddress,
1498             _governProposalDeposit,
1499             _governVoteTimeout,
1500             _slashTimeout,
1501             _minValidatorNum,
1502             _maxValidatorNum,
1503             _minStakeInPool,
1504             _advanceNoticePeriod
1505         )
1506     {
1507         dposGoLiveTime = block.number.add(_dposGoLiveTimeout);
1508         enableSlash = true;
1509     }
1510 
1511     /**
1512      * @notice Update enableWhitelist
1513      * @param _enable enable whitelist flag
1514      */
1515     function updateEnableWhitelist(bool _enable) external onlyOwner {
1516         enableWhitelist = _enable;
1517     }
1518 
1519     /**
1520      * @notice Update enableSlash
1521      * @param _enable enable slash flag
1522      */
1523     function updateEnableSlash(bool _enable) external onlyOwner {
1524         enableSlash = _enable;
1525     }
1526 
1527     /**
1528      * @notice Owner drains one type of tokens when the contract is paused
1529      * @dev This is for emergency situations.
1530      * @param _amount drained token amount
1531      */
1532     function drainToken(uint256 _amount) external whenPaused onlyOwner {
1533         celerToken.safeTransfer(msg.sender, _amount);
1534     }
1535 
1536     /**
1537      * @notice Vote for a parameter proposal with a specific type of vote
1538      * @param _proposalId the id of the parameter proposal
1539      * @param _vote the type of vote
1540      */
1541     function voteParam(uint256 _proposalId, VoteType _vote) external onlyValidator {
1542         internalVoteParam(_proposalId, msg.sender, _vote);
1543     }
1544 
1545     /**
1546      * @notice Confirm a parameter proposal
1547      * @param _proposalId the id of the parameter proposal
1548      */
1549     function confirmParamProposal(uint256 _proposalId) external {
1550         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
1551 
1552         // check Yes votes only now
1553         uint256 yesVoteStakes;
1554         for (uint256 i = 0; i < maxValidatorNum; i++) {
1555             if (getParamProposalVote(_proposalId, validatorSet[i]) == VoteType.Yes) {
1556                 yesVoteStakes = yesVoteStakes.add(candidateProfiles[validatorSet[i]].stakingPool);
1557             }
1558         }
1559 
1560         bool passed = yesVoteStakes >= getMinQuorumStakingPool();
1561         if (!passed) {
1562             miningPool = miningPool.add(paramProposals[_proposalId].deposit);
1563         }
1564         internalConfirmParamProposal(_proposalId, passed);
1565     }
1566 
1567     /**
1568      * @notice Vote for a sidechain proposal with a specific type of vote
1569      * @param _proposalId the id of the sidechain proposal
1570      * @param _vote the type of vote
1571      */
1572     function voteSidechain(uint256 _proposalId, VoteType _vote) external onlyValidator {
1573         internalVoteSidechain(_proposalId, msg.sender, _vote);
1574     }
1575 
1576     /**
1577      * @notice Confirm a sidechain proposal
1578      * @param _proposalId the id of the sidechain proposal
1579      */
1580     function confirmSidechainProposal(uint256 _proposalId) external {
1581         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
1582 
1583         // check Yes votes only now
1584         uint256 yesVoteStakes;
1585         for (uint256 i = 0; i < maxValidatorNum; i++) {
1586             if (getSidechainProposalVote(_proposalId, validatorSet[i]) == VoteType.Yes) {
1587                 yesVoteStakes = yesVoteStakes.add(candidateProfiles[validatorSet[i]].stakingPool);
1588             }
1589         }
1590 
1591         bool passed = yesVoteStakes >= getMinQuorumStakingPool();
1592         if (!passed) {
1593             miningPool = miningPool.add(sidechainProposals[_proposalId].deposit);
1594         }
1595         internalConfirmSidechainProposal(_proposalId, passed);
1596     }
1597 
1598     /**
1599      * @notice Contribute CELR tokens to the mining pool
1600      * @param _amount the amount of CELR tokens to contribute
1601      */
1602     function contributeToMiningPool(uint256 _amount) external whenNotPaused {
1603         address msgSender = msg.sender;
1604         miningPool = miningPool.add(_amount);
1605         celerToken.safeTransferFrom(msgSender, address(this), _amount);
1606 
1607         emit MiningPoolContribution(msgSender, _amount, miningPool);
1608     }
1609 
1610     /**
1611      * @notice Redeem mining reward
1612      * @dev The validation of this redeeming operation should be done by the caller, a registered sidechain contract
1613      * @dev Here we use cumulative mining reward to simplify the logic in sidechain code
1614      * @param _receiver the receiver of the redeemed mining reward
1615      * @param _cumulativeReward the latest cumulative mining reward
1616      */
1617     function redeemMiningReward(address _receiver, uint256 _cumulativeReward)
1618         external
1619         whenNotPaused
1620         onlyRegisteredSidechains
1621     {
1622         uint256 newReward = _cumulativeReward.sub(redeemedMiningReward[_receiver]);
1623         require(miningPool >= newReward, 'Mining pool is smaller than new reward');
1624 
1625         redeemedMiningReward[_receiver] = _cumulativeReward;
1626         miningPool = miningPool.sub(newReward);
1627         celerToken.safeTransfer(_receiver, newReward);
1628 
1629         emit RedeemMiningReward(_receiver, newReward, miningPool);
1630     }
1631 
1632     /**
1633      * @notice Initialize a candidate profile for validator
1634      * @dev every validator must become a candidate first
1635      * @param _minSelfStake minimal amount of tokens staked by the validator itself
1636      * @param _commissionRate the self-declaimed commission rate
1637      * @param _rateLockEndTime the lock end time of initial commission rate
1638      */
1639     function initializeCandidate(
1640         uint256 _minSelfStake,
1641         uint256 _commissionRate,
1642         uint256 _rateLockEndTime
1643     ) external whenNotPaused onlyWhitelist {
1644         ValidatorCandidate storage candidate = candidateProfiles[msg.sender];
1645         require(!candidate.initialized, 'Candidate is initialized');
1646         require(_commissionRate <= COMMISSION_RATE_BASE, 'Invalid commission rate');
1647 
1648         candidate.initialized = true;
1649         candidate.minSelfStake = _minSelfStake;
1650         candidate.commissionRate = _commissionRate;
1651         candidate.rateLockEndTime = _rateLockEndTime;
1652 
1653         emit InitializeCandidate(msg.sender, _minSelfStake, _commissionRate, _rateLockEndTime);
1654     }
1655 
1656     /**
1657      * @notice Apply non-increase-commission-rate changes to commission rate or lock end time,
1658      *   including decreasing commission rate and/or changing lock end time
1659      * @dev It can increase lock end time immediately without waiting
1660      * @param _newRate new commission rate
1661      * @param _newLockEndTime new lock end time
1662      */
1663     function nonIncreaseCommissionRate(uint256 _newRate, uint256 _newLockEndTime)
1664         external
1665         isCandidateInitialized
1666     {
1667         ValidatorCandidate storage candidate = candidateProfiles[msg.sender];
1668         require(_newRate <= candidate.commissionRate, 'Invalid new rate');
1669 
1670         _updateCommissionRate(candidate, _newRate, _newLockEndTime);
1671     }
1672 
1673     /**
1674      * @notice Announce the intent of increasing the commission rate
1675      * @param _newRate new commission rate
1676      * @param _newLockEndTime new lock end time
1677      */
1678     function announceIncreaseCommissionRate(uint256 _newRate, uint256 _newLockEndTime)
1679         external
1680         isCandidateInitialized
1681     {
1682         ValidatorCandidate storage candidate = candidateProfiles[msg.sender];
1683         require(candidate.commissionRate < _newRate, 'Invalid new rate');
1684 
1685         candidate.announcedRate = _newRate;
1686         candidate.announcedLockEndTime = _newLockEndTime;
1687         candidate.announcementTime = block.number;
1688 
1689         emit CommissionRateAnnouncement(msg.sender, _newRate, _newLockEndTime);
1690     }
1691 
1692     /**
1693      * @notice Confirm the intent of increasing the commission rate
1694      */
1695     function confirmIncreaseCommissionRate() external isCandidateInitialized {
1696         ValidatorCandidate storage candidate = candidateProfiles[msg.sender];
1697         require(
1698             block.number >
1699                 candidate.announcementTime.add(
1700                     getUIntValue(uint256(ParamNames.AdvanceNoticePeriod))
1701                 ),
1702             'Still in notice period'
1703         );
1704 
1705         _updateCommissionRate(candidate, candidate.announcedRate, candidate.announcedLockEndTime);
1706 
1707         delete candidate.announcedRate;
1708         delete candidate.announcedLockEndTime;
1709         delete candidate.announcementTime;
1710     }
1711 
1712     /**
1713      * @notice update minimal self stake value
1714      * @param _minSelfStake minimal amount of tokens staked by the validator itself
1715      */
1716     function updateMinSelfStake(uint256 _minSelfStake) external isCandidateInitialized {
1717         ValidatorCandidate storage candidate = candidateProfiles[msg.sender];
1718         if (_minSelfStake < candidate.minSelfStake) {
1719             require(candidate.status != DPoSCommon.CandidateStatus.Bonded, 'Candidate is bonded');
1720             candidate.earliestBondTime = block.number.add(
1721                 getUIntValue(uint256(ParamNames.AdvanceNoticePeriod))
1722             );
1723         }
1724         candidate.minSelfStake = _minSelfStake;
1725         emit UpdateMinSelfStake(msg.sender, _minSelfStake);
1726     }
1727 
1728     /**
1729      * @notice Delegate CELR tokens to a candidate
1730      * @param _candidateAddr candidate to delegate
1731      * @param _amount the amount of delegated CELR tokens
1732      */
1733     function delegate(address _candidateAddr, uint256 _amount)
1734         external
1735         whenNotPaused
1736         onlyNonZeroAddr(_candidateAddr)
1737         minAmount(_amount, 1 * DECIMALS_MULTIPLIER) // minimal amount per delegate operation is 1 CELR
1738     {
1739         ValidatorCandidate storage candidate = candidateProfiles[_candidateAddr];
1740         require(candidate.initialized, 'Candidate is not initialized');
1741 
1742         address msgSender = msg.sender;
1743         _updateDelegatedStake(candidate, _candidateAddr, msgSender, _amount, MathOperation.Add);
1744 
1745         celerToken.safeTransferFrom(msgSender, address(this), _amount);
1746 
1747         emit Delegate(msgSender, _candidateAddr, _amount, candidate.stakingPool);
1748     }
1749 
1750     /**
1751      * @notice Candidate claims to become a validator
1752      */
1753     function claimValidator() external isCandidateInitialized {
1754         address msgSender = msg.sender;
1755         ValidatorCandidate storage candidate = candidateProfiles[msgSender];
1756         require(
1757             candidate.status == DPoSCommon.CandidateStatus.Unbonded ||
1758                 candidate.status == DPoSCommon.CandidateStatus.Unbonding,
1759             'Invalid candidate status'
1760         );
1761         require(block.number >= candidate.earliestBondTime, 'Not earliest bond time yet');
1762         require(
1763             candidate.stakingPool >= getUIntValue(uint256(ParamNames.MinStakeInPool)),
1764             'Insufficient staking pool'
1765         );
1766         require(
1767             candidate.delegatorProfiles[msgSender].delegatedStake >= candidate.minSelfStake,
1768             'Not enough self stake'
1769         );
1770 
1771         uint256 minStakingPoolIndex;
1772         uint256 minStakingPool = candidateProfiles[validatorSet[0]].stakingPool;
1773         require(validatorSet[0] != msgSender, 'Already in validator set');
1774         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
1775         for (uint256 i = 1; i < maxValidatorNum; i++) {
1776             require(validatorSet[i] != msgSender, 'Already in validator set');
1777             if (candidateProfiles[validatorSet[i]].stakingPool < minStakingPool) {
1778                 minStakingPoolIndex = i;
1779                 minStakingPool = candidateProfiles[validatorSet[i]].stakingPool;
1780             }
1781         }
1782         require(candidate.stakingPool > minStakingPool, 'Not larger than smallest pool');
1783 
1784         address removedValidator = validatorSet[minStakingPoolIndex];
1785         if (removedValidator != address(0)) {
1786             _removeValidator(minStakingPoolIndex);
1787         }
1788         _addValidator(msgSender, minStakingPoolIndex);
1789     }
1790 
1791     /**
1792      * @notice Confirm candidate status from Unbonding to Unbonded
1793      * @param _candidateAddr the address of the candidate
1794      */
1795     function confirmUnbondedCandidate(address _candidateAddr) external {
1796         ValidatorCandidate storage candidate = candidateProfiles[_candidateAddr];
1797         require(
1798             candidate.status == DPoSCommon.CandidateStatus.Unbonding,
1799             'Candidate not unbonding'
1800         );
1801         require(block.number >= candidate.unbondTime, 'Unbonding time not reached');
1802 
1803         candidate.status = DPoSCommon.CandidateStatus.Unbonded;
1804         delete candidate.unbondTime;
1805         emit CandidateUnbonded(_candidateAddr);
1806     }
1807 
1808     /**
1809      * @notice Withdraw delegated stakes from an unbonded candidate
1810      * @dev note that the stakes are delegated by the msgSender to the candidate
1811      * @param _candidateAddr the address of the candidate
1812      * @param _amount withdrawn amount
1813      */
1814     function withdrawFromUnbondedCandidate(address _candidateAddr, uint256 _amount)
1815         external
1816         onlyNonZeroAddr(_candidateAddr)
1817         minAmount(_amount, 1 * DECIMALS_MULTIPLIER)
1818     {
1819         ValidatorCandidate storage candidate = candidateProfiles[_candidateAddr];
1820         require(
1821             candidate.status == DPoSCommon.CandidateStatus.Unbonded || isMigrating(),
1822             'invalid status'
1823         );
1824 
1825         address msgSender = msg.sender;
1826         _updateDelegatedStake(candidate, _candidateAddr, msgSender, _amount, MathOperation.Sub);
1827         celerToken.safeTransfer(msgSender, _amount);
1828 
1829         emit WithdrawFromUnbondedCandidate(msgSender, _candidateAddr, _amount);
1830     }
1831 
1832     /**
1833      * @notice Intend to withdraw delegated stakes from a candidate
1834      * @dev note that the stakes are delegated by the msgSender to the candidate
1835      * @param _candidateAddr the address of the candidate
1836      * @param _amount withdrawn amount
1837      */
1838     function intendWithdraw(address _candidateAddr, uint256 _amount)
1839         external
1840         onlyNonZeroAddr(_candidateAddr)
1841         minAmount(_amount, 1 * DECIMALS_MULTIPLIER)
1842     {
1843         address msgSender = msg.sender;
1844 
1845         ValidatorCandidate storage candidate = candidateProfiles[_candidateAddr];
1846         Delegator storage delegator = candidate.delegatorProfiles[msgSender];
1847 
1848         _updateDelegatedStake(candidate, _candidateAddr, msgSender, _amount, MathOperation.Sub);
1849         delegator.undelegatingStake = delegator.undelegatingStake.add(_amount);
1850         _validateValidator(_candidateAddr);
1851 
1852         WithdrawIntent storage withdrawIntent = delegator.withdrawIntents[delegator.intentEndIndex];
1853         withdrawIntent.amount = _amount;
1854         withdrawIntent.proposedTime = block.number;
1855         delegator.intentEndIndex++;
1856 
1857         emit IntendWithdraw(msgSender, _candidateAddr, _amount, withdrawIntent.proposedTime);
1858     }
1859 
1860     /**
1861      * @notice Confirm an intent of withdrawing delegated stakes from a candidate
1862      * @dev note that the stakes are delegated by the msgSender to the candidate
1863      * @param _candidateAddr the address of the candidate
1864      */
1865     function confirmWithdraw(address _candidateAddr) external onlyNonZeroAddr(_candidateAddr) {
1866         address msgSender = msg.sender;
1867         Delegator storage delegator = candidateProfiles[_candidateAddr]
1868             .delegatorProfiles[msgSender];
1869 
1870         uint256 slashTimeout = getUIntValue(uint256(ParamNames.SlashTimeout));
1871         bool isUnbonded = candidateProfiles[_candidateAddr].status ==
1872             DPoSCommon.CandidateStatus.Unbonded;
1873         // for all undelegated withdraw intents
1874         uint256 i;
1875         for (i = delegator.intentStartIndex; i < delegator.intentEndIndex; i++) {
1876             if (
1877                 isUnbonded ||
1878                 delegator.withdrawIntents[i].proposedTime.add(slashTimeout) <= block.number
1879             ) {
1880                 // withdraw intent is undelegated when the validator becomes unbonded or
1881                 // the slashTimeout for the withdraw intent is up.
1882                 delete delegator.withdrawIntents[i];
1883                 continue;
1884             }
1885             break;
1886         }
1887         delegator.intentStartIndex = i;
1888         // for all undelegating withdraw intents
1889         uint256 undelegatingStakeWithoutSlash;
1890         for (; i < delegator.intentEndIndex; i++) {
1891             undelegatingStakeWithoutSlash = undelegatingStakeWithoutSlash.add(
1892                 delegator.withdrawIntents[i].amount
1893             );
1894         }
1895 
1896         uint256 withdrawAmt;
1897         if (delegator.undelegatingStake > undelegatingStakeWithoutSlash) {
1898             withdrawAmt = delegator.undelegatingStake.sub(undelegatingStakeWithoutSlash);
1899             delegator.undelegatingStake = undelegatingStakeWithoutSlash;
1900 
1901             celerToken.safeTransfer(msgSender, withdrawAmt);
1902         }
1903 
1904         emit ConfirmWithdraw(msgSender, _candidateAddr, withdrawAmt);
1905     }
1906 
1907     /**
1908      * @notice Slash a validator and its delegators
1909      * @param _penaltyRequest penalty request bytes coded in protobuf
1910      */
1911     function slash(bytes calldata _penaltyRequest)
1912         external
1913         whenNotPaused
1914         onlyValidDPoS
1915         onlyNotMigrating
1916     {
1917         require(enableSlash, 'Slash is disabled');
1918         PbSgn.PenaltyRequest memory penaltyRequest = PbSgn.decPenaltyRequest(_penaltyRequest);
1919         PbSgn.Penalty memory penalty = PbSgn.decPenalty(penaltyRequest.penalty);
1920 
1921         ValidatorCandidate storage validator = candidateProfiles[penalty.validatorAddress];
1922         require(validator.status != DPoSCommon.CandidateStatus.Unbonded, 'Validator unbounded');
1923 
1924         bytes32 h = keccak256(penaltyRequest.penalty);
1925         require(_checkValidatorSigs(h, penaltyRequest.sigs), 'Validator sigs verification failed');
1926         require(block.number < penalty.expireTime, 'Penalty expired');
1927         require(!usedPenaltyNonce[penalty.nonce], 'Used penalty nonce');
1928         usedPenaltyNonce[penalty.nonce] = true;
1929 
1930         uint256 totalSubAmt;
1931         for (uint256 i = 0; i < penalty.penalizedDelegators.length; i++) {
1932             PbSgn.AccountAmtPair memory penalizedDelegator = penalty.penalizedDelegators[i];
1933             totalSubAmt = totalSubAmt.add(penalizedDelegator.amt);
1934             emit Slash(
1935                 penalty.validatorAddress,
1936                 penalizedDelegator.account,
1937                 penalizedDelegator.amt
1938             );
1939 
1940             Delegator storage delegator = validator.delegatorProfiles[penalizedDelegator.account];
1941             uint256 _amt;
1942             if (delegator.delegatedStake >= penalizedDelegator.amt) {
1943                 _amt = penalizedDelegator.amt;
1944             } else {
1945                 uint256 remainingAmt = penalizedDelegator.amt.sub(delegator.delegatedStake);
1946                 delegator.undelegatingStake = delegator.undelegatingStake.sub(remainingAmt);
1947                 _amt = delegator.delegatedStake;
1948             }
1949             _updateDelegatedStake(
1950                 validator,
1951                 penalty.validatorAddress,
1952                 penalizedDelegator.account,
1953                 _amt,
1954                 MathOperation.Sub
1955             );
1956         }
1957         _validateValidator(penalty.validatorAddress);
1958 
1959         uint256 totalAddAmt;
1960         for (uint256 i = 0; i < penalty.beneficiaries.length; i++) {
1961             PbSgn.AccountAmtPair memory beneficiary = penalty.beneficiaries[i];
1962             totalAddAmt = totalAddAmt.add(beneficiary.amt);
1963 
1964             if (beneficiary.account == address(0)) {
1965                 // address(0) stands for miningPool
1966                 miningPool = miningPool.add(beneficiary.amt);
1967             } else if (beneficiary.account == address(1)) {
1968                 // address(1) means beneficiary is msg sender
1969                 celerToken.safeTransfer(msg.sender, beneficiary.amt);
1970                 emit Compensate(msg.sender, beneficiary.amt);
1971             } else {
1972                 celerToken.safeTransfer(beneficiary.account, beneficiary.amt);
1973                 emit Compensate(beneficiary.account, beneficiary.amt);
1974             }
1975         }
1976 
1977         require(totalSubAmt == totalAddAmt, 'Amount not match');
1978     }
1979 
1980     /**
1981      * @notice Validate multi-signed message
1982      * @dev Can't use view here because _checkValidatorSigs is not a view function
1983      * @param _request a multi-signed message bytes coded in protobuf
1984      * @return passed the validation or not
1985      */
1986     function validateMultiSigMessage(bytes calldata _request)
1987         external
1988         onlyRegisteredSidechains
1989         returns (bool)
1990     {
1991         PbSgn.MultiSigMessage memory request = PbSgn.decMultiSigMessage(_request);
1992         bytes32 h = keccak256(request.msg);
1993 
1994         return _checkValidatorSigs(h, request.sigs);
1995     }
1996 
1997     /**
1998      * @notice Get the minimum staking pool of all validators
1999      * @return the minimum staking pool of all validators
2000      */
2001     function getMinStakingPool() external view returns (uint256) {
2002         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
2003 
2004         uint256 minStakingPool = candidateProfiles[validatorSet[0]].stakingPool;
2005         for (uint256 i = 0; i < maxValidatorNum; i++) {
2006             if (validatorSet[i] == address(0)) {
2007                 return 0;
2008             }
2009             if (candidateProfiles[validatorSet[i]].stakingPool < minStakingPool) {
2010                 minStakingPool = candidateProfiles[validatorSet[i]].stakingPool;
2011             }
2012         }
2013 
2014         return minStakingPool;
2015     }
2016 
2017     /**
2018      * @notice Get candidate info
2019      * @param _candidateAddr the address of the candidate
2020      * @return initialized whether initialized or not
2021      * @return minSelfStake minimum self stakes
2022      * @return stakingPool staking pool
2023      * @return status candidate status
2024      * @return unbondTime unbond time
2025      * @return commissionRate commission rate
2026      * @return rateLockEndTime commission rate lock end time
2027      */
2028     function getCandidateInfo(address _candidateAddr)
2029         external
2030         view
2031         returns (
2032             bool initialized,
2033             uint256 minSelfStake,
2034             uint256 stakingPool,
2035             uint256 status,
2036             uint256 unbondTime,
2037             uint256 commissionRate,
2038             uint256 rateLockEndTime
2039         )
2040     {
2041         ValidatorCandidate memory c = candidateProfiles[_candidateAddr];
2042 
2043         initialized = c.initialized;
2044         minSelfStake = c.minSelfStake;
2045         stakingPool = c.stakingPool;
2046         status = uint256(c.status);
2047         unbondTime = c.unbondTime;
2048         commissionRate = c.commissionRate;
2049         rateLockEndTime = c.rateLockEndTime;
2050     }
2051 
2052     /**
2053      * @notice Get the delegator info of a specific candidate
2054      * @param _candidateAddr the address of the candidate
2055      * @param _delegatorAddr the address of the delegator
2056      * @return delegatedStake delegated stake to this candidate
2057      * @return undelegatingStake undelegating stakes
2058      * @return intentAmounts the amounts of withdraw intents
2059      * @return intentProposedTimes the proposed times of withdraw intents
2060      */
2061     function getDelegatorInfo(address _candidateAddr, address _delegatorAddr)
2062         external
2063         view
2064         returns (
2065             uint256 delegatedStake,
2066             uint256 undelegatingStake,
2067             uint256[] memory intentAmounts,
2068             uint256[] memory intentProposedTimes
2069         )
2070     {
2071         Delegator storage d = candidateProfiles[_candidateAddr].delegatorProfiles[_delegatorAddr];
2072 
2073         uint256 len = d.intentEndIndex.sub(d.intentStartIndex);
2074         intentAmounts = new uint256[](len);
2075         intentProposedTimes = new uint256[](len);
2076         for (uint256 i = 0; i < len; i++) {
2077             intentAmounts[i] = d.withdrawIntents[i + d.intentStartIndex].amount;
2078             intentProposedTimes[i] = d.withdrawIntents[i + d.intentStartIndex].proposedTime;
2079         }
2080 
2081         delegatedStake = d.delegatedStake;
2082         undelegatingStake = d.undelegatingStake;
2083     }
2084 
2085     /**
2086      * @notice Check this DPoS contract is valid or not now
2087      * @return DPoS is valid or not
2088      */
2089     function isValidDPoS() public view returns (bool) {
2090         return
2091             block.number >= dposGoLiveTime &&
2092             getValidatorNum() >= getUIntValue(uint256(ParamNames.MinValidatorNum));
2093     }
2094 
2095     /**
2096      * @notice Check the given address is a validator or not
2097      * @param _addr the address to check
2098      * @return the given address is a validator or not
2099      */
2100     function isValidator(address _addr) public view returns (bool) {
2101         return candidateProfiles[_addr].status == DPoSCommon.CandidateStatus.Bonded;
2102     }
2103 
2104     /**
2105      * @notice Check if the contract is in migrating state
2106      * @return contract in migrating state or not
2107      */
2108     function isMigrating() public view returns (bool) {
2109         uint256 migrationTime = getUIntValue(uint256(ParamNames.MigrationTime));
2110         return migrationTime != 0 && block.number >= migrationTime;
2111     }
2112 
2113     /**
2114      * @notice Get the number of validators
2115      * @return the number of validators
2116      */
2117     function getValidatorNum() public view returns (uint256) {
2118         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
2119 
2120         uint256 num;
2121         for (uint256 i = 0; i < maxValidatorNum; i++) {
2122             if (validatorSet[i] != address(0)) {
2123                 num++;
2124             }
2125         }
2126         return num;
2127     }
2128 
2129     /**
2130      * @notice Get minimum amount of stakes for a quorum
2131      * @return the minimum amount
2132      */
2133     function getMinQuorumStakingPool() public view returns (uint256) {
2134         return getTotalValidatorStakingPool().mul(2).div(3).add(1);
2135     }
2136 
2137     /**
2138      * @notice Get the total amount of stakes in validators' staking pools
2139      * @return the total amount
2140      */
2141     function getTotalValidatorStakingPool() public view returns (uint256) {
2142         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
2143 
2144         uint256 totalValidatorStakingPool;
2145         for (uint256 i = 0; i < maxValidatorNum; i++) {
2146             totalValidatorStakingPool = totalValidatorStakingPool.add(
2147                 candidateProfiles[validatorSet[i]].stakingPool
2148             );
2149         }
2150 
2151         return totalValidatorStakingPool;
2152     }
2153 
2154     /**
2155      * @notice Update the commission rate of a candidate
2156      * @param _candidate the candidate to update
2157      * @param _newRate new commission rate
2158      * @param _newLockEndTime new lock end time
2159      */
2160     function _updateCommissionRate(
2161         ValidatorCandidate storage _candidate,
2162         uint256 _newRate,
2163         uint256 _newLockEndTime
2164     ) private {
2165         require(_newRate <= COMMISSION_RATE_BASE, 'Invalid new rate');
2166         require(_newLockEndTime >= block.number, 'Outdated new lock end time');
2167 
2168         if (_newRate <= _candidate.commissionRate) {
2169             require(_newLockEndTime >= _candidate.rateLockEndTime, 'Invalid new lock end time');
2170         } else {
2171             require(block.number > _candidate.rateLockEndTime, 'Commission rate is locked');
2172         }
2173 
2174         _candidate.commissionRate = _newRate;
2175         _candidate.rateLockEndTime = _newLockEndTime;
2176 
2177         emit UpdateCommissionRate(msg.sender, _newRate, _newLockEndTime);
2178     }
2179 
2180     /**
2181      * @notice Update the delegated stake of a delegator to an candidate
2182      * @param _candidate the candidate
2183      * @param _delegatorAddr the delegator address
2184      * @param _amount update amount
2185      * @param _op update operation
2186      */
2187     function _updateDelegatedStake(
2188         ValidatorCandidate storage _candidate,
2189         address _candidateAddr,
2190         address _delegatorAddr,
2191         uint256 _amount,
2192         MathOperation _op
2193     ) private {
2194         Delegator storage delegator = _candidate.delegatorProfiles[_delegatorAddr];
2195 
2196         if (_op == MathOperation.Add) {
2197             _candidate.stakingPool = _candidate.stakingPool.add(_amount);
2198             delegator.delegatedStake = delegator.delegatedStake.add(_amount);
2199         } else if (_op == MathOperation.Sub) {
2200             _candidate.stakingPool = _candidate.stakingPool.sub(_amount);
2201             delegator.delegatedStake = delegator.delegatedStake.sub(_amount);
2202         } else {
2203             assert(false);
2204         }
2205         emit UpdateDelegatedStake(
2206             _delegatorAddr,
2207             _candidateAddr,
2208             delegator.delegatedStake,
2209             _candidate.stakingPool
2210         );
2211     }
2212 
2213     /**
2214      * @notice Add a validator
2215      * @param _validatorAddr the address of the validator
2216      * @param _setIndex the index to put the validator
2217      */
2218     function _addValidator(address _validatorAddr, uint256 _setIndex) private {
2219         require(validatorSet[_setIndex] == address(0), 'Validator slot occupied');
2220 
2221         validatorSet[_setIndex] = _validatorAddr;
2222         candidateProfiles[_validatorAddr].status = DPoSCommon.CandidateStatus.Bonded;
2223         delete candidateProfiles[_validatorAddr].unbondTime;
2224         emit ValidatorChange(_validatorAddr, ValidatorChangeType.Add);
2225     }
2226 
2227     /**
2228      * @notice Remove a validator
2229      * @param _setIndex the index of the validator to be removed
2230      */
2231     function _removeValidator(uint256 _setIndex) private {
2232         address removedValidator = validatorSet[_setIndex];
2233         if (removedValidator == address(0)) {
2234             return;
2235         }
2236 
2237         delete validatorSet[_setIndex];
2238         candidateProfiles[removedValidator].status = DPoSCommon.CandidateStatus.Unbonding;
2239         candidateProfiles[removedValidator].unbondTime = block.number.add(
2240             getUIntValue(uint256(ParamNames.SlashTimeout))
2241         );
2242         emit ValidatorChange(removedValidator, ValidatorChangeType.Removal);
2243     }
2244 
2245     /**
2246      * @notice Validate a validator status after stakes change
2247      * @dev remove this validator if it doesn't meet the requirement of being a validator
2248      * @param _validatorAddr the validator address
2249      */
2250     function _validateValidator(address _validatorAddr) private {
2251         ValidatorCandidate storage v = candidateProfiles[_validatorAddr];
2252         if (v.status != DPoSCommon.CandidateStatus.Bonded) {
2253             // no need to validate the stake of a non-validator
2254             return;
2255         }
2256 
2257         bool lowSelfStake = v.delegatorProfiles[_validatorAddr].delegatedStake < v.minSelfStake;
2258         bool lowStakingPool = v.stakingPool < getUIntValue(uint256(ParamNames.MinStakeInPool));
2259 
2260         if (lowSelfStake || lowStakingPool) {
2261             _removeValidator(_getValidatorIdx(_validatorAddr));
2262         }
2263     }
2264 
2265     /**
2266      * @notice Check whether validators with more than 2/3 total stakes have signed this hash
2267      * @param _h signed hash
2268      * @param _sigs signatures
2269      * @return whether the signatures are valid or not
2270      */
2271     function _checkValidatorSigs(bytes32 _h, bytes[] memory _sigs) private returns (bool) {
2272         uint256 minQuorumStakingPool = getMinQuorumStakingPool();
2273 
2274         bytes32 hash = _h.toEthSignedMessageHash();
2275         address[] memory addrs = new address[](_sigs.length);
2276         uint256 quorumStakingPool;
2277         bool hasDuplicatedSig;
2278         for (uint256 i = 0; i < _sigs.length; i++) {
2279             addrs[i] = hash.recover(_sigs[i]);
2280             if (checkedValidators[addrs[i]]) {
2281                 hasDuplicatedSig = true;
2282                 break;
2283             }
2284             if (candidateProfiles[addrs[i]].status != DPoSCommon.CandidateStatus.Bonded) {
2285                 continue;
2286             }
2287 
2288             quorumStakingPool = quorumStakingPool.add(candidateProfiles[addrs[i]].stakingPool);
2289             checkedValidators[addrs[i]] = true;
2290         }
2291 
2292         for (uint256 i = 0; i < _sigs.length; i++) {
2293             checkedValidators[addrs[i]] = false;
2294         }
2295 
2296         return !hasDuplicatedSig && quorumStakingPool >= minQuorumStakingPool;
2297     }
2298 
2299     /**
2300      * @notice Get validator index
2301      * @param _addr the validator address
2302      * @return the index of the validator
2303      */
2304     function _getValidatorIdx(address _addr) private view returns (uint256) {
2305         uint256 maxValidatorNum = getUIntValue(uint256(ParamNames.MaxValidatorNum));
2306 
2307         for (uint256 i = 0; i < maxValidatorNum; i++) {
2308             if (validatorSet[i] == _addr) {
2309                 return i;
2310             }
2311         }
2312 
2313         revert('No such a validator');
2314     }
2315 }