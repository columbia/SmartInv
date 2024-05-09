1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     assert(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(
33     ERC20 token,
34     address from,
35     address to,
36     uint256 value
37   )
38     internal
39   {
40     assert(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     assert(token.approve(spender, value));
45   }
46 }
47 
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that throw on error
102  */
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     if (a == 0) {
110       return 0;
111     }
112     c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   /**
118   * @dev Integer division of two numbers, truncating the quotient.
119   */
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     // uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return a / b;
125   }
126 
127   /**
128   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   /**
136   * @dev Adds two numbers, throws on overflow.
137   */
138   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }
144 
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 
192 
193 
194 
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address owner, address spender) public view returns (uint256);
202   function transferFrom(address from, address to, uint256 value) public returns (bool);
203   function approve(address spender, uint256 value) public returns (bool);
204   event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 
208 
209 /**
210  * @title Standard ERC20 token
211  *
212  * @dev Implementation of the basic standard token.
213  * @dev https://github.com/ethereum/EIPs/issues/20
214  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  */
216 contract StandardToken is ERC20, BasicToken {
217 
218   mapping (address => mapping (address => uint256)) internal allowed;
219 
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
228     require(_to != address(0));
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    *
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(address _owner, address _spender) public view returns (uint256) {
262     return allowed[_owner][_spender];
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
276     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 
305 
306 
307 
308 
309 /**
310  * @title Burnable Token
311  * @dev Token that can be irreversibly burned (destroyed).
312  */
313 contract BurnableToken is BasicToken {
314 
315   event Burn(address indexed burner, uint256 value);
316 
317   /**
318    * @dev Burns a specific amount of tokens.
319    * @param _value The amount of token to be burned.
320    */
321   function burn(uint256 _value) public {
322     _burn(msg.sender, _value);
323   }
324 
325   function _burn(address _who, uint256 _value) internal {
326     require(_value <= balances[_who]);
327     // no need to require value <= totalSupply, since that would imply the
328     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330     balances[_who] = balances[_who].sub(_value);
331     totalSupply_ = totalSupply_.sub(_value);
332     emit Burn(_who, _value);
333     emit Transfer(_who, address(0), _value);
334   }
335 }
336 
337 
338 
339 
340 
341 
342 
343 
344 /**
345  * @title Pausable
346  * @dev Base contract which allows children to implement an emergency stop mechanism.
347  */
348 contract Pausable is Ownable {
349   event Pause();
350   event Unpause();
351 
352   bool public paused = false;
353 
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is not paused.
357    */
358   modifier whenNotPaused() {
359     require(!paused);
360     _;
361   }
362 
363   /**
364    * @dev Modifier to make a function callable only when the contract is paused.
365    */
366   modifier whenPaused() {
367     require(paused);
368     _;
369   }
370 
371   /**
372    * @dev called by the owner to pause, triggers stopped state
373    */
374   function pause() onlyOwner whenNotPaused public {
375     paused = true;
376     emit Pause();
377   }
378 
379   /**
380    * @dev called by the owner to unpause, returns to normal state
381    */
382   function unpause() onlyOwner whenPaused public {
383     paused = false;
384     emit Unpause();
385   }
386 }
387 
388 
389 
390 
391 
392 
393 /**
394  * @title Contracts that should not own Ether
395  * @author Remco Bloemen <remco@2π.com>
396  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
397  * in the contract, it will allow the owner to reclaim this ether.
398  * @notice Ether can still be sent to this contract by:
399  * calling functions labeled `payable`
400  * `selfdestruct(contract_address)`
401  * mining directly to the contract address
402  */
403 contract HasNoEther is Ownable {
404 
405   /**
406   * @dev Constructor that rejects incoming Ether
407   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
408   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
409   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
410   * we could use assembly to access msg.value.
411   */
412   function HasNoEther() public payable {
413     require(msg.value == 0);
414   }
415 
416   /**
417    * @dev Disallows direct send by settings a default function without the `payable` flag.
418    */
419   function() external {
420   }
421 
422   /**
423    * @dev Transfer all Ether held by the contract to the owner.
424    */
425   function reclaimEther() external onlyOwner {
426     // solium-disable-next-line security/no-send
427     assert(owner.send(address(this).balance));
428   }
429 }
430 
431 
432 
433 
434 
435 
436 
437 
438 /**
439  * @title Contracts that should be able to recover tokens
440  * @author SylTi
441  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
442  * This will prevent any accidental loss of tokens.
443  */
444 contract CanReclaimToken is Ownable {
445   using SafeERC20 for ERC20Basic;
446 
447   /**
448    * @dev Reclaim all ERC20Basic compatible tokens
449    * @param token ERC20Basic The address of the token contract
450    */
451   function reclaimToken(ERC20Basic token) external onlyOwner {
452     uint256 balance = token.balanceOf(this);
453     token.safeTransfer(owner, balance);
454   }
455 
456 }
457 
458 
459 
460 contract Whitelist is Pausable {
461   mapping(address => bool) public whitelist;
462   uint public numberOfWhitelists;
463   event WhitelistedAddressAdded(address addr);
464   event WhitelistedAddressRemoved(address addr);
465 
466   /**
467    * @dev Throws if called by any account that's not whitelisted.
468    */
469   modifier onlyWhitelisted() {
470     require(whitelist[msg.sender]);
471     _;
472   }
473 
474   constructor() public {
475     whitelist[msg.sender] = true;
476     numberOfWhitelists = 1;
477     emit WhitelistedAddressAdded(msg.sender);
478   }
479   /**
480    * @dev add an address to the whitelist
481    * @param addr address
482    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
483    */
484   function addAddressToWhitelist(address addr) onlyWhitelisted whenNotPaused public returns(bool success) {
485     if (!whitelist[addr]) {
486       whitelist[addr] = true;
487       numberOfWhitelists++;
488       emit WhitelistedAddressAdded(addr);
489       success = true;
490     }
491   }
492 
493   /**
494    * @dev remove an address from the whitelist
495    * @param addr address
496    * @return true if the address was removed from the whitelist,
497    * false if the address wasn't in the whitelist in the first place
498    */
499   function removeAddressFromWhitelist(address addr) onlyWhitelisted whenNotPaused public returns(bool success) {
500     require(numberOfWhitelists > 1);
501     if (whitelist[addr]) {
502       whitelist[addr] = false;
503       numberOfWhitelists--;
504       emit WhitelistedAddressRemoved(addr);
505       success = true;
506     }
507   }
508 
509 }
510 
511 /**
512  * @title SimpleToken
513  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
514  * Note they can later distribute these tokens as they wish using `transfer` and other
515  * `StandardToken` functions.
516  */
517 contract SimpleToken is StandardToken, BurnableToken, Whitelist, HasNoEther, CanReclaimToken {
518 
519   string public constant name = "KubitCoin"; // solium-disable-line uppercase
520   string public constant symbol = "KBX"; // solium-disable-line uppercase
521   uint8 public constant decimals = 18; // solium-disable-line uppercase
522   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
523 
524   mapping(address => bool) public blacklist;
525   event BlacklistedAddressAdded(address _address);
526   event BlacklistedAddressRemoved(address _address);
527 
528   modifier canTransfer(address from, address to) {
529     if(blacklist[from]) {
530       if(whitelist[to]) {
531         _;
532       } else {
533         revert();
534       }
535     } else {
536       _;
537     }
538   }
539 
540   /**
541    * @dev Constructor that gives msg.sender all of existing tokens.
542    */
543   constructor() public {
544     totalSupply_ = INITIAL_SUPPLY;
545     balances[msg.sender] = INITIAL_SUPPLY;
546     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
547   }
548 
549 
550   function transfer(address _to, uint _value) canTransfer(msg.sender, _to) whenNotPaused public  returns (bool success) {
551    return super.transfer(_to, _value);
552   }
553 
554   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _to)  whenNotPaused public  returns (bool success) {
555     return super.transferFrom(_from, _to, _value);
556   }
557 
558 
559   function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
560     super.approve(_spender, _value);
561   }
562 
563   function increaseApproval(address _spender, uint _addedValue)  whenNotPaused public returns (bool) {
564     super.increaseApproval(_spender, _addedValue);
565   }
566 
567   function decreaseApproval(address _spender, uint _subtractedValue)  whenNotPaused public returns (bool) {
568     super.decreaseApproval(_spender, _subtractedValue);
569   }
570 
571   function burn(uint256 value) public onlyWhitelisted whenNotPaused {
572     super.burn(value);
573   }
574 
575   function addAddressToBlacklist(address addr) onlyWhitelisted whenNotPaused public returns(bool success) {
576     if (!blacklist[addr]) {
577       blacklist[addr] = true;
578       emit BlacklistedAddressAdded(addr);
579       success = true;
580     }
581   }
582 
583   function removeAddressFromBlacklist(address addr) onlyWhitelisted whenNotPaused public returns(bool success) {
584     if (blacklist[addr]) {
585       blacklist[addr] = false;
586       emit BlacklistedAddressRemoved(addr);
587       success = true;
588     }
589   }
590 }