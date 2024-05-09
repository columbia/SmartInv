1 pragma solidity 0.5.9;
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
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
37         uint256 c = a * b;
38         require(a == 0 || c / a == b);
39         return c;
40     }
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a / b;
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b <= a);
49         return a - b;
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55         return c;
56     }
57     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
58         uint256 c = add(a,m);
59         uint256 d = sub(c,1);
60         return mul(div(d,m),m);
61     }
62 
63 }
64 
65 /**
66   * @title Burner
67   * @dev Used to burn one percent of a transfer each time
68  */
69 contract Burner {
70     using SafeMath for uint256;
71     uint256 public basePercent = 100;
72     function findOnePercent(uint256 value) public view returns (uint256)  {
73         uint256 roundValue = value.ceil(basePercent);
74         uint256 onePercent = roundValue.mul(basePercent).div(10000);
75         return onePercent;
76     }
77 }
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic, Burner {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev Total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     uint256 amountBurn = findOnePercent(_value);
107     uint256 amountTransfer = _value.sub(amountBurn);
108 
109     balances[msg.sender] = balances[msg.sender].sub(amountTransfer);
110     balances[_to] = balances[_to].add(amountTransfer);
111     totalSupply_ = totalSupply_.sub(amountBurn);
112 
113     emit Transfer(msg.sender, _to, amountTransfer);
114     emit Transfer(msg.sender, address(0), amountBurn);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * https://github.com/ethereum/EIPs/issues/20
134  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151 
152     balances[_from] = balances[_from].sub(_value);
153 
154     uint256 amountBurn = findOnePercent(_value);
155     uint256 amountTransfer = _value.sub(amountBurn);
156 
157     balances[_to] = balances[_to].add(amountTransfer);
158     totalSupply_ = totalSupply_.sub(amountBurn);
159 
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161 
162     emit Transfer(_from, _to, _value);
163     emit Transfer(_from, address(0), amountBurn);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _addedValue The amount of tokens to increase the allowance by.
200    */
201   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
202     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
203     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   /**
208    * @dev Decrease the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
217     uint256 oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 /**
230  * @title Burnable Token
231  * @dev Token that can be irreversibly burned (destroyed).
232  */
233 contract Burnable is BasicToken {
234 
235   event Burn(address indexed burner, uint256 value);
236 
237   /**
238    * @dev Burns a specific amount of tokens.
239    * @param _value The amount of token to be burned.
240    */
241   function burn(uint256 _value) public {
242     _burn(msg.sender, _value);
243   }
244 
245   function _burn(address _who, uint256 _value) internal {
246     require(_value <= balances[_who]);
247     // no need to require value <= totalSupply, since that would imply the
248     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249 
250     balances[_who] = balances[_who].sub(_value);
251     totalSupply_ = totalSupply_.sub(_value);
252     emit Burn(_who, _value);
253     emit Transfer(_who, address(0), _value);
254   }
255 }
256 
257 /**
258  * @title Ownable
259  * @dev The Ownable contract has an owner address, and provides basic authorization control
260  * functions, this simplifies the implementation of "user permissions".
261  */
262 contract Ownable {
263   address public owner;
264 
265 
266   event OwnershipRenounced(address indexed previousOwner);
267   event OwnershipTransferred(
268     address indexed previousOwner,
269     address indexed newOwner
270   );
271 
272 
273   /**
274    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
275    * account.
276    */
277   constructor() public {
278     owner = msg.sender;
279   }
280 
281   /**
282    * @dev Throws if called by any account other than the owner.
283    */
284   modifier onlyOwner() {
285     require(msg.sender == owner);
286     _;
287   }
288 
289   /**
290    * @dev Allows the current owner to relinquish control of the contract.
291    * @notice Renouncing to ownership will leave the contract without an owner.
292    * It will not be possible to call the functions with the `onlyOwner`
293    * modifier anymore.
294    */
295   function renounceOwnership() public onlyOwner {
296     emit OwnershipRenounced(owner);
297     owner = address(0);
298   }
299 
300   /**
301    * @dev Allows the current owner to transfer control of the contract to a newOwner.
302    * @param _newOwner The address to transfer ownership to.
303    */
304   function transferOwnership(address _newOwner) public onlyOwner {
305     _transferOwnership(_newOwner);
306   }
307 
308   /**
309    * @dev Transfers control of the contract to a newOwner.
310    * @param _newOwner The address to transfer ownership to.
311    */
312   function _transferOwnership(address _newOwner) internal {
313     require(_newOwner != address(0));
314     emit OwnershipTransferred(owner, _newOwner);
315     owner = _newOwner;
316   }
317 }
318 
319 /**
320  * @title Claimable
321  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
322  * This allows the new owner to accept the transfer.
323  */
324 contract Claimable is Ownable {
325   address public pendingOwner;
326 
327   /**
328    * @dev Modifier throws if called by any account other than the pendingOwner.
329    */
330   modifier onlyPendingOwner() {
331     require(msg.sender == pendingOwner);
332     _;
333   }
334 
335   /**
336    * @dev Allows the current owner to set the pendingOwner address.
337    * @param newOwner The address to transfer ownership to.
338    */
339   function transferOwnership(address newOwner) onlyOwner public {
340     pendingOwner = newOwner;
341   }
342 
343   /**
344    * @dev Allows the pendingOwner address to finalize the transfer.
345    */
346   function claimOwnership() onlyPendingOwner public {
347     emit OwnershipTransferred(owner, pendingOwner);
348     owner = pendingOwner;
349     pendingOwner = address(0);
350   }
351 }
352 
353 
354 /**
355  * @title Pausable
356  * @dev Base contract which allows children to implement an emergency stop mechanism.
357  */
358 contract Pausable is Ownable {
359   event Pause();
360   event Unpause();
361 
362   bool public paused = false;
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is not paused.
366    */
367   modifier whenNotPaused() {
368     require(!paused);
369     _;
370   }
371 
372   /**
373    * @dev Modifier to make a function callable only when the contract is paused.
374    */
375   modifier whenPaused() {
376     require(paused);
377     _;
378   }
379 
380   /**
381    * @dev called by the owner to pause, triggers stopped state
382    */
383   function pause() onlyOwner whenNotPaused public {
384     paused = true;
385     emit Pause();
386   }
387 
388   /**
389    * @dev called by the owner to unpause, returns to normal state
390    */
391   function unpause() onlyOwner whenPaused public {
392     paused = false;
393     emit Unpause();
394   }
395 }
396 
397 /**
398  * @title ArenaMatchGold
399  * @dev The ArenaMatchGold ERC20 contract
400  */
401 contract ArenaMatchGold is StandardToken, Burnable, Pausable, Claimable {
402 
403   string public constant name = "AMGold Arena Match"; // solium-disable-line uppercase
404   string public constant symbol = "AMG"; // solium-disable-line uppercase
405   uint8 public constant decimals = 18; // solium-disable-line uppercase
406   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
407 
408   /**
409    * @dev Constructor that gives msg.sender all of existing tokens.
410    */
411   constructor() public {
412     totalSupply_ = INITIAL_SUPPLY;
413     balances[msg.sender] = INITIAL_SUPPLY;
414     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
415   }
416   
417   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
418     return super.transfer(_to, _value);
419   }
420 
421   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
422     return super.transferFrom(_from, _to, _value);
423   }
424 
425   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
426     return super.approve(_spender, _value);
427   }
428 
429   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
430     return super.increaseApproval(_spender, _addedValue);
431   }
432 
433   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
434     return super.decreaseApproval(_spender, _subtractedValue);
435   }
436   
437 }
438 
439 /**
440  * @notes All the credits go to the fantastic OpenZeppelin project and its community
441  * See https://github.com/OpenZeppelin/openzeppelin-solidity
442  */