1 /*
2 file:   1mdb.sol
3 ver:    0.1.3
4 author: Chris Kwan
5 date:   21-April-2018
6 email:  ecorpnu AT gmail.com
7 
8 A collated contract set for a token sale specific to the requirments of
9 1mdb (1mdb) token product.
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
24  1mdb token sale configuration
25 
26 \*----------------------------------------------------------------------------*/
27 
28 // Contains token sale parameters
29 contract mdbTokenConfig
30 {
31     // ERC20 trade name and symbol
32     string public           name            = "USPAT7493279 loansyndicate";
33     string public           symbol          = "1mdb";
34 
35     // Owner has power to abort, discount addresses, sweep successful funds,
36     // change owner, sweep alien tokens.
37     address public          owner           = 0xB353cF41A0CAa38D6597A7a1337debf0b09dd8ae; // Primary address checksummed
38     
39     // Fund wallet should also be audited prior to deployment
40     // NOTE: Must be checksummed address!
41     //address public          fundWallet      = 0xE4Be3157DBD71Acd7Ad5667db00AA111C0088195; // multiSig address checksummed
42      address public           fundWallet      = 0xb6cEC5dd8c3A7E1892752a5724496c22ef6d0A37; //multiSig address main
43     //address public          fundWallet = 0x29c92dbf73a6cb9d7e87b2ac9099765da9a2e7d3; //ropster test
44     
45     //you cannot use regular address, you need to create a contract wallet and need to make it checkedsummed search net  
46     
47     // Tokens awarded per USD contributed
48     uint public constant    TOKENS_PER_USD  = 2;
49 
50     // Ether market price in USD
51     uint public constant    USD_PER_ETH     = 500; // approx 7 day average High Low as at 21th APRIL 2018
52     
53     // Minimum and maximum target in USD
54     uint public constant    MIN_USD_FUND    = 100000;  // $100K
55     uint public constant    MAX_USD_FUND    = 5000000; // $5 mio
56     
57     // Non-KYC contribution limit in USD
58     uint public constant    KYC_USD_LMT     = 15000;
59     
60     // There will be exactly 4000000 tokens regardless of number sold
61     // Unsold tokens are put given to the Founder on Trust to fund operations of the Project
62     uint public constant    MAX_TOKENS      = 10000000; // 10 mio
63     
64     // Funding begins on 30th OCT 2017
65     
66     //uint public constant    START_DATE      = 1509318001; // 30.10.2017 10 AM and 1 Sec Sydney Time
67       uint public constant    START_DATE      = 1523465678; // April 11, 2018 16.54 GMT 
68       
69     // Period for fundraising
70     uint public constant    FUNDING_PERIOD  = 180 days;
71 }
72 
73 
74 library SafeMath {
75     function add(uint a, uint b) internal pure returns (uint c) {
76         c = a + b;
77         require(c >= a);
78     }
79     function sub(uint a, uint b) internal pure returns (uint c) {
80         require(b <= a);
81         c = a - b;
82     }
83     function mul(uint a, uint b) internal pure returns (uint c) {
84         c = a * b;
85         require(a == 0 || c / a == b);
86     }
87     function div(uint a, uint b) internal pure returns (uint c) {
88         require(b > 0);
89         c = a / b;
90     }
91 }
92 
93 
94 contract ReentryProtected
95 {
96     // The reentry protection state mutex.
97     bool __reMutex;
98 
99     // Sets and resets mutex in order to block functin reentry
100     modifier preventReentry() {
101         require(!__reMutex);
102         __reMutex = true;
103         _;
104         delete __reMutex;
105     }
106 
107     // Blocks function entry if mutex is set
108     modifier noReentry() {
109         require(!__reMutex);
110         _;
111     }
112 }
113 
114 contract ERC20Token
115 {
116     using SafeMath for uint;
117 
118 /* Constants */
119 
120     // none
121     
122 /* State variable */
123 
124     /// @return The Total supply of tokens
125     uint public totalSupply;
126     
127     /// @return Token symbol
128     string public symbol;
129     
130     // Token ownership mapping
131     mapping (address => uint) balances;
132     
133     // Allowances mapping
134     mapping (address => mapping (address => uint)) allowed;
135 
136 /* Events */
137 
138     // Triggered when tokens are transferred.
139     event Transfer(
140         address indexed _from,
141         address indexed _to,
142         uint256 _amount);
143 
144     // Triggered whenever approve(address _spender, uint256 _amount) is called.
145     event Approval(
146         address indexed _owner,
147         address indexed _spender,
148         uint256 _amount);
149 
150 /* Modifiers */
151 
152     // none
153     
154 /* Functions */
155 
156     // Using an explicit getter allows for function overloading    
157     function balanceOf(address _addr)
158         public
159         constant
160         returns (uint)
161     {
162         return balances[_addr];
163     }
164     
165     // Using an explicit getter allows for function overloading    
166     function allowance(address _owner, address _spender)
167         public
168         constant
169         returns (uint)
170     {
171         return allowed[_owner][_spender];
172     }
173 
174     // Send _value amount of tokens to address _to
175     function transfer(address _to, uint256 _amount)
176         public
177         returns (bool)
178     {
179         return xfer(msg.sender, _to, _amount);
180     }
181 
182     // Send _value amount of tokens from address _from to address _to
183     function transferFrom(address _from, address _to, uint256 _amount)
184         public
185         returns (bool)
186     {
187         require(_amount <= allowed[_from][msg.sender]);
188         
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
190         return xfer(_from, _to, _amount);
191     }
192 
193     // Process a transfer internally.
194     function xfer(address _from, address _to, uint _amount)
195         internal
196         returns (bool)
197     {
198         require(_amount <= balances[_from]);
199 
200         Transfer(_from, _to, _amount);
201         
202         // avoid wasting gas on 0 token transfers
203         if(_amount == 0) return true;
204         
205         balances[_from] = balances[_from].sub(_amount);
206         balances[_to]   = balances[_to].add(_amount);
207         
208         return true;
209     }
210 
211     // Approves a third-party spender
212     function approve(address _spender, uint256 _amount)
213         public
214         returns (bool)
215     {
216         allowed[msg.sender][_spender] = _amount;
217         Approval(msg.sender, _spender, _amount);
218         return true;
219     }
220 }
221 
222 
223 
224 /*-----------------------------------------------------------------------------\
225 
226 ## Conditional Entry Table
227 
228 Functions must throw on F conditions
229 
230 Conditional Entry Table (functions must throw on F conditions)
231 
232 renetry prevention on all public mutating functions
233 Reentry mutex set in moveFundsToWallet(), refund()
234 
235 |function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
236 |------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
237 |()                      |KYC        |T         |F           |T            |F          |
238 |abort()                 |T          |T         |T           |T            |F          |
239 |proxyPurchase()         |KYC        |T         |F           |T            |F          |
240 |addKycAddress()         |T          |T         |F           |T            |T          |
241 |finaliseICO()           |F          |F         |F           |T            |T          |
242 |refund()                |F          |F         |T           |F            |F          |
243 |transfer()              |F          |F         |F           |F            |T          |
244 |transferFrom()          |F          |F         |F           |F            |T          |
245 |approve()               |F          |F         |F           |F            |T          |
246 |changeOwner()           |T          |T         |T           |T            |T          |
247 |acceptOwnership()       |T          |T         |T           |T            |T          |
248 |changedeposito()          |T          |T         |T           |T            |T          |
249 |destroy()               |F          |F         |!__abortFuse|F            |F          |
250 |transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
251 
252 \*----------------------------------------------------------------------------*/
253 
254 contract mdbTokenAbstract
255 {
256 // TODO comment events
257 
258 // Logged when funder exceeds the KYC limit
259     event KYCAddress(address indexed _addr, bool indexed _kyc);
260 
261 // Logged upon refund
262     event Refunded(address indexed _addr, uint indexed _value);
263 
264 // Logged when new owner accepts ownership
265     event ChangedOwner(address indexed _from, address indexed _to);
266     
267 // Logged when owner initiates a change of ownership
268     event ChangeOwnerTo(address indexed _to);
269 
270 // Logged when ICO ether funds are transferred to an address
271     event FundsTransferred(address indexed _wallet, uint indexed _value);
272 
273 
274     // This fuse blows upon calling abort() which forces a fail state
275     bool public __abortFuse = true;
276     
277     // Set to true after the fund is swept to the fund wallet, allows token
278     // transfers and prevents abort()
279     bool public icoSuccessful;
280 
281     // Token conversion factors are calculated with decimal places at parity with ether
282     uint8 public constant decimals = 18;
283 
284     // An address authorised to take ownership
285     address public newOwner;
286     
287     // The deposito smart contract address
288     address public deposito;
289     
290     // Total ether raised during funding
291     uint public etherRaised;
292     
293     // Preauthorized tranch discount addresses
294     // holder => discount
295     mapping (address => bool) public kycAddresses;
296     
297     // Record of ether paid per address
298     mapping (address => uint) public etherContributed;
299 
300     // Return `true` if MIN_FUNDS were raised
301     function fundSucceeded() public constant returns (bool);
302     
303     // Return `true` if MIN_FUNDS were not raised before END_DATE
304     function fundFailed() public constant returns (bool);
305 
306     // Returns USD raised for set ETH/USD rate
307     function usdRaised() public constant returns (uint);
308 
309     // Returns an amount in eth equivilent to USD at the set rate
310     function usdToEth(uint) public constant returns(uint);
311     
312     // Returns the USD value of ether at the set USD/ETH rate
313     function ethToUsd(uint _wei) public constant returns (uint);
314 
315     // Returns token/ether conversion given ether value and address. 
316     function ethToTokens(uint _eth)
317         public constant returns (uint);
318 
319     // Processes a token purchase for a given address
320     function proxyPurchase(address _addr) payable returns (bool);
321 
322     // Owner can move funds of successful fund to fundWallet 
323     function finaliseICO() public returns (bool);
324     
325     // Registers a discounted address
326     function addKycAddress(address _addr, bool _kyc)
327         public returns (bool);
328 
329     // Refund on failed or aborted sale 
330     function refund(address _addr) public returns (bool);
331 
332     // To cancel token sale prior to START_DATE
333     function abort() public returns (bool);
334     
335     // Change the deposito backend contract address
336     function changedeposito(address _addr) public returns (bool);
337     
338     // For owner to salvage tokens sent to contract
339     function transferAnyERC20Token(address tokenAddress, uint amount)
340         returns (bool);
341 }
342 
343 
344 /*-----------------------------------------------------------------------------\
345 
346  1mdb token implimentation
347 
348 \*----------------------------------------------------------------------------*/
349 
350 contract mdbToken is 
351     ReentryProtected,
352     ERC20Token,
353     mdbTokenAbstract,
354     mdbTokenConfig
355 {
356     using SafeMath for uint;
357 
358 //
359 // Constants
360 //
361 
362     // USD to ether conversion factors calculated from `depositofferTokenConfig` constants 
363     uint public constant TOKENS_PER_ETH = TOKENS_PER_USD * USD_PER_ETH;
364     uint public constant MIN_ETH_FUND   = 1 ether * MIN_USD_FUND / USD_PER_ETH;
365     uint public constant MAX_ETH_FUND   = 1 ether * MAX_USD_FUND / USD_PER_ETH;
366     uint public constant KYC_ETH_LMT    = 1 ether * KYC_USD_LMT  / USD_PER_ETH;
367 
368     // General funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
369     uint public END_DATE  = START_DATE + FUNDING_PERIOD;
370 
371 //
372 // Modifiers
373 //
374 
375     modifier onlyOwner {
376         require(msg.sender == owner);
377         _;
378     }
379 
380 //
381 // Functions
382 //
383 
384     // Constructor
385     function mdbToken()
386     {
387         // ICO parameters are set in 1mdbTSConfig
388         // Invalid configuration catching here
389         require(bytes(symbol).length > 0);
390         require(bytes(name).length > 0);
391         require(owner != 0x0);
392         require(fundWallet != 0x0);
393         require(TOKENS_PER_USD > 0);
394         require(USD_PER_ETH > 0);
395         require(MIN_USD_FUND > 0);
396         require(MAX_USD_FUND > MIN_USD_FUND);
397         require(START_DATE > 0);
398         require(FUNDING_PERIOD > 0);
399         
400         // Setup and allocate token supply to 18 decimal places
401         totalSupply = MAX_TOKENS * 1e18;
402         balances[fundWallet] = totalSupply;
403         Transfer(0x0, fundWallet, totalSupply);
404     }
405     
406     // Default function
407     function ()
408         payable
409     {
410         // Pass through to purchasing function. Will throw on failed or
411         // successful ICO
412         proxyPurchase(msg.sender);
413     }
414 
415 //
416 // Getters
417 //
418 
419     // ICO fails if aborted or minimum funds are not raised by the end date
420     function fundFailed() public constant returns (bool)
421     {
422         return !__abortFuse
423             || (now > END_DATE && etherRaised < MIN_ETH_FUND);
424     }
425     
426     // Funding succeeds if not aborted, minimum funds are raised before end date
427     function fundSucceeded() public constant returns (bool)
428     {
429         return !fundFailed()
430             && etherRaised >= MIN_ETH_FUND;
431     }
432 
433     // Returns the USD value of ether at the set USD/ETH rate
434     function ethToUsd(uint _wei) public constant returns (uint)
435     {
436         return USD_PER_ETH.mul(_wei).div(1 ether);
437     }
438     
439     // Returns the ether value of USD at the set USD/ETH rate
440     function usdToEth(uint _usd) public constant returns (uint)
441     {
442         return _usd.mul(1 ether).div(USD_PER_ETH);
443     }
444     
445     // Returns the USD value of ether raised at the set USD/ETH rate
446     function usdRaised() public constant returns (uint)
447     {
448         return ethToUsd(etherRaised);
449     }
450     
451     // Returns the number of tokens for given amount of ether for an address 
452     function ethToTokens(uint _wei) public constant returns (uint)
453     {
454         uint usd = ethToUsd(_wei);
455         
456         // Percent bonus funding tiers for USD funding
457                  uint bonus = 
458              usd >= 2000000 ? 35 :
459              usd >= 500000  ? 30 :
460              usd >= 100000  ? 20 :
461              usd >= 25000   ? 15 :
462              usd >= 10000   ? 10 :
463              usd >= 5000    ? 5  :
464              usd >= 1000    ? 1  :                    
465                                 0;
466         // using n.2 fixed point decimal for whole number percentage.
467         return _wei.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);
468     }
469 
470 //
471 // ICO functions
472 //
473 
474     // The fundraising can be aborted any time before funds are swept to the
475     // fundWallet.
476     // This will force a fail state and allow refunds to be collected.
477     function abort()
478         public
479         noReentry
480         onlyOwner
481         returns (bool)
482     {
483         require(!icoSuccessful);
484         delete __abortFuse;
485         return true;
486     }
487     
488     // General addresses can purchase tokens during funding
489     function proxyPurchase(address _addr)
490         payable
491         noReentry
492         returns (bool)
493     {
494         require(!fundFailed());
495         require(!icoSuccessful);
496         require(now <= END_DATE);
497         require(msg.value > 0);
498         
499         // Non-KYC'ed funders can only contribute up to $10000 after prefund period
500         if(!kycAddresses[_addr])
501         {
502             require(now >= START_DATE);
503             require((etherContributed[_addr].add(msg.value)) <= KYC_ETH_LMT);
504         }
505 
506         // Get ether to token conversion
507         uint tokens = ethToTokens(msg.value);
508         
509         // transfer tokens from fund wallet
510         
511         xfer(fundWallet, _addr, tokens);
512         
513         // Update holder payments
514         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
515         
516         // Update funds raised
517         etherRaised = etherRaised.add(msg.value);
518         
519         // Bail if this pushes the fund over the USD cap or Token cap
520         require(etherRaised <= MAX_ETH_FUND);
521 
522         return true;
523     }
524     
525     // Owner can KYC (or revoke) addresses until close of funding
526     function addKycAddress(address _addr, bool _kyc)
527     public
528         noReentry
529         onlyOwner
530         returns (bool)
531     {
532        require(!fundFailed());
533 
534         kycAddresses[_addr] = _kyc;
535         KYCAddress(_addr, _kyc);
536       return true;
537     }
538     
539     // Owner can sweep a successful funding to the fundWallet
540     // Contract can be aborted up until this action.
541     // Effective once but can be called multiple time to withdraw edge case
542     // funds recieved by contract which can selfdestruct to this address
543  
544     
545     function finaliseICO()
546         public
547         onlyOwner
548         preventReentry()
549         returns (bool)
550     {
551         require(fundSucceeded());
552 
553         icoSuccessful = true;
554 
555         FundsTransferred(fundWallet, this.balance);
556         fundWallet.transfer(this.balance);
557         return true;
558     }
559     
560     // Refunds can be claimed from a failed ICO
561     function refund(address _addr)
562         public
563         preventReentry()
564         returns (bool)
565     {
566         require(fundFailed());
567         
568         uint value = etherContributed[_addr];
569 
570         // Transfer tokens back to origin
571         // (Not really necessary but looking for graceful exit)
572         xfer(_addr, fundWallet, balances[_addr]);
573 
574         // garbage collect
575         delete etherContributed[_addr];
576         delete kycAddresses[_addr];
577         
578         Refunded(_addr, value);
579         if (value > 0) {
580             _addr.transfer(value);
581         }
582         return true;
583     }
584 
585 //
586 // ERC20 overloaded functions
587 //
588 
589     function transfer(address _to, uint _amount)
590         public
591         preventReentry
592         returns (bool)
593     {
594         // ICO must be successful
595         require(icoSuccessful);
596         super.transfer(_to, _amount);
597 
598         if (_to == deposito)
599             // Notify the deposito contract it has been sent tokens
600             require(Notify(deposito).notify(msg.sender, _amount));
601         return true;
602     }
603 
604     function transferFrom(address _from, address _to, uint _amount)
605         public
606         preventReentry
607         returns (bool)
608     {
609         // ICO must be successful
610         require(icoSuccessful);
611         super.transferFrom(_from, _to, _amount);
612 
613         if (_to == deposito)
614             // Notify the deposito contract it has been sent tokens
615             require(Notify(deposito).notify(msg.sender, _amount));
616         return true;
617     }
618     
619     function approve(address _spender, uint _amount)
620         public
621         noReentry
622         returns (bool)
623     {
624         // ICO must be successful
625         require(icoSuccessful);
626         super.approve(_spender, _amount);
627         return true;
628     }
629 
630 //
631 // Contract managment functions
632 //
633 
634     // To initiate an ownership change
635     function changeOwner(address _newOwner)
636         public
637         noReentry
638         onlyOwner
639         returns (bool)
640     {
641         ChangeOwnerTo(_newOwner);
642         newOwner = _newOwner;
643         return true;
644     }
645 
646     // To accept ownership. Required to prove new address can call the contract.
647     function acceptOwnership()
648         public
649         noReentry
650         returns (bool)
651     {
652         require(msg.sender == newOwner);
653         ChangedOwner(owner, newOwner);
654         owner = newOwner;
655         return true;
656     }
657 
658     // Change the address of the deposito contract address. The contract
659     // must impliment the `Notify` interface.
660     function changedeposito(address _addr)
661         public
662         noReentry
663         onlyOwner
664         returns (bool)
665     {
666         deposito = _addr;
667         return true;
668     }
669     
670     // The contract can be selfdestructed after abort and ether balance is 0.
671     function destroy()
672         public
673         noReentry
674         onlyOwner
675     {
676         require(!__abortFuse);
677         require(this.balance == 0);
678         selfdestruct(owner);
679     }
680     
681     // Owner can salvage ANYTYPE ERC20 tokens that may have been sent to the account by accident 
682     function transferAnyERC20Token(address tokenAddress, uint amount)
683         public
684         onlyOwner
685         preventReentry
686         returns (bool) 
687     {
688         require(ERC20Token(tokenAddress).transfer(owner, amount));
689         return true;
690     }
691 }
692 
693 
694 interface Notify
695 {
696     event Notified(address indexed _from, uint indexed _amount);
697     
698     function notify(address _from, uint _amount) public returns (bool);
699 }
700 
701 
702 contract depositoTest is Notify
703 {
704     address public dot;
705     
706     function setdot(address _addr) { dot = _addr; }
707     
708     function notify(address _from, uint _amount) public returns (bool)
709     {
710         require(msg.sender == dot);
711         Notified(_from, _amount);
712         return true;
713     }
714 }