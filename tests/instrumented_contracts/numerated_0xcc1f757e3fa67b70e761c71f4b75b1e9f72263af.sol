1 /**
2  *Submitted for verification at Etherscan.io on 2018-11-24
3 */
4 
5 pragma solidity 0.4.24;
6 
7 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * See https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     assert(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     assert(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     assert(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) internal balances;
83 
84   uint256 internal totalSupply_;
85 
86   /**
87   * @dev Total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev Transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_value <= balances[msg.sender]);
100     require(_to != address(0));
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address _owner, address _spender)
127     public view returns (uint256);
128 
129   function transferFrom(address _from, address _to, uint256 _value)
130     public returns (bool);
131 
132   function approve(address _spender, uint256 _value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/issues/20
147  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public
166     returns (bool)
167   {
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170     require(_to != address(0));
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(
201     address _owner,
202     address _spender
203    )
204     public
205     view
206     returns (uint256)
207   {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(
221     address _spender,
222     uint256 _addedValue
223   )
224     public
225     returns (bool)
226   {
227     allowed[msg.sender][_spender] = (
228       allowed[msg.sender][_spender].add(_addedValue));
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseApproval(
243     address _spender,
244     uint256 _subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     uint256 oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue >= oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
262 
263 /**
264  * @title DetailedERC20 token
265  * @dev The decimals are only for visualization purposes.
266  * All the operations are done using the smallest and indivisible token unit,
267  * just as on Ethereum all the operations are done in wei.
268  */
269 contract DetailedERC20 is ERC20 {
270   string public name;
271   string public symbol;
272   uint8 public decimals;
273 
274   constructor(string _name, string _symbol, uint8 _decimals) public {
275     name = _name;
276     symbol = _symbol;
277     decimals = _decimals;
278   }
279 }
280 
281 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of "user permissions".
287  */
288 contract Ownable {
289   address public owner;
290 
291 
292   event OwnershipRenounced(address indexed previousOwner);
293   event OwnershipTransferred(
294     address indexed previousOwner,
295     address indexed newOwner
296   );
297 
298 
299   /**
300    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301    * account.
302    */
303   constructor() public {
304     owner = msg.sender;
305   }
306 
307   /**
308    * @dev Throws if called by any account other than the owner.
309    */
310   modifier onlyOwner() {
311     require(msg.sender == owner);
312     _;
313   }
314 
315   /**
316    * @dev Allows the current owner to relinquish control of the contract.
317    * @notice Renouncing to ownership will leave the contract without an owner.
318    * It will not be possible to call the functions with the `onlyOwner`
319    * modifier anymore.
320    */
321   function renounceOwnership() public onlyOwner {
322     emit OwnershipRenounced(owner);
323     owner = address(0);
324   }
325 
326   /**
327    * @dev Allows the current owner to transfer control of the contract to a newOwner.
328    * @param _newOwner The address to transfer ownership to.
329    */
330   function transferOwnership(address _newOwner) public onlyOwner {
331     _transferOwnership(_newOwner);
332   }
333 
334   /**
335    * @dev Transfers control of the contract to a newOwner.
336    * @param _newOwner The address to transfer ownership to.
337    */
338   function _transferOwnership(address _newOwner) internal {
339     require(_newOwner != address(0));
340     emit OwnershipTransferred(owner, _newOwner);
341     owner = _newOwner;
342   }
343 }
344 
345 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
346 
347 /**
348  * @title Mintable token
349  * @dev Simple ERC20 Token example, with mintable token creation
350  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
351  */
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355 
356   bool public mintingFinished = false;
357 
358 
359   modifier canMint() {
360     require(!mintingFinished);
361     _;
362   }
363 
364   modifier hasMintPermission() {
365     require(msg.sender == owner);
366     _;
367   }
368 
369   /**
370    * @dev Function to mint tokens
371    * @param _to The address that will receive the minted tokens.
372    * @param _amount The amount of tokens to mint.
373    * @return A boolean that indicates if the operation was successful.
374    */
375   function mint(
376     address _to,
377     uint256 _amount
378   )
379     public
380     hasMintPermission
381     canMint
382     returns (bool)
383   {
384     totalSupply_ = totalSupply_.add(_amount);
385     balances[_to] = balances[_to].add(_amount);
386     mintingFinished = true;
387     emit Mint(_to, _amount);
388     emit Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396 /*
397   function finishMinting() public onlyOwner canMint returns (bool) {
398     mintingFinished = true;
399     emit MintFinished();
400     return true;
401   }
402   */
403 }
404 
405 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
406 
407 /**
408  * @title Burnable Token
409  * @dev Token that can be irreversibly burned (destroyed).
410  */
411 contract BurnableToken is BasicToken {
412 
413   event Burn(address indexed burner, uint256 value);
414 
415   /**
416    * @dev Burns a specific amount of tokens.
417    * @param _value The amount of token to be burned.
418    */
419   function burn(uint256 _value) public {
420     _burn(msg.sender, _value);
421   }
422 
423   function _burn(address _who, uint256 _value) internal {
424     require(_value <= balances[_who]);
425     // no need to require value <= totalSupply, since that would imply the
426     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
427 
428     balances[_who] = balances[_who].sub(_value);
429     totalSupply_ = totalSupply_.sub(_value);
430     emit Burn(_who, _value);
431     emit Transfer(_who, address(0), _value);
432   }
433 }
434 
435 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
436 
437 /**
438  * @title Pausable
439  * @dev Base contract which allows children to implement an emergency stop mechanism.
440  */
441 contract Pausable is Ownable {
442   event Pause();
443   event Unpause();
444 
445   bool public paused = false;
446 
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is not paused.
450    */
451   modifier whenNotPaused() {
452     require(!paused);
453     _;
454   }
455 
456   /**
457    * @dev Modifier to make a function callable only when the contract is paused.
458    */
459   modifier whenPaused() {
460     require(paused);
461     _;
462   }
463 
464   /**
465    * @dev called by the owner to pause, triggers stopped state
466    */
467   function pause() public onlyOwner whenNotPaused {
468     paused = true;
469     emit Pause();
470   }
471 
472   /**
473    * @dev called by the owner to unpause, returns to normal state
474    */
475   function unpause() public onlyOwner whenPaused {
476     paused = false;
477     emit Unpause();
478   }
479 }
480 
481 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
482 
483 /**
484  * @title Pausable token
485  * @dev StandardToken modified with pausable transfers.
486  **/
487 contract PausableToken is StandardToken, Pausable {
488 
489   function transfer(
490     address _to,
491     uint256 _value
492   )
493     public
494     whenNotPaused
495     returns (bool)
496   {
497     return super.transfer(_to, _value);
498   }
499 
500   function transferFrom(
501     address _from,
502     address _to,
503     uint256 _value
504   )
505     public
506     whenNotPaused
507     returns (bool)
508   {
509     return super.transferFrom(_from, _to, _value);
510   }
511 
512   function approve(
513     address _spender,
514     uint256 _value
515   )
516     public
517     whenNotPaused
518     returns (bool)
519   {
520     return super.approve(_spender, _value);
521   }
522 
523   function increaseApproval(
524     address _spender,
525     uint _addedValue
526   )
527     public
528     whenNotPaused
529     returns (bool success)
530   {
531     return super.increaseApproval(_spender, _addedValue);
532   }
533 
534   function decreaseApproval(
535     address _spender,
536     uint _subtractedValue
537   )
538     public
539     whenNotPaused
540     returns (bool success)
541   {
542     return super.decreaseApproval(_spender, _subtractedValue);
543   }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
547 
548 /**
549  * @title SafeERC20
550  * @dev Wrappers around ERC20 operations that throw on failure.
551  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
552  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
553  */
554 library SafeERC20 {
555   function safeTransfer(
556     ERC20Basic _token,
557     address _to,
558     uint256 _value
559   )
560     internal
561   {
562     require(_token.transfer(_to, _value));
563   }
564 
565   function safeTransferFrom(
566     ERC20 _token,
567     address _from,
568     address _to,
569     uint256 _value
570   )
571     internal
572   {
573     require(_token.transferFrom(_from, _to, _value));
574   }
575 
576   function safeApprove(
577     ERC20 _token,
578     address _spender,
579     uint256 _value
580   )
581     internal
582   {
583     require(_token.approve(_spender, _value));
584   }
585 }
586 
587 
588 //contract GETT is StandardToken, DetailedERC20("Green Earth community Token", "GETT", 18),
589 //    MintableToken, BurnableToken, PausableToken {
590 
591 contract GET is StandardToken, DetailedERC20("Green Earth community Token", "GET", 18),
592     MintableToken, BurnableToken, PausableToken {
593 
594     function burn(uint value) public onlyOwner {
595         super.burn(value);
596     }
597 
598 /*
599     function finishMinting() public onlyOwner returns (bool) {
600         return false;
601     }
602 */
603     function renounceOwnership() public onlyOwner {
604         revert("renouncing ownership is blocked");
605     }
606 }