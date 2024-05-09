1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
68 
69 /**
70  * @title Destructible
71  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
72  */
73 contract Destructible is Ownable {
74 
75   constructor() public payable { }
76 
77   /**
78    * @dev Transfers the current balance to the owner and terminates the contract.
79    */
80   function destroy() onlyOwner public {
81     selfdestruct(owner);
82   }
83 
84   function destroyAndSend(address _recipient) onlyOwner public {
85     selfdestruct(_recipient);
86   }
87 }
88 
89 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
90 
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97   address public pendingOwner;
98 
99   /**
100    * @dev Modifier throws if called by any account other than the pendingOwner.
101    */
102   modifier onlyPendingOwner() {
103     require(msg.sender == pendingOwner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to set the pendingOwner address.
109    * @param newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address newOwner) onlyOwner public {
112     pendingOwner = newOwner;
113   }
114 
115   /**
116    * @dev Allows the pendingOwner address to finalize the transfer.
117    */
118   function claimOwnership() onlyPendingOwner public {
119     emit OwnershipTransferred(owner, pendingOwner);
120     owner = pendingOwner;
121     pendingOwner = address(0);
122   }
123 }
124 
125 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     emit Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     emit Unpause();
168   }
169 }
170 
171 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
172 
173 /**
174  * @title ERC20Basic
175  * @dev Simpler version of ERC20 interface
176  * See https://github.com/ethereum/EIPs/issues/179
177  */
178 contract ERC20Basic {
179   function totalSupply() public view returns (uint256);
180   function balanceOf(address who) public view returns (uint256);
181   function transfer(address to, uint256 value) public returns (bool);
182   event Transfer(address indexed from, address indexed to, uint256 value);
183 }
184 
185 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
186 
187 /**
188  * @title SafeMath
189  * @dev Math operations with safety checks that throw on error
190  */
191 library SafeMath {
192 
193   /**
194   * @dev Multiplies two numbers, throws on overflow.
195   */
196   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
197     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
198     // benefit is lost if 'b' is also tested.
199     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
200     if (a == 0) {
201       return 0;
202     }
203 
204     c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers, truncating the quotient.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     // assert(b > 0); // Solidity automatically throws when dividing by 0
214     // uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216     return a / b;
217   }
218 
219   /**
220   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221   */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   /**
228   * @dev Adds two numbers, throws on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
231     c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
238 
239 /**
240  * @title Basic token
241  * @dev Basic version of StandardToken, with no allowances.
242  */
243 contract BasicToken is ERC20Basic {
244   using SafeMath for uint256;
245 
246   mapping(address => uint256) balances;
247 
248   uint256 totalSupply_;
249 
250   /**
251   * @dev Total number of tokens in existence
252   */
253   function totalSupply() public view returns (uint256) {
254     return totalSupply_;
255   }
256 
257   /**
258   * @dev Transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0));
264     require(_value <= balances[msg.sender]);
265 
266     balances[msg.sender] = balances[msg.sender].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     emit Transfer(msg.sender, _to, _value);
269     return true;
270   }
271 
272   /**
273   * @dev Gets the balance of the specified address.
274   * @param _owner The address to query the the balance of.
275   * @return An uint256 representing the amount owned by the passed address.
276   */
277   function balanceOf(address _owner) public view returns (uint256) {
278     return balances[_owner];
279   }
280 
281 }
282 
283 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
284 
285 /**
286  * @title ERC20 interface
287  * @dev see https://github.com/ethereum/EIPs/issues/20
288  */
289 contract ERC20 is ERC20Basic {
290   function allowance(address owner, address spender)
291     public view returns (uint256);
292 
293   function transferFrom(address from, address to, uint256 value)
294     public returns (bool);
295 
296   function approve(address spender, uint256 value) public returns (bool);
297   event Approval(
298     address indexed owner,
299     address indexed spender,
300     uint256 value
301   );
302 }
303 
304 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
305 
306 /**
307  * @title Standard ERC20 token
308  *
309  * @dev Implementation of the basic standard token.
310  * https://github.com/ethereum/EIPs/issues/20
311  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
312  */
313 contract StandardToken is ERC20, BasicToken {
314 
315   mapping (address => mapping (address => uint256)) internal allowed;
316 
317 
318   /**
319    * @dev Transfer tokens from one address to another
320    * @param _from address The address which you want to send tokens from
321    * @param _to address The address which you want to transfer to
322    * @param _value uint256 the amount of tokens to be transferred
323    */
324   function transferFrom(
325     address _from,
326     address _to,
327     uint256 _value
328   )
329     public
330     returns (bool)
331   {
332     require(_to != address(0));
333     require(_value <= balances[_from]);
334     require(_value <= allowed[_from][msg.sender]);
335 
336     balances[_from] = balances[_from].sub(_value);
337     balances[_to] = balances[_to].add(_value);
338     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339     emit Transfer(_from, _to, _value);
340     return true;
341   }
342 
343   /**
344    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
345    * Beware that changing an allowance with this method brings the risk that someone may use both the old
346    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
347    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
348    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349    * @param _spender The address which will spend the funds.
350    * @param _value The amount of tokens to be spent.
351    */
352   function approve(address _spender, uint256 _value) public returns (bool) {
353     allowed[msg.sender][_spender] = _value;
354     emit Approval(msg.sender, _spender, _value);
355     return true;
356   }
357 
358   /**
359    * @dev Function to check the amount of tokens that an owner allowed to a spender.
360    * @param _owner address The address which owns the funds.
361    * @param _spender address The address which will spend the funds.
362    * @return A uint256 specifying the amount of tokens still available for the spender.
363    */
364   function allowance(
365     address _owner,
366     address _spender
367    )
368     public
369     view
370     returns (uint256)
371   {
372     return allowed[_owner][_spender];
373   }
374 
375   /**
376    * @dev Increase the amount of tokens that an owner allowed to a spender.
377    * approve should be called when allowed[_spender] == 0. To increment
378    * allowed value is better to use this function to avoid 2 calls (and wait until
379    * the first transaction is mined)
380    * From MonolithDAO Token.sol
381    * @param _spender The address which will spend the funds.
382    * @param _addedValue The amount of tokens to increase the allowance by.
383    */
384   function increaseApproval(
385     address _spender,
386     uint256 _addedValue
387   )
388     public
389     returns (bool)
390   {
391     allowed[msg.sender][_spender] = (
392       allowed[msg.sender][_spender].add(_addedValue));
393     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
394     return true;
395   }
396 
397   /**
398    * @dev Decrease the amount of tokens that an owner allowed to a spender.
399    * approve should be called when allowed[_spender] == 0. To decrement
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _subtractedValue The amount of tokens to decrease the allowance by.
405    */
406   function decreaseApproval(
407     address _spender,
408     uint256 _subtractedValue
409   )
410     public
411     returns (bool)
412   {
413     uint256 oldValue = allowed[msg.sender][_spender];
414     if (_subtractedValue > oldValue) {
415       allowed[msg.sender][_spender] = 0;
416     } else {
417       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
418     }
419     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
420     return true;
421   }
422 
423 }
424 
425 /**
426  * Zil Roll Token is used to fund the initial capital of ZillRoll, a provably-fair
427  * and transparent dice gaming on the Zilliqa network. All profits (if any) shall be
428  * periodically and proportionately distributed between token holders.
429  */
430 contract ZilRollToken is StandardToken, Pausable, Claimable, Destructible {
431     string public constant name = "ZilRoll";
432     string public constant symbol = "ZLR";
433     uint8  public constant decimals = 18;
434     
435     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
436     
437     /**
438      * The listed addresses are not valid recipients of tokens.
439      *
440      * 0x0 - the zero address is not valid
441      * this - the contract itself should not receive tokens
442      * owner - the owner has all the initial tokens, but cannot receive any back
443      */
444     modifier validDestination(address to) {
445         require(to != address(0x0));
446         require(to != address(this));
447         require(to != owner);
448         _;
449     }
450     
451     modifier isTradeable() {
452         require(
453             !paused ||
454             msg.sender == owner
455         );
456         _;
457     }
458     
459     /**
460      * Constructor - instantiates token supply and allocates entire balance to the contract owner (msg.sender).
461      */
462     constructor() public {
463         // Mint all tokens
464         totalSupply_ = INITIAL_SUPPLY;
465         balances[msg.sender] = totalSupply_;
466         emit Transfer(address(0x0), msg.sender, totalSupply_);
467     }
468     
469     // ERC20 Methods
470 
471     function transfer(address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
472         return super.transfer(to, value);
473     }
474 
475     function transferFrom(address from, address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
476         return super.transferFrom(from, to, value);
477     }
478 
479     function approve(address spender, uint256 value) public isTradeable returns (bool) {
480         return super.approve(spender, value);
481     }
482 
483     function increaseApproval(address spender, uint addedValue) public isTradeable returns (bool) {
484         return super.increaseApproval(spender, addedValue);
485     }
486 
487     function decreaseApproval(address spender, uint subtractedValue) public isTradeable returns (bool) {
488         return super.decreaseApproval(spender, subtractedValue);
489     }
490     
491     // Token Drain
492     function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
493         // Owner can drain tokens that are sent here by mistake
494         token.transfer(owner, amount);
495     }
496 }