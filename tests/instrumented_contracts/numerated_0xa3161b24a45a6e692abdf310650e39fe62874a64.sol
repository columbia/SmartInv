1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender)
74     public view returns (uint256);
75 
76   function transferFrom(address from, address to, uint256 value)
77     public returns (bool);
78 
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84   );
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93   address public owner;
94 
95 
96   event OwnershipRenounced(address indexed previousOwner);
97   event OwnershipTransferred(
98     address indexed previousOwner,
99     address indexed newOwner
100   );
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to relinquish control of the contract.
121    */
122   function renounceOwnership() public onlyOwner {
123     emit OwnershipRenounced(owner);
124     owner = address(0);
125   }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address _newOwner) public onlyOwner {
132     _transferOwnership(_newOwner);
133   }
134 
135   /**
136    * @dev Transfers control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function _transferOwnership(address _newOwner) internal {
140     require(_newOwner != address(0));
141     emit OwnershipTransferred(owner, _newOwner);
142     owner = _newOwner;
143   }
144 }
145 
146 /**
147  * @title Pausable
148  * @dev Base contract which allows children to implement an emergency stop mechanism.
149  */
150 contract Pausable is Ownable {
151   event Pause();
152   event Unpause();
153 
154   bool public paused = false;
155 
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is not paused.
159    */
160   modifier whenNotPaused() {
161     require(!paused);
162     _;
163   }
164 
165   /**
166    * @dev Modifier to make a function callable only when the contract is paused.
167    */
168   modifier whenPaused() {
169     require(paused);
170     _;
171   }
172 
173   /**
174    * @dev called by the owner to pause, triggers stopped state
175    */
176   function pause() onlyOwner whenNotPaused public {
177     paused = true;
178     emit Pause();
179   }
180 
181   /**
182    * @dev called by the owner to unpause, returns to normal state
183    */
184   function unpause() onlyOwner whenPaused public {
185     paused = false;
186     emit Unpause();
187   }
188 }
189 
190 /**
191  * @title Basic token
192  * @dev Basic version of StandardToken, with no allowances.
193  */
194 contract BasicToken is ERC20Basic {
195   using SafeMath for uint256;
196 
197   mapping(address => uint256) balances;
198 
199   uint256 totalSupply_;
200 
201   /**
202   * @dev total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return totalSupply_;
206   }
207 
208   /**
209   * @dev transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[msg.sender]);
216 
217     balances[msg.sender] = balances[msg.sender].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     emit Transfer(msg.sender, _to, _value);
220     return true;
221   }
222 
223   /**
224   * @dev Gets the balance of the specified address.
225   * @param _owner The address to query the the balance of.
226   * @return An uint256 representing the amount owned by the passed address.
227   */
228   function balanceOf(address _owner) public view returns (uint256) {
229     return balances[_owner];
230   }
231 
232 }
233 
234 /**
235  * @title Standard ERC20 token
236  *
237  * @dev Implementation of the basic standard token.
238  * @dev https://github.com/ethereum/EIPs/issues/20
239  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
240  */
241 contract StandardToken is ERC20, BasicToken {
242 
243   mapping (address => mapping (address => uint256)) internal allowed;
244 
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    *
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
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(
294     address _owner,
295     address _spender
296    )
297     public
298     view
299     returns (uint256)
300   {
301     return allowed[_owner][_spender];
302   }
303 
304   /**
305    * @dev Increase the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseApproval(
315     address _spender,
316     uint _addedValue
317   )
318     public
319     returns (bool)
320   {
321     allowed[msg.sender][_spender] = (
322       allowed[msg.sender][_spender].add(_addedValue));
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    *
330    * approve should be called when allowed[_spender] == 0. To decrement
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _subtractedValue The amount of tokens to decrease the allowance by.
336    */
337   function decreaseApproval(
338     address _spender,
339     uint _subtractedValue
340   )
341     public
342     returns (bool)
343   {
344     uint oldValue = allowed[msg.sender][_spender];
345     if (_subtractedValue > oldValue) {
346       allowed[msg.sender][_spender] = 0;
347     } else {
348       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349     }
350     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353 
354 }
355 
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PausableToken is StandardToken, Pausable {
361 
362   function transfer(
363     address _to,
364     uint256 _value
365   )
366     public
367     whenNotPaused
368     returns (bool)
369   {
370     return super.transfer(_to, _value);
371   }
372 
373   function transferFrom(
374     address _from,
375     address _to,
376     uint256 _value
377   )
378     public
379     whenNotPaused
380     returns (bool)
381   {
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385   function approve(
386     address _spender,
387     uint256 _value
388   )
389     public
390     whenNotPaused
391     returns (bool)
392   {
393     return super.approve(_spender, _value);
394   }
395 
396   function increaseApproval(
397     address _spender,
398     uint _addedValue
399   )
400     public
401     whenNotPaused
402     returns (bool success)
403   {
404     return super.increaseApproval(_spender, _addedValue);
405   }
406 
407   function decreaseApproval(
408     address _spender,
409     uint _subtractedValue
410   )
411     public
412     whenNotPaused
413     returns (bool success)
414   {
415     return super.decreaseApproval(_spender, _subtractedValue);
416   }
417 }
418 
419 
420 /**
421  * @title BatteryStorage.io Token
422  */
423 
424 contract BatteryStorageToken is PausableToken {
425     string public constant name = "BatteryStorage";
426     string public constant symbol = "BSO";
427     uint8 public constant decimals = 18;
428 
429     uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);    
430     uint256 public constant TOTAL_SUPPLY = 2000000000 * TOKEN_UNIT;
431 
432 
433     constructor() public {
434         totalSupply_ = TOTAL_SUPPLY;
435         balances[owner] = TOTAL_SUPPLY;
436         emit Transfer(address(0), owner, balances[owner]);
437     }
438     
439 }