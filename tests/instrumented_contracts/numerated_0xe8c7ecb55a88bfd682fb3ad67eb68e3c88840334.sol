1 pragma solidity ^ 0.4.19;
2 
3 // DopeRaider Districts Contract
4 // by gasmasters.io
5 // contact: team@doperaider.com
6 
7 // special thanks to :
8 //                    8฿ł₮₮Ɽł₱
9 //                    Etherguy
10 
11 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
12 contract ERC721 {
13   function implementsERC721() public pure returns(bool);
14   function totalSupply() public view returns(uint256 total);
15   function balanceOf(address _owner) public view returns(uint256 balance);
16   function ownerOf(uint256 _tokenId) public view returns(address owner);
17   function approve(address _to, uint256 _tokenId) public;
18   function transferFrom(address _from, address _to, uint256 _tokenId) public;
19   function transfer(address _to, uint256 _tokenId) public;
20   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
21   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
22 
23   // Optional
24   // function name() public view returns (string name);
25   // function symbol() public view returns (string symbol);
26   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
27   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
28 }
29 
30 // File: contracts/NarcoCoreInterface.sol
31 
32 contract NarcosCoreInterface is ERC721 {
33   function getNarco(uint256 _id)
34   public
35   view
36   returns(
37     string  narcoName,
38     uint256 weedTotal,
39     uint256 cokeTotal,
40     uint16[6] skills,
41     uint8[4] consumables,
42     string genes,
43     uint8 homeLocation,
44     uint16 level,
45     uint256[6] cooldowns,
46     uint256 id,
47     uint16[9] stats
48   );
49 
50   function updateWeedTotal(uint256 _narcoId, bool _add, uint16 _total) public;
51   function updateCokeTotal(uint256 _narcoId, bool _add,  uint16 _total) public;
52   function updateConsumable(uint256 _narcoId, uint256 _index, uint8 _new) public;
53   function updateSkill(uint256 _narcoId, uint256 _index, uint16 _new) public;
54   function incrementStat(uint256 _narcoId, uint256 _index) public;
55   function setCooldown(uint256 _narcoId , uint256 _index , uint256 _new) public;
56   function getRemainingCapacity(uint256 _id) public view returns (uint8 capacity);
57 }
58 
59 // File: contracts/Ownable.sol
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   function Ownable() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 // File: contracts/Pausable.sol
102 
103 /**
104  * @title Pausable
105  * @dev Base contract which allows children to implement an emergency stop mechanism.
106  */
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = true;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() onlyOwner whenNotPaused public {
134     paused = true;
135     Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     Unpause();
144   }
145 }
146 
147 
148 // File: contracts/Districts/DistrictsAdmin.sol
149 
150 contract DistrictsAdmin is Ownable, Pausable {
151   event ContractUpgrade(address newContract);
152 
153   address public newContractAddress;
154   address public coreAddress;
155 
156   NarcosCoreInterface public narcoCore;
157 
158   function setNarcosCoreAddress(address _address) public onlyOwner {
159     _setNarcosCoreAddress(_address);
160   }
161 
162   function _setNarcosCoreAddress(address _address) internal {
163     NarcosCoreInterface candidateContract = NarcosCoreInterface(_address);
164     require(candidateContract.implementsERC721());
165     coreAddress = _address;
166     narcoCore = candidateContract;
167   }
168 
169   /// @dev Used to mark the smart contract as upgraded, in case there is a serious
170   ///  breaking bug. This method does nothing but keep track of the new contract and
171   ///  emit a message indicating that the new address is set. It's up to clients of this
172   ///  contract to update to the new contract address in that case.
173   /// @param _v2Address new address
174   function setNewAddress(address _v2Address) public onlyOwner whenPaused {
175     newContractAddress = _v2Address;
176 
177     ContractUpgrade(_v2Address);
178   }
179 
180 
181   // token manager contract
182   address [6] public tokenContractAddresses;
183 
184   function setTokenAddresses(address[6] _addresses) public onlyOwner {
185       tokenContractAddresses = _addresses;
186   }
187 
188   modifier onlyDopeRaiderContract() {
189     require(msg.sender == coreAddress);
190     _;
191   }
192 
193   modifier onlyTokenContract() {
194     require(
195         msg.sender == tokenContractAddresses[0] ||
196         msg.sender == tokenContractAddresses[1] ||
197         msg.sender == tokenContractAddresses[2] ||
198         msg.sender == tokenContractAddresses[3] ||
199         msg.sender == tokenContractAddresses[4] ||
200         msg.sender == tokenContractAddresses[5]
201       );
202     _;
203   }
204 
205 }
206 
207 
208 // File: contracts/DistrictsCore.sol
209 
210 contract DistrictsCore is DistrictsAdmin {
211 
212   // DISTRICT EVENTS
213   event NarcoArrived(uint8 indexed location, uint256 indexed narcoId); // who just arrived here
214   event NarcoLeft(uint8 indexed location, uint256 indexed narcoId); // who just left here
215   event TravelBust(uint256 indexed narcoId, uint16 confiscatedWeed, uint16 confiscatedCoke);
216   event Hijacked(uint256 indexed hijacker, uint256 indexed victim , uint16 stolenWeed , uint16 stolenCoke);
217   event HijackDefended(uint256 indexed hijacker, uint256 indexed victim);
218   event EscapedHijack(uint256 indexed hijacker, uint256 indexed victim , uint8 escapeLocation);
219 
220   uint256 public airLiftPrice = 0.01 ether; // home dorothy price
221   uint256 public hijackPrice = 0.008 ether; // universal hijackPrice
222   uint256 public travelPrice = 0.002 ether; // universal travelPrice
223   uint256 public spreadPercent = 5; // universal spread between buy and sell
224   uint256 public devFeePercent = 2; // on various actions
225   uint256 public currentDevFees = 0;
226   uint256 public bustRange = 10;
227 
228   function setAirLiftPrice(uint256 _price) public onlyOwner{
229     airLiftPrice = _price;
230   }
231 
232   function setBustRange(uint256 _range) public onlyOwner{
233     bustRange = _range;
234   }
235 
236   function setHijackPrice(uint256 _price) public onlyOwner{
237     hijackPrice = _price;
238   }
239 
240   function setTravelPrice(uint256 _price) public onlyOwner{
241     travelPrice = _price;
242   }
243 
244   function setSpreadPercent(uint256 _spread) public onlyOwner{
245     spreadPercent = _spread;
246   }
247 
248   function setDevFeePercent(uint256 _fee) public onlyOwner{
249     devFeePercent = _fee;
250   }
251 
252   function isDopeRaiderDistrictsCore() public pure returns(bool){ return true; }
253 
254 
255   // Market Items
256 
257   struct MarketItem{
258     uint256 id;
259     string itemName;
260     uint8 skillAffected;
261     uint8 upgradeAmount;
262     uint8 levelRequired; // the level a narco must have before they
263   }
264 
265   // there is a fixed amount of items - they are not tokens bc iterations will be needed.
266   // 0,1 = weed , coke , 2 - 4 consumables , 5-23 items
267   MarketItem[24] public marketItems;
268 
269   function configureMarketItem(uint256 _id, uint8 _skillAffected, uint8  _upgradeAmount, uint8 _levelRequired, string _itemName) public onlyOwner{
270     marketItems[_id].skillAffected = _skillAffected;
271     marketItems[_id].upgradeAmount = _upgradeAmount;
272     marketItems[_id].levelRequired = _levelRequired;
273     marketItems[_id].itemName = _itemName;
274     marketItems[_id].id = _id;
275   }
276 
277 
278   struct District {
279     uint256[6] exits;
280     uint256 weedPot;
281     uint256 weedAmountHere;
282     uint256 cokePot;
283     uint256 cokeAmountHere;
284     uint256[24] marketPrices;
285     bool[24] isStocked;
286     bool hasMarket;
287     string name;
288   }
289 
290   District[8] public districts; // there is no '0' district - this will be used to indicate no exit
291 
292   // for keeping track of who is where
293   mapping(uint256 => uint8) narcoIndexToLocation;
294 
295   function DistrictsCore() public {
296   }
297 
298   function getDistrict(uint256 _id) public view returns(uint256[6] exits, bool hasMarket, uint256[24] prices, bool[24] isStocked, uint256 weedPot, uint256 cokePot, uint256 weedAmountHere, uint256 cokeAmountHere, string name){
299     District storage district = districts[_id];
300     exits = district.exits;
301     hasMarket = district.hasMarket;
302     prices = district.marketPrices;
303 
304     // minimum prices for w/c set in the districts configuration file
305     prices[0] = max(prices[0], (((district.weedPot / district.weedAmountHere)/100)*(100+spreadPercent)));// Smeti calc this is the buy price (contract sells)
306     prices[1] = max(prices[1], (((district.cokePot / district.cokeAmountHere)/100)*(100+spreadPercent)));  // Smeti calc this is the buy price (contract sells)
307     isStocked = district.isStocked;
308     weedPot = district.weedPot;
309     cokePot = district.cokePot;
310     weedAmountHere = district.weedAmountHere;
311     cokeAmountHere = district.cokeAmountHere;
312     name = district.name;
313   }
314 
315   function createNamedDistrict(uint256 _index, string _name, bool _hasMarket) public onlyOwner{
316     districts[_index].name = _name;
317     districts[_index].hasMarket = _hasMarket;
318     districts[_index].weedAmountHere = 1;
319     districts[_index].cokeAmountHere = 1;
320     districts[_index].weedPot = 0.001 ether;
321     districts[_index].cokePot = 0.001 ether;
322   }
323 
324   function initializeSupply(uint256 _index, uint256 _weedSupply, uint256 _cokeSupply) public onlyOwner{
325     districts[_index].weedAmountHere = _weedSupply;
326     districts[_index].cokeAmountHere = _cokeSupply;
327   }
328 
329   function configureDistrict(uint256 _index, uint256[6]_exits, uint256[24] _prices, bool[24] _isStocked) public onlyOwner{
330     districts[_index].exits = _exits; // clockwise starting at noon
331     districts[_index].marketPrices = _prices;
332     districts[_index].isStocked = _isStocked;
333   }
334 
335   // callable by other contracts to control economy
336   function increaseDistrictWeed(uint256 _district, uint256 _quantity) public onlyDopeRaiderContract{
337     districts[_district].weedAmountHere += _quantity;
338   }
339   function increaseDistrictCoke(uint256 _district, uint256 _quantity) public onlyDopeRaiderContract{
340     districts[_district].cokeAmountHere += _quantity;
341   }
342 
343   // proxy updates to main contract
344   function updateConsumable(uint256 _narcoId,  uint256 _index ,uint8 _newQuantity) public onlyTokenContract {
345     narcoCore.updateConsumable(_narcoId,  _index, _newQuantity);
346   }
347 
348   function updateWeedTotal(uint256 _narcoId,  uint16 _total) public onlyTokenContract {
349     narcoCore.updateWeedTotal(_narcoId,  true , _total);
350     districts[getNarcoLocation(_narcoId)].weedAmountHere += uint8(_total);
351   }
352 
353   function updatCokeTotal(uint256 _narcoId,  uint16 _total) public onlyTokenContract {
354     narcoCore.updateCokeTotal(_narcoId,  true , _total);
355     districts[getNarcoLocation(_narcoId)].cokeAmountHere += uint8(_total);
356   }
357 
358 
359   function getNarcoLocation(uint256 _narcoId) public view returns(uint8 location){
360     location = narcoIndexToLocation[_narcoId];
361     // could be they have not travelled, so just return their home location
362     if (location == 0) {
363       (
364             ,
365             ,
366             ,
367             ,
368             ,
369             ,
370         location
371         ,
372         ,
373         ,
374         ,
375         ) = narcoCore.getNarco(_narcoId);
376 
377     }
378 
379   }
380 
381   function getNarcoHomeLocation(uint256 _narcoId) public view returns(uint8 location){
382       (
383             ,
384             ,
385             ,
386             ,
387             ,
388             ,
389         location
390         ,
391         ,
392         ,
393         ,
394         ) = narcoCore.getNarco(_narcoId);
395   }
396 
397   // function to be called when wanting to add funds to all districts
398   function floatEconony() public payable onlyOwner {
399         if(msg.value>0){
400           for (uint district=1;district<8;district++){
401               districts[district].weedPot+=(msg.value/14);
402               districts[district].cokePot+=(msg.value/14);
403             }
404         }
405     }
406 
407   // function to be called when wanting to add funds to a district
408   function distributeRevenue(uint256 _district , uint8 _splitW, uint8 _splitC) public payable onlyDopeRaiderContract {
409         if(msg.value>0){
410          _distributeRevenue(msg.value, _district, _splitW, _splitC);
411         }
412   }
413 
414   uint256 public localRevenuePercent = 80;
415 
416   function setLocalRevenuPercent(uint256 _lrp) public onlyOwner{
417     localRevenuePercent = _lrp;
418   }
419 
420   function _distributeRevenue(uint256 _grossRevenue, uint256 _district , uint8 _splitW, uint8 _splitC) internal {
421           // subtract dev fees
422           uint256 onePc = _grossRevenue/100;
423           uint256 netRevenue = onePc*(100-devFeePercent);
424           uint256 devFee = onePc*(devFeePercent);
425 
426           uint256 districtRevenue = (netRevenue/100)*localRevenuePercent;
427           uint256 federalRevenue = (netRevenue/100)*(100-localRevenuePercent);
428 
429           // distribute district revenue
430           // split evenly between weed and coke pots
431           districts[_district].weedPot+=(districtRevenue/100)*_splitW;
432           districts[_district].cokePot+=(districtRevenue/100)*_splitC;
433 
434           // distribute federal revenue
435            for (uint district=1;district<8;district++){
436               districts[district].weedPot+=(federalRevenue/14);
437               districts[district].cokePot+=(federalRevenue/14);
438             }
439 
440           // acrue dev fee
441           currentDevFees+=devFee;
442   }
443 
444   function withdrawFees() external onlyOwner {
445         if (currentDevFees<=address(this).balance){
446           currentDevFees = 0;
447           msg.sender.transfer(currentDevFees);
448         }
449     }
450 
451 
452   function buyItem(uint256 _narcoId, uint256 _district, uint256 _itemIndex, uint256 _quantity) public payable whenNotPaused{
453     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
454 
455     uint256 narcoWeedTotal;
456     uint256 narcoCokeTotal;
457     uint16[6] memory narcoSkills;
458     uint8[4] memory narcoConsumables;
459     uint16 narcoLevel;
460 
461     (
462                 ,
463       narcoWeedTotal,
464       narcoCokeTotal,
465       narcoSkills,
466       narcoConsumables,
467                 ,
468                 ,
469       narcoLevel,
470                 ,
471                 ,
472     ) = narcoCore.getNarco(_narcoId);
473 
474     require(getNarcoLocation(_narcoId) == uint8(_district)); // right place to buy
475     require(uint8(_quantity) > 0 && districts[_district].isStocked[_itemIndex] == true); // there is enough of it
476     require(marketItems[_itemIndex].levelRequired <= narcoLevel || _district==7); //  must be level to buy this item or black market
477     require(narcoCore.getRemainingCapacity(_narcoId) >= _quantity || _itemIndex>=6); // narco can carry it or not a consumable
478 
479     // progression through the upgrades for non consumable items (>=6)
480     if (_itemIndex>=6) {
481       require (_quantity==1);
482 
483       if (marketItems[_itemIndex].skillAffected!=5){
484             // regular items
485             require (marketItems[_itemIndex].levelRequired==0 || narcoSkills[marketItems[_itemIndex].skillAffected]<marketItems[_itemIndex].upgradeAmount);
486           }else{
487             // capacity has 20 + requirement
488             require (narcoSkills[5]<20+marketItems[_itemIndex].upgradeAmount);
489       }
490     }
491 
492     uint256 costPrice = districts[_district].marketPrices[_itemIndex] * _quantity;
493 
494     if (_itemIndex ==0 ) {
495       costPrice = max(districts[_district].marketPrices[0], (((districts[_district].weedPot / districts[_district].weedAmountHere)/100)*(100+spreadPercent))) * _quantity;
496     }
497     if (_itemIndex ==1 ) {
498       costPrice = max(districts[_district].marketPrices[1], (((districts[_district].cokePot / districts[_district].cokeAmountHere)/100)*(100+spreadPercent))) * _quantity;
499     }
500 
501     require(msg.value >= costPrice); // paid enough?
502     // ok purchase here
503     if (_itemIndex > 1 && _itemIndex < 6) {
504       // consumable
505       narcoCore.updateConsumable(_narcoId, _itemIndex - 2, uint8(narcoConsumables[_itemIndex - 2] + _quantity));
506        _distributeRevenue(costPrice, _district , 50, 50);
507     }
508 
509     if (_itemIndex >= 6) {
510         // skills boost
511         // check which skill is updated by this item
512         narcoCore.updateSkill(
513           _narcoId,
514           marketItems[_itemIndex].skillAffected,
515           uint16(narcoSkills[marketItems[_itemIndex].skillAffected] + (marketItems[_itemIndex].upgradeAmount))
516         );
517         _distributeRevenue(costPrice, _district , 50, 50);
518     }
519     if (_itemIndex == 0) {
520         // weedTotal
521         narcoCore.updateWeedTotal(_narcoId, true,  uint16(_quantity));
522         districts[_district].weedAmountHere += uint8(_quantity);
523         _distributeRevenue(costPrice, _district , 100, 0);
524     }
525     if (_itemIndex == 1) {
526        // cokeTotal
527        narcoCore.updateCokeTotal(_narcoId, true, uint16(_quantity));
528        districts[_district].cokeAmountHere += uint8(_quantity);
529        _distributeRevenue(costPrice, _district , 0, 100);
530     }
531 
532     // allow overbid
533     if (msg.value>costPrice){
534         msg.sender.transfer(msg.value-costPrice);
535     }
536 
537   }
538 
539 
540   function sellItem(uint256 _narcoId, uint256 _district, uint256 _itemIndex, uint256 _quantity) public whenNotPaused{
541     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
542     require(_itemIndex < marketItems.length && _district < 8 && _district > 0 && _quantity > 0); // valid item and district and quantity
543 
544     uint256 narcoWeedTotal;
545     uint256 narcoCokeTotal;
546 
547     (
548                 ,
549       narcoWeedTotal,
550       narcoCokeTotal,
551                 ,
552                 ,
553                 ,
554                 ,
555                 ,
556                 ,
557                 ,
558             ) = narcoCore.getNarco(_narcoId);
559 
560 
561     require(getNarcoLocation(_narcoId) == _district); // right place to buy
562     // at this time only weed and coke can be sold to the contract
563     require((_itemIndex == 0 && narcoWeedTotal >= _quantity) || (_itemIndex == 1 && narcoCokeTotal >= _quantity));
564 
565     uint256 salePrice = 0;
566 
567     if (_itemIndex == 0) {
568       salePrice = districts[_district].weedPot / districts[_district].weedAmountHere;  // Smeti calc this is the sell price (contract buys)
569     }
570     if (_itemIndex == 1) {
571       salePrice = districts[_district].cokePot / districts[_district].cokeAmountHere;  // Smeti calc this is the sell price (contract buys)
572     }
573     require(salePrice > 0); // yeah that old chestnut lol
574 
575     // do the updates
576     if (_itemIndex == 0) {
577       narcoCore.updateWeedTotal(_narcoId, false, uint16(_quantity));
578       districts[_district].weedPot=sub(districts[_district].weedPot,salePrice*_quantity);
579       districts[_district].weedAmountHere=sub(districts[_district].weedAmountHere,_quantity);
580     }
581     if (_itemIndex == 1) {
582       narcoCore.updateCokeTotal(_narcoId, false, uint16(_quantity));
583       districts[_district].cokePot=sub(districts[_district].cokePot,salePrice*_quantity);
584       districts[_district].cokeAmountHere=sub(districts[_district].cokeAmountHere,_quantity);
585     }
586     narcoCore.incrementStat(_narcoId, 0); // dealsCompleted
587     // transfer the amount to the seller - should be owner of, but for now...
588     msg.sender.transfer(salePrice*_quantity);
589 
590   }
591 
592 
593 
594   // allow a Narco to travel between districts
595   // travelling is done by taking "exit" --> index into the loctions
596   function travelTo(uint256 _narcoId, uint256 _exitId) public payable whenNotPaused{
597     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
598     require((msg.value >= travelPrice && _exitId < 7) || (msg.value >= airLiftPrice && _exitId==7));
599 
600     // exitId ==7 is a special exit for airlifting narcos back to their home location
601 
602 
603     uint256 narcoWeedTotal;
604     uint256 narcoCokeTotal;
605     uint16[6] memory narcoSkills;
606     uint8[4] memory narcoConsumables;
607     uint256[6] memory narcoCooldowns;
608 
609     (
610                 ,
611       narcoWeedTotal,
612       narcoCokeTotal,
613       narcoSkills,
614       narcoConsumables,
615                 ,
616                 ,
617                 ,
618       narcoCooldowns,
619                 ,
620     ) = narcoCore.getNarco(_narcoId);
621 
622     // travel cooldown must have expired and narco must have some gas
623     require(now>narcoCooldowns[0] && (narcoConsumables[0]>0 || _exitId==7));
624 
625     uint8 sourceLocation = getNarcoLocation(_narcoId);
626     District storage sourceDistrict = districts[sourceLocation]; // find out source
627     require(_exitId==7 || sourceDistrict.exits[_exitId] != 0); // must be a valid exit
628 
629     // decrease the weed pot and cocaine pot for the destination district
630     uint256 localWeedTotal = districts[sourceLocation].weedAmountHere;
631     uint256 localCokeTotal = districts[sourceLocation].cokeAmountHere;
632 
633     if (narcoWeedTotal < localWeedTotal) {
634       districts[sourceLocation].weedAmountHere -= narcoWeedTotal;
635     } else {
636       districts[sourceLocation].weedAmountHere = 1; // always drop to 1
637     }
638 
639     if (narcoCokeTotal < localCokeTotal) {
640       districts[sourceLocation].cokeAmountHere -= narcoCokeTotal;
641     } else {
642       districts[sourceLocation].cokeAmountHere = 1; // always drop to 1
643     }
644 
645     // do the move
646     uint8 targetLocation = getNarcoHomeLocation(_narcoId);
647     if (_exitId<7){
648       targetLocation =  uint8(sourceDistrict.exits[_exitId]);
649     }
650 
651     narcoIndexToLocation[_narcoId] = targetLocation;
652 
653     // distribute the travel revenue
654     _distributeRevenue(msg.value, targetLocation , 50, 50);
655 
656     // increase the weed pot and cocaine pot for the destination district with the travel cost
657     districts[targetLocation].weedAmountHere += narcoWeedTotal;
658     districts[targetLocation].cokeAmountHere += narcoCokeTotal;
659 
660     // consume some gas (gas index = 0)
661     if (_exitId!=7){
662       narcoCore.updateConsumable(_narcoId, 0 , narcoConsumables[0]-1);
663     }
664     // set travel cooldown (speed skill = 0)
665     //narcoCore.setCooldown( _narcoId ,  0 , now + min(3 minutes,(455-(5*narcoSkills[0])* 1 seconds)));
666     narcoCore.setCooldown( _narcoId ,  0 , now + (455-(5*narcoSkills[0])* 1 seconds));
667 
668     // update travel stat
669     narcoCore.incrementStat(_narcoId, 7);
670     // Travel risk
671      uint64 bustChance=random(50+(5*narcoSkills[0])); // 0  = speed skill
672 
673      if (bustChance<=bustRange){
674       busted(_narcoId,targetLocation,narcoWeedTotal,narcoCokeTotal);
675      }
676 
677      NarcoArrived(targetLocation, _narcoId); // who just arrived here
678      NarcoLeft(sourceLocation, _narcoId); // who just left here
679 
680   }
681 
682   function busted(uint256 _narcoId, uint256 targetLocation, uint256 narcoWeedTotal, uint256 narcoCokeTotal) private  {
683        uint256 bustedWeed=narcoWeedTotal/2; // %50
684        uint256 bustedCoke=narcoCokeTotal/2; // %50
685        districts[targetLocation].weedAmountHere -= bustedWeed; // smeti fix
686        districts[targetLocation].cokeAmountHere -= bustedCoke; // smeti fix
687        districts[7].weedAmountHere += bustedWeed; // smeti fix
688        districts[7].cokeAmountHere += bustedCoke; // smeti fix
689        narcoCore.updateWeedTotal(_narcoId, false, uint16(bustedWeed)); // 50% weed
690        narcoCore.updateCokeTotal(_narcoId, false, uint16(bustedCoke)); // 50% coke
691        narcoCore.updateWeedTotal(0, true, uint16(bustedWeed)); // 50% weed confiscated into office lardass
692        narcoCore.updateCokeTotal(0, true, uint16(bustedCoke)); // 50% coke confiscated into office lardass
693        TravelBust(_narcoId, uint16(bustedWeed), uint16(bustedCoke));
694   }
695 
696 
697   function hijack(uint256 _hijackerId, uint256 _victimId)  public payable whenNotPaused{
698     require(narcoCore.ownerOf(_hijackerId) == msg.sender); // must be owner
699     require(msg.value >= hijackPrice);
700 
701     // has the victim escaped?
702     if (getNarcoLocation(_hijackerId)!=getNarcoLocation(_victimId)){
703         EscapedHijack(_hijackerId, _victimId , getNarcoLocation(_victimId));
704         narcoCore.incrementStat(_victimId, 6); // lucky escape
705     }else
706     {
707       // hijack calculation
708       uint256 hijackerWeedTotal;
709       uint256 hijackerCokeTotal;
710       uint16[6] memory hijackerSkills;
711       uint8[4] memory hijackerConsumables;
712       uint256[6] memory hijackerCooldowns;
713 
714       (
715                   ,
716         hijackerWeedTotal,
717         hijackerCokeTotal,
718         hijackerSkills,
719         hijackerConsumables,
720                   ,
721                   ,
722                   ,
723         hijackerCooldowns,
724                   ,
725       ) = narcoCore.getNarco(_hijackerId);
726 
727       // does hijacker have capacity to carry any loot?
728 
729       uint256 victimWeedTotal;
730       uint256 victimCokeTotal;
731       uint16[6] memory victimSkills;
732       uint256[6] memory victimCooldowns;
733       uint8 victimHomeLocation;
734       (
735                   ,
736         victimWeedTotal,
737         victimCokeTotal,
738         victimSkills,
739                   ,
740                   ,
741        victimHomeLocation,
742                   ,
743         victimCooldowns,
744                   ,
745       ) = narcoCore.getNarco(_victimId);
746 
747       // victim is not in home location , or is officer lardass
748       require(getNarcoLocation(_victimId)!=victimHomeLocation || _victimId==0);
749       require(hijackerConsumables[3] >0); // narco has ammo
750 
751       require(now>hijackerCooldowns[3]); // must be outside cooldown
752 
753       // consume the ammo
754       narcoCore.updateConsumable(_hijackerId, 3 , hijackerConsumables[3]-1);
755       // attempt the hijack
756 
757       // 3 = attackIndex
758       // 4 = defenseIndex
759 
760       if (random((hijackerSkills[3]+victimSkills[4]))+1 >victimSkills[4]) {
761         // successful hijacking
762 
763         doHijack(_hijackerId  , _victimId , victimWeedTotal , victimCokeTotal);
764 
765         // heist character
766         if (_victimId==0){
767              narcoCore.incrementStat(_hijackerId, 5); // raidSuccessful
768         }
769 
770       }else{
771         // successfully defended
772         narcoCore.incrementStat(_victimId, 4); // defendedSuccessfully
773         HijackDefended( _hijackerId,_victimId);
774       }
775 
776     } // end if escaped
777 
778     //narcoCore.setCooldown( _hijackerId ,  3 , now + min(3 minutes,(455-(5*hijackerSkills[3])* 1 seconds))); // cooldown
779      narcoCore.setCooldown( _hijackerId ,  3 , now + (455-(5*hijackerSkills[3])* 1 seconds)); // cooldown
780 
781       // distribute the hijack revenue
782       _distributeRevenue(hijackPrice, getNarcoLocation(_hijackerId) , 50, 50);
783 
784   } // end hijack function
785 
786   function doHijack(uint256 _hijackerId  , uint256 _victimId ,  uint256 victimWeedTotal , uint256 victimCokeTotal) private {
787 
788         uint256 hijackerCapacity =  narcoCore.getRemainingCapacity(_hijackerId);
789 
790         // fill pockets starting with coke
791         uint16 stolenCoke = uint16(min(hijackerCapacity , (victimCokeTotal/2))); // steal 50%
792         uint16 stolenWeed = uint16(min(hijackerCapacity - stolenCoke, (victimWeedTotal/2))); // steal 50%
793 
794         // 50% chance to start with weed
795         if (random(100)>50){
796            stolenWeed = uint16(min(hijackerCapacity , (victimWeedTotal/2))); // steal 50%
797            stolenCoke = uint16(min(hijackerCapacity - stolenWeed, (victimCokeTotal/2))); // steal 50
798         }
799 
800         // steal some loot this calculation tbd
801         // for now just take all coke / weed
802         if (stolenWeed>0){
803           narcoCore.updateWeedTotal(_hijackerId, true, stolenWeed);
804           narcoCore.updateWeedTotal(_victimId,false, stolenWeed);
805         }
806         if (stolenCoke>0){
807           narcoCore.updateCokeTotal(_hijackerId, true , stolenCoke);
808           narcoCore.updateCokeTotal(_victimId,false, stolenCoke);
809         }
810 
811         narcoCore.incrementStat(_hijackerId, 3); // hijackSuccessful
812         Hijacked(_hijackerId, _victimId , stolenWeed, stolenCoke);
813 
814 
815   }
816 
817 
818   // pseudo random - but does that matter?
819   uint64 _seed = 0;
820   function random(uint64 upper) private returns (uint64 randomNumber) {
821      _seed = uint64(keccak256(keccak256(block.blockhash(block.number-1), _seed), now));
822      return _seed % upper;
823    }
824 
825    function min(uint a, uint b) private pure returns (uint) {
826             return a < b ? a : b;
827    }
828    function max(uint a, uint b) private pure returns (uint) {
829             return a > b ? a : b;
830    }
831    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
832      assert(b <= a);
833      return a - b;
834    }
835   // never call this from a contract
836   /// @param _loc that we are interested in
837   function narcosByDistrict(uint8 _loc) public view returns(uint256[] narcosHere) {
838     uint256 tokenCount = numberOfNarcosByDistrict(_loc);
839     uint256 totalNarcos = narcoCore.totalSupply();
840     uint256[] memory result = new uint256[](tokenCount);
841     uint256 narcoId;
842     uint256 resultIndex = 0;
843     for (narcoId = 0; narcoId <= totalNarcos; narcoId++) {
844       if (getNarcoLocation(narcoId) == _loc) {
845         result[resultIndex] = narcoId;
846         resultIndex++;
847       }
848     }
849     return result;
850   }
851 
852   function numberOfNarcosByDistrict(uint8 _loc) public view returns(uint256 number) {
853     uint256 count = 0;
854     uint256 narcoId;
855     for (narcoId = 0; narcoId <= narcoCore.totalSupply(); narcoId++) {
856       if (getNarcoLocation(narcoId) == _loc) {
857         count++;
858       }
859     }
860     return count;
861   }
862 
863 }