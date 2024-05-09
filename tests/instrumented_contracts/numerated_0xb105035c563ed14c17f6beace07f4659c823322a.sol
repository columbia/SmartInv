1 pragma solidity 0.4.24;
2 
3 contract BBFarmEvents {
4     event BallotCreatedWithID(uint ballotId);
5     event BBFarmInit(bytes4 namespace);
6     event Sponsorship(uint ballotId, uint value);
7     event Vote(uint indexed ballotId, bytes32 vote, address voter, bytes extra);
8 }
9 
10 library BBLib {
11     using BytesLib for bytes;
12 
13     // ballot meta
14     uint256 constant BB_VERSION = 6;
15     /* 4 deprecated due to insecure vote by proxy
16        5 deprecated to
17         - add `returns (address)` to submitProxyVote
18     */
19 
20     // voting settings
21     uint16 constant USE_ETH = 1;          // 2^0
22     uint16 constant USE_SIGNED = 2;       // 2^1
23     uint16 constant USE_NO_ENC = 4;       // 2^2
24     uint16 constant USE_ENC = 8;          // 2^3
25 
26     // ballot settings
27     uint16 constant IS_BINDING = 8192;    // 2^13
28     uint16 constant IS_OFFICIAL = 16384;  // 2^14
29     uint16 constant USE_TESTING = 32768;  // 2^15
30 
31     // other consts
32     uint32 constant MAX_UINT32 = 0xFFFFFFFF;
33 
34     //// ** Storage Variables
35 
36     // struct for ballot
37     struct Vote {
38         bytes32 voteData;
39         bytes32 castTsAndSender;
40         bytes extra;
41     }
42 
43     struct Sponsor {
44         address sender;
45         uint amount;
46     }
47 
48     //// ** Events
49     event CreatedBallot(bytes32 _specHash, uint64 startTs, uint64 endTs, uint16 submissionBits);
50     event SuccessfulVote(address indexed voter, uint voteId);
51     event SeckeyRevealed(bytes32 secretKey);
52     event TestingEnabled();
53     event DeprecatedContract();
54 
55 
56     // The big database struct
57 
58 
59     struct DB {
60         // Maps to store ballots, along with corresponding log of voters.
61         // Should only be modified through internal functions
62         mapping (uint256 => Vote) votes;
63         uint256 nVotesCast;
64 
65         // we need replay protection for proxy ballots - this will let us check against a sequence number
66         // note: votes directly from a user ALWAYS take priority b/c they do not have sequence numbers
67         // (sequencing is done by Ethereum itself via the tx nonce).
68         mapping (address => uint32) sequenceNumber;
69 
70         // NOTE - We don't actually want to include the encryption PublicKey because _it's included in the ballotSpec_.
71         // It's better to ensure ppl actually have the ballot spec by not including it in the contract.
72         // Plus we're already storing the hash of the ballotSpec anyway...
73 
74         // Private key to be set after ballot conclusion - curve25519
75         bytes32 ballotEncryptionSeckey;
76 
77         // packed contains:
78         // 1. Timestamps for start and end of ballot (UTC)
79         // 2. bits used to decide which options are enabled or disabled for submission of ballots
80         uint256 packed;
81 
82         // specHash by which to validate the ballots integrity
83         bytes32 specHash;
84         // extradata if we need it - allows us to upgrade spechash format, etc
85         bytes16 extraData;
86 
87         // allow tracking of sponsorship for this ballot & connection to index
88         Sponsor[] sponsors;
89         IxIface index;
90 
91         // deprecation flag - doesn't actually do anything besides signal that this contract is deprecated;
92         bool deprecated;
93 
94         address ballotOwner;
95         uint256 creationTs;
96     }
97 
98 
99     // ** Modifiers -- note, these are functions here to allow use as a lib
100     function requireBallotClosed(DB storage db) internal view {
101         require(now > BPackedUtils.packedToEndTime(db.packed), "!b-closed");
102     }
103 
104     function requireBallotOpen(DB storage db) internal view {
105         uint64 _n = uint64(now);
106         uint64 startTs;
107         uint64 endTs;
108         (, startTs, endTs) = BPackedUtils.unpackAll(db.packed);
109         require(_n >= startTs && _n < endTs, "!b-open");
110         require(db.deprecated == false, "b-deprecated");
111     }
112 
113     function requireBallotOwner(DB storage db) internal view {
114         require(msg.sender == db.ballotOwner, "!b-owner");
115     }
116 
117     function requireTesting(DB storage db) internal view {
118         require(isTesting(BPackedUtils.packedToSubmissionBits(db.packed)), "!testing");
119     }
120 
121     /* Library meta */
122 
123     function getVersion() external pure returns (uint) {
124         // even though this is constant we want to make sure that it's actually
125         // callable on Ethereum so we don't accidentally package the constant code
126         // in with an SC using BBLib. This function _must_ be external.
127         return BB_VERSION;
128     }
129 
130     /* Functions */
131 
132     // "Constructor" function - init core params on deploy
133     // timestampts are uint64s to give us plenty of room for millennia
134     function init(DB storage db, bytes32 _specHash, uint256 _packed, IxIface ix, address ballotOwner, bytes16 extraData) external {
135         require(db.specHash == bytes32(0), "b-exists");
136 
137         db.index = ix;
138         db.ballotOwner = ballotOwner;
139 
140         uint64 startTs;
141         uint64 endTs;
142         uint16 sb;
143         (sb, startTs, endTs) = BPackedUtils.unpackAll(_packed);
144 
145         bool _testing = isTesting(sb);
146         if (_testing) {
147             emit TestingEnabled();
148         } else {
149             require(endTs > now, "bad-end-time");
150 
151             // 0x1ff2 is 0001111111110010 in binary
152             // by ANDing with subBits we make sure that only bits in positions 0,2,3,13,14,15
153             // can be used. these correspond to the option flags at the top, and ETH ballots
154             // that are enc'd or plaintext.
155             require(sb & 0x1ff2 == 0, "bad-sb");
156 
157             // if we give bad submission bits (e.g. all 0s) then refuse to deploy ballot
158             bool okaySubmissionBits = 1 == (isEthNoEnc(sb) ? 1 : 0) + (isEthWithEnc(sb) ? 1 : 0);
159             require(okaySubmissionBits, "!valid-sb");
160 
161             // take the max of the start time provided and the blocks timestamp to avoid a DoS against recent token holders
162             // (which someone might be able to do if they could set the timestamp in the past)
163             startTs = startTs > now ? startTs : uint64(now);
164         }
165         require(_specHash != bytes32(0), "null-specHash");
166         db.specHash = _specHash;
167 
168         db.packed = BPackedUtils.pack(sb, startTs, endTs);
169         db.creationTs = now;
170 
171         if (extraData != bytes16(0)) {
172             db.extraData = extraData;
173         }
174 
175         emit CreatedBallot(db.specHash, startTs, endTs, sb);
176     }
177 
178     /* sponsorship */
179 
180     function logSponsorship(DB storage db, uint value) internal {
181         db.sponsors.push(Sponsor(msg.sender, value));
182     }
183 
184     /* getters */
185 
186     function getVote(DB storage db, uint id) internal view returns (bytes32 voteData, address sender, bytes extra, uint castTs) {
187         return (db.votes[id].voteData, address(db.votes[id].castTsAndSender), db.votes[id].extra, uint(db.votes[id].castTsAndSender) >> 160);
188     }
189 
190     function getSequenceNumber(DB storage db, address voter) internal view returns (uint32) {
191         return db.sequenceNumber[voter];
192     }
193 
194     function getTotalSponsorship(DB storage db) internal view returns (uint total) {
195         for (uint i = 0; i < db.sponsors.length; i++) {
196             total += db.sponsors[i].amount;
197         }
198     }
199 
200     function getSponsor(DB storage db, uint i) external view returns (address sender, uint amount) {
201         sender = db.sponsors[i].sender;
202         amount = db.sponsors[i].amount;
203     }
204 
205     /* ETH BALLOTS */
206 
207     // Ballot submission
208     // note: if USE_ENC then curve25519 keys should be generated for
209     // each ballot (then thrown away).
210     // the curve25519 PKs go in the extra param
211     function submitVote(DB storage db, bytes32 voteData, bytes extra) external {
212         _addVote(db, voteData, msg.sender, extra);
213         // set the sequence number to max uint32 to disable proxy submitted ballots
214         // after a voter submits a transaction personally - effectivley disables proxy
215         // ballots. You can _always_ submit a new vote _personally_ with this scheme.
216         if (db.sequenceNumber[msg.sender] != MAX_UINT32) {
217             // using an IF statement here let's us save 4800 gas on repeat votes at the cost of 20k extra gas initially
218             db.sequenceNumber[msg.sender] = MAX_UINT32;
219         }
220     }
221 
222     // Boundaries for constructing the msg we'll validate the signature of
223     function submitProxyVote(DB storage db, bytes32[5] proxyReq, bytes extra) external returns (address voter) {
224         // a proxy vote (where the vote is submitted (i.e. tx fee paid by someone else)
225         // docs for datastructs: https://github.com/secure-vote/tokenvote/blob/master/Docs/DataStructs.md
226 
227         bytes32 r = proxyReq[0];
228         bytes32 s = proxyReq[1];
229         uint8 v = uint8(proxyReq[2][0]);
230         // converting to uint248 will truncate the first byte, and we can then convert it to a bytes31.
231         // we truncate the first byte because it's the `v` parm used above
232         bytes31 proxyReq2 = bytes31(uint248(proxyReq[2]));
233         // proxyReq[3] is ballotId - required for verifying sig but not used for anything else
234         bytes32 ballotId = proxyReq[3];
235         bytes32 voteData = proxyReq[4];
236 
237         // using abi.encodePacked is much cheaper than making bytes in other ways...
238         bytes memory signed = abi.encodePacked(proxyReq2, ballotId, voteData, extra);
239         bytes32 msgHash = keccak256(signed);
240         // need to be sure we are signing the entire ballot and any extra data that comes with it
241         voter = ecrecover(msgHash, v, r, s);
242 
243         // we need to make sure that this is the most recent vote the voter made, and that it has
244         // not been seen before. NOTE: we've already validated the BBFarm namespace before this, so
245         // we know it's meant for _this_ ballot.
246         uint32 sequence = uint32(proxyReq2);  // last 4 bytes of proxyReq2 - the sequence number
247         _proxyReplayProtection(db, voter, sequence);
248 
249         _addVote(db, voteData, voter, extra);
250     }
251 
252     function _addVote(DB storage db, bytes32 voteData, address sender, bytes extra) internal returns (uint256 id) {
253         requireBallotOpen(db);
254 
255         id = db.nVotesCast;
256         db.votes[id].voteData = voteData;
257         // pack the casting ts right next to the sender
258         db.votes[id].castTsAndSender = bytes32(sender) ^ bytes32(now << 160);
259         if (extra.length > 0) {
260             db.votes[id].extra = extra;
261         }
262         db.nVotesCast += 1;
263         emit SuccessfulVote(sender, id);
264     }
265 
266     function _proxyReplayProtection(DB storage db, address voter, uint32 sequence) internal {
267         // we want the replay protection sequence number to be STRICTLY MORE than what
268         // is stored in the mapping. This means we can set sequence to MAX_UINT32 to disable
269         // any future votes.
270         require(db.sequenceNumber[voter] < sequence, "bad-sequence-n");
271         db.sequenceNumber[voter] = sequence;
272     }
273 
274     /* Admin */
275 
276     function setEndTime(DB storage db, uint64 newEndTime) external {
277         uint16 sb;
278         uint64 sTs;
279         (sb, sTs,) = BPackedUtils.unpackAll(db.packed);
280         db.packed = BPackedUtils.pack(sb, sTs, newEndTime);
281     }
282 
283     function revealSeckey(DB storage db, bytes32 sk) internal {
284         db.ballotEncryptionSeckey = sk;
285         emit SeckeyRevealed(sk);
286     }
287 
288     /* Submission Bits (Ballot Classifications) */
289 
290     // do (bits & SETTINGS_MASK) to get just operational bits (as opposed to testing or official flag)
291     uint16 constant SETTINGS_MASK = 0xFFFF ^ USE_TESTING ^ IS_OFFICIAL ^ IS_BINDING;
292 
293     function isEthNoEnc(uint16 submissionBits) pure internal returns (bool) {
294         return checkFlags(submissionBits, USE_ETH | USE_NO_ENC);
295     }
296 
297     function isEthWithEnc(uint16 submissionBits) pure internal returns (bool) {
298         return checkFlags(submissionBits, USE_ETH | USE_ENC);
299     }
300 
301     function isOfficial(uint16 submissionBits) pure internal returns (bool) {
302         return (submissionBits & IS_OFFICIAL) == IS_OFFICIAL;
303     }
304 
305     function isBinding(uint16 submissionBits) pure internal returns (bool) {
306         return (submissionBits & IS_BINDING) == IS_BINDING;
307     }
308 
309     function isTesting(uint16 submissionBits) pure internal returns (bool) {
310         return (submissionBits & USE_TESTING) == USE_TESTING;
311     }
312 
313     function qualifiesAsCommunityBallot(uint16 submissionBits) pure internal returns (bool) {
314         // if submissionBits AND any of the bits that make this _not_ a community
315         // ballot is equal to zero that means none of those bits were active, so
316         // it could be a community ballot
317         return (submissionBits & (IS_BINDING | IS_OFFICIAL | USE_ENC)) == 0;
318     }
319 
320     function checkFlags(uint16 submissionBits, uint16 expected) pure internal returns (bool) {
321         // this should ignore ONLY the testing/flag bits - all other bits are significant
322         uint16 sBitsNoSettings = submissionBits & SETTINGS_MASK;
323         // then we want ONLY expected
324         return sBitsNoSettings == expected;
325     }
326 }
327 
328 library BPackedUtils {
329 
330     // the uint16 ending at 128 bits should be 0s
331     uint256 constant sbMask        = 0xffffffffffffffffffffffffffff0000ffffffffffffffffffffffffffffffff;
332     uint256 constant startTimeMask = 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff;
333     uint256 constant endTimeMask   = 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
334 
335     function packedToSubmissionBits(uint256 packed) internal pure returns (uint16) {
336         return uint16(packed >> 128);
337     }
338 
339     function packedToStartTime(uint256 packed) internal pure returns (uint64) {
340         return uint64(packed >> 64);
341     }
342 
343     function packedToEndTime(uint256 packed) internal pure returns (uint64) {
344         return uint64(packed);
345     }
346 
347     function unpackAll(uint256 packed) internal pure returns (uint16 submissionBits, uint64 startTime, uint64 endTime) {
348         submissionBits = uint16(packed >> 128);
349         startTime = uint64(packed >> 64);
350         endTime = uint64(packed);
351     }
352 
353     function pack(uint16 sb, uint64 st, uint64 et) internal pure returns (uint256 packed) {
354         return uint256(sb) << 128 | uint256(st) << 64 | uint256(et);
355     }
356 
357     function setSB(uint256 packed, uint16 newSB) internal pure returns (uint256) {
358         return (packed & sbMask) | uint256(newSB) << 128;
359     }
360 
361     // function setStartTime(uint256 packed, uint64 startTime) internal pure returns (uint256) {
362     //     return (packed & startTimeMask) | uint256(startTime) << 64;
363     // }
364 
365     // function setEndTime(uint256 packed, uint64 endTime) internal pure returns (uint256) {
366     //     return (packed & endTimeMask) | uint256(endTime);
367     // }
368 }
369 
370 interface CommAuctionIface {
371     function getNextPrice(bytes32 democHash) external view returns (uint);
372     function noteBallotDeployed(bytes32 democHash) external;
373 
374     // add more when we need it
375 
376     function upgradeMe(address newSC) external;
377 }
378 
379 library IxLib {
380     /**
381      * Usage: `using IxLib for IxIface`
382      * The idea is to (instead of adding methods that already use
383      * available public info to the index) we can create `internal`
384      * methods in the lib to do this instead (which means the code
385      * is inserted into other contracts inline, without a `delegatecall`.
386      *
387      * For this reason it's crucial to have no methods in IxLib with the
388      * same name as methods in IxIface
389      */
390 
391     /* Global price and payments data */
392 
393     function getPayTo(IxIface ix) internal view returns (address) {
394         return ix.getPayments().getPayTo();
395     }
396 
397     /* Global Ix data */
398 
399     function getBBFarmFromBallotID(IxIface ix, uint256 ballotId) internal view returns (BBFarmIface) {
400         bytes4 bbNamespace = bytes4(ballotId >> 48);
401         uint8 bbFarmId = ix.getBBFarmID(bbNamespace);
402         return ix.getBBFarm(bbFarmId);
403     }
404 
405     /* Global backend data */
406 
407     function getGDemocsN(IxIface ix) internal view returns (uint256) {
408         return ix.getBackend().getGDemocsN();
409     }
410 
411     function getGDemoc(IxIface ix, uint256 n) internal view returns (bytes32) {
412         return ix.getBackend().getGDemoc(n);
413     }
414 
415     function getGErc20ToDemocs(IxIface ix, address erc20) internal view returns (bytes32[] democHashes) {
416         return ix.getBackend().getGErc20ToDemocs(erc20);
417     }
418 
419     /* Democ specific payment/account data */
420 
421     function accountInGoodStanding(IxIface ix, bytes32 democHash) internal view returns (bool) {
422         return ix.getPayments().accountInGoodStanding(democHash);
423     }
424 
425     function accountPremiumAndInGoodStanding(IxIface ix, bytes32 democHash) internal view returns (bool) {
426         IxPaymentsIface payments = ix.getPayments();
427         return payments.accountInGoodStanding(democHash) && payments.getPremiumStatus(democHash);
428     }
429 
430     function payForDemocracy(IxIface ix, bytes32 democHash) internal {
431         ix.getPayments().payForDemocracy.value(msg.value)(democHash);
432     }
433 
434     /* Democ getters */
435 
436     function getDOwner(IxIface ix, bytes32 democHash) internal view returns (address) {
437         return ix.getBackend().getDOwner(democHash);
438     }
439 
440     function isDEditor(IxIface ix, bytes32 democHash, address editor) internal view returns (bool) {
441         return ix.getBackend().isDEditor(democHash, editor);
442     }
443 
444     function getDBallotsN(IxIface ix, bytes32 democHash) internal view returns (uint256) {
445         return ix.getBackend().getDBallotsN(democHash);
446     }
447 
448     function getDBallotID(IxIface ix, bytes32 democHash, uint256 n) internal view returns (uint256) {
449         return ix.getBackend().getDBallotID(democHash, n);
450     }
451 
452     function getDInfo(IxIface ix, bytes32 democHash) internal view returns (address erc20, address admin, uint256 _nBallots) {
453         return ix.getBackend().getDInfo(democHash);
454     }
455 
456     function getDErc20(IxIface ix, bytes32 democHash) internal view returns (address erc20) {
457         return ix.getBackend().getDErc20(democHash);
458     }
459 
460     function getDHash(IxIface ix, bytes13 prefix) internal view returns (bytes32) {
461         return ix.getBackend().getDHash(prefix);
462     }
463 
464     function getDCategoriesN(IxIface ix, bytes32 democHash) internal view returns (uint) {
465         return ix.getBackend().getDCategoriesN(democHash);
466     }
467 
468     function getDCategory(IxIface ix, bytes32 democHash, uint categoryId) internal view returns (bool, bytes32, bool, uint) {
469         return ix.getBackend().getDCategory(democHash, categoryId);
470     }
471 
472     function getDArbitraryData(IxIface ix, bytes32 democHash, bytes key) external view returns (bytes) {
473         return ix.getBackend().getDArbitraryData(democHash, key);
474     }
475 }
476 
477 contract SVBallotConsts {
478     // voting settings
479     uint16 constant USE_ETH = 1;          // 2^0
480     uint16 constant USE_SIGNED = 2;       // 2^1
481     uint16 constant USE_NO_ENC = 4;       // 2^2
482     uint16 constant USE_ENC = 8;          // 2^3
483 
484     // ballot settings
485     uint16 constant IS_BINDING = 8192;    // 2^13
486     uint16 constant IS_OFFICIAL = 16384;  // 2^14
487     uint16 constant USE_TESTING = 32768;  // 2^15
488 }
489 
490 contract safeSend {
491     bool private txMutex3847834;
492 
493     // we want to be able to call outside contracts (e.g. the admin proxy contract)
494     // but reentrency is bad, so here's a mutex.
495     function doSafeSend(address toAddr, uint amount) internal {
496         doSafeSendWData(toAddr, "", amount);
497     }
498 
499     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
500         require(txMutex3847834 == false, "ss-guard");
501         txMutex3847834 = true;
502         // we need to use address.call.value(v)() because we want
503         // to be able to send to other contracts, even with no data,
504         // which might use more than 2300 gas in their fallback function.
505         require(toAddr.call.value(amount)(data), "ss-failed");
506         txMutex3847834 = false;
507     }
508 }
509 
510 contract payoutAllC is safeSend {
511     address private _payTo;
512 
513     event PayoutAll(address payTo, uint value);
514 
515     constructor(address initPayTo) public {
516         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
517         assert(initPayTo != address(0));
518         _payTo = initPayTo;
519     }
520 
521     function _getPayTo() internal view returns (address) {
522         return _payTo;
523     }
524 
525     function _setPayTo(address newPayTo) internal {
526         _payTo = newPayTo;
527     }
528 
529     function payoutAll() external {
530         address a = _getPayTo();
531         uint bal = address(this).balance;
532         doSafeSend(a, bal);
533         emit PayoutAll(a, bal);
534     }
535 }
536 
537 contract payoutAllCSettable is payoutAllC {
538     constructor (address initPayTo) payoutAllC(initPayTo) public {
539     }
540 
541     function setPayTo(address) external;
542     function getPayTo() external view returns (address) {
543         return _getPayTo();
544     }
545 }
546 
547 contract owned {
548     address public owner;
549 
550     event OwnerChanged(address newOwner);
551 
552     modifier only_owner() {
553         require(msg.sender == owner, "only_owner: forbidden");
554         _;
555     }
556 
557     modifier owner_or(address addr) {
558         require(msg.sender == addr || msg.sender == owner, "!owner-or");
559         _;
560     }
561 
562     constructor() public {
563         owner = msg.sender;
564     }
565 
566     function setOwner(address newOwner) only_owner() external {
567         owner = newOwner;
568         emit OwnerChanged(newOwner);
569     }
570 }
571 
572 contract CanReclaimToken is owned {
573 
574     /**
575     * @dev Reclaim all ERC20Basic compatible tokens
576     * @param token ERC20Basic The address of the token contract
577     */
578     function reclaimToken(ERC20Interface token) external only_owner {
579         uint256 balance = token.balanceOf(this);
580         require(token.approve(owner, balance));
581     }
582 
583 }
584 
585 contract CommunityAuctionSimple is owned {
586     // about $1USD at $600usd/eth
587     uint public commBallotPriceWei = 1666666666000000;
588 
589     struct Record {
590         bytes32 democHash;
591         uint ts;
592     }
593 
594     mapping (address => Record[]) public ballotLog;
595     mapping (address => address) public upgrades;
596 
597     function getNextPrice(bytes32) external view returns (uint) {
598         return commBallotPriceWei;
599     }
600 
601     function noteBallotDeployed(bytes32 d) external {
602         require(upgrades[msg.sender] == address(0));
603         ballotLog[msg.sender].push(Record(d, now));
604     }
605 
606     function upgradeMe(address newSC) external {
607         require(upgrades[msg.sender] == address(0));
608         upgrades[msg.sender] = newSC;
609     }
610 
611     function getBallotLogN(address a) external view returns (uint) {
612         return ballotLog[a].length;
613     }
614 
615     function setPriceWei(uint newPrice) only_owner() external {
616         commBallotPriceWei = newPrice;
617     }
618 }
619 
620 contract controlledIface {
621     function controller() external view returns (address);
622 }
623 
624 contract hasAdmins is owned {
625     mapping (uint => mapping (address => bool)) admins;
626     uint public currAdminEpoch = 0;
627     bool public adminsDisabledForever = false;
628     address[] adminLog;
629 
630     event AdminAdded(address indexed newAdmin);
631     event AdminRemoved(address indexed oldAdmin);
632     event AdminEpochInc();
633     event AdminDisabledForever();
634 
635     modifier only_admin() {
636         require(adminsDisabledForever == false, "admins must not be disabled");
637         require(isAdmin(msg.sender), "only_admin: forbidden");
638         _;
639     }
640 
641     constructor() public {
642         _setAdmin(msg.sender, true);
643     }
644 
645     function isAdmin(address a) view public returns (bool) {
646         return admins[currAdminEpoch][a];
647     }
648 
649     function getAdminLogN() view external returns (uint) {
650         return adminLog.length;
651     }
652 
653     function getAdminLog(uint n) view external returns (address) {
654         return adminLog[n];
655     }
656 
657     function upgradeMeAdmin(address newAdmin) only_admin() external {
658         // note: already checked msg.sender has admin with `only_admin` modifier
659         require(msg.sender != owner, "owner cannot upgrade self");
660         _setAdmin(msg.sender, false);
661         _setAdmin(newAdmin, true);
662     }
663 
664     function setAdmin(address a, bool _givePerms) only_admin() external {
665         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
666         _setAdmin(a, _givePerms);
667     }
668 
669     function _setAdmin(address a, bool _givePerms) internal {
670         admins[currAdminEpoch][a] = _givePerms;
671         if (_givePerms) {
672             emit AdminAdded(a);
673             adminLog.push(a);
674         } else {
675             emit AdminRemoved(a);
676         }
677     }
678 
679     // safety feature if admins go bad or something
680     function incAdminEpoch() only_owner() external {
681         currAdminEpoch++;
682         admins[currAdminEpoch][msg.sender] = true;
683         emit AdminEpochInc();
684     }
685 
686     // this is internal so contracts can all it, but not exposed anywhere in this
687     // contract.
688     function disableAdminForever() internal {
689         currAdminEpoch++;
690         adminsDisabledForever = true;
691         emit AdminDisabledForever();
692     }
693 }
694 
695 contract EnsOwnerProxy is hasAdmins {
696     bytes32 public ensNode;
697     ENSIface public ens;
698     PublicResolver public resolver;
699 
700     /**
701      * @param _ensNode The node to administer
702      * @param _ens The ENS Registrar
703      * @param _resolver The ENS Resolver
704      */
705     constructor(bytes32 _ensNode, ENSIface _ens, PublicResolver _resolver) public {
706         ensNode = _ensNode;
707         ens = _ens;
708         resolver = _resolver;
709     }
710 
711     function setAddr(address addr) only_admin() external {
712         _setAddr(addr);
713     }
714 
715     function _setAddr(address addr) internal {
716         resolver.setAddr(ensNode, addr);
717     }
718 
719     function returnToOwner() only_owner() external {
720         ens.setOwner(ensNode, owner);
721     }
722 
723     function fwdToENS(bytes data) only_owner() external {
724         require(address(ens).call(data), "fwding to ens failed");
725     }
726 
727     function fwdToResolver(bytes data) only_owner() external {
728         require(address(resolver).call(data), "fwding to resolver failed");
729     }
730 }
731 
732 contract permissioned is owned, hasAdmins {
733     mapping (address => bool) editAllowed;
734     bool public adminLockdown = false;
735 
736     event PermissionError(address editAddr);
737     event PermissionGranted(address editAddr);
738     event PermissionRevoked(address editAddr);
739     event PermissionsUpgraded(address oldSC, address newSC);
740     event SelfUpgrade(address oldSC, address newSC);
741     event AdminLockdown();
742 
743     modifier only_editors() {
744         require(editAllowed[msg.sender], "only_editors: forbidden");
745         _;
746     }
747 
748     modifier no_lockdown() {
749         require(adminLockdown == false, "no_lockdown: check failed");
750         _;
751     }
752 
753 
754     constructor() owned() hasAdmins() public {
755     }
756 
757 
758     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
759         editAllowed[e] = _editPerms;
760         if (_editPerms)
761             emit PermissionGranted(e);
762         else
763             emit PermissionRevoked(e);
764     }
765 
766     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
767         editAllowed[oldSC] = false;
768         editAllowed[newSC] = true;
769         emit PermissionsUpgraded(oldSC, newSC);
770     }
771 
772     // always allow SCs to upgrade themselves, even after lockdown
773     function upgradeMe(address newSC) only_editors() external {
774         editAllowed[msg.sender] = false;
775         editAllowed[newSC] = true;
776         emit SelfUpgrade(msg.sender, newSC);
777     }
778 
779     function hasPermissions(address a) public view returns (bool) {
780         return editAllowed[a];
781     }
782 
783     function doLockdown() external only_owner() no_lockdown() {
784         disableAdminForever();
785         adminLockdown = true;
786         emit AdminLockdown();
787     }
788 }
789 
790 contract upgradePtr {
791     address ptr = address(0);
792 
793     modifier not_upgraded() {
794         require(ptr == address(0), "upgrade pointer is non-zero");
795         _;
796     }
797 
798     function getUpgradePointer() view external returns (address) {
799         return ptr;
800     }
801 
802     function doUpgradeInternal(address nextSC) internal {
803         ptr = nextSC;
804     }
805 }
806 
807 interface ERC20Interface {
808     // Get the total token supply
809     function totalSupply() constant external returns (uint256 _totalSupply);
810 
811     // Get the account balance of another account with address _owner
812     function balanceOf(address _owner) constant external returns (uint256 balance);
813 
814     // Send _value amount of tokens to address _to
815     function transfer(address _to, uint256 _value) external returns (bool success);
816 
817     // Send _value amount of tokens from address _from to address _to
818     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
819 
820     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
821     // If this function is called again it overwrites the current allowance with _value.
822     // this function is required for some DEX functionality
823     function approve(address _spender, uint256 _value) external returns (bool success);
824 
825     // Returns the amount which _spender is still allowed to withdraw from _owner
826     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
827 
828     // Triggered when tokens are transferred.
829     event Transfer(address indexed _from, address indexed _to, uint256 _value);
830 
831     // Triggered whenever approve(address _spender, uint256 _value) is called.
832     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
833 }
834 
835 contract ixEvents {
836     event PaymentMade(uint[2] valAndRemainder);
837     event AddedBBFarm(uint8 bbFarmId);
838     event SetBackend(bytes32 setWhat, address newSC);
839     event DeprecatedBBFarm(uint8 bbFarmId);
840     event CommunityBallot(bytes32 democHash, uint256 ballotId);
841     event ManuallyAddedBallot(bytes32 democHash, uint256 ballotId, uint256 packed);
842     // copied from BBFarm - unable to inherit from BBFarmEvents...
843     event BallotCreatedWithID(uint ballotId);
844     event BBFarmInit(bytes4 namespace);
845 }
846 
847 contract ixBackendEvents {
848     event NewDemoc(bytes32 democHash);
849     event ManuallyAddedDemoc(bytes32 democHash, address erc20);
850     event NewBallot(bytes32 indexed democHash, uint ballotN);
851     event DemocOwnerSet(bytes32 indexed democHash, address owner);
852     event DemocEditorSet(bytes32 indexed democHash, address editor, bool canEdit);
853     event DemocEditorsWiped(bytes32 indexed democHash);
854     event DemocErc20Set(bytes32 indexed democHash, address erc20);
855     event DemocDataSet(bytes32 indexed democHash, bytes32 keyHash);
856     event DemocCatAdded(bytes32 indexed democHash, uint catId);
857     event DemocCatDeprecated(bytes32 indexed democHash, uint catId);
858     event DemocCommunityBallotsEnabled(bytes32 indexed democHash, bool enabled);
859     event DemocErc20OwnerClaimDisabled(bytes32 indexed democHash);
860     event DemocClaimed(bytes32 indexed democHash);
861     event EmergencyDemocOwner(bytes32 indexed democHash, address newOwner);
862 }
863 
864 library SafeMath {
865     function subToZero(uint a, uint b) internal pure returns (uint) {
866         if (a < b) {  // then (a - b) would overflow
867             return 0;
868         }
869         return a - b;
870     }
871 }
872 
873 contract ixPaymentEvents {
874     event UpgradedToPremium(bytes32 indexed democHash);
875     event GrantedAccountTime(bytes32 indexed democHash, uint additionalSeconds, bytes32 ref);
876     event AccountPayment(bytes32 indexed democHash, uint additionalSeconds);
877     event SetCommunityBallotFee(uint amount);
878     event SetBasicCentsPricePer30Days(uint amount);
879     event SetPremiumMultiplier(uint8 multiplier);
880     event DowngradeToBasic(bytes32 indexed democHash);
881     event UpgradeToPremium(bytes32 indexed democHash);
882     event SetExchangeRate(uint weiPerCent);
883     event FreeExtension(bytes32 democHash);
884     event SetBallotsPer30Days(uint amount);
885     event SetFreeExtension(bytes32 democHash, bool hasFreeExt);
886     event SetDenyPremium(bytes32 democHash, bool isPremiumDenied);
887     event SetPayTo(address payTo);
888     event SetMinorEditsAddr(address minorEditsAddr);
889     event SetMinWeiForDInit(uint amount);
890 }
891 
892 interface hasVersion {
893     function getVersion() external pure returns (uint);
894 }
895 
896 contract BBFarmIface is BBFarmEvents, permissioned, hasVersion, payoutAllC {
897     /* global bbfarm getters */
898 
899     function getNamespace() external view returns (bytes4);
900     function getBBLibVersion() external view returns (uint256);
901     function getNBallots() external view returns (uint256);
902 
903     /* init a ballot */
904 
905     // note that the ballotId returned INCLUDES the namespace.
906     function initBallot( bytes32 specHash
907                        , uint256 packed
908                        , IxIface ix
909                        , address bbAdmin
910                        , bytes24 extraData
911                        ) external returns (uint ballotId);
912 
913     /* Sponsorship of ballots */
914 
915     function sponsor(uint ballotId) external payable;
916 
917     /* Voting functions */
918 
919     function submitVote(uint ballotId, bytes32 vote, bytes extra) external;
920     function submitProxyVote(bytes32[5] proxyReq, bytes extra) external;
921 
922     /* Ballot Getters */
923 
924     function getDetails(uint ballotId, address voter) external view returns
925             ( bool hasVoted
926             , uint nVotesCast
927             , bytes32 secKey
928             , uint16 submissionBits
929             , uint64 startTime
930             , uint64 endTime
931             , bytes32 specHash
932             , bool deprecated
933             , address ballotOwner
934             , bytes16 extraData);
935 
936     function getVote(uint ballotId, uint voteId) external view returns (bytes32 voteData, address sender, bytes extra);
937     function getTotalSponsorship(uint ballotId) external view returns (uint);
938     function getSponsorsN(uint ballotId) external view returns (uint);
939     function getSponsor(uint ballotId, uint sponsorN) external view returns (address sender, uint amount);
940     function getCreationTs(uint ballotId) external view returns (uint);
941 
942     /* Admin on ballots */
943     function revealSeckey(uint ballotId, bytes32 sk) external;
944     function setEndTime(uint ballotId, uint64 newEndTime) external;  // note: testing only
945     function setDeprecated(uint ballotId) external;
946     function setBallotOwner(uint ballotId, address newOwner) external;
947 }
948 
949 contract BBFarm is BBFarmIface {
950     using BBLib for BBLib.DB;
951     using IxLib for IxIface;
952 
953     // namespaces should be unique for each bbFarm
954     bytes4 constant NAMESPACE = 0x00000001;
955     // last 48 bits
956     uint256 constant BALLOT_ID_MASK = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
957 
958     uint constant VERSION = 2;
959 
960     mapping (uint224 => BBLib.DB) dbs;
961     // note - start at 100 to avoid any test for if 0 is a valid ballotId
962     // also gives us some space to play with low numbers if we want.
963     uint nBallots = 0;
964 
965     /* modifiers */
966 
967     modifier req_namespace(uint ballotId) {
968         // bytes4() will take the _first_ 4 bytes
969         require(bytes4(ballotId >> 224) == NAMESPACE, "bad-namespace");
970         _;
971     }
972 
973     /* Constructor */
974 
975     constructor() payoutAllC(msg.sender) public {
976         // this bbFarm requires v5 of BBLib (note: v4 deprecated immediately due to insecure submitProxyVote)
977         // note: even though we can't test for this in coverage, this has stopped me deploying to kovan with the wrong version tho, so I consider it tested :)
978         assert(BBLib.getVersion() == 6);
979         emit BBFarmInit(NAMESPACE);
980     }
981 
982     /* base SCs */
983 
984     function _getPayTo() internal view returns (address) {
985         return owner;
986     }
987 
988     function getVersion() external pure returns (uint) {
989         return VERSION;
990     }
991 
992     /* global funcs */
993 
994     function getNamespace() external view returns (bytes4) {
995         return NAMESPACE;
996     }
997 
998     function getBBLibVersion() external view returns (uint256) {
999         return BBLib.getVersion();
1000     }
1001 
1002     function getNBallots() external view returns (uint256) {
1003         return nBallots;
1004     }
1005 
1006     /* db lookup helper */
1007 
1008     function getDb(uint ballotId) internal view returns (BBLib.DB storage) {
1009         // cut off anything above 224 bits (where the namespace goes)
1010         return dbs[uint224(ballotId)];
1011     }
1012 
1013     /* Init ballot */
1014 
1015     function initBallot( bytes32 specHash
1016                        , uint256 packed
1017                        , IxIface ix
1018                        , address bbAdmin
1019                        , bytes24 extraData
1020                 ) only_editors() external returns (uint ballotId) {
1021         // calculate the ballotId based on the last 224 bits of the specHash.
1022         ballotId = uint224(specHash) ^ (uint256(NAMESPACE) << 224);
1023         // we need to call the init functions on our libraries
1024         getDb(ballotId).init(specHash, packed, ix, bbAdmin, bytes16(uint128(extraData)));
1025         nBallots += 1;
1026 
1027         emit BallotCreatedWithID(ballotId);
1028     }
1029 
1030     /* Sponsorship */
1031 
1032     function sponsor(uint ballotId) external payable {
1033         BBLib.DB storage db = getDb(ballotId);
1034         db.logSponsorship(msg.value);
1035         doSafeSend(db.index.getPayTo(), msg.value);
1036         emit Sponsorship(ballotId, msg.value);
1037     }
1038 
1039     /* Voting */
1040 
1041     function submitVote(uint ballotId, bytes32 vote, bytes extra) req_namespace(ballotId) external {
1042         getDb(ballotId).submitVote(vote, extra);
1043         emit Vote(ballotId, vote, msg.sender, extra);
1044     }
1045 
1046     function submitProxyVote(bytes32[5] proxyReq, bytes extra) req_namespace(uint256(proxyReq[3])) external {
1047         // see https://github.com/secure-vote/tokenvote/blob/master/Docs/DataStructs.md for breakdown of params
1048         // pr[3] is the ballotId, and pr[4] is the vote
1049         uint ballotId = uint256(proxyReq[3]);
1050         address voter = getDb(ballotId).submitProxyVote(proxyReq, extra);
1051         bytes32 vote = proxyReq[4];
1052         emit Vote(ballotId, vote, voter, extra);
1053     }
1054 
1055     /* Getters */
1056 
1057     // note - this is the maxmimum number of vars we can return with one
1058     // function call (taking 2 args)
1059     function getDetails(uint ballotId, address voter) external view returns
1060             ( bool hasVoted
1061             , uint nVotesCast
1062             , bytes32 secKey
1063             , uint16 submissionBits
1064             , uint64 startTime
1065             , uint64 endTime
1066             , bytes32 specHash
1067             , bool deprecated
1068             , address ballotOwner
1069             , bytes16 extraData) {
1070         BBLib.DB storage db = getDb(ballotId);
1071         uint packed = db.packed;
1072         return (
1073             db.getSequenceNumber(voter) > 0,
1074             db.nVotesCast,
1075             db.ballotEncryptionSeckey,
1076             BPackedUtils.packedToSubmissionBits(packed),
1077             BPackedUtils.packedToStartTime(packed),
1078             BPackedUtils.packedToEndTime(packed),
1079             db.specHash,
1080             db.deprecated,
1081             db.ballotOwner,
1082             db.extraData
1083         );
1084     }
1085 
1086     function getVote(uint ballotId, uint voteId) external view returns (bytes32 voteData, address sender, bytes extra) {
1087         (voteData, sender, extra, ) = getDb(ballotId).getVote(voteId);
1088     }
1089 
1090     function getSequenceNumber(uint ballotId, address voter) external view returns (uint32 sequence) {
1091         return getDb(ballotId).getSequenceNumber(voter);
1092     }
1093 
1094     function getTotalSponsorship(uint ballotId) external view returns (uint) {
1095         return getDb(ballotId).getTotalSponsorship();
1096     }
1097 
1098     function getSponsorsN(uint ballotId) external view returns (uint) {
1099         return getDb(ballotId).sponsors.length;
1100     }
1101 
1102     function getSponsor(uint ballotId, uint sponsorN) external view returns (address sender, uint amount) {
1103         return getDb(ballotId).getSponsor(sponsorN);
1104     }
1105 
1106     function getCreationTs(uint ballotId) external view returns (uint) {
1107         return getDb(ballotId).creationTs;
1108     }
1109 
1110     /* ADMIN */
1111 
1112     // Allow the owner to reveal the secret key after ballot conclusion
1113     function revealSeckey(uint ballotId, bytes32 sk) external {
1114         BBLib.DB storage db = getDb(ballotId);
1115         db.requireBallotOwner();
1116         db.requireBallotClosed();
1117         db.revealSeckey(sk);
1118     }
1119 
1120     // note: testing only.
1121     function setEndTime(uint ballotId, uint64 newEndTime) external {
1122         BBLib.DB storage db = getDb(ballotId);
1123         db.requireBallotOwner();
1124         db.requireTesting();
1125         db.setEndTime(newEndTime);
1126     }
1127 
1128     function setDeprecated(uint ballotId) external {
1129         BBLib.DB storage db = getDb(ballotId);
1130         db.requireBallotOwner();
1131         db.deprecated = true;
1132     }
1133 
1134     function setBallotOwner(uint ballotId, address newOwner) external {
1135         BBLib.DB storage db = getDb(ballotId);
1136         db.requireBallotOwner();
1137         db.ballotOwner = newOwner;
1138     }
1139 }
1140 
1141 contract IxIface is hasVersion,
1142                     ixPaymentEvents,
1143                     ixBackendEvents,
1144                     ixEvents,
1145                     SVBallotConsts,
1146                     owned,
1147                     CanReclaimToken,
1148                     upgradePtr,
1149                     payoutAllC {
1150 
1151     /* owner functions */
1152     function addBBFarm(BBFarmIface bbFarm) external returns (uint8 bbFarmId);
1153     function setABackend(bytes32 toSet, address newSC) external;
1154     function deprecateBBFarm(uint8 bbFarmId, BBFarmIface _bbFarm) external;
1155 
1156     /* global getters */
1157     function getPayments() external view returns (IxPaymentsIface);
1158     function getBackend() external view returns (IxBackendIface);
1159     function getBBFarm(uint8 bbFarmId) external view returns (BBFarmIface);
1160     function getBBFarmID(bytes4 bbNamespace) external view returns (uint8 bbFarmId);
1161     function getCommAuction() external view returns (CommAuctionIface);
1162 
1163     /* init a democ */
1164     function dInit(address defualtErc20, bool disableErc20OwnerClaim) external payable returns (bytes32);
1165 
1166     /* democ owner / editor functions */
1167     function setDEditor(bytes32 democHash, address editor, bool canEdit) external;
1168     function setDNoEditors(bytes32 democHash) external;
1169     function setDOwner(bytes32 democHash, address newOwner) external;
1170     function dOwnerErc20Claim(bytes32 democHash) external;
1171     function setDErc20(bytes32 democHash, address newErc20) external;
1172     function dAddCategory(bytes32 democHash, bytes32 categoryName, bool hasParent, uint parent) external;
1173     function dDeprecateCategory(bytes32 democHash, uint categoryId) external;
1174     function dUpgradeToPremium(bytes32 democHash) external;
1175     function dDowngradeToBasic(bytes32 democHash) external;
1176     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1177     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) external;
1178     function dDisableErc20OwnerClaim(bytes32 democHash) external;
1179 
1180     /* democ getters (that used to be here) should be called on either backend or payments directly */
1181     /* use IxLib for convenience functions from other SCs */
1182 
1183     /* ballot deployment */
1184     // only ix owner - used for adding past or special ballots
1185     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed) external;
1186     function dDeployCommunityBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint128 packedTimes) external payable;
1187     function dDeployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint256 packed) external payable;
1188 }
1189 
1190 contract SVIndex is IxIface {
1191     uint256 constant VERSION = 2;
1192 
1193     // generated from: `address public owner;`
1194     bytes4 constant OWNER_SIG = 0x8da5cb5b;
1195     // generated from: `address public controller;`
1196     bytes4 constant CONTROLLER_SIG = 0xf77c4791;
1197 
1198     /* backend & other SC storage */
1199 
1200     IxBackendIface backend;
1201     IxPaymentsIface payments;
1202     EnsOwnerProxy public ensOwnerPx;
1203     BBFarmIface[] bbFarms;
1204     CommAuctionIface commAuction;
1205     // mapping from bbFarm namespace to bbFarmId
1206     mapping (bytes4 => uint8) bbFarmIdLookup;
1207     mapping (uint8 => bool) deprecatedBBFarms;
1208 
1209     //* MODIFIERS /
1210 
1211     modifier onlyDemocOwner(bytes32 democHash) {
1212         require(msg.sender == backend.getDOwner(democHash), "!d-owner");
1213         _;
1214     }
1215 
1216     modifier onlyDemocEditor(bytes32 democHash) {
1217         require(backend.isDEditor(democHash, msg.sender), "!d-editor");
1218         _;
1219     }
1220 
1221     /* FUNCTIONS */
1222 
1223     // constructor
1224     constructor( IxBackendIface _b
1225                , IxPaymentsIface _pay
1226                , EnsOwnerProxy _ensOwnerPx
1227                , BBFarmIface _bbFarm0
1228                , CommAuctionIface _commAuction
1229                ) payoutAllC(msg.sender) public {
1230         backend = _b;
1231         payments = _pay;
1232         ensOwnerPx = _ensOwnerPx;
1233         _addBBFarm(0x0, _bbFarm0);
1234         commAuction = _commAuction;
1235     }
1236 
1237     /* payoutAllC */
1238 
1239     function _getPayTo() internal view returns (address) {
1240         return payments.getPayTo();
1241     }
1242 
1243     /* UPGRADE STUFF */
1244 
1245     function doUpgrade(address nextSC) only_owner() not_upgraded() external {
1246         doUpgradeInternal(nextSC);
1247         backend.upgradeMe(nextSC);
1248         payments.upgradeMe(nextSC);
1249         ensOwnerPx.setAddr(nextSC);
1250         ensOwnerPx.upgradeMeAdmin(nextSC);
1251         commAuction.upgradeMe(nextSC);
1252 
1253         for (uint i = 0; i < bbFarms.length; i++) {
1254             bbFarms[i].upgradeMe(nextSC);
1255         }
1256     }
1257 
1258     function _addBBFarm(bytes4 bbNamespace, BBFarmIface _bbFarm) internal returns (uint8 bbFarmId) {
1259         uint256 bbFarmIdLong = bbFarms.length;
1260         require(bbFarmIdLong < 2**8, "too-many-farms");
1261         bbFarmId = uint8(bbFarmIdLong);
1262 
1263         bbFarms.push(_bbFarm);
1264         bbFarmIdLookup[bbNamespace] = bbFarmId;
1265         emit AddedBBFarm(bbFarmId);
1266     }
1267 
1268     // adding a new BBFarm
1269     function addBBFarm(BBFarmIface bbFarm) only_owner() external returns (uint8 bbFarmId) {
1270         bytes4 bbNamespace = bbFarm.getNamespace();
1271 
1272         require(bbNamespace != bytes4(0), "bb-farm-namespace");
1273         require(bbFarmIdLookup[bbNamespace] == 0 && bbNamespace != bbFarms[0].getNamespace(), "bb-namespace-used");
1274 
1275         bbFarmId = _addBBFarm(bbNamespace, bbFarm);
1276     }
1277 
1278     function setABackend(bytes32 toSet, address newSC) only_owner() external {
1279         emit SetBackend(toSet, newSC);
1280         if (toSet == bytes32("payments")) {
1281             payments = IxPaymentsIface(newSC);
1282         } else if (toSet == bytes32("backend")) {
1283             backend = IxBackendIface(newSC);
1284         } else if (toSet == bytes32("commAuction")) {
1285             commAuction = CommAuctionIface(newSC);
1286         } else {
1287             revert("404");
1288         }
1289     }
1290 
1291     function deprecateBBFarm(uint8 bbFarmId, BBFarmIface _bbFarm) only_owner() external {
1292         require(address(_bbFarm) != address(0));
1293         require(bbFarms[bbFarmId] == _bbFarm);
1294         deprecatedBBFarms[bbFarmId] = true;
1295         emit DeprecatedBBFarm(bbFarmId);
1296     }
1297 
1298     /* Getters for backends */
1299 
1300     function getPayments() external view returns (IxPaymentsIface) {
1301         return payments;
1302     }
1303 
1304     function getBackend() external view returns (IxBackendIface) {
1305         return backend;
1306     }
1307 
1308     function getBBFarm(uint8 bbFarmId) external view returns (BBFarmIface) {
1309         return bbFarms[bbFarmId];
1310     }
1311 
1312     function getBBFarmID(bytes4 bbNamespace) external view returns (uint8 bbFarmId) {
1313         return bbFarmIdLookup[bbNamespace];
1314     }
1315 
1316     function getCommAuction() external view returns (CommAuctionIface) {
1317         return commAuction;
1318     }
1319 
1320     //* GLOBAL INFO */
1321 
1322     function getVersion() external pure returns (uint256) {
1323         return VERSION;
1324     }
1325 
1326     //* DEMOCRACY FUNCTIONS - INDIVIDUAL */
1327 
1328     function dInit(address defaultErc20, bool disableErc20OwnerClaim) not_upgraded() external payable returns (bytes32) {
1329         require(msg.value >= payments.getMinWeiForDInit());
1330         bytes32 democHash = backend.dInit(defaultErc20, msg.sender, disableErc20OwnerClaim);
1331         payments.payForDemocracy.value(msg.value)(democHash);
1332         return democHash;
1333     }
1334 
1335     // admin methods
1336 
1337     function setDEditor(bytes32 democHash, address editor, bool canEdit) onlyDemocOwner(democHash) external {
1338         backend.setDEditor(democHash, editor, canEdit);
1339     }
1340 
1341     function setDNoEditors(bytes32 democHash) onlyDemocOwner(democHash) external {
1342         backend.setDNoEditors(democHash);
1343     }
1344 
1345     function setDOwner(bytes32 democHash, address newOwner) onlyDemocOwner(democHash) external {
1346         backend.setDOwner(democHash, newOwner);
1347     }
1348 
1349     function dOwnerErc20Claim(bytes32 democHash) external {
1350         address erc20 = backend.getDErc20(democHash);
1351         // test if we can call the erc20.owner() method, etc
1352         // also limit gas use to 3000 because we don't know what they'll do with it
1353         // during testing both owned and controlled could be called from other contracts for 2525 gas.
1354         if (erc20.call.gas(3000)(OWNER_SIG)) {
1355             require(msg.sender == owned(erc20).owner.gas(3000)(), "!erc20-owner");
1356         } else if (erc20.call.gas(3000)(CONTROLLER_SIG)) {
1357             require(msg.sender == controlledIface(erc20).controller.gas(3000)(), "!erc20-controller");
1358         } else {
1359             revert();
1360         }
1361         // now we are certain the sender deployed or controls the erc20
1362         backend.setDOwnerFromClaim(democHash, msg.sender);
1363     }
1364 
1365     function setDErc20(bytes32 democHash, address newErc20) onlyDemocOwner(democHash) external {
1366         backend.setDErc20(democHash, newErc20);
1367     }
1368 
1369     function dAddCategory(bytes32 democHash, bytes32 catName, bool hasParent, uint parent) onlyDemocEditor(democHash) external {
1370         backend.dAddCategory(democHash, catName, hasParent, parent);
1371     }
1372 
1373     function dDeprecateCategory(bytes32 democHash, uint catId) onlyDemocEditor(democHash) external {
1374         backend.dDeprecateCategory(democHash, catId);
1375     }
1376 
1377     function dUpgradeToPremium(bytes32 democHash) onlyDemocOwner(democHash) external {
1378         payments.upgradeToPremium(democHash);
1379     }
1380 
1381     function dDowngradeToBasic(bytes32 democHash) onlyDemocOwner(democHash) external {
1382         payments.downgradeToBasic(democHash);
1383     }
1384 
1385     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external {
1386         if (msg.sender == backend.getDOwner(democHash)) {
1387             backend.dSetArbitraryData(democHash, key, value);
1388         } else if (backend.isDEditor(democHash, msg.sender)) {
1389             backend.dSetEditorArbitraryData(democHash, key, value);
1390         } else {
1391             revert();
1392         }
1393     }
1394 
1395     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) onlyDemocOwner(democHash) external {
1396         backend.dSetCommunityBallotsEnabled(democHash, enabled);
1397     }
1398 
1399     // this is one way only!
1400     function dDisableErc20OwnerClaim(bytes32 democHash) onlyDemocOwner(democHash) external {
1401         backend.dDisableErc20OwnerClaim(democHash);
1402     }
1403 
1404     /* Democ Getters - deprecated */
1405     // NOTE: the getters that used to live here just proxied to the backend.
1406     // this has been removed to reduce gas costs + size of Ix contract
1407     // For SCs you should use IxLib for convenience.
1408     // For Offchain use you should query the backend directly (via ix.getBackend())
1409 
1410     /* Add and Deploy Ballots */
1411 
1412     // manually add a ballot - only the owner can call this
1413     // WARNING - it's required that we make ABSOLUTELY SURE that
1414     // ballotId is valid and can resolve via the appropriate BBFarm.
1415     // this function _DOES NOT_ validate that everything else is done.
1416     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed)
1417                       only_owner()
1418                       external {
1419 
1420         _addBallot(democHash, ballotId, packed, false);
1421         emit ManuallyAddedBallot(democHash, ballotId, packed);
1422     }
1423 
1424 
1425     function _deployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint packed, bool checkLimit, bool alreadySentTx) internal returns (uint ballotId) {
1426         require(BBLib.isTesting(BPackedUtils.packedToSubmissionBits(packed)) == false, "b-testing");
1427 
1428         // the most significant byte of extraData signals the bbFarm to use.
1429         uint8 bbFarmId = uint8(extraData[0]);
1430         require(deprecatedBBFarms[bbFarmId] == false, "bb-dep");
1431         BBFarmIface _bbFarm = bbFarms[bbFarmId];
1432 
1433         // anything that isn't a community ballot counts towards the basic limit.
1434         // we want to check in cases where
1435         // the ballot doesn't qualify as a community ballot
1436         // OR (the ballot qualifies as a community ballot
1437         //     AND the admins have _disabled_ community ballots).
1438         bool countTowardsLimit = checkLimit;
1439         bool performedSend;
1440         if (checkLimit) {
1441             uint64 endTime = BPackedUtils.packedToEndTime(packed);
1442             (countTowardsLimit, performedSend) = _basicBallotLimitOperations(democHash, _bbFarm);
1443             _accountOkayChecks(democHash, endTime);
1444         }
1445 
1446         if (!performedSend && msg.value > 0 && alreadySentTx == false) {
1447             // refund if we haven't send value anywhere (which might happen if someone accidentally pays us)
1448             doSafeSend(msg.sender, msg.value);
1449         }
1450 
1451         ballotId = _bbFarm.initBallot(
1452             specHash,
1453             packed,
1454             this,
1455             msg.sender,
1456             // we are certain that the first 8 bytes are for index use only.
1457             // truncating extraData like this means we can occasionally
1458             // save on gas. we need to use uint192 first because that will take
1459             // the _last_ 24 bytes of extraData.
1460             bytes24(uint192(extraData)));
1461 
1462         _addBallot(democHash, ballotId, packed, countTowardsLimit);
1463     }
1464 
1465     function dDeployCommunityBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint128 packedTimes) external payable {
1466         uint price = commAuction.getNextPrice(democHash);
1467         require(msg.value >= price, "!cb-fee");
1468 
1469         doSafeSend(payments.getPayTo(), price);
1470         doSafeSend(msg.sender, msg.value - price);
1471 
1472         bool canProceed = backend.getDCommBallotsEnabled(democHash) || !payments.accountInGoodStanding(democHash);
1473         require(canProceed, "!cb-enabled");
1474 
1475         uint256 packed = BPackedUtils.setSB(uint256(packedTimes), (USE_ETH | USE_NO_ENC));
1476 
1477         uint ballotId = _deployBallot(democHash, specHash, extraData, packed, false, true);
1478         commAuction.noteBallotDeployed(democHash);
1479 
1480         emit CommunityBallot(democHash, ballotId);
1481     }
1482 
1483     // only way a democ admin can deploy a ballot
1484     function dDeployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, uint256 packed)
1485                           onlyDemocEditor(democHash)
1486                           external payable {
1487 
1488         _deployBallot(democHash, specHash, extraData, packed, true, false);
1489     }
1490 
1491     // internal logic around adding a ballot
1492     function _addBallot(bytes32 democHash, uint256 ballotId, uint256 packed, bool countTowardsLimit) internal {
1493         // backend handles events
1494         backend.dAddBallot(democHash, ballotId, packed, countTowardsLimit);
1495     }
1496 
1497     // check an account has paid up enough for this ballot
1498     function _accountOkayChecks(bytes32 democHash, uint64 endTime) internal view {
1499         // if the ballot is marked as official require the democracy is paid up to
1500         // some relative amount - exclude NFP accounts from this check
1501         uint secsLeft = payments.getSecondsRemaining(democHash);
1502         // must be positive due to ending in future check
1503         uint256 secsToEndTime = endTime - now;
1504         // require ballots end no more than twice the time left on the democracy
1505         require(secsLeft * 2 > secsToEndTime, "unpaid");
1506     }
1507 
1508     function _basicBallotLimitOperations(bytes32 democHash, BBFarmIface _bbFarm) internal returns (bool shouldCount, bool performedSend) {
1509         // if we're an official ballot and the democ is basic, ensure the democ
1510         // isn't over the ballots/mo limit
1511         if (payments.getPremiumStatus(democHash) == false) {
1512             uint nBallotsAllowed = payments.getBasicBallotsPer30Days();
1513             uint nBallotsBasicCounted = backend.getDCountedBasicBallotsN(democHash);
1514 
1515             // if the democ has less than nBallotsAllowed then it's guarenteed to be okay
1516             if (nBallotsAllowed > nBallotsBasicCounted) {
1517                 // and we should count this ballot
1518                 return (true, false);
1519             }
1520 
1521             // we want to check the creation timestamp of the nth most recent ballot
1522             // where n is the # of ballots allowed per month. Note: there isn't an off
1523             // by 1 error here because if 1 ballots were allowed per month then we'd want
1524             // to look at the most recent ballot, so nBallotsBasicCounted-1 in this case.
1525             // similarly, if X ballots were allowed per month we want to look at
1526             // nBallotsBasicCounted-X. There would thus be (X-1) ballots that are _more_
1527             // recent than the one we're looking for.
1528             uint earlyBallotId = backend.getDCountedBasicBallotID(democHash, nBallotsBasicCounted - nBallotsAllowed);
1529             uint earlyBallotTs = _bbFarm.getCreationTs(earlyBallotId);
1530 
1531             // if the earlyBallot was created more than 30 days in the past we should
1532             // count the new ballot
1533             if (earlyBallotTs < now - 30 days) {
1534                 return (true, false);
1535             }
1536 
1537             // at this point it may be the case that we shouldn't allow the ballot
1538             // to be created. (It's an official ballot for a basic tier democracy
1539             // where the Nth most recent ballot was created within the last 30 days.)
1540             // We should now check for payment
1541             uint extraBallotFee = payments.getBasicExtraBallotFeeWei();
1542             require(msg.value >= extraBallotFee, "!extra-b-fee");
1543 
1544             // now that we know they've paid the fee, we should send Eth to `payTo`
1545             // and return the remainder.
1546             uint remainder = msg.value - extraBallotFee;
1547             doSafeSend(address(payments), extraBallotFee);
1548             doSafeSend(msg.sender, remainder);
1549             emit PaymentMade([extraBallotFee, remainder]);
1550             // only in this case (for basic) do we want to return false - don't count towards the
1551             // limit because it's been paid for here.
1552             return (false, true);
1553 
1554         } else {  // if we're premium we don't count ballots
1555             return (false, false);
1556         }
1557     }
1558 }
1559 
1560 contract IxBackendIface is hasVersion, ixBackendEvents, permissioned, payoutAllC {
1561     /* global getters */
1562     function getGDemocsN() external view returns (uint);
1563     function getGDemoc(uint id) external view returns (bytes32);
1564     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes);
1565 
1566     /* owner functions */
1567     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) external;
1568     function emergencySetDOwner(bytes32 democHash, address newOwner) external;
1569 
1570     /* democ admin */
1571     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) external returns (bytes32 democHash);
1572     function setDOwner(bytes32 democHash, address newOwner) external;
1573     function setDOwnerFromClaim(bytes32 democHash, address newOwner) external;
1574     function setDEditor(bytes32 democHash, address editor, bool canEdit) external;
1575     function setDNoEditors(bytes32 democHash) external;
1576     function setDErc20(bytes32 democHash, address newErc20) external;
1577     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1578     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) external;
1579     function dAddCategory(bytes32 democHash, bytes32 categoryName, bool hasParent, uint parent) external;
1580     function dDeprecateCategory(bytes32 democHash, uint catId) external;
1581     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) external;
1582     function dDisableErc20OwnerClaim(bytes32 democHash) external;
1583 
1584     /* actually add a ballot */
1585     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) external;
1586 
1587     /* global democ getters */
1588     function getDOwner(bytes32 democHash) external view returns (address);
1589     function isDEditor(bytes32 democHash, address editor) external view returns (bool);
1590     function getDHash(bytes13 prefix) external view returns (bytes32);
1591     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots);
1592     function getDErc20(bytes32 democHash) external view returns (address);
1593     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
1594     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
1595     function getDBallotsN(bytes32 democHash) external view returns (uint256);
1596     function getDBallotID(bytes32 democHash, uint n) external view returns (uint ballotId);
1597     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256);
1598     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256);
1599     function getDCategoriesN(bytes32 democHash) external view returns (uint);
1600     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint parent);
1601     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool);
1602     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool);
1603 }
1604 
1605 contract SVIndexBackend is IxBackendIface {
1606     uint constant VERSION = 2;
1607 
1608     struct Democ {
1609         address erc20;
1610         address owner;
1611         bool communityBallotsDisabled;
1612         bool erc20OwnerClaimDisabled;
1613         uint editorEpoch;
1614         mapping (uint => mapping (address => bool)) editors;
1615         uint256[] allBallots;
1616         uint256[] includedBasicBallots;  // the IDs of official ballots
1617 
1618     }
1619 
1620     struct BallotRef {
1621         bytes32 democHash;
1622         uint ballotId;
1623     }
1624 
1625     struct Category {
1626         bool deprecated;
1627         bytes32 name;
1628         bool hasParent;
1629         uint parent;
1630     }
1631 
1632     struct CategoriesIx {
1633         uint nCategories;
1634         mapping(uint => Category) categories;
1635     }
1636 
1637     mapping (bytes32 => Democ) democs;
1638     mapping (bytes32 => CategoriesIx) democCategories;
1639     mapping (bytes13 => bytes32) democPrefixToHash;
1640     mapping (address => bytes32[]) erc20ToDemocs;
1641     bytes32[] democList;
1642 
1643     // allows democ admins to store arbitrary data
1644     // this lets us (for example) set particular keys to signal cerain
1645     // things to client apps s.t. the admin can turn them on and off.
1646     // arbitraryData[democHash][key]
1647     mapping (bytes32 => mapping (bytes32 => bytes)) arbitraryData;
1648 
1649     /* constructor */
1650 
1651     constructor() payoutAllC(msg.sender) public {
1652         // do nothing
1653     }
1654 
1655     /* base contract overloads */
1656 
1657     function _getPayTo() internal view returns (address) {
1658         return owner;
1659     }
1660 
1661     function getVersion() external pure returns (uint) {
1662         return VERSION;
1663     }
1664 
1665     /* GLOBAL INFO */
1666 
1667     function getGDemocsN() external view returns (uint) {
1668         return democList.length;
1669     }
1670 
1671     function getGDemoc(uint id) external view returns (bytes32) {
1672         return democList[id];
1673     }
1674 
1675     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes) {
1676         return erc20ToDemocs[erc20];
1677     }
1678 
1679     /* DEMOCRACY ADMIN FUNCTIONS */
1680 
1681     function _addDemoc(bytes32 democHash, address erc20, address initOwner, bool disableErc20OwnerClaim) internal {
1682         democList.push(democHash);
1683         Democ storage d = democs[democHash];
1684         d.erc20 = erc20;
1685         if (disableErc20OwnerClaim) {
1686             d.erc20OwnerClaimDisabled = true;
1687         }
1688         // this should never trigger if we have a good security model - entropy for 13 bytes ~ 2^(8*13) ~ 10^31
1689         assert(democPrefixToHash[bytes13(democHash)] == bytes32(0));
1690         democPrefixToHash[bytes13(democHash)] = democHash;
1691         erc20ToDemocs[erc20].push(democHash);
1692         _setDOwner(democHash, initOwner);
1693         emit NewDemoc(democHash);
1694     }
1695 
1696     /* owner democ admin functions */
1697 
1698     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) only_owner() external {
1699         _addDemoc(democHash, erc20, msg.sender, disableErc20OwnerClaim);
1700         emit ManuallyAddedDemoc(democHash, erc20);
1701     }
1702 
1703     /* Preferably for emergencies only */
1704 
1705     function emergencySetDOwner(bytes32 democHash, address newOwner) only_owner() external {
1706         _setDOwner(democHash, newOwner);
1707         emit EmergencyDemocOwner(democHash, newOwner);
1708     }
1709 
1710     /* user democ admin functions */
1711 
1712     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) only_editors() external returns (bytes32 democHash) {
1713         // generating the democHash in this way guarentees it'll be unique/hard-to-brute-force
1714         // (particularly because prevBlockHash and now are part of the hash)
1715         democHash = keccak256(abi.encodePacked(democList.length, blockhash(block.number-1), defaultErc20, now));
1716         _addDemoc(democHash, defaultErc20, initOwner, disableErc20OwnerClaim);
1717     }
1718 
1719     function _setDOwner(bytes32 democHash, address newOwner) internal {
1720         Democ storage d = democs[democHash];
1721         uint epoch = d.editorEpoch;
1722         d.owner = newOwner;
1723         // unset prev owner as editor - does little if one was not set
1724         d.editors[epoch][d.owner] = false;
1725         // make new owner an editor too
1726         d.editors[epoch][newOwner] = true;
1727         emit DemocOwnerSet(democHash, newOwner);
1728     }
1729 
1730     function setDOwner(bytes32 democHash, address newOwner) only_editors() external {
1731         _setDOwner(democHash, newOwner);
1732     }
1733 
1734     function setDOwnerFromClaim(bytes32 democHash, address newOwner) only_editors() external {
1735         Democ storage d = democs[democHash];
1736         // make sure that the owner claim is enabled (i.e. the disabled flag is false)
1737         require(d.erc20OwnerClaimDisabled == false, "!erc20-claim");
1738         // set owner and editor
1739         d.owner = newOwner;
1740         d.editors[d.editorEpoch][newOwner] = true;
1741         // disable the ability to claim now that it's done
1742         d.erc20OwnerClaimDisabled = true;
1743         emit DemocOwnerSet(democHash, newOwner);
1744         emit DemocClaimed(democHash);
1745     }
1746 
1747     function setDEditor(bytes32 democHash, address editor, bool canEdit) only_editors() external {
1748         Democ storage d = democs[democHash];
1749         d.editors[d.editorEpoch][editor] = canEdit;
1750         emit DemocEditorSet(democHash, editor, canEdit);
1751     }
1752 
1753     function setDNoEditors(bytes32 democHash) only_editors() external {
1754         democs[democHash].editorEpoch += 1;
1755         emit DemocEditorsWiped(democHash);
1756     }
1757 
1758     function setDErc20(bytes32 democHash, address newErc20) only_editors() external {
1759         democs[democHash].erc20 = newErc20;
1760         erc20ToDemocs[newErc20].push(democHash);
1761         emit DemocErc20Set(democHash, newErc20);
1762     }
1763 
1764     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
1765         bytes32 k = keccak256(key);
1766         arbitraryData[democHash][k] = value;
1767         emit DemocDataSet(democHash, k);
1768     }
1769 
1770     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
1771         bytes32 k = keccak256(_calcEditorKey(key));
1772         arbitraryData[democHash][k] = value;
1773         emit DemocDataSet(democHash, k);
1774     }
1775 
1776     function dAddCategory(bytes32 democHash, bytes32 name, bool hasParent, uint parent) only_editors() external {
1777         uint catId = democCategories[democHash].nCategories;
1778         democCategories[democHash].categories[catId].name = name;
1779         if (hasParent) {
1780             democCategories[democHash].categories[catId].hasParent = true;
1781             democCategories[democHash].categories[catId].parent = parent;
1782         }
1783         democCategories[democHash].nCategories += 1;
1784         emit DemocCatAdded(democHash, catId);
1785     }
1786 
1787     function dDeprecateCategory(bytes32 democHash, uint catId) only_editors() external {
1788         democCategories[democHash].categories[catId].deprecated = true;
1789         emit DemocCatDeprecated(democHash, catId);
1790     }
1791 
1792     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) only_editors() external {
1793         democs[democHash].communityBallotsDisabled = !enabled;
1794         emit DemocCommunityBallotsEnabled(democHash, enabled);
1795     }
1796 
1797     function dDisableErc20OwnerClaim(bytes32 democHash) only_editors() external {
1798         democs[democHash].erc20OwnerClaimDisabled = true;
1799         emit DemocErc20OwnerClaimDisabled(democHash);
1800     }
1801 
1802     //* ADD BALLOT TO RECORD */
1803 
1804     function _commitBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) internal {
1805         uint16 subBits;
1806         subBits = BPackedUtils.packedToSubmissionBits(packed);
1807 
1808         uint localBallotId = democs[democHash].allBallots.length;
1809         democs[democHash].allBallots.push(ballotId);
1810 
1811         // do this for anything that doesn't qualify as a community ballot
1812         if (countTowardsLimit) {
1813             democs[democHash].includedBasicBallots.push(ballotId);
1814         }
1815 
1816         emit NewBallot(democHash, localBallotId);
1817     }
1818 
1819     // what SVIndex uses to add a ballot
1820     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) only_editors() external {
1821         _commitBallot(democHash, ballotId, packed, countTowardsLimit);
1822     }
1823 
1824     /* democ getters */
1825 
1826     function getDOwner(bytes32 democHash) external view returns (address) {
1827         return democs[democHash].owner;
1828     }
1829 
1830     function isDEditor(bytes32 democHash, address editor) external view returns (bool) {
1831         Democ storage d = democs[democHash];
1832         // allow either an editor or always the owner
1833         return d.editors[d.editorEpoch][editor] || editor == d.owner;
1834     }
1835 
1836     function getDHash(bytes13 prefix) external view returns (bytes32) {
1837         return democPrefixToHash[prefix];
1838     }
1839 
1840     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots) {
1841         return (democs[democHash].erc20, democs[democHash].owner, democs[democHash].allBallots.length);
1842     }
1843 
1844     function getDErc20(bytes32 democHash) external view returns (address) {
1845         return democs[democHash].erc20;
1846     }
1847 
1848     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
1849         return arbitraryData[democHash][keccak256(key)];
1850     }
1851 
1852     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
1853         return arbitraryData[democHash][keccak256(_calcEditorKey(key))];
1854     }
1855 
1856     function getDBallotsN(bytes32 democHash) external view returns (uint256) {
1857         return democs[democHash].allBallots.length;
1858     }
1859 
1860     function getDBallotID(bytes32 democHash, uint256 n) external view returns (uint ballotId) {
1861         return democs[democHash].allBallots[n];
1862     }
1863 
1864     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256) {
1865         return democs[democHash].includedBasicBallots.length;
1866     }
1867 
1868     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256) {
1869         return democs[democHash].includedBasicBallots[n];
1870     }
1871 
1872     function getDCategoriesN(bytes32 democHash) external view returns (uint) {
1873         return democCategories[democHash].nCategories;
1874     }
1875 
1876     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint256 parent) {
1877         deprecated = democCategories[democHash].categories[catId].deprecated;
1878         name = democCategories[democHash].categories[catId].name;
1879         hasParent = democCategories[democHash].categories[catId].hasParent;
1880         parent = democCategories[democHash].categories[catId].parent;
1881     }
1882 
1883     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool) {
1884         return !democs[democHash].communityBallotsDisabled;
1885     }
1886 
1887     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool) {
1888         return !democs[democHash].erc20OwnerClaimDisabled;
1889     }
1890 
1891     /* util for calculating editor key */
1892 
1893     function _calcEditorKey(bytes key) internal pure returns (bytes) {
1894         return abi.encodePacked("editor.", key);
1895     }
1896 }
1897 
1898 contract IxPaymentsIface is hasVersion, ixPaymentEvents, permissioned, CanReclaimToken, payoutAllCSettable {
1899     /* in emergency break glass */
1900     function emergencySetOwner(address newOwner) external;
1901 
1902     /* financial calcluations */
1903     function weiBuysHowManySeconds(uint amount) public view returns (uint secs);
1904     function weiToCents(uint w) public view returns (uint);
1905     function centsToWei(uint c) public view returns (uint);
1906 
1907     /* account management */
1908     function payForDemocracy(bytes32 democHash) external payable;
1909     function doFreeExtension(bytes32 democHash) external;
1910     function downgradeToBasic(bytes32 democHash) external;
1911     function upgradeToPremium(bytes32 democHash) external;
1912 
1913     /* account status - getters */
1914     function accountInGoodStanding(bytes32 democHash) external view returns (bool);
1915     function getSecondsRemaining(bytes32 democHash) external view returns (uint);
1916     function getPremiumStatus(bytes32 democHash) external view returns (bool);
1917     function getFreeExtension(bytes32 democHash) external view returns (bool);
1918     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension);
1919     function getDenyPremium(bytes32 democHash) external view returns (bool);
1920 
1921     /* admin utils for accounts */
1922     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) external;
1923 
1924     /* admin setters global */
1925     function setPayTo(address) external;
1926     function setMinorEditsAddr(address) external;
1927     function setBasicCentsPricePer30Days(uint amount) external;
1928     function setBasicBallotsPer30Days(uint amount) external;
1929     function setPremiumMultiplier(uint8 amount) external;
1930     function setWeiPerCent(uint) external;
1931     function setFreeExtension(bytes32 democHash, bool hasFreeExt) external;
1932     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) external;
1933     function setMinWeiForDInit(uint amount) external;
1934 
1935     /* global getters */
1936     function getBasicCentsPricePer30Days() external view returns(uint);
1937     function getBasicExtraBallotFeeWei() external view returns (uint);
1938     function getBasicBallotsPer30Days() external view returns (uint);
1939     function getPremiumMultiplier() external view returns (uint8);
1940     function getPremiumCentsPricePer30Days() external view returns (uint);
1941     function getWeiPerCent() external view returns (uint weiPerCent);
1942     function getUsdEthExchangeRate() external view returns (uint centsPerEth);
1943     function getMinWeiForDInit() external view returns (uint);
1944 
1945     /* payments stuff */
1946     function getPaymentLogN() external view returns (uint);
1947     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue);
1948 }
1949 
1950 contract SVPayments is IxPaymentsIface {
1951     uint constant VERSION = 2;
1952 
1953     struct Account {
1954         bool isPremium;
1955         uint lastPaymentTs;
1956         uint paidUpTill;
1957         uint lastUpgradeTs;  // timestamp of the last time it was upgraded to premium
1958     }
1959 
1960     struct PaymentLog {
1961         bool _external;
1962         bytes32 _democHash;
1963         uint _seconds;
1964         uint _ethValue;
1965     }
1966 
1967     // this is an address that's only allowed to make minor edits
1968     // e.g. setExchangeRate, setDenyPremium, giveTimeToDemoc
1969     address public minorEditsAddr;
1970 
1971     // payment details
1972     uint basicCentsPricePer30Days = 125000; // $1250/mo
1973     uint basicBallotsPer30Days = 10;
1974     uint8 premiumMultiplier = 5;
1975     uint weiPerCent = 0.000016583747 ether;  // $603, 4th June 2018
1976 
1977     uint minWeiForDInit = 1;  // minimum 1 wei - match existing behaviour in SVIndex
1978 
1979     mapping (bytes32 => Account) accounts;
1980     PaymentLog[] payments;
1981 
1982     // can set this on freeExtension democs to deny them premium upgrades
1983     mapping (bytes32 => bool) denyPremium;
1984     // this is used for non-profits or organisations that have perpetual licenses, etc
1985     mapping (bytes32 => bool) freeExtension;
1986 
1987 
1988     /* BREAK GLASS IN CASE OF EMERGENCY */
1989     // this is included here because something going wrong with payments is possibly
1990     // the absolute worst case. Note: does this have negligable benefit if the other
1991     // contracts are compromised? (e.g. by a leaked privkey)
1992     address public emergencyAdmin;
1993     function emergencySetOwner(address newOwner) external {
1994         require(msg.sender == emergencyAdmin, "!emergency-owner");
1995         owner = newOwner;
1996     }
1997     /* END BREAK GLASS */
1998 
1999 
2000     constructor(address _emergencyAdmin) payoutAllCSettable(msg.sender) public {
2001         emergencyAdmin = _emergencyAdmin;
2002         assert(_emergencyAdmin != address(0));
2003     }
2004 
2005     /* base SCs */
2006 
2007     function getVersion() external pure returns (uint) {
2008         return VERSION;
2009     }
2010 
2011     function() payable public {
2012         _getPayTo().transfer(msg.value);
2013     }
2014 
2015     function _modAccountBalance(bytes32 democHash, uint additionalSeconds) internal {
2016         uint prevPaidTill = accounts[democHash].paidUpTill;
2017         if (prevPaidTill < now) {
2018             prevPaidTill = now;
2019         }
2020 
2021         accounts[democHash].paidUpTill = prevPaidTill + additionalSeconds;
2022         accounts[democHash].lastPaymentTs = now;
2023     }
2024 
2025     /* Financial Calculations */
2026 
2027     function weiBuysHowManySeconds(uint amount) public view returns (uint) {
2028         uint centsPaid = weiToCents(amount);
2029         // multiply by 10**18 to ensure we make rounding errors insignificant
2030         uint monthsOffsetPaid = ((10 ** 18) * centsPaid) / basicCentsPricePer30Days;
2031         uint secondsOffsetPaid = monthsOffsetPaid * (30 days);
2032         uint additionalSeconds = secondsOffsetPaid / (10 ** 18);
2033         return additionalSeconds;
2034     }
2035 
2036     function weiToCents(uint w) public view returns (uint) {
2037         return w / weiPerCent;
2038     }
2039 
2040     function centsToWei(uint c) public view returns (uint) {
2041         return c * weiPerCent;
2042     }
2043 
2044     /* account management */
2045 
2046     function payForDemocracy(bytes32 democHash) external payable {
2047         require(msg.value > 0, "need to send some ether to make payment");
2048 
2049         uint additionalSeconds = weiBuysHowManySeconds(msg.value);
2050 
2051         if (accounts[democHash].isPremium) {
2052             additionalSeconds /= premiumMultiplier;
2053         }
2054 
2055         if (additionalSeconds >= 1) {
2056             _modAccountBalance(democHash, additionalSeconds);
2057         }
2058         payments.push(PaymentLog(false, democHash, additionalSeconds, msg.value));
2059         emit AccountPayment(democHash, additionalSeconds);
2060 
2061         _getPayTo().transfer(msg.value);
2062     }
2063 
2064     function doFreeExtension(bytes32 democHash) external {
2065         require(freeExtension[democHash], "!free");
2066         uint newPaidUpTill = now + 60 days;
2067         accounts[democHash].paidUpTill = newPaidUpTill;
2068         emit FreeExtension(democHash);
2069     }
2070 
2071     function downgradeToBasic(bytes32 democHash) only_editors() external {
2072         require(accounts[democHash].isPremium, "!premium");
2073         accounts[democHash].isPremium = false;
2074         // convert premium minutes to basic
2075         uint paidTill = accounts[democHash].paidUpTill;
2076         uint timeRemaining = SafeMath.subToZero(paidTill, now);
2077         // if we have time remaining: convert it
2078         if (timeRemaining > 0) {
2079             // prevent accounts from downgrading if they have time remaining
2080             // and upgraded less than 24hrs ago
2081             require(accounts[democHash].lastUpgradeTs < (now - 24 hours), "downgrade-too-soon");
2082             timeRemaining *= premiumMultiplier;
2083             accounts[democHash].paidUpTill = now + timeRemaining;
2084         }
2085         emit DowngradeToBasic(democHash);
2086     }
2087 
2088     function upgradeToPremium(bytes32 democHash) only_editors() external {
2089         require(denyPremium[democHash] == false, "upgrade-denied");
2090         require(!accounts[democHash].isPremium, "!basic");
2091         accounts[democHash].isPremium = true;
2092         // convert basic minutes to premium minutes
2093         uint paidTill = accounts[democHash].paidUpTill;
2094         uint timeRemaining = SafeMath.subToZero(paidTill, now);
2095         // if we have time remaning then convert it - otherwise don't need to do anything
2096         if (timeRemaining > 0) {
2097             timeRemaining /= premiumMultiplier;
2098             accounts[democHash].paidUpTill = now + timeRemaining;
2099         }
2100         accounts[democHash].lastUpgradeTs = now;
2101         emit UpgradedToPremium(democHash);
2102     }
2103 
2104     /* account status - getters */
2105 
2106     function accountInGoodStanding(bytes32 democHash) external view returns (bool) {
2107         return accounts[democHash].paidUpTill >= now;
2108     }
2109 
2110     function getSecondsRemaining(bytes32 democHash) external view returns (uint) {
2111         return SafeMath.subToZero(accounts[democHash].paidUpTill, now);
2112     }
2113 
2114     function getPremiumStatus(bytes32 democHash) external view returns (bool) {
2115         return accounts[democHash].isPremium;
2116     }
2117 
2118     function getFreeExtension(bytes32 democHash) external view returns (bool) {
2119         return freeExtension[democHash];
2120     }
2121 
2122     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension) {
2123         isPremium = accounts[democHash].isPremium;
2124         lastPaymentTs = accounts[democHash].lastPaymentTs;
2125         paidUpTill = accounts[democHash].paidUpTill;
2126         hasFreeExtension = freeExtension[democHash];
2127     }
2128 
2129     function getDenyPremium(bytes32 democHash) external view returns (bool) {
2130         return denyPremium[democHash];
2131     }
2132 
2133     /* admin utils for accounts */
2134 
2135     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) owner_or(minorEditsAddr) external {
2136         _modAccountBalance(democHash, additionalSeconds);
2137         payments.push(PaymentLog(true, democHash, additionalSeconds, 0));
2138         emit GrantedAccountTime(democHash, additionalSeconds, ref);
2139     }
2140 
2141     /* admin setters global */
2142 
2143     function setPayTo(address newPayTo) only_owner() external {
2144         _setPayTo(newPayTo);
2145         emit SetPayTo(newPayTo);
2146     }
2147 
2148     function setMinorEditsAddr(address a) only_owner() external {
2149         minorEditsAddr = a;
2150         emit SetMinorEditsAddr(a);
2151     }
2152 
2153     function setBasicCentsPricePer30Days(uint amount) only_owner() external {
2154         basicCentsPricePer30Days = amount;
2155         emit SetBasicCentsPricePer30Days(amount);
2156     }
2157 
2158     function setBasicBallotsPer30Days(uint amount) only_owner() external {
2159         basicBallotsPer30Days = amount;
2160         emit SetBallotsPer30Days(amount);
2161     }
2162 
2163     function setPremiumMultiplier(uint8 m) only_owner() external {
2164         premiumMultiplier = m;
2165         emit SetPremiumMultiplier(m);
2166     }
2167 
2168     function setWeiPerCent(uint wpc) owner_or(minorEditsAddr) external {
2169         weiPerCent = wpc;
2170         emit SetExchangeRate(wpc);
2171     }
2172 
2173     function setFreeExtension(bytes32 democHash, bool hasFreeExt) owner_or(minorEditsAddr) external {
2174         freeExtension[democHash] = hasFreeExt;
2175         emit SetFreeExtension(democHash, hasFreeExt);
2176     }
2177 
2178     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) owner_or(minorEditsAddr) external {
2179         denyPremium[democHash] = isPremiumDenied;
2180         emit SetDenyPremium(democHash, isPremiumDenied);
2181     }
2182 
2183     function setMinWeiForDInit(uint amount) owner_or(minorEditsAddr) external {
2184         minWeiForDInit = amount;
2185         emit SetMinWeiForDInit(amount);
2186     }
2187 
2188     /* global getters */
2189 
2190     function getBasicCentsPricePer30Days() external view returns (uint) {
2191         return basicCentsPricePer30Days;
2192     }
2193 
2194     function getBasicExtraBallotFeeWei() external view returns (uint) {
2195         return centsToWei(basicCentsPricePer30Days / basicBallotsPer30Days);
2196     }
2197 
2198     function getBasicBallotsPer30Days() external view returns (uint) {
2199         return basicBallotsPer30Days;
2200     }
2201 
2202     function getPremiumMultiplier() external view returns (uint8) {
2203         return premiumMultiplier;
2204     }
2205 
2206     function getPremiumCentsPricePer30Days() external view returns (uint) {
2207         return _premiumPricePer30Days();
2208     }
2209 
2210     function _premiumPricePer30Days() internal view returns (uint) {
2211         return uint(premiumMultiplier) * basicCentsPricePer30Days;
2212     }
2213 
2214     function getWeiPerCent() external view returns (uint) {
2215         return weiPerCent;
2216     }
2217 
2218     function getUsdEthExchangeRate() external view returns (uint) {
2219         // this returns cents per ether
2220         return 1 ether / weiPerCent;
2221     }
2222 
2223     function getMinWeiForDInit() external view returns (uint) {
2224         return minWeiForDInit;
2225     }
2226 
2227     /* payments stuff */
2228 
2229     function getPaymentLogN() external view returns (uint) {
2230         return payments.length;
2231     }
2232 
2233     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue) {
2234         _external = payments[n]._external;
2235         _democHash = payments[n]._democHash;
2236         _seconds = payments[n]._seconds;
2237         _ethValue = payments[n]._ethValue;
2238     }
2239 }
2240 
2241 interface SvEnsIface {
2242     // Logged when the owner of a node assigns a new owner to a subnode.
2243     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2244 
2245     // Logged when the owner of a node transfers ownership to a new account.
2246     event Transfer(bytes32 indexed node, address owner);
2247 
2248     // Logged when the resolver for a node changes.
2249     event NewResolver(bytes32 indexed node, address resolver);
2250 
2251     // Logged when the TTL of a node changes
2252     event NewTTL(bytes32 indexed node, uint64 ttl);
2253 
2254 
2255     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
2256     function setResolver(bytes32 node, address resolver) external;
2257     function setOwner(bytes32 node, address owner) external;
2258     function setTTL(bytes32 node, uint64 ttl) external;
2259     function owner(bytes32 node) external view returns (address);
2260     function resolver(bytes32 node) external view returns (address);
2261     function ttl(bytes32 node) external view returns (uint64);
2262 }
2263 
2264 interface ENSIface {
2265     // Logged when the owner of a node assigns a new owner to a subnode.
2266     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2267 
2268     // Logged when the owner of a node transfers ownership to a new account.
2269     event Transfer(bytes32 indexed node, address owner);
2270 
2271     // Logged when the resolver for a node changes.
2272     event NewResolver(bytes32 indexed node, address resolver);
2273 
2274     // Logged when the TTL of a node changes
2275     event NewTTL(bytes32 indexed node, uint64 ttl);
2276 
2277 
2278     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
2279     function setResolver(bytes32 node, address resolver) external;
2280     function setOwner(bytes32 node, address owner) external;
2281     function setTTL(bytes32 node, uint64 ttl) external;
2282     function owner(bytes32 node) external view returns (address);
2283     function resolver(bytes32 node) external view returns (address);
2284     function ttl(bytes32 node) external view returns (uint64);
2285 }
2286 
2287 contract PublicResolver {
2288 
2289     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
2290     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
2291     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
2292     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
2293     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
2294     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
2295     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
2296 
2297     event AddrChanged(bytes32 indexed node, address a);
2298     event ContentChanged(bytes32 indexed node, bytes32 hash);
2299     event NameChanged(bytes32 indexed node, string name);
2300     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
2301     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
2302     event TextChanged(bytes32 indexed node, string indexedKey, string key);
2303 
2304     struct PublicKey {
2305         bytes32 x;
2306         bytes32 y;
2307     }
2308 
2309     struct Record {
2310         address addr;
2311         bytes32 content;
2312         string name;
2313         PublicKey pubkey;
2314         mapping(string=>string) text;
2315         mapping(uint256=>bytes) abis;
2316     }
2317 
2318     ENSIface ens;
2319 
2320     mapping (bytes32 => Record) records;
2321 
2322     modifier only_owner(bytes32 node) {
2323         require(ens.owner(node) == msg.sender);
2324         _;
2325     }
2326 
2327     /**
2328      * Constructor.
2329      * @param ensAddr The ENS registrar contract.
2330      */
2331     constructor(ENSIface ensAddr) public {
2332         ens = ensAddr;
2333     }
2334 
2335     /**
2336      * Sets the address associated with an ENS node.
2337      * May only be called by the owner of that node in the ENS registry.
2338      * @param node The node to update.
2339      * @param addr The address to set.
2340      */
2341     function setAddr(bytes32 node, address addr) public only_owner(node) {
2342         records[node].addr = addr;
2343         emit AddrChanged(node, addr);
2344     }
2345 
2346     /**
2347      * Sets the content hash associated with an ENS node.
2348      * May only be called by the owner of that node in the ENS registry.
2349      * Note that this resource type is not standardized, and will likely change
2350      * in future to a resource type based on multihash.
2351      * @param node The node to update.
2352      * @param hash The content hash to set
2353      */
2354     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
2355         records[node].content = hash;
2356         emit ContentChanged(node, hash);
2357     }
2358 
2359     /**
2360      * Sets the name associated with an ENS node, for reverse records.
2361      * May only be called by the owner of that node in the ENS registry.
2362      * @param node The node to update.
2363      * @param name The name to set.
2364      */
2365     function setName(bytes32 node, string name) public only_owner(node) {
2366         records[node].name = name;
2367         emit NameChanged(node, name);
2368     }
2369 
2370     /**
2371      * Sets the ABI associated with an ENS node.
2372      * Nodes may have one ABI of each content type. To remove an ABI, set it to
2373      * the empty string.
2374      * @param node The node to update.
2375      * @param contentType The content type of the ABI
2376      * @param data The ABI data.
2377      */
2378     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
2379         // Content types must be powers of 2
2380         require(((contentType - 1) & contentType) == 0);
2381 
2382         records[node].abis[contentType] = data;
2383         emit ABIChanged(node, contentType);
2384     }
2385 
2386     /**
2387      * Sets the SECP256k1 public key associated with an ENS node.
2388      * @param node The ENS node to query
2389      * @param x the X coordinate of the curve point for the public key.
2390      * @param y the Y coordinate of the curve point for the public key.
2391      */
2392     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
2393         records[node].pubkey = PublicKey(x, y);
2394         emit PubkeyChanged(node, x, y);
2395     }
2396 
2397     /**
2398      * Sets the text data associated with an ENS node and key.
2399      * May only be called by the owner of that node in the ENS registry.
2400      * @param node The node to update.
2401      * @param key The key to set.
2402      * @param value The text data value to set.
2403      */
2404     function setText(bytes32 node, string key, string value) public only_owner(node) {
2405         records[node].text[key] = value;
2406         emit TextChanged(node, key, key);
2407     }
2408 
2409     /**
2410      * Returns the text data associated with an ENS node and key.
2411      * @param node The ENS node to query.
2412      * @param key The text data key to query.
2413      * @return The associated text data.
2414      */
2415     function text(bytes32 node, string key) public view returns (string) {
2416         return records[node].text[key];
2417     }
2418 
2419     /**
2420      * Returns the SECP256k1 public key associated with an ENS node.
2421      * Defined in EIP 619.
2422      * @param node The ENS node to query
2423      * @return x, y the X and Y coordinates of the curve point for the public key.
2424      */
2425     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
2426         return (records[node].pubkey.x, records[node].pubkey.y);
2427     }
2428 
2429     /**
2430      * Returns the ABI associated with an ENS node.
2431      * Defined in EIP205.
2432      * @param node The ENS node to query
2433      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
2434      * @return contentType The content type of the return value
2435      * @return data The ABI data
2436      */
2437     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
2438         Record storage record = records[node];
2439         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
2440             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
2441                 data = record.abis[contentType];
2442                 return;
2443             }
2444         }
2445         contentType = 0;
2446     }
2447 
2448     /**
2449      * Returns the name associated with an ENS node, for reverse records.
2450      * Defined in EIP181.
2451      * @param node The ENS node to query.
2452      * @return The associated name.
2453      */
2454     function name(bytes32 node) public view returns (string) {
2455         return records[node].name;
2456     }
2457 
2458     /**
2459      * Returns the content hash associated with an ENS node.
2460      * Note that this resource type is not standardized, and will likely change
2461      * in future to a resource type based on multihash.
2462      * @param node The ENS node to query.
2463      * @return The associated content hash.
2464      */
2465     function content(bytes32 node) public view returns (bytes32) {
2466         return records[node].content;
2467     }
2468 
2469     /**
2470      * Returns the address associated with an ENS node.
2471      * @param node The ENS node to query.
2472      * @return The associated address.
2473      */
2474     function addr(bytes32 node) public view returns (address) {
2475         return records[node].addr;
2476     }
2477 
2478     /**
2479      * Returns true if the resolver implements the interface specified by the provided hash.
2480      * @param interfaceID The ID of the interface to check for.
2481      * @return True if the contract implements the requested interface.
2482      */
2483     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
2484         return interfaceID == ADDR_INTERFACE_ID ||
2485         interfaceID == CONTENT_INTERFACE_ID ||
2486         interfaceID == NAME_INTERFACE_ID ||
2487         interfaceID == ABI_INTERFACE_ID ||
2488         interfaceID == PUBKEY_INTERFACE_ID ||
2489         interfaceID == TEXT_INTERFACE_ID ||
2490         interfaceID == INTERFACE_META_ID;
2491     }
2492 }
2493 
2494 library BytesLib {
2495     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
2496         bytes memory tempBytes;
2497 
2498         assembly {
2499             // Get a location of some free memory and store it in tempBytes as
2500             // Solidity does for memory variables.
2501             tempBytes := mload(0x40)
2502 
2503             // Store the length of the first bytes array at the beginning of
2504             // the memory for tempBytes.
2505             let length := mload(_preBytes)
2506             mstore(tempBytes, length)
2507 
2508             // Maintain a memory counter for the current write location in the
2509             // temp bytes array by adding the 32 bytes for the array length to
2510             // the starting location.
2511             let mc := add(tempBytes, 0x20)
2512             // Stop copying when the memory counter reaches the length of the
2513             // first bytes array.
2514             let end := add(mc, length)
2515 
2516             for {
2517                 // Initialize a copy counter to the start of the _preBytes data,
2518                 // 32 bytes into its memory.
2519                 let cc := add(_preBytes, 0x20)
2520             } lt(mc, end) {
2521                 // Increase both counters by 32 bytes each iteration.
2522                 mc := add(mc, 0x20)
2523                 cc := add(cc, 0x20)
2524             } {
2525                 // Write the _preBytes data into the tempBytes memory 32 bytes
2526                 // at a time.
2527                 mstore(mc, mload(cc))
2528             }
2529 
2530             // Add the length of _postBytes to the current length of tempBytes
2531             // and store it as the new length in the first 32 bytes of the
2532             // tempBytes memory.
2533             length := mload(_postBytes)
2534             mstore(tempBytes, add(length, mload(tempBytes)))
2535 
2536             // Move the memory counter back from a multiple of 0x20 to the
2537             // actual end of the _preBytes data.
2538             mc := end
2539             // Stop copying when the memory counter reaches the new combined
2540             // length of the arrays.
2541             end := add(mc, length)
2542 
2543             for {
2544                 let cc := add(_postBytes, 0x20)
2545             } lt(mc, end) {
2546                 mc := add(mc, 0x20)
2547                 cc := add(cc, 0x20)
2548             } {
2549                 mstore(mc, mload(cc))
2550             }
2551 
2552             // Update the free-memory pointer by padding our last write location
2553             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
2554             // next 32 byte block, then round down to the nearest multiple of
2555             // 32. If the sum of the length of the two arrays is zero then add
2556             // one before rounding down to leave a blank 32 bytes (the length block with 0).
2557             mstore(0x40, and(
2558               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
2559               not(31) // Round down to the nearest 32 bytes.
2560             ))
2561         }
2562 
2563         return tempBytes;
2564     }
2565 
2566     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
2567         assembly {
2568             // Read the first 32 bytes of _preBytes storage, which is the length
2569             // of the array. (We don't need to use the offset into the slot
2570             // because arrays use the entire slot.)
2571             let fslot := sload(_preBytes_slot)
2572             // Arrays of 31 bytes or less have an even value in their slot,
2573             // while longer arrays have an odd value. The actual length is
2574             // the slot divided by two for odd values, and the lowest order
2575             // byte divided by two for even values.
2576             // If the slot is even, bitwise and the slot with 255 and divide by
2577             // two to get the length. If the slot is odd, bitwise and the slot
2578             // with -1 and divide by two.
2579             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
2580             let mlength := mload(_postBytes)
2581             let newlength := add(slength, mlength)
2582             // slength can contain both the length and contents of the array
2583             // if length < 32 bytes so let's prepare for that
2584             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
2585             switch add(lt(slength, 32), lt(newlength, 32))
2586             case 2 {
2587                 // Since the new array still fits in the slot, we just need to
2588                 // update the contents of the slot.
2589                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
2590                 sstore(
2591                     _preBytes_slot,
2592                     // all the modifications to the slot are inside this
2593                     // next block
2594                     add(
2595                         // we can just add to the slot contents because the
2596                         // bytes we want to change are the LSBs
2597                         fslot,
2598                         add(
2599                             mul(
2600                                 div(
2601                                     // load the bytes from memory
2602                                     mload(add(_postBytes, 0x20)),
2603                                     // zero all bytes to the right
2604                                     exp(0x100, sub(32, mlength))
2605                                 ),
2606                                 // and now shift left the number of bytes to
2607                                 // leave space for the length in the slot
2608                                 exp(0x100, sub(32, newlength))
2609                             ),
2610                             // increase length by the double of the memory
2611                             // bytes length
2612                             mul(mlength, 2)
2613                         )
2614                     )
2615                 )
2616             }
2617             case 1 {
2618                 // The stored value fits in the slot, but the combined value
2619                 // will exceed it.
2620                 // get the keccak hash to get the contents of the array
2621                 mstore(0x0, _preBytes_slot)
2622                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
2623 
2624                 // save new length
2625                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
2626 
2627                 // The contents of the _postBytes array start 32 bytes into
2628                 // the structure. Our first read should obtain the `submod`
2629                 // bytes that can fit into the unused space in the last word
2630                 // of the stored array. To get this, we read 32 bytes starting
2631                 // from `submod`, so the data we read overlaps with the array
2632                 // contents by `submod` bytes. Masking the lowest-order
2633                 // `submod` bytes allows us to add that value directly to the
2634                 // stored value.
2635 
2636                 let submod := sub(32, slength)
2637                 let mc := add(_postBytes, submod)
2638                 let end := add(_postBytes, mlength)
2639                 let mask := sub(exp(0x100, submod), 1)
2640 
2641                 sstore(
2642                     sc,
2643                     add(
2644                         and(
2645                             fslot,
2646                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
2647                         ),
2648                         and(mload(mc), mask)
2649                     )
2650                 )
2651 
2652                 for {
2653                     mc := add(mc, 0x20)
2654                     sc := add(sc, 1)
2655                 } lt(mc, end) {
2656                     sc := add(sc, 1)
2657                     mc := add(mc, 0x20)
2658                 } {
2659                     sstore(sc, mload(mc))
2660                 }
2661 
2662                 mask := exp(0x100, sub(mc, end))
2663 
2664                 sstore(sc, mul(div(mload(mc), mask), mask))
2665             }
2666             default {
2667                 // get the keccak hash to get the contents of the array
2668                 mstore(0x0, _preBytes_slot)
2669                 // Start copying to the last used word of the stored array.
2670                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
2671 
2672                 // save new length
2673                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
2674 
2675                 // Copy over the first `submod` bytes of the new data as in
2676                 // case 1 above.
2677                 let slengthmod := mod(slength, 32)
2678                 let mlengthmod := mod(mlength, 32)
2679                 let submod := sub(32, slengthmod)
2680                 let mc := add(_postBytes, submod)
2681                 let end := add(_postBytes, mlength)
2682                 let mask := sub(exp(0x100, submod), 1)
2683 
2684                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
2685 
2686                 for {
2687                     sc := add(sc, 1)
2688                     mc := add(mc, 0x20)
2689                 } lt(mc, end) {
2690                     sc := add(sc, 1)
2691                     mc := add(mc, 0x20)
2692                 } {
2693                     sstore(sc, mload(mc))
2694                 }
2695 
2696                 mask := exp(0x100, sub(mc, end))
2697 
2698                 sstore(sc, mul(div(mload(mc), mask), mask))
2699             }
2700         }
2701     }
2702 
2703     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
2704         require(_bytes.length >= (_start + _length));
2705 
2706         bytes memory tempBytes;
2707 
2708         assembly {
2709             switch iszero(_length)
2710             case 0 {
2711                 // Get a location of some free memory and store it in tempBytes as
2712                 // Solidity does for memory variables.
2713                 tempBytes := mload(0x40)
2714 
2715                 // The first word of the slice result is potentially a partial
2716                 // word read from the original array. To read it, we calculate
2717                 // the length of that partial word and start copying that many
2718                 // bytes into the array. The first word we copy will start with
2719                 // data we don't care about, but the last `lengthmod` bytes will
2720                 // land at the beginning of the contents of the new array. When
2721                 // we're done copying, we overwrite the full first word with
2722                 // the actual length of the slice.
2723                 let lengthmod := and(_length, 31)
2724 
2725                 // The multiplication in the next line is necessary
2726                 // because when slicing multiples of 32 bytes (lengthmod == 0)
2727                 // the following copy loop was copying the origin's length
2728                 // and then ending prematurely not copying everything it should.
2729                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
2730                 let end := add(mc, _length)
2731 
2732                 for {
2733                     // The multiplication in the next line has the same exact purpose
2734                     // as the one above.
2735                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
2736                 } lt(mc, end) {
2737                     mc := add(mc, 0x20)
2738                     cc := add(cc, 0x20)
2739                 } {
2740                     mstore(mc, mload(cc))
2741                 }
2742 
2743                 mstore(tempBytes, _length)
2744 
2745                 //update free-memory pointer
2746                 //allocating the array padded to 32 bytes like the compiler does now
2747                 mstore(0x40, and(add(mc, 31), not(31)))
2748             }
2749             //if we want a zero-length slice let's just return a zero-length array
2750             default {
2751                 tempBytes := mload(0x40)
2752 
2753                 mstore(0x40, add(tempBytes, 0x20))
2754             }
2755         }
2756 
2757         return tempBytes;
2758     }
2759 
2760     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
2761         require(_bytes.length >= (_start + 20));
2762         address tempAddress;
2763 
2764         assembly {
2765             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
2766         }
2767 
2768         return tempAddress;
2769     }
2770 
2771     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
2772         require(_bytes.length >= (_start + 32));
2773         uint256 tempUint;
2774 
2775         assembly {
2776             tempUint := mload(add(add(_bytes, 0x20), _start))
2777         }
2778 
2779         return tempUint;
2780     }
2781 
2782     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
2783         bool success = true;
2784 
2785         assembly {
2786             let length := mload(_preBytes)
2787 
2788             // if lengths don't match the arrays are not equal
2789             switch eq(length, mload(_postBytes))
2790             case 1 {
2791                 // cb is a circuit breaker in the for loop since there's
2792                 //  no said feature for inline assembly loops
2793                 // cb = 1 - don't breaker
2794                 // cb = 0 - break
2795                 let cb := 1
2796 
2797                 let mc := add(_preBytes, 0x20)
2798                 let end := add(mc, length)
2799 
2800                 for {
2801                     let cc := add(_postBytes, 0x20)
2802                 // the next line is the loop condition:
2803                 // while(uint(mc < end) + cb == 2)
2804                 } eq(add(lt(mc, end), cb), 2) {
2805                     mc := add(mc, 0x20)
2806                     cc := add(cc, 0x20)
2807                 } {
2808                     // if any of these checks fails then arrays are not equal
2809                     if iszero(eq(mload(mc), mload(cc))) {
2810                         // unsuccess:
2811                         success := 0
2812                         cb := 0
2813                     }
2814                 }
2815             }
2816             default {
2817                 // unsuccess:
2818                 success := 0
2819             }
2820         }
2821 
2822         return success;
2823     }
2824 
2825     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
2826         bool success = true;
2827 
2828         assembly {
2829             // we know _preBytes_offset is 0
2830             let fslot := sload(_preBytes_slot)
2831             // Decode the length of the stored array like in concatStorage().
2832             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
2833             let mlength := mload(_postBytes)
2834 
2835             // if lengths don't match the arrays are not equal
2836             switch eq(slength, mlength)
2837             case 1 {
2838                 // slength can contain both the length and contents of the array
2839                 // if length < 32 bytes so let's prepare for that
2840                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
2841                 if iszero(iszero(slength)) {
2842                     switch lt(slength, 32)
2843                     case 1 {
2844                         // blank the last byte which is the length
2845                         fslot := mul(div(fslot, 0x100), 0x100)
2846 
2847                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
2848                             // unsuccess:
2849                             success := 0
2850                         }
2851                     }
2852                     default {
2853                         // cb is a circuit breaker in the for loop since there's
2854                         //  no said feature for inline assembly loops
2855                         // cb = 1 - don't breaker
2856                         // cb = 0 - break
2857                         let cb := 1
2858 
2859                         // get the keccak hash to get the contents of the array
2860                         mstore(0x0, _preBytes_slot)
2861                         let sc := keccak256(0x0, 0x20)
2862 
2863                         let mc := add(_postBytes, 0x20)
2864                         let end := add(mc, mlength)
2865 
2866                         // the next line is the loop condition:
2867                         // while(uint(mc < end) + cb == 2)
2868                         for {} eq(add(lt(mc, end), cb), 2) {
2869                             sc := add(sc, 1)
2870                             mc := add(mc, 0x20)
2871                         } {
2872                             if iszero(eq(sload(sc), mload(mc))) {
2873                                 // unsuccess:
2874                                 success := 0
2875                                 cb := 0
2876                             }
2877                         }
2878                     }
2879                 }
2880             }
2881             default {
2882                 // unsuccess:
2883                 success := 0
2884             }
2885         }
2886 
2887         return success;
2888     }
2889 }