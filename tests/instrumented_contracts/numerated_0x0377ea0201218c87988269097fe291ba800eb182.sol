1 pragma solidity 0.4.18;
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
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
101     uint256 c = a * b;
102     assert(a == 0 || c / a == b);
103     return c;
104   }
105 
106   function div(uint256 a, uint256 b) internal constant returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   uint256 public totalSupply;
134   function balanceOf(address who) public constant returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 // File: zeppelin-solidity/contracts/token/BasicToken.sol
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) balances;
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public constant returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender) public constant returns (uint256);
184   function transferFrom(address from, address to, uint256 value) public returns (bool);
185   function approve(address spender, uint256 value) public returns (bool);
186   event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: zeppelin-solidity/contracts/token/StandardToken.sol
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211 
212     uint256 _allowance = allowed[_from][msg.sender];
213 
214     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
215     // require (_value <= _allowance);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = _allowance.sub(_value);
220     Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    */
256   function increaseApproval (address _spender, uint _addedValue)
257     returns (bool success) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   function decreaseApproval (address _spender, uint _subtractedValue)
264     returns (bool success) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 // File: zeppelin-solidity/contracts/token/PausableToken.sol
278 
279 /**
280  * @title Pausable token
281  *
282  * @dev StandardToken modified with pausable transfers.
283  **/
284 
285 contract PausableToken is StandardToken, Pausable {
286 
287   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
288     return super.transfer(_to, _value);
289   }
290 
291   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
292     return super.transferFrom(_from, _to, _value);
293   }
294 
295   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
296     return super.approve(_spender, _value);
297   }
298 
299   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
300     return super.increaseApproval(_spender, _addedValue);
301   }
302 
303   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
304     return super.decreaseApproval(_spender, _subtractedValue);
305   }
306 }
307 
308 // File: contracts/SimplePOAToken.sol
309 
310 contract SimplePOAToken is PausableToken {
311 
312   string public constant name = "BB_RE_DE_04315_Leipzig_0001";
313   string public constant symbol = "LZ1";
314   uint256 public constant initialSupply = 1800 * (10 ** uint256(decimals));
315   uint8 public constant decimals = 18;
316 
317   event Purchase(address from, uint256 amount);
318 
319   function SimplePOAToken()
320     public
321   {
322     totalSupply = initialSupply;
323     balances[msg.sender] = initialSupply;
324     Transfer(address(0), msg.sender, initialSupply);
325   }
326 
327   function ()
328     public
329     payable
330   {
331     owner.transfer(msg.value);
332     Purchase(msg.sender, msg.value);
333   }
334 
335 }