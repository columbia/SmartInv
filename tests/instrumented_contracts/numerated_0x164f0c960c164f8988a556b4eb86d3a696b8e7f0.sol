1 pragma solidity ^0.4.24;
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
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
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
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address _newOwner) public onlyOwner {
93     _transferOwnership(_newOwner);
94   }
95 
96   /**
97    * @dev Transfers control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function _transferOwnership(address _newOwner) internal {
101     require(_newOwner != address(0));
102     emit OwnershipTransferred(owner, _newOwner);
103     owner = _newOwner;
104   }
105 }
106 
107 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
108 
109 /**
110  * @title ERC20Basic
111  * @dev Simpler version of ERC20 interface
112  * See https://github.com/ethereum/EIPs/issues/179
113  */
114 contract ERC20Basic {
115   function totalSupply() public view returns (uint256);
116   function balanceOf(address who) public view returns (uint256);
117   function transfer(address to, uint256 value) public returns (bool);
118   event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev Total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender)
175     public view returns (uint256);
176 
177   function transferFrom(address from, address to, uint256 value)
178     public returns (bool);
179 
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(
182     address indexed owner,
183     address indexed spender,
184     uint256 value
185   );
186 }
187 
188 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/issues/20
195  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     emit Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(
249     address _owner,
250     address _spender
251    )
252     public
253     view
254     returns (uint256)
255   {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(
269     address _spender,
270     uint256 _addedValue
271   )
272     public
273     returns (bool)
274   {
275     allowed[msg.sender][_spender] = (
276       allowed[msg.sender][_spender].add(_addedValue));
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint256 _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint256 oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue >= oldValue) {
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
309 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
310 
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318 
319   bool public paused = false;
320 
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is not paused.
324    */
325   modifier whenNotPaused() {
326     require(!paused);
327     _;
328   }
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is paused.
332    */
333   modifier whenPaused() {
334     require(paused);
335     _;
336   }
337 
338   /**
339    * @dev called by the owner to pause, triggers stopped state
340    */
341   function pause() onlyOwner whenNotPaused public {
342     paused = true;
343     emit Pause();
344   }
345 
346   /**
347    * @dev called by the owner to unpause, returns to normal state
348    */
349   function unpause() onlyOwner whenPaused public {
350     paused = false;
351     emit Unpause();
352   }
353 }
354 
355 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
356 
357 /**
358  * @title Pausable token
359  * @dev StandardToken modified with pausable transfers.
360  **/
361 contract PausableToken is StandardToken, Pausable {
362 
363   function transfer(
364     address _to,
365     uint256 _value
366   )
367     public
368     whenNotPaused
369     returns (bool)
370   {
371     return super.transfer(_to, _value);
372   }
373 
374   function transferFrom(
375     address _from,
376     address _to,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.transferFrom(_from, _to, _value);
384   }
385 
386   function approve(
387     address _spender,
388     uint256 _value
389   )
390     public
391     whenNotPaused
392     returns (bool)
393   {
394     return super.approve(_spender, _value);
395   }
396 
397   function increaseApproval(
398     address _spender,
399     uint _addedValue
400   )
401     public
402     whenNotPaused
403     returns (bool success)
404   {
405     return super.increaseApproval(_spender, _addedValue);
406   }
407 
408   function decreaseApproval(
409     address _spender,
410     uint _subtractedValue
411   )
412     public
413     whenNotPaused
414     returns (bool success)
415   {
416     return super.decreaseApproval(_spender, _subtractedValue);
417   }
418 }
419 
420 // File: contracts\USDollarHKex.sol
421 
422 /*****************************************************************************
423  *
424  *Copyright 2018 USDollarHKex
425  *
426  *Licensed under the Apache License, Version 2.0 (the "License");
427  *you may not use this file except in compliance with the License.
428  *You may obtain a copy of the License at
429  *
430  *    http://www.apache.org/licenses/LICENSE-2.0
431  *
432  *Unless required by applicable law or agreed to in writing, software
433  *distributed under the License is distributed on an "AS IS" BASIS,
434  *WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
435  *See the License for the specific language governing permissions and
436  *limitations under the License.
437  *
438  *****************************************************************************/
439 
440 contract USDollarHKex is PausableToken
441 {
442   using SafeMath for uint256;
443   
444   // ERC20 constants
445   string public name="USDollarHKex";
446   string public symbol="USDHK";
447   string public standard="ERC20";
448   
449   uint8 public constant decimals = 18; // solium-disable-line uppercase
450   
451   uint256 public constant INITIAL_SUPPLY = 25 *(10**8)*(10 ** uint256(decimals));
452   
453   event NewLock(address indexed target,uint256 indexed locktime,uint256 lockamount);
454   event UnLock(address indexed target,uint256 indexed unlocktime,uint256 unlockamount);
455     
456   mapping(address => TimeLock[]) public allocations;
457   
458   struct TimeLock
459   {
460       uint256 releaseTime;
461       uint256 balance;
462   }
463 
464   /*Here is the constructor function that is executed when the instance is created*/
465   constructor() public 
466   {
467     totalSupply_ = INITIAL_SUPPLY;
468     balances[msg.sender] = INITIAL_SUPPLY;
469     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
470   }
471 
472   function transfer(address _to, uint256 _value) public returns (bool) 
473   {
474       require(canSubAllocation(msg.sender, _value));
475     
476       subAllocation(msg.sender);
477     
478       return super.transfer(_to, _value); 
479   }
480 
481   function transferFrom(address _from, address _to,uint256 _value) public returns (bool)
482   {
483       require(canSubAllocation(_from, _value));
484 
485       subAllocation(_from);
486 
487       return super.transferFrom(_from,_to, _value); 
488   }
489 
490   function canSubAllocation(address sender, uint256 sub_value) constant private returns (bool)
491   {
492       if (sub_value==0)
493       {
494           return false;
495       }
496       
497       if (balances[sender] < sub_value)
498       {
499           return false;
500       }
501 
502       if (allocations[sender].length == 0)
503       {
504           return true;
505       }
506       
507       uint256 alllock_sum = 0;
508       for (uint j=0; j<allocations[sender].length; j++)
509       {
510           if (allocations[sender][j].releaseTime >= block.timestamp)
511           {
512               alllock_sum = alllock_sum.add(allocations[sender][j].balance);
513           }
514       }
515       
516       uint256 can_unlock = balances[sender].sub(alllock_sum);
517       
518       return can_unlock >= sub_value;
519   }
520 
521   function subAllocation(address sender) private
522   {
523       uint256 total_lockamount = 0;
524       uint256 total_unlockamount = 0;
525       for (uint j=0; j<allocations[sender].length; j++)
526       {
527           if (allocations[sender][j].releaseTime < block.timestamp)
528           {
529               total_unlockamount = total_unlockamount.add(allocations[sender][j].balance);
530               allocations[sender][j].balance = 0;
531           }
532           else
533           {
534               total_lockamount = total_lockamount.add(allocations[sender][j].balance);
535           }
536       }
537 
538       if (total_unlockamount > 0)
539       {
540         emit UnLock(sender, block.timestamp, total_unlockamount);
541       }
542       
543       if(total_lockamount == 0 && allocations[sender].length > 0)
544       {
545           delete allocations[sender];
546       }
547   }
548 
549   function setAllocation(address _address, uint256 total_value, uint[] times, uint256[] balanceRequires) public onlyOwner returns (bool)
550   {
551       require(times.length == balanceRequires.length);
552       require(balances[msg.sender]>=total_value);   
553       uint256 sum = 0;
554       for (uint x=0; x<balanceRequires.length; x++)
555       {
556           require(balanceRequires[x]>0);
557           sum = sum.add(balanceRequires[x]);
558       }
559       
560       require(total_value >= sum);
561 
562       for (uint i=0; i<times.length; i++)
563       {
564           bool find = false;
565           
566           for (uint j=0; j<allocations[_address].length; j++)
567           {
568               if (allocations[_address][j].releaseTime == times[i])
569               {
570                   allocations[_address][j].balance = allocations[_address][j].balance.add(balanceRequires[i]);
571                   find = true;
572                   break;
573               }
574           }
575           
576           if (!find)
577           {
578               allocations[_address].push(TimeLock(times[i], balanceRequires[i]));
579           }
580       }
581 
582       emit NewLock(_address, block.timestamp, sum);
583       
584       return super.transfer(_address, total_value); 
585   }
586 }