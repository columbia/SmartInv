1 pragma solidity ^0.4.21;
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
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     emit Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 
220 
221 /**
222  * @title Ownable
223  * @dev The Ownable contract has an owner address, and provides basic authorization control
224  * functions, this simplifies the implementation of "user permissions".
225  */
226 contract Ownable {
227   address public owner;
228 
229 
230   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232 
233   /**
234    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235    * account.
236    */
237   constructor() public {
238     owner = msg.sender;
239   }
240 
241   /**
242    * @dev Throws if called by any account other than the owner.
243    */
244   modifier onlyOwner() {
245     require(msg.sender == owner);
246     _;
247   }
248 
249   /**
250    * @dev Allows the current owner to transfer control of the contract to a newOwner.
251    * @param newOwner The address to transfer ownership to.
252    */
253   function transferOwnership(address newOwner) public onlyOwner {
254     require(newOwner != address(0));
255     emit OwnershipTransferred(owner, newOwner);
256     owner = newOwner;
257   }
258 
259 }
260 
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is not paused.
275    */
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   /**
282    * @dev Modifier to make a function callable only when the contract is paused.
283    */
284   modifier whenPaused() {
285     require(paused);
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused public {
293     paused = true;
294     emit Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     emit Unpause();
303   }
304 }
305 
306 
307 
308 /**
309  * @title Pausable token
310  * @dev StandardToken modified with pausable transfers.
311  **/
312 contract PausableToken is StandardToken, Pausable {
313 
314   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transferFrom(_from, _to, _value);
320   }
321 
322   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
323     return super.approve(_spender, _value);
324   }
325 
326   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseApproval(_spender, _subtractedValue);
332   }
333 }
334 
335 
336 contract MITT is  PausableToken{
337   string public constant name = "InterstellarMeteorologicalTradeToken";
338   string public constant symbol = "IMTT";
339   uint8 public constant decimals = 18;
340   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
341 
342   constructor() public {
343     totalSupply_ = INITIAL_SUPPLY;
344     balances[msg.sender] = INITIAL_SUPPLY;
345     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
346   }
347 }