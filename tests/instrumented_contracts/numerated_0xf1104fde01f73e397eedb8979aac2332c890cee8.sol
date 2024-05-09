1 pragma solidity ^0.4.24;
2 
3 
4 /* ----------------------------------------------------------------------------
5 | Sheltercoin ICO 'Sheltercoin Token' Crowdfunding contract
6 | Date - 16-November-2017
7 | Blockchain Date - Dec 4 2018
8 | copyright 2017 zMint Limited. All Rights Reserved.
9 | authors A Campbell, S Outtrim
10 | Vers - 000 v001
11 | ------------------------
12 | Updates 
13 | Date 25-Aug-17 ADC Finalising format
14 | Date 27-Aug-17 ADC Code review amendments
15 | Date 01-Sep-17 ADC Changes 
16 | Date 16-Nov-17 ADC Sheltercoin Pre-ICO phase
17 | Date 27-Nov-17 ADC Pragma 17 Changes
18 | Date 12-Dec-17 SO, ADC Code Review, testing; production migration.
19 | Date 01-May-18 ADC Code changes
20 | Date 12-May-18 ADC KYC Client Verication 
21 | Date 29-May-18 SO, ADC Code Revew, testing
22 | Date 11-Jun-18 SO  hard coding, testing, production migration. 
23 |                    Removed TransferAnyERC20Token, KYC contract shell
24 |                    Added whitelist and blacklist code
25 |                    Added bonus calc to ICO function
26 | Date 08-Aug-18 SO  Updated function to constructor()
27 |                    Added SHLT specific function to SHLT code, replaced names
28 | Date 07-Feb-19 SO  Production deployment of new SHLT token
29 |                    
30 | 
31 | Sheltercoin.io :-)
32 | :-) hAVe aN aWeSoMe iCo :-) 
33 |
34 // ---------------------------------------------------------------------------- */
35 
36 
37 /* =============================================================================
38 | Sheltercoin ICO 'Sheltercoin Token & Crowdfunding 
39 |
40 | 001. contract - ERC20 Token Interface
41 |
42 |
43 |
44 | Apache Licence
45 | ============================================================================= */
46 
47 
48 /* ============================================================================
49 |
50 | Token Standard #20 Interface
51 | https://github.com/ethereum/EIPs/issues/20
52 | 
53 | ============================================================================ */
54 
55 
56 contract ERC20Interface {
57     uint public totalSupply;
58     uint public tokensSold;
59     function balanceOf(address _owner) public constant returns (uint balance);
60     function transfer(address _to, uint _value) public returns (bool success);
61     function transferFrom(address _from, address _to, uint _value) 
62         public returns (bool success);
63     function approve(address _spender, uint _value) public returns (bool success);
64     function allowance(address _owner, address _spender) public constant 
65         returns (uint remaining);
66     event Transfer(address indexed _from, address indexed _to, uint _value);
67     event Approval(address indexed _owner, address indexed _spender, 
68         uint _value);
69 }
70 
71 
72 
73 /* ======================================================================
74 |
75 | 002. contract Owned 
76 | 
77 | ====================================================================== */
78 
79 contract Owned {
80 
81     /* ------------------------------------------------------------------------
82     | 002.01 - Current owner, and proposed new owner
83     | -----------------------------------------------------------------------*/
84     address public owner;
85     address public newOwner;
86 
87     // ------------------------------------------------------------------------
88     // 002.02 - Constructor - assign creator as the owner
89     // -----------------------------------------------------------------------*/
90     constructor () public {
91         owner = msg.sender;
92     }
93 
94     /* ------------------------------------------------------------------------
95     | 002.03 - Modifier to mark that a function can only be executed by the owner
96     | -----------------------------------------------------------------------*/
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101 
102 
103     /* ------------------------------------------------------------------------
104     | 002.04 - Owner can initiate transfer of contract to a new owner
105     | -----------------------------------------------------------------------*/
106     function transferOwnership(address _newOwner) public onlyOwner {
107         newOwner = _newOwner;
108     }
109 
110  
111     /* ------------------------------------------------------------------------
112     | 002.05 - New owner has to accept transfer of contract
113     | -----------------------------------------------------------------------*/
114     function acceptOwnership() public {
115         require(msg.sender == newOwner);
116         emit OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119     event OwnershipTransferred(address indexed _from, address indexed _to);
120 }
121 
122 /* ===================================================================================
123 |
124 | 003. contract Pausable
125 |      Abstract contract that allows children to implement an emergency stop mechanism
126 | 
127 | ==================================================================================== */
128 
129 contract Pausable is Owned {
130   event Pause();
131   event Unpause();
132 
133   bool public paused = false;
134     /* ------------------------------------------------------------------------
135     | 003.01 - modifier to allow actions only when the contract IS paused
136     | -----------------------------------------------------------------------*/
137    modifier whenNotPaused() {
138     require(!paused);
139     _;
140   }
141    
142    /* ------------------------------------------------------------------------
143     | 003.02 - modifier to allow actions only when the contract IS NOT paused
144     | -----------------------------------------------------------------------*/
145   modifier whenPaused {
146     require(paused);
147     _;
148   }
149    
150    /* ------------------------------------------------------------------------
151     | 003.01 - called by the owner to pause, triggers stopped state
152     | -----------------------------------------------------------------------*/
153   function pause() public onlyOwner whenNotPaused returns (bool) {
154     paused = true;
155     emit Pause();
156     return true;
157   }
158    
159    /* ------------------------------------------------------------------------
160     | 003.01 - called by the owner to unpause, returns to normal state
161     | -----------------------------------------------------------------------*/
162    function unpause() public onlyOwner whenPaused returns (bool) {
163     paused = false;
164     emit Unpause();
165     return true;
166   }
167 }
168 
169 /* ===================================================================================
170 |
171 | 004. contract Transferable
172 |      Abstract contract that allows wallets the transfer mechanism
173 | 
174 | ==================================================================================== */
175 
176 contract Transferable is Owned {
177   event Transfer();
178   event Untransfer();
179 
180   bool public flg_transfer = true;
181     /* ------------------------------------------------------------------------
182     | 004.01 - modifier to allow actions only when the contract IS transfer
183     | -----------------------------------------------------------------------*/
184    modifier whenNotTransfer() {
185     require(!flg_transfer);
186     _;
187   }
188    
189    /* ------------------------------------------------------------------------
190     | 004.02 - modifier to allow actions only when the contract IS NOT transfer
191     | -----------------------------------------------------------------------*/
192   modifier whenTransfer {
193     require(flg_transfer);
194     _;
195   }
196    
197    /* ------------------------------------------------------------------------
198     | 004.01 - called by the owner to transfer, triggers stopped state
199     | -----------------------------------------------------------------------*/
200   function transfer() public onlyOwner whenNotTransfer returns (bool) {
201     flg_transfer = true;
202     emit Transfer();
203     return true;
204   }
205    
206    /* ------------------------------------------------------------------------
207     | 004.01 - called by the owner to untransfer, returns to normal state
208     | -----------------------------------------------------------------------*/
209    function untransfer() public onlyOwner whenTransfer returns (bool) {
210     flg_transfer = false;
211     emit Untransfer();
212     return true;
213   }
214 }
215 
216 
217 
218 /* ----------------------------------------------------------------------------
219 | 005. libraty Safe maths - OpenZeppelin
220 | --------------------------------------------------------------------------- */
221 library SafeMath {
222 
223     /* ------------------------------------------------------------------------
224     // 005.01 - safeAdd a number to another number, checking for overflows
225     // -----------------------------------------------------------------------*/
226     function safeAdd(uint a, uint b) internal pure returns (uint) {
227         uint c = a + b;
228         assert(c >= a && c >= b);
229         return c;
230     }
231 
232     /* ------------------------------------------------------------------------
233     // 005.02 - safeSubtract a number from another number, checking for underflows
234     // -----------------------------------------------------------------------*/
235     function safeSub(uint a, uint b) internal pure returns (uint) {
236         assert(b <= a);
237         return a - b;
238     }
239     /* ------------------------------------------------------------------------
240     // 005.03 - safeMuiltplier a number to another number, checking for underflows
241     // -----------------------------------------------------------------------*/
242     function safeMul(uint a, uint b) internal pure returns (uint256) {
243         uint c = a * b;
244         assert(a == 0 || c / a == b);
245         return c;
246     }
247 
248     /* ------------------------------------------------------------------------
249     // 005.04 - safeDivision 
250     // -----------------------------------------------------------------------*/
251     function safeDiv(uint a, uint b) internal pure returns (uint256) {
252         uint c = a / b;
253         return c;
254     }
255     /* ------------------------------------------------------------------------
256     // 005.05 - Max64
257     // -----------------------------------------------------------------------*/
258     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
259         return a >= b ? a : b;
260     }
261     /* ------------------------------------------------------------------------
262     // 005.06 - Min64
263     // -----------------------------------------------------------------------*/
264     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
265         return a < b ? a : b;
266     }
267     /* ------------------------------------------------------------------------
268     // 005.07 - max256
269     // -----------------------------------------------------------------------*/
270     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a >= b ? a : b;
272     }
273     /* ------------------------------------------------------------------------
274     // 005.08 - min256
275     // -----------------------------------------------------------------------*/
276     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a < b ? a : b;
278     }
279 }
280 /* ----------------------------------------------------------------------------
281 | 006. contract Sheltercoin Token Configuration - pass through parameters
282 | ---------------------------------------------------------------------------- */
283 
284 contract SheltercoinTokCfg {
285 
286     /* ------------------------------------------------------------------------
287     | 006.01 - Token symbol(), name() and decimals()
288     |------------------------------------------------------------------------ */
289     string public constant SYMBOL = "SHLT";
290     string public constant NAME = "SHLT Sheltercoin.io";
291     uint8 public constant DECIMALS = 8;
292     bool public flg001 = false;
293     
294 
295 
296 
297     /* -----------------------------------------------------------------------
298     | 006.02 - Decimal factor for multiplications 
299     | ------------------------------------------------------------------------*/
300     uint public constant TOKENS_SOFT_CAP = 1 * DECIMALSFACTOR;
301     uint public constant TOKENS_HARD_CAP = 1000000000 * DECIMALSFACTOR; /* billion */
302     uint public constant TOKENS_TOTAL = 1000000000 * DECIMALSFACTOR;
303     uint public tokensSold = 0;
304 
305 
306     /* ------------------------------------------------------------------------
307     | 006.03 - Lot 1 Crowdsale start date and end date
308     | Do not use the `now` function here
309     | Good caluclator for sanity check for epoch - http://www.unixtimestamp.com/
310     | Start - Sunday 30-Jun-19 12:00:00 UTC 
311     | End - Tuesday 30-Jun-20  12:00:00 UTC 
312     | ----------------------------------------------------------------------- */
313     uint public constant DECIMALSFACTOR = 10**uint(DECIMALS);
314 
315     /* ------------------------------------------------------------------------
316     | 006.04 - Lot 1 Crowdsale timings Soft Cap and Hard Cap, and Total tokens
317     | -------------------------------------------------------------------------- */
318     uint public START_DATE = 1582545600;  // 24-Feb-20 12:00:00 GMT
319     uint public END_DATE = 1614165071;    // 24-Feb-21 11:11:11 GMT
320 
321     /* ------------------------------------------------------------------------
322     | 006.05 - Individual transaction contribution min and max amounts
323     | Set to 0 to switch off, or `x ether`
324     | ----------------------------------------------------------------------*/
325     uint public CONTRIBUTIONS_MIN = 0;
326     uint public CONTRIBUTIONS_MAX = 1000000 ether;
327 }
328 
329 
330 
331 /* ----------------------------------------------------------------------------
332 | 007. - contract ERC20 Token, with the safeAddition of Symbol, name and Decimal
333 | --------------------------------------------------------------------------*/
334 contract ERC20Token is ERC20Interface, Owned, Pausable, Transferable {
335     using SafeMath for uint;
336 
337     /* ------------------------------------------------------------------------
338     | 007.01 - Symbol(), Name() and Decimals()
339     | ----------------------------------------------------------------------*/
340     string public symbol;
341     string public name;
342     uint8 public decimals;
343 
344     /* ------------------------------------------------------------------------
345     | 007.02 - Balances for each account
346     | ----------------------------------------------------------------------*/
347     mapping(address => uint) balances;
348 
349     /*------------------------------------------------------------------------
350     | 007.03 - Owner of account approves the transfer of an amount to another account
351     | ----------------------------------------------------------------------*/
352     mapping(address => mapping (address => uint)) allowed;
353 
354 
355     /* ------------------------------------------------------------------------
356     | 007.04 - Constructor
357     | ----------------------------------------------------------------------*/
358     constructor (
359         string _symbol, 
360         string _name, 
361         uint8 _decimals, 
362         uint _tokensSold
363     ) Owned() public {
364         symbol = _symbol;
365         name = _name;
366         decimals = _decimals;
367         tokensSold = _tokensSold;
368         balances[owner] = _tokensSold;
369     }
370 
371 
372     /* ------------------------------------------------------------------------
373     | 007.05 -Get the account balance of another account with address _owner
374     | ----------------------------------------------------------------------*/
375     function balanceOf(address _owner) public constant returns (uint balance) {
376         return balances[_owner];
377     }
378 
379 
380     /* ------------------------------------------------------------------------
381     | 007.06 - Transfer the balance from owner's account to another account
382     | ----------------------------------------------------------------------*/
383     function transfer(address _to, uint _amount) public returns (bool success) {
384         if (balances[msg.sender] >= _amount             // User has balance
385             && _amount > 0                              // Non-zero transfer
386             && balances[_to] + _amount > balances[_to]  // Overflow check
387         ) {
388             balances[msg.sender] = balances[msg.sender].safeSub(_amount);
389             balances[_to] = balances[_to].safeAdd(_amount);
390             emit Transfer(msg.sender, _to, _amount);
391             return true;
392         } else {
393             return false;
394         }
395     }
396 
397 
398     /* ------------------------------------------------------------------------
399     | 007.07 - Allow _spender to withdraw from your Account, multiple times, up to the
400     |          _value amount. If this function is called again it overwrites the
401     |          current allowance with _value.
402     | ----------------------------------------------------------------------*/
403     function approve(
404         address _spender,
405         uint _amount
406     ) public returns (bool success) {
407         allowed[msg.sender][_spender] = _amount;
408         emit Approval(msg.sender, _spender, _amount);
409         return true;
410     }
411 
412 
413     /* ------------------------------------------------------------------------
414     | 007.08 - Spender of tokens transfer an amount of tokens from the token owner's
415     |          balance to another account. The owner of the tokens must already
416     |          have approved this transfer
417     | ----------------------------------------------------------------------*/
418     function transferFrom(
419         address _from,
420         address _to,
421         uint _amount
422     ) public returns (bool success) {
423         if (balances[_from] >= _amount                  // _from a/c has a balance
424             && allowed[_from][msg.sender] >= _amount    // Transfer allowed
425             && _amount > 0                              // Non-zero transfer
426             && balances[_to] + _amount > balances[_to]  // Overflow check
427         ) {
428             balances[_from] = balances[_from].safeSub(_amount);
429             allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_amount);
430             balances[_to] = balances[_to].safeAdd(_amount);
431             emit Transfer(_from, _to, _amount);
432             return true;
433         } else {
434             return false;
435         }
436     }
437 
438 
439     /* ------------------------------------------------------------------------
440     | 007.09 - Returns the amount of tokens approved by the owner that can be
441     |          transferred to the spender's account
442     | ----------------------------------------------------------------------*/
443     function allowance(
444         address _owner, 
445         address _spender
446     ) public constant returns (uint remaining) 
447     {
448         return allowed[_owner][_spender];
449     }
450 }
451 
452 
453 /* ----------------------------------------------------------------------------
454 | 008. contract SheltercoinToken - Sheltercoin ICO Crowdsale
455 | --------------------------------------------------------------------------*/
456 contract SHLTSheltercoinToken is ERC20Token, SheltercoinTokCfg {
457 
458     /* ------------------------------------------------------------------------
459     | 007.01 - Has the crowdsale been finalised?
460     | ----------------------------------------------------------------------*/
461     bool public finalised = false;
462     
463     /* ------------------------------------------------------------------------
464     | 007.02 - Number of Tokens per 1 ETH
465     |          This can be adjusted as the ETH/USD rate changes
466     |          
467     | 007.03 SO 
468                Price per ETH $105.63 Feb 7 2019 coinmarketcap
469                1 ETH = 2000 SHLT
470                1 SHLT = 0.0005 ETH
471                USD 5c 
472                1 billion SHLT = total hard cap 
473     |
474     |          tokensPerEther  = 2000
475     |          tokensPerKEther = 2000000
476     |          
477 
478     /* ----------------------------------------------------------------------*/
479     uint public tokensPerEther = 2000;    
480     uint public tokensPerKEther = 2000000;  
481     uint public etherSold = 0;
482     uint public weiSold = 0;
483     uint public tokens = 0;
484     uint public dspTokens = 0;
485     uint public dspTokensSold = 0;
486     uint public dspEther = 0;
487     uint public dspEtherSold = 0;
488     uint public dspWeiSold = 0;
489     uint public BONUS_VALUE = 0;
490     uint public bonusTokens = 0;
491 
492 // Emergency Disaster Relief 
493     string public SCE_Shelter_ID;
494     string public SCE_Shelter_Desc;
495   //  string public SCE_Emergency_ID;
496     string public SCE_Emergency_Type;
497 // string public SCE_UN_Body;
498     string public SCE_UN_Programme_ID;
499     string public SCE_Country;
500     string public SCE_Region; 
501  //   string public SCE_Area;
502     uint public SCE_START_DATE;
503     uint public SCE_END_DATE; 
504     
505     /* ------------------------------------------------------------------------
506     | 007.04 - Wallet receiving the raised funds 
507     |        - The ICO Contract address 
508     | ----------------------------------------------------------------------*/
509     address public wallet;
510     address public tokenContractAdr;
511     /* ------------------------------------------------------------------------
512     | 007.05 - Crowdsale participant's accounts need to be client verified client before
513     |          the participant can move their tokens
514     | ----------------------------------------------------------------------*/
515     mapping(address => bool) public Whitelisted;
516     mapping(address => bool) public Blacklisted;
517 
518     modifier isWhitelisted() {
519         require(Whitelisted[msg.sender] == true);
520         _;
521       }
522     
523     modifier isBlacklisted() {
524         require(Blacklisted[msg.sender] == true);
525         _;
526 
527 
528       }
529    
530     /* ------------------------------------------------------------------------
531     | 007.06 - Constructor
532     | ----------------------------------------------------------------------*/
533     constructor (address _wallet) 
534        public ERC20Token(SYMBOL, NAME, DECIMALS, 0)
535     {
536         wallet = _wallet;
537         flg001 = true ;   
538 
539     }
540 
541     /* ------------------------------------------------------------------------
542     | 007.07 - Sheltercoin Owner can change the Crowdsale wallet address
543     |          Can be set at any time before or during the Crowdsale
544     |          Not relevant after the crowdsale is finalised as no more contributions
545     |          are accepted
546     | ----------------------------------------------------------------------*/
547     function setWallet(address _wallet) public onlyOwner {
548         wallet = _wallet;
549         emit WalletUpdated(wallet);
550     }
551     event WalletUpdated(address newWallet);
552 
553 
554     /* ------------------------------------------------------------------------
555     | 007.08 - Sheltercoin Owner can set number of tokens per 1 x  ETH
556     |          Can only be set before the start of the Crowdsale
557     | ----------------------------------------------------------------------*/
558     function settokensPerKEther(uint _tokensPerKEther) public onlyOwner {
559         require(now < START_DATE);
560         require(_tokensPerKEther > 0);
561         tokensPerKEther = _tokensPerKEther;
562         emit tokensPerKEtherUpdated(tokensPerKEther);
563     }
564     event tokensPerKEtherUpdated(uint _tokPerKEther);
565 
566 
567     /* ------------------------------------------------------------------------
568     | 007.09 - Accept Ethers to buy Tokens during the Crowdsale
569     | ----------------------------------------------------------------------*/
570     function () public payable {
571         ICOContribution(msg.sender);
572     }
573 
574 
575     /* ------------------------------------------------------------------------
576     | 007.10 - Accept Ethers from one account for tokens to be created for another
577     |          account. Can be used by Exchanges to purchase Tokens on behalf of 
578     |          it's Customers
579     | ----------------------------------------------------------------------*/
580     function ICOContribution(address participant) public payable {
581         // No contributions after the crowdsale is finalised
582         require(!finalised);
583         // Not paused
584         require(!paused);
585         // No contributions before the start of the crowdsale
586         require(now >= START_DATE);
587         // No contributions after the end of the crowdsale
588         require(now <= END_DATE);
589         // No contributions below the minimum (can be 0 ETH)
590         require(msg.value >= CONTRIBUTIONS_MIN);
591         // No contributions above a maximum (if maximum is set to non-0)
592         require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
593 
594         // client verification required before participant can transfer the tokens
595         require(Whitelisted[msg.sender]);
596         require(!Blacklisted[msg.sender]);
597 
598         // Transfer the contributed ethers to the Crowdsale wallet
599         require(wallet.send(msg.value)); 
600 
601         // Calculate number of Tokens for contributed ETH
602         // `18` is the ETH decimals
603         // `- decimals` is the token decimals
604         // `+ 3` for the tokens per 1,000 ETH factor
605         tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
606 
607         /* create variable bonusTokens. This is the purchase amount adjusted by
608            any bonus. The SetBonus function is onlyOwner
609            Bonus is expressed in %, eg 50 = 50%
610            */
611         bonusTokens = msg.value.safeMul(BONUS_VALUE + 100);
612 
613         bonusTokens = bonusTokens.safeDiv(100);
614  
615         tokens = bonusTokens;
616 
617         dspTokens = tokens * tokensPerKEther / 10**uint(18 - decimals + 6);
618         dspEther = tokens / 10**uint(18);  
619         // Check if the Hard Cap will be exceeded
620        require(totalSupply + tokens <= TOKENS_HARD_CAP);
621        require(tokensSold + tokens <= TOKENS_HARD_CAP);
622         // Crowdsale Address
623          tokenContractAdr = this;
624         // safeAdd tokens purchased to Account's balance and TokensSold
625         balances[participant] = balances[participant].safeAdd(tokens);
626         tokensSold = tokensSold.safeAdd(tokens);
627         etherSold = etherSold.safeAdd(dspEther);
628         weiSold = weiSold + tokenContractAdr.balance;
629         //weiSold = weiSold + this.balance;
630         // Event Display Totals 
631         dspTokensSold = dspTokensSold.safeAdd(dspTokens);
632         dspEtherSold = dspEtherSold.safeAdd(dspEther);
633         dspWeiSold = dspWeiSold + tokenContractAdr.balance;
634        //dspWeiSold = dspWeiSold + this.balance;
635 
636   
637          // Transfer Tokens &  Log the tokens purchased 
638         emit Transfer(tokenContractAdr, participant, tokens);
639         emit TokensBought(participant,bonusTokens, dspWeiSold, dspEther, dspEtherSold, dspTokens, dspTokensSold, tokensPerEther);
640 
641         
642      
643     }
644     event TokensBought(address indexed buyer, uint newWei, 
645         uint newWeiBalance, uint newEther, uint EtherTotal, uint _toks, uint newTokenTotal, 
646         uint _toksPerEther);
647 
648 
649     /* ------------------------------------------------------------------------
650     |  007.11 - SheltercoinOwner to finalise the Crowdsale 
651     |           
652     | ----------------------------------------------------------------------*/
653     function finalise() public onlyOwner {
654         // Can only finalise if raised > soft cap or after the end date
655         require(tokensSold >= TOKENS_SOFT_CAP || now > END_DATE);
656        // Can only finalise once
657         require(!finalised);
658           // Crowdsale Address
659          tokenContractAdr = this;    
660         // Write out the total
661         emit TokensBought(tokenContractAdr, 0, dspWeiSold, dspEther, dspEtherSold, dspTokens, dspTokensSold, tokensPerEther);
662         // Can only finalise once
663         finalised = true;
664     }
665 
666 
667     /* ------------------------------------------------------------------------
668     | 007.12 - Sheltercoin Owner to safeAdd Pre-sales funding token balance before the Crowdsale
669     |          commences
670     | ----------------------------------------------------------------------*/
671     function ICOAddPrecommitment(address participant, uint balance) public onlyOwner {
672          // Not paused
673         require(!paused);
674         // No contributions after the start of the crowdsale
675         // Allowing off chain contributions during the Crowdsale
676         // Allowing contributions after the end of the crowdsale
677         // Off Chain SHLT Balance to Transfer 
678         require(balance > 0);
679         //Address field is completed
680         require(address(participant) != 0x0);
681         // safeAdd tokens purchased to Account's balance and TokensSold
682         tokenContractAdr = this;
683         balances[participant] = balances[participant].safeAdd(balance);
684         tokensSold = tokensSold.safeAdd(balance);
685         emit Transfer(tokenContractAdr, participant, balance);
686     }
687     event ICOcommitmentAdded(address indexed participant, uint balance, uint tokensSold );
688 
689     /* ------------------------------------------------------------------------
690     | 007.12a - Sheltercoin Owner to Change ICO Start Date or ICO End Date
691     |          commences
692     | ----------------------------------------------------------------------*/
693     function ICOdt(uint START_DATE_NEW, uint END_DATE_NEW ) public onlyOwner {
694         // No contributions after the crowdsale is finalised
695         require(!finalised);
696         // Not paused
697         require(!paused);
698         //  Allowed to change any time 
699         // No 0 
700         require(START_DATE_NEW > 0);
701         require(END_DATE_NEW > 0);
702         tokenContractAdr = this;
703         START_DATE = START_DATE_NEW;
704         END_DATE = END_DATE_NEW;
705         emit ICOdate(START_DATE, END_DATE);
706      }
707     event ICOdate(uint ST_DT, uint END_DT);
708 
709     /* ----------------------------------------------------------------------
710     | 007.13 - Transfer the Balance from Owner's account to another account, with client
711     |          verification check for the crowdsale participant's first transfer
712     | ----------------------------------------------------------------------*/
713     function transfer(address _to, uint _amount) public returns (bool success) {
714         // Cannot transfer before crowdsale ends
715         // require(finalised);
716         //  require(flg002transfer);
717         // Cannot transfer if Client verification is required
718         //require(!clientRequired[msg.sender]);
719         // Standard transfer
720         return super.transfer(_to, _amount);
721     }
722 
723 
724     /* ------------------------------------------------------------------------
725     | 007.14 - Spender of tokens transfer an amount of tokens from the token Owner's
726     |          balance to another account, with Client verification check for the
727     |          Crowdsale participant's first transfer
728     | ----------------------------------------------------------------------*/
729     function transferFrom(address _from, address _to, uint _amount) 
730         public returns (bool success)
731     {
732         // Cannot transfer before crowdsale ends
733         // require(flg002transfer);
734         // Cannot transfer if Client verification is required
735         //require(!clientRequired[_from]);
736         // Standard transferFrom
737         return super.transferFrom(_from, _to, _amount);
738     }
739 
740 
741  /* ------------------------------------------------------------------------
742     | 007.16 - Any account can burn _from's tokens as long as the _from account has 
743     |          approved the _amount to be burnt using
744     |          approve(0x0, _amount)
745     | ----------------------------------------------------------------------*/
746     function mintFrom(
747         address _from,
748         uint _amount
749     ) public returns (bool success) {
750         if (balances[_from] >= _amount                  // From a/c has balance
751             && allowed[_from][0x0] >= _amount           // Transfer approved
752             && _amount > 0                              // Non-zero transfer
753             && balances[0x0] + _amount > balances[0x0]  // Overflow check
754         ) {
755             balances[_from] = balances[_from].safeSub(_amount);
756             allowed[_from][0x0] = allowed[_from][0x0].safeSub(_amount);
757             balances[0x0] = balances[0x0].safeAdd(_amount);
758             tokensSold = tokensSold.safeSub(_amount);
759             emit Transfer(_from, 0x0, _amount);
760             return true;
761         } else {
762             return false;
763         }
764     
765  
766      }  
767     
768 
769 /* ------------------------------------------------------------------------
770     | 007.17 - Set bonus percentage multiplier. 50% = * 1.5
771     | ----------------------------------------------------------------------*/
772     function setBonus(uint _bonus) public onlyOwner
773 
774         returns (bool success) {
775         require (!finalised);
776         if (_bonus >= 0)               // From a/c is owner
777           {
778             BONUS_VALUE = _bonus;
779             return true;
780         } else {
781             return false;
782         }
783           emit BonusSet(_bonus);
784         }
785     event BonusSet(uint _bonus);
786 
787     /* ------------------------------------------------------------------------
788     |  007.15 - SheltercoinOwner to Client verify the participant's account
789     |  ----------------------------------------------------------------------*/
790    
791    
792     function AddToWhitelist(address participant) public onlyOwner {
793         Whitelisted[participant] = true;
794         emit AddedToWhitelist(participant);
795     }
796     event AddedToWhitelist(address indexed participant);
797 
798     function IsWhitelisted(address participant) 
799         public view returns (bool) {
800       return bool(Whitelisted[participant]);
801     }
802     
803     function RemoveFromWhitelist(address participant) public onlyOwner {
804         Whitelisted[participant] = false;
805         emit RemovedFromWhitelist(participant);
806     }
807     event RemovedFromWhitelist(address indexed participant);
808 
809     function AddToBlacklist(address participant) public onlyOwner {
810         Blacklisted[participant] = true;
811         emit AddedToBlacklist(participant);
812     }
813     event AddedToBlacklist(address indexed participant);
814 
815     function IsBlacklisted(address participant) 
816         public view returns (bool) {
817       return bool(Blacklisted[participant]);
818     }
819     function RemoveFromBlackList(address participant) public onlyOwner {
820         Blacklisted[participant] = false;
821         emit RemovedFromBlacklist(participant);
822     }
823     event RemovedFromBlacklist(address indexed participant);
824 
825     function SCEmergency(string _Shelter_ID, string _Shelter_Description, string _Emergency_Type, string _UN_Programme_ID, string _Country, string _Region, uint START_DATE_SCE, uint END_DATE_SCE ) public onlyOwner {
826  
827         // Disaster Occur's
828         finalised = true;
829         require(finalised);
830         // Not paused
831         //require(!paused);
832         // No 0 
833          require(START_DATE_SCE > 0);
834         // Write to the blockchain 
835         tokenContractAdr = this;
836         SCE_Shelter_ID = _Shelter_ID;
837         SCE_Shelter_Desc = _Shelter_Description;
838         SCE_Emergency_Type = _Emergency_Type;
839         SCE_UN_Programme_ID = _UN_Programme_ID;
840         SCE_Country = _Country;
841         SCE_Region = _Region; 
842         SCE_START_DATE = START_DATE_SCE;
843         SCE_END_DATE = END_DATE_SCE; 
844         emit SC_Emergency(SCE_Shelter_ID, SCE_Shelter_Desc, SCE_Emergency_Type, SCE_UN_Programme_ID, SCE_Country, SCE_Region, SCE_START_DATE, SCE_END_DATE );
845        
846     }
847     event SC_Emergency(string _str_Shelter_ID, string _str_Shelter_Descrip, string _str_Emergency_Type, string _str_UN_Prog_ID, string _str_Country, string _str_Region, uint SC_ST_DT, uint SC_END_DT);
848     
849 
850 }