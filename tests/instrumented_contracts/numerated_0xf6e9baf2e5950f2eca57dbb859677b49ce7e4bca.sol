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
50   event Pause();
51 
52   bool public paused = true;
53 
54 
55   /**
56    * @dev modifier to allow actions only when the contract IS paused
57    */
58   modifier whenNotPaused() {
59       require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev modifier to allow actions only when the contract IS NOT paused
65    */
66   modifier whenPaused {
67       require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused public returns (bool) {
75     paused = false;
76     Unpause();
77     return true;
78   }
79 
80     /**
81    * @dev called by the owner to pause, returns to paused state
82    */
83   function pause() onlyOwner whenNotPaused public returns (bool) {
84     paused = true;
85     Pause();
86     return false;
87   }
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20Basic {
97   uint public totalSupply;
98   function balanceOf(address who) constant public returns (uint);
99   function transfer(address to, uint value) public;
100   event Transfer(address indexed from, address indexed to, uint value);
101 }
102 
103 
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant public returns (uint);
112   function transferFrom(address from, address to, uint value) public;
113   function approve(address spender, uint value) public;
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * Math operations with safety checks
120  */
121 library SafeMath {
122   function mul(uint a, uint b) internal pure returns (uint) {
123     uint c = a * b;
124     assert(a == 0 || c / a == b);
125     return c;
126   }
127 
128   function div(uint a, uint b) internal pure returns (uint) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   function sub(uint a, uint b) internal pure returns (uint) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function add(uint a, uint b) internal pure returns (uint) {
141     uint c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 
146   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
147     return a >= b ? a : b;
148   }
149 
150   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
151     return a < b ? a : b;
152   }
153 
154   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
155     return a >= b ? a : b;
156   }
157 
158   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
159     return a < b ? a : b;
160   }
161 }
162 
163 
164 
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint;
172 
173   mapping(address => uint) balances;
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint _value) public {
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) constant public returns (uint balance) {
192     return balances[_owner];
193   }
194 
195 }
196 
197 
198 
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implemantation of the basic standart token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is BasicToken, ERC20 {
208 
209   mapping (address => mapping (address => uint)) allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint the amout of tokens to be transfered
217    */
218   function transferFrom(address _from, address _to, uint _value) public {
219     var _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // if (_value > _allowance) throw;
223 
224     balances[_to] = balances[_to].add(_value);
225     balances[_from] = balances[_from].sub(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228   }
229 
230   /**
231    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint _value) public {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens than an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint specifing the amount of tokens still avaible for the spender.
245    */
246   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
247     return allowed[_owner][_spender];
248   }
249 
250 }
251 
252 
253 
254 
255 /**
256  * Pausable token
257  *
258  * Simple ERC20 Token example, with pausable token transfer and special method for token distribution
259  **/
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263   function transfer(address _to, uint _value) whenNotPaused public {
264     super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address _from, address _to, uint _value) whenNotPaused public {
268     super.transferFrom(_from, _to, _value);
269   }
270 
271   function transferDistribution(address _to, uint _value) onlyOwner public {
272     super.transfer(_to, _value);
273   }
274 }
275 
276 
277 
278 
279 
280 
281 /**
282  * @title DATToken
283  * @dev DAT Token contract
284  */
285 contract DATToken is PausableToken {
286   using SafeMath for uint256;
287 
288   string public name = "DAT Token";
289   string public symbol = "DAT";
290   uint public decimals = 18;
291 
292 
293   uint256 private constant INITIAL_SUPPLY = 2653841597973271663912484125 wei;
294 
295 
296   /**
297    * @dev Contructor that gives msg.sender all of existing tokens. 
298    */
299   function DATToken(address _wallet) public {
300     totalSupply = INITIAL_SUPPLY;
301     balances[_wallet] = INITIAL_SUPPLY;
302   }
303 
304   function changeSymbolName(string symbolName) onlyOwner public
305   {
306       symbol = symbolName;
307   }
308 
309    function changeName(string symbolName) onlyOwner public
310   {
311       name = symbolName;
312   }
313 }
314 
315 
316 
317 
318 
319 contract DatumTokenDistributor is Ownable {
320   DATToken public token;
321   address public distributorWallet;
322   
323   function DatumTokenDistributor(address _distributorWallet) public
324   {
325      distributorWallet = _distributorWallet;
326   }
327 
328   function setToken(DATToken _token) onlyOwner public
329   {
330      token = _token;
331   }
332 
333   function distributeToken(address[] addresses, uint256[] amounts) public {
334      require(msg.sender == distributorWallet);
335      require(addresses.length == amounts.length);
336 
337      for (uint i = 0; i < addresses.length; i++) {
338          token.transferDistribution(addresses[i], amounts[i]);
339      }
340   }
341 
342   function resetOwnership() onlyOwner public
343   {
344       token.transferOwnership(msg.sender);
345   }
346 }