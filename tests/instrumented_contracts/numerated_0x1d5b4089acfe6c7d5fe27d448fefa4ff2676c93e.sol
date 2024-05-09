1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
139     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
140     // benefit is lost if 'b' is also tested.
141     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142     if (_a == 0) {
143       return 0;
144     }
145 
146     c = _a * _b;
147     assert(c / _a == _b);
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers, truncating the quotient.
153   */
154   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
155     // assert(_b > 0); // Solidity automatically throws when dividing by 0
156     // uint256 c = _a / _b;
157     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
158     return _a / _b;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
165     assert(_b <= _a);
166     return _a - _b;
167   }
168 
169   /**
170   * @dev Adds two numbers, throws on overflow.
171   */
172   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
173     c = _a + _b;
174     assert(c >= _a);
175     return c;
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) internal balances;
189 
190   uint256 internal totalSupply_;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_value <= balances[msg.sender]);
206     require(_to != address(0));
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address _owner, address _spender)
233     public view returns (uint256);
234 
235   function transferFrom(address _from, address _to, uint256 _value)
236     public returns (bool);
237 
238   function approve(address _spender, uint256 _value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
247 
248 /**
249  * @title Standard ERC20 token
250  *
251  * @dev Implementation of the basic standard token.
252  * https://github.com/ethereum/EIPs/issues/20
253  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
254  */
255 contract StandardToken is ERC20, BasicToken {
256 
257   mapping (address => mapping (address => uint256)) internal allowed;
258 
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param _from address The address which you want to send tokens from
263    * @param _to address The address which you want to transfer to
264    * @param _value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address _from,
268     address _to,
269     uint256 _value
270   )
271     public
272     returns (bool)
273   {
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276     require(_to != address(0));
277 
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     emit Transfer(_from, _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     emit Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(
307     address _owner,
308     address _spender
309    )
310     public
311     view
312     returns (uint256)
313   {
314     return allowed[_owner][_spender];
315   }
316 
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(
327     address _spender,
328     uint256 _addedValue
329   )
330     public
331     returns (bool)
332   {
333     allowed[msg.sender][_spender] = (
334       allowed[msg.sender][_spender].add(_addedValue));
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint256 _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint256 oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue >= oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
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
424 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
425 
426 /**
427  * @title Pausable token
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 contract PausableToken is StandardToken, Pausable {
431 
432   function transfer(
433     address _to,
434     uint256 _value
435   )
436     public
437     whenNotPaused
438     returns (bool)
439   {
440     return super.transfer(_to, _value);
441   }
442 
443   function transferFrom(
444     address _from,
445     address _to,
446     uint256 _value
447   )
448     public
449     whenNotPaused
450     returns (bool)
451   {
452     return super.transferFrom(_from, _to, _value);
453   }
454 
455   function approve(
456     address _spender,
457     uint256 _value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.approve(_spender, _value);
464   }
465 
466   function increaseApproval(
467     address _spender,
468     uint _addedValue
469   )
470     public
471     whenNotPaused
472     returns (bool success)
473   {
474     return super.increaseApproval(_spender, _addedValue);
475   }
476 
477   function decreaseApproval(
478     address _spender,
479     uint _subtractedValue
480   )
481     public
482     whenNotPaused
483     returns (bool success)
484   {
485     return super.decreaseApproval(_spender, _subtractedValue);
486   }
487 }
488 
489 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
490 
491 /**
492  * @title DetailedERC20 token
493  * @dev The decimals are only for visualization purposes.
494  * All the operations are done using the smallest and indivisible token unit,
495  * just as on Ethereum all the operations are done in wei.
496  */
497 contract DetailedERC20 is ERC20 {
498   string public name;
499   string public symbol;
500   uint8 public decimals;
501 
502   constructor(string _name, string _symbol, uint8 _decimals) public {
503     name = _name;
504     symbol = _symbol;
505     decimals = _decimals;
506   }
507 }
508 
509 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
510 
511 /**
512  * @title Burnable Token
513  * @dev Token that can be irreversibly burned (destroyed).
514  */
515 contract BurnableToken is BasicToken {
516 
517   event Burn(address indexed burner, uint256 value);
518 
519   /**
520    * @dev Burns a specific amount of tokens.
521    * @param _value The amount of token to be burned.
522    */
523   function burn(uint256 _value) public {
524     _burn(msg.sender, _value);
525   }
526 
527   function _burn(address _who, uint256 _value) internal {
528     require(_value <= balances[_who]);
529     // no need to require value <= totalSupply, since that would imply the
530     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
531 
532     balances[_who] = balances[_who].sub(_value);
533     totalSupply_ = totalSupply_.sub(_value);
534     emit Burn(_who, _value);
535     emit Transfer(_who, address(0), _value);
536   }
537 }
538 
539 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
540 
541 /**
542  * @title Standard Burnable Token
543  * @dev Adds burnFrom method to ERC20 implementations
544  */
545 contract StandardBurnableToken is BurnableToken, StandardToken {
546 
547   /**
548    * @dev Burns a specific amount of tokens from the target address and decrements allowance
549    * @param _from address The address which you want to send tokens from
550    * @param _value uint256 The amount of token to be burned
551    */
552   function burnFrom(address _from, uint256 _value) public {
553     require(_value <= allowed[_from][msg.sender]);
554     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
555     // this function needs to emit an event with the updated approval.
556     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
557     _burn(_from, _value);
558   }
559 }
560 
561 // File: contracts/DefCampStandard.sol
562 
563 /**
564  * @title DefCampStandard
565  * @author https://bit-sentinel.com
566  */
567 contract DefCampStandard is MintableToken, PausableToken, StandardBurnableToken, DetailedERC20 {
568     /**
569      * @dev Initialize the DefCampStandard and transfer the initialBalance to the
570      *      initialAccount.
571      */
572     constructor()
573         DetailedERC20("DefCampStandard", "DEFSTA", 18)
574         public
575     {
576         totalSupply_ = 50;
577         balances[msg.sender] = 50;
578         emit Transfer(address(0), msg.sender, 50);
579     }
580 }