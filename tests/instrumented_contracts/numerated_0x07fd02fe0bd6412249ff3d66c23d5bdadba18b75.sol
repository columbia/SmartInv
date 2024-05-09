1 /**
2  * @title ERC20 interface
3  * @dev see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6 
7     function totalSupply() public view returns (uint256);
8 
9     function balanceOf(address _who) public view returns (uint256);
10 
11     function allowance(address _owner, address _spender) public view returns (uint256);
12 
13     function transfer(address _to, uint256 _value) public returns (bool);
14 
15     function approve(address _spender, uint256 _value) public returns (bool);
16 
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
18 
19     event Transfer (address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22     
23 }
24 
25 /**
26  * @title Standard ERC20 token
27  *
28  * @dev Implementation of the basic standard token.
29  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
30  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
31  */
32 contract StandardToken is ERC20 {
33     
34     using SafeMath for uint256;
35 
36     mapping (address => uint256) internal balances;
37 
38     mapping (address => mapping (address => uint256)) private allowed;
39 
40     uint256 internal totalSupply_;
41 
42     /**
43     * @dev Total tokens amount
44     */
45     function totalSupply() public view returns (uint256) {
46         return totalSupply_;
47     }
48 
49     /**
50     * @dev Gets the balance of the specified address.
51     * @param _owner The address to query the the balance of.
52     * @return An uint256 representing the amount owned by the passed address.
53     */
54     function balanceOf(address _owner) public view returns (uint256) {
55         return balances[_owner];
56     }
57 
58     /**
59     * @dev Function to check the amount of tokens that an owner allowed to a spender.
60     * @param _owner address The address which owns the funds.
61     * @param _spender address The address which will spend the funds.
62     * @return A uint256 specifying the amount of tokens still available for the spender.
63     */
64     function allowance(address _owner,address _spender) public view returns (uint256){
65         return allowed[_owner][_spender];
66     }
67 
68     /**
69     * @dev Transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_value <= balances[msg.sender]);
75         require(_to != address(0));
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     /**
84     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
85     * Beware that changing an allowance with this method brings the risk that someone may use both the old
86     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
87     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
88     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89     * @param _spender The address which will spend the funds.
90     * @param _value The amount of tokens to be spent.
91     */
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Transfer tokens from one address to another
100     * @param _from address The address which you want to send tokens from
101     * @param _to address The address which you want to transfer to
102     * @param _value uint256 the amount of tokens to be transferred
103     */
104     function transferFrom(address _from,address _to,uint256 _value)public returns (bool){
105         require(_value <= balances[_from]);
106         require(_value <= allowed[_from][msg.sender]);
107         require(_to != address(0));
108 
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         emit Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Increase the amount of tokens that an owner allowed to a spender.
118     * approve should be called when allowed[_spender] == 0. To increment
119     * allowed value is better to use this function to avoid 2 calls (and wait until
120     * the first transaction is mined)
121     * From MonolithDAO Token.sol
122     * @param _spender The address which will spend the funds.
123     * @param _addedValue The amount of tokens to increase the allowance by.
124     */
125     function increaseApproval(address _spender,uint256 _addedValue) public returns (bool){
126         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
127         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130 
131     /**
132     * @dev Decrease the amount of tokens that an owner allowed to a spender.
133     * approve should be called when allowed[_spender] == 0. To decrement
134     * allowed value is better to use this function to avoid 2 calls (and wait until
135     * the first transaction is mined)
136     * From MonolithDAO Token.sol
137     * @param _spender The address which will spend the funds.
138     * @param _subtractedValue The amount of tokens to decrease the allowance by.
139     */
140     function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool){
141         uint256 oldValue = allowed[msg.sender][_spender];
142         if (_subtractedValue >= oldValue) {
143             allowed[msg.sender][_spender] = 0;
144         } else {
145             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 }
151 
152 /**
153  * @title Rate means
154  * @dev The contract purposed for managing crowdsale financial data,
155  *      such as rates, prices, limits and etc.
156  */
157 contract Rate  {
158     
159     using SafeMath for uint;
160     
161     //  Ether / US cent exchange rate
162     uint public ETHUSDC;
163     
164     //  Token price in US cents
165     uint public usCentsPrice;
166     
167     //  Token price in wei
168     uint public tokenWeiPrice;
169     
170     //  Minimum wei amount derived from requiredDollarAmount parameter
171     uint public requiredWeiAmount;
172     
173     //  Minimum dollar amount that investor can provide for purchasing
174     uint public requiredDollarAmount;
175 
176     //  Total tokens amount which can be sold at the current crowdsale stage
177     uint internal percentLimit;
178 
179     //  All percent limits according to Crowdsale stages
180     uint[] internal percentLimits = [10, 27, 53, 0];
181     
182     //  Event for interacting with OraclizeAPI
183     event LogConstructorInitiated(string  nextStep);
184     
185     //  Event for price updating
186     event LogPriceUpdated(string price);
187     
188     //  Event for logging oraclize queries
189     event LogNewOraclizeQuery(string  description);
190 
191 
192     function ethersToTokens(uint _ethAmount)
193     public
194     view
195     returns(uint microTokens)
196     {
197         uint centsAmount = _ethAmount.mul(ETHUSDC);
198         return centsToTokens(centsAmount);
199     }
200     
201     function centsToTokens(uint _cents)
202     public
203     view
204     returns(uint microTokens)
205     {
206         require(_cents > 0);
207         microTokens = _cents.mul(1000000).div(usCentsPrice);
208         return microTokens;
209     }
210     
211     function tokensToWei(uint _microTokensAmount)
212     public
213     view
214     returns(uint weiAmount) {
215         uint centsWei = SafeMath.div(1 ether, ETHUSDC);
216         uint microTokenWeiPrice = centsWei.mul(usCentsPrice).div(10 ** 6);
217         weiAmount = _microTokensAmount.mul(microTokenWeiPrice);
218         return weiAmount;
219     }
220     
221     function tokensToCents(uint _microTokenAmount)
222     public
223     view
224     returns(uint centsAmount) {
225         centsAmount = _microTokenAmount.mul(usCentsPrice).div(1000000);
226         return centsAmount;
227     }
228     
229 
230     function stringUpdate(string _rate) internal {
231         ETHUSDC = getInt(_rate, 0);
232         uint centsWei = SafeMath.div(1 ether, ETHUSDC);
233         tokenWeiPrice = usCentsPrice.mul(centsWei);
234         requiredWeiAmount = requiredDollarAmount.mul(100).mul(1 ether).div(ETHUSDC);
235     }
236     
237     function getInt(string _a, uint _b) private pure returns (uint) {
238         bytes memory bresult = bytes(_a);
239         uint mint = 0;
240         bool decimals = false;
241         for (uint i = 0; i < bresult.length; i++) {
242             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
243                 if (decimals) {
244                     if (_b == 0) break;
245                     else _b--;
246                 }
247                 mint *= 10;
248                 mint += uint(bresult[i]) - 48;
249             } else if (bresult[i] == 46) decimals = true;
250         }
251         return mint;
252     }
253     
254 }
255 
256 /**
257  * @title IMPCoin implementation based on ERC20 standard token
258  */
259 contract IMPERIVMCoin is StandardToken {
260     
261     using SafeMath for uint;
262     
263     string public name = "IMPERIVMCoin";
264     string public symbol = "IMPC";
265     uint8 public decimals = 6;
266     
267     address owner;
268     
269     /**
270      *  @dev Contract initiallization
271      *  @param _initialSupply total tokens amount
272      */
273     constructor(uint _initialSupply) public {
274         totalSupply_ = _initialSupply * 10 ** uint(decimals);
275         owner = msg.sender;
276         balances[owner] = balances[owner].add(totalSupply_);
277     }
278     
279 }  
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  *      functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287 
288     //  The account who initially deployed both an IMPCoin and IMPCrowdsale contracts
289     address public initialOwner;
290     
291     mapping(address => bool) owners;
292     
293     /**
294      * Event for adding owner
295      * @param admin is an account gonna be added to the admin list
296      */
297     event AddOwner(address indexed admin);
298     
299     /**
300      * Event for deleting owner
301      * @param admin is an account gonna be deleted from the admin list
302      */
303     event DeleteOwner(address indexed admin);
304     
305     /**
306      * @dev Throws if called by any account other than the owner.
307      */
308     modifier onlyOwners() {
309         require(
310             msg.sender == initialOwner
311             || inOwners(msg.sender)
312         );
313         _;
314     }
315     
316     /**
317      * @dev Throws if called by any account other than the initial owner.
318      */
319     modifier onlyInitialOwner() {
320         require(msg.sender == initialOwner);
321         _;
322     }
323     
324     /**
325      * @dev adding admin account to the admins list
326      * @param _wallet is an account gonna be approved as an admin account
327      */
328     function addOwner(address _wallet) public onlyInitialOwner {
329         owners[_wallet] = true;
330         emit AddOwner(_wallet);
331     }
332     
333     /**
334      * @dev deleting admin account from the admins list
335      * @param _wallet is an account gonna be deleted from the admins list
336      */
337     function deleteOwner(address _wallet) public onlyInitialOwner {
338         owners[_wallet] = false;
339         emit DeleteOwner(_wallet);
340     }
341     
342     /**
343      * @dev checking if account is admin or not
344      * @param _wallet is an account for checking
345      */
346     function inOwners(address _wallet)
347     public
348     view
349     returns(bool)
350     {
351         if(owners[_wallet]){ 
352             return true;
353         }
354         return false;
355     }
356     
357 }
358 
359 /**
360  * @title Lifecycle means
361  * @dev The contract purposed for managing crowdsale lifecycle
362  */
363 contract Lifecycle is Ownable, Rate {
364     
365     /**
366      * Enumeration describing all crowdsale stages
367      * @ Private for small group of privileged investors
368      * @ PreSale for more wide and less privileged group of investors
369      * @ Sale for all buyers
370      * @ Cancel crowdsale completing stage
371      * @ Stopped special stage for updates and force-major handling
372      */
373     enum Stages {
374         Private,
375         PreSale,
376         Sale,
377         Cancel,
378         Stopped
379     }
380     
381     //  Previous crowdsale stage
382     Stages public previousStage;
383     
384     //  Current crowdsale stage
385     Stages public crowdsaleStage;
386     
387     //  Event for crowdsale stopping
388     event ICOStopped(uint timeStamp);
389     
390     //  Event for crowdsale continuing after stopping
391     event ICOContinued(uint timeStamp);
392     
393     //  Event for crowdsale starting
394     event CrowdsaleStarted(uint timeStamp);
395     
396     /**
397     * Event for ICO stage switching
398     * @param timeStamp time of switching
399     * @param newPrice one token price (US cents)
400     * @param newRequiredDollarAmount new minimum limit for investment
401     */
402     event ICOSwitched(uint timeStamp,uint newPrice,uint newRequiredDollarAmount);
403     
404     modifier appropriateStage() {
405         require(
406             crowdsaleStage != Stages.Cancel,
407             "ICO is finished now"
408         );
409         
410         require(
411             crowdsaleStage != Stages.Stopped,
412             "ICO is temporary stopped at the moment"
413         );
414         _;
415     }
416     
417     function stopCrowdsale()
418     public
419     onlyOwners
420     {
421         require(crowdsaleStage != Stages.Stopped);
422         previousStage = crowdsaleStage;
423         crowdsaleStage = Stages.Stopped;
424         
425         emit ICOStopped(now);
426     }
427     
428     function continueCrowdsale()
429     public
430     onlyOwners
431     {
432         require(crowdsaleStage == Stages.Stopped);
433         crowdsaleStage = previousStage;
434         previousStage = Stages.Stopped;
435         
436         emit ICOContinued(now);
437     }
438     
439     function nextStage(
440         uint _cents,
441         uint _requiredDollarAmount
442     )
443     public
444     onlyOwners
445     appropriateStage
446     {
447         crowdsaleStage = Stages(uint(crowdsaleStage)+1);
448         setUpConditions( _cents, _requiredDollarAmount);
449         emit ICOSwitched(now,_cents,_requiredDollarAmount);
450     }
451     
452     /**
453      * @dev Setting up specified parameters for particular ICO stage
454      * @param _cents One token cost in U.S. cents
455      * @param _requiredDollarAmount Minimal dollar amount whicn Investor can send for buying purpose
456      */
457     function setUpConditions(
458         uint _cents,
459         uint _requiredDollarAmount
460     )
461     internal
462     {
463         require(_cents > 0);
464         require(_requiredDollarAmount > 0);
465         
466         percentLimit =  percentLimits[ uint(crowdsaleStage) ];
467         usCentsPrice = _cents;
468         requiredDollarAmount = _requiredDollarAmount;
469     }
470     
471 }
472 
473 
474 
475 /**
476  * @title SafeMath
477  * @dev Math operations with safety checks that revert on error
478  */
479 library SafeMath {
480 
481     /**
482     * @dev Multiplies two numbers, reverts on overflow.
483     */
484     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
485         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
486         // benefit is lost if 'b' is also tested.
487         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
488         if (_a == 0) {
489             return 0;
490         }
491 
492         uint256 c = _a * _b;
493         require(c / _a == _b);
494 
495         return c;
496     }
497 
498     /**
499     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
500     */
501     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
502         require(_b > 0); // Solidity only automatically asserts when dividing by 0
503         uint256 c = _a / _b;
504         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
505 
506         return c;
507     }
508 
509     /**
510     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
511     */
512     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
513         require(_b <= _a);
514         uint256 c = _a - _b;
515 
516         return c;
517     }
518 
519     /**
520     * @dev Adds two numbers, reverts on overflow.
521     */
522     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
523         uint256 c = _a + _b;
524         require(c >= _a);
525 
526         return c;
527     }
528 
529     /**
530     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
531     * reverts when dividing by zero.
532     */
533     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
534         require(b != 0);
535         return a % b;
536     }
537 }
538 
539 
540 
541 /**
542  * @title Verification means
543  * @dev The contract purposed for validating ethereum accounts
544  *      able to buy IMP Coin
545  */
546 contract Verification is Ownable {
547     
548     /**
549      * Event for adding buyer
550      * @param buyer is a new buyer
551      */
552     event AddBuyer(address indexed buyer);
553     
554     /**
555      * Event for deleting buyer
556      * @param buyer is a buyer gonna be deleted
557      * @param success is a result of deleting operation
558      */
559     event DeleteBuyer(address indexed buyer, bool indexed success);
560     
561     mapping(address => bool) public approvedBuyers;
562     
563     /**
564      * @dev adding buyer to the list of approved buyers
565      * @param _buyer account gonna to be added
566      */
567     function addBuyer(address _buyer)
568     public
569     onlyOwners
570     returns(bool success)
571     {
572         approvedBuyers[_buyer] = true;
573         emit AddBuyer(_buyer);
574         return true;
575     }  
576     
577     /**
578      * @dev deleting buyer from the list of approved buyers
579      * @param _buyer account gonna to be deleted
580      */
581     function deleteBuyer(address _buyer)
582     public
583     onlyOwners
584     returns(bool success)
585     {
586         if (approvedBuyers[_buyer]) {
587             delete approvedBuyers[_buyer];
588             emit DeleteBuyer(_buyer, true);
589             return true;
590         } else {
591             emit DeleteBuyer(_buyer, false);
592             return false;
593         }
594     }
595     
596     /**
597      * @dev If specified account address is in approved buyers list
598      *      then the function returns true, otherwise returns false
599      */
600     function getBuyer(address _buyer) public view  returns(bool success){
601         if (approvedBuyers[_buyer]){
602             return true;  
603         }
604         return false;        
605     }
606     
607 }
608 /**
609  * @dev Brainspace crowdsale contract
610  */
611 contract IMPCrowdsale is Lifecycle, Verification {
612 
613     using SafeMath for uint;
614      
615     //  Token contract for the Crowdsale
616     IMPERIVMCoin public token;
617     
618     //  Total amount of received wei
619     uint public weiRaised;
620     
621     //  Total amount of sold tokens
622     uint public totalSold;
623     
624     //  The variable is purposed for ETHUSD updating
625     uint lastTimeStamp;
626     
627     /**
628      * Event for token purchase logging
629      * @param purchaser who paid for the tokens
630      * @param value weis paid for purchase
631      * @param amount amount of tokens purchased
632      */
633     event TokenPurchase(
634         address indexed purchaser,
635         uint value,
636         uint amount
637     );
638     
639     /**
640      * Event for token purchase logging
641      * @param rate new rate
642      */
643     event StringUpdate(string rate);
644     
645     
646     /**
647      * Event for manual token transfer
648      * @param to receiver address
649      * @param value tokens amount
650      */
651     event ManualTransfer(address indexed to, uint indexed value);
652 
653     constructor(
654         IMPERIVMCoin _token,
655         uint _cents,
656         uint _requiredDollarAmount
657     )
658     public
659     {
660         require(_token != address(0));
661         token = _token;
662         initialOwner = msg.sender;
663         setUpConditions( _cents, _requiredDollarAmount);
664         crowdsaleStage = Stages.Sale;
665     }
666     
667     /**
668      * @dev callback
669      */
670     function () public payable {
671         initialOwner.transfer(msg.value);
672     }
673     
674     /**
675      * @dev low level token purchase ***DO NOT OVERRIDE***
676      */
677     function buyTokens()
678     public
679     payable
680     appropriateStage
681     {
682         require(approvedBuyers[msg.sender]);
683         require(totalSold <= token.totalSupply().div(100).mul(percentLimit));
684 
685         uint weiAmount = msg.value;
686         _preValidatePurchase(weiAmount);
687 
688         // calculate token amount to be created
689         uint tokens = _getTokenAmount(weiAmount);
690 
691         // update state
692         weiRaised = weiRaised.add(weiAmount);
693 
694         _processPurchase(tokens);
695         
696         emit TokenPurchase(
697             msg.sender,
698             weiAmount,
699             tokens
700         );
701 
702         _forwardFunds();
703         _postValidatePurchase(tokens);
704     }
705     
706     
707     /**
708      * @dev manual ETHUSD rate updating according to exchange data
709      * @param _rate is the rate gonna be set up
710      */
711     function stringCourse(string _rate) public payable onlyOwners {
712         stringUpdate(_rate);
713         lastTimeStamp = now;
714         emit StringUpdate(_rate);
715     }
716     
717     function manualTokenTransfer(address _to, uint _value)
718     public
719     onlyOwners
720     returns(bool success)
721     {
722         if(approvedBuyers[_to]) {
723             totalSold = totalSold.add(_value);
724             token.transferFrom(initialOwner, _to, _value);
725             emit ManualTransfer(_to, _value);
726             return true;    
727         } else {
728             return false;
729         }
730     }
731     
732     function _preValidatePurchase(uint _weiAmount)
733     internal
734     view
735     {
736         require(
737             _weiAmount >= requiredWeiAmount,
738             "Your investment funds are less than minimum allowable amount for tokens buying"
739         );
740     }
741     
742     /**
743      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
744      */
745     function _postValidatePurchase(uint _tokensAmount)
746     internal
747     {
748         totalSold = totalSold.add(_tokensAmount);
749     }
750     
751     /**
752      * @dev Get tokens amount for purchasing
753      * @param _weiAmount Value in wei to be converted into tokens
754      * @return Number of tokens that can be purchased with the specified _weiAmount
755      */
756     function _getTokenAmount(uint _weiAmount)
757     internal
758     view
759     returns (uint)
760     {
761         uint centsWei = SafeMath.div(1 ether, ETHUSDC);
762         uint microTokenWeiPrice = centsWei.mul(usCentsPrice).div(10 ** uint(token.decimals()));
763         uint amountTokensForInvestor = _weiAmount.div(microTokenWeiPrice);
764         
765         return amountTokensForInvestor;
766     }
767     
768     /**
769      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
770      * @param _tokenAmount Number of tokens to be emitted
771      */
772     function _deliverTokens(uint _tokenAmount) internal {
773         token.transferFrom(initialOwner, msg.sender, _tokenAmount);
774     }
775     
776     /**
777      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
778      * @param _tokenAmount Number of tokens to be purchased
779      */
780     function _processPurchase(uint _tokenAmount) internal {
781         _deliverTokens(_tokenAmount);
782     }
783 
784     /**
785      * @dev Determines how ETH is stored/forwarded on purchases.
786      */
787     function _forwardFunds() internal {
788         initialOwner.transfer(msg.value);
789     }
790     
791     function destroy() public onlyInitialOwner {
792         selfdestruct(this);
793     }
794 }