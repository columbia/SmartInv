1 pragma solidity ^0.4.13;
2 
3 contract ReentrancyGuard {
4 
5   /**
6    * @dev We use a single lock for the whole contract.
7    */
8   bool private rentrancy_lock = false;
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
19     require(!rentrancy_lock);
20     rentrancy_lock = true;
21     _;
22     rentrancy_lock = false;
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
218 contract ERC20 is ERC20Basic {
219   function allowance(address owner, address spender) public view returns (uint256);
220   function transferFrom(address from, address to, uint256 value) public returns (bool);
221   function approve(address spender, uint256 value) public returns (bool);
222   event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237     require(_to != address(0));
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244     Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    *
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(address _owner, address _spender) public view returns (uint256) {
271     return allowed[_owner][_spender];
272   }
273 
274   /**
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287     uint oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue > oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297 }
298 
299 contract BurnableToken is StandardToken {
300 
301     event Burn(address indexed burner, uint256 value);
302 
303     /**
304      * @dev Burns a specific amount of tokens.
305      * @param _value The amount of token to be burned.
306      */
307     function burn(uint256 _value) public {
308         require(_value > 0);
309         require(_value <= balances[msg.sender]);
310         // no need to require value <= totalSupply, since that would imply the
311         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
312 
313         address burner = msg.sender;
314         balances[burner] = balances[burner].sub(_value);
315         totalSupply = totalSupply.sub(_value);
316         Burn(burner, _value);
317     }
318 }
319 
320 contract PausableToken is StandardToken, Pausable {
321 
322   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transfer(_to, _value);
324   }
325 
326   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
327     return super.transferFrom(_from, _to, _value);
328   }
329 
330   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
331     return super.approve(_spender, _value);
332   }
333 
334   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
335     return super.increaseApproval(_spender, _addedValue);
336   }
337 
338   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
339     return super.decreaseApproval(_spender, _subtractedValue);
340   }
341 }
342 
343 contract AgiCrowdsale is Ownable, ReentrancyGuard {
344     using SafeMath for uint256;
345 
346     // We have a window in the first 24hrs that permits to allocate all whitelist 
347     // participants with an equal distribution => firstDayCap = cap / whitelist participants.
348     uint256 public firstDayCap;
349     uint256 public cap;
350     uint256 public goal;
351     uint256 public rate;
352     uint256 public constant WEI_TO_COGS =  10**uint256(10);
353 
354 
355     address public wallet;
356     RefundVault public vault;
357     SingularityNetToken public token;
358 
359     uint256 public startTime;
360     uint256 public endTime;
361     uint256 public firstDay;
362 
363     bool public isFinalized = false;
364     uint256 public weiRaised;
365 
366     mapping(address => bool) public whitelist;
367     mapping(address => uint256) public contribution;
368     
369     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
370     event TokenRelease(address indexed beneficiary, uint256 amount);
371     event TokenRefund(address indexed refundee, uint256 amount);
372 
373     event Finalized();
374 
375     function AgiCrowdsale(
376         address _token, 
377         address _wallet,
378         uint256 _startTime,
379         uint256 _endTime,
380         uint256 _rate,
381         uint256 _cap,
382         uint256 _firstDayCap,
383         uint256 _goal
384     ) {
385         require(_startTime >= getBlockTimestamp());
386         require(_endTime >= _startTime);
387         require(_rate > 0);
388         require(_goal > 0);
389         require(_cap > 0);
390         require(_wallet != 0x0);
391 
392         vault = new RefundVault(_wallet);
393         token = SingularityNetToken(_token);
394         wallet = _wallet;
395         startTime = _startTime;
396         endTime = _endTime;
397         firstDay = startTime + 1 * 1 days;
398         firstDayCap = _firstDayCap;
399         rate = _rate;
400         goal = _goal;
401         cap = _cap;
402     }
403 
404     // fallback function can be used to buy tokens
405     function () external payable {
406         buyTokens(msg.sender);
407     }
408 
409     //low level function to buy tokens
410     function buyTokens(address beneficiary) internal {
411         require(beneficiary != 0x0);
412         require(whitelist[beneficiary]);
413         require(validPurchase());
414 
415         //derive amount in wei to buy 
416         uint256 weiAmount = msg.value;
417 
418         // check if contribution is in the first 24h hours
419         if (getBlockTimestamp() <= firstDay) {
420             require((contribution[beneficiary].add(weiAmount)) <= firstDayCap);
421         }
422         //check if there is enough funds 
423         uint256 remainingToFund = cap.sub(weiRaised);
424         if (weiAmount > remainingToFund) {
425             weiAmount = remainingToFund;
426         }
427         uint256 weiToReturn = msg.value.sub(weiAmount);
428         //Forward funs to the vault 
429         forwardFunds(weiAmount);
430         //refund if the contribution exceed the cap
431         if (weiToReturn > 0) {
432             msg.sender.transfer(weiToReturn);
433             TokenRefund(beneficiary, weiToReturn);
434         }
435         //derive how many tokens
436         uint256 tokens = getTokens(weiAmount);
437         //update the state of weiRaised
438         weiRaised = weiRaised.add(weiAmount);
439         contribution[beneficiary] = contribution[beneficiary].add(weiAmount);
440      
441         //Trigger the event of TokenPurchase
442         TokenPurchase(
443             msg.sender,
444             beneficiary,
445             weiAmount,
446             tokens
447         );
448         token.transferTokens(beneficiary,tokens);
449         
450     }
451 
452     function getTokens(uint256 amount) internal constant returns (uint256) {
453         return amount.mul(rate).div(WEI_TO_COGS);
454     }
455 
456     // contributors can claim refund if the goal is not reached
457     function claimRefund() nonReentrant external {
458         require(isFinalized);
459         require(!goalReached());
460         vault.refund(msg.sender);
461     }
462 
463     //in case of endTime before the reach of the cap, the owner can claim the unsold tokens
464     function claimUnsold() onlyOwner {
465         require(endTime <= getBlockTimestamp());
466         uint256 unsold = token.balanceOf(this);
467 
468         if (unsold > 0) {
469             require(token.transferTokens(msg.sender, unsold));
470         }
471     }
472 
473     // add/remove to whitelist array of addresses based on boolean status
474     function updateWhitelist(address[] addresses, bool status) public onlyOwner {
475         for (uint256 i = 0; i < addresses.length; i++) {
476             address contributorAddress = addresses[i];
477             whitelist[contributorAddress] = status;
478         }
479     }
480 
481     //Only owner can manually finalize the sale
482     function finalize() onlyOwner {
483         require(!isFinalized);
484         require(hasEnded());
485 
486         if (goalReached()) {
487             //Close the vault
488             vault.close();
489             //Unpause the token 
490             token.unpause();
491             //give ownership back to deployer
492             token.transferOwnership(owner);
493         } else {
494             //else enable refunds
495             vault.enableRefunds();
496         }
497         //update the sate of isFinalized
498         isFinalized = true;
499         //trigger and emit the event of finalization
500         Finalized();
501     } 
502 
503     // send ether to the fund collection wallet, the vault in this case
504     function forwardFunds(uint256 weiAmount) internal {
505         vault.deposit.value(weiAmount)(msg.sender);
506     }
507 
508     // @return true if crowdsale event has ended or cap reached
509     function hasEnded() public constant returns (bool) {
510         bool passedEndTime = getBlockTimestamp() > endTime;
511         return passedEndTime || capReached();
512     }
513 
514     function capReached() public constant returns (bool) {
515         return weiRaised >= cap;
516     }
517 
518     function goalReached() public constant returns (bool) {
519         return weiRaised >= goal;
520     }
521 
522     function isWhitelisted(address contributor) public constant returns (bool) {
523         return whitelist[contributor];
524     }
525 
526     // @return true if the transaction can buy tokens
527     function validPurchase() internal constant returns (bool) {
528         bool withinPeriod = getBlockTimestamp() >= startTime && getBlockTimestamp() <= endTime;
529         bool nonZeroPurchase = msg.value != 0;
530         bool capNotReached = weiRaised < cap;
531         return withinPeriod && nonZeroPurchase && capNotReached;
532     }
533 
534     function getBlockTimestamp() internal constant returns (uint256) {
535         return block.timestamp;
536     }
537 }
538 
539 contract SingularityNetToken is PausableToken, BurnableToken {
540 
541     string public constant name = "SingularityNET Token";
542     string public constant symbol = "AGI";
543     uint8 public constant decimals = 8;
544     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
545     
546     /**
547     * @dev SingularityNetToken Constructor
548     */
549 
550     function SingularityNetToken() {
551         totalSupply = INITIAL_SUPPLY;   
552         balances[msg.sender] = INITIAL_SUPPLY;
553     }
554 
555     function transferTokens(address beneficiary, uint256 amount) onlyOwner returns (bool) {
556         require(amount > 0);
557 
558         balances[owner] = balances[owner].sub(amount);
559         balances[beneficiary] = balances[beneficiary].add(amount);
560         Transfer(owner, beneficiary, amount);
561 
562         return true;
563     }
564 }