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
87 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 
133 // File: zeppelin-solidity/contracts/math/SafeMath.sol
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
145     if (a == 0) {
146       return 0;
147     }
148     c = a * b;
149     assert(c / a == b);
150     return c;
151   }
152 
153   /**
154   * @dev Integer division of two numbers, truncating the quotient.
155   */
156   function div(uint256 a, uint256 b) internal pure returns (uint256) {
157     // assert(b > 0); // Solidity automatically throws when dividing by 0
158     // uint256 c = a / b;
159     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160     return a / b;
161   }
162 
163   /**
164   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
165   */
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     assert(b <= a);
168     return a - b;
169   }
170 
171   /**
172   * @dev Adds two numbers, throws on overflow.
173   */
174   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
175     c = a + b;
176     assert(c >= a);
177     return c;
178   }
179 }
180 
181 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
182 
183 /**
184  * @title ERC20Basic
185  * @dev Simpler version of ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/179
187  */
188 contract ERC20Basic {
189   function totalSupply() public view returns (uint256);
190   function balanceOf(address who) public view returns (uint256);
191   function transfer(address to, uint256 value) public returns (bool);
192   event Transfer(address indexed from, address indexed to, uint256 value);
193 }
194 
195 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   uint256 totalSupply_;
207 
208   /**
209   * @dev total number of tokens in existence
210   */
211   function totalSupply() public view returns (uint256) {
212     return totalSupply_;
213   }
214 
215   /**
216   * @dev transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223 
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256) {
236     return balances[_owner];
237   }
238 
239 }
240 
241 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
242 
243 /**
244  * @title Burnable Token
245  * @dev Token that can be irreversibly burned (destroyed).
246  */
247 contract BurnableToken is BasicToken {
248 
249   event Burn(address indexed burner, uint256 value);
250 
251   /**
252    * @dev Burns a specific amount of tokens.
253    * @param _value The amount of token to be burned.
254    */
255   function burn(uint256 _value) public {
256     _burn(msg.sender, _value);
257   }
258 
259   function _burn(address _who, uint256 _value) internal {
260     require(_value <= balances[_who]);
261     // no need to require value <= totalSupply, since that would imply the
262     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264     balances[_who] = balances[_who].sub(_value);
265     totalSupply_ = totalSupply_.sub(_value);
266     emit Burn(_who, _value);
267     emit Transfer(_who, address(0), _value);
268   }
269 }
270 
271 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
272 
273 /**
274  * @title ERC20 interface
275  * @dev see https://github.com/ethereum/EIPs/issues/20
276  */
277 contract ERC20 is ERC20Basic {
278   function allowance(address owner, address spender) public view returns (uint256);
279   function transferFrom(address from, address to, uint256 value) public returns (bool);
280   function approve(address spender, uint256 value) public returns (bool);
281   event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
285 
286 /**
287  * @title Standard ERC20 token
288  *
289  * @dev Implementation of the basic standard token.
290  * @dev https://github.com/ethereum/EIPs/issues/20
291  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
292  */
293 contract StandardToken is ERC20, BasicToken {
294 
295   mapping (address => mapping (address => uint256)) internal allowed;
296 
297 
298   /**
299    * @dev Transfer tokens from one address to another
300    * @param _from address The address which you want to send tokens from
301    * @param _to address The address which you want to transfer to
302    * @param _value uint256 the amount of tokens to be transferred
303    */
304   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
305     require(_to != address(0));
306     require(_value <= balances[_from]);
307     require(_value <= allowed[_from][msg.sender]);
308 
309     balances[_from] = balances[_from].sub(_value);
310     balances[_to] = balances[_to].add(_value);
311     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
312     emit Transfer(_from, _to, _value);
313     return true;
314   }
315 
316   /**
317    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
318    *
319    * Beware that changing an allowance with this method brings the risk that someone may use both the old
320    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
321    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
322    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323    * @param _spender The address which will spend the funds.
324    * @param _value The amount of tokens to be spent.
325    */
326   function approve(address _spender, uint256 _value) public returns (bool) {
327     allowed[msg.sender][_spender] = _value;
328     emit Approval(msg.sender, _spender, _value);
329     return true;
330   }
331 
332   /**
333    * @dev Function to check the amount of tokens that an owner allowed to a spender.
334    * @param _owner address The address which owns the funds.
335    * @param _spender address The address which will spend the funds.
336    * @return A uint256 specifying the amount of tokens still available for the spender.
337    */
338   function allowance(address _owner, address _spender) public view returns (uint256) {
339     return allowed[_owner][_spender];
340   }
341 
342   /**
343    * @dev Increase the amount of tokens that an owner allowed to a spender.
344    *
345    * approve should be called when allowed[_spender] == 0. To increment
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _addedValue The amount of tokens to increase the allowance by.
351    */
352   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
353     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358   /**
359    * @dev Decrease the amount of tokens that an owner allowed to a spender.
360    *
361    * approve should be called when allowed[_spender] == 0. To decrement
362    * allowed value is better to use this function to avoid 2 calls (and wait until
363    * the first transaction is mined)
364    * From MonolithDAO Token.sol
365    * @param _spender The address which will spend the funds.
366    * @param _subtractedValue The amount of tokens to decrease the allowance by.
367    */
368   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
369     uint oldValue = allowed[msg.sender][_spender];
370     if (_subtractedValue > oldValue) {
371       allowed[msg.sender][_spender] = 0;
372     } else {
373       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374     }
375     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376     return true;
377   }
378 
379 }
380 
381 // File: contracts/KarmazaToken.sol
382 
383 interface tokenRecipient {
384     function receiveApproval(
385         address _from,
386         uint256 _value,
387         address _token,
388         bytes _extraData)
389     external;
390 }
391 
392 
393 contract KarmazaToken is StandardToken, BurnableToken, FreezableToken, Pausable {
394     string public constant name = "KARMAZA";
395     string public constant symbol = "KMZ";
396     uint256 public constant decimals = 18;
397 
398     uint256 public constant TOTAL_SUPPLY_VALUE = 100 * (10 ** 9) * (10 ** decimals);
399 
400     uint256 public constant RESERVED_TOKENS_ICO = 50 * (10 ** 9) * (10 ** decimals);
401     uint256 public constant RESERVED_TOKENS_FUTURE_OPERATIONS = 25 * (10 ** 9) * (10 ** decimals);
402     uint256 public constant RESERVED_TOKENS_FOUNDERS_TEAM = 20 * (10 ** 9) * (10 ** decimals);
403     uint256 public constant RESERVED_TOKENS_BOUNTIES_ADVISORS = 5 * (10 ** 9) * (10 ** decimals);
404 
405     address private addressIco;
406 
407     modifier onlyIco() {
408         require(msg.sender == addressIco);
409         _;
410     }
411 
412     /**
413     * @dev Create KarmazaToken contract.
414     * @param _futureOperationsReserve The address of future operartions reserve.
415     * @param _foundersAndTeamReserve The address of founders and team reserve.
416     * @param _bountiesAndAdvisorsReserve The address of bounties and advisors reserve.
417     */
418     constructor (address _futureOperationsReserve, address _foundersAndTeamReserve, address _bountiesAndAdvisorsReserve) public {
419         require(
420             _futureOperationsReserve != address(0) && _foundersAndTeamReserve != address(0) && _bountiesAndAdvisorsReserve != address(0)
421         );
422 
423         addressIco = msg.sender;
424 
425         totalSupply_ = TOTAL_SUPPLY_VALUE;
426 
427         balances[msg.sender] = RESERVED_TOKENS_ICO;
428         emit Transfer(address(0), msg.sender, RESERVED_TOKENS_ICO);
429 
430         balances[_futureOperationsReserve] = RESERVED_TOKENS_FUTURE_OPERATIONS;
431         emit Transfer(address(0), _futureOperationsReserve, RESERVED_TOKENS_FUTURE_OPERATIONS);
432 
433         balances[_foundersAndTeamReserve] = RESERVED_TOKENS_FOUNDERS_TEAM;
434         emit Transfer(address(0), _foundersAndTeamReserve, RESERVED_TOKENS_FOUNDERS_TEAM);
435 
436         balances[_bountiesAndAdvisorsReserve] = RESERVED_TOKENS_BOUNTIES_ADVISORS;
437         emit Transfer(address(0), _bountiesAndAdvisorsReserve, RESERVED_TOKENS_BOUNTIES_ADVISORS);
438     }
439 
440     /**
441     * @dev Transfer token for a specified address with pause and freeze features for owner.
442     * @dev Only applies when the transfer is allowed by the owner.
443     * @param _to The address to transfer to.
444     * @param _value The amount to be transferred.
445     */
446     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
447         require(!isFrozen(msg.sender));
448         super.transfer(_to, _value);
449     }
450 
451     /**
452     * @dev Transfer tokens from one address to another with pause and freeze features for owner.
453     * @dev Only applies when the transfer is allowed by the owner.
454     * @param _from address The address which you want to send tokens from
455     * @param _to address The address which you want to transfer to
456     * @param _value uint256 the amount of tokens to be transferred
457     */
458     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
459         require(!isFrozen(msg.sender));
460         require(!isFrozen(_from));
461         super.transferFrom(_from, _to, _value);
462     }
463 
464     /**
465     * @dev Transfer tokens from ICO address to another address.
466     * @param _to The address to transfer to.
467     * @param _value The amount to be transferred.
468     */
469     function transferFromIco(address _to, uint256 _value) public onlyIco returns (bool) {
470         super.transfer(_to, _value);
471     }
472 
473     /**
474     * Set allowance for other address and notify
475     *
476     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
477     *
478     * @param _spender The address authorized to spend
479     * @param _value the max amount they can spend
480     * @param _extraData some extra information to send to the approved contract
481     */
482     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
483         tokenRecipient spender = tokenRecipient(_spender);
484         if (approve(_spender, _value)) {
485             spender.receiveApproval(
486                 msg.sender,
487                 _value, this,
488                 _extraData);
489             return true;
490         }
491     }
492 
493 }