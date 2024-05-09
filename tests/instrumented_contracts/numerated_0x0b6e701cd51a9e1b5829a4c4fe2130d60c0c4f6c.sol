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
285   string public constant name = "AnyCoin";
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
299   /**
300    * Limit token transfer until the crowdsale is over.
301    *
302    */
303   modifier canTransfer(address _sender) {
304     require(released || transferAgents[_sender]);
305     _;
306   }
307 
308   /** The function can be called only before or after the tokens have been released */
309   modifier inReleaseState(bool releaseState) {
310     require(releaseState == released);
311     _;
312   }
313 
314   /** The function can be called only by a whitelisted release agent. */
315   modifier onlyReleaseAgent() {
316     require(msg.sender == releaseAgent);
317     _;
318   }
319 
320 
321   /**
322    * @dev Constructor that gives msg.sender all of existing tokens.
323    */
324   function AnythingAppToken() {
325     totalSupply = INITIAL_SUPPLY;
326     balances[msg.sender] = INITIAL_SUPPLY;
327     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
328   }
329 
330   /**
331    * Set the contract that can call release and make the token transferable.
332    *
333    * Design choice. Allow reset the release agent to fix fat finger mistakes.
334    */
335   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
336     require(addr != 0x0);
337 
338     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
339     releaseAgent = addr;
340   }
341 
342   function release() onlyReleaseAgent inReleaseState(false) public {
343     released = true;
344   }
345 
346   /**
347    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
348    */
349   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
350     require(addr != 0x0);
351     transferAgents[addr] = state;
352   }
353 
354   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
355     // Call Burnable.transferForm()
356     return super.transferFrom(_from, _to, _value);
357   }
358 
359 
360   /**
361      * @dev Transfer the specified amount of tokens to the specified address.
362      *      Invokes the `tokenFallback` function if the recipient is a contract.
363      *      The token transfer fails if the recipient is a contract
364      *      but does not implement the `tokenFallback` function
365      *      or the fallback function to receive funds.
366      *
367      * @param _to    Receiver address.
368      * @param _value Amount of tokens that will be transferred.
369      * @param _data  Transaction metadata.
370      */
371     function transfer(address _to, uint _value, bytes _data) canTransfer(msg.sender) returns (bool success) {
372       require(_to != address(0));
373       require(_value <= balances[msg.sender]);
374       uint codeLength;
375       assembly {
376           codeLength := extcodesize(_to)
377       }
378       balances[msg.sender] = balances[msg.sender].sub(_value);
379       balances[_to] = balances[_to].add(_value);
380       if(codeLength>0) {
381           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
382           receiver.tokenFallback(msg.sender, _value, _data);
383       }
384       Transfer(msg.sender, _to, _value);
385       return true;
386     }
387 
388     /**
389      * @dev Transfer the specified amount of tokens to the specified address.
390      *      This function works the same with the previous one
391      *      but doesn't contain `_data` param.
392      *      Added due to backwards compatibility reasons.
393      *
394      * @param _to    Receiver address.
395      * @param _value Amount of tokens that will be transferred.
396      */
397     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
398       require(_to != address(0));
399       require(_value <= balances[msg.sender]);
400 
401       uint codeLength;
402       bytes memory empty;
403 
404       assembly {
405           codeLength := extcodesize(_to)
406       }
407 
408       balances[msg.sender] = balances[msg.sender].sub(_value);
409       balances[_to] = balances[_to].add(_value);
410       if(codeLength>0) {
411           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
412           receiver.tokenFallback(msg.sender, _value, empty);
413       }
414       Transfer(msg.sender, _to, _value);
415       return true;
416     }
417 
418   function burn(uint _value) onlyOwner returns (bool success) {
419     return super.burn(_value);
420   }
421 
422   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
423     return super.burnFrom(_from, _value);
424   }
425 }
426 
427 contract InvestorWhiteList is Ownable {
428   mapping (address => bool) public investorWhiteList;
429 
430   mapping (address => address) public referralList;
431 
432   function InvestorWhiteList() {
433 
434   }
435 
436   function addInvestorToWhiteList(address investor) external onlyOwner {
437     require(investor != 0x0 && !investorWhiteList[investor]);
438     investorWhiteList[investor] = true;
439   }
440 
441   function removeInvestorFromWhiteList(address investor) external onlyOwner {
442     require(investor != 0x0 && investorWhiteList[investor]);
443     investorWhiteList[investor] = false;
444   }
445 
446   //when new user will contribute ICO contract will automatically send bonus to referral
447   function addReferralOf(address investor, address referral) external onlyOwner {
448     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
449     referralList[investor] = referral;
450   }
451 
452   function isAllowed(address investor) constant external returns (bool result) {
453     return investorWhiteList[investor];
454   }
455 
456   function getReferralOf(address investor) constant external returns (address result) {
457     return referralList[investor];
458   }
459 }
460 
461 contract PriceReceiver {
462   address public ethPriceProvider;
463 
464   modifier onlyEthPriceProvider() {
465     require(msg.sender == ethPriceProvider);
466     _;
467   }
468 
469   function receiveEthPrice(uint ethUsdPrice) external;
470 
471   function setEthPriceProvider(address provider) external;
472 }
473 
474 contract AnythingAppTokenPreSale is Haltable, PriceReceiver {
475   using SafeMath for uint;
476 
477   string public constant name = "AnythingAppTokenPreSale";
478 
479   AnythingAppToken public token;
480   InvestorWhiteList public investorWhiteList;
481   address public beneficiary;
482 
483   uint public tokenPriceUsd;
484   uint public totalTokens;//in wei
485 
486   uint public ethUsdRate;
487 
488   uint public collected = 0;
489   uint public withdrawn = 0;
490   uint public tokensSold = 0;
491   uint public investorCount = 0;
492   uint public weiRefunded = 0;
493 
494   uint public startTime;
495   uint public endTime;
496 
497   bool public crowdsaleFinished = false;
498 
499   mapping (address => bool) public refunded;
500   mapping (address => uint) public deposited;
501 
502   uint public constant BONUS_LEVEL_1 = 40;
503   uint public constant BONUS_LEVEL_2 = 35;
504   uint public constant BONUS_LEVEL_3 = 30;
505 
506   uint public firstStage;
507   uint public secondStage;
508   uint public thirdStage;
509 
510   uint public constant MINIMAL_PURCHASE = 250 ether;
511   uint public constant LIMIT_PER_USER = 500000 ether;
512 
513   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
514   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
515   event Refunded(address indexed holder, uint amount);
516   event Deposited(address indexed holder, uint amount);
517 
518   modifier preSaleActive() {
519     require(block.timestamp >= startTime && block.timestamp < endTime);
520     _;
521   }
522 
523   modifier preSaleEnded() {
524     require(block.timestamp >= endTime);
525     _;
526   }
527 
528   modifier inWhiteList() {
529     require(investorWhiteList.isAllowed(msg.sender));
530     _;
531   }
532 
533   function AnythingAppTokenPreSale(
534     address _token,
535     address _beneficiary,
536     address _investorWhiteList,
537 
538     uint _totalTokens,
539     uint _tokenPriceUsd,
540 
541     uint _baseEthUsdPrice,
542 
543     uint _firstStage,
544     uint _secondStage,
545     uint _thirdStage,
546 
547     uint _startTime,
548     uint _endTime
549   ) {
550     ethUsdRate = _baseEthUsdPrice;
551     tokenPriceUsd = _tokenPriceUsd;
552 
553     totalTokens = _totalTokens.mul(1 ether);
554 
555     token = AnythingAppToken(_token);
556     investorWhiteList = InvestorWhiteList(_investorWhiteList);
557     beneficiary = _beneficiary;
558 
559     firstStage = _firstStage.mul(1 ether);
560     secondStage = _secondStage.mul(1 ether);
561     thirdStage = _thirdStage.mul(1 ether);
562 
563     startTime = _startTime;
564     endTime = _endTime;
565   }
566 
567   function() payable inWhiteList {
568     doPurchase(msg.sender);
569   }
570 
571   function tokenFallback(address _from, uint _value, bytes _data) public pure { }
572 
573   function doPurchase(address _owner) private preSaleActive inNormalState {
574     if (token.balanceOf(msg.sender) == 0) investorCount++;
575 
576     uint tokens = msg.value.mul(ethUsdRate).div(tokenPriceUsd);
577     address referral = investorWhiteList.getReferralOf(msg.sender);
578     uint referralBonus = calculateReferralBonus(tokens);
579     uint bonus = calculateBonus(tokens, referral);
580 
581     tokens = tokens.add(bonus);
582 
583     uint newTokensSold = tokensSold.add(tokens);
584     if (referralBonus > 0 && referral != 0x0) {
585       newTokensSold = newTokensSold.add(referralBonus);
586     }
587 
588     require(newTokensSold <= totalTokens);
589     require(token.balanceOf(msg.sender).add(tokens) <= LIMIT_PER_USER);
590 
591     tokensSold = newTokensSold;
592 
593     collected = collected.add(msg.value);
594     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
595 
596     token.transfer(msg.sender, tokens);
597     NewContribution(_owner, tokens, msg.value);
598 
599     if (referralBonus > 0 && referral != 0x0) {
600       token.transfer(referral, referralBonus);
601       NewReferralTransfer(msg.sender, referral, referralBonus);
602     }
603   }
604 
605   function calculateBonus(uint _tokens, address _referral) private returns (uint _bonuses) {
606     uint bonus;
607 
608     if (tokensSold < firstStage) {
609       bonus = BONUS_LEVEL_1;
610     } else if (tokensSold >= firstStage && tokensSold < secondStage) {
611       bonus = BONUS_LEVEL_2;
612     } else {
613       bonus = BONUS_LEVEL_3;
614     }
615 
616     if (_referral != 0x0) {
617       bonus += 5;
618     }
619 
620     return _tokens.mul(bonus).div(100);
621   }
622 
623   function calculateReferralBonus(uint _tokens) internal constant returns (uint _bonus) {
624     return _tokens.mul(20).div(100);
625   }
626 
627   function withdraw() external onlyOwner {
628     uint withdrawLimit = 500 ether;
629     if (withdrawn < withdrawLimit) {
630       uint toWithdraw = collected.sub(withdrawn);
631       if (toWithdraw + withdrawn > withdrawLimit) {
632         toWithdraw = withdrawLimit.sub(withdrawn);
633       }
634       beneficiary.transfer(toWithdraw);
635       withdrawn = withdrawn.add(toWithdraw);
636       return;
637     }
638     require(block.timestamp >= endTime);
639     beneficiary.transfer(collected);
640     token.transfer(beneficiary, token.balanceOf(this));
641     crowdsaleFinished = true;
642   }
643 
644   function refund() external preSaleEnded inNormalState {
645     require(refunded[msg.sender] == false);
646 
647     uint refund = deposited[msg.sender];
648     require(refund > 0);
649 
650     deposited[msg.sender] = 0;
651     refunded[msg.sender] = true;
652     weiRefunded = weiRefunded.add(refund);
653     msg.sender.transfer(refund);
654     Refunded(msg.sender, refund);
655   }
656 
657   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
658     require(ethUsdPrice > 0);
659     ethUsdRate = ethUsdPrice;
660   }
661 
662   function setEthPriceProvider(address provider) external onlyOwner {
663     require(provider != 0x0);
664     ethPriceProvider = provider;
665   }
666 
667   function setNewWhiteList(address newWhiteList) external onlyOwner {
668     require(newWhiteList != 0x0);
669     investorWhiteList = InvestorWhiteList(newWhiteList);
670   }
671 }