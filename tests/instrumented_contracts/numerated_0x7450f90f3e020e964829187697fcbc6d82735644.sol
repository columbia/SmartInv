1 /**
2  * The Edgeless blackjack contract only allows calls from the authorized casino proxy contracts. 
3  * The proxy contract only forward moves if called by an authorized wallet owned by the Edgeless casino, but the game
4  * data has to be signed by the player to show his approval. This way, Edgeless can provide a fluid game experience
5  * without having to wait for transaction confirmations.
6  * author: Julia Altenried
7  **/
8 
9 pragma solidity ^ 0.4 .17;
10 
11 contract owned {
12   address public owner;
13   modifier onlyOwner {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function owned() public {
19     owner = msg.sender;
20   }
21 
22   function changeOwner(address newOwner) onlyOwner public {
23     owner = newOwner;
24   }
25 }
26 
27 contract mortal is owned {
28   function close() onlyOwner public {
29     selfdestruct(owner);
30   }
31 }
32 
33 contract casino is mortal {
34   /** the minimum bet**/
35   uint public minimumBet;
36   /** the maximum bet **/
37   uint public maximumBet;
38   /** tells if an address is authorized to call game functions **/
39   mapping(address => bool) public authorized;
40 
41   /** notify listeners that an error occurred**/
42   event Error(uint8 errorCode);
43 
44   /** 
45    * constructur. initialize the contract with initial values. 
46    * @param minBet         the minimum bet
47    *        maxBet         the maximum bet
48    **/
49   function casino(uint minBet, uint maxBet) public {
50     minimumBet = minBet;
51     maximumBet = maxBet;
52   }
53 
54   /** 
55    * allows the owner to change the minimum bet
56    * @param newMin the new minimum bet
57    **/
58   function setMinimumBet(uint newMin) onlyOwner public {
59     minimumBet = newMin;
60   }
61 
62   /** 
63    * allows the owner to change the maximum bet
64    * @param newMax the new maximum bet
65    **/
66   function setMaximumBet(uint newMax) onlyOwner public {
67     maximumBet = newMax;
68   }
69 
70 
71   /**
72    * authorize a address to call game functions.
73    * @param addr the address to be authorized
74    **/
75   function authorize(address addr) onlyOwner public {
76     authorized[addr] = true;
77   }
78 
79   /**
80    * deauthorize a address to call game functions.
81    * @param addr the address to be deauthorized
82    **/
83   function deauthorize(address addr) onlyOwner public {
84     authorized[addr] = false;
85   }
86 
87 
88   /**
89    * checks if an address is authorized to call game functionality
90    **/
91   modifier onlyAuthorized {
92     require(authorized[msg.sender]);
93     _;
94   }
95 }
96 
97 contract blackjack is casino {
98   struct Game {
99     /** the hash of the (partial) deck **/
100     bytes32 deck;
101     /** the hash of the casino seed used for randomness generation and deck-hashing, also serves as id**/
102     bytes32 seedHash;
103     /** the player address **/
104     address player;
105     /** the bet **/
106     uint bet;
107   }
108 
109   /** the value of the cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K . Ace can be 1 or 11, of course. 
110    *   the value of a card can be determined by looking up cardValues[cardId%13]**/
111   uint8[13] cardValues = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
112 
113   /** use the game id to reference the games **/
114   mapping(bytes32 => Game) games;
115   /** list of splits per game - length 0 in most cases **/
116   mapping(bytes32 => uint8[]) splits;
117   /** tells if a hand of a given game has been doubled **/
118   mapping(bytes32 => mapping(uint8 => bool)) doubled;
119   /** tells if the player already claimed his win **/
120   mapping(bytes32 => bool) over;
121 
122   /** notify listeners that a new round of blackjack started **/
123   event NewGame(bytes32 indexed id, bytes32 deck, bytes32 srvSeed, bytes32 cSeed, address player, uint bet);
124   /** notify listeners of the game outcome **/
125   event Result(bytes32 indexed id, address player, uint win);
126   /** notify listeners that the player doubled **/
127   event Double(bytes32 indexed id, uint8 hand);
128   /** notify listeners that the player split **/
129   event Split(bytes32 indexed id, uint8 hand);
130 
131   /** 
132    * constructur. initialize the contract with a minimum bet and a signer address. 
133    * @param minBet         the minimum bet
134    *        maxBet         the maximum bet
135    *        bankroll       the lower bound for profit sharing
136    *        lotteryAddress the address of the lottery contract
137    *        profitAddress  the address to send 60% of the profit to on payday
138    **/
139   function blackjack(uint minBet, uint maxBet) casino(minBet, maxBet) public {
140 
141   }
142 
143   /** 
144    *   initializes a round of blackjack with an id, the hash of the (partial) deck and the hash of the server seed. 
145    *   accepts the bet.
146    *   throws an exception if the bet is too low or a game with the given id already exists.
147    *   @param player  the address of the player
148    *          value   the value of the bet in tokens
149    *          deck    the hash of the deck
150    *          srvSeed the hash of the server seed
151    *          cSeed   the plain client seed
152    **/
153   function initGame(address player, uint value, bytes32 deck, bytes32 srvSeed, bytes32 cSeed) onlyAuthorized public {
154     //throw if game with id already exists. later maybe throw only if game with id is still running
155     assert(value >= minimumBet && value <= maximumBet);
156     assert(!gameExists(srvSeed));
157     games[srvSeed] = Game(deck, srvSeed, player, value);
158     NewGame(srvSeed, deck, srvSeed, cSeed, player, value);
159   }
160 
161   /**
162    *   doubles the bet of the game with the given id if the correct amount is sent and the player did not double the hand yet.
163    *   @param id    the game id
164    *          hand  the index of the hand being doubled
165    *          value the number of tokens sent by the player
166    **/
167   function double(bytes32 id, uint8 hand, uint value) onlyAuthorized public {
168     Game storage game = games[id];
169     require(value == game.bet);
170     require(hand <= splits[id].length && !doubled[id][hand]);
171     doubled[id][hand] = true;
172     Double(id, hand);
173   }
174 
175   /**
176    *   splits the hands of the game with the given id if the correct amount is sent from the player address and the player
177    *   did not split yet.
178    *   @param id    the game id
179    *          hand  the index of the hand being split
180    *          value the number of tokens sent by the player
181    **/
182   function split(bytes32 id, uint8 hand, uint value) onlyAuthorized public {
183     Game storage game = games[id];
184     require(value == game.bet);
185     require(splits[id].length < 3);
186     splits[id].push(hand);
187     Split(id, hand);
188   }
189 
190 
191   /**
192    * by surrendering half the bet is returned to the player.
193    * send the plain server seed to check if it's correct
194    * @param seed the server seed
195    **/
196   function surrender(bytes32 seed) onlyAuthorized public {
197     var id = keccak256(seed);
198     Game storage game = games[id];
199     require(id == game.seedHash);
200     require(!over[id]);
201     over[id] = true;
202     assert(msg.sender.call(bytes4(keccak256("shift(address,uint256)")), game.player, game.bet / 2));
203     Result(id, game.player, game.bet / 2);
204   }
205 
206   /** 
207    * first checks if deck and the player's number of cards are correct, then checks if the player won and if so, sends the win.
208    * @param deck      the partial deck
209    *        seed      the plain server seed
210    *        numCards  the number of cards per hand
211    **/
212   function stand(uint8[] deck, bytes32 seed, uint8[] numCards) onlyAuthorized public {
213     var gameId = keccak256(seed); //if seed is incorrect the first condition will already fail
214     Game storage game = games[gameId];
215     assert(!over[gameId]);
216     assert(checkDeck(gameId, deck, seed));
217     assert(splits[gameId].length == numCards.length - 1);
218     over[gameId] = true;
219     uint win = determineOutcome(gameId, deck, numCards);
220     if (win > 0) assert(msg.sender.call(bytes4(keccak256("shift(address,uint256)")), game.player, win));
221     Result(gameId, game.player, win);
222   }
223 
224   /**
225    * checks if a game with the given id already exists
226    * @param id the game id
227    **/
228   function gameExists(bytes32 id) constant public returns(bool success) {
229     if (games[id].player != 0x0) return true;
230     return false;
231   }
232 
233   /**
234    * check if deck and casino seed are correct.
235    * @param gameId the game id
236    *        deck   the partial deck
237    *        seed   the server seed
238    * @return true if correct
239    **/
240   function checkDeck(bytes32 gameId, uint8[] deck, bytes32 seed) constant public returns(bool correct) {
241     if (keccak256(convertToBytes(deck), seed) != games[gameId].deck) return false;
242     return true;
243   }
244 
245   /**
246    * converts an uint8 array to bytes
247    * @param byteArray the uint8 array to be converted
248    * @return the bytes
249    **/
250   function convertToBytes(uint8[] byteArray) internal constant returns(bytes b) {
251     b = new bytes(byteArray.length);
252     for (uint8 i = 0; i < byteArray.length; i++)
253       b[i] = byte(byteArray[i]);
254   }
255 
256   /**
257    * determines the outcome of a game and returns the win. 
258    * in case of a loss, win is 0.
259    * @param gameId    the id of the game
260    *        cards     the cards / partial deck
261    *        numCards  the number of cards per hand
262    * @return the total win of all hands
263    **/
264   function determineOutcome(bytes32 gameId, uint8[] cards, uint8[] numCards) constant public returns(uint totalWin) {
265     Game storage game = games[gameId];
266     var playerValues = getPlayerValues(cards, numCards, splits[gameId]);
267     var (dealerValue, dealerBJ) = getDealerValue(cards, sum(numCards));
268     uint win;
269     for (uint8 h = 0; h < numCards.length; h++) {
270       uint8 playerValue = playerValues[h];
271       //bust if value > 21
272       if (playerValue > 21) win = 0;
273       //player blackjack but no dealer blackjack
274       else if (numCards.length == 1 && playerValue == 21 && numCards[h] == 2 && !dealerBJ) {
275         win = game.bet * 5 / 2; //pay 3 to 2
276       }
277       //player wins regularly
278       else if (playerValue > dealerValue || dealerValue > 21)
279         win = game.bet * 2;
280       //tie
281       else if (playerValue == dealerValue)
282         win = game.bet;
283       //player looses
284       else
285         win = 0;
286 
287       if (doubled[gameId][h]) win *= 2;
288       totalWin += win;
289     }
290   }
291 
292   /**
293    *   calculates the value of the player's hands.
294    *   @param cards     holds the (partial) deck.
295    *          numCards  the number of cards per player hand
296    *          pSplits   the player's splits (hand index)
297    *   @return the values of the player's hands
298    **/
299   function getPlayerValues(uint8[] cards, uint8[] numCards, uint8[] pSplits) constant internal returns(uint8[5] playerValues) {
300     uint8 cardIndex;
301     uint8 splitIndex;
302     (cardIndex, splitIndex, playerValues) = playHand(0, 0, 0, playerValues, cards, numCards, pSplits);
303   }
304 
305   /**
306    *   recursively plays the player's hands.
307    *   @param hIndex        the hand index
308    *          cIndex        the index of the next card to draw
309    *          sIndex        the index of the next split, if there is any
310    *          playerValues  the values of the player's hands (not yet complete)
311    *          cards         holds the (partial) deck.
312    *          numCards      the number of cards per player hand
313    *          pSplits        the array of splits
314    *   @return the values of the player's hands and the current card index
315    **/
316   function playHand(uint8 hIndex, uint8 cIndex, uint8 sIndex, uint8[5] playerValues, uint8[] cards, uint8[] numCards, uint8[] pSplits) constant internal returns(uint8, uint8, uint8[5]) {
317     playerValues[hIndex] = cardValues[cards[cIndex] % 13];
318     cIndex = cIndex < 4 ? cIndex + 2 : cIndex + 1;
319     while (sIndex < pSplits.length && pSplits[sIndex] == hIndex) {
320       sIndex++;
321       (cIndex, sIndex, playerValues) = playHand(sIndex, cIndex, sIndex, playerValues, cards, numCards, pSplits);
322     }
323     uint8 numAces = playerValues[hIndex] == 11 ? 1 : 0;
324     uint8 card;
325     for (uint8 i = 1; i < numCards[hIndex]; i++) {
326       card = cards[cIndex] % 13;
327       playerValues[hIndex] += cardValues[card];
328       if (card == 0) numAces++;
329       cIndex = cIndex < 4 ? cIndex + 2 : cIndex + 1;
330     }
331     while (numAces > 0 && playerValues[hIndex] > 21) {
332       playerValues[hIndex] -= 10;
333       numAces--;
334     }
335     return (cIndex, sIndex, playerValues);
336   }
337 
338 
339 
340   /**
341    *   calculates the value of a dealer's hand.
342    *   @param cards     holds the (partial) deck.
343    *          numCards  the number of cards the player holds
344    *   @return the value of the dealer's hand and a flag indicating if the dealer has got a blackjack
345    **/
346   function getDealerValue(uint8[] cards, uint8 numCards) constant internal returns(uint8 dealerValue, bool bj) {
347 
348     //dealer always receives second and forth card
349     uint8 card = cards[1] % 13;
350     uint8 card2 = cards[3] % 13;
351     dealerValue = cardValues[card] + cardValues[card2];
352     uint8 numAces;
353     if (card == 0) numAces++;
354     if (card2 == 0) numAces++;
355     if (dealerValue > 21) { //2 aces,count as 12
356       dealerValue -= 10;
357       numAces--;
358     } else if (dealerValue == 21) {
359       return (21, true);
360     }
361     //take cards until value reaches 17 or more. 
362     uint8 i;
363     while (dealerValue < 17) {
364       card = cards[numCards + i + 2] % 13;
365       dealerValue += cardValues[card];
366       if (card == 0) numAces++;
367       if (dealerValue > 21 && numAces > 0) {
368         dealerValue -= 10;
369         numAces--;
370       }
371       i++;
372     }
373   }
374 
375   /**
376    * sums up the given numbers
377    * note:  player will always hold less than 100 cards
378    * @param numbers   the numbers to sum up
379    * @return the sum of the numbers
380    **/
381   function sum(uint8[] numbers) constant internal returns(uint8 s) {
382     for (uint i = 0; i < numbers.length; i++) {
383       s += numbers[i];
384     }
385   }
386 
387 }