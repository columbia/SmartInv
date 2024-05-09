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
872 
873     
874     mapping(address => OrderBid) public bid;
875     mapping(address => OrderAsk) public ask;
876     string public name = "NacExchange";
877     
878     /// address of Nami token
879     address NamiAddr;
880     
881     /// price of Nac = ETH/NAC
882     uint public price = 1;
883     uint public etherBalance=0;
884     uint public nacBalance=0;
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
899         require(msg.value > 0);
900         if (bid[msg.sender].price > 0) {
901             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
902             etherBalance = etherBalance.add(msg.value);
903             UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
904         } else {
905             // refund
906             msg.sender.transfer(msg.value);
907         }
908         // test
909         // address test = "0x70c932369fc1C76fde684FF05966A70b9c1561c1";
910         // test.transfer(msg.value);
911     }
912 
913     // prevent lost token
914     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success) {
915         require(_value > 0 && _data.length == 0);
916         if (ask[_from].price > 0) {
917             ask[_from].volume = (ask[_from].volume).add(_value);
918             nacBalance = nacBalance.add(_value);
919             UpdateAsk(_from, ask[_from].price, ask[_from].volume);
920             return true;
921         } else {
922             //refund
923             ERC23 asset = ERC23(NamiAddr);
924             asset.transfer(_from, _value);
925             return false;
926         }
927     }
928     
929     modifier onlyNami {
930         require(msg.sender == NamiAddr);
931         _;
932     }
933     
934     
935     /////////////////
936     // function about bid Order-----------------------------------------------------------
937     
938     function placeBuyOrder(uint _price) payable public {
939         require(_price > 0);
940         if (msg.value > 0) {
941             etherBalance += msg.value;
942             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
943             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
944         }
945         bid[msg.sender].price = _price;
946     }
947     
948     function tokenFallbackBuyer(address _from, uint _value, address _buyer) onlyNami public returns (bool success) {
949         ERC23 asset = ERC23(NamiAddr);
950         uint currentEth = bid[_buyer].eth;
951         if ((_value.div(bid[_buyer].price)) > currentEth) {
952             if (_from.send(currentEth) && asset.transfer(_buyer, currentEth.mul(bid[_buyer].price)) && asset.transfer(_from, _value - (currentEth.mul(bid[_buyer].price) ) ) ) {
953                 bid[_buyer].eth = 0;
954                 etherBalance = etherBalance.sub(currentEth);
955                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
956                 return true;
957             } else {
958                 // refund token
959                 asset.transfer(_from, _value);
960                 return false;
961             }
962         } else {
963             uint eth = _value.div(bid[_buyer].price);
964             if (_from.send(eth) && asset.transfer(_buyer, _value)) {
965                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
966                 etherBalance = etherBalance.sub(eth);
967                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
968                 return true;
969             } else {
970                 // refund token
971                 asset.transfer(_from, _value);
972                 return false;
973             }
974         }
975     }
976     
977     function closeBidOrder() public {
978         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
979         msg.sender.transfer(bid[msg.sender].eth);
980         etherBalance = etherBalance.sub(bid[msg.sender].eth);
981         bid[msg.sender].eth = 0;
982         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
983     }
984     
985 
986     ////////////////
987     // function about ask Order-----------------------------------------------------------
988     // place ask order by send NAC to contract
989     
990     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
991         require(_price > 0);
992         if (_value > 0) {
993             nacBalance = nacBalance.add(_value);
994             ask[_from].volume = (ask[_from].volume).add(_value);
995             ask[_from].price = _price;
996             UpdateAsk(_from, _price, ask[_from].volume);
997             return true;
998         } else {
999             ask[_from].price = _price;
1000             return false;
1001         }
1002     }
1003     
1004     function closeAskOrder() public {
1005         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
1006         ERC23 asset = ERC23(NamiAddr);
1007         if (asset.transfer(msg.sender, ask[msg.sender].volume)) {
1008             nacBalance = nacBalance.sub(ask[msg.sender].volume);
1009             ask[msg.sender].volume = 0;
1010             UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1011         }
1012     }
1013     
1014     function buyNac(address _seller) payable public returns (bool success) {
1015         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1016         ERC23 asset = ERC23(NamiAddr);
1017         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1018         if (msg.value > maxEth) {
1019             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth)) && asset.transfer(msg.sender, ask[_seller].volume)) {
1020                 nacBalance = nacBalance.sub(ask[_seller].volume);
1021                 ask[_seller].volume = 0;
1022                 UpdateAsk(_seller, ask[_seller].price, 0);
1023                 return true;
1024             } else {
1025                 //refund
1026                 return false;
1027             }
1028         } else {
1029             if (_seller.send(msg.value) && asset.transfer(msg.sender, (msg.value).mul(ask[_seller].price))) {
1030                 uint nac = (msg.value).mul(ask[_seller].price);
1031                 nacBalance = nacBalance.sub(nac);
1032                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1033                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1034                 return true;
1035             } else {
1036                 //refund
1037                 return false;
1038             }
1039         }
1040     }
1041 }
1042 
1043 contract ERC23 {
1044   function balanceOf(address who) public constant returns (uint);
1045   function transfer(address to, uint value) public returns (bool success);
1046 }
1047 
1048 
1049 
1050 /*
1051 * NamiMultiSigWallet smart contract-------------------------------
1052 */
1053 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1054 contract NamiMultiSigWallet {
1055 
1056     uint constant public MAX_OWNER_COUNT = 50;
1057 
1058     event Confirmation(address indexed sender, uint indexed transactionId);
1059     event Revocation(address indexed sender, uint indexed transactionId);
1060     event Submission(uint indexed transactionId);
1061     event Execution(uint indexed transactionId);
1062     event ExecutionFailure(uint indexed transactionId);
1063     event Deposit(address indexed sender, uint value);
1064     event OwnerAddition(address indexed owner);
1065     event OwnerRemoval(address indexed owner);
1066     event RequirementChange(uint required);
1067 
1068     mapping (uint => Transaction) public transactions;
1069     mapping (uint => mapping (address => bool)) public confirmations;
1070     mapping (address => bool) public isOwner;
1071     address[] public owners;
1072     uint public required;
1073     uint public transactionCount;
1074 
1075     struct Transaction {
1076         address destination;
1077         uint value;
1078         bytes data;
1079         bool executed;
1080     }
1081 
1082     modifier onlyWallet() {
1083         require(msg.sender == address(this));
1084         _;
1085     }
1086 
1087     modifier ownerDoesNotExist(address owner) {
1088         require(!isOwner[owner]);
1089         _;
1090     }
1091 
1092     modifier ownerExists(address owner) {
1093         require(isOwner[owner]);
1094         _;
1095     }
1096 
1097     modifier transactionExists(uint transactionId) {
1098         require(transactions[transactionId].destination != 0);
1099         _;
1100     }
1101 
1102     modifier confirmed(uint transactionId, address owner) {
1103         require(confirmations[transactionId][owner]);
1104         _;
1105     }
1106 
1107     modifier notConfirmed(uint transactionId, address owner) {
1108         require(!confirmations[transactionId][owner]);
1109         _;
1110     }
1111 
1112     modifier notExecuted(uint transactionId) {
1113         require(!transactions[transactionId].executed);
1114         _;
1115     }
1116 
1117     modifier notNull(address _address) {
1118         require(_address != 0);
1119         _;
1120     }
1121 
1122     modifier validRequirement(uint ownerCount, uint _required) {
1123         require(!(ownerCount > MAX_OWNER_COUNT
1124             || _required > ownerCount
1125             || _required == 0
1126             || ownerCount == 0));
1127         _;
1128     }
1129 
1130     /// @dev Fallback function allows to deposit ether.
1131     function() public payable {
1132         if (msg.value > 0)
1133             Deposit(msg.sender, msg.value);
1134     }
1135 
1136     /*
1137      * Public functions
1138      */
1139     /// @dev Contract constructor sets initial owners and required number of confirmations.
1140     /// @param _owners List of initial owners.
1141     /// @param _required Number of required confirmations.
1142     function NamiMultiSigWallet(address[] _owners, uint _required)
1143         public
1144         validRequirement(_owners.length, _required)
1145     {
1146         for (uint i = 0; i < _owners.length; i++) {
1147             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1148             isOwner[_owners[i]] = true;
1149         }
1150         owners = _owners;
1151         required = _required;
1152     }
1153 
1154     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1155     /// @param owner Address of new owner.
1156     function addOwner(address owner)
1157         public
1158         onlyWallet
1159         ownerDoesNotExist(owner)
1160         notNull(owner)
1161         validRequirement(owners.length + 1, required)
1162     {
1163         isOwner[owner] = true;
1164         owners.push(owner);
1165         OwnerAddition(owner);
1166     }
1167 
1168     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1169     /// @param owner Address of owner.
1170     function removeOwner(address owner)
1171         public
1172         onlyWallet
1173         ownerExists(owner)
1174     {
1175         isOwner[owner] = false;
1176         for (uint i=0; i<owners.length - 1; i++) {
1177             if (owners[i] == owner) {
1178                 owners[i] = owners[owners.length - 1];
1179                 break;
1180             }
1181         }
1182         owners.length -= 1;
1183         if (required > owners.length)
1184             changeRequirement(owners.length);
1185         OwnerRemoval(owner);
1186     }
1187 
1188     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1189     /// @param owner Address of owner to be replaced.
1190     /// @param owner Address of new owner.
1191     function replaceOwner(address owner, address newOwner)
1192         public
1193         onlyWallet
1194         ownerExists(owner)
1195         ownerDoesNotExist(newOwner)
1196     {
1197         for (uint i=0; i<owners.length; i++) {
1198             if (owners[i] == owner) {
1199                 owners[i] = newOwner;
1200                 break;
1201             }
1202         }
1203         isOwner[owner] = false;
1204         isOwner[newOwner] = true;
1205         OwnerRemoval(owner);
1206         OwnerAddition(newOwner);
1207     }
1208 
1209     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1210     /// @param _required Number of required confirmations.
1211     function changeRequirement(uint _required)
1212         public
1213         onlyWallet
1214         validRequirement(owners.length, _required)
1215     {
1216         required = _required;
1217         RequirementChange(_required);
1218     }
1219 
1220     /// @dev Allows an owner to submit and confirm a transaction.
1221     /// @param destination Transaction target address.
1222     /// @param value Transaction ether value.
1223     /// @param data Transaction data payload.
1224     /// @return Returns transaction ID.
1225     function submitTransaction(address destination, uint value, bytes data)
1226         public
1227         returns (uint transactionId)
1228     {
1229         transactionId = addTransaction(destination, value, data);
1230         confirmTransaction(transactionId);
1231     }
1232 
1233     /// @dev Allows an owner to confirm a transaction.
1234     /// @param transactionId Transaction ID.
1235     function confirmTransaction(uint transactionId)
1236         public
1237         ownerExists(msg.sender)
1238         transactionExists(transactionId)
1239         notConfirmed(transactionId, msg.sender)
1240     {
1241         confirmations[transactionId][msg.sender] = true;
1242         Confirmation(msg.sender, transactionId);
1243         executeTransaction(transactionId);
1244     }
1245 
1246     /// @dev Allows an owner to revoke a confirmation for a transaction.
1247     /// @param transactionId Transaction ID.
1248     function revokeConfirmation(uint transactionId)
1249         public
1250         ownerExists(msg.sender)
1251         confirmed(transactionId, msg.sender)
1252         notExecuted(transactionId)
1253     {
1254         confirmations[transactionId][msg.sender] = false;
1255         Revocation(msg.sender, transactionId);
1256     }
1257 
1258     /// @dev Allows anyone to execute a confirmed transaction.
1259     /// @param transactionId Transaction ID.
1260     function executeTransaction(uint transactionId)
1261         public
1262         notExecuted(transactionId)
1263     {
1264         if (isConfirmed(transactionId)) {
1265             // Transaction tx = transactions[transactionId];
1266             transactions[transactionId].executed = true;
1267             // tx.executed = true;
1268             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1269                 Execution(transactionId);
1270             } else {
1271                 ExecutionFailure(transactionId);
1272                 transactions[transactionId].executed = false;
1273             }
1274         }
1275     }
1276 
1277     /// @dev Returns the confirmation status of a transaction.
1278     /// @param transactionId Transaction ID.
1279     /// @return Confirmation status.
1280     function isConfirmed(uint transactionId)
1281         public
1282         constant
1283         returns (bool)
1284     {
1285         uint count = 0;
1286         for (uint i = 0; i < owners.length; i++) {
1287             if (confirmations[transactionId][owners[i]])
1288                 count += 1;
1289             if (count == required)
1290                 return true;
1291         }
1292     }
1293 
1294     /*
1295      * Internal functions
1296      */
1297     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1298     /// @param destination Transaction target address.
1299     /// @param value Transaction ether value.
1300     /// @param data Transaction data payload.
1301     /// @return Returns transaction ID.
1302     function addTransaction(address destination, uint value, bytes data)
1303         internal
1304         notNull(destination)
1305         returns (uint transactionId)
1306     {
1307         transactionId = transactionCount;
1308         transactions[transactionId] = Transaction({
1309             destination: destination, 
1310             value: value,
1311             data: data,
1312             executed: false
1313         });
1314         transactionCount += 1;
1315         Submission(transactionId);
1316     }
1317 
1318     /*
1319      * Web3 call functions
1320      */
1321     /// @dev Returns number of confirmations of a transaction.
1322     /// @param transactionId Transaction ID.
1323     /// @return Number of confirmations.
1324     function getConfirmationCount(uint transactionId)
1325         public
1326         constant
1327         returns (uint count)
1328     {
1329         for (uint i = 0; i < owners.length; i++) {
1330             if (confirmations[transactionId][owners[i]])
1331                 count += 1;
1332         }
1333     }
1334 
1335     /// @dev Returns total number of transactions after filers are applied.
1336     /// @param pending Include pending transactions.
1337     /// @param executed Include executed transactions.
1338     /// @return Total number of transactions after filters are applied.
1339     function getTransactionCount(bool pending, bool executed)
1340         public
1341         constant
1342         returns (uint count)
1343     {
1344         for (uint i = 0; i < transactionCount; i++) {
1345             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1346                 count += 1;
1347         }
1348     }
1349 
1350     /// @dev Returns list of owners.
1351     /// @return List of owner addresses.
1352     function getOwners()
1353         public
1354         constant
1355         returns (address[])
1356     {
1357         return owners;
1358     }
1359 
1360     /// @dev Returns array with owner addresses, which confirmed transaction.
1361     /// @param transactionId Transaction ID.
1362     /// @return Returns array of owner addresses.
1363     function getConfirmations(uint transactionId)
1364         public
1365         constant
1366         returns (address[] _confirmations)
1367     {
1368         address[] memory confirmationsTemp = new address[](owners.length);
1369         uint count = 0;
1370         uint i;
1371         for (i = 0; i < owners.length; i++) {
1372             if (confirmations[transactionId][owners[i]]) {
1373                 confirmationsTemp[count] = owners[i];
1374                 count += 1;
1375             }
1376         }
1377         _confirmations = new address[](count);
1378         for (i = 0; i < count; i++) {
1379             _confirmations[i] = confirmationsTemp[i];
1380         }
1381     }
1382 
1383     /// @dev Returns list of transaction IDs in defined range.
1384     /// @param from Index start position of transaction array.
1385     /// @param to Index end position of transaction array.
1386     /// @param pending Include pending transactions.
1387     /// @param executed Include executed transactions.
1388     /// @return Returns array of transaction IDs.
1389     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1390         public
1391         constant
1392         returns (uint[] _transactionIds)
1393     {
1394         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1395         uint count = 0;
1396         uint i;
1397         for (i = 0; i < transactionCount; i++) {
1398             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1399                 transactionIdsTemp[count] = i;
1400                 count += 1;
1401             }
1402         }
1403         _transactionIds = new uint[](to - from);
1404         for (i = from; i < to; i++) {
1405             _transactionIds[i - from] = transactionIdsTemp[i];
1406         }
1407     }
1408 }