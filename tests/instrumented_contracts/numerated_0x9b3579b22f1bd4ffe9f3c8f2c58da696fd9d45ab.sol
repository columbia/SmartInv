1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender)
134     public view returns (uint256);
135 
136   function transferFrom(address from, address to, uint256 value)
137     public returns (bool);
138 
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(
141     address indexed owner,
142     address indexed spender,
143     uint256 value
144   );
145 }
146 
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158 
159   /**
160   * @dev total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256) {
187     return balances[_owner];
188   }
189 
190 }
191 
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * @dev https://github.com/ethereum/EIPs/issues/20
198  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(
212     address _from,
213     address _to,
214     uint256 _value
215   )
216     public
217     returns (bool)
218   {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(
253     address _owner,
254     address _spender
255    )
256     public
257     view
258     returns (uint256)
259   {
260     return allowed[_owner][_spender];
261   }
262 
263   /**
264    * @dev Increase the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _addedValue The amount of tokens to increase the allowance by.
272    */
273   function increaseApproval(
274     address _spender,
275     uint _addedValue
276   )
277     public
278     returns (bool)
279   {
280     allowed[msg.sender][_spender] = (
281       allowed[msg.sender][_spender].add(_addedValue));
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(
297     address _spender,
298     uint _subtractedValue
299   )
300     public
301     returns (bool)
302   {
303     uint oldValue = allowed[msg.sender][_spender];
304     if (_subtractedValue > oldValue) {
305       allowed[msg.sender][_spender] = 0;
306     } else {
307       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308     }
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313 }
314 
315 
316 /**
317  * @title CryptualProjectToken
318  * @dev Official ERC20 token contract for the Cryptual Project.
319  * This contract includes both a presale and a crowdsale.
320  */
321 contract CryptualProjectToken is StandardToken, Ownable {
322   using SafeMath for uint256;
323 
324   // ERC20 optional details
325   string public constant name = "Cryptual Project Token"; // solium-disable-line uppercase
326   string public constant symbol = "CTL"; // solium-disable-line uppercase
327   uint8 public constant decimals = 0; // solium-disable-line uppercase
328 
329   // Token constants, variables
330   uint256 public constant INITIAL_SUPPLY = 2480000000;
331   address public wallet;
332 
333   // Private presale constants
334   uint256 public constant PRESALE_OPENING_TIME = 1535382000; // Mon, 27 Aug 2018 15:00:00 +0000
335   uint256 public constant PRESALE_CLOSING_TIME = 1536289200; // Fri, 07 Sep 2018 03:00:00 +0000
336   uint256 public constant PRESALE_RATE = 500000;
337   uint256 public constant PRESALE_WEI_CAP = 2500 ether;
338   uint256 public constant PRESALE_WEI_GOAL = 100 ether;
339 
340   // Public crowdsale constants
341   uint256 public constant CROWDSALE_OPENING_TIME = 1537542000; // Fri, 21 Sep 2018 15:00:00 +0000
342   uint256 public constant CROWDSALE_CLOSING_TIME = 1545361200; // Fri, 21 Dec 2018 03:00:00 +0000
343   uint256 public constant CROWDSALE_WEI_CAP = 20000 ether;
344   uint256 public constant CROWDSALE_WEI_GOAL = 800 ether;
345 
346   // Public crowdsale parameters
347   uint256[] public crowdsaleWeiAvailableLevels = [2500 ether, 5000 ether, 12500 ether];
348   uint256[] public crowdsaleRates = [400000, 300000, 200000];
349   uint256[] public crowdsaleMinElapsedTimeLevels = [0, 12 * 3600, 18 * 3600, 21 * 3600, 22 * 3600];
350   uint256[] public crowdsaleUserCaps = [1 ether, 2 ether, 4 ether, 8 ether, CROWDSALE_WEI_CAP];
351   mapping(address => uint256) public crowdsaleContributions;
352 
353   // Amount of wei raised for each token sale stage
354   uint256 public presaleWeiRaised;
355   uint256 public crowdsaleWeiRaised;
356 
357   /**
358    * @dev Constructor that sends msg.sender the initial token supply
359    */
360   constructor(
361     address _wallet
362   ) public {
363     require(_wallet != address(0));
364     wallet = _wallet;
365 
366     totalSupply_ = INITIAL_SUPPLY;
367     balances[msg.sender] = INITIAL_SUPPLY;
368     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
369   }
370 
371   /**
372    * Event for token purchase logging
373    * @param purchaser who paid for the tokens
374    * @param beneficiary who got the tokens
375    * @param value weis paid for purchase
376    * @param amount amount of tokens purchased
377    */
378   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
379 
380   /**
381    * @dev fallback token purchase function
382    */
383   function () external payable {
384     buyTokens(msg.sender);
385   }
386 
387   /**
388    * @dev token purchase function
389    * @param _beneficiary Address performing the token purchase
390    */
391   function buyTokens(address _beneficiary) public payable {
392 
393     uint256 weiAmount = msg.value;
394     require(_beneficiary != address(0));
395     require(weiAmount != 0);
396     bool isPresale = block.timestamp >= PRESALE_OPENING_TIME && block.timestamp <= PRESALE_CLOSING_TIME && presaleWeiRaised.add(weiAmount) <= PRESALE_WEI_CAP;
397     bool isCrowdsale = block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME && presaleGoalReached() && crowdsaleWeiRaised.add(weiAmount) <= CROWDSALE_WEI_CAP;
398     uint256 tokens;
399 
400     if (isCrowdsale) {
401       require(crowdsaleContributions[_beneficiary].add(weiAmount) <= getCrowdsaleUserCap());
402       
403       // calculate token amount to be created
404       tokens = _getCrowdsaleTokenAmount(weiAmount);
405       require(tokens != 0);
406 
407       // update state
408       crowdsaleWeiRaised = crowdsaleWeiRaised.add(weiAmount);
409     } else if (isPresale) {
410       require(whitelist[_beneficiary]);
411       
412       // calculate token amount to be created
413       tokens = weiAmount.mul(PRESALE_RATE).div(1 ether);
414       require(tokens != 0);
415 
416       // update state
417       presaleWeiRaised = presaleWeiRaised.add(weiAmount);
418     } else {
419       revert();
420     }
421 
422     _processPurchase(_beneficiary, tokens);
423     emit TokenPurchase(
424       msg.sender,
425       _beneficiary,
426       weiAmount,
427       tokens
428     );
429 
430     if (isCrowdsale) {
431       crowdsaleContributions[_beneficiary] = crowdsaleContributions[_beneficiary].add(weiAmount);
432       crowdsaleDeposited[_beneficiary] = crowdsaleDeposited[_beneficiary].add(msg.value);
433     } else if (isPresale) {
434       presaleDeposited[_beneficiary] = presaleDeposited[_beneficiary].add(msg.value);
435     }
436   }
437 
438   /**
439    * @dev Returns the current contribution cap per user in wei.
440    * Note that this cap in changes with time.
441    * @return The maximum wei a user may contribute in total
442    */
443   function getCrowdsaleUserCap() public view returns (uint256) {
444     require(block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME);
445     // solium-disable-next-line security/no-block-members
446     uint256 elapsedTime = block.timestamp.sub(CROWDSALE_OPENING_TIME);
447     uint256 currentMinElapsedTime = 0;
448     uint256 currentCap = 0;
449 
450     for (uint i = 0; i < crowdsaleUserCaps.length; i++) {
451       if (elapsedTime < crowdsaleMinElapsedTimeLevels[i]) continue;
452       if (crowdsaleMinElapsedTimeLevels[i] < currentMinElapsedTime) continue;
453       currentCap = crowdsaleUserCaps[i];
454     }
455 
456     return currentCap;
457   }
458 
459   /**
460    * @dev Function to compute output tokens from input wei
461    * @param _weiAmount The value in wei to be converted into tokens
462    * @return The number of tokens _weiAmount wei will buy at present time
463    */
464   function _getCrowdsaleTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
465     uint256 uncountedWeiRaised = crowdsaleWeiRaised;
466     uint256 uncountedWeiAmount = _weiAmount;
467     uint256 tokenAmount = 0;
468 
469     for (uint i = 0; i < crowdsaleWeiAvailableLevels.length; i++) {
470       uint256 weiAvailable = crowdsaleWeiAvailableLevels[i];
471       uint256 rate = crowdsaleRates[i];
472       
473       if (uncountedWeiRaised < weiAvailable) {
474         if (uncountedWeiRaised > 0) {
475           weiAvailable = weiAvailable.sub(uncountedWeiRaised);
476           uncountedWeiRaised = 0;
477         }
478 
479         if (uncountedWeiAmount <= weiAvailable) {
480           tokenAmount = tokenAmount.add(uncountedWeiAmount.mul(rate));
481           break;
482         } else {
483           uncountedWeiAmount = uncountedWeiAmount.sub(weiAvailable);
484           tokenAmount = tokenAmount.add(weiAvailable.mul(rate));
485         }
486       } else {
487         uncountedWeiRaised = uncountedWeiRaised.sub(weiAvailable);
488       }
489     }
490 
491     return tokenAmount.div(1 ether);
492   }
493 
494   /**
495    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
496    * @param _beneficiary Address receiving the tokens
497    * @param _tokenAmount Number of tokens to be purchased
498    */
499   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
500     totalSupply_ = totalSupply_.add(_tokenAmount);
501     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
502     emit Transfer(0x0, _beneficiary, _tokenAmount);
503   }
504   
505   // Private presale buyer whitelist
506   mapping(address => bool) public whitelist;
507 
508   /**
509    * @dev Adds single address to whitelist.
510    * @param _beneficiary Address to be added to the whitelist
511    */
512   function addToPresaleWhitelist(address _beneficiary) external onlyOwner {
513     whitelist[_beneficiary] = true;
514   }
515 
516   /**
517    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
518    * @param _beneficiaries Addresses to be added to the whitelist
519    */
520   function addManyToPresaleWhitelist(address[] _beneficiaries) external onlyOwner {
521     for (uint256 i = 0; i < _beneficiaries.length; i++) {
522       whitelist[_beneficiaries[i]] = true;
523     }
524   }
525 
526   /**
527    * @dev Removes single address from whitelist.
528    * @param _beneficiary Address to be removed to the whitelist
529    */
530   function removeFromPresaleWhitelist(address _beneficiary) external onlyOwner {
531     whitelist[_beneficiary] = false;
532   }
533 
534   // Crowdsale finalization/refunding variables
535   bool public isPresaleFinalized = false;
536   bool public isCrowdsaleFinalized = false;
537   mapping (address => uint256) public presaleDeposited;
538   mapping (address => uint256) public crowdsaleDeposited;
539 
540   // Crowdsale finalization/refunding events
541   event PresaleFinalized();
542   event CrowdsaleFinalized();
543   event RefundsEnabled();
544   event Refunded(address indexed beneficiary, uint256 weiAmount);
545 
546   /**
547    * @dev Must be called after presale ends, to do some extra finalization (forwarding/refunding) work.
548    */
549   function finalizePresale() external {
550     require(!isPresaleFinalized);
551     require(block.timestamp > PRESALE_CLOSING_TIME);
552 
553     if (presaleGoalReached()) {
554       wallet.transfer(address(this).balance > presaleWeiRaised ? presaleWeiRaised : address(this).balance);
555     } else {
556       emit RefundsEnabled();
557     }
558 
559     emit PresaleFinalized();
560     isPresaleFinalized = true;
561   }
562 
563   /**
564    * @dev Must be called after crowdsale ends, to do some extra finalization (forwarding/refunding) work.
565    */
566   function finalizeCrowdsale() external {
567     require(isPresaleFinalized && presaleGoalReached());
568     require(!isCrowdsaleFinalized);
569     require(block.timestamp > CROWDSALE_CLOSING_TIME);
570 
571     if (crowdsaleGoalReached()) {
572       wallet.transfer(address(this).balance);
573     } else {
574       emit RefundsEnabled();
575     }
576 
577     emit CrowdsaleFinalized();
578     isCrowdsaleFinalized = true;
579   }
580 
581   /**
582    * @dev Investors can claim refunds here if presale/crowdsale is unsuccessful
583    */
584   function claimRefund() external {
585     uint256 depositedValue = 0;
586 
587     if (isCrowdsaleFinalized && !crowdsaleGoalReached()) {
588       require(crowdsaleDeposited[msg.sender] > 0);
589       depositedValue = crowdsaleDeposited[msg.sender];
590       crowdsaleDeposited[msg.sender] = 0;
591     } else if (isPresaleFinalized && !presaleGoalReached()) {
592       require(presaleDeposited[msg.sender] > 0);
593       depositedValue = presaleDeposited[msg.sender];
594       presaleDeposited[msg.sender] = 0;
595     }
596 
597     require(depositedValue > 0);
598     msg.sender.transfer(depositedValue);
599     emit Refunded(msg.sender, depositedValue);
600   }
601 
602   /**
603    * @dev Checks whether presale funding goal was reached.
604    * @return Whether presale funding goal was reached
605    */
606   function presaleGoalReached() public view returns (bool) {
607     return presaleWeiRaised >= PRESALE_WEI_GOAL;
608   }
609 
610   /**
611    * @dev Checks whether crowdsale funding goal was reached.
612    * @return Whether crowdsale funding goal was reached
613    */
614   function crowdsaleGoalReached() public view returns (bool) {
615     return crowdsaleWeiRaised >= CROWDSALE_WEI_GOAL;
616   }
617 
618 }