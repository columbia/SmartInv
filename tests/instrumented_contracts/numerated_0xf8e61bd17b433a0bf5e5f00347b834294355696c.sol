1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
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
110  * @title Burnable Token
111  * @dev Token that can be irreversibly burned (destroyed).
112  */
113 contract BurnableToken is BasicToken {
114 
115   event Burn(address indexed burner, uint256 value);
116 
117   /**
118    * @dev Burns a specific amount of tokens.
119    * @param _value The amount of token to be burned.
120    */
121   function burn(uint256 _value) public {
122     _burn(msg.sender, _value);
123   }
124 
125   function _burn(address _who, uint256 _value) internal {
126     require(_value <= balances[_who]);
127     // no need to require value <= totalSupply, since that would imply the
128     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
129 
130     balances[_who] = balances[_who].sub(_value);
131     totalSupply_ = totalSupply_.sub(_value);
132     emit Burn(_who, _value);
133     emit Transfer(_who, address(0), _value);
134   }
135 }
136 
137 /**
138  * @title Ownable
139  * @dev The Ownable contract has an owner address, and provides basic authorization control
140  * functions, this simplifies the implementation of "user permissions".
141  */
142 contract Ownable {
143   address public owner;
144 
145 
146   event OwnershipRenounced(address indexed previousOwner);
147   event OwnershipTransferred(
148     address indexed previousOwner,
149     address indexed newOwner
150   );
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   constructor() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to relinquish control of the contract.
171    * @notice Renouncing to ownership will leave the contract without an owner.
172    * It will not be possible to call the functions with the `onlyOwner`
173    * modifier anymore.
174    */
175   function renounceOwnership() public onlyOwner {
176     emit OwnershipRenounced(owner);
177     owner = address(0);
178   }
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param _newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address _newOwner) public onlyOwner {
185     _transferOwnership(_newOwner);
186   }
187 
188   /**
189    * @dev Transfers control of the contract to a newOwner.
190    * @param _newOwner The address to transfer ownership to.
191    */
192   function _transferOwnership(address _newOwner) internal {
193     require(_newOwner != address(0));
194     emit OwnershipTransferred(owner, _newOwner);
195     owner = _newOwner;
196   }
197 }
198 
199 /**
200  * @title Pausable
201  * @dev Base contract which allows children to implement an emergency stop mechanism.
202  */
203 contract Pausable is Ownable {
204   event Pause();
205   event Unpause();
206 
207   bool public paused = false;
208 
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is not paused.
212    */
213   modifier whenNotPaused() {
214     require(!paused);
215     _;
216   }
217 
218   /**
219    * @dev Modifier to make a function callable only when the contract is paused.
220    */
221   modifier whenPaused() {
222     require(paused);
223     _;
224   }
225 
226   /**
227    * @dev called by the owner to pause, triggers stopped state
228    */
229   function pause() onlyOwner whenNotPaused public {
230     paused = true;
231     emit Pause();
232   }
233 
234   /**
235    * @dev called by the owner to unpause, returns to normal state
236    */
237   function unpause() onlyOwner whenPaused public {
238     paused = false;
239     emit Unpause();
240   }
241 }
242 
243 /**
244  * @title ERC20 interface
245  * @dev see https://github.com/ethereum/EIPs/issues/20
246  */
247 contract ERC20 is ERC20Basic {
248   function allowance(address owner, address spender)
249     public view returns (uint256);
250 
251   function transferFrom(address from, address to, uint256 value)
252     public returns (bool);
253 
254   function approve(address spender, uint256 value) public returns (bool);
255   event Approval(
256     address indexed owner,
257     address indexed spender,
258     uint256 value
259   );
260 }
261 
262 /**
263  * @title Standard ERC20 token
264  *
265  * @dev Implementation of the basic standard token.
266  * https://github.com/ethereum/EIPs/issues/20
267  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
268  */
269 contract StandardToken is ERC20, BasicToken {
270 
271   mapping (address => mapping (address => uint256)) internal allowed;
272 
273 
274   /**
275    * @dev Transfer tokens from one address to another
276    * @param _from address The address which you want to send tokens from
277    * @param _to address The address which you want to transfer to
278    * @param _value uint256 the amount of tokens to be transferred
279    */
280   function transferFrom(
281     address _from,
282     address _to,
283     uint256 _value
284   )
285     public
286     returns (bool)
287   {
288     require(_to != address(0));
289     require(_value <= balances[_from]);
290     require(_value <= allowed[_from][msg.sender]);
291 
292     balances[_from] = balances[_from].sub(_value);
293     balances[_to] = balances[_to].add(_value);
294     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295     emit Transfer(_from, _to, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
301    * Beware that changing an allowance with this method brings the risk that someone may use both the old
302    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305    * @param _spender The address which will spend the funds.
306    * @param _value The amount of tokens to be spent.
307    */
308   function approve(address _spender, uint256 _value) public returns (bool) {
309     allowed[msg.sender][_spender] = _value;
310     emit Approval(msg.sender, _spender, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Function to check the amount of tokens that an owner allowed to a spender.
316    * @param _owner address The address which owns the funds.
317    * @param _spender address The address which will spend the funds.
318    * @return A uint256 specifying the amount of tokens still available for the spender.
319    */
320   function allowance(
321     address _owner,
322     address _spender
323    )
324     public
325     view
326     returns (uint256)
327   {
328     return allowed[_owner][_spender];
329   }
330 
331   /**
332    * @dev Increase the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed[_spender] == 0. To increment
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param _spender The address which will spend the funds.
338    * @param _addedValue The amount of tokens to increase the allowance by.
339    */
340   function increaseApproval(
341     address _spender,
342     uint256 _addedValue
343   )
344     public
345     returns (bool)
346   {
347     allowed[msg.sender][_spender] = (
348       allowed[msg.sender][_spender].add(_addedValue));
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353   /**
354    * @dev Decrease the amount of tokens that an owner allowed to a spender.
355    * approve should be called when allowed[_spender] == 0. To decrement
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _subtractedValue The amount of tokens to decrease the allowance by.
361    */
362   function decreaseApproval(
363     address _spender,
364     uint256 _subtractedValue
365   )
366     public
367     returns (bool)
368   {
369     uint256 oldValue = allowed[msg.sender][_spender];
370     if (_subtractedValue > oldValue) {
371       allowed[msg.sender][_spender] = 0;
372     } else {
373       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374     }
375     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376     return true;
377   }
378 
379 }
380 
381 /**
382  * @title Pausable token
383  * @dev StandardToken modified with pausable transfers.
384  **/
385 contract PausableToken is StandardToken, Pausable {
386 
387   function transfer(
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transfer(_to, _value);
396   }
397 
398   function transferFrom(
399     address _from,
400     address _to,
401     uint256 _value
402   )
403     public
404     whenNotPaused
405     returns (bool)
406   {
407     return super.transferFrom(_from, _to, _value);
408   }
409 
410   function approve(
411     address _spender,
412     uint256 _value
413   )
414     public
415     whenNotPaused
416     returns (bool)
417   {
418     return super.approve(_spender, _value);
419   }
420 
421   function increaseApproval(
422     address _spender,
423     uint _addedValue
424   )
425     public
426     whenNotPaused
427     returns (bool success)
428   {
429     return super.increaseApproval(_spender, _addedValue);
430   }
431 
432   function decreaseApproval(
433     address _spender,
434     uint _subtractedValue
435   )
436     public
437     whenNotPaused
438     returns (bool success)
439   {
440     return super.decreaseApproval(_spender, _subtractedValue);
441   }
442 }
443 
444 contract WestrendAirdrop is PausableToken, BurnableToken
445 {
446     string public constant name = "WestrendAirdrop";
447     string public constant symbol = "WES-A";
448     uint8 public constant decimals = 18;
449 
450     // 1 Million Total Supply
451     uint256 public constant INITIAL_SUPPLY = 1e6 * 10**uint256(decimals);
452     
453     constructor()  public {
454         totalSupply_ = INITIAL_SUPPLY;
455         transferOwnership(0x7a35B4Cb1F65efF653be686110d98d28d6bcF738);
456         balances[0x7a35B4Cb1F65efF653be686110d98d28d6bcF738] = INITIAL_SUPPLY;
457         emit Transfer(0x0, 0x7a35B4Cb1F65efF653be686110d98d28d6bcF738, INITIAL_SUPPLY);
458     }
459 }