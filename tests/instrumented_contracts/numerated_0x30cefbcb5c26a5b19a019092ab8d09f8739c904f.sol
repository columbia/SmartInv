1 /*
2 file:   VentanaToken.sol
3 ver:    0.1.0
4 author: Darryl Morris
5 date:   14-Aug-2017
6 email:  o0ragman0o AT gmail.com
7 (c) Darryl Morris 2017
8 
9 A collated contract set for a token sale specific to the requirments of
10 Veredictum's Ventana token product.
11 
12 This software is distributed in the hope that it will be useful,
13 but WITHOUT ANY WARRANTY; without even the implied warranty of
14 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
15 See MIT Licence for further details.
16 <https://opensource.org/licenses/MIT>.
17 
18 Release Notes
19 -------------
20 0.1.0
21 * Release version
22 * updated owner, fundWallet, USD_PER_ETH, and START_DATE to final values in VentanaTokenConfig
23 
24 
25 */
26 
27 
28 pragma solidity ^0.4.13;
29 
30 /*-----------------------------------------------------------------------------\
31 
32  Ventana token sale configuration
33 
34 \*----------------------------------------------------------------------------*/
35 
36 // Contains token sale parameters
37 contract VentanaTokenConfig
38 {
39     // ERC20 trade name and symbol
40     string public           name            = "Ventana";
41     string public           symbol          = "VNT";
42 
43     // Owner has power to abort, discount addresses, sweep successful funds,
44     // change owner, sweep alien tokens.
45     address public          owner           = 0xF4b087Ad256ABC5BE11E0433B15Ed012c8AEC8B4; // veredictumPrimary address checksummed
46     
47     // Fund wallet should also be audited prior to deployment
48     // NOTE: Must be checksummed address!
49     address public          fundWallet      = 0xd6514387236595e080B97c8ead1cBF12f9a6Ab65; // multiSig address checksummed
50 
51     // Tokens awarded per USD contributed
52     uint public constant    TOKENS_PER_USD  = 3;
53 
54     // Ether market price in USD
55     uint public constant    USD_PER_ETH     = 258; // calculated from 60 day moving average as at 14th August 2017
56     
57     // Minimum and maximum target in USD
58     uint public constant    MIN_USD_FUND    = 2000000;  // $2m
59     uint public constant    MAX_USD_FUND    = 20000000; // $20m
60     
61     // Non-KYC contribution limit in USD
62     uint public constant    KYC_USD_LMT     = 10000;
63     
64     // There will be exactly 300,000,000 tokens regardless of number sold
65     // Unsold tokens are put into the Strategic Growth token pool
66     uint public constant    MAX_TOKENS      = 300000000;
67     
68     // Funding begins on 14th August 2017
69     // `+ new Date('19:00 14 August 2017')/1000`
70     uint public constant    START_DATE      = 1502701200; // Mon Aug 14 2017 19:00:00 GMT+1000 (AEST)
71 
72     // Period for fundraising
73     uint public constant    FUNDING_PERIOD  = 28 days;
74 }
75 
76 
77 library SafeMath
78 {
79     // a add to b
80     function add(uint a, uint b) internal returns (uint c) {
81         c = a + b;
82         assert(c >= a);
83     }
84     
85     // a subtract b
86     function sub(uint a, uint b) internal returns (uint c) {
87         c = a - b;
88         assert(c <= a);
89     }
90     
91     // a multiplied by b
92     function mul(uint a, uint b) internal returns (uint c) {
93         c = a * b;
94         assert(a == 0 || c / a == b);
95     }
96     
97     // a divided by b
98     function div(uint a, uint b) internal returns (uint c) {
99         c = a / b;
100         // No assert required as no overflows are posible.
101     }
102 }
103 
104 
105 contract ReentryProtected
106 {
107     // The reentry protection state mutex.
108     bool __reMutex;
109 
110     // Sets and resets mutex in order to block functin reentry
111     modifier preventReentry() {
112         require(!__reMutex);
113         __reMutex = true;
114         _;
115         delete __reMutex;
116     }
117 
118     // Blocks function entry if mutex is set
119     modifier noReentry() {
120         require(!__reMutex);
121         _;
122     }
123 }
124 
125 contract ERC20Token
126 {
127     using SafeMath for uint;
128 
129 /* Constants */
130 
131     // none
132     
133 /* State variable */
134 
135     /// @return The Total supply of tokens
136     uint public totalSupply;
137     
138     /// @return Token symbol
139     string public symbol;
140     
141     // Token ownership mapping
142     mapping (address => uint) balances;
143     
144     // Allowances mapping
145     mapping (address => mapping (address => uint)) allowed;
146 
147 /* Events */
148 
149     // Triggered when tokens are transferred.
150     event Transfer(
151         address indexed _from,
152         address indexed _to,
153         uint256 _amount);
154 
155     // Triggered whenever approve(address _spender, uint256 _amount) is called.
156     event Approval(
157         address indexed _owner,
158         address indexed _spender,
159         uint256 _amount);
160 
161 /* Modifiers */
162 
163     // none
164     
165 /* Functions */
166 
167     // Using an explicit getter allows for function overloading    
168     function balanceOf(address _addr)
169         public
170         constant
171         returns (uint)
172     {
173         return balances[_addr];
174     }
175     
176     // Using an explicit getter allows for function overloading    
177     function allowance(address _owner, address _spender)
178         public
179         constant
180         returns (uint)
181     {
182         return allowed[_owner][_spender];
183     }
184 
185     // Send _value amount of tokens to address _to
186     function transfer(address _to, uint256 _amount)
187         public
188         returns (bool)
189     {
190         return xfer(msg.sender, _to, _amount);
191     }
192 
193     // Send _value amount of tokens from address _from to address _to
194     function transferFrom(address _from, address _to, uint256 _amount)
195         public
196         returns (bool)
197     {
198         require(_amount <= allowed[_from][msg.sender]);
199         
200         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
201         return xfer(_from, _to, _amount);
202     }
203 
204     // Process a transfer internally.
205     function xfer(address _from, address _to, uint _amount)
206         internal
207         returns (bool)
208     {
209         require(_amount <= balances[_from]);
210 
211         Transfer(_from, _to, _amount);
212         
213         // avoid wasting gas on 0 token transfers
214         if(_amount == 0) return true;
215         
216         balances[_from] = balances[_from].sub(_amount);
217         balances[_to]   = balances[_to].add(_amount);
218         
219         return true;
220     }
221 
222     // Approves a third-party spender
223     function approve(address _spender, uint256 _amount)
224         public
225         returns (bool)
226     {
227         allowed[msg.sender][_spender] = _amount;
228         Approval(msg.sender, _spender, _amount);
229         return true;
230     }
231 }
232 
233 
234 
235 /*-----------------------------------------------------------------------------\
236 
237 ## Conditional Entry Table
238 
239 Functions must throw on F conditions
240 
241 Conditional Entry Table (functions must throw on F conditions)
242 
243 renetry prevention on all public mutating functions
244 Reentry mutex set in moveFundsToWallet(), refund()
245 
246 |function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
247 |------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
248 |()                      |KYC        |T         |F           |T            |F          |
249 |abort()                 |T          |T         |T           |T            |F          |
250 |proxyPurchase()         |KYC        |T         |F           |T            |F          |
251 |addKycAddress()         |T          |T         |F           |T            |T          |
252 |finaliseICO()           |F          |F         |F           |T            |T          |
253 |refund()                |F          |F         |T           |F            |F          |
254 |transfer()              |F          |F         |F           |F            |T          |
255 |transferFrom()          |F          |F         |F           |F            |T          |
256 |approve()               |F          |F         |F           |F            |T          |
257 |changeOwner()           |T          |T         |T           |T            |T          |
258 |acceptOwnership()       |T          |T         |T           |T            |T          |
259 |changeVeredictum()      |T          |T         |T           |T            |T          |
260 |destroy()               |F          |F         |!__abortFuse|F            |F          |
261 |transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
262 
263 \*----------------------------------------------------------------------------*/
264 
265 contract VentanaTokenAbstract
266 {
267 // TODO comment events
268     event KYCAddress(address indexed _addr, bool indexed _kyc);
269     event Refunded(address indexed _addr, uint indexed _value);
270     event ChangedOwner(address indexed _from, address indexed _to);
271     event ChangeOwnerTo(address indexed _to);
272     event FundsTransferred(address indexed _wallet, uint indexed _value);
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
287     // The Veredictum smart contract address
288     address public veredictum;
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
335     // Change the Veredictum backend contract address
336     function changeVeredictum(address _addr) public returns (bool);
337     
338     // For owner to salvage tokens sent to contract
339     function transferAnyERC20Token(address tokenAddress, uint amount)
340         returns (bool);
341 }
342 
343 
344 /*-----------------------------------------------------------------------------\
345 
346  Ventana token implimentation
347 
348 \*----------------------------------------------------------------------------*/
349 
350 contract VentanaToken is 
351     ReentryProtected,
352     ERC20Token,
353     VentanaTokenAbstract,
354     VentanaTokenConfig
355 {
356     using SafeMath for uint;
357 
358 //
359 // Constants
360 //
361 
362     // USD to ether conversion factors calculated from `VentanaTokenConfig` constants 
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
385     function VentanaToken()
386     {
387         // ICO parameters are set in VentanaTSConfig
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
457         uint bonus =
458             usd >= 2000000 ? 35 :
459             usd >= 500000  ? 30 :
460             usd >= 100000  ? 20 :
461             usd >= 25000   ? 15 :
462             usd >= 10000   ? 10 :
463             usd >= 5000    ? 5  :
464                              0;  
465         
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
510         xfer(fundWallet, _addr, tokens);
511         
512         // Update holder payments
513         etherContributed[_addr] = etherContributed[_addr].add(msg.value);
514         
515         // Update funds raised
516         etherRaised = etherRaised.add(msg.value);
517         
518         // Bail if this pushes the fund over the USD cap or Token cap
519         require(etherRaised <= MAX_ETH_FUND);
520 
521         return true;
522     }
523     
524     // Owner can KYC (or revoke) addresses until close of funding
525     function addKycAddress(address _addr, bool _kyc)
526         public
527         noReentry
528         onlyOwner
529         returns (bool)
530     {
531         require(!fundFailed());
532 
533         kycAddresses[_addr] = _kyc;
534         KYCAddress(_addr, _kyc);
535         return true;
536     }
537     
538     // Owner can sweep a successful funding to the fundWallet
539     // Contract can be aborted up until this action.
540     function finaliseICO()
541         public
542         onlyOwner
543         preventReentry()
544         returns (bool)
545     {
546         require(fundSucceeded());
547 
548         icoSuccessful = true;
549 
550         FundsTransferred(fundWallet, this.balance);
551         fundWallet.transfer(this.balance);
552         return true;
553     }
554     
555     // Refunds can be claimed from a failed ICO
556     function refund(address _addr)
557         public
558         preventReentry()
559         returns (bool)
560     {
561         require(fundFailed());
562         
563         uint value = etherContributed[_addr];
564 
565         // Transfer tokens back to origin
566         // (Not really necessary but looking for graceful exit)
567         xfer(_addr, fundWallet, balances[_addr]);
568 
569         // garbage collect
570         delete etherContributed[_addr];
571         delete kycAddresses[_addr];
572         
573         Refunded(_addr, value);
574         if (value > 0) {
575             _addr.transfer(value);
576         }
577         return true;
578     }
579 
580 //
581 // ERC20 overloaded functions
582 //
583 
584     function transfer(address _to, uint _amount)
585         public
586         preventReentry
587         returns (bool)
588     {
589         // ICO must be successful
590         require(icoSuccessful);
591         super.transfer(_to, _amount);
592 
593         if (_to == veredictum)
594             // Notify the Veredictum contract it has been sent tokens
595             require(Notify(veredictum).notify(msg.sender, _amount));
596         return true;
597     }
598 
599     function transferFrom(address _from, address _to, uint _amount)
600         public
601         preventReentry
602         returns (bool)
603     {
604         // ICO must be successful
605         require(icoSuccessful);
606         super.transferFrom(_from, _to, _amount);
607 
608         if (_to == veredictum)
609             // Notify the Veredictum contract it has been sent tokens
610             require(Notify(veredictum).notify(msg.sender, _amount));
611         return true;
612     }
613     
614     function approve(address _spender, uint _amount)
615         public
616         noReentry
617         returns (bool)
618     {
619         // ICO must be successful
620         require(icoSuccessful);
621         super.approve(_spender, _amount);
622         return true;
623     }
624 
625 //
626 // Contract managment functions
627 //
628 
629     // To initiate an ownership change
630     function changeOwner(address _newOwner)
631         public
632         noReentry
633         onlyOwner
634         returns (bool)
635     {
636         ChangeOwnerTo(_newOwner);
637         newOwner = _newOwner;
638         return true;
639     }
640 
641     // To accept ownership. Required to prove new address can call the contract.
642     function acceptOwnership()
643         public
644         noReentry
645         returns (bool)
646     {
647         require(msg.sender == newOwner);
648         ChangedOwner(owner, newOwner);
649         owner = newOwner;
650         return true;
651     }
652 
653     // Change the address of the Veredictum contract address. The contract
654     // must impliment the `Notify` interface.
655     function changeVeredictum(address _addr)
656         public
657         noReentry
658         onlyOwner
659         returns (bool)
660     {
661         veredictum = _addr;
662         return true;
663     }
664     
665     // The contract can be selfdestructed after abort and ether balance is 0.
666     function destroy()
667         public
668         noReentry
669         onlyOwner
670     {
671         require(!__abortFuse);
672         require(this.balance == 0);
673         selfdestruct(owner);
674     }
675     
676     // Owner can salvage ERC20 tokens that may have been sent to the account
677     function transferAnyERC20Token(address tokenAddress, uint amount)
678         public
679         onlyOwner
680         preventReentry
681         returns (bool) 
682     {
683         require(ERC20Token(tokenAddress).transfer(owner, amount));
684         return true;
685     }
686 }
687 
688 
689 interface Notify
690 {
691     event Notified(address indexed _from, uint indexed _amount);
692     
693     function notify(address _from, uint _amount) public returns (bool);
694 }
695 
696 
697 contract VeredictumTest is Notify
698 {
699     address public vnt;
700     
701     function setVnt(address _addr) { vnt = _addr; }
702     
703     function notify(address _from, uint _amount) public returns (bool)
704     {
705         require(msg.sender == vnt);
706         Notified(_from, _amount);
707         return true;
708     }
709 }