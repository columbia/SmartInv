1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal pure returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a < b ? a : b;
42   }
43 }
44 
45 
46 contract ERC223 {
47   uint public totalSupply;
48   function balanceOf(address who) public view returns (uint);
49   
50   function name() public view returns (string _name);
51   function symbol() public view returns (string _symbol);
52   function decimals() public view returns (uint8 _decimals);
53   function totalSupply() public view returns (uint256 _supply);
54 
55   function transfer(address to, uint value) public returns (bool ok);
56   function transfer(address to, uint value, bytes data) public returns (bool ok);
57   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
58   
59   event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 contract ContractReceiver {
63      
64     struct TKN {
65         address sender;
66         uint value;
67         bytes data;
68         bytes4 sig;
69     }
70     
71     
72     function tokenFallback(address _from, uint _value, bytes _data) public pure {
73       TKN memory tkn;
74       tkn.sender = _from;
75       tkn.value = _value;
76       tkn.data = _data;
77       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
78       tkn.sig = bytes4(u);
79       
80       /* tkn variable is analogue of msg variable of Ether transaction
81       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
82       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
83       *  tkn.data is data of token transaction   (analogue of msg.data)
84       *  tkn.sig is 4 bytes signature of function
85       *  if data of token transaction is a function execution
86       */
87     }
88 }
89 
90 contract StandardToken is ERC223 {
91     using SafeMath for uint;
92 
93     //user token balances
94     mapping (address => uint) balances;
95     //token transer permissions
96     mapping (address => mapping (address => uint)) allowed;
97 
98     // Function that is called when a user or another contract wants to transfer funds .
99     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
100         if(isContract(_to)) {
101             if (balanceOf(msg.sender) < _value) revert();
102             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
103             balances[_to] = balanceOf(_to).add(_value);
104             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
105             Transfer(msg.sender, _to, _value);
106             return true;
107         }
108         else {
109             return transferToAddress(_to, _value);
110         }
111     }
112     
113 
114     // Function that is called when a user or another contract wants to transfer funds .
115     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
116           
117         if(isContract(_to)) {
118             return transferToContract(_to, _value, _data);
119         }
120         else {
121             return transferToAddress(_to, _value);
122         }
123     }
124       
125     // Standard function transfer similar to ERC20 transfer with no _data .
126     // Added due to backwards compatibility reasons .
127     function transfer(address _to, uint _value) public returns (bool success) {
128           
129         //standard function transfer similar to ERC20 transfer with no _data
130         //added due to backwards compatibility reasons
131         bytes memory empty;
132         if(isContract(_to)) {
133             return transferToContract(_to, _value, empty);
134         }
135         else {
136             return transferToAddress(_to, _value);
137         }
138     }
139 
140     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
141     function isContract(address _addr) private view returns (bool is_contract) {
142         uint length;
143         assembly {
144             //retrieve the size of the code on target address, this needs assembly
145             length := extcodesize(_addr)
146         }
147         return (length > 0);
148     }
149 
150     //function that is called when transaction target is an address
151     function transferToAddress(address _to, uint _value) private returns (bool success) {
152         if (balanceOf(msg.sender) < _value) revert();
153         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
154         balances[_to] = balanceOf(_to).add(_value);
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158       
159       //function that is called when transaction target is a contract
160       function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
161         if (balanceOf(msg.sender) < _value) revert();
162         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
163         balances[_to] = balanceOf(_to).add(_value);
164         ContractReceiver receiver = ContractReceiver(_to);
165         receiver.tokenFallback(msg.sender, _value, _data);
166         Transfer(msg.sender, _to, _value);
167         return true;
168     }
169 
170     /**
171      * Token transfer from from to _to (permission needed)
172      */
173     function transferFrom(
174         address _from, 
175         address _to,
176         uint _value
177     ) 
178         public 
179         returns (bool)
180     {
181         if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();
182 
183         bytes memory empty;
184         balances[_to] = balanceOf(_to).add(_value);
185         balances[_from] = balanceOf(_from).sub(_value);
186         allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);
187         if (isContract(_to)) {
188             ContractReceiver receiver = ContractReceiver(_to);
189             receiver.tokenFallback(msg.sender, _value, empty);
190         }
191         Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     /**
196      * Increase permission for transfer
197      */
198     function increaseApproval(
199         address spender,
200         uint value
201     )
202         public
203         returns (bool) 
204     {
205         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
206         return true;
207     }
208 
209     /**
210      * Decrease permission for transfer
211      */
212     function decreaseApproval(
213         address spender,
214         uint value
215     )
216         public
217         returns (bool) 
218     {
219         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
220         return true;
221     }
222 
223     /**
224      * User token balance
225      */
226     function balanceOf(
227         address owner
228     ) 
229         public 
230         constant 
231         returns (uint) 
232     {
233         return balances[owner];
234     }
235 
236     /**
237      * User transfer permission
238      */
239     function allowance(
240         address owner, 
241         address spender
242     )
243         public
244         constant
245         returns (uint remaining)
246     {
247         return allowed[owner][spender];
248     }
249 }
250 
251 contract MyDFSToken is StandardToken {
252 
253     string public name = "MyDFS Token";
254     uint8 public decimals = 6;
255     string public symbol = "MyDFS";
256     string public version = 'H1.0';
257     uint256 public totalSupply;
258 
259     function () external {
260         revert();
261     } 
262 
263     function MyDFSToken() public {
264         totalSupply = 125 * 1e12;
265         balances[msg.sender] = totalSupply;
266     }
267 
268     // Function to access name of token .
269     function name() public view returns (string _name) {
270         return name;
271     }
272     // Function to access symbol of token .
273     function symbol() public view returns (string _symbol) {
274         return symbol;
275     }
276     // Function to access decimals of token .
277     function decimals() public view returns (uint8 _decimals) {
278         return decimals;
279     }
280     // Function to access total supply of tokens .
281     function totalSupply() public view returns (uint256 _totalSupply) {
282         return totalSupply;
283     }
284 }
285 
286 contract Ownable {
287     address public owner;
288     address public newOwnerCandidate;
289 
290     event OwnershipRequested(address indexed _by, address indexed _to);
291     event OwnershipTransferred(address indexed _from, address indexed _to);
292 
293     function Ownable() public {
294         owner = msg.sender;
295     }
296 
297     modifier onlyOwner() { require(msg.sender == owner); _;}
298 
299     /// Proposes to transfer control of the contract to a newOwnerCandidate.
300     /// @param _newOwnerCandidate address The address to transfer ownership to.
301     function transferOwnership(address _newOwnerCandidate) external onlyOwner {
302         require(_newOwnerCandidate != address(0));
303 
304         newOwnerCandidate = _newOwnerCandidate;
305 
306         OwnershipRequested(msg.sender, newOwnerCandidate);
307     }
308 
309     /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.
310     function acceptOwnership() external {
311         if (msg.sender == newOwnerCandidate) {
312             owner = newOwnerCandidate;
313             newOwnerCandidate = address(0);
314 
315             OwnershipTransferred(owner, newOwnerCandidate);
316         }
317     }
318 }
319 
320 contract DevTokensHolder is Ownable {
321     using SafeMath for uint256;
322 
323     uint256 collectedTokens;
324     GenericCrowdsale crowdsale;
325     MyDFSToken token;
326 
327     event ClaimedTokens(address token, uint256 amount);
328     event TokensWithdrawn(address holder, uint256 amount);
329     event Debug(uint256 amount);
330 
331     function DevTokensHolder(address _crowdsale, address _token, address _owner) public {
332         crowdsale = GenericCrowdsale(_crowdsale);
333         token = MyDFSToken(_token);
334         owner = _owner;
335     }
336 
337     function tokenFallback(
338         address _from, 
339         uint _value, 
340         bytes _data
341     ) 
342         public 
343         view 
344     {
345         require(_from == owner || _from == address(crowdsale));
346         require(_value > 0 || _data.length > 0);
347     }
348 
349     /// @notice The Dev (Owner) will call this method to extract the tokens
350     function collectTokens() public onlyOwner {
351         uint256 balance = token.balanceOf(address(this));
352         uint256 total = collectedTokens.add(balance);
353 
354         uint256 finalizedTime = crowdsale.finishTime();
355         require(finalizedTime > 0 && getTime() > finalizedTime.add(14 days));
356 
357         uint256 canExtract = total.mul(getTime().sub(finalizedTime)).div(months(12));
358         canExtract = canExtract.sub(collectedTokens);
359 
360         if (canExtract > balance) {
361             canExtract = balance;
362         }
363 
364         collectedTokens = collectedTokens.add(canExtract);
365         require(token.transfer(owner, canExtract));
366         TokensWithdrawn(owner, canExtract);
367     }
368 
369     function months(uint256 m) internal pure returns (uint256) {
370         return m.mul(30 days);
371     }
372 
373     function getTime() internal view returns (uint256) {
374         return now;
375     }
376 
377     //////////
378     // Safety Methods
379     //////////
380 
381     /// @notice This method can be used by the controller to extract mistakenly
382     ///  sent tokens to this contract.
383     /// @param _token The address of the token contract that you want to recover
384     ///  set to 0 in case you want to extract ether.
385     function claimTokens(address _token) public onlyOwner {
386         require(_token != address(token));
387         if (_token == 0x0) {
388             owner.transfer(this.balance);
389             return;
390         }
391 
392         token = MyDFSToken(_token);
393         uint256 balance = token.balanceOf(this);
394         token.transfer(owner, balance);
395         ClaimedTokens(_token, balance);
396     }
397 }
398 
399 contract AdvisorsTokensHolder is Ownable {
400     using SafeMath for uint256;
401 
402     GenericCrowdsale crowdsale;
403     MyDFSToken token;
404 
405     event ClaimedTokens(address token, uint256 amount);
406     event TokensWithdrawn(address holder, uint256 amount);
407 
408     function AdvisorsTokensHolder(address _crowdsale, address _token, address _owner) public {
409         crowdsale = GenericCrowdsale(_crowdsale);
410         token = MyDFSToken(_token);
411         owner = _owner;
412     }
413 
414     function tokenFallback(
415         address _from, 
416         uint _value, 
417         bytes _data
418     ) 
419         public 
420         view 
421     {
422         require(_from == owner || _from == address(crowdsale));
423         require(_value > 0 || _data.length > 0);
424     }
425 
426     /// @notice The Dev (Owner) will call this method to extract the tokens
427     function collectTokens() public onlyOwner {
428         uint256 balance = token.balanceOf(address(this));
429         require(balance > 0);
430 
431         uint256 finalizedTime = crowdsale.finishTime();
432         require(finalizedTime > 0 && getTime() > finalizedTime.add(14 days));
433 
434         require(token.transfer(owner, balance));
435         TokensWithdrawn(owner, balance);
436     }
437 
438     function getTime() internal view returns (uint256) {
439         return now;
440     }
441 
442     //////////
443     // Safety Methods
444     //////////
445 
446     /// @notice This method can be used by the controller to extract mistakenly
447     ///  sent tokens to this contract.
448     /// @param _token The address of the token contract that you want to recover
449     ///  set to 0 in case you want to extract ether.
450     function claimTokens(address _token) public onlyOwner {
451         require(_token != address(token));
452         if (_token == 0x0) {
453             owner.transfer(this.balance);
454             return;
455         }
456 
457         token = MyDFSToken(_token);
458         uint256 balance = token.balanceOf(this);
459         token.transfer(owner, balance);
460         ClaimedTokens(_token, balance);
461     }
462 }
463 
464 contract GenericCrowdsale is Ownable {
465     using SafeMath for uint256;
466 
467     //Crowrdsale states
468     enum State { Initialized, PreIco, PreIcoFinished, Ico, IcoFinished}
469 
470     struct Discount {
471         uint256 amount;
472         uint256 value;
473     }
474 
475     //ether trasfered to
476     address public beneficiary;
477     //Crowrdsale state
478     State public state;
479     //Hard goal in Wei
480     uint public hardFundingGoal;
481     //soft goal in Wei
482     uint public softFundingGoal;
483     //gathered Ether amount in Wei
484     uint public amountRaised;
485     //ICO/PreICO start timestamp in seconds
486     uint public started;
487     //Crowdsale finish time
488     uint public finishTime;
489     //price for 1 token in Wei
490     uint public price;
491     //minimum purchase value in Wei
492     uint public minPurchase;
493     //Token cantract
494     ERC223 public tokenReward;
495     //Wei balances for refund if ICO failed
496     mapping(address => uint256) public balances;
497 
498     //Emergency stop sell
499     bool emergencyPaused = false;
500     //Soft cap reached
501     bool softCapReached = false;
502     //dev holder
503     DevTokensHolder public devTokensHolder;
504     //advisors holder
505     AdvisorsTokensHolder public advisorsTokensHolder;
506     
507     //Disconts
508     Discount[] public discounts;
509 
510     //price overhead for next stages
511     uint8[2] public preIcoTokenPrice = [70,75];
512     //price overhead for next stages
513     uint8[4] public icoTokenPrice = [100,120,125,130];
514 
515     event TokenPurchased(address investor, uint sum, uint tokensCount, uint discountTokens);
516     event PreIcoLimitReached(uint totalAmountRaised);
517     event SoftGoalReached(uint totalAmountRaised);
518     event HardGoalReached(uint totalAmountRaised);
519     event Debug(uint num);
520 
521     //Sale is active
522     modifier sellActive() { 
523         require(
524             !emergencyPaused 
525             && (state == State.PreIco || state == State.Ico)
526             && amountRaised < hardFundingGoal
527         );
528     _; }
529     //Soft cap not reached
530     modifier goalNotReached() { require(state == State.IcoFinished && amountRaised < softFundingGoal); _; }
531 
532     /**
533      * Constrctor function
534      */
535     function GenericCrowdsale(
536         address ifSuccessfulSendTo,
537         address addressOfTokenUsedAsReward
538     ) public {
539         require(ifSuccessfulSendTo != address(0) 
540             && addressOfTokenUsedAsReward != address(0));
541         beneficiary = ifSuccessfulSendTo;
542         tokenReward = ERC223(addressOfTokenUsedAsReward);
543         state = State.Initialized;
544     }
545 
546     function tokenFallback(
547         address _from, 
548         uint _value, 
549         bytes _data
550     ) 
551         public 
552         view 
553     {
554         require(_from == owner);
555         require(_value > 0 || _data.length > 0);
556     }
557 
558     /**
559      * Start PreICO
560      */
561     function preIco(
562         uint hardFundingGoalInEthers,
563         uint minPurchaseInFinney,
564         uint costOfEachToken,
565         uint256[] discountEthers,
566         uint256[] discountValues
567     ) 
568         external 
569         onlyOwner 
570     {
571         require(hardFundingGoalInEthers > 0
572             && costOfEachToken > 0
573             && state == State.Initialized
574             && discountEthers.length == discountValues.length);
575 
576         hardFundingGoal = hardFundingGoalInEthers.mul(1 ether);
577         minPurchase = minPurchaseInFinney.mul(1 finney);
578         price = costOfEachToken;
579         initDiscounts(discountEthers, discountValues);
580         state = State.PreIco;
581         started = now;
582     }
583 
584     /**
585      * Start ICO
586      */
587     function ico(
588         uint softFundingGoalInEthers,
589         uint hardFundingGoalInEthers,
590         uint minPurchaseInFinney,
591         uint costOfEachToken,
592         uint256[] discountEthers,
593         uint256[] discountValues
594     ) 
595         external
596         onlyOwner
597     {
598         require(softFundingGoalInEthers > 0
599             && hardFundingGoalInEthers > 0
600             && hardFundingGoalInEthers > softFundingGoalInEthers
601             && costOfEachToken > 0
602             && state < State.Ico
603             && discountEthers.length == discountValues.length);
604 
605         softFundingGoal = softFundingGoalInEthers.mul(1 ether);
606         hardFundingGoal = hardFundingGoalInEthers.mul(1 ether);
607         minPurchase = minPurchaseInFinney.mul(1 finney);
608         price = costOfEachToken;
609         delete discounts;
610         initDiscounts(discountEthers, discountValues);
611         state = State.Ico;
612         started = now;
613     }
614 
615     /**
616      * Finish ICO / PreICO
617      */
618     function finishSale() external onlyOwner {
619         require(state == State.PreIco || state == State.Ico);
620         
621         if (state == State.PreIco)
622             state = State.PreIcoFinished;
623         else
624             state = State.IcoFinished;
625     }
626 
627     /**
628      * Admin can pause token sell
629      */
630     function emergencyPause() external onlyOwner {
631         emergencyPaused = true;
632     }
633 
634     /**
635      * Admin can unpause token sell
636      */
637     function emergencyUnpause() external onlyOwner {
638         emergencyPaused = false;
639     }
640 
641     /**
642      * Transfer dev tokens to vesting wallet
643      */
644     function sendDevTokens() external onlyOwner returns(address) {
645         require(successed());
646 
647         devTokensHolder = new DevTokensHolder(address(this), address(tokenReward), owner);
648         tokenReward.transfer(address(devTokensHolder), 12500 * 1e9);
649         return address(devTokensHolder);
650     }
651 
652     /**
653      * Transfer dev tokens to vesting wallet
654      */
655     function sendAdvisorsTokens() external onlyOwner returns(address) {
656         require(successed());
657 
658         advisorsTokensHolder = new AdvisorsTokensHolder(address(this), address(tokenReward), owner);
659         tokenReward.transfer(address(advisorsTokensHolder), 12500 * 1e9);
660         return address(advisorsTokensHolder);
661     }
662 
663     /**
664      * Admin can withdraw ether beneficiary address
665      */
666     function withdrawFunding() external onlyOwner {
667         require((state == State.PreIco || successed()));
668         beneficiary.transfer(this.balance);
669     }
670 
671     /**
672      * Different coins purchase
673      */
674     function foreignPurchase(address user, uint256 amount)
675         external
676         onlyOwner
677         sellActive
678     {
679         buyTokens(user, amount);
680         checkGoals();
681     }
682 
683     /**
684      * Claim refund ether in soft goal not reached 
685      */
686     function claimRefund() 
687         external 
688         goalNotReached 
689     {
690         uint256 amount = balances[msg.sender];
691         balances[msg.sender] = 0;
692         if (amount > 0){
693             if (!msg.sender.send(amount)) {
694                 balances[msg.sender] = amount;
695             }
696         }
697     }
698 
699     /**
700      * Payment transaction
701      */
702     function () 
703         external 
704         payable 
705         sellActive
706     {
707         require(msg.value > 0);
708         require(msg.value >= minPurchase);
709         uint amount = msg.value;
710         if (amount > hardFundingGoal.sub(amountRaised)) {
711             uint availableAmount = hardFundingGoal.sub(amountRaised);
712             msg.sender.transfer(amount.sub(availableAmount));
713             amount = availableAmount;
714         }
715 
716         buyTokens(msg.sender,  amount);
717         checkGoals();
718     }
719 
720     /**
721      * Transfer tokens to user
722      */
723     function buyTokens(
724         address user,
725         uint256 amount
726     ) internal {
727         require(amount <= hardFundingGoal.sub(amountRaised));
728 
729         uint256 passedSeconds = getTime().sub(started);
730         uint256 week = 0;
731         if (passedSeconds >= 604800){
732             week = passedSeconds.div(604800);
733         }
734         Debug(week);
735 
736         uint256 tokenPrice;
737         if (state == State.Ico){
738             uint256 cup = amountRaised.mul(4).div(hardFundingGoal);
739             if (cup > week)
740                 week = cup;
741             if (week >= 4)
742                  week = 3;
743             tokenPrice = price.mul(icoTokenPrice[week]).div(100);
744         } else {
745             if (week >= 2)
746                  week = 1;
747             tokenPrice = price.mul(preIcoTokenPrice[week]).div(100);
748         }
749 
750         Debug(tokenPrice);
751 
752         uint256 count = amount.div(tokenPrice);
753         uint256 discount = getDiscountOf(amount);
754         uint256 discountBonus = discount.mul(count).div(100);
755         count = count.add(discountBonus);
756         count = ceilTokens(count);
757 
758         require(tokenReward.transfer(user, count));
759         balances[user] = balances[user].add(amount);
760         amountRaised = amountRaised.add(amount);
761         TokenPurchased(user, amount, count, discountBonus);
762     }
763 
764     /**
765      * Define distount percents for different token amounts
766      */
767     function ceilTokens(
768         uint256 num
769     ) 
770         public
771         pure
772         returns(uint256) 
773     {
774         uint256 part = num % 1000000;
775         return part > 0 ? num.div(1000000).mul(1000000) + 1000000 : num;
776     }
777 
778     /**
779      * ICO is finished successfully
780      */
781     function successed() 
782         public 
783         view 
784         returns(bool) 
785     {
786         return state == State.IcoFinished && amountRaised >= softFundingGoal;
787     }
788 
789     /**
790      * Define distount percents for different token amounts
791      */
792     function initDiscounts(
793         uint256[] discountEthers,
794         uint256[] discountValues
795     ) internal {
796         for (uint256 i = 0; i < discountEthers.length; i++) {
797             discounts.push(Discount(discountEthers[i].mul(1 ether), discountValues[i]));
798         }
799     }
800 
801     /**
802      * Get discount percent for number of tokens
803      */
804     function getDiscountOf(
805         uint256 _amount
806     )
807         public
808         view
809         returns (uint256)
810     {
811         if (discounts.length > 0)
812             for (uint256 i = 0; i < discounts.length; i++) {
813                 if (_amount >= discounts[i].amount) {
814                     return discounts[i].value;
815                 }
816             }
817         return 0;
818     }
819 
820     /**
821      * Check ICO goals achievement
822      */
823     function checkGoals() internal {
824         if (state == State.PreIco) {
825             if (amountRaised >= hardFundingGoal) {
826                 PreIcoLimitReached(amountRaised);
827                 state = State.PreIcoFinished;
828             }
829         } else {
830             if (!softCapReached && amountRaised >= softFundingGoal){
831                 softCapReached = true;
832                 SoftGoalReached(amountRaised);
833             }
834             if (amountRaised >= hardFundingGoal) {
835                 finishTime = now;
836                 HardGoalReached(amountRaised);
837                 state = State.IcoFinished;
838             }
839         }
840     }
841 
842     function getTime() internal view returns (uint) {
843         return now;
844     }
845 }