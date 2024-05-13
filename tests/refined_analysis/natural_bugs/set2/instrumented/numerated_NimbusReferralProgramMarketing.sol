1 pragma solidity >=0.8.0 <=0.8.13;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12     function vest(address user, uint amount) external;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library TransferHelper {
19     function safeApprove(address token, address to, uint value) internal {
20         // bytes4(keccak256(bytes('approve(address,uint256)')));
21         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
22         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
23     }
24 
25     function safeTransfer(address token, address to, uint value) internal {
26         // bytes4(keccak256(bytes('transfer(address,uint256)')));
27         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
28         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
29     }
30 
31     function safeTransferFrom(address token, address from, address to, uint value) internal {
32         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
33         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
34         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
35     }
36 
37     function safeTransferBNB(address to, uint value) internal {
38         (bool success,) = to.call{value:value}(new bytes(0));
39         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
40     }
41 }
42 
43 interface INimbusReferralProgramUsers {
44     function userSponsor(uint user) external view returns (uint);
45     function registerUser(address user, uint category) external returns (uint);
46     function registerUserBySponsorAddress(address user, address sponsorAddress, uint category) external returns (uint);
47     function registerUserBySponsorId(address user, uint sponsorId, uint category) external returns (uint);
48     function userIdByAddress(address user) external view returns (uint);
49     function userAddressById(uint id) external view returns (address);
50     function userSponsorAddressByAddress(address user) external view returns (address);
51     function getUserReferrals(address user) external view returns (uint[] memory);
52 }
53 
54 interface INimbusVesting {
55     struct VestingInfo {
56         uint vestingAmount;
57         uint unvestedAmount;
58         uint vestingType;
59         uint vestingStart;
60         uint vestingReleaseStartDate;
61         uint vestingEnd;
62         uint vestingSecondPeriod;
63     }
64     function vestingInfos(address user, uint nonce) external view returns (VestingInfo memory);
65     function vestingNonces(address user) external view returns (uint);
66 }
67 
68 contract Ownable {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed from, address indexed to);
73 
74     constructor() {
75         owner = msg.sender;
76         emit OwnershipTransferred(address(0), owner);
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner, "Ownable: Caller is not the owner");
81         _;
82     }
83 
84     function getOwner() external view returns (address) {
85         return owner;
86     }
87 
88     function transferOwnership(address transferOwner) external onlyOwner {
89         require(transferOwner != newOwner);
90         newOwner = transferOwner;
91     }
92 
93     function acceptOwnership() virtual external {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 library Address {
102     function isContract(address account) internal view returns (bool) {
103         uint256 size;
104         assembly { size := extcodesize(account) }
105         return size > 0;
106     }
107 }
108 
109 contract NimbusReferralProgramMarketingStorage is Ownable {  
110         struct Qualification {
111             uint Number;
112             uint TotalTurnover; 
113             uint Percentage; 
114             uint FixedReward;
115             uint MaxUpdateLevel;
116         }
117 
118         struct UpgradeInfo {
119             uint date;
120             uint prevLevel;
121             uint nextLevel;
122         }
123 
124         mapping (address => uint) public upgradeNonces;
125         mapping (address => mapping (uint => UpgradeInfo)) public upgradeInfos;
126         mapping (address => mapping (uint => mapping(address => uint))) public prevTurnovers;
127 
128         IBEP20 public NBU;
129         INimbusReferralProgramUsers rpUsers;
130         INimbusVesting public vestingContract;
131 
132         uint public totalFixedAirdropped;
133         uint public totalVariableAirdropped;
134         uint public airdropProgramCap;
135 
136         uint constant PERCENTAGE_PRECISION = 1e5;
137         uint constant MARKETING_CATEGORY = 3;
138         uint constant REFERRAL_LINES = 1;
139 
140         mapping(address => bool) public isRegionManager;
141         mapping(address => bool) public isHeadOfLocation;
142         mapping(address => address) public userHeadOfLocations;
143         mapping(address => address) public headOfLocationRegionManagers;
144         address[] public regionalManagers;
145         address[] public headOfLocations;
146 
147         mapping(address => uint) public headOfLocationTurnover; //contains the whole structure turnover (more than 6 lines), including userStructureTurnover (only 6 lines turnover)
148         mapping(address => uint) public regionalManagerTurnover;
149         mapping(address => uint) public userPersonalTurnover;
150         mapping(address => uint) public userQualificationLevel;
151         mapping(address => uint) public userQualificationOrigin; //0 - organic, 1 - imported, 2 - set
152         mapping(address => uint) public userMaxLevelPayment;
153         mapping(address => uint) public userUpgradeAllowedToLevel;
154 
155         uint public qualificationsCount;
156         mapping(uint => Qualification) public qualifications;
157 
158         mapping(address => bool) public isAllowedContract;
159         mapping(address => bool) public registrators;
160         mapping(address => bool) public allowedUpdaters;
161         mapping(address => bool) public allowedVerifiers;
162 
163         uint public levelLockPeriod;
164 
165         event Rescue(address indexed to, uint amount);
166         event RescueToken(address indexed token, address indexed to, uint amount);
167 
168         event AirdropFixedReward(address indexed user, uint fixedAirdropped, uint indexed qualification);
169         event AirdropVariableReward(address indexed user, uint variableAirdropped, uint indexed qualification);
170         event QualificationUpdated(address indexed user, uint indexed previousQualificationLevel, uint indexed qualificationLevel, uint systemFee);
171 
172         event UserRegistered(address user, uint indexed sponsorId);
173         event UserRegisteredWithoutHeadOfLocation(address user, uint indexed sponsorId);
174 
175         event LevelLockPeriodSet(uint levelLockPeriod);
176         event PendingQualificationUpdate(address indexed user, uint indexed previousQualificationLevel, uint indexed qualificationLevel);
177 
178         event UpdateReferralProfitAmount(address indexed user, uint amount, uint indexed line);
179         event UpdateHeadOfLocationTurnover(address indexed headOfLocation, uint amount);
180         event UpdateRegionalManagerTurnover(address indexed regionalManager, uint amount);
181         event UpdateAirdropProgramCap(uint indexed newAirdropProgramCap);
182         event UpdateQualification(uint indexed index, uint indexed totalTurnoverAmount, uint indexed percentage, uint fixedReward, uint maxUpdateLevel);
183         event AddHeadOfLocation(address indexed headOfLocation, address indexed regionalManager);
184         event RemoveHeadOfLocation(address indexed headOfLocation);
185         event AddRegionalManager(address indexed regionalManager);
186         event RemoveRegionalManager(address indexed regionalManager);
187         event UpdateRegionalManager(address indexed user, bool indexed isManager);
188         event ImportUserTurnoverSet(address indexed user, uint personalTurnover);
189         event ImportUserMaxLevelPayment(address indexed user, uint maxLevelPayment, bool indexed addToCurrentPayment);
190         event AllowLevelUpgradeForUser(address indexed user, uint currentLevel, uint allowedLevel);
191         event ImportUserTurnoverUpdate(address indexed user, uint newPersonalTurnoverAmount, uint previousPersonalTurnoverAmount);
192         event ImportHeadOfLocationTurnoverUpdate(address indexed headOfLocation, uint previousTurnover, uint newTurnover);
193         event ImportHeadOfLocationTurnoverSet(address indexed headOfLocation, uint turnover);
194         event ImportRegionalManagerTurnoverUpdate(address indexed headOfLocation, uint previousTurnover, uint newTurnover);
195         event ImportRegionalManagerTurnoverSet(address indexed headOfLocation, uint turnover);
196         event ImportUserHeadOfLocation(address indexed user, address indexed headOfLocation);
197         event UpgradeUserQualification(address indexed user, uint indexed previousQualification, uint indexed newQualification, uint newStructureTurnover);
198     }
199 
200 contract NimbusReferralProgramMarketingProxy is NimbusReferralProgramMarketingStorage {
201         address public target;
202         
203         event SetTarget(address indexed newTarget);
204 
205         constructor(address _newTarget) NimbusReferralProgramMarketingStorage() {
206             _setTarget(_newTarget);
207         }
208 
209         fallback() external {
210             if (gasleft() <= 2300) {
211                 return;
212             }
213 
214             address target_ = target;
215             bytes memory data = msg.data;
216             assembly {
217                 let result := delegatecall(gas(), target_, add(data, 0x20), mload(data), 0, 0)
218                 let size := returndatasize()
219                 let ptr := mload(0x40)
220                 returndatacopy(ptr, 0, size)
221                 switch result
222                 case 0 { revert(ptr, size) }
223                 default { return(ptr, size) }
224             }
225         }
226 
227         function setTarget(address _newTarget) external onlyOwner {
228             _setTarget(_newTarget);
229         }
230 
231         function _setTarget(address _newTarget) internal {
232             require(Address.isContract(_newTarget), "Target not a contract");
233             target = _newTarget;
234             emit SetTarget(_newTarget);
235         }
236     }
237 
238 contract NimbusReferralProgramMarketing is NimbusReferralProgramMarketingStorage {
239     address public target;
240 
241     function initialize(address _nbu, address _rpUsers, address _vestingContract) external onlyOwner {
242         require(Address.isContract(_nbu), "_nbu is not a contract");
243         require(Address.isContract(_rpUsers), "_rpUsers is not a contract");
244         require(Address.isContract(_vestingContract), "_vestingContract is not a contract");
245 
246         NBU = IBEP20(_nbu);
247         rpUsers = INimbusReferralProgramUsers(_rpUsers);
248         vestingContract = INimbusVesting(_vestingContract);
249         airdropProgramCap = 75_000_000e18;
250         levelLockPeriod = 1 days;
251     }
252 
253     modifier onlyAllowedContract() {
254         require(isAllowedContract[msg.sender], "Provided address is not an allowed contract");
255         _;
256     }
257 
258     modifier onlyRegistrators() {
259         require(registrators[msg.sender], "Provided address is not a registrator");
260         _;
261     }
262 
263     modifier onlyAllowedUpdaters() {
264         require(allowedUpdaters[msg.sender], "Provided address is not a allowed updater");
265         _;
266     }
267 
268     modifier onlyAllowedVerifiers() {
269         require(allowedVerifiers[msg.sender], "Provided address is not a allowed verifier");
270         _;
271     }
272 
273     function register(uint sponsorId) external returns (uint userId) {
274         return _register(msg.sender, sponsorId);
275     }
276 
277     function registerUser(address user, uint sponsorId) external onlyRegistrators returns (uint userId) {
278         return _register(user, sponsorId);
279     }
280 
281     function registerBySponsorAddress(address sponsor) external returns (uint userId) {
282         uint sponsorId = rpUsers.userIdByAddress(sponsor);
283         return _register(msg.sender, sponsorId);
284     }
285 
286     function registerUserBySponsorAddress(address user, address sponsor) external onlyRegistrators returns (uint userId) {
287         uint sponsorId = rpUsers.userIdByAddress(sponsor);
288         return _register(user, sponsorId);
289     }
290 
291     function updateReferralProfitAmount(address user, uint amount) external onlyAllowedContract {
292         require(rpUsers.userIdByAddress(user) != 0, "User is not a part of referral program");
293 
294         _updateReferralProfitAmount(user, amount, 0, false);
295     }
296 
297     function upgradeLevelsLeft(address user, uint potentialLevel) public view returns (uint) {
298         uint qualificationLevel = userQualificationLevel[user];
299         if (userUpgradeAllowedToLevel[user] >= potentialLevel)
300         return potentialLevel;
301         else if (userUpgradeAllowedToLevel[user] > qualificationLevel && potentialLevel > userUpgradeAllowedToLevel[user])
302         return userUpgradeAllowedToLevel[user];
303 
304         uint upgradedLevelsForPeriod;
305         if (upgradeNonces[user] > 0)
306             {
307                 for (uint i = upgradeNonces[user]; i > 0; i--) {
308                     if (upgradeInfos[user][i].date + levelLockPeriod <= block.timestamp) break;
309                     upgradedLevelsForPeriod += upgradeInfos[user][i].nextLevel - upgradeInfos[user][i].prevLevel;
310                 }
311             }
312         
313         
314         uint maxUpdateLevel = qualifications[qualificationLevel].MaxUpdateLevel;
315 
316         if (upgradedLevelsForPeriod < maxUpdateLevel) {
317             uint toUpgrade = maxUpdateLevel - upgradedLevelsForPeriod;
318             if (potentialLevel >= toUpgrade) return qualificationLevel + toUpgrade;
319             return potentialLevel;
320         }
321         return 0;
322     }
323 
324     function claimRewards(address user, uint256 personalTurnover, address[] memory referralAddresses, uint256[] memory referalTurnovers, uint256 systemFee) external onlyAllowedUpdaters {
325         bool dryRun = systemFee == 0;
326         (uint userFixedAirdropAmount, uint userVariableAirdropAmount, uint potentialLevel, bool isMaxLevel) = getUserRewards(user, personalTurnover, referralAddresses, referalTurnovers, dryRun);
327 
328         require(dryRun || potentialLevel > userQualificationLevel[user], "Upgrade not allowed yet");
329 
330         uint upgradeNonce = ++upgradeNonces[user];
331         upgradeInfos[user][upgradeNonce].date = block.timestamp;
332         upgradeInfos[user][upgradeNonce].prevLevel = userQualificationLevel[user];
333         upgradeInfos[user][upgradeNonce].nextLevel = potentialLevel;
334         for (uint i = 0; i < referralAddresses.length; i++) {
335             require(rpUsers.userSponsorAddressByAddress(referralAddresses[i]) == user, "Wrong referal address");
336             prevTurnovers[user][upgradeNonce][referralAddresses[i]] = referalTurnovers[i];
337         }
338 
339         if (dryRun) {
340             potentialLevel = userQualificationLevel[user];
341             upgradeNonces[user] -= 1;
342             userFixedAirdropAmount = 0;
343             userVariableAirdropAmount = 0;
344         }
345 
346         uint toPayout = 0;
347         if (userFixedAirdropAmount > 0) {
348             totalFixedAirdropped += userFixedAirdropAmount;
349             toPayout += userFixedAirdropAmount;
350             emit AirdropFixedReward(user, userFixedAirdropAmount, potentialLevel);
351         }
352 
353         if (userVariableAirdropAmount > 0) {
354             if (upgradeNonce <= 1) {
355                 uint latestAirdrop = getLatestVestedVariableAirdrop(user);
356                 userVariableAirdropAmount = latestAirdrop < userVariableAirdropAmount ? userVariableAirdropAmount - latestAirdrop : systemFee;
357             }
358             totalVariableAirdropped += userVariableAirdropAmount;
359             toPayout += userVariableAirdropAmount;
360             emit AirdropVariableReward(user, userVariableAirdropAmount, potentialLevel);
361         }
362 
363         require(dryRun || systemFee == userVariableAirdropAmount || toPayout > systemFee, "No rewards or fee more then rewards");
364         if (toPayout - systemFee > 0) TransferHelper.safeTransfer(address(NBU), user, toPayout - systemFee);
365         
366         if (dryRun) return;
367         require(totalAirdropped() <= airdropProgramCap, "Airdrop program reached its cap");
368         emit QualificationUpdated(user, userQualificationLevel[user], potentialLevel, systemFee);
369         userQualificationLevel[user] = potentialLevel;
370         if (isMaxLevel) {
371             userMaxLevelPayment[user] += userVariableAirdropAmount;
372         }
373     }
374 
375 
376     function totalAirdropped() public view returns(uint) {
377         return totalFixedAirdropped + totalVariableAirdropped;
378     }
379 
380     function totalTurnover() public view returns(uint total) {
381         for (uint i = 0; i < regionalManagers.length; i++) {
382             total += regionalManagerTurnover[regionalManagers[i]];
383         }
384     }
385 
386     function getRegionalManagers() public view returns(address[] memory) {
387         return regionalManagers;
388     }
389 
390     function getHeadOfLocations() public view returns(address[] memory) {
391         return headOfLocations;
392     }
393 
394     function canQualificationBeUpgraded(address user, uint256 structureTurnover) external view returns (bool) {
395         uint qualificationLevel = userQualificationLevel[user];
396         return _getUserPotentialQualificationLevel(qualificationLevel, structureTurnover) > qualificationLevel;
397     }
398 
399     function calculateStructureLine(address[] memory referralAddresses, uint256[] memory referalTurnovers) internal pure returns (uint256 structureTurnover) {
400         for (uint i = 0; i < referralAddresses.length; i++) structureTurnover += referalTurnovers[i];
401     }
402 
403     function canQualificationBeUpgradedOrCanClaimMaxLevelReward(address user, uint256 personalTurnover, address[] memory referralAddresses, uint256[] memory referalTurnovers) external view 
404         returns (bool canQualBeUpgraded, bool canClaimMaxLevelReward) 
405     {
406         uint256 structureTurnover = calculateStructureLine(referralAddresses, referalTurnovers);
407         uint qualificationLevel = userQualificationLevel[user];
408         canQualBeUpgraded = _getUserPotentialQualificationLevel(qualificationLevel, structureTurnover) > qualificationLevel;
409         if (qualificationLevel >= qualificationsCount - 1) {
410             (, uint userVariable, ,)  = getUserRewards(user, personalTurnover, referralAddresses, referalTurnovers, false);
411             canClaimMaxLevelReward = userVariable > 0;
412         }
413     }
414 
415     function getUserPotentialQualificationLevel(address user, uint256 structureTurnover) public view returns (uint) {
416         uint qualificationLevel = userQualificationLevel[user];
417         return _getUserPotentialQualificationLevel(qualificationLevel, structureTurnover);
418     }
419 
420     function userFullStructureTurnover(address user) public view returns (uint) {
421         return _userFullStructureTurnover(rpUsers.getUserReferrals(user));
422     }
423 
424     function _userFullStructureTurnover(uint[] memory userReferrals) internal view returns (uint256 structureTurnover) {
425         if (userReferrals.length == 0) return structureTurnover;
426 
427         for (uint i = 0; i < userReferrals.length; i++) {
428             address referralAddress = rpUsers.userAddressById(userReferrals[i]);
429             structureTurnover += userPersonalTurnover[referralAddress] + 
430             _userFullStructureTurnover(rpUsers.getUserReferrals(referralAddress));
431         }
432         return structureTurnover;
433     }
434 
435     function getUserRewards(address user, uint256 personalTurnover, address[] memory referralAddresses, uint256[] memory referalTurnovers, bool noChecks) public view returns (uint userFixed, uint userVariable, uint potentialLevel, bool isMaxLevel) {
436         require(rpUsers.userIdByAddress(user) > 0, "User not registered");
437         require(referralAddresses.length == referalTurnovers.length, "Not equal arrays");
438         require(personalTurnover <= userPersonalTurnover[user], "Wrong personal turnover");
439 
440         uint qualificationLevel = userQualificationLevel[user];
441 
442         uint structureLine = calculateStructureLine(referralAddresses, referalTurnovers);
443         uint turnover = personalTurnover + structureLine;
444         isMaxLevel = qualificationLevel >= (qualificationsCount - 1);
445         
446         if (!isMaxLevel) {
447             potentialLevel = _getUserPotentialQualificationLevel(qualificationLevel, turnover);
448             require(noChecks || potentialLevel > qualificationLevel, "User level not changed");
449         } else {
450             potentialLevel = qualificationsCount - 1;
451         }
452         require(noChecks || upgradeLevelsLeft(user, potentialLevel) >= potentialLevel, "No upgrade levels left");
453 
454         if (referralAddresses.length == 0) return (0, 0, potentialLevel, isMaxLevel);
455         
456         userFixed = _getFixedRewardToBePaidForQualification(structureLine, qualificationLevel, potentialLevel);
457         userVariable = _getVariableRewardToBePaidForQualification(user, referralAddresses, referalTurnovers, potentialLevel);
458         if (isMaxLevel) {
459             if (userVariable > userMaxLevelPayment[user]) userVariable -= userMaxLevelPayment[user];
460         }
461     }
462 
463     function _register(address user, uint sponsorId) private returns (uint userId) {
464         require(rpUsers.userIdByAddress(user) == 0, "User already registered");
465         address sponsor = rpUsers.userAddressById(sponsorId);
466         require(sponsor != address(0), "User sponsor address is equal to 0");
467 
468         address sponsorAddress = rpUsers.userAddressById(sponsorId);
469         if (isHeadOfLocation[sponsorAddress]) {
470             userHeadOfLocations[user] = sponsorAddress;
471         } else {
472             address head = userHeadOfLocations[sponsor];
473             if (head != address(0)){
474                 userHeadOfLocations[user] = head;
475             } else {
476                 emit UserRegisteredWithoutHeadOfLocation(user, sponsorId);
477             }
478         }
479         
480         emit UserRegistered(user, sponsorId);   
481         return rpUsers.registerUserBySponsorId(user, sponsorId, MARKETING_CATEGORY);
482     }
483 
484     function _updateReferralProfitAmount(address user, uint amount, uint line, bool isRegionalAmountUpdated) internal {
485         if (line == 0) {
486             userPersonalTurnover[user] += amount;
487             emit UpdateReferralProfitAmount(user, amount, line);
488             if (isHeadOfLocation[user]) {
489                 headOfLocationTurnover[user] += amount;
490                 address regionalManager = headOfLocationRegionManagers[user];
491                 regionalManagerTurnover[regionalManager] += amount;
492                 isRegionalAmountUpdated = true;
493             } else if (isRegionManager[user]) {
494                 regionalManagerTurnover[user] += amount;
495                 return;
496             } else {
497                 address userSponsor = rpUsers.userSponsorAddressByAddress(user);
498                 _updateReferralProfitAmount(userSponsor, amount, 1, isRegionalAmountUpdated);
499             }
500         } else {
501             emit UpdateReferralProfitAmount(user, amount, line);
502             if (isHeadOfLocation[user]) {
503                 headOfLocationTurnover[user] += amount;
504                 address regionalManager = headOfLocationRegionManagers[user];
505                 if (!isRegionalAmountUpdated) {
506                     regionalManagerTurnover[regionalManager] += amount;
507                     isRegionalAmountUpdated = true;
508                 }
509             } else if (isRegionManager[user]) {
510                 if (!isRegionalAmountUpdated) regionalManagerTurnover[user] += amount;
511                 return;
512             }
513 
514             if (line >= REFERRAL_LINES) {
515                 if (!isRegionalAmountUpdated) _updateReferralHeadOfLocationAndRegionalTurnover(user, amount);
516                 return;
517             }
518 
519             address userSponsor = rpUsers.userSponsorAddressByAddress(user);
520             if (userSponsor == address(0)) {
521                 if (!isRegionalAmountUpdated) _updateReferralHeadOfLocationAndRegionalTurnover(user, amount);
522                 return;
523             }
524 
525             _updateReferralProfitAmount(userSponsor, amount, ++line, isRegionalAmountUpdated);
526         }
527     }
528 
529     function _updateReferralHeadOfLocationAndRegionalTurnover(address user, uint amount) internal {
530         address headOfLocation = userHeadOfLocations[user];
531         if (headOfLocation == address(0)) return;
532         headOfLocationTurnover[headOfLocation] += amount;
533         address regionalManager = headOfLocationRegionManagers[user];
534         emit UpdateHeadOfLocationTurnover(headOfLocation, amount);
535         if (regionalManager == address(0)) return;
536         regionalManagerTurnover[regionalManager] += amount;
537         emit UpdateRegionalManagerTurnover(regionalManager, amount);
538     }
539 
540     function _getUserPotentialQualificationLevel(uint qualificationLevel, uint256 turnover) internal view returns (uint) {
541         if (qualificationLevel >= qualificationsCount) return qualificationsCount - 1;
542         
543         for (uint i = qualificationLevel; i < qualificationsCount; i++) {
544             if (qualifications[i+1].TotalTurnover > turnover) {
545                 return i;
546             }
547         }
548         return qualificationsCount - 1; //user gained max qualification
549     }
550 
551     function _getFixedRewardToBePaidForQualification(uint structureTurnover, uint qualificationLevel, uint potentialLevel) internal view returns (uint userFixed) { 
552         if (structureTurnover == 0) return 0;
553 
554         for (uint i = qualificationLevel + 1; i <= potentialLevel; i++) {
555             uint fixedRewardAmount = qualifications[i].FixedReward;
556             if (fixedRewardAmount > 0) {
557                 userFixed += fixedRewardAmount;
558             }
559         }
560     }
561 
562     function _getVariableRewardToBePaidForQualification(address user, address[] memory referralAddresses, uint256[] memory referralTurnovers, uint qualification) internal view returns (uint userVariable) {
563         uint userQualificationPercentage = qualifications[qualification].Percentage;
564         for (uint i; i < referralAddresses.length; i++) {
565             uint referralTurnover = referralTurnovers[i];
566             uint referralQualification = getUserPotentialQualificationLevel(referralAddresses[i], referralTurnover);
567             uint referralPercentage = qualifications[referralQualification].Percentage;
568             if (referralPercentage >= userQualificationPercentage) continue;
569             if (upgradeNonces[user] > 0) {
570                 uint prevTurnover = prevTurnovers[user][upgradeNonces[user]][referralAddresses[i]];
571                 if (referralTurnover < prevTurnover) referralTurnover = prevTurnover;
572                 else referralTurnover -= prevTurnover;
573             }
574             userVariable += (userQualificationPercentage - referralPercentage) * referralTurnover / PERCENTAGE_PRECISION;
575         }
576     }
577 
578     function getLatestVestedVariableAirdrop(address user) public view returns(uint) {
579         for (uint i = vestingContract.vestingNonces(user); i > 0; i--) {
580             INimbusVesting.VestingInfo memory info = vestingContract.vestingInfos(user, i);
581             if (info.vestingType == 12) return info.vestingAmount;
582         }
583         return 0;
584     }
585 
586     function updateVestingContract(address vestingContractAddress) external onlyOwner {
587         require(Address.isContract(vestingContractAddress), "Not a contract");
588         vestingContract = INimbusVesting(vestingContractAddress);
589     }
590 
591     function updateRegistrator(address registrator, bool isActive) external onlyOwner {
592         require(registrator != address(0), "Registrator address is equal to 0");
593         registrators[registrator] = isActive;
594     }
595 
596     function updateAllowedUpdater(address updater, bool isActive) external onlyOwner {
597         require(updater != address(0), "Updater address is equal to 0");
598         allowedUpdaters[updater] = isActive;
599     }
600 
601     function updateAllowedVerifier(address verifier, bool isActive) external onlyOwner {
602         require(verifier != address(0), "Verifier address is equal to 0");
603         allowedVerifiers[verifier] = isActive;
604     }
605 
606     function updateAllowedContract(address _contract, bool _isAllowed) external onlyOwner {
607         require(Address.isContract(_contract), "Provided address is not a contract");
608         isAllowedContract[_contract] = _isAllowed;
609     }
610 
611     function updateQualifications(uint[] memory totalTurnoverAmounts, uint[] memory percentages, uint[] memory fixedRewards, uint[] memory maxUpdateLevels) external onlyOwner {
612         require(totalTurnoverAmounts.length == percentages.length && totalTurnoverAmounts.length == fixedRewards.length && totalTurnoverAmounts.length == maxUpdateLevels.length, "Arrays length are not equal");
613         qualificationsCount = 0;
614 
615         for (uint i; i < totalTurnoverAmounts.length; i++) {
616             _updateQualification(i, totalTurnoverAmounts[i], percentages[i], fixedRewards[i], maxUpdateLevels[i]);
617         }
618         qualificationsCount = totalTurnoverAmounts.length;
619     }
620 
621     function updateAirdropProgramCap(uint newAirdropProgramCap) external onlyOwner {
622         require(newAirdropProgramCap > 0, "Airdrop cap must be grater then 0");
623         airdropProgramCap = newAirdropProgramCap;
624         emit UpdateAirdropProgramCap(newAirdropProgramCap);
625     }
626 
627     function setUserQualification(address user, uint qualification, bool updateTurnover) external onlyOwner {
628         _upgradeUserQualification(user, qualification, updateTurnover);
629     }
630 
631     function setUserQualifications(address[] memory users, uint[] memory newQualifications, bool updateTurnover) external onlyOwner {
632         require(users.length == newQualifications.length, "Arrays length are not equal");
633         for (uint i; i < users.length; i++) {
634             _upgradeUserQualification(users[i], newQualifications[i], updateTurnover);
635         }
636     }
637 
638     function addHeadOfLocation(address headOfLocation, address regionalManager) external onlyOwner {
639         _addHeadOfLocation(headOfLocation, regionalManager);
640     }
641 
642     function addHeadOfLocations(address[] memory headOfLocation, address[] memory managers) external onlyOwner {
643         require(headOfLocation.length == managers.length, "Arrays length are not equal");
644         for (uint i; i < headOfLocation.length; i++) {
645             _addHeadOfLocation(headOfLocation[i], managers[i]);
646         }
647     }
648 
649     function removeHeadOfLocation(uint index) external onlyOwner {
650         require (headOfLocations.length > index, "Incorrect index");
651         address headOfLocation = headOfLocations[index];
652         headOfLocations[index] = headOfLocations[headOfLocations.length - 1];
653         headOfLocations.pop(); 
654         isHeadOfLocation[headOfLocation] = false;
655         emit RemoveHeadOfLocation(headOfLocation);
656     }
657 
658     function updateLevelLockPeriod(uint newLevelLockPeriod) external onlyOwner {
659         levelLockPeriod = newLevelLockPeriod;
660         emit LevelLockPeriodSet(newLevelLockPeriod);
661     }
662 
663     function addRegionalManager(address regionalManager) external onlyOwner {
664         _addRegionalManager(regionalManager);
665     }
666 
667     function addRegionalManagers(address[] memory managers) external onlyOwner {
668         for (uint i; i < managers.length; i++) {
669             _addRegionalManager(managers[i]);
670         }
671     }
672 
673     function removeRegionalManager(uint index) external onlyOwner {
674         require (regionalManagers.length > index, "Incorrect index");
675         address regionalManager = regionalManagers[index];
676         regionalManagers[index] = regionalManagers[regionalManagers.length - 1];
677         regionalManagers.pop(); 
678         isRegionManager[regionalManager] = false;
679         emit RemoveRegionalManager(regionalManager);
680     }
681 
682     function importUserHeadOfLocation(address user, address headOfLocation, bool isSilent) external onlyOwner {
683         _importUserHeadOfLocation(user, headOfLocation, isSilent);
684     }
685 
686     function importUserHeadOfLocations(address[] memory users, address[] memory headOfLocationsLocal, bool isSilent) external onlyOwner {
687         require(users.length == headOfLocationsLocal.length, "Array length missmatch");
688         for(uint i = 0; i < users.length; i++) {
689             _importUserHeadOfLocation(users[i], headOfLocationsLocal[i], isSilent);
690         }
691     }
692     
693     function importUserTurnover(address user, uint personalTurnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel, bool isSilent) external onlyOwner {
694         _importUserTurnover(user, personalTurnover, levelHint, addToCurrentTurnover, updateLevel, isSilent);
695     }
696 
697     function importUserTurnovers(address[] memory users, uint[] memory personalTurnovers, uint[] memory levelsHints, bool addToCurrentTurnover, bool updateLevel, bool isSilent) external onlyOwner {
698         require(users.length == personalTurnovers.length && 
699             users.length == levelsHints.length, "Array length missmatch");
700 
701         for(uint i = 0; i < users.length; i++) {
702             _importUserTurnover(users[i], personalTurnovers[i], levelsHints[i], addToCurrentTurnover, updateLevel, isSilent);
703         }
704     }
705 
706     function importHeadOfLocationTurnover(address headOfLocation, uint turnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel) external onlyOwner {
707         _importHeadOfLocationTurnover(headOfLocation, turnover, levelHint, addToCurrentTurnover, updateLevel);
708     }
709 
710     function importHeadOfLocationTurnovers(address[] memory heads, uint[] memory turnovers, uint[] memory levelsHints, bool addToCurrentTurnover, bool updateLevel) external onlyOwner {
711         require(heads.length == turnovers.length, "Array length missmatch");
712 
713         for(uint i = 0; i < heads.length; i++) {
714             _importHeadOfLocationTurnover(heads[i], turnovers[i], levelsHints[i], addToCurrentTurnover, updateLevel);
715         }
716     }
717 
718     function importRegionalManagerTurnover(address headOfLocation, uint turnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel) external onlyOwner {
719         _importRegionalManagerTurnover(headOfLocation, turnover, levelHint, addToCurrentTurnover, updateLevel);
720     }
721 
722     function importRegionalManagerTurnovers(address[] memory managers, uint[] memory turnovers, uint[] memory levelsHints, bool addToCurrentTurnover, bool updateLevel) external onlyOwner {
723         require(managers.length == turnovers.length && managers.length == levelsHints.length, "Array length missmatch");
724 
725         for(uint i = 0; i < managers.length; i++) {
726             _importRegionalManagerTurnover(managers[i], turnovers[i], levelsHints[i], addToCurrentTurnover, updateLevel);
727         }
728     }
729 
730     function allowLevelUpgradeForUsers(address[] memory users, uint[] memory levels) external onlyAllowedVerifiers {
731         require(users.length == levels.length, "Array length missmatch");
732         for(uint i = 0; i < users.length; i++) {
733             _allowLevelUpgradeForUser(users[i], levels[i]);
734         }
735     }
736 
737     function _allowLevelUpgradeForUser(address user, uint level) internal {
738         require(userQualificationLevel[user] <= level, "Level below current");
739         userUpgradeAllowedToLevel[user] = level;
740         emit AllowLevelUpgradeForUser(user, userQualificationLevel[user], level);
741     }
742 
743     function importUserMaxLevelPayment(address user, uint maxLevelPayment, bool addToCurrentPayment) external onlyOwner { 
744         _importUserMaxLevelPayment(user, maxLevelPayment, addToCurrentPayment);
745     }
746 
747     function importUserMaxLevelPayments(address[] memory users, uint[] memory maxLevelPayments, bool addToCurrentPayment) external onlyOwner { 
748         require(users.length == maxLevelPayments.length, "Array length missmatch");
749 
750         for(uint i = 0; i < users.length; i++) {
751             _importUserMaxLevelPayment(users[i], maxLevelPayments[i], addToCurrentPayment);
752         }
753     }
754 
755     
756 
757 
758     function _addHeadOfLocation(address headOfLocation, address regionalManager) internal {
759         require(!isHeadOfLocation[headOfLocation], "HOL already added");
760         require(isRegionManager[regionalManager], "Regional manager not exists");
761         require(rpUsers.userIdByAddress(headOfLocation) > 1000000001, "HOL not in referral system or first user");
762         headOfLocations.push(headOfLocation);
763         isHeadOfLocation[headOfLocation] = true;
764         headOfLocationRegionManagers[headOfLocation] = regionalManager;
765         emit AddHeadOfLocation(headOfLocation, regionalManager);
766     }
767 
768     function _addRegionalManager(address regionalManager) internal {
769         require(!isRegionManager[regionalManager], "Regional manager exist");
770         require(rpUsers.userIdByAddress(regionalManager) > 1000000001, "Regional manager not in referral system or first user");
771         regionalManagers.push(regionalManager);
772         isRegionManager[regionalManager] = true;
773         emit AddRegionalManager(regionalManager);
774     }
775 
776     function _upgradeUserQualification(address user, uint qualification, bool updateTurnover) internal {
777         require(qualification < qualificationsCount, "Incorrect qualification index");
778         require(userQualificationLevel[user] < qualification, "Can't donwgrade user qualification");
779         uint newTurnover;
780         if (updateTurnover) newTurnover = qualifications[qualification].TotalTurnover;
781         emit UpgradeUserQualification(user, userQualificationLevel[user], qualification, newTurnover);
782         userQualificationLevel[user] = qualification;
783         userQualificationOrigin[user] = 2;
784     }
785 
786     function _importUserHeadOfLocation(address user, address headOfLocation, bool isSilent) internal onlyOwner {
787         require(isHeadOfLocation[headOfLocation], "Not HOL");
788         userHeadOfLocations[user] = headOfLocation;
789         if (!isSilent) emit ImportUserHeadOfLocation(user, headOfLocation);
790     }
791 
792     function _updateQualification(uint index, uint totalTurnoverAmount, uint percentage, uint fixedReward, uint maxUpdateLevel) internal {
793         //Total turnover amount can be zero for the first qualification (zero qualification), so check and require is not needed
794         qualifications[index] = Qualification(index, totalTurnoverAmount, percentage, fixedReward, maxUpdateLevel);
795         emit UpdateQualification(index, totalTurnoverAmount, percentage, fixedReward, maxUpdateLevel);
796     }
797 
798     function _importUserTurnover(address user, uint personalTurnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel, bool isSilent) private {
799         require(rpUsers.userIdByAddress(user) != 0, "User is not registered");
800 
801         if (addToCurrentTurnover) {
802             uint previousPersonalTurnover = userPersonalTurnover[user];
803             uint newPersonalTurnover = previousPersonalTurnover + personalTurnover;
804             if (!isSilent) emit ImportUserTurnoverUpdate(user, newPersonalTurnover, previousPersonalTurnover);
805             userPersonalTurnover[user] = newPersonalTurnover;
806         } else {
807             userPersonalTurnover[user] = personalTurnover;
808             if (!isSilent) emit ImportUserTurnoverSet(user, personalTurnover);
809         }
810 
811         if (updateLevel) {
812             uint potentialLevel = levelHint;
813             if (potentialLevel > 0) {
814                 userQualificationLevel[user] = potentialLevel;
815                 if (!isSilent) emit QualificationUpdated(user, 0, potentialLevel, 0);
816             }
817         }
818         userQualificationOrigin[user] = 1;
819     }
820 
821     function _importHeadOfLocationTurnover(address headOfLocation, uint turnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel) private {
822         require(isHeadOfLocation[headOfLocation], "User is not HOL");
823 
824         uint actualTurnover;
825         if (addToCurrentTurnover) {
826             uint previousTurnover = headOfLocationTurnover[headOfLocation];
827 
828             actualTurnover = previousTurnover + turnover;
829             emit ImportHeadOfLocationTurnoverUpdate(headOfLocation, previousTurnover, actualTurnover);
830             headOfLocationTurnover[headOfLocation] = actualTurnover;
831         } else {
832             headOfLocationTurnover[headOfLocation] = turnover;
833             emit ImportHeadOfLocationTurnoverSet(headOfLocation, turnover);
834             actualTurnover = turnover;
835         }
836 
837         if (updateLevel) {
838             uint potentialLevel = levelHint;
839             if (potentialLevel > 0) {
840                 userQualificationLevel[headOfLocation] = potentialLevel;
841                 emit QualificationUpdated(headOfLocation, 0, potentialLevel, 0);
842             }
843         }
844         userQualificationOrigin[headOfLocation] = 1;
845     }
846 
847     function _importRegionalManagerTurnover(address regionalManager, uint turnover, uint levelHint, bool addToCurrentTurnover, bool updateLevel) private {
848         require(isRegionManager[regionalManager], "User is not HOL");
849         require(levelHint < qualificationsCount, "Incorrect level hint");
850 
851         uint actualTurnover;
852         if (addToCurrentTurnover) {
853             uint previousTurnover = regionalManagerTurnover[regionalManager];
854 
855             actualTurnover = previousTurnover + turnover;
856             emit ImportRegionalManagerTurnoverUpdate(regionalManager, previousTurnover, actualTurnover);
857             regionalManagerTurnover[regionalManager] = actualTurnover;
858         } else {
859             regionalManagerTurnover[regionalManager] = turnover;
860             emit ImportRegionalManagerTurnoverSet(regionalManager, turnover);
861             actualTurnover = turnover;
862         }
863 
864         if (updateLevel) {
865             uint potentialLevel = levelHint;
866             if (potentialLevel > 0) {
867                 userQualificationLevel[regionalManager] = potentialLevel;
868                 emit QualificationUpdated(regionalManager, 0, potentialLevel, 0);
869             }
870         }
871         userQualificationOrigin[regionalManager] = 1;
872     }
873 
874     function _importUserMaxLevelPayment(address user, uint maxLevelPayment, bool addToCurrentPayment) internal {
875         require(userQualificationLevel[user] >= qualificationsCount - 1, "Not max level user");
876         if (addToCurrentPayment) {
877             userMaxLevelPayment[user] += maxLevelPayment;
878         } else {
879             userMaxLevelPayment[user] = maxLevelPayment;
880         }
881         emit ImportUserMaxLevelPayment(user, maxLevelPayment, addToCurrentPayment);
882     }
883 
884     function rescue(address payable to, uint256 amount) external onlyOwner {
885         require(to != address(0), "Can't be zero address");
886         require(amount > 0, "Should be greater than 0");
887         TransferHelper.safeTransferBNB(to, amount);
888         emit Rescue(to, amount);
889     }
890 
891     function rescue(address to, address token, uint256 amount) external onlyOwner {
892         require(to != address(0), "Can't be zero address");
893         require(amount > 0, "Should be greater than 0");
894         TransferHelper.safeTransfer(token, to, amount);
895         emit RescueToken(token, to, amount);
896     }
897 
898     function availableAirdropSupply() external view returns (uint) {
899         return NBU.balanceOf(address(this));
900     }
901 }