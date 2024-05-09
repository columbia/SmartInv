1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/49b42e86963df7192e7024e0e5bd30fa9d7ccbef
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
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
52 
53 /**
54  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/ERC20Basic.sol
55  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/370e6a882aef6b9600949594d3a3e4854260d51e
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/ERC20.sol
70  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address owner, address spender) public view returns (uint256);
76   function transferFrom(address from, address to, uint256 value) public returns (bool);
77   function approve(address spender, uint256 value) public returns (bool);
78   event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 /**
83  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/SafeERC20.sol
84  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/b67856c69d3536f28d51b75b270dfff79343bf93
85  * @title SafeERC20
86  * @dev Wrappers around ERC20 operations that throw on failure.
87  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
88  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
89  */
90 library SafeERC20 {
91   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
92     assert(token.transfer(to, value));
93   }
94 
95   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
96     assert(token.transferFrom(from, to, value));
97   }
98 
99   function safeApprove(ERC20 token, address spender, uint256 value) internal {
100     assert(token.approve(spender, value));
101   }
102 }
103 
104 
105 /**
106  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/BasicToken.sol
107  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 totalSupply_;
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return balances[_owner];
148   }
149 }
150 
151 
152 /**
153  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/StandardToken.sol
154  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) internal allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public view returns (uint256) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 }
247 
248 
249 /**
250  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/ownership/Ownable.sol
251  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/e60aee61f20d25bffa0a1f651247810a8bc8a660
252  * @title Ownable
253  * @dev The Ownable contract has an owner address, and provides basic authorization control
254  * functions, this simplifies the implementation of "user permissions".
255  */
256 contract Ownable {
257   address public owner;
258 
259 
260   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   function Ownable() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to transfer control of the contract to a newOwner.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     require(newOwner != address(0));
285     OwnershipTransferred(owner, newOwner);
286     owner = newOwner;
287   }
288 }
289 
290 
291 /**
292  * https://raw.githubusercontent.com/OpenZeppelin/zeppelin-solidity/master/contracts/token/ERC20/TokenVesting.sol
293  * https://github.com/OpenZeppelin/zeppelin-solidity/commit/c5d66183abcb63a90a2528b8333b2b17067629fc
294  * @title TokenVesting
295  * @dev A token holder contract that can release its token balance gradually like a
296  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
297  * owner.
298  */
299 contract TokenVesting is Ownable {
300   using SafeMath for uint256;
301   using SafeERC20 for ERC20Basic;
302 
303   event Released(uint256 amount);
304   event Revoked();
305 
306   // beneficiary of tokens after they are released
307   address public beneficiary;
308 
309   uint256 public cliff;
310   uint256 public start;
311   uint256 public duration;
312 
313   bool public revocable;
314 
315   mapping (address => uint256) public released;
316   mapping (address => bool) public revoked;
317 
318   /**
319    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
320    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
321    * of the balance will have vested.
322    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
323    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
324    * @param _duration duration in seconds of the period in which the tokens will vest
325    * @param _revocable whether the vesting is revocable or not
326    */
327   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
328     require(_beneficiary != address(0));
329     require(_cliff <= _duration);
330 
331     beneficiary = _beneficiary;
332     revocable = _revocable;
333     duration = _duration;
334     cliff = _start.add(_cliff);
335     start = _start;
336   }
337 
338   /**
339    * @notice Transfers vested tokens to beneficiary.
340    * @param token ERC20 token which is being vested
341    */
342   function release(ERC20Basic token) public {
343     uint256 unreleased = releasableAmount(token);
344 
345     require(unreleased > 0);
346 
347     released[token] = released[token].add(unreleased);
348 
349     token.safeTransfer(beneficiary, unreleased);
350 
351     Released(unreleased);
352   }
353 
354   /**
355    * @notice Allows the owner to revoke the vesting. Tokens already vested
356    * remain in the contract, the rest are returned to the owner.
357    * @param token ERC20 token which is being vested
358    */
359   function revoke(ERC20Basic token) public onlyOwner {
360     require(revocable);
361     require(!revoked[token]);
362 
363     uint256 balance = token.balanceOf(this);
364 
365     uint256 unreleased = releasableAmount(token);
366     uint256 refund = balance.sub(unreleased);
367 
368     revoked[token] = true;
369 
370     token.safeTransfer(owner, refund);
371 
372     Revoked();
373   }
374 
375   /**
376    * @dev Calculates the amount that has already vested but hasn't been released yet.
377    * @param token ERC20 token which is being vested
378    */
379   function releasableAmount(ERC20Basic token) public view returns (uint256) {
380     return vestedAmount(token).sub(released[token]);
381   }
382 
383   /**
384    * @dev Calculates the amount that has already vested.
385    * @param token ERC20 token which is being vested
386    */
387   function vestedAmount(ERC20Basic token) public view returns (uint256) {
388     uint256 currentBalance = token.balanceOf(this);
389     uint256 totalBalance = currentBalance.add(released[token]);
390 
391     if (now < cliff) {
392       return 0;
393     } else if (now >= start.add(duration) || revoked[token]) {
394       return totalBalance;
395     } else {
396       return totalBalance.mul(now.sub(start)).div(duration);
397     }
398   }
399 }
400 
401 
402 contract CoinFiToken is StandardToken, Ownable {
403     string public constant name = "CoinFi";
404     string public constant symbol = "COFI";
405     uint8 public constant decimals = 18;
406 
407     // 300 million tokens minted
408     uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(decimals));
409 
410     // Indicates whether token transfer is enabled
411     bool public transferEnabled = false;
412 
413     // Specifies airdrop contract address which can transfer tokens before unlock
414     address public airdropAddress;
415 
416     modifier onlyWhenTransferEnabled() {
417         if (!transferEnabled) {
418             require(msg.sender == owner || msg.sender == airdropAddress);
419         }
420         _;
421     }
422 
423     function CoinFiToken() public {
424         totalSupply_ = INITIAL_SUPPLY;
425         balances[msg.sender] = INITIAL_SUPPLY;
426         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
427     }
428 
429     /**
430      * Enables everyone to start transferring their tokens.
431      * This can only be called by the token owner.
432      */
433     function enableTransfer() external onlyOwner {
434         transferEnabled = true;
435     }
436 
437     /**
438      * Disables the ability to transfer tokens except by owner.
439      * This can only be called by the token owner.
440      */
441     function disableTransfer() external onlyOwner {
442         transferEnabled = false;
443     }
444 
445     /**
446      * Sets the airdrop contract address which is allowed to transfer before unlock.
447      * This can only be called by the token owner.
448      */
449     function setAirdropAddress(address _airdropAddress) external onlyOwner {
450         airdropAddress = _airdropAddress;
451     }
452 
453     /**
454      * Overrides the ERC20Basic transfer() function to only allow token transfers after enableTransfer() is called.
455      */
456     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
457         return super.transfer(_to, _value);
458     }
459 
460     /**
461      * Overrides the ERC20Basic transferFrom() function to only allow token transfers after enableTransfer() is called.
462      */
463     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
464         return super.transferFrom(_from, _to, _value);
465     }
466 }
467 
468 
469 contract CoinFiAirdrop is Ownable {
470     uint256 public constant AIRDROP_AMOUNT = 500 * (10**18);
471 
472     // Actual token instance to airdrop
473     ERC20 public token;
474 
475     function CoinFiAirdrop(ERC20 _token) public {
476         token = _token;
477     }
478 
479     function sendAirdrop(address[] airdropRecipients, bool allowDuplicates) external onlyOwner {
480         require(airdropRecipients.length > 0);
481 
482         for (uint i = 0; i < airdropRecipients.length; i++) {
483             if (token.balanceOf(airdropRecipients[i]) == 0 || allowDuplicates) {
484                 token.transferFrom(owner, airdropRecipients[i], AIRDROP_AMOUNT);
485             }
486         }
487     }
488 }