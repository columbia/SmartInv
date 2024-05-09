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
20 pragma solidity ^0.4.13;
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
32     string public           name            = "depositoffer network";
33     string public           symbol          = "DOT";
34 
35     // Owner has power to abort, discount addresses, sweep successful funds,
36     // change owner, sweep alien tokens.
37     address public          owner           = 0xB353cF41A0CAa38D6597A7a1337debf0b09dd8ae; // Primary address checksummed
38     
39     // Fund wallet should also be audited prior to deployment
40     // NOTE: Must be checksummed address!
41     address public          fundWallet      = 0xE4Be3157DBD71Acd7Ad5667db00AA111C0088195; // multiSig address checksummed
42 
43     // Tokens awarded per USD contributed
44     uint public constant    TOKENS_PER_USD  = 2;
45 
46     // Ether market price in USD
47     uint public constant    USD_PER_ETH     = 800; // approx 7 day average High Low as at 29th OCT 2017
48     
49     // Minimum and maximum target in USD
50     uint public constant    MIN_USD_FUND    = 1;  // $1
51     uint public constant    MAX_USD_FUND    = 2000000; // $2 mio
52     
53     // Non-KYC contribution limit in USD
54     uint public constant    KYC_USD_LMT     = 50000;
55     
56     // There will be exactly 4000000 tokens regardless of number sold
57     // Unsold tokens are put given to the Founder on Trust to fund operations of the Project
58     uint public constant    MAX_TOKENS      = 4000000; // $4 mio
59     
60     // Funding begins on 30th OCT 2017
61     
62     //uint public constant    START_DATE      = 1509318001; // 30.10.2017 10 AM and 1 Sec Sydney Time
63       uint public constant    START_DATE      = 1520776337; // Monday March 12, 2018 00:52:17 (am) in time zone Australia/Sydney (AEDT)
64       
65     // Period for fundraising
66     uint public constant    FUNDING_PERIOD  = 180 days;
67 }
68 
69 
70 library SafeMath
71 {
72     // a add to b
73     
74     function add(uint a, uint b) internal constant returns (uint c) {
75         c = a + b;
76         assert(c >= a);
77     }
78     
79     // a subtract b
80     function sub(uint a, uint b) internal constant returns (uint c) {
81         c = a - b;
82         assert(c <= a);
83     }
84     
85     // a multiplied by b
86     function mul(uint a, uint b) internal constant returns (uint c) {
87         c = a * b;
88         assert(a == 0 || c / a == b);
89     }
90     
91     // a divided by b
92     function div(uint a, uint b) internal constant returns (uint c) {
93         c = a / b;
94         // No assert required as no overflows are posible.
95     }
96 }
97 
98 
99 contract ReentryProtected
100 {
101     // The reentry protection state mutex.
102     bool __reMutex;
103 
104     // Sets and resets mutex in order to block functin reentry
105     modifier preventReentry() {
106         require(!__reMutex);
107         __reMutex = true;
108         _;
109         delete __reMutex;
110     }
111 
112     // Blocks function entry if mutex is set
113     modifier noReentry() {
114         require(!__reMutex);
115         _;
116     }
117 }
118 
119 contract ERC20Token
120 {
121     using SafeMath for uint;
122 
123 /* Constants */
124 
125     // none
126     
127 /* State variable */
128 
129     /// @return The Total supply of tokens
130     uint public totalSupply;
131     
132     /// @return Token symbol
133     string public symbol;
134     
135     // Token ownership mapping
136     mapping (address => uint) balances;
137     
138     // Allowances mapping
139     mapping (address => mapping (address => uint)) allowed;
140 
141 /* Events */
142 
143     // Triggered when tokens are transferred.
144     event Transfer(
145         address indexed _from,
146         address indexed _to,
147         uint256 _amount);
148 
149     // Triggered whenever approve(address _spender, uint256 _amount) is called.
150     event Approval(
151         address indexed _owner,
152         address indexed _spender,
153         uint256 _amount);
154 
155 /* Modifiers */
156 
157     // none
158     
159 /* Functions */
160 
161     // Using an explicit getter allows for function overloading    
162     function balanceOf(address _addr)
163         public
164         constant
165         returns (uint)
166     {
167         return balances[_addr];
168     }
169     
170     // Using an explicit getter allows for function overloading    
171     function allowance(address _owner, address _spender)
172         public
173         constant
174         returns (uint)
175     {
176         return allowed[_owner][_spender];
177     }
178 
179     // Send _value amount of tokens to address _to
180     function transfer(address _to, uint256 _amount)
181         public
182         returns (bool)
183     {
184         return xfer(msg.sender, _to, _amount);
185     }
186 
187     // Send _value amount of tokens from address _from to address _to
188     function transferFrom(address _from, address _to, uint256 _amount)
189         public
190         returns (bool)
191     {
192         require(_amount <= allowed[_from][msg.sender]);
193         
194         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
195         return xfer(_from, _to, _amount);
196     }
197 
198     // Process a transfer internally.
199     function xfer(address _from, address _to, uint _amount)
200         internal
201         returns (bool)
202     {
203         require(_amount <= balances[_from]);
204 
205         Transfer(_from, _to, _amount);
206         
207         // avoid wasting gas on 0 token transfers
208         if(_amount == 0) return true;
209         
210         balances[_from] = balances[_from].sub(_amount);
211         balances[_to]   = balances[_to].add(_amount);
212         
213         return true;
214     }
215 
216     // Approves a third-party spender
217     function approve(address _spender, uint256 _amount)
218         public
219         returns (bool)
220     {
221         allowed[msg.sender][_spender] = _amount;
222         Approval(msg.sender, _spender, _amount);
223         return true;
224     }
225 }
226 
227 
228 
229 /*-----------------------------------------------------------------------------\
230 
231 ## Conditional Entry Table
232 
233 Functions must throw on F conditions
234 
235 Conditional Entry Table (functions must throw on F conditions)
236 
237 renetry prevention on all public mutating functions
238 Reentry mutex set in moveFundsToWallet(), refund()
239 
240 |function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
241 |------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
242 |()                      |KYC        |T         |F           |T            |F          |
243 |abort()                 |T          |T         |T           |T            |F          |
244 |proxyPurchase()         |KYC        |T         |F           |T            |F          |
245 |addKycAddress()         |T          |T         |F           |T            |T          |
246 |finaliseICO()           |F          |F         |F           |T            |T          |
247 |refund()                |F          |F         |T           |F            |F          |
248 |transfer()              |F          |F         |F           |F            |T          |
249 |transferFrom()          |F          |F         |F           |F            |T          |
250 |approve()               |F          |F         |F           |F            |T          |
251 |changeOwner()           |T          |T         |T           |T            |T          |
252 |acceptOwnership()       |T          |T         |T           |T            |T          |
253 |changedeposito()          |T          |T         |T           |T            |T          |
254 |destroy()               |F          |F         |!__abortFuse|F            |F          |
255 |transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
256 
257 \*----------------------------------------------------------------------------*/
258 
259 contract depositofferTokenAbstract
260 {
261 // TODO comment events
262 
263 // Logged when funder exceeds the KYC limit
264     event KYCAddress(address indexed _addr, bool indexed _kyc);
265 
266 // Logged upon refund
267     event Refunded(address indexed _addr, uint indexed _value);
268 
269 // Logged when new owner accepts ownership
270     event ChangedOwner(address indexed _from, address indexed _to);
271     
272 // Logged when owner initiates a change of ownership
273     event ChangeOwnerTo(address indexed _to);
274 
275 // Logged when ICO ether funds are transferred to an address
276     event FundsTransferred(address indexed _wallet, uint indexed _value);
277 
278 
279     // This fuse blows upon calling abort() which forces a fail state
280     bool public __abortFuse = true;
281     
282     // Set to true after the fund is swept to the fund wallet, allows token
283     // transfers and prevents abort()
284     bool public icoSuccessful;
285 
286     // Token conversion factors are calculated with decimal places at parity with ether
287     uint8 public constant decimals = 18;
288 
289     // An address authorised to take ownership
290     address public newOwner;
291     
292     // The deposito smart contract address
293     address public deposito;
294     
295     // Total ether raised during funding
296     uint public etherRaised;
297     
298     // Preauthorized tranch discount addresses
299     // holder => discount
300     mapping (address => bool) public kycAddresses;
301     
302     // Record of ether paid per address
303     mapping (address => uint) public etherContributed;
304 
305     // Return `true` if MIN_FUNDS were raised
306     function fundSucceeded() public constant returns (bool);
307     
308     // Return `true` if MIN_FUNDS were not raised before END_DATE
309     function fundFailed() public constant returns (bool);
310 
311     // Returns USD raised for set ETH/USD rate
312     function usdRaised() public constant returns (uint);
313 
314     // Returns an amount in eth equivilent to USD at the set rate
315     function usdToEth(uint) public constant returns(uint);
316     
317     // Returns the USD value of ether at the set USD/ETH rate
318     function ethToUsd(uint _wei) public constant returns (uint);
319 
320     // Returns token/ether conversion given ether value and address. 
321     function ethToTokens(uint _eth)
322         public constant returns (uint);
323 
324     // Processes a token purchase for a given address
325     function proxyPurchase(address _addr) payable returns (bool);
326 
327     // Owner can move funds of successful fund to fundWallet 
328     function finaliseICO() public returns (bool);
329     
330     // Registers a discounted address
331     function addKycAddress(address _addr, bool _kyc)
332         public returns (bool);
333 
334     // Refund on failed or aborted sale 
335     function refund(address _addr) public returns (bool);
336 
337     // To cancel token sale prior to START_DATE
338     function abort() public returns (bool);
339     
340     // Change the deposito backend contract address
341     function changedeposito(address _addr) public returns (bool);
342     
343     // For owner to salvage tokens sent to contract
344     function transferAnyERC20Token(address tokenAddress, uint amount)
345         returns (bool);
346 }
347 
348 
349 /*-----------------------------------------------------------------------------\
350 
351  depositoffer token implimentation
352 
353 \*----------------------------------------------------------------------------*/
354 
355 contract depositofferToken is 
356     ReentryProtected,
357     ERC20Token,
358     depositofferTokenAbstract,
359     depositofferTokenConfig
360 {
361     using SafeMath for uint;
362 
363 //
364 // Constants
365 //
366 
367     // USD to ether conversion factors calculated from `depositofferTokenConfig` constants 
368     uint public constant TOKENS_PER_ETH = TOKENS_PER_USD * USD_PER_ETH;
369     uint public constant MIN_ETH_FUND   = 1 ether * MIN_USD_FUND / USD_PER_ETH;
370     uint public constant MAX_ETH_FUND   = 1 ether * MAX_USD_FUND / USD_PER_ETH;
371     uint public constant KYC_ETH_LMT    = 1 ether * KYC_USD_LMT  / USD_PER_ETH;
372 
373     // General funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
374     uint public END_DATE  = START_DATE + FUNDING_PERIOD;
375 
376 //
377 // Modifiers
378 //
379 
380     modifier onlyOwner {
381         require(msg.sender == owner);
382         _;
383     }
384 
385 //
386 // Functions
387 //
388 
389     // Constructor
390     function depositofferToken()
391     {
392         // ICO parameters are set in depositofferTSConfig
393         // Invalid configuration catching here
394         require(bytes(symbol).length > 0);
395         require(bytes(name).length > 0);
396         require(owner != 0x0);
397         require(fundWallet != 0x0);
398         require(TOKENS_PER_USD > 0);
399         require(USD_PER_ETH > 0);
400         require(MIN_USD_FUND > 0);
401         require(MAX_USD_FUND > MIN_USD_FUND);
402         require(START_DATE > 0);
403         require(FUNDING_PERIOD > 0);
404         
405         // Setup and allocate token supply to 18 decimal places
406         totalSupply = MAX_TOKENS * 1e18;
407         balances[fundWallet] = totalSupply;
408         Transfer(0x0, fundWallet, totalSupply);
409     }
410     
411     // Default function
412     function ()
413         payable
414     {
415         // Pass through to purchasing function. Will throw on failed or
416         // successful ICO
417         proxyPurchase(msg.sender);
418     }
419 
420 //
421 // Getters
422 //
423 
424     // ICO fails if aborted or minimum funds are not raised by the end date
425     function fundFailed() public constant returns (bool)
426     {
427         return !__abortFuse
428             || (now > END_DATE && etherRaised < MIN_ETH_FUND);
429     }
430     
431     // Funding succeeds if not aborted, minimum funds are raised before end date
432     function fundSucceeded() public constant returns (bool)
433     {
434         return !fundFailed()
435             && etherRaised >= MIN_ETH_FUND;
436     }
437 
438     // Returns the USD value of ether at the set USD/ETH rate
439     function ethToUsd(uint _wei) public constant returns (uint)
440     {
441         return USD_PER_ETH.mul(_wei).div(1 ether);
442     }
443     
444     // Returns the ether value of USD at the set USD/ETH rate
445     function usdToEth(uint _usd) public constant returns (uint)
446     {
447         return _usd.mul(1 ether).div(USD_PER_ETH);
448     }
449     
450     // Returns the USD value of ether raised at the set USD/ETH rate
451     function usdRaised() public constant returns (uint)
452     {
453         return ethToUsd(etherRaised);
454     }
455     
456     // Returns the number of tokens for given amount of ether for an address 
457     function ethToTokens(uint _wei) public constant returns (uint)
458     {
459         uint usd = ethToUsd(_wei);
460         
461         // Percent bonus funding tiers for USD funding
462         uint bonus = 0;
463     //        usd >= 2000000 ? 35 :
464     //        usd >= 500000  ? 30 :
465     //        usd >= 100000  ? 20 :
466     //        usd >= 25000   ? 15 :
467     //        usd >= 10000   ? 10 :
468     //        usd >= 5000    ? 5  :
469     //        usd >= 1000    ? 1  :                    
470         
471         // using n.2 fixed point decimal for whole number percentage.
472         return _wei.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);
473     }
474 
475 //
476 // ICO functions
477 //
478 
479     // The fundraising can be aborted any time before funds are swept to the
480     // fundWallet.
481     // This will force a fail state and allow refunds to be collected.
482     function abort()
483         public
484         noReentry
485         onlyOwner
486         returns (bool)
487     {
488         require(!icoSuccessful);
489         delete __abortFuse;
490         return true;
491     }
492     
493     // General addresses can purchase tokens during funding
494     function proxyPurchase(address _addr)
495         payable
496         noReentry
497         returns (bool)
498     {
499         require(!fundFailed());
500         require(!icoSuccessful);
501         require(now <= END_DATE);
502         require(msg.value > 0);
503         
504         // Non-KYC'ed funders can only contribute up to $10000 after prefund period
505         if(!kycAddresses[_addr])
506         {
507             require(now >= START_DATE);
508             require((etherContributed[_addr].add(msg.value)) <= KYC_ETH_LMT);
509         }
510 
511         // Get ether to token conversion
512         uint tokens = ethToTokens(msg.value);
513         
514         // transfer tokens from fund wallet
515         
516         xfer(fundWallet, _addr, tokens);
517         
518         // Update holder payments
519         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
520         
521         // Update funds raised
522         etherRaised = etherRaised.add(msg.value);
523         
524         // Bail if this pushes the fund over the USD cap or Token cap
525         require(etherRaised <= MAX_ETH_FUND);
526 
527         return true;
528     }
529     
530     // Owner can KYC (or revoke) addresses until close of funding
531     function addKycAddress(address _addr, bool _kyc)
532     public
533         noReentry
534         onlyOwner
535         returns (bool)
536     {
537        require(!fundFailed());
538 
539         kycAddresses[_addr] = _kyc;
540         KYCAddress(_addr, _kyc);
541       return true;
542     }
543     
544     // Owner can sweep a successful funding to the fundWallet
545     // Contract can be aborted up until this action.
546     // Effective once but can be called multiple time to withdraw edge case
547     // funds recieved by contract which can selfdestruct to this address
548  
549     
550     function finaliseICO()
551         public
552         onlyOwner
553         preventReentry()
554         returns (bool)
555     {
556         require(fundSucceeded());
557 
558         icoSuccessful = true;
559 
560         FundsTransferred(fundWallet, this.balance);
561         fundWallet.transfer(this.balance);
562         return true;
563     }
564     
565     // Refunds can be claimed from a failed ICO
566     function refund(address _addr)
567         public
568         preventReentry()
569         returns (bool)
570     {
571         require(fundFailed());
572         
573         uint value = etherContributed[_addr];
574 
575         // Transfer tokens back to origin
576         // (Not really necessary but looking for graceful exit)
577         xfer(_addr, fundWallet, balances[_addr]);
578 
579         // garbage collect
580         delete etherContributed[_addr];
581         delete kycAddresses[_addr];
582         
583         Refunded(_addr, value);
584         if (value > 0) {
585             _addr.transfer(value);
586         }
587         return true;
588     }
589 
590 //
591 // ERC20 overloaded functions
592 //
593 
594     function transfer(address _to, uint _amount)
595         public
596         preventReentry
597         returns (bool)
598     {
599         // ICO must be successful
600         require(icoSuccessful);
601         super.transfer(_to, _amount);
602 
603         if (_to == deposito)
604             // Notify the deposito contract it has been sent tokens
605             require(Notify(deposito).notify(msg.sender, _amount));
606         return true;
607     }
608 
609     function transferFrom(address _from, address _to, uint _amount)
610         public
611         preventReentry
612         returns (bool)
613     {
614         // ICO must be successful
615         require(icoSuccessful);
616         super.transferFrom(_from, _to, _amount);
617 
618         if (_to == deposito)
619             // Notify the deposito contract it has been sent tokens
620             require(Notify(deposito).notify(msg.sender, _amount));
621         return true;
622     }
623     
624     function approve(address _spender, uint _amount)
625         public
626         noReentry
627         returns (bool)
628     {
629         // ICO must be successful
630         require(icoSuccessful);
631         super.approve(_spender, _amount);
632         return true;
633     }
634 
635 //
636 // Contract managment functions
637 //
638 
639     // To initiate an ownership change
640     function changeOwner(address _newOwner)
641         public
642         noReentry
643         onlyOwner
644         returns (bool)
645     {
646         ChangeOwnerTo(_newOwner);
647         newOwner = _newOwner;
648         return true;
649     }
650 
651     // To accept ownership. Required to prove new address can call the contract.
652     function acceptOwnership()
653         public
654         noReentry
655         returns (bool)
656     {
657         require(msg.sender == newOwner);
658         ChangedOwner(owner, newOwner);
659         owner = newOwner;
660         return true;
661     }
662 
663     // Change the address of the deposito contract address. The contract
664     // must impliment the `Notify` interface.
665     function changedeposito(address _addr)
666         public
667         noReentry
668         onlyOwner
669         returns (bool)
670     {
671         deposito = _addr;
672         return true;
673     }
674     
675     // The contract can be selfdestructed after abort and ether balance is 0.
676     function destroy()
677         public
678         noReentry
679         onlyOwner
680     {
681         require(!__abortFuse);
682         require(this.balance == 0);
683         selfdestruct(owner);
684     }
685     
686     // Owner can salvage ANYTYPE ERC20 tokens that may have been sent to the account by accident 
687     function transferAnyERC20Token(address tokenAddress, uint amount)
688         public
689         onlyOwner
690         preventReentry
691         returns (bool) 
692     {
693         require(ERC20Token(tokenAddress).transfer(owner, amount));
694         return true;
695     }
696 }
697 
698 
699 interface Notify
700 {
701     event Notified(address indexed _from, uint indexed _amount);
702     
703     function notify(address _from, uint _amount) public returns (bool);
704 }
705 
706 
707 contract depositoTest is Notify
708 {
709     address public dot;
710     
711     function setdot(address _addr) { dot = _addr; }
712     
713     function notify(address _from, uint _amount) public returns (bool)
714     {
715         require(msg.sender == dot);
716         Notified(_from, _amount);
717         return true;
718     }
719 }