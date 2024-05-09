1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-11
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57  /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 
117 /**
118  * @title Pausable
119  * @dev Base contract which allows children to implement an emergency stop mechanism.
120  */
121 contract Pausable is Ownable {
122   event Pause();
123   event Unpause();
124 
125   bool public paused = false;
126 
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is not paused.
130    */
131   modifier whenNotPaused() {
132     require(!paused);
133     _;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is paused.
138    */
139   modifier whenPaused() {
140     require(paused);
141     _;
142   }
143 
144   /**
145    * @dev called by the owner to pause, triggers stopped state
146    */
147   function pause() onlyOwner whenNotPaused public {
148     paused = true;
149     emit Pause();
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     emit Unpause();
158   }
159 }
160 
161 
162 /**
163  * @title ERC20Basic
164  * @dev Simpler version of ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/179
166  */
167 contract ERC20Basic {
168   function totalSupply() public view returns (uint256);
169   function balanceOf(address who) public view returns (uint256);
170   function transfer(address to, uint256 value) public returns (bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   uint256 totalSupply_;
185 
186   /**
187   * @dev Total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193   /**
194   * @dev Transfer token for a specified address
195   * @param _to The address to transfer to.
196   * @param _value The amount to be transferred.
197   */
198   function transfer(address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     emit Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param _owner The address to query the the balance of.
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address _owner) public view returns (uint256) {
214     return balances[_owner];
215   }
216 
217 }
218 
219 /**
220  * @title ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/20
222  */
223 contract ERC20 is ERC20Basic {
224   function allowance(address owner, address spender)
225     public view returns (uint256);
226 
227   function transferFrom(address from, address to, uint256 value)
228     public returns (bool);
229 
230   function approve(address spender, uint256 value) public returns (bool);
231   event Approval(
232     address indexed owner,
233     address indexed spender,
234     uint256 value
235   );
236 
237   function () public payable {
238     revert();
239   }
240 }
241 
242 /**
243  * @title Burnable Token
244  * @dev Token that can be irreversibly burned (destroyed).
245  */
246 contract BurnableToken is BasicToken {
247 
248   event Burn(address indexed burner, uint256 value);
249 
250   /**
251    * @dev Burns a specific amount of tokens.
252    * @param _value The amount of token to be burned.
253    */
254   function burn(uint256 _value) public {
255     _burn(msg.sender, _value);
256   }
257 
258   function _burn(address _who, uint256 _value) internal {
259     require(_value <= balances[_who]);
260     // no need to require value <= totalSupply, since that would imply the
261     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263     balances[_who] = balances[_who].sub(_value);
264     totalSupply_ = totalSupply_.sub(_value);
265     emit Burn(_who, _value);
266     emit Transfer(_who, address(0), _value);
267   }
268 }
269 
270 /**
271  * @title Standard ERC20 token
272  *
273  * @dev Implementation of the basic standard token.
274  * @dev https://github.com/ethereum/EIPs/issues/20
275  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
276  */
277 contract StandardToken is ERC20, BasicToken {
278 
279   mapping (address => mapping (address => uint256)) internal allowed;
280 
281 
282   /**
283    * @dev Transfer tokens from one address to another
284    * @param _from address The address which you want to send tokens from
285    * @param _to address The address which you want to transfer to
286    * @param _value uint256 the amount of tokens to be transferred
287    */
288   function transferFrom(
289     address _from,
290     address _to,
291     uint256 _value
292   )
293     public
294 
295     returns (bool)
296   {
297     require(_to != address(0));
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300 
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304     emit Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    *
311    * Beware that changing an allowance with this method brings the risk that someone may use both the old
312    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
313    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
314    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
315    * @param _spender The address which will spend the funds.
316    * @param _value The amount of tokens to be spent.
317    */
318   function approve(address _spender, uint256 _value) public returns (bool) {
319     allowed[msg.sender][_spender] = _value;
320     emit Approval(msg.sender, _spender, _value);
321     return true;
322   }
323 
324   /**
325    * @dev Function to check the amount of tokens that an owner allowed to a spender.
326    * @param _owner address The address which owns the funds.
327    * @param _spender address The address which will spend the funds.
328    * @return A uint256 specifying the amount of tokens still available for the spender.
329    */
330   function allowance(
331     address _owner,
332     address _spender
333    )
334     public
335     view
336     returns (uint256)
337   {
338     return allowed[_owner][_spender];
339   }
340 
341   /**
342    * @dev Increase the amount of tokens that an owner allowed to a spender.
343    *
344    * approve should be called when allowed[_spender] == 0. To increment
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _addedValue The amount of tokens to increase the allowance by.
350    */
351   function increaseApproval(
352     address _spender,
353     uint _addedValue
354   )
355     public
356     returns (bool)
357   {
358     allowed[msg.sender][_spender] = (
359       allowed[msg.sender][_spender].add(_addedValue));
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   /**
365    * @dev Decrease the amount of tokens that an owner allowed to a spender.
366    *
367    * approve should be called when allowed[_spender] == 0. To decrement
368    * allowed value is better to use this function to avoid 2 calls (and wait until
369    * the first transaction is mined)
370    * From MonolithDAO Token.sol
371    * @param _spender The address which will spend the funds.
372    * @param _subtractedValue The amount of tokens to decrease the allowance by.
373    */
374   function decreaseApproval(
375     address _spender,
376     uint _subtractedValue
377   )
378     public
379     returns (bool)
380   {
381     uint oldValue = allowed[msg.sender][_spender];
382     if (_subtractedValue > oldValue) {
383       allowed[msg.sender][_spender] = 0;
384     } else {
385       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
386     }
387     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388     return true;
389   }
390 
391 }
392 
393 /**
394  * @title Mintable token
395  * @dev Simple ERC20 Token example, with mintable token creation
396  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
397  */
398 contract MintableToken is StandardToken, Ownable {
399   event Mint(address indexed to, uint256 amount);
400   event MintFinished();
401 
402   bool public mintingFinished = false;
403 
404 
405   modifier canMint() {
406     require(!mintingFinished);
407     _;
408   }
409 
410   modifier hasMintPermission() {
411     require(msg.sender == owner);
412     _;
413   }
414 
415   /**
416    * @dev Function to mint tokens
417    * @param _to The address that will receive the minted tokens.
418    * @param _amount The amount of tokens to mint.
419    * @return A boolean that indicates if the operation was successful.
420    */
421   function mint(
422     address _to,
423     uint256 _amount
424   )
425     hasMintPermission
426     canMint
427     public
428     returns (bool)
429   {
430     totalSupply_ = totalSupply_.add(_amount);
431     balances[_to] = balances[_to].add(_amount);
432     emit Mint(_to, _amount);
433     emit Transfer(address(0), _to, _amount);
434     return true;
435   }
436 
437   /**
438    * @dev Function to stop minting new tokens.
439    * @return True if the operation was successful.
440    */
441   function finishMinting() onlyOwner canMint public returns (bool) {
442     mintingFinished = true;
443     emit MintFinished();
444     return true;
445   }
446 }
447 
448 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
449 /**
450  * @title Capped token
451  * @dev Mintable token with a token cap.
452  */
453 contract CappedToken is MintableToken {
454 
455   uint256 public cap;
456 
457   constructor(uint256 _cap) public {
458     require(_cap > 0);
459     cap = _cap;
460   }
461 
462   /**
463    * @dev Function to mint tokens
464    * @param _to The address that will receive the minted tokens.
465    * @param _amount The amount of tokens to mint.
466    * @return A boolean that indicates if the operation was successful.
467    */
468   function mint(
469     address _to,
470     uint256 _amount
471   )
472     public
473     returns (bool)
474   {
475     require(totalSupply_.add(_amount) <= cap);
476 
477     return super.mint(_to, _amount);
478   }
479 
480 }
481 
482 /**
483  * @title Pausable token
484  * @dev StandardToken modified with pausable transfers.
485  **/
486 contract PausableToken is StandardToken, Pausable {
487 
488   mapping (address => bool) public frozenAccount;
489   event FrozenFunds(address target, bool frozen);
490     
491   function transfer(
492     address _to,
493     uint256 _value
494   )
495     public
496     whenNotPaused
497     returns (bool)
498   {
499     require(!frozenAccount[msg.sender]); 
500     return super.transfer(_to, _value);
501   }
502 
503   
504   function freezeAccount(address target, bool freeze) onlyOwner public {
505     frozenAccount[target] = freeze;
506     emit FrozenFunds(target, freeze);
507   }
508     
509   function transferFrom(
510     address _from,
511     address _to,
512     uint256 _value
513   )
514     public
515     whenNotPaused
516     returns (bool)
517   {
518 	require(!frozenAccount[_from]);
519     return super.transferFrom(_from, _to, _value);
520   }
521 
522   function approve(
523     address _spender,
524     uint256 _value
525   )
526     public
527     whenNotPaused
528     returns (bool)
529   {
530     return super.approve(_spender, _value);
531   }
532 
533   function increaseApproval(
534     address _spender,
535     uint _addedValue
536   )
537     public
538     whenNotPaused
539     returns (bool success)
540   {
541     return super.increaseApproval(_spender, _addedValue);
542   }
543 
544   function decreaseApproval(
545     address _spender,
546     uint _subtractedValue
547   )
548     public
549     whenNotPaused
550     returns (bool success)
551   {
552     return super.decreaseApproval(_spender, _subtractedValue);
553   }
554 }
555 
556 
557 /**
558  * @title TelomereToken
559  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
560  * Note they can later distribute these tokens as they wish using `transfer` and other
561  * `StandardToken` functions.
562  */
563 contract TelomereToken is PausableToken, CappedToken, BurnableToken {
564     string public name = "TelomereCoin";
565     string public symbol = "DTXY";
566     uint8 public decimals = 18;
567 
568     uint256 constant TOTAL_CAP = 116000000 * (10 ** uint256(decimals));
569 
570     constructor() public CappedToken(TOTAL_CAP) {
571     }
572 }