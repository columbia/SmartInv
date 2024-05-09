1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   constructor() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to relinquish control of the contract.
181    */
182   function renounceOwnership() public onlyOwner {
183     emit OwnershipRenounced(owner);
184     owner = address(0);
185   }
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param _newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address _newOwner) public onlyOwner {
192     _transferOwnership(_newOwner);
193   }
194 
195   /**
196    * @dev Transfers control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function _transferOwnership(address _newOwner) internal {
200     require(_newOwner != address(0));
201     emit OwnershipTransferred(owner, _newOwner);
202     owner = _newOwner;
203   }
204 }
205 
206 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
228 
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(
248     address _from,
249     address _to,
250     uint256 _value
251   )
252     public
253     returns (bool)
254   {
255     require(_to != address(0));
256     require(_value <= balances[_from]);
257     require(_value <= allowed[_from][msg.sender]);
258 
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
268    *
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param _spender The address which will spend the funds.
274    * @param _value The amount of tokens to be spent.
275    */
276   function approve(address _spender, uint256 _value) public returns (bool) {
277     allowed[msg.sender][_spender] = _value;
278     emit Approval(msg.sender, _spender, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Function to check the amount of tokens that an owner allowed to a spender.
284    * @param _owner address The address which owns the funds.
285    * @param _spender address The address which will spend the funds.
286    * @return A uint256 specifying the amount of tokens still available for the spender.
287    */
288   function allowance(
289     address _owner,
290     address _spender
291    )
292     public
293     view
294     returns (uint256)
295   {
296     return allowed[_owner][_spender];
297   }
298 
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    *
302    * approve should be called when allowed[_spender] == 0. To increment
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _addedValue The amount of tokens to increase the allowance by.
308    */
309   function increaseApproval(
310     address _spender,
311     uint _addedValue
312   )
313     public
314     returns (bool)
315   {
316     allowed[msg.sender][_spender] = (
317       allowed[msg.sender][_spender].add(_addedValue));
318     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Decrease the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue > oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349 }
350 
351 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
357  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
358  */
359 contract MintableToken is StandardToken, Ownable {
360   event Mint(address indexed to, uint256 amount);
361   event MintFinished();
362 
363   bool public mintingFinished = false;
364 
365 
366   modifier canMint() {
367     require(!mintingFinished);
368     _;
369   }
370 
371   modifier hasMintPermission() {
372     require(msg.sender == owner);
373     _;
374   }
375 
376   /**
377    * @dev Function to mint tokens
378    * @param _to The address that will receive the minted tokens.
379    * @param _amount The amount of tokens to mint.
380    * @return A boolean that indicates if the operation was successful.
381    */
382   function mint(
383     address _to,
384     uint256 _amount
385   )
386     hasMintPermission
387     canMint
388     public
389     returns (bool)
390   {
391     totalSupply_ = totalSupply_.add(_amount);
392     balances[_to] = balances[_to].add(_amount);
393     emit Mint(_to, _amount);
394     emit Transfer(address(0), _to, _amount);
395     return true;
396   }
397 
398   /**
399    * @dev Function to stop minting new tokens.
400    * @return True if the operation was successful.
401    */
402   function finishMinting() onlyOwner canMint public returns (bool) {
403     mintingFinished = true;
404     emit MintFinished();
405     return true;
406   }
407 }
408 
409 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
410 
411 /**
412  * @title Capped token
413  * @dev Mintable token with a token cap.
414  */
415 contract CappedToken is MintableToken {
416 
417   uint256 public cap;
418 
419   constructor(uint256 _cap) public {
420     require(_cap > 0);
421     cap = _cap;
422   }
423 
424   /**
425    * @dev Function to mint tokens
426    * @param _to The address that will receive the minted tokens.
427    * @param _amount The amount of tokens to mint.
428    * @return A boolean that indicates if the operation was successful.
429    */
430   function mint(
431     address _to,
432     uint256 _amount
433   )
434     onlyOwner
435     canMint
436     public
437     returns (bool)
438   {
439     require(totalSupply_.add(_amount) <= cap);
440 
441     return super.mint(_to, _amount);
442   }
443 
444 }
445 
446 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
447 
448 /**
449  * @title Pausable
450  * @dev Base contract which allows children to implement an emergency stop mechanism.
451  */
452 contract Pausable is Ownable {
453   event Pause();
454   event Unpause();
455 
456   bool public paused = false;
457 
458 
459   /**
460    * @dev Modifier to make a function callable only when the contract is not paused.
461    */
462   modifier whenNotPaused() {
463     require(!paused);
464     _;
465   }
466 
467   /**
468    * @dev Modifier to make a function callable only when the contract is paused.
469    */
470   modifier whenPaused() {
471     require(paused);
472     _;
473   }
474 
475   /**
476    * @dev called by the owner to pause, triggers stopped state
477    */
478   function pause() onlyOwner whenNotPaused public {
479     paused = true;
480     emit Pause();
481   }
482 
483   /**
484    * @dev called by the owner to unpause, returns to normal state
485    */
486   function unpause() onlyOwner whenPaused public {
487     paused = false;
488     emit Unpause();
489   }
490 }
491 
492 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
493 
494 /**
495  * @title Pausable token
496  * @dev StandardToken modified with pausable transfers.
497  **/
498 contract PausableToken is StandardToken, Pausable {
499 
500   function transfer(
501     address _to,
502     uint256 _value
503   )
504     public
505     whenNotPaused
506     returns (bool)
507   {
508     return super.transfer(_to, _value);
509   }
510 
511   function transferFrom(
512     address _from,
513     address _to,
514     uint256 _value
515   )
516     public
517     whenNotPaused
518     returns (bool)
519   {
520     return super.transferFrom(_from, _to, _value);
521   }
522 
523   function approve(
524     address _spender,
525     uint256 _value
526   )
527     public
528     whenNotPaused
529     returns (bool)
530   {
531     return super.approve(_spender, _value);
532   }
533 
534   function increaseApproval(
535     address _spender,
536     uint _addedValue
537   )
538     public
539     whenNotPaused
540     returns (bool success)
541   {
542     return super.increaseApproval(_spender, _addedValue);
543   }
544 
545   function decreaseApproval(
546     address _spender,
547     uint _subtractedValue
548   )
549     public
550     whenNotPaused
551     returns (bool success)
552   {
553     return super.decreaseApproval(_spender, _subtractedValue);
554   }
555 }
556 
557 // File: contracts/HotToken.sol
558 
559 contract HotToken is CappedToken, PausableToken, BurnableToken {
560     string public name = "Time Gold Chain";
561     string public symbol = "TGC";
562     uint8 public decimals = 18;
563 
564     uint public INITIAL_SUPPLY = 20 * 10000 * 10000 * (10 ** uint256(decimals));
565 
566     uint256 public constant MAX_SUPPLY = 20 * 10000 * 10000 * (10 ** uint256(decimals));
567     constructor() CappedToken(MAX_SUPPLY) public {
568       totalSupply_ = INITIAL_SUPPLY;
569       balances[msg.sender] = INITIAL_SUPPLY;
570     }
571 
572     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
573          return super.mint(_to, _amount);
574     }
575 
576     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
577         return super.finishMinting();
578     }
579 
580     function burn(uint256 _value) onlyOwner whenNotPaused public {
581         super.burn(_value);
582     }
583 
584     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
585         super.transferOwnership(newOwner);
586     }
587 
588     function renounceOwnership() onlyOwner whenNotPaused public {
589       super.renounceOwnership();
590     }
591 
592     function() payable public {
593         revert();
594     }
595 }