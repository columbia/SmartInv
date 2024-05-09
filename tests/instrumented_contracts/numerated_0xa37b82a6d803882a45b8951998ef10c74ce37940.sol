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
468     /**
469      * @dev Transfer the specified amount of tokens to the NamiExchange address.
470      *      Invokes the `tokenFallbackExchange` function.
471      *      The token transfer fails if the recipient is a contract
472      *      but does not implement the `tokenFallbackExchange` function
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
498      * @dev Transfer the specified amount of tokens to the NamiExchange address.
499      *      Invokes the `tokenFallbackBuyer` function.
500      *      The token transfer fails if the recipient is a contract
501      *      but does not implement the `tokenFallbackBuyer` function
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
549     uint public minimunEth = 10000000000000000; // minimunEth = 0.01 eth
550     /**
551      * Events for binany option system
552      */
553     event SessionOpen(uint timeOpen, uint indexed sessionId);
554     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
555     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
556     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rate);
557 
558     event Deposit(address indexed sender, uint value);
559     /// @dev Fallback function allows to deposit ether.
560     function() public payable {
561         if (msg.value > 0)
562             Deposit(msg.sender, msg.value);
563     }
564     // there is only one session available at one timeOpen
565     // priceOpen is price of ETH in USD
566     // priceClose is price of ETH in USD
567     // process of one Session
568     // 1st: escrow reset session by run resetSession()
569     // 2nd: escrow open session by run openSession() => save timeOpen at this time
570     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
571     // 4th: escrow close invest and insert price open for this Session
572     // 5th: escrow close session and send NAC for investor
573     struct Session {
574         uint priceOpen;
575         uint priceClose;
576         uint timeOpen;
577         bool isReset;
578         bool isOpen;
579         bool investOpen;
580         uint investorCount;
581         mapping(uint => address) investor;
582         mapping(uint => bool) win;
583         mapping(uint => uint) amountInvest;
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
613     // chagne minimunEth
614     function changeMinEth(uint _minimunEth) public 
615         onlyEscrow
616     {
617         require(_minimunEth != 0);
618         minimunEth = _minimunEth;
619     }
620     
621     /// @dev Change time for investor can invest in one session, can only change at time not in session
622     /// @param _timeInvest time invest in minutes
623     function changeTimeInvest(uint _timeInvest)
624         public
625         onlyEscrow
626     {
627         require(!session.isOpen && _timeInvest < timeOneSession);
628         timeInvestInMinute = _timeInvest;
629     }
630     
631     // 100 < _rate < 200
632     // price of NAC for investor win = _rate/100
633     // price of NAC for investor loss = 2 - _rate/100
634     function changeRate(uint _rate)
635         public
636         onlyEscrow
637     {
638         require(100 < _rate && _rate < 200 && !session.isOpen);
639         rate = _rate;
640     }
641     
642     function changeTimeOneSession(uint _timeOneSession) 
643         public
644         onlyEscrow
645     {
646         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
647         timeOneSession = _timeOneSession;
648     }
649     
650     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
651     /// @param _amount value ether in wei to withdraw
652     function withdrawEther(uint _amount) public
653         onlyEscrow
654     {
655         require(namiMultiSigWallet != 0x0);
656         // Available at any phase.
657         if (this.balance > 0) {
658             namiMultiSigWallet.transfer(_amount);
659         }
660     }
661     
662     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
663     /// @param _withdraw address to withdraw
664     function safeWithdraw(address _withdraw, uint _amount) public
665         onlyEscrow
666     {
667         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
668         if (namiWallet.isOwner(_withdraw)) {
669             _withdraw.transfer(_amount);
670         }
671     }
672     
673     // @dev Returns list of owners.
674     // @return List of owner addresses.
675     // MAX_INVESTOR = 20
676     function getInvestors()
677         public
678         view
679         returns (address[20])
680     {
681         address[20] memory listInvestor;
682         for (uint i = 0; i < MAX_INVESTOR; i++) {
683             listInvestor[i] = session.investor[i];
684         }
685         return listInvestor;
686     }
687     
688     function getChooses()
689         public
690         view
691         returns (bool[20])
692     {
693         bool[20] memory listChooses;
694         for (uint i = 0; i < MAX_INVESTOR; i++) {
695             listChooses[i] = session.win[i];
696         }
697         return listChooses;
698     }
699     
700     function getAmount()
701         public
702         view
703         returns (uint[20])
704     {
705         uint[20] memory listAmount;
706         for (uint i = 0; i < MAX_INVESTOR; i++) {
707             listAmount[i] = session.amountInvest[i];
708         }
709         return listAmount;
710     }
711     
712     /// @dev reset all data of previous session, must run before open new session
713     // only escrow can call
714     function resetSession()
715         public
716         onlyEscrow
717     {
718         require(!session.isReset && !session.isOpen);
719         session.priceOpen = 0;
720         session.priceClose = 0;
721         session.isReset = true;
722         session.isOpen = false;
723         session.investOpen = false;
724         session.investorCount = 0;
725         for (uint i = 0; i < MAX_INVESTOR; i++) {
726             session.investor[i] = 0x0;
727             session.win[i] = false;
728             session.amountInvest[i] = 0;
729         }
730     }
731     
732     /// @dev Open new session, only escrow can call
733     function openSession ()
734         public
735         onlyEscrow
736     {
737         require(session.isReset && !session.isOpen);
738         session.isReset = false;
739         // open invest
740         session.investOpen = true;
741         session.timeOpen = now;
742         session.isOpen = true;
743         SessionOpen(now, sessionId);
744     }
745     
746     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
747     /// @param _choose choise of investor, true is call, false is put
748     function invest (bool _choose)
749         public
750         payable
751     {
752         require(msg.value >= minimunEth && session.investOpen); // msg.value >= 0.1 ether
753         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
754         require(session.investorCount < MAX_INVESTOR);
755         session.investor[session.investorCount] = msg.sender;
756         session.win[session.investorCount] = _choose;
757         session.amountInvest[session.investorCount] = msg.value;
758         session.investorCount += 1;
759         Invest(msg.sender, _choose, msg.value, now, sessionId);
760     }
761     
762     /// @dev close invest for escrow
763     /// @param _priceOpen price ETH in USD
764     function closeInvest (uint _priceOpen) 
765         public
766         onlyEscrow
767     {
768         require(_priceOpen != 0 && session.investOpen);
769         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
770         session.investOpen = false;
771         session.priceOpen = _priceOpen;
772         InvestClose(now, _priceOpen, sessionId);
773     }
774     
775     /// @dev get amount of ether to buy NAC for investor
776     /// @param _ether amount ether which investor invest
777     /// @param _rate rate between win and loss investor
778     /// @param _status true for investor win and false for investor loss
779     function getEtherToBuy (uint _ether, uint _rate, bool _status)
780         public
781         pure
782         returns (uint)
783     {
784         if (_status) {
785             return _ether * _rate / 100;
786         } else {
787             return _ether * (200 - _rate) / 100;
788         }
789     }
790 
791     /// @dev close session, only escrow can call
792     /// @param _priceClose price of ETH in USD
793     function closeSession (uint _priceClose)
794         public
795         onlyEscrow
796     {
797         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
798         require(!session.investOpen && session.isOpen);
799         session.priceClose = _priceClose;
800         bool result = (_priceClose>session.priceOpen)?true:false;
801         uint etherToBuy;
802         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
803         uint price = namiContract.getPrice();
804         for (uint i = 0; i < session.investorCount; i++) {
805             if (session.win[i]==result) {
806                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, true);
807             } else {
808                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, false);
809             }
810             namiContract.buy.value(etherToBuy)(session.investor[i]);
811             // reset investor
812             session.investor[i] = 0x0;
813             session.win[i] = false;
814             session.amountInvest[i] = 0;
815         }
816         session.isOpen = false;
817         SessionClose(now, sessionId, _priceClose, price, rate);
818         sessionId += 1;
819         
820         // require(!session.isReset && !session.isOpen);
821         // reset state session
822         session.priceOpen = 0;
823         session.priceClose = 0;
824         session.isReset = true;
825         session.investOpen = false;
826         session.investorCount = 0;
827     }
828 }
829 
830 
831 contract PresaleToken {
832     mapping (address => uint256) public balanceOf;
833     function burnTokens(address _owner) public;
834 }
835 
836  /*
837  * Contract that is working with ERC223 tokens
838  */
839  
840  /**
841  * @title Contract that will work with ERC223 tokens.
842  */
843  
844 contract ERC223ReceivingContract {
845 /**
846  * @dev Standard ERC223 function that will handle incoming token transfers.
847  *
848  * @param _from  Token sender address.
849  * @param _value Amount of tokens.
850  * @param _data  Transaction metadata.
851  */
852     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
853     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
854     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
855 }
856 
857 
858  /*
859  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
860  *
861  */
862 
863 contract NamiExchange {
864     using SafeMath for uint;
865     
866     function NamiExchange(address _namiAddress) public {
867         NamiAddr = _namiAddress;
868     }
869 
870     event UpdateBid(address owner, uint price, uint balance);
871     event UpdateAsk(address owner, uint price, uint volume);
872     event BuyHistory(address indexed buyer, address indexed seller, uint price, uint volume, uint time);
873     event SellHistory(address indexed seller, address indexed buyer, uint price, uint volume, uint time);
874 
875     
876     mapping(address => OrderBid) public bid;
877     mapping(address => OrderAsk) public ask;
878     string public name = "NacExchange";
879     
880     /// address of Nami token
881     address public NamiAddr;
882     
883     /// price of Nac = ETH/NAC
884     uint public price = 1;
885     // struct store order of user
886     struct OrderBid {
887         uint price;
888         uint eth;
889     }
890     
891     struct OrderAsk {
892         uint price;
893         uint volume;
894     }
895     
896         
897     // prevent lost ether
898     function() payable public {
899         require(msg.data.length != 0);
900         require(msg.value == 0);
901     }
902     
903     modifier onlyNami {
904         require(msg.sender == NamiAddr);
905         _;
906     }
907     
908     /////////////////
909     //---------------------------function about bid Order-----------------------------------------------------------
910     
911     function placeBuyOrder(uint _price) payable public {
912         require(_price > 0 && msg.value > 0 && bid[msg.sender].eth == 0);
913         if (msg.value > 0) {
914             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
915             bid[msg.sender].price = _price;
916             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
917         }
918     }
919     
920     function sellNac(uint _value, address _buyer, uint _price) public returns (bool success) {
921         require(_price == bid[_buyer].price && _buyer != msg.sender);
922         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
923         uint ethOfBuyer = bid[_buyer].eth;
924         uint maxToken = ethOfBuyer.mul(bid[_buyer].price);
925         require(namiToken.allowance(msg.sender, this) >= _value && _value > 0 && ethOfBuyer != 0 && _buyer != 0x0);
926         if (_value > maxToken) {
927             if (msg.sender.send(ethOfBuyer) && namiToken.transferFrom(msg.sender,_buyer,maxToken)) {
928                 // update order
929                 bid[_buyer].eth = 0;
930                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
931                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, maxToken, now);
932                 return true;
933             } else {
934                 // revert anything
935                 revert();
936             }
937         } else {
938             uint eth = _value.div(bid[_buyer].price);
939             if (msg.sender.send(eth) && namiToken.transferFrom(msg.sender,_buyer,_value)) {
940                 // update order
941                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
942                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
943                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, _value, now);
944                 return true;
945             } else {
946                 // revert anything
947                 revert();
948             }
949         }
950     }
951     
952     function closeBidOrder() public {
953         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
954         // transfer ETH
955         msg.sender.transfer(bid[msg.sender].eth);
956         // update order
957         bid[msg.sender].eth = 0;
958         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
959     }
960     
961 
962     ////////////////
963     //---------------------------function about ask Order-----------------------------------------------------------
964     
965     // place ask order by send NAC to Nami Exchange contract
966     // this function place sell order
967     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
968         require(_price > 0 && _value > 0 && ask[_from].volume == 0);
969         if (_value > 0) {
970             ask[_from].volume = (ask[_from].volume).add(_value);
971             ask[_from].price = _price;
972             UpdateAsk(_from, _price, ask[_from].volume);
973         }
974         return true;
975     }
976     
977     function closeAskOrder() public {
978         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
979         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
980         uint previousBalances = namiToken.balanceOf(msg.sender);
981         // transfer token
982         namiToken.transfer(msg.sender, ask[msg.sender].volume);
983         // update order
984         ask[msg.sender].volume = 0;
985         UpdateAsk(msg.sender, ask[msg.sender].price, 0);
986         // check balance
987         assert(previousBalances < namiToken.balanceOf(msg.sender));
988     }
989     
990     function buyNac(address _seller, uint _price) payable public returns (bool success) {
991         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
992         require(_price == ask[_seller].price && _seller != msg.sender);
993         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
994         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
995         uint previousBalances = namiToken.balanceOf(msg.sender);
996         if (msg.value > maxEth) {
997             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth))) {
998                 // transfer token
999                 namiToken.transfer(msg.sender, ask[_seller].volume);
1000                 SellHistory(_seller, msg.sender, ask[_seller].price, ask[_seller].volume, now);
1001                 // update order
1002                 ask[_seller].volume = 0;
1003                 UpdateAsk(_seller, ask[_seller].price, 0);
1004                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1005                 return true;
1006             } else {
1007                 // revert anything
1008                 revert();
1009             }
1010         } else {
1011             uint nac = (msg.value).mul(ask[_seller].price);
1012             if (_seller.send(msg.value)) {
1013                 // transfer token
1014                 namiToken.transfer(msg.sender, nac);
1015                 // update order
1016                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1017                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1018                 SellHistory(_seller, msg.sender, ask[_seller].price, nac, now);
1019                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1020                 return true;
1021             } else {
1022                 // revert anything
1023                 revert();
1024             }
1025         }
1026     }
1027 }
1028 
1029 contract ERC23 {
1030   function balanceOf(address who) public constant returns (uint);
1031   function transfer(address to, uint value) public returns (bool success);
1032 }
1033 
1034 
1035 
1036 /*
1037 * NamiMultiSigWallet smart contract-------------------------------
1038 */
1039 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1040 contract NamiMultiSigWallet {
1041 
1042     uint constant public MAX_OWNER_COUNT = 50;
1043 
1044     event Confirmation(address indexed sender, uint indexed transactionId);
1045     event Revocation(address indexed sender, uint indexed transactionId);
1046     event Submission(uint indexed transactionId);
1047     event Execution(uint indexed transactionId);
1048     event ExecutionFailure(uint indexed transactionId);
1049     event Deposit(address indexed sender, uint value);
1050     event OwnerAddition(address indexed owner);
1051     event OwnerRemoval(address indexed owner);
1052     event RequirementChange(uint required);
1053 
1054     mapping (uint => Transaction) public transactions;
1055     mapping (uint => mapping (address => bool)) public confirmations;
1056     mapping (address => bool) public isOwner;
1057     address[] public owners;
1058     uint public required;
1059     uint public transactionCount;
1060 
1061     struct Transaction {
1062         address destination;
1063         uint value;
1064         bytes data;
1065         bool executed;
1066     }
1067 
1068     modifier onlyWallet() {
1069         require(msg.sender == address(this));
1070         _;
1071     }
1072 
1073     modifier ownerDoesNotExist(address owner) {
1074         require(!isOwner[owner]);
1075         _;
1076     }
1077 
1078     modifier ownerExists(address owner) {
1079         require(isOwner[owner]);
1080         _;
1081     }
1082 
1083     modifier transactionExists(uint transactionId) {
1084         require(transactions[transactionId].destination != 0);
1085         _;
1086     }
1087 
1088     modifier confirmed(uint transactionId, address owner) {
1089         require(confirmations[transactionId][owner]);
1090         _;
1091     }
1092 
1093     modifier notConfirmed(uint transactionId, address owner) {
1094         require(!confirmations[transactionId][owner]);
1095         _;
1096     }
1097 
1098     modifier notExecuted(uint transactionId) {
1099         require(!transactions[transactionId].executed);
1100         _;
1101     }
1102 
1103     modifier notNull(address _address) {
1104         require(_address != 0);
1105         _;
1106     }
1107 
1108     modifier validRequirement(uint ownerCount, uint _required) {
1109         require(!(ownerCount > MAX_OWNER_COUNT
1110             || _required > ownerCount
1111             || _required == 0
1112             || ownerCount == 0));
1113         _;
1114     }
1115 
1116     /// @dev Fallback function allows to deposit ether.
1117     function() public payable {
1118         if (msg.value > 0)
1119             Deposit(msg.sender, msg.value);
1120     }
1121 
1122     /*
1123      * Public functions
1124      */
1125     /// @dev Contract constructor sets initial owners and required number of confirmations.
1126     /// @param _owners List of initial owners.
1127     /// @param _required Number of required confirmations.
1128     function NamiMultiSigWallet(address[] _owners, uint _required)
1129         public
1130         validRequirement(_owners.length, _required)
1131     {
1132         for (uint i = 0; i < _owners.length; i++) {
1133             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1134             isOwner[_owners[i]] = true;
1135         }
1136         owners = _owners;
1137         required = _required;
1138     }
1139 
1140     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1141     /// @param owner Address of new owner.
1142     function addOwner(address owner)
1143         public
1144         onlyWallet
1145         ownerDoesNotExist(owner)
1146         notNull(owner)
1147         validRequirement(owners.length + 1, required)
1148     {
1149         isOwner[owner] = true;
1150         owners.push(owner);
1151         OwnerAddition(owner);
1152     }
1153 
1154     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1155     /// @param owner Address of owner.
1156     function removeOwner(address owner)
1157         public
1158         onlyWallet
1159         ownerExists(owner)
1160     {
1161         isOwner[owner] = false;
1162         for (uint i=0; i<owners.length - 1; i++) {
1163             if (owners[i] == owner) {
1164                 owners[i] = owners[owners.length - 1];
1165                 break;
1166             }
1167         }
1168         owners.length -= 1;
1169         if (required > owners.length)
1170             changeRequirement(owners.length);
1171         OwnerRemoval(owner);
1172     }
1173 
1174     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1175     /// @param owner Address of owner to be replaced.
1176     /// @param owner Address of new owner.
1177     function replaceOwner(address owner, address newOwner)
1178         public
1179         onlyWallet
1180         ownerExists(owner)
1181         ownerDoesNotExist(newOwner)
1182     {
1183         for (uint i=0; i<owners.length; i++) {
1184             if (owners[i] == owner) {
1185                 owners[i] = newOwner;
1186                 break;
1187             }
1188         }
1189         isOwner[owner] = false;
1190         isOwner[newOwner] = true;
1191         OwnerRemoval(owner);
1192         OwnerAddition(newOwner);
1193     }
1194 
1195     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1196     /// @param _required Number of required confirmations.
1197     function changeRequirement(uint _required)
1198         public
1199         onlyWallet
1200         validRequirement(owners.length, _required)
1201     {
1202         required = _required;
1203         RequirementChange(_required);
1204     }
1205 
1206     /// @dev Allows an owner to submit and confirm a transaction.
1207     /// @param destination Transaction target address.
1208     /// @param value Transaction ether value.
1209     /// @param data Transaction data payload.
1210     /// @return Returns transaction ID.
1211     function submitTransaction(address destination, uint value, bytes data)
1212         public
1213         returns (uint transactionId)
1214     {
1215         transactionId = addTransaction(destination, value, data);
1216         confirmTransaction(transactionId);
1217     }
1218 
1219     /// @dev Allows an owner to confirm a transaction.
1220     /// @param transactionId Transaction ID.
1221     function confirmTransaction(uint transactionId)
1222         public
1223         ownerExists(msg.sender)
1224         transactionExists(transactionId)
1225         notConfirmed(transactionId, msg.sender)
1226     {
1227         confirmations[transactionId][msg.sender] = true;
1228         Confirmation(msg.sender, transactionId);
1229         executeTransaction(transactionId);
1230     }
1231 
1232     /// @dev Allows an owner to revoke a confirmation for a transaction.
1233     /// @param transactionId Transaction ID.
1234     function revokeConfirmation(uint transactionId)
1235         public
1236         ownerExists(msg.sender)
1237         confirmed(transactionId, msg.sender)
1238         notExecuted(transactionId)
1239     {
1240         confirmations[transactionId][msg.sender] = false;
1241         Revocation(msg.sender, transactionId);
1242     }
1243 
1244     /// @dev Allows anyone to execute a confirmed transaction.
1245     /// @param transactionId Transaction ID.
1246     function executeTransaction(uint transactionId)
1247         public
1248         notExecuted(transactionId)
1249     {
1250         if (isConfirmed(transactionId)) {
1251             // Transaction tx = transactions[transactionId];
1252             transactions[transactionId].executed = true;
1253             // tx.executed = true;
1254             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1255                 Execution(transactionId);
1256             } else {
1257                 ExecutionFailure(transactionId);
1258                 transactions[transactionId].executed = false;
1259             }
1260         }
1261     }
1262 
1263     /// @dev Returns the confirmation status of a transaction.
1264     /// @param transactionId Transaction ID.
1265     /// @return Confirmation status.
1266     function isConfirmed(uint transactionId)
1267         public
1268         constant
1269         returns (bool)
1270     {
1271         uint count = 0;
1272         for (uint i = 0; i < owners.length; i++) {
1273             if (confirmations[transactionId][owners[i]])
1274                 count += 1;
1275             if (count == required)
1276                 return true;
1277         }
1278     }
1279 
1280     /*
1281      * Internal functions
1282      */
1283     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1284     /// @param destination Transaction target address.
1285     /// @param value Transaction ether value.
1286     /// @param data Transaction data payload.
1287     /// @return Returns transaction ID.
1288     function addTransaction(address destination, uint value, bytes data)
1289         internal
1290         notNull(destination)
1291         returns (uint transactionId)
1292     {
1293         transactionId = transactionCount;
1294         transactions[transactionId] = Transaction({
1295             destination: destination, 
1296             value: value,
1297             data: data,
1298             executed: false
1299         });
1300         transactionCount += 1;
1301         Submission(transactionId);
1302     }
1303 
1304     /*
1305      * Web3 call functions
1306      */
1307     /// @dev Returns number of confirmations of a transaction.
1308     /// @param transactionId Transaction ID.
1309     /// @return Number of confirmations.
1310     function getConfirmationCount(uint transactionId)
1311         public
1312         constant
1313         returns (uint count)
1314     {
1315         for (uint i = 0; i < owners.length; i++) {
1316             if (confirmations[transactionId][owners[i]])
1317                 count += 1;
1318         }
1319     }
1320 
1321     /// @dev Returns total number of transactions after filers are applied.
1322     /// @param pending Include pending transactions.
1323     /// @param executed Include executed transactions.
1324     /// @return Total number of transactions after filters are applied.
1325     function getTransactionCount(bool pending, bool executed)
1326         public
1327         constant
1328         returns (uint count)
1329     {
1330         for (uint i = 0; i < transactionCount; i++) {
1331             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1332                 count += 1;
1333         }
1334     }
1335 
1336     /// @dev Returns list of owners.
1337     /// @return List of owner addresses.
1338     function getOwners()
1339         public
1340         constant
1341         returns (address[])
1342     {
1343         return owners;
1344     }
1345 
1346     /// @dev Returns array with owner addresses, which confirmed transaction.
1347     /// @param transactionId Transaction ID.
1348     /// @return Returns array of owner addresses.
1349     function getConfirmations(uint transactionId)
1350         public
1351         constant
1352         returns (address[] _confirmations)
1353     {
1354         address[] memory confirmationsTemp = new address[](owners.length);
1355         uint count = 0;
1356         uint i;
1357         for (i = 0; i < owners.length; i++) {
1358             if (confirmations[transactionId][owners[i]]) {
1359                 confirmationsTemp[count] = owners[i];
1360                 count += 1;
1361             }
1362         }
1363         _confirmations = new address[](count);
1364         for (i = 0; i < count; i++) {
1365             _confirmations[i] = confirmationsTemp[i];
1366         }
1367     }
1368 
1369     /// @dev Returns list of transaction IDs in defined range.
1370     /// @param from Index start position of transaction array.
1371     /// @param to Index end position of transaction array.
1372     /// @param pending Include pending transactions.
1373     /// @param executed Include executed transactions.
1374     /// @return Returns array of transaction IDs.
1375     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1376         public
1377         constant
1378         returns (uint[] _transactionIds)
1379     {
1380         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1381         uint count = 0;
1382         uint i;
1383         for (i = 0; i < transactionCount; i++) {
1384             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1385                 transactionIdsTemp[count] = i;
1386                 count += 1;
1387             }
1388         }
1389         _transactionIds = new uint[](to - from);
1390         for (i = from; i < to; i++) {
1391             _transactionIds[i - from] = transactionIdsTemp[i];
1392         }
1393     }
1394 }