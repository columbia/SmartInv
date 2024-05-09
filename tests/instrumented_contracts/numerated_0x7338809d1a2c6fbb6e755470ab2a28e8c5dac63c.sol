1 /*
2 file:   OZRealestatesToken.sol
3 ver:    0.1.0
4 modifier: Chris Kwan
5 date:   26-Aug-2017
6 email:  ecorpnu AT gmail.com
7 (Adapted from VentanaToken.sol by Darryl Morris)
8 
9 A collated contract set for a token sale specific to the requirments of
10 Ozreal's OZRealestates token product.
11 
12 This software is distributed in the hope that it will be useful,
13 but WITHOUT ANY WARRANTY; without even the implied warranty of
14 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
15 See MIT Licence for further details.
16 <https://opensource.org/licenses/MIT>.
17 
18 */
19 
20 
21 pragma solidity ^0.4.13;
22 
23 /*-----------------------------------------------------------------------------\
24 
25  OZRealestates token sale configuration
26 
27 \*----------------------------------------------------------------------------*/
28 
29 // Contains token sale parameters
30 contract OZRealestatesTokenConfig
31 {
32     // ERC20 trade name and symbol
33     string public           name            = "OZRealestates";
34     string public           symbol          = "OZR";
35 
36     // Owner has power to abort, discount addresses, sweep successful funds,
37     // change owner, sweep alien tokens.
38     address public          owner           = 0xB353cF41A0CAa38D6597A7a1337debf0b09dd8ae; // OZRPrimary address checksummed
39     
40     // Fund wallet should also be audited prior to deployment
41     // NOTE: Must be checksummed address!
42     address public          fundWallet      = 0xE4Be3157DBD71Acd7Ad5667db00AA111C0088195; // multiSig address checksummed
43 
44     // Tokens awarded per USD contributed
45     uint public constant    TOKENS_PER_USD  = 1;
46 
47     // Ether market price in USD
48     uint public constant    USD_PER_ETH     = 376; // approx 7 day average High Low as at 30th August 2017
49     
50     // Minimum and maximum target in USD
51     uint public constant    MIN_USD_FUND    = 1;  // $1
52     uint public constant    MAX_USD_FUND    = 2000000; // $2m
53     
54     // Non-KYC contribution limit in USD
55     uint public constant    KYC_USD_LMT     = 50000;
56     
57     // There will be exactly 100,000,000 tokens regardless of number sold
58     // Unsold tokens are put into the Strategic Growth token pool
59     uint public constant    MAX_TOKENS      = 100000000;
60     
61     // Funding begins on 31th August 2017
62     
63     uint public constant    START_DATE      = 1504137600; // 31.8.2017 10 AM Sydney Time
64 
65     // Period for fundraising
66     uint public constant    FUNDING_PERIOD  = 40 days;
67 }
68 
69 
70 library SafeMath
71 {
72     // a add to b
73     function add(uint a, uint b) internal returns (uint c) {
74         c = a + b;
75         assert(c >= a);
76     }
77     
78     // a subtract b
79     function sub(uint a, uint b) internal returns (uint c) {
80         c = a - b;
81         assert(c <= a);
82     }
83     
84     // a multiplied by b
85     function mul(uint a, uint b) internal returns (uint c) {
86         c = a * b;
87         assert(a == 0 || c / a == b);
88     }
89     
90     // a divided by b
91     function div(uint a, uint b) internal returns (uint c) {
92         c = a / b;
93         // No assert required as no overflows are posible.
94     }
95 }
96 
97 
98 contract ReentryProtected
99 {
100     // The reentry protection state mutex.
101     bool __reMutex;
102 
103     // Sets and resets mutex in order to block functin reentry
104     modifier preventReentry() {
105         require(!__reMutex);
106         __reMutex = true;
107         _;
108         delete __reMutex;
109     }
110 
111     // Blocks function entry if mutex is set
112     modifier noReentry() {
113         require(!__reMutex);
114         _;
115     }
116 }
117 
118 contract ERC20Token
119 {
120     using SafeMath for uint;
121 
122 /* Constants */
123 
124     // none
125     
126 /* State variable */
127 
128     /// @return The Total supply of tokens
129     uint public totalSupply;
130     
131     /// @return Token symbol
132     string public symbol;
133     
134     // Token ownership mapping
135     mapping (address => uint) balances;
136     
137     // Allowances mapping
138     mapping (address => mapping (address => uint)) allowed;
139 
140 /* Events */
141 
142     // Triggered when tokens are transferred.
143     event Transfer(
144         address indexed _from,
145         address indexed _to,
146         uint256 _amount);
147 
148     // Triggered whenever approve(address _spender, uint256 _amount) is called.
149     event Approval(
150         address indexed _owner,
151         address indexed _spender,
152         uint256 _amount);
153 
154 /* Modifiers */
155 
156     // none
157     
158 /* Functions */
159 
160     // Using an explicit getter allows for function overloading    
161     function balanceOf(address _addr)
162         public
163         constant
164         returns (uint)
165     {
166         return balances[_addr];
167     }
168     
169     // Using an explicit getter allows for function overloading    
170     function allowance(address _owner, address _spender)
171         public
172         constant
173         returns (uint)
174     {
175         return allowed[_owner][_spender];
176     }
177 
178     // Send _value amount of tokens to address _to
179     function transfer(address _to, uint256 _amount)
180         public
181         returns (bool)
182     {
183         return xfer(msg.sender, _to, _amount);
184     }
185 
186     // Send _value amount of tokens from address _from to address _to
187     function transferFrom(address _from, address _to, uint256 _amount)
188         public
189         returns (bool)
190     {
191         require(_amount <= allowed[_from][msg.sender]);
192         
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194         return xfer(_from, _to, _amount);
195     }
196 
197     // Process a transfer internally.
198     function xfer(address _from, address _to, uint _amount)
199         internal
200         returns (bool)
201     {
202         require(_amount <= balances[_from]);
203 
204         Transfer(_from, _to, _amount);
205         
206         // avoid wasting gas on 0 token transfers
207         if(_amount == 0) return true;
208         
209         balances[_from] = balances[_from].sub(_amount);
210         balances[_to]   = balances[_to].add(_amount);
211         
212         return true;
213     }
214 
215     // Approves a third-party spender
216     function approve(address _spender, uint256 _amount)
217         public
218         returns (bool)
219     {
220         allowed[msg.sender][_spender] = _amount;
221         Approval(msg.sender, _spender, _amount);
222         return true;
223     }
224 }
225 
226 
227 
228 /*-----------------------------------------------------------------------------\
229 
230 ## Conditional Entry Table
231 
232 Functions must throw on F conditions
233 
234 Conditional Entry Table (functions must throw on F conditions)
235 
236 renetry prevention on all public mutating functions
237 Reentry mutex set in moveFundsToWallet(), refund()
238 
239 |function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
240 |------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
241 |()                            |KYC        |T         |F           |T            |F          |
242 |abort()                 |T          |T         |T           |T            |F          |
243 |proxyPurchase()         |KYC        |T         |F           |T            |F          |
244 |addKycAddress()         |T          |T         |F           |T            |T          |
245 |finaliseICO()           |F          |F         |F           |T            |T          |
246 |refund()                |F          |F         |T           |F            |F          |
247 |transfer()              |F          |F         |F           |F            |T          |
248 |transferFrom()          |F          |F         |F           |F            |T          |
249 |approve()               |F          |F         |F           |F            |T          |
250 |changeOwner()           |T          |T         |T           |T            |T          |
251 |acceptOwnership()       |T          |T         |T           |T            |T          |
252 |changeOzreal()          |T          |T         |T           |T            |T          |
253 |destroy()               |F          |F         |!__abortFuse|F            |F          |
254 |transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
255 
256 \*----------------------------------------------------------------------------*/
257 
258 contract OZRealestatesTokenAbstract
259 {
260 // TODO comment events
261     event KYCAddress(address indexed _addr, bool indexed _kyc);
262     event Refunded(address indexed _addr, uint indexed _value);
263     event ChangedOwner(address indexed _from, address indexed _to);
264     event ChangeOwnerTo(address indexed _to);
265     event FundsTransferred(address indexed _wallet, uint indexed _value);
266 
267     // This fuse blows upon calling abort() which forces a fail state
268     bool public __abortFuse = true;
269     
270     // Set to true after the fund is swept to the fund wallet, allows token
271     // transfers and prevents abort()
272     bool public icoSuccessful;
273 
274     // Token conversion factors are calculated with decimal places at parity with ether
275     uint8 public constant decimals = 18;
276 
277     // An address authorised to take ownership
278     address public newOwner;
279     
280     // The Ozreal smart contract address
281     address public Ozreal;
282     
283     // Total ether raised during funding
284     uint public etherRaised;
285     
286     // Preauthorized tranch discount addresses
287     // holder => discount
288     mapping (address => bool) public kycAddresses;
289     
290     // Record of ether paid per address
291     mapping (address => uint) public etherContributed;
292 
293     // Return `true` if MIN_FUNDS were raised
294     function fundSucceeded() public constant returns (bool);
295     
296     // Return `true` if MIN_FUNDS were not raised before END_DATE
297     function fundFailed() public constant returns (bool);
298 
299     // Returns USD raised for set ETH/USD rate
300     function usdRaised() public constant returns (uint);
301 
302     // Returns an amount in eth equivilent to USD at the set rate
303     function usdToEth(uint) public constant returns(uint);
304     
305     // Returns the USD value of ether at the set USD/ETH rate
306     function ethToUsd(uint _wei) public constant returns (uint);
307 
308     // Returns token/ether conversion given ether value and address. 
309     function ethToTokens(uint _eth)
310         public constant returns (uint);
311 
312     // Processes a token purchase for a given address
313     function proxyPurchase(address _addr) payable returns (bool);
314 
315     // Owner can move funds of successful fund to fundWallet 
316     function finaliseICO() public returns (bool);
317     
318     // Registers a discounted address
319     function addKycAddress(address _addr, bool _kyc)
320         public returns (bool);
321 
322     // Refund on failed or aborted sale 
323     function refund(address _addr) public returns (bool);
324 
325     // To cancel token sale prior to START_DATE
326     function abort() public returns (bool);
327     
328     // Change the Ozreal backend contract address
329     function changeOzreal(address _addr) public returns (bool);
330     
331     // For owner to salvage tokens sent to contract
332     function transferAnyERC20Token(address tokenAddress, uint amount)
333         returns (bool);
334 }
335 
336 
337 /*-----------------------------------------------------------------------------\
338 
339  OZRealestates token implimentation
340 
341 \*----------------------------------------------------------------------------*/
342 
343 contract OZRealestatesToken is 
344     ReentryProtected,
345     ERC20Token,
346     OZRealestatesTokenAbstract,
347     OZRealestatesTokenConfig
348 {
349     using SafeMath for uint;
350 
351 //
352 // Constants
353 //
354 
355     // USD to ether conversion factors calculated from `OZRealestatesTokenConfig` constants 
356     uint public constant TOKENS_PER_ETH = TOKENS_PER_USD * USD_PER_ETH;
357     uint public constant MIN_ETH_FUND   = 1 ether * MIN_USD_FUND / USD_PER_ETH;
358     uint public constant MAX_ETH_FUND   = 1 ether * MAX_USD_FUND / USD_PER_ETH;
359     uint public constant KYC_ETH_LMT    = 1 ether * KYC_USD_LMT  / USD_PER_ETH;
360 
361     // General funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
362     uint public END_DATE  = START_DATE + FUNDING_PERIOD;
363 
364 //
365 // Modifiers
366 //
367 
368     modifier onlyOwner {
369         require(msg.sender == owner);
370         _;
371     }
372 
373 //
374 // Functions
375 //
376 
377     // Constructor
378     function OZRealestatesToken()
379     {
380         // ICO parameters are set in OZRealestatesTSConfig
381         // Invalid configuration catching here
382         require(bytes(symbol).length > 0);
383         require(bytes(name).length > 0);
384         require(owner != 0x0);
385         require(fundWallet != 0x0);
386         require(TOKENS_PER_USD > 0);
387         require(USD_PER_ETH > 0);
388         require(MIN_USD_FUND > 0);
389         require(MAX_USD_FUND > MIN_USD_FUND);
390         require(START_DATE > 0);
391         require(FUNDING_PERIOD > 0);
392         
393         // Setup and allocate token supply to 18 decimal places
394         totalSupply = MAX_TOKENS * 1e18;
395         balances[fundWallet] = totalSupply;
396         Transfer(0x0, fundWallet, totalSupply);
397     }
398     
399     // Default function
400     function ()
401         payable
402     {
403         // Pass through to purchasing function. Will throw on failed or
404         // successful ICO
405         proxyPurchase(msg.sender);
406     }
407 
408 //
409 // Getters
410 //
411 
412     // ICO fails if aborted or minimum funds are not raised by the end date
413     function fundFailed() public constant returns (bool)
414     {
415         return !__abortFuse
416             || (now > END_DATE && etherRaised < MIN_ETH_FUND);
417     }
418     
419     // Funding succeeds if not aborted, minimum funds are raised before end date
420     function fundSucceeded() public constant returns (bool)
421     {
422         return !fundFailed()
423             && etherRaised >= MIN_ETH_FUND;
424     }
425 
426     // Returns the USD value of ether at the set USD/ETH rate
427     function ethToUsd(uint _wei) public constant returns (uint)
428     {
429         return USD_PER_ETH.mul(_wei).div(1 ether);
430     }
431     
432     // Returns the ether value of USD at the set USD/ETH rate
433     function usdToEth(uint _usd) public constant returns (uint)
434     {
435         return _usd.mul(1 ether).div(USD_PER_ETH);
436     }
437     
438     // Returns the USD value of ether raised at the set USD/ETH rate
439     function usdRaised() public constant returns (uint)
440     {
441         return ethToUsd(etherRaised);
442     }
443     
444     // Returns the number of tokens for given amount of ether for an address 
445     function ethToTokens(uint _wei) public constant returns (uint)
446     {
447         uint usd = ethToUsd(_wei);
448         
449         // Percent bonus funding tiers for USD funding
450         uint bonus =
451     //        usd >= 2000000 ? 35 :
452     //        usd >= 500000  ? 30 :
453     //        usd >= 100000  ? 20 :
454     //        usd >= 25000   ? 15 :
455     //        usd >= 10000   ? 10 :
456     //        usd >= 5000    ? 5  :
457                              0;  
458         
459         // using n.2 fixed point decimal for whole number percentage.
460         return _wei.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);
461     }
462 
463 //
464 // ICO functions
465 //
466 
467     // The fundraising can be aborted any time before funds are swept to the
468     // fundWallet.
469     // This will force a fail state and allow refunds to be collected.
470     function abort()
471         public
472         noReentry
473         onlyOwner
474         returns (bool)
475     {
476         require(!icoSuccessful);
477         delete __abortFuse;
478         return true;
479     }
480     
481     // General addresses can purchase tokens during funding
482     function proxyPurchase(address _addr)
483         payable
484         noReentry
485         returns (bool)
486     {
487         require(!fundFailed());
488         require(!icoSuccessful);
489         require(now <= END_DATE);
490         require(msg.value > 0);
491         
492         // Non-KYC'ed funders can only contribute up to $10000 after prefund period
493         if(!kycAddresses[_addr])
494         {
495             require(now >= START_DATE);
496             require((etherContributed[_addr].add(msg.value)) <= KYC_ETH_LMT);
497         }
498 
499         // Get ether to token conversion
500         uint tokens = ethToTokens(msg.value);
501         
502         // transfer tokens from fund wallet
503         xfer(fundWallet, _addr, tokens);
504         
505         // Update holder payments
506         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
507         
508         // Update funds raised
509         etherRaised = etherRaised.add(msg.value);
510         
511         // Bail if this pushes the fund over the USD cap or Token cap
512         require(etherRaised <= MAX_ETH_FUND);
513 
514         return true;
515     }
516     
517     // Owner can KYC (or revoke) addresses until close of funding
518     function addKycAddress(address _addr, bool _kyc)
519     public
520         noReentry
521         onlyOwner
522         returns (bool)
523     {
524        require(!fundFailed());
525 
526         kycAddresses[_addr] = _kyc;
527         KYCAddress(_addr, _kyc);
528       return true;
529     }
530     
531     // Owner can sweep a successful funding to the fundWallet
532     // Contract can be aborted up until this action.
533     
534     function finaliseICO()
535         public
536         onlyOwner
537         preventReentry()
538         returns (bool)
539     {
540         require(fundSucceeded());
541 
542         icoSuccessful = true;
543 
544         FundsTransferred(fundWallet, this.balance);
545         fundWallet.transfer(this.balance);
546         return true;
547     }
548     
549     // Refunds can be claimed from a failed ICO
550     function refund(address _addr)
551         public
552         preventReentry()
553         returns (bool)
554     {
555         require(fundFailed());
556         
557         uint value = etherContributed[_addr];
558 
559         // Transfer tokens back to origin
560         // (Not really necessary but looking for graceful exit)
561         xfer(_addr, fundWallet, balances[_addr]);
562 
563         // garbage collect
564         delete etherContributed[_addr];
565         delete kycAddresses[_addr];
566         
567         Refunded(_addr, value);
568         if (value > 0) {
569             _addr.transfer(value);
570         }
571         return true;
572     }
573 
574 //
575 // ERC20 overloaded functions
576 //
577 
578     function transfer(address _to, uint _amount)
579         public
580         preventReentry
581         returns (bool)
582     {
583         // ICO must be successful
584         require(icoSuccessful);
585         super.transfer(_to, _amount);
586 
587         if (_to == Ozreal)
588             // Notify the Ozreal contract it has been sent tokens
589             require(Notify(Ozreal).notify(msg.sender, _amount));
590         return true;
591     }
592 
593     function transferFrom(address _from, address _to, uint _amount)
594         public
595         preventReentry
596         returns (bool)
597     {
598         // ICO must be successful
599         require(icoSuccessful);
600         super.transferFrom(_from, _to, _amount);
601 
602         if (_to == Ozreal)
603             // Notify the Ozreal contract it has been sent tokens
604             require(Notify(Ozreal).notify(msg.sender, _amount));
605         return true;
606     }
607     
608     function approve(address _spender, uint _amount)
609         public
610         noReentry
611         returns (bool)
612     {
613         // ICO must be successful
614         require(icoSuccessful);
615         super.approve(_spender, _amount);
616         return true;
617     }
618 
619 //
620 // Contract managment functions
621 //
622 
623     // To initiate an ownership change
624     function changeOwner(address _newOwner)
625         public
626         noReentry
627         onlyOwner
628         returns (bool)
629     {
630         ChangeOwnerTo(_newOwner);
631         newOwner = _newOwner;
632         return true;
633     }
634 
635     // To accept ownership. Required to prove new address can call the contract.
636     function acceptOwnership()
637         public
638         noReentry
639         returns (bool)
640     {
641         require(msg.sender == newOwner);
642         ChangedOwner(owner, newOwner);
643         owner = newOwner;
644         return true;
645     }
646 
647     // Change the address of the Ozreal contract address. The contract
648     // must impliment the `Notify` interface.
649     function changeOzreal(address _addr)
650         public
651         noReentry
652         onlyOwner
653         returns (bool)
654     {
655         Ozreal = _addr;
656         return true;
657     }
658     
659     // The contract can be selfdestructed after abort and ether balance is 0.
660     function destroy()
661         public
662         noReentry
663         onlyOwner
664     {
665         require(!__abortFuse);
666         require(this.balance == 0);
667         selfdestruct(owner);
668     }
669     
670     // Owner can salvage ERC20 tokens that may have been sent to the account
671     function transferAnyERC20Token(address tokenAddress, uint amount)
672         public
673         onlyOwner
674         preventReentry
675         returns (bool) 
676     {
677         require(ERC20Token(tokenAddress).transfer(owner, amount));
678         return true;
679     }
680 }
681 
682 
683 interface Notify
684 {
685     event Notified(address indexed _from, uint indexed _amount);
686     
687     function notify(address _from, uint _amount) public returns (bool);
688 }
689 
690 
691 contract OzrealTest is Notify
692 {
693     address public ozr;
694     
695     function setOzr(address _addr) { ozr = _addr; }
696     
697     function notify(address _from, uint _amount) public returns (bool)
698     {
699         require(msg.sender == ozr);
700         Notified(_from, _amount);
701         return true;
702     }
703 }