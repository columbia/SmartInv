1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     require(newOwner != address(0));      
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 contract Crowdsale {
76   using SafeMath for uint256;
77 
78   // The token being sold
79   MintableToken public token;
80 
81   // start and end timestamps where investments are allowed (both inclusive)
82   uint256 public startTime;
83   uint256 public endTime;
84 
85   // address where funds are collected
86   address public wallet;
87 
88   // how many token units a buyer gets per wei
89   uint256 public rate;
90 
91   // amount of raised money in wei
92   uint256 public weiRaised;
93 
94   /**
95    * event for token purchase logging
96    * @param purchaser who paid for the tokens
97    * @param beneficiary who got the tokens
98    * @param value weis paid for purchase
99    * @param amount amount of tokens purchased
100    */ 
101   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
102 
103 
104   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
105     require(_startTime >= now);
106     require(_endTime >= _startTime);
107     require(_rate > 0);
108     require(_wallet != 0x0);
109 
110     token = createTokenContract();
111     startTime = _startTime;
112     endTime = _endTime;
113     rate = _rate;
114     wallet = _wallet;
115   }
116 
117   // creates the token to be sold. 
118   // override this method to have crowdsale of a specific mintable token.
119   function createTokenContract() internal returns (MintableToken) {
120     return new MintableToken();
121   }
122 
123 
124   // fallback function can be used to buy tokens
125   function () payable {
126     buyTokens(msg.sender);
127   }
128 
129   // low level token purchase function
130   function buyTokens(address beneficiary) payable {
131     require(beneficiary != 0x0);
132     require(validPurchase());
133 
134     uint256 weiAmount = msg.value;
135 
136     // calculate token amount to be created
137     uint256 tokens = weiAmount.mul(rate);
138 
139     // update state
140     weiRaised = weiRaised.add(weiAmount);
141 
142     token.mint(beneficiary, tokens);
143     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
144 
145     forwardFunds();
146   }
147 
148   // send ether to the fund collection wallet
149   // override to create custom fund forwarding mechanisms
150   function forwardFunds() internal {
151     wallet.transfer(msg.value);
152   }
153 
154   // @return true if the transaction can buy tokens
155   function validPurchase() internal constant returns (bool) {
156     bool withinPeriod = now >= startTime && now <= endTime;
157     bool nonZeroPurchase = msg.value != 0;
158     return withinPeriod && nonZeroPurchase;
159   }
160 
161   // @return true if crowdsale event has ended
162   function hasEnded() public constant returns (bool) {
163     return now > endTime;
164   }
165 
166 
167 }
168 
169 
170 contract CappedCrowdsale is Crowdsale {
171   using SafeMath for uint256;
172 
173   uint256 public cap;
174 
175   function CappedCrowdsale(uint256 _cap) {
176     require(_cap > 0);
177     cap = _cap;
178   }
179 
180   // overriding Crowdsale#validPurchase to add extra cap logic
181   // @return true if investors can buy at the moment
182   function validPurchase() internal constant returns (bool) {
183     bool withinCap = weiRaised.add(msg.value) <= cap;
184     return super.validPurchase() && withinCap;
185   }
186 
187   // overriding Crowdsale#hasEnded to add cap logic
188   // @return true if crowdsale event has ended
189   function hasEnded() public constant returns (bool) {
190     bool capReached = weiRaised >= cap;
191     return super.hasEnded() || capReached;
192   }
193 
194 }
195 
196 contract WithdrawVault is Ownable {
197     using SafeMath for uint256;
198 
199     mapping (address => uint256) public deposited;
200     address public wallet;
201 
202 
203     function WithdrawVault(address _wallet) {
204         require(_wallet != 0x0);
205         wallet = _wallet;
206     }
207 
208     function deposit(address investor) onlyOwner payable {
209         deposited[investor] = deposited[investor].add(msg.value);
210     }
211 
212     function close() onlyOwner {
213         wallet.transfer(this.balance);
214     }
215 
216 }
217 
218 
219 
220 
221 contract ERC20Basic {
222   uint256 public totalSupply;
223   function balanceOf(address who) constant returns (uint256);
224   function transfer(address to, uint256 value) returns (bool);
225   event Transfer(address indexed from, address indexed to, uint256 value);
226 }
227 
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender) constant returns (uint256);
230   function transferFrom(address from, address to, uint256 value) returns (bool);
231   function approve(address spender, uint256 value) returns (bool);
232   event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 contract BasicToken is ERC20Basic {
236   using SafeMath for uint256;
237 
238   mapping(address => uint256) balances;
239 
240   /**
241   * @dev transfer token for a specified address
242   * @param _to The address to transfer to.
243   * @param _value The amount to be transferred.
244   */
245   function transfer(address _to, uint256 _value) returns (bool) {
246     require(_to != address(0));
247 
248     // SafeMath.sub will throw if there is not enough balance.
249     balances[msg.sender] = balances[msg.sender].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     Transfer(msg.sender, _to, _value);
252     return true;
253   }
254 
255   /**
256   * @dev Gets the balance of the specified address.
257   * @param _owner The address to query the the balance of. 
258   * @return An uint256 representing the amount owned by the passed address.
259   */
260   function balanceOf(address _owner) constant returns (uint256 balance) {
261     return balances[_owner];
262   }
263 
264 }
265 
266 contract StandardToken is ERC20, BasicToken {
267 
268   mapping (address => mapping (address => uint256)) allowed;
269 
270 
271   /**
272    * @dev Transfer tokens from one address to another
273    * @param _from address The address which you want to send tokens from
274    * @param _to address The address which you want to transfer to
275    * @param _value uint256 the amount of tokens to be transferred
276    */
277   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
278     require(_to != address(0));
279 
280     var _allowance = allowed[_from][msg.sender];
281 
282     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
283     // require (_value <= _allowance);
284 
285     balances[_from] = balances[_from].sub(_value);
286     balances[_to] = balances[_to].add(_value);
287     allowed[_from][msg.sender] = _allowance.sub(_value);
288     Transfer(_from, _to, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
294    * @param _spender The address which will spend the funds.
295    * @param _value The amount of tokens to be spent.
296    */
297   function approve(address _spender, uint256 _value) returns (bool) {
298 
299     // To change the approve amount you first have to reduce the addresses`
300     //  allowance to zero by calling `approve(_spender, 0)` if it is not
301     //  already 0 to mitigate the race condition described here:
302     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
304 
305     allowed[msg.sender][_spender] = _value;
306     Approval(msg.sender, _spender, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Function to check the amount of tokens that an owner allowed to a spender.
312    * @param _owner address The address which owns the funds.
313    * @param _spender address The address which will spend the funds.
314    * @return A uint256 specifying the amount of tokens still available for the spender.
315    */
316   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
317     return allowed[_owner][_spender];
318   }
319   
320   /**
321    * approve should be called when allowed[_spender] == 0. To increment
322    * allowed value is better to use this function to avoid 2 calls (and wait until 
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    */
326   function increaseApproval (address _spender, uint _addedValue) 
327     returns (bool success) {
328     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
329     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   function decreaseApproval (address _spender, uint _subtractedValue) 
334     returns (bool success) {
335     uint oldValue = allowed[msg.sender][_spender];
336     if (_subtractedValue > oldValue) {
337       allowed[msg.sender][_spender] = 0;
338     } else {
339       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
340     }
341     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345 }
346 
347 contract BurnableToken is StandardToken {
348 
349     /**
350      * @dev Burns a specific amount of tokens.
351      * @param _value The amount of token to be burned.
352      */
353     function burn(uint _value)
354         public
355     {
356         require(_value > 0);
357 
358         address burner = msg.sender;
359         balances[burner] = balances[burner].sub(_value);
360         totalSupply = totalSupply.sub(_value);
361         Burn(burner, _value);
362     }
363 
364     event Burn(address indexed burner, uint indexed value);
365 }
366 
367 contract MintableToken is StandardToken, Ownable {
368   event Mint(address indexed to, uint256 amount);
369   event MintFinished();
370 
371   bool public mintingFinished = false;
372 
373 
374   modifier canMint() {
375     require(!mintingFinished);
376     _;
377   }
378 
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
386     totalSupply = totalSupply.add(_amount);
387     balances[_to] = balances[_to].add(_amount);
388     Mint(_to, _amount);
389     Transfer(0x0, _to, _amount);
390     return true;
391   }
392 
393   /**
394    * @dev Function to stop minting new tokens.
395    * @return True if the operation was successful.
396    */
397   function finishMinting() onlyOwner returns (bool) {
398     mintingFinished = true;
399     MintFinished();
400     return true;
401   }
402 }
403 
404 
405 
406 
407 contract FinalizableCrowdsale is Crowdsale, Ownable {
408   using SafeMath for uint256;
409 
410   bool public isFinalized = false;
411 
412   event Finalized();
413 
414   /**
415    * @dev Must be called after crowdsale ends, to do some extra finalization
416    * work. Calls the contract's finalization function.
417    */
418   function finalize() onlyOwner {
419     require(!isFinalized);
420     require(hasEnded());
421 
422     finalization();
423     Finalized();
424     
425     isFinalized = true;
426   }
427 
428   /**
429    * @dev Can be overriden to add finalization logic. The overriding function
430    * should call super.finalization() to ensure the chain of finalization is
431    * executed entirely.
432    */
433   function finalization() internal {
434   }
435 }
436 
437 contract RefundVault is Ownable {
438   using SafeMath for uint256;
439 
440   enum State { Active, Refunding, Closed }
441 
442   mapping (address => uint256) public deposited;
443   address public wallet;
444   State public state;
445 
446   event Closed();
447   event RefundsEnabled();
448   event Refunded(address indexed beneficiary, uint256 weiAmount);
449 
450   function RefundVault(address _wallet) {
451     require(_wallet != 0x0);
452     wallet = _wallet;
453     state = State.Active;
454   }
455 
456   function deposit(address investor) onlyOwner payable {
457     deposited[investor] = deposited[investor].add(msg.value);
458   }
459 
460   function close() onlyOwner {
461     require(state == State.Active);
462     state = State.Closed;
463     Closed();
464     wallet.transfer(this.balance);
465   }
466 
467   function enableRefunds() onlyOwner {
468     require(state == State.Active);
469     state = State.Refunding;
470     RefundsEnabled();
471   }
472 
473   function refund(address investor) {
474     require(state == State.Refunding);
475     uint256 depositedValue = deposited[investor];
476     deposited[investor] = 0;
477     investor.transfer(depositedValue);
478     Refunded(investor, depositedValue);
479   }
480 }
481 
482 
483 
484 
485 
486 contract Pausable is Ownable {
487   event Pause();
488   event Unpause();
489 
490   bool public paused = false;
491 
492 
493   /**
494    * @dev Modifier to make a function callable only when the contract is not paused.
495    */
496   modifier whenNotPaused() {
497     require(!paused);
498     _;
499   }
500 
501   /**
502    * @dev Modifier to make a function callable only when the contract is paused.
503    */
504   modifier whenPaused() {
505     require(paused);
506     _;
507   }
508 
509   /**
510    * @dev called by the owner to pause, triggers stopped state
511    */
512   function pause() onlyOwner whenNotPaused public {
513     paused = true;
514     Pause();
515   }
516 
517   /**
518    * @dev called by the owner to unpause, returns to normal state
519    */
520   function unpause() onlyOwner whenPaused public {
521     paused = false;
522     Unpause();
523   }
524 }
525 
526 contract PausableToken is StandardToken, Pausable {
527 
528   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
529     return super.transfer(_to, _value);
530   }
531 
532   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
533     return super.transferFrom(_from, _to, _value);
534   }
535 
536   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
537     return super.approve(_spender, _value);
538   }
539 
540   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
541     return super.increaseApproval(_spender, _addedValue);
542   }
543 
544   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
545     return super.decreaseApproval(_spender, _subtractedValue);
546   }
547 }
548 
549 
550 
551 
552 contract TokenRecipient {
553 
554     function tokenFallback(address sender, uint256 _value, bytes _extraData) returns (bool) {}
555 
556 }
557 
558 
559 
560 
561 
562 contract liebescoin is MintableToken, BurnableToken, PausableToken {
563 
564     string public constant name = "liebescoin";
565     string public constant symbol = "LIEB";
566     uint8 public constant decimals =0;
567 
568 
569     function liebescoin() {
570 
571     }
572 
573 
574     // --------------------------------------------------------
575 
576     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
577         bool result = super.transferFrom(_from, _to, _value);
578         return result;
579     }
580 
581     mapping (address => bool) stopReceive;
582 
583     function setStopReceive(bool stop) {
584         stopReceive[msg.sender] = stop;
585     }
586 
587     function getStopReceive() constant public returns (bool) {
588         return stopReceive[msg.sender];
589     }
590 
591     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
592         require(!stopReceive[_to]);
593         bool result = super.transfer(_to, _value);
594         return result;
595     }
596 
597 
598     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
599         bool result = super.mint(_to, _amount);
600         return result;
601     }
602 
603     function burn(uint256 _value) public {
604         super.burn(_value);
605     }
606    
607     function pause() onlyOwner whenNotPaused public {
608         super.pause();
609     }
610    
611     function unpause() onlyOwner whenPaused public {
612         super.unpause();
613     }
614 
615     function transferAndCall(address _recipient, uint256 _amount, bytes _data) {
616         require(_recipient != address(0));
617         require(_amount <= balances[msg.sender]);
618 
619         balances[msg.sender] = balances[msg.sender].sub(_amount);
620         balances[_recipient] = balances[_recipient].add(_amount);
621 
622         require(TokenRecipient(_recipient).tokenFallback(msg.sender, _amount, _data));
623         Transfer(msg.sender, _recipient, _amount);
624     }
625 
626 }