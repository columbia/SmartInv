1 pragma solidity 0.4.13;
2 contract Burnable {
3 
4     event LogBurned(address indexed burner, uint256 indexed amount);
5 
6     function burn(uint256 amount) returns (bool burned);
7 }
8 contract Mintable {
9 
10     function mint(address to, uint256 amount) returns (bool minted);
11 
12     function mintLocked(address to, uint256 amount) returns (bool minted);
13 }
14 /**
15  * @title ERC20Basic
16  * @dev Simpler version of ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/179
18  */
19 contract ERC20Basic {
20   uint256 public totalSupply;
21   function balanceOf(address who) public constant returns (uint256);
22   function transfer(address to, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public constant returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 /**
36  * @title SafeERC20
37  * @dev Wrappers around ERC20 operations that throw on failure.
38  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
39  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
40  */
41 library SafeERC20 {
42   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
43     assert(token.transfer(to, value));
44   }
45 
46   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
47     assert(token.transferFrom(from, to, value));
48   }
49 
50   function safeApprove(ERC20 token, address spender, uint256 value) internal {
51     assert(token.approve(spender, value));
52   }
53 }
54 /**
55  * @title TokenTimelock
56  * @dev TokenTimelock is a token holder contract that will allow a
57  * beneficiary to extract the tokens after a given release time
58  */
59 contract TokenTimelock {
60     using SafeERC20 for ERC20Basic;
61 
62     // ERC20 basic token contract being held
63     ERC20Basic public token;
64 
65     // beneficiary of tokens after they are released
66     address public beneficiary;
67 
68     // timestamp when token release is enabled
69     uint256 public releaseTime;
70 
71     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) {
72         //require(_token != address(0));
73         //require(_beneficiary != address(0));
74         require(_releaseTime > now);
75 
76         token = _token;
77         beneficiary = _beneficiary;
78         releaseTime = _releaseTime;
79     }
80 
81     /**
82     * @notice Transfers tokens held by timelock to beneficiary.
83     */
84     function release() public {
85         require(now >= releaseTime);
86 
87         uint256 amount = token.balanceOf(this);
88         require(amount > 0);
89 
90         token.safeTransfer(beneficiary, amount);
91     }
92 }
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a * b;
100     assert(a == 0 || c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal constant returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal constant returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 /**
123  * @title Ownable
124  * @dev The Ownable contract has an owner address, and provides basic authorization control
125  * functions, this simplifies the implementation of "user permissions".
126  */
127 contract Ownable {
128   address public owner;
129 
130 
131   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133 
134   /**
135    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136    * account.
137    */
138   function Ownable() {
139     owner = msg.sender;
140   }
141 
142 
143   /**
144    * @dev Throws if called by any account other than the owner.
145    */
146   modifier onlyOwner() {
147     require(msg.sender == owner);
148     _;
149   }
150 
151 
152   /**
153    * @dev Allows the current owner to transfer control of the contract to a newOwner.
154    * @param newOwner The address to transfer ownership to.
155    */
156   function transferOwnership(address newOwner) onlyOwner public {
157     require(newOwner != address(0));
158     OwnershipTransferred(owner, newOwner);
159     owner = newOwner;
160   }
161 
162 }
163 /**
164 * @title TokenVesting
165 * @dev A token holder contract that can release its token balance gradually like a typical vesting
166 * scheme, with a cliff and vesting period. Optionally revocable by the owner.
167 */
168 contract TokenVesting is Ownable {
169     using SafeMath for uint256;
170     using SafeERC20 for ERC20Basic;
171 
172     event LogVestingCreated(address indexed beneficiary, uint256 startTime, uint256 indexed cliff,
173         uint256 indexed duration, bool revocable);
174     event LogVestedTokensReleased(address indexed token, uint256 indexed released);
175     event LogVestingRevoked(address indexed token, uint256 indexed refunded);
176 
177     // Beneficiary of tokens after they are released
178     address public beneficiary;
179 
180     // The duration in seconds of the cliff in which tokens will begin to vest
181     uint256 public cliff;
182     
183     // When the vesting starts as timestamp in seconds from Unix epoch
184     uint256 public startTime;
185     
186     // The duration in seconds of the period in which the tokens will vest
187     uint256 public duration;
188 
189     // Flag indicating whether the vesting is revocable or not
190     bool public revocable;
191 
192     mapping (address => uint256) public released;
193     mapping (address => bool) public revoked;
194 
195     /**
196     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
197     * _beneficiary, gradually in a linear fashion until _startTime + _duration. By then all
198     * of the balance will have vested.
199     * @param _beneficiary The address of the beneficiary to whom vested tokens are transferred
200     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch
201     * @param _cliff The duration in seconds of the cliff in which tokens will begin to vest
202     * @param _duration The duration in seconds of the period in which the tokens will vest
203     * @param _revocable Flag indicating whether the vesting is revocable or not
204     */
205     function TokenVesting(address _beneficiary, uint256 _startTime, uint256 _cliff, uint256 _duration, bool _revocable) public {
206         require(_beneficiary != address(0));
207         require(_startTime >= now);
208         require(_duration > 0);
209         require(_cliff <= _duration);
210 
211         beneficiary = _beneficiary;
212         startTime = _startTime;
213         cliff = _startTime.add(_cliff);
214         duration = _duration;
215         revocable = _revocable;
216 
217         LogVestingCreated(beneficiary, startTime, cliff, duration, revocable);
218     }
219 
220     /**
221     * @notice Transfers vested tokens to beneficiary.
222     * @param token ERC20 token which is being vested
223     */
224     function release(ERC20Basic token) public {
225         uint256 unreleased = releasableAmount(token);
226         require(unreleased > 0);
227 
228         released[token] = released[token].add(unreleased);
229 
230         token.safeTransfer(beneficiary, unreleased);
231 
232         LogVestedTokensReleased(address(token), unreleased);
233     }
234 
235     /**
236     * @notice Allows the owner to revoke the vesting. Tokens already vested
237     * remain in the contract, the rest are returned to the owner.
238     * @param token ERC20 token which is being vested
239     */
240     function revoke(ERC20Basic token) public onlyOwner {
241         require(revocable);
242         require(!revoked[token]);
243 
244         uint256 balance = token.balanceOf(this);
245 
246         uint256 unreleased = releasableAmount(token);
247         uint256 refundable = balance.sub(unreleased);
248 
249         revoked[token] = true;
250 
251         token.safeTransfer(owner, refundable);
252 
253         LogVestingRevoked(address(token), refundable);
254     }
255 
256     /**
257     * @dev Calculates the amount that has already vested but hasn't been released yet.
258     * @param token ERC20 token which is being vested
259     */
260     function releasableAmount(ERC20Basic token) public constant returns (uint256) {
261         return vestedAmount(token).sub(released[token]);
262     }
263 
264     /**
265     * @dev Calculates the amount that has already vested.
266     * @param token ERC20 token which is being vested
267     */
268     function vestedAmount(ERC20Basic token) public constant returns (uint256) {
269         uint256 currentBalance = token.balanceOf(this);
270         uint256 totalBalance = currentBalance.add(released[token]);
271 
272         if (now < cliff) {
273             return 0;
274         } else if (now >= startTime.add(duration) || revoked[token]) {
275             return totalBalance;
276         } else {
277             return totalBalance.mul(now.sub(startTime)).div(duration);
278         }
279     }
280 }
281 /**
282  * @title Pausable
283  * @dev Base contract which allows children to implement an emergency stop mechanism.
284  */
285 contract Pausable is Ownable {
286   event Pause();
287   event Unpause();
288 
289   bool public paused = false;
290 
291 
292   /**
293    * @dev Modifier to make a function callable only when the contract is not paused.
294    */
295   modifier whenNotPaused() {
296     require(!paused);
297     _;
298   }
299 
300   /**
301    * @dev Modifier to make a function callable only when the contract is paused.
302    */
303   modifier whenPaused() {
304     require(paused);
305     _;
306   }
307 
308   /**
309    * @dev called by the owner to pause, triggers stopped state
310    */
311   function pause() onlyOwner whenNotPaused public {
312     paused = true;
313     Pause();
314   }
315 
316   /**
317    * @dev called by the owner to unpause, returns to normal state
318    */
319   function unpause() onlyOwner whenPaused public {
320     paused = false;
321     Unpause();
322   }
323 }
324 /**
325  * @title Basic token
326  * @dev Basic version of StandardToken, with no allowances.
327  */
328 contract BasicToken is ERC20Basic {
329   using SafeMath for uint256;
330 
331   mapping(address => uint256) balances;
332 
333   /**
334   * @dev transfer token for a specified address
335   * @param _to The address to transfer to.
336   * @param _value The amount to be transferred.
337   */
338   function transfer(address _to, uint256 _value) public returns (bool) {
339     require(_to != address(0));
340 
341     // SafeMath.sub will throw if there is not enough balance.
342     balances[msg.sender] = balances[msg.sender].sub(_value);
343     balances[_to] = balances[_to].add(_value);
344     Transfer(msg.sender, _to, _value);
345     return true;
346   }
347 
348   /**
349   * @dev Gets the balance of the specified address.
350   * @param _owner The address to query the the balance of.
351   * @return An uint256 representing the amount owned by the passed address.
352   */
353   function balanceOf(address _owner) public constant returns (uint256 balance) {
354     return balances[_owner];
355   }
356 
357 }
358 /**
359  * @title Standard ERC20 token
360  *
361  * @dev Implementation of the basic standard token.
362  * @dev https://github.com/ethereum/EIPs/issues/20
363  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
364  */
365 contract StandardToken is ERC20, BasicToken {
366 
367   mapping (address => mapping (address => uint256)) allowed;
368 
369 
370   /**
371    * @dev Transfer tokens from one address to another
372    * @param _from address The address which you want to send tokens from
373    * @param _to address The address which you want to transfer to
374    * @param _value uint256 the amount of tokens to be transferred
375    */
376   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
377     require(_to != address(0));
378 
379     uint256 _allowance = allowed[_from][msg.sender];
380 
381     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
382     // require (_value <= _allowance);
383 
384     balances[_from] = balances[_from].sub(_value);
385     balances[_to] = balances[_to].add(_value);
386     allowed[_from][msg.sender] = _allowance.sub(_value);
387     Transfer(_from, _to, _value);
388     return true;
389   }
390 
391   /**
392    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
393    *
394    * Beware that changing an allowance with this method brings the risk that someone may use both the old
395    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
396    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
397    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398    * @param _spender The address which will spend the funds.
399    * @param _value The amount of tokens to be spent.
400    */
401   function approve(address _spender, uint256 _value) public returns (bool) {
402     allowed[msg.sender][_spender] = _value;
403     Approval(msg.sender, _spender, _value);
404     return true;
405   }
406 
407   /**
408    * @dev Function to check the amount of tokens that an owner allowed to a spender.
409    * @param _owner address The address which owns the funds.
410    * @param _spender address The address which will spend the funds.
411    * @return A uint256 specifying the amount of tokens still available for the spender.
412    */
413   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
414     return allowed[_owner][_spender];
415   }
416 
417   /**
418    * approve should be called when allowed[_spender] == 0. To increment
419    * allowed value is better to use this function to avoid 2 calls (and wait until
420    * the first transaction is mined)
421    * From MonolithDAO Token.sol
422    */
423   function increaseApproval (address _spender, uint _addedValue)
424     returns (bool success) {
425     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
426     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
427     return true;
428   }
429 
430   function decreaseApproval (address _spender, uint _subtractedValue)
431     returns (bool success) {
432     uint oldValue = allowed[msg.sender][_spender];
433     if (_subtractedValue > oldValue) {
434       allowed[msg.sender][_spender] = 0;
435     } else {
436       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
437     }
438     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439     return true;
440   }
441 
442 }
443 /**
444  * @title Pausable token
445  *
446  * @dev StandardToken modified with pausable transfers.
447  **/
448 
449 contract PausableToken is StandardToken, Pausable {
450 
451   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
452     return super.transfer(_to, _value);
453   }
454 
455   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
456     return super.transferFrom(_from, _to, _value);
457   }
458 
459   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
460     return super.approve(_spender, _value);
461   }
462 
463   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
464     return super.increaseApproval(_spender, _addedValue);
465   }
466 
467   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
468     return super.decreaseApproval(_spender, _subtractedValue);
469   }
470 }
471 contract AdaptableToken is Burnable, Mintable, PausableToken {
472 
473     uint256 public transferableFromBlock;
474 
475     uint256 public lockEndBlock;
476     
477     mapping (address => uint256) public initiallyLockedAmount;
478     
479     function AdaptableToken(uint256 _transferableFromBlock, uint256 _lockEndBlock) internal {
480         require(_lockEndBlock > _transferableFromBlock);
481         transferableFromBlock = _transferableFromBlock;
482         lockEndBlock = _lockEndBlock;
483     }
484 
485     modifier canTransfer(address _from, uint _value) {
486         require(block.number >= transferableFromBlock);
487 
488         if (block.number < lockEndBlock) {
489             uint256 locked = lockedBalanceOf(_from);
490             if (locked > 0) {
491                 uint256 newBalance = balanceOf(_from).sub(_value);
492                 require(newBalance >= locked);
493             }
494         }
495         _;
496     }
497 
498     function lockedBalanceOf(address _to) public constant returns(uint256) {
499         uint256 locked = initiallyLockedAmount[_to];
500         if (block.number >= lockEndBlock) return 0;
501         else if (block.number <= transferableFromBlock) return locked;
502 
503         uint256 releaseForBlock = locked.div(lockEndBlock.sub(transferableFromBlock));
504         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
505         return locked.sub(released);
506     }
507 
508     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) public returns (bool) {
509         return super.transfer(_to, _value);
510     }
511 
512     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) public returns (bool) {
513         return super.transferFrom(_from, _to, _value);
514     }
515 
516     modifier canMint() {
517         require(!mintingFinished());
518         _;
519     }
520 
521     function mintingFinished() public constant returns(bool finished) {
522         return block.number >= transferableFromBlock;
523     }
524 
525     /**
526     * @dev Mint new tokens.
527     * @param _to The address that will receieve the minted tokens.
528     * @param _amount The amount of tokens to mint.
529     * @return A boolean that indicates if the operation was successful.
530     */
531     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool minted) {
532         totalSupply = totalSupply.add(_amount);
533         balances[_to] = balances[_to].add(_amount);
534         Transfer(address(0), _to, _amount);
535         return true;
536     }
537 
538     /**
539     * @dev Mint new locked tokens, which will unlock progressively.
540     * @param _to The address that will receieve the minted locked tokens.
541     * @param _amount The amount of tokens to mint.
542     * @return A boolean that indicates if the operation was successful.
543     */
544     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns (bool minted) {
545         initiallyLockedAmount[_to] = initiallyLockedAmount[_to].add(_amount);
546         return mint(_to, _amount);
547     }
548 
549     /**
550      * @dev Mint timelocked tokens.
551      * @param _to The address that will receieve the minted locked tokens.
552      * @param _amount The amount of tokens to mint.
553      * @param _releaseTime The token release time as timestamp from Unix epoch.
554      * @return A boolean that indicates if the operation was successful.
555      */
556     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public
557         onlyOwner canMint returns (TokenTimelock tokenTimelock) {
558 
559         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
560         mint(timelock, _amount);
561 
562         return timelock;
563     }
564 
565     /**
566     * @dev Mint vested tokens.
567     * @param _to The address that will receieve the minted vested tokens.
568     * @param _amount The amount of tokens to mint.
569     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
570     * @param _duration The duration in seconds of the period in which the tokens will vest.
571     * @return A boolean that indicates if the operation was successful.
572     */
573     function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public
574         onlyOwner canMint returns (TokenVesting tokenVesting) {
575 
576         TokenVesting vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
577         mint(vesting, _amount);
578 
579         return vesting;
580     }
581 
582     /**
583     * @dev Burn tokens.
584     * @param _amount The amount of tokens to burn.
585     * @return A boolean that indicates if the operation was successful.
586     */
587     function burn(uint256 _amount) public returns (bool burned) {
588         //require(0 < _amount && _amount <= balances[msg.sender]);
589 
590         balances[msg.sender] = balances[msg.sender].sub(_amount);
591         totalSupply = totalSupply.sub(_amount);
592 
593         Transfer(msg.sender, address(0), _amount);
594         
595         return true;
596     }
597 
598     /**
599      * @dev Release vested tokens to beneficiary.
600      * @param _vesting The token vesting to release.
601      */
602     function releaseVested(TokenVesting _vesting) public {
603         require(_vesting != address(0));
604 
605         _vesting.release(this);
606     }
607 
608     /**
609      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
610      * @param _vesting The token vesting to revoke.
611      */
612     function revokeVested(TokenVesting _vesting) public onlyOwner {
613         require(_vesting != address(0));
614 
615         _vesting.revoke(this);
616     }
617 }
618 contract NokuMasterToken is AdaptableToken {
619     string public constant name = "NOKU";
620     string public constant symbol = "NOKU";
621     uint8 public constant decimals = 18;
622 
623     function NokuMasterToken(uint256 _transferableFromBlock, uint256 _lockEndBlock)
624         AdaptableToken(_transferableFromBlock, _lockEndBlock) public {
625     }
626 }