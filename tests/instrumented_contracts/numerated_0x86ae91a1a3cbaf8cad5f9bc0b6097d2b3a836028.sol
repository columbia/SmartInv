1 pragma solidity 0.4.24;
2 
3 // File: contracts\lib\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts\lib\SafeMath.sol
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
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
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
65 // File: contracts\lib\BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: contracts\lib\ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 {
119     function allowance(address owner, address spender) public view returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     function totalSupply() public view returns (uint256);
123     function balanceOf(address who) public view returns (uint256);
124     function transfer(address to, uint256 value) public returns (bool);
125 
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: contracts\lib\StandardToken.sol
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) public view returns (uint256) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 // File: contracts\lib\Ownable.sol
228 
229 /**
230  * @title Ownable
231  * @dev The Ownable contract has an owner address, and provides basic authorization control
232  * functions, this simplifies the implementation of "user permissions".
233  */
234 contract Ownable {
235   address public owner;
236 
237   event OwnershipRenounced(address indexed previousOwner);
238   event OwnershipTransferred(
239     address indexed previousOwner,
240     address indexed newOwner
241   );
242 
243   /**
244    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
245    * account.
246    */
247   constructor() public {
248     owner = msg.sender;
249   }
250 
251   /**
252    * @dev Throws if called by any account other than the owner.
253    */
254   modifier onlyOwner() {
255     require(msg.sender == owner, "only owner is able to call this function");
256     _;
257   }
258 
259   /**
260    * @dev Allows the current owner to relinquish control of the contract.
261    * @notice Renouncing to ownership will leave the contract without an owner.
262    * It will not be possible to call the functions with the `onlyOwner`
263    * modifier anymore.
264    */
265   function renounceOwnership() public onlyOwner {
266     emit OwnershipRenounced(owner);
267     owner = address(0);
268   }
269 
270   /**
271    * @dev Allows the current owner to transfer control of the contract to a newOwner.
272    * @param _newOwner The address to transfer ownership to.
273    */
274   function transferOwnership(address _newOwner) public onlyOwner {
275     _transferOwnership(_newOwner);
276   }
277 
278   /**
279    * @dev Transfers control of the contract to a newOwner.
280    * @param _newOwner The address to transfer ownership to.
281    */
282   function _transferOwnership(address _newOwner) internal {
283     require(_newOwner != address(0));
284     emit OwnershipTransferred(owner, _newOwner);
285     owner = _newOwner;
286   }
287 }
288 
289 // File: contracts\lib\MintableToken.sol
290 
291 /**
292  * @title Mintable token
293  * @dev Simple ERC20 Token example, with mintable token creation
294  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
295  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
296  */
297 contract MintableToken is StandardToken, Ownable {
298   event Mint(address indexed to, uint256 amount);
299   event MintFinished();
300 
301   bool public mintingFinished = false;
302 
303 
304   modifier canMint() {
305     require(!mintingFinished);
306     _;
307   }
308 
309   /**
310    * @dev Function to mint tokens
311    * @param _to The address that will receive the minted tokens.
312    * @param _amount The amount of tokens to mint.
313    * @return A boolean that indicates if the operation was successful.
314    */
315   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
316     totalSupply_ = totalSupply_.add(_amount);
317     balances[_to] = balances[_to].add(_amount);
318     emit Mint(_to, _amount);
319     emit Transfer(address(0), _to, _amount);
320     return true;
321   }
322 
323   /**
324    * @dev Function to stop minting new tokens.
325    * @return True if the operation was successful.
326    */
327   function finishMinting() onlyOwner canMint public returns (bool) {
328     mintingFinished = true;
329     emit MintFinished();
330     return true;
331   }
332 }
333 
334 // File: contracts\lib\Pausable.sol
335 
336 /**
337  * @title Pausable
338  * @dev Base contract which allows children to implement an emergency stop mechanism.
339  */
340 contract Pausable is Ownable {
341   event Pause();
342   event Unpause();
343 
344   bool public paused = false;
345 
346 
347   /**
348    * @dev Modifier to make a function callable only when the contract is not paused.
349    */
350   modifier whenNotPaused() {
351     require(!paused);
352     _;
353   }
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is paused.
357    */
358   modifier whenPaused() {
359     require(paused);
360     _;
361   }
362 
363   /**
364    * @dev called by the owner to pause, triggers stopped state
365    */
366   function pause() onlyOwner whenNotPaused public {
367     paused = true;
368     emit Pause();
369   }
370 
371   /**
372    * @dev called by the owner to unpause, returns to normal state
373    */
374   function unpause() onlyOwner whenPaused public {
375     paused = false;
376     emit Unpause();
377   }
378 }
379 
380 // File: contracts\lib\PausableToken.sol
381 
382 /**
383  * @title Pausable token
384  * @dev StandardToken modified with pausable transfers.
385  **/
386 contract PausableToken is StandardToken, Pausable {
387 
388   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
389     return super.transfer(_to, _value);
390   }
391 
392   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
393     return super.transferFrom(_from, _to, _value);
394   }
395 
396   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
397     return super.approve(_spender, _value);
398   }
399 
400   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
401     return super.increaseApproval(_spender, _addedValue);
402   }
403 
404   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
405     return super.decreaseApproval(_spender, _subtractedValue);
406   }
407 }
408 
409 // File: contracts\CompanyToken.sol
410 
411 /**
412  * @title CompanyToken contract - ERC20 compatible token contract with customized token parameters.
413  * @author Gustavo Guimaraes - <gustavo@starbase.co>
414  */
415 contract CompanyToken is PausableToken, MintableToken {
416     string public name;
417     string public symbol;
418     uint8 public decimals;
419 
420     /**
421      * @dev Contract constructor function
422      * @param _name Token name
423      * @param _symbol Token symbol - up to 4 characters
424      * @param _decimals Decimals for token
425      */
426     constructor(string _name, string _symbol, uint8 _decimals) public {
427         name = _name;
428         symbol = _symbol;
429         decimals = _decimals;
430 
431         pause();
432     }
433 }