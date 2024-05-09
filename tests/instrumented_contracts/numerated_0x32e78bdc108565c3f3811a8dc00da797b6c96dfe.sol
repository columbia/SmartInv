1 pragma solidity ^0.4.18;
2 
3 
4 //
5 // AddressWars
6 // (http://beta.addresswars.io/)
7 // Public Beta v1.1
8 //
9 //
10 //     .d8888b.                                    .d8888b.          
11 //    d88P  Y88b                                  d88P  Y88b         
12 //    888    888                                  888    888         
13 //    888    888888  888     888  888.d8888b      888    888888  888 
14 //    888    888`Y8bd8P'     888  88888K          888    888`Y8bd8P' 
15 //    888    888  X88K       Y88  88P"Y8888b.     888    888  X88K   
16 //    Y88b  d88P.d8""8b.      Y8bd8P      X88     Y88b  d88P.d8""8b. 
17 //     "Y8888P" 888  888       Y88P   88888P'      "Y8888P" 888  888 
18 //
19 //
20 // ******************************
21 //  Welcome to AddressWars Beta!
22 // ******************************
23 //
24 // This contract is currently in a state of being tested and bug hunted,
25 // as this is the beta, there will be no fees for enlisting or wagering.
26 // This will encourage anyone to come and try out AddressWars for free
27 // before deciding to play the live version (when released) as well as
28 // making it so that the contract is tested to the fullest ability before
29 // the live version is deployed. The website is currently under development
30 // and will be continually improved as time goes on, once the live version
31 // is deployed, you can access it's contract and data through the root url
32 // (https://addresswars.io/) and there will always be a copy of the website
33 // on a subdomain that you can visit in order to view and interact with this
34 // contract at any time in the future.
35 //
36 // This contract is pushing the limits of the current Ethereum blockchain as
37 // there are quite a lot of variables that it needs to keep track of as well
38 // as being able to handle the statistical generation of key numbers. As a
39 // result, the estimated gas cost to deploy this contract is 7.5M whereas
40 // the current block gas limit is only 8M so this contract will take up
41 // almost a whole block! Another problem with complex contracts is the fact
42 // that there is a 16 local variable limit per function and in a few cases,
43 // the functions needed access to a lot more than that so a lot of filtering
44 // functions have been developed to handle the calculation internally then
45 // simply return the useful parts.
46 //
47 //
48 // **************************
49 //  How to play AddressWars!
50 // **************************
51 //
52 // Enlisting
53 // In order to start playing AddressWars, you must first have an Ethereum
54 // wallet address which you can issue transactions from but only non-contract 
55 // addresses (ie addresses where you can issue a transaction directly) can play.
56 // From here, you can simply call the enlist() function and send the relevant
57 // fee (in the beta it's 0 ETH, for the live it will be 0.01 ETH). After the
58 // transaction succeeds, you will have your very own, randomly generated
59 // address card that you can now put up for wager or use to attempt to claim
60 // other address cards with!
61 //
62 // Wagering
63 // You can choose to wager any card you own assuming you are not already 
64 // wagering a copy of that card. For your own address, you can provide a
65 // maximum of 10 other copies to any other addresses (by either transferring 
66 // or wagering), once 10 copies of your own address are circulating, you will
67 // no longer be able to transfer or wager your own address (although you can
68 // still use it to claim other addresses). It is important to note that there
69 // is no way to 'destroy' a copy of a card in circulation and your own address
70 // card cannot be transferred back to you (and you can't attempt to claim your
71 // own address card).
72 // To wager a card, simply call the wagerCardForAmount() function and send
73 // the relevant fee (in the beta it's 0 ETH, for the live it will be 0.005 ETH)
74 // as well as the address of the card you wish to wager and the amount you are
75 // willing to wager it for (in wei). From this point, any other address can
76 // attempt to claim the address card you listed but the card that will be put up
77 // for claim will be the one with the lowest claim price (this may not be yours 
78 // at the time but as soon as a successful claim happens and you are the next
79 // cheapest price, the next time someone attempts to claim that address, you
80 // will receive the wager and your card may be claimed and taken from you).
81 //
82 // Claiming
83 // Assuming your address has already enlisted, you are free to attempt to
84 // claim any card that has a current wager on it. You can only store up to
85 // 8 unique card addresses (your own address + 7 others) in your inventory
86 // and you cannot claim if you are already at this limit (unless you already own
87 // that card). You can claim as many copies of a card you own as you like but you
88 // can only get rid of them by wagering off one at a time. As mentioned above,
89 // the claim contender will be the owner of the cheapest claim wager. You cannot 
90 // claim a card if you are the current claim contender or if the card address is 
91 // the same as your address (ie you enlisted and got that card).
92 // To attempt to claim, you need to first assemble an army of 3 address cards
93 // (these cards don't have to be unique but you do have to own them) and send the 
94 // current cheapest wager price to the attemptToClaimCard() function. This function  
95 // will do all of the calculation work for you and determine if you managed to claim
96 // the card or not. The first thing that happens is the contract randomly picks 
97 // your claim contenders cards ensuring that at least one of the cards is the card
98 // address you are attempting to claim and the rest are from their inventory.
99 // After this point, all of the complex maths happens and the final attack
100 // and defence numbers will be calculated based on all of the cards types,
101 // modifiers and the base attack and defence stats.
102 // From here it's simply a matter of determining how many hits got through
103 // on both claimer and claim contender, it's calculated as follows;
104 // opponentsHits = yourCard[attack] - opponentsCard[defence]
105 //  ^ will be 0 if opponentsCard[defence] > yourCard[attack]
106 // This is totalled up for both the claimer and the claim contender and the
107 // one with the least amount of hits wins!
108 //
109 // Claim Outcomes
110 // There are 3 situations that can result from a claim attempt;
111 // 1. The total hits for both the claimer and the claim contender are equal
112 //    - this means that you have drawn with your opponent, the wager will
113 //      then be distributed;
114 //      98% -> the claimer (you get most of the wager back)
115 //      2% -> the dev
116 // 2. The claimer has more hits than the claim contender
117 //    - this means that you have lost against your opponent as they ended
118 //      up taking less hits than you, the wager will then be distributed;
119 //      98% -> the claim contender (they get most of the wager)
120 //      2% -> the dev
121 // 3. The claimer has less hits than the claim contender
122 //    - this means that you have succeeded in claiming the card and hence
123 //      that card address will be transferred from the claim contender
124 //      to the claimer. in this case, both claimer and claim contender
125 //      receive a portion of the wager as follow;
126 //      50% -> the claimer (you get half of the wager back)
127 //      48% -> the claim contender (they get about half of the wager)
128 //      2% -> the dev
129 //
130 // Transferring
131 // You are free to transfer any card you own to another address that has
132 // already enlisted. Upon transfer, only one copy of the card will be removed
133 // from your inventory so if you have multiple copies of that card, it will
134 // not be completely removed from your inventory. If you only had one copy
135 // though, that address will be removed from your inventory and you will
136 // be able to claim/receive another address in its place.
137 // There are some restrictions when transferring a card; 
138 //   1. you cannot be currently wagering the card
139 //   2. the address you are transferring to must already be enlisted
140 //   3. the address you are transferring the card to must have less than 
141 //      8 unique cards already (or they must already own the card)
142 //   4. you cannot transfer a card back to it's original address
143 //   5. if you are gifting your own address card, the claim limit will apply
144 //      and if 10 copies already exist, you will not be able to gift your card.
145 //
146 // Withdrawing
147 // All ETH transferred to the contract will stay in there until an
148 // address wishes to withdraw from their account. Balances are tracked
149 // per address and you can either withdraw an amount (assuming you have
150 // a balance higher than that amount) or you can just withdraw it all.
151 // For both of these cases there will be no fees associated with withdrawing
152 // from the contract and after you choose to withdraw, your balance will
153 // update accordingly.
154 //
155 //
156 // Have fun and good luck claiming!
157 //
158 
159 
160 contract AddressWarsBeta {
161 
162   //////////////////////////////////////////////////////////////////////
163   //  Constants
164 
165 
166   // dev
167   address public dev;
168   uint256 constant devTax = 2; // 2% of all wagers
169 
170   // fees
171   // in the live version the;
172   // enlistingFee will be 0.01 ether and the
173   // wageringFee will be 0.005 ether
174   uint256 constant enlistingFee = 0;
175   uint256 constant wageringFee = 0;
176 
177   // limits
178 
179   // the claim limit represents how many times an address can
180   // wager/trasnfer their own address. in this case the limit
181   // is set to 10 which means there can only ever be 10 other
182   // copies of your address out there. once you have wagered
183   // all 10 copies, you will no longer be able to wager your
184   // own address card (although you can still use it in play).
185   uint256 constant CLAIM_LIMIT = 10;
186 
187   // this will limit how many unique addresses you can own at
188   // one time. you can own multiple copies of a unique address
189   // but you can only own a total of 8 unique addresses (your
190   // own address + 7 others) at a time. you can choose to wager
191   // any address but if you wager one, the current claim price is the
192   // lowest price offered from all owners. upon a successful claim,
193   // one copy will transfer from your inventory and if you have no
194   // copies remaining, it will remove that address card and you will
195   // have another free slot.
196   uint256 constant MAX_UNIQUE_CARDS_PER_ADDRESS = 8;
197 
198 
199   //////////////////////////////////////////////////////////////////////
200   //  Statistical Variables
201 
202 
203   // this is used to calculate all of the statistics and random choices
204   // within AddressWars
205   // see the shuffleSeed() and querySeed() methods for more information.
206   uint256 private _seed;
207 
208   // the type will determine a cards bonus numbers;
209   // normal cards do not get any type advantage bonuses
210   // fire gets 1.25x att and def when versing nature
211   // water gets 1.25x att and def when versing fire
212   // nature gets 1.25x att and def when versing water
213   // *type advantages are applied after all modifiers
214   // that use addition are calculated
215   enum TYPE { NORMAL, FIRE, WATER, NATURE }
216   uint256[] private typeChances = [ 6, 7, 7, 7 ];
217   uint256 constant typeSum = 27;
218 
219   // the modifier will act like a bonus for your card(s)
220   // NONE: no bonus will be applied
221   // ALL_: if all cards are of the same type, they all get
222   //       bonus att/def/att+def numbers
223   // V_: if a versing card is of a certain type, your card
224   //     will get bonus att/def numbers
225   // V_SWAP: this will swap the versing cards att and def
226   //         numbers after they've been modified by any
227   //         other active modifiers
228   // R_V: your card resists the type advantages of the versing card,
229   //      normal type cards cannot receive this modifier
230   // A_I: your cards type advantage increases from 1.25x to 1.5x,
231   //      normal type cards cannot receive this modifier
232   enum MODIFIER {
233     NONE,
234     ALL_ATT, ALL_DEF, ALL_ATT_DEF,
235     V_ATT, V_DEF,
236     V_SWAP,
237     R_V,
238     A_I
239   }
240   uint256[] private modifierChances = [
241     55,
242     5, 6, 1,
243     12, 14,
244     3,
245     7,
246     4
247   ];
248   uint256 constant modifierSum = 107;
249 
250   // below are the chances for the bonus stats of the modifiers,
251   // the seed will first choose a value between 0 and the sum, it will
252   // then cumulatively count up until it reaches the index with the
253   // matched roll
254   // for example;
255   // if your data was = [ 2, 3, 4, 2, 1 ], your cumulative total is 12,
256   // from there a number will be rolled and it will add up all the values
257   // until the cumulative total is greater than the number rolled
258   // if we rolled a 9, 2(0) + 3(1) + 4(2) + 2(3) = 11 > 9 so the index
259   // you matched in this case would be 3
260   // the final value will be;
261   // bonusMinimum + indexOf(cumulativeRoll)
262   uint256 constant cardBonusMinimum = 1;
263   uint256[] private modifierAttBonusChances = [ 2, 5, 8, 7, 3, 2, 1, 1 ]; // range: 1 - 8
264   uint256 constant modifierAttBonusSum = 29;
265   uint256[] private modifierDefBonusChances = [ 2, 3, 6, 8, 6, 5, 3, 2, 1, 1 ];  // range: 1 - 10
266   uint256 constant modifierDefBonusSum = 37;
267 
268   // below are the distribution of the attack and defence numbers,
269   // in general, the attack average should be slightly higher than the
270   // defence average and defence should have a wider spread of values 
271   // compared to attack which should be a tighter set of numbers
272   // the final value will be;
273   // cardMinimum + indexOf(cumulativeRoll)
274   uint256 constant cardAttackMinimum = 10;
275   uint256[] private cardAttackChances = [ 2, 2, 3, 5, 8, 9, 15, 17, 13, 11, 6, 5, 3, 2, 1, 1 ]; // range: 10 - 25
276   uint256 constant cardAttackSum = 103;
277   uint256 constant cardDefenceMinimum = 5;
278   uint256[] private cardDefenceChances = [ 1, 1, 2, 3, 5, 6, 11, 15, 19, 14, 12, 11, 9, 8, 7, 6, 5, 4, 3, 2, 2, 2, 2, 1, 1, 1 ]; // range: 5 - 30
279   uint256 constant cardDefenceSum = 153;
280 
281 
282   //////////////////////////////////////////////////////////////////////
283   //  Registry Variables
284 
285 
286   // overall address card tracking
287   mapping (address => bool) _exists;
288   mapping (address => uint256) _indexOf;
289   mapping (address => address[]) _ownersOf;
290   mapping (address => uint256[]) _ownersClaimPriceOf;
291   struct AddressCard {
292       address _cardAddress;
293       uint8 _cardType;
294       uint8 _cardModifier;
295       uint8 _modifierPrimarayVal;
296       uint8 _modifierSecondaryVal;
297       uint8 _attack;
298       uint8 _defence;
299       uint8 _claimed;
300       uint8 _forClaim;
301       uint256 _lowestPrice;
302       address _claimContender;
303   }
304   AddressCard[] private _addressCards;
305 
306   // owner and balance tracking
307   mapping (address => uint256) _balanceOf;
308   mapping (address => address[]) _cardsOf;
309 
310 
311   //////////////////////////////////////////////////////////////////////
312   //  Events
313 
314 
315   event AddressDidEnlist(
316     address enlistedAddress);
317   event AddressCardWasWagered(
318     address addressCard, 
319     address owner, 
320     uint256 wagerAmount);
321   event AddressCardWagerWasCancelled(
322     address addressCard, 
323     address owner);
324   event AddressCardWasTransferred(
325     address addressCard, 
326     address fromAddress, 
327     address toAddress);
328   event ClaimAttempt(
329     bool wasSuccessful, 
330     address addressCard, 
331     address claimer, 
332     address claimContender, 
333     address[3] claimerChoices, 
334     address[3] claimContenderChoices, 
335     uint256[3][2] allFinalAttackValues,
336     uint256[3][2] allFinalDefenceValues);
337 
338 
339   //////////////////////////////////////////////////////////////////////
340   //  Main Functions
341 
342 
343   // start up the contract!
344   function AddressWarsBeta() public {
345 
346     // set our dev
347     dev = msg.sender;
348     // now use the dev address as the initial seed mix
349     shuffleSeed(uint256(dev));
350 
351   }
352 
353   // any non-contract address can call this function and begin playing AddressWars!
354   // please note that as there are a lot of write to storage operations, this function
355   // will be quite expensive in terms of gas so keep that in mind when sending your
356   // transaction to the network!
357   // 350k gas should be enough to handle all of the storage operations but MetaMask
358   // will give a good estimate when you initialize the transaction
359   // in order to enlist in AddressWars, you must first pay the enlistingFee (free for beta!)
360   function enlist() public payable {
361 
362     require(cardAddressExists(msg.sender) == false);
363     require(msg.value == enlistingFee);
364     require(msg.sender == tx.origin); // this prevents contracts from enlisting,
365     // only normal addresses (ie ones that can send a request) can play AddressWars.
366 
367     // first shuffle the main seed with the sender address as input
368     uint256 tmpSeed = tmpShuffleSeed(_seed, uint256(msg.sender));
369     uint256 tmpModulus;
370     // from this point on, tmpSeed will shuffle every time tmpQuerySeed()
371     // is called. it is used recursively so it will mutate upon each
372     // call of that function and finally at the end we will update
373     // the overall seed to save on gas fees
374 
375     // now we can query the different attributes of the card
376     // first lets determine the card type
377     (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, typeSum);
378     uint256 cardType = cumulativeIndexOf(typeChances, tmpModulus);
379 
380     // now to get the modifier
381     // special logic to handle normal type cards
382     uint256 adjustedModifierSum = modifierSum;
383     if (cardType == uint256(TYPE.NORMAL)) {
384       // normal cards cannot have the advantage increase modifier (the last in the array)
385       adjustedModifierSum -= modifierChances[modifierChances.length - 1];
386       // normal cards cannot have the resistance versing modifier (second last in the array)
387       adjustedModifierSum -= modifierChances[modifierChances.length - 2];
388     }
389     (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, adjustedModifierSum);
390     uint256 cardModifier = cumulativeIndexOf(modifierChances, tmpModulus);
391 
392     // now we need to find our attack and defence values
393     (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, cardAttackSum);
394     uint256 cardAttack = cardAttackMinimum + cumulativeIndexOf(cardAttackChances, tmpModulus);
395     (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, cardDefenceSum);
396     uint256 cardDefence = cardDefenceMinimum + cumulativeIndexOf(cardDefenceChances, tmpModulus);
397 
398     // finally handle our modifier values
399     uint256 primaryModifierVal = 0;
400     uint256 secondaryModifierVal = 0;
401     uint256 bonusAttackPenalty = 0;
402     uint256 bonusDefencePenalty = 0;
403     // handle the logic of our modifiers
404     if (cardModifier == uint256(MODIFIER.ALL_ATT)) { // all of the same type attack bonus
405 
406       // the primary modifier value will hold our attack bonus
407       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
408       primaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
409       // now for the attack penalty
410       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
411       bonusAttackPenalty = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
412       // penalty is doubled
413       bonusAttackPenalty *= 2;
414 
415     } else if (cardModifier == uint256(MODIFIER.ALL_DEF)) { // all of the same type defence bonus
416 
417       // the primary modifier value will hold our defence bonus
418       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
419       primaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
420       // now for the defence penalty
421       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
422       bonusDefencePenalty = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
423       // penalty is doubled
424       bonusDefencePenalty *= 2;
425 
426     } else if (cardModifier == uint256(MODIFIER.ALL_ATT_DEF)) { // all of the same type attack and defence bonus
427 
428       // the primary modifier value will hold our attack bonus
429       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
430       primaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
431       // now for the attack penalty
432       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
433       bonusAttackPenalty = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
434       // penalty is doubled
435       bonusAttackPenalty *= 2;
436 
437       // the secondary modifier value will hold our defence bonus
438       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
439       secondaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
440       // now for the defence penalty
441       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
442       bonusDefencePenalty = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
443       // penalty is doubled
444       bonusDefencePenalty *= 2;
445 
446     } else if (cardModifier == uint256(MODIFIER.V_ATT)) { // versing a certain type attack bonus
447 
448       // the primary modifier value will hold type we need to verse in order to get our bonus
449       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, typeSum);
450       primaryModifierVal = cumulativeIndexOf(typeChances, tmpModulus);
451 
452       // the secondary modifier value will hold our attack bonus
453       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
454       secondaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
455       // now for the attack penalty
456       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierAttBonusSum);
457       bonusAttackPenalty = cardBonusMinimum + cumulativeIndexOf(modifierAttBonusChances, tmpModulus);
458 
459     } else if (cardModifier == uint256(MODIFIER.V_DEF)) { // versing a certain type defence bonus
460 
461       // the primary modifier value will hold type we need to verse in order to get our bonus
462       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, typeSum);
463       primaryModifierVal = cumulativeIndexOf(typeChances, tmpModulus);
464 
465       // the secondary modifier value will hold our defence bonus
466       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
467       secondaryModifierVal = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
468       // now for the defence penalty
469       (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, modifierDefBonusSum);
470       bonusDefencePenalty = cardBonusMinimum + cumulativeIndexOf(modifierDefBonusChances, tmpModulus);
471 
472     }
473 
474     // now apply the penalties
475     if (bonusAttackPenalty >= cardAttack) {
476       cardAttack = 0;
477     } else {
478       cardAttack -= bonusAttackPenalty;
479     }
480     if (bonusDefencePenalty >= cardDefence) {
481       cardDefence = 0;
482     } else {
483       cardDefence -= bonusDefencePenalty;
484     }
485 
486 
487     // now to add it to the registry
488     _exists[msg.sender] = true;
489     _indexOf[msg.sender] = uint256(_addressCards.length);
490     _ownersOf[msg.sender] = [ msg.sender ];
491     _ownersClaimPriceOf[msg.sender] = [ uint256(0) ];
492     _addressCards.push(AddressCard({
493       _cardAddress: msg.sender,
494       _cardType: uint8(cardType),
495       _cardModifier: uint8(cardModifier),
496       _modifierPrimarayVal: uint8(primaryModifierVal),
497       _modifierSecondaryVal: uint8(secondaryModifierVal),
498       _attack: uint8(cardAttack),
499       _defence: uint8(cardDefence),
500       _claimed: uint8(0),
501       _forClaim: uint8(0),
502       _lowestPrice: uint256(0),
503       _claimContender: address(0)
504     }));
505 
506     // ...and now start your own collection!
507     _cardsOf[msg.sender] = [ msg.sender ];
508 
509     // dev receives the enlisting fee
510     _balanceOf[dev] = SafeMath.add(_balanceOf[dev], enlistingFee);
511 
512     // finally we need to update the main seed and as we initially started with
513     // the current main seed, tmpSeed will be the current representation of the seed
514     _seed = tmpSeed;
515 
516     // now that we're done, it's time to log the event
517     AddressDidEnlist(msg.sender);
518 
519   }
520 
521   // this is where you can wager one of your addresses for a certain amount.
522   // any other player can then attempt to claim your address off you, if the
523   // address is your own address, you will simply give them a copy (limited to 10
524   // total copies) but otherwise the player will take that address off you if they
525   // are successful.
526   // here's what can happen when you wager;
527   // 1. if an opponent is successful in claiming your card, they will receive 50%
528   //    of the wager amount back, the dev gets 2% and you get 48%
529   // 2. if an opponent is unsuccessful in claiming your card, you will receive
530   //    98% of the wager amount and the dev will get 2%
531   // 3. if an opponent is draws with you when claiming your card, they will receive
532   //    98% of the wager amount back and the dev will get 2%
533   // your wager will remain available for anyone to claim up until either you cancel
534   // the wager or an opponent is successful in claiming your card
535   // in order to wager in AddressWars, you must first pay the wageringFee (free for beta!)
536   function wagerCardForAmount(address cardAddress, uint256 amount) public payable {
537 
538     require(amount > 0);
539 
540     require(cardAddressExists(msg.sender));
541     require(msg.value == wageringFee);
542 
543     uint256 firstMatchedIndex;
544     bool isAlreadyWagered;
545     (firstMatchedIndex, isAlreadyWagered, , , ) = getOwnerOfCardsCheapestWager(msg.sender, cardAddress);
546     // calling the above method will automatically reinforce the check that the cardAddress exists
547     // as well as the sender actually owning the card
548     // we cannot wager a card if we are already wagering it
549     require(isAlreadyWagered == false);
550     // double check to make sure the card is actually owned by the sender
551     require(msg.sender == _ownersOf[cardAddress][firstMatchedIndex]);
552 
553     AddressCard memory addressCardForWager = _addressCards[_indexOf[cardAddress]];
554     if (msg.sender == cardAddress) {
555       // we need to enforce the claim limit if you are the initial owner
556       require(addressCardForWager._claimed < CLAIM_LIMIT);
557     }
558 
559     // now write the new data
560     _ownersClaimPriceOf[cardAddress][firstMatchedIndex] = amount;
561 
562     // now update our statistics
563     updateCardStatistics(cardAddress);
564 
565     // dev receives the wagering fee
566     _balanceOf[dev] = SafeMath.add(_balanceOf[dev], wageringFee);
567 
568     // now that we're done, it's time to log the event
569     AddressCardWasWagered(cardAddress, msg.sender, amount);
570 
571   }
572 
573   function cancelWagerOfCard(address cardAddress) public {
574 
575     require(cardAddressExists(msg.sender));
576 
577     uint256 firstMatchedIndex;
578     bool isAlreadyWagered;
579     (firstMatchedIndex, isAlreadyWagered, , , ) = getOwnerOfCardsCheapestWager(msg.sender, cardAddress);
580     // calling the above method will automatically reinforce the check that the cardAddress exists
581     // as well as the owner actually owning the card
582     // we can only cancel a wager if there already is one
583     require(isAlreadyWagered);
584     // double check to make sure the card is actually owned by the sender
585     require(msg.sender == _ownersOf[cardAddress][firstMatchedIndex]);
586 
587     // now write the new data
588     _ownersClaimPriceOf[cardAddress][firstMatchedIndex] = 0;
589 
590     // now update our statistics
591     updateCardStatistics(cardAddress);
592 
593     // now that we're done, it's time to log the event
594     AddressCardWagerWasCancelled(cardAddress, msg.sender);
595 
596   }
597 
598   // this is the main battle function of the contract, it takes the card address you
599   // wish to claim as well as your card choices as input. a lot of complex calculations
600   // happen within this function and in the end, a result will be determined on whether
601   // you won the claim or not. at the end, an event will be logged with all of the information
602   // about what happened in the battle including the final result, the contenders,
603   // the card choices (yours and your opponenets) as well as the final attack and defence numbers.
604   // this function will revert if the msg.value does not match the current minimum claim value
605   // of the card address you are attempting to claim.
606   function attemptToClaimCard(address cardAddress, address[3] choices) public payable {
607 
608     // a lot of the functionality of attemptToClaimCard() is calculated in other methods as
609     // there is only a 16 local variable limit per method and we need a lot more than that
610 
611     // see ownerCanClaimCard() below, this ensures we can actually claim the card we are after
612     // by running through various requirement checks
613     address claimContender;
614     uint256 claimContenderIndex;
615     (claimContender, claimContenderIndex) = ownerCanClaimCard(msg.sender, cardAddress, choices, msg.value);
616 
617     address[3] memory opponentCardChoices = generateCardsFromClaimForOpponent(cardAddress, claimContender);
618 
619     uint256[3][2] memory allFinalAttackFigures;
620     uint256[3][2] memory allFinalDefenceFigures;
621     (allFinalAttackFigures, allFinalDefenceFigures) = calculateAdjustedFiguresForBattle(choices, opponentCardChoices);
622     // after this point we have all of the modified attack and defence figures
623     // in the arrays above. the way the winner is determined is by counting 
624     // how many attack points get through in total for each card, this is
625     // calculated by simply doing;
626     // opponentsHits = yourCard[attack] - opponentsCard[defence]
627     // if the defence of the opposing card is greater than the attack value,
628     // no hits will be taken.
629     // at the end, all hits are added up and the winner is the one with
630     // the least total amount of hits, if it is a draw, the wager will be
631     // returned to the sender (minus the dev fee)
632     uint256[2] memory totalHits = [ uint256(0), uint256(0) ];
633     for (uint256 i = 0; i < 3; i++) {
634       // start with the opponent attack to you
635       totalHits[0] += (allFinalAttackFigures[1][i] > allFinalDefenceFigures[0][i] ? allFinalAttackFigures[1][i] - allFinalDefenceFigures[0][i] : 0);
636       // then your attack to the opponent
637       totalHits[1] += (allFinalAttackFigures[0][i] > allFinalDefenceFigures[1][i] ? allFinalAttackFigures[0][i] - allFinalDefenceFigures[1][i] : 0);
638     }
639 
640     // before we process the outcome, we should log the event.
641     // order is important here as we should log a successful 
642     // claim attempt then a transfer (if that's what happens)
643     // instead of the other way around
644     ClaimAttempt(
645       totalHits[0] < totalHits[1], // it was successful if we had less hits than the opponent
646       cardAddress,
647       msg.sender,
648       claimContender,
649       choices,
650       opponentCardChoices,
651       allFinalAttackFigures,
652       allFinalDefenceFigures
653       );
654 
655     // handle the outcomes
656     uint256 tmpAmount;
657     if (totalHits[0] == totalHits[1]) { // we have a draw
658 
659       // hand out the dev tax
660       tmpAmount = SafeMath.div(SafeMath.mul(msg.value, devTax), 100); // 2%
661       _balanceOf[dev] = SafeMath.add(_balanceOf[dev], tmpAmount);
662       // now we return the rest to the sender
663       _balanceOf[msg.sender] = SafeMath.add(_balanceOf[msg.sender], SafeMath.sub(msg.value, tmpAmount)); // 98%
664 
665     } else if (totalHits[0] > totalHits[1]) { // we have more hits so we were unsuccessful
666 
667       // hand out the dev tax
668       tmpAmount = SafeMath.div(SafeMath.mul(msg.value, devTax), 100); // 2%
669       _balanceOf[dev] = SafeMath.add(_balanceOf[dev], tmpAmount);
670       // now we give the rest to the claim contender
671       _balanceOf[claimContender] = SafeMath.add(_balanceOf[claimContender], SafeMath.sub(msg.value, tmpAmount)); // 98%
672 
673     } else { // this means we have less hits than the opponent so we were successful in our claim!
674 
675       // hand out the dev tax
676       tmpAmount = SafeMath.div(SafeMath.mul(msg.value, devTax), 100); // 2%
677       _balanceOf[dev] = SafeMath.add(_balanceOf[dev], tmpAmount);
678       // return half to the sender
679       _balanceOf[msg.sender] = SafeMath.add(_balanceOf[msg.sender], SafeMath.div(msg.value, 2)); // 50%
680       // and now the remainder goes to the claim contender
681       _balanceOf[claimContender] = SafeMath.add(_balanceOf[claimContender], SafeMath.sub(SafeMath.div(msg.value, 2), tmpAmount)); // 48%
682 
683       // finally transfer the ownership of the card from the claim contender to the sender but
684       // first we need to make sure to cancel the wager
685       _ownersClaimPriceOf[cardAddress][claimContenderIndex] = 0;
686       transferCard(cardAddress, claimContender, msg.sender);
687 
688       // now update our statistics
689       updateCardStatistics(cardAddress);
690 
691     }
692 
693   }
694 
695   function transferCardTo(address cardAddress, address toAddress) public {
696 
697     // you can view this internal method below for more details.
698     // all of the requirements around transferring a card are
699     // tested within the transferCard() method.
700     // you are free to gift your own address card to anyone
701     // (assuming there are less than 10 copies circulating).
702     transferCard(cardAddress, msg.sender, toAddress);
703 
704   }
705 
706 
707   //////////////////////////////////////////////////////////////////////
708   //  Wallet Functions
709 
710 
711   function withdrawAmount(uint256 amount) public {
712 
713     require(amount > 0);
714 
715     address sender = msg.sender;
716     uint256 balance = _balanceOf[sender];
717     
718     require(amount <= balance);
719     // transfer and update the balances
720     _balanceOf[sender] = SafeMath.sub(_balanceOf[sender], amount);
721     sender.transfer(amount);
722 
723   }
724 
725   function withdrawAll() public {
726 
727     address sender = msg.sender;
728     uint256 balance = _balanceOf[sender];
729 
730     require(balance > 0);
731     // transfer and update the balances
732     _balanceOf[sender] = 0;
733     sender.transfer(balance);
734 
735   }
736 
737   function getBalanceOfSender() public view returns (uint256) {
738     return _balanceOf[msg.sender];
739   }
740 
741 
742   //////////////////////////////////////////////////////////////////////
743   //  Helper Functions
744 
745 
746   function tmpShuffleSeed(uint256 tmpSeed, uint256 mix) public view returns (uint256) {
747 
748     // really mix it up!
749     uint256 newTmpSeed = tmpSeed;
750     uint256 currentTime = now;
751     uint256 timeMix = currentTime + mix;
752     // in this instance, overflow is ok as we are just shuffling around the bits
753     // first lets square the seed
754     newTmpSeed *= newTmpSeed;
755     // now add our time and mix
756     newTmpSeed += timeMix;
757     // multiply by the time
758     newTmpSeed *= currentTime;
759     // now add our mix
760     newTmpSeed += mix;
761     // and finally multiply by the time and mix
762     newTmpSeed *= timeMix;
763 
764     return newTmpSeed;
765 
766   }
767 
768   function shuffleSeed(uint256 mix) private {
769 
770     // set our seed based on our last seed
771     _seed = tmpShuffleSeed(_seed, mix);
772   
773   }
774 
775   function tmpQuerySeed(uint256 tmpSeed, uint256 modulus) public view returns (uint256 tmpShuffledSeed, uint256 result) {
776 
777     require(modulus > 0);
778 
779     // get our answer
780     uint256 response = tmpSeed % modulus;
781 
782     // now we want to re-mix our seed based off our response
783     uint256 mix = response + 1; // non-zero
784     mix *= modulus;
785     mix += response;
786     mix *= modulus;
787 
788     // now return it
789     return (tmpShuffleSeed(tmpSeed, mix), response);
790 
791   }
792 
793   function querySeed(uint256 modulus) private returns (uint256) {
794 
795     require(modulus > 0);
796 
797     uint256 tmpSeed;
798     uint256 response;
799     (tmpSeed, response) = tmpQuerySeed(_seed, modulus);
800 
801     // tmpSeed will now represent the suffled version of our last seed
802     _seed = tmpSeed;
803 
804     // now return it
805     return response;
806 
807   }
808 
809   function cumulativeIndexOf(uint256[] array, uint256 target) private pure returns (uint256) {
810 
811     bool hasFound = false;
812     uint256 index;
813     uint256 cumulativeTotal = 0;
814     for (uint256 i = 0; i < array.length; i++) {
815       cumulativeTotal += array[i];
816       if (cumulativeTotal > target) {
817         hasFound = true;
818         index = i;
819         break;
820       }
821     }
822 
823     require(hasFound);
824     return index;
825 
826   }
827 
828   function cardAddressExists(address cardAddress) public view returns (bool) {
829     return _exists[cardAddress];
830   }
831 
832   function indexOfCardAddress(address cardAddress) public view returns (uint256) {
833     require(cardAddressExists(cardAddress));
834     return _indexOf[cardAddress];
835   }
836 
837   function ownerCountOfCard(address owner, address cardAddress) public view returns (uint256) {
838 
839     // both card addresses need to exist in order to own cards
840     require(cardAddressExists(owner));
841     require(cardAddressExists(cardAddress));
842 
843     // check if it's your own address
844     if (owner == cardAddress) {
845       return 0;
846     }
847 
848     uint256 ownerCount = 0;
849     address[] memory owners = _ownersOf[cardAddress];
850     for (uint256 i = 0; i < owners.length; i++) {
851       if (owner == owners[i]) {
852         ownerCount++;
853       }
854     }
855 
856     return ownerCount;
857 
858   }
859 
860   function ownerHasCard(address owner, address cardAddress) public view returns (bool doesOwn, uint256[] indexes) {
861 
862     // both card addresses need to exist in order to own cards
863     require(cardAddressExists(owner));
864     require(cardAddressExists(cardAddress));
865 
866     uint256[] memory ownerIndexes = new uint256[](ownerCountOfCard(owner, cardAddress));
867     // check if it's your own address
868     if (owner == cardAddress) {
869       return (true, ownerIndexes);
870     }
871 
872     if (ownerIndexes.length > 0) {
873       uint256 currentIndex = 0;
874       address[] memory owners = _ownersOf[cardAddress];
875       for (uint256 i = 0; i < owners.length; i++) {
876         if (owner == owners[i]) {
877           ownerIndexes[currentIndex] = i;
878           currentIndex++;
879         }
880       }
881     }
882 
883     // this owner may own multiple copies of the card and so an array of indexes are returned
884     // if the owner does not own the card, it will return (false, [])
885     return (ownerIndexes.length > 0, ownerIndexes);
886 
887   }
888 
889   function ownerHasCardSimple(address owner, address cardAddress) private view returns (bool) {
890 
891     bool doesOwn;
892     (doesOwn, ) = ownerHasCard(owner, cardAddress);
893     return doesOwn;
894 
895   }
896 
897   function ownerCanClaimCard(address owner, address cardAddress, address[3] choices, uint256 amount) private view returns (address currentClaimContender, uint256 claimContenderIndex) {
898 
899     // you cannot claim back your own address cards
900     require(owner != cardAddress);
901     require(cardAddressExists(owner));
902     require(ownerHasCardSimple(owner, cardAddress) || _cardsOf[owner].length < MAX_UNIQUE_CARDS_PER_ADDRESS);
903 
904 
905     uint256 cheapestIndex;
906     bool canClaim;
907     address claimContender;
908     uint256 lowestClaimPrice;
909     (cheapestIndex, canClaim, claimContender, lowestClaimPrice, ) = getCheapestCardWager(cardAddress);
910     // make sure we can actually claim it and that we are paying the correct amount
911     require(canClaim);
912     require(amount == lowestClaimPrice);
913     // we also need to check that the sender is not the current claim contender
914     require(owner != claimContender);
915 
916     // now check if we own all of our choices
917     for (uint256 i = 0; i < choices.length; i++) {
918       require(ownerHasCardSimple(owner, choices[i])); // if one is not owned, it will trigger a revert
919     }
920 
921     // if no requires have been triggered by this point it means we are able to claim the card
922     // now return the claim contender and their index
923     return (claimContender, cheapestIndex);
924 
925   }
926 
927   function generateCardsFromClaimForOpponent(address cardAddress, address opponentAddress) private returns (address[3]) {
928 
929     require(cardAddressExists(cardAddress));
930     require(cardAddressExists(opponentAddress));
931     require(ownerHasCardSimple(opponentAddress, cardAddress));
932 
933     // generate the opponents cards from their own inventory
934     // it is important to note that at least 1 of their choices
935     // needs to be the card you are attempting to claim
936     address[] memory cardsOfOpponent = _cardsOf[opponentAddress];
937     address[3] memory opponentCardChoices;
938     uint256 tmpSeed = tmpShuffleSeed(_seed, uint256(opponentAddress));
939     uint256 tmpModulus;
940     uint256 indexOfClaimableCard;
941     (tmpSeed, indexOfClaimableCard) = tmpQuerySeed(tmpSeed, 3); // 0, 1 or 2
942     for (uint256 i = 0; i < 3; i++) {
943       if (i == indexOfClaimableCard) {
944         opponentCardChoices[i] = cardAddress;
945       } else {
946         (tmpSeed, tmpModulus) = tmpQuerySeed(tmpSeed, cardsOfOpponent.length);
947         opponentCardChoices[i] = cardsOfOpponent[tmpModulus];        
948       }
949     }
950 
951     // finally we need to update the main seed and as we initially started with
952     // the current main seed, tmpSeed will be the current representation of the seed
953     _seed = tmpSeed;
954 
955     return opponentCardChoices;
956 
957   }
958 
959   function updateCardStatistics(address cardAddress) private {
960 
961     AddressCard storage addressCardClaimed = _addressCards[_indexOf[cardAddress]];
962     address claimContender;
963     uint256 lowestClaimPrice;
964     uint256 wagerCount;
965     ( , , claimContender, lowestClaimPrice, wagerCount) = getCheapestCardWager(cardAddress);
966     addressCardClaimed._forClaim = uint8(wagerCount);
967     addressCardClaimed._lowestPrice = lowestClaimPrice;
968     addressCardClaimed._claimContender = claimContender;
969 
970   }
971 
972   function transferCard(address cardAddress, address fromAddress, address toAddress) private {
973 
974     require(toAddress != fromAddress);
975     require(cardAddressExists(cardAddress));
976     require(cardAddressExists(fromAddress));
977     uint256 firstMatchedIndex;
978     bool isWagered;
979     (firstMatchedIndex, isWagered, , , ) = getOwnerOfCardsCheapestWager(fromAddress, cardAddress);
980     require(isWagered == false); // you cannot transfer a card if it's currently wagered
981 
982     require(cardAddressExists(toAddress));
983     require(toAddress != cardAddress); // can't transfer a card to it's original address
984     require(ownerHasCardSimple(toAddress, cardAddress) || _cardsOf[toAddress].length < MAX_UNIQUE_CARDS_PER_ADDRESS);
985 
986     // firstly, if toAddress doesn't have a copy we need to add one
987     if (!ownerHasCardSimple(toAddress, cardAddress)) {
988       _cardsOf[toAddress].push(cardAddress);
989     } 
990 
991     // now check whether the fromAddress is just our original card
992     // address, if this is the case, they are free to transfer out
993     // one of their cards assuming the claim limit is not yet reached
994     if (fromAddress == cardAddress) { // the card is being claimed/gifted
995 
996       AddressCard storage addressCardClaimed = _addressCards[_indexOf[cardAddress]];
997       require(addressCardClaimed._claimed < CLAIM_LIMIT);
998 
999       // we need to push new data to our arrays
1000       _ownersOf[cardAddress].push(toAddress);
1001       _ownersClaimPriceOf[cardAddress].push(uint256(0));
1002 
1003       // now update the claimed count in the registry
1004       addressCardClaimed._claimed = uint8(_ownersOf[cardAddress].length - 1); // we exclude the original address
1005 
1006     } else {
1007 
1008       // firstly we need to cache the current index from our fromAddress' _cardsOf
1009       uint256 cardIndexOfSender = getCardIndexOfOwner(cardAddress, fromAddress);
1010 
1011       // now just update the address at the firstMatchedIndex
1012       _ownersOf[cardAddress][firstMatchedIndex] = toAddress;
1013 
1014       // finally check if our fromAddress has any copies of the card left
1015       if (!ownerHasCardSimple(fromAddress, cardAddress)) {
1016 
1017         // if not delete that card from their inventory and make room in the array
1018         for (uint256 i = cardIndexOfSender; i < _cardsOf[fromAddress].length - 1; i++) {
1019           // shuffle the next value over
1020           _cardsOf[fromAddress][i] = _cardsOf[fromAddress][i + 1];
1021         }
1022         // now decrease the length
1023         _cardsOf[fromAddress].length--;
1024 
1025       }
1026 
1027     }
1028 
1029     // now that we're done, it's time to log the event
1030     AddressCardWasTransferred(cardAddress, fromAddress, toAddress);
1031 
1032   }
1033 
1034   function calculateAdjustedFiguresForBattle(address[3] yourChoices, address[3] opponentsChoices) private view returns (uint256[3][2] allAdjustedAttackFigures, uint256[3][2] allAdjustedDefenceFigures) {
1035 
1036     // [0] is yours, [1] is your opponents
1037     AddressCard[3][2] memory allCards;
1038     uint256[3][2] memory allAttackFigures;
1039     uint256[3][2] memory allDefenceFigures;
1040     bool[2] memory allOfSameType = [ true, true ];
1041     uint256[2] memory cumulativeAttackBonuses = [ uint256(0), uint256(0) ];
1042     uint256[2] memory cumulativeDefenceBonuses = [ uint256(0), uint256(0) ];
1043 
1044     for (uint256 i = 0; i < 3; i++) {
1045       // cache your cards
1046       require(_exists[yourChoices[i]]);
1047       allCards[0][i] = _addressCards[_indexOf[yourChoices[i]]];
1048       allAttackFigures[0][i] = allCards[0][i]._attack;
1049       allDefenceFigures[0][i] = allCards[0][i]._defence;
1050 
1051       // cache your opponents cards
1052       require(_exists[opponentsChoices[i]]);
1053       allCards[1][i] = _addressCards[_indexOf[opponentsChoices[i]]];
1054       allAttackFigures[1][i] = allCards[1][i]._attack;
1055       allDefenceFigures[1][i] = allCards[1][i]._defence;
1056     }
1057 
1058     // for the next part, order is quite important as we want the
1059     // addition to happen first and then the multiplication to happen 
1060     // at the very end for the type advantages/resistances
1061 
1062     //////////////////////////////////////////////////////////////
1063     // the first modifiers that needs to be applied is the
1064     // ALL_ATT, ALL_DEF and the ALL_ATT_DEF mod
1065     // if all 3 of the chosen cards match the same type
1066     // and if at least one of them have the ALL_ATT, ALL_DEF
1067     // or ALL_ATT_DEF modifier, all of the cards will receive
1068     // the cumulative bonus for att/def/att+def
1069     for (i = 0; i < 3; i++) {
1070 
1071       // start with your cards      
1072       // compare to see if the types are the same as the previous one
1073       if (i > 0 && allCards[0][i]._cardType != allCards[0][i - 1]._cardType) {
1074         allOfSameType[0] = false;
1075       }
1076       // next count up all the modifier values for a total possible bonus
1077       if (allCards[0][i]._cardModifier == uint256(MODIFIER.ALL_ATT)) { // all attack
1078         // for the ALL_ATT modifier, the additional attack bonus is
1079         // stored in the primary value
1080         cumulativeAttackBonuses[0] += allCards[0][i]._modifierPrimarayVal;
1081       } else if (allCards[0][i]._cardModifier == uint256(MODIFIER.ALL_DEF)) { // all defence
1082         // for the ALL_DEF modifier, the additional defence bonus is
1083         // stored in the primary value
1084         cumulativeDefenceBonuses[0] += allCards[0][i]._modifierPrimarayVal;
1085       } else if (allCards[0][i]._cardModifier == uint256(MODIFIER.ALL_ATT_DEF)) { // all attack + defence
1086         // for the ALL_ATT_DEF modifier, the additional attack bonus is
1087         // stored in the primary value and the additional defence bonus is
1088         // stored in the secondary value
1089         cumulativeAttackBonuses[0] += allCards[0][i]._modifierPrimarayVal;
1090         cumulativeDefenceBonuses[0] += allCards[0][i]._modifierSecondaryVal;
1091       }
1092       
1093       // now do the same for your opponent
1094       if (i > 0 && allCards[1][i]._cardType != allCards[1][i - 1]._cardType) {
1095         allOfSameType[1] = false;
1096       }
1097       if (allCards[1][i]._cardModifier == uint256(MODIFIER.ALL_ATT)) {
1098         cumulativeAttackBonuses[1] += allCards[1][i]._modifierPrimarayVal;
1099       } else if (allCards[1][i]._cardModifier == uint256(MODIFIER.ALL_DEF)) {
1100         cumulativeDefenceBonuses[1] += allCards[1][i]._modifierPrimarayVal;
1101       } else if (allCards[1][i]._cardModifier == uint256(MODIFIER.ALL_ATT_DEF)) {
1102         cumulativeAttackBonuses[1] += allCards[1][i]._modifierPrimarayVal;
1103         cumulativeDefenceBonuses[1] += allCards[1][i]._modifierSecondaryVal;
1104       }
1105 
1106     }
1107     // we void our bonus if they aren't all of the type
1108     if (!allOfSameType[0]) {
1109       cumulativeAttackBonuses[0] = 0;
1110       cumulativeDefenceBonuses[0] = 0;
1111     }
1112     if (!allOfSameType[1]) {
1113       cumulativeAttackBonuses[1] = 0;
1114       cumulativeDefenceBonuses[1] = 0;
1115     }
1116     // now add the bonus figures to the initial attack numbers, they will be 0
1117     // if they either weren't all of the same type or if no cards actually had
1118     // the ALL_ modifier
1119     for (i = 0; i < 3; i++) {
1120       // for your cards
1121       allAttackFigures[0][i] += cumulativeAttackBonuses[0];
1122       allDefenceFigures[0][i] += cumulativeDefenceBonuses[0];
1123 
1124       // ...and your opponents cards
1125       allAttackFigures[1][i] += cumulativeAttackBonuses[1];
1126       allDefenceFigures[1][i] += cumulativeDefenceBonuses[1]; 
1127     }
1128 
1129     //////////////////////////////////////////////////////////////
1130     // the second modifier that needs to be applied is the V_ATT
1131     // or the V_DEF mod
1132     // if the versing card matches the same type listed in the
1133     // primaryModifierVal, that card will receive the bonus in
1134     // secondaryModifierVal for att/def
1135     for (i = 0; i < 3; i++) {
1136 
1137       // start with your cards      
1138       if (allCards[0][i]._cardModifier == uint256(MODIFIER.V_ATT)) { // versing attack
1139         // check if the versing cards type matches the primary value
1140         if (allCards[1][i]._cardType == allCards[0][i]._modifierPrimarayVal) {
1141           // add the attack bonus (amount is held in the secondary value)
1142           allAttackFigures[0][i] += allCards[0][i]._modifierSecondaryVal;
1143         }
1144       } else if (allCards[0][i]._cardModifier == uint256(MODIFIER.V_DEF)) { // versing defence
1145         // check if the versing cards type matches the primary value
1146         if (allCards[1][i]._cardType == allCards[0][i]._modifierPrimarayVal) {
1147           // add the defence bonus (amount is held in the secondary value)
1148           allDefenceFigures[0][i] += allCards[0][i]._modifierSecondaryVal;
1149         }
1150       }
1151 
1152       // now do the same for your opponent
1153       if (allCards[1][i]._cardModifier == uint256(MODIFIER.V_ATT)) {
1154         if (allCards[0][i]._cardType == allCards[1][i]._modifierPrimarayVal) {
1155           allAttackFigures[1][i] += allCards[1][i]._modifierSecondaryVal;
1156         }
1157       } else if (allCards[1][i]._cardModifier == uint256(MODIFIER.V_DEF)) {
1158         if (allCards[0][i]._cardType == allCards[1][i]._modifierPrimarayVal) {
1159           allDefenceFigures[1][i] += allCards[1][i]._modifierSecondaryVal;
1160         }
1161       }
1162 
1163     }
1164 
1165     //////////////////////////////////////////////////////////////
1166     // the third modifier that needs to be applied is the type
1167     // advantage numbers as well as applying R_V (resists versing
1168     // cards type advantage) and A_I (increases your cards advantage)
1169     for (i = 0; i < 3; i++) {
1170 
1171       // start with your cards
1172       // first check if the card we're versing resists our type advantage
1173       if (allCards[1][i]._cardModifier != uint256(MODIFIER.R_V)) {
1174         // test all the possible combinations of advantages
1175         if (
1176           // fire vs nature
1177           (allCards[0][i]._cardType == uint256(TYPE.FIRE) && allCards[1][i]._cardType == uint256(TYPE.NATURE)) ||
1178           // water vs fire
1179           (allCards[0][i]._cardType == uint256(TYPE.WATER) && allCards[1][i]._cardType == uint256(TYPE.FIRE)) ||
1180           // nature vs water
1181           (allCards[0][i]._cardType == uint256(TYPE.NATURE) && allCards[1][i]._cardType == uint256(TYPE.WATER))
1182           ) {
1183 
1184           // now check if your card has a type advantage increase modifier
1185           if (allCards[0][i]._cardModifier == uint256(MODIFIER.A_I)) {
1186             allAttackFigures[0][i] = SafeMath.div(SafeMath.mul(allAttackFigures[0][i], 3), 2); // x1.5
1187             allDefenceFigures[0][i] = SafeMath.div(SafeMath.mul(allDefenceFigures[0][i], 3), 2); // x1.5
1188           } else {
1189             allAttackFigures[0][i] = SafeMath.div(SafeMath.mul(allAttackFigures[0][i], 5), 4); // x1.25
1190             allDefenceFigures[0][i] = SafeMath.div(SafeMath.mul(allDefenceFigures[0][i], 5), 4); // x1.25
1191           }
1192         }
1193       }
1194 
1195       // now do the same for your opponent
1196       if (allCards[0][i]._cardModifier != uint256(MODIFIER.R_V)) {
1197         if (
1198           (allCards[1][i]._cardType == uint256(TYPE.FIRE) && allCards[0][i]._cardType == uint256(TYPE.NATURE)) ||
1199           (allCards[1][i]._cardType == uint256(TYPE.WATER) && allCards[0][i]._cardType == uint256(TYPE.FIRE)) ||
1200           (allCards[1][i]._cardType == uint256(TYPE.NATURE) && allCards[0][i]._cardType == uint256(TYPE.WATER))
1201           ) {
1202           if (allCards[1][i]._cardModifier == uint256(MODIFIER.A_I)) {
1203             allAttackFigures[1][i] = SafeMath.div(SafeMath.mul(allAttackFigures[1][i], 3), 2); // x1.5
1204             allDefenceFigures[1][i] = SafeMath.div(SafeMath.mul(allDefenceFigures[1][i], 3), 2); // x1.5
1205           } else {
1206             allAttackFigures[1][i] = SafeMath.div(SafeMath.mul(allAttackFigures[1][i], 5), 4); // x1.25
1207             allDefenceFigures[1][i] = SafeMath.div(SafeMath.mul(allDefenceFigures[1][i], 5), 4); // x1.25
1208           }
1209         }
1210       }
1211 
1212     }
1213 
1214     //////////////////////////////////////////////////////////////
1215     // the final modifier that needs to be applied is the V_SWAP mod
1216     // if your card has this modifier, it will swap the final attack
1217     // and defence numbers of your card
1218     uint256 tmp;
1219     for (i = 0; i < 3; i++) {
1220 
1221       // start with your cards
1222       // check if the versing card has the V_SWAP modifier
1223       if (allCards[1][i]._cardModifier == uint256(MODIFIER.V_SWAP)) {
1224         tmp = allAttackFigures[0][i];
1225         allAttackFigures[0][i] = allDefenceFigures[0][i];
1226         allDefenceFigures[0][i] = tmp;
1227       }
1228       // ...and your opponents cards
1229       if (allCards[0][i]._cardModifier == uint256(MODIFIER.V_SWAP)) {
1230         tmp = allAttackFigures[1][i];
1231         allAttackFigures[1][i] = allDefenceFigures[1][i];
1232         allDefenceFigures[1][i] = tmp;
1233       }
1234 
1235     }
1236 
1237     // we're all done!
1238     return (allAttackFigures, allDefenceFigures);
1239 
1240   }
1241 
1242 
1243   //////////////////////////////////////////////////////////////////////
1244   //  Getter Functions
1245 
1246 
1247   function getCard(address cardAddress) public view returns (uint256 cardIndex, uint256 cardType, uint256 cardModifier, uint256 cardModifierPrimaryVal, uint256 cardModifierSecondaryVal, uint256 attack, uint256 defence, uint256 claimed, uint256 forClaim, uint256 lowestPrice, address claimContender) {
1248 
1249     require(cardAddressExists(cardAddress));
1250 
1251     uint256 index = _indexOf[cardAddress];
1252     AddressCard memory addressCard = _addressCards[index];
1253     return (
1254         index,
1255         uint256(addressCard._cardType),
1256         uint256(addressCard._cardModifier),
1257         uint256(addressCard._modifierPrimarayVal),
1258         uint256(addressCard._modifierSecondaryVal),
1259         uint256(addressCard._attack),
1260         uint256(addressCard._defence),
1261         uint256(addressCard._claimed),
1262         uint256(addressCard._forClaim),
1263         uint256(addressCard._lowestPrice),
1264         address(addressCard._claimContender)
1265       );
1266 
1267   }
1268 
1269   function getCheapestCardWager(address cardAddress) public view returns (uint256 cheapestIndex, bool isClaimable, address claimContender, uint256 claimPrice, uint256 wagerCount) {
1270 
1271     require(cardAddressExists(cardAddress));
1272 
1273     uint256 cheapestSale = 0;
1274     uint256 indexOfCheapestSale = 0;
1275     uint256 totalWagers = 0;
1276     uint256[] memory allOwnersClaimPrice = _ownersClaimPriceOf[cardAddress];
1277     for (uint256 i = 0; i < allOwnersClaimPrice.length; i++) {
1278       uint256 priceAtIndex = allOwnersClaimPrice[i];
1279       if (priceAtIndex != 0) {
1280         totalWagers++;
1281         if (cheapestSale == 0 || priceAtIndex < cheapestSale) {
1282           cheapestSale = priceAtIndex;
1283           indexOfCheapestSale = i;
1284         }
1285       }
1286     }
1287 
1288     return (
1289         indexOfCheapestSale,
1290         (cheapestSale > 0),
1291         (cheapestSale > 0 ? _ownersOf[cardAddress][indexOfCheapestSale] : address(0)),
1292         cheapestSale,
1293         totalWagers
1294       );
1295 
1296   }
1297 
1298   function getOwnerOfCardsCheapestWager(address owner, address cardAddress) public view returns (uint256 cheapestIndex, bool isSelling, uint256 claimPrice, uint256 priceRank, uint256 outOf) {
1299 
1300     bool doesOwn;
1301     uint256[] memory indexes;
1302     (doesOwn, indexes) = ownerHasCard(owner, cardAddress);
1303     require(doesOwn);
1304 
1305     uint256[] memory allOwnersClaimPrice = _ownersClaimPriceOf[cardAddress];
1306     uint256 cheapestSale = 0;
1307     uint256 indexOfCheapestSale = 0; // this will handle the case of owner == cardAddress
1308     if (indexes.length > 0) {
1309       indexOfCheapestSale = indexes[0]; // defaults to the first index matched
1310     } else { // also will handle the case of owner == cardAddress
1311       cheapestSale = allOwnersClaimPrice[0];
1312     }
1313 
1314     for (uint256 i = 0; i < indexes.length; i++) {
1315       if (allOwnersClaimPrice[indexes[i]] != 0 && (cheapestSale == 0 || allOwnersClaimPrice[indexes[i]] < cheapestSale)) {
1316         cheapestSale = allOwnersClaimPrice[indexes[i]];
1317         indexOfCheapestSale = indexes[i];
1318       }
1319     }
1320 
1321     uint256 saleRank = 0;
1322     uint256 totalWagers = 0;
1323     if (cheapestSale > 0) {
1324       saleRank = 1;
1325       for (i = 0; i < allOwnersClaimPrice.length; i++) {
1326         if (allOwnersClaimPrice[i] != 0) {
1327           totalWagers++;
1328           if (allOwnersClaimPrice[i] < cheapestSale) {
1329             saleRank++;
1330           }
1331         }
1332       }
1333     }
1334 
1335     return (
1336         indexOfCheapestSale,
1337         (cheapestSale > 0),
1338         cheapestSale,
1339         saleRank,
1340         totalWagers
1341       );
1342 
1343   }
1344 
1345   function getCardIndexOfOwner(address cardAddress, address owner) public view returns (uint256) {
1346 
1347     require(cardAddressExists(cardAddress));
1348     require(cardAddressExists(owner));
1349     require(ownerHasCardSimple(owner, cardAddress));
1350 
1351     uint256 matchedIndex;
1352     address[] memory cardsOfOwner = _cardsOf[owner];
1353     for (uint256 i = 0; i < cardsOfOwner.length; i++) {
1354       if (cardsOfOwner[i] == cardAddress) {
1355         matchedIndex = i;
1356         break;
1357       }
1358     }
1359 
1360     return matchedIndex;
1361 
1362   }
1363   
1364   function getTotalUniqueCards() public view returns (uint256) {
1365     return _addressCards.length;
1366   }
1367   
1368   function getAllCardsAddress() public view returns (bytes20[]) {
1369 
1370     bytes20[] memory allCardsAddress = new bytes20[](_addressCards.length);
1371     for (uint256 i = 0; i < _addressCards.length; i++) {
1372       AddressCard memory addressCard = _addressCards[i];
1373       allCardsAddress[i] = bytes20(addressCard._cardAddress);
1374     }
1375     return allCardsAddress;
1376 
1377   }
1378 
1379   function getAllCardsType() public view returns (bytes1[]) {
1380 
1381     bytes1[] memory allCardsType = new bytes1[](_addressCards.length);
1382     for (uint256 i = 0; i < _addressCards.length; i++) {
1383       AddressCard memory addressCard = _addressCards[i];
1384       allCardsType[i] = bytes1(addressCard._cardType);
1385     }
1386     return allCardsType;
1387 
1388   }
1389 
1390   function getAllCardsModifier() public view returns (bytes1[]) {
1391 
1392     bytes1[] memory allCardsModifier = new bytes1[](_addressCards.length);
1393     for (uint256 i = 0; i < _addressCards.length; i++) {
1394       AddressCard memory addressCard = _addressCards[i];
1395       allCardsModifier[i] = bytes1(addressCard._cardModifier);
1396     }
1397     return allCardsModifier;
1398 
1399   }
1400 
1401   function getAllCardsModifierPrimaryVal() public view returns (bytes1[]) {
1402 
1403     bytes1[] memory allCardsModifierPrimaryVal = new bytes1[](_addressCards.length);
1404     for (uint256 i = 0; i < _addressCards.length; i++) {
1405       AddressCard memory addressCard = _addressCards[i];
1406       allCardsModifierPrimaryVal[i] = bytes1(addressCard._modifierPrimarayVal);
1407     }
1408     return allCardsModifierPrimaryVal;
1409 
1410   }
1411 
1412   function getAllCardsModifierSecondaryVal() public view returns (bytes1[]) {
1413 
1414     bytes1[] memory allCardsModifierSecondaryVal = new bytes1[](_addressCards.length);
1415     for (uint256 i = 0; i < _addressCards.length; i++) {
1416       AddressCard memory addressCard = _addressCards[i];
1417       allCardsModifierSecondaryVal[i] = bytes1(addressCard._modifierSecondaryVal);
1418     }
1419     return allCardsModifierSecondaryVal;
1420 
1421   }
1422 
1423   function getAllCardsAttack() public view returns (bytes1[]) {
1424 
1425     bytes1[] memory allCardsAttack = new bytes1[](_addressCards.length);
1426     for (uint256 i = 0; i < _addressCards.length; i++) {
1427       AddressCard memory addressCard = _addressCards[i];
1428       allCardsAttack[i] = bytes1(addressCard._attack);
1429     }
1430     return allCardsAttack;
1431 
1432   }
1433 
1434   function getAllCardsDefence() public view returns (bytes1[]) {
1435 
1436     bytes1[] memory allCardsDefence = new bytes1[](_addressCards.length);
1437     for (uint256 i = 0; i < _addressCards.length; i++) {
1438       AddressCard memory addressCard = _addressCards[i];
1439       allCardsDefence[i] = bytes1(addressCard._defence);
1440     }
1441     return allCardsDefence;
1442 
1443   }
1444 
1445   function getAllCardsClaimed() public view returns (bytes1[]) {
1446 
1447     bytes1[] memory allCardsClaimed = new bytes1[](_addressCards.length);
1448     for (uint256 i = 0; i < _addressCards.length; i++) {
1449       AddressCard memory addressCard = _addressCards[i];
1450       allCardsClaimed[i] = bytes1(addressCard._claimed);
1451     }
1452     return allCardsClaimed;
1453 
1454   }
1455 
1456   function getAllCardsForClaim() public view returns (bytes1[]) {
1457 
1458     bytes1[] memory allCardsForClaim = new bytes1[](_addressCards.length);
1459     for (uint256 i = 0; i < _addressCards.length; i++) {
1460       AddressCard memory addressCard = _addressCards[i];
1461       allCardsForClaim[i] = bytes1(addressCard._forClaim);
1462     }
1463     return allCardsForClaim;
1464 
1465   }
1466 
1467   function getAllCardsLowestPrice() public view returns (bytes32[]) {
1468 
1469     bytes32[] memory allCardsLowestPrice = new bytes32[](_addressCards.length);
1470     for (uint256 i = 0; i < _addressCards.length; i++) {
1471       AddressCard memory addressCard = _addressCards[i];
1472       allCardsLowestPrice[i] = bytes32(addressCard._lowestPrice);
1473     }
1474     return allCardsLowestPrice;
1475 
1476   }
1477 
1478   function getAllCardsClaimContender() public view returns (bytes4[]) {
1479 
1480     // returns the indexes of the claim contender
1481     bytes4[] memory allCardsClaimContender = new bytes4[](_addressCards.length);
1482     for (uint256 i = 0; i < _addressCards.length; i++) {
1483       AddressCard memory addressCard = _addressCards[i];
1484       allCardsClaimContender[i] = bytes4(_indexOf[addressCard._claimContender]);
1485     }
1486     return allCardsClaimContender;
1487 
1488   }
1489 
1490   function getAllOwnersOfCard(address cardAddress) public view returns (bytes4[]) {
1491     
1492     require(cardAddressExists(cardAddress));
1493 
1494     // returns the indexes of the owners
1495     address[] memory ownersOfCardAddress = _ownersOf[cardAddress];
1496     bytes4[] memory allOwners = new bytes4[](ownersOfCardAddress.length);
1497     for (uint256 i = 0; i < ownersOfCardAddress.length; i++) {
1498       allOwners[i] = bytes4(_indexOf[ownersOfCardAddress[i]]);
1499     }
1500     return allOwners;
1501 
1502   }
1503 
1504   function getAllOwnersClaimPriceOfCard(address cardAddress) public view returns (bytes32[]) {
1505     
1506     require(cardAddressExists(cardAddress));
1507 
1508     uint256[] memory ownersClaimPriceOfCardAddress = _ownersClaimPriceOf[cardAddress];
1509     bytes32[] memory allOwnersClaimPrice = new bytes32[](ownersClaimPriceOfCardAddress.length);
1510     for (uint256 i = 0; i < ownersClaimPriceOfCardAddress.length; i++) {
1511       allOwnersClaimPrice[i] = bytes32(ownersClaimPriceOfCardAddress[i]);
1512     }
1513     return allOwnersClaimPrice;
1514 
1515   }
1516 
1517   function getAllCardAddressesOfOwner(address owner) public view returns (bytes4[]) {
1518     
1519     require(cardAddressExists(owner));
1520 
1521     // returns the indexes of the cards owned
1522     address[] memory cardsOfOwner = _cardsOf[owner];
1523     bytes4[] memory allCardAddresses = new bytes4[](cardsOfOwner.length);
1524     for (uint256 i = 0; i < cardsOfOwner.length; i++) {
1525       allCardAddresses[i] = bytes4(_indexOf[cardsOfOwner[i]]);
1526     }
1527     return allCardAddresses;
1528 
1529   }
1530 
1531   function getAllCardAddressesCountOfOwner(address owner) public view returns (bytes1[]) {
1532     
1533     require(cardAddressExists(owner));
1534 
1535     address[] memory cardsOfOwner = _cardsOf[owner];
1536     bytes1[] memory allCardAddressesCount = new bytes1[](cardsOfOwner.length);
1537     for (uint256 i = 0; i < cardsOfOwner.length; i++) {
1538       allCardAddressesCount[i] = bytes1(ownerCountOfCard(owner, cardsOfOwner[i]));
1539     }
1540     return allCardAddressesCount;
1541 
1542   }
1543 
1544   function getAllCardAddressesPriceOfOwner(address owner) public view returns (bytes32[]) {
1545     
1546     require(cardAddressExists(owner));
1547 
1548     address[] memory cardsOfOwner = _cardsOf[owner];
1549     bytes32[] memory allCardAddressesPrice = new bytes32[](cardsOfOwner.length);
1550     for (uint256 i = 0; i < cardsOfOwner.length; i++) {
1551       uint256 price;
1552       ( , , price, , ) = getOwnerOfCardsCheapestWager(owner, cardsOfOwner[i]);
1553       allCardAddressesPrice[i] = bytes32(price);
1554     }
1555     return allCardAddressesPrice;
1556 
1557   }
1558 
1559 
1560   //////////////////////////////////////////////////////////////////////
1561   
1562 }
1563 
1564 library SafeMath {
1565 
1566   /**
1567   * @dev Multiplies two numbers, throws on overflow.
1568   */
1569   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1570     if (a == 0) {
1571       return 0;
1572     }
1573     uint256 c = a * b;
1574     assert(c / a == b);
1575     return c;
1576   }
1577 
1578   /**
1579   * @dev Integer division of two numbers, truncating the quotient.
1580   */
1581   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1582     // assert(b > 0); // Solidity automatically throws when dividing by 0
1583     uint256 c = a / b;
1584     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1585     return c;
1586   }
1587 
1588   /**
1589   * @dev Substracts two numbers, throws on overflow (ie if subtrahend is greater than minuend).
1590   */
1591   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1592     assert(b <= a);
1593     return a - b;
1594   }
1595 
1596   /**
1597   * @dev Adds two numbers, throws on overflow.
1598   */
1599   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1600     uint256 c = a + b;
1601     assert(c >= a);
1602     return c;
1603   }
1604 
1605 }