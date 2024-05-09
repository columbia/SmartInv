1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-22
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 // File: contracts/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 // File: contracts/lifecycle/Pausable.sol
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused public {
104     paused = true;
105     emit Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     emit Unpause();
114   }
115 }
116 
117 // File: contracts/math/SafeMath.sol
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, throws on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
129     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
130     // benefit is lost if 'b' is also tested.
131     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
132     if (a == 0) {
133       return 0;
134     }
135 
136     c = a * b;
137     assert(c / a == b);
138     return c;
139   }
140 
141   /**
142   * @dev Integer division of two numbers, truncating the quotient.
143   */
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     // assert(b > 0); // Solidity automatically throws when dividing by 0
146     // uint256 c = a / b;
147     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148     return a / b;
149   }
150 
151   /**
152   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
153   */
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     assert(b <= a);
156     return a - b;
157   }
158 
159   /**
160   * @dev Adds two numbers, throws on overflow.
161   */
162   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
163     c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 }
168 
169 // File: contracts/ERC20/ERC20Basic.sol
170 
171 /**
172  * @title ERC20Basic
173  * @dev Simpler version of ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/179
175  */
176 contract ERC20Basic {
177   function totalSupply() public view returns (uint256);
178   function balanceOf(address who) public view returns (uint256);
179   function transfer(address to, uint256 value) public returns (bool);
180   event Transfer(address indexed from, address indexed to, uint256 value);
181 }
182 
183 // File: contracts/ERC20/BasicToken.sol
184 
185 /**
186  * @title Basic token
187  * @dev Basic version of StandardToken, with no allowances.
188  */
189 contract BasicToken is ERC20Basic {
190   using SafeMath for uint256;
191 
192   mapping(address => uint256) balances;
193 
194   uint256 totalSupply_;
195 
196   /**
197   * @dev Total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   /**
204   * @dev Transfer token for a specified address
205   * @param _to The address to transfer to.
206   * @param _value The amount to be transferred.
207   */
208   function transfer(address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[msg.sender]);
211 
212     balances[msg.sender] = balances[msg.sender].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     emit Transfer(msg.sender, _to, _value);
215     return true;
216   }
217 
218   /**
219   * @dev Gets the balance of the specified address.
220   * @param _owner The address to query the the balance of.
221   * @return An uint256 representing the amount owned by the passed address.
222   */
223   function balanceOf(address _owner) public view returns (uint256) {
224     return balances[_owner];
225   }
226 
227 }
228 
229 // File: contracts/ERC20/ERC20.sol
230 
231 /**
232  * @title ERC20 interface
233  * @dev see https://github.com/ethereum/EIPs/issues/20
234  */
235 contract ERC20 is ERC20Basic {
236   function allowance(address owner, address spender)
237     public view returns (uint256);
238 
239   function transferFrom(address from, address to, uint256 value)
240     public returns (bool);
241 
242   function approve(address spender, uint256 value) public returns (bool);
243   event Approval(
244     address indexed owner,
245     address indexed spender,
246     uint256 value
247   );
248 }
249 
250 // File: contracts/ERC20/StandardToken.sol
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * @dev https://github.com/ethereum/EIPs/issues/20
257  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract StandardToken is ERC20, BasicToken {
260 
261   mapping (address => mapping (address => uint256)) internal allowed;
262 
263 
264   /**
265    * @dev Transfer tokens from one address to another
266    * @param _from address The address which you want to send tokens from
267    * @param _to address The address which you want to transfer to
268    * @param _value uint256 the amount of tokens to be transferred
269    */
270   function transferFrom(
271     address _from,
272     address _to,
273     uint256 _value
274   )
275     public
276     returns (bool)
277   {
278     require(_to != address(0));
279     require(_value <= balances[_from]);
280     require(_value <= allowed[_from][msg.sender]);
281 
282     balances[_from] = balances[_from].sub(_value);
283     balances[_to] = balances[_to].add(_value);
284     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
285     emit Transfer(_from, _to, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291    *
292    * Beware that changing an allowance with this method brings the risk that someone may use both the old
293    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
294    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
295    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296    * @param _spender The address which will spend the funds.
297    * @param _value The amount of tokens to be spent.
298    */
299   function approve(address _spender, uint256 _value) public returns (bool) {
300     allowed[msg.sender][_spender] = _value;
301     emit Approval(msg.sender, _spender, _value);
302     return true;
303   }
304 
305   /**
306    * @dev Function to check the amount of tokens that an owner allowed to a spender.
307    * @param _owner address The address which owns the funds.
308    * @param _spender address The address which will spend the funds.
309    * @return A uint256 specifying the amount of tokens still available for the spender.
310    */
311   function allowance(
312     address _owner,
313     address _spender
314    )
315     public
316     view
317     returns (uint256)
318   {
319     return allowed[_owner][_spender];
320   }
321 
322   /**
323    * @dev Increase the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To increment
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _addedValue The amount of tokens to increase the allowance by.
331    */
332   function increaseApproval(
333     address _spender,
334     uint _addedValue
335   )
336     public
337     returns (bool)
338   {
339     allowed[msg.sender][_spender] = (
340       allowed[msg.sender][_spender].add(_addedValue));
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(
356     address _spender,
357     uint _subtractedValue
358   )
359     public
360     returns (bool)
361   {
362     uint oldValue = allowed[msg.sender][_spender];
363     if (_subtractedValue > oldValue) {
364       allowed[msg.sender][_spender] = 0;
365     } else {
366       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
367     }
368     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369     return true;
370   }
371 
372 }
373 
374 // File: contracts/ERC20/PausableToken.sol
375 
376 /**
377  * @title Pausable token
378  * @dev StandardToken modified with pausable transfers.
379  **/
380 contract PausableToken is StandardToken, Pausable {
381 
382   function transfer(
383     address _to,
384     uint256 _value
385   )
386     public
387     whenNotPaused
388     returns (bool)
389   {
390     return super.transfer(_to, _value);
391   }
392 
393   function transferFrom(
394     address _from,
395     address _to,
396     uint256 _value
397   )
398     public
399     whenNotPaused
400     returns (bool)
401   {
402     return super.transferFrom(_from, _to, _value);
403   }
404 
405   function approve(
406     address _spender,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.approve(_spender, _value);
414   }
415 
416   function increaseApproval(
417     address _spender,
418     uint _addedValue
419   )
420     public
421     whenNotPaused
422     returns (bool success)
423   {
424     return super.increaseApproval(_spender, _addedValue);
425   }
426 
427   function decreaseApproval(
428     address _spender,
429     uint _subtractedValue
430   )
431     public
432     whenNotPaused
433     returns (bool success)
434   {
435     return super.decreaseApproval(_spender, _subtractedValue);
436   }
437 }
438 
439 // File: contracts/BitMaxToken.sol
440 
441 contract BitMaxToken is PausableToken {
442     using SafeMath for uint256;
443 
444     string  public  constant name = "BitMax token";
445     string  public  constant symbol = "BTMX";
446     uint8   public  constant decimals = 18;
447     
448     mapping(address => bool) blacklisted;
449 
450     event Burn(address indexed burner, uint256 value);
451 
452     function changeBlacklist(address recipient, bool status) onlyOwner {
453         blacklisted[recipient] = status;
454     }
455     
456     function checkBlacklist(address recipient) public view returns (bool) {
457         return blacklisted[recipient];
458     }
459 
460     modifier isNotBlacklisted(address recipient) {
461         require(recipient != address(0x0));
462         require(recipient != address(this));
463         require(!blacklisted[recipient]);
464         _;
465     }
466 
467     constructor()  public {
468         // assign the total tokens
469         totalSupply_ = 780615274 * 10 ** 18;
470 
471         balances[msg.sender] = totalSupply_;
472         emit Transfer(address(0x0), msg.sender, totalSupply_);
473     }
474 
475     function transfer(address _to, uint _value) 
476         isNotBlacklisted(_to) 
477         isNotBlacklisted(msg.sender) 
478         public returns (bool) {
479         return super.transfer(_to, _value);
480     }
481 
482     function transferFrom(address _from, address _to, uint _value) 
483         isNotBlacklisted(_to) 
484         isNotBlacklisted(_from) 
485         public returns (bool) {
486         return super.transferFrom(_from, _to, _value);
487     }
488 
489     /**
490     * @dev Burns a specific amount of tokens.
491     * @param _value The amount of token to be burned.
492     */
493     function burn(uint256 _value) public {
494         _burn(msg.sender, _value);
495     }
496 
497     function _burn(address _who, uint256 _value) internal {
498         require(_value <= balances[_who]);
499         // no need to require value <= totalSupply, since that would imply the
500         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
501 
502         balances[_who] = balances[_who].sub(_value);
503         totalSupply_ = totalSupply_.sub(_value);
504         emit Burn(_who, _value);
505         emit Transfer(_who, address(0), _value);
506     }
507 }