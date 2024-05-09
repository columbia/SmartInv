1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 
31     //Variables
32     address public owner;
33 
34     address public newOwner;
35 
36     //    Modifiers
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         newOwner = _newOwner;
61     }
62 
63     function acceptOwnership() public {
64         if (msg.sender == newOwner) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public constant returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     /**
94     * @dev transfer token for a specified address
95     * @param _to The address to transfer to.
96     * @param _value The amount to be transferred.
97     */
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         // SafeMath.sub will throw if there is not enough balance.
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) public constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    */
175   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 
195 contract MintableToken is StandardToken, Ownable {
196   event Mint(address indexed to, uint256 amount);
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will receive the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     Transfer(0x0, _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner public returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 
232 contract LamdenTau is MintableToken {
233     string public constant name = "Lamden Tau";
234     string public constant symbol = "TAU";
235     uint8 public constant decimals = 18;
236 
237     // locks transfers until minting is over, which ends at the end of the sale
238     // thus, the behavior of this token is locked transfers during sale, and unlocked after :)
239     function transfer(address _to, uint256 _value) public returns (bool) {
240       require(mintingFinished);
241       bool success = super.transfer(_to, _value);
242       return success;
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246       require(mintingFinished);
247       bool success = super.transferFrom(_from, _to, _value);
248       return success;
249     }
250 }
251 
252 contract Crowdsale {
253   using SafeMath for uint256;
254 
255   // The token being sold
256   MintableToken public token;
257 
258   // start and end timestamps where investments are allowed (both inclusive)
259   uint256 public startTime;
260   uint256 public endTime;
261 
262   // address where funds are collected
263   address public wallet;
264 
265   // how many token units a buyer gets per wei
266   uint256 public rate;
267 
268   // amount of raised money in wei
269   uint256 public weiRaised;
270 
271   /**
272    * event for token purchase logging
273    * @param purchaser who paid for the tokens
274    * @param beneficiary who got the tokens
275    * @param value weis paid for purchase
276    * @param amount amount of tokens purchased
277    */
278   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
279 
280 
281   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
282     require(_startTime >= now);
283     require(_endTime >= _startTime);
284     require(_rate > 0);
285     require(_wallet != 0x0);
286 
287     token = createTokenContract();
288     startTime = _startTime;
289     endTime = _endTime;
290     rate = _rate;
291     wallet = _wallet;
292   }
293 
294   // creates the token to be sold.
295   // override this method to have crowdsale of a specific mintable token.
296   function createTokenContract() internal returns (MintableToken) {
297     return new MintableToken();
298   }
299 
300 
301   // fallback function can be used to buy tokens
302   function () payable {
303     buyTokens(msg.sender);
304   }
305 
306   // low level token purchase function
307   function buyTokens(address beneficiary) public payable {
308     require(beneficiary != 0x0);
309     require(validPurchase());
310 
311     uint256 weiAmount = msg.value;
312 
313     // calculate token amount to be created
314     uint256 tokens = weiAmount.mul(rate);
315 
316     // update state
317     weiRaised = weiRaised.add(weiAmount);
318 
319     token.mint(beneficiary, tokens);
320     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
321 
322     forwardFunds();
323   }
324 
325   // send ether to the fund collection wallet
326   // override to create custom fund forwarding mechanisms
327   function forwardFunds() internal {
328     wallet.transfer(msg.value);
329   }
330 
331   // @return true if the transaction can buy tokens
332   function validPurchase() internal constant returns (bool) {
333     bool withinPeriod = now >= startTime && now <= endTime;
334     bool nonZeroPurchase = msg.value != 0;
335     return withinPeriod && nonZeroPurchase;
336   }
337 
338   // @return true if crowdsale event has ended
339   function hasEnded() public constant returns (bool) {
340     return now > endTime;
341   }
342 
343 
344 }
345 
346 contract CappedCrowdsale is Crowdsale {
347   using SafeMath for uint256;
348 
349   uint256 public cap;
350 
351   function CappedCrowdsale(uint256 _cap) {
352     require(_cap > 0);
353     cap = _cap;
354   }
355 
356   // overriding Crowdsale#validPurchase to add extra cap logic
357   // @return true if investors can buy at the moment
358   function validPurchase() internal constant returns (bool) {
359     bool withinCap = weiRaised.add(msg.value) <= cap;
360     return super.validPurchase() && withinCap;
361   }
362 
363   // overriding Crowdsale#hasEnded to add cap logic
364   // @return true if crowdsale event has ended
365   function hasEnded() public constant returns (bool) {
366     bool capReached = weiRaised >= cap;
367     return super.hasEnded() || capReached;
368   }
369 
370 }
371 
372 
373 contract Presale is CappedCrowdsale, Ownable {
374     using SafeMath for uint256;
375 
376     mapping (address => bool) public whitelist;
377 
378     bool public isFinalized = false;
379     event Finalized();
380     
381     address public team = 0x7D72dc07876435d3B2eE498E53A803958bc55b42;
382     uint256 public teamShare = 150000000 * (10 ** 18);
383     
384     address public seed = 0x3669ad54675E94e14196528786645c858b8391F1;
385     uint256 public seedShare = 1805067 * (10 ** 18);
386 
387     bool public hasAllocated = false;
388 
389     address public mediator = 0x0;
390     
391     function Presale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _tokenAddress) 
392     Crowdsale(_startTime, _endTime, _rate, _wallet)
393     CappedCrowdsale(_cap)
394     {
395         token = LamdenTau(_tokenAddress);
396     }
397     
398     // Crowdsale overrides
399     function createTokenContract() internal returns (MintableToken) {
400         return LamdenTau(0x0);
401     }
402 
403     function validPurchase() internal constant returns (bool) {
404         bool withinCap = weiRaised.add(msg.value) <= cap;
405         bool valid = super.validPurchase() && withinCap && whitelist[msg.sender];
406         return valid;
407     }
408     // * * *
409     
410     // Finalizer functions. Redefined from FinalizableCrowdsale to prevent diamond inheritence complexities
411     
412     function finalize() onlyOwner public {
413       require(mediator != 0x0);
414       require(!isFinalized);
415       require(hasEnded());
416       
417       finalization();
418       Finalized();
419 
420       isFinalized = true;
421     }
422     
423     function finalization() internal {
424         // set the ownership to the mediator so it can pass it onto the sale contract
425         // at the time that the sale contract is deployed
426         token.transferOwnership(mediator);
427         Mediator m = Mediator(mediator);
428         m.acceptToken();
429     }
430     // * * * 
431 
432     // Contract Specific functions
433     function assignMediator(address _m) public onlyOwner returns(bool) {
434         mediator = _m;
435         return true;
436     }
437     
438     function whitelistUser(address _a) public onlyOwner returns(bool){
439         whitelist[_a] = true;
440         return whitelist[_a];
441     }
442 
443     function whitelistUsers(address[] users) external onlyOwner {
444         for (uint i = 0; i < users.length; i++) {
445             whitelist[users[i]] = true;
446         }
447     }
448 
449     function unWhitelistUser(address _a) public onlyOwner returns(bool){
450         whitelist[_a] = false;
451         return whitelist[_a];
452     }
453 
454     function unWhitelistUsers(address[] users) external onlyOwner {
455         for (uint i = 0; i < users.length; i++) {
456             whitelist[users[i]] = false;
457         }
458     }
459     
460     function allocateTokens() public onlyOwner returns(bool) {
461         require(hasAllocated == false);
462         token.mint(team, teamShare);
463         token.mint(seed, seedShare);
464         hasAllocated = true;
465         return hasAllocated;
466     }
467     
468     function acceptToken() public onlyOwner returns(bool) {
469         token.acceptOwnership();
470         return true;
471     }
472 
473     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
474         require(_e > startTime);
475         endTime = _e;
476         return endTime;
477     }
478     
479     // * * *
480 }
481 
482 contract Sale is CappedCrowdsale, Ownable {
483     using SafeMath for uint256;
484 
485     // Initialization Variables
486     uint256 public amountPerDay; // 30 eth
487     uint256 public constant UNIX_DAY = 86400;
488 
489     bool public isFinalized = false;
490     event Finalized();
491 
492     mapping (address => bool) public whitelist;
493     mapping (address => uint256) public amountContributedBy;
494     // * * *
495 
496     // Constructor
497     function Sale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, uint256 _amountPerDay, address _tokenAddress)
498     Crowdsale(_startTime, _endTime, _rate, _wallet)
499     CappedCrowdsale(_cap)
500     {
501         amountPerDay = _amountPerDay;
502         token = LamdenTau(_tokenAddress);
503     }
504     // * * *
505     
506     // Crowdsale overrides
507     function createTokenContract() internal returns (MintableToken) {
508         return LamdenTau(0x0);
509     }
510     
511     function validPurchase() internal constant returns (bool) {
512         bool withinCap = weiRaised.add(msg.value) <= cap;
513         bool withinContributionLimit = msg.value <= currentPersonalLimit(msg.sender);
514         bool valid = super.validPurchase() && withinCap && whitelist[msg.sender] && withinContributionLimit;
515         return valid;
516     }
517 
518     function buyTokens(address beneficiary) public payable {
519         super.buyTokens(beneficiary);
520         amountContributedBy[msg.sender] = amountContributedBy[msg.sender].add(msg.value);
521     }
522     // * * *
523 
524     // Finalizer functions
525     function finalize() onlyOwner public {
526       require(!isFinalized);
527       require(hasEnded());
528 
529       finalization();
530       Finalized();
531 
532       isFinalized = true;
533     }
534     
535     function finalization() internal {
536         token.finishMinting();
537     }
538     // * * * 
539     
540     // Contract Specific functions
541     function daysSinceLaunch() public constant returns(uint256) {
542         return now.sub(startTime).div(UNIX_DAY);
543     }
544     
545     function currentContributionLimit() public constant returns(uint256) {
546         return amountPerDay.mul(2 ** daysSinceLaunch());
547     }
548     
549     function currentPersonalLimit(address _a) public constant returns(uint256) {
550         return currentContributionLimit().sub(amountContributedBy[_a]);
551     }
552     
553     function claimToken(address _m) public onlyOwner returns(bool) {
554         Mediator m = Mediator(_m);
555         m.passOff();
556         token.acceptOwnership();
557         return true;
558     }
559     
560     function whitelistUser(address _a) onlyOwner public returns(bool) {
561         whitelist[_a] = true;
562         return whitelist[_a];
563     }
564     
565     function whitelistUsers(address[] users) external onlyOwner {
566         for (uint i = 0; i < users.length; i++) {
567             whitelist[users[i]] = true;
568         }
569     }
570 
571     function unWhitelistUser(address _a) public onlyOwner returns(bool){
572         whitelist[_a] = false;
573         return whitelist[_a];
574     }
575 
576     function unWhitelistUsers(address[] users) external onlyOwner {
577         for (uint i = 0; i < users.length; i++) {
578             whitelist[users[i]] = false;
579         }
580     }
581 
582     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
583         require(_e > startTime);
584         endTime = _e;
585         return endTime;
586     }
587     // * * *
588 }
589 
590 
591 contract Mediator is Ownable {
592     address public presale;
593     LamdenTau public tau;
594     address public sale;
595     
596     function setPresale(address p) public onlyOwner { presale = p; }
597     function setTau(address t) public onlyOwner { tau = LamdenTau(t); }
598     function setSale(address s) public onlyOwner { sale = s; }
599     
600     modifier onlyPresale {
601         require(msg.sender == presale);
602         _;
603     }
604     
605     modifier onlySale {
606         require(msg.sender == sale);
607         _;
608     }
609     
610     function acceptToken() public onlyPresale { tau.acceptOwnership(); }
611     function passOff() public onlySale { tau.transferOwnership(sale); }
612 }