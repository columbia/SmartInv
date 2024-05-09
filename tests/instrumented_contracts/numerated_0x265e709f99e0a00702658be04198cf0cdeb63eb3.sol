1 pragma solidity ^0.5.7;
2 
3 /*
4 #############&&##################################################################################################################################&
5 ###########@%!!$#################################################################################################################################&
6 ##########&!!!!!%@#####################$&#########&$@#####################&|%################$!!!!!!|&#############################&|!$######&|!$$
7 #########%!!!!!!!!&##################@%|&#########$%@#####$$#######$$#####&|%################$!%###@|!&##############################$!|@###%!%@#&
8 #$!%@##&|!!!!!!!!!!%###$||&##########@%|&#########&$@###&|!||%@##&|!||%@##&|%######$||%&#####$!%###@||&######$||%&#######$||%&########@%!%%!|&###&
9 @|!!!!!!!!!!!!!!!!!!!!!!!!$##########@%|&#########%|&###&||&#####&||&#####&|%####$!$##&|%@###$!!!!!!%@#####$!%##@||@###$!%@#@%|&########$!!$#####&
10 &!!!!!!!!!!!!!!!!!!!!!!!!!%@#########@%|&#########%|&###@%%@#####@%%@#####&|%###&|!|||||!$###$!%####&|!&##@|!|||||!$##@|!|||||!$#######%!|%!|@###&
11 $!!!!!!!!!!!!!!!!!!!!!!!!!!&#########@%|&#########%|&###@%%@#####@%%@#####&|%###@||@#########$!%#####$!$##@||@########@%|&###########$!|&##@%!%##&
12 %!!!!!!!!!!!!!!!!!!!!!!!!!!$#########@%!||||||&###%|&####$!|%|$###%!|%|$##&|%####&|!|%%||&###$!!||||!!%@###@|!!%%|!$###@%!!|%|!$###&|!$######&|!&&
13 !!!!!!!!!!!!!!!!!!!!!!!!!!!%@####################################################################################################################$
14 $!!!!!!!!!!!!!!!!!!!!!!!!!|&#####################################################################################################################&
15 ###%!!!!!!!!!!!!!!!!!!!|$########################################################################################################################&
16 #####@%!!!!!!!!!!!!!!$###############@$Forever young:############################################################################################&
17 ########&|!!!!!!!!%@#################@DEFENG XU/LARRY YE/MR GUO/MR LIU/YIRANG ZHANG/MINGCONG WU/YIMING WANG/YANPENG ZHANG/GAO JUN/KOREAN FRIENDS#&
18 ###########$|!!|&################################################################################################################################&
19 #############&&##################################################################################################################################&
20 
21 /*
22 COPYRIGHT (C) 2019 LITTLEBEEX TECHNOLOGY，ALL RIGHTS RESERVED.
23 
24 Permission is hereby granted, free of charge, to any person obtaining
25 a copy of this software and associated documentation files (the
26 "Software"), to deal in the Software without restriction, including 
27 without limitation the rights to use, copy, modify, merge, publish,
28 distribute, sublicense, and/or sell copies of the Software, and to
29 permit persons to whom the Software is furnished to do so, subject to
30 the following conditions:
31 
32 The above copyright notice and this permission notice shall be included
33 in all copies or substantial portions of the Software.
34 
35 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
36 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
37 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
38 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
39 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
40 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
41 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
42 */
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 
50 contract Ownable {
51   address public owner;
52   event OwnershipRenounced(address indexed previousOwner);
53   event OwnershipTransferred(
54   address indexed previousOwner,
55   address indexed newOwner
56   );
57 
58 /**
59 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60 * account.
61 */
62   constructor() public {
63     owner = msg.sender;
64   }
65 
66 /**
67 * @dev Throws if called by any account other than the owner.
68 */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 /**
75 * @dev Allows the current owner to transfer control of the contract to a newOwner.
76 * @param newOwner The address to transfer ownership to.
77 */
78 
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 }
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 
91 library SafeMath {
92 
93 /**
94  * @dev Multiplies two numbers, throws on overflow.
95  */
96 
97   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     if (a == 0) {
99       return 0;
100     }
101     c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106 /**
107 * @dev Integer division of two numbers, truncating the quotient.
108 */
109 
110   function div(uint256 a, uint256 b) internal pure returns (uint256) {
111     //assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     //assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117 /**
118 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119 */
120 
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126 /**
127 * @dev Adds two numbers, throws on overflow.
128 */
129 
130   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
131     c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 contract Pausable is Ownable {
138   event Pause();
139   event Unpause();
140   bool public paused = false;
141 
142 /**
143 * @dev Modifier to make a function callable only when the contract is not paused.
144 */
145   modifier whenNotPaused() {
146     require(!paused);
147     _;
148   }
149 
150 /**
151 * @dev Modifier to make a function callable only when the contract is paused.
152 */
153   modifier whenPaused() {
154     require(paused);
155     _;
156   }
157 
158 /**
159 * @dev called by the owner to pause, triggers stopped state
160 */
161 
162   function pause() onlyOwner whenNotPaused public {
163     paused = true;
164     emit Pause();
165   }
166 
167 /**
168 * @dev called by the owner to unpause, returns to normal state
169 */
170 
171   function unpause() onlyOwner whenPaused public {
172     paused = false;
173     emit Unpause();
174   }
175 }
176 
177 /**
178  * @title ERC20Basic
179  * @dev Simpler version of ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/179
181  */
182 
183 contract ERC20Basic is Pausable {
184   function totalSupply() public view returns (uint256);
185   function balanceOf(address who) public view returns (uint256);
186   function transfer(address to, uint256 value) public returns (bool);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 }
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 
195 contract ERC20 is ERC20Basic {
196   function allowance(address owner, address spender) public view returns (uint256);
197   function transferFrom(address from, address to, uint256 value) public returns (bool);
198   function approve(address spender, uint256 value) public returns (bool);
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 contract BasicToken is ERC20Basic {
203   using SafeMath for uint256;
204   mapping (address => bool) public frozenAccount; //Accounts frozen indefinitely
205   mapping (address => uint256) public frozenTimestamp; //Limited frozen accounts
206   mapping(address => uint256) balances;
207   uint256 totalSupply_;
208 
209 /**
210 * @dev total number of tokens in existence
211 */
212 
213   function totalSupply() public view returns (uint256) {
214     return totalSupply_;
215   }
216 
217 /**
218 * @dev transfer token for a specified address
219 * @param _to The address to transfer to.
220 * @param _value The amount to be transferred.
221 */
222 
223   function transfer(address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[msg.sender]);
226     require(!frozenAccount[msg.sender]);
227     require(now > frozenTimestamp[msg.sender]);
228     require(!frozenAccount[_to]);
229     require(now > frozenTimestamp[_to]);
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236 /**
237 * @dev Gets the balance of the specified address.
238 * @param _owner The address to query the the balance of.
239 * @return An uint256 representing the amount owned by the passed address.
240 */
241 
242   function balanceOf(address _owner) public view returns (uint256) {
243     return balances[_owner];
244   }
245 
246   /**@dev Lock account */
247 
248   function freeze(address _target,bool _freeze) onlyOwner public returns (bool) {
249     require(_target != address(0));
250     frozenAccount[_target] = _freeze;
251     return true;
252   }
253 
254   /**@dev Bulk lock account */
255 
256   function multiFreeze(address[] memory _targets,bool[] memory _freezes) onlyOwner public returns (bool) {
257     require(_targets.length == _freezes.length);
258     uint256 len = _targets.length;
259     require(len > 0);
260     for (uint256 i = 0; i < len; i= i.add(1)) {
261       address _target = _targets[i];
262       require(_target != address(0));
263       bool _freeze = _freezes[i];
264       frozenAccount[_target] = _freeze;
265     }
266     return true;
267   }
268 
269   /**@dev Lock accounts through timestamp refer to:https://www.epochconverter.com */
270   
271   function freezeWithTimestamp(address _target,uint256 _timestamp) onlyOwner public returns (bool) {
272     require(_target != address(0));
273     frozenTimestamp[_target] = _timestamp;
274     return true;
275   }
276 
277   /**@dev Batch lock accounts through timestamp refer to:https://www.epochconverter.com */
278 
279   function multiFreezeWithTimestamp(address[] memory _targets,uint256[] memory _timestamps) onlyOwner public returns (bool) {
280     require(_targets.length == _timestamps.length);
281     uint256 len = _targets.length;
282     require(len > 0);
283     for (uint256 i = 0; i < len; i = i.add(1)) {
284       address _target = _targets[i];
285       require(_target != address(0));
286       uint256 _timestamp = _timestamps[i];
287       frozenTimestamp[_target] = _timestamp;
288     }
289     return true;
290   }
291 }
292 
293 /**
294  * @title Standard ERC20 token
295  * @dev Implementation of the basic standard token.
296  * @dev https://github.com/ethereum/EIPs/issues/20
297  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
298  */
299 
300 contract StandardToken is ERC20, BasicToken {
301   mapping (address => mapping (address => uint256)) internal allowed;
302   
303 /**
304 * @dev Transfer tokens from one address to another
305 * @param _from address The address which you want to send tokens from
306 * @param _to address The address which you want to transfer to
307 * @param _value uint256 the amount of tokens to be transferred
308 */
309 
310   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
311     require(_to != address(0));
312     require(_value <= balances[_from]);
313     require(_value <= allowed[_from][msg.sender]);
314     require(!frozenAccount[_from]);
315     require(!frozenAccount[_to]);
316     require(now > frozenTimestamp[_from]);
317     require(now > frozenTimestamp[_to]); 
318     balances[_from] = balances[_from].sub(_value);
319     balances[_to] = balances[_to].add(_value);
320     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
321     emit Transfer(_from, _to, _value);
322     return true;
323   }
324 
325 /**
326 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
327 *
328 * Beware that changing an allowance with this method brings the risk that someone may use both the old
329 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
330 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
331 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332 * @param _spender The address which will spend the funds.
333 * @param _value The amount of tokens to be spent.
334 */
335 
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     require(_value == 0 || allowed[msg.sender][_spender] == 0);
338     allowed[msg.sender][_spender] = _value;
339     emit Approval(msg.sender, _spender, _value);
340     return true;
341   }
342 
343 /**
344 * @dev Function to check the amount of tokens that an owner allowed to a spender.
345 * @param _owner address The address which owns the funds.
346 * @param _spender address The address which will spend the funds.
347 * @return A uint256 specifying the amount of tokens still available for the spender.
348 */
349 
350   function allowance(address _owner, address _spender) public view returns (uint256) {
351     return allowed[_owner][_spender];
352   }
353 
354 /**
355 * @dev Increase the amount of tokens that an owner allowed to a spender.
356 *
357 * approve should be called when allowed[_spender] == 0. To increment
358 * allowed value is better to use this function to avoid 2 calls (and wait until
359 * the first transaction is mined)
360 * @param _spender The address which will spend the funds.
361 * @param _addedValue The amount of tokens to increase the allowance by.
362 */
363 
364   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
365     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
366     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
367     return true;
368   }
369 
370 /**
371 * @dev Decrease the amount of tokens that an owner allowed to a spender.
372 *
373 * approve should be called when allowed[_spender] == 0. To decrement
374 * allowed value is better to use this function to avoid 2 calls (and wait until
375 * the first transaction is mined)
376 * From MonolithDAO Token.sol
377 * @param _spender The address which will spend the funds.
378 * @param _subtractedValue The amount of tokens to decrease the allowance by.
379 */
380 
381   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
382     uint oldValue = allowed[msg.sender][_spender];
383     if (_subtractedValue > oldValue) {
384       allowed[msg.sender][_spender] = 0;
385     } else {
386       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
387     }
388     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389     return true;
390   }
391 }
392 
393 /**
394  * @title Burn token
395  * @dev Token can be destroyed.
396  */
397 
398 contract BurnableToken is BasicToken {
399   event Burn(address indexed burner, uint256 value);
400 
401 /**
402 * @dev Destroy the specified number of token.
403 * @param _value Number of destroyed token.
404 */
405 
406   function burn(uint256 _value) public {
407     _burn(msg.sender, _value);
408   }
409 
410   function _burn(address _who, uint256 _value) internal {
411     require(_value <= balances[_who]);
412     //No need to verify value <= totalSupply，Because this means that the balance of the sender is greater than the total supply. This should be the assertion failure.
413     balances[_who] = balances[_who].sub(_value);
414     totalSupply_ = totalSupply_.sub(_value);
415     emit Burn(_who, _value);
416     emit Transfer(_who, address(0), _value);
417   }
418 }
419 
420 /**
421  * @title StandardBurn token
422  * @dev Add the burnFrom method to the ERC20 implementation.
423  */
424 
425 contract StandardBurnableToken is BurnableToken, StandardToken {
426 
427 /**
428 * @dev Destroy a specific number of token from target address and reduce the allowable amount.
429 * @param _from address token Owner address
430 * @param _value uint256 Number of destroyed token
431 */
432 
433   function burnFrom(address _from, uint256 _value) public {
434     require(_value <= allowed[_from][msg.sender]);
435     //Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
436     //This method requires triggering an event with updated approval.
437     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
438     _burn(_from, _value);
439   }
440 }
441 
442 contract MintableToken is StandardBurnableToken {
443   event Mint(address indexed to, uint256 amount);
444   event MintFinished();
445   bool public mintingFinished = false;
446   modifier canMint() {
447   require(!mintingFinished);
448   _;
449   }
450 
451 /**
452 * @dev Function to mint tokens
453 * @param _to The address that will receive the minted tokens.
454 * @param _amount The amount of tokens to mint.
455 * @return A boolean that indicates if the operation was successful.
456 */
457 
458   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
459     require(_to != address(0));
460     totalSupply_ = totalSupply_.add(_amount);
461     balances[_to] = balances[_to].add(_amount);
462     emit Mint(_to, _amount);
463     emit Transfer(address(0), _to, _amount);
464     return true;
465   }
466 
467 /**
468 * @dev Function to stop minting new tokens.
469 * @return True if the operation was successful.
470 */
471 
472   function finishMinting() onlyOwner canMint public returns (bool) {
473     mintingFinished = true;
474     emit MintFinished();
475     return true;
476   }
477 }
478 
479 contract CappedToken is MintableToken {
480   uint256 public cap;
481   constructor(uint256 _cap) public {
482   require(_cap > 0);
483   cap = _cap;
484   }
485 
486 /**
487 * @dev Function to mint tokens
488 * @param _to The address that will receive the minted tokens.
489 * @param _amount The amount of tokens to mint.
490 * @return A boolean that indicates if the operation was successful.
491 */
492    
493   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
494     require(totalSupply_.add(_amount) <= cap);
495     return super.mint(_to, _amount);
496   }
497 }
498 
499 contract PausableToken is StandardToken {
500 
501   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
502     return super.transfer(_to, _value);
503   }
504 
505   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
506     return super.transferFrom(_from, _to, _value);
507   }
508 
509   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
510     return super.approve(_spender, _value);
511   }
512 
513   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
514     return super.increaseApproval(_spender, _addedValue);
515   }
516 
517   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
518     return super.decreaseApproval(_spender, _subtractedValue);
519   }
520 }
521 
522 contract LT_Token is CappedToken, PausableToken {
523   string public constant name = "LittleBeeX"; // solium-disable-line uppercase
524   string public constant symbol = "LT"; // solium-disable-line uppercase
525   uint8 public constant decimals = 18; // solium-disable-line uppercase
526   uint256 public constant INITIAL_SUPPLY = 0;
527   uint256 public constant MAX_SUPPLY = 50 * 10000 * 10000 * (10 ** uint256(decimals));
528 
529 /**
530 * @dev Constructor that gives msg.sender all of existing tokens.
531 */
532   
533   constructor() CappedToken(MAX_SUPPLY) public {
534     totalSupply_ = INITIAL_SUPPLY;
535     balances[msg.sender] = INITIAL_SUPPLY;
536     emit Transfer(address(uint160(0x0)), msg.sender, INITIAL_SUPPLY);
537   }
538 
539 /**
540 * @dev Function to mint tokens
541 * @param _to The address that will receive the minted tokens.
542 * @param _amount The amount of tokens to mint.
543 * @return A boolean that indicates if the operation was successful.
544 */
545   
546   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
547     return super.mint(_to, _amount);
548   }
549 
550 /**
551 * @dev Function to stop minting new tokens.
552 * @return True if the operation was successful.
553 */
554   
555   function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
556     return super.finishMinting();
557   }
558 
559 /**@dev Withdrawals from contracts can only be made to Owner.*/
560 
561   function withdraw (uint256 _amount) onlyOwner public returns (bool) {
562     msg.sender.transfer(_amount);
563     return true;
564   }
565 
566 //The fallback function.
567 
568   function() payable external {
569     revert();
570   }
571 }