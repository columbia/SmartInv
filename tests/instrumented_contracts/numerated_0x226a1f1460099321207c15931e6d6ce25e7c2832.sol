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
45 // File: contracts/Administrable.sol
46 
47 contract Administrable is Ownable {
48     mapping (address => bool) private administrators;
49     uint256 public administratorsLength = 0;
50 
51     /**
52      * @dev Throws if called by any account other than the owner or administrator.
53     */
54     modifier onlyAdministratorOrOwner() {
55         require(msg.sender == owner || administrators[msg.sender]);
56         _;
57     }
58 
59     function addAdministrator(address _wallet) onlyOwner public {
60         require(!administrators[_wallet]);
61         require(_wallet != address(0) && _wallet != owner);
62         administrators[_wallet] = true;
63         administratorsLength++;
64     }
65 
66     function removeAdministrator(address _wallet) onlyOwner public {
67         require(_wallet != address(0));
68         require(administrators[_wallet]);
69         administrators[_wallet] = false;
70         administratorsLength--;
71     }
72 
73     function isAdministrator(address _wallet) public constant returns (bool) {
74         return administrators[_wallet];
75     }
76 }
77 
78 // File: contracts/FreezableToken.sol
79 
80 /**
81 * @title Freezable Token
82 * @dev Token that can be freezed for chosen token holder.
83 */
84 contract FreezableToken is Administrable {
85 
86     mapping (address => bool) public frozenList;
87 
88     event FrozenFunds(address indexed wallet, bool frozen);
89 
90     /**
91     * @dev Owner can freeze the token balance for chosen token holder.
92     * @param _wallet The address of token holder whose tokens to be frozen.
93     */
94     function freezeAccount(address _wallet) onlyAdministratorOrOwner public {
95         require(_wallet != address(0));
96         frozenList[_wallet] = true;
97         FrozenFunds(_wallet, true);
98     }
99 
100     /**
101     * @dev Owner can unfreeze the token balance for chosen token holder.
102     * @param _wallet The address of token holder whose tokens to be unfrozen.
103     */
104     function unfreezeAccount(address _wallet) onlyAdministratorOrOwner public {
105         require(_wallet != address(0));
106         frozenList[_wallet] = false;
107         FrozenFunds(_wallet, false);
108     }
109 
110     /**
111     * @dev Check the specified token holder whether his/her token balance is frozen.
112     * @param _wallet The address of token holder to check.
113     */ 
114     function isFrozen(address _wallet) constant public returns (bool) {
115         return frozenList[_wallet];
116     }
117 
118 }
119 
120 // File: zeppelin-solidity/contracts/math/SafeMath.sol
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127 
128   /**
129   * @dev Multiplies two numbers, throws on overflow.
130   */
131   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132     if (a == 0) {
133       return 0;
134     }
135     uint256 c = a * b;
136     assert(c / a == b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return c;
148   }
149 
150   /**
151   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256) {
162     uint256 c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
169 
170 /**
171  * @title ERC20Basic
172  * @dev Simpler version of ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/179
174  */
175 contract ERC20Basic {
176   function totalSupply() public view returns (uint256);
177   function balanceOf(address who) public view returns (uint256);
178   function transfer(address to, uint256 value) public returns (bool);
179   event Transfer(address indexed from, address indexed to, uint256 value);
180 }
181 
182 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances.
187  */
188 contract BasicToken is ERC20Basic {
189   using SafeMath for uint256;
190 
191   mapping(address => uint256) balances;
192 
193   uint256 totalSupply_;
194 
195   /**
196   * @dev total number of tokens in existence
197   */
198   function totalSupply() public view returns (uint256) {
199     return totalSupply_;
200   }
201 
202   /**
203   * @dev transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[msg.sender]);
210 
211     // SafeMath.sub will throw if there is not enough balance.
212     balances[msg.sender] = balances[msg.sender].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     Transfer(msg.sender, _to, _value);
215     return true;
216   }
217 
218   /**
219   * @dev Gets the balance of the specified address.
220   * @param _owner The address to query the the balance of.
221   * @return An uint256 representing the amount owned by the passed address.
222   */
223   function balanceOf(address _owner) public view returns (uint256 balance) {
224     return balances[_owner];
225   }
226 
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
230 
231 /**
232  * @title ERC20 interface
233  * @dev see https://github.com/ethereum/EIPs/issues/20
234  */
235 contract ERC20 is ERC20Basic {
236   function allowance(address owner, address spender) public view returns (uint256);
237   function transferFrom(address from, address to, uint256 value) public returns (bool);
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
243 
244 /**
245  * @title Standard ERC20 token
246  *
247  * @dev Implementation of the basic standard token.
248  * @dev https://github.com/ethereum/EIPs/issues/20
249  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
250  */
251 contract StandardToken is ERC20, BasicToken {
252 
253   mapping (address => mapping (address => uint256)) internal allowed;
254 
255 
256   /**
257    * @dev Transfer tokens from one address to another
258    * @param _from address The address which you want to send tokens from
259    * @param _to address The address which you want to transfer to
260    * @param _value uint256 the amount of tokens to be transferred
261    */
262   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0));
264     require(_value <= balances[_from]);
265     require(_value <= allowed[_from][msg.sender]);
266 
267     balances[_from] = balances[_from].sub(_value);
268     balances[_to] = balances[_to].add(_value);
269     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270     Transfer(_from, _to, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276    *
277    * Beware that changing an allowance with this method brings the risk that someone may use both the old
278    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) public returns (bool) {
285     allowed[msg.sender][_spender] = _value;
286     Approval(msg.sender, _spender, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Function to check the amount of tokens that an owner allowed to a spender.
292    * @param _owner address The address which owns the funds.
293    * @param _spender address The address which will spend the funds.
294    * @return A uint256 specifying the amount of tokens still available for the spender.
295    */
296   function allowance(address _owner, address _spender) public view returns (uint256) {
297     return allowed[_owner][_spender];
298   }
299 
300   /**
301    * @dev Increase the amount of tokens that an owner allowed to a spender.
302    *
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
311     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
312     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316   /**
317    * @dev Decrease the amount of tokens that an owner allowed to a spender.
318    *
319    * approve should be called when allowed[_spender] == 0. To decrement
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _subtractedValue The amount of tokens to decrease the allowance by.
325    */
326   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
327     uint oldValue = allowed[msg.sender][_spender];
328     if (_subtractedValue > oldValue) {
329       allowed[msg.sender][_spender] = 0;
330     } else {
331       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332     }
333     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337 }
338 
339 // File: contracts/MintableToken.sol
340 
341 /**
342 * @title Mintable token
343 * @dev Simple ERC20 Token example, with mintable token creation
344 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
345 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
346 */
347 contract MintableToken is StandardToken, Administrable {
348     event Mint(address indexed to, uint256 amount);
349     event MintFinished();
350 
351     bool public mintingFinished = false;
352 
353     modifier canMint() {
354         require(!mintingFinished);
355         _;
356     }
357 
358     /**
359     * @dev Function to mint tokens
360     * @param _to The address that will receive the minted tokens.
361     * @param _amount The amount of tokens to mint.
362     * @return A boolean that indicates if the operation was successful.
363     */
364     function mint(address _to, uint256 _amount) onlyAdministratorOrOwner canMint public returns (bool) {
365         totalSupply_ = totalSupply_.add(_amount);
366         balances[_to] = balances[_to].add(_amount);
367         Mint(_to, _amount);
368         Transfer(address(0), _to, _amount);
369         return true;
370     }
371 
372     /**
373     * @dev Function to stop minting new tokens.
374     * @return True if the operation was successful.
375     */
376     function finishMinting() onlyOwner canMint public returns (bool) {
377         mintingFinished = true;
378         MintFinished();
379         return true;
380     }
381 }
382 
383 // File: contracts/Pausable.sol
384 
385 /**
386 * @title Pausable
387 * @dev Base contract which allows children to implement an emergency stop mechanism.
388 */
389 contract Pausable is Administrable {
390     event Pause();
391     event Unpause();
392 
393     bool public paused = false;
394 
395     /**
396     * @dev Modifier to make a function callable only when the contract is not paused.
397     */
398     modifier whenNotPaused() {
399         require(!paused);
400         _;
401     }
402 
403     /**
404     * @dev Modifier to make a function callable only when the contract is paused.
405     */
406     modifier whenPaused() {
407         require(paused);
408         _;
409     }
410 
411     /**
412     * @dev called by the owner to pause, triggers stopped state
413     */
414     function pause() onlyAdministratorOrOwner whenNotPaused public {
415         paused = true;
416         Pause();
417     }
418 
419     /**
420     * @dev called by the owner to unpause, returns to normal state
421     */
422     function unpause() onlyAdministratorOrOwner whenPaused public {
423         paused = false;
424         Unpause();
425     }
426 }
427 
428 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
429 
430 /**
431  * @title Burnable Token
432  * @dev Token that can be irreversibly burned (destroyed).
433  */
434 contract BurnableToken is BasicToken {
435 
436   event Burn(address indexed burner, uint256 value);
437 
438   /**
439    * @dev Burns a specific amount of tokens.
440    * @param _value The amount of token to be burned.
441    */
442   function burn(uint256 _value) public {
443     require(_value <= balances[msg.sender]);
444     // no need to require value <= totalSupply, since that would imply the
445     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
446 
447     address burner = msg.sender;
448     balances[burner] = balances[burner].sub(_value);
449     totalSupply_ = totalSupply_.sub(_value);
450     Burn(burner, _value);
451   }
452 }
453 
454 // File: contracts/OncoToken.sol
455 
456 contract OncoToken is MintableToken, Pausable, FreezableToken, BurnableToken {
457     string constant public name = "ONCO";
458     string constant public symbol = "ONCO";
459     uint8 constant public decimals = 18;
460 
461     /**
462     * @dev Empty OncoToken constructor
463     */
464     function OncoToken() public {}
465 
466     /**
467     * @dev Transfer token for a specified address with pause and freeze features for owner.
468     * @dev Only applies when the transfer is allowed by the owner.
469     * @param _to The address to transfer to.
470     * @param _value The amount to be transferred.
471     */
472     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
473         require(!isFrozen(msg.sender));
474         super.transfer(_to, _value);
475     }
476 
477     /**
478     * @dev Transfer tokens from one address to another with pause and freeze features for owner.
479     * @dev Only applies when the transfer is allowed by the owner.
480     * @param _from address The address which you want to send tokens from
481     * @param _to address The address which you want to transfer to
482     * @param _value uint256 the amount of tokens to be transferred
483     */
484     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
485         require(!isFrozen(msg.sender));
486         require(!isFrozen(_from));
487         super.transferFrom(_from, _to, _value);
488     }
489 }