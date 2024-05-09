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
343 contract RenCrowdsale is Ownable, ReentrancyGuard {
344     using SafeMath for uint256;
345 
346     // We have a window in the first 5hrs that permits to allocate all whitelist 
347     // participants with an equal distribution => fiveHourCap = cap / whitelist participants.
348     uint256 public fiveHourCap;
349     uint256 public cap;
350     uint256 public goal;
351     uint256 public rate;
352 
353 
354     address public wallet;
355     RefundVault public vault;
356     RepublicToken public token;
357 
358     uint256 public startTime;
359     uint256 public endTime;
360     uint256 public fiveHours;
361     bool public isFinalized = false;
362     uint256 public weiRaised;
363 
364     mapping(address => bool) public whitelist;
365     mapping(address => uint256) public contribution;
366     
367     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
368     event TokenRelease(address indexed beneficiary, uint256 amount);
369     event TokenRefund(address indexed refundee, uint256 amount);
370     event Finalized();
371 
372     function RenCrowdsale(
373         address _token, 
374         address _wallet,
375         uint256 _startTime,
376         uint256 _endTime,
377         uint256 _rate,
378         uint256 _cap,
379         uint256 _fiveHourCap,
380         uint256 _goal
381     ) {
382         require(_startTime >= getBlockTimestamp());
383         require(_endTime >= _startTime);
384         require(_rate > 0);
385         require(_goal > 0);
386         require(_cap > 0);
387         require(_wallet != 0x0);
388 
389         vault = new RefundVault(_wallet);
390         token = RepublicToken(_token);
391         startTime = _startTime;
392         wallet = _wallet;
393         endTime = _endTime;
394         fiveHours = startTime + 5 * 1 hours;
395         fiveHourCap = _fiveHourCap;
396         rate = _rate;
397         goal = _goal;
398         cap = _cap;
399     }
400 
401     // fallback function can be used to buy tokens
402     function () external payable {
403         buyTokens(msg.sender);
404     }
405 
406     //low level function to buy tokens
407     function buyTokens(address beneficiary) internal {
408         require(beneficiary != 0x0);
409         require(whitelist[beneficiary]);
410         require(validPurchase());
411         //derive amount in wei to buy 
412         uint256 weiAmount = msg.value;
413 
414         // check if contribution is in the first 5 hours
415         if (getBlockTimestamp() <= fiveHours) {
416              require((contribution[beneficiary].add(weiAmount)) <= fiveHourCap);
417         }
418         // check if there is enough funds 
419         uint256 remainingToFund = cap.sub(weiRaised);
420         if (weiAmount > remainingToFund) {
421             weiAmount = remainingToFund;
422         }
423         uint256 weiToReturn = msg.value.sub(weiAmount);
424         //Forward funds to the vault 
425         forwardFunds(weiAmount);
426         //refund if the contribution exceed the cap
427         if (weiToReturn > 0) {
428             msg.sender.transfer(weiToReturn);
429             TokenRefund(beneficiary, weiToReturn);
430         }
431         //derive how many tokens
432         uint256 tokens = getTokens(weiAmount);
433         //update the state of weiRaised
434         weiRaised = weiRaised.add(weiAmount);
435         contribution[beneficiary] = contribution[beneficiary].add(weiAmount);
436      
437         //Trigger the event of TokenPurchase
438         TokenPurchase(
439             msg.sender,
440             beneficiary,
441             weiAmount,
442             tokens
443         );
444         token.transferTokens(beneficiary, tokens);
445         
446     }
447 
448     function getTokens(uint256 amount) internal constant returns (uint256) {
449         return amount.mul(rate);
450     }
451 
452     // contributors can claim refund if the goal is not reached
453     function claimRefund() nonReentrant external {
454         require(isFinalized);
455         require(!goalReached());
456         vault.refund(msg.sender);
457     }
458 
459     //in case of endTime before the reach of the cap, the owner can claim the unsold tokens
460     function claimUnsold() onlyOwner {
461         require(endTime <= getBlockTimestamp());
462         uint256 unsold = token.balanceOf(this);
463 
464         if (unsold > 0) {
465             require(token.transferTokens(msg.sender, unsold));
466         }
467     }
468 
469     // add/remove to whitelist array of addresses based on boolean status
470     function updateWhitelist(address[] addresses, bool status) public onlyOwner {
471         for (uint256 i = 0; i < addresses.length; i++) {
472             address contributorAddress = addresses[i];
473             whitelist[contributorAddress] = status;
474         }
475     }
476 
477     //Only owner can manually finalize the sale
478     function finalize() onlyOwner {
479         require(!isFinalized);
480         require(hasEnded());
481 
482         if (goalReached()) {
483             //Close the vault
484             vault.close();
485             //Unpause the token 
486             token.unpause();
487             //give ownership back to deployer
488             token.transferOwnership(owner);
489         } else {
490             //else enable refunds
491             vault.enableRefunds();
492         }
493         //update the sate of isFinalized
494         isFinalized = true;
495         //trigger and emit the event of finalization
496         Finalized();
497     } 
498 
499     // send ether to the fund collection wallet, the vault in this case
500     function forwardFunds(uint256 weiAmount) internal {
501         vault.deposit.value(weiAmount)(msg.sender);
502     }
503 
504     // @return true if crowdsale event has ended or cap reached
505     function hasEnded() public constant returns (bool) {
506         bool passedEndTime = getBlockTimestamp() > endTime;
507         return passedEndTime || capReached();
508     }
509 
510     function capReached() public constant returns (bool) {
511         return weiRaised >= cap;
512     }
513 
514     function goalReached() public constant returns (bool) {
515         return weiRaised >= goal;
516     }
517 
518     function isWhitelisted(address contributor) public constant returns (bool) {
519         return whitelist[contributor];
520     }
521 
522     // @return true if the transaction can buy tokens
523     function validPurchase() internal constant returns (bool) {
524         bool withinPeriod = getBlockTimestamp() >= startTime && getBlockTimestamp() <= endTime;
525         bool nonZeroPurchase = msg.value != 0;
526         bool capNotReached = weiRaised < cap;
527         return withinPeriod && nonZeroPurchase && capNotReached;
528     }
529 
530     function getBlockTimestamp() internal constant returns (uint256) {
531         return block.timestamp;
532     }
533 }
534 
535 contract RepublicToken is PausableToken, BurnableToken {
536 
537     string public constant name = "Republic Token";
538     string public constant symbol = "REN";
539     uint8 public constant decimals = 18;
540     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
541     
542     /**
543      * @notice The RepublicToken Constructor.
544      */
545     function RepublicToken() {
546         totalSupply = INITIAL_SUPPLY;   
547         balances[msg.sender] = INITIAL_SUPPLY;
548     }
549 
550     function transferTokens(address beneficiary, uint256 amount) onlyOwner returns (bool) {
551         require(amount > 0);
552 
553         balances[owner] = balances[owner].sub(amount);
554         balances[beneficiary] = balances[beneficiary].add(amount);
555         Transfer(owner, beneficiary, amount);
556 
557         return true;
558     }
559 }