1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: zeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
117 
118 /**
119  * @title RefundVault
120  * @dev This contract is used for storing funds while a crowdsale
121  * is in progress. Supports refunding the money if crowdsale fails,
122  * and forwarding it if crowdsale is successful.
123  */
124 contract RefundVault is Ownable {
125   using SafeMath for uint256;
126 
127   enum State { Active, Refunding, Closed }
128 
129   mapping (address => uint256) public deposited;
130   address public wallet;
131   State public state;
132 
133   event Closed();
134   event RefundsEnabled();
135   event Refunded(address indexed beneficiary, uint256 weiAmount);
136 
137   /**
138    * @param _wallet Vault address
139    */
140   constructor(address _wallet) public {
141     require(_wallet != address(0));
142     wallet = _wallet;
143     state = State.Active;
144   }
145 
146   /**
147    * @param investor Investor address
148    */
149   function deposit(address investor) onlyOwner public payable {
150     require(state == State.Active);
151     deposited[investor] = deposited[investor].add(msg.value);
152   }
153 
154   function close() onlyOwner public {
155     require(state == State.Active);
156     state = State.Closed;
157     emit Closed();
158     wallet.transfer(address(this).balance);
159   }
160 
161   function enableRefunds() onlyOwner public {
162     require(state == State.Active);
163     state = State.Refunding;
164     emit RefundsEnabled();
165   }
166 
167   /**
168    * @param investor Investor address
169    */
170   function refund(address investor) public {
171     require(state == State.Refunding);
172     uint256 depositedValue = deposited[investor];
173     deposited[investor] = 0;
174     investor.transfer(depositedValue);
175     emit Refunded(investor, depositedValue);
176   }
177 }
178 
179 // File: contracts/IpoVault.sol
180 
181 contract IpoVault is RefundVault {
182   using SafeMath for uint256;
183 
184   address platformWallet;
185   uint platformFee;
186   constructor(address _wallet, address _platformWallet, uint _platformFee) public  RefundVault(_wallet) {
187     platformWallet = _platformWallet;
188     platformFee = _platformFee;
189   }
190 
191   function close() onlyOwner public {
192     require(state == State.Active);
193     uint platformReward = address(this).balance.mul(platformFee).div(100);
194     platformWallet.transfer(platformReward);
195     state = State.Closed;
196     emit Closed();
197     wallet.transfer(address(this).balance);
198   }
199 }
200 
201 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
202 
203 /**
204  * @title ERC20Basic
205  * @dev Simpler version of ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/179
207  */
208 contract ERC20Basic {
209   function totalSupply() public view returns (uint256);
210   function balanceOf(address who) public view returns (uint256);
211   function transfer(address to, uint256 value) public returns (bool);
212   event Transfer(address indexed from, address indexed to, uint256 value);
213 }
214 
215 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
216 
217 /**
218  * @title Basic token
219  * @dev Basic version of StandardToken, with no allowances.
220  */
221 contract BasicToken is ERC20Basic {
222   using SafeMath for uint256;
223 
224   mapping(address => uint256) balances;
225 
226   uint256 totalSupply_;
227 
228   /**
229   * @dev total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return totalSupply_;
233   }
234 
235   /**
236   * @dev transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[msg.sender]);
243 
244     balances[msg.sender] = balances[msg.sender].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     emit Transfer(msg.sender, _to, _value);
247     return true;
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public view returns (uint256) {
256     return balances[_owner];
257   }
258 
259 }
260 
261 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
262 
263 /**
264  * @title ERC20 interface
265  * @dev see https://github.com/ethereum/EIPs/issues/20
266  */
267 contract ERC20 is ERC20Basic {
268   function allowance(address owner, address spender)
269     public view returns (uint256);
270 
271   function transferFrom(address from, address to, uint256 value)
272     public returns (bool);
273 
274   function approve(address spender, uint256 value) public returns (bool);
275   event Approval(
276     address indexed owner,
277     address indexed spender,
278     uint256 value
279   );
280 }
281 
282 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
283 
284 /**
285  * @title Standard ERC20 token
286  *
287  * @dev Implementation of the basic standard token.
288  * @dev https://github.com/ethereum/EIPs/issues/20
289  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
290  */
291 contract StandardToken is ERC20, BasicToken {
292 
293   mapping (address => mapping (address => uint256)) internal allowed;
294 
295 
296   /**
297    * @dev Transfer tokens from one address to another
298    * @param _from address The address which you want to send tokens from
299    * @param _to address The address which you want to transfer to
300    * @param _value uint256 the amount of tokens to be transferred
301    */
302   function transferFrom(
303     address _from,
304     address _to,
305     uint256 _value
306   )
307     public
308     returns (bool)
309   {
310     require(_to != address(0));
311     require(_value <= balances[_from]);
312     require(_value <= allowed[_from][msg.sender]);
313 
314     balances[_from] = balances[_from].sub(_value);
315     balances[_to] = balances[_to].add(_value);
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     emit Transfer(_from, _to, _value);
318     return true;
319   }
320 
321   /**
322    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323    *
324    * Beware that changing an allowance with this method brings the risk that someone may use both the old
325    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
326    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
327    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
328    * @param _spender The address which will spend the funds.
329    * @param _value The amount of tokens to be spent.
330    */
331   function approve(address _spender, uint256 _value) public returns (bool) {
332     allowed[msg.sender][_spender] = _value;
333     emit Approval(msg.sender, _spender, _value);
334     return true;
335   }
336 
337   /**
338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
339    * @param _owner address The address which owns the funds.
340    * @param _spender address The address which will spend the funds.
341    * @return A uint256 specifying the amount of tokens still available for the spender.
342    */
343   function allowance(
344     address _owner,
345     address _spender
346    )
347     public
348     view
349     returns (uint256)
350   {
351     return allowed[_owner][_spender];
352   }
353 
354   /**
355    * @dev Increase the amount of tokens that an owner allowed to a spender.
356    *
357    * approve should be called when allowed[_spender] == 0. To increment
358    * allowed value is better to use this function to avoid 2 calls (and wait until
359    * the first transaction is mined)
360    * From MonolithDAO Token.sol
361    * @param _spender The address which will spend the funds.
362    * @param _addedValue The amount of tokens to increase the allowance by.
363    */
364   function increaseApproval(
365     address _spender,
366     uint _addedValue
367   )
368     public
369     returns (bool)
370   {
371     allowed[msg.sender][_spender] = (
372       allowed[msg.sender][_spender].add(_addedValue));
373     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376 
377   /**
378    * @dev Decrease the amount of tokens that an owner allowed to a spender.
379    *
380    * approve should be called when allowed[_spender] == 0. To decrement
381    * allowed value is better to use this function to avoid 2 calls (and wait until
382    * the first transaction is mined)
383    * From MonolithDAO Token.sol
384    * @param _spender The address which will spend the funds.
385    * @param _subtractedValue The amount of tokens to decrease the allowance by.
386    */
387   function decreaseApproval(
388     address _spender,
389     uint _subtractedValue
390   )
391     public
392     returns (bool)
393   {
394     uint oldValue = allowed[msg.sender][_spender];
395     if (_subtractedValue > oldValue) {
396       allowed[msg.sender][_spender] = 0;
397     } else {
398       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
399     }
400     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404 }
405 
406 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
407 
408 /**
409  * @title Mintable token
410  * @dev Simple ERC20 Token example, with mintable token creation
411  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
412  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
413  */
414 contract MintableToken is StandardToken, Ownable {
415   event Mint(address indexed to, uint256 amount);
416   event MintFinished();
417 
418   bool public mintingFinished = false;
419 
420 
421   modifier canMint() {
422     require(!mintingFinished);
423     _;
424   }
425 
426   modifier hasMintPermission() {
427     require(msg.sender == owner);
428     _;
429   }
430 
431   /**
432    * @dev Function to mint tokens
433    * @param _to The address that will receive the minted tokens.
434    * @param _amount The amount of tokens to mint.
435    * @return A boolean that indicates if the operation was successful.
436    */
437   function mint(
438     address _to,
439     uint256 _amount
440   )
441     hasMintPermission
442     canMint
443     public
444     returns (bool)
445   {
446     totalSupply_ = totalSupply_.add(_amount);
447     balances[_to] = balances[_to].add(_amount);
448     emit Mint(_to, _amount);
449     emit Transfer(address(0), _to, _amount);
450     return true;
451   }
452 
453   /**
454    * @dev Function to stop minting new tokens.
455    * @return True if the operation was successful.
456    */
457   function finishMinting() onlyOwner canMint public returns (bool) {
458     mintingFinished = true;
459     emit MintFinished();
460     return true;
461   }
462 }
463 
464 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
465 
466 /**
467  * @title Pausable
468  * @dev Base contract which allows children to implement an emergency stop mechanism.
469  */
470 contract Pausable is Ownable {
471   event Pause();
472   event Unpause();
473 
474   bool public paused = false;
475 
476 
477   /**
478    * @dev Modifier to make a function callable only when the contract is not paused.
479    */
480   modifier whenNotPaused() {
481     require(!paused);
482     _;
483   }
484 
485   /**
486    * @dev Modifier to make a function callable only when the contract is paused.
487    */
488   modifier whenPaused() {
489     require(paused);
490     _;
491   }
492 
493   /**
494    * @dev called by the owner to pause, triggers stopped state
495    */
496   function pause() onlyOwner whenNotPaused public {
497     paused = true;
498     emit Pause();
499   }
500 
501   /**
502    * @dev called by the owner to unpause, returns to normal state
503    */
504   function unpause() onlyOwner whenPaused public {
505     paused = false;
506     emit Unpause();
507   }
508 }
509 
510 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
511 
512 /**
513  * @title Pausable token
514  * @dev StandardToken modified with pausable transfers.
515  **/
516 contract PausableToken is StandardToken, Pausable {
517 
518   function transfer(
519     address _to,
520     uint256 _value
521   )
522     public
523     whenNotPaused
524     returns (bool)
525   {
526     return super.transfer(_to, _value);
527   }
528 
529   function transferFrom(
530     address _from,
531     address _to,
532     uint256 _value
533   )
534     public
535     whenNotPaused
536     returns (bool)
537   {
538     return super.transferFrom(_from, _to, _value);
539   }
540 
541   function approve(
542     address _spender,
543     uint256 _value
544   )
545     public
546     whenNotPaused
547     returns (bool)
548   {
549     return super.approve(_spender, _value);
550   }
551 
552   function increaseApproval(
553     address _spender,
554     uint _addedValue
555   )
556     public
557     whenNotPaused
558     returns (bool success)
559   {
560     return super.increaseApproval(_spender, _addedValue);
561   }
562 
563   function decreaseApproval(
564     address _spender,
565     uint _subtractedValue
566   )
567     public
568     whenNotPaused
569     returns (bool success)
570   {
571     return super.decreaseApproval(_spender, _subtractedValue);
572   }
573 }
574 
575 // File: contracts/BaseToken.sol
576 
577 contract BaseToken is MintableToken, PausableToken {
578 
579   string public name; // solium-disable-line uppercase
580   string public symbol; // solium-disable-line uppercase
581   uint8 public constant decimals = 0; // solium-disable-line uppercase
582   uint public cap;
583 
584   mapping(address => uint256) dividendBalanceOf;
585   uint256 public dividendPerToken;
586   mapping(address => uint256) dividendCreditedTo;
587 
588   constructor(uint _cap, string _name, string _symbol) public {
589     cap = _cap * (10 ** uint256(decimals));
590     name = _name;
591     symbol = _symbol;
592     pause();
593   }
594 
595   function increaseTokenCap(uint _additionalTokensAmount) onlyOwner public {
596     cap = cap.add(_additionalTokensAmount);
597   }
598 
599   function capReached() public view returns (bool) {
600     return totalSupply_ >= cap;
601   }
602 
603   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
604     require(totalSupply_.add(_amount) <= cap);
605     return super.mint(_to, _amount);
606   }
607 
608   function isTokenHolder(address _address) public constant returns (bool) {
609     return balanceOf(_address) > 0;
610   }
611 
612   function updateDividends(address account) internal {
613     uint256 owed = dividendPerToken.sub(dividendCreditedTo[account]);
614     dividendBalanceOf[account] = dividendBalanceOf[account].add(balanceOf(account).mul(owed));
615     dividendCreditedTo[account] = dividendPerToken;
616   }
617 
618   function depositDividends() public payable onlyOwner {
619     dividendPerToken = dividendPerToken.add(msg.value.div(totalSupply_));
620   }
621 
622   function claimDividends() public {
623     require(isTokenHolder(msg.sender));
624     updateDividends(msg.sender);
625     uint256 amount = dividendBalanceOf[msg.sender];
626     dividendBalanceOf[msg.sender] = 0;
627     msg.sender.transfer(amount);
628   }
629 }
630 
631 // File: contracts/BaseIPO.sol
632 
633 contract BaseIPO is Ownable {
634   using SafeMath for uint256;
635 
636   address wallet;
637 
638   bool public success = false;
639   bool public isFinalized = false;
640 
641   enum Result {InProgress, Success, Failure}
642   Result public result = Result.InProgress;
643 
644   enum State {Closed, IPO}
645   State public state = State.Closed;
646 
647   uint public endTime;
648 
649   uint public tokenPrice;
650   IpoVault public vault;
651   BaseToken public token;
652 
653   event EventAdditionalSaleStarted(address ipoAddress, uint startTime);
654   event EventRefundSuccess(address ipoAddress, address beneficiary);
655   event EventBuyTokens(address ipoAddress, uint tokens, address beneficiary, uint weiAmount, uint tokenPrice);
656   event EventCreateIpoSuccess(address ipoContractAddress, address contractOwner, address tokenAddress);
657   event EventIpoFinalized(address ipoAddress, Result result);
658 
659   constructor (
660     address _owner,
661     address _wallet,
662     address _platformWallet,
663     uint _tokenGoal,
664     uint _tokenPrice,
665     string _tokenName,
666     string _tokenSymbol,
667     uint _ipoPeriodInDays,
668     uint _platformFee
669   ) public {
670     require(_ipoPeriodInDays > 0);
671     require(_tokenPrice > 0);
672     require(_tokenGoal > 0);
673     require(_wallet != address(0));
674     transferOwnership(_owner);
675     wallet = _wallet;
676     vault = new IpoVault(_wallet, _platformWallet, _platformFee);
677     token = new BaseToken(_tokenGoal, _tokenName, _tokenSymbol);
678     tokenPrice = _tokenPrice;
679     endTime = now.add(_ipoPeriodInDays.mul(1 days));
680     state = State.IPO;
681     emit EventCreateIpoSuccess(address(this), _owner, token);
682   }
683 
684   function getTokenAmount(uint weiAmount) internal view returns (uint) {
685     return weiAmount.div(tokenPrice);
686   }
687 
688   function isIpoPeriodOver() public view returns (bool) {
689     return now >= endTime;
690   }
691 
692   function buyTokens(address _beneficiary) public payable {
693     uint weiAmount = msg.value;
694     require(_beneficiary != address(0));
695     require(weiAmount > 0);
696     require(!token.capReached());
697     require(!isIpoPeriodOver());
698     require(state == State.IPO);
699     uint tokens = getTokenAmount(weiAmount);
700     token.mint(_beneficiary, tokens);
701     vault.deposit.value(msg.value)(msg.sender);
702     if (token.capReached()) {
703       finalizeIPO();
704     }
705     emit EventBuyTokens(address(this), tokens, msg.sender, weiAmount, tokenPrice);
706   }
707 
708   function finalizeIPO() internal {
709     if (token.capReached()) {
710       result = Result.Success;
711       vault.close();
712       token.unpause();
713     } else {
714       result = Result.Failure;
715       vault.enableRefunds();
716     }
717     state = State.Closed;
718     isFinalized = true;
719     emit EventIpoFinalized(address(this), result);
720   }
721 
722   function claimRefund() public {
723     require(token.isTokenHolder(msg.sender));
724     if (isIpoPeriodOver() && !isFinalized) {
725       finalizeIPO();
726     }
727     require(isFinalized);
728     require(!token.capReached());
729     vault.refund(msg.sender);
730     emit EventRefundSuccess(address(this), msg.sender);
731   }
732 
733   function payDividends() payable external onlyOwner {
734     require(result == Result.Success);
735     token.depositDividends.value(msg.value)();
736   }
737 
738   function() external payable {
739     buyTokens(msg.sender);
740   }
741 }
742 
743 // File: contracts/IpoCreator.sol
744 
745 contract IpoCreator {
746   address public platformAddress = 0xB23167b1941A4fe6C4864f97281099425B07A5c0;
747   uint public ipoPeriodInDays = 30;
748   uint public platformFee = 5;
749 
750   function createIpo(address _wallet, uint _tokenGoal, uint _tokenPrice, string _tokenName, string _tokenSymbol) public {
751     new BaseIPO(msg.sender, _wallet, platformAddress, _tokenGoal, _tokenPrice, _tokenName, _tokenSymbol, ipoPeriodInDays, platformFee);
752   }
753 }