1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53  /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 
113 /**
114  * @title Pausable
115  * @dev Base contract which allows children to implement an emergency stop mechanism.
116  */
117 contract Pausable is Ownable {
118   event Pause();
119   event Unpause();
120 
121   bool public paused = false;
122 
123 
124   /**
125    * @dev Modifier to make a function callable only when the contract is not paused.
126    */
127   modifier whenNotPaused() {
128     require(!paused);
129     _;
130   }
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is paused.
134    */
135   modifier whenPaused() {
136     require(paused);
137     _;
138   }
139 
140   /**
141    * @dev called by the owner to pause, triggers stopped state
142    */
143   function pause() onlyOwner whenNotPaused public {
144     paused = true;
145     emit Pause();
146   }
147 
148   /**
149    * @dev called by the owner to unpause, returns to normal state
150    */
151   function unpause() onlyOwner whenPaused public {
152     paused = false;
153     emit Unpause();
154   }
155 }
156 
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   function totalSupply() public view returns (uint256);
165   function balanceOf(address who) public view returns (uint256);
166   function transfer(address to, uint256 value) public returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 
171 /**
172  * @title Basic token
173  * @dev Basic version of StandardToken, with no allowances.
174  */
175 contract BasicToken is ERC20Basic {
176   using SafeMath for uint256;
177 
178   mapping(address => uint256) balances;
179 
180   uint256 totalSupply_;
181 
182   /**
183   * @dev Total number of tokens in existence
184   */
185   function totalSupply() public view returns (uint256) {
186     return totalSupply_;
187   }
188 
189   /**
190   * @dev Transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[msg.sender]);
197 
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     emit Transfer(msg.sender, _to, _value);
201     return true;
202   }
203 
204   /**
205   * @dev Gets the balance of the specified address.
206   * @param _owner The address to query the the balance of.
207   * @return An uint256 representing the amount owned by the passed address.
208   */
209   function balanceOf(address _owner) public view returns (uint256) {
210     return balances[_owner];
211   }
212 
213 }
214 
215 /**
216  * @title ERC20 interface
217  * @dev see https://github.com/ethereum/EIPs/issues/20
218  */
219 contract ERC20 is ERC20Basic {
220   function allowance(address owner, address spender)
221     public view returns (uint256);
222 
223   function transferFrom(address from, address to, uint256 value)
224     public returns (bool);
225 
226   function approve(address spender, uint256 value) public returns (bool);
227   event Approval(
228     address indexed owner,
229     address indexed spender,
230     uint256 value
231   );
232 
233   function () public payable {
234     revert();
235   }
236 }
237 
238 /**
239  * @title Burnable Token
240  * @dev Token that can be irreversibly burned (destroyed).
241  */
242 contract BurnableToken is BasicToken {
243 
244   event Burn(address indexed burner, uint256 value);
245 
246   /**
247    * @dev Burns a specific amount of tokens.
248    * @param _value The amount of token to be burned.
249    */
250   function burn(uint256 _value) public {
251     _burn(msg.sender, _value);
252   }
253 
254   function _burn(address _who, uint256 _value) internal {
255     require(_value <= balances[_who]);
256     // no need to require value <= totalSupply, since that would imply the
257     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258 
259     balances[_who] = balances[_who].sub(_value);
260     totalSupply_ = totalSupply_.sub(_value);
261     emit Burn(_who, _value);
262     emit Transfer(_who, address(0), _value);
263   }
264 }
265 
266 /**
267  * @title Standard ERC20 token
268  *
269  * @dev Implementation of the basic standard token.
270  * @dev https://github.com/ethereum/EIPs/issues/20
271  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
272  */
273 contract StandardToken is ERC20, BasicToken {
274 
275   mapping (address => mapping (address => uint256)) internal allowed;
276 
277 
278   /**
279    * @dev Transfer tokens from one address to another
280    * @param _from address The address which you want to send tokens from
281    * @param _to address The address which you want to transfer to
282    * @param _value uint256 the amount of tokens to be transferred
283    */
284   function transferFrom(
285     address _from,
286     address _to,
287     uint256 _value
288   )
289     public
290 
291     returns (bool)
292   {
293     require(_to != address(0));
294     require(_value <= balances[_from]);
295     require(_value <= allowed[_from][msg.sender]);
296 
297     balances[_from] = balances[_from].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300     emit Transfer(_from, _to, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306    *
307    * Beware that changing an allowance with this method brings the risk that someone may use both the old
308    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311    * @param _spender The address which will spend the funds.
312    * @param _value The amount of tokens to be spent.
313    */
314   function approve(address _spender, uint256 _value) public returns (bool) {
315     allowed[msg.sender][_spender] = _value;
316     emit Approval(msg.sender, _spender, _value);
317     return true;
318   }
319 
320   /**
321    * @dev Function to check the amount of tokens that an owner allowed to a spender.
322    * @param _owner address The address which owns the funds.
323    * @param _spender address The address which will spend the funds.
324    * @return A uint256 specifying the amount of tokens still available for the spender.
325    */
326   function allowance(
327     address _owner,
328     address _spender
329    )
330     public
331     view
332     returns (uint256)
333   {
334     return allowed[_owner][_spender];
335   }
336 
337   /**
338    * @dev Increase the amount of tokens that an owner allowed to a spender.
339    *
340    * approve should be called when allowed[_spender] == 0. To increment
341    * allowed value is better to use this function to avoid 2 calls (and wait until
342    * the first transaction is mined)
343    * From MonolithDAO Token.sol
344    * @param _spender The address which will spend the funds.
345    * @param _addedValue The amount of tokens to increase the allowance by.
346    */
347   function increaseApproval(
348     address _spender,
349     uint _addedValue
350   )
351     public
352     returns (bool)
353   {
354     allowed[msg.sender][_spender] = (
355       allowed[msg.sender][_spender].add(_addedValue));
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360   /**
361    * @dev Decrease the amount of tokens that an owner allowed to a spender.
362    *
363    * approve should be called when allowed[_spender] == 0. To decrement
364    * allowed value is better to use this function to avoid 2 calls (and wait until
365    * the first transaction is mined)
366    * From MonolithDAO Token.sol
367    * @param _spender The address which will spend the funds.
368    * @param _subtractedValue The amount of tokens to decrease the allowance by.
369    */
370   function decreaseApproval(
371     address _spender,
372     uint _subtractedValue
373   )
374     public
375     returns (bool)
376   {
377     uint oldValue = allowed[msg.sender][_spender];
378     if (_subtractedValue > oldValue) {
379       allowed[msg.sender][_spender] = 0;
380     } else {
381       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
382     }
383     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386 
387 }
388 
389 /**
390  * @title Mintable token
391  * @dev Simple ERC20 Token example, with mintable token creation
392  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
393  */
394 contract MintableToken is StandardToken, Ownable {
395   event Mint(address indexed to, uint256 amount);
396   event MintFinished();
397 
398   bool public mintingFinished = false;
399 
400 
401   modifier canMint() {
402     require(!mintingFinished);
403     _;
404   }
405 
406   modifier hasMintPermission() {
407     require(msg.sender == owner);
408     _;
409   }
410 
411   /**
412    * @dev Function to mint tokens
413    * @param _to The address that will receive the minted tokens.
414    * @param _amount The amount of tokens to mint.
415    * @return A boolean that indicates if the operation was successful.
416    */
417   function mint(
418     address _to,
419     uint256 _amount
420   )
421     hasMintPermission
422     canMint
423     public
424     returns (bool)
425   {
426     totalSupply_ = totalSupply_.add(_amount);
427     balances[_to] = balances[_to].add(_amount);
428     emit Mint(_to, _amount);
429     emit Transfer(address(0), _to, _amount);
430     return true;
431   }
432 
433   /**
434    * @dev Function to stop minting new tokens.
435    * @return True if the operation was successful.
436    */
437   function finishMinting() onlyOwner canMint public returns (bool) {
438     mintingFinished = true;
439     emit MintFinished();
440     return true;
441   }
442 }
443 
444 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
445 /**
446  * @title Capped token
447  * @dev Mintable token with a token cap.
448  */
449 contract CappedToken is MintableToken {
450 
451   uint256 public cap;
452 
453   constructor(uint256 _cap) public {
454     require(_cap > 0);
455     cap = _cap;
456   }
457 
458   /**
459    * @dev Function to mint tokens
460    * @param _to The address that will receive the minted tokens.
461    * @param _amount The amount of tokens to mint.
462    * @return A boolean that indicates if the operation was successful.
463    */
464   function mint(
465     address _to,
466     uint256 _amount
467   )
468     public
469     returns (bool)
470   {
471     require(totalSupply_.add(_amount) <= cap);
472 
473     return super.mint(_to, _amount);
474   }
475 
476 }
477 
478 /**
479  * @title Pausable token
480  * @dev StandardToken modified with pausable transfers.
481  **/
482 contract PausableToken is StandardToken, Pausable {
483 
484   function transfer(
485     address _to,
486     uint256 _value
487   )
488     public
489     whenNotPaused
490     returns (bool)
491   {
492     return super.transfer(_to, _value);
493   }
494 
495   function transferFrom(
496     address _from,
497     address _to,
498     uint256 _value
499   )
500     public
501     whenNotPaused
502     returns (bool)
503   {
504     return super.transferFrom(_from, _to, _value);
505   }
506 
507   function approve(
508     address _spender,
509     uint256 _value
510   )
511     public
512     whenNotPaused
513     returns (bool)
514   {
515     return super.approve(_spender, _value);
516   }
517 
518   function increaseApproval(
519     address _spender,
520     uint _addedValue
521   )
522     public
523     whenNotPaused
524     returns (bool success)
525   {
526     return super.increaseApproval(_spender, _addedValue);
527   }
528 
529   function decreaseApproval(
530     address _spender,
531     uint _subtractedValue
532   )
533     public
534     whenNotPaused
535     returns (bool success)
536   {
537     return super.decreaseApproval(_spender, _subtractedValue);
538   }
539 }
540 
541 
542 /**
543  * @title TelomereToken
544  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
545  * Note they can later distribute these tokens as they wish using `transfer` and other
546  * `StandardToken` functions.
547  */
548 contract TelomereToken is PausableToken, CappedToken, BurnableToken {
549     string public name = "TelomereCoin";
550     string public symbol = "TXY";
551     uint8 public decimals = 18;
552 
553     uint256 constant TOTAL_CAP = 116000000 * (10 ** uint256(decimals));
554 
555     constructor() public CappedToken(TOTAL_CAP) {
556     }
557 }