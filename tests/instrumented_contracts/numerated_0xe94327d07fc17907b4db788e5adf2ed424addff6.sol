1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) returns (bool);
54   function approve(address spender, uint256 value) returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amout of tokens to be transfered
109    */
110   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
111     var _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // require (_value <= _allowance);
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) returns (bool) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     //  allowance to zero by calling `approve(_spender, 0)` if it is not
132     //  already 0 to mitigate the race condition described here:
133     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifing the amount of tokens still avaible for the spender.
146    */
147   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151 }
152 
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160   address public owner;
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner {
186     if (newOwner != address(0)) {
187       owner = newOwner;
188     }
189   }
190 
191 }
192 
193 
194 /**
195  * @title Pausable
196  * @dev Base contract which allows children to implement an emergency stop mechanism.
197  */
198 contract Pausable is Ownable {
199   event Pause();
200   event Unpause();
201 
202   bool public paused = false;
203 
204 
205   /**
206    * @dev modifier to allow actions only when the contract IS paused
207    */
208   modifier whenNotPaused() {
209     require(!paused);
210     _;
211   }
212 
213   /**
214    * @dev modifier to allow actions only when the contract IS NOT paused
215    */
216   modifier whenPaused {
217     require(paused);
218     _;
219   }
220 
221   /**
222    * @dev called by the owner to pause, triggers stopped state
223    */
224   function pause() onlyOwner whenNotPaused returns (bool) {
225     paused = true;
226     Pause();
227     return true;
228   }
229 
230   /**
231    * @dev called by the owner to unpause, returns to normal state
232    */
233   function unpause() onlyOwner whenPaused returns (bool) {
234     paused = false;
235     Unpause();
236     return true;
237   }
238 }
239 
240 /**
241  * Pausable token
242  *
243  * Simple ERC20 Token example, with pausable token creation
244  **/
245 
246 contract PausableToken is StandardToken, Pausable {
247 
248   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
249     return super.transfer(_to, _value);
250   }
251 
252   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
253     return super.transferFrom(_from, _to, _value);
254   }
255 }
256 
257 
258 contract Initializable {
259   bool public initialized = false;
260 
261   modifier afterInitialized {
262     require(initialized);
263     _;
264   }
265 
266   modifier beforeInitialized {
267     require(!initialized);
268     _;
269   }
270 
271   function endInitialization() internal beforeInitialized returns (bool) {
272     initialized = true;
273     return true;
274   }
275 }
276 
277 
278 /**
279  * @title REP2 Token
280  * @dev REP2 Mintable Token with migration from legacy contract
281  */
282 contract RepToken is Initializable, PausableToken {
283   ERC20Basic public legacyRepContract;
284   uint256 public targetSupply;
285 
286   string public constant name = "Reputation";
287   string public constant symbol = "REP";
288   uint256 public constant decimals = 18;
289 
290   event Migrated(address indexed holder, uint256 amount);
291 
292   /**
293     * @dev Creates a new RepToken instance
294     * @param _legacyRepContract Address of the legacy ERC20Basic REP contract to migrate balances from
295     */
296   function RepToken(address _legacyRepContract, uint256 _amountUsedToFreeze, address _accountToSendFrozenRepTo) {
297     require(_legacyRepContract != 0);
298     legacyRepContract = ERC20Basic(_legacyRepContract);
299     targetSupply = legacyRepContract.totalSupply();
300     balances[_accountToSendFrozenRepTo] = _amountUsedToFreeze;
301     totalSupply = _amountUsedToFreeze;
302     pause();
303   }
304 
305   /**
306     * @dev Copies the balance of a batch of addresses from the legacy contract
307     * @param _holders Array of addresses to migrate balance
308     * @return True if operation was completed
309     */
310   function migrateBalances(address[] _holders) onlyOwner beforeInitialized returns (bool) {
311     for (uint256 i = 0; i < _holders.length; i++) {
312       migrateBalance(_holders[i]);
313     }
314     return true;
315   }
316 
317   /**
318     * @dev Copies the balance of a single addresses from the legacy contract
319     * @param _holder Address to migrate balance
320     * @return True if balance was copied, false if was already copied or address had no balance
321     */
322   function migrateBalance(address _holder) onlyOwner beforeInitialized returns (bool) {
323     if (balances[_holder] > 0) {
324       return false; // Already copied, move on
325     }
326 
327     uint256 amount = legacyRepContract.balanceOf(_holder);
328     if (amount == 0) {
329       return false; // Has no balance in legacy contract, move on
330     }
331 
332     balances[_holder] = amount;
333     totalSupply = totalSupply.add(amount);
334     Migrated(_holder, amount);
335 
336     if (targetSupply == totalSupply) {
337       endInitialization();
338     }
339     return true;
340   }
341 
342   /**
343     * @dev Unpauses the contract with the caveat added that it can only happen after initialization.
344     */
345   function unpause() onlyOwner whenPaused afterInitialized returns (bool) {
346     super.unpause();
347     return true;
348   }
349 }