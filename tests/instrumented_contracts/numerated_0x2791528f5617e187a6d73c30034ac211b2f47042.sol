1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.
4 /* 
5 /* https://www.magicacademy.io One of the world's first idle strategy games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jony.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /*
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 contract AccessAdmin is Ownable {
48 
49   /// @dev Admin Address
50   mapping (address => bool) adminContracts;
51 
52   /// @dev Trust contract
53   mapping (address => bool) actionContracts;
54 
55   function setAdminContract(address _addr, bool _useful) public onlyOwner {
56     require(_addr != address(0));
57     adminContracts[_addr] = _useful;
58   }
59 
60   modifier onlyAdmin {
61     require(adminContracts[msg.sender]); 
62     _;
63   }
64 
65   function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {
66     actionContracts[_actionAddr] = _useful;
67   }
68 
69   modifier onlyAccess() {
70     require(actionContracts[msg.sender]);
71     _;
72   }
73 }
74 
75 interface CardsInterface {
76   function balanceOf(address player) public constant returns(uint256);
77   function updatePlayersCoinByOut(address player) external;
78   function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) public;
79   function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
80   function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external;
81 }
82 interface RareInterface {
83   function getRareItemsOwner(uint256 rareId) external view returns (address);
84   function getRareItemsPrice(uint256 rareId) external view returns (uint256);
85     function getRareInfo(uint256 _tokenId) external view returns (
86     uint256 sellingPrice,
87     address owner,
88     uint256 nextPrice,
89     uint256 rareClass,
90     uint256 cardId,
91     uint256 rareValue
92   ); 
93   function transferToken(address _from, address _to, uint256 _tokenId) external;
94   function transferTokenByContract(uint256 _tokenId,address _to) external;
95   function setRarePrice(uint256 _rareId, uint256 _price) external;
96   function rareStartPrice() external view returns (uint256);
97 }
98 contract CardsRaffle is AccessAdmin {
99   using SafeMath for SafeMath;
100 
101   function CardsRaffle() public {
102     setAdminContract(msg.sender,true);
103     setActionContract(msg.sender,true);
104   }
105   //data contract
106   CardsInterface public cards ;
107   RareInterface public rare;
108 
109   function setCardsAddress(address _address) external onlyOwner {
110     cards = CardsInterface(_address);
111   }
112 
113   //rare cards
114   function setRareAddress(address _address) external onlyOwner {
115     rare = RareInterface(_address);
116   }
117 
118   function getRareAddress() public view returns (address) {
119     return rare;
120   }
121 
122   //event
123   event UnitBought(address player, uint256 unitId, uint256 amount);
124   event RaffleSuccessful(address winner);
125 
126   // Raffle structures
127   struct TicketPurchases {
128     TicketPurchase[] ticketsBought;
129     uint256 numPurchases; // Allows us to reset without clearing TicketPurchase[] (avoids potential for gas limit)
130     uint256 raffleRareId;
131   }
132     
133   // Allows us to query winner without looping (avoiding potential for gas limit)
134   struct TicketPurchase {
135     uint256 startId;
136     uint256 endId;
137   }
138     
139   // Raffle tickets
140   mapping(address => TicketPurchases) private ticketsBoughtByPlayer;
141   mapping(uint256 => address[]) private rafflePlayers; // Keeping a seperate list for each raffle has it's benefits. 
142 
143   uint256 private constant RAFFLE_TICKET_BASE_PRICE = 10000;
144 
145   // Current raffle info  
146   uint256 private raffleEndTime;
147   uint256 private raffleRareId;
148   uint256 private raffleTicketsBought;
149   address private raffleWinner; // Address of winner
150   bool private raffleWinningTicketSelected;
151   uint256 private raffleTicketThatWon;
152 
153   // Raffle for rare items  
154   function buyRaffleTicket(uint256 amount) external {
155     require(raffleEndTime >= block.timestamp);  //close it if need test
156     require(amount > 0);
157         
158     uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_PRICE, amount);
159     require(cards.balanceOf(msg.sender) >= ticketsCost);
160         
161     // Update player's jade  
162     cards.updatePlayersCoinByPurchase(msg.sender, ticketsCost);
163         
164     // Handle new tickets
165     TicketPurchases storage purchases = ticketsBoughtByPlayer[msg.sender];
166         
167     // If we need to reset tickets from a previous raffle
168     if (purchases.raffleRareId != raffleRareId) {
169       purchases.numPurchases = 0;
170       purchases.raffleRareId = raffleRareId;
171       rafflePlayers[raffleRareId].push(msg.sender); // Add user to raffle
172     }
173         
174     // Store new ticket purchase 
175     if (purchases.numPurchases == purchases.ticketsBought.length) {
176       purchases.ticketsBought.length = SafeMath.add(purchases.ticketsBought.length,1);
177     }
178     purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(raffleTicketsBought, raffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
179         
180     // Finally update ticket total
181     raffleTicketsBought = SafeMath.add(raffleTicketsBought,amount);
182     //event
183     UnitBought(msg.sender,raffleRareId,amount);
184   } 
185 
186   /// @dev start raffle
187   function startRareRaffle(uint256 endTime, uint256 rareId) external onlyAdmin {
188     require(rareId>0);
189     require(rare.getRareItemsOwner(rareId) == getRareAddress());
190     require(block.timestamp < endTime); //close it if need test
191 
192     if (raffleRareId != 0) { // Sanity to assure raffle has ended before next one starts
193       require(raffleWinner != 0);
194     }
195 
196     // Reset previous raffle info
197     raffleWinningTicketSelected = false;
198     raffleTicketThatWon = 0;
199     raffleWinner = 0;
200     raffleTicketsBought = 0;
201         
202     // Set current raffle info
203     raffleEndTime = endTime;
204     raffleRareId = rareId;
205   }
206 
207   function awardRafflePrize(address checkWinner, uint256 checkIndex) external { 
208     require(raffleEndTime < block.timestamp);  //close it if need test
209     require(raffleWinner == 0);
210     require(rare.getRareItemsOwner(raffleRareId) == getRareAddress());
211         
212     if (!raffleWinningTicketSelected) {
213       drawRandomWinner(); // Ideally do it in one call (gas limit cautious)
214     }
215         
216   // Reduce gas by (optionally) offering an address to _check_ for winner
217     if (checkWinner != 0) {
218       TicketPurchases storage tickets = ticketsBoughtByPlayer[checkWinner];
219       if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleRareId == raffleRareId) {
220         TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
221         if (raffleTicketThatWon >= checkTicket.startId && raffleTicketThatWon <= checkTicket.endId) {
222           assignRafflePrize(checkWinner); // WINNER!
223           return;
224         }
225       }
226     }
227         
228   // Otherwise just naively try to find the winner (will work until mass amounts of players)
229     for (uint256 i = 0; i < rafflePlayers[raffleRareId].length; i++) {
230       address player = rafflePlayers[raffleRareId][i];
231       TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
232             
233       uint256 endIndex = playersTickets.numPurchases - 1;
234       // Minor optimization to avoid checking every single player
235       if (raffleTicketThatWon >= playersTickets.ticketsBought[0].startId && raffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
236         for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
237           TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
238           if (raffleTicketThatWon >= playerTicket.startId && raffleTicketThatWon <= playerTicket.endId) {
239             assignRafflePrize(player); // WINNER!
240             return;
241           }
242         }
243       }
244     }
245   }
246 
247   function assignRafflePrize(address winner) internal {
248     raffleWinner = winner;
249     uint256 newPrice = (rare.rareStartPrice() * 25) / 20;
250     rare.transferTokenByContract(raffleRareId,winner);
251     rare.setRarePrice(raffleRareId,newPrice);
252        
253     cards.updatePlayersCoinByOut(winner);
254     uint256 upgradeClass;
255     uint256 unitId;
256     uint256 upgradeValue;
257     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRareInfo(raffleRareId);
258     
259     cards.upgradeUnitMultipliers(winner, upgradeClass, unitId, upgradeValue);
260     //event
261     RaffleSuccessful(winner);
262   }
263   
264   // Random enough for small contests (Owner only to prevent trial & error execution)
265   function drawRandomWinner() public onlyAdmin {
266     require(raffleEndTime < block.timestamp); //close it if need to test
267     require(!raffleWinningTicketSelected);
268         
269     uint256 seed = SafeMath.add(raffleTicketsBought , block.timestamp);
270     raffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, raffleTicketsBought);
271     raffleWinningTicketSelected = true;
272   }  
273 
274   // To allow clients to verify contestants
275   function getRafflePlayers(uint256 raffleId) external constant returns (address[]) {
276     return (rafflePlayers[raffleId]);
277   }
278 
279     // To allow clients to verify contestants
280   function getPlayersTickets(address player) external constant returns (uint256[], uint256[]) {
281     TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
282         
283     if (playersTickets.raffleRareId == raffleRareId) {
284       uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
285       uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
286             
287       for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
288         startIds[i] = playersTickets.ticketsBought[i].startId;
289         endIds[i] = playersTickets.ticketsBought[i].endId;
290       }
291     }
292         
293     return (startIds, endIds);
294   }
295 
296 
297   // To display on website
298   function getLatestRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
299     return (raffleEndTime, raffleRareId, raffleTicketsBought, raffleWinner, raffleTicketThatWon);
300   }    
301 }
302 
303 library SafeMath {
304 
305   /**
306   * @dev Multiplies two numbers, throws on overflow.
307   */
308   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
309     if (a == 0) {
310       return 0;
311     }
312     uint256 c = a * b;
313     assert(c / a == b);
314     return c;
315   }
316 
317   /**
318   * @dev Integer division of two numbers, truncating the quotient.
319   */
320   function div(uint256 a, uint256 b) internal pure returns (uint256) {
321     // assert(b > 0); // Solidity automatically throws when dividing by 0
322     uint256 c = a / b;
323     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
324     return c;
325   }
326 
327   /**
328   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
329   */
330   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331     assert(b <= a);
332     return a - b;
333   }
334 
335   /**
336   * @dev Adds two numbers, throws on overflow.
337   */
338   function add(uint256 a, uint256 b) internal pure returns (uint256) {
339     uint256 c = a + b;
340     assert(c >= a);
341     return c;
342   }
343 }