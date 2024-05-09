1 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 
3 pragma solidity ^0.5.9;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value); 
16 
17 }
18 
19 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
20 
21 pragma solidity ^0.5.0;
22 
23 /**
24  * @dev Wrappers over Solidity's arithmetic operations with added overflow
25  * checks.
26  *
27  * Arithmetic operations in Solidity wrap on overflow. This can easily result
28  * in bugs, because programmers usually assume that an overflow raises an
29  * error, which is the standard behavior in high level programming languages.
30  * `SafeMath` restores this intuition by reverting the transaction when an
31  * operation overflows.
32  *
33  * Using this library instead of the unchecked operations eliminates an entire
34  * class of bugs, so it's recommended to use it always.
35  */
36 library SafeMath {
37     /**
38      * @dev Returns the addition of two unsigned integers, reverting on
39      * overflow.
40      *
41      * Counterpart to Solidity's `+` operator.
42      *
43      * Requirements:
44      * - Addition cannot overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a, "SafeMath: subtraction overflow");
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, "SafeMath: division by zero");
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0, "SafeMath: modulo by zero");
125         return a % b;
126     }
127 }
128 
129 // File: contracts\BasicToken.sol
130 
131 pragma solidity ^0.5.9;
132 
133 
134 
135 
136 /**
137  * @title Basic token
138  * @dev Basic version of StandardToken, with no allowances.
139  */
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) internal balances;
144 
145   uint256 internal totalSupply_;
146 
147   /**
148   * @dev Total number of tokens in existence
149   */
150   function totalSupply() public view returns (uint256) {
151     return totalSupply_;
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public returns (bool) {
160     require(_value <= balances[msg.sender]);
161     require(_to != address(0));
162 
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 // File: contracts\StandardToken.sol
181 
182 pragma solidity ^0.5.9;
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * https://github.com/ethereum/EIPs/issues/20
190  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196    event Approval(address indexed owner, address indexed spender, uint256 value);
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(
204     address _from,
205     address _to,
206     uint256 _value
207   )
208     public
209     returns (bool)
210   {
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213     require(_to != address(0));
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address _owner,
245     address _spender
246    )
247     public
248     view
249     returns (uint256)
250   {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(
264     address _spender,
265     uint256 _addedValue
266   )
267     public
268     returns (bool)
269   {
270     allowed[msg.sender][_spender] = (
271       allowed[msg.sender][_spender].add(_addedValue));
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint256 _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint256 oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue >= oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
305 
306 pragma solidity ^0.5.0;
307 
308 /**
309  * @dev Contract module which provides a basic access control mechanism, where
310  * there is an account (an owner) that can be granted exclusive access to
311  * specific functions.
312  *
313  * This module is used through inheritance. It will make available the modifier
314  * `onlyOwner`, which can be aplied to your functions to restrict their use to
315  * the owner.
316  */
317 contract Ownable {
318     address private _owner;
319 
320     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
321 
322     /**
323      * @dev Initializes the contract setting the deployer as the initial owner.
324      */
325     constructor () internal {
326         _owner = msg.sender;
327         emit OwnershipTransferred(address(0), _owner);
328     }
329 
330     /**
331      * @dev Returns the address of the current owner.
332      */
333     function owner() public view returns (address) {
334         return _owner;
335     }
336 
337     /**
338      * @dev Throws if called by any account other than the owner.
339      */
340     modifier onlyOwner() {
341         require(isOwner(), "Ownable: caller is not the owner");
342         _;
343     }
344 
345     /**
346      * @dev Returns true if the caller is the current owner.
347      */
348     function isOwner() public view returns (bool) {
349         return msg.sender == _owner;
350     }
351 
352     /**
353      * @dev Leaves the contract without owner. It will not be possible to call
354      * `onlyOwner` functions anymore. Can only be called by the current owner.
355      *
356      * > Note: Renouncing ownership will leave the contract without an owner,
357      * thereby removing any functionality that is only available to the owner.
358      */
359     function renounceOwnership() public onlyOwner {
360         emit OwnershipTransferred(_owner, address(0));
361         _owner = address(0);
362     }
363 
364     /**
365      * @dev Transfers ownership of the contract to a new account (`newOwner`).
366      * Can only be called by the current owner.
367      */
368     function transferOwnership(address newOwner) public onlyOwner {
369         _transferOwnership(newOwner);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      */
375     function _transferOwnership(address newOwner) internal {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         emit OwnershipTransferred(_owner, newOwner);
378         _owner = newOwner;
379     }
380 }
381 
382 // File: contracts\Pausable.sol
383 
384 pragma solidity ^0.5.9;
385 
386 
387 
388 /**
389  * @title Pausable
390  * @dev Base contract which allows children to implement an emergency stop mechanism.
391  */
392 contract Pausable is Ownable {
393   event Pause();
394   event Unpause();
395 
396   bool public paused = false;
397 
398 
399   /**
400    * @dev Modifier to make a function callable only when the contract is not paused.
401    */
402   modifier whenNotPaused() {
403     require(!paused);
404     _;
405   }
406 
407   /**
408    * @dev Modifier to make a function callable only when the contract is paused.
409    */
410   modifier whenPaused() {
411     require(paused);
412     _;
413   }
414 
415   /**
416    * @dev called by the owner to pause, triggers stopped state
417    */
418   function pause() public onlyOwner whenNotPaused {
419     paused = true;
420     emit Pause();
421   }
422 
423   /**
424    * @dev called by the owner to unpause, returns to normal state
425    */
426   function unpause() public onlyOwner whenPaused {
427     paused = false;
428     emit Unpause();
429   }
430 }
431 
432 // File: contracts\RozToken.sol
433 
434 pragma solidity ^0.5.9;
435 
436 
437                                         
438 contract RozToken is StandardToken, Pausable {
439 
440   string public name = "ROZEUS";
441   string public symbol = "ROZ";
442   uint8 public decimals = 8 ;
443   uint256 _totalSupply = 10000000000;  
444        
445   constructor() public {
446     totalSupply_ = _totalSupply * 10**uint(decimals);
447     
448     uint256 sale_fund = 2500000000 * 10**uint(decimals);
449     uint256 team_fund = 500000000 * 10**uint(decimals);
450     uint256 platform_fund = 4000000000 * 10**uint(decimals);
451     uint256 ecosystem_fund = 2000000000 * 10**uint(decimals);
452     uint256 bounty_fund = 1000000000 * 10**uint(decimals);
453 
454     balances[0x3B71AB34A2d5e28B5E3E2B6248D4D45D12f664CC] = sale_fund;
455     balances[0x297f0a58e006A121C7af4F7B4Dd8a98383DC402C] = team_fund;
456     balances[0x3dd7Ad80806F59dD62dfFd51c4D078c4AdbB048f] = platform_fund;
457     balances[0x93f77A45933A22FA4bc43A9ceE3D707d2E537E2a] = ecosystem_fund;
458     balances[0x16C5EB21D3441eF11815CFbF2B34861264F87924] = bounty_fund;
459     
460     emit Transfer(address(0), 0x3B71AB34A2d5e28B5E3E2B6248D4D45D12f664CC, sale_fund);
461     emit Transfer(address(0), 0x297f0a58e006A121C7af4F7B4Dd8a98383DC402C, team_fund);
462     emit Transfer(address(0), 0x3dd7Ad80806F59dD62dfFd51c4D078c4AdbB048f, platform_fund);
463     emit Transfer(address(0), 0x93f77A45933A22FA4bc43A9ceE3D707d2E537E2a, ecosystem_fund);
464     emit Transfer(address(0), 0x16C5EB21D3441eF11815CFbF2B34861264F87924, bounty_fund);
465   }  
466 
467   function transfer( address to, uint256 value ) public whenNotPaused returns (bool)  {   
468     return super.transfer(to, value);      
469   }
470 
471   function transferFrom(address from, address to, uint256 value ) public whenNotPaused returns (bool) {
472     return super.transferFrom(from, to, value);
473   }
474 
475   function approve(address spender, uint256 value ) public whenNotPaused returns (bool) {
476     return super.approve(spender, value);
477   }
478    
479   function increaseApproval( address _spender, uint256 _addedValue ) public whenNotPaused returns (bool)  {    
480     return super.increaseApproval(_spender, _addedValue);
481   }
482 
483   function decreaseApproval( address _spender, uint256 _subtractedValue ) public whenNotPaused returns (bool) {    
484     return super.decreaseApproval( _spender, _subtractedValue );
485   }
486 }