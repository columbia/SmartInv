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
14 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   uint256 public totalSupply;
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 // File: zeppelin-solidity/contracts/token/ERC20.sol
29 
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public view returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 // File: contracts/token/ERC223.sol
42 
43 contract ERC223 is ERC20 {
44     function transfer(address _to, uint _value, bytes _data) public returns (bool);
45     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool);
46     
47     event Transfer(address indexed from, address indexed to, uint value, bytes data);
48 }
49 
50 // File: contracts/token/TokenReciever.sol
51 
52 /*
53  * Contract that is working with ERC223 tokens
54  */
55  
56  contract TokenReciever {
57     function tokenFallback(address _from, uint _value, bytes _data) public pure {
58     }
59 }
60 
61 // File: zeppelin-solidity/contracts/math/SafeMath.sol
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     if (a == 0) {
70       return 0;
71     }
72     uint256 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
115     owner = msg.sender;
116   }
117 
118 
119   /**
120    * @dev Throws if called by any account other than the owner.
121    */
122   modifier onlyOwner() {
123     require(msg.sender == owner);
124     _;
125   }
126 
127 
128   /**
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address newOwner) public onlyOwner {
133     require(newOwner != address(0));
134     OwnershipTransferred(owner, newOwner);
135     owner = newOwner;
136   }
137 
138 }
139 
140 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
141 
142 /**
143  * @title Contactable token
144  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
145  * contact information.
146  */
147 contract Contactable is Ownable{
148 
149     string public contactInformation;
150 
151     /**
152      * @dev Allows the owner to set a string with their contact information.
153      * @param info The contact information to attach to the contract.
154      */
155     function setContactInformation(string info) onlyOwner public {
156          contactInformation = info;
157      }
158 }
159 
160 // File: contracts/token/PlayHallToken.sol
161 
162 contract PlayHallToken is ERC223, Contactable {
163     using SafeMath for uint;
164 
165     string constant public name = "PlayHall Token";
166     string constant public symbol = "PHT";
167     uint constant public decimals = 18;
168 
169     bool public isActivated = false;
170 
171     mapping (address => uint) balances;
172     mapping (address => mapping (address => uint)) internal allowed;
173     mapping (address => bool) public freezedList;
174     
175     // address, who is allowed to issue new tokens (presale and sale contracts)
176     address public minter;
177 
178     bool public mintingFinished = false;
179 
180     event Mint(address indexed to, uint amount);
181     event MintingFinished();
182 
183     modifier onlyMinter() {
184         require(msg.sender == minter);
185         _;
186     }
187 
188     modifier canMint() {
189         require(!mintingFinished);
190         _;
191     }
192 
193     modifier whenActivated() {
194         require(isActivated);
195         _;
196     }
197 
198     function PlayHallToken() public {
199         minter = msg.sender;
200     }
201 
202     /**
203     * @dev transfer token for a specified address
204     * @param _to The address to transfer to.
205     * @param _value The amount to be transferred.
206     */
207     function transfer(address _to, uint _value) public returns (bool) {
208         bytes memory empty;
209         return transfer(_to, _value, empty);
210     }
211 
212     /**
213     * @dev transfer token for a specified address
214     * @param _to The address to transfer to.
215     * @param _value The amount to be transferred.
216     * @param _data Optional metadata.
217     */
218     function transfer(address _to, uint _value, bytes _data) public whenActivated returns (bool) {
219         require(_to != address(0));
220         require(_value <= balances[msg.sender]);
221         require(!freezedList[msg.sender]);
222 
223         // SafeMath.sub will throw if there is not enough balance.
224         balances[msg.sender] = balances[msg.sender].sub(_value);
225         balances[_to] = balances[_to].add(_value);
226 
227         if (isContract(_to)) {
228             TokenReciever receiver = TokenReciever(_to);
229             receiver.tokenFallback(msg.sender, _value, _data);
230         }
231 
232         Transfer(msg.sender, _to, _value);
233         Transfer(msg.sender, _to, _value, _data);
234         return true;
235     }
236 
237     /**
238     * @dev Gets the balance of the specified address.
239     * @param _owner The address to query the the balance of.
240     * @return An uint representing the amount owned by the passed address.
241     */
242     function balanceOf(address _owner) public view returns (uint balance) {
243         return balances[_owner];
244     }
245 
246     /**
247      * @dev Transfer tokens from one address to another
248      * @param _from address The address which you want to send tokens from
249      * @param _to address The address which you want to transfer to
250      * @param _value uint the amount of tokens to be transferred
251      */
252     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
253         bytes memory empty;
254         return transferFrom(_from, _to, _value, empty);
255     }
256 
257     /**
258      * @dev Transfer tokens from one address to another
259      * @param _from address The address which you want to send tokens from
260      * @param _to address The address which you want to transfer to
261      * @param _value uint the amount of tokens to be transferred
262      * @param _data Optional metadata.
263      */
264     function transferFrom(address _from, address _to, uint _value, bytes _data) public whenActivated returns (bool) {
265         require(_to != address(0));
266         require(_value <= balances[_from]);
267         require(_value <= allowed[_from][msg.sender]);
268         require(!freezedList[_from]);
269 
270         balances[_from] = balances[_from].sub(_value);
271         balances[_to] = balances[_to].add(_value);
272         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273 
274         if (isContract(_to)) {
275             TokenReciever receiver = TokenReciever(_to);
276             receiver.tokenFallback(_from, _value, _data);
277         }
278 
279         Transfer(_from, _to, _value);
280         Transfer(_from, _to, _value, _data);
281         return true;
282     }
283 
284     /**
285      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286      *
287      * Beware that changing an allowance with this method brings the risk that someone may use both the old
288      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291      * @param _spender The address which will spend the funds.
292      * @param _value The amount of tokens to be spent.
293      */
294     function approve(address _spender, uint _value) public returns (bool) {
295         require(_value == 0 || allowed[msg.sender][_spender] == 0);
296         allowed[msg.sender][_spender] = _value;
297         Approval(msg.sender, _spender, _value);
298         return true;
299     }
300 
301     /**
302      * @dev Function to check the amount of tokens that an owner allowed to a spender.
303      * @param _owner address The address which owns the funds.
304      * @param _spender address The address which will spend the funds.
305      * @return A uint specifying the amount of tokens still available for the spender.
306      */
307     function allowance(address _owner, address _spender) public view returns (uint) {
308         return allowed[_owner][_spender];
309     }
310 
311     /**
312      * @dev Increase the amount of tokens that an owner allowed to a spender.
313      *
314      * approve should be called when allowed[_spender] == 0. To increment
315      * allowed value is better to use this function to avoid 2 calls (and wait until
316      * the first transaction is mined)
317      * From MonolithDAO Token.sol
318      * @param _spender The address which will spend the funds.
319      * @param _addedValue The amount of tokens to increase the allowance by.
320      */
321     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
322         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
323         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324         return true;
325     }
326 
327     /**
328      * @dev Decrease the amount of tokens that an owner allowed to a spender.
329      *
330      * approve should be called when allowed[_spender] == 0. To decrement
331      * allowed value is better to use this function to avoid 2 calls (and wait until
332      * the first transaction is mined)
333      * From MonolithDAO Token.sol
334      * @param _spender The address which will spend the funds.
335      * @param _subtractedValue The amount of tokens to decrease the allowance by.
336      */
337     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
338         uint oldValue = allowed[msg.sender][_spender];
339         if (_subtractedValue > oldValue) {
340             allowed[msg.sender][_spender] = 0;
341         } else {
342             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
343         }
344         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345         return true;
346     }
347 
348       /**
349      * @dev Function to mint tokens
350      * @param _to The address that will receive the minted tokens.
351      * @param _amount The amount of tokens to mint.
352      * @return A boolean that indicates if the operation was successful.
353      */
354     function mint(address _to, uint _amount, bool freeze) canMint onlyMinter external returns (bool) {
355         totalSupply = totalSupply.add(_amount);
356         balances[_to] = balances[_to].add(_amount);
357         if (freeze) {
358             freezedList[_to] = true;
359         }
360         Mint(_to, _amount);
361         Transfer(address(0), _to, _amount);
362         return true;
363     }
364 
365     /**
366      * @dev Function to stop minting new tokens.
367      * @return True if the operation was successful.
368      */
369     function finishMinting() canMint onlyMinter external returns (bool) {
370         mintingFinished = true;
371         MintingFinished();
372         return true;
373     }
374     
375     /**
376      * Minter can pass it's role to another address
377      */
378     function setMinter(address _minter) external onlyMinter {
379         require(_minter != 0x0);
380         minter = _minter;
381     }
382 
383     /**
384      * Owner can unfreeze any address
385      */
386     function removeFromFreezedList(address user) external onlyOwner {
387         freezedList[user] = false;
388     }
389 
390     /**
391      * Activation of the token allows all tokenholders to operate with the token
392      */
393     function activate() external onlyOwner returns (bool) {
394         isActivated = true;
395         return true;
396     }
397 
398     function isContract(address _addr) private view returns (bool) {
399         uint length;
400         assembly {
401               //retrieve the size of the code on target address, this needs assembly
402               length := extcodesize(_addr)
403         }
404         return (length>0);
405     }
406 }
407 
408 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
409 
410 /**
411  * @title Pausable
412  * @dev Base contract which allows children to implement an emergency stop mechanism.
413  */
414 contract Pausable is Ownable {
415   event Pause();
416   event Unpause();
417 
418   bool public paused = false;
419 
420 
421   /**
422    * @dev Modifier to make a function callable only when the contract is not paused.
423    */
424   modifier whenNotPaused() {
425     require(!paused);
426     _;
427   }
428 
429   /**
430    * @dev Modifier to make a function callable only when the contract is paused.
431    */
432   modifier whenPaused() {
433     require(paused);
434     _;
435   }
436 
437   /**
438    * @dev called by the owner to pause, triggers stopped state
439    */
440   function pause() onlyOwner whenNotPaused public {
441     paused = true;
442     Pause();
443   }
444 
445   /**
446    * @dev called by the owner to unpause, returns to normal state
447    */
448   function unpause() onlyOwner whenPaused public {
449     paused = false;
450     Unpause();
451   }
452 }
453 
454 // File: contracts/SaleBase.sol
455 
456 contract SaleBase is Pausable, Contactable {
457     using SafeMath for uint;
458   
459     // The token being sold
460     PlayHallToken public token;
461   
462     // start and end timestamps where purchases are allowed (both inclusive)
463     uint public startTime;
464     uint public endTime;
465   
466     // address where funds are collected
467     address public wallet;
468   
469     // the contract, which determine how many token units a buyer gets per wei
470     IPricingStrategy public pricingStrategy;
471   
472     // amount of raised money in wei
473     uint public weiRaised;
474 
475     // amount of tokens that was sold on the crowdsale
476     uint public tokensSold;
477 
478     // maximum amount of wei in total, that can be bought
479     uint public weiMaximumGoal;
480 
481     // if weiMinimumGoal will not be reached till endTime, buyers will be able to refund ETH
482     uint public weiMinimumGoal;
483 
484     // minimum amount of wel, that can be contributed
485     uint public weiMinimumAmount;
486 
487     // How many distinct addresses have bought
488     uint public buyerCount;
489 
490     // how much wei we have returned back to the contract after a failed crowdfund
491     uint public loadedRefund;
492 
493     // how much wei we have given back to buyers
494     uint public weiRefunded;
495 
496     // how much ETH each address has bought to this crowdsale
497     mapping (address => uint) public boughtAmountOf;
498 
499     // whether a buyer already bought some tokens
500     mapping (address => bool) public isBuyer;
501 
502     // whether a buyer bought tokens through other currencies
503     mapping (address => bool) public isExternalBuyer;
504 
505     address public admin;
506 
507     /**
508      * event for token purchase logging
509      * @param purchaser who paid for the tokens
510      * @param beneficiary who got the tokens
511      * @param value weis paid for purchase
512      * @param tokenAmount amount of tokens purchased
513      */
514     event TokenPurchase(
515         address indexed purchaser,
516         address indexed beneficiary,
517         uint value,
518         uint tokenAmount
519     );
520 
521     // a refund was processed for an buyer
522     event Refund(address buyer, uint weiAmount);
523     event RefundLoaded(uint amount);
524 
525     function SaleBase(
526         uint _startTime,
527         uint _endTime,
528         IPricingStrategy _pricingStrategy,
529         PlayHallToken _token,
530         address _wallet,
531         uint _weiMaximumGoal,
532         uint _weiMinimumGoal,
533         uint _weiMinimumAmount,
534         address _admin
535     ) public
536     {
537         require(_startTime >= now);
538         require(_endTime >= _startTime);
539         require(_pricingStrategy.isPricingStrategy());
540         require(address(_token) != 0x0);
541         require(_wallet != 0x0);
542         require(_weiMaximumGoal > 0);
543         require(_admin != 0x0);
544 
545         startTime = _startTime;
546         endTime = _endTime;
547         pricingStrategy = _pricingStrategy;
548         token = _token;
549         wallet = _wallet;
550         weiMaximumGoal = _weiMaximumGoal;
551         weiMinimumGoal = _weiMinimumGoal;
552         weiMinimumAmount = _weiMinimumAmount;
553         admin = _admin;
554     }
555 
556 
557     modifier onlyOwnerOrAdmin() {
558         require(msg.sender == owner || msg.sender == admin); 
559         _;
560     }
561 
562     // fallback function can be used to buy tokens
563     function () external payable {
564         buyTokens(msg.sender);
565     }
566 
567     // low level token purchase function
568     function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {
569         uint weiAmount = msg.value;
570 
571         require(beneficiary != 0x0);
572         require(weiAmount >= weiMinimumAmount);
573         require(validPurchase(msg.value));
574     
575         // calculate token amount to be created
576         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, weiRaised);
577         
578         mintTokenToBuyer(beneficiary, tokenAmount, weiAmount);
579         
580         wallet.transfer(msg.value);
581 
582         return true;
583     }
584 
585     function mintTokenToBuyer(address beneficiary, uint tokenAmount, uint weiAmount) internal {
586         if (!isBuyer[beneficiary]) {
587             // A new buyer
588             buyerCount++;
589             isBuyer[beneficiary] = true;
590         }
591 
592         boughtAmountOf[beneficiary] = boughtAmountOf[beneficiary].add(weiAmount);
593         weiRaised = weiRaised.add(weiAmount);
594         tokensSold = tokensSold.add(tokenAmount);
595     
596         token.mint(beneficiary, tokenAmount, true);
597         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
598     }
599 
600     // return true if the transaction can buy tokens
601     function validPurchase(uint weiAmount) internal constant returns (bool) {
602         bool withinPeriod = now >= startTime && now <= endTime;
603         bool withinCap = weiRaised.add(weiAmount) <= weiMaximumGoal;
604 
605         return withinPeriod && withinCap;
606     }
607 
608     // return true if crowdsale event has ended
609     function hasEnded() public constant returns (bool) {
610         bool capReached = weiRaised >= weiMaximumGoal;
611         bool afterEndTime = now > endTime;
612         
613         return capReached || afterEndTime;
614     }
615 
616     // get the amount of unsold tokens allocated to this contract;
617     function getWeiLeft() external constant returns (uint) {
618         return weiMaximumGoal - weiRaised;
619     }
620 
621     // return true if the crowdsale has raised enough money to be a successful.
622     function isMinimumGoalReached() public constant returns (bool) {
623         return weiRaised >= weiMinimumGoal;
624     }
625     
626     // allows to update tokens rate for owner
627     function setPricingStrategy(IPricingStrategy _pricingStrategy) external onlyOwner returns (bool) {
628         pricingStrategy = _pricingStrategy;
629         return true;
630     }
631 
632     /**
633     * Allow load refunds back on the contract for the refunding.
634     *
635     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
636     */
637     function loadRefund() external payable {
638         require(msg.sender == wallet);
639         require(msg.value > 0);
640         require(!isMinimumGoalReached());
641         
642         loadedRefund = loadedRefund.add(msg.value);
643 
644         RefundLoaded(msg.value);
645     }
646 
647     /**
648     * Buyers can claim refund.
649     *
650     * Note that any refunds from proxy buyers should be handled separately,
651     * and not through this contract.
652     */
653     function refund() external {
654         require(!isMinimumGoalReached() && loadedRefund > 0);
655         require(!isExternalBuyer[msg.sender]);
656         uint weiValue = boughtAmountOf[msg.sender];
657         require(weiValue > 0);
658         
659         boughtAmountOf[msg.sender] = 0;
660         weiRefunded = weiRefunded.add(weiValue);
661         msg.sender.transfer(weiValue);
662 
663         Refund(msg.sender, weiValue);
664     }
665 
666     function registerPayment(address beneficiary, uint tokenAmount, uint weiAmount) public onlyOwnerOrAdmin {
667         require(validPurchase(weiAmount));
668         isExternalBuyer[beneficiary] = true;
669         mintTokenToBuyer(beneficiary, tokenAmount, weiAmount);
670     }
671 
672     function registerPayments(address[] beneficiaries, uint[] tokenAmounts, uint[] weiAmounts) external onlyOwnerOrAdmin {
673         require(beneficiaries.length == tokenAmounts.length);
674         require(tokenAmounts.length == weiAmounts.length);
675 
676         for (uint i = 0; i < beneficiaries.length; i++) {
677             registerPayment(beneficiaries[i], tokenAmounts[i], weiAmounts[i]);
678         }
679     }
680 
681     function setAdmin(address adminAddress) external onlyOwner {
682         admin = adminAddress;
683     }
684 }
685 
686 // File: contracts/presale/Presale.sol
687 
688 /**
689  * @title Presale
690  * @dev Presale is a contract for managing a token crowdsale.
691  * Presales have a start and end timestamps, where buyers can make
692  * token purchases and the crowdsale will assign them tokens based
693  * on a token per ETH rate. Funds collected are forwarded to a wallet
694  * as they arrive.
695  */
696 contract Presale is SaleBase {
697     function Presale(
698         uint _startTime,
699         uint _endTime,
700         IPricingStrategy _pricingStrategy,
701         PlayHallToken _token,
702         address _wallet,
703         uint _weiMaximumGoal,
704         uint _weiMinimumGoal,
705         uint _weiMinimumAmount,
706         address _admin
707     ) public SaleBase(
708         _startTime,
709         _endTime,
710         _pricingStrategy,
711         _token,
712         _wallet,
713         _weiMaximumGoal,
714         _weiMinimumGoal,
715         _weiMinimumAmount,
716         _admin) 
717     {
718 
719     }
720 
721     function changeTokenMinter(address newMinter) external onlyOwner {
722         require(newMinter != 0x0);
723         require(hasEnded());
724 
725         token.setMinter(newMinter);
726     }
727 }