1 pragma solidity ^0.4.18;
2 
3 // File: contracts/IPricingStrategy.sol
4 
5 interface IPricingStrategy {
6 
7     function isPricingStrategy() public view returns (bool);
8 
9     /** Calculate the current price for buy in amount. */
10     function calculateTokenAmount(uint weiAmount, uint tokensSold) public view returns (uint tokenAmount);
11 
12 }
13 
14 // File: contracts/token/ERC223.sol
15 
16 contract ERC223 {
17     function transfer(address _to, uint _value, bytes _data) public returns (bool);
18     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool);
19     
20     event Transfer(address indexed from, address indexed to, uint value, bytes data);
21 }
22 
23 // File: zeppelin-solidity/contracts/math/SafeMath.sol
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   function Ownable() public {
77     owner = msg.sender;
78   }
79 
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89 
90   /**
91    * @dev Allows the current owner to transfer control of the contract to a newOwner.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     require(newOwner != address(0));
96     OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100 }
101 
102 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
103 
104 /**
105  * @title Contactable token
106  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
107  * contact information.
108  */
109 contract Contactable is Ownable{
110 
111     string public contactInformation;
112 
113     /**
114      * @dev Allows the owner to set a string with their contact information.
115      * @param info The contact information to attach to the contract.
116      */
117     function setContactInformation(string info) onlyOwner public {
118          contactInformation = info;
119      }
120 }
121 
122 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   uint256 public totalSupply;
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public view returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 // File: contracts/token/MintableToken.sol
150 
151 contract MintableToken is ERC20, Contactable {
152     using SafeMath for uint;
153 
154     mapping (address => uint) balances;
155     mapping (address => uint) public holderGroup;
156     bool public mintingFinished = false;
157     address public minter;
158 
159     event MinterChanged(address indexed previousMinter, address indexed newMinter);
160     event Mint(address indexed to, uint amount);
161     event MintFinished();
162 
163     modifier canMint() {
164         require(!mintingFinished);
165         _;
166     }
167 
168     modifier onlyMinter() {
169         require(msg.sender == minter);
170         _;
171     }
172 
173       /**
174      * @dev Function to mint tokens
175      * @param _to The address that will receive the minted tokens.
176      * @param _amount The amount of tokens to mint.
177      * @return A boolean that indicates if the operation was successful.
178      */
179     function mint(address _to, uint _amount, uint _holderGroup) onlyMinter canMint public returns (bool) {
180         totalSupply = totalSupply.add(_amount);
181         balances[_to] = balances[_to].add(_amount);
182         holderGroup[_to] = _holderGroup;
183         Mint(_to, _amount);
184         Transfer(address(0), _to, _amount);
185         return true;
186     }
187 
188     /**
189      * @dev Function to stop minting new tokens.
190      * @return True if the operation was successful.
191      */
192     function finishMinting() onlyMinter canMint public returns (bool) {
193         mintingFinished = true;
194         MintFinished();
195         return true;
196     }
197 
198     function changeMinter(address _minter) external onlyOwner {
199         require(_minter != 0x0);
200         MinterChanged(minter, _minter);
201         minter = _minter;
202     }
203 }
204 
205 // File: contracts/token/TokenReciever.sol
206 
207 /*
208  * Contract that is working with ERC223 tokens
209  */
210  
211  contract TokenReciever {
212     function tokenFallback(address _from, uint _value, bytes _data) public pure {
213     }
214 }
215 
216 // File: contracts/token/HeroCoin.sol
217 
218 contract HeroCoin is ERC223, MintableToken {
219     using SafeMath for uint;
220 
221     string constant public name = "HeroCoin";
222     string constant public symbol = "HRO";
223     uint constant public decimals = 18;
224 
225     mapping(address => mapping (address => uint)) internal allowed;
226 
227     mapping (uint => uint) public activationTime;
228 
229     modifier activeForHolder(address holder) {
230         uint group = holderGroup[holder];
231         require(activationTime[group] <= now);
232         _;
233     }
234 
235     /**
236     * @dev transfer token for a specified address
237     * @param _to The address to transfer to.
238     * @param _value The amount to be transferred.
239     */
240     function transfer(address _to, uint _value) public returns (bool) {
241         bytes memory empty;
242         return transfer(_to, _value, empty);
243     }
244 
245     /**
246     * @dev transfer token for a specified address
247     * @param _to The address to transfer to.
248     * @param _value The amount to be transferred.
249     * @param _data Optional metadata.
250     */
251     function transfer(address _to, uint _value, bytes _data) public activeForHolder(msg.sender) returns (bool) {
252         require(_to != address(0));
253         require(_value <= balances[msg.sender]);
254 
255         // SafeMath.sub will throw if there is not enough balance.
256         balances[msg.sender] = balances[msg.sender].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258 
259         if (isContract(_to)) {
260             TokenReciever receiver = TokenReciever(_to);
261             receiver.tokenFallback(msg.sender, _value, _data);
262         }
263 
264         Transfer(msg.sender, _to, _value);
265         Transfer(msg.sender, _to, _value, _data);
266         return true;
267     }
268 
269     /**
270     * @dev Gets the balance of the specified address.
271     * @param _owner The address to query the the balance of.
272     * @return An uint representing the amount owned by the passed address.
273     */
274     function balanceOf(address _owner) public view returns (uint balance) {
275         return balances[_owner];
276     }
277 
278     /**
279      * @dev Transfer tokens from one address to another
280      * @param _from address The address which you want to send tokens from
281      * @param _to address The address which you want to transfer to
282      * @param _value uint the amount of tokens to be transferred
283      */
284     function transferFrom(address _from, address _to, uint _value) activeForHolder(_from) public returns (bool) {
285         bytes memory empty;
286         return transferFrom(_from, _to, _value, empty);
287     }
288 
289     /**
290      * @dev Transfer tokens from one address to another
291      * @param _from address The address which you want to send tokens from
292      * @param _to address The address which you want to transfer to
293      * @param _value uint the amount of tokens to be transferred
294      * @param _data Optional metadata.
295      */
296     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
297         require(_to != address(0));
298         require(_value <= balances[_from]);
299         require(_value <= allowed[_from][msg.sender]);
300 
301         balances[_from] = balances[_from].sub(_value);
302         balances[_to] = balances[_to].add(_value);
303         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304 
305         if (isContract(_to)) {
306             TokenReciever receiver = TokenReciever(_to);
307             receiver.tokenFallback(msg.sender, _value, _data);
308         }
309 
310         Transfer(_from, _to, _value);
311         Transfer(_from, _to, _value, _data);
312         return true;
313     }
314 
315     /**
316      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
317      *
318      * Beware that changing an allowance with this method brings the risk that someone may use both the old
319      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
320      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322      * @param _spender The address which will spend the funds.
323      * @param _value The amount of tokens to be spent.
324      */
325     function approve(address _spender, uint _value) public returns (bool) {
326         allowed[msg.sender][_spender] = _value;
327         Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331     /**
332      * @dev Function to check the amount of tokens that an owner allowed to a spender.
333      * @param _owner address The address which owns the funds.
334      * @param _spender address The address which will spend the funds.
335      * @return A uint specifying the amount of tokens still available for the spender.
336      */
337     function allowance(address _owner, address _spender) public view returns (uint) {
338         return allowed[_owner][_spender];
339     }
340 
341     /**
342      * @dev Increase the amount of tokens that an owner allowed to a spender.
343      *
344      * approve should be called when allowed[_spender] == 0. To increment
345      * allowed value is better to use this function to avoid 2 calls (and wait until
346      * the first transaction is mined)
347      * From MonolithDAO Token.sol
348      * @param _spender The address which will spend the funds.
349      * @param _addedValue The amount of tokens to increase the allowance by.
350      */
351     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
352         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
353         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354         return true;
355     }
356 
357     /**
358      * @dev Decrease the amount of tokens that an owner allowed to a spender.
359      *
360      * approve should be called when allowed[_spender] == 0. To decrement
361      * allowed value is better to use this function to avoid 2 calls (and wait until
362      * the first transaction is mined)
363      * From MonolithDAO Token.sol
364      * @param _spender The address which will spend the funds.
365      * @param _subtractedValue The amount of tokens to decrease the allowance by.
366      */
367     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
368         uint oldValue = allowed[msg.sender][_spender];
369         if (_subtractedValue > oldValue) {
370             allowed[msg.sender][_spender] = 0;
371         } else {
372             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
373         }
374         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375         return true;
376     }
377 
378     function setActivationTime(uint _holderGroup, uint _activationTime) external onlyOwner {
379         activationTime[_holderGroup] = _activationTime;
380     }
381 
382     function setHolderGroup(address _holder, uint _holderGroup) external onlyOwner {
383         holderGroup[_holder] = _holderGroup;
384     }
385 
386     function isContract(address _addr) private view returns (bool) {
387         uint length;
388         assembly {
389               //retrieve the size of the code on target address, this needs assembly
390               length := extcodesize(_addr)
391         }
392         return (length>0);
393     }
394 }
395 
396 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
397 
398 /**
399  * @title Pausable
400  * @dev Base contract which allows children to implement an emergency stop mechanism.
401  */
402 contract Pausable is Ownable {
403   event Pause();
404   event Unpause();
405 
406   bool public paused = false;
407 
408 
409   /**
410    * @dev Modifier to make a function callable only when the contract is not paused.
411    */
412   modifier whenNotPaused() {
413     require(!paused);
414     _;
415   }
416 
417   /**
418    * @dev Modifier to make a function callable only when the contract is paused.
419    */
420   modifier whenPaused() {
421     require(paused);
422     _;
423   }
424 
425   /**
426    * @dev called by the owner to pause, triggers stopped state
427    */
428   function pause() onlyOwner whenNotPaused public {
429     paused = true;
430     Pause();
431   }
432 
433   /**
434    * @dev called by the owner to unpause, returns to normal state
435    */
436   function unpause() onlyOwner whenPaused public {
437     paused = false;
438     Unpause();
439   }
440 }
441 
442 // File: contracts/SaleBase.sol
443 
444 contract SaleBase is Pausable, Contactable {
445     using SafeMath for uint;
446   
447     // The token being sold
448     HeroCoin public token;
449   
450     // start and end timestamps where purchases are allowed (both inclusive)
451     uint public startTime;
452     uint public endTime;
453   
454     // address where funds are collected
455     address public wallet;
456   
457     // the contract, which determine how many token units a buyer gets per wei
458     IPricingStrategy public pricingStrategy;
459   
460     // amount of raised money in wei
461     uint public weiRaised;
462 
463     // amount of tokens that was sold on the crowdsale
464     uint public tokensSold;
465 
466     // maximum amount of wei in total, that can be bought
467     uint public weiMaximumGoal;
468 
469     // if weiMinimumGoal will not be reached till endTime, buyers will be able to refund ETH
470     uint public weiMinimumGoal;
471 
472     // minimum amount of wel, that can be contributed
473     uint public weiMinimumAmount;
474 
475     // How many distinct addresses have bought
476     uint public buyerCount;
477 
478     // how much wei we have returned back to the contract after a failed crowdfund
479     uint public loadedRefund;
480 
481     // how much wei we have given back to buyers
482     uint public weiRefunded;
483 
484     // how much ETH each address has bought to this crowdsale
485     mapping (address => uint) public boughtAmountOf;
486 
487     // holder group of sale buyers, must be defined in child contract
488     function holderGroupNumber() pure returns (uint) {
489         return 0;
490     }
491 
492     /**
493      * event for token purchase logging
494      * @param purchaser who paid for the tokens
495      * @param beneficiary who got the tokens
496      * @param value weis paid for purchase
497      * @param tokenAmount amount of tokens purchased
498      */
499     event TokenPurchase(
500         address indexed purchaser,
501         address indexed beneficiary,
502         uint value,
503         uint tokenAmount
504     );
505 
506     // a refund was processed for an buyer
507     event Refund(address buyer, uint weiAmount);
508 
509     function SaleBase(
510         uint _startTime,
511         uint _endTime,
512         IPricingStrategy _pricingStrategy,
513         HeroCoin _token,
514         address _wallet,
515         uint _weiMaximumGoal,
516         uint _weiMinimumGoal,
517         uint _weiMinimumAmount
518     ) public
519     {
520         require(_pricingStrategy.isPricingStrategy());
521         require(address(_token) != 0x0);
522         require(_wallet != 0x0);
523         require(_weiMaximumGoal > 0);
524 
525         setStartTime(_startTime);
526         setEndTime(_endTime);
527         pricingStrategy = _pricingStrategy;
528         token = _token;
529         wallet = _wallet;
530         weiMaximumGoal = _weiMaximumGoal;
531         weiMinimumGoal = _weiMinimumGoal;
532         weiMinimumAmount = _weiMinimumAmount;
533     }
534 
535     // fallback function can be used to buy tokens
536     function () external payable {
537         buyTokens(msg.sender);
538     }
539 
540     // low level token purchase function
541     function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {
542         uint weiAmount = msg.value;
543 
544         require(beneficiary != 0x0);
545         require(validPurchase(weiAmount));
546     
547         // calculate token amount to be created
548         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, tokensSold);
549         
550         mintTokenToBuyer(beneficiary, tokenAmount, weiAmount);
551         
552         wallet.transfer(msg.value);
553 
554         return true;
555     }
556 
557     function mintTokenToBuyer(address beneficiary, uint tokenAmount, uint weiAmount) internal {
558         if (boughtAmountOf[beneficiary] == 0) {
559             // A new buyer
560             buyerCount++;
561         }
562 
563         boughtAmountOf[beneficiary] = boughtAmountOf[beneficiary].add(weiAmount);
564         weiRaised = weiRaised.add(weiAmount);
565         tokensSold = tokensSold.add(tokenAmount);
566     
567         token.mint(beneficiary, tokenAmount, holderGroupNumber());
568         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
569     }
570 
571     // return true if the transaction can buy tokens
572     function validPurchase(uint weiAmount) internal constant returns (bool) {
573         bool withinPeriod = now >= startTime && now <= endTime;
574         bool withinCap = weiRaised.add(weiAmount) <= weiMaximumGoal;
575         bool moreThenMinimum = weiAmount >= weiMinimumAmount;
576 
577         return withinPeriod && withinCap && moreThenMinimum;
578     }
579 
580     // return true if crowdsale event has ended
581     function hasEnded() external constant returns (bool) {
582         bool capReached = weiRaised >= weiMaximumGoal;
583         bool afterEndTime = now > endTime;
584         
585         return capReached || afterEndTime;
586     }
587 
588     // get the amount of unsold tokens allocated to this contract;
589     function getWeiLeft() external constant returns (uint) {
590         return weiMaximumGoal - weiRaised;
591     }
592 
593     // return true if the crowdsale has raised enough money to be a successful.
594     function isMinimumGoalReached() public constant returns (bool) {
595         return weiRaised >= weiMinimumGoal;
596     }
597     
598     // allows to update tokens rate for owner
599     function setPricingStrategy(IPricingStrategy _pricingStrategy) external onlyOwner returns (bool) {
600         pricingStrategy = _pricingStrategy;
601         return true;
602     }
603 
604     /**
605     * Allow load refunds back on the contract for the refunding.
606     *
607     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
608     */
609     function loadRefund() external payable {
610         require(msg.value > 0);
611         require(!isMinimumGoalReached());
612         
613         loadedRefund = loadedRefund.add(msg.value);
614     }
615 
616     /**
617     * Buyers can claim refund.
618     *
619     * Note that any refunds from proxy buyers should be handled separately,
620     * and not through this contract.
621     */
622     function refund() external {
623         require(!isMinimumGoalReached() && loadedRefund > 0);
624         uint256 weiValue = boughtAmountOf[msg.sender];
625         require(weiValue > 0);
626         
627         boughtAmountOf[msg.sender] = 0;
628         weiRefunded = weiRefunded.add(weiValue);
629         Refund(msg.sender, weiValue);
630         msg.sender.transfer(weiValue);
631     }
632 
633     function setStartTime(uint _startTime) public onlyOwner {
634         require(_startTime >= now);
635         startTime = _startTime;
636     }
637 
638     function setEndTime(uint _endTime) public onlyOwner {
639         require(_endTime >= startTime);
640         endTime = _endTime;
641     }
642 }
643 
644 // File: contracts/presale/Presale.sol
645 
646 /**
647  * @title Presale
648  * @dev Presale is a contract for managing a token crowdsale.
649  * Presales have a start and end timestamps, where buyers can make
650  * token purchases and the crowdsale will assign them tokens based
651  * on a token per ETH rate. Funds collected are forwarded to a wallet
652  * as they arrive.
653  */
654 contract Presale is SaleBase {
655     function Presale(
656         uint _startTime,
657         uint _endTime,
658         IPricingStrategy _pricingStrategy,
659         HeroCoin _token,
660         address _wallet,
661         uint _weiMaximumGoal,
662         uint _weiMinimumGoal,
663         uint _weiMinimumAmount
664     ) public SaleBase(
665         _startTime,
666         _endTime,
667         _pricingStrategy,
668         _token,
669         _wallet,
670         _weiMaximumGoal,
671         _weiMinimumGoal,
672         _weiMinimumAmount) 
673     {
674 
675     }
676 
677     function holderGroupNumber() public pure returns (uint) {
678         return 1;
679     }
680 }