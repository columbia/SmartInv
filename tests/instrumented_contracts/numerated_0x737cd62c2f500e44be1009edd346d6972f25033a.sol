1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
46 
47 /**
48  * @title Destructible
49  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
50  */
51 contract Destructible is Ownable {
52 
53   function Destructible() public payable { }
54 
55   /**
56    * @dev Transfers the current balance to the owner and terminates the contract.
57    */
58   function destroy() onlyOwner public {
59     selfdestruct(owner);
60   }
61 
62   function destroyAndSend(address _recipient) onlyOwner public {
63     selfdestruct(_recipient);
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
95 
96 contract DetailedERC20 is ERC20 {
97   string public name;
98   string public symbol;
99   uint8 public decimals;
100 
101   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
102     name = _name;
103     symbol = _symbol;
104     decimals = _decimals;
105   }
106 }
107 
108 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
109 
110 /**
111  * @title Pausable
112  * @dev Base contract which allows children to implement an emergency stop mechanism.
113  */
114 contract Pausable is Ownable {
115   event Pause();
116   event Unpause();
117 
118   bool public paused = false;
119 
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is not paused.
123    */
124   modifier whenNotPaused() {
125     require(!paused);
126     _;
127   }
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is paused.
131    */
132   modifier whenPaused() {
133     require(paused);
134     _;
135   }
136 
137   /**
138    * @dev called by the owner to pause, triggers stopped state
139    */
140   function pause() onlyOwner whenNotPaused public {
141     paused = true;
142     Pause();
143   }
144 
145   /**
146    * @dev called by the owner to unpause, returns to normal state
147    */
148   function unpause() onlyOwner whenPaused public {
149     paused = false;
150     Unpause();
151   }
152 }
153 
154 // File: zeppelin-solidity/contracts/math/SafeMath.sol
155 
156 /**
157  * @title SafeMath
158  * @dev Math operations with safety checks that throw on error
159  */
160 library SafeMath {
161 
162   /**
163   * @dev Multiplies two numbers, throws on overflow.
164   */
165   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166     if (a == 0) {
167       return 0;
168     }
169     uint256 c = a * b;
170     assert(c / a == b);
171     return c;
172   }
173 
174   /**
175   * @dev Integer division of two numbers, truncating the quotient.
176   */
177   function div(uint256 a, uint256 b) internal pure returns (uint256) {
178     // assert(b > 0); // Solidity automatically throws when dividing by 0
179     uint256 c = a / b;
180     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181     return c;
182   }
183 
184   /**
185   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
186   */
187   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188     assert(b <= a);
189     return a - b;
190   }
191 
192   /**
193   * @dev Adds two numbers, throws on overflow.
194   */
195   function add(uint256 a, uint256 b) internal pure returns (uint256) {
196     uint256 c = a + b;
197     assert(c >= a);
198     return c;
199   }
200 }
201 
202 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
203 
204 /**
205  * @title Basic token
206  * @dev Basic version of StandardToken, with no allowances.
207  */
208 contract BasicToken is ERC20Basic {
209   using SafeMath for uint256;
210 
211   mapping(address => uint256) balances;
212 
213   uint256 totalSupply_;
214 
215   /**
216   * @dev total number of tokens in existence
217   */
218   function totalSupply() public view returns (uint256) {
219     return totalSupply_;
220   }
221 
222   /**
223   * @dev transfer token for a specified address
224   * @param _to The address to transfer to.
225   * @param _value The amount to be transferred.
226   */
227   function transfer(address _to, uint256 _value) public returns (bool) {
228     require(_to != address(0));
229     require(_value <= balances[msg.sender]);
230 
231     // SafeMath.sub will throw if there is not enough balance.
232     balances[msg.sender] = balances[msg.sender].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     Transfer(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239   * @dev Gets the balance of the specified address.
240   * @param _owner The address to query the the balance of.
241   * @return An uint256 representing the amount owned by the passed address.
242   */
243   function balanceOf(address _owner) public view returns (uint256 balance) {
244     return balances[_owner];
245   }
246 
247 }
248 
249 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
250 
251 /**
252  * @title Standard ERC20 token
253  *
254  * @dev Implementation of the basic standard token.
255  * @dev https://github.com/ethereum/EIPs/issues/20
256  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
257  */
258 contract StandardToken is ERC20, BasicToken {
259 
260   mapping (address => mapping (address => uint256)) internal allowed;
261 
262 
263   /**
264    * @dev Transfer tokens from one address to another
265    * @param _from address The address which you want to send tokens from
266    * @param _to address The address which you want to transfer to
267    * @param _value uint256 the amount of tokens to be transferred
268    */
269   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
270     require(_to != address(0));
271     require(_value <= balances[_from]);
272     require(_value <= allowed[_from][msg.sender]);
273 
274     balances[_from] = balances[_from].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277     Transfer(_from, _to, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283    *
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param _spender The address which will spend the funds.
289    * @param _value The amount of tokens to be spent.
290    */
291   function approve(address _spender, uint256 _value) public returns (bool) {
292     allowed[msg.sender][_spender] = _value;
293     Approval(msg.sender, _spender, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Function to check the amount of tokens that an owner allowed to a spender.
299    * @param _owner address The address which owns the funds.
300    * @param _spender address The address which will spend the funds.
301    * @return A uint256 specifying the amount of tokens still available for the spender.
302    */
303   function allowance(address _owner, address _spender) public view returns (uint256) {
304     return allowed[_owner][_spender];
305   }
306 
307   /**
308    * @dev Increase the amount of tokens that an owner allowed to a spender.
309    *
310    * approve should be called when allowed[_spender] == 0. To increment
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _addedValue The amount of tokens to increase the allowance by.
316    */
317   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
318     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
319     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    *
326    * approve should be called when allowed[_spender] == 0. To decrement
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param _spender The address which will spend the funds.
331    * @param _subtractedValue The amount of tokens to decrease the allowance by.
332    */
333   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
334     uint oldValue = allowed[msg.sender][_spender];
335     if (_subtractedValue > oldValue) {
336       allowed[msg.sender][_spender] = 0;
337     } else {
338       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
339     }
340     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
341     return true;
342   }
343 
344 }
345 
346 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
347 
348 /**
349  * @title Pausable token
350  * @dev StandardToken modified with pausable transfers.
351  **/
352 contract PausableToken is StandardToken, Pausable {
353 
354   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
355     return super.transfer(_to, _value);
356   }
357 
358   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
359     return super.transferFrom(_from, _to, _value);
360   }
361 
362   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
363     return super.approve(_spender, _value);
364   }
365 
366   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
367     return super.increaseApproval(_spender, _addedValue);
368   }
369 
370   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
371     return super.decreaseApproval(_spender, _subtractedValue);
372   }
373 }
374 
375 // File: contracts/Mahjongcoin.sol
376 
377 contract Mahjongcoin is PausableToken, DetailedERC20, Destructible {
378   function Mahjongcoin() public DetailedERC20('麻将币', '?', 0) {
379     totalSupply_ = 9e9;
380     balances[msg.sender] = totalSupply_;
381   }
382 }