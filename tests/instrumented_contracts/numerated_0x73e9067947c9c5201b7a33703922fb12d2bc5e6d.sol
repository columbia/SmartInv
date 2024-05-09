1 pragma solidity ^0.4.23;
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
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   uint256 totalSupply_;
27 
28   /**
29   * @dev total number of tokens in existence
30   */
31   function totalSupply() public view returns (uint256) {
32     return totalSupply_;
33   }
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     emit Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   /**
51   * @dev Gets the balance of the specified address.
52   * @param _owner The address to query the the balance of.
53   * @return An uint256 representing the amount owned by the passed address.
54   */
55   function balanceOf(address _owner) public view returns (uint256) {
56     return balances[_owner];
57   }
58 
59 }
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipRenounced(address indexed previousOwner);
71   event OwnershipTransferred(
72     address indexed previousOwner,
73     address indexed newOwner
74   );
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to relinquish control of the contract.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender)
137     public view returns (uint256);
138 
139   function transferFrom(address from, address to, uint256 value)
140     public returns (bool);
141 
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(
171     address _from,
172     address _to,
173     uint256 _value
174   )
175     public
176     returns (bool)
177   {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     emit Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     emit Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(
212     address _owner,
213     address _spender
214    )
215     public
216     view
217     returns (uint256)
218   {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(
233     address _spender,
234     uint _addedValue
235   )
236     public
237     returns (bool)
238   {
239     allowed[msg.sender][_spender] = (
240       allowed[msg.sender][_spender].add(_addedValue));
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(
256     address _spender,
257     uint _subtractedValue
258   )
259     public
260     returns (bool)
261   {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 
275 
276 
277 
278 
279 
280 /**
281  * @title Pausable
282  * @dev Base contract which allows children to implement an emergency stop mechanism.
283  */
284 contract Pausable is Ownable {
285   event Pause();
286   event Unpause();
287 
288   bool public paused = false;
289 
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is not paused.
293    */
294   modifier whenNotPaused() {
295     require(!paused);
296     _;
297   }
298 
299   /**
300    * @dev Modifier to make a function callable only when the contract is paused.
301    */
302   modifier whenPaused() {
303     require(paused);
304     _;
305   }
306 
307   /**
308    * @dev called by the owner to pause, triggers stopped state
309    */
310   function pause() onlyOwner whenNotPaused public {
311     paused = true;
312     emit Pause();
313   }
314 
315   /**
316    * @dev called by the owner to unpause, returns to normal state
317    */
318   function unpause() onlyOwner whenPaused public {
319     paused = false;
320     emit Unpause();
321   }
322 }
323 
324 
325 
326 /**
327  * @title Pausable token
328  * @dev StandardToken modified with pausable transfers.
329  **/
330 contract PausableToken is StandardToken, Pausable {
331 
332   function transfer(
333     address _to,
334     uint256 _value
335   )
336     public
337     whenNotPaused
338     returns (bool)
339   {
340     return super.transfer(_to, _value);
341   }
342 
343   function transferFrom(
344     address _from,
345     address _to,
346     uint256 _value
347   )
348     public
349     whenNotPaused
350     returns (bool)
351   {
352     return super.transferFrom(_from, _to, _value);
353   }
354 
355   function approve(
356     address _spender,
357     uint256 _value
358   )
359     public
360     whenNotPaused
361     returns (bool)
362   {
363     return super.approve(_spender, _value);
364   }
365 
366   function increaseApproval(
367     address _spender,
368     uint _addedValue
369   )
370     public
371     whenNotPaused
372     returns (bool success)
373   {
374     return super.increaseApproval(_spender, _addedValue);
375   }
376 
377   function decreaseApproval(
378     address _spender,
379     uint _subtractedValue
380   )
381     public
382     whenNotPaused
383     returns (bool success)
384   {
385     return super.decreaseApproval(_spender, _subtractedValue);
386   }
387 }
388 
389 
390 
391 
392 
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
399  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
400  */
401 contract MintableToken is StandardToken, Ownable {
402   event Mint(address indexed to, uint256 amount);
403   event MintFinished();
404 
405   bool public mintingFinished = false;
406 
407 
408   modifier canMint() {
409     require(!mintingFinished);
410     _;
411   }
412 
413   modifier hasMintPermission() {
414     require(msg.sender == owner);
415     _;
416   }
417 
418   /**
419    * @dev Function to mint tokens
420    * @param _to The address that will receive the minted tokens.
421    * @param _amount The amount of tokens to mint.
422    * @return A boolean that indicates if the operation was successful.
423    */
424   function mint(
425     address _to,
426     uint256 _amount
427   )
428     hasMintPermission
429     canMint
430     public
431     returns (bool)
432   {
433     totalSupply_ = totalSupply_.add(_amount);
434     balances[_to] = balances[_to].add(_amount);
435     emit Mint(_to, _amount);
436     emit Transfer(address(0), _to, _amount);
437     return true;
438   }
439 
440   /**
441    * @dev Function to stop minting new tokens.
442    * @return True if the operation was successful.
443    */
444   function finishMinting() onlyOwner canMint public returns (bool) {
445     mintingFinished = true;
446     emit MintFinished();
447     return true;
448   }
449 }
450 
451 
452 
453 
454 
455 
456 
457 
458 
459 
460 /**
461  * @title SafeMath
462  * @dev Math operations with safety checks that throw on error
463  */
464 library SafeMath {
465 
466   /**
467   * @dev Multiplies two numbers, throws on overflow.
468   */
469   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
470     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
471     // benefit is lost if 'b' is also tested.
472     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
473     if (a == 0) {
474       return 0;
475     }
476 
477     c = a * b;
478     assert(c / a == b);
479     return c;
480   }
481 
482   /**
483   * @dev Integer division of two numbers, truncating the quotient.
484   */
485   function div(uint256 a, uint256 b) internal pure returns (uint256) {
486     // assert(b > 0); // Solidity automatically throws when dividing by 0
487     // uint256 c = a / b;
488     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
489     return a / b;
490   }
491 
492   /**
493   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
494   */
495   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496     assert(b <= a);
497     return a - b;
498   }
499 
500   /**
501   * @dev Adds two numbers, throws on overflow.
502   */
503   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
504     c = a + b;
505     assert(c >= a);
506     return c;
507   }
508 }
509 
510 /**
511  * @title Burnable Token
512  * @dev Token that can be irreversibly burned (destroyed).
513  */
514 contract BurnableToken is BasicToken {
515 
516   event Burn(address indexed burner, uint256 value);
517 
518   /**
519    * @dev Burns a specific amount of tokens.
520    * @param _value The amount of token to be burned.
521    */
522   function burn(uint256 _value) public {
523     _burn(msg.sender, _value);
524   }
525 
526   function _burn(address _who, uint256 _value) internal {
527     require(_value <= balances[_who]);
528     // no need to require value <= totalSupply, since that would imply the
529     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
530 
531     balances[_who] = balances[_who].sub(_value);
532     totalSupply_ = totalSupply_.sub(_value);
533     emit Burn(_who, _value);
534     emit Transfer(_who, address(0), _value);
535   }
536 }
537 
538 
539 
540 contract GMSToken is PausableToken, MintableToken, BurnableToken {
541     string public name = "Gemstra Token";
542     string public symbol = "GMS";
543     uint public decimals = 18;
544     uint public INITIAL_SUPPLY = 16000000000 * (10 ** uint256(decimals));
545 
546     constructor() public {
547         totalSupply_ = INITIAL_SUPPLY;
548         balances[msg.sender] = INITIAL_SUPPLY;
549         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
550     }
551 }