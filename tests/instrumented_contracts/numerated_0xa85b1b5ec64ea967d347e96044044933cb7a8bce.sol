1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     /**
19    * @dev Throws if called by any account other than the owner.
20    */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract NoboToken is Ownable {
39 
40     using SafeMath for uint256;
41 
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 totalSupply_;
46 
47     constructor() public {
48         name = "Nobotoken";
49         symbol = "NBX";
50         decimals = 18;
51         totalSupply_ = 0;
52     }
53 
54     // -----------------------------------------------------------------------
55     // ------------------------- GENERAL ERC20 -------------------------------
56     // -----------------------------------------------------------------------
57     event Transfer(
58         address indexed _from,
59         address indexed _to,
60         uint256 _value
61     );
62     event Approval(
63         address indexed _owner,
64         address indexed _spender,
65         uint256 _value
66     );
67 
68     /*
69     * @dev tracks token balances of users
70     */
71     mapping (address => uint256) balances;
72 
73     /*
74     * @dev transfer token for a specified address
75     */
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(_to != address(0));
78         require(_value <= balances[msg.sender]);
79 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /*
87     * @dev total number of tokens in existence
88     */
89     function totalSupply() public view returns (uint256) {
90         return totalSupply_;
91     }
92     /*
93     * @dev gets the balance of the specified address.
94     */
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 
100 
101     // -----------------------------------------------------------------------
102     // ------------------------- ALLOWANCE RELEATED --------------------------
103     // -----------------------------------------------------------------------
104 
105     /*
106     * @dev tracks the allowance an address has from another one
107     */
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     /*
111     * @dev transfers token from one address to another, must have allowance
112     */
113     function transferFrom(
114         address _from,
115         address _to,
116         uint256 _value
117     )
118         public
119         returns (bool success)
120     {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /*
133     * @dev gives allowance to spender, works together with transferFrom
134     */
135     function approve(
136         address _spender,
137         uint256 _value
138     )
139         public
140         returns (bool success)
141     {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /*
148     * @dev used to increase the allowance a spender has
149     */
150     function increaseApproval(
151         address _spender,
152         uint _addedValue
153     )
154         public
155         returns (bool success)
156     {
157         allowed[msg.sender][_spender] =
158             allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     /*
164     * @dev used to decrease the allowance a spender has
165     */
166     function decreaseApproval(
167         address _spender,
168         uint _subtractedValue
169     )
170         public
171         returns (bool success)
172     {
173         uint oldValue = allowed[msg.sender][_spender];
174         if (_subtractedValue > oldValue) {
175             allowed[msg.sender][_spender] = 0;
176         } else {
177             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178         }
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     /*
184     * @dev used to check what allowance a spender has from the owner
185     */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190         public
191         view
192         returns (uint256 remaining)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     // -----------------------------------------------------------------------
198     //--------------------------- MINTING RELEATED ---------------------------
199     // -----------------------------------------------------------------------
200     /*
201     * @title Mintable token
202     * @dev instead of another contract, all mintable functionality goes here
203     */
204     event Mint(
205         address indexed to,
206         uint256 amount
207     );
208     event MintFinished();
209 
210     /*
211     * @dev signifies whether or not minting process is over
212     */
213     bool public mintingFinished = false;
214 
215     modifier canMint() {
216         require(!mintingFinished);
217         _;
218     }
219 
220 
221     /*
222     * @dev minting of tokens, restricted to owner address (crowdsale)
223     */
224     function mint(
225         address _to,
226         uint256 _amount
227     )
228         public
229         onlyOwner
230         canMint
231         returns (bool success)
232     {
233         totalSupply_ = totalSupply_.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         emit Mint(_to, _amount);
236         emit Transfer(address(0), _to, _amount);
237         return true;
238     }
239 
240     /*
241     * @dev Function to stop minting new tokens.
242     */
243     function finishMinting() onlyOwner canMint public returns (bool success) {
244         mintingFinished = true;
245         emit MintFinished();
246         return true;
247     }
248 }
249 
250 contract RefundVault is Ownable {
251     using SafeMath for uint256;
252 
253     enum State { Active, Refunding, Closed }
254 
255     mapping (address => uint256) public deposited;
256     address public wallet;
257     State public state;
258 
259     event Closed();
260     event RefundsEnabled();
261     event Refunded(address indexed beneficiary, uint256 weiAmount);
262 
263     /**
264    * @param _wallet Vault address
265    */
266     constructor(address _wallet) public {
267         require(_wallet != address(0));
268         wallet = _wallet;
269         state = State.Active;
270     }
271 
272     /**
273    * @param investor Investor address
274    */
275     function deposit(address investor) onlyOwner public payable {
276         require(state == State.Active);
277         deposited[investor] = deposited[investor].add(msg.value);
278     }
279 
280     function close() onlyOwner public {
281         require(state == State.Active);
282         state = State.Closed;
283         emit Closed();
284         wallet.transfer(address(this).balance);
285     }
286 
287     function enableRefunds() onlyOwner public {
288         require(state == State.Active);
289         state = State.Refunding;
290         emit RefundsEnabled();
291     }
292 
293     /**
294    * @param investor Investor address
295    */
296     function refund(address investor) public {
297         require(state == State.Refunding);
298         uint256 depositedValue = deposited[investor];
299         deposited[investor] = 0;
300         investor.transfer(depositedValue);
301         emit Refunded(investor, depositedValue);
302     }
303 
304     function batchRefund(address[] _investors) public {
305         require(state == State.Refunding);
306         for (uint256 i = 0; i < _investors.length; i++) {
307            require(_investors[i] != address(0));
308            uint256 _depositedValue = deposited[_investors[i]];
309            require(_depositedValue > 0);
310            deposited[_investors[i]] = 0;
311            _investors[i].transfer(_depositedValue);
312            emit Refunded(_investors[i], _depositedValue);
313         }
314     }
315 }
316 
317 library SafeMath {
318 
319     /**
320     * @dev Multiplies two numbers, throws on overflow.
321     */
322     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
323         if (a == 0) {
324             return 0;
325         }
326         c = a * b;
327         assert(c / a == b);
328         return c;
329     }
330 
331     /**
332     * @dev Integer division of two numbers, truncating the quotient.
333     */
334     function div(uint256 a, uint256 b) internal pure returns (uint256) {
335         // assert(b > 0); // Solidity automatically throws when dividing by 0
336         // uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338         return a / b;
339     }
340 
341     /**
342     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
343     */
344     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
345         assert(b <= a);
346         return a - b;
347     }
348 
349     /**
350     * @dev Adds two numbers, throws on overflow.
351     */
352     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
353         c = a + b;
354         assert(c >= a);
355         return c;
356     }
357 }
358 
359 contract TimedAccess is Ownable {
360    /*
361     * @dev Requires msg.sender to have valid access message.
362     * @param _v ECDSA signature parameter v.
363     * @param _r ECDSA signature parameters r.
364     * @param _s ECDSA signature parameters s.
365     * @param _blockNum used to limit access time, will be checked if signed
366     * @param _etherPrice must be checked to ensure no tampering
367     */
368     address public signer;
369 
370     function _setSigner(address _signer) internal {
371         require(_signer != address(0));
372         signer = _signer;
373     }
374 
375     modifier onlyWithValidCode(
376         bytes32 _r,
377         bytes32 _s,
378         uint8 _v,
379         uint256 _blockNum,
380         uint256 _etherPrice
381     )
382     {
383         require(
384             isValidAccessMessage(
385                 _r,
386                 _s,
387                 _v,
388                 _blockNum,
389                 _etherPrice,
390                 msg.sender
391             ),
392             "Access code is incorrect or expired."
393         );
394         _;
395     }
396 
397 
398     /*
399     * @dev Verifies if message was signed by owner to give access to
400     *      _add for this contract.
401     *      Assumes Geth signature prefix (\x19Ethereum Signed Message:\n32).
402     * @param _sender Address of agent with access
403     * @return Validity of access message for a given address.
404     */
405     function isValidAccessMessage(
406         bytes32 _r,
407         bytes32 _s,
408         uint8 _v,
409         uint256 _blockNum,
410         uint256 _etherPrice,
411         address _sender
412     )
413         view
414         public
415         returns (bool)
416     {
417         bytes32 hash = keccak256(
418             abi.encodePacked(
419                 _blockNum,
420                 _etherPrice,
421                 _sender
422             )
423         );
424         bool isValid = (
425             signer == ecrecover(
426                 keccak256(
427                     abi.encodePacked(
428                         "\x19Ethereum Signed Message:\n32",
429                         hash
430                     )
431                 ),
432                 _v,
433                 _r,
434                 _s
435             )
436         );
437 
438         // after 123 blocks have passed, no purchase is possible
439         // (roughly 30 minutes)
440         bool isStillTime = (_blockNum + 123 > block.number);
441 
442         return (isValid && isStillTime);
443     }
444 }
445 
446 contract NoboCrowdsale is TimedAccess {
447 
448     using SafeMath for uint256;
449 
450     /*
451     * @dev TokenAmountGetter: a library to calculate appropiate token amount
452     */
453     using TokenAmountGetter for uint256;
454 
455     // -----------------------------------------------------------------------
456     // ---------------------------- VARIABLES --------------------------------
457     // -----------------------------------------------------------------------
458 
459     /*
460     * @dev the supervisor can prevent the owner from having control
461     */
462     address public supervisor;
463 
464     /*
465     * @dev wallet = where the ether goes to in a successful crowdsale
466     */
467     address public wallet;
468 
469     /*
470     * @dev token is the actual ERC20 token contract
471     */
472     NoboToken public token;
473 
474     /*
475     * @dev RefundVault: where the ether is stored, used to enable refunds
476     */
477     RefundVault public vault;
478 
479     /*
480     * @dev the base rate for NBX, without any bonuses
481     */
482     uint256  public baseRate;
483 
484    /*
485     * @dev startTime regulates the time bonuses, set when crowdsale begins
486     */
487     uint256  public startTime;
488 
489     /*
490     * @dev softCap = goal of our crowdsale, if it is not reached,
491     *   customers can be refunded
492     */
493     uint256 public softCap;
494 
495     /*
496     * @dev maximum amount of ether we can collect in this crowdsale
497     */
498     uint256 public hardCap;
499 
500     /*
501     * @dev the status controls the accessibilty of certain functions, e.g. the
502     *   purchase token function (in combination with the modifier onlyDuring)
503     */
504     enum Status { unstarted, started, ended, paused }
505     Status public status;
506 
507     /*
508     * @dev balances stores the balances an investor is eligible to
509     */
510     mapping(address => uint256) public balances;
511 
512     /*
513     * @dev accessAllowed-bit needs to be true for certain functions,
514     *   can only be switched by supervisor
515     */
516     bool public accessAllowed;
517 
518 
519     // ------------------------------------------------------------------------
520     // ------------------------------ EVENTS ----------------------------------
521     // ------------------------------------------------------------------------
522 
523     /*
524     * @dev NoAccessCode emitted when tx is made without data field
525     */
526     event NoAccessCode(address indexed sender);
527 
528     /*
529     * @dev CapReached signals the end of the crowdsale to us
530     */
531     event CapReached(address indexed sender, uint256 indexed etherAmount);
532 
533     /*
534     * @dev PurchaseTooSmall is emitted when tx with less than 0.1 ETH is made
535     */
536     event PurchaseTooSmall(address indexed sender, uint256 indexed etherAmount);
537 
538     /*
539     * @dev TokenPurchase is the general log for a legit purchase
540     */
541     event TokenPurchase(
542         address indexed investor,
543         uint256 indexed etherAmount,
544         uint256 indexed etherPrice,
545         uint256 tokenAmount
546     );
547 
548     /*
549     * @dev AccessChanged is emitted when the supervisor dis-/allows functions
550     */
551     event AccessChanged(bool indexed accessAllowed);
552 
553     /*
554     * @dev SignerChanged signals the change of the signer address,
555     *   the one against whcih the signature of the access code is compared to
556     */
557     event SignerChanged(address indexed previousSigner, address indexed newSigner);
558 
559     /*
560     * @dev StatusChanged signals the change of crowdsale stages
561     */
562     event StatusChanged(
563         Status indexed previousStatus,
564         Status indexed newStatus
565     );
566 
567     // ------------------------------------------------------------------------
568     // --------------------------- MODIFIER -----------------------------------
569     // ------------------------------------------------------------------------
570 
571     /*
572     * @dev restricts functions to certain crowdsale stages
573     */
574     modifier onlyDuring(Status _status) {
575         require (status == _status);
576         _;
577     }
578 
579     /*
580     * @dev akin to onlyOwner
581     */
582     modifier onlySupervisor() {
583         require(supervisor == msg.sender);
584         _;
585     }
586 
587     /*
588     * @dev certain functions need permission from the supervisor
589     */
590     modifier whenAccessAllowed() {
591         require(accessAllowed);
592         _;
593     }
594 
595     // ------------------------------------------------------------------------
596     // --------------------------- CONSTRUCTOR --------------------------------
597     // ------------------------------------------------------------------------
598 
599     /*
600     * @dev the constructor needs the token contract address
601     * @dev the crowdsale contract needs to be made owner of the token contract
602     */
603     constructor (
604         address _tokenAddress,
605         address _signer,
606         address _supervisor,
607         address _wallet
608     )
609         public
610     {
611         require(_tokenAddress != address(0));
612         require(_signer != address(0));
613         require(_supervisor!= address(0));
614         require(_wallet != address(0));
615         signer = _signer;
616         supervisor = _supervisor;
617         wallet = _wallet;
618         token = NoboToken(_tokenAddress);
619         vault = new RefundVault(wallet);
620         baseRate = 500;
621         softCap = 15000 ether;
622         hardCap = 250000 ether;
623         status = Status.unstarted;
624         accessAllowed = false;
625     }
626 
627     /*
628     * @dev send ether back to sender when no access code is specified
629     */
630     function() public payable {
631         emit NoAccessCode(msg.sender);
632         msg.sender.transfer(msg.value);
633     }
634 
635     // ------------------------------------------------------------------------
636     // -------------------------- MAIN PURCHASE -------------------------------
637     // ------------------------------------------------------------------------
638 
639     /*
640     * @dev called by users to buy token, whilst providing their access code
641     *   for more information about v, r and as see TimedAccess contract
642     * @param _v ECDSA signature parameter v.
643     * @param _r ECDSA signature parameters r.
644     * @param _s ECDSA signature parameters s.
645     * @param _blockNum used to make sure the user has only a certain timeperiod
646     *   to buy the tokens (after a set amount of blocks the function will
647     *   not execute anymore. Checked in TimedAccess
648     * @param _etherPrice used to get the bonus for the user
649     */
650     function purchaseTokens(
651         bytes32 _r,
652         bytes32 _s,
653         uint8 _v,
654         uint256 _blockNum,
655         uint256 _etherPrice
656     )
657         public
658         payable
659         onlyDuring(Status.started)
660         onlyWithValidCode( _r, _s, _v, _blockNum, _etherPrice)
661     {
662         if (_isPurchaseValid(msg.sender, msg.value)) {
663             uint256 _etherAmount = msg.value;
664             uint256 _tokenAmount = _etherAmount.getTokenAmount(
665                 _etherPrice,
666                 startTime,
667                 baseRate
668             );
669             emit TokenPurchase(msg.sender, _etherAmount, _etherPrice, _tokenAmount);
670             // registering purchase in a balance mapping
671             _registerPurchase(msg.sender, _tokenAmount);
672         }
673     }
674 
675     /*
676     * @dev checks if ether Amount is sufficient (measured in Euro)
677     *   and if the hardcap would be reached
678     */
679     function _isPurchaseValid(
680         address _sender,
681         uint256 _etherAmount
682     )
683         internal
684         returns (bool)
685     {
686         // if raised ether would be more than hardcap, send ETH back 
687         if (getEtherRaised().add(_etherAmount) > hardCap) {
688             _sender.transfer(_etherAmount);
689             emit CapReached(_sender, getEtherRaised());
690             return false;
691         }
692         if(_etherAmount <  0.5 ether) {
693             _sender.transfer(_etherAmount);
694             emit PurchaseTooSmall(_sender, _etherAmount);
695             return false;
696         }
697         return true;
698     }
699 
700     /**
701     * @dev stores balances instead of issuing tokens right away
702     * @param _investor Token purchaser
703     * @param _tokenAmount Amount of tokens purchased
704     */
705     function _registerPurchase(
706         address _investor,
707         uint256 _tokenAmount
708     )
709         internal
710     {
711         // registering balance of tokens in mapping for the customer
712         balances[_investor] = balances[_investor].add(_tokenAmount);
713         // and registering in the refundvault
714         vault.deposit.value(msg.value)(_investor);
715     }
716 
717     /*
718     * @dev used to check if refunds need to be enabled
719     */
720     function _isGoalReached() internal view returns (bool) {
721         return (getEtherRaised() >= softCap);
722     }
723 
724     /*
725     * @dev used to check how much ether is in the refundvault
726     */
727     function getEtherRaised() public view returns (uint256) {
728         return address(vault).balance;
729     }
730 
731     // ------------------------------------------------------------------------
732     // ------------------------- STAGE MANAGEMENT -----------------------------
733     // ------------------------------------------------------------------------
734 
735     /*
736     * @dev used to start Crowdsale, sets the starttime for bonuses
737     */
738     function startCrowdsale()
739         external
740         whenAccessAllowed
741         onlyOwner
742         onlyDuring(Status.unstarted)
743     {
744         emit StatusChanged(status, Status.started);
745         status = Status.started;
746         startTime = now;
747     }
748 
749     /*
750     * @dev ends Crowdsale, enables refunding of contracts
751     */
752     function endCrowdsale()
753         external
754         whenAccessAllowed
755         onlyOwner
756         onlyDuring(Status.started)
757     {
758         emit StatusChanged(status, Status.ended);
759         status = Status.ended;
760         if(_isGoalReached()) {
761             vault.close();
762         } else {
763             vault.enableRefunds();
764         }
765     }
766 
767     /*
768     * @dev can be called in ongoing Crowdsale
769     */
770     function pauseCrowdsale()
771         external
772         onlySupervisor
773         onlyDuring(Status.started)
774     {
775         emit StatusChanged(status, Status.paused);
776         status = Status.paused;
777     }
778 
779     /*
780     * @dev if problem was fixed, Crowdsale can resume
781     */
782     function resumeCrowdsale()
783         external
784         onlySupervisor
785         onlyDuring(Status.paused)
786     {
787         emit StatusChanged(status, Status.started);
788         status = Status.started;
789     }
790 
791     /*
792     * @dev if problem cant be resolved, cancel the crowdsale
793     */
794     function cancelCrowdsale()
795         external
796         onlySupervisor
797         onlyDuring(Status.paused)
798     {
799         emit StatusChanged(status, Status.ended);
800         status = Status.ended;
801         vault.enableRefunds();
802     }
803 
804     // ------------------------------------------------------------------------
805     // --------------------------- POSTCROWDSALE ------------------------------
806     // ------------------------------------------------------------------------
807 
808     /**
809     * @dev validate a customer and send the tokens
810     */
811     function approveInvestor(
812         address _beneficiary
813     )
814         external
815         whenAccessAllowed
816         onlyOwner
817     {
818         uint256 _amount = balances[_beneficiary];
819         require(_amount > 0);
820         balances[_beneficiary] = 0;
821         _deliverTokens(_beneficiary, _amount);
822     }
823 
824     /*
825     * @dev mint tokens using an array to reduce transaction costs
826     */
827     function approveInvestors(
828         address[] _beneficiaries
829     )
830         external
831         whenAccessAllowed
832         onlyOwner
833     {
834         for (uint256 i = 0; i < _beneficiaries.length; i++) {
835            require(_beneficiaries[i] != address(0));
836            uint256 _amount = balances[_beneficiaries[i]];
837            require(_amount > 0);
838            balances[_beneficiaries[i]] = 0;
839             _deliverTokens(_beneficiaries[i], _amount);
840         }
841     }
842 
843     /*
844     * @dev minting 49 percent for the platform and finishing minting
845     */
846     function mintForPlatform()
847         external
848         whenAccessAllowed
849         onlyOwner
850         onlyDuring(Status.ended)
851     {
852         uint256 _tokensForPlatform = token.totalSupply().mul(49).div(51);
853         require(token.mint(wallet, _tokensForPlatform));
854         require(token.finishMinting());
855     }
856 
857     /*
858     * @dev delivers token to a certain address
859     */
860     function _deliverTokens(
861         address _beneficiary,
862         uint256 _tokenAmount
863     )
864         internal
865     {
866         require(token.mint(_beneficiary, _tokenAmount));
867     }
868 
869     // ------------------------------------------------------------------------
870     // --------------------------- SUPERVISOR ---------------------------------
871     // ------------------------------------------------------------------------
872 
873     /*
874     * @dev change signer if account there is problem with the account
875     */
876     function changeSigner(
877         address _newSigner
878     )
879         external
880         onlySupervisor
881         onlyDuring(Status.paused)
882     {
883         require(_newSigner != address(0));
884         emit SignerChanged(signer, _newSigner);
885         signer = _newSigner;
886     }
887 
888     /*
889     * @dev change the state of accessAllowed bit, thus locking or freeing functions
890     */
891     function setAccess(bool value) public onlySupervisor {
892         require(accessAllowed != value);
893         emit AccessChanged(value);
894         accessAllowed = value;
895     }
896 
897     // ------------------------------------------------------------------------
898     // ----------------------- Expired Crowdsale ------------------------------
899     // ------------------------------------------------------------------------
900 
901     /*
902     * @dev function for everyone to enable refunds after certain time
903     */
904     function endExpiredCrowdsale() public {
905         require(status != Status.unstarted);
906         require(now > startTime + 181 days);
907         emit StatusChanged(status, Status.ended);
908         status = Status.ended;
909         if(_isGoalReached()) {
910             vault.close();
911         } else {
912             vault.enableRefunds();
913         }
914     }
915 }
916 
917 library TokenAmountGetter {
918 
919     using SafeMath for uint256;
920 
921     /*
922     * @dev get the amount of tokens corresponding to the ether amount
923     * @param _etherAmount amount of ether the user has invested
924     * @param _etherPrice price of ether in euro ca at the time of purchase
925     * @param _startTime starting time of the ICO
926     * @param _baseRate the base rate of token to ether, constant
927     */
928     function getTokenAmount(
929         uint256 _etherAmount,
930         uint256 _etherPrice,
931         uint256 _startTime,
932         uint256 _baseRate
933     )
934         internal
935         view
936         returns (uint256)
937     {
938         uint256 _baseTokenAmount = _etherAmount.mul(_baseRate);
939         uint256 _timeBonus = _getTimeBonus(_baseTokenAmount, _startTime);
940         uint256 _amountBonus = _getAmountBonus(
941             _etherAmount,
942             _etherPrice,
943             _baseTokenAmount
944         );
945         uint256 _totalBonus = _timeBonus.add(_amountBonus);
946 
947         uint256 _totalAmount = _baseTokenAmount.add(_totalBonus);
948 
949         // another 2% on top if tokens bought in the first 24 hours
950         if(_startTime + 1 days > now)
951             _totalAmount = _totalAmount.add(_totalAmount.mul(2).div(100));
952 
953         return _totalAmount;
954     }
955 
956     /*
957     * @dev get time bonus for base amount, does not include 24H 2% on top
958     */
959     function _getTimeBonus(
960         uint256 _baseTokenAmount,
961         uint256 _startTime
962     )
963         internal
964         view
965         returns (uint256)
966     {
967         if (now <= (_startTime + 1 weeks))
968             return (_baseTokenAmount.mul(20).div(100));
969         if (now <= (_startTime + 2 weeks))
970             return (_baseTokenAmount.mul(18).div(100));
971         if (now <= (_startTime + 3 weeks))
972             return (_baseTokenAmount.mul(16).div(100));
973         if (now <= (_startTime + 4 weeks))
974             return (_baseTokenAmount.mul(14).div(100));
975         if (now <= (_startTime + 5 weeks))
976             return (_baseTokenAmount.mul(12).div(100));
977         if (now <= (_startTime + 6 weeks))
978             return (_baseTokenAmount.mul(10).div(100));
979         if (now <= (_startTime + 7 weeks))
980             return (_baseTokenAmount.mul(8).div(100));
981         if (now <= (_startTime + 8 weeks))
982             return (_baseTokenAmount.mul(6).div(100));
983         if (now <= (_startTime + 9 weeks))
984             return (_baseTokenAmount.mul(4).div(100));
985         if (now <= (_startTime + 10 weeks))
986             return (_baseTokenAmount.mul(2).div(100));
987         return 0;
988     }
989 
990     /*
991     * @dev get amount bonus for amount measured in euro, which is
992     *   determined by the current price and amount
993     */
994     function _getAmountBonus(
995         uint256 _etherAmount,
996         uint256 _etherPrice,
997         uint256 _baseTokenAmount
998     )
999         internal
1000         pure
1001         returns (uint256)
1002     {
1003         uint256 _etherAmountInEuro = _etherAmount.mul(_etherPrice).div(1 ether);
1004         if (_etherAmountInEuro < 100000)
1005             return 0;
1006         if (_etherAmountInEuro >= 100000 && _etherAmountInEuro < 150000)
1007             return (_baseTokenAmount.mul(3)).div(100);
1008         if (_etherAmountInEuro >= 150000 && _etherAmountInEuro < 200000)
1009             return (_baseTokenAmount.mul(6)).div(100);
1010         if (_etherAmountInEuro >= 200000 && _etherAmountInEuro < 300000)
1011             return (_baseTokenAmount.mul(9)).div(100);
1012         if (_etherAmountInEuro >= 300000 && _etherAmountInEuro < 1000000)
1013             return (_baseTokenAmount.mul(12)).div(100);
1014         if (_etherAmountInEuro >= 1000000 && _etherAmountInEuro < 1500000)
1015             return (_baseTokenAmount.mul(15)).div(100);
1016         if (_etherAmountInEuro >= 1500000)
1017             return (_baseTokenAmount.mul(20)).div(100);
1018     }
1019 }