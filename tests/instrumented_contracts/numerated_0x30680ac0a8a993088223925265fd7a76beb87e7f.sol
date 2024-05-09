1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 // ----------------------------------------------------------------------------
53 // Ownership functionality for authorization controls and user permissions
54 // ----------------------------------------------------------------------------
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97   /**
98    * @dev Allows the current owner to relinquish control of the contract.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 }
105 
106 // ERC20 Standard Interface
107 // ----------------------------------------------------------------------------
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender)
127     public view returns (uint256);
128 
129   function transferFrom(address from, address to, uint256 value)
130     public returns (bool);
131 
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 // ----------------------------------------------------------------------------
141 // Basic version of StandardToken, with no allowances.
142 // ----------------------------------------------------------------------------
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   uint256 totalSupply_;
154 
155   /**
156   * @dev total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return totalSupply_;
160   }
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170 
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     emit Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) public view returns (uint256) {
183     return balances[_owner];
184   }
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 }
307 
308 /**
309  * @title Burnable Token
310  * @dev Token that can be irreversibly burned (destroyed).
311  */
312 contract BurnableToken is BasicToken {
313 
314   event Burn(address indexed burner, uint256 value);
315 
316   /**
317    * @dev Burns a specific amount of tokens.
318    * @param _value The amount of token to be burned.
319    */
320   function burn(uint256 _value) public {
321     _burn(msg.sender, _value);
322   }
323 
324   function _burn(address _who, uint256 _value) internal {
325     require(_value <= balances[_who]);
326     // no need to require value <= totalSupply, since that would imply the
327     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
328 
329     balances[_who] = balances[_who].sub(_value);
330     totalSupply_ = totalSupply_.sub(_value);
331     emit Burn(_who, _value);
332     emit Transfer(_who, address(0), _value);
333   }
334 }
335 
336 /**
337  * @title Standard Burnable Token
338  * @dev Adds burnFrom method to ERC20 implementations
339  */
340 contract StandardBurnableToken is BurnableToken, StandardToken {
341 
342   /**
343    * @dev Burns a specific amount of tokens from the target address and decrements allowance
344    * @param _from address The address which you want to send tokens from
345    * @param _value uint256 The amount of token to be burned
346    */
347   function burnFrom(address _from, uint256 _value) public {
348     require(_value <= allowed[_from][msg.sender]);
349     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
350     // this function needs to emit an event with the updated approval.
351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352     _burn(_from, _value);
353   }
354 }
355 
356 
357 contract ArawToken is StandardBurnableToken, Ownable {
358 
359   using SafeMath for uint256;
360 
361   string public symbol = "ARAW";
362   string public name = "ARAW";
363   uint256 public decimals = 18;
364 
365   /* Wallet address will be changed for production */ 
366   address public arawWallet;
367 
368   /* Locked tokens addresses - will be changed for production */
369   address public reservedTokensAddress;
370   address public foundersTokensAddress;
371   address public advisorsTokensAddress;
372 
373   /* Variables to manage Advisors tokens vesting periods time */
374   uint256 public advisorsTokensFirstReleaseTime; 
375   uint256 public advisorsTokensSecondReleaseTime; 
376   uint256 public advisorsTokensThirdReleaseTime; 
377   
378   /* Flags to indicate Advisors tokens released */
379   bool public isAdvisorsTokensFirstReleased; 
380   bool public isAdvisorsTokensSecondReleased; 
381   bool public isAdvisorsTokensThirdReleased; 
382 
383   /* Variables to hold reserved and founders tokens locking period */
384   uint256 public reservedTokensLockedPeriod;
385   uint256 public foundersTokensLockedPeriod;
386 
387   /* Total advisors tokens allocated */
388   uint256 totalAdvisorsLockedTokens; 
389 
390   modifier checkAfterICOLock () {
391     if (msg.sender == reservedTokensAddress){
392         require (now >= reservedTokensLockedPeriod);
393     }
394     if (msg.sender == foundersTokensAddress){
395         require (now >= foundersTokensLockedPeriod);
396     }
397     _;
398   }
399 
400   function transfer(address _to, uint256 _value) 
401   public 
402   checkAfterICOLock 
403   returns (bool) {
404     super.transfer(_to,_value);
405   }
406 
407   function transferFrom(address _from, address _to, uint256 _value) 
408   public 
409   checkAfterICOLock 
410   returns (bool) {
411     super.transferFrom(_from, _to, _value);
412   }
413 
414   function approve(address _spender, uint256 _value) 
415   public 
416   checkAfterICOLock 
417   returns (bool) {
418     super.approve(_spender, _value);
419   }
420 
421   function increaseApproval(address _spender, uint _addedValue) 
422   public 
423   checkAfterICOLock 
424   returns (bool) {
425     super.increaseApproval(_spender, _addedValue);
426   }
427 
428   function decreaseApproval(address _spender, uint _subtractedValue) 
429   public 
430   checkAfterICOLock 
431   returns (bool) {
432     super.decreaseApproval(_spender, _subtractedValue);
433   }
434 
435   /**
436    * @dev Transfer ownership now transfers all owners tokens to new owner 
437    */
438   function transferOwnership(address newOwner) public onlyOwner {
439     balances[newOwner] = balances[newOwner].add(balances[owner]);
440     emit Transfer(owner, newOwner, balances[owner]);
441     balances[owner] = 0;
442 
443     super.transferOwnership(newOwner);
444   }
445 
446   /* ICO status */
447   enum State {
448     Active,
449     Closed
450   }
451 
452   event Closed();
453 
454   State public state;
455 
456   // ------------------------------------------------------------------------
457   // Constructor
458   // ------------------------------------------------------------------------
459   constructor(address _reservedTokensAddress, address _foundersTokensAddress, address _advisorsTokensAddress, address _arawWallet) public {
460     owner = msg.sender;
461 
462     reservedTokensAddress = _reservedTokensAddress;
463     foundersTokensAddress = _foundersTokensAddress;
464     advisorsTokensAddress = _advisorsTokensAddress;
465 
466     arawWallet = _arawWallet;
467 
468     totalSupply_ = 5000000000 ether;
469    
470     balances[msg.sender] = 3650000000 ether;
471     balances[reservedTokensAddress] = 750000000 ether;
472     balances[foundersTokensAddress] = 450000000 ether;
473     
474     totalAdvisorsLockedTokens = 150000000 ether;
475     balances[this] = 150000000 ether;
476    
477     state = State.Active;
478    
479     emit Transfer(address(0), msg.sender, balances[msg.sender]);
480     emit Transfer(address(0), reservedTokensAddress, balances[reservedTokensAddress]);
481     emit Transfer(address(0), foundersTokensAddress, balances[foundersTokensAddress]);
482     emit Transfer(address(0), address(this), balances[this]);
483   }
484 
485   /**
486    * @dev release tokens for advisors
487    */
488   function releaseAdvisorsTokens() public returns (bool) {
489     require(state == State.Closed);
490     
491     require (now > advisorsTokensFirstReleaseTime);
492     
493     if (now < advisorsTokensSecondReleaseTime) {   
494       require (!isAdvisorsTokensFirstReleased);
495       
496       isAdvisorsTokensFirstReleased = true;
497       releaseAdvisorsTokensForPercentage(30);
498 
499       return true;
500     }
501 
502     if (now < advisorsTokensThirdReleaseTime) {
503       require (!isAdvisorsTokensSecondReleased);
504       
505       if (!isAdvisorsTokensFirstReleased) {
506         isAdvisorsTokensFirstReleased = true;
507         releaseAdvisorsTokensForPercentage(60);
508       } else{
509         releaseAdvisorsTokensForPercentage(30);
510       }
511       
512       isAdvisorsTokensSecondReleased = true;
513       return true;
514     }
515 
516     require (!isAdvisorsTokensThirdReleased);
517 
518     if (!isAdvisorsTokensFirstReleased) {
519       releaseAdvisorsTokensForPercentage(100);
520     } else if (!isAdvisorsTokensSecondReleased) {
521       releaseAdvisorsTokensForPercentage(70);
522     } else{
523       releaseAdvisorsTokensForPercentage(40);
524     }
525 
526     isAdvisorsTokensFirstReleased = true;
527     isAdvisorsTokensSecondReleased = true;
528     isAdvisorsTokensThirdReleased = true;
529 
530     return true;
531   } 
532   
533   /**
534    * @param percent tokens release for advisors from their pool
535    */
536   function releaseAdvisorsTokensForPercentage(uint256 percent) internal {
537     uint256 releasedTokens = (percent.mul(totalAdvisorsLockedTokens)).div(100);
538 
539     balances[advisorsTokensAddress] = balances[advisorsTokensAddress].add(releasedTokens);
540     balances[this] = balances[this].sub(releasedTokens);
541     emit Transfer(this, advisorsTokensAddress, releasedTokens);
542   }
543 
544   /**
545    * @dev all ether transfer to another wallet automatic
546    */
547   function () public payable {
548     require(state == State.Active); // Reject the transactions after ICO ended
549     require(msg.value >= 0.1 ether);
550     
551     arawWallet.transfer(msg.value);
552   }
553 
554   /**
555   * After ICO close it helps to lock tokens for pools
556   **/
557   function close() onlyOwner public {
558     require(state == State.Active);
559     state = State.Closed;
560     
561     foundersTokensLockedPeriod = now + 365 days;
562     reservedTokensLockedPeriod = now + 1095 days; //3 years
563     advisorsTokensFirstReleaseTime = now + 12 weeks; //3 months to unlock 30 %
564     advisorsTokensSecondReleaseTime = now + 24 weeks; // 6 months to unlock 30%
565     advisorsTokensThirdReleaseTime = now + 365 days; //1 year to unlock 40 %
566     
567     emit Closed();
568   }
569 }