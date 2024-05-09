1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135   }
136 }
137 
138 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
139 
140 /**
141  * @title Ownable
142  * @dev The Ownable contract has an owner address, and provides basic authorization control
143  * functions, this simplifies the implementation of "user permissions".
144  */
145 contract Ownable {
146   address public owner;
147   address public owner2;
148 
149   address private owner2_address = 0x615B255EEE9cdb8BF1FA7db3EE101106673E8DCB;
150 
151   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159     owner2 = owner2_address;
160   }
161 
162   /**
163    * @dev Throws if called by any account other than the owner.
164    */
165   modifier onlyOwner() {
166     require(msg.sender == owner || msg.sender == owner2);
167     _;
168   }
169 
170   modifier onlyOwner2() {
171     require(msg.sender == owner2);
172     _;
173   }
174 
175   /**
176    * @dev Allows the current owner to transfer control of the contract to a newOwner.
177    * @param newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address newOwner) public onlyOwner {
180     require(newOwner != address(0));
181     OwnershipTransferred(owner, newOwner);
182     owner = newOwner;
183   }
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership2(address newOwner) public onlyOwner2 {
190     require(newOwner != address(0));
191     OwnershipTransferred(owner2, newOwner);
192     owner2 = newOwner;
193   }
194 
195 }
196 
197 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address owner, address spender) public view returns (uint256);
205   function transferFrom(address from, address to, uint256 value) public returns (bool);
206   function approve(address spender, uint256 value) public returns (bool);
207   event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     Transfer(_from, _to, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    *
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param _spender The address which will spend the funds.
250    * @param _value The amount of tokens to be spent.
251    */
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) public view returns (uint256) {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
279     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
334     totalSupply_ = totalSupply_.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     Mint(_to, _amount);
337     Transfer(address(0), _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner canMint public returns (bool) {
346     mintingFinished = true;
347     MintFinished();
348     return true;
349   }
350 }
351 
352 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
353 
354 /**
355  * @title Pausable
356  * @dev Base contract which allows children to implement an emergency stop mechanism.
357  */
358 contract Pausable is Ownable {
359   event Pause();
360   event Unpause();
361 
362   bool public paused = false;
363 
364 
365   /**
366    * @dev Modifier to make a function callable only when the contract is not paused.
367    */
368   modifier whenNotPaused() {
369     require(!paused);
370     _;
371   }
372 
373   /**
374    * @dev Modifier to make a function callable only when the contract is paused.
375    */
376   modifier whenPaused() {
377     require(paused);
378     _;
379   }
380 
381   /**
382    * @dev called by the owner to pause, triggers stopped state
383    */
384   function pause() onlyOwner whenNotPaused public {
385     paused = true;
386     Pause();
387   }
388 
389   /**
390    * @dev called by the owner to unpause, returns to normal state
391    */
392   function unpause() onlyOwner whenPaused public {
393     paused = false;
394     Unpause();
395   }
396 }
397 
398 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
399 
400 /**
401  * @title Pausable token
402  * @dev StandardToken modified with pausable transfers.
403  **/
404 contract PausableToken is StandardToken, Pausable {
405 
406   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
407     return super.transfer(_to, _value);
408   }
409 
410   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
411     return super.transferFrom(_from, _to, _value);
412   }
413 
414   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
415     return super.approve(_spender, _value);
416   }
417 
418   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
419     return super.increaseApproval(_spender, _addedValue);
420   }
421 
422   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
423     return super.decreaseApproval(_spender, _subtractedValue);
424   }
425 }
426 
427 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
428 
429 /**
430  * @title SafeERC20
431  * @dev Wrappers around ERC20 operations that throw on failure.
432  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
433  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
434  */
435 library SafeERC20 {
436   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
437     assert(token.transfer(to, value));
438   }
439 
440   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
441     assert(token.transferFrom(from, to, value));
442   }
443 
444   function safeApprove(ERC20 token, address spender, uint256 value) internal {
445     assert(token.approve(spender, value));
446   }
447 }
448 
449 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
450 
451 /**
452  * @title TokenTimelock
453  * @dev TokenTimelock is a token holder contract that will allow a
454  * beneficiary to extract the tokens after a given release time
455  */
456 contract TokenTimelock {
457   using SafeERC20 for ERC20Basic;
458 
459   // ERC20 basic token contract being held
460   ERC20Basic public token;
461 
462   // beneficiary of tokens after they are released
463   address public beneficiary;
464 
465   // timestamp when token release is enabled
466   uint256 public releaseTime;
467 
468   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
469     require(_releaseTime > now);
470     token = _token;
471     beneficiary = _beneficiary;
472     releaseTime = _releaseTime;
473   }
474 
475   /**
476    * @notice Transfers tokens held by timelock to beneficiary.
477    */
478   function release() public {
479     require(now >= releaseTime);
480 
481     uint256 amount = token.balanceOf(this);
482     require(amount > 0);
483 
484     token.safeTransfer(beneficiary, amount);
485   }
486 }
487 
488 // File: contracts/PBKtoken.sol
489 
490 contract PBKtoken is MintableToken, PausableToken, BurnableToken {
491   string public name = "PlasmaBank token"; 
492   string public symbol = "PBK";
493   uint public decimals = 2;
494 
495   /// @dev whether an address is permitted to perform burn operations.
496   mapping(address => bool) public isBurner;
497 
498   event ReceivedEther(address from, uint256 value);
499   event WithdrewEther(address to, uint256 value);
500 
501   address PlasmaPrivateTokenSale            = 0xec0767B180C05B261A23744cCF8EB89b677dFeE1;
502   address PlasmaPreTokenSaleReserve         = 0x2910dB084a467131C121626987b3F8b69ebaE82A;
503   address PlasmaTokenSaleReserve            = 0x516154A8e9d365dC976f977E6815710b94B8C9f6;
504   address PlasmaReserveForBonus             = 0x47e061914750f0Ee7C7675da0D62A59e2bd27dc4;
505   address PlasmaReserveForBounty            = 0xdbf81Af07e37ec855653de1dB152E578d847f215;
506   address PlasmaReserveForEarlyBirds        = 0x831360b8Dd93692d1A0Bdf7fdE8C037BaB1CE631;
507   address PlasmaTeamOptionsReserveAddress   = 0x04D20280B1E870688B7552E14171923215D3411C;
508   address PlasmaFrozenForInstitutionalSales = 0x88bF0Ae762B801943190D1B7D757103BA9Dd6eAb;
509   address PlasmaReserveForAdvisors          = 0x6Df994BdCA65f6bdAb66c72cd3fE3666cc183E37;
510   address PlasmaFoundationReserve           = 0xF0dbBDb93344Bc679F8f0CffAE187D324917F44b;
511   address PlasmaFrozenForTopManagement      = 0x5ed22d37BB1A16a15E9a2dD6F46b9C891164916B;
512   address PlasmaFrozenForTokenSale2020      = 0x67F585f3EB7363E26744aA19E8f217D70e7E0001;
513 
514   function PBKtoken() public {
515     mint(PlasmaPrivateTokenSale,            500000000 * (10 ** decimals));
516     mint(PlasmaPreTokenSaleReserve,         300000000 * (10 ** decimals));
517     mint(PlasmaTokenSaleReserve,            3200000000 * (10 ** decimals));
518     mint(PlasmaReserveForBonus,             100000000 * (10 ** decimals));
519     mint(PlasmaReserveForBounty,            100000000 * (10 ** decimals));
520     mint(PlasmaReserveForEarlyBirds,        200000000 * (10 ** decimals));
521     mint(PlasmaTeamOptionsReserveAddress,   800000000 * (10 ** decimals));
522     mint(PlasmaFrozenForInstitutionalSales, 500000000 * (10 ** decimals));
523     mint(PlasmaReserveForAdvisors,          300000000 * (10 ** decimals));
524     mint(PlasmaFoundationReserve,           1000000000 * (10 ** decimals));
525     mint(PlasmaFrozenForTopManagement,      1500000000 * (10 ** decimals));
526     mint(PlasmaFrozenForTokenSale2020,      1500000000 * (10 ** decimals));
527 
528     assert(totalSupply_ == 10000000000 * (10 ** decimals));
529     
530     finishMinting();
531   }
532 
533   function transferTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public
534     returns (TokenTimelock) {
535 
536     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
537     transferFrom(msg.sender, timelock, _amount);
538 
539     return timelock;
540   }
541 
542   /**
543    * @dev Grant or remove burn permissions. Only owner can do that!
544    */
545   function grantBurner(address _burner, bool _value) public onlyOwner {
546       isBurner[_burner] = _value;
547   }
548 
549   /**
550    * @dev Throws if called by any account other than the burner.
551    */
552   modifier onlyBurner() {
553       require(isBurner[msg.sender]);
554       _;
555   }
556 
557   /**
558    * @dev Burns a specific amount of tokens.
559    * Only an address listed in `isBurner` can do this.
560    * @param _value The amount of token to be burned.
561    */
562   function burn(uint256 _value) public onlyBurner {
563       super.burn(_value);
564   }
565 
566   // transfer balance to owner
567   function withdrawEther(uint256 amount) public onlyOwner {
568     owner.transfer(amount);
569     WithdrewEther(msg.sender, amount);
570   }
571 
572   // can accept ether
573   function() payable private {
574     ReceivedEther(msg.sender, msg.value);
575   }
576 }