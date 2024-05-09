1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title SafeERC20
51  * @dev Wrappers around ERC20 operations that throw on failure.
52  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
53  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
54  */
55 library SafeERC20 {
56   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
57     assert(token.transfer(to, value));
58   }
59 
60   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
61     assert(token.transferFrom(from, to, value));
62   }
63 
64   function safeApprove(ERC20 token, address spender, uint256 value) internal {
65     assert(token.approve(spender, value));
66   }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   function Ownable() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) public onlyOwner {
102     require(newOwner != address(0));
103     OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 }
107 
108 /**
109  * @title Contactable token
110  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
111  * contact information.
112  */
113 contract Contactable is Ownable {
114 
115   string public contactInformation;
116 
117   /**
118     * @dev Allows the owner to set a string with their contact information.
119     * @param info The contact information to attach to the contract.
120     */
121   function setContactInformation(string info) onlyOwner public {
122     contactInformation = info;
123   }
124 }
125 
126 
127 interface BlacklistInterface {
128 
129     event Blacklisted(address indexed _node);
130     event Unblacklisted(address indexed _node);
131     
132     function blacklist(address _node) public;
133     function unblacklist(address _node) public;
134     function isBanned(address _node) returns (bool);
135 
136 }
137 
138 contract Blacklist is BlacklistInterface, Ownable {
139 
140     mapping (address => bool) blacklisted;
141 
142     /**
143      * @dev Add a node to the blacklist.
144      * @param node The node to add to the blacklist.
145      */
146     function blacklist(address node) public onlyOwner {
147         blacklisted[node] = true;
148         Blacklisted(node);
149     }
150     
151     /** 
152      * @dev Remove a node from the blacklist.
153      * @param node The node to remove from the blacklist.
154      */
155     function unblacklist(address node) public onlyOwner {
156         blacklisted[node] = false;
157         Unblacklisted(node);
158     }
159     
160     function isBanned(address node) onlyOwner returns (bool) {
161         if (blacklisted[node]) {
162             return true;
163         } else {
164             return false;
165         }
166     }
167 }
168 
169 /**
170  * @title Claimable
171  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
172  * This allows the new owner to accept the transfer.
173  */
174 contract Claimable is Ownable {
175   address public pendingOwner;
176 
177   /**
178    * @dev Modifier throws if called by any account other than the pendingOwner.
179    */
180   modifier onlyPendingOwner() {
181     require(msg.sender == pendingOwner);
182     _;
183   }
184 
185   /**
186    * @dev Allows the current owner to set the pendingOwner address.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address newOwner) onlyOwner public {
190     pendingOwner = newOwner;
191   }
192 
193   /**
194    * @dev Allows the pendingOwner address to finalize the transfer.
195    */
196   function claimOwnership() onlyPendingOwner public {
197     OwnershipTransferred(owner, pendingOwner);
198     owner = pendingOwner;
199     pendingOwner = address(0);
200   }
201 }
202 
203 /**
204  * @title ERC20Basic
205  * @dev Simpler version of ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/179
207  */
208 contract ERC20Basic {
209   function totalSupply() public view returns (uint256);
210   function balanceOf(address who) public view returns (uint256);
211   function transfer(address to, uint256 value) public returns (bool);
212   event Transfer(address indexed from, address indexed to, uint256 value);
213 }
214 
215 /**
216  * @title Basic token
217  * @dev Basic version of StandardToken, with no allowances.
218  */
219 contract BasicToken is ERC20Basic, Blacklist {
220   using SafeMath for uint256;
221 
222   mapping(address => uint256) balances;
223 
224   uint256 totalSupply_;
225   modifier onlyPayloadSize(uint256 numwords) {
226     assert(msg.data.length >= numwords * 32 + 4);
227     _;
228   }
229 
230   /**
231   * @dev total number of tokens in existence
232   */
233   function totalSupply() public view returns (uint256) {
234     return totalSupply_;
235   }
236 
237   /**
238   * @dev transfer token for a specified address
239   * @param _to The address to transfer to.
240   * @param _value The amount to be transferred.
241   */
242   function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
243     require(_to != address(0));
244     require(!isBanned(_to));
245     require(_value <= balances[msg.sender]);
246 
247     // SafeMath.sub will throw if there is not enough balance.
248     balances[msg.sender] = balances[msg.sender].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     Transfer(msg.sender, _to, _value);
251     return true;
252   }
253 
254   /**
255   * @dev Gets the balance of the specified address.
256   * @param _owner The address to query the the balance of.
257   * @return An uint256 representing the amount owned by the passed address.
258   */
259   function balanceOf(address _owner) public view returns (uint256 balance) {
260     return balances[_owner];
261   }
262 
263 }
264 
265 /**
266  * @title ERC20 interface
267  * @dev see https://github.com/ethereum/EIPs/issues/20
268  */
269 contract ERC20 is ERC20Basic {
270   function allowance(address owner, address spender) public view returns (uint256);
271   function transferFrom(address from, address to, uint256 value) public returns (bool);
272   function approve(address spender, uint256 value) public returns (bool);
273   event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 /**
277  * @title Standard ERC20 token
278  *
279  * @dev Implementation of the basic standard token.
280  * @dev https://github.com/ethereum/EIPs/issues/20
281  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
282  */
283 contract StandardToken is ERC20, BasicToken {
284 
285   mapping (address => mapping (address => uint256)) internal allowed;
286 
287 
288   /**
289    * @dev Transfer tokens from one address to another
290    * @param _from address The address which you want to send tokens from
291    * @param _to address The address which you want to transfer to
292    * @param _value uint256 the amount of tokens to be transferred
293    */
294   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
295     require(_to != address(0));
296     require(!isBanned(_to));
297     require(_value <= balances[_from]);
298     require(_value <= allowed[_from][msg.sender]);
299 
300     balances[_from] = balances[_from].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
303     Transfer(_from, _to, _value);
304     return true;
305   }
306 
307   /**
308    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
309    *
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(address _owner, address _spender) public view returns (uint256) {
330     return allowed[_owner][_spender];
331   }
332 
333   /**
334    * @dev Increase the amount of tokens that an owner allowed to a spender.
335    *
336    * approve should be called when allowed[_spender] == 0. To increment
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _addedValue The amount of tokens to increase the allowance by.
342    */
343   function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
344     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
345     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349   /**
350    * @dev Decrease the amount of tokens that an owner allowed to a spender.
351    *
352    * approve should be called when allowed[_spender] == 0. To decrement
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _subtractedValue The amount of tokens to decrease the allowance by.
358    */
359   function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
360     uint oldValue = allowed[msg.sender][_spender];
361     if (_subtractedValue > oldValue) {
362       allowed[msg.sender][_spender] = 0;
363     } else {
364       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
365     }
366     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
367     return true;
368   }
369 
370 }
371 
372 /**
373  * @title Pausable
374  * @dev Base contract which allows children to implement an emergency stop mechanism.
375  */
376 contract Pausable is Ownable {
377   event Pause();
378   event Unpause();
379 
380   bool public paused = false;
381 
382 
383   /**
384    * @dev Modifier to make a function callable only when the contract is not paused.
385    */
386   modifier whenNotPaused() {
387     require(!paused);
388     _;
389   }
390 
391   /**
392    * @dev Modifier to make a function callable only when the contract is paused.
393    */
394   modifier whenPaused() {
395     require(paused);
396     _;
397   }
398 
399   /**
400    * @dev called by the owner to pause, triggers stopped state
401    */
402   function pause() onlyOwner whenNotPaused public {
403     paused = true;
404     Pause();
405   }
406 
407   /**
408    * @dev called by the owner to unpause, returns to normal state
409    */
410   function unpause() onlyOwner whenPaused public {
411     paused = false;
412     Unpause();
413   }
414 }
415 
416 /**
417  * @title Pausable token
418  * @dev StandardToken modified with pausable transfers.
419  **/
420 contract PausableToken is StandardToken, Pausable {
421 
422   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
423     return super.transfer(_to, _value);
424   }
425 
426   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
427     return super.transferFrom(_from, _to, _value);
428   }
429 
430   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
431     return super.approve(_spender, _value);
432   }
433 
434   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
435     return super.increaseApproval(_spender, _addedValue);
436   }
437 
438   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
439     return super.decreaseApproval(_spender, _subtractedValue);
440   }
441 }
442 
443 /**
444  * @title Mintable token
445  * @dev Simple ERC20 Token example, with mintable token creation
446  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
447  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
448  */
449 contract MintableToken is PausableToken {
450 
451   event Mint(address indexed to, uint256 amount);
452   event MintFinished();
453 
454   bool public mintingFinished = false;
455   uint256 limit = 952457688 * 10 ** 18;
456 
457   modifier canMint() {
458     require(!mintingFinished);
459     _;
460   }
461 
462   /**
463    * @dev Function to mint tokens
464    * @param _to The address that will receive the minted tokens.
465    * @param _amount The amount of tokens to mint.
466    * @return A boolean that indicates if the operation was successful.
467    */
468   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
469     require(totalSupply_.add(_amount) <= limit);
470     totalSupply_ = totalSupply_.add(_amount);
471     balances[_to] = balances[_to].add(_amount);
472     Mint(_to, _amount);
473     Transfer(address(this), _to, _amount);
474     
475     if(totalSupply_ == limit ){
476       finishMinting();
477       return false;
478     }
479     return true;
480   }   
481   
482 
483   /**
484    * @dev Function to stop minting new tokens.
485    * @return True if the operation was successful.
486    */
487   function finishMinting() onlyOwner canMint public returns (bool) {
488     mintingFinished = true;
489     MintFinished();
490     return true;
491   }
492 }
493 
494 contract XTRD is MintableToken, Claimable, Contactable {
495   /*----------- ERC20 GLOBALS -----------*/
496   string public constant name = "XTRD"; 
497   string public constant symbol = "XTRD";
498   uint public constant decimals = 18;
499 
500   /*----------- Ownership Reclaim -----------*/
501   address public reclaimableOwner;
502 
503   /**
504    * @dev Restricts method call to only the address set as `reclaimableOwner`.
505    */
506   modifier onlyReclaimableOwner() {
507       require(msg.sender == reclaimableOwner);
508       _;
509   }
510 
511   /**
512    * @dev Sets the reclaim address to current owner.
513    */
514   function setupReclaim() public onlyOwner {
515       require(reclaimableOwner == address(0));
516 
517       reclaimableOwner = msg.sender;
518   }
519 
520   /**
521    * @dev Resets the reclaim address to address(0).
522    */
523   function resetReclaim() public onlyReclaimableOwner {
524       reclaimableOwner = address(0);
525   }
526 
527   /**
528    * @dev Failsafe to reclaim ownership in the event sale is unable to
529    *      return ownership. Reclaims ownership regardless of
530    *      pending ownership transfer.
531    */
532   function reclaimOwnership() public onlyReclaimableOwner {
533 
534       // Erase any pending transfer.
535       pendingOwner = address(0);
536 
537       // Transfer ownership.
538       OwnershipTransferred(owner, reclaimableOwner);
539       owner = reclaimableOwner;
540 
541       // Reset reclaimableOwner.
542       reclaimableOwner = address(0);
543 
544   }
545 }