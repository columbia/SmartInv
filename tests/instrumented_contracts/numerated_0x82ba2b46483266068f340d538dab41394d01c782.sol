1 pragma solidity ^0.4.19;
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
21   function Ownable() public {
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
39     OwnershipTransferred(owner, newOwner);
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
61     function freezeAccount(address _wallet) onlyOwner public {
62         require(_wallet != address(0));
63         frozenList[_wallet] = true;
64         FrozenFunds(_wallet, true);
65     }
66 
67     /**
68     * @dev Owner can unfreeze the token balance for chosen token holder.
69     * @param _wallet The address of token holder whose tokens to be unfrozen.
70     */
71     function unfreezeAccount(address _wallet) onlyOwner public {
72         require(_wallet != address(0));
73         frozenList[_wallet] = false;
74         FrozenFunds(_wallet, false);
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
127   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
128     assert(token.transferFrom(from, to, value));
129   }
130 
131   function safeApprove(ERC20 token, address spender, uint256 value) internal {
132     assert(token.approve(spender, value));
133   }
134 }
135 
136 // File: contracts/TokenTimelock.sol
137 
138 /**
139  * @title TokenTimelock
140  * @dev TokenTimelock is a token holder contract that will allow a
141  * beneficiary to extract the tokens after a given release time
142  */
143 contract TokenTimelock {
144     using SafeERC20 for ERC20Basic;
145 
146     // ERC20 basic token contract being held
147     ERC20Basic public token;
148 
149     // beneficiary of tokens after they are released
150     address public beneficiary;
151 
152     // timestamp when token release is enabled
153     uint256 public releaseTime;
154 
155     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
156         require(_releaseTime > now);
157         token = _token;
158         beneficiary = _beneficiary;
159         releaseTime = _releaseTime;
160     }
161 
162     /**
163     * @notice Transfers tokens held by timelock to beneficiary.
164     */
165     function release() public {
166         require(now >= releaseTime);
167 
168         uint256 amount = token.balanceOf(this);
169         require(amount > 0);
170 
171         // Change  safeTransfer -> transfer because issue with assert function with ref type.
172         token.transfer(beneficiary, amount);
173     }
174 }
175 
176 // File: zeppelin-solidity/contracts/math/SafeMath.sol
177 
178 /**
179  * @title SafeMath
180  * @dev Math operations with safety checks that throw on error
181  */
182 library SafeMath {
183 
184   /**
185   * @dev Multiplies two numbers, throws on overflow.
186   */
187   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188     if (a == 0) {
189       return 0;
190     }
191     uint256 c = a * b;
192     assert(c / a == b);
193     return c;
194   }
195 
196   /**
197   * @dev Integer division of two numbers, truncating the quotient.
198   */
199   function div(uint256 a, uint256 b) internal pure returns (uint256) {
200     // assert(b > 0); // Solidity automatically throws when dividing by 0
201     uint256 c = a / b;
202     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203     return c;
204   }
205 
206   /**
207   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
208   */
209   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210     assert(b <= a);
211     return a - b;
212   }
213 
214   /**
215   * @dev Adds two numbers, throws on overflow.
216   */
217   function add(uint256 a, uint256 b) internal pure returns (uint256) {
218     uint256 c = a + b;
219     assert(c >= a);
220     return c;
221   }
222 }
223 
224 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
225 
226 /**
227  * @title Basic token
228  * @dev Basic version of StandardToken, with no allowances.
229  */
230 contract BasicToken is ERC20Basic {
231   using SafeMath for uint256;
232 
233   mapping(address => uint256) balances;
234 
235   uint256 totalSupply_;
236 
237   /**
238   * @dev total number of tokens in existence
239   */
240   function totalSupply() public view returns (uint256) {
241     return totalSupply_;
242   }
243 
244   /**
245   * @dev transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249   function transfer(address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[msg.sender]);
252 
253     // SafeMath.sub will throw if there is not enough balance.
254     balances[msg.sender] = balances[msg.sender].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     Transfer(msg.sender, _to, _value);
257     return true;
258   }
259 
260   /**
261   * @dev Gets the balance of the specified address.
262   * @param _owner The address to query the the balance of.
263   * @return An uint256 representing the amount owned by the passed address.
264   */
265   function balanceOf(address _owner) public view returns (uint256 balance) {
266     return balances[_owner];
267   }
268 
269 }
270 
271 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * @dev https://github.com/ethereum/EIPs/issues/20
278  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281 
282   mapping (address => mapping (address => uint256)) internal allowed;
283 
284 
285   /**
286    * @dev Transfer tokens from one address to another
287    * @param _from address The address which you want to send tokens from
288    * @param _to address The address which you want to transfer to
289    * @param _value uint256 the amount of tokens to be transferred
290    */
291   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
292     require(_to != address(0));
293     require(_value <= balances[_from]);
294     require(_value <= allowed[_from][msg.sender]);
295 
296     balances[_from] = balances[_from].sub(_value);
297     balances[_to] = balances[_to].add(_value);
298     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299     Transfer(_from, _to, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305    *
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(address _owner, address _spender) public view returns (uint256) {
326     return allowed[_owner][_spender];
327   }
328 
329   /**
330    * @dev Increase the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To increment
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _addedValue The amount of tokens to increase the allowance by.
338    */
339   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
340     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
341     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
356     uint oldValue = allowed[msg.sender][_spender];
357     if (_subtractedValue > oldValue) {
358       allowed[msg.sender][_spender] = 0;
359     } else {
360       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
361     }
362     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366 }
367 
368 // File: contracts/SaifuToken.sol
369 
370 contract SaifuToken is StandardToken, FreezableToken {
371     using SafeMath for uint256;
372 
373     string constant public name = "Saifu";
374     string constant public symbol = "SFU";
375     uint8 constant public decimals = 18;
376 
377     uint256 constant public INITIAL_TOTAL_SUPPLY = 200e6 * (uint256(10) ** decimals);
378     uint256 constant public AMOUNT_TOKENS_FOR_SELL = 130e6 * (uint256(10) ** decimals);
379 
380     uint256 constant public RESERVE_FUND = 20e6 * (uint256(10) ** decimals);
381     uint256 constant public RESERVED_FOR_TEAM = 50e6 * (uint256(10) ** decimals);
382 
383     uint256 constant public RESERVED_TOTAL_AMOUNT = 70e6 * (uint256(10) ** decimals);
384     
385     uint256 public alreadyReservedForTeam = 0;
386 
387     bool private isReservedFundsDone = false;
388 
389     address public burnAddress;
390 
391     uint256 private setBurnAddressCount = 0;
392 
393     // Key: address of wallet, Value: address of contract.
394     mapping (address => address) private lockedList;
395 
396     /**
397     * @dev Throws if called by any account other than the burnable account.
398     */
399     modifier onlyBurnAddress() {
400         require(msg.sender == burnAddress);
401         _;
402     }
403 
404     /**
405     * @dev Create SaifuToken contract
406     */
407     function SaifuToken() public {
408         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
409 
410         balances[owner] = balances[owner].add(AMOUNT_TOKENS_FOR_SELL);
411         Transfer(address(0), owner, AMOUNT_TOKENS_FOR_SELL);
412 
413         balances[this] = balances[this].add(RESERVED_TOTAL_AMOUNT);
414         Transfer(address(0), this, RESERVED_TOTAL_AMOUNT);
415     }
416 
417      /**
418     * @dev Transfer token for a specified address.
419     * @dev Only applies when the transfer is allowed by the owner.
420     * @param _to The address to transfer to.
421     * @param _value The amount to be transferred.
422     */
423     function transfer(address _to, uint256 _value) public returns (bool) {
424         require(!isFrozen(msg.sender));
425         super.transfer(_to, _value);
426     }
427 
428     /**
429     * @dev Transfer tokens from one address to another.
430     * @dev Only applies when the transfer is allowed by the owner.
431     * @param _from address The address which you want to send tokens from
432     * @param _to address The address which you want to transfer to
433     * @param _value uint256 the amount of tokens to be transferred
434     */
435     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
436         require(!isFrozen(msg.sender));
437         require(!isFrozen(_from));
438         super.transferFrom(_from, _to, _value);
439     }
440 
441     /**
442     * @dev Set burn address.
443     * @param _address New burn address
444     */
445     function setBurnAddress(address _address) onlyOwner public {
446         require(setBurnAddressCount < 3);
447         require(_address != address(0));
448         burnAddress = _address;
449         setBurnAddressCount = setBurnAddressCount.add(1);
450     }
451 
452     /**
453     * @dev Reserve funds.
454     * @param _address the address for reserve funds. 
455     */
456     function reserveFunds(address _address) onlyOwner public {
457         require(_address != address(0));
458 
459         require(!isReservedFundsDone);
460 
461         sendFromContract(_address, RESERVE_FUND);
462         
463         isReservedFundsDone = true;
464     }
465 
466     /**
467     * @dev Get locked contract address.
468     * @param _address the address of owner these tokens.
469     */
470     function getLockedContract(address _address) public view returns(address) {
471         return lockedList[_address];
472     }
473 
474     /**
475     * @dev Reserve for team.
476     * @param _address the address for reserve. 
477     * @param _amount the specified amount for reserve. 
478     * @param _time the specified freezing time (in days). 
479     */
480     function reserveForTeam(address _address, uint256 _amount, uint256  _time) onlyOwner public {
481         require(_address != address(0));
482         require(_amount > 0 && _amount <= RESERVED_FOR_TEAM.sub(alreadyReservedForTeam));
483 
484         if (_time > 0) {
485             address lockedAddress = new TokenTimelock(this, _address, now.add(_time * 1 days));
486             lockedList[_address] = lockedAddress;
487             sendFromContract(lockedAddress, _amount);
488         } else {
489             sendFromContract(_address, _amount);
490         }
491         
492         alreadyReservedForTeam = alreadyReservedForTeam.add(_amount);
493     }
494 
495     /**
496     * @dev Send tokens which will be frozen for specified time.
497     * @param _address the address for send. 
498     * @param _amount the specified amount for send. 
499     * @param _time the specified freezing time (in seconds). 
500     */
501     function sendWithFreeze(address _address, uint256 _amount, uint256  _time) onlyOwner public {
502         require(_address != address(0) && _amount > 0 && _time > 0);
503 
504         address lockedAddress = new TokenTimelock(this, _address, now.add(_time));
505         lockedList[_address] = lockedAddress;
506         transfer(lockedAddress, _amount);
507     }
508 
509     /**
510     * @dev Unlock frozen tokens.
511     * @param _address the address for which to release already unlocked tokens. 
512     */
513     function unlockTokens(address _address) public {
514         require(lockedList[_address] != address(0));
515 
516         TokenTimelock lockedContract = TokenTimelock(lockedList[_address]);
517 
518         lockedContract.release();
519     }
520 
521     /**
522     * @dev Burn a specific amount of tokens.
523     * @param _amount The Amount of tokens.
524     */
525     function burnFromAddress(uint256 _amount) onlyBurnAddress public {
526         require(_amount > 0);
527         require(_amount <= balances[burnAddress]);
528 
529         balances[burnAddress] = balances[burnAddress].sub(_amount);
530         totalSupply_ = totalSupply_.sub(_amount);
531         Transfer(burnAddress, address(0), _amount);
532     }
533 
534     /*
535     * @dev Send tokens from contract.
536     * @param _address the address destination. 
537     * @param _amount the specified amount for send.
538      */
539     function sendFromContract(address _address, uint256 _amount) internal {
540         balances[this] = balances[this].sub(_amount);
541         balances[_address] = balances[_address].add(_amount);
542         Transfer(this, _address, _amount);
543     }
544 }