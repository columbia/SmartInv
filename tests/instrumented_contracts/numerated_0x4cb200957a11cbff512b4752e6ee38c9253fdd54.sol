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
144   uint256 private constant MAX_LIMIT = 1000;
145 
146   // Current raffle info  
147   uint256 private raffleEndTime;
148   uint256 private raffleRareId;
149   uint256 private raffleTicketsBought;
150   address private raffleWinner; // Address of winner
151   bool private raffleWinningTicketSelected;
152   uint256 private raffleTicketThatWon;
153 
154   // Raffle for rare items  
155   function buyRaffleTicket(uint256 amount) external {
156     require(raffleEndTime >= block.timestamp);  //close it if need test
157     require(amount > 0 && amount<=MAX_LIMIT);
158         
159     uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_PRICE, amount);
160     require(cards.balanceOf(msg.sender) >= ticketsCost);
161         
162     // Update player's jade  
163     cards.updatePlayersCoinByPurchase(msg.sender, ticketsCost);
164         
165     // Handle new tickets
166     TicketPurchases storage purchases = ticketsBoughtByPlayer[msg.sender];
167         
168     // If we need to reset tickets from a previous raffle
169     if (purchases.raffleRareId != raffleRareId) {
170       purchases.numPurchases = 0;
171       purchases.raffleRareId = raffleRareId;
172       rafflePlayers[raffleRareId].push(msg.sender); // Add user to raffle
173     }
174         
175     // Store new ticket purchase 
176     if (purchases.numPurchases == purchases.ticketsBought.length) {
177       purchases.ticketsBought.length = SafeMath.add(purchases.ticketsBought.length,1);
178     }
179     purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(raffleTicketsBought, raffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
180         
181     // Finally update ticket total
182     raffleTicketsBought = SafeMath.add(raffleTicketsBought,amount);
183     //event
184     UnitBought(msg.sender,raffleRareId,amount);
185   } 
186 
187   /// @dev start raffle
188   function startRareRaffle(uint256 endTime, uint256 rareId) external onlyAdmin {
189     require(rareId>0);
190     require(rare.getRareItemsOwner(rareId) == getRareAddress());
191     require(block.timestamp < endTime); //close it if need test
192 
193     if (raffleRareId != 0) { // Sanity to assure raffle has ended before next one starts
194       require(raffleWinner != 0);
195     }
196 
197     // Reset previous raffle info
198     raffleWinningTicketSelected = false;
199     raffleTicketThatWon = 0;
200     raffleWinner = 0;
201     raffleTicketsBought = 0;
202         
203     // Set current raffle info
204     raffleEndTime = endTime;
205     raffleRareId = rareId;
206   }
207 
208   function awardRafflePrize(address checkWinner, uint256 checkIndex) external { 
209     require(raffleEndTime < block.timestamp);  //close it if need test
210     require(raffleWinner == 0);
211     require(rare.getRareItemsOwner(raffleRareId) == getRareAddress());
212         
213     if (!raffleWinningTicketSelected) {
214       drawRandomWinner(); // Ideally do it in one call (gas limit cautious)
215     }
216         
217   // Reduce gas by (optionally) offering an address to _check_ for winner
218     if (checkWinner != 0) {
219       TicketPurchases storage tickets = ticketsBoughtByPlayer[checkWinner];
220       if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleRareId == raffleRareId) {
221         TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
222         if (raffleTicketThatWon >= checkTicket.startId && raffleTicketThatWon <= checkTicket.endId) {
223           assignRafflePrize(checkWinner); // WINNER!
224           return;
225         }
226       }
227     }
228         
229   // Otherwise just naively try to find the winner (will work until mass amounts of players)
230     for (uint256 i = 0; i < rafflePlayers[raffleRareId].length; i++) {
231       address player = rafflePlayers[raffleRareId][i];
232       TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
233             
234       uint256 endIndex = playersTickets.numPurchases - 1;
235       // Minor optimization to avoid checking every single player
236       if (raffleTicketThatWon >= playersTickets.ticketsBought[0].startId && raffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
237         for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
238           TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
239           if (raffleTicketThatWon >= playerTicket.startId && raffleTicketThatWon <= playerTicket.endId) {
240             assignRafflePrize(player); // WINNER!
241             return;
242           }
243         }
244       }
245     }
246   }
247 
248   function assignRafflePrize(address winner) internal {
249     raffleWinner = winner;
250     uint256 newPrice = (rare.rareStartPrice() * 25) / 20;
251     rare.transferTokenByContract(raffleRareId,winner);
252     rare.setRarePrice(raffleRareId,newPrice);
253        
254     cards.updatePlayersCoinByOut(winner);
255     uint256 upgradeClass;
256     uint256 unitId;
257     uint256 upgradeValue;
258     (,,,,upgradeClass, unitId, upgradeValue) = rare.getRareInfo(raffleRareId);
259     
260     cards.upgradeUnitMultipliers(winner, upgradeClass, unitId, upgradeValue);
261     //event
262     RaffleSuccessful(winner);
263   }
264   
265   // Random enough for small contests (Owner only to prevent trial & error execution)
266   function drawRandomWinner() public onlyAdmin {
267     require(raffleEndTime < block.timestamp); //close it if need to test
268     require(!raffleWinningTicketSelected);
269         
270     uint256 seed = SafeMath.add(raffleTicketsBought , block.timestamp);
271     raffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, raffleTicketsBought);
272     raffleWinningTicketSelected = true;
273   }  
274 
275   // To allow clients to verify contestants
276   function getRafflePlayers(uint256 raffleId) external constant returns (address[]) {
277     return (rafflePlayers[raffleId]);
278   }
279 
280     // To allow clients to verify contestants
281   function getPlayersTickets(address player) external constant returns (uint256[], uint256[]) {
282     TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
283         
284     if (playersTickets.raffleRareId == raffleRareId) {
285       uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
286       uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
287             
288       for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
289         startIds[i] = playersTickets.ticketsBought[i].startId;
290         endIds[i] = playersTickets.ticketsBought[i].endId;
291       }
292     }
293         
294     return (startIds, endIds);
295   }
296 
297 
298   // To display on website
299   function getLatestRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
300     return (raffleEndTime, raffleRareId, raffleTicketsBought, raffleWinner, raffleTicketThatWon);
301   }    
302 }
303 
304 library SafeMath {
305 
306   /**
307   * @dev Multiplies two numbers, throws on overflow.
308   */
309   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310     if (a == 0) {
311       return 0;
312     }
313     uint256 c = a * b;
314     assert(c / a == b);
315     return c;
316   }
317 
318   /**
319   * @dev Integer division of two numbers, truncating the quotient.
320   */
321   function div(uint256 a, uint256 b) internal pure returns (uint256) {
322     // assert(b > 0); // Solidity automatically throws when dividing by 0
323     uint256 c = a / b;
324     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
325     return c;
326   }
327 
328   /**
329   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
330   */
331   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332     assert(b <= a);
333     return a - b;
334   }
335 
336   /**
337   * @dev Adds two numbers, throws on overflow.
338   */
339   function add(uint256 a, uint256 b) internal pure returns (uint256) {
340     uint256 c = a + b;
341     assert(c >= a);
342     return c;
343   }
344 }