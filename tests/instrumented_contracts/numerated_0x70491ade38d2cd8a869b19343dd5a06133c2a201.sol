1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     require(c >= a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     _transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param spender The address which will spend the funds.
168    * @param value The amount of tokens to be spent.
169    */
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = value;
174     emit Approval(msg.sender, spender, value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param from address The address which you want to send tokens from
181    * @param to address The address which you want to transfer to
182    * @param value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address from,
186     address to,
187     uint256 value
188   )
189     public
190     returns (bool)
191   {
192     require(value <= _allowed[from][msg.sender]);
193 
194     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195     _transfer(from, to, value);
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212     public
213     returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218       _allowed[msg.sender][spender].add(addedValue));
219     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseAllowance(
233     address spender,
234     uint256 subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].sub(subtractedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248   * @dev Transfer token for a specified addresses
249   * @param from The address to transfer from.
250   * @param to The address to transfer to.
251   * @param value The amount to be transferred.
252   */
253   function _transfer(address from, address to, uint256 value) internal {
254     require(value <= _balances[from]);
255     require(to != address(0));
256 
257     _balances[from] = _balances[from].sub(value);
258     _balances[to] = _balances[to].add(value);
259     emit Transfer(from, to, value);
260   }
261 
262   /**
263    * @dev Internal function that mints an amount of the token and assigns it to
264    * an account. This encapsulates the modification of balances such that the
265    * proper events are emitted.
266    * @param account The account that will receive the created tokens.
267    * @param value The amount that will be created.
268    */
269   function _mint(address account, uint256 value) internal {
270     require(account != 0);
271     _totalSupply = _totalSupply.add(value);
272     _balances[account] = _balances[account].add(value);
273     emit Transfer(address(0), account, value);
274   }
275 
276   /**
277    * @dev Internal function that burns an amount of the token of a given
278    * account.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burn(address account, uint256 value) internal {
283     require(account != 0);
284     require(value <= _balances[account]);
285 
286     _totalSupply = _totalSupply.sub(value);
287     _balances[account] = _balances[account].sub(value);
288     emit Transfer(account, address(0), value);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal burn function.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burnFrom(address account, uint256 value) internal {
299     require(value <= _allowed[account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
304       value);
305     _burn(account, value);
306   }
307 }
308 
309 
310 
311 // GoatClash contract
312 // Version 1.0
313 // The Goat Herd @ https://goat.cash
314 //
315 // Based on dice2.win Solidity contract. Extended to use ERC20 tokens in place of ETH, 
316 // betting logic and proofs unchanged. Original comments follow this text.
317 // Note modified and added lines marked with comments.
318 //
319 // * dice2.win - fair games that pay Ether. Version 5.
320 //
321 // * Ethereum smart contract, deployed at 0xD1CEeeeee83F8bCF3BEDad437202b6154E9F5405.
322 //
323 // * Uses hybrid commit-reveal + block hash random number generation that is immune
324 //   to tampering by players, house and miners. Apart from being fully transparent,
325 //   this also allows arbitrarily high bets.
326 //
327 // * Refer to https://dice2.win/whitepaper.pdf for detailed description and proofs.
328 contract GoatClash  {
329     // ADDED ERC20 token reference and setter
330     ERC20 private _token;
331     
332     function token() public view returns(ERC20) {
333         return _token;
334     }
335 
336     function setToken(address erc20Token) external onlyOwner {
337         _token = ERC20(erc20Token);
338     }
339 
340     // *** Constants section
341 
342     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
343     // The lower bound is dictated by gas costs of the settleBet transaction, providing
344     // headroom for up to 10 Gwei prices.
345     uint constant HOUSE_EDGE_PERCENT = 2;
346     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 1;
347     // GOAT MODIFIED: changed min amount, this will cost us gas, boooo..
348     //uint constant HOUSE_EDGE_PERCENT = 1;
349     //uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
350 
351     // Bets lower than this amount do not participate in jackpot rolls (and are
352     // not deducted JACKPOT_FEE).
353     // GOAT MODIFIED: changed min amount from 0.1 ether
354     uint constant MIN_JACKPOT_BET = 5000 * (10 ** 18);
355 
356     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
357     uint constant JACKPOT_MODULO = 1000;
358     // GOAT MODIFIED: changed fee amount
359     uint constant JACKPOT_FEE = 100 * (10 ** 18);
360 
361     // There is minimum and maximum bets.
362     // GOAT MODIFIED
363     // uint constant MIN_BET = 0.01 ether;
364     // uint constant MAX_AMOUNT = 300000 ether;
365     uint constant MIN_BET = 1 * (10 ** 18);
366     uint constant MAX_AMOUNT = 1000000 * (10 ** 18);
367 
368     // Modulo is a number of equiprobable outcomes in a game:
369     //  - 2 for coin flip
370     //  - 6 for dice
371     //  - 6*6 = 36 for double dice
372     //  - 100 for etheroll
373     //  - 37 for roulette
374     //  etc.
375     // It's called so because 256-bit entropy is treated like a huge integer and
376     // the remainder of its division by modulo is considered bet outcome.
377     uint constant MAX_MODULO = 100;
378 
379     // For modulos below this threshold rolls are checked against a bit mask,
380     // thus allowing betting on any combination of outcomes. For example, given
381     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
382     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
383     // limit is used, allowing betting on any outcome in [0, N) range.
384     //
385     // The specific value is dictated by the fact that 256-bit intermediate
386     // multiplication result allows implementing population count efficiently
387     // for numbers that are up to 42 bits, and 40 is the highest multiple of
388     // eight below 42.
389     uint constant MAX_MASK_MODULO = 40;
390 
391     // This is a check on bet mask overflow.
392     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
393 
394     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
395     // past. Given that settleBet uses block hash of placeBet as one of
396     // complementary entropy sources, we cannot process bets older than this
397     // threshold. On rare occasions dice2.win croupier may fail to invoke
398     // settleBet in this timespan due to technical issues or extreme Ethereum
399     // congestion; such bets can be refunded via invoking refundBet.
400     uint constant BET_EXPIRATION_BLOCKS = 250;
401 
402     // Some deliberately invalid address to initialize the secret signer with.
403     // Forces maintainers to invoke setSecretSigner before processing any bets.
404     address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
405 
406     // Standard contract ownership transfer.
407     address public owner;
408     address private nextOwner;
409 
410     // Adjustable max bet profit. Used to cap bets against dynamic odds.
411     uint public maxProfit;
412 
413     // The address corresponding to a private key used to sign placeBet commits.
414     address public secretSigner;
415 
416     // Accumulated jackpot fund.
417     uint128 public jackpotSize;
418 
419     // Funds that are locked in potentially winning bets. Prevents contract from
420     // committing to bets it cannot pay out.
421     uint128 public lockedInBets;
422 
423     // A structure representing a single bet.
424     struct Bet {
425         // Wager amount in wei.
426         uint amount;
427         // Modulo of a game.
428         uint8 modulo;
429         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
430         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
431         uint8 rollUnder;
432         // Block number of placeBet tx.
433         uint40 placeBlockNumber;
434         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
435         uint40 mask;
436         // Address of a gambler, used to pay out winning bets.
437         address gambler;
438     }
439 
440     // Mapping from commits to all currently active & processed bets.
441     mapping (uint => Bet) bets;
442 
443     // Croupier account.
444     address public croupier;
445 
446     // Events that are issued to make statistic recovery easier.
447     event FailedPayment(address indexed beneficiary, uint amount);
448     event Payment(address indexed beneficiary, uint amount);
449     event JackpotPayment(address indexed beneficiary, uint amount);
450    
451     // This event is emitted in placeBet to record commit in the logs.
452     event Commit(uint commit);
453     
454     // Constructor. Deliberately does not take any parameters.
455     constructor () public {
456         owner = msg.sender;
457         secretSigner = DUMMY_ADDRESS;
458         croupier = DUMMY_ADDRESS;
459     }
460 
461     // Standard modifier on methods invokable only by contract owner.
462     modifier onlyOwner {
463         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
464         _;
465     }
466 
467     // Standard modifier on methods invokable only by contract owner.
468     modifier onlyCroupier {
469         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
470         _;
471     }
472 
473     // Standard contract ownership transfer implementation,
474     function approveNextOwner(address _nextOwner) external onlyOwner {
475         require (_nextOwner != owner, "Cannot approve current owner.");
476         nextOwner = _nextOwner;
477     }
478 
479     function acceptNextOwner() external {
480         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
481         owner = nextOwner;
482     }
483 
484     // Fallback function deliberately left empty. It's primary use case
485     // is to top up the bank roll.
486     function () public payable {
487     }
488 
489     // See comment for "secretSigner" variable.
490     function setSecretSigner(address newSecretSigner) external onlyOwner {
491         secretSigner = newSecretSigner;
492     }
493 
494     // Change the croupier address.
495     function setCroupier(address newCroupier) external onlyOwner {
496         croupier = newCroupier;
497     }
498 
499     // Change max bet reward. Setting this to zero effectively disables betting.
500     function setMaxProfit(uint _maxProfit) public onlyOwner {
501         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
502         maxProfit = _maxProfit;
503     }
504 
505     // MODIFIED
506     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
507     function increaseJackpot(uint increaseAmount) external onlyOwner {
508         require (increaseAmount <= _token.balanceOf(address(this)), "Increase amount larger than balance.");
509         require (jackpotSize + lockedInBets + increaseAmount <= _token.balanceOf(address(this)), "Not enough funds.");
510         jackpotSize += uint128(increaseAmount);
511     }
512 
513     // MODIFIED
514     // Funds withdrawal to cover costs of dice2.win operation.
515     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
516         require (withdrawAmount <= _token.balanceOf(address(this)), "Cannot withdraw more than balance.");
517         require (jackpotSize + lockedInBets + withdrawAmount <= _token.balanceOf(address(this)), "Not enough funds.");
518         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
519     }
520 
521     // MODIFIED
522     // Contract may be destroyed only when there are no ongoing bets,
523     // either settled or refunded. All funds are transferred to contract owner.
524     function kill() external onlyOwner {
525         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
526         
527         // Any remaining funds locked in the Jackpot (which cannot be decreased) will only be withdrawn when contract is killed
528         sendFunds(owner, _token.balanceOf(address(this)), _token.balanceOf(address(this)));
529 
530         selfdestruct(owner);
531     }
532 
533     /// *** Betting logic
534 
535     // Bet states:
536     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
537     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
538     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
539     //
540     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
541     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
542 
543     // Bet placing transaction - issued by the player.
544     //  amount          - ADDED: Token bet amount (amount must be already 'approved' by player)
545     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
546     //                    [0, betMask) for larger modulos.
547     //  modulo          - game modulo.
548     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
549     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
550     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
551     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
552     //                    after placeBet have been mined.
553     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
554     //                    guaranteed to always equal 27.
555     //
556     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
557     // the 'bets' mapping.
558     //
559     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
560     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
561     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
562     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
563     function placeBet(uint amount, uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external {         
564         // Check that the bet is in 'clean' state.
565         Bet storage bet = bets[commit];
566         require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
567 
568         // Validate input data ranges.
569         // MODIFIED: Using amount parameter not msg.value;
570         //uint amount = msg.value;
571         require (amount <= _token.allowance(msg.sender, address(this)), "Bet amount not inserted.");
572         require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
573         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
574         require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
575 
576         // Check that commit is valid - it has not expired and its signature is valid.
577         require (block.number <= commitLastBlock, "Commit has expired.");
578         bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
579         require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
580 
581         uint rollUnder;
582         uint mask;
583 
584         if (modulo <= MAX_MASK_MODULO) {
585             // Small modulo games specify bet outcomes via bit mask.
586             // rollUnder is a number of 1 bits in this mask (population count).
587             // This magic looking formula is an efficient way to compute population
588             // count on EVM for numbers below 2**40. For detailed proof consult
589             // the dice2.win whitepaper.
590             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
591             mask = betMask;
592         } else {
593             // Larger modulos specify the right edge of half-open interval of
594             // winning bet outcomes.
595             require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
596             rollUnder = betMask;
597         }
598 
599         // Winning amount and jackpot increase.
600         uint possibleWinAmount;
601         uint jackpotFee;
602 
603         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
604 
605         // Enforce max profit limit.
606         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
607 
608         // Lock funds.
609         lockedInBets += uint128(possibleWinAmount);
610         jackpotSize += uint128(jackpotFee);
611 
612         // Check whether contract has enough funds to process this bet.
613         // Modified: Updated to ERC20
614         require (jackpotSize + lockedInBets <= _token.balanceOf(address(this)), "Cannot afford to lose this bet.");
615 
616         // ADDED deduct from approved tokens - moved to settleBet
617         //deductFunds(msg.sender, amount);
618 
619         // Record commit in logs.
620         emit Commit(commit);
621 
622         // Store bet parameters on blockchain.
623         bet.amount = amount;
624         bet.modulo = uint8(modulo);
625         bet.rollUnder = uint8(rollUnder);
626         bet.placeBlockNumber = uint40(block.number);
627         bet.mask = uint40(mask);
628         bet.gambler = msg.sender;
629     }
630 
631     // This is the method used to settle 99% of bets. To process a bet with a specific
632     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
633     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
634     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
635     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
636         uint commit = uint(keccak256(abi.encodePacked(reveal)));
637 
638         Bet storage bet = bets[commit];
639         uint placeBlockNumber = bet.placeBlockNumber;
640 
641         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
642         require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
643         require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
644         require (blockhash(placeBlockNumber) == blockHash, "Blockhash does not match.");
645         require (bet.amount <= _token.allowance(bet.gambler, address(this)), "Bet amount not inserted."); 
646 
647         // Settle bet using reveal and blockHash as entropy sources.
648         settleBetCommon(bet, reveal, blockHash);
649     }
650 
651     // This method is used to settle a bet that was mined into an uncle block. At this
652     // point the player was shown some bet outcome, but the blockhash at placeBet height
653     // is different because of Ethereum chain reorg. We supply a full merkle proof of the
654     // placeBet transaction receipt to provide untamperable evidence that uncle block hash
655     // indeed was present on-chain at some point.
656     function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
657         // "commit" for bet settlement can only be obtained by hashing a "reveal".
658         uint commit = uint(keccak256(abi.encodePacked(reveal)));
659 
660         Bet storage bet = bets[commit];
661 
662         // Check that canonical block hash can still be verified.
663         require (block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
664 
665         // Verify placeBet receipt.
666         requireCorrectReceipt(4 + 32 + 32 + 4);
667 
668         // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
669         bytes32 canonicalHash;
670         bytes32 uncleHash;
671         (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
672         require (blockhash(canonicalBlockNumber) == canonicalHash);
673 
674         // Settle bet using reveal and uncleHash as entropy sources.
675         settleBetCommon(bet, reveal, uncleHash);
676     }
677 
678     // Common settlement code for settleBet & settleBetUncleMerkleProof.
679     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
680         // Fetch bet parameters into local variables (to save gas).
681         uint amount = bet.amount;
682         uint modulo = bet.modulo;
683         uint rollUnder = bet.rollUnder;
684         address gambler = bet.gambler;
685 
686         // Check that bet is in 'active' state.
687         require (amount != 0, "Bet should be in an 'active' state");
688 
689         // Move bet into 'processed' state already.
690         bet.amount = 0;
691 
692         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
693         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
694         // preimage is intractable), and house is unable to alter the "reveal" after
695         // placeBet have been mined (as Keccak256 collision finding is also intractable).
696         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
697 
698         // Do a roll by taking a modulo of entropy. Compute winning amount.
699         uint dice = uint(entropy) % modulo;
700 
701         uint diceWinAmount;
702         uint _jackpotFee;
703         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
704 
705         uint diceWin = 0;
706         uint jackpotWin = 0;
707 
708         // Determine dice outcome.
709         if (modulo <= MAX_MASK_MODULO) {
710             // For small modulo games, check the outcome against a bit mask.
711             if ((2 ** dice) & bet.mask != 0) {
712                 diceWin = diceWinAmount;
713             }
714 
715         } else {
716             // For larger modulos, check inclusion into half-open interval.
717             if (dice < rollUnder) {
718                 diceWin = diceWinAmount;
719             }
720 
721         }
722 
723         // Unlock the bet amount, regardless of the outcome.
724         lockedInBets -= uint128(diceWinAmount);
725 
726         // Roll for a jackpot (if eligible).
727         if (amount >= MIN_JACKPOT_BET) {
728             // The second modulo, statistically independent from the "main" dice roll.
729             // Effectively you are playing two games at once!
730             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
731 
732             // Bingo!
733             if (jackpotRng == 0) {
734                 jackpotWin = jackpotSize;
735                 jackpotSize = 0;
736             }
737         }
738 
739         // Log jackpot win.
740         if (jackpotWin > 0) {
741             emit JackpotPayment(gambler, jackpotWin);
742         }
743 
744         // ADDED: Perform payment/deduct here to reduce gas costs (I guess this reduces contract interactions and therefore dApp ratings or something) 
745         // Lost bet
746         if (diceWin + jackpotWin == 0) {
747             deductFunds(gambler, amount);
748         }
749         else {
750             // MODIFIED: only send funds on win (less orig amount)
751             // Send the funds to gambler.
752             sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin - amount, diceWin);
753         }
754 
755         // Send the funds to gambler.
756         //sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
757     }
758 
759     // MODIFIED: Removed as redundant due to settle bet changes - replaced with cancelBet()
760     // Refund transaction - return the bet amount of a roll that was not processed in a
761     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
762     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
763     // in a situation like this, just contact the dice2.win support, however nothing
764     // precludes you from invoking this method yourself.
765     // function refundBet(uint commit) external {
766     //     // Check that bet is in 'active' state.
767     //     Bet storage bet = bets[commit];
768     //     uint amount = bet.amount;
769 
770     //     require (amount != 0, "Bet should be in an 'active' state");
771 
772     //     // Check that bet has already expired.
773     //     require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
774 
775     //     // Move bet into 'processed' state, release funds.
776     //     bet.amount = 0;
777 
778     //     uint diceWinAmount;
779     //     uint jackpotFee;
780     //     (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
781 
782     //     lockedInBets -= uint128(diceWinAmount);
783     //     jackpotSize -= uint128(jackpotFee);
784 
785     //     // Send the refund.
786     //     sendFunds(bet.gambler, amount, amount);
787     // }
788 
789     // ADDED
790     // A bet which failed to be settled in time (see refund transaction comments) will still 
791     // count in locked in values and must be corrected.
792     function cancelBet(uint commit) external onlyCroupier {
793         // Check that bet is in 'active' state.
794         Bet storage bet = bets[commit];
795         uint amount = bet.amount;
796 
797         require (amount != 0, "Bet should be in an 'active' state");
798 
799         // Check that bet has already expired.
800         //require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
801 
802         // Move bet into 'processed' state, release funds.
803         bet.amount = 0;
804 
805         uint diceWinAmount;
806         uint jackpotFee;
807         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
808 
809         lockedInBets -= uint128(diceWinAmount);
810         jackpotSize -= uint128(jackpotFee);
811     }
812 
813     // Get the expected win amount after house edge is subtracted.
814     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
815         require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
816 
817         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
818 
819         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
820 
821         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
822             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
823         }
824 
825         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
826         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
827     }
828 
829     // Helper routine to process the payment.
830     // function sendFunds(address beneficiary, uint amount, uint successLogAmount) internal {
831     //     if (beneficiary.send(amount)) {
832     //         emit Payment(beneficiary, successLogAmount);
833     //     } else {
834     //         emit FailedPayment(beneficiary, amount);
835     //     }
836     // }
837 
838     // MODIFIED
839     // Override helper routine to process the payment in ERC20    
840     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
841         if (_token.transfer(beneficiary, amount)) {        
842             emit Payment(beneficiary, successLogAmount);
843         } else {
844             emit FailedPayment(beneficiary, amount);
845         }
846     }
847 
848     // ADDED
849     // Helper routine to process the payment in ERC20    
850     function deductFunds(address player, uint amount) private {
851         if (_token.transferFrom(player, address(this), amount)) {
852             emit Payment(address(this), amount);
853         } else {
854             emit FailedPayment(address(this), amount);
855         }
856     }
857 
858     // This are some constants making O(1) population count in placeBet possible.
859     // See whitepaper for intuition and proofs behind it.
860     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
861     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
862     uint constant POPCNT_MODULO = 0x3F;
863 
864     // *** Merkle proofs.
865 
866     // This helpers are used to verify cryptographic proofs of placeBet inclusion into
867     // uncle blocks. They are used to prevent bet outcome changing on Ethereum reorgs without
868     // compromising the security of the smart contract. Proof data is appended to the input data
869     // in a simple prefix length format and does not adhere to the ABI.
870     // Invariants checked:
871     //  - receipt trie entry contains a (1) successful transaction (2) directed at this smart
872     //    contract (3) containing commit as a payload.
873     //  - receipt trie entry is a part of a valid merkle proof of a block header
874     //  - the block header is a part of uncle list of some block on canonical chain
875     // The implementation is optimized for gas cost and relies on the specifics of Ethereum internal data structures.
876     // Read the whitepaper for details.
877 
878     // Helper to verify a full merkle proof starting from some seedHash (usually commit). "offset" is the location of the proof
879     // beginning in the calldata.
880     function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
881         // (Safe) assumption - nobody will write into RAM during this method invocation.
882         uint scratchBuf1;  assembly { scratchBuf1 := mload(0x40) }
883 
884         uint uncleHeaderLength; uint blobLength; uint shift; uint hashSlot;
885 
886         // Verify merkle proofs up to uncle block header. Calldata layout is:
887         //  - 2 byte big-endian slice length
888         //  - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
889         //  - followed by the current slice verbatim
890         for (;; offset += blobLength) {
891             assembly { blobLength := and(calldataload(sub(offset, 30)), 0xffff) }
892             if (blobLength == 0) {
893                 // Zero slice length marks the end of uncle proof.
894                 break;
895             }
896 
897             assembly { shift := and(calldataload(sub(offset, 28)), 0xffff) }
898             require (shift + 32 <= blobLength, "Shift bounds check.");
899 
900             offset += 4;
901             assembly { hashSlot := calldataload(add(offset, shift)) }
902             require (hashSlot == 0, "Non-empty hash slot.");
903 
904             assembly {
905                 calldatacopy(scratchBuf1, offset, blobLength)
906                 mstore(add(scratchBuf1, shift), seedHash)
907                 seedHash := sha3(scratchBuf1, blobLength)
908                 uncleHeaderLength := blobLength
909             }
910         }
911 
912         // At this moment the uncle hash is known.
913         uncleHash = bytes32(seedHash);
914 
915         // Construct the uncle list of a canonical block.
916         uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
917         uint unclesLength; assembly { unclesLength := and(calldataload(sub(offset, 28)), 0xffff) }
918         uint unclesShift;  assembly { unclesShift := and(calldataload(sub(offset, 26)), 0xffff) }
919         require (unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");
920 
921         offset += 6;
922         assembly { calldatacopy(scratchBuf2, offset, unclesLength) }
923         memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);
924 
925         assembly { seedHash := sha3(scratchBuf2, unclesLength) }
926 
927         offset += unclesLength;
928 
929         // Verify the canonical block header using the computed sha3Uncles.
930         assembly {
931             blobLength := and(calldataload(sub(offset, 30)), 0xffff)
932             shift := and(calldataload(sub(offset, 28)), 0xffff)
933         }
934         require (shift + 32 <= blobLength, "Shift bounds check.");
935 
936         offset += 4;
937         assembly { hashSlot := calldataload(add(offset, shift)) }
938         require (hashSlot == 0, "Non-empty hash slot.");
939 
940         assembly {
941             calldatacopy(scratchBuf1, offset, blobLength)
942             mstore(add(scratchBuf1, shift), seedHash)
943 
944             // At this moment the canonical block hash is known.
945             blockHash := sha3(scratchBuf1, blobLength)
946         }
947     }
948 
949     // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
950     // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
951     function requireCorrectReceipt(uint offset) view private {
952         uint leafHeaderByte; assembly { leafHeaderByte := byte(0, calldataload(offset)) }
953 
954         require (leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
955         offset += leafHeaderByte - 0xf6;
956 
957         uint pathHeaderByte; assembly { pathHeaderByte := byte(0, calldataload(offset)) }
958 
959         if (pathHeaderByte <= 0x7f) {
960             offset += 1;
961 
962         } else {
963             require (pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
964             offset += pathHeaderByte - 0x7f;
965         }
966 
967         uint receiptStringHeaderByte; assembly { receiptStringHeaderByte := byte(0, calldataload(offset)) }
968         require (receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
969         offset += 3;
970 
971         uint receiptHeaderByte; assembly { receiptHeaderByte := byte(0, calldataload(offset)) }
972         require (receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
973         offset += 3;
974 
975         uint statusByte; assembly { statusByte := byte(0, calldataload(offset)) }
976         require (statusByte == 0x1, "Status should be success.");
977         offset += 1;
978 
979         uint cumGasHeaderByte; assembly { cumGasHeaderByte := byte(0, calldataload(offset)) }
980         if (cumGasHeaderByte <= 0x7f) {
981             offset += 1;
982 
983         } else {
984             require (cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
985             offset += cumGasHeaderByte - 0x7f;
986         }
987 
988         uint bloomHeaderByte; assembly { bloomHeaderByte := byte(0, calldataload(offset)) }
989         require (bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
990         offset += 256 + 3;
991 
992         uint logsListHeaderByte; assembly { logsListHeaderByte := byte(0, calldataload(offset)) }
993         require (logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
994         offset += 2;
995 
996         uint logEntryHeaderByte; assembly { logEntryHeaderByte := byte(0, calldataload(offset)) }
997         require (logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
998         offset += 2;
999 
1000         uint addressHeaderByte; assembly { addressHeaderByte := byte(0, calldataload(offset)) }
1001         require (addressHeaderByte == 0x94, "Address is 20 bytes long.");
1002 
1003         uint logAddress; assembly { logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff) }
1004         require (logAddress == uint(address(this)));
1005     }
1006 
1007     // Memory copy.
1008     function memcpy(uint dest, uint src, uint len) pure private {
1009         // Full 32 byte words
1010         for(; len >= 32; len -= 32) {
1011             assembly { mstore(dest, mload(src)) }
1012             dest += 32; src += 32;
1013         }
1014 
1015         // Remaining bytes
1016         uint mask = 256 ** (32 - len) - 1;
1017         assembly {
1018             let srcpart := and(mload(src), not(mask))
1019             let destpart := and(mload(dest), mask)
1020             mstore(dest, or(destpart, srcpart))
1021         }
1022     }
1023 }