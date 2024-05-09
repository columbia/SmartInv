1 pragma solidity ^0.4.8;
2 
3 /**
4  * Very basic owned/mortal boilerplate.  Used for basically everything, for
5  * security/access control purposes.
6  */
7 contract Owned {
8   address owner;
9 
10   modifier onlyOwner {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   /**
18    * Basic constructor.  The sender is the owner.
19    */
20   function Owned() {
21     owner = msg.sender;
22   }
23 
24   /**
25    * Transfers ownership of the contract to a new owner.
26    * @param newOwner  Who gets to inherit this thing.
27    */
28   function transferOwnership(address newOwner) onlyOwner {
29     owner = newOwner;
30   }
31 
32   /**
33    * Shuts down the contract and removes it from the blockchain state.
34    * Only available to the owner.
35    */
36   function shutdown() onlyOwner {
37     selfdestruct(owner);
38   }
39 
40   /**
41    * Withdraw all the funds from this contract.
42    * Only available to the owner.
43    */
44   function withdraw() onlyOwner {
45     if (!owner.send(this.balance)) {
46       throw;
47     }
48   }
49 }
50 
51 contract LotteryRoundInterface {
52   bool public winningNumbersPicked;
53   uint256 public closingBlock;
54 
55   function pickTicket(bytes4 picks) payable;
56   function randomTicket() payable;
57 
58   function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool);
59   function closeGame(bytes32 salt, uint8 N);
60   function claimOwnerFee(address payout);
61   function withdraw();
62   function shutdown();
63   function distributeWinnings();
64   function claimPrize();
65 
66   function paidOut() constant returns(bool);
67   function transferOwnership(address newOwner);
68 }
69 
70 /**
71  * The meat of the game.  Holds all the rules around picking numbers,
72  * attempting to establish good sources of entropy, holding the pre-selected
73  * entropy sources (salt) in a way that is not publicly-revealed, etc.
74  * The gist is that this is a bit of a PRNG, that advances its entropy each
75  * time a ticket is picked.
76  *
77  * Provides the means to both pick specific numbers or have the PRNG select
78  * them for the ticketholder.
79  *
80  * Also controls payout of winners for a particular round.
81  */
82 contract LotteryRound is LotteryRoundInterface, Owned {
83 
84   /*
85     Constants
86    */
87   // public version string
88   string constant VERSION = '0.1.1';
89 
90   // round length
91   uint256 constant ROUND_LENGTH = 43200;  // approximately a week
92 
93   // payout fraction (in thousandths):
94   uint256 constant PAYOUT_FRACTION = 950;
95 
96   // Cost per ticket
97   uint constant TICKET_PRICE = 1 finney;
98 
99   // valid pick mask
100   bytes1 constant PICK_MASK = 0x3f; // 0-63
101 
102   /*
103     Public variables
104    */
105   // Pre-selected salt, hashed N times
106   // serves as proof-of-salt
107   bytes32 public saltHash;
108 
109   // single hash of salt.N.salt
110   // serves as proof-of-N
111   // 0 < N < 256
112   bytes32 public saltNHash;
113 
114   // closing time.
115   uint256 public closingBlock;
116 
117   // winning numbers
118   bytes4 public winningNumbers;
119 
120   // This becomes true when the numbers have been picked
121   bool public winningNumbersPicked = false;
122 
123   // This becomes populated if anyone wins
124   address[] public winners;
125 
126   // Stores a flag to signal if the winner has winnings to be claimed
127   mapping(address => bool) public winningsClaimable;
128 
129   /**
130    * Current picks are from 0 to 63, or 2^6 - 1.
131    * Current number of picks is 4
132    * Rough odds of winning will be 1 in (2^6)^4, assuming even distributions, etc
133    */
134   mapping(bytes4 => address[]) public tickets;
135   uint256 public nTickets = 0;
136 
137   // Set when winners are drawn, and represents the amount of the contract's current balance that can be paid out.
138   uint256 public prizePool;
139 
140   // Set when winners are drawn, and signifies the amount each winner will receive.  In the event of multiple
141   // winners, this will be prizePool / winners.length
142   uint256 public prizeValue;
143 
144   // The fee at the time winners were picked (if there were winners).  This is the portion of the contract's balance
145   // that goes to the contract owner.
146   uint256 public ownerFee;
147 
148   // This will be the sha3 hash of the previous entropy + some additional inputs (e.g. randomly-generated hashes, etc)
149   bytes32 private accumulatedEntropy;
150 
151   modifier beforeClose {
152     if (block.number > closingBlock) {
153       throw;
154     }
155     _;
156   }
157 
158   modifier beforeDraw {
159     if (block.number <= closingBlock || winningNumbersPicked) {
160       throw;
161     }
162     _;
163   }
164 
165   modifier afterDraw {
166     if (winningNumbersPicked == false) {
167       throw;
168     }
169     _;
170   }
171 
172   // Emitted when the round starts, broadcasting the hidden entropy params, closing block
173   // and game version.
174   event LotteryRoundStarted(
175     bytes32 saltHash,
176     bytes32 saltNHash,
177     uint256 closingBlock,
178     string version
179   );
180 
181   // Broadcasted any time a user purchases a ticket.
182   event LotteryRoundDraw(
183     address indexed ticketHolder,
184     bytes4 indexed picks
185   );
186 
187   // Broadcast when the round is completed, revealing the hidden entropy sources
188   // and the winning picks.
189   event LotteryRoundCompleted(
190     bytes32 salt,
191     uint8 N,
192     bytes4 indexed winningPicks,
193     uint256 closingBalance
194   );
195 
196   // Broadcast for each winner.
197   event LotteryRoundWinner(
198     address indexed ticketHolder,
199     bytes4 indexed picks
200   );
201 
202   /**
203    * Creates a new Lottery round, and sets the round's parameters.
204    *
205    * Note that this will implicitly set the factory to be the owner,
206    * meaning the factory will need to be able to transfer ownership,
207    * to its owner, the C&C contract.
208    *
209    * @param _saltHash       Hashed salt.  Will be hashed with sha3 N times
210    * @param _saltNHash      Hashed proof of N, in the format sha3(salt+N+salt)
211    */
212   function LotteryRound(
213     bytes32 _saltHash,
214     bytes32 _saltNHash
215   ) payable {
216     saltHash = _saltHash;
217     saltNHash = _saltNHash;
218     closingBlock = block.number + ROUND_LENGTH;
219     LotteryRoundStarted(
220       saltHash,
221       saltNHash,
222       closingBlock,
223       VERSION
224     );
225     // start this off with some really poor entropy.
226     accumulatedEntropy = block.blockhash(block.number - 1);
227   }
228 
229   /**
230    * Attempt to generate a new pseudo-random number, while advancing the internal entropy
231    * of the contract.  Uses a two-phase approach: first, generates a simple offset [0-255]
232    * from simple entropy sources (accumulated, sender, block number).  Uses this offset
233    * to index into the history of blockhashes, to attempt to generate some stronger entropy
234    * by including previous block hashes.
235    *
236    * Then advances the interal entropy by rehashing it with the chosen number.
237    */
238   function generatePseudoRand() internal returns(bytes32) {
239     uint8 pseudoRandomOffset = uint8(uint256(sha256(
240       msg.sender,
241       block.number,
242       accumulatedEntropy
243     )) & 0xff);
244     // WARNING: This assumes block.number > 256... If block.number < 256, the below block.blockhash could return 0
245     // This is probably only an issue in testing, but shouldn't be a problem there.
246     uint256 pseudoRandomBlock = block.number - pseudoRandomOffset - 1;
247     bytes32 pseudoRand = sha3(
248       block.number,
249       block.blockhash(pseudoRandomBlock),
250       msg.sender,
251       accumulatedEntropy
252     );
253     accumulatedEntropy = sha3(accumulatedEntropy, pseudoRand);
254     return pseudoRand;
255   }
256 
257   /**
258    * Buy a ticket with pre-selected picks
259    * @param picks User's picks.
260    */
261   function pickTicket(bytes4 picks) payable beforeClose {
262     if (msg.value != TICKET_PRICE) {
263       throw;
264     }
265     // don't allow invalid picks.
266     for (uint8 i = 0; i < 4; i++) {
267       if (picks[i] & PICK_MASK != picks[i]) {
268         throw;
269       }
270     }
271     tickets[picks].push(msg.sender);
272     nTickets++;
273     generatePseudoRand(); // advance the accumulated entropy
274     LotteryRoundDraw(msg.sender, picks);
275   }
276 
277   /**
278    * Interal function to generate valid picks.  Used by both the random
279    * ticket functionality, as well as when generating winning picks.
280    * Even though the picks are a fixed-width byte array, each pick is
281    * chosen separately (e.g. a bytes4 will result in 4 separate sha3 hashes
282    * used as sources).
283    *
284    * Masks the first byte of the seed to use as an offset into the next PRNG,
285    * then replaces the seed with the new PRNG.  Pulls a single byte from the
286    * resultant offset, masks it to be valid, then adds it to the accumulator.
287    *
288    * @param seed  The PRNG seed used to pick the numbers.
289    */
290   function pickValues(bytes32 seed) internal returns (bytes4) {
291     bytes4 picks;
292     uint8 offset;
293     for (uint8 i = 0; i < 4; i++) {
294       offset = uint8(seed[0]) & 0x1f;
295       seed = sha3(seed, msg.sender);
296       picks = (picks >> 8) | bytes1(seed[offset] & PICK_MASK);
297     }
298     return picks;
299   }
300 
301   /**
302    * Picks a random ticket, using the internal PRNG and accumulated entropy
303    */
304   function randomTicket() payable beforeClose {
305     if (msg.value != TICKET_PRICE) {
306       throw;
307     }
308     bytes32 pseudoRand = generatePseudoRand();
309     bytes4 picks = pickValues(pseudoRand);
310     tickets[picks].push(msg.sender);
311     nTickets++;
312     LotteryRoundDraw(msg.sender, picks);
313   }
314 
315   /**
316    * Public means to prove the salt after numbers are picked.  Not technically necessary
317    * for this to be external, because it will be called during the round close process.
318    * If the hidden entropy parameters don't match, the contract will refuse to pick
319    * numbers or close.
320    *
321    * @param salt          Hidden entropy source
322    * @param N             Secret value proving how to obtain the hashed entropy from the source.
323    */
324   function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool) {
325     // Proof-of-N:
326     bytes32 _saltNHash = sha3(salt, N, salt);
327     if (_saltNHash != saltNHash) {
328       return false;
329     }
330 
331     // Proof-of-salt:
332     bytes32 _saltHash = sha3(salt);
333     for (var i = 1; i < N; i++) {
334       _saltHash = sha3(_saltHash);
335     }
336     if (_saltHash != saltHash) {
337       return false;
338     }
339     return true;
340   }
341 
342   /**
343    * Internal function to handle tabulating the winners, including edge cases around
344    * duplicate winners.  Split out into its own method partially to enable proper
345    * testing.
346    *
347    * @param salt          Hidden entropy source.  Emitted here
348    * @param N             Key to the hidden entropy source.
349    * @param winningPicks  The winning picks.
350    */
351   function finalizeRound(bytes32 salt, uint8 N, bytes4 winningPicks) internal {
352     winningNumbers = winningPicks;
353     winningNumbersPicked = true;
354     LotteryRoundCompleted(salt, N, winningNumbers, this.balance);
355 
356     var _winners = tickets[winningNumbers];
357     // if we have winners:
358     if (_winners.length > 0) {
359       // let's dedupe and broadcast the winners before figuring out the prize pool situation.
360       for (uint i = 0; i < _winners.length; i++) {
361         var winner = _winners[i];
362         if (!winningsClaimable[winner]) {
363           winners.push(winner);
364           winningsClaimable[winner] = true;
365           LotteryRoundWinner(winner, winningNumbers);
366         }
367       }
368       // now let's wrap this up by finalizing the prize pool value:
369       // There may be some rounding errors in here, but it should only amount to a couple wei.
370       prizePool = this.balance * PAYOUT_FRACTION / 1000;
371       prizeValue = prizePool / winners.length;
372 
373       // Note that the owner doesn't get to claim a fee until the game is won.
374       ownerFee = this.balance - prizePool;
375     }
376     // we done.
377   }
378 
379   /**
380    * Reveal the secret sources of entropy, then use them to pick winning numbers.
381    *
382    * Note that by using no dynamic (e.g. blockhash-based) sources of entropy,
383    * censoring this transaction will not change the final outcome of the picks.
384    *
385    * @param salt          Hidden entropy.
386    * @param N             Number of times to hash the hidden entropy to produce the value provided at creation.
387    */
388   function closeGame(bytes32 salt, uint8 N) onlyOwner beforeDraw {
389     // Don't allow picking numbers multiple times.
390     if (winningNumbersPicked == true) {
391       throw;
392     }
393 
394     // prove the pre-selected salt is actually legit.
395     if (proofOfSalt(salt, N) != true) {
396       throw;
397     }
398 
399     bytes32 pseudoRand = sha3(
400       salt,
401       nTickets,
402       accumulatedEntropy
403     );
404     finalizeRound(salt, N, pickValues(pseudoRand));
405   }
406 
407   /**
408    * Sends the owner's fee to the specified address.  Note that the
409    * owner can only be paid if there actually was a winner. In the
410    * event no one wins, the entire balance is carried over into the
411    * next round.  No double-dipping here.
412    * @param payout        Address to send the owner fee to.
413    */
414   function claimOwnerFee(address payout) onlyOwner afterDraw {
415     if (ownerFee > 0) {
416       uint256 value = ownerFee;
417       ownerFee = 0;
418       if (!payout.send(value)) {
419         throw;
420       }
421     }
422   }
423 
424   /**
425    * Used to withdraw the balance when the round is completed.  This
426    * only works if there are either no winners, or all winners + the
427    * owner have been paid.
428    */
429   function withdraw() onlyOwner afterDraw {
430     if (paidOut() && ownerFee == 0) {
431       if (!owner.send(this.balance)) {
432         throw;
433       }
434     }
435   }
436 
437   /**
438    * Same as above.  This is mostly here because it's overriding the method
439    * inherited from `Owned`
440    */
441   function shutdown() onlyOwner afterDraw {
442     if (paidOut() && ownerFee == 0) {
443       selfdestruct(owner);
444     }
445   }
446 
447   /**
448    * Attempt to pay the winners, if any.  If any `send`s fail, the winner
449    * will have to collect their winnings on their own.
450    */
451   function distributeWinnings() onlyOwner afterDraw {
452     if (winners.length > 0) {
453       for (uint i = 0; i < winners.length; i++) {
454         address winner = winners[i];
455         bool unclaimed = winningsClaimable[winner];
456         if (unclaimed) {
457           winningsClaimable[winner] = false;
458           if (!winner.send(prizeValue)) {
459             // If I can't send you money, dumbshit, you get to claim it on your own.
460             // maybe next time don't use a contract or try to exploit the game.
461             // Regardless, you're on your own.  Happy birthday to the ground.
462             winningsClaimable[winner] = true;
463           }
464         }
465       }
466     }
467   }
468 
469   /**
470    * Returns true if it's after the draw, and either there are no winners, or all the winners have been paid.
471    * @return {bool}
472    */
473   function paidOut() constant returns(bool) {
474     // no need to use the modifier on this function, just do the same check
475     // and return false instead.
476     if (winningNumbersPicked == false) {
477       return false;
478     }
479     if (winners.length > 0) {
480       bool claimed = true;
481       // if anyone hasn't been sent or claimed their earnings,
482       // we still have money to pay out.
483       for (uint i = 0; claimed && i < winners.length; i++) {
484         claimed = claimed && !winningsClaimable[winners[i]];
485       }
486       return claimed;
487     } else {
488       // no winners, nothing to pay.
489       return true;
490     }
491   }
492 
493   /**
494    * Winners can claim their own prizes using this.  If they do
495    * something stupid like use a contract, this gives them a
496    * a second chance at withdrawing their funds.  Note that
497    * this shares an interlock with `distributeWinnings`.
498    */
499   function claimPrize() afterDraw {
500     if (winningsClaimable[msg.sender] == false) {
501       // get. out!
502       throw;
503     }
504     winningsClaimable[msg.sender] = false;
505     if (!msg.sender.send(prizeValue)) {
506       // you really are a dumbshit, aren't you.
507       throw;
508     }
509   }
510 
511   // Man! What do I look like? A charity case?
512   // Please.
513   // You can't buy me, hot dog man!
514   function () {
515     throw;
516   }
517 }
518 
519 contract LotteryRoundFactoryInterface {
520   string public VERSION;
521   function transferOwnership(address newOwner);
522 }
523 
524 contract LotteryRoundFactoryInterfaceV1 is LotteryRoundFactoryInterface {
525   function createRound(bytes32 _saltHash, bytes32 _saltNHash) payable returns(address);
526 }
527 
528 contract LotteryRoundFactory is LotteryRoundFactoryInterfaceV1, Owned {
529 
530   string public VERSION = '0.1.1';
531 
532   event LotteryRoundCreated(
533     address newRound,
534     string version
535   );
536 
537   /**
538    * Creates a new round, and sets the secret (hashed) salt and proof of N.
539    * @param _saltHash     Hashed salt
540    * @param _saltNHash    Hashed proof of N
541    */
542   function createRound(
543     bytes32 _saltHash,
544     bytes32 _saltNHash
545   ) payable onlyOwner returns(address) {
546     LotteryRound newRound;
547     if (msg.value > 0) {
548       newRound = (new LotteryRound).value(msg.value)(
549         _saltHash,
550         _saltNHash
551       );
552     } else {
553       newRound = new LotteryRound(
554         _saltHash,
555         _saltNHash
556       );
557     }
558 
559     if (newRound == LotteryRound(0)) {
560       throw;
561     }
562     newRound.transferOwnership(owner);
563     LotteryRoundCreated(address(newRound), VERSION);
564     return address(newRound);
565   }
566 
567   // Man, this ain't my dad!
568   // This is a cell phone!
569   function () {
570     throw;
571   }
572 }