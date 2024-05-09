1 pragma solidity ^0.4.0;
2 
3 /*
4 
5                                   # #  ( )
6                                   ___#_#___|__
7                               _  |____________|  _
8                        _=====| | |            | | |==== _
9                  =====| |.---------------------------. | |====
10    <--------------------'   .  .  .  .  .  .  .  .   '--------------/
11      \                                                             /
12       \___________________________________________________________/
13   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
14 wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
15    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww 
16 
17 */
18 
19 contract EtherShipsCore {
20 
21     struct ShipProduct {
22         string name; // Ship's name
23         uint32 armor; // Armor value
24         uint32 speed; // Speed value
25         uint32 minDamage; // Ship's minimal damage value
26         uint32 maxDamage; // Ship's maximum damage value
27         uint32 attackSpeed; // Ship's attack speed value
28         uint8 league; // The battle league which allows to play with this ship type
29         // Unfortunately, it's impossible to define the variable inside the struct as constant.
30         // However, you can read this smart-contract and see that there are no changes at all related to the start prices.
31         uint256 startPrice;
32         uint256 currentPrice; // The current price. Changes every time someone buys this kind of ship
33         uint256 earning; // The amount of earning each owner of this ship gets when someone buys this type of ship
34         uint256 releaseTime; // The moment when it will be allowed to buy this type of ship
35         uint32 amountOfShips; // The amount of ships with this kind of product
36 
37     }
38 
39     struct ShipEntity {
40         uint32 productID;
41         uint8[4] upgrades;
42         address owner; // The address of the owner of this ship
43         address earner; // The address of the earner of this ship who get paid
44         bool selling; // Is this ship on the auction now?
45         uint256 auctionEntity; // If it's on the auction,
46         uint256 earned; // Total funds earned with this ship
47         uint32 exp; // ship's experience
48         uint32 lastCashoutIndex; // Last amount of ships existing in the game with the same ProductID
49     }
50 
51     struct AuctionEntity {
52         uint32 shipID;
53         uint256 startPrice;
54         uint256 finishPrice;
55         uint256 startTime;
56         uint256 duration;
57     }
58 
59     event EventCashOut (
60        address indexed player,
61        uint256 amount
62        ); //;-)
63 
64     event EventLogin (
65         address indexed player,
66         string hash
67         ); //;-)
68 
69     event EventUpgradeShip (
70         address indexed player,
71         uint32 shipID,
72         uint8 upgradeChoice
73         ); // ;-)
74 
75     event EventTransfer (
76         address indexed player,
77         address indexed receiver,
78         uint32 shipID
79         ); // ;-)
80 
81     event EventTransferAction (
82         address indexed player,
83         address indexed receiver,
84         uint32 shipID,
85         uint8 ActionType
86         ); // ;-)
87 
88     event EventAuction (
89         address indexed player,
90         uint32 shipID,
91         uint256 startPrice,
92         uint256 finishPrice,
93         uint256 duration,
94         uint256 currentTime
95         ); // ;-)
96         
97     event EventCancelAuction (
98         uint32 shipID
99         ); // ;-)
100 
101     event EventBid (
102         uint32 shipID
103         ); // ;-)
104 
105     event EventBuyShip (
106         address indexed player,
107         uint32 productID,
108         uint32 shipID
109         ); // ;-)
110 
111     address public UpgradeMaster; // Earns fees for upgrading ships (0.05 Eth)
112     address public AuctionMaster; // Earns fees for producing auctions (3%)
113     address public ShipSellMaster; // Earns fees for selling ships (start price)
114 
115     function ChangeUpgradeMaster (address _newMaster) public {
116         require(msg.sender == UpgradeMaster);
117         UpgradeMaster = _newMaster;
118     }
119 
120     function ChangeShipSellMaster (address _newMaster) public {
121         require(msg.sender == ShipSellMaster);
122         ShipSellMaster = _newMaster;
123     }
124 
125     function ChangeAuctionMaster (address _newMaster) public {
126         require(msg.sender == AuctionMaster);
127         AuctionMaster = _newMaster;
128     }
129 
130     function EtherShipsCore() public {
131 
132         UpgradeMaster = msg.sender;
133         AuctionMaster = msg.sender;
134         ShipSellMaster = msg.sender;
135 
136         // Creating ship types
137         //name, armor, speed, minDamage, maxDamage, attackSpeed, league, start price, earning, release time
138         
139         newShipProduct("L-Raz", 50, 5, 5, 40, 5, 1, 50000000000000000, 500000000000000, now);
140         newShipProduct("L-Vip", 50, 4, 6, 35, 6, 1, 50000000000000000, 500000000000000, now+(60*60*3));
141         newShipProduct("L-Rapt", 50, 5, 5, 35, 5, 1, 50000000000000000, 500000000000000, now+(60*60*6));
142         newShipProduct("L-Slash", 50, 5, 5, 30, 6, 1, 50000000000000000, 500000000000000, now+(60*60*12));
143         newShipProduct("L-Stin", 50, 5, 5, 40, 5, 1, 50000000000000000, 500000000000000, now+(60*60*24));
144         newShipProduct("L-Scor", 50, 4, 5, 35, 5, 1, 50000000000000000, 500000000000000, now+(60*60*48));
145         
146         newShipProduct("Sub-Sc", 60, 5, 45, 115, 4, 2, 100000000000000000, 1000000000000000, now);
147         newShipProduct("Sub-Cycl", 70, 4, 40, 115, 4, 2, 100000000000000000, 1000000000000000, now+(60*60*6));
148         newShipProduct("Sub-Deep", 80, 5, 45, 120, 4, 2, 100000000000000000, 1000000000000000, now+(60*60*12));
149         newShipProduct("Sub-Sp", 90, 4, 50, 120, 3, 2, 100000000000000000, 1000000000000000, now+(60*60*24));
150         newShipProduct("Sub-Ab", 100, 5, 55, 130, 3, 2, 100000000000000000, 1000000000000000, now+(60*60*48));
151 
152         newShipProduct("M-Sp", 140, 4, 40, 120, 4, 3, 200000000000000000, 2000000000000000, now);
153         newShipProduct("M-Arma", 150, 4, 40, 115, 5, 3, 200000000000000000, 2000000000000000, now+(60*60*12));
154         newShipProduct("M-Penetr", 160, 4, 35, 120, 6, 3, 200000000000000000, 2000000000000000, now+(60*60*24));
155         newShipProduct("M-Slice", 170, 4, 45, 120, 3, 3, 200000000000000000, 2000000000000000, now+(60*60*36));
156         newShipProduct("M-Hell", 180, 3, 35, 120, 2, 3, 200000000000000000, 2000000000000000, now+(60*60*48));
157 
158         newShipProduct("H-Haw", 210, 3, 65, 140, 3, 4, 400000000000000000, 4000000000000000, now);
159         newShipProduct("H-Fat", 220, 3, 75, 150, 2, 4, 400000000000000000, 4000000000000000, now+(60*60*24));
160         newShipProduct("H-Beh", 230, 2, 85, 160, 2, 4, 400000000000000000, 4000000000000000, now+(60*60*48));
161         newShipProduct("H-Mamm", 240, 2, 100, 170, 2, 4, 400000000000000000, 4000000000000000, now+(60*60*72));
162         newShipProduct("H-BigM", 250, 2, 120, 180, 3, 4, 400000000000000000, 4000000000000000, now+(60*60*96));
163 
164     }
165 
166     function cashOut (uint256 _amount) public payable {
167 
168         require (_amount >= 0); //just in case
169         require (_amount == uint256(uint128(_amount))); // Just some magic stuff
170         require (this.balance >= _amount); // Checking if this contract has enought money to pay
171         require (balances[msg.sender] >= _amount); // Checking if player has enough funds on his balance
172         if (_amount == 0){
173             _amount = balances[msg.sender];
174             // If the requested amount is 0, it means that player wants to cashout the whole amount of balance
175         }
176 
177         balances[msg.sender] -= _amount; // Changing the amount of funds on the player's in-game balance
178 
179         if (!msg.sender.send(_amount)){ // Sending funds and if the transaction is failed
180             balances[msg.sender] += _amount; // Returning the amount of funds on the player's in-game balance
181         }
182 
183         EventCashOut (msg.sender, _amount);
184         return;
185     }
186 
187     function cashOutShip (uint32 _shipID) public payable {
188 
189         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
190         require (ships[_shipID].owner == msg.sender); // Checking if sender owns this ship
191         uint256 _amount = shipProducts[ships[_shipID].productID].earning*(shipProducts[ships[_shipID].productID].amountOfShips-ships[_shipID].lastCashoutIndex);
192         require (this.balance >= _amount); // Checking if this contract has enought money to pay
193         require (_amount > 0);
194 
195         uint32 lastIndex = ships[_shipID].lastCashoutIndex;
196 
197         ships[_shipID].lastCashoutIndex = shipProducts[ships[_shipID].productID].amountOfShips; // Changing the amount of funds on the ships's in-game balance
198 
199         if (!ships[_shipID].owner.send(_amount)){ // Sending funds and if the transaction is failed
200             ships[_shipID].lastCashoutIndex = lastIndex; // Changing the amount of funds on the ships's in-game balance
201         }
202 
203         EventCashOut (msg.sender, _amount);
204         return;
205     }
206 
207     function login (string _hash) public {
208         EventLogin (msg.sender, _hash);
209         return;
210     }
211 
212     //upgrade ship
213     // @_upgradeChoice: 0 is for armor, 1 is for damage, 2 is for speed, 3 is for attack speed
214     function upgradeShip (uint32 _shipID, uint8 _upgradeChoice) public payable {
215         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
216         require (ships[_shipID].owner == msg.sender); // Checking if sender owns this ship
217         require (_upgradeChoice >= 0 && _upgradeChoice < 4); // Has to be between 0 and 3
218         require (ships[_shipID].upgrades[_upgradeChoice] < 5); // Only 5 upgrades are allowed for each type of ship's parametres
219         require (msg.value >= upgradePrice); // Checking if there is enough amount of money for the upgrade
220         ships[_shipID].upgrades[_upgradeChoice]++; // Upgrading
221         balances[msg.sender] += msg.value-upgradePrice; // Returning the rest amount of money back to the ship owner
222         balances[UpgradeMaster] += upgradePrice; // Sending the amount of money spent on the upgrade to the contract creator
223 
224         EventUpgradeShip (msg.sender, _shipID, _upgradeChoice);
225         return;
226     }
227 
228 
229     // Transfer. Using for sending ships to another players
230     function _transfer (uint32 _shipID, address _receiver) public {
231         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
232         require (ships[_shipID].owner == msg.sender); //Checking if sender owns this ship
233         require (msg.sender != _receiver); // Checking that the owner is not sending the ship to himself
234         require (ships[_shipID].selling == false); //Making sure that the ship is not on the auction now
235         ships[_shipID].owner = _receiver; // Changing the ship's owner
236         ships[_shipID].earner = _receiver; // Changing the ship's earner address
237 
238         EventTransfer (msg.sender, _receiver, _shipID);
239         return;
240     }
241 
242     // Transfer Action. Using for sending ships to EtherArmy's contracts. For example, the battle-area contract.
243     function _transferAction (uint32 _shipID, address _receiver, uint8 _ActionType) public {
244         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
245         require (ships[_shipID].owner == msg.sender); // Checking if sender owns this ship
246         require (msg.sender != _receiver); // Checking that the owner is not sending the ship to himself
247         require (ships[_shipID].selling == false); // Making sure that the ship is not on the auction now
248         ships[_shipID].owner = _receiver; // Changing the ship's owner
249 
250         // As you can see, we do not change the earner here.
251         // It means that technically speaking, the ship's owner is still getting his earnings.
252         // It's logically that this method (transferAction) will be used for sending ships to the battle area contract or some other contracts which will be interacting with ships
253         // Be careful with this method! Do not call it to transfer ships to another player!
254         // The reason you should not do this is that the method called "transfer" changes the owner and earner, so it is possible to change the earner address to the current owner address any time.
255         // However, for our special contracts like battle area, you are able to read this contract and make sure that your ship will not be sent to anyone else, only back to you.
256         // So, please, do not use this method to send your ships to other players. Use it just for interacting with Etherships' contracts, which will be listed on Etherships.com
257 
258         EventTransferAction (msg.sender, _receiver, _shipID, _ActionType);
259         return;
260     }
261 
262     //selling
263     function sellShip (uint32 _shipID, uint256 _startPrice, uint256 _finishPrice, uint256 _duration) public {
264         require (_shipID > 0 && _shipID < newIdShip);
265         require (ships[_shipID].owner == msg.sender);
266         require (ships[_shipID].selling == false); // Making sure that the ship is not on the auction already
267         require (_startPrice >= _finishPrice);
268         require (_startPrice > 0 && _finishPrice >= 0);
269         require (_duration > 0);
270         require (_startPrice == uint256(uint128(_startPrice))); // Just some magic stuff
271         require (_finishPrice == uint256(uint128(_finishPrice))); // Just some magic stuff
272 
273         auctions[newIdAuctionEntity] = AuctionEntity(_shipID, _startPrice, _finishPrice, now, _duration);
274         ships[_shipID].selling = true;
275         ships[_shipID].auctionEntity = newIdAuctionEntity++;
276 
277         EventAuction (msg.sender, _shipID, _startPrice, _finishPrice, _duration, now);
278     }
279 
280     //bidding function, people use this to buy ships
281     function bid (uint32 _shipID) public payable {
282         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
283         require (ships[_shipID].selling == true); // Checking if this ships is on the auction now
284         AuctionEntity memory currentAuction = auctions[ships[_shipID].auctionEntity]; // The auction entity for this ship. Just to make the line below easier to read
285         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
286         // The line above calculates the current price using the formula StartPrice-(((StartPrice-FinishPrice)/Duration)*(CurrentTime-StartTime)
287         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
288             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice
289         }
290         require (currentPrice >= 0); // Who knows :)
291         require (msg.value >= currentPrice); // Checking if the buyer sent the amount of money which is more or equal the current price
292 
293         // All is fine, changing balances and changing ship's owner
294         uint256 marketFee = (currentPrice/100)*3; // Calculating 3% of the current price as a fee
295         balances[ships[_shipID].owner] += currentPrice-marketFee; // Giving [current price]-[fee] amount to seller
296         balances[AuctionMaster] += marketFee; // Sending the fee amount to the contract creator's balance
297         balances[msg.sender] += msg.value-currentPrice; //Return the rest amount to buyer
298         ships[_shipID].owner = msg.sender; // Changing the owner of the ship
299         ships[_shipID].selling = false; // Change the ship status to "not selling now"
300         delete auctions[ships[_shipID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
301         ships[_shipID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
302 
303         EventBid (_shipID);
304     }
305 
306     //cancel auction
307     function cancelAuction (uint32 _shipID) public {
308         require (_shipID > 0 && _shipID < newIdShip); // Checking if the ship exists
309         require (ships[_shipID].selling == true); // Checking if this ships is on the auction now
310         require (ships[_shipID].owner == msg.sender); // Checking if sender owns this ship
311         ships[_shipID].selling = false; // Change the ship status to "not selling now"
312         delete auctions[ships[_shipID].auctionEntity]; // Deleting the auction entity from the storage for auctions -- we don't need it anymore
313         ships[_shipID].auctionEntity = 0; // Not necessary, but deleting the ID of auction entity which was deleted in the operation above
314 
315         EventCancelAuction (_shipID);
316     }
317 
318 
319     function newShipProduct (string _name, uint32 _armor, uint32 _speed, uint32 _minDamage, uint32 _maxDamage, uint32 _attackSpeed, uint8 _league, uint256 _price, uint256 _earning, uint256 _releaseTime) private {
320         shipProducts[newIdShipProduct++] = ShipProduct(_name, _armor, _speed, _minDamage, _maxDamage, _attackSpeed, _league, _price, _price, _earning, _releaseTime, 0);
321     }
322 
323     function buyShip (uint32 _shipproductID) public payable {
324         require (shipProducts[_shipproductID].currentPrice > 0 && msg.value > 0); //value is more than 0, price is more than 0
325         require (msg.value >= shipProducts[_shipproductID].currentPrice); //value is higher than price
326         require (shipProducts[_shipproductID].releaseTime <= now); //checking if this ship was released.
327         // Basically, the releaseTime was implemented just to give a chance to get the new ship for as many players as possible.
328         // It prevents the using of bots.
329 
330         if (msg.value > shipProducts[_shipproductID].currentPrice){
331             // If player payed more, put the rest amount of money on his balance
332             balances[msg.sender] += msg.value-shipProducts[_shipproductID].currentPrice;
333         }
334 
335         shipProducts[_shipproductID].currentPrice += shipProducts[_shipproductID].earning;
336 
337         ships[newIdShip++] = ShipEntity (_shipproductID, [0, 0, 0, 0], msg.sender, msg.sender, false, 0, 0, 0, ++shipProducts[_shipproductID].amountOfShips);
338 
339         // After all owners of the same type of ship got their earnings, admins get the amount which remains and no one need it
340         // Basically, it is the start price of the ship.
341         balances[ShipSellMaster] += shipProducts[_shipproductID].startPrice;
342 
343         EventBuyShip (msg.sender, _shipproductID, newIdShip-1);
344         return;
345     }
346 
347     // Our storage, keys are listed first, then mappings.
348     // Of course, instead of some mappings we could use arrays, but why not
349 
350     uint32 public newIdShip = 1; // The next ID for the new ship
351     uint32 public newIdShipProduct = 1; // The next ID for the new ship type
352     uint256 public newIdAuctionEntity = 1; // The next ID for the new auction entity
353 
354     mapping (uint32 => ShipEntity) ships; // The storage
355     mapping (uint32 => ShipProduct) shipProducts;
356     mapping (uint256 => AuctionEntity) auctions;
357     mapping (address => uint) balances;
358 
359     uint256 public constant upgradePrice = 5000000000000000; // The fee which the UgradeMaster earns for upgrading ships. Fee: 0.005 Eth
360 
361     function getShipName (uint32 _ID) public constant returns (string){
362         return shipProducts[_ID].name;
363     }
364 
365     function getShipProduct (uint32 _ID) public constant returns (uint32[7]){
366         return [shipProducts[_ID].armor, shipProducts[_ID].speed, shipProducts[_ID].minDamage, shipProducts[_ID].maxDamage, shipProducts[_ID].attackSpeed, uint32(shipProducts[_ID].releaseTime), uint32(shipProducts[_ID].league)];
367     }
368 
369     function getShipDetails (uint32 _ID) public constant returns (uint32[6]){
370         return [ships[_ID].productID, uint32(ships[_ID].upgrades[0]), uint32(ships[_ID].upgrades[1]), uint32(ships[_ID].upgrades[2]), uint32(ships[_ID].upgrades[3]), uint32(ships[_ID].exp)];
371     }
372 
373     function getShipOwner(uint32 _ID) public constant returns (address){
374         return ships[_ID].owner;
375     }
376 
377     function getShipSell(uint32 _ID) public constant returns (bool){
378         return ships[_ID].selling;
379     }
380 
381     function getShipTotalEarned(uint32 _ID) public constant returns (uint256){
382         return ships[_ID].earned;
383     }
384 
385     function getShipAuctionEntity (uint32 _ID) public constant returns (uint256){
386         return ships[_ID].auctionEntity;
387     }
388 
389     function getCurrentPrice (uint32 _ID) public constant returns (uint256){
390         return shipProducts[_ID].currentPrice;
391     }
392 
393     function getProductEarning (uint32 _ID) public constant returns (uint256){
394         return shipProducts[_ID].earning;
395     }
396 
397     function getShipEarning (uint32 _ID) public constant returns (uint256){
398         return shipProducts[ships[_ID].productID].earning*(shipProducts[ships[_ID].productID].amountOfShips-ships[_ID].lastCashoutIndex);
399     }
400 
401     function getCurrentPriceAuction (uint32 _ID) public constant returns (uint256){
402         require (getShipSell(_ID));
403         AuctionEntity memory currentAuction = auctions[ships[_ID].auctionEntity]; // The auction entity for this ship. Just to make the line below easier to read
404         uint256 currentPrice = currentAuction.startPrice-(((currentAuction.startPrice-currentAuction.finishPrice)/(currentAuction.duration))*(now-currentAuction.startTime));
405         if (currentPrice < currentAuction.finishPrice){ // If the auction duration time has been expired
406             currentPrice = currentAuction.finishPrice;  // Setting the current price as finishPrice
407         }
408         return currentPrice;
409     }
410 
411     function getPlayerBalance(address _player) public constant returns (uint256){
412         return balances[_player];
413     }
414 
415     function getContractBalance() public constant returns (uint256){
416         return this.balance;
417     }
418 
419     function howManyShips() public constant returns (uint32){
420         return newIdShipProduct;
421     }
422 
423 }
424 
425 /*
426     EtherArmy.com
427     Ethertanks.com
428     Etheretanks.com
429 */