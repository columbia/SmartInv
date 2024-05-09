1 /*
2 file:   Hut34ICO.sol
3 ver:    0.2.4_deploy
4 author: Darryl Morris
5 date:   27-Oct-2017
6 email:  o0ragman0o AT gmail.com
7 (c) Darryl Morris 2017
8 
9 A collated contract set for the receipt of funds and production and transfer
10 of ERC20 tokens as specified by Hut34.
11 
12 License
13 -------
14 This software is distributed in the hope that it will be useful,
15 but WITHOUT ANY WARRANTY; without even the implied warranty of
16 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
17 See MIT Licence for further details.
18 <https://opensource.org/licenses/MIT>.
19 
20 Release Notes
21 -------------
22 * Added `event Aborted()`
23 * correct `wholesaleLeft` magnitude bug
24 * All tests passed
25 
26 Dedications
27 -------------
28 * with love to Isabella and pea from your dad
29 * xx to edie, robin, william and charlotte x
30 */
31 
32 
33 pragma solidity ^0.4.17;
34 
35 // Audited 27 October 2017 by Darryl Morris, Peter Godbolt
36 contract Hut34Config
37 {
38     // ERC20 token name
39     string  public constant name            = "Hut34 Entropy";
40 
41     // ERC20 trading symbol
42     string  public constant symbol          = "ENT";
43 
44     // ERC20 decimal places
45     uint8   public constant decimals        = 18;
46 
47     // Total supply (* in unit ENT *)
48     uint    public constant TOTAL_TOKENS    = 100000000;
49 
50     // Contract owner at time of deployment.
51     address public constant OWNER           = 0xdA3780Cff2aE3a59ae16eC1734DEec77a7fd8db2;
52 
53     // + new Date("00:00 2 November 2017 utc")/1000
54     uint    public constant START_DATE      = 1509580800;
55 
56     // A Hut34 address to own tokens
57     address public constant HUT34_RETAIN    = 0x3135F4acA3C1Ad4758981500f8dB20EbDc5A1caB;
58 
59     // A Hut34 address to accept raised funds
60     address public constant HUT34_WALLET    = 0xA70d04dC4a64960c40CD2ED2CDE36D76CA4EDFaB;
61 
62     // Percentage of tokens to be vested over 2 years. 20%
63     uint    public constant VESTED_PERCENT  = 20;
64 
65     // Vesting period
66     uint    public constant VESTING_PERIOD  = 26 weeks;
67 
68     // Minimum cap over which the funding is considered successful
69     uint    public constant MIN_CAP         = 3000 * 1 ether;
70 
71     // An ether threshold over which a funder must KYC before tokens can be
72     // transferred (unit of ether);
73     uint    public constant KYC_THRESHOLD   = 150 * 1 ether;
74 
75     // A minimum amount of ether funding before the concierge rate is applied
76     // to tokens
77     uint    public constant WHOLESALE_THRESHOLD  = 150 * 1 ether;
78 
79     // Number of tokens up for wholesale purchasers (* in unit ENT *)
80     uint    public constant WHOLESALE_TOKENS = 12500000;
81 
82     // Tokens sold to prefunders (* in unit ENT *)
83     uint    public constant PRESOLD_TOKENS  = 1817500;
84 
85     // Presale ether is estimateed from fiat raised prior to ICO at the ETH/AUD
86     // rate at the time of contract deployment
87     uint    public constant PRESALE_ETH_RAISE = 2807 * 1 ether;
88 
89     // Address holding presold tokens to be distributed after ICO
90     address public constant PRESOLD_ADDRESS = 0x6BF708eF2C1FDce3603c04CE9547AA6E134093b6;
91 
92     // wholesale rate for purchases over WHOLESALE_THRESHOLD ether
93     uint    public constant RATE_WHOLESALE  = 1000;
94 
95     // Time dependant retail rates
96     // First Day
97     uint    public constant RATE_DAY_0      = 750;
98 
99     // First Week (The six days after first day)
100     uint    public constant RATE_DAY_1      = 652;
101 
102     // Second Week
103     uint    public constant RATE_DAY_7      = 588;
104 
105     // Third Week
106     uint    public constant RATE_DAY_14     = 545;
107 
108     // Fourth Week
109     uint    public constant RATE_DAY_21     = 517;
110 
111     // Fifth Week
112     uint    public constant RATE_DAY_28     = 500;
113 }
114 
115 
116 library SafeMath
117 {
118     // a add to b
119     function add(uint a, uint b) internal pure returns (uint c) {
120         c = a + b;
121         assert(c >= a);
122     }
123 
124     // a subtract b
125     function sub(uint a, uint b) internal pure returns (uint c) {
126         c = a - b;
127         assert(c <= a);
128     }
129 
130     // a multiplied by b
131     function mul(uint a, uint b) internal pure returns (uint c) {
132         c = a * b;
133         assert(a == 0 || c / a == b);
134     }
135 
136     // a divided by b
137     function div(uint a, uint b) internal pure returns (uint c) {
138         assert(b != 0);
139         c = a / b;
140     }
141 }
142 
143 
144 contract ReentryProtected
145 {
146     // The reentry protection state mutex.
147     bool __reMutex;
148 
149     // Sets and clears mutex in order to block function reentry
150     modifier preventReentry() {
151         require(!__reMutex);
152         __reMutex = true;
153         _;
154         delete __reMutex;
155     }
156 
157     // Blocks function entry if mutex is set
158     modifier noReentry() {
159         require(!__reMutex);
160         _;
161     }
162 }
163 
164 
165 contract ERC20Token
166 {
167     using SafeMath for uint;
168 
169 /* Constants */
170 
171     // none
172 
173 /* State variable */
174 
175     /// @return The Total supply of tokens
176     uint public totalSupply;
177 
178     /// @return Tokens owned by an address
179     mapping (address => uint) balances;
180 
181     /// @return Tokens spendable by a thridparty
182     mapping (address => mapping (address => uint)) allowed;
183 
184 /* Events */
185 
186     // Triggered when tokens are transferred.
187     event Transfer(
188         address indexed _from,
189         address indexed _to,
190         uint256 _amount);
191 
192     // Triggered whenever approve(address _spender, uint256 _amount) is called.
193     event Approval(
194         address indexed _owner,
195         address indexed _spender,
196         uint256 _amount);
197 
198 /* Modifiers */
199 
200     // none
201 
202 /* Functions */
203 
204     // Using an explicit getter allows for function overloading
205     function balanceOf(address _addr)
206         public
207         view
208         returns (uint)
209     {
210         return balances[_addr];
211     }
212 
213     // Using an explicit getter allows for function overloading
214     function allowance(address _owner, address _spender)
215         public
216         constant
217         returns (uint)
218     {
219         return allowed[_owner][_spender];
220     }
221 
222     // Send _value amount of tokens to address _to
223     function transfer(address _to, uint256 _amount)
224         public
225         returns (bool)
226     {
227         return xfer(msg.sender, _to, _amount);
228     }
229 
230     // Send _value amount of tokens from address _from to address _to
231     function transferFrom(address _from, address _to, uint256 _amount)
232         public
233         returns (bool)
234     {
235         require(_amount <= allowed[_from][msg.sender]);
236 
237         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
238         return xfer(_from, _to, _amount);
239     }
240 
241     // Process a transfer internally.
242     function xfer(address _from, address _to, uint _amount)
243         internal
244         returns (bool)
245     {
246         require(_amount <= balances[_from]);
247 
248         Transfer(_from, _to, _amount);
249 
250         // avoid wasting gas on 0 token transfers
251         if(_amount == 0) return true;
252 
253         balances[_from] = balances[_from].sub(_amount);
254         balances[_to]   = balances[_to].add(_amount);
255 
256         return true;
257     }
258 
259     // Approves a third-party spender
260     function approve(address _spender, uint256 _amount)
261         public
262         returns (bool)
263     {
264         allowed[msg.sender][_spender] = _amount;
265         Approval(msg.sender, _spender, _amount);
266         return true;
267     }
268 }
269 
270 
271 /*-----------------------------------------------------------------------------\
272 
273 ## Conditional Entry Table
274 
275 Functions must throw on F conditions
276 
277 Renetry prevention is on all public mutating functions
278 Reentry mutex set in finalizeICO(), externalXfer(), refund()
279 
280 |function                |<startDate |<endDate  |fundFailed  |fundRaised|icoSucceeded
281 |------------------------|:---------:|:--------:|:----------:|:--------:|:---------:|
282 |()                      |F          |T         |F           |T         |F          |
283 |abort()                 |T          |T         |T           |T         |F          |
284 |proxyPurchase()         |F          |T         |F           |T         |F          |
285 |finalizeICO()           |F          |F         |F           |T         |T          |
286 |refund()                |F          |F         |T           |F         |F          |
287 |refundFor()             |F          |F         |T           |F         |F          |
288 |transfer()              |F          |F         |F           |F         |T          |
289 |transferFrom()          |F          |F         |F           |F         |T          |
290 |transferToMany()        |F          |F         |F           |F         |T          |
291 |approve()               |F          |F         |F           |F         |T          |
292 |clearKyc()              |T          |T         |T           |T         |T          |
293 |releaseVested()         |F          |F         |F           |F         |now>release|
294 |changeOwner()           |T          |T         |T           |T         |T          |
295 |acceptOwnership()       |T          |T         |T           |T         |T          |
296 |transferExternalTokens()|T          |T         |T           |T         |T          |
297 |destroy()               |F          |F         |!__abortFuse|F         |F          |
298 
299 \*----------------------------------------------------------------------------*/
300 
301 contract Hut34ICOAbstract
302 {
303     /// @dev Logged upon receiving a deposit
304     /// @param _from The address from which value has been recieved
305     /// @param _value The value of ether received
306     event Deposit(address indexed _from, uint _value);
307 
308     /// @dev Logged upon a withdrawal
309     /// @param _from the address of the withdrawer
310     /// @param _to Address to which value was sent
311     /// @param _value The value in ether which was withdrawn
312     event Withdrawal(address indexed _from, address indexed _to, uint _value);
313 
314     /// @dev Logged when new owner accepts ownership
315     /// @param _from the old owner address
316     /// @param _to the new owner address
317     event ChangedOwner(address indexed _from, address indexed _to);
318 
319     /// @dev Logged when owner initiates a change of ownership
320     /// @param _to the new owner address
321     event ChangeOwnerTo(address indexed _to);
322 
323     /// @dev Logged when a funder exceeds the KYC limit
324     /// @param _addr Address to set or clear KYC flag
325     /// @param _kyc A boolean flag
326     event Kyc(address indexed _addr, bool _kyc);
327 
328     /// @dev Logged when vested tokens are released back to HUT32_WALLET
329     /// @param _releaseDate The official release date (even if released at
330     /// later date)
331     event VestingReleased(uint _releaseDate);
332 
333     /// @dev Logged if the contract is aborted
334     event Aborted();
335 
336 //
337 // Constants
338 //
339 
340     /// @dev The Hut34 vesting 'psudo-address' for transferring and releasing
341     /// vested tokens to the Hut34 Wallet. The address is UTF8 encoding of the
342     /// string and can only be accessed by the 'releaseVested()' function.
343     /// @return `0x48757433342056657374696e6700000000000000`
344     address public constant HUT34_VEST_ADDR = address(bytes20("Hut34 Vesting"));
345 
346 //
347 // State Variables
348 //
349 
350     /// @dev This fuse blows upon calling abort() which forces a fail state
351     /// @return the abort state. true == not aborted
352     bool public __abortFuse = true;
353 
354     /// @dev Sets to true after the fund is swept to the fund wallet, allows
355     /// token transfers and prevents abort()
356     /// @return final success state of ICO
357     bool public icoSucceeded;
358 
359     /// @dev An address permissioned to enact owner restricted functions
360     /// @return owner
361     address public owner;
362 
363     /// @dev An address permissioned to take ownership of the contract
364     /// @return new owner address
365     address public newOwner;
366 
367     /// @dev A tally of total ether raised during the funding period
368     /// @return Total ether raised during funding
369     uint public etherRaised;
370 
371     /// @return Wholesale tokens available for sale
372     uint public wholesaleLeft;
373 
374     /// @return Total ether refunded. Used to permision call to `destroy()`
375     uint public refunded;
376 
377     /// @returns Date of next vesting release
378     uint public nextReleaseDate;
379 
380     /// @return Ether paid by an address
381     mapping (address => uint) public etherContributed;
382 
383     /// @returns KYC flag for an address
384     mapping (address => bool) public mustKyc;
385 
386 //
387 // Modifiers
388 //
389 
390     modifier onlyOwner() {
391         require(msg.sender == owner);
392         _;
393     }
394 
395 //
396 // Function Abstracts
397 //
398 
399     /// @return `true` if MIN_FUNDS were raised
400     function fundRaised() public view returns (bool);
401 
402     /// @return `true` if MIN_FUNDS were not raised before END_DATE or contract
403     /// has been aborted
404     function fundFailed() public view returns (bool);
405 
406     /// @return The current retail rate for token purchase
407     function currentRate() public view returns (uint);
408 
409     /// @param _wei A value of ether in units of wei
410     /// @return allTokens_ returnable tokens for the funding amount
411     /// @return wholesaleToken_ Number of tokens purchased at wholesale rate
412     function ethToTokens(uint _wei)
413         public view returns (uint allTokens_, uint wholesaleTokens_);
414 
415     /// @notice Processes a token purchase for `_addr`
416     /// @param _addr An address to purchase tokens
417     /// @return Boolean success value
418     /// @dev Requires <150,000 gas
419     function proxyPurchase(address _addr) public payable returns (bool);
420 
421     /// @notice Finalize the ICO and transfer funds
422     /// @return Boolean success value
423     function finalizeICO() public returns (bool);
424 
425     /// @notice Clear the KYC flags for an array of addresses to allow tokens
426     /// transfers
427     function clearKyc(address[] _addrs) public returns (bool);
428 
429     /// @notice Make bulk transfer of tokens to many addresses
430     /// @param _addrs An array of recipient addresses
431     /// @param _amounts An array of amounts to transfer to respective addresses
432     /// @return Boolean success value
433     function transferToMany(address[] _addrs, uint[] _amounts)
434         public returns (bool);
435 
436     /// @notice Release vested tokens after a maturity date
437     /// @return Boolean success value
438     function releaseVested() public returns (bool);
439 
440     /// @notice Claim refund on failed ICO
441     /// @return Boolean success value
442     function refund() public returns (bool);
443 
444     /// @notice Push refund for `_addr` from failed ICO
445     /// @param _addrs An array of address to refund
446     /// @return Boolean success value
447     function refundFor(address[] _addrs) public returns (bool);
448 
449     /// @notice Abort the token sale prior to finalizeICO()
450     function abort() public returns (bool);
451 
452     /// @notice Salvage `_amount` tokens at `_kaddr` and send them to `_to`
453     /// @param _kAddr An ERC20 contract address
454     /// @param _to and address to send tokens
455     /// @param _amount The number of tokens to transfer
456     /// @return Boolean success value
457     function transferExternalToken(address _kAddr, address _to, uint _amount)
458         public returns (bool);
459 }
460 
461 
462 /*-----------------------------------------------------------------------------\
463 
464  Hut34ICO implimentation
465 
466 \*----------------------------------------------------------------------------*/
467 
468 contract Hut34ICO is
469     ReentryProtected,
470     ERC20Token,
471     Hut34ICOAbstract,
472     Hut34Config
473 {
474     using SafeMath for uint;
475 
476 //
477 // Constants
478 //
479 
480     // Token fixed point for decimal places
481     uint constant TOKEN = uint(10)**decimals;
482 
483     // Calculate vested tokens
484     uint public constant VESTED_TOKENS =
485             TOTAL_TOKENS * TOKEN * VESTED_PERCENT / 100;
486 
487     // Hut34 retains 50% of tokens (70% - 20% vested tokens)
488     uint public constant RETAINED_TOKENS = TOKEN * TOTAL_TOKENS / 2;
489 
490     // Calculate end date
491     uint public constant END_DATE = START_DATE + 35 days;
492 
493     // Divides `etherRaised` to calculate commision
494     // etherRaised/6.66... == etherRaised * 1.5% / 100
495     uint public constant COMMISSION_DIV = 67;
496 
497     // Developer commission wallet
498     address public constant COMMISSION_WALLET =
499         0x0065D506E475B5DBD76480bAFa57fe7C41c783af;
500 
501 //
502 // Functions
503 //
504 
505     function Hut34ICO()
506         public
507     {
508         // Run sanity checks
509         require(TOTAL_TOKENS != 0);
510         require(OWNER != 0x0);
511         require(HUT34_RETAIN != 0x0);
512         require(HUT34_WALLET != 0x0);
513         require(PRESOLD_TOKENS <= WHOLESALE_TOKENS);
514         require(PRESOLD_TOKENS == 0 || PRESOLD_ADDRESS != 0x0);
515         require(MIN_CAP != 0);
516         require(START_DATE >= now);
517         require(bytes(name).length != 0);
518         require(bytes(symbol).length != 0);
519         require(KYC_THRESHOLD != 0);
520         require(RATE_DAY_0 >= RATE_DAY_1);
521         require(RATE_DAY_1 >= RATE_DAY_7);
522         require(RATE_DAY_7 >= RATE_DAY_14);
523         require(RATE_DAY_14 >= RATE_DAY_21);
524         require(RATE_DAY_21 >= RATE_DAY_28);
525 
526         owner = OWNER;
527         totalSupply = TOTAL_TOKENS.mul(TOKEN);
528         wholesaleLeft = WHOLESALE_TOKENS.mul(TOKEN);
529         uint presold = PRESOLD_TOKENS.mul(TOKEN);
530         wholesaleLeft = wholesaleLeft.sub(presold);
531 
532         // Presale raise is appoximate given it was conducted in Fiat.
533         etherRaised = PRESALE_ETH_RAISE;
534 
535         // Mint the total supply into Hut34 token holding address
536         balances[HUT34_RETAIN] = totalSupply;
537         Transfer(0x0, HUT34_RETAIN, totalSupply);
538 
539         // Transfer vested tokens from holding wallet to vesting pseudo-address
540         balances[HUT34_RETAIN] = balances[HUT34_RETAIN].sub(VESTED_TOKENS);
541         balances[HUT34_VEST_ADDR] = balances[HUT34_VEST_ADDR].add(VESTED_TOKENS);
542         Transfer(HUT34_RETAIN, HUT34_VEST_ADDR, VESTED_TOKENS);
543 
544         // Transfer presold tokens to holding address;
545         balances[HUT34_RETAIN] = balances[HUT34_RETAIN].sub(presold);
546         balances[PRESOLD_ADDRESS] = balances[PRESOLD_ADDRESS].add(presold);
547         Transfer(HUT34_RETAIN, PRESOLD_ADDRESS, presold);
548     }
549 
550     // Default function. Accepts payments during funding period
551     function ()
552         public
553         payable
554     {
555         // Pass through to purchasing function. Will throw on failed or
556         // successful ICO
557         proxyPurchase(msg.sender);
558     }
559 
560 //
561 // Getters
562 //
563 
564     // ICO fails if aborted or minimum funds are not raised by the end date
565     function fundFailed() public view returns (bool)
566     {
567         return !__abortFuse
568             || (now > END_DATE && etherRaised < MIN_CAP);
569     }
570 
571     // Funding succeeds if not aborted, minimum funds are raised before end date
572     function fundRaised() public view returns (bool)
573     {
574         return !fundFailed()
575             && etherRaised >= MIN_CAP
576             && now > START_DATE;
577     }
578 
579     // Returns wholesale value in wei
580     function wholeSaleValueLeft() public view returns (uint)
581     {
582         return wholesaleLeft / RATE_WHOLESALE;
583     }
584 
585     function currentRate()
586         public
587         view
588         returns (uint)
589     {
590         return
591             fundFailed() ? 0 :
592             icoSucceeded ? 0 :
593             now < START_DATE ? 0 :
594             now < START_DATE + 1 days ? RATE_DAY_0 :
595             now < START_DATE + 7 days ? RATE_DAY_1 :
596             now < START_DATE + 14 days ? RATE_DAY_7 :
597             now < START_DATE + 21 days ? RATE_DAY_14 :
598             now < START_DATE + 28 days ? RATE_DAY_21 :
599             now < END_DATE ? RATE_DAY_28 :
600             0;
601     }
602 
603     // Calculates the sale and wholesale portion of tokens for a given value
604     // of wei at the time of calling.
605     function ethToTokens(uint _wei)
606         public
607         view
608         returns (uint allTokens_, uint wholesaleTokens_)
609     {
610         // Get wholesale portion of ether and tokens
611         uint wsValueLeft = wholeSaleValueLeft();
612         uint wholesaleSpend =
613                 fundFailed() ? 0 :
614                 icoSucceeded ? 0 :
615                 now < START_DATE ? 0 :
616                 now > END_DATE ? 0 :
617                 // No wholesale purchse
618                 _wei < WHOLESALE_THRESHOLD ? 0 :
619                 // Total wholesale purchase
620                 _wei < wsValueLeft ?  _wei :
621                 // over funded for remaining wholesale tokens
622                 wsValueLeft;
623 
624         wholesaleTokens_ = wholesaleSpend
625                 .mul(RATE_WHOLESALE)
626                 .mul(TOKEN)
627                 .div(1 ether);
628 
629         // Remaining wei used to purchase retail tokens
630         _wei = _wei.sub(wholesaleSpend);
631 
632         // Get retail rate
633         uint saleRate = currentRate();
634 
635         allTokens_ = _wei
636                 .mul(saleRate)
637                 .mul(TOKEN)
638                 .div(1 ether)
639                 .add(wholesaleTokens_);
640     }
641 
642 //
643 // ICO functions
644 //
645 
646     // The fundraising can be aborted any time before `finaliseICO()` is called.
647     // This will force a fail state and allow refunds to be collected.
648     // The owner can abort or anyone else if a successful fund has not been
649     // finalised before 7 days after the end date.
650     function abort()
651         public
652         noReentry
653         returns (bool)
654     {
655         require(!icoSucceeded);
656         require(msg.sender == owner || now > END_DATE  + 14 days);
657         delete __abortFuse;
658         Aborted();
659         return true;
660     }
661 
662     // General addresses can purchase tokens during funding
663     function proxyPurchase(address _addr)
664         public
665         payable
666         noReentry
667         returns (bool)
668     {
669         require(!fundFailed());
670         require(!icoSucceeded);
671         require(now > START_DATE);
672         require(now <= END_DATE);
673         require(msg.value > 0);
674 
675         // Log ether deposit
676         Deposit (_addr, msg.value);
677 
678         // Get ether to token conversion
679         uint tokens;
680         // Portion of tokens sold at wholesale rate
681         uint wholesaleTokens;
682 
683         (tokens, wholesaleTokens) = ethToTokens(msg.value);
684 
685         // Block any failed token creation
686         require(tokens > 0);
687 
688         // Prevent over subscribing
689         require(balances[HUT34_RETAIN] - tokens >= RETAINED_TOKENS);
690 
691         // Adjust wholesale tokens left for sale
692         if (wholesaleTokens != 0) {
693             wholesaleLeft = wholesaleLeft.sub(wholesaleTokens);
694         }
695 
696         // transfer tokens from fund wallet
697         balances[HUT34_RETAIN] = balances[HUT34_RETAIN].sub(tokens);
698         balances[_addr] = balances[_addr].add(tokens);
699         Transfer(HUT34_RETAIN, _addr, tokens);
700 
701         // Update funds raised
702         etherRaised = etherRaised.add(msg.value);
703 
704         // Update holder payments
705         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
706 
707         // Check KYC requirement
708         if(etherContributed[_addr] >= KYC_THRESHOLD && !mustKyc[_addr]) {
709             mustKyc[_addr] = true;
710             Kyc(_addr, true);
711         }
712 
713         return true;
714     }
715 
716     // Owner can sweep a successful funding to the fundWallet.
717     // Can be called repeatedly to recover errant ether which may have been
718     // `selfdestructed` to the contract
719     // Contract can be aborted up until this returns `true`
720     function finalizeICO()
721         public
722         onlyOwner
723         preventReentry()
724         returns (bool)
725     {
726         // Must have reached minimum cap
727         require(fundRaised());
728 
729         // Set first vesting date (only once as this function can be called again)
730         if(!icoSucceeded) {
731             nextReleaseDate = now + VESTING_PERIOD;
732         }
733 
734         // Set success flag;
735         icoSucceeded = true;
736 
737         // Transfer % Developer commission
738         uint devCommission = calcCommission();
739         Withdrawal(this, COMMISSION_WALLET, devCommission);
740         COMMISSION_WALLET.transfer(devCommission);
741 
742         // Remaining % to the fund wallet
743         Withdrawal(this, HUT34_WALLET, this.balance);
744         HUT34_WALLET.transfer(this.balance);
745         return true;
746     }
747 
748     function clearKyc(address[] _addrs)
749         public
750         noReentry
751         onlyOwner
752         returns (bool)
753     {
754         uint len = _addrs.length;
755         for(uint i; i < len; i++) {
756             delete mustKyc[_addrs[i]];
757             Kyc(_addrs[i], false);
758         }
759         return true;
760     }
761 
762     // Releases vested tokens back to Hut34 wallet
763     function releaseVested()
764         public
765         returns (bool)
766     {
767         require(now > nextReleaseDate);
768         VestingReleased(nextReleaseDate);
769         nextReleaseDate = nextReleaseDate.add(VESTING_PERIOD);
770         return xfer(HUT34_VEST_ADDR, HUT34_RETAIN, VESTED_TOKENS / 4);
771     }
772 
773     // Direct refund to caller
774     function refund()
775         public
776         returns (bool)
777     {
778         address[] memory addrs = new address[](1);
779         addrs[0] = msg.sender;
780         return refundFor(addrs);
781     }
782 
783     // Bulk refunds can be pushed from a failed ICO
784     function refundFor(address[] _addrs)
785         public
786         preventReentry()
787         returns (bool)
788     {
789         require(fundFailed());
790         uint i;
791         uint len = _addrs.length;
792         uint value;
793         uint tokens;
794         address addr;
795 
796         for (i; i < len; i++) {
797             addr = _addrs[i];
798             value = etherContributed[addr];
799             tokens = balances[addr];
800             if (tokens > 0) {
801                 // Return tokens
802                 // transfer tokens from fund wallet
803                 balances[HUT34_RETAIN] = balances[HUT34_RETAIN].add(tokens);
804                 delete balances[addr];
805                 Transfer(addr, HUT34_RETAIN, tokens);
806             }
807 
808             if (value > 0) {
809                 // Refund ether contribution
810                 delete etherContributed[addr];
811                 delete mustKyc[addr];
812                 refunded = refunded.add(value);
813                 Withdrawal(this, addr, value);
814                 addr.transfer(value);
815             }
816         }
817         return true;
818     }
819 
820 //
821 // ERC20 additional and overloaded functions
822 //
823 
824     // Allows a sender to transfer tokens to an array of recipients
825     function transferToMany(address[] _addrs, uint[] _amounts)
826         public
827         noReentry
828         returns (bool)
829     {
830         require(_addrs.length == _amounts.length);
831         uint len = _addrs.length;
832         for(uint i = 0; i < len; i++) {
833             xfer(msg.sender, _addrs[i], _amounts[i]);
834         }
835         return true;
836     }
837 
838     // Overload to check ICO success and KYC flags.
839     function xfer(address _from, address _to, uint _amount)
840         internal
841         noReentry
842         returns (bool)
843     {
844         require(icoSucceeded);
845         require(!mustKyc[_from]);
846         super.xfer(_from, _to, _amount);
847         return true;
848     }
849 
850     // Overload to require ICO success
851     function approve(address _spender, uint _amount)
852         public
853         noReentry
854         returns (bool)
855     {
856         // ICO must be successful
857         require(icoSucceeded);
858         super.approve(_spender, _amount);
859         return true;
860     }
861 
862 //
863 // Contract management functions
864 //
865 
866     // Initiate a change of owner to `_owner`
867     function changeOwner(address _owner)
868         public
869         onlyOwner
870         returns (bool)
871     {
872         ChangeOwnerTo(_owner);
873         newOwner = _owner;
874         return true;
875     }
876 
877     // Finalise change of ownership to newOwner
878     function acceptOwnership()
879         public
880         returns (bool)
881     {
882         require(msg.sender == newOwner);
883         ChangedOwner(owner, msg.sender);
884         owner = newOwner;
885         delete newOwner;
886         return true;
887     }
888 
889     // This will selfdestruct the contract on the condittion all have been
890     // processed.
891     function destroy()
892         public
893         noReentry
894         onlyOwner
895     {
896         require(!__abortFuse);
897         require(refunded == (etherRaised - PRESALE_ETH_RAISE));
898         // Log burned tokens for complete ledger accounting on archival nodes
899         Transfer(HUT34_RETAIN, 0x0, balances[HUT34_RETAIN]);
900         Transfer(HUT34_VEST_ADDR, 0x0, VESTED_TOKENS);
901         Transfer(PRESOLD_ADDRESS, 0x0, PRESOLD_TOKENS);
902         // Garbage collect mapped state
903         delete balances[HUT34_RETAIN];
904         delete balances[PRESOLD_ADDRESS];
905         selfdestruct(owner);
906     }
907 
908     // Owner can salvage ERC20 tokens that may have been sent to the account
909     function transferExternalToken(address _kAddr, address _to, uint _amount)
910         public
911         onlyOwner
912         preventReentry
913         returns (bool)
914     {
915         require(ERC20Token(_kAddr).transfer(_to, _amount));
916         return true;
917     }
918 
919     // Calculate commission on prefunded and raised ether.
920     function calcCommission()
921         internal
922         view
923         returns(uint)
924     {
925         uint commission = (this.balance + PRESALE_ETH_RAISE) / COMMISSION_DIV;
926         // Edge case that prefund causes commission to be greater than balance
927         return commission <= this.balance ? commission : this.balance;
928     }
929 }