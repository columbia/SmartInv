1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
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
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86    //replaced by Claimable
87   // function transferOwnership(address newOwner) public onlyOwner {
88   //   require(newOwner != address(0));
89   //   OwnershipTransferred(owner, newOwner);
90   //   owner = newOwner;
91   // }
92 
93 }
94 
95 
96 
97 
98 /**
99  * @title SafeERC20
100  * @dev Wrappers around ERC20 operations that throw on failure.
101  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
102  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
103  */
104  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/SafeERC20.sol
105 library SafeERC20 {
106   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
107     assert(token.transfer(to, value));
108   }
109 
110   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
111     assert(token.transferFrom(from, to, value));
112   }
113 
114   function safeApprove(ERC20 token, address spender, uint256 value) internal {
115     assert(token.approve(spender, value));
116   }
117 }
118 
119 
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
127 contract ERC20Basic {
128   function totalSupply() public view returns (uint256);
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 
135 
136 
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender) public view returns (uint256);
145   function transferFrom(address from, address to, uint256 value) public returns (bool);
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 
151 
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156   */
157 //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) balances;
162 
163   uint256 totalSupply_;
164 
165   /**
166   * @dev total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 
297 
298 
299 
300 /**
301  * @title Claimable
302  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
303  * This allows the new owner to accept the transfer.
304  */
305  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Claimable.sol
306 contract Claimable is Ownable {
307   address public pendingOwner;
308 
309   /**
310    * @dev Modifier throws if called by any account other than the pendingOwner.
311    */
312   modifier onlyPendingOwner() {
313     require(msg.sender == pendingOwner);
314     _;
315   }
316 
317   /**
318    * @dev Allows the current owner to set the pendingOwner address.
319    * @param newOwner The address to transfer ownership to.
320    */
321   function transferOwnership(address newOwner) onlyOwner public {
322     pendingOwner = newOwner;
323   }
324 
325   /**
326    * @dev Allows the pendingOwner address to finalize the transfer.
327    */
328   function claimOwnership() onlyPendingOwner public {
329     OwnershipTransferred(owner, pendingOwner);
330     owner = pendingOwner;
331     pendingOwner = address(0);
332   }
333 }
334 
335 
336 
337 
338 /**
339  * @title Contracts that should be able to recover tokens
340  * @author SylTi
341  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
342  * This will prevent any accidental loss of tokens.
343  */
344  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/CanReclaimToken.sol
345 contract CanReclaimToken is Ownable {
346   using SafeERC20 for ERC20Basic;
347 
348   /**
349    * @dev Reclaim all ERC20Basic compatible tokens
350    * @param token ERC20Basic The address of the token contract
351    */
352   function reclaimToken(ERC20Basic token) external onlyOwner {
353     uint256 balance = token.balanceOf(this);
354     token.safeTransfer(owner, balance);
355   }
356 
357 }
358 
359 
360 
361 
362 /**
363  * @title Mintable token
364  * @dev Simple ERC20 Token example, with mintable token creation and update of max supply
365  */
366  
367 contract MintableToken is StandardToken, Ownable, Claimable {
368   event Mint(address indexed to, uint256 amount);
369   event MintFinished();
370 
371   bool public mintingFinished = false;
372   uint public maxSupply = 500000000 * (10 ** 18);//Max 500 M Tokens
373 
374 
375   modifier canMint() {
376     require(!mintingFinished);
377     _;
378   }
379 
380   /**
381    * @dev Function to mint tokens
382    * @param _to The address that will receive the minted tokens.
383    * @param _amount The amount of tokens to mint.
384    * @return A boolean that indicates if the operation was successful.
385    */
386   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
387     if (maxSupply < totalSupply_.add(_amount) ) {
388         revert();//Hard cap of 500M mintable tokens
389     }
390 
391     totalSupply_ = totalSupply_.add(_amount);
392     balances[_to] = balances[_to].add(_amount);
393     Mint(_to, _amount);
394     Transfer(address(0), _to, _amount);
395     return true;
396   }
397 
398   /**
399    * @dev Function to stop minting new tokens.
400    * @return True if the operation was successful.
401    */
402   function finishMinting() onlyOwner canMint public returns (bool) {
403     mintingFinished = true;
404     MintFinished();
405     return true;
406   }
407 
408 }
409 
410 
411 
412 /**
413  * @title Contracts that should not own Tokens
414  * @author Remco Bloemen <remco@2π.com>
415  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
416  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
417  * owner to reclaim the tokens.
418  */
419 contract HasNoTokens is CanReclaimToken {
420 
421  /**
422   * @dev Reject all ERC223 compatible tokens
423   * @param from_ address The address that is transferring the tokens
424   * @param value_ uint256 the amount of the specified token
425   * @param data_ Bytes The data passed from the caller.
426   */
427   function tokenFallback(address from_, uint256 value_, bytes data_) external {
428     from_;
429     value_;
430     data_;
431     revert();
432   }
433 
434 }
435 
436 
437 
438 
439 
440 /**
441  * @title Pausable
442  * @dev Base contract which allows children to implement an emergency stop mechanism.
443  */
444  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
445 contract Pausable is Ownable {
446   event Pause();
447   event Unpause();
448 
449   bool public paused = false;
450 
451 
452   /**
453    * @dev Modifier to make a function callable only when the contract is not paused.
454    */
455   modifier whenNotPaused() {
456     require(!paused);
457     _;
458   }
459 
460   /**
461    * @dev Modifier to make a function callable only when the contract is paused.
462    */
463   modifier whenPaused() {
464     require(paused);
465     _;
466   }
467 
468   /**
469    * @dev called by the owner to pause, triggers stopped state
470    */
471   function pause() onlyOwner whenNotPaused public {
472     paused = true;
473     Pause();
474   }
475 
476   /**
477    * @dev called by the owner to unpause, returns to normal state
478    */
479   function unpause() onlyOwner whenPaused public {
480     paused = false;
481     Unpause();
482   }
483 }
484 
485 
486 
487 
488 
489 /**
490  * @title Pausable token
491  * @dev StandardToken modified with pausable transfers.
492  **/
493  //https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/PausableToken.sol
494 contract PausableToken is StandardToken, Pausable {
495 
496   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
497     return super.transfer(_to, _value);
498   }
499 
500   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
501     return super.transferFrom(_from, _to, _value);
502   }
503 
504   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
505     return super.approve(_spender, _value);
506   }
507 
508   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
509     return super.increaseApproval(_spender, _addedValue);
510   }
511 
512   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
513     return super.decreaseApproval(_spender, _subtractedValue);
514   }
515 }
516 
517 
518 
519 
520 // ----------------------------------------------------------------------------
521 // Contracts that can have tokens approved, and then a function executed
522 // ----------------------------------------------------------------------------
523 contract ApproveAndCallFallBack {
524     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
525 }
526 
527 
528 /**
529  * @title SHIPToken
530  */
531  //CanReclaimToken
532 contract SHIPToken is StandardToken, PausableToken, MintableToken, HasNoTokens {
533 
534   string public constant name = "ShipChain SHIP"; 
535   string public constant symbol = "SHIP"; 
536   uint8 public constant decimals = 18; 
537 
538   uint256 public constant INITIAL_SUPPLY = 0 * (10 ** uint256(decimals));
539 
540   /**
541    * @dev Constructor that gives msg.sender all of existing tokens.
542    */
543   function SHIPToken() public {
544     totalSupply_ = INITIAL_SUPPLY;
545     balances[msg.sender] = INITIAL_SUPPLY;
546     maxSupply = 500000000 * (10 ** uint256(decimals));//Max 500 M Tokens
547 
548     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
549   }
550 
551   function approveAndCall(address spender, uint _value, bytes data) public returns (bool success) {
552     approve(spender, _value);
553     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, _value, address(this), data);
554     return true;
555   }
556 }