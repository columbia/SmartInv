1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable 
52 {
53   address public owner;
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param _newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address _newOwner) public onlyOwner {
78     _transferOwnership(_newOwner);
79   }
80   /**
81    * @dev Transfers control of the contract to a newOwner.
82    * @param _newOwner The address to transfer ownership to.
83    */
84   function _transferOwnership(address _newOwner) internal {
85     require(_newOwner != address(0));
86     emit OwnershipTransferred(owner, _newOwner);
87     owner = _newOwner;
88   }
89 }
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is Ownable 
95 {
96   event Pause();
97   event Unpause();
98   bool public paused = false;
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106   /**
107    * @dev Modifier to make a function callable only when the contract is paused.
108    */
109   modifier whenPaused() {
110     require(paused);
111     _;
112   }
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() onlyOwner whenNotPaused public {
117     paused = true;
118     emit Pause();
119   }
120   /**
121    * @dev called by the owner to unpauseunpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     emit Unpause();
126   }
127 }
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic 
134 {
135   function totalSupply() public view returns (uint256);
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic 
145 {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(
150     address indexed owner,
151     address indexed spender,
152     uint256 value
153   );
154 }
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic 
160 {
161   using SafeMath for uint256;
162   mapping(address => uint256) balances;
163   uint256 totalSupply_;
164   /**
165   * @dev total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return totalSupply_;
169   }
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 }
192 /**
193  * @title Standard ERC20 token
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken 
199 {
200   mapping (address => mapping (address => uint256)) internal allowed;
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     emit Transfer(_from, _to, _value);
215     return true;
216   }
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(address _owner, address _spender) public view returns (uint256) {
240     return allowed[_owner][_spender];
241   }
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
268     uint256 oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 }
278 /**
279  * @title Pausable token
280  * @dev StandardToken modified with pausable transfers.
281  **/
282 contract PausableToken is StandardToken, Pausable 
283 {
284   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
285     return super.transfer(_to, _value);
286   }
287   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
288     return super.transferFrom(_from, _to, _value);
289   }
290   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
291     return super.approve(_spender, _value);
292   }
293   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
294     return super.increaseApproval(_spender, _addedValue);
295   }
296   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
297     return super.decreaseApproval(_spender, _subtractedValue);
298   }
299 }
300 /**
301  * @title Frozenable Token
302  * @dev Illegal address that can be frozened.
303  */
304 contract FrozenableToken is PausableToken
305 {
306     mapping (address => bool) public frozenAccount;
307     event FrozenFunds(address indexed to, bool frozen);
308     modifier whenNotFrozen(address _who) {
309       require(!frozenAccount[msg.sender] && !frozenAccount[_who]);
310       _;
311     }
312     function freezeAccount(address _to, bool _freeze) public onlyOwner {
313         require(_to != address(0));
314         frozenAccount[_to] = _freeze;
315         emit FrozenFunds(_to, _freeze);
316     }
317 
318     function transfer(address _to, uint256 _value) public whenNotFrozen(_to) returns (bool) {
319       return super.transfer(_to, _value);
320     }
321     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen(_to) whenNotFrozen(_from) returns (bool) {
322       return super.transferFrom(_from, _to, _value);
323     }
324     function approve(address _spender, uint256 _value) public whenNotFrozen(_spender) returns (bool) {
325       return super.approve(_spender, _value);
326     }
327     function increaseApproval(address _spender, uint256 _addedValue) public whenNotFrozen(_spender) returns (bool success) {
328       return super.increaseApproval(_spender, _addedValue);
329     }
330     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotFrozen(_spender) returns (bool success) {
331       return super.decreaseApproval(_spender, _subtractedValue);
332     }
333 }
334 
335 /**
336  * @title TokenDestructible:
337  * @author Remco Bloemen <remco@2π.com>
338  * @dev Base contract that can be destroyed by owner. All funds in contract including
339  * listed tokens will be sent to the owner.
340  */
341 contract TokenDestructible is Ownable,FrozenableToken {
342 
343   constructor() public payable { }
344 
345   /**
346    * @notice Terminate contract and refund to owner
347    * @param _tokens List of addresses of ERC20 or ERC20Basic token contracts to
348    refund.
349    * @notice The called token contracts could try to re-enter this contract. Only
350    supply token contracts you trust.
351    */
352   function destroy(address[] _tokens) public onlyOwner {
353 
354     // Transfer tokens to owner
355     for (uint256 i = 0; i < _tokens.length; i++) {
356       ERC20Basic token = ERC20Basic(_tokens[i]);
357       uint256 balance = token.balanceOf(this);
358       token.transfer(owner, balance);
359     }
360 
361     // Transfer Eth to owner and terminate contract
362     selfdestruct(owner);
363   }
364 }
365 /**
366  * @title WuKong Token
367  */
368 contract WuKongChain is PausableToken, FrozenableToken, TokenDestructible 
369 {
370     string public name = "WuKongChain";
371     string public symbol = "WKC";
372     uint256 public decimals = 4;
373     uint256 INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
374     /**
375      * @dev Initializes the total release
376      */
377     constructor() public {
378         totalSupply_ = INITIAL_SUPPLY;
379         balances[msg.sender] = totalSupply_;
380         emit Transfer(address(0), msg.sender, totalSupply_);
381     }
382 }