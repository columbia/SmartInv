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
544     uint public timeInvestInMinute = 10;
545     uint public timeOneSession = 15;
546     uint public sessionId = 1;
547     uint public rateWin = 100;
548     uint public rateLoss = 20;
549     uint public rateFee = 5;
550     uint public constant MAX_INVESTOR = 20;
551     uint public minimunEth = 10000000000000000; // minimunEth = 0.01 eth
552     /**
553      * Events for binany option system
554      */
555     event SessionOpen(uint timeOpen, uint indexed sessionId);
556     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
557     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
558     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rateWin, uint rateLoss, uint rateFee);
559 
560     event Deposit(address indexed sender, uint value);
561     /// @dev Fallback function allows to deposit ether.
562     function() public payable {
563         if (msg.value > 0)
564             Deposit(msg.sender, msg.value);
565     }
566     // there is only one session available at one timeOpen
567     // priceOpen is price of ETH in USD
568     // priceClose is price of ETH in USD
569     // process of one Session
570     // 1st: escrow reset session by run resetSession()
571     // 2nd: escrow open session by run openSession() => save timeOpen at this time
572     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
573     // 4th: escrow close invest and insert price open for this Session
574     // 5th: escrow close session and send NAC for investor
575     struct Session {
576         uint priceOpen;
577         uint priceClose;
578         uint timeOpen;
579         bool isReset;
580         bool isOpen;
581         bool investOpen;
582         uint investorCount;
583         mapping(uint => address) investor;
584         mapping(uint => bool) win;
585         mapping(uint => uint) amountInvest;
586     }
587     
588     function BinaryOption(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
589         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
590         namiCrowdSaleAddr = _namiCrowdSale;
591         escrow = _escrow;
592         namiMultiSigWallet = _namiMultiSigWallet;
593     }
594     
595     
596     modifier onlyEscrow() {
597         require(msg.sender==escrow);
598         _;
599     }
600     
601         
602     modifier onlyNamiMultisig() {
603         require(msg.sender == namiMultiSigWallet);
604         _;
605     }
606     
607     // change escrow
608     function changeEscrow(address _escrow) public
609         onlyNamiMultisig
610     {
611         require(_escrow != 0x0);
612         escrow = _escrow;
613     }
614     
615     // chagne minimunEth
616     function changeMinEth(uint _minimunEth) public 
617         onlyEscrow
618     {
619         require(_minimunEth != 0);
620         minimunEth = _minimunEth;
621     }
622     
623     /// @dev Change time for investor can invest in one session, can only change at time not in session
624     /// @param _timeInvest time invest in minutes
625     ///---------------------------change time function------------------------------
626     function changeTimeInvest(uint _timeInvest)
627         public
628         onlyEscrow
629     {
630         require(!session.isOpen && _timeInvest < timeOneSession);
631         timeInvestInMinute = _timeInvest;
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
642     /////------------------------change rate function-------------------------------
643     
644     function changeRateWin(uint _rateWin)
645         public
646         onlyEscrow
647     {
648         require(!session.isOpen);
649         rateWin = _rateWin;
650     }
651     
652     function changeRateLoss(uint _rateLoss)
653         public
654         onlyEscrow
655     {
656         require(!session.isOpen);
657         rateLoss = _rateLoss;
658     }
659     
660     function changeRateFee(uint _rateFee)
661         public
662         onlyEscrow
663     {
664         require(!session.isOpen);
665         rateFee = _rateFee;
666     }
667     
668     
669     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
670     /// @param _amount value ether in wei to withdraw
671     function withdrawEther(uint _amount) public
672         onlyEscrow
673     {
674         require(namiMultiSigWallet != 0x0);
675         // Available at any phase.
676         if (this.balance > 0) {
677             namiMultiSigWallet.transfer(_amount);
678         }
679     }
680     
681     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
682     /// @param _withdraw address to withdraw
683     function safeWithdraw(address _withdraw, uint _amount) public
684         onlyEscrow
685     {
686         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
687         if (namiWallet.isOwner(_withdraw)) {
688             _withdraw.transfer(_amount);
689         }
690     }
691     
692     // @dev Returns list of owners.
693     // @return List of owner addresses.
694     // MAX_INVESTOR = 20
695     function getInvestors()
696         public
697         view
698         returns (address[20])
699     {
700         address[20] memory listInvestor;
701         for (uint i = 0; i < MAX_INVESTOR; i++) {
702             listInvestor[i] = session.investor[i];
703         }
704         return listInvestor;
705     }
706     
707     function getChooses()
708         public
709         view
710         returns (bool[20])
711     {
712         bool[20] memory listChooses;
713         for (uint i = 0; i < MAX_INVESTOR; i++) {
714             listChooses[i] = session.win[i];
715         }
716         return listChooses;
717     }
718     
719     function getAmount()
720         public
721         view
722         returns (uint[20])
723     {
724         uint[20] memory listAmount;
725         for (uint i = 0; i < MAX_INVESTOR; i++) {
726             listAmount[i] = session.amountInvest[i];
727         }
728         return listAmount;
729     }
730     
731     /// @dev reset all data of previous session, must run before open new session
732     // only escrow can call
733     function resetSession()
734         public
735         onlyEscrow
736     {
737         require(!session.isReset && !session.isOpen);
738         session.priceOpen = 0;
739         session.priceClose = 0;
740         session.isReset = true;
741         session.isOpen = false;
742         session.investOpen = false;
743         session.investorCount = 0;
744         for (uint i = 0; i < MAX_INVESTOR; i++) {
745             session.investor[i] = 0x0;
746             session.win[i] = false;
747             session.amountInvest[i] = 0;
748         }
749     }
750     
751     /// @dev Open new session, only escrow can call
752     function openSession ()
753         public
754         onlyEscrow
755     {
756         require(session.isReset && !session.isOpen);
757         session.isReset = false;
758         // open invest
759         session.investOpen = true;
760         session.timeOpen = now;
761         session.isOpen = true;
762         SessionOpen(now, sessionId);
763     }
764     
765     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
766     /// @param _choose choise of investor, true is call, false is put
767     function invest (bool _choose)
768         public
769         payable
770     {
771         require(msg.value >= minimunEth && session.investOpen); // msg.value >= 0.1 ether
772         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
773         require(session.investorCount < MAX_INVESTOR);
774         session.investor[session.investorCount] = msg.sender;
775         session.win[session.investorCount] = _choose;
776         session.amountInvest[session.investorCount] = msg.value;
777         session.investorCount += 1;
778         Invest(msg.sender, _choose, msg.value, now, sessionId);
779     }
780     
781     /// @dev close invest for escrow
782     /// @param _priceOpen price ETH in USD
783     function closeInvest (uint _priceOpen) 
784         public
785         onlyEscrow
786     {
787         require(_priceOpen != 0 && session.investOpen);
788         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
789         session.investOpen = false;
790         session.priceOpen = _priceOpen;
791         InvestClose(now, _priceOpen, sessionId);
792     }
793     
794     /// @dev get amount of ether to buy NAC for investor
795     /// @param _ether amount ether which investor invest
796     /// @param _status true for investor win and false for investor loss
797     function getEtherToBuy (uint _ether, bool _status)
798         public
799         view
800         returns (uint)
801     {
802         if (_status) {
803             return _ether * rateWin / 100;
804         } else {
805             return _ether * rateLoss / 100;
806         }
807     }
808 
809     /// @dev close session, only escrow can call
810     /// @param _priceClose price of ETH in USD
811     function closeSession (uint _priceClose)
812         public
813         onlyEscrow
814     {
815         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
816         require(!session.investOpen && session.isOpen);
817         session.priceClose = _priceClose;
818         bool result = (_priceClose>session.priceOpen)?true:false;
819         uint etherToBuy;
820         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
821         uint price = namiContract.getPrice();
822         require(price != 0);
823         for (uint i = 0; i < session.investorCount; i++) {
824             if (session.win[i]==result) {
825                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateWin / 100;
826                 uint etherReturn = session.amountInvest[i] - session.amountInvest[i] * rateFee / 100;
827                 (session.investor[i]).transfer(etherReturn);
828             } else {
829                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateLoss / 100;
830             }
831             namiContract.buy.value(etherToBuy)(session.investor[i]);
832             // reset investor
833             session.investor[i] = 0x0;
834             session.win[i] = false;
835             session.amountInvest[i] = 0;
836         }
837         session.isOpen = false;
838         SessionClose(now, sessionId, _priceClose, price, rateWin, rateLoss, rateFee);
839         sessionId += 1;
840         
841         // require(!session.isReset && !session.isOpen);
842         // reset state session
843         session.priceOpen = 0;
844         session.priceClose = 0;
845         session.isReset = true;
846         session.investOpen = false;
847         session.investorCount = 0;
848     }
849 }
850 
851 
852 contract PresaleToken {
853     mapping (address => uint256) public balanceOf;
854     function burnTokens(address _owner) public;
855 }
856 
857  /*
858  * Contract that is working with ERC223 tokens
859  */
860  
861  /**
862  * @title Contract that will work with ERC223 tokens.
863  */
864  
865 contract ERC223ReceivingContract {
866 /**
867  * @dev Standard ERC223 function that will handle incoming token transfers.
868  *
869  * @param _from  Token sender address.
870  * @param _value Amount of tokens.
871  * @param _data  Transaction metadata.
872  */
873     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
874     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
875     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
876 }
877 
878 
879  /*
880  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
881  *
882  */
883 
884 contract NamiExchange {
885     using SafeMath for uint;
886     
887     function NamiExchange(address _namiAddress) public {
888         NamiAddr = _namiAddress;
889     }
890 
891     event UpdateBid(address owner, uint price, uint balance);
892     event UpdateAsk(address owner, uint price, uint volume);
893     event BuyHistory(address indexed buyer, address indexed seller, uint price, uint volume, uint time);
894     event SellHistory(address indexed seller, address indexed buyer, uint price, uint volume, uint time);
895 
896     
897     mapping(address => OrderBid) public bid;
898     mapping(address => OrderAsk) public ask;
899     string public name = "NacExchange";
900     
901     /// address of Nami token
902     address public NamiAddr;
903     
904     /// price of Nac = ETH/NAC
905     uint public price = 1;
906     // struct store order of user
907     struct OrderBid {
908         uint price;
909         uint eth;
910     }
911     
912     struct OrderAsk {
913         uint price;
914         uint volume;
915     }
916     
917         
918     // prevent lost ether
919     function() payable public {
920         require(msg.data.length != 0);
921         require(msg.value == 0);
922     }
923     
924     modifier onlyNami {
925         require(msg.sender == NamiAddr);
926         _;
927     }
928     
929     /////////////////
930     //---------------------------function about bid Order-----------------------------------------------------------
931     
932     function placeBuyOrder(uint _price) payable public {
933         require(_price > 0 && msg.value > 0 && bid[msg.sender].eth == 0);
934         if (msg.value > 0) {
935             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
936             bid[msg.sender].price = _price;
937             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
938         }
939     }
940     
941     function sellNac(uint _value, address _buyer, uint _price) public returns (bool success) {
942         require(_price == bid[_buyer].price && _buyer != msg.sender);
943         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
944         uint ethOfBuyer = bid[_buyer].eth;
945         uint maxToken = ethOfBuyer.mul(bid[_buyer].price);
946         require(namiToken.allowance(msg.sender, this) >= _value && _value > 0 && ethOfBuyer != 0 && _buyer != 0x0);
947         if (_value > maxToken) {
948             if (msg.sender.send(ethOfBuyer) && namiToken.transferFrom(msg.sender,_buyer,maxToken)) {
949                 // update order
950                 bid[_buyer].eth = 0;
951                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
952                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, maxToken, now);
953                 return true;
954             } else {
955                 // revert anything
956                 revert();
957             }
958         } else {
959             uint eth = _value.div(bid[_buyer].price);
960             if (msg.sender.send(eth) && namiToken.transferFrom(msg.sender,_buyer,_value)) {
961                 // update order
962                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
963                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
964                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, _value, now);
965                 return true;
966             } else {
967                 // revert anything
968                 revert();
969             }
970         }
971     }
972     
973     function closeBidOrder() public {
974         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
975         // transfer ETH
976         msg.sender.transfer(bid[msg.sender].eth);
977         // update order
978         bid[msg.sender].eth = 0;
979         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
980     }
981     
982 
983     ////////////////
984     //---------------------------function about ask Order-----------------------------------------------------------
985     
986     // place ask order by send NAC to Nami Exchange contract
987     // this function place sell order
988     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
989         require(_price > 0 && _value > 0 && ask[_from].volume == 0);
990         if (_value > 0) {
991             ask[_from].volume = (ask[_from].volume).add(_value);
992             ask[_from].price = _price;
993             UpdateAsk(_from, _price, ask[_from].volume);
994         }
995         return true;
996     }
997     
998     function closeAskOrder() public {
999         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
1000         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1001         uint previousBalances = namiToken.balanceOf(msg.sender);
1002         // transfer token
1003         namiToken.transfer(msg.sender, ask[msg.sender].volume);
1004         // update order
1005         ask[msg.sender].volume = 0;
1006         UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1007         // check balance
1008         assert(previousBalances < namiToken.balanceOf(msg.sender));
1009     }
1010     
1011     function buyNac(address _seller, uint _price) payable public returns (bool success) {
1012         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1013         require(_price == ask[_seller].price && _seller != msg.sender);
1014         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1015         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1016         uint previousBalances = namiToken.balanceOf(msg.sender);
1017         if (msg.value > maxEth) {
1018             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth))) {
1019                 // transfer token
1020                 namiToken.transfer(msg.sender, ask[_seller].volume);
1021                 SellHistory(_seller, msg.sender, ask[_seller].price, ask[_seller].volume, now);
1022                 // update order
1023                 ask[_seller].volume = 0;
1024                 UpdateAsk(_seller, ask[_seller].price, 0);
1025                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1026                 return true;
1027             } else {
1028                 // revert anything
1029                 revert();
1030             }
1031         } else {
1032             uint nac = (msg.value).mul(ask[_seller].price);
1033             if (_seller.send(msg.value)) {
1034                 // transfer token
1035                 namiToken.transfer(msg.sender, nac);
1036                 // update order
1037                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1038                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1039                 SellHistory(_seller, msg.sender, ask[_seller].price, nac, now);
1040                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1041                 return true;
1042             } else {
1043                 // revert anything
1044                 revert();
1045             }
1046         }
1047     }
1048 }
1049 
1050 contract ERC23 {
1051   function balanceOf(address who) public constant returns (uint);
1052   function transfer(address to, uint value) public returns (bool success);
1053 }
1054 
1055 
1056 
1057 /*
1058 * NamiMultiSigWallet smart contract-------------------------------
1059 */
1060 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1061 contract NamiMultiSigWallet {
1062 
1063     uint constant public MAX_OWNER_COUNT = 50;
1064 
1065     event Confirmation(address indexed sender, uint indexed transactionId);
1066     event Revocation(address indexed sender, uint indexed transactionId);
1067     event Submission(uint indexed transactionId);
1068     event Execution(uint indexed transactionId);
1069     event ExecutionFailure(uint indexed transactionId);
1070     event Deposit(address indexed sender, uint value);
1071     event OwnerAddition(address indexed owner);
1072     event OwnerRemoval(address indexed owner);
1073     event RequirementChange(uint required);
1074 
1075     mapping (uint => Transaction) public transactions;
1076     mapping (uint => mapping (address => bool)) public confirmations;
1077     mapping (address => bool) public isOwner;
1078     address[] public owners;
1079     uint public required;
1080     uint public transactionCount;
1081 
1082     struct Transaction {
1083         address destination;
1084         uint value;
1085         bytes data;
1086         bool executed;
1087     }
1088 
1089     modifier onlyWallet() {
1090         require(msg.sender == address(this));
1091         _;
1092     }
1093 
1094     modifier ownerDoesNotExist(address owner) {
1095         require(!isOwner[owner]);
1096         _;
1097     }
1098 
1099     modifier ownerExists(address owner) {
1100         require(isOwner[owner]);
1101         _;
1102     }
1103 
1104     modifier transactionExists(uint transactionId) {
1105         require(transactions[transactionId].destination != 0);
1106         _;
1107     }
1108 
1109     modifier confirmed(uint transactionId, address owner) {
1110         require(confirmations[transactionId][owner]);
1111         _;
1112     }
1113 
1114     modifier notConfirmed(uint transactionId, address owner) {
1115         require(!confirmations[transactionId][owner]);
1116         _;
1117     }
1118 
1119     modifier notExecuted(uint transactionId) {
1120         require(!transactions[transactionId].executed);
1121         _;
1122     }
1123 
1124     modifier notNull(address _address) {
1125         require(_address != 0);
1126         _;
1127     }
1128 
1129     modifier validRequirement(uint ownerCount, uint _required) {
1130         require(!(ownerCount > MAX_OWNER_COUNT
1131             || _required > ownerCount
1132             || _required == 0
1133             || ownerCount == 0));
1134         _;
1135     }
1136 
1137     /// @dev Fallback function allows to deposit ether.
1138     function() public payable {
1139         if (msg.value > 0)
1140             Deposit(msg.sender, msg.value);
1141     }
1142 
1143     /*
1144      * Public functions
1145      */
1146     /// @dev Contract constructor sets initial owners and required number of confirmations.
1147     /// @param _owners List of initial owners.
1148     /// @param _required Number of required confirmations.
1149     function NamiMultiSigWallet(address[] _owners, uint _required)
1150         public
1151         validRequirement(_owners.length, _required)
1152     {
1153         for (uint i = 0; i < _owners.length; i++) {
1154             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1155             isOwner[_owners[i]] = true;
1156         }
1157         owners = _owners;
1158         required = _required;
1159     }
1160 
1161     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1162     /// @param owner Address of new owner.
1163     function addOwner(address owner)
1164         public
1165         onlyWallet
1166         ownerDoesNotExist(owner)
1167         notNull(owner)
1168         validRequirement(owners.length + 1, required)
1169     {
1170         isOwner[owner] = true;
1171         owners.push(owner);
1172         OwnerAddition(owner);
1173     }
1174 
1175     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1176     /// @param owner Address of owner.
1177     function removeOwner(address owner)
1178         public
1179         onlyWallet
1180         ownerExists(owner)
1181     {
1182         isOwner[owner] = false;
1183         for (uint i=0; i<owners.length - 1; i++) {
1184             if (owners[i] == owner) {
1185                 owners[i] = owners[owners.length - 1];
1186                 break;
1187             }
1188         }
1189         owners.length -= 1;
1190         if (required > owners.length)
1191             changeRequirement(owners.length);
1192         OwnerRemoval(owner);
1193     }
1194 
1195     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1196     /// @param owner Address of owner to be replaced.
1197     /// @param owner Address of new owner.
1198     function replaceOwner(address owner, address newOwner)
1199         public
1200         onlyWallet
1201         ownerExists(owner)
1202         ownerDoesNotExist(newOwner)
1203     {
1204         for (uint i=0; i<owners.length; i++) {
1205             if (owners[i] == owner) {
1206                 owners[i] = newOwner;
1207                 break;
1208             }
1209         }
1210         isOwner[owner] = false;
1211         isOwner[newOwner] = true;
1212         OwnerRemoval(owner);
1213         OwnerAddition(newOwner);
1214     }
1215 
1216     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1217     /// @param _required Number of required confirmations.
1218     function changeRequirement(uint _required)
1219         public
1220         onlyWallet
1221         validRequirement(owners.length, _required)
1222     {
1223         required = _required;
1224         RequirementChange(_required);
1225     }
1226 
1227     /// @dev Allows an owner to submit and confirm a transaction.
1228     /// @param destination Transaction target address.
1229     /// @param value Transaction ether value.
1230     /// @param data Transaction data payload.
1231     /// @return Returns transaction ID.
1232     function submitTransaction(address destination, uint value, bytes data)
1233         public
1234         returns (uint transactionId)
1235     {
1236         transactionId = addTransaction(destination, value, data);
1237         confirmTransaction(transactionId);
1238     }
1239 
1240     /// @dev Allows an owner to confirm a transaction.
1241     /// @param transactionId Transaction ID.
1242     function confirmTransaction(uint transactionId)
1243         public
1244         ownerExists(msg.sender)
1245         transactionExists(transactionId)
1246         notConfirmed(transactionId, msg.sender)
1247     {
1248         confirmations[transactionId][msg.sender] = true;
1249         Confirmation(msg.sender, transactionId);
1250         executeTransaction(transactionId);
1251     }
1252 
1253     /// @dev Allows an owner to revoke a confirmation for a transaction.
1254     /// @param transactionId Transaction ID.
1255     function revokeConfirmation(uint transactionId)
1256         public
1257         ownerExists(msg.sender)
1258         confirmed(transactionId, msg.sender)
1259         notExecuted(transactionId)
1260     {
1261         confirmations[transactionId][msg.sender] = false;
1262         Revocation(msg.sender, transactionId);
1263     }
1264 
1265     /// @dev Allows anyone to execute a confirmed transaction.
1266     /// @param transactionId Transaction ID.
1267     function executeTransaction(uint transactionId)
1268         public
1269         notExecuted(transactionId)
1270     {
1271         if (isConfirmed(transactionId)) {
1272             // Transaction tx = transactions[transactionId];
1273             transactions[transactionId].executed = true;
1274             // tx.executed = true;
1275             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1276                 Execution(transactionId);
1277             } else {
1278                 ExecutionFailure(transactionId);
1279                 transactions[transactionId].executed = false;
1280             }
1281         }
1282     }
1283 
1284     /// @dev Returns the confirmation status of a transaction.
1285     /// @param transactionId Transaction ID.
1286     /// @return Confirmation status.
1287     function isConfirmed(uint transactionId)
1288         public
1289         constant
1290         returns (bool)
1291     {
1292         uint count = 0;
1293         for (uint i = 0; i < owners.length; i++) {
1294             if (confirmations[transactionId][owners[i]])
1295                 count += 1;
1296             if (count == required)
1297                 return true;
1298         }
1299     }
1300 
1301     /*
1302      * Internal functions
1303      */
1304     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1305     /// @param destination Transaction target address.
1306     /// @param value Transaction ether value.
1307     /// @param data Transaction data payload.
1308     /// @return Returns transaction ID.
1309     function addTransaction(address destination, uint value, bytes data)
1310         internal
1311         notNull(destination)
1312         returns (uint transactionId)
1313     {
1314         transactionId = transactionCount;
1315         transactions[transactionId] = Transaction({
1316             destination: destination, 
1317             value: value,
1318             data: data,
1319             executed: false
1320         });
1321         transactionCount += 1;
1322         Submission(transactionId);
1323     }
1324 
1325     /*
1326      * Web3 call functions
1327      */
1328     /// @dev Returns number of confirmations of a transaction.
1329     /// @param transactionId Transaction ID.
1330     /// @return Number of confirmations.
1331     function getConfirmationCount(uint transactionId)
1332         public
1333         constant
1334         returns (uint count)
1335     {
1336         for (uint i = 0; i < owners.length; i++) {
1337             if (confirmations[transactionId][owners[i]])
1338                 count += 1;
1339         }
1340     }
1341 
1342     /// @dev Returns total number of transactions after filers are applied.
1343     /// @param pending Include pending transactions.
1344     /// @param executed Include executed transactions.
1345     /// @return Total number of transactions after filters are applied.
1346     function getTransactionCount(bool pending, bool executed)
1347         public
1348         constant
1349         returns (uint count)
1350     {
1351         for (uint i = 0; i < transactionCount; i++) {
1352             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1353                 count += 1;
1354         }
1355     }
1356 
1357     /// @dev Returns list of owners.
1358     /// @return List of owner addresses.
1359     function getOwners()
1360         public
1361         constant
1362         returns (address[])
1363     {
1364         return owners;
1365     }
1366 
1367     /// @dev Returns array with owner addresses, which confirmed transaction.
1368     /// @param transactionId Transaction ID.
1369     /// @return Returns array of owner addresses.
1370     function getConfirmations(uint transactionId)
1371         public
1372         constant
1373         returns (address[] _confirmations)
1374     {
1375         address[] memory confirmationsTemp = new address[](owners.length);
1376         uint count = 0;
1377         uint i;
1378         for (i = 0; i < owners.length; i++) {
1379             if (confirmations[transactionId][owners[i]]) {
1380                 confirmationsTemp[count] = owners[i];
1381                 count += 1;
1382             }
1383         }
1384         _confirmations = new address[](count);
1385         for (i = 0; i < count; i++) {
1386             _confirmations[i] = confirmationsTemp[i];
1387         }
1388     }
1389 
1390     /// @dev Returns list of transaction IDs in defined range.
1391     /// @param from Index start position of transaction array.
1392     /// @param to Index end position of transaction array.
1393     /// @param pending Include pending transactions.
1394     /// @param executed Include executed transactions.
1395     /// @return Returns array of transaction IDs.
1396     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1397         public
1398         constant
1399         returns (uint[] _transactionIds)
1400     {
1401         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1402         uint count = 0;
1403         uint i;
1404         for (i = 0; i < transactionCount; i++) {
1405             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1406                 transactionIdsTemp[count] = i;
1407                 count += 1;
1408             }
1409         }
1410         _transactionIds = new uint[](to - from);
1411         for (i = from; i < to; i++) {
1412             _transactionIds[i - from] = transactionIdsTemp[i];
1413         }
1414     }
1415 }