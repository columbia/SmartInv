1 pragma solidity 0.4.24;
2 
3 /* (c) 2018 SecureVote (Exo One Pty Ltd) */
4 
5 contract BBFarmEvents {
6     event BallotCreatedWithID(uint ballotId);
7     event BBFarmInit(bytes4 namespace);
8     event Sponsorship(uint ballotId, uint value);
9     event Vote(uint indexed ballotId, bytes32 vote, address voter, bytes extra);
10 }
11 
12 library BBLib {
13     using BytesLib for bytes;
14 
15     // ballot meta
16     uint256 constant BB_VERSION = 6;
17     /* 4 deprecated due to insecure vote by proxy
18        5 deprecated to
19         - add `returns (address)` to submitProxyVote
20     */
21 
22     // voting settings
23     uint16 constant USE_ETH = 1;          // 2^0
24     uint16 constant USE_SIGNED = 2;       // 2^1
25     uint16 constant USE_NO_ENC = 4;       // 2^2
26     uint16 constant USE_ENC = 8;          // 2^3
27 
28     // ballot settings
29     uint16 constant IS_BINDING = 8192;    // 2^13
30     uint16 constant IS_OFFICIAL = 16384;  // 2^14
31     uint16 constant USE_TESTING = 32768;  // 2^15
32 
33     // other consts
34     uint32 constant MAX_UINT32 = 0xFFFFFFFF;
35 
36     //// ** Storage Variables
37 
38     // struct for ballot
39     struct Vote {
40         bytes32 voteData;
41         bytes32 castTsAndSender;
42         bytes extra;
43     }
44 
45     struct Sponsor {
46         address sender;
47         uint amount;
48     }
49 
50     //// ** Events
51     event CreatedBallot(bytes32 _specHash, uint64 startTs, uint64 endTs, uint16 submissionBits);
52     event SuccessfulVote(address indexed voter, uint voteId);
53     event SeckeyRevealed(bytes32 secretKey);
54     event TestingEnabled();
55     event DeprecatedContract();
56 
57 
58     // The big database struct
59 
60 
61     struct DB {
62         // Maps to store ballots, along with corresponding log of voters.
63         // Should only be modified through internal functions
64         mapping (uint256 => Vote) votes;
65         uint256 nVotesCast;
66 
67         // we need replay protection for proxy ballots - this will let us check against a sequence number
68         // note: votes directly from a user ALWAYS take priority b/c they do not have sequence numbers
69         // (sequencing is done by Ethereum itself via the tx nonce).
70         mapping (address => uint32) sequenceNumber;
71 
72         // NOTE - We don't actually want to include the encryption PublicKey because _it's included in the ballotSpec_.
73         // It's better to ensure ppl actually have the ballot spec by not including it in the contract.
74         // Plus we're already storing the hash of the ballotSpec anyway...
75 
76         // Private key to be set after ballot conclusion - curve25519
77         bytes32 ballotEncryptionSeckey;
78 
79         // packed contains:
80         // 1. Timestamps for start and end of ballot (UTC)
81         // 2. bits used to decide which options are enabled or disabled for submission of ballots
82         uint256 packed;
83 
84         // specHash by which to validate the ballots integrity
85         bytes32 specHash;
86         // extradata if we need it - allows us to upgrade spechash format, etc
87         bytes16 extraData;
88 
89         // allow tracking of sponsorship for this ballot & connection to index
90         Sponsor[] sponsors;
91         IxIface index;
92 
93         // deprecation flag - doesn't actually do anything besides signal that this contract is deprecated;
94         bool deprecated;
95 
96         address ballotOwner;
97         uint256 creationTs;
98     }
99 
100 
101     // ** Modifiers -- note, these are functions here to allow use as a lib
102     function requireBallotClosed(DB storage db) internal view {
103         require(now > BPackedUtils.packedToEndTime(db.packed), "!b-closed");
104     }
105 
106     function requireBallotOpen(DB storage db) internal view {
107         uint64 _n = uint64(now);
108         uint64 startTs;
109         uint64 endTs;
110         (, startTs, endTs) = BPackedUtils.unpackAll(db.packed);
111         require(_n >= startTs && _n < endTs, "!b-open");
112         require(db.deprecated == false, "b-deprecated");
113     }
114 
115     function requireBallotOwner(DB storage db) internal view {
116         require(msg.sender == db.ballotOwner, "!b-owner");
117     }
118 
119     function requireTesting(DB storage db) internal view {
120         require(isTesting(BPackedUtils.packedToSubmissionBits(db.packed)), "!testing");
121     }
122 
123     /* Library meta */
124 
125     function getVersion() external pure returns (uint) {
126         // even though this is constant we want to make sure that it's actually
127         // callable on Ethereum so we don't accidentally package the constant code
128         // in with an SC using BBLib. This function _must_ be external.
129         return BB_VERSION;
130     }
131 
132     /* Functions */
133 
134     // "Constructor" function - init core params on deploy
135     // timestampts are uint64s to give us plenty of room for millennia
136     function init(DB storage db, bytes32 _specHash, uint256 _packed, IxIface ix, address ballotOwner, bytes16 extraData) external {
137         require(db.specHash == bytes32(0), "b-exists");
138 
139         db.index = ix;
140         db.ballotOwner = ballotOwner;
141 
142         uint64 startTs;
143         uint64 endTs;
144         uint16 sb;
145         (sb, startTs, endTs) = BPackedUtils.unpackAll(_packed);
146 
147         bool _testing = isTesting(sb);
148         if (_testing) {
149             emit TestingEnabled();
150         } else {
151             require(endTs > now, "bad-end-time");
152 
153             // 0x1ff2 is 0001111111110010 in binary
154             // by ANDing with subBits we make sure that only bits in positions 0,2,3,13,14,15
155             // can be used. these correspond to the option flags at the top, and ETH ballots
156             // that are enc'd or plaintext.
157             require(sb & 0x1ff2 == 0, "bad-sb");
158 
159             // if we give bad submission bits (e.g. all 0s) then refuse to deploy ballot
160             bool okaySubmissionBits = 1 == (isEthNoEnc(sb) ? 1 : 0) + (isEthWithEnc(sb) ? 1 : 0);
161             require(okaySubmissionBits, "!valid-sb");
162 
163             // take the max of the start time provided and the blocks timestamp to avoid a DoS against recent token holders
164             // (which someone might be able to do if they could set the timestamp in the past)
165             startTs = startTs > now ? startTs : uint64(now);
166         }
167         require(_specHash != bytes32(0), "null-specHash");
168         db.specHash = _specHash;
169 
170         db.packed = BPackedUtils.pack(sb, startTs, endTs);
171         db.creationTs = now;
172 
173         if (extraData != bytes16(0)) {
174             db.extraData = extraData;
175         }
176 
177         emit CreatedBallot(db.specHash, startTs, endTs, sb);
178     }
179 
180     /* sponsorship */
181 
182     function logSponsorship(DB storage db, uint value) internal {
183         db.sponsors.push(Sponsor(msg.sender, value));
184     }
185 
186     /* getters */
187 
188     function getVote(DB storage db, uint id) internal view returns (bytes32 voteData, address sender, bytes extra, uint castTs) {
189         return (db.votes[id].voteData, address(db.votes[id].castTsAndSender), db.votes[id].extra, uint(db.votes[id].castTsAndSender) >> 160);
190     }
191 
192     function getSequenceNumber(DB storage db, address voter) internal view returns (uint32) {
193         return db.sequenceNumber[voter];
194     }
195 
196     function getTotalSponsorship(DB storage db) internal view returns (uint total) {
197         for (uint i = 0; i < db.sponsors.length; i++) {
198             total += db.sponsors[i].amount;
199         }
200     }
201 
202     function getSponsor(DB storage db, uint i) external view returns (address sender, uint amount) {
203         sender = db.sponsors[i].sender;
204         amount = db.sponsors[i].amount;
205     }
206 
207     /* ETH BALLOTS */
208 
209     // Ballot submission
210     // note: if USE_ENC then curve25519 keys should be generated for
211     // each ballot (then thrown away).
212     // the curve25519 PKs go in the extra param
213     function submitVote(DB storage db, bytes32 voteData, bytes extra) external {
214         _addVote(db, voteData, msg.sender, extra);
215         // set the sequence number to max uint32 to disable proxy submitted ballots
216         // after a voter submits a transaction personally - effectivley disables proxy
217         // ballots. You can _always_ submit a new vote _personally_ with this scheme.
218         if (db.sequenceNumber[msg.sender] != MAX_UINT32) {
219             // using an IF statement here let's us save 4800 gas on repeat votes at the cost of 20k extra gas initially
220             db.sequenceNumber[msg.sender] = MAX_UINT32;
221         }
222     }
223 
224     // Boundaries for constructing the msg we'll validate the signature of
225     function submitProxyVote(DB storage db, bytes32[5] proxyReq, bytes extra) external returns (address voter) {
226         // a proxy vote (where the vote is submitted (i.e. tx fee paid by someone else)
227         // docs for datastructs: https://github.com/secure-vote/tokenvote/blob/master/Docs/DataStructs.md
228 
229         bytes32 r = proxyReq[0];
230         bytes32 s = proxyReq[1];
231         uint8 v = uint8(proxyReq[2][0]);
232         // converting to uint248 will truncate the first byte, and we can then convert it to a bytes31.
233         // we truncate the first byte because it's the `v` parm used above
234         bytes31 proxyReq2 = bytes31(uint248(proxyReq[2]));
235         // proxyReq[3] is ballotId - required for verifying sig but not used for anything else
236         bytes32 ballotId = proxyReq[3];
237         bytes32 voteData = proxyReq[4];
238 
239         // using abi.encodePacked is much cheaper than making bytes in other ways...
240         bytes memory signed = abi.encodePacked(proxyReq2, ballotId, voteData, extra);
241         bytes32 msgHash = keccak256(signed);
242         // need to be sure we are signing the entire ballot and any extra data that comes with it
243         voter = ecrecover(msgHash, v, r, s);
244 
245         // we need to make sure that this is the most recent vote the voter made, and that it has
246         // not been seen before. NOTE: we've already validated the BBFarm namespace before this, so
247         // we know it's meant for _this_ ballot.
248         uint32 sequence = uint32(proxyReq2);  // last 4 bytes of proxyReq2 - the sequence number
249         _proxyReplayProtection(db, voter, sequence);
250 
251         _addVote(db, voteData, voter, extra);
252     }
253 
254     function _addVote(DB storage db, bytes32 voteData, address sender, bytes extra) internal returns (uint256 id) {
255         requireBallotOpen(db);
256 
257         id = db.nVotesCast;
258         db.votes[id].voteData = voteData;
259         // pack the casting ts right next to the sender
260         db.votes[id].castTsAndSender = bytes32(sender) ^ bytes32(now << 160);
261         if (extra.length > 0) {
262             db.votes[id].extra = extra;
263         }
264         db.nVotesCast += 1;
265         emit SuccessfulVote(sender, id);
266     }
267 
268     function _proxyReplayProtection(DB storage db, address voter, uint32 sequence) internal {
269         // we want the replay protection sequence number to be STRICTLY MORE than what
270         // is stored in the mapping. This means we can set sequence to MAX_UINT32 to disable
271         // any future votes.
272         require(db.sequenceNumber[voter] < sequence, "bad-sequence-n");
273         db.sequenceNumber[voter] = sequence;
274     }
275 
276     /* Admin */
277 
278     function setEndTime(DB storage db, uint64 newEndTime) external {
279         uint16 sb;
280         uint64 sTs;
281         (sb, sTs,) = BPackedUtils.unpackAll(db.packed);
282         db.packed = BPackedUtils.pack(sb, sTs, newEndTime);
283     }
284 
285     function revealSeckey(DB storage db, bytes32 sk) internal {
286         db.ballotEncryptionSeckey = sk;
287         emit SeckeyRevealed(sk);
288     }
289 
290     /* Submission Bits (Ballot Classifications) */
291 
292     // do (bits & SETTINGS_MASK) to get just operational bits (as opposed to testing or official flag)
293     uint16 constant SETTINGS_MASK = 0xFFFF ^ USE_TESTING ^ IS_OFFICIAL ^ IS_BINDING;
294 
295     function isEthNoEnc(uint16 submissionBits) pure internal returns (bool) {
296         return checkFlags(submissionBits, USE_ETH | USE_NO_ENC);
297     }
298 
299     function isEthWithEnc(uint16 submissionBits) pure internal returns (bool) {
300         return checkFlags(submissionBits, USE_ETH | USE_ENC);
301     }
302 
303     function isOfficial(uint16 submissionBits) pure internal returns (bool) {
304         return (submissionBits & IS_OFFICIAL) == IS_OFFICIAL;
305     }
306 
307     function isBinding(uint16 submissionBits) pure internal returns (bool) {
308         return (submissionBits & IS_BINDING) == IS_BINDING;
309     }
310 
311     function isTesting(uint16 submissionBits) pure internal returns (bool) {
312         return (submissionBits & USE_TESTING) == USE_TESTING;
313     }
314 
315     function qualifiesAsCommunityBallot(uint16 submissionBits) pure internal returns (bool) {
316         // if submissionBits AND any of the bits that make this _not_ a community
317         // ballot is equal to zero that means none of those bits were active, so
318         // it could be a community ballot
319         return (submissionBits & (IS_BINDING | IS_OFFICIAL | USE_ENC)) == 0;
320     }
321 
322     function checkFlags(uint16 submissionBits, uint16 expected) pure internal returns (bool) {
323         // this should ignore ONLY the testing/flag bits - all other bits are significant
324         uint16 sBitsNoSettings = submissionBits & SETTINGS_MASK;
325         // then we want ONLY expected
326         return sBitsNoSettings == expected;
327     }
328 }
329 
330 library BPackedUtils {
331 
332     // the uint16 ending at 128 bits should be 0s
333     uint256 constant sbMask        = 0xffffffffffffffffffffffffffff0000ffffffffffffffffffffffffffffffff;
334     uint256 constant startTimeMask = 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff;
335     uint256 constant endTimeMask   = 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
336 
337     function packedToSubmissionBits(uint256 packed) internal pure returns (uint16) {
338         return uint16(packed >> 128);
339     }
340 
341     function packedToStartTime(uint256 packed) internal pure returns (uint64) {
342         return uint64(packed >> 64);
343     }
344 
345     function packedToEndTime(uint256 packed) internal pure returns (uint64) {
346         return uint64(packed);
347     }
348 
349     function unpackAll(uint256 packed) internal pure returns (uint16 submissionBits, uint64 startTime, uint64 endTime) {
350         submissionBits = uint16(packed >> 128);
351         startTime = uint64(packed >> 64);
352         endTime = uint64(packed);
353     }
354 
355     function pack(uint16 sb, uint64 st, uint64 et) internal pure returns (uint256 packed) {
356         return uint256(sb) << 128 | uint256(st) << 64 | uint256(et);
357     }
358 
359     function setSB(uint256 packed, uint16 newSB) internal pure returns (uint256) {
360         return (packed & sbMask) | uint256(newSB) << 128;
361     }
362 
363     // function setStartTime(uint256 packed, uint64 startTime) internal pure returns (uint256) {
364     //     return (packed & startTimeMask) | uint256(startTime) << 64;
365     // }
366 
367     // function setEndTime(uint256 packed, uint64 endTime) internal pure returns (uint256) {
368     //     return (packed & endTimeMask) | uint256(endTime);
369     // }
370 }
371 
372 interface CommAuctionIface {
373     function getNextPrice(bytes32 democHash) external view returns (uint);
374     function noteBallotDeployed(bytes32 democHash) external;
375 
376     // add more when we need it
377 
378     function upgradeMe(address newSC) external;
379 }
380 
381 library IxLib {
382     /**
383      * Usage: `using IxLib for IxIface`
384      * The idea is to (instead of adding methods that already use
385      * available public info to the index) we can create `internal`
386      * methods in the lib to do this instead (which means the code
387      * is inserted into other contracts inline, without a `delegatecall`.
388      *
389      * For this reason it's crucial to have no methods in IxLib with the
390      * same name as methods in IxIface
391      */
392 
393     /* Global price and payments data */
394 
395     function getPayTo(IxIface ix) internal view returns (address) {
396         return ix.getPayments().getPayTo();
397     }
398 
399     /* Global Ix data */
400 
401     function getBBFarmFromBallotID(IxIface ix, uint256 ballotId) internal view returns (BBFarmIface) {
402         bytes4 bbNamespace = bytes4(ballotId >> 48);
403         uint8 bbFarmId = ix.getBBFarmID(bbNamespace);
404         return ix.getBBFarm(bbFarmId);
405     }
406 
407     /* Global backend data */
408 
409     function getGDemocsN(IxIface ix) internal view returns (uint256) {
410         return ix.getBackend().getGDemocsN();
411     }
412 
413     function getGDemoc(IxIface ix, uint256 n) internal view returns (bytes32) {
414         return ix.getBackend().getGDemoc(n);
415     }
416 
417     function getGErc20ToDemocs(IxIface ix, address erc20) internal view returns (bytes32[] democHashes) {
418         return ix.getBackend().getGErc20ToDemocs(erc20);
419     }
420 
421     /* Democ specific payment/account data */
422 
423     function accountInGoodStanding(IxIface ix, bytes32 democHash) internal view returns (bool) {
424         return ix.getPayments().accountInGoodStanding(democHash);
425     }
426 
427     function accountPremiumAndInGoodStanding(IxIface ix, bytes32 democHash) internal view returns (bool) {
428         IxPaymentsIface payments = ix.getPayments();
429         return payments.accountInGoodStanding(democHash) && payments.getPremiumStatus(democHash);
430     }
431 
432     function payForDemocracy(IxIface ix, bytes32 democHash) internal {
433         ix.getPayments().payForDemocracy.value(msg.value)(democHash);
434     }
435 
436     /* Democ getters */
437 
438     function getDOwner(IxIface ix, bytes32 democHash) internal view returns (address) {
439         return ix.getBackend().getDOwner(democHash);
440     }
441 
442     function isDEditor(IxIface ix, bytes32 democHash, address editor) internal view returns (bool) {
443         return ix.getBackend().isDEditor(democHash, editor);
444     }
445 
446     function getDBallotsN(IxIface ix, bytes32 democHash) internal view returns (uint256) {
447         return ix.getBackend().getDBallotsN(democHash);
448     }
449 
450     function getDBallotID(IxIface ix, bytes32 democHash, uint256 n) internal view returns (uint256) {
451         return ix.getBackend().getDBallotID(democHash, n);
452     }
453 
454     function getDInfo(IxIface ix, bytes32 democHash) internal view returns (address erc20, address admin, uint256 _nBallots) {
455         return ix.getBackend().getDInfo(democHash);
456     }
457 
458     function getDErc20(IxIface ix, bytes32 democHash) internal view returns (address erc20) {
459         return ix.getBackend().getDErc20(democHash);
460     }
461 
462     function getDHash(IxIface ix, bytes13 prefix) internal view returns (bytes32) {
463         return ix.getBackend().getDHash(prefix);
464     }
465 
466     function getDCategoriesN(IxIface ix, bytes32 democHash) internal view returns (uint) {
467         return ix.getBackend().getDCategoriesN(democHash);
468     }
469 
470     function getDCategory(IxIface ix, bytes32 democHash, uint categoryId) internal view returns (bool, bytes32, bool, uint) {
471         return ix.getBackend().getDCategory(democHash, categoryId);
472     }
473 
474     function getDArbitraryData(IxIface ix, bytes32 democHash, bytes key) external view returns (bytes) {
475         return ix.getBackend().getDArbitraryData(democHash, key);
476     }
477 }
478 
479 contract SVBallotConsts {
480     // voting settings
481     uint16 constant USE_ETH = 1;          // 2^0
482     uint16 constant USE_SIGNED = 2;       // 2^1
483     uint16 constant USE_NO_ENC = 4;       // 2^2
484     uint16 constant USE_ENC = 8;          // 2^3
485 
486     // ballot settings
487     uint16 constant IS_BINDING = 8192;    // 2^13
488     uint16 constant IS_OFFICIAL = 16384;  // 2^14
489     uint16 constant USE_TESTING = 32768;  // 2^15
490 }
491 
492 contract safeSend {
493     bool private txMutex3847834;
494 
495     // we want to be able to call outside contracts (e.g. the admin proxy contract)
496     // but reentrency is bad, so here's a mutex.
497     function doSafeSend(address toAddr, uint amount) internal {
498         doSafeSendWData(toAddr, "", amount);
499     }
500 
501     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
502         require(txMutex3847834 == false, "ss-guard");
503         txMutex3847834 = true;
504         // we need to use address.call.value(v)() because we want
505         // to be able to send to other contracts, even with no data,
506         // which might use more than 2300 gas in their fallback function.
507         require(toAddr.call.value(amount)(data), "ss-failed");
508         txMutex3847834 = false;
509     }
510 }
511 
512 contract payoutAllC is safeSend {
513     address private _payTo;
514 
515     event PayoutAll(address payTo, uint value);
516 
517     constructor(address initPayTo) public {
518         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
519         assert(initPayTo != address(0));
520         _payTo = initPayTo;
521     }
522 
523     function _getPayTo() internal view returns (address) {
524         return _payTo;
525     }
526 
527     function _setPayTo(address newPayTo) internal {
528         _payTo = newPayTo;
529     }
530 
531     function payoutAll() external {
532         address a = _getPayTo();
533         uint bal = address(this).balance;
534         doSafeSend(a, bal);
535         emit PayoutAll(a, bal);
536     }
537 }
538 
539 contract payoutAllCSettable is payoutAllC {
540     constructor (address initPayTo) payoutAllC(initPayTo) public {
541     }
542 
543     function setPayTo(address) external;
544     function getPayTo() external view returns (address) {
545         return _getPayTo();
546     }
547 }
548 
549 contract owned {
550     address public owner;
551 
552     event OwnerChanged(address newOwner);
553 
554     modifier only_owner() {
555         require(msg.sender == owner, "only_owner: forbidden");
556         _;
557     }
558 
559     modifier owner_or(address addr) {
560         require(msg.sender == addr || msg.sender == owner, "!owner-or");
561         _;
562     }
563 
564     constructor() public {
565         owner = msg.sender;
566     }
567 
568     function setOwner(address newOwner) only_owner() external {
569         owner = newOwner;
570         emit OwnerChanged(newOwner);
571     }
572 }
573 
574 contract CanReclaimToken is owned {
575 
576     /**
577     * @dev Reclaim all ERC20Basic compatible tokens
578     * @param token ERC20Basic The address of the token contract
579     */
580     function reclaimToken(ERC20Interface token) external only_owner {
581         uint256 balance = token.balanceOf(this);
582         require(token.approve(owner, balance));
583     }
584 
585 }
586 
587 contract CommunityAuctionSimple is owned {
588     // about $1USD at $600usd/eth
589     uint public commBallotPriceWei = 1666666666000000;
590 
591     struct Record {
592         bytes32 democHash;
593         uint ts;
594     }
595 
596     mapping (address => Record[]) public ballotLog;
597     mapping (address => address) public upgrades;
598 
599     function getNextPrice(bytes32) external view returns (uint) {
600         return commBallotPriceWei;
601     }
602 
603     function noteBallotDeployed(bytes32 d) external {
604         require(upgrades[msg.sender] == address(0));
605         ballotLog[msg.sender].push(Record(d, now));
606     }
607 
608     function upgradeMe(address newSC) external {
609         require(upgrades[msg.sender] == address(0));
610         upgrades[msg.sender] = newSC;
611     }
612 
613     function getBallotLogN(address a) external view returns (uint) {
614         return ballotLog[a].length;
615     }
616 
617     function setPriceWei(uint newPrice) only_owner() external {
618         commBallotPriceWei = newPrice;
619     }
620 }
621 
622 contract controlledIface {
623     function controller() external view returns (address);
624 }
625 
626 contract hasAdmins is owned {
627     mapping (uint => mapping (address => bool)) admins;
628     uint public currAdminEpoch = 0;
629     bool public adminsDisabledForever = false;
630     address[] adminLog;
631 
632     event AdminAdded(address indexed newAdmin);
633     event AdminRemoved(address indexed oldAdmin);
634     event AdminEpochInc();
635     event AdminDisabledForever();
636 
637     modifier only_admin() {
638         require(adminsDisabledForever == false, "admins must not be disabled");
639         require(isAdmin(msg.sender), "only_admin: forbidden");
640         _;
641     }
642 
643     constructor() public {
644         _setAdmin(msg.sender, true);
645     }
646 
647     function isAdmin(address a) view public returns (bool) {
648         return admins[currAdminEpoch][a];
649     }
650 
651     function getAdminLogN() view external returns (uint) {
652         return adminLog.length;
653     }
654 
655     function getAdminLog(uint n) view external returns (address) {
656         return adminLog[n];
657     }
658 
659     function upgradeMeAdmin(address newAdmin) only_admin() external {
660         // note: already checked msg.sender has admin with `only_admin` modifier
661         require(msg.sender != owner, "owner cannot upgrade self");
662         _setAdmin(msg.sender, false);
663         _setAdmin(newAdmin, true);
664     }
665 
666     function setAdmin(address a, bool _givePerms) only_admin() external {
667         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
668         _setAdmin(a, _givePerms);
669     }
670 
671     function _setAdmin(address a, bool _givePerms) internal {
672         admins[currAdminEpoch][a] = _givePerms;
673         if (_givePerms) {
674             emit AdminAdded(a);
675             adminLog.push(a);
676         } else {
677             emit AdminRemoved(a);
678         }
679     }
680 
681     // safety feature if admins go bad or something
682     function incAdminEpoch() only_owner() external {
683         currAdminEpoch++;
684         admins[currAdminEpoch][msg.sender] = true;
685         emit AdminEpochInc();
686     }
687 
688     // this is internal so contracts can all it, but not exposed anywhere in this
689     // contract.
690     function disableAdminForever() internal {
691         currAdminEpoch++;
692         adminsDisabledForever = true;
693         emit AdminDisabledForever();
694     }
695 }
696 
697 contract EnsOwnerProxy is hasAdmins {
698     bytes32 public ensNode;
699     ENSIface public ens;
700     PublicResolver public resolver;
701 
702     /**
703      * @param _ensNode The node to administer
704      * @param _ens The ENS Registrar
705      * @param _resolver The ENS Resolver
706      */
707     constructor(bytes32 _ensNode, ENSIface _ens, PublicResolver _resolver) public {
708         ensNode = _ensNode;
709         ens = _ens;
710         resolver = _resolver;
711     }
712 
713     function setAddr(address addr) only_admin() external {
714         _setAddr(addr);
715     }
716 
717     function _setAddr(address addr) internal {
718         resolver.setAddr(ensNode, addr);
719     }
720 
721     function returnToOwner() only_owner() external {
722         ens.setOwner(ensNode, owner);
723     }
724 
725     function fwdToENS(bytes data) only_owner() external {
726         require(address(ens).call(data), "fwding to ens failed");
727     }
728 
729     function fwdToResolver(bytes data) only_owner() external {
730         require(address(resolver).call(data), "fwding to resolver failed");
731     }
732 }
733 
734 contract permissioned is owned, hasAdmins {
735     mapping (address => bool) editAllowed;
736     bool public adminLockdown = false;
737 
738     event PermissionError(address editAddr);
739     event PermissionGranted(address editAddr);
740     event PermissionRevoked(address editAddr);
741     event PermissionsUpgraded(address oldSC, address newSC);
742     event SelfUpgrade(address oldSC, address newSC);
743     event AdminLockdown();
744 
745     modifier only_editors() {
746         require(editAllowed[msg.sender], "only_editors: forbidden");
747         _;
748     }
749 
750     modifier no_lockdown() {
751         require(adminLockdown == false, "no_lockdown: check failed");
752         _;
753     }
754 
755 
756     constructor() owned() hasAdmins() public {
757     }
758 
759 
760     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
761         editAllowed[e] = _editPerms;
762         if (_editPerms)
763             emit PermissionGranted(e);
764         else
765             emit PermissionRevoked(e);
766     }
767 
768     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
769         editAllowed[oldSC] = false;
770         editAllowed[newSC] = true;
771         emit PermissionsUpgraded(oldSC, newSC);
772     }
773 
774     // always allow SCs to upgrade themselves, even after lockdown
775     function upgradeMe(address newSC) only_editors() external {
776         editAllowed[msg.sender] = false;
777         editAllowed[newSC] = true;
778         emit SelfUpgrade(msg.sender, newSC);
779     }
780 
781     function hasPermissions(address a) public view returns (bool) {
782         return editAllowed[a];
783     }
784 
785     function doLockdown() external only_owner() no_lockdown() {
786         disableAdminForever();
787         adminLockdown = true;
788         emit AdminLockdown();
789     }
790 }
791 
792 contract upgradePtr {
793     address ptr = address(0);
794 
795     modifier not_upgraded() {
796         require(ptr == address(0), "upgrade pointer is non-zero");
797         _;
798     }
799 
800     function getUpgradePointer() view external returns (address) {
801         return ptr;
802     }
803 
804     function doUpgradeInternal(address nextSC) internal {
805         ptr = nextSC;
806     }
807 }
808 
809 interface ERC20Interface {
810     // Get the total token supply
811     function totalSupply() constant external returns (uint256 _totalSupply);
812 
813     // Get the account balance of another account with address _owner
814     function balanceOf(address _owner) constant external returns (uint256 balance);
815 
816     // Send _value amount of tokens to address _to
817     function transfer(address _to, uint256 _value) external returns (bool success);
818 
819     // Send _value amount of tokens from address _from to address _to
820     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
821 
822     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
823     // If this function is called again it overwrites the current allowance with _value.
824     // this function is required for some DEX functionality
825     function approve(address _spender, uint256 _value) external returns (bool success);
826 
827     // Returns the amount which _spender is still allowed to withdraw from _owner
828     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
829 
830     // Triggered when tokens are transferred.
831     event Transfer(address indexed _from, address indexed _to, uint256 _value);
832 
833     // Triggered whenever approve(address _spender, uint256 _value) is called.
834     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
835 }
836 
837 contract ixEvents {
838     event PaymentMade(uint[2] valAndRemainder);
839     event AddedBBFarm(uint8 bbFarmId);
840     event SetBackend(bytes32 setWhat, address newSC);
841     event DeprecatedBBFarm(uint8 bbFarmId);
842     event CommunityBallot(bytes32 democHash, uint256 ballotId);
843     event ManuallyAddedBallot(bytes32 democHash, uint256 ballotId, uint256 packed);
844     // copied from BBFarm - unable to inherit from BBFarmEvents...
845     event BallotCreatedWithID(uint ballotId);
846     event BBFarmInit(bytes4 namespace);
847 }
848 
849 contract ixBackendEvents {
850     event NewDemoc(bytes32 democHash);
851     event ManuallyAddedDemoc(bytes32 democHash, address erc20);
852     event NewBallot(bytes32 indexed democHash, uint ballotN);
853     event DemocOwnerSet(bytes32 indexed democHash, address owner);
854     event DemocEditorSet(bytes32 indexed democHash, address editor, bool canEdit);
855     event DemocEditorsWiped(bytes32 indexed democHash);
856     event DemocErc20Set(bytes32 indexed democHash, address erc20);
857     event DemocDataSet(bytes32 indexed democHash, bytes32 keyHash);
858     event DemocCatAdded(bytes32 indexed democHash, uint catId);
859     event DemocCatDeprecated(bytes32 indexed democHash, uint catId);
860     event DemocCommunityBallotsEnabled(bytes32 indexed democHash, bool enabled);
861     event DemocErc20OwnerClaimDisabled(bytes32 indexed democHash);
862     event DemocClaimed(bytes32 indexed democHash);
863     event EmergencyDemocOwner(bytes32 indexed democHash, address newOwner);
864 }
865 
866 library SafeMath {
867     function subToZero(uint a, uint b) internal pure returns (uint) {
868         if (a < b) {  // then (a - b) would overflow
869             return 0;
870         }
871         return a - b;
872     }
873 }
874 
875 contract ixPaymentEvents {
876     event UpgradedToPremium(bytes32 indexed democHash);
877     event GrantedAccountTime(bytes32 indexed democHash, uint additionalSeconds, bytes32 ref);
878     event AccountPayment(bytes32 indexed democHash, uint additionalSeconds);
879     event SetCommunityBallotFee(uint amount);
880     event SetBasicCentsPricePer30Days(uint amount);
881     event SetPremiumMultiplier(uint8 multiplier);
882     event DowngradeToBasic(bytes32 indexed democHash);
883     event UpgradeToPremium(bytes32 indexed democHash);
884     event SetExchangeRate(uint weiPerCent);
885     event FreeExtension(bytes32 democHash);
886     event SetBallotsPer30Days(uint amount);
887     event SetFreeExtension(bytes32 democHash, bool hasFreeExt);
888     event SetDenyPremium(bytes32 democHash, bool isPremiumDenied);
889     event SetPayTo(address payTo);
890     event SetMinorEditsAddr(address minorEditsAddr);
891     event SetMinWeiForDInit(uint amount);
892 }
893 
894 interface hasVersion {
895     function getVersion() external pure returns (uint);
896 }
897 
898 contract BBFarmIface is BBFarmEvents, permissioned, hasVersion, payoutAllC {
899     /* global bbfarm getters */
900 
901     function getNamespace() external view returns (bytes4);
902     function getBBLibVersion() external view returns (uint256);
903     function getNBallots() external view returns (uint256);
904 
905     /* init a ballot */
906 
907     // note that the ballotId returned INCLUDES the namespace.
908     function initBallot( bytes32 specHash
909                        , uint256 packed
910                        , IxIface ix
911                        , address bbAdmin
912                        , bytes24 extraData
913                        ) external returns (uint ballotId);
914 
915     /* Sponsorship of ballots */
916 
917     function sponsor(uint ballotId) external payable;
918 
919     /* Voting functions */
920 
921     function submitVote(uint ballotId, bytes32 vote, bytes extra) external;
922     function submitProxyVote(bytes32[5] proxyReq, bytes extra) external;
923 
924     /* Ballot Getters */
925 
926     function getDetails(uint ballotId, address voter) external view returns
927             ( bool hasVoted
928             , uint nVotesCast
929             , bytes32 secKey
930             , uint16 submissionBits
931             , uint64 startTime
932             , uint64 endTime
933             , bytes32 specHash
934             , bool deprecated
935             , address ballotOwner
936             , bytes16 extraData);
937 
938     function getVote(uint ballotId, uint voteId) external view returns (bytes32 voteData, address sender, bytes extra);
939     function getTotalSponsorship(uint ballotId) external view returns (uint);
940     function getSponsorsN(uint ballotId) external view returns (uint);
941     function getSponsor(uint ballotId, uint sponsorN) external view returns (address sender, uint amount);
942     function getCreationTs(uint ballotId) external view returns (uint);
943 
944     /* Admin on ballots */
945     function revealSeckey(uint ballotId, bytes32 sk) external;
946     function setEndTime(uint ballotId, uint64 newEndTime) external;  // note: testing only
947     function setDeprecated(uint ballotId) external;
948     function setBallotOwner(uint ballotId, address newOwner) external;
949 }
950 
951 contract BBFarm is BBFarmIface {
952     using BBLib for BBLib.DB;
953     using IxLib for IxIface;
954 
955     // namespaces should be unique for each bbFarm
956     bytes4 constant NAMESPACE = 0x00000001;
957     // last 48 bits
958     uint256 constant BALLOT_ID_MASK = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
959 
960     uint constant VERSION = 2;
961 
962     mapping (uint224 => BBLib.DB) dbs;
963     // note - start at 100 to avoid any test for if 0 is a valid ballotId
964     // also gives us some space to play with low numbers if we want.
965     uint nBallots = 0;
966 
967     /* modifiers */
968 
969     modifier req_namespace(uint ballotId) {
970         // bytes4() will take the _first_ 4 bytes
971         require(bytes4(ballotId >> 224) == NAMESPACE, "bad-namespace");
972         _;
973     }
974 
975     /* Constructor */
976 
977     constructor() payoutAllC(msg.sender) public {
978         // this bbFarm requires v5 of BBLib (note: v4 deprecated immediately due to insecure submitProxyVote)
979         // note: even though we can't test for this in coverage, this has stopped me deploying to kovan with the wrong version tho, so I consider it tested :)
980         assert(BBLib.getVersion() == 6);
981         emit BBFarmInit(NAMESPACE);
982     }
983 
984     /* base SCs */
985 
986     function _getPayTo() internal view returns (address) {
987         return owner;
988     }
989 
990     function getVersion() external pure returns (uint) {
991         return VERSION;
992     }
993 
994     /* global funcs */
995 
996     function getNamespace() external view returns (bytes4) {
997         return NAMESPACE;
998     }
999 
1000     function getBBLibVersion() external view returns (uint256) {
1001         return BBLib.getVersion();
1002     }
1003 
1004     function getNBallots() external view returns (uint256) {
1005         return nBallots;
1006     }
1007 
1008     /* db lookup helper */
1009 
1010     function getDb(uint ballotId) internal view returns (BBLib.DB storage) {
1011         // cut off anything above 224 bits (where the namespace goes)
1012         return dbs[uint224(ballotId)];
1013     }
1014 
1015     /* Init ballot */
1016 
1017     function initBallot( bytes32 specHash
1018                        , uint256 packed
1019                        , IxIface ix
1020                        , address bbAdmin
1021                        , bytes24 extraData
1022                 ) only_editors() external returns (uint ballotId) {
1023         // calculate the ballotId based on the last 224 bits of the specHash.
1024         ballotId = uint224(specHash) ^ (uint256(NAMESPACE) << 224);
1025         // we need to call the init functions on our libraries
1026         getDb(ballotId).init(specHash, packed, ix, bbAdmin, bytes16(uint128(extraData)));
1027         nBallots += 1;
1028 
1029         emit BallotCreatedWithID(ballotId);
1030     }
1031 
1032     /* Sponsorship */
1033 
1034     function sponsor(uint ballotId) external payable {
1035         BBLib.DB storage db = getDb(ballotId);
1036         db.logSponsorship(msg.value);
1037         doSafeSend(db.index.getPayTo(), msg.value);
1038         emit Sponsorship(ballotId, msg.value);
1039     }
1040 
1041     /* Voting */
1042 
1043     function submitVote(uint ballotId, bytes32 vote, bytes extra) req_namespace(ballotId) external {
1044         getDb(ballotId).submitVote(vote, extra);
1045         emit Vote(ballotId, vote, msg.sender, extra);
1046     }
1047 
1048     function submitProxyVote(bytes32[5] proxyReq, bytes extra) req_namespace(uint256(proxyReq[3])) external {
1049         // see https://github.com/secure-vote/tokenvote/blob/master/Docs/DataStructs.md for breakdown of params
1050         // pr[3] is the ballotId, and pr[4] is the vote
1051         uint ballotId = uint256(proxyReq[3]);
1052         address voter = getDb(ballotId).submitProxyVote(proxyReq, extra);
1053         bytes32 vote = proxyReq[4];
1054         emit Vote(ballotId, vote, voter, extra);
1055     }
1056 
1057     /* Getters */
1058 
1059     // note - this is the maxmimum number of vars we can return with one
1060     // function call (taking 2 args)
1061     function getDetails(uint ballotId, address voter) external view returns
1062             ( bool hasVoted
1063             , uint nVotesCast
1064             , bytes32 secKey
1065             , uint16 submissionBits
1066             , uint64 startTime
1067             , uint64 endTime
1068             , bytes32 specHash
1069             , bool deprecated
1070             , address ballotOwner
1071             , bytes16 extraData) {
1072         BBLib.DB storage db = getDb(ballotId);
1073         uint packed = db.packed;
1074         return (
1075             db.getSequenceNumber(voter) > 0,
1076             db.nVotesCast,
1077             db.ballotEncryptionSeckey,
1078             BPackedUtils.packedToSubmissionBits(packed),
1079             BPackedUtils.packedToStartTime(packed),
1080             BPackedUtils.packedToEndTime(packed),
1081             db.specHash,
1082             db.deprecated,
1083             db.ballotOwner,
1084             db.extraData
1085         );
1086     }
1087 
1088     function getVote(uint ballotId, uint voteId) external view returns (bytes32 voteData, address sender, bytes extra) {
1089         (voteData, sender, extra, ) = getDb(ballotId).getVote(voteId);
1090     }
1091 
1092     function getSequenceNumber(uint ballotId, address voter) external view returns (uint32 sequence) {
1093         return getDb(ballotId).getSequenceNumber(voter);
1094     }
1095 
1096     function getTotalSponsorship(uint ballotId) external view returns (uint) {
1097         return getDb(ballotId).getTotalSponsorship();
1098     }
1099 
1100     function getSponsorsN(uint ballotId) external view returns (uint) {
1101         return getDb(ballotId).sponsors.length;
1102     }
1103 
1104     function getSponsor(uint ballotId, uint sponsorN) external view returns (address sender, uint amount) {
1105         return getDb(ballotId).getSponsor(sponsorN);
1106     }
1107 
1108     function getCreationTs(uint ballotId) external view returns (uint) {
1109         return getDb(ballotId).creationTs;
1110     }
1111 
1112     /* ADMIN */
1113 
1114     // Allow the owner to reveal the secret key after ballot conclusion
1115     function revealSeckey(uint ballotId, bytes32 sk) external {
1116         BBLib.DB storage db = getDb(ballotId);
1117         db.requireBallotOwner();
1118         db.requireBallotClosed();
1119         db.revealSeckey(sk);
1120     }
1121 
1122     // note: testing only.
1123     function setEndTime(uint ballotId, uint64 newEndTime) external {
1124         BBLib.DB storage db = getDb(ballotId);
1125         db.requireBallotOwner();
1126         db.requireTesting();
1127         db.setEndTime(newEndTime);
1128     }
1129 
1130     function setDeprecated(uint ballotId) external {
1131         BBLib.DB storage db = getDb(ballotId);
1132         db.requireBallotOwner();
1133         db.deprecated = true;
1134     }
1135 
1136     function setBallotOwner(uint ballotId, address newOwner) external {
1137         BBLib.DB storage db = getDb(ballotId);
1138         db.requireBallotOwner();
1139         db.ballotOwner = newOwner;
1140     }
1141 }
1142 
1143 contract IxIface is hasVersion,
1144                     ixPaymentEvents,
1145                     ixBackendEvents,
1146                     ixEvents,
1147                     SVBallotConsts,
1148                     owned,
1149                     CanReclaimToken,
1150                     upgradePtr,
1151                     payoutAllC {
1152 
1153     /* owner functions */
1154     function addBBFarm(BBFarmIface bbFarm) external returns (uint8 bbFarmId);
1155     function setABackend(bytes32 toSet, address newSC) external;
1156     function deprecateBBFarm(uint8 bbFarmId, BBFarmIface _bbFarm) external;
1157 
1158     /* global getters */
1159     function getPayments() external view returns (IxPaymentsIface);
1160     function getBackend() external view returns (IxBackendIface);
1161     function getBBFarm(uint8 bbFarmId) external view returns (BBFarmIface);
1162     function getBBFarmID(bytes4 bbNamespace) external view returns (uint8 bbFarmId);
1163     function getCommAuction() external view returns (CommAuctionIface);
1164 
1165     /* init a democ */
1166     function dInit(address defualtErc20, bool disableErc20OwnerClaim) external payable returns (bytes32);
1167 
1168     /* democ owner / editor functions */
1169     function setDEditor(bytes32 democHash, address editor, bool canEdit) external;
1170     function setDNoEditors(bytes32 democHash) external;
1171     function setDOwner(bytes32 democHash, address newOwner) external;
1172     function dOwnerErc20Claim(bytes32 democHash) external;
1173     function setDErc20(bytes32 democHash, address newErc20) external;
1174     function dAddCategory(bytes32 democHash, bytes32 categoryName, bool hasParent, uint parent) external;
1175     function dDeprecateCategory(bytes32 democHash, uint categoryId) external;
1176     function dUpgradeToPremium(bytes32 democHash) external;
1177     function dDowngradeToBasic(bytes32 democHash) external;
1178     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1179     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) external;
1180     function dDisableErc20OwnerClaim(bytes32 democHash) external;
1181 
1182     /* democ getters (that used to be here) should be called on either backend or payments directly */
1183     /* use IxLib for convenience functions from other SCs */
1184 
1185     /* ballot deployment */
1186     // only ix owner - used for adding past or special ballots
1187     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed) external;
1188     function dDeployCommunityBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint128 packedTimes) external payable;
1189     function dDeployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint256 packed) external payable;
1190 }
1191 
1192 contract SVIndex is IxIface {
1193     uint256 constant VERSION = 2;
1194 
1195     // generated from: `address public owner;`
1196     bytes4 constant OWNER_SIG = 0x8da5cb5b;
1197     // generated from: `address public controller;`
1198     bytes4 constant CONTROLLER_SIG = 0xf77c4791;
1199 
1200     /* backend & other SC storage */
1201 
1202     IxBackendIface backend;
1203     IxPaymentsIface payments;
1204     EnsOwnerProxy public ensOwnerPx;
1205     BBFarmIface[] bbFarms;
1206     CommAuctionIface commAuction;
1207     // mapping from bbFarm namespace to bbFarmId
1208     mapping (bytes4 => uint8) bbFarmIdLookup;
1209     mapping (uint8 => bool) deprecatedBBFarms;
1210 
1211     //* MODIFIERS /
1212 
1213     modifier onlyDemocOwner(bytes32 democHash) {
1214         require(msg.sender == backend.getDOwner(democHash), "!d-owner");
1215         _;
1216     }
1217 
1218     modifier onlyDemocEditor(bytes32 democHash) {
1219         require(backend.isDEditor(democHash, msg.sender), "!d-editor");
1220         _;
1221     }
1222 
1223     /* FUNCTIONS */
1224 
1225     // constructor
1226     constructor( IxBackendIface _b
1227                , IxPaymentsIface _pay
1228                , EnsOwnerProxy _ensOwnerPx
1229                , BBFarmIface _bbFarm0
1230                , CommAuctionIface _commAuction
1231                ) payoutAllC(msg.sender) public {
1232         backend = _b;
1233         payments = _pay;
1234         ensOwnerPx = _ensOwnerPx;
1235         _addBBFarm(0x0, _bbFarm0);
1236         commAuction = _commAuction;
1237     }
1238 
1239     /* payoutAllC */
1240 
1241     function _getPayTo() internal view returns (address) {
1242         return payments.getPayTo();
1243     }
1244 
1245     /* UPGRADE STUFF */
1246 
1247     function doUpgrade(address nextSC) only_owner() not_upgraded() external {
1248         doUpgradeInternal(nextSC);
1249         backend.upgradeMe(nextSC);
1250         payments.upgradeMe(nextSC);
1251         ensOwnerPx.setAddr(nextSC);
1252         ensOwnerPx.upgradeMeAdmin(nextSC);
1253         commAuction.upgradeMe(nextSC);
1254 
1255         for (uint i = 0; i < bbFarms.length; i++) {
1256             bbFarms[i].upgradeMe(nextSC);
1257         }
1258     }
1259 
1260     function _addBBFarm(bytes4 bbNamespace, BBFarmIface _bbFarm) internal returns (uint8 bbFarmId) {
1261         uint256 bbFarmIdLong = bbFarms.length;
1262         require(bbFarmIdLong < 2**8, "too-many-farms");
1263         bbFarmId = uint8(bbFarmIdLong);
1264 
1265         bbFarms.push(_bbFarm);
1266         bbFarmIdLookup[bbNamespace] = bbFarmId;
1267         emit AddedBBFarm(bbFarmId);
1268     }
1269 
1270     // adding a new BBFarm
1271     function addBBFarm(BBFarmIface bbFarm) only_owner() external returns (uint8 bbFarmId) {
1272         bytes4 bbNamespace = bbFarm.getNamespace();
1273 
1274         require(bbNamespace != bytes4(0), "bb-farm-namespace");
1275         require(bbFarmIdLookup[bbNamespace] == 0 && bbNamespace != bbFarms[0].getNamespace(), "bb-namespace-used");
1276 
1277         bbFarmId = _addBBFarm(bbNamespace, bbFarm);
1278     }
1279 
1280     function setABackend(bytes32 toSet, address newSC) only_owner() external {
1281         emit SetBackend(toSet, newSC);
1282         if (toSet == bytes32("payments")) {
1283             payments = IxPaymentsIface(newSC);
1284         } else if (toSet == bytes32("backend")) {
1285             backend = IxBackendIface(newSC);
1286         } else if (toSet == bytes32("commAuction")) {
1287             commAuction = CommAuctionIface(newSC);
1288         } else {
1289             revert("404");
1290         }
1291     }
1292 
1293     function deprecateBBFarm(uint8 bbFarmId, BBFarmIface _bbFarm) only_owner() external {
1294         require(address(_bbFarm) != address(0));
1295         require(bbFarms[bbFarmId] == _bbFarm);
1296         deprecatedBBFarms[bbFarmId] = true;
1297         emit DeprecatedBBFarm(bbFarmId);
1298     }
1299 
1300     /* Getters for backends */
1301 
1302     function getPayments() external view returns (IxPaymentsIface) {
1303         return payments;
1304     }
1305 
1306     function getBackend() external view returns (IxBackendIface) {
1307         return backend;
1308     }
1309 
1310     function getBBFarm(uint8 bbFarmId) external view returns (BBFarmIface) {
1311         return bbFarms[bbFarmId];
1312     }
1313 
1314     function getBBFarmID(bytes4 bbNamespace) external view returns (uint8 bbFarmId) {
1315         return bbFarmIdLookup[bbNamespace];
1316     }
1317 
1318     function getCommAuction() external view returns (CommAuctionIface) {
1319         return commAuction;
1320     }
1321 
1322     //* GLOBAL INFO */
1323 
1324     function getVersion() external pure returns (uint256) {
1325         return VERSION;
1326     }
1327 
1328     //* DEMOCRACY FUNCTIONS - INDIVIDUAL */
1329 
1330     function dInit(address defaultErc20, bool disableErc20OwnerClaim) not_upgraded() external payable returns (bytes32) {
1331         require(msg.value >= payments.getMinWeiForDInit());
1332         bytes32 democHash = backend.dInit(defaultErc20, msg.sender, disableErc20OwnerClaim);
1333         payments.payForDemocracy.value(msg.value)(democHash);
1334         return democHash;
1335     }
1336 
1337     // admin methods
1338 
1339     function setDEditor(bytes32 democHash, address editor, bool canEdit) onlyDemocOwner(democHash) external {
1340         backend.setDEditor(democHash, editor, canEdit);
1341     }
1342 
1343     function setDNoEditors(bytes32 democHash) onlyDemocOwner(democHash) external {
1344         backend.setDNoEditors(democHash);
1345     }
1346 
1347     function setDOwner(bytes32 democHash, address newOwner) onlyDemocOwner(democHash) external {
1348         backend.setDOwner(democHash, newOwner);
1349     }
1350 
1351     function dOwnerErc20Claim(bytes32 democHash) external {
1352         address erc20 = backend.getDErc20(democHash);
1353         // test if we can call the erc20.owner() method, etc
1354         // also limit gas use to 3000 because we don't know what they'll do with it
1355         // during testing both owned and controlled could be called from other contracts for 2525 gas.
1356         if (erc20.call.gas(3000)(OWNER_SIG)) {
1357             require(msg.sender == owned(erc20).owner.gas(3000)(), "!erc20-owner");
1358         } else if (erc20.call.gas(3000)(CONTROLLER_SIG)) {
1359             require(msg.sender == controlledIface(erc20).controller.gas(3000)(), "!erc20-controller");
1360         } else {
1361             revert();
1362         }
1363         // now we are certain the sender deployed or controls the erc20
1364         backend.setDOwnerFromClaim(democHash, msg.sender);
1365     }
1366 
1367     function setDErc20(bytes32 democHash, address newErc20) onlyDemocOwner(democHash) external {
1368         backend.setDErc20(democHash, newErc20);
1369     }
1370 
1371     function dAddCategory(bytes32 democHash, bytes32 catName, bool hasParent, uint parent) onlyDemocEditor(democHash) external {
1372         backend.dAddCategory(democHash, catName, hasParent, parent);
1373     }
1374 
1375     function dDeprecateCategory(bytes32 democHash, uint catId) onlyDemocEditor(democHash) external {
1376         backend.dDeprecateCategory(democHash, catId);
1377     }
1378 
1379     function dUpgradeToPremium(bytes32 democHash) onlyDemocOwner(democHash) external {
1380         payments.upgradeToPremium(democHash);
1381     }
1382 
1383     function dDowngradeToBasic(bytes32 democHash) onlyDemocOwner(democHash) external {
1384         payments.downgradeToBasic(democHash);
1385     }
1386 
1387     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external {
1388         if (msg.sender == backend.getDOwner(democHash)) {
1389             backend.dSetArbitraryData(democHash, key, value);
1390         } else if (backend.isDEditor(democHash, msg.sender)) {
1391             backend.dSetEditorArbitraryData(democHash, key, value);
1392         } else {
1393             revert();
1394         }
1395     }
1396 
1397     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) onlyDemocOwner(democHash) external {
1398         backend.dSetCommunityBallotsEnabled(democHash, enabled);
1399     }
1400 
1401     // this is one way only!
1402     function dDisableErc20OwnerClaim(bytes32 democHash) onlyDemocOwner(democHash) external {
1403         backend.dDisableErc20OwnerClaim(democHash);
1404     }
1405 
1406     /* Democ Getters - deprecated */
1407     // NOTE: the getters that used to live here just proxied to the backend.
1408     // this has been removed to reduce gas costs + size of Ix contract
1409     // For SCs you should use IxLib for convenience.
1410     // For Offchain use you should query the backend directly (via ix.getBackend())
1411 
1412     /* Add and Deploy Ballots */
1413 
1414     // manually add a ballot - only the owner can call this
1415     // WARNING - it's required that we make ABSOLUTELY SURE that
1416     // ballotId is valid and can resolve via the appropriate BBFarm.
1417     // this function _DOES NOT_ validate that everything else is done.
1418     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed)
1419                       only_owner()
1420                       external {
1421 
1422         _addBallot(democHash, ballotId, packed, false);
1423         emit ManuallyAddedBallot(democHash, ballotId, packed);
1424     }
1425 
1426 
1427     function _deployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint packed, bool checkLimit, bool alreadySentTx) internal returns (uint ballotId) {
1428         require(BBLib.isTesting(BPackedUtils.packedToSubmissionBits(packed)) == false, "b-testing");
1429 
1430         // the most significant byte of extraData signals the bbFarm to use.
1431         uint8 bbFarmId = uint8(extraData[0]);
1432         require(deprecatedBBFarms[bbFarmId] == false, "bb-dep");
1433         BBFarmIface _bbFarm = bbFarms[bbFarmId];
1434 
1435         // anything that isn't a community ballot counts towards the basic limit.
1436         // we want to check in cases where
1437         // the ballot doesn't qualify as a community ballot
1438         // OR (the ballot qualifies as a community ballot
1439         //     AND the admins have _disabled_ community ballots).
1440         bool countTowardsLimit = checkLimit;
1441         bool performedSend;
1442         if (checkLimit) {
1443             uint64 endTime = BPackedUtils.packedToEndTime(packed);
1444             (countTowardsLimit, performedSend) = _basicBallotLimitOperations(democHash, _bbFarm);
1445             _accountOkayChecks(democHash, endTime);
1446         }
1447 
1448         if (!performedSend && msg.value > 0 && alreadySentTx == false) {
1449             // refund if we haven't send value anywhere (which might happen if someone accidentally pays us)
1450             doSafeSend(msg.sender, msg.value);
1451         }
1452 
1453         ballotId = _bbFarm.initBallot(
1454             specHash,
1455             packed,
1456             this,
1457             msg.sender,
1458             // we are certain that the first 8 bytes are for index use only.
1459             // truncating extraData like this means we can occasionally
1460             // save on gas. we need to use uint192 first because that will take
1461             // the _last_ 24 bytes of extraData.
1462             bytes24(uint192(extraData)));
1463 
1464         _addBallot(democHash, ballotId, packed, countTowardsLimit);
1465     }
1466 
1467     function dDeployCommunityBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint128 packedTimes) external payable {
1468         uint price = commAuction.getNextPrice(democHash);
1469         require(msg.value >= price, "!cb-fee");
1470 
1471         doSafeSend(payments.getPayTo(), price);
1472         doSafeSend(msg.sender, msg.value - price);
1473 
1474         bool canProceed = backend.getDCommBallotsEnabled(democHash) || !payments.accountInGoodStanding(democHash);
1475         require(canProceed, "!cb-enabled");
1476 
1477         uint256 packed = BPackedUtils.setSB(uint256(packedTimes), (USE_ETH | USE_NO_ENC));
1478 
1479         uint ballotId = _deployBallot(democHash, specHash, extraData, packed, false, true);
1480         commAuction.noteBallotDeployed(democHash);
1481 
1482         emit CommunityBallot(democHash, ballotId);
1483     }
1484 
1485     // only way a democ admin can deploy a ballot
1486     function dDeployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint256 packed)
1487                           onlyDemocEditor(democHash)
1488                           external payable {
1489 
1490         _deployBallot(democHash, specHash, extraData, packed, true, false);
1491     }
1492 
1493     // internal logic around adding a ballot
1494     function _addBallot(bytes32 democHash, uint256 ballotId, uint256 packed, bool countTowardsLimit) internal {
1495         // backend handles events
1496         backend.dAddBallot(democHash, ballotId, packed, countTowardsLimit);
1497     }
1498 
1499     // check an account has paid up enough for this ballot
1500     function _accountOkayChecks(bytes32 democHash, uint64 endTime) internal view {
1501         // if the ballot is marked as official require the democracy is paid up to
1502         // some relative amount - exclude NFP accounts from this check
1503         uint secsLeft = payments.getSecondsRemaining(democHash);
1504         // must be positive due to ending in future check
1505         uint256 secsToEndTime = endTime - now;
1506         // require ballots end no more than twice the time left on the democracy
1507         require(secsLeft * 2 > secsToEndTime, "unpaid");
1508     }
1509 
1510     function _basicBallotLimitOperations(bytes32 democHash, BBFarmIface _bbFarm) internal returns (bool shouldCount, bool performedSend) {
1511         // if we're an official ballot and the democ is basic, ensure the democ
1512         // isn't over the ballots/mo limit
1513         if (payments.getPremiumStatus(democHash) == false) {
1514             uint nBallotsAllowed = payments.getBasicBallotsPer30Days();
1515             uint nBallotsBasicCounted = backend.getDCountedBasicBallotsN(democHash);
1516 
1517             // if the democ has less than nBallotsAllowed then it's guarenteed to be okay
1518             if (nBallotsAllowed > nBallotsBasicCounted) {
1519                 // and we should count this ballot
1520                 return (true, false);
1521             }
1522 
1523             // we want to check the creation timestamp of the nth most recent ballot
1524             // where n is the # of ballots allowed per month. Note: there isn't an off
1525             // by 1 error here because if 1 ballots were allowed per month then we'd want
1526             // to look at the most recent ballot, so nBallotsBasicCounted-1 in this case.
1527             // similarly, if X ballots were allowed per month we want to look at
1528             // nBallotsBasicCounted-X. There would thus be (X-1) ballots that are _more_
1529             // recent than the one we're looking for.
1530             uint earlyBallotId = backend.getDCountedBasicBallotID(democHash, nBallotsBasicCounted - nBallotsAllowed);
1531             uint earlyBallotTs = _bbFarm.getCreationTs(earlyBallotId);
1532 
1533             // if the earlyBallot was created more than 30 days in the past we should
1534             // count the new ballot
1535             if (earlyBallotTs < now - 30 days) {
1536                 return (true, false);
1537             }
1538 
1539             // at this point it may be the case that we shouldn't allow the ballot
1540             // to be created. (It's an official ballot for a basic tier democracy
1541             // where the Nth most recent ballot was created within the last 30 days.)
1542             // We should now check for payment
1543             uint extraBallotFee = payments.getBasicExtraBallotFeeWei();
1544             require(msg.value >= extraBallotFee, "!extra-b-fee");
1545 
1546             // now that we know they've paid the fee, we should send Eth to `payTo`
1547             // and return the remainder.
1548             uint remainder = msg.value - extraBallotFee;
1549             doSafeSend(address(payments), extraBallotFee);
1550             doSafeSend(msg.sender, remainder);
1551             emit PaymentMade([extraBallotFee, remainder]);
1552             // only in this case (for basic) do we want to return false - don't count towards the
1553             // limit because it's been paid for here.
1554             return (false, true);
1555 
1556         } else {  // if we're premium we don't count ballots
1557             return (false, false);
1558         }
1559     }
1560 }
1561 
1562 contract IxBackendIface is hasVersion, ixBackendEvents, permissioned, payoutAllC {
1563     /* global getters */
1564     function getGDemocsN() external view returns (uint);
1565     function getGDemoc(uint id) external view returns (bytes32);
1566     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes);
1567 
1568     /* owner functions */
1569     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) external;
1570     function emergencySetDOwner(bytes32 democHash, address newOwner) external;
1571 
1572     /* democ admin */
1573     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) external returns (bytes32 democHash);
1574     function setDOwner(bytes32 democHash, address newOwner) external;
1575     function setDOwnerFromClaim(bytes32 democHash, address newOwner) external;
1576     function setDEditor(bytes32 democHash, address editor, bool canEdit) external;
1577     function setDNoEditors(bytes32 democHash) external;
1578     function setDErc20(bytes32 democHash, address newErc20) external;
1579     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1580     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1581     function dAddCategory(bytes32 democHash, bytes32 categoryName, bool hasParent, uint parent) external;
1582     function dDeprecateCategory(bytes32 democHash, uint catId) external;
1583     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) external;
1584     function dDisableErc20OwnerClaim(bytes32 democHash) external;
1585 
1586     /* actually add a ballot */
1587     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) external;
1588 
1589     /* global democ getters */
1590     function getDOwner(bytes32 democHash) external view returns (address);
1591     function isDEditor(bytes32 democHash, address editor) external view returns (bool);
1592     function getDHash(bytes13 prefix) external view returns (bytes32);
1593     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots);
1594     function getDErc20(bytes32 democHash) external view returns (address);
1595     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
1596     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
1597     function getDBallotsN(bytes32 democHash) external view returns (uint256);
1598     function getDBallotID(bytes32 democHash, uint n) external view returns (uint ballotId);
1599     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256);
1600     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256);
1601     function getDCategoriesN(bytes32 democHash) external view returns (uint);
1602     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint parent);
1603     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool);
1604     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool);
1605 }
1606 
1607 contract SVIndexBackend is IxBackendIface {
1608     uint constant VERSION = 2;
1609 
1610     struct Democ {
1611         address erc20;
1612         address owner;
1613         bool communityBallotsDisabled;
1614         bool erc20OwnerClaimDisabled;
1615         uint editorEpoch;
1616         mapping (uint => mapping (address => bool)) editors;
1617         uint256[] allBallots;
1618         uint256[] includedBasicBallots;  // the IDs of official ballots
1619 
1620     }
1621 
1622     struct BallotRef {
1623         bytes32 democHash;
1624         uint ballotId;
1625     }
1626 
1627     struct Category {
1628         bool deprecated;
1629         bytes32 name;
1630         bool hasParent;
1631         uint parent;
1632     }
1633 
1634     struct CategoriesIx {
1635         uint nCategories;
1636         mapping(uint => Category) categories;
1637     }
1638 
1639     mapping (bytes32 => Democ) democs;
1640     mapping (bytes32 => CategoriesIx) democCategories;
1641     mapping (bytes13 => bytes32) democPrefixToHash;
1642     mapping (address => bytes32[]) erc20ToDemocs;
1643     bytes32[] democList;
1644 
1645     // allows democ admins to store arbitrary data
1646     // this lets us (for example) set particular keys to signal cerain
1647     // things to client apps s.t. the admin can turn them on and off.
1648     // arbitraryData[democHash][key]
1649     mapping (bytes32 => mapping (bytes32 => bytes)) arbitraryData;
1650 
1651     /* constructor */
1652 
1653     constructor() payoutAllC(msg.sender) public {
1654         // do nothing
1655     }
1656 
1657     /* base contract overloads */
1658 
1659     function _getPayTo() internal view returns (address) {
1660         return owner;
1661     }
1662 
1663     function getVersion() external pure returns (uint) {
1664         return VERSION;
1665     }
1666 
1667     /* GLOBAL INFO */
1668 
1669     function getGDemocsN() external view returns (uint) {
1670         return democList.length;
1671     }
1672 
1673     function getGDemoc(uint id) external view returns (bytes32) {
1674         return democList[id];
1675     }
1676 
1677     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes) {
1678         return erc20ToDemocs[erc20];
1679     }
1680 
1681     /* DEMOCRACY ADMIN FUNCTIONS */
1682 
1683     function _addDemoc(bytes32 democHash, address erc20, address initOwner, bool disableErc20OwnerClaim) internal {
1684         democList.push(democHash);
1685         Democ storage d = democs[democHash];
1686         d.erc20 = erc20;
1687         if (disableErc20OwnerClaim) {
1688             d.erc20OwnerClaimDisabled = true;
1689         }
1690         // this should never trigger if we have a good security model - entropy for 13 bytes ~ 2^(8*13) ~ 10^31
1691         assert(democPrefixToHash[bytes13(democHash)] == bytes32(0));
1692         democPrefixToHash[bytes13(democHash)] = democHash;
1693         erc20ToDemocs[erc20].push(democHash);
1694         _setDOwner(democHash, initOwner);
1695         emit NewDemoc(democHash);
1696     }
1697 
1698     /* owner democ admin functions */
1699 
1700     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) only_owner() external {
1701         _addDemoc(democHash, erc20, msg.sender, disableErc20OwnerClaim);
1702         emit ManuallyAddedDemoc(democHash, erc20);
1703     }
1704 
1705     /* Preferably for emergencies only */
1706 
1707     function emergencySetDOwner(bytes32 democHash, address newOwner) only_owner() external {
1708         _setDOwner(democHash, newOwner);
1709         emit EmergencyDemocOwner(democHash, newOwner);
1710     }
1711 
1712     /* user democ admin functions */
1713 
1714     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) only_editors() external returns (bytes32 democHash) {
1715         // generating the democHash in this way guarentees it'll be unique/hard-to-brute-force
1716         // (particularly because prevBlockHash and now are part of the hash)
1717         democHash = keccak256(abi.encodePacked(democList.length, blockhash(block.number-1), defaultErc20, now));
1718         _addDemoc(democHash, defaultErc20, initOwner, disableErc20OwnerClaim);
1719     }
1720 
1721     function _setDOwner(bytes32 democHash, address newOwner) internal {
1722         Democ storage d = democs[democHash];
1723         uint epoch = d.editorEpoch;
1724         d.owner = newOwner;
1725         // unset prev owner as editor - does little if one was not set
1726         d.editors[epoch][d.owner] = false;
1727         // make new owner an editor too
1728         d.editors[epoch][newOwner] = true;
1729         emit DemocOwnerSet(democHash, newOwner);
1730     }
1731 
1732     function setDOwner(bytes32 democHash, address newOwner) only_editors() external {
1733         _setDOwner(democHash, newOwner);
1734     }
1735 
1736     function setDOwnerFromClaim(bytes32 democHash, address newOwner) only_editors() external {
1737         Democ storage d = democs[democHash];
1738         // make sure that the owner claim is enabled (i.e. the disabled flag is false)
1739         require(d.erc20OwnerClaimDisabled == false, "!erc20-claim");
1740         // set owner and editor
1741         d.owner = newOwner;
1742         d.editors[d.editorEpoch][newOwner] = true;
1743         // disable the ability to claim now that it's done
1744         d.erc20OwnerClaimDisabled = true;
1745         emit DemocOwnerSet(democHash, newOwner);
1746         emit DemocClaimed(democHash);
1747     }
1748 
1749     function setDEditor(bytes32 democHash, address editor, bool canEdit) only_editors() external {
1750         Democ storage d = democs[democHash];
1751         d.editors[d.editorEpoch][editor] = canEdit;
1752         emit DemocEditorSet(democHash, editor, canEdit);
1753     }
1754 
1755     function setDNoEditors(bytes32 democHash) only_editors() external {
1756         democs[democHash].editorEpoch += 1;
1757         emit DemocEditorsWiped(democHash);
1758     }
1759 
1760     function setDErc20(bytes32 democHash, address newErc20) only_editors() external {
1761         democs[democHash].erc20 = newErc20;
1762         erc20ToDemocs[newErc20].push(democHash);
1763         emit DemocErc20Set(democHash, newErc20);
1764     }
1765 
1766     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
1767         bytes32 k = keccak256(key);
1768         arbitraryData[democHash][k] = value;
1769         emit DemocDataSet(democHash, k);
1770     }
1771 
1772     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
1773         bytes32 k = keccak256(_calcEditorKey(key));
1774         arbitraryData[democHash][k] = value;
1775         emit DemocDataSet(democHash, k);
1776     }
1777 
1778     function dAddCategory(bytes32 democHash, bytes32 name, bool hasParent, uint parent) only_editors() external {
1779         uint catId = democCategories[democHash].nCategories;
1780         democCategories[democHash].categories[catId].name = name;
1781         if (hasParent) {
1782             democCategories[democHash].categories[catId].hasParent = true;
1783             democCategories[democHash].categories[catId].parent = parent;
1784         }
1785         democCategories[democHash].nCategories += 1;
1786         emit DemocCatAdded(democHash, catId);
1787     }
1788 
1789     function dDeprecateCategory(bytes32 democHash, uint catId) only_editors() external {
1790         democCategories[democHash].categories[catId].deprecated = true;
1791         emit DemocCatDeprecated(democHash, catId);
1792     }
1793 
1794     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) only_editors() external {
1795         democs[democHash].communityBallotsDisabled = !enabled;
1796         emit DemocCommunityBallotsEnabled(democHash, enabled);
1797     }
1798 
1799     function dDisableErc20OwnerClaim(bytes32 democHash) only_editors() external {
1800         democs[democHash].erc20OwnerClaimDisabled = true;
1801         emit DemocErc20OwnerClaimDisabled(democHash);
1802     }
1803 
1804     //* ADD BALLOT TO RECORD */
1805 
1806     function _commitBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) internal {
1807         uint16 subBits;
1808         subBits = BPackedUtils.packedToSubmissionBits(packed);
1809 
1810         uint localBallotId = democs[democHash].allBallots.length;
1811         democs[democHash].allBallots.push(ballotId);
1812 
1813         // do this for anything that doesn't qualify as a community ballot
1814         if (countTowardsLimit) {
1815             democs[democHash].includedBasicBallots.push(ballotId);
1816         }
1817 
1818         emit NewBallot(democHash, localBallotId);
1819     }
1820 
1821     // what SVIndex uses to add a ballot
1822     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) only_editors() external {
1823         _commitBallot(democHash, ballotId, packed, countTowardsLimit);
1824     }
1825 
1826     /* democ getters */
1827 
1828     function getDOwner(bytes32 democHash) external view returns (address) {
1829         return democs[democHash].owner;
1830     }
1831 
1832     function isDEditor(bytes32 democHash, address editor) external view returns (bool) {
1833         Democ storage d = democs[democHash];
1834         // allow either an editor or always the owner
1835         return d.editors[d.editorEpoch][editor] || editor == d.owner;
1836     }
1837 
1838     function getDHash(bytes13 prefix) external view returns (bytes32) {
1839         return democPrefixToHash[prefix];
1840     }
1841 
1842     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots) {
1843         return (democs[democHash].erc20, democs[democHash].owner, democs[democHash].allBallots.length);
1844     }
1845 
1846     function getDErc20(bytes32 democHash) external view returns (address) {
1847         return democs[democHash].erc20;
1848     }
1849 
1850     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
1851         return arbitraryData[democHash][keccak256(key)];
1852     }
1853 
1854     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
1855         return arbitraryData[democHash][keccak256(_calcEditorKey(key))];
1856     }
1857 
1858     function getDBallotsN(bytes32 democHash) external view returns (uint256) {
1859         return democs[democHash].allBallots.length;
1860     }
1861 
1862     function getDBallotID(bytes32 democHash, uint256 n) external view returns (uint ballotId) {
1863         return democs[democHash].allBallots[n];
1864     }
1865 
1866     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256) {
1867         return democs[democHash].includedBasicBallots.length;
1868     }
1869 
1870     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256) {
1871         return democs[democHash].includedBasicBallots[n];
1872     }
1873 
1874     function getDCategoriesN(bytes32 democHash) external view returns (uint) {
1875         return democCategories[democHash].nCategories;
1876     }
1877 
1878     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint256 parent) {
1879         deprecated = democCategories[democHash].categories[catId].deprecated;
1880         name = democCategories[democHash].categories[catId].name;
1881         hasParent = democCategories[democHash].categories[catId].hasParent;
1882         parent = democCategories[democHash].categories[catId].parent;
1883     }
1884 
1885     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool) {
1886         return !democs[democHash].communityBallotsDisabled;
1887     }
1888 
1889     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool) {
1890         return !democs[democHash].erc20OwnerClaimDisabled;
1891     }
1892 
1893     /* util for calculating editor key */
1894 
1895     function _calcEditorKey(bytes key) internal pure returns (bytes) {
1896         return abi.encodePacked("editor.", key);
1897     }
1898 }
1899 
1900 contract IxPaymentsIface is hasVersion, ixPaymentEvents, permissioned, CanReclaimToken, payoutAllCSettable {
1901     /* in emergency break glass */
1902     function emergencySetOwner(address newOwner) external;
1903 
1904     /* financial calcluations */
1905     function weiBuysHowManySeconds(uint amount) public view returns (uint secs);
1906     function weiToCents(uint w) public view returns (uint);
1907     function centsToWei(uint c) public view returns (uint);
1908 
1909     /* account management */
1910     function payForDemocracy(bytes32 democHash) external payable;
1911     function doFreeExtension(bytes32 democHash) external;
1912     function downgradeToBasic(bytes32 democHash) external;
1913     function upgradeToPremium(bytes32 democHash) external;
1914 
1915     /* account status - getters */
1916     function accountInGoodStanding(bytes32 democHash) external view returns (bool);
1917     function getSecondsRemaining(bytes32 democHash) external view returns (uint);
1918     function getPremiumStatus(bytes32 democHash) external view returns (bool);
1919     function getFreeExtension(bytes32 democHash) external view returns (bool);
1920     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension);
1921     function getDenyPremium(bytes32 democHash) external view returns (bool);
1922 
1923     /* admin utils for accounts */
1924     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) external;
1925 
1926     /* admin setters global */
1927     function setPayTo(address) external;
1928     function setMinorEditsAddr(address) external;
1929     function setBasicCentsPricePer30Days(uint amount) external;
1930     function setBasicBallotsPer30Days(uint amount) external;
1931     function setPremiumMultiplier(uint8 amount) external;
1932     function setWeiPerCent(uint) external;
1933     function setFreeExtension(bytes32 democHash, bool hasFreeExt) external;
1934     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) external;
1935     function setMinWeiForDInit(uint amount) external;
1936 
1937     /* global getters */
1938     function getBasicCentsPricePer30Days() external view returns(uint);
1939     function getBasicExtraBallotFeeWei() external view returns (uint);
1940     function getBasicBallotsPer30Days() external view returns (uint);
1941     function getPremiumMultiplier() external view returns (uint8);
1942     function getPremiumCentsPricePer30Days() external view returns (uint);
1943     function getWeiPerCent() external view returns (uint weiPerCent);
1944     function getUsdEthExchangeRate() external view returns (uint centsPerEth);
1945     function getMinWeiForDInit() external view returns (uint);
1946 
1947     /* payments stuff */
1948     function getPaymentLogN() external view returns (uint);
1949     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue);
1950 }
1951 
1952 contract SVPayments is IxPaymentsIface {
1953     uint constant VERSION = 2;
1954 
1955     struct Account {
1956         bool isPremium;
1957         uint lastPaymentTs;
1958         uint paidUpTill;
1959         uint lastUpgradeTs;  // timestamp of the last time it was upgraded to premium
1960     }
1961 
1962     struct PaymentLog {
1963         bool _external;
1964         bytes32 _democHash;
1965         uint _seconds;
1966         uint _ethValue;
1967     }
1968 
1969     // this is an address that's only allowed to make minor edits
1970     // e.g. setExchangeRate, setDenyPremium, giveTimeToDemoc
1971     address public minorEditsAddr;
1972 
1973     // payment details
1974     uint basicCentsPricePer30Days = 125000; // $1250/mo
1975     uint basicBallotsPer30Days = 10;
1976     uint8 premiumMultiplier = 5;
1977     uint weiPerCent = 0.000016583747 ether;  // $603, 4th June 2018
1978 
1979     uint minWeiForDInit = 1;  // minimum 1 wei - match existing behaviour in SVIndex
1980 
1981     mapping (bytes32 => Account) accounts;
1982     PaymentLog[] payments;
1983 
1984     // can set this on freeExtension democs to deny them premium upgrades
1985     mapping (bytes32 => bool) denyPremium;
1986     // this is used for non-profits or organisations that have perpetual licenses, etc
1987     mapping (bytes32 => bool) freeExtension;
1988 
1989 
1990     /* BREAK GLASS IN CASE OF EMERGENCY */
1991     // this is included here because something going wrong with payments is possibly
1992     // the absolute worst case. Note: does this have negligable benefit if the other
1993     // contracts are compromised? (e.g. by a leaked privkey)
1994     address public emergencyAdmin;
1995     function emergencySetOwner(address newOwner) external {
1996         require(msg.sender == emergencyAdmin, "!emergency-owner");
1997         owner = newOwner;
1998     }
1999     /* END BREAK GLASS */
2000 
2001 
2002     constructor(address _emergencyAdmin) payoutAllCSettable(msg.sender) public {
2003         emergencyAdmin = _emergencyAdmin;
2004         assert(_emergencyAdmin != address(0));
2005     }
2006 
2007     /* base SCs */
2008 
2009     function getVersion() external pure returns (uint) {
2010         return VERSION;
2011     }
2012 
2013     function() payable public {
2014         _getPayTo().transfer(msg.value);
2015     }
2016 
2017     function _modAccountBalance(bytes32 democHash, uint additionalSeconds) internal {
2018         uint prevPaidTill = accounts[democHash].paidUpTill;
2019         if (prevPaidTill < now) {
2020             prevPaidTill = now;
2021         }
2022 
2023         accounts[democHash].paidUpTill = prevPaidTill + additionalSeconds;
2024         accounts[democHash].lastPaymentTs = now;
2025     }
2026 
2027     /* Financial Calculations */
2028 
2029     function weiBuysHowManySeconds(uint amount) public view returns (uint) {
2030         uint centsPaid = weiToCents(amount);
2031         // multiply by 10**18 to ensure we make rounding errors insignificant
2032         uint monthsOffsetPaid = ((10 ** 18) * centsPaid) / basicCentsPricePer30Days;
2033         uint secondsOffsetPaid = monthsOffsetPaid * (30 days);
2034         uint additionalSeconds = secondsOffsetPaid / (10 ** 18);
2035         return additionalSeconds;
2036     }
2037 
2038     function weiToCents(uint w) public view returns (uint) {
2039         return w / weiPerCent;
2040     }
2041 
2042     function centsToWei(uint c) public view returns (uint) {
2043         return c * weiPerCent;
2044     }
2045 
2046     /* account management */
2047 
2048     function payForDemocracy(bytes32 democHash) external payable {
2049         require(msg.value > 0, "need to send some ether to make payment");
2050 
2051         uint additionalSeconds = weiBuysHowManySeconds(msg.value);
2052 
2053         if (accounts[democHash].isPremium) {
2054             additionalSeconds /= premiumMultiplier;
2055         }
2056 
2057         if (additionalSeconds >= 1) {
2058             _modAccountBalance(democHash, additionalSeconds);
2059         }
2060         payments.push(PaymentLog(false, democHash, additionalSeconds, msg.value));
2061         emit AccountPayment(democHash, additionalSeconds);
2062 
2063         _getPayTo().transfer(msg.value);
2064     }
2065 
2066     function doFreeExtension(bytes32 democHash) external {
2067         require(freeExtension[democHash], "!free");
2068         uint newPaidUpTill = now + 60 days;
2069         accounts[democHash].paidUpTill = newPaidUpTill;
2070         emit FreeExtension(democHash);
2071     }
2072 
2073     function downgradeToBasic(bytes32 democHash) only_editors() external {
2074         require(accounts[democHash].isPremium, "!premium");
2075         accounts[democHash].isPremium = false;
2076         // convert premium minutes to basic
2077         uint paidTill = accounts[democHash].paidUpTill;
2078         uint timeRemaining = SafeMath.subToZero(paidTill, now);
2079         // if we have time remaining: convert it
2080         if (timeRemaining > 0) {
2081             // prevent accounts from downgrading if they have time remaining
2082             // and upgraded less than 24hrs ago
2083             require(accounts[democHash].lastUpgradeTs < (now - 24 hours), "downgrade-too-soon");
2084             timeRemaining *= premiumMultiplier;
2085             accounts[democHash].paidUpTill = now + timeRemaining;
2086         }
2087         emit DowngradeToBasic(democHash);
2088     }
2089 
2090     function upgradeToPremium(bytes32 democHash) only_editors() external {
2091         require(denyPremium[democHash] == false, "upgrade-denied");
2092         require(!accounts[democHash].isPremium, "!basic");
2093         accounts[democHash].isPremium = true;
2094         // convert basic minutes to premium minutes
2095         uint paidTill = accounts[democHash].paidUpTill;
2096         uint timeRemaining = SafeMath.subToZero(paidTill, now);
2097         // if we have time remaning then convert it - otherwise don't need to do anything
2098         if (timeRemaining > 0) {
2099             timeRemaining /= premiumMultiplier;
2100             accounts[democHash].paidUpTill = now + timeRemaining;
2101         }
2102         accounts[democHash].lastUpgradeTs = now;
2103         emit UpgradedToPremium(democHash);
2104     }
2105 
2106     /* account status - getters */
2107 
2108     function accountInGoodStanding(bytes32 democHash) external view returns (bool) {
2109         return accounts[democHash].paidUpTill >= now;
2110     }
2111 
2112     function getSecondsRemaining(bytes32 democHash) external view returns (uint) {
2113         return SafeMath.subToZero(accounts[democHash].paidUpTill, now);
2114     }
2115 
2116     function getPremiumStatus(bytes32 democHash) external view returns (bool) {
2117         return accounts[democHash].isPremium;
2118     }
2119 
2120     function getFreeExtension(bytes32 democHash) external view returns (bool) {
2121         return freeExtension[democHash];
2122     }
2123 
2124     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension) {
2125         isPremium = accounts[democHash].isPremium;
2126         lastPaymentTs = accounts[democHash].lastPaymentTs;
2127         paidUpTill = accounts[democHash].paidUpTill;
2128         hasFreeExtension = freeExtension[democHash];
2129     }
2130 
2131     function getDenyPremium(bytes32 democHash) external view returns (bool) {
2132         return denyPremium[democHash];
2133     }
2134 
2135     /* admin utils for accounts */
2136 
2137     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) owner_or(minorEditsAddr) external {
2138         _modAccountBalance(democHash, additionalSeconds);
2139         payments.push(PaymentLog(true, democHash, additionalSeconds, 0));
2140         emit GrantedAccountTime(democHash, additionalSeconds, ref);
2141     }
2142 
2143     /* admin setters global */
2144 
2145     function setPayTo(address newPayTo) only_owner() external {
2146         _setPayTo(newPayTo);
2147         emit SetPayTo(newPayTo);
2148     }
2149 
2150     function setMinorEditsAddr(address a) only_owner() external {
2151         minorEditsAddr = a;
2152         emit SetMinorEditsAddr(a);
2153     }
2154 
2155     function setBasicCentsPricePer30Days(uint amount) only_owner() external {
2156         basicCentsPricePer30Days = amount;
2157         emit SetBasicCentsPricePer30Days(amount);
2158     }
2159 
2160     function setBasicBallotsPer30Days(uint amount) only_owner() external {
2161         basicBallotsPer30Days = amount;
2162         emit SetBallotsPer30Days(amount);
2163     }
2164 
2165     function setPremiumMultiplier(uint8 m) only_owner() external {
2166         premiumMultiplier = m;
2167         emit SetPremiumMultiplier(m);
2168     }
2169 
2170     function setWeiPerCent(uint wpc) owner_or(minorEditsAddr) external {
2171         weiPerCent = wpc;
2172         emit SetExchangeRate(wpc);
2173     }
2174 
2175     function setFreeExtension(bytes32 democHash, bool hasFreeExt) owner_or(minorEditsAddr) external {
2176         freeExtension[democHash] = hasFreeExt;
2177         emit SetFreeExtension(democHash, hasFreeExt);
2178     }
2179 
2180     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) owner_or(minorEditsAddr) external {
2181         denyPremium[democHash] = isPremiumDenied;
2182         emit SetDenyPremium(democHash, isPremiumDenied);
2183     }
2184 
2185     function setMinWeiForDInit(uint amount) owner_or(minorEditsAddr) external {
2186         minWeiForDInit = amount;
2187         emit SetMinWeiForDInit(amount);
2188     }
2189 
2190     /* global getters */
2191 
2192     function getBasicCentsPricePer30Days() external view returns (uint) {
2193         return basicCentsPricePer30Days;
2194     }
2195 
2196     function getBasicExtraBallotFeeWei() external view returns (uint) {
2197         return centsToWei(basicCentsPricePer30Days / basicBallotsPer30Days);
2198     }
2199 
2200     function getBasicBallotsPer30Days() external view returns (uint) {
2201         return basicBallotsPer30Days;
2202     }
2203 
2204     function getPremiumMultiplier() external view returns (uint8) {
2205         return premiumMultiplier;
2206     }
2207 
2208     function getPremiumCentsPricePer30Days() external view returns (uint) {
2209         return _premiumPricePer30Days();
2210     }
2211 
2212     function _premiumPricePer30Days() internal view returns (uint) {
2213         return uint(premiumMultiplier) * basicCentsPricePer30Days;
2214     }
2215 
2216     function getWeiPerCent() external view returns (uint) {
2217         return weiPerCent;
2218     }
2219 
2220     function getUsdEthExchangeRate() external view returns (uint) {
2221         // this returns cents per ether
2222         return 1 ether / weiPerCent;
2223     }
2224 
2225     function getMinWeiForDInit() external view returns (uint) {
2226         return minWeiForDInit;
2227     }
2228 
2229     /* payments stuff */
2230 
2231     function getPaymentLogN() external view returns (uint) {
2232         return payments.length;
2233     }
2234 
2235     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue) {
2236         _external = payments[n]._external;
2237         _democHash = payments[n]._democHash;
2238         _seconds = payments[n]._seconds;
2239         _ethValue = payments[n]._ethValue;
2240     }
2241 }
2242 
2243 interface SvEnsIface {
2244     // Logged when the owner of a node assigns a new owner to a subnode.
2245     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2246 
2247     // Logged when the owner of a node transfers ownership to a new account.
2248     event Transfer(bytes32 indexed node, address owner);
2249 
2250     // Logged when the resolver for a node changes.
2251     event NewResolver(bytes32 indexed node, address resolver);
2252 
2253     // Logged when the TTL of a node changes
2254     event NewTTL(bytes32 indexed node, uint64 ttl);
2255 
2256 
2257     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
2258     function setResolver(bytes32 node, address resolver) external;
2259     function setOwner(bytes32 node, address owner) external;
2260     function setTTL(bytes32 node, uint64 ttl) external;
2261     function owner(bytes32 node) external view returns (address);
2262     function resolver(bytes32 node) external view returns (address);
2263     function ttl(bytes32 node) external view returns (uint64);
2264 }
2265 
2266 interface ENSIface {
2267     // Logged when the owner of a node assigns a new owner to a subnode.
2268     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2269 
2270     // Logged when the owner of a node transfers ownership to a new account.
2271     event Transfer(bytes32 indexed node, address owner);
2272 
2273     // Logged when the resolver for a node changes.
2274     event NewResolver(bytes32 indexed node, address resolver);
2275 
2276     // Logged when the TTL of a node changes
2277     event NewTTL(bytes32 indexed node, uint64 ttl);
2278 
2279 
2280     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
2281     function setResolver(bytes32 node, address resolver) external;
2282     function setOwner(bytes32 node, address owner) external;
2283     function setTTL(bytes32 node, uint64 ttl) external;
2284     function owner(bytes32 node) external view returns (address);
2285     function resolver(bytes32 node) external view returns (address);
2286     function ttl(bytes32 node) external view returns (uint64);
2287 }
2288 
2289 contract PublicResolver {
2290 
2291     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
2292     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
2293     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
2294     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
2295     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
2296     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
2297     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
2298 
2299     event AddrChanged(bytes32 indexed node, address a);
2300     event ContentChanged(bytes32 indexed node, bytes32 hash);
2301     event NameChanged(bytes32 indexed node, string name);
2302     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
2303     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
2304     event TextChanged(bytes32 indexed node, string indexedKey, string key);
2305 
2306     struct PublicKey {
2307         bytes32 x;
2308         bytes32 y;
2309     }
2310 
2311     struct Record {
2312         address addr;
2313         bytes32 content;
2314         string name;
2315         PublicKey pubkey;
2316         mapping(string=>string) text;
2317         mapping(uint256=>bytes) abis;
2318     }
2319 
2320     ENSIface ens;
2321 
2322     mapping (bytes32 => Record) records;
2323 
2324     modifier only_owner(bytes32 node) {
2325         require(ens.owner(node) == msg.sender);
2326         _;
2327     }
2328 
2329     /**
2330      * Constructor.
2331      * @param ensAddr The ENS registrar contract.
2332      */
2333     constructor(ENSIface ensAddr) public {
2334         ens = ensAddr;
2335     }
2336 
2337     /**
2338      * Sets the address associated with an ENS node.
2339      * May only be called by the owner of that node in the ENS registry.
2340      * @param node The node to update.
2341      * @param addr The address to set.
2342      */
2343     function setAddr(bytes32 node, address addr) public only_owner(node) {
2344         records[node].addr = addr;
2345         emit AddrChanged(node, addr);
2346     }
2347 
2348     /**
2349      * Sets the content hash associated with an ENS node.
2350      * May only be called by the owner of that node in the ENS registry.
2351      * Note that this resource type is not standardized, and will likely change
2352      * in future to a resource type based on multihash.
2353      * @param node The node to update.
2354      * @param hash The content hash to set
2355      */
2356     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
2357         records[node].content = hash;
2358         emit ContentChanged(node, hash);
2359     }
2360 
2361     /**
2362      * Sets the name associated with an ENS node, for reverse records.
2363      * May only be called by the owner of that node in the ENS registry.
2364      * @param node The node to update.
2365      * @param name The name to set.
2366      */
2367     function setName(bytes32 node, string name) public only_owner(node) {
2368         records[node].name = name;
2369         emit NameChanged(node, name);
2370     }
2371 
2372     /**
2373      * Sets the ABI associated with an ENS node.
2374      * Nodes may have one ABI of each content type. To remove an ABI, set it to
2375      * the empty string.
2376      * @param node The node to update.
2377      * @param contentType The content type of the ABI
2378      * @param data The ABI data.
2379      */
2380     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
2381         // Content types must be powers of 2
2382         require(((contentType - 1) & contentType) == 0);
2383 
2384         records[node].abis[contentType] = data;
2385         emit ABIChanged(node, contentType);
2386     }
2387 
2388     /**
2389      * Sets the SECP256k1 public key associated with an ENS node.
2390      * @param node The ENS node to query
2391      * @param x the X coordinate of the curve point for the public key.
2392      * @param y the Y coordinate of the curve point for the public key.
2393      */
2394     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
2395         records[node].pubkey = PublicKey(x, y);
2396         emit PubkeyChanged(node, x, y);
2397     }
2398 
2399     /**
2400      * Sets the text data associated with an ENS node and key.
2401      * May only be called by the owner of that node in the ENS registry.
2402      * @param node The node to update.
2403      * @param key The key to set.
2404      * @param value The text data value to set.
2405      */
2406     function setText(bytes32 node, string key, string value) public only_owner(node) {
2407         records[node].text[key] = value;
2408         emit TextChanged(node, key, key);
2409     }
2410 
2411     /**
2412      * Returns the text data associated with an ENS node and key.
2413      * @param node The ENS node to query.
2414      * @param key The text data key to query.
2415      * @return The associated text data.
2416      */
2417     function text(bytes32 node, string key) public view returns (string) {
2418         return records[node].text[key];
2419     }
2420 
2421     /**
2422      * Returns the SECP256k1 public key associated with an ENS node.
2423      * Defined in EIP 619.
2424      * @param node The ENS node to query
2425      * @return x, y the X and Y coordinates of the curve point for the public key.
2426      */
2427     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
2428         return (records[node].pubkey.x, records[node].pubkey.y);
2429     }
2430 
2431     /**
2432      * Returns the ABI associated with an ENS node.
2433      * Defined in EIP205.
2434      * @param node The ENS node to query
2435      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
2436      * @return contentType The content type of the return value
2437      * @return data The ABI data
2438      */
2439     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
2440         Record storage record = records[node];
2441         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
2442             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
2443                 data = record.abis[contentType];
2444                 return;
2445             }
2446         }
2447         contentType = 0;
2448     }
2449 
2450     /**
2451      * Returns the name associated with an ENS node, for reverse records.
2452      * Defined in EIP181.
2453      * @param node The ENS node to query.
2454      * @return The associated name.
2455      */
2456     function name(bytes32 node) public view returns (string) {
2457         return records[node].name;
2458     }
2459 
2460     /**
2461      * Returns the content hash associated with an ENS node.
2462      * Note that this resource type is not standardized, and will likely change
2463      * in future to a resource type based on multihash.
2464      * @param node The ENS node to query.
2465      * @return The associated content hash.
2466      */
2467     function content(bytes32 node) public view returns (bytes32) {
2468         return records[node].content;
2469     }
2470 
2471     /**
2472      * Returns the address associated with an ENS node.
2473      * @param node The ENS node to query.
2474      * @return The associated address.
2475      */
2476     function addr(bytes32 node) public view returns (address) {
2477         return records[node].addr;
2478     }
2479 
2480     /**
2481      * Returns true if the resolver implements the interface specified by the provided hash.
2482      * @param interfaceID The ID of the interface to check for.
2483      * @return True if the contract implements the requested interface.
2484      */
2485     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
2486         return interfaceID == ADDR_INTERFACE_ID ||
2487         interfaceID == CONTENT_INTERFACE_ID ||
2488         interfaceID == NAME_INTERFACE_ID ||
2489         interfaceID == ABI_INTERFACE_ID ||
2490         interfaceID == PUBKEY_INTERFACE_ID ||
2491         interfaceID == TEXT_INTERFACE_ID ||
2492         interfaceID == INTERFACE_META_ID;
2493     }
2494 }
2495 
2496 library BytesLib {
2497     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
2498         bytes memory tempBytes;
2499 
2500         assembly {
2501             // Get a location of some free memory and store it in tempBytes as
2502             // Solidity does for memory variables.
2503             tempBytes := mload(0x40)
2504 
2505             // Store the length of the first bytes array at the beginning of
2506             // the memory for tempBytes.
2507             let length := mload(_preBytes)
2508             mstore(tempBytes, length)
2509 
2510             // Maintain a memory counter for the current write location in the
2511             // temp bytes array by adding the 32 bytes for the array length to
2512             // the starting location.
2513             let mc := add(tempBytes, 0x20)
2514             // Stop copying when the memory counter reaches the length of the
2515             // first bytes array.
2516             let end := add(mc, length)
2517 
2518             for {
2519                 // Initialize a copy counter to the start of the _preBytes data,
2520                 // 32 bytes into its memory.
2521                 let cc := add(_preBytes, 0x20)
2522             } lt(mc, end) {
2523                 // Increase both counters by 32 bytes each iteration.
2524                 mc := add(mc, 0x20)
2525                 cc := add(cc, 0x20)
2526             } {
2527                 // Write the _preBytes data into the tempBytes memory 32 bytes
2528                 // at a time.
2529                 mstore(mc, mload(cc))
2530             }
2531 
2532             // Add the length of _postBytes to the current length of tempBytes
2533             // and store it as the new length in the first 32 bytes of the
2534             // tempBytes memory.
2535             length := mload(_postBytes)
2536             mstore(tempBytes, add(length, mload(tempBytes)))
2537 
2538             // Move the memory counter back from a multiple of 0x20 to the
2539             // actual end of the _preBytes data.
2540             mc := end
2541             // Stop copying when the memory counter reaches the new combined
2542             // length of the arrays.
2543             end := add(mc, length)
2544 
2545             for {
2546                 let cc := add(_postBytes, 0x20)
2547             } lt(mc, end) {
2548                 mc := add(mc, 0x20)
2549                 cc := add(cc, 0x20)
2550             } {
2551                 mstore(mc, mload(cc))
2552             }
2553 
2554             // Update the free-memory pointer by padding our last write location
2555             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
2556             // next 32 byte block, then round down to the nearest multiple of
2557             // 32. If the sum of the length of the two arrays is zero then add
2558             // one before rounding down to leave a blank 32 bytes (the length block with 0).
2559             mstore(0x40, and(
2560               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
2561               not(31) // Round down to the nearest 32 bytes.
2562             ))
2563         }
2564 
2565         return tempBytes;
2566     }
2567 
2568     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
2569         assembly {
2570             // Read the first 32 bytes of _preBytes storage, which is the length
2571             // of the array. (We don't need to use the offset into the slot
2572             // because arrays use the entire slot.)
2573             let fslot := sload(_preBytes_slot)
2574             // Arrays of 31 bytes or less have an even value in their slot,
2575             // while longer arrays have an odd value. The actual length is
2576             // the slot divided by two for odd values, and the lowest order
2577             // byte divided by two for even values.
2578             // If the slot is even, bitwise and the slot with 255 and divide by
2579             // two to get the length. If the slot is odd, bitwise and the slot
2580             // with -1 and divide by two.
2581             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
2582             let mlength := mload(_postBytes)
2583             let newlength := add(slength, mlength)
2584             // slength can contain both the length and contents of the array
2585             // if length < 32 bytes so let's prepare for that
2586             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
2587             switch add(lt(slength, 32), lt(newlength, 32))
2588             case 2 {
2589                 // Since the new array still fits in the slot, we just need to
2590                 // update the contents of the slot.
2591                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
2592                 sstore(
2593                     _preBytes_slot,
2594                     // all the modifications to the slot are inside this
2595                     // next block
2596                     add(
2597                         // we can just add to the slot contents because the
2598                         // bytes we want to change are the LSBs
2599                         fslot,
2600                         add(
2601                             mul(
2602                                 div(
2603                                     // load the bytes from memory
2604                                     mload(add(_postBytes, 0x20)),
2605                                     // zero all bytes to the right
2606                                     exp(0x100, sub(32, mlength))
2607                                 ),
2608                                 // and now shift left the number of bytes to
2609                                 // leave space for the length in the slot
2610                                 exp(0x100, sub(32, newlength))
2611                             ),
2612                             // increase length by the double of the memory
2613                             // bytes length
2614                             mul(mlength, 2)
2615                         )
2616                     )
2617                 )
2618             }
2619             case 1 {
2620                 // The stored value fits in the slot, but the combined value
2621                 // will exceed it.
2622                 // get the keccak hash to get the contents of the array
2623                 mstore(0x0, _preBytes_slot)
2624                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
2625 
2626                 // save new length
2627                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
2628 
2629                 // The contents of the _postBytes array start 32 bytes into
2630                 // the structure. Our first read should obtain the `submod`
2631                 // bytes that can fit into the unused space in the last word
2632                 // of the stored array. To get this, we read 32 bytes starting
2633                 // from `submod`, so the data we read overlaps with the array
2634                 // contents by `submod` bytes. Masking the lowest-order
2635                 // `submod` bytes allows us to add that value directly to the
2636                 // stored value.
2637 
2638                 let submod := sub(32, slength)
2639                 let mc := add(_postBytes, submod)
2640                 let end := add(_postBytes, mlength)
2641                 let mask := sub(exp(0x100, submod), 1)
2642 
2643                 sstore(
2644                     sc,
2645                     add(
2646                         and(
2647                             fslot,
2648                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
2649                         ),
2650                         and(mload(mc), mask)
2651                     )
2652                 )
2653 
2654                 for {
2655                     mc := add(mc, 0x20)
2656                     sc := add(sc, 1)
2657                 } lt(mc, end) {
2658                     sc := add(sc, 1)
2659                     mc := add(mc, 0x20)
2660                 } {
2661                     sstore(sc, mload(mc))
2662                 }
2663 
2664                 mask := exp(0x100, sub(mc, end))
2665 
2666                 sstore(sc, mul(div(mload(mc), mask), mask))
2667             }
2668             default {
2669                 // get the keccak hash to get the contents of the array
2670                 mstore(0x0, _preBytes_slot)
2671                 // Start copying to the last used word of the stored array.
2672                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
2673 
2674                 // save new length
2675                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
2676 
2677                 // Copy over the first `submod` bytes of the new data as in
2678                 // case 1 above.
2679                 let slengthmod := mod(slength, 32)
2680                 let mlengthmod := mod(mlength, 32)
2681                 let submod := sub(32, slengthmod)
2682                 let mc := add(_postBytes, submod)
2683                 let end := add(_postBytes, mlength)
2684                 let mask := sub(exp(0x100, submod), 1)
2685 
2686                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
2687 
2688                 for {
2689                     sc := add(sc, 1)
2690                     mc := add(mc, 0x20)
2691                 } lt(mc, end) {
2692                     sc := add(sc, 1)
2693                     mc := add(mc, 0x20)
2694                 } {
2695                     sstore(sc, mload(mc))
2696                 }
2697 
2698                 mask := exp(0x100, sub(mc, end))
2699 
2700                 sstore(sc, mul(div(mload(mc), mask), mask))
2701             }
2702         }
2703     }
2704 
2705     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
2706         require(_bytes.length >= (_start + _length));
2707 
2708         bytes memory tempBytes;
2709 
2710         assembly {
2711             switch iszero(_length)
2712             case 0 {
2713                 // Get a location of some free memory and store it in tempBytes as
2714                 // Solidity does for memory variables.
2715                 tempBytes := mload(0x40)
2716 
2717                 // The first word of the slice result is potentially a partial
2718                 // word read from the original array. To read it, we calculate
2719                 // the length of that partial word and start copying that many
2720                 // bytes into the array. The first word we copy will start with
2721                 // data we don't care about, but the last `lengthmod` bytes will
2722                 // land at the beginning of the contents of the new array. When
2723                 // we're done copying, we overwrite the full first word with
2724                 // the actual length of the slice.
2725                 let lengthmod := and(_length, 31)
2726 
2727                 // The multiplication in the next line is necessary
2728                 // because when slicing multiples of 32 bytes (lengthmod == 0)
2729                 // the following copy loop was copying the origin's length
2730                 // and then ending prematurely not copying everything it should.
2731                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
2732                 let end := add(mc, _length)
2733 
2734                 for {
2735                     // The multiplication in the next line has the same exact purpose
2736                     // as the one above.
2737                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
2738                 } lt(mc, end) {
2739                     mc := add(mc, 0x20)
2740                     cc := add(cc, 0x20)
2741                 } {
2742                     mstore(mc, mload(cc))
2743                 }
2744 
2745                 mstore(tempBytes, _length)
2746 
2747                 //update free-memory pointer
2748                 //allocating the array padded to 32 bytes like the compiler does now
2749                 mstore(0x40, and(add(mc, 31), not(31)))
2750             }
2751             //if we want a zero-length slice let's just return a zero-length array
2752             default {
2753                 tempBytes := mload(0x40)
2754 
2755                 mstore(0x40, add(tempBytes, 0x20))
2756             }
2757         }
2758 
2759         return tempBytes;
2760     }
2761 
2762     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
2763         require(_bytes.length >= (_start + 20));
2764         address tempAddress;
2765 
2766         assembly {
2767             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
2768         }
2769 
2770         return tempAddress;
2771     }
2772 
2773     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
2774         require(_bytes.length >= (_start + 32));
2775         uint256 tempUint;
2776 
2777         assembly {
2778             tempUint := mload(add(add(_bytes, 0x20), _start))
2779         }
2780 
2781         return tempUint;
2782     }
2783 
2784     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
2785         bool success = true;
2786 
2787         assembly {
2788             let length := mload(_preBytes)
2789 
2790             // if lengths don't match the arrays are not equal
2791             switch eq(length, mload(_postBytes))
2792             case 1 {
2793                 // cb is a circuit breaker in the for loop since there's
2794                 //  no said feature for inline assembly loops
2795                 // cb = 1 - don't breaker
2796                 // cb = 0 - break
2797                 let cb := 1
2798 
2799                 let mc := add(_preBytes, 0x20)
2800                 let end := add(mc, length)
2801 
2802                 for {
2803                     let cc := add(_postBytes, 0x20)
2804                 // the next line is the loop condition:
2805                 // while(uint(mc < end) + cb == 2)
2806                 } eq(add(lt(mc, end), cb), 2) {
2807                     mc := add(mc, 0x20)
2808                     cc := add(cc, 0x20)
2809                 } {
2810                     // if any of these checks fails then arrays are not equal
2811                     if iszero(eq(mload(mc), mload(cc))) {
2812                         // unsuccess:
2813                         success := 0
2814                         cb := 0
2815                     }
2816                 }
2817             }
2818             default {
2819                 // unsuccess:
2820                 success := 0
2821             }
2822         }
2823 
2824         return success;
2825     }
2826 
2827     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
2828         bool success = true;
2829 
2830         assembly {
2831             // we know _preBytes_offset is 0
2832             let fslot := sload(_preBytes_slot)
2833             // Decode the length of the stored array like in concatStorage().
2834             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
2835             let mlength := mload(_postBytes)
2836 
2837             // if lengths don't match the arrays are not equal
2838             switch eq(slength, mlength)
2839             case 1 {
2840                 // slength can contain both the length and contents of the array
2841                 // if length < 32 bytes so let's prepare for that
2842                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
2843                 if iszero(iszero(slength)) {
2844                     switch lt(slength, 32)
2845                     case 1 {
2846                         // blank the last byte which is the length
2847                         fslot := mul(div(fslot, 0x100), 0x100)
2848 
2849                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
2850                             // unsuccess:
2851                             success := 0
2852                         }
2853                     }
2854                     default {
2855                         // cb is a circuit breaker in the for loop since there's
2856                         //  no said feature for inline assembly loops
2857                         // cb = 1 - don't breaker
2858                         // cb = 0 - break
2859                         let cb := 1
2860 
2861                         // get the keccak hash to get the contents of the array
2862                         mstore(0x0, _preBytes_slot)
2863                         let sc := keccak256(0x0, 0x20)
2864 
2865                         let mc := add(_postBytes, 0x20)
2866                         let end := add(mc, mlength)
2867 
2868                         // the next line is the loop condition:
2869                         // while(uint(mc < end) + cb == 2)
2870                         for {} eq(add(lt(mc, end), cb), 2) {
2871                             sc := add(sc, 1)
2872                             mc := add(mc, 0x20)
2873                         } {
2874                             if iszero(eq(sload(sc), mload(mc))) {
2875                                 // unsuccess:
2876                                 success := 0
2877                                 cb := 0
2878                             }
2879                         }
2880                     }
2881                 }
2882             }
2883             default {
2884                 // unsuccess:
2885                 success := 0
2886             }
2887         }
2888 
2889         return success;
2890     }
2891 }