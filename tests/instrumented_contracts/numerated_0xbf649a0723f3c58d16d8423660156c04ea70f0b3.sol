1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract TokenVesting is Ownable {
41   using SafeMath for uint256;
42   using SafeERC20 for ERC20Basic;
43 
44   event Released(uint256 amount);
45   event Revoked();
46 
47   // beneficiary of tokens after they are released
48   address public beneficiary;
49 
50   uint256 public cliff;
51   uint256 public start;
52   uint256 public duration;
53 
54   bool public revocable;
55 
56   mapping (address => uint256) public released;
57   mapping (address => bool) public revoked;
58 
59   /**
60    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
61    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
62    * of the balance will have vested.
63    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
64    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
65    * @param _duration duration in seconds of the period in which the tokens will vest
66    * @param _revocable whether the vesting is revocable or not
67    */
68   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
69     require(_beneficiary != address(0));
70     require(_cliff <= _duration);
71 
72     beneficiary = _beneficiary;
73     revocable = _revocable;
74     duration = _duration;
75     cliff = _start.add(_cliff);
76     start = _start;
77   }
78 
79   /**
80    * @notice Transfers vested tokens to beneficiary.
81    * @param token ERC20 token which is being vested
82    */
83   function release(ERC20Basic token) public {
84     uint256 unreleased = releasableAmount(token);
85 
86     require(unreleased > 0);
87 
88     released[token] = released[token].add(unreleased);
89 
90     token.safeTransfer(beneficiary, unreleased);
91 
92     Released(unreleased);
93   }
94 
95   /**
96    * @notice Allows the owner to revoke the vesting. Tokens already vested
97    * remain in the contract, the rest are returned to the owner.
98    * @param token ERC20 token which is being vested
99    */
100   function revoke(ERC20Basic token) public onlyOwner {
101     require(revocable);
102     require(!revoked[token]);
103 
104     uint256 balance = token.balanceOf(this);
105 
106     uint256 unreleased = releasableAmount(token);
107     uint256 refund = balance.sub(unreleased);
108 
109     revoked[token] = true;
110 
111     token.safeTransfer(owner, refund);
112 
113     Revoked();
114   }
115 
116   /**
117    * @dev Calculates the amount that has already vested but hasn't been released yet.
118    * @param token ERC20 token which is being vested
119    */
120   function releasableAmount(ERC20Basic token) public view returns (uint256) {
121     return vestedAmount(token).sub(released[token]);
122   }
123 
124   /**
125    * @dev Calculates the amount that has already vested.
126    * @param token ERC20 token which is being vested
127    */
128   function vestedAmount(ERC20Basic token) public view returns (uint256) {
129     uint256 currentBalance = token.balanceOf(this);
130     uint256 totalBalance = currentBalance.add(released[token]);
131 
132     if (now < cliff) {
133       return 0;
134     } else if (now >= start.add(duration) || revoked[token]) {
135       return totalBalance;
136     } else {
137       return totalBalance.mul(now.sub(start)).div(duration);
138     }
139   }
140 }
141 
142 library SafeMath {
143   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144     if (a == 0) {
145       return 0;
146     }
147     uint256 c = a * b;
148     assert(c / a == b);
149     return c;
150   }
151 
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     // assert(b > 0); // Solidity automatically throws when dividing by 0
154     uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156     return c;
157   }
158 
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     assert(b <= a);
161     return a - b;
162   }
163 
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 library SafeERC20 {
172   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
173     assert(token.transfer(to, value));
174   }
175 
176   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
177     assert(token.transferFrom(from, to, value));
178   }
179 
180   function safeApprove(ERC20 token, address spender, uint256 value) internal {
181     assert(token.approve(spender, value));
182   }
183 }
184 
185 contract Pausable is Ownable {
186   event Pause();
187   event Unpause();
188 
189   bool public paused = false;
190 
191 
192   /**
193    * @dev Modifier to make a function callable only when the contract is not paused.
194    */
195   modifier whenNotPaused() {
196     require(!paused);
197     _;
198   }
199 
200   /**
201    * @dev Modifier to make a function callable only when the contract is paused.
202    */
203   modifier whenPaused() {
204     require(paused);
205     _;
206   }
207 
208   /**
209    * @dev called by the owner to pause, triggers stopped state
210    */
211   function pause() onlyOwner whenNotPaused public {
212     paused = true;
213     Pause();
214   }
215 
216   /**
217    * @dev called by the owner to unpause, returns to normal state
218    */
219   function unpause() onlyOwner whenPaused public {
220     paused = false;
221     Unpause();
222   }
223 }
224 
225 contract NucleusVisionAllocation is Ownable {
226   using SafeMath for uint256;
227 
228   // The token being minted.
229   NucleusVisionToken public token;
230 
231   // map of address to token vesting contract
232   mapping (address => TokenVesting) public vesting;
233 
234   /**
235    * event for token mint logging
236    * @param beneficiary who is receiving the tokens
237    * @param tokens amount of tokens given to the beneficiary
238    */
239   event NucleusVisionTokensMinted(address beneficiary, uint256 tokens);
240 
241   /**
242    * event for time vested token mint logging
243    * @param beneficiary who is receiving the time vested tokens
244    * @param tokens amount of tokens that will be vested to the beneficiary
245    * @param start unix timestamp at which the tokens will start vesting
246    * @param cliff duration in seconds after start time at which vesting will start
247    * @param duration total duration in seconds in which the tokens will be vested
248    */
249   event NucleusVisionTimeVestingTokensMinted(address beneficiary, uint256 tokens, uint256 start, uint256 cliff, uint256 duration);
250 
251   /**
252    * event for air drop token mint loggin
253    * @param beneficiary who is receiving the airdrop tokens
254    * @param tokens airdropped
255    */
256   event NucleusVisionAirDropTokensMinted(address beneficiary, uint256 tokens);
257 
258   /**
259    * @dev Creates a new NucleusVisionAllocation contract
260    */
261   function NucleusVisionAllocation() public {
262     token = new NucleusVisionToken();
263   }
264 
265   // member function to mint tokens to a beneficiary
266   function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
267     require(beneficiary != 0x0);
268     require(tokens > 0);
269 
270     require(token.mint(beneficiary, tokens));
271     NucleusVisionTokensMinted(beneficiary, tokens);
272   }
273 
274   // member function to mint time based vesting tokens to a beneficiary
275   function mintTokensWithTimeBasedVesting(address beneficiary, uint256 tokens, uint256 start, uint256 cliff, uint256 duration) public onlyOwner {
276     require(beneficiary != 0x0);
277     require(tokens > 0);
278 
279     vesting[beneficiary] = new TokenVesting(beneficiary, start, cliff, duration, false);
280     require(token.mint(address(vesting[beneficiary]), tokens));
281 
282     NucleusVisionTimeVestingTokensMinted(beneficiary, tokens, start, cliff, duration);
283   }
284 
285   function mintAirDropTokens(uint256 tokens, address[] addresses) public onlyOwner {
286     require(tokens > 0);
287     for (uint256 i = 0; i < addresses.length; i++) {
288       require(token.mint(addresses[i], tokens));
289       NucleusVisionAirDropTokensMinted(addresses[i], tokens);
290     }
291   }
292 
293   // member function to finish the minting process
294   function finishAllocation() public onlyOwner {
295     require(token.finishMinting());
296   }
297 
298   // member function to unlock token for trading
299   function unlockToken() public onlyOwner {
300     token.unlockToken();
301   }
302 
303   // member function that can be called to release vested tokens periodically
304   function releaseVestedTokens(address beneficiary) public {
305     require(beneficiary != 0x0);
306 
307     TokenVesting tokenVesting = vesting[beneficiary];
308     tokenVesting.release(token);
309   }
310 
311   // transfer token ownership after allocation
312   function transferTokenOwnership(address owner) public onlyOwner {
313     require(token.mintingFinished());
314     token.transferOwnership(owner);
315   }
316 }
317 
318 contract ERC20Basic {
319   uint256 public totalSupply;
320   function balanceOf(address who) public view returns (uint256);
321   function transfer(address to, uint256 value) public returns (bool);
322   event Transfer(address indexed from, address indexed to, uint256 value);
323 }
324 
325 contract ERC20 is ERC20Basic {
326   function allowance(address owner, address spender) public view returns (uint256);
327   function transferFrom(address from, address to, uint256 value) public returns (bool);
328   function approve(address spender, uint256 value) public returns (bool);
329   event Approval(address indexed owner, address indexed spender, uint256 value);
330 }
331 
332 contract BasicToken is ERC20Basic {
333   using SafeMath for uint256;
334 
335   mapping(address => uint256) balances;
336 
337   /**
338   * @dev transfer token for a specified address
339   * @param _to The address to transfer to.
340   * @param _value The amount to be transferred.
341   */
342   function transfer(address _to, uint256 _value) public returns (bool) {
343     require(_to != address(0));
344     require(_value <= balances[msg.sender]);
345 
346     // SafeMath.sub will throw if there is not enough balance.
347     balances[msg.sender] = balances[msg.sender].sub(_value);
348     balances[_to] = balances[_to].add(_value);
349     Transfer(msg.sender, _to, _value);
350     return true;
351   }
352 
353   /**
354   * @dev Gets the balance of the specified address.
355   * @param _owner The address to query the the balance of.
356   * @return An uint256 representing the amount owned by the passed address.
357   */
358   function balanceOf(address _owner) public view returns (uint256 balance) {
359     return balances[_owner];
360   }
361 
362 }
363 
364 contract StandardToken is ERC20, BasicToken {
365 
366   mapping (address => mapping (address => uint256)) internal allowed;
367 
368 
369   /**
370    * @dev Transfer tokens from one address to another
371    * @param _from address The address which you want to send tokens from
372    * @param _to address The address which you want to transfer to
373    * @param _value uint256 the amount of tokens to be transferred
374    */
375   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
376     require(_to != address(0));
377     require(_value <= balances[_from]);
378     require(_value <= allowed[_from][msg.sender]);
379 
380     balances[_from] = balances[_from].sub(_value);
381     balances[_to] = balances[_to].add(_value);
382     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
383     Transfer(_from, _to, _value);
384     return true;
385   }
386 
387   /**
388    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
389    *
390    * Beware that changing an allowance with this method brings the risk that someone may use both the old
391    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
392    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
393    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
394    * @param _spender The address which will spend the funds.
395    * @param _value The amount of tokens to be spent.
396    */
397   function approve(address _spender, uint256 _value) public returns (bool) {
398     allowed[msg.sender][_spender] = _value;
399     Approval(msg.sender, _spender, _value);
400     return true;
401   }
402 
403   /**
404    * @dev Function to check the amount of tokens that an owner allowed to a spender.
405    * @param _owner address The address which owns the funds.
406    * @param _spender address The address which will spend the funds.
407    * @return A uint256 specifying the amount of tokens still available for the spender.
408    */
409   function allowance(address _owner, address _spender) public view returns (uint256) {
410     return allowed[_owner][_spender];
411   }
412 
413   /**
414    * @dev Increase the amount of tokens that an owner allowed to a spender.
415    *
416    * approve should be called when allowed[_spender] == 0. To increment
417    * allowed value is better to use this function to avoid 2 calls (and wait until
418    * the first transaction is mined)
419    * From MonolithDAO Token.sol
420    * @param _spender The address which will spend the funds.
421    * @param _addedValue The amount of tokens to increase the allowance by.
422    */
423   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
424     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
425     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429   /**
430    * @dev Decrease the amount of tokens that an owner allowed to a spender.
431    *
432    * approve should be called when allowed[_spender] == 0. To decrement
433    * allowed value is better to use this function to avoid 2 calls (and wait until
434    * the first transaction is mined)
435    * From MonolithDAO Token.sol
436    * @param _spender The address which will spend the funds.
437    * @param _subtractedValue The amount of tokens to decrease the allowance by.
438    */
439   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
440     uint oldValue = allowed[msg.sender][_spender];
441     if (_subtractedValue > oldValue) {
442       allowed[msg.sender][_spender] = 0;
443     } else {
444       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
445     }
446     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
447     return true;
448   }
449 
450 }
451 
452 contract MintableToken is StandardToken, Ownable {
453   event Mint(address indexed to, uint256 amount);
454   event MintFinished();
455 
456   bool public mintingFinished = false;
457 
458 
459   modifier canMint() {
460     require(!mintingFinished);
461     _;
462   }
463 
464   /**
465    * @dev Function to mint tokens
466    * @param _to The address that will receive the minted tokens.
467    * @param _amount The amount of tokens to mint.
468    * @return A boolean that indicates if the operation was successful.
469    */
470   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
471     totalSupply = totalSupply.add(_amount);
472     balances[_to] = balances[_to].add(_amount);
473     Mint(_to, _amount);
474     Transfer(address(0), _to, _amount);
475     return true;
476   }
477 
478   /**
479    * @dev Function to stop minting new tokens.
480    * @return True if the operation was successful.
481    */
482   function finishMinting() onlyOwner canMint public returns (bool) {
483     mintingFinished = true;
484     MintFinished();
485     return true;
486   }
487 }
488 
489 contract NucleusVisionToken is MintableToken {
490   string public constant name = "NucleusVision";
491   string public constant symbol = "nCash";
492   uint8 public constant decimals = 18;
493 
494   // Total supply of nCash tokens is 10 Billion
495   uint256 public constant MAX_SUPPLY = 10 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
496   // Bit that controls whether the token can be transferred / traded
497   bool public unlocked = false;
498 
499   event NucleusVisionTokenUnlocked();
500 
501   /**
502    * @dev totalSupply is set via the minting process
503    */
504   function NucleusVisionToken() public {
505   }
506 
507   function mint(address to, uint256 amount) onlyOwner public returns (bool) {
508     require(totalSupply + amount <= MAX_SUPPLY);
509     return super.mint(to, amount);
510   }
511 
512   function unlockToken() onlyOwner public {
513     require (!unlocked);
514     unlocked = true;
515     NucleusVisionTokenUnlocked();
516   }
517 
518   // Overriding basic ERC-20 specification that lets people transfer/approve tokens.
519   function transfer(address to, uint256 value) public returns (bool) {
520     require(unlocked);
521     return super.transfer(to, value);
522   }
523 
524   function transferFrom(address from, address to, uint256 value) public returns (bool) {
525     require(unlocked);
526     return super.transferFrom(from, to, value);
527   }
528 
529   function approve(address spender, uint256 value) public returns (bool) {
530     require(unlocked);
531     return super.approve(spender, value);
532   }
533 
534   // Overriding StandardToken functions that lets people transfer/approve tokens.
535   function increaseApproval(address spender, uint addedValue) public returns (bool) {
536     require(unlocked);
537     return super.increaseApproval(spender, addedValue);
538   }
539 
540   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
541     require(unlocked);
542     return super.decreaseApproval(spender, subtractedValue);
543   }
544 
545 }