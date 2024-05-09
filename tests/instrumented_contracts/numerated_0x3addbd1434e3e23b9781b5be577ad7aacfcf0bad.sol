1 pragma solidity ^0.4.19;
2 
3 
4 contract ERC721 {
5     // Required methods
6     function totalSupply() public view returns (uint256 total);
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     function ownerOf(uint256 _tokenId) external view returns (address owner);
9     function approve(address _to, uint256 _tokenId) external;
10     function transfer(address _to, uint256 _tokenId) external;
11     function transferFrom(address _from, address _to, uint256 _tokenId) external;
12 
13     // Events
14     event Transfer(address from, address to, uint256 tokenId);
15     event Approval(address owner, address approved, uint256 tokenId);
16 
17     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
18     function getBeneficiary() external view returns(address);
19 }
20 
21 contract GeneratorInterface {
22 
23     function isGenerator() public pure returns (bool);
24 
25     /// @dev generate new warrior genes
26     /// @param _heroGenes Genes of warrior that have completed dungeon
27     /// @param _heroLevel Level of the warrior
28     /// @return the genes that are supposed to be passed down to newly arisen warrior
29     function generateWarrior(uint256 _heroGenes, uint256 _heroLevel, uint256 _targetBlock, uint256 _perkId) public returns (uint256);
30 }
31 
32 contract PVPInterface {
33 
34     function isPVPProvider() external pure returns (bool);
35     
36     function addTournamentContender(address _owner, uint256[] _tournamentData) external payable;
37     function getTournamentThresholdFee() public view returns(uint256);
38     
39     function addPVPContender(address _owner, uint256 _packedWarrior) external payable;
40     function getPVPEntranceFee(uint256 _levelPoints) external view returns(uint256);
41 }
42 
43 contract PVPListenerInterface {
44 
45     function isPVPListener() public pure returns (bool);
46     function getBeneficiary() external view returns(address);
47     
48     function pvpFinished(uint256[] warriorData, uint256 matchingCount) public;
49     function pvpContenderRemoved(uint32 _warriorId) public;
50     function tournamentFinished(uint256[] packedContenders) public;
51 }
52 
53 // - The Admin: The Admin performs administrative functions, such as pause, unpause, change dependent contracts
54 // contracts.
55 //
56 // - The Bank: the beneficiary of all contracts
57 //
58 // - The Issuer: The Issuer can release miner warriors to auction.
59 contract PermissionControll {
60 
61     event ContractUpgrade(address newContract);
62     
63     address public newContractAddress;
64 
65     address public adminAddress;
66     address public bankAddress;
67     address public issuerAddress; 
68 
69     bool public paused = false;
70     
71 
72     modifier onlyAdmin(){
73         require(msg.sender == adminAddress);
74         _;
75     }
76 
77     modifier onlyBank(){
78         require(msg.sender == bankAddress);
79         _;
80     }
81     
82     modifier onlyIssuer(){
83     		require(msg.sender == issuerAddress);
84         _;
85     }
86     
87     modifier onlyAuthorized(){
88         require(msg.sender == issuerAddress ||
89             msg.sender == adminAddress ||
90             msg.sender == bankAddress);
91         _;
92     }
93 
94 
95     function setBank(address _newBank) external onlyBank {
96         require(_newBank != address(0));
97         bankAddress = _newBank;
98     }
99 
100     function setAdmin(address _newAdmin) external {
101         require(msg.sender == adminAddress || msg.sender == bankAddress);
102         require(_newAdmin != address(0));
103         adminAddress = _newAdmin;
104     }
105     
106     function setIssuer(address _newIssuer) external onlyAdmin{
107         require(_newIssuer != address(0));
108         issuerAddress = _newIssuer;
109     }
110 
111     modifier whenNotPaused(){
112         require(!paused);
113         _;
114     }
115 
116 
117     modifier whenPaused{
118         require(paused);
119         _;
120     }
121 
122     function pause() external onlyAuthorized whenNotPaused{
123         paused = true;
124     }
125 
126     function unpause() public onlyAdmin whenPaused{
127         paused = false;
128     }
129     
130 
131     function setNewAddress(address _v2Address) external onlyAdmin whenPaused {
132         newContractAddress = _v2Address;
133         ContractUpgrade(_v2Address);
134     }
135 }
136 
137 contract Ownable {
138     address public owner;
139 
140     /**
141      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
142      * account.
143      */
144     function Ownable() public{
145         owner = msg.sender;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner(){
152         require(msg.sender == owner);
153         _;
154     }
155 
156     /**
157      * @dev Allows the current owner to transfer control of the contract to a newOwner.
158      * @param newOwner The address to transfer ownership to.
159      */
160     function transferOwnership(address newOwner) public onlyOwner{
161         if (newOwner != address(0)) {
162             owner = newOwner;
163         }
164     }
165 }
166 
167 contract Pausable is Ownable {
168     event Pause();
169 
170     event Unpause();
171 
172     bool public paused = false;
173 
174     /**
175      * @dev modifier to allow actions only when the contract IS paused
176      */
177     modifier whenNotPaused(){
178         require(!paused);
179         _;
180     }
181 
182     /**
183      * @dev modifier to allow actions only when the contract IS NOT paused
184      */
185     modifier whenPaused{
186         require(paused);
187         _;
188     }
189 
190     /**
191      * @dev called by the owner to pause, triggers stopped state
192      */
193     function pause() public onlyOwner whenNotPaused {
194         paused = true;
195         Pause();
196     }
197 
198     /**
199      * @dev called by the owner to unpause, returns to normal state
200      */
201     function unpause() public onlyOwner whenPaused {
202         paused = false;
203         Unpause();
204     }
205 }
206 
207 
208 library DataTypes {
209 
210     struct Warrior{
211         // The Warrior's identity code is packed into these 256-bits
212         uint256 identity;
213         
214         uint64 cooldownEndBlock;
215         /** every warriors starts from 1 lv (10 level points per level) */
216         uint64 level;
217         /** PVP rating, every warrior starts with 100 rating */
218         int64 rating;
219         // 0 - idle
220         uint32 action;
221         /** Set to the index in the levelRequirements array (see CryptoWarriorBase.levelRequirements) that represents
222          *  the current dungeon level requirement for warrior. This starts at zero. */
223         uint32 dungeonIndex;
224     }
225 }
226 
227 contract CryptoWarriorBase is PermissionControll, PVPListenerInterface {
228 
229 
230     /// @dev The Arise event is fired when a new warrior created.
231     event Arise(address owner, uint256 warriorId, uint256 identity);
232 
233     /// @dev ERC721 Transfer event
234     event Transfer(address from, address to, uint256 tokenId);
235 
236     /*** CONSTANTS ***/
237     
238 	uint256 public constant IDLE = 0;
239     uint256 public constant PVE_BATTLE = 1;
240     uint256 public constant PVP_BATTLE = 2;
241     uint256 public constant TOURNAMENT_BATTLE = 3;
242     
243     //max pve dungeon level
244     uint256 public constant MAX_LEVEL = 25;
245     //how many points is needed to get 1 level
246     uint256 public constant POINTS_TO_LEVEL = 10;
247     
248     /// @dev Array contains PVE dungeon level requirements, each time warrior
249     /// completes dungeon, next level requirement is set, until 25lv (250points) is reached.
250     uint32[6] public dungeonRequirements = [
251         uint32(10),
252         uint32(30),
253         uint32(60),
254         uint32(100),
255         uint32(150),
256         uint32(250)
257     ];
258 
259     uint256 public secondsPerBlock = 15;
260 
261     /*** STORAGE ***/
262 
263     /// @dev An array of warrior tokens
264     DataTypes.Warrior[] warriors;
265 
266     /// @dev A mapping of warrior id to owner address
267     mapping (uint256 => address) public warriorToOwner;
268 
269     // @dev A mapping from owner address to warriors count
270     mapping (address => uint256) ownersTokenCount;
271 
272     /// @dev A mapping from warror id to approved address, that have permission to transfer specified warrior
273     mapping (uint256 => address) public warriorToApproved;
274 
275     SaleClockAuction public saleAuction;
276     
277     
278     /// @dev Assigns ownership of a specific warrior to an address.
279     function _transfer(address _from, address _to, uint256 _tokenId) internal {
280         // Since the number of warriors is capped to '1 000 000' we can't overflow this
281         ownersTokenCount[_to]++;
282         // transfer ownership
283         warriorToOwner[_tokenId] = _to;
284         // When creating new warriors _from is 0x0, but we can't account that address.
285         if (_from != address(0)) {
286             ownersTokenCount[_from]--;
287             // clear any previously approved ownership exchange
288             delete warriorToApproved[_tokenId];
289         }
290         // Emit the transfer event.
291         Transfer(_from, _to, _tokenId);
292     }
293 
294     /// @param _identity The warrior's genetic code.
295     /// @param _owner The initial owner of this warrior, must be non-zero
296     /// @param _cooldown pve cooldown block number
297     function _createWarrior(uint256 _identity, address _owner, uint256 _cooldown)
298         internal
299         returns (uint256) {
300         	    
301         DataTypes.Warrior memory _warrior = DataTypes.Warrior({
302             identity : _identity,
303             cooldownEndBlock : uint64(_cooldown),
304             level : uint64(10),
305             rating : int64(100),
306             action : uint32(IDLE),
307             dungeonIndex : uint32(0)
308         });
309         uint256 newWarriorId = warriors.push(_warrior) - 1;
310         
311         require(newWarriorId == uint256(uint32(newWarriorId)));
312         
313         // emit the arise event
314         Arise(_owner, newWarriorId, _identity);
315         
316         // emit the Transfer event
317         _transfer(0, _owner, newWarriorId);
318 
319         return newWarriorId;
320     }
321     
322 
323     function setSecondsPerBlock(uint256 secs) external onlyAuthorized {
324         secondsPerBlock = secs;
325     }
326 }
327 
328 contract WarriorTokenImpl is CryptoWarriorBase, ERC721 {
329 
330     string public constant name = "CryptoWarriors";
331     string public constant symbol = "CW";
332 
333     bytes4 constant InterfaceSignature_ERC165 =
334         bytes4(keccak256('supportsInterface(bytes4)'));
335 
336     bytes4 constant InterfaceSignature_ERC721 =
337         bytes4(keccak256('name()')) ^
338         bytes4(keccak256('symbol()')) ^
339         bytes4(keccak256('totalSupply()')) ^
340         bytes4(keccak256('balanceOf(address)')) ^
341         bytes4(keccak256('ownerOf(uint256)')) ^
342         bytes4(keccak256('approve(address,uint256)')) ^
343         bytes4(keccak256('transfer(address,uint256)')) ^
344         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
345         bytes4(keccak256('tokensOfOwner(address)'));
346 
347     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
348     {
349         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
350     }
351 
352     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
353         return warriorToOwner[_tokenId] == _claimant;    
354     }
355 
356     function _ownerApproved(address _claimant, uint256 _tokenId) internal view returns (bool) {
357         return warriorToOwner[_tokenId] == _claimant && warriorToApproved[_tokenId] == address(0);    
358     }
359 
360     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
361         return warriorToApproved[_tokenId] == _claimant;
362     }
363 
364     function _approve(uint256 _tokenId, address _approved) internal {
365         warriorToApproved[_tokenId] = _approved;
366     }
367 	
368 	/// @notice ERC-721 method.
369     function balanceOf(address _owner) public view returns (uint256 count) {
370         return ownersTokenCount[_owner];
371     }
372 
373 	/// @notice ERC-721 method.
374     function transfer(address _to, uint256 _tokenId) external whenNotPaused {
375         //sanity check
376         require(_to != address(0));
377         //can't transfer to core contract
378         require(_to != address(this));
379         //can't transfer to auction contract
380         require(_to != address(saleAuction));
381 
382         // You can only send your own warrior.
383         require(_owns(msg.sender, _tokenId));
384         // Only idle warriors are allowed 
385         require(warriors[_tokenId].action == IDLE);
386 
387         // actually transfer warrior
388         _transfer(msg.sender, _to, _tokenId);
389     }
390 
391 	/// @notice ERC-721 method.
392     function approve(address _to, uint256 _tokenId) external whenNotPaused {
393         // Only owner can approve
394         require(_owns(msg.sender, _tokenId));
395         // Only idle warriors are allowed 
396         require(warriors[_tokenId].action == IDLE);
397 
398         // actually approve
399         _approve(_tokenId, _to);
400 
401         // Emit event.
402         Approval(msg.sender, _to, _tokenId);
403     }
404 
405 	/// @notice ERC-721 method.
406     function transferFrom(address _from, address _to, uint256 _tokenId)
407         external
408         whenNotPaused
409     {
410         // Sanity check
411         require(_to != address(0));
412         // Disallow transfers to this contract to prevent accidental misuse.
413         // The contract should never own any warriors (except very briefly
414         // after a miner warrior is created and before it goes on auction).
415         require(_to != address(this));
416         // Check for approval and valid ownership
417         require(_approvedFor(msg.sender, _tokenId));
418         require(_owns(_from, _tokenId));
419         // Only idle warriors are allowed 
420         require(warriors[_tokenId].action == IDLE);
421 
422         // Reassign ownership (also clears pending approvals and emits Transfer event).
423         _transfer(_from, _to, _tokenId);
424     }
425 
426     /// @notice ERC-721 method.
427     function totalSupply() public view returns (uint256) {
428         return warriors.length;
429     }
430 
431     /// @notice ERC-721 method.
432     function ownerOf(uint256 _tokenId)
433         external
434         view
435         returns (address owner)
436     {
437         owner = warriorToOwner[_tokenId];
438 
439         require(owner != address(0));
440     }
441 
442     /// @notice ERC-721 method.
443     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
444         uint256 tokenCount = balanceOf(_owner);
445 
446         if (tokenCount == 0) {
447             return new uint256[](0);
448         } else {
449             uint256[] memory result = new uint256[](tokenCount);
450             uint256 totalWarriors = totalSupply();
451             uint256 resultIndex = 0;
452 
453             uint256 warriorId;
454 
455             for (warriorId = 0; warriorId < totalWarriors; warriorId++) {
456                 if (warriorToOwner[warriorId] == _owner) {
457                     result[resultIndex] = warriorId;
458                     resultIndex++;
459                 }
460             }
461 
462             return result;
463         }
464     }
465 
466 }
467 
468 contract CryptoWarriorPVE is WarriorTokenImpl {
469     
470     uint256 internal constant SUMMONING_SICKENESS = 12;
471     
472     uint256 internal constant PVE_COOLDOWN = 1 hours;
473     uint256 internal constant PVE_DURATION = 15 minutes;
474     
475     
476     /// @notice The payment required to use startPVEBattle().
477     uint256 public pveBattleFee = 10 finney;
478     uint256 public constant PVE_COMPENSATION = 2 finney;
479     
480 	/// @dev The address of contract that is used to implement warrior generation algorithm.
481     GeneratorInterface public generator;
482 
483     /** @dev PVEStarted event. Emitted every time a warrior enters pve battle
484      *  @param owner Warrior owner
485      *  @param dungeonIndex Started dungeon index 
486      *  @param warriorId Warrior ID that started PVE dungeon
487      *  @param battleEndBlock Block number, when started PVE dungeon will be completed
488      */
489     event PVEStarted(address owner, uint256 dungeonIndex, uint256 warriorId, uint256 battleEndBlock);
490 
491     /** @dev PVEFinished event. Emitted every time a warrior finishes pve battle
492      *  @param owner Warrior owner
493      *  @param dungeonIndex Finished dungeon index
494      *  @param warriorId Warrior ID that completed dungeon
495      *  @param cooldownEndBlock Block number, when cooldown on PVE battle entrance will be over
496      *  @param rewardId Warrior ID which was granted to the owner as battle reward
497      */
498     event PVEFinished(address owner, uint256 dungeonIndex, uint256 warriorId, uint256 cooldownEndBlock, uint256 rewardId);
499 
500 	/// @dev Update the address of the generator contract, can only be called by the Admin.
501     /// @param _address An address of a Generator contract instance to be used from this point forward.
502     function setGeneratorAddress(address _address) external onlyAdmin {
503         GeneratorInterface candidateContract = GeneratorInterface(_address);
504 
505         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
506         require(candidateContract.isGenerator());
507 
508         // Set the new contract address
509         generator = candidateContract;
510     }
511     
512     function areUnique(uint32[] memory _warriorIds) internal pure returns(bool) {
513    	    uint256 length = _warriorIds.length;
514    	    uint256 j;
515         for(uint256 i = 0; i < length; i++) {
516 	        for(j = i + 1; j < length; j++) {
517 	            if (_warriorIds[i] == _warriorIds[j]) return false;
518 	        }
519         }
520         return true; 
521    	}
522 
523     /// @dev Updates the minimum payment required for calling startPVE(). Can only
524     ///  be called by the admin address.
525     function setPVEBattleFee(uint256 _pveBattleFee) external onlyAdmin {
526         require(_pveBattleFee > PVE_COMPENSATION);
527         pveBattleFee = _pveBattleFee;
528     }
529     
530     /** @dev Returns PVE cooldown, after each battle, the warrior receives a 
531      *  cooldown on the next entrance to the battle, cooldown depends on current warrior level,
532      *  which is multiplied by 1h. Special case: after receiving 25 lv, the cooldwon will be 14 days.
533      *  @param _levelPoints warrior level */
534     function getPVECooldown(uint256 _levelPoints) public pure returns (uint256) {
535         uint256 level = CryptoUtils._getLevel(_levelPoints);
536         if (level >= MAX_LEVEL) return (14 * 24 * PVE_COOLDOWN);//14 days
537         return (PVE_COOLDOWN * level);
538     }
539 
540     /** @dev Returns PVE duration, each battle have a duration, which depends on current warrior level,
541      *  which is multiplied by 15 min. At the end of the duration, warrior is becoming eligible to receive
542      *  battle reward (new warrior in shiny armor)
543      *  @param _levelPoints warrior level points 
544      */
545     function getPVEDuration(uint256 _levelPoints) public pure returns (uint256) {
546         return CryptoUtils._getLevel(_levelPoints) * PVE_DURATION;
547     }
548     
549     /// @dev Checks that a given warrior can participate in PVE battle. Requires that the
550     ///  current cooldown is finished and also checks that warrior is idle (does not participate in any action)
551     ///  and dungeon level requirement is satisfied
552     function _isReadyToPVE(DataTypes.Warrior _warrior) internal view returns (bool) {
553         return (_warrior.action == IDLE) && //is idle
554         (_warrior.cooldownEndBlock <= uint64(block.number)) && //no cooldown
555         (_warrior.level >= dungeonRequirements[_warrior.dungeonIndex]);//dungeon level requirement is satisfied
556     }
557     
558     /// @dev Internal utility function to initiate pve battle, assumes that all battle
559     ///  requirements have been checked.
560     function _triggerPVEStart(uint256 _warriorId) internal {
561         // Grab a reference to the warrior from storage.
562         DataTypes.Warrior storage warrior = warriors[_warriorId];
563         // Set warrior current action to pve battle
564         warrior.action = uint16(PVE_BATTLE);
565         // Set battle duration
566         warrior.cooldownEndBlock = uint64((getPVEDuration(warrior.level) / secondsPerBlock) + block.number);
567         // Emit the pve battle start event.
568         PVEStarted(msg.sender, warrior.dungeonIndex, _warriorId, warrior.cooldownEndBlock);
569     }
570     
571     /// @dev Starts PVE battle for specified warrior, 
572     /// after battle, warrior owner will receive reward (Warrior) 
573     /// @param _warriorId A Warrior ready to PVE battle.
574     function startPVE(uint256 _warriorId) external payable whenNotPaused {
575 		// Checks for payment.
576         require(msg.value >= pveBattleFee);
577 		
578 		// Caller must own the warrior.
579         require(_ownerApproved(msg.sender, _warriorId));
580 
581         // Grab a reference to the warrior in storage.
582         DataTypes.Warrior storage warrior = warriors[_warriorId];
583 
584         // Check that the warrior exists.
585         require(warrior.identity != 0);
586 
587         // Check that the warrior is ready to battle
588         require(_isReadyToPVE(warrior));
589         
590         // All checks passed, let the battle begin!
591         _triggerPVEStart(_warriorId);
592         
593         // Calculate any excess funds included in msg.value. If the excess
594         // is anything worth worrying about, transfer it back to message owner.
595         // NOTE: We checked above that the msg.value is greater than or
596         // equal to the price so this cannot underflow.
597         uint256 feeExcess = msg.value - pveBattleFee;
598 
599         // Return the funds. This is not susceptible 
600         // to a re-entry attack because of _isReadyToPVE check
601         // will fail
602         msg.sender.transfer(feeExcess);
603         //send battle fee to beneficiary
604         bankAddress.transfer(pveBattleFee - PVE_COMPENSATION);
605     }
606     
607     function _ariseWarrior(address _owner, DataTypes.Warrior storage _warrior) internal returns(uint256) {
608         uint256 identity = generator.generateWarrior(_warrior.identity, CryptoUtils._getLevel(_warrior.level), _warrior.cooldownEndBlock - 1, 0);
609         return _createWarrior(identity, _owner, block.number + (PVE_COOLDOWN * SUMMONING_SICKENESS / secondsPerBlock));
610     }
611 
612 	/// @dev Internal utility function to finish pve battle, assumes that all battle
613     ///  finish requirements have been checked.
614     function _triggerPVEFinish(uint256 _warriorId) internal {
615         // Grab a reference to the warrior in storage.
616         DataTypes.Warrior storage warrior = warriors[_warriorId];
617         
618         // Set warrior current action to idle
619         warrior.action = uint16(IDLE);
620         
621         // Compute an estimation of the cooldown time in blocks (based on current level).
622         // and miner perc also reduces cooldown time by 4 times
623         warrior.cooldownEndBlock = uint64((getPVECooldown(warrior.level) / 
624             CryptoUtils._getBonus(warrior.identity) / secondsPerBlock) + block.number);
625         
626         // cash completed dungeon index before increment
627         uint32 dungeonIndex = warrior.dungeonIndex;
628         // Increment the dungeon index, clamping it at 6, which is the length of the
629         // dungeonRequirements array. We could check the array size dynamically, but hard-coding
630         // this as a constant saves gas.
631         if (dungeonIndex < 6) {
632             warrior.dungeonIndex += 1;
633         }
634         
635         address owner = warriorToOwner[_warriorId];
636         // generate reward
637         uint256 arisenWarriorId = _ariseWarrior(owner, warrior);
638         //Emit event
639         PVEFinished(owner, dungeonIndex, _warriorId, warrior.cooldownEndBlock, arisenWarriorId);
640     }
641     
642     /**
643      * @dev finishPVE can be called after battle time is over,
644      * if checks are passed then battle result is computed,
645      * and new warrior is awarded to owner of specified _warriord ID.
646      * NB anyone can call this method, if they willing to pay the gas price
647      */
648     function finishPVE(uint32 _warriorId) external whenNotPaused {
649         // Grab a reference to the warrior in storage.
650         DataTypes.Warrior storage warrior = warriors[_warriorId];
651         
652         // Check that the warrior exists.
653         require(warrior.identity != 0);
654         
655         // Check that warrior participated in PVE battle action
656         require(warrior.action == PVE_BATTLE);
657         
658         // And the battle time is over
659         require(warrior.cooldownEndBlock <= uint64(block.number));
660         
661         // When the all checks done, calculate actual battle result
662         _triggerPVEFinish(_warriorId);
663         
664         //not susceptible to reetrance attack because of require(warrior.action == PVE_BATTLE)
665         //and require(warrior.cooldownEndBlock <= uint64(block.number));
666         msg.sender.transfer(PVE_COMPENSATION);
667     }
668     
669     /**
670      * @dev finishPVEBatch same as finishPVE but for multiple warrior ids.
671      * NB anyone can call this method, if they willing to pay the gas price
672      */
673     function finishPVEBatch(uint32[] _warriorIds) external whenNotPaused {
674         uint256 length = _warriorIds.length;
675         //check max number of bach finish pve
676         require(length <= 20);
677         uint256 blockNumber = block.number;
678         uint256 index;
679         //all warrior ids must be unique
680         require(areUnique(_warriorIds));
681         //check prerequisites
682         for(index = 0; index < length; index ++) {
683             DataTypes.Warrior storage warrior = warriors[_warriorIds[index]];
684 			require(
685 		        // Check that the warrior exists.
686 			    warrior.identity != 0 &&
687 		        // Check that warrior participated in PVE battle action
688 			    warrior.action == PVE_BATTLE &&
689 		        // And the battle time is over
690 			    warrior.cooldownEndBlock <= blockNumber
691 			);
692         }
693         // When the all checks done, calculate actual battle result
694         for(index = 0; index < length; index ++) {
695             _triggerPVEFinish(_warriorIds[index]);
696         }
697         
698         //not susceptible to reetrance attack because of require(warrior.action == PVE_BATTLE)
699         //and require(warrior.cooldownEndBlock <= uint64(block.number));
700         msg.sender.transfer(PVE_COMPENSATION * length);
701     }
702 }
703 
704 contract CryptoWarriorPVP is CryptoWarriorPVE {
705 	
706 	PVPInterface public battleProvider;
707 	
708 	/// @dev Sets the reference to the sale auction.
709     /// @param _address - Address of sale contract.
710     function setBattleProviderAddress(address _address) external onlyAdmin {
711         PVPInterface candidateContract = PVPInterface(_address);
712 
713         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
714         require(candidateContract.isPVPProvider());
715 
716         // Set the new contract address
717         battleProvider = candidateContract;
718     }
719     
720     function _packPVPData(uint256 _warriorId, DataTypes.Warrior storage warrior) internal view returns(uint256){
721         return CryptoUtils._packWarriorPvpData(warrior.identity, uint256(warrior.rating), 0, _warriorId, warrior.level);
722     }
723     
724     function _triggerPVPSignUp(uint32 _warriorId, uint256 fee) internal {
725         DataTypes.Warrior storage warrior = warriors[_warriorId];
726     		
727 		uint256 packedWarrior = _packPVPData(_warriorId, warrior);
728         
729         // addPVPContender will throw if fee fails.
730         battleProvider.addPVPContender.value(fee)(msg.sender, packedWarrior);
731         
732         warrior.action = uint16(PVP_BATTLE);
733     }
734     
735     /*
736      * @title signUpForPVP enqueues specified warrior to PVP
737      * 
738      * @dev When the owner enqueues his warrior for PvP, the warrior enters the waiting room.
739      * Once every 15 minutes, we check the warriors in the room and select pairs. 
740      * For those warriors to whom we found couples, fighting is conducted and the results 
741      * are recorded in the profile of the warrior. 
742      */
743     function signUpForPVP(uint32 _warriorId) public payable whenNotPaused {//done
744 		// Caller must own the warrior.
745         require(_ownerApproved(msg.sender, _warriorId));
746         // Grab a reference to the warrior in storage.
747         DataTypes.Warrior storage warrior = warriors[_warriorId];
748         // sanity check
749         require(warrior.identity != 0);
750 
751         // Check that the warrior is ready to battle
752         require(warrior.action == IDLE);
753         
754         // Define the current price of the auction.
755         uint256 fee = battleProvider.getPVPEntranceFee(warrior.level);
756         
757         // Checks for payment.
758         require(msg.value >= fee);
759         
760         // All checks passed, put the warrior to the queue!
761         _triggerPVPSignUp(_warriorId, fee);
762         
763         // Calculate any excess funds included in msg.value. If the excess
764         // is anything worth worrying about, transfer it back to message owner.
765         // NOTE: We checked above that the msg.value is greater than or
766         // equal to the price so this cannot underflow.
767         uint256 feeExcess = msg.value - fee;
768 
769         // Return the funds. This is not susceptible 
770         // to a re-entry attack because of warrior.action == IDLE check
771         // will fail
772         msg.sender.transfer(feeExcess);
773     }
774 
775     function _grandPVPWinnerReward(uint256 _warriorId) internal {
776         DataTypes.Warrior storage warrior = warriors[_warriorId];
777         // reward 1 level, add 10 level points
778         uint256 level = warrior.level;
779         if (level < (MAX_LEVEL * POINTS_TO_LEVEL)) {
780             level = level + POINTS_TO_LEVEL;
781 			warrior.level = uint64(level > (MAX_LEVEL * POINTS_TO_LEVEL) ? (MAX_LEVEL * POINTS_TO_LEVEL) : level);
782         }
783 		// give 100 rating for levelUp and 30 for win
784 		warrior.rating += 130;
785 		// mark warrior idle, so it can participate
786 		// in another actions
787 		warrior.action = uint16(IDLE);
788     }
789 
790     function _grandPVPLoserReward(uint256 _warriorId) internal {
791         DataTypes.Warrior storage warrior = warriors[_warriorId];
792 		// reward 0.5 level
793 		uint256 oldLevel = warrior.level;
794 		uint256 level = oldLevel;
795 		if (level < (MAX_LEVEL * POINTS_TO_LEVEL)) {
796             level += (POINTS_TO_LEVEL / 2);
797 			warrior.level = uint64(level);
798         }
799 		// give 100 rating for levelUp if happens and -30 for lose
800 		int256 newRating = warrior.rating + (CryptoUtils._getLevel(level) > CryptoUtils._getLevel(oldLevel) ? int256(100 - 30) : int256(-30));
801 		// rating can't be less than 0 and more than 1000000000
802 	    warrior.rating = int64((newRating >= 0) ? (newRating > 1000000000 ? 1000000000 : newRating) : 0);
803         // mark warrior idle, so it can participate
804 		// in another actions
805 	    warrior.action = uint16(IDLE);
806     }
807     
808     function _grandPVPRewards(uint256[] memory warriorsData, uint256 matchingCount) internal {
809         for(uint256 id = 0; id < matchingCount; id += 2){
810             //
811             // winner, even ids are winners!
812             _grandPVPWinnerReward(CryptoUtils._unpackIdValue(warriorsData[id]));
813             //
814             // loser, they are odd...
815             _grandPVPLoserReward(CryptoUtils._unpackIdValue(warriorsData[id + 1]));
816         }
817 	}
818 
819     // @dev Internal utility function to initiate pvp battle, assumes that all battle
820     ///  requirements have been checked.
821     function pvpFinished(uint256[] warriorsData, uint256 matchingCount) public {
822         //this method can be invoked only by battleProvider contract
823         require(msg.sender == address(battleProvider));
824         
825         _grandPVPRewards(warriorsData, matchingCount);
826     }
827     
828     function pvpContenderRemoved(uint32 _warriorId) public {
829         //this method can be invoked only by battleProvider contract
830         require(msg.sender == address(battleProvider));
831         //grab warrior storage reference
832         DataTypes.Warrior storage warrior = warriors[_warriorId];
833         //specified warrior must be in pvp state
834         require(warrior.action == PVP_BATTLE);
835         //all checks done
836         //set warrior state to IDLE
837         warrior.action = uint16(IDLE);
838     }
839 }
840 
841 contract CryptoWarriorTournament is CryptoWarriorPVP {
842     
843     uint256 internal constant GROUP_SIZE = 5;
844     
845     function _ownsAll(address _claimant, uint32[] memory _warriorIds) internal view returns (bool) {
846         uint256 length = _warriorIds.length;
847         for(uint256 i = 0; i < length; i++) {
848             if (!_ownerApproved(_claimant, _warriorIds[i])) return false;
849         }
850         return true;    
851     }
852     
853     function _isReadyToTournament(DataTypes.Warrior storage _warrior) internal view returns(bool){
854         return _warrior.level >= 50 && _warrior.action == IDLE;//must not participate in any action
855     }
856     
857     function _packTournamentData(uint32[] memory _warriorIds) internal view returns(uint256[] memory tournamentData) {
858         tournamentData = new uint256[](GROUP_SIZE);
859         uint256 warriorId;
860         for(uint256 i = 0; i < GROUP_SIZE; i++) {
861             warriorId = _warriorIds[i];
862             tournamentData[i] = _packPVPData(warriorId, warriors[warriorId]);   
863         }
864         return tournamentData;
865     }
866     
867     
868     // @dev Internal utility function to sign up to tournament, 
869     // assumes that all battle requirements have been checked.
870     function _triggerTournamentSignUp(uint32[] memory _warriorIds, uint256 fee) internal {
871         //pack warrior ids into into uint256
872         uint256[] memory tournamentData = _packTournamentData(_warriorIds);
873         
874         for(uint256 i = 0; i < GROUP_SIZE; i++) {
875             // Set warrior current action to tournament battle
876             warriors[_warriorIds[i]].action = uint16(TOURNAMENT_BATTLE);
877         }
878 
879         battleProvider.addTournamentContender.value(fee)(msg.sender, tournamentData);
880     }
881     
882     function signUpForTournament(uint32[] _warriorIds) public payable {
883         //
884         //check that there is enough funds to pay entrance fee
885         uint256 fee = battleProvider.getTournamentThresholdFee();
886         require(msg.value >= fee);
887         //
888         //check that warriors group is exactly of allowed size
889         require(_warriorIds.length == GROUP_SIZE);
890         //
891         //message sender must own all the specified warrior IDs
892         require(_ownsAll(msg.sender, _warriorIds));
893         //
894         //check all warriors are unique
895         require(areUnique(_warriorIds));
896         //
897         //check that all warriors are 25 lv and IDLE
898         for(uint256 i = 0; i < GROUP_SIZE; i ++) {
899             // Grab a reference to the warrior in storage.
900             require(_isReadyToTournament(warriors[_warriorIds[i]]));
901         }
902         
903         
904         //all checks passed, trigger sign up
905         _triggerTournamentSignUp(_warriorIds, fee);
906         
907         // Calculate any excess funds included in msg.value. If the excess
908         // is anything worth worrying about, transfer it back to message owner.
909         // NOTE: We checked above that the msg.value is greater than or
910         // equal to the fee so this cannot underflow.
911         uint256 feeExcess = msg.value - fee;
912 
913         // Return the funds. This is not susceptible 
914         // to a re-entry attack because of _isReadyToTournament check
915         // will fail
916         msg.sender.transfer(feeExcess);
917     }
918     
919     function _setIDLE(uint256 warriorIds) internal {
920         for(uint256 i = 0; i < GROUP_SIZE; i ++) {
921             warriors[CryptoUtils._unpackWarriorId(warriorIds, i)].action = uint16(IDLE);
922         }
923     }
924     
925     function _freeWarriors(uint256[] memory packedContenders) internal {
926         uint256 length = packedContenders.length;
927         for(uint256 i = 0; i < length; i ++) {
928             //set participants action to IDLE
929             _setIDLE(packedContenders[i]);
930         }
931     }
932     
933     function tournamentFinished(uint256[] packedContenders) public {
934         //this method can be invoked only by battleProvider contract
935         require(msg.sender == address(battleProvider));
936         
937         //grad rewards and set IDLE action
938         _freeWarriors(packedContenders);
939     }
940     
941 }
942 
943 contract CryptoWarriorAuction is CryptoWarriorTournament {
944 
945     function setSaleAuctionAddress(address _address) external onlyAdmin {
946         SaleClockAuction candidateContract = SaleClockAuction(_address);
947 
948         require(candidateContract.isSaleClockAuction());
949 
950         saleAuction = candidateContract;
951     }
952 
953     function createSaleAuction(
954         uint256 _warriorId,
955         uint256 _startingPrice,
956         uint256 _endingPrice,
957         uint256 _duration
958     )
959         external
960         whenNotPaused
961     {
962         // only owned and not approved to transfer warriors allowed 
963         require(_ownerApproved(msg.sender, _warriorId));
964         // Ensure the warrior is not busy to prevent the auction
965         // contract creation while warrior is in any kind of battle (PVE, PVP, TOURNAMENT).
966         require(warriors[_warriorId].action == IDLE);
967         _approve(_warriorId, address(saleAuction));
968         // Actually create auction
969         saleAuction.createAuction(
970             _warriorId,
971             _startingPrice,
972             _endingPrice,
973             _duration,
974             msg.sender
975         );
976     }
977 
978 }
979 
980 contract CryptoWarriorIssuer is CryptoWarriorAuction {
981     
982     // Limits the number of warriors the contract owner can ever create
983     uint256 public constant MINER_CREATION_LIMIT = 2880;//issue every 15min for one month
984 	uint256 internal constant MINER_PERK = 1;
985     // Constants for miner auctions.
986     uint256 public constant MINER_STARTING_PRICE = 100 finney;
987     uint256 public constant MINER_END_PRICE = 50 finney;
988     uint256 public constant MINER_AUCTION_DURATION = 1 days;
989 
990     uint256 public minerCreatedCount;
991 
992     /// @dev Generates a new miner warrior with MINER perk of COMMON rarity
993     ///  creates an auction for it.
994     function createMinerAuction() external onlyIssuer {
995         require(minerCreatedCount < MINER_CREATION_LIMIT);
996 		
997         minerCreatedCount++;
998 
999         uint256 identity = generator.generateWarrior(minerCreatedCount, 0, block.number - 1, MINER_PERK);
1000         uint256 warriorId = _createWarrior(identity, bankAddress, 0);
1001         _approve(warriorId, address(saleAuction));
1002 
1003         saleAuction.createAuction(
1004             warriorId,
1005             _computeNextMinerPrice(),
1006             MINER_END_PRICE,
1007             MINER_AUCTION_DURATION,
1008             bankAddress
1009         );
1010     }
1011 
1012     function _computeNextMinerPrice() internal view returns (uint256) {
1013         uint256 avePrice = saleAuction.averageMinerSalePrice();
1014 
1015         require(avePrice == uint256(uint128(avePrice)));
1016 
1017         uint256 nextPrice = avePrice * 3 / 2;//confirmed
1018 
1019         if (nextPrice < MINER_STARTING_PRICE) {
1020             nextPrice = MINER_STARTING_PRICE;
1021         }
1022 
1023         return nextPrice;
1024     }
1025 
1026 }
1027 
1028 contract CryptoWarriorCore is CryptoWarriorIssuer {
1029 
1030     function CryptoWarriorCore() public {
1031         // Starts paused.
1032         paused = true;
1033 
1034         // the creator of the contract is the initial Admin
1035         adminAddress = msg.sender;
1036 
1037         // the creator of the contract is also the initial Issuer
1038         issuerAddress = msg.sender;
1039         
1040         // the creator of the contract is also the initial Bank
1041         bankAddress = msg.sender;
1042     }
1043     
1044     function() external payable {
1045         require(false);
1046     }
1047     
1048     function unpause() public onlyAdmin whenPaused {
1049         require(address(saleAuction) != address(0));
1050         require(address(generator) != address(0));
1051         require(address(battleProvider) != address(0));
1052         require(newContractAddress == address(0));
1053 
1054         // Actually unpause the contract.
1055         super.unpause();
1056     }
1057     
1058     function getBeneficiary() external view returns(address) {
1059         return bankAddress;
1060     }
1061     
1062     function isPVPListener() public pure returns (bool) {
1063         return true;
1064     }
1065        
1066     /**
1067      *@param _warriorIds array of warriorIds, 
1068      * for those IDs warrior data will be packed into warriorsData array
1069      *@return warriorsData packed warrior data
1070      *@return stepSize number of fields in single warrior data */
1071     function getWarriors(uint32[] _warriorIds) external view returns (uint256[] memory warriorsData, uint32 stepSize) {
1072         stepSize = 6;
1073         warriorsData = new uint256[](_warriorIds.length * stepSize);
1074         for(uint32 i = 0; i < _warriorIds.length; i++) {
1075             _setWarriorData(warriorsData, warriors[_warriorIds[i]], i * stepSize);
1076         }
1077     }
1078     
1079     /**
1080      *@param indexFrom index in global warrior storage (aka warriorId), 
1081      * from this index(including), warriors data will be gathered
1082      *@param count Number of warriors to include in packed data
1083      *@return warriorsData packed warrior data
1084      *@return stepSize number of fields in single warrior data */
1085     function getWarriorsFromIndex(uint32 indexFrom, uint32 count) external view returns (uint256[] memory warriorsData, uint32 stepSize) {
1086         stepSize = 6;
1087         //check length
1088         uint256 lenght = (warriors.length - indexFrom >= count ? count : warriors.length - indexFrom);
1089         
1090         warriorsData = new uint256[](lenght * stepSize);
1091         for(uint32 i = 0; i < lenght; i ++) {
1092             _setWarriorData(warriorsData, warriors[indexFrom + i], i * stepSize);
1093         }
1094     }
1095     
1096     function getWarriorOwners(uint32[] _warriorIds) external view returns (address[] memory owners) {
1097         uint256 lenght = _warriorIds.length;
1098         owners = new address[](lenght);
1099         
1100         for(uint256 i = 0; i < lenght; i ++) {
1101             owners[i] = warriorToOwner[_warriorIds[i]];
1102         }
1103     }
1104     
1105     
1106     function _setWarriorData(uint256[] memory warriorsData, DataTypes.Warrior storage warrior, uint32 id) internal view {
1107         warriorsData[id] = uint256(warrior.identity);//0
1108         warriorsData[id + 1] = uint256(warrior.cooldownEndBlock);//1
1109         warriorsData[id + 2] = uint256(warrior.level);//2
1110         warriorsData[id + 3] = uint256(warrior.rating);//3
1111         warriorsData[id + 4] = uint256(warrior.action);//4
1112         warriorsData[id + 5] = uint256(warrior.dungeonIndex);//5
1113     }
1114     
1115 	function getWarrior(uint256 _id) external view returns 
1116     (
1117         uint256 identity, 
1118         uint256 cooldownEndBlock, 
1119         uint256 level,
1120         uint256 rating, 
1121         uint256 action,
1122         uint256 dungeonIndex
1123     ) {
1124         DataTypes.Warrior storage warrior = warriors[_id];
1125 
1126         identity = uint256(warrior.identity);
1127         cooldownEndBlock = uint256(warrior.cooldownEndBlock);
1128         level = uint256(warrior.level);
1129 		rating = uint256(warrior.rating);
1130 		action = uint256(warrior.action);
1131 		dungeonIndex = uint256(warrior.dungeonIndex);
1132     }
1133     
1134 }
1135 
1136 
1137 contract PVP is Pausable, PVPInterface {
1138 	/* PVP BATLE */
1139 	
1140     /** list of packed warrior data that will participate in next PVP session. 
1141      *  Fixed size arry, to evade constant remove and push operations,
1142      *  this approach reduces transaction costs involving queue modification. */
1143     uint256[100] public pvpQueue;
1144     //
1145     //queue size
1146     uint256 public pvpQueueSize = 0;
1147     
1148     // @dev A mapping from owner address to booty in WEI
1149     //  booty is acquired in PVP and Tournament battles and can be
1150     // withdrawn with grabBooty method by the owner of the loot
1151     mapping (address => uint256) public ownerToBooty;
1152     
1153     // @dev A mapping from warrior id to owners address
1154     mapping (uint256 => address) internal warriorToOwner;
1155     
1156     // An approximation of currently how many seconds are in between blocks.
1157     uint256 internal secondsPerBlock = 15;
1158     
1159     // Cut owner takes from, measured in basis points (1/100 of a percent).
1160     // Values 0-10,000 map to 0%-100%
1161     uint256 public pvpOwnerCut;
1162     
1163     // Values 0-10,000 map to 0%-100%
1164     //this % of the total bets will be sent as 
1165     //a reward to address, that triggered finishPVP method
1166     uint256 public pvpMaxIncentiveCut;
1167     
1168     /// @notice The payment base required to use startPVP().
1169     // pvpBattleFee * (warrior.level / POINTS_TO_LEVEL)
1170     uint256 internal pvpBattleFee = 20 finney;
1171     
1172     uint256 public constant PVP_INTERVAL = 15 minutes;
1173     
1174     uint256 public nextPVPBatleBlock = 0;
1175     //number of WEI in hands of warrior owners
1176     uint256 public totalBooty = 0;
1177     
1178     /* TOURNAMENT */
1179     uint256 public constant FUND_GATHERING_TIME = 24 hours;
1180     uint256 public constant ADMISSION_TIME = 12 hours;
1181     uint256 public constant RATING_EXPAND_INTERVAL = 1 hours;
1182     uint256 internal constant SAFETY_GAP = 5;
1183     
1184     uint256 internal constant MAX_INCENTIVE_REWARD = 200 finney;
1185     
1186     //tournamentContenders size
1187     uint256 public tournamentQueueSize = 0;
1188     
1189     // Values 0-10,000 map to 0%-100%
1190     uint256 public tournamentBankCut;
1191     
1192    /** tournamentEndBlock, tournament is eligible to be finished only
1193     *  after block.number >= tournamentEndBlock 
1194     *  it depends on FUND_GATHERING_TIME and ADMISSION_TIME */
1195     uint256 public tournamentEndBlock;
1196     
1197     //number of WEI in tournament bank
1198     uint256 public currentTournamentBank = 0;
1199     uint256 public nextTournamentBank = 0;
1200     
1201     PVPListenerInterface internal pvpListener;
1202     
1203     /* EVENTS */
1204     /** @dev TournamentScheduled event. Emitted every time a tournament is scheduled 
1205      *  @param tournamentEndBlock when block.number > tournamentEndBlock, then tournament 
1206      *         is eligible to be finished or rescheduled */
1207     event TournamentScheduled(uint256 tournamentEndBlock);
1208     
1209     /** @dev PVPScheduled event. Emitted every time a tournament is scheduled 
1210      *  @param nextPVPBatleBlock when block.number > nextPVPBatleBlock, then pvp battle 
1211      *         is eligible to be finished or rescheduled */
1212     event PVPScheduled(uint256 nextPVPBatleBlock);
1213     
1214     /** @dev PVPNewContender event. Emitted every time a warrior enqueues pvp battle
1215      *  @param owner Warrior owner
1216      *  @param warriorId Warrior ID that entered PVP queue
1217      *  @param entranceFee fee in WEI warrior owner payed to enter PVP
1218      */
1219     event PVPNewContender(address owner, uint256 warriorId, uint256 entranceFee);
1220 
1221     /** @dev PVPFinished event. Emitted every time a pvp battle is finished
1222      *  @param warriorsData array of pairs of pvp warriors packed to uint256, even => winners, odd => losers 
1223      *  @param owners array of warrior owners, 1 to 1 with warriorsData, even => winners, odd => losers 
1224      *  @param matchingCount total number of warriors that fought in current pvp session and got rewards,
1225      *  if matchingCount < participants.length then all IDs that are >= matchingCount will 
1226      *  remain in waiting room, until they are matched.
1227      */
1228     event PVPFinished(uint256[] warriorsData, address[] owners, uint256 matchingCount);
1229     
1230     /** @dev BootySendFailed event. Emitted every time address.send() function failed to transfer Ether to recipient
1231      *  in this case recipient Ether is recorded to ownerToBooty mapping, so recipient can withdraw their booty manually
1232      *  @param recipient address for whom send failed
1233      *  @param amount number of WEI we failed to send
1234      */
1235     event BootySendFailed(address recipient, uint256 amount);
1236     
1237     /** @dev BootyGrabbed event
1238      *  @param receiver address who grabbed his booty
1239      *  @param amount number of WEI
1240      */
1241     event BootyGrabbed(address receiver, uint256 amount);
1242     
1243     /** @dev PVPContenderRemoved event. Emitted every time warrior is removed from pvp queue by its owner.
1244      *  @param warriorId id of the removed warrior
1245      */
1246     event PVPContenderRemoved(uint256 warriorId, address owner);
1247     
1248     function PVP(uint256 _pvpCut, uint256 _tournamentBankCut, uint256 _pvpMaxIncentiveCut) public {
1249         require((_tournamentBankCut + _pvpCut + _pvpMaxIncentiveCut) <= 10000);
1250 		pvpOwnerCut = _pvpCut;
1251 		tournamentBankCut = _tournamentBankCut;
1252 		pvpMaxIncentiveCut = _pvpMaxIncentiveCut;
1253     }
1254     
1255     /** @dev grabBooty sends to message sender his booty in WEI
1256      */
1257     function grabBooty() external {
1258         uint256 booty = ownerToBooty[msg.sender];
1259         require(booty > 0);
1260         require(totalBooty >= booty);
1261         
1262         ownerToBooty[msg.sender] = 0;
1263         totalBooty -= booty;
1264         
1265         msg.sender.transfer(booty);
1266         //emit event
1267         BootyGrabbed(msg.sender, booty);
1268     }
1269     
1270     function safeSend(address _recipient, uint256 _amaunt) internal {
1271 		uint256 failedBooty = sendBooty(_recipient, _amaunt);
1272         if (failedBooty > 0) {
1273 			totalBooty += failedBooty;
1274         }
1275     }
1276     
1277     function sendBooty(address _recipient, uint256 _amaunt) internal returns(uint256) {
1278         bool success = _recipient.send(_amaunt);
1279         if (!success && _amaunt > 0) {
1280             ownerToBooty[_recipient] += _amaunt;
1281             BootySendFailed(_recipient, _amaunt);
1282             return _amaunt;
1283         }
1284         return 0;
1285     }
1286     
1287     //@returns block number, after this block tournament is opened for admission
1288     function getTournamentAdmissionBlock() public view returns(uint256) {
1289         uint256 admissionInterval = (ADMISSION_TIME / secondsPerBlock);
1290         return tournamentEndBlock < admissionInterval ? 0 : tournamentEndBlock - admissionInterval;
1291     }
1292     
1293     
1294     //schedules next turnament time(block)
1295     function _scheduleTournament() internal {
1296         //we can chedule only if there is nobody in tournament queue and
1297         //time of tournament battle have passed
1298 		if (tournamentQueueSize == 0 && tournamentEndBlock <= block.number) {
1299 		    tournamentEndBlock = ((FUND_GATHERING_TIME / 2 + ADMISSION_TIME) / secondsPerBlock) + block.number;
1300 		    TournamentScheduled(tournamentEndBlock);
1301 		}
1302     }
1303     
1304     /// @dev Updates the minimum payment required for calling startPVP(). Can only
1305     ///  be called by the Owner address, and only if pvp queue is empty.
1306     function setPVPEntranceFee(uint256 value) external onlyOwner {
1307         require(pvpQueueSize == 0);
1308         pvpBattleFee = value;
1309     }
1310     
1311     //@returns PVP entrance fee for specified warrior level 
1312     //@param _levelPoints NB!
1313     function getPVPEntranceFee(uint256 _levelPoints) external view returns(uint256) {
1314         return pvpBattleFee * CryptoUtils._getLevel(_levelPoints);
1315     }
1316     
1317     //level can only be > 0 and <= 25
1318     function _getPVPFeeByLevel(uint256 _level) internal view returns(uint256) {
1319         return pvpBattleFee * _level;
1320     }
1321     
1322 	// @dev Computes warrior pvp reward
1323     // @param _totalBet - total bet from both competitors.
1324     function _computePVPReward(uint256 _totalBet, uint256 _contendersCut) internal pure returns (uint256){
1325         // NOTE: We don't use SafeMath (or similar) in this function because
1326         // _totalBet max value is 1000 finney, and _contendersCut aka
1327         // (10000 - pvpOwnerCut - tournamentBankCut - incentiveRewardCut) <= 10000 (see the require()
1328         // statement in the BattleProvider constructor). The result of this
1329         // function is always guaranteed to be <= _totalBet.
1330         return _totalBet * _contendersCut / 10000;
1331     }
1332     
1333     function _getPVPContendersCut(uint256 _incentiveCut) internal view returns (uint256) {
1334         // NOTE: We don't use SafeMath (or similar) in this function because
1335         // (pvpOwnerCut + tournamentBankCut + pvpMaxIncentiveCut) <= 10000 (see the require()
1336         // statement in the BattleProvider constructor). 
1337         // _incentiveCut is guaranteed to be >= 1 and <=  pvpMaxIncentiveCut
1338         return (10000 - pvpOwnerCut - tournamentBankCut - _incentiveCut);
1339     }
1340 	
1341 	// @dev Computes warrior pvp reward
1342     // @param _totalSessionLoot - total bets from all competitors.
1343     function _computeIncentiveReward(uint256 _totalSessionLoot, uint256 _incentiveCut) internal pure returns (uint256){
1344         // NOTE: We don't use SafeMath (or similar) in this function because
1345         // _totalSessionLoot max value is 37500 finney, and 
1346         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
1347         // statement in the BattleProvider constructor). The result of this
1348         // function is always guaranteed to be <= _totalSessionLoot.
1349         return _totalSessionLoot * _incentiveCut / 10000;
1350     }
1351     
1352 	///@dev computes incentive cut for specified loot, 
1353 	/// Values 0-10,000 map to 0%-100%
1354 	/// max incentive reward cut is 5%, if it exceeds MAX_INCENTIVE_REWARD,
1355 	/// then cut is lowered to be equal to MAX_INCENTIVE_REWARD.
1356 	/// minimum cut is 0.01%
1357     /// this % of the total bets will be sent as 
1358     /// a reward to address, that triggered finishPVP method
1359     function _computeIncentiveCut(uint256 _totalSessionLoot, uint256 maxIncentiveCut) internal pure returns(uint256) {
1360         uint256 result = _totalSessionLoot * maxIncentiveCut / 10000;
1361         result = result <= MAX_INCENTIVE_REWARD ? maxIncentiveCut : MAX_INCENTIVE_REWARD * 10000 / _totalSessionLoot;
1362         //min cut is 0.01%
1363         return result > 0 ? result : 1;
1364     }
1365     
1366     // @dev Computes warrior pvp reward
1367     // @param _totalSessionLoot - total bets from all competitors.
1368     function _computePVPBeneficiaryFee(uint256 _totalSessionLoot) internal view returns (uint256){
1369         // NOTE: We don't use SafeMath (or similar) in this function because
1370         // _totalSessionLoot max value is 37500 finney, and 
1371         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
1372         // statement in the BattleProvider constructor). The result of this
1373         // function is always guaranteed to be <= _totalSessionLoot.
1374         return _totalSessionLoot * pvpOwnerCut / 10000;
1375     }
1376     
1377     // @dev Computes tournament bank cut
1378     // @param _totalSessionLoot - total session loot.
1379     function _computeTournamentCut(uint256 _totalSessionLoot) internal view returns (uint256){
1380         // NOTE: We don't use SafeMath (or similar) in this function because
1381         // _totalSessionLoot max value is 37500 finney, and 
1382         // (pvpOwnerCut + tournamentBankCut + incentiveRewardCut) <= 10000 (see the require()
1383         // statement in the BattleProvider constructor). The result of this
1384         // function is always guaranteed to be <= _totalSessionLoot.
1385         return _totalSessionLoot * tournamentBankCut / 10000;
1386     }
1387 
1388     function indexOf(uint256 _warriorId) internal view returns(int256) {
1389 	    uint256 length = uint256(pvpQueueSize);
1390 	    for(uint256 i = 0; i < length; i ++) {
1391 	        if(CryptoUtils._unpackIdValue(pvpQueue[i]) == _warriorId) return int256(i);
1392 	    }
1393 	    return -1;
1394 	}
1395     
1396     function getPVPIncentiveReward(uint256[] memory matchingIds, uint256 matchingCount) internal view returns(uint256) {
1397         uint256 sessionLoot = _computeTotalBooty(matchingIds, matchingCount);
1398         
1399         return _computeIncentiveReward(sessionLoot, _computeIncentiveCut(sessionLoot, pvpMaxIncentiveCut));
1400     }
1401     
1402     function maxPVPContenders() external view returns(uint256){
1403         return pvpQueue.length;
1404     }
1405     
1406     function getPVPState() external view returns
1407     (uint256 contendersCount, uint256 matchingCount, uint256 endBlock, uint256 incentiveReward)
1408     {
1409         uint256[] memory pvpData = _packPVPData();
1410         
1411     	contendersCount = pvpQueueSize;
1412     	matchingCount = CryptoUtils._getMatchingIds(pvpData, PVP_INTERVAL, _computeCycleSkip(), RATING_EXPAND_INTERVAL);
1413     	endBlock = nextPVPBatleBlock;   
1414     	incentiveReward = getPVPIncentiveReward(pvpData, matchingCount);
1415     }
1416     
1417     function canFinishPVP() external view returns(bool) {
1418         return nextPVPBatleBlock <= block.number &&
1419          CryptoUtils._getMatchingIds(_packPVPData(), PVP_INTERVAL, _computeCycleSkip(), RATING_EXPAND_INTERVAL) > 1;
1420     }
1421     
1422     function _clarifyPVPSchedule() internal {
1423         uint256 length = pvpQueueSize;
1424 		uint256 currentBlock = block.number;
1425 		uint256 nextBattleBlock = nextPVPBatleBlock;
1426 		//if battle not scheduled, schedule battle
1427 		if (nextBattleBlock <= currentBlock) {
1428 		    //if queue not empty update cycles
1429 		    if (length > 0) {
1430 				uint256 packedWarrior;
1431 				uint256 cycleSkip = _computeCycleSkip();
1432 		        for(uint256 i = 0; i < length; i++) {
1433 		            packedWarrior = pvpQueue[i];
1434 		            //increase warrior iteration cycle
1435 		            pvpQueue[i] = CryptoUtils._changeCycleValue(packedWarrior, CryptoUtils._unpackCycleValue(packedWarrior) + cycleSkip);
1436 		        }
1437 		    }
1438 		    nextBattleBlock = (PVP_INTERVAL / secondsPerBlock) + currentBlock;
1439 		    nextPVPBatleBlock = nextBattleBlock;
1440 		    PVPScheduled(nextBattleBlock);
1441 		//if pvp queue will be full and there is still too much time left, then let the battle begin! 
1442 		} else if (length + 1 == pvpQueue.length && (currentBlock + SAFETY_GAP * 2) < nextBattleBlock) {
1443 		    nextBattleBlock = currentBlock + SAFETY_GAP;
1444 		    nextPVPBatleBlock = nextBattleBlock;
1445 		    PVPScheduled(nextBattleBlock);
1446 		}
1447     }
1448     
1449     /// @dev Internal utility function to initiate pvp battle, assumes that all battle
1450     ///  requirements have been checked.
1451     function _triggerNewPVPContender(address _owner, uint256 _packedWarrior, uint256 fee) internal {
1452 
1453 		_clarifyPVPSchedule();
1454         //number of pvp cycles the warrior is waiting for suitable enemy match
1455         //increment every time when finishPVP is called and no suitable enemy match was found
1456         _packedWarrior = CryptoUtils._changeCycleValue(_packedWarrior, 0);
1457 		
1458 		//record contender data
1459 		pvpQueue[pvpQueueSize++] = _packedWarrior;
1460 		warriorToOwner[CryptoUtils._unpackIdValue(_packedWarrior)] = _owner;
1461 		
1462 		//Emit event
1463 		PVPNewContender(_owner, CryptoUtils._unpackIdValue(_packedWarrior), fee);
1464     }
1465     
1466     function _noMatchingPairs() internal view returns(bool) {
1467         uint256 matchingCount = CryptoUtils._getMatchingIds(_packPVPData(), uint64(PVP_INTERVAL), _computeCycleSkip(), uint64(RATING_EXPAND_INTERVAL));
1468         return matchingCount == 0;
1469     }
1470     
1471     /*
1472      * @title startPVP enqueues specified warrior to PVP
1473      * 
1474      * @dev When the owner enqueues his warrior for PvP, the warrior enters the waiting room.
1475      * Once every 15 minutes, we check the warriors in the room and select pairs. 
1476      * For those warriors to whom we found couples, fighting is conducted and the results 
1477      * are recorded in the profile of the warrior. 
1478      */
1479     function addPVPContender(address _owner, uint256 _packedWarrior) external payable whenNotPaused {
1480 		// Caller must be pvpListener contract
1481         require(msg.sender == address(pvpListener));
1482 
1483         require(_owner != address(0));
1484         //contender can be added only while PVP is scheduled in future
1485         //or no matching warrior pairs found
1486         require(nextPVPBatleBlock > block.number || _noMatchingPairs());
1487         // Check that the warrior exists.
1488         require(_packedWarrior != 0);
1489         //owner must withdraw all loot before contending pvp
1490         require(ownerToBooty[_owner] == 0);
1491         //check that there is enough room for new participants
1492         require(pvpQueueSize < pvpQueue.length);
1493         // Checks for payment.
1494         uint256 fee = _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarrior));
1495         require(msg.value >= fee);
1496         //
1497         // All checks passed, put the warrior to the queue!
1498         _triggerNewPVPContender(_owner, _packedWarrior, fee);
1499     }
1500     
1501     function _packPVPData() internal view returns(uint256[] memory matchingIds) {
1502         uint256 length = pvpQueueSize;
1503         matchingIds = new uint256[](length);
1504         for(uint256 i = 0; i < length; i++) {
1505             matchingIds[i] = pvpQueue[i];
1506         }
1507         return matchingIds;
1508     }
1509     
1510     function _computeTotalBooty(uint256[] memory _packedWarriors, uint256 matchingCount) internal view returns(uint256) {
1511         //compute session booty
1512         uint256 sessionLoot = 0;
1513         for(uint256 i = 0; i < matchingCount; i++) {
1514             sessionLoot += _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarriors[i]));
1515         }
1516         return sessionLoot;
1517     }
1518     
1519     function _grandPVPRewards(uint256[] memory _packedWarriors, uint256 matchingCount) 
1520     internal returns(uint256)
1521     {
1522         uint256 booty = 0;
1523         uint256 packedWarrior;
1524         uint256 failedBooty = 0;
1525         
1526         uint256 sessionBooty = _computeTotalBooty(_packedWarriors, matchingCount);
1527         uint256 incentiveCut = _computeIncentiveCut(sessionBooty, pvpMaxIncentiveCut);
1528         uint256 contendersCut = _getPVPContendersCut(incentiveCut);
1529         
1530         for(uint256 id = 0; id < matchingCount; id++) {
1531             //give reward to warriors that fought hard
1532 			//winner, even ids are winners!
1533 			packedWarrior = _packedWarriors[id];
1534 			//
1535 			//give winner deserved booty 80% from both bets
1536 			//must be computed before level reward!
1537 			booty = _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(packedWarrior)) + 
1538 				_getPVPFeeByLevel(CryptoUtils._unpackLevelValue(_packedWarriors[id + 1]));
1539 			
1540 			//
1541 			//send reward to warrior owner
1542 			failedBooty += sendBooty(warriorToOwner[CryptoUtils._unpackIdValue(packedWarrior)], _computePVPReward(booty, contendersCut));
1543 			//loser, they are odd...
1544 			//skip them, as they deserve none!
1545 			id ++;
1546         }
1547         failedBooty += sendBooty(pvpListener.getBeneficiary(), _computePVPBeneficiaryFee(sessionBooty));
1548         
1549         if (failedBooty > 0) {
1550             totalBooty += failedBooty;
1551         }
1552         //if tournament admission start time not passed
1553         //add tournament cut to current tournament bank,
1554         //otherwise to next tournament bank
1555         if (getTournamentAdmissionBlock() > block.number) {
1556             currentTournamentBank += _computeTournamentCut(sessionBooty);
1557         } else {
1558             nextTournamentBank += _computeTournamentCut(sessionBooty);
1559         }
1560         
1561         //compute incentive reward
1562         return _computeIncentiveReward(sessionBooty, incentiveCut);
1563     }
1564     
1565     function _increaseCycleAndTrimQueue(uint256[] memory matchingIds, uint256 matchingCount) internal {
1566         uint32 length = uint32(matchingIds.length - matchingCount);  
1567 		uint256 packedWarrior;
1568 		uint256 skipCycles = _computeCycleSkip();
1569         for(uint256 i = 0; i < length; i++) {
1570             packedWarrior = matchingIds[matchingCount + i];
1571             //increase warrior iteration cycle
1572             pvpQueue[i] = CryptoUtils._changeCycleValue(packedWarrior, CryptoUtils._unpackCycleValue(packedWarrior) + skipCycles);
1573         }
1574         //trim queue	
1575         pvpQueueSize = length;
1576     }
1577     
1578     function _computeCycleSkip() internal view returns(uint256) {
1579         uint256 number = block.number;
1580         return nextPVPBatleBlock > number ? 0 : (number - nextPVPBatleBlock) * secondsPerBlock / PVP_INTERVAL + 1;
1581     }
1582     
1583     function _getWarriorOwners(uint256[] memory pvpData) internal view returns (address[] memory owners){
1584         uint256 length = pvpData.length;
1585         owners = new address[](length);
1586         for(uint256 i = 0; i < length; i ++) {
1587             owners[i] = warriorToOwner[CryptoUtils._unpackIdValue(pvpData[i])];
1588         }
1589     }
1590     
1591     // @dev Internal utility function to initiate pvp battle, assumes that all battle
1592     ///  requirements have been checked.
1593     function _triggerPVPFinish(uint256[] memory pvpData, uint256 matchingCount) internal returns(uint256){
1594         //
1595 		//compute battle results        
1596         CryptoUtils._getPVPBattleResults(pvpData, matchingCount, nextPVPBatleBlock);
1597         //
1598         //mark not fought warriors and trim queue 
1599         _increaseCycleAndTrimQueue(pvpData, matchingCount);
1600         //
1601         //schedule next battle time
1602         nextPVPBatleBlock = (PVP_INTERVAL / secondsPerBlock) + block.number;
1603         
1604         //
1605         //schedule tournament
1606         //if contendersCount is 0 and tournament not scheduled, schedule tournament
1607         //NB MUST be before _grandPVPRewards()
1608         _scheduleTournament();
1609         // compute and grand rewards to warriors,
1610         // put tournament cut to bank, not susceptible to reentry attack because of require(nextPVPBatleBlock <= block.number);
1611         // and require(number of pairs > 1);
1612         uint256 incentiveReward = _grandPVPRewards(pvpData, matchingCount);
1613         //
1614         //notify pvp listener contract
1615         pvpListener.pvpFinished(pvpData, matchingCount);
1616         
1617         //
1618         //fire event
1619 		PVPFinished(pvpData, _getWarriorOwners(pvpData), matchingCount);
1620         PVPScheduled(nextPVPBatleBlock);
1621 		
1622 		return incentiveReward;
1623     }
1624     
1625     
1626     /**
1627      * @dev finishPVP this method finds matches of warrior pairs
1628      * in waiting room and computes result of their fights.
1629      * 
1630      * The winner gets +1 level, the loser gets +0.5 level
1631      * The winning player gets +130 rating
1632 	 * The losing player gets -30 or 70 rating (if warrior levelUps after battle) .
1633      * can be called once in 15min.
1634      * NB If the warrior is not picked up in an hour, then we expand the range 
1635      * of selection by 25 rating each hour.
1636      */
1637     function finishPVP() public whenNotPaused {
1638         // battle interval is over
1639         require(nextPVPBatleBlock <= block.number);
1640         //
1641 	    //match warriors
1642         uint256[] memory pvpData = _packPVPData();
1643         //match ids and sort them according to matching
1644         uint256 matchingCount = CryptoUtils._getMatchingIds(pvpData, uint64(PVP_INTERVAL), _computeCycleSkip(), uint64(RATING_EXPAND_INTERVAL));
1645 		// we have at least 1 matching battle pair
1646         require(matchingCount > 1);
1647         
1648         // When the all checks done, calculate actual battle result
1649         uint256 incentiveReward = _triggerPVPFinish(pvpData, matchingCount);
1650         
1651         //give reward for incentive
1652         safeSend(msg.sender, incentiveReward);
1653     }
1654 
1655     // @dev Removes specified warrior from PVP queue
1656     //  sets warrior free (IDLE) and returns pvp entrance fee to owner
1657     // @notice This is a state-modifying function that can
1658     //  be called while the contract is paused.
1659     // @param _warriorId - ID of warrior in PVP queue
1660     function removePVPContender(uint32 _warriorId) external{
1661         uint256 queueSize = pvpQueueSize;
1662         require(queueSize > 0);
1663         // Caller must be owner of the specified warrior
1664         require(warriorToOwner[_warriorId] == msg.sender);
1665         //warrior must be in pvp queue
1666         int256 warriorIndex = indexOf(_warriorId);
1667         require(warriorIndex >= 0);
1668         //grab warrior data
1669         uint256 warriorData = pvpQueue[uint32(warriorIndex)];
1670         //warrior cycle must be >= 4 (> than 1 hour)
1671         require((CryptoUtils._unpackCycleValue(warriorData) + _computeCycleSkip()) >= 4);
1672         
1673         //remove from queue
1674         if (uint256(warriorIndex) < queueSize - 1) {
1675 	        pvpQueue[uint32(warriorIndex)] = pvpQueue[pvpQueueSize - 1];
1676         }
1677         pvpQueueSize --;
1678         //notify battle listener
1679         pvpListener.pvpContenderRemoved(_warriorId);
1680         //return pvp bet
1681         msg.sender.transfer(_getPVPFeeByLevel(CryptoUtils._unpackLevelValue(warriorData)));
1682         //Emit event
1683         PVPContenderRemoved(_warriorId, msg.sender);
1684     }
1685     
1686     function getPVPCycles(uint32[] warriorIds) external view returns(uint32[]){
1687         uint256 length = warriorIds.length;
1688         uint32[] memory cycles = new uint32[](length);
1689         int256 index;
1690         uint256 skipCycles = _computeCycleSkip();
1691 	    for(uint256 i = 0; i < length; i ++) {
1692 	        index = indexOf(warriorIds[i]);
1693 	        cycles[i] = index >= 0 ? uint32(CryptoUtils._unpackCycleValue(pvpQueue[uint32(index)]) + skipCycles) : 0;
1694 	    }
1695 	    return cycles;
1696     }
1697     
1698     // @dev Remove all PVP contenders from PVP queue 
1699     //  and return all bets to warrior owners.
1700     //  NB: this is emergency method, used only in f%#^@up situation
1701     function removeAllPVPContenders() external onlyOwner whenPaused {
1702         //remove all pvp contenders
1703         uint256 length = pvpQueueSize;
1704         
1705         uint256 warriorData;
1706         uint256 warriorId;
1707         uint256 failedBooty;
1708         address owner;
1709         
1710         pvpQueueSize = 0;
1711         
1712         for(uint256 i = 0; i < length; i++) {
1713 	        //grab warrior data
1714 	        warriorData = pvpQueue[i];
1715 	        warriorId = CryptoUtils._unpackIdValue(warriorData);
1716 	        //notify battle listener
1717 	        pvpListener.pvpContenderRemoved(uint32(warriorId));
1718 	        
1719 	        owner = warriorToOwner[warriorId];
1720 	        //return pvp bet
1721 	        failedBooty += sendBooty(owner, _getPVPFeeByLevel(CryptoUtils._unpackLevelValue(warriorData)));
1722         }
1723         totalBooty += failedBooty;
1724     }
1725 }
1726 
1727 contract Tournament is PVP {
1728 
1729     uint256 internal constant GROUP_SIZE = 5;
1730     uint256 internal constant DATA_SIZE = 2;
1731     uint256 internal constant THRESHOLD = 300;
1732     
1733   /** list of warrior IDs that will participate in next tournament. 
1734     *  Fixed size arry, to evade constant remove and push operations,
1735     *  this approach reduces transaction costs involving array modification. */
1736     uint256[160] public tournamentQueue;
1737     
1738     /**The cost of participation in the tournament is 1% of its current prize fund, 
1739      * money is added to the prize fund. measured in basis points (1/100 of a percent).
1740      * Values 0-10,000 map to 0%-100% */
1741     uint256 internal tournamentEntranceFeeCut = 100;
1742     
1743     // Values 0-10,000 map to 0%-100% => 20%
1744     uint256 public tournamentOwnersCut;
1745     uint256 public tournamentIncentiveCut;
1746     
1747      /** @dev TournamentNewContender event. Emitted every time a warrior enters tournament
1748      *  @param owner Warrior owner
1749      *  @param warriorIds 5 Warrior IDs that entered tournament, packed into one uint256
1750      *  see CryptoUtils._packWarriorIds
1751      */
1752     event TournamentNewContender(address owner, uint256 warriorIds, uint256 entranceFee);
1753     
1754     /** @dev TournamentFinished event. Emitted every time a tournament is finished
1755      *  @param owners array of warrior group owners packed to uint256
1756      *  @param results number of wins for each group
1757      *  @param tournamentBank current tournament bank
1758      *  see CryptoUtils._packWarriorIds
1759      */
1760     event TournamentFinished(uint256[] owners, uint32[] results, uint256 tournamentBank);
1761     
1762     function Tournament(uint256 _pvpCut, uint256 _tournamentBankCut, 
1763     uint256 _pvpMaxIncentiveCut, uint256 _tournamentOwnersCut, uint256 _tournamentIncentiveCut) public
1764     PVP(_pvpCut, _tournamentBankCut, _pvpMaxIncentiveCut) 
1765     {
1766         require((_tournamentOwnersCut + _tournamentIncentiveCut) <= 10000);
1767 		
1768 		tournamentOwnersCut = _tournamentOwnersCut;
1769 		tournamentIncentiveCut = _tournamentIncentiveCut;
1770     }
1771     
1772     
1773     
1774     // @dev Computes incentive reward for launching tournament finishTournament()
1775     // @param _tournamentBank
1776     function _computeTournamentIncentiveReward(uint256 _currentBank, uint256 _incentiveCut) internal pure returns (uint256){
1777         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
1778         // and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
1779         // statement in the Tournament constructor). The result of this
1780         // function is always guaranteed to be <= _currentBank.
1781         return _currentBank * _incentiveCut / 10000;
1782     }
1783     
1784     function _computeTournamentContenderCut(uint256 _incentiveCut) internal view returns (uint256) {
1785         // NOTE: (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
1786         // statement in the Tournament constructor). The result of this
1787         // function is always guaranteed to be <= _reward.
1788         return 10000 - tournamentOwnersCut - _incentiveCut;
1789     }
1790     
1791     function _computeTournamentBeneficiaryFee(uint256 _currentBank) internal view returns (uint256){
1792         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
1793         // and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
1794         // statement in the Tournament constructor). The result of this
1795         // function is always guaranteed to be <= _currentBank.
1796         return _currentBank * tournamentOwnersCut / 10000;
1797     }
1798     
1799     // @dev set tournament entrance fee cut, can be set only if
1800     // tournament queue is empty
1801     // @param _cut range from 0 - 10000, mapped to 0-100%
1802     function setTournamentEntranceFeeCut(uint256 _cut) external onlyOwner {
1803         //cut must be less or equal 100&
1804         require(_cut <= 10000);
1805         //tournament queue must be empty
1806         require(tournamentQueueSize == 0);
1807         //checks passed, set cut
1808 		tournamentEntranceFeeCut = _cut;
1809     }
1810     
1811     function getTournamentEntranceFee() external view returns(uint256) {
1812         return currentTournamentBank * tournamentEntranceFeeCut / 10000;
1813     }
1814     
1815     //@dev returns tournament entrance fee - 3% threshold
1816     function getTournamentThresholdFee() public view returns(uint256) {
1817         return currentTournamentBank * tournamentEntranceFeeCut * (10000 - THRESHOLD) / 10000 / 10000;
1818     }
1819     
1820     //@dev returns max allowed tournament contenders, public because of internal use
1821     function maxTournamentContenders() public view returns(uint256){
1822         return tournamentQueue.length / DATA_SIZE;
1823     }
1824     
1825     function canFinishTournament() external view returns(bool) {
1826         return tournamentEndBlock <= block.number && tournamentQueueSize > 0;
1827     }
1828     
1829     // @dev Internal utility function to sigin up to tournament, 
1830     // assumes that all battle requirements have been checked.
1831     function _triggerNewTournamentContender(address _owner, uint256[] memory _tournamentData, uint256 _fee) internal {
1832         //pack warrior ids into uint256
1833         
1834         currentTournamentBank += _fee;
1835         
1836         uint256 packedWarriorIds = CryptoUtils._packWarriorIds(_tournamentData);
1837         //make composite warrior out of 5 warriors 
1838         uint256 combinedWarrior = CryptoUtils._combineWarriors(_tournamentData);
1839         
1840         //add to queue
1841         //icrement tournament queue
1842         uint256 size = tournamentQueueSize++ * DATA_SIZE;
1843         //record tournament data
1844 		tournamentQueue[size++] = packedWarriorIds;
1845 		tournamentQueue[size++] = combinedWarrior;
1846 		warriorToOwner[CryptoUtils._unpackWarriorId(packedWarriorIds, 0)] = _owner;
1847 		//
1848 		//Emit event
1849 		TournamentNewContender(_owner, packedWarriorIds, _fee);
1850     }
1851     
1852     function addTournamentContender(address _owner, uint256[] _tournamentData) external payable whenNotPaused{
1853         // Caller must be pvpListener contract
1854         require(msg.sender == address(pvpListener));
1855         
1856         require(_owner != address(0));
1857         //
1858         //check current tournament bank > 0
1859         require(pvpBattleFee == 0 || currentTournamentBank > 0);
1860         //
1861         //check that there is enough funds to pay entrance fee
1862         uint256 fee = getTournamentThresholdFee();
1863         require(msg.value >= fee);
1864         //owner must withdraw all booty before contending pvp
1865         require(ownerToBooty[_owner] == 0);
1866         //
1867         //check that warriors group is exactly of allowed size
1868         require(_tournamentData.length == GROUP_SIZE);
1869         //
1870         //check that there is enough room for new participants
1871         require(tournamentQueueSize < maxTournamentContenders());
1872         //
1873         //check that admission started
1874         require(block.number >= getTournamentAdmissionBlock());
1875         //check that admission not ended
1876         require(block.number <= tournamentEndBlock);
1877         
1878         //all checks passed, trigger sign up
1879         _triggerNewTournamentContender(_owner, _tournamentData, fee);
1880     }
1881     
1882     //@dev collect all combined warriors data
1883     function getCombinedWarriors() internal view returns(uint256[] memory warriorsData) {
1884         uint256 length = tournamentQueueSize;
1885         warriorsData = new uint256[](length);
1886         
1887         for(uint256 i = 0; i < length; i ++) {
1888             // Grab the combined warrior data in storage.
1889             warriorsData[i] = tournamentQueue[i * DATA_SIZE + 1];
1890         }
1891         return warriorsData;
1892     }
1893     
1894     function getTournamentState() external view returns
1895     (uint256 contendersCount, uint256 bank, uint256 admissionStartBlock, uint256 endBlock, uint256 incentiveReward)
1896     {
1897     	contendersCount = tournamentQueueSize;
1898     	bank = currentTournamentBank;
1899     	admissionStartBlock = getTournamentAdmissionBlock();   
1900     	endBlock = tournamentEndBlock;
1901     	incentiveReward = _computeTournamentIncentiveReward(bank, _computeIncentiveCut(bank, tournamentIncentiveCut));
1902     }
1903     
1904     function _repackToCombinedIds(uint256[] memory _warriorsData) internal view {
1905         uint256 length = _warriorsData.length;
1906         for(uint256 i = 0; i < length; i ++) {
1907             _warriorsData[i] = tournamentQueue[i * DATA_SIZE];
1908         }
1909     }
1910     
1911     // @dev Computes warrior pvp reward
1912     // @param _totalBet - total bet from both competitors.
1913     function _computeTournamentBooty(uint256 _currentBank, uint256 _contenderResult, uint256 _totalBattles) internal pure returns (uint256){
1914         // NOTE: We don't use SafeMath (or similar) in this function because _currentBank max is equal ~ 20000000 finney,
1915         // _totalBattles is guaranteed to be > 0 and <= 400, and (tournamentOwnersCut + tournamentIncentiveCut) <= 10000 (see the require()
1916         // statement in the Tournament constructor). The result of this
1917         // function is always guaranteed to be <= _reward.
1918         // return _currentBank * (10000 - tournamentOwnersCut - _incentiveCut) * _result / 10000 / _totalBattles;
1919         return _currentBank * _contenderResult / _totalBattles;
1920         
1921     }
1922     
1923     function _grandTournamentBooty(uint256 _warriorIds, uint256 _currentBank, uint256 _contenderResult, uint256 _totalBattles)
1924     internal returns (uint256)
1925     {
1926         uint256 warriorId = CryptoUtils._unpackWarriorId(_warriorIds, 0);
1927         address owner = warriorToOwner[warriorId];
1928         uint256 booty = _computeTournamentBooty(_currentBank, _contenderResult, _totalBattles);
1929         return sendBooty(owner, booty);
1930     }
1931     
1932     function _grandTournamentRewards(uint256 _currentBank, uint256[] memory _warriorsData, uint32[] memory _results) internal returns (uint256){
1933         uint256 length = _warriorsData.length;
1934         uint256 totalBattles = CryptoUtils._getTournamentBattles(length) * 10000;//*10000 required for booty computation
1935         uint256 incentiveCut = _computeIncentiveCut(_currentBank, tournamentIncentiveCut);
1936         uint256 contenderCut = _computeTournamentContenderCut(incentiveCut);
1937         
1938         uint256 failedBooty = 0;
1939         for(uint256 i = 0; i < length; i ++) {
1940             //grand rewards
1941             failedBooty += _grandTournamentBooty(_warriorsData[i], _currentBank, _results[i] * contenderCut, totalBattles);
1942         }
1943         //send beneficiary fee
1944         failedBooty += sendBooty(pvpListener.getBeneficiary(), _computeTournamentBeneficiaryFee(_currentBank));
1945         if (failedBooty > 0) {
1946             totalBooty += failedBooty;
1947         }
1948         return _computeTournamentIncentiveReward(_currentBank, incentiveCut);
1949     }
1950     
1951     function _repackToWarriorOwners(uint256[] memory warriorsData) internal view {
1952         uint256 length = warriorsData.length;
1953         for (uint256 i = 0; i < length; i ++) {
1954             warriorsData[i] = uint256(warriorToOwner[CryptoUtils._unpackWarriorId(warriorsData[i], 0)]);
1955         }
1956     }
1957     
1958     function _triggerFinishTournament() internal returns(uint256){
1959         //hold 10 random battles for each composite warrior
1960         uint256[] memory warriorsData = getCombinedWarriors();
1961         uint32[] memory results = CryptoUtils.getTournamentBattleResults(warriorsData, tournamentEndBlock - 1);
1962         //repack combined warriors id
1963         _repackToCombinedIds(warriorsData);
1964         //notify pvp listener
1965         pvpListener.tournamentFinished(warriorsData);
1966         //reschedule
1967         //clear tournament
1968         tournamentQueueSize = 0;
1969         //schedule new tournament
1970         _scheduleTournament();
1971         
1972         uint256 currentBank = currentTournamentBank;
1973         currentTournamentBank = 0;//nullify before sending to users
1974         //grand rewards, not susceptible to reentry attack
1975         //because of require(tournamentEndBlock <= block.number)
1976         //and require(tournamentQueueSize > 0) and currentTournamentBank == 0
1977         uint256 incentiveReward = _grandTournamentRewards(currentBank, warriorsData, results);
1978         
1979         currentTournamentBank = nextTournamentBank;
1980         nextTournamentBank = 0;
1981         
1982         _repackToWarriorOwners(warriorsData);
1983         
1984         //emit event
1985         TournamentFinished(warriorsData, results, currentBank);
1986 
1987         return incentiveReward;
1988     }
1989     
1990     function finishTournament() external whenNotPaused {
1991         //make all the checks
1992         // tournament is ready to be executed
1993         require(tournamentEndBlock <= block.number);
1994         // we have participants
1995         require(tournamentQueueSize > 0);
1996         
1997         uint256 incentiveReward = _triggerFinishTournament();
1998         
1999         //give reward for incentive
2000         safeSend(msg.sender, incentiveReward);
2001     }
2002     
2003     
2004     // @dev Remove all PVP contenders from PVP queue 
2005     //  and return all entrance fees to warrior owners.
2006     //  NB: this is emergency method, used only in f%#^@up situation
2007     function removeAllTournamentContenders() external onlyOwner whenPaused {
2008         //remove all pvp contenders
2009         uint256 length = tournamentQueueSize;
2010         
2011         uint256 warriorId;
2012         uint256 failedBooty;
2013         uint256 i;
2014 
2015         uint256 fee;
2016         uint256 bank = currentTournamentBank;
2017         
2018         uint256[] memory warriorsData = new uint256[](length);
2019         //get tournament warriors
2020         for(i = 0; i < length; i ++) {
2021             warriorsData[i] = tournamentQueue[i * DATA_SIZE];
2022         }
2023         //notify pvp listener
2024         pvpListener.tournamentFinished(warriorsData);
2025         //return entrance fee to warrior owners
2026      	currentTournamentBank = 0;
2027         tournamentQueueSize = 0;
2028 
2029         for(i = length - 1; i >= 0; i --) {
2030             //return entrance fee
2031             warriorId = CryptoUtils._unpackWarriorId(warriorsData[i], 0);
2032             //compute contender entrance fee
2033 			fee = bank - (bank * 10000 / (tournamentEntranceFeeCut * (10000 - THRESHOLD) / 10000 + 10000));
2034 			//return entrance fee to owner
2035 	        failedBooty += sendBooty(warriorToOwner[warriorId], fee);
2036 	        //subtract fee from bank, for next use
2037 	        bank -= fee;
2038         }
2039         currentTournamentBank = bank;
2040         totalBooty += failedBooty;
2041     }
2042 }
2043 
2044 contract BattleProvider is Tournament {
2045     
2046     function BattleProvider(address _pvpListener, uint256 _pvpCut, uint256 _tournamentCut, uint256 _incentiveCut, 
2047     uint256 _tournamentOwnersCut, uint256 _tournamentIncentiveCut) public 
2048     Tournament(_pvpCut, _tournamentCut, _incentiveCut, _tournamentOwnersCut, _tournamentIncentiveCut) 
2049     {
2050         PVPListenerInterface candidateContract = PVPListenerInterface(_pvpListener);
2051         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
2052         require(candidateContract.isPVPListener());
2053         // Set the new contract address
2054         pvpListener = candidateContract;
2055         
2056         paused = true;
2057 
2058         // the creator of the contract is the initial owner
2059         owner = msg.sender;
2060     }
2061     
2062     
2063     // @dev Sanity check that allows us to ensure that we are pointing to the
2064     // right BattleProvider in our setBattleProviderAddress() call.
2065     function isPVPProvider() external pure returns (bool) {
2066         return true;
2067     }
2068     
2069     /// @dev Override unpause so it requires all external contract addresses
2070     ///  to be set before contract can be unpaused.
2071     /// @notice This is public rather than external so we can call super.unpause
2072     ///  without using an expensive CALL.
2073     function unpause() public onlyOwner whenPaused {
2074         require(address(pvpListener) != address(0));
2075 
2076         // Actually unpause the contract.
2077         super.unpause();
2078     }
2079     
2080     function setSecondsPerBlock(uint256 secs) external onlyOwner {
2081         secondsPerBlock = secs;
2082     }
2083 }
2084 
2085 library CryptoUtils {
2086    
2087     /* CLASSES */
2088     uint256 internal constant WARRIOR = 0;
2089     uint256 internal constant ARCHER = 1;
2090     uint256 internal constant MAGE = 2;
2091     /* RARITIES */
2092     uint256 internal constant COMMON = 1;
2093     uint256 internal constant UNCOMMON = 2;
2094     uint256 internal constant RARE = 3;
2095     uint256 internal constant MYTHIC = 4;
2096     uint256 internal constant LEGENDARY = 5;
2097     uint256 internal constant UNIQUE = 6;
2098     /* LIMITS */
2099     uint256 internal constant CLASS_MECHANICS_MAX = 3;
2100     uint256 internal constant RARITY_MAX = 6;
2101     /*@dev range used for rarity chance computation */
2102     uint256 internal constant RARITY_CHANCE_RANGE = 10000000;
2103     uint256 internal constant POINTS_TO_LEVEL = 10;
2104     /* ATTRIBUTE MASKS */
2105     /*@dev range 0-9999 */
2106     uint256 internal constant UNIQUE_MASK_0 = 1;
2107     /*@dev range 0-9 */
2108     uint256 internal constant RARITY_MASK_1 = UNIQUE_MASK_0 * 10000;
2109     /*@dev range 0-999 */
2110     uint256 internal constant CLASS_VIEW_MASK_2 = RARITY_MASK_1 * 10;
2111     /*@dev range 0-999 */
2112     uint256 internal constant BODY_COLOR_MASK_3 = CLASS_VIEW_MASK_2 * 1000;
2113     /*@dev range 0-999 */
2114     uint256 internal constant EYES_MASK_4 = BODY_COLOR_MASK_3 * 1000;
2115     /*@dev range 0-999 */
2116     uint256 internal constant MOUTH_MASK_5 = EYES_MASK_4 * 1000;
2117     /*@dev range 0-999 */
2118     uint256 internal constant HEIR_MASK_6 = MOUTH_MASK_5 * 1000;
2119     /*@dev range 0-999 */
2120     uint256 internal constant HEIR_COLOR_MASK_7 = HEIR_MASK_6 * 1000;
2121     /*@dev range 0-999 */
2122     uint256 internal constant ARMOR_MASK_8 = HEIR_COLOR_MASK_7 * 1000;
2123     /*@dev range 0-999 */
2124     uint256 internal constant WEAPON_MASK_9 = ARMOR_MASK_8 * 1000;
2125     /*@dev range 0-999 */
2126     uint256 internal constant HAT_MASK_10 = WEAPON_MASK_9 * 1000;
2127     /*@dev range 0-99 */
2128     uint256 internal constant RUNES_MASK_11 = HAT_MASK_10 * 1000;
2129     /*@dev range 0-99 */
2130     uint256 internal constant WINGS_MASK_12 = RUNES_MASK_11 * 100;
2131     /*@dev range 0-99 */
2132     uint256 internal constant PET_MASK_13 = WINGS_MASK_12 * 100;
2133     /*@dev range 0-99 */
2134     uint256 internal constant BORDER_MASK_14 = PET_MASK_13 * 100;
2135     /*@dev range 0-99 */
2136     uint256 internal constant BACKGROUND_MASK_15 = BORDER_MASK_14 * 100;
2137     /*@dev range 0-99 */
2138     uint256 internal constant INTELLIGENCE_MASK_16 = BACKGROUND_MASK_15 * 100;
2139     /*@dev range 0-99 */
2140     uint256 internal constant AGILITY_MASK_17 = INTELLIGENCE_MASK_16 * 100;
2141     /*@dev range 0-99 */
2142     uint256 internal constant STRENGTH_MASK_18 = AGILITY_MASK_17 * 100;
2143     /*@dev range 0-9 */
2144     uint256 internal constant CLASS_MECH_MASK_19 = STRENGTH_MASK_18 * 100;
2145     /*@dev range 0-999 */
2146     uint256 internal constant RARITY_BONUS_MASK_20 = CLASS_MECH_MASK_19 * 10;
2147     /*@dev range 0-9 */
2148     uint256 internal constant SPECIALITY_MASK_21 = RARITY_BONUS_MASK_20 * 1000;
2149     /*@dev range 0-99 */
2150     uint256 internal constant DAMAGE_MASK_22 = SPECIALITY_MASK_21 * 10;
2151     /*@dev range 0-99 */
2152     uint256 internal constant AURA_MASK_23 = DAMAGE_MASK_22 * 100;
2153     /*@dev 20 decimals left */
2154     uint256 internal constant BASE_MASK_24 = AURA_MASK_23 * 100;
2155     
2156     
2157     /* SPECIAL PERKS */
2158     uint256 internal constant MINER_PERK = 1;
2159     
2160     
2161     /* PARAM INDEXES */
2162     uint256 internal constant BODY_COLOR_MAX_INDEX_0 = 0;
2163     uint256 internal constant EYES_MAX_INDEX_1 = 1;
2164     uint256 internal constant MOUTH_MAX_2 = 2;
2165     uint256 internal constant HAIR_MAX_3 = 3;
2166     uint256 internal constant HEIR_COLOR_MAX_4 = 4;
2167     uint256 internal constant ARMOR_MAX_5 = 5;
2168     uint256 internal constant WEAPON_MAX_6 = 6;
2169     uint256 internal constant HAT_MAX_7 = 7;
2170     uint256 internal constant RUNES_MAX_8 = 8;
2171     uint256 internal constant WINGS_MAX_9 = 9;
2172     uint256 internal constant PET_MAX_10 = 10;
2173     uint256 internal constant BORDER_MAX_11 = 11;
2174     uint256 internal constant BACKGROUND_MAX_12 = 12;
2175     uint256 internal constant UNIQUE_INDEX_13 = 13;
2176     uint256 internal constant LEGENDARY_INDEX_14 = 14;
2177     uint256 internal constant MYTHIC_INDEX_15 = 15;
2178     uint256 internal constant RARE_INDEX_16 = 16;
2179     uint256 internal constant UNCOMMON_INDEX_17 = 17;
2180     uint256 internal constant UNIQUE_TOTAL_INDEX_18 = 18;
2181     
2182      /* PACK PVP DATA LOGIC */
2183     //pvp data
2184     uint256 internal constant CLASS_PACK_0 = 1;
2185     uint256 internal constant RARITY_BONUS_PACK_1 = CLASS_PACK_0 * 10;
2186     uint256 internal constant RARITY_PACK_2 = RARITY_BONUS_PACK_1 * 1000;
2187     uint256 internal constant EXPERIENCE_PACK_3 = RARITY_PACK_2 * 10;
2188     uint256 internal constant INTELLIGENCE_PACK_4 = EXPERIENCE_PACK_3 * 1000;
2189     uint256 internal constant AGILITY_PACK_5 = INTELLIGENCE_PACK_4 * 100;
2190     uint256 internal constant STRENGTH_PACK_6 = AGILITY_PACK_5 * 100;
2191     uint256 internal constant BASE_DAMAGE_PACK_7 = STRENGTH_PACK_6 * 100;
2192     uint256 internal constant PET_PACK_8 = BASE_DAMAGE_PACK_7 * 100;
2193     uint256 internal constant AURA_PACK_9 = PET_PACK_8 * 100;
2194     uint256 internal constant WARRIOR_ID_PACK_10 = AURA_PACK_9 * 100;
2195     uint256 internal constant PVP_CYCLE_PACK_11 = WARRIOR_ID_PACK_10 * 10**10;
2196     uint256 internal constant RATING_PACK_12 = PVP_CYCLE_PACK_11 * 10**10;
2197     uint256 internal constant PVP_BASE_PACK_13 = RATING_PACK_12 * 10**10;//NB rating must be at the END!
2198     
2199     //tournament data
2200     uint256 internal constant HP_PACK_0 = 1;
2201     uint256 internal constant DAMAGE_PACK_1 = HP_PACK_0 * 10**12;
2202     uint256 internal constant ARMOR_PACK_2 = DAMAGE_PACK_1 * 10**12;
2203     uint256 internal constant DODGE_PACK_3 = ARMOR_PACK_2 * 10**12;
2204     uint256 internal constant PENETRATION_PACK_4 = DODGE_PACK_3 * 10**12;
2205     uint256 internal constant COMBINE_BASE_PACK_5 = PENETRATION_PACK_4 * 10**12;
2206     
2207     /* MISC CONSTANTS */
2208     uint256 internal constant MAX_ID_SIZE = 10000000000;
2209     int256 internal constant PRECISION = 1000000;
2210     
2211     uint256 internal constant BATTLES_PER_CONTENDER = 10;//10x100
2212     uint256 internal constant BATTLES_PER_CONTENDER_SUM = BATTLES_PER_CONTENDER * 100;//10x100
2213     
2214     uint256 internal constant LEVEL_BONUSES = 98898174676155504541373431282523211917151413121110;
2215     
2216     //ucommon bonuses
2217     uint256 internal constant BONUS_NONE = 0;
2218     uint256 internal constant BONUS_HP = 1;
2219     uint256 internal constant BONUS_ARMOR = 2;
2220     uint256 internal constant BONUS_CRIT_CHANCE = 3;
2221     uint256 internal constant BONUS_CRIT_MULT = 4;
2222     uint256 internal constant BONUS_PENETRATION = 5;
2223     //rare bonuses
2224     uint256 internal constant BONUS_STR = 6;
2225     uint256 internal constant BONUS_AGI = 7;
2226     uint256 internal constant BONUS_INT = 8;
2227     uint256 internal constant BONUS_DAMAGE = 9;
2228     
2229     //bonus value database, 
2230     uint256 internal constant BONUS_DATA = 16060606140107152000;
2231     //pets database
2232     uint256 internal constant PETS_DATA = 287164235573728325842459981692000;
2233     
2234     uint256 internal constant PET_AURA = 2;
2235     uint256 internal constant PET_PARAM_1 = 1;
2236     uint256 internal constant PET_PARAM_2 = 0;
2237 
2238     /* GETTERS */
2239 	function getUniqueValue(uint256 identity) internal pure returns(uint256){
2240 		return identity % RARITY_MASK_1;
2241 	}
2242 
2243     function getRarityValue(uint256 identity) internal pure returns(uint256){
2244         return (identity % CLASS_VIEW_MASK_2) / RARITY_MASK_1;
2245     }
2246 
2247 	function getClassViewValue(uint256 identity) internal pure returns(uint256){
2248 		return (identity % BODY_COLOR_MASK_3) / CLASS_VIEW_MASK_2;
2249 	}
2250 
2251 	function getBodyColorValue(uint256 identity) internal pure returns(uint256){
2252         return (identity % EYES_MASK_4) / BODY_COLOR_MASK_3;
2253     }
2254 
2255     function getEyesValue(uint256 identity) internal pure returns(uint256){
2256         return (identity % MOUTH_MASK_5) / EYES_MASK_4;
2257     }
2258 
2259     function getMouthValue(uint256 identity) internal pure returns(uint256){
2260         return (identity % HEIR_MASK_6) / MOUTH_MASK_5;
2261     }
2262 
2263     function getHairValue(uint256 identity) internal pure returns(uint256){
2264         return (identity % HEIR_COLOR_MASK_7) / HEIR_MASK_6;
2265     }
2266 
2267     function getHairColorValue(uint256 identity) internal pure returns(uint256){
2268         return (identity % ARMOR_MASK_8) / HEIR_COLOR_MASK_7;
2269     }
2270 
2271     function getArmorValue(uint256 identity) internal pure returns(uint256){
2272         return (identity % WEAPON_MASK_9) / ARMOR_MASK_8;
2273     }
2274 
2275     function getWeaponValue(uint256 identity) internal pure returns(uint256){
2276         return (identity % HAT_MASK_10) / WEAPON_MASK_9;
2277     }
2278 
2279     function getHatValue(uint256 identity) internal pure returns(uint256){
2280         return (identity % RUNES_MASK_11) / HAT_MASK_10;
2281     }
2282 
2283     function getRunesValue(uint256 identity) internal pure returns(uint256){
2284         return (identity % WINGS_MASK_12) / RUNES_MASK_11;
2285     }
2286 
2287     function getWingsValue(uint256 identity) internal pure returns(uint256){
2288         return (identity % PET_MASK_13) / WINGS_MASK_12;
2289     }
2290 
2291     function getPetValue(uint256 identity) internal pure returns(uint256){
2292         return (identity % BORDER_MASK_14) / PET_MASK_13;
2293     }
2294 
2295 	function getBorderValue(uint256 identity) internal pure returns(uint256){
2296 		return (identity % BACKGROUND_MASK_15) / BORDER_MASK_14;
2297 	}
2298 
2299 	function getBackgroundValue(uint256 identity) internal pure returns(uint256){
2300 		return (identity % INTELLIGENCE_MASK_16) / BACKGROUND_MASK_15;
2301 	}
2302 
2303     function getIntelligenceValue(uint256 identity) internal pure returns(uint256){
2304         return (identity % AGILITY_MASK_17) / INTELLIGENCE_MASK_16;
2305     }
2306 
2307     function getAgilityValue(uint256 identity) internal pure returns(uint256){
2308         return ((identity % STRENGTH_MASK_18) / AGILITY_MASK_17);
2309     }
2310 
2311     function getStrengthValue(uint256 identity) internal pure returns(uint256){
2312         return ((identity % CLASS_MECH_MASK_19) / STRENGTH_MASK_18);
2313     }
2314 
2315     function getClassMechValue(uint256 identity) internal pure returns(uint256){
2316         return (identity % RARITY_BONUS_MASK_20) / CLASS_MECH_MASK_19;
2317     }
2318 
2319     function getRarityBonusValue(uint256 identity) internal pure returns(uint256){
2320         return (identity % SPECIALITY_MASK_21) / RARITY_BONUS_MASK_20;
2321     }
2322 
2323     function getSpecialityValue(uint256 identity) internal pure returns(uint256){
2324         return (identity % DAMAGE_MASK_22) / SPECIALITY_MASK_21;
2325     }
2326     
2327     function getDamageValue(uint256 identity) internal pure returns(uint256){
2328         return (identity % AURA_MASK_23) / DAMAGE_MASK_22;
2329     }
2330 
2331     function getAuraValue(uint256 identity) internal pure returns(uint256){
2332         return ((identity % BASE_MASK_24) / AURA_MASK_23);
2333     }
2334 
2335     /* SETTERS */
2336     function _setUniqueValue0(uint256 value) internal pure returns(uint256){
2337         require(value < RARITY_MASK_1);
2338         return value * UNIQUE_MASK_0;
2339     }
2340 
2341     function _setRarityValue1(uint256 value) internal pure returns(uint256){
2342         require(value < (CLASS_VIEW_MASK_2 / RARITY_MASK_1));
2343         return value * RARITY_MASK_1;
2344     }
2345 
2346     function _setClassViewValue2(uint256 value) internal pure returns(uint256){
2347         require(value < (BODY_COLOR_MASK_3 / CLASS_VIEW_MASK_2));
2348         return value * CLASS_VIEW_MASK_2;
2349     }
2350 
2351     function _setBodyColorValue3(uint256 value) internal pure returns(uint256){
2352         require(value < (EYES_MASK_4 / BODY_COLOR_MASK_3));
2353         return value * BODY_COLOR_MASK_3;
2354     }
2355 
2356     function _setEyesValue4(uint256 value) internal pure returns(uint256){
2357         require(value < (MOUTH_MASK_5 / EYES_MASK_4));
2358         return value * EYES_MASK_4;
2359     }
2360 
2361     function _setMouthValue5(uint256 value) internal pure returns(uint256){
2362         require(value < (HEIR_MASK_6 / MOUTH_MASK_5));
2363         return value * MOUTH_MASK_5;
2364     }
2365 
2366     function _setHairValue6(uint256 value) internal pure returns(uint256){
2367         require(value < (HEIR_COLOR_MASK_7 / HEIR_MASK_6));
2368         return value * HEIR_MASK_6;
2369     }
2370 
2371     function _setHairColorValue7(uint256 value) internal pure returns(uint256){
2372         require(value < (ARMOR_MASK_8 / HEIR_COLOR_MASK_7));
2373         return value * HEIR_COLOR_MASK_7;
2374     }
2375 
2376     function _setArmorValue8(uint256 value) internal pure returns(uint256){
2377         require(value < (WEAPON_MASK_9 / ARMOR_MASK_8));
2378         return value * ARMOR_MASK_8;
2379     }
2380 
2381     function _setWeaponValue9(uint256 value) internal pure returns(uint256){
2382         require(value < (HAT_MASK_10 / WEAPON_MASK_9));
2383         return value * WEAPON_MASK_9;
2384     }
2385 
2386     function _setHatValue10(uint256 value) internal pure returns(uint256){
2387         require(value < (RUNES_MASK_11 / HAT_MASK_10));
2388         return value * HAT_MASK_10;
2389     }
2390 
2391     function _setRunesValue11(uint256 value) internal pure returns(uint256){
2392         require(value < (WINGS_MASK_12 / RUNES_MASK_11));
2393         return value * RUNES_MASK_11;
2394     }
2395 
2396     function _setWingsValue12(uint256 value) internal pure returns(uint256){
2397         require(value < (PET_MASK_13 / WINGS_MASK_12));
2398         return value * WINGS_MASK_12;
2399     }
2400 
2401     function _setPetValue13(uint256 value) internal pure returns(uint256){
2402         require(value < (BORDER_MASK_14 / PET_MASK_13));
2403         return value * PET_MASK_13;
2404     }
2405 
2406     function _setBorderValue14(uint256 value) internal pure returns(uint256){
2407         require(value < (BACKGROUND_MASK_15 / BORDER_MASK_14));
2408         return value * BORDER_MASK_14;
2409     }
2410 
2411     function _setBackgroundValue15(uint256 value) internal pure returns(uint256){
2412         require(value < (INTELLIGENCE_MASK_16 / BACKGROUND_MASK_15));
2413         return value * BACKGROUND_MASK_15;
2414     }
2415 
2416     function _setIntelligenceValue16(uint256 value) internal pure returns(uint256){
2417         require(value < (AGILITY_MASK_17 / INTELLIGENCE_MASK_16));
2418         return value * INTELLIGENCE_MASK_16;
2419     }
2420 
2421     function _setAgilityValue17(uint256 value) internal pure returns(uint256){
2422         require(value < (STRENGTH_MASK_18 / AGILITY_MASK_17));
2423         return value * AGILITY_MASK_17;
2424     }
2425 
2426     function _setStrengthValue18(uint256 value) internal pure returns(uint256){
2427         require(value < (CLASS_MECH_MASK_19 / STRENGTH_MASK_18));
2428         return value * STRENGTH_MASK_18;
2429     }
2430 
2431     function _setClassMechValue19(uint256 value) internal pure returns(uint256){
2432         require(value < (RARITY_BONUS_MASK_20 / CLASS_MECH_MASK_19));
2433         return value * CLASS_MECH_MASK_19;
2434     }
2435 
2436     function _setRarityBonusValue20(uint256 value) internal pure returns(uint256){
2437         require(value < (SPECIALITY_MASK_21 / RARITY_BONUS_MASK_20));
2438         return value * RARITY_BONUS_MASK_20;
2439     }
2440 
2441     function _setSpecialityValue21(uint256 value) internal pure returns(uint256){
2442         require(value < (DAMAGE_MASK_22 / SPECIALITY_MASK_21));
2443         return value * SPECIALITY_MASK_21;
2444     }
2445     
2446     function _setDamgeValue22(uint256 value) internal pure returns(uint256){
2447         require(value < (AURA_MASK_23 / DAMAGE_MASK_22));
2448         return value * DAMAGE_MASK_22;
2449     }
2450 
2451     function _setAuraValue23(uint256 value) internal pure returns(uint256){
2452         require(value < (BASE_MASK_24 / AURA_MASK_23));
2453         return value * AURA_MASK_23;
2454     }
2455     
2456     /* WARRIOR IDENTITY GENERATION */
2457     function _computeRunes(uint256 _rarity) internal pure returns (uint256){
2458         return _rarity > UNCOMMON ? _rarity - UNCOMMON : 0;// 1 + _random(0, max, hash, WINGS_MASK_12, RUNES_MASK_11) : 0;
2459     }
2460 
2461     function _computeWings(uint256 _rarity, uint256 max, uint256 hash) internal pure returns (uint256){
2462         return _rarity > RARE ?  1 + _random(0, max, hash, PET_MASK_13, WINGS_MASK_12) : 0;
2463     }
2464 
2465     function _computePet(uint256 _rarity, uint256 max, uint256 hash) internal pure returns (uint256){
2466         return _rarity > MYTHIC ? 1 + _random(0, max, hash, BORDER_MASK_14, PET_MASK_13) : 0;
2467     }
2468 
2469     function _computeBorder(uint256 _rarity) internal pure returns (uint256){
2470         return _rarity >= COMMON ? _rarity - 1 : 0;
2471     }
2472 
2473     function _computeBackground(uint256 _rarity) internal pure returns (uint256){
2474         return _rarity;
2475     }
2476     
2477     function _unpackPetData(uint256 index) internal pure returns(uint256){
2478         return (PETS_DATA % (1000 ** (index + 1)) / (1000 ** index));
2479     }
2480     
2481     function _getPetBonus1(uint256 _pet) internal pure returns(uint256) {
2482         return (_pet % (10 ** (PET_PARAM_1 + 1)) / (10 ** PET_PARAM_1));
2483     }
2484     
2485     function _getPetBonus2(uint256 _pet) internal pure returns(uint256) {
2486         return (_pet % (10 ** (PET_PARAM_2 + 1)) / (10 ** PET_PARAM_2));
2487     }
2488     
2489     function _getPetAura(uint256 _pet) internal pure returns(uint256) {
2490         return (_pet % (10 ** (PET_AURA + 1)) / (10 ** PET_AURA));
2491     }
2492     
2493     function _getBattleBonus(uint256 _setBonusIndex, uint256 _currentBonusIndex, uint256 _petData, uint256 _warriorAuras, uint256 _petAuras) internal pure returns(int256) {
2494         int256 bonus = 0;
2495         if (_setBonusIndex == _currentBonusIndex) {
2496             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION;
2497         }
2498         //add pet bonuses
2499         if (_setBonusIndex == _getPetBonus1(_petData)) {
2500             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
2501         }
2502         if (_setBonusIndex == _getPetBonus2(_petData)) {
2503             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
2504         }
2505         //add warrior aura bonuses
2506         if (isAuraSet(_warriorAuras, uint8(_setBonusIndex))) {//warriors receive half bonuses from auras
2507             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION / 2;
2508         }
2509         //add pet aura bonuses
2510         if (isAuraSet(_petAuras, uint8(_setBonusIndex))) {//pets receive full bonues from auras
2511             bonus += int256(BONUS_DATA % (100 ** (_setBonusIndex + 1)) / (100 ** _setBonusIndex)) * PRECISION;
2512         }
2513         return bonus;
2514     }
2515     
2516     function _computeRarityBonus(uint256 _rarity, uint256 hash) internal pure returns (uint256){
2517         if (_rarity == UNCOMMON) {
2518             return 1 + _random(0, BONUS_PENETRATION, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
2519         }
2520         if (_rarity == RARE) {
2521             return 1 + _random(BONUS_PENETRATION, BONUS_DAMAGE, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
2522         }
2523         if (_rarity >= MYTHIC) {
2524             return 1 + _random(0, BONUS_DAMAGE, hash, SPECIALITY_MASK_21, RARITY_BONUS_MASK_20);
2525         }
2526         return BONUS_NONE;
2527     }
2528 
2529     function _computeAura(uint256 _rarity, uint256 hash) internal pure returns (uint256){
2530         if (_rarity >= MYTHIC) {
2531             return 1 + _random(0, BONUS_DAMAGE, hash, BASE_MASK_24, AURA_MASK_23);
2532         }
2533         return BONUS_NONE;
2534     }
2535     
2536 	function _computeRarity(uint256 _reward, uint256 _unique, uint256 _legendary, 
2537 	    uint256 _mythic, uint256 _rare, uint256 _uncommon) internal pure returns(uint256){
2538 	        
2539         uint256 range = _unique + _legendary + _mythic + _rare + _uncommon;
2540         if (_reward >= range) return COMMON; // common
2541         if (_reward >= (range = (range - _uncommon))) return UNCOMMON;
2542         if (_reward >= (range = (range - _rare))) return RARE;
2543         if (_reward >= (range = (range - _mythic))) return MYTHIC;
2544         if (_reward >= (range = (range - _legendary))) return LEGENDARY;
2545         if (_reward < range) return UNIQUE;
2546         return COMMON;
2547     }
2548     
2549     function _computeUniqueness(uint256 _rarity, uint256 nextUnique) internal pure returns (uint256){
2550         return _rarity == UNIQUE ? nextUnique : 0;
2551     }
2552     
2553     /* identity packing */
2554     /* @returns bonus value which depends on speciality value,
2555      * if speciality == 1 (miner), then bonus value will be equal 4,
2556      * otherwise 1
2557      */
2558     function _getBonus(uint256 identity) internal pure returns(uint256){
2559         return getSpecialityValue(identity) == MINER_PERK ? 4 : 1;
2560     }
2561     
2562 
2563     function _computeAndSetBaseParameters16_18_22(uint256 _hash) internal pure returns (uint256, uint256){
2564         uint256 identity = 0;
2565 
2566         uint256 damage = 35 + _random(0, 21, _hash, AURA_MASK_23, DAMAGE_MASK_22);
2567         
2568         uint256 strength = 45 + _random(0, 26, _hash, CLASS_MECH_MASK_19, STRENGTH_MASK_18);
2569         uint256 agility = 15 + (125 - damage - strength);
2570         uint256 intelligence = 155 - strength - agility - damage;
2571         (strength, agility, intelligence) = _shuffleParams(strength, agility, intelligence, _hash);
2572         
2573         identity += _setStrengthValue18(strength);
2574         identity += _setAgilityValue17(agility);
2575 		identity += _setIntelligenceValue16(intelligence);
2576 		identity += _setDamgeValue22(damage);
2577         
2578         uint256 classMech = strength > agility ? (strength > intelligence ? WARRIOR : MAGE) : (agility > intelligence ? ARCHER : MAGE);
2579         return (identity, classMech);
2580     }
2581     
2582     function _shuffleParams(uint256 param1, uint256 param2, uint256 param3, uint256 _hash) internal pure returns(uint256, uint256, uint256) {
2583         uint256 temp = param1;
2584         if (_hash % 2 == 0) {
2585             temp = param1;
2586             param1 = param2;
2587             param2 = temp;
2588         }
2589         if ((_hash / 10 % 2) == 0) {
2590             temp = param2;
2591             param2 = param3;
2592             param3 = temp;
2593         }
2594         if ((_hash / 100 % 2) == 0) {
2595             temp = param1;
2596             param1 = param2;
2597             param2 = temp;
2598         }
2599         return (param1, param2, param3);
2600     }
2601     
2602     
2603     /* RANDOM */
2604     function _random(uint256 _min, uint256 _max, uint256 _hash, uint256 _reminder, uint256 _devider) internal pure returns (uint256){
2605         return ((_hash % _reminder) / _devider) % (_max - _min) + _min;
2606     }
2607 
2608     function _random(uint256 _min, uint256 _max, uint256 _hash) internal pure returns (uint256){
2609         return _hash % (_max - _min) + _min;
2610     }
2611 
2612     function _getTargetBlock(uint256 _targetBlock) internal view returns(uint256){
2613         uint256 currentBlock = block.number;
2614         uint256 target = currentBlock - (currentBlock % 256) + (_targetBlock % 256);
2615         if (target >= currentBlock) {
2616             return (target - 256);
2617         }
2618         return target;
2619     }
2620     
2621     function _getMaxRarityChance() internal pure returns(uint256){
2622         return RARITY_CHANCE_RANGE;
2623     }
2624     
2625     function generateWarrior(uint256 _heroIdentity, uint256 _heroLevel, uint256 _targetBlock, uint256 specialPerc, uint32[19] memory params) internal view returns (uint256) {
2626         _targetBlock = _getTargetBlock(_targetBlock);
2627         
2628         uint256 identity;
2629         uint256 hash = uint256(keccak256(block.blockhash(_targetBlock), _heroIdentity, block.coinbase, block.difficulty));
2630         //0 _heroLevel produces warriors of COMMON rarity
2631         uint256 rarityChance = _heroLevel == 0 ? RARITY_CHANCE_RANGE : 
2632         	_random(0, RARITY_CHANCE_RANGE, hash) / (_heroLevel * _getBonus(_heroIdentity)); // 0 - 10 000 000
2633         uint256 rarity = _computeRarity(rarityChance, 
2634             params[UNIQUE_INDEX_13],params[LEGENDARY_INDEX_14], params[MYTHIC_INDEX_15], params[RARE_INDEX_16], params[UNCOMMON_INDEX_17]);
2635             
2636         uint256 classMech;
2637         
2638         // start
2639         (identity, classMech) = _computeAndSetBaseParameters16_18_22(hash);
2640         
2641         identity += _setUniqueValue0(_computeUniqueness(rarity, params[UNIQUE_TOTAL_INDEX_18] + 1));
2642         identity += _setRarityValue1(rarity);
2643         identity += _setClassViewValue2(classMech); // 1 to 1 with classMech
2644         
2645         identity += _setBodyColorValue3(1 + _random(0, params[BODY_COLOR_MAX_INDEX_0], hash, EYES_MASK_4, BODY_COLOR_MASK_3));
2646         identity += _setEyesValue4(1 + _random(0, params[EYES_MAX_INDEX_1], hash, MOUTH_MASK_5, EYES_MASK_4));
2647         identity += _setMouthValue5(1 + _random(0, params[MOUTH_MAX_2], hash, HEIR_MASK_6, MOUTH_MASK_5));
2648         identity += _setHairValue6(1 + _random(0, params[HAIR_MAX_3], hash, HEIR_COLOR_MASK_7, HEIR_MASK_6));
2649         identity += _setHairColorValue7(1 + _random(0, params[HEIR_COLOR_MAX_4], hash, ARMOR_MASK_8, HEIR_COLOR_MASK_7));
2650         identity += _setArmorValue8(1 + _random(0, params[ARMOR_MAX_5], hash, WEAPON_MASK_9, ARMOR_MASK_8));
2651         identity += _setWeaponValue9(1 + _random(0, params[WEAPON_MAX_6], hash, HAT_MASK_10, WEAPON_MASK_9));
2652         identity += _setHatValue10(_random(0, params[HAT_MAX_7], hash, RUNES_MASK_11, HAT_MASK_10));//removed +1
2653         
2654         identity += _setRunesValue11(_computeRunes(rarity));
2655         identity += _setWingsValue12(_computeWings(rarity, params[WINGS_MAX_9], hash));
2656         identity += _setPetValue13(_computePet(rarity, params[PET_MAX_10], hash));
2657         identity += _setBorderValue14(_computeBorder(rarity)); // 1 to 1 with rarity
2658         identity += _setBackgroundValue15(_computeBackground(rarity)); // 1 to 1 with rarity
2659         
2660         identity += _setClassMechValue19(classMech);
2661 
2662         identity += _setRarityBonusValue20(_computeRarityBonus(rarity, hash));
2663         identity += _setSpecialityValue21(specialPerc); // currently only miner (1)
2664         
2665         identity += _setAuraValue23(_computeAura(rarity, hash));
2666         // end
2667         return identity;
2668     }
2669     
2670 	function _changeParameter(uint256 _paramIndex, uint32 _value, uint32[19] storage parameters) internal {
2671 		//we can change only view parameters, and unique count in max range <= 100
2672 		require(_paramIndex >= BODY_COLOR_MAX_INDEX_0 && _paramIndex <= UNIQUE_INDEX_13);
2673 		//we can NOT set pet, border and background values,
2674 		//those values have special logic behind them
2675 		require(
2676 		    _paramIndex != RUNES_MAX_8 && 
2677 		    _paramIndex != PET_MAX_10 && 
2678 		    _paramIndex != BORDER_MAX_11 && 
2679 		    _paramIndex != BACKGROUND_MAX_12
2680 		);
2681 		//value of bodyColor, eyes, mouth, hair, hairColor, armor, weapon, hat must be < 1000
2682 		require(_paramIndex > HAT_MAX_7 || _value < 1000);
2683 		//value of wings,  must be < 100
2684 		require(_paramIndex > BACKGROUND_MAX_12 || _value < 100);
2685 		//check that max total number of UNIQUE warriors that we can emit is not > 100
2686 		require(_paramIndex != UNIQUE_INDEX_13 || (_value + parameters[UNIQUE_TOTAL_INDEX_18]) <= 100);
2687 		
2688 		parameters[_paramIndex] = _value;
2689     }
2690     
2691 	function _recordWarriorData(uint256 identity, uint32[19] storage parameters) internal {
2692         uint256 rarity = getRarityValue(identity);
2693         if (rarity == UNCOMMON) { // uncommon
2694             parameters[UNCOMMON_INDEX_17]--;
2695             return;
2696         }
2697         if (rarity == RARE) { // rare
2698             parameters[RARE_INDEX_16]--;
2699             return;
2700         }
2701         if (rarity == MYTHIC) { // mythic
2702             parameters[MYTHIC_INDEX_15]--;
2703             return;
2704         }
2705         if (rarity == LEGENDARY) { // legendary
2706             parameters[LEGENDARY_INDEX_14]--;
2707             return;
2708         }
2709         if (rarity == UNIQUE) { // unique
2710             parameters[UNIQUE_INDEX_13]--;
2711             parameters[UNIQUE_TOTAL_INDEX_18] ++;
2712             return;
2713         }
2714     }
2715     
2716     function _validateIdentity(uint256 _identity, uint32[19] memory params) internal pure returns(bool){
2717         uint256 rarity = getRarityValue(_identity);
2718         require(rarity <= UNIQUE);
2719         
2720         require(
2721             rarity <= COMMON ||//common 
2722             (rarity == UNCOMMON && params[UNCOMMON_INDEX_17] > 0) ||//uncommon
2723             (rarity == RARE && params[RARE_INDEX_16] > 0) ||//rare
2724             (rarity == MYTHIC && params[MYTHIC_INDEX_15] > 0) ||//mythic
2725             (rarity == LEGENDARY && params[LEGENDARY_INDEX_14] > 0) ||//legendary
2726             (rarity == UNIQUE && params[UNIQUE_INDEX_13] > 0)//unique
2727         );
2728         require(rarity != UNIQUE || getUniqueValue(_identity) > params[UNIQUE_TOTAL_INDEX_18]);
2729         
2730         //check battle parameters
2731         require(
2732             getStrengthValue(_identity) < 100 &&
2733             getAgilityValue(_identity) < 100 &&
2734             getIntelligenceValue(_identity) < 100 &&
2735             getDamageValue(_identity) <= 55
2736         );
2737         require(getClassMechValue(_identity) <= MAGE);
2738         require(getClassMechValue(_identity) == getClassViewValue(_identity));
2739         require(getSpecialityValue(_identity) <= MINER_PERK);
2740         require(getRarityBonusValue(_identity) <= BONUS_DAMAGE);
2741         require(getAuraValue(_identity) <= BONUS_DAMAGE);
2742         
2743         //check view
2744         require(getBodyColorValue(_identity) <= params[BODY_COLOR_MAX_INDEX_0]);
2745         require(getEyesValue(_identity) <= params[EYES_MAX_INDEX_1]);
2746         require(getMouthValue(_identity) <= params[MOUTH_MAX_2]);
2747         require(getHairValue(_identity) <= params[HAIR_MAX_3]);
2748         require(getHairColorValue(_identity) <= params[HEIR_COLOR_MAX_4]);
2749         require(getArmorValue(_identity) <= params[ARMOR_MAX_5]);
2750         require(getWeaponValue(_identity) <= params[WEAPON_MAX_6]);
2751         require(getHatValue(_identity) <= params[HAT_MAX_7]);
2752         require(getRunesValue(_identity) <= params[RUNES_MAX_8]);
2753         require(getWingsValue(_identity) <= params[WINGS_MAX_9]);
2754         require(getPetValue(_identity) <= params[PET_MAX_10]);
2755         require(getBorderValue(_identity) <= params[BORDER_MAX_11]);
2756         require(getBackgroundValue(_identity) <= params[BACKGROUND_MAX_12]);
2757         
2758         return true;
2759     }
2760     
2761     /* UNPACK METHODS */
2762     //common
2763     function _unpackClassValue(uint256 packedValue) internal pure returns(uint256){
2764         return (packedValue % RARITY_PACK_2 / CLASS_PACK_0);
2765     }
2766     
2767     function _unpackRarityBonusValue(uint256 packedValue) internal pure returns(uint256){
2768         return (packedValue % RARITY_PACK_2 / RARITY_BONUS_PACK_1);
2769     }
2770     
2771     function _unpackRarityValue(uint256 packedValue) internal pure returns(uint256){
2772         return (packedValue % EXPERIENCE_PACK_3 / RARITY_PACK_2);
2773     }
2774     
2775     function _unpackExpValue(uint256 packedValue) internal pure returns(uint256){
2776         return (packedValue % INTELLIGENCE_PACK_4 / EXPERIENCE_PACK_3);
2777     }
2778 
2779     function _unpackLevelValue(uint256 packedValue) internal pure returns(uint256){
2780         return (packedValue % INTELLIGENCE_PACK_4) / (EXPERIENCE_PACK_3 * POINTS_TO_LEVEL);
2781     }
2782     
2783     function _unpackIntelligenceValue(uint256 packedValue) internal pure returns(int256){
2784         return int256(packedValue % AGILITY_PACK_5 / INTELLIGENCE_PACK_4);
2785     }
2786     
2787     function _unpackAgilityValue(uint256 packedValue) internal pure returns(int256){
2788         return int256(packedValue % STRENGTH_PACK_6 / AGILITY_PACK_5);
2789     }
2790     
2791     function _unpackStrengthValue(uint256 packedValue) internal pure returns(int256){
2792         return int256(packedValue % BASE_DAMAGE_PACK_7 / STRENGTH_PACK_6);
2793     }
2794 
2795     function _unpackBaseDamageValue(uint256 packedValue) internal pure returns(int256){
2796         return int256(packedValue % PET_PACK_8 / BASE_DAMAGE_PACK_7);
2797     }
2798     
2799     function _unpackPetValue(uint256 packedValue) internal pure returns(uint256){
2800         return (packedValue % AURA_PACK_9 / PET_PACK_8);
2801     }
2802     
2803     function _unpackAuraValue(uint256 packedValue) internal pure returns(uint256){
2804         return (packedValue % WARRIOR_ID_PACK_10 / AURA_PACK_9);
2805     }
2806     //
2807     //pvp unpack
2808     function _unpackIdValue(uint256 packedValue) internal pure returns(uint256){
2809         return (packedValue % PVP_CYCLE_PACK_11 / WARRIOR_ID_PACK_10);
2810     }
2811     
2812     function _unpackCycleValue(uint256 packedValue) internal pure returns(uint256){
2813         return (packedValue % RATING_PACK_12 / PVP_CYCLE_PACK_11);
2814     }
2815     
2816     function _unpackRatingValue(uint256 packedValue) internal pure returns(uint256){
2817         return (packedValue % PVP_BASE_PACK_13 / RATING_PACK_12);
2818     }
2819     
2820     //max cycle skip value cant be more than 1000000000
2821     function _changeCycleValue(uint256 packedValue, uint256 newValue) internal pure returns(uint256){
2822         newValue = newValue > 1000000000 ? 1000000000 : newValue;
2823         return packedValue - (_unpackCycleValue(packedValue) * PVP_CYCLE_PACK_11) + newValue * PVP_CYCLE_PACK_11;
2824     }
2825     
2826     function _packWarriorCommonData(uint256 _identity, uint256 _experience) internal pure returns(uint256){
2827         uint256 packedData = 0;
2828         packedData += getClassMechValue(_identity) * CLASS_PACK_0;
2829         packedData += getRarityBonusValue(_identity) * RARITY_BONUS_PACK_1;
2830         packedData += getRarityValue(_identity) * RARITY_PACK_2;
2831         packedData += _experience * EXPERIENCE_PACK_3;
2832         packedData += getIntelligenceValue(_identity) * INTELLIGENCE_PACK_4;
2833         packedData += getAgilityValue(_identity) * AGILITY_PACK_5;
2834         packedData += getStrengthValue(_identity) * STRENGTH_PACK_6;
2835         packedData += getDamageValue(_identity) * BASE_DAMAGE_PACK_7;
2836         packedData += getPetValue(_identity) * PET_PACK_8;
2837         
2838         return packedData;
2839     }
2840     
2841     function _packWarriorPvpData(uint256 _identity, uint256 _rating, uint256 _pvpCycle, uint256 _warriorId, uint256 _experience) internal pure returns(uint256){
2842         uint256 packedData = _packWarriorCommonData(_identity, _experience);
2843         packedData += _warriorId * WARRIOR_ID_PACK_10;
2844         packedData += _pvpCycle * PVP_CYCLE_PACK_11;
2845         //rating MUST have most significant value!
2846         packedData += _rating * RATING_PACK_12;
2847         return packedData;
2848     }
2849     
2850     /* TOURNAMENT BATTLES */
2851     
2852     
2853     function _packWarriorIds(uint256[] memory packedWarriors) internal pure returns(uint256){
2854         uint256 packedIds = 0;
2855         uint256 length = packedWarriors.length;
2856         for(uint256 i = 0; i < length; i ++) {
2857             packedIds += (MAX_ID_SIZE ** i) * _unpackIdValue(packedWarriors[i]);
2858         }
2859         return packedIds;
2860     }
2861 
2862     function _unpackWarriorId(uint256 packedIds, uint256 index) internal pure returns(uint256){
2863         return (packedIds % (MAX_ID_SIZE ** (index + 1)) / (MAX_ID_SIZE ** index));
2864     }
2865     
2866     function _packCombinedParams(int256 hp, int256 damage, int256 armor, int256 dodge, int256 penetration) internal pure returns(uint256) {
2867         uint256 combinedWarrior = 0;
2868         combinedWarrior += uint256(hp) * HP_PACK_0;
2869         combinedWarrior += uint256(damage) * DAMAGE_PACK_1;
2870         combinedWarrior += uint256(armor) * ARMOR_PACK_2;
2871         combinedWarrior += uint256(dodge) * DODGE_PACK_3;
2872         combinedWarrior += uint256(penetration) * PENETRATION_PACK_4;
2873         return combinedWarrior;
2874     }
2875     
2876     function _unpackProtectionParams(uint256 combinedWarrior) internal pure returns 
2877     (int256 hp, int256 armor, int256 dodge){
2878         hp = int256(combinedWarrior % DAMAGE_PACK_1 / HP_PACK_0);
2879         armor = int256(combinedWarrior % DODGE_PACK_3 / ARMOR_PACK_2);
2880         dodge = int256(combinedWarrior % PENETRATION_PACK_4 / DODGE_PACK_3);
2881     }
2882     
2883     function _unpackAttackParams(uint256 combinedWarrior) internal pure returns(int256 damage, int256 penetration) {
2884         damage = int256(combinedWarrior % ARMOR_PACK_2 / DAMAGE_PACK_1);
2885         penetration = int256(combinedWarrior % COMBINE_BASE_PACK_5 / PENETRATION_PACK_4);
2886     }
2887     
2888     function _combineWarriors(uint256[] memory packedWarriors) internal pure returns (uint256) {
2889         int256 hp;
2890         int256 damage;
2891 		int256 armor;
2892 		int256 dodge;
2893 		int256 penetration;
2894 		
2895 		(hp, damage, armor, dodge, penetration) = _computeCombinedParams(packedWarriors);
2896         return _packCombinedParams(hp, damage, armor, dodge, penetration);
2897     }
2898     
2899     function _computeCombinedParams(uint256[] memory packedWarriors) internal pure returns 
2900     (int256 totalHp, int256 totalDamage, int256 maxArmor, int256 maxDodge, int256 maxPenetration){
2901         uint256 length = packedWarriors.length;
2902         
2903         int256 hp;
2904 		int256 armor;
2905 		int256 dodge;
2906 		int256 penetration;
2907 		
2908 		uint256 warriorAuras;
2909 		uint256 petAuras;
2910 		(warriorAuras, petAuras) = _getAurasData(packedWarriors);
2911 		
2912 		uint256 packedWarrior;
2913         for(uint256 i = 0; i < length; i ++) {
2914             packedWarrior = packedWarriors[i];
2915             
2916             totalDamage += getDamage(packedWarrior, warriorAuras, petAuras);
2917             
2918             penetration = getPenetration(packedWarrior, warriorAuras, petAuras);
2919             maxPenetration = maxPenetration > penetration ? maxPenetration : penetration;
2920 			(hp, armor, dodge) = _getProtectionParams(packedWarrior, warriorAuras, petAuras);
2921             totalHp += hp;
2922             maxArmor = maxArmor > armor ? maxArmor : armor;
2923             maxDodge = maxDodge > dodge ? maxDodge : dodge;
2924         }
2925     }
2926     
2927     function _getAurasData(uint256[] memory packedWarriors) internal pure returns(uint256 warriorAuras, uint256 petAuras) {
2928         uint256 length = packedWarriors.length;
2929         
2930         warriorAuras = 0;
2931         petAuras = 0;
2932         
2933         uint256 packedWarrior;
2934         for(uint256 i = 0; i < length; i ++) {
2935             packedWarrior = packedWarriors[i];
2936             warriorAuras = enableAura(warriorAuras, (_unpackAuraValue(packedWarrior)));
2937             petAuras = enableAura(petAuras, (_getPetAura(_unpackPetData(_unpackPetValue(packedWarrior)))));
2938         }
2939         warriorAuras = filterWarriorAuras(warriorAuras, petAuras);
2940         return (warriorAuras, petAuras);
2941     }
2942     
2943     // Get bit value at position
2944     function isAuraSet(uint256 aura, uint256 auraIndex) internal pure returns (bool) {
2945         return aura & (uint256(0x01) << auraIndex) != 0;
2946     }
2947     
2948     // Set bit value at position
2949     function enableAura(uint256 a, uint256 n) internal pure returns (uint256) {
2950         return a | (uint256(0x01) << n);
2951     }
2952     
2953     //switch off warrior auras that are enabled in pets auras, pet aura have priority
2954     function filterWarriorAuras(uint256 _warriorAuras, uint256 _petAuras) internal pure returns(uint256) {
2955         return (_warriorAuras & _petAuras) ^ _warriorAuras;
2956     }
2957   
2958     function _getTournamentBattles(uint256 _numberOfContenders) internal pure returns(uint256) {
2959         return (_numberOfContenders * BATTLES_PER_CONTENDER / 2);
2960     }
2961     
2962     function getTournamentBattleResults(uint256[] memory combinedWarriors, uint256 _targetBlock) internal view returns (uint32[] memory results){
2963         uint256 length = combinedWarriors.length;
2964         results = new uint32[](length);
2965 		
2966 		int256 damage1;
2967 		int256 penetration1;
2968 		
2969 		uint256 hash;
2970 		
2971 		uint256 randomIndex;
2972 		uint256 exp = 0;
2973 		uint256 i;
2974 		uint256 result;
2975         for(i = 0; i < length; i ++) {
2976             (damage1, penetration1) = _unpackAttackParams(combinedWarriors[i]);
2977             while(results[i] < BATTLES_PER_CONTENDER_SUM) {
2978                 //if we just started generate new random source
2979                 //or regenerate if we used all data from it
2980                 if (exp == 0 || exp > 73) {
2981                     hash = uint256(keccak256(block.blockhash(_getTargetBlock(_targetBlock - i)), uint256(damage1) + now));
2982                     exp = 0;
2983                 }
2984                 //we do not fight with self if there are other warriors
2985                 randomIndex = (_random(i + 1 < length ? i + 1 : i, length, hash, 1000 * 10**exp, 10**exp));
2986                 result = getTournamentBattleResult(damage1, penetration1, combinedWarriors[i],
2987                     combinedWarriors[randomIndex], hash % (1000 * 10**exp) / 10**exp);
2988                 results[result == 1 ? i : randomIndex] += 101;//icrement battle count 100 and +1 win
2989                 results[result == 1 ? randomIndex : i] += 100;//increment only battle count 100 for loser
2990                 if (results[randomIndex] >= BATTLES_PER_CONTENDER_SUM) {
2991                     if (randomIndex < length - 1) {
2992                         _swapValues(combinedWarriors, results, randomIndex, length - 1);
2993                     }
2994                     length --;
2995                 }
2996                 exp++;
2997             }
2998         }
2999         //filter battle count from results
3000         length = combinedWarriors.length;
3001         for(i = 0; i < length; i ++) {
3002             results[i] = results[i] % 100;
3003         }
3004         
3005         return results;
3006     }
3007     
3008     function _swapValues(uint256[] memory combinedWarriors, uint32[] memory results, uint256 id1, uint256 id2) internal pure {
3009         uint256 temp = combinedWarriors[id1];
3010         combinedWarriors[id1] = combinedWarriors[id2];
3011         combinedWarriors[id2] = temp;
3012         temp = results[id1];
3013         results[id1] = results[id2];
3014         results[id2] = uint32(temp);
3015     }
3016 
3017     function getTournamentBattleResult(int256 damage1, int256 penetration1, uint256 combinedWarrior1, 
3018         uint256 combinedWarrior2, uint256 randomSource) internal pure returns (uint256)
3019     {
3020         int256 damage2;
3021 		int256 penetration2;
3022         
3023 		(damage2, penetration2) = _unpackAttackParams(combinedWarrior1);
3024 
3025 		int256 totalHp1 = getCombinedTotalHP(combinedWarrior1, penetration2);
3026 		int256 totalHp2 = getCombinedTotalHP(combinedWarrior2, penetration1);
3027         
3028         return _getBattleResult(damage1 * getBattleRandom(randomSource, 1) / 100, damage2 * getBattleRandom(randomSource, 10) / 100, totalHp1, totalHp2, randomSource);
3029     }
3030     /* COMMON BATTLE */
3031     
3032     function _getBattleResult(int256 damage1, int256 damage2, int256 totalHp1, int256 totalHp2, uint256 randomSource)  internal pure returns (uint256){
3033 		totalHp1 = (totalHp1 * (PRECISION * PRECISION) / damage2);
3034 		totalHp2 = (totalHp2 * (PRECISION * PRECISION) / damage1);
3035 		//if draw, let the coin decide who wins
3036 		if (totalHp1 == totalHp2) return randomSource % 2 + 1;
3037 		return totalHp1 > totalHp2 ? 1 : 2;       
3038     }
3039     
3040     function getCombinedTotalHP(uint256 combinedData, int256 enemyPenetration) internal pure returns(int256) {
3041         int256 hp;
3042 		int256 armor;
3043 		int256 dodge;
3044 		(hp, armor, dodge) = _unpackProtectionParams(combinedData);
3045         
3046         return _getTotalHp(hp, armor, dodge, enemyPenetration);
3047     }
3048     
3049     function getTotalHP(uint256 packedData, uint256 warriorAuras, uint256 petAuras, int256 enemyPenetration) internal pure returns(int256) {
3050         int256 hp;
3051 		int256 armor;
3052 		int256 dodge;
3053 		(hp, armor, dodge) = _getProtectionParams(packedData, warriorAuras, petAuras);
3054         
3055         return _getTotalHp(hp, armor, dodge, enemyPenetration);
3056     }
3057     
3058     function _getTotalHp(int256 hp, int256 armor, int256 dodge, int256 enemyPenetration) internal pure returns(int256) {
3059         int256 piercingResult = (armor - enemyPenetration) < -(75 * PRECISION) ? -(75 * PRECISION) : (armor - enemyPenetration);
3060         int256 mitigation = (PRECISION - piercingResult * PRECISION / (PRECISION + piercingResult / 100) / 100);
3061         
3062         return (hp * PRECISION / mitigation + (hp * dodge / (100 * PRECISION)));
3063     }
3064     
3065     function _applyLevelBonus(int256 _value, uint256 _level) internal pure returns(int256) {
3066         _level -= 1;
3067         return int256(uint256(_value) * (LEVEL_BONUSES % (100 ** (_level + 1)) / (100 ** _level)) / 10);
3068     }
3069     
3070     function _getProtectionParams(uint256 packedData, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256 hp, int256 armor, int256 dodge) {
3071         uint256 rarityBonus = _unpackRarityBonusValue(packedData);
3072         uint256 petData = _unpackPetData(_unpackPetValue(packedData));
3073         int256 strength = _unpackStrengthValue(packedData) * PRECISION + _getBattleBonus(BONUS_STR, rarityBonus, petData, warriorAuras, petAuras);
3074         int256 agility = _unpackAgilityValue(packedData) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
3075         
3076         hp = 100 * PRECISION + strength + 7 * strength / 10 + _getBattleBonus(BONUS_HP, rarityBonus, petData, warriorAuras, petAuras);//add bonus hp
3077         hp = _applyLevelBonus(hp, _unpackLevelValue(packedData));
3078 		armor = (strength + 8 * strength / 10 + agility + _getBattleBonus(BONUS_ARMOR, rarityBonus, petData, warriorAuras, petAuras));//add bonus armor
3079 		dodge = (2 * agility / 3);
3080     }
3081     
3082     function getDamage(uint256 packedWarrior, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256) {
3083         uint256 rarityBonus = _unpackRarityBonusValue(packedWarrior);
3084         uint256 petData = _unpackPetData(_unpackPetValue(packedWarrior));
3085         int256 agility = _unpackAgilityValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
3086         int256 intelligence = _unpackIntelligenceValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_INT, rarityBonus, petData, warriorAuras, petAuras);
3087 		
3088 		int256 crit = (agility / 5 + intelligence / 4) + _getBattleBonus(BONUS_CRIT_CHANCE, rarityBonus, petData, warriorAuras, petAuras);
3089 		int256 critMultiplier = (PRECISION + intelligence / 25) + _getBattleBonus(BONUS_CRIT_MULT, rarityBonus, petData, warriorAuras, petAuras);
3090         
3091         int256 damage = int256(_unpackBaseDamageValue(packedWarrior) * 3 * PRECISION / 2) + _getBattleBonus(BONUS_DAMAGE, rarityBonus, petData, warriorAuras, petAuras);
3092         
3093 		return (_applyLevelBonus(damage, _unpackLevelValue(packedWarrior)) * (PRECISION + crit * critMultiplier / (100 * PRECISION))) / PRECISION;
3094     }
3095 
3096     function getPenetration(uint256 packedWarrior, uint256 warriorAuras, uint256 petAuras) internal pure returns(int256) {
3097         uint256 rarityBonus = _unpackRarityBonusValue(packedWarrior);
3098         uint256 petData = _unpackPetData(_unpackPetValue(packedWarrior));
3099         int256 agility = _unpackAgilityValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_AGI, rarityBonus, petData, warriorAuras, petAuras);
3100         int256 intelligence = _unpackIntelligenceValue(packedWarrior) * PRECISION + _getBattleBonus(BONUS_INT, rarityBonus, petData, warriorAuras, petAuras);
3101 		
3102 		return (intelligence * 2 + agility + _getBattleBonus(BONUS_PENETRATION, rarityBonus, petData, warriorAuras, petAuras));
3103     }
3104     
3105     /* BATTLE PVP */
3106     
3107     //@param randomSource must be >= 1000
3108     function getBattleRandom(uint256 randmSource, uint256 _step) internal pure returns(int256){
3109         return int256(100 + _random(0, 11, randmSource, 100 * _step, _step));
3110     }
3111     
3112     uint256 internal constant NO_AURA = 0;
3113     
3114     function getPVPBattleResult(uint256 packedData1, uint256 packedData2, uint256 randmSource) internal pure returns (uint256){
3115         uint256 petAura1 = _computePVPPetAura(packedData1);
3116         uint256 petAura2 = _computePVPPetAura(packedData2);
3117         
3118         uint256 warriorAura1 = _computePVPWarriorAura(packedData1, petAura1);
3119         uint256 warriorAura2 = _computePVPWarriorAura(packedData2, petAura2);
3120         
3121 		int256 damage1 = getDamage(packedData1, warriorAura1, petAura1) * getBattleRandom(randmSource, 1) / 100;
3122         int256 damage2 = getDamage(packedData2, warriorAura2, petAura2) * getBattleRandom(randmSource, 10) / 100;
3123 
3124 		int256 totalHp1;
3125 		int256 totalHp2;
3126 		(totalHp1, totalHp2) = _computeContendersTotalHp(packedData1, warriorAura1, petAura1, packedData2, warriorAura1, petAura1);
3127         
3128         return _getBattleResult(damage1, damage2, totalHp1, totalHp2, randmSource);
3129     }
3130     
3131     function _computePVPPetAura(uint256 packedData) internal pure returns(uint256) {
3132         return enableAura(NO_AURA, _getPetAura(_unpackPetData(_unpackPetValue(packedData))));
3133     }
3134     
3135     function _computePVPWarriorAura(uint256 packedData, uint256 petAuras) internal pure returns(uint256) {
3136         return filterWarriorAuras(enableAura(NO_AURA, _unpackAuraValue(packedData)), petAuras);
3137     }
3138     
3139     function _computeContendersTotalHp(uint256 packedData1, uint256 warriorAura1, uint256 petAura1, uint256 packedData2, uint256 warriorAura2, uint256 petAura2) 
3140     internal pure returns(int256 totalHp1, int256 totalHp2) {
3141 		int256 enemyPenetration = getPenetration(packedData2, warriorAura2, petAura2);
3142 		totalHp1 = getTotalHP(packedData1, warriorAura1, petAura1, enemyPenetration);
3143 		enemyPenetration = getPenetration(packedData1, warriorAura1, petAura1);
3144 		totalHp2 = getTotalHP(packedData2, warriorAura1, petAura1, enemyPenetration);
3145     }
3146     
3147     function getRatingRange(uint256 _pvpCycle, uint256 _pvpInterval, uint256 _expandInterval) internal pure returns (uint256){
3148         return 50 + (_pvpCycle * _pvpInterval / _expandInterval * 25);
3149     }
3150     
3151     function isMatching(int256 evenRating, int256 oddRating, int256 ratingGap) internal pure returns(bool) {
3152         return evenRating <= (oddRating + ratingGap) && evenRating >= (oddRating - ratingGap);
3153     }
3154     
3155     function sort(uint256[] memory data) internal pure {
3156        quickSort(data, int(0), int(data.length - 1));
3157     }
3158     
3159     function quickSort(uint256[] memory arr, int256 left, int256 right) internal pure {
3160         int256 i = left;
3161         int256 j = right;
3162         if(i==j) return;
3163         uint256 pivot = arr[uint256(left + (right - left) / 2)];
3164         while (i <= j) {
3165             while (arr[uint256(i)] < pivot) i++;
3166             while (pivot < arr[uint256(j)]) j--;
3167             if (i <= j) {
3168                 (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
3169                 i++;
3170                 j--;
3171             }
3172         }
3173         if (left < j)
3174             quickSort(arr, left, j);
3175         if (i < right)
3176             quickSort(arr, i, right);
3177     }
3178     
3179     function _swapPair(uint256[] memory matchingIds, uint256 id1, uint256 id2, uint256 id3, uint256 id4) internal pure {
3180         uint256 temp = matchingIds[id1];
3181         matchingIds[id1] = matchingIds[id2];
3182         matchingIds[id2] = temp;
3183         
3184         temp = matchingIds[id3];
3185         matchingIds[id3] = matchingIds[id4];
3186         matchingIds[id4] = temp;
3187     }
3188     
3189     function _swapValues(uint256[] memory matchingIds, uint256 id1, uint256 id2) internal pure {
3190         uint256 temp = matchingIds[id1];
3191         matchingIds[id1] = matchingIds[id2];
3192         matchingIds[id2] = temp;
3193     }
3194     
3195     function _getMatchingIds(uint256[] memory matchingIds, uint256 _pvpInterval, uint256 _skipCycles, uint256 _expandInterval) 
3196     internal pure returns(uint256 matchingCount) 
3197     {
3198         matchingCount = matchingIds.length;
3199         if (matchingCount == 0) return 0;
3200         
3201         uint256 warriorId;
3202         uint256 index;
3203         //sort matching ids
3204         quickSort(matchingIds, int256(0), int256(matchingCount - 1));
3205         //find pairs
3206         int256 rating1;
3207         uint256 pairIndex = 0;
3208         int256 ratingRange;
3209         for(index = 0; index < matchingCount; index++) {
3210             //get packed value
3211             warriorId = matchingIds[index];
3212             //unpack rating 1
3213             rating1 = int256(_unpackRatingValue(warriorId));
3214             ratingRange = int256(getRatingRange(_unpackCycleValue(warriorId) + _skipCycles, _pvpInterval, _expandInterval));
3215             
3216             if (index > pairIndex && //check left neighbor
3217             isMatching(rating1, int256(_unpackRatingValue(matchingIds[index - 1])), ratingRange)) {
3218                 //move matched pairs to the left
3219                 //swap pairs
3220                 _swapPair(matchingIds, pairIndex, index - 1, pairIndex + 1, index);
3221                 //mark last pair position
3222                 pairIndex += 2;
3223             } else if (index + 1 < matchingCount && //check right neighbor
3224             isMatching(rating1, int256(_unpackRatingValue(matchingIds[index + 1])), ratingRange)) {
3225                 //move matched pairs to the left
3226                 //swap pairs
3227                 _swapPair(matchingIds, pairIndex, index, pairIndex + 1, index + 1);
3228                 //mark last pair position
3229                 pairIndex += 2;
3230                 //skip next iteration
3231                 index++;
3232             }
3233         }
3234         
3235         matchingCount = pairIndex;
3236     }
3237 
3238     function _getPVPBattleResults(uint256[] memory matchingIds, uint256 matchingCount, uint256 _targetBlock) internal view {
3239         uint256 exp = 0;
3240         uint256 hash = 0;
3241         uint256 result = 0;
3242         for (uint256 even = 0; even < matchingCount; even += 2) {
3243             if (exp == 0 || exp > 73) {
3244                 hash = uint256(keccak256(block.blockhash(_getTargetBlock(_targetBlock)), hash));
3245                 exp = 0;
3246             }
3247                 
3248             //compute battle result 1 = even(left) id won, 2 - odd(right) id won
3249             result = getPVPBattleResult(matchingIds[even], matchingIds[even + 1], hash % (1000 * 10**exp) / 10**exp);
3250             require(result > 0 && result < 3);
3251             exp++;
3252             //if odd warrior won, swap his id with even warrior,
3253             //otherwise do nothing,
3254             //even ids are winning ids! odds suck!
3255             if (result == 2) {
3256                 _swapValues(matchingIds, even, even + 1);
3257             }
3258         }
3259     }
3260     
3261     function _getLevel(uint256 _levelPoints) internal pure returns(uint256) {
3262         return _levelPoints / POINTS_TO_LEVEL;
3263     }
3264     
3265 }
3266 
3267 contract WarriorGenerator is Ownable, GeneratorInterface {
3268     
3269     address coreContract;
3270     
3271     /* LIMITS */
3272     uint32[19] public parameters;/*  = [
3273         uint32(10),//0_bodyColorMax3
3274         uint32(10),//1_eyeshMax4
3275         uint32(10),//2_mouthMax5
3276         uint32(20),//3_heirMax6
3277         uint32(10),//4_heirColorMax7
3278         uint32(3),//5_armorMax8
3279         uint32(3),//6_weaponMax9
3280         uint32(3),//7_hatMax10
3281         uint32(4),//8_runesMax11
3282         uint32(1),//9_wingsMax12
3283         uint32(10),//10_petMax13
3284         uint32(6),//11_borderMax14
3285         uint32(6),//12_backgroundMax15
3286         uint32(10),//13_unique
3287         uint32(900),//14_legendary
3288         uint32(9000),//15_mythic
3289         uint32(90000),//16_rare
3290         uint32(900000),//17_uncommon
3291         uint32(0)//18_uniqueTotal
3292     ];*/
3293     
3294     function WarriorGenerator(address _coreContract, uint32[] _settings) public {
3295         uint256 length = _settings.length;
3296         require(length == 18);
3297         require(_settings[8] == 4);//check runes max
3298         require(_settings[10] == 10);//check pets max
3299         require(_settings[11] == 5);//check border max
3300         require(_settings[12] == 6);//check background max
3301         //setup parameters
3302         for(uint256 i = 0; i < length; i ++) {
3303             parameters[i] = _settings[i];
3304         }	
3305         
3306         coreContract = _coreContract;
3307     }
3308     
3309     function changeParameter(uint32 _paramIndex, uint32 _value) external onlyOwner {
3310         CryptoUtils._changeParameter(_paramIndex, _value, parameters);
3311     }
3312 
3313     // / @dev simply a boolean to indicate this is the contract we expect to be
3314     function isGenerator() public pure returns (bool){
3315         return true;
3316     }
3317 
3318     // / @dev generate new warrior identity
3319     // / @param _heroIdentity Genes of warrior that invoked resurrection, if 0 => Demigod gene that signals to generate unique warrior
3320     // / @param _heroLevel Level of the warrior
3321     // / @_targetBlock block number from which hash will be taken
3322     // / @_perkId special perk id, like MINER(1)
3323     // / @return the identity that are supposed to be passed down to newly arisen warrior
3324     function generateWarrior(uint256 _heroIdentity, uint256 _heroLevel, uint256 _targetBlock, uint256 _perkId) 
3325     public returns (uint256) 
3326     {
3327         //only core contract can call this method
3328         require(msg.sender == coreContract);
3329         //get memory copy, to reduce storage read requests
3330         uint32[19] memory memoryParams = parameters;
3331         //generate warrior identity
3332         uint256 identity = CryptoUtils.generateWarrior(_heroIdentity, _heroLevel, _targetBlock, _perkId, memoryParams);
3333         
3334         //validate before pushing changes to storage
3335         CryptoUtils._validateIdentity(identity, memoryParams);
3336         //push changes to storage
3337         CryptoUtils._recordWarriorData(identity, parameters);
3338         
3339         return identity;
3340     }
3341 }
3342 
3343 contract AuctionBase {
3344 	uint256 public constant PRICE_CHANGE_TIME_STEP = 15 minutes;
3345 	
3346     struct Auction{
3347         address seller;
3348         uint128 startingPrice;
3349         uint128 endingPrice;
3350         uint64 duration;
3351         uint64 startedAt;
3352     }
3353     mapping (uint256 => Auction) internal tokenIdToAuction;
3354     
3355     uint256 public ownerCut;
3356     
3357     ERC721 public nonFungibleContract;
3358 
3359     event AuctionCreated(uint256 tokenId, address seller, uint256 startingPrice);
3360 
3361     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner, address seller);
3362 
3363     event AuctionCancelled(uint256 tokenId, address seller);
3364 
3365     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
3366         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
3367     }
3368 
3369     function _escrow(address _owner, uint256 _tokenId) internal{
3370         nonFungibleContract.transferFrom(_owner, this, _tokenId);
3371     }
3372     
3373     function _transfer(address _receiver, uint256 _tokenId) internal{
3374         nonFungibleContract.transfer(_receiver, _tokenId);
3375     }
3376     
3377     function _addAuction(uint256 _tokenId, Auction _auction) internal{
3378         require(_auction.duration >= 1 minutes);
3379         
3380         tokenIdToAuction[_tokenId] = _auction;
3381         
3382         AuctionCreated(uint256(_tokenId), _auction.seller, _auction.startingPrice);
3383     }
3384 
3385     // @dev Cancels an auction unconditionally.
3386     function _cancelAuction(uint256 _tokenId, address _seller) internal{
3387         _removeAuction(_tokenId);
3388         
3389         _transfer(_seller, _tokenId);
3390         
3391         AuctionCancelled(_tokenId, _seller);
3392     }
3393 
3394     function _bid(uint256 _tokenId, uint256 _bidAmount) internal returns (uint256){
3395         
3396         Auction storage auction = tokenIdToAuction[_tokenId];
3397         
3398         require(_isOnAuction(auction));
3399         
3400         uint256 price = _currentPrice(auction);
3401         
3402         require(_bidAmount >= price);
3403         
3404         address seller = auction.seller;
3405         
3406         _removeAuction(_tokenId);
3407         
3408         if (price > 0) {
3409             uint256 auctioneerCut = _computeCut(price);
3410             uint256 sellerProceeds = price - auctioneerCut;
3411             
3412             seller.transfer(sellerProceeds);
3413             nonFungibleContract.getBeneficiary().transfer(auctioneerCut);
3414         }
3415         
3416         uint256 bidExcess = _bidAmount - price;
3417         
3418         msg.sender.transfer(bidExcess);
3419         
3420         AuctionSuccessful(_tokenId, price, msg.sender, seller);
3421         
3422         return price;
3423     }
3424 
3425     function _removeAuction(uint256 _tokenId) internal{
3426         delete tokenIdToAuction[_tokenId];
3427     }
3428 
3429     function _isOnAuction(Auction storage _auction) internal view returns (bool){
3430         return (_auction.startedAt > 0);
3431     }
3432 
3433     function _currentPrice(Auction storage _auction)
3434         internal
3435         view
3436         returns (uint256){
3437         uint256 secondsPassed = 0;
3438         
3439         if (now > _auction.startedAt) {
3440             secondsPassed = now - _auction.startedAt;
3441         }
3442         
3443         return _computeCurrentPrice(_auction.startingPrice,
3444             _auction.endingPrice,
3445             _auction.duration,
3446             secondsPassed);
3447     }
3448     
3449     function _computeCurrentPrice(uint256 _startingPrice,
3450         uint256 _endingPrice,
3451         uint256 _duration,
3452         uint256 _secondsPassed)
3453         internal
3454         pure
3455         returns (uint256){
3456         
3457         if (_secondsPassed >= _duration) {
3458             return _endingPrice;
3459         } else {
3460             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
3461             
3462             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed / PRICE_CHANGE_TIME_STEP * PRICE_CHANGE_TIME_STEP) / int256(_duration);
3463             
3464             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
3465             
3466             return uint256(currentPrice);
3467         }
3468     }
3469 
3470     function _computeCut(uint256 _price) internal view returns (uint256){
3471         
3472         return _price * ownerCut / 10000;
3473     }
3474 }
3475 
3476 
3477 contract SaleClockAuction is Pausable, AuctionBase {
3478     
3479     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9f40b779);
3480     
3481     bool public isSaleClockAuction = true;
3482     uint256 public minerSaleCount;
3483     uint256[5] public lastMinerSalePrices;
3484 
3485     function SaleClockAuction(address _nftAddress, uint256 _cut) public{
3486         require(_cut <= 10000);
3487         ownerCut = _cut;
3488         ERC721 candidateContract = ERC721(_nftAddress);
3489         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
3490         require(candidateContract.getBeneficiary() != address(0));
3491         
3492         nonFungibleContract = candidateContract;
3493     }
3494 
3495     function cancelAuction(uint256 _tokenId)
3496         external{
3497         
3498         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3499         
3500         require(_isOnAuction(auction));
3501         
3502         address seller = auction.seller;
3503         
3504         require(msg.sender == seller);
3505         
3506         _cancelAuction(_tokenId, seller);
3507     }
3508 
3509     function cancelAuctionWhenPaused(uint256 _tokenId)
3510         whenPaused
3511         onlyOwner
3512         external{
3513         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3514         require(_isOnAuction(auction));
3515         _cancelAuction(_tokenId, auction.seller);
3516     }
3517 
3518     function getCurrentPrice(uint256 _tokenId)
3519         external
3520         view
3521         returns (uint256){
3522         
3523         AuctionBase.Auction storage auction = tokenIdToAuction[_tokenId];
3524         
3525         require(_isOnAuction(auction));
3526         
3527         return _currentPrice(auction);
3528     }
3529     
3530     function createAuction(uint256 _tokenId,
3531         uint256 _startingPrice,
3532         uint256 _endingPrice,
3533         uint256 _duration,
3534         address _seller)
3535         external{
3536         require(_startingPrice == uint256(uint128(_startingPrice)));
3537         require(_endingPrice == uint256(uint128(_endingPrice)));
3538         require(_duration == uint256(uint64(_duration)));
3539         require(msg.sender == address(nonFungibleContract));
3540         _escrow(_seller, _tokenId);
3541         
3542         AuctionBase.Auction memory auction = Auction(_seller,
3543             uint128(_startingPrice),
3544             uint128(_endingPrice),
3545             uint64(_duration),
3546             uint64(now));
3547         
3548         _addAuction(_tokenId, auction);
3549     }
3550     
3551     function bid(uint256 _tokenId)
3552         external
3553         payable{
3554         
3555         address seller = tokenIdToAuction[_tokenId].seller;
3556         
3557         uint256 price = _bid(_tokenId, msg.value);
3558         
3559         _transfer(msg.sender, _tokenId);
3560         
3561         if (seller == nonFungibleContract.getBeneficiary()) {
3562             lastMinerSalePrices[minerSaleCount % 5] = price;
3563             minerSaleCount++;
3564         }
3565     }
3566 
3567     function averageMinerSalePrice() external view returns (uint256){
3568         uint256 sum = 0;
3569         for (uint256 i = 0; i < 5; i++){
3570             sum += lastMinerSalePrices[i];
3571         }
3572         return sum / 5;
3573     }
3574     
3575     /**getAuctionsById returns packed actions data
3576      * @param tokenIds ids of tokens, whose auction's must be active 
3577      * @return auctionData as uint256 array
3578      * @return stepSize number of fields describing auction 
3579      */
3580     function getAuctionsById(uint32[] tokenIds) external view returns(uint256[] memory auctionData, uint32 stepSize) {
3581         stepSize = 6;
3582         auctionData = new uint256[](tokenIds.length * stepSize);
3583         
3584         uint32 tokenId;
3585         for(uint32 i = 0; i < tokenIds.length; i ++) {
3586             tokenId = tokenIds[i];
3587             AuctionBase.Auction storage auction = tokenIdToAuction[tokenId];
3588             require(_isOnAuction(auction));
3589             _setTokenData(auctionData, auction, tokenId, i * stepSize);
3590         }
3591     }
3592     
3593     /**getAuctions returns packed actions data
3594      * @param fromIndex warrior index from global warrior storage (aka warriorId)
3595      * @param count Number of auction's to find, if count == 0, then exact warriorId(fromIndex) will be searched
3596      * @return auctionData as uint256 array
3597      * @return stepSize number of fields describing auction 
3598      */
3599     function getAuctions(uint32 fromIndex, uint32 count) external view returns(uint256[] memory auctionData, uint32 stepSize) {
3600         stepSize = 6;
3601         if (count == 0) {
3602             AuctionBase.Auction storage auction = tokenIdToAuction[fromIndex];
3603 	        	require(_isOnAuction(auction));
3604 	        	auctionData = new uint256[](1 * stepSize);
3605 	        	_setTokenData(auctionData, auction, fromIndex, count);
3606 	        	return (auctionData, stepSize);
3607         } else {
3608             uint256 totalWarriors = nonFungibleContract.totalSupply();
3609 	        if (totalWarriors == 0) {
3610 	            // Return an empty array
3611 	            return (new uint256[](0), stepSize);
3612 	        } else {
3613 	
3614 	            uint32 totalSize = 0;
3615 	            uint32 tokenId;
3616 	            uint32 size = 0;
3617 				auctionData = new uint256[](count * stepSize);
3618 	            for (tokenId = 0; tokenId < totalWarriors && size < count; tokenId++) {
3619 	                AuctionBase.Auction storage auction1 = tokenIdToAuction[tokenId];
3620 	        
3621 		        		if (_isOnAuction(auction1)) {
3622 		        		    totalSize ++;
3623 		        		    if (totalSize > fromIndex) {
3624 		        		        _setTokenData(auctionData, auction1, tokenId, size++ * stepSize);//warriorId;
3625 		        		    }
3626 		        		}
3627 	            }
3628 	            
3629 	            if (size < count) {
3630 	                size *= stepSize;
3631 	                uint256[] memory repack = new uint256[](size);
3632 	                for(tokenId = 0; tokenId < size; tokenId++) {
3633 	                    repack[tokenId] = auctionData[tokenId];
3634 	                }
3635 	                return (repack, stepSize);
3636 	            }
3637 	
3638 	            return (auctionData, stepSize);
3639 	        }
3640         }
3641     }
3642     
3643     // @dev Returns auction info for an NFT on auction.
3644     // @param _tokenId - ID of NFT on auction.
3645     function getAuction(uint256 _tokenId) external view returns(
3646         address seller,
3647         uint256 startingPrice,
3648         uint256 endingPrice,
3649         uint256 duration,
3650         uint256 startedAt
3651         ){
3652         
3653         Auction storage auction = tokenIdToAuction[_tokenId];
3654         
3655         require(_isOnAuction(auction));
3656         
3657         return (auction.seller,
3658             auction.startingPrice,
3659             auction.endingPrice,
3660             auction.duration,
3661             auction.startedAt);
3662     }
3663     
3664     //pack NFT data into specified array
3665     function _setTokenData(uint256[] memory auctionData, 
3666         AuctionBase.Auction storage auction, uint32 tokenId, uint32 index
3667     ) internal view {
3668         auctionData[index] = uint256(tokenId);//0
3669         auctionData[index + 1] = uint256(auction.seller);//1
3670         auctionData[index + 2] = uint256(auction.startingPrice);//2
3671         auctionData[index + 3] = uint256(auction.endingPrice);//3
3672         auctionData[index + 4] = uint256(auction.duration);//4
3673         auctionData[index + 5] = uint256(auction.startedAt);//5
3674     }
3675     
3676 }