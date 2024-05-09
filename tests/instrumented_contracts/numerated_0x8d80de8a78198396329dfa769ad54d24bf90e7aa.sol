1 pragma solidity ^0.4.18;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6   function mul(uint a, uint b) internal pure returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal pure returns (uint) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal pure returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal pure returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a < b ? a : b;
44   }
45 }
46 
47 // ERC20 token interface is implemented only partially.
48 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
49 
50 contract NamiCrowdSale {
51     using SafeMath for uint256;
52 
53     /// NAC Broker Presale Token
54     /// @dev Constructor
55     function NamiCrowdSale(address _escrow, address _namiMultiSigWallet, address _namiPresale) public {
56         require(_namiMultiSigWallet != 0x0);
57         escrow = _escrow;
58         namiMultiSigWallet = _namiMultiSigWallet;
59         namiPresale = _namiPresale;
60     }
61 
62 
63     /*/
64      *  Constants
65     /*/
66 
67     string public name = "Nami ICO";
68     string public  symbol = "NAC";
69     uint   public decimals = 18;
70 
71     bool public TRANSFERABLE = false; // default not transferable
72 
73     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
74     
75     uint public binary = 0;
76 
77     /*/
78      *  Token state
79     /*/
80 
81     enum Phase {
82         Created,
83         Running,
84         Paused,
85         Migrating,
86         Migrated
87     }
88 
89     Phase public currentPhase = Phase.Created;
90     uint public totalSupply = 0; // amount of tokens already sold
91 
92     // escrow has exclusive priveleges to call administrative
93     // functions on this contract.
94     address public escrow;
95 
96     // Gathered funds can be withdrawn only to namimultisigwallet's address.
97     address public namiMultiSigWallet;
98 
99     // nami presale contract
100     address public namiPresale;
101 
102     // Crowdsale manager has exclusive priveleges to burn presale tokens.
103     address public crowdsaleManager;
104     
105     // binary option address
106     address public binaryAddress;
107     
108     // This creates an array with all balances
109     mapping (address => uint256) public balanceOf;
110     mapping (address => mapping (address => uint256)) public allowance;
111 
112     modifier onlyCrowdsaleManager() {
113         require(msg.sender == crowdsaleManager); 
114         _; 
115     }
116 
117     modifier onlyEscrow() {
118         require(msg.sender == escrow);
119         _;
120     }
121     
122     modifier onlyTranferable() {
123         require(TRANSFERABLE);
124         _;
125     }
126     
127     modifier onlyNamiMultisig() {
128         require(msg.sender == namiMultiSigWallet);
129         _;
130     }
131     
132     /*/
133      *  Events
134     /*/
135 
136     event LogBuy(address indexed owner, uint value);
137     event LogBurn(address indexed owner, uint value);
138     event LogPhaseSwitch(Phase newPhase);
139     // Log migrate token
140     event LogMigrate(address _from, address _to, uint256 amount);
141     // This generates a public event on the blockchain that will notify clients
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /*/
145      *  Public functions
146     /*/
147 
148     /**
149      * Internal transfer, only can be called by this contract
150      */
151     function _transfer(address _from, address _to, uint _value) internal {
152         // Prevent transfer to 0x0 address. Use burn() instead
153         require(_to != 0x0);
154         // Check if the sender has enough
155         require(balanceOf[_from] >= _value);
156         // Check for overflows
157         require(balanceOf[_to] + _value > balanceOf[_to]);
158         // Save this for an assertion in the future
159         uint previousBalances = balanceOf[_from] + balanceOf[_to];
160         // Subtract from the sender
161         balanceOf[_from] -= _value;
162         // Add the same to the recipient
163         balanceOf[_to] += _value;
164         Transfer(_from, _to, _value);
165         // Asserts are used to use static analysis to find bugs in your code. They should never fail
166         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
167     }
168 
169     // Transfer the balance from owner's account to another account
170     // only escrow can send token (to send token private sale)
171     function transferForTeam(address _to, uint256 _value) public
172         onlyEscrow
173     {
174         _transfer(msg.sender, _to, _value);
175     }
176     
177     /**
178      * Transfer tokens
179      *
180      * Send `_value` tokens to `_to` from your account
181      *
182      * @param _to The address of the recipient
183      * @param _value the amount to send
184      */
185     function transfer(address _to, uint256 _value) public
186         onlyTranferable
187     {
188         _transfer(msg.sender, _to, _value);
189     }
190     
191        /**
192      * Transfer tokens from other address
193      *
194      * Send `_value` tokens to `_to` in behalf of `_from`
195      *
196      * @param _from The address of the sender
197      * @param _to The address of the recipient
198      * @param _value the amount to send
199      */
200     function transferFrom(address _from, address _to, uint256 _value) 
201         public
202         onlyTranferable
203         returns (bool success)
204     {
205         require(_value <= allowance[_from][msg.sender]);     // Check allowance
206         allowance[_from][msg.sender] -= _value;
207         _transfer(_from, _to, _value);
208         return true;
209     }
210 
211     /**
212      * Set allowance for other address
213      *
214      * Allows `_spender` to spend no more than `_value` tokens in your behalf
215      *
216      * @param _spender The address authorized to spend
217      * @param _value the max amount they can spend
218      */
219     function approve(address _spender, uint256 _value) public
220         onlyTranferable
221         returns (bool success) 
222     {
223         allowance[msg.sender][_spender] = _value;
224         return true;
225     }
226 
227     /**
228      * Set allowance for other address and notify
229      *
230      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
231      *
232      * @param _spender The address authorized to spend
233      * @param _value the max amount they can spend
234      * @param _extraData some extra information to send to the approved contract
235      */
236     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
237         public
238         onlyTranferable
239         returns (bool success) 
240     {
241         tokenRecipient spender = tokenRecipient(_spender);
242         if (approve(_spender, _value)) {
243             spender.receiveApproval(msg.sender, _value, this, _extraData);
244             return true;
245         }
246     }
247 
248     // allows transfer token
249     function changeTransferable () public
250         onlyEscrow
251     {
252         TRANSFERABLE = !TRANSFERABLE;
253     }
254     
255     // change escrow
256     function changeEscrow(address _escrow) public
257         onlyNamiMultisig
258     {
259         require(_escrow != 0x0);
260         escrow = _escrow;
261     }
262     
263     // change binary value
264     function changeBinary(uint _binary)
265         public
266         onlyEscrow
267     {
268         binary = _binary;
269     }
270     
271     // change binary address
272     function changeBinaryAddress(address _binaryAddress)
273         public
274         onlyEscrow
275     {
276         require(_binaryAddress != 0x0);
277         binaryAddress = _binaryAddress;
278     }
279     
280     /*
281     * price in ICO:
282     * first week: 1 ETH = 2400 NAC
283     * second week: 1 ETH = 23000 NAC
284     * 3rd week: 1 ETH = 2200 NAC
285     * 4th week: 1 ETH = 2100 NAC
286     * 5th week: 1 ETH = 2000 NAC
287     * 6th week: 1 ETH = 1900 NAC
288     * 7th week: 1 ETH = 1800 NAC
289     * 8th week: 1 ETH = 1700 nac
290     * time: 
291     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
292     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
293     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
294     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
295     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
296     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
297     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
298     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
299     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
300     */
301     function getPrice() public view returns (uint price) {
302         if (now < 1517443200) {
303             // presale
304             return 3450;
305         } else if (1517443200 < now && now <= 1518048000) {
306             // 1st week
307             return 2400;
308         } else if (1518048000 < now && now <= 1518652800) {
309             // 2nd week
310             return 2300;
311         } else if (1518652800 < now && now <= 1519257600) {
312             // 3rd week
313             return 2200;
314         } else if (1519257600 < now && now <= 1519862400) {
315             // 4th week
316             return 2100;
317         } else if (1519862400 < now && now <= 1520467200) {
318             // 5th week
319             return 2000;
320         } else if (1520467200 < now && now <= 1521072000) {
321             // 6th week
322             return 1900;
323         } else if (1521072000 < now && now <= 1521676800) {
324             // 7th week
325             return 1800;
326         } else if (1521676800 < now && now <= 1522281600) {
327             // 8th week
328             return 1700;
329         } else {
330             return binary;
331         }
332     }
333 
334 
335     function() payable public {
336         buy(msg.sender);
337     }
338     
339     
340     function buy(address _buyer) payable public {
341         // Available only if presale is running.
342         require(currentPhase == Phase.Running);
343         // require ICO time or binary option
344         require(now <= 1522281600 || msg.sender == binaryAddress);
345         require(msg.value != 0);
346         uint newTokens = msg.value * getPrice();
347         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
348         // add new token to buyer
349         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
350         // add new token to totalSupply
351         totalSupply = totalSupply.add(newTokens);
352         LogBuy(_buyer,newTokens);
353         Transfer(this,_buyer,newTokens);
354     }
355     
356 
357     /// @dev Returns number of tokens owned by given address.
358     /// @param _owner Address of token owner.
359     function burnTokens(address _owner) public
360         onlyCrowdsaleManager
361     {
362         // Available only during migration phase
363         require(currentPhase == Phase.Migrating);
364 
365         uint tokens = balanceOf[_owner];
366         require(tokens != 0);
367         balanceOf[_owner] = 0;
368         totalSupply -= tokens;
369         LogBurn(_owner, tokens);
370         Transfer(_owner, crowdsaleManager, tokens);
371 
372         // Automatically switch phase when migration is done.
373         if (totalSupply == 0) {
374             currentPhase = Phase.Migrated;
375             LogPhaseSwitch(Phase.Migrated);
376         }
377     }
378 
379 
380     /*/
381      *  Administrative functions
382     /*/
383     function setPresalePhase(Phase _nextPhase) public
384         onlyEscrow
385     {
386         bool canSwitchPhase
387             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
388             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
389                 // switch to migration phase only if crowdsale manager is set
390             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
391                 && _nextPhase == Phase.Migrating
392                 && crowdsaleManager != 0x0)
393             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
394                 // switch to migrated only if everyting is migrated
395             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
396                 && totalSupply == 0);
397 
398         require(canSwitchPhase);
399         currentPhase = _nextPhase;
400         LogPhaseSwitch(_nextPhase);
401     }
402 
403 
404     function withdrawEther(uint _amount) public
405         onlyEscrow
406     {
407         require(namiMultiSigWallet != 0x0);
408         // Available at any phase.
409         if (this.balance > 0) {
410             namiMultiSigWallet.transfer(_amount);
411         }
412     }
413     
414     function safeWithdraw(address _withdraw, uint _amount) public
415         onlyEscrow
416     {
417         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
418         if (namiWallet.isOwner(_withdraw)) {
419             _withdraw.transfer(_amount);
420         }
421     }
422 
423 
424     function setCrowdsaleManager(address _mgr) public
425         onlyEscrow
426     {
427         // You can't change crowdsale contract when migration is in progress.
428         require(currentPhase != Phase.Migrating);
429         crowdsaleManager = _mgr;
430     }
431 
432     // internal migrate migration tokens
433     function _migrateToken(address _from, address _to)
434         internal
435     {
436         PresaleToken presale = PresaleToken(namiPresale);
437         uint256 newToken = presale.balanceOf(_from);
438         require(newToken > 0);
439         // burn old token
440         presale.burnTokens(_from);
441         // add new token to _to
442         balanceOf[_to] = balanceOf[_to].add(newToken);
443         // add new token to totalSupply
444         totalSupply = totalSupply.add(newToken);
445         LogMigrate(_from, _to, newToken);
446         Transfer(this,_to,newToken);
447     }
448 
449     // migate token function for Nami Team
450     function migrateToken(address _from, address _to) public
451         onlyEscrow
452     {
453         _migrateToken(_from, _to);
454     }
455 
456     // migrate token for investor
457     function migrateForInvestor() public {
458         _migrateToken(msg.sender, msg.sender);
459     }
460 
461     // Nami internal exchange
462     
463     // event for Nami exchange
464     event TransferToBuyer(address indexed _from, address indexed _to, uint _value, address indexed _seller);
465     event TransferToExchange(address indexed _from, address indexed _to, uint _value, uint _price);
466     
467     
468         /**
469      * @dev Transfer the specified amount of tokens to the specified address.
470      *      Invokes the `tokenFallback` function if the recipient is a contract.
471      *      The token transfer fails if the recipient is a contract
472      *      but does not implement the `tokenFallback` function
473      *      or the fallback function to receive funds.
474      *
475      * @param _to    Receiver address.
476      * @param _value Amount of tokens that will be transferred.
477      * @param _price price to sell token.
478      */
479      
480     function transferToExchange(address _to, uint _value, uint _price) public {
481         uint codeLength;
482         
483         assembly {
484             codeLength := extcodesize(_to)
485         }
486         
487         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
488         balanceOf[_to] = balanceOf[_to].add(_value);
489         Transfer(msg.sender,_to,_value);
490         if (codeLength > 0) {
491             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
492             receiver.tokenFallbackExchange(msg.sender, _value, _price);
493             TransferToExchange(msg.sender, _to, _value, _price);
494         }
495     }
496     
497     /**
498      * @dev Transfer the specified amount of tokens to the specified address.
499      *      Invokes the `tokenFallback` function if the recipient is a contract.
500      *      The token transfer fails if the recipient is a contract
501      *      but does not implement the `tokenFallback` function
502      *      or the fallback function to receive funds.
503      *
504      * @param _to    Receiver address.
505      * @param _value Amount of tokens that will be transferred.
506      * @param _buyer address of seller.
507      */
508      
509     function transferToBuyer(address _to, uint _value, address _buyer) public {
510         uint codeLength;
511         
512         assembly {
513             codeLength := extcodesize(_to)
514         }
515         
516         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
517         balanceOf[_to] = balanceOf[_to].add(_value);
518         Transfer(msg.sender,_to,_value);
519         if (codeLength > 0) {
520             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
521             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
522             TransferToBuyer(msg.sender, _to, _value, _buyer);
523         }
524     }
525 //-------------------------------------------------------------------------------------------------------
526 }
527 
528 
529 /*
530 * Binary option smart contract-------------------------------
531 */
532 contract BinaryOption {
533     /*
534      * binary option controled by escrow to buy NAC with good price
535      */
536     // NamiCrowdSale address
537     address public namiCrowdSaleAddr;
538     address public escrow;
539     
540     // namiMultiSigWallet
541     address public namiMultiSigWallet;
542     
543     Session public session;
544     uint public timeInvestInMinute = 30;
545     uint public timeOneSession = 180;
546     uint public sessionId = 1;
547     uint public rate = 190;
548     uint public constant MAX_INVESTOR = 20;
549     /**
550      * Events for binany option system
551      */
552     event SessionOpen(uint timeOpen, uint indexed sessionId);
553     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
554     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
555     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rate);
556 
557     event Deposit(address indexed sender, uint value);
558     /// @dev Fallback function allows to deposit ether.
559     function() public payable {
560         if (msg.value > 0)
561             Deposit(msg.sender, msg.value);
562     }
563     // there is only one session available at one timeOpen
564     // priceOpen is price of ETH in USD
565     // priceClose is price of ETH in USD
566     // process of one Session
567     // 1st: escrow reset session by run resetSession()
568     // 2nd: escrow open session by run openSession() => save timeOpen at this time
569     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
570     // 4th: escrow close invest and insert price open for this Session
571     // 5th: escrow close session and send NAC for investor
572     struct Session {
573         uint priceOpen;
574         uint priceClose;
575         uint timeOpen;
576         bool isReset;
577         bool isOpen;
578         bool investOpen;
579         uint investorCount;
580         mapping(uint => address) investor;
581         mapping(uint => bool) win;
582         mapping(uint => uint) amountInvest;
583         mapping(address=> uint) investedSession;
584     }
585     
586     function BinaryOption(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
587         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
588         namiCrowdSaleAddr = _namiCrowdSale;
589         escrow = _escrow;
590         namiMultiSigWallet = _namiMultiSigWallet;
591     }
592     
593     
594     modifier onlyEscrow() {
595         require(msg.sender==escrow);
596         _;
597     }
598     
599         
600     modifier onlyNamiMultisig() {
601         require(msg.sender == namiMultiSigWallet);
602         _;
603     }
604     
605     // change escrow
606     function changeEscrow(address _escrow) public
607         onlyNamiMultisig
608     {
609         require(_escrow != 0x0);
610         escrow = _escrow;
611     }
612     
613     /// @dev Change time for investor can invest in one session, can only change at time not in session
614     /// @param _timeInvest time invest in minutes
615     function changeTimeInvest(uint _timeInvest)
616         public
617         onlyEscrow
618     {
619         require(!session.isOpen && _timeInvest < timeOneSession);
620         timeInvestInMinute = _timeInvest;
621     }
622     
623     // 100 < _rate < 200
624     // price of NAC for investor win = _rate/100
625     // price of NAC for investor loss = 2 - _rate/100
626     function changeRate(uint _rate)
627         public
628         onlyEscrow
629     {
630         require(100 < _rate && _rate < 200 && !session.isOpen);
631         rate = _rate;
632     }
633     
634     function changeTimeOneSession(uint _timeOneSession) 
635         public
636         onlyEscrow
637     {
638         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
639         timeOneSession = _timeOneSession;
640     }
641     
642     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
643     /// @param _amount value ether in wei to withdraw
644     function withdrawEther(uint _amount) public
645         onlyEscrow
646     {
647         require(namiMultiSigWallet != 0x0);
648         // Available at any phase.
649         if (this.balance > 0) {
650             namiMultiSigWallet.transfer(_amount);
651         }
652     }
653     
654     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
655     /// @param _withdraw address to withdraw
656     function safeWithdraw(address _withdraw, uint _amount) public
657         onlyEscrow
658     {
659         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
660         if (namiWallet.isOwner(_withdraw)) {
661             _withdraw.transfer(_amount);
662         }
663     }
664     
665     // @dev Returns list of owners.
666     // @return List of owner addresses.
667     // MAX_INVESTOR = 20
668     function getInvestors()
669         public
670         view
671         returns (address[20])
672     {
673         address[20] memory listInvestor;
674         for (uint i = 0; i < MAX_INVESTOR; i++) {
675             listInvestor[i] = session.investor[i];
676         }
677         return listInvestor;
678     }
679     
680     function getChooses()
681         public
682         view
683         returns (bool[20])
684     {
685         bool[20] memory listChooses;
686         for (uint i = 0; i < MAX_INVESTOR; i++) {
687             listChooses[i] = session.win[i];
688         }
689         return listChooses;
690     }
691     
692     function getAmount()
693         public
694         view
695         returns (uint[20])
696     {
697         uint[20] memory listAmount;
698         for (uint i = 0; i < MAX_INVESTOR; i++) {
699             listAmount[i] = session.amountInvest[i];
700         }
701         return listAmount;
702     }
703     
704     /// @dev reset all data of previous session, must run before open new session
705     // only escrow can call
706     function resetSession()
707         public
708         onlyEscrow
709     {
710         require(!session.isReset && !session.isOpen);
711         session.priceOpen = 0;
712         session.priceClose = 0;
713         session.isReset = true;
714         session.isOpen = false;
715         session.investOpen = false;
716         session.investorCount = 0;
717         for (uint i = 0; i < MAX_INVESTOR; i++) {
718             session.investor[i] = 0x0;
719             session.win[i] = false;
720             session.amountInvest[i] = 0;
721         }
722     }
723     
724     /// @dev Open new session, only escrow can call
725     function openSession ()
726         public
727         onlyEscrow
728     {
729         require(session.isReset && !session.isOpen);
730         session.isReset = false;
731         // open invest
732         session.investOpen = true;
733         session.timeOpen = now;
734         session.isOpen = true;
735         SessionOpen(now, sessionId);
736     }
737     
738     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
739     /// @param _choose choise of investor, true is call, false is put
740     function invest (bool _choose)
741         public
742         payable
743     {
744         require(msg.value >= 100000000000000000 && session.investOpen); // msg.value >= 0.1 ether
745         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
746         require(session.investorCount < MAX_INVESTOR && session.investedSession[msg.sender] != sessionId);
747         session.investor[session.investorCount] = msg.sender;
748         session.win[session.investorCount] = _choose;
749         session.amountInvest[session.investorCount] = msg.value;
750         session.investorCount += 1;
751         session.investedSession[msg.sender] = sessionId;
752         Invest(msg.sender, _choose, msg.value, now, sessionId);
753     }
754     
755     /// @dev close invest for escrow
756     /// @param _priceOpen price ETH in USD
757     function closeInvest (uint _priceOpen) 
758         public
759         onlyEscrow
760     {
761         require(_priceOpen != 0 && session.investOpen);
762         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
763         session.investOpen = false;
764         session.priceOpen = _priceOpen;
765         InvestClose(now, _priceOpen, sessionId);
766     }
767     
768     /// @dev get amount of ether to buy NAC for investor
769     /// @param _ether amount ether which investor invest
770     /// @param _rate rate between win and loss investor
771     /// @param _status true for investor win and false for investor loss
772     function getEtherToBuy (uint _ether, uint _rate, bool _status)
773         public
774         pure
775         returns (uint)
776     {
777         if (_status) {
778             return _ether * _rate / 100;
779         } else {
780             return _ether * (200 - _rate) / 100;
781         }
782     }
783 
784     /// @dev close session, only escrow can call
785     /// @param _priceClose price of ETH in USD
786     function closeSession (uint _priceClose)
787         public
788         onlyEscrow
789     {
790         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
791         require(!session.investOpen && session.isOpen);
792         session.priceClose = _priceClose;
793         bool result = (_priceClose>session.priceOpen)?true:false;
794         uint etherToBuy;
795         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
796         uint price = namiContract.getPrice();
797         for (uint i = 0; i < session.investorCount; i++) {
798             if (session.win[i]==result) {
799                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, true);
800             } else {
801                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, false);
802             }
803             namiContract.buy.value(etherToBuy)(session.investor[i]);
804             // reset investor
805             session.investor[i] = 0x0;
806             session.win[i] = false;
807             session.amountInvest[i] = 0;
808         }
809         session.isOpen = false;
810         SessionClose(now, sessionId, _priceClose, price, rate);
811         sessionId += 1;
812         
813         // require(!session.isReset && !session.isOpen);
814         // reset state session
815         session.priceOpen = 0;
816         session.priceClose = 0;
817         session.isReset = true;
818         session.investOpen = false;
819         session.investorCount = 0;
820     }
821 }
822 
823 
824 contract PresaleToken {
825     mapping (address => uint256) public balanceOf;
826     function burnTokens(address _owner) public;
827 }
828 
829  /*
830  * Contract that is working with ERC223 tokens
831  */
832  
833  /**
834  * @title Contract that will work with ERC223 tokens.
835  */
836  
837 contract ERC223ReceivingContract {
838 /**
839  * @dev Standard ERC223 function that will handle incoming token transfers.
840  *
841  * @param _from  Token sender address.
842  * @param _value Amount of tokens.
843  * @param _data  Transaction metadata.
844  */
845     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
846     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
847     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
848 }
849 
850 
851  /*
852  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
853  *
854  */
855 
856 contract NamiExchange {
857     using SafeMath for uint;
858     
859     function NamiExchange(address _namiAddress) public {
860         NamiAddr = _namiAddress;
861     }
862 
863     event UpdateBid(address owner, uint price, uint balance);
864     event UpdateAsk(address owner, uint price, uint volume);
865 
866     
867     mapping(address => OrderBid) public bid;
868     mapping(address => OrderAsk) public ask;
869     string public name = "NacExchange";
870     
871     /// address of Nami token
872     address NamiAddr;
873     
874     /// price of Nac = ETH/NAC
875     uint public price = 1;
876     uint public etherBalance=0;
877     uint public nacBalance=0;
878     // struct store order of user
879     struct OrderBid {
880         uint price;
881         uint eth;
882     }
883     
884     struct OrderAsk {
885         uint price;
886         uint volume;
887     }
888     
889         
890     // prevent lost ether
891     function() payable public {
892         require(msg.value > 0);
893         if (bid[msg.sender].price > 0) {
894             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
895             etherBalance = etherBalance.add(msg.value);
896             UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
897         } else {
898             // refund
899             msg.sender.transfer(msg.value);
900         }
901         // test
902         // address test = "0x70c932369fc1C76fde684FF05966A70b9c1561c1";
903         // test.transfer(msg.value);
904     }
905 
906     // prevent lost token
907     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success) {
908         require(_value > 0 && _data.length == 0);
909         if (ask[_from].price > 0) {
910             ask[_from].volume = (ask[_from].volume).add(_value);
911             nacBalance = nacBalance.add(_value);
912             UpdateAsk(_from, ask[_from].price, ask[_from].volume);
913             return true;
914         } else {
915             //refund
916             ERC23 asset = ERC23(NamiAddr);
917             asset.transfer(_from, _value);
918             return false;
919         }
920     }
921     
922     modifier onlyNami {
923         require(msg.sender == NamiAddr);
924         _;
925     }
926     
927     
928     /////////////////
929     // function about bid Order-----------------------------------------------------------
930     
931     function placeBuyOrder(uint _price) payable public {
932         require(_price > 0);
933         if (msg.value > 0) {
934             etherBalance += msg.value;
935             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
936             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
937         }
938         bid[msg.sender].price = _price;
939     }
940     
941     function tokenFallbackBuyer(address _from, uint _value, address _buyer) onlyNami public returns (bool success) {
942         ERC23 asset = ERC23(NamiAddr);
943         uint currentEth = bid[_buyer].eth;
944         if ((_value.div(bid[_buyer].price)) > currentEth) {
945             if (_from.send(currentEth) && asset.transfer(_buyer, currentEth.mul(bid[_buyer].price)) && asset.transfer(_from, _value - (currentEth.mul(bid[_buyer].price) ) ) ) {
946                 bid[_buyer].eth = 0;
947                 etherBalance = etherBalance.sub(currentEth);
948                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
949                 return true;
950             } else {
951                 // refund token
952                 asset.transfer(_from, _value);
953                 return false;
954             }
955         } else {
956             uint eth = _value.div(bid[_buyer].price);
957             if (_from.send(eth) && asset.transfer(_buyer, _value)) {
958                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
959                 etherBalance = etherBalance.sub(eth);
960                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
961                 return true;
962             } else {
963                 // refund token
964                 asset.transfer(_from, _value);
965                 return false;
966             }
967         }
968     }
969     
970     function closeBidOrder() public {
971         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
972         msg.sender.transfer(bid[msg.sender].eth);
973         etherBalance = etherBalance.sub(bid[msg.sender].eth);
974         bid[msg.sender].eth = 0;
975         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
976     }
977     
978 
979     ////////////////
980     // function about ask Order-----------------------------------------------------------
981     // place ask order by send NAC to contract
982     
983     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
984         require(_price > 0);
985         if (_value > 0) {
986             nacBalance = nacBalance.add(_value);
987             ask[_from].volume = (ask[_from].volume).add(_value);
988             ask[_from].price = _price;
989             UpdateAsk(_from, _price, ask[_from].volume);
990             return true;
991         } else {
992             ask[_from].price = _price;
993             return false;
994         }
995     }
996     
997     function closeAskOrder() public {
998         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
999         ERC23 asset = ERC23(NamiAddr);
1000         if (asset.transfer(msg.sender, ask[msg.sender].volume)) {
1001             nacBalance = nacBalance.sub(ask[msg.sender].volume);
1002             ask[msg.sender].volume = 0;
1003             UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1004         }
1005     }
1006     
1007     function buyNac(address _seller) payable public returns (bool success) {
1008         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1009         ERC23 asset = ERC23(NamiAddr);
1010         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1011         if (msg.value > maxEth) {
1012             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth)) && asset.transfer(msg.sender, ask[_seller].volume)) {
1013                 nacBalance = nacBalance.sub(ask[_seller].volume);
1014                 ask[_seller].volume = 0;
1015                 UpdateAsk(_seller, ask[_seller].price, 0);
1016                 return true;
1017             } else {
1018                 //refund
1019                 return false;
1020             }
1021         } else {
1022             if (_seller.send(msg.value) && asset.transfer(msg.sender, (msg.value).mul(ask[_seller].price))) {
1023                 uint nac = (msg.value).mul(ask[_seller].price);
1024                 nacBalance = nacBalance.sub(nac);
1025                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1026                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1027                 return true;
1028             } else {
1029                 //refund
1030                 return false;
1031             }
1032         }
1033     }
1034 }
1035 
1036 contract ERC23 {
1037   function balanceOf(address who) public constant returns (uint);
1038   function transfer(address to, uint value) public returns (bool success);
1039 }
1040 
1041 
1042 
1043 /*
1044 * NamiMultiSigWallet smart contract-------------------------------
1045 */
1046 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1047 contract NamiMultiSigWallet {
1048 
1049     uint constant public MAX_OWNER_COUNT = 50;
1050 
1051     event Confirmation(address indexed sender, uint indexed transactionId);
1052     event Revocation(address indexed sender, uint indexed transactionId);
1053     event Submission(uint indexed transactionId);
1054     event Execution(uint indexed transactionId);
1055     event ExecutionFailure(uint indexed transactionId);
1056     event Deposit(address indexed sender, uint value);
1057     event OwnerAddition(address indexed owner);
1058     event OwnerRemoval(address indexed owner);
1059     event RequirementChange(uint required);
1060 
1061     mapping (uint => Transaction) public transactions;
1062     mapping (uint => mapping (address => bool)) public confirmations;
1063     mapping (address => bool) public isOwner;
1064     address[] public owners;
1065     uint public required;
1066     uint public transactionCount;
1067 
1068     struct Transaction {
1069         address destination;
1070         uint value;
1071         bytes data;
1072         bool executed;
1073     }
1074 
1075     modifier onlyWallet() {
1076         require(msg.sender == address(this));
1077         _;
1078     }
1079 
1080     modifier ownerDoesNotExist(address owner) {
1081         require(!isOwner[owner]);
1082         _;
1083     }
1084 
1085     modifier ownerExists(address owner) {
1086         require(isOwner[owner]);
1087         _;
1088     }
1089 
1090     modifier transactionExists(uint transactionId) {
1091         require(transactions[transactionId].destination != 0);
1092         _;
1093     }
1094 
1095     modifier confirmed(uint transactionId, address owner) {
1096         require(confirmations[transactionId][owner]);
1097         _;
1098     }
1099 
1100     modifier notConfirmed(uint transactionId, address owner) {
1101         require(!confirmations[transactionId][owner]);
1102         _;
1103     }
1104 
1105     modifier notExecuted(uint transactionId) {
1106         require(!transactions[transactionId].executed);
1107         _;
1108     }
1109 
1110     modifier notNull(address _address) {
1111         require(_address != 0);
1112         _;
1113     }
1114 
1115     modifier validRequirement(uint ownerCount, uint _required) {
1116         require(!(ownerCount > MAX_OWNER_COUNT
1117             || _required > ownerCount
1118             || _required == 0
1119             || ownerCount == 0));
1120         _;
1121     }
1122 
1123     /// @dev Fallback function allows to deposit ether.
1124     function() public payable {
1125         if (msg.value > 0)
1126             Deposit(msg.sender, msg.value);
1127     }
1128 
1129     /*
1130      * Public functions
1131      */
1132     /// @dev Contract constructor sets initial owners and required number of confirmations.
1133     /// @param _owners List of initial owners.
1134     /// @param _required Number of required confirmations.
1135     function NamiMultiSigWallet(address[] _owners, uint _required)
1136         public
1137         validRequirement(_owners.length, _required)
1138     {
1139         for (uint i = 0; i < _owners.length; i++) {
1140             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1141             isOwner[_owners[i]] = true;
1142         }
1143         owners = _owners;
1144         required = _required;
1145     }
1146 
1147     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1148     /// @param owner Address of new owner.
1149     function addOwner(address owner)
1150         public
1151         onlyWallet
1152         ownerDoesNotExist(owner)
1153         notNull(owner)
1154         validRequirement(owners.length + 1, required)
1155     {
1156         isOwner[owner] = true;
1157         owners.push(owner);
1158         OwnerAddition(owner);
1159     }
1160 
1161     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1162     /// @param owner Address of owner.
1163     function removeOwner(address owner)
1164         public
1165         onlyWallet
1166         ownerExists(owner)
1167     {
1168         isOwner[owner] = false;
1169         for (uint i=0; i<owners.length - 1; i++) {
1170             if (owners[i] == owner) {
1171                 owners[i] = owners[owners.length - 1];
1172                 break;
1173             }
1174         }
1175         owners.length -= 1;
1176         if (required > owners.length)
1177             changeRequirement(owners.length);
1178         OwnerRemoval(owner);
1179     }
1180 
1181     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1182     /// @param owner Address of owner to be replaced.
1183     /// @param owner Address of new owner.
1184     function replaceOwner(address owner, address newOwner)
1185         public
1186         onlyWallet
1187         ownerExists(owner)
1188         ownerDoesNotExist(newOwner)
1189     {
1190         for (uint i=0; i<owners.length; i++) {
1191             if (owners[i] == owner) {
1192                 owners[i] = newOwner;
1193                 break;
1194             }
1195         }
1196         isOwner[owner] = false;
1197         isOwner[newOwner] = true;
1198         OwnerRemoval(owner);
1199         OwnerAddition(newOwner);
1200     }
1201 
1202     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1203     /// @param _required Number of required confirmations.
1204     function changeRequirement(uint _required)
1205         public
1206         onlyWallet
1207         validRequirement(owners.length, _required)
1208     {
1209         required = _required;
1210         RequirementChange(_required);
1211     }
1212 
1213     /// @dev Allows an owner to submit and confirm a transaction.
1214     /// @param destination Transaction target address.
1215     /// @param value Transaction ether value.
1216     /// @param data Transaction data payload.
1217     /// @return Returns transaction ID.
1218     function submitTransaction(address destination, uint value, bytes data)
1219         public
1220         returns (uint transactionId)
1221     {
1222         transactionId = addTransaction(destination, value, data);
1223         confirmTransaction(transactionId);
1224     }
1225 
1226     /// @dev Allows an owner to confirm a transaction.
1227     /// @param transactionId Transaction ID.
1228     function confirmTransaction(uint transactionId)
1229         public
1230         ownerExists(msg.sender)
1231         transactionExists(transactionId)
1232         notConfirmed(transactionId, msg.sender)
1233     {
1234         confirmations[transactionId][msg.sender] = true;
1235         Confirmation(msg.sender, transactionId);
1236         executeTransaction(transactionId);
1237     }
1238 
1239     /// @dev Allows an owner to revoke a confirmation for a transaction.
1240     /// @param transactionId Transaction ID.
1241     function revokeConfirmation(uint transactionId)
1242         public
1243         ownerExists(msg.sender)
1244         confirmed(transactionId, msg.sender)
1245         notExecuted(transactionId)
1246     {
1247         confirmations[transactionId][msg.sender] = false;
1248         Revocation(msg.sender, transactionId);
1249     }
1250 
1251     /// @dev Allows anyone to execute a confirmed transaction.
1252     /// @param transactionId Transaction ID.
1253     function executeTransaction(uint transactionId)
1254         public
1255         notExecuted(transactionId)
1256     {
1257         if (isConfirmed(transactionId)) {
1258             // Transaction tx = transactions[transactionId];
1259             transactions[transactionId].executed = true;
1260             // tx.executed = true;
1261             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1262                 Execution(transactionId);
1263             } else {
1264                 ExecutionFailure(transactionId);
1265                 transactions[transactionId].executed = false;
1266             }
1267         }
1268     }
1269 
1270     /// @dev Returns the confirmation status of a transaction.
1271     /// @param transactionId Transaction ID.
1272     /// @return Confirmation status.
1273     function isConfirmed(uint transactionId)
1274         public
1275         constant
1276         returns (bool)
1277     {
1278         uint count = 0;
1279         for (uint i = 0; i < owners.length; i++) {
1280             if (confirmations[transactionId][owners[i]])
1281                 count += 1;
1282             if (count == required)
1283                 return true;
1284         }
1285     }
1286 
1287     /*
1288      * Internal functions
1289      */
1290     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1291     /// @param destination Transaction target address.
1292     /// @param value Transaction ether value.
1293     /// @param data Transaction data payload.
1294     /// @return Returns transaction ID.
1295     function addTransaction(address destination, uint value, bytes data)
1296         internal
1297         notNull(destination)
1298         returns (uint transactionId)
1299     {
1300         transactionId = transactionCount;
1301         transactions[transactionId] = Transaction({
1302             destination: destination, 
1303             value: value,
1304             data: data,
1305             executed: false
1306         });
1307         transactionCount += 1;
1308         Submission(transactionId);
1309     }
1310 
1311     /*
1312      * Web3 call functions
1313      */
1314     /// @dev Returns number of confirmations of a transaction.
1315     /// @param transactionId Transaction ID.
1316     /// @return Number of confirmations.
1317     function getConfirmationCount(uint transactionId)
1318         public
1319         constant
1320         returns (uint count)
1321     {
1322         for (uint i = 0; i < owners.length; i++) {
1323             if (confirmations[transactionId][owners[i]])
1324                 count += 1;
1325         }
1326     }
1327 
1328     /// @dev Returns total number of transactions after filers are applied.
1329     /// @param pending Include pending transactions.
1330     /// @param executed Include executed transactions.
1331     /// @return Total number of transactions after filters are applied.
1332     function getTransactionCount(bool pending, bool executed)
1333         public
1334         constant
1335         returns (uint count)
1336     {
1337         for (uint i = 0; i < transactionCount; i++) {
1338             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1339                 count += 1;
1340         }
1341     }
1342 
1343     /// @dev Returns list of owners.
1344     /// @return List of owner addresses.
1345     function getOwners()
1346         public
1347         constant
1348         returns (address[])
1349     {
1350         return owners;
1351     }
1352 
1353     /// @dev Returns array with owner addresses, which confirmed transaction.
1354     /// @param transactionId Transaction ID.
1355     /// @return Returns array of owner addresses.
1356     function getConfirmations(uint transactionId)
1357         public
1358         constant
1359         returns (address[] _confirmations)
1360     {
1361         address[] memory confirmationsTemp = new address[](owners.length);
1362         uint count = 0;
1363         uint i;
1364         for (i = 0; i < owners.length; i++) {
1365             if (confirmations[transactionId][owners[i]]) {
1366                 confirmationsTemp[count] = owners[i];
1367                 count += 1;
1368             }
1369         }
1370         _confirmations = new address[](count);
1371         for (i = 0; i < count; i++) {
1372             _confirmations[i] = confirmationsTemp[i];
1373         }
1374     }
1375 
1376     /// @dev Returns list of transaction IDs in defined range.
1377     /// @param from Index start position of transaction array.
1378     /// @param to Index end position of transaction array.
1379     /// @param pending Include pending transactions.
1380     /// @param executed Include executed transactions.
1381     /// @return Returns array of transaction IDs.
1382     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1383         public
1384         constant
1385         returns (uint[] _transactionIds)
1386     {
1387         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1388         uint count = 0;
1389         uint i;
1390         for (i = 0; i < transactionCount; i++) {
1391             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1392                 transactionIdsTemp[count] = i;
1393                 count += 1;
1394             }
1395         }
1396         _transactionIds = new uint[](to - from);
1397         for (i = from; i < to; i++) {
1398             _transactionIds[i - from] = transactionIdsTemp[i];
1399         }
1400     }
1401 }