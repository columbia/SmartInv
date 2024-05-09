1 /**
2  * Early prototype of the Edgeless Black Jack contract. 
3  * Allows an user to initialize a round of black jack, withdraw the win in case he won or both on the same time,
4  * while verifying the game data.
5  * author: Julia Altenried
6  **/
7 pragma solidity ^0.4.10;
8 
9 contract owned {
10   address public owner; 
11   modifier onlyOwner {
12       if (msg.sender != owner)
13           throw;
14       _;
15   }
16   function owned() { owner = msg.sender; }
17   function changeOwner(address newOwner) onlyOwner{
18     owner = newOwner;
19   }
20 }
21 
22 contract mortal is owned{
23   function close() onlyOwner {
24         selfdestruct(owner);
25     }
26 }
27 contract blackjack is mortal {
28   struct Game {
29     /** the game id is used to reference the game **/
30     uint id;
31     /** the hash of the (partial) deck **/
32     bytes32 deck;
33     /** the hash of the casino seed used for randomness generation and deck-hashing**/
34     bytes32 seed;
35     /** the player address **/
36     address player;
37     /** the bet **/
38     uint bet;
39     /** the timestamp of the start of the game, game ends automatically after certain time interval passed **/
40     uint start;
41   }
42 
43   /** the value of the cards: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K . Ace can be 1 or 11, of course. 
44    *   the value of a card can be determined by looking up cardValues[cardId%13]**/
45   uint8[13] cardValues = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
46 
47   /** use the game id to reference the games **/
48   mapping(uint => Game) games;
49   /** the minimum bet**/
50   uint public minimumBet;
51   /** the maximum bet **/
52   uint public maximumBet;
53   /** the address which signs the number of cards dealt **/
54   address public signer;
55   
56   /** notify listeners that a new round of blackjack started **/
57   event NewGame(uint indexed id, bytes32 deck, bytes32 srvSeed, bytes32 cSeed, address player, uint bet);
58   /** notify listeners of the game outcome **/
59   event Result(uint indexed id, address player, uint win);
60   /** notify listeners that an error occurred**/
61   event Error(uint errorCode);
62 
63   /** constructur. initialize the contract with a minimum bet and a signer address. **/
64   function blackjack(uint minBet, uint maxBet, address signerAddress) payable{
65     minimumBet = minBet;
66     maximumBet = maxBet;
67     signer = signerAddress;
68   }
69 
70   /** 
71    *   initializes a round of blackjack with an id, the hash of the (partial) deck and the hash of the server seed. 
72    *   accepts the bet.
73    *   throws an exception if the bet is too low or a game with the given id already exists.
74    **/
75   function initGame(uint id, bytes32 deck, bytes32 srvSeed, bytes32 cSeed) payable {
76     //throw if bet is too low or too high
77     if (msg.value < minimumBet || msg.value > maximumBet) throw;
78     //throw if user could not be paiud out in case of suited blackjack
79     if (msg.value * 3 > address(this).balance) throw;
80     _initGame(id, deck, srvSeed, cSeed, msg.value);
81   }
82 
83   /** 
84    * first checks if deck and the player's number of cards are correct, then checks if the player won and if so, sends the win.
85    **/
86   function stand(uint gameId, uint8[] deck, bytes32 seed, uint8 numCards, uint8 v, bytes32 r, bytes32 s) {
87     uint win = _stand(gameId,deck,seed,numCards,v,r,s, true);
88   }
89   
90   /**
91   *   first stands, then inits a new game with only one transaction
92   **/
93   function standAndRebet(uint oldGameId, uint8[] oldDeck, bytes32 oldSeed, uint8 numCards, uint8 v, bytes32 r, bytes32 s, uint newGameId, bytes32 newDeck, bytes32 newSrvSeed, bytes32 newCSeed){
94     uint win = _stand(oldGameId,oldDeck,oldSeed,numCards,v,r,s, false);
95     uint bet = games[oldGameId].bet;
96     if(win >= bet){
97       _initGame(newGameId, newDeck, newSrvSeed, newCSeed, bet);
98       win-=bet;
99     }
100     if(win>0 && !msg.sender.send(win)){//pay the rest
101       throw;
102     }
103   }
104   
105   /** 
106    *   internal function to initialize a round of blackjack with an id, the hash of the (partial) deck, 
107    *   the hash of the server seed and the bet. 
108    **/
109   function _initGame(uint id, bytes32 deck, bytes32 srvSeed, bytes32 cSeed, uint bet) internal{
110     //throw if game with id already exists. later maybe throw only if game with id is still running
111     if (games[id].player != 0x0) throw;
112     games[id] = Game(id, deck, srvSeed, msg.sender, bet, now);
113     NewGame(id, deck, srvSeed, cSeed, msg.sender, bet);
114   }
115   
116   /**
117   * first checks if deck and the player's number of cards are correct, then checks if the player won and if so, calculates the win.
118   **/
119   function _stand(uint gameId, uint8[] deck, bytes32 seed, uint8 numCards, uint8 v, bytes32 r, bytes32 s, bool payout) internal returns(uint win){
120     Game game = games[gameId];
121     uint start = game.start;
122     game.start = 0; //make sure outcome isn't determined a second time while win payment is still pending -> prevent double payout
123     if(msg.sender!=game.player){
124       Error(1);
125       return 0;
126     }
127     if(!checkDeck(gameId, deck, seed)){
128       Error(2);
129       return 0;
130     }
131     if(!checkNumCards(gameId, numCards, v, r, s)){
132       Error(3);
133       return 0;
134     }
135     if(start + 1 hours < now){
136       Error(4);
137       return 0;
138     }
139     
140     win = determineOutcome(gameId, deck, numCards);
141     if (payout && win > 0 && !msg.sender.send(win)){
142       Error(5);
143       game.start = start;
144       return 0;
145     }
146     Result(gameId, msg.sender, win);
147   }
148   
149   /**
150   * check if deck and casino seed are correct.
151   **/
152   function checkDeck(uint gameId, uint8[] deck, bytes32 seed) constant returns (bool correct){
153     if(sha3(seed) != games[gameId].seed) return false;
154     if(sha3(convertToBytes(deck), seed) != games[gameId].deck) return false;
155     return true;
156   }
157   
158   function convertToBytes(uint8[] byteArray) returns (bytes b){
159     b = new bytes(byteArray.length);
160     for(uint8 i = 0; i < byteArray.length; i++)
161       b[i] = byte(byteArray[i]);
162   }
163   
164   /**
165   * check if user and casino agree on the number of cards
166   **/
167   function checkNumCards(uint gameId, uint8 numCards, uint8 v, bytes32 r, bytes32 s) constant returns (bool correct){
168     bytes32 msgHash = sha3(gameId,numCards);
169     return ecrecover(msgHash, v, r, s) == signer;
170   }
171 
172   /**
173    * determines the outcome of a game and returns the win. 
174    * in case of a loss, win is 0.
175    **/
176   function determineOutcome(uint gameId, uint8[] cards, uint8 numCards) constant returns(uint win) {
177     uint8 playerValue = getPlayerValue(cards, numCards);
178     //bust if value > 21
179     if (playerValue > 21) return 0;
180 
181     var (dealerValue, dealerBJ) = getDealerValue(cards, numCards);
182 
183     //player wins
184     if (playerValue == 21 && numCards == 2 && !dealerBJ){ //player blackjack but no dealer blackjack
185       if(isSuited(cards[0], cards[2]))
186         return games[gameId].bet * 3; //pay 2 to 1
187       else
188         return games[gameId].bet * 5 / 2; 
189     }
190     else if(playerValue == 21 && numCards == 5) //automatic win on 5-card 21
191       return games[gameId].bet * 2;
192     else if (playerValue > dealerValue || dealerValue > 21)
193       return games[gameId].bet * 2;
194     //tie
195     else if (playerValue == dealerValue)
196       return games[gameId].bet;
197     //player loses
198     else
199       return 0;
200 
201   }
202 
203   /**
204    *   calculates the value of a player's hand.
205    *   cards: holds the (partial) deck.
206    *   numCards: the number of cards the player holds
207    **/
208   function getPlayerValue(uint8[] cards, uint8 numCards) constant internal returns(uint8 playerValue) {
209     //player receives first and third card and  all further cards after the 4. until he stands 
210     //determine value of the player's hand
211     uint8 numAces;
212     uint8 card;
213     for (uint8 i = 0; i < numCards + 2; i++) {
214       if (i != 1 && i != 3) { //1 and 3 are dealer cards
215         card = cards[i] %13;
216         playerValue += cardValues[card];
217         if (card == 0) numAces++;
218       }
219 
220     }
221     while (numAces > 0 && playerValue > 21) {
222       playerValue -= 10;
223       numAces--;
224     }
225   }
226 
227 
228   /**
229    *   calculates the value of a dealer's hand.
230    *   cards: holds the (partial) deck.
231    *   numCards: the number of cards the player holds
232    **/
233   function getDealerValue(uint8[] cards, uint8 numCards) constant internal returns(uint8 dealerValue, bool bj) {
234     
235     //dealer always receives second and forth card
236     uint8 card  = cards[1] % 13;
237     uint8 card2 = cards[3] % 13;
238     dealerValue = cardValues[card] + cardValues[card2];
239     uint8 numAces;
240     if (card == 0) numAces++;
241     if (card2 == 0) numAces++;
242     if (dealerValue > 21) { //2 aces,count as 12
243       dealerValue -= 10;
244       numAces--;
245     }
246     else if(dealerValue==21){
247       return (21, true);
248     }
249     //take cards until value reaches 17 or more. 
250     uint8 i;
251     while (dealerValue < 17) {
252       card = cards[numCards + i + 2] % 13 ;
253       dealerValue += cardValues[card];
254       if (card == 0) numAces++;
255       if (dealerValue > 21 && numAces > 0) {
256         dealerValue -= 10;
257         numAces--;
258       }
259       i++;
260     }
261   }
262   
263   /** determines if two cards have the same color **/
264   function isSuited(uint8 card1, uint8 card2) internal returns(bool){
265     return card1/13 == card2/13;
266   }
267   
268   /** the fallback function can be used to send ether to increase the casino bankroll **/
269   function() payable onlyOwner{
270   }
271   
272   /** allows the owner to withdraw funds **/
273   function withdraw(uint amount) onlyOwner{
274     if(amount < address(this).balance)
275       if(!owner.send(amount))
276         Error(6);
277   }
278   
279   /** allows the owner to change the signer address **/
280   function setSigner(address signerAddress) onlyOwner{
281     signer = signerAddress;
282   }
283   
284   /** allows the owner to change the minimum bet **/
285   function setMinimumBet(uint newMin) onlyOwner{
286     minimumBet = newMin;
287   }
288   
289   /** allows the owner to change the mximum **/
290   function setMaximumBet(uint newMax) onlyOwner{
291     minimumBet = newMax;
292   }
293 }