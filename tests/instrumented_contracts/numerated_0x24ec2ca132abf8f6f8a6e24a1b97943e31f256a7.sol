1 pragma solidity 0.5.8; 
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, reverting on
33      * overflow.
34      *
35      * Counterpart to Solidity's `+` operator.
36      *
37      * Requirements:
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      *
69      * _Available since v2.4.0._
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      *
127      * _Available since v2.4.0._
128      */
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      *
164      * _Available since v2.4.0._
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
172 
173 /**
174  * @title Basic token
175  * @dev Basic version of StandardToken, with no allowances.
176  */
177 contract BasicToken is ERC20Basic {
178     using SafeMath for uint256;
179 
180     mapping(address => uint256) balances;
181 
182     uint256 totalSupply_;
183 
184     /**
185     * @dev total number of tokens in existence
186     */
187     function totalSupply() public view returns (uint256) {
188         return totalSupply_;
189     }
190 
191     /**
192     * @dev transfer token for a specified address
193     * @param _to The address to transfer to.
194     * @param _value The amount to be transferred.
195     */
196     function transfer(address _to, uint256 _value) public returns (bool) {
197         require(_to != address(0));
198         require(_value <= balances[msg.sender]);
199 
200         balances[msg.sender] = balances[msg.sender].sub(_value);
201         balances[_to] = balances[_to].add(_value);
202         emit Transfer(msg.sender, _to, _value);
203         return true;
204     }
205 
206     /**
207     * @dev Gets the balance of the specified address.
208     * @param _owner The address to query the the balance of.
209     * @return An uint256 representing the amount owned by the passed address.
210     */
211     function balanceOf(address _owner) public view returns (uint256) {
212         return balances[_owner];
213     }
214 
215 }
216 
217 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
218 
219 /**
220  * @title ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/20
222  */
223 contract ERC20 is ERC20Basic {
224   function allowance(address owner, address spender) public view returns (uint256);
225   function transferFrom(address from, address to, uint256 value) public returns (bool);
226   function approve(address spender, uint256 value) public returns (bool);
227   event Approval(address indexed owner, address indexed spender, uint256 value);
228 }
229 
230 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * @dev https://github.com/ethereum/EIPs/issues/20
237  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
251     require(_to != address(0));
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    *
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender The address which will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    */
272   function approve(address _spender, uint256 _value) public returns (bool) {
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(address _owner, address _spender) public view returns (uint256) {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
299     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
315     uint oldValue = allowed[msg.sender][_spender];
316     if (_subtractedValue > oldValue) {
317       allowed[msg.sender][_spender] = 0;
318     } else {
319       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320     }
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325 }
326 
327 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
328 
329 /**
330  * @title Ownable
331  * @dev The Ownable contract has an owner address, and provides basic authorization control
332  * functions, this simplifies the implementation of "user permissions".
333  */
334 contract Ownable {
335   address public owner;
336 
337 
338   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
339 
340 
341   /**
342    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
343    * account.
344    */
345   constructor() public {
346     owner = msg.sender;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Allows the current owner to transfer control of the contract to a newOwner.
359    * @param newOwner The address to transfer ownership to.
360    */
361   function transferOwnership(address newOwner) public onlyOwner {
362     require(newOwner != address(0));
363     emit OwnershipTransferred(owner, newOwner);
364     owner = newOwner;
365   }
366 
367 }
368 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
369 
370 /**
371  * @title Capped token
372  * @dev Mintable token with a token cap.
373  */
374 contract CappedToken is StandardToken, Ownable{
375 
376     uint256 public cap;
377     address public distributionContract;
378 
379     constructor(uint256 _cap, 
380     address _distributionContract
381     ) public {
382         require(_cap > 0);
383         cap = _cap;
384         totalSupply_ = _cap;
385 
386         distributionContract = _distributionContract;
387 
388         balances[_distributionContract] =  _cap;
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
483 contract DotmoovsToken is PausableToken, CappedToken {
484     string public name = "dotmoovs";
485     string public symbol = "MOOV";
486     uint8 public decimals = 18;
487     // 1 Billion
488     uint256 constant TOTAL_CAP = 1000000000 * 1 ether;
489 
490     constructor(
491         address _distributionContract
492         ) public CappedToken(TOTAL_CAP, _distributionContract) {
493 
494     }
495 }