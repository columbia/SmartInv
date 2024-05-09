1 /*
2 file:   depositoffer.sol
3 ver:    0.1.1
4 author: Chris Kwan
5 date:   28-OCT-2017/11-March-2018
6 email:  ecorpnu AT gmail.com
7 
8 A collated contract set for a token sale specific to the requirments of
9 Depositoffer (DOT) token product.
10 
11 This software is distributed in the hope that it will be useful,
12 but WITHOUT ANY WARRANTY; without even the implied warranty of
13 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
14 See MIT Licence for further details.
15 <https://opensource.org/licenses/MIT>.
16 
17 */
18 
19 
20 pragma solidity ^0.4.18;
21 
22 /*-----------------------------------------------------------------------------\
23 
24  depositoffer token sale configuration
25 
26 \*----------------------------------------------------------------------------*/
27 
28 // Contains token sale parameters
29 contract depositofferTokenConfig
30 {
31     // ERC20 trade name and symbol
32     string public           name            = "Depositoffer.com USPat7376612";
33     string public           symbol          = "DOT";
34 
35     // Owner has power to abort, discount addresses, sweep successful funds,
36     // change owner, sweep alien tokens.
37     address public          owner           = 0xB353cF41A0CAa38D6597A7a1337debf0b09dd8ae; // Primary address checksummed
38     
39     // Fund wallet should also be audited prior to deployment
40     // NOTE: Must be checksummed address!
41     //address public          fundWallet      = 0xE4Be3157DBD71Acd7Ad5667db00AA111C0088195; // multiSig address checksummed
42     address public            fundWallet =      0xcce1f6f4ceb0f046cf57fe8e1c409fc47afe6aab; 
43     
44     // Tokens awarded per USD contributed
45     uint public constant    TOKENS_PER_USD  = 2;
46 
47     // Ether market price in USD
48     uint public constant    USD_PER_ETH     = 380; // approx 7 day average High Low as at 29th OCT 2017
49     
50     // Minimum and maximum target in USD
51     uint public constant    MIN_USD_FUND    = 1;  // $1
52     uint public constant    MAX_USD_FUND    = 2000000; // $2 mio
53     
54     // Non-KYC contribution limit in USD
55     uint public constant    KYC_USD_LMT     = 50000;
56     
57     // There will be exactly 4000000 tokens regardless of number sold
58     // Unsold tokens are put given to the Founder on Trust to fund operations of the Project
59     uint public constant    MAX_TOKENS      = 4000000; // 4 mio
60     
61     // Funding begins on 30th OCT 2017
62     
63     //uint public constant    START_DATE      = 1509318001; // 30.10.2017 10 AM and 1 Sec Sydney Time
64       uint public constant    START_DATE      = 1520776337; // Monday March 12, 2018 00:52:17 (am) in time zone Australia/Sydney (AEDT)
65       
66     // Period for fundraising
67     uint public constant    FUNDING_PERIOD  = 180 days;
68 }
69 
70 
71 library SafeMath {
72     function add(uint a, uint b) internal pure returns (uint c) {
73         c = a + b;
74         require(c >= a);
75     }
76     function sub(uint a, uint b) internal pure returns (uint c) {
77         require(b <= a);
78         c = a - b;
79     }
80     function mul(uint a, uint b) internal pure returns (uint c) {
81         c = a * b;
82         require(a == 0 || c / a == b);
83     }
84     function div(uint a, uint b) internal pure returns (uint c) {
85         require(b > 0);
86         c = a / b;
87     }
88 }
89 
90 
91 contract ReentryProtected
92 {
93     // The reentry protection state mutex.
94     bool __reMutex;
95 
96     // Sets and resets mutex in order to block functin reentry
97     modifier preventReentry() {
98         require(!__reMutex);
99         __reMutex = true;
100         _;
101         delete __reMutex;
102     }
103 
104     // Blocks function entry if mutex is set
105     modifier noReentry() {
106         require(!__reMutex);
107         _;
108     }
109 }
110 
111 contract ERC20Token
112 {
113     using SafeMath for uint;
114 
115 /* Constants */
116 
117     // none
118     
119 /* State variable */
120 
121     /// @return The Total supply of tokens
122     uint public totalSupply;
123     
124     /// @return Token symbol
125     string public symbol;
126     
127     // Token ownership mapping
128     mapping (address => uint) balances;
129     
130     // Allowances mapping
131     mapping (address => mapping (address => uint)) allowed;
132 
133 /* Events */
134 
135     // Triggered when tokens are transferred.
136     event Transfer(
137         address indexed _from,
138         address indexed _to,
139         uint256 _amount);
140 
141     // Triggered whenever approve(address _spender, uint256 _amount) is called.
142     event Approval(
143         address indexed _owner,
144         address indexed _spender,
145         uint256 _amount);
146 
147 /* Modifiers */
148 
149     // none
150     
151 /* Functions */
152 
153     // Using an explicit getter allows for function overloading    
154     function balanceOf(address _addr)
155         public
156         constant
157         returns (uint)
158     {
159         return balances[_addr];
160     }
161     
162     // Using an explicit getter allows for function overloading    
163     function allowance(address _owner, address _spender)
164         public
165         constant
166         returns (uint)
167     {
168         return allowed[_owner][_spender];
169     }
170 
171     // Send _value amount of tokens to address _to
172     function transfer(address _to, uint256 _amount)
173         public
174         returns (bool)
175     {
176         return xfer(msg.sender, _to, _amount);
177     }
178 
179     // Send _value amount of tokens from address _from to address _to
180     function transferFrom(address _from, address _to, uint256 _amount)
181         public
182         returns (bool)
183     {
184         require(_amount <= allowed[_from][msg.sender]);
185         
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
187         return xfer(_from, _to, _amount);
188     }
189 
190     // Process a transfer internally.
191     function xfer(address _from, address _to, uint _amount)
192         internal
193         returns (bool)
194     {
195         require(_amount <= balances[_from]);
196 
197         Transfer(_from, _to, _amount);
198         
199         // avoid wasting gas on 0 token transfers
200         if(_amount == 0) return true;
201         
202         balances[_from] = balances[_from].sub(_amount);
203         balances[_to]   = balances[_to].add(_amount);
204         
205         return true;
206     }
207 
208     // Approves a third-party spender
209     function approve(address _spender, uint256 _amount)
210         public
211         returns (bool)
212     {
213         allowed[msg.sender][_spender] = _amount;
214         Approval(msg.sender, _spender, _amount);
215         return true;
216     }
217 }
218 
219 
220 
221 /*-----------------------------------------------------------------------------\
222 
223 ## Conditional Entry Table
224 
225 Functions must throw on F conditions
226 
227 Conditional Entry Table (functions must throw on F conditions)
228 
229 renetry prevention on all public mutating functions
230 Reentry mutex set in moveFundsToWallet(), refund()
231 
232 |function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
233 |------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
234 |()                      |KYC        |T         |F           |T            |F          |
235 |abort()                 |T          |T         |T           |T            |F          |
236 |proxyPurchase()         |KYC        |T         |F           |T            |F          |
237 |addKycAddress()         |T          |T         |F           |T            |T          |
238 |finaliseICO()           |F          |F         |F           |T            |T          |
239 |refund()                |F          |F         |T           |F            |F          |
240 |transfer()              |F          |F         |F           |F            |T          |
241 |transferFrom()          |F          |F         |F           |F            |T          |
242 |approve()               |F          |F         |F           |F            |T          |
243 |changeOwner()           |T          |T         |T           |T            |T          |
244 |acceptOwnership()       |T          |T         |T           |T            |T          |
245 |changedeposito()          |T          |T         |T           |T            |T          |
246 |destroy()               |F          |F         |!__abortFuse|F            |F          |
247 |transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
248 
249 \*----------------------------------------------------------------------------*/
250 
251 contract depositofferTokenAbstract
252 {
253 // TODO comment events
254 
255 // Logged when funder exceeds the KYC limit
256     event KYCAddress(address indexed _addr, bool indexed _kyc);
257 
258 // Logged upon refund
259     event Refunded(address indexed _addr, uint indexed _value);
260 
261 // Logged when new owner accepts ownership
262     event ChangedOwner(address indexed _from, address indexed _to);
263     
264 // Logged when owner initiates a change of ownership
265     event ChangeOwnerTo(address indexed _to);
266 
267 // Logged when ICO ether funds are transferred to an address
268     event FundsTransferred(address indexed _wallet, uint indexed _value);
269 
270 
271     // This fuse blows upon calling abort() which forces a fail state
272     bool public __abortFuse = true;
273     
274     // Set to true after the fund is swept to the fund wallet, allows token
275     // transfers and prevents abort()
276     bool public icoSuccessful;
277 
278     // Token conversion factors are calculated with decimal places at parity with ether
279     uint8 public constant decimals = 18;
280 
281     // An address authorised to take ownership
282     address public newOwner;
283     
284     // The deposito smart contract address
285     address public deposito;
286     
287     // Total ether raised during funding
288     uint public etherRaised;
289     
290     // Preauthorized tranch discount addresses
291     // holder => discount
292     mapping (address => bool) public kycAddresses;
293     
294     // Record of ether paid per address
295     mapping (address => uint) public etherContributed;
296 
297     // Return `true` if MIN_FUNDS were raised
298     function fundSucceeded() public constant returns (bool);
299     
300     // Return `true` if MIN_FUNDS were not raised before END_DATE
301     function fundFailed() public constant returns (bool);
302 
303     // Returns USD raised for set ETH/USD rate
304     function usdRaised() public constant returns (uint);
305 
306     // Returns an amount in eth equivilent to USD at the set rate
307     function usdToEth(uint) public constant returns(uint);
308     
309     // Returns the USD value of ether at the set USD/ETH rate
310     function ethToUsd(uint _wei) public constant returns (uint);
311 
312     // Returns token/ether conversion given ether value and address. 
313     function ethToTokens(uint _eth)
314         public constant returns (uint);
315 
316     // Processes a token purchase for a given address
317     function proxyPurchase(address _addr) payable returns (bool);
318 
319     // Owner can move funds of successful fund to fundWallet 
320     function finaliseICO() public returns (bool);
321     
322     // Registers a discounted address
323     function addKycAddress(address _addr, bool _kyc)
324         public returns (bool);
325 
326     // Refund on failed or aborted sale 
327     function refund(address _addr) public returns (bool);
328 
329     // To cancel token sale prior to START_DATE
330     function abort() public returns (bool);
331     
332     // Change the deposito backend contract address
333     function changedeposito(address _addr) public returns (bool);
334     
335     // For owner to salvage tokens sent to contract
336     function transferAnyERC20Token(address tokenAddress, uint amount)
337         returns (bool);
338 }
339 
340 
341 /*-----------------------------------------------------------------------------\
342 
343  depositoffer token implimentation
344 
345 \*----------------------------------------------------------------------------*/
346 
347 contract depositofferToken is 
348     ReentryProtected,
349     ERC20Token,
350     depositofferTokenAbstract,
351     depositofferTokenConfig
352 {
353     using SafeMath for uint;
354 
355 //
356 // Constants
357 //
358 
359     // USD to ether conversion factors calculated from `depositofferTokenConfig` constants 
360     uint public constant TOKENS_PER_ETH = TOKENS_PER_USD * USD_PER_ETH;
361     uint public constant MIN_ETH_FUND   = 1 ether * MIN_USD_FUND / USD_PER_ETH;
362     uint public constant MAX_ETH_FUND   = 1 ether * MAX_USD_FUND / USD_PER_ETH;
363     uint public constant KYC_ETH_LMT    = 1 ether * KYC_USD_LMT  / USD_PER_ETH;
364 
365     // General funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
366     uint public END_DATE  = START_DATE + FUNDING_PERIOD;
367 
368 //
369 // Modifiers
370 //
371 
372     modifier onlyOwner {
373         require(msg.sender == owner);
374         _;
375     }
376 
377 //
378 // Functions
379 //
380 
381     // Constructor
382     function depositofferToken()
383     {
384         // ICO parameters are set in depositofferTSConfig
385         // Invalid configuration catching here
386         require(bytes(symbol).length > 0);
387         require(bytes(name).length > 0);
388         require(owner != 0x0);
389         require(fundWallet != 0x0);
390         require(TOKENS_PER_USD > 0);
391         require(USD_PER_ETH > 0);
392         require(MIN_USD_FUND > 0);
393         require(MAX_USD_FUND > MIN_USD_FUND);
394         require(START_DATE > 0);
395         require(FUNDING_PERIOD > 0);
396         
397         // Setup and allocate token supply to 18 decimal places
398         totalSupply = MAX_TOKENS * 1e18;
399         balances[fundWallet] = totalSupply;
400         Transfer(0x0, fundWallet, totalSupply);
401     }
402     
403     // Default function
404     function ()
405         payable
406     {
407         // Pass through to purchasing function. Will throw on failed or
408         // successful ICO
409         proxyPurchase(msg.sender);
410     }
411 
412 //
413 // Getters
414 //
415 
416     // ICO fails if aborted or minimum funds are not raised by the end date
417     function fundFailed() public constant returns (bool)
418     {
419         return !__abortFuse
420             || (now > END_DATE && etherRaised < MIN_ETH_FUND);
421     }
422     
423     // Funding succeeds if not aborted, minimum funds are raised before end date
424     function fundSucceeded() public constant returns (bool)
425     {
426         return !fundFailed()
427             && etherRaised >= MIN_ETH_FUND;
428     }
429 
430     // Returns the USD value of ether at the set USD/ETH rate
431     function ethToUsd(uint _wei) public constant returns (uint)
432     {
433         return USD_PER_ETH.mul(_wei).div(1 ether);
434     }
435     
436     // Returns the ether value of USD at the set USD/ETH rate
437     function usdToEth(uint _usd) public constant returns (uint)
438     {
439         return _usd.mul(1 ether).div(USD_PER_ETH);
440     }
441     
442     // Returns the USD value of ether raised at the set USD/ETH rate
443     function usdRaised() public constant returns (uint)
444     {
445         return ethToUsd(etherRaised);
446     }
447     
448     // Returns the number of tokens for given amount of ether for an address 
449     function ethToTokens(uint _wei) public constant returns (uint)
450     {
451         uint usd = ethToUsd(_wei);
452         
453         // Percent bonus funding tiers for USD funding
454         uint bonus = 0;
455     //        usd >= 2000000 ? 35 :
456     //        usd >= 500000  ? 30 :
457     //        usd >= 100000  ? 20 :
458     //        usd >= 25000   ? 15 :
459     //        usd >= 10000   ? 10 :
460     //        usd >= 5000    ? 5  :
461     //        usd >= 1000    ? 1  :                    
462         
463         // using n.2 fixed point decimal for whole number percentage.
464         return _wei.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);
465     }
466 
467 //
468 // ICO functions
469 //
470 
471     // The fundraising can be aborted any time before funds are swept to the
472     // fundWallet.
473     // This will force a fail state and allow refunds to be collected.
474     function abort()
475         public
476         noReentry
477         onlyOwner
478         returns (bool)
479     {
480         require(!icoSuccessful);
481         delete __abortFuse;
482         return true;
483     }
484     
485     // General addresses can purchase tokens during funding
486     function proxyPurchase(address _addr)
487         payable
488         noReentry
489         returns (bool)
490     {
491         require(!fundFailed());
492         require(!icoSuccessful);
493         require(now <= END_DATE);
494         require(msg.value > 0);
495         
496         // Non-KYC'ed funders can only contribute up to $10000 after prefund period
497         if(!kycAddresses[_addr])
498         {
499             require(now >= START_DATE);
500             require((etherContributed[_addr].add(msg.value)) <= KYC_ETH_LMT);
501         }
502 
503         // Get ether to token conversion
504         uint tokens = ethToTokens(msg.value);
505         
506         // transfer tokens from fund wallet
507         
508         xfer(fundWallet, _addr, tokens);
509         
510         // Update holder payments
511         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
512         
513         // Update funds raised
514         etherRaised = etherRaised.add(msg.value);
515         
516         // Bail if this pushes the fund over the USD cap or Token cap
517         require(etherRaised <= MAX_ETH_FUND);
518 
519         return true;
520     }
521     
522     // Owner can KYC (or revoke) addresses until close of funding
523     function addKycAddress(address _addr, bool _kyc)
524     public
525         noReentry
526         onlyOwner
527         returns (bool)
528     {
529        require(!fundFailed());
530 
531         kycAddresses[_addr] = _kyc;
532         KYCAddress(_addr, _kyc);
533       return true;
534     }
535     
536     // Owner can sweep a successful funding to the fundWallet
537     // Contract can be aborted up until this action.
538     // Effective once but can be called multiple time to withdraw edge case
539     // funds recieved by contract which can selfdestruct to this address
540  
541     
542     function finaliseICO()
543         public
544         onlyOwner
545         preventReentry()
546         returns (bool)
547     {
548         require(fundSucceeded());
549 
550         icoSuccessful = true;
551 
552         FundsTransferred(fundWallet, this.balance);
553         fundWallet.transfer(this.balance);
554         return true;
555     }
556     
557     // Refunds can be claimed from a failed ICO
558     function refund(address _addr)
559         public
560         preventReentry()
561         returns (bool)
562     {
563         require(fundFailed());
564         
565         uint value = etherContributed[_addr];
566 
567         // Transfer tokens back to origin
568         // (Not really necessary but looking for graceful exit)
569         xfer(_addr, fundWallet, balances[_addr]);
570 
571         // garbage collect
572         delete etherContributed[_addr];
573         delete kycAddresses[_addr];
574         
575         Refunded(_addr, value);
576         if (value > 0) {
577             _addr.transfer(value);
578         }
579         return true;
580     }
581 
582 //
583 // ERC20 overloaded functions
584 //
585 
586     function transfer(address _to, uint _amount)
587         public
588         preventReentry
589         returns (bool)
590     {
591         // ICO must be successful
592         require(icoSuccessful);
593         super.transfer(_to, _amount);
594 
595         if (_to == deposito)
596             // Notify the deposito contract it has been sent tokens
597             require(Notify(deposito).notify(msg.sender, _amount));
598         return true;
599     }
600 
601     function transferFrom(address _from, address _to, uint _amount)
602         public
603         preventReentry
604         returns (bool)
605     {
606         // ICO must be successful
607         require(icoSuccessful);
608         super.transferFrom(_from, _to, _amount);
609 
610         if (_to == deposito)
611             // Notify the deposito contract it has been sent tokens
612             require(Notify(deposito).notify(msg.sender, _amount));
613         return true;
614     }
615     
616     function approve(address _spender, uint _amount)
617         public
618         noReentry
619         returns (bool)
620     {
621         // ICO must be successful
622         require(icoSuccessful);
623         super.approve(_spender, _amount);
624         return true;
625     }
626 
627 //
628 // Contract managment functions
629 //
630 
631     // To initiate an ownership change
632     function changeOwner(address _newOwner)
633         public
634         noReentry
635         onlyOwner
636         returns (bool)
637     {
638         ChangeOwnerTo(_newOwner);
639         newOwner = _newOwner;
640         return true;
641     }
642 
643     // To accept ownership. Required to prove new address can call the contract.
644     function acceptOwnership()
645         public
646         noReentry
647         returns (bool)
648     {
649         require(msg.sender == newOwner);
650         ChangedOwner(owner, newOwner);
651         owner = newOwner;
652         return true;
653     }
654 
655     // Change the address of the deposito contract address. The contract
656     // must impliment the `Notify` interface.
657     function changedeposito(address _addr)
658         public
659         noReentry
660         onlyOwner
661         returns (bool)
662     {
663         deposito = _addr;
664         return true;
665     }
666     
667     // The contract can be selfdestructed after abort and ether balance is 0.
668     function destroy()
669         public
670         noReentry
671         onlyOwner
672     {
673         require(!__abortFuse);
674         require(this.balance == 0);
675         selfdestruct(owner);
676     }
677     
678     // Owner can salvage ANYTYPE ERC20 tokens that may have been sent to the account by accident 
679     function transferAnyERC20Token(address tokenAddress, uint amount)
680         public
681         onlyOwner
682         preventReentry
683         returns (bool) 
684     {
685         require(ERC20Token(tokenAddress).transfer(owner, amount));
686         return true;
687     }
688 }
689 
690 
691 interface Notify
692 {
693     event Notified(address indexed _from, uint indexed _amount);
694     
695     function notify(address _from, uint _amount) public returns (bool);
696 }
697 
698 
699 contract depositoTest is Notify
700 {
701     address public dot;
702     
703     function setdot(address _addr) { dot = _addr; }
704     
705     function notify(address _from, uint _amount) public returns (bool)
706     {
707         require(msg.sender == dot);
708         Notified(_from, _amount);
709         return true;
710     }
711 }