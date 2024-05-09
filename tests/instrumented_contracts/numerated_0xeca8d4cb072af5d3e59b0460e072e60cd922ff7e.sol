1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     require(newOwner != address(0));      
36     owner = newOwner;
37   }
38 
39 }
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
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
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   uint256 public totalSupply;
77   function balanceOf(address who) constant returns (uint256);
78   function transfer(address to, uint256 value) returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) returns (bool);
89   function approve(address spender, uint256 value) returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) returns (bool) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of. 
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183   
184     /*
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until 
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    */
190   function increaseApproval (address _spender, uint _addedValue) 
191     returns (bool success) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   function decreaseApproval (address _spender, uint _subtractedValue) 
198     returns (bool success) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Mintable token
213  * @dev Simple ERC20 Token example, with mintable token creation
214  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
215  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
216  */
217 
218 contract MintableToken is StandardToken, Ownable {
219   event Mint(address indexed to, uint256 amount);
220   event MintFinished();
221 
222   bool public mintingFinished = false;
223 
224 
225   modifier canMint() {
226     require(!mintingFinished);
227     _;
228   }
229 
230   /**
231    * @dev Function to mint tokens
232    * @param _to The address that will receive the minted tokens.
233    * @param _amount The amount of tokens to mint.
234    * @return A boolean that indicates if the operation was successful.
235    */
236   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
237     totalSupply = totalSupply.add(_amount);
238     balances[_to] = balances[_to].add(_amount);
239     Mint(_to, _amount);
240     Transfer(0x0, _to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() onlyOwner returns (bool) {
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 }
254 
255 contract ReleasableToken is MintableToken {
256 
257   /* The finalizer contract that allows unlift the transfer limits on this token */
258   address public releaseAgent;
259 
260   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
261   bool public released = false;
262 
263   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
264   mapping (address => bool) public transferAgents;
265 
266   /**
267    * Limit token transfer until the crowdsale is over.
268    *
269    */
270   modifier canTransfer(address _sender) {
271 
272     if(!released) {
273         if(!transferAgents[_sender]) {
274             throw;
275         }
276     }
277 
278     _;
279   }
280 
281   /**
282    * Set the contract that can call release and make the token transferable.
283    *
284    * Design choice. Allow reset the release agent to fix fat finger mistakes.
285    */
286   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
287 
288     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
289     releaseAgent = addr;
290   }
291 
292   /**
293    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
294    */
295   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
296     transferAgents[addr] = state;
297   }
298 
299   /**
300    * One way function to release the tokens to the wild.
301    *
302    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
303    */
304   function releaseTokenTransfer() public onlyReleaseAgent {
305     released = true;
306   }
307 
308   /** The function can be called only before or after the tokens have been releasesd */
309   modifier inReleaseState(bool releaseState) {
310     if(releaseState != released) {
311         throw;
312     }
313     _;
314   }
315 
316   /** The function can be called only by a whitelisted release agent. */
317   modifier onlyReleaseAgent() {
318     if(msg.sender != releaseAgent) {
319         throw;
320     }
321     _;
322   }
323 
324   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
325     // Call StandardToken.transfer()
326    return super.transfer(_to, _value);
327   }
328 
329   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
330     // Call StandardToken.transferForm()
331     return super.transferFrom(_from, _to, _value);
332   }
333 
334 }
335 
336 /**
337  * @title SimpleToken
338  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
339  */
340 contract GlobalBusinessSystemToken is ReleasableToken {
341 
342   string public constant name = "Global Business System Token";
343   string public constant symbol = "GBST";
344   uint8 public constant decimals = 18;
345 
346   uint256 public constant INITIAL_SUPPLY = 0;
347 
348   /**
349    * @dev Contructor that gives msg.sender all of existing tokens.
350    */
351   function GlobalBusinessSystemToken() {
352     totalSupply = INITIAL_SUPPLY;
353     balances[msg.sender] = INITIAL_SUPPLY;
354     setReleaseAgent(msg.sender);
355   }
356 
357 }
358 
359 /**
360  * @title Crowdsale 
361  * @dev Crowdsale is a base contract for managing a token crowdsale.
362  * Crowdsales have a start and end timestamps, where investors can make
363  * token purchases and the crowdsale will assign them tokens based
364  * on a token per ETH rate. Funds collected are forwarded to a wallet 
365  * as they arrive.
366  */
367 contract Crowdsale {
368   using SafeMath for uint256;
369 
370   // The token being sold
371   MintableToken public token;
372 
373   // start and end timestamps where investments are allowed (both inclusive)
374   uint256 public startTime;
375   uint256 public endTime;
376 
377   // address where funds are collected
378   address public wallet;
379 
380   // how many token units a buyer gets per wei
381   uint256 public rate;
382 
383   // amount of raised money in wei
384   uint256 public weiRaised;
385 
386   /**
387    * event for token purchase logging
388    * @param purchaser who paid for the tokens
389    * @param beneficiary who got the tokens
390    * @param value weis paid for purchase
391    * @param amount amount of tokens purchased
392    */ 
393   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
394 
395 
396   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
397     //require(_startTime >= now);
398     require(_endTime >= _startTime);
399     require(_rate > 0);
400     require(_wallet != 0x0);
401 
402     token = createTokenContract();
403     startTime = _startTime;
404     endTime = _endTime;
405     rate = _rate;
406     wallet = _wallet;
407   }
408 
409   // creates the token to be sold. 
410   // override this method to have crowdsale of a specific mintable token.
411   function createTokenContract() internal returns (MintableToken) {
412     return new MintableToken();
413   }
414 
415 
416   // fallback function can be used to buy tokens
417   function () payable {
418     buyTokens(msg.sender);
419   }
420 
421   // low level token purchase function
422   function buyTokens(address beneficiary) payable {
423     require(beneficiary != 0x0);
424     require(validPurchase());
425 
426     uint256 weiAmount = msg.value;
427 
428     // calculate token amount to be created
429     uint256 tokens = weiAmount.mul(rate);
430 
431     // update state
432     weiRaised = weiRaised.add(weiAmount);
433 
434     token.mint(beneficiary, tokens);
435     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
436 
437     forwardFunds();
438   }
439 
440   // send ether to the fund collection wallet
441   // override to create custom fund forwarding mechanisms
442   function forwardFunds() internal {
443     wallet.transfer(msg.value);
444   }
445 
446   // @return true if the transaction can buy tokens
447   function validPurchase() internal constant returns (bool) {
448     bool withinPeriod = now >= startTime && now <= endTime;
449     bool nonZeroPurchase = msg.value != 0;
450     bool minValue = msg.value >= 10000000000000000;
451     return withinPeriod && nonZeroPurchase && minValue;
452   }
453 
454   // @return true if crowdsale event has ended
455   function hasEnded() public constant returns (bool) {
456     return now > endTime;
457   }
458 
459 
460 }
461 
462 /**
463  * @title CappedCrowdsale
464  * @dev Extension of Crowsdale with a max amount of funds raised
465  */
466 contract CappedCrowdsale is Crowdsale {
467   using SafeMath for uint256;
468 
469   uint256 public cap;
470 
471   function CappedCrowdsale(uint256 _cap) {
472     require(_cap > 0);
473     cap = _cap * 1000000000000000000;
474   }
475 
476   // overriding Crowdsale#validPurchase to add extra cap logic
477   // @return true if investors can buy at the moment
478   function validPurchase() internal constant returns (bool) {
479     bool withinCap = weiRaised.add(msg.value) <= cap;
480     return super.validPurchase() && withinCap;
481   }
482 
483   // overriding Crowdsale#hasEnded to add cap logic
484   // @return true if crowdsale event has ended
485   function hasEnded() public constant returns (bool) {
486     bool capReached = weiRaised >= cap;
487     return super.hasEnded() || capReached;
488   }
489 
490 }
491 
492 /**
493  * @title FinalizableCrowdsale
494  * @dev Extension of Crowsdale where an owner can do extra work
495  * after finishing. 
496  */
497 contract FinalizableCrowdsale is Crowdsale, Ownable {
498   using SafeMath for uint256;
499 
500   bool public isFinalized = false;
501 
502   event Finalized();
503 
504   /**
505    * @dev Must be called after crowdsale ends, to do some extra finalization
506    * work. Calls the contract's finalization function.
507    */
508   function finalize() onlyOwner {
509     require(!isFinalized);
510     require(hasEnded());
511 
512     finalization();
513     Finalized();
514     
515     isFinalized = true;
516   }
517 
518   /**
519    * @dev Can be overriden to add finalization logic. The overriding function
520    * should call super.finalization() to ensure the chain of finalization is
521    * executed entirely.
522    */
523   function finalization() internal {
524   }
525 }
526 
527 /**
528  * @title SampleCrowdsale
529  * @dev This is an example of a fully fledged crowdsale.
530  * The way to add new features to a base crowdsale is by multiple inheritance.
531  * In this example we are providing following extensions:
532  * CappedCrowdsale - sets a max boundary for raised funds
533  *
534  * After adding multiple features it's good practice to run integration tests
535  * to ensure that subcontracts works together as intended.
536  */
537 contract GlobalBusinessSystem is CappedCrowdsale,FinalizableCrowdsale {
538 
539   function GlobalBusinessSystem(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
540     CappedCrowdsale(_cap)
541     FinalizableCrowdsale()
542     Crowdsale(_startTime, _endTime, _rate, _wallet)
543   {
544     //As goal needs to be met for a successful crowdsale
545     //the value needs to less or equal than a cap which is limit for accepted funds
546     //require(_goal <= _cap);
547   }
548 
549   function createTokenContract() internal returns (MintableToken) {
550     return new GlobalBusinessSystemToken();
551   }
552 
553 }