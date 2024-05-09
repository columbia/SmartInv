1 pragma solidity ^0.4.23;
2 
3 // openzeppelin-solidity: 1.9.0
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
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     emit Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     emit Unpause();
86   }
87 }
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
99     if (a == 0) {
100       return 0;
101     }
102     c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   /**
108   * @dev Integer division of two numbers, truncating the quotient.
109   */
110   function div(uint256 a, uint256 b) internal pure returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     // uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return a / b;
115   }
116 
117   /**
118   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   /**
126   * @dev Adds two numbers, throws on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
129     c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 
135 /**
136  * @title ERC20Basic
137  * @dev Simpler version of ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/179
139  */
140 contract ERC20Basic {
141   function totalSupply() public view returns (uint256);
142   function balanceOf(address who) public view returns (uint256);
143   function transfer(address to, uint256 value) public returns (bool);
144   event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender) public view returns (uint256);
153   function transferFrom(address from, address to, uint256 value) public returns (bool);
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 /**
159  * @title Basic token
160  * @dev Basic version of StandardToken, with no allowances.
161  */
162 contract BasicToken is ERC20Basic {
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167   uint256 totalSupply_;
168 
169   /**
170   * @dev total number of tokens in existence
171   */
172   function totalSupply() public view returns (uint256) {
173     return totalSupply_;
174   }
175 
176   /**
177   * @dev transfer token for a specified address
178   * @param _to The address to transfer to.
179   * @param _value The amount to be transferred.
180   */
181   function transfer(address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[msg.sender]);
184 
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     emit Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * @dev https://github.com/ethereum/EIPs/issues/20
207  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     emit Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285     uint oldValue = allowed[msg.sender][_spender];
286     if (_subtractedValue > oldValue) {
287       allowed[msg.sender][_spender] = 0;
288     } else {
289       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290     }
291     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295 }
296 
297 /**
298  * @title Pausable token
299  * @dev StandardToken modified with pausable transfers.
300  **/
301 contract PausableToken is StandardToken, Pausable {
302 
303   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
304     return super.transfer(_to, _value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transferFrom(_from, _to, _value);
309   }
310 
311   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
312     return super.approve(_spender, _value);
313   }
314 
315   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
316     return super.increaseApproval(_spender, _addedValue);
317   }
318 
319   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
320     return super.decreaseApproval(_spender, _subtractedValue);
321   }
322 }
323 
324 contract FrameCoin is PausableToken {
325 
326   string public constant name = "FrameCoin";
327   string public constant symbol = "FRAC";
328   uint8 public constant decimals = 18;
329   uint256 public constant INITIAL_SUPPLY = 265e6 * 10**uint256(decimals);
330 
331   function FrameCoin() public {
332     totalSupply_ = INITIAL_SUPPLY;
333     balances[msg.sender] = INITIAL_SUPPLY;
334     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
335   }
336 }