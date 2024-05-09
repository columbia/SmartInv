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
22         // Unfortunately, it's imposible to define the variable inside the struct as constant.
23         // However, you can read this smart-contract and see that there are no changes at all related to the start prices.
24         uint256 startPrice;
25         uint256 currentPrice; // The current price. Changes every time someone buys this kind of tank
26         uint256 earning; // The amount of earning each owner of this tank gets when someone buys this type of tank
27         uint256 releaseTime; // The moment when it will be allowed to buy this type of tank
28     }
29         
30     struct TankEntity {
31         uint32 productID;
32         uint8[4] upgrades;
33         address owner; // The address of the owner of this tank
34         address earner; // The address of the earner of this tank who get paid
35         bool selling; // Is this tank on the auction now?
36         uint256 auctionEntity; // If it's on the auction,
37         uint256 earned; // Total funds earned with this tank
38         uint32 exp; // Tank's experience
39     }
40     
41 
42     struct AuctionEntity {
43         uint32 tankId;
44         uint256 startPrice;
45         uint256 finishPrice;
46         uint256 startTime;
47         uint256 duration;
48     }
49     
50     event EventCashOut (
51        address indexed player,
52        uint256 amount
53        ); //;-)
54     
55     event EventLogin (
56         address indexed player,
57         string hash
58         ); //;-)
59     
60     event EventUpgradeTank (
61         address indexed player,
62         uint32 tankID,
63         uint8 upgradeChoice
64         ); // ;-)
65     
66     event EventTransfer (
67         address indexed player,
68         address indexed receiver,
69         uint32 tankID
70         ); // ;-)
71         
72     event EventTransferAction (
73         address indexed player,
74         address indexed receiver,
75         uint32 tankID,
76         uint8 ActionType
77         ); // ;-)
78         
79     event EventAuction (
80         address indexed player,
81         uint32 tankID,
82         uint256 startPrice,
83         uint256 finishPrice,
84         uint256 duration,
85         uint256 currentTime
86         ); // ;-)
87     event EventCancelAuction (
88         uint32 tankID
89         ); // ;-)
90     
91     event EventBid (
92         uint32 tankID  
93         ); // ;-)
94     
95     event EventProduct (
96         uint32 productID,
97         string name,
98         uint32 hull,
99         uint32 weapon,
100         uint256 price,
101         uint256 earning,
102         uint256 releaseTime,
103         uint256 currentTime
104         ); // ;-)
105         
106     event EventBuyTank (
107         address indexed player,
108         uint32 productID,
109         uint32 tankID
110         ); // ;-)
111 
112     
113     address public UpgradeMaster; // Earns fees for upgrading tanks (0.05 Eth)
114     address public AuctionMaster; // Earns fees for producing auctions (3%)
115     address public TankSellMaster; // Earns fees for selling tanks (start price)
116     // No modifiers were needed, because each access is checked no more than one time in the whole code,
117     // So calling "require(msg.sender == UpgradeMaster);" is enough.
118     
119     function ChangeUpgradeMaster (address _newMaster) public {
120         require(msg.sender == UpgradeMaster);
121         UpgradeMaster = _newMaster;
122     }
123     
124     function ChangeTankSellMaster (address _newMaster) public {
125         require(msg.sender == TankSellMaster);
126         TankSellMaster = _newMaster;
127     }
128     
129     function ChangeAuctionMaster (address _newMaster) public {
130         require(msg.sender == AuctionMaster);
131         AuctionMaster = _newMaster;
132     }
133     
134     function EtherTanks() public {
135         
136         UpgradeMaster = msg.sender;
137         AuctionMaster = msg.sender;
138         TankSellMaster = msg.sender;
139 
140         // Creating 11 hulls
141         newTankHull(100, 5, 1);
142         newTankHull(60, 6, 2);
143         newTankHull(140, 4, 1);
144         newTankHull(200, 3, 1);
145         newTankHull(240, 3, 1);
146         newTankHull(200, 6, 2);
147         newTankHull(360, 4, 2);
148         newTankHull(180, 9, 3);
149         newTankHull(240, 8, 3);
150         newTankHull(500, 4, 2);
151         newTankHull(440, 6, 3);
152         
153         // Creating 11 weapons
154         newTankWeapon(6, 14, 5, 1);
155         newTankWeapon(18, 26, 3, 2);
156         newTankWeapon(44, 66, 2, 1);
157         newTankWeapon(21, 49, 3, 1);
158         newTankWeapon(60, 90, 2, 2);
159         newTankWeapon(21, 49, 2, 2);
160         newTankWeapon(48, 72, 3, 2);
161         newTankWeapon(13, 29, 9, 3);
162         newTankWeapon(36, 84, 4, 3);
163         newTankWeapon(120, 180, 2, 3);
164         newTankWeapon(72, 108, 4, 3);
165         
166         // Creating first 11 tank types
167         newTankProduct("LT-1", 1, 1, 10000000000000000, 100000000000000, now);
168         newTankProduct("LT-2", 2, 2, 50000000000000000, 500000000000000, now);
169         newTankProduct("MT-1", 3, 3, 100000000000000000, 1000000000000000, now);
170         newTankProduct("HT-1", 4, 4, 500000000000000000, 5000000000000000, now);
171         newTankProduct("SPG-1", 5, 5, 500000000000000000, 5000000000000000, now);
172         newTankProduct("MT-2", 6, 6, 700000000000000000, 7000000000000000, now+(60*60*2));
173         newTankProduct("HT-2", 7, 7, 1500000000000000000, 15000000000000000, now+(60*60*5));
174         newTankProduct("LT-3", 8, 8, 300000000000000000, 3000000000000000, now+(60*60*8));
175         newTankProduct("MT-3", 9, 9, 1500000000000000000, 15000000000000000, now+(60*60*24));
176         newTankProduct("SPG-2", 10, 10, 2000000000000000000, 20000000000000000, now+(60*60*24*2));
177         newTankProduct("HT-3", 11, 11, 2500000000000000000, 25000000000000000, now+(60*60*24*3));
178     }
179     
180     function cashOut (uint256 _amount) public payable {
181         require (_amount >= 0); //just in case
182         require (_amount == uint256(uint128(_amount))); // Just some magic stuff
183         require (this.balance >= _amount); // Checking if this contract has enought money to pay
184         require (balances[msg.sender] >= _amount); // Checking if player has enough funds on his balance
185         if (_amount == 0){
186             _amount = balances[msg.sender];
187             // If the requested amount is 0, it means that player wants to cashout the whole amount of balance
188         }
189         if (msg.sender.send(_amount)){ // Sending funds and if the transaction is successful
190             balances[msg.sender] -= _amount; // Changing the amount of funds on the player's in-game balance
191         }
192         
193         EventCashOut (msg.sender, _amount);
194         return;
195     }
196     
197     function login (string _hash) public {
198         EventLogin (msg.sender, _hash);
199         return;
200     }
201     
202     //upgrade tank
203     // @_upgradeChoice: 0 is for armor, 1 is for damage, 2 is for speed, 3 is for attack speed
204     function upgradeTank (uint32 _tankID, uint8 _upgradeChoice) public payable {
205         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
206         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
207         require (_upgradeChoice >= 0 && _upgradeChoice < 4); // Has to be between 0 and 3
208         require (tanks[_tankID].upgrades[_upgradeChoice] < 5); // Only 5 upgrades are allowed for each type of tank's parametres
209         require (msg.value >= upgradePrice); // Checking if there is enough amount of money for the upgrade
210         tanks[_tankID].upgrades[_upgradeChoice]++; // Upgrading
211         balances[msg.sender] += msg.value-upgradePrice; // Returning the rest amount of money back to the tank owner
212         balances[UpgradeMaster] += upgradePrice; // Sending the amount of money spent on the upgrade to the contract creator
213         
214         EventUpgradeTank (msg.sender, _tankID, _upgradeChoice);
215         return;
216     }
217     
218     
219     // Transfer. Using for sending tanks to another players
220     function _transfer (uint32 _tankID, address _receiver) public {
221         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
222         require (tanks[_tankID].owner == msg.sender); //Checking if sender owns this tank
223         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
224         require (tanks[_tankID].selling == false); //Making sure that the tank is not on the auction now
225         tanks[_tankID].owner = _receiver; // Changing the tank's owner
226         tanks[_tankID].earner = _receiver; // Changing the tank's earner address
227 
228         EventTransfer (msg.sender, _receiver, _tankID);
229         return;
230     }
231     
232     // Transfer Action. Using for sending tanks to EtherTanks' contracts. For example, the battle-area contract.
233     function _transferAction (uint32 _tankID, address _receiver, uint8 _ActionType) public {
234         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
235         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
236         require (msg.sender != _receiver); // Checking that the owner is not sending the tank to himself
237         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction now
238         tanks[_tankID].owner = _receiver; // Changing the tank's owner
239         
240         // As you can see, we do not change the earner here.
241         // It means that technically speaking, the tank's owner is still getting his earnings.
242         // It's logically that this method (transferAction) will be used for sending tanks to the battle area contract or some other contracts which will be interacting with tanks
243         // Be careful with this method! Do not call it to transfer tanks to another player!
244         // The reason you should not do this is that the method called "transfer" changes the owner and earner, so it is possible to change the earner address to the current owner address any time.
245         // However, for our special contracts like battle area, you are able to read this contract and make sure that your tank will not be sent to anyone else, only back to you.
246         // So, please, do not use this method to send your tanks to other players. Use it just for interacting with EtherTanks' contracts, which will be listed on EtherTanks.com
247         
248         EventTransferAction (msg.sender, _receiver, _tankID, _ActionType);
249         return;
250     }
251     
252     //selling
253     function sellTank (uint32 _tankID, uint256 _startPrice, uint256 _finishPrice, uint256 _duration) public {
254         require (_tankID > 0 && _tankID < newIdTank);
255         require (tanks[_tankID].owner == msg.sender);
256         require (tanks[_tankID].selling == false); // Making sure that the tank is not on the auction already
257         require (_startPrice >= _finishPrice);
258         require (_startPrice > 0 && _finishPrice >= 0);
259         require (_duration > 0);
260         require (_startPrice == uint256(uint128(_startPrice))); // Just some magic stuff
261         require (_finishPrice == uint256(uint128(_finishPrice))); // Just some magic stuff
262         
263         auctions[newIdAuctionEntity] = AuctionEntity(_tankID, _startPrice, _finishPrice, now, _duration);
264         tanks[_tankID].selling = true;
265         tanks[_tankID].auctionEntity = newIdAuctionEntity++;
266         
267         EventAuction (msg.sender, _tankID, _startPrice, _finishPrice, _duration, now);
268     }
269     
270     //bidding function, people use this to buy tanks
271     function bid (uint32 _tankID) public payable {
272         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
273         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
274         AuctionEntity memory currentAuction = auctions[tanks[_tankID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
275         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
276         // The line above calculates the current price using the formula StartPrice-(((StartPrice-FinishPrice)/Duration)*(CurrentTime-StartTime)
277         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
278             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
279         }
280         require (currentPrice >= 0); // Who knows :)
281         require (msg.value >= currentPrice); // Checking if the buyer sent the amount of money which is more or equal the current price
282         
283         // All is fine, changing balances and changing tank's owner
284         uint256 marketFee = (currentPrice/100)*3; // Calculating 3% of the current price as a fee
285         balances[tanks[_tankID].owner] += currentPrice-marketFee; // Giving [current price]-[fee] amount to seller
286         balances[AuctionMaster] += marketFee; // Sending the fee amount to the contract creator's balance
287         balances[msg.sender] += msg.value-currentPrice; //Return the rest amount to buyer
288         tanks[_tankID].owner = msg.sender; // Changing the owner of the tank
289         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
290         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
291         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
292         
293         EventBid (_tankID);
294     }
295     
296     //cancel auction
297     function cancelAuction (uint32 _tankID) public {
298         require (_tankID > 0 && _tankID < newIdTank); // Checking if the tank exists
299         require (tanks[_tankID].selling == true); // Checking if this tanks is on the auction now
300         require (tanks[_tankID].owner == msg.sender); // Checking if sender owns this tank
301         tanks[_tankID].selling = false; // Change the tank status to "not selling now"
302         delete auctions[tanks[_tankID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
303         tanks[_tankID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
304         
305         EventCancelAuction (_tankID);
306     }
307     
308     
309     function newTankProduct (string _name, uint32 _hull, uint32 _weapon, uint256 _price, uint256 _earning, uint256 _releaseTime) private {
310         tankProducts[newIdTankProduct++] = TankProduct(_name, _hull, _weapon, _price, _price, _earning, _releaseTime);
311         
312         EventProduct (newIdTankProduct-1, _name, _hull, _weapon, _price, _earning, _releaseTime, now);
313     }
314     
315     function newTankHull (uint32 _armor, uint32 _speed, uint8 _league) private {
316         tankHulls[newIdTankHull++] = TankHull(_armor, _speed, _league);
317     }
318     
319     function newTankWeapon (uint32 _minDamage, uint32 _maxDamage, uint32 _attackSpeed, uint8 _league) private {
320         tankWeapons[newIdTankWeapon++] = TankWeapon(_minDamage, _maxDamage, _attackSpeed, _league);
321     }
322     
323     function buyTank (uint32 _tankproductID) public payable {
324         require (tankProducts[_tankproductID].currentPrice > 0 && msg.value > 0); //value is more than 0, price is more than 0
325         require (msg.value >= tankProducts[_tankproductID].currentPrice); //value is higher than price
326         require (tankProducts[_tankproductID].releaseTime <= now); //checking if this tank was released.
327         // Basically, the releaseTime was implemented just to give a chance to get the new tank for as many players as possible.
328         // It prevents the using of bots.
329         
330         if (msg.value > tankProducts[_tankproductID].currentPrice){
331             // If player payed more, put the rest amount of money on his balance
332             balances[msg.sender] += msg.value-tankProducts[_tankproductID].currentPrice;
333         }
334         
335         tankProducts[_tankproductID].currentPrice += tankProducts[_tankproductID].earning;
336         
337         for (uint32 index = 1; index < newIdTank; index++){
338             if (tanks[index].productID == _tankproductID){
339                 balances[tanks[index].earner] += tankProducts[_tankproductID].earning;
340                 tanks[index].earned += tankProducts[_tankproductID].earning;
341             }
342         }
343         
344         if (tanksBeforeTheNewTankType() == 0 && newIdTankProduct <= 121){
345             newTankType();
346         }
347         
348         tanks[newIdTank++] = TankEntity (_tankproductID, [0, 0, 0, 0], msg.sender, msg.sender, false, 0, 0, 0);
349         
350         // After all owners of the same type of tank got their earnings, admins get the amount which remains and no one need it
351         // Basically, it is the start price of the tank.
352         balances[TankSellMaster] += tankProducts[_tankproductID].startPrice;
353         
354         EventBuyTank (msg.sender, _tankproductID, newIdTank-1);
355         return;
356     }
357     
358     // This is the tricky method which creates the new type tank.
359     function newTankType () public {
360         if (newIdTankProduct > 121){
361             return;
362         }
363         //creating new tank type!
364         if (createNewTankHull < newIdTankHull - 1 && createNewTankWeapon >= newIdTankWeapon - 1) {
365             createNewTankWeapon = 1;
366             createNewTankHull++;
367         } else {
368             createNewTankWeapon++;
369             if (createNewTankHull == createNewTankWeapon) {
370                 createNewTankWeapon++;
371             }
372         }
373         newTankProduct ("Tank", uint32(createNewTankHull), uint32(createNewTankWeapon), 200000000000000000, 3000000000000000, now+(60*60));
374         return;
375     }
376     
377     // Our storage, keys are listed first, then mappings.
378     // Of course, instead of some mappings we could use arrays, but why not
379     
380     uint32 public newIdTank = 1; // The next ID for the new tank
381     uint32 public newIdTankProduct = 1; // The next ID for the new tank type
382     uint32 public newIdTankHull = 1; // The next ID for the new hull
383     uint32 public newIdTankWeapon = 1; // The new ID for the new weapon
384     uint32 public createNewTankHull = 1; // For newTankType()
385     uint32 public createNewTankWeapon = 0; // For newTankType()
386     uint256 public newIdAuctionEntity = 1; // The next ID for the new auction entity
387 
388     mapping (uint32 => TankEntity) tanks; // The storage 
389     mapping (uint32 => TankProduct) tankProducts;
390     mapping (uint32 => TankHull) tankHulls;
391     mapping (uint32 => TankWeapon) tankWeapons;
392     mapping (uint256 => AuctionEntity) auctions;
393     mapping (address => uint) balances;
394 
395     uint256 public constant upgradePrice = 50000000000000000; // The fee which the UgradeMaster earns for upgrading tanks
396 
397     function getTankName (uint32 _ID) public constant returns (string){
398         return tankProducts[_ID].name;
399     }
400     
401     function getTankProduct (uint32 _ID) public constant returns (uint32[6]){
402         return [tankHulls[tankProducts[_ID].hull].armor, tankHulls[tankProducts[_ID].hull].speed, tankWeapons[tankProducts[_ID].weapon].minDamage, tankWeapons[tankProducts[_ID].weapon].maxDamage, tankWeapons[tankProducts[_ID].weapon].attackSpeed, uint32(tankProducts[_ID].releaseTime)];
403     }
404     
405     function getTankDetails (uint32 _ID) public constant returns (uint32[6]){
406         return [tanks[_ID].productID, uint32(tanks[_ID].upgrades[0]), uint32(tanks[_ID].upgrades[1]), uint32(tanks[_ID].upgrades[2]), uint32(tanks[_ID].upgrades[3]), uint32(tanks[_ID].exp)];
407     }
408     
409     function getTankOwner(uint32 _ID) public constant returns (address){
410         return tanks[_ID].owner;
411     }
412     
413     function getTankSell(uint32 _ID) public constant returns (bool){
414         return tanks[_ID].selling;
415     }
416     
417     function getTankTotalEarned(uint32 _ID) public constant returns (uint256){
418         return tanks[_ID].earned;
419     }
420     
421     function getTankAuctionEntity (uint32 _ID) public constant returns (uint256){
422         return tanks[_ID].auctionEntity;
423     }
424     
425     function getCurrentPrice (uint32 _ID) public constant returns (uint256){
426         return tankProducts[_ID].currentPrice;
427     }
428     
429     function getProductEarning (uint32 _ID) public constant returns (uint256){
430         return tankProducts[_ID].earning;
431     }
432     
433     function getTankEarning (uint32 _ID) public constant returns (uint256){
434         return tanks[_ID].earned;
435     }
436     
437     function getCurrentPriceAuction (uint32 _ID) public constant returns (uint256){
438         require (getTankSell(_ID));
439         AuctionEntity memory currentAuction = auctions[tanks[_ID].auctionEntity]; // The auction entity for this tank. Just to make the line below easier to read
440         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
441         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
442             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice 
443         }
444         return currentPrice;
445     }
446     
447     function getPlayerBalance(address _player) public constant returns (uint256){
448         return balances[_player];
449     }
450     
451     function getContractBalance() public constant returns (uint256){
452         return this.balance;
453     }
454     
455     function howManyTanks() public constant returns (uint32){
456         return newIdTankProduct;
457     }
458     
459     function tanksBeforeTheNewTankType() public constant returns (uint256){
460         return 1000+(((newIdTankProduct)+10)*((newIdTankProduct)+10)*(newIdTankProduct-11))-newIdTank;
461     }
462 }
463 
464 /*
465     EtherTanks.com
466     EthereTanks.com
467 */