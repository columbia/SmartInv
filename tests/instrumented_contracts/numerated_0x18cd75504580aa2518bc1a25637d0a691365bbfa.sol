1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipRenounced(address indexed previousOwner);
77   event OwnershipTransferred(
78     address indexed previousOwner,
79     address indexed newOwner
80   );
81 
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   constructor() public {
88     owner = msg.sender;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99   /**
100    * @dev Allows the current owner to relinquish control of the contract.
101    * @notice Renouncing to ownership will leave the contract without an owner.
102    * It will not be possible to call the functions with the `onlyOwner`
103    * modifier anymore.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipRenounced(owner);
107     owner = address(0);
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address _newOwner) public onlyOwner {
115     _transferOwnership(_newOwner);
116   }
117 
118   /**
119    * @dev Transfers control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function _transferOwnership(address _newOwner) internal {
123     require(_newOwner != address(0));
124     emit OwnershipTransferred(owner, _newOwner);
125     owner = _newOwner;
126   }
127 }
128 
129 
130 /**
131  * @title Pausable
132  * @dev Base contract which allows children to implement an emergency stop mechanism.
133  */
134 contract Pausable is Ownable {
135   event Pause();
136   event Unpause();
137 
138   bool public paused = false;
139 
140 
141   /**
142    * @dev Modifier to make a function callable only when the contract is not paused.
143    */
144   modifier whenNotPaused() {
145     require(!paused);
146     _;
147   }
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is paused.
151    */
152   modifier whenPaused() {
153     require(paused);
154     _;
155   }
156 
157   /**
158    * @dev called by the owner to pause, triggers stopped state
159    */
160   function pause() public onlyOwner whenNotPaused {
161     paused = true;
162     emit Pause();
163   }
164 
165   /**
166    * @dev called by the owner to unpause, returns to normal state
167    */
168   function unpause() public onlyOwner whenPaused {
169     paused = false;
170     emit Unpause();
171   }
172 }
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 {
179   function totalSupply() public view returns (uint256);
180 
181   function balanceOf(address _who) public view returns (uint256);
182 
183   function allowance(address _owner, address _spender)
184     public view returns (uint256);
185 
186   function transfer(address _to, uint256 _value) public returns (bool);
187 
188   function approve(address _spender, uint256 _value)
189     public returns (bool);
190 
191   function transferFrom(address _from, address _to, uint256 _value)
192     public returns (bool);
193 
194   event Transfer(
195     address indexed from,
196     address indexed to,
197     uint256 value
198   );
199 
200   event Approval(
201     address indexed owner,
202     address indexed spender,
203     uint256 value
204   );
205 }
206 
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * https://github.com/ethereum/EIPs/issues/20
213  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20 {
216   using SafeMath for uint256;
217 
218   mapping(address => uint256) balances;
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222   uint256 totalSupply_;
223 
224   /**
225   * @dev Total number of tokens in existence
226   */
227   function totalSupply() public view returns (uint256) {
228     return totalSupply_;
229   }
230 
231   /**
232   * @dev Gets the balance of the specified address.
233   * @param _owner The address to query the the balance of.
234   * @return An uint256 representing the amount owned by the passed address.
235   */
236   function balanceOf(address _owner) public view returns (uint256) {
237     return balances[_owner];
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258   * @dev Transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(_value <= balances[msg.sender]);
264     require(_to != address(0));
265 
266     balances[msg.sender] = balances[msg.sender].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     emit Transfer(msg.sender, _to, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint256 _value) public returns (bool) {
282     allowed[msg.sender][_spender] = _value;
283     emit Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Transfer tokens from one address to another
289    * @param _from address The address which you want to send tokens from
290    * @param _to address The address which you want to transfer to
291    * @param _value uint256 the amount of tokens to be transferred
292    */
293   function transferFrom(
294     address _from,
295     address _to,
296     uint256 _value
297   )
298     public
299     returns (bool)
300   {
301     require(_value <= balances[_from]);
302     require(_value <= allowed[_from][msg.sender]);
303     require(_to != address(0));
304 
305     balances[_from] = balances[_from].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     emit Transfer(_from, _to, _value);
309     return true;
310   }
311 
312   /**
313    * @dev Increase the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _addedValue The amount of tokens to increase the allowance by.
320    */
321   function increaseApproval(
322     address _spender,
323     uint256 _addedValue
324   )
325     public
326     returns (bool)
327   {
328     allowed[msg.sender][_spender] = (
329       allowed[msg.sender][_spender].add(_addedValue));
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseApproval(
344     address _spender,
345     uint256 _subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     uint256 oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue >= oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 
363 /**
364  * @title Pausable token
365  * @dev StandardToken modified with pausable transfers.
366  **/
367 contract PausableToken is StandardToken, Pausable {
368 
369   function transfer(
370     address _to,
371     uint256 _value
372   )
373     public
374     whenNotPaused
375     returns (bool)
376   {
377     return super.transfer(_to, _value);
378   }
379 
380   function transferFrom(
381     address _from,
382     address _to,
383     uint256 _value
384   )
385     public
386     whenNotPaused
387     returns (bool)
388   {
389     return super.transferFrom(_from, _to, _value);
390   }
391 
392   function approve(
393     address _spender,
394     uint256 _value
395   )
396     public
397     whenNotPaused
398     returns (bool)
399   {
400     return super.approve(_spender, _value);
401   }
402 
403   function increaseApproval(
404     address _spender,
405     uint _addedValue
406   )
407     public
408     whenNotPaused
409     returns (bool success)
410   {
411     return super.increaseApproval(_spender, _addedValue);
412   }
413 
414   function decreaseApproval(
415     address _spender,
416     uint _subtractedValue
417   )
418     public
419     whenNotPaused
420     returns (bool success)
421   {
422     return super.decreaseApproval(_spender, _subtractedValue);
423   }
424 }
425 
426 contract BiboToken is PausableToken {
427     string public name = "Bibo Token";
428     string public symbol = "BIBO";
429     uint public decimals = 18;
430     uint public INITIAL_SUPPLY = 100000000000*10**decimals;
431 
432     function BiboToken() public {
433         totalSupply_ = INITIAL_SUPPLY;
434         balances[msg.sender] = INITIAL_SUPPLY;
435     }
436 }