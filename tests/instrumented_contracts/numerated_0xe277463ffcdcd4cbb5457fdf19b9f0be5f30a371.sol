1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipRenounced(address indexed previousOwner);
49   event OwnershipTransferred(
50     address indexed previousOwner,
51     address indexed newOwner
52   );
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   constructor() public {
60     owner = msg.sender;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71   /**
72    * @dev Allows the current owner to relinquish control of the contract.
73    * @notice Renouncing to ownership will leave the contract without an owner.
74    * It will not be possible to call the functions with the `onlyOwner`
75    * modifier anymore.
76    */
77   function renounceOwnership() public onlyOwner {
78     emit OwnershipRenounced(owner);
79     owner = address(0);
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 
101 
102 
103 
104 
105 
106 
107 
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that revert on error
111  */
112 library SafeMath {
113 
114   /**
115   * @dev Multiplies two numbers, reverts on overflow.
116   */
117   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
118     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119     // benefit is lost if 'b' is also tested.
120     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
121     if (_a == 0) {
122       return 0;
123     }
124 
125     uint256 c = _a * _b;
126     require(c / _a == _b);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
133   */
134   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
135     require(_b > 0); // Solidity only automatically asserts when dividing by 0
136     uint256 c = _a / _b;
137     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
138 
139     return c;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
146     require(_b <= _a);
147     uint256 c = _a - _b;
148 
149     return c;
150   }
151 
152   /**
153   * @dev Adds two numbers, reverts on overflow.
154   */
155   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
156     uint256 c = _a + _b;
157     require(c >= _a);
158 
159     return c;
160   }
161 
162   /**
163   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
164   * reverts when dividing by zero.
165   */
166   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167     require(b != 0);
168     return a % b;
169   }
170 }
171 
172 
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
179  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20 {
182   using SafeMath for uint256;
183 
184   mapping (address => uint256) private balances;
185 
186   mapping (address => mapping (address => uint256)) private allowed;
187 
188   uint256 private totalSupply_;
189 
190   /**
191   * @dev Total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return totalSupply_;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param _owner The address to query the the balance of.
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address _owner) public view returns (uint256) {
203     return balances[_owner];
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address _owner,
214     address _spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224   * @dev Transfer token for a specified address
225   * @param _to The address to transfer to.
226   * @param _value The amount to be transferred.
227   */
228   function transfer(address _to, uint256 _value) public returns (bool) {
229     require(_value <= balances[msg.sender]);
230     require(_to != address(0));
231 
232     balances[msg.sender] = balances[msg.sender].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     emit Transfer(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269     require(_to != address(0));
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _addedValue The amount of tokens to increase the allowance by.
286    */
287   function increaseApproval(
288     address _spender,
289     uint256 _addedValue
290   )
291     public
292     returns (bool)
293   {
294     allowed[msg.sender][_spender] = (
295       allowed[msg.sender][_spender].add(_addedValue));
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   /**
301    * @dev Decrease the amount of tokens that an owner allowed to a spender.
302    * approve should be called when allowed[_spender] == 0. To decrement
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _subtractedValue The amount of tokens to decrease the allowance by.
308    */
309   function decreaseApproval(
310     address _spender,
311     uint256 _subtractedValue
312   )
313     public
314     returns (bool)
315   {
316     uint256 oldValue = allowed[msg.sender][_spender];
317     if (_subtractedValue >= oldValue) {
318       allowed[msg.sender][_spender] = 0;
319     } else {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Internal function that mints an amount of the token and assigns it to
328    * an account. This encapsulates the modification of balances such that the
329    * proper events are emitted.
330    * @param _account The account that will receive the created tokens.
331    * @param _amount The amount that will be created.
332    */
333   function _mint(address _account, uint256 _amount) internal {
334     require(_account != 0);
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[_account] = balances[_account].add(_amount);
337     emit Transfer(address(0), _account, _amount);
338   }
339 
340   /**
341    * @dev Internal function that burns an amount of the token of a given
342    * account.
343    * @param _account The account whose tokens will be burnt.
344    * @param _amount The amount that will be burnt.
345    */
346   function _burn(address _account, uint256 _amount) internal {
347     require(_account != 0);
348     require(_amount <= balances[_account]);
349 
350     totalSupply_ = totalSupply_.sub(_amount);
351     balances[_account] = balances[_account].sub(_amount);
352     emit Transfer(_account, address(0), _amount);
353   }
354 
355   /**
356    * @dev Internal function that burns an amount of the token of a given
357    * account, deducting from the sender's allowance for said account. Uses the
358    * internal _burn function.
359    * @param _account The account whose tokens will be burnt.
360    * @param _amount The amount that will be burnt.
361    */
362   function _burnFrom(address _account, uint256 _amount) internal {
363     require(_amount <= allowed[_account][msg.sender]);
364 
365     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
366     // this function needs to emit an event with the updated approval.
367     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
368     _burn(_account, _amount);
369   }
370 }
371 
372 
373 
374 
375 
376 
377 /**
378  * @title DetailedERC20 token
379  * @dev The decimals are only for visualization purposes.
380  * All the operations are done using the smallest and indivisible token unit,
381  * just as on Ethereum all the operations are done in wei.
382  */
383 contract DetailedERC20 is ERC20 {
384   string public name;
385   string public symbol;
386   uint8 public decimals;
387 
388   constructor(string _name, string _symbol, uint8 _decimals) public {
389     name = _name;
390     symbol = _symbol;
391     decimals = _decimals;
392   }
393 }
394 
395 
396 
397 contract CTSToken is Ownable, DetailedERC20, StandardToken {
398   
399   event Mint(address indexed to, uint256 amount);
400   
401   event Burn(address burner, uint256 value);
402   
403   constructor() 
404     public
405   DetailedERC20("CTS Token", "CTS", 18)
406   {
407 
408   }
409   
410   /**
411    * @dev Function to mint tokens
412    * @param _to The address that will receive the minted tokens.
413    * @param _amount The amount of tokens to mint.
414    * @return A boolean that indicates if the operation was successful.
415    */
416   function mint(
417     address _to,
418     uint256 _amount
419   )  
420     public 
421     onlyOwner 
422     returns (bool) 
423   {
424     _mint(_to, _amount);
425     emit Mint(_to, _amount);
426     return true;
427   }
428   
429   /**
430   * @dev Transfer token for a specified address 
431   * (or burn them if tokens has been transfered to contract owner)
432   * @param _to The address to transfer to.
433   * @param _value The amount to be transferred.
434   */
435   function transfer(
436     address _to, 
437     uint256 _value
438   ) 
439     public 
440     returns (bool) 
441   {
442     if (_to == address(this)) {
443       _burn(msg.sender, _value);
444       return true;
445     }
446     
447     return super.transfer(_to, _value);
448   }
449   
450   /**
451    * @dev Overrides StandardToken._burn in order for burn to emit
452    * an additional Burn event.
453    */
454   function _burn(address _who, uint256 _value) internal {
455     super._burn(_who, _value);
456     emit Burn(_who, _value);
457   }
458 }