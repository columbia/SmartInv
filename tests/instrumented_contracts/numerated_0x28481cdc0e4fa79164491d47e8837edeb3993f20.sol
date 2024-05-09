1 pragma solidity ^0.4.13;
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
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner public {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public constant returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract BurnableToken is StandardToken {
189 
190     event Burn(address indexed burner, uint256 value);
191 
192     /**
193      * @dev Burns a specific amount of tokens.
194      * @param _value The amount of token to be burned.
195      */
196     function burn(uint256 _value) public {
197         require(_value > 0);
198         require(_value <= balances[msg.sender]);
199         // no need to require value <= totalSupply, since that would imply the
200         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
201 
202         address burner = msg.sender;
203         balances[burner] = balances[burner].sub(_value);
204         totalSupply = totalSupply.sub(_value);
205         Burn(burner, _value);
206     }
207 }
208 
209 contract MintableToken is StandardToken, Ownable {
210   event Mint(address indexed to, uint256 amount);
211   event MintFinished();
212 
213   bool public mintingFinished = false;
214 
215 
216   modifier canMint() {
217     require(!mintingFinished);
218     _;
219   }
220 
221   /**
222    * @dev Function to mint tokens
223    * @param _to The address that will receive the minted tokens.
224    * @param _amount The amount of tokens to mint.
225    * @return A boolean that indicates if the operation was successful.
226    */
227   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
228     totalSupply = totalSupply.add(_amount);
229     balances[_to] = balances[_to].add(_amount);
230     Mint(_to, _amount);
231     Transfer(0x0, _to, _amount);
232     return true;
233   }
234 
235   /**
236    * @dev Function to stop minting new tokens.
237    * @return True if the operation was successful.
238    */
239   function finishMinting() onlyOwner public returns (bool) {
240     mintingFinished = true;
241     MintFinished();
242     return true;
243   }
244 }
245 
246 contract TssToken is MintableToken, BurnableToken {
247     string public constant name = "TssToken";
248     string public constant symbol = "TSS";
249     uint256 public constant decimals = 18;
250 
251     function TssToken(address initialAccount, uint256 initialBalance) public {
252         balances[initialAccount] = initialBalance;
253         totalSupply = initialBalance;
254   }
255 }
256 
257 contract Crowdsale {
258   using SafeMath for uint256;
259 
260   // The token being sold
261   MintableToken public token;
262 
263   // start and end timestamps where investments are allowed (both inclusive)
264   uint256 public startTime;
265   uint256 public endTime;
266 
267   // address where funds are collected
268   address public wallet;
269 
270   // how many token units a buyer gets per wei
271   uint256 public rate;
272 
273   // amount of raised money in wei
274   uint256 public weiRaised;
275 
276   /**
277    * event for token purchase logging
278    * @param purchaser who paid for the tokens
279    * @param beneficiary who got the tokens
280    * @param value weis paid for purchase
281    * @param amount amount of tokens purchased
282    */
283   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
284 
285   event Debug(bytes32 text, uint256);
286 
287   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
288     require(_startTime >= now);
289     require(_endTime >= _startTime);
290     require(_rate > 0);
291     require(_wallet != 0x0);
292 
293     token = createTokenContract();
294     startTime = _startTime;
295     endTime = _endTime;
296     rate = _rate;
297     wallet = _wallet;
298   }
299 
300   // creates the token to be sold.
301   // override this method to have crowdsale of a specific mintable token.
302   function createTokenContract() internal returns (MintableToken) {
303     return new MintableToken();
304   }
305 
306 
307   // fallback function can be used to buy tokens
308   function () payable {
309     buyTokens(msg.sender);
310   }
311 
312   // low level token purchase function
313   function buyTokens(address beneficiary) public payable {
314     require(beneficiary != 0x0);
315     require(validPurchase());
316 
317     uint256 weiAmount = msg.value;
318 
319     // calculate token amount to be created
320     uint256 tokens = weiAmount.mul(rate);
321 
322     // update state
323     weiRaised = weiRaised.add(weiAmount);
324 
325     token.mint(beneficiary, tokens);
326     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
327 
328     forwardFunds();
329   }
330 
331   // send ether to the fund collection wallet
332   // override to create custom fund forwarding mechanisms
333   function forwardFunds() internal {
334     wallet.transfer(msg.value);
335   }
336 
337   // @return true if the transaction can buy tokens
338   function validPurchase() internal constant returns (bool) {
339     bool withinPeriod = now >= startTime && now <= endTime;
340     bool nonZeroPurchase = msg.value != 0;
341     return withinPeriod && nonZeroPurchase;
342   }
343 
344   // @return true if crowdsale event has ended
345   function hasEnded() public constant returns (bool) {
346     return now > endTime;
347   }
348 
349 
350 }
351 
352 contract Pausable is Ownable {
353   event Pause();
354   event Unpause();
355 
356   bool public paused = false;
357 
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is not paused.
361    */
362   modifier whenNotPaused() {
363     require(!paused);
364     _;
365   }
366 
367   /**
368    * @dev Modifier to make a function callable only when the contract is paused.
369    */
370   modifier whenPaused() {
371     require(paused);
372     _;
373   }
374 
375   /**
376    * @dev called by the owner to pause, triggers stopped state
377    */
378   function pause() onlyOwner whenNotPaused public {
379     paused = true;
380     Pause();
381   }
382 
383   /**
384    * @dev called by the owner to unpause, returns to normal state
385    */
386   function unpause() onlyOwner whenPaused public {
387     paused = false;
388     Unpause();
389   }
390 }
391 
392 contract TssCrowdsale is Crowdsale, Pausable {
393     enum LifecycleStage {
394     DEPLOYMENT,
395     MINTING,
396     PRESALE,
397     CROWDSALE_PHASE_1,
398     CROWDSALE_PHASE_2,
399     CROWDSALE_PHASE_3,
400     POSTSALE
401     }
402 
403     uint256 public CROWDSALE_PHASE_1_START;
404 
405     uint256 public CROWDSALE_PHASE_2_START;
406 
407     uint256 public CROWDSALE_PHASE_3_START;
408 
409     uint256 public POSTSALE_START;
410 
411     address public FOUNDER_WALLET;
412 
413     address public BOUNTY_WALLET;
414 
415     address public FUTURE_WALLET;
416 
417     address public CROWDSALE_WALLET;
418 
419     address public PRESALE_WALLET;
420 
421     address PROCEEDS_WALLET;
422 
423 
424     LifecycleStage public currentStage;
425 
426     function assertValidParameters() internal {
427         require(CROWDSALE_PHASE_1_START > 0);
428         require(CROWDSALE_PHASE_2_START > 0);
429         require(CROWDSALE_PHASE_3_START > 0);
430         require(POSTSALE_START > 0);
431 
432         require(address(FOUNDER_WALLET) != 0);
433         require(address(BOUNTY_WALLET) != 0);
434         require(address(FUTURE_WALLET) != 0);
435     }
436 
437     /**
438      * Used for forcing ensureStage modifier
439      */
440     function setCurrentStage() onlyOwner ensureStage returns (bool) {
441         return true;
442     }
443 
444     modifier ensureStage() {
445         if (token.mintingFinished()) {
446             if (now < CROWDSALE_PHASE_1_START) {currentStage = LifecycleStage.PRESALE;}
447             else if (now < CROWDSALE_PHASE_2_START) {currentStage = LifecycleStage.CROWDSALE_PHASE_1;}
448             else if (now < CROWDSALE_PHASE_3_START) {currentStage = LifecycleStage.CROWDSALE_PHASE_2;}
449             else if (now < POSTSALE_START) {currentStage = LifecycleStage.CROWDSALE_PHASE_3;}
450             else {currentStage = LifecycleStage.POSTSALE;}
451         }
452         _;
453     }
454 
455     function getCurrentRate() constant returns (uint _rate) {
456 
457         if (currentStage == LifecycleStage.CROWDSALE_PHASE_1) {_rate = 1150;}
458         else if (currentStage == LifecycleStage.CROWDSALE_PHASE_2) {_rate = 1100;}
459         else if (currentStage == LifecycleStage.CROWDSALE_PHASE_3) {_rate = 1050;}
460         else {_rate == 0;}
461 
462         return _rate;
463     }
464 
465     function TssCrowdsale(
466     uint256 _rate,
467     address _wallet,
468 
469     uint256 _phase_1_start,
470     uint256 _phase_2_start,
471     uint256 _phase_3_start,
472     uint256 _postsale_start,
473 
474     address _founder_wallet,
475     address _bounty_wallet,
476     address _future_wallet,
477     address _presale_wallet)
478 
479     public
480     Crowdsale(_phase_1_start, _postsale_start, _rate, _wallet)
481     {
482         // Initialise date milestones
483         CROWDSALE_PHASE_1_START = _phase_1_start;
484         CROWDSALE_PHASE_2_START = _phase_2_start;
485         CROWDSALE_PHASE_3_START = _phase_3_start;
486         POSTSALE_START = _postsale_start;
487 
488         // Initialise Wallet Addresses
489 
490         FOUNDER_WALLET = _founder_wallet;
491         BOUNTY_WALLET = _bounty_wallet;
492         FUTURE_WALLET = _future_wallet;
493         PRESALE_WALLET = _presale_wallet;
494 
495         CROWDSALE_WALLET = address(this);
496 
497         assertValidParameters();
498 
499         // Mint Tokens
500         currentStage = LifecycleStage.MINTING;
501         mintTokens();
502         token.finishMinting();
503 
504         currentStage = LifecycleStage.PRESALE;
505     }
506 
507     function mintTokens() internal {
508 
509         /**  Token Initial Distribution
510          *   100 000 000 to founder wallet
511          *   25 000 000 to bounty wallet
512          *   275 000 000 to future wallet
513          *   97 000 000 to crowdsale wallet
514          *   3 000 000 to presale wallet
515          */
516 
517         TssToken _token = TssToken(token);
518         token.mint(FOUNDER_WALLET, 100000000 * 10 ** _token.decimals());
519         token.mint(BOUNTY_WALLET, 25000000 * 10 ** _token.decimals());
520         token.mint(FUTURE_WALLET, 275000000 * 10 ** _token.decimals());
521         token.mint(CROWDSALE_WALLET, 97000000 * 10 ** _token.decimals());
522         token.mint(PRESALE_WALLET, 3000000 * 10 ** _token.decimals());
523     }
524 
525     /**
526      * Overrides Crowdsale.buyTokens()
527      */
528     function buyTokens(address beneficiary) public
529     payable
530     whenNotPaused()
531     ensureStage()
532     {
533         require(beneficiary != 0x0);
534         require(validPurchase());
535 
536         uint256 weiAmount = msg.value;
537 
538         // calculate token amount to be created
539         uint256 tokens = weiAmount.mul(getCurrentRate());
540 
541         // update state
542         weiRaised = weiRaised.add(weiAmount);
543 
544         token.transfer(beneficiary, tokens);
545         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
546 
547         forwardFunds();
548     }
549 
550     /**
551       * Overrides Crowdsale.validPurchase()
552      */
553     function validPurchase() internal constant returns (bool) {
554         bool withinPeriod = currentStage >= LifecycleStage.CROWDSALE_PHASE_1 && currentStage <= LifecycleStage.CROWDSALE_PHASE_3;
555         bool minimumPurchase = msg.value > 0.01 ether;
556         return withinPeriod && minimumPurchase;
557     }
558 
559     /**
560     * Overrides Crowdsale.createTokenContract()
561     */
562     function createTokenContract() internal returns (MintableToken) {
563         return new TssToken(0x0, 0);
564     }
565 
566     event CoinsRetrieved(address indexed recipient, uint amount);    
567 
568     function retrieveRemainingCoinsPostSale() 
569         public
570         onlyOwner 
571         ensureStage() 
572     {
573         require(currentStage == LifecycleStage.POSTSALE);
574 
575         uint coinBalance = token.balanceOf(CROWDSALE_WALLET);
576         token.transfer(FUTURE_WALLET, coinBalance);
577         CoinsRetrieved(FUTURE_WALLET, coinBalance);
578     }
579 
580     /** 
581         There shouldn't be any funds trapped in this contract 
582         but as a failsafe if there are any funds whatsoever, this function exists
583      */
584     function retrieveFunds() 
585         public
586         onlyOwner
587     {
588         owner.transfer(this.balance);
589     }
590 
591 }