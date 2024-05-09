1 /**
2  * The Edgeless blackjack contract only allows calls from the authorized casino proxy contracts. 
3  * The proxy contract only forward moves if called by an authorized wallet owned by the Edgeless casino, but the game
4  * data has to be signed by the player to show his approval. This way, Edgeless can provide a fluid game experience
5  * without having to wait for transaction confirmations.
6  * author: Julia Altenried
7  **/
8 pragma solidity ^0.4.17;
9 
10 contract owned {
11   address public owner;
12   modifier onlyOwner {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function owned() public{
18     owner = msg.sender;
19   }
20 
21   function changeOwner(address newOwner) onlyOwner public {
22     owner = newOwner;
23   }
24 }
25 
26 contract mortal is owned {
27   function close() onlyOwner public{
28     selfdestruct(owner);
29   }
30 }
31 
32 contract casino is mortal{
33   /** the minimum bet**/
34   uint public minimumBet;
35   /** the maximum bet **/
36   uint public maximumBet;
37   /** tells if an address is authorized to call game functions **/
38   mapping(address => bool) public authorized;
39   
40   /** 
41    * constructur. initialize the contract with initial values. 
42    * @param minBet         the minimum bet
43    *        maxBet         the maximum bet
44    **/
45   function casino(uint minBet, uint maxBet) public{
46     minimumBet = minBet;
47     maximumBet = maxBet;
48   }
49 
50   /** 
51    * allows the owner to change the minimum bet
52    * @param newMin the new minimum bet
53    **/
54   function setMinimumBet(uint newMin) onlyOwner public{
55     minimumBet = newMin;
56   }
57 
58   /** 
59    * allows the owner to change the maximum bet
60    * @param newMax the new maximum bet
61    **/
62   function setMaximumBet(uint newMax) onlyOwner public{
63     maximumBet = newMax;
64   }
65 
66   
67   /**
68   * authorize a address to call game functions.
69   * @param addr the address to be authorized
70   **/
71   function authorize(address addr) onlyOwner public{
72     authorized[addr] = true;
73   }
74   
75   /**
76   * deauthorize a address to call game functions.
77   * @param addr the address to be deauthorized
78   **/
79   function deauthorize(address addr) onlyOwner public{
80     authorized[addr] = false;
81   }
82   
83   
84   /**
85   * checks if an address is authorized to call game functionality
86   **/
87   modifier onlyAuthorized{
88     require(authorized[msg.sender]);
89     _;
90   }
91 }
92 
93 contract blackjack is casino {
94 
95   /** the value of the cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K . Ace can be 1 or 11, of course. 
96    *   the value of a card can be determined by looking up cardValues[cardId%13]**/
97   uint8[13] cardValues = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
98   /** tells if the player already claimed his win **/
99   mapping(bytes32 => bool) public over;
100   /** the bets of the games in case they have been initialized before stand **/
101   mapping(bytes32 => uint) bets;
102    /** list of splits per game - length 0 in most cases **/
103   mapping(bytes32 => uint8[]) splits;
104   /** tells if a hand of a given game has been doubled **/
105   mapping(bytes32 => mapping(uint8 => bool)) doubled;
106   
107   /** notify listeners that a new round of blackjack started **/
108   event NewGame(bytes32 indexed id, bytes32 deck, bytes32 cSeed, address player, uint bet);
109   /** notify listeners of the game outcome **/
110   event Result(bytes32 indexed id, address player, uint value, bool isWin);
111   /** notify listeners that the player doubled **/
112   event Double(bytes32 indexed id, uint8 hand);
113   /** notify listeners that the player split **/
114   event Split(bytes32 indexed id, uint8 hand);
115 
116   /** 
117    * constructur. initialize the contract with a minimum bet. 
118    * @param minBet         the minimum bet
119    *        maxBet         the maximum bet
120    **/
121   function blackjack(uint minBet, uint maxBet) casino(minBet, maxBet) public{
122 
123   }
124 
125   /** 
126    *   initializes a round of blackjack. 
127    *   accepts the bet.
128    *   throws an exception if the bet is too low or a game with the given id has already been played or the bet was already paid.
129    *   @param player  the address of the player
130    *          value   the value of the bet in tokens
131    *          deck    the hash of the deck
132    *          srvSeed the hash of the server seed
133    *          cSeed   the plain client seed
134    **/
135   function initGame(address player, uint value, bytes32 deck, bytes32 srvSeed, bytes32 cSeed) onlyAuthorized  public{
136     //throw if game with id already exists. later maybe throw only if game with id is still running
137     assert(value >= minimumBet && value <= maximumBet);
138     assert(!over[srvSeed]&&bets[srvSeed]==0);//make sure the game hasn't been payed already
139     bets[srvSeed] = value;
140     assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player, value, false));
141     NewGame(srvSeed, deck, cSeed, player, value);
142   }
143 
144   /**
145    *   doubles the bet of the game with the given id if the correct amount is sent and the player did not double the hand yet.
146    *   @param player the player address
147    *          id     the game id
148    *          hand   the index of the hand being doubled
149    *          value  the number of tokens sent by the player
150    **/
151   function double(address player, bytes32 id, uint8 hand, uint value) onlyAuthorized public {
152     require(!over[id]);
153     require(checkBet(id, value));//make sure the game has been initialized and the transfered value is correct
154     require(hand <= splits[id].length && !doubled[id][hand]);//make sure the hand has not been doubled yet
155     doubled[id][hand] = true;
156     bets[id] += value;
157     assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player, value, false));
158     Double(id, hand);
159   }
160 
161   /**
162    *   splits the hands of the game with the given id if the correct amount is sent from the player address and the player
163    *   did not split yet.
164    *   @param player the player address
165    *          id     the game id
166    *          hand   the index of the hand being split
167    *          value  the number of tokens sent by the player
168    **/
169   function split(address player, bytes32 id, uint8 hand, uint value) onlyAuthorized public  {
170     require(!over[id]);
171     require(checkBet(id, value));//make sure the game has been initialized and the transfered value is correct
172     require(splits[id].length < 3);
173     splits[id].push(hand);
174     bets[id] += value;
175     assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player, value, false));
176     Split(id,hand);
177   }
178   
179   /**
180    * by surrendering half the bet is returned to the player.
181    * send the plain server seed to check if it's correct
182    * @param player the player address
183    *        seed   the server seed
184    *        bet    the original bet
185    **/
186   function surrender(address player, bytes32 seed, uint bet) onlyAuthorized public {
187     var id = keccak256(seed);
188     require(!over[id]);
189     over[id] = true;
190     if(bets[id]>0){
191       assert(bets[id]==bet);
192       assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player,bet / 2, true));
193       Result(id, player, bet / 2, true);
194     }
195     else{
196       assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player,bet / 2, false));
197       Result(id, player, bet / 2, false);
198     }
199   }
200 
201   /** 
202    * first checks if deck and the player's number of cards are correct, then checks if the player won and if so, sends the win.
203    * @param player the player address
204    *        deck      the partial deck
205    *        seed      the plain server seed
206    *        numCards  the number of cards per hand
207    *        splits    the array of splits
208    *        doubled   the array indicating if a hand was doubled
209    *        bet       the original bet
210    *        deckHash  the hash of the deck (for verification and logging)
211    *        cSeed     the client seed (for logging)
212    **/
213   function stand(address player, uint8[] deck, bytes32 seed, uint8[] numCards, uint8[] splits, bool[] doubled,uint bet, bytes32 deckHash, bytes32 cSeed) onlyAuthorized public {
214     bytes32 gameId;
215     gameId = keccak256(seed);
216     assert(!over[gameId]);
217     assert(splits.length == numCards.length - 1);
218     over[gameId] = true;
219     assert(checkDeck(deck, seed, deckHash));//plausibility check
220     
221     var (win,loss) = determineOutcome(deck, numCards, splits, doubled, bet);
222     
223     if(bets[gameId] > 0){//initGame method called before
224       assert(checkBet(gameId, bet));
225       win += bets[gameId];//pay back the bet
226     }
227     else
228       NewGame(gameId, deckHash, cSeed, player, bet);
229     
230     if (win > loss){
231       assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player, win-loss, true));
232       Result(gameId, player, win-loss, true); 
233     }  
234     else if(loss > win){//shift balance from the player to the casino
235       assert(msg.sender.call(bytes4(keccak256("shift(address,uint256,bool)")),player, loss-win, false));
236       Result(gameId, player, loss-win, false); 
237     }
238     else
239       Result(gameId, player, 0, false);
240      
241   }
242 
243   /**
244    * check if deck and casino seed are correct.
245    * @param deck      the partial deck
246    *        seed      the server seed
247    *        deckHash  the hash of the deck
248    * @return true if correct
249    **/
250   function checkDeck(uint8[] deck, bytes32 seed, bytes32 deckHash) constant public returns(bool correct) {
251     if (keccak256(convertToBytes(deck), seed) != deckHash) return false;
252     return true;
253   }
254 
255   /**
256    * converts an uint8 array to bytes
257    * @param byteArray the uint8 array to be converted
258    * @return the bytes
259    **/
260   function convertToBytes(uint8[] byteArray) internal constant returns(bytes b) {
261     b = new bytes(byteArray.length);
262     for (uint8 i = 0; i < byteArray.length; i++)
263       b[i] = byte(byteArray[i]);
264   }
265   
266   /**
267    * checks if the correct amount was paid for the initial bet + splits and doubles.
268    * @param gameId the game id
269    *        bet    the bet
270    * @return true if correct
271    * */
272   function checkBet(bytes32 gameId, uint bet) internal constant returns (bool correct){
273     uint factor = splits[gameId].length + 1;
274     for(uint8 i = 0; i < splits[gameId].length+1; i++){
275       if(doubled[gameId][i]) factor++;
276     }
277     return bets[gameId] == bet * factor;
278   }
279 
280   /**
281    * determines the outcome of a game and returns the win. 
282    * in case of a loss, win is 0.
283    * @param cards     the cards / partial deck
284    *        numCards  the number of cards per hand
285    *        splits    the array of splits
286    *        doubled   the array indicating if a hand was doubled
287    *        bet       the original bet
288    * @return the total win of all hands
289    **/
290   function determineOutcome(uint8[] cards, uint8[] numCards, uint8[] splits, bool[] doubled, uint bet) constant public returns(uint totalWin, uint totalLoss) {
291 
292     var playerValues = getPlayerValues(cards, numCards, splits);
293     var (dealerValue, dealerBJ) = getDealerValue(cards, sum(numCards));
294     uint win;
295     uint loss;
296     for (uint8 h = 0; h < numCards.length; h++) {
297       uint8 playerValue = playerValues[h];
298       //bust if value > 21
299       if (playerValue > 21){
300         win = 0;
301         loss = bet;
302       } 
303       //player blackjack but no dealer blackjack
304       else if (numCards.length == 1 && playerValue == 21 && numCards[h] == 2 && !dealerBJ) {
305         win = bet * 3 / 2; //pay 3 to 2
306         loss = 0;
307       }
308       //player wins regularly
309       else if (playerValue > dealerValue || dealerValue > 21){
310         win = bet;
311         loss = 0;
312       }
313       //tie
314       else if (playerValue == dealerValue){
315         win = 0;
316         loss = 0;
317       }
318       //player looses
319       else{
320         win = 0;
321         loss = bet;
322       }
323 
324       if (doubled[h]){
325         win *= 2;
326         loss *= 2;
327       } 
328       totalWin += win;
329       totalLoss += loss;
330     }
331   }
332 
333   /**
334    *   calculates the value of the player's hands.
335    *   @param cards     holds the (partial) deck.
336    *          numCards  the number of cards per player hand
337    *          pSplits   the player's splits (hand index)
338    *   @return the values of the player's hands
339    **/
340   function getPlayerValues(uint8[] cards, uint8[] numCards, uint8[] pSplits) constant internal returns(uint8[5] playerValues) {
341     uint8 cardIndex;
342     uint8 splitIndex;
343     (cardIndex, splitIndex, playerValues) = playHand(0, 0, 0, playerValues, cards, numCards, pSplits);
344   }
345 
346   /**
347    *   recursively plays the player's hands.
348    *   @param hIndex        the hand index
349    *          cIndex        the index of the next card to draw
350    *          sIndex        the index of the next split, if there is any
351    *          playerValues  the values of the player's hands (not yet complete)
352    *          cards         holds the (partial) deck.
353    *          numCards      the number of cards per player hand
354    *          pSplits        the array of splits
355    *   @return the values of the player's hands and the current card index
356    **/
357   function playHand(uint8 hIndex, uint8 cIndex, uint8 sIndex, uint8[5] playerValues, uint8[] cards, uint8[] numCards, uint8[] pSplits) constant internal returns(uint8, uint8, uint8[5]) {
358     playerValues[hIndex] = cardValues[cards[cIndex] % 13];
359     cIndex = cIndex < 4 ? cIndex + 2 : cIndex + 1;
360     while (sIndex < pSplits.length && pSplits[sIndex] == hIndex) {
361       sIndex++;
362       (cIndex, sIndex, playerValues) = playHand(sIndex, cIndex, sIndex, playerValues, cards, numCards, pSplits);
363     }
364     uint8 numAces = playerValues[hIndex] == 11 ? 1 : 0;
365     uint8 card;
366     for (uint8 i = 1; i < numCards[hIndex]; i++) {
367       card = cards[cIndex] % 13;
368       playerValues[hIndex] += cardValues[card];
369       if (card == 0) numAces++;
370       cIndex = cIndex < 4 ? cIndex + 2 : cIndex + 1;
371     }
372     while (numAces > 0 && playerValues[hIndex] > 21) {
373       playerValues[hIndex] -= 10;
374       numAces--;
375     }
376     return (cIndex, sIndex, playerValues);
377   }
378 
379 
380 
381   /**
382    *   calculates the value of a dealer's hand.
383    *   @param cards     holds the (partial) deck.
384    *          numCards  the number of cards the player holds
385    *   @return the value of the dealer's hand and a flag indicating if the dealer has got a blackjack
386    **/
387   function getDealerValue(uint8[] cards, uint8 numCards) constant internal returns(uint8 dealerValue, bool bj) {
388 
389     //dealer always receives second and forth card
390     uint8 card = cards[1] % 13;
391     uint8 card2 = cards[3] % 13;
392     dealerValue = cardValues[card] + cardValues[card2];
393     uint8 numAces;
394     if (card == 0) numAces++;
395     if (card2 == 0) numAces++;
396     if (dealerValue > 21) { //2 aces,count as 12
397       dealerValue -= 10;
398       numAces--;
399     } else if (dealerValue == 21) {
400       return (21, true);
401     }
402     //take cards until value reaches 17 or more. 
403     uint8 i;
404     while (dealerValue < 17) {
405       card = cards[numCards + i + 2] % 13;
406       dealerValue += cardValues[card];
407       if (card == 0) numAces++;
408       if (dealerValue > 21 && numAces > 0) {
409         dealerValue -= 10;
410         numAces--;
411       }
412       i++;
413     }
414   }
415 
416   /**
417    * sums up the given numbers
418    * note: no overflow possible as player will always hold less than 100 cards
419    * @param numbers   the numbers to sum up
420    * @return the sum of the numbers
421    **/
422   function sum(uint8[] numbers) constant internal returns(uint8 s) {
423     for (uint i = 0; i < numbers.length; i++) {
424       s += numbers[i];
425     }
426   }
427 
428 }