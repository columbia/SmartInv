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
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /*
43  * Haltable
44  *
45  * Abstract contract that allows children to implement an
46  * emergency stop mechanism. Differs from Pausable by requiring a state.
47  *
48  *
49  * Originally envisioned in FirstBlood ICO contract.
50  */
51 contract Haltable is Ownable {
52   bool public halted = false;
53 
54   modifier inNormalState {
55     require(!halted);
56     _;
57   }
58 
59   modifier inEmergencyState {
60     require(halted);
61     _;
62   }
63 
64   // called by the owner on emergency, triggers stopped state
65   function halt() external onlyOwner inNormalState {
66     halted = true;
67   }
68 
69   // called by the owner on end of emergency, returns to normal state
70   function unhalt() external onlyOwner inEmergencyState {
71     halted = false;
72   }
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal constant returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic {
111   uint256 public totalSupply;
112   function balanceOf(address who) constant returns (uint256);
113   function transfer(address to, uint256 value) returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances. 
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) returns (bool) {
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of. 
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) constant returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/20
152  */
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) constant returns (uint256);
155   function transferFrom(address from, address to, uint256 value) returns (bool);
156   function approve(address spender, uint256 value) returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amout of tokens to be transfered
177    */
178   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
179     var _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
182     // require (_value <= _allowance);
183 
184     balances[_to] = balances[_to].add(_value);
185     balances[_from] = balances[_from].sub(_value);
186     allowed[_from][msg.sender] = _allowance.sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) returns (bool) {
197 
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
203 
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifing the amount of tokens still avaible for the spender.
214    */
215   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
216     return allowed[_owner][_spender];
217   }
218 
219 }
220 
221 /**
222  * @title Burnable
223  *
224  * @dev Standard ERC20 token
225  */
226 contract Burnable is StandardToken {
227   using SafeMath for uint;
228 
229   /* This notifies clients about the amount burnt */
230   event Burn(address indexed from, uint value);
231 
232   function burn(uint _value) returns (bool success) {
233     require(_value > 0 && balances[msg.sender] >= _value);
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     totalSupply = totalSupply.sub(_value);
236     Burn(msg.sender, _value);
237     return true;
238   }
239 
240   function burnFrom(address _from, uint _value) returns (bool success) {
241     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
242     require(_value <= allowed[_from][msg.sender]);
243     balances[_from] = balances[_from].sub(_value);
244     totalSupply = totalSupply.sub(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     Burn(_from, _value);
247     return true;
248   }
249 
250   function transfer(address _to, uint _value) returns (bool success) {
251     require(_to != 0x0); //use burn
252 
253     return super.transfer(_to, _value);
254   }
255 
256   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
257     require(_to != 0x0); //use burn
258 
259     return super.transferFrom(_from, _to, _value);
260   }
261 }
262 
263 /**
264  * @title Contract that will work with ERC223 tokens.
265  */
266 
267 contract ERC223ReceivingContract {
268 /**
269  * @dev Standard ERC223 function that will handle incoming token transfers.
270  *
271  * @param _from  Token sender address.
272  * @param _value Amount of tokens.
273  * @param _data  Transaction metadata.
274  */
275     function tokenFallback(address _from, uint _value, bytes _data);
276 }
277 
278 /**
279  * @title AnythingAppToken
280  *
281  * @dev Burnable Ownable ERC20 token
282  */
283 contract AnythingAppToken is Burnable, Ownable {
284 
285   string public constant name = "AnythingApp Token";
286   string public constant symbol = "ANY";
287   uint8 public constant decimals = 18;
288   uint public constant INITIAL_SUPPLY = 400000000 * 1 ether;
289 
290   /* The finalizer contract that allows unlift the transfer limits on this token */
291   address public releaseAgent;
292 
293   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
294   bool public released = false;
295 
296   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
297   mapping (address => bool) public transferAgents;
298 
299   event Transfer(address indexed from, address indexed to, uint value, bytes data);
300 
301   /**
302    * Limit token transfer until the crowdsale is over.
303    *
304    */
305   modifier canTransfer(address _sender) {
306     require(released || transferAgents[_sender]);
307     _;
308   }
309 
310   /** The function can be called only before or after the tokens have been released */
311   modifier inReleaseState(bool releaseState) {
312     require(releaseState == released);
313     _;
314   }
315 
316   /** The function can be called only by a whitelisted release agent. */
317   modifier onlyReleaseAgent() {
318     require(msg.sender == releaseAgent);
319     _;
320   }
321 
322 
323   /**
324    * @dev Constructor that gives msg.sender all of existing tokens.
325    */
326   function AnythingAppToken() {
327     totalSupply = INITIAL_SUPPLY;
328     balances[msg.sender] = INITIAL_SUPPLY;
329     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
330   }
331 
332   /**
333    * Set the contract that can call release and make the token transferable.
334    *
335    * Design choice. Allow reset the release agent to fix fat finger mistakes.
336    */
337   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
338     require(addr != 0x0);
339 
340     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
341     releaseAgent = addr;
342   }
343 
344   function release() onlyReleaseAgent inReleaseState(false) public {
345     released = true;
346   }
347 
348   /**
349    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
350    */
351   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
352     require(addr != 0x0);
353     transferAgents[addr] = state;
354   }
355 
356   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
357     // Call Burnable.transferForm()
358     return super.transferFrom(_from, _to, _value);
359   }
360 
361 
362   /**
363      * @dev Transfer the specified amount of tokens to the specified address.
364      *      Invokes the `tokenFallback` function if the recipient is a contract.
365      *      The token transfer fails if the recipient is a contract
366      *      but does not implement the `tokenFallback` function
367      *      or the fallback function to receive funds.
368      *
369      * @param _to    Receiver address.
370      * @param _value Amount of tokens that will be transferred.
371      * @param _data  Transaction metadata.
372      */
373     function transfer(address _to, uint _value, bytes _data) canTransfer(msg.sender) returns (bool success) {
374       require(_to != address(0));
375       require(_value <= balances[msg.sender]);
376       uint codeLength;
377       assembly {
378           codeLength := extcodesize(_to)
379       }
380       balances[msg.sender] = balances[msg.sender].sub(_value);
381       balances[_to] = balances[_to].add(_value);
382       if(codeLength>0) {
383           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
384           receiver.tokenFallback(msg.sender, _value, _data);
385       }
386       Transfer(msg.sender, _to, _value, _data);
387       return true;
388     }
389 
390     /**
391      * @dev Transfer the specified amount of tokens to the specified address.
392      *      This function works the same with the previous one
393      *      but doesn't contain `_data` param.
394      *      Added due to backwards compatibility reasons.
395      *
396      * @param _to    Receiver address.
397      * @param _value Amount of tokens that will be transferred.
398      */
399     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
400       require(_to != address(0));
401       require(_value <= balances[msg.sender]);
402 
403       uint codeLength;
404       bytes memory empty;
405 
406       assembly {
407           codeLength := extcodesize(_to)
408       }
409 
410       balances[msg.sender] = balances[msg.sender].sub(_value);
411       balances[_to] = balances[_to].add(_value);
412       if(codeLength>0) {
413           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
414           receiver.tokenFallback(msg.sender, _value, empty);
415       }
416       Transfer(msg.sender, _to, _value, empty);
417       return true;
418     }
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
466   modifier onlyEthPriceProvider() {
467     require(msg.sender == ethPriceProvider);
468     _;
469   }
470 
471   function receiveEthPrice(uint ethUsdPrice) external;
472 
473   function setEthPriceProvider(address provider) external;
474 }
475 
476 contract AnythingAppTokenPreSale is Haltable, PriceReceiver {
477   using SafeMath for uint;
478 
479   string public constant name = "AnythingAppTokenPreSale";
480 
481   AnythingAppToken public token;
482   InvestorWhiteList public investorWhiteList;
483   address public beneficiary;
484 
485   uint public tokenPriceUsd;
486   uint public totalTokens;//in wei
487 
488   uint public ethUsdRate;
489 
490   uint public collected = 0;
491   uint public withdrawn = 0;
492   uint public tokensSold = 0;
493   uint public investorCount = 0;
494   uint public weiRefunded = 0;
495 
496   uint public startTime;
497   uint public endTime;
498 
499   bool public crowdsaleFinished = false;
500 
501   mapping (address => bool) public refunded;
502   mapping (address => uint) public deposited;
503 
504   uint public constant MINIMAL_PURCHASE = 250 ether;
505   uint public constant LIMIT_PER_USER = 500000 ether;
506 
507   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
508   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
509   event Refunded(address indexed holder, uint amount);
510   event Deposited(address indexed holder, uint amount);
511 
512   modifier preSaleActive() {
513     require(block.timestamp >= startTime && block.timestamp < endTime);
514     _;
515   }
516 
517   modifier preSaleEnded() {
518     require(block.timestamp >= endTime);
519     _;
520   }
521 
522 
523   function AnythingAppTokenPreSale(
524     address _token,
525     address _beneficiary,
526     address _investorWhiteList,
527 
528     uint _totalTokens,
529     uint _tokenPriceUsd,
530 
531     uint _baseEthUsdPrice,
532 
533     uint _startTime,
534     uint _endTime
535   ) {
536     ethUsdRate = _baseEthUsdPrice;
537     tokenPriceUsd = _tokenPriceUsd;
538 
539     totalTokens = _totalTokens.mul(1 ether);
540 
541     token = AnythingAppToken(_token);
542     investorWhiteList = InvestorWhiteList(_investorWhiteList);
543     beneficiary = _beneficiary;
544 
545     startTime = _startTime;
546     endTime = _endTime;
547   }
548 
549   function() payable {
550     doPurchase(msg.sender);
551   }
552 
553   function tokenFallback(address _from, uint _value, bytes _data) public pure { }
554 
555   function doPurchase(address _owner) private preSaleActive inNormalState {
556     if (token.balanceOf(msg.sender) == 0) investorCount++;
557 
558     uint tokens = msg.value.mul(ethUsdRate).div(tokenPriceUsd);
559     address referral = investorWhiteList.getReferralOf(msg.sender);
560     uint referralBonus = calculateReferralBonus(tokens);
561 
562     uint newTokensSold = tokensSold.add(tokens);
563     if (referralBonus > 0 && referral != 0x0) {
564       newTokensSold = newTokensSold.add(referralBonus);
565     }
566 
567     require(newTokensSold <= totalTokens);
568     require(token.balanceOf(msg.sender).add(tokens) <= LIMIT_PER_USER);
569 
570     tokensSold = newTokensSold;
571 
572     collected = collected.add(msg.value);
573     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
574 
575     token.transfer(msg.sender, tokens);
576     NewContribution(_owner, tokens, msg.value);
577 
578     if (referralBonus > 0 && referral != 0x0) {
579       token.transfer(referral, referralBonus);
580       NewReferralTransfer(msg.sender, referral, referralBonus);
581     }
582   }
583 
584   function calculateReferralBonus(uint _tokens) internal constant returns (uint _bonus) {
585     return _tokens.mul(20).div(100);
586   }
587 
588   function withdraw() external onlyOwner {
589     uint toWithdraw = collected.sub(withdrawn);
590     beneficiary.transfer(toWithdraw);
591     withdrawn = withdrawn.add(toWithdraw);
592   }
593 
594   function withdrawTokens() external onlyOwner {
595     token.transfer(beneficiary, token.balanceOf(this));
596   }
597 
598   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
599     require(ethUsdPrice > 0);
600     ethUsdRate = ethUsdPrice;
601   }
602 
603   function setEthPriceProvider(address provider) external onlyOwner {
604     require(provider != 0x0);
605     ethPriceProvider = provider;
606   }
607 
608   function setNewWhiteList(address newWhiteList) external onlyOwner {
609     require(newWhiteList != 0x0);
610     investorWhiteList = InvestorWhiteList(newWhiteList);
611   }
612 }