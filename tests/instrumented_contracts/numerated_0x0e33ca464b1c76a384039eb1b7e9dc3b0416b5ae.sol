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
50 contract NamiPool {
51     using SafeMath for uint256;
52     
53     function NamiPool(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
54         require(_namiMultiSigWallet != 0x0);
55         escrow = _escrow;
56         namiMultiSigWallet = _namiMultiSigWallet;
57         NamiAddr = _namiAddress;
58     }
59     
60     string public name = "Nami Pool";
61     
62     // escrow has exclusive priveleges to call administrative
63     // functions on this contract.
64     address public escrow;
65 
66     // Gathered funds can be withdraw only to namimultisigwallet's address.
67     address public namiMultiSigWallet;
68     
69     /// address of Nami token
70     address public NamiAddr;
71     
72     modifier onlyEscrow() {
73         require(msg.sender == escrow);
74         _;
75     }
76     
77     modifier onlyNami {
78         require(msg.sender == NamiAddr);
79         _;
80     }
81     
82     modifier onlyNamiMultisig {
83         require(msg.sender == namiMultiSigWallet);
84         _;
85     }
86     
87     uint public currentRound = 1;
88     
89     struct ShareHolder {
90         uint stake;
91         bool isActive;
92         bool isWithdrawn;
93     }
94     
95     struct Round {
96         bool isOpen;
97         uint currentNAC;
98         uint finalNAC;
99         uint ethBalance;
100         bool withdrawable; //for user not in top
101         bool topWithdrawable;
102         bool isCompleteActive;
103         bool isCloseEthPool;
104     }
105     
106     mapping (uint => mapping (address => ShareHolder)) public namiPool;
107     mapping (uint => Round) public round;
108     
109     
110     // Events
111     event UpdateShareHolder(address indexed ShareHolderAddress, uint indexed RoundIndex, uint Stake, uint Time);
112     event Deposit(address sender,uint indexed RoundIndex, uint value);
113     event WithdrawPool(uint Amount, uint TimeWithdraw);
114     event UpdateActive(address indexed ShareHolderAddress, uint indexed RoundIndex, bool Status, uint Time);
115     event Withdraw(address indexed ShareHolderAddress, uint indexed RoundIndex, uint Ether, uint Nac, uint TimeWithdraw);
116     event ActivateRound(uint RoundIndex, uint TimeActive);
117     
118     
119     function changeEscrow(address _escrow)
120         onlyNamiMultisig
121         public
122     {
123         require(_escrow != 0x0);
124         escrow = _escrow;
125     }
126     
127     function withdrawEther(uint _amount) public
128         onlyEscrow
129     {
130         require(namiMultiSigWallet != 0x0);
131         // 
132         if (this.balance > 0) {
133             namiMultiSigWallet.transfer(_amount);
134         }
135     }
136     
137     function withdrawNAC(uint _amount) public
138         onlyEscrow
139     {
140         require(namiMultiSigWallet != 0x0 && _amount != 0);
141         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
142         if (namiToken.balanceOf(this) > 0) {
143             namiToken.transfer(namiMultiSigWallet, _amount);
144         }
145     }
146     
147     
148     /*/
149      *  Admin function
150     /*/
151     
152     /*/ process of one round
153      * step 1: admin open one round by execute activateRound function
154      * step 2: now investor can invest Nac to Nac Pool until round closed
155      * step 3: admin close round, now investor cann't invest NAC to Pool
156      * step 4: admin activate top investor
157      * step 5: all top investor was activated, admin execute closeActive function to close active phrase
158      * step 6: admin open withdrawable for investor not in top to withdraw NAC
159      * step 7: admin deposit eth to eth pool
160      * step 8: close deposit eth to eth pool
161      * step 9: admin open withdrawable to investor in top
162      * step 10: investor in top now can withdraw NAC and ETH for this round
163     /*/
164     
165     // ------------------------------------------------ 
166     /*
167     * Admin function
168     * Open and Close Round
169     *
170     */
171     function activateRound(uint _roundIndex) 
172         onlyEscrow
173         public
174     {
175         require(round[_roundIndex].isOpen == false && round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isCompleteActive == false);
176         round[_roundIndex].isOpen = true;
177         currentRound = _roundIndex;
178         ActivateRound(_roundIndex, now);
179     }
180     
181     function deactivateRound(uint _roundIndex)
182         onlyEscrow
183         public
184     {
185         require(round[_roundIndex].isOpen == true);
186         round[_roundIndex].isOpen = false;
187     }
188     
189     // ------------------------------------------------ 
190     // this function add stake of ShareHolder
191     // investor can execute this function during round open
192     //
193     
194     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
195         // only on currentRound and active user can add stake
196         require(round[_price].isOpen == true && _value > 0);
197         // add stake
198         namiPool[_price][_from].stake = namiPool[_price][_from].stake.add(_value);
199         round[_price].currentNAC = round[_price].currentNAC.add(_value);
200         UpdateShareHolder(_from, _price, namiPool[_price][_from].stake, now);
201         return true;
202     }
203     
204     
205     /*
206     *
207     * Activate and deactivate user
208     * add or sub final Nac to compute stake to withdraw
209     */
210     function activateUser(address _shareAddress, uint _roundId)
211         onlyEscrow
212         public
213     {
214         require(namiPool[_roundId][_shareAddress].isActive == false && namiPool[_roundId][_shareAddress].stake > 0);
215         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
216         namiPool[_roundId][_shareAddress].isActive = true;
217         round[_roundId].finalNAC = round[_roundId].finalNAC.add(namiPool[_roundId][_shareAddress].stake);
218         UpdateActive(_shareAddress, _roundId ,namiPool[_roundId][_shareAddress].isActive, now);
219     }
220     
221     function deactivateUser(address _shareAddress, uint _roundId)
222         onlyEscrow
223         public
224     {
225         require(namiPool[_roundId][_shareAddress].isActive == true && namiPool[_roundId][_shareAddress].stake > 0);
226         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
227         namiPool[_roundId][_shareAddress].isActive = false;
228         round[_roundId].finalNAC = round[_roundId].finalNAC.sub(namiPool[_roundId][_shareAddress].stake);
229         UpdateActive(_shareAddress, _roundId ,namiPool[_roundId][_shareAddress].isActive, now);
230     }
231     
232     
233     // ------------------------------------------------ 
234     // admin close activate phrase to 
235     // 
236     //
237     function closeActive(uint _roundId)
238         onlyEscrow
239         public
240     {
241         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
242         round[_roundId].isCompleteActive = true;
243     }
244     //
245     //
246     // change Withdrawable for one round after every month
247     // for investor not in top
248     //
249     function changeWithdrawable(uint _roundIndex)
250         onlyEscrow
251         public
252     {
253         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
254         round[_roundIndex].withdrawable = !round[_roundIndex].withdrawable;
255     }
256     
257     
258     
259     //
260     //
261     // change Withdrawable for one round after every month
262     // for investor in top
263     //
264     function changeTopWithdrawable(uint _roundIndex)
265         onlyEscrow
266         public
267     {
268         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
269         round[_roundIndex].topWithdrawable = !round[_roundIndex].topWithdrawable;
270     }
271     
272     
273     //
274     //
275     // after month admin deposit ETH to ETH Pool
276     // 
277     //
278     function depositEthPool(uint _roundIndex)
279         payable public
280         onlyEscrow
281     {
282         require(msg.value > 0 && round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isOpen == false);
283         if (msg.value > 0) {
284             round[_roundIndex].ethBalance = round[_roundIndex].ethBalance.add(msg.value);
285             Deposit(msg.sender, _roundIndex, msg.value);
286         }
287     }
288     
289     //
290     //
291     function withdrawEthPool(uint _roundIndex, uint _amount)
292         public
293         onlyEscrow
294     {
295         require(round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isOpen == false);
296         require(namiMultiSigWallet != 0x0);
297         // 
298         if (_amount > 0) {
299             namiMultiSigWallet.transfer(_amount);
300             round[_roundIndex].ethBalance = round[_roundIndex].ethBalance.sub(_amount);
301             WithdrawPool(_amount, now);
302         }
303     }
304     
305     //
306     // close phrase deposit ETH to Pool
307     // 
308     function closeEthPool(uint _roundIndex)
309         public
310         onlyEscrow
311     {
312         require(round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
313         round[_roundIndex].isCloseEthPool = true;
314     }
315     
316     //
317     //
318     // withdraw NAC for investor
319     // internal function only can run by this smartcontract
320     // 
321     //
322     function _withdrawNAC(address _shareAddress, uint _roundIndex) internal {
323         require(namiPool[_roundIndex][_shareAddress].stake > 0);
324         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
325         uint previousBalances = namiToken.balanceOf(this);
326         namiToken.transfer(_shareAddress, namiPool[_roundIndex][_shareAddress].stake);
327         // update current Nac pool balance
328         round[_roundIndex].currentNAC = round[_roundIndex].currentNAC.sub(namiPool[_roundIndex][_shareAddress].stake);
329         
330         namiPool[_roundIndex][_shareAddress].stake = 0;
331         assert(previousBalances > namiToken.balanceOf(this));
332     }
333     
334     
335     //
336     //
337     // withdraw NAC and ETH for top investor
338     // 
339     //
340     function withdrawTopForTeam(address _shareAddress, uint _roundIndex)
341         onlyEscrow
342         public
343     {
344         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isCloseEthPool == true && round[_roundIndex].isOpen == false);
345         require(round[_roundIndex].topWithdrawable);
346         if(namiPool[_roundIndex][_shareAddress].isActive == true) {
347             require(namiPool[_roundIndex][_shareAddress].isWithdrawn == false);
348             assert(round[_roundIndex].finalNAC > namiPool[_roundIndex][_shareAddress].stake);
349             
350             // compute eth for invester
351             uint ethReturn = (round[_roundIndex].ethBalance.mul(namiPool[_roundIndex][_shareAddress].stake)).div(round[_roundIndex].finalNAC);
352             _shareAddress.transfer(ethReturn);
353             
354             // set user withdraw
355             namiPool[_roundIndex][_shareAddress].isWithdrawn = true;
356             Withdraw(_shareAddress, _roundIndex, ethReturn, namiPool[_roundIndex][_shareAddress].stake, now);
357             
358             // withdraw NAC
359             _withdrawNAC(_shareAddress, _roundIndex);
360         }
361     }
362     
363     
364     
365     
366     //
367     //
368     // withdraw NAC and ETH for non top investor
369     // execute by admin only
370     // 
371     //
372     function withdrawNonTopForTeam(address _shareAddress, uint _roundIndex)
373         onlyEscrow
374         public
375     {
376         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
377         require(round[_roundIndex].withdrawable);
378         if(namiPool[_roundIndex][_shareAddress].isActive == false) {
379             require(namiPool[_roundIndex][_shareAddress].isWithdrawn == false);
380             // set state user withdraw
381             namiPool[_roundIndex][_shareAddress].isWithdrawn = true;
382             Withdraw(_shareAddress, _roundIndex, 0, namiPool[_roundIndex][_shareAddress].stake, now);
383             //
384             _withdrawNAC(_shareAddress, _roundIndex);
385         }
386     }
387     
388     
389     
390     //
391     //
392     // withdraw NAC and ETH for top investor
393     // execute by investor
394     // 
395     //
396     function withdrawTop(uint _roundIndex)
397         public
398     {
399         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isCloseEthPool == true && round[_roundIndex].isOpen == false);
400         require(round[_roundIndex].topWithdrawable);
401         if(namiPool[_roundIndex][msg.sender].isActive == true) {
402             require(namiPool[_roundIndex][msg.sender].isWithdrawn == false);
403             uint ethReturn = (round[_roundIndex].ethBalance.mul(namiPool[_roundIndex][msg.sender].stake)).div(round[_roundIndex].finalNAC);
404             msg.sender.transfer(ethReturn);
405             // set user withdraw
406             namiPool[_roundIndex][msg.sender].isWithdrawn = true;
407             //
408             Withdraw(msg.sender, _roundIndex, ethReturn, namiPool[_roundIndex][msg.sender].stake, now);
409             _withdrawNAC(msg.sender, _roundIndex);
410         }
411     }
412     
413     //
414     //
415     // withdraw NAC and ETH for non top investor
416     // execute by investor
417     // 
418     //
419     function withdrawNonTop(uint _roundIndex)
420         public
421     {
422         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
423         require(round[_roundIndex].withdrawable);
424         if(namiPool[_roundIndex][msg.sender].isActive == false) {
425             require(namiPool[_roundIndex][msg.sender].isWithdrawn == false);
426             namiPool[_roundIndex][msg.sender].isWithdrawn = true;
427             //
428             Withdraw(msg.sender, _roundIndex, 0, namiPool[_roundIndex][msg.sender].stake, now);
429             _withdrawNAC(msg.sender, _roundIndex);
430         }
431     }
432     
433 }
434 
435 contract NamiCrowdSale {
436     using SafeMath for uint256;
437 
438     /// NAC Broker Presale Token
439     /// @dev Constructor
440     function NamiCrowdSale(address _escrow, address _namiMultiSigWallet, address _namiPresale) public {
441         require(_namiMultiSigWallet != 0x0);
442         escrow = _escrow;
443         namiMultiSigWallet = _namiMultiSigWallet;
444         namiPresale = _namiPresale;
445     }
446 
447 
448     /*/
449      *  Constants
450     /*/
451 
452     string public name = "Nami ICO";
453     string public  symbol = "NAC";
454     uint   public decimals = 18;
455 
456     bool public TRANSFERABLE = false; // default not transferable
457 
458     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
459     
460     uint public binary = 0;
461 
462     /*/
463      *  Token state
464     /*/
465 
466     enum Phase {
467         Created,
468         Running,
469         Paused,
470         Migrating,
471         Migrated
472     }
473 
474     Phase public currentPhase = Phase.Created;
475     uint public totalSupply = 0; // amount of tokens already sold
476 
477     // escrow has exclusive priveleges to call administrative
478     // functions on this contract.
479     address public escrow;
480 
481     // Gathered funds can be withdraw only to namimultisigwallet's address.
482     address public namiMultiSigWallet;
483 
484     // nami presale contract
485     address public namiPresale;
486 
487     // Crowdsale manager has exclusive priveleges to burn presale tokens.
488     address public crowdsaleManager;
489     
490     // binary option address
491     address public binaryAddress;
492     
493     // This creates an array with all balances
494     mapping (address => uint256) public balanceOf;
495     mapping (address => mapping (address => uint256)) public allowance;
496 
497     modifier onlyCrowdsaleManager() {
498         require(msg.sender == crowdsaleManager); 
499         _; 
500     }
501 
502     modifier onlyEscrow() {
503         require(msg.sender == escrow);
504         _;
505     }
506     
507     modifier onlyTranferable() {
508         require(TRANSFERABLE);
509         _;
510     }
511     
512     modifier onlyNamiMultisig() {
513         require(msg.sender == namiMultiSigWallet);
514         _;
515     }
516     
517     /*/
518      *  Events
519     /*/
520 
521     event LogBuy(address indexed owner, uint value);
522     event LogBurn(address indexed owner, uint value);
523     event LogPhaseSwitch(Phase newPhase);
524     // Log migrate token
525     event LogMigrate(address _from, address _to, uint256 amount);
526     // This generates a public event on the blockchain that will notify clients
527     event Transfer(address indexed from, address indexed to, uint256 value);
528 
529     /*/
530      *  Public functions
531     /*/
532 
533     /**
534      * Internal transfer, only can be called by this contract
535      */
536     function _transfer(address _from, address _to, uint _value) internal {
537         // Prevent transfer to 0x0 address. Use burn() instead
538         require(_to != 0x0);
539         // Check if the sender has enough
540         require(balanceOf[_from] >= _value);
541         // Check for overflows
542         require(balanceOf[_to] + _value > balanceOf[_to]);
543         // Save this for an assertion in the future
544         uint previousBalances = balanceOf[_from] + balanceOf[_to];
545         // Subtract from the sender
546         balanceOf[_from] -= _value;
547         // Add the same to the recipient
548         balanceOf[_to] += _value;
549         Transfer(_from, _to, _value);
550         // Asserts are used to use static analysis to find bugs in your code. They should never fail
551         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
552     }
553 
554     // Transfer the balance from owner's account to another account
555     // only escrow can send token (to send token private sale)
556     function transferForTeam(address _to, uint256 _value) public
557         onlyEscrow
558     {
559         _transfer(msg.sender, _to, _value);
560     }
561     
562     /**
563      * Transfer tokens
564      *
565      * Send `_value` tokens to `_to` from your account
566      *
567      * @param _to The address of the recipient
568      * @param _value the amount to send
569      */
570     function transfer(address _to, uint256 _value) public
571         onlyTranferable
572     {
573         _transfer(msg.sender, _to, _value);
574     }
575     
576        /**
577      * Transfer tokens from other address
578      *
579      * Send `_value` tokens to `_to` in behalf of `_from`
580      *
581      * @param _from The address of the sender
582      * @param _to The address of the recipient
583      * @param _value the amount to send
584      */
585     function transferFrom(address _from, address _to, uint256 _value) 
586         public
587         onlyTranferable
588         returns (bool success)
589     {
590         require(_value <= allowance[_from][msg.sender]);     // Check allowance
591         allowance[_from][msg.sender] -= _value;
592         _transfer(_from, _to, _value);
593         return true;
594     }
595 
596     /**
597      * Set allowance for other address
598      *
599      * Allows `_spender` to spend no more than `_value` tokens in your behalf
600      *
601      * @param _spender The address authorized to spend
602      * @param _value the max amount they can spend
603      */
604     function approve(address _spender, uint256 _value) public
605         onlyTranferable
606         returns (bool success) 
607     {
608         allowance[msg.sender][_spender] = _value;
609         return true;
610     }
611 
612     /**
613      * Set allowance for other address and notify
614      *
615      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
616      *
617      * @param _spender The address authorized to spend
618      * @param _value the max amount they can spend
619      * @param _extraData some extra information to send to the approved contract
620      */
621     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
622         public
623         onlyTranferable
624         returns (bool success) 
625     {
626         tokenRecipient spender = tokenRecipient(_spender);
627         if (approve(_spender, _value)) {
628             spender.receiveApproval(msg.sender, _value, this, _extraData);
629             return true;
630         }
631     }
632 
633     // allows transfer token
634     function changeTransferable () public
635         onlyEscrow
636     {
637         TRANSFERABLE = !TRANSFERABLE;
638     }
639     
640     // change escrow
641     function changeEscrow(address _escrow) public
642         onlyNamiMultisig
643     {
644         require(_escrow != 0x0);
645         escrow = _escrow;
646     }
647     
648     // change binary value
649     function changeBinary(uint _binary)
650         public
651         onlyEscrow
652     {
653         binary = _binary;
654     }
655     
656     // change binary address
657     function changeBinaryAddress(address _binaryAddress)
658         public
659         onlyEscrow
660     {
661         require(_binaryAddress != 0x0);
662         binaryAddress = _binaryAddress;
663     }
664     
665     /*
666     * price in ICO:
667     * first week: 1 ETH = 2400 NAC
668     * second week: 1 ETH = 23000 NAC
669     * 3rd week: 1 ETH = 2200 NAC
670     * 4th week: 1 ETH = 2100 NAC
671     * 5th week: 1 ETH = 2000 NAC
672     * 6th week: 1 ETH = 1900 NAC
673     * 7th week: 1 ETH = 1800 NAC
674     * 8th week: 1 ETH = 1700 nac
675     * time: 
676     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
677     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
678     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
679     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
680     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
681     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
682     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
683     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
684     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
685     */
686     function getPrice() public view returns (uint price) {
687         if (now < 1517443200) {
688             // presale
689             return 3450;
690         } else if (1517443200 < now && now <= 1518048000) {
691             // 1st week
692             return 2400;
693         } else if (1518048000 < now && now <= 1518652800) {
694             // 2nd week
695             return 2300;
696         } else if (1518652800 < now && now <= 1519257600) {
697             // 3rd week
698             return 2200;
699         } else if (1519257600 < now && now <= 1519862400) {
700             // 4th week
701             return 2100;
702         } else if (1519862400 < now && now <= 1520467200) {
703             // 5th week
704             return 2000;
705         } else if (1520467200 < now && now <= 1521072000) {
706             // 6th week
707             return 1900;
708         } else if (1521072000 < now && now <= 1521676800) {
709             // 7th week
710             return 1800;
711         } else if (1521676800 < now && now <= 1522281600) {
712             // 8th week
713             return 1700;
714         } else {
715             return binary;
716         }
717     }
718 
719 
720     function() payable public {
721         buy(msg.sender);
722     }
723     
724     
725     function buy(address _buyer) payable public {
726         // Available only if presale is running.
727         require(currentPhase == Phase.Running);
728         // require ICO time or binary option
729         require(now <= 1522281600 || msg.sender == binaryAddress);
730         require(msg.value != 0);
731         uint newTokens = msg.value * getPrice();
732         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
733         // add new token to buyer
734         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
735         // add new token to totalSupply
736         totalSupply = totalSupply.add(newTokens);
737         LogBuy(_buyer,newTokens);
738         Transfer(this,_buyer,newTokens);
739     }
740     
741 
742     /// @dev Returns number of tokens owned by given address.
743     /// @param _owner Address of token owner.
744     function burnTokens(address _owner) public
745         onlyCrowdsaleManager
746     {
747         // Available only during migration phase
748         require(currentPhase == Phase.Migrating);
749 
750         uint tokens = balanceOf[_owner];
751         require(tokens != 0);
752         balanceOf[_owner] = 0;
753         totalSupply -= tokens;
754         LogBurn(_owner, tokens);
755         Transfer(_owner, crowdsaleManager, tokens);
756 
757         // Automatically switch phase when migration is done.
758         if (totalSupply == 0) {
759             currentPhase = Phase.Migrated;
760             LogPhaseSwitch(Phase.Migrated);
761         }
762     }
763 
764 
765     /*/
766      *  Administrative functions
767     /*/
768     function setPresalePhase(Phase _nextPhase) public
769         onlyEscrow
770     {
771         bool canSwitchPhase
772             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
773             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
774                 // switch to migration phase only if crowdsale manager is set
775             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
776                 && _nextPhase == Phase.Migrating
777                 && crowdsaleManager != 0x0)
778             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
779                 // switch to migrated only if everyting is migrated
780             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
781                 && totalSupply == 0);
782 
783         require(canSwitchPhase);
784         currentPhase = _nextPhase;
785         LogPhaseSwitch(_nextPhase);
786     }
787 
788 
789     function withdrawEther(uint _amount) public
790         onlyEscrow
791     {
792         require(namiMultiSigWallet != 0x0);
793         // Available at any phase.
794         if (this.balance > 0) {
795             namiMultiSigWallet.transfer(_amount);
796         }
797     }
798     
799     function safeWithdraw(address _withdraw, uint _amount) public
800         onlyEscrow
801     {
802         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
803         if (namiWallet.isOwner(_withdraw)) {
804             _withdraw.transfer(_amount);
805         }
806     }
807 
808 
809     function setCrowdsaleManager(address _mgr) public
810         onlyEscrow
811     {
812         // You can't change crowdsale contract when migration is in progress.
813         require(currentPhase != Phase.Migrating);
814         crowdsaleManager = _mgr;
815     }
816 
817     // internal migrate migration tokens
818     function _migrateToken(address _from, address _to)
819         internal
820     {
821         PresaleToken presale = PresaleToken(namiPresale);
822         uint256 newToken = presale.balanceOf(_from);
823         require(newToken > 0);
824         // burn old token
825         presale.burnTokens(_from);
826         // add new token to _to
827         balanceOf[_to] = balanceOf[_to].add(newToken);
828         // add new token to totalSupply
829         totalSupply = totalSupply.add(newToken);
830         LogMigrate(_from, _to, newToken);
831         Transfer(this,_to,newToken);
832     }
833 
834     // migate token function for Nami Team
835     function migrateToken(address _from, address _to) public
836         onlyEscrow
837     {
838         _migrateToken(_from, _to);
839     }
840 
841     // migrate token for investor
842     function migrateForInvestor() public {
843         _migrateToken(msg.sender, msg.sender);
844     }
845 
846     // Nami internal exchange
847     
848     // event for Nami exchange
849     event TransferToBuyer(address indexed _from, address indexed _to, uint _value, address indexed _seller);
850     event TransferToExchange(address indexed _from, address indexed _to, uint _value, uint _price);
851     
852     
853     /**
854      * @dev Transfer the specified amount of tokens to the NamiExchange address.
855      *      Invokes the `tokenFallbackExchange` function.
856      *      The token transfer fails if the recipient is a contract
857      *      but does not implement the `tokenFallbackExchange` function
858      *      or the fallback function to receive funds.
859      *
860      * @param _to    Receiver address.
861      * @param _value Amount of tokens that will be transferred.
862      * @param _price price to sell token.
863      */
864      
865     function transferToExchange(address _to, uint _value, uint _price) public {
866         uint codeLength;
867         
868         assembly {
869             codeLength := extcodesize(_to)
870         }
871         
872         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
873         balanceOf[_to] = balanceOf[_to].add(_value);
874         Transfer(msg.sender,_to,_value);
875         if (codeLength > 0) {
876             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
877             receiver.tokenFallbackExchange(msg.sender, _value, _price);
878             TransferToExchange(msg.sender, _to, _value, _price);
879         }
880     }
881     
882     /**
883      * @dev Transfer the specified amount of tokens to the NamiExchange address.
884      *      Invokes the `tokenFallbackBuyer` function.
885      *      The token transfer fails if the recipient is a contract
886      *      but does not implement the `tokenFallbackBuyer` function
887      *      or the fallback function to receive funds.
888      *
889      * @param _to    Receiver address.
890      * @param _value Amount of tokens that will be transferred.
891      * @param _buyer address of seller.
892      */
893      
894     function transferToBuyer(address _to, uint _value, address _buyer) public {
895         uint codeLength;
896         
897         assembly {
898             codeLength := extcodesize(_to)
899         }
900         
901         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
902         balanceOf[_to] = balanceOf[_to].add(_value);
903         Transfer(msg.sender,_to,_value);
904         if (codeLength > 0) {
905             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
906             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
907             TransferToBuyer(msg.sender, _to, _value, _buyer);
908         }
909     }
910 //-------------------------------------------------------------------------------------------------------
911 }
912 
913 
914 /*
915 * Binary option smart contract-------------------------------
916 */
917 contract BinaryOption {
918     /*
919      * binary option controled by escrow to buy NAC with good price
920      */
921     // NamiCrowdSale address
922     address public namiCrowdSaleAddr;
923     address public escrow;
924     
925     // namiMultiSigWallet
926     address public namiMultiSigWallet;
927     
928     Session public session;
929     uint public timeInvestInMinute = 15;
930     uint public timeOneSession = 20;
931     uint public sessionId = 1;
932     uint public rateWin = 100;
933     uint public rateLoss = 20;
934     uint public rateFee = 5;
935     uint public constant MAX_INVESTOR = 20;
936     uint public minimunEth = 10000000000000000; // minimunEth = 0.01 eth
937     /**
938      * Events for binany option system
939      */
940     event SessionOpen(uint timeOpen, uint indexed sessionId);
941     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
942     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
943     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rateWin, uint rateLoss, uint rateFee);
944 
945     event Deposit(address indexed sender, uint value);
946     /// @dev Fallback function allows to deposit ether.
947     function() public payable {
948         if (msg.value > 0)
949             Deposit(msg.sender, msg.value);
950     }
951     // there is only one session available at one timeOpen
952     // priceOpen is price of ETH in USD
953     // priceClose is price of ETH in USD
954     // process of one Session
955     // 1st: escrow reset session by run resetSession()
956     // 2nd: escrow open session by run openSession() => save timeOpen at this time
957     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
958     // 4th: escrow close invest and insert price open for this Session
959     // 5th: escrow close session and send NAC for investor
960     struct Session {
961         uint priceOpen;
962         uint priceClose;
963         uint timeOpen;
964         bool isReset;
965         bool isOpen;
966         bool investOpen;
967         uint investorCount;
968         mapping(uint => address) investor;
969         mapping(uint => bool) win;
970         mapping(uint => uint) amountInvest;
971     }
972     
973     function BinaryOption(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
974         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
975         namiCrowdSaleAddr = _namiCrowdSale;
976         escrow = _escrow;
977         namiMultiSigWallet = _namiMultiSigWallet;
978     }
979     
980     
981     modifier onlyEscrow() {
982         require(msg.sender==escrow);
983         _;
984     }
985     
986         
987     modifier onlyNamiMultisig() {
988         require(msg.sender == namiMultiSigWallet);
989         _;
990     }
991     
992     // change escrow
993     function changeEscrow(address _escrow) public
994         onlyNamiMultisig
995     {
996         require(_escrow != 0x0);
997         escrow = _escrow;
998     }
999     
1000     // chagne minimunEth
1001     function changeMinEth(uint _minimunEth) public 
1002         onlyEscrow
1003     {
1004         require(_minimunEth != 0);
1005         minimunEth = _minimunEth;
1006     }
1007     
1008     /// @dev Change time for investor can invest in one session, can only change at time not in session
1009     /// @param _timeInvest time invest in minutes
1010     ///---------------------------change time function------------------------------
1011     function changeTimeInvest(uint _timeInvest)
1012         public
1013         onlyEscrow
1014     {
1015         require(!session.isOpen && _timeInvest < timeOneSession);
1016         timeInvestInMinute = _timeInvest;
1017     }
1018 
1019     function changeTimeOneSession(uint _timeOneSession) 
1020         public
1021         onlyEscrow
1022     {
1023         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
1024         timeOneSession = _timeOneSession;
1025     }
1026 
1027     /////------------------------change rate function-------------------------------
1028     
1029     function changeRateWin(uint _rateWin)
1030         public
1031         onlyEscrow
1032     {
1033         require(!session.isOpen);
1034         rateWin = _rateWin;
1035     }
1036     
1037     function changeRateLoss(uint _rateLoss)
1038         public
1039         onlyEscrow
1040     {
1041         require(!session.isOpen);
1042         rateLoss = _rateLoss;
1043     }
1044     
1045     function changeRateFee(uint _rateFee)
1046         public
1047         onlyEscrow
1048     {
1049         require(!session.isOpen);
1050         rateFee = _rateFee;
1051     }
1052     
1053     
1054     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1055     /// @param _amount value ether in wei to withdraw
1056     function withdrawEther(uint _amount) public
1057         onlyEscrow
1058     {
1059         require(namiMultiSigWallet != 0x0);
1060         // Available at any phase.
1061         if (this.balance > 0) {
1062             namiMultiSigWallet.transfer(_amount);
1063         }
1064     }
1065     
1066     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
1067     /// @param _withdraw address to withdraw
1068     function safeWithdraw(address _withdraw, uint _amount) public
1069         onlyEscrow
1070     {
1071         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
1072         if (namiWallet.isOwner(_withdraw)) {
1073             _withdraw.transfer(_amount);
1074         }
1075     }
1076     
1077     // @dev Returns list of owners.
1078     // @return List of owner addresses.
1079     // MAX_INVESTOR = 20
1080     function getInvestors()
1081         public
1082         view
1083         returns (address[20])
1084     {
1085         address[20] memory listInvestor;
1086         for (uint i = 0; i < MAX_INVESTOR; i++) {
1087             listInvestor[i] = session.investor[i];
1088         }
1089         return listInvestor;
1090     }
1091     
1092     function getChooses()
1093         public
1094         view
1095         returns (bool[20])
1096     {
1097         bool[20] memory listChooses;
1098         for (uint i = 0; i < MAX_INVESTOR; i++) {
1099             listChooses[i] = session.win[i];
1100         }
1101         return listChooses;
1102     }
1103     
1104     function getAmount()
1105         public
1106         view
1107         returns (uint[20])
1108     {
1109         uint[20] memory listAmount;
1110         for (uint i = 0; i < MAX_INVESTOR; i++) {
1111             listAmount[i] = session.amountInvest[i];
1112         }
1113         return listAmount;
1114     }
1115     
1116     /// @dev reset all data of previous session, must run before open new session
1117     // only escrow can call
1118     function resetSession()
1119         public
1120         onlyEscrow
1121     {
1122         require(!session.isReset && !session.isOpen);
1123         session.priceOpen = 0;
1124         session.priceClose = 0;
1125         session.isReset = true;
1126         session.isOpen = false;
1127         session.investOpen = false;
1128         session.investorCount = 0;
1129         for (uint i = 0; i < MAX_INVESTOR; i++) {
1130             session.investor[i] = 0x0;
1131             session.win[i] = false;
1132             session.amountInvest[i] = 0;
1133         }
1134     }
1135     
1136     /// @dev Open new session, only escrow can call
1137     function openSession ()
1138         public
1139         onlyEscrow
1140     {
1141         require(session.isReset && !session.isOpen);
1142         session.isReset = false;
1143         // open invest
1144         session.investOpen = true;
1145         session.timeOpen = now;
1146         session.isOpen = true;
1147         SessionOpen(now, sessionId);
1148     }
1149     
1150     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
1151     /// @param _choose choise of investor, true is call, false is put
1152     function invest (bool _choose)
1153         public
1154         payable
1155     {
1156         require(msg.value >= minimunEth && session.investOpen); // msg.value >= 0.1 ether
1157         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
1158         require(session.investorCount < MAX_INVESTOR);
1159         session.investor[session.investorCount] = msg.sender;
1160         session.win[session.investorCount] = _choose;
1161         session.amountInvest[session.investorCount] = msg.value;
1162         session.investorCount += 1;
1163         Invest(msg.sender, _choose, msg.value, now, sessionId);
1164     }
1165     
1166     /// @dev close invest for escrow
1167     /// @param _priceOpen price ETH in USD
1168     function closeInvest (uint _priceOpen) 
1169         public
1170         onlyEscrow
1171     {
1172         require(_priceOpen != 0 && session.investOpen);
1173         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
1174         session.investOpen = false;
1175         session.priceOpen = _priceOpen;
1176         InvestClose(now, _priceOpen, sessionId);
1177     }
1178     
1179     /// @dev get amount of ether to buy NAC for investor
1180     /// @param _ether amount ether which investor invest
1181     /// @param _status true for investor win and false for investor loss
1182     function getEtherToBuy (uint _ether, bool _status)
1183         public
1184         view
1185         returns (uint)
1186     {
1187         if (_status) {
1188             return _ether * rateWin / 100;
1189         } else {
1190             return _ether * rateLoss / 100;
1191         }
1192     }
1193 
1194     /// @dev close session, only escrow can call
1195     /// @param _priceClose price of ETH in USD
1196     function closeSession (uint _priceClose)
1197         public
1198         onlyEscrow
1199     {
1200         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
1201         require(!session.investOpen && session.isOpen);
1202         session.priceClose = _priceClose;
1203         bool result = (_priceClose>session.priceOpen)?true:false;
1204         uint etherToBuy;
1205         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
1206         uint price = namiContract.getPrice();
1207         require(price != 0);
1208         for (uint i = 0; i < session.investorCount; i++) {
1209             if (session.win[i]==result) {
1210                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateWin / 100;
1211                 uint etherReturn = session.amountInvest[i] - session.amountInvest[i] * rateFee / 100;
1212                 (session.investor[i]).transfer(etherReturn);
1213             } else {
1214                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateLoss / 100;
1215             }
1216             namiContract.buy.value(etherToBuy)(session.investor[i]);
1217             // reset investor
1218             session.investor[i] = 0x0;
1219             session.win[i] = false;
1220             session.amountInvest[i] = 0;
1221         }
1222         session.isOpen = false;
1223         SessionClose(now, sessionId, _priceClose, price, rateWin, rateLoss, rateFee);
1224         sessionId += 1;
1225         
1226         // require(!session.isReset && !session.isOpen);
1227         // reset state session
1228         session.priceOpen = 0;
1229         session.priceClose = 0;
1230         session.isReset = true;
1231         session.investOpen = false;
1232         session.investorCount = 0;
1233     }
1234 }
1235 
1236 
1237 contract PresaleToken {
1238     mapping (address => uint256) public balanceOf;
1239     function burnTokens(address _owner) public;
1240 }
1241 
1242  /*
1243  * Contract that is working with ERC223 tokens
1244  */
1245  
1246  /**
1247  * @title Contract that will work with ERC223 tokens.
1248  */
1249  
1250 contract ERC223ReceivingContract {
1251 /**
1252  * @dev Standard ERC223 function that will handle incoming token transfers.
1253  *
1254  * @param _from  Token sender address.
1255  * @param _value Amount of tokens.
1256  * @param _data  Transaction metadata.
1257  */
1258     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
1259     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
1260     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
1261 }
1262 
1263 
1264  /*
1265  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
1266  *
1267  */
1268 
1269 contract NamiExchange {
1270     using SafeMath for uint;
1271     
1272     function NamiExchange(address _namiAddress) public {
1273         NamiAddr = _namiAddress;
1274     }
1275 
1276     event UpdateBid(address owner, uint price, uint balance);
1277     event UpdateAsk(address owner, uint price, uint volume);
1278     event BuyHistory(address indexed buyer, address indexed seller, uint price, uint volume, uint time);
1279     event SellHistory(address indexed seller, address indexed buyer, uint price, uint volume, uint time);
1280 
1281     
1282     mapping(address => OrderBid) public bid;
1283     mapping(address => OrderAsk) public ask;
1284     string public name = "NacExchange";
1285     
1286     /// address of Nami token
1287     address public NamiAddr;
1288     
1289     /// price of Nac = ETH/NAC
1290     uint public price = 1;
1291     // struct store order of user
1292     struct OrderBid {
1293         uint price;
1294         uint eth;
1295     }
1296     
1297     struct OrderAsk {
1298         uint price;
1299         uint volume;
1300     }
1301     
1302         
1303     // prevent lost ether
1304     function() payable public {
1305         require(msg.data.length != 0);
1306         require(msg.value == 0);
1307     }
1308     
1309     modifier onlyNami {
1310         require(msg.sender == NamiAddr);
1311         _;
1312     }
1313     
1314     /////////////////
1315     //---------------------------function about bid Order-----------------------------------------------------------
1316     
1317     function placeBuyOrder(uint _price) payable public {
1318         require(_price > 0 && msg.value > 0 && bid[msg.sender].eth == 0);
1319         if (msg.value > 0) {
1320             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
1321             bid[msg.sender].price = _price;
1322             UpdateBid(msg.sender, _price, bid[msg.sender].eth);
1323         }
1324     }
1325     
1326     function sellNac(uint _value, address _buyer, uint _price) public returns (bool success) {
1327         require(_price == bid[_buyer].price && _buyer != msg.sender);
1328         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1329         uint ethOfBuyer = bid[_buyer].eth;
1330         uint maxToken = ethOfBuyer.mul(bid[_buyer].price);
1331         require(namiToken.allowance(msg.sender, this) >= _value && _value > 0 && ethOfBuyer != 0 && _buyer != 0x0);
1332         if (_value > maxToken) {
1333             if (msg.sender.send(ethOfBuyer) && namiToken.transferFrom(msg.sender,_buyer,maxToken)) {
1334                 // update order
1335                 bid[_buyer].eth = 0;
1336                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
1337                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, maxToken, now);
1338                 return true;
1339             } else {
1340                 // revert anything
1341                 revert();
1342             }
1343         } else {
1344             uint eth = _value.div(bid[_buyer].price);
1345             if (msg.sender.send(eth) && namiToken.transferFrom(msg.sender,_buyer,_value)) {
1346                 // update order
1347                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
1348                 UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
1349                 BuyHistory(_buyer, msg.sender, bid[_buyer].price, _value, now);
1350                 return true;
1351             } else {
1352                 // revert anything
1353                 revert();
1354             }
1355         }
1356     }
1357     
1358     function closeBidOrder() public {
1359         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
1360         // transfer ETH
1361         msg.sender.transfer(bid[msg.sender].eth);
1362         // update order
1363         bid[msg.sender].eth = 0;
1364         UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
1365     }
1366     
1367 
1368     ////////////////
1369     //---------------------------function about ask Order-----------------------------------------------------------
1370     
1371     // place ask order by send NAC to Nami Exchange contract
1372     // this function place sell order
1373     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
1374         require(_price > 0 && _value > 0 && ask[_from].volume == 0);
1375         if (_value > 0) {
1376             ask[_from].volume = (ask[_from].volume).add(_value);
1377             ask[_from].price = _price;
1378             UpdateAsk(_from, _price, ask[_from].volume);
1379         }
1380         return true;
1381     }
1382     
1383     function closeAskOrder() public {
1384         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
1385         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1386         uint previousBalances = namiToken.balanceOf(msg.sender);
1387         // transfer token
1388         namiToken.transfer(msg.sender, ask[msg.sender].volume);
1389         // update order
1390         ask[msg.sender].volume = 0;
1391         UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1392         // check balance
1393         assert(previousBalances < namiToken.balanceOf(msg.sender));
1394     }
1395     
1396     function buyNac(address _seller, uint _price) payable public returns (bool success) {
1397         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1398         require(_price == ask[_seller].price && _seller != msg.sender);
1399         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1400         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1401         uint previousBalances = namiToken.balanceOf(msg.sender);
1402         if (msg.value > maxEth) {
1403             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth))) {
1404                 // transfer token
1405                 namiToken.transfer(msg.sender, ask[_seller].volume);
1406                 SellHistory(_seller, msg.sender, ask[_seller].price, ask[_seller].volume, now);
1407                 // update order
1408                 ask[_seller].volume = 0;
1409                 UpdateAsk(_seller, ask[_seller].price, 0);
1410                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1411                 return true;
1412             } else {
1413                 // revert anything
1414                 revert();
1415             }
1416         } else {
1417             uint nac = (msg.value).mul(ask[_seller].price);
1418             if (_seller.send(msg.value)) {
1419                 // transfer token
1420                 namiToken.transfer(msg.sender, nac);
1421                 // update order
1422                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1423                 UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1424                 SellHistory(_seller, msg.sender, ask[_seller].price, nac, now);
1425                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1426                 return true;
1427             } else {
1428                 // revert anything
1429                 revert();
1430             }
1431         }
1432     }
1433 }
1434 
1435 contract ERC23 {
1436   function balanceOf(address who) public constant returns (uint);
1437   function transfer(address to, uint value) public returns (bool success);
1438 }
1439 
1440 
1441 
1442 /*
1443 * NamiMultiSigWallet smart contract-------------------------------
1444 */
1445 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1446 contract NamiMultiSigWallet {
1447 
1448     uint constant public MAX_OWNER_COUNT = 50;
1449 
1450     event Confirmation(address indexed sender, uint indexed transactionId);
1451     event Revocation(address indexed sender, uint indexed transactionId);
1452     event Submission(uint indexed transactionId);
1453     event Execution(uint indexed transactionId);
1454     event ExecutionFailure(uint indexed transactionId);
1455     event Deposit(address indexed sender, uint value);
1456     event OwnerAddition(address indexed owner);
1457     event OwnerRemoval(address indexed owner);
1458     event RequirementChange(uint required);
1459 
1460     mapping (uint => Transaction) public transactions;
1461     mapping (uint => mapping (address => bool)) public confirmations;
1462     mapping (address => bool) public isOwner;
1463     address[] public owners;
1464     uint public required;
1465     uint public transactionCount;
1466 
1467     struct Transaction {
1468         address destination;
1469         uint value;
1470         bytes data;
1471         bool executed;
1472     }
1473 
1474     modifier onlyWallet() {
1475         require(msg.sender == address(this));
1476         _;
1477     }
1478 
1479     modifier ownerDoesNotExist(address owner) {
1480         require(!isOwner[owner]);
1481         _;
1482     }
1483 
1484     modifier ownerExists(address owner) {
1485         require(isOwner[owner]);
1486         _;
1487     }
1488 
1489     modifier transactionExists(uint transactionId) {
1490         require(transactions[transactionId].destination != 0);
1491         _;
1492     }
1493 
1494     modifier confirmed(uint transactionId, address owner) {
1495         require(confirmations[transactionId][owner]);
1496         _;
1497     }
1498 
1499     modifier notConfirmed(uint transactionId, address owner) {
1500         require(!confirmations[transactionId][owner]);
1501         _;
1502     }
1503 
1504     modifier notExecuted(uint transactionId) {
1505         require(!transactions[transactionId].executed);
1506         _;
1507     }
1508 
1509     modifier notNull(address _address) {
1510         require(_address != 0);
1511         _;
1512     }
1513 
1514     modifier validRequirement(uint ownerCount, uint _required) {
1515         require(!(ownerCount > MAX_OWNER_COUNT
1516             || _required > ownerCount
1517             || _required == 0
1518             || ownerCount == 0));
1519         _;
1520     }
1521 
1522     /// @dev Fallback function allows to deposit ether.
1523     function() public payable {
1524         if (msg.value > 0)
1525             Deposit(msg.sender, msg.value);
1526     }
1527 
1528     /*
1529      * Public functions
1530      */
1531     /// @dev Contract constructor sets initial owners and required number of confirmations.
1532     /// @param _owners List of initial owners.
1533     /// @param _required Number of required confirmations.
1534     function NamiMultiSigWallet(address[] _owners, uint _required)
1535         public
1536         validRequirement(_owners.length, _required)
1537     {
1538         for (uint i = 0; i < _owners.length; i++) {
1539             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1540             isOwner[_owners[i]] = true;
1541         }
1542         owners = _owners;
1543         required = _required;
1544     }
1545 
1546     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1547     /// @param owner Address of new owner.
1548     function addOwner(address owner)
1549         public
1550         onlyWallet
1551         ownerDoesNotExist(owner)
1552         notNull(owner)
1553         validRequirement(owners.length + 1, required)
1554     {
1555         isOwner[owner] = true;
1556         owners.push(owner);
1557         OwnerAddition(owner);
1558     }
1559 
1560     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
1561     /// @param owner Address of owner.
1562     function removeOwner(address owner)
1563         public
1564         onlyWallet
1565         ownerExists(owner)
1566     {
1567         isOwner[owner] = false;
1568         for (uint i=0; i<owners.length - 1; i++) {
1569             if (owners[i] == owner) {
1570                 owners[i] = owners[owners.length - 1];
1571                 break;
1572             }
1573         }
1574         owners.length -= 1;
1575         if (required > owners.length)
1576             changeRequirement(owners.length);
1577         OwnerRemoval(owner);
1578     }
1579 
1580     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
1581     /// @param owner Address of owner to be replaced.
1582     /// @param owner Address of new owner.
1583     function replaceOwner(address owner, address newOwner)
1584         public
1585         onlyWallet
1586         ownerExists(owner)
1587         ownerDoesNotExist(newOwner)
1588     {
1589         for (uint i=0; i<owners.length; i++) {
1590             if (owners[i] == owner) {
1591                 owners[i] = newOwner;
1592                 break;
1593             }
1594         }
1595         isOwner[owner] = false;
1596         isOwner[newOwner] = true;
1597         OwnerRemoval(owner);
1598         OwnerAddition(newOwner);
1599     }
1600 
1601     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
1602     /// @param _required Number of required confirmations.
1603     function changeRequirement(uint _required)
1604         public
1605         onlyWallet
1606         validRequirement(owners.length, _required)
1607     {
1608         required = _required;
1609         RequirementChange(_required);
1610     }
1611 
1612     /// @dev Allows an owner to submit and confirm a transaction.
1613     /// @param destination Transaction target address.
1614     /// @param value Transaction ether value.
1615     /// @param data Transaction data payload.
1616     /// @return Returns transaction ID.
1617     function submitTransaction(address destination, uint value, bytes data)
1618         public
1619         returns (uint transactionId)
1620     {
1621         transactionId = addTransaction(destination, value, data);
1622         confirmTransaction(transactionId);
1623     }
1624 
1625     /// @dev Allows an owner to confirm a transaction.
1626     /// @param transactionId Transaction ID.
1627     function confirmTransaction(uint transactionId)
1628         public
1629         ownerExists(msg.sender)
1630         transactionExists(transactionId)
1631         notConfirmed(transactionId, msg.sender)
1632     {
1633         confirmations[transactionId][msg.sender] = true;
1634         Confirmation(msg.sender, transactionId);
1635         executeTransaction(transactionId);
1636     }
1637 
1638     /// @dev Allows an owner to revoke a confirmation for a transaction.
1639     /// @param transactionId Transaction ID.
1640     function revokeConfirmation(uint transactionId)
1641         public
1642         ownerExists(msg.sender)
1643         confirmed(transactionId, msg.sender)
1644         notExecuted(transactionId)
1645     {
1646         confirmations[transactionId][msg.sender] = false;
1647         Revocation(msg.sender, transactionId);
1648     }
1649 
1650     /// @dev Allows anyone to execute a confirmed transaction.
1651     /// @param transactionId Transaction ID.
1652     function executeTransaction(uint transactionId)
1653         public
1654         notExecuted(transactionId)
1655     {
1656         if (isConfirmed(transactionId)) {
1657             // Transaction tx = transactions[transactionId];
1658             transactions[transactionId].executed = true;
1659             // tx.executed = true;
1660             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
1661                 Execution(transactionId);
1662             } else {
1663                 ExecutionFailure(transactionId);
1664                 transactions[transactionId].executed = false;
1665             }
1666         }
1667     }
1668 
1669     /// @dev Returns the confirmation status of a transaction.
1670     /// @param transactionId Transaction ID.
1671     /// @return Confirmation status.
1672     function isConfirmed(uint transactionId)
1673         public
1674         constant
1675         returns (bool)
1676     {
1677         uint count = 0;
1678         for (uint i = 0; i < owners.length; i++) {
1679             if (confirmations[transactionId][owners[i]])
1680                 count += 1;
1681             if (count == required)
1682                 return true;
1683         }
1684     }
1685 
1686     /*
1687      * Internal functions
1688      */
1689     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
1690     /// @param destination Transaction target address.
1691     /// @param value Transaction ether value.
1692     /// @param data Transaction data payload.
1693     /// @return Returns transaction ID.
1694     function addTransaction(address destination, uint value, bytes data)
1695         internal
1696         notNull(destination)
1697         returns (uint transactionId)
1698     {
1699         transactionId = transactionCount;
1700         transactions[transactionId] = Transaction({
1701             destination: destination, 
1702             value: value,
1703             data: data,
1704             executed: false
1705         });
1706         transactionCount += 1;
1707         Submission(transactionId);
1708     }
1709 
1710     /*
1711      * Web3 call functions
1712      */
1713     /// @dev Returns number of confirmations of a transaction.
1714     /// @param transactionId Transaction ID.
1715     /// @return Number of confirmations.
1716     function getConfirmationCount(uint transactionId)
1717         public
1718         constant
1719         returns (uint count)
1720     {
1721         for (uint i = 0; i < owners.length; i++) {
1722             if (confirmations[transactionId][owners[i]])
1723                 count += 1;
1724         }
1725     }
1726 
1727     /// @dev Returns total number of transactions after filers are applied.
1728     /// @param pending Include pending transactions.
1729     /// @param executed Include executed transactions.
1730     /// @return Total number of transactions after filters are applied.
1731     function getTransactionCount(bool pending, bool executed)
1732         public
1733         constant
1734         returns (uint count)
1735     {
1736         for (uint i = 0; i < transactionCount; i++) {
1737             if (pending && !transactions[i].executed || executed && transactions[i].executed)
1738                 count += 1;
1739         }
1740     }
1741 
1742     /// @dev Returns list of owners.
1743     /// @return List of owner addresses.
1744     function getOwners()
1745         public
1746         constant
1747         returns (address[])
1748     {
1749         return owners;
1750     }
1751 
1752     /// @dev Returns array with owner addresses, which confirmed transaction.
1753     /// @param transactionId Transaction ID.
1754     /// @return Returns array of owner addresses.
1755     function getConfirmations(uint transactionId)
1756         public
1757         constant
1758         returns (address[] _confirmations)
1759     {
1760         address[] memory confirmationsTemp = new address[](owners.length);
1761         uint count = 0;
1762         uint i;
1763         for (i = 0; i < owners.length; i++) {
1764             if (confirmations[transactionId][owners[i]]) {
1765                 confirmationsTemp[count] = owners[i];
1766                 count += 1;
1767             }
1768         }
1769         _confirmations = new address[](count);
1770         for (i = 0; i < count; i++) {
1771             _confirmations[i] = confirmationsTemp[i];
1772         }
1773     }
1774 
1775     /// @dev Returns list of transaction IDs in defined range.
1776     /// @param from Index start position of transaction array.
1777     /// @param to Index end position of transaction array.
1778     /// @param pending Include pending transactions.
1779     /// @param executed Include executed transactions.
1780     /// @return Returns array of transaction IDs.
1781     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1782         public
1783         constant
1784         returns (uint[] _transactionIds)
1785     {
1786         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1787         uint count = 0;
1788         uint i;
1789         for (i = 0; i < transactionCount; i++) {
1790             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
1791                 transactionIdsTemp[count] = i;
1792                 count += 1;
1793             }
1794         }
1795         _transactionIds = new uint[](to - from);
1796         for (i = from; i < to; i++) {
1797             _transactionIds[i - from] = transactionIdsTemp[i];
1798         }
1799     }
1800 }