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
60         // 
61         balanceOf[_escrow] += 100000000000000000000000000; // 100 million NAC
62         totalSupply += 100000000000000000000000000;
63     }
64 
65 
66     /*/
67      *  Constants
68     /*/
69 
70     string public name = "Nami Token";
71     string public  symbol = "NAC";
72     uint   public decimals = 18;
73 
74     bool public TRANSFERABLE = false; // default not transferable
75 
76     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
77     
78     uint public binary = 0;
79 
80     /*/
81      *  Token state
82     /*/
83 
84     enum Phase {
85         Created,
86         Running,
87         Paused,
88         Migrating,
89         Migrated
90     }
91 
92     Phase public currentPhase = Phase.Created;
93     uint public totalSupply = 0; // amount of tokens already sold
94 
95     // escrow has exclusive priveleges to call administrative
96     // functions on this contract.
97     address public escrow;
98 
99     // Gathered funds can be withdrawn only to namimultisigwallet's address.
100     address public namiMultiSigWallet;
101 
102     // nami presale contract
103     address public namiPresale;
104 
105     // Crowdsale manager has exclusive priveleges to burn presale tokens.
106     address public crowdsaleManager;
107     
108     // binary option address
109     address public binaryAddress;
110     
111     // This creates an array with all balances
112     mapping (address => uint256) public balanceOf;
113     mapping (address => mapping (address => uint256)) public allowance;
114 
115     modifier onlyCrowdsaleManager() {
116         require(msg.sender == crowdsaleManager); 
117         _; 
118     }
119 
120     modifier onlyEscrow() {
121         require(msg.sender == escrow);
122         _;
123     }
124     
125     modifier onlyTranferable() {
126         require(TRANSFERABLE);
127         _;
128     }
129     
130     modifier onlyNamiMultisig() {
131         require(msg.sender == namiMultiSigWallet);
132         _;
133     }
134     
135     /*/
136      *  Events
137     /*/
138 
139     event LogBuy(address indexed owner, uint value);
140     event LogBurn(address indexed owner, uint value);
141     event LogPhaseSwitch(Phase newPhase);
142     // Log migrate token
143     event LogMigrate(address _from, address _to, uint256 amount);
144     // This generates a public event on the blockchain that will notify clients
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     /*/
148      *  Public functions
149     /*/
150 
151     /**
152      * Internal transfer, only can be called by this contract
153      */
154     function _transfer(address _from, address _to, uint _value) internal {
155         // Prevent transfer to 0x0 address. Use burn() instead
156         require(_to != 0x0);
157         // Check if the sender has enough
158         require(balanceOf[_from] >= _value);
159         // Check for overflows
160         require(balanceOf[_to] + _value > balanceOf[_to]);
161         // Save this for an assertion in the future
162         uint previousBalances = balanceOf[_from] + balanceOf[_to];
163         // Subtract from the sender
164         balanceOf[_from] -= _value;
165         // Add the same to the recipient
166         balanceOf[_to] += _value;
167         Transfer(_from, _to, _value);
168         // Asserts are used to use static analysis to find bugs in your code. They should never fail
169         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
170     }
171 
172     // Transfer the balance from owner's account to another account
173     // only escrow can send token (to send token private sale)
174     function transferForTeam(address _to, uint256 _value) public
175         onlyEscrow
176     {
177         _transfer(msg.sender, _to, _value);
178     }
179     
180     /**
181      * Transfer tokens
182      *
183      * Send `_value` tokens to `_to` from your account
184      *
185      * @param _to The address of the recipient
186      * @param _value the amount to send
187      */
188     function transfer(address _to, uint256 _value) public
189         onlyTranferable
190     {
191         _transfer(msg.sender, _to, _value);
192     }
193     
194        /**
195      * Transfer tokens from other address
196      *
197      * Send `_value` tokens to `_to` in behalf of `_from`
198      *
199      * @param _from The address of the sender
200      * @param _to The address of the recipient
201      * @param _value the amount to send
202      */
203     function transferFrom(address _from, address _to, uint256 _value) 
204         public
205         onlyTranferable
206         returns (bool success)
207     {
208         require(_value <= allowance[_from][msg.sender]);     // Check allowance
209         allowance[_from][msg.sender] -= _value;
210         _transfer(_from, _to, _value);
211         return true;
212     }
213 
214     /**
215      * Set allowance for other address
216      *
217      * Allows `_spender` to spend no more than `_value` tokens in your behalf
218      *
219      * @param _spender The address authorized to spend
220      * @param _value the max amount they can spend
221      */
222     function approve(address _spender, uint256 _value) public
223         onlyTranferable
224         returns (bool success) 
225     {
226         allowance[msg.sender][_spender] = _value;
227         return true;
228     }
229 
230     /**
231      * Set allowance for other address and notify
232      *
233      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
234      *
235      * @param _spender The address authorized to spend
236      * @param _value the max amount they can spend
237      * @param _extraData some extra information to send to the approved contract
238      */
239     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
240         public
241         onlyTranferable
242         returns (bool success) 
243     {
244         tokenRecipient spender = tokenRecipient(_spender);
245         if (approve(_spender, _value)) {
246             spender.receiveApproval(msg.sender, _value, this, _extraData);
247             return true;
248         }
249     }
250 
251     // allows transfer token
252     function changeTransferable () public
253         onlyEscrow
254     {
255         TRANSFERABLE = !TRANSFERABLE;
256     }
257     
258     // change escrow
259     function changeEscrow(address _escrow) public
260         onlyNamiMultisig
261     {
262         require(_escrow != 0x0);
263         escrow = _escrow;
264     }
265     
266     // change binary value
267     function changeBinary(uint _binary)
268         public
269         onlyEscrow
270     {
271         binary = _binary;
272     }
273     
274     // change binary address
275     function changeBinaryAddress(address _binaryAddress)
276         public
277         onlyEscrow
278     {
279         require(_binaryAddress != 0x0);
280         binaryAddress = _binaryAddress;
281     }
282     
283     /*
284     * price in ICO:
285     * first week: 1 ETH = 2400 NAC
286     * second week: 1 ETH = 23000 NAC
287     * 3rd week: 1 ETH = 2200 NAC
288     * 4th week: 1 ETH = 2100 NAC
289     * 5th week: 1 ETH = 2000 NAC
290     * 6th week: 1 ETH = 1900 NAC
291     * 7th week: 1 ETH = 1800 NAC
292     * 8th week: 1 ETH = 1700 nac
293     * time: 
294     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
295     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
296     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
297     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
298     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
299     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
300     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
301     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
302     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
303     */
304     function getPrice() public view returns (uint price) {
305         if (now < 1517443200) {
306             // presale
307             return 3450;
308         } else if (1517443200 < now && now <= 1518048000) {
309             // 1st week
310             return 2400;
311         } else if (1518048000 < now && now <= 1518652800) {
312             // 2nd week
313             return 2300;
314         } else if (1518652800 < now && now <= 1519257600) {
315             // 3rd week
316             return 2200;
317         } else if (1519257600 < now && now <= 1519862400) {
318             // 4th week
319             return 2100;
320         } else if (1519862400 < now && now <= 1520467200) {
321             // 5th week
322             return 2000;
323         } else if (1520467200 < now && now <= 1521072000) {
324             // 6th week
325             return 1900;
326         } else if (1521072000 < now && now <= 1521676800) {
327             // 7th week
328             return 1800;
329         } else if (1521676800 < now && now <= 1522281600) {
330             // 8th week
331             return 1700;
332         } else {
333             return binary;
334         }
335     }
336 
337 
338     function() payable public {
339         buy(msg.sender);
340     }
341     
342     
343     function buy(address _buyer) payable public {
344         // Available only if presale is running.
345         require(currentPhase == Phase.Running);
346         // require ICO time or binary option
347         require(now <= 1519862400 || msg.sender == binaryAddress);
348         require(msg.value != 0);
349         uint newTokens = msg.value * getPrice();
350         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
351         // add new token to buyer
352         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
353         // add new token to totalSupply
354         totalSupply = totalSupply.add(newTokens);
355         LogBuy(_buyer, newTokens);
356     }
357     
358 
359     /// @dev Returns number of tokens owned by given address.
360     /// @param _owner Address of token owner.
361     function burnTokens(address _owner) public
362         onlyCrowdsaleManager
363     {
364         // Available only during migration phase
365         require(currentPhase == Phase.Migrating);
366 
367         uint tokens = balanceOf[_owner];
368         require(tokens != 0);
369         balanceOf[_owner] = 0;
370         totalSupply -= tokens;
371         LogBurn(_owner, tokens);
372 
373         // Automatically switch phase when migration is done.
374         if (totalSupply == 0) {
375             currentPhase = Phase.Migrated;
376             LogPhaseSwitch(Phase.Migrated);
377         }
378     }
379 
380 
381     /*/
382      *  Administrative functions
383     /*/
384     function setPresalePhase(Phase _nextPhase) public
385         onlyEscrow
386     {
387         bool canSwitchPhase
388             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
389             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
390                 // switch to migration phase only if crowdsale manager is set
391             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
392                 && _nextPhase == Phase.Migrating
393                 && crowdsaleManager != 0x0)
394             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
395                 // switch to migrated only if everyting is migrated
396             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
397                 && totalSupply == 0);
398 
399         require(canSwitchPhase);
400         currentPhase = _nextPhase;
401         LogPhaseSwitch(_nextPhase);
402     }
403 
404 
405     function withdrawEther(uint _amount) public
406         onlyEscrow
407     {
408         require(namiMultiSigWallet != 0x0);
409         // Available at any phase.
410         if (this.balance > 0) {
411             namiMultiSigWallet.transfer(_amount);
412         }
413     }
414     
415     function safeWithdraw(address _withdraw, uint _amount) public
416         onlyEscrow
417     {
418         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
419         if (namiWallet.isOwner(_withdraw)) {
420             _withdraw.transfer(_amount);
421         }
422     }
423 
424 
425     function setCrowdsaleManager(address _mgr) public
426         onlyEscrow
427     {
428         // You can't change crowdsale contract when migration is in progress.
429         require(currentPhase != Phase.Migrating);
430         crowdsaleManager = _mgr;
431     }
432 
433     // internal migrate migration tokens
434     function _migrateToken(address _from, address _to)
435         internal
436     {
437         PresaleToken presale = PresaleToken(namiPresale);
438         uint256 newToken = presale.balanceOf(_from);
439         require(newToken > 0);
440         // burn old token
441         presale.burnTokens(_from);
442         // add new token to _to
443         balanceOf[_to] = balanceOf[_to].add(newToken);
444         // add new token to totalSupply
445         totalSupply = totalSupply.add(newToken);
446         LogMigrate(_from, _to, newToken);
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
489         if (codeLength > 0) {
490             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
491             receiver.tokenFallbackExchange(msg.sender, _value, _price);
492             TransferToExchange(msg.sender, _to, _value, _price);
493         }
494     }
495     
496     /**
497      * @dev Transfer the specified amount of tokens to the specified address.
498      *      Invokes the `tokenFallback` function if the recipient is a contract.
499      *      The token transfer fails if the recipient is a contract
500      *      but does not implement the `tokenFallback` function
501      *      or the fallback function to receive funds.
502      *
503      * @param _to    Receiver address.
504      * @param _value Amount of tokens that will be transferred.
505      * @param _buyer address of seller.
506      */
507      
508     function transferToBuyer(address _to, uint _value, address _buyer) public {
509         uint codeLength;
510         
511         assembly {
512             codeLength := extcodesize(_to)
513         }
514         
515         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
516         balanceOf[_to] = balanceOf[_to].add(_value);
517         if (codeLength > 0) {
518             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
519             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
520             TransferToBuyer(msg.sender, _to, _value, _buyer);
521         }
522     }
523 //-------------------------------------------------------------------------------------------------------
524 }
525 
526 
527 /*
528 * Binary option smart contract-------------------------------
529 */
530 contract BinaryOption {
531     /*
532      * binary option controled by escrow to buy NAC with good price
533      */
534     // NamiCrowdSale address
535     address public namiCrowdSaleAddr;
536     address public escrow;
537     
538     // namiMultiSigWallet
539     address public namiMultiSigWallet;
540     
541     Session public session;
542     uint public timeInvestInMinute = 30;
543     uint public timeOneSession = 180;
544     uint public sessionId = 1;
545     uint public rate = 150;
546     uint public constant MAX_INVESTOR = 20;
547     /**
548      * Events for binany option system
549      */
550     event SessionOpen(uint timeOpen, uint indexed sessionId);
551     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
552     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
553     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rate);
554 
555     event Deposit(address indexed sender, uint value);
556     /// @dev Fallback function allows to deposit ether.
557     function() public payable {
558         if (msg.value > 0)
559             Deposit(msg.sender, msg.value);
560     }
561     // there is only one session available at one timeOpen
562     // priceOpen is price of ETH in USD
563     // priceClose is price of ETH in USD
564     // process of one Session
565     // 1st: escrow reset session by run resetSession()
566     // 2nd: escrow open session by run openSession() => save timeOpen at this time
567     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
568     // 4th: escrow close invest and insert price open for this Session
569     // 5th: escrow close session and send NAC for investor
570     struct Session {
571         uint priceOpen;
572         uint priceClose;
573         uint timeOpen;
574         bool isReset;
575         bool isOpen;
576         bool investOpen;
577         uint investorCount;
578         mapping(uint => address) investor;
579         mapping(uint => bool) win;
580         mapping(uint => uint) amountInvest;
581         mapping(address=> uint) investedSession;
582     }
583     
584     function BinaryOption(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
585         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
586         namiCrowdSaleAddr = _namiCrowdSale;
587         escrow = _escrow;
588         namiMultiSigWallet = _namiMultiSigWallet;
589     }
590     
591     
592     modifier onlyEscrow() {
593         require(msg.sender==escrow);
594         _;
595     }
596     
597         
598     modifier onlyNamiMultisig() {
599         require(msg.sender == namiMultiSigWallet);
600         _;
601     }
602     
603     // change escrow
604     function changeEscrow(address _escrow) public
605         onlyNamiMultisig
606     {
607         require(_escrow != 0x0);
608         escrow = _escrow;
609     }
610     
611     /// @dev Change time for investor can invest in one session, can only change at time not in session
612     /// @param _timeInvest time invest in minutes
613     function changeTimeInvest(uint _timeInvest)
614         public
615         onlyEscrow
616     {
617         require(!session.isOpen && _timeInvest < timeOneSession);
618         timeInvestInMinute = _timeInvest;
619     }
620     
621     // 100 < _rate < 200
622     // price of NAC for investor win = _rate/100
623     // price of NAC for investor loss = 2 - _rate/100
624     function changeRate(uint _rate)
625         public
626         onlyEscrow
627     {
628         require(100 < _rate && _rate < 200 && !session.isOpen);
629         rate = _rate;
630     }
631     
632     function changeTimeOneSession(uint _timeOneSession) 
633         public
634         onlyEscrow
635     {
636         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
637         timeOneSession = _timeOneSession;
638     }
639     
640     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
641     /// @param _amount value ether in wei to withdraw
642     function withdrawEther(uint _amount) public
643         onlyEscrow
644     {
645         require(namiMultiSigWallet != 0x0);
646         // Available at any phase.
647         if (this.balance > 0) {
648             namiMultiSigWallet.transfer(_amount);
649         }
650     }
651     
652     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
653     /// @param _withdraw address to withdraw
654     function safeWithdraw(address _withdraw, uint _amount) public
655         onlyEscrow
656     {
657         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
658         if (namiWallet.isOwner(_withdraw)) {
659             _withdraw.transfer(_amount);
660         }
661     }
662     
663     // @dev Returns list of owners.
664     // @return List of owner addresses.
665     // MAX_INVESTOR = 20
666     function getInvestors()
667         public
668         view
669         returns (address[20])
670     {
671         address[20] memory listInvestor;
672         for (uint i = 0; i < MAX_INVESTOR; i++) {
673             listInvestor[i] = session.investor[i];
674         }
675         return listInvestor;
676     }
677     
678     function getChooses()
679         public
680         view
681         returns (bool[20])
682     {
683         bool[20] memory listChooses;
684         for (uint i = 0; i < MAX_INVESTOR; i++) {
685             listChooses[i] = session.win[i];
686         }
687         return listChooses;
688     }
689     
690     function getAmount()
691         public
692         view
693         returns (uint[20])
694     {
695         uint[20] memory listAmount;
696         for (uint i = 0; i < MAX_INVESTOR; i++) {
697             listAmount[i] = session.amountInvest[i];
698         }
699         return listAmount;
700     }
701     
702     /// @dev reset all data of previous session, must run before open new session
703     // only escrow can call
704     function resetSession()
705         public
706         onlyEscrow
707     {
708         require(!session.isReset && !session.isOpen);
709         session.priceOpen = 0;
710         session.priceClose = 0;
711         session.isReset = true;
712         session.isOpen = false;
713         session.investOpen = false;
714         session.investorCount = 0;
715         for (uint i = 0; i < MAX_INVESTOR; i++) {
716             session.investor[i] = 0x0;
717             session.win[i] = false;
718             session.amountInvest[i] = 0;
719         }
720     }
721     
722     /// @dev Open new session, only escrow can call
723     function openSession ()
724         public
725         onlyEscrow
726     {
727         require(session.isReset && !session.isOpen);
728         session.isReset = false;
729         // open invest
730         session.investOpen = true;
731         session.timeOpen = now;
732         session.isOpen = true;
733         SessionOpen(now, sessionId);
734     }
735     
736     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
737     /// @param _choose choise of investor, true is call, false is put
738     function invest (bool _choose)
739         public
740         payable
741     {
742         require(msg.value >= 100000000000000000 && session.investOpen); // msg.value >= 0.1 ether
743         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
744         require(session.investorCount < MAX_INVESTOR && session.investedSession[msg.sender] != sessionId);
745         session.investor[session.investorCount] = msg.sender;
746         session.win[session.investorCount] = _choose;
747         session.amountInvest[session.investorCount] = msg.value;
748         session.investorCount += 1;
749         session.investedSession[msg.sender] = sessionId;
750         Invest(msg.sender, _choose, msg.value, now, sessionId);
751     }
752     
753     /// @dev close invest for escrow
754     /// @param _priceOpen price ETH in USD
755     function closeInvest (uint _priceOpen) 
756         public
757         onlyEscrow
758     {
759         require(_priceOpen != 0 && session.investOpen);
760         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
761         session.investOpen = false;
762         session.priceOpen = _priceOpen;
763         InvestClose(now, _priceOpen, sessionId);
764     }
765     
766     /// @dev get amount of ether to buy NAC for investor
767     /// @param _ether amount ether which investor invest
768     /// @param _rate rate between win and loss investor
769     /// @param _status true for investor win and false for investor loss
770     function getEtherToBuy (uint _ether, uint _rate, bool _status)
771         public
772         pure
773         returns (uint)
774     {
775         if (_status) {
776             return _ether * _rate / 100;
777         } else {
778             return _ether * (200 - _rate) / 100;
779         }
780     }
781 
782     /// @dev close session, only escrow can call
783     /// @param _priceClose price of ETH in USD
784     function closeSession (uint _priceClose)
785         public
786         onlyEscrow
787     {
788         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
789         require(!session.investOpen && session.isOpen);
790         session.priceClose = _priceClose;
791         bool result = (_priceClose>session.priceOpen)?true:false;
792         uint etherToBuy;
793         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
794         uint price = namiContract.getPrice();
795         for (uint i = 0; i < session.investorCount; i++) {
796             if (session.win[i]==result) {
797                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, true);
798             } else {
799                 etherToBuy = getEtherToBuy(session.amountInvest[i], rate, false);
800             }
801             namiContract.buy.value(etherToBuy)(session.investor[i]);
802             // reset investor
803             session.investor[i] = 0x0;
804             session.win[i] = false;
805             session.amountInvest[i] = 0;
806         }
807         session.isOpen = false;
808         SessionClose(now, sessionId, _priceClose, price, rate);
809         sessionId += 1;
810         
811         // require(!session.isReset && !session.isOpen);
812         // reset state session
813         session.priceOpen = 0;
814         session.priceClose = 0;
815         session.isReset = true;
816         session.investOpen = false;
817         session.investorCount = 0;
818     }
819 }
820 
821 
822 contract PresaleToken {
823     mapping (address => uint256) public balanceOf;
824     function burnTokens(address _owner) public;
825 }
826 
827  /*
828  * Contract that is working with ERC223 tokens
829  */
830  
831  /**
832  * @title Contract that will work with ERC223 tokens.
833  */
834  
835 contract ERC223ReceivingContract {
836 /**
837  * @dev Standard ERC223 function that will handle incoming token transfers.
838  *
839  * @param _from  Token sender address.
840  * @param _value Amount of tokens.
841  * @param _data  Transaction metadata.
842  */
843     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
844     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
845     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
846 }
847 
848 
849  /*
850  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
851  *
852  */
853 
854 contract NamiExchange {
855     using SafeMath for uint;
856     
857     function NamiExchange(address _namiAddress) public {
858         NamiAddr = _namiAddress;
859     }
860 
861     event UpdateBid(address owner, uint price, uint balance);
862     event UpdateAsk(address owner, uint price, uint volume);
863 
864     
865     mapping(address => OrderBid) public bid;
866     mapping(address => OrderAsk) public ask;
867     string public name = "NacExchange";
868     
869     /// address of Nami token
870     address NamiAddr;
871     
872     /// price of Nac = ETH/NAC
873     uint public price = 1;
874     uint public etherBalance=0;
875     uint public nacBalance=0;
876     // struct store order of user
877     struct OrderBid {
878         uint price;
879         uint eth;
880     }
881     
882     struct OrderAsk {
883         uint price;
884         uint volume;
885     }
886     
887         
888     // prevent lost ether
889     function() payable public {
890         require(msg.value > 0);
891         if (bid[msg.sender].price > 0) {
892             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
893             etherBalance = etherBalance.add(msg.value);
894             UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
895         } else {
896             // refund
897             msg.sender.transfer(msg.value);
898         }
899         // test
900         // address test = "0x70c932369fc1C76fde684FF05966A70b9c1561c1";
901         // test.transfer(msg.value);
902     }
903 
904     // prevent lost token
905     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success) {
906         require(_value > 0 && _data.length == 0);
907         if (ask[_from].price > 0) {
908             ask[_from].volume = (ask[_from].volume).add(_value);
909             nacBalance = nacBalance.add(_value);
910             UpdateAsk(_from, ask[_from].price, ask[_from].volume);
911             return true;
912         } else {
913             //refund
914             ERC23 asset = ERC23(NamiAddr);
915             asset.transfer(_from, _value);
916             return false;
917         }
918     }
919     
920     modifier onlyNami {
921         require(msg.sender == NamiAddr);
922         _;
923     }
924     
925     
926     /////////////////
927     // function about bid Order-----------------------------------------------------------
928     
929     function placeBuyOrder(uint _price) payable public {
930         require(_price > 0);
931         if (msg.value > 0) {
932             etherBalance += msg.value;
933             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
934             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
935         }
936         bid[msg.sender].price = _price;
937     }
938     
939     function tokenFallbackBuyer(address _from, uint _value, address _buyer) onlyNami public returns (bool success) {
940         ERC23 asset = ERC23(NamiAddr);
941         uint currentEth = bid[_buyer].eth;
942         if ((_value.div(bid[_buyer].price)) > currentEth) {
943             if (_from.send(currentEth) && asset.transfer(_buyer, currentEth.mul(bid[_buyer].price)) && asset.transfer(_from, _value - (currentEth.mul(bid[_buyer].price) ) ) ) {
944                 bid[_buyer].eth = 0;
945                 etherBalance = etherBalance.sub(currentEth);
946                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
947                 return true;
948             } else {
949                 // refund token
950                 asset.transfer(_from, _value);
951                 return false;
952             }
953         } else {
954             uint eth = _value.div(bid[_buyer].price);
955             if (_from.send(eth) && asset.transfer(_buyer, _value)) {
956                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
957                 etherBalance = etherBalance.sub(eth);
958                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
959                 return true;
960             } else {
961                 // refund token
962                 asset.transfer(_from, _value);
963                 return false;
964             }
965         }
966     }
967     
968     function closeBidOrder() public {
969         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
970         msg.sender.transfer(bid[msg.sender].eth);
971         etherBalance = etherBalance.sub(bid[msg.sender].eth);
972         bid[msg.sender].eth = 0;
973         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
974     }
975     
976 
977     ////////////////
978     // function about ask Order-----------------------------------------------------------
979     // place ask order by send NAC to contract
980     
981     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
982         require(_price > 0);
983         if (_value > 0) {
984             nacBalance = nacBalance.add(_value);
985             ask[_from].volume = (ask[_from].volume).add(_value);
986             ask[_from].price = _price;
987             UpdateAsk(_from, _price, ask[_from].volume);
988             return true;
989         } else {
990             ask[_from].price = _price;
991             return false;
992         }
993     }
994     
995     function closeAskOrder() public {
996         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
997         ERC23 asset = ERC23(NamiAddr);
998         if (asset.transfer(msg.sender, ask[msg.sender].volume)) {
999             nacBalance = nacBalance.sub(ask[msg.sender].volume);
1000             ask[msg.sender].volume = 0;
1001             UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1002         }
1003     }
1004     
1005     function buyNac(address _seller) payable public returns (bool success) {
1006         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1007         ERC23 asset = ERC23(NamiAddr);
1008         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1009         if (msg.value > maxEth) {
1010             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth)) && asset.transfer(msg.sender, ask[_seller].volume)) {
1011                 nacBalance = nacBalance.sub(ask[_seller].volume);
1012                 ask[_seller].volume = 0;
1013                 UpdateAsk(_seller, ask[_seller].price, 0);
1014                 return true;
1015             } else {
1016                 //refund
1017                 return false;
1018             }
1019         } else {
1020             if (_seller.send(msg.value) && asset.transfer(msg.sender, (msg.value).mul(ask[_seller].price))) {
1021                 uint nac = (msg.value).mul(ask[_seller].price);
1022                 nacBalance = nacBalance.sub(nac);
1023                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1024                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1025                 return true;
1026             } else {
1027                 //refund
1028                 return false;
1029             }
1030         }
1031     }
1032 }
1033 
1034 contract ERC23 {
1035   function balanceOf(address who) public constant returns (uint);
1036   function transfer(address to, uint value) public returns (bool success);
1037 }
1038 
1039 
1040 
1041 /*
1042 * NamiMultiSigWallet smart contract-------------------------------
1043 */
1044 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1045 contract NamiMultiSigWallet {
1046 
1047     uint constant public MAX_OWNER_COUNT = 50;
1048 
1049     event Confirmation(address indexed sender, uint indexed transactionId);
1050     event Revocation(address indexed sender, uint indexed transactionId);
1051     event Submission(uint indexed transactionId);
1052     event Execution(uint indexed transactionId);
1053     event ExecutionFailure(uint indexed transactionId);
1054     event Deposit(address indexed sender, uint value);
1055     event OwnerAddition(address indexed owner);
1056     event OwnerRemoval(address indexed owner);
1057     event RequirementChange(uint required);
1058 
1059     mapping (uint => Transaction) public transactions;
1060     mapping (uint => mapping (address => bool)) public confirmations;
1061     mapping (address => bool) public isOwner;
1062     address[] public owners;
1063     uint public required;
1064     uint public transactionCount;
1065 
1066     struct Transaction {
1067         address destination;
1068         uint value;
1069         bytes data;
1070         bool executed;
1071     }
1072 
1073     modifier onlyWallet() {
1074         require(msg.sender == address(this));
1075         _;
1076     }
1077 
1078     modifier ownerDoesNotExist(address owner) {
1079         require(!isOwner[owner]);
1080         _;
1081     }
1082 
1083     modifier ownerExists(address owner) {
1084         require(isOwner[owner]);
1085         _;
1086     }
1087 
1088     modifier transactionExists(uint transactionId) {
1089         require(transactions[transactionId].destination != 0);
1090         _;
1091     }
1092 
1093     modifier confirmed(uint transactionId, address owner) {
1094         require(confirmations[transactionId][owner]);
1095         _;
1096     }
1097 
1098     modifier notConfirmed(uint transactionId, address owner) {
1099         require(!confirmations[transactionId][owner]);
1100         _;
1101     }
1102 
1103     modifier notExecuted(uint transactionId) {
1104         require(!transactions[transactionId].executed);
1105         _;
1106     }
1107 
1108     modifier notNull(address _address) {
1109         require(_address != 0);
1110         _;
1111     }
1112 
1113     modifier validRequirement(uint ownerCount, uint _required) {
1114         require(!(ownerCount > MAX_OWNER_COUNT
1115             || _required > ownerCount
1116             || _required == 0
1117             || ownerCount == 0));
1118         _;
1119     }
1120 
1121     /// @dev Fallback function allows to deposit ether.
1122     function() public payable {
1123         if (msg.value > 0)
1124             Deposit(msg.sender, msg.value);
1125     }
1126 
1127     /*
1128      * Public functions
1129      */
1130     /// @dev Contract constructor sets initial owners and required number of confirmations.
1131     /// @param _owners List of initial owners.
1132     /// @param _required Number of required confirmations.
1133     function NamiMultiSigWallet(address[] _owners, uint _required)
1134         public
1135         validRequirement(_owners.length, _required)
1136     {
1137         for (uint i = 0; i < _owners.length; i++) {
1138             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1139             isOwner[_owners[i]] = true;
1140         }
1141         owners = _owners;
1142         required = _required;
1143     }
1144 
1145     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1146     /// @param owner Address of new owner.
1147     function addOwner(address owner)
1148         public
1149         onlyWallet
1150         ownerDoesNotExist(owner)
1151         notNull(owner)
1152         validRequirement(owners.length + 1, required)
1153     {
1154         isOwner[owner] = true;
1155         owners.push(owner);
1156         OwnerAddition(owner);
1157     }
1158 
1159     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1160     /// @param owner Address of owner.
1161     function removeOwner(address owner)
1162         public
1163         onlyWallet
1164         ownerExists(owner)
1165     {
1166         isOwner[owner] = false;
1167         for (uint i=0; i<owners.length - 1; i++) {
1168             if (owners[i] == owner) {
1169                 owners[i] = owners[owners.length - 1];
1170                 break;
1171             }
1172         }
1173         owners.length -= 1;
1174         if (required > owners.length)
1175             changeRequirement(owners.length);
1176         OwnerRemoval(owner);
1177     }
1178 
1179     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1180     /// @param owner Address of owner to be replaced.
1181     /// @param owner Address of new owner.
1182     function replaceOwner(address owner, address newOwner)
1183         public
1184         onlyWallet
1185         ownerExists(owner)
1186         ownerDoesNotExist(newOwner)
1187     {
1188         for (uint i=0; i<owners.length; i++) {
1189             if (owners[i] == owner) {
1190                 owners[i] = newOwner;
1191                 break;
1192             }
1193         }
1194         isOwner[owner] = false;
1195         isOwner[newOwner] = true;
1196         OwnerRemoval(owner);
1197         OwnerAddition(newOwner);
1198     }
1199 
1200     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1201     /// @param _required Number of required confirmations.
1202     function changeRequirement(uint _required)
1203         public
1204         onlyWallet
1205         validRequirement(owners.length, _required)
1206     {
1207         required = _required;
1208         RequirementChange(_required);
1209     }
1210 
1211     /// @dev Allows an owner to submit and confirm a transaction.
1212     /// @param destination Transaction target address.
1213     /// @param value Transaction ether value.
1214     /// @param data Transaction data payload.
1215     /// @return Returns transaction ID.
1216     function submitTransaction(address destination, uint value, bytes data)
1217         public
1218         returns (uint transactionId)
1219     {
1220         transactionId = addTransaction(destination, value, data);
1221         confirmTransaction(transactionId);
1222     }
1223 
1224     /// @dev Allows an owner to confirm a transaction.
1225     /// @param transactionId Transaction ID.
1226     function confirmTransaction(uint transactionId)
1227         public
1228         ownerExists(msg.sender)
1229         transactionExists(transactionId)
1230         notConfirmed(transactionId, msg.sender)
1231     {
1232         confirmations[transactionId][msg.sender] = true;
1233         Confirmation(msg.sender, transactionId);
1234         executeTransaction(transactionId);
1235     }
1236 
1237     /// @dev Allows an owner to revoke a confirmation for a transaction.
1238     /// @param transactionId Transaction ID.
1239     function revokeConfirmation(uint transactionId)
1240         public
1241         ownerExists(msg.sender)
1242         confirmed(transactionId, msg.sender)
1243         notExecuted(transactionId)
1244     {
1245         confirmations[transactionId][msg.sender] = false;
1246         Revocation(msg.sender, transactionId);
1247     }
1248 
1249     /// @dev Allows anyone to execute a confirmed transaction.
1250     /// @param transactionId Transaction ID.
1251     function executeTransaction(uint transactionId)
1252         public
1253         notExecuted(transactionId)
1254     {
1255         if (isConfirmed(transactionId)) {
1256             // Transaction tx = transactions[transactionId];
1257             transactions[transactionId].executed = true;
1258             // tx.executed = true;
1259             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1260                 Execution(transactionId);
1261             } else {
1262                 ExecutionFailure(transactionId);
1263                 transactions[transactionId].executed = false;
1264             }
1265         }
1266     }
1267 
1268     /// @dev Returns the confirmation status of a transaction.
1269     /// @param transactionId Transaction ID.
1270     /// @return Confirmation status.
1271     function isConfirmed(uint transactionId)
1272         public
1273         constant
1274         returns (bool)
1275     {
1276         uint count = 0;
1277         for (uint i = 0; i < owners.length; i++) {
1278             if (confirmations[transactionId][owners[i]])
1279                 count += 1;
1280             if (count == required)
1281                 return true;
1282         }
1283     }
1284 
1285     /*
1286      * Internal functions
1287      */
1288     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1289     /// @param destination Transaction target address.
1290     /// @param value Transaction ether value.
1291     /// @param data Transaction data payload.
1292     /// @return Returns transaction ID.
1293     function addTransaction(address destination, uint value, bytes data)
1294         internal
1295         notNull(destination)
1296         returns (uint transactionId)
1297     {
1298         transactionId = transactionCount;
1299         transactions[transactionId] = Transaction({
1300             destination: destination, 
1301             value: value,
1302             data: data,
1303             executed: false
1304         });
1305         transactionCount += 1;
1306         Submission(transactionId);
1307     }
1308 
1309     /*
1310      * Web3 call functions
1311      */
1312     /// @dev Returns number of confirmations of a transaction.
1313     /// @param transactionId Transaction ID.
1314     /// @return Number of confirmations.
1315     function getConfirmationCount(uint transactionId)
1316         public
1317         constant
1318         returns (uint count)
1319     {
1320         for (uint i = 0; i < owners.length; i++) {
1321             if (confirmations[transactionId][owners[i]])
1322                 count += 1;
1323         }
1324     }
1325 
1326     /// @dev Returns total number of transactions after filers are applied.
1327     /// @param pending Include pending transactions.
1328     /// @param executed Include executed transactions.
1329     /// @return Total number of transactions after filters are applied.
1330     function getTransactionCount(bool pending, bool executed)
1331         public
1332         constant
1333         returns (uint count)
1334     {
1335         for (uint i = 0; i < transactionCount; i++) {
1336             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1337                 count += 1;
1338         }
1339     }
1340 
1341     /// @dev Returns list of owners.
1342     /// @return List of owner addresses.
1343     function getOwners()
1344         public
1345         constant
1346         returns (address[])
1347     {
1348         return owners;
1349     }
1350 
1351     /// @dev Returns array with owner addresses, which confirmed transaction.
1352     /// @param transactionId Transaction ID.
1353     /// @return Returns array of owner addresses.
1354     function getConfirmations(uint transactionId)
1355         public
1356         constant
1357         returns (address[] _confirmations)
1358     {
1359         address[] memory confirmationsTemp = new address[](owners.length);
1360         uint count = 0;
1361         uint i;
1362         for (i = 0; i < owners.length; i++) {
1363             if (confirmations[transactionId][owners[i]]) {
1364                 confirmationsTemp[count] = owners[i];
1365                 count += 1;
1366             }
1367         }
1368         _confirmations = new address[](count);
1369         for (i = 0; i < count; i++) {
1370             _confirmations[i] = confirmationsTemp[i];
1371         }
1372     }
1373 
1374     /// @dev Returns list of transaction IDs in defined range.
1375     /// @param from Index start position of transaction array.
1376     /// @param to Index end position of transaction array.
1377     /// @param pending Include pending transactions.
1378     /// @param executed Include executed transactions.
1379     /// @return Returns array of transaction IDs.
1380     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1381         public
1382         constant
1383         returns (uint[] _transactionIds)
1384     {
1385         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1386         uint count = 0;
1387         uint i;
1388         for (i = 0; i < transactionCount; i++) {
1389             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1390                 transactionIdsTemp[count] = i;
1391                 count += 1;
1392             }
1393         }
1394         _transactionIds = new uint[](to - from);
1395         for (i = from; i < to; i++) {
1396             _transactionIds[i - from] = transactionIdsTemp[i];
1397         }
1398     }
1399 }