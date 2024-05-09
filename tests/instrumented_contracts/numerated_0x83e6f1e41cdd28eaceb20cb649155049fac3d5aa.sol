1 /**
2  *Submitted for verification at Etherscan.io on 2018-09-01
3 */
4 
5 pragma solidity 0.5.8; 
6 
7 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15     function totalSupply() public view returns (uint256);
16     function balanceOf(address who) public view returns (uint256);
17     function transfer(address to, uint256 value) public returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @dev Wrappers over Solidity's arithmetic operations with added overflow
23  * checks.
24  *
25  * Arithmetic operations in Solidity wrap on overflow. This can easily result
26  * in bugs, because programmers usually assume that an overflow raises an
27  * error, which is the standard behavior in high level programming languages.
28  * `SafeMath` restores this intuition by reverting the transaction when an
29  * operation overflows.
30  *
31  * Using this library instead of the unchecked operations eliminates an entire
32  * class of bugs, so it's recommended to use it always.
33  */
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting on
37      * overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      *
73      * _Available since v2.4.0._
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      * - The divisor cannot be zero.
115      */
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return div(a, b, "SafeMath: division by zero");
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      *
131      * _Available since v2.4.0._
132      */
133     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         // Solidity only automatically asserts when dividing by 0
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return mod(a, b, "SafeMath: modulo by zero");
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts with custom message when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      *
168      * _Available since v2.4.0._
169      */
170     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 }
175 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
176 
177 /**
178  * @title Basic token
179  * @dev Basic version of StandardToken, with no allowances.
180  */
181 contract BasicToken is ERC20Basic {
182     using SafeMath for uint256;
183 
184     mapping(address => uint256) balances;
185 
186     uint256 totalSupply_;
187 
188     /**
189     * @dev total number of tokens in existence
190     */
191     function totalSupply() public view returns (uint256) {
192         return totalSupply_;
193     }
194 
195     /**
196     * @dev transfer token for a specified address
197     * @param _to The address to transfer to.
198     * @param _value The amount to be transferred.
199     */
200     function transfer(address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[msg.sender]);
203 
204         balances[msg.sender] = balances[msg.sender].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         emit Transfer(msg.sender, _to, _value);
207         return true;
208     }
209 
210     /**
211     * @dev Gets the balance of the specified address.
212     * @param _owner The address to query the the balance of.
213     * @return An uint256 representing the amount owned by the passed address.
214     */
215     function balanceOf(address _owner) public view returns (uint256) {
216         return balances[_owner];
217     }
218 
219 }
220 
221 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
222 
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20 is ERC20Basic {
228   function allowance(address owner, address spender) public view returns (uint256);
229   function transferFrom(address from, address to, uint256 value) public returns (bool);
230   function approve(address spender, uint256 value) public returns (bool);
231   event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
235 
236 /**
237  * @title Standard ERC20 token
238  *
239  * @dev Implementation of the basic standard token.
240  * @dev https://github.com/ethereum/EIPs/issues/20
241  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
242  */
243 contract StandardToken is ERC20, BasicToken {
244 
245   mapping (address => mapping (address => uint256)) internal allowed;
246 
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param _from address The address which you want to send tokens from
251    * @param _to address The address which you want to transfer to
252    * @param _value uint256 the amount of tokens to be transferred
253    */
254   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
255     require(_to != address(0));
256     require(_value <= balances[_from]);
257     require(_value <= allowed[_from][msg.sender]);
258 
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
268    *
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param _spender The address which will spend the funds.
274    * @param _value The amount of tokens to be spent.
275    */
276   function approve(address _spender, uint256 _value) public returns (bool) {
277     allowed[msg.sender][_spender] = _value;
278     emit Approval(msg.sender, _spender, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Function to check the amount of tokens that an owner allowed to a spender.
284    * @param _owner address The address which owns the funds.
285    * @param _spender address The address which will spend the funds.
286    * @return A uint256 specifying the amount of tokens still available for the spender.
287    */
288   function allowance(address _owner, address _spender) public view returns (uint256) {
289     return allowed[_owner][_spender];
290   }
291 
292   /**
293    * @dev Increase the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _addedValue The amount of tokens to increase the allowance by.
301    */
302   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
303     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308   /**
309    * @dev Decrease the amount of tokens that an owner allowed to a spender.
310    *
311    * approve should be called when allowed[_spender] == 0. To decrement
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _subtractedValue The amount of tokens to decrease the allowance by.
317    */
318   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
319     uint oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue > oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329 }
330 
331 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
332 
333 /**
334  * @title Ownable
335  * @dev The Ownable contract has an owner address, and provides basic authorization control
336  * functions, this simplifies the implementation of "user permissions".
337  */
338 contract Ownable {
339   address public owner;
340 
341 
342   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
343 
344 
345   /**
346    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
347    * account.
348    */
349   constructor() public {
350     owner = msg.sender;
351   }
352 
353   /**
354    * @dev Throws if called by any account other than the owner.
355    */
356   modifier onlyOwner() {
357     require(msg.sender == owner);
358     _;
359   }
360 
361   /**
362    * @dev Allows the current owner to transfer control of the contract to a newOwner.
363    * @param newOwner The address to transfer ownership to.
364    */
365   function transferOwnership(address newOwner) public onlyOwner {
366     require(newOwner != address(0));
367     emit OwnershipTransferred(owner, newOwner);
368     owner = newOwner;
369   }
370 
371 }
372 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
373 
374 /**
375  * @title Capped token
376  * @dev Mintable token with a token cap.
377  */
378 contract CappedToken is StandardToken, Ownable{
379 
380     uint256 public cap;
381     address public distributionContract;
382     
383     constructor(uint256 _cap, address _distributionContract) public {
384         require(_cap > 0);
385         cap = _cap;
386         totalSupply_ = _cap;
387         distributionContract = _distributionContract;
388         balances[_distributionContract] = _cap;
389     }
390 
391 }
392 
393 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
394 
395 /**
396  * @title Pausable
397  * @dev Base contract which allows children to implement an emergency stop mechanism.
398  */
399 contract Pausable is Ownable {
400     event Pause();
401     event Unpause();
402 
403     bool public paused = false;
404 
405 
406     /**
407     * @dev Modifier to make a function callable only when the contract is not paused.
408     */
409     modifier whenNotPaused() {
410         require(!paused);
411         _;
412     }
413 
414     /**
415     * @dev Modifier to make a function callable only when the contract is paused.
416     */
417     modifier whenPaused() {
418         require(paused);
419         _;
420     }
421 
422     /**
423     * @dev called by the owner to pause, triggers stopped state
424     */
425     function pause() onlyOwner whenNotPaused public {
426         paused = true;
427         emit Pause();
428     }
429 
430     /**
431     * @dev called by the owner to unpause, returns to normal state
432     */
433     function unpause() onlyOwner whenPaused public {
434         paused = false;
435         emit Unpause();
436     }
437 }
438 
439 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
440 
441 /**
442  * @title Pausable token
443  * @dev StandardToken modified with pausable transfers.
444  **/
445 contract PausableToken is StandardToken, Pausable {
446 
447     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
448         return super.transfer(_to, _value);
449     }
450 
451     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
452         return super.transferFrom(_from, _to, _value);
453     }
454 
455     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
456         return super.approve(_spender, _value);
457     }
458 
459     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
460         return super.increaseApproval(_spender, _addedValue);
461     }
462 
463     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
464         return super.decreaseApproval(_spender, _subtractedValue);
465     }
466 }
467 
468 // This program is free software: you can redistribute it and/or modify
469 // it under the terms of the GNU General Public License as published by
470 // the Free Software Foundation, either version 3 of the License, or
471 // (at your option) any later version.
472 //
473 // This program is distributed in the hope that it will be useful,
474 // but WITHOUT ANY WARRANTY; without even the implied warranty of
475 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
476 // GNU General Public License for more details.
477 //
478 // You should have received a copy of the GNU General Public License
479 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
480 
481 
482 
483 contract PolkastarterToken is PausableToken, CappedToken {
484     string public name = "PolkastarterToken";
485     string public symbol = "POLS";
486     uint8 public decimals = 18;
487     address public distributionContractAddress;
488     // 100 Million <---------|   |-----------------> 10^18
489     uint256 constant TOTAL_CAP = 100000000 * 1 ether;
490 
491     constructor(address _distributionContract) public CappedToken(TOTAL_CAP, _distributionContract) {
492         distributionContractAddress = _distributionContract;
493     }
494 }