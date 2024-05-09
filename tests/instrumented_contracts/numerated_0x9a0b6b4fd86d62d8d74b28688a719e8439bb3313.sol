1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32   function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
44 
45 pragma solidity ^0.4.23;
46 
47 
48 
49 /**
50  * @title DetailedERC20 token
51  * @dev The decimals are only for visualization purposes.
52  * All the operations are done using the smallest and indivisible token unit,
53  * just as on Ethereum all the operations are done in wei.
54  */
55 contract DetailedERC20 is ERC20 {
56   string public name;
57   string public symbol;
58   uint8 public decimals;
59 
60   constructor(string _name, string _symbol, uint8 _decimals) public {
61     name = _name;
62     symbol = _symbol;
63     decimals = _decimals;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 pragma solidity ^0.4.23;
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (a == 0) {
86       return 0;
87     }
88 
89     c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     // uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return a / b;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
116     c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
123 
124 pragma solidity ^0.4.23;
125 
126 
127 
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139 
140   /**
141   * @dev total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256) {
168     return balances[_owner];
169   }
170 
171 }
172 
173 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
174 
175 pragma solidity ^0.4.23;
176 
177 
178 
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address _from,
200     address _to,
201     uint256 _value
202   )
203     public
204     returns (bool)
205   {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     emit Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     emit Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(
240     address _owner,
241     address _spender
242    )
243     public
244     view
245     returns (uint256)
246   {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(
261     address _spender,
262     uint _addedValue
263   )
264     public
265     returns (bool)
266   {
267     allowed[msg.sender][_spender] = (
268       allowed[msg.sender][_spender].add(_addedValue));
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
283   function decreaseApproval(
284     address _spender,
285     uint _subtractedValue
286   )
287     public
288     returns (bool)
289   {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
303 
304 pragma solidity ^0.4.23;
305 
306 
307 /**
308  * @title Ownable
309  * @dev The Ownable contract has an owner address, and provides basic authorization control
310  * functions, this simplifies the implementation of "user permissions".
311  */
312 contract Ownable {
313   address public owner;
314 
315 
316   event OwnershipRenounced(address indexed previousOwner);
317   event OwnershipTransferred(
318     address indexed previousOwner,
319     address indexed newOwner
320   );
321 
322 
323   /**
324    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
325    * account.
326    */
327   constructor() public {
328     owner = msg.sender;
329   }
330 
331   /**
332    * @dev Throws if called by any account other than the owner.
333    */
334   modifier onlyOwner() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   /**
340    * @dev Allows the current owner to relinquish control of the contract.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
367 
368 pragma solidity ^0.4.23;
369 
370 
371 
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
377  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
378  */
379 contract MintableToken is StandardToken, Ownable {
380   event Mint(address indexed to, uint256 amount);
381   event MintFinished();
382 
383   bool public mintingFinished = false;
384 
385 
386   modifier canMint() {
387     require(!mintingFinished);
388     _;
389   }
390 
391   modifier hasMintPermission() {
392     require(msg.sender == owner);
393     _;
394   }
395 
396   /**
397    * @dev Function to mint tokens
398    * @param _to The address that will receive the minted tokens.
399    * @param _amount The amount of tokens to mint.
400    * @return A boolean that indicates if the operation was successful.
401    */
402   function mint(
403     address _to,
404     uint256 _amount
405   )
406     hasMintPermission
407     canMint
408     public
409     returns (bool)
410   {
411     totalSupply_ = totalSupply_.add(_amount);
412     balances[_to] = balances[_to].add(_amount);
413     emit Mint(_to, _amount);
414     emit Transfer(address(0), _to, _amount);
415     return true;
416   }
417 
418   /**
419    * @dev Function to stop minting new tokens.
420    * @return True if the operation was successful.
421    */
422   function finishMinting() onlyOwner canMint public returns (bool) {
423     mintingFinished = true;
424     emit MintFinished();
425     return true;
426   }
427 }
428 
429 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
430 
431 pragma solidity ^0.4.23;
432 
433 
434 
435 /**
436  * @title Burnable Token
437  * @dev Token that can be irreversibly burned (destroyed).
438  */
439 contract BurnableToken is BasicToken {
440 
441   event Burn(address indexed burner, uint256 value);
442 
443   /**
444    * @dev Burns a specific amount of tokens.
445    * @param _value The amount of token to be burned.
446    */
447   function burn(uint256 _value) public {
448     _burn(msg.sender, _value);
449   }
450 
451   function _burn(address _who, uint256 _value) internal {
452     require(_value <= balances[_who]);
453     // no need to require value <= totalSupply, since that would imply the
454     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
455 
456     balances[_who] = balances[_who].sub(_value);
457     totalSupply_ = totalSupply_.sub(_value);
458     emit Burn(_who, _value);
459     emit Transfer(_who, address(0), _value);
460   }
461 }
462 
463 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
464 
465 pragma solidity ^0.4.23;
466 
467 
468 
469 /**
470  * @title Pausable
471  * @dev Base contract which allows children to implement an emergency stop mechanism.
472  */
473 contract Pausable is Ownable {
474   event Pause();
475   event Unpause();
476 
477   bool public paused = false;
478 
479 
480   /**
481    * @dev Modifier to make a function callable only when the contract is not paused.
482    */
483   modifier whenNotPaused() {
484     require(!paused);
485     _;
486   }
487 
488   /**
489    * @dev Modifier to make a function callable only when the contract is paused.
490    */
491   modifier whenPaused() {
492     require(paused);
493     _;
494   }
495 
496   /**
497    * @dev called by the owner to pause, triggers stopped state
498    */
499   function pause() onlyOwner whenNotPaused public {
500     paused = true;
501     emit Pause();
502   }
503 
504   /**
505    * @dev called by the owner to unpause, returns to normal state
506    */
507   function unpause() onlyOwner whenPaused public {
508     paused = false;
509     emit Unpause();
510   }
511 }
512 
513 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
514 
515 pragma solidity ^0.4.23;
516 
517 
518 
519 
520 /**
521  * @title Pausable token
522  * @dev StandardToken modified with pausable transfers.
523  **/
524 contract PausableToken is StandardToken, Pausable {
525 
526   function transfer(
527     address _to,
528     uint256 _value
529   )
530     public
531     whenNotPaused
532     returns (bool)
533   {
534     return super.transfer(_to, _value);
535   }
536 
537   function transferFrom(
538     address _from,
539     address _to,
540     uint256 _value
541   )
542     public
543     whenNotPaused
544     returns (bool)
545   {
546     return super.transferFrom(_from, _to, _value);
547   }
548 
549   function approve(
550     address _spender,
551     uint256 _value
552   )
553     public
554     whenNotPaused
555     returns (bool)
556   {
557     return super.approve(_spender, _value);
558   }
559 
560   function increaseApproval(
561     address _spender,
562     uint _addedValue
563   )
564     public
565     whenNotPaused
566     returns (bool success)
567   {
568     return super.increaseApproval(_spender, _addedValue);
569   }
570 
571   function decreaseApproval(
572     address _spender,
573     uint _subtractedValue
574   )
575     public
576     whenNotPaused
577     returns (bool success)
578   {
579     return super.decreaseApproval(_spender, _subtractedValue);
580   }
581 }
582 
583 // File: openzeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
584 
585 pragma solidity ^0.4.23;
586 
587 
588 
589 
590 /**
591  * @title TokenDestructible:
592  * @author Remco Bloemen <remco@2π.com>
593  * @dev Base contract that can be destroyed by owner. All funds in contract including
594  * listed tokens will be sent to the owner.
595  */
596 contract TokenDestructible is Ownable {
597 
598   constructor() public payable { }
599 
600   /**
601    * @notice Terminate contract and refund to owner
602    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
603    refund.
604    * @notice The called token contracts could try to re-enter this contract. Only
605    supply token contracts you trust.
606    */
607   function destroy(address[] tokens) onlyOwner public {
608 
609     // Transfer tokens to owner
610     for (uint256 i = 0; i < tokens.length; i++) {
611       ERC20Basic token = ERC20Basic(tokens[i]);
612       uint256 balance = token.balanceOf(this);
613       token.transfer(owner, balance);
614     }
615 
616     // Transfer Eth to owner and terminate contract
617     selfdestruct(owner);
618   }
619 }
620 
621 // File: contracts/ERC20Token.sol
622 
623 pragma solidity ^0.4.24;
624 
625 contract ERC20Token is
626   DetailedERC20,
627   MintableToken,
628   BurnableToken,
629   PausableToken,
630   TokenDestructible
631 {
632   constructor(string _name, string _symbol, uint8 _decimals)
633     public
634     DetailedERC20(_name, _symbol, _decimals)
635   { }
636 }