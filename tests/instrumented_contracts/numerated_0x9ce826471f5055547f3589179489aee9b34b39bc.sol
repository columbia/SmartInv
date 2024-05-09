1 // solium-disable linebreak-style
2 pragma solidity ^0.4.24;
3 
4 contract AceDice {
5   /// *** Constants section
6   
7   // Each bet is deducted 1% in favour of the house, but no less than some minimum.
8   // The lower bound is dictated by gas costs of the settleBet transaction, providing
9   // headroom for up to 10 Gwei prices.
10   uint constant HOUSE_EDGE_PERCENT = 2;
11   uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
12   
13   // Bets lower than this amount do not participate in jackpot rolls (and are
14   // not deducted JACKPOT_FEE).
15   uint constant MIN_JACKPOT_BET = 0.1 ether;
16   
17   // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
18   uint constant JACKPOT_MODULO = 1000;
19   uint constant JACKPOT_FEE = 0.001 ether;
20   
21   // There is minimum and maximum bets.
22   uint constant MIN_BET = 0.01 ether;
23   uint constant MAX_AMOUNT = 300000 ether;
24   
25   // Modulo is a number of equiprobable outcomes in a game:
26   // - 2 for coin flip
27   // - 6 for dice
28   // - 6*6 = 36 for double dice
29   // - 100 for etheroll
30   // - 37 for roulette
31   // etc.
32   // It's called so because 256-bit entropy is treated like a huge integer and
33   // the remainder of its division by modulo is considered bet outcome.
34   // uint constant MAX_MODULO = 100;
35   
36   // For modulos below this threshold rolls are checked against a bit mask,
37   // thus allowing betting on any combination of outcomes. For example, given
38   // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
39   // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
40   // limit is used, allowing betting on any outcome in [0, N) range.
41   //
42   // The specific value is dictated by the fact that 256-bit intermediate
43   // multiplication result allows implementing population count efficiently
44   // for numbers that are up to 42 bits, and 40 is the highest multiple of
45   // eight below 42.
46   uint constant MAX_MASK_MODULO = 40;
47   
48   // This is a check on bet mask overflow.
49   uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
50   
51   // EVM BLOCKHASH opcode can query no further than 256 blocks into the
52   // past. Given that settleBet uses block hash of placeBet as one of
53   // complementary entropy sources, we cannot process bets older than this
54   // threshold. On rare occasions dice2.win croupier may fail to invoke
55   // settleBet in this timespan due to technical issues or extreme Ethereum
56   // congestion; such bets can be refunded via invoking refundBet.
57   uint constant BET_EXPIRATION_BLOCKS = 250;
58   
59   // Some deliberately invalid address to initialize the secret signer with.
60   // Forces maintainers to invoke setSecretSigner before processing any bets.
61   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
62   
63   // Standard contract ownership transfer.
64   address public owner;
65   address private nextOwner;
66   
67   // Adjustable max bet profit. Used to cap bets against dynamic odds.
68   uint public maxProfit;
69   
70   // The address corresponding to a private key used to sign placeBet commits.
71   address public secretSigner;
72   
73   // Accumulated jackpot fund.
74   uint128 public jackpotSize;
75   
76   uint public todaysRewardSize;
77 
78   // Funds that are locked in potentially winning bets. Prevents contract from
79   // committing to bets it cannot pay out.
80   uint128 public lockedInBets;
81   
82   // A structure representing a single bet.
83   struct Bet {
84     // Wager amount in wei.
85     uint amount;
86     // Modulo of a game.
87     // uint8 modulo;
88     // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
89     // and used instead of mask for games with modulo > MAX_MASK_MODULO.
90     uint8 rollUnder;
91     // Block number of placeBet tx.
92     uint40 placeBlockNumber;
93     // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
94     uint40 mask;
95     // Address of a gambler, used to pay out winning bets.
96     address gambler;
97     // Address of inviter
98     address inviter;
99   }
100 
101   struct Profile{
102     // picture index of profile avatar
103     uint avatarIndex;
104     // nickname of user
105     string nickName;
106   }
107   
108   // Mapping from commits to all currently active & processed bets.
109   mapping (uint => Bet) bets;
110   // Mapping for accumuldated bet amount and users
111   mapping (address => uint) accuBetAmount;
112 
113   mapping (address => Profile) profiles;
114   
115   // Croupier account.
116   address public croupier;
117   
118   // Events that are issued to make statistic recovery easier.
119   event FailedPayment(address indexed beneficiary, uint amount);
120   event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
121   event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
122   event VIPPayback(address indexed beneficiary, uint amount);
123   
124   // This event is emitted in placeBet to record commit in the logs.
125   event Commit(uint commit);
126 
127   // 오늘의 랭킹 보상 지급 이벤트
128   event TodaysRankingPayment(address indexed beneficiary, uint amount);
129   
130   // Constructor. Deliberately does not take any parameters.
131   constructor () public {
132     owner = msg.sender;
133     secretSigner = DUMMY_ADDRESS;
134     croupier = DUMMY_ADDRESS;
135   }
136   
137   // Standard modifier on methods invokable only by contract owner.
138   modifier onlyOwner {
139     require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
140     _;
141   }
142   
143   // Standard modifier on methods invokable only by contract owner.
144   modifier onlyCroupier {
145     require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
146     _;
147   }
148   
149   // Standard contract ownership transfer implementation,
150   function approveNextOwner(address _nextOwner) external onlyOwner {
151     require (_nextOwner != owner, "Cannot approve current owner.");
152     nextOwner = _nextOwner;
153   }
154   
155   function acceptNextOwner() external {
156     require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
157     owner = nextOwner;
158   }
159   
160   // Fallback function deliberately left empty. It's primary use case
161   // is to top up the bank roll.
162   function () public payable {
163   }
164   
165   // See comment for "secretSigner" variable.
166   function setSecretSigner(address newSecretSigner) external onlyOwner {
167     secretSigner = newSecretSigner;
168   }
169   
170   function getSecretSigner() external onlyOwner view returns(address){
171     return secretSigner;
172   }
173   
174   // Change the croupier address.
175   function setCroupier(address newCroupier) external onlyOwner {
176     croupier = newCroupier;
177   }
178   
179   // Change max bet reward. Setting this to zero effectively disables betting.
180   function setMaxProfit(uint _maxProfit) public onlyOwner {
181     require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
182     maxProfit = _maxProfit;
183   }
184   
185   // This function is used to bump up the jackpot fund. Cannot be used to lower it.
186   function increaseJackpot(uint increaseAmount) external onlyOwner {
187     require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
188     require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
189     jackpotSize += uint128(increaseAmount);
190   }
191   
192   // Funds withdrawal to cover costs of dice2.win operation.
193   function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
194     require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
195     require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
196     sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0);
197   }
198   
199   // Contract may be destroyed only when there are no ongoing bets,
200   // either settled or refunded. All funds are transferred to contract owner.
201   function kill() external onlyOwner {
202     require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
203     selfdestruct(owner);
204   }
205   
206   function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
207     return abi.encodePacked(uint40(commitLastBlock), commit);
208   }
209   
210   function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
211     // Check that commit is valid - it has not expired and its signature is valid.
212     require (block.number <= commitLastBlock, "Commit has expired.");
213     //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
214     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
215     bytes memory message = encodePacketCommit(commitLastBlock, commit);
216     bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
217     require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
218   }
219   
220   /// *** Betting logic
221   
222   // Bet states:
223   // amount == 0 && gambler == 0 - 'clean' (can place a bet)
224   // amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
225   // amount == 0 && gambler != 0 - 'processed' (can clean storage)
226   //
227   // NOTE: Storage cleaning is not implemented in this contract version; it will be added
228   // with the next upgrade to prevent polluting Ethereum state with expired bets.
229   
230   // Bet placing transaction - issued by the player.
231   // betMask - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
232   // [0, betMask) for larger modulos.
233   // modulo - game modulo.
234   // commitLastBlock - number of the maximum block where "commit" is still considered valid.
235   // commit - Keccak256 hash of some secret "reveal" random number, to be supplied
236   // by the dice2.win croupier bot in the settleBet transaction. Supplying
237   // "commit" ensures that "reveal" cannot be changed behind the scenes
238   // after placeBet have been mined.
239   // r, s - components of ECDSA signature of (commitLastBlock, commit). v is
240   // guaranteed to always equal 27.
241   //
242   // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
243   // the 'bets' mapping.
244   //
245   // Commits are signed with a block limit to ensure that they are used at most once - otherwise
246   // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
247   // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
248   // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
249   function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
250     // Check that the bet is in 'clean' state.
251     Bet storage bet = bets[commit];
252     require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
253     
254     // Validate input data ranges.
255     uint amount = msg.value;
256     //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
257     require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
258     require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
259     
260     verifyCommit(commitLastBlock, commit, v, r, s);
261     
262     // uint rollUnder;
263     uint mask;
264     
265     // if (modulo <= MAX_MASK_MODULO) {
266     //   // Small modulo games specify bet outcomes via bit mask.
267     //   // rollUnder is a number of 1 bits in this mask (population count).
268     //   // This magic looking formula is an efficient way to compute population
269     //   // count on EVM for numbers below 2**40. For detailed proof consult
270     //   // the dice2.win whitepaper.
271     //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
272     //   mask = betMask;
273     //   } else {
274         // Larger modulos specify the right edge of half-open interval of
275         // winning bet outcomes.
276         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
277         // rollUnder = betMask;
278       // }
279       
280       // Winning amount and jackpot increase.
281       uint possibleWinAmount;
282       uint jackpotFee;
283       
284       (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
285       
286       // Enforce max profit limit.
287       require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
288       
289       // Lock funds.
290       lockedInBets += uint128(possibleWinAmount);
291       jackpotSize += uint128(jackpotFee);
292       
293       // Check whether contract has enough funds to process this bet.
294       require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
295       
296       // Record commit in logs.
297       emit Commit(commit);
298 
299       // Store bet parameters on blockchain.
300       bet.amount = amount;
301       // bet.modulo = uint8(modulo);
302       bet.rollUnder = uint8(betMask);
303       bet.placeBlockNumber = uint40(block.number);
304       bet.mask = uint40(mask);
305       bet.gambler = msg.sender;
306       
307       uint accuAmount = accuBetAmount[msg.sender];
308       accuAmount = accuAmount + amount;
309       accuBetAmount[msg.sender] = accuAmount;
310     }
311 
312     function applyVIPLevel(address gambler, uint amount) private {
313       uint accuAmount = accuBetAmount[gambler];
314       uint rate;
315       if(accuAmount >= 30 ether && accuAmount < 150 ether){
316         rate = 1;
317       } else if(accuAmount >= 150 ether && accuAmount < 300 ether){
318         rate = 2;
319       } else if(accuAmount >= 300 ether && accuAmount < 1500 ether){
320         rate = 4;
321       } else if(accuAmount >= 1500 ether && accuAmount < 3000 ether){
322         rate = 6;
323       } else if(accuAmount >= 3000 ether && accuAmount < 15000 ether){
324         rate = 8;
325       } else if(accuAmount >= 15000 ether && accuAmount < 30000 ether){
326         rate = 10;
327       } else if(accuAmount >= 30000 ether && accuAmount < 150000 ether){
328         rate = 12;
329       } else if(accuAmount >= 150000 ether){
330         rate = 15;
331       } else{
332         return;
333       }
334 
335       uint vipPayback = amount * rate / 10000;
336       if(gambler.send(vipPayback)){
337         emit VIPPayback(gambler, vipPayback);
338       }
339     }
340 
341     function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address inviter) external payable {
342       // Check that the bet is in 'clean' state.
343       Bet storage bet = bets[commit];
344       require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
345       
346       // Validate input data ranges.
347       uint amount = msg.value;
348       // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
349       require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
350       require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
351       require (address(this) != inviter && inviter != address(0), "cannot invite mysql");
352       
353       verifyCommit(commitLastBlock, commit, v, r, s);
354       
355       // uint rollUnder;
356       uint mask;
357       
358       // if (modulo <= MAX_MASK_MODULO) {
359       //   // Small modulo games specify bet outcomes via bit mask.
360       //   // rollUnder is a number of 1 bits in this mask (population count).
361       //   // This magic looking formula is an efficient way to compute population
362       //   // count on EVM for numbers below 2**40. For detailed proof consult
363       //   // the dice2.win whitepaper.
364       //   rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
365       //   mask = betMask;
366       // } else {
367         // Larger modulos specify the right edge of half-open interval of
368         // winning bet outcomes.
369         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
370         // rollUnder = betMask;
371       // }
372       
373       // Winning amount and jackpot increase.
374       uint possibleWinAmount;
375       uint jackpotFee;
376       
377       (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
378       
379       // Enforce max profit limit.
380       require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
381       
382       // Lock funds.
383       lockedInBets += uint128(possibleWinAmount);
384       jackpotSize += uint128(jackpotFee);
385       
386       // Check whether contract has enough funds to process this bet.
387       require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
388       
389       // Record commit in logs.
390       emit Commit(commit);
391 
392       // Store bet parameters on blockchain.
393       bet.amount = amount;
394       // bet.modulo = uint8(modulo);
395       bet.rollUnder = uint8(betMask);
396       bet.placeBlockNumber = uint40(block.number);
397       bet.mask = uint40(mask);
398       bet.gambler = msg.sender;
399       bet.inviter = inviter;
400 
401       uint accuAmount = accuBetAmount[msg.sender];
402       accuAmount = accuAmount + amount;
403       accuBetAmount[msg.sender] = accuAmount;
404     }
405 
406     function getMyAccuAmount() external view returns (uint){
407       return accuBetAmount[msg.sender];
408     }
409     
410     // This is the method used to settle 99% of bets. To process a bet with a specific
411     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
412     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
413     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
414     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
415       uint commit = uint(keccak256(abi.encodePacked(reveal)));
416       
417       Bet storage bet = bets[commit];
418       uint placeBlockNumber = bet.placeBlockNumber;
419       
420       // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
421       require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
422       require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
423       require (blockhash(placeBlockNumber) == blockHash);
424       
425       // Settle bet using reveal and blockHash as entropy sources.
426       settleBetCommon(bet, reveal, blockHash);
427     }
428     
429     // This method is used to settle a bet that was mined into an uncle block. At this
430     // point the player was shown some bet outcome, but the blockhash at placeBet height
431     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
432     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
433     // indeed was present on-chain at some point.
434     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
435       // "commit" for bet settlement can only be obtained by hashing a "reveal".
436       uint commit = uint(keccak256(abi.encodePacked(reveal)));
437       
438       Bet storage bet = bets[commit];
439       
440       // Check that canonical block hash can still be verified.
441       require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
442       
443       // Verify placeBet receipt.
444       requireCorrectReceipt(4 + 32 + 32 + 4);
445       
446       // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
447       bytes32 canonicalHash;
448       bytes32 uncleHash;
449       (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
450       require (blockhash(canonicalBlockNumber) == canonicalHash);
451       
452       // Settle bet using reveal and uncleHash as entropy sources.
453       settleBetCommon(bet, reveal, uncleHash);
454     }
455     
456     // Common settlement code for settleBet & settleBetUncleMerkleProof.
457     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
458       // Fetch bet parameters into local variables (to save gas).
459       uint amount = bet.amount;
460       // uint modulo = bet.modulo;
461       uint rollUnder = bet.rollUnder;
462       address gambler = bet.gambler;
463       
464       // Check that bet is in 'active' state.
465       require (amount != 0, "Bet should be in an 'active' state");
466 
467       applyVIPLevel(gambler, amount);
468       
469       // Move bet into 'processed' state already.
470       bet.amount = 0;
471       
472       // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
473       // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
474       // preimage is intractable), and house is unable to alter the "reveal" after
475       // placeBet have been mined (as Keccak256 collision finding is also intractable).
476       bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
477       
478       // Do a roll by taking a modulo of entropy. Compute winning amount.
479       uint modulo = 100;
480       uint dice = uint(entropy) % modulo;
481       
482       uint diceWinAmount;
483       uint _jackpotFee;
484       (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, rollUnder);
485       
486       uint diceWin = 0;
487       uint jackpotWin = 0;
488       
489       // Determine dice outcome.
490       if (modulo <= MAX_MASK_MODULO) {
491         // For small modulo games, check the outcome against a bit mask.
492         if ((2 ** dice) & bet.mask != 0) {
493           diceWin = diceWinAmount;
494         }
495         
496         } else {
497           // For larger modulos, check inclusion into half-open interval.
498           if (dice < rollUnder) {
499             diceWin = diceWinAmount;
500           }
501           
502         }
503         
504         // Unlock the bet amount, regardless of the outcome.
505         lockedInBets -= uint128(diceWinAmount);
506         
507         // Roll for a jackpot (if eligible).
508         if (amount >= MIN_JACKPOT_BET) {
509           // The second modulo, statistically independent from the "main" dice roll.
510           // Effectively you are playing two games at once!
511           // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
512           
513           // Bingo!
514           if ((uint(entropy) / modulo) % JACKPOT_MODULO == 0) {
515             jackpotWin = jackpotSize;
516             jackpotSize = 0;
517           }
518         }
519         
520         // Log jackpot win.
521         if (jackpotWin > 0) {
522           emit JackpotPayment(gambler, jackpotWin, dice, rollUnder, amount);
523         }
524         
525         if(bet.inviter != address(0)){
526           // 친구 초대하면 친구한대 15% 때어줌
527           // uint inviterFee = amount * HOUSE_EDGE_PERCENT / 100 * 15 /100;
528           bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 15 /100);
529         }
530         todaysRewardSize += amount * HOUSE_EDGE_PERCENT / 100 * 9 /100;
531         // Send the funds to gambler.
532         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, dice, rollUnder, amount);
533       }
534       
535       // Refund transaction - return the bet amount of a roll that was not processed in a
536       // due timeframe. Processing such blocks is not possible due to EVM limitations (see
537       // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
538       // in a situation like this, just contact the dice2.win support, however nothing
539       // precludes you from invoking this method yourself.
540       function refundBet(uint commit) external {
541         // Check that bet is in 'active' state.
542         Bet storage bet = bets[commit];
543         uint amount = bet.amount;
544         
545         require (amount != 0, "Bet should be in an 'active' state");
546         
547         // Check that bet has already expired.
548         require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
549         
550         // Move bet into 'processed' state, release funds.
551         bet.amount = 0;
552         
553         uint diceWinAmount;
554         uint jackpotFee;
555         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.rollUnder);
556         
557         lockedInBets -= uint128(diceWinAmount);
558         jackpotSize -= uint128(jackpotFee);
559         
560         // Send the refund.
561         sendFunds(bet.gambler, amount, amount, 0, 0, 0);
562       }
563       
564       // Get the expected win amount after house edge is subtracted.
565       function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
566         require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
567         
568         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
569         
570         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
571         
572         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
573           houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
574         }
575         
576         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
577         winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
578       }
579       
580       // Helper routine to process the payment.
581       function sendFunds(address beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) private {
582         if (beneficiary.send(amount)) {
583           emit Payment(beneficiary, successLogAmount, dice, rollUnder, betAmount);
584           } else {
585             emit FailedPayment(beneficiary, amount);
586           }
587         }
588         
589         // This are some constants making O(1) population count in placeBet possible.
590         // See whitepaper for intuition and proofs behind it.
591         uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
592         uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
593         uint constant POPCNT_MODULO = 0x3F;
594         
595         // *** Merkle proofs.
596         
597         // This helpers are used to verify cryptographic proofs of placeBet inclusion into
598         // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
599         // compromising the security of the smart contract. Proof data is appended to the input data
600         // in a simple prefix length format and does not adhere to the ABI.
601         // Invariants checked:
602         // - receipt trie entry contains a (1) successful transaction (2) directed at this smart
603         // contract (3) containing commit as a payload.
604         // - receipt trie entry is a part of a valid merkle proof of a block header
605         // - the block header is a part of uncle list of some block on canonical chain
606         // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
607         // Read the whitepaper for details.
608         
609         // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
610         // beginning in the calldata.
611         function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
612           // (Safe) assumption - nobody will write into RAM during this method invocation.
613         uint scratchBuf1; assembly { scratchBuf1 := mload(0x40) }
614         
615         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
616         
617         // Verify merkle proofs up to uncle block header. Calldata layout is:
618         // - 2 byte big-endian slice length
619         // - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
620         // - followed by the current slice verbatim
621         for (;; offset += blobLength) {
622         assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
623         if (blobLength == 0) {
624           // Zero slice length marks the end of uncle proof.
625           break;
626         }
627         
628       assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
629       require (shift + 32 <= blobLength, "Shift bounds check.");
630       
631       offset += 4;
632     assembly { hashSlot := calldataload(add(offset, shift)) }
633     require (hashSlot == 0, "Non-empty hash slot.");
634     
635     assembly {
636       calldatacopy(scratchBuf1, offset, blobLength)
637       mstore(add(scratchBuf1, shift), seedHash)
638       seedHash := sha3(scratchBuf1, blobLength)
639       uncleHeaderLength := blobLength
640     }
641   }
642   
643   // At this moment the uncle hash is known.
644   uncleHash = bytes32(seedHash);
645   
646   // Construct the uncle list of a canonical block.
647   uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
648 uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
649         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
650         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
651 
652         offset += 6;
653         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
654         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
655 
656         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
657 
658         offset += unclesLength;
659 
660         // Verify the canonical block header using the computed sha3Uncles.
661         assembly {
662             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
663             shift := and(calldataload(sub(offset, 28)), 0xffff)
664         }
665         require (shift + 32 <= blobLength, "Shift bounds check.");
666 
667         offset += 4;
668         assembly { hashSlot := calldataload(add(offset, shift)) }
669         require (hashSlot == 0, "Non-empty hash slot.");
670 
671         assembly {
672             calldatacopy(scratchBuf1, offset, blobLength)
673             mstore(add(scratchBuf1, shift), seedHash)
674 
675             // At this moment the canonical block hash is known.
676             blockHash := sha3(scratchBuf1, blobLength)
677         }
678     }
679 
680     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
681     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
682     function requireCorrectReceipt(uint offset) view private {
683         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
684 
685         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
686         offset += leafHeaderByte - 0xf6;
687 
688         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
689 
690         if (pathHeaderByte <= 0x7f) {
691             offset += 1;
692 
693         } else {
694             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
695             offset += pathHeaderByte - 0x7f;
696         }
697 
698         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
699         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
700         offset += 3;
701 
702         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
703         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
704         offset += 3;
705 
706         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
707         require (statusByte == 0x1, "Status should be success.");
708         offset += 1;
709 
710         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
711         if (cumGasHeaderByte <= 0x7f) {
712             offset += 1;
713 
714         } else {
715             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
716             offset += cumGasHeaderByte - 0x7f;
717         }
718 
719         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
720         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
721         offset += 256 + 3;
722 
723         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
724         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
725         offset += 2;
726 
727         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
728         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
729         offset += 2;
730 
731         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
732         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
733 
734         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
735         require (logAddress == uint(address(this)));
736     }
737 
738     // Memory copy.
739     function memcpy(uint dest, uint src, uint len) pure private {
740         // Full 32 byte words
741         for(; len >= 32; len -= 32) {
742             assembly { mstore(dest, mload(src)) }
743             dest += 32; src += 32;
744         }
745 
746         // Remaining bytes
747         uint mask = 256 ** (32 - len) - 1;
748         assembly {
749             let srcpart := and(mload(src), not(mask))
750             let destpart := and(mload(dest), mask)
751             mstore(dest, or(destpart, srcpart))
752         }
753     }
754 
755     function thisBalance() public view returns(uint) {
756         return address(this).balance;
757     }
758 
759     function setAvatarIndex(uint index) external{
760       require (index >=0 && index <= 100, "avatar index should be in range");
761       Profile storage profile = profiles[msg.sender];
762       profile.avatarIndex = index;
763     }
764 
765     function setNickName(string nickName) external{
766       Profile storage profile = profiles[msg.sender];
767       profile.nickName = nickName;
768     }
769 
770     function getProfile() external view returns(uint, string){
771       Profile storage profile = profiles[msg.sender];
772       return (profile.avatarIndex, profile.nickName);
773     }
774 
775     function payTodayReward(address to, uint rate) external onlyOwner {
776       uint prize = todaysRewardSize * rate / 10000;
777       todaysRewardSize = todaysRewardSize - prize;
778       if(to.send(prize)){
779         emit TodaysRankingPayment(to, prize);
780       }
781     }
782 }