1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/FreezableToken.sol
46 
47 /**
48 * @title Freezable Token
49 * @dev Token that can be freezed for chosen token holder.
50 */
51 contract FreezableToken is Ownable {
52 
53     mapping (address => bool) public frozenList;
54 
55     event FrozenFunds(address indexed wallet, bool frozen);
56 
57     /**
58     * @dev Owner can freeze the token balance for chosen token holder.
59     * @param _wallet The address of token holder whose tokens to be frozen.
60     */
61     function freezeAccount(address _wallet) public onlyOwner {
62         require(_wallet != address(0));
63         frozenList[_wallet] = true;
64         emit FrozenFunds(_wallet, true);
65     }
66 
67     /**
68     * @dev Owner can unfreeze the token balance for chosen token holder.
69     * @param _wallet The address of token holder whose tokens to be unfrozen.
70     */
71     function unfreezeAccount(address _wallet) public onlyOwner {
72         require(_wallet != address(0));
73         frozenList[_wallet] = false;
74         emit FrozenFunds(_wallet, false);
75     }
76 
77     /**
78     * @dev Check the specified token holder whether his/her token balance is frozen.
79     * @param _wallet The address of token holder to check.
80     */ 
81     function isFrozen(address _wallet) public view returns (bool) {
82         return frozenList[_wallet];
83     }
84 
85 }
86 
87 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
115 
116 /**
117  * @title SafeERC20
118  * @dev Wrappers around ERC20 operations that throw on failure.
119  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
120  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
121  */
122 library SafeERC20 {
123   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
124     assert(token.transfer(to, value));
125   }
126 
127   function safeTransferFrom(
128     ERC20 token,
129     address from,
130     address to,
131     uint256 value
132   )
133     internal
134   {
135     assert(token.transferFrom(from, to, value));
136   }
137 
138   function safeApprove(ERC20 token, address spender, uint256 value) internal {
139     assert(token.approve(spender, value));
140   }
141 }
142 
143 // File: contracts/TokenTimelock.sol
144 
145 /**
146  * @title TokenTimelock
147  * @dev TokenTimelock is a token holder contract that will allow a
148  * beneficiary to extract the tokens after a given release time
149  */
150 contract TokenTimelock {
151     using SafeERC20 for ERC20Basic;
152 
153     // ERC20 basic token contract being held
154     ERC20Basic public token;
155 
156     // beneficiary of tokens after they are released
157     address public beneficiary;
158 
159     // timestamp when token release is enabled
160     uint256 public releaseTime;
161 
162     constructor(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
163         require(_releaseTime > now);
164         token = _token;
165         beneficiary = _beneficiary;
166         releaseTime = _releaseTime;
167     }
168 
169     /**
170     * @notice Transfers tokens held by timelock to beneficiary.
171     */
172     function release() public {
173         require(now >= releaseTime);
174 
175         uint256 amount = token.balanceOf(this);
176         require(amount > 0);
177 
178         // Change  safeTransfer -> transfer because issue with assert function with ref type.
179         token.transfer(beneficiary, amount);
180     }
181 }
182 
183 // File: zeppelin-solidity/contracts/math/SafeMath.sol
184 
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
195     if (a == 0) {
196       return 0;
197     }
198     c = a * b;
199     assert(c / a == b);
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers, truncating the quotient.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     // uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return a / b;
211   }
212 
213   /**
214   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217     assert(b <= a);
218     return a - b;
219   }
220 
221   /**
222   * @dev Adds two numbers, throws on overflow.
223   */
224   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
225     c = a + b;
226     assert(c >= a);
227     return c;
228   }
229 }
230 
231 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
232 
233 /**
234  * @title Basic token
235  * @dev Basic version of StandardToken, with no allowances.
236  */
237 contract BasicToken is ERC20Basic {
238   using SafeMath for uint256;
239 
240   mapping(address => uint256) balances;
241 
242   uint256 totalSupply_;
243 
244   /**
245   * @dev total number of tokens in existence
246   */
247   function totalSupply() public view returns (uint256) {
248     return totalSupply_;
249   }
250 
251   /**
252   * @dev transfer token for a specified address
253   * @param _to The address to transfer to.
254   * @param _value The amount to be transferred.
255   */
256   function transfer(address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[msg.sender]);
259 
260     balances[msg.sender] = balances[msg.sender].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     emit Transfer(msg.sender, _to, _value);
263     return true;
264   }
265 
266   /**
267   * @dev Gets the balance of the specified address.
268   * @param _owner The address to query the the balance of.
269   * @return An uint256 representing the amount owned by the passed address.
270   */
271   function balanceOf(address _owner) public view returns (uint256) {
272     return balances[_owner];
273   }
274 
275 }
276 
277 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
278 
279 /**
280  * @title Standard ERC20 token
281  *
282  * @dev Implementation of the basic standard token.
283  * @dev https://github.com/ethereum/EIPs/issues/20
284  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
285  */
286 contract StandardToken is ERC20, BasicToken {
287 
288   mapping (address => mapping (address => uint256)) internal allowed;
289 
290 
291   /**
292    * @dev Transfer tokens from one address to another
293    * @param _from address The address which you want to send tokens from
294    * @param _to address The address which you want to transfer to
295    * @param _value uint256 the amount of tokens to be transferred
296    */
297   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
298     require(_to != address(0));
299     require(_value <= balances[_from]);
300     require(_value <= allowed[_from][msg.sender]);
301 
302     balances[_from] = balances[_from].sub(_value);
303     balances[_to] = balances[_to].add(_value);
304     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305     emit Transfer(_from, _to, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
311    *
312    * Beware that changing an allowance with this method brings the risk that someone may use both the old
313    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
314    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
315    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) public returns (bool) {
320     allowed[msg.sender][_spender] = _value;
321     emit Approval(msg.sender, _spender, _value);
322     return true;
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param _owner address The address which owns the funds.
328    * @param _spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(address _owner, address _spender) public view returns (uint256) {
332     return allowed[_owner][_spender];
333   }
334 
335   /**
336    * @dev Increase the amount of tokens that an owner allowed to a spender.
337    *
338    * approve should be called when allowed[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _addedValue The amount of tokens to increase the allowance by.
344    */
345   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
346     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
347     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348     return true;
349   }
350 
351   /**
352    * @dev Decrease the amount of tokens that an owner allowed to a spender.
353    *
354    * approve should be called when allowed[_spender] == 0. To decrement
355    * allowed value is better to use this function to avoid 2 calls (and wait until
356    * the first transaction is mined)
357    * From MonolithDAO Token.sol
358    * @param _spender The address which will spend the funds.
359    * @param _subtractedValue The amount of tokens to decrease the allowance by.
360    */
361   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
362     uint oldValue = allowed[msg.sender][_spender];
363     if (_subtractedValue > oldValue) {
364       allowed[msg.sender][_spender] = 0;
365     } else {
366       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
367     }
368     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369     return true;
370   }
371 
372 }
373 
374 // File: contracts/SaifuToken.sol
375 
376 contract SaifuToken is StandardToken, FreezableToken {
377     using SafeMath for uint256;
378 
379     string public constant name = "Saifu";
380     string public constant symbol = "SFU";
381     uint8 public constant decimals = 18;
382 
383     uint256 public constant INITIAL_TOTAL_SUPPLY = 200e6 * (10 ** uint256(decimals));
384     uint256 public constant AMOUNT_TOKENS_FOR_SELL = 130e6 * (10 ** uint256(decimals));
385 
386     uint256 public constant RESERVE_FUND = 20e6 * (10 ** uint256(decimals));
387     uint256 public constant RESERVED_FOR_TEAM = 50e6 * (10 ** uint256(decimals));
388 
389     uint256 public constant RESERVED_TOTAL_AMOUNT = 70e6 * (10 ** uint256(decimals));
390     
391     uint256 public alreadyReservedForTeam = 0;
392 
393     address public burnAddress;
394 
395     bool private isReservedFundsDone = false;
396 
397     uint256 private setBurnAddressCount = 0;
398 
399     // Key: address of wallet, Value: address of contract.
400     mapping (address => address) private lockedList;
401 
402     /**
403     * @dev Throws if called by any account other than the burnable account.
404     */
405     modifier onlyBurnAddress() {
406         require(msg.sender == burnAddress);
407         _;
408     }
409 
410     /**
411     * @dev Create SaifuToken contract
412     */
413     constructor() public {
414         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
415 
416         balances[owner] = balances[owner].add(AMOUNT_TOKENS_FOR_SELL);
417         emit Transfer(address(0), owner, AMOUNT_TOKENS_FOR_SELL);
418 
419         balances[this] = balances[this].add(RESERVED_TOTAL_AMOUNT);
420         emit Transfer(address(0), this, RESERVED_TOTAL_AMOUNT);
421     }
422 
423      /**
424     * @dev Transfer token for a specified address.
425     * @dev Only applies when the transfer is allowed by the owner.
426     * @param _to The address to transfer to.
427     * @param _value The amount to be transferred.
428     */
429     function transfer(address _to, uint256 _value) public returns (bool) {
430         require(!isFrozen(msg.sender));
431         return super.transfer(_to, _value);
432     }
433 
434     /**
435     * @dev Transfer tokens from one address to another.
436     * @dev Only applies when the transfer is allowed by the owner.
437     * @param _from address The address which you want to send tokens from
438     * @param _to address The address which you want to transfer to
439     * @param _value uint256 the amount of tokens to be transferred
440     */
441     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
442         require(!isFrozen(msg.sender));
443         require(!isFrozen(_from));
444         return super.transferFrom(_from, _to, _value);
445     }
446 
447     /**
448     * @dev Set burn address.
449     * @param _address New burn address
450     */
451     function setBurnAddress(address _address) public onlyOwner {
452         require(setBurnAddressCount < 3);
453         require(_address != address(0));
454         burnAddress = _address;
455         setBurnAddressCount = setBurnAddressCount.add(1);
456     }
457 
458     /**
459     * @dev Reserve funds.
460     * @param _address the address for reserve funds. 
461     */
462     function reserveFunds(address _address) public onlyOwner {
463         require(_address != address(0));
464 
465         require(!isReservedFundsDone);
466 
467         sendFromContract(_address, RESERVE_FUND);
468         
469         isReservedFundsDone = true;
470     }
471 
472     /**
473     * @dev Get locked contract address.
474     * @param _address the address of owner these tokens.
475     */
476     function getLockedContract(address _address) public view returns(address) {
477         return lockedList[_address];
478     }
479 
480     /**
481     * @dev Reserve for team.
482     * @param _address the address for reserve. 
483     * @param _amount the specified amount for reserve. 
484     * @param _time the specified freezing time (in days). 
485     */
486     function reserveForTeam(address _address, uint256 _amount, uint256  _time) public onlyOwner {
487         require(_address != address(0));
488         require(_amount > 0 && _amount <= RESERVED_FOR_TEAM.sub(alreadyReservedForTeam));
489 
490         if (_time > 0) {
491             address lockedAddress = new TokenTimelock(this, _address, now.add(_time * 1 days));
492             lockedList[_address] = lockedAddress;
493             sendFromContract(lockedAddress, _amount);
494         } else {
495             sendFromContract(_address, _amount);
496         }
497         
498         alreadyReservedForTeam = alreadyReservedForTeam.add(_amount);
499     }
500 
501     /**
502     * @dev Send tokens which will be frozen for specified time.
503     * @param _address the address for send. 
504     * @param _amount the specified amount for send. 
505     * @param _time the specified freezing time (in seconds). 
506     */
507     function sendWithFreeze(address _address, uint256 _amount, uint256  _time) public onlyOwner {
508         require(_address != address(0) && _amount > 0 && _time > 0);
509 
510         address lockedAddress = new TokenTimelock(this, _address, now.add(_time));
511         lockedList[_address] = lockedAddress;
512         transfer(lockedAddress, _amount);
513     }
514 
515     /**
516     * @dev Unlock frozen tokens.
517     * @param _address the address for which to release already unlocked tokens. 
518     */
519     function unlockTokens(address _address) public {
520         require(lockedList[_address] != address(0));
521 
522         TokenTimelock lockedContract = TokenTimelock(lockedList[_address]);
523 
524         lockedContract.release();
525     }
526 
527     /**
528     * @dev Burn a specific amount of tokens.
529     * @param _amount The Amount of tokens.
530     */
531     function burnFromAddress(uint256 _amount) public onlyBurnAddress {
532         require(_amount > 0);
533         require(_amount <= balances[burnAddress]);
534 
535         balances[burnAddress] = balances[burnAddress].sub(_amount);
536         totalSupply_ = totalSupply_.sub(_amount);
537         emit Transfer(burnAddress, address(0), _amount);
538     }
539 
540     /*
541     * @dev Send tokens from contract.
542     * @param _address the address destination. 
543     * @param _amount the specified amount for send.
544      */
545     function sendFromContract(address _address, uint256 _amount) internal {
546         balances[this] = balances[this].sub(_amount);
547         balances[_address] = balances[_address].add(_amount);
548         emit Transfer(this, _address, _amount);
549     }
550 }