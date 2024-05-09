1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295 
296   /**
297    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298    * account.
299    */
300   constructor() public {
301     owner = msg.sender;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312   /**
313    * @dev Allows the current owner to relinquish control of the contract.
314    * @notice Renouncing to ownership will leave the contract without an owner.
315    * It will not be possible to call the functions with the `onlyOwner`
316    * modifier anymore.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
343 
344 pragma solidity ^0.4.24;
345 
346 
347 
348 /**
349  * @title Pausable
350  * @dev Base contract which allows children to implement an emergency stop mechanism.
351  */
352 contract Pausable is Ownable {
353   event Pause();
354   event Unpause();
355 
356   bool public paused = false;
357 
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is not paused.
361    */
362   modifier whenNotPaused() {
363     require(!paused);
364     _;
365   }
366 
367   /**
368    * @dev Modifier to make a function callable only when the contract is paused.
369    */
370   modifier whenPaused() {
371     require(paused);
372     _;
373   }
374 
375   /**
376    * @dev called by the owner to pause, triggers stopped state
377    */
378   function pause() onlyOwner whenNotPaused public {
379     paused = true;
380     emit Pause();
381   }
382 
383   /**
384    * @dev called by the owner to unpause, returns to normal state
385    */
386   function unpause() onlyOwner whenPaused public {
387     paused = false;
388     emit Unpause();
389   }
390 }
391 
392 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
393 
394 pragma solidity ^0.4.24;
395 
396 
397 
398 
399 /**
400  * @title Pausable token
401  * @dev StandardToken modified with pausable transfers.
402  **/
403 contract PausableToken is StandardToken, Pausable {
404 
405   function transfer(
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transfer(_to, _value);
414   }
415 
416   function transferFrom(
417     address _from,
418     address _to,
419     uint256 _value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428   function approve(
429     address _spender,
430     uint256 _value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.approve(_spender, _value);
437   }
438 
439   function increaseApproval(
440     address _spender,
441     uint _addedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.increaseApproval(_spender, _addedValue);
448   }
449 
450   function decreaseApproval(
451     address _spender,
452     uint _subtractedValue
453   )
454     public
455     whenNotPaused
456     returns (bool success)
457   {
458     return super.decreaseApproval(_spender, _subtractedValue);
459   }
460 }
461 
462 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
463 
464 pragma solidity ^0.4.24;
465 
466 
467 
468 /**
469  * @title Burnable Token
470  * @dev Token that can be irreversibly burned (destroyed).
471  */
472 contract BurnableToken is BasicToken {
473 
474   event Burn(address indexed burner, uint256 value);
475 
476   /**
477    * @dev Burns a specific amount of tokens.
478    * @param _value The amount of token to be burned.
479    */
480   function burn(uint256 _value) public {
481     _burn(msg.sender, _value);
482   }
483 
484   function _burn(address _who, uint256 _value) internal {
485     require(_value <= balances[_who]);
486     // no need to require value <= totalSupply, since that would imply the
487     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
488 
489     balances[_who] = balances[_who].sub(_value);
490     totalSupply_ = totalSupply_.sub(_value);
491     emit Burn(_who, _value);
492     emit Transfer(_who, address(0), _value);
493   }
494 }
495 
496 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
497 
498 pragma solidity ^0.4.24;
499 
500 
501 
502 
503 /**
504  * @title Mintable token
505  * @dev Simple ERC20 Token example, with mintable token creation
506  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
507  */
508 contract MintableToken is StandardToken, Ownable {
509   event Mint(address indexed to, uint256 amount);
510   event MintFinished();
511 
512   bool public mintingFinished = false;
513 
514 
515   modifier canMint() {
516     require(!mintingFinished);
517     _;
518   }
519 
520   modifier hasMintPermission() {
521     require(msg.sender == owner);
522     _;
523   }
524 
525   /**
526    * @dev Function to mint tokens
527    * @param _to The address that will receive the minted tokens.
528    * @param _amount The amount of tokens to mint.
529    * @return A boolean that indicates if the operation was successful.
530    */
531   function mint(
532     address _to,
533     uint256 _amount
534   )
535     hasMintPermission
536     canMint
537     public
538     returns (bool)
539   {
540     totalSupply_ = totalSupply_.add(_amount);
541     balances[_to] = balances[_to].add(_amount);
542     emit Mint(_to, _amount);
543     emit Transfer(address(0), _to, _amount);
544     return true;
545   }
546 
547   /**
548    * @dev Function to stop minting new tokens.
549    * @return True if the operation was successful.
550    */
551   function finishMinting() onlyOwner canMint public returns (bool) {
552     mintingFinished = true;
553     emit MintFinished();
554     return true;
555   }
556 }
557 
558 // File: contracts/EMPCToken.sol
559 
560 pragma solidity ^0.4.24;
561 
562 
563 
564 
565 
566 contract EMPCToken is PausableToken, MintableToken, BurnableToken {
567     string public name = "EmpireCash";
568     string public symbol = "EMPC";
569     uint public decimals = 18;
570     uint public INITIAL_SUPPLY = 1350000000 * (10 ** uint256(decimals));
571 
572     constructor() public {
573         totalSupply_ = INITIAL_SUPPLY;
574         balances[msg.sender] = INITIAL_SUPPLY;
575         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
576     }
577 }