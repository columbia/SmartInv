1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 contract ERC20 {
62   function totalSupply() public view returns (uint256);
63 
64   function balanceOf(address _who) public view returns (uint256);
65 
66   function allowance(address _owner, address _spender)
67     public view returns (uint256);
68 
69   function transfer(address _to, uint256 _value) public returns (bool);
70 
71   function approve(address _spender, uint256 _value)
72     public returns (bool);
73 
74   function transferFrom(address _from, address _to, uint256 _value)
75     public returns (bool);
76 
77   event Transfer(
78     address indexed from,
79     address indexed to,
80     uint256 value
81   );
82 
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 library SafeMath {
90 
91   /**
92   * @dev Multiplies two numbers, reverts on overflow.
93   */
94   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96     // benefit is lost if 'b' is also tested.
97     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98     if (_a == 0) {
99       return 0;
100     }
101 
102     uint256 c = _a * _b;
103     require(c / _a == _b);
104 
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
110   */
111   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
112     require(_b > 0); // Solidity only automatically asserts when dividing by 0
113     uint256 c = _a / _b;
114     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
115 
116     return c;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     require(_b <= _a);
124     uint256 c = _a - _b;
125 
126     return c;
127   }
128 
129   /**
130   * @dev Adds two numbers, reverts on overflow.
131   */
132   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
133     uint256 c = _a + _b;
134     require(c >= _a);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
141   * reverts when dividing by zero.
142   */
143   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144     require(b != 0);
145     return a % b;
146   }
147 }
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151 
152   bool public paused = false;
153 
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is paused.
165    */
166   modifier whenPaused() {
167     require(paused);
168     _;
169   }
170 
171   /**
172    * @dev called by the owner to pause, triggers stopped state
173    */
174   function pause() public onlyOwner whenNotPaused {
175     paused = true;
176     emit Pause();
177   }
178 
179   /**
180    * @dev called by the owner to unpause, returns to normal state
181    */
182   function unpause() public onlyOwner whenPaused {
183     paused = false;
184     emit Unpause();
185   }
186 }
187 contract StandardToken is ERC20 {
188   using SafeMath for uint256;
189 
190   mapping (address => uint256) private balances;
191 
192   mapping (address => mapping (address => uint256)) private allowed;
193 
194   uint256 private totalSupply_;
195 
196   /**
197   * @dev Total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances[_owner];
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230   * @dev Transfer token for a specified address
231   * @param _to The address to transfer to.
232   * @param _value The amount to be transferred.
233   */
234   function transfer(address _to, uint256 _value) public returns (bool) {
235     require(_value <= balances[msg.sender]);
236     require(_to != address(0));
237 
238     balances[msg.sender] = balances[msg.sender].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     emit Transfer(msg.sender, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     emit Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param _from address The address which you want to send tokens from
262    * @param _to address The address which you want to transfer to
263    * @param _value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(
266     address _from,
267     address _to,
268     uint256 _value
269   )
270     public
271     returns (bool)
272   {
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275     require(_to != address(0));
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     emit Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(
294     address _spender,
295     uint256 _addedValue
296   )
297     public
298     returns (bool)
299   {
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(
316     address _spender,
317     uint256 _subtractedValue
318   )
319     public
320     returns (bool)
321   {
322     uint256 oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue >= oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Internal function that mints an amount of the token and assigns it to
334    * an account. This encapsulates the modification of balances such that the
335    * proper events are emitted.
336    * @param _account The account that will receive the created tokens.
337    * @param _amount The amount that will be created.
338    */
339   function _mint(address _account, uint256 _amount) internal {
340     require(_account != 0);
341     totalSupply_ = totalSupply_.add(_amount);
342     balances[_account] = balances[_account].add(_amount);
343     emit Transfer(address(0), _account, _amount);
344   }
345 
346   /**
347    * @dev Internal function that burns an amount of the token of a given
348    * account.
349    * @param _account The account whose tokens will be burnt.
350    * @param _amount The amount that will be burnt.
351    */
352   function _burn(address _account, uint256 _amount) internal {
353     require(_account != 0);
354     require(_amount <= balances[_account]);
355 
356     totalSupply_ = totalSupply_.sub(_amount);
357     balances[_account] = balances[_account].sub(_amount);
358     emit Transfer(_account, address(0), _amount);
359   }
360 
361   /**
362    * @dev Internal function that burns an amount of the token of a given
363    * account, deducting from the sender's allowance for said account. Uses the
364    * internal _burn function.
365    * @param _account The account whose tokens will be burnt.
366    * @param _amount The amount that will be burnt.
367    */
368   function _burnFrom(address _account, uint256 _amount) internal {
369     require(_amount <= allowed[_account][msg.sender]);
370 
371     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
372     // this function needs to emit an event with the updated approval.
373     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
374     _burn(_account, _amount);
375   }
376 }
377 contract BurnableToken is StandardToken {
378 
379   event Burn(address indexed burner, uint256 value);
380 
381   /**
382    * @dev Burns a specific amount of tokens.
383    * @param _value The amount of token to be burned.
384    */
385   function burn(uint256 _value) public {
386     _burn(msg.sender, _value);
387   }
388 
389   /**
390    * @dev Burns a specific amount of tokens from the target address and decrements allowance
391    * @param _from address The address which you want to send tokens from
392    * @param _value uint256 The amount of token to be burned
393    */
394   function burnFrom(address _from, uint256 _value) public {
395     _burnFrom(_from, _value);
396   }
397 
398   /**
399    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
400    * an additional Burn event.
401    */
402   function _burn(address _who, uint256 _value) internal {
403     super._burn(_who, _value);
404     emit Burn(_who, _value);
405   }
406 }
407 contract HubToken is BurnableToken, Pausable {
408 
409 	// Constants
410     string  public constant name = "Hub Token";
411     string  public constant symbol = "HUB";
412     uint8   public constant decimals = 18;
413     uint256 public constant INITIAL_SUPPLY = 1750000000 * (10 ** uint256(decimals));
414 
415 	constructor() public {
416 		super._mint(msg.sender, INITIAL_SUPPLY);
417 	}	
418 
419 	function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
420 		return super.transfer(_to, _value);
421 	}
422 
423 	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
424 		return super.transferFrom(_from, _to, _value);
425 	}
426 
427 	function burn(uint256 _value) whenNotPaused public {
428 		super._burn(msg.sender, _value);
429 	}
430 
431 	function burnFrom(address _from, uint256 _value) whenNotPaused public {
432 		super._burnFrom(_from, _value);
433 	}
434 }