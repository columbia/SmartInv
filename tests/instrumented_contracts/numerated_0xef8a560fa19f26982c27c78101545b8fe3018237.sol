1 pragma solidity ^0.4.0;
2 
3 contract EtherTanks {
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
144     function EtherTanks() public {
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
183         newTankProduct("MT-2", 6, 6, 700000000000000000, 7000000000000000, now+(60*60*2));
184         newTankProduct("HT-2", 7, 7, 1500000000000000000, 15000000000000000, now+(60*60*5));
185         newTankProduct("LT-3", 8, 8, 300000000000000000, 3000000000000000, now+(60*60*8));
186         newTankProduct("MT-3", 9, 9, 1500000000000000000, 15000000000000000, now+(60*60*24));
187         newTankProduct("SPG-2", 10, 10, 2000000000000000000, 20000000000000000, now+(60*60*24*2));
188         newTankProduct("HT-3", 11, 11, 2500000000000000000, 25000000000000000, now+(60*60*24*3));
189     }
190     
191     function cashOut (uint256 _amount) public payable {
192         require (_amount >= 0); //just in case
193         require (_amount == uint256(uint128(_amount))); // Just some magic stuff
194         require (this.balance >= _amount); // Checking if this contract has enought money to pay
195         require (balances[msg.sender] >= _amount); // Checking if player has enough funds on his balance
196         if (_amount == 0){
197             _amount = balances[msg.sender];
198             // If the requested amount is 0, it means that player wants to cashout the whole amount of balance
199         }
200         if (msg.sender.send(_amount)){ // Sending funds and if the transaction is successful
201             balances[msg.sender] -= _amount; // Changing the amount of funds on the player's in-game balance
202         }
203         
204         EventCashOut (msg.sender, _amount);
205         return;
206     }
207     
208     function cashOutTank (uint32 _tankID) public payable {
209         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
210         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
211         uint256 _amount = tankProducts[tanks[_tankID].productID].earning*(tankProducts[tanks[_tankID].productID].amountOfTanks-tanks[_tankID].lastCashoutIndex);
212         require (this.balance >= _amount); // Checking if this contract has enought money to pay
213         require (_amount > 0);
214         
215         if (tanks[_tankID].owner.send(_amount)){ // Sending funds and if the transaction is successful
216             tanks[_tankID].lastCashoutIndex = tankProducts[tanks[_tankID].productID].amountOfTanks; // Changing the amount of funds on the player's in-game balance
217         }
218         
219         EventCashOut (msg.sender, _amount);
220         return;
221     }
222     
223     function login (string _hash) public {
224         EventLogin (msg.sender, _hash);
225         return;
226     }
227     
228     //upgrade tank
229     // @_upgradeChoice: 0 is for armor, 1 is for damage, 2 is for speed, 3 is for attack speed
230     function upgradeTank (uint32 _tankID, uint8 _upgradeChoice) public payable {
231         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
232         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
233         require (_upgradeChoice >= 0 && _upgradeChoice < 4); // Has to be between 0 and 3
234         require (tanks[_tankID].upgrades[_upgradeChoice] < 5); // Only 5 upgrades are allowed for each type of tank's parametres
235         require (msg.value >= upgradePrice); // Checking if there is enough amount of money for the upgrade
236         tanks[_tankID].upgrades[_upgradeChoice]++; // Upgrading
237         balances[msg.sender] += msg.value-upgradePrice; // Returning the rest amount of money back to the tank owner
238         balances[UpgradeMaster] += upgradePrice; // Sending the amount of money spent on the upgrade to the contract creator
239         
240         EventUpgradeTank (msg.sender, _tankID, _upgradeChoice);
241         return;
242     }
243     
244     
245     // Transfer. Using for sending tanks to another players
246     function _transfer (uint32 _tankID, address _receiver) public {
247         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
248         require (tanks[_tankID].owner == msg.sender); //Checking if sender owns this tank
249         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
250         require (tanks[_tankID].selling == false); //Making sure that the tank is not on the auction now
251         tanks[_tankID].owner = _receiver; // Changing the tank's owner
252         tanks[_tankID].earner = _receiver; // Changing the tank's earner address
253 
254         EventTransfer (msg.sender, _receiver, _tankID);
255         return;
256     }
257     
258     // Transfer Action. Using for sending tanks to EtherTanks' contracts. For example, the battle-area contract.
259     function _transferAction (uint32 _tankID, address _receiver, uint8 _ActionType) public {
260         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
261         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
262         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
263         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction now
264         tanks[_tankID].owner = _receiver; // Changing the tank's owner
265         
266         // As you can see, we do not change the earner here.
267         // It means that technically speaking, the tank's owner is still getting his earnings.
268         // It's logically that this method (transferAction) will be used for sending tanks to the battle area contract or some other contracts which will be interacting with tanks
269         // Be careful with this method! Do not call it to transfer tanks to another player!
270         // The reason you should not do this is that the method called "transfer" changes the owner and earner, so it is possible to change the earner address to the current owner address any time.
271         // However, for our special contracts like battle area, you are able to read this contract and make sure that your tank will not be sent to anyone else, only back to you.
272         // So, please, do not use this method to send your tanks to other players. Use it just for interacting with EtherTanks' contracts, which will be listed on EtherTanks.com
273         
274         EventTransferAction (msg.sender, _receiver, _tankID, _ActionType);
275         return;
276     }
277     
278     //selling
279     function sellTank (uint32 _tankID, uint256 _startPrice, uint256 _finishPrice, uint256 _duration) public {
280         require (_tankID > 0 && _tankID < newIdTank);
281         require (tanks[_tankID].owner == msg.sender);
282         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction already
283         require (_startPrice >= _finishPrice);
284         require (_startPrice > 0 && _finishPrice >= 0);
285         require (_duration > 0);
286         require (_startPrice == uint256(uint128(_startPrice))); // Just some magic stuff
287         require (_finishPrice == uint256(uint128(_finishPrice))); // Just some magic stuff
288         
289         auctions[newIdAuctionEntity] = AuctionEntity(_tankID, _startPrice, _finishPrice, now, _duration);
290         tanks[_tankID].selling = true;
291         tanks[_tankID].auctionEntity = newIdAuctionEntity++;
292         
293         EventAuction (msg.sender, _tankID, _startPrice, _finishPrice, _duration, now);
294     }
295     
296     //bidding function, people use this to buy tanks
297     function bid (uint32 _tankID) public payable {
298         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
299         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
300         AuctionEntity memory currentAuction = auctions[tanks[_tankID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
301         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
302         // The line above calculates the current price using the formula StartPrice-(((StartPrice-FinishPrice)/Duration)*(CurrentTime-StartTime)
303         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
304             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
305         }
306         require (currentPrice >= 0); // Who knows :)
307         require (msg.value >= currentPrice); // Checking if the buyer sent the amount of money which is more or equal the current price
308         
309         // All is fine, changing balances and changing tank's owner
310         uint256 marketFee = (currentPrice/100)*3; // Calculating 3% of the current price as a fee
311         balances[tanks[_tankID].owner] += currentPrice-marketFee; // Giving [current price]-[fee] amount to seller
312         balances[AuctionMaster] += marketFee; // Sending the fee amount to the contract creator's balance
313         balances[msg.sender] += msg.value-currentPrice; //Return the rest amount to buyer
314         tanks[_tankID].owner = msg.sender; // Changing the owner of the tank
315         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
316         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
317         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
318         
319         EventBid (_tankID);
320     }
321     
322     //cancel auction
323     function cancelAuction (uint32 _tankID) public {
324         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
325         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
326         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
327         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
328         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
329         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
330         
331         EventCancelAuction (_tankID);
332     }
333     
334     
335     function newTankProduct (string _name, uint32 _hull, uint32 _weapon, uint256 _price, uint256 _earning, uint256 _releaseTime) private {
336         tankProducts[newIdTankProduct++] = TankProduct(_name, _hull, _weapon, _price, _price, _earning, _releaseTime, 0);
337         
338         EventProduct (newIdTankProduct-1, _name, _hull, _weapon, _price, _earning, _releaseTime, now);
339     }
340     
341     function newTankHull (uint32 _armor, uint32 _speed, uint8 _league) private {
342         tankHulls[newIdTankHull++] = TankHull(_armor, _speed, _league);
343     }
344     
345     function newTankWeapon (uint32 _minDamage, uint32 _maxDamage, uint32 _attackSpeed, uint8 _league) private {
346         tankWeapons[newIdTankWeapon++] = TankWeapon(_minDamage, _maxDamage, _attackSpeed, _league);
347     }
348     
349     function exportTank (address _owner, uint32 _tankproductID) public {
350         require (canExport == true); // Can be called only if the process of exporting is allowed
351         tankProducts[_tankproductID].currentPrice += tankProducts[_tankproductID].earning;
352         tanks[newIdTank++] = TankEntity (_tankproductID, [0, 0, 0, 0], _owner, _owner, false, 0, 0, 0, ++tankProducts[_tankproductID].amountOfTanks);
353         EventBuyTank (msg.sender, _tankproductID, newIdTank-1);
354     }
355     
356     function buyTank (uint32 _tankproductID) public payable {
357         require (tankProducts[_tankproductID].currentPrice > 0 && msg.value > 0); //value is more than 0, price is more than 0
358         require (msg.value >= tankProducts[_tankproductID].currentPrice); //value is higher than price
359         require (tankProducts[_tankproductID].releaseTime <= now); //checking if this tank was released.
360         // Basically, the releaseTime was implemented just to give a chance to get the new tank for as many players as possible.
361         // It prevents the using of bots.
362         
363         if (msg.value > tankProducts[_tankproductID].currentPrice){
364             // If player payed more, put the rest amount of money on his balance
365             balances[msg.sender] += msg.value-tankProducts[_tankproductID].currentPrice;
366         }
367         
368         tankProducts[_tankproductID].currentPrice += tankProducts[_tankproductID].earning;
369         
370         /*for (uint32 index = 1; index < newIdTank; index++){
371             if (tanks[index].productID == _tankproductID){
372                 balances[tanks[index].earner] += tankProducts[_tankproductID].earning;
373                 tanks[index].earned += tankProducts[_tankproductID].earning;
374             }
375         }*/
376         // This is why we decided to create the new contract - to avoid loops. Our suggestion to you: NEVER EVER USE LOOPS IN SMART-CONTRACTS
377         
378         if (tanksBeforeTheNewTankType() == 0 && newIdTankProduct <= 121){
379             newTankType();
380         }
381         
382         tanks[newIdTank++] = TankEntity (_tankproductID, [0, 0, 0, 0], msg.sender, msg.sender, false, 0, 0, 0, ++tankProducts[_tankproductID].amountOfTanks);
383 
384         // After all owners of the same type of tank got their earnings, admins get the amount which remains and no one need it
385         // Basically, it is the start price of the tank.
386         balances[TankSellMaster] += tankProducts[_tankproductID].startPrice;
387         
388         EventBuyTank (msg.sender, _tankproductID, newIdTank-1);
389         return;
390     }
391     
392     // This is the tricky method which creates the new type tank.
393     function newTankType () public {
394         if (newIdTankProduct > 121){
395             return;
396         }
397         //creating new tank type!
398         if (createNewTankHull < newIdTankHull - 1 && createNewTankWeapon >= newIdTankWeapon - 1) {
399             createNewTankWeapon = 1;
400             createNewTankHull++;
401         } else {
402             createNewTankWeapon++;
403             if (createNewTankHull == createNewTankWeapon) {
404                 createNewTankWeapon++;
405             }
406         }
407         newTankProduct ("Tank", uint32(createNewTankHull), uint32(createNewTankWeapon), 200000000000000000, 3000000000000000, now+(60*60));
408         return;
409     }
410     
411     // Our storage, keys are listed first, then mappings.
412     // Of course, instead of some mappings we could use arrays, but why not
413     
414     uint32 public newIdTank = 1; // The next ID for the new tank
415     uint32 public newIdTankProduct = 1; // The next ID for the new tank type
416     uint32 public newIdTankHull = 1; // The next ID for the new hull
417     uint32 public newIdTankWeapon = 1; // The new ID for the new weapon
418     uint32 public createNewTankHull = 1; // For newTankType()
419     uint32 public createNewTankWeapon = 0; // For newTankType()
420     uint256 public newIdAuctionEntity = 1; // The next ID for the new auction entity
421 
422     mapping (uint32 => TankEntity) tanks; // The storage 
423     mapping (uint32 => TankProduct) tankProducts;
424     mapping (uint32 => TankHull) tankHulls;
425     mapping (address => uint32[]) tankOwners;
426     mapping (uint32 => TankWeapon) tankWeapons;
427     mapping (uint256 => AuctionEntity) auctions;
428     mapping (address => uint) balances;
429 
430     uint256 public constant upgradePrice = 50000000000000000; // The fee which the UgradeMaster earns for upgrading tanks
431 
432     function getTankName (uint32 _ID) public constant returns (string){
433         return tankProducts[_ID].name;
434     }
435     
436     function getTankProduct (uint32 _ID) public constant returns (uint32[6]){
437         return [tankHulls[tankProducts[_ID].hull].armor, tankHulls[tankProducts[_ID].hull].speed, tankWeapons[tankProducts[_ID].weapon].minDamage, tankWeapons[tankProducts[_ID].weapon].maxDamage, tankWeapons[tankProducts[_ID].weapon].attackSpeed, uint32(tankProducts[_ID].releaseTime)];
438     }
439     
440     function getTankDetails (uint32 _ID) public constant returns (uint32[6]){
441         return [tanks[_ID].productID, uint32(tanks[_ID].upgrades[0]), uint32(tanks[_ID].upgrades[1]), uint32(tanks[_ID].upgrades[2]), uint32(tanks[_ID].upgrades[3]), uint32(tanks[_ID].exp)];
442     }
443     
444     function getTankOwner(uint32 _ID) public constant returns (address){
445         return tanks[_ID].owner;
446     }
447     
448     function getTankSell(uint32 _ID) public constant returns (bool){
449         return tanks[_ID].selling;
450     }
451     
452     function getTankTotalEarned(uint32 _ID) public constant returns (uint256){
453         return tanks[_ID].earned;
454     }
455     
456     function getTankAuctionEntity (uint32 _ID) public constant returns (uint256){
457         return tanks[_ID].auctionEntity;
458     }
459     
460     function getCurrentPrice (uint32 _ID) public constant returns (uint256){
461         return tankProducts[_ID].currentPrice;
462     }
463     
464     function getProductEarning (uint32 _ID) public constant returns (uint256){
465         return tankProducts[_ID].earning;
466     }
467     
468     function getTankEarning (uint32 _ID) public constant returns (uint256){
469         return tankProducts[tanks[_ID].productID].earning*(tankProducts[tanks[_ID].productID].amountOfTanks-tanks[_ID].lastCashoutIndex);
470     }
471     
472     function getCurrentPriceAuction (uint32 _ID) public constant returns (uint256){
473         require (getTankSell(_ID));
474         AuctionEntity memory currentAuction = auctions[tanks[_ID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
475         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
476         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
477             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
478         }
479         return currentPrice;
480     }
481     
482     function getPlayerBalance(address _player) public constant returns (uint256){
483         return balances[_player];
484     }
485     
486     function getContractBalance() public constant returns (uint256){
487         return this.balance;
488     }
489     
490     function howManyTanks() public constant returns (uint32){
491         return newIdTankProduct;
492     }
493     
494     function tanksBeforeTheNewTankType() public constant returns (uint256){
495         return 1000+(((newIdTankProduct)+10)*((newIdTankProduct)+10)*(newIdTankProduct-11))-newIdTank;
496     }
497 }
498 
499 /*
500     The previous contract address: 0xca5088449b96c225801ced8e9efdcae1e0c92a3d
501     
502     EtherTanks.com
503     EthereTanks.com
504 */