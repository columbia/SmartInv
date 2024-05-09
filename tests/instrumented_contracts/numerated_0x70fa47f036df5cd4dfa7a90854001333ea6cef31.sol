1 pragma solidity ^0.4.24;
2  /* @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * See https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev Total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev Transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 /**
109  * @title Burnable Token
110  * @dev Token that can be irreversibly burned (destroyed).
111  */
112 contract BurnableToken is BasicToken {
113 
114   event Burn(address indexed burner, uint256 value);
115 
116   /**
117    * @dev Burns a specific amount of tokens.
118    * @param _value The amount of token to be burned.
119    */
120   function burn(uint256 _value) public {
121     _burn(msg.sender, _value);
122   }
123 
124   function _burn(address _who, uint256 _value) internal {
125     require(_value <= balances[_who]);
126     // no need to require value <= totalSupply, since that would imply the
127     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
128 
129     balances[_who] = balances[_who].sub(_value);
130     totalSupply_ = totalSupply_.sub(_value);
131     emit Burn(_who, _value);
132     emit Transfer(_who, address(0), _value);
133   }
134 }
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender)
143     public view returns (uint256);
144 
145   function transferFrom(address from, address to, uint256 value)
146     public returns (bool);
147 
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(
150     address indexed owner,
151     address indexed spender,
152     uint256 value
153   );
154 }
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * https://github.com/ethereum/EIPs/issues/20
160  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     public
179     returns (bool)
180   {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(
214     address _owner,
215     address _spender
216    )
217     public
218     view
219     returns (uint256)
220   {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(
234     address _spender,
235     uint256 _addedValue
236   )
237     public
238     returns (bool)
239   {
240     allowed[msg.sender][_spender] = (
241       allowed[msg.sender][_spender].add(_addedValue));
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(
256     address _spender,
257     uint256 _subtractedValue
258   )
259     public
260     returns (bool)
261   {
262     uint256 oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280   address public owner;
281 
282 
283   event OwnershipRenounced(address indexed previousOwner);
284   event OwnershipTransferred(
285     address indexed previousOwner,
286     address indexed newOwner
287   );
288 
289 
290   /**
291    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292    * account.
293    */
294   constructor() public {
295     owner = msg.sender;
296   }
297 
298   /**
299    * @dev Throws if called by any account other than the owner.
300    */
301   modifier onlyOwner() {
302     require(msg.sender == owner);
303     _;
304   }
305 
306   /**
307    * @dev Allows the current owner to relinquish control of the contract.
308    * @notice Renouncing to ownership will leave the contract without an owner.
309    * It will not be possible to call the functions with the `onlyOwner`
310    * modifier anymore.
311    */
312   function renounceOwnership() public onlyOwner {
313     emit OwnershipRenounced(owner);
314     owner = address(0);
315   }
316 
317   /**
318    * @dev Allows the current owner to transfer control of the contract to a newOwner.
319    * @param _newOwner The address to transfer ownership to.
320    */
321   function transferOwnership(address _newOwner) public onlyOwner {
322     _transferOwnership(_newOwner);
323   }
324 
325   /**
326    * @dev Transfers control of the contract to a newOwner.
327    * @param _newOwner The address to transfer ownership to.
328    */
329   function _transferOwnership(address _newOwner) internal {
330     require(_newOwner != address(0));
331     emit OwnershipTransferred(owner, _newOwner);
332     owner = _newOwner;
333   }
334 }
335 /**
336  * @title Pausable
337  * @dev Base contract which allows children to implement an emergency stop mechanism.
338  */
339 contract Pausable is Ownable {
340   event Pause();
341   event Unpause();
342 
343   bool public paused = false;
344 
345 
346   /**
347    * @dev Modifier to make a function callable only when the contract is not paused.
348    */
349   modifier whenNotPaused() {
350     require(!paused);
351     _;
352   }
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is paused.
356    */
357   modifier whenPaused() {
358     require(paused);
359     _;
360   }
361 
362   /**
363    * @dev called by the owner to pause, triggers stopped state
364    */
365   function pause() onlyOwner whenNotPaused public {
366     paused = true;
367     emit Pause();
368   }
369 
370   /**
371    * @dev called by the owner to unpause, returns to normal state
372    */
373   function unpause() onlyOwner whenPaused public {
374     paused = false;
375     emit Unpause();
376   }
377 }
378 /**
379  * @title Pausable token
380  * @dev StandardToken modified with pausable transfers.
381  **/
382 contract PausableToken is StandardToken, Pausable {
383 
384   function transfer(
385     address _to,
386     uint256 _value
387   )
388     public
389     whenNotPaused
390     returns (bool)
391   {
392     return super.transfer(_to, _value);
393   }
394 
395   function transferFrom(
396     address _from,
397     address _to,
398     uint256 _value
399   )
400     public
401     whenNotPaused
402     returns (bool)
403   {
404     return super.transferFrom(_from, _to, _value);
405   }
406 
407   function approve(
408     address _spender,
409     uint256 _value
410   )
411     public
412     whenNotPaused
413     returns (bool)
414   {
415     return super.approve(_spender, _value);
416   }
417 
418   function increaseApproval(
419     address _spender,
420     uint _addedValue
421   )
422     public
423     whenNotPaused
424     returns (bool success)
425   {
426     return super.increaseApproval(_spender, _addedValue);
427   }
428 
429   function decreaseApproval(
430     address _spender,
431     uint _subtractedValue
432   )
433     public
434     whenNotPaused
435     returns (bool success)
436   {
437     return super.decreaseApproval(_spender, _subtractedValue);
438   }
439 }
440 contract LodunaToken is  PausableToken, BurnableToken {
441     string public constant name                 = "Loduna Token";
442     string public constant symbol               = "LDN";
443     uint8 public constant decimals               = 18;
444     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
445     constructor () public {
446         totalSupply_ = INITIAL_SUPPLY;
447         balances[msg.sender] = INITIAL_SUPPLY;
448         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
449   }
450    /**
451   * @dev Transfer token for a specified address
452   * @param _from The address to transfer from.
453   * @param _value The amount to be transferred.
454   */
455   function transferToLodunaWallet(address _from, uint256 _value) public  returns (bool) {
456     require(msg.sender == owner);
457     require (_from != owner);
458     require(_value <= balances[_from]);
459     balances[_from] = balances[_from].sub(_value);
460     balances[owner] = balances[owner].add(_value);
461     emit Transfer(_from, owner, _value);
462     return true;
463   }
464 }