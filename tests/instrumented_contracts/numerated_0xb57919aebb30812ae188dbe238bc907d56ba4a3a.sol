1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) internal balances;
78 
79   uint256 internal totalSupply_;
80 
81   /**
82   * @dev Total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev Transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_value <= balances[msg.sender]);
95     require(_to != address(0));
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address _owner, address _spender)
121     public view returns (uint256);
122 
123   function transferFrom(address _from, address _to, uint256 _value)
124     public returns (bool);
125 
126   function approve(address _spender, uint256 _value) public returns (bool);
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * https://github.com/ethereum/EIPs/issues/20
142  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(
156     address _from,
157     address _to,
158     uint256 _value
159   )
160     public
161     returns (bool)
162   {
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165     require(_to != address(0));
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint256 _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint256 _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint256 oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue >= oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() public onlyOwner whenNotPaused {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() public onlyOwner whenPaused {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 
368 /**
369  * @title Pausable token
370  * @dev StandardToken modified with pausable transfers.
371  **/
372 contract PausableToken is StandardToken, Pausable {
373 
374   function transfer(
375     address _to,
376     uint256 _value
377   )
378     public
379     whenNotPaused
380     returns (bool)
381   {
382     return super.transfer(_to, _value);
383   }
384 
385   function transferFrom(
386     address _from,
387     address _to,
388     uint256 _value
389   )
390     public
391     whenNotPaused
392     returns (bool)
393   {
394     return super.transferFrom(_from, _to, _value);
395   }
396 
397   function approve(
398     address _spender,
399     uint256 _value
400   )
401     public
402     whenNotPaused
403     returns (bool)
404   {
405     return super.approve(_spender, _value);
406   }
407 
408   function increaseApproval(
409     address _spender,
410     uint _addedValue
411   )
412     public
413     whenNotPaused
414     returns (bool success)
415   {
416     return super.increaseApproval(_spender, _addedValue);
417   }
418 
419   function decreaseApproval(
420     address _spender,
421     uint _subtractedValue
422   )
423     public
424     whenNotPaused
425     returns (bool success)
426   {
427     return super.decreaseApproval(_spender, _subtractedValue);
428   }
429 }
430 
431 
432 
433 
434 
435 contract EveryCoin is PausableToken  {
436     string  public  constant name = "EveryCoin";
437     string  public  constant symbol = "EYC";
438     uint8   public  constant decimals = 12;
439     uint256   public  totalSupply = 0;
440     modifier validDestination( address to )
441     {
442         require(to != address(0x0));
443         require(to != address(this));
444         _;
445     }
446 
447     function everyCoin( address _admin, uint _totalTokenAmount ) 
448     {
449         address admin = _admin;
450         totalSupply = _totalTokenAmount;
451         balances[msg.sender] = _totalTokenAmount;
452         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
453     }
454     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
455     {
456         return super.transfer(_to, _value);
457     }
458     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
459     {
460         return super.transferFrom(_from, _to, _value);
461     }
462     event Burn(address indexed _burner, uint _value);
463     function burn(uint _value) returns (bool)
464     {
465         balances[msg.sender] = balances[msg.sender].sub(_value);
466         totalSupply = totalSupply.sub(_value);
467         emit Burn(msg.sender, _value);
468         emit Transfer(msg.sender, address(0x0), _value);
469         return true;
470     }
471     function burnFrom(address _from, uint256 _value) returns (bool)  
472     {
473         assert( transferFrom( _from, msg.sender, _value ) );
474         return burn(_value);
475     }
476     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
477         token.transfer( owner, amount );
478     }
479     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
480     function changeAdmin(address newAdmin) onlyOwner {
481         emit AdminTransferred(admin, newAdmin);
482         address admin = newAdmin;
483     }
484 }