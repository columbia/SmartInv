1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender)
112     public view returns (uint256);
113 
114   function transferFrom(address from, address to, uint256 value)
115     public returns (bool);
116 
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(
119     address indexed owner,
120     address indexed spender,
121     uint256 value
122   );
123 }
124 
125 contract DetailedERC20 is ERC20 {
126   string public name;
127   string public symbol;
128   uint8 public decimals;
129 
130   constructor(string _name, string _symbol, uint8 _decimals) public {
131     name = _name;
132     symbol = _symbol;
133     decimals = _decimals;
134   }
135 }
136 
137 /**
138  * @title SafeERC20
139  * @dev Wrappers around ERC20 operations that throw on failure.
140  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
141  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
142  */
143 library SafeERC20 {
144   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
145     require(token.transfer(to, value));
146   }
147 
148   function safeTransferFrom(
149     ERC20 token,
150     address from,
151     address to,
152     uint256 value
153   )
154     internal
155   {
156     require(token.transferFrom(from, to, value));
157   }
158 
159   function safeApprove(ERC20 token, address spender, uint256 value) internal {
160     require(token.approve(spender, value));
161   }
162 }
163 
164 
165 /**
166  * @title Burnable Token
167  * @dev Token that can be irreversibly burned (destroyed).
168  */
169 contract BurnableToken is BasicToken {
170 
171   event Burn(address indexed burner, uint256 value);
172 
173   /**
174    * @dev Burns a specific amount of tokens.
175    * @param _value The amount of token to be burned.
176    */
177   function burn(uint256 _value) public {
178     _burn(msg.sender, _value);
179   }
180 
181   function _burn(address _who, uint256 _value) internal {
182     require(_value <= balances[_who]);
183     // no need to require value <= totalSupply, since that would imply the
184     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
185 
186     balances[_who] = balances[_who].sub(_value);
187     totalSupply_ = totalSupply_.sub(_value);
188     emit Burn(_who, _value);
189     emit Transfer(_who, address(0), _value);
190   }
191 }
192 
193 
194 /**
195  * @title Standard ERC20 token
196  *
197  * @dev Implementation of the basic standard token.
198  * @dev https://github.com/ethereum/EIPs/issues/20
199  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
200  */
201 contract StandardToken is ERC20, BasicToken {
202 
203   mapping (address => mapping (address => uint256)) internal allowed;
204 
205 
206   /**
207    * @dev Transfer tokens from one address to another
208    * @param _from address The address which you want to send tokens from
209    * @param _to address The address which you want to transfer to
210    * @param _value uint256 the amount of tokens to be transferred
211    */
212   function transferFrom(
213     address _from,
214     address _to,
215     uint256 _value
216   )
217     public
218     returns (bool)
219   {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     emit Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     emit Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(
254     address _owner,
255     address _spender
256    )
257     public
258     view
259     returns (uint256)
260   {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(
275     address _spender,
276     uint _addedValue
277   )
278     public
279     returns (bool)
280   {
281     allowed[msg.sender][_spender] = (
282       allowed[msg.sender][_spender].add(_addedValue));
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(
298     address _spender,
299     uint _subtractedValue
300   )
301     public
302     returns (bool)
303   {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 /**
317  * @title Standard Burnable Token
318  * @dev Adds burnFrom method to ERC20 implementations
319  */
320 contract StandardBurnableToken is BurnableToken, StandardToken {
321 
322   /**
323    * @dev Burns a specific amount of tokens from the target address and decrements allowance
324    * @param _from address The address which you want to send tokens from
325    * @param _value uint256 The amount of token to be burned
326    */
327   function burnFrom(address _from, uint256 _value) public {
328     require(_value <= allowed[_from][msg.sender]);
329     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
330     // this function needs to emit an event with the updated approval.
331     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
332     _burn(_from, _value);
333   }
334 }
335 
336 
337 /**
338  * @title Ownable
339  * @dev The Ownable contract has an owner address, and provides basic authorization control
340  * functions, this simplifies the implementation of "user permissions".
341  */
342 contract Ownable {
343   address public owner;
344 
345 
346   event OwnershipRenounced(address indexed previousOwner);
347   event OwnershipTransferred(
348     address indexed previousOwner,
349     address indexed newOwner
350   );
351 
352 
353   /**
354    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
355    * account.
356    */
357   constructor() public {
358     owner = msg.sender;
359   }
360 
361   /**
362    * @dev Throws if called by any account other than the owner.
363    */
364   modifier onlyOwner() {
365     require(msg.sender == owner);
366     _;
367   }
368 
369   /**
370    * @dev Allows the current owner to transfer control of the contract to a newOwner.
371    * @param newOwner The address to transfer ownership to.
372    */
373   function transferOwnership(address newOwner) public onlyOwner {
374     require(newOwner != address(0));
375     emit OwnershipTransferred(owner, newOwner);
376     owner = newOwner;
377   }
378 
379   /**
380    * @dev Allows the current owner to relinquish control of the contract.
381    */
382   function renounceOwnership() public onlyOwner {
383     emit OwnershipRenounced(owner);
384     owner = address(0);
385   }
386 }
387 
388 contract TokenPool {
389     ERC20Basic public token;
390 
391     modifier poolReady {
392         require(token != address(0));
393         _;
394     }
395 
396     function setToken(ERC20Basic newToken) public {
397         require(token == address(0));
398 
399         token = newToken;
400     }
401 
402     function balance() view public returns (uint256) {
403         return token.balanceOf(this);
404     }
405 
406     function transferTo(address dst, uint256 amount) internal returns (bool) {
407         return token.transfer(dst, amount);
408     }
409 
410     function getFrom() view public returns (address) {
411         return this;
412     }
413 }
414 
415 contract StandbyGamePool is TokenPool, Ownable {
416     address public currentVersion;
417     bool public ready = false;
418 
419     function update(address newAddress) onlyOwner public {
420         require(!ready);
421         ready = true;
422         currentVersion = newAddress;
423         transferTo(newAddress, balance());
424     }
425 
426     function() public payable {
427         require(ready);
428         if(!currentVersion.delegatecall(msg.data)) revert();
429     }
430 }
431 
432 contract AdvisorPool is TokenPool, Ownable {
433 
434     function addVestor(
435         address _beneficiary,
436         uint256 _cliff,
437         uint256 _duration,
438         uint256 totalTokens
439     ) public onlyOwner poolReady returns (TokenVesting) {
440         uint256 start = block.timestamp;
441         
442         TokenVesting vesting = new TokenVesting(_beneficiary, start, _cliff, _duration, false);
443 
444         transferTo(vesting, totalTokens);
445 
446         return vesting;
447     }
448 
449     function transfer(address _beneficiary, uint256 amount) public onlyOwner poolReady returns (bool) {
450         return transferTo(_beneficiary, amount);
451     }
452 }
453 
454 /**
455  * @title TokenVesting
456  * @dev A token holder contract that can release its token balance gradually like a
457  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
458  * owner.
459  */
460 contract TokenVesting is Ownable {
461   using SafeMath for uint256;
462   using SafeERC20 for ERC20Basic;
463 
464   event Released(uint256 amount);
465   event Revoked();
466 
467   // beneficiary of tokens after they are released
468   address public beneficiary;
469 
470   uint256 public cliff;
471   uint256 public start;
472   uint256 public duration;
473 
474   bool public revocable;
475 
476   mapping (address => uint256) public released;
477   mapping (address => bool) public revoked;
478 
479   /**
480    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
481    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
482    * of the balance will have vested.
483    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
484    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
485    * @param _duration duration in seconds of the period in which the tokens will vest
486    * @param _revocable whether the vesting is revocable or not
487    */
488   constructor(
489     address _beneficiary,
490     uint256 _start,
491     uint256 _cliff,
492     uint256 _duration,
493     bool _revocable
494   )
495     public
496   {
497     require(_beneficiary != address(0));
498     require(_cliff <= _duration);
499 
500     beneficiary = _beneficiary;
501     revocable = _revocable;
502     duration = _duration;
503     cliff = _start.add(_cliff);
504     start = _start;
505   }
506 
507   /**
508    * @notice Transfers vested tokens to beneficiary.
509    * @param token ERC20 token which is being vested
510    */
511   function release(ERC20Basic token) public {
512     uint256 unreleased = releasableAmount(token);
513 
514     require(unreleased > 0);
515 
516     released[token] = released[token].add(unreleased);
517 
518     token.safeTransfer(beneficiary, unreleased);
519 
520     emit Released(unreleased);
521   }
522 
523   /**
524    * @notice Allows the owner to revoke the vesting. Tokens already vested
525    * remain in the contract, the rest are returned to the owner.
526    * @param token ERC20 token which is being vested
527    */
528   function revoke(ERC20Basic token) public onlyOwner {
529     require(revocable);
530     require(!revoked[token]);
531 
532     uint256 balance = token.balanceOf(this);
533 
534     uint256 unreleased = releasableAmount(token);
535     uint256 refund = balance.sub(unreleased);
536 
537     revoked[token] = true;
538 
539     token.safeTransfer(owner, refund);
540 
541     emit Revoked();
542   }
543 
544   /**
545    * @dev Calculates the amount that has already vested but hasn't been released yet.
546    * @param token ERC20 token which is being vested
547    */
548   function releasableAmount(ERC20Basic token) public view returns (uint256) {
549     return vestedAmount(token).sub(released[token]);
550   }
551 
552   /**
553    * @dev Calculates the amount that has already vested.
554    * @param token ERC20 token which is being vested
555    */
556   function vestedAmount(ERC20Basic token) public view returns (uint256) {
557     uint256 currentBalance = token.balanceOf(this);
558     uint256 totalBalance = currentBalance.add(released[token]);
559 
560     if (block.timestamp < cliff) {
561       return 0;
562     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
563       return totalBalance;
564     } else {
565       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
566     }
567   }
568 }
569 
570 contract TeamPool is TokenPool, Ownable {
571 
572     uint256 public constant INIT_COIN = 200000 * (10 ** uint256(18));
573 
574     mapping(address => TokenVesting[]) cache;
575 
576     function addVestor(
577         address _beneficiary,
578         uint256 _cliff,
579         uint256 _duration,
580         uint256 totalTokens
581     ) public onlyOwner poolReady returns (TokenVesting) {
582         return _addVestor(_beneficiary, _cliff, _duration, totalTokens, true);
583     }
584 
585     function _addVestor(
586         address _beneficiary,
587         uint256 _cliff,
588         uint256 _duration,
589         uint256 totalTokens,
590         bool revokable
591     ) internal returns (TokenVesting) {
592         uint256 start = block.timestamp;
593 
594         cache[_beneficiary].push(new TokenVesting(_beneficiary, start, _cliff, _duration, revokable));
595 
596         uint newIndex = cache[_beneficiary].length - 1;
597 
598         transferTo(cache[_beneficiary][newIndex], totalTokens);
599 
600         return cache[_beneficiary][newIndex];
601     }
602 
603     function vestingCount(address _beneficiary) public view poolReady returns (uint) {
604         return cache[_beneficiary].length;
605     }
606 
607     function revoke(address _beneficiary, uint index) public onlyOwner poolReady {
608         require(index < vestingCount(_beneficiary));
609         require(cache[_beneficiary][index] != address(0));
610 
611         cache[_beneficiary][index].revoke(token);
612     }
613 }
614 
615 contract BenzeneToken is StandardBurnableToken, DetailedERC20 {
616     using SafeMath for uint256;
617 
618     string public constant name = "Benzene";
619     string public constant symbol = "BZN";
620     uint8 public constant decimals = 18;
621     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
622     uint256 public constant GAME_POOL_INIT = 75000000 * (10 ** uint256(decimals));
623     uint256 public constant TEAM_POOL_INIT = 20000000 * (10 ** uint256(decimals));
624     uint256 public constant ADVISOR_POOL_INIT = 5000000 * (10 ** uint256(decimals));
625 
626     address public GamePoolAddress;
627     address public TeamPoolAddress;
628     address public AdvisorPoolAddress;
629 
630     constructor(address gamePool,
631                 address teamPool, //vest
632                 address advisorPool) public DetailedERC20(name, symbol, decimals) {
633                     totalSupply_ = INITIAL_SUPPLY;
634                     
635                     balances[gamePool] = GAME_POOL_INIT;
636                     GamePoolAddress = gamePool;
637 
638                     balances[teamPool] = TEAM_POOL_INIT;
639                     TeamPoolAddress = teamPool;
640 
641 
642                     balances[advisorPool] = ADVISOR_POOL_INIT;
643                     AdvisorPoolAddress = advisorPool;
644 
645                     StandbyGamePool(gamePool).setToken(this);
646                     TeamPool(teamPool).setToken(this);
647                     AdvisorPool(advisorPool).setToken(this);
648                 }
649 }