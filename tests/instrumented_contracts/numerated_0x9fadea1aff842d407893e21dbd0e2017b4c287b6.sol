1 pragma solidity ^0.4.21;
2 
3 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
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
45 // File: contracts\zeppelin-solidity\contracts\ownership\Whitelist.sol
46 
47 /**
48  * @title Whitelist
49  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
50  * @dev This simplifies the implementation of "user permissions".
51  */
52 contract Whitelist is Ownable {
53   mapping(address => bool) public whitelist;
54   
55   event WhitelistedAddressAdded(address addr);
56   event WhitelistedAddressRemoved(address addr);
57 
58   /**
59    * @dev Throws if called by any account that's not whitelisted.
60    */
61   modifier onlyWhitelisted() {
62     require(whitelist[msg.sender]);
63     _;
64   }
65 
66   /**
67    * @dev add an address to the whitelist
68    * @param addr address
69    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
70    */
71   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
72     if (!whitelist[addr]) {
73       whitelist[addr] = true;
74       emit WhitelistedAddressAdded(addr);
75       success = true; 
76     }
77   }
78 
79   /**
80    * @dev add addresses to the whitelist
81    * @param addrs addresses
82    * @return true if at least one address was added to the whitelist, 
83    * false if all addresses were already in the whitelist  
84    */
85   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
86     for (uint256 i = 0; i < addrs.length; i++) {
87       if (addAddressToWhitelist(addrs[i])) {
88         success = true;
89       }
90     }
91   }
92 
93   /**
94    * @dev remove an address from the whitelist
95    * @param addr address
96    * @return true if the address was removed from the whitelist, 
97    * false if the address wasn't in the whitelist in the first place 
98    */
99   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
100     if (whitelist[addr]) {
101       whitelist[addr] = false;
102       emit WhitelistedAddressRemoved(addr);
103       success = true;
104     }
105   }
106 
107   /**
108    * @dev remove addresses from the whitelist
109    * @param addrs addresses
110    * @return true if at least one address was removed from the whitelist, 
111    * false if all addresses weren't in the whitelist in the first place
112    */
113   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
114     for (uint256 i = 0; i < addrs.length; i++) {
115       if (removeAddressFromWhitelist(addrs[i])) {
116         success = true;
117       }
118     }
119   }
120 
121 }
122 
123 // File: contracts\LockableWhitelisted.sol
124 
125 /**
126  * @dev A Whitelist contract that can be locked and unlocked. Provides a modifier
127  * to check for locked state plus functions and events. The contract is never locked for
128  * whitelisted addresses. The contracts starts off unlocked and can be locked and
129  * then unlocked a single time. Once unlocked, the contract can never be locked back.
130  * @dev Base contract which allows children to implement an emergency stop mechanism.
131  */
132 contract LockableWhitelisted is Whitelist {
133   event Locked();
134   event Unlocked();
135 
136   bool public locked = false;
137   bool private unlockedOnce = false;
138 
139   /**
140    * @dev Modifier to make a function callable only when the contract is not locked
141    * or the caller is whitelisted.
142    */
143   modifier whenNotLocked(address _address) {
144     require(!locked || whitelist[_address]);
145     _;
146   }
147 
148   /**
149    * @dev Returns true if the specified address is whitelisted.
150    * @param _address The address to check for whitelisting status.
151    */
152   function isWhitelisted(address _address) public view returns (bool) {
153     return whitelist[_address];
154   }
155 
156   /**
157    * @dev Called by the owner to lock.
158    */
159   function lock() onlyOwner public {
160     require(!unlockedOnce);
161     if (!locked) {
162       locked = true;
163       emit Locked();
164     }
165   }
166 
167   /**
168    * @dev Called by the owner to unlock.
169    */
170   function unlock() onlyOwner public {
171     if (locked) {
172       locked = false;
173       unlockedOnce = true;
174       emit Unlocked();
175     }
176   }
177 }
178 
179 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
180 
181 /**
182  * @title SafeMath
183  * @dev Math operations with safety checks that throw on error
184  */
185 library SafeMath {
186 
187   /**
188   * @dev Multiplies two numbers, throws on overflow.
189   */
190   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191     if (a == 0) {
192       return 0;
193     }
194     uint256 c = a * b;
195     assert(c / a == b);
196     return c;
197   }
198 
199   /**
200   * @dev Integer division of two numbers, truncating the quotient.
201   */
202   function div(uint256 a, uint256 b) internal pure returns (uint256) {
203     // assert(b > 0); // Solidity automatically throws when dividing by 0
204     uint256 c = a / b;
205     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206     return c;
207   }
208 
209   /**
210   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
211   */
212   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213     assert(b <= a);
214     return a - b;
215   }
216 
217   /**
218   * @dev Adds two numbers, throws on overflow.
219   */
220   function add(uint256 a, uint256 b) internal pure returns (uint256) {
221     uint256 c = a + b;
222     assert(c >= a);
223     return c;
224   }
225 }
226 
227 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
228 
229 /**
230  * @title ERC20Basic
231  * @dev Simpler version of ERC20 interface
232  * @dev see https://github.com/ethereum/EIPs/issues/179
233  */
234 contract ERC20Basic {
235   function totalSupply() public view returns (uint256);
236   function balanceOf(address who) public view returns (uint256);
237   function transfer(address to, uint256 value) public returns (bool);
238   event Transfer(address indexed from, address indexed to, uint256 value);
239 }
240 
241 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
242 
243 /**
244  * @title Basic token
245  * @dev Basic version of StandardToken, with no allowances.
246  */
247 contract BasicToken is ERC20Basic {
248   using SafeMath for uint256;
249 
250   mapping(address => uint256) balances;
251 
252   uint256 totalSupply_;
253 
254   /**
255   * @dev total number of tokens in existence
256   */
257   function totalSupply() public view returns (uint256) {
258     return totalSupply_;
259   }
260 
261   /**
262   * @dev transfer token for a specified address
263   * @param _to The address to transfer to.
264   * @param _value The amount to be transferred.
265   */
266   function transfer(address _to, uint256 _value) public returns (bool) {
267     require(_to != address(0));
268     require(_value <= balances[msg.sender]);
269 
270     // SafeMath.sub will throw if there is not enough balance.
271     balances[msg.sender] = balances[msg.sender].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     emit Transfer(msg.sender, _to, _value);
274     return true;
275   }
276 
277   /**
278   * @dev Gets the balance of the specified address.
279   * @param _owner The address to query the the balance of.
280   * @return An uint256 representing the amount owned by the passed address.
281   */
282   function balanceOf(address _owner) public view returns (uint256 balance) {
283     return balances[_owner];
284   }
285 
286 }
287 
288 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
289 
290 /**
291  * @title Burnable Token
292  * @dev Token that can be irreversibly burned (destroyed).
293  */
294 contract BurnableToken is BasicToken {
295 
296   event Burn(address indexed burner, uint256 value);
297 
298   /**
299    * @dev Burns a specific amount of tokens.
300    * @param _value The amount of token to be burned.
301    */
302   function burn(uint256 _value) public {
303     require(_value <= balances[msg.sender]);
304     // no need to require value <= totalSupply, since that would imply the
305     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
306 
307     address burner = msg.sender;
308     balances[burner] = balances[burner].sub(_value);
309     totalSupply_ = totalSupply_.sub(_value);
310     emit Burn(burner, _value);
311     emit Transfer(burner, address(0), _value);
312   }
313 }
314 
315 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
316 
317 /**
318  * @title ERC20 interface
319  * @dev see https://github.com/ethereum/EIPs/issues/20
320  */
321 contract ERC20 is ERC20Basic {
322   function allowance(address owner, address spender) public view returns (uint256);
323   function transferFrom(address from, address to, uint256 value) public returns (bool);
324   function approve(address spender, uint256 value) public returns (bool);
325   event Approval(address indexed owner, address indexed spender, uint256 value);
326 }
327 
328 // File: contracts\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
329 
330 contract DetailedERC20 is ERC20 {
331   string public name;
332   string public symbol;
333   uint8 public decimals;
334 
335   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
336     name = _name;
337     symbol = _symbol;
338     decimals = _decimals;
339   }
340 }
341 
342 // File: contracts\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
343 
344 /**
345  * @title Standard ERC20 token
346  *
347  * @dev Implementation of the basic standard token.
348  * @dev https://github.com/ethereum/EIPs/issues/20
349  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
350  */
351 contract StandardToken is ERC20, BasicToken {
352 
353   mapping (address => mapping (address => uint256)) internal allowed;
354 
355 
356   /**
357    * @dev Transfer tokens from one address to another
358    * @param _from address The address which you want to send tokens from
359    * @param _to address The address which you want to transfer to
360    * @param _value uint256 the amount of tokens to be transferred
361    */
362   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
363     require(_to != address(0));
364     require(_value <= balances[_from]);
365     require(_value <= allowed[_from][msg.sender]);
366 
367     balances[_from] = balances[_from].sub(_value);
368     balances[_to] = balances[_to].add(_value);
369     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
370     emit Transfer(_from, _to, _value);
371     return true;
372   }
373 
374   /**
375    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
376    *
377    * Beware that changing an allowance with this method brings the risk that someone may use both the old
378    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
379    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
380    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381    * @param _spender The address which will spend the funds.
382    * @param _value The amount of tokens to be spent.
383    */
384   function approve(address _spender, uint256 _value) public returns (bool) {
385     allowed[msg.sender][_spender] = _value;
386     emit Approval(msg.sender, _spender, _value);
387     return true;
388   }
389 
390   /**
391    * @dev Function to check the amount of tokens that an owner allowed to a spender.
392    * @param _owner address The address which owns the funds.
393    * @param _spender address The address which will spend the funds.
394    * @return A uint256 specifying the amount of tokens still available for the spender.
395    */
396   function allowance(address _owner, address _spender) public view returns (uint256) {
397     return allowed[_owner][_spender];
398   }
399 
400   /**
401    * @dev Increase the amount of tokens that an owner allowed to a spender.
402    *
403    * approve should be called when allowed[_spender] == 0. To increment
404    * allowed value is better to use this function to avoid 2 calls (and wait until
405    * the first transaction is mined)
406    * From MonolithDAO Token.sol
407    * @param _spender The address which will spend the funds.
408    * @param _addedValue The amount of tokens to increase the allowance by.
409    */
410   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
411     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
412     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
413     return true;
414   }
415 
416   /**
417    * @dev Decrease the amount of tokens that an owner allowed to a spender.
418    *
419    * approve should be called when allowed[_spender] == 0. To decrement
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _subtractedValue The amount of tokens to decrease the allowance by.
425    */
426   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
427     uint oldValue = allowed[msg.sender][_spender];
428     if (_subtractedValue > oldValue) {
429       allowed[msg.sender][_spender] = 0;
430     } else {
431       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
432     }
433     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
434     return true;
435   }
436 
437 }
438 
439 // File: contracts\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
440 
441 /**
442  * @title Mintable token
443  * @dev Simple ERC20 Token example, with mintable token creation
444  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
445  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
446  */
447 contract MintableToken is StandardToken, Ownable {
448   event Mint(address indexed to, uint256 amount);
449   event MintFinished();
450 
451   bool public mintingFinished = false;
452 
453 
454   modifier canMint() {
455     require(!mintingFinished);
456     _;
457   }
458 
459   /**
460    * @dev Function to mint tokens
461    * @param _to The address that will receive the minted tokens.
462    * @param _amount The amount of tokens to mint.
463    * @return A boolean that indicates if the operation was successful.
464    */
465   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
466     totalSupply_ = totalSupply_.add(_amount);
467     balances[_to] = balances[_to].add(_amount);
468     emit Mint(_to, _amount);
469     emit Transfer(address(0), _to, _amount);
470     return true;
471   }
472 
473   /**
474    * @dev Function to stop minting new tokens.
475    * @return True if the operation was successful.
476    */
477   function finishMinting() onlyOwner canMint public returns (bool) {
478     mintingFinished = true;
479     emit MintFinished();
480     return true;
481   }
482 }
483 
484 // File: contracts\PGF500Token.sol
485 
486 contract PGF500Token is BurnableToken, MintableToken, DetailedERC20, LockableWhitelisted {
487 
488   uint256 constant internal DECIMALS = 18;
489 
490   function PGF500Token (uint256 _initialSupply) public
491     BurnableToken()
492     MintableToken()
493     DetailedERC20('PGF500 Token', 'PGF7T', uint8(DECIMALS))
494     LockableWhitelisted()
495    {
496     require(_initialSupply > 0);
497     mint(owner, _initialSupply);
498     finishMinting();
499     addAddressToWhitelist(owner);
500     lock();
501   }
502 
503   function transfer(address _to, uint256 _value) public whenNotLocked(msg.sender) returns (bool) {
504     return super.transfer(_to, _value);
505   }
506 
507   function transferFrom(address _from, address _to, uint256 _value) public whenNotLocked(_from) returns (bool) {
508     return super.transferFrom(_from, _to, _value);
509   }
510 
511   function approve(address _spender, uint256 _value) public whenNotLocked(msg.sender) returns (bool) {
512     return super.approve(_spender, _value);
513   }
514 
515   function increaseApproval(address _spender, uint _addedValue) public whenNotLocked(msg.sender) returns (bool success) {
516     return super.increaseApproval(_spender, _addedValue);
517   }
518 
519   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotLocked(msg.sender) returns (bool success) {
520     return super.decreaseApproval(_spender, _subtractedValue);
521   }
522 
523   function transferOwnership(address _newOwner) public onlyOwner {
524     if (owner != _newOwner) {
525       addAddressToWhitelist(_newOwner);
526       removeAddressFromWhitelist(owner);
527     }
528     super.transferOwnership(_newOwner);
529   }
530 
531   /**
532   * @dev Transfers the same amount of tokens to up to 200 specified addresses.
533   * If the sender runs out of balance then the entire transaction fails.
534   * @param _to The addresses to transfer to.
535   * @param _value The amount to be transferred to each address.
536   */
537   function airdrop(address[] _to, uint256 _value) public whenNotLocked(msg.sender)
538   {
539     require(_to.length <= 200);
540     require(balanceOf(msg.sender) >= _value.mul(_to.length));
541 
542     for (uint i = 0; i < _to.length; i++)
543     {
544       transfer(_to[i], _value);
545     }
546   }
547 
548   /**
549   * @dev Transfers a variable amount of tokens to up to 200 specified addresses.
550   * If the sender runs out of balance then the entire transaction fails.
551   * For each address a value must be specified.
552   * @param _to The addresses to transfer to.
553   * @param _values The amounts to be transferred to the addresses.
554   */
555   function multiTransfer(address[] _to, uint256[] _values) public whenNotLocked(msg.sender)
556   {
557     require(_to.length <= 200);
558     require(_to.length == _values.length);
559 
560     for (uint i = 0; i < _to.length; i++)
561     {
562       transfer(_to[i], _values[i]);
563     }
564   }
565 // Proprietary a6f18ae3a419c6634596bee10ba51328
566 }