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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 }
50 
51 /*
52  * Haltable
53  *
54  * Abstract contract that allows children to implement an
55  * emergency stop mechanism. Differs from Pausable by requiring a state.
56  *
57  *
58  * Originally envisioned in FirstBlood ICO contract.
59  */
60 contract Haltable is Ownable {
61   bool public halted = false;
62 
63   modifier inNormalState {
64     require(!halted);
65     _;
66   }
67 
68   modifier inEmergencyState {
69     require(halted);
70     _;
71   }
72 
73   // called by the owner on emergency, triggers stopped state
74   function halt() external onlyOwner inNormalState {
75     halted = true;
76   }
77 
78   // called by the owner on end of emergency, returns to normal state
79   function unhalt() external onlyOwner inEmergencyState {
80     halted = false;
81   }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     if (a == 0) {
95       return 0;
96     }
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
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   function totalSupply() public view returns (uint256);
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 /**
187  * @title ERC20 interface
188  * @dev see https://github.com/ethereum/EIPs/issues/20
189  */
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(address _owner, address _spender) public view returns (uint256) {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
264     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Decrease the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 /**
293  * @title Burnable
294  *
295  * @dev Standard ERC20 token
296  */
297 contract Burnable is StandardToken {
298   using SafeMath for uint;
299 
300   /* This notifies clients about the amount burnt */
301   event Burn(address indexed from, uint value);
302 
303   function burn(uint _value) returns (bool success) {
304     require(_value > 0 && balances[msg.sender] >= _value);
305     balances[msg.sender] = balances[msg.sender].sub(_value);
306     totalSupply_ = totalSupply_.sub(_value);
307     Burn(msg.sender, _value);
308     return true;
309   }
310 
311   function burnFrom(address _from, uint _value) returns (bool success) {
312     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
313     require(_value <= allowed[_from][msg.sender]);
314     balances[_from] = balances[_from].sub(_value);
315     totalSupply_ = totalSupply_.sub(_value);
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     Burn(_from, _value);
318     return true;
319   }
320 
321   function transfer(address _to, uint _value) returns (bool success) {
322     require(_to != 0x0); //use burn
323 
324     return super.transfer(_to, _value);
325   }
326 
327   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
328     require(_to != 0x0); //use burn
329 
330     return super.transferFrom(_from, _to, _value);
331   }
332 }
333 
334 /**
335  * @title MyPizzaPieToken
336  *
337  * @dev Burnable Ownable ERC20 token
338  */
339 contract MyPizzaPieToken is Burnable, Ownable {
340 
341   string public constant name = "MyPizzaPie Token";
342   string public constant symbol = "PZA";
343   uint8 public constant decimals = 18;
344   uint public constant INITIAL_SUPPLY = 81192000 * 1 ether;
345 
346   /* The finalizer contract that allows unlift the transfer limits on this token */
347   address public releaseAgent;
348 
349   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
350   bool public released = false;
351 
352   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
353   mapping (address => bool) public transferAgents;
354 
355   /**
356    * Limit token transfer until the crowdsale is over.
357    *
358    */
359   modifier canTransfer(address _sender) {
360     require(released || transferAgents[_sender]);
361     _;
362   }
363 
364   /** The function can be called only before or after the tokens have been released */
365   modifier inReleaseState(bool releaseState) {
366     require(releaseState == released);
367     _;
368   }
369 
370   /** The function can be called only by a whitelisted release agent. */
371   modifier onlyReleaseAgent() {
372     require(msg.sender == releaseAgent);
373     _;
374   }
375 
376 
377   /**
378    * @dev Constructor that gives msg.sender all of existing tokens.
379    */
380   function MyPizzaPieToken() {
381     totalSupply_ = INITIAL_SUPPLY;
382     balances[msg.sender] = INITIAL_SUPPLY;
383   }
384 
385 
386   /**
387    * Set the contract that can call release and make the token transferable.
388    *
389    * Design choice. Allow reset the release agent to fix fat finger mistakes.
390    */
391   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
392     require(addr != 0x0);
393 
394     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
395     releaseAgent = addr;
396   }
397 
398   function release() onlyReleaseAgent inReleaseState(false) public {
399     released = true;
400   }
401 
402   /**
403    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
404    */
405   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
406     require(addr != 0x0);
407     transferAgents[addr] = state;
408   }
409 
410   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
411     // Call Burnable.transfer()
412     return super.transfer(_to, _value);
413   }
414 
415   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
416     // Call Burnable.transferForm()
417     return super.transferFrom(_from, _to, _value);
418   }
419 
420   function burn(uint _value) onlyOwner returns (bool success) {
421     return super.burn(_value);
422   }
423 
424   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
425     return super.burnFrom(_from, _value);
426   }
427 }
428 
429 contract InvestorWhiteList is Ownable {
430   mapping (address => bool) public investorWhiteList;
431 
432   mapping (address => address) public referralList;
433 
434   function InvestorWhiteList() {
435 
436   }
437 
438   function addInvestorToWhiteList(address investor) external onlyOwner {
439     require(investor != 0x0 && !investorWhiteList[investor]);
440     investorWhiteList[investor] = true;
441   }
442 
443   function removeInvestorFromWhiteList(address investor) external onlyOwner {
444     require(investor != 0x0 && investorWhiteList[investor]);
445     investorWhiteList[investor] = false;
446   }
447 
448   //when new user will contribute ICO contract will automatically send bonus to referral
449   function addReferralOf(address investor, address referral) external onlyOwner {
450     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
451     referralList[investor] = referral;
452   }
453 
454   function isAllowed(address investor) constant external returns (bool result) {
455     return investorWhiteList[investor];
456   }
457 
458   function getReferralOf(address investor) constant external returns (address result) {
459     return referralList[investor];
460   }
461 }
462 
463 contract PriceReceiver {
464   address public ethPriceProvider;
465 
466   address public btcPriceProvider;
467 
468   modifier onlyEthPriceProvider() {
469     require(msg.sender == ethPriceProvider);
470     _;
471   }
472 
473   modifier onlyBtcPriceProvider() {
474     require(msg.sender == btcPriceProvider);
475     _;
476   }
477 
478   function receiveEthPrice(uint ethUsdPrice) external;
479 
480   function receiveBtcPrice(uint btcUsdPrice) external;
481 
482   function setEthPriceProvider(address provider) external;
483 
484   function setBtcPriceProvider(address provider) external;
485 }
486 
487 contract MyPizzaPieTokenPreSale is Haltable, PriceReceiver {
488   using SafeMath for uint;
489 
490   string public constant name = "MyPizzaPie Token PreSale";
491   uint public VOLUME_70 = 2000 ether;
492   uint public VOLUME_60 = 1000 ether;
493   uint public VOLUME_50 = 100 ether;
494   uint public VOLUME_25 = 1 ether;
495   uint public VOLUME_5 = 0.1 ether;
496 
497   MyPizzaPieToken public token;
498   InvestorWhiteList public investorWhiteList;
499 
500   address public beneficiary;
501 
502   uint public hardCap;
503   uint public softCap;
504 
505   uint public ethUsdRate;
506   uint public btcUsdRate;
507 
508   uint public tokenPriceUsd;
509   uint public totalTokens;//in wei
510 
511   uint public collected = 0;
512   uint public tokensSold = 0;
513   uint public investorCount = 0;
514   uint public weiRefunded = 0;
515 
516   uint public startTime;
517   uint public endTime;
518 
519   bool public softCapReached = false;
520   bool public crowdsaleFinished = false;
521 
522   mapping (address => bool) refunded;
523   mapping (address => uint) public deposited;
524 
525   event SoftCapReached(uint softCap);
526   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
527   event Refunded(address indexed holder, uint amount);
528   event Deposited(address indexed holder, uint amount);
529   event Amount(uint amount);
530   event Timestamp(uint time);
531 
532   modifier preSaleActive() {
533     require(now >= startTime && now < endTime);
534     _;
535   }
536 
537   modifier preSaleEnded() {
538     require(now >= endTime);
539     _;
540   }
541 
542   modifier inWhiteList() {
543     require(investorWhiteList.isAllowed(msg.sender));
544     _;
545   }
546 
547   function MyPizzaPieTokenPreSale(
548     uint _hardCapETH,
549     uint _softCapETH,
550 
551     address _token,
552     address _beneficiary,
553     address _investorWhiteList,
554 
555     uint _totalTokens,
556     uint _tokenPriceUsd,
557 
558     uint _baseEthUsdPrice,
559     uint _baseBtcUsdPrice,
560 
561     uint _startTime,
562     uint _endTime
563   ) {
564     ethUsdRate = _baseEthUsdPrice;
565     btcUsdRate = _baseBtcUsdPrice;
566     tokenPriceUsd = _tokenPriceUsd;
567 
568     totalTokens = _totalTokens.mul(1 ether);
569 
570     hardCap = _hardCapETH.mul(1 ether);
571     softCap = _softCapETH.mul(1 ether);
572 
573     token = MyPizzaPieToken(_token);
574     investorWhiteList = InvestorWhiteList(_investorWhiteList);
575     beneficiary = _beneficiary;
576 
577     startTime = _startTime;
578     endTime = _endTime;
579 
580     Timestamp(block.timestamp);
581     Timestamp(startTime);
582   }
583 
584   function() payable inWhiteList {
585     doPurchase(msg.sender);
586   }
587 
588   function refund() external preSaleEnded inNormalState {
589     require(softCapReached == false);
590     require(refunded[msg.sender] == false);
591 
592     uint refund = deposited[msg.sender];
593     require(refund > 0);
594 
595     msg.sender.transfer(refund);
596     deposited[msg.sender] = 0;
597     refunded[msg.sender] = true;
598     weiRefunded = weiRefunded.add(refund);
599     Refunded(msg.sender, refund);
600   }
601 
602   function withdraw() external onlyOwner {
603     require(softCapReached);
604     beneficiary.transfer(collected);
605     token.transfer(beneficiary, token.balanceOf(this));
606     crowdsaleFinished = true;
607   }
608 
609   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
610     require(ethUsdPrice > 0);
611     ethUsdRate = ethUsdPrice;
612   }
613 
614   function receiveBtcPrice(uint btcUsdPrice) external onlyBtcPriceProvider {
615     require(btcUsdPrice > 0);
616     btcUsdRate = btcUsdPrice;
617   }
618 
619   function setEthPriceProvider(address provider) external onlyOwner {
620     require(provider != 0x0);
621     ethPriceProvider = provider;
622   }
623 
624   function setBtcPriceProvider(address provider) external onlyOwner {
625     require(provider != 0x0);
626     btcPriceProvider = provider;
627   }
628 
629   function setNewWhiteList(address newWhiteList) external onlyOwner {
630     require(newWhiteList != 0x0);
631     investorWhiteList = InvestorWhiteList(newWhiteList);
632   }
633 
634   function doPurchase(address _owner) private preSaleActive inNormalState {
635     require(!crowdsaleFinished);
636     require(collected.add(msg.value) <= hardCap);
637     require(totalTokens >= tokensSold + msg.value.mul(ethUsdRate).div(tokenPriceUsd));
638 
639     if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
640       softCapReached = true;
641       SoftCapReached(softCap);
642     }
643 
644     uint tokens = msg.value.mul(ethUsdRate).div(tokenPriceUsd);
645     uint bonus = calculateBonus(msg.value);
646     
647     if (bonus > 0) {
648       tokens = tokens + tokens.mul(bonus).div(100);
649     }
650 
651     if (token.balanceOf(msg.sender) == 0) investorCount++;
652 
653     collected = collected.add(msg.value);
654 
655     token.transfer(msg.sender, tokens);
656 
657     tokensSold = tokensSold.add(tokens);
658     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
659     
660     NewContribution(_owner, tokens, msg.value);
661   }
662 
663   function calculateBonus(uint value) private returns (uint bonus) {
664     if (value >= VOLUME_70) {
665       return 70;
666     } else if (value >= VOLUME_60) {
667       return 60;
668     } else if (value >= VOLUME_50) {
669       return 50;
670     } else if (value >= VOLUME_25) {
671       return 25;
672     }else if (value >= VOLUME_5) {
673       return 5;
674     }
675 
676     return 0;
677   }
678 }