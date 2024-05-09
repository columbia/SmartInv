1 pragma solidity ^0.4.23;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
176 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
197 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
321 // File: contracts/CryptualProjectToken.sol
322 
323 /**
324  * @title CryptualProjectToken
325  * @dev Official ERC20 token contract for the Cryptual Project.
326  * This contract includes both a presale and a crowdsale.
327  */
328 contract CryptualProjectToken is StandardToken, Ownable {
329   using SafeMath for uint256;
330 
331   // ERC20 optional details
332   string public constant name = "Cryptual Project Token"; // solium-disable-line uppercase
333   string public constant symbol = "CPT"; // solium-disable-line uppercase
334   uint8 public constant decimals = 0; // solium-disable-line uppercase
335 
336   // Token constants, variables
337   uint256 public constant INITIAL_SUPPLY = 283000000;
338   address public wallet;
339 
340   // Private presale constants
341   uint256 public constant PRESALE_OPENING_TIME = 1533726000; // Wed, 08 Aug 2018 11:00:00 +0000
342   uint256 public constant PRESALE_CLOSING_TIME = 1534291200; // Wed, 15 Aug 2018 00:00:00 +0000
343   uint256 public constant PRESALE_RATE = 150000;
344   uint256 public constant PRESALE_WEI_CAP = 500 ether;
345   uint256 public constant PRESALE_WEI_GOAL = 50 ether;
346 
347   // Public crowdsale constants
348   uint256 public constant CROWDSALE_OPENING_TIME = 1534935600; // Wed, 22 Aug 2018 11:00:00 +0000
349   uint256 public constant CROWDSALE_CLOSING_TIME = 1540166400; // Mon, 22 Oct 2018 00:00:00 +0000
350   uint256 public constant CROWDSALE_WEI_CAP = 5000 ether;
351 
352   // Combined wei goal for both token sale stages
353   uint256 public constant COMBINED_WEI_GOAL = 750 ether;
354 
355   // Public crowdsale parameters
356   uint256[] public crowdsaleWeiAvailableLevels = [1000 ether, 1500 ether, 2000 ether];
357   uint256[] public crowdsaleRates = [135000, 120000, 100000];
358   uint256[] public crowdsaleMinElapsedTimeLevels = [0, 12 * 3600, 18 * 3600, 21 * 3600, 22 * 3600];
359   uint256[] public crowdsaleUserCaps = [1 ether, 2 ether, 4 ether, 8 ether, CROWDSALE_WEI_CAP];
360   mapping(address => uint256) public crowdsaleContributions;
361 
362   // Amount of wei raised for each token sale stage
363   uint256 public presaleWeiRaised;
364   uint256 public crowdsaleWeiRaised;
365 
366   /**
367    * @dev Constructor that sends msg.sender the initial token supply
368    */
369   constructor(
370     address _wallet
371   ) public {
372     require(_wallet != address(0));
373     wallet = _wallet;
374 
375     totalSupply_ = INITIAL_SUPPLY;
376     balances[msg.sender] = INITIAL_SUPPLY;
377     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
378   }
379 
380   /**
381    * Event for token purchase logging
382    * @param purchaser who paid for the tokens
383    * @param beneficiary who got the tokens
384    * @param value weis paid for purchase
385    * @param amount amount of tokens purchased
386    */
387   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
388 
389   /**
390    * @dev fallback token purchase function
391    */
392   function () external payable {
393     buyTokens(msg.sender);
394   }
395 
396   /**
397    * @dev token purchase function
398    * @param _beneficiary Address performing the token purchase
399    */
400   function buyTokens(address _beneficiary) public payable {
401 
402     uint256 weiAmount = msg.value;
403     require(_beneficiary != address(0));
404     require(weiAmount != 0);
405     bool isPresale = block.timestamp >= PRESALE_OPENING_TIME && block.timestamp <= PRESALE_CLOSING_TIME && presaleWeiRaised.add(weiAmount) <= PRESALE_WEI_CAP;
406     bool isCrowdsale = block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME && presaleGoalReached() && crowdsaleWeiRaised.add(weiAmount) <= CROWDSALE_WEI_CAP;
407     uint256 tokens;
408 
409     if (isCrowdsale) {
410       require(crowdsaleContributions[_beneficiary].add(weiAmount) <= getCrowdsaleUserCap());
411       
412       // calculate token amount to be created
413       tokens = _getCrowdsaleTokenAmount(weiAmount);
414       require(tokens != 0);
415 
416       // update state
417       crowdsaleWeiRaised = crowdsaleWeiRaised.add(weiAmount);
418     } else if (isPresale) {
419       require(whitelist[_beneficiary]);
420       
421       // calculate token amount to be created
422       tokens = weiAmount.mul(PRESALE_RATE).div(1 ether);
423       require(tokens != 0);
424 
425       // update state
426       presaleWeiRaised = presaleWeiRaised.add(weiAmount);
427     } else {
428       revert();
429     }
430 
431     _processPurchase(_beneficiary, tokens);
432     emit TokenPurchase(
433       msg.sender,
434       _beneficiary,
435       weiAmount,
436       tokens
437     );
438 
439     if (isCrowdsale) {
440       crowdsaleContributions[_beneficiary] = crowdsaleContributions[_beneficiary].add(weiAmount);
441       crowdsaleDeposited[_beneficiary] = crowdsaleDeposited[_beneficiary].add(msg.value);
442     } else if (isPresale) {
443       presaleDeposited[_beneficiary] = presaleDeposited[_beneficiary].add(msg.value);
444     }
445   }
446 
447   /**
448    * @dev Returns the current contribution cap per user in wei.
449    * Note that this cap in changes with time.
450    * @return The maximum wei a user may contribute in total
451    */
452   function getCrowdsaleUserCap() public view returns (uint256) {
453     require(block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME);
454     // solium-disable-next-line security/no-block-members
455     uint256 elapsedTime = block.timestamp.sub(CROWDSALE_OPENING_TIME);
456     uint256 currentMinElapsedTime = 0;
457     uint256 currentCap = 0;
458 
459     for (uint i = 0; i < crowdsaleUserCaps.length; i++) {
460       if (elapsedTime < crowdsaleMinElapsedTimeLevels[i]) continue;
461       if (crowdsaleMinElapsedTimeLevels[i] < currentMinElapsedTime) continue;
462       currentCap = crowdsaleUserCaps[i];
463     }
464 
465     return currentCap;
466   }
467 
468   /**
469    * @dev Function to compute output tokens from input wei
470    * @param _weiAmount The value in wei to be converted into tokens
471    * @return The number of tokens _weiAmount wei will buy at present time
472    */
473   function _getCrowdsaleTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
474     uint256 uncountedWeiRaised = crowdsaleWeiRaised;
475     uint256 uncountedWeiAmount = _weiAmount;
476     uint256 tokenAmount = 0;
477 
478     for (uint i = 0; i < crowdsaleWeiAvailableLevels.length; i++) {
479       uint256 weiAvailable = crowdsaleWeiAvailableLevels[i];
480       uint256 rate = crowdsaleRates[i];
481       
482       if (uncountedWeiRaised < weiAvailable) {
483         if (uncountedWeiRaised > 0) {
484           weiAvailable = weiAvailable.sub(uncountedWeiRaised);
485           uncountedWeiRaised = 0;
486         }
487 
488         if (uncountedWeiAmount <= weiAvailable) {
489           tokenAmount = tokenAmount.add(uncountedWeiAmount.mul(rate));
490           break;
491         } else {
492           uncountedWeiAmount = uncountedWeiAmount.sub(weiAvailable);
493           tokenAmount = tokenAmount.add(weiAvailable.mul(rate));
494         }
495       } else {
496         uncountedWeiRaised = uncountedWeiRaised.sub(weiAvailable);
497       }
498     }
499 
500     return tokenAmount.div(1 ether);
501   }
502 
503   /**
504    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
505    * @param _beneficiary Address receiving the tokens
506    * @param _tokenAmount Number of tokens to be purchased
507    */
508   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
509     totalSupply_ = totalSupply_.add(_tokenAmount);
510     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
511     emit Transfer(0x0, _beneficiary, _tokenAmount);
512   }
513   
514   // Private presale buyer whitelist
515   mapping(address => bool) public whitelist;
516 
517   /**
518    * @dev Adds single address to whitelist.
519    * @param _beneficiary Address to be added to the whitelist
520    */
521   function addToPresaleWhitelist(address _beneficiary) external onlyOwner {
522     whitelist[_beneficiary] = true;
523   }
524 
525   /**
526    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
527    * @param _beneficiaries Addresses to be added to the whitelist
528    */
529   function addManyToPresaleWhitelist(address[] _beneficiaries) external onlyOwner {
530     for (uint256 i = 0; i < _beneficiaries.length; i++) {
531       whitelist[_beneficiaries[i]] = true;
532     }
533   }
534 
535   /**
536    * @dev Removes single address from whitelist.
537    * @param _beneficiary Address to be removed to the whitelist
538    */
539   function removeFromPresaleWhitelist(address _beneficiary) external onlyOwner {
540     whitelist[_beneficiary] = false;
541   }
542 
543   // Crowdsale finalization/refunding variables
544   bool public isPresaleFinalized = false;
545   bool public isCrowdsaleFinalized = false;
546   mapping (address => uint256) public presaleDeposited;
547   mapping (address => uint256) public crowdsaleDeposited;
548 
549   // Crowdsale finalization/refunding events
550   event PresaleFinalized();
551   event CrowdsaleFinalized();
552   event RefundsEnabled();
553   event Refunded(address indexed beneficiary, uint256 weiAmount);
554 
555   /**
556    * @dev Must be called after presale ends, to do some extra finalization (forwarding/refunding) work.
557    */
558   function finalizePresale() external {
559     require(!isPresaleFinalized);
560     require(block.timestamp > PRESALE_CLOSING_TIME);
561 
562     if (presaleGoalReached()) {
563       wallet.transfer(address(this).balance > presaleWeiRaised ? presaleWeiRaised : address(this).balance);
564     } else {
565       emit RefundsEnabled();
566     }
567 
568     emit PresaleFinalized();
569     isPresaleFinalized = true;
570   }
571 
572   /**
573    * @dev Must be called after crowdsale ends, to do some extra finalization (forwarding/refunding) work.
574    */
575   function finalizeCrowdsale() external {
576     require(isPresaleFinalized && presaleGoalReached());
577     require(!isCrowdsaleFinalized);
578     require(block.timestamp > CROWDSALE_CLOSING_TIME);
579 
580     if (combinedGoalReached()) {
581       wallet.transfer(address(this).balance);
582     } else {
583       emit RefundsEnabled();
584     }
585 
586     emit CrowdsaleFinalized();
587     isCrowdsaleFinalized = true;
588   }
589 
590   /**
591    * @dev Investors can claim refunds here if presale/crowdsale is unsuccessful
592    */
593   function claimRefund() external {
594     uint256 depositedValue = 0;
595 
596     if (isCrowdsaleFinalized && !combinedGoalReached()) {
597       require(crowdsaleDeposited[msg.sender] > 0);
598       depositedValue = crowdsaleDeposited[msg.sender];
599       crowdsaleDeposited[msg.sender] = 0;
600     } else if (isPresaleFinalized && !presaleGoalReached()) {
601       require(presaleDeposited[msg.sender] > 0);
602       depositedValue = presaleDeposited[msg.sender];
603       presaleDeposited[msg.sender] = 0;
604     }
605 
606     require(depositedValue > 0);
607     msg.sender.transfer(depositedValue);
608     emit Refunded(msg.sender, depositedValue);
609   }
610 
611   /**
612    * @dev Checks whether presale funding goal was reached.
613    * @return Whether presale funding goal was reached
614    */
615   function presaleGoalReached() public view returns (bool) {
616     return presaleWeiRaised >= PRESALE_WEI_GOAL;
617   }
618 
619   /**
620    * @dev Checks whether total funding goal was reached.
621    * @return Whether total funding goal was reached
622    */
623   function combinedGoalReached() public view returns (bool) {
624     return presaleWeiRaised.add(crowdsaleWeiRaised) >= COMBINED_WEI_GOAL;
625   }
626 
627 }