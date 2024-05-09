1 /*
2   8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      
3     888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      
4     888  888    888 888     888 Y88b.      888                     888                 888      
5     888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  
6     888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b 
7     888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 
8     888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 
9   8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 
10 
11   Rocket startup for your ICO
12 
13   The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.
14   All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,
15   Master Nodes management, on a single SaaS platform!
16 */
17 pragma solidity ^0.4.21;
18 
19 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 // File: contracts\zeppelin-solidity\contracts\ownership\Whitelist.sol
62 
63 /**
64  * @title Whitelist
65  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
66  * @dev This simplifies the implementation of "user permissions".
67  */
68 contract Whitelist is Ownable {
69   mapping(address => bool) public whitelist;
70   
71   event WhitelistedAddressAdded(address addr);
72   event WhitelistedAddressRemoved(address addr);
73 
74   /**
75    * @dev Throws if called by any account that's not whitelisted.
76    */
77   modifier onlyWhitelisted() {
78     require(whitelist[msg.sender]);
79     _;
80   }
81 
82   /**
83    * @dev add an address to the whitelist
84    * @param addr address
85    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
86    */
87   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
88     if (!whitelist[addr]) {
89       whitelist[addr] = true;
90       emit WhitelistedAddressAdded(addr);
91       success = true; 
92     }
93   }
94 
95   /**
96    * @dev add addresses to the whitelist
97    * @param addrs addresses
98    * @return true if at least one address was added to the whitelist, 
99    * false if all addresses were already in the whitelist  
100    */
101   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
102     for (uint256 i = 0; i < addrs.length; i++) {
103       if (addAddressToWhitelist(addrs[i])) {
104         success = true;
105       }
106     }
107   }
108 
109   /**
110    * @dev remove an address from the whitelist
111    * @param addr address
112    * @return true if the address was removed from the whitelist, 
113    * false if the address wasn't in the whitelist in the first place 
114    */
115   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
116     if (whitelist[addr]) {
117       whitelist[addr] = false;
118       emit WhitelistedAddressRemoved(addr);
119       success = true;
120     }
121   }
122 
123   /**
124    * @dev remove addresses from the whitelist
125    * @param addrs addresses
126    * @return true if at least one address was removed from the whitelist, 
127    * false if all addresses weren't in the whitelist in the first place
128    */
129   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
130     for (uint256 i = 0; i < addrs.length; i++) {
131       if (removeAddressFromWhitelist(addrs[i])) {
132         success = true;
133       }
134     }
135   }
136 
137 }
138 
139 // File: contracts\LockableWhitelisted.sol
140 
141 /**
142  * @dev A Whitelist contract that can be locked and unlocked. Provides a modifier
143  * to check for locked state plus functions and events. The contract is never locked for
144  * whitelisted addresses. The contracts starts off unlocked and can be locked and
145  * then unlocked a single time. Once unlocked, the contract can never be locked back.
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract LockableWhitelisted is Whitelist {
149   event Locked();
150   event Unlocked();
151 
152   bool public locked = false;
153   bool private unlockedOnce = false;
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not locked
157    * or the caller is whitelisted.
158    */
159   modifier whenNotLocked(address _address) {
160     require(!locked || whitelist[_address]);
161     _;
162   }
163 
164   /**
165    * @dev Returns true if the specified address is whitelisted.
166    * @param _address The address to check for whitelisting status.
167    */
168   function isWhitelisted(address _address) public view returns (bool) {
169     return whitelist[_address];
170   }
171 
172   /**
173    * @dev Called by the owner to lock.
174    */
175   function lock() onlyOwner public {
176     require(!unlockedOnce);
177     if (!locked) {
178       locked = true;
179       emit Locked();
180     }
181   }
182 
183   /**
184    * @dev Called by the owner to unlock.
185    */
186   function unlock() onlyOwner public {
187     if (locked) {
188       locked = false;
189       unlockedOnce = true;
190       emit Unlocked();
191     }
192   }
193 }
194 
195 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
196 
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that throw on error
200  */
201 library SafeMath {
202 
203   /**
204   * @dev Multiplies two numbers, throws on overflow.
205   */
206   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207     if (a == 0) {
208       return 0;
209     }
210     uint256 c = a * b;
211     assert(c / a == b);
212     return c;
213   }
214 
215   /**
216   * @dev Integer division of two numbers, truncating the quotient.
217   */
218   function div(uint256 a, uint256 b) internal pure returns (uint256) {
219     // assert(b > 0); // Solidity automatically throws when dividing by 0
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222     return c;
223   }
224 
225   /**
226   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
227   */
228   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   /**
234   * @dev Adds two numbers, throws on overflow.
235   */
236   function add(uint256 a, uint256 b) internal pure returns (uint256) {
237     uint256 c = a + b;
238     assert(c >= a);
239     return c;
240   }
241 }
242 
243 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
244 
245 /**
246  * @title ERC20Basic
247  * @dev Simpler version of ERC20 interface
248  * @dev see https://github.com/ethereum/EIPs/issues/179
249  */
250 contract ERC20Basic {
251   function totalSupply() public view returns (uint256);
252   function balanceOf(address who) public view returns (uint256);
253   function transfer(address to, uint256 value) public returns (bool);
254   event Transfer(address indexed from, address indexed to, uint256 value);
255 }
256 
257 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
258 
259 /**
260  * @title Basic token
261  * @dev Basic version of StandardToken, with no allowances.
262  */
263 contract BasicToken is ERC20Basic {
264   using SafeMath for uint256;
265 
266   mapping(address => uint256) balances;
267 
268   uint256 totalSupply_;
269 
270   /**
271   * @dev total number of tokens in existence
272   */
273   function totalSupply() public view returns (uint256) {
274     return totalSupply_;
275   }
276 
277   /**
278   * @dev transfer token for a specified address
279   * @param _to The address to transfer to.
280   * @param _value The amount to be transferred.
281   */
282   function transfer(address _to, uint256 _value) public returns (bool) {
283     require(_to != address(0));
284     require(_value <= balances[msg.sender]);
285 
286     // SafeMath.sub will throw if there is not enough balance.
287     balances[msg.sender] = balances[msg.sender].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     emit Transfer(msg.sender, _to, _value);
290     return true;
291   }
292 
293   /**
294   * @dev Gets the balance of the specified address.
295   * @param _owner The address to query the the balance of.
296   * @return An uint256 representing the amount owned by the passed address.
297   */
298   function balanceOf(address _owner) public view returns (uint256 balance) {
299     return balances[_owner];
300   }
301 
302 }
303 
304 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
305 
306 /**
307  * @title Burnable Token
308  * @dev Token that can be irreversibly burned (destroyed).
309  */
310 contract BurnableToken is BasicToken {
311 
312   event Burn(address indexed burner, uint256 value);
313 
314   /**
315    * @dev Burns a specific amount of tokens.
316    * @param _value The amount of token to be burned.
317    */
318   function burn(uint256 _value) public {
319     require(_value <= balances[msg.sender]);
320     // no need to require value <= totalSupply, since that would imply the
321     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
322 
323     address burner = msg.sender;
324     balances[burner] = balances[burner].sub(_value);
325     totalSupply_ = totalSupply_.sub(_value);
326     emit Burn(burner, _value);
327     emit Transfer(burner, address(0), _value);
328   }
329 }
330 
331 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
332 
333 /**
334  * @title ERC20 interface
335  * @dev see https://github.com/ethereum/EIPs/issues/20
336  */
337 contract ERC20 is ERC20Basic {
338   function allowance(address owner, address spender) public view returns (uint256);
339   function transferFrom(address from, address to, uint256 value) public returns (bool);
340   function approve(address spender, uint256 value) public returns (bool);
341   event Approval(address indexed owner, address indexed spender, uint256 value);
342 }
343 
344 // File: contracts\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
345 
346 contract DetailedERC20 is ERC20 {
347   string public name;
348   string public symbol;
349   uint8 public decimals;
350 
351   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
352     name = _name;
353     symbol = _symbol;
354     decimals = _decimals;
355   }
356 }
357 
358 // File: contracts\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
359 
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * @dev https://github.com/ethereum/EIPs/issues/20
365  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  */
367 contract StandardToken is ERC20, BasicToken {
368 
369   mapping (address => mapping (address => uint256)) internal allowed;
370 
371 
372   /**
373    * @dev Transfer tokens from one address to another
374    * @param _from address The address which you want to send tokens from
375    * @param _to address The address which you want to transfer to
376    * @param _value uint256 the amount of tokens to be transferred
377    */
378   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
379     require(_to != address(0));
380     require(_value <= balances[_from]);
381     require(_value <= allowed[_from][msg.sender]);
382 
383     balances[_from] = balances[_from].sub(_value);
384     balances[_to] = balances[_to].add(_value);
385     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
386     emit Transfer(_from, _to, _value);
387     return true;
388   }
389 
390   /**
391    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
392    *
393    * Beware that changing an allowance with this method brings the risk that someone may use both the old
394    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
395    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
396    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397    * @param _spender The address which will spend the funds.
398    * @param _value The amount of tokens to be spent.
399    */
400   function approve(address _spender, uint256 _value) public returns (bool) {
401     allowed[msg.sender][_spender] = _value;
402     emit Approval(msg.sender, _spender, _value);
403     return true;
404   }
405 
406   /**
407    * @dev Function to check the amount of tokens that an owner allowed to a spender.
408    * @param _owner address The address which owns the funds.
409    * @param _spender address The address which will spend the funds.
410    * @return A uint256 specifying the amount of tokens still available for the spender.
411    */
412   function allowance(address _owner, address _spender) public view returns (uint256) {
413     return allowed[_owner][_spender];
414   }
415 
416   /**
417    * @dev Increase the amount of tokens that an owner allowed to a spender.
418    *
419    * approve should be called when allowed[_spender] == 0. To increment
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _addedValue The amount of tokens to increase the allowance by.
425    */
426   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
427     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
428     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
429     return true;
430   }
431 
432   /**
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434    *
435    * approve should be called when allowed[_spender] == 0. To decrement
436    * allowed value is better to use this function to avoid 2 calls (and wait until
437    * the first transaction is mined)
438    * From MonolithDAO Token.sol
439    * @param _spender The address which will spend the funds.
440    * @param _subtractedValue The amount of tokens to decrease the allowance by.
441    */
442   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
443     uint oldValue = allowed[msg.sender][_spender];
444     if (_subtractedValue > oldValue) {
445       allowed[msg.sender][_spender] = 0;
446     } else {
447       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
448     }
449     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
450     return true;
451   }
452 
453 }
454 
455 // File: contracts\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
456 
457 /**
458  * @title Mintable token
459  * @dev Simple ERC20 Token example, with mintable token creation
460  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
461  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
462  */
463 contract MintableToken is StandardToken, Ownable {
464   event Mint(address indexed to, uint256 amount);
465   event MintFinished();
466 
467   bool public mintingFinished = false;
468 
469 
470   modifier canMint() {
471     require(!mintingFinished);
472     _;
473   }
474 
475   /**
476    * @dev Function to mint tokens
477    * @param _to The address that will receive the minted tokens.
478    * @param _amount The amount of tokens to mint.
479    * @return A boolean that indicates if the operation was successful.
480    */
481   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
482     totalSupply_ = totalSupply_.add(_amount);
483     balances[_to] = balances[_to].add(_amount);
484     emit Mint(_to, _amount);
485     emit Transfer(address(0), _to, _amount);
486     return true;
487   }
488 
489   /**
490    * @dev Function to stop minting new tokens.
491    * @return True if the operation was successful.
492    */
493   function finishMinting() onlyOwner canMint public returns (bool) {
494     mintingFinished = true;
495     emit MintFinished();
496     return true;
497   }
498 }
499 
500 // File: contracts\ICOStartToken.sol
501 
502 contract ICOStartToken is BurnableToken, MintableToken, DetailedERC20, LockableWhitelisted {
503 
504   uint256 constant internal DECIMALS = 18;
505 
506   function ICOStartToken (uint256 _initialSupply) public
507     BurnableToken()
508     MintableToken()
509     DetailedERC20('ICOStart Token', 'ICH', uint8(DECIMALS))
510     LockableWhitelisted()
511    {
512     require(_initialSupply > 0);
513     mint(owner, _initialSupply);
514     finishMinting();
515     addAddressToWhitelist(owner);
516     lock();
517   }
518 
519   function transfer(address _to, uint256 _value) public whenNotLocked(msg.sender) returns (bool) {
520     return super.transfer(_to, _value);
521   }
522 
523   function transferFrom(address _from, address _to, uint256 _value) public whenNotLocked(_from) returns (bool) {
524     return super.transferFrom(_from, _to, _value);
525   }
526 
527   function approve(address _spender, uint256 _value) public whenNotLocked(msg.sender) returns (bool) {
528     return super.approve(_spender, _value);
529   }
530 
531   function increaseApproval(address _spender, uint _addedValue) public whenNotLocked(msg.sender) returns (bool success) {
532     return super.increaseApproval(_spender, _addedValue);
533   }
534 
535   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotLocked(msg.sender) returns (bool success) {
536     return super.decreaseApproval(_spender, _subtractedValue);
537   }
538 
539   function transferOwnership(address _newOwner) public onlyOwner {
540     if (owner != _newOwner) {
541       addAddressToWhitelist(_newOwner);
542       removeAddressFromWhitelist(owner);
543     }
544     super.transferOwnership(_newOwner);
545   }
546 
547   /**
548   * @dev Transfers the same amount of tokens to up to 200 specified addresses.
549   * If the sender runs out of balance then the entire transaction fails.
550   * @param _to The addresses to transfer to.
551   * @param _value The amount to be transferred to each address.
552   */
553   function airdrop(address[] _to, uint256 _value) public whenNotLocked(msg.sender)
554   {
555     require(_to.length <= 200);
556     require(balanceOf(msg.sender) >= _value.mul(_to.length));
557 
558     for (uint i = 0; i < _to.length; i++)
559     {
560       transfer(_to[i], _value);
561     }
562   }
563 
564   /**
565   * @dev Transfers a variable amount of tokens to up to 200 specified addresses.
566   * If the sender runs out of balance then the entire transaction fails.
567   * For each address a value must be specified.
568   * @param _to The addresses to transfer to.
569   * @param _values The amounts to be transferred to the addresses.
570   */
571   function multiTransfer(address[] _to, uint256[] _values) public whenNotLocked(msg.sender)
572   {
573     require(_to.length <= 200);
574     require(_to.length == _values.length);
575 
576     for (uint i = 0; i < _to.length; i++)
577     {
578       transfer(_to[i], _values[i]);
579     }
580   }
581 
582 }