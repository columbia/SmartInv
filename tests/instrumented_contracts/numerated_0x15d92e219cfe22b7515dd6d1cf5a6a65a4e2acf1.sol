1 pragma solidity ^0.4.21;
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
48 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
49 
50 
51 contract NamiPool {
52     using SafeMath for uint256;
53     
54     function NamiPool(address _escrow, address _namiMultiSigWallet, address _namiAddress) public {
55         require(_namiMultiSigWallet != 0x0);
56         escrow = _escrow;
57         namiMultiSigWallet = _namiMultiSigWallet;
58         NamiAddr = _namiAddress;
59     }
60     
61     string public name = "Nami Pool";
62     
63     // escrow has exclusive priveleges to call administrative
64     // functions on this contract.
65     address public escrow;
66 
67     // Gathered funds can be withdraw only to namimultisigwallet's address.
68     address public namiMultiSigWallet;
69     
70     /// address of Nami token
71     address public NamiAddr;
72     
73     modifier onlyEscrow() {
74         require(msg.sender == escrow);
75         _;
76     }
77     
78     modifier onlyNami {
79         require(msg.sender == NamiAddr);
80         _;
81     }
82     
83     modifier onlyNamiMultisig {
84         require(msg.sender == namiMultiSigWallet);
85         _;
86     }
87     
88     uint public currentRound = 1;
89     
90     struct ShareHolder {
91         uint stake;
92         bool isActive;
93         bool isWithdrawn;
94     }
95     
96     struct Round {
97         bool isOpen;
98         uint currentNAC;
99         uint finalNAC;
100         uint ethBalance;
101         bool withdrawable; //for user not in top
102         bool topWithdrawable;
103         bool isCompleteActive;
104         bool isCloseEthPool;
105     }
106     
107     mapping (uint => mapping (address => ShareHolder)) public namiPool;
108     mapping (uint => Round) public round;
109     
110     
111     // Events
112     event UpdateShareHolder(address indexed ShareHolderAddress, uint indexed RoundIndex, uint Stake, uint Time);
113     event Deposit(address sender,uint indexed RoundIndex, uint value);
114     event WithdrawPool(uint Amount, uint TimeWithdraw);
115     event UpdateActive(address indexed ShareHolderAddress, uint indexed RoundIndex, bool Status, uint Time);
116     event Withdraw(address indexed ShareHolderAddress, uint indexed RoundIndex, uint Ether, uint Nac, uint TimeWithdraw);
117     event ActivateRound(uint RoundIndex, uint TimeActive);
118     
119     
120     function changeEscrow(address _escrow)
121         onlyNamiMultisig
122         public
123     {
124         require(_escrow != 0x0);
125         escrow = _escrow;
126     }
127     
128     function withdrawEther(uint _amount) public
129         onlyEscrow
130     {
131         require(namiMultiSigWallet != 0x0);
132         // 
133         if (address(this).balance > 0) {
134             namiMultiSigWallet.transfer(_amount);
135         }
136     }
137     
138     function withdrawNAC(uint _amount) public
139         onlyEscrow
140     {
141         require(namiMultiSigWallet != 0x0 && _amount != 0);
142         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
143         if (namiToken.balanceOf(this) > 0) {
144             namiToken.transfer(namiMultiSigWallet, _amount);
145         }
146     }
147     
148     
149     /*/
150      *  Admin function
151     /*/
152     
153     /*/ process of one round
154      * step 1: admin open one round by execute activateRound function
155      * step 2: now investor can invest Nac to Nac Pool until round closed
156      * step 3: admin close round, now investor cann't invest NAC to Pool
157      * step 4: admin activate top investor
158      * step 5: all top investor was activated, admin execute closeActive function to close active phrase
159      * step 6: admin open withdrawable for investor not in top to withdraw NAC
160      * step 7: admin deposit eth to eth pool
161      * step 8: close deposit eth to eth pool
162      * step 9: admin open withdrawable to investor in top
163      * step 10: investor in top now can withdraw NAC and ETH for this round
164     /*/
165     
166     // ------------------------------------------------ 
167     /*
168     * Admin function
169     * Open and Close Round
170     *
171     */
172     function activateRound(uint _roundIndex) 
173         onlyEscrow
174         public
175     {
176         require(round[_roundIndex].isOpen == false && round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isCompleteActive == false);
177         round[_roundIndex].isOpen = true;
178         currentRound = _roundIndex;
179         emit ActivateRound(_roundIndex, now);
180     }
181     
182     function deactivateRound(uint _roundIndex)
183         onlyEscrow
184         public
185     {
186         require(round[_roundIndex].isOpen == true);
187         round[_roundIndex].isOpen = false;
188     }
189     
190     // ------------------------------------------------ 
191     // this function add stake of ShareHolder
192     // investor can execute this function during round open
193     //
194     
195     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
196         // only on currentRound and active user can add stake
197         require(round[_price].isOpen == true && _value > 0);
198         // add stake
199         namiPool[_price][_from].stake = namiPool[_price][_from].stake.add(_value);
200         round[_price].currentNAC = round[_price].currentNAC.add(_value);
201         emit UpdateShareHolder(_from, _price, namiPool[_price][_from].stake, now);
202         return true;
203     }
204     
205     
206     /*
207     *
208     * Activate and deactivate user
209     * add or sub final Nac to compute stake to withdraw
210     */
211     function activateUser(address _shareAddress, uint _roundId)
212         onlyEscrow
213         public
214     {
215         require(namiPool[_roundId][_shareAddress].isActive == false && namiPool[_roundId][_shareAddress].stake > 0);
216         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
217         namiPool[_roundId][_shareAddress].isActive = true;
218         round[_roundId].finalNAC = round[_roundId].finalNAC.add(namiPool[_roundId][_shareAddress].stake);
219         emit UpdateActive(_shareAddress, _roundId ,namiPool[_roundId][_shareAddress].isActive, now);
220     }
221     
222     function deactivateUser(address _shareAddress, uint _roundId)
223         onlyEscrow
224         public
225     {
226         require(namiPool[_roundId][_shareAddress].isActive == true && namiPool[_roundId][_shareAddress].stake > 0);
227         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
228         namiPool[_roundId][_shareAddress].isActive = false;
229         round[_roundId].finalNAC = round[_roundId].finalNAC.sub(namiPool[_roundId][_shareAddress].stake);
230         emit UpdateActive(_shareAddress, _roundId ,namiPool[_roundId][_shareAddress].isActive, now);
231     }
232     
233     
234     // ------------------------------------------------ 
235     // admin close activate phrase to 
236     // 
237     //
238     function closeActive(uint _roundId)
239         onlyEscrow
240         public
241     {
242         require(round[_roundId].isCompleteActive == false && round[_roundId].isOpen == false);
243         round[_roundId].isCompleteActive = true;
244     }
245     //
246     //
247     // change Withdrawable for one round after every month
248     // for investor not in top
249     //
250     function changeWithdrawable(uint _roundIndex)
251         onlyEscrow
252         public
253     {
254         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
255         round[_roundIndex].withdrawable = !round[_roundIndex].withdrawable;
256     }
257     
258     
259     
260     //
261     //
262     // change Withdrawable for one round after every month
263     // for investor in top
264     //
265     function changeTopWithdrawable(uint _roundIndex)
266         onlyEscrow
267         public
268     {
269         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
270         round[_roundIndex].topWithdrawable = !round[_roundIndex].topWithdrawable;
271     }
272     
273     
274     //
275     //
276     // after month admin deposit ETH to ETH Pool
277     // 
278     //
279     function depositEthPool(uint _roundIndex)
280         payable public
281         onlyEscrow
282     {
283         require(msg.value > 0 && round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isOpen == false);
284         if (msg.value > 0) {
285             round[_roundIndex].ethBalance = round[_roundIndex].ethBalance.add(msg.value);
286             emit Deposit(msg.sender, _roundIndex, msg.value);
287         }
288     }
289     
290     //
291     //
292     function withdrawEthPool(uint _roundIndex, uint _amount)
293         public
294         onlyEscrow
295     {
296         require(round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isOpen == false);
297         require(namiMultiSigWallet != 0x0);
298         // 
299         if (_amount > 0) {
300             namiMultiSigWallet.transfer(_amount);
301             round[_roundIndex].ethBalance = round[_roundIndex].ethBalance.sub(_amount);
302             emit WithdrawPool(_amount, now);
303         }
304     }
305     
306     //
307     // close phrase deposit ETH to Pool
308     // 
309     function closeEthPool(uint _roundIndex)
310         public
311         onlyEscrow
312     {
313         require(round[_roundIndex].isCloseEthPool == false && round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
314         round[_roundIndex].isCloseEthPool = true;
315     }
316     
317     //
318     //
319     // withdraw NAC for investor
320     // internal function only can run by this smartcontract
321     // 
322     //
323     function _withdrawNAC(address _shareAddress, uint _roundIndex) internal {
324         require(namiPool[_roundIndex][_shareAddress].stake > 0);
325         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
326         uint previousBalances = namiToken.balanceOf(this);
327         namiToken.transfer(_shareAddress, namiPool[_roundIndex][_shareAddress].stake);
328         // update current Nac pool balance
329         round[_roundIndex].currentNAC = round[_roundIndex].currentNAC.sub(namiPool[_roundIndex][_shareAddress].stake);
330         
331         namiPool[_roundIndex][_shareAddress].stake = 0;
332         assert(previousBalances > namiToken.balanceOf(this));
333     }
334     
335     
336     //
337     //
338     // withdraw NAC and ETH for top investor
339     // 
340     //
341     function withdrawTopForTeam(address _shareAddress, uint _roundIndex)
342         onlyEscrow
343         public
344     {
345         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isCloseEthPool == true && round[_roundIndex].isOpen == false);
346         require(round[_roundIndex].topWithdrawable);
347         if(namiPool[_roundIndex][_shareAddress].isActive == true) {
348             require(namiPool[_roundIndex][_shareAddress].isWithdrawn == false);
349             assert(round[_roundIndex].finalNAC > namiPool[_roundIndex][_shareAddress].stake);
350             
351             // compute eth for invester
352             uint ethReturn = (round[_roundIndex].ethBalance.mul(namiPool[_roundIndex][_shareAddress].stake)).div(round[_roundIndex].finalNAC);
353             _shareAddress.transfer(ethReturn);
354             
355             // set user withdraw
356             namiPool[_roundIndex][_shareAddress].isWithdrawn = true;
357             emit Withdraw(_shareAddress, _roundIndex, ethReturn, namiPool[_roundIndex][_shareAddress].stake, now);
358             
359             // withdraw NAC
360             _withdrawNAC(_shareAddress, _roundIndex);
361         }
362     }
363     
364     
365     
366     
367     //
368     //
369     // withdraw NAC and ETH for non top investor
370     // execute by admin only
371     // 
372     //
373     function withdrawNonTopForTeam(address _shareAddress, uint _roundIndex)
374         onlyEscrow
375         public
376     {
377         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
378         require(round[_roundIndex].withdrawable);
379         if(namiPool[_roundIndex][_shareAddress].isActive == false) {
380             require(namiPool[_roundIndex][_shareAddress].isWithdrawn == false);
381             // set state user withdraw
382             namiPool[_roundIndex][_shareAddress].isWithdrawn = true;
383             emit Withdraw(_shareAddress, _roundIndex, 0, namiPool[_roundIndex][_shareAddress].stake, now);
384             //
385             _withdrawNAC(_shareAddress, _roundIndex);
386         }
387     }
388     
389     
390     
391     //
392     //
393     // withdraw NAC and ETH for top investor
394     // execute by investor
395     // 
396     //
397     function withdrawTop(uint _roundIndex)
398         public
399     {
400         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isCloseEthPool == true && round[_roundIndex].isOpen == false);
401         require(round[_roundIndex].topWithdrawable);
402         if(namiPool[_roundIndex][msg.sender].isActive == true) {
403             require(namiPool[_roundIndex][msg.sender].isWithdrawn == false);
404             uint ethReturn = (round[_roundIndex].ethBalance.mul(namiPool[_roundIndex][msg.sender].stake)).div(round[_roundIndex].finalNAC);
405             msg.sender.transfer(ethReturn);
406             // set user withdraw
407             namiPool[_roundIndex][msg.sender].isWithdrawn = true;
408             //
409             emit Withdraw(msg.sender, _roundIndex, ethReturn, namiPool[_roundIndex][msg.sender].stake, now);
410             _withdrawNAC(msg.sender, _roundIndex);
411         }
412     }
413     
414     //
415     //
416     // withdraw NAC and ETH for non top investor
417     // execute by investor
418     // 
419     //
420     function withdrawNonTop(uint _roundIndex)
421         public
422     {
423         require(round[_roundIndex].isCompleteActive == true && round[_roundIndex].isOpen == false);
424         require(round[_roundIndex].withdrawable);
425         if(namiPool[_roundIndex][msg.sender].isActive == false) {
426             require(namiPool[_roundIndex][msg.sender].isWithdrawn == false);
427             namiPool[_roundIndex][msg.sender].isWithdrawn = true;
428             //
429             emit Withdraw(msg.sender, _roundIndex, 0, namiPool[_roundIndex][msg.sender].stake, now);
430             _withdrawNAC(msg.sender, _roundIndex);
431         }
432     }
433     
434 }
435 
436 contract NamiCrowdSale {
437     using SafeMath for uint256;
438 
439     /// NAC Broker Presale Token
440     /// @dev Constructor
441     function NamiCrowdSale(address _escrow, address _namiMultiSigWallet, address _namiPresale) public {
442         require(_namiMultiSigWallet != 0x0);
443         escrow = _escrow;
444         namiMultiSigWallet = _namiMultiSigWallet;
445         namiPresale = _namiPresale;
446     }
447 
448 
449     /*/
450      *  Constants
451     /*/
452 
453     string public name = "Nami ICO";
454     string public  symbol = "NAC";
455     uint   public decimals = 18;
456 
457     bool public TRANSFERABLE = false; // default not transferable
458 
459     uint public constant TOKEN_SUPPLY_LIMIT = 1000000000 * (1 ether / 1 wei);
460     
461     uint public binary = 0;
462 
463     /*/
464      *  Token state
465     /*/
466 
467     enum Phase {
468         Created,
469         Running,
470         Paused,
471         Migrating,
472         Migrated
473     }
474 
475     Phase public currentPhase = Phase.Created;
476     uint public totalSupply = 0; // amount of tokens already sold
477 
478     // escrow has exclusive priveleges to call administrative
479     // functions on this contract.
480     address public escrow;
481 
482     // Gathered funds can be withdraw only to namimultisigwallet's address.
483     address public namiMultiSigWallet;
484 
485     // nami presale contract
486     address public namiPresale;
487 
488     // Crowdsale manager has exclusive priveleges to burn presale tokens.
489     address public crowdsaleManager;
490     
491     // binary option address
492     address public binaryAddress;
493     
494     // This creates an array with all balances
495     mapping (address => uint256) public balanceOf;
496     mapping (address => mapping (address => uint256)) public allowance;
497 
498     modifier onlyCrowdsaleManager() {
499         require(msg.sender == crowdsaleManager); 
500         _; 
501     }
502 
503     modifier onlyEscrow() {
504         require(msg.sender == escrow);
505         _;
506     }
507     
508     modifier onlyTranferable() {
509         require(TRANSFERABLE);
510         _;
511     }
512     
513     modifier onlyNamiMultisig() {
514         require(msg.sender == namiMultiSigWallet);
515         _;
516     }
517     
518     /*/
519      *  Events
520     /*/
521 
522     event LogBuy(address indexed owner, uint value);
523     event LogBurn(address indexed owner, uint value);
524     event LogPhaseSwitch(Phase newPhase);
525     // Log migrate token
526     event LogMigrate(address _from, address _to, uint256 amount);
527     // This generates a public event on the blockchain that will notify clients
528     event Transfer(address indexed from, address indexed to, uint256 value);
529 
530     /*/
531      *  Public functions
532     /*/
533 
534     /**
535      * Internal transfer, only can be called by this contract
536      */
537     function _transfer(address _from, address _to, uint _value) internal {
538         // Prevent transfer to 0x0 address. Use burn() instead
539         require(_to != 0x0);
540         // Check if the sender has enough
541         require(balanceOf[_from] >= _value);
542         // Check for overflows
543         require(balanceOf[_to] + _value > balanceOf[_to]);
544         // Save this for an assertion in the future
545         uint previousBalances = balanceOf[_from] + balanceOf[_to];
546         // Subtract from the sender
547         balanceOf[_from] -= _value;
548         // Add the same to the recipient
549         balanceOf[_to] += _value;
550         emit Transfer(_from, _to, _value);
551         // Asserts are used to use static analysis to find bugs in your code. They should never fail
552         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
553     }
554 
555     // Transfer the balance from owner's account to another account
556     // only escrow can send token (to send token private sale)
557     function transferForTeam(address _to, uint256 _value) public
558         onlyEscrow
559     {
560         _transfer(msg.sender, _to, _value);
561     }
562     
563     /**
564      * Transfer tokens
565      *
566      * Send `_value` tokens to `_to` from your account
567      *
568      * @param _to The address of the recipient
569      * @param _value the amount to send
570      */
571     function transfer(address _to, uint256 _value) public
572         onlyTranferable
573     {
574         _transfer(msg.sender, _to, _value);
575     }
576     
577        /**
578      * Transfer tokens from other address
579      *
580      * Send `_value` tokens to `_to` in behalf of `_from`
581      *
582      * @param _from The address of the sender
583      * @param _to The address of the recipient
584      * @param _value the amount to send
585      */
586     function transferFrom(address _from, address _to, uint256 _value) 
587         public
588         onlyTranferable
589         returns (bool success)
590     {
591         require(_value <= allowance[_from][msg.sender]);     // Check allowance
592         allowance[_from][msg.sender] -= _value;
593         _transfer(_from, _to, _value);
594         return true;
595     }
596 
597     /**
598      * Set allowance for other address
599      *
600      * Allows `_spender` to spend no more than `_value` tokens in your behalf
601      *
602      * @param _spender The address authorized to spend
603      * @param _value the max amount they can spend
604      */
605     function approve(address _spender, uint256 _value) public
606         onlyTranferable
607         returns (bool success) 
608     {
609         allowance[msg.sender][_spender] = _value;
610         return true;
611     }
612 
613     /**
614      * Set allowance for other address and notify
615      *
616      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
617      *
618      * @param _spender The address authorized to spend
619      * @param _value the max amount they can spend
620      * @param _extraData some extra information to send to the approved contract
621      */
622     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
623         public
624         onlyTranferable
625         returns (bool success) 
626     {
627         tokenRecipient spender = tokenRecipient(_spender);
628         if (approve(_spender, _value)) {
629             spender.receiveApproval(msg.sender, _value, this, _extraData);
630             return true;
631         }
632     }
633 
634     // allows transfer token
635     function changeTransferable () public
636         onlyEscrow
637     {
638         TRANSFERABLE = !TRANSFERABLE;
639     }
640     
641     // change escrow
642     function changeEscrow(address _escrow) public
643         onlyNamiMultisig
644     {
645         require(_escrow != 0x0);
646         escrow = _escrow;
647     }
648     
649     // change binary value
650     function changeBinary(uint _binary)
651         public
652         onlyEscrow
653     {
654         binary = _binary;
655     }
656     
657     // change binary address
658     function changeBinaryAddress(address _binaryAddress)
659         public
660         onlyEscrow
661     {
662         require(_binaryAddress != 0x0);
663         binaryAddress = _binaryAddress;
664     }
665     
666     /*
667     * price in ICO:
668     * first week: 1 ETH = 2400 NAC
669     * second week: 1 ETH = 23000 NAC
670     * 3rd week: 1 ETH = 2200 NAC
671     * 4th week: 1 ETH = 2100 NAC
672     * 5th week: 1 ETH = 2000 NAC
673     * 6th week: 1 ETH = 1900 NAC
674     * 7th week: 1 ETH = 1800 NAC
675     * 8th week: 1 ETH = 1700 nac
676     * time: 
677     * 1517443200: Thursday, February 1, 2018 12:00:00 AM
678     * 1518048000: Thursday, February 8, 2018 12:00:00 AM
679     * 1518652800: Thursday, February 15, 2018 12:00:00 AM
680     * 1519257600: Thursday, February 22, 2018 12:00:00 AM
681     * 1519862400: Thursday, March 1, 2018 12:00:00 AM
682     * 1520467200: Thursday, March 8, 2018 12:00:00 AM
683     * 1521072000: Thursday, March 15, 2018 12:00:00 AM
684     * 1521676800: Thursday, March 22, 2018 12:00:00 AM
685     * 1522281600: Thursday, March 29, 2018 12:00:00 AM
686     */
687     function getPrice() public view returns (uint price) {
688         if (now < 1517443200) {
689             // presale
690             return 3450;
691         } else if (1517443200 < now && now <= 1518048000) {
692             // 1st week
693             return 2400;
694         } else if (1518048000 < now && now <= 1518652800) {
695             // 2nd week
696             return 2300;
697         } else if (1518652800 < now && now <= 1519257600) {
698             // 3rd week
699             return 2200;
700         } else if (1519257600 < now && now <= 1519862400) {
701             // 4th week
702             return 2100;
703         } else if (1519862400 < now && now <= 1520467200) {
704             // 5th week
705             return 2000;
706         } else if (1520467200 < now && now <= 1521072000) {
707             // 6th week
708             return 1900;
709         } else if (1521072000 < now && now <= 1521676800) {
710             // 7th week
711             return 1800;
712         } else if (1521676800 < now && now <= 1522281600) {
713             // 8th week
714             return 1700;
715         } else {
716             return binary;
717         }
718     }
719 
720 
721     function() payable public {
722         buy(msg.sender);
723     }
724     
725     
726     function buy(address _buyer) payable public {
727         // Available only if presale is running.
728         require(currentPhase == Phase.Running);
729         // require ICO time or binary option
730         require(now <= 1522281600 || msg.sender == binaryAddress);
731         require(msg.value != 0);
732         uint newTokens = msg.value * getPrice();
733         require (totalSupply + newTokens < TOKEN_SUPPLY_LIMIT);
734         // add new token to buyer
735         balanceOf[_buyer] = balanceOf[_buyer].add(newTokens);
736         // add new token to totalSupply
737         totalSupply = totalSupply.add(newTokens);
738         emit LogBuy(_buyer,newTokens);
739         emit Transfer(this,_buyer,newTokens);
740     }
741     
742 
743     /// @dev Returns number of tokens owned by given address.
744     /// @param _owner Address of token owner.
745     function burnTokens(address _owner) public
746         onlyCrowdsaleManager
747     {
748         // Available only during migration phase
749         require(currentPhase == Phase.Migrating);
750 
751         uint tokens = balanceOf[_owner];
752         require(tokens != 0);
753         balanceOf[_owner] = 0;
754         totalSupply -= tokens;
755         emit LogBurn(_owner, tokens);
756         emit Transfer(_owner, crowdsaleManager, tokens);
757 
758         // Automatically switch phase when migration is done.
759         if (totalSupply == 0) {
760             currentPhase = Phase.Migrated;
761             emit LogPhaseSwitch(Phase.Migrated);
762         }
763     }
764 
765 
766     /*/
767      *  Administrative functions
768     /*/
769     function setPresalePhase(Phase _nextPhase) public
770         onlyEscrow
771     {
772         bool canSwitchPhase
773             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
774             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
775                 // switch to migration phase only if crowdsale manager is set
776             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
777                 && _nextPhase == Phase.Migrating
778                 && crowdsaleManager != 0x0)
779             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
780                 // switch to migrated only if everyting is migrated
781             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
782                 && totalSupply == 0);
783 
784         require(canSwitchPhase);
785         currentPhase = _nextPhase;
786         emit LogPhaseSwitch(_nextPhase);
787     }
788 
789 
790     function withdrawEther(uint _amount) public
791         onlyEscrow
792     {
793         require(namiMultiSigWallet != 0x0);
794         // Available at any phase.
795         if (address(this).balance > 0) {
796             namiMultiSigWallet.transfer(_amount);
797         }
798     }
799     
800     function safeWithdraw(address _withdraw, uint _amount) public
801         onlyEscrow
802     {
803         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
804         if (namiWallet.isOwner(_withdraw)) {
805             _withdraw.transfer(_amount);
806         }
807     }
808 
809 
810     function setCrowdsaleManager(address _mgr) public
811         onlyEscrow
812     {
813         // You can't change crowdsale contract when migration is in progress.
814         require(currentPhase != Phase.Migrating);
815         crowdsaleManager = _mgr;
816     }
817 
818     // internal migrate migration tokens
819     function _migrateToken(address _from, address _to)
820         internal
821     {
822         PresaleToken presale = PresaleToken(namiPresale);
823         uint256 newToken = presale.balanceOf(_from);
824         require(newToken > 0);
825         // burn old token
826         presale.burnTokens(_from);
827         // add new token to _to
828         balanceOf[_to] = balanceOf[_to].add(newToken);
829         // add new token to totalSupply
830         totalSupply = totalSupply.add(newToken);
831         emit LogMigrate(_from, _to, newToken);
832         emit Transfer(this,_to,newToken);
833     }
834 
835     // migate token function for Nami Team
836     function migrateToken(address _from, address _to) public
837         onlyEscrow
838     {
839         _migrateToken(_from, _to);
840     }
841 
842     // migrate token for investor
843     function migrateForInvestor() public {
844         _migrateToken(msg.sender, msg.sender);
845     }
846 
847     // Nami internal exchange
848     
849     // event for Nami exchange
850     event TransferToBuyer(address indexed _from, address indexed _to, uint _value, address indexed _seller);
851     event TransferToExchange(address indexed _from, address indexed _to, uint _value, uint _price);
852     
853     
854     /**
855      * @dev Transfer the specified amount of tokens to the NamiExchange address.
856      *      Invokes the `tokenFallbackExchange` function.
857      *      The token transfer fails if the recipient is a contract
858      *      but does not implement the `tokenFallbackExchange` function
859      *      or the fallback function to receive funds.
860      *
861      * @param _to    Receiver address.
862      * @param _value Amount of tokens that will be transferred.
863      * @param _price price to sell token.
864      */
865      
866     function transferToExchange(address _to, uint _value, uint _price) public {
867         uint codeLength;
868         
869         assembly {
870             codeLength := extcodesize(_to)
871         }
872         
873         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
874         balanceOf[_to] = balanceOf[_to].add(_value);
875         emit Transfer(msg.sender,_to,_value);
876         if (codeLength > 0) {
877             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
878             receiver.tokenFallbackExchange(msg.sender, _value, _price);
879             emit TransferToExchange(msg.sender, _to, _value, _price);
880         }
881     }
882     
883     /**
884      * @dev Transfer the specified amount of tokens to the NamiExchange address.
885      *      Invokes the `tokenFallbackBuyer` function.
886      *      The token transfer fails if the recipient is a contract
887      *      but does not implement the `tokenFallbackBuyer` function
888      *      or the fallback function to receive funds.
889      *
890      * @param _to    Receiver address.
891      * @param _value Amount of tokens that will be transferred.
892      * @param _buyer address of seller.
893      */
894      
895     function transferToBuyer(address _to, uint _value, address _buyer) public {
896         uint codeLength;
897         
898         assembly {
899             codeLength := extcodesize(_to)
900         }
901         
902         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
903         balanceOf[_to] = balanceOf[_to].add(_value);
904         emit Transfer(msg.sender,_to,_value);
905         if (codeLength > 0) {
906             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
907             receiver.tokenFallbackBuyer(msg.sender, _value, _buyer);
908             emit TransferToBuyer(msg.sender, _to, _value, _buyer);
909         }
910     }
911 //-------------------------------------------------------------------------------------------------------
912 }
913 
914 
915 /*
916 * Binary option smart contract-------------------------------
917 */
918 contract BinaryOption {
919     /*
920      * binary option controled by escrow to buy NAC with good price
921      */
922     // NamiCrowdSale address
923     address public namiCrowdSaleAddr;
924     address public escrow;
925     
926     // namiMultiSigWallet
927     address public namiMultiSigWallet;
928     
929     Session public session;
930     uint public timeInvestInMinute = 15;
931     uint public timeOneSession = 20;
932     uint public sessionId = 1;
933     uint public rateWin = 100;
934     uint public rateLoss = 20;
935     uint public rateFee = 5;
936     uint public constant MAX_INVESTOR = 20;
937     uint public minimunEth = 10000000000000000; // minimunEth = 0.01 eth
938     /**
939      * Events for binany option system
940      */
941     event SessionOpen(uint timeOpen, uint indexed sessionId);
942     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
943     event Invest(address indexed investor, bool choose, uint amount, uint timeInvest, uint indexed sessionId);
944     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint nacPrice, uint rateWin, uint rateLoss, uint rateFee);
945 
946     event Deposit(address indexed sender, uint value);
947     /// @dev Fallback function allows to deposit ether.
948     function() public payable {
949         if (msg.value > 0)
950             emit Deposit(msg.sender, msg.value);
951     }
952     // there is only one session available at one timeOpen
953     // priceOpen is price of ETH in USD
954     // priceClose is price of ETH in USD
955     // process of one Session
956     // 1st: escrow reset session by run resetSession()
957     // 2nd: escrow open session by run openSession() => save timeOpen at this time
958     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
959     // 4th: escrow close invest and insert price open for this Session
960     // 5th: escrow close session and send NAC for investor
961     struct Session {
962         uint priceOpen;
963         uint priceClose;
964         uint timeOpen;
965         bool isReset;
966         bool isOpen;
967         bool investOpen;
968         uint investorCount;
969         mapping(uint => address) investor;
970         mapping(uint => bool) win;
971         mapping(uint => uint) amountInvest;
972     }
973     
974     function BinaryOption(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
975         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
976         namiCrowdSaleAddr = _namiCrowdSale;
977         escrow = _escrow;
978         namiMultiSigWallet = _namiMultiSigWallet;
979     }
980     
981     
982     modifier onlyEscrow() {
983         require(msg.sender==escrow);
984         _;
985     }
986     
987         
988     modifier onlyNamiMultisig() {
989         require(msg.sender == namiMultiSigWallet);
990         _;
991     }
992     
993     // change escrow
994     function changeEscrow(address _escrow) public
995         onlyNamiMultisig
996     {
997         require(_escrow != 0x0);
998         escrow = _escrow;
999     }
1000     
1001     // chagne minimunEth
1002     function changeMinEth(uint _minimunEth) public 
1003         onlyEscrow
1004     {
1005         require(_minimunEth != 0);
1006         minimunEth = _minimunEth;
1007     }
1008     
1009     /// @dev Change time for investor can invest in one session, can only change at time not in session
1010     /// @param _timeInvest time invest in minutes
1011     ///---------------------------change time function------------------------------
1012     function changeTimeInvest(uint _timeInvest)
1013         public
1014         onlyEscrow
1015     {
1016         require(!session.isOpen && _timeInvest < timeOneSession);
1017         timeInvestInMinute = _timeInvest;
1018     }
1019 
1020     function changeTimeOneSession(uint _timeOneSession) 
1021         public
1022         onlyEscrow
1023     {
1024         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
1025         timeOneSession = _timeOneSession;
1026     }
1027 
1028     /////------------------------change rate function-------------------------------
1029     
1030     function changeRateWin(uint _rateWin)
1031         public
1032         onlyEscrow
1033     {
1034         require(!session.isOpen);
1035         rateWin = _rateWin;
1036     }
1037     
1038     function changeRateLoss(uint _rateLoss)
1039         public
1040         onlyEscrow
1041     {
1042         require(!session.isOpen);
1043         rateLoss = _rateLoss;
1044     }
1045     
1046     function changeRateFee(uint _rateFee)
1047         public
1048         onlyEscrow
1049     {
1050         require(!session.isOpen);
1051         rateFee = _rateFee;
1052     }
1053     
1054     
1055     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1056     /// @param _amount value ether in wei to withdraw
1057     function withdrawEther(uint _amount) public
1058         onlyEscrow
1059     {
1060         require(namiMultiSigWallet != 0x0);
1061         // Available at any phase.
1062         if (address(this).balance > 0) {
1063             namiMultiSigWallet.transfer(_amount);
1064         }
1065     }
1066     
1067     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
1068     /// @param _withdraw address to withdraw
1069     function safeWithdraw(address _withdraw, uint _amount) public
1070         onlyEscrow
1071     {
1072         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
1073         if (namiWallet.isOwner(_withdraw)) {
1074             _withdraw.transfer(_amount);
1075         }
1076     }
1077     
1078     // @dev Returns list of owners.
1079     // @return List of owner addresses.
1080     // MAX_INVESTOR = 20
1081     function getInvestors()
1082         public
1083         view
1084         returns (address[20])
1085     {
1086         address[20] memory listInvestor;
1087         for (uint i = 0; i < MAX_INVESTOR; i++) {
1088             listInvestor[i] = session.investor[i];
1089         }
1090         return listInvestor;
1091     }
1092     
1093     function getChooses()
1094         public
1095         view
1096         returns (bool[20])
1097     {
1098         bool[20] memory listChooses;
1099         for (uint i = 0; i < MAX_INVESTOR; i++) {
1100             listChooses[i] = session.win[i];
1101         }
1102         return listChooses;
1103     }
1104     
1105     function getAmount()
1106         public
1107         view
1108         returns (uint[20])
1109     {
1110         uint[20] memory listAmount;
1111         for (uint i = 0; i < MAX_INVESTOR; i++) {
1112             listAmount[i] = session.amountInvest[i];
1113         }
1114         return listAmount;
1115     }
1116     
1117     /// @dev reset all data of previous session, must run before open new session
1118     // only escrow can call
1119     function resetSession()
1120         public
1121         onlyEscrow
1122     {
1123         require(!session.isReset && !session.isOpen);
1124         session.priceOpen = 0;
1125         session.priceClose = 0;
1126         session.isReset = true;
1127         session.isOpen = false;
1128         session.investOpen = false;
1129         session.investorCount = 0;
1130         for (uint i = 0; i < MAX_INVESTOR; i++) {
1131             session.investor[i] = 0x0;
1132             session.win[i] = false;
1133             session.amountInvest[i] = 0;
1134         }
1135     }
1136     
1137     /// @dev Open new session, only escrow can call
1138     function openSession ()
1139         public
1140         onlyEscrow
1141     {
1142         require(session.isReset && !session.isOpen);
1143         session.isReset = false;
1144         // open invest
1145         session.investOpen = true;
1146         session.timeOpen = now;
1147         session.isOpen = true;
1148         emit SessionOpen(now, sessionId);
1149     }
1150     
1151     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
1152     /// @param _choose choise of investor, true is call, false is put
1153     function invest (bool _choose)
1154         public
1155         payable
1156     {
1157         require(msg.value >= minimunEth && session.investOpen); // msg.value >= 0.1 ether
1158         require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
1159         require(session.investorCount < MAX_INVESTOR);
1160         session.investor[session.investorCount] = msg.sender;
1161         session.win[session.investorCount] = _choose;
1162         session.amountInvest[session.investorCount] = msg.value;
1163         session.investorCount += 1;
1164         emit Invest(msg.sender, _choose, msg.value, now, sessionId);
1165     }
1166     
1167     /// @dev close invest for escrow
1168     /// @param _priceOpen price ETH in USD
1169     function closeInvest (uint _priceOpen) 
1170         public
1171         onlyEscrow
1172     {
1173         require(_priceOpen != 0 && session.investOpen);
1174         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
1175         session.investOpen = false;
1176         session.priceOpen = _priceOpen;
1177         emit InvestClose(now, _priceOpen, sessionId);
1178     }
1179     
1180     /// @dev get amount of ether to buy NAC for investor
1181     /// @param _ether amount ether which investor invest
1182     /// @param _status true for investor win and false for investor loss
1183     function getEtherToBuy (uint _ether, bool _status)
1184         public
1185         view
1186         returns (uint)
1187     {
1188         if (_status) {
1189             return _ether * rateWin / 100;
1190         } else {
1191             return _ether * rateLoss / 100;
1192         }
1193     }
1194 
1195     /// @dev close session, only escrow can call
1196     /// @param _priceClose price of ETH in USD
1197     function closeSession (uint _priceClose)
1198         public
1199         onlyEscrow
1200     {
1201         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
1202         require(!session.investOpen && session.isOpen);
1203         session.priceClose = _priceClose;
1204         bool result = (_priceClose>session.priceOpen)?true:false;
1205         uint etherToBuy;
1206         NamiCrowdSale namiContract = NamiCrowdSale(namiCrowdSaleAddr);
1207         uint price = namiContract.getPrice();
1208         require(price != 0);
1209         for (uint i = 0; i < session.investorCount; i++) {
1210             if (session.win[i]==result) {
1211                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateWin / 100;
1212                 uint etherReturn = session.amountInvest[i] - session.amountInvest[i] * rateFee / 100;
1213                 (session.investor[i]).transfer(etherReturn);
1214             } else {
1215                 etherToBuy = (session.amountInvest[i] - session.amountInvest[i] * rateFee / 100) * rateLoss / 100;
1216             }
1217             namiContract.buy.value(etherToBuy)(session.investor[i]);
1218             // reset investor
1219             session.investor[i] = 0x0;
1220             session.win[i] = false;
1221             session.amountInvest[i] = 0;
1222         }
1223         session.isOpen = false;
1224         emit SessionClose(now, sessionId, _priceClose, price, rateWin, rateLoss, rateFee);
1225         sessionId += 1;
1226         
1227         // require(!session.isReset && !session.isOpen);
1228         // reset state session
1229         session.priceOpen = 0;
1230         session.priceClose = 0;
1231         session.isReset = true;
1232         session.investOpen = false;
1233         session.investorCount = 0;
1234     }
1235 }
1236 
1237 
1238 
1239 
1240 
1241 /*
1242 * Binary option smart contract NAC to ETH-------------------------------
1243 */
1244 contract BinaryOptionV2 {
1245     using SafeMath for uint256;
1246     /*
1247      * binary option controled by escrow to buy NAC with good price
1248      */
1249     // NamiCrowdSale address
1250     address public NamiAddr;
1251     address public escrow;
1252     
1253     // namiMultiSigWallet
1254     address public namiMultiSigWallet;
1255     
1256     Session public session;
1257     uint public timeInvestInMinute = 15;
1258     uint public timeOneSession = 20;
1259     uint public sessionId = 1;
1260     uint public rateWin = 100;
1261     uint public rateLoss = 0;
1262     uint public rateFee = 5;
1263     uint public constant MAX_INVESTOR = 20;
1264     uint public minNac = 100000000000000000000; // 100 Nac
1265     uint public totalFci = 0;
1266     uint public totalNacInPool = 0;
1267     bool isEmptyPool = true;
1268     bool public isTradableFciInSession = false;
1269     /**
1270      * Events for binany option system
1271      */
1272     event SessionOpen(uint timeOpen, uint indexed sessionId);
1273     event InvestClose(uint timeInvestClose, uint priceOpen, uint indexed sessionId);
1274     event Invest(address indexed investor, uint choose, uint amount, uint timeInvest, uint indexed sessionId);
1275     event InvestToPool(address indexed investor, uint amount, uint timeInvest);
1276     event SessionClose(uint timeClose, uint indexed sessionId, uint priceClose, uint rateWin, uint rateLoss, uint rateFee);
1277 
1278     event Deposit(address indexed sender, uint value);
1279     /// @dev Fallback function allows to deposit ether.
1280     function() public payable {
1281         if (msg.value > 0)
1282             emit Deposit(msg.sender, msg.value);
1283     }
1284     
1285     // there is only one session available at one timeOpen
1286     // priceOpen is price of ETH in USD
1287     // priceClose is price of ETH in USD
1288     // process of one Session
1289     // 1st: escrow reset session by run resetSession()
1290     // 2nd: escrow open session by run openSession() => save timeOpen at this time
1291     // 3rd: all investor can invest by run invest(), send minimum 0.1 ETH
1292     // 4th: escrow close invest and insert price open for this Session
1293     // 5th: escrow close session and send NAC for investor
1294     struct Session {
1295         uint priceOpen;
1296         uint priceClose;
1297         uint timeOpen;
1298         bool isReset;
1299         bool isOpen;
1300         bool investOpen;
1301         uint investorCount;
1302         mapping(uint => address) investor;
1303         mapping(uint => uint) win;
1304         mapping(uint => uint) amountInvest;
1305     }
1306     
1307     // list fci
1308     mapping(address => uint) public fci;
1309     
1310     function BinaryOptionV2(address _namiCrowdSale, address _escrow, address _namiMultiSigWallet) public {
1311         require(_namiCrowdSale != 0x0 && _escrow != 0x0);
1312         NamiAddr = _namiCrowdSale;
1313         escrow = _escrow;
1314         namiMultiSigWallet = _namiMultiSigWallet;
1315     }
1316     
1317     
1318     modifier onlyEscrow() {
1319         require(msg.sender==escrow);
1320         _;
1321     }
1322     
1323     modifier onlyNami {
1324         require(msg.sender == NamiAddr);
1325         _;
1326     }
1327     
1328         
1329     modifier onlyNamiMultisig() {
1330         require(msg.sender == namiMultiSigWallet);
1331         _;
1332     }
1333     
1334     // change escrow
1335     function changeEscrow(address _escrow) public
1336         onlyNamiMultisig
1337     {
1338         require(_escrow != 0x0);
1339         escrow = _escrow;
1340     }
1341     
1342     // change minimum nac in one order
1343     function changeMinNac(uint _minNAC) public
1344         onlyEscrow
1345     {
1346         require(_minNAC != 0);
1347         minNac = _minNAC;
1348     }
1349     
1350     /// @dev Change time for investor can invest in one session, can only change at time not in session
1351     /// @param _timeInvest time invest in minutes
1352     ///---------------------------change time function------------------------------
1353     function changeTimeInvest(uint _timeInvest)
1354         public
1355         onlyEscrow
1356     {
1357         require(!session.isOpen && _timeInvest < timeOneSession);
1358         timeInvestInMinute = _timeInvest;
1359     }
1360 
1361     function changeTimeOneSession(uint _timeOneSession) 
1362         public
1363         onlyEscrow
1364     {
1365         require(!session.isOpen && _timeOneSession > timeInvestInMinute);
1366         timeOneSession = _timeOneSession;
1367     }
1368     
1369     function changeTradableFciInSession(bool _isTradableFciInPool)
1370         public
1371         onlyEscrow
1372     {
1373         isTradableFciInSession = _isTradableFciInPool;
1374     }
1375 
1376     
1377     /////------------------------change rate function-------------------------------
1378     
1379     function changeRateWin(uint _rateWin)
1380         public
1381         onlyEscrow
1382     {
1383         require(!session.isOpen);
1384         rateWin = _rateWin;
1385     }
1386     
1387     function changeRateLoss(uint _rateLoss)
1388         public
1389         onlyEscrow
1390     {
1391         require(!session.isOpen);
1392         rateLoss = _rateLoss;
1393     }
1394     
1395     function changeRateFee(uint _rateFee)
1396         public
1397         onlyEscrow
1398     {
1399         require(!session.isOpen);
1400         rateFee = _rateFee;
1401     }
1402     
1403     
1404     /// @dev withdraw ether to nami multisignature wallet, only escrow can call
1405     /// @param _amount value ether in wei to withdraw
1406     function withdrawEther(uint _amount) public
1407         onlyEscrow
1408     {
1409         require(namiMultiSigWallet != 0x0);
1410         // Available at any phase.
1411         if (address(this).balance > 0) {
1412             namiMultiSigWallet.transfer(_amount);
1413         }
1414     }
1415     
1416     
1417     /// @dev withdraw NAC to nami multisignature wallet, only escrow can call
1418     /// @param _amount value NAC to withdraw
1419     function withdrawNac(uint _amount) public
1420         onlyEscrow
1421     {
1422         require(namiMultiSigWallet != 0x0);
1423         // Available at any phase.
1424         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1425         if (namiToken.balanceOf(address(this)) > 0) {
1426             namiToken.transfer(namiMultiSigWallet, _amount);
1427         }
1428     }
1429     
1430         
1431     /// @dev safe withdraw Ether to one of owner of nami multisignature wallet
1432     /// @param _withdraw address to withdraw
1433     function safeWithdraw(address _withdraw, uint _amount) public
1434         onlyEscrow
1435     {
1436         NamiMultiSigWallet namiWallet = NamiMultiSigWallet(namiMultiSigWallet);
1437         if (namiWallet.isOwner(_withdraw)) {
1438             _withdraw.transfer(_amount);
1439         }
1440     }
1441     
1442     // @dev Returns list of owners.
1443     // @return List of owner addresses.
1444     // MAX_INVESTOR = 20
1445     function getInvestors()
1446         public
1447         view
1448         returns (address[20])
1449     {
1450         address[20] memory listInvestor;
1451         for (uint i = 0; i < MAX_INVESTOR; i++) {
1452             listInvestor[i] = session.investor[i];
1453         }
1454         return listInvestor;
1455     }
1456     
1457     function getChooses()
1458         public
1459         view
1460         returns (uint[20])
1461     {
1462         uint[20] memory listChooses;
1463         for (uint i = 0; i < MAX_INVESTOR; i++) {
1464             listChooses[i] = session.win[i];
1465         }
1466         return listChooses;
1467     }
1468     
1469     function getAmount()
1470         public
1471         view
1472         returns (uint[20])
1473     {
1474         uint[20] memory listAmount;
1475         for (uint i = 0; i < MAX_INVESTOR; i++) {
1476             listAmount[i] = session.amountInvest[i];
1477         }
1478         return listAmount;
1479     }
1480     
1481     /// @dev reset all data of previous session, must run before open new session
1482     // only escrow can call
1483     function resetSession()
1484         public
1485         onlyEscrow
1486     {
1487         require(!session.isReset && !session.isOpen);
1488         session.priceOpen = 0;
1489         session.priceClose = 0;
1490         session.isReset = true;
1491         session.isOpen = false;
1492         session.investOpen = false;
1493         session.investorCount = 0;
1494         for (uint i = 0; i < MAX_INVESTOR; i++) {
1495             session.investor[i] = 0x0;
1496             session.win[i] = 0;
1497             session.amountInvest[i] = 0;
1498         }
1499     }
1500     
1501     /// @dev Open new session, only escrow can call
1502     function openSession ()
1503         public
1504         onlyEscrow
1505     {
1506         require(totalNacInPool > 0);
1507         require(session.isReset && !session.isOpen);
1508         session.isReset = false;
1509         // open invest
1510         session.investOpen = true;
1511         session.timeOpen = now;
1512         session.isOpen = true;
1513         emit SessionOpen(now, sessionId);
1514     }
1515     
1516     function setPoolStatus()
1517         public
1518         onlyEscrow
1519     {
1520         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1521         if(namiToken.balanceOf(address(this)) == 0) {
1522             isEmptyPool = true;
1523         } else {
1524             isEmptyPool = false;
1525         }
1526     }
1527     
1528     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
1529     /// @param _choose choise of investor, true is call, false is put
1530     // function invest (bool _choose)
1531     //     public
1532     //     payable
1533     // {
1534     //     require(msg.value >= minimunEth && session.investOpen); // msg.value >= 0.1 ether
1535     //     require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
1536     //     require(session.investorCount < MAX_INVESTOR);
1537     //     session.investor[session.investorCount] = msg.sender;
1538     //     session.win[session.investorCount] = _choose;
1539     //     session.amountInvest[session.investorCount] = msg.value;
1540     //     session.investorCount += 1;
1541     //     Invest(msg.sender, _choose, msg.value, now, sessionId);
1542     // }
1543     
1544     
1545     // ------------------------------------------------ 
1546     /// @dev Fuction for investor, minimun ether send is 0.1, one address can call one time in one session
1547     /// @param _choose choise of investor, true is call, false is put
1548     
1549     function tokenFallbackExchange(address _from, uint _value, uint _choose) onlyNami public returns (bool success) {
1550         if(_choose < 2) {
1551             require(_value >= minNac && session.investOpen); // msg.value >= 0.1 ether
1552             require(now < (session.timeOpen + timeInvestInMinute * 1 minutes));
1553             require(session.investorCount < MAX_INVESTOR);
1554             //
1555             session.investor[session.investorCount] = _from;
1556             session.win[session.investorCount] = _choose;
1557             session.amountInvest[session.investorCount] = _value;
1558             session.investorCount += 1;
1559             emit Invest(_from, _choose, _value, now, sessionId);
1560         } else {
1561             require(_choose==2 && _value > 0);
1562             bool check = (!session.isOpen) || isTradableFciInSession;
1563             require(check);
1564             // check pool empty
1565             if(isEmptyPool==true) {
1566                 fci[_from] = (fci[_from]).add(_value);
1567                 totalNacInPool = totalNacInPool.add(_value);
1568                 totalFci = totalFci.add(_value);
1569                 if(totalNacInPool > 0) {
1570                     isEmptyPool = false;
1571                 }
1572             } else {
1573                 uint fciReceive = (_value.mul(totalFci)).div(totalNacInPool);
1574                 // check fci receive
1575                 require(fciReceive > 0);
1576                 fci[_from] = fci[_from].add(fciReceive);
1577                 totalNacInPool = totalNacInPool.add(_value);
1578                 totalFci = totalFci.add(fciReceive);
1579                 if(totalNacInPool > 0) {
1580                     isEmptyPool = false;
1581                 }
1582             }
1583             // add shareHolder
1584             // uint fciReceive = 
1585             emit InvestToPool(_from, _value, now);
1586         }
1587         return true;
1588     }
1589     
1590     // sell fci and receive NAC back
1591     
1592     function sellFci(uint _amount) public {
1593         bool check = (!session.isOpen) || isTradableFciInSession;
1594         require(check && fci[msg.sender] >= _amount);
1595         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1596         require(namiToken.balanceOf(address(this)) > 0 && totalNacInPool > 0);
1597         uint nacReceive = (_amount.mul(totalNacInPool)).div(totalFci);
1598         
1599         // check nac receive
1600         require(nacReceive > 0);
1601         // cann't sell all fci in pool if session open
1602         if(totalNacInPool == nacReceive) {
1603             require(session.isOpen == false);
1604         }
1605         fci[msg.sender] = fci[msg.sender].sub(_amount);
1606         totalFci = totalFci.sub(_amount);
1607         namiToken.transfer(msg.sender, nacReceive);
1608         totalNacInPool = totalNacInPool.sub(nacReceive);
1609         if(totalNacInPool == 0) {
1610             isEmptyPool = true;
1611         }
1612     }
1613     
1614     /// @dev close invest for escrow
1615     /// @param _priceOpen price ETH in USD
1616     function closeInvest (uint _priceOpen) 
1617         public
1618         onlyEscrow
1619     {
1620         require(_priceOpen != 0 && session.investOpen);
1621         require(now > (session.timeOpen + timeInvestInMinute * 1 minutes));
1622         session.investOpen = false;
1623         session.priceOpen = _priceOpen;
1624         emit InvestClose(now, _priceOpen, sessionId);
1625     }
1626     
1627     /// @dev close session, only escrow can call
1628     /// @param _priceClose price of ETH in USD
1629     function closeSession (uint _priceClose)
1630         public
1631         onlyEscrow
1632     {
1633         require(_priceClose != 0 && now > (session.timeOpen + timeOneSession * 1 minutes));
1634         require(!session.investOpen && session.isOpen);
1635         session.priceClose = _priceClose;
1636         uint result = (_priceClose>session.priceOpen)?1:0;
1637         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1638         uint nacReturn;
1639         uint rate;
1640         // uint price = namiToken.getPrice();
1641         // require(price != 0);
1642         for (uint i = 0; i < session.investorCount; i++) {
1643             if (session.win[i]==result) {
1644                 rate = (rateWin.mul(rateFee)).div(100);
1645                 require(rate <= 100);
1646                 nacReturn = session.amountInvest[i].add( session.amountInvest[i].mul(100 - rate)  / 100);
1647                 require(namiToken.balanceOf(address(this)) >= nacReturn);
1648                 namiToken.transfer(session.investor[i], nacReturn);
1649                 totalNacInPool = totalNacInPool.sub(nacReturn.sub(session.amountInvest[i]));
1650             } else {
1651                 if(rateLoss > 0) {
1652                     rate = (rateLoss.mul(rateFee)).div(100);
1653                     require(rate <= 100);
1654                     nacReturn = session.amountInvest[i].add( session.amountInvest[i].mul(100 - rate)  / 100);
1655                     require(namiToken.balanceOf(address(this)) >= nacReturn);
1656                     namiToken.transfer(session.investor[i], nacReturn);
1657                     totalNacInPool = totalNacInPool.add(session.amountInvest[i].sub(nacReturn));
1658                 } else {
1659                     totalNacInPool = totalNacInPool.add(session.amountInvest[i]);
1660                 }
1661             }
1662             // namiToken.buy.value(etherToBuy)(session.investor[i]);
1663             // reset investor
1664             session.investor[i] = 0x0;
1665             session.win[i] = 0;
1666             session.amountInvest[i] = 0;
1667         }
1668         session.isOpen = false;
1669         emit SessionClose(now, sessionId, _priceClose, rateWin, rateLoss, rateFee);
1670         sessionId += 1;
1671         
1672         // require(!session.isReset && !session.isOpen);
1673         // reset state session
1674         session.priceOpen = 0;
1675         session.priceClose = 0;
1676         session.isReset = true;
1677         session.investOpen = false;
1678         session.investorCount = 0;
1679     }
1680 }
1681 
1682 
1683 contract PresaleToken {
1684     mapping (address => uint256) public balanceOf;
1685     function burnTokens(address _owner) public;
1686 }
1687 
1688  /*
1689  * Contract that is working with ERC223 tokens
1690  */
1691  
1692  /**
1693  * @title Contract that will work with ERC223 tokens.
1694  */
1695  
1696 contract ERC223ReceivingContract {
1697 /**
1698  * @dev Standard ERC223 function that will handle incoming token transfers.
1699  *
1700  * @param _from  Token sender address.
1701  * @param _value Amount of tokens.
1702  * @param _data  Transaction metadata.
1703  */
1704     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
1705     function tokenFallbackBuyer(address _from, uint _value, address _buyer) public returns (bool success);
1706     function tokenFallbackExchange(address _from, uint _value, uint _price) public returns (bool success);
1707 }
1708 
1709 
1710  /*
1711  * Nami Internal Exchange smartcontract-----------------------------------------------------------------
1712  *
1713  */
1714 
1715 contract NamiExchange {
1716     using SafeMath for uint;
1717     
1718     function NamiExchange(address _namiAddress) public {
1719         NamiAddr = _namiAddress;
1720     }
1721 
1722     event UpdateBid(address owner, uint price, uint balance);
1723     event UpdateAsk(address owner, uint price, uint volume);
1724     event BuyHistory(address indexed buyer, address indexed seller, uint price, uint volume, uint time);
1725     event SellHistory(address indexed seller, address indexed buyer, uint price, uint volume, uint time);
1726 
1727     
1728     mapping(address => OrderBid) public bid;
1729     mapping(address => OrderAsk) public ask;
1730     string public name = "NacExchange";
1731     
1732     /// address of Nami token
1733     address public NamiAddr;
1734     
1735     /// price of Nac = ETH/NAC
1736     uint public price = 1;
1737     // struct store order of user
1738     struct OrderBid {
1739         uint price;
1740         uint eth;
1741     }
1742     
1743     struct OrderAsk {
1744         uint price;
1745         uint volume;
1746     }
1747     
1748         
1749     // prevent lost ether
1750     function() payable public {
1751         require(msg.data.length != 0);
1752         require(msg.value == 0);
1753     }
1754     
1755     modifier onlyNami {
1756         require(msg.sender == NamiAddr);
1757         _;
1758     }
1759     
1760     /////////////////
1761     //---------------------------function about bid Order-----------------------------------------------------------
1762     
1763     function placeBuyOrder(uint _price) payable public {
1764         require(_price > 0 && msg.value > 0 && bid[msg.sender].eth == 0);
1765         if (msg.value > 0) {
1766             bid[msg.sender].eth = (bid[msg.sender].eth).add(msg.value);
1767             bid[msg.sender].price = _price;
1768             emit UpdateBid(msg.sender, _price, bid[msg.sender].eth);
1769         }
1770     }
1771     
1772     function sellNac(uint _value, address _buyer, uint _price) public returns (bool success) {
1773         require(_price == bid[_buyer].price && _buyer != msg.sender);
1774         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1775         uint ethOfBuyer = bid[_buyer].eth;
1776         uint maxToken = ethOfBuyer.mul(bid[_buyer].price);
1777         require(namiToken.allowance(msg.sender, this) >= _value && _value > 0 && ethOfBuyer != 0 && _buyer != 0x0);
1778         if (_value > maxToken) {
1779             if (msg.sender.send(ethOfBuyer) && namiToken.transferFrom(msg.sender,_buyer,maxToken)) {
1780                 // update order
1781                 bid[_buyer].eth = 0;
1782                 emit UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
1783                 emit BuyHistory(_buyer, msg.sender, bid[_buyer].price, maxToken, now);
1784                 return true;
1785             } else {
1786                 // revert anything
1787                 revert();
1788             }
1789         } else {
1790             uint eth = _value.div(bid[_buyer].price);
1791             if (msg.sender.send(eth) && namiToken.transferFrom(msg.sender,_buyer,_value)) {
1792                 // update order
1793                 bid[_buyer].eth = (bid[_buyer].eth).sub(eth);
1794                 emit UpdateBid(_buyer, bid[_buyer].price, bid[_buyer].eth);
1795                 emit BuyHistory(_buyer, msg.sender, bid[_buyer].price, _value, now);
1796                 return true;
1797             } else {
1798                 // revert anything
1799                 revert();
1800             }
1801         }
1802     }
1803     
1804     function closeBidOrder() public {
1805         require(bid[msg.sender].eth > 0 && bid[msg.sender].price > 0);
1806         // transfer ETH
1807         msg.sender.transfer(bid[msg.sender].eth);
1808         // update order
1809         bid[msg.sender].eth = 0;
1810         emit UpdateBid(msg.sender, bid[msg.sender].price, bid[msg.sender].eth);
1811     }
1812     
1813 
1814     ////////////////
1815     //---------------------------function about ask Order-----------------------------------------------------------
1816     
1817     // place ask order by send NAC to Nami Exchange contract
1818     // this function place sell order
1819     function tokenFallbackExchange(address _from, uint _value, uint _price) onlyNami public returns (bool success) {
1820         require(_price > 0 && _value > 0 && ask[_from].volume == 0);
1821         if (_value > 0) {
1822             ask[_from].volume = (ask[_from].volume).add(_value);
1823             ask[_from].price = _price;
1824             emit UpdateAsk(_from, _price, ask[_from].volume);
1825         }
1826         return true;
1827     }
1828     
1829     function closeAskOrder() public {
1830         require(ask[msg.sender].volume > 0 && ask[msg.sender].price > 0);
1831         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1832         uint previousBalances = namiToken.balanceOf(msg.sender);
1833         // transfer token
1834         namiToken.transfer(msg.sender, ask[msg.sender].volume);
1835         // update order
1836         ask[msg.sender].volume = 0;
1837         emit UpdateAsk(msg.sender, ask[msg.sender].price, 0);
1838         // check balance
1839         assert(previousBalances < namiToken.balanceOf(msg.sender));
1840     }
1841     
1842     function buyNac(address _seller, uint _price) payable public returns (bool success) {
1843         require(msg.value > 0 && ask[_seller].volume > 0 && ask[_seller].price > 0);
1844         require(_price == ask[_seller].price && _seller != msg.sender);
1845         NamiCrowdSale namiToken = NamiCrowdSale(NamiAddr);
1846         uint maxEth = (ask[_seller].volume).div(ask[_seller].price);
1847         uint previousBalances = namiToken.balanceOf(msg.sender);
1848         if (msg.value > maxEth) {
1849             if (_seller.send(maxEth) && msg.sender.send(msg.value.sub(maxEth))) {
1850                 // transfer token
1851                 namiToken.transfer(msg.sender, ask[_seller].volume);
1852                 emit SellHistory(_seller, msg.sender, ask[_seller].price, ask[_seller].volume, now);
1853                 // update order
1854                 ask[_seller].volume = 0;
1855                 emit UpdateAsk(_seller, ask[_seller].price, 0);
1856                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1857                 return true;
1858             } else {
1859                 // revert anything
1860                 revert();
1861             }
1862         } else {
1863             uint nac = (msg.value).mul(ask[_seller].price);
1864             if (_seller.send(msg.value)) {
1865                 // transfer token
1866                 namiToken.transfer(msg.sender, nac);
1867                 // update order
1868                 ask[_seller].volume = (ask[_seller].volume).sub(nac);
1869                 emit UpdateAsk(_seller, ask[_seller].price, ask[_seller].volume);
1870                 emit SellHistory(_seller, msg.sender, ask[_seller].price, nac, now);
1871                 assert(previousBalances < namiToken.balanceOf(msg.sender));
1872                 return true;
1873             } else {
1874                 // revert anything
1875                 revert();
1876             }
1877         }
1878     }
1879 }
1880 
1881 contract ERC23 {
1882     function balanceOf(address who) public constant returns (uint);
1883     function transfer(address to, uint value) public returns (bool success);
1884 }
1885 
1886 
1887 
1888 /*
1889 * NamiMultiSigWallet smart contract-------------------------------
1890 */
1891 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
1892 contract NamiMultiSigWallet {
1893 
1894     uint constant public MAX_OWNER_COUNT = 50;
1895 
1896     event Confirmation(address indexed sender, uint indexed transactionId);
1897     event Revocation(address indexed sender, uint indexed transactionId);
1898     event Submission(uint indexed transactionId);
1899     event Execution(uint indexed transactionId);
1900     event ExecutionFailure(uint indexed transactionId);
1901     event Deposit(address indexed sender, uint value);
1902     event OwnerAddition(address indexed owner);
1903     event OwnerRemoval(address indexed owner);
1904     event RequirementChange(uint required);
1905 
1906     mapping (uint => Transaction) public transactions;
1907     mapping (uint => mapping (address => bool)) public confirmations;
1908     mapping (address => bool) public isOwner;
1909     address[] public owners;
1910     uint public required;
1911     uint public transactionCount;
1912 
1913     struct Transaction {
1914         address destination;
1915         uint value;
1916         bytes data;
1917         bool executed;
1918     }
1919 
1920     modifier onlyWallet() {
1921         require(msg.sender == address(this));
1922         _;
1923     }
1924 
1925     modifier ownerDoesNotExist(address owner) {
1926         require(!isOwner[owner]);
1927         _;
1928     }
1929 
1930     modifier ownerExists(address owner) {
1931         require(isOwner[owner]);
1932         _;
1933     }
1934 
1935     modifier transactionExists(uint transactionId) {
1936         require(transactions[transactionId].destination != 0);
1937         _;
1938     }
1939 
1940     modifier confirmed(uint transactionId, address owner) {
1941         require(confirmations[transactionId][owner]);
1942         _;
1943     }
1944 
1945     modifier notConfirmed(uint transactionId, address owner) {
1946         require(!confirmations[transactionId][owner]);
1947         _;
1948     }
1949 
1950     modifier notExecuted(uint transactionId) {
1951         require(!transactions[transactionId].executed);
1952         _;
1953     }
1954 
1955     modifier notNull(address _address) {
1956         require(_address != 0);
1957         _;
1958     }
1959 
1960     modifier validRequirement(uint ownerCount, uint _required) {
1961         require(!(ownerCount > MAX_OWNER_COUNT
1962             || _required > ownerCount
1963             || _required == 0
1964             || ownerCount == 0));
1965         _;
1966     }
1967 
1968     /// @dev Fallback function allows to deposit ether.
1969     function() public payable {
1970         if (msg.value > 0)
1971             emit Deposit(msg.sender, msg.value);
1972     }
1973 
1974     /*
1975      * Public functions
1976      */
1977     /// @dev Contract constructor sets initial owners and required number of confirmations.
1978     /// @param _owners List of initial owners.
1979     /// @param _required Number of required confirmations.
1980     function NamiMultiSigWallet(address[] _owners, uint _required)
1981         public
1982         validRequirement(_owners.length, _required)
1983     {
1984         for (uint i = 0; i < _owners.length; i++) {
1985             require(!(isOwner[_owners[i]] || _owners[i] == 0));
1986             isOwner[_owners[i]] = true;
1987         }
1988         owners = _owners;
1989         required = _required;
1990     }
1991 
1992     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
1993     /// @param owner Address of new owner.
1994     function addOwner(address owner)
1995         public
1996         onlyWallet
1997         ownerDoesNotExist(owner)
1998         notNull(owner)
1999         validRequirement(owners.length + 1, required)
2000     {
2001         isOwner[owner] = true;
2002         owners.push(owner);
2003         emit OwnerAddition(owner);
2004     }
2005 
2006     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
2007     /// @param owner Address of owner.
2008     function removeOwner(address owner)
2009         public
2010         onlyWallet
2011         ownerExists(owner)
2012     {
2013         isOwner[owner] = false;
2014         for (uint i=0; i<owners.length - 1; i++) {
2015             if (owners[i] == owner) {
2016                 owners[i] = owners[owners.length - 1];
2017                 break;
2018             }
2019         }
2020         owners.length -= 1;
2021         if (required > owners.length)
2022             changeRequirement(owners.length);
2023         emit OwnerRemoval(owner);
2024     }
2025 
2026     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
2027     /// @param owner Address of owner to be replaced.
2028     /// @param owner Address of new owner.
2029     function replaceOwner(address owner, address newOwner)
2030         public
2031         onlyWallet
2032         ownerExists(owner)
2033         ownerDoesNotExist(newOwner)
2034     {
2035         for (uint i=0; i<owners.length; i++) {
2036             if (owners[i] == owner) {
2037                 owners[i] = newOwner;
2038                 break;
2039             }
2040         }
2041         isOwner[owner] = false;
2042         isOwner[newOwner] = true;
2043         emit OwnerRemoval(owner);
2044         emit OwnerAddition(newOwner);
2045     }
2046 
2047     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
2048     /// @param _required Number of required confirmations.
2049     function changeRequirement(uint _required)
2050         public
2051         onlyWallet
2052         validRequirement(owners.length, _required)
2053     {
2054         required = _required;
2055         emit RequirementChange(_required);
2056     }
2057 
2058     /// @dev Allows an owner to submit and confirm a transaction.
2059     /// @param destination Transaction target address.
2060     /// @param value Transaction ether value.
2061     /// @param data Transaction data payload.
2062     /// @return Returns transaction ID.
2063     function submitTransaction(address destination, uint value, bytes data)
2064         public
2065         returns (uint transactionId)
2066     {
2067         transactionId = addTransaction(destination, value, data);
2068         confirmTransaction(transactionId);
2069     }
2070 
2071     /// @dev Allows an owner to confirm a transaction.
2072     /// @param transactionId Transaction ID.
2073     function confirmTransaction(uint transactionId)
2074         public
2075         ownerExists(msg.sender)
2076         transactionExists(transactionId)
2077         notConfirmed(transactionId, msg.sender)
2078     {
2079         confirmations[transactionId][msg.sender] = true;
2080         emit Confirmation(msg.sender, transactionId);
2081         executeTransaction(transactionId);
2082     }
2083 
2084     /// @dev Allows an owner to revoke a confirmation for a transaction.
2085     /// @param transactionId Transaction ID.
2086     function revokeConfirmation(uint transactionId)
2087         public
2088         ownerExists(msg.sender)
2089         confirmed(transactionId, msg.sender)
2090         notExecuted(transactionId)
2091     {
2092         confirmations[transactionId][msg.sender] = false;
2093         emit Revocation(msg.sender, transactionId);
2094     }
2095 
2096     /// @dev Allows anyone to execute a confirmed transaction.
2097     /// @param transactionId Transaction ID.
2098     function executeTransaction(uint transactionId)
2099         public
2100         notExecuted(transactionId)
2101     {
2102         if (isConfirmed(transactionId)) {
2103             // Transaction tx = transactions[transactionId];
2104             transactions[transactionId].executed = true;
2105             // tx.executed = true;
2106             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data)) {
2107                 emit Execution(transactionId);
2108             } else {
2109                 emit ExecutionFailure(transactionId);
2110                 transactions[transactionId].executed = false;
2111             }
2112         }
2113     }
2114 
2115     /// @dev Returns the confirmation status of a transaction.
2116     /// @param transactionId Transaction ID.
2117     /// @return Confirmation status.
2118     function isConfirmed(uint transactionId)
2119         public
2120         constant
2121         returns (bool)
2122     {
2123         uint count = 0;
2124         for (uint i = 0; i < owners.length; i++) {
2125             if (confirmations[transactionId][owners[i]])
2126                 count += 1;
2127             if (count == required)
2128                 return true;
2129         }
2130     }
2131 
2132     /*
2133      * Internal functions
2134      */
2135     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
2136     /// @param destination Transaction target address.
2137     /// @param value Transaction ether value.
2138     /// @param data Transaction data payload.
2139     /// @return Returns transaction ID.
2140     function addTransaction(address destination, uint value, bytes data)
2141         internal
2142         notNull(destination)
2143         returns (uint transactionId)
2144     {
2145         transactionId = transactionCount;
2146         transactions[transactionId] = Transaction({
2147             destination: destination, 
2148             value: value,
2149             data: data,
2150             executed: false
2151         });
2152         transactionCount += 1;
2153         emit Submission(transactionId);
2154     }
2155 
2156     /*
2157      * Web3 call functions
2158      */
2159     /// @dev Returns number of confirmations of a transaction.
2160     /// @param transactionId Transaction ID.
2161     /// @return Number of confirmations.
2162     function getConfirmationCount(uint transactionId)
2163         public
2164         constant
2165         returns (uint count)
2166     {
2167         for (uint i = 0; i < owners.length; i++) {
2168             if (confirmations[transactionId][owners[i]])
2169                 count += 1;
2170         }
2171     }
2172 
2173     /// @dev Returns total number of transactions after filers are applied.
2174     /// @param pending Include pending transactions.
2175     /// @param executed Include executed transactions.
2176     /// @return Total number of transactions after filters are applied.
2177     function getTransactionCount(bool pending, bool executed)
2178         public
2179         constant
2180         returns (uint count)
2181     {
2182         for (uint i = 0; i < transactionCount; i++) {
2183             if (pending && !transactions[i].executed || executed && transactions[i].executed)
2184                 count += 1;
2185         }
2186     }
2187 
2188     /// @dev Returns list of owners.
2189     /// @return List of owner addresses.
2190     function getOwners()
2191         public
2192         constant
2193         returns (address[])
2194     {
2195         return owners;
2196     }
2197 
2198     /// @dev Returns array with owner addresses, which confirmed transaction.
2199     /// @param transactionId Transaction ID.
2200     /// @return Returns array of owner addresses.
2201     function getConfirmations(uint transactionId)
2202         public
2203         constant
2204         returns (address[] _confirmations)
2205     {
2206         address[] memory confirmationsTemp = new address[](owners.length);
2207         uint count = 0;
2208         uint i;
2209         for (i = 0; i < owners.length; i++) {
2210             if (confirmations[transactionId][owners[i]]) {
2211                 confirmationsTemp[count] = owners[i];
2212                 count += 1;
2213             }
2214         }
2215         _confirmations = new address[](count);
2216         for (i = 0; i < count; i++) {
2217             _confirmations[i] = confirmationsTemp[i];
2218         }
2219     }
2220 
2221     /// @dev Returns list of transaction IDs in defined range.
2222     /// @param from Index start position of transaction array.
2223     /// @param to Index end position of transaction array.
2224     /// @param pending Include pending transactions.
2225     /// @param executed Include executed transactions.
2226     /// @return Returns array of transaction IDs.
2227     function getTransactionIds(uint from, uint to, bool pending, bool executed)
2228         public
2229         constant
2230         returns (uint[] _transactionIds)
2231     {
2232         uint[] memory transactionIdsTemp = new uint[](transactionCount);
2233         uint count = 0;
2234         uint i;
2235         for (i = 0; i < transactionCount; i++) {
2236             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
2237                 transactionIdsTemp[count] = i;
2238                 count += 1;
2239             }
2240         }
2241         _transactionIds = new uint[](to - from);
2242         for (i = from; i < to; i++) {
2243             _transactionIds[i - from] = transactionIdsTemp[i];
2244         }
2245     }
2246 }