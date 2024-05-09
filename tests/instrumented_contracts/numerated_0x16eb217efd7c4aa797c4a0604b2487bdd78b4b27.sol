1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4   address private _owner;
5 
6   event OwnershipTransferred(
7     address indexed previousOwner,
8     address indexed newOwner
9   );
10 
11   /**
12   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13   * account.
14   */
15   constructor() internal {
16     _owner = msg.sender;
17     emit OwnershipTransferred(address(0), _owner);
18   }
19 
20   /**
21   * @return the address of the owner.
22   */
23   function owner() public view returns(address) {
24     return _owner;
25   }
26 
27   /**
28   * @dev Throws if called by any account other than the owner.
29   */
30   modifier onlyOwner() {
31     require(isOwner());
32     _;
33   }
34 
35   /**
36   * @return true if `msg.sender` is the owner of the contract.
37   */
38   function isOwner() public view returns(bool) {
39     return msg.sender == _owner;
40   }
41 
42 
43   /**
44   * @dev Allows the current owner to transfer control of the contract to a newOwner.
45   * @param newOwner The address to transfer ownership to.
46   */
47   function transferOwnership(address newOwner) public onlyOwner {
48     _transferOwnership(newOwner);
49   }
50 
51   function withdrawAllEther() public onlyOwner { //to be executed on contract close
52     _owner.transfer(this.balance);
53   }
54 
55   /**
56   * @dev Transfers control of the contract to a newOwner.
57   * @param newOwner The address to transfer ownership to.
58   */
59   function _transferOwnership(address newOwner) internal {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(_owner, newOwner);
62     _owner = newOwner;
63   }
64 }
65 
66 contract blackJack is Ownable {
67 
68     mapping (uint => uint) cardsPower;
69 
70     constructor() {
71     cardsPower[0] = 11; // aces
72     cardsPower[1] = 2;
73     cardsPower[2] = 3;
74     cardsPower[3] = 4;
75     cardsPower[4] = 5;
76     cardsPower[5] = 6;
77     cardsPower[6] = 7;
78     cardsPower[7] = 8;
79     cardsPower[8] = 9;
80     cardsPower[9] = 10;
81     cardsPower[10] = 10; // j
82     cardsPower[11] = 10; // q
83     cardsPower[12] = 10; // k
84     }
85 
86 
87     uint minBet = 0.01 ether;
88     uint maxBet = 0.1 ether;
89     uint requiredHouseBankroll = 3 ether; //use math of maxBet * 300
90     uint autoWithdrawBuffer = 1 ether; // only automatically withdraw if requiredHouseBankroll is exceeded by this amount
91 
92 
93     mapping (address => bool) public isActive;
94     mapping (address => bool) public isPlayerActive;
95     mapping (address => uint) public betAmount;
96     mapping (address => uint) public gamestatus; //1 = Player Turn, 2 = Player Blackjack!, 3 = Dealer Blackjack!, 4 = Push, 5 = Game Finished. Bets resolved.
97     mapping (address => uint) public payoutAmount;
98     mapping (address => uint) dealTime;
99     mapping (address => uint) blackJackHouseProhibited;
100     mapping (address => uint[]) playerCards;
101     mapping (address => uint[]) houseCards;
102 
103 
104     mapping (address => bool) playerExists; //check whether the player has played before, if so, he must have a playerHand
105 
106     function card2PowerConverter(uint[] cards) internal view returns (uint) { //converts an array of cards to their actual power. 1 is 1 or 11 (Ace)
107         uint powerMax = 0;
108         uint aces = 0; //count number of aces
109         uint power;
110         for (uint i = 0; i < cards.length; i++) {
111              power = cardsPower[(cards[i] + 13) % 13];
112              powerMax += power;
113              if (power == 11) {
114                  aces += 1;
115              }
116         }
117         if (powerMax > 21) { //remove 10 for each ace until under 21, if possible.
118             for (uint i2=0; i2<aces; i2++) {
119                 powerMax-=10;
120                 if (powerMax <= 21) {
121                     break;
122                 }
123             }
124         }
125         return uint(powerMax);
126     }
127 
128 
129     //PRNG / RANDOM NUMBER GENERATION. REPLACE THIS AS NEEDED WITH MORE EFFICIENT RNG
130 
131     uint randNonce = 0;
132     function randgenNewHand() internal returns(uint,uint,uint) { //returns 3 numbers from 0-51.
133         //If new hand, generate 3 cards. If not, generate just 1.
134         randNonce++;
135         uint a = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 52;
136         randNonce++;
137         uint b = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 52;
138         randNonce++;
139         uint c = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 52;
140         return (a,b,c);
141       }
142 
143     function randgen() internal returns(uint) { //returns number from 0-51.
144         //If new hand, generate 3 cards. If not, generate just 1.
145         randNonce++;
146         return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 52; //range: 0-51
147       }
148 
149     modifier requireHandActive(bool truth) {
150         require(isActive[msg.sender] == truth);
151         _;
152     }
153 
154     modifier requirePlayerActive(bool truth) {
155         require(isPlayerActive[msg.sender] == truth);
156         _;
157     }
158 
159     function _play() public payable { //TEMP: Care, public.. ensure this is the public point of entry to play. Only allow 1 point of entry.
160         //check whether or not player has played before
161         if (playerExists[msg.sender]) {
162             require(isActive[msg.sender] == false);
163         }
164         else {
165             playerExists[msg.sender] = true;
166         }
167         require(msg.value >= minBet); //now check player has sent ether within betting requirements
168         require(msg.value <= maxBet); //TODO Do unit testing to ensure ETH is not deducted if previous conditional fails
169         //Now all checks have passed, the betting can proceed
170         uint a; //generate 3 cards, 2 for player, 1 for the house
171         uint b;
172         uint c;
173         (a,b,c) = randgenNewHand();
174         gamestatus[msg.sender] = 1;
175         payoutAmount[msg.sender] = 0;
176         isActive[msg.sender] = true;
177         isPlayerActive[msg.sender] = true;
178         betAmount[msg.sender] = msg.value;
179         dealTime[msg.sender] = now;
180         playerCards[msg.sender] = new uint[](0);
181         playerCards[msg.sender].push(a);
182         playerCards[msg.sender].push(b);
183         houseCards[msg.sender] = new uint[](0);
184         houseCards[msg.sender].push(c);
185         isBlackjack();
186         withdrawToOwnerCheck();
187         //TODO UPDATE playerHand correctly and also commence play utilizing game logic
188         //PLACEHOLDER FOR THE GAMBLING, DELEGATE TO OTHER FUNCTIONS SOME OF THE GAME LOGIC HERE
189         //END PLACEHOLDER, REMOVE THESE COMMENTS
190     }
191 
192     function _Hit() public requireHandActive(true) requirePlayerActive(true) { //both the hand and player turn must be active in order to hit
193         uint a=randgen(); //generate a new card
194         playerCards[msg.sender].push(a);
195         checkGameState();
196     }
197 
198     function _Stand() public requireHandActive(true) requirePlayerActive(true) { //both the hand and player turn must be active in order to stand
199         isPlayerActive[msg.sender] = false; //Player ends their turn, now dealer's turn
200         checkGameState();
201     }
202 
203     function checkGameState() internal requireHandActive(true) { //checks game state, processing it as needed. Should be called after any card is dealt or action is made (eg: stand).
204         //IMPORTANT: Make sure this function is NOT called in the event of a blackjack. Blackjack should calculate things separately
205         if (isPlayerActive[msg.sender] == true) {
206             uint handPower = card2PowerConverter(playerCards[msg.sender]);
207             if (handPower > 21) { //player busted
208                 processHandEnd(false);
209             }
210             else if (handPower == 21) { //autostand. Ensure same logic in stand is used
211                 isPlayerActive[msg.sender] = false;
212                 dealerHit();
213             }
214             else if (handPower <21) {
215                 //do nothing, player is allowed another action
216             }
217         }
218         else if (isPlayerActive[msg.sender] == false) {
219             dealerHit();
220         }
221 
222     }
223 
224     function dealerHit() internal requireHandActive(true) requirePlayerActive(false)  { //dealer hits after player ends turn legally. Nounces can be incrimented with hits until turn finished.
225         uint[] storage houseCardstemp = houseCards[msg.sender];
226         uint[] storage playerCardstemp = playerCards[msg.sender];
227 
228         uint tempCard;
229         while (card2PowerConverter(houseCardstemp) < 17) { //keep hitting on the same block for everything under 17. Same block is fine for dealer due to Nounce increase
230             //The house cannot cheat here since the player is forcing the NEXT BLOCK to be the source of randomness for all hits, and this contract cannot voluntarily skip blocks.
231             tempCard = randgen();
232             if (blackJackHouseProhibited[msg.sender] != 0) {
233                 while (cardsPower[(tempCard + 13) % 13] == blackJackHouseProhibited[msg.sender]) { //don't deal the first card as prohibited card
234                     tempCard = randgen();
235                 }
236                 blackJackHouseProhibited[msg.sender] = 0;
237                 }
238             houseCardstemp.push(tempCard);
239         }
240         //First, check if the dealer busted for an auto player win
241         if (card2PowerConverter(houseCardstemp) > 21 ) {
242             processHandEnd(true);
243         }
244         //If not, we do win logic here, since this is the natural place to do it (after dealer hitting). 3 Scenarios are possible... =>
245         if (card2PowerConverter(playerCardstemp) == card2PowerConverter(houseCardstemp)) {
246             //push, return bet
247             msg.sender.transfer(betAmount[msg.sender]);
248             payoutAmount[msg.sender]=betAmount[msg.sender];
249             gamestatus[msg.sender] = 4;
250             isActive[msg.sender] = false; //let's declare this manually only here, since processHandEnd is not called. Not needed for other scenarios.
251         }
252         else if (card2PowerConverter(playerCardstemp) > card2PowerConverter(houseCardstemp)) {
253             //player hand has more strength
254             processHandEnd(true);
255         }
256         else {
257             //only one possible scenario remains.. dealer hand has more strength
258             processHandEnd(false);
259         }
260     }
261 
262     function processHandEnd(bool _win) internal { //hand is over and win is either true or false, now process it
263         if (_win == false) {
264             //do nothing, as player simply lost
265         }
266         else if (_win == true) {
267             uint winAmount = betAmount[msg.sender] * 2;
268             msg.sender.transfer(winAmount);
269             payoutAmount[msg.sender]=winAmount;
270         }
271         gamestatus[msg.sender] = 5;
272         isActive[msg.sender] = false;
273     }
274 
275 
276     //TODO: Log an event after hand, showing outcome
277 
278     function isBlackjack() internal { //fill this function later to check both player and dealer for a blackjack after _play is called, then process
279         //4 possibilities: dealer blackjack, player blackjack (paying 3:2), both blackjack (push), no blackjack
280         //copy processHandEnd for remainder
281         blackJackHouseProhibited[msg.sender]=0; //set to 0 incase it already has a value
282         bool houseIsBlackjack = false;
283         bool playerIsBlackjack = false;
284         //First thing: For dealer check, ensure if dealer doesn't get blackjack they are prohibited from their first hit resulting in a blackjack
285         uint housePower = card2PowerConverter(houseCards[msg.sender]); //read the 1 and only house card, if it's 11 or 10, then deal temporary new card for bj check
286         if (housePower == 10 || housePower == 11) {
287             uint _card = randgen();
288             if (housePower == 10) {
289                 if (cardsPower[_card] == 11) {
290                     //dealer has blackjack, process
291                     houseCards[msg.sender].push(_card); //push card as record, since game is now over
292                     houseIsBlackjack = true;
293                 }
294                 else {
295                     blackJackHouseProhibited[msg.sender]=uint(11); //ensure dealerHit doesn't draw this powerMax
296                 }
297             }
298             else if (housePower == 11) {
299                 if (cardsPower[_card] == 10) { //all 10s
300                     //dealer has blackjack, process
301                     houseCards[msg.sender].push(_card);  //push card as record, since game is now over
302                     houseIsBlackjack = true;
303                 }
304                 else{
305                     blackJackHouseProhibited[msg.sender]=uint(10); //ensure dealerHit doesn't draw this powerMax
306                 }
307 
308             }
309         }
310         //Second thing: Check if player has blackjack
311         uint playerPower = card2PowerConverter(playerCards[msg.sender]);
312         if (playerPower == 21) {
313             playerIsBlackjack = true;
314         }
315         //Third thing: Return all four possible outcomes: Win 1.5x, Push, Loss, or Nothing (no blackjack, continue game)
316         if (playerIsBlackjack == false && houseIsBlackjack == false) {
317             //do nothing. Call this first since it's the most likely outcome
318         }
319         else if (playerIsBlackjack == true && houseIsBlackjack == false) {
320             //Player has blackjack, dealer doesn't, reward 1.5x bet (plus bet return)
321             uint winAmount = betAmount[msg.sender] * 5/2;
322             msg.sender.transfer(winAmount);
323             payoutAmount[msg.sender] = betAmount[msg.sender] * 5/2;
324             gamestatus[msg.sender] = 2;
325             isActive[msg.sender] = false;
326         }
327         else if (playerIsBlackjack == true && houseIsBlackjack == true) {
328             //Both player and dealer have blackjack. Push - return bet only
329             uint winAmountPush = betAmount[msg.sender];
330             msg.sender.transfer(winAmountPush);
331             payoutAmount[msg.sender] = winAmountPush;
332             gamestatus[msg.sender] = 4;
333             isActive[msg.sender] = false;
334         }
335         else if (playerIsBlackjack == false && houseIsBlackjack == true) {
336             //Only dealer has blackjack, player loses
337             gamestatus[msg.sender] = 3;
338             isActive[msg.sender] = false;
339         }
340     }
341 
342     function readCards() external view returns(uint[],uint[]) { //returns the cards in play, as an array of playercards, then houseCards
343         return (playerCards[msg.sender],houseCards[msg.sender]);
344     }
345 
346     function readPower() external view returns(uint, uint) { //returns current card power of player and house
347         return (card2PowerConverter(playerCards[msg.sender]),card2PowerConverter(houseCards[msg.sender]));
348     }
349 
350     function donateEther() public payable {
351         //do nothing
352     }
353 
354     function withdrawToOwnerCheck() internal { //auto call this
355         //Contract profit withdrawal to the current contract owner is disabled unless contract balance exceeds requiredHouseBankroll
356         //If this condition is  met, requiredHouseBankroll must still always remain in the contract and cannot be withdrawn.
357         uint houseBalance = address(this).balance;
358         if (houseBalance > requiredHouseBankroll + autoWithdrawBuffer) { //see comments at top of contract
359             uint permittedWithdraw = houseBalance - requiredHouseBankroll; //leave the required bankroll behind, withdraw the rest
360             address _owner = owner();
361             _owner.transfer(permittedWithdraw);
362         }
363     }
364 }