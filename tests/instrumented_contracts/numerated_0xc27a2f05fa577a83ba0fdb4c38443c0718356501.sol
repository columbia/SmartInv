1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4 
5     //Variables
6     address public owner;
7 
8     address public newOwner;
9 
10     //    Modifiers
11     /**
12      * @dev Throws if called by any account other than the owner.
13      */
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     function Ownable() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param _newOwner The address to transfer ownership to.
30      */
31 
32     function transferOwnership(address _newOwner) public onlyOwner {
33         require(_newOwner != address(0));
34         newOwner = _newOwner;
35     }
36 
37     function acceptOwnership() public {
38         if (msg.sender == newOwner) {
39             owner = newOwner;
40         }
41     }
42 }
43 
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
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
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90     using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 
196 contract MintableToken is StandardToken, Ownable {
197   event Mint(address indexed to, uint256 amount);
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will receive the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     Transfer(0x0, _to, _amount);
218     return true;
219   }
220 
221   /**
222    * @dev Function to stop minting new tokens.
223    * @return True if the operation was successful.
224    */
225   function finishMinting() onlyOwner public returns (bool) {
226     mintingFinished = true;
227     MintFinished();
228     return true;
229   }
230 }
231 
232 
233 contract LamdenTau is MintableToken {
234     string public constant name = "Lamden Tau";
235     string public constant symbol = "TAU";
236     uint8 public constant decimals = 18;
237 }
238 
239 contract Crowdsale {
240   using SafeMath for uint256;
241 
242   // The token being sold
243   MintableToken public token;
244 
245   // start and end timestamps where investments are allowed (both inclusive)
246   uint256 public startTime;
247   uint256 public endTime;
248 
249   // address where funds are collected
250   address public wallet;
251 
252   // how many token units a buyer gets per wei
253   uint256 public rate;
254 
255   // amount of raised money in wei
256   uint256 public weiRaised;
257 
258   /**
259    * event for token purchase logging
260    * @param purchaser who paid for the tokens
261    * @param beneficiary who got the tokens
262    * @param value weis paid for purchase
263    * @param amount amount of tokens purchased
264    */
265   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
266 
267 
268   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
269     //require(_startTime >= now);
270     require(_endTime >= _startTime);
271     require(_rate > 0);
272     //require(_wallet != 0x0);
273 
274     token = createTokenContract();
275     startTime = _startTime;
276     endTime = _endTime;
277     rate = _rate;
278     wallet = _wallet;
279   }
280 
281   // creates the token to be sold.
282   // override this method to have crowdsale of a specific mintable token.
283   function createTokenContract() internal returns (MintableToken) {
284     return new MintableToken();
285   }
286 
287 
288   // fallback function can be used to buy tokens
289   function () payable {
290     buyTokens(msg.sender);
291   }
292 
293   // low level token purchase function
294   function buyTokens(address beneficiary) public payable {
295     require(beneficiary != 0x0);
296     require(validPurchase());
297 
298     uint256 weiAmount = msg.value;
299 
300     // calculate token amount to be created
301     uint256 tokens = weiAmount.mul(rate);
302 
303     // update state
304     weiRaised = weiRaised.add(weiAmount);
305 
306     token.mint(beneficiary, tokens);
307     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
308 
309     forwardFunds();
310   }
311 
312   // send ether to the fund collection wallet
313   // override to create custom fund forwarding mechanisms
314   function forwardFunds() internal {
315     wallet.transfer(msg.value);
316   }
317 
318   // @return true if the transaction can buy tokens
319   function validPurchase() internal constant returns (bool) {
320     bool withinPeriod = now >= startTime && now <= endTime;
321     bool nonZeroPurchase = msg.value != 0;
322     return withinPeriod && nonZeroPurchase;
323   }
324 
325   // @return true if crowdsale event has ended
326   function hasEnded() public constant returns (bool) {
327     return now > endTime;
328   }
329 
330 
331 }
332 
333 contract CappedCrowdsale is Crowdsale {
334   using SafeMath for uint256;
335 
336   uint256 public cap;
337 
338   function CappedCrowdsale(uint256 _cap) {
339     require(_cap > 0);
340     cap = _cap;
341   }
342 
343   // overriding Crowdsale#validPurchase to add extra cap logic
344   // @return true if investors can buy at the moment
345   function validPurchase() internal constant returns (bool) {
346     bool withinCap = weiRaised.add(msg.value) <= cap;
347     return super.validPurchase() && withinCap;
348   }
349 
350   // overriding Crowdsale#hasEnded to add cap logic
351   // @return true if crowdsale event has ended
352   function hasEnded() public constant returns (bool) {
353     bool capReached = weiRaised >= cap;
354     return super.hasEnded() || capReached;
355   }
356 
357 }
358 contract Presale is CappedCrowdsale, Ownable {
359     using SafeMath for uint256;
360 
361     mapping (address => bool) public whitelist;
362 
363     bool public isFinalized = false;
364     event Finalized();
365     
366     address public team = 0x9c38c7e22cb20b055e008775617224d0ec25c91f;
367     uint256 public teamShare = 150000000 * (10 ** 18);
368     
369     address public seed = 0x3669ad54675E94e14196528786645c858b8391F1;
370     uint256 public seedShare = 6807960 * (10 ** 18);
371 
372     bool public hasAllocated = false;
373 
374     address public mediator = 0x0;
375     
376     function Presale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _tokenAddress) 
377     Crowdsale(_startTime, _endTime, _rate, _wallet)
378     CappedCrowdsale(_cap)
379     {
380         token = LamdenTau(_tokenAddress);
381     }
382     
383     // Crowdsale overrides
384     function createTokenContract() internal returns (MintableToken) {
385         return LamdenTau(0x0);
386     }
387 
388     function validPurchase() internal constant returns (bool) {
389         bool withinCap = weiRaised.add(msg.value) <= cap;
390         bool valid = super.validPurchase() && withinCap && whitelist[msg.sender];
391         return valid;
392     }
393     // * * *
394     
395     // Finalizer functions. Redefined from FinalizableCrowdsale to prevent diamond inheritence complexities
396     
397     function finalize() onlyOwner public {
398       require(mediator != 0x0);
399       require(!isFinalized);
400       require(hasEnded());
401       
402       finalization();
403       Finalized();
404 
405       isFinalized = true;
406     }
407     
408     function finalization() internal {
409         // set the ownership to the mediator so it can pass it onto the sale contract
410         // at the time that the sale contract is deployed
411         token.transferOwnership(mediator);
412         Mediator m = Mediator(mediator);
413         m.acceptToken();
414     }
415     // * * * 
416 
417     // Contract Specific functions
418     function assignMediator(address _m) public onlyOwner returns(bool) {
419         mediator = _m;
420         return true;
421     }
422     
423     function whitelistUser(address _a) public onlyOwner returns(bool){
424         whitelist[_a] = true;
425         return whitelist[_a];
426     }
427 
428     function whitelistUsers(address[] users) external onlyOwner {
429         for (uint i = 0; i < users.length; i++) {
430             whitelist[users[i]] = true;
431         }
432     }
433 
434     function unWhitelistUser(address _a) public onlyOwner returns(bool){
435         whitelist[_a] = false;
436         return whitelist[_a];
437     }
438 
439     function unWhitelistUsers(address[] users) external onlyOwner {
440         for (uint i = 0; i < users.length; i++) {
441             whitelist[users[i]] = false;
442         }
443     }
444     
445     function allocateTokens() public onlyOwner returns(bool) {
446         require(hasAllocated == false);
447         token.mint(team, teamShare);
448         token.mint(seed, seedShare);
449         hasAllocated = true;
450         return hasAllocated;
451     }
452     
453     function acceptToken() public onlyOwner returns(bool) {
454         token.acceptOwnership();
455         return true;
456     }
457 
458     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
459         require(_e > startTime);
460         endTime = _e;
461         return endTime;
462     }
463 
464     function mintTokens(uint256 tokenAmount) public onlyOwner {
465        require(!isFinalized);
466        token.mint(wallet, tokenAmount);
467     }
468     
469     // * * *
470 }
471 
472 contract Mediator is Ownable {
473     address public presale;
474     LamdenTau public tau;
475     address public sale;
476     
477     function setPresale(address p) public onlyOwner { presale = p; }
478     function setTau(address t) public onlyOwner { tau = LamdenTau(t); }
479     function setSale(address s) public onlyOwner { sale = s; }
480     
481     modifier onlyPresale {
482         require(msg.sender == presale);
483         _;
484     }
485     
486     modifier onlySale {
487         require(msg.sender == sale);
488         _;
489     }
490     
491     function acceptToken() public onlyPresale { tau.acceptOwnership(); }
492     function passOff() public onlySale { tau.transferOwnership(sale); }
493 }
494 
495 contract Sale is CappedCrowdsale, Ownable {
496     using SafeMath for uint256;
497 
498     // Initialization Variables
499     uint256 public amountPerDay; // 30 eth
500     uint256 public constant UNIX_DAY = 86400;
501 
502     bool public isFinalized = false;
503     event Finalized();
504 
505     mapping (address => bool) public whitelist;
506     mapping (address => uint256) public amountContributedBy;
507     // * * *
508 
509     // Constructor
510     function Sale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, uint256 _amountPerDay, address _tokenAddress)
511     Crowdsale(_startTime, _endTime, _rate, _wallet)
512     CappedCrowdsale(_cap)
513     {
514         amountPerDay = _amountPerDay;
515         token = LamdenTau(_tokenAddress);
516     }
517     // * * *
518     
519     // Crowdsale overrides
520     function createTokenContract() internal returns (MintableToken) {
521         return LamdenTau(0x0);
522     }
523     
524     function validPurchase() internal constant returns (bool) {
525         bool withinCap = weiRaised.add(msg.value) <= cap;
526         bool withinContributionLimit = msg.value <= currentPersonalLimit(msg.sender);
527         bool valid = super.validPurchase() && withinCap && whitelist[msg.sender] && withinContributionLimit;
528         return valid;
529     }
530 
531     function buyTokens(address beneficiary) public payable {
532         super.buyTokens(beneficiary);
533         amountContributedBy[msg.sender] = amountContributedBy[msg.sender].add(msg.value);
534     }
535     // * * *
536 
537     // Finalizer functions
538     function finalize() onlyOwner public {
539       require(!isFinalized);
540       require(hasEnded());
541 
542       finalization();
543       Finalized();
544 
545       isFinalized = true;
546     }
547     
548     function finalization() internal {
549         token.finishMinting();
550     }
551     // * * * 
552     
553     // Contract Specific functions
554     function daysSinceLaunch() public constant returns(uint256) {
555         return now.sub(startTime).div(UNIX_DAY);
556     }
557     
558     function currentContributionLimit() public constant returns(uint256) {
559         return amountPerDay.mul(2 ** daysSinceLaunch());
560     }
561     
562     function currentPersonalLimit(address _a) public constant returns(uint256) {
563         return currentContributionLimit().sub(amountContributedBy[_a]);
564     }
565     
566     function claimToken(address _m) public onlyOwner returns(bool) {
567         Mediator m = Mediator(_m);
568         m.passOff();
569         token.acceptOwnership();
570         return true;
571     }
572     
573     function whitelistUser(address _a) onlyOwner public returns(bool) {
574         whitelist[_a] = true;
575         return whitelist[_a];
576     }
577     
578     function whitelistUsers(address[] users) external onlyOwner {
579         for (uint i = 0; i < users.length; i++) {
580             whitelist[users[i]] = true;
581         }
582     }
583 
584     function unWhitelistUser(address _a) public onlyOwner returns(bool){
585         whitelist[_a] = false;
586         return whitelist[_a];
587     }
588 
589     function unWhitelistUsers(address[] users) external onlyOwner {
590         for (uint i = 0; i < users.length; i++) {
591             whitelist[users[i]] = false;
592         }
593     }
594 
595     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
596         require(_e > startTime);
597         endTime = _e;
598         return endTime;
599     }
600 
601     function mintTokens(uint256 tokenAmount) public onlyOwner {
602        require(!isFinalized);
603        token.mint(wallet, tokenAmount);
604     }
605     // * * *
606 }