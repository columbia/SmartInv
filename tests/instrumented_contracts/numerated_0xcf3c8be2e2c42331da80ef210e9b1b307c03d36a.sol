1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-09-01
7 */
8 
9 pragma solidity 0.5.8; 
10 
11 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address who) public view returns (uint256);
21     function transfer(address to, uint256 value) public returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations with added overflow
27  * checks.
28  *
29  * Arithmetic operations in Solidity wrap on overflow. This can easily result
30  * in bugs, because programmers usually assume that an overflow raises an
31  * error, which is the standard behavior in high level programming languages.
32  * `SafeMath` restores this intuition by reverting the transaction when an
33  * operation overflows.
34  *
35  * Using this library instead of the unchecked operations eliminates an entire
36  * class of bugs, so it's recommended to use it always.
37  */
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
70      * overflow (when the result is negative).
71      *
72      * Counterpart to Solidity's `-` operator.
73      *
74      * Requirements:
75      * - Subtraction cannot overflow.
76      *
77      * _Available since v2.4.0._
78      */
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      *
135      * _Available since v2.4.0._
136      */
137     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         // Solidity only automatically asserts when dividing by 0
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return mod(a, b, "SafeMath: modulo by zero");
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts with custom message when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      *
172      * _Available since v2.4.0._
173      */
174     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186     using SafeMath for uint256;
187 
188     mapping(address => uint256) balances;
189 
190     uint256 totalSupply_;
191 
192     /**
193     * @dev total number of tokens in existence
194     */
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198 
199     /**
200     * @dev transfer token for a specified address
201     * @param _to The address to transfer to.
202     * @param _value The amount to be transferred.
203     */
204     function transfer(address _to, uint256 _value) public returns (bool) {
205         require(_to != address(0));
206         require(_value <= balances[msg.sender]);
207 
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         return true;
212     }
213 
214     /**
215     * @dev Gets the balance of the specified address.
216     * @param _owner The address to query the the balance of.
217     * @return An uint256 representing the amount owned by the passed address.
218     */
219     function balanceOf(address _owner) public view returns (uint256) {
220         return balances[_owner];
221     }
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
232   function allowance(address owner, address spender) public view returns (uint256);
233   function transferFrom(address from, address to, uint256 value) public returns (bool);
234   function approve(address spender, uint256 value) public returns (bool);
235   event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     emit Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(address _owner, address _spender) public view returns (uint256) {
293     return allowed[_owner][_spender];
294   }
295 
296   /**
297    * @dev Increase the amount of tokens that an owner allowed to a spender.
298    *
299    * approve should be called when allowed[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _addedValue The amount of tokens to increase the allowance by.
305    */
306   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
307     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    *
315    * approve should be called when allowed[_spender] == 0. To decrement
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _subtractedValue The amount of tokens to decrease the allowance by.
321    */
322   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
323     uint oldValue = allowed[msg.sender][_spender];
324     if (_subtractedValue > oldValue) {
325       allowed[msg.sender][_spender] = 0;
326     } else {
327       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328     }
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333 }
334 
335 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
336 
337 /**
338  * @title Ownable
339  * @dev The Ownable contract has an owner address, and provides basic authorization control
340  * functions, this simplifies the implementation of "user permissions".
341  */
342 contract Ownable {
343   address public owner;
344 
345 
346   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
347 
348 
349   /**
350    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
351    * account.
352    */
353   constructor() public {
354     owner = msg.sender;
355   }
356 
357   /**
358    * @dev Throws if called by any account other than the owner.
359    */
360   modifier onlyOwner() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Allows the current owner to transfer control of the contract to a newOwner.
367    * @param newOwner The address to transfer ownership to.
368    */
369   function transferOwnership(address newOwner) public onlyOwner {
370     require(newOwner != address(0));
371     emit OwnershipTransferred(owner, newOwner);
372     owner = newOwner;
373   }
374 
375 }
376 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
377 
378 /**
379  * @title Capped token
380  * @dev Mintable token with a token cap.
381  */
382 contract CappedToken is StandardToken, Ownable{
383 
384     uint256 public cap;
385     address public distributionContract;
386     
387     constructor(uint256 _cap, address _distributionContract) public {
388         require(_cap > 0);
389         cap = _cap;
390         totalSupply_ = _cap;
391         distributionContract = _distributionContract;
392         balances[_distributionContract] = _cap;
393     }
394 
395 }
396 
397 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
398 
399 /**
400  * @title Pausable
401  * @dev Base contract which allows children to implement an emergency stop mechanism.
402  */
403 contract Pausable is Ownable {
404     event Pause();
405     event Unpause();
406 
407     bool public paused = false;
408 
409 
410     /**
411     * @dev Modifier to make a function callable only when the contract is not paused.
412     */
413     modifier whenNotPaused() {
414         require(!paused);
415         _;
416     }
417 
418     /**
419     * @dev Modifier to make a function callable only when the contract is paused.
420     */
421     modifier whenPaused() {
422         require(paused);
423         _;
424     }
425 
426     /**
427     * @dev called by the owner to pause, triggers stopped state
428     */
429     function pause() onlyOwner whenNotPaused public {
430         paused = true;
431         emit Pause();
432     }
433 
434     /**
435     * @dev called by the owner to unpause, returns to normal state
436     */
437     function unpause() onlyOwner whenPaused public {
438         paused = false;
439         emit Unpause();
440     }
441 }
442 
443 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
444 
445 /**
446  * @title Pausable token
447  * @dev StandardToken modified with pausable transfers.
448  **/
449 contract PausableToken is StandardToken, Pausable {
450 
451     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
452         return super.transfer(_to, _value);
453     }
454 
455     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
456         return super.transferFrom(_from, _to, _value);
457     }
458 
459     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
460         return super.approve(_spender, _value);
461     }
462 
463     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
464         return super.increaseApproval(_spender, _addedValue);
465     }
466 
467     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
468         return super.decreaseApproval(_spender, _subtractedValue);
469     }
470 }
471 
472 // File: contracts/BetProtocolToken.sol
473 
474 // This program is free software: you can redistribute it and/or modify
475 // it under the terms of the GNU General Public License as published by
476 // the Free Software Foundation, either version 3 of the License, or
477 // (at your option) any later version.
478 //
479 // This program is distributed in the hope that it will be useful,
480 // but WITHOUT ANY WARRANTY; without even the implied warranty of
481 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
482 // GNU General Public License for more details.
483 //
484 // You should have received a copy of the GNU General Public License
485 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
486 
487 
488 
489 contract BetProtocolToken is PausableToken, CappedToken {
490     string public name = "BetProtocolToken";
491     string public symbol = "BEPRO";
492     uint8 public decimals = 18;
493     address public distributionContractAddress;
494     //                10 billion <---------|   |-----------------> 10^18
495     uint256 constant TOTAL_CAP = 10000000000 * 1 ether;
496 
497     // FIXME: Here we've wanted to use constructor() keyword instead,
498     // but solium/solhint lint softwares don't parse it properly as of
499     // April 2018.
500     constructor(address _distributionContract) public CappedToken(TOTAL_CAP, _distributionContract) {
501         distributionContractAddress = _distributionContract;
502     }
503 }