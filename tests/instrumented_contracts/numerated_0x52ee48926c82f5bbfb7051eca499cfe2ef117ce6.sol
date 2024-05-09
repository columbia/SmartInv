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
88   string constant VERSION = '0.1.2';
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
238   function generatePseudoRand(bytes32 seed) internal returns(bytes32) {
239     uint8 pseudoRandomOffset = uint8(uint256(sha256(
240       seed,
241       block.difficulty,
242       block.coinbase,
243       block.timestamp,
244       accumulatedEntropy
245     )) & 0xff);
246     // WARNING: This assumes block.number > 256... If block.number < 256, the below block.blockhash could return 0
247     // This is probably only an issue in testing, but shouldn't be a problem there.
248     uint256 pseudoRandomBlock = block.number - pseudoRandomOffset - 1;
249     bytes32 pseudoRand = sha3(
250       block.number,
251       block.blockhash(pseudoRandomBlock),
252       block.difficulty,
253       block.timestamp,
254       accumulatedEntropy
255     );
256     accumulatedEntropy = sha3(accumulatedEntropy, pseudoRand);
257     return pseudoRand;
258   }
259 
260   /**
261    * Buy a ticket with pre-selected picks
262    * @param picks User's picks.
263    */
264   function pickTicket(bytes4 picks) payable beforeClose {
265     if (msg.value != TICKET_PRICE) {
266       throw;
267     }
268     // don't allow invalid picks.
269     for (uint8 i = 0; i < 4; i++) {
270       if (picks[i] & PICK_MASK != picks[i]) {
271         throw;
272       }
273     }
274     tickets[picks].push(msg.sender);
275     nTickets++;
276     generatePseudoRand(bytes32(picks)); // advance the accumulated entropy
277     LotteryRoundDraw(msg.sender, picks);
278   }
279 
280   /**
281    * Interal function to generate valid picks.  Used by both the random
282    * ticket functionality, as well as when generating winning picks.
283    * Even though the picks are a fixed-width byte array, each pick is
284    * chosen separately (e.g. a bytes4 will result in 4 separate sha3 hashes
285    * used as sources).
286    *
287    * Masks the first byte of the seed to use as an offset into the next PRNG,
288    * then replaces the seed with the new PRNG.  Pulls a single byte from the
289    * resultant offset, masks it to be valid, then adds it to the accumulator.
290    *
291    * @param seed  The PRNG seed used to pick the numbers.
292    */
293   function pickValues(bytes32 seed) internal returns (bytes4) {
294     bytes4 picks;
295     uint8 offset;
296     for (uint8 i = 0; i < 4; i++) {
297       offset = uint8(seed[0]) & 0x1f;
298       seed = sha3(seed, msg.sender);
299       picks = (picks >> 8) | bytes1(seed[offset] & PICK_MASK);
300     }
301     return picks;
302   }
303 
304   /**
305    * Picks a random ticket, using the internal PRNG and accumulated entropy
306    */
307   function randomTicket() payable beforeClose {
308     if (msg.value != TICKET_PRICE) {
309       throw;
310     }
311     bytes32 pseudoRand = generatePseudoRand(bytes32(msg.sender));
312     bytes4 picks = pickValues(pseudoRand);
313     tickets[picks].push(msg.sender);
314     nTickets++;
315     LotteryRoundDraw(msg.sender, picks);
316   }
317 
318   /**
319    * Public means to prove the salt after numbers are picked.  Not technically necessary
320    * for this to be external, because it will be called during the round close process.
321    * If the hidden entropy parameters don't match, the contract will refuse to pick
322    * numbers or close.
323    *
324    * @param salt          Hidden entropy source
325    * @param N             Secret value proving how to obtain the hashed entropy from the source.
326    */
327   function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool) {
328     // Proof-of-N:
329     bytes32 _saltNHash = sha3(salt, N, salt);
330     if (_saltNHash != saltNHash) {
331       return false;
332     }
333 
334     // Proof-of-salt:
335     bytes32 _saltHash = sha3(salt);
336     for (var i = 1; i < N; i++) {
337       _saltHash = sha3(_saltHash);
338     }
339     if (_saltHash != saltHash) {
340       return false;
341     }
342     return true;
343   }
344 
345   /**
346    * Internal function to handle tabulating the winners, including edge cases around
347    * duplicate winners.  Split out into its own method partially to enable proper
348    * testing.
349    *
350    * @param salt          Hidden entropy source.  Emitted here
351    * @param N             Key to the hidden entropy source.
352    * @param winningPicks  The winning picks.
353    */
354   function finalizeRound(bytes32 salt, uint8 N, bytes4 winningPicks) internal {
355     winningNumbers = winningPicks;
356     winningNumbersPicked = true;
357     LotteryRoundCompleted(salt, N, winningNumbers, this.balance);
358 
359     var _winners = tickets[winningNumbers];
360     // if we have winners:
361     if (_winners.length > 0) {
362       // let's dedupe and broadcast the winners before figuring out the prize pool situation.
363       for (uint i = 0; i < _winners.length; i++) {
364         var winner = _winners[i];
365         if (!winningsClaimable[winner]) {
366           winners.push(winner);
367           winningsClaimable[winner] = true;
368           LotteryRoundWinner(winner, winningNumbers);
369         }
370       }
371       // now let's wrap this up by finalizing the prize pool value:
372       // There may be some rounding errors in here, but it should only amount to a couple wei.
373       prizePool = this.balance * PAYOUT_FRACTION / 1000;
374       prizeValue = prizePool / winners.length;
375 
376       // Note that the owner doesn't get to claim a fee until the game is won.
377       ownerFee = this.balance - prizePool;
378     }
379     // we done.
380   }
381 
382   /**
383    * Reveal the secret sources of entropy, then use them to pick winning numbers.
384    *
385    * Note that by using no dynamic (e.g. blockhash-based) sources of entropy,
386    * censoring this transaction will not change the final outcome of the picks.
387    *
388    * @param salt          Hidden entropy.
389    * @param N             Number of times to hash the hidden entropy to produce the value provided at creation.
390    */
391   function closeGame(bytes32 salt, uint8 N) onlyOwner beforeDraw {
392     // Don't allow picking numbers multiple times.
393     if (winningNumbersPicked == true) {
394       throw;
395     }
396 
397     // prove the pre-selected salt is actually legit.
398     if (proofOfSalt(salt, N) != true) {
399       throw;
400     }
401 
402     bytes32 pseudoRand = sha3(
403       salt,
404       nTickets,
405       accumulatedEntropy
406     );
407     finalizeRound(salt, N, pickValues(pseudoRand));
408   }
409 
410   /**
411    * Sends the owner's fee to the specified address.  Note that the
412    * owner can only be paid if there actually was a winner. In the
413    * event no one wins, the entire balance is carried over into the
414    * next round.  No double-dipping here.
415    * @param payout        Address to send the owner fee to.
416    */
417   function claimOwnerFee(address payout) onlyOwner afterDraw {
418     if (ownerFee > 0) {
419       uint256 value = ownerFee;
420       ownerFee = 0;
421       if (!payout.send(value)) {
422         throw;
423       }
424     }
425   }
426 
427   /**
428    * Used to withdraw the balance when the round is completed.  This
429    * only works if there are either no winners, or all winners + the
430    * owner have been paid.
431    */
432   function withdraw() onlyOwner afterDraw {
433     if (paidOut() && ownerFee == 0) {
434       if (!owner.send(this.balance)) {
435         throw;
436       }
437     }
438   }
439 
440   /**
441    * Same as above.  This is mostly here because it's overriding the method
442    * inherited from `Owned`
443    */
444   function shutdown() onlyOwner afterDraw {
445     if (paidOut() && ownerFee == 0) {
446       selfdestruct(owner);
447     }
448   }
449 
450   /**
451    * Attempt to pay the winners, if any.  If any `send`s fail, the winner
452    * will have to collect their winnings on their own.
453    */
454   function distributeWinnings() onlyOwner afterDraw {
455     if (winners.length > 0) {
456       for (uint i = 0; i < winners.length; i++) {
457         address winner = winners[i];
458         bool unclaimed = winningsClaimable[winner];
459         if (unclaimed) {
460           winningsClaimable[winner] = false;
461           if (!winner.send(prizeValue)) {
462             // If I can't send you money, dumbshit, you get to claim it on your own.
463             // maybe next time don't use a contract or try to exploit the game.
464             // Regardless, you're on your own.  Happy birthday to the ground.
465             winningsClaimable[winner] = true;
466           }
467         }
468       }
469     }
470   }
471 
472   /**
473    * Returns true if it's after the draw, and either there are no winners, or all the winners have been paid.
474    * @return {bool}
475    */
476   function paidOut() constant returns(bool) {
477     // no need to use the modifier on this function, just do the same check
478     // and return false instead.
479     if (winningNumbersPicked == false) {
480       return false;
481     }
482     if (winners.length > 0) {
483       bool claimed = true;
484       // if anyone hasn't been sent or claimed their earnings,
485       // we still have money to pay out.
486       for (uint i = 0; claimed && i < winners.length; i++) {
487         claimed = claimed && !winningsClaimable[winners[i]];
488       }
489       return claimed;
490     } else {
491       // no winners, nothing to pay.
492       return true;
493     }
494   }
495 
496   /**
497    * Winners can claim their own prizes using this.  If they do
498    * something stupid like use a contract, this gives them a
499    * a second chance at withdrawing their funds.  Note that
500    * this shares an interlock with `distributeWinnings`.
501    */
502   function claimPrize() afterDraw {
503     if (winningsClaimable[msg.sender] == false) {
504       // get. out!
505       throw;
506     }
507     winningsClaimable[msg.sender] = false;
508     if (!msg.sender.send(prizeValue)) {
509       // you really are a dumbshit, aren't you.
510       throw;
511     }
512   }
513 
514   // Man! What do I look like? A charity case?
515   // Please.
516   // You can't buy me, hot dog man!
517   function () {
518     throw;
519   }
520 }
521 
522 contract LotteryRoundFactoryInterface {
523   string public VERSION;
524   function transferOwnership(address newOwner);
525 }
526 
527 contract LotteryRoundFactoryInterfaceV1 is LotteryRoundFactoryInterface {
528   function createRound(bytes32 _saltHash, bytes32 _saltNHash) payable returns(address);
529 }
530 
531 contract LotteryRoundFactory is LotteryRoundFactoryInterfaceV1, Owned {
532 
533   string public VERSION = '0.1.2';
534 
535   event LotteryRoundCreated(
536     address newRound,
537     string version
538   );
539 
540   /**
541    * Creates a new round, and sets the secret (hashed) salt and proof of N.
542    * @param _saltHash     Hashed salt
543    * @param _saltNHash    Hashed proof of N
544    */
545   function createRound(
546     bytes32 _saltHash,
547     bytes32 _saltNHash
548   ) payable onlyOwner returns(address) {
549     LotteryRound newRound;
550     if (msg.value > 0) {
551       newRound = (new LotteryRound).value(msg.value)(
552         _saltHash,
553         _saltNHash
554       );
555     } else {
556       newRound = new LotteryRound(
557         _saltHash,
558         _saltNHash
559       );
560     }
561 
562     if (newRound == LotteryRound(0)) {
563       throw;
564     }
565     newRound.transferOwnership(owner);
566     LotteryRoundCreated(address(newRound), VERSION);
567     return address(newRound);
568   }
569 
570   // Man, this ain't my dad!
571   // This is a cell phone!
572   function () {
573     throw;
574   }
575 }