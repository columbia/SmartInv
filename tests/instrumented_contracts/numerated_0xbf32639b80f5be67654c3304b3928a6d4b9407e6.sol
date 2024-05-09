1 pragma solidity 0.4.20;
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
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0;
99     }
100     uint256 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     // assert(b > 0); // Solidity automatically throws when dividing by 0
110     uint256 c = a / b;
111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112     return c;
113   }
114 
115   /**
116   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     // SafeMath.sub will throw if there is not enough balance.
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256 balance) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 /**
297  * @title Mintable token
298  * @dev Simple ERC20 Token example, with mintable token creation
299  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
300  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
301  */
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply_ = totalSupply_.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     Mint(_to, _amount);
324     Transfer(address(0), _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner canMint public returns (bool) {
333     mintingFinished = true;
334     MintFinished();
335     return true;
336   }
337 }
338 
339 /**
340  * @title StarCoin
341  *
342  * @dev Burnable Ownable ERC20 token
343  */
344 contract StarCoin is MintableToken {
345 
346   string public constant name = "StarCoin";
347   string public constant symbol = "STAR";
348   uint8 public constant decimals = 18;
349   uint public constant INITIAL_SUPPLY = 40000000 * 1 ether; //40M tokens accroding to https://starflow.com/ico/
350   uint public constant MAXIMUM_SUPPLY = 100000000 * 1 ether; // 100M tokens is maximum according to https://starflow.com/ico/
351 
352   /* The finalizer contract that allows unlift the transfer limits on this token */
353   address public releaseAgent;
354 
355   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
356   bool public released = false;
357 
358   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
359   mapping (address => bool) public transferAgents;
360 
361   /**
362    * Limit token transfer until the crowdsale is over.
363    *
364    */
365   modifier canTransfer(address _sender) {
366     require(released || transferAgents[_sender]);
367     _;
368   }
369 
370   /** The function can be called only before or after the tokens have been released */
371   modifier inReleaseState(bool releaseState) {
372     require(releaseState == released);
373     _;
374   }
375 
376   /** The function can be called only by a whitelisted release agent. */
377   modifier onlyReleaseAgent() {
378     require(msg.sender == releaseAgent);
379     _;
380   }
381 
382   /** Restrict minting by the MAXIMUM_SUPPLY allowed **/
383   modifier bellowMaximumSupply(uint _amount) {
384     require(_amount + totalSupply_ < MAXIMUM_SUPPLY);
385     _;
386   }
387 
388 
389   /**
390    * @dev Constructor that gives msg.sender all of existing tokens.
391    */
392   function StarCoin() {
393     totalSupply_ = INITIAL_SUPPLY;
394     balances[msg.sender] = INITIAL_SUPPLY;
395   }
396 
397 
398   /**
399    * Set the contract that can call release and make the token transferable.
400    *
401    * Design choice. Allow reset the release agent to fix fat finger mistakes.
402    */
403   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
404     require(addr != 0x0);
405 
406     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
407     releaseAgent = addr;
408   }
409 
410   function release() onlyReleaseAgent inReleaseState(false) public {
411     released = true;
412   }
413 
414   /**
415    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
416    */
417   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
418     require(addr != 0x0);
419     transferAgents[addr] = state;
420   }
421 
422   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
423     // Call Burnable.transfer()
424     return super.transfer(_to, _value);
425   }
426 
427   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
428     // Call Burnable.transferForm()
429     return super.transferFrom(_from, _to, _value);
430   }
431 
432     /**
433    * @dev Function to mint tokens
434    * @param _to The address that will receive the minted tokens.
435    * @param _amount The amount of tokens to mint.
436    * @return A boolean that indicates if the operation was successful.
437    */
438   function mint(address _to, uint _amount) onlyOwner canMint bellowMaximumSupply(_amount) public returns (bool) {
439     return super.mint(_to, _amount);
440   }
441 
442   /**
443    * @dev Function to stop minting new tokens.
444    * @return True if the operation was successful.
445    */
446   function finishMinting() onlyOwner canMint public returns (bool) {
447     return super.finishMinting();
448   }
449 
450 
451 }
452 
453 contract InvestorWhiteList is Ownable {
454   mapping (address => bool) public investorWhiteList;
455 
456   mapping (address => address) public referralList;
457 
458   function InvestorWhiteList() {
459 
460   }
461 
462   function addInvestorToWhiteList(address investor) external onlyOwner {
463     require(investor != 0x0 && !investorWhiteList[investor]);
464     investorWhiteList[investor] = true;
465   }
466 
467   function removeInvestorFromWhiteList(address investor) external onlyOwner {
468     require(investor != 0x0 && investorWhiteList[investor]);
469     investorWhiteList[investor] = false;
470   }
471 
472   //when new user will contribute ICO contract will automatically send bonus to referral
473   function addReferralOf(address investor, address referral) external onlyOwner {
474     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
475     referralList[investor] = referral;
476   }
477 
478   function isAllowed(address investor) constant external returns (bool result) {
479     return investorWhiteList[investor];
480   }
481 
482   function getReferralOf(address investor) constant external returns (address result) {
483     return referralList[investor];
484   }
485 }
486 
487 contract StarCoinPreSale is Pausable {
488   using SafeMath for uint;
489 
490   string public constant name = "StarCoin Token ICO";
491 
492   StarCoin public token;
493 
494   address public beneficiary;
495 
496   InvestorWhiteList public investorWhiteList;
497 
498   uint public starEthRate;
499 
500   uint public hardCap;
501 
502   uint public softCap;
503 
504   uint public collected = 0;
505 
506   uint public tokensSold = 0;
507 
508   uint public weiRefunded = 0;
509 
510   uint public startBlock;
511 
512   uint public endBlock;
513 
514   bool public softCapReached = false;
515 
516   bool public crowdsaleFinished = false;
517 
518   mapping (address => uint) public deposited;
519 
520   uint constant VOLUME_20_REF_7 = 5000 ether;
521 
522   uint constant VOLUME_15_REF_6 = 2000 ether;
523 
524   uint constant VOLUME_12d5_REF_5d5 = 1000 ether;
525 
526   uint constant VOLUME_10_REF_5 = 500 ether;
527 
528   uint constant VOLUME_7_REF_4 = 250 ether;
529 
530   uint constant VOLUME_5_REF_3 = 100 ether;
531 
532   event SoftCapReached(uint softCap);
533 
534   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
535 
536   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
537 
538   event Refunded(address indexed holder, uint amount);
539 
540   modifier icoActive() {
541     require(block.number >= startBlock && block.number < endBlock);
542     _;
543   }
544 
545   modifier icoEnded() {
546     require(block.number >= endBlock);
547     _;
548   }
549 
550   modifier minInvestment() {
551     require(msg.value >= 0.1 * 1 ether);
552     _;
553   }
554 
555   modifier inWhiteList() {
556     require(investorWhiteList.isAllowed(msg.sender));
557     _;
558   }
559 
560   function StarCoinPreSale(
561     uint _hardCapSTAR,
562     uint _softCapSTAR,
563     address _token,
564     address _beneficiary,
565     address _investorWhiteList,
566     uint _baseStarEthPrice,
567 
568     uint _startBlock,
569     uint _endBlock
570   ) {
571     hardCap = _hardCapSTAR.mul(1 ether);
572     softCap = _softCapSTAR.mul(1 ether);
573 
574     token = StarCoin(_token);
575     beneficiary = _beneficiary;
576     investorWhiteList = InvestorWhiteList(_investorWhiteList);
577 
578     startBlock = _startBlock;
579     endBlock = _endBlock;
580 
581     starEthRate = _baseStarEthPrice;
582   }
583 
584   function() payable minInvestment inWhiteList {
585     doPurchase();
586   }
587 
588   function refund() external icoEnded {
589     require(softCapReached == false);
590     require(deposited[msg.sender] > 0);
591 
592     uint refund = deposited[msg.sender];
593 
594     deposited[msg.sender] = 0;
595     msg.sender.transfer(refund);
596 
597     weiRefunded = weiRefunded.add(refund);
598     Refunded(msg.sender, refund);
599   }
600 
601   function withdraw() external onlyOwner {
602     require(softCapReached);
603     beneficiary.transfer(collected);
604     token.transfer(beneficiary, token.balanceOf(this));
605     crowdsaleFinished = true;
606   }
607 
608   function calculateBonus(uint tokens) internal constant returns (uint bonus) {
609     if (msg.value >= VOLUME_20_REF_7) {
610       return tokens.mul(20).div(100);
611     }
612 
613     if (msg.value >= VOLUME_15_REF_6) {
614       return tokens.mul(15).div(100);
615     }
616 
617     if (msg.value >= VOLUME_12d5_REF_5d5) {
618       return tokens.mul(125).div(1000);
619     }
620 
621     if (msg.value >= VOLUME_10_REF_5) {
622       return tokens.mul(10).div(100);
623     }
624 
625     if (msg.value >= VOLUME_7_REF_4) {
626       return tokens.mul(7).div(100);
627     }
628 
629     if (msg.value >= VOLUME_5_REF_3) {
630       return tokens.mul(5).div(100);
631     }
632 
633     return 0;
634   }
635 
636   function calculateReferralBonus(uint tokens) internal constant returns (uint bonus) {
637     if (msg.value >= VOLUME_20_REF_7) {
638       return tokens.mul(7).div(100);
639     }
640 
641     if (msg.value >= VOLUME_15_REF_6) {
642       return tokens.mul(6).div(100);
643     }
644 
645     if (msg.value >= VOLUME_12d5_REF_5d5) {
646       return tokens.mul(55).div(1000);
647     }
648 
649     if (msg.value >= VOLUME_10_REF_5) {
650       return tokens.mul(5).div(100);
651     }
652 
653     if (msg.value >= VOLUME_7_REF_4) {
654       return tokens.mul(4).div(100);
655     }
656 
657     if (msg.value >= VOLUME_5_REF_3) {
658       return tokens.mul(3).div(100);
659     }
660 
661     return 0;
662   }
663 
664   function setNewWhiteList(address newWhiteList) external onlyOwner {
665     require(newWhiteList != 0x0);
666     investorWhiteList = InvestorWhiteList(newWhiteList);
667   }
668 
669   function doPurchase() private icoActive whenNotPaused {
670     require(!crowdsaleFinished);
671 
672     uint tokens = msg.value.mul(starEthRate);
673     uint referralBonus = calculateReferralBonus(tokens);
674     address referral = investorWhiteList.getReferralOf(msg.sender);
675 
676     tokens = tokens.add(calculateBonus(tokens));
677 
678     uint newTokensSold = tokensSold.add(tokens);
679 
680     if (referralBonus > 0 && referral != 0x0) {
681       newTokensSold = newTokensSold.add(referralBonus);
682     }
683 
684     require(newTokensSold <= hardCap);
685 
686     if (!softCapReached && newTokensSold >= softCap) {
687       softCapReached = true;
688       SoftCapReached(softCap);
689     }
690 
691     collected = collected.add(msg.value);
692 
693     tokensSold = newTokensSold;
694 
695     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
696 
697     token.transfer(msg.sender, tokens);
698     NewContribution(msg.sender, tokens, msg.value);
699 
700     if (referralBonus > 0 && referral != 0x0) {
701       token.transfer(referral, referralBonus);
702       NewReferralTransfer(msg.sender, referral, referralBonus);
703     }
704   }
705 
706   function transferOwnership(address newOwner) onlyOwner icoEnded {
707     super.transferOwnership(newOwner);
708   }
709 }