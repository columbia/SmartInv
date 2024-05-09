1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     function Ownable() public {
22         owner = msg.sender;
23     }
24 
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         assert(c / a == b);
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         assert(b <= a);
72         return a - b;
73     }
74 
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90     uint256 public totalSupply;
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[msg.sender]);
115 
116         // SafeMath.sub will throw if there is not enough balance.
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public view returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141     function allowance(address owner, address spender) public view returns (uint256);
142     function transferFrom(address from, address to, uint256 value) public returns (bool);
143     function approve(address spender, uint256 value) public returns (bool);
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161     /**
162      * @dev Transfer tokens from one address to another
163      * @param _from address The address which you want to send tokens from
164      * @param _to address The address which you want to transfer to
165      * @param _value uint256 the amount of tokens to be transferred
166      */
167     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168         require(_to != address(0));
169         require(_value <= balances[_from]);
170         require(_value <= allowed[_from][msg.sender]);
171 
172         balances[_from] = balances[_from].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      *
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param _spender The address which will spend the funds.
187      * @param _value The amount of tokens to be spent.
188      */
189     function approve(address _spender, uint256 _value) public returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      */
201     function allowance(address _owner, address _spender) public view returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204 
205     /**
206      * approve should be called when allowed[_spender] == 0. To increment
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      */
211     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220             allowed[msg.sender][_spender] = 0;
221         } else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240     event Mint(address indexed to, uint256 amount);
241     event MintFinished();
242 
243     bool public mintingFinished = false;
244 
245 
246     modifier canMint() {
247         require(!mintingFinished);
248         _;
249     }
250 
251     /**
252      * @dev Function to mint tokens
253      * @param _to The address that will receive the minted tokens.
254      * @param _amount The amount of tokens to mint.
255      * @return A boolean that indicates if the operation was successful.
256      */
257     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258         totalSupply = totalSupply.add(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         Mint(_to, _amount);
261         Transfer(address(0), _to, _amount);
262         return true;
263     }
264 
265     /**
266      * @dev Function to stop minting new tokens.
267      * @return True if the operation was successful.
268      */
269     function finishMinting() onlyOwner canMint public returns (bool) {
270         mintingFinished = true;
271         MintFinished();
272         return true;
273     }
274 }
275 
276 // File: contracts/OAKToken.sol
277 
278 contract OAKToken is MintableToken {
279     string public name = "Acorn Collective Token";
280     string public symbol = "OAK";
281     uint256 public decimals = 18;
282 
283     mapping(address => bool) public kycRequired;
284 
285     // overriding MintableToken#mint to add kyc logic
286     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
287         kycRequired[_to] = true;
288         return super.mint(_to, _amount);
289     }
290 
291     // overriding MintableToken#transfer to add kyc logic
292     function transfer(address _to, uint _value) public returns (bool) {
293         require(!kycRequired[msg.sender]);
294 
295         return super.transfer(_to, _value);
296     }
297 
298     // overriding MintableToken#transferFrom to add kyc logic
299     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
300         require(!kycRequired[_from]);
301 
302         return super.transferFrom(_from, _to, _value);
303     }
304 
305     function kycVerify(address participant) onlyOwner public {
306         kycRequired[participant] = false;
307         KycVerified(participant);
308     }
309     event KycVerified(address indexed participant);
310 }
311 
312 // File: contracts/Crowdsale.sol
313 
314 /**
315  * @title Crowdsale
316  * @dev Crowdsale is a base contract for managing a token crowdsale.
317  * Crowdsales have a start and end timestamps, where investors can make
318  * token purchases and the crowdsale will assign them tokens based
319  * on a token per ETH rate. Funds collected are forwarded to a wallet
320  * as they arrive.
321  */
322 contract Crowdsale {
323     using SafeMath for uint256;
324 
325     // The token being sold
326     OAKToken public token;
327 
328     // start and end timestamps where investments are allowed (both inclusive)
329     uint256 public startTime;
330     uint256 public endTime;
331 
332     // address where funds are collected
333     address public wallet;
334 
335     // how many token units a buyer gets per wei
336     uint256 public rate;
337 
338     // amount of raised money in wei
339     uint256 public weiRaised;
340 
341     /**
342      * event for token purchase logging
343      * @param purchaser who paid for the tokens
344      * @param beneficiary who got the tokens
345      * @param value weis paid for purchase
346      * @param amount amount of tokens purchased
347      */
348     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
349 
350 
351     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
352         require(_startTime >= now);
353         require(_endTime >= _startTime);
354         require(_rate > 0);
355         require(_wallet != address(0));
356 
357         token = createTokenContract();
358         startTime = _startTime;
359         endTime = _endTime;
360         rate = _rate;
361         wallet = _wallet;
362     }
363 
364     // creates the token to be sold.
365     // override this method to have crowdsale of a specific mintable token.
366     event CrowdSaleTokenContractCreation();
367     // creates the token to be sold.
368     function createTokenContract() internal returns (OAKToken) {
369         OAKToken newToken = new OAKToken();
370         CrowdSaleTokenContractCreation();
371         return newToken;
372     }
373 
374 
375     // fallback function can be used to buy tokens
376     function () external payable {
377         buyTokens(msg.sender);
378     }
379 
380     // low level token purchase function
381     function buyTokens(address beneficiary) public payable {
382         require(beneficiary != address(0));
383         require(validPurchase());
384 
385         uint256 weiAmount = msg.value;
386 
387         // calculate token amount to be created
388         uint256 tokens = weiAmount.mul(rate);
389 
390         // update state
391         weiRaised = weiRaised.add(weiAmount);
392 
393         token.mint(beneficiary, tokens);
394         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
395 
396         forwardFunds();
397     }
398 
399     // send ether to the fund collection wallet
400     // override to create custom fund forwarding mechanisms
401     function forwardFunds() internal {
402         wallet.transfer(msg.value);
403     }
404 
405     // @return true if the transaction can buy tokens
406     function validPurchase() internal view returns (bool) {
407         bool withinPeriod = now >= startTime && now <= endTime;
408         bool nonZeroPurchase = msg.value != 0;
409         return withinPeriod && nonZeroPurchase;
410     }
411 
412     // @return true if crowdsale event has ended
413     function hasEnded() public view returns (bool) {
414         return now > endTime;
415     }
416 
417 
418 }
419 
420 // File: contracts/FinalizableCrowdsale.sol
421 
422 /**
423  * @title FinalizableCrowdsale
424  * @dev Extension of Crowdsale where an owner can do extra work
425  * after finishing.
426  */
427 contract FinalizableCrowdsale is Crowdsale, Ownable {
428     using SafeMath for uint256;
429 
430     bool public isFinalized = false;
431 
432     event Finalized();
433 
434     /**
435      * @dev Must be called after crowdsale ends, to do some extra finalization
436      * work. Calls the contract's finalization function.
437      */
438     function finalize() onlyOwner public {
439         require(!isFinalized);
440         require(hasEnded());
441 
442         finalization();
443         Finalized();
444 
445         isFinalized = true;
446     }
447 
448     /**
449      * @dev Can be overridden to add finalization logic. The overriding function
450      * should call super.finalization() to ensure the chain of finalization is
451      * executed entirely.
452      */
453     function finalization() internal {
454     }
455 }
456 
457 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
458 
459 /**
460  * @title Pausable
461  * @dev Base contract which allows children to implement an emergency stop mechanism.
462  */
463 contract Pausable is Ownable {
464     event Pause();
465     event Unpause();
466 
467     bool public paused = false;
468 
469 
470     /**
471      * @dev Modifier to make a function callable only when the contract is not paused.
472      */
473     modifier whenNotPaused() {
474         require(!paused);
475         _;
476     }
477 
478     /**
479      * @dev Modifier to make a function callable only when the contract is paused.
480      */
481     modifier whenPaused() {
482         require(paused);
483         _;
484     }
485 
486     /**
487      * @dev called by the owner to pause, triggers stopped state
488      */
489     function pause() onlyOwner whenNotPaused public {
490         paused = true;
491         Pause();
492     }
493 
494     /**
495      * @dev called by the owner to unpause, returns to normal state
496      */
497     function unpause() onlyOwner whenPaused public {
498         paused = false;
499         Unpause();
500     }
501 }
502 
503 // File: contracts/OAKTokenCrowdsale.sol
504 
505 contract OAKTokenCrowdsale is FinalizableCrowdsale, Pausable {
506 
507     uint256 public restrictedPercent;
508     address public restricted;
509     uint256 public soldTokens;
510     uint256 public hardCap;
511     uint256 public vipRate;
512 
513     uint256 public totalTokenSupply;
514 
515     mapping(address => bool) public vip;
516 
517     //TokenTimelock logic
518     uint256 public Y1_lockedTokenReleaseTime;
519     uint256 public Y1_lockedTokenAmount;
520 
521     uint256 public Y2_lockedTokenReleaseTime;
522     uint256 public Y2_lockedTokenAmount;
523 
524 
525     // constructor
526     function OAKTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public
527     Crowdsale(_startTime, _endTime, _rate, _wallet) {
528 
529         // total token supply for sales
530         totalTokenSupply = 75000000 * 10 ** 18;
531 
532         // hardCap for pre-sale
533         hardCap = 7000000 * 10 ** 18;
534 
535         vipRate = _rate;
536         soldTokens = 0;
537 
538         restrictedPercent = 20;
539         restricted = msg.sender;
540     }
541 
542     // update hardCap for sale
543     function setHardCap(uint256 _hardCap) public onlyOwner {
544         require(!isFinalized);
545         require(_hardCap >= 0 && _hardCap <= totalTokenSupply);
546 
547         hardCap = _hardCap;
548     }
549 
550     // update address where funds are collected
551     function setWalletAddress(address _wallet) public onlyOwner {
552         require(!isFinalized);
553 
554         wallet = _wallet;
555     }
556 
557     // update token units a buyer gets per wei
558     function setRate(uint256 _rate) public onlyOwner {
559         require(!isFinalized);
560         require(_rate > 0);
561 
562         rate = _rate;
563     }
564 
565     // update token units a vip buyer gets per wei
566     function setVipRate(uint256 _vipRate) public onlyOwner {
567         require(!isFinalized);
568         require(_vipRate > 0);
569 
570         vipRate = _vipRate;
571     }
572 
573     // add VIP buyer address
574     function setVipAddress(address _address) public onlyOwner {
575         vip[_address] = true;
576     }
577 
578     // remove VIP buyer address
579     function unsetVipAddress(address _address) public onlyOwner {
580         vip[_address] = false;
581     }
582 
583     // update startTime, endTime for post-sales
584     function setSalePeriod(uint256 _startTime, uint256 _endTime) public onlyOwner {
585         require(!isFinalized);
586         require(_startTime > 0);
587         require(_endTime > _startTime);
588 
589         startTime = _startTime;
590         endTime = _endTime;
591     }
592 
593     // fallback function can be used to buy tokens
594     function () external payable {
595         buyTokens(msg.sender);
596     }
597 
598     // overriding Crowdsale#buyTokens to add pausable sales and vip logic
599     function buyTokens(address beneficiary) public whenNotPaused payable {
600         require(beneficiary != address(0));
601         require(!isFinalized);
602 
603         uint256 weiAmount = msg.value;
604         uint tokens;
605 
606         if(vip[msg.sender] == true){
607             tokens = weiAmount.mul(vipRate);
608         }else{
609             tokens = weiAmount.mul(rate);
610         }
611         require(validPurchase(tokens));
612         soldTokens = soldTokens.add(tokens);
613 
614         // update state
615         weiRaised = weiRaised.add(weiAmount);
616 
617         token.mint(beneficiary, tokens);
618         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
619 
620         forwardFunds();
621     }
622 
623     // overriding Crowdsale#validPurchase to add capped sale logic
624     // @return true if the transaction can buy tokens
625     function validPurchase(uint256 tokens) internal view returns (bool) {
626         bool withinPeriod = now >= startTime && now <= endTime;
627         bool withinCap = soldTokens.add(tokens) <= hardCap;
628         bool withinTotalSupply = soldTokens.add(tokens) <= totalTokenSupply;
629         bool nonZeroPurchase = msg.value != 0;
630         return withinPeriod && nonZeroPurchase && withinCap && withinTotalSupply;
631     }
632 
633     // overriding FinalizableCrowdsale#finalization to add 20% of sold token for owner
634     function finalization() internal {
635         // mint locked token to Crowdsale contract
636         uint256 restrictedTokens = soldTokens.div(100).mul(restrictedPercent);
637         token.mint(this, restrictedTokens);
638         token.kycVerify(this);
639 
640         Y1_lockedTokenReleaseTime = now + 1 years;
641         Y1_lockedTokenAmount = restrictedTokens.div(2);
642 
643         Y2_lockedTokenReleaseTime = now + 2 years;
644         Y2_lockedTokenAmount = restrictedTokens.div(2);
645 
646         // stop minting new tokens
647         token.finishMinting();
648 
649         // transfer the contract ownership to OAKTokenCrowdsale.owner
650         token.transferOwnership(owner);
651 
652     }
653 
654     // release the 1st year locked token
655     function Y1_release() onlyOwner public {
656         require(Y1_lockedTokenAmount > 0);
657         require(now > Y1_lockedTokenReleaseTime);
658 
659         // transfer the locked token to restricted
660         token.transfer(restricted, Y1_lockedTokenAmount);
661 
662         Y1_lockedTokenAmount = 0;
663     }
664 
665     // release the 2nd year locked token
666     function Y2_release() onlyOwner public {
667         require(Y1_lockedTokenAmount == 0);
668         require(Y2_lockedTokenAmount > 0);
669         require(now > Y2_lockedTokenReleaseTime);
670 
671         uint256 amount = token.balanceOf(this);
672         require(amount > 0);
673 
674         // transfer the locked token to restricted
675         token.transfer(restricted, amount);
676 
677         Y2_lockedTokenAmount = 0;
678     }
679 
680     function kycVerify(address participant) onlyOwner public {
681         token.kycVerify(participant);
682     }
683 
684     function addPrecommitment(address participant, uint balance) onlyOwner public {
685         require(!isFinalized);
686         require(balance > 0);
687         // Check if the total token supply will be exceeded
688         require(soldTokens.add(balance) <= totalTokenSupply);
689 
690         soldTokens = soldTokens.add(balance);
691         token.mint(participant, balance);
692     }
693 
694 }