1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();
316 
317   bool public paused = false;
318 
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     emit Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     emit Unpause();
350   }
351 }
352 
353 /**
354  * @title Pausable token
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 contract PausableToken is StandardToken, Pausable {
358 
359   function transfer(
360     address _to,
361     uint256 _value
362   )
363     public
364     whenNotPaused
365     returns (bool)
366   {
367     return super.transfer(_to, _value);
368   }
369 
370   function transferFrom(
371     address _from,
372     address _to,
373     uint256 _value
374   )
375     public
376     whenNotPaused
377     returns (bool)
378   {
379     return super.transferFrom(_from, _to, _value);
380   }
381 
382   function approve(
383     address _spender,
384     uint256 _value
385   )
386     public
387     whenNotPaused
388     returns (bool)
389   {
390     return super.approve(_spender, _value);
391   }
392 
393   function increaseApproval(
394     address _spender,
395     uint _addedValue
396   )
397     public
398     whenNotPaused
399     returns (bool success)
400   {
401     return super.increaseApproval(_spender, _addedValue);
402   }
403 
404   function decreaseApproval(
405     address _spender,
406     uint _subtractedValue
407   )
408     public
409     whenNotPaused
410     returns (bool success)
411   {
412     return super.decreaseApproval(_spender, _subtractedValue);
413   }
414 }
415 
416 /**
417  * @title Burnable Token
418  * @dev Token that can be irreversibly burned (destroyed).
419  */
420 contract BurnableToken is BasicToken {
421 
422   event Burn(address indexed burner, uint256 value);
423 
424   /**
425    * @dev Burns a specific amount of tokens.
426    * @param _value The amount of token to be burned.
427    */
428   function burn(uint256 _value) public {
429     _burn(msg.sender, _value);
430   }
431 
432   function _burn(address _who, uint256 _value) internal {
433     require(_value <= balances[_who]);
434     // no need to require value <= totalSupply, since that would imply the
435     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
436 
437     balances[_who] = balances[_who].sub(_value);
438     totalSupply_ = totalSupply_.sub(_value);
439     emit Burn(_who, _value);
440     emit Transfer(_who, address(0), _value);
441   }
442 }
443 
444 contract RepublicToken is PausableToken, BurnableToken {
445 
446     string public constant name = "Republic Token";
447     string public constant symbol = "REN";
448     uint8 public constant decimals = 18;
449     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
450 
451     /// @notice The RepublicToken Constructor.
452     constructor() public {
453         totalSupply_ = INITIAL_SUPPLY;
454         balances[msg.sender] = INITIAL_SUPPLY;
455     }
456 
457     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
458         /* solium-disable error-reason */
459         require(amount > 0);
460 
461         balances[owner] = balances[owner].sub(amount);
462         balances[beneficiary] = balances[beneficiary].add(amount);
463         emit Transfer(owner, beneficiary, amount);
464 
465         return true;
466     }
467 }