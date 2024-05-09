1 pragma solidity ^0.4.23;
2 
3 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
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
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
52 
53 /**
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
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95   /**
96    * @dev Allows the current owner to relinquish control of the contract.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 }
103 
104 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   function totalSupply() public view returns (uint256);
113   function balanceOf(address who) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender)
172     public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value)
175     public returns (bool);
176 
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 }
184 
185 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
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
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
310 
311 /**
312  * @title Mintable token
313  * @dev Simple ERC20 Token example, with mintable token creation
314  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
315  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
316  */
317 contract MintableToken is StandardToken, Ownable {
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   modifier hasMintPermission() {
330     require(msg.sender == owner);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(
341     address _to,
342     uint256 _amount
343   )
344     hasMintPermission
345     canMint
346     public
347     returns (bool)
348   {
349     totalSupply_ = totalSupply_.add(_amount);
350     balances[_to] = balances[_to].add(_amount);
351     emit Mint(_to, _amount);
352     emit Transfer(address(0), _to, _amount);
353     return true;
354   }
355 
356   /**
357    * @dev Function to stop minting new tokens.
358    * @return True if the operation was successful.
359    */
360   function finishMinting() onlyOwner canMint public returns (bool) {
361     mintingFinished = true;
362     emit MintFinished();
363     return true;
364   }
365 }
366 
367 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
368 
369 /**
370  * @title Pausable
371  * @dev Base contract which allows children to implement an emergency stop mechanism.
372  */
373 contract Pausable is Ownable {
374   event Pause();
375   event Unpause();
376 
377   bool public paused = false;
378 
379 
380   /**
381    * @dev Modifier to make a function callable only when the contract is not paused.
382    */
383   modifier whenNotPaused() {
384     require(!paused);
385     _;
386   }
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is paused.
390    */
391   modifier whenPaused() {
392     require(paused);
393     _;
394   }
395 
396   /**
397    * @dev called by the owner to pause, triggers stopped state
398    */
399   function pause() onlyOwner whenNotPaused public {
400     paused = true;
401     emit Pause();
402   }
403 
404   /**
405    * @dev called by the owner to unpause, returns to normal state
406    */
407   function unpause() onlyOwner whenPaused public {
408     paused = false;
409     emit Unpause();
410   }
411 }
412 
413 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
414 
415 /**
416  * @title Pausable token
417  * @dev StandardToken modified with pausable transfers.
418  **/
419 contract PausableToken is StandardToken, Pausable {
420 
421   function transfer(
422     address _to,
423     uint256 _value
424   )
425     public
426     whenNotPaused
427     returns (bool)
428   {
429     return super.transfer(_to, _value);
430   }
431 
432   function transferFrom(
433     address _from,
434     address _to,
435     uint256 _value
436   )
437     public
438     whenNotPaused
439     returns (bool)
440   {
441     return super.transferFrom(_from, _to, _value);
442   }
443 
444   function approve(
445     address _spender,
446     uint256 _value
447   )
448     public
449     whenNotPaused
450     returns (bool)
451   {
452     return super.approve(_spender, _value);
453   }
454 
455   function increaseApproval(
456     address _spender,
457     uint _addedValue
458   )
459     public
460     whenNotPaused
461     returns (bool success)
462   {
463     return super.increaseApproval(_spender, _addedValue);
464   }
465 
466   function decreaseApproval(
467     address _spender,
468     uint _subtractedValue
469   )
470     public
471     whenNotPaused
472     returns (bool success)
473   {
474     return super.decreaseApproval(_spender, _subtractedValue);
475   }
476 }
477 
478 // File: contracts\SAIToken.sol
479 
480 // SAI Token is a first token of TokenStars platform
481 // Copyright (c) 2018 TokenStars
482 // Made by Maggie Samoyed
483 // Permission is hereby granted, free of charge, to any person obtaining a copy
484 // of this software and associated documentation files (the "Software"), to deal
485 // in the Software without restriction, including without limitation the rights
486 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
487 // copies of the Software, and to permit persons to whom the Software is
488 // furnished to do so, subject to the following conditions:
489 
490 // The above copyright notice and this permission notice shall be included in all
491 // copies or substantial portions of the Software.
492 
493 // THE SOFTWARE IS PROVIDED "Sophon Capital", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
494 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
495 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
496 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
497 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
498 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
499 // SOFTWARE.
500 pragma solidity ^0.4.17;
501 
502 
503 
504 
505 contract SAIToken is MintableToken, PausableToken{
506 	// ERC20 constants
507 	string public name="Sophon Capital Token";
508 	string public symbol="SAIT";
509 	string public standard="ERC20";	
510 	uint8 public decimals=18;
511 
512 	/*Publish Constants*/
513 	uint256 public totalSupply=0;
514 	uint256 public INITIAL_SUPPLY = 10*(10**8)*(10**18);
515 	uint256 public ONE_PERCENT = INITIAL_SUPPLY/100;
516 	uint256 public TOKEN_SALE = 30 * ONE_PERCENT;//Directed distribution
517 	uint256 public COMMUNITY_RESERVE = 10 * ONE_PERCENT;//Community operation
518 	uint256 public TEAM_RESERVE = 30 * ONE_PERCENT;//Team motivation
519 	uint256 public FOUNDATION_RESERVE = 30 * ONE_PERCENT;//Foundation development standby
520 
521 	/*Issuing Address Constants*/
522 	address public salesTokenHolder;
523 	address public communityTokenHolder;
524 	address public teamTokenHolder;
525 	address public foundationTokenHolder;
526 
527 	/* Freeze Account*/
528 	mapping(address => bool) public frozenAccount;
529 	event FrozenFunds(address target, bool frozen);
530 
531 	using SafeMath for uint256;
532 	
533 	/*Here is the constructor function that is executed when the instance is created*/
534 	function SAIToken(address _communityAdd, address _teamAdd, address _foundationAdd) public{
535 		balances[_communityAdd] = balances[_communityAdd].add(COMMUNITY_RESERVE);
536 		totalSupply = totalSupply.add(COMMUNITY_RESERVE);
537 		emit Transfer(0x0, _communityAdd, COMMUNITY_RESERVE);
538 		communityTokenHolder = _communityAdd;
539 
540 		balances[_teamAdd] = balances[_teamAdd].add(TEAM_RESERVE);
541 		totalSupply = totalSupply.add(TEAM_RESERVE);
542 		emit Transfer(0x0, _teamAdd, TEAM_RESERVE);
543 		teamTokenHolder = _teamAdd;
544 
545 		balances[_foundationAdd] = balances[_foundationAdd].add(FOUNDATION_RESERVE);
546 		totalSupply = totalSupply.add(FOUNDATION_RESERVE);
547 		emit Transfer(0x0, _foundationAdd, FOUNDATION_RESERVE);
548 		foundationTokenHolder = _foundationAdd;
549 	}
550 
551   /**
552   * @dev mint required amount of token
553   * @param _investor address of investor
554   * @param _value token amount corresponding to investor
555   */
556   function mint(address _investor, uint256 _value) onlyOwner whenNotPaused returns (bool success){
557 		require(_value > 0);
558 		require(totalSupply.add(_value) <= INITIAL_SUPPLY);
559     	balances[_investor] = balances[_investor].add(_value);
560 		totalSupply = totalSupply.add(_value);
561 	 	emit Transfer(0x0, _investor, _value);
562 		return true;
563 	}
564 
565    /**
566     * @dev Function to freeze Account
567     * @param target The address that will freezed.
568     * @param freeze Is it frozen.
569     */
570 	function freezeAccount(address target, bool freeze) onlyOwner {
571 		frozenAccount[target]=freeze;
572 		emit FrozenFunds(target,freeze);
573 	}
574 
575    /**
576     * @dev transfer token for a specified address if transfer is open
577     * @param _to The address to transfer to.
578     * @param _value The amount to be transferred.
579     */
580 	function transfer(address _to, uint256 _value) returns (bool) {
581 		require(!frozenAccount[msg.sender]);
582 		return super.transfer(_to, _value);	
583 	}
584 }