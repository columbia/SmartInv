1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
10   */
11   function sub(uint a, uint b) internal pure returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   /**
17   * @dev Adds two numbers, throws on overflow.
18   */
19   function add(uint a, uint b) internal pure returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address internal contractOwner;
33 
34   constructor () internal {
35     if(contractOwner == address(0)){
36       contractOwner = msg.sender;
37     }
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == contractOwner);
45     _;
46   }
47   
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     contractOwner = newOwner;
56   }
57 
58 }
59 
60 contract MyCryptoChampCore{
61     struct Champ {
62         uint id;
63         uint attackPower;
64         uint defencePower;
65         uint cooldownTime; 
66         uint readyTime;
67         uint winCount;
68         uint lossCount;
69         uint position; 
70         uint price; 
71         uint withdrawCooldown; 
72         uint eq_sword; 
73         uint eq_shield; 
74         uint eq_helmet; 
75         bool forSale; 
76     }
77     
78     struct AddressInfo {
79         uint withdrawal;
80         uint champsCount;
81         uint itemsCount;
82         string name;
83     }
84 
85     struct Item {
86         uint id;
87         uint8 itemType; 
88         uint8 itemRarity; 
89         uint attackPower;
90         uint defencePower;
91         uint cooldownReduction;
92         uint price;
93         uint onChampId; 
94         bool onChamp; 
95         bool forSale;
96     }
97     
98     Champ[] public champs;
99     Item[] public items;
100     mapping (uint => uint) public leaderboard;
101     mapping (address => AddressInfo) public addressInfo;
102     mapping (bool => mapping(address => mapping (address => bool))) public tokenOperatorApprovals;
103     mapping (bool => mapping(uint => address)) public tokenApprovals;
104     mapping (bool => mapping(uint => address)) public tokenToOwner;
105     mapping (uint => string) public champToName;
106     mapping (bool => uint) public tokensForSaleCount;
107     uint public pendingWithdrawal = 0;
108 
109     function addWithdrawal(address _address, uint _amount) public;
110     function clearTokenApproval(address _from, uint _tokenId, bool _isTokenChamp) public;
111     function setChampsName(uint _champId, string _name) public;
112     function setLeaderboard(uint _x, uint _value) public;
113     function setTokenApproval(uint _id, address _to, bool _isTokenChamp) public;
114     function setTokenOperatorApprovals(address _from, address _to, bool _approved, bool _isTokenChamp) public;
115     function setTokenToOwner(uint _id, address _owner, bool _isTokenChamp) public;
116     function setTokensForSaleCount(uint _value, bool _isTokenChamp) public;
117     function transferToken(address _from, address _to, uint _id, bool _isTokenChamp) public;
118     function newChamp(uint _attackPower,uint _defencePower,uint _cooldownTime,uint _winCount,uint _lossCount,uint _position,uint _price,uint _eq_sword, uint _eq_shield, uint _eq_helmet, bool _forSale,address _owner) public returns (uint);
119     function newItem(uint8 _itemType,uint8 _itemRarity,uint _attackPower,uint _defencePower,uint _cooldownReduction,uint _price,uint _onChampId,bool _onChamp,bool _forSale,address _owner) public returns (uint);
120     function updateAddressInfo(address _address, uint _withdrawal, bool _updatePendingWithdrawal, uint _champsCount, bool _updateChampsCount, uint _itemsCount, bool _updateItemsCount, string _name, bool _updateName) public;
121     function updateChamp(uint _champId, uint _attackPower,uint _defencePower,uint _cooldownTime,uint _readyTime,uint _winCount,uint _lossCount,uint _position,uint _price,uint _withdrawCooldown,uint _eq_sword, uint _eq_shield, uint _eq_helmet, bool _forSale) public;
122     function updateItem(uint _id,uint8 _itemType,uint8 _itemRarity,uint _attackPower,uint _defencePower,uint _cooldownReduction,uint _price,uint _onChampId,bool _onChamp,bool _forSale) public;
123 
124     function getChampStats(uint256 _champId) public view returns(uint256,uint256,uint256);
125     function getChampsByOwner(address _owner) external view returns(uint256[]);
126     function getTokensForSale(bool _isTokenChamp) view external returns(uint256[]);
127     function getItemsByOwner(address _owner) external view returns(uint256[]);
128     function getTokenCount(bool _isTokenChamp) external view returns(uint);
129     function getTokenURIs(uint _tokenId, bool _isTokenChamp) public view returns(string);
130     function onlyApprovedOrOwnerOfToken(uint _id, address _msgsender, bool _isTokenChamp) external view returns(bool);
131     
132 }
133 
134 contract Inherit is Ownable{
135   address internal coreAddress;
136   MyCryptoChampCore internal core;
137 
138   modifier onlyCore(){
139     require(msg.sender == coreAddress);
140     _;
141   }
142 
143   function loadCoreAddress(address newCoreAddress) public onlyOwner {
144     require(newCoreAddress != address(0));
145     coreAddress = newCoreAddress;
146     core = MyCryptoChampCore(coreAddress);
147   }
148 
149 }
150 
151 contract Strings {
152 
153     function strConcat(string _a, string _b) internal pure returns (string){
154         bytes memory _ba = bytes(_a);
155         bytes memory _bb = bytes(_b);
156         string memory ab = new string(_ba.length + _bb.length);
157         bytes memory bab = bytes(ab);
158         uint k = 0;
159         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
160         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
161         return string(bab);
162     }
163 
164     function uint2str(uint i) internal pure returns (string){
165         if (i == 0) return "0";
166         uint j = i;
167         uint len;
168         while (j != 0){
169             len++;
170             j /= 10;
171         }
172         bytes memory bstr = new bytes(len);
173         uint k = len - 1;
174         while (i != 0){
175             bstr[k--] = byte(48 + i % 10);
176             i /= 10;
177         }
178         return string(bstr);
179     }
180 
181 }
182 
183 //ERC721 Contract 
184 interface EC {
185     function emitTransfer(address _from, address _to, uint _tokenId) external; //Controller uses only this one function
186 }
187 
188 //author Patrik Mojzis
189 contract Controller is Inherit, Strings {
190 
191     using SafeMath for uint; 
192 
193     struct Champ {
194         uint id; //same as position in Champ[]
195         uint attackPower;
196         uint defencePower;
197         uint cooldownTime; //how long does it take to be ready attack again
198         uint readyTime; //if is smaller than block.timestamp champ is ready to fight
199         uint winCount;
200         uint lossCount;
201         uint position; //position in leaderboard. subtract 1 and you got position in leaderboard[]
202         uint price; //selling price
203         uint withdrawCooldown; //if you one of the 800 best champs and withdrawCooldown is less as block.timestamp then you get ETH reward
204         uint eq_sword; 
205         uint eq_shield; 
206         uint eq_helmet; 
207         bool forSale; //is champ for sale?
208     }
209 
210     struct Item {
211         uint id;
212         uint8 itemType; // 1 - Sword | 2 - Shield | 3 - Helmet
213         uint8 itemRarity; // 1 - Common | 2 - Uncommon | 3 - Rare | 4 - Epic | 5 - Legendery | 6 - Forged
214         uint attackPower;
215         uint defencePower;
216         uint cooldownReduction;
217         uint price;
218         uint onChampId; //can not be used to decide if item is on champ, because champ's id can be 0, 'bool onChamp' solves it.
219         bool onChamp; 
220         bool forSale; //is item for sale?
221     }
222 
223     EC champsEC;
224     EC itemsEC;
225      
226     /// @notice People are allowed to withdraw only if min. balance (0.01 gwei) is reached
227     modifier contractMinBalanceReached(){
228         uint pendingWithdrawal = core.pendingWithdrawal();
229         require( (address(core).balance).sub(pendingWithdrawal) > 1000000 );
230         _;
231     }
232     
233     modifier onlyApprovedOrOwnerOfToken(uint _id, address _msgsender, bool _isTokenChamp) 
234     {
235         require(core.onlyApprovedOrOwnerOfToken(_id, _msgsender, _isTokenChamp));
236         _;
237     }
238     
239 
240     /// @notice Gets champ's reward in wei
241     function getChampReward(uint _position) public view returns(uint) 
242     {
243         if(_position <= 800){
244             //percentageMultipier = 10,000
245             //maxReward = 2000 = .2% * percentageMultipier
246             //subtractPerPosition = 2 = .0002% * percentageMultipier
247             //2000 - (2 * (_position - 1))
248             uint rewardPercentage = uint(2000).sub(2 * (_position - 1));
249 
250             //available funds are all funds - already pending
251             uint availableWithdrawal = address(coreAddress).balance.sub(core.pendingWithdrawal());
252 
253             //calculate reward for champ's position
254             //1000000 = percentageMultipier * 100
255             return availableWithdrawal / 1000000 * rewardPercentage;
256         }else{
257             return uint(0);
258         }
259     }
260 
261     function setChampEC(address _address) public onlyOwner {
262         champsEC = EC(_address);
263     }
264 
265 
266     function setItemsEC(address _address) public onlyOwner {
267         itemsEC = EC(_address);
268     }
269 
270     function changeChampsName(uint _champId, string _name, address _msgsender) external 
271     onlyApprovedOrOwnerOfToken(_champId, _msgsender, true)
272     onlyCore
273     {
274         core.setChampsName(_champId, _name);
275     }
276 
277     /// @dev Move champ reward to pending withdrawal to his wallet. 
278     function withdrawChamp(uint _id, address _msgsender) external 
279     onlyApprovedOrOwnerOfToken(_id, _msgsender, true) 
280     contractMinBalanceReached  
281     onlyCore 
282     {
283         Champ memory champ = _getChamp(_id);
284         require(champ.position <= 800); 
285         require(champ.withdrawCooldown < block.timestamp); //isChampWithdrawReady
286 
287         champ.withdrawCooldown = block.timestamp + 1 days; //one withdrawal 1 per day
288         _updateChamp(champ); //update core storage
289 
290         core.addWithdrawal(_msgsender, getChampReward(champ.position));
291     }
292     
293 
294     /// @dev Is called from from Attack function after the winner is already chosen. Updates abilities, champ's stats and swaps positions.
295     function _attackCompleted(Champ memory _winnerChamp, Champ memory _defeatedChamp, uint _pointsGiven) private 
296     {
297         /*
298          * Updates abilities after fight
299          */
300         //winner abilities update
301         _winnerChamp.attackPower += _pointsGiven; //increase attack power
302         _winnerChamp.defencePower += _pointsGiven; //max point that was given - already given to AP
303                 
304         //defeated champ's abilities update
305         //checks for not cross minimal AP & DP points
306         //_defeatedChamp.attackPower = _subAttack(_defeatedChamp.attackPower, _pointsGiven); //decrease attack power
307         _defeatedChamp.attackPower = (_defeatedChamp.attackPower <= _pointsGiven + 2) ? 2 : _defeatedChamp.attackPower - _pointsGiven; //Subtracts ability points. Helps to not cross minimal attack ability points -> 2
308 
309         //_defeatedChamp.defencePower = _subDefence(_defeatedChamp.defencePower, _pointsGiven); // decrease defence power
310         _defeatedChamp.defencePower = (_defeatedChamp.defencePower <= _pointsGiven) ? 1 : _defeatedChamp.defencePower - _pointsGiven; //Subtracts ability points. Helps to not cross minimal defence ability points -> 1
311 
312 
313         /*
314          * Update champs' wins and losses
315          */
316         _winnerChamp.winCount++;
317         _defeatedChamp.lossCount++;
318             
319 
320         /*
321          * Swap positions
322          */
323         if(_winnerChamp.position > _defeatedChamp.position) { //require loser to has better (lower) postion than attacker
324             uint winnerPosition = _winnerChamp.position;
325             uint loserPosition = _defeatedChamp.position;
326         
327             _defeatedChamp.position = winnerPosition;
328             _winnerChamp.position = loserPosition;
329         }
330 
331         _updateChamp(_winnerChamp);
332         _updateChamp(_defeatedChamp);
333     }
334 
335 
336     /*
337      * External
338      */
339     function attack(uint _champId, uint _targetId, address _msgsender) external 
340     onlyApprovedOrOwnerOfToken(_champId, _msgsender, true) 
341     onlyCore 
342     {
343         Champ memory myChamp = _getChamp(_champId); 
344         Champ memory enemyChamp = _getChamp(_targetId); 
345         
346         require (myChamp.readyTime <= block.timestamp); /// Is champ ready to fight again?
347         require(_champId != _targetId); /// Prevents from self-attack
348         require(core.tokenToOwner(true, _targetId) != address(0)); /// Checks if champ does exist
349     
350         uint pointsGiven; //total points that will be divided between AP and DP
351         uint myChampAttackPower;  
352         uint enemyChampDefencePower; 
353         uint myChampCooldownReduction;
354         
355         (myChampAttackPower,,myChampCooldownReduction) = core.getChampStats(_champId);
356         (,enemyChampDefencePower,) = core.getChampStats(_targetId);
357 
358 
359         //if attacker's AP is more than target's DP then attacker wins
360         if (myChampAttackPower > enemyChampDefencePower) {
361             
362             //this should demotivate players from farming on way weaker champs than they are
363             //the bigger difference between AP & DP is, the reward is smaller
364             if(myChampAttackPower - enemyChampDefencePower < 5){
365                 pointsGiven = 6; //big experience - 6 ability points
366             }else if(myChampAttackPower - enemyChampDefencePower < 10){
367                 pointsGiven = 4; //medium experience - 4 ability points
368             }else{
369                 pointsGiven = 2; //small experience - 2 ability point to random ability (attack power or defence power)
370             }
371             
372             _attackCompleted(myChamp, enemyChamp, pointsGiven/2);
373 
374         } else {
375             
376             //1 ability point to random ability (attack power or defence power)
377             pointsGiven = 2;
378 
379             _attackCompleted(enemyChamp, myChamp, pointsGiven/2);
380              
381         }
382         
383         //Trigger cooldown for attacker
384         myChamp.readyTime = uint(block.timestamp + myChamp.cooldownTime - myChampCooldownReduction);
385 
386         _updateChamp(myChamp);
387 
388     }
389 
390      function _cancelChampSale(Champ memory _champ) private 
391      {
392         //cancel champ's sale
393         //no need waste gas to overwrite his price.
394         _champ.forSale = false;
395 
396         /*
397         uint champsForSaleCount = core.champsForSaleCount() - 1;
398         core.setTokensForSaleCount(champsForSaleCount, true);
399         */
400 
401         _updateChamp(_champ);
402      }
403      
404 
405     function _transferChamp(address _from, address _to, uint _champId) private onlyCore
406     {
407         Champ memory champ = _getChamp(_champId);
408 
409         //ifChampForSaleThenCancelSale
410         if(champ.forSale){
411              _cancelChampSale(champ);
412         }
413 
414         core.clearTokenApproval(_from, _champId, true);
415 
416         //transfer champ
417         (,uint toChampsCount,,) = core.addressInfo(_to); 
418         (,uint fromChampsCount,,) = core.addressInfo(_from);
419 
420         core.updateAddressInfo(_to,0,false,toChampsCount + 1,true,0,false,"",false);
421         core.updateAddressInfo(_from,0,false,fromChampsCount - 1,true,0,false,"",false);
422 
423         core.setTokenToOwner(_champId, _to, true);
424 
425         champsEC.emitTransfer(_from,_to,_champId);
426 
427         //transfer items
428         if(champ.eq_sword != 0) { _transferItem(_from, _to, champ.eq_sword); }
429         if(champ.eq_shield != 0) { _transferItem(_from, _to, champ.eq_shield); }
430         if(champ.eq_helmet != 0) { _transferItem(_from, _to, champ.eq_helmet); }
431     }
432 
433 
434     function transferToken(address _from, address _to, uint _id, bool _isTokenChamp) external
435     onlyCore{
436         if(_isTokenChamp){
437             _transferChamp(_from, _to, _id);
438         }else{
439             _transferItem(_from, _to, _id);
440         }
441     }
442 
443     function cancelTokenSale(uint _id, address _msgsender, bool _isTokenChamp) public 
444       onlyApprovedOrOwnerOfToken(_id, _msgsender, _isTokenChamp)
445       onlyCore 
446     {
447         if(_isTokenChamp){
448             Champ memory champ = _getChamp(_id);
449             require(champ.forSale); //champIsForSale
450             _cancelChampSale(champ);
451         }else{
452             Item memory item = _getItem(_id);
453           require(item.forSale);
454            _cancelItemSale(item);
455         }
456     }
457 
458     /// @dev Address _from is msg.sender
459     function giveToken(address _to, uint _id, address _msgsender, bool _isTokenChamp) external 
460       onlyApprovedOrOwnerOfToken(_id, _msgsender, _isTokenChamp)
461       onlyCore 
462     {
463         if(_isTokenChamp){
464             _transferChamp(core.tokenToOwner(true,_id), _to, _id);
465         }else{
466              _transferItem(core.tokenToOwner(false,_id), _to, _id);
467         }
468     }
469 
470 
471     function setTokenForSale(uint _id, uint _price, address _msgsender, bool _isTokenChamp) external 
472       onlyApprovedOrOwnerOfToken(_id, _msgsender, _isTokenChamp) 
473       onlyCore 
474     {
475         if(_isTokenChamp){
476             Champ memory champ = _getChamp(_id);
477             require(champ.forSale == false); //champIsNotForSale
478             champ.forSale = true;
479             champ.price = _price;
480             _updateChamp(champ);
481             
482             /*
483             uint champsForSaleCount = core.champsForSaleCount() + 1;
484             core.setTokensForSaleCount(champsForSaleCount,true);
485             */
486         }else{
487             Item memory item = _getItem(_id);
488             require(item.forSale == false);
489             item.forSale = true;
490             item.price = _price;
491             _updateItem(item);
492             
493             /*
494             uint itemsForSaleCount = core.itemsForSaleCount() + 1;
495             core.setTokensForSaleCount(itemsForSaleCount,false);
496             */
497         }
498 
499     }
500 
501     function _updateChamp(Champ memory champ) private 
502     {
503         core.updateChamp(champ.id, champ.attackPower, champ.defencePower, champ.cooldownTime, champ.readyTime, champ.winCount, champ.lossCount, champ.position, champ.price, champ.withdrawCooldown, champ.eq_sword, champ.eq_shield, champ.eq_helmet, champ.forSale);
504     }
505 
506     function _updateItem(Item memory item) private
507     {
508         core.updateItem(item.id, item.itemType, item.itemRarity, item.attackPower, item.defencePower, item.cooldownReduction,item.price, item.onChampId, item.onChamp, item.forSale);
509     }
510     
511     function _getChamp(uint _champId) private view returns (Champ)
512     {
513         Champ memory champ;
514         
515         //CompilerError: Stack too deep, try removing local variables.
516         (champ.id, champ.attackPower, champ.defencePower, champ.cooldownTime, champ.readyTime, champ.winCount, champ.lossCount, champ.position,,,,,,) = core.champs(_champId);
517         (,,,,,,,,champ.price, champ.withdrawCooldown, champ.eq_sword, champ.eq_shield, champ.eq_helmet, champ.forSale) = core.champs(_champId);
518         
519         return champ;
520     }
521     
522     function _getItem(uint _itemId) private view returns (Item)
523     {
524         Item memory item;
525         
526         //CompilerError: Stack too deep, try removing local variables.
527         (item.id, item.itemType, item.itemRarity, item.attackPower, item.defencePower, item.cooldownReduction,,,,) = core.items(_itemId);
528         (,,,,,,item.price, item.onChampId, item.onChamp, item.forSale) = core.items(_itemId);
529         
530         return item;
531     }
532 
533     function getTokenURIs(uint _id, bool _isTokenChamp) public pure returns(string)
534     {
535         if(_isTokenChamp){
536             return strConcat('https://mccapi.patrikmojzis.com/champ.php?id=', uint2str(_id));
537         }else{
538             return strConcat('https://mccapi.patrikmojzis.com/item.php?id=', uint2str(_id));
539         }
540     }
541 
542 
543     function _takeOffItem(uint _champId, uint8 _type) private
544     {
545         uint itemId;
546         Champ memory champ = _getChamp(_champId);
547         if(_type == 1){
548             itemId = champ.eq_sword; //Get item ID
549             if (itemId > 0) { //0 = nothing
550                 champ.eq_sword = 0; //take off sword
551             }
552         }
553         if(_type == 2){
554             itemId = champ.eq_shield; //Get item ID
555             if(itemId > 0) {//0 = nothing
556                 champ.eq_shield = 0; //take off shield
557             }
558         }
559         if(_type == 3){
560             itemId = champ.eq_helmet; //Get item ID
561             if(itemId > 0) { //0 = nothing
562                 champ.eq_helmet = 0; //take off 
563             }
564         }
565         if(itemId > 0){
566             Item memory item = _getItem(itemId);
567             item.onChamp = false;
568             _updateItem(item);
569         }
570     }
571 
572     function takeOffItem(uint _champId, uint8 _type, address _msgsender) public 
573     onlyApprovedOrOwnerOfToken(_champId, _msgsender, true) 
574     onlyCore
575     {
576             _takeOffItem(_champId, _type);
577     }
578 
579     function putOn(uint _champId, uint _itemId, address _msgsender) external 
580         onlyApprovedOrOwnerOfToken(_champId, _msgsender, true) 
581         onlyApprovedOrOwnerOfToken(_itemId, _msgsender, false) 
582         onlyCore 
583         {
584             Champ memory champ = _getChamp(_champId);
585             Item memory item = _getItem(_itemId);
586 
587             //checks if items is on some other champ
588             if(item.onChamp){
589                 _takeOffItem(item.onChampId, item.itemType); //take off from champ
590             }
591 
592             item.onChamp = true; //item is on champ
593             item.onChampId = _champId; //champ's id
594 
595             //put on
596             if(item.itemType == 1){
597                 //take off actual sword 
598                 if(champ.eq_sword > 0){
599                     _takeOffItem(champ.id, 1);
600                 }
601                 champ.eq_sword = _itemId; //put on sword
602             }
603             if(item.itemType == 2){
604                 //take off actual shield 
605                 if(champ.eq_shield > 0){
606                     _takeOffItem(champ.id, 2);
607                 }
608                 champ.eq_shield = _itemId; //put on shield
609             }
610             if(item.itemType == 3){
611                 //take off actual helmet 
612                 if(champ.eq_helmet > 0){
613                     _takeOffItem(champ.id, 3);
614                 }
615                 champ.eq_helmet = _itemId; //put on helmet
616             }
617 
618             _updateChamp(champ);
619             _updateItem(item);
620     }
621 
622 
623     function _cancelItemSale(Item memory item) private {
624       //No need to overwrite item's price
625       item.forSale = false;
626       
627       /*
628       uint itemsForSaleCount = core.itemsForSaleCount() - 1;
629       core.setTokensForSaleCount(itemsForSaleCount, false);
630       */
631 
632       _updateItem(item);
633     }
634 
635     function _transferItem(address _from, address _to, uint _itemID) private 
636     {
637         Item memory item = _getItem(_itemID);
638 
639         if(item.forSale){
640               _cancelItemSale(item);
641         }
642 
643         //take off      
644         if(item.onChamp && _to != core.tokenToOwner(true, item.onChampId)){
645           _takeOffItem(item.onChampId, item.itemType);
646         }
647 
648         core.clearTokenApproval(_from, _itemID, false);
649 
650         //transfer item
651         (,,uint toItemsCount,) = core.addressInfo(_to);
652         (,,uint fromItemsCount,) = core.addressInfo(_from);
653 
654         core.updateAddressInfo(_to,0,false,0,false,toItemsCount + 1,true,"",false);
655         core.updateAddressInfo(_from,0,false,0,false,fromItemsCount - 1,true,"",false);
656         
657         core.setTokenToOwner(_itemID, _to,false);
658 
659         itemsEC.emitTransfer(_from,_to,_itemID);
660     }
661 
662     function forgeItems(uint _parentItemID, uint _childItemID, address _msgsender) external 
663     onlyApprovedOrOwnerOfToken(_parentItemID, _msgsender, false) 
664     onlyApprovedOrOwnerOfToken(_childItemID, _msgsender, false) 
665     onlyCore
666     {
667         //checks if items are not the same
668         require(_parentItemID != _childItemID);
669         
670         Item memory parentItem = _getItem(_parentItemID);
671         Item memory childItem = _getItem(_childItemID);
672         
673         //if Item For Sale Then Cancel Sale
674         if(parentItem.forSale){
675           _cancelItemSale(parentItem);
676         }
677         
678         //if Item For Sale Then Cancel Sale
679         if(childItem.forSale){
680           _cancelItemSale(childItem);
681         }
682 
683         //take child item off, because child item will be burned
684         if(childItem.onChamp){
685             _takeOffItem(childItem.onChampId, childItem.itemType);
686         }
687 
688         //update parent item
689         parentItem.attackPower = (parentItem.attackPower > childItem.attackPower) ? parentItem.attackPower : childItem.attackPower;
690         parentItem.defencePower = (parentItem.defencePower > childItem.defencePower) ? parentItem.defencePower : childItem.defencePower;
691         parentItem.cooldownReduction = (parentItem.cooldownReduction > childItem.cooldownReduction) ? parentItem.cooldownReduction : childItem.cooldownReduction;
692         parentItem.itemRarity = uint8(6);
693 
694         _updateItem(parentItem);
695 
696         //burn child item
697         _transferItem(core.tokenToOwner(false,_childItemID), address(0), _childItemID);
698 
699     }
700 
701 
702 }