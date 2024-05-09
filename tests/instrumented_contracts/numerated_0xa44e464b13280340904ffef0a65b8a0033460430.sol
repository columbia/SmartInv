1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   /**
10   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
11   */
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   /**
18   * @dev Adds two numbers, throws on overflow.
19   */
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address internal contractOwner;
35 
36   constructor () internal {
37     if(contractOwner == address(0)){
38       contractOwner = msg.sender;
39     }
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == contractOwner);
47     _;
48   }
49   
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     contractOwner = newOwner;
58   }
59 
60 }
61 
62 
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68   bool private paused = false;
69 
70   /**
71    * @dev Modifier to allow actions only when the contract IS paused
72      @dev If is paused msg.value is send back
73    */
74   modifier whenNotPaused() {
75     if(paused == true && msg.value > 0){
76       msg.sender.transfer(msg.value);
77     }
78     require(!paused);
79     _;
80   }
81 
82 
83   /**
84    * @dev Called by the owner to pause, triggers stopped state
85    */
86   function triggerPause() onlyOwner external {
87     paused = !paused;
88   }
89 
90 }
91 
92 
93 /// @title A contract for creating new champs and making withdrawals
94 contract ChampFactory is Pausable{
95 
96     event NewChamp(uint256 champID, address owner);
97 
98     using SafeMath for uint; //SafeMath for overflow prevention
99 
100     /*
101      * Variables
102      */
103     struct Champ {
104         uint256 id; //same as position in Champ[]
105         uint256 attackPower;
106         uint256 defencePower;
107         uint256 cooldownTime; //how long does it take to be ready attack again
108         uint256 readyTime; //if is smaller than block.timestamp champ is ready to fight
109         uint256 winCount;
110         uint256 lossCount;
111         uint256 position; //position in leaderboard. subtract 1 and you got position in leaderboard[]
112         uint256 price; //selling price
113         uint256 withdrawCooldown; //if you one of the 800 best champs and withdrawCooldown is less as block.timestamp then you get ETH reward
114         uint256 eq_sword; 
115         uint256 eq_shield; 
116         uint256 eq_helmet; 
117         bool forSale; //is champ for sale?
118     }
119     
120     struct AddressInfo {
121         uint256 withdrawal;
122         uint256 champsCount;
123         uint256 itemsCount;
124         string name;
125     }
126 
127     //Item struct
128     struct Item {
129         uint8 itemType; // 1 - Sword | 2 - Shield | 3 - Helmet
130         uint8 itemRarity; // 1 - Common | 2 - Uncommon | 3 - Rare | 4 - Epic | 5 - Legendery | 6 - Forged
131         uint256 attackPower;
132         uint256 defencePower;
133         uint256 cooldownReduction;
134         uint256 price;
135         uint256 onChampId; //can not be used to decide if item is on champ, because champ's id can be 0, 'bool onChamp' solves it.
136         bool onChamp; 
137         bool forSale; //is item for sale?
138     }
139     
140     mapping (address => AddressInfo) public addressInfo;
141     mapping (uint256 => address) public champToOwner;
142     mapping (uint256 => address) public itemToOwner;
143     mapping (uint256 => string) public champToName;
144     
145     Champ[] public champs;
146     Item[] public items;
147     uint256[] public leaderboard;
148     
149     uint256 internal createChampFee = 5 finney;
150     uint256 internal lootboxFee = 5 finney;
151     uint256 internal pendingWithdrawal = 0;
152     uint256 private randNonce = 0; //being used in generating random numbers
153     uint256 public champsForSaleCount;
154     uint256 public itemsForSaleCount;
155     
156 
157     /*
158      * Modifiers
159      */
160     /// @dev Checks if msg.sender is owner of champ
161     modifier onlyOwnerOfChamp(uint256 _champId) {
162         require(msg.sender == champToOwner[_champId]);
163         _;
164     }
165     
166 
167     /// @dev Checks if msg.sender is NOT owner of champ
168     modifier onlyNotOwnerOfChamp(uint256 _champId) {
169         require(msg.sender != champToOwner[_champId]);
170         _;
171     }
172     
173 
174     /// @notice Checks if amount was sent
175     modifier isPaid(uint256 _price){
176         require(msg.value >= _price);
177         _;
178     }
179 
180 
181     /// @notice People are allowed to withdraw only if min. balance (0.01 gwei) is reached
182     modifier contractMinBalanceReached(){
183         require( (address(this).balance).sub(pendingWithdrawal) > 1000000 );
184         _;
185     }
186 
187 
188     /// @notice Checks if withdraw cooldown passed 
189     modifier isChampWithdrawReady(uint256 _id){
190         require(champs[_id].withdrawCooldown < block.timestamp);
191         _;
192     }
193 
194 
195     /// @notice Distribute input funds between contract owner and players
196     modifier distributeInput(address _affiliateAddress){
197 
198         //contract owner
199         uint256 contractOwnerWithdrawal = (msg.value / 100) * 50; // 50%
200         addressInfo[contractOwner].withdrawal += contractOwnerWithdrawal;
201         pendingWithdrawal += contractOwnerWithdrawal;
202 
203         //affiliate
204         //checks if _affiliateAddress is set & if affiliate address is not buying player
205         if(_affiliateAddress != address(0) && _affiliateAddress != msg.sender){
206             uint256 affiliateBonus = (msg.value / 100) * 25; //provision is 25%
207             addressInfo[_affiliateAddress].withdrawal += affiliateBonus;
208             pendingWithdrawal += affiliateBonus;
209         }
210 
211         _;
212     }
213 
214 
215 
216     /*
217      * View
218      */
219     /// @notice Gets champs by address
220     /// @param _owner Owner address
221     function getChampsByOwner(address _owner) external view returns(uint256[]) {
222         uint256[] memory result = new uint256[](addressInfo[_owner].champsCount);
223         uint256 counter = 0;
224         for (uint256 i = 0; i < champs.length; i++) {
225             if (champToOwner[i] == _owner) {
226                 result[counter] = i;
227                 counter++;
228             }
229         }
230         return result;
231     }
232 
233 
234     /// @notice Gets total champs count
235     function getChampsCount() external view returns(uint256){
236         return champs.length;
237     }
238     
239 
240     /// @notice Gets champ's reward in wei
241     function getChampReward(uint256 _position) public view returns(uint256) {
242         if(_position <= 800){
243             //percentageMultipier = 10,000
244             //maxReward = 2000 = .2% * percentageMultipier
245             //subtractPerPosition = 2 = .0002% * percentageMultipier
246             //2000 - (2 * (_position - 1))
247             uint256 rewardPercentage = uint256(2000).sub(2 * (_position - 1));
248 
249             //available funds are all funds - already pending
250             uint256 availableWithdrawal = address(this).balance.sub(pendingWithdrawal);
251 
252             //calculate reward for champ's position
253             //1000000 = percentageMultipier * 100
254             return availableWithdrawal / 1000000 * rewardPercentage;
255         }else{
256             return uint256(0);
257         }
258     }
259 
260 
261     /*
262      * Internal
263      */
264     /// @notice Generates random modulus
265     /// @param _modulus Max random modulus
266     function randMod(uint256 _modulus) internal returns(uint256) {
267         randNonce++;
268         return uint256(keccak256(randNonce, blockhash(block.number - 1))) % _modulus;
269     }
270     
271 
272 
273     /*
274      * External
275      */
276     /// @notice Creates new champ
277     /// @param _affiliateAddress Affiliate address (optional)
278     function createChamp(address _affiliateAddress) external payable 
279     whenNotPaused
280     isPaid(createChampFee) 
281     distributeInput(_affiliateAddress) 
282     {
283 
284         /* 
285         Champ memory champ = Champ({
286              id: 0,
287              attackPower: 2 + randMod(4),
288              defencePower: 1 + randMod(4),
289              cooldownTime: uint256(1 days) - uint256(randMod(9) * 1 hours),
290              readyTime: 0,
291              winCount: 0,
292              lossCount: 0,
293              position: leaderboard.length + 1, //Last place in leaderboard is new champ's position. Used in new champ struct bellow. +1 to avoid zero position.
294              price: 0,
295              withdrawCooldown: uint256(block.timestamp), 
296              eq_sword: 0,
297              eq_shield: 0, 
298              eq_helmet: 0, 
299              forSale: false 
300         });   
301         */
302 
303         // This line bellow is about 30k gas cheaper than lines above. They are the same. Lines above are just more readable.
304         uint256 id = champs.push(Champ(0, 2 + randMod(4), 1 + randMod(4), uint256(1 days)  - uint256(randMod(9) * 1 hours), 0, 0, 0, leaderboard.length + 1, 0, uint256(block.timestamp), 0,0,0, false)) - 1;     
305         
306         
307         champs[id].id = id; //sets id in Champ struct  
308         leaderboard.push(id); //push champ on the last place in leaderboard  
309         champToOwner[id] = msg.sender; //sets owner of this champ - msg.sender
310         addressInfo[msg.sender].champsCount++;
311 
312         emit NewChamp(id, msg.sender);
313 
314     }
315 
316 
317     /// @notice Change "CreateChampFee". If ETH price will grow up it can expensive to create new champ.
318     /// @param _fee New "CreateChampFee"
319     /// @dev Only owner of contract can change "CreateChampFee"
320     function setCreateChampFee(uint256 _fee) external onlyOwner {
321         createChampFee = _fee;
322     }
323     
324 
325     /// @notice Change champ's name
326     function changeChampsName(uint _champId, string _name) external 
327     onlyOwnerOfChamp(_champId){
328         champToName[_champId] = _name;
329     }
330 
331 
332     /// @notice Change players's name
333     function changePlayersName(string _name) external {
334         addressInfo[msg.sender].name = _name;
335     }
336 
337 
338     /// @notice Withdraw champ's reward
339     /// @param _id Champ id
340     /// @dev Move champ reward to pending withdrawal to his wallet. 
341     function withdrawChamp(uint _id) external 
342     onlyOwnerOfChamp(_id) 
343     contractMinBalanceReached  
344     isChampWithdrawReady(_id) 
345     whenNotPaused {
346         Champ storage champ = champs[_id];
347         require(champ.position <= 800);
348 
349         champ.withdrawCooldown = block.timestamp + 1 days; //one withdrawal 1 per day
350 
351         uint256 withdrawal = getChampReward(champ.position);
352         addressInfo[msg.sender].withdrawal += withdrawal;
353         pendingWithdrawal += withdrawal;
354     }
355     
356 
357     /// @dev Send all pending funds of caller's address
358     function withdrawToAddress(address _address) external 
359     whenNotPaused {
360         address playerAddress = _address;
361         if(playerAddress == address(0)){ playerAddress = msg.sender; }
362         uint256 share = addressInfo[playerAddress].withdrawal; //gets pending funds
363         require(share > 0); //is it more than 0?
364 
365         //first sets players withdrawal pending to 0 and subtract amount from playerWithdrawals then transfer funds to avoid reentrancy
366         addressInfo[playerAddress].withdrawal = 0; //set player's withdrawal pendings to 0 
367         pendingWithdrawal = pendingWithdrawal.sub(share); //subtract share from total pendings 
368         
369         playerAddress.transfer(share); //transfer
370     }
371     
372 }
373 
374 
375 
376 /// @title  Moderates items and creates new ones
377 contract Items is ChampFactory {
378 
379     event NewItem(uint256 itemID, address owner);
380 
381     constructor () internal {
382         //item -> nothing
383         items.push(Item(0, 0, 0, 0, 0, 0, 0, false, false));
384     }
385 
386     /*
387      * Modifiers
388      */
389     /// @notice Checks if sender is owner of item
390     modifier onlyOwnerOfItem(uint256 _itemId) {
391         require(_itemId != 0);
392         require(msg.sender == itemToOwner[_itemId]);
393         _;
394     }
395     
396 
397     /// @notice Checks if sender is NOT owner of item
398     modifier onlyNotOwnerOfItem(uint256 _itemId) {
399         require(msg.sender != itemToOwner[_itemId]);
400         _;
401     }
402 
403 
404     /*
405      * View
406      */
407     ///@notice Check if champ has something on
408     ///@param _type Sword, shield or helmet
409     function hasChampSomethingOn(uint _champId, uint8 _type) internal view returns(bool){
410         Champ storage champ = champs[_champId];
411         if(_type == 1){
412             return (champ.eq_sword == 0) ? false : true;
413         }
414         if(_type == 2){
415             return (champ.eq_shield == 0) ? false : true;
416         }
417         if(_type == 3){
418             return (champ.eq_helmet == 0) ? false : true;
419         }
420     }
421 
422 
423     /// @notice Gets items by address
424     /// @param _owner Owner address
425     function getItemsByOwner(address _owner) external view returns(uint256[]) {
426         uint256[] memory result = new uint256[](addressInfo[_owner].itemsCount);
427         uint256 counter = 0;
428         for (uint256 i = 0; i < items.length; i++) {
429             if (itemToOwner[i] == _owner) {
430                 result[counter] = i;
431                 counter++;
432             }
433         }
434         return result;
435     }
436 
437 
438     /*
439      * Public
440      */
441     ///@notice Takes item off champ
442     function takeOffItem(uint _champId, uint8 _type) public 
443         onlyOwnerOfChamp(_champId) {
444             uint256 itemId;
445             Champ storage champ = champs[_champId];
446             if(_type == 1){
447                 itemId = champ.eq_sword; //Get item ID
448                 if (itemId > 0) { //0 = nothing
449                     champ.eq_sword = 0; //take off sword
450                 }
451             }
452             if(_type == 2){
453                 itemId = champ.eq_shield; //Get item ID
454                 if(itemId > 0) {//0 = nothing
455                     champ.eq_shield = 0; //take off shield
456                 }
457             }
458             if(_type == 3){
459                 itemId = champ.eq_helmet; //Get item ID
460                 if(itemId > 0) { //0 = nothing
461                     champ.eq_helmet = 0; //take off 
462                 }
463             }
464             if(itemId > 0){
465                 items[itemId].onChamp = false; //item is free to use, is not on champ
466             }
467     }
468 
469 
470 
471     /*
472      * External
473      */
474     ///@notice Puts item on champ
475     function putOn(uint256 _champId, uint256 _itemId) external 
476         onlyOwnerOfChamp(_champId) 
477         onlyOwnerOfItem(_itemId) {
478             Champ storage champ = champs[_champId];
479             Item storage item = items[_itemId];
480 
481             //checks if items is on some other champ
482             if(item.onChamp){
483                 takeOffItem(item.onChampId, item.itemType); //take off from champ
484             }
485 
486             item.onChamp = true; //item is on champ
487             item.onChampId = _champId; //champ's id
488 
489             //put on
490             if(item.itemType == 1){
491                 //take off actual sword 
492                 if(champ.eq_sword > 0){
493                     takeOffItem(champ.id, 1);
494                 }
495                 champ.eq_sword = _itemId; //put on sword
496             }
497             if(item.itemType == 2){
498                 //take off actual shield 
499                 if(champ.eq_shield > 0){
500                     takeOffItem(champ.id, 2);
501                 }
502                 champ.eq_shield = _itemId; //put on shield
503             }
504             if(item.itemType == 3){
505                 //take off actual helmet 
506                 if(champ.eq_helmet > 0){
507                     takeOffItem(champ.id, 3);
508                 }
509                 champ.eq_helmet = _itemId; //put on helmet
510             }
511     }
512 
513 
514 
515     /// @notice Opens loot box and generates new item
516     function openLootbox(address _affiliateAddress) external payable 
517     whenNotPaused
518     isPaid(lootboxFee) 
519     distributeInput(_affiliateAddress) {
520 
521         uint256 pointToCooldownReduction;
522         uint256 randNum = randMod(1001); //random number <= 1000
523         uint256 pointsToShare; //total points given
524         uint256 itemID;
525 
526         //sets up item
527         Item memory item = Item({
528             itemType: uint8(uint256(randMod(3) + 1)), //generates item type - max num is 2 -> 0 + 1 SWORD | 1 + 1 SHIELD | 2 + 1 HELMET;
529             itemRarity: uint8(0),
530             attackPower: 0,
531             defencePower: 0,
532             cooldownReduction: 0,
533             price: 0,
534             onChampId: 0,
535             onChamp: false,
536             forSale: false
537         });
538         
539         // Gets Rarity of item
540         // 45% common
541         // 27% uncommon
542         // 19% rare
543         // 7%  epic
544         // 2%  legendary
545         if(450 > randNum){
546             pointsToShare = 25 + randMod(9); //25 basic + random number max to 8
547             item.itemRarity = uint8(1);
548         }else if(720 > randNum){
549             pointsToShare = 42 + randMod(17); //42 basic + random number max to 16
550             item.itemRarity = uint8(2);
551         }else if(910 > randNum){
552             pointsToShare = 71 + randMod(25); //71 basic + random number max to 24
553             item.itemRarity = uint8(3);
554         }else if(980 > randNum){
555             pointsToShare = 119 + randMod(33); //119 basic + random number max to 32
556             item.itemRarity = uint8(4);
557         }else{
558             pointsToShare = 235 + randMod(41); //235 basic + random number max to 40
559             item.itemRarity = uint8(5);
560         }
561         
562 
563         //Gets type of item
564         if(item.itemType == uint8(1)){ //ITEM IS SWORDS
565             item.attackPower = pointsToShare / 10 * 7; //70% attackPower
566             pointsToShare -= item.attackPower; //points left;
567                 
568             item.defencePower = pointsToShare / 10 * randMod(6); //up to 15% defencePower
569             pointsToShare -= item.defencePower; //points left;
570                 
571             item.cooldownReduction = pointsToShare * uint256(1 minutes); //rest of points is cooldown reduction
572             item.itemType = uint8(1);
573         }
574         
575         if(item.itemType == uint8(2)){ //ITEM IS SHIELD
576             item.defencePower = pointsToShare / 10 * 7; //70% defencePower
577             pointsToShare -= item.defencePower; //points left;
578                 
579             item.attackPower = pointsToShare / 10 * randMod(6); //up to 15% attackPowerPower
580             pointsToShare -= item.attackPower; //points left;
581                 
582             item.cooldownReduction = pointsToShare * uint256(1 minutes); //rest of points is cooldown reduction
583             item.itemType = uint8(2);
584         }
585         
586         if(item.itemType == uint8(3)){ //ITEM IS HELMET
587             pointToCooldownReduction = pointsToShare / 10 * 7; //70% cooldown reduction
588             item.cooldownReduction = pointToCooldownReduction * uint256(1 minutes); //points to time
589             pointsToShare -= pointToCooldownReduction; //points left;
590                 
591             item.attackPower = pointsToShare / 10 * randMod(6); //up to 15% attackPower
592             pointsToShare -= item.attackPower; //points left;
593                 
594             item.defencePower = pointsToShare; //rest of points is defencePower
595             item.itemType = uint8(3);
596         }
597 
598         itemID = items.push(item) - 1;
599         
600         itemToOwner[itemID] = msg.sender; //sets owner of this item - msg.sender
601         addressInfo[msg.sender].itemsCount++; //every address has count of items    
602 
603         emit NewItem(itemID, msg.sender);    
604 
605     }
606 
607     /// @notice Change "lootboxFee". 
608     /// @param _fee New "lootboxFee"
609     /// @dev Only owner of contract can change "lootboxFee"
610     function setLootboxFee(uint _fee) external onlyOwner {
611         lootboxFee = _fee;
612     }
613 }
614 
615 
616 
617 /// @title Moderates buying and selling items
618 contract ItemMarket is Items {
619 
620     event TransferItem(address from, address to, uint256 itemID);
621 
622     /*
623      * Modifiers
624      */
625     ///@notice Checks if item is for sale
626     modifier itemIsForSale(uint256 _id){
627         require(items[_id].forSale);
628         _;
629     }
630 
631     ///@notice Checks if item is NOT for sale
632     modifier itemIsNotForSale(uint256 _id){
633         require(items[_id].forSale == false);
634         _;
635     }
636 
637     ///@notice If item is for sale then cancel sale
638     modifier ifItemForSaleThenCancelSale(uint256 _itemID){
639       Item storage item = items[_itemID];
640       if(item.forSale){
641           _cancelItemSale(item);
642       }
643       _;
644     }
645 
646 
647     ///@notice Distribute sale eth input
648     modifier distributeSaleInput(address _owner) { 
649         uint256 contractOwnerCommision; //1%
650         uint256 playerShare; //99%
651         
652         if(msg.value > 100){
653             contractOwnerCommision = (msg.value / 100);
654             playerShare = msg.value - contractOwnerCommision;
655         }else{
656             contractOwnerCommision = 0;
657             playerShare = msg.value;
658         }
659 
660         addressInfo[_owner].withdrawal += playerShare;
661         addressInfo[contractOwner].withdrawal += contractOwnerCommision;
662         pendingWithdrawal += playerShare + contractOwnerCommision;
663         _;
664     }
665 
666 
667 
668     /*
669      * View
670      */
671     function getItemsForSale() view external returns(uint256[]){
672         uint256[] memory result = new uint256[](itemsForSaleCount);
673         if(itemsForSaleCount > 0){
674             uint256 counter = 0;
675             for (uint256 i = 0; i < items.length; i++) {
676                 if (items[i].forSale == true) {
677                     result[counter]=i;
678                     counter++;
679                 }
680             }
681         }
682         return result;
683     }
684     
685      /*
686      * Private
687      */
688     ///@notice Cancel sale. Should not be called without checking if item is really for sale.
689     function _cancelItemSale(Item storage item) private {
690       //No need to overwrite item's price
691       item.forSale = false;
692       itemsForSaleCount--;
693     }
694 
695 
696     /*
697      * Internal
698      */
699     /// @notice Transfer item
700     function transferItem(address _from, address _to, uint256 _itemID) internal 
701       ifItemForSaleThenCancelSale(_itemID) {
702         Item storage item = items[_itemID];
703 
704         //take off      
705         if(item.onChamp && _to != champToOwner[item.onChampId]){
706           takeOffItem(item.onChampId, item.itemType);
707         }
708 
709         addressInfo[_to].itemsCount++;
710         addressInfo[_from].itemsCount--;
711         itemToOwner[_itemID] = _to;
712 
713         emit TransferItem(_from, _to, _itemID);
714     }
715 
716 
717 
718     /*
719      * Public
720      */
721     /// @notice Calls transfer item
722     /// @notice Address _from is msg.sender. Cannot be used is market, bc msg.sender is buyer
723     function giveItem(address _to, uint256 _itemID) public 
724       onlyOwnerOfItem(_itemID) {
725         transferItem(msg.sender, _to, _itemID);
726     }
727     
728 
729     /// @notice Calcels item's sale
730     function cancelItemSale(uint256 _id) public 
731     itemIsForSale(_id) 
732     onlyOwnerOfItem(_id){
733       Item storage item = items[_id];
734        _cancelItemSale(item);
735     }
736 
737 
738     /*
739      * External
740      */
741     /// @notice Sets item for sale
742     function setItemForSale(uint256 _id, uint256 _price) external 
743       onlyOwnerOfItem(_id) 
744       itemIsNotForSale(_id) {
745         Item storage item = items[_id];
746         item.forSale = true;
747         item.price = _price;
748         itemsForSaleCount++;
749     }
750     
751     
752     /// @notice Buys item
753     function buyItem(uint256 _id) external payable 
754       whenNotPaused 
755       onlyNotOwnerOfItem(_id) 
756       itemIsForSale(_id) 
757       isPaid(items[_id].price) 
758       distributeSaleInput(itemToOwner[_id]) 
759       {
760         transferItem(itemToOwner[_id], msg.sender, _id);
761     }
762     
763 }
764 
765 
766 
767 /// @title Manages forging
768 contract ItemForge is ItemMarket {
769 
770 	event Forge(uint256 forgedItemID);
771 
772 	///@notice Forge items together
773 	function forgeItems(uint256 _parentItemID, uint256 _childItemID) external 
774 	onlyOwnerOfItem(_parentItemID) 
775 	onlyOwnerOfItem(_childItemID) 
776 	ifItemForSaleThenCancelSale(_parentItemID) 
777 	ifItemForSaleThenCancelSale(_childItemID) {
778 
779 		//checks if items are not the same
780         require(_parentItemID != _childItemID);
781         
782 		Item storage parentItem = items[_parentItemID];
783 		Item storage childItem = items[_childItemID];
784 
785 		//take child item off, because child item will be burned
786 		if(childItem.onChamp){
787 			takeOffItem(childItem.onChampId, childItem.itemType);
788 		}
789 
790 		//update parent item
791 		parentItem.attackPower = (parentItem.attackPower > childItem.attackPower) ? parentItem.attackPower : childItem.attackPower;
792 		parentItem.defencePower = (parentItem.defencePower > childItem.defencePower) ? parentItem.defencePower : childItem.defencePower;
793 		parentItem.cooldownReduction = (parentItem.cooldownReduction > childItem.cooldownReduction) ? parentItem.cooldownReduction : childItem.cooldownReduction;
794 		parentItem.itemRarity = uint8(6);
795 
796 		//burn child item
797 		transferItem(msg.sender, address(0), _childItemID);
798 
799 		emit Forge(_parentItemID);
800 	}
801 
802 }
803 
804 
805 /// @title Manages attacks in game
806 contract ChampAttack is ItemForge {
807     
808     event Attack(uint256 winnerChampID, uint256 defeatedChampID, bool didAttackerWin);
809 
810     /*
811      * Modifiers
812      */
813      /// @notice Is champ ready to fight again?
814     modifier isChampReady(uint256 _champId) {
815       require (champs[_champId].readyTime <= block.timestamp);
816       _;
817     }
818 
819 
820     /// @notice Prevents from self-attack
821     modifier notSelfAttack(uint256 _champId, uint256 _targetId) {
822         require(_champId != _targetId); 
823         _;
824     }
825 
826 
827     /// @notice Checks if champ does exist
828     modifier targetExists(uint256 _targetId){
829         require(champToOwner[_targetId] != address(0)); 
830         _;
831     }
832 
833 
834     /*
835      * View
836      */
837     /// @notice Gets champ's attack power, defence power and cooldown reduction with items on
838     function getChampStats(uint256 _champId) public view returns(uint256,uint256,uint256){
839         Champ storage champ = champs[_champId];
840         Item storage sword = items[champ.eq_sword];
841         Item storage shield = items[champ.eq_shield];
842         Item storage helmet = items[champ.eq_helmet];
843 
844         //AP
845         uint256 totalAttackPower = champ.attackPower + sword.attackPower + shield.attackPower + helmet.attackPower; //Gets champs AP
846 
847         //DP
848         uint256 totalDefencePower = champ.defencePower + sword.defencePower + shield.defencePower + helmet.defencePower; //Gets champs  DP
849 
850         //CR
851         uint256 totalCooldownReduction = sword.cooldownReduction + shield.cooldownReduction + helmet.cooldownReduction; //Gets  CR
852 
853         return (totalAttackPower, totalDefencePower, totalCooldownReduction);
854     }
855 
856 
857     /*
858      * Pure
859      */
860     /// @notice Subtracts ability points. Helps to not cross minimal attack ability points -> 2
861     /// @param _playerAttackPoints Actual player's attack points
862     /// @param _x Amount to subtract 
863     function subAttack(uint256 _playerAttackPoints, uint256 _x) internal pure returns (uint256) {
864         return (_playerAttackPoints <= _x + 2) ? 2 : _playerAttackPoints - _x;
865     }
866     
867 
868     /// @notice Subtracts ability points. Helps to not cross minimal defence ability points -> 1
869     /// @param _playerDefencePoints Actual player's defence points
870     /// @param _x Amount to subtract 
871     function subDefence(uint256 _playerDefencePoints, uint256 _x) internal pure returns (uint256) {
872         return (_playerDefencePoints <= _x) ? 1 : _playerDefencePoints - _x;
873     }
874     
875 
876     /*
877      * Private
878      */
879     /// @dev Is called from from Attack function after the winner is already chosen
880     /// @dev Updates abilities, champ's stats and swaps positions
881     function _attackCompleted(Champ storage _winnerChamp, Champ storage _defeatedChamp, uint256 _pointsGiven, uint256 _pointsToAttackPower) private {
882         /*
883          * Updates abilities after fight
884          */
885         //winner abilities update
886         _winnerChamp.attackPower += _pointsToAttackPower; //increase attack power
887         _winnerChamp.defencePower += _pointsGiven - _pointsToAttackPower; //max point that was given - already given to AP
888                 
889         //defeated champ's abilities update
890         //checks for not cross minimal AP & DP points
891         _defeatedChamp.attackPower = subAttack(_defeatedChamp.attackPower, _pointsToAttackPower); //decrease attack power
892         _defeatedChamp.defencePower = subDefence(_defeatedChamp.defencePower, _pointsGiven - _pointsToAttackPower); // decrease defence power
893 
894 
895 
896         /*
897          * Update champs' wins and losses
898          */
899         _winnerChamp.winCount++;
900         _defeatedChamp.lossCount++;
901             
902 
903 
904         /*
905          * Swap positions
906          */
907         if(_winnerChamp.position > _defeatedChamp.position) { //require loser to has better (lower) postion than attacker
908             uint256 winnerPosition = _winnerChamp.position;
909             uint256 loserPosition = _defeatedChamp.position;
910         
911             _defeatedChamp.position = winnerPosition;
912             _winnerChamp.position = loserPosition;
913         
914             //position in champ struct is always one point bigger than in leaderboard array
915             leaderboard[winnerPosition - 1] = _defeatedChamp.id;
916             leaderboard[loserPosition - 1] = _winnerChamp.id;
917         }
918     }
919     
920     
921     /// @dev Gets pointsGiven and pointsToAttackPower
922     function _getPoints(uint256 _pointsGiven) private returns (uint256 pointsGiven, uint256 pointsToAttackPower){
923         return (_pointsGiven, randMod(_pointsGiven+1));
924     }
925 
926 
927 
928     /*
929      * External
930      */
931     /// @notice Attack function
932     /// @param _champId Attacker champ
933     /// @param _targetId Target champ
934     function attack(uint256 _champId, uint256 _targetId) external 
935     onlyOwnerOfChamp(_champId) 
936     isChampReady(_champId) 
937     notSelfAttack(_champId, _targetId) 
938     targetExists(_targetId) {
939         Champ storage myChamp = champs[_champId]; 
940         Champ storage enemyChamp = champs[_targetId]; 
941         uint256 pointsGiven; //total points that will be divided between AP and DP
942         uint256 pointsToAttackPower; //part of points that will be added to attack power, the rest of points go to defence power
943         uint256 myChampAttackPower;  
944         uint256 enemyChampDefencePower; 
945         uint256 myChampCooldownReduction;
946         
947         (myChampAttackPower,,myChampCooldownReduction) = getChampStats(_champId);
948         (,enemyChampDefencePower,) = getChampStats(_targetId);
949 
950 
951         //if attacker's AP is more than target's DP then attacker wins
952         if (myChampAttackPower > enemyChampDefencePower) {
953             
954             //this should demotivate players from farming on way weaker champs than they are
955             //the bigger difference between AP & DP is, the reward is smaller
956             if(myChampAttackPower - enemyChampDefencePower < 5){
957                 
958                 //big experience - 3 ability points
959                 (pointsGiven, pointsToAttackPower) = _getPoints(3);
960                 
961                 
962             }else if(myChampAttackPower - enemyChampDefencePower < 10){
963                 
964                 //medium experience - 2 ability points
965                 (pointsGiven, pointsToAttackPower) = _getPoints(2);
966                 
967             }else{
968                 
969                 //small experience - 1 ability point to random ability (attack power or defence power)
970                 (pointsGiven, pointsToAttackPower) = _getPoints(1);
971                 
972             }
973             
974             _attackCompleted(myChamp, enemyChamp, pointsGiven, pointsToAttackPower);
975 
976             emit Attack(myChamp.id, enemyChamp.id, true);
977 
978         } else {
979             
980             //1 ability point to random ability (attack power or defence power)
981             (pointsGiven, pointsToAttackPower) = _getPoints(1);
982 
983             _attackCompleted(enemyChamp, myChamp, pointsGiven, pointsToAttackPower);
984 
985             emit Attack(enemyChamp.id, myChamp.id, false);
986              
987         }
988         
989         //Trigger cooldown for attacker
990         myChamp.readyTime = uint256(block.timestamp + myChamp.cooldownTime - myChampCooldownReduction);
991 
992     }
993     
994 }
995 
996 
997 /// @title Moderates buying and selling champs
998 contract ChampMarket is ChampAttack {
999 
1000     event TransferChamp(address from, address to, uint256 champID);
1001 
1002     /*
1003      * Modifiers
1004      */
1005     ///@notice Require champ to be sale
1006     modifier champIsForSale(uint256 _id){
1007         require(champs[_id].forSale);
1008         _;
1009     }
1010     
1011 
1012     ///@notice Require champ NOT to be for sale
1013     modifier champIsNotForSale(uint256 _id){
1014         require(champs[_id].forSale == false);
1015         _;
1016     }
1017     
1018 
1019     ///@notice If champ is for sale then cancel sale
1020     modifier ifChampForSaleThenCancelSale(uint256 _champID){
1021       Champ storage champ = champs[_champID];
1022       if(champ.forSale){
1023           _cancelChampSale(champ);
1024       }
1025       _;
1026     }
1027     
1028 
1029     /*
1030      * View
1031      */
1032     ///@notice Gets all champs for sale
1033     function getChampsForSale() view external returns(uint256[]){
1034         uint256[] memory result = new uint256[](champsForSaleCount);
1035         if(champsForSaleCount > 0){
1036             uint256 counter = 0;
1037             for (uint256 i = 0; i < champs.length; i++) {
1038                 if (champs[i].forSale == true) {
1039                     result[counter]=i;
1040                     counter++;
1041                 }
1042             }
1043         }
1044         return result;
1045     }
1046     
1047     
1048     /*
1049      * Private
1050      */
1051      ///@dev Cancel sale. Should not be called without checking if champ is really for sale.
1052      function _cancelChampSale(Champ storage champ) private {
1053         //cancel champ's sale
1054         //no need waste gas to overwrite his price.
1055         champ.forSale = false;
1056         champsForSaleCount--;
1057      }
1058      
1059 
1060     /*
1061      * Internal
1062      */
1063     /// @notice Transfer champ
1064     function transferChamp(address _from, address _to, uint256 _champId) internal ifChampForSaleThenCancelSale(_champId){
1065         Champ storage champ = champs[_champId];
1066 
1067         //transfer champ
1068         addressInfo[_to].champsCount++;
1069         addressInfo[_from].champsCount--;
1070         champToOwner[_champId] = _to;
1071 
1072         //transfer items
1073         if(champ.eq_sword != 0) { transferItem(_from, _to, champ.eq_sword); }
1074         if(champ.eq_shield != 0) { transferItem(_from, _to, champ.eq_shield); }
1075         if(champ.eq_helmet != 0) { transferItem(_from, _to, champ.eq_helmet); }
1076 
1077         emit TransferChamp(_from, _to, _champId);
1078     }
1079 
1080 
1081 
1082     /*
1083      * Public
1084      */
1085     /// @notice Champ is no more for sale
1086     function cancelChampSale(uint256 _id) public 
1087       champIsForSale(_id) 
1088       onlyOwnerOfChamp(_id) {
1089         Champ storage champ = champs[_id];
1090         _cancelChampSale(champ);
1091     }
1092 
1093 
1094     /*
1095      * External
1096      */
1097     /// @notice Gift champ
1098     /// @dev Address _from is msg.sender
1099     function giveChamp(address _to, uint256 _champId) external 
1100       onlyOwnerOfChamp(_champId) {
1101         transferChamp(msg.sender, _to, _champId);
1102     }
1103 
1104 
1105     /// @notice Sets champ for sale
1106     function setChampForSale(uint256 _id, uint256 _price) external 
1107       onlyOwnerOfChamp(_id) 
1108       champIsNotForSale(_id) {
1109         Champ storage champ = champs[_id];
1110         champ.forSale = true;
1111         champ.price = _price;
1112         champsForSaleCount++;
1113     }
1114     
1115     
1116     /// @notice Buys champ
1117     function buyChamp(uint256 _id) external payable 
1118       whenNotPaused 
1119       onlyNotOwnerOfChamp(_id) 
1120       champIsForSale(_id) 
1121       isPaid(champs[_id].price) 
1122       distributeSaleInput(champToOwner[_id]) {
1123         transferChamp(champToOwner[_id], msg.sender, _id);
1124     }
1125     
1126 }
1127 
1128 
1129 
1130 /// @title Only used for deploying all contracts
1131 contract MyCryptoChampCore is ChampMarket {
1132 	/* 
1133 		© Copyright 2018 - Patrik Mojzis
1134 		Redistributing and modifying is prohibited.
1135 		
1136 		https://mycryptochamp.io/
1137 
1138 		What is MyCryptoChamp?
1139 		- Blockchain game about upgrading champs by fighting, getting better items,
1140 		  trading them and the best 800 champs are daily rewarded by real Ether.
1141 
1142 		Feel free to ask any questions
1143 		hello@mycryptochamp.io
1144 	*/
1145 }