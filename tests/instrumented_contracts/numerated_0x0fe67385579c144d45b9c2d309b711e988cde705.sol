1 pragma solidity ^ 0.4.19;
2 
3 // DopeRaider Districts Contract
4 // by gasmasters.io
5 // contact: team@doperaider.com
6 
7 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
8 contract ERC721 {
9   function implementsERC721() public pure returns(bool);
10   function totalSupply() public view returns(uint256 total);
11   function balanceOf(address _owner) public view returns(uint256 balance);
12   function ownerOf(uint256 _tokenId) public view returns(address owner);
13   function approve(address _to, uint256 _tokenId) public;
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 // File: contracts/NarcoCoreInterface.sol
27 
28 contract NarcosCoreInterface is ERC721 {
29   function getNarco(uint256 _id)
30   public
31   view
32   returns(
33     string  narcoName,
34     uint256 weedTotal,
35     uint256 cokeTotal,
36     uint16[6] skills,
37     uint8[4] consumables,
38     string genes,
39     uint8 homeLocation,
40     uint16 level,
41     uint256[6] cooldowns,
42     uint256 id,
43     uint16[9] stats
44   );
45 
46   function updateWeedTotal(uint256 _narcoId, bool _add, uint16 _total) public;
47   function updateCokeTotal(uint256 _narcoId, bool _add,  uint16 _total) public;
48   function updateConsumable(uint256 _narcoId, uint256 _index, uint8 _new) public;
49   function updateSkill(uint256 _narcoId, uint256 _index, uint16 _new) public;
50   function incrementStat(uint256 _narcoId, uint256 _index) public;
51   function setCooldown(uint256 _narcoId , uint256 _index , uint256 _new) public;
52   function getRemainingCapacity(uint256 _id) public view returns (uint8 capacity);
53 }
54 
55 
56 // File: contracts/Ownable.sol
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 // File: contracts/Pausable.sol
99 
100 /**
101  * @title Pausable
102  * @dev Base contract which allows children to implement an emergency stop mechanism.
103  */
104 contract Pausable is Ownable {
105   event Pause();
106   event Unpause();
107 
108   bool public paused = true;
109 
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is not paused.
113    */
114   modifier whenNotPaused() {
115     require(!paused);
116     _;
117   }
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is paused.
121    */
122   modifier whenPaused() {
123     require(paused);
124     _;
125   }
126 
127   /**
128    * @dev called by the owner to pause, triggers stopped state
129    */
130   function pause() onlyOwner whenNotPaused public {
131     paused = true;
132     Pause();
133   }
134 
135   /**
136    * @dev called by the owner to unpause, returns to normal state
137    */
138   function unpause() onlyOwner whenPaused public {
139     paused = false;
140     Unpause();
141   }
142 }
143 
144 
145 // File: contracts/Districts/DistrictsAdmin.sol
146 
147 contract DistrictsAdmin is Ownable, Pausable {
148   event ContractUpgrade(address newContract);
149 
150   address public newContractAddress;
151   address public coreAddress;
152 
153   NarcosCoreInterface public narcoCore;
154 
155   function setNarcosCoreAddress(address _address) public onlyOwner {
156     _setNarcosCoreAddress(_address);
157   }
158 
159   function _setNarcosCoreAddress(address _address) internal {
160     NarcosCoreInterface candidateContract = NarcosCoreInterface(_address);
161     require(candidateContract.implementsERC721());
162     coreAddress = _address;
163     narcoCore = candidateContract;
164   }
165 
166   /// @dev Used to mark the smart contract as upgraded, in case there is a serious
167   ///  breaking bug. This method does nothing but keep track of the new contract and
168   ///  emit a message indicating that the new address is set. It's up to clients of this
169   ///  contract to update to the new contract address in that case.
170   /// @param _v2Address new address
171   function setNewAddress(address _v2Address) public onlyOwner whenPaused {
172     newContractAddress = _v2Address;
173 
174     ContractUpgrade(_v2Address);
175   }
176 
177   modifier onlyDopeRaiderContract() {
178     require(msg.sender == coreAddress);
179     _;
180   }
181 
182 }
183 
184 
185 
186 // File: contracts/DistrictsCore.sol
187 
188 contract DistrictsCore is DistrictsAdmin {
189 
190   // DISTRICT EVENTS
191   event NarcoArrived(uint8 indexed location, uint256 indexed narcoId); // who just arrived here
192   event NarcoLeft(uint8 indexed location, uint256 indexed narcoId); // who just left here
193   event TravelBust(uint256 indexed narcoId, uint16 confiscatedWeed, uint16 confiscatedCoke);
194   event Hijacked(uint256 indexed hijacker, uint256 indexed victim , uint16 stolenWeed , uint16 stolenCoke);
195   event HijackDefended(uint256 indexed hijacker, uint256 indexed victim);
196   event EscapedHijack(uint256 indexed hijacker, uint256 indexed victim , uint8 escapeLocation);
197 
198   uint256 public airLiftPrice = 0.01 ether; // home dorothy price
199   uint256 public hijackPrice = 0.002 ether; // universal hijackPrice
200   uint256 public travelPrice = 0.001 ether; // universal travelPrice
201   uint256 public spreadPercent = 5; // universal spread between buy and sell
202   uint256 public devFeePercent = 2; // on various actions
203   uint256 public currentDevFees = 0;
204   uint256 public bustRange = 10;
205 
206   function setAirLiftPrice(uint256 _price) public onlyOwner{
207     airLiftPrice = _price;
208   }
209 
210   function setBustRange(uint256 _range) public onlyOwner{
211     bustRange = _range;
212   }
213 
214   function setHijackPrice(uint256 _price) public onlyOwner{
215     hijackPrice = _price;
216   }
217 
218   function setTravelPrice(uint256 _price) public onlyOwner{
219     travelPrice = _price;
220   }
221 
222   function setSpreadPercent(uint256 _spread) public onlyOwner{
223     spreadPercent = _spread;
224   }
225 
226   function setDevFeePercent(uint256 _fee) public onlyOwner{
227     devFeePercent = _fee;
228   }
229 
230   function isDopeRaiderDistrictsCore() public pure returns(bool){ return true; }
231 
232 
233   // Market Items
234 
235   struct MarketItem{
236     uint256 id;
237     string itemName;
238     uint8 skillAffected;
239     uint8 upgradeAmount;
240     uint8 levelRequired; // the level a narco must have before they
241   }
242 
243   // there is a fixed amount of items - they are not tokens bc iterations will be needed.
244   // 0,1 = weed , coke , 2 - 4 consumables , 5-23 items
245   MarketItem[24] public marketItems;
246 
247   function configureMarketItem(uint256 _id, uint8 _skillAffected, uint8  _upgradeAmount, uint8 _levelRequired, string _itemName) public onlyOwner{
248     marketItems[_id].skillAffected = _skillAffected;
249     marketItems[_id].upgradeAmount = _upgradeAmount;
250     marketItems[_id].levelRequired = _levelRequired;
251     marketItems[_id].itemName = _itemName;
252     marketItems[_id].id = _id;
253   }
254 
255 
256   struct District {
257     uint256[6] exits;
258     uint256 weedPot;
259     uint256 weedAmountHere;
260     uint256 cokePot;
261     uint256 cokeAmountHere;
262     uint256[24] marketPrices;
263     bool[24] isStocked;
264     bool hasMarket;
265     string name;
266   }
267 
268   District[8] public districts; // there is no '0' district - this will be used to indicate no exit
269 
270   // for keeping track of who is where
271   mapping(uint256 => uint8) narcoIndexToLocation;
272 
273   function DistrictsCore() public {
274   }
275 
276   function getDistrict(uint256 _id) public view returns(uint256[6] exits, bool hasMarket, uint256[24] prices, bool[24] isStocked, uint256 weedPot, uint256 cokePot, uint256 weedAmountHere, uint256 cokeAmountHere, string name){
277     District storage district = districts[_id];
278     exits = district.exits;
279     hasMarket = district.hasMarket;
280     prices = district.marketPrices;
281 
282     // minimum prices for w/c set in the districts configuration file
283     prices[0] = max(prices[0], (((district.weedPot / district.weedAmountHere)/100)*(100+spreadPercent)));// Smeti calc this is the buy price (contract sells)
284     prices[1] = max(prices[1], (((district.cokePot / district.cokeAmountHere)/100)*(100+spreadPercent)));  // Smeti calc this is the buy price (contract sells)
285     isStocked = district.isStocked;
286     weedPot = district.weedPot;
287     cokePot = district.cokePot;
288     weedAmountHere = district.weedAmountHere;
289     cokeAmountHere = district.cokeAmountHere;
290     name = district.name;
291   }
292 
293   function createNamedDistrict(uint256 _index, string _name, bool _hasMarket) public onlyOwner{
294     districts[_index].name = _name;
295     districts[_index].hasMarket = _hasMarket;
296     districts[_index].weedAmountHere = 1;
297     districts[_index].cokeAmountHere = 1;
298     districts[_index].weedPot = 0.001 ether;
299     districts[_index].cokePot = 0.001 ether;
300   }
301 
302   function configureDistrict(uint256 _index, uint256[6]_exits, uint256[24] _prices, bool[24] _isStocked) public onlyOwner{
303     districts[_index].exits = _exits; // clockwise starting at noon
304     districts[_index].marketPrices = _prices;
305     districts[_index].isStocked = _isStocked;
306   }
307 
308   // callable by other contracts to control economy
309   function increaseDistrictWeed(uint256 _district, uint256 _quantity) public onlyDopeRaiderContract{
310     districts[_district].weedAmountHere += _quantity;
311   }
312   function increaseDistrictCoke(uint256 _district, uint256 _quantity) public onlyDopeRaiderContract{
313     districts[_district].cokeAmountHere += _quantity;
314   }
315 
316   function getNarcoLocation(uint256 _narcoId) public view returns(uint8 location){
317     location = narcoIndexToLocation[_narcoId];
318     // could be they have not travelled, so just return their home location
319     if (location == 0) {
320       (
321             ,
322             ,
323             ,
324             ,
325             ,
326             ,
327         location
328         ,
329         ,
330         ,
331         ,
332         ) = narcoCore.getNarco(_narcoId);
333 
334     }
335 
336   }
337 
338   function getNarcoHomeLocation(uint256 _narcoId) public view returns(uint8 location){
339       (
340             ,
341             ,
342             ,
343             ,
344             ,
345             ,
346         location
347         ,
348         ,
349         ,
350         ,
351         ) = narcoCore.getNarco(_narcoId);
352   }
353 
354   // function to be called when wanting to add funds to all districts
355   function floatEconony() public payable onlyOwner {
356         if(msg.value>0){
357           for (uint district=1;district<8;district++){
358               districts[district].weedPot+=(msg.value/14);
359               districts[district].cokePot+=(msg.value/14);
360             }
361         }
362     }
363 
364   // function to be called when wanting to add funds to a district
365   function distributeRevenue(uint256 _district , uint8 _splitW, uint8 _splitC) public payable onlyDopeRaiderContract {
366         if(msg.value>0){
367          _distributeRevenue(msg.value, _district, _splitW, _splitC);
368         }
369   }
370 
371   uint256 public localRevenuePercent = 80;
372 
373   function setLocalRevenuPercent(uint256 _lrp) public onlyOwner{
374     localRevenuePercent = _lrp;
375   }
376 
377   function _distributeRevenue(uint256 _grossRevenue, uint256 _district , uint8 _splitW, uint8 _splitC) internal {
378           // subtract dev fees
379           uint256 onePc = _grossRevenue/100;
380           uint256 netRevenue = onePc*(100-devFeePercent);
381           uint256 devFee = onePc*(devFeePercent);
382 
383           uint256 districtRevenue = (netRevenue/100)*localRevenuePercent;
384           uint256 federalRevenue = (netRevenue/100)*(100-localRevenuePercent);
385 
386           // distribute district revenue
387           // split evenly between weed and coke pots
388           districts[_district].weedPot+=(districtRevenue/100)*_splitW;
389           districts[_district].cokePot+=(districtRevenue/100)*_splitC;
390 
391           // distribute federal revenue
392            for (uint district=1;district<8;district++){
393               districts[district].weedPot+=(federalRevenue/14);
394               districts[district].cokePot+=(federalRevenue/14);
395             }
396 
397           // acrue dev fee
398           currentDevFees+=devFee;
399   }
400 
401   function withdrawFees() external onlyOwner {
402         if (currentDevFees<=address(this).balance){
403           currentDevFees = 0;
404           msg.sender.transfer(currentDevFees);
405         }
406     }
407 
408 
409   function buyItem(uint256 _narcoId, uint256 _district, uint256 _itemIndex, uint256 _quantity) public payable whenNotPaused{
410     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
411 
412     uint256 narcoWeedTotal;
413     uint256 narcoCokeTotal;
414     uint16[6] memory narcoSkills;
415     uint8[4] memory narcoConsumables;
416     uint16 narcoLevel;
417 
418     (
419                 ,
420       narcoWeedTotal,
421       narcoCokeTotal,
422       narcoSkills,
423       narcoConsumables,
424                 ,
425                 ,
426       narcoLevel,
427                 ,
428                 ,
429     ) = narcoCore.getNarco(_narcoId);
430 
431     require(getNarcoLocation(_narcoId) == uint8(_district)); // right place to buy
432     require(uint8(_quantity) > 0 && districts[_district].isStocked[_itemIndex] == true); // there is enough of it
433     require(marketItems[_itemIndex].levelRequired <= narcoLevel || _district==7); //  must be level to buy this item or black market
434     require(narcoCore.getRemainingCapacity(_narcoId) >= _quantity || _itemIndex>=6); // narco can carry it or not a consumable
435 
436     // progression through the upgrades for non consumable items (>=6)
437     if (_itemIndex>=6) {
438       if (marketItems[_itemIndex].skillAffected!=5){
439             // regular items
440             require (marketItems[_itemIndex].levelRequired==0 || narcoSkills[marketItems[_itemIndex].skillAffected]<marketItems[_itemIndex].upgradeAmount);
441           }else{
442             // capacity has 20 + requirement
443             require (narcoSkills[5]<20+marketItems[_itemIndex].upgradeAmount);
444       }
445     }
446 
447     uint256 costPrice = districts[_district].marketPrices[_itemIndex] * _quantity;
448 
449     if (_itemIndex ==0 ) {
450       costPrice = max(districts[_district].marketPrices[0], (((districts[_district].weedPot / districts[_district].weedAmountHere)/100)*(100+spreadPercent))) * _quantity;
451     }
452     if (_itemIndex ==1 ) {
453       costPrice = max(districts[_district].marketPrices[1], (((districts[_district].cokePot / districts[_district].cokeAmountHere)/100)*(100+spreadPercent))) * _quantity;
454     }
455 
456     require(msg.value >= costPrice); // paid enough?
457     // ok purchase here
458     if (_itemIndex > 1 && _itemIndex < 6) {
459       // consumable
460       narcoCore.updateConsumable(_narcoId, _itemIndex - 2, uint8(narcoConsumables[_itemIndex - 2] + _quantity));
461        _distributeRevenue(costPrice, _district , 50, 50);
462     }
463 
464     if (_itemIndex >= 6) {
465         // skills boost
466         // check which skill is updated by this item
467         narcoCore.updateSkill(
468           _narcoId,
469           marketItems[_itemIndex].skillAffected,
470           uint16(narcoSkills[marketItems[_itemIndex].skillAffected] + (marketItems[_itemIndex].upgradeAmount * _quantity))
471         );
472         _distributeRevenue(costPrice, _district , 50, 50);
473     }
474     if (_itemIndex == 0) {
475         // weedTotal
476         narcoCore.updateWeedTotal(_narcoId, true,  uint16(_quantity));
477         districts[_district].weedAmountHere += uint8(_quantity);
478         _distributeRevenue(costPrice, _district , 100, 0);
479     }
480     if (_itemIndex == 1) {
481        // cokeTotal
482        narcoCore.updateCokeTotal(_narcoId, true, uint16(_quantity));
483        districts[_district].cokeAmountHere += uint8(_quantity);
484        _distributeRevenue(costPrice, _district , 0, 100);
485     }
486 
487     // allow overbid
488     if (msg.value>costPrice){
489         msg.sender.transfer(msg.value-costPrice);
490     }
491 
492   }
493 
494 
495   function sellItem(uint256 _narcoId, uint256 _district, uint256 _itemIndex, uint256 _quantity) public whenNotPaused{
496     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
497     require(_itemIndex < marketItems.length && _district < 8 && _district > 0 && _quantity > 0); // valid item and district and quantity
498 
499     uint256 narcoWeedTotal;
500     uint256 narcoCokeTotal;
501 
502     (
503                 ,
504       narcoWeedTotal,
505       narcoCokeTotal,
506                 ,
507                 ,
508                 ,
509                 ,
510                 ,
511                 ,
512                 ,
513             ) = narcoCore.getNarco(_narcoId);
514 
515 
516     require(getNarcoLocation(_narcoId) == _district); // right place to buy
517     // at this time only weed and coke can be sold to the contract
518     require((_itemIndex == 0 && narcoWeedTotal >= _quantity) || (_itemIndex == 1 && narcoCokeTotal >= _quantity));
519 
520     uint256 salePrice = 0;
521 
522     if (_itemIndex == 0) {
523       salePrice = districts[_district].weedPot / districts[_district].weedAmountHere;  // Smeti calc this is the sell price (contract buys)
524     }
525     if (_itemIndex == 1) {
526       salePrice = districts[_district].cokePot / districts[_district].cokeAmountHere;  // Smeti calc this is the sell price (contract buys)
527     }
528     require(salePrice > 0); // yeah that old chestnut lol
529 
530     // do the updates
531     if (_itemIndex == 0) {
532       narcoCore.updateWeedTotal(_narcoId, false, uint16(_quantity));
533       districts[_district].weedPot-=salePrice*_quantity;
534       districts[_district].weedAmountHere -= _quantity;
535     }
536     if (_itemIndex == 1) {
537       narcoCore.updateCokeTotal(_narcoId, false, uint16(_quantity));
538       districts[_district].cokePot-=salePrice*_quantity;
539       districts[_district].cokeAmountHere -= _quantity;
540     }
541     narcoCore.incrementStat(_narcoId, 0); // dealsCompleted
542     // transfer the amount to the seller - should be owner of, but for now...
543     msg.sender.transfer(salePrice*_quantity);
544 
545   }
546 
547 
548 
549   // allow a Narco to travel between districts
550   // travelling is done by taking "exit" --> index into the loctions
551   function travelTo(uint256 _narcoId, uint256 _exitId) public payable whenNotPaused{
552     require(narcoCore.ownerOf(_narcoId) == msg.sender); // must be owner
553     require((msg.value >= travelPrice && _exitId < 7) || (msg.value >= airLiftPrice && _exitId==7));
554 
555     // exitId ==7 is a special exit for airlifting narcos back to their home location
556 
557 
558     uint256 narcoWeedTotal;
559     uint256 narcoCokeTotal;
560     uint16[6] memory narcoSkills;
561     uint8[4] memory narcoConsumables;
562     uint256[6] memory narcoCooldowns;
563 
564     (
565                 ,
566       narcoWeedTotal,
567       narcoCokeTotal,
568       narcoSkills,
569       narcoConsumables,
570                 ,
571                 ,
572                 ,
573       narcoCooldowns,
574                 ,
575     ) = narcoCore.getNarco(_narcoId);
576 
577     // travel cooldown must have expired and narco must have some gas
578     require(now>narcoCooldowns[0] && narcoConsumables[0]>0);
579 
580     uint8 sourceLocation = getNarcoLocation(_narcoId);
581     District storage sourceDistrict = districts[sourceLocation]; // find out source
582     require(_exitId==7 || sourceDistrict.exits[_exitId] != 0); // must be a valid exit
583 
584     // decrease the weed pot and cocaine pot for the destination district
585     uint256 localWeedTotal = districts[sourceLocation].weedAmountHere;
586     uint256 localCokeTotal = districts[sourceLocation].cokeAmountHere;
587 
588     if (narcoWeedTotal < localWeedTotal) {
589       districts[sourceLocation].weedAmountHere -= narcoWeedTotal;
590     } else {
591       districts[sourceLocation].weedAmountHere = 1; // always drop to 1
592     }
593 
594     if (narcoCokeTotal < localCokeTotal) {
595       districts[sourceLocation].cokeAmountHere -= narcoCokeTotal;
596     } else {
597       districts[sourceLocation].cokeAmountHere = 1; // always drop to 1
598     }
599 
600     // do the move
601     uint8 targetLocation = getNarcoHomeLocation(_narcoId);
602     if (_exitId<7){
603       targetLocation =  uint8(sourceDistrict.exits[_exitId]);
604     }
605 
606     narcoIndexToLocation[_narcoId] = targetLocation;
607 
608     // distribute the travel revenue
609     _distributeRevenue(travelPrice, targetLocation , 50, 50);
610 
611     // increase the weed pot and cocaine pot for the destination district with the travel cost
612     districts[targetLocation].weedAmountHere += narcoWeedTotal;
613     districts[targetLocation].cokeAmountHere += narcoCokeTotal;
614 
615     // consume some gas (gas index = 0)
616     narcoCore.updateConsumable(_narcoId, 0 , narcoConsumables[0]-1);
617     // set travel cooldown (speed skill = 0)
618     //narcoCore.setCooldown( _narcoId ,  0 , now + min(3 minutes,(455-(5*narcoSkills[0])* 1 seconds)));
619     narcoCore.setCooldown( _narcoId ,  0 , now + (455-(5*narcoSkills[0])* 1 seconds));
620 
621     // update travel stat
622     narcoCore.incrementStat(_narcoId, 7);
623     // Travel risk
624      uint64 bustChance=random(50+(5*narcoSkills[0])); // 0  = speed skill
625 
626      if (bustChance<=bustRange){
627       busted(_narcoId,targetLocation,narcoWeedTotal,narcoCokeTotal);
628      }
629 
630      NarcoArrived(targetLocation, _narcoId); // who just arrived here
631      NarcoLeft(sourceLocation, _narcoId); // who just left here
632 
633   }
634 
635   function busted(uint256 _narcoId, uint256 targetLocation, uint256 narcoWeedTotal, uint256 narcoCokeTotal) private  {
636        uint256 bustedWeed=narcoWeedTotal/2; // %50
637        uint256 bustedCoke=narcoCokeTotal/2; // %50
638        districts[targetLocation].weedAmountHere -= bustedWeed; // smeti fix
639        districts[targetLocation].cokeAmountHere -= bustedCoke; // smeti fix
640        districts[7].weedAmountHere += bustedWeed; // smeti fix
641        districts[7].cokeAmountHere += bustedCoke; // smeti fix
642        narcoCore.updateWeedTotal(_narcoId, false, uint16(bustedWeed)); // 50% weed
643        narcoCore.updateCokeTotal(_narcoId, false, uint16(bustedCoke)); // 50% coke
644        narcoCore.updateWeedTotal(0, true, uint16(bustedWeed)); // 50% weed confiscated into office lardass
645        narcoCore.updateCokeTotal(0, true, uint16(bustedCoke)); // 50% coke confiscated into office lardass
646        TravelBust(_narcoId, uint16(bustedWeed), uint16(bustedCoke));
647   }
648 
649 
650   function hijack(uint256 _hijackerId, uint256 _victimId)  public payable whenNotPaused{
651     require(narcoCore.ownerOf(_hijackerId) == msg.sender); // must be owner
652     require(msg.value >= hijackPrice);
653 
654     // has the victim escaped?
655     if (getNarcoLocation(_hijackerId)!=getNarcoLocation(_victimId)){
656         EscapedHijack(_hijackerId, _victimId , getNarcoLocation(_victimId));
657         narcoCore.incrementStat(_victimId, 6); // lucky escape
658     }else
659     {
660       // hijack calculation
661       uint256 hijackerWeedTotal;
662       uint256 hijackerCokeTotal;
663       uint16[6] memory hijackerSkills;
664       uint8[4] memory hijackerConsumables;
665       uint256[6] memory hijackerCooldowns;
666 
667       (
668                   ,
669         hijackerWeedTotal,
670         hijackerCokeTotal,
671         hijackerSkills,
672         hijackerConsumables,
673                   ,
674                   ,
675                   ,
676         hijackerCooldowns,
677                   ,
678       ) = narcoCore.getNarco(_hijackerId);
679 
680       // does hijacker have capacity to carry any loot?
681 
682       uint256 victimWeedTotal;
683       uint256 victimCokeTotal;
684       uint16[6] memory victimSkills;
685       uint256[6] memory victimCooldowns;
686       uint8 victimHomeLocation;
687       (
688                   ,
689         victimWeedTotal,
690         victimCokeTotal,
691         victimSkills,
692                   ,
693                   ,
694        victimHomeLocation,
695                   ,
696         victimCooldowns,
697                   ,
698       ) = narcoCore.getNarco(_victimId);
699 
700       // victim is not in home location , or is officer lardass
701       require(getNarcoLocation(_victimId)!=victimHomeLocation || _victimId==0);
702       require(hijackerConsumables[3] >0); // narco has ammo
703 
704       require(now>hijackerCooldowns[3]); // must be outside cooldown
705 
706       // consume the ammo
707       narcoCore.updateConsumable(_hijackerId, 3 , hijackerConsumables[3]-1);
708       // attempt the hijack
709 
710       // 3 = attackIndex
711       // 4 = defenseIndex
712 
713       if (uint8(random((hijackerSkills[3]+victimSkills[4]))+1) >victimSkills[4]) {
714         // successful hijacking
715 
716         doHijack(_hijackerId  , _victimId , victimWeedTotal , victimCokeTotal);
717 
718         // heist character
719         if (_victimId==0){
720              narcoCore.incrementStat(_hijackerId, 5); // raidSuccessful
721         }
722 
723       }else{
724         // successfully defended
725         narcoCore.incrementStat(_victimId, 4); // defendedSuccessfully
726         HijackDefended( _hijackerId,_victimId);
727       }
728 
729     } // end if escaped
730 
731     //narcoCore.setCooldown( _hijackerId ,  3 , now + min(3 minutes,(455-(5*hijackerSkills[3])* 1 seconds))); // cooldown
732      narcoCore.setCooldown( _hijackerId ,  3 , now + (455-(5*hijackerSkills[3])* 1 seconds)); // cooldown
733 
734       // distribute the hijack revenue
735       _distributeRevenue(hijackPrice, getNarcoLocation(_hijackerId) , 50, 50);
736 
737   } // end hijack function
738 
739   function doHijack(uint256 _hijackerId  , uint256 _victimId ,  uint256 victimWeedTotal , uint256 victimCokeTotal) private {
740 
741         uint256 hijackerCapacity =  narcoCore.getRemainingCapacity(_hijackerId);
742 
743         // fill pockets starting with coke
744         uint16 stolenCoke = uint16(min(hijackerCapacity , (victimCokeTotal/2))); // steal 50%
745         uint16 stolenWeed = uint16(min(hijackerCapacity - stolenCoke, (victimWeedTotal/2))); // steal 50%
746 
747         // 50% chance to start with weed
748         if (random(100)>50){
749            stolenWeed = uint16(min(hijackerCapacity , (victimWeedTotal/2))); // steal 50%
750            stolenCoke = uint16(min(hijackerCapacity - stolenWeed, (victimCokeTotal/2))); // steal 50
751         }
752 
753         // steal some loot this calculation tbd
754         // for now just take all coke / weed
755         if (stolenWeed>0){
756           narcoCore.updateWeedTotal(_hijackerId, true, stolenWeed);
757           narcoCore.updateWeedTotal(_victimId,false, stolenWeed);
758         }
759         if (stolenCoke>0){
760           narcoCore.updateCokeTotal(_hijackerId, true , stolenCoke);
761           narcoCore.updateCokeTotal(_victimId,false, stolenCoke);
762         }
763 
764         narcoCore.incrementStat(_hijackerId, 3); // hijackSuccessful
765         Hijacked(_hijackerId, _victimId , stolenWeed, stolenCoke);
766 
767 
768   }
769 
770 
771   // pseudo random - but does that matter?
772   uint64 _seed = 0;
773   function random(uint64 upper) private returns (uint64 randomNumber) {
774      _seed = uint64(keccak256(keccak256(block.blockhash(block.number-1), _seed), now));
775      return _seed % upper;
776    }
777 
778    function min(uint a, uint b) private pure returns (uint) {
779             return a < b ? a : b;
780    }
781    function max(uint a, uint b) private pure returns (uint) {
782             return a > b ? a : b;
783    }
784 
785   // never call this from a contract
786   /// @param _loc that we are interested in
787   function narcosByDistrict(uint8 _loc) public view returns(uint256[] narcosHere) {
788     uint256 tokenCount = numberOfNarcosByDistrict(_loc);
789     uint256 totalNarcos = narcoCore.totalSupply();
790     uint256[] memory result = new uint256[](tokenCount);
791     uint256 narcoId;
792     uint256 resultIndex = 0;
793     for (narcoId = 0; narcoId <= totalNarcos; narcoId++) {
794       if (getNarcoLocation(narcoId) == _loc) {
795         result[resultIndex] = narcoId;
796         resultIndex++;
797       }
798     }
799     return result;
800   }
801 
802   function numberOfNarcosByDistrict(uint8 _loc) public view returns(uint256 number) {
803     uint256 count = 0;
804     uint256 narcoId;
805     for (narcoId = 0; narcoId <= narcoCore.totalSupply(); narcoId++) {
806       if (getNarcoLocation(narcoId) == _loc) {
807         count++;
808       }
809     }
810     return count;
811   }
812 
813 }