1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 contract TokenVesting is Ownable {
40   using SafeMath for uint256;
41   using SafeERC20 for ERC20Basic;
42 
43   event Released(uint256 amount);
44   event Revoked();
45 
46   // beneficiary of tokens after they are released
47   address public beneficiary;
48 
49   uint256 public start;
50   uint256 public period;
51   uint256 public periodDuration;
52 
53   bool public revocable;
54 
55   mapping (address => uint256) public released;
56   mapping (address => bool) public revoked;
57 
58   /**
59    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
60    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
61    * of the balance will have vested.
62    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
63    * @param _revocable whether the vesting is revocable or not
64    */
65   function TokenVesting(address _beneficiary, uint256 _start, uint256 _period, uint256 _periodDuration, bool _revocable) public {
66     require(_beneficiary != address(0));
67 
68     beneficiary = _beneficiary;
69     revocable = _revocable;
70     period = _period;
71     periodDuration = _periodDuration;
72     start = _start;
73   }
74 
75   /**
76    * @notice Transfers vested tokens to beneficiary.
77    * @param token ERC20 token which is being vested
78    */
79   function release(ERC20Basic token) public {
80     uint256 unreleased = releasableAmount(token);
81 
82     require(unreleased > 0);
83 
84     released[token] = released[token].add(unreleased);
85 
86     token.safeTransfer(beneficiary, unreleased);
87 
88     Released(unreleased);
89   }
90 
91   /**
92    * @notice Allows the owner to revoke the vesting. Tokens already vested
93    * remain in the contract, the rest are returned to the owner.
94    * @param token ERC20 token which is being vested
95    */
96   function revoke(ERC20Basic token) public onlyOwner {
97     require(revocable);
98     require(!revoked[token]);
99 
100     uint256 balance = token.balanceOf(this);
101 
102     uint256 unreleased = releasableAmount(token);
103     uint256 refund = balance.sub(unreleased);
104 
105     revoked[token] = true;
106 
107     token.safeTransfer(owner, refund);
108 
109     Revoked();
110   }
111 
112   /**
113    * @dev Calculates the amount that has already vested but hasn't been released yet.
114    * @param token ERC20 token which is being vested
115    */
116   function releasableAmount(ERC20Basic token) public view returns (uint256) {
117     return vestedAmount(token).sub(released[token]);
118   }
119 
120   /**
121    * @dev Calculates the amount that has already vested.
122    * @param token ERC20 token which is being vested
123    */
124   function vestedAmount(ERC20Basic token) public view returns (uint256) {
125     uint256 currentBalance = token.balanceOf(this);
126     uint256 totalBalance = currentBalance.add(released[token]);
127 
128     if (now >= start.add(period.mul(periodDuration)) || revoked[token]) {
129       return totalBalance;
130     } else {
131       return totalBalance.div(period).mul(now.sub(start).div(periodDuration));
132     }
133   }
134 }
135 
136 library SafeMath {
137   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138     if (a == 0) {
139       return 0;
140     }
141     uint256 c = a * b;
142     assert(c / a == b);
143     return c;
144   }
145 
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return c;
151   }
152 
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   function add(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 library SafeERC20 {
166   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
167     assert(token.transfer(to, value));
168   }
169 
170   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
171     assert(token.transferFrom(from, to, value));
172   }
173 
174   function safeApprove(ERC20 token, address spender, uint256 value) internal {
175     assert(token.approve(spender, value));
176   }
177 }
178 
179 contract Pausable is Ownable {
180   event Pause();
181   event Unpause();
182 
183   bool public paused = false;
184 
185 
186   /**
187    * @dev Modifier to make a function callable only when the contract is not paused.
188    */
189   modifier whenNotPaused() {
190     require(!paused);
191     _;
192   }
193 
194   /**
195    * @dev Modifier to make a function callable only when the contract is paused.
196    */
197   modifier whenPaused() {
198     require(paused);
199     _;
200   }
201 
202   /**
203    * @dev called by the owner to pause, triggers stopped state
204    */
205   function pause() onlyOwner whenNotPaused public {
206     paused = true;
207     Pause();
208   }
209 
210   /**
211    * @dev called by the owner to unpause, returns to normal state
212    */
213   function unpause() onlyOwner whenPaused public {
214     paused = false;
215     Unpause();
216   }
217 }
218 
219 contract DClearAllocation is Ownable {
220   using SafeMath for uint256;
221 
222   // The token being minted.
223   DClearToken public token;
224   uint256 public initTime = 1565193600;//2019-08-08 00:00:00
225   uint256 public periodMintReleased = 0;
226   uint256 public periodMintDuration = 31104000;//1 year
227   uint256 public periodMintBalance = 10000000000000000000000000;
228   address public periodMintAddress = 0x0a39AA89C528D086eAA42447520C684f713966c4;
229 
230   // map of address to token vesting contract
231   mapping (address => TokenVesting) public vesting;
232 
233   /**
234    * event for token mint special logging
235    * @param beneficiary who is receiving the tokens
236    * @param tokens amount of tokens given to the beneficiary
237    */
238   event DClearTokensMintedSpecial(address beneficiary, uint256 tokens);
239   
240     /**
241    * event for token mint logging
242    * @param beneficiary who is receiving the tokens
243    * @param tokens amount of tokens given to the beneficiary
244    */
245   event DClearTokensMinted(address beneficiary, uint256 tokens);
246 
247   /**
248    * event for time vested token mint logging
249    * @param beneficiary who is receiving the time vested tokens
250    * @param tokens amount of tokens that will be vested to the beneficiary
251    * @param start unix timestamp at which the tokens will start vesting
252    */
253   event DClearTimeVestingTokensMinted(address beneficiary, uint256 tokens, uint256 start, uint256 periodDuration, uint256 period);
254 
255   /**
256    * event for air drop token mint loggin
257    * @param beneficiary who is receiving the airdrop tokens
258    * @param tokens airdropped
259    */
260   event DClearAirDropTokensMinted(address beneficiary, uint256 tokens);
261 
262   /**
263    * @dev Creates a new DClearAllocation contract
264    */
265   function DClearAllocation() public {
266     token = new DClearToken();
267   }
268 
269   // member function to mint tokens to a beneficiary
270   function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
271     require(beneficiary != 0x0);
272     require(tokens > 0);
273 
274     require(token.mint(beneficiary, tokens));
275     DClearTokensMinted(beneficiary, tokens);
276   }
277   
278   function mintTokensSpecial() public onlyOwner {
279 
280     uint256 amount = periodMintBalance.mul((now.sub(initTime)).div(periodMintDuration));
281     uint256 unreleased = amount.sub(periodMintReleased);
282     require(unreleased > 0);
283     periodMintReleased = periodMintReleased.add(unreleased);
284     require(token.mintSpecial(periodMintAddress, unreleased));
285     DClearTokensMintedSpecial(periodMintAddress, unreleased);
286   }
287 
288   // member function to mint time based vesting tokens to a beneficiary
289   function mintTokensWithTimeBasedVesting(address beneficiary, uint256 tokens, uint256 start, uint256 period, uint256 periodDuration) public onlyOwner {
290     require(beneficiary != 0x0);
291     require(tokens > 0);
292 
293     vesting[beneficiary] = new TokenVesting(beneficiary, start, period, periodDuration, false);
294     require(token.mint(address(vesting[beneficiary]), tokens));
295 
296     DClearTimeVestingTokensMinted(beneficiary, tokens, start, period, periodDuration);
297   }
298 
299   function mintAirDropTokens(uint256 tokens, address[] addresses) public onlyOwner {
300     require(tokens > 0);
301     for (uint256 i = 0; i < addresses.length; i++) {
302       require(token.mint(addresses[i], tokens));
303       DClearAirDropTokensMinted(addresses[i], tokens);
304     }
305   }
306 
307   // member function to finish the minting process
308   function finishAllocation() public onlyOwner {
309     require(token.finishMinting());
310   }
311 
312   // member function to unlock token for trading
313   function unlockToken() public onlyOwner {
314     token.unlockToken();
315   }
316 
317   // member function that can be called to release vested tokens periodically
318   function releaseVestedTokens(address beneficiary) public {
319     require(beneficiary != 0x0);
320 
321     TokenVesting tokenVesting = vesting[beneficiary];
322     tokenVesting.release(token);
323   }
324 
325   // transfer token ownership after allocation
326   function transferTokenOwnership(address owner) public onlyOwner {
327     require(token.mintingFinished());
328     token.transferOwnership(owner);
329   }
330 }
331 
332 contract ERC20Basic {
333   uint256 public totalSupply;
334   function balanceOf(address who) public view returns (uint256);
335   function transfer(address to, uint256 value) public returns (bool);
336   event Transfer(address indexed from, address indexed to, uint256 value);
337 }
338 
339 contract ERC20 is ERC20Basic {
340   function allowance(address owner, address spender) public view returns (uint256);
341   function transferFrom(address from, address to, uint256 value) public returns (bool);
342   function approve(address spender, uint256 value) public returns (bool);
343   event Approval(address indexed owner, address indexed spender, uint256 value);
344 }
345 
346 contract BasicToken is ERC20Basic {
347   using SafeMath for uint256;
348 
349   mapping(address => uint256) balances;
350 
351   /**
352   * @dev transfer token for a specified address
353   * @param _to The address to transfer to.
354   * @param _value The amount to be transferred.
355   */
356   function transfer(address _to, uint256 _value) public returns (bool) {
357     require(_to != address(0));
358     require(_value <= balances[msg.sender]);
359 
360     // SafeMath.sub will throw if there is not enough balance.
361     balances[msg.sender] = balances[msg.sender].sub(_value);
362     balances[_to] = balances[_to].add(_value);
363     Transfer(msg.sender, _to, _value);
364     return true;
365   }
366 
367   /**
368   * @dev Gets the balance of the specified address.
369   * @param _owner The address to query the the balance of.
370   * @return An uint256 representing the amount owned by the passed address.
371   */
372   function balanceOf(address _owner) public view returns (uint256 balance) {
373     return balances[_owner];
374   }
375 
376 }
377 
378 contract StandardToken is ERC20, BasicToken {
379 
380   mapping (address => mapping (address => uint256)) internal allowed;
381 
382 
383   /**
384    * @dev Transfer tokens from one address to another
385    * @param _from address The address which you want to send tokens from
386    * @param _to address The address which you want to transfer to
387    * @param _value uint256 the amount of tokens to be transferred
388    */
389   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
390     require(_to != address(0));
391     require(_value <= balances[_from]);
392     require(_value <= allowed[_from][msg.sender]);
393 
394     balances[_from] = balances[_from].sub(_value);
395     balances[_to] = balances[_to].add(_value);
396     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
397     Transfer(_from, _to, _value);
398     return true;
399   }
400 
401   /**
402    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
403    *
404    * Beware that changing an allowance with this method brings the risk that someone may use both the old
405    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
406    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
407    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408    * @param _spender The address which will spend the funds.
409    * @param _value The amount of tokens to be spent.
410    */
411   function approve(address _spender, uint256 _value) public returns (bool) {
412     allowed[msg.sender][_spender] = _value;
413     Approval(msg.sender, _spender, _value);
414     return true;
415   }
416 
417   /**
418    * @dev Function to check the amount of tokens that an owner allowed to a spender.
419    * @param _owner address The address which owns the funds.
420    * @param _spender address The address which will spend the funds.
421    * @return A uint256 specifying the amount of tokens still available for the spender.
422    */
423   function allowance(address _owner, address _spender) public view returns (uint256) {
424     return allowed[_owner][_spender];
425   }
426 
427   /**
428    * @dev Increase the amount of tokens that an owner allowed to a spender.
429    *
430    * approve should be called when allowed[_spender] == 0. To increment
431    * allowed value is better to use this function to avoid 2 calls (and wait until
432    * the first transaction is mined)
433    * From MonolithDAO Token.sol
434    * @param _spender The address which will spend the funds.
435    * @param _addedValue The amount of tokens to increase the allowance by.
436    */
437   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
438     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
439     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443   /**
444    * @dev Decrease the amount of tokens that an owner allowed to a spender.
445    *
446    * approve should be called when allowed[_spender] == 0. To decrement
447    * allowed value is better to use this function to avoid 2 calls (and wait until
448    * the first transaction is mined)
449    * From MonolithDAO Token.sol
450    * @param _spender The address which will spend the funds.
451    * @param _subtractedValue The amount of tokens to decrease the allowance by.
452    */
453   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
454     uint oldValue = allowed[msg.sender][_spender];
455     if (_subtractedValue > oldValue) {
456       allowed[msg.sender][_spender] = 0;
457     } else {
458       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
459     }
460     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
461     return true;
462   }
463 
464 }
465 
466 contract MintableToken is StandardToken, Ownable {
467   event Mint(address indexed to, uint256 amount);
468   event MintFinished();
469 
470   bool public mintingFinished = false;
471 
472 
473   modifier canMint() {
474     require(!mintingFinished);
475     _;
476   }
477 
478   /**
479    * @dev Function to mint tokens
480    * @param _to The address that will receive the minted tokens.
481    * @param _amount The amount of tokens to mint.
482    * @return A boolean that indicates if the operation was successful.
483    */
484   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
485     totalSupply = totalSupply.add(_amount);
486     balances[_to] = balances[_to].add(_amount);
487     Mint(_to, _amount);
488     Transfer(address(0), _to, _amount);
489     return true;
490   }
491   
492     /**
493    * @dev Function to mint tokens
494    * @param _to The address that will receive the minted tokens.
495    * @param _amount The amount of tokens to mint.
496    * @return A boolean that indicates if the operation was successful.
497    */
498   function mintSpecial(address _to, uint256 _amount) onlyOwner public returns (bool) {
499     totalSupply = totalSupply.add(_amount);
500     balances[_to] = balances[_to].add(_amount);
501     Mint(_to, _amount);
502     Transfer(address(0), _to, _amount);
503     return true;
504   }
505 
506   /**
507    * @dev Function to stop minting new tokens.
508    * @return True if the operation was successful.
509    */
510   function finishMinting() onlyOwner canMint public returns (bool) {
511     mintingFinished = true;
512     MintFinished();
513     return true;
514   }
515 }
516 
517 contract DClearToken is MintableToken {
518   string public constant name = "DClearToken";
519   string public constant symbol = "DCH";
520   uint8 public constant decimals = 18;
521 
522   uint256 public constant MAX_INIT_SUPPLY = 1 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
523   // Bit that controls whether the token can be transferred / traded
524   bool public unlocked = false;
525 
526   event DClearTokenUnlocked();
527 
528   /**
529    * @dev totalSupply is set via the minting process
530    */
531   function DClearToken() public {
532   }
533 
534   function mint(address to, uint256 amount) onlyOwner public returns (bool) {
535     require(totalSupply + amount <= MAX_INIT_SUPPLY);
536     return super.mint(to, amount);
537   }
538   
539   function mintSpecial(address to, uint256 amount) onlyOwner public returns (bool) {
540     return super.mintSpecial(to, amount);
541   }
542 
543   function unlockToken() onlyOwner public {
544     require (!unlocked);
545     unlocked = true;
546     DClearTokenUnlocked();
547   }
548 
549   // Overriding basic ERC-20 specification that lets people transfer/approve tokens.
550   function transfer(address to, uint256 value) public returns (bool) {
551     require(unlocked);
552     return super.transfer(to, value);
553   }
554 
555   function transferFrom(address from, address to, uint256 value) public returns (bool) {
556     require(unlocked);
557     return super.transferFrom(from, to, value);
558   }
559 
560   function approve(address spender, uint256 value) public returns (bool) {
561     require(unlocked);
562     return super.approve(spender, value);
563   }
564 
565   // Overriding StandardToken functions that lets people transfer/approve tokens.
566   function increaseApproval(address spender, uint addedValue) public returns (bool) {
567     require(unlocked);
568     return super.increaseApproval(spender, addedValue);
569   }
570 
571   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
572     require(unlocked);
573     return super.decreaseApproval(spender, subtractedValue);
574   }
575 
576 }