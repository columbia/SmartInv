1 pragma solidity ^0.4.25;
2 
3 /*
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@!!!!@@@@@@@@@@@@@@!!!!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@    @@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@---;@@    @@@@@---@@    @@@@@@@@@@@@@@@@@-@@@@@@*@@@@@@@@@@@@@@@. @@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@  @@@@@ !@@@@@
11 @@@@@---#@@   -@@@---@@~   @@@@@@@@@@@@@@@@@ -@@@@@@ $@@@@.@@@@@-@@@. @@@@@@@@@@@ @@@ :@@@@@@@@@@@@@@@@@@@@ -@@@  @@@@@@
12 @@@@@@---@@*   #@---@@@   =@@@@@@@@@@@@@@@@@ -@@@@@@@@@@@ @@@@@ @@@@. @@@@@@@@@@@ @@@  @@@@@@@@@@@@@@@@@@@@@ $@  @@@@@@@
13 @@@@@@@---@@.   ---*@@   ,@@@@@@@@@@@@@@@@@@ -@@@@@@ $@@    @@    @@. @@@*   @@@@ @@@ #@@@@   @@@@@   @@@@@@*   @@@@@@@@
14 @@@@@@@*---@@    -~@@    @@@@@@@@@@@@@@@@@@@ -@@@@@@ $@@@ @@@@@ @@@@. @@@ @@- @@@    :@@@@ $@# @@@ =@@ @@@@@@  @@@@@@@@@
15 @@@@@@@@~--~@@    @@    @@@@@@@@@@@@@@@@@@@@ -@@@@@@ $@@@ @@@@@ @@@@. @@  @@@ @@@ @@@  @@# @@@ @@@ @@@ @@@@@$   @@@@@@@@
16 @@@@@@@@@---*@-    .   @@@@@@@@@@@@@@@@@@@@@ -@@@@@@ $@@@ @@@@@ @@@@. @@  @@@@@@@ @@@@ *@$ @@@@@@# @@@@@@@@@ !@  @@@@@@@
17 @@@@@@@@@@------      @@@@@@@@@@@@@@@@@@@@@@ -@@@@@@ $@@@ @@@@@ @@@@. @@$ @@@@@@@ @@@@ $@@ @@@@@@@ @@@@@@@@ .@@@ ,@@@@@@
18 @@@@@@@@@@@----@*    =@@@@@@@@@@@@@@@@@@@@@@     .@@ $@@@   @@@   @@. @@@     @@@      @@@     @@@     @@@  @@@@@ $@@@@@
19 @@@@@@@@@@@----@@    @@@@@@@@@@@@@@@@@@@@@@@~~~~!@@@~#@@@@:=@@@@~=@@:~@@@@$~*@@@@~~~:@@@@@@@~!@@@@@@~;@@@~~@@@@@@*~@@@@@
20 @@@@@@@@@@~-----      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@;---~-        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@#---@@    @@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@---@@.   -@@@   ~@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@---@@=   ,--@@=   #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@---=@@   .@---@@.   @@@@@@@@@@@@@@@@@@;@=#@@@-@@!@.@@! @~@.@@#*@@.@@-@@=.@@@@@@#@@@@~@@!@.@@:@@@:@ @@,@@@@*@ @@@@@
26 @@@@@~--~@@    @@*---@@    @@@@@@@@@@@@@@@@@;@$#@@~@@@@@@@@@ ,@@@@@@*@@.@=@@@=.@@@@@@*@@@~@@@@@@. #@@@~-@@@@ @@@@.@@@@@@
27 @@@@;---@@    @@@@~--~@@    @@@@@@@@@@@@@@@@;@ #@@-@@@@@@@@@ ~@#@@@@*@@.@., @=.@$@@@@$@@@-@@@@@@@@#@@@@,, @@@,@@@-@@@@@@
28 @@@#---@@    @@@@@@---*@@    @@@@@@@@@@@@@@@;@,#@@@!@@-@ @@$ @,@-@@#*@@.@@@@@=.@@~@@@*@@@@*@@~@@@@#@@@!@@@@@@@!@@-@@@@@@
29 @@@@@@@@.   @@@@@@@@@@@@@@   ~@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 @@@@@@@@;;;$@@@@@@@@@@@@@@=;;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
32 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
33 Forever young:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 DEFENG XU/LARRY YE/COINSSUL SKY/MR GUO/YIRANG ZHANG/MINGCONG WU/YIMING WANG/YANPENG ZHANG/HUANKAI JIN/KUN WANG/JUN GAO:)
35 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
36 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>>> We are the best ^_^ >>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
37 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
38 
39 /*
40 COPYRIGHT (C) 2018 LITTLEBEEX TECHNOLOGY，ALL RIGHTS RESERVED.
41 
42 Permission is hereby granted, free of charge, to any person obtaining
43 a copy of this software and associated documentation files (the
44 "Software"), to deal in the Software without restriction, including
45 without limitation the rights to use, copy, modify, merge, publish,
46 distribute, sublicense, and/or sell copies of the Software, and to
47 permit persons to whom the Software is furnished to do so, subject to
48 the following conditions:
49 
50 The above copyright notice and this permission notice shall be included
51 in all copies or substantial portions of the Software.
52 
53 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
54 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
55 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
56 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
57 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
58 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
59 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
60 */
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 
68 contract Ownable {
69   address public owner;
70   event OwnershipRenounced(address indexed previousOwner);
71   event OwnershipTransferred(
72   address indexed previousOwner,
73   address indexed newOwner
74   );
75 
76 /**
77 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78 * account.
79 */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84 /**
85 * @dev Throws if called by any account other than the owner.
86 */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 /**
93 * @dev Allows the current owner to transfer control of the contract to a newOwner.
94 * @param newOwner The address to transfer ownership to.
95 */
96 
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     emit OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 
109 library SafeMath {
110 
111 /**
112  * @dev Multiplies two numbers, throws on overflow.
113  */
114 
115   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
116     if (a == 0) {
117       return 0;
118     }
119     c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124 /**
125 * @dev Integer division of two numbers, truncating the quotient.
126 */
127 
128   function div(uint256 a, uint256 b) internal pure returns (uint256) {
129     //assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     //assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135 /**
136 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137 */
138 
139   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144 /**
145 * @dev Adds two numbers, throws on overflow.
146 */
147 
148   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 contract Pausable is Ownable {
156   event Pause();
157   event Unpause();
158   bool public paused = false;
159 
160 /**
161 * @dev Modifier to make a function callable only when the contract is not paused.
162 */
163   modifier whenNotPaused() {
164     require(!paused);
165     _;
166   }
167 
168 /**
169 * @dev Modifier to make a function callable only when the contract is paused.
170 */
171   modifier whenPaused() {
172     require(paused);
173     _;
174   }
175 
176 /**
177 * @dev called by the owner to pause, triggers stopped state
178 */
179 
180   function pause() onlyOwner whenNotPaused public {
181     paused = true;
182     emit Pause();
183   }
184 
185 /**
186 * @dev called by the owner to unpause, returns to normal state
187 */
188 
189   function unpause() onlyOwner whenPaused public {
190     paused = false;
191     emit Unpause();
192   }
193 }
194 
195 /**
196  * @title ERC20Basic
197  * @dev Simpler version of ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/179
199  */
200 
201 contract ERC20Basic is Pausable {
202   function totalSupply() public view returns (uint256);
203   function balanceOf(address who) public view returns (uint256);
204   function transfer(address to, uint256 value) public returns (bool);
205   event Transfer(address indexed from, address indexed to, uint256 value);
206 }
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 
213 contract ERC20 is ERC20Basic {
214   function allowance(address owner, address spender) public view returns (uint256);
215   function transferFrom(address from, address to, uint256 value) public returns (bool);
216   function approve(address spender, uint256 value) public returns (bool);
217   event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 contract BasicToken is ERC20Basic {
221   using SafeMath for uint256;
222   mapping (address => bool) public frozenAccount; //Accounts frozen indefinitely
223   mapping (address => uint256) public frozenTimestamp; //Limited frozen accounts
224   mapping(address => uint256) balances;
225   uint256 totalSupply_;
226 
227 /**
228 * @dev total number of tokens in existence
229 */
230 
231   function totalSupply() public view returns (uint256) {
232     return totalSupply_;
233   }
234 
235 /**
236 * @dev transfer token for a specified address
237 * @param _to The address to transfer to.
238 * @param _value The amount to be transferred.
239 */
240 
241   function transfer(address _to, uint256 _value) public returns (bool) {
242     require(_to != address(0));
243     require(_value <= balances[msg.sender]);
244     require(!frozenAccount[msg.sender]);
245     require(now > frozenTimestamp[msg.sender]);
246     balances[msg.sender] = balances[msg.sender].sub(_value);
247     balances[_to] = balances[_to].add(_value);
248     emit Transfer(msg.sender, _to, _value);
249     return true;
250   }
251 
252 /**
253 * @dev Gets the balance of the specified address.
254 * @param _owner The address to query the the balance of.
255 * @return An uint256 representing the amount owned by the passed address.
256 */
257 
258   function balanceOf(address _owner) public view returns (uint256) {
259     return balances[_owner];
260   }
261 
262   /**@dev Lock account */
263 
264   function freeze(address _target,bool _freeze) public returns (bool) {
265     require(msg.sender == owner);
266     require(_target != address(0));
267     frozenAccount[_target] = _freeze;
268     return true;
269   }
270 
271   /**@dev Bulk lock account */
272 
273   function multiFreeze(address[] _targets,bool[] _freezes) public returns (bool) {
274     require(msg.sender == owner);
275     require(_targets.length == _freezes.length);
276     uint256 len = _targets.length;
277     require(len > 0);
278     for (uint256 i = 0; i < len; i= i.add(1)) {
279       address _target = _targets[i];
280       require(_target != address(0));
281       bool _freeze = _freezes[i];
282       frozenAccount[_target] = _freeze;
283     }
284     return true;
285   }
286 
287   /**@dev Lock accounts through timestamp refer to:https://www.epochconverter.com */
288   
289   function freezeWithTimestamp(address _target,uint256 _timestamp) public returns (bool) {
290     require(msg.sender == owner);
291     require(_target != address(0));
292     frozenTimestamp[_target] = _timestamp;
293     return true;
294   }
295 
296   /**@dev Batch lock accounts through timestamp refer to:https://www.epochconverter.com */
297 
298   function multiFreezeWithTimestamp(address[] _targets,uint256[] _timestamps) public returns (bool) {
299     require(msg.sender == owner);
300     require(_targets.length == _timestamps.length);
301     uint256 len = _targets.length;
302     require(len > 0);
303     for (uint256 i = 0; i < len; i = i.add(1)) {
304       address _target = _targets[i];
305       require(_target != address(0));
306       uint256 _timestamp = _timestamps[i];
307       frozenTimestamp[_target] = _timestamp;
308     }
309     return true;
310   }
311 }
312 
313 /**
314  * @title Standard ERC20 token
315  * @dev Implementation of the basic standard token.
316  * @dev https://github.com/ethereum/EIPs/issues/20
317  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
318  */
319 
320 contract StandardToken is ERC20, BasicToken {
321   mapping (address => mapping (address => uint256)) internal allowed;
322   
323 /**
324 * @dev Transfer tokens from one address to another
325 * @param _from address The address which you want to send tokens from
326 * @param _to address The address which you want to transfer to
327 * @param _value uint256 the amount of tokens to be transferred
328 */
329 
330   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
331     require(_to != address(0));
332     require(_value <= balances[_from]);
333     require(_value <= allowed[_from][msg.sender]);
334     require(!frozenAccount[_from]);
335     require(!frozenAccount[_to]);
336     balances[_from] = balances[_from].sub(_value);
337     balances[_to] = balances[_to].add(_value);
338     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339     emit Transfer(_from, _to, _value);
340     return true;
341   }
342 
343 /**
344 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
345 *
346 * Beware that changing an allowance with this method brings the risk that someone may use both the old
347 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
348 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
349 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350 * @param _spender The address which will spend the funds.
351 * @param _value The amount of tokens to be spent.
352 */
353 
354   function approve(address _spender, uint256 _value) public returns (bool) {
355     allowed[msg.sender][_spender] = _value;
356     emit Approval(msg.sender, _spender, _value);
357     return true;
358   }
359 
360 /**
361 * @dev Function to check the amount of tokens that an owner allowed to a spender.
362 * @param _owner address The address which owns the funds.
363 * @param _spender address The address which will spend the funds.
364 * @return A uint256 specifying the amount of tokens still available for the spender.
365 */
366 
367   function allowance(address _owner, address _spender) public view returns (uint256) {
368     return allowed[_owner][_spender];
369   }
370 
371 /**
372 * @dev Increase the amount of tokens that an owner allowed to a spender.
373 *
374 * approve should be called when allowed[_spender] == 0. To increment
375 * allowed value is better to use this function to avoid 2 calls (and wait until
376 * the first transaction is mined)
377 * @param _spender The address which will spend the funds.
378 * @param _addedValue The amount of tokens to increase the allowance by.
379 */
380 
381   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
382     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
383     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386 
387 /**
388 * @dev Decrease the amount of tokens that an owner allowed to a spender.
389 *
390 * approve should be called when allowed[_spender] == 0. To decrement
391 * allowed value is better to use this function to avoid 2 calls (and wait until
392 * the first transaction is mined)
393 * From MonolithDAO Token.sol
394 * @param _spender The address which will spend the funds.
395 * @param _subtractedValue The amount of tokens to decrease the allowance by.
396 */
397 
398   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
399     uint oldValue = allowed[msg.sender][_spender];
400     if (_subtractedValue > oldValue) {
401       allowed[msg.sender][_spender] = 0;
402     } else {
403       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
404     }
405     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406     return true;
407   }
408 }
409 
410 /**
411  * @title Burn token
412  * @dev Token can be destroyed.
413  */
414 
415 contract BurnableToken is BasicToken {
416   event Burn(address indexed burner, uint256 value);
417 
418 /**
419 * @dev Destroy the specified number of token.
420 * @param _value Number of destroyed token.
421 */
422 
423   function burn(uint256 _value) public {
424     _burn(msg.sender, _value);
425   }
426 
427   function _burn(address _who, uint256 _value) internal {
428     require(_value <= balances[_who]);
429     //No need to verify value <= totalSupply，Because this means that the balance of the sender is greater than the total supply. This should be the assertion failure.
430     balances[_who] = balances[_who].sub(_value);
431     totalSupply_ = totalSupply_.sub(_value);
432     emit Burn(_who, _value);
433     emit Transfer(_who, address(0), _value);
434   }
435 }
436 
437 /**
438  * @title StandardBurn token
439  * @dev Add the burnFrom method to the ERC20 implementation.
440  */
441 
442 contract StandardBurnableToken is BurnableToken, StandardToken {
443 
444 /**
445 * @dev Destroy a specific number of token from target address and reduce the allowable amount.
446 * @param _from address token Owner address
447 * @param _value uint256 Number of destroyed token
448 */
449 
450   function burnFrom(address _from, uint256 _value) public {
451     require(_value <= allowed[_from][msg.sender]);
452     //Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
453     //This method requires triggering an event with updated approval.
454     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
455     _burn(_from, _value);
456   }
457 }
458 
459 contract MintableToken is StandardBurnableToken {
460   event Mint(address indexed to, uint256 amount);
461   event MintFinished();
462   bool public mintingFinished = false;
463   modifier canMint() {
464   require(!mintingFinished);
465   _;
466   }
467 
468 /**
469 * @dev Function to mint tokens
470 * @param _to The address that will receive the minted tokens.
471 * @param _amount The amount of tokens to mint.
472 * @return A boolean that indicates if the operation was successful.
473 */
474 
475   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
476     totalSupply_ = totalSupply_.add(_amount);
477     balances[_to] = balances[_to].add(_amount);
478     emit Mint(_to, _amount);
479     emit Transfer(address(0), _to, _amount);
480     return true;
481   }
482 
483 /**
484 * @dev Function to stop minting new tokens.
485 * @return True if the operation was successful.
486 */
487 
488   function finishMinting() onlyOwner canMint public returns (bool) {
489     mintingFinished = true;
490     emit MintFinished();
491     return true;
492   }
493 }
494 
495 contract CappedToken is MintableToken {
496   uint256 public cap;
497   constructor(uint256 _cap) public {
498   require(_cap > 0);
499   cap = _cap;
500   }
501 
502 /**
503 * @dev Function to mint tokens
504 * @param _to The address that will receive the minted tokens.
505 * @param _amount The amount of tokens to mint.
506 * @return A boolean that indicates if the operation was successful.
507 */
508    
509   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
510     require(totalSupply_.add(_amount) <= cap);
511     return super.mint(_to, _amount);
512   }
513 }
514 
515 contract PausableToken is StandardToken {
516 
517   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
518     return super.transfer(_to, _value);
519   }
520 
521   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
522     return super.transferFrom(_from, _to, _value);
523   }
524 
525   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
526     return super.approve(_spender, _value);
527   }
528 
529   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
530     return super.increaseApproval(_spender, _addedValue);
531   }
532 
533   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
534     return super.decreaseApproval(_spender, _subtractedValue);
535   }
536 }
537 
538 contract LT_Token is CappedToken, PausableToken {
539   string public constant name = "LittleBeeX® Token"; // solium-disable-line uppercase
540   string public constant symbol = "LT"; // solium-disable-line uppercase
541   uint8 public constant decimals = 18; // solium-disable-line uppercase
542   uint256 public constant INITIAL_SUPPLY = 0;
543   uint256 public constant MAX_SUPPLY = 50 * 10000 * 10000 * (10 ** uint256(decimals));
544 
545 /**
546 * @dev Constructor that gives msg.sender all of existing tokens.
547 */
548   
549   constructor() CappedToken(MAX_SUPPLY) public {
550     totalSupply_ = INITIAL_SUPPLY;
551     balances[msg.sender] = INITIAL_SUPPLY;
552     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
553   }
554 
555 /**
556 * @dev Function to mint tokens
557 * @param _to The address that will receive the minted tokens.
558 * @param _amount The amount of tokens to mint.
559 * @return A boolean that indicates if the operation was successful.
560 */
561   
562   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
563     return super.mint(_to, _amount);
564   }
565 
566 /**
567 * @dev Function to stop minting new tokens.
568 * @return True if the operation was successful.
569 */
570   
571   function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
572     return super.finishMinting();
573   }
574 
575 /**@dev Withdrawals from contracts can only be made to Owner.*/
576 
577   function withdraw (uint256 _amount) public returns (bool) {
578     require(msg.sender == owner);
579     msg.sender.transfer(_amount);
580     return true;
581   }
582 
583 //The fallback function.
584 
585   function() payable public {
586     revert();
587   }
588 }