1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity >=0.8.4;
4 
5 /// @notice Modern and gas-optimized ERC-20 + EIP-2612 implementation with COMP-style governance and pausing.
6 /// @author Modified from Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/erc20/ERC20.sol)
7 /// License-Identifier: AGPL-3.0-only
8 abstract contract KaliDAOtoken {
9     /*///////////////////////////////////////////////////////////////
10                             EVENTS
11     //////////////////////////////////////////////////////////////*/
12 
13     event Transfer(address indexed from, address indexed to, uint256 amount);
14 
15     event Approval(address indexed owner, address indexed spender, uint256 amount);
16 
17     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
18 
19     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
20 
21     event PauseFlipped(bool paused);
22 
23     /*///////////////////////////////////////////////////////////////
24                             ERRORS
25     //////////////////////////////////////////////////////////////*/
26 
27     error NoArrayParity();
28 
29     error Paused();
30 
31     error SignatureExpired();
32 
33     error NullAddress();
34 
35     error InvalidNonce();
36 
37     error NotDetermined();
38 
39     error InvalidSignature();
40 
41     error Uint32max();
42 
43     error Uint96max();
44 
45     /*///////////////////////////////////////////////////////////////
46                             METADATA STORAGE
47     //////////////////////////////////////////////////////////////*/
48 
49     string public name;
50 
51     string public symbol;
52 
53     uint8 public constant decimals = 18;
54 
55     /*///////////////////////////////////////////////////////////////
56                             ERC-20 STORAGE
57     //////////////////////////////////////////////////////////////*/
58 
59     uint256 public totalSupply;
60 
61     mapping(address => uint256) public balanceOf;
62 
63     mapping(address => mapping(address => uint256)) public allowance;
64 
65     /*///////////////////////////////////////////////////////////////
66                             EIP-2612 STORAGE
67     //////////////////////////////////////////////////////////////*/
68 
69     bytes32 public constant PERMIT_TYPEHASH =
70         keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
71 
72     uint256 internal INITIAL_CHAIN_ID;
73 
74     bytes32 internal INITIAL_DOMAIN_SEPARATOR;
75 
76     mapping(address => uint256) public nonces;
77 
78     /*///////////////////////////////////////////////////////////////
79                             DAO STORAGE
80     //////////////////////////////////////////////////////////////*/
81 
82     bool public paused;
83 
84     bytes32 public constant DELEGATION_TYPEHASH = 
85         keccak256('Delegation(address delegatee,uint256 nonce,uint256 deadline)');
86 
87     mapping(address => address) internal _delegates;
88 
89     mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;
90 
91     mapping(address => uint256) public numCheckpoints;
92 
93     struct Checkpoint {
94         uint32 fromTimestamp;
95         uint96 votes;
96     }
97 
98     /*///////////////////////////////////////////////////////////////
99                             CONSTRUCTOR
100     //////////////////////////////////////////////////////////////*/
101 
102     function _init(
103         string memory name_,
104         string memory symbol_,
105         bool paused_,
106         address[] memory voters_,
107         uint256[] memory shares_
108     ) internal virtual {
109         if (voters_.length != shares_.length) revert NoArrayParity();
110 
111         name = name_;
112         
113         symbol = symbol_;
114         
115         paused = paused_;
116 
117         INITIAL_CHAIN_ID = block.chainid;
118         
119         INITIAL_DOMAIN_SEPARATOR = _computeDomainSeparator();
120         
121         // cannot realistically overflow on human timescales
122         unchecked {
123             for (uint256 i; i < voters_.length; i++) {
124                 _mint(voters_[i], shares_[i]);
125             }
126         }
127     }
128 
129     /*///////////////////////////////////////////////////////////////
130                             ERC-20 LOGIC
131     //////////////////////////////////////////////////////////////*/
132 
133     function approve(address spender, uint256 amount) public payable virtual returns (bool) {
134         allowance[msg.sender][spender] = amount;
135 
136         emit Approval(msg.sender, spender, amount);
137 
138         return true;
139     }
140 
141     function transfer(address to, uint256 amount) public payable notPaused virtual returns (bool) {
142         balanceOf[msg.sender] -= amount;
143 
144         // cannot overflow because the sum of all user
145         // balances can't exceed the max uint256 value
146         unchecked {
147             balanceOf[to] += amount;
148         }
149         
150         _moveDelegates(delegates(msg.sender), delegates(to), amount);
151 
152         emit Transfer(msg.sender, to, amount);
153 
154         return true;
155     }
156 
157     function transferFrom(
158         address from,
159         address to,
160         uint256 amount
161     ) public payable notPaused virtual returns (bool) {
162         if (allowance[from][msg.sender] != type(uint256).max) 
163             allowance[from][msg.sender] -= amount;
164 
165         balanceOf[from] -= amount;
166 
167         // cannot overflow because the sum of all user
168         // balances can't exceed the max uint256 value
169         unchecked {
170             balanceOf[to] += amount;
171         }
172         
173         _moveDelegates(delegates(from), delegates(to), amount);
174 
175         emit Transfer(from, to, amount);
176 
177         return true;
178     }
179 
180     /*///////////////////////////////////////////////////////////////
181                             EIP-2612 LOGIC
182     //////////////////////////////////////////////////////////////*/
183     
184     function permit(
185         address owner,
186         address spender,
187         uint256 value,
188         uint256 deadline,
189         uint8 v,
190         bytes32 r,
191         bytes32 s
192     ) public payable virtual {
193         if (block.timestamp > deadline) revert SignatureExpired();
194 
195         // cannot realistically overflow on human timescales
196         unchecked {
197             bytes32 digest = keccak256(
198                 abi.encodePacked(
199                     '\x19\x01',
200                     DOMAIN_SEPARATOR(),
201                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
202                 )
203             );
204 
205             address recoveredAddress = ecrecover(digest, v, r, s);
206 
207             if (recoveredAddress == address(0) || recoveredAddress != owner) revert InvalidSignature();
208 
209             allowance[recoveredAddress][spender] = value;
210         }
211 
212         emit Approval(owner, spender, value);
213     }
214 
215     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
216         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : _computeDomainSeparator();
217     }
218 
219     function _computeDomainSeparator() internal view virtual returns (bytes32) {
220         return 
221             keccak256(
222                 abi.encode(
223                     keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
224                     keccak256(bytes(name)),
225                     keccak256('1'),
226                     block.chainid,
227                     address(this)
228                 )
229             );
230     }
231 
232     /*///////////////////////////////////////////////////////////////
233                             DAO LOGIC
234     //////////////////////////////////////////////////////////////*/
235 
236     modifier notPaused() {
237         if (paused) revert Paused();
238 
239         _;
240     }
241     
242     function delegates(address delegator) public view virtual returns (address) {
243         address current = _delegates[delegator];
244         
245         return current == address(0) ? delegator : current;
246     }
247 
248     function getCurrentVotes(address account) public view virtual returns (uint256) {
249         // this is safe from underflow because decrement only occurs if `nCheckpoints` is positive
250         unchecked {
251             uint256 nCheckpoints = numCheckpoints[account];
252 
253             return nCheckpoints != 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
254         }
255     }
256 
257     function delegate(address delegatee) public payable virtual {
258         _delegate(msg.sender, delegatee);
259     }
260 
261     function delegateBySig(
262         address delegatee, 
263         uint256 nonce, 
264         uint256 deadline, 
265         uint8 v, 
266         bytes32 r, 
267         bytes32 s
268     ) public payable virtual {
269         if (block.timestamp > deadline) revert SignatureExpired();
270 
271         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, deadline));
272 
273         bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR(), structHash));
274 
275         address signatory = ecrecover(digest, v, r, s);
276 
277         if (signatory == address(0)) revert NullAddress();
278         
279         // cannot realistically overflow on human timescales
280         unchecked {
281             if (nonce != nonces[signatory]++) revert InvalidNonce();
282         }
283 
284         _delegate(signatory, delegatee);
285     }
286 
287     function getPriorVotes(address account, uint256 timestamp) public view virtual returns (uint96) {
288         if (block.timestamp <= timestamp) revert NotDetermined();
289 
290         uint256 nCheckpoints = numCheckpoints[account];
291 
292         if (nCheckpoints == 0) return 0;
293         
294         // this is safe from underflow because decrement only occurs if `nCheckpoints` is positive
295         unchecked {
296             if (checkpoints[account][nCheckpoints - 1].fromTimestamp <= timestamp)
297                 return checkpoints[account][nCheckpoints - 1].votes;
298 
299             if (checkpoints[account][0].fromTimestamp > timestamp) return 0;
300 
301             uint256 lower;
302             
303             // this is safe from underflow because decrement only occurs if `nCheckpoints` is positive
304             uint256 upper = nCheckpoints - 1;
305 
306             while (upper > lower) {
307                 // this is safe from underflow because `upper` ceiling is provided
308                 uint256 center = upper - (upper - lower) / 2;
309 
310                 Checkpoint memory cp = checkpoints[account][center];
311 
312                 if (cp.fromTimestamp == timestamp) {
313                     return cp.votes;
314                 } else if (cp.fromTimestamp < timestamp) {
315                     lower = center;
316                 } else {
317                     upper = center - 1;
318                 }
319             }
320 
321         return checkpoints[account][lower].votes;
322 
323         }
324     }
325 
326     function _delegate(address delegator, address delegatee) internal virtual {
327         address currentDelegate = delegates(delegator);
328 
329         _delegates[delegator] = delegatee;
330 
331         _moveDelegates(currentDelegate, delegatee, balanceOf[delegator]);
332 
333         emit DelegateChanged(delegator, currentDelegate, delegatee);
334     }
335 
336     function _moveDelegates(
337         address srcRep, 
338         address dstRep, 
339         uint256 amount
340     ) internal virtual {
341         if (srcRep != dstRep && amount != 0) 
342             if (srcRep != address(0)) {
343                 uint256 srcRepNum = numCheckpoints[srcRep];
344                 
345                 uint256 srcRepOld = srcRepNum != 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
346 
347                 uint256 srcRepNew = srcRepOld - amount;
348 
349                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
350             }
351             
352             if (dstRep != address(0)) {
353                 uint256 dstRepNum = numCheckpoints[dstRep];
354 
355                 uint256 dstRepOld = dstRepNum != 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
356 
357                 uint256 dstRepNew = dstRepOld + amount;
358 
359                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
360             }
361     }
362 
363     function _writeCheckpoint(
364         address delegatee, 
365         uint256 nCheckpoints, 
366         uint256 oldVotes, 
367         uint256 newVotes
368     ) internal virtual {
369         unchecked {
370             // this is safe from underflow because decrement only occurs if `nCheckpoints` is positive
371             if (nCheckpoints != 0 && checkpoints[delegatee][nCheckpoints - 1].fromTimestamp == block.timestamp) {
372                 checkpoints[delegatee][nCheckpoints - 1].votes = _safeCastTo96(newVotes);
373             } else {
374                 checkpoints[delegatee][nCheckpoints] = Checkpoint(_safeCastTo32(block.timestamp), _safeCastTo96(newVotes));
375                 
376                 // cannot realistically overflow on human timescales
377                 numCheckpoints[delegatee] = nCheckpoints + 1;
378             }
379         }
380 
381         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
382     }
383 
384     /*///////////////////////////////////////////////////////////////
385                             MINT/BURN LOGIC
386     //////////////////////////////////////////////////////////////*/
387 
388     function _mint(address to, uint256 amount) internal virtual {
389         totalSupply += amount;
390 
391         // cannot overflow because the sum of all user
392         // balances can't exceed the max uint256 value
393         unchecked {
394             balanceOf[to] += amount;
395         }
396 
397         _moveDelegates(address(0), delegates(to), amount);
398 
399         emit Transfer(address(0), to, amount);
400     }
401 
402     function _burn(address from, uint256 amount) internal virtual {
403         balanceOf[from] -= amount;
404 
405         // cannot underflow because a user's balance
406         // will never be larger than the total supply
407         unchecked {
408             totalSupply -= amount;
409         }
410 
411         _moveDelegates(delegates(from), address(0), amount);
412 
413         emit Transfer(from, address(0), amount);
414     }
415     
416     function burn(uint256 amount) public payable virtual {
417         _burn(msg.sender, amount);
418     }
419 
420     function burnFrom(address from, uint256 amount) public payable virtual {
421         if (allowance[from][msg.sender] != type(uint256).max) 
422             allowance[from][msg.sender] -= amount;
423 
424         _burn(from, amount);
425     }
426 
427     /*///////////////////////////////////////////////////////////////
428                             PAUSE LOGIC
429     //////////////////////////////////////////////////////////////*/
430 
431     function _flipPause() internal virtual {
432         paused = !paused;
433 
434         emit PauseFlipped(paused);
435     }
436     
437     /*///////////////////////////////////////////////////////////////
438                             SAFECAST LOGIC
439     //////////////////////////////////////////////////////////////*/
440     
441     function _safeCastTo32(uint256 x) internal pure virtual returns (uint32) {
442         if (x > type(uint32).max) revert Uint32max();
443 
444         return uint32(x);
445     }
446     
447     function _safeCastTo96(uint256 x) internal pure virtual returns (uint96) {
448         if (x > type(uint96).max) revert Uint96max();
449 
450         return uint96(x);
451     }
452 }
453 
454 /// @notice Helper utility that enables calling multiple local methods in a single call.
455 /// @author Modified from Uniswap (https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol)
456 abstract contract Multicall {
457     function multicall(bytes[] calldata data) public payable virtual returns (bytes[] memory results) {
458         results = new bytes[](data.length);
459         
460         // cannot realistically overflow on human timescales
461         unchecked {
462             for (uint256 i = 0; i < data.length; i++) {
463                 (bool success, bytes memory result) = address(this).delegatecall(data[i]);
464 
465                 if (!success) {
466                     if (result.length < 68) revert();
467                     
468                     assembly {
469                         result := add(result, 0x04)
470                     }
471                     
472                     revert(abi.decode(result, (string)));
473                 }
474                 results[i] = result;
475             }
476         }
477     }
478 }
479 
480 /// @notice Helper utility for NFT 'safe' transfers.
481 abstract contract NFThelper {
482     function onERC721Received(
483         address,
484         address,
485         uint256,
486         bytes calldata
487     ) external pure returns (bytes4 sig) {
488         sig = 0x150b7a02; // 'onERC721Received(address,address,uint256,bytes)'
489     }
490 
491     function onERC1155Received(
492         address,
493         address,
494         uint256,
495         uint256,
496         bytes calldata
497     ) external pure returns (bytes4 sig) {
498         sig = 0xf23a6e61; // 'onERC1155Received(address,address,uint256,uint256,bytes)'
499     }
500     
501     function onERC1155BatchReceived(
502         address,
503         address,
504         uint256[] calldata,
505         uint256[] calldata,
506         bytes calldata
507     ) external pure returns (bytes4 sig) {
508         sig = 0xbc197c81; // 'onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)'
509     }
510 }
511 
512 /// @notice Gas-optimized reentrancy protection.
513 /// @author Modified from OpenZeppelin 
514 /// (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
515 /// License-Identifier: MIT
516 abstract contract ReentrancyGuard {
517     error Reentrancy();
518 
519     uint256 private constant NOT_ENTERED = 1;
520 
521     uint256 private constant ENTERED = 2;
522 
523     uint256 private status = NOT_ENTERED;
524 
525     modifier nonReentrant() {
526         if (status == ENTERED) revert Reentrancy();
527 
528         status = ENTERED;
529 
530         _;
531 
532         status = NOT_ENTERED;
533     }
534 }
535 
536 /// @notice Kali DAO membership extension interface.
537 interface IKaliDAOextension {
538     function setExtension(bytes calldata extensionData) external;
539 
540     function callExtension(
541         address account, 
542         uint256 amount, 
543         bytes calldata extensionData
544     ) external payable returns (bool mint, uint256 amountOut);
545 }
546 
547 /// @notice Simple gas-optimized Kali DAO core module.
548 contract KaliDAO is KaliDAOtoken, Multicall, NFThelper, ReentrancyGuard {
549     /*///////////////////////////////////////////////////////////////
550                             EVENTS
551     //////////////////////////////////////////////////////////////*/
552 
553     event NewProposal(
554         address indexed proposer, 
555         uint256 indexed proposal, 
556         ProposalType indexed proposalType, 
557         string description, 
558         address[] accounts, 
559         uint256[] amounts, 
560         bytes[] payloads
561     );
562 
563     event ProposalCancelled(address indexed proposer, uint256 indexed proposal);
564 
565     event ProposalSponsored(address indexed sponsor, uint256 indexed proposal);
566     
567     event VoteCast(address indexed voter, uint256 indexed proposal, bool indexed approve);
568 
569     event ProposalProcessed(uint256 indexed proposal, bool indexed didProposalPass);
570 
571     /*///////////////////////////////////////////////////////////////
572                             ERRORS
573     //////////////////////////////////////////////////////////////*/
574 
575     error Initialized();
576 
577     error PeriodBounds();
578 
579     error QuorumMax();
580 
581     error SupermajorityBounds();
582 
583     error InitCallFail();
584 
585     error TypeBounds();
586 
587     error NotProposer();
588 
589     error Sponsored();
590 
591     error NotMember();
592 
593     error NotCurrentProposal();
594 
595     error AlreadyVoted();
596 
597     error NotVoteable();
598 
599     error VotingNotEnded();
600 
601     error PrevNotProcessed();
602 
603     error NotExtension();
604 
605     /*///////////////////////////////////////////////////////////////
606                             DAO STORAGE
607     //////////////////////////////////////////////////////////////*/
608 
609     string public docs;
610 
611     uint256 private currentSponsoredProposal;
612     
613     uint256 public proposalCount;
614 
615     uint32 public votingPeriod;
616 
617     uint32 public gracePeriod;
618 
619     uint32 public quorum; // 1-100
620 
621     uint32 public supermajority; // 1-100
622     
623     bytes32 public constant VOTE_HASH = 
624         keccak256('SignVote(address signer,uint256 proposal,bool approve)');
625     
626     mapping(address => bool) public extensions;
627 
628     mapping(uint256 => Proposal) public proposals;
629 
630     mapping(uint256 => ProposalState) public proposalStates;
631 
632     mapping(ProposalType => VoteType) public proposalVoteTypes;
633     
634     mapping(uint256 => mapping(address => bool)) public voted;
635 
636     mapping(address => uint256) public lastYesVote;
637 
638     enum ProposalType {
639         MINT, // add membership
640         BURN, // revoke membership
641         CALL, // call contracts
642         VPERIOD, // set `votingPeriod`
643         GPERIOD, // set `gracePeriod`
644         QUORUM, // set `quorum`
645         SUPERMAJORITY, // set `supermajority`
646         TYPE, // set `VoteType` to `ProposalType`
647         PAUSE, // flip membership transferability
648         EXTENSION, // flip `extensions` whitelisting
649         ESCAPE, // delete pending proposal in case of revert
650         DOCS // amend org docs
651     }
652 
653     enum VoteType {
654         SIMPLE_MAJORITY,
655         SIMPLE_MAJORITY_QUORUM_REQUIRED,
656         SUPERMAJORITY,
657         SUPERMAJORITY_QUORUM_REQUIRED
658     }
659 
660     struct Proposal {
661         ProposalType proposalType;
662         string description;
663         address[] accounts; // member(s) being added/kicked; account(s) receiving payload
664         uint256[] amounts; // value(s) to be minted/burned/spent; gov setting [0]
665         bytes[] payloads; // data for CALL proposals
666         uint256 prevProposal;
667         uint96 yesVotes;
668         uint96 noVotes;
669         uint32 creationTime;
670         address proposer;
671     }
672 
673     struct ProposalState {
674         bool passed;
675         bool processed;
676     }
677 
678     /*///////////////////////////////////////////////////////////////
679                             CONSTRUCTOR
680     //////////////////////////////////////////////////////////////*/
681 
682     function init(
683         string memory name_,
684         string memory symbol_,
685         string memory docs_,
686         bool paused_,
687         address[] memory extensions_,
688         bytes[] memory extensionsData_,
689         address[] calldata voters_,
690         uint256[] calldata shares_,
691         uint32[16] memory govSettings_
692     ) public payable nonReentrant virtual {
693         if (extensions_.length != extensionsData_.length) revert NoArrayParity();
694 
695         if (votingPeriod != 0) revert Initialized();
696 
697         if (govSettings_[0] == 0 || govSettings_[0] > 365 days) revert PeriodBounds();
698 
699         if (govSettings_[1] > 365 days) revert PeriodBounds();
700 
701         if (govSettings_[2] > 100) revert QuorumMax();
702 
703         if (govSettings_[3] <= 51 || govSettings_[3] > 100) revert SupermajorityBounds();
704 
705         KaliDAOtoken._init(name_, symbol_, paused_, voters_, shares_);
706 
707         if (extensions_.length != 0) {
708             // cannot realistically overflow on human timescales
709             unchecked {
710                 for (uint256 i; i < extensions_.length; i++) {
711                     extensions[extensions_[i]] = true;
712 
713                     if (extensionsData_[i].length > 3) {
714                         (bool success, ) = extensions_[i].call(extensionsData_[i]);
715 
716                         if (!success) revert InitCallFail();
717                     }
718                 }
719             }
720         }
721 
722         docs = docs_;
723         
724         votingPeriod = govSettings_[0];
725 
726         gracePeriod = govSettings_[1];
727         
728         quorum = govSettings_[2];
729         
730         supermajority = govSettings_[3];
731 
732         // set initial vote types
733         proposalVoteTypes[ProposalType.MINT] = VoteType(govSettings_[4]);
734 
735         proposalVoteTypes[ProposalType.BURN] = VoteType(govSettings_[5]);
736 
737         proposalVoteTypes[ProposalType.CALL] = VoteType(govSettings_[6]);
738 
739         proposalVoteTypes[ProposalType.VPERIOD] = VoteType(govSettings_[7]);
740 
741         proposalVoteTypes[ProposalType.GPERIOD] = VoteType(govSettings_[8]);
742         
743         proposalVoteTypes[ProposalType.QUORUM] = VoteType(govSettings_[9]);
744         
745         proposalVoteTypes[ProposalType.SUPERMAJORITY] = VoteType(govSettings_[10]);
746 
747         proposalVoteTypes[ProposalType.TYPE] = VoteType(govSettings_[11]);
748         
749         proposalVoteTypes[ProposalType.PAUSE] = VoteType(govSettings_[12]);
750         
751         proposalVoteTypes[ProposalType.EXTENSION] = VoteType(govSettings_[13]);
752 
753         proposalVoteTypes[ProposalType.ESCAPE] = VoteType(govSettings_[14]);
754 
755         proposalVoteTypes[ProposalType.DOCS] = VoteType(govSettings_[15]);
756     }
757 
758     /*///////////////////////////////////////////////////////////////
759                             PROPOSAL LOGIC
760     //////////////////////////////////////////////////////////////*/
761 
762     function getProposalArrays(uint256 proposal) public view virtual returns (
763         address[] memory accounts, 
764         uint256[] memory amounts, 
765         bytes[] memory payloads
766     ) {
767         Proposal storage prop = proposals[proposal];
768         
769         (accounts, amounts, payloads) = (prop.accounts, prop.amounts, prop.payloads);
770     }
771 
772     function propose(
773         ProposalType proposalType,
774         string calldata description,
775         address[] calldata accounts,
776         uint256[] calldata amounts,
777         bytes[] calldata payloads
778     ) public payable nonReentrant virtual returns (uint256 proposal) {
779         if (accounts.length != amounts.length || amounts.length != payloads.length) revert NoArrayParity();
780         
781         if (proposalType == ProposalType.VPERIOD) if (amounts[0] == 0 || amounts[0] > 365 days) revert PeriodBounds();
782 
783         if (proposalType == ProposalType.GPERIOD) if (amounts[0] > 365 days) revert PeriodBounds();
784         
785         if (proposalType == ProposalType.QUORUM) if (amounts[0] > 100) revert QuorumMax();
786         
787         if (proposalType == ProposalType.SUPERMAJORITY) if (amounts[0] <= 51 || amounts[0] > 100) revert SupermajorityBounds();
788 
789         if (proposalType == ProposalType.TYPE) if (amounts[0] > 11 || amounts[1] > 3 || amounts.length != 2) revert TypeBounds();
790 
791         bool selfSponsor;
792 
793         // if member or extension is making proposal, include sponsorship
794         if (balanceOf[msg.sender] != 0 || extensions[msg.sender]) selfSponsor = true;
795 
796         // cannot realistically overflow on human timescales
797         unchecked {
798             proposalCount++;
799         }
800 
801         proposal = proposalCount;
802 
803         proposals[proposal] = Proposal({
804             proposalType: proposalType,
805             description: description,
806             accounts: accounts,
807             amounts: amounts,
808             payloads: payloads,
809             prevProposal: selfSponsor ? currentSponsoredProposal : 0,
810             yesVotes: 0,
811             noVotes: 0,
812             creationTime: selfSponsor ? _safeCastTo32(block.timestamp) : 0,
813             proposer: msg.sender
814         });
815 
816         if (selfSponsor) currentSponsoredProposal = proposal;
817 
818         emit NewProposal(msg.sender, proposal, proposalType, description, accounts, amounts, payloads);
819     }
820 
821     function cancelProposal(uint256 proposal) public payable nonReentrant virtual {
822         Proposal storage prop = proposals[proposal];
823 
824         if (msg.sender != prop.proposer) revert NotProposer();
825 
826         if (prop.creationTime != 0) revert Sponsored();
827 
828         delete proposals[proposal];
829 
830         emit ProposalCancelled(msg.sender, proposal);
831     }
832 
833     function sponsorProposal(uint256 proposal) public payable nonReentrant virtual {
834         Proposal storage prop = proposals[proposal];
835 
836         if (balanceOf[msg.sender] == 0) revert NotMember();
837 
838         if (prop.proposer == address(0)) revert NotCurrentProposal();
839 
840         if (prop.creationTime != 0) revert Sponsored();
841 
842         prop.prevProposal = currentSponsoredProposal;
843 
844         currentSponsoredProposal = proposal;
845 
846         prop.creationTime = _safeCastTo32(block.timestamp);
847 
848         emit ProposalSponsored(msg.sender, proposal);
849     } 
850 
851     function vote(uint256 proposal, bool approve) public payable nonReentrant virtual {
852         _vote(msg.sender, proposal, approve);
853     }
854     
855     function voteBySig(
856         address signer, 
857         uint256 proposal, 
858         bool approve, 
859         uint8 v, 
860         bytes32 r, 
861         bytes32 s
862     ) public payable nonReentrant virtual {
863         bytes32 digest =
864             keccak256(
865                 abi.encodePacked(
866                     '\x19\x01',
867                     DOMAIN_SEPARATOR(),
868                     keccak256(
869                         abi.encode(
870                             VOTE_HASH,
871                             signer,
872                             proposal,
873                             approve
874                         )
875                     )
876                 )
877             );
878             
879         address recoveredAddress = ecrecover(digest, v, r, s);
880 
881         if (recoveredAddress == address(0) || recoveredAddress != signer) revert InvalidSignature();
882         
883         _vote(signer, proposal, approve);
884     }
885     
886     function _vote(
887         address signer, 
888         uint256 proposal, 
889         bool approve
890     ) internal virtual {
891         Proposal storage prop = proposals[proposal];
892 
893         if (voted[proposal][signer]) revert AlreadyVoted();
894         
895         // this is safe from overflow because `votingPeriod` is capped so it will not combine
896         // with unix time to exceed the max uint256 value
897         unchecked {
898             if (block.timestamp > prop.creationTime + votingPeriod) revert NotVoteable();
899         }
900 
901         uint96 weight = getPriorVotes(signer, prop.creationTime);
902         
903         // this is safe from overflow because `yesVotes` and `noVotes` are capped by `totalSupply`
904         // which is checked for overflow in `KaliDAOtoken` contract
905         unchecked { 
906             if (approve) {
907                 prop.yesVotes += weight;
908 
909                 lastYesVote[signer] = proposal;
910             } else {
911                 prop.noVotes += weight;
912             }
913         }
914         
915         voted[proposal][signer] = true;
916         
917         emit VoteCast(signer, proposal, approve);
918     }
919 
920     function processProposal(uint256 proposal) public payable nonReentrant virtual returns (
921         bool didProposalPass, bytes[] memory results
922     ) {
923         Proposal storage prop = proposals[proposal];
924 
925         VoteType voteType = proposalVoteTypes[prop.proposalType];
926 
927         if (prop.creationTime == 0) revert NotCurrentProposal();
928         
929         // this is safe from overflow because `votingPeriod` and `gracePeriod` are capped so they will not combine
930         // with unix time to exceed the max uint256 value
931         unchecked {
932             if (block.timestamp <= prop.creationTime + votingPeriod + gracePeriod) revert VotingNotEnded();
933         }
934 
935         // skip previous proposal processing requirement in case of escape hatch
936         if (prop.proposalType != ProposalType.ESCAPE) 
937             if (proposals[prop.prevProposal].creationTime != 0) revert PrevNotProcessed();
938 
939         didProposalPass = _countVotes(voteType, prop.yesVotes, prop.noVotes);
940         
941         if (didProposalPass) {
942             // cannot realistically overflow on human timescales
943             unchecked {
944                 if (prop.proposalType == ProposalType.MINT) 
945                     for (uint256 i; i < prop.accounts.length; i++) {
946                         _mint(prop.accounts[i], prop.amounts[i]);
947                     }
948                     
949                 if (prop.proposalType == ProposalType.BURN) 
950                     for (uint256 i; i < prop.accounts.length; i++) {
951                         _burn(prop.accounts[i], prop.amounts[i]);
952                     }
953                     
954                 if (prop.proposalType == ProposalType.CALL) 
955                     for (uint256 i; i < prop.accounts.length; i++) {
956                         results = new bytes[](prop.accounts.length);
957                         
958                         (, bytes memory result) = prop.accounts[i].call{value: prop.amounts[i]}
959                             (prop.payloads[i]);
960                         
961                         results[i] = result;
962                     }
963                     
964                 // governance settings
965                 if (prop.proposalType == ProposalType.VPERIOD) 
966                     if (prop.amounts[0] != 0) votingPeriod = uint32(prop.amounts[0]);
967                 
968                 if (prop.proposalType == ProposalType.GPERIOD) 
969                     if (prop.amounts[0] != 0) gracePeriod = uint32(prop.amounts[0]);
970                 
971                 if (prop.proposalType == ProposalType.QUORUM) 
972                     if (prop.amounts[0] != 0) quorum = uint32(prop.amounts[0]);
973                 
974                 if (prop.proposalType == ProposalType.SUPERMAJORITY) 
975                     if (prop.amounts[0] != 0) supermajority = uint32(prop.amounts[0]);
976                 
977                 if (prop.proposalType == ProposalType.TYPE) 
978                     proposalVoteTypes[ProposalType(prop.amounts[0])] = VoteType(prop.amounts[1]);
979                 
980                 if (prop.proposalType == ProposalType.PAUSE) 
981                     _flipPause();
982                 
983                 if (prop.proposalType == ProposalType.EXTENSION) 
984                     for (uint256 i; i < prop.accounts.length; i++) {
985                         if (prop.amounts[i] != 0) 
986                             extensions[prop.accounts[i]] = !extensions[prop.accounts[i]];
987                     
988                         if (prop.payloads[i].length > 3) IKaliDAOextension(prop.accounts[i])
989                             .setExtension(prop.payloads[i]);
990                     }
991                 
992                 if (prop.proposalType == ProposalType.ESCAPE)
993                     delete proposals[prop.amounts[0]];
994 
995                 if (prop.proposalType == ProposalType.DOCS)
996                     docs = prop.description;
997                 
998                 proposalStates[proposal].passed = true;
999             }
1000         }
1001 
1002         delete proposals[proposal];
1003 
1004         proposalStates[proposal].processed = true;
1005 
1006         emit ProposalProcessed(proposal, didProposalPass);
1007     }
1008 
1009     function _countVotes(
1010         VoteType voteType,
1011         uint256 yesVotes,
1012         uint256 noVotes
1013     ) internal view virtual returns (bool didProposalPass) {
1014         // fail proposal if no participation
1015         if (yesVotes == 0 && noVotes == 0) return false;
1016 
1017         // rule out any failed quorums
1018         if (voteType == VoteType.SIMPLE_MAJORITY_QUORUM_REQUIRED || voteType == VoteType.SUPERMAJORITY_QUORUM_REQUIRED) {
1019             uint256 minVotes = (totalSupply * quorum) / 100;
1020             
1021             // this is safe from overflow because `yesVotes` and `noVotes` 
1022             // supply are checked in `KaliDAOtoken` contract
1023             unchecked {
1024                 uint256 votes = yesVotes + noVotes;
1025 
1026                 if (votes < minVotes) return false;
1027             }
1028         }
1029         
1030         // simple majority check
1031         if (voteType == VoteType.SIMPLE_MAJORITY || voteType == VoteType.SIMPLE_MAJORITY_QUORUM_REQUIRED) {
1032             if (yesVotes > noVotes) return true;
1033         // supermajority check
1034         } else {
1035             // example: 7 yes, 2 no, supermajority = 66
1036             // ((7+2) * 66) / 100 = 5.94; 7 yes will pass
1037             uint256 minYes = ((yesVotes + noVotes) * supermajority) / 100;
1038 
1039             if (yesVotes >= minYes) return true;
1040         }
1041     }
1042     
1043     /*///////////////////////////////////////////////////////////////
1044                             EXTENSIONS 
1045     //////////////////////////////////////////////////////////////*/
1046 
1047     receive() external payable virtual {}
1048 
1049     modifier onlyExtension {
1050         if (!extensions[msg.sender]) revert NotExtension();
1051 
1052         _;
1053     }
1054 
1055     function callExtension(
1056         address extension, 
1057         uint256 amount, 
1058         bytes calldata extensionData
1059     ) public payable nonReentrant virtual returns (bool mint, uint256 amountOut) {
1060         if (!extensions[extension]) revert NotExtension();
1061         
1062         (mint, amountOut) = IKaliDAOextension(extension).callExtension{value: msg.value}
1063             (msg.sender, amount, extensionData);
1064         
1065         if (mint) {
1066             if (amountOut != 0) _mint(msg.sender, amountOut); 
1067         } else {
1068             if (amountOut != 0) _burn(msg.sender, amount);
1069         }
1070     }
1071 
1072     function mintShares(address to, uint256 amount) public payable onlyExtension virtual {
1073         _mint(to, amount);
1074     }
1075 
1076     function burnShares(address from, uint256 amount) public payable onlyExtension virtual {
1077         _burn(from, amount);
1078     }
1079 }