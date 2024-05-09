1 pragma solidity 0.4.24;
2 
3 library BPackedUtils {
4 
5     // the uint16 ending at 128 bits should be 0s
6     uint256 constant sbMask        = 0xffffffffffffffffffffffffffff0000ffffffffffffffffffffffffffffffff;
7     uint256 constant startTimeMask = 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff;
8     uint256 constant endTimeMask   = 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
9 
10     function packedToSubmissionBits(uint256 packed) internal pure returns (uint16) {
11         return uint16(packed >> 128);
12     }
13 
14     function packedToStartTime(uint256 packed) internal pure returns (uint64) {
15         return uint64(packed >> 64);
16     }
17 
18     function packedToEndTime(uint256 packed) internal pure returns (uint64) {
19         return uint64(packed);
20     }
21 
22     function unpackAll(uint256 packed) internal pure returns (uint16 submissionBits, uint64 startTime, uint64 endTime) {
23         submissionBits = uint16(packed >> 128);
24         startTime = uint64(packed >> 64);
25         endTime = uint64(packed);
26     }
27 
28     function pack(uint16 sb, uint64 st, uint64 et) internal pure returns (uint256 packed) {
29         return uint256(sb) << 128 | uint256(st) << 64 | uint256(et);
30     }
31 
32     function setSB(uint256 packed, uint16 newSB) internal pure returns (uint256) {
33         return (packed & sbMask) | uint256(newSB) << 128;
34     }
35 
36     // function setStartTime(uint256 packed, uint64 startTime) internal pure returns (uint256) {
37     //     return (packed & startTimeMask) | uint256(startTime) << 64;
38     // }
39 
40     // function setEndTime(uint256 packed, uint64 endTime) internal pure returns (uint256) {
41     //     return (packed & endTimeMask) | uint256(endTime);
42     // }
43 }
44 
45 contract safeSend {
46     bool private txMutex3847834;
47 
48     // we want to be able to call outside contracts (e.g. the admin proxy contract)
49     // but reentrency is bad, so here's a mutex.
50     function doSafeSend(address toAddr, uint amount) internal {
51         doSafeSendWData(toAddr, "", amount);
52     }
53 
54     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
55         require(txMutex3847834 == false, "ss-guard");
56         txMutex3847834 = true;
57         // we need to use address.call.value(v)() because we want
58         // to be able to send to other contracts, even with no data,
59         // which might use more than 2300 gas in their fallback function.
60         require(toAddr.call.value(amount)(data), "ss-failed");
61         txMutex3847834 = false;
62     }
63 }
64 
65 contract payoutAllC is safeSend {
66     address private _payTo;
67 
68     event PayoutAll(address payTo, uint value);
69 
70     constructor(address initPayTo) public {
71         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
72         assert(initPayTo != address(0));
73         _payTo = initPayTo;
74     }
75 
76     function _getPayTo() internal view returns (address) {
77         return _payTo;
78     }
79 
80     function _setPayTo(address newPayTo) internal {
81         _payTo = newPayTo;
82     }
83 
84     function payoutAll() external {
85         address a = _getPayTo();
86         uint bal = address(this).balance;
87         doSafeSend(a, bal);
88         emit PayoutAll(a, bal);
89     }
90 }
91 
92 contract payoutAllCSettable is payoutAllC {
93     constructor (address initPayTo) payoutAllC(initPayTo) public {
94     }
95 
96     function setPayTo(address) external;
97     function getPayTo() external view returns (address) {
98         return _getPayTo();
99     }
100 }
101 
102 contract owned {
103     address public owner;
104 
105     event OwnerChanged(address newOwner);
106 
107     modifier only_owner() {
108         require(msg.sender == owner, "only_owner: forbidden");
109         _;
110     }
111 
112     modifier owner_or(address addr) {
113         require(msg.sender == addr || msg.sender == owner, "!owner-or");
114         _;
115     }
116 
117     constructor() public {
118         owner = msg.sender;
119     }
120 
121     function setOwner(address newOwner) only_owner() external {
122         owner = newOwner;
123         emit OwnerChanged(newOwner);
124     }
125 }
126 
127 contract controlledIface {
128     function controller() external view returns (address);
129 }
130 
131 contract hasAdmins is owned {
132     mapping (uint => mapping (address => bool)) admins;
133     uint public currAdminEpoch = 0;
134     bool public adminsDisabledForever = false;
135     address[] adminLog;
136 
137     event AdminAdded(address indexed newAdmin);
138     event AdminRemoved(address indexed oldAdmin);
139     event AdminEpochInc();
140     event AdminDisabledForever();
141 
142     modifier only_admin() {
143         require(adminsDisabledForever == false, "admins must not be disabled");
144         require(isAdmin(msg.sender), "only_admin: forbidden");
145         _;
146     }
147 
148     constructor() public {
149         _setAdmin(msg.sender, true);
150     }
151 
152     function isAdmin(address a) view public returns (bool) {
153         return admins[currAdminEpoch][a];
154     }
155 
156     function getAdminLogN() view external returns (uint) {
157         return adminLog.length;
158     }
159 
160     function getAdminLog(uint n) view external returns (address) {
161         return adminLog[n];
162     }
163 
164     function upgradeMeAdmin(address newAdmin) only_admin() external {
165         // note: already checked msg.sender has admin with `only_admin` modifier
166         require(msg.sender != owner, "owner cannot upgrade self");
167         _setAdmin(msg.sender, false);
168         _setAdmin(newAdmin, true);
169     }
170 
171     function setAdmin(address a, bool _givePerms) only_admin() external {
172         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
173         _setAdmin(a, _givePerms);
174     }
175 
176     function _setAdmin(address a, bool _givePerms) internal {
177         admins[currAdminEpoch][a] = _givePerms;
178         if (_givePerms) {
179             emit AdminAdded(a);
180             adminLog.push(a);
181         } else {
182             emit AdminRemoved(a);
183         }
184     }
185 
186     // safety feature if admins go bad or something
187     function incAdminEpoch() only_owner() external {
188         currAdminEpoch++;
189         admins[currAdminEpoch][msg.sender] = true;
190         emit AdminEpochInc();
191     }
192 
193     // this is internal so contracts can all it, but not exposed anywhere in this
194     // contract.
195     function disableAdminForever() internal {
196         currAdminEpoch++;
197         adminsDisabledForever = true;
198         emit AdminDisabledForever();
199     }
200 }
201 
202 contract permissioned is owned, hasAdmins {
203     mapping (address => bool) editAllowed;
204     bool public adminLockdown = false;
205 
206     event PermissionError(address editAddr);
207     event PermissionGranted(address editAddr);
208     event PermissionRevoked(address editAddr);
209     event PermissionsUpgraded(address oldSC, address newSC);
210     event SelfUpgrade(address oldSC, address newSC);
211     event AdminLockdown();
212 
213     modifier only_editors() {
214         require(editAllowed[msg.sender], "only_editors: forbidden");
215         _;
216     }
217 
218     modifier no_lockdown() {
219         require(adminLockdown == false, "no_lockdown: check failed");
220         _;
221     }
222 
223 
224     constructor() owned() hasAdmins() public {
225     }
226 
227 
228     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
229         editAllowed[e] = _editPerms;
230         if (_editPerms)
231             emit PermissionGranted(e);
232         else
233             emit PermissionRevoked(e);
234     }
235 
236     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
237         editAllowed[oldSC] = false;
238         editAllowed[newSC] = true;
239         emit PermissionsUpgraded(oldSC, newSC);
240     }
241 
242     // always allow SCs to upgrade themselves, even after lockdown
243     function upgradeMe(address newSC) only_editors() external {
244         editAllowed[msg.sender] = false;
245         editAllowed[newSC] = true;
246         emit SelfUpgrade(msg.sender, newSC);
247     }
248 
249     function hasPermissions(address a) public view returns (bool) {
250         return editAllowed[a];
251     }
252 
253     function doLockdown() external only_owner() no_lockdown() {
254         disableAdminForever();
255         adminLockdown = true;
256         emit AdminLockdown();
257     }
258 }
259 
260 contract upgradePtr {
261     address ptr = address(0);
262 
263     modifier not_upgraded() {
264         require(ptr == address(0), "upgrade pointer is non-zero");
265         _;
266     }
267 
268     function getUpgradePointer() view external returns (address) {
269         return ptr;
270     }
271 
272     function doUpgradeInternal(address nextSC) internal {
273         ptr = nextSC;
274     }
275 }
276 
277 interface ERC20Interface {
278     // Get the total token supply
279     function totalSupply() constant external returns (uint256 _totalSupply);
280 
281     // Get the account balance of another account with address _owner
282     function balanceOf(address _owner) constant external returns (uint256 balance);
283 
284     // Send _value amount of tokens to address _to
285     function transfer(address _to, uint256 _value) external returns (bool success);
286 
287     // Send _value amount of tokens from address _from to address _to
288     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
289 
290     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
291     // If this function is called again it overwrites the current allowance with _value.
292     // this function is required for some DEX functionality
293     function approve(address _spender, uint256 _value) external returns (bool success);
294 
295     // Returns the amount which _spender is still allowed to withdraw from _owner
296     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
297 
298     // Triggered when tokens are transferred.
299     event Transfer(address indexed _from, address indexed _to, uint256 _value);
300 
301     // Triggered whenever approve(address _spender, uint256 _value) is called.
302     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
303 }
304 
305 contract ixBackendEvents {
306     event NewDemoc(bytes32 democHash);
307     event ManuallyAddedDemoc(bytes32 democHash, address erc20);
308     event NewBallot(bytes32 indexed democHash, uint ballotN);
309     event DemocOwnerSet(bytes32 indexed democHash, address owner);
310     event DemocEditorSet(bytes32 indexed democHash, address editor, bool canEdit);
311     event DemocEditorsWiped(bytes32 indexed democHash);
312     event DemocErc20Set(bytes32 indexed democHash, address erc20);
313     event DemocDataSet(bytes32 indexed democHash, bytes32 keyHash);
314     event DemocCatAdded(bytes32 indexed democHash, uint catId);
315     event DemocCatDeprecated(bytes32 indexed democHash, uint catId);
316     event DemocCommunityBallotsEnabled(bytes32 indexed democHash, bool enabled);
317     event DemocErc20OwnerClaimDisabled(bytes32 indexed democHash);
318     event DemocClaimed(bytes32 indexed democHash);
319     event EmergencyDemocOwner(bytes32 indexed democHash, address newOwner);
320 }
321 
322 interface hasVersion {
323     function getVersion() external pure returns (uint);
324 }
325 
326 contract IxBackendIface is hasVersion, ixBackendEvents, permissioned, payoutAllC {
327     /* global getters */
328     function getGDemocsN() external view returns (uint);
329     function getGDemoc(uint id) external view returns (bytes32);
330     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes);
331 
332     /* owner functions */
333     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) external;
334     function emergencySetDOwner(bytes32 democHash, address newOwner) external;
335 
336     /* democ admin */
337     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) external returns (bytes32 democHash);
338     function setDOwner(bytes32 democHash, address newOwner) external;
339     function setDOwnerFromClaim(bytes32 democHash, address newOwner) external;
340     function setDEditor(bytes32 democHash, address editor, bool canEdit) external;
341     function setDNoEditors(bytes32 democHash) external;
342     function setDErc20(bytes32 democHash, address newErc20) external;
343     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) external;
344     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) external;
345     function dAddCategory(bytes32 democHash, bytes32 categoryName, bool hasParent, uint parent) external;
346     function dDeprecateCategory(bytes32 democHash, uint catId) external;
347     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) external;
348     function dDisableErc20OwnerClaim(bytes32 democHash) external;
349 
350     /* actually add a ballot */
351     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) external;
352 
353     /* global democ getters */
354     function getDOwner(bytes32 democHash) external view returns (address);
355     function isDEditor(bytes32 democHash, address editor) external view returns (bool);
356     function getDHash(bytes13 prefix) external view returns (bytes32);
357     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots);
358     function getDErc20(bytes32 democHash) external view returns (address);
359     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
360     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes value);
361     function getDBallotsN(bytes32 democHash) external view returns (uint256);
362     function getDBallotID(bytes32 democHash, uint n) external view returns (uint ballotId);
363     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256);
364     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256);
365     function getDCategoriesN(bytes32 democHash) external view returns (uint);
366     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint parent);
367     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool);
368     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool);
369 }
370 
371 contract SVIndexBackend is IxBackendIface {
372     uint constant VERSION = 2;
373 
374     struct Democ {
375         address erc20;
376         address owner;
377         bool communityBallotsDisabled;
378         bool erc20OwnerClaimDisabled;
379         uint editorEpoch;
380         mapping (uint => mapping (address => bool)) editors;
381         uint256[] allBallots;
382         uint256[] includedBasicBallots;  // the IDs of official ballots
383 
384     }
385 
386     struct BallotRef {
387         bytes32 democHash;
388         uint ballotId;
389     }
390 
391     struct Category {
392         bool deprecated;
393         bytes32 name;
394         bool hasParent;
395         uint parent;
396     }
397 
398     struct CategoriesIx {
399         uint nCategories;
400         mapping(uint => Category) categories;
401     }
402 
403     mapping (bytes32 => Democ) democs;
404     mapping (bytes32 => CategoriesIx) democCategories;
405     mapping (bytes13 => bytes32) democPrefixToHash;
406     mapping (address => bytes32[]) erc20ToDemocs;
407     bytes32[] democList;
408 
409     // allows democ admins to store arbitrary data
410     // this lets us (for example) set particular keys to signal cerain
411     // things to client apps s.t. the admin can turn them on and off.
412     // arbitraryData[democHash][key]
413     mapping (bytes32 => mapping (bytes32 => bytes)) arbitraryData;
414 
415     /* constructor */
416 
417     constructor() payoutAllC(msg.sender) public {
418         // do nothing
419     }
420 
421     /* base contract overloads */
422 
423     function _getPayTo() internal view returns (address) {
424         return owner;
425     }
426 
427     function getVersion() external pure returns (uint) {
428         return VERSION;
429     }
430 
431     /* GLOBAL INFO */
432 
433     function getGDemocsN() external view returns (uint) {
434         return democList.length;
435     }
436 
437     function getGDemoc(uint id) external view returns (bytes32) {
438         return democList[id];
439     }
440 
441     function getGErc20ToDemocs(address erc20) external view returns (bytes32[] democHashes) {
442         return erc20ToDemocs[erc20];
443     }
444 
445     /* DEMOCRACY ADMIN FUNCTIONS */
446 
447     function _addDemoc(bytes32 democHash, address erc20, address initOwner, bool disableErc20OwnerClaim) internal {
448         democList.push(democHash);
449         Democ storage d = democs[democHash];
450         d.erc20 = erc20;
451         if (disableErc20OwnerClaim) {
452             d.erc20OwnerClaimDisabled = true;
453         }
454         // this should never trigger if we have a good security model - entropy for 13 bytes ~ 2^(8*13) ~ 10^31
455         assert(democPrefixToHash[bytes13(democHash)] == bytes32(0));
456         democPrefixToHash[bytes13(democHash)] = democHash;
457         erc20ToDemocs[erc20].push(democHash);
458         _setDOwner(democHash, initOwner);
459         emit NewDemoc(democHash);
460     }
461 
462     /* owner democ admin functions */
463 
464     function dAdd(bytes32 democHash, address erc20, bool disableErc20OwnerClaim) only_owner() external {
465         _addDemoc(democHash, erc20, msg.sender, disableErc20OwnerClaim);
466         emit ManuallyAddedDemoc(democHash, erc20);
467     }
468 
469     /* Preferably for emergencies only */
470 
471     function emergencySetDOwner(bytes32 democHash, address newOwner) only_owner() external {
472         _setDOwner(democHash, newOwner);
473         emit EmergencyDemocOwner(democHash, newOwner);
474     }
475 
476     /* user democ admin functions */
477 
478     function dInit(address defaultErc20, address initOwner, bool disableErc20OwnerClaim) only_editors() external returns (bytes32 democHash) {
479         // generating the democHash in this way guarentees it'll be unique/hard-to-brute-force
480         // (particularly because prevBlockHash and now are part of the hash)
481         democHash = keccak256(abi.encodePacked(democList.length, blockhash(block.number-1), defaultErc20, now));
482         _addDemoc(democHash, defaultErc20, initOwner, disableErc20OwnerClaim);
483     }
484 
485     function _setDOwner(bytes32 democHash, address newOwner) internal {
486         Democ storage d = democs[democHash];
487         uint epoch = d.editorEpoch;
488         d.owner = newOwner;
489         // unset prev owner as editor - does little if one was not set
490         d.editors[epoch][d.owner] = false;
491         // make new owner an editor too
492         d.editors[epoch][newOwner] = true;
493         emit DemocOwnerSet(democHash, newOwner);
494     }
495 
496     function setDOwner(bytes32 democHash, address newOwner) only_editors() external {
497         _setDOwner(democHash, newOwner);
498     }
499 
500     function setDOwnerFromClaim(bytes32 democHash, address newOwner) only_editors() external {
501         Democ storage d = democs[democHash];
502         // make sure that the owner claim is enabled (i.e. the disabled flag is false)
503         require(d.erc20OwnerClaimDisabled == false, "!erc20-claim");
504         // set owner and editor
505         d.owner = newOwner;
506         d.editors[d.editorEpoch][newOwner] = true;
507         // disable the ability to claim now that it's done
508         d.erc20OwnerClaimDisabled = true;
509         emit DemocOwnerSet(democHash, newOwner);
510         emit DemocClaimed(democHash);
511     }
512 
513     function setDEditor(bytes32 democHash, address editor, bool canEdit) only_editors() external {
514         Democ storage d = democs[democHash];
515         d.editors[d.editorEpoch][editor] = canEdit;
516         emit DemocEditorSet(democHash, editor, canEdit);
517     }
518 
519     function setDNoEditors(bytes32 democHash) only_editors() external {
520         democs[democHash].editorEpoch += 1;
521         emit DemocEditorsWiped(democHash);
522     }
523 
524     function setDErc20(bytes32 democHash, address newErc20) only_editors() external {
525         democs[democHash].erc20 = newErc20;
526         erc20ToDemocs[newErc20].push(democHash);
527         emit DemocErc20Set(democHash, newErc20);
528     }
529 
530     function dSetArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
531         bytes32 k = keccak256(key);
532         arbitraryData[democHash][k] = value;
533         emit DemocDataSet(democHash, k);
534     }
535 
536     function dSetEditorArbitraryData(bytes32 democHash, bytes key, bytes value) only_editors() external {
537         bytes32 k = keccak256(_calcEditorKey(key));
538         arbitraryData[democHash][k] = value;
539         emit DemocDataSet(democHash, k);
540     }
541 
542     function dAddCategory(bytes32 democHash, bytes32 name, bool hasParent, uint parent) only_editors() external {
543         uint catId = democCategories[democHash].nCategories;
544         democCategories[democHash].categories[catId].name = name;
545         if (hasParent) {
546             democCategories[democHash].categories[catId].hasParent = true;
547             democCategories[democHash].categories[catId].parent = parent;
548         }
549         democCategories[democHash].nCategories += 1;
550         emit DemocCatAdded(democHash, catId);
551     }
552 
553     function dDeprecateCategory(bytes32 democHash, uint catId) only_editors() external {
554         democCategories[democHash].categories[catId].deprecated = true;
555         emit DemocCatDeprecated(democHash, catId);
556     }
557 
558     function dSetCommunityBallotsEnabled(bytes32 democHash, bool enabled) only_editors() external {
559         democs[democHash].communityBallotsDisabled = !enabled;
560         emit DemocCommunityBallotsEnabled(democHash, enabled);
561     }
562 
563     function dDisableErc20OwnerClaim(bytes32 democHash) only_editors() external {
564         democs[democHash].erc20OwnerClaimDisabled = true;
565         emit DemocErc20OwnerClaimDisabled(democHash);
566     }
567 
568     //* ADD BALLOT TO RECORD */
569 
570     function _commitBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) internal {
571         uint16 subBits;
572         subBits = BPackedUtils.packedToSubmissionBits(packed);
573 
574         uint localBallotId = democs[democHash].allBallots.length;
575         democs[democHash].allBallots.push(ballotId);
576 
577         // do this for anything that doesn't qualify as a community ballot
578         if (countTowardsLimit) {
579             democs[democHash].includedBasicBallots.push(ballotId);
580         }
581 
582         emit NewBallot(democHash, localBallotId);
583     }
584 
585     // what SVIndex uses to add a ballot
586     function dAddBallot(bytes32 democHash, uint ballotId, uint256 packed, bool countTowardsLimit) only_editors() external {
587         _commitBallot(democHash, ballotId, packed, countTowardsLimit);
588     }
589 
590     /* democ getters */
591 
592     function getDOwner(bytes32 democHash) external view returns (address) {
593         return democs[democHash].owner;
594     }
595 
596     function isDEditor(bytes32 democHash, address editor) external view returns (bool) {
597         Democ storage d = democs[democHash];
598         // allow either an editor or always the owner
599         return d.editors[d.editorEpoch][editor] || editor == d.owner;
600     }
601 
602     function getDHash(bytes13 prefix) external view returns (bytes32) {
603         return democPrefixToHash[prefix];
604     }
605 
606     function getDInfo(bytes32 democHash) external view returns (address erc20, address owner, uint256 nBallots) {
607         return (democs[democHash].erc20, democs[democHash].owner, democs[democHash].allBallots.length);
608     }
609 
610     function getDErc20(bytes32 democHash) external view returns (address) {
611         return democs[democHash].erc20;
612     }
613 
614     function getDArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
615         return arbitraryData[democHash][keccak256(key)];
616     }
617 
618     function getDEditorArbitraryData(bytes32 democHash, bytes key) external view returns (bytes) {
619         return arbitraryData[democHash][keccak256(_calcEditorKey(key))];
620     }
621 
622     function getDBallotsN(bytes32 democHash) external view returns (uint256) {
623         return democs[democHash].allBallots.length;
624     }
625 
626     function getDBallotID(bytes32 democHash, uint256 n) external view returns (uint ballotId) {
627         return democs[democHash].allBallots[n];
628     }
629 
630     function getDCountedBasicBallotsN(bytes32 democHash) external view returns (uint256) {
631         return democs[democHash].includedBasicBallots.length;
632     }
633 
634     function getDCountedBasicBallotID(bytes32 democHash, uint256 n) external view returns (uint256) {
635         return democs[democHash].includedBasicBallots[n];
636     }
637 
638     function getDCategoriesN(bytes32 democHash) external view returns (uint) {
639         return democCategories[democHash].nCategories;
640     }
641 
642     function getDCategory(bytes32 democHash, uint catId) external view returns (bool deprecated, bytes32 name, bool hasParent, uint256 parent) {
643         deprecated = democCategories[democHash].categories[catId].deprecated;
644         name = democCategories[democHash].categories[catId].name;
645         hasParent = democCategories[democHash].categories[catId].hasParent;
646         parent = democCategories[democHash].categories[catId].parent;
647     }
648 
649     function getDCommBallotsEnabled(bytes32 democHash) external view returns (bool) {
650         return !democs[democHash].communityBallotsDisabled;
651     }
652 
653     function getDErc20OwnerClaimEnabled(bytes32 democHash) external view returns (bool) {
654         return !democs[democHash].erc20OwnerClaimDisabled;
655     }
656 
657     /* util for calculating editor key */
658 
659     function _calcEditorKey(bytes key) internal pure returns (bytes) {
660         return abi.encodePacked("editor.", key);
661     }
662 }