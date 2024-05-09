1 pragma solidity ^0.4.24;
2 
3 /* SNAILTHRONE
4 
5 // SnailFarm + Pyramid + Fomo
6 
7 // Buy and sell snails, pyramid tokens, directly from the contract
8 // Snail holders receive proportional dividends from buys and hatches
9 // Token price correlates with snail max supply
10 
11 // Snails produce eggs, at a rate of 8% per day
12 // Up to a maximum equal to the amount of snails the player owns
13 // Players can hatch these eggs to turn them into more tokens
14 // Hatching comes at half the cost of buying tokens
15 // Players can also sacrifice their eggs to the FrogKing for an ETH reward
16 
17 // On buy, incoming ETH is distributed as such:
18 // 50% saved for the SnailPot (token price on sale)
19 // 20% in divs
20 // 20% go to the FrogPot
21 // 2% is given to the current Pharaoh
22 // 2% goes to the SnailGod pot
23 // 6% goes to the referral. lacking ref, it goes to the SnailGod pot
24 
25 // On hatch, incoming ETH is distributed as follows:
26 // 40% in divs
27 // 40% go to the FrogPot
28 // 4% is given to the current Pharaoh
29 // 16% goes to the SnailGod pot
30 
31 // SNAILPOT 
32 // Snails can be sold to the SnailPot for ether 
33 // Price per snail is 50% of the current buy price 
34 // No more than 10% of the SnailPot can be drained in one sale 
35 
36 // FROGPOT
37 // Feeding eggs to the frogking grants a reward 
38 // Ether earned = frogpot * eggs fed / total snails
39 
40 // SNAILGOD
41 // The ultimate reward of the game, on a 24 hours timer
42 // Sacrifice a minimum of 40 snails to become the Pharaoh
43 // While the Pharaoh sits on the throne, he receives 2% ETH of every buy
44 // A successful sacrifice will bump the timer back up by 8 minutes
45 // and set the minimum snail requirement to 40 + this sacrifice
46 // This number lowers back down to 40 over time
47 // Once the timer hits 0, whoever holds the Pharaoh title ascends to godhood
48 // The SnailGod can instantly claim 50% of the SnailGod pot
49 // Timer resets at 24 hours, minimum sacrifice resets at 40 snails 
50 // and the previous Pharaoh takes the throne until a contender sacrifices enough snails
51 
52 // REFERRALS
53 // Unlocked by owning at least 300 snails
54 // Every buy through a referral link gives 6% to the referred address
55 // Addresses aren't bound to their referral link
56 // Referrals don't profit from hatching eggs
57 
58 */
59 
60 contract SnailThrone {
61     using SafeMath for uint;
62     
63     /* Events */
64     
65     event WithdrewEarnings (address indexed player, uint ethreward);
66     event ClaimedDivs (address indexed player, uint ethreward);
67     event BoughtSnail (address indexed player, uint ethspent, uint snail);
68     event SoldSnail (address indexed player, uint ethreward, uint snail);
69     event HatchedSnail (address indexed player, uint ethspent, uint snail);
70     event FedFrogking (address indexed player, uint ethreward, uint egg);
71     event Ascended (address indexed player, uint ethreward, uint indexed round);
72     event BecamePharaoh (address indexed player, uint indexed round);
73     event NewDivs (uint ethreward);
74     
75     /* Constants */
76     
77     uint256 public GOD_TIMER_START      = 86400; //seconds, or 24 hours
78 	uint256 public PHARAOH_REQ_START    = 40; //number of snails to become pharaoh
79     uint256 public GOD_TIMER_INTERVAL   = 12; //seconds to remove one snail from req
80 	uint256 public GOD_TIMER_BOOST		= 480; //seconds added to timer with new pharaoh
81     uint256 public TIME_TO_HATCH_1SNAIL = 1080000; //8% daily
82     uint256 public TOKEN_PRICE_FLOOR    = 0.00002 ether; //4 zeroes
83     uint256 public TOKEN_PRICE_MULT     = 0.00000000001 ether; //10 zeroes
84     uint256 public TOKEN_MAX_BUY        = 4 ether; //max allowed eth in one buy transaction
85     uint256 public SNAIL_REQ_REF        = 300; //number of snails for ref link to be active
86 	
87     /* Variables */
88     
89     //Becomes true one time to start the game
90     bool public gameStarted             = false;
91     
92     //Used to ensure a proper game start
93     address public gameOwner;
94     
95     //SnailGod round, amount, timer
96     uint256 public godRound             = 0;
97     uint256 public godPot               = 0;
98     uint256 public godTimer             = 0;
99     
100     //Current Pharaoh
101     address public pharaoh;
102     
103     //Last time throne was claimed or pharaohReq was computed
104     uint256 public lastClaim;
105     
106     //Snails required to become the Pharaoh
107     uint256 public pharaohReq           = PHARAOH_REQ_START;
108     
109     //Total number of snail tokens
110     uint256 public maxSnail             = 0;
111     
112     //Egg sell fund
113     uint256 public frogPot              = 0;
114     
115     //Token sell fund
116     uint256 public snailPot             = 0;
117     
118     //Current divs per snail
119     uint256 public divsPerSnail         = 0;
120     	
121     /* Mappings */
122     
123     mapping (address => uint256) public hatcherySnail;
124     mapping (address => uint256) public lastHatch;
125     mapping (address => uint256) public playerEarnings;
126     mapping (address => uint256) public claimedDivs;
127 	
128     /* Functions */
129     
130     // ACTIONS
131     
132     // Constructor
133     // Sets msg.sender as gameOwner to start the game properly
134     
135     constructor() public {
136         gameOwner = msg.sender;
137     }
138 
139     // StartGame
140     // Initialize godTimer
141     // Set pharaoh and lastPharaoh as gameOwner
142     // Buy tokens for value of message
143     
144     function StartGame() public payable {
145         require(gameStarted == false);
146         require(msg.sender == gameOwner);
147         
148         godTimer = now + GOD_TIMER_START;
149         godRound = 1;
150         gameStarted = true;
151         pharaoh = gameOwner;
152         lastClaim = now;
153         BuySnail(msg.sender);
154     }
155     
156     // WithdrawEarnings
157     // Sends all player ETH earnings to his wallet
158     
159     function WithdrawEarnings() public {
160         require(playerEarnings[msg.sender] > 0);
161         
162         uint256 _amount = playerEarnings[msg.sender];
163         playerEarnings[msg.sender] = 0;
164         msg.sender.transfer(_amount);
165         
166         emit WithdrewEarnings(msg.sender, _amount);
167     }
168     
169     // ClaimDivs
170     // Sends player dividends to his playerEarnings
171     // Adjusts claimable dividends
172     
173     function ClaimDivs() public {
174         
175         uint256 _playerDivs = ComputeMyDivs();
176         
177         if(_playerDivs > 0) {
178             //Add new divs to claimed divs
179             claimedDivs[msg.sender] = claimedDivs[msg.sender].add(_playerDivs);
180             
181             //Send divs to playerEarnings
182             playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_playerDivs);
183             
184             emit ClaimedDivs(msg.sender, _playerDivs);
185         }
186     }
187     
188     // BuySnail 
189     
190     function BuySnail(address _ref) public payable {
191         require(gameStarted == true, "game hasn't started yet");
192         require(tx.origin == msg.sender, "contracts not allowed");
193         require(msg.value <= TOKEN_MAX_BUY, "maximum buy = 4 ETH");
194         
195         //Calculate price and resulting snails
196         uint256 _snailsBought = ComputeBuy(msg.value);
197         
198         //Adjust player claimed divs
199         claimedDivs[msg.sender] = claimedDivs[msg.sender].add(_snailsBought.mul(divsPerSnail));
200         
201         //Change maxSnail before new div calculation
202         maxSnail = maxSnail.add(_snailsBought);
203         
204         //Divide incoming ETH
205         PotSplit(msg.value, _ref, true);
206         
207         //Set last hatch to current timestamp
208         lastHatch[msg.sender] = now;
209         
210         //Add player snails
211         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].add(_snailsBought);
212         
213         emit BoughtSnail(msg.sender, msg.value, _snailsBought);
214     }
215     
216     // SellSnail
217     
218     function SellSnail(uint256 _tokensSold) public {
219         require(gameStarted == true, "game hasn't started yet");
220         require(hatcherySnail[msg.sender] >= _tokensSold, "not enough snails to sell");
221         
222         //Call ClaimDivs so ETH isn't blackholed
223         ClaimDivs();
224 
225         //Check token price, sell price is half of current buy price
226         uint256 _tokenSellPrice = ComputeTokenPrice();
227         _tokenSellPrice = _tokenSellPrice.div(2);
228         
229         //Check maximum ETH that can be obtained = 10% of SnailPot
230         uint256 _maxEth = snailPot.div(10);
231         
232         //Check maximum amount of tokens that can be sold
233         uint256 _maxTokens = _maxEth.div(_tokenSellPrice);
234         
235         //Check if player tried to sell too many tokens
236         if(_tokensSold > _maxTokens) {
237             _tokensSold = _maxTokens;
238         }
239         
240         //Calculate sell reward, tokens * price per token
241         uint256 _sellReward = _tokensSold.mul(_tokenSellPrice);
242         
243         //Remove reserve ETH 
244         snailPot = snailPot.sub(_sellReward);
245         
246         //Remove tokens
247         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].sub(_tokensSold);
248         maxSnail = maxSnail.sub(_tokensSold);
249         
250         //Adjust player claimed divs
251         claimedDivs[msg.sender] = claimedDivs[msg.sender].sub(divsPerSnail.mul(_tokensSold));
252         
253         //Give ETH to player 
254         playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_sellReward);
255         
256         emit SoldSnail(msg.sender, _sellReward, _tokensSold);
257     }
258     
259     // HatchEgg
260     // Turns player eggs into snails
261     // Costs half the ETH of a normal buy
262     
263     function HatchEgg() public payable {
264         require(gameStarted == true, "game hasn't started yet");
265         require(msg.value > 0, "need ETH to hatch eggs");
266         
267         //Check how many eggs the ether sent can pay for
268         uint256 _tokenPrice = ComputeTokenPrice().div(2);
269         uint256 _maxHatch = msg.value.div(_tokenPrice);
270         
271         //Check number of eggs to hatch
272         uint256 _newSnail = ComputeMyEggs(msg.sender);
273         
274         //Multiply by token price
275         uint256 _snailPrice = _tokenPrice.mul(_newSnail);
276         
277         //Refund any extra ether
278         uint256 _ethUsed = msg.value;
279                 
280         if (msg.value > _snailPrice) {
281             uint256 _refund = msg.value.sub(_snailPrice);
282             playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_refund);
283             _ethUsed = _snailPrice;
284         }
285         
286         //Adjust new snail amount if not enough ether 
287         if (msg.value < _snailPrice) {
288             _newSnail = _maxHatch;
289         }
290         
291         //Adjust player divs
292         claimedDivs[msg.sender] = claimedDivs[msg.sender].add(_newSnail.mul(divsPerSnail));
293         
294         //Change maxSnail before div calculation
295         maxSnail = maxSnail.add(_newSnail);
296         
297         //Divide incoming ETH 
298         PotSplit(_ethUsed, msg.sender, false);
299         
300         //Add new snails
301         lastHatch[msg.sender] = now;
302         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].add(_newSnail);
303         
304         emit HatchedSnail(msg.sender, _ethUsed, _newSnail);
305     }
306     
307     // PotSplit
308     // Called on buy and hatch
309     
310     function PotSplit(uint256 _msgValue, address _ref, bool _buy) private {
311         
312         //On token buy, 50% of the ether goes to snailpot
313         //On hatch, no ether goes to the snailpot
314         uint256 _eth = _msgValue;
315         
316         if (_buy == true) {
317             _eth = _msgValue.div(2);
318             snailPot = snailPot.add(_eth);
319         }
320         
321         //20% distributed as divs (40% on hatch)
322         divsPerSnail = divsPerSnail.add(_eth.mul(2).div(5).div(maxSnail));
323         
324         //20% to FrogPot (40% on hatch)
325         frogPot = frogPot.add(_eth.mul(2).div(5));
326         
327         //2% to Pharaoh (4% on hatch)
328         playerEarnings[pharaoh] = playerEarnings[pharaoh].add(_eth.mul(2).div(50));
329         
330         //2% to SnailGod pot (4% on hatch)
331         godPot = godPot.add(_eth.mul(2).div(50));
332         
333         //Check for referrals (300 snails required)
334         //Give 6% to referrer if there is one
335         //Else give 6% to SnailGod pot
336         //Always give 12% to SnailGod pot on hatch
337         if (_ref != msg.sender && hatcherySnail[_ref] >= SNAIL_REQ_REF) {
338             playerEarnings[_ref] = playerEarnings[_ref].add(_eth.mul(6).div(50));
339         } else {
340             godPot = godPot.add(_eth.mul(6).div(50));
341         }
342     }
343     
344     // FeedEgg
345     // Sacrifices the player's eggs to the FrogPot
346     // Gives ETH in return
347     
348     function FeedEgg() public {
349         require(gameStarted == true, "game hasn't started yet");
350         
351         //Check number of eggs to hatch
352         uint256 _eggsUsed = ComputeMyEggs(msg.sender);
353         
354         //Remove eggs
355         lastHatch[msg.sender] = now;
356         
357         //Calculate ETH earned
358         uint256 _reward = _eggsUsed.mul(frogPot).div(maxSnail);
359         frogPot = frogPot.sub(_reward);
360         playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_reward);
361         
362         emit FedFrogking(msg.sender, _reward, _eggsUsed);
363     }
364     
365     // AscendGod
366     // Distributes SnailGod pot to winner, restarts timer 
367     
368     function AscendGod() public {
369 		require(gameStarted == true, "game hasn't started yet");
370         require(now >= godTimer, "pharaoh hasn't ascended yet");
371         
372         //Reset timer and start new round 
373         godTimer = now + GOD_TIMER_START;
374         pharaohReq = PHARAOH_REQ_START;
375         godRound = godRound.add(1);
376         
377         //Calculate and give reward
378         uint256 _godReward = godPot.div(2);
379         godPot = godPot.sub(_godReward);
380         playerEarnings[pharaoh] = playerEarnings[pharaoh].add(_godReward);
381         
382         emit Ascended(pharaoh, _godReward, godRound);
383         
384         //msg.sender becomes pharaoh 
385         pharaoh = msg.sender;
386     }
387 
388     // BecomePharaoh
389     // Sacrifices snails to become the Pharaoh
390     
391     function BecomePharaoh(uint256 _snails) public {
392         require(gameStarted == true, "game hasn't started yet");
393         require(hatcherySnail[msg.sender] >= _snails, "not enough snails in hatchery");
394         
395         //Run end round function if round is over
396         if(now >= godTimer) {
397             AscendGod();
398         }
399         
400         //Call ClaimDivs so ETH isn't blackholed
401         ClaimDivs();
402         
403         //Check number of snails to remove from pharaohReq
404         uint256 _snailsToRemove = ComputePharaohReq();
405         
406         //Save claim time to lower number of snails later
407         lastClaim = now;
408         
409         //Adjust pharaohReq
410         if(pharaohReq < _snailsToRemove){
411             pharaohReq = PHARAOH_REQ_START;
412         } else {
413             pharaohReq = pharaohReq.sub(_snailsToRemove);
414             if(pharaohReq < PHARAOH_REQ_START){
415                 pharaohReq = PHARAOH_REQ_START;
416             }
417         }
418         
419         //Make sure player fits requirement
420         if(_snails >= pharaohReq) {
421             
422         //Remove snails
423             maxSnail = maxSnail.sub(_snails);
424             hatcherySnail[msg.sender] = hatcherySnail[msg.sender].sub(_snails);
425             
426         //Adjust msg.sender claimed dividends
427             claimedDivs[msg.sender] = claimedDivs[msg.sender].sub(_snails.mul(divsPerSnail));
428         
429         //Add 8 minutes to timer
430             godTimer = godTimer.add(GOD_TIMER_BOOST);
431             
432         //pharaohReq becomes the amount of snails sacrificed + 40
433             pharaohReq = _snails.add(PHARAOH_REQ_START);
434 
435         //msg.sender becomes new Pharaoh
436             pharaoh = msg.sender;
437             
438             emit BecamePharaoh(msg.sender, godRound);
439         }
440     }
441     
442     // fallback function
443     // Distributes sent ETH as dividends
444     
445     function() public payable {
446         divsPerSnail = divsPerSnail.add(msg.value.div(maxSnail));
447         
448         emit NewDivs(msg.value);
449     }
450     
451     // VIEW
452     
453     // ComputePharaohReq
454     // Returns number of snails to remove from pharaohReq
455     // Snail requirement lowers by 1 every 12 seconds
456 
457     function ComputePharaohReq() public view returns(uint256) {
458         uint256 _timeLeft = now.sub(lastClaim);
459         uint256 _req = _timeLeft.div(GOD_TIMER_INTERVAL);
460         return _req;
461     }
462 
463     // ComputeTokenPrice
464     // Returns ETH required to buy one snail
465     // 1 snail = (T_P_FLOOR + (T_P_MULT * total amount of snails)) eth
466     
467     function ComputeTokenPrice() public view returns(uint256) {
468         return TOKEN_PRICE_FLOOR.add(TOKEN_PRICE_MULT.mul(maxSnail));
469     }
470     
471     // ComputeBuy
472     // Returns snails bought for a given amount of ETH 
473     
474     function ComputeBuy(uint256 _ether) public view returns(uint256) {
475         uint256 _tokenPrice = ComputeTokenPrice();
476         return _ether.div(_tokenPrice);
477     }
478     
479     // ComputeMyEggs
480     // Returns eggs produced since last hatch or sacrifice
481 	// Egg amount can never be above current snail count
482     
483     function ComputeMyEggs(address adr) public view returns(uint256) {
484         uint256 _eggs = now.sub(lastHatch[adr]);
485         _eggs = _eggs.mul(hatcherySnail[adr]).div(TIME_TO_HATCH_1SNAIL);
486         if (_eggs > hatcherySnail[adr]) {
487             _eggs = hatcherySnail[adr];
488         }
489         return _eggs;
490     }
491     
492     // ComputeMyDivs
493     // Returns unclaimed divs for the player
494     
495     function ComputeMyDivs() public view returns(uint256) {
496         //Calculate share of player
497         uint256 _playerShare = divsPerSnail.mul(hatcherySnail[msg.sender]);
498 		
499         //Subtract already claimed divs
500     	_playerShare = _playerShare.sub(claimedDivs[msg.sender]);
501         return _playerShare;
502     }
503     
504     // GetMySnails
505     // Returns player snails
506     
507     function GetMySnails() public view returns(uint256) {
508         return hatcherySnail[msg.sender];
509     }
510     
511     // GetMyEarnings
512     // Returns player earnings
513     
514     function GetMyEarnings() public view returns(uint256) {
515         return playerEarnings[msg.sender];
516     }
517     
518     // GetContractBalance
519     // Returns ETH in contract
520     
521     function GetContractBalance() public view returns (uint256) {
522         return address(this).balance;
523     }
524     
525 }
526 
527 library SafeMath {
528 
529   /**
530   * @dev Multiplies two numbers, throws on overflow.
531   */
532   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
533     if (a == 0) {
534       return 0;
535     }
536     uint256 c = a * b;
537     assert(c / a == b);
538     return c;
539   }
540 
541   /**
542   * @dev Integer division of two numbers, truncating the quotient.
543   */
544   function div(uint256 a, uint256 b) internal pure returns (uint256) {
545     // assert(b > 0); // Solidity automatically throws when dividing by 0
546     uint256 c = a / b;
547     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
548     return c;
549   }
550 
551   /**
552   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
553   */
554   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
555     assert(b <= a);
556     return a - b;
557   }
558 
559   /**
560   * @dev Adds two numbers, throws on overflow.
561   */
562   function add(uint256 a, uint256 b) internal pure returns (uint256) {
563     uint256 c = a + b;
564     assert(c >= a);
565     return c;
566   }
567 }