1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 
38 }
39 
40 
41 
42 
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Unpause();
50 
51   bool public paused = true;
52 
53 
54   /**
55    * @dev modifier to allow actions only when the contract IS paused
56    */
57   modifier whenNotPaused() {
58       require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev modifier to allow actions only when the contract IS NOT paused
64    */
65   modifier whenPaused {
66       require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to unpause, returns to normal state
72    */
73   function unpause() onlyOwner whenPaused public returns (bool) {
74     paused = false;
75     Unpause();
76     return true;
77   }
78 
79     /**
80    * @dev called by the owner to pause, returns to paused state
81    */
82   function pause() onlyOwner whenNotPaused public returns (bool) {
83     paused = true;
84     return false;
85   }
86 }
87 
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20Basic {
95   uint public totalSupply;
96   function balanceOf(address who) constant public returns (uint);
97   function transfer(address to, uint value) public;
98   event Transfer(address indexed from, address indexed to, uint value);
99 }
100 
101 
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant public returns (uint);
110   function transferFrom(address from, address to, uint value) public;
111   function approve(address spender, uint value) public;
112   event Approval(address indexed owner, address indexed spender, uint value);
113 }
114 
115 
116 /**
117  * Math operations with safety checks
118  */
119 library SafeMath {
120   function mul(uint a, uint b) internal pure returns (uint) {
121     uint c = a * b;
122     assert(a == 0 || c / a == b);
123     return c;
124   }
125 
126   function div(uint a, uint b) internal pure returns (uint) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     uint c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130     return c;
131   }
132 
133   function sub(uint a, uint b) internal pure returns (uint) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   function add(uint a, uint b) internal pure returns (uint) {
139     uint c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 
144   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
145     return a >= b ? a : b;
146   }
147 
148   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
149     return a < b ? a : b;
150   }
151 
152   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
153     return a >= b ? a : b;
154   }
155 
156   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
157     return a < b ? a : b;
158   }
159 }
160 
161 
162 
163 
164 /**
165  * @title Basic token
166  * @dev Basic version of StandardToken, with no allowances.
167  */
168 contract BasicToken is ERC20Basic {
169   using SafeMath for uint;
170 
171   mapping(address => uint) balances;
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint _value) public {
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) constant public returns (uint balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implemantation of the basic standart token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is BasicToken, ERC20 {
206 
207   mapping (address => mapping (address => uint)) allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint the amout of tokens to be transfered
215    */
216   function transferFrom(address _from, address _to, uint _value) public {
217     var _allowance = allowed[_from][msg.sender];
218 
219     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
220     // if (_value > _allowance) throw;
221 
222     balances[_to] = balances[_to].add(_value);
223     balances[_from] = balances[_from].sub(_value);
224     allowed[_from][msg.sender] = _allowance.sub(_value);
225     Transfer(_from, _to, _value);
226   }
227 
228   /**
229    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint _value) public {
234     allowed[msg.sender][_spender] = _value;
235     Approval(msg.sender, _spender, _value);
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens than an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint specifing the amount of tokens still avaible for the spender.
243    */
244   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
245     return allowed[_owner][_spender];
246   }
247 
248 }
249 
250 
251 
252 
253 /**
254  * Pausable token
255  *
256  * Simple ERC20 Token example, with pausable token transfer
257  **/
258 
259 contract PausableToken is StandardToken, Pausable {
260 
261   function transfer(address _to, uint _value) whenNotPaused public {
262     super.transfer(_to, _value);
263   }
264 
265   function transferFrom(address _from, address _to, uint _value) whenNotPaused public {
266     super.transferFrom(_from, _to, _value);
267   }
268 }
269 
270 
271 
272 
273 
274 
275 /**
276  * @title GODToken
277  * @dev GOD Token contract
278  */
279 contract GODToken is PausableToken {
280   using SafeMath for uint256;
281 
282   string public name = "GOD Token";
283   string public symbol = "GOD";
284   uint public decimals = 18;
285 
286 
287   uint256 private constant INITIAL_SUPPLY = 3000000000 ether;
288 
289 
290   /**
291    * @dev Contructor that gives msg.sender all of existing tokens. 
292    */
293   function GODToken() public {
294     totalSupply = INITIAL_SUPPLY;
295     balances[msg.sender] = INITIAL_SUPPLY;
296   }
297 
298   function changeSymbolName(string symbolName) onlyOwner public
299   {
300       symbol = symbolName;
301   }
302 
303    function changeName(string symbolName) onlyOwner public
304   {
305       name = symbolName;
306   }
307 }