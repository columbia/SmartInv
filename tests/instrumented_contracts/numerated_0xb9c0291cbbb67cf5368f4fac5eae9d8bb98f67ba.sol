1 pragma solidity 0.4.24;
2 
3 contract safeSend {
4     bool private txMutex3847834;
5 
6     // we want to be able to call outside contracts (e.g. the admin proxy contract)
7     // but reentrency is bad, so here's a mutex.
8     function doSafeSend(address toAddr, uint amount) internal {
9         doSafeSendWData(toAddr, "", amount);
10     }
11 
12     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
13         require(txMutex3847834 == false, "ss-guard");
14         txMutex3847834 = true;
15         // we need to use address.call.value(v)() because we want
16         // to be able to send to other contracts, even with no data,
17         // which might use more than 2300 gas in their fallback function.
18         require(toAddr.call.value(amount)(data), "ss-failed");
19         txMutex3847834 = false;
20     }
21 }
22 
23 contract payoutAllC is safeSend {
24     address private _payTo;
25 
26     event PayoutAll(address payTo, uint value);
27 
28     constructor(address initPayTo) public {
29         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
30         assert(initPayTo != address(0));
31         _payTo = initPayTo;
32     }
33 
34     function _getPayTo() internal view returns (address) {
35         return _payTo;
36     }
37 
38     function _setPayTo(address newPayTo) internal {
39         _payTo = newPayTo;
40     }
41 
42     function payoutAll() external {
43         address a = _getPayTo();
44         uint bal = address(this).balance;
45         doSafeSend(a, bal);
46         emit PayoutAll(a, bal);
47     }
48 }
49 
50 contract payoutAllCSettable is payoutAllC {
51     constructor (address initPayTo) payoutAllC(initPayTo) public {
52     }
53 
54     function setPayTo(address) external;
55     function getPayTo() external view returns (address) {
56         return _getPayTo();
57     }
58 }
59 
60 contract owned {
61     address public owner;
62 
63     event OwnerChanged(address newOwner);
64 
65     modifier only_owner() {
66         require(msg.sender == owner, "only_owner: forbidden");
67         _;
68     }
69 
70     modifier owner_or(address addr) {
71         require(msg.sender == addr || msg.sender == owner, "!owner-or");
72         _;
73     }
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     function setOwner(address newOwner) only_owner() external {
80         owner = newOwner;
81         emit OwnerChanged(newOwner);
82     }
83 }
84 
85 contract CanReclaimToken is owned {
86 
87     /**
88     * @dev Reclaim all ERC20Basic compatible tokens
89     * @param token ERC20Basic The address of the token contract
90     */
91     function reclaimToken(ERC20Interface token) external only_owner {
92         uint256 balance = token.balanceOf(this);
93         require(token.approve(owner, balance));
94     }
95 
96 }
97 
98 contract controlledIface {
99     function controller() external view returns (address);
100 }
101 
102 contract hasAdmins is owned {
103     mapping (uint => mapping (address => bool)) admins;
104     uint public currAdminEpoch = 0;
105     bool public adminsDisabledForever = false;
106     address[] adminLog;
107 
108     event AdminAdded(address indexed newAdmin);
109     event AdminRemoved(address indexed oldAdmin);
110     event AdminEpochInc();
111     event AdminDisabledForever();
112 
113     modifier only_admin() {
114         require(adminsDisabledForever == false, "admins must not be disabled");
115         require(isAdmin(msg.sender), "only_admin: forbidden");
116         _;
117     }
118 
119     constructor() public {
120         _setAdmin(msg.sender, true);
121     }
122 
123     function isAdmin(address a) view public returns (bool) {
124         return admins[currAdminEpoch][a];
125     }
126 
127     function getAdminLogN() view external returns (uint) {
128         return adminLog.length;
129     }
130 
131     function getAdminLog(uint n) view external returns (address) {
132         return adminLog[n];
133     }
134 
135     function upgradeMeAdmin(address newAdmin) only_admin() external {
136         // note: already checked msg.sender has admin with `only_admin` modifier
137         require(msg.sender != owner, "owner cannot upgrade self");
138         _setAdmin(msg.sender, false);
139         _setAdmin(newAdmin, true);
140     }
141 
142     function setAdmin(address a, bool _givePerms) only_admin() external {
143         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
144         _setAdmin(a, _givePerms);
145     }
146 
147     function _setAdmin(address a, bool _givePerms) internal {
148         admins[currAdminEpoch][a] = _givePerms;
149         if (_givePerms) {
150             emit AdminAdded(a);
151             adminLog.push(a);
152         } else {
153             emit AdminRemoved(a);
154         }
155     }
156 
157     // safety feature if admins go bad or something
158     function incAdminEpoch() only_owner() external {
159         currAdminEpoch++;
160         admins[currAdminEpoch][msg.sender] = true;
161         emit AdminEpochInc();
162     }
163 
164     // this is internal so contracts can all it, but not exposed anywhere in this
165     // contract.
166     function disableAdminForever() internal {
167         currAdminEpoch++;
168         adminsDisabledForever = true;
169         emit AdminDisabledForever();
170     }
171 }
172 
173 contract permissioned is owned, hasAdmins {
174     mapping (address => bool) editAllowed;
175     bool public adminLockdown = false;
176 
177     event PermissionError(address editAddr);
178     event PermissionGranted(address editAddr);
179     event PermissionRevoked(address editAddr);
180     event PermissionsUpgraded(address oldSC, address newSC);
181     event SelfUpgrade(address oldSC, address newSC);
182     event AdminLockdown();
183 
184     modifier only_editors() {
185         require(editAllowed[msg.sender], "only_editors: forbidden");
186         _;
187     }
188 
189     modifier no_lockdown() {
190         require(adminLockdown == false, "no_lockdown: check failed");
191         _;
192     }
193 
194 
195     constructor() owned() hasAdmins() public {
196     }
197 
198 
199     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
200         editAllowed[e] = _editPerms;
201         if (_editPerms)
202             emit PermissionGranted(e);
203         else
204             emit PermissionRevoked(e);
205     }
206 
207     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
208         editAllowed[oldSC] = false;
209         editAllowed[newSC] = true;
210         emit PermissionsUpgraded(oldSC, newSC);
211     }
212 
213     // always allow SCs to upgrade themselves, even after lockdown
214     function upgradeMe(address newSC) only_editors() external {
215         editAllowed[msg.sender] = false;
216         editAllowed[newSC] = true;
217         emit SelfUpgrade(msg.sender, newSC);
218     }
219 
220     function hasPermissions(address a) public view returns (bool) {
221         return editAllowed[a];
222     }
223 
224     function doLockdown() external only_owner() no_lockdown() {
225         disableAdminForever();
226         adminLockdown = true;
227         emit AdminLockdown();
228     }
229 }
230 
231 contract upgradePtr {
232     address ptr = address(0);
233 
234     modifier not_upgraded() {
235         require(ptr == address(0), "upgrade pointer is non-zero");
236         _;
237     }
238 
239     function getUpgradePointer() view external returns (address) {
240         return ptr;
241     }
242 
243     function doUpgradeInternal(address nextSC) internal {
244         ptr = nextSC;
245     }
246 }
247 
248 interface ERC20Interface {
249     // Get the total token supply
250     function totalSupply() constant external returns (uint256 _totalSupply);
251 
252     // Get the account balance of another account with address _owner
253     function balanceOf(address _owner) constant external returns (uint256 balance);
254 
255     // Send _value amount of tokens to address _to
256     function transfer(address _to, uint256 _value) external returns (bool success);
257 
258     // Send _value amount of tokens from address _from to address _to
259     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
260 
261     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
262     // If this function is called again it overwrites the current allowance with _value.
263     // this function is required for some DEX functionality
264     function approve(address _spender, uint256 _value) external returns (bool success);
265 
266     // Returns the amount which _spender is still allowed to withdraw from _owner
267     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
268 
269     // Triggered when tokens are transferred.
270     event Transfer(address indexed _from, address indexed _to, uint256 _value);
271 
272     // Triggered whenever approve(address _spender, uint256 _value) is called.
273     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
274 }
275 
276 library SafeMath {
277     function subToZero(uint a, uint b) internal pure returns (uint) {
278         if (a < b) {  // then (a - b) would overflow
279             return 0;
280         }
281         return a - b;
282     }
283 }
284 
285 contract ixPaymentEvents {
286     event UpgradedToPremium(bytes32 indexed democHash);
287     event GrantedAccountTime(bytes32 indexed democHash, uint additionalSeconds, bytes32 ref);
288     event AccountPayment(bytes32 indexed democHash, uint additionalSeconds);
289     event SetCommunityBallotFee(uint amount);
290     event SetBasicCentsPricePer30Days(uint amount);
291     event SetPremiumMultiplier(uint8 multiplier);
292     event DowngradeToBasic(bytes32 indexed democHash);
293     event UpgradeToPremium(bytes32 indexed democHash);
294     event SetExchangeRate(uint weiPerCent);
295     event FreeExtension(bytes32 democHash);
296     event SetBallotsPer30Days(uint amount);
297     event SetFreeExtension(bytes32 democHash, bool hasFreeExt);
298     event SetDenyPremium(bytes32 democHash, bool isPremiumDenied);
299     event SetPayTo(address payTo);
300     event SetMinorEditsAddr(address minorEditsAddr);
301     event SetMinWeiForDInit(uint amount);
302 }
303 
304 interface hasVersion {
305     function getVersion() external pure returns (uint);
306 }
307 
308 contract IxPaymentsIface is hasVersion, ixPaymentEvents, permissioned, CanReclaimToken, payoutAllCSettable {
309     /* in emergency break glass */
310     function emergencySetOwner(address newOwner) external;
311 
312     /* financial calcluations */
313     function weiBuysHowManySeconds(uint amount) public view returns (uint secs);
314     function weiToCents(uint w) public view returns (uint);
315     function centsToWei(uint c) public view returns (uint);
316 
317     /* account management */
318     function payForDemocracy(bytes32 democHash) external payable;
319     function doFreeExtension(bytes32 democHash) external;
320     function downgradeToBasic(bytes32 democHash) external;
321     function upgradeToPremium(bytes32 democHash) external;
322 
323     /* account status - getters */
324     function accountInGoodStanding(bytes32 democHash) external view returns (bool);
325     function getSecondsRemaining(bytes32 democHash) external view returns (uint);
326     function getPremiumStatus(bytes32 democHash) external view returns (bool);
327     function getFreeExtension(bytes32 democHash) external view returns (bool);
328     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension);
329     function getDenyPremium(bytes32 democHash) external view returns (bool);
330 
331     /* admin utils for accounts */
332     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) external;
333 
334     /* admin setters global */
335     function setPayTo(address) external;
336     function setMinorEditsAddr(address) external;
337     function setBasicCentsPricePer30Days(uint amount) external;
338     function setBasicBallotsPer30Days(uint amount) external;
339     function setPremiumMultiplier(uint8 amount) external;
340     function setWeiPerCent(uint) external;
341     function setFreeExtension(bytes32 democHash, bool hasFreeExt) external;
342     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) external;
343     function setMinWeiForDInit(uint amount) external;
344 
345     /* global getters */
346     function getBasicCentsPricePer30Days() external view returns(uint);
347     function getBasicExtraBallotFeeWei() external view returns (uint);
348     function getBasicBallotsPer30Days() external view returns (uint);
349     function getPremiumMultiplier() external view returns (uint8);
350     function getPremiumCentsPricePer30Days() external view returns (uint);
351     function getWeiPerCent() external view returns (uint weiPerCent);
352     function getUsdEthExchangeRate() external view returns (uint centsPerEth);
353     function getMinWeiForDInit() external view returns (uint);
354 
355     /* payments stuff */
356     function getPaymentLogN() external view returns (uint);
357     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue);
358 }
359 
360 contract SVPayments is IxPaymentsIface {
361     uint constant VERSION = 2;
362 
363     struct Account {
364         bool isPremium;
365         uint lastPaymentTs;
366         uint paidUpTill;
367         uint lastUpgradeTs;  // timestamp of the last time it was upgraded to premium
368     }
369 
370     struct PaymentLog {
371         bool _external;
372         bytes32 _democHash;
373         uint _seconds;
374         uint _ethValue;
375     }
376 
377     // this is an address that's only allowed to make minor edits
378     // e.g. setExchangeRate, setDenyPremium, giveTimeToDemoc
379     address public minorEditsAddr;
380 
381     // payment details
382     uint basicCentsPricePer30Days = 125000; // $1250/mo
383     uint basicBallotsPer30Days = 10;
384     uint8 premiumMultiplier = 5;
385     uint weiPerCent = 0.000016583747 ether;  // $603, 4th June 2018
386 
387     uint minWeiForDInit = 1;  // minimum 1 wei - match existing behaviour in SVIndex
388 
389     mapping (bytes32 => Account) accounts;
390     PaymentLog[] payments;
391 
392     // can set this on freeExtension democs to deny them premium upgrades
393     mapping (bytes32 => bool) denyPremium;
394     // this is used for non-profits or organisations that have perpetual licenses, etc
395     mapping (bytes32 => bool) freeExtension;
396 
397 
398     /* BREAK GLASS IN CASE OF EMERGENCY */
399     // this is included here because something going wrong with payments is possibly
400     // the absolute worst case. Note: does this have negligable benefit if the other
401     // contracts are compromised? (e.g. by a leaked privkey)
402     address public emergencyAdmin;
403     function emergencySetOwner(address newOwner) external {
404         require(msg.sender == emergencyAdmin, "!emergency-owner");
405         owner = newOwner;
406     }
407     /* END BREAK GLASS */
408 
409 
410     constructor(address _emergencyAdmin) payoutAllCSettable(msg.sender) public {
411         emergencyAdmin = _emergencyAdmin;
412         assert(_emergencyAdmin != address(0));
413     }
414 
415     /* base SCs */
416 
417     function getVersion() external pure returns (uint) {
418         return VERSION;
419     }
420 
421     function() payable public {
422         _getPayTo().transfer(msg.value);
423     }
424 
425     function _modAccountBalance(bytes32 democHash, uint additionalSeconds) internal {
426         uint prevPaidTill = accounts[democHash].paidUpTill;
427         if (prevPaidTill < now) {
428             prevPaidTill = now;
429         }
430 
431         accounts[democHash].paidUpTill = prevPaidTill + additionalSeconds;
432         accounts[democHash].lastPaymentTs = now;
433     }
434 
435     /* Financial Calculations */
436 
437     function weiBuysHowManySeconds(uint amount) public view returns (uint) {
438         uint centsPaid = weiToCents(amount);
439         // multiply by 10**18 to ensure we make rounding errors insignificant
440         uint monthsOffsetPaid = ((10 ** 18) * centsPaid) / basicCentsPricePer30Days;
441         uint secondsOffsetPaid = monthsOffsetPaid * (30 days);
442         uint additionalSeconds = secondsOffsetPaid / (10 ** 18);
443         return additionalSeconds;
444     }
445 
446     function weiToCents(uint w) public view returns (uint) {
447         return w / weiPerCent;
448     }
449 
450     function centsToWei(uint c) public view returns (uint) {
451         return c * weiPerCent;
452     }
453 
454     /* account management */
455 
456     function payForDemocracy(bytes32 democHash) external payable {
457         require(msg.value > 0, "need to send some ether to make payment");
458 
459         uint additionalSeconds = weiBuysHowManySeconds(msg.value);
460 
461         if (accounts[democHash].isPremium) {
462             additionalSeconds /= premiumMultiplier;
463         }
464 
465         if (additionalSeconds >= 1) {
466             _modAccountBalance(democHash, additionalSeconds);
467         }
468         payments.push(PaymentLog(false, democHash, additionalSeconds, msg.value));
469         emit AccountPayment(democHash, additionalSeconds);
470 
471         _getPayTo().transfer(msg.value);
472     }
473 
474     function doFreeExtension(bytes32 democHash) external {
475         require(freeExtension[democHash], "!free");
476         uint newPaidUpTill = now + 60 days;
477         accounts[democHash].paidUpTill = newPaidUpTill;
478         emit FreeExtension(democHash);
479     }
480 
481     function downgradeToBasic(bytes32 democHash) only_editors() external {
482         require(accounts[democHash].isPremium, "!premium");
483         accounts[democHash].isPremium = false;
484         // convert premium minutes to basic
485         uint paidTill = accounts[democHash].paidUpTill;
486         uint timeRemaining = SafeMath.subToZero(paidTill, now);
487         // if we have time remaining: convert it
488         if (timeRemaining > 0) {
489             // prevent accounts from downgrading if they have time remaining
490             // and upgraded less than 24hrs ago
491             require(accounts[democHash].lastUpgradeTs < (now - 24 hours), "downgrade-too-soon");
492             timeRemaining *= premiumMultiplier;
493             accounts[democHash].paidUpTill = now + timeRemaining;
494         }
495         emit DowngradeToBasic(democHash);
496     }
497 
498     function upgradeToPremium(bytes32 democHash) only_editors() external {
499         require(denyPremium[democHash] == false, "upgrade-denied");
500         require(!accounts[democHash].isPremium, "!basic");
501         accounts[democHash].isPremium = true;
502         // convert basic minutes to premium minutes
503         uint paidTill = accounts[democHash].paidUpTill;
504         uint timeRemaining = SafeMath.subToZero(paidTill, now);
505         // if we have time remaning then convert it - otherwise don't need to do anything
506         if (timeRemaining > 0) {
507             timeRemaining /= premiumMultiplier;
508             accounts[democHash].paidUpTill = now + timeRemaining;
509         }
510         accounts[democHash].lastUpgradeTs = now;
511         emit UpgradedToPremium(democHash);
512     }
513 
514     /* account status - getters */
515 
516     function accountInGoodStanding(bytes32 democHash) external view returns (bool) {
517         return accounts[democHash].paidUpTill >= now;
518     }
519 
520     function getSecondsRemaining(bytes32 democHash) external view returns (uint) {
521         return SafeMath.subToZero(accounts[democHash].paidUpTill, now);
522     }
523 
524     function getPremiumStatus(bytes32 democHash) external view returns (bool) {
525         return accounts[democHash].isPremium;
526     }
527 
528     function getFreeExtension(bytes32 democHash) external view returns (bool) {
529         return freeExtension[democHash];
530     }
531 
532     function getAccount(bytes32 democHash) external view returns (bool isPremium, uint lastPaymentTs, uint paidUpTill, bool hasFreeExtension) {
533         isPremium = accounts[democHash].isPremium;
534         lastPaymentTs = accounts[democHash].lastPaymentTs;
535         paidUpTill = accounts[democHash].paidUpTill;
536         hasFreeExtension = freeExtension[democHash];
537     }
538 
539     function getDenyPremium(bytes32 democHash) external view returns (bool) {
540         return denyPremium[democHash];
541     }
542 
543     /* admin utils for accounts */
544 
545     function giveTimeToDemoc(bytes32 democHash, uint additionalSeconds, bytes32 ref) owner_or(minorEditsAddr) external {
546         _modAccountBalance(democHash, additionalSeconds);
547         payments.push(PaymentLog(true, democHash, additionalSeconds, 0));
548         emit GrantedAccountTime(democHash, additionalSeconds, ref);
549     }
550 
551     /* admin setters global */
552 
553     function setPayTo(address newPayTo) only_owner() external {
554         _setPayTo(newPayTo);
555         emit SetPayTo(newPayTo);
556     }
557 
558     function setMinorEditsAddr(address a) only_owner() external {
559         minorEditsAddr = a;
560         emit SetMinorEditsAddr(a);
561     }
562 
563     function setBasicCentsPricePer30Days(uint amount) only_owner() external {
564         basicCentsPricePer30Days = amount;
565         emit SetBasicCentsPricePer30Days(amount);
566     }
567 
568     function setBasicBallotsPer30Days(uint amount) only_owner() external {
569         basicBallotsPer30Days = amount;
570         emit SetBallotsPer30Days(amount);
571     }
572 
573     function setPremiumMultiplier(uint8 m) only_owner() external {
574         premiumMultiplier = m;
575         emit SetPremiumMultiplier(m);
576     }
577 
578     function setWeiPerCent(uint wpc) owner_or(minorEditsAddr) external {
579         weiPerCent = wpc;
580         emit SetExchangeRate(wpc);
581     }
582 
583     function setFreeExtension(bytes32 democHash, bool hasFreeExt) owner_or(minorEditsAddr) external {
584         freeExtension[democHash] = hasFreeExt;
585         emit SetFreeExtension(democHash, hasFreeExt);
586     }
587 
588     function setDenyPremium(bytes32 democHash, bool isPremiumDenied) owner_or(minorEditsAddr) external {
589         denyPremium[democHash] = isPremiumDenied;
590         emit SetDenyPremium(democHash, isPremiumDenied);
591     }
592 
593     function setMinWeiForDInit(uint amount) owner_or(minorEditsAddr) external {
594         minWeiForDInit = amount;
595         emit SetMinWeiForDInit(amount);
596     }
597 
598     /* global getters */
599 
600     function getBasicCentsPricePer30Days() external view returns (uint) {
601         return basicCentsPricePer30Days;
602     }
603 
604     function getBasicExtraBallotFeeWei() external view returns (uint) {
605         return centsToWei(basicCentsPricePer30Days / basicBallotsPer30Days);
606     }
607 
608     function getBasicBallotsPer30Days() external view returns (uint) {
609         return basicBallotsPer30Days;
610     }
611 
612     function getPremiumMultiplier() external view returns (uint8) {
613         return premiumMultiplier;
614     }
615 
616     function getPremiumCentsPricePer30Days() external view returns (uint) {
617         return _premiumPricePer30Days();
618     }
619 
620     function _premiumPricePer30Days() internal view returns (uint) {
621         return uint(premiumMultiplier) * basicCentsPricePer30Days;
622     }
623 
624     function getWeiPerCent() external view returns (uint) {
625         return weiPerCent;
626     }
627 
628     function getUsdEthExchangeRate() external view returns (uint) {
629         // this returns cents per ether
630         return 1 ether / weiPerCent;
631     }
632 
633     function getMinWeiForDInit() external view returns (uint) {
634         return minWeiForDInit;
635     }
636 
637     /* payments stuff */
638 
639     function getPaymentLogN() external view returns (uint) {
640         return payments.length;
641     }
642 
643     function getPaymentLog(uint n) external view returns (bool _external, bytes32 _democHash, uint _seconds, uint _ethValue) {
644         _external = payments[n]._external;
645         _democHash = payments[n]._democHash;
646         _seconds = payments[n]._seconds;
647         _ethValue = payments[n]._ethValue;
648     }
649 }