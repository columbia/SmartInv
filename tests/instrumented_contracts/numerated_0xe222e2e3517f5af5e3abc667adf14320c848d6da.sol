1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title introduce
5  * @dev erc20: balance, transfer, approve, transferFrom, allowrance
6  * @dev plus functions: ownable, pausable
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that revert on error
12  */
13 library SafeMath {
14   /**
15   * @dev Multiplies two numbers, reverts on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     uint256 c = _a * _b;
26     require(c / _a == _b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     require(_b > 0); // Solidity only automatically asserts when dividing by 0
36     uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     require(_b <= _a);
47     uint256 c = _a - _b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     uint256 c = _a + _b;
57     require(c >= _a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant public returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) constant public returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101   mapping(address => uint256) balances;
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) constant public returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133   uint8 public constant decimals = 18;
134   uint256 public constant ONE_TOKEN = (10 ** uint256(decimals));
135   mapping (address => mapping (address => uint256)) allowed;
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     uint256 _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169     allowed[msg.sender][_spender] = _value;
170     emit Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still avaible for the spender.
179    */
180   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 }
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191   address public owner;
192 
193   /**
194    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   constructor() public {
198     owner = msg.sender;
199   }
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner);
206     _;
207   }
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) public onlyOwner {
214     if (newOwner != address(0)) {
215       owner = newOwner;
216     }
217   }
218 }
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225   event Pause();
226   event Unpause();
227 
228   bool public paused = false;
229 
230   /**
231    * @dev modifier to allow actions only when the contract IS paused
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237 
238   /**
239    * @dev modifier to allow actions only when the contract IS NOT paused
240    */
241   modifier whenPaused {
242     require(paused);
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public returns (bool) {
250     paused = true;
251     emit Pause();
252     return true;
253   }
254 
255   /**
256    * @dev called by the owner to unpause, returns to normal state
257    */
258   function unpause() onlyOwner whenPaused public returns (bool) {
259     paused = false;
260     emit Unpause();
261     return true;
262   }
263 }
264 
265 /**
266  * @title Slash Token
267  * @dev ERC20 Slash Token (SLASH)
268  */
269 contract SlashToken is StandardToken, Pausable {
270   string public constant name = 'Slash Token';                       // Set the token name for display
271   string public constant symbol = 'SLASH';                                       // Set the token symbol for display
272   uint256 constant Thousand_Token = 1000 * ONE_TOKEN;
273   uint256 constant Million_Token = 1000 * Thousand_Token;
274   uint256 constant Billion_Token = 1000 * Million_Token;
275   uint256 public constant TOTAL_TOKENS = 10 * Billion_Token;
276 
277   /**
278    * @dev Slash Token Constructor
279    * Runs only on initial contract creation.
280    */
281   constructor() public {
282     totalSupply = TOTAL_TOKENS;                               // Set the total supply
283     balances[msg.sender] = TOTAL_TOKENS;                      // Creator address is assigned all
284   }
285 
286   /**
287    * @dev Transfer token for a specified address when not paused
288    * @param _to The address to transfer to.
289    * @param _value The amount to be transferred.
290    */
291   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
292     require(_to != address(0));
293     return super.transfer(_to, _value);
294   }
295 
296   /**
297    * @dev Transfer tokens from one address to another when not paused
298    * @param _from address The address which you want to send tokens from
299    * @param _to address The address which you want to transfer to
300    * @param _value uint256 the amount of tokens to be transferred
301    */
302   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
303     require(_to != address(0));
304     return super.transferFrom(_from, _to, _value);
305   }
306 
307   /**
308    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
309    * @param _spender The address which will spend the funds.
310    * @param _value The amount of tokens to be spent.
311    */
312   function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
313     return super.approve(_spender, _value);
314   }
315 }