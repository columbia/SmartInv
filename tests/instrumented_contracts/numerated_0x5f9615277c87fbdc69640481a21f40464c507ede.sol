1 pragma solidity ^ 0.4 .24;
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
12    * @dev Multiplies two numbers, throws on overflow.
13    */
14   function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28    * @dev Integer division of two numbers, truncating the quotient.
29    */
30   function div(uint256 a, uint256 b) internal pure returns(uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39    */
40   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46    * @dev Adds two numbers, throws on overflow.
47    */
48   function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
56 
57 /**
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
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns(uint256);
128 
129   function balanceOf(address who) public view returns(uint256);
130 
131   function transfer(address to, uint256 value) public returns(bool);
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath
143   for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   uint256 totalSupply_;
148 
149   /**
150    * @dev Total number of tokens in existence
151    */
152   function totalSupply() public view returns(uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157    * @dev Transfer token for a specified address
158    * @param _to The address to transfer to.
159    * @param _value The amount to be transferred.
160    */
161   function transfer(address _to, uint256 _value) public returns(bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     emit Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Gets the balance of the specified address.
173    * @param _owner The address to query the the balance of.
174    * @return An uint256 representing the amount owned by the passed address.
175    */
176   function balanceOf(address _owner) public view returns(uint256) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 is ERC20Basic {
189   function allowance(address owner, address spender)
190   public view returns(uint256);
191 
192   function transferFrom(address from, address to, uint256 value)
193   public returns(bool);
194 
195   function approve(address spender, uint256 value) public returns(bool);
196   event Approval(
197     address indexed owner,
198     address indexed spender,
199     uint256 value
200   );
201 }
202 
203 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * https://github.com/ethereum/EIPs/issues/20
210  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping(address => mapping(address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(
224     address _from,
225     address _to,
226     uint256 _value
227   )
228   public
229   returns(bool) {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     emit Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param _spender The address which will spend the funds.
248    * @param _value The amount of tokens to be spent.
249    */
250   function approve(address _spender, uint256 _value) public returns(bool) {
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(
263     address _owner,
264     address _spender
265   )
266   public
267   view
268   returns(uint256) {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(
282     address _spender,
283     uint256 _addedValue
284   )
285   public
286   returns(bool) {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306   public
307   returns(bool) {
308     uint256 oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue > oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
321 
322 /**
323  * @title Pausable
324  * @dev Base contract which allows children to implement an emergency stop mechanism.
325  */
326 contract Pausable is Ownable {
327   event Pause();
328   event Unpause();
329 
330   bool public paused = false;
331 
332 
333   /**
334    * @dev Modifier to make a function callable only when the contract is not paused.
335    */
336   modifier whenNotPaused() {
337     require(!paused);
338     _;
339   }
340 
341   /**
342    * @dev Modifier to make a function callable only when the contract is paused.
343    */
344   modifier whenPaused() {
345     require(paused);
346     _;
347   }
348 
349   /**
350    * @dev called by the owner to pause, triggers stopped state
351    */
352   function pause() onlyOwner whenNotPaused public {
353     paused = true;
354     emit Pause();
355   }
356 
357   /**
358    * @dev called by the owner to unpause, returns to normal state
359    */
360   function unpause() onlyOwner whenPaused public {
361     paused = false;
362     emit Unpause();
363   }
364 }
365 
366 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
367 
368 /**
369  * @title Pausable token
370  * @dev StandardToken modified with pausable transfers.
371  **/
372 contract PausableToken is StandardToken, Pausable {
373 
374   function transfer(
375     address _to,
376     uint256 _value
377   )
378   public
379   whenNotPaused
380   returns(bool) {
381     return super.transfer(_to, _value);
382   }
383 
384   function transferFrom(
385     address _from,
386     address _to,
387     uint256 _value
388   )
389   public
390   whenNotPaused
391   returns(bool) {
392     return super.transferFrom(_from, _to, _value);
393   }
394 
395   function approve(
396     address _spender,
397     uint256 _value
398   )
399   public
400   whenNotPaused
401   returns(bool) {
402     return super.approve(_spender, _value);
403   }
404 
405   function increaseApproval(
406     address _spender,
407     uint _addedValue
408   )
409   public
410   whenNotPaused
411   returns(bool success) {
412     return super.increaseApproval(_spender, _addedValue);
413   }
414 
415   function decreaseApproval(
416     address _spender,
417     uint _subtractedValue
418   )
419   public
420   whenNotPaused
421   returns(bool success) {
422     return super.decreaseApproval(_spender, _subtractedValue);
423   }
424 }
425 
426 // File: contracts\TopPlayerToken.sol
427 
428 /*****************************************************************************
429  *
430  *Copyright 2018 TopPlayer
431  *
432  *Licensed under the Apache License, Version 2.0 (the "License");
433  *you may not use this file except in compliance with the License.
434  *You may obtain a copy of the License at
435  *
436  *    http://www.apache.org/licenses/LICENSE-2.0
437  *
438  *Unless required by applicable law or agreed to in writing, software
439  *distributed under the License is distributed on an "AS IS" BASIS,
440  *WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
441  *See the License for the specific language governing permissions and
442  *limitations under the License.
443  *
444  *****************************************************************************/
445 
446 contract TopPlayerTestToken is PausableToken {
447   using SafeMath
448   for uint256;
449 
450   // ERC20 constants
451   string public name = "Top Players Mother Token Test";
452   string public symbol = "TPMT Test";
453   string public standard = "ERC20";
454 
455   uint8 public constant decimals = 18; // solium-disable-line uppercase
456 
457   uint256 public constant INITIAL_SUPPLY = 20 * (10 ** 8) * (10 ** 18);
458 
459   event ReleaseTarget(address target);
460 
461   mapping(address => TimeLock[]) public allocations;
462 
463   address[] public receiptors;
464 
465   address[] public froms;
466   address[] public tos;
467   uint[] public timess;
468   uint256[] public balancess;
469   uint[] public createTimes;
470 
471   struct TimeLock {
472     uint time;
473     uint256 balance;
474     uint createTime;
475   }
476 
477   /*Here is the constructor function that is executed when the instance is created*/
478   constructor() public {
479     totalSupply_ = INITIAL_SUPPLY;
480     balances[msg.sender] = INITIAL_SUPPLY;
481     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
482   }
483 
484   function getAllocations() public view returns(address[], address[],  uint[], uint256[], uint[]){
485     getInfos();
486     return (froms, tos, timess, balancess, createTimes); 
487   }
488 
489   /**
490    * @dev transfer token for a specified address if transfer is open
491    * @param _to The address to transfer to.
492    * @param _value The amount to be transferred.
493    */
494   function transfer(address _to, uint256 _value) public returns(bool) {
495     require(canSubAllocation(msg.sender, _value));
496 
497     subAllocation(msg.sender);
498 
499     return super.transfer(_to, _value);
500   }
501 
502   function canSubAllocation(address sender, uint256 sub_value) private constant returns(bool) {
503     if (sub_value == 0) {
504       return false;
505     }
506 
507     if (balances[sender] < sub_value) {
508       return false;
509     }
510 
511     uint256 alllock_sum = 0;
512     for (uint j = 0; j < allocations[sender].length; j++) {
513       if (allocations[sender][j].time >= block.timestamp) {
514         alllock_sum = alllock_sum.add(allocations[sender][j].balance);
515       }
516     }
517 
518     uint256 can_unlock = balances[sender].sub(alllock_sum);
519 
520     return can_unlock >= sub_value;
521   }
522 
523   function subAllocation(address sender) private {
524     for (uint j = 0; j < allocations[sender].length; j++) {
525       if (allocations[sender][j].time < block.timestamp) {
526         allocations[sender][j].balance = 0;
527       }
528     }
529   }
530 
531   function setAllocation(address _address, uint256 total_value, uint time, uint256 balanceRequire) public onlyOwner returns(bool) {
532     uint256 sum = 0;
533     sum = sum.add(balanceRequire);
534 
535     require(total_value >= sum);
536 
537     require(balances[msg.sender] >= sum);
538 
539     uint256 createTime;
540 
541     if(allocations[_address].length == 0){
542       receiptors.push(_address);
543     }
544 
545     bool find = false;
546 
547     for (uint j = 0; j < allocations[_address].length; j++) {
548       if (allocations[_address][j].time == time) {
549         allocations[_address][j].balance = allocations[_address][j].balance.add(balanceRequire);
550         find = true;
551         break;
552       }
553     }
554 
555     if (!find) {
556       createTime = now;
557       allocations[_address].push(TimeLock(time, balanceRequire, createTime));
558     }
559 
560     bool result = super.transfer(_address, total_value);
561 
562     emit Transferred(msg.sender, _address, createTime, total_value, time);
563 
564     return result;
565   }
566 
567   function releaseAllocation(address target) public onlyOwner {
568     require(balances[target] > 0);
569 
570     for (uint j = 0; j < allocations[target].length; j++) {
571       allocations[target][j].balance = 0;
572     }
573 
574     emit ReleaseTarget(target);
575   }
576 
577   event Transferred(address from, address to, uint256 createAt, uint256 total_value, uint time);
578 
579   function getInfos() public {
580     if (msg.sender == owner){
581       for (uint i=0; i<receiptors.length; i++){
582         for (uint j=0; j<allocations[receiptors[i]].length; j++){
583           froms.push(owner);
584           tos.push(receiptors[i]);
585           timess.push(allocations[receiptors[i]][j].time);
586           balancess.push(allocations[receiptors[i]][j].balance);
587           createTimes.push(allocations[receiptors[i]][j].createTime);
588         }
589       }
590     }else{
591       for (uint k=0; k<allocations[msg.sender].length; k++){
592         froms.push(owner);
593         tos.push(msg.sender);
594         timess.push(allocations[msg.sender][k].time);
595         balancess.push(allocations[msg.sender][k].balance);
596         createTimes.push(allocations[msg.sender][k].createTime);
597       }
598     }
599   }
600 }