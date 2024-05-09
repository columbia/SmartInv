1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /*
44  * Haltable
45  *
46  * Abstract contract that allows children to implement an
47  * emergency stop mechanism. Differs from Pausable by requiring a state.
48  *
49  *
50  * Originally envisioned in FirstBlood ICO contract.
51  */
52 contract Haltable is Ownable {
53   bool public halted = false;
54 
55   modifier inNormalState {
56     require(!halted);
57     _;
58   }
59 
60   modifier inEmergencyState {
61     require(halted);
62     _;
63   }
64 
65   // called by the owner on emergency, triggers stopped state
66   function halt() external onlyOwner inNormalState {
67     halted = true;
68   }
69 
70   // called by the owner on end of emergency, returns to normal state
71   function unhalt() external onlyOwner inEmergencyState {
72     halted = false;
73   }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81 
82   /**
83   * @dev Multiplies two numbers, throws on overflow.
84   */
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     if (a == 0) {
87       return 0;
88     }
89     uint256 c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return c;
102   }
103 
104   /**
105   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   function totalSupply() public view returns (uint256);
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   uint256 totalSupply_;
144 
145   /**
146   * @dev total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return totalSupply_;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[msg.sender]);
160 
161     // SafeMath.sub will throw if there is not enough balance.
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256 balance) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 /**
286  * @title Burnable
287  *
288  * @dev Standard ERC20 token
289  */
290 contract Burnable is StandardToken {
291   using SafeMath for uint;
292 
293   /* This notifies clients about the amount burnt */
294   event Burn(address indexed from, uint value);
295 
296   function burn(uint _value) returns (bool success) {
297     require(_value > 0 && balances[msg.sender] >= _value);
298     balances[msg.sender] = balances[msg.sender].sub(_value);
299     totalSupply_ = totalSupply_.sub(_value);
300     Burn(msg.sender, _value);
301     return true;
302   }
303 
304   function burnFrom(address _from, uint _value) returns (bool success) {
305     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
306     require(_value <= allowed[_from][msg.sender]);
307     balances[_from] = balances[_from].sub(_value);
308     totalSupply_ = totalSupply_.sub(_value);
309     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
310     Burn(_from, _value);
311     return true;
312   }
313 
314   function transfer(address _to, uint _value) returns (bool success) {
315     require(_to != 0x0); //use burn
316 
317     return super.transfer(_to, _value);
318   }
319 
320   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
321     require(_to != 0x0); //use burn
322 
323     return super.transferFrom(_from, _to, _value);
324   }
325 }
326 
327 /**
328  * @title DirectCryptToken
329  *
330  * @dev Burnable Ownable ERC20 token
331  */
332 contract DirectCryptToken is Burnable, Ownable {
333 
334   string public constant name = "Direct Crypt Token";
335   string public constant symbol = "DRCT";
336   uint8 public constant decimals = 18;
337   uint public constant INITIAL_SUPPLY = 500000000 * 1 ether;
338 
339   /* The finalizer contract that allows unlift the transfer limits on this token */
340   address public releaseAgent;
341 
342   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
343   bool public released = false;
344 
345   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
346   mapping (address => bool) public transferAgents;
347 
348   /**
349    * Limit token transfer until the crowdsale is over.
350    *
351    */
352   modifier canTransfer(address _sender) {
353     require(released || transferAgents[_sender]);
354     _;
355   }
356 
357   /** The function can be called only before or after the tokens have been released */
358   modifier inReleaseState(bool releaseState) {
359     require(releaseState == released);
360     _;
361   }
362 
363   /** The function can be called only by a whitelisted release agent. */
364   modifier onlyReleaseAgent() {
365     require(msg.sender == releaseAgent);
366     _;
367   }
368 
369 
370   /**
371    * @dev Constructor that gives msg.sender all of existing tokens.
372    */
373   function DirectCryptToken() {
374     totalSupply_ = INITIAL_SUPPLY;
375     balances[msg.sender] = INITIAL_SUPPLY;
376   }
377 
378 
379   /**
380    * Set the contract that can call release and make the token transferable.
381    *
382    * Design choice. Allow reset the release agent to fix fat finger mistakes.
383    */
384   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
385     require(addr != 0x0);
386 
387     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
388     releaseAgent = addr;
389   }
390 
391   function release() onlyReleaseAgent inReleaseState(false) public {
392     released = true;
393   }
394 
395   /**
396    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
397    */
398   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
399     require(addr != 0x0);
400     transferAgents[addr] = state;
401   }
402 
403   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
404     // Call Burnable.transfer()
405     return super.transfer(_to, _value);
406   }
407 
408   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
409     // Call Burnable.transferForm()
410     return super.transferFrom(_from, _to, _value);
411   }
412 
413   function burn(uint _value) onlyOwner returns (bool success) {
414     return super.burn(_value);
415   }
416 
417   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
418     return super.burnFrom(_from, _value);
419   }
420 }
421 
422 contract InvestorWhiteList is Ownable {
423   mapping (address => bool) public investorWhiteList;
424 
425   mapping (address => address) public referralList;
426 
427   function InvestorWhiteList() {
428 
429   }
430 
431   function addInvestorToWhiteList(address investor) external onlyOwner {
432     require(investor != 0x0 && !investorWhiteList[investor]);
433     investorWhiteList[investor] = true;
434   }
435 
436   function removeInvestorFromWhiteList(address investor) external onlyOwner {
437     require(investor != 0x0 && investorWhiteList[investor]);
438     investorWhiteList[investor] = false;
439   }
440 
441   //when new user will contribute ICO contract will automatically send bonus to referral
442   function addReferralOf(address investor, address referral) external onlyOwner {
443     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
444     referralList[investor] = referral;
445   }
446 
447   function isAllowed(address investor) constant external returns (bool result) {
448     return investorWhiteList[investor];
449   }
450 
451   function getReferralOf(address investor) constant external returns (address result) {
452     return referralList[investor];
453   }
454 }
455 
456 contract PriceReceiver {
457   address public ethPriceProvider;
458 
459   modifier onlyEthPriceProvider() {
460     require(msg.sender == ethPriceProvider);
461     _;
462   }
463 
464   function receiveEthPrice(uint ethUsdPrice) external;
465 
466   function setEthPriceProvider(address provider) external;
467 }
468 
469 contract DirectCryptTokenPreSale is Haltable, PriceReceiver {
470   using SafeMath for uint;
471 
472   string public constant name = "Direct Crypt Token PreSale";
473 
474   uint public constant REFERRAL_MIN_LIMIT = 2 ether;
475 
476   DirectCryptToken public token;
477   InvestorWhiteList public investorWhiteList;
478 
479   address public beneficiary;
480 
481   uint public hardCap;
482   uint public softCap;
483 
484   uint public ethUsdRate;
485 
486   uint public tokenPriceUsd;
487   uint public totalTokens;//in wei
488 
489   uint public collected = 0;
490   uint public tokensSold = 0;
491   uint public investorCount = 0;
492   uint public weiRefunded = 0;
493 
494   uint public startTime;
495   uint public endTime;
496 
497   bool public softCapReached = false;
498   bool public crowdsaleFinished = false;
499 
500   mapping (address => bool) refunded;
501   mapping (address => uint) public deposited;
502 
503   event SoftCapReached(uint softCap);
504   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
505   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
506   event Refunded(address indexed holder, uint amount);
507   event Deposited(address indexed holder, uint amount);
508 
509   modifier preSaleActive() {
510     require(now >= startTime && now < endTime);
511     _;
512   }
513 
514   modifier preSaleEnded() {
515     require(now >= endTime);
516     _;
517   }
518 
519   modifier inWhiteList() {
520     require(investorWhiteList.isAllowed(msg.sender));
521     _;
522   }
523 
524   function DirectCryptTokenPreSale(
525     uint _hardCapETH,
526     uint _softCapETH,
527 
528     address _token,
529     address _beneficiary,
530     address _investorWhiteList,
531 
532     uint _totalTokens,
533     uint _tokenPriceUsd,
534 
535     uint _baseEthUsdPrice,
536 
537     uint _startTime,
538     uint _endTime
539   ) {
540     ethUsdRate = _baseEthUsdPrice;
541     tokenPriceUsd = _tokenPriceUsd;
542 
543     totalTokens = _totalTokens.mul(1 ether);
544 
545     hardCap = _hardCapETH.mul(1 ether);
546     softCap = _softCapETH.mul(1 ether);
547 
548     token = DirectCryptToken(_token);
549     investorWhiteList = InvestorWhiteList(_investorWhiteList);
550     beneficiary = _beneficiary;
551 
552     startTime = _startTime;
553     endTime = _endTime;
554   }
555 
556   function() payable inWhiteList {
557     doPurchase(msg.sender);
558   }
559 
560   function refund() external preSaleEnded inNormalState {
561     require(softCapReached == false);
562     require(refunded[msg.sender] == false);
563 
564     uint refund = deposited[msg.sender];
565     require(refund > 0);
566 
567     msg.sender.transfer(refund);
568     deposited[msg.sender] = 0;
569     refunded[msg.sender] = true;
570     weiRefunded = weiRefunded.add(refund);
571     Refunded(msg.sender, refund);
572   }
573 
574   function withdraw() external onlyOwner {
575     require(softCapReached);
576     beneficiary.transfer(collected);
577     token.transfer(beneficiary, token.balanceOf(this));
578     crowdsaleFinished = true;
579   }
580 
581   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
582     require(ethUsdPrice > 0);
583     ethUsdRate = ethUsdPrice;
584   }
585 
586   function setEthPriceProvider(address provider) external onlyOwner {
587     require(provider != 0x0);
588     ethPriceProvider = provider;
589   }
590 
591   function setNewWhiteList(address newWhiteList) external onlyOwner {
592     require(newWhiteList != 0x0);
593     investorWhiteList = InvestorWhiteList(newWhiteList);
594   }
595 
596   function doPurchase(address _owner) private preSaleActive inNormalState {
597     require(!crowdsaleFinished);
598     require(collected.add(msg.value) <= hardCap);
599     require(totalTokens >= tokensSold + msg.value.mul(ethUsdRate).div(tokenPriceUsd));
600 
601     if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
602       softCapReached = true;
603       SoftCapReached(softCap);
604     }
605 
606     uint tokens = msg.value.mul(ethUsdRate).div(tokenPriceUsd);
607 
608     if (token.balanceOf(msg.sender) == 0) investorCount++;
609 
610     address referral = investorWhiteList.getReferralOf(msg.sender);
611     uint referralBonus = 0;
612     if (msg.value >= REFERRAL_MIN_LIMIT) {
613       referralBonus = calculateReferralBonus(tokens);
614     }
615 
616     collected = collected.add(msg.value);
617 
618     token.transfer(msg.sender, tokens);
619 
620     uint newTokensSold = tokensSold.add(tokens);
621 
622     if (referralBonus > 0 && referral != 0x0) {
623       newTokensSold = newTokensSold.add(referralBonus);
624     }
625 
626     tokensSold = newTokensSold;
627 
628     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
629     
630     NewContribution(_owner, tokens, msg.value);
631 
632     if (referralBonus > 0 && referral != 0x0) {
633       token.transfer(referral, referralBonus);
634       NewReferralTransfer(msg.sender, referral, referralBonus);
635     }
636   }
637 
638   function calculateReferralBonus(uint tokens) private returns (uint) {
639     return tokens.mul(5).div(100);
640   }
641 }