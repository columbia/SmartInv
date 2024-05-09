1 pragma solidity ^0.4.23;
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
64 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 // File: zeppelin-solidity/contracts/math/SafeMath.sol
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86   /**
87   * @dev Multiplies two numbers, throws on overflow.
88   */
89   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
91     // benefit is lost if 'b' is also tested.
92     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93     if (a == 0) {
94       return 0;
95     }
96 
97     c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   /**
103   * @dev Integer division of two numbers, truncating the quotient.
104   */
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     // uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return a / b;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     assert(b <= a);
117     return a - b;
118   }
119 
120   /**
121   * @dev Adds two numbers, throws on overflow.
122   */
123   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
124     c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }
129 
130 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: kuende-token/contracts/KuendeCoinToken.sol
322 
323 /**
324  * @title KuendeCoinToken
325  * @author https://bit-sentinel.com
326  */
327 contract KuendeCoinToken is StandardToken, Ownable {
328   /**
329    * @dev event for logging enablement of transfers
330    */
331   event EnabledTransfers();
332 
333   /**
334    * @dev event for logging crowdsale address set
335    * @param crowdsale address Address of the crowdsale
336    */
337   event SetCrowdsaleAddress(address indexed crowdsale);
338 
339   // Address of the crowdsale.
340   address public crowdsale;
341 
342   // Public variables of the Token.
343   string public name = "KuendeCoin"; 
344   uint8 public decimals = 18;
345   string public symbol = "KNC";
346 
347   // If the token is transferable or not.
348   bool public transferable = false;
349 
350   /**
351    * @dev Initialize the KuendeCoinToken and transfer the initialBalance to the
352    *      contract creator. 
353    */
354   constructor(address initialAccount, uint256 initialBalance) public {
355     totalSupply_ = initialBalance;
356     balances[initialAccount] = initialBalance;
357     emit Transfer(0x0, initialAccount, initialBalance);
358   }
359 
360   /**
361    * @dev Ensure the transfer is valid.
362    */
363   modifier canTransfer() {
364     require(transferable || (crowdsale != address(0) && crowdsale == msg.sender));
365     _; 
366   }
367 
368   /**
369    * @dev Enable the transfers of this token. Can only be called once.
370    */
371   function enableTransfers() external onlyOwner {
372     require(!transferable);
373     transferable = true;
374     emit EnabledTransfers();
375   }
376 
377   /**
378    * @dev Set the crowdsale address.
379    * @param _addr address
380    */
381   function setCrowdsaleAddress(address _addr) external onlyOwner {
382     require(_addr != address(0));
383     crowdsale = _addr;
384     emit SetCrowdsaleAddress(_addr);
385   }
386 
387   /**
388   * @dev transfer token for a specified address
389   * @param _to The address to transfer to.
390   * @param _value The amount to be transferred.
391   */
392   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
393     return super.transfer(_to, _value);
394   }
395 
396   /**
397    * @dev Transfer tokens from one address to another
398    * @param _from address The address which you want to send tokens from
399    * @param _to address The address which you want to transfer to
400    * @param _value uint256 the amount of tokens to be transferred
401    */
402   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
403     return super.transferFrom(_from, _to, _value);
404   }
405 }
406 
407 // File: contracts/KuendeCrowdsale.sol
408 
409 /**
410  * @title KuendeCrowdsale
411  * @author https://bit-sentinel.com
412  * @dev Inspired by: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/crowdsale
413  */
414 contract KuendeCrowdsale is Ownable {
415   using SafeMath for uint256;
416 
417   /**
418    * @dev event for change wallet address logging
419    * @param newWallet address that got set
420    * @param oldWallet address that was changed from
421    */
422   event ChangedWalletAddress(address indexed newWallet, address indexed oldWallet);
423   
424   /**
425    * @dev event for token purchase logging
426    * @param investor who purchased tokens
427    * @param value weis paid for purchase
428    * @param amount of tokens purchased
429    */
430   event TokenPurchase(address indexed investor, uint256 value, uint256 amount);
431 
432   // definition of an Investor
433   struct Investor {
434     uint256 weiBalance;    // Amount of invested wei (0 for PreInvestors)
435     uint256 tokenBalance;  // Amount of owned tokens
436     bool whitelisted;      // Flag for marking an investor as whitelisted
437     bool purchasing;       // Lock flag
438   }
439 
440   // start and end timestamps where investments are allowed (both inclusive)
441   uint256 public startTime;
442   uint256 public endTime;
443 
444   // address that can whitelist new investors
445   address public registrar;
446 
447   // wei to token exchange rate
448   uint256 public exchangeRate;
449 
450   // address where funds are collected
451   address public wallet;
452 
453   // token contract
454   KuendeCoinToken public token;
455 
456   // crowdsale sale cap
457   uint256 public cap;
458 
459   // crowdsale investor cap
460   uint256 public investorCap;
461 
462   // minimum investment
463   uint256 public constant minInvestment = 100 finney;
464 
465   // gas price limit. 100 gwei.
466   uint256 public constant gasPriceLimit = 1e11 wei;
467 
468   // amount of raised money in wei
469   uint256 public weiRaised;
470 
471   // storage for the investors repository
472   uint256 public numInvestors;
473   mapping (address => Investor) public investors;
474 
475   /**
476    * @dev Create a new instance of the KuendeCrowdsale contract
477    * @param _startTime     uint256 Crowdsale start time timestamp in unix format.
478    * @param _endTime       uint256 Crowdsale end time timestamp in unix format.
479    * @param _cap           uint256 Hard cap in wei.
480    * @param _exchangeRate  uint256 1 token value in wei.
481    * @param _registrar     address Address that can whitelist investors.
482    * @param _wallet        address Address of the wallet that will collect the funds.
483    * @param _token         address Token smart contract address.
484    */
485   constructor (
486     uint256 _startTime,
487     uint256 _endTime,
488     uint256 _cap,
489     uint256 _exchangeRate,
490     address _registrar,
491     address _wallet,
492     address _token
493   )
494     public
495   {
496     // validate parameters
497     require(_startTime > now);
498     require(_endTime > _startTime);
499     require(_cap > 0);
500     require(_exchangeRate > 0);
501     require(_registrar != address(0));
502     require(_wallet != address(0));
503     require(_token != address(0));
504 
505     // update storage
506     startTime = _startTime;
507     endTime = _endTime;
508     cap = _cap;
509     exchangeRate = _exchangeRate;
510     registrar = _registrar;
511     wallet = _wallet;
512     token = KuendeCoinToken(_token);
513   }
514 
515   /**
516    * @dev Ensure the crowdsale is not started
517    */
518   modifier notStarted() { 
519     require(now < startTime);
520     _;
521   }
522 
523   /**
524    * @dev Ensure the crowdsale is not notEnded
525    */
526   modifier notEnded() { 
527     require(now <= endTime);
528     _;
529   }
530   
531   /**
532    * @dev Fallback function can be used to buy tokens
533    */
534   function () external payable {
535     buyTokens();
536   }
537 
538   /**
539    * @dev Change the wallet address
540    * @param _wallet address
541    */
542   function changeWalletAddress(address _wallet) external notStarted onlyOwner {
543     // validate call against the rules
544     require(_wallet != address(0));
545     require(_wallet != wallet);
546 
547     // update storage
548     address _oldWallet = wallet;
549     wallet = _wallet;
550 
551     // trigger event
552     emit ChangedWalletAddress(_wallet, _oldWallet);
553   }
554 
555   /**
556    * @dev Whitelist multiple investors at once
557    * @param addrs address[]
558    */
559   function whitelistInvestors(address[] addrs) external {
560     require(addrs.length > 0 && addrs.length <= 30);
561     for (uint i = 0; i < addrs.length; i++) {
562       whitelistInvestor(addrs[i]);
563     }
564   }
565 
566   /**
567    * @dev Whitelist a new investor
568    * @param addr address
569    */
570   function whitelistInvestor(address addr) public notEnded {
571     require((msg.sender == registrar || msg.sender == owner) && !limited());
572     if (!investors[addr].whitelisted && addr != address(0)) {
573       investors[addr].whitelisted = true;
574       numInvestors++;
575     }
576   }
577 
578   /**
579    * @dev Low level token purchase function
580    */
581   function buyTokens() public payable {
582     // update investor cap.
583     updateInvestorCap();
584 
585     address investor = msg.sender;
586 
587     // validate purchase    
588     validPurchase();
589 
590     // lock investor account
591     investors[investor].purchasing = true;
592 
593     // get the msg wei amount
594     uint256 weiAmount = msg.value.sub(refundExcess());
595 
596     // value after refunds should be greater or equal to minimum investment
597     require(weiAmount >= minInvestment);
598 
599     // calculate token amount to be sold
600     uint256 tokens = weiAmount.mul(1 ether).div(exchangeRate);
601 
602     // update storage
603     weiRaised = weiRaised.add(weiAmount);
604     investors[investor].weiBalance = investors[investor].weiBalance.add(weiAmount);
605     investors[investor].tokenBalance = investors[investor].tokenBalance.add(tokens);
606 
607     // transfer tokens
608     require(transfer(investor, tokens));
609 
610     // trigger event
611     emit TokenPurchase(msg.sender, weiAmount, tokens);
612 
613     // forward funds
614     wallet.transfer(weiAmount);
615 
616     // unlock investor account
617     investors[investor].purchasing = false;
618   }
619 
620   /**
621   * @dev Update the investor cap.
622   */
623   function updateInvestorCap() internal {
624     require(now >= startTime);
625 
626     if (investorCap == 0) {
627       investorCap = cap.div(numInvestors);
628     }
629   }
630 
631   /**
632    * @dev Wrapper over token's transferFrom function. Ensures the call is valid.
633    * @param  to    address
634    * @param  value uint256
635    * @return bool
636    */
637   function transfer(address to, uint256 value) internal returns (bool) {
638     if (!(
639       token.allowance(owner, address(this)) >= value &&
640       token.balanceOf(owner) >= value &&
641       token.crowdsale() == address(this)
642     )) {
643       return false;
644     }
645     return token.transferFrom(owner, to, value);
646   }
647   
648   /**
649    * @dev Refund the excess weiAmount back to the investor so the caps aren't reached
650    * @return uint256 the weiAmount after refund
651    */
652   function refundExcess() internal returns (uint256 excess) {
653     uint256 weiAmount = msg.value;
654     address investor = msg.sender;
655 
656     // calculate excess for investorCap
657     if (limited() && !withinInvestorCap(investor, weiAmount)) {
658       excess = investors[investor].weiBalance.add(weiAmount).sub(investorCap);
659       weiAmount = msg.value.sub(excess);
660     }
661 
662     // calculate excess for crowdsale cap
663     if (!withinCap(weiAmount)) {
664       excess = excess.add(weiRaised.add(weiAmount).sub(cap));
665     }
666     
667     // refund and update weiAmount
668     if (excess > 0) {
669       investor.transfer(excess);
670     }
671   }
672 
673   /**
674    * @dev Validate the purchase. Reverts if purchase is invalid
675    */
676   function validPurchase() internal view {
677     require (msg.sender != address(0));           // valid investor address
678     require (tx.gasprice <= gasPriceLimit);       // tx gas price doesn't exceed limit
679     require (!investors[msg.sender].purchasing);  // investor not already purchasing
680     require (startTime <= now && now <= endTime); // within crowdsale period
681     require (investorCap != 0);                   // investor cap initialized
682     require (msg.value >= minInvestment);         // value should exceed or be equal to minimum investment
683     require (whitelisted(msg.sender));            // check if investor is whitelisted
684     require (withinCap(0));                       // check if purchase is within cap
685     require (withinInvestorCap(msg.sender, 0));   // check if purchase is within investor cap
686   }
687 
688   /**
689    * @dev Check if by adding the provided _weiAmomunt the cap is not exceeded
690    * @param weiAmount uint256
691    * @return bool
692    */
693   function withinCap(uint256 weiAmount) internal view returns (bool) {
694     return weiRaised.add(weiAmount) <= cap;
695   }
696 
697   /**
698    * @dev Check if by adding the provided weiAmount to investor's account the investor
699    *      cap is not excedeed
700    * @param investor  address
701    * @param weiAmount uint256
702    * @return bool
703    */
704   function withinInvestorCap(address investor, uint256 weiAmount) internal view returns (bool) {
705     return limited() ? investors[investor].weiBalance.add(weiAmount) <= investorCap : true;
706   }
707 
708   /**
709    * @dev Check if the given address is whitelisted for token purchases
710    * @param investor address
711    * @return bool
712    */
713   function whitelisted(address investor) internal view returns (bool) {
714     return investors[investor].whitelisted;
715   }
716 
717   /**
718    * @dev Check if the crowdsale is limited
719    * @return bool
720    */
721   function limited() internal view returns (bool) {
722     return  startTime <= now && now < startTime.add(3 days);
723   }
724 }