1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * See https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74   function totalSupply() public view returns (uint256);
75   function balanceOf(address _who) public view returns (uint256);
76   function transfer(address _to, uint256 _value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 
81 
82 
83 
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
96     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (_a == 0) {
100       return 0;
101     }
102 
103     c = _a * _b;
104     assert(c / _a == _b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
112     // assert(_b > 0); // Solidity automatically throws when dividing by 0
113     // uint256 c = _a / _b;
114     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
115     return _a / _b;
116   }
117 
118   /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
122     assert(_b <= _a);
123     return _a - _b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
130     c = _a + _b;
131     assert(c >= _a);
132     return c;
133   }
134 }
135 
136 
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) internal balances;
146 
147   uint256 internal totalSupply_;
148 
149   /**
150   * @dev Total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157   * @dev Transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_value <= balances[msg.sender]);
163     require(_to != address(0));
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     emit Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 
183 
184 
185 
186 
187 
188 
189 /**
190  * @title ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/20
192  */
193 contract ERC20 is ERC20Basic {
194   function allowance(address _owner, address _spender)
195     public view returns (uint256);
196 
197   function transferFrom(address _from, address _to, uint256 _value)
198     public returns (bool);
199 
200   function approve(address _spender, uint256 _value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 
209 
210 /**
211  * @title Standard ERC20 token
212  *
213  * @dev Implementation of the basic standard token.
214  * https://github.com/ethereum/EIPs/issues/20
215  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
216  */
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238     require(_to != address(0));
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address _owner,
270     address _spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(
289     address _spender,
290     uint256 _addedValue
291   )
292     public
293     returns (bool)
294   {
295     allowed[msg.sender][_spender] = (
296       allowed[msg.sender][_spender].add(_addedValue));
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(
311     address _spender,
312     uint256 _subtractedValue
313   )
314     public
315     returns (bool)
316   {
317     uint256 oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue >= oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327 }
328 
329 
330 
331 
332 
333 
334 
335 /**
336  * @title Burnable Token
337  * @dev Token that can be irreversibly burned (destroyed).
338  */
339 contract BurnableToken is BasicToken {
340 
341   event Burn(address indexed burner, uint256 value);
342 
343   /**
344    * @dev Burns a specific amount of tokens.
345    * @param _value The amount of token to be burned.
346    */
347   function burn(uint256 _value) public {
348     _burn(msg.sender, _value);
349   }
350 
351   function _burn(address _who, uint256 _value) internal {
352     require(_value <= balances[_who]);
353     // no need to require value <= totalSupply, since that would imply the
354     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
355 
356     balances[_who] = balances[_who].sub(_value);
357     totalSupply_ = totalSupply_.sub(_value);
358     emit Burn(_who, _value);
359     emit Transfer(_who, address(0), _value);
360   }
361 }
362 
363 
364 
365 
366 
367 
368 
369 /**
370  * @title Mintable token
371  * @dev Simple ERC20 Token example, with mintable token creation
372  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
373  */
374 contract MintableToken is StandardToken, Ownable {
375   event Mint(address indexed to, uint256 amount);
376   event MintFinished();
377 
378   bool public mintingFinished = false;
379 
380 
381   modifier canMint() {
382     require(!mintingFinished);
383     _;
384   }
385 
386   modifier hasMintPermission() {
387     require(msg.sender == owner);
388     _;
389   }
390 
391   /**
392    * @dev Function to mint tokens
393    * @param _to The address that will receive the minted tokens.
394    * @param _amount The amount of tokens to mint.
395    * @return A boolean that indicates if the operation was successful.
396    */
397   function mint(
398     address _to,
399     uint256 _amount
400   )
401     public
402     hasMintPermission
403     canMint
404     returns (bool)
405   {
406     totalSupply_ = totalSupply_.add(_amount);
407     balances[_to] = balances[_to].add(_amount);
408     emit Mint(_to, _amount);
409     emit Transfer(address(0), _to, _amount);
410     return true;
411   }
412 
413   /**
414    * @dev Function to stop minting new tokens.
415    * @return True if the operation was successful.
416    */
417   function finishMinting() public onlyOwner canMint returns (bool) {
418     mintingFinished = true;
419     emit MintFinished();
420     return true;
421   }
422 }
423 
424 
425 
426 
427 
428 
429 
430 
431 
432 
433 /**
434  * @title Pausable
435  * @dev Base contract which allows children to implement an emergency stop mechanism.
436  */
437 contract Pausable is Ownable {
438   event Pause();
439   event Unpause();
440 
441   bool public paused = false;
442 
443 
444   /**
445    * @dev Modifier to make a function callable only when the contract is not paused.
446    */
447   modifier whenNotPaused() {
448     require(!paused);
449     _;
450   }
451 
452   /**
453    * @dev Modifier to make a function callable only when the contract is paused.
454    */
455   modifier whenPaused() {
456     require(paused);
457     _;
458   }
459 
460   /**
461    * @dev called by the owner to pause, triggers stopped state
462    */
463   function pause() public onlyOwner whenNotPaused {
464     paused = true;
465     emit Pause();
466   }
467 
468   /**
469    * @dev called by the owner to unpause, returns to normal state
470    */
471   function unpause() public onlyOwner whenPaused {
472     paused = false;
473     emit Unpause();
474   }
475 }
476 
477 
478 
479 /**
480  * @title Pausable token
481  * @dev StandardToken modified with pausable transfers.
482  **/
483 contract PausableToken is StandardToken, Pausable {
484 
485   function transfer(
486     address _to,
487     uint256 _value
488   )
489     public
490     whenNotPaused
491     returns (bool)
492   {
493     return super.transfer(_to, _value);
494   }
495 
496   function transferFrom(
497     address _from,
498     address _to,
499     uint256 _value
500   )
501     public
502     whenNotPaused
503     returns (bool)
504   {
505     return super.transferFrom(_from, _to, _value);
506   }
507 
508   function approve(
509     address _spender,
510     uint256 _value
511   )
512     public
513     whenNotPaused
514     returns (bool)
515   {
516     return super.approve(_spender, _value);
517   }
518 
519   function increaseApproval(
520     address _spender,
521     uint _addedValue
522   )
523     public
524     whenNotPaused
525     returns (bool success)
526   {
527     return super.increaseApproval(_spender, _addedValue);
528   }
529 
530   function decreaseApproval(
531     address _spender,
532     uint _subtractedValue
533   )
534     public
535     whenNotPaused
536     returns (bool success)
537   {
538     return super.decreaseApproval(_spender, _subtractedValue);
539   }
540 }
541 
542 
543 
544 
545 
546 
547 /**
548  * @title DetailedERC20 token
549  * @dev The decimals are only for visualization purposes.
550  * All the operations are done using the smallest and indivisible token unit,
551  * just as on Ethereum all the operations are done in wei.
552  */
553 contract DetailedERC20 is ERC20 {
554   string public name;
555   string public symbol;
556   uint8 public decimals;
557 
558   constructor(string _name, string _symbol, uint8 _decimals) public {
559     name = _name;
560     symbol = _symbol;
561     decimals = _decimals;
562   }
563 }
564 
565 
566 contract IFEXToken is BurnableToken, MintableToken, PausableToken, DetailedERC20 {
567     event MintReopend();
568 
569     constructor() public DetailedERC20('Internet FinTech Exchange Coin', 'IFEX', 18) {
570         totalSupply_ = 1 * 10 ** 9 * 1 ether;
571         balances[msg.sender] = totalSupply_;
572     }
573 
574     function reopenMint() public onlyOwner returns (bool) {
575       mintingFinished = false;
576       emit MintReopend();
577       return true;
578   }
579 }