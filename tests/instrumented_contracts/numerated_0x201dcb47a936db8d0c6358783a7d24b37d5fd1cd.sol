1 pragma solidity ^0.4.13;
2 
3 contract ReentrancyGuard {
4 
5   /**
6    * @dev We use a single lock for the whole contract.
7    */
8   bool private reentrancy_lock = false;
9 
10   /**
11    * @dev Prevents a contract from calling itself, directly or indirectly.
12    * @notice If you mark a function `nonReentrant`, you should also
13    * mark it `external`. Calling one nonReentrant function from
14    * another is not supported. Instead, you can implement a
15    * `private` function doing the actual work, and a `external`
16    * wrapper marked as `nonReentrant`.
17    */
18   modifier nonReentrant() {
19     require(!reentrancy_lock);
20     reentrancy_lock = true;
21     _;
22     reentrancy_lock = false;
23   }
24 
25 }
26 
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract RefundVault is Ownable {
94   using SafeMath for uint256;
95 
96   enum State { Active, Refunding, Closed }
97 
98   mapping (address => uint256) public deposited;
99   address public wallet;
100   State public state;
101 
102   event Closed();
103   event RefundsEnabled();
104   event Refunded(address indexed beneficiary, uint256 weiAmount);
105 
106   function RefundVault(address _wallet) public {
107     require(_wallet != address(0));
108     wallet = _wallet;
109     state = State.Active;
110   }
111 
112   function deposit(address investor) onlyOwner public payable {
113     require(state == State.Active);
114     deposited[investor] = deposited[investor].add(msg.value);
115   }
116 
117   function close() onlyOwner public {
118     require(state == State.Active);
119     state = State.Closed;
120     Closed();
121     wallet.transfer(this.balance);
122   }
123 
124   function enableRefunds() onlyOwner public {
125     require(state == State.Active);
126     state = State.Refunding;
127     RefundsEnabled();
128   }
129 
130   function refund(address investor) public {
131     require(state == State.Refunding);
132     uint256 depositedValue = deposited[investor];
133     deposited[investor] = 0;
134     investor.transfer(depositedValue);
135     Refunded(investor, depositedValue);
136   }
137 }
138 
139 contract Pausable is Ownable {
140   event Pause();
141   event Unpause();
142 
143   bool public paused = false;
144 
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is not paused.
148    */
149   modifier whenNotPaused() {
150     require(!paused);
151     _;
152   }
153 
154   /**
155    * @dev Modifier to make a function callable only when the contract is paused.
156    */
157   modifier whenPaused() {
158     require(paused);
159     _;
160   }
161 
162   /**
163    * @dev called by the owner to pause, triggers stopped state
164    */
165   function pause() onlyOwner whenNotPaused public {
166     paused = true;
167     Pause();
168   }
169 
170   /**
171    * @dev called by the owner to unpause, returns to normal state
172    */
173   function unpause() onlyOwner whenPaused public {
174     paused = false;
175     Unpause();
176   }
177 }
178 
179 contract ERC20Basic {
180   uint256 public totalSupply;
181   function balanceOf(address who) public view returns (uint256);
182   function transfer(address to, uint256 value) public returns (bool);
183   event Transfer(address indexed from, address indexed to, uint256 value);
184 }
185 
186 contract BasicToken is ERC20Basic {
187   using SafeMath for uint256;
188 
189   mapping(address => uint256) balances;
190 
191   /**
192   * @dev transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[msg.sender]);
199 
200     // SafeMath.sub will throw if there is not enough balance.
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256 balance) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 contract BurnableToken is BasicToken {
219 
220     event Burn(address indexed burner, uint256 value);
221 
222     /**
223      * @dev Burns a specific amount of tokens.
224      * @param _value The amount of token to be burned.
225      */
226     function burn(uint256 _value) public {
227         require(_value <= balances[msg.sender]);
228         // no need to require value <= totalSupply, since that would imply the
229         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
230 
231         address burner = msg.sender;
232         balances[burner] = balances[burner].sub(_value);
233         totalSupply = totalSupply.sub(_value);
234         Burn(burner, _value);
235     }
236 }
237 
238 contract ERC20 is ERC20Basic {
239   function allowance(address owner, address spender) public view returns (uint256);
240   function transferFrom(address from, address to, uint256 value) public returns (bool);
241   function approve(address spender, uint256 value) public returns (bool);
242   event Approval(address indexed owner, address indexed spender, uint256 value);
243 }
244 
245 contract StandardToken is ERC20, BasicToken {
246 
247   mapping (address => mapping (address => uint256)) internal allowed;
248 
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(address _owner, address _spender) public view returns (uint256) {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * @dev Increase the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _addedValue The amount of tokens to increase the allowance by.
303    */
304   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
305     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
306     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310   /**
311    * @dev Decrease the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
321     uint oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 contract PausableToken is StandardToken, Pausable {
334 
335   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
336     return super.transfer(_to, _value);
337   }
338 
339   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transferFrom(_from, _to, _value);
341   }
342 
343   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
344     return super.approve(_spender, _value);
345   }
346 
347   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
348     return super.increaseApproval(_spender, _addedValue);
349   }
350 
351   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
352     return super.decreaseApproval(_spender, _subtractedValue);
353   }
354 }
355 
356 contract DataWalletCrowdsale is Ownable, ReentrancyGuard {
357     using SafeMath for uint256;
358 
359     // We have a window in the first 24hrs that permits to allocate all whitelist 
360     // participants with an equal distribution => firstDayCap = cap / whitelist participants.
361     uint256 public firstDayCap;
362     uint256 public cap;
363     uint256 public goal;
364     uint256 public rate;
365     uint256 public constant WEI_TO_INSIGHTS = 10**uint256(10);
366 
367 
368     RefundVault public vault;
369     DataWalletToken public token;
370 
371     uint256 public startTime;
372     uint256 public endTime;
373     uint256 public firstDay;
374 
375     bool public isFinalized = false;
376     uint256 public weiRaised;
377 
378     mapping(address => bool) public whitelist;
379     mapping(address => uint256) public contribution;
380     
381     event WhitelistUpdate(address indexed purchaser, bool status);
382     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
383     event TokenRefund(address indexed refundee, uint256 amount);
384 
385     event Finalized();
386     
387 
388     function DataWalletCrowdsale(
389         address _token, 
390         address _wallet,
391         uint256 _startTime,
392         uint256 _endTime,
393         uint256 _rate,
394         uint256 _cap,
395         uint256 _firstDayCap,
396         uint256 _goal
397     ) {
398         require(_startTime >= getBlockTimestamp());
399         require(_endTime >= _startTime);
400         require(_rate > 0);
401         require(_goal > 0);
402         require(_cap > 0);
403         require(_wallet != 0x0);
404 
405         vault = new RefundVault(_wallet);
406         token = DataWalletToken(_token);
407         startTime = _startTime;
408         endTime = _endTime;
409         firstDay = startTime + 1 * 1 days;
410         firstDayCap = _firstDayCap;
411         rate = _rate;
412         goal = _goal;
413         cap = _cap;
414     }
415 
416     // fallback function can be used to buy tokens
417     function () external payable {
418         buyTokens(msg.sender);
419     }
420 
421     //low level function to buy tokens
422     function buyTokens(address beneficiary) internal {
423         require(beneficiary != 0x0);
424         require(whitelist[beneficiary]);
425         require(validPurchase());
426 
427         //derive amount in wei to buy 
428         uint256 weiAmount = msg.value;
429 
430         // check if contribution is in the first 24h hours
431         if (getBlockTimestamp() <= firstDay) {
432             require((contribution[beneficiary].add(weiAmount)) <= firstDayCap);
433         }
434         //check if there is enough funds 
435         uint256 remainingToFund = cap.sub(weiRaised);
436         if (weiAmount > remainingToFund) {
437             weiAmount = remainingToFund;
438         }
439         uint256 weiToReturn = msg.value.sub(weiAmount);
440         //Forward funs to the vault 
441         forwardFunds(weiAmount);
442         //refund if the contribution exceed the cap
443         if (weiToReturn > 0) {
444             beneficiary.transfer(weiToReturn);
445             TokenRefund(beneficiary, weiToReturn);
446         }
447         //derive how many tokens
448         uint256 tokens = getTokens(weiAmount);
449         //update the state of weiRaised
450         weiRaised = weiRaised.add(weiAmount);
451         contribution[beneficiary] = contribution[beneficiary].add(weiAmount);
452      
453         //Trigger the event of TokenPurchase
454         TokenPurchase(beneficiary, weiAmount, tokens);
455 
456         token.transfer(beneficiary, tokens); 
457     }
458 
459     function getTokens(uint256 amount) internal constant returns (uint256) {
460         return amount.mul(rate).div(WEI_TO_INSIGHTS);
461     }
462 
463     // contributors can claim refund if the goal is not reached
464     function claimRefund() nonReentrant external {
465         require(isFinalized);
466         require(!goalReached());
467         vault.refund(msg.sender);
468     }
469 
470     //in case of endTime before the reach of the cap, the owner can claim the unsold tokens
471     function claimUnsold() onlyOwner {
472         require(endTime <= getBlockTimestamp());
473         uint256 unsold = token.balanceOf(this);
474 
475         if (unsold > 0) {
476             require(token.transfer(msg.sender, unsold));
477         }
478     }
479 
480     // add/remove to whitelist array of addresses based on boolean status
481     function updateWhitelist(address[] addresses, bool status) public onlyOwner {
482         for (uint256 i = 0; i < addresses.length; i++) {
483             address contributorAddress = addresses[i];
484             whitelist[contributorAddress] = status;
485             WhitelistUpdate(contributorAddress, status);
486         }
487     }
488 
489     //Only owner can manually finalize the sale
490     function finalize() onlyOwner {
491         require(!isFinalized);
492         require(hasEnded());
493 
494         //update the sate of isFinalized
495         isFinalized = true;
496         //trigger and emit the event of finalization
497         Finalized();
498 
499         if (goalReached()) {
500             //Close the vault
501             vault.close();
502             //Unpause the token 
503             token.unpause();
504             //give ownership back to deployer
505             token.transferOwnership(owner);
506         } else {
507             //else enable refunds
508             vault.enableRefunds();
509         }
510     } 
511 
512     // send ether to the fund collection wallet, the vault in this case
513     function forwardFunds(uint256 weiAmount) internal {
514         vault.deposit.value(weiAmount)(msg.sender);
515     }
516 
517     // @return true if crowdsale event has ended or cap reached
518     function hasEnded() public constant returns (bool) {
519         bool passedEndTime = getBlockTimestamp() > endTime;
520         return passedEndTime || capReached();
521     }
522 
523     function capReached() public constant returns (bool) {
524         return weiRaised >= cap;
525     }
526 
527     function goalReached() public constant returns (bool) {
528         return weiRaised >= goal;
529     }
530 
531     function isWhitelisted(address contributor) public constant returns (bool) {
532         return whitelist[contributor];
533     }
534 
535     // @return true if the transaction can buy tokens
536     function validPurchase() internal constant returns (bool) {
537         bool withinPeriod = getBlockTimestamp() >= startTime && getBlockTimestamp() <= endTime;
538         bool nonZeroPurchase = msg.value != 0;
539         bool capNotReached = weiRaised < cap;
540         return withinPeriod && nonZeroPurchase && capNotReached;
541     }
542 
543     function getBlockTimestamp() internal constant returns (uint256) {
544         return block.timestamp;
545     }
546 }
547 
548 contract DataWalletToken is PausableToken, BurnableToken {
549 
550     string public constant name = "DataWallet Token";
551     string public constant symbol = "DXT";
552     uint8 public constant decimals = 8;
553     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
554     
555     /**
556     * @dev DataWalletToken Constructor
557     */
558 
559     function DataWalletToken() public {
560         totalSupply = INITIAL_SUPPLY;   
561         balances[msg.sender] = INITIAL_SUPPLY;
562     }
563 
564     function transfer(address beneficiary, uint256 amount) public returns (bool) {
565         if (msg.sender != owner) {
566             require(!paused);
567         }
568         require(beneficiary != address(0));
569         require(amount <= balances[msg.sender]);
570 
571         // SafeMath.sub will throw if there is not enough balance.
572         balances[msg.sender] = balances[msg.sender].sub(amount);
573         balances[beneficiary] = balances[beneficiary].add(amount);
574         Transfer(msg.sender, beneficiary, amount);
575         return true;
576     }
577 }