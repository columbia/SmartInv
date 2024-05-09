1 pragma solidity ^0.5.0;
2 
3 /**
4   * @title DSMath
5   * @author MakerDAO
6   * @notice Safe math contracts from Maker.
7   */
8 contract DSMath {
9     function add(uint x, uint y) internal pure returns (uint z) {
10         require((z = x + y) >= x);
11     }
12     function sub(uint x, uint y) internal pure returns (uint z) {
13         require((z = x - y) <= x);
14     }
15     function mul(uint x, uint y) internal pure returns (uint z) {
16         require(y == 0 || (z = x * y) / y == x);
17     }
18 
19     function min(uint x, uint y) internal pure returns (uint z) {
20         return x <= y ? x : y;
21     }
22     function max(uint x, uint y) internal pure returns (uint z) {
23         return x >= y ? x : y;
24     }
25     function imin(int x, int y) internal pure returns (int z) {
26         return x <= y ? x : y;
27     }
28     function imax(int x, int y) internal pure returns (int z) {
29         return x >= y ? x : y;
30     }
31 
32     uint constant WAD = 10 ** 18;
33     uint constant RAY = 10 ** 27;
34 
35     function wmul(uint x, uint y) internal pure returns (uint z) {
36         z = add(mul(x, y), WAD / 2) / WAD;
37     }
38     function rmul(uint x, uint y) internal pure returns (uint z) {
39         z = add(mul(x, y), RAY / 2) / RAY;
40     }
41     function wdiv(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, WAD), y / 2) / y;
43     }
44     function rdiv(uint x, uint y) internal pure returns (uint z) {
45         z = add(mul(x, RAY), y / 2) / y;
46     }
47 
48     // This famous algorithm is called "exponentiation by squaring"
49     // and calculates x^n with x as fixed-point and n as regular unsigned.
50     //
51     // It's O(log n), instead of O(n) for naive repeated multiplication.
52     //
53     // These facts are why it works:
54     //
55     //  If n is even, then x^n = (x^2)^(n/2).
56     //  If n is odd,  then x^n = x * x^(n-1),
57     //   and applying the equation for even x gives
58     //    x^n = x * (x^2)^((n-1) / 2).
59     //
60     //  Also, EVM division is flooring and
61     //    floor[(n-1) / 2] = floor[n / 2].
62     //
63     function rpow(uint x, uint n) internal pure returns (uint z) {
64         z = n % 2 != 0 ? x : RAY;
65 
66         for (n /= 2; n != 0; n /= 2) {
67             x = rmul(x, x);
68 
69             if (n % 2 != 0) {
70                 z = rmul(z, x);
71             }
72         }
73     }
74 }
75 
76 /**
77   * @title Owned
78   * @author Gavin Wood?
79   * @notice Primitive owner properties, modifiers and methods for a single
80   *     to own a particular contract.
81   */
82 contract Owned {
83     address public owner = msg.sender;
84 
85     modifier isOwner {
86         assert(msg.sender == owner); _;
87     }
88 
89     function changeOwner(address account) external isOwner {
90         owner = account;
91     }
92 }
93 
94 /**
95   * @title Pausable
96   * @author MakerDAO?
97   * @notice Primitive events, methods, properties for a contract which can be
98         paused by a single owner.
99   */
100 contract Pausable is Owned {
101     event Pause();
102     event Unpause();
103 
104     bool public paused;
105 
106     modifier pausable {
107         assert(!paused); _;
108     }
109 
110     function pause() external isOwner {
111         paused = true;
112 
113         emit Pause();
114     }
115 
116     function unpause() external isOwner {
117         paused = false;
118 
119         emit Unpause();
120     }
121 }
122 
123 /**
124   * @title BurnerAccount
125   * @author UnityCoin Team
126   * @notice Primitive events, methods, properties for a contract which has a
127           special burner account that is Owned by a single account.
128   */
129 contract BurnerAccount is Owned {
130     address public burner;
131 
132     modifier isOwnerOrBurner {
133         assert(msg.sender == burner || msg.sender == owner); _;
134     }
135 
136     function changeBurner(address account) external isOwner {
137         burner = account;
138     }
139 }
140 
141 /**
142   * @title IntervalBased
143   * @author UnityCoin Team
144   * @notice Primitive events, methods, properties for a contract which has a
145   *        interval system, that can be changed in-flight.
146   *
147   *        Here we create a system in which any valid unixtimestamp can reduce
148   *        down to a specific interval number, based on a start time, duration
149   *        and offset.
150   *
151   *        Interval Derivation
152   *        number = offset + ((timestamp - start time) / intervalDuration)
153   *
154   *        Note, when your changing the interval params in flight, we must
155   *        set the offset to the most current interval number, as to not
156   *        disrupt previously used interval numbers / mechanics
157   */
158 contract IntervalBased is DSMath {
159     // the start interval
160     uint256 public intervalStartTimestamp;
161 
162     // interval duration (e.g. 1 days)
163     uint256 public intervalDuration;
164 
165     // the max amount of intervals that can be processed for interest claim
166     uint256 public intervalMaximum;
167 
168     // interval offset
169     uint256 public intervalOffset;
170 
171     function changeDuration(uint256 duration) internal {
172       // protect againt unecessary change of offset and starttimestamp
173       if (duration == intervalDuration) { return; }
174 
175       // offset all previous intervals
176       intervalOffset = intervalNumber(block.timestamp);
177 
178       // set new duration
179       intervalDuration = duration;
180 
181       // restart timestamp to current
182       intervalStartTimestamp = block.timestamp;
183     }
184 
185     // get the interval number from start position
186     // every timestamp should have an interval past the start timestamp..
187     function intervalNumber(uint256 timestamp) public view returns(uint256 number) {
188         return add(intervalOffset, sub(timestamp, intervalStartTimestamp) / intervalDuration);
189     }
190 }
191 
192 /**
193   * @title ERC20Events
194   * @author EIP20 Authors
195   * @notice Primitive events for the ERC20 event specification.
196   */
197 contract ERC20Events {
198     event Transfer(address indexed from, address indexed to, uint256 tokens);
199     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
200 }
201 
202 /**
203   * @title ERC20
204   * @author EIP/ERC20 Authors
205   * @author BokkyPooBah / Bok Consulting Pty Ltd 2018.
206   * @notice The ERC20 standard contract interface.
207   */
208 contract ERC20 is ERC20Events {
209     function totalSupply() external view returns (uint);
210     function balanceOf(address tokenOwner) public view returns (uint);
211     function allowance(address tokenOwner, address spender) external view returns (uint);
212 
213     function approve(address spender, uint amount) public returns (bool);
214     function transfer(address to, uint amount) external returns (bool);
215     function transferFrom(
216         address from, address to, uint amount
217     ) public returns (bool);
218 }
219 
220 /**
221   * @title ERC20Token
222   * @author BokkyPooBah / Bok Consulting Pty Ltd 2018.
223   * @author UnityCoin Team
224   * @author MakerDAO
225   * @notice An ERC20 Token implimentation based roughly off of MakerDAO's
226   *       version DSToken.
227   */
228 contract ERC20Token is DSMath, ERC20 {
229     // Standard EIP20 Name, Symbol, Decimals
230     string public symbol = "USDC";
231     string public name = "UnityCoinTest";
232     string public version = "1.0.0";
233     uint8 public decimals = 18;
234 
235     // Balances for each account
236     mapping(address => uint256) balances;
237 
238     // Owner of account approves the transfer of an amount to another account
239     mapping(address => mapping (address => uint256)) approvals;
240 
241     // Standard EIP20: BalanceOf, Transfer, TransferFrom, Allow, Allowance methods..
242     // Get the token balance for account `tokenOwner`
243     function balanceOf(address tokenOwner) public view returns (uint balance) {
244         return balances[tokenOwner];
245     }
246 
247     // Transfer the balance from owner's account to another account
248     function transfer(address to, uint256 tokens) external returns (bool success) {
249         return transferFrom(msg.sender, to, tokens);
250     }
251 
252     // Send `tokens` amount of tokens from address `from` to address `to`
253     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
254     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
255     // fees in sub-currencies; the command should fail unless the from account has
256     // deliberately authorized the sender of the message via some mechanism; we propose
257     // these standardized APIs for approval:
258     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
259         if (from != msg.sender) {
260             approvals[from][msg.sender] = sub(approvals[from][msg.sender], tokens);
261         }
262 
263         balances[from] = sub(balances[from], tokens);
264         balances[to] = add(balances[to], tokens);
265 
266         emit Transfer(from, to, tokens);
267         return true;
268     }
269 
270     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
271     // If this function is called again it overwrites the current allowance with _value.
272     function approve(address spender, uint256 tokens) public returns (bool success) {
273         approvals[msg.sender][spender] = tokens;
274 
275         emit Approval(msg.sender, spender, tokens);
276         return true;
277     }
278 
279     // ------------------------------------------------------------------------
280     // Returns the amount of tokens approved by the owner that can be
281     // transferred to the spender's account
282     // ------------------------------------------------------------------------
283     function allowance(address tokenOwner, address spender) external view returns (uint remaining) {
284         return approvals[tokenOwner][spender];
285     }
286 }
287 
288 /**
289   * @title InterestRateBased
290   * @author UnityCoin Team
291   * @notice A compount interest module which allows for the recording of balance
292   *       events and interest rate changes.
293   *
294   *       Compound Interest Aglo:
295   *       compound interest owed = (principle * ( 1 + Rate / 100 ) * N) – principle;
296   *
297   *       This module uses the interval system IntervalBased.
298   *       The module is time based and thus we accept that miners can manipulate
299   *       time.
300   *
301   *       Rate's are specified (as per DSMath imp.) in 10 pow 27 always.
302   *       Rates are recorded in an array `interestRates` and thus are indexed.
303   *
304   *       Everytime a balance is recorded, we also make sure to set an updatable
305   *       pointer to the most recent InterestRate index `intervalToInterestIndex`.
306   *
307   *       This module provides a way to calculate compound interest owed,
308   *       given the interest rates and balance records are recoded properly.
309   */
310 contract InterestRateBased is IntervalBased {
311     // Interest Rate Record
312     struct InterestRate {
313         uint256 interval;
314         uint256 rate; // >= 10 ** 27
315     }
316 
317     // Interval to interest rate
318     InterestRate[] public interestRates;
319 
320     // uint256(interval) => uint256(interest index)
321     mapping(uint256 => uint256) public intervalToInterestIndex;
322 
323     // Balance Records
324     struct BalanceRecord {
325         uint256 interval;
326         uint256 intervalOffset;
327         uint256 balance;
328     }
329 
330     // address(token holder) => uint256(interval) => BalanceChange
331     mapping(address => BalanceRecord[]) public balanceRecords;
332 
333     // address(tokenOwner) => uint256(balance index)
334     mapping(address => uint256) public lastClaimedBalanceIndex;
335 
336     // include balance of method, is ERC20 compliant for tokens
337     function balanceOf(address tokenOwner) public view returns (uint);
338 
339     // VIEW: get current interest rate
340     function latestInterestRate() external view returns (uint256 rateAsRay, uint256 asOfInterval) {
341         uint256 latestRateIndex = interestRates.length > 0 ? sub(interestRates.length, 1) : 0;
342 
343         return (interestRates[latestRateIndex].rate, interestRates[latestRateIndex].interval);
344     }
345 
346     // getters
347     function numInterestRates() public view returns (uint256) {
348       return interestRates.length;
349     }
350 
351     // getters
352     function numBalanceRecords(address tokenOwner) public view returns (uint256) {
353       return balanceRecords[tokenOwner].length;
354     }
355 
356     // interest owed
357     function interestOwed(address tokenOwner)
358         public
359         view
360         returns (uint256 amountOwed, uint256 balanceIndex, uint256 interval) {
361 
362         // check for no balance records..
363         if (balanceRecords[tokenOwner].length == 0) {
364           return (0, 0, 0);
365         }
366 
367         // balance index
368         amountOwed = 0;
369         balanceIndex = lastClaimedBalanceIndex[tokenOwner];
370         interval = balanceRecords[tokenOwner][balanceIndex].intervalOffset;
371 
372         // current principle and interest rate
373         uint256 principle = 0; // current principle value
374         uint256 interestRate = 0; // current interest rate
375 
376         // interval markers and interval offset
377         uint256 nextBalanceInterval = interval; // set to starting interval for setup
378         uint256 nextInterestInterval = interval; // set to starting interval for setup
379 
380         // enforce interval maximum, last claim offset difference with max
381         assert(sub(intervalNumber(block.timestamp), intervalOffset) < intervalMaximum);
382 
383         // this for loop should only hit either interest or balance change records, and in theory process only
384         // what is required to calculate compound interest with general computaitonal efficiency
385         // yes, maybe in the future adding a MIN here would be good..
386         while (interval < intervalNumber(block.timestamp)) {
387 
388             // set interest rates for given interval
389             if (interval == nextInterestInterval) {
390                 uint256 interestIndex = intervalToInterestIndex[interval];
391 
392                 // set rate with current interval
393                 interestRate = interestRates[interestIndex].rate;
394 
395                 // check if look ahead next index is greater than rates length, if so, go to max interval, otherwise next up
396                 nextInterestInterval = add(interestIndex, 1) >= interestRates.length
397                     ? intervalNumber(block.timestamp)
398                     : interestRates[add(interestIndex, 1)].interval;
399             }
400 
401             // setup principle with whats on record at given interval
402             if (interval == nextBalanceInterval) {
403                 // get current principle at current balance index, add with amount previously owed in interest
404                 principle = add(balanceRecords[tokenOwner][balanceIndex].balance, amountOwed);
405 
406                 // increase balance index ahead now that we have the balance
407                 balanceIndex = add(balanceIndex, 1);
408 
409                 // check if the new blance index exceeds, set next interval to limit or next interval on record
410                 nextBalanceInterval = balanceIndex >= balanceRecords[tokenOwner].length
411                     ? intervalNumber(block.timestamp)
412                     : balanceRecords[tokenOwner][balanceIndex].interval;
413             }
414 
415             // apply compound interest to principle, subtract original principle, add to amount owed
416             amountOwed = add(amountOwed, sub(wmul(principle,
417                 rpow(interestRate,
418                     sub(min(nextBalanceInterval, nextInterestInterval), interval)) / 10 ** 9),
419                         principle));
420 
421             // set interval to next nearest major balance or interest (or both) change
422             interval = min(nextBalanceInterval, nextInterestInterval);
423         }
424 
425         // return amount owed, adjusted balance index, and the last interval set / used
426         return (amountOwed, (balanceIndex > 0 ? sub(balanceIndex, 1) : 0), interval);
427     }
428 
429     // record users balance (max 2 writes additional per person per transfer)
430     function recordBalance(address tokenOwner) internal {
431         // todays current interval id
432         uint256 todaysInterval = intervalNumber(block.timestamp);
433 
434         // last balance index
435         uint256 latestBalanceIndex = balanceRecords[tokenOwner].length > 0
436             ? sub(balanceRecords[tokenOwner].length, 1) : 0;
437 
438         // always update the current record (i.e. todays interval)
439         // record balance record (if latest record is for today, add to it, otherwise add a record)
440         if (balanceRecords[tokenOwner].length > 0
441             && balanceRecords[tokenOwner][latestBalanceIndex].interval == todaysInterval) {
442             balanceRecords[tokenOwner][latestBalanceIndex].balance = balanceOf(tokenOwner);
443         } else {
444             balanceRecords[tokenOwner].push(BalanceRecord({
445                 interval: todaysInterval,
446                 intervalOffset: todaysInterval,
447                 balance: balanceOf(tokenOwner)
448             }));
449         }
450 
451         // if no interval to interest mapping exists, map it (should always be at least a length of one)
452         if (intervalToInterestIndex[todaysInterval] <= 0) {
453             intervalToInterestIndex[todaysInterval] = sub(interestRates.length, 1); }
454     }
455 
456     // record a new intrest rate change
457     function recordInterestRate(uint256 rate) internal {
458         // min number precision for rate.. might need to add a max here.
459         assert(rate >= RAY);
460 
461         // todays current interval id
462         uint256 todaysInterval = intervalNumber(block.timestamp);
463 
464         // last balance index
465         uint256 latestRateIndex = interestRates.length > 0
466             ? sub(interestRates.length, 1) : 0;
467 
468         // always update todays interval
469         // record balance record (if latest record is for today, add to it, otherwise add a record)
470         if (interestRates.length > 0
471             && interestRates[latestRateIndex].interval == todaysInterval) {
472             interestRates[latestRateIndex].rate = rate;
473         } else {
474             interestRates.push(InterestRate({
475                 interval: todaysInterval,
476                 rate: rate
477             }));
478         }
479 
480         // map the interval to interest index always
481         intervalToInterestIndex[todaysInterval] = sub(interestRates.length, 1);
482     }
483 }
484 
485 /**
486   * @title PausableCompoundInterestERC20
487   * @author UnityCoin Team
488   * @notice An implimentation of a mintable, pausable, burnable, compound interest based
489   *       ERC20 token.
490   *
491   *       The token has a few *special* properties.
492   *         - a special burner account (which can burn tokens in its account)
493   *         - a special supply tracking pool account / mechanism
494   *         - a special interest pool account which interest payments are drawn from
495   *         - you cannot transfer from / to any pool (supply or interest)
496   *         - you cannot claim interest on the interest pool account
497   *         - by all accounts the interest and supply accounts dont really exist
498   *           and are used for internal accounting purposes.
499   *
500   *       Minting / burning / pausing style is based roughly on DSToken from maker.
501   *
502   *       Whenever we burn, mint, change rates we update the supply pool,
503   *       which intern updates the totalSupply return.
504   *
505   *       The TotalSupply of this token should be as follows:
506   *       total supply = supply issued + total interest accued up to current interval
507   *
508   *       The special `burner` account can only burn tokens sent to it's account.
509   *       You can think of it as a HOT burn account.
510   *       The provider can ultimatly burn any account.
511   */
512 contract PausableCompoundInterestERC20 is Pausable, BurnerAccount, InterestRateBased, ERC20Token {
513     // Non EIP20 Standard Constants, Variables and Events
514     event Mint(address indexed to, uint256 tokens);
515     event Burn(uint256 tokens);
516     event InterestRateChange(uint256 intervalDuration, uint256 intervalExpiry, uint256 indexed interestRateIndex);
517     event InterestClaimed(address indexed tokenOwner, uint256 amountOwed);
518 
519     // the interest pool account address, that wont be included in total supply
520     // hex generated with linux system entropy + dice + keys (private key thrown out)
521     address public constant interestPool = address(0xd365131390302b58A61E265744288097Bd53532e);
522 
523     // this is the based supply pool address, which is used to calculate total supply with interest accured
524     // hex generated with linux system entropy + dice + keys (private key thrown out)
525     address public constant supplyPool = address(0x85c05851ef3175aeFBC74EcA16F174E22b5acF28);
526 
527     // is not a pool account
528     modifier isNotPool(address tokenOwner) {
529         assert(tokenOwner != supplyPool && tokenOwner != interestPool); _;
530     }
531 
532     // total supply with amount owed
533     function totalSupply() external view returns (uint256 supplyWithAccruedInterest) {
534         (uint256 amountOwed,,) = interestOwed(supplyPool);
535 
536         return add(balanceOf(supplyPool), amountOwed);
537     }
538 
539     // Dai/Maker style minting
540     function mint(address to, uint256 amount) public isOwner pausable isNotPool(to) {
541         // any time the supply pool changes, we need to update it's interest owed
542         claimInterestOwed(supplyPool);
543 
544         balances[supplyPool] = add(balances[supplyPool], amount);
545         balances[to] = add(balances[to], amount);
546 
547         recordBalance(supplyPool);
548         recordBalance(to);
549 
550         emit Mint(to, amount);
551     }
552 
553     // the burner can only burn tokens in the burn account
554     function burn(address account) external isOwnerOrBurner pausable isNotPool(account) {
555         // target burn address
556         address target = msg.sender == burner ? burner : account;
557 
558         // any time the supply pool changes, we need to update it's interest owed
559         claimInterestOwed(supplyPool);
560 
561         emit Burn(balances[target]);
562 
563         balances[supplyPool] = sub(balances[supplyPool], balances[target]);
564         balances[target] = 0;
565 
566         // technially the burner account can claim interest, not that it should matter
567         recordBalance(supplyPool);
568         recordBalance(target);
569     }
570 
571     // change interest rates
572     function changeInterestRate(
573         uint256 duration,
574         uint256 maximum,
575         uint256 interestRate,
576         uint256 increasePool,
577         uint256 decreasePool) public isOwner pausable {
578         // claim up supply pool amount
579         if (interestRates.length > 0) {
580           claimInterestOwed(supplyPool); }
581 
582         // set duration and maximum
583         changeDuration(duration);
584 
585         // set interval maximum
586         intervalMaximum = maximum;
587 
588         // record interest rate..
589         recordInterestRate(interestRate);
590 
591         // set interest pool, no balance needs to be recorded here as this is the interest pool
592         balances[interestPool] = sub(add(balances[interestPool], increasePool),
593           decreasePool);
594     }
595 
596     // hard token set for interest pool
597     function setInterestPool(uint256 tokens) external isOwner pausable {
598         balances[interestPool] = tokens;
599         // no need to record balance as this is the interest pool account..
600     }
601 
602     // claim interest owed
603     function claimInterestOwed(address tokenOwner) public pausable {
604         // cant claim interest on the interest pool
605         assert(tokenOwner != interestPool);
606 
607         // calculate interest balances and new record indexes
608         (uint256 amountOwed, uint256 balanceIndex, uint256 interval) = interestOwed(tokenOwner);
609 
610         // set last balance index used (it's always one ahead so subtract one)
611         lastClaimedBalanceIndex[tokenOwner] = balanceIndex;
612 
613         // set interval offset
614         if (balanceRecords[tokenOwner].length > 0) {
615           balanceRecords[tokenOwner][balanceIndex].intervalOffset = interval;
616         }
617 
618         // increase the balance of the account, reduce interest pool
619         if (tokenOwner != supplyPool) {
620           balances[interestPool] = sub(balances[interestPool], amountOwed);
621         }
622 
623         // set new token owner balance, record balance event
624         balances[tokenOwner] = add(balances[tokenOwner], amountOwed);
625         recordBalance(tokenOwner);
626 
627         // fire the interest claimed event
628         emit InterestClaimed(tokenOwner, amountOwed);
629     }
630 
631     function transferFrom(address from, address to, uint256 tokens) public pausable isNotPool(from) isNotPool(to) returns (bool success) {
632         super.transferFrom(from, to, tokens);
633 
634         recordBalance(from);
635         recordBalance(to);
636 
637         return true;
638     }
639 
640     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
641     // If this function is called again it overwrites the current allowance with _value.
642     function approve(address spender, uint256 tokens) public pausable isNotPool(spender) returns (bool success) {
643         return super.approve(spender, tokens);
644     }
645 }
646 
647 /**
648   * @title SignableCompoundInterestERC20
649   * @author UnityCoin Team
650   * @notice A meta-transaction enabled version of the PausableCompoundInterestERC20
651   *       this allows you to do a signed transfer or claim using EIP712 signature format.
652   *
653   *       We also impliment a constructor here.
654   *
655   *       A sender can essentially build EIP712 Claim to specific funds, whereby
656   *       someone else (the `feeRecipient`) can recieve a pre-specified fee for
657   *       sending the transaction on-behalf of the sender.
658   *
659   *       At anytime the sender can invalide the transfer / claim release hash of
660   *       a claim / transfer they have signed.
661   *
662   *       Written claims also have nonce's to make them unique, and expiries
663   *       to remove the change of holding attacks.
664   */
665 contract SignableCompoundInterestERC20 is PausableCompoundInterestERC20 {
666     // EIP712 Hashes and Seporators
667     bytes32 constant public EIP712_DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)");
668     bytes32 constant public SIGNEDTRANSFER_TYPEHASH = keccak256("SignedTransfer(address to,uint256 tokens,address feeRecipient,uint256 fee,uint256 expiry,bytes32 nonce)");
669     bytes32 constant public SIGNEDINTERESTCLAIM_TYPEHASH = keccak256("SignedInterestClaim(address feeRecipient,uint256 fee,uint256 expiry,bytes32 nonce)");
670     bytes32 public DOMAIN_SEPARATOR = keccak256(abi.encode(
671         EIP712_DOMAIN_TYPEHASH, // EIP712
672         keccak256("UnityCoin"), // app name
673         keccak256("1"), // app version
674         uint256(1), // chain id
675         address(this), // verifying contract
676         bytes32(0x111857f4a3edcb7462eabc03bfe733db1e3f6cdc2b7971ee739626c98268ae12) // salt
677     ));
678 
679     // address(tokenOwner signer) => bytes32(releaseHash) => bool(was release hash used)
680     mapping(address => mapping(bytes32 => bool)) public releaseHashes;
681 
682     event SignedTransfer(address indexed from, address indexed to, uint256 tokens, bytes32 releaseHash);
683     event SignedInterestClaim(address indexed from, bytes32 releaseHash);
684 
685     // constructor for the entire token
686     constructor(
687         address tokenOwner, // main token controller
688         address tokenBurner, // burner account
689 
690         uint256 initialSupply, // total supply amount
691 
692         uint256 interestIntervalStartTimestamp, // start time
693         uint256 interestIntervalDurationSeconds, // interval duration
694         uint256 interestIntervalMaximum, // interest expiry
695         uint256 interestPoolSize, // total interest pool size
696         uint256 interestRate) public {
697         // setup the burner account
698         burner = tokenBurner;
699 
700         // setup the interest mechnics
701         intervalStartTimestamp = interestIntervalStartTimestamp;
702 
703         // set duration
704         intervalDuration = interestIntervalDurationSeconds;
705 
706         // set interest rates
707         changeInterestRate(interestIntervalDurationSeconds,
708             interestIntervalMaximum,
709             interestRate, interestPoolSize, 0);
710 
711         // mint to the token owner the initial supply
712         mint(tokenOwner, initialSupply);
713 
714         // set the provider
715         owner = tokenOwner;
716     }
717 
718     // allow someone else to pay the gas fee for this token, by taking a fee within the token itself.
719     function signedTransfer(address to,
720         uint256 tokens,
721         address feeRecipient,
722         uint256 fee,
723         uint256 expiry,
724         bytes32 nonce,
725         uint8 v, bytes32 r, bytes32 s) external returns (bool success) {
726         bytes32 releaseHash = keccak256(abi.encodePacked(
727            "\x19\x01",
728            DOMAIN_SEPARATOR,
729            keccak256(abi.encode(SIGNEDTRANSFER_TYPEHASH, to, tokens, feeRecipient, fee, expiry, nonce))
730         ));
731         address from = ecrecover(releaseHash, v, r, s);
732 
733         // check expiry, release hash and balances
734         assert(block.timestamp < expiry);
735         assert(releaseHashes[from][releaseHash] == false);
736 
737         // waste out release hash
738         releaseHashes[from][releaseHash] = true;
739 
740         // allow funds to be transfered.
741         approvals[from][msg.sender] = add(tokens, fee);
742 
743         // transfer funds
744         transferFrom(from, to, tokens);
745         transferFrom(from, feeRecipient, fee);
746 
747         emit SignedTransfer(from, to, tokens, releaseHash);
748 
749         return true;
750     }
751 
752     // allow someone else to fire the claim interest owed method, and get paid a fee in the token to do so
753     function signedInterestClaim(
754         address feeRecipient,
755         uint256 fee,
756         uint256 expiry,
757         bytes32 nonce,
758         uint8 v, bytes32 r, bytes32 s) external returns (bool success) {
759         bytes32 releaseHash = keccak256(abi.encodePacked(
760            "\x19\x01",
761            DOMAIN_SEPARATOR,
762            keccak256(abi.encode(SIGNEDINTERESTCLAIM_TYPEHASH, feeRecipient, fee, expiry, nonce))
763         ));
764         address from = ecrecover(releaseHash, v, r, s);
765 
766         // check expiry, release hash and balances
767         assert(block.timestamp < expiry);
768         assert(releaseHashes[from][releaseHash] == false);
769 
770         // waste out release hash
771         releaseHashes[from][releaseHash] = true;
772 
773         // claim interest owed
774         claimInterestOwed(from);
775 
776         // allow funds to be transfered.
777         approvals[from][msg.sender] = fee;
778 
779         // transfer funds
780         transferFrom(from, feeRecipient, fee);
781 
782         emit SignedInterestClaim(from, releaseHash);
783 
784         return true;
785     }
786 
787     // this allows a token user to invalidate approved release hashes at anytime..
788     function invalidateHash(bytes32 releaseHash) external pausable {
789       releaseHashes[msg.sender][releaseHash] = true;
790     }
791 }