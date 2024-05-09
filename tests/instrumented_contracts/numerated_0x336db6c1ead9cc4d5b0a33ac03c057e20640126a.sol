1 pragma solidity ^0.4.0;
2 
3 contract EtherTanksCore {
4     
5     struct TankHull {
6         uint32 armor; // Hull's armor value
7         uint32 speed; // Hull's speed value
8         uint8 league; // The battle league which allows to play with this hull type
9     }
10     
11     struct TankWeapon {
12         uint32 minDamage; // Weapon minimal damage value
13         uint32 maxDamage; // Weapon maximum damage value
14         uint32 attackSpeed; // Weapon's attack speed value
15         uint8 league; // The battle league which allows to play with this weapon type
16     }
17     
18     struct TankProduct {
19         string name; // Tank's name
20         uint32 hull; // Hull's ID
21         uint32 weapon; // Weapon's ID
22         // Unfortunately, it's impossible to define the variable inside the struct as constant.
23         // However, you can read this smart-contract and see that there are no changes at all related to the start prices.
24         uint256 startPrice;
25         uint256 currentPrice; // The current price. Changes every time someone buys this kind of tank
26         uint256 earning; // The amount of earning each owner of this tank gets when someone buys this type of tank
27         uint256 releaseTime; // The moment when it will be allowed to buy this type of tank
28         uint32 amountOfTanks; // The amount of tanks with this kind of product
29         
30     }
31         
32     struct TankEntity {
33         uint32 productID;
34         uint8[4] upgrades;
35         address owner; // The address of the owner of this tank
36         address earner; // The address of the earner of this tank who get paid
37         bool selling; // Is this tank on the auction now?
38         uint256 auctionEntity; // If it's on the auction,
39         uint256 earned; // Total funds earned with this tank
40         uint32 exp; // Tank's experience
41         uint32 lastCashoutIndex; // Last amount of tanks existing in the game with the same ProductID
42     }
43     
44 
45     struct AuctionEntity {
46         uint32 tankId;
47         uint256 startPrice;
48         uint256 finishPrice;
49         uint256 startTime;
50         uint256 duration;
51     }
52     
53     event EventCashOut (
54        address indexed player,
55        uint256 amount
56        ); //;-)
57     
58     event EventLogin (
59         address indexed player,
60         string hash
61         ); //;-)
62     
63     event EventUpgradeTank (
64         address indexed player,
65         uint32 tankID,
66         uint8 upgradeChoice
67         ); // ;-)
68     
69     event EventTransfer (
70         address indexed player,
71         address indexed receiver,
72         uint32 tankID
73         ); // ;-)
74         
75     event EventTransferAction (
76         address indexed player,
77         address indexed receiver,
78         uint32 tankID,
79         uint8 ActionType
80         ); // ;-)
81         
82     event EventAuction (
83         address indexed player,
84         uint32 tankID,
85         uint256 startPrice,
86         uint256 finishPrice,
87         uint256 duration,
88         uint256 currentTime
89         ); // ;-)
90     event EventCancelAuction (
91         uint32 tankID
92         ); // ;-)
93     
94     event EventBid (
95         uint32 tankID  
96         ); // ;-)
97     
98     event EventProduct (
99         uint32 productID,
100         string name,
101         uint32 hull,
102         uint32 weapon,
103         uint256 price,
104         uint256 earning,
105         uint256 releaseTime,
106         uint256 currentTime
107         ); // ;-)
108         
109     event EventBuyTank (
110         address indexed player,
111         uint32 productID,
112         uint32 tankID
113         ); // ;-)
114 
115     
116     address public UpgradeMaster; // Earns fees for upgrading tanks (0.05 Eth)
117     address public AuctionMaster; // Earns fees for producing auctions (3%)
118     address public TankSellMaster; // Earns fees for selling tanks (start price)
119     address public ExportMaster; // Exports tanks from the previous contract.
120     bool public canExport = true; // If false -- the exporting is not allowed for this contract forever, so it's safe.
121     // No modifiers were needed, because each access is checked no more than one time in the whole code,
122     // So calling "require(msg.sender == UpgradeMaster);" is enough.
123     
124     function ChangeUpgradeMaster (address _newMaster) public {
125         require(msg.sender == UpgradeMaster);
126         UpgradeMaster = _newMaster;
127     }
128     
129     function ChangeTankSellMaster (address _newMaster) public {
130         require(msg.sender == TankSellMaster);
131         TankSellMaster = _newMaster;
132     }
133     
134     function ChangeAuctionMaster (address _newMaster) public {
135         require(msg.sender == AuctionMaster);
136         AuctionMaster = _newMaster;
137     }
138     
139     function FinishedExporting () public {
140         require(msg.sender == ExportMaster);
141         canExport = false; // Now, the exporting process has been finished, so we do not need to export anything anymore. Done.
142     }
143     
144     function EtherTanksCore() public {
145         
146         UpgradeMaster = msg.sender;
147         AuctionMaster = msg.sender;
148         TankSellMaster = msg.sender;
149         ExportMaster = msg.sender;
150 
151         // Creating 11 hulls
152         newTankHull(100, 5, 1);
153         newTankHull(60, 6, 2);
154         newTankHull(140, 4, 1);
155         newTankHull(200, 3, 1);
156         newTankHull(240, 3, 1);
157         newTankHull(200, 6, 2);
158         newTankHull(360, 4, 2);
159         newTankHull(180, 9, 3);
160         newTankHull(240, 8, 3);
161         newTankHull(500, 4, 2);
162         newTankHull(440, 6, 3);
163         
164         // Creating 11 weapons
165         newTankWeapon(6, 14, 5, 1);
166         newTankWeapon(18, 26, 3, 2);
167         newTankWeapon(44, 66, 2, 1);
168         newTankWeapon(21, 49, 3, 1);
169         newTankWeapon(60, 90, 2, 2);
170         newTankWeapon(21, 49, 2, 2);
171         newTankWeapon(48, 72, 3, 2);
172         newTankWeapon(13, 29, 9, 3);
173         newTankWeapon(36, 84, 4, 3);
174         newTankWeapon(120, 180, 2, 3);
175         newTankWeapon(72, 108, 4, 3);
176         
177         // Creating first 11 tank types
178         newTankProduct("LT-1", 1, 1, 10000000000000000, 100000000000000, now);
179         newTankProduct("LT-2", 2, 2, 50000000000000000, 500000000000000, now);
180         newTankProduct("MT-1", 3, 3, 100000000000000000, 1000000000000000, now);
181         newTankProduct("HT-1", 4, 4, 500000000000000000, 5000000000000000, now);
182         newTankProduct("SPG-1", 5, 5, 500000000000000000, 5000000000000000, now);
183         newTankProduct("MT-2", 6, 6, 700000000000000000, 7000000000000000, now);
184         newTankProduct("HT-2", 7, 7, 1500000000000000000, 15000000000000000, now);
185         newTankProduct("LT-3", 8, 8, 300000000000000000, 3000000000000000, now);
186         newTankProduct("MT-3", 9, 9, 1500000000000000000, 15000000000000000, now);
187         newTankProduct("SPG-2", 10, 10, 2000000000000000000, 20000000000000000, now+(60*60*5));
188         newTankProduct("HT-3", 11, 11, 2500000000000000000, 25000000000000000, now+(60*60*5));
189     }
190     
191     function cashOut (uint256 _amount) public payable {
192         require (canExport == false); // Can be called only if the process of exporting has been completed
193 
194         require (_amount >= 0); //just in case
195         require (_amount == uint256(uint128(_amount))); // Just some magic stuff
196         require (this.balance >= _amount); // Checking if this contract has enought money to pay
197         require (balances[msg.sender] >= _amount); // Checking if player has enough funds on his balance
198         if (_amount == 0){
199             _amount = balances[msg.sender];
200             // If the requested amount is 0, it means that player wants to cashout the whole amount of balance
201         }
202         
203         balances[msg.sender] -= _amount; // Changing the amount of funds on the player's in-game balance
204         
205         if (!msg.sender.send(_amount)){ // Sending funds and if the transaction is failed
206             balances[msg.sender] += _amount; // Returning the amount of funds on the player's in-game balance
207         }
208         
209         EventCashOut (msg.sender, _amount);
210         return;
211     }
212     
213     function cashOutTank (uint32 _tankID) public payable {
214         require (canExport == false); // Can be called only if the process of exporting has been completed
215         
216         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
217         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
218         uint256 _amount = tankProducts[tanks[_tankID].productID].earning*(tankProducts[tanks[_tankID].productID].amountOfTanks-tanks[_tankID].lastCashoutIndex);
219         require (this.balance >= _amount); // Checking if this contract has enought money to pay
220         require (_amount > 0);
221         
222         uint32 lastIndex = tanks[_tankID].lastCashoutIndex;
223         
224         tanks[_tankID].lastCashoutIndex = tankProducts[tanks[_tankID].productID].amountOfTanks; // Changing the amount of funds on the tanks's in-game balance
225         
226         if (!tanks[_tankID].owner.send(_amount)){ // Sending funds and if the transaction is failed
227             tanks[_tankID].lastCashoutIndex = lastIndex; // Changing the amount of funds on the tanks's in-game balance
228         }
229         
230         EventCashOut (msg.sender, _amount);
231         return;
232     }
233     
234     function login (string _hash) public {
235         EventLogin (msg.sender, _hash);
236         return;
237     }
238     
239     //upgrade tank
240     // @_upgradeChoice: 0 is for armor, 1 is for damage, 2 is for speed, 3 is for attack speed
241     function upgradeTank (uint32 _tankID, uint8 _upgradeChoice) public payable {
242         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
243         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
244         require (_upgradeChoice >= 0 && _upgradeChoice < 4); // Has to be between 0 and 3
245         require (tanks[_tankID].upgrades[_upgradeChoice] < 5); // Only 5 upgrades are allowed for each type of tank's parametres
246         require (msg.value >= upgradePrice); // Checking if there is enough amount of money for the upgrade
247         tanks[_tankID].upgrades[_upgradeChoice]++; // Upgrading
248         balances[msg.sender] += msg.value-upgradePrice; // Returning the rest amount of money back to the tank owner
249         balances[UpgradeMaster] += upgradePrice; // Sending the amount of money spent on the upgrade to the contract creator
250         
251         EventUpgradeTank (msg.sender, _tankID, _upgradeChoice);
252         return;
253     }
254     
255     
256     // Transfer. Using for sending tanks to another players
257     function _transfer (uint32 _tankID, address _receiver) public {
258         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
259         require (tanks[_tankID].owner == msg.sender); //Checking if sender owns this tank
260         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
261         require (tanks[_tankID].selling == false); //Making sure that the tank is not on the auction now
262         tanks[_tankID].owner = _receiver; // Changing the tank's owner
263         tanks[_tankID].earner = _receiver; // Changing the tank's earner address
264 
265         EventTransfer (msg.sender, _receiver, _tankID);
266         return;
267     }
268     
269     // Transfer Action. Using for sending tanks to EtherTanks' contracts. For example, the battle-area contract.
270     function _transferAction (uint32 _tankID, address _receiver, uint8 _ActionType) public {
271         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
272         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
273         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
274         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction now
275         tanks[_tankID].owner = _receiver; // Changing the tank's owner
276         
277         // As you can see, we do not change the earner here.
278         // It means that technically speaking, the tank's owner is still getting his earnings.
279         // It's logically that this method (transferAction) will be used for sending tanks to the battle area contract or some other contracts which will be interacting with tanks
280         // Be careful with this method! Do not call it to transfer tanks to another player!
281         // The reason you should not do this is that the method called "transfer" changes the owner and earner, so it is possible to change the earner address to the current owner address any time.
282         // However, for our special contracts like battle area, you are able to read this contract and make sure that your tank will not be sent to anyone else, only back to you.
283         // So, please, do not use this method to send your tanks to other players. Use it just for interacting with EtherTanks' contracts, which will be listed on EtherTanks.com
284         
285         EventTransferAction (msg.sender, _receiver, _tankID, _ActionType);
286         return;
287     }
288     
289     //selling
290     function sellTank (uint32 _tankID, uint256 _startPrice, uint256 _finishPrice, uint256 _duration) public {
291         require (_tankID > 0 && _tankID < newIdTank);
292         require (tanks[_tankID].owner == msg.sender);
293         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction already
294         require (_startPrice >= _finishPrice);
295         require (_startPrice > 0 && _finishPrice >= 0);
296         require (_duration > 0);
297         require (_startPrice == uint256(uint128(_startPrice))); // Just some magic stuff
298         require (_finishPrice == uint256(uint128(_finishPrice))); // Just some magic stuff
299         
300         auctions[newIdAuctionEntity] = AuctionEntity(_tankID, _startPrice, _finishPrice, now, _duration);
301         tanks[_tankID].selling = true;
302         tanks[_tankID].auctionEntity = newIdAuctionEntity++;
303         
304         EventAuction (msg.sender, _tankID, _startPrice, _finishPrice, _duration, now);
305     }
306     
307     //bidding function, people use this to buy tanks
308     function bid (uint32 _tankID) public payable {
309         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
310         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
311         AuctionEntity memory currentAuction = auctions[tanks[_tankID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
312         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
313         // The line above calculates the current price using the formula StartPrice-(((StartPrice-FinishPrice)/Duration)*(CurrentTime-StartTime)
314         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
315             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
316         }
317         require (currentPrice >= 0); // Who knows :)
318         require (msg.value >= currentPrice); // Checking if the buyer sent the amount of money which is more or equal the current price
319         
320         // All is fine, changing balances and changing tank's owner
321         uint256 marketFee = (currentPrice/100)*3; // Calculating 3% of the current price as a fee
322         balances[tanks[_tankID].owner] += currentPrice-marketFee; // Giving [current price]-[fee] amount to seller
323         balances[AuctionMaster] += marketFee; // Sending the fee amount to the contract creator's balance
324         balances[msg.sender] += msg.value-currentPrice; //Return the rest amount to buyer
325         tanks[_tankID].owner = msg.sender; // Changing the owner of the tank
326         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
327         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
328         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
329         
330         EventBid (_tankID);
331     }
332     
333     //cancel auction
334     function cancelAuction (uint32 _tankID) public {
335         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
336         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
337         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
338         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
339         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
340         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
341         
342         EventCancelAuction (_tankID);
343     }
344     
345     
346     function newTankProduct (string _name, uint32 _hull, uint32 _weapon, uint256 _price, uint256 _earning, uint256 _releaseTime) private {
347         tankProducts[newIdTankProduct++] = TankProduct(_name, _hull, _weapon, _price, _price, _earning, _releaseTime, 0);
348         
349         EventProduct (newIdTankProduct-1, _name, _hull, _weapon, _price, _earning, _releaseTime, now);
350     }
351     
352     function newTankHull (uint32 _armor, uint32 _speed, uint8 _league) private {
353         tankHulls[newIdTankHull++] = TankHull(_armor, _speed, _league);
354     }
355     
356     function newTankWeapon (uint32 _minDamage, uint32 _maxDamage, uint32 _attackSpeed, uint8 _league) private {
357         tankWeapons[newIdTankWeapon++] = TankWeapon(_minDamage, _maxDamage, _attackSpeed, _league);
358     }
359     
360     function exportTank (address _owner, uint32 _tankproductID) public {
361         require (canExport == true); // Can be called only if the process of exporting is allowed
362         require (msg.sender == ExportMaster); // This is what was missed before. All balances were returned.
363         tankProducts[_tankproductID].currentPrice += tankProducts[_tankproductID].earning;
364         tanks[newIdTank++] = TankEntity (_tankproductID, [0, 0, 0, 0], _owner, _owner, false, 0, 0, 0, ++tankProducts[_tankproductID].amountOfTanks);
365         
366         if (tanksBeforeTheNewTankType() == 0 && newIdTankProduct <= 121){
367             newTankType();
368         }
369         
370         EventBuyTank (_owner, _tankproductID, newIdTank-1);
371     }
372     
373     function exportTankResetEarning (uint32 _tankID) public {
374         // Because, before the exporting, we already payed all earnings
375         require (canExport == true); // Can be called only if the process of exporting is allowed
376         require (msg.sender == ExportMaster); // This is what was missed before. All balances were returned.
377         
378         tanks[_tankID].lastCashoutIndex = tankProducts[tanks[_tankID].productID].amountOfTanks; // Reseting the tank's earnings
379     
380     }
381     
382     function buyTank (uint32 _tankproductID) public payable {
383         require (canExport == false); // Can be called only if the process of exporting has been completed
384         require (tankProducts[_tankproductID].currentPrice > 0 && msg.value > 0); //value is more than 0, price is more than 0
385         require (msg.value >= tankProducts[_tankproductID].currentPrice); //value is higher than price
386         require (tankProducts[_tankproductID].releaseTime <= now); //checking if this tank was released.
387         // Basically, the releaseTime was implemented just to give a chance to get the new tank for as many players as possible.
388         // It prevents the using of bots.
389         
390         if (msg.value > tankProducts[_tankproductID].currentPrice){
391             // If player payed more, put the rest amount of money on his balance
392             balances[msg.sender] += msg.value-tankProducts[_tankproductID].currentPrice;
393         }
394         
395         tankProducts[_tankproductID].currentPrice += tankProducts[_tankproductID].earning;
396         
397         /*for (uint32 index = 1; index < newIdTank; index++){
398             if (tanks[index].productID == _tankproductID){
399                 balances[tanks[index].earner] += tankProducts[_tankproductID].earning;
400                 tanks[index].earned += tankProducts[_tankproductID].earning;
401             }
402         }*/
403         // This is why we decided to create the new contract - to avoid loops. Our suggestion to you: NEVER EVER USE LOOPS IN SMART-CONTRACTS
404         
405         if (tanksBeforeTheNewTankType() == 0 && newIdTankProduct <= 121){
406             newTankType();
407         }
408         
409         tanks[newIdTank++] = TankEntity (_tankproductID, [0, 0, 0, 0], msg.sender, msg.sender, false, 0, 0, 0, ++tankProducts[_tankproductID].amountOfTanks);
410 
411         // After all owners of the same type of tank got their earnings, admins get the amount which remains and no one need it
412         // Basically, it is the start price of the tank.
413         balances[TankSellMaster] += tankProducts[_tankproductID].startPrice;
414         
415         EventBuyTank (msg.sender, _tankproductID, newIdTank-1);
416         return;
417     }
418     
419     // This is the tricky method which creates the new type tank.
420     function newTankType () private {
421         if (newIdTankProduct > 121){
422             return;
423         }
424         //creating new tank type!
425         if (createNewTankHull < newIdTankHull - 1 && createNewTankWeapon >= newIdTankWeapon - 1) {
426             createNewTankWeapon = 1;
427             createNewTankHull++;
428         } else {
429             createNewTankWeapon++;
430             if (createNewTankHull == createNewTankWeapon) {
431                 createNewTankWeapon++;
432             }
433         }
434         newTankProduct ("Tank", uint32(createNewTankHull), uint32(createNewTankWeapon), 200000000000000000, 3000000000000000, now+(60*60));
435         return;
436     }
437     
438     // Our storage, keys are listed first, then mappings.
439     // Of course, instead of some mappings we could use arrays, but why not
440     
441     uint32 public newIdTank = 1; // The next ID for the new tank
442     uint32 public newIdTankProduct = 1; // The next ID for the new tank type
443     uint32 public newIdTankHull = 1; // The next ID for the new hull
444     uint32 public newIdTankWeapon = 1; // The new ID for the new weapon
445     uint32 public createNewTankHull = 1; // For newTankType()
446     uint32 public createNewTankWeapon = 0; // For newTankType()
447     uint256 public newIdAuctionEntity = 1; // The next ID for the new auction entity
448 
449     mapping (uint32 => TankEntity) tanks; // The storage 
450     mapping (uint32 => TankProduct) tankProducts;
451     mapping (uint32 => TankHull) tankHulls;
452     mapping (address => uint32[]) tankOwners;
453     mapping (uint32 => TankWeapon) tankWeapons;
454     mapping (uint256 => AuctionEntity) auctions;
455     mapping (address => uint) balances;
456 
457     uint256 public constant upgradePrice = 50000000000000000; // The fee which the UgradeMaster earns for upgrading tanks
458 
459     function getTankName (uint32 _ID) public constant returns (string){
460         return tankProducts[_ID].name;
461     }
462     
463     function getTankProduct (uint32 _ID) public constant returns (uint32[6]){
464         return [tankHulls[tankProducts[_ID].hull].armor, tankHulls[tankProducts[_ID].hull].speed, tankWeapons[tankProducts[_ID].weapon].minDamage, tankWeapons[tankProducts[_ID].weapon].maxDamage, tankWeapons[tankProducts[_ID].weapon].attackSpeed, uint32(tankProducts[_ID].releaseTime)];
465     }
466     
467     function getTankDetails (uint32 _ID) public constant returns (uint32[6]){
468         return [tanks[_ID].productID, uint32(tanks[_ID].upgrades[0]), uint32(tanks[_ID].upgrades[1]), uint32(tanks[_ID].upgrades[2]), uint32(tanks[_ID].upgrades[3]), uint32(tanks[_ID].exp)];
469     }
470     
471     function getTankOwner(uint32 _ID) public constant returns (address){
472         return tanks[_ID].owner;
473     }
474     
475     function getTankSell(uint32 _ID) public constant returns (bool){
476         return tanks[_ID].selling;
477     }
478     
479     function getTankTotalEarned(uint32 _ID) public constant returns (uint256){
480         return tanks[_ID].earned;
481     }
482     
483     function getTankAuctionEntity (uint32 _ID) public constant returns (uint256){
484         return tanks[_ID].auctionEntity;
485     }
486     
487     function getCurrentPrice (uint32 _ID) public constant returns (uint256){
488         return tankProducts[_ID].currentPrice;
489     }
490     
491     function getProductEarning (uint32 _ID) public constant returns (uint256){
492         return tankProducts[_ID].earning;
493     }
494     
495     function getTankEarning (uint32 _ID) public constant returns (uint256){
496         return tankProducts[tanks[_ID].productID].earning*(tankProducts[tanks[_ID].productID].amountOfTanks-tanks[_ID].lastCashoutIndex);
497     }
498     
499     function getCurrentPriceAuction (uint32 _ID) public constant returns (uint256){
500         require (getTankSell(_ID));
501         AuctionEntity memory currentAuction = auctions[tanks[_ID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
502         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
503         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
504             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
505         }
506         return currentPrice;
507     }
508     
509     function getPlayerBalance(address _player) public constant returns (uint256){
510         return balances[_player];
511     }
512     
513     function getContractBalance() public constant returns (uint256){
514         return this.balance;
515     }
516     
517     function howManyTanks() public constant returns (uint32){
518         return newIdTankProduct;
519     }
520     
521     function tanksBeforeTheNewTankType() public constant returns (uint256){
522         return 1000+(((newIdTankProduct)+10)*((newIdTankProduct)+10)*(newIdTankProduct-11))-newIdTank;
523     }
524 }
525 
526 /*
527     The previous contract addresses: 
528     
529     Second address: 0xef8a560fa19f26982c27c78101545b8fe3018237
530     First address: 0xca5088449b96c225801ced8e9efdcae1e0c92a3d
531     
532     By the way, we are very thankful that you support us! 
533     
534     EtherTanks.com
535     EthereTanks.com
536 */