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
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60  
61   mapping(address => uint256) balances;
62  
63   uint256 totalSupply_;
64  
65   /**
66   * @dev Total number of tokens in existence
67   */
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71  
72   /**
73   * @dev Transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80  
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86  
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256) {
93     return balances[_owner];
94   }
95  
96 }
97  
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * https://github.com/ethereum/EIPs/issues/20
103  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106  
107   mapping (address => mapping (address => uint256)) internal allowed;
108  
109  
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120  
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     emit Transfer(_from, _to, _value);
125     return true;
126   }
127  
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     emit Approval(msg.sender, _spender, _value);
140     return true;
141   }
142  
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152  
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    * @param _spender The address which will spend the funds.
160    * @param _addedValue The amount of tokens to increase the allowance by.
161    */
162   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
163     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167  
168   /**
169    * @dev Decrease the amount of tokens that an owner allowed to a spender.
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
178     uint256 oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187  
188 }
189  
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197  
198  
199   event OwnershipRenounced(address indexed previousOwner);
200   event OwnershipTransferred(
201     address indexed previousOwner,
202     address indexed newOwner
203   );
204  
205  
206   /**
207    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
208    * account.
209    */
210   constructor() public {
211     owner = msg.sender;
212   }
213  
214   /**
215    * @dev Throws if called by any account other than the owner.
216    */
217   modifier onlyOwner() {
218     require(msg.sender == owner);
219     _;
220   }
221  
222   /**
223    * @dev Allows the current owner to relinquish control of the contract.
224    * @notice Renouncing to ownership will leave the contract without an owner.
225    * It will not be possible to call the functions with the `onlyOwner`
226    * modifier anymore.
227    */
228   function renounceOwnership() public onlyOwner {
229     emit OwnershipRenounced(owner);
230     owner = address(0);
231   }
232  
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param _newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address _newOwner) public onlyOwner {
238     _transferOwnership(_newOwner);
239   }
240  
241   /**
242    * @dev Transfers control of the contract to a newOwner.
243    * @param _newOwner The address to transfer ownership to.
244    */
245   function _transferOwnership(address _newOwner) internal {
246     require(_newOwner != address(0));
247     emit OwnershipTransferred(owner, _newOwner);
248     owner = _newOwner;
249   }
250 }
251  
252 /**
253  * @title Claimable
254  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
255  * This allows the new owner to accept the transfer.
256  */
257 contract Claimable is Ownable {
258   address public pendingOwner;
259  
260   /**
261    * @dev Modifier throws if called by any account other than the pendingOwner.
262    */
263   modifier onlyPendingOwner() {
264     require(msg.sender == pendingOwner);
265     _;
266   }
267  
268   /**
269    * @dev Allows the current owner to set the pendingOwner address.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function transferOwnership(address newOwner) onlyOwner public {
273     pendingOwner = newOwner;
274   }
275  
276   /**
277    * @dev Allows the pendingOwner address to finalize the transfer.
278    */
279   function claimOwnership() onlyPendingOwner public {
280     emit OwnershipTransferred(owner, pendingOwner);
281     owner = pendingOwner;
282     pendingOwner = address(0);
283   }
284 }
285  
286  
287 /**
288  * @title Pausable
289  * @dev Base contract which allows children to implement an emergency stop mechanism.
290  */
291 contract Pausable is Ownable {
292   event Pause();
293   event Unpause();
294  
295   bool public paused = false;
296  
297   /**
298    * @dev Modifier to make a function callable only when the contract is not paused.
299    */
300   modifier whenNotPaused() {
301     require(!paused);
302     _;
303   }
304  
305   /**
306    * @dev Modifier to make a function callable only when the contract is paused.
307    */
308   modifier whenPaused() {
309     require(paused);
310     _;
311   }
312  
313   /**
314    * @dev called by the owner to pause, triggers stopped state
315    */
316   function pause() onlyOwner whenNotPaused public {
317     paused = true;
318     emit Pause();
319   }
320  
321   /**
322    * @dev called by the owner to unpause, returns to normal state
323    */
324   function unpause() onlyOwner whenPaused public {
325     paused = false;
326     emit Unpause();
327   }
328 }
329  
330 /**
331  * @title Upcoin
332  * @dev The Upcoin ERC20 contract
333  */
334 contract Upcoin is StandardToken, Pausable, Claimable {
335  
336   string public constant name = "Upcoin"; // solium-disable-line uppercase
337   string public constant symbol = "UPC"; // solium-disable-line uppercase
338   uint8 public constant decimals = 18; // solium-disable-line uppercase
339  
340   uint256 public constant INITIAL_SUPPLY = 600000000 * (10 ** uint256(decimals));
341  
342   /**
343    * @dev Constructor that gives msg.sender all of existing tokens.
344    */
345   constructor() public {
346     totalSupply_ = INITIAL_SUPPLY;
347     balances[msg.sender] = INITIAL_SUPPLY;
348     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
349   }
350   
351   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
352     return super.transfer(_to, _value);
353   }
354  
355   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
356     return super.transferFrom(_from, _to, _value);
357   }
358  
359   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
360     return super.approve(_spender, _value);
361   }
362  
363   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
364     return super.increaseApproval(_spender, _addedValue);
365   }
366  
367   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
368     return super.decreaseApproval(_spender, _subtractedValue);
369   }
370   
371 }
372  
373 /**
374  * @notes All the credits go to the fantastic OpenZeppelin project and its community
375  * See https://github.com/OpenZeppelin/openzeppelin-solidity
376  */