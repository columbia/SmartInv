1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address _who) external view returns (uint256);
12 
13   function allowance(address _owner, address _spender) external view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) external returns (bool);
16 
17   function approve(address _spender, uint256 _value) external returns (bool);
18 
19   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
20 
21   event Transfer(
22     address indexed from,
23     address indexed to,
24     uint256 value
25   );
26 
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that revert on error
38  */
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, reverts on overflow.
43     */
44     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (_a == 0) {
49             return 0;
50         }
51 
52         uint256 c = _a * _b;
53         require(c / _a == _b,"Math error");
54 
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
60     */
61     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
62         require(_b > 0,"Math error"); // Solidity only automatically asserts when dividing by 0
63         uint256 c = _a / _b;
64         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71     */
72     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
73         require(_b <= _a,"Math error");
74         uint256 c = _a - _b;
75 
76         return c;
77     }
78 
79     /**
80     * @dev Adds two numbers, reverts on overflow.
81     */
82     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
83         uint256 c = _a + _b;
84         require(c >= _a,"Math error");
85 
86         return c;
87     }
88 
89     /**
90     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
91     * reverts when dividing by zero.
92     */
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b != 0,"Math error");
95         return a % b;
96     }
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  * @dev Implementation of the basic standard token.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) internal balances_;
108 
109     mapping (address => mapping (address => uint256)) private allowed_;
110 
111     uint256 private totalSupply_;
112 
113     /**
114     * @dev Total number of tokens in existence
115     */
116     function totalSupply() public view returns (uint256) {
117         return totalSupply_;
118     }
119 
120     /**
121     * @dev Gets the balance of the specified address.
122     * @param _owner The address to query the the balance of.
123     * @return An uint256 representing the amount owned by the passed address.
124     */
125     function balanceOf(address _owner) public view returns (uint256) {
126         return balances_[_owner];
127     }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135     function allowance(
136         address _owner,
137         address _spender
138     )
139       public
140       view
141       returns (uint256)
142     {
143         return allowed_[_owner][_spender];
144     }
145 
146     /**
147     * @dev Transfer token for a specified address
148     * @param _to The address to transfer to.
149     * @param _value The amount to be transferred.
150     */
151     function transfer(address _to, uint256 _value) public returns (bool) {
152         require(_value <= balances_[msg.sender],"Invalid value");
153         require(_to != address(0),"Invalid address");
154 
155         balances_[msg.sender] = balances_[msg.sender].sub(_value);
156         balances_[_to] = balances_[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     /**
162     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163     * Beware that changing an allowance with this method brings the risk that someone may use both the old
164     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     * @param _spender The address which will spend the funds.
168     * @param _value The amount of tokens to be spent.
169     */
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed_[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177     * @dev Transfer tokens from one address to another
178     * @param _from address The address which you want to send tokens from
179     * @param _to address The address which you want to transfer to
180     * @param _value uint256 the amount of tokens to be transferred
181     */
182     function transferFrom(
183         address _from,
184         address _to,
185         uint256 _value
186     )
187       public
188       returns (bool)
189     {
190         require(_value <= balances_[_from],"Value is more than balance");
191         require(_value <= allowed_[_from][msg.sender],"Value is more than alloved");
192         require(_to != address(0),"Invalid address");
193 
194         balances_[_from] = balances_[_from].sub(_value);
195         balances_[_to] = balances_[_to].add(_value);
196         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
197         emit Transfer(_from, _to, _value);
198         return true;
199     }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210     function increaseApproval(
211         address _spender,
212         uint256 _addedValue
213     )
214       public
215       returns (bool)
216     {
217         allowed_[msg.sender][_spender] = (allowed_[msg.sender][_spender].add(_addedValue));
218         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
219         return true;
220     }
221 
222     /**
223     * @dev Decrease the amount of tokens that an owner allowed to a spender.
224     * approve should be called when allowed_[_spender] == 0. To decrement
225     * allowed value is better to use this function to avoid 2 calls (and wait until
226     * the first transaction is mined)
227     * From MonolithDAO Token.sol
228     * @param _spender The address which will spend the funds.
229     * @param _subtractedValue The amount of tokens to decrease the allowance by.
230     */
231     function decreaseApproval(
232         address _spender,
233         uint256 _subtractedValue
234     )
235       public
236       returns (bool)
237     {
238         uint256 oldValue = allowed_[msg.sender][_spender];
239         if (_subtractedValue >= oldValue) {
240             allowed_[msg.sender][_spender] = 0;
241         } else {
242             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243         }
244         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
245         return true;
246     }
247 
248     /**
249     * @dev Internal function that mints an amount of the token and assigns it to
250     * an account. This encapsulates the modification of balances such that the
251     * proper events are emitted.
252     * @param _account The account that will receive the created tokens.
253     * @param _amount The amount that will be created.
254     */
255     function _mint(address _account, uint256 _amount) internal {
256         require(_account != 0,"Invalid address");
257         totalSupply_ = totalSupply_.add(_amount);
258         balances_[_account] = balances_[_account].add(_amount);
259         emit Transfer(address(0), _account, _amount);
260     }
261 
262     /**
263     * @dev Internal function that burns an amount of the token of a given
264     * account.
265     * @param _account The account whose tokens will be burnt.
266     * @param _amount The amount that will be burnt.
267     */
268     function _burn(address _account, uint256 _amount) internal {
269         require(_account != 0,"Invalid address");
270         require(_amount <= balances_[_account],"Amount is more than balance");
271 
272         totalSupply_ = totalSupply_.sub(_amount);
273         balances_[_account] = balances_[_account].sub(_amount);
274         emit Transfer(_account, address(0), _amount);
275     }
276 
277 }
278 
279 
280 /**
281  * @title SafeERC20
282  * @dev Wrappers around ERC20 operations that throw on failure.
283  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
284  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
285  */
286 library SafeERC20 {
287     function safeTransfer(
288         IERC20 _token,
289         address _to,
290         uint256 _value
291     )
292       internal
293     {
294         require(_token.transfer(_to, _value),"Transfer error");
295     }
296 
297     function safeTransferFrom(
298         IERC20 _token,
299         address _from,
300         address _to,
301         uint256 _value
302     )
303       internal
304     {
305         require(_token.transferFrom(_from, _to, _value),"Tranfer error");
306     }
307 
308     function safeApprove(
309         IERC20 _token,
310         address _spender,
311         uint256 _value
312     )
313       internal
314     {
315         require(_token.approve(_spender, _value),"Approve error");
316     }
317 }
318 
319 
320 /**
321  * @title Pausable
322  * @dev Base contract which allows children to implement an emergency stop mechanism.
323  */
324 contract Pausable {
325     event Paused();
326     event Unpaused();
327 
328     bool public paused = false;
329 
330 
331     /**
332     * @dev Modifier to make a function callable only when the contract is not paused.
333     */
334     modifier whenNotPaused() {
335         require(!paused,"Contract is paused, sorry");
336         _;
337     }
338 
339     /**
340     * @dev Modifier to make a function callable only when the contract is paused.
341     */
342     modifier whenPaused() {
343         require(paused, "Contract is running now");
344         _;
345     }
346 
347 }
348 
349 
350 /**
351  * @title Pausable token
352  * @dev ERC20 modified with pausable transfers.
353  **/
354 contract ERC20Pausable is ERC20, Pausable {
355 
356     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
357         return super.transfer(_to, _value);
358     }
359 
360     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
361         return super.transferFrom(_from, _to, _value);
362     }
363 
364     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
365         return super.approve(_spender, _value);
366     }
367 
368     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
369         return super.increaseApproval(_spender, _addedValue);
370     }
371 
372     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
373         return super.decreaseApproval(_spender, _subtractedValue);
374     }
375 }
376 
377 /**
378  * @title Contract ATHLETICO token
379  * @dev ERC20 compatible token contract
380  */
381 contract ATHLETICOToken is ERC20Pausable {
382     string public constant name = "ATHLETICO TOKEN";
383     string public constant symbol = "ATH";
384     uint32 public constant decimals = 18;
385     uint256 public INITIAL_SUPPLY = 1000000000 * 1 ether; // 1 000 000 000
386     address public CrowdsaleAddress;
387     bool public ICOover;
388 
389     mapping (address => bool) public kyc;
390     mapping (address => uint256) public sponsors;
391 
392     event LogSponsor(
393         address indexed from,
394         uint256 value
395     );
396 
397     constructor(address _CrowdsaleAddress) public {
398     
399         CrowdsaleAddress = _CrowdsaleAddress;
400         _mint(_CrowdsaleAddress, INITIAL_SUPPLY);
401     }
402 
403 
404     modifier onlyOwner() {
405         require(msg.sender == CrowdsaleAddress,"Only CrowdSale contract can run this");
406         _;
407     }
408     
409     modifier validDestination( address to ) {
410         require(to != address(0),"Empty address");
411         require(to != address(this),"RESTO Token address");
412         _;
413     }
414     
415     modifier isICOover {
416         if (msg.sender != CrowdsaleAddress){
417             require(ICOover == true,"Transfer of tokens is prohibited until the end of the ICO");
418         }
419         _;
420     }
421     
422     /**
423      * @dev Override for testing address destination
424      */
425     function transfer(address _to, uint256 _value) public validDestination(_to) isICOover returns (bool) {
426         return super.transfer(_to, _value);
427     }
428 
429     /**
430      * @dev Override for testing address destination
431      */
432     function transferFrom(address _from, address _to, uint256 _value) 
433     public validDestination(_to) isICOover returns (bool) 
434     {
435         return super.transferFrom(_from, _to, _value);
436     }
437 
438     
439   /**
440    * @dev Function to mint tokens
441    * can run only from crowdsale contract
442    * @param to The address that will receive the minted tokens.
443    * @param _value The amount of tokens to mint.
444    * @return A boolean that indicates if the operation was successful.
445    */
446     function mint(address to, uint256 _value) public onlyOwner {
447         _mint(to, _value);
448     }
449 
450 
451    /**
452     * @dev Function to burn tokens
453     * Anyone can burn their tokens and in this way help the project.
454     * Information about sponsors is public.
455     * On the project website you can get a sponsor certificate.
456     */
457     function burn(uint256 _value) public {
458         _burn(msg.sender, _value);
459         sponsors[msg.sender] = sponsors[msg.sender].add(_value);
460         emit LogSponsor(msg.sender, _value);
461     }
462 
463     /**
464     * @dev function set kyc bool to true
465     * can run only from crowdsale contract
466     * @param _investor The investor who passed the procedure KYC
467     */
468     function kycPass(address _investor) public onlyOwner {
469         kyc[_investor] = true;
470     }
471 
472     /**
473     * @dev function set kyc bool to false
474     * can run only from crowdsale contract
475     * @param _investor The investor who not passed the procedure KYC (change after passing kyc - something wrong)
476     */
477     function kycNotPass(address _investor) public onlyOwner {
478         kyc[_investor] = false;
479     }
480 
481     /**
482     * @dev function set ICOOver bool to true
483     * can run only from crowdsale contract
484     */
485     function setICOover() public onlyOwner {
486         ICOover = true;
487     }
488 
489     /**
490      * @dev function transfer tokens from special address to users
491      * can run only from crowdsale contract
492      */
493     function transferTokensFromSpecialAddress(address _from, address _to, uint256 _value) public onlyOwner whenNotPaused returns (bool){
494         require (balances_[_from] >= _value,"Decrease value");
495         
496         balances_[_from] = balances_[_from].sub(_value);
497         balances_[_to] = balances_[_to].add(_value);
498         
499         emit Transfer(_from, _to, _value);
500         
501         return true;
502     }
503 
504     /**
505      * @dev called from crowdsale contract to pause, triggers stopped state
506      * can run only from crowdsale contract
507      */
508     function pause() public onlyOwner whenNotPaused {
509         paused = true;
510         emit Paused();
511     }
512 
513     /**
514      * @dev called from crowdsale contract to unpause, returns to normal state
515      * can run only from crowdsale contract
516      */
517     function unpause() public onlyOwner whenPaused {
518         paused = false;
519         emit Unpaused();
520     }
521  
522 }
523 
524 
525 
526 /**
527  * @title Ownable
528  * @dev The Ownable contract has an owner and DAOContract addresses, and provides basic authorization control
529  * functions, this simplifies the implementation of "user permissions".
530  */
531 contract Ownable {
532     address public owner;
533     address public DAOContract;
534     address private candidate;
535 
536     constructor() public {
537         owner = msg.sender;
538         DAOContract = msg.sender;
539     }
540 
541     modifier onlyOwner() {
542         require(msg.sender == owner,"Access denied");
543         _;
544     }
545 
546     modifier onlyDAO() {
547         require(msg.sender == DAOContract,"Access denied");
548         _;
549     }
550 
551     function transferOwnership(address _newOwner) public onlyOwner {
552         require(_newOwner != address(0),"Invalid address");
553         candidate = _newOwner;
554     }
555 
556     function setDAOContract(address _newDAOContract) public onlyOwner {
557         require(_newDAOContract != address(0),"Invalid address");
558         DAOContract = _newDAOContract;
559     }
560 
561 
562     function confirmOwnership() public {
563         require(candidate == msg.sender,"Only from candidate");
564         owner = candidate;
565         delete candidate;
566     }
567 
568 }
569 
570 
571 contract TeamAddress {
572 
573 }
574 
575 
576 contract BountyAddress {
577 
578 }
579 
580 
581 /**
582  * @title Crowdsale
583  * @dev Crowdsale is a base contract for managing a token crowdsale
584  */
585 contract Crowdsale is Ownable {
586     using SafeMath for uint256;
587     using SafeERC20 for ATHLETICOToken;
588 
589     event LogStateSwitch(State newState);
590     event LogRefunding(address indexed to, uint256 amount);
591     mapping(address => uint) public crowdsaleBalances;
592 
593     uint256 public softCap = 250 * 1 ether;
594     address internal myAddress = this;
595     ATHLETICOToken public token = new ATHLETICOToken(myAddress);
596     uint64 public crowdSaleStartTime;       
597     uint64 public crowdSaleEndTime = 1559347200;       // 01.06.2019 0:00:00
598     uint256 internal minValue = 0.005 ether;
599 
600     //Addresses for store tokens
601     TeamAddress public teamAddress = new TeamAddress();
602     BountyAddress public bountyAddress = new BountyAddress();
603       
604     // How many token units a buyer gets per wei.
605     uint256 public rate;
606 
607     // Amount of wei raised
608     uint256 public weiRaised;
609 
610     event LogWithdraw(
611         address indexed from, 
612         address indexed to, 
613         uint256 amount
614     );
615 
616     event LogTokensPurchased(
617         address indexed purchaser,
618         address indexed beneficiary,
619         uint256 value,
620         uint256 amount
621     );
622 
623     // Create state of contract
624     enum State { 
625         Init,    
626         CrowdSale,
627         Refunding,
628         WorkTime
629     }
630 
631     State public currentState = State.Init;
632 
633     modifier onlyInState(State state){ 
634         require(state==currentState); 
635         _; 
636     }
637 
638 
639     constructor() public {
640         uint256 totalTokens = token.INITIAL_SUPPLY();
641         /**
642         * @dev Inicial distributing tokens to special adresses
643         * TeamAddress - 10%
644         * BountyAddress - 5%
645         */
646         _deliverTokens(teamAddress, totalTokens.div(10));
647         _deliverTokens(bountyAddress, totalTokens.div(20));
648 
649         rate = 20000;
650         setState(State.CrowdSale);
651         crowdSaleStartTime = uint64(now);
652     }
653 
654     /**
655      * @dev public function finishing crowdsale if enddate is coming or softcap is passed
656      */
657     function finishCrowdSale() public onlyInState(State.CrowdSale) {
658         require(now >= crowdSaleEndTime || myAddress.balance >= softCap, "Too early");
659         if(myAddress.balance >= softCap) {
660         setState(State.WorkTime);
661         token.setICOover();
662         } else {
663         setState(State.Refunding);
664         }
665     }
666 
667 
668     /**
669     * @dev fallback function
670     */
671     function () external payable {
672         buyTokens(msg.sender);
673     }
674 
675     /**
676     * @dev token purchase
677     * @param _beneficiary Address performing the token purchase
678     */
679     function buyTokens(address _beneficiary) public payable {
680         uint256 weiAmount = msg.value;
681         _preValidatePurchase(_beneficiary, weiAmount);
682 
683         // calculate token amount to be created
684         uint256 tokens = _getTokenAmount(weiAmount);
685 
686         // update state
687         weiRaised = weiRaised.add(weiAmount);
688 
689         _processPurchase(_beneficiary, tokens);
690 
691         crowdsaleBalances[_beneficiary] = crowdsaleBalances[_beneficiary].add(weiAmount);
692         
693         emit LogTokensPurchased(
694             msg.sender,
695             _beneficiary,
696             weiAmount,
697             tokens
698         );
699 
700     }
701 
702 
703     function setState(State _state) internal {
704         currentState = _state;
705         emit LogStateSwitch(_state);
706     }
707 
708 
709     /**
710      * @dev called by the owner to pause, triggers stopped state
711      */
712     function pauseCrowdsale() public onlyOwner {
713         token.pause();
714     }
715 
716     /**
717      * @dev called by the owner to unpause, returns to normal state
718      */
719     function unpauseCrowdsale() public onlyOwner {
720         token.unpause();
721     }
722 
723     /**
724      * @dev called by the DAO to set new rate
725      */
726     function setRate(uint256 _newRate) public onlyDAO {
727         rate = _newRate;
728     }
729 
730     /**
731      * @dev function set kyc bool to true
732      * @param _investor The investor who passed the procedure KYC
733      */
734     function setKYCpassed(address _investor) public onlyDAO returns(bool){
735         token.kycPass(_investor);
736         return true;
737     }
738 
739     /**
740      * @dev function set kyc bool to false
741      * @param _investor The investor who not passed the procedure KYC after passing
742      */
743     function setKYCNotPassed(address _investor) public onlyDAO returns(bool){
744         token.kycNotPass(_investor);
745         return true;
746     }
747 
748     /**
749      * @dev the function tranfer tokens from TeamAddress 
750      */
751     function transferTokensFromTeamAddress(address _investor, uint256 _value) public onlyDAO returns(bool){
752         token.transferTokensFromSpecialAddress(address(teamAddress), _investor, _value); 
753         return true;
754     } 
755 
756     
757     /**
758      * @dev the function tranfer tokens from BountyAddress 
759      */
760     function transferTokensFromBountyAddress(address _investor, uint256 _value) public onlyDAO returns(bool){
761         token.transferTokensFromSpecialAddress(address(bountyAddress), _investor, _value); 
762         return true;
763     } 
764     
765     /**
766      * @dev Validation of an incoming purchase. internal function.
767      * @param _beneficiary Address performing the token purchase
768      * @param _weiAmount Value in wei involved in the purchase
769      */
770     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view{
771         require(_beneficiary != address(0),"Invalid address");
772         require(_weiAmount >= minValue,"Min amount is 0.005 ether");
773         require(currentState != State.Refunding, "Only for CrowdSale and Work stage.");
774     }
775 
776     /**
777      * @dev internal function
778      * @param _beneficiary Address performing the token purchase
779      * @param _tokenAmount Number of tokens to be emitted
780      */
781     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
782         token.safeTransfer(_beneficiary, _tokenAmount);
783     }
784 
785 
786     /**
787      * @dev Function transfer token to new investors
788      * Access restricted DAO
789      */ 
790     function transferTokens(address _newInvestor, uint256 _tokenAmount) public onlyDAO {
791         _deliverTokens(_newInvestor, _tokenAmount);
792     }
793 
794     /**
795      * @dev Function mint tokens to winners or prize funds contracts
796      * Access restricted DAO
797      */ 
798     function mintTokensToWinners(address _address, uint256 _tokenAmount) public onlyDAO {
799         require(currentState == State.WorkTime, "CrowdSale is not finished yet. Access denied.");
800         token.mint(_address, _tokenAmount);
801     }
802 
803     /**
804     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
805     * @param _beneficiary Address receiving the tokens
806     * @param _tokenAmount Number of tokens to be purchased
807     */
808     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
809         _deliverTokens(_beneficiary, _tokenAmount);
810         
811     }
812 
813 
814     /**
815     * @dev this function is ether converted to tokens.
816     * @param _weiAmount Value in wei to be converted into tokens
817     * @return Number of tokens that can be purchased with the specified _weiAmount
818     */
819     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
820         uint256 bonus = 0;
821         uint256 resultAmount = _weiAmount;
822 
823 
824         /**
825         * ICO bonus                        UnisTimeStamp 
826         *                                  Start date       End date
827         * StartTime -01.01.2019 - 100%     1543622400       1546300800
828         * 01.01.2019-01.02.2019 - 50%      1546300800       1548979200
829         * 01.02.2019-01.03.2019 - 25%      1548979200       1551398400
830         */
831         if (now >= crowdSaleStartTime && now < 1546300800) {
832             bonus = 100;
833         }
834         if (now >= 1546300800 && now < 1548979200) {
835             bonus = 50;
836         }
837         if (now >= 1548979200 && now < 1551398400) {
838             bonus = 25;
839         }
840         
841         if (bonus > 0) {
842             resultAmount += _weiAmount.mul(bonus).div(100);
843         }
844         return resultAmount.mul(rate);
845     }
846 
847     /**
848      * @dev function returns funds to investors in case of project failure.
849      */
850     function refund() public payable{
851         require(currentState == State.Refunding, "Only for Refunding stage.");
852         // refund ether to investors
853         uint value = crowdsaleBalances[msg.sender]; 
854         crowdsaleBalances[msg.sender] = 0; 
855         msg.sender.transfer(value);
856         emit LogRefunding(msg.sender, value);
857     }
858 
859     /**
860      * @dev function of withdrawal of funds for the development of the project if successful
861      */
862     function withdrawFunds (address _to, uint256 _value) public onlyDAO {
863         require(currentState == State.WorkTime, "CrowdSale is not finished yet. Access denied.");
864         require (myAddress.balance >= _value,"Value is more than balance");
865         require(_to != address(0),"Invalid address");
866         _to.transfer(_value);
867         emit LogWithdraw(msg.sender, _to, _value);
868     }
869 
870 }