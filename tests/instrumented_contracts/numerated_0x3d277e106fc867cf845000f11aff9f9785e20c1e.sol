1 pragma solidity ^0.4.19;
2 
3 contract ERC721 {
4     // Required methods
5     function totalSupply() public view returns (uint256 total);
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function ownerOf(uint256 _tokenId) external view returns (address owner);
8     function approve(address _to, uint256 _tokenId) external;
9     function transfer(address _to, uint256 _tokenId) external;
10     function transferFrom(address _from, address _to, uint256 _tokenId) external;
11 
12     // Events
13     event Transfer(address from, address to, uint256 tokenId);
14     event Approval(address owner, address approved, uint256 tokenId);
15 
16     // Optional
17     // function name() public view returns (string name);
18     // function symbol() public view returns (string symbol);
19     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
20     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
21     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
22     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
23     function getBeneficiary() external view returns(address);
24 }
25 
26 contract SanctuaryInterface {
27     /// @dev simply a boolean to indicate this is the contract we expect to be
28     function isSanctuary() public pure returns (bool);
29 
30     /// @dev generate new warrior genes
31     /// @param _heroGenes Genes of warrior that have completed dungeon
32     /// @param _heroLevel Level of the warrior
33     /// @return the genes that are supposed to be passed down to newly arisen warrior
34     function generateWarrior(uint256 _heroGenes, uint256 _heroLevel, uint256 _targetBlock, uint256 _perkId) public returns (uint256);
35 }
36 
37 contract PVPInterface {
38     /// @dev simply a boolean to indicate this is the contract we expect to be
39     function isPVPProvider() external pure returns (bool);
40     
41     function addTournamentContender(address _owner, uint256[] _tournamentData) external payable;
42     function getTournamentThresholdFee() public view returns(uint256);
43     
44     function addPVPContender(address _owner, uint256 _packedWarrior) external payable;
45     function getPVPEntranceFee(uint256 _levelPoints) external view returns(uint256);
46 }
47 
48 contract PVPListenerInterface {
49     /// @dev simply a boolean to indicate this is the contract we expect to be
50     function isPVPListener() public pure returns (bool);
51     function getBeneficiary() external view returns(address);
52     
53     function pvpFinished(uint256[] warriorData, uint256 matchingCount) public;
54     function pvpContenderRemoved(uint256 _warriorId) public;
55     function tournamentFinished(uint256[] packedContenders) public;
56 }
57 
58 contract PermissionControll {
59     // This facet controls access to contract that implements it. There are four roles managed here:
60     //
61     // - The Admin: The Admin can reassign admin and issuer roles and change the addresses of our dependent smart
62     // contracts. It is also the only role that can unpause the smart contract. It is initially
63     // set to the address that created the smart contract in the CryptoWarriorCore constructor.
64     //
65     // - The Bank: The Bank can withdraw funds from CryptoWarriorCore and its auction and battle contracts, and change admin role.
66     //
67     // - The Issuer: The Issuer can release gen0 warriors to auction.
68     //
69     // / @dev Emited when contract is upgraded
70     event ContractUpgrade(address newContract);
71     
72     // Set in case the core contract is broken and an upgrade is required
73     address public newContractAddress;
74 
75     // The addresses of the accounts (or contracts) that can execute actions within each roles.
76     address public adminAddress;
77     address public bankAddress;
78     address public issuerAddress; 
79     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
80     bool public paused = false;
81     
82 
83     // / @dev Access modifier for Admin-only functionality
84     modifier onlyAdmin(){
85         require(msg.sender == adminAddress);
86         _;
87     }
88 
89     // / @dev Access modifier for Bank-only functionality
90     modifier onlyBank(){
91         require(msg.sender == bankAddress);
92         _;
93     }
94     
95     /// @dev Access modifier for Issuer-only functionality
96     modifier onlyIssuer(){
97     		require(msg.sender == issuerAddress);
98         _;
99     }
100     
101     modifier onlyAuthorized(){
102         require(msg.sender == issuerAddress ||
103             msg.sender == adminAddress ||
104             msg.sender == bankAddress);
105         _;
106     }
107 
108 
109     // / @dev Assigns a new address to act as the Bank. Only available to the current Bank.
110     // / @param _newBank The address of the new Bank
111     function setBank(address _newBank) external onlyBank {
112         require(_newBank != address(0));
113         bankAddress = _newBank;
114     }
115 
116     // / @dev Assigns a new address to act as the Admin. Only available to the current Admin.
117     // / @param _newAdmin The address of the new Admin
118     function setAdmin(address _newAdmin) external {
119         require(msg.sender == adminAddress || msg.sender == bankAddress);
120         require(_newAdmin != address(0));
121         adminAddress = _newAdmin;
122     }
123     
124     // / @dev Assigns a new address to act as the Issuer. Only available to the current Issuer.
125     // / @param _newIssuer The address of the new Issuer
126     function setIssuer(address _newIssuer) external onlyAdmin{
127         require(_newIssuer != address(0));
128         issuerAddress = _newIssuer;
129     }
130 
131     /*** Pausable functionality adapted from OpenZeppelin ***/
132     // / @dev Modifier to allow actions only when the contract IS NOT paused
133     modifier whenNotPaused(){
134         require(!paused);
135         _;
136     }
137 
138     // / @dev Modifier to allow actions only when the contract IS paused
139     modifier whenPaused{
140         require(paused);
141         _;
142     }
143 
144     // / @dev Called by any "Authorized" role to pause the contract. Used only when
145     // /  a bug or exploit is detected and we need to limit damage.
146     function pause() external onlyAuthorized whenNotPaused{
147         paused = true;
148     }
149 
150     // / @dev Unpauses the smart contract. Can only be called by the Admin.
151     // / @notice This is public rather than external so it can be called by
152     // /  derived contracts.
153     function unpause() public onlyAdmin whenPaused{
154         // can't unpause if contract was upgraded
155         paused = false;
156     }
157     
158     
159     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
160     ///  breaking bug. This method does nothing but keep track of the new contract and
161     ///  emit a message indicating that the new address is set. It's up to clients of this
162     ///  contract to update to the new contract address in that case. (This contract will
163     ///  be paused indefinitely if such an upgrade takes place.)
164     /// @param _v2Address new address
165     function setNewAddress(address _v2Address) external onlyAdmin whenPaused {
166         newContractAddress = _v2Address;
167         ContractUpgrade(_v2Address);
168     }
169 }
170 
171 contract Ownable {
172     address public owner;
173 
174     /**
175      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
176      * account.
177      */
178     function Ownable() public{
179         owner = msg.sender;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner(){
186         require(msg.sender == owner);
187         _;
188     }
189 
190     /**
191      * @dev Allows the current owner to transfer control of the contract to a newOwner.
192      * @param newOwner The address to transfer ownership to.
193      */
194     function transferOwnership(address newOwner) public onlyOwner{
195         if (newOwner != address(0)) {
196             owner = newOwner;
197         }
198     }
199 }
200 
201 contract PausableBattle is Ownable {
202     event PausePVP(bool paused);
203     event PauseTournament(bool paused);
204     
205     bool public pvpPaused = false;
206     bool public tournamentPaused = false;
207     
208     /** PVP */
209     modifier PVPNotPaused(){
210         require(!pvpPaused);
211         _;
212     }
213 
214     modifier PVPPaused{
215         require(pvpPaused);
216         _;
217     }
218 
219     function pausePVP() public onlyOwner PVPNotPaused {
220         pvpPaused = true;
221         PausePVP(true);
222     }
223 
224     function unpausePVP() public onlyOwner PVPPaused {
225         pvpPaused = false;
226         PausePVP(false);
227     }
228     
229     /** Tournament */
230     modifier TournamentNotPaused(){
231         require(!tournamentPaused);
232         _;
233     }
234 
235     modifier TournamentPaused{
236         require(tournamentPaused);
237         _;
238     }
239 
240     function pauseTournament() public onlyOwner TournamentNotPaused {
241         tournamentPaused = true;
242         PauseTournament(true);
243     }
244 
245     function unpauseTournament() public onlyOwner TournamentPaused {
246         tournamentPaused = false;
247         PauseTournament(false);
248     }
249     
250 }
251 
252 contract Pausable is Ownable {
253     event Pause();
254 
255     event Unpause();
256 
257     bool public paused = false;
258 
259     /**
260      * @dev modifier to allow actions only when the contract IS paused
261      */
262     modifier whenNotPaused(){
263         require(!paused);
264         _;
265     }
266 
267     /**
268      * @dev modifier to allow actions only when the contract IS NOT paused
269      */
270     modifier whenPaused{
271         require(paused);
272         _;
273     }
274 
275     /**
276      * @dev called by the owner to pause, triggers stopped state
277      */
278     function pause() public onlyOwner whenNotPaused {
279         paused = true;
280         Pause();
281     }
282 
283     /**
284      * @dev called by the owner to unpause, returns to normal state
285      */
286     function unpause() public onlyOwner whenPaused {
287         paused = false;
288         Unpause();
289     }
290 }
291 
292 library CryptoUtils {
293    
294     /* CLASSES */
295     uint256 internal constant WARRIOR = 0;
296     uint256 internal constant ARCHER = 1;
297     uint256 internal constant MAGE = 2;
298     /* RARITIES */
299     uint256 internal constant COMMON = 1;
300     uint256 internal constant UNCOMMON = 2;
301     uint256 internal constant RARE = 3;
302     uint256 internal constant MYTHIC = 4;
303     uint256 internal constant LEGENDARY = 5;
304     uint256 internal constant UNIQUE = 6;
305     /* LIMITS */
306     uint256 internal constant CLASS_MECHANICS_MAX = 3;
307     uint256 internal constant RARITY_MAX = 6;
308     /*@dev range used for rarity chance computation */
309     uint256 internal constant RARITY_CHANCE_RANGE = 10000000;
310     uint256 internal constant POINTS_TO_LEVEL = 10;
311     /* ATTRIBUTE MASKS */
312     /*@dev range 0-9999 */
313     uint256 internal constant UNIQUE_MASK_0 = 1;
314     /*@dev range 0-9 */
315     uint256 internal constant RARITY_MASK_1 = UNIQUE_MASK_0 * 10000;
316     /*@dev range 0-999 */
317     uint256 internal constant CLASS_VIEW_MASK_2 = RARITY_MASK_1 * 10;
318     /*@dev range 0-999 */
319     uint256 internal constant BODY_COLOR_MASK_3 = CLASS_VIEW_MASK_2 * 1000;
320     /*@dev range 0-999 */
321     uint256 internal constant EYES_MASK_4 = BODY_COLOR_MASK_3 * 1000;
322     /*@dev range 0-999 */
323     uint256 internal constant MOUTH_MASK_5 = EYES_MASK_4 * 1000;
324     /*@dev range 0-999 */
325     uint256 internal constant HEIR_MASK_6 = MOUTH_MASK_5 * 1000;
326     /*@dev range 0-999 */
327     uint256 internal constant HEIR_COLOR_MASK_7 = HEIR_MASK_6 * 1000;
328     /*@dev range 0-999 */
329     uint256 internal constant ARMOR_MASK_8 = HEIR_COLOR_MASK_7 * 1000;
330     /*@dev range 0-999 */
331     uint256 internal constant WEAPON_MASK_9 = ARMOR_MASK_8 * 1000;
332     /*@dev range 0-999 */
333     uint256 internal constant HAT_MASK_10 = WEAPON_MASK_9 * 1000;
334     /*@dev range 0-99 */
335     uint256 internal constant RUNES_MASK_11 = HAT_MASK_10 * 1000;
336     /*@dev range 0-99 */
337     uint256 internal constant WINGS_MASK_12 = RUNES_MASK_11 * 100;
338     /*@dev range 0-99 */
339     uint256 internal constant PET_MASK_13 = WINGS_MASK_12 * 100;
340     /*@dev range 0-99 */
341     uint256 internal constant BORDER_MASK_14 = PET_MASK_13 * 100;
342     /*@dev range 0-99 */
343     uint256 internal constant BACKGROUND_MASK_15 = BORDER_MASK_14 * 100;
344     /*@dev range 0-99 */
345     uint256 internal constant INTELLIGENCE_MASK_16 = BACKGROUND_MASK_15 * 100;
346     /*@dev range 0-99 */
347     uint256 internal constant AGILITY_MASK_17 = INTELLIGENCE_MASK_16 * 100;
348     /*@dev range 0-99 */
349     uint256 internal constant STRENGTH_MASK_18 = AGILITY_MASK_17 * 100;
350     /*@dev range 0-9 */
351     uint256 internal constant CLASS_MECH_MASK_19 = STRENGTH_MASK_18 * 100;
352     /*@dev range 0-999 */
353     uint256 internal constant RARITY_BONUS_MASK_20 = CLASS_MECH_MASK_19 * 10;
354     /*@dev range 0-9 */
355     uint256 internal constant SPECIALITY_MASK_21 = RARITY_BONUS_MASK_20 * 1000;
356     /*@dev range 0-99 */
357     uint256 internal constant DAMAGE_MASK_22 = SPECIALITY_MASK_21 * 10;
358     /*@dev range 0-99 */
359     uint256 internal constant AURA_MASK_23 = DAMAGE_MASK_22 * 100;
360     /*@dev 20 decimals left */
361     uint256 internal constant BASE_MASK_24 = AURA_MASK_23 * 100;
362     
363     
364     /* SPECIAL PERKS */
365     uint256 internal constant MINER_PERK = 1;
366     
367     
368     /* PARAM INDEXES */
369     uint256 internal constant BODY_COLOR_MAX_INDEX_0 = 0;
370     uint256 internal constant EYES_MAX_INDEX_1 = 1;
371     uint256 internal constant MOUTH_MAX_2 = 2;
372     uint256 internal constant HAIR_MAX_3 = 3;
373     uint256 internal constant HEIR_COLOR_MAX_4 = 4;
374     uint256 internal constant ARMOR_MAX_5 = 5;
375     uint256 internal constant WEAPON_MAX_6 = 6;
376     uint256 internal constant HAT_MAX_7 = 7;
377     uint256 internal constant RUNES_MAX_8 = 8;
378     uint256 internal constant WINGS_MAX_9 = 9;
379     uint256 internal constant PET_MAX_10 = 10;
380     uint256 internal constant BORDER_MAX_11 = 11;
381     uint256 internal constant BACKGROUND_MAX_12 = 12;
382     uint256 internal constant UNIQUE_INDEX_13 = 13;
383     uint256 internal constant LEGENDARY_INDEX_14 = 14;
384     uint256 internal constant MYTHIC_INDEX_15 = 15;
385     uint256 internal constant RARE_INDEX_16 = 16;
386     uint256 internal constant UNCOMMON_INDEX_17 = 17;
387     uint256 internal constant UNIQUE_TOTAL_INDEX_18 = 18;
388     
389      /* PACK PVP DATA LOGIC */
390     //pvp data
391     uint256 internal constant CLASS_PACK_0 = 1;
392     uint256 internal constant RARITY_BONUS_PACK_1 = CLASS_PACK_0 * 10;
393     uint256 internal constant RARITY_PACK_2 = RARITY_BONUS_PACK_1 * 1000;
394     uint256 internal constant EXPERIENCE_PACK_3 = RARITY_PACK_2 * 10;
395     uint256 internal constant INTELLIGENCE_PACK_4 = EXPERIENCE_PACK_3 * 1000;
396     uint256 internal constant AGILITY_PACK_5 = INTELLIGENCE_PACK_4 * 100;
397     uint256 internal constant STRENGTH_PACK_6 = AGILITY_PACK_5 * 100;
398     uint256 internal constant BASE_DAMAGE_PACK_7 = STRENGTH_PACK_6 * 100;
399     uint256 internal constant PET_PACK_8 = BASE_DAMAGE_PACK_7 * 100;
400     uint256 internal constant AURA_PACK_9 = PET_PACK_8 * 100;
401     uint256 internal constant WARRIOR_ID_PACK_10 = AURA_PACK_9 * 100;
402     uint256 internal constant PVP_CYCLE_PACK_11 = WARRIOR_ID_PACK_10 * 10**10;
403     uint256 internal constant RATING_PACK_12 = PVP_CYCLE_PACK_11 * 10**10;
404     uint256 internal constant PVP_BASE_PACK_13 = RATING_PACK_12 * 10**10;//NB rating must be at the END!
405     
406     //tournament data
407     uint256 internal constant HP_PACK_0 = 1;
408     uint256 internal constant DAMAGE_PACK_1 = HP_PACK_0 * 10**12;
409     uint256 internal constant ARMOR_PACK_2 = DAMAGE_PACK_1 * 10**12;
410     uint256 internal constant DODGE_PACK_3 = ARMOR_PACK_2 * 10**12;
411     uint256 internal constant PENETRATION_PACK_4 = DODGE_PACK_3 * 10**12;
412     uint256 internal constant COMBINE_BASE_PACK_5 = PENETRATION_PACK_4 * 10**12;
413     
414     /* MISC CONSTANTS */
415     uint256 internal constant MAX_ID_SIZE = 10000000000;
416     int256 internal constant PRECISION = 1000000;
417     
418     uint256 internal constant BATTLES_PER_CONTENDER = 10;//10x100
419     uint256 internal constant BATTLES_PER_CONTENDER_SUM = BATTLES_PER_CONTENDER * 100;//10x100
420     
421     uint256 internal constant LEVEL_BONUSES = 98898174676155504541373431282523211917151413121110;
422     
423     //ucommon bonuses
424     uint256 internal constant BONUS_NONE = 0;
425     uint256 internal constant BONUS_HP = 1;
426     uint256 internal constant BONUS_ARMOR = 2;
427     uint256 internal constant BONUS_CRIT_CHANCE = 3;
428     uint256 internal constant BONUS_CRIT_MULT = 4;
429     uint256 internal constant BONUS_PENETRATION = 5;
430     //rare bonuses
431     uint256 internal constant BONUS_STR = 6;
432     uint256 internal constant BONUS_AGI = 7;
433     uint256 internal constant BONUS_INT = 8;
434     uint256 internal constant BONUS_DAMAGE = 9;
435     
436     //bonus value database, 
437     uint256 internal constant BONUS_DATA = 16060606140107152000;
438     //pets database
439     uint256 internal constant PETS_DATA = 287164235573728325842459981692000;
440     
441     uint256 internal constant PET_AURA = 2;
442     uint256 internal constant PET_PARAM_1 = 1;
443     uint256 internal constant PET_PARAM_2 = 0;
444 
445     /* GETTERS */
446 	function getUniqueValue(uint256 identity) internal pure returns(uint256){
447 		return identity % RARITY_MASK_1;
448 	}
449 
450     function getRarityValue(uint256 identity) internal pure returns(uint256){
451         return (identity % CLASS_VIEW_MASK_2) / RARITY_MASK_1;
452     }
453 
454 	function getClassViewValue(uint256 identity) internal pure returns(uint256){
455 		return (identity % BODY_COLOR_MASK_3) / CLASS_VIEW_MASK_2;
456 	}
457 
458 	function getBodyColorValue(uint256 identity) internal pure returns(uint256){
459         return (identity % EYES_MASK_4) / BODY_COLOR_MASK_3;
460     }
461 
462     function getEyesValue(uint256 identity) internal pure returns(uint256){
463         return (identity % MOUTH_MASK_5) / EYES_MASK_4;
464     }
465 
466     function getMouthValue(uint256 identity) internal pure returns(uint256){
467         return (identity % HEIR_MASK_6) / MOUTH_MASK_5;
468     }
469 
470     function getHairValue(uint256 identity) internal pure returns(uint256){
471         return (identity % HEIR_COLOR_MASK_7) / HEIR_MASK_6;
472     }
473 
474     function getHairColorValue(uint256 identity) internal pure returns(uint256){
475         return (identity % ARMOR_MASK_8) / HEIR_COLOR_MASK_7;
476     }
477 
478     function getArmorValue(uint256 identity) internal pure returns(uint256){
479         return (identity % WEAPON_MASK_9) / ARMOR_MASK_8;
480     }
481 
482     function getWeaponValue(uint256 identity) internal pure returns(uint256){
483         return (identity % HAT_MASK_10) / WEAPON_MASK_9;
484     }
485 
486     function getHatValue(uint256 identity) internal pure returns(uint256){
487         return (identity % RUNES_MASK_11) / HAT_MASK_10;
488     }
489 
490     function getRunesValue(uint256 identity) internal pure returns(uint256){
491         return (identity % WINGS_MASK_12) / RUNES_MASK_11;
492     }
493 
494     function getWingsValue(uint256 identity) internal pure returns(uint256){
495         return (identity % PET_MASK_13) / WINGS_MASK_12;
496     }
497 
498     function getPetValue(uint256 identity) internal pure returns(uint256){
499         return (identity % BORDER_MASK_14) / PET_MASK_13;
500     }
501 
502 	function getBorderValue(uint256 identity) internal pure returns(uint256){
503 		return (identity % BACKGROUND_MASK_15) / BORDER_MASK_14;
504 	}
505 
506 	function getBackgroundValue(uint256 identity) internal pure returns(uint256){
507 		return (identity % INTELLIGENCE_MASK_16) / BACKGROUND_MASK_15;
508 	}
509 
510     function getIntelligenceValue(uint256 identity) internal pure returns(uint256){
511         return (identity % AGILITY_MASK_17) / INTELLIGENCE_MASK_16;
512     }
513 
514     function getAgilityValue(uint256 identity) internal pure returns(uint256){
515         return ((identity % STRENGTH_MASK_18) / AGILITY_MASK_17);
516     }
517 
518     function getStrengthValue(uint256 identity) internal pure returns(uint256){
519         return ((identity % CLASS_MECH_MASK_19) / STRENGTH_MASK_18);
520     }
521 
522     function getClassMechValue(uint256 identity) internal pure returns(uint256){
523         return (identity % RARITY_BONUS_MASK_20) / CLASS_MECH_MASK_19;
524     }
525 
526     function getRarityBonusValue(uint256 identity) internal pure returns(uint256){
527         return (identity % SPECIALITY_MASK_21) / RARITY_BONUS_MASK_20;
528     }
529 
530     function getSpecialityValue(uint256 identity) internal pure returns(uint256){
531         return (identity % DAMAGE_MASK_22) / SPECIALITY_MASK_21;
532     }
533     
534     function getDamageValue(uint256 identity) internal pure returns(uint256){
535         return (identity % AURA_MASK_23) / DAMAGE_MASK_22;
536     }
537 
538     function getAuraValue(uint256 identity) internal pure returns(uint256){
539         return ((identity % BASE_MASK_24) / AURA_MASK_23);
540     }
541 
542     /* SETTERS */
543     function _setUniqueValue0(uint256 value) internal pure returns(uint256){
544         require(value < RARITY_MASK_1);
545         return value * UNIQUE_MASK_0;
546     }
547 
548     function _setRarityValue1(uint256 value) internal pure returns(uint256){
549         require(value < (CLASS_VIEW_MASK_2 / RARITY_MASK_1));
550         return value * RARITY_MASK_1;
551     }
552 
553     function _setClassViewValue2(uint256 value) internal pure returns(uint256){
554         require(value < (BODY_COLOR_MASK_3 / CLASS_VIEW_MASK_2));
555         return value * CLASS_VIEW_MASK_2;
556     }
557 
558     function _setBodyColorValue3(uint256 value) internal pure returns(uint256){
559         require(value < (EYES_MASK_4 / BODY_COLOR_MASK_3));
560         return value * BODY_COLOR_MASK_3;
561     }
562 
563     function _setEyesValue4(uint256 value) internal pure returns(uint256){
564         require(value < (MOUTH_MASK_5 / EYES_MASK_4));
565         return value * EYES_MASK_4;
566     }
567 
568     function _setMouthValue5(uint256 value) internal pure returns(uint256){
569         require(value < (HEIR_MASK_6 / MOUTH_MASK_5));
570         return value * MOUTH_MASK_5;
571     }
572 
573     function _setHairValue6(uint256 value) internal pure returns(uint256){
574         require(value < (HEIR_COLOR_MASK_7 / HEIR_MASK_6));
575         return value * HEIR_MASK_6;
576     }
577 
578     function _setHairColorValue7(uint256 value) internal pure returns(uint256){
579         require(value < (ARMOR_MASK_8 / HEIR_COLOR_MASK_7));
580         return value * HEIR_COLOR_MASK_7;
581     }
582 
583     function _setArmorValue8(uint256 value) internal pure returns(uint256){
584         require(value < (WEAPON_MASK_9 / ARMOR_MASK_8));
585         return value * ARMOR_MASK_8;
586     }
587 
588     function _setWeaponValue9(uint256 value) internal pure returns(uint256){
589         require(value < (HAT_MASK_10 / WEAPON_MASK_9));
590         return value * WEAPON_MASK_9;
591     }
592 
593     function _setHatValue10(uint256 value) internal pure returns(uint256){
594         require(value < (RUNES_MASK_11 / HAT_MASK_10));
595         return value * HAT_MASK_10;
596     }
597 
598     function _setRunesValue11(uint256 value) internal pure returns(uint256){
599         require(value < (WINGS_MASK_12 / RUNES_MASK_11));
600         return value * RUNES_MASK_11;
601     }
602 
603     function _setWingsValue12(uint256 value) internal pure returns(uint256){
604         require(value < (PET_MASK_13 / WINGS_MASK_12));
605         return value * WINGS_MASK_12;
606     }
607 
608     function _setPetValue13(uint256 value) internal pure returns(uint256){
609         require(value < (BORDER_MASK_14 / PET_MASK_13));
610         return value * PET_MASK_13;
611     }
612 
613     function _setBorderValue14(uint256 value) internal pure returns(uint256){
614         require(value < (BACKGROUND_MASK_15 / BORDER_MASK_14));
615         return value * BORDER_MASK_14;
616     }
617 
618     function _setBackgroundValue15(uint256 value) internal pure returns(uint256){
619         require(value < (INTELLIGENCE_MASK_16 / BACKGROUND_MASK_15));
620         return value * BACKGROUND_MASK_15;
621     }
622 
623     function _setIntelligenceValue16(uint256 value) internal pure returns(uint256){
624         require(value < (AGILITY_MASK_17 / INTELLIGENCE_MASK_16));
625         return value * INTELLIGENCE_MASK_16;
626     }
627 
628     function _setAgilityValue17(uint256 value) internal pure returns(uint256){
629         require(value < (STRENGTH_MASK_18 / AGILITY_MASK_17));
630         return value * AGILITY_MASK_17;
631     }
632 
633     function _setStrengthValue18(uint256 value) internal pure returns(uint256){
634         require(value < (CLASS_MECH_MASK_19 / STRENGTH_MASK_18));
635         return value * STRENGTH_MASK_18;
636     }
637 
638     function _setClassMechValue19(uint256 value) internal pure returns(uint256){
639         require(value < (RARITY_BONUS_MASK_20 / CLASS_MECH_MASK_19));
640         return value * CLASS_MECH_MASK_19;
641     }
642 
643     function _setRarityBonusValue20(uint256 value) internal pure returns(uint256){
644         require(value < (SPECIALITY_MASK_21 / RARITY_BONUS_MASK_20));
645         return value * RARITY_BONUS_MASK_20;
646     }
647 
648     function _setSpecialityValue21(uint256 value) internal pure returns(uint256){
649         require(value < (DAMAGE_MASK_22 / SPECIALITY_MASK_21));
650         return value * SPECIALITY_MASK_21;
651     }
652     
653     function _setDamgeValue22(uint256 value) internal pure returns(uint256){
654         require(value < (AURA_MASK_23 / DAMAGE_MASK_22));
655         return value * DAMAGE_MASK_22;
656     }
657 
658     function _setAuraValue23(uint256 value) internal pure returns(uint256){
659         require(value < (BASE_MASK_24 / AURA_MASK_23));
660         return value * AURA_MASK_23;
661     }
662     
663     /* WARRIOR IDENTITY GENERATION */
664     function _computeRunes(uint256 _rarity) internal pure returns (uint256){
665         return _rarity > UNCOMMON ? _rarity - UNCOMMON : 0;// 1 + _random(0, max, hash, WINGS_MASK_12, RUNES_MASK_11) : 0;
666     }
667 
668     function _computeWings(uint256 _rarity, uint256 max, uint256 hash) internal pure returns (uint256){
669         return _rarity > RARE ?  1 + _random(0, max, hash, PET_MASK_13, WINGS_MASK_12) : 0;
670     }
671 
672     function _computePet(uint256 _rarity, uint256 max, uint256 hash) internal pure returns (uint256){
673         return _rarity > MYTHIC ? 1 + _random(0, max, hash, BORDER_MASK_14, PET_MASK_13) : 0;
674     }
675 
676     function _computeBorder(uint256 _rarity) internal pure returns (uint256){
677         return _rarity >= COMMON ? _rarity - 1 : 0;
678     }
679 
680     function _computeBackground(uint256 _rarity) internal pure returns (uint256){
681         return _rarity;
682     }
683     
684     function _unpackPetData(uint256 index) internal pure returns(uint256){
685         return (PETS_DATA % (1000 ** (index + 1)) / (1000 ** index));
686     }
687     
688     function _getPetBonus1(uint256 _pet) internal pure returns(uint256) {
689         return (_pet % (10 ** (PET_PARAM_1 + 1)) / (10 ** PET_PARAM_1));
690     }
691     
692     function _getPetBonus2(uint256 _pet) internal pure returns(uint256) {
693         return (_pet % (10 ** (PET_PARAM_2 + 1)) / (10 ** PET_PARAM_2));
694     }
695     
696     function _getPetAura(uint256 _pet) internal pure returns(uint256) {
697         return (_pet % (10 ** (PET_AURA + 1)) / (10 ** PET_AURA));
698     }
699     
700     function _getBattleBonus(uint256 _setBonusIndex, uint256 _currentBonusIndex, uint256 _petData, uint256 _warriorAuras, uint256 _petAuras) internal pure returns(int256) {
701         int256 bonus = 0;
702         if (_setBonusIndex == _currentBonusIndex) {
703             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION;
704         }
705         //add pet bonuses
706         if (_setBonusIndex == _getPetBonus1(_petData)) {
707             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
708         }
709         if (_setBonusIndex == _getPetBonus2(_petData)) {
710             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
711         }
712         //add warrior aura bonuses
713         if (isAuraSet(_warriorAuras, uint8(_setBonusIndex))) {//warriors receive half bonuses from auras
714             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
715         }
716         //add pet aura bonuses
717         if (isAuraSet(_petAuras, uint8(_setBonusIndex))) {//pets receive full bonues from auras
718             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION;
719         }
720         return bonus;
721     }
722     
723     function _computeRarityBonus(uint256 _rarity, uint256 hash) internal pure returns (uint256){
724         if (_rarity == UNCOMMON) {
725             return 1 + _random(0, BONUS_PENETRATION, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
726         }
727         if (_rarity == RARE) {
728             return 1 + _random(BONUS_PENETRATION, BONUS_DAMAGE, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
729         }
730         if (_rarity >= MYTHIC) {
731             return 1 + _random(0, BONUS_DAMAGE, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
732         }
733         return BONUS_NONE;
734     }
735 
736     function _computeAura(uint256 _rarity, uint256 hash) internal pure returns (uint256){
737         if (_rarity >= MYTHIC) {
738             return 1 + _random(0, BONUS_DAMAGE, hash, BASE_MASK_24, AURA_MASK_23);
739         }
740         return BONUS_NONE;
741     }
742     
743 	function _computeRarity(uint256 _reward, uint256 _unique, uint256 _legendary, 
744 	    uint256 _mythic, uint256 _rare, uint256 _uncommon) internal pure returns(uint256){
745 	        
746         uint256 range = _unique + _legendary + _mythic + _rare + _uncommon;
747         if (_reward >= range) return COMMON; // common
748         if (_reward >= (range = (range - _uncommon))) return UNCOMMON;
749         if (_reward >= (range = (range - _rare))) return RARE;
750         if (_reward >= (range = (range - _mythic))) return MYTHIC;
751         if (_reward >= (range = (range - _legendary))) return LEGENDARY;
752         if (_reward < range) return UNIQUE;
753         return COMMON;
754     }
755     
756     function _computeUniqueness(uint256 _rarity, uint256 nextUnique) internal pure returns (uint256){
757         return _rarity == UNIQUE ? nextUnique : 0;
758     }
759     
760     /* identity packing */
761     /* @returns bonus value which depends on speciality value,
762      * if speciality == 1 (miner), then bonus value will be equal 4,
763      * otherwise 1
764      */
765     function _getBonus(uint256 identity) internal pure returns(uint256){
766         return getSpecialityValue(identity) == MINER_PERK ? 4 : 1;
767     }
768     
769 
770     function _computeAndSetBaseParameters16_18_22(uint256 _hash) internal pure returns (uint256, uint256){
771         uint256 identity = 0;
772 
773         uint256 damage = 35 + _random(0, 21, _hash, AURA_MASK_23, DAMAGE_MASK_22);
774         
775         uint256 strength = 45 + _random(0, 26, _hash, CLASS_MECH_MASK_19, STRENGTH_MASK_18);
776         uint256 agility = 15 + (125 - damage - strength);
777         uint256 intelligence = 155 - strength - agility - damage;
778         (strength, agility, intelligence) = _shuffleParams(strength, agility, intelligence, _hash);
779         
780         identity += _setStrengthValue18(strength);
781         identity += _setAgilityValue17(agility);
782 		identity += _setIntelligenceValue16(intelligence);
783 		identity += _setDamgeValue22(damage);
784         
785         uint256 classMech = strength > agility ? (strength > intelligence ? WARRIOR : MAGE) : (agility > intelligence ? ARCHER : MAGE);
786         return (identity, classMech);
787     }
788     
789     function _shuffleParams(uint256 param1, uint256 param2, uint256 param3, uint256 _hash) internal pure returns(uint256, uint256, uint256) {
790         uint256 temp = param1;
791         if (_hash % 2 == 0) {
792             temp = param1;
793             param1 = param2;
794             param2 = temp;
795         }
796         if ((_hash / 10 % 2) == 0) {
797             temp = param2;
798             param2 = param3;
799             param3 = temp;
800         }
801         if ((_hash / 100 % 2) == 0) {
802             temp = param1;
803             param1 = param2;
804             param2 = temp;
805         }
806         return (param1, param2, param3);
807     }
808     
809     
810     /* RANDOM */
811     function _random(uint256 _min, uint256 _max, uint256 _hash, uint256 _reminder, uint256 _devider) internal pure returns (uint256){
812         return ((_hash % _reminder) / _devider) % (_max - _min) + _min;
813     }
814 
815     function _random(uint256 _min, uint256 _max, uint256 _hash) internal pure returns (uint256){
816         return _hash % (_max - _min) + _min;
817     }
818 
819     function _getTargetBlock(uint256 _targetBlock) internal view returns(uint256){
820         uint256 currentBlock = block.number;
821         uint256 target = currentBlock - (currentBlock % 256) + (_targetBlock % 256);
822         if (target >= currentBlock) {
823             return (target - 256);
824         }
825         return target;
826     }
827     
828     function _getMaxRarityChance() internal pure returns(uint256){
829         return RARITY_CHANCE_RANGE;
830     }
831     
832     function generateWarrior(uint256 _heroIdentity, uint256 _heroLevel, uint256 _targetBlock, uint256 specialPerc, uint32[19] memory params) internal view returns (uint256) {
833         _targetBlock = _getTargetBlock(_targetBlock);
834         
835         uint256 identity;
836         uint256 hash = uint256(keccak256(block.blockhash(_targetBlock), _heroIdentity, block.coinbase, block.difficulty));
837         //0 _heroLevel produces warriors of COMMON rarity
838         uint256 rarityChance = _heroLevel == 0 ? RARITY_CHANCE_RANGE : 
839         	_random(0, RARITY_CHANCE_RANGE, hash) / (_heroLevel * _getBonus(_heroIdentity)); // 0 - 10 000 000
840         uint256 rarity = _computeRarity(rarityChance, 
841             params[UNIQUE_INDEX_13],params[LEGENDARY_INDEX_14], params[MYTHIC_INDEX_15], params[RARE_INDEX_16], params[UNCOMMON_INDEX_17]);
842             
843         uint256 classMech;
844         
845         // start
846         (identity, classMech) = _computeAndSetBaseParameters16_18_22(hash);
847         
848         identity += _setUniqueValue0(_computeUniqueness(rarity, params[UNIQUE_TOTAL_INDEX_18] + 1));
849         identity += _setRarityValue1(rarity);
850         identity += _setClassViewValue2(classMech); // 1 to 1 with classMech
851         
852         identity += _setBodyColorValue3(1 + _random(0, params[BODY_COLOR_MAX_INDEX_0], hash, EYES_MASK_4, BODY_COLOR_MASK_3));
853         identity += _setEyesValue4(1 + _random(0, params[EYES_MAX_INDEX_1], hash, MOUTH_MASK_5, EYES_MASK_4));
854         identity += _setMouthValue5(1 + _random(0, params[MOUTH_MAX_2], hash, HEIR_MASK_6, MOUTH_MASK_5));
855         identity += _setHairValue6(1 + _random(0, params[HAIR_MAX_3], hash, HEIR_COLOR_MASK_7, HEIR_MASK_6));
856         identity += _setHairColorValue7(1 + _random(0, params[HEIR_COLOR_MAX_4], hash, ARMOR_MASK_8, HEIR_COLOR_MASK_7));
857         identity += _setArmorValue8(1 + _random(0, params[ARMOR_MAX_5], hash, WEAPON_MASK_9, ARMOR_MASK_8));
858         identity += _setWeaponValue9(1 + _random(0, params[WEAPON_MAX_6], hash, HAT_MASK_10, WEAPON_MASK_9));
859         identity += _setHatValue10(_random(0, params[HAT_MAX_7], hash, RUNES_MASK_11, HAT_MASK_10));//removed +1
860         
861         identity += _setRunesValue11(_computeRunes(rarity));
862         identity += _setWingsValue12(_computeWings(rarity, params[WINGS_MAX_9], hash));
863         identity += _setPetValue13(_computePet(rarity, params[PET_MAX_10], hash));
864         identity += _setBorderValue14(_computeBorder(rarity)); // 1 to 1 with rarity
865         identity += _setBackgroundValue15(_computeBackground(rarity)); // 1 to 1 with rarity
866         
867         identity += _setClassMechValue19(classMech);
868 
869         identity += _setRarityBonusValue20(_computeRarityBonus(rarity, hash));
870         identity += _setSpecialityValue21(specialPerc); // currently only miner (1)
871         
872         identity += _setAuraValue23(_computeAura(rarity, hash));
873         // end
874         return identity;
875     }
876     
877 	function _changeParameter(uint256 _paramIndex, uint32 _value, uint32[19] storage parameters) internal {
878 		//we can change only view parameters, and unique count in max range <= 100
879 		require(_paramIndex >= BODY_COLOR_MAX_INDEX_0 && _paramIndex <= UNIQUE_INDEX_13);
880 		//we can NOT set pet, border and background values,
881 		//those values have special logic behind them
882 		require(
883 		    _paramIndex != RUNES_MAX_8 && 
884 		    _paramIndex != PET_MAX_10 && 
885 		    _paramIndex != BORDER_MAX_11 && 
886 		    _paramIndex != BACKGROUND_MAX_12
887 		);
888 		//value of bodyColor, eyes, mouth, hair, hairColor, armor, weapon, hat must be < 1000
889 		require(_paramIndex > HAT_MAX_7 || _value < 1000);
890 		//value of wings,  must be < 100
891 		require(_paramIndex > BACKGROUND_MAX_12 || _value < 100);
892 		//check that max total number of UNIQUE warriors that we can emit is not > 100
893 		require(_paramIndex != UNIQUE_INDEX_13 || (_value + parameters[UNIQUE_TOTAL_INDEX_18]) <= 100);
894 		
895 		parameters[_paramIndex] = _value;
896     }
897     
898 	function _recordWarriorData(uint256 identity, uint32[19] storage parameters) internal {
899         uint256 rarity = getRarityValue(identity);
900         if (rarity == UNCOMMON) { // uncommon
901             parameters[UNCOMMON_INDEX_17]--;
902             return;
903         }
904         if (rarity == RARE) { // rare
905             parameters[RARE_INDEX_16]--;
906             return;
907         }
908         if (rarity == MYTHIC) { // mythic
909             parameters[MYTHIC_INDEX_15]--;
910             return;
911         }
912         if (rarity == LEGENDARY) { // legendary
913             parameters[LEGENDARY_INDEX_14]--;
914             return;
915         }
916         if (rarity == UNIQUE) { // unique
917             parameters[UNIQUE_INDEX_13]--;
918             parameters[UNIQUE_TOTAL_INDEX_18] ++;
919             return;
920         }
921     }
922     
923     function _validateIdentity(uint256 _identity, uint32[19] memory params) internal pure returns(bool){
924         uint256 rarity = getRarityValue(_identity);
925         require(rarity <= UNIQUE);
926         
927         require(
928             rarity <= COMMON ||//common 
929             (rarity == UNCOMMON && params[UNCOMMON_INDEX_17] > 0) ||//uncommon
930             (rarity == RARE && params[RARE_INDEX_16] > 0) ||//rare
931             (rarity == MYTHIC && params[MYTHIC_INDEX_15] > 0) ||//mythic
932             (rarity == LEGENDARY && params[LEGENDARY_INDEX_14] > 0) ||//legendary
933             (rarity == UNIQUE && params[UNIQUE_INDEX_13] > 0)//unique
934         );
935         require(rarity != UNIQUE || getUniqueValue(_identity) > params[UNIQUE_TOTAL_INDEX_18]);
936         
937         //check battle parameters
938         require(
939             getStrengthValue(_identity) < 100 &&
940             getAgilityValue(_identity) < 100 &&
941             getIntelligenceValue(_identity) < 100 &&
942             getDamageValue(_identity) <= 55
943         );
944         require(getClassMechValue(_identity) <= MAGE);
945         require(getClassMechValue(_identity) == getClassViewValue(_identity));
946         require(getSpecialityValue(_identity) <= MINER_PERK);
947         require(getRarityBonusValue(_identity) <= BONUS_DAMAGE);
948         require(getAuraValue(_identity) <= BONUS_DAMAGE);
949         
950         //check view
951         require(getBodyColorValue(_identity) <= params[BODY_COLOR_MAX_INDEX_0]);
952         require(getEyesValue(_identity) <= params[EYES_MAX_INDEX_1]);
953         require(getMouthValue(_identity) <= params[MOUTH_MAX_2]);
954         require(getHairValue(_identity) <= params[HAIR_MAX_3]);
955         require(getHairColorValue(_identity) <= params[HEIR_COLOR_MAX_4]);
956         require(getArmorValue(_identity) <= params[ARMOR_MAX_5]);
957         require(getWeaponValue(_identity) <= params[WEAPON_MAX_6]);
958         require(getHatValue(_identity) <= params[HAT_MAX_7]);
959         require(getRunesValue(_identity) <= params[RUNES_MAX_8]);
960         require(getWingsValue(_identity) <= params[WINGS_MAX_9]);
961         require(getPetValue(_identity) <= params[PET_MAX_10]);
962         require(getBorderValue(_identity) <= params[BORDER_MAX_11]);
963         require(getBackgroundValue(_identity) <= params[BACKGROUND_MAX_12]);
964         
965         return true;
966     }
967     
968     /* UNPACK METHODS */
969     //common
970     function _unpackClassValue(uint256 packedValue) internal pure returns(uint256){
971         return (packedValue % RARITY_PACK_2 / CLASS_PACK_0);
972     }
973     
974     function _unpackRarityBonusValue(uint256 packedValue) internal pure returns(uint256){
975         return (packedValue % RARITY_PACK_2 / RARITY_BONUS_PACK_1);
976     }
977     
978     function _unpackRarityValue(uint256 packedValue) internal pure returns(uint256){
979         return (packedValue % EXPERIENCE_PACK_3 / RARITY_PACK_2);
980     }
981     
982     function _unpackExpValue(uint256 packedValue) internal pure returns(uint256){
983         return (packedValue % INTELLIGENCE_PACK_4 / EXPERIENCE_PACK_3);
984     }
985 
986     function _unpackLevelValue(uint256 packedValue) internal pure returns(uint256){
987         return (packedValue % INTELLIGENCE_PACK_4) / (EXPERIENCE_PACK_3 * POINTS_TO_LEVEL);
988     }
989     
990     function _unpackIntelligenceValue(uint256 packedValue) internal pure returns(int256){
991         return int256(packedValue % AGILITY_PACK_5 / INTELLIGENCE_PACK_4);
992     }
993     
994     function _unpackAgilityValue(uint256 packedValue) internal pure returns(int256){
995         return int256(packedValue % STRENGTH_PACK_6 / AGILITY_PACK_5);
996     }
997     
998     function _unpackStrengthValue(uint256 packedValue) internal pure returns(int256){
999         return int256(packedValue % BASE_DAMAGE_PACK_7 / STRENGTH_PACK_6);
1000     }
1001 
1002     function _unpackBaseDamageValue(uint256 packedValue) internal pure returns(int256){
1003         return int256(packedValue % PET_PACK_8 / BASE_DAMAGE_PACK_7);
1004     }
1005     
1006     function _unpackPetValue(uint256 packedValue) internal pure returns(uint256){
1007         return (packedValue % AURA_PACK_9 / PET_PACK_8);
1008     }
1009     
1010     function _unpackAuraValue(uint256 packedValue) internal pure returns(uint256){
1011         return (packedValue % WARRIOR_ID_PACK_10 / AURA_PACK_9);
1012     }
1013     //
1014     //pvp unpack
1015     function _unpackIdValue(uint256 packedValue) internal pure returns(uint256){
1016         return (packedValue % PVP_CYCLE_PACK_11 / WARRIOR_ID_PACK_10);
1017     }
1018     
1019     function _unpackCycleValue(uint256 packedValue) internal pure returns(uint256){
1020         return (packedValue % RATING_PACK_12 / PVP_CYCLE_PACK_11);
1021     }
1022     
1023     function _unpackRatingValue(uint256 packedValue) internal pure returns(uint256){
1024         return (packedValue % PVP_BASE_PACK_13 / RATING_PACK_12);
1025     }
1026     
1027     //max cycle skip value cant be more than 1000000000
1028     function _changeCycleValue(uint256 packedValue, uint256 newValue) internal pure returns(uint256){
1029         newValue = newValue > 1000000000 ? 1000000000 : newValue;
1030         return packedValue - (_unpackCycleValue(packedValue) * PVP_CYCLE_PACK_11) + newValue * PVP_CYCLE_PACK_11;
1031     }
1032     
1033     function _packWarriorCommonData(uint256 _identity, uint256 _experience) internal pure returns(uint256){
1034         uint256 packedData = 0;
1035         packedData += getClassMechValue(_identity) * CLASS_PACK_0;
1036         packedData += getRarityBonusValue(_identity) * RARITY_BONUS_PACK_1;
1037         packedData += getRarityValue(_identity) * RARITY_PACK_2;
1038         packedData += _experience * EXPERIENCE_PACK_3;
1039         packedData += getIntelligenceValue(_identity) * INTELLIGENCE_PACK_4;
1040         packedData += getAgilityValue(_identity) * AGILITY_PACK_5;
1041         packedData += getStrengthValue(_identity) * STRENGTH_PACK_6;
1042         packedData += getDamageValue(_identity) * BASE_DAMAGE_PACK_7;
1043         packedData += getPetValue(_identity) * PET_PACK_8;
1044         
1045         return packedData;
1046     }
1047     
1048     function _packWarriorPvpData(uint256 _identity, uint256 _rating, uint256 _pvpCycle, uint256 _warriorId, uint256 _experience) internal pure returns(uint256){
1049         uint256 packedData = _packWarriorCommonData(_identity, _experience);
1050         packedData += _warriorId * WARRIOR_ID_PACK_10;
1051         packedData += _pvpCycle * PVP_CYCLE_PACK_11;
1052         //rating MUST have most significant value!
1053         packedData += _rating * RATING_PACK_12;
1054         return packedData;
1055     }
1056     
1057     /* TOURNAMENT BATTLES */
1058     
1059     
1060     function _packWarriorIds(uint256[] memory packedWarriors) internal pure returns(uint256){
1061         uint256 packedIds = 0;
1062         uint256 length = packedWarriors.length;
1063         for(uint256 i = 0; i < length; i ++) {
1064             packedIds += (MAX_ID_SIZE ** i) * _unpackIdValue(packedWarriors[i]);
1065         }
1066         return packedIds;
1067     }
1068 
1069     function _unpackWarriorId(uint256 packedIds, uint256 index) internal pure returns(uint256){
1070         return (packedIds % (MAX_ID_SIZE ** (index + 1)) / (MAX_ID_SIZE ** index));
1071     }
1072     
1073     function _packCombinedParams(int256 hp, int256 damage, int256 armor, int256 dodge, int256 penetration) internal pure returns(uint256) {
1074         uint256 combinedWarrior = 0;
1075         combinedWarrior += uint256(hp) * HP_PACK_0;
1076         combinedWarrior += uint256(damage) * DAMAGE_PACK_1;
1077         combinedWarrior += uint256(armor) * ARMOR_PACK_2;
1078         combinedWarrior += uint256(dodge) * DODGE_PACK_3;
1079         combinedWarrior += uint256(penetration) * PENETRATION_PACK_4;
1080         return combinedWarrior;
1081     }
1082     
1083     function _unpackProtectionParams(uint256 combinedWarrior) internal pure returns 
1084     (int256 hp, int256 armor, int256 dodge){
1085         hp = int256(combinedWarrior % DAMAGE_PACK_1 / HP_PACK_0);
1086         armor = int256(combinedWarrior % DODGE_PACK_3 / ARMOR_PACK_2);
1087         dodge = int256(combinedWarrior % PENETRATION_PACK_4 / DODGE_PACK_3);
1088     }
1089     
1090     function _unpackAttackParams(uint256 combinedWarrior) internal pure returns(int256 damage, int256 penetration) {
1091         damage = int256(combinedWarrior % ARMOR_PACK_2 / DAMAGE_PACK_1);
1092         penetration = int256(combinedWarrior % COMBINE_BASE_PACK_5 / PENETRATION_PACK_4);
1093     }
1094     
1095     function _combineWarriors(uint256[] memory packedWarriors) internal pure returns (uint256) {
1096         int256 hp;
1097         int256 damage;
1098 		int256 armor;
1099 		int256 dodge;
1100 		int256 penetration;
1101 		
1102 		(hp, damage, armor, dodge, penetration) = _computeCombinedParams(packedWarriors);
1103         return _packCombinedParams(hp, damage, armor, dodge, penetration);
1104     }
1105     
1106     function _computeCombinedParams(uint256[] memory packedWarriors) internal pure returns 
1107     (int256 totalHp, int256 totalDamage, int256 maxArmor, int256 maxDodge, int256 maxPenetration){
1108         uint256 length = packedWarriors.length;
1109         
1110         int256 hp;
1111 		int256 armor;
1112 		int256 dodge;
1113 		int256 penetration;
1114 		
1115 		uint256 warriorAuras;
1116 		uint256 petAuras;
1117 		(warriorAuras, petAuras) = _getAurasData(packedWarriors);
1118 		
1119 		uint256 packedWarrior;
1120         for(uint256 i = 0; i < length; i ++) {
1121             packedWarrior = packedWarriors[i];
1122             
1123             totalDamage += getDamage(packedWarrior, warriorAuras, petAuras);
1124             
1125             penetration = getPenetration(packedWarrior, warriorAuras, petAuras);
1126             maxPenetration = maxPenetration > penetration ? maxPenetration : penetration;
1127 			(hp, armor, dodge) = _getProtectionParams(packedWarrior, warriorAuras, petAuras);
1128             totalHp += hp;
1129             maxArmor = maxArmor > armor ? maxArmor : armor;
1130             maxDodge = maxDodge > dodge ? maxDodge : dodge;
1131         }
1132     }
1133     
1134     function _getAurasData(uint256[] memory packedWarriors) internal pure returns(uint256 warriorAuras, uint256 petAuras) {
1135         uint256 length = packedWarriors.length;
1136         
1137         warriorAuras = 0;
1138         petAuras = 0;
1139         
1140         uint256 packedWarrior;
1141         for(uint256 i = 0; i < length; i ++) {
1142             packedWarrior = packedWarriors[i];
1143             warriorAuras = enableAura(warriorAuras, (_unpackAuraValue(packedWarrior)));
1144             petAuras = enableAura(petAuras, (_getPetAura(_unpackPetData(_unpackPetValue(packedWarrior)))));
1145         }
1146         warriorAuras = filterWarriorAuras(warriorAuras, petAuras);
1147         return (warriorAuras, petAuras);
1148     }
1149     
1150     // Get bit value at position
1151     function isAuraSet(uint256 aura, uint256 auraIndex) internal pure returns (bool) {
1152         return aura & (uint256(0x01) << auraIndex) != 0;
1153     }
1154     
1155     // Set bit value at position
1156     function enableAura(uint256 a, uint256 n) internal pure returns (uint256) {
1157         return a | (uint256(0x01) << n);
1158     }
1159     
1160     //switch off warrior auras that are enabled in pets auras, pet aura have priority
1161     function filterWarriorAuras(uint256 _warriorAuras, uint256 _petAuras) internal pure returns(uint256) {
1162         return (_warriorAuras & _petAuras) ^ _warriorAuras;
1163     }
1164   
1165     function _getTournamentBattles(uint256 _numberOfContenders) internal pure returns(uint256) {
1166         return (_numberOfContenders * BATTLES_PER_CONTENDER / 2);
1167     }
1168     
1169     function getTournamentBattleResults(uint256[] memory combinedWarriors, uint256 _targetBlock) internal view returns (uint32[] memory results){
1170         uint256 length = combinedWarriors.length;
1171         results = new uint32[](length);
1172 		
1173 		int256 damage1;
1174 		int256 penetration1;
1175 		
1176 		uint256 hash;
1177 		
1178 		uint256 randomIndex;
1179 		uint256 exp = 0;
1180 		uint256 i;
1181 		uint256 result;
1182         for(i = 0; i < length; i ++) {
1183             (damage1, penetration1) = _unpackAttackParams(combinedWarriors[i]);
1184             while(results[i] < BATTLES_PER_CONTENDER_SUM) {
1185                 //if we just started generate new random source
1186                 //or regenerate if we used all data from it
1187                 if (exp == 0 || exp > 73) {
1188                     hash = uint256(keccak256(block.blockhash(_getTargetBlock(_targetBlock - i)), uint256(damage1) + now));
1189                     exp = 0;
1190                 }
1191                 //we do not fight with self if there are other warriors
1192                 randomIndex = (_random(i + 1 < length ? i + 1 : i, length, hash, 1000 * 10**exp, 10**exp));
1193                 result = getTournamentBattleResult(damage1, penetration1, combinedWarriors[i],
1194                     combinedWarriors[randomIndex], hash % (1000 * 10**exp) / 10**exp);
1195                 results[result == 1 ? i : randomIndex] += 101;//icrement battle count 100 and +1 win
1196                 results[result == 1 ? randomIndex : i] += 100;//increment only battle count 100 for loser
1197                 if (results[randomIndex] >= BATTLES_PER_CONTENDER_SUM) {
1198                     if (randomIndex < length - 1) {
1199                         _swapValues(combinedWarriors, results, randomIndex, length - 1);
1200                     }
1201                     length --;
1202                 }
1203                 exp++;
1204             }
1205         }
1206         //filter battle count from results
1207         length = combinedWarriors.length;
1208         for(i = 0; i < length; i ++) {
1209             results[i] = results[i] % 100;
1210         }
1211         
1212         return results;
1213     }
1214     
1215     function _swapValues(uint256[] memory combinedWarriors, uint32[] memory results, uint256 id1, uint256 id2) internal pure {
1216         uint256 temp = combinedWarriors[id1];
1217         combinedWarriors[id1] = combinedWarriors[id2];
1218         combinedWarriors[id2] = temp;
1219         temp = results[id1];
1220         results[id1] = results[id2];
1221         results[id2] = uint32(temp);
1222     }
1223 
1224     function getTournamentBattleResult(int256 damage1, int256 penetration1, uint256 combinedWarrior1, 
1225         uint256 combinedWarrior2, uint256 randomSource) internal pure returns (uint256)
1226     {
1227         int256 damage2;
1228 		int256 penetration2;
1229         
1230 		(damage2, penetration2) = _unpackAttackParams(combinedWarrior1);
1231 
1232 		int256 totalHp1 = getCombinedTotalHP(combinedWarrior1, penetration2);
1233 		int256 totalHp2 = getCombinedTotalHP(combinedWarrior2, penetration1);
1234         
1235         return _getBattleResult(damage1 * getBattleRandom(randomSource, 1) / 100, damage2 * getBattleRandom(randomSource, 10) / 100, totalHp1, totalHp2, randomSource);
1236     }
1237     /* COMMON BATTLE */
1238     
1239     function _getBattleResult(int256 damage1, int256 damage2, int256 totalHp1, int256 totalHp2, uint256 randomSource)  internal pure returns (uint256){
1240 		totalHp1 = (totalHp1 * (PRECISION * PRECISION) / damage2);
1241 		totalHp2 = (totalHp2 * (PRECISION * PRECISION) / damage1);
1242 		//if draw, let the coin decide who wins
1243 		if (totalHp1 == totalHp2) return randomSource % 2 + 1;
1244 		return totalHp1 > totalHp2 ? 1 : 2;       
1245     }
1246     
1247     function getCombinedTotalHP(uint256 combinedData, int256 enemyPenetration) internal pure returns(int256) {
1248         int256 hp;
1249 		int256 armor;
1250 		int256 dodge;
1251 		(hp, armor, dodge) = _unpackProtectionParams(combinedData);
1252         
1253         return _getTotalHp(hp, armor, dodge, enemyPenetration);
1254     }
1255     
1256     function getTotalHP(uint256 packedData, uint256 warriorAuras, uint256 petAuras, int256 enemyPenetration) internal pure returns(int256) {
1257         int256 hp;
1258 		int256 armor;
1259 		int256 dodge;
1260 		(hp, armor, dodge) = _getProtectionParams(packedData, warriorAuras, petAuras);
1261         
1262         return _getTotalHp(hp, armor, dodge, enemyPenetration);
1263     }
1264     
1265     function _getTotalHp(int256 hp, int256 armor, int256 dodge, int256 enemyPenetration) internal pure returns(int256) {
1266         int256 piercingResult = (armor - enemyPenetration) < -(75 * PRECISION) ? -(75 * PRECISION) : (armor - enemyPenetration);
1267         int256 mitigation = (PRECISION - piercingResult * PRECISION / (PRECISION + piercingResult / 100) / 100);
1268         
1269         return (hp * PRECISION / mitigation + (hp * dodge / (100 * PRECISION)));
1270     }
1271     
1272     function _applyLevelBonus(int256 _value, uint256 _level) internal pure returns(int256) {
1273         _level -= 1;
1274         return int256(uint256(_value) * (LEVEL_BONUSES % (100 ** (_level + 1)) / (100 ** _level)) / 10);
1275     }
1276     
1277     function _getProtectionParams(uint256 packedData, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256 hp, int256 armor, int256 dodge) {
1278         uint256 rarityBonus = _unpackRarityBonusValue(packedData);
1279         uint256 petData = _unpackPetData(_unpackPetValue(packedData));
1280         int256 strength = _unpackStrengthValue(packedData) * PRECISION + _getBattleBonus(BONUS_STR, rarityBonus, petData, warriorAuras, petAuras);
1281         int256 agility = _unpackAgilityValue(packedData) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
1282         
1283         hp = 100 * PRECISION + strength + 7 * strength / 10 + _getBattleBonus(BONUS_HP, rarityBonus, petData, warriorAuras, petAuras);//add bonus hp
1284         hp = _applyLevelBonus(hp, _unpackLevelValue(packedData));
1285 		armor = (strength + 8 * strength / 10 + agility + _getBattleBonus(BONUS_ARMOR, rarityBonus, petData, warriorAuras, petAuras));//add bonus armor
1286 		dodge = (2 * agility / 3);
1287     }
1288     
1289     function getDamage(uint256 packedWarrior, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256) {
1290         uint256 rarityBonus = _unpackRarityBonusValue(packedWarrior);
1291         uint256 petData = _unpackPetData(_unpackPetValue(packedWarrior));
1292         int256 agility = _unpackAgilityValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
1293         int256 intelligence = _unpackIntelligenceValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_INT, rarityBonus, petData, warriorAuras, petAuras);
1294 		
1295 		int256 crit = (agility / 5 + intelligence / 4) + _getBattleBonus(BONUS_CRIT_CHANCE, rarityBonus, petData, warriorAuras, petAuras);
1296 		int256 critMultiplier = (PRECISION + intelligence / 25) + _getBattleBonus(BONUS_CRIT_MULT, rarityBonus, petData, warriorAuras, petAuras);
1297         
1298         int256 damage = int256(_unpackBaseDamageValue(packedWarrior) * 3 * PRECISION / 2) + _getBattleBonus(BONUS_DAMAGE, rarityBonus, petData, warriorAuras, petAuras);
1299         
1300 		return (_applyLevelBonus(damage, _unpackLevelValue(packedWarrior)) * (PRECISION + crit * critMultiplier / (100 * PRECISION))) / PRECISION;
1301     }
1302 
1303     function getPenetration(uint256 packedWarrior, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256) {
1304         uint256 rarityBonus = _unpackRarityBonusValue(packedWarrior);
1305         uint256 petData = _unpackPetData(_unpackPetValue(packedWarrior));
1306         int256 agility = _unpackAgilityValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
1307         int256 intelligence = _unpackIntelligenceValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_INT, rarityBonus, petData, warriorAuras, petAuras);
1308 		
1309 		return (intelligence * 2 + agility + _getBattleBonus(BONUS_PENETRATION, rarityBonus, petData, warriorAuras, petAuras));
1310     }
1311     
1312     /* BATTLE PVP */
1313     
1314     //@param randomSource must be >= 1000
1315     function getBattleRandom(uint256 randmSource, uint256 _step) internal pure returns(int256){
1316         return int256(100 + _random(0, 11, randmSource, 100 * _step, _step));
1317     }
1318     
1319     uint256 internal constant NO_AURA = 0;
1320     
1321     function getPVPBattleResult(uint256 packedData1, uint256 packedData2, uint256 randmSource) internal pure returns (uint256){
1322         uint256 petAura1 = _computePVPPetAura(packedData1);
1323         uint256 petAura2 = _computePVPPetAura(packedData2);
1324         
1325         uint256 warriorAura1 = _computePVPWarriorAura(packedData1, petAura1);
1326         uint256 warriorAura2 = _computePVPWarriorAura(packedData2, petAura2);
1327         
1328 		int256 damage1 = getDamage(packedData1, warriorAura1, petAura1) * getBattleRandom(randmSource, 1) / 100;
1329         int256 damage2 = getDamage(packedData2, warriorAura2, petAura2) * getBattleRandom(randmSource, 10) / 100;
1330 
1331 		int256 totalHp1;
1332 		int256 totalHp2;
1333 		(totalHp1, totalHp2) = _computeContendersTotalHp(packedData1, warriorAura1, petAura1, packedData2, warriorAura1, petAura1);
1334         
1335         return _getBattleResult(damage1, damage2, totalHp1, totalHp2, randmSource);
1336     }
1337     
1338     function _computePVPPetAura(uint256 packedData) internal pure returns(uint256) {
1339         return enableAura(NO_AURA, _getPetAura(_unpackPetData(_unpackPetValue(packedData))));
1340     }
1341     
1342     function _computePVPWarriorAura(uint256 packedData, uint256 petAuras) internal pure returns(uint256) {
1343         return filterWarriorAuras(enableAura(NO_AURA, _unpackAuraValue(packedData)), petAuras);
1344     }
1345     
1346     function _computeContendersTotalHp(uint256 packedData1, uint256 warriorAura1, uint256 petAura1, uint256 packedData2, uint256 warriorAura2, uint256 petAura2) 
1347     internal pure returns(int256 totalHp1, int256 totalHp2) {
1348 		int256 enemyPenetration = getPenetration(packedData2, warriorAura2, petAura2);
1349 		totalHp1 = getTotalHP(packedData1, warriorAura1, petAura1, enemyPenetration);
1350 		enemyPenetration = getPenetration(packedData1, warriorAura1, petAura1);
1351 		totalHp2 = getTotalHP(packedData2, warriorAura1, petAura1, enemyPenetration);
1352     }
1353     
1354     function getRatingRange(uint256 _pvpCycle, uint256 _pvpInterval, uint256 _expandInterval) internal pure returns (uint256){
1355         return 50 + (_pvpCycle * _pvpInterval / _expandInterval * 25);
1356     }
1357     
1358     function isMatching(int256 evenRating, int256 oddRating, int256 ratingGap) internal pure returns(bool) {
1359         return evenRating <= (oddRating + ratingGap) && evenRating >= (oddRating - ratingGap);
1360     }
1361     
1362     function sort(uint256[] memory data) internal pure {
1363        quickSort(data, int(0), int(data.length - 1));
1364     }
1365     
1366     function quickSort(uint256[] memory arr, int256 left, int256 right) internal pure {
1367         int256 i = left;
1368         int256 j = right;
1369         if(i==j) return;
1370         uint256 pivot = arr[uint256(left + (right - left) / 2)];
1371         while (i <= j) {
1372             while (arr[uint256(i)] < pivot) i++;
1373             while (pivot < arr[uint256(j)]) j--;
1374             if (i <= j) {
1375                 (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
1376                 i++;
1377                 j--;
1378             }
1379         }
1380         if (left < j)
1381             quickSort(arr, left, j);
1382         if (i < right)
1383             quickSort(arr, i, right);
1384     }
1385     
1386     function _swapPair(uint256[] memory matchingIds, uint256 id1, uint256 id2, uint256 id3, uint256 id4) internal pure {
1387         uint256 temp = matchingIds[id1];
1388         matchingIds[id1] = matchingIds[id2];
1389         matchingIds[id2] = temp;
1390         
1391         temp = matchingIds[id3];
1392         matchingIds[id3] = matchingIds[id4];
1393         matchingIds[id4] = temp;
1394     }
1395     
1396     function _swapValues(uint256[] memory matchingIds, uint256 id1, uint256 id2) internal pure {
1397         uint256 temp = matchingIds[id1];
1398         matchingIds[id1] = matchingIds[id2];
1399         matchingIds[id2] = temp;
1400     }
1401     
1402     function _getMatchingIds(uint256[] memory matchingIds, uint256 _pvpInterval, uint256 _skipCycles, uint256 _expandInterval) 
1403     internal pure returns(uint256 matchingCount) 
1404     {
1405         matchingCount = matchingIds.length;
1406         if (matchingCount == 0) return 0;
1407         
1408         uint256 warriorId;
1409         uint256 index;
1410         //sort matching ids
1411         quickSort(matchingIds, int256(0), int256(matchingCount - 1));
1412         //find pairs
1413         int256 rating1;
1414         uint256 pairIndex = 0;
1415         int256 ratingRange;
1416         for(index = 0; index < matchingCount; index++) {
1417             //get packed value
1418             warriorId = matchingIds[index];
1419             //unpack rating 1
1420             rating1 = int256(_unpackRatingValue(warriorId));
1421             ratingRange = int256(getRatingRange(_unpackCycleValue(warriorId) + _skipCycles, _pvpInterval, _expandInterval));
1422             
1423             if (index > pairIndex && //check left neighbor
1424             isMatching(rating1, int256(_unpackRatingValue(matchingIds[index - 1])), ratingRange)) {
1425                 //move matched pairs to the left
1426                 //swap pairs
1427                 _swapPair(matchingIds, pairIndex, index - 1, pairIndex + 1, index);
1428                 //mark last pair position
1429                 pairIndex += 2;
1430             } else if (index + 1 < matchingCount && //check right neighbor
1431             isMatching(rating1, int256(_unpackRatingValue(matchingIds[index + 1])), ratingRange)) {
1432                 //move matched pairs to the left
1433                 //swap pairs
1434                 _swapPair(matchingIds, pairIndex, index, pairIndex + 1, index + 1);
1435                 //mark last pair position
1436                 pairIndex += 2;
1437                 //skip next iteration
1438                 index++;
1439             }
1440         }
1441         
1442         matchingCount = pairIndex;
1443     }
1444 
1445     function _getPVPBattleResults(uint256[] memory matchingIds, uint256 matchingCount, uint256 _targetBlock) internal view {
1446         uint256 exp = 0;
1447         uint256 hash = 0;
1448         uint256 result = 0;
1449         for (uint256 even = 0; even < matchingCount; even += 2) {
1450             if (exp == 0 || exp > 73) {
1451                 hash = uint256(keccak256(block.blockhash(_getTargetBlock(_targetBlock)), hash));
1452                 exp = 0;
1453             }
1454                 
1455             //compute battle result 1 = even(left) id won, 2 - odd(right) id won
1456             result = getPVPBattleResult(matchingIds[even], matchingIds[even + 1], hash % (1000 * 10**exp) / 10**exp);
1457             require(result > 0 && result < 3);
1458             exp++;
1459             //if odd warrior won, swap his id with even warrior,
1460             //otherwise do nothing,
1461             //even ids are winning ids! odds suck!
1462             if (result == 2) {
1463                 _swapValues(matchingIds, even, even + 1);
1464             }
1465         }
1466     }
1467     
1468     function _getLevel(uint256 _levelPoints) internal pure returns(uint256) {
1469         return _levelPoints / POINTS_TO_LEVEL;
1470     }
1471     
1472 }
1473 
1474 library DataTypes {
1475      // / @dev The main Warrior struct. Every warrior in CryptoWarriors is represented by a copy
1476     // /  of this structure, so great care was taken to ensure that it fits neatly into
1477     // /  exactly two 256-bit words. Note that the order of the members in this structure
1478     // /  is important because of the byte-packing rules used by Ethereum.
1479     // /  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
1480     struct Warrior{
1481         // The Warrior's identity code is packed into these 256-bits
1482         uint256 identity;
1483         
1484         uint64 cooldownEndBlock;
1485         /** every warriors starts from 1 lv (10 level points per level) */
1486         uint64 level;
1487         /** PVP rating, every warrior starts with 100 rating */
1488         int64 rating;
1489         // 0 - idle
1490         uint32 action;
1491         /** Set to the index in the levelRequirements array (see CryptoWarriorBase.levelRequirements) that represents
1492          *  the current dungeon level requirement for warrior. This starts at zero. */
1493         uint32 dungeonIndex;
1494     }
1495 }
1496 
1497 contract CryptoWarriorBase is PermissionControll, PVPListenerInterface {
1498 
1499     /*** EVENTS ***/
1500 
1501     /// @dev The Arise event is fired whenever a new warrior comes into existence. This obviously
1502     ///  includes any time a warrior is created through the ariseWarrior method, but it is also called
1503     ///  when a new miner warrior is created.
1504     event Arise(address owner, uint256 warriorId, uint256 identity);
1505 
1506     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a warrior
1507     ///  ownership is assigned, including dungeon rewards.
1508     event Transfer(address from, address to, uint256 tokenId);
1509 
1510     /*** CONSTANTS ***/
1511     
1512 	uint256 public constant IDLE = 0;
1513     uint256 public constant PVE_BATTLE = 1;
1514     uint256 public constant PVP_BATTLE = 2;
1515     uint256 public constant TOURNAMENT_BATTLE = 3;
1516     
1517     //max pve dungeon level
1518     uint256 public constant MAX_LEVEL = 25;
1519     //how many points is needed to get 1 level
1520     uint256 public constant POINTS_TO_LEVEL = 10;
1521     
1522     /// @dev A lookup table contains PVE dungeon level requirements, each time warrior
1523     /// completes dungeon, next level requirement is set, until 25lv (250points) is reached.
1524     uint32[6] public dungeonRequirements = [
1525         uint32(10),
1526         uint32(30),
1527         uint32(60),
1528         uint32(100),
1529         uint32(150),
1530         uint32(250)
1531     ];
1532 
1533     // An approximation of currently how many seconds are in between blocks.
1534     uint256 public secondsPerBlock = 15;
1535 
1536     /*** STORAGE ***/
1537 
1538     /// @dev An array containing the Warrior struct for all Warriors in existence. The ID
1539     ///  of each warrior is actually an index of this array.
1540     DataTypes.Warrior[] warriors;
1541 
1542     /// @dev A mapping from warrior IDs to the address that owns them. All warriors have
1543     ///  some valid owner address, even miner warriors are created with a non-zero owner.
1544     mapping (uint256 => address) public warriorToOwner;
1545 
1546     // @dev A mapping from owner address to count of tokens that address owns.
1547     //  Used internally inside balanceOf() to resolve ownership count.
1548     mapping (address => uint256) ownersTokenCount;
1549 
1550     /// @dev A mapping from warrior IDs to an address that has been approved to call
1551     ///  transferFrom(). Each Warrior can only have one approved address for transfer
1552     ///  at any time. A zero value means no approval is outstanding.
1553     mapping (uint256 => address) public warriorToApproved;
1554     
1555     // Mapping from owner to list of owned token IDs
1556     mapping (address => uint256[]) internal ownedTokens;
1557 
1558     // Mapping from token ID to index of the owner tokens list
1559     mapping(uint256 => uint256) internal ownedTokensIndex;
1560 
1561 
1562     /// @dev The address of the ClockAuction contract that handles sales of warriors. This
1563     ///  same contract handles both peer-to-peer sales as well as the miner sales which are
1564     ///  initiated every 15 minutes.
1565     SaleClockAuction public saleAuction;
1566     
1567     
1568     /// @dev Assigns ownership of a specific warrior to an address.
1569     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1570         // When creating new warriors _from is 0x0, but we can't account that address.
1571         if (_from != address(0)) {
1572             _clearApproval(_tokenId);
1573             _removeTokenFrom(_from, _tokenId);
1574         }
1575         _addTokenTo(_to, _tokenId);
1576         
1577         // Emit the transfer event.
1578         Transfer(_from, _to, _tokenId);
1579     }
1580     
1581     function _addTokenTo(address _to, uint256 _tokenId) internal {
1582         // Since the number of warriors is capped to '1 000 000' we can't overflow this
1583         ownersTokenCount[_to]++;
1584         // transfer ownership
1585         warriorToOwner[_tokenId] = _to;
1586         
1587         uint256 length = ownedTokens[_to].length;
1588         ownedTokens[_to].push(_tokenId);
1589         ownedTokensIndex[_tokenId] = length;
1590     }
1591     
1592     function _removeTokenFrom(address _from, uint256 _tokenId) internal {
1593         //
1594         ownersTokenCount[_from]--;
1595         
1596         warriorToOwner[_tokenId] = address(0);
1597         
1598         uint256 tokenIndex = ownedTokensIndex[_tokenId];
1599         uint256 lastTokenIndex = ownedTokens[_from].length - 1;
1600         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1601     
1602         ownedTokens[_from][tokenIndex] = lastToken;
1603         ownedTokens[_from][lastTokenIndex] = 0;
1604         
1605         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1606         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1607         // the lastToken to the first position, and then dropping the element placed in the last position of the list
1608         ownedTokens[_from].length--;
1609         ownedTokensIndex[_tokenId] = 0;
1610         ownedTokensIndex[lastToken] = tokenIndex;
1611     }
1612     
1613     function _clearApproval(uint256 _tokenId) internal {
1614         if (warriorToApproved[_tokenId] != address(0)) {
1615             // clear any previously approved ownership exchange
1616             warriorToApproved[_tokenId] = address(0);
1617         }
1618     }
1619     
1620     function _createWarrior(uint256 _identity, address _owner, uint256 _cooldown, uint256 _level, uint256 _rating, uint256 _dungeonIndex)
1621         internal
1622         returns (uint256) {
1623         	    
1624         DataTypes.Warrior memory _warrior = DataTypes.Warrior({
1625             identity : _identity,
1626             cooldownEndBlock : uint64(_cooldown),
1627             level : uint64(_level),//uint64(10),
1628             rating : int64(_rating),//int64(100),
1629             action : uint32(IDLE),
1630             dungeonIndex : uint32(_dungeonIndex)//uint32(0)
1631         });
1632         uint256 newWarriorId = warriors.push(_warrior) - 1;
1633         
1634         // let's just be 100% sure we never let this happen.
1635         require(newWarriorId == uint256(uint32(newWarriorId)));
1636         
1637         // emit the arise event
1638         Arise(_owner, newWarriorId, _identity);
1639         
1640         // This will assign ownership, and also emit the Transfer event as
1641         // per ERC721 draft
1642         _transfer(0, _owner, newWarriorId);
1643 
1644         return newWarriorId;
1645     }
1646     
1647 
1648     // Any C-level can fix how many seconds per blocks are currently observed.
1649     function setSecondsPerBlock(uint256 secs) external onlyAuthorized {
1650         secondsPerBlock = secs;
1651     }
1652 }
1653 
1654 contract WarriorTokenImpl is CryptoWarriorBase, ERC721 {
1655 
1656     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
1657     string public constant name = "CryptoWarriors";
1658     string public constant symbol = "CW";
1659 
1660     bytes4 constant InterfaceSignature_ERC165 =
1661         bytes4(keccak256('supportsInterface(bytes4)'));
1662 
1663     bytes4 constant InterfaceSignature_ERC721 =
1664         bytes4(keccak256('name()')) ^
1665         bytes4(keccak256('symbol()')) ^
1666         bytes4(keccak256('totalSupply()')) ^
1667         bytes4(keccak256('balanceOf(address)')) ^
1668         bytes4(keccak256('ownerOf(uint256)')) ^
1669         bytes4(keccak256('approve(address,uint256)')) ^
1670         bytes4(keccak256('transfer(address,uint256)')) ^
1671         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1672         bytes4(keccak256('tokensOfOwner(address)'));
1673 
1674     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
1675     ///  Returns true for any standardized interfaces implemented by this contract. We implement
1676     ///  ERC-165 (obviously!) and ERC-721.
1677     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
1678     {
1679         // DEBUG ONLY
1680         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9f40b779));
1681 
1682         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
1683     }
1684 
1685     // Internal utility functions: These functions all assume that their input arguments
1686     // are valid. We leave it to public methods to sanitize their inputs and follow
1687     // the required logic.
1688 
1689     /** @dev Checks if a given address is the current owner of the specified Warrior tokenId.
1690      * @param _claimant the address we are validating against.
1691      * @param _tokenId warrior id
1692      */
1693     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1694         return _claimant != address(0) && warriorToOwner[_tokenId] == _claimant;    
1695     }
1696 
1697     function _ownerApproved(address _claimant, uint256 _tokenId) internal view returns (bool) {
1698         return _claimant != address(0) &&//0 address means token is burned 
1699         warriorToOwner[_tokenId] == _claimant && warriorToApproved[_tokenId] == address(0);    
1700     }
1701 
1702     /// @dev Checks if a given address currently has transferApproval for a particular Warrior.
1703     /// @param _claimant the address we are confirming warrior is approved for.
1704     /// @param _tokenId warrior id
1705     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1706         return warriorToApproved[_tokenId] == _claimant;
1707     }
1708 
1709     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
1710     ///  approval. Setting _approved to address(0) clears all transfer approval.
1711     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
1712     ///  _approve() and transferFrom() are used together for putting Warriors on auction, and
1713     ///  there is no value in spamming the log with Approval events in that case.
1714     function _approve(uint256 _tokenId, address _approved) internal {
1715         warriorToApproved[_tokenId] = _approved;
1716     }
1717 
1718     /// @notice Returns the number of Warriors(tokens) owned by a specific address.
1719     /// @param _owner The owner address to check.
1720     /// @dev Required for ERC-721 compliance
1721     function balanceOf(address _owner) public view returns (uint256 count) {
1722         return ownersTokenCount[_owner];
1723     }
1724 
1725     /// @notice Transfers a Warrior to another address. If transferring to a smart
1726     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1727     ///  CryptoWarriors specifically) or your Warrior may be lost forever. Seriously.
1728     /// @param _to The address of the recipient, can be a user or contract.
1729     /// @param _tokenId The ID of the Warrior to transfer.
1730     /// @dev Required for ERC-721 compliance.
1731     function transfer(address _to, uint256 _tokenId) external whenNotPaused {
1732         // Safety check to prevent against an unexpected 0x0 default.
1733         require(_to != address(0));
1734         // Disallow transfers to this contract to prevent accidental misuse.
1735         // The contract should never own any warriors (except very briefly
1736         // after a miner warrior is created and before it goes on auction).
1737         require(_to != address(this));
1738         // Disallow transfers to the auction contracts to prevent accidental
1739         // misuse. Auction contracts should only take ownership of warriors
1740         // through the allow + transferFrom flow.
1741         require(_to != address(saleAuction));
1742         // You can only send your own warrior.
1743         require(_owns(msg.sender, _tokenId));
1744         // Only idle warriors are allowed 
1745         require(warriors[_tokenId].action == IDLE);
1746 
1747         // Reassign ownership, clear pending approvals, emit Transfer event.
1748         _transfer(msg.sender, _to, _tokenId);
1749     }
1750     
1751     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
1752         require(_index < balanceOf(_owner));
1753         return ownedTokens[_owner][_index];
1754     }
1755 
1756     /// @notice Grant another address the right to transfer a specific Warrior via
1757     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1758     /// @param _to The address to be granted transfer approval. Pass address(0) to
1759     ///  clear all approvals.
1760     /// @param _tokenId The ID of the Warrior that can be transferred if this call succeeds.
1761     /// @dev Required for ERC-721 compliance.
1762     function approve(address _to, uint256 _tokenId) external whenNotPaused {
1763         // Only an owner can grant transfer approval.
1764         require(_owns(msg.sender, _tokenId));
1765         // Only idle warriors are allowed 
1766         require(warriors[_tokenId].action == IDLE);
1767 
1768         // Register the approval (replacing any previous approval).
1769         _approve(_tokenId, _to);
1770 
1771         // Emit approval event.
1772         Approval(msg.sender, _to, _tokenId);
1773     }
1774 
1775     /// @notice Transfer a Warrior owned by another address, for which the calling address
1776     ///  has previously been granted transfer approval by the owner.
1777     /// @param _from The address that owns the Warrior to be transfered.
1778     /// @param _to The address that should take ownership of the Warrior. Can be any address,
1779     ///  including the caller.
1780     /// @param _tokenId The ID of the Warrior to be transferred.
1781     /// @dev Required for ERC-721 compliance.
1782     function transferFrom(address _from, address _to, uint256 _tokenId)
1783         external
1784         whenNotPaused
1785     {
1786         // Safety check to prevent against an unexpected 0x0 default.
1787         require(_to != address(0));
1788         // Disallow transfers to this contract to prevent accidental misuse.
1789         // The contract should never own any warriors (except very briefly
1790         // after a miner warrior is created and before it goes on auction).
1791         require(_to != address(this));
1792         // Check for approval and valid ownership
1793         require(_approvedFor(msg.sender, _tokenId));
1794         require(_owns(_from, _tokenId));
1795         // Only idle warriors are allowed 
1796         require(warriors[_tokenId].action == IDLE);
1797 
1798         // Reassign ownership (also clears pending approvals and emits Transfer event).
1799         _transfer(_from, _to, _tokenId);
1800     }
1801 
1802     /// @notice Returns the total number of Warriors currently in existence.
1803     /// @dev Required for ERC-721 compliance.
1804     function totalSupply() public view returns (uint256) {
1805         return warriors.length;
1806     }
1807 
1808     /// @notice Returns the address currently assigned ownership of a given Warrior.
1809     /// @dev Required for ERC-721 compliance.
1810     function ownerOf(uint256 _tokenId)
1811         external
1812         view
1813         returns (address owner)
1814     {
1815         require(_tokenId < warriors.length);
1816         owner = warriorToOwner[_tokenId];
1817     }
1818 
1819     /// @notice Returns a list of all Warrior IDs assigned to an address.
1820     /// @param _owner The owner whose Warriors we are interested in.
1821     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
1822         return ownedTokens[_owner];
1823     }
1824     
1825     function tokensOfOwnerFromIndex(address _owner, uint256 _fromIndex, uint256 _count) external view returns(uint256[] memory ownerTokens) {
1826         require(_fromIndex < balanceOf(_owner));
1827         uint256[] storage tokens = ownedTokens[_owner];
1828         //        
1829         uint256 ownerBalance = ownersTokenCount[_owner];
1830         uint256 lenght = (ownerBalance - _fromIndex >= _count ? _count : ownerBalance - _fromIndex);
1831         //
1832         ownerTokens = new uint256[](lenght);
1833         for(uint256 i = 0; i < lenght; i ++) {
1834             ownerTokens[i] = tokens[_fromIndex + i];
1835         }
1836         
1837         return ownerTokens;
1838     }
1839     
1840     /**
1841      * @dev Internal function to burn a specific token
1842      * @dev Reverts if the token does not exist
1843      * @param _owner owner of the token to burn
1844      * @param _tokenId uint256 ID of the token being burned by the msg.sender
1845      */
1846     function _burn(address _owner, uint256 _tokenId) internal {
1847         _clearApproval(_tokenId);
1848         _removeTokenFrom(_owner, _tokenId);
1849         
1850         Transfer(_owner, address(0), _tokenId);
1851     }
1852 
1853 }
1854 
1855 contract CryptoWarriorPVE is WarriorTokenImpl {
1856     uint256 internal constant MINER_PERK = 1;
1857     uint256 internal constant SUMMONING_SICKENESS = 12;
1858     
1859     uint256 internal constant PVE_COOLDOWN = 1 hours;
1860     uint256 internal constant PVE_DURATION = 15 minutes;
1861     
1862     
1863     /// @notice The payment required to use startPVEBattle().
1864     uint256 public pveBattleFee = 10 finney;
1865     uint256 public constant PVE_COMPENSATION = 2 finney;
1866     
1867 	/// @dev The address of the sibling contract that is used to implement warrior generation algorithm.
1868     SanctuaryInterface public sanctuary;
1869 
1870     /** @dev PVEStarted event. Emitted every time a warrior enters pve battle
1871      *  @param owner Warrior owner
1872      *  @param dungeonIndex Started dungeon index 
1873      *  @param warriorId Warrior ID that started PVE dungeon
1874      *  @param battleEndBlock Block number, when started PVE dungeon will be completed
1875      */
1876     event PVEStarted(address owner, uint256 dungeonIndex, uint256 warriorId, uint256 battleEndBlock);
1877 
1878     /** @dev PVEFinished event. Emitted every time a warrior finishes pve battle
1879      *  @param owner Warrior owner
1880      *  @param dungeonIndex Finished dungeon index
1881      *  @param warriorId Warrior ID that completed dungeon
1882      *  @param cooldownEndBlock Block number, when cooldown on PVE battle entrance will be over
1883      *  @param rewardId Warrior ID which was granted to the owner as battle reward
1884      */
1885     event PVEFinished(address owner, uint256 dungeonIndex, uint256 warriorId, uint256 cooldownEndBlock, uint256 rewardId);
1886 
1887 	/// @dev Update the address of the sanctuary contract, can only be called by the Admin.
1888     /// @param _address An address of a sanctuary contract instance to be used from this point forward.
1889     function setSanctuaryAddress(address _address) external onlyAdmin {
1890         SanctuaryInterface candidateContract = SanctuaryInterface(_address);
1891 
1892         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1893         require(candidateContract.isSanctuary());
1894 
1895         // Set the new contract address
1896         sanctuary = candidateContract;
1897     }
1898     
1899     function areUnique(uint256[] memory _warriorIds) internal pure returns(bool) {
1900    	    uint256 length = _warriorIds.length;
1901    	    uint256 j;
1902         for(uint256 i = 0; i < length; i++) {
1903 	        for(j = i + 1; j < length; j++) {
1904 	            if (_warriorIds[i] == _warriorIds[j]) return false;
1905 	        }
1906         }
1907         return true; 
1908    	}
1909 
1910     /// @dev Updates the minimum payment required for calling startPVE(). Can only
1911     ///  be called by the COO address.
1912     function setPVEBattleFee(uint256 _pveBattleFee) external onlyAdmin {
1913         require(_pveBattleFee > PVE_COMPENSATION);
1914         pveBattleFee = _pveBattleFee;
1915     }
1916     
1917     /** @dev Returns PVE cooldown, after each battle, the warrior receives a 
1918      *  cooldown on the next entrance to the battle, cooldown depends on current warrior level,
1919      *  which is multiplied by 1h. Special case: after receiving 25 lv, the cooldwon will be 14 days.
1920      *  @param _levelPoints warrior level */
1921     function getPVECooldown(uint256 _levelPoints) public pure returns (uint256) {
1922         uint256 level = CryptoUtils._getLevel(_levelPoints);
1923         if (level >= MAX_LEVEL) return (14 * 24 * PVE_COOLDOWN);//14 days
1924         return (PVE_COOLDOWN * level);
1925     }
1926 
1927     /** @dev Returns PVE duration, each battle have a duration, which depends on current warrior level,
1928      *  which is multiplied by 15 min. At the end of the duration, warrior is becoming eligible to receive
1929      *  battle reward (new warrior in shiny armor)
1930      *  @param _levelPoints warrior level points 
1931      */
1932     function getPVEDuration(uint256 _levelPoints) public pure returns (uint256) {
1933         return CryptoUtils._getLevel(_levelPoints) * PVE_DURATION;
1934     }
1935     
1936     /// @dev Checks that a given warrior can participate in PVE battle. Requires that the
1937     ///  current cooldown is finished and also checks that warrior is idle (does not participate in any action)
1938     ///  and dungeon level requirement is satisfied
1939     function _isReadyToPVE(DataTypes.Warrior _warrior) internal view returns (bool) {
1940         return (_warrior.action == IDLE) && //is idle
1941         (_warrior.cooldownEndBlock <= uint64(block.number)) && //no cooldown
1942         (_warrior.level >= dungeonRequirements[_warrior.dungeonIndex]);//dungeon level requirement is satisfied
1943     }
1944     
1945     /// @dev Internal utility function to initiate pve battle, assumes that all battle
1946     ///  requirements have been checked.
1947     function _triggerPVEStart(uint256 _warriorId) internal {
1948         // Grab a reference to the warrior from storage.
1949         DataTypes.Warrior storage warrior = warriors[_warriorId];
1950         // Set warrior current action to pve battle
1951         warrior.action = uint16(PVE_BATTLE);
1952         // Set battle duration
1953         warrior.cooldownEndBlock = uint64((getPVEDuration(warrior.level) / secondsPerBlock) + block.number);
1954         // Emit the pve battle start event.
1955         PVEStarted(msg.sender, warrior.dungeonIndex, _warriorId, warrior.cooldownEndBlock);
1956     }
1957     
1958     /// @dev Starts PVE battle for specified warrior, 
1959     /// after battle, warrior owner will receive reward (Warrior) 
1960     /// @param _warriorId A Warrior ready to PVE battle.
1961     function startPVE(uint256 _warriorId) external payable whenNotPaused {
1962 		// Checks for payment.
1963         require(msg.value >= pveBattleFee);
1964 		
1965 		// Caller must own the warrior.
1966         require(_ownerApproved(msg.sender, _warriorId));
1967 
1968         // Grab a reference to the warrior in storage.
1969         DataTypes.Warrior storage warrior = warriors[_warriorId];
1970 
1971         // Check that the warrior exists.
1972         require(warrior.identity != 0);
1973 
1974         // Check that the warrior is ready to battle
1975         require(_isReadyToPVE(warrior));
1976         
1977         // All checks passed, let the battle begin!
1978         _triggerPVEStart(_warriorId);
1979         
1980         // Calculate any excess funds included in msg.value. If the excess
1981         // is anything worth worrying about, transfer it back to message owner.
1982         // NOTE: We checked above that the msg.value is greater than or
1983         // equal to the price so this cannot underflow.
1984         uint256 feeExcess = msg.value - pveBattleFee;
1985 
1986         // Return the funds. This is not susceptible 
1987         // to a re-entry attack because of _isReadyToPVE check
1988         // will fail
1989         msg.sender.transfer(feeExcess);
1990         //send battle fee to beneficiary
1991         bankAddress.transfer(pveBattleFee - PVE_COMPENSATION);
1992     }
1993     
1994     function _ariseWarrior(address _owner, DataTypes.Warrior storage _warrior) internal returns(uint256) {
1995         uint256 identity = sanctuary.generateWarrior(_warrior.identity, CryptoUtils._getLevel(_warrior.level), _warrior.cooldownEndBlock - 1, 0);
1996         return _createWarrior(identity, _owner, block.number + (PVE_COOLDOWN * SUMMONING_SICKENESS / secondsPerBlock), 10, 100, 0);
1997     }
1998 
1999 	/// @dev Internal utility function to finish pve battle, assumes that all battle
2000     ///  finish requirements have been checked.
2001     function _triggerPVEFinish(uint256 _warriorId) internal {
2002         // Grab a reference to the warrior in storage.
2003         DataTypes.Warrior storage warrior = warriors[_warriorId];
2004         
2005         // Set warrior current action to idle
2006         warrior.action = uint16(IDLE);
2007         
2008         // Compute an estimation of the cooldown time in blocks (based on current level).
2009         // and miner perc also reduces cooldown time by 4 times
2010         warrior.cooldownEndBlock = uint64((getPVECooldown(warrior.level) / 
2011             CryptoUtils._getBonus(warrior.identity) / secondsPerBlock) + block.number);
2012         
2013         // cash completed dungeon index before increment
2014         uint256 dungeonIndex = warrior.dungeonIndex;
2015         // Increment the dungeon index, clamping it at 5, which is the length of the
2016         // dungeonRequirements array. We could check the array size dynamically, but hard-coding
2017         // this as a constant saves gas.
2018         if (dungeonIndex < 5) {
2019             warrior.dungeonIndex += 1;
2020         }
2021         
2022         address owner = warriorToOwner[_warriorId];
2023         // generate reward
2024         uint256 arisenWarriorId = _ariseWarrior(owner, warrior);
2025         //Emit event
2026         PVEFinished(owner, dungeonIndex, _warriorId, warrior.cooldownEndBlock, arisenWarriorId);
2027     }
2028     
2029     /**
2030      * @dev finishPVE can be called after battle time is over,
2031      * if checks are passed then battle result is computed,
2032      * and new warrior is awarded to owner of specified _warriord ID.
2033      * NB anyone can call this method, if they willing to pay the gas price
2034      */
2035     function finishPVE(uint256 _warriorId) external whenNotPaused {
2036         // Grab a reference to the warrior in storage.
2037         DataTypes.Warrior storage warrior = warriors[_warriorId];
2038         
2039         // Check that the warrior exists.
2040         require(warrior.identity != 0);
2041         
2042         // Check that warrior participated in PVE battle action
2043         require(warrior.action == PVE_BATTLE);
2044         
2045         // And the battle time is over
2046         require(warrior.cooldownEndBlock <= uint64(block.number));
2047         
2048         // When the all checks done, calculate actual battle result
2049         _triggerPVEFinish(_warriorId);
2050         
2051         //not susceptible to reetrance attack because of require(warrior.action == PVE_BATTLE)
2052         //and require(warrior.cooldownEndBlock <= uint64(block.number));
2053         msg.sender.transfer(PVE_COMPENSATION);
2054     }
2055     
2056     /**
2057      * @dev finishPVEBatch same as finishPVE but for multiple warrior ids.
2058      * NB anyone can call this method, if they willing to pay the gas price
2059      */
2060     function finishPVEBatch(uint256[] _warriorIds) external whenNotPaused {
2061         uint256 length = _warriorIds.length;
2062         //check max number of bach finish pve
2063         require(length <= 20);
2064         uint256 blockNumber = block.number;
2065         uint256 index;
2066         //all warrior ids must be unique
2067         require(areUnique(_warriorIds));
2068         //check prerequisites
2069         for(index = 0; index < length; index ++) {
2070             DataTypes.Warrior storage warrior = warriors[_warriorIds[index]];
2071 			require(
2072 		        // Check that the warrior exists.
2073 			    warrior.identity != 0 &&
2074 		        // Check that warrior participated in PVE battle action
2075 			    warrior.action == PVE_BATTLE &&
2076 		        // And the battle time is over
2077 			    warrior.cooldownEndBlock <= blockNumber
2078 			);
2079         }
2080         // When the all checks done, calculate actual battle result
2081         for(index = 0; index < length; index ++) {
2082             _triggerPVEFinish(_warriorIds[index]);
2083         }
2084         
2085         //not susceptible to reetrance attack because of require(warrior.action == PVE_BATTLE)
2086         //and require(warrior.cooldownEndBlock <= uint64(block.number));
2087         msg.sender.transfer(PVE_COMPENSATION * length);
2088     }
2089 }
2090 
2091 contract CryptoWarriorSanctuary is CryptoWarriorPVE {
2092     
2093     uint256 internal constant RARE = 3;
2094     
2095     function burnWarrior(uint256 _warriorId, address _owner) whenNotPaused external {
2096         require(msg.sender == address(sanctuary));
2097         
2098         // Caller must own the warrior.
2099         require(_ownerApproved(_owner, _warriorId));
2100 
2101         // Grab a reference to the warrior in storage.
2102         DataTypes.Warrior storage warrior = warriors[_warriorId];
2103 
2104         // Check that the warrior exists.
2105         require(warrior.identity != 0);
2106 
2107         // Check that the warrior is ready to battle
2108         require(warrior.action == IDLE);//is idle
2109         
2110         // Rarity of burned warrior must be less or equal RARE (3)
2111         require(CryptoUtils.getRarityValue(warrior.identity) <= RARE);
2112         // Warriors with MINER perc are not allowed to be berned
2113         require(CryptoUtils.getSpecialityValue(warrior.identity) < MINER_PERK);
2114         
2115         _burn(_owner, _warriorId);
2116     }
2117     
2118     function ariseWarrior(uint256 _identity, address _owner, uint256 _cooldown) whenNotPaused external returns(uint256){
2119         require(msg.sender == address(sanctuary));
2120         return _createWarrior(_identity, _owner, _cooldown, 10, 100, 0);
2121     }
2122     
2123 }
2124 
2125 contract CryptoWarriorPVP is CryptoWarriorSanctuary {
2126 	
2127 	PVPInterface public battleProvider;
2128 	
2129 	/// @dev Sets the reference to the sale auction.
2130     /// @param _address - Address of sale contract.
2131     function setBattleProviderAddress(address _address) external onlyAdmin {
2132         PVPInterface candidateContract = PVPInterface(_address);
2133 
2134         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2135         require(candidateContract.isPVPProvider());
2136 
2137         // Set the new contract address
2138         battleProvider = candidateContract;
2139     }
2140     
2141     function _packPVPData(uint256 _warriorId, DataTypes.Warrior storage warrior) internal view returns(uint256){
2142         return CryptoUtils._packWarriorPvpData(warrior.identity, uint256(warrior.rating), 0, _warriorId, warrior.level);
2143     }
2144     
2145     function _triggerPVPSignUp(uint256 _warriorId, uint256 fee) internal {
2146         DataTypes.Warrior storage warrior = warriors[_warriorId];
2147     		
2148 		uint256 packedWarrior = _packPVPData(_warriorId, warrior);
2149         
2150         // addPVPContender will throw if fee fails.
2151         battleProvider.addPVPContender.value(fee)(msg.sender, packedWarrior);
2152         
2153         warrior.action = uint16(PVP_BATTLE);
2154     }
2155     
2156     /*
2157      * @title signUpForPVP enqueues specified warrior to PVP
2158      * 
2159      * @dev When the owner enqueues his warrior for PvP, the warrior enters the waiting room.
2160      * Once every 15 minutes, we check the warriors in the room and select pairs. 
2161      * For those warriors to whom we found couples, fighting is conducted and the results 
2162      * are recorded in the profile of the warrior. 
2163      */
2164     function signUpForPVP(uint256 _warriorId) public payable whenNotPaused {//done
2165 		// Caller must own the warrior.
2166         require(_ownerApproved(msg.sender, _warriorId));
2167         // Grab a reference to the warrior in storage.
2168         DataTypes.Warrior storage warrior = warriors[_warriorId];
2169         // sanity check
2170         require(warrior.identity != 0);
2171 
2172         // Check that the warrior is ready to battle
2173         require(warrior.action == IDLE);
2174         
2175         // Define the current price of the auction.
2176         uint256 fee = battleProvider.getPVPEntranceFee(warrior.level);
2177         
2178         // Checks for payment.
2179         require(msg.value >= fee);
2180         
2181         // All checks passed, put the warrior to the queue!
2182         _triggerPVPSignUp(_warriorId, fee);
2183         
2184         // Calculate any excess funds included in msg.value. If the excess
2185         // is anything worth worrying about, transfer it back to message owner.
2186         // NOTE: We checked above that the msg.value is greater than or
2187         // equal to the price so this cannot underflow.
2188         uint256 feeExcess = msg.value - fee;
2189 
2190         // Return the funds. This is not susceptible 
2191         // to a re-entry attack because of warrior.action == IDLE check
2192         // will fail
2193         msg.sender.transfer(feeExcess);
2194     }
2195 
2196     function _grandPVPWinnerReward(uint256 _warriorId) internal {
2197         DataTypes.Warrior storage warrior = warriors[_warriorId];
2198         // reward 1 level, add 10 level points
2199         uint256 level = warrior.level;
2200         if (level < (MAX_LEVEL * POINTS_TO_LEVEL)) {
2201             level = level + POINTS_TO_LEVEL;
2202 			warrior.level = uint64(level > (MAX_LEVEL * POINTS_TO_LEVEL) ? (MAX_LEVEL * POINTS_TO_LEVEL) : level);
2203         }
2204 		// give 100 rating for levelUp and 30 for win
2205 		warrior.rating += 130;
2206 		// mark warrior idle, so it can participate
2207 		// in another actions
2208 		warrior.action = uint16(IDLE);
2209     }
2210 
2211     function _grandPVPLoserReward(uint256 _warriorId) internal {
2212         DataTypes.Warrior storage warrior = warriors[_warriorId];
2213 		// reward 0.5 level
2214 		uint256 oldLevel = warrior.level;
2215 		uint256 level = oldLevel;
2216 		if (level < (MAX_LEVEL * POINTS_TO_LEVEL)) {
2217             level += (POINTS_TO_LEVEL / 2);
2218 			warrior.level = uint64(level);
2219         }
2220 		// give 100 rating for levelUp if happens and -30 for lose
2221 		int256 newRating = warrior.rating + (CryptoUtils._getLevel(level) > CryptoUtils._getLevel(oldLevel) ? int256(100 - 30) : int256(-30));
2222 		// rating can't be less than 0 and more than 1000000000
2223 	    warrior.rating = int64((newRating >= 0) ? (newRating > 1000000000 ? 1000000000 : newRating) : 0);
2224         // mark warrior idle, so it can participate
2225 		// in another actions
2226 	    warrior.action = uint16(IDLE);
2227     }
2228     
2229     function _grandPVPRewards(uint256[] memory warriorsData, uint256 matchingCount) internal {
2230         for(uint256 id = 0; id < matchingCount; id += 2){
2231             //
2232             // winner, even ids are winners!
2233             _grandPVPWinnerReward(CryptoUtils._unpackIdValue(warriorsData[id]));
2234             //
2235             // loser, they are odd...
2236             _grandPVPLoserReward(CryptoUtils._unpackIdValue(warriorsData[id + 1]));
2237         }
2238 	}
2239 
2240     // @dev Internal utility function to initiate pvp battle, assumes that all battle
2241     ///  requirements have been checked.
2242     function pvpFinished(uint256[] warriorsData, uint256 matchingCount) public {
2243         //this method can be invoked only by battleProvider contract
2244         require(msg.sender == address(battleProvider));
2245         
2246         _grandPVPRewards(warriorsData, matchingCount);
2247     }
2248     
2249     function pvpContenderRemoved(uint256 _warriorId) public {
2250         //this method can be invoked only by battleProvider contract
2251         require(msg.sender == address(battleProvider));
2252         //grab warrior storage reference
2253         DataTypes.Warrior storage warrior = warriors[_warriorId];
2254         //specified warrior must be in pvp state
2255         require(warrior.action == PVP_BATTLE);
2256         //all checks done
2257         //set warrior state to IDLE
2258         warrior.action = uint16(IDLE);
2259     }
2260 }
2261 
2262 contract CryptoWarriorTournament is CryptoWarriorPVP {
2263     
2264     uint256 internal constant GROUP_SIZE = 5;
2265     
2266     function _ownsAll(address _claimant, uint256[] memory _warriorIds) internal view returns (bool) {
2267         uint256 length = _warriorIds.length;
2268         for(uint256 i = 0; i < length; i++) {
2269             if (!_ownerApproved(_claimant, _warriorIds[i])) return false;
2270         }
2271         return true;    
2272     }
2273     
2274     function _isReadyToTournament(DataTypes.Warrior storage _warrior) internal view returns(bool){
2275         return _warrior.level >= 50 && _warrior.action == IDLE;//must not participate in any action
2276     }
2277     
2278     function _packTournamentData(uint256[] memory _warriorIds) internal view returns(uint256[] memory tournamentData) {
2279         tournamentData = new uint256[](GROUP_SIZE);
2280         uint256 warriorId;
2281         for(uint256 i = 0; i < GROUP_SIZE; i++) {
2282             warriorId = _warriorIds[i];
2283             tournamentData[i] = _packPVPData(warriorId, warriors[warriorId]);   
2284         }
2285         return tournamentData;
2286     }
2287     
2288     
2289     // @dev Internal utility function to sign up to tournament, 
2290     // assumes that all battle requirements have been checked.
2291     function _triggerTournamentSignUp(uint256[] memory _warriorIds, uint256 fee) internal {
2292         //pack warrior ids into into uint256
2293         uint256[] memory tournamentData = _packTournamentData(_warriorIds);
2294         
2295         for(uint256 i = 0; i < GROUP_SIZE; i++) {
2296             // Set warrior current action to tournament battle
2297             warriors[_warriorIds[i]].action = uint16(TOURNAMENT_BATTLE);
2298         }
2299 
2300         battleProvider.addTournamentContender.value(fee)(msg.sender, tournamentData);
2301     }
2302     
2303     function signUpForTournament(uint256[] _warriorIds) public payable {
2304         //
2305         //check that there is enough funds to pay entrance fee
2306         uint256 fee = battleProvider.getTournamentThresholdFee();
2307         require(msg.value >= fee);
2308         //
2309         //check that warriors group is exactly of allowed size
2310         require(_warriorIds.length == GROUP_SIZE);
2311         //
2312         //message sender must own all the specified warrior IDs
2313         require(_ownsAll(msg.sender, _warriorIds));
2314         //
2315         //check all warriors are unique
2316         require(areUnique(_warriorIds));
2317         //
2318         //check that all warriors are 25 lv and IDLE
2319         for(uint256 i = 0; i < GROUP_SIZE; i ++) {
2320             // Grab a reference to the warrior in storage.
2321             require(_isReadyToTournament(warriors[_warriorIds[i]]));
2322         }
2323         
2324         
2325         //all checks passed, trigger sign up
2326         _triggerTournamentSignUp(_warriorIds, fee);
2327         
2328         // Calculate any excess funds included in msg.value. If the excess
2329         // is anything worth worrying about, transfer it back to message owner.
2330         // NOTE: We checked above that the msg.value is greater than or
2331         // equal to the fee so this cannot underflow.
2332         uint256 feeExcess = msg.value - fee;
2333 
2334         // Return the funds. This is not susceptible 
2335         // to a re-entry attack because of _isReadyToTournament check
2336         // will fail
2337         msg.sender.transfer(feeExcess);
2338     }
2339     
2340     function _setIDLE(uint256 warriorIds) internal {
2341         for(uint256 i = 0; i < GROUP_SIZE; i ++) {
2342             warriors[CryptoUtils._unpackWarriorId(warriorIds, i)].action = uint16(IDLE);
2343         }
2344     }
2345     
2346     function _freeWarriors(uint256[] memory packedContenders) internal {
2347         uint256 length = packedContenders.length;
2348         for(uint256 i = 0; i < length; i ++) {
2349             //set participants action to IDLE
2350             _setIDLE(packedContenders[i]);
2351         }
2352     }
2353     
2354     function tournamentFinished(uint256[] packedContenders) public {
2355         //this method can be invoked only by battleProvider contract
2356         require(msg.sender == address(battleProvider));
2357         
2358         //grad rewards and set IDLE action
2359         _freeWarriors(packedContenders);
2360     }
2361     
2362 }
2363 
2364 contract CryptoWarriorAuction is CryptoWarriorTournament {
2365 
2366     // @notice The auction contract variables are defined in CryptoWarriorBase to allow
2367     //  us to refer to them in WarriorTokenImpl to prevent accidental transfers.
2368     // `saleAuction` refers to the auction for miner and p2p sale of warriors.
2369 
2370     /// @dev Sets the reference to the sale auction.
2371     /// @param _address - Address of sale contract.
2372     function setSaleAuctionAddress(address _address) external onlyAdmin {
2373         SaleClockAuction candidateContract = SaleClockAuction(_address);
2374 
2375         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2376         require(candidateContract.isSaleClockAuction());
2377 
2378         // Set the new contract address
2379         saleAuction = candidateContract;
2380     }
2381 
2382 
2383     /// @dev Put a warrior up for auction.
2384     ///  Does some ownership trickery to create auctions in one tx.
2385     function createSaleAuction(
2386         uint256 _warriorId,
2387         uint256 _startingPrice,
2388         uint256 _endingPrice,
2389         uint256 _duration
2390     )
2391         external
2392         whenNotPaused
2393     {
2394         // Auction contract checks input sizes
2395         // If warrior is already on any auction, this will throw
2396         // because it will be owned by the auction contract.
2397         require(_ownerApproved(msg.sender, _warriorId));
2398         // Ensure the warrior is not busy to prevent the auction
2399         // contract creation while warrior is in any kind of battle (PVE, PVP, TOURNAMENT).
2400         require(warriors[_warriorId].action == IDLE);
2401         _approve(_warriorId, address(saleAuction));
2402         // Sale auction throws if inputs are invalid and clears
2403         // transfer approval after escrowing the warrior.
2404         saleAuction.createAuction(
2405             _warriorId,
2406             _startingPrice,
2407             _endingPrice,
2408             _duration,
2409             msg.sender
2410         );
2411     }
2412 
2413 }
2414 
2415 contract CryptoWarriorIssuer is CryptoWarriorAuction {
2416     
2417     // Limits the number of warriors the contract owner can ever create
2418     uint256 public constant MINER_CREATION_LIMIT = 2880;//issue every 15min for one month
2419     // Constants for miner auctions.
2420     uint256 public constant MINER_STARTING_PRICE = 100 finney;
2421     uint256 public constant MINER_END_PRICE = 50 finney;
2422     uint256 public constant MINER_AUCTION_DURATION = 1 days;
2423 
2424     uint256 public minerCreatedCount;
2425 
2426     /// @dev Generates a new miner warrior with MINER perk of COMMON rarity
2427     ///  creates an auction for it.
2428     function createMinerAuction() external onlyIssuer {
2429         require(minerCreatedCount < MINER_CREATION_LIMIT);
2430 		
2431         minerCreatedCount++;
2432 
2433         uint256 identity = sanctuary.generateWarrior(minerCreatedCount, 0, block.number - 1, MINER_PERK);
2434         uint256 warriorId = _createWarrior(identity, bankAddress, 0, 10, 100, 0);
2435         _approve(warriorId, address(saleAuction));
2436 
2437         saleAuction.createAuction(
2438             warriorId,
2439             _computeNextMinerPrice(),
2440             MINER_END_PRICE,
2441             MINER_AUCTION_DURATION,
2442             bankAddress
2443         );
2444     }
2445 
2446     /// @dev Computes the next miner auction starting price, given
2447     ///  the average of the past 5 prices * 2.
2448     function _computeNextMinerPrice() internal view returns (uint256) {
2449         uint256 avePrice = saleAuction.averageMinerSalePrice();
2450 
2451         // Sanity check to ensure we don't overflow arithmetic
2452         require(avePrice == uint256(uint128(avePrice)));
2453 
2454         uint256 nextPrice = avePrice * 3 / 2;//confirmed
2455 
2456         // We never auction for less than starting price
2457         if (nextPrice < MINER_STARTING_PRICE) {
2458             nextPrice = MINER_STARTING_PRICE;
2459         }
2460 
2461         return nextPrice;
2462     }
2463 
2464 }
2465 
2466 contract CoreRecovery is CryptoWarriorIssuer {
2467     
2468     bool public allowRecovery = true;
2469     
2470     //data model
2471     //0 - identity
2472     //1 - cooldownEndBlock
2473     //2 - level
2474     //3 - rating
2475     //4 - index
2476     function recoverWarriors(uint256[] recoveryData, address[] owners) external onlyAdmin whenPaused {
2477         //check that recory action is allowed
2478         require(allowRecovery);
2479         
2480         uint256 length = owners.length;
2481         
2482         //check that number of owners corresponds to recover data length
2483         require(length == recoveryData.length / 5);
2484         
2485         for(uint256 i = 0; i < length; i++) {
2486             _createWarrior(recoveryData[i * 5], owners[i], recoveryData[i * 5 + 1], 
2487                 recoveryData[i * 5 + 2], recoveryData[i * 5 + 3], recoveryData[i * 5 + 4]);
2488         }
2489     }
2490     
2491     //recovery is a one time action, once it is done no more recovery actions allowed
2492     function recoveryDone() external onlyAdmin {
2493         allowRecovery = false;
2494     }
2495 
2496 }
2497 
2498 contract CryptoWarriorCore is CoreRecovery {
2499 
2500     /// @notice Creates the main CryptoWarrior smart contract instance.
2501     function CryptoWarriorCore() public {
2502         // Starts paused.
2503         paused = true;
2504 
2505         // the creator of the contract is the initial Admin
2506         adminAddress = msg.sender;
2507 
2508         // the creator of the contract is also the initial COO
2509         issuerAddress = msg.sender;
2510         
2511         // the creator of the contract is also the initial Bank
2512         bankAddress = msg.sender;
2513     }
2514     
2515     /// @notice No tipping!
2516     /// @dev Reject all Ether from being sent here
2517     /// (Hopefully, we can prevent user accidents.)
2518     function() external payable {
2519         require(false);
2520     }
2521     
2522     /// @dev Override unpause so it requires all external contract addresses
2523     ///  to be set before contract can be unpaused. Also, we can't have
2524     ///  newContractAddress set either, because then the contract was upgraded.
2525     /// @notice This is public rather than external so we can call super.unpause
2526     ///  without using an expensive CALL.
2527     function unpause() public onlyAdmin whenPaused {
2528         require(address(saleAuction) != address(0));
2529         require(address(sanctuary) != address(0));
2530         require(address(battleProvider) != address(0));
2531         require(newContractAddress == address(0));
2532 
2533         // Actually unpause the contract.
2534         super.unpause();
2535     }
2536     
2537     function getBeneficiary() external view returns(address) {
2538         return bankAddress;
2539     }
2540     
2541     function isPVPListener() public pure returns (bool) {
2542         return true;
2543     }
2544        
2545     /**
2546      *@param _warriorIds array of warriorIds, 
2547      * for those IDs warrior data will be packed into warriorsData array
2548      *@return warriorsData packed warrior data
2549      *@return stepSize number of fields in single warrior data */
2550     function getWarriors(uint256[] _warriorIds) external view returns (uint256[] memory warriorsData, uint256 stepSize) {
2551         stepSize = 6;
2552         warriorsData = new uint256[](_warriorIds.length * stepSize);
2553         for(uint256 i = 0; i < _warriorIds.length; i++) {
2554             _setWarriorData(warriorsData, warriors[_warriorIds[i]], i * stepSize);
2555         }
2556     }
2557     
2558     /**
2559      *@param indexFrom index in global warrior storage (aka warriorId), 
2560      * from this index(including), warriors data will be gathered
2561      *@param count Number of warriors to include in packed data
2562      *@return warriorsData packed warrior data
2563      *@return stepSize number of fields in single warrior data */
2564     function getWarriorsFromIndex(uint256 indexFrom, uint256 count) external view returns (uint256[] memory warriorsData, uint256 stepSize) {
2565         stepSize = 6;
2566         //check length
2567         uint256 lenght = (warriors.length - indexFrom >= count ? count : warriors.length - indexFrom);
2568         
2569         warriorsData = new uint256[](lenght * stepSize);
2570         for(uint256 i = 0; i < lenght; i ++) {
2571             _setWarriorData(warriorsData, warriors[indexFrom + i], i * stepSize);
2572         }
2573     }
2574     
2575     function getWarriorOwners(uint256[] _warriorIds) external view returns (address[] memory owners) {
2576         uint256 lenght = _warriorIds.length;
2577         owners = new address[](lenght);
2578         
2579         for(uint256 i = 0; i < lenght; i ++) {
2580             owners[i] = warriorToOwner[_warriorIds[i]];
2581         }
2582     }
2583     
2584     
2585     function _setWarriorData(uint256[] memory warriorsData, DataTypes.Warrior storage warrior, uint256 id) internal view {
2586         warriorsData[id] = uint256(warrior.identity);//0
2587         warriorsData[id + 1] = uint256(warrior.cooldownEndBlock);//1
2588         warriorsData[id + 2] = uint256(warrior.level);//2
2589         warriorsData[id + 3] = uint256(warrior.rating);//3
2590         warriorsData[id + 4] = uint256(warrior.action);//4
2591         warriorsData[id + 5] = uint256(warrior.dungeonIndex);//5
2592     }
2593     
2594 	function getWarrior(uint256 _id) external view returns 
2595     (
2596         uint256 identity, 
2597         uint256 cooldownEndBlock, 
2598         uint256 level,
2599         uint256 rating, 
2600         uint256 action,
2601         uint256 dungeonIndex
2602     ) {
2603         DataTypes.Warrior storage warrior = warriors[_id];
2604 
2605         identity = uint256(warrior.identity);
2606         cooldownEndBlock = uint256(warrior.cooldownEndBlock);
2607         level = uint256(warrior.level);
2608 		rating = uint256(warrior.rating);
2609 		action = uint256(warrior.action);
2610 		dungeonIndex = uint256(warrior.dungeonIndex);
2611     }
2612     
2613 }
2614 
2615 /*  @title Handles creating pvp battles every 15 min.*/
2616 contract PVP is PausableBattle, PVPInterface {
2617 	/* PVP BATLE */
2618 	
2619     /** list of packed warrior data that will participate in next PVP session. 
2620      *  Fixed size arry, to evade constant remove and push operations,
2621      *  this approach reduces transaction costs involving queue modification. */
2622     uint256[100] public pvpQueue;
2623     //
2624     //queue size
2625     uint256 public pvpQueueSize = 0;
2626     
2627     // @dev A mapping from owner address to booty in WEI
2628     //  booty is acquired in PVP and Tournament battles and can be
2629     // withdrawn with grabBooty method by the owner of the loot
2630     mapping (address => uint256) public ownerToBooty;
2631     
2632     // @dev A mapping from warrior id to owners address
2633     mapping (uint256 => address) internal warriorToOwner;
2634     
2635     // An approximation of currently how many seconds are in between blocks.
2636     uint256 internal secondsPerBlock = 15;
2637     
2638     // Cut owner takes from, measured in basis points (1/100 of a percent).
2639     // Values 0-10,000 map to 0%-100%
2640     uint256 public pvpOwnerCut;
2641     
2642     // Values 0-10,000 map to 0%-100%
2643     //this % of the total bets will be sent as 
2644     //a reward to address, that triggered finishPVP method
2645     uint256 public pvpMaxIncentiveCut;
2646     
2647     /// @notice The payment base required to use startPVP().
2648     // pvpBattleFee * (warrior.level / POINTS_TO_LEVEL)
2649     uint256 internal pvpBattleFee = 10 finney;
2650     
2651     uint256 public constant PVP_INTERVAL = 15 minutes;
2652     
2653     uint256 public nextPVPBatleBlock = 0;
2654     //number of WEI in hands of warrior owners
2655     uint256 public totalBooty = 0;
2656     
2657     /* TOURNAMENT */
2658     uint256 public constant FUND_GATHERING_TIME = 24 hours;
2659     uint256 public constant ADMISSION_TIME = 12 hours;
2660     uint256 public constant RATING_EXPAND_INTERVAL = 1 hours;
2661     uint256 internal constant SAFETY_GAP = 5;
2662     
2663     uint256 internal constant MAX_INCENTIVE_REWARD = 200 finney;
2664     
2665     //tournamentContenders size
2666     uint256 public tournamentQueueSize = 0;
2667     
2668     // Values 0-10,000 map to 0%-100%
2669     uint256 public tournamentBankCut;
2670     
2671    /** tournamentEndBlock, tournament is eligible to be finished only
2672     *  after block.number >= tournamentEndBlock 
2673     *  it depends on FUND_GATHERING_TIME and ADMISSION_TIME */
2674     uint256 public tournamentEndBlock;
2675     
2676     //number of WEI in tournament bank
2677     uint256 public currentTournamentBank = 0;
2678     uint256 public nextTournamentBank = 0;
2679     
2680     PVPListenerInterface internal pvpListener;
2681     
2682     /* EVENTS */
2683     /** @dev TournamentScheduled event. Emitted every time a tournament is scheduled 
2684      *  @param tournamentEndBlock when block.number > tournamentEndBlock, then tournament 
2685      *         is eligible to be finished or rescheduled */
2686     event TournamentScheduled(uint256 tournamentEndBlock);
2687     
2688     /** @dev PVPScheduled event. Emitted every time a tournament is scheduled 
2689      *  @param nextPVPBatleBlock when block.number > nextPVPBatleBlock, then pvp battle 
2690      *         is eligible to be finished or rescheduled */
2691     event PVPScheduled(uint256 nextPVPBatleBlock);
2692     
2693     /** @dev PVPNewContender event. Emitted every time a warrior enqueues pvp battle
2694      *  @param owner Warrior owner
2695      *  @param warriorId Warrior ID that entered PVP queue
2696      *  @param entranceFee fee in WEI warrior owner payed to enter PVP
2697      */
2698     event PVPNewContender(address owner, uint256 warriorId, uint256 entranceFee);
2699 
2700     /** @dev PVPFinished event. Emitted every time a pvp battle is finished
2701      *  @param warriorsData array of pairs of pvp warriors packed to uint256, even => winners, odd => losers 
2702      *  @param owners array of warrior owners, 1 to 1 with warriorsData, even => winners, odd => losers 
2703      *  @param matchingCount total number of warriors that fought in current pvp session and got rewards,
2704      *  if matchingCount < participants.length then all IDs that are >= matchingCount will 
2705      *  remain in waiting room, until they are matched.
2706      */
2707     event PVPFinished(uint256[] warriorsData, address[] owners, uint256 matchingCount);
2708     
2709     /** @dev BootySendFailed event. Emitted every time address.send() function failed to transfer Ether to recipient
2710      *  in this case recipient Ether is recorded to ownerToBooty mapping, so recipient can withdraw their booty manually
2711      *  @param recipient address for whom send failed
2712      *  @param amount number of WEI we failed to send
2713      */
2714     event BootySendFailed(address recipient, uint256 amount);
2715     
2716     /** @dev BootyGrabbed event
2717      *  @param receiver address who grabbed his booty
2718      *  @param amount number of WEI
2719      */
2720     event BootyGrabbed(address receiver, uint256 amount);
2721     
2722     /** @dev PVPContenderRemoved event. Emitted every time warrior is removed from pvp queue by its owner.
2723      *  @param warriorId id of the removed warrior
2724      */
2725     event PVPContenderRemoved(uint256 warriorId, address owner);
2726     
2727     function PVP(uint256 _pvpCut, uint256 _tournamentBankCut, uint256 _pvpMaxIncentiveCut) public {
2728         require((_tournamentBankCut + _pvpCut + _pvpMaxIncentiveCut) <= 10000);
2729 		pvpOwnerCut = _pvpCut;
2730 		tournamentBankCut = _tournamentBankCut;
2731 		pvpMaxIncentiveCut = _pvpMaxIncentiveCut;
2732     }
2733     
2734     /** @dev grabBooty sends to message sender his booty in WEI
2735      */
2736     function grabBooty() external {
2737         uint256 booty = ownerToBooty[msg.sender];
2738         require(booty > 0);
2739         require(totalBooty >= booty);
2740         
2741         ownerToBooty[msg.sender] = 0;
2742         totalBooty -= booty;
2743         
2744         msg.sender.transfer(booty);
2745         //emit event
2746         BootyGrabbed(msg.sender, booty);
2747     }
2748     
2749     function safeSend(address _recipient, uint256 _amaunt) internal {
2750 		uint256 failedBooty = sendBooty(_recipient, _amaunt);
2751         if (failedBooty > 0) {
2752 			totalBooty += failedBooty;
2753         }
2754     }
2755     
2756     function sendBooty(address _recipient, uint256 _amaunt) internal returns(uint256) {
2757         bool success = _recipient.send(_amaunt);
2758         if (!success && _amaunt > 0) {
2759             ownerToBooty[_recipient] += _amaunt;
2760             BootySendFailed(_recipient, _amaunt);
2761             return _amaunt;
2762         }
2763         return 0;
2764     }
2765     
2766     //@returns block number, after this block tournament is opened for admission
2767     function getTournamentAdmissionBlock() public view returns(uint256) {
2768         uint256 admissionInterval = (ADMISSION_TIME / secondsPerBlock);
2769         return tournamentEndBlock < admissionInterval ? 0 : tournamentEndBlock - admissionInterval;
2770     }
2771     
2772     
2773     //schedules next turnament time(block)
2774     function _scheduleTournament() internal {
2775         //we can chedule only if there is nobody in tournament queue and
2776         //time of tournament battle have passed
2777 		if (tournamentQueueSize == 0 && tournamentEndBlock <= block.number) {
2778 		    tournamentEndBlock = ((FUND_GATHERING_TIME / 2 + ADMISSION_TIME) / secondsPerBlock) + block.number;
2779 		    TournamentScheduled(tournamentEndBlock);
2780 		}
2781     }
2782     
2783     /// @dev Updates the minimum payment required for calling startPVP(). Can only
2784     ///  be called by the COO address, and only if pvp queue is empty.
2785     function setPVPEntranceFee(uint256 value) external onlyOwner {
2786         require(pvpQueueSize == 0);
2787         pvpBattleFee = value;
2788     }
2789     
2790     //@returns PVP entrance fee for specified warrior level 
2791     //@param _levelPoints NB!
2792     function getPVPEntranceFee(uint256 _levelPoints) external view returns(uint256) {
2793         return pvpBattleFee * CryptoUtils._getLevel(_levelPoints);
2794     }
2795     
2796     //level can only be > 0 and <= 25
2797     function _getPVPFeeByLevel(uint256 _level) internal view returns(uint256) {
2798         return pvpBattleFee * _level;
2799     }
2800     
2801 	// @dev Computes warrior pvp reward
2802     // @param _totalBet - total bet from both competitors.
2803     function _computePVPReward(uint256 _totalBet, uint256 _contendersCut) internal pure returns (uint256){
2804         // NOTE: We don't use SafeMath (or similar) in this function because
2805         // _totalBet max value is 1000 finney, and _contendersCut aka
2806         // (10000 - pvpOwnerCut - tournamentBankCut - incentiveRewardCut) <= 10000 (see the require()
2807         // statement in the BattleProvider constructor). The result of this
2808         // function is always guaranteed to be <= _totalBet.
2809         return _totalBet * _contendersCut / 10000;
2810     }
2811     
2812     function _getPVPContendersCut(uint256 _incentiveCut) internal view returns (uint256) {
2813         // NOTE: We don't use SafeMath (or similar) in this function because
2814         // (pvpOwnerCut + tournamentBankCut + pvpMaxIncentiveCut) <= 10000 (see the require()
2815         // statement in the BattleProvider constructor). 
2816         // _incentiveCut is guaranteed to be >= 1 and <=  pvpMaxIncentiveCut
2817         return (10000 - pvpOwnerCut - tournamentBankCut - _incentiveCut);
2818     }
2819 	
2820 	// @dev Computes warrior pvp reward
2821     // @param _totalSessionLoot - total bets from all competitors.
2822     function _computeIncentiveReward(uint256 _totalSessionLoot, uint256 _incentiveCut) internal pure returns (uint256){
2823         // NOTE: We don't use SafeMath (or similar) in this function because
2824         // _totalSessionLoot max value is 37500 finney, and 
2825         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
2826         // statement in the BattleProvider constructor). The result of this
2827         // function is always guaranteed to be <= _totalSessionLoot.
2828         return _totalSessionLoot * _incentiveCut / 10000;
2829     }
2830     
2831 	///@dev computes incentive cut for specified loot, 
2832 	/// Values 0-10,000 map to 0%-100%
2833 	/// max incentive reward cut is 5%, if it exceeds MAX_INCENTIVE_REWARD,
2834 	/// then cut is lowered to be equal to MAX_INCENTIVE_REWARD.
2835 	/// minimum cut is 0.01%
2836     /// this % of the total bets will be sent as 
2837     /// a reward to address, that triggered finishPVP method
2838     function _computeIncentiveCut(uint256 _totalSessionLoot, uint256 maxIncentiveCut) internal pure returns(uint256) {
2839         uint256 result = _totalSessionLoot * maxIncentiveCut / 10000;
2840         result = result <= MAX_INCENTIVE_REWARD ? maxIncentiveCut : MAX_INCENTIVE_REWARD * 10000 / _totalSessionLoot;
2841         //min cut is 0.01%
2842         return result > 0 ? result : 1;
2843     }
2844     
2845     // @dev Computes warrior pvp reward
2846     // @param _totalSessionLoot - total bets from all competitors.
2847     function _computePVPBeneficiaryFee(uint256 _totalSessionLoot) internal view returns (uint256){
2848         // NOTE: We don't use SafeMath (or similar) in this function because
2849         // _totalSessionLoot max value is 37500 finney, and 
2850         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
2851         // statement in the BattleProvider constructor). The result of this
2852         // function is always guaranteed to be <= _totalSessionLoot.
2853         return _totalSessionLoot * pvpOwnerCut / 10000;
2854     }
2855     
2856     // @dev Computes tournament bank cut
2857     // @param _totalSessionLoot - total session loot.
2858     function _computeTournamentCut(uint256 _totalSessionLoot) internal view returns (uint256){
2859         // NOTE: We don't use SafeMath (or similar) in this function because
2860         // _totalSessionLoot max value is 37500 finney, and 
2861         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
2862         // statement in the BattleProvider constructor). The result of this
2863         // function is always guaranteed to be <= _totalSessionLoot.
2864         return _totalSessionLoot * tournamentBankCut / 10000;
2865     }
2866 
2867     function indexOf(uint256 _warriorId) internal view returns(int256) {
2868 	    uint256 length = uint256(pvpQueueSize);
2869 	    for(uint256 i = 0; i < length; i ++) {
2870 	        if(CryptoUtils._unpackIdValue(pvpQueue[i]) == _warriorId) return int256(i);
2871 	    }
2872 	    return -1;
2873 	}
2874     
2875     function getPVPIncentiveReward(uint256[] memory matchingIds, uint256 matchingCount) internal view returns(uint256) {
2876         uint256 sessionLoot = _computeTotalBooty(matchingIds, matchingCount);
2877         
2878         return _computeIncentiveReward(sessionLoot, _computeIncentiveCut(sessionLoot, pvpMaxIncentiveCut));
2879     }
2880     
2881     function maxPVPContenders() external view returns(uint256){
2882         return pvpQueue.length;
2883     }
2884     
2885     function getPVPState() external view returns
2886     (uint256 contendersCount, uint256 matchingCount, uint256 endBlock, uint256 incentiveReward)
2887     {
2888         uint256[] memory pvpData = _packPVPData();
2889         
2890     	contendersCount = pvpQueueSize;
2891     	matchingCount = CryptoUtils._getMatchingIds(pvpData, PVP_INTERVAL, _computeCycleSkip(), RATING_EXPAND_INTERVAL);
2892     	endBlock = nextPVPBatleBlock;   
2893     	incentiveReward = getPVPIncentiveReward(pvpData, matchingCount);
2894     }
2895     
2896     function canFinishPVP() external view returns(bool) {
2897         return nextPVPBatleBlock <= block.number &&
2898          CryptoUtils._getMatchingIds(_packPVPData(), PVP_INTERVAL, _computeCycleSkip(), RATING_EXPAND_INTERVAL) > 1;
2899     }
2900     
2901     function _clarifyPVPSchedule() internal {
2902         uint256 length = pvpQueueSize;
2903 		uint256 currentBlock = block.number;
2904 		uint256 nextBattleBlock = nextPVPBatleBlock;
2905 		//if battle not scheduled, schedule battle
2906 		if (nextBattleBlock <= currentBlock) {
2907 		    //if queue not empty update cycles
2908 		    if (length > 0) {
2909 				uint256 packedWarrior;
2910 				uint256 cycleSkip = _computeCycleSkip();
2911 		        for(uint256 i = 0; i < length; i++) {
2912 		            packedWarrior = pvpQueue[i];
2913 		            //increase warrior iteration cycle
2914 		            pvpQueue[i] = CryptoUtils._changeCycleValue(packedWarrior, CryptoUtils._unpackCycleValue(packedWarrior) + cycleSkip);
2915 		        }
2916 		    }
2917 		    nextBattleBlock = (PVP_INTERVAL / secondsPerBlock) + currentBlock;
2918 		    nextPVPBatleBlock = nextBattleBlock;
2919 		    PVPScheduled(nextBattleBlock);
2920 		//if pvp queue will be full and there is still too much time left, then let the battle begin! 
2921 		} else if (length + 1 == pvpQueue.length && (currentBlock + SAFETY_GAP * 2) < nextBattleBlock) {
2922 		    nextBattleBlock = currentBlock + SAFETY_GAP;
2923 		    nextPVPBatleBlock = nextBattleBlock;
2924 		    PVPScheduled(nextBattleBlock);
2925 		}
2926     }
2927     
2928     /// @dev Internal utility function to initiate pvp battle, assumes that all battle
2929     ///  requirements have been checked.
2930     function _triggerNewPVPContender(address _owner, uint256 _packedWarrior, uint256 fee) internal {
2931 
2932 		_clarifyPVPSchedule();
2933         //number of pvp cycles the warrior is waiting for suitable enemy match
2934         //increment every time when finishPVP is called and no suitable enemy match was found
2935         _packedWarrior = CryptoUtils._changeCycleValue(_packedWarrior, 0);
2936 		
2937 		//record contender data
2938 		pvpQueue[pvpQueueSize++] = _packedWarrior;
2939 		warriorToOwner[CryptoUtils._unpackIdValue(_packedWarrior)] = _owner;
2940 		
2941 		//Emit event
2942 		PVPNewContender(_owner, CryptoUtils._unpackIdValue(_packedWarrior), fee);
2943     }
2944     
2945     function _noMatchingPairs() internal view returns(bool) {
2946         uint256 matchingCount = CryptoUtils._getMatchingIds(_packPVPData(), uint64(PVP_INTERVAL), _computeCycleSkip(), uint64(RATING_EXPAND_INTERVAL));
2947         return matchingCount == 0;
2948     }
2949     
2950     /*
2951      * @title startPVP enqueues specified warrior to PVP
2952      * 
2953      * @dev When the owner enqueues his warrior for PvP, the warrior enters the waiting room.
2954      * Once every 15 minutes, we check the warriors in the room and select pairs. 
2955      * For those warriors to whom we found couples, fighting is conducted and the results 
2956      * are recorded in the profile of the warrior. 
2957      */
2958     function addPVPContender(address _owner, uint256 _packedWarrior) external payable PVPNotPaused {
2959 		// Caller must be pvpListener contract
2960         require(msg.sender == address(pvpListener));
2961 
2962         require(_owner != address(0));
2963         //contender can be added only while PVP is scheduled in future
2964         //or no matching warrior pairs found
2965         require(nextPVPBatleBlock > block.number || _noMatchingPairs());
2966         // Check that the warrior exists.
2967         require(_packedWarrior != 0);
2968         //owner must withdraw all loot before contending pvp
2969         require(ownerToBooty[_owner] == 0);
2970         //check that there is enough room for new participants
2971         require(pvpQueueSize < pvpQueue.length);
2972         // Checks for payment.
2973         uint256 fee = _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarrior));
2974         require(msg.value >= fee);
2975         //
2976         // All checks passed, put the warrior to the queue!
2977         _triggerNewPVPContender(_owner, _packedWarrior, fee);
2978     }
2979     
2980     function _packPVPData() internal view returns(uint256[] memory matchingIds) {
2981         uint256 length = pvpQueueSize;
2982         matchingIds = new uint256[](length);
2983         for(uint256 i = 0; i < length; i++) {
2984             matchingIds[i] = pvpQueue[i];
2985         }
2986         return matchingIds;
2987     }
2988     
2989     function _computeTotalBooty(uint256[] memory _packedWarriors, uint256 matchingCount) internal view returns(uint256) {
2990         //compute session booty
2991         uint256 sessionLoot = 0;
2992         for(uint256 i = 0; i < matchingCount; i++) {
2993             sessionLoot += _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarriors[i]));
2994         }
2995         return sessionLoot;
2996     }
2997     
2998     function _grandPVPRewards(uint256[] memory _packedWarriors, uint256 matchingCount) 
2999     internal returns(uint256)
3000     {
3001         uint256 booty = 0;
3002         uint256 packedWarrior;
3003         uint256 failedBooty = 0;
3004         
3005         uint256 sessionBooty = _computeTotalBooty(_packedWarriors, matchingCount);
3006         uint256 incentiveCut = _computeIncentiveCut(sessionBooty, pvpMaxIncentiveCut);
3007         uint256 contendersCut = _getPVPContendersCut(incentiveCut);
3008         
3009         for(uint256 id = 0; id < matchingCount; id++) {
3010             //give reward to warriors that fought hard
3011 			//winner, even ids are winners!
3012 			packedWarrior = _packedWarriors[id];
3013 			//
3014 			//give winner deserved booty 80% from both bets
3015 			//must be computed before level reward!
3016 			booty = _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(packedWarrior)) + 
3017 				_getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarriors[id + 1]));
3018 			
3019 			//
3020 			//send reward to warrior owner
3021 			failedBooty += sendBooty(warriorToOwner[CryptoUtils._unpackIdValue(packedWarrior)], _computePVPReward(booty, contendersCut));
3022 			//loser, they are odd...
3023 			//skip them, as they deserve none!
3024 			id ++;
3025         }
3026         failedBooty += sendBooty(pvpListener.getBeneficiary(), _computePVPBeneficiaryFee(sessionBooty));
3027         
3028         if (failedBooty > 0) {
3029             totalBooty += failedBooty;
3030         }
3031         //if tournament admission start time not passed
3032         //add tournament cut to current tournament bank,
3033         //otherwise to next tournament bank
3034         if (getTournamentAdmissionBlock() > block.number) {
3035             currentTournamentBank += _computeTournamentCut(sessionBooty);
3036         } else {
3037             nextTournamentBank += _computeTournamentCut(sessionBooty);
3038         }
3039         
3040         //compute incentive reward
3041         return _computeIncentiveReward(sessionBooty, incentiveCut);
3042     }
3043     
3044     function _increaseCycleAndTrimQueue(uint256[] memory matchingIds, uint256 matchingCount) internal {
3045         uint32 length = uint32(matchingIds.length - matchingCount);  
3046 		uint256 packedWarrior;
3047 		uint256 skipCycles = _computeCycleSkip();
3048         for(uint256 i = 0; i < length; i++) {
3049             packedWarrior = matchingIds[matchingCount + i];
3050             //increase warrior iteration cycle
3051             pvpQueue[i] = CryptoUtils._changeCycleValue(packedWarrior, CryptoUtils._unpackCycleValue(packedWarrior) + skipCycles);
3052         }
3053         //trim queue	
3054         pvpQueueSize = length;
3055     }
3056     
3057     function _computeCycleSkip() internal view returns(uint256) {
3058         uint256 number = block.number;
3059         return nextPVPBatleBlock > number ? 0 : (number - nextPVPBatleBlock) * secondsPerBlock / PVP_INTERVAL + 1;
3060     }
3061     
3062     function _getWarriorOwners(uint256[] memory pvpData) internal view returns (address[] memory owners){
3063         uint256 length = pvpData.length;
3064         owners = new address[](length);
3065         for(uint256 i = 0; i < length; i ++) {
3066             owners[i] = warriorToOwner[CryptoUtils._unpackIdValue(pvpData[i])];
3067         }
3068     }
3069     
3070     // @dev Internal utility function to initiate pvp battle, assumes that all battle
3071     ///  requirements have been checked.
3072     function _triggerPVPFinish(uint256[] memory pvpData, uint256 matchingCount) internal returns(uint256){
3073         //
3074 		//compute battle results        
3075         CryptoUtils._getPVPBattleResults(pvpData, matchingCount, nextPVPBatleBlock);
3076         //
3077         //mark not fought warriors and trim queue 
3078         _increaseCycleAndTrimQueue(pvpData, matchingCount);
3079         //
3080         //schedule next battle time
3081         nextPVPBatleBlock = (PVP_INTERVAL / secondsPerBlock) + block.number;
3082         
3083         //
3084         //schedule tournament
3085         //if contendersCount is 0 and tournament not scheduled, schedule tournament
3086         //NB MUST be before _grandPVPRewards()
3087         _scheduleTournament();
3088         // compute and grand rewards to warriors,
3089         // put tournament cut to bank, not susceptible to reentry attack because of require(nextPVPBatleBlock <= block.number);
3090         // and require(number of pairs > 1);
3091         uint256 incentiveReward = _grandPVPRewards(pvpData, matchingCount);
3092         //
3093         //notify pvp listener contract
3094         pvpListener.pvpFinished(pvpData, matchingCount);
3095         
3096         //
3097         //fire event
3098 		PVPFinished(pvpData, _getWarriorOwners(pvpData), matchingCount);
3099         PVPScheduled(nextPVPBatleBlock);
3100 		
3101 		return incentiveReward;
3102     }
3103     
3104     
3105     /**
3106      * @dev finishPVP this method finds matches of warrior pairs
3107      * in waiting room and computes result of their fights.
3108      * 
3109      * The winner gets +1 level, the loser gets +0.5 level
3110      * The winning player gets +130 rating
3111 	 * The losing player gets -30 or 70 rating (if warrior levelUps after battle) .
3112      * can be called once in 15min.
3113      * NB If the warrior is not picked up in an hour, then we expand the range 
3114      * of selection by 25 rating each hour.
3115      */
3116     function finishPVP() public PVPNotPaused {
3117         // battle interval is over
3118         require(nextPVPBatleBlock <= block.number);
3119         //
3120 	    //match warriors
3121         uint256[] memory pvpData = _packPVPData();
3122         //match ids and sort them according to matching
3123         uint256 matchingCount = CryptoUtils._getMatchingIds(pvpData, uint64(PVP_INTERVAL), _computeCycleSkip(), uint64(RATING_EXPAND_INTERVAL));
3124 		// we have at least 1 matching battle pair
3125         require(matchingCount > 1);
3126         
3127         // When the all checks done, calculate actual battle result
3128         uint256 incentiveReward = _triggerPVPFinish(pvpData, matchingCount);
3129         
3130         //give reward for incentive
3131         safeSend(msg.sender, incentiveReward);
3132     }
3133 
3134     // @dev Removes specified warrior from PVP queue
3135     //  sets warrior free (IDLE) and returns pvp entrance fee to owner
3136     // @notice This is a state-modifying function that can
3137     //  be called while the contract is paused.
3138     // @param _warriorId - ID of warrior in PVP queue
3139     function removePVPContender(uint256 _warriorId) external{
3140         uint256 queueSize = pvpQueueSize;
3141         require(queueSize > 0);
3142         // Caller must be owner of the specified warrior
3143         require(warriorToOwner[_warriorId] == msg.sender);
3144         //warrior must be in pvp queue
3145         int256 warriorIndex = indexOf(_warriorId);
3146         require(warriorIndex >= 0);
3147         //grab warrior data
3148         uint256 warriorData = pvpQueue[uint32(warriorIndex)];
3149         //warrior cycle must be >= 4 (> than 1 hour)
3150         require((CryptoUtils._unpackCycleValue(warriorData) + _computeCycleSkip()) >= 4);
3151         
3152         //remove from queue
3153         if (uint256(warriorIndex) < queueSize - 1) {
3154 	        pvpQueue[uint32(warriorIndex)] = pvpQueue[pvpQueueSize - 1];
3155         }
3156         pvpQueueSize --;
3157         //notify battle listener
3158         pvpListener.pvpContenderRemoved(_warriorId);
3159         //return pvp bet
3160         msg.sender.transfer(_getPVPFeeByLevel(CryptoUtils._unpackLevelValue(warriorData)));
3161         //Emit event
3162         PVPContenderRemoved(_warriorId, msg.sender);
3163     }
3164     
3165     function getPVPCycles(uint32[] warriorIds) external view returns(uint32[]){
3166         uint256 length = warriorIds.length;
3167         uint32[] memory cycles = new uint32[](length);
3168         int256 index;
3169         uint256 skipCycles = _computeCycleSkip();
3170 	    for(uint256 i = 0; i < length; i ++) {
3171 	        index = indexOf(warriorIds[i]);
3172 	        cycles[i] = index >= 0 ? uint32(CryptoUtils._unpackCycleValue(pvpQueue[uint32(index)]) + skipCycles) : 0;
3173 	    }
3174 	    return cycles;
3175     }
3176     
3177     // @dev Remove all PVP contenders from PVP queue 
3178     //  and return all bets to warrior owners.
3179     //  NB: this is emergency method, used only in f%#^@up situation
3180     function removeAllPVPContenders() external onlyOwner PVPPaused {
3181         //remove all pvp contenders
3182         uint256 length = pvpQueueSize;
3183         
3184         uint256 warriorData;
3185         uint256 warriorId;
3186         uint256 failedBooty;
3187         address owner;
3188         
3189         pvpQueueSize = 0;
3190         
3191         for(uint256 i = 0; i < length; i++) {
3192 	        //grab warrior data
3193 	        warriorData = pvpQueue[i];
3194 	        warriorId = CryptoUtils._unpackIdValue(warriorData);
3195 	        //notify battle listener
3196 	        pvpListener.pvpContenderRemoved(uint32(warriorId));
3197 	        
3198 	        owner = warriorToOwner[warriorId];
3199 	        //return pvp bet
3200 	        failedBooty += sendBooty(owner, _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(warriorData)));
3201         }
3202         totalBooty += failedBooty;
3203     }
3204 }
3205 
3206 
3207 contract Tournament is PVP {
3208 
3209     uint256 internal constant GROUP_SIZE = 5;
3210     uint256 internal constant DATA_SIZE = 2;
3211     uint256 internal constant THRESHOLD = 300;
3212     
3213   /** list of warrior IDs that will participate in next tournament. 
3214     *  Fixed size arry, to evade constant remove and push operations,
3215     *  this approach reduces transaction costs involving array modification. */
3216     uint256[160] public tournamentQueue;
3217     
3218     /**The cost of participation in the tournament is 1% of its current prize fund, 
3219      * money is added to the prize fund. measured in basis points (1/100 of a percent).
3220      * Values 0-10,000 map to 0%-100% */
3221     uint256 internal tournamentEntranceFeeCut = 100;
3222     
3223     // Values 0-10,000 map to 0%-100% => 20%
3224     uint256 public tournamentOwnersCut;
3225     uint256 public tournamentIncentiveCut;
3226     
3227      /** @dev TournamentNewContender event. Emitted every time a warrior enters tournament
3228      *  @param owner Warrior owner
3229      *  @param warriorIds 5 Warrior IDs that entered tournament, packed into one uint256
3230      *  see CryptoUtils._packWarriorIds
3231      */
3232     event TournamentNewContender(address owner, uint256 warriorIds, uint256 entranceFee);
3233     
3234     /** @dev TournamentFinished event. Emitted every time a tournament is finished
3235      *  @param owners array of warrior group owners packed to uint256
3236      *  @param results number of wins for each group
3237      *  @param tournamentBank current tournament bank
3238      *  see CryptoUtils._packWarriorIds
3239      */
3240     event TournamentFinished(uint256[] owners, uint32[] results, uint256 tournamentBank);
3241     
3242     function Tournament(uint256 _pvpCut, uint256 _tournamentBankCut, 
3243     uint256 _pvpMaxIncentiveCut, uint256 _tournamentOwnersCut, uint256 _tournamentIncentiveCut) public
3244     PVP(_pvpCut, _tournamentBankCut, _pvpMaxIncentiveCut) 
3245     {
3246         require((_tournamentOwnersCut + _tournamentIncentiveCut) <= 10000);
3247 		
3248 		tournamentOwnersCut = _tournamentOwnersCut;
3249 		tournamentIncentiveCut = _tournamentIncentiveCut;
3250     }
3251     
3252     
3253     
3254     // @dev Computes incentive reward for launching tournament finishTournament()
3255     // @param _tournamentBank
3256     function _computeTournamentIncentiveReward(uint256 _currentBank, uint256 _incentiveCut) internal pure returns (uint256){
3257         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
3258         // and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
3259         // statement in the Tournament constructor). The result of this
3260         // function is always guaranteed to be <= _currentBank.
3261         return _currentBank * _incentiveCut / 10000;
3262     }
3263     
3264     function _computeTournamentContenderCut(uint256 _incentiveCut) internal view returns (uint256) {
3265         // NOTE: (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
3266         // statement in the Tournament constructor). The result of this
3267         // function is always guaranteed to be <= _reward.
3268         return 10000 - tournamentOwnersCut - _incentiveCut;
3269     }
3270     
3271     function _computeTournamentBeneficiaryFee(uint256 _currentBank) internal view returns (uint256){
3272         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
3273         // and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
3274         // statement in the Tournament constructor). The result of this
3275         // function is always guaranteed to be <= _currentBank.
3276         return _currentBank * tournamentOwnersCut / 10000;
3277     }
3278     
3279     // @dev set tournament entrance fee cut, can be set only if
3280     // tournament queue is empty
3281     // @param _cut range from 0 - 10000, mapped to 0-100%
3282     function setTournamentEntranceFeeCut(uint256 _cut) external onlyOwner {
3283         //cut must be less or equal 100&
3284         require(_cut <= 10000);
3285         //tournament queue must be empty
3286         require(tournamentQueueSize == 0);
3287         //checks passed, set cut
3288 		tournamentEntranceFeeCut = _cut;
3289     }
3290     
3291     function getTournamentEntranceFee() external view returns(uint256) {
3292         return currentTournamentBank * tournamentEntranceFeeCut / 10000;
3293     }
3294     
3295     //@dev returns tournament entrance fee - 3% threshold
3296     function getTournamentThresholdFee() public view returns(uint256) {
3297         return currentTournamentBank * tournamentEntranceFeeCut * (10000 - THRESHOLD) / 10000 / 10000;
3298     }
3299     
3300     //@dev returns max allowed tournament contenders, public because of internal use
3301     function maxTournamentContenders() public view returns(uint256){
3302         return tournamentQueue.length / DATA_SIZE;
3303     }
3304     
3305     function canFinishTournament() external view returns(bool) {
3306         return tournamentEndBlock <= block.number && tournamentQueueSize > 0;
3307     }
3308     
3309     // @dev Internal utility function to sigin up to tournament, 
3310     // assumes that all battle requirements have been checked.
3311     function _triggerNewTournamentContender(address _owner, uint256[] memory _tournamentData, uint256 _fee) internal {
3312         //pack warrior ids into uint256
3313         
3314         currentTournamentBank += _fee;
3315         
3316         uint256 packedWarriorIds = CryptoUtils._packWarriorIds(_tournamentData);
3317         //make composite warrior out of 5 warriors 
3318         uint256 combinedWarrior = CryptoUtils._combineWarriors(_tournamentData);
3319         
3320         //add to queue
3321         //icrement tournament queue
3322         uint256 size = tournamentQueueSize++ * DATA_SIZE;
3323         //record tournament data
3324 		tournamentQueue[size++] = packedWarriorIds;
3325 		tournamentQueue[size++] = combinedWarrior;
3326 		warriorToOwner[CryptoUtils._unpackWarriorId(packedWarriorIds, 0)] = _owner;
3327 		//
3328 		//Emit event
3329 		TournamentNewContender(_owner, packedWarriorIds, _fee);
3330     }
3331     
3332     function addTournamentContender(address _owner, uint256[] _tournamentData) external payable TournamentNotPaused{
3333         // Caller must be pvpListener contract
3334         require(msg.sender == address(pvpListener));
3335         
3336         require(_owner != address(0));
3337         //
3338         //check current tournament bank > 0
3339         require(pvpBattleFee == 0 || currentTournamentBank > 0);
3340         //
3341         //check that there is enough funds to pay entrance fee
3342         uint256 fee = getTournamentThresholdFee();
3343         require(msg.value >= fee);
3344         //owner must withdraw all booty before contending pvp
3345         require(ownerToBooty[_owner] == 0);
3346         //
3347         //check that warriors group is exactly of allowed size
3348         require(_tournamentData.length == GROUP_SIZE);
3349         //
3350         //check that there is enough room for new participants
3351         require(tournamentQueueSize < maxTournamentContenders());
3352         //
3353         //check that admission started
3354         require(block.number >= getTournamentAdmissionBlock());
3355         //check that admission not ended
3356         require(block.number <= tournamentEndBlock);
3357         
3358         //all checks passed, trigger sign up
3359         _triggerNewTournamentContender(_owner, _tournamentData, fee);
3360     }
3361     
3362     //@dev collect all combined warriors data
3363     function getCombinedWarriors() internal view returns(uint256[] memory warriorsData) {
3364         uint256 length = tournamentQueueSize;
3365         warriorsData = new uint256[](length);
3366         
3367         for(uint256 i = 0; i < length; i ++) {
3368             // Grab the combined warrior data in storage.
3369             warriorsData[i] = tournamentQueue[i * DATA_SIZE + 1];
3370         }
3371         return warriorsData;
3372     }
3373     
3374     function getTournamentState() external view returns
3375     (uint256 contendersCount, uint256 bank, uint256 admissionStartBlock, uint256 endBlock, uint256 incentiveReward)
3376     {
3377     	contendersCount = tournamentQueueSize;
3378     	bank = currentTournamentBank;
3379     	admissionStartBlock = getTournamentAdmissionBlock();   
3380     	endBlock = tournamentEndBlock;
3381     	incentiveReward = _computeTournamentIncentiveReward(bank, _computeIncentiveCut(bank, tournamentIncentiveCut));
3382     }
3383     
3384     function _repackToCombinedIds(uint256[] memory _warriorsData) internal view {
3385         uint256 length = _warriorsData.length;
3386         for(uint256 i = 0; i < length; i ++) {
3387             _warriorsData[i] = tournamentQueue[i * DATA_SIZE];
3388         }
3389     }
3390     
3391     // @dev Computes warrior pvp reward
3392     // @param _totalBet - total bet from both competitors.
3393     function _computeTournamentBooty(uint256 _currentBank, uint256 _contenderResult, uint256 _totalBattles) internal pure returns (uint256){
3394         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
3395         // _totalBattles is guaranteed to be > 0 and <= 400, and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
3396         // statement in the Tournament constructor). The result of this
3397         // function is always guaranteed to be <= _reward.
3398         // return _currentBank * (10000 - tournamentOwnersCut - _incentiveCut) * _result / 10000 / _totalBattles;
3399         return _currentBank * _contenderResult / _totalBattles;
3400         
3401     }
3402     
3403     function _grandTournamentBooty(uint256 _warriorIds, uint256 _currentBank, uint256 _contenderResult, uint256 _totalBattles)
3404     internal returns (uint256)
3405     {
3406         uint256 warriorId = CryptoUtils._unpackWarriorId(_warriorIds, 0);
3407         address owner = warriorToOwner[warriorId];
3408         uint256 booty = _computeTournamentBooty(_currentBank, _contenderResult, _totalBattles);
3409         return sendBooty(owner, booty);
3410     }
3411     
3412     function _grandTournamentRewards(uint256 _currentBank, uint256[] memory _warriorsData, uint32[] memory _results) internal returns (uint256){
3413         uint256 length = _warriorsData.length;
3414         uint256 totalBattles = CryptoUtils._getTournamentBattles(length) * 10000;//*10000 required for booty computation
3415         uint256 incentiveCut = _computeIncentiveCut(_currentBank, tournamentIncentiveCut);
3416         uint256 contenderCut = _computeTournamentContenderCut(incentiveCut);
3417         
3418         uint256 failedBooty = 0;
3419         for(uint256 i = 0; i < length; i ++) {
3420             //grand rewards
3421             failedBooty += _grandTournamentBooty(_warriorsData[i], _currentBank, _results[i] * contenderCut, totalBattles);
3422         }
3423         //send beneficiary fee
3424         failedBooty += sendBooty(pvpListener.getBeneficiary(), _computeTournamentBeneficiaryFee(_currentBank));
3425         if (failedBooty > 0) {
3426             totalBooty += failedBooty;
3427         }
3428         return _computeTournamentIncentiveReward(_currentBank, incentiveCut);
3429     }
3430     
3431     function _repackToWarriorOwners(uint256[] memory warriorsData) internal view {
3432         uint256 length = warriorsData.length;
3433         for (uint256 i = 0; i < length; i ++) {
3434             warriorsData[i] = uint256(warriorToOwner[CryptoUtils._unpackWarriorId(warriorsData[i], 0)]);
3435         }
3436     }
3437     
3438     function _triggerFinishTournament() internal returns(uint256){
3439         //hold 10 random battles for each composite warrior
3440         uint256[] memory warriorsData = getCombinedWarriors();
3441         uint32[] memory results = CryptoUtils.getTournamentBattleResults(warriorsData, tournamentEndBlock - 1);
3442         //repack combined warriors id
3443         _repackToCombinedIds(warriorsData);
3444         //notify pvp listener
3445         pvpListener.tournamentFinished(warriorsData);
3446         //reschedule
3447         //clear tournament
3448         tournamentQueueSize = 0;
3449         //schedule new tournament
3450         _scheduleTournament();
3451         
3452         uint256 currentBank = currentTournamentBank;
3453         currentTournamentBank = 0;//nullify before sending to users
3454         //grand rewards, not susceptible to reentry attack
3455         //because of require(tournamentEndBlock <= block.number)
3456         //and require(tournamentQueueSize > 0) and currentTournamentBank == 0
3457         uint256 incentiveReward = _grandTournamentRewards(currentBank, warriorsData, results);
3458         
3459         currentTournamentBank = nextTournamentBank;
3460         nextTournamentBank = 0;
3461         
3462         _repackToWarriorOwners(warriorsData);
3463         
3464         //emit event
3465         TournamentFinished(warriorsData, results, currentBank);
3466 
3467         return incentiveReward;
3468     }
3469     
3470     function finishTournament() external TournamentNotPaused {
3471         //make all the checks
3472         // tournament is ready to be executed
3473         require(tournamentEndBlock <= block.number);
3474         // we have participants
3475         require(tournamentQueueSize > 0);
3476         
3477         uint256 incentiveReward = _triggerFinishTournament();
3478         
3479         //give reward for incentive
3480         safeSend(msg.sender, incentiveReward);
3481     }
3482     
3483     
3484     // @dev Remove all PVP contenders from PVP queue 
3485     //  and return all entrance fees to warrior owners.
3486     //  NB: this is emergency method, used only in f%#^@up situation
3487     function removeAllTournamentContenders() external onlyOwner TournamentPaused {
3488         //remove all pvp contenders
3489         uint256 length = tournamentQueueSize;
3490         
3491         uint256 warriorId;
3492         uint256 failedBooty;
3493         uint256 i;
3494 
3495         uint256 fee;
3496         uint256 bank = currentTournamentBank;
3497         
3498         uint256[] memory warriorsData = new uint256[](length);
3499         //get tournament warriors
3500         for(i = 0; i < length; i ++) {
3501             warriorsData[i] = tournamentQueue[i * DATA_SIZE];
3502         }
3503         //notify pvp listener
3504         pvpListener.tournamentFinished(warriorsData);
3505         //return entrance fee to warrior owners
3506      	currentTournamentBank = 0;
3507         tournamentQueueSize = 0;
3508 
3509         for(i = length - 1; i >= 0; i --) {
3510             //return entrance fee
3511             warriorId = CryptoUtils._unpackWarriorId(warriorsData[i], 0);
3512             //compute contender entrance fee
3513 			fee = bank - (bank * 10000 / (tournamentEntranceFeeCut * (10000 - THRESHOLD) / 10000 + 10000));
3514 			//return entrance fee to owner
3515 	        failedBooty += sendBooty(warriorToOwner[warriorId], fee);
3516 	        //subtract fee from bank, for next use
3517 	        bank -= fee;
3518         }
3519         currentTournamentBank = bank;
3520         totalBooty += failedBooty;
3521     }
3522 }
3523 
3524 contract BattleProvider is Tournament {
3525     
3526     function BattleProvider(address _pvpListener, uint256 _pvpCut, uint256 _tournamentCut, uint256 _incentiveCut, 
3527     uint256 _tournamentOwnersCut, uint256 _tournamentIncentiveCut) public 
3528     Tournament(_pvpCut, _tournamentCut, _incentiveCut, _tournamentOwnersCut, _tournamentIncentiveCut) 
3529     {
3530         PVPListenerInterface candidateContract = PVPListenerInterface(_pvpListener);
3531         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
3532         require(candidateContract.isPVPListener());
3533         // Set the new contract address
3534         pvpListener = candidateContract;
3535         
3536         // the creator of the contract is the initial owner
3537         owner = msg.sender;
3538     }
3539     
3540     
3541     // @dev Sanity check that allows us to ensure that we are pointing to the
3542     // right BattleProvider in our setBattleProviderAddress() call.
3543     function isPVPProvider() external pure returns (bool) {
3544         return true;
3545     }
3546     
3547     function setSecondsPerBlock(uint256 secs) external onlyOwner {
3548         secondsPerBlock = secs;
3549     }
3550 }
3551 
3552 
3553 /* warrior identity generator*/
3554 contract WarriorGenerator is Pausable, SanctuaryInterface {
3555     
3556     CryptoWarriorCore public coreContract;
3557     
3558     /* LIMITS */
3559     uint32[19] public parameters;/*  = [
3560         uint32(10),//0_bodyColorMax3
3561         uint32(10),//1_eyeshMax4
3562         uint32(10),//2_mouthMax5
3563         uint32(20),//3_heirMax6
3564         uint32(10),//4_heirColorMax7
3565         uint32(3),//5_armorMax8
3566         uint32(3),//6_weaponMax9
3567         uint32(3),//7_hatMax10
3568         uint32(4),//8_runesMax11
3569         uint32(1),//9_wingsMax12
3570         uint32(10),//10_petMax13
3571         uint32(6),//11_borderMax14
3572         uint32(6),//12_backgroundMax15
3573         uint32(10),//13_unique
3574         uint32(900),//14_legendary
3575         uint32(9000),//15_mythic
3576         uint32(90000),//16_rare
3577         uint32(900000),//17_uncommon
3578         uint32(0)//18_uniqueTotal
3579     ];*/
3580     
3581 
3582     function changeParameter(uint32 _paramIndex, uint32 _value) external onlyOwner {
3583         CryptoUtils._changeParameter(_paramIndex, _value, parameters);
3584     }
3585 
3586     // / @dev simply a boolean to indicate this is the contract we expect to be
3587     function isSanctuary() public pure returns (bool){
3588         return true;
3589     }
3590 
3591     // / @dev generate new warrior identity
3592     // / @param _heroIdentity Genes of warrior that invoked resurrection, if 0 => Demigod gene that signals to generate unique warrior
3593     // / @param _heroLevel Level of the warrior
3594     // / @_targetBlock block number from which hash will be taken
3595     // / @_perkId special perk id, like MINER(1)
3596     // / @return the identity that are supposed to be passed down to newly arisen warrior
3597     function generateWarrior(uint256 _heroIdentity, uint256 _heroLevel, uint256 _targetBlock, uint256 _perkId) 
3598     public returns (uint256) 
3599     {
3600         //only core contract can call this method
3601         require(msg.sender == address(coreContract));
3602         
3603         return _generateIdentity(_heroIdentity, _heroLevel, _targetBlock, _perkId);
3604     }
3605     
3606     function _generateIdentity(uint256 _heroIdentity, uint256 _heroLevel, uint256 _targetBlock, uint256 _perkId) internal returns(uint256){
3607         
3608         //get memory copy, to reduce storage read requests
3609         uint32[19] memory memoryParams = parameters;
3610         //generate warrior identity
3611         uint256 identity = CryptoUtils.generateWarrior(_heroIdentity, _heroLevel, _targetBlock, _perkId, memoryParams);
3612         
3613         //validate before pushing changes to storage
3614         CryptoUtils._validateIdentity(identity, memoryParams);
3615         //push changes to storage
3616         CryptoUtils._recordWarriorData(identity, parameters);
3617         
3618         return identity;
3619     }
3620 }
3621 
3622 contract WarriorSanctuary is WarriorGenerator {
3623     uint256 internal constant SUMMONING_SICKENESS = 12 hours;
3624     uint256 internal constant RITUAL_DURATION = 15 minutes;
3625     /// @notice The payment required to use startRitual().
3626     uint256 public ritualFee = 10 finney;
3627     
3628     uint256 public constant RITUAL_COMPENSATION = 2 finney;
3629     
3630     mapping(address => uint256) public soulCounter;
3631     //
3632     mapping(address => uint256) public ritualTimeBlock;
3633     
3634     bool public recoveryAllowed = true;
3635     
3636     event WarriorBurned(uint256 warriorId, address owner);
3637     event RitualStarted(address owner, uint256 numberOfSouls);
3638     event RitualFinished(address owner, uint256 numberOfSouls, uint256 newWarriorId);
3639     
3640     
3641     function WarriorSanctuary(address _coreContract, uint32[] _settings) public {
3642         uint256 length = _settings.length;
3643         require(length == 18);
3644         require(_settings[8] == 4);//check runes max
3645         require(_settings[10] == 10);//check pets max
3646         require(_settings[11] == 5);//check border max
3647         require(_settings[12] == 6);//check background max
3648         //setup parameters
3649         for(uint256 i = 0; i < length; i ++) {
3650             parameters[i] = _settings[i];
3651         }	
3652         
3653         //set core
3654         CryptoWarriorCore coreCondidat = CryptoWarriorCore(_coreContract);
3655         require(coreCondidat.isPVPListener());
3656         coreContract = coreCondidat;
3657         
3658     }
3659     
3660     function recoverSouls(address[] owners, uint256[] souls, uint256[] blocks) external onlyOwner {
3661         require(recoveryAllowed);
3662         
3663         uint256 length = owners.length;
3664         require(length == souls.length && length == blocks.length);
3665         
3666         for(uint256 i = 0; i < length; i ++) {
3667             soulCounter[owners[i]] = souls[i];
3668             ritualTimeBlock[owners[i]] = blocks[i];
3669         }
3670         
3671         recoveryAllowed = false;
3672     }
3673     
3674     
3675     //burn warrior
3676     function burnWarrior(uint256 _warriorId) whenNotPaused external {
3677         coreContract.burnWarrior(_warriorId, msg.sender);
3678         
3679         soulCounter[msg.sender] ++;
3680         
3681         WarriorBurned(_warriorId, msg.sender);
3682     }
3683    
3684     
3685     function startRitual() whenNotPaused external payable {
3686         // Checks for payment.
3687         require(msg.value >= ritualFee);
3688         
3689         uint256 souls = soulCounter[msg.sender];
3690         // Check that address has at least 10 burned souls
3691         require(souls >= 10);
3692         //
3693         //Check that no rituals are in progress
3694         require(ritualTimeBlock[msg.sender] == 0);
3695         
3696         ritualTimeBlock[msg.sender] = RITUAL_DURATION / coreContract.secondsPerBlock() + block.number;
3697         
3698         // Calculate any excess funds included in msg.value. If the excess
3699         // is anything worth worrying about, transfer it back to message owner.
3700         // NOTE: We checked above that the msg.value is greater than or
3701         // equal to the price so this cannot underflow.
3702         uint256 feeExcess = msg.value - ritualFee;
3703 
3704         // Return the funds. This is not susceptible 
3705         // to a re-entry attack because of _isReadyToPVE check
3706         // will fail
3707         if (feeExcess > 0) {
3708             msg.sender.transfer(feeExcess);
3709         }
3710         //send battle fee to beneficiary
3711         coreContract.getBeneficiary().transfer(ritualFee - RITUAL_COMPENSATION);
3712         
3713         RitualStarted(msg.sender, souls);
3714     }
3715     
3716     
3717     //arise warrior
3718     function finishRitual(address _owner) whenNotPaused external {
3719         // Check ritual time is over
3720         uint256 timeBlock = ritualTimeBlock[_owner];
3721         require(timeBlock > 0 && timeBlock <= block.number);
3722         
3723         uint256 souls = soulCounter[_owner];
3724         
3725         require(souls >= 10);
3726         
3727         uint256 identity = _generateIdentity(uint256(_owner), souls, timeBlock - 1, 0);
3728         
3729         uint256 warriorId = coreContract.ariseWarrior(identity, _owner, block.number + (SUMMONING_SICKENESS / coreContract.secondsPerBlock()));
3730     
3731         soulCounter[_owner] = 0;
3732         ritualTimeBlock[_owner] = 0;
3733         //send compensation
3734         msg.sender.transfer(RITUAL_COMPENSATION);
3735         
3736         RitualFinished(_owner, 10, warriorId);
3737     }
3738     
3739     function setRitualFee(uint256 _pveRitualFee) external onlyOwner {
3740         require(_pveRitualFee > RITUAL_COMPENSATION);
3741         ritualFee = _pveRitualFee;
3742     }
3743 }
3744 
3745 contract AuctionBase {
3746 	uint256 public constant PRICE_CHANGE_TIME_STEP = 15 minutes;
3747     //
3748     struct Auction{
3749         address seller;
3750         uint128 startingPrice;
3751         uint128 endingPrice;
3752         uint64 duration;
3753         uint64 startedAt;
3754     }
3755     mapping (uint256 => Auction) internal tokenIdToAuction;
3756     uint256 public ownerCut;
3757     ERC721 public nonFungibleContract;
3758 
3759     event AuctionCreated(uint256 tokenId, address seller, uint256 startingPrice);
3760 
3761     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner, address seller);
3762 
3763     event AuctionCancelled(uint256 tokenId, address seller);
3764 
3765     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
3766         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
3767     }
3768 
3769     function _escrow(address _owner, uint256 _tokenId) internal{
3770         nonFungibleContract.transferFrom(_owner, address(this), _tokenId);
3771     }
3772 
3773     function _transfer(address _receiver, uint256 _tokenId) internal{
3774         nonFungibleContract.transfer(_receiver, _tokenId);
3775     }
3776 
3777     function _addAuction(uint256 _tokenId, Auction _auction) internal{
3778         require(_auction.duration >= 1 minutes);
3779         
3780         tokenIdToAuction[_tokenId] = _auction;
3781         
3782         AuctionCreated(uint256(_tokenId), _auction.seller, _auction.startingPrice);
3783     }
3784 
3785     function _cancelAuction(uint256 _tokenId, address _seller) internal{
3786         _removeAuction(_tokenId);
3787         
3788         _transfer(_seller, _tokenId);
3789         
3790         AuctionCancelled(_tokenId, _seller);
3791     }
3792 
3793     function _bid(uint256 _tokenId, uint256 _bidAmount) internal returns (uint256){
3794         
3795         Auction storage auction = tokenIdToAuction[_tokenId];
3796         
3797         require(_isOnAuction(auction));
3798         
3799         uint256 price = _currentPrice(auction);
3800         
3801         require(_bidAmount >= price);
3802         
3803         address seller = auction.seller;
3804         
3805         _removeAuction(_tokenId);
3806         
3807         if (price > 0) {
3808             uint256 auctioneerCut = _computeCut(price);
3809             uint256 sellerProceeds = price - auctioneerCut;
3810             seller.transfer(sellerProceeds);
3811             nonFungibleContract.getBeneficiary().transfer(auctioneerCut);
3812         }
3813         
3814         uint256 bidExcess = _bidAmount - price;
3815         
3816         msg.sender.transfer(bidExcess);
3817         
3818         AuctionSuccessful(_tokenId, price, msg.sender, seller);
3819         
3820         return price;
3821     }
3822 
3823     function _removeAuction(uint256 _tokenId) internal{
3824         delete tokenIdToAuction[_tokenId];
3825     }
3826 
3827     function _isOnAuction(Auction storage _auction) internal view returns (bool){
3828         return (_auction.startedAt > 0);
3829     }
3830 
3831     function _currentPrice(Auction storage _auction)
3832         internal
3833         view
3834         returns (uint256){
3835         uint256 secondsPassed = 0;
3836         
3837         if (now > _auction.startedAt) {
3838             secondsPassed = now - _auction.startedAt;
3839         }
3840         
3841         return _computeCurrentPrice(_auction.startingPrice,
3842             _auction.endingPrice,
3843             _auction.duration,
3844             secondsPassed);
3845     }
3846     
3847     function _computeCurrentPrice(uint256 _startingPrice,
3848         uint256 _endingPrice,
3849         uint256 _duration,
3850         uint256 _secondsPassed)
3851         internal
3852         pure
3853         returns (uint256){
3854         if (_secondsPassed >= _duration) {
3855             return _endingPrice;
3856         } else {
3857             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
3858             
3859             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed / PRICE_CHANGE_TIME_STEP * PRICE_CHANGE_TIME_STEP) / int256(_duration);
3860             
3861             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
3862             
3863             return uint256(currentPrice);
3864         }
3865     }
3866 
3867     function _computeCut(uint256 _price) internal view returns (uint256){
3868         
3869         return _price * ownerCut / 10000;
3870     }
3871 }
3872 
3873 contract SaleClockAuction is Pausable, AuctionBase {
3874     
3875     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9f40b779);
3876     
3877     bool public isSaleClockAuction = true;
3878     uint256 public minerSaleCount;
3879     uint256[5] public lastMinerSalePrices;
3880 
3881     function SaleClockAuction(address _nftAddress, uint256 _cut) public{
3882         require(_cut <= 10000);
3883         ownerCut = _cut;
3884         ERC721 candidateContract = ERC721(_nftAddress);
3885         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
3886         require(candidateContract.getBeneficiary() != address(0));
3887         
3888         nonFungibleContract = candidateContract;
3889     }
3890 
3891     function cancelAuction(uint256 _tokenId)
3892         external{
3893         
3894         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3895         
3896         require(_isOnAuction(auction));
3897         
3898         address seller = auction.seller;
3899         
3900         require(msg.sender == seller);
3901         
3902         _cancelAuction(_tokenId, seller);
3903     }
3904 
3905     function cancelAuctionWhenPaused(uint256 _tokenId)
3906         whenPaused
3907         onlyOwner
3908         external{
3909         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3910         require(_isOnAuction(auction));
3911         _cancelAuction(_tokenId, auction.seller);
3912     }
3913 
3914     function getCurrentPrice(uint256 _tokenId)
3915         external
3916         view
3917         returns (uint256){
3918         
3919         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3920         
3921         require(_isOnAuction(auction));
3922         
3923         return _currentPrice(auction);
3924     }
3925     
3926     function createAuction(uint256 _tokenId,
3927         uint256 _startingPrice,
3928         uint256 _endingPrice,
3929         uint256 _duration,
3930         address _seller)
3931         whenNotPaused
3932         external{
3933         require(_startingPrice == uint256(uint128(_startingPrice)));
3934         require(_endingPrice == uint256(uint128(_endingPrice)));
3935         require(_duration == uint256(uint64(_duration)));
3936         require(msg.sender == address(nonFungibleContract));
3937         _escrow(_seller, _tokenId);
3938         
3939         AuctionBase.Auction memory auction = Auction(_seller,
3940             uint128(_startingPrice),
3941             uint128(_endingPrice),
3942             uint64(_duration),
3943             uint64(now));
3944         
3945         _addAuction(_tokenId, auction);
3946     }
3947     
3948     function bid(uint256 _tokenId)
3949         whenNotPaused
3950         external
3951         payable{
3952         
3953         address seller = tokenIdToAuction[_tokenId].seller;
3954         
3955         uint256 price = _bid(_tokenId, msg.value);
3956         
3957         _transfer(msg.sender, _tokenId);
3958         
3959         if (seller == nonFungibleContract.getBeneficiary()) {
3960             lastMinerSalePrices[minerSaleCount % 5] = price;
3961             minerSaleCount++;
3962         }
3963     }
3964 
3965     function averageMinerSalePrice() external view returns (uint256){
3966         uint256 sum = 0;
3967         for (uint256 i = 0; i < 5; i++){
3968             sum += lastMinerSalePrices[i];
3969         }
3970         return sum / 5;
3971     }
3972     
3973     /**getAuctionsById returns packed actions data
3974      * @param tokenIds ids of tokens, whose auction's must be active 
3975      * @return auctionData as uint256 array
3976      * @return stepSize number of fields describing auction 
3977      */
3978     function getAuctionsById(uint32[] tokenIds) external view returns(uint256[] memory auctionData, uint32 stepSize) {
3979         stepSize = 6;
3980         auctionData = new uint256[](tokenIds.length * stepSize);
3981         
3982         uint32 tokenId;
3983         for(uint32 i = 0; i < tokenIds.length; i ++) {
3984             tokenId = tokenIds[i];
3985             AuctionBase.Auction storage auction = tokenIdToAuction[tokenId];
3986             require(_isOnAuction(auction));
3987             _setTokenData(auctionData, auction, tokenId, i * stepSize);
3988         }
3989     }
3990     
3991     /**getAuctions returns packed actions data
3992      * @param fromIndex warrior index from global warrior storage (aka warriorId)
3993      * @param count Number of auction's to find, if count == 0, then exact warriorId(fromIndex) will be searched
3994      * @return auctionData as uint256 array
3995      * @return stepSize number of fields describing auction 
3996      */
3997     function getAuctions(uint32 fromIndex, uint32 count) external view returns(uint256[] memory auctionData, uint32 stepSize) {
3998         stepSize = 6;
3999         if (count == 0) {
4000             AuctionBase.Auction storage auction = tokenIdToAuction[fromIndex];
4001 	        	require(_isOnAuction(auction));
4002 	        	auctionData = new uint256[](1 * stepSize);
4003 	        	_setTokenData(auctionData, auction, fromIndex, count);
4004 	        	return (auctionData, stepSize);
4005         } else {
4006             uint256 totalWarriors = nonFungibleContract.totalSupply();
4007 	        if (totalWarriors == 0) {
4008 	            // Return an empty array
4009 	            return (new uint256[](0), stepSize);
4010 	        } else {
4011 	
4012 	            uint32 totalSize = 0;
4013 	            uint32 tokenId;
4014 	            uint32 size = 0;
4015 				auctionData = new uint256[](count * stepSize);
4016 	            for (tokenId = 0; tokenId < totalWarriors && size < count; tokenId++) {
4017 	                AuctionBase.Auction storage auction1 = tokenIdToAuction[tokenId];
4018 	        
4019 		        		if (_isOnAuction(auction1)) {
4020 		        		    totalSize ++;
4021 		        		    if (totalSize > fromIndex) {
4022 		        		        _setTokenData(auctionData, auction1, tokenId, size++ * stepSize);//warriorId;
4023 		        		    }
4024 		        		}
4025 	            }
4026 	            
4027 	            if (size < count) {
4028 	                size *= stepSize;
4029 	                uint256[] memory repack = new uint256[](size);
4030 	                for(tokenId = 0; tokenId < size; tokenId++) {
4031 	                    repack[tokenId] = auctionData[tokenId];
4032 	                }
4033 	                return (repack, stepSize);
4034 	            }
4035 	
4036 	            return (auctionData, stepSize);
4037 	        }
4038         }
4039     }
4040     
4041     // @dev Returns auction info for an NFT on auction.
4042     // @param _tokenId - ID of NFT on auction.
4043     function getAuction(uint256 _tokenId) external view returns(
4044         address seller,
4045         uint256 startingPrice,
4046         uint256 endingPrice,
4047         uint256 duration,
4048         uint256 startedAt
4049         ){
4050         
4051         Auction storage auction = tokenIdToAuction[_tokenId];
4052         
4053         require(_isOnAuction(auction));
4054         
4055         return (auction.seller,
4056             auction.startingPrice,
4057             auction.endingPrice,
4058             auction.duration,
4059             auction.startedAt);
4060     }
4061     
4062     //pack NFT data into specified array
4063     function _setTokenData(uint256[] memory auctionData, 
4064         AuctionBase.Auction storage auction, uint32 tokenId, uint32 index
4065     ) internal view {
4066         auctionData[index] = uint256(tokenId);//0
4067         auctionData[index + 1] = uint256(auction.seller);//1
4068         auctionData[index + 2] = uint256(auction.startingPrice);//2
4069         auctionData[index + 3] = uint256(auction.endingPrice);//3
4070         auctionData[index + 4] = uint256(auction.duration);//4
4071         auctionData[index + 5] = uint256(auction.startedAt);//5
4072     }
4073     
4074 }