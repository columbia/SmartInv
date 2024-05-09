1 /**
2  * In this place you can write any text before deploy the contract in MainNet
3  */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13   function totalSupply() external view returns (uint256);
14 
15   function balanceOf(address _who) external view returns (uint256);
16 
17   function allowance(address _owner, address _spender) external view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) external returns (bool);
20 
21   function approve(address _spender, uint256 _value) external returns (bool);
22 
23   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that revert on error
42  */
43 library SafeMath {
44 
45     /**
46     * @dev Multiplies two numbers, reverts on overflow.
47     */
48     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (_a == 0) {
53             return 0;
54         }
55 
56         uint256 c = _a * _b;
57         require(c / _a == _b,"Math error");
58 
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
64     */
65     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66         require(_b > 0,"Math error"); // Solidity only automatically asserts when dividing by 0
67         uint256 c = _a / _b;
68         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
77         require(_b <= _a,"Math error");
78         uint256 c = _a - _b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Adds two numbers, reverts on overflow.
85     */
86     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
87         uint256 c = _a + _b;
88         require(c >= _a,"Math error");
89 
90         return c;
91     }
92 
93     /**
94     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
95     * reverts when dividing by zero.
96     */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0,"Math error");
99         return a % b;
100     }
101 }
102 
103 
104 /**
105  * @title Standard ERC20 token
106  * @dev Implementation of the basic standard token.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) internal balances_;
112 
113     mapping (address => mapping (address => uint256)) private allowed_;
114 
115     uint256 private totalSupply_;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return totalSupply_;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256) {
130         return balances_[_owner];
131     }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139     function allowance(
140         address _owner,
141         address _spender
142     )
143       public
144       view
145       returns (uint256)
146     {
147         return allowed_[_owner][_spender];
148     }
149 
150     /**
151     * @dev Transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) public returns (bool) {
156         require(_value <= balances_[msg.sender],"Invalid value");
157         require(_to != address(0),"Invalid address");
158 
159         balances_[msg.sender] = balances_[msg.sender].sub(_value);
160         balances_[_to] = balances_[_to].add(_value);
161         emit Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     * Beware that changing an allowance with this method brings the risk that someone may use both the old
168     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     * @param _spender The address which will spend the funds.
172     * @param _value The amount of tokens to be spent.
173     */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed_[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181     * @dev Transfer tokens from one address to another
182     * @param _from address The address which you want to send tokens from
183     * @param _to address The address which you want to transfer to
184     * @param _value uint256 the amount of tokens to be transferred
185     */
186     function transferFrom(
187         address _from,
188         address _to,
189         uint256 _value
190     )
191       public
192       returns (bool)
193     {
194         require(_value <= balances_[_from],"Value is more than balance");
195         require(_value <= allowed_[_from][msg.sender],"Value is more than alloved");
196         require(_to != address(0),"Invalid address");
197 
198         balances_[_from] = balances_[_from].sub(_value);
199         balances_[_to] = balances_[_to].add(_value);
200         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
201         emit Transfer(_from, _to, _value);
202         return true;
203     }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed_[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214     function increaseApproval(
215         address _spender,
216         uint256 _addedValue
217     )
218       public
219       returns (bool)
220     {
221         allowed_[msg.sender][_spender] = (allowed_[msg.sender][_spender].add(_addedValue));
222         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Decrease the amount of tokens that an owner allowed to a spender.
228     * approve should be called when allowed_[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * From MonolithDAO Token.sol
232     * @param _spender The address which will spend the funds.
233     * @param _subtractedValue The amount of tokens to decrease the allowance by.
234     */
235     function decreaseApproval(
236         address _spender,
237         uint256 _subtractedValue
238     )
239       public
240       returns (bool)
241     {
242         uint256 oldValue = allowed_[msg.sender][_spender];
243         if (_subtractedValue >= oldValue) {
244             allowed_[msg.sender][_spender] = 0;
245         } else {
246             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247         }
248         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
249         return true;
250     }
251 
252     /**
253     * @dev Internal function that mints an amount of the token and assigns it to
254     * an account. This encapsulates the modification of balances such that the
255     * proper events are emitted.
256     * @param _account The account that will receive the created tokens.
257     * @param _amount The amount that will be created.
258     */
259     function _mint(address _account, uint256 _amount) internal {
260         require(_account != 0,"Invalid address");
261         totalSupply_ = totalSupply_.add(_amount);
262         balances_[_account] = balances_[_account].add(_amount);
263         emit Transfer(address(0), _account, _amount);
264     }
265 
266     /**
267     * @dev Internal function that burns an amount of the token of a given
268     * account.
269     * @param _account The account whose tokens will be burnt.
270     * @param _amount The amount that will be burnt.
271     */
272     function _burn(address _account, uint256 _amount) internal {
273         require(_account != 0,"Invalid address");
274         require(_amount <= balances_[_account],"Amount is more than balance");
275 
276         totalSupply_ = totalSupply_.sub(_amount);
277         balances_[_account] = balances_[_account].sub(_amount);
278         emit Transfer(_account, address(0), _amount);
279     }
280 
281     /**
282     * @dev Internal function that burns an amount of the token of a given
283     * account, deducting from the sender's allowance for said account. Uses the
284     * internal _burn function.
285     * @param _account The account whose tokens will be burnt.
286     * @param _amount The amount that will be burnt.
287     */
288     function _burnFrom(address _account, uint256 _amount) internal {
289         require(_amount <= allowed_[_account][msg.sender],"Amount is more than alloved");
290 
291         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
292         // this function needs to emit an event with the updated approval.
293         allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(_amount);
294         _burn(_account, _amount);
295     }
296 }
297 
298 
299 /**
300  * @title SafeERC20
301  * @dev Wrappers around ERC20 operations that throw on failure.
302  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
303  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
304  */
305 library SafeERC20 {
306     function safeTransfer(
307         IERC20 _token,
308         address _to,
309         uint256 _value
310     )
311       internal
312     {
313         require(_token.transfer(_to, _value),"Transfer error");
314     }
315 
316     function safeTransferFrom(
317         IERC20 _token,
318         address _from,
319         address _to,
320         uint256 _value
321     )
322       internal
323     {
324         require(_token.transferFrom(_from, _to, _value),"Tranfer error");
325     }
326 
327     function safeApprove(
328         IERC20 _token,
329         address _spender,
330         uint256 _value
331     )
332       internal
333     {
334         require(_token.approve(_spender, _value),"Approve error");
335     }
336 }
337 
338 
339 /**
340  * @title Pausable
341  * @dev Base contract which allows children to implement an emergency stop mechanism.
342  */
343 contract Pausable {
344     event Paused();
345     event Unpaused();
346 
347     bool public paused = false;
348 
349 
350     /**
351     * @dev Modifier to make a function callable only when the contract is not paused.
352     */
353     modifier whenNotPaused() {
354         require(!paused,"Contract is paused, sorry");
355         _;
356     }
357 
358     /**
359     * @dev Modifier to make a function callable only when the contract is paused.
360     */
361     modifier whenPaused() {
362         require(paused, "Contract is running now");
363         _;
364     }
365 
366 }
367 
368 
369 /**
370  * @title Pausable token
371  * @dev ERC20 modified with pausable transfers.
372  **/
373 contract ERC20Pausable is ERC20, Pausable {
374 
375     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
376         return super.transfer(_to, _value);
377     }
378 
379     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
380         return super.transferFrom(_from, _to, _value);
381     }
382 
383     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
384         return super.approve(_spender, _value);
385     }
386 
387     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
388         return super.increaseApproval(_spender, _addedValue);
389     }
390 
391     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
392         return super.decreaseApproval(_spender, _subtractedValue);
393     }
394 }
395 
396 /**
397  * @title Contract RESTO token
398  * @dev ERC20 compatible token contract
399  */
400 contract RESTOToken is ERC20Pausable {
401     string public constant name = "RESTO";
402     string public constant symbol = "RESTO";
403     uint32 public constant decimals = 18;
404     uint256 public INITIAL_SUPPLY = 1100000000 * 1 ether; // 1 100 000 000
405     address public CrowdsaleAddress;
406     uint64 crowdSaleEndTime = 1544745600;       // 14.12.2018
407 
408     mapping (address => bool) internal kyc;
409 
410 
411     constructor(address _CrowdsaleAddress) public {
412     
413         CrowdsaleAddress = _CrowdsaleAddress;
414         _mint(_CrowdsaleAddress, INITIAL_SUPPLY);
415     }
416 
417     modifier kyc_passed(address _investor) {
418         if (_investor != CrowdsaleAddress){
419             require(kyc[_investor],"For transfer tokens you need to go through the procedure KYC");
420         }
421         _;
422     }
423 
424     modifier onlyOwner() {
425         require(msg.sender == CrowdsaleAddress,"Only CrowdSale contract can run this");
426         _;
427     }
428     
429     modifier validDestination( address to ) {
430         require(to != address(0x0),"Empty address");
431         require(to != address(this),"RESTO Token address");
432         _;
433     }
434     
435     modifier isICOover {
436         if (msg.sender != CrowdsaleAddress){
437             require(now > crowdSaleEndTime,"Transfer of tokens is prohibited until the end of the ICO");
438         }
439         _;
440     }
441     
442     /**
443      * @dev Override for testing address destination
444      */
445     function transfer(address _to, uint256 _value) public validDestination(_to) kyc_passed(msg.sender) isICOover returns (bool) {
446         return super.transfer(_to, _value);
447     }
448 
449     /**
450      * @dev Override for testing address destination
451      */
452     function transferFrom(address _from, address _to, uint256 _value) 
453     public validDestination(_to) kyc_passed(msg.sender) isICOover returns (bool) 
454     {
455         return super.transferFrom(_from, _to, _value);
456     }
457 
458     
459     /**
460      * @dev function set kyc bool to true
461      * can run only from crowdsale contract
462      * @param _investor The investor who passed the procedure KYC
463      */
464     function kycPass(address _investor) public onlyOwner {
465         kyc[_investor] = true;
466     }
467 
468 
469     /**
470      * @dev function transfer tokens from special address to users
471      * can run only from crowdsale contract
472      * @param _value is entered in whole tokens (1 = 1 token)
473      */
474     function transferTokensFromSpecialAddress(address _from, address _to, uint256 _value) public onlyOwner whenNotPaused returns (bool){
475         uint256 value = _value;
476         require (value >= 1,"Min value is 1");
477         value = value.mul(1 ether);
478         require (balances_[_from] >= value,"Decrease value");
479         
480         balances_[_from] = balances_[_from].sub(value);
481         balances_[_to] = balances_[_to].add(value);
482         
483         emit Transfer(_from, _to, value);
484         
485         return true;
486     }
487 
488     /**
489      * @dev called from crowdsale contract to pause, triggers stopped state
490      * can run only from crowdsale contract
491      */
492     function pause() public onlyOwner whenNotPaused {
493         paused = true;
494         emit Paused();
495     }
496 
497     /**
498      * @dev called from crowdsale contract to unpause, returns to normal state
499      * can run only from crowdsale contract
500      */
501     function unpause() public onlyOwner whenPaused {
502         paused = false;
503         emit Unpaused();
504     }
505 
506     function() external payable {
507         revert("The token contract don`t receive ether");
508     }  
509 }
510 
511 
512 
513 /**
514  * @title Ownable
515  * @dev The Ownable contract has an owner and manager addresses, and provides basic authorization control
516  * functions, this simplifies the implementation of "user permissions".
517  */
518 contract Ownable {
519     address public owner;
520     address public manager;
521     address candidate;
522 
523     constructor() public {
524         owner = msg.sender;
525         manager = msg.sender;
526     }
527 
528     modifier onlyOwner() {
529         require(msg.sender == owner,"Access denied");
530         _;
531     }
532 
533     modifier restricted() {
534         require(msg.sender == owner || msg.sender == manager,"Access denied");
535         _;
536     }
537 
538     function transferOwnership(address _newOwner) public onlyOwner {
539         require(_newOwner != address(0),"Invalid address");
540         candidate = _newOwner;
541     }
542 
543     function setManager(address _newManager) public onlyOwner {
544         require(_newManager != address(0),"Invalid address");
545         manager = _newManager;
546     }
547 
548 
549     function confirmOwnership() public {
550         require(candidate == msg.sender,"Only from candidate");
551         owner = candidate;
552         delete candidate;
553     }
554 
555 }
556 
557 
558 contract TeamAddress1 {
559     function() external payable {
560         revert("The contract don`t receive ether");
561     } 
562 }
563 
564 
565 contract TeamAddress2 {
566     function() external payable {
567         revert("The contract don`t receive ether");
568     } 
569 }
570 
571 
572 contract MarketingAddress {
573     function() external payable {
574         revert("The contract don`t receive ether");
575     } 
576 }
577 
578 
579 contract RetailersAddress {
580     function() external payable {
581         revert("The contract don`t receive ether");
582     } 
583 }
584 
585 
586 contract ReserveAddress {
587     function() external payable {
588         revert("The contract don`t receive ether");
589     } 
590 }
591 
592 
593 contract BountyAddress {
594     function() external payable {
595         revert("The contract don`t receive ether");
596     } 
597 }
598 
599 
600 /**
601  * @title Crowdsale
602  * @dev Crowdsale is a base contract for managing a token crowdsale
603  */
604 contract Crowdsale is Ownable {
605     using SafeMath for uint256;
606     using SafeERC20 for RESTOToken;
607 
608     uint256 hardCap = 50000 * 1 ether;
609     address myAddress = this;
610     RESTOToken public token = new RESTOToken(myAddress);
611     uint64 crowdSaleStartTime = 1537401600;     // 20.09.2018
612     uint64 crowdSaleEndTime = 1544745600;       // 14.12.2018
613 
614     //Addresses for store tokens
615     TeamAddress1 public teamAddress1 = new TeamAddress1();
616     TeamAddress2 public teamAddress2 = new TeamAddress2();
617     MarketingAddress public marketingAddress = new MarketingAddress();
618     RetailersAddress public retailersAddress = new RetailersAddress();
619     ReserveAddress public reserveAddress = new ReserveAddress();
620     BountyAddress public bountyAddress = new BountyAddress();
621       
622     // How many token units a buyer gets per wei.
623     uint256 public rate;
624 
625     // Amount of wei raised
626     uint256 public weiRaised;
627 
628     event Withdraw(
629         address indexed from, 
630         address indexed to, 
631         uint256 amount
632     );
633 
634     event TokensPurchased(
635         address indexed purchaser,
636         address indexed beneficiary,
637         uint256 value,
638         uint256 amount
639     );
640 
641     constructor() public {
642         uint256 totalTokens = token.INITIAL_SUPPLY();
643         /**
644         * @dev Inicial distributing tokens to special adresses
645         * TeamAddress1 - 4.5%
646         * TeamAddress2 - 13.5% (hold one year)
647         * MarketingAddress - 18%
648         * RetailersAddress - 9%
649         * ReserveAddress - 8%
650         * BountyAddress - 1%
651         */
652         _deliverTokens(teamAddress1, totalTokens.mul(45).div(1000));
653         _deliverTokens(teamAddress2, totalTokens.mul(135).div(1000));
654         _deliverTokens(marketingAddress, totalTokens.mul(18).div(100));
655         _deliverTokens(retailersAddress, totalTokens.mul(9).div(100));
656         _deliverTokens(reserveAddress, totalTokens.mul(8).div(100));
657         _deliverTokens(bountyAddress, totalTokens.div(100));
658 
659         rate = 10000;
660     }
661 
662     // -----------------------------------------
663     // Crowdsale external interface
664     // -----------------------------------------
665 
666     /**
667     * @dev fallback function
668     */
669     function () external payable {
670         require(msg.data.length == 0,"Only for simple payments");
671         buyTokens(msg.sender);
672     }
673 
674     /**
675     * @dev low level token purchase ***DO NOT OVERRIDE***
676     * @param _beneficiary Address performing the token purchase
677     */
678     function buyTokens(address _beneficiary) public payable {
679         uint256 weiAmount = msg.value;
680         _preValidatePurchase(_beneficiary, weiAmount);
681 
682         // calculate token amount to be created
683         uint256 tokens = _getTokenAmount(weiAmount);
684 
685         // update state
686         weiRaised = weiRaised.add(weiAmount);
687 
688         _processPurchase(_beneficiary, tokens);
689         
690         emit TokensPurchased(
691             msg.sender,
692             _beneficiary,
693             weiAmount,
694             tokens
695         );
696 
697     }
698 
699     // -----------------------------------------
700     // Internal interface (extensible)
701     // -----------------------------------------
702 
703     /**
704      * @dev called by the owner to pause, triggers stopped state
705      */
706     function pauseCrowdsale() public onlyOwner {
707         token.pause();
708     }
709 
710     /**
711      * @dev called by the owner to unpause, returns to normal state
712      */
713     function unpauseCrowdsale() public onlyOwner {
714         token.unpause();
715     }
716 
717     /**
718      * @dev function set kyc bool to true
719      * @param _investor The investor who passed the procedure KYC
720      */
721     function setKYCpassed(address _investor) public restricted returns(bool){
722         token.kycPass(_investor);
723         return true;
724     }
725 
726     /**
727      * @dev the function tranfer tokens from TeamAddress1 to investor
728      * @param _value is entered in whole tokens (1 = 1 token)
729      */
730     function transferTokensFromTeamAddress1(address _investor, uint256 _value) public restricted returns(bool){
731         token.transferTokensFromSpecialAddress(address(teamAddress1), _investor, _value); 
732         return true;
733     } 
734 
735     /**
736      * @dev the function tranfer tokens from TeamAddress1 to investor
737      * only after 1 year
738      * @param _value is entered in whole tokens (1 = 1 token)
739      */
740     function transferTokensFromTeamAddress2(address _investor, uint256 _value) public restricted returns(bool){
741         require (now >= (crowdSaleEndTime + 365 days), "Only after 1 year");
742         token.transferTokensFromSpecialAddress(address(teamAddress2), _investor, _value); 
743         return true;
744     } 
745     
746     /**
747      * @dev the function tranfer tokens from MarketingAddress to investor
748      * @param _value is entered in whole tokens (1 = 1 token)
749      */
750     function transferTokensFromMarketingAddress(address _investor, uint256 _value) public restricted returns(bool){
751         token.transferTokensFromSpecialAddress(address(marketingAddress), _investor, _value); 
752         return true;
753     } 
754     
755     /**
756      * @dev the function tranfer tokens from RetailersAddress to investor
757      * @param _value is entered in whole tokens (1 = 1 token)
758      */
759     function transferTokensFromRetailersAddress(address _investor, uint256 _value) public restricted returns(bool){
760         token.transferTokensFromSpecialAddress(address(retailersAddress), _investor, _value); 
761         return true;
762     } 
763 
764     /**
765      * @dev the function tranfer tokens from ReserveAddress to investor
766      * @param _value is entered in whole tokens (1 = 1 token)
767      */
768     function transferTokensFromReserveAddress(address _investor, uint256 _value) public restricted returns(bool){
769         token.transferTokensFromSpecialAddress(address(reserveAddress), _investor, _value); 
770         return true;
771     } 
772 
773     /**
774      * @dev the function tranfer tokens from BountyAddress to investor
775      * @param _value is entered in whole tokens (1 = 1 token)
776      */
777     function transferTokensFromBountyAddress(address _investor, uint256 _value) public restricted returns(bool){
778         token.transferTokensFromSpecialAddress(address(bountyAddress), _investor, _value); 
779         return true;
780     } 
781     
782     /**
783     * @dev Validation of an incoming purchase. 
784     * @param _beneficiary Address performing the token purchase
785     * @param _weiAmount Value in wei involved in the purchase
786     * Start Crowdsale 20/09/2018       - 1537401600
787     * Finish Crowdsale 14/12/2018      - 1544745600
788     * Greate pause until 01/11/2020    - 1604188800
789     */
790     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view{
791         require(_beneficiary != address(0),"Invalid address");
792         require(_weiAmount != 0,"Invalid amount");
793         require((now > crowdSaleStartTime && now <= crowdSaleEndTime) || now > 1604188800,"At this time contract don`t sell tokens, sorry");
794         require(weiRaised < hardCap,"HardCap is passed, contract don`t accept ether.");
795     }
796 
797     /**
798     * @dev internal function
799     * @param _beneficiary Address performing the token purchase
800     * @param _tokenAmount Number of tokens to be emitted
801     */
802     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
803         token.safeTransfer(_beneficiary, _tokenAmount);
804     }
805 
806 
807     /**
808      * @dev Function transfer token to new investors
809      * Access restricted owner and manager
810      */ 
811     function transferTokens(address _newInvestor, uint256 _tokenAmount) public restricted {
812         uint256 value = _tokenAmount;
813         require (value >= 1,"Min _tokenAmount is 1");
814         value = value.mul(1 ether);        
815         _deliverTokens(_newInvestor, value);
816     }
817 
818     /**
819     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
820     * @param _beneficiary Address receiving the tokens
821     * @param _tokenAmount Number of tokens to be purchased
822     */
823     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
824         _deliverTokens(_beneficiary, _tokenAmount);
825     }
826 
827 
828     /**
829     * @dev this function is ether converted to tokens.
830     * @param _weiAmount Value in wei to be converted into tokens
831     * @return Number of tokens that can be purchased with the specified _weiAmount
832     */
833     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
834         uint256 bonus = 0;
835         uint256 resultAmount = _weiAmount;
836         /**
837         * Start PreSale      20/09/2018      - 1537401600
838         * Start ICO          10/10/2018      - 1539129600 
839         * Finish ICO         14/12/2018      - 1544745600    
840         */
841         if (now < 1539129600) {
842             // Calculating bonus for PreSale period
843             if (_weiAmount >= 100 * 1 ether) {
844                 bonus = 300;
845             } else {
846                 bonus = 100;
847             }
848         } else {
849             // Calculating bonus for ICO period
850             if (_weiAmount >= 100 * 1 ether) {
851                 bonus = 200;
852             } else {
853                 /**
854                 * ICO bonus                        UnisTimeStamp 
855                 *                                  Start date      End date
856                 * 10.10.2018-16.10.2018 - 40%      1539129600
857                 * 17.10.2018-23.10.2018 - 30%      1539734400
858                 * 24.10.2018-31.10.2018 - 20%      1540339200
859                 * 01.11.2018-16.11.2018 - 10%      1541030400      1542326400
860                 */
861                 if (now >= 1539129600 && now < 1539734400) {
862                     bonus = 40;
863                 }
864                 if (now >= 1539734400 && now < 1540339200) {
865                     bonus = 30;
866                 }
867                 if (now >= 1540339200 && now < 1541030400) {
868                     bonus = 20;
869                 }
870                 if (now >= 1541030400 && now < 1542326400) {
871                     bonus = 10;
872                 }
873             }
874         }
875         if (bonus > 0) {
876             resultAmount += _weiAmount.mul(bonus).div(100);
877         }
878         return resultAmount.mul(rate);
879     }
880 
881     /**
882     * @dev Determines how ETH is stored/forwarded on purchases.
883     */
884     function forwardFunds() public onlyOwner {
885         uint256 transferValue = myAddress.balance.div(8);
886 
887         // Addresses where funds are collected
888         address wallet1 = 0x0C4324DC212f7B09151148c3960f71904E5C074D;
889         address wallet2 = 0x49C0fAc36178DB055dD55df6a6656dd457dc307A;
890         address wallet3 = 0x510aC42D296D0b06d5B262F606C27d5cf22B9726;
891         address wallet4 = 0x48dfeA3ce1063191B45D06c6ECe7462B244A40B6;
892         address wallet5 = 0x5B1689B453bb0DBd38A0d9710a093A228ab13170;
893         address wallet6 = 0xDFA0Cba1D28E625C3f3257B4758782164e4622f2;
894         address wallet7 = 0xF3Ff96FE7eE76ACA81aFb180264D6A31f726BAbE;
895         address wallet8 = 0x5384EFFdf2bb24a8b0489633A64D4Bfc53BdFEb6;
896 
897         wallet1.transfer(transferValue);
898         wallet2.transfer(transferValue);
899         wallet3.transfer(transferValue);
900         wallet4.transfer(transferValue);
901         wallet5.transfer(transferValue);
902         wallet6.transfer(transferValue);
903         wallet7.transfer(transferValue);
904         wallet8.transfer(myAddress.balance);
905     }
906     
907     function withdrawFunds (address _to, uint256 _value) public onlyOwner {
908         require (now > crowdSaleEndTime, "CrowdSale is not finished yet. Access denied.");
909         require (myAddress.balance >= _value,"Value is more than balance");
910         require(_to != address(0),"Invalid address");
911         _to.transfer(_value);
912         emit Withdraw(msg.sender, _to, _value);
913     }
914 
915 }