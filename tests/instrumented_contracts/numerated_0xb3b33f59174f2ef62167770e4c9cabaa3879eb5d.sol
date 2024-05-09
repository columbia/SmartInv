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
264  * @title JincorToken
265  *
266  * @dev Burnable Ownable ERC20 token
267  */
268 contract JincorToken is Burnable, Ownable {
269 
270   string public constant name = "Jincor Token";
271   string public constant symbol = "JCR";
272   uint8 public constant decimals = 18;
273   uint public constant INITIAL_SUPPLY = 35000000 * 1 ether;
274 
275   /* The finalizer contract that allows unlift the transfer limits on this token */
276   address public releaseAgent;
277 
278   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
279   bool public released = false;
280 
281   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
282   mapping (address => bool) public transferAgents;
283 
284   /**
285    * Limit token transfer until the crowdsale is over.
286    *
287    */
288   modifier canTransfer(address _sender) {
289     require(released || transferAgents[_sender]);
290     _;
291   }
292 
293   /** The function can be called only before or after the tokens have been released */
294   modifier inReleaseState(bool releaseState) {
295     require(releaseState == released);
296     _;
297   }
298 
299   /** The function can be called only by a whitelisted release agent. */
300   modifier onlyReleaseAgent() {
301     require(msg.sender == releaseAgent);
302     _;
303   }
304 
305 
306   /**
307    * @dev Constructor that gives msg.sender all of existing tokens.
308    */
309   function JincorToken() {
310     totalSupply = INITIAL_SUPPLY;
311     balances[msg.sender] = INITIAL_SUPPLY;
312   }
313 
314 
315   /**
316    * Set the contract that can call release and make the token transferable.
317    *
318    * Design choice. Allow reset the release agent to fix fat finger mistakes.
319    */
320   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
321     require(addr != 0x0);
322 
323     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
324     releaseAgent = addr;
325   }
326 
327   function release() onlyReleaseAgent inReleaseState(false) public {
328     released = true;
329   }
330 
331   /**
332    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
333    */
334   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
335     require(addr != 0x0);
336     transferAgents[addr] = state;
337   }
338 
339   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
340     // Call Burnable.transfer()
341     return super.transfer(_to, _value);
342   }
343 
344   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
345     // Call Burnable.transferForm()
346     return super.transferFrom(_from, _to, _value);
347   }
348 
349   function burn(uint _value) onlyOwner returns (bool success) {
350     return super.burn(_value);
351   }
352 
353   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
354     return super.burnFrom(_from, _value);
355   }
356 }
357 
358 contract InvestorWhiteList is Ownable {
359   mapping (address => bool) public investorWhiteList;
360 
361   mapping (address => address) public referralList;
362 
363   function InvestorWhiteList() {
364 
365   }
366 
367   function addInvestorToWhiteList(address investor) external onlyOwner {
368     require(investor != 0x0 && !investorWhiteList[investor]);
369     investorWhiteList[investor] = true;
370   }
371 
372   function removeInvestorFromWhiteList(address investor) external onlyOwner {
373     require(investor != 0x0 && investorWhiteList[investor]);
374     investorWhiteList[investor] = false;
375   }
376 
377   //when new user will contribute ICO contract will automatically send bonus to referral
378   function addReferralOf(address investor, address referral) external onlyOwner {
379     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
380     referralList[investor] = referral;
381   }
382 
383   function isAllowed(address investor) constant external returns (bool result) {
384     return investorWhiteList[investor];
385   }
386 
387   function getReferralOf(address investor) constant external returns (address result) {
388     return referralList[investor];
389   }
390 }
391 
392 contract PriceReceiver {
393   address public ethPriceProvider;
394 
395   address public btcPriceProvider;
396 
397   modifier onlyEthPriceProvider() {
398     require(msg.sender == ethPriceProvider);
399     _;
400   }
401 
402   modifier onlyBtcPriceProvider() {
403     require(msg.sender == btcPriceProvider);
404     _;
405   }
406 
407   function receiveEthPrice(uint ethUsdPrice) external;
408 
409   function receiveBtcPrice(uint btcUsdPrice) external;
410 
411   function setEthPriceProvider(address provider) external;
412 
413   function setBtcPriceProvider(address provider) external;
414 }
415 
416 contract JincorTokenICO is Haltable, PriceReceiver {
417   using SafeMath for uint;
418 
419   string public constant name = "Jincor Token ICO";
420 
421   JincorToken public token;
422 
423   address public beneficiary;
424 
425   address public constant preSaleAddress = 0x949C9B8dFf9b264CAD57F69Cd98ECa1338F05B39;
426 
427   InvestorWhiteList public investorWhiteList;
428 
429   uint public constant jcrUsdRate = 100; //in cents
430 
431   uint public ethUsdRate;
432 
433   uint public btcUsdRate;
434 
435   uint public hardCap;
436 
437   uint public softCap;
438 
439   uint public collected = 0;
440 
441   uint public tokensSold = 0;
442 
443   uint public weiRefunded = 0;
444 
445   uint public startBlock;
446 
447   uint public endBlock;
448 
449   bool public softCapReached = false;
450 
451   bool public crowdsaleFinished = false;
452 
453   mapping (address => uint) public deposited;
454 
455   uint constant VOLUME_20_REF_7 = 5000 ether;
456 
457   uint constant VOLUME_15_REF_6 = 2000 ether;
458 
459   uint constant VOLUME_12d5_REF_5d5 = 1000 ether;
460 
461   uint constant VOLUME_10_REF_5 = 500 ether;
462 
463   uint constant VOLUME_7_REF_4 = 250 ether;
464 
465   uint constant VOLUME_5_REF_3 = 100 ether;
466 
467   event SoftCapReached(uint softCap);
468 
469   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
470 
471   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
472 
473   event Refunded(address indexed holder, uint amount);
474 
475   modifier icoActive() {
476     require(block.number >= startBlock && block.number < endBlock);
477     _;
478   }
479 
480   modifier icoEnded() {
481     require(block.number >= endBlock);
482     _;
483   }
484 
485   modifier minInvestment() {
486     require(msg.value >= 0.1 * 1 ether);
487     _;
488   }
489 
490   modifier inWhiteList() {
491     require(investorWhiteList.isAllowed(msg.sender));
492     _;
493   }
494 
495   function JincorTokenICO(
496     uint _hardCapJCR,
497     uint _softCapJCR,
498     address _token,
499     address _beneficiary,
500     address _investorWhiteList,
501     uint _baseEthUsdPrice,
502     uint _baseBtcUsdPrice,
503 
504     uint _startBlock,
505     uint _endBlock
506   ) {
507     hardCap = _hardCapJCR.mul(1 ether);
508     softCap = _softCapJCR.mul(1 ether);
509 
510     token = JincorToken(_token);
511     beneficiary = _beneficiary;
512     investorWhiteList = InvestorWhiteList(_investorWhiteList);
513 
514     startBlock = _startBlock;
515     endBlock = _endBlock;
516 
517     ethUsdRate = _baseEthUsdPrice;
518     btcUsdRate = _baseBtcUsdPrice;
519     owner = 0xd1436F0A5e9b063733A67E5dc9Abe45792A423fE;
520   }
521 
522   function() payable minInvestment inWhiteList {
523     doPurchase();
524   }
525 
526   function refund() external icoEnded {
527     require(softCapReached == false);
528     require(deposited[msg.sender] > 0);
529 
530     uint refund = deposited[msg.sender];
531 
532     deposited[msg.sender] = 0;
533     msg.sender.transfer(refund);
534 
535     weiRefunded = weiRefunded.add(refund);
536     Refunded(msg.sender, refund);
537   }
538 
539   function withdraw() external onlyOwner {
540     require(softCapReached);
541     beneficiary.transfer(collected);
542     token.transfer(beneficiary, token.balanceOf(this));
543     crowdsaleFinished = true;
544   }
545 
546   function calculateBonus(uint tokens) internal constant returns (uint bonus) {
547     if (msg.value >= VOLUME_20_REF_7) {
548       return tokens.mul(20).div(100);
549     }
550 
551     if (msg.value >= VOLUME_15_REF_6) {
552       return tokens.mul(15).div(100);
553     }
554 
555     if (msg.value >= VOLUME_12d5_REF_5d5) {
556       return tokens.mul(125).div(1000);
557     }
558 
559     if (msg.value >= VOLUME_10_REF_5) {
560       return tokens.mul(10).div(100);
561     }
562 
563     if (msg.value >= VOLUME_7_REF_4) {
564       return tokens.mul(7).div(100);
565     }
566 
567     if (msg.value >= VOLUME_5_REF_3) {
568       return tokens.mul(5).div(100);
569     }
570 
571     return 0;
572   }
573 
574   function calculateReferralBonus(uint tokens) internal constant returns (uint bonus) {
575     if (msg.value >= VOLUME_20_REF_7) {
576       return tokens.mul(7).div(100);
577     }
578 
579     if (msg.value >= VOLUME_15_REF_6) {
580       return tokens.mul(6).div(100);
581     }
582 
583     if (msg.value >= VOLUME_12d5_REF_5d5) {
584       return tokens.mul(55).div(1000);
585     }
586 
587     if (msg.value >= VOLUME_10_REF_5) {
588       return tokens.mul(5).div(100);
589     }
590 
591     if (msg.value >= VOLUME_7_REF_4) {
592       return tokens.mul(4).div(100);
593     }
594 
595     if (msg.value >= VOLUME_5_REF_3) {
596       return tokens.mul(3).div(100);
597     }
598 
599     return 0;
600   }
601 
602   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
603     require(ethUsdPrice > 0);
604     ethUsdRate = ethUsdPrice;
605   }
606 
607   function receiveBtcPrice(uint btcUsdPrice) external onlyBtcPriceProvider {
608     require(btcUsdPrice > 0);
609     btcUsdRate = btcUsdPrice;
610   }
611 
612   function setEthPriceProvider(address provider) external onlyOwner {
613     require(provider != 0x0);
614     ethPriceProvider = provider;
615   }
616 
617   function setBtcPriceProvider(address provider) external onlyOwner {
618     require(provider != 0x0);
619     btcPriceProvider = provider;
620   }
621 
622   function setNewWhiteList(address newWhiteList) external onlyOwner {
623     require(newWhiteList != 0x0);
624     investorWhiteList = InvestorWhiteList(newWhiteList);
625   }
626 
627   function doPurchase() private icoActive inNormalState {
628     require(!crowdsaleFinished);
629 
630     uint tokens = msg.value.mul(ethUsdRate).div(jcrUsdRate);
631     uint referralBonus = calculateReferralBonus(tokens);
632     address referral = investorWhiteList.getReferralOf(msg.sender);
633 
634     tokens = tokens.add(calculateBonus(tokens));
635 
636     uint newTokensSold = tokensSold.add(tokens);
637 
638     if (referralBonus > 0 && referral != 0x0) {
639       newTokensSold = newTokensSold.add(referralBonus);
640     }
641 
642     require(newTokensSold <= hardCap);
643 
644     if (!softCapReached && newTokensSold >= softCap) {
645       softCapReached = true;
646       SoftCapReached(softCap);
647     }
648 
649     collected = collected.add(msg.value);
650 
651     tokensSold = newTokensSold;
652 
653     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
654 
655     token.transfer(msg.sender, tokens);
656     NewContribution(msg.sender, tokens, msg.value);
657 
658     if (referralBonus > 0 && referral != 0x0) {
659       token.transfer(referral, referralBonus);
660       NewReferralTransfer(msg.sender, referral, referralBonus);
661     }
662   }
663 
664   function transferOwnership(address newOwner) onlyOwner icoEnded {
665     super.transferOwnership(newOwner);
666   }
667 }